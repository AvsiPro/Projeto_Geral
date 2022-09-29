
#include 'rwmake.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M410LIOK ³ Autor ³  Marciane             ³ Data ³ 19/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nao permite inclusao de Pedido com finalidade Venda sem    ³±±
±±³          ³ informar Item Contabil e Centro de Custo                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³30/12/09 - Alterado por Cadu para nao permitir pedido de    ³±±
±±³          ³           abastecimento sem local de PA ou rota.           ³±±
±±³          ³           E tambem nao permitir C6_LOCAL vazio.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			MsgAlert("Não foi informado o Armazém de saída do produto, verifique o cadastro do item","M410LIOK")
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONTROLES DATA DE ENTREGA MINIMA                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Domingo
If Dow(ddatabase)==1
	nDiaDDE1  := ddatabase+5      //5   //3
	nDiaDDE2  := ddatabase+6      //6   //4
	// Segunda
ElseIf Dow(ddatabase)==2
	nDiaDDE1  := ddatabase+3      //3
	nDiaDDE2  := ddatabase+4      //4
	// Terça
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
	// Sábado
ElseIf Dow(ddatabase)==7
	nDiaDDE1  := ddatabase+6      //5    //4
	nDiaDDE2  := ddatabase+7      //6    //5
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONTROLES DE CLIENTES                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCli <> cCliPV
	Aviso("Gerenciamento de Pedido de Venda","Código do cliente não deve ser diferente do clódigo de cliente de entrega. Altere para continuar.",{"Ok"},,"Atenção:")
	Return .F.
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONTROLES PARA O FUNCIONAMENTO DA TES INTELIGENTE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cCliPV)
	Aviso("Gerenciamento de Pedido de Venda","Código do cliente para entrega não preenchido. Cadastre para continuar.",{"Ok"},,"Atenção:")
	Return .F.
End
If Empty(cLojPV)
	Aviso("Gerenciamento de Pedido de Venda","Loja do cliente para entrega não preenchido. Cadastre para continuar.",{"Ok"},,"Atenção:")
	Return .F.
End
If Empty(cTpCli)
	Aviso("Gerenciamento de Pedido de Venda","Tipo de cliente não definido. Cadastre para continuar.",{"Ok"},,"Atenção:")
	Return .F.
End
If Empty(cFinal)
	Aviso("Gerenciamento de Pedido de Venda","Finalidade de venda não definida. Cadastre para continuar.",{"Ok"},,"Atenção:")
	Return .F.
