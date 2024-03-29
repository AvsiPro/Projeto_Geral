
#include 'rwmake.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � M410LIOK � Autor �  Marciane             � Data � 19/11/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Nao permite inclusao de Pedido com finalidade Venda sem    ���
���          � informar Item Contabil e Centro de Custo                   ���
�������������������������������������������������������������������������Ĵ��
���Observacao�30/12/09 - Alterado por Cadu para nao permitir pedido de    ���
���          �           abastecimento sem local de PA ou rota.           ���
���          �           E tambem nao permitir C6_LOCAL vazio.            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M410LIOK()

Local lRet      := .T.
Local dEmissao  := M->C5_EMISSAO
Local cXGPV     := ""	//M->C5_XGPV
Local cCli      := M->C5_CLIENTE
Local cCliPV    := M->C5_CLIENT
Local cLojPV    := M->C5_LOJAENT
Local cTpCli    := M->C5_TIPOCLI
Local cAbast    := ""	//M->C5_XNFABAS
Local cFinal    := ""	//M->C5_XFINAL
Local cTIPO     := M->C5_TIPO
Local cTabela   := M->C5_TABELA
Local clItemc5  := ""	//M->C5_XITEMCC 
Local cTabVal   := ""
Local cUsrPV    := ""	//U_TTUSRGPV()
Local nTimePV   := 0	//SuperGetMV("MV_XTIMEPV")
Local lTabPreco := .F.	//SuperGetMV("MV_XTABELA")
Local cProd     := GDFieldGet("C6_PRODUTO",n)
Local nQtd      := GDFieldGet("C6_QTDVEN",n)
Local cLc       := GDFieldGet("C6_LOCAL",n)
Local cCC       := GDFieldGet("C6_CCUSTO",n)
Local dEntre    := GDFieldGet("C6_ENTREG",n)
Local cBlq      := GDFieldGet("C6_BLQ",n)
Local cTes      := GDFieldGet("C6_TES",n)
Local cItemCc   := GDFieldGet("C6_ITEMCC",n)
Local cB1PIS    := ""	//GetAdvFval("SB1","B1_XPISCOF",xFilial("SB1")+cProd,1)
Local cB1TIP    := GetAdvFval("SB1","B1_TIPO"   ,xFilial("SB1")+cProd,1)
Local cNom      := GetAdvFval("SB1","B1_DESC" ,xFilial("SB1")+cProd,1)
Local nConv     := GetAdvFval("SB1","B1_CONV"  ,xFilial("SB1")+cProd,1)
Local cB1NCM    := GetAdvFval("SB1","B1_POSIPI"  ,xFilial("SB1")+cProd,1)
Local cTpCpnv   := GetAdvFval("SB1","B1_TIPCONV",xFilial("SB1")+cProd,1)
Local cOrigem   := GetAdvFval("SB1","B1_ORIGEM",xFilial("SB1")+cProd,1)
Local nSat      := GetAdvFval("SB2","B2_QATU" ,xFilial("SB2")+cProd+cLc,1)
Local nRes      := GetAdvFval("SB2","B2_RESERVA" ,xFilial("SB2")+cProd+cLc,1)
Local cF4PIS    := GetAdvFval("SF4","F4_PISCOF" ,xFilial("SF4")+cTes,1)
Local cF4DUP    := GetAdvFval("SF4","F4_DUPLIC" ,xFilial("SF4")+cTes,1)
Local cF4EST    := GetAdvFval("SF4","F4_ESTOQUE",xFilial("SF4")+cTes,1)
Local cF4ICM    := GetAdvFval("SF4","F4_BASEICM",xFilial("SF4")+cTes,1)
Local cF4ATF    := GetAdvFval("SF4","F4_ATUATF" ,xFilial("SF4")+cTes,1)
Local cRazao    := GetAdvFval("SA1","A1_NOME" ,xFilial("SA1")+cCliPV+cLojPV,1)
Local cSIMPLES  := GetAdvFval("SA1","A1_SIMPLES",xFilial("SA1")+cCliPV+cLojPV,1)
Local cEPP      := IIF('EPP'$cRazao,'S','N')
Local cGPV      := ""	//GDFieldGet("C6_XGPV",n)
Local n_PosTES  := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_TES"})
Local n_PosCFO  := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_CF"})
Local n_PosOPE  := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_OPER"})
Local n_PosCST  := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_CLASFIS"})
Local clitemc6  := Ascan(aHeader,{|x|AllTrim(x[2])=="C6_ITEMCC"})
Local cUserPV   := Upper(AllTrim(cusername))
Local cUserNF   := ""	//AllTrim(SuperGetMv("MV_XUSRNFS"))
Local cTESPC    := ""	//AllTrim(SuperGetMv("MV_XNFSNPC"))
Local cOpera    := ''
Local cEstoque  := ''
Local cTipTab   := ''
Local nQtdSegR  := 0
Local nQtdSegI  := 0
Local nDiaDDE1  := 0
Local nDiaDDE2  := 0
Local _FINAL := Space(1)
Local _DUPLI := Space(1)
Local _ESTQ  := Space(1)
Local _APROV := Space(1)
Local _AFIXO := Space(1)  
Local lEdi1	 := .F.
Local nCont	 := 0
Local cLocC6  	:= Ascan(aHeader,{|x|AllTrim(x[2])=="C6_LOCAL"})

