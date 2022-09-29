#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100AGR �Autor  �Bruno Daniel Borges � Data �  05/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos a entrada da NF de devolucao para in- ���
���          �cluir movimento de estorno do saldo em estoque de distrib.  ���
�������������������������������������������������������������������������͹��
���Hist.     �			�Autor	�Jackson E. de Deus	� Data �	06/03/13  ���
���          � Alterado para gerar pedido de venda de descarte caso a NF  ���
���			 � seja de devolu��o e utilizar as TES de descarte			  ���
�������������������������������������������������������������������������͹��
���Hist.     �			�Autor	�Jackson E. de Deus	� Data �	12/08/13  ���
���          � Enviar email quando os produtos entregues estiverem com    ���
���			 � quantidade inferior ao da nota fiscal.					  ���
�������������������������������������������������������������������������͹��
���Uso       � Toktake                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT100AGR()

Local aAreaBKP := GetArea()
Local aMata240 := {}    
Local cTM      := If(cEmpAnt == "01",GetMv("MV_XTMENT",,"501"),"")
Local lPVDesc  := If(cEmpAnt == "01",SuperGetMV("MV_XPVDATV",.T.,.F.),"")	// variavel logica para controle da geracao do pedido de descarte
Local lAtvMail := If(cEmpAnt == "01",SuperGetMV("MV_XNDV003",.T.,.F.),"")	// ativa o envio de email quando houver quantidade divergente na classificacao da nf 
Local lOkField := .F.								// variavel logica para controle da existencia de campo customizado
Local lDiver   := .F.								// variavel logica para controle da existencia de divergencia na quantidade
Local lNovoProc := If(cEmpAnt == "01",SuperGetMV("MV_XLOG012",.T.,.F.),"")	// controle do descarte no novo processo de abastecimento


If cEmpAnt == "01"
	/*------------------------------------------------------+
	| movimento de estorno do saldo em estoque de distrib	|
	+------------------------------------------------------*/     
	//Tratamento na inclusao e classificacao
	If l103Class .Or. INCLUI
		If SF1->F1_TIPO == "D"
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ))
			While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) ==xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
				dbSelectArea("SD2")
				SD2->(dbSetOrder(3))
				SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI ))
				
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO ))
				
				If !Empty(SC5->C5_XCODPA) .AND. SC5->C5_XNFABAS == "1"
					// PA - ROTA BAIXA DIRETO DA ROTINA DO FECHAMENTO - TTPROC57
					If SubStr(SC5->C5_XCODPA,1,1) == "P"
						aMata240 := {}
						aAdd(aMata240, {'D3_TM'     ,cTM			 ,Nil})
						aAdd(aMata240, {'D3_COD'    ,SD1->D1_COD    ,Nil})
						aAdd(aMata240, {'D3_UM'     ,SD1->D1_UM     ,Nil})
						aAdd(aMata240, {'D3_QUANT'  ,SD1->D1_QUANT  ,Nil})
						aAdd(aMata240, {'D3_LOCAL'  ,SC5->C5_XCODPA ,Nil})
						aAdd(aMata240, {'D3_EMISSAO',SD1->D1_EMISSAO,Nil})
						aAdd(aMata240, {'D3_DOC'    ,SD1->D1_DOC    ,Nil})
						aAdd(aMata240, {'D3_CONTA'  ,SD1->D1_CONTA  ,Nil})
						aAdd(aMata240, {'D3_CC'     ,SD1->D1_CC     ,Nil})
						aAdd(aMata240, {'D3_CLVL'   ,SD1->D1_CLVL   ,Nil})
						aAdd(aMata240, {'D3_ITEMCTA',SD1->D1_ITEMCTA,Nil})
						aAdd(aMata240, {'D3_XORIGEM',"MT100AGR"	     ,Nil})
						                                               
						lMsErroAuto := .F.
						MSExecAuto({|x,y| Mata240(x,y)},aMata240,3)
						If lMsErroAuto
							MostraErro()
						Else
							RecLock("SD2",.F.)
								SD2->D2_XSLDPA -= SD1->D1_QUANT // Baixa o valor do saldo.
							MsUnLock()
						EndIf
					EndIf	 
				EndIf
			     
				SD1->(dbSkip())
			EndDo
				
		EndIf
	
	EndIf
	
	
	RestArea(aAreaBKP)
	                                                                     
	        
	
	/*
	//�����������������������Ŀ
	//�Gera Pedido de descarte�
	//�������������������������
	*/
	If INCLUI
		aAreaBKP := GetArea()		
		// Gera Pedido de Venda de Descarte caso a NF seja de devolu��o de descarte
		If lPVDesc .And. !lNovoProc
			If FindFunction("U_PVDESC")
				U_PVDESC()                 
			EndIf     
		EndIf
		RestArea(aAreaBKP)
	EndIf
	
	
	
	/*
	//������������������������������������������������������ive���� �
	//�Na classificacao da NF                               �
	//�Verifica quantidade divergente dos produtos entregues�
	//�Jackson E. de Deus - 12/08/2013                      �
	//������������������������������������������������������ive���� �
	*/
	If l103Class 
		If SF1->F1_TIPO == "N"
			aAreaBKP := GetArea()
			dbSelectArea("SD1")
			If FieldPos("D1_XCLASPN") > 0
				lOkField := .T.
			EndIf
			
			If lAtvMail .And. lOkField
				SD1->(dbSetOrder(1))
				SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ))
				While SD1->(!Eof()) .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
					If SD1->D1_QUANT <> SD1->D1_XCLASPN
						lDiver := .T.
						Exit
					EndIf
					SD1->(dbSkip())
				End
			
				dbSelectArea("SF1")
				If RecLock("SF1",.F.)
					SF1->F1_XQTDDIV := "S"
					MsUnLock()
				EndIf
				
				// Envia email para os departamentos
				If FindFunction("U_TTCOMC15") .And. FindFunction("U_TTMAILN")
					U_TTCOMC15()
				EndIf
			EndIf	
			RestArea(aAreaBKP)
		EndIf
	EndIf

EndIf

Return NIL