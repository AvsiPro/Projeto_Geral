#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKMEX    �Autor  �Jackson E. de Deus  � Data �  10/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado antes do cancelamento do atendimento.          ���
���          �Utilizado para bloquear o cancelamento de OMM de instalacao ���
���          �caso ja exista pedido de venda e/ou nota fiscal.			  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �10/10/13�01.01 |Criacao                                 ���
���Jackson       �19/05/14�01.02 |Ajuste no cancelamento da OMM			  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TMKMEX()

Local cNumTmk	:= SUC->UC_CODIGO
Local cCodCli	:= SubStr(SUC->UC_CHAVE,1,6)
Local cLoja		:= SubStr(SUC->UC_CHAVE,7)                
Local cAssOMM	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK002",.T.,""),"")	// assunto OMM
Local cOcorrIns	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK003",.T.,""),"")	// ocorrencia de instalacao
Local cOcorrRem	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK004",.T.,""),"")	// ocorrencia de remocao
Local aArea		:= GetArea() 
Local aItens	:= {}
Local nI
Local cMensagem := ""
Local nRecno	:= 0
Local lPed		:= .F.
Local lNf		:= .F.
// TRATAR A DEVOLUCAO QUANDO AS MAQUINAS NAO FOREM INSTALADAS - NESSE CASO SE HOUVER A DEVOLUCAO DEIXAR CANCELAR

If cEmpAnt == "01"
	
	/*
	//����������������������������������������������5qT��T���
	//�Bloquear o cancelamento nos seguintes casos:�
	//�Atendimento de OMM - instalacao             �
	//�Pedido de venda gerado                      �
	//�Nota fiscal gerada                          �
	//�Patrimonio empenhado                        �
	//�Patrimonio em transito                      �
	//����������������������������������������������5qT��T���
	*/
	dbSelectArea("SUD")
	dbSetOrder(1)
	If dbSeek(xFilial("SUD")+cNumTmk)
		// A validacao deve ser somente para atendimentos de OMM, outros atendimentos podem ser cancelados
		If SUD->UD_ASSUNTO <> cAssOMM 
			Return .T.
		EndIf
		
		While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
			aItens := {}
			/*
			//������������������������������������������������������Ŀ
			//�Tratamento para OMM de instalacao                     �
			//�Caso exista Pedido ou Nota Fiscal, nao deixar cancelar�
			//��������������������������������������������������������
			*/
			If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrIns
				If !Empty( SUD->UD_XNPATRI )
				
					lPed := .F.
					lNf := .F.
				
					dbSelectArea("SN1")
					nRecno := U_TTTMKA19(SUD->UD_XNPATRI)
					If nRecno > 0
						SN1->( dbGoTo(nRecno) )
						 // esta empenhado/em transito
						If AllTrim(SN1->N1_XSTATTT) $ "2|5"
							// verifica existencia de pedido / nota fiscal
							If !Empty( SUD->UD_VENDA )
								dbSelectArea("SC5")
								dbSetOrder(1) //filial + pedido
								If dbSeek( xFilial("SC5") +AvKey(SUD->UD_VENDA, "C5_NUM") )
									If !"XXX" $ SC5->C5_NOTA
										lPed := .T.
										dbSelectArea("SC6")
										dbSetOrder(1)	// pedido item produto
										If dbSeek( xFilial("SC6") +AvKey(SUD->UD_VENDA, "C6_NUM") +AvKey(SUD->UD_ITEMVDA, "C6_ITEM") +AvKey(SUD->UD_PRODUTO, "C6_PRODUTO") ) 
											If !Empty(SC6->C6_NOTA) .And. !Empty(SC6->C6_SERIE)
												dbSelectArea("SF2")
												dbSetOrder(2)	// CLIENTE LOJA NF SERIE
												If dbSeek( xFilial("SF2") +AvKey(cCodCli,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(SC6->C6_NOTA,"F2_DOC") +AvKey(SC6->C6_SERIE,"F2_SERIE") )
													lNf := .T.
												EndIf      
											EndIf
										EndIf
									EndIf		
								EndIf												
							EndIf    
							
							If lPed .Or. lNf
								AADD( aItens, {SUD->UD_XNPATRI,;	//[1] Patrimonio
												SUD->UD_VENDA,;		//[2] Pedido
												SN1->N1_XSTATTT,;	//[3] Status
												SF2->F2_DOC,;		//[4] Nota		
												SN1->N1_DESCRIC})	//[5] Descricao
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf	             
			SUD->(dbSkip())
		End While
		
	
		If Len(aItens) > 0
			cMensagem := "A OMM de instala��o n�o pode ser cancelada nas seguintes situa��es:" +CRLF
			cMensagem += "Quando houver pedido de venda gerado ou nota fiscal gerada." +CRLF +CRLF
			
			For nI := 1 To Len(aItens)
				cMensagem += "Patrim�nio: " +aItens[nI][1] +"-" +aItens[nI][5] +CRLF
				cMensagem += "Status: " +IIF(aItens[nI][3]=="2","Empenhado","Em tr�nsito") +CRLF
				cMensagem += "Pedido: " +aItens[nI][2] +CRLF
					
				If !Empty( aItens[nI][4] ) 
					cMensagem += "Nota Fiscal: " +aItens[nI][4] +CRLF		
				EndIf
				cMensagem += CRLF +CRLF
			Next nI
			
			Aviso("TMKMEX",cMensagem,{"Ok"},3)	 
		EndIf
	EndIf
EndIF
	
RestArea(aArea)

Return .T.