// Tratamento para AMC
If cEmpAnt == "10" 
	// atualiza peso liquido e peso bruto
	If !aCols[n,len(aHeader)+1]
		If Empty(aCols[n,cLocC6])
			MsgAlert("N�o foi informado o Armaz�m de sa�da do produto, verifique o cadastro do item","M410LIOK")
			lRet :=	.F.
		EndIf
	EndIf
	U_TTFAT04C()   
	Return .T.
EndIf


cXGPV     := M->C5_XGPV
cAbast    := M->C5_XNFABAS
cFinal    := M->C5_XFINAL
clItemc5  := M->C5_XITEMCC 
cUsrPV    := U_TTUSRGPV()
nTimePV   := SuperGetMV("MV_XTIMEPV")
lTabPreco := SuperGetMV("MV_XTABELA")
cB1PIS    := GetAdvFval("SB1","B1_XPISCOF",xFilial("SB1")+cProd,1)
cGPV      := GDFieldGet("C6_XGPV",n)
cUserNF   := AllTrim(SuperGetMv("MV_XUSRNFS"))
cTESPC    := AllTrim(SuperGetMv("MV_XNFSNPC"))


While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTEDI101/U_TTEDI110/CNTA120/U_TTFAT11C/U_TTEDI200/U_TTTMKA03/U_TTPROC22/U_TTPROC25/U_TTFAT21C/U_TTCNTLOC/U_TTFAT39C/U_TTPROC57"
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo

//����������������������������������������������������������������������������Ŀ
//� CONTROLES DATA DE ENTREGA MINIMA                                           �
//������������������������������������������������������������������������������
// Domingo
If Dow(ddatabase)==1
	nDiaDDE1  := ddatabase+5      //5   //3
	nDiaDDE2  := ddatabase+6      //6   //4
	// Segunda
ElseIf Dow(ddatabase)==2
	nDiaDDE1  := ddatabase+3      //3
	nDiaDDE2  := ddatabase+4      //4
	// Ter�a
ElseIf Dow(ddatabase)==3
	nDiaDDE1  := ddatabase+3       //3
	nDiaDDE2  := ddatabase+4       //4
	// Quarta
ElseIf Dow(ddatabase)==4
	nDiaDDE1  := ddatabase+5       //6   //3
	nDiaDDE2  := ddatabase+6       //7   //5
	// Quinta
ElseIf Dow(ddatabase)==5
	nDiaDDE1  := ddatabase+5      //5    //4
	nDiaDDE2  := ddatabase+6      //6    //5
	// Sexta
