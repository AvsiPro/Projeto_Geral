#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JUBRF201  ³ Autor ³ Rodrigo Barreto      ³ Data ³02/06/2022 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Vendas                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function JUBRF201

	Local oReport
	Local nCusProd := 0
	Local cNumNf	:= ""
	Local cFilDoc  	:= ""
	Local nValor := 0
	Local cNome := ""
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
	Local oCell
	Local oBreak
	Local cTitle := "Relatório de Lucro"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01    Data De                                          ³
	//³ mv_par02    Data Ate                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte("JUBRF201",.F.)

	oReport := TReport():New("JUBRF201",cTitle,If(lAuto,Nil,"JUBRF201"), {|oReport| ReportPrint(oReport)},"")
	oReport:SetLandscape()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                                ³
	//³                                                                        ³
	//³TRCell():New                                                            ³
	//³ExpO1 : Objeto TSection que a secao pertence                            ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
	//³ExpC3 : Nome da tabela de referencia da celula                          ³
	//³ExpC4 : Titulo da celula                                                ³
	//³        Default : X3Titulo()                                            ³
	//³ExpC5 : Picture                                                         ³
	//³        Default : X3_PICTURE                                            ³
	//³ExpC6 : Tamanho                                                         ³
	//³        Default : X3_TAMANHO                                            ³
	//³ExpL7 : Informe se o tamanho esta em pixel                              ³
	//³        Default : False                                                 ³
	//³ExpB8 : Bloco de código para impressao.                                 ³
	//³        Default : ExpC2                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:= TRSection():New(oReport,"Supplier",{"TRB"},/*aOrdem*/)
	oSection1:SetHeaderPage()
	// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao

	//Nro_Pedido,Nro_NFE,Cliente,Vendedor, Tt_Produtos, Desconto, Acresc, Tt_Bruto, Tt_ST, Tt_Ipi, Tt_FCPST, Tt_Pedido


	TRCell():New(oSection1,"FILIAL","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"COD_CLIENTE","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_CLIENTE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"LOJA_CLIENTE","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_LOJA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"NOME_CLIENTE","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_XRAZAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"NUM_PEDOK","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_XIDPOK")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"NUMERO_NF","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_DOC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"NUM_PEDIDO","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_PEDIDO")[1],/*lPixel*/, /**/ )
	TRCell():New(oSection1,"NOME_VEND","TRB",/*Titulo*/,/*Picture*/,TamSX3("A3_NREDUZ")[1],/*lPixel*/, /**/ )
	TRCell():New(oSection1,"DATA_EMISSAO","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"QUANTIDADE"	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D2_QUANT")[1],/*lPixel*/)
	TRCell():New(oSection1,"CUSTO_TOTAL" 	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("B1_CUSTD")[1],/*lPixel*/)
	TRCell():New(oSection1,"TOTAL","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/)
	TRCell():New(oSection1,"VALOR_ICMS","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_VALMERC")[1],/*lPixel*/)
	TRCell():New(oSection1,"SEGURO","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_SEGURO")[1],/*lPixel*/)

	oBreak := TRBreak():New(oSection1,oSection1:Cell("DATA_EMISSAO"),"Sub-Total")

	TRFunction():New(oSection1:Cell("QUANTIDADE"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("CUSTO_TOTAL"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("TOTAL"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("VALOR_ICMS"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
	TRFunction():New(oSection1:Cell("SEGURO"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)

	/*
	TRFunction():New(oSection1:Cell("Tt_Produtos"),"TOTAL_PRODUTOS","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
	TRFunction():New(oSection1:Cell("Desconto"),"TOTAL_DESCONTOS","SUM",,,"@E 99,999,999.99",,.F.,.T.,,oSection1)
	//TRFunction():New(oSection1:Cell("Total_Bruto"),"TOTAL_COM_IMPOSTOS","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
	TRFunction():New(oSection1:Cell("Total_ST"),"TOTAL_ST","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
	TRFunction():New(oSection1:Cell("Total_IPI"),"TOTAL_IPI","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
	//TRFunction():New(oSection1:Cell("Total_FCP_ST"),"TOTAL_FCP_ST","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
	TRFunction():New(oSection1:Cell("Vlr_Pedido"),"TOTAL_PRODUTOS","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
	*/
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
	Local _aDados	:=	{}
	//Local dAuxDt	:=	ctod('//')
	Local cCondPag	:=	""

	cQuery := " SELECT DISTINCT SUM(B1_CUSTD) AS CUSTO_TOTAL,SUM(D2_QUANT) AS QUANTIDADE, SUM(D2_TOTAL) AS TOTAL, D2_FILIAL as FILIAL,"
	cQuery += " D2_CLIENTE AS COD_CLIENTE, D2_LOJA AS LOJA_CLIENTE,C5_XRAZAO AS NOME_CLIENTE,"
	cQuery += " C5_XIDPOK AS NUM_PEDOK, A3_NREDUZ AS NOME_VEND,D2_DOC AS NUMERO_NF,D2_SERIE AS SERIE_NF,"
	cQuery += " D2_PEDIDO AS NUM_PEDIDO,C5_VEND1 AS COD_VEND,D2_EMISSAO AS DATA_EMISSAO,F2_VALICM AS VALOR_ICMS, F2_SEGURO AS SEGURO  "
	cQuery += " FROM "+RetSQLName("SD2")+" D2"

	cQuery += "		INNER JOIN "+RetSQLName("SC5")+" C5"
	cQuery += "		ON C5_FILIAL = D2_FILIAL"
	cQuery += "		AND C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE AND C5_LOJACLI = D2_LOJA AND C5.D_E_L_E_T_=''"

	cQuery += "		INNER JOIN "+RetSQLName("SF2")+" F2"
	cQuery += "		ON F2_FILIAL=D2_FILIAL AND F2_DOC = D2_DOC AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2.D_E_L_E_T_=''"

	cQuery += "		INNER JOIN "+RetSqlName("SB1")+" B1
	cQuery += "		ON B1_FILIAL= '"+xFilial("SB1")+"' AND B1_COD = D2_COD AND B1.D_E_L_E_T_=''"

	cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A3 ON"
	cQuery += " A3_FILIAL ='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"

	cQuery += " WHERE D2.D_E_L_E_T_=''"
	cQuery += " AND D2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += " AND D2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
	cQuery += " AND D2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
	cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR07)+"' AND '"+dtos(MV_PAR08)+"'"

	cQuery += "	Group by D2_FILIAL,D2_CLIENTE, D2_LOJA,C5_XRAZAO,C5_XIDPOK,D2_DOC,D2_PEDIDO,C5_VEND1,D2_EMISSAO, F2_VALICM,A3_NREDUZ,D2_SERIE,F2_SEGURO"
	cQuery += " ORDER BY D2_FILIAL, D2_EMISSAO"

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

	
	While !oReport:Cancel() .And. !TRB->(Eof())
		cNome := POSICIONE("SA1",1,XFILIAL("SA1")+TRB->COD_CLIENTE+TRB->LOJA_CLIENTE,"A1_NOME")     
		cNumNf := TRB->NUMERO_NF
		cFilDoc := TRB->FILIAL

		oSection1:Cell(TRB->FILIAL)
		oSection1:Cell(TRB->COD_CLIENTE)
		oSection1:Cell(TRB->LOJA_CLIENTE)
		oSection1:Cell(cNome)
		oSection1:Cell(TRB->NUM_PEDOK)
		oSection1:Cell(TRB->NUMERO_NF)
		oSection1:Cell(TRB->NUM_PEDIDO)
		oSection1:Cell(TRB->NOME_VEND)
		oSection1:Cell("DATA_EMISSAO"):SetValue(stod(TRB->DATA_EMISSAO))
		oSection1:Cell(TRB->QUANTIDADE)
		
		nValor := u_SomaCus(cNumNf,cFilDoc)

		oSection1:Cell(nValor)

		oSection1:Cell(TRB->TOTAL)
		oSection1:Cell(TRB->VALOR_ICMS)
		oSection1:Cell(TRB->SEGURO)

		oReport:IncMeter()

		If oReport:Cancel()
			Exit
		EndIf

		/*	If cCondPag <> Alltrim(TRB->Tab_Preco)
			oReport:ThinLine()
			cCondPag := Alltrim(TRB->Tab_Preco)
		EndIf
		*/
		oSection1:PrintLine()

		dbSelectArea("TRB")
		dbSkip()
	EndDo

	oSection1:Finish()
	oReport:EndPage()

Return Nil

User function SomaCus(cNumNf,cFilDoc)

	Local cQuery2 	:= ""
	Local nValor := 0

	cQuery2 := "SELECT B1_COD, B1_CUSTD, D2_QUANT FROM "+RetSQLName("SD2")+" D2"
	cQuery2 += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = D2_COD AND B1.D_E_L_E_T_=''"
	cQuery2 += " WHERE D2_DOC = '" + cNumNf +"' AND D2_FILIAL ='"+ cFilDoc +"' and D2.D_E_L_E_T_=''"

	If Select('TRC') > 0
		dbSelectArea('TRC')
		dbCloseArea()
	EndIf

	cQuery2 := ChangeQuery(cQuery2)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery2),"TRC",.F.,.T.)

	dbSelectArea("TRC")

	//oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})

	//oReport:SetMeter(TRB->(LastRec()))
	dbSelectArea("TRC")
	Dbgotop()
	//oSection1:Init()

	//dAuxDt := stod(TRB->EMISSAO)
	//cCondPag := Alltrim(TRB->Tab_Preco)

	While !TRC->(Eof())
		
		nValor += TRC->D2_QUANT * TRC->B1_CUSTD

		dbSelectArea("TRC")
		dbSkip()
	EndDo

Return (nValor)
