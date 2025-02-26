#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RRFINR5  ³ Autor ³ Rodrigo Barreto      ³ Data ³30/05/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Vendas Analitico por tab de vendas            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RRFINR5

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
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Dados para exibição                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01: nReg =                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ oExpO1: Objeto do relatorio                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local oReport
	Local oSection1
	Local cTitle := "Relatório de Vendas por Tabela de Preço"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01    Data De                                          ³
	//³ mv_par02    Data Ate                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte("RRFINR5",.F.)

	oReport := TReport():New("RRFINR5",cTitle,If(lAuto,Nil,"RRFINR5"), {|oReport| ReportPrint(oReport)},"")
	oReport:SetLandscape()

	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 9 

	oSection1:= TRSection():New(oReport,"Supplier",{"TRB"},/*aOrdem*/)
	oSection1:SetHeaderPage()
	
	TRCell():New(oSection1,"EMISSAO","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"Tab_Preco","TRB",/*Titulo*/,/*Picture*/,TamSX3("E4_CODIGO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"Nome_Tabela","TRB",/*Titulo*/,/*Picture*/,30,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"Nro_Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_NUM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"Nro_NFE","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_DOC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"COD_CLIENTE","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_CLIENTE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"RAZAO_SOCIAL","TRB",/*Titulo*/,/*Picture*/,35,/*lPixel*/, /**/ )
	TRCell():New(oSection1,"Tt_Produtos","TRB",/*Titulo*/,/*Picture*/,19,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"Desconto"   ,"TRB",/*Titulo*/,/*Picture*/,19,/*lPixel*/)
	TRCell():New(oSection1,"Total_ST"	,"TRB",/*Titulo*/,/*Picture*/,19,/*lPixel*/)
	TRCell():New(oSection1,"Total_IPI" 	,"TRB",/*Titulo*/,/*Picture*/,19,/*lPixel*/)
	TRCell():New(oSection1,"Vlr_Pedido","TRB",/*Titulo*/,/*Picture*/,19,/*lPixel*/)

	
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³11/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local cQuery 	:= ""
	Local cCondPag	:=	""
	Local nVlr01 	:=	0
	Local nVlr02 	:=	0
	Local nVlr03 	:=	0
	Local nVlr04 	:=	0
	Local nVlr05 	:=	0
	Local nTot01 	:=	0
	Local nTot02 	:=	0
	Local nTot03 	:=	0
	Local nTot04 	:=	0
	Local nTot05 	:=	0
	
	cQuery := " SELECT C5_TABELA AS Tab_Preco,DA0_DESCRI AS Nome_Tabela,"
	cQuery += " C5_EMISSAO AS EMISSAO, C5_NUM AS Nro_Pedido,"
	cQuery += " C5_CLIENTE  AS COD_CLIENTE,C5_LOJACLI,"
	//cQuery += " SUM(C6_VALOR) AS Tt_Produtos,"
	//cQuery += " SUM(C6_PRCVEN) AS PRECOVEN,"
	cQuery += " SUM(C6_PRUNIT*C6_QTDVEN) AS PREUNIT,"
	cQuery += " SUM(C6_VALDESC) AS Desconto,"
	cQuery += " SUM(C6_XVLIMP1) AS IMPST,"
	cQuery += " SUM(C6_XVLIMP2) AS IMPIPI,"
	
	cQuery += " C5_NOTA AS Nro_NFE,C5_SERIE,C5_XTOTNF,"

	cQuery += " A1_NOME AS RAZAO_SOCIAL, A1_EST AS UF,"
	cQuery += " A3_NOME AS Nome_Vendedor, C5_VEND1 "
	cQuery += " FROM "+RetSQLName("SC5")+" C5"

	cQuery += "		INNER JOIN "+RetSQLName("SC6")+" C6"
	cQuery += "		ON C6_FILIAL = C5_FILIAL"
	cQuery += "		AND C6_NUM=C5_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA "
	cQuery += "		AND C6.D_E_L_E_T_=''"

	cQuery += "		LEFT JOIN "+RetSQLName("DA0")+" DA0"
	cQuery += "		ON DA0_FILIAL = '"+xFilial("DA0")+"'"
	cQuery += "		AND DA0_CODTAB = C5_TABELA AND DA0.D_E_L_E_T_=''"

	cQuery += "		INNER JOIN "+RetSqlName("SA1")+" A1
	cQuery += "		ON A1_FILIAL= '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA
	cQuery += "		AND A1.D_E_L_E_T_=' ' AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += "		AND A1_EST BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "

	cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A3 ON"
	cQuery += " A3_FILIAL ='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
	cQuery += " AND A3_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"

	cQuery += " WHERE  C5.D_E_L_E_T_=' '"
	cQuery += " AND C5_FILIAL BETWEEN ' ' AND 'ZZ' AND C5_TABELA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR09)+"' AND '"+dtos(MV_PAR10)+"'"
	cQuery += "	GROUP BY C5_FILIAL,C5_TABELA, DA0_DESCRI, C5_EMISSAO, C5_NUM, C5_CLIENTE ,C5_LOJACLI, A1_NOME, C5_NOTA,C5_SERIE,C5_XTOTNF, A1_EST, A3_NOME, C5_VEND1"
	cQuery += " ORDER BY C5_TABELA,C5_EMISSAO"

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

	cCondPag := Alltrim(TRB->Tab_Preco)
	cNomeTab := Alltrim(TRB->Nome_Tabela)

	While !oReport:Cancel() .And. !TRB->(Eof())

		If cCondPag <> Alltrim(TRB->Tab_Preco)
			oReport:SkipLine()
			oSection1:Cell("EMISSAO"):SetValue("")
			oSection1:Cell("Tab_Preco"):SetValue(cCondPag)
			oSection1:Cell("Nome_Tabela"):SetValue(cNomeTab)
			oSection1:Cell("Nro_Pedido"):SetValue("")
			oSection1:Cell("Nro_NFE"):SetValue("")
			oSection1:Cell("COD_CLIENTE"):SetValue("")
			oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total")
			oSection1:Cell("Tt_Produtos"):SetValue(Transform(nVlr01,'@E 999,999,999.99'))
			oSection1:Cell("Desconto"):SetValue(Transform(nVlr02,'@E 999,999,999.99'))
			oSection1:Cell('Total_ST'):SetValue(Transform(nVlr03,'@E 999,999,999.99'))
			oSection1:Cell('Total_IPI'):SetValue(Transform(nVlr04,'@E 999,999,999.99'))
			oSection1:Cell('Vlr_Pedido'):SetValue(Transform(nVlr05,'@E 999,999,999.99'))
			oSection1:PrintLine()
			oReport:SkipLine()

			cCondPag := Alltrim(TRB->Tab_Preco)
			cNomeTab := Alltrim(TRB->Nome_Tabela)
			nVlr01 	:=	0
			nVlr02 	:=	0
			nVlr03 	:=	0
			nVlr04 	:=	0
			nVlr05 	:=	0
			
		EndIf 

		nVlrPv	:= 0
		nVlrIpi	:= 0
		nVlrST	:= 0

	//	If Empty(TRB->Nro_NFE)
			/*aAuxImp	 := U__VlrImp(TRB->Nro_Pedido)
			
			nVlrPv	:= aAuxImp[1,4]
			
			If nVlrpV == 0*/
				nVlrpV := TRB->PREUNIT
			//EndIf

			nVlrIpi	:= TRB->IMPIPI
			nVlrST	:= TRB->IMPST
		/*else
			aAuxImp	 := BuscVlImp(TRB->Nro_NFE,TRB->C5_SERIE)
			
			nVlrPv	:= aAuxImp[1,1]
			
			If nVlrpV == 0
				nVlrpV := TRB->PREUNIT
			EndIf

			nVlrIpi	:= aAuxImp[1,4]
			nVlrST	:= aAuxImp[1,3]
		EndIf
*/
		oSection1:Cell("EMISSAO"):SetValue(stod(TRB->EMISSAO))
		oSection1:Cell("Tab_Preco"):SetValue(TRB->Tab_Preco)
		oSection1:Cell("Nome_Tabela"):SetValue(TRB->Nome_Tabela)
		oSection1:Cell("Nro_Pedido"):SetValue(TRB->Nro_Pedido)
		oSection1:Cell("Nro_NFE"):SetValue(TRB->Nro_NFE)
		oSection1:Cell("COD_CLIENTE"):SetValue(TRB->COD_CLIENTE)
		oSection1:Cell("RAZAO_SOCIAL"):SetValue(TRB->RAZAO_SOCIAL)
		oSection1:Cell("Tt_Produtos"):SetValue(Transform(TRB->PREUNIT,'@E 999,999,999.99'))
		oSection1:Cell("Desconto"):SetValue(Transform(TRB->Desconto,'@E 999,999,999.99'))
		oSection1:Cell('Total_ST'):SetValue(Transform(nVlrST,'@E 999,999,999.99'))
		oSection1:Cell('Total_IPI'):SetValue(Transform(nVlrIpi,'@E 999,999,999.99'))
		oSection1:Cell('Vlr_Pedido'):SetValue(Transform(TRB->PREUNIT+nVlrST+nVlrIpi-TRB->Desconto,'@E 999,999,999.99'))


		nVlr01 	+=	TRB->PREUNIT
		nVlr02 	+=	TRB->Desconto
		nVlr03 	+=	nVlrST
		nVlr04 	+=	nVlrIpi
		nVlr05 	+=	TRB->C5_XTOTNF //TRB->PREUNIT+nVlrST+nVlrIpi-TRB->Desconto
		nTot01 	+=	TRB->PREUNIT
		nTot02 	+=	TRB->Desconto
		nTot03 	+=	nVlrST
		nTot04 	+=	nVlrIpi
		nTot05 	+=	TRB->C5_XTOTNF //TRB->PREUNIT+nVlrST+nVlrIpi-TRB->Desconto
		oReport:IncMeter()

		If oReport:Cancel()
			Exit
		EndIf

		oSection1:PrintLine()

		dbSelectArea("TRB")
		dbSkip()
	EndDo

	oReport:SkipLine()
	oSection1:Cell("EMISSAO"):SetValue("")
	oSection1:Cell("Tab_Preco"):SetValue(cCondPag)
	oSection1:Cell("Nome_Tabela"):SetValue(cNomeTab)
	oSection1:Cell("Nro_Pedido"):SetValue("")
	oSection1:Cell("Nro_NFE"):SetValue("")
	oSection1:Cell("COD_CLIENTE"):SetValue("")
	oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total")
	oSection1:Cell("Tt_Produtos"):SetValue(Transform(nVlr01,'@E 999,999,999.99'))
	oSection1:Cell("Desconto"):SetValue(Transform(nVlr02,'@E 999,999,999.99'))
	oSection1:Cell('Total_ST'):SetValue(Transform(nVlr03,'@E 999,999,999.99'))
	oSection1:Cell('Total_IPI'):SetValue(Transform(nVlr04,'@E 999,999,999.99'))
	oSection1:Cell('Vlr_Pedido'):SetValue(Transform(nVlr05,'@E 999,999,999.99'))
	oSection1:PrintLine()
	oReport:SkipLine()

	oReport:SkipLine()
	oSection1:Cell("EMISSAO"):SetValue("")
	oSection1:Cell("Tab_Preco"):SetValue("")
	oSection1:Cell("Nome_Tabela"):SetValue("")
	oSection1:Cell("Nro_Pedido"):SetValue("")
	oSection1:Cell("Nro_NFE"):SetValue("")
	oSection1:Cell("COD_CLIENTE"):SetValue("")
	oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total Geral")
	oSection1:Cell("Tt_Produtos"):SetValue(Transform(nTot01,'@E 999,999,999.99'))
	oSection1:Cell("Desconto"):SetValue(Transform(nTot02,'@E 999,999,999.99'))
	oSection1:Cell('Total_ST'):SetValue(Transform(nTot03,'@E 999,999,999.99'))
	oSection1:Cell('Total_IPI'):SetValue(Transform(nTot04,'@E 999,999,999.99'))
	oSection1:Cell('Vlr_Pedido'):SetValue(Transform(nTot05,'@E 999,999,999.99'))
	oSection1:PrintLine()
	oReport:SkipLine()

	oSection1:Finish()
	oReport:EndPage()

Return Nil

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
Local aRet  :=  {}
Local cQuery 

cQuery := "SELECT F2_VALMERC,F2_DESCONT,F2_ICMSRET,F2_VALIPI,F2_BSFCPST"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC='"+cNota+"' AND F2_SERIE='"+cSerNf+"' AND F2.D_E_L_E_T_=' '"

If Select('QUERY') > 0
	dbSelectArea('QUERY')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QUERY",.F.,.T.)

dbSelectArea("QUERY")

Aadd(aRet,{QUERY->F2_VALMERC,F2_DESCONT,F2_ICMSRET,F2_VALIPI})

RestArea(aArea)

Return(aRet)