ElseIf Dow(ddatabase)==6
	nDiaDDE1  := ddatabase+5      //4    //4
	nDiaDDE2  := ddatabase+6      //5    //5
	// S�bado
ElseIf Dow(ddatabase)==7
	nDiaDDE1  := ddatabase+6      //5    //4
	nDiaDDE2  := ddatabase+7      //6    //5
End
//����������������������������������������������������������������������������Ŀ
//� CONTROLES DE CLIENTES                                                      �
//������������������������������������������������������������������������������
If cCli <> cCliPV
	Aviso("Gerenciamento de Pedido de Venda","C�digo do cliente n�o deve ser diferente do cl�digo de cliente de entrega. Altere para continuar.",{"Ok"},,"Aten��o:")
	Return .F.
End
//����������������������������������������������������������������������������Ŀ
//� CONTROLES PARA O FUNCIONAMENTO DA TES INTELIGENTE                          �
//������������������������������������������������������������������������������
If Empty(cCliPV)
	Aviso("Gerenciamento de Pedido de Venda","C�digo do cliente para entrega n�o preenchido. Cadastre para continuar.",{"Ok"},,"Aten��o:")
	Return .F.
End
If Empty(cLojPV)
	Aviso("Gerenciamento de Pedido de Venda","Loja do cliente para entrega n�o preenchido. Cadastre para continuar.",{"Ok"},,"Aten��o:")
	Return .F.
End
If Empty(cTpCli)
	Aviso("Gerenciamento de Pedido de Venda","Tipo de cliente n�o definido. Cadastre para continuar.",{"Ok"},,"Aten��o:")
	Return .F.
End
If Empty(cFinal)
	Aviso("Gerenciamento de Pedido de Venda","Finalidade de venda n�o definida. Cadastre para continuar.",{"Ok"},,"Aten��o:")
	Return .F.
End