End


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CONTROLES TOK-TAKE FILIAL 01                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05' .OR.  SM0->M0_CODIGO=='11'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONTROLE DE TABELA DE PREÇO                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SM0->M0_CODFIL=='01'                            
	
		If lTabPreco
			If cAbast=="1" .AND. Empty(cTabela)
				MsgInfo("Quando o pedido for de [Abastecimento] é necessário que e o campo da Tabela de Preços esteja preenchida. Entre em contato com a Controladoria.","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
			If cFinal=="3" .AND. Empty(cTabela)
				MsgInfo("Quando o pedido for de [Transferência] é necessário que e o campo da Tabela de Preços esteja preenchida. Entre em contato com a Controladoria.","ATENÇÃO!!!")
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
				MsgInfo("A tabela de preço do pedido ["+cTabela+"] é divergente da tabela de preços de referência ["+cTAbVal+"] para o mês corrente. Entre em contato com a Controladoria.","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONTROLE DE FINALIDADE DE VENDA                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_FINAL  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_FINAL")
	_DUPLI  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_DUPLI")
	_ESTQ   := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_ESTQ")
	_APROV  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_APROV")
	_AFIXO  := Posicione("ZZC",1,xFilial("ZZC")+cFINAL,"ZZC_ATIVO")
	If GDFieldGet("C6_TES",n)<>'888'

		/*  Alteração realizada no dia 23/02/2017 por Ronaldo Gomes
			Solicitação da Jussara Santos dos Anjos - Na legislação não tem nenhum impedimento referente a base reduzida de imposto para Simples nacional.

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ SIMPLES NACIONAL                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cF4ICM>0 .AND. cSIMPLES=='1'
			MsgInfo("O cliente ["+cCliPV+"/"+cLojPV+"] está inscrito no SIMPLES Nacional, e A TES ["+AllTrim(GDFieldGet("C6_TES",n))+"]  tem redução de base de ICMS e não pode ser utilizada para esta operação. Por favor altere a TES ou procure o Depto. Fiscal.","ATENÇÃO!!!")
			lRet := .F.
			Return(lRet)
		End

		*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ VENDA ATIFO FIXO                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cF4ATF=='S' .AND. cF4DUP=='S'
			If _AFIXO<>'S'
				MsgInfo("A TES ["+AllTrim(GDFieldGet("C6_TES",n))+"]  atualiza o Controle de Ativo Fixo com geração de duplicata, e não pode ser utilizada com esta Finalidade de Venda ["+AllTrim(_FINAL)+"].","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
			If  AllTrim(cB1TIP)<>'AI'
				MsgInfo("O tipo do produto ["+AllTrim(cProd)+"] não é [AI], e a TES ["+AllTrim(GDFieldGet("C6_TES",n))+"] está configurada para saida de Ativo Fixo. Altere para uma TES.","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
		Else
			If _AFIXO=='S'
				MsgInfo("A TES ["+AllTrim(GDFieldGet("C6_TES",n))+"] não atualiza o Controle de Ativo Fixo ou não gera duplicata, e não pode ser utilizada com a Finalidade de Venda ["+AllTrim(_FINAL)+"].","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DUPLICATA                                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		/*If Empty(GDFieldGet("C6_CCUSTO",n))
				MsgInfo("Esta TES exige o uso do Centro de Custo, favor preencher.","ATENÇÃO!!!")
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
	| Incluído por Fabio Sales em 03/05/2012 a pedido da Tamara Orcioli no item 131 da lista de pendência para obrigar |
	| o usuário a digitar o item contábil quando a finalidade de venda for Venda PA ou Locação(Nota de débito)         |	
	\-----------------------------------------------------------------------------------------------------------------*/			
	If cFinal $ "2#8" 
		aCols[n][clItemc6]:=clItemc5
		If Empty(clItemc5)
			MsgInfo("Pedidos com a finalidade de [Venda PA] ou [Locação (Nota de débito)] devem obrigatoriamente ter o item contábil preenchido.","M410LIOK")
			lRet := .F.
			Return(lRet)
		EndIf		
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONTA CONTABIL E CENTRO DE CUSTOS                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*If SubStr(GDFieldGet("C6_CCUSTO",n),1,2)='03' .AND. Empty(GDFieldGet("C6_ITEMCC",n))
		MsgInfo("Centros de Custo que iniciam com [7] devem ter o Item Contábil preenchido.","ATENÇÃO!!!")
		lRet := .F.
		Return(lRet)
	End */
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle Grupo Pedido de Venda                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cXGPV)
		cXGPV      := cUsrPV
		M->C5_XGPV := cXGPV
	End

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle NCM                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If M->C5_XFINAL <> "T" //Serviço
		If Empty(cB1NCM)
			Aviso("Gerenciamento Fiscal","O produto ["+AllTrim(cProd)+"] não tem o NCM cadastrado, favor entrar em contato com o Depto. Fiscal. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
			lRet := .F.
		End
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Controle Fiscal                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de Data de Entrega                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(cUserPV$(cUserNF))
			If GDFieldGet("C6_LOCAL",n)<>"R"
				If GDFieldGet("C6_LOCAL",n)=="D00026"
					If Val(SubStr(TIME(),1,2))<nTimePV
						If M->C5_XDTENTR<nDiaDDE1
							Aviso("Gerenciamento de Pedido de Venda","Este pedido não pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima é ["+DTOC(nDiaDDE1)+"]. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
							lRet := .F.
						End
					Else
						If M->C5_XDTENTR<nDiaDDE2
							Aviso("Gerenciamento de Pedido de Venda","Este pedido não pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima é ["+DTOC(nDiaDDE2)+"]. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
							lRet := .F.
						End
					End
				End
				If GDFieldGet("C6_LOCAL",n)=="D00015" .AND. SubStr(GDFieldGet ("C6_PRODUTO",n),1,2)=='21'
					If Val(SubStr(TIME(),1,2))<nTimePV
						If M->C5_XDTENTR<nDiaDDE1
							Aviso("Gerenciamento de Pedido de Venda","Este pedido não pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima é ["+DTOC(nDiaDDE1)+"]. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
							lRet := .F.
						End
					Else
						If M->C5_XDTENTR<nDiaDDE2
							Aviso("Gerenciamento de Pedido de Venda","Este pedido não pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima é ["+DTOC(nDiaDDE2)+"]. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
							lRet := .F.
						End
					End
				End
				If GDFieldGet("C6_LOCAL",n)=="D00006"
					If Val(SubStr(TIME(),1,2))<nTimePV
						If M->C5_XDTENTR<nDiaDDE1
							Aviso("Gerenciamento de Pedido de Venda","Este pedido não pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima é ["+DTOC(nDiaDDE1)+"]. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
							lRet := .F.
						End
					Else
						If M->C5_XDTENTR<nDiaDDE2
							Aviso("Gerenciamento de Pedido de Venda","Este pedido não pode ser atendido com a entrega de ["+DTOC(M->C5_XDTENTR)+"] a data minima é ["+DTOC(nDiaDDE2)+"]. Inclusão/Alteração não permitida.",{"Ok"},,"Atenção:")
							lRet := .F.
						End
					End
				End
			End
		End
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle de Alteração da Quantidade e Data de Entrega                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(cUserPV$(cUserNF))
			If !(AllTrim(cXGPV)$'PRO-A#PRO-C#QLD#TEC')
				If SubStr(GDFieldGet ("C6_PRODUTO",n),1,1)=='2'
					If GDFieldGet("C6_LOCAL",n)=="D00006" .OR. GDFieldGet("C6_LOCAL",n)=="D00015" .OR. GDFieldGet("C6_LOCAL",n)=="D00026"
						If Val(SubStr(TIME(),1,2))<nTimePV
							If  M->C5_XDTENTR<nDiaDDE1
								If ALTERA
									If GDFieldGet("C6_XQTDORI",n)<>GDFieldGet("C6_QTDVEN",n)
										AVISO("Controle de Quantidade","A quantidade original não pode ser alterada.",{"Ok"},,"Atenção:")
										lRet := .F.
									End
								End
								If ALTERA
									If GDFieldGet("C6_XPRDORI",n)<>GDFieldGet("C6_PRODUTO",n)
										AVISO("Controle de Produto","O produto original não pode ser alterada.",{"Ok"},,"Atenção:")
										lRet := .F.
									End
								End
							End
						Else
							If  M->C5_XDTENTR<nDiaDDE2
								If ALTERA
									If GDFieldGet("C6_XQTDORI",n)<>GDFieldGet("C6_QTDVEN",n)
										AVISO("Controle de Quantidade","A quantidade original não pode ser alterada.",{"Ok"},,"Atenção:")
										lRet := .F.
									End
								End
								If ALTERA
									If GDFieldGet("C6_XPRDORI",n)<>GDFieldGet("C6_PRODUTO",n)
										AVISO("Controle de Produto","O produto original não pode ser alterada.",{"Ok"},,"Atenção:")
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
		| Condição incluída por Fábio Sales em 15/05/2012 para passar pela validação abaixo somente se a TES movimentar estoque|
		\---------------------------------------------------------------------------------------------------------------------*/                   
		If cF4EST=="S" 
		
		/*--------------------------------------------------------------------------------------------------------------------------\
		|comentado por Fabio Sales em 24/04/2012 pois as validações dos grupo FAB,KIT e PE serão as mesmas com relação aos armazens |
		\---------------------------------------------------------------------------------------------------------------------------/
		|	If AllTrim(cXGPV)$('PE')                                                                                                |
		|		If !(GDFieldGet("C6_LOCAL",n)=="D00001" .OR. GDFieldGet("C6_LOCAL",n)=="D00006" .OR. GDFieldGet("C6_LOCAL",n)=="D00026" .OR. GDFieldGet("C6_LOCAL",n)=="D00036" .OR. SubStr(GDFieldGet("C6_LOCAL",n),1,2)=="PE")
		|			Aviso("Controle de Armazem","O grupo ["+AllTrim(cXGPV)+"] não pode movimentar o armazem ["+GDFieldGet("C6_LOCAL",n)+"]. Movimentação não permitida.",{"Ok"},,"Atenção:")
		|			lRet := .F.                                                                                                     |
		|		End                                                                                                                 |
		|	End                                                                                                                     |
		\--------------------------------------------------------------------------------------------------------------------------*/ 
			If AllTrim(cXGPV)$('QLD')
				If !(GDFieldGet("C6_LOCAL",n)=="D00016")
					Aviso("Controle de Armazem","O grupo ["+AllTrim(cXGPV)+"] não pode movimentar o armazem ["+GDFieldGet("C6_LOCAL",n)+"]. Movimentação não permitida.",{"Ok"},,"Atenção:")
					lRet := .F.
				End
			End 
		EndIf
	EndIf
Endif 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aviso de Falta de Estoque                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cF4EST=="S"
	cMsg1 := AllTrim(cProd)+"-"+cNom+"   | Disp.: "+Str(nSat-nRes)+" | Qtd Solc.: "+Str(nQtd)
	If (nSat-nRes) < nQtd
		AVISO("Estoque Insuficiente",cMsg1,{"OK"},1)
	Endif
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Centro de Custo e Item Contabil                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If M->C5_XFINAL=="1" .and. Empty(cCC)
/*If M->C5_XFINAL $ "1#2" .and. Empty(cCC) //Tipo de Venda - Exigir Pedido de Venda
	Aviso("Verificação C.Custo","Pedido com Finalidade de Venda. Favor informar o Centro de Custo.",{"Ok"},,"Atenção:")
	lRet := .F.
EndIf */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Pedidos de Abastecimento                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Alterado por Cadu em 30/12/09
If M->C5_TIPO == "N"
	//Nao permitr pedido de abastecimento sem local de estoque.
	If M->C5_XNFABAS == "1" .and. Empty(M->C5_XCODPA)
		Aviso("Verificação Abastecimento.","Pedido de abastecimento, favor informar o local de estoque no cabeçalho do pedido de venda.",{"Ok"},,"Atenção:")
		lRet := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Credito p/ o Abastecimento                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->C5_XNFABAS == "1"
	If U_TTBLQABA(M->C5_XCODPA)
		Aviso("Verificação Abastecimento - Crédito","Este abastecimento está bloqueado por crédito, favor procurar o Ctas. a Receber.",{"Ok"},,"Atenção:")
		lRet := .F.
	End
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Armazens                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If Empty(GDFieldGet("C6_LOCAL",n))
	Aviso("Armazem.","Armazem em branco. Favor verificar.",{"Ok"},,"Atenção:")
	lRet := .F.
EndIf*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controle de Pedidos de Transferencia                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Alterado por Cadu em 28/01/10
If M->C5_XFINAL == "3" //Transferencia
	//Nao permitr pedido de transferencia sem filial de destino
	If Empty(M->C5_XFLDEST)
		Aviso("Verificação Transferencia.","Pedido de transferencia, favor informar a filial de destino no cabeçalho do pedido de venda.",{"Ok"},,"Atenção:")
		lRet := .F.
	Else
		//Verifico se o cliente informado esta cadastrado como fornecedor
		cCgc := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_CGC")
		dbSelectArea("SA2")
		aAreaSA2 := SA2->(GetArea())
		dbSetOrder(3)
		If !dbSeek(xFilial("SA2")+cCgc)
			Aviso("Verificação Transferencia.","Para nota de transferencia o cliente deverá estar cadastrado como fornecedor também. Favor verificar.",{"Ok"},,"Atenção:")
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