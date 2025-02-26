#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RRFINR4  ³ Autor ³ Rodrigo Barreto      ³ Data ³30/05/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio RESUMO POR VENDEDOR                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RRFINR4

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf	

oReport:= ReportDef()
oReport:PrintDialog()
                                               
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Alexandre Venancio     ³Data  ³30/05/2020 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Dados para exibição                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01: nReg =                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oSection1   
//Local oBreak
Local cTitle := "Relatorio de Vendas Completo "

Pergunte("RRFINR4",.F.)

oReport := TReport():New("RRFINR4",cTitle,If(lAuto,Nil,"RRFINR4"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLandscape() 
oReport:cFontBody := 'Courier New' 
oReport:nFontBody := 9 

oSection1:= TRSection():New(oReport,"Supplier",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()

//Nro_Pedido,Nro_NFE,Cliente,Vendedor, Tt_Produtos, Desconto, Acresc, Tt_Bruto, Tt_ST, Tt_Ipi, Tt_FCPST, Tt_Pedido

TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Nro_Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_NUM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Nro_NFE","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_NOTA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"COD_CLIENTE","TRB",/*Titulo*/,/*Picture*/,6,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Razao_Social","TRB",/*Titulo*/,/*Picture*/,40,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Vendedor"   ,"TRB",/*Titulo*/,/*Picture*/,30,/*lPixel*/, /**/ )

TRCell():New(oSection1,"Day_of_Payment"   ,"TRB",/*Titulo*/,/*Picture*/,15,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Status"   ,"TRB",/*Titulo*/,/*Picture*/,12,/*lPixel*/, /**/ )

TRCell():New(oSection1,"Tt_Produtos","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Tt_Pedidos","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Sit_Financ","TRB",/*Titulo*/,'@!'/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Sit_Pedido","TRB",/*Titulo*/,'@!'/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³11/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
Local cQuery 	:= ""
Local dAuxDt	:=	ctod('//')
Local nTotPrd	:=	0
lOCAL nTotPFT	:=	0

/*
MV_PAR01 := CTOD('01/05/2022')
MV_PAR02 := CTOD('31/05/2022')
MV_PAR03 := ' '
MV_PAR04 := 'ZZ'
MV_PAR05 := ' '
MV_PAR06 := 'ZZ'
MV_PAR07 := ' '
MV_PAR08 := 'ZZ'
MV_PAR11 := 2
*/

cQuery := " SELECT C5_EMISSAO AS EMISSAO, C5_NUM AS Nro_Pedido, C5_NOTA AS Nro_NFE,"
cQuery += " C5_SERIE AS Serie_Nf,C5_CLIENTE AS COD_CLIENTE, C5_LOJACLI,"
cQuery += " A1_NOME AS RAZAO_SOCIAL, C5_VEND1,A3_NOME AS Vendedor, '' AS Day_of_Payment,'' AS Status,"
cQuery += " C5_FILIAL,C5_XTOTNF AS Tt_Pedidos,"
cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND D_E_L_E_T_=' ') AS Tt_Produtos"
cQuery += " FROM "+RetSQLName("SC5")+" C5"
/*cQuery += "	INNER JOIN "+RetSQLName("SC6")+" C6"
cQuery += "		ON C5_FILIAL = C6_FILIAL"
cQuery += "		AND C5_NUM = C6_NUM"
cQuery += "		AND C5.D_E_L_E_T_=' '"
*/
cQuery += "	INNER JOIN "+RetSQLName("SA1")+" A1"
cQuery += "		ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD = C5_CLIENTE"
cQuery += "		AND A1_LOJA = C5_LOJACLI"
cQuery += "		AND A1.D_E_L_E_T_=' '"
cQuery += "     AND A1_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"

cQuery += "	INNER JOIN "+RetSQLName("SA3")+" A3"
cQuery += "		ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD = C5_VEND1"
cQuery += "		AND A3.D_E_L_E_T_=' '"
cQuery += " WHERE  C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'" 
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'" 
cQuery += " AND C5_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND C5_VEND1 BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"

cQuery += " AND C5_NOTA NOT LIKE '%XX%' "

If MV_PAR11 == 2
	cQuery += " AND C5_NOTA <> ' '"
ElseIf MV_PAR11 == 3
	cQuery += " AND C5_NOTA = ' '"
EndIf 

//cQuery += " GROUP BY C6_FILIAL, C6_NUM,C5_EMISSAO,C5_NOTA, C5_VEND1,A3_NOME,A1_NOME,C5_SERIE,C5_CLIENTE,C5_LOJACLI"
cQuery += " ORDER BY  C5_EMISSAO, C5_VEND1  "

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

dAuxDt := stod(TRB->EMISSAO)

nItAtu := 1
While !oReport:Cancel() .And. !TRB->(Eof()) 
/*
	If !Empty(TRB->Nro_NFE)
		nVlrPv := BuscVlImp(TRB->Nro_NFE,TRB->Serie_Nf)
		dbSelectArea("TRB")
	Else	
		aAuxImp	 := U__VlrImp(TRB->Nro_Pedido)
		nVlrPv	:= aAuxImp[1,4]
	EndIF 
*/	
    oSection1:Cell("EMISSAO"):SetValue(stod(TRB->EMISSAO))
    oSection1:Cell(TRB->Nro_Pedido)
    oSection1:Cell(TRB->Nro_NFE)
    oSection1:Cell(TRB->COD_CLIENTE)    
	oSection1:Cell(TRB->RAZAO_SOCIAL)
	oSection1:Cell(TRB->Vendedor)
	oSection1:Cell(TRB->Day_of_Payment)
	oSection1:Cell(TRB->Status)
	
	oSection1:Cell("Tt_Produtos"):SetValue(Transform(TRB->Tt_Produtos,'@E 999,999,999.99'))
	oSection1:Cell("Tt_Pedidos"):SetValue(Transform(TRB->Tt_Pedidos,'@E 999,999,999.99'))
	
	nTotPrd += TRB->Tt_Produtos
	nTotPFT += TRB->Tt_Pedidos //nVlrPv+TRB->Tt_Produtos

	If Empty(TRB->Nro_NFE) .OR. 'XXX' $ TRB->Nro_NFE
		oSection1:Cell("Sit_Financ"):SetValue("Em Aberto")
		oSection1:Cell("Sit_Pedido"):SetValue("Em Carteira")
	else
		oSection1:Cell("Sit_Financ"):SetValue(BuscaSts(TRB->Nro_NFE,TRB->Serie_Nf))
		oSection1:Cell("Sit_Pedido"):SetValue("Faturado")
	EndIf 


	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
	dbSelectArea("TRB")
	dbSkip()
EndDo                     
	
oReport:SkipLine()
oReport:SkipLine()
oSection1:Cell("EMISSAO"):SetValue("")
oSection1:Cell("Nro_Pedido"):SetValue("")
oSection1:Cell("Nro_NFE"):SetValue("")
oSection1:Cell("COD_CLIENTE"):SetValue("")   
oSection1:Cell("RAZAO_SOCIAL"):SetValue("TOTAL GERAL")
oSection1:Cell("Vendedor"):SetValue("")
oSection1:Cell("Day_of_Payment"):SetValue("")
oSection1:Cell("Status"):SetValue("")

oSection1:Cell("Tt_Produtos"):SetValue(Transform(nTotPrd,'@E 999,999,999.99'))
oSection1:Cell("Tt_Pedidos"):SetValue(Transform(nTotPFT,'@E 999,999,999.99'))
oSection1:Cell("Sit_Financ"):SetValue("")
oSection1:Cell("Sit_Pedido"):SetValue("")

oSection1:PrintLine()

oSection1:Finish()
oReport:EndPage() 

Return Nil


/*/{Protheus.doc} BuscaSts
	(long_description)
	@type  Static Function
	@author user
	@since 29/04/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function BuscaSts(cnota,cserie)

Local aArea := GetArea()
Local cRet  := ""
Local aAux  := {}
Local nCont := 1

DbSelectArea("SE1")
DbSetOrder(1)
If Dbseek(xFilial("SE1")+cserie+cnota)
	While !EOF() .And. SE1->E1_NUM == cnota .And. SE1->E1_PREFIXO == cserie
		Aadd(aAux,{SE1->E1_PARCELA,SE1->E1_VENCREA,SE1->E1_SALDO})
		Dbskip()
	EndDo
EndIf 

For nCont := 1 to len(aAux)
	If aAux[nCont,02] < ddatabase .And. aAux[nCont,03] > 0
		cRet += "Parcela atrasada "+aAux[nCont,01]
	ElseIf aAux[nCont,02] < ddatabase .And. aAux[nCont,03] == 0
		cRet += "Pago"
	ElseIf aAux[nCont,02] > ddatabase
		cRet := "Em Aberto"
	else
		cRet := "Em Aberto"
	EndIf

Next nCont

If Empty(cRet)
	cRet := 'Em Aberto'
EndIf 

RestArea(aAreA)
	
Return(cRet)


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function _VlrImp(cPedido)

Local aArea	:=	GetArea()
Local aRet  :=  {}
Local nTotVal := 0

DbSelectArea("SC5")
DbSetOrder(1)
If Dbseek(xFilial("SC5")+cPedido)
	MaFisIni(SC5->C5_CLIENTE,;                   // 01 - Codigo Cliente/Fornecedor
					SC5->C5_LOJACLI,;                        // 02 - Loja do Cliente/Fornecedor
					Iif(SC5->C5_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
					SC5->C5_TIPO,;                           // 04 - Tipo da NF
					SC5->C5_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
					MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
					,;                                       // 07 - Tipo de complemento
					,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
					"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)

	nItAtu := 0
	nQtdEmb := 0
	nValDesc := 0

	While !EOF() .AND. SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC5->C5_NUM == SC6->C6_NUM 
		DbselectArea("SB1")
		DbSetOrder(1)
		nItAtu++
		SB1->(DbSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))
		MaFisAdd(SC6->C6_PRODUTO,;    // 01 - Codigo do Produto                    ( Obrigatorio )
			SC6->C6_TES,;             // 02 - Codigo do TES                        ( Opcional )
			SC6->C6_QTDVEN,;          // 03 - Quantidade                           ( Obrigatorio )
			SC6->C6_PRCVEN,;          // 04 - Preco Unitario                       ( Obrigatorio )
			SC6->C6_VALDESC,;         // 05 - Desconto
			SC6->C6_NFORI,;           // 06 - Numero da NF Original                ( Devolucao/Benef )
			SC6->C6_SERIORI,;         // 07 - Serie da NF Original                 ( Devolucao/Benef )
			0,;                           // 08 - RecNo da NF Original no arq SD1/SD2
			0,;                           // 09 - Valor do Frete do Item               ( Opcional )
			0,;                           // 10 - Valor da Despesa do item             ( Opcional )
			0,;                           // 11 - Valor do Seguro do item              ( Opcional )
			0,;                           // 12 - Valor do Frete Autonomo              ( Opcional )
			SC6->C6_VALOR,;           // 13 - Valor da Mercadoria                  ( Obrigatorio )
			0,;                           // 14 - Valor da Embalagem                   ( Opcional )
			SB1->(RecNo()),;              // 15 - RecNo do SB1
			0)                            // 16 - RecNo do SF4
		
		nQtdPeso := SC6->C6_QTDVEN*SB1->B1_PESO
		nQtdEmb	 := nQtdEmb + SC6->C6_UNSVEN
		nValDesc := nValDesc + SC6->C6_VALDESC
		MaFisLoad("IT_VALMERC", SC6->C6_VALOR, nItAtu)				
		MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
		DbSelectArea("SC6")
		Dbskip()
	EndDo 

	//Altera dados da Nota
	MaFisAlt("NF_FRETE", SC5->C5_FRETE)
	MaFisAlt("NF_SEGURO", SC5->C5_SEGURO)
	MaFisAlt("NF_DESPESA", SC5->C5_DESPESA) 
	MaFisAlt("NF_AUTONOMO", SC5->C5_FRETAUT)
	If SC5->C5_DESCONT > 0
		MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, SC5->C5_DESCONT+MaFisRet(, "NF_DESCONTO")) )
	EndIf
	If SC5->C5_PDESCAB > 0
		MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*SC5->C5_PDESCAB/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
	EndIf

	nItAtu := 0
	nTotalST := 0
	nTotIPI := 0
	nBasICM := 0
	nValICM := 0

	DbSelectArea("SC6")
	DbSetOrder(1)
	Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)
	While !EOF() .AND. SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC5->C5_NUM == SC6->C6_NUM 
		nItAtu++

		SB1->(DbSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))
				
		//Pega os valores
		nBasICM    += MaFisRet(nItAtu, "IT_BASEICM") 
		nValICM    += MaFisRet(nItAtu, "IT_VALICM")
		nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
		nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
		nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
		nValSol    := (MaFisRet(nItAtu, "IT_VALSOL") / SC6->C6_QTDVEN) 
		nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")
		nVlrFCP    := 0 //MaFisRef(nItAtu, "IT_FCPAUX")
		nPrcUniSol := SC6->C6_PRCVEN + nValSol
		nTotSol    := nPrcUniSol * SC6->C6_QTDVEN
		nTotalST   += MaFisRet(nItAtu, "IT_VALSOL")
		nTotIPI    += nValIPI
		DbSelectArea("SC6")
		dbskip()
	EndDo

	nTotVal := MaFisRet(, "NF_TOTAL")
	
	Aadd(aRet,{nBasICM,nTotalST,nTotIPI,nBasICM+nTotalST+nTotIPI,nVlrFCP,nTotVal})
ENDIF

RestArea(aAreA)

Return(aRet)

/*/{Protheus.doc} BuscVlImp(Nota,Serie)
	(long_description)
	@type  Static Function
	@author user
	@since 14/05/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function BuscVlImp(cNota,cSerNf)

Local aArea	:=	GetArea()
Local nRet  :=  0
Local cQuery 

cQuery := "SELECT F2_VALMERC-F2_DESCONT+F2_ICMSRET+F2_VALIPI+"
cQuery += " (SELECT SUM(D2_VFECPST) FROM "+RetSQLName("SD2")+" WHERE D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D_E_L_E_T_=' ') AS TOTAL"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC='"+cNota+"' AND F2_SERIE='"+cSerNf+"' AND F2.D_E_L_E_T_=' '"

If Select('QUERY') > 0
	dbSelectArea('QUERY')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QUERY",.F.,.T.)

dbSelectArea("QUERY")

nRet := QUERY->TOTAL

RestArea(aArea)

Return(nRet)