//����������������������������������������������������������������������������Ŀ
//� CONTROLES TOK-TAKE FILIAL 01                                               �
//������������������������������������������������������������������������������
If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05' .OR.  SM0->M0_CODIGO=='11'
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE DE TABELA DE PRE�O                                                �
	//������������������������������������������������������������������������������
	If SM0->M0_CODFIL=='01'                            
	
		If lTabPreco
			If cAbast=="1" .AND. Empty(cTabela)
				MsgInfo("Quando o pedido for de [Abastecimento] � necess�rio que e o campo da Tabela de Pre�os esteja preenchida. Entre em contato com a Controladoria.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
			If cFinal=="3" .AND. Empty(cTabela)
				MsgInfo("Quando o pedido for de [Transfer�ncia] � necess�rio que e o campo da Tabela de Pre�os esteja preenchida. Entre em contato com a Controladoria.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
			If cAbast=="1"
				cTipTab := "A"
			Else
				IF cFinal=="3"
					cTipTab := "T"
				End
			End
			cTabVal := U_TTCODTAB(cTipTab,dEmissao)
			If cTabval<>cTabela
				MsgInfo("A tabela de pre�o do pedido ["+cTabela+"] � divergente da tabela de pre�os de refer�ncia ["+cTAbVal+"] para o m�s corrente. Entre em contato com a Controladoria.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	End
	//����������������������������������������������������������������������������Ŀ
	//� CONTROLE DE FINALIDADE DE VENDA                                            �
	//������������������������������������������������������������������������������
	_FINAL  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_FINAL")
	_DUPLI  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_DUPLI")
	_ESTQ   := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_ESTQ")
	_APROV  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_APROV")
	_AFIXO  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_ATIVO")
	If GDFieldGet("C6_TES",n)<>'888'

		/*  Altera��o realizada no dia 23/02/2017 por Ronaldo Gomes
			Solicita��o da Jussara Santos dos Anjos - Na legisla��o n�o tem nenhum impedimento referente a base reduzida de imposto para Simples nacional.

		//����������������������������������������������������������������������������Ŀ
		//� SIMPLES NACIONAL                                                           �
		//������������������������������������������������������������������������������
		If cF4ICM>0 .AND. cSIMPLES=='1'
			MsgInfo("O cliente ["+cCliPV+"/"+cLojPV+"] est� inscrito no SIMPLES Nacional, e A TES ["+AllTrim(GDFieldGet("C6_TES",n))+"]  tem redu��o de base de ICMS e n�o pode ser utilizada para esta opera��o. Por favor altere a TES ou procure o Depto. Fiscal.","ATEN��O!!!")
			lRet := .F.
			Return(lRet)
		End

		*/

		//����������������������������������������������������������������������������Ŀ
		//� VENDA ATIFO FIXO                                                           �
		//������������������������������������������������������������������������������
		If cF4ATF=='S' .AND. cF4DUP=='S'
			If _AFIXO<>'S'
				MsgInfo("A TES ["+AllTrim(GDFieldGet("C6_TES",n))+"]  atualiza o Controle de Ativo Fixo com gera��o de duplicata, e n�o pode ser utilizada com esta Finalidade de Venda ["+AllTrim(_FINAL)+"].","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
			If  AllTrim(cB1TIP)<>'AI'
				MsgInfo("O tipo do produto ["+AllTrim(cProd)+"] n�o � [AI], e a TES ["+AllTrim(GDFieldGet("C6_TES",n))+"] est� configurada para saida de Ativo Fixo. Altere para uma TES.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		Else
			If _AFIXO=='S'
				MsgInfo("A TES ["+AllTrim(GDFieldGet("C6_TES",n))+"] n�o atualiza o Controle de Ativo Fixo ou n�o gera duplicata, e n�o pode ser utilizada com a Finalidade de Venda ["+AllTrim(_FINAL)+"].","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	
		//����������������������������������������������������������������������������Ŀ
		//� DUPLICATA                                                                  �
		//������������������������������������������������������������������������������
		/*If Empty(GDFieldGet("C6_CCUSTO",n))
				MsgInfo("Esta TES exige o uso do Centro de Custo, favor preencher.","ATEN��O!!!")
				lRet := .F.
				Return(lRet)
			End*/
		//End    
	End 
	//PEDIDOS DE ABASTECIMENTO DEVEM TER O CENTRO DE LUCRO PREENCHIDO
	//SOLICITADO PELA USUARIA JULIANE NO DIA 29/03/12 - ALEXANDRE
	/*If UPPER(ALLTRIM(_FINAL)) == "ABASTECIMENTO" .AND. Empty(GDFieldGet("C6_CCUSTO",n))
		MsgInfo("Pedidos de Abastecimento devem obrigatoriamente ter o Centro de Custo preenchido.","M410LIOK")
		lRet := .F.
		Return(lRet)
	ENDIF */
	
	/*----------------------------------------------------------------------------------------------------- -----------\
	| Inclu�do por Fabio Sales em 03/05/2012 a pedido da Tamara Orcioli no item 131 da lista de pend�ncia para obrigar |
	| o usu�rio a digitar o item cont�bil quando a finalidade de venda for Venda PA ou Loca��o(Nota de d�bito)         |	
	\-----------------------------------------------------------------------------------------------------------------*/			
	If cFinal $ "2#8" 
		aCols[n][clItemc6]:=clItemc5
		If Empty(clItemc5)
			MsgInfo("Pedidos com a finalidade de [Venda PA] ou [Loca��o (Nota de d�bito)] devem obrigatoriamente ter o item cont�bil preenchido.","M410LIOK")
			lRet := .F.
			Return(lRet)
		EndIf		
	EndIf


	//����������������������������������������������������������������������������Ŀ
	//� CONTA CONTABIL E CENTRO DE CUSTOS                                          �
	//������������������������������������������������������������������������������
	/*If SubStr(GDFieldGet("C6_CCUSTO",n),1,2)='03' .AND. Empty(GDFieldGet("C6_ITEMCC",n))
		MsgInfo("Centros de Custo que iniciam com [7] devem ter o Item Cont�bil preenchido.","ATEN��O!!!")
		lRet := .F.
		Return(lRet)
	End */
	//����������������������������������������������������������������������������Ŀ
	//� Controle Grupo Pedido de Venda                                             �
	//������������������������������������������������������������������������������
	If Empty(cXGPV)
		cXGPV      := cUsrPV
		M->C5_XGPV := cXGPV
	End

	//����������������������������������������������������������������������������Ŀ
	//� Controle NCM                                                               �
	//������������������������������������������������������������������������������
	If M->C5_XFINAL <> "T" //Servi�o
		If Empty(cB1NCM)
			Aviso("Gerenciamento Fiscal","O produto ["+AllTrim(cProd)+"] n�o tem o NCM cadastrado, favor entrar em contato com o Depto. Fiscal. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
			lRet := .F.
		End
	End
	//����������������������������������������������������������������������������Ŀ
	//� Controle Fiscal                                            �
	//������������������������������������������������������������������������������
	cOpera := U_TTOPERA(cXGPV,cTpCli,cFinal,cEPP)
	If !Empty(cOpera) .And. !lEdi1 .AND. !"DOSE" $ Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC") .And. Alltrim(M->C5_XGPV) <> "PRO-A"
		cTES     := MaTesInt(2,cOpera,cCliPV,cLojPV,If(cTipo$'DB',"F","C"),cProd,"C6_TES")
		aCols[n][n_PosTES]  := cTes
	End
	If !Empty(aCols[n][n_PosTES])
		RunTrigger(2,n,nil,,'C6_TES')
		If DbSeek(xFilial("SF4")+aCols[n][n_PosTES], .F.)
			cEstoque := SF4->F4_ESTOQUE
			aCols[n][n_PosCST] := cOrigem+SF4->F4_SITTRIB
		End
	End 
	If SM0->M0_CODFIL=='01'
		//����������������������������������������������������������������������������Ŀ
		//� Controle de Data de Entrega                                                �
		//������������������������������������������������������������������������������
		If !(cUserPV$(cUserNF))
			If GDFieldGet("C6_LOCAL",n)<>"R"
				If GDFieldGet("C6_LOCAL",n)=="D00026"
					If Val(SubStr(TIME(),1,2))<nTimePV
						If M->C5_XDTENTR<nDiaDDE1
							Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE1)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
							lRet := .F.
						End
					Else
						If M->C5_XDTENTR<nDiaDDE2
							Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE2)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
							lRet := .F.
						End
					End
				End
				If GDFieldGet("C6_LOCAL",n)=="D00015" .AND. SubStr(GDFieldGet ("C6_PRODUTO",n),1,2)=='21'
					If Val(SubStr(TIME(),1,2))<nTimePV
						If M->C5_XDTENTR<nDiaDDE1
							Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE1)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
							lRet := .F.
						End
					Else
						If M->C5_XDTENTR<nDiaDDE2
							Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE2)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
							lRet := .F.
						End
					End
				End
				If GDFieldGet("C6_LOCAL",n)=="D00006"
					If Val(SubStr(TIME(),1,2))<nTimePV
						If M->C5_XDTENTR<nDiaDDE1
							Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE1)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
							lRet := .F.
						End
					Else
						If M->C5_XDTENTR<nDiaDDE2
							Aviso("Gerenciamento de Pedido de Venda","Este pedido n�o pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima � ["+DTOC(nDiaDDE2)+"]. Inclus�o/Altera��o n�o permitida.",{"Ok"},,"Aten��o:")
							lRet := .F.
						End
					End
				End
			End
		End
		//����������������������������������������������������������������������������Ŀ
		//� Controle de Altera��o da Quantidade e Data de Entrega                      �
		//������������������������������������������������������������������������������
		If !(cUserPV$(cUserNF))
			If !(AllTrim(cXGPV)$'PRO-A#PRO-C#QLD#TEC')
				If SubStr(GDFieldGet ("C6_PRODUTO",n),1,1)=='2'
					If GDFieldGet("C6_LOCAL",n)=="D00006" .OR. GDFieldGet("C6_LOCAL",n)=="D00015" .OR. GDFieldGet("C6_LOCAL",n)=="D00026"
						If Val(SubStr(TIME(),1,2))<nTimePV
							If  M->C5_XDTENTR<nDiaDDE1
								If ALTERA
									If GDFieldGet("C6_XQTDORI",n)<>GDFieldGet("C6_QTDVEN",n)
										AVISO("Controle de Quantidade","A quantidade original n�o pode ser alterada.",{"Ok"},,"Aten��o:")
										lRet := .F.
									End
								End
								If ALTERA
									If GDFieldGet("C6_XPRDORI",n)<>GDFieldGet("C6_PRODUTO",n)
										AVISO("Controle de Produto","O produto original n�o pode ser alterada.",{"Ok"},,"Aten��o:")
										lRet := .F.
									End
								End
							End
						Else
							If  M->C5_XDTENTR<nDiaDDE2
								If ALTERA
									If GDFieldGet("C6_XQTDORI",n)<>GDFieldGet("C6_QTDVEN",n)
										AVISO("Controle de Quantidade","A quantidade original n�o pode ser alterada.",{"Ok"},,"Aten��o:")
										lRet := .F.
									End
								End
								If ALTERA
									If GDFieldGet("C6_XPRDORI",n)<>GDFieldGet("C6_PRODUTO",n)
										AVISO("Controle de Produto","O produto original n�o pode ser alterada.",{"Ok"},,"Aten��o:")
										lRet := .F.
									End
								End
							End
						End
					End
				End
			End
		End
		
		/*---------------------------------------------------------------------------------------------------------------------\
		| Condi��o inclu�da por F�bio Sales em 15/05/2012 para passar pela valida��o abaixo somente se a TES movimentar estoque|
		\---------------------------------------------------------------------------------------------------------------------*/                   
		If cF4EST=="S" 
		
		/*--------------------------------------------------------------------------------------------------------------------------\
		|comentado por Fabio Sales em 24/04/2012 pois as valida��es dos grupo FAB,KIT e PE ser�o as mesmas com rela��o aos armazens |
		\---------------------------------------------------------------------------------------------------------------------------/
		|	If AllTrim(cXGPV)$('PE')                                                                                                |
		|		If !(GDFieldGet("C6_LOCAL",n)=="D00001" .OR. GDFieldGet("C6_LOCAL",n)=="D00006" .OR. GDFieldGet("C6_LOCAL",n)=="D00026" .OR. GDFieldGet("C6_LOCAL",n)=="D00036" .OR. SubStr(GDFieldGet("C6_LOCAL",n),1,2)=="PE")
		|			Aviso("Controle de Armazem","O grupo ["+AllTrim(cXGPV)+"] n�o pode movimentar o armazem ["+GDFieldGet("C6_LOCAL",n)+"]. Movimenta��o n�o permitida.",{"Ok"},,"Aten��o:")
		|			lRet := .F.                                                                                                     |
		|		End                                                                                                                 |
		|	End                                                                                                                     |
		\--------------------------------------------------------------------------------------------------------------------------*/ 
			If AllTrim(cXGPV)$('QLD')
				If !(GDFieldGet("C6_LOCAL",n)=="D00016")
					Aviso("Controle de Armazem","O grupo ["+AllTrim(cXGPV)+"] n�o pode movimentar o armazem ["+GDFieldGet("C6_LOCAL",n)+"]. Movimenta��o n�o permitida.",{"Ok"},,"Aten��o:")
					lRet := .F.
				End
			End 
		EndIf
	EndIf
Endif 


//����������������������������������������������������������������������������Ŀ
//� Aviso de Falta de Estoque                                                  �
//������������������������������������������������������������������������������
If cF4EST=="S"
	cMsg1 := AllTrim(cProd)+"-"+cNom+"   | Disp.: "+Str(nSat-nRes)+" | Qtd Solc.: "+Str(nQtd)
	If (nSat-nRes) < nQtd
		AVISO("Estoque Insuficiente",cMsg1,{"OK"},1)
	Endif
EndIf 

//����������������������������������������������������������������������������Ŀ
//� Controle de Centro de Custo e Item Contabil                                �
//������������������������������������������������������������������������������
//If M->C5_XFINAL=="1" .and. Empty(cCC)
/*If M->C5_XFINAL $ "1#2" .and. Empty(cCC) //Tipo de Venda - Exigir Pedido de Venda
	Aviso("Verifica��o C.Custo","Pedido com Finalidade de Venda. Favor informar o Centro de Custo.",{"Ok"},,"Aten��o:")
	lRet := .F.
EndIf */

//����������������������������������������������������������������������������Ŀ
//� Controle de Pedidos de Abastecimento                                       �
//������������������������������������������������������������������������������
//Alterado por Cadu em 30/12/09
If M->C5_TIPO == "N"
	//Nao permitr pedido de abastecimento sem local de estoque.
	If M->C5_XNFABAS == "1" .and. Empty(M->C5_XCODPA)
		Aviso("Verifica��o Abastecimento.","Pedido de abastecimento, favor informar o local de estoque no cabe�alho do pedido de venda.",{"Ok"},,"Aten��o:")
		lRet := .F.
	EndIf
EndIf
//����������������������������������������������������������������������������Ŀ
//� Controle de Credito p/ o Abastecimento                                       �
//������������������������������������������������������������������������������
If M->C5_XNFABAS == "1"
	If U_TTBLQABA(M->C5_XCODPA)
		Aviso("Verifica��o Abastecimento - Cr�dito","Este abastecimento est� bloqueado por cr�dito, favor procurar o Ctas. a Receber.",{"Ok"},,"Aten��o:")
		lRet := .F.
	End
End
//����������������������������������������������������������������������������Ŀ
//� Controle de Armazens                                                       �
//������������������������������������������������������������������������������
/*If Empty(GDFieldGet("C6_LOCAL",n))
	Aviso("Armazem.","Armazem em branco. Favor verificar.",{"Ok"},,"Aten��o:")
	lRet := .F.
EndIf*/

//����������������������������������������������������������������������������Ŀ
//� Controle de Pedidos de Transferencia                                       �
//������������������������������������������������������������������������������
//Alterado por Cadu em 28/01/10
If M->C5_XFINAL == "3" //Transferencia
	//Nao permitr pedido de transferencia sem filial de destino
	If Empty(M->C5_XFLDEST)
		Aviso("Verifica��o Transferencia.","Pedido de transferencia, favor informar a filial de destino no cabe�alho do pedido de venda.",{"Ok"},,"Aten��o:")
		lRet := .F.
	Else
		//Verifico se o cliente informado esta cadastrado como fornecedor
		cCgc := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CGC")
		dbSelectArea("SA2")
		aAreaSA2 := SA2->(GetArea())
		dbSetOrder(3)
		If !dbSeek(xFilial("SA2")+cCgc)
			Aviso("Verifica��o Transferencia.","Para nota de transferencia o cliente dever� estar cadastrado como fornecedor tamb�m. Favor verificar.",{"Ok"},,"Aten��o:")
			lRet := .F.
		EndIf
		RestArea(aAreaSA2)
	EndIf
EndIf
 
/*------------------------------------------+
|	Atualiza Peso Liquido e Peso Bruto		|
|	Jackson E. de Deus - 08/03/13			|
+------------------------------------------*/
If !lEdi1
	U_TTFAT04C()                         
EndIf

Return (lRet)