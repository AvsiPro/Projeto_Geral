#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RRFINR3  ³ Autor ³ Rodrigo Barreto      ³ Data ³30/05/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Vendas Completo                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RRFINR3

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
Local cTitle := "Relatório Vendas completo"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("RRFINR3",.F.)

oReport := TReport():New("RRFINR3",cTitle,If(lAuto,Nil,"RRFINR3"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLandscape() 
oReport:cFontBody := 'Courier New' 
oReport:nFontBody := 9 

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


TRCell():New(oSection1,"EMISSAO","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Nro_Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_NUM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Nro_NFE","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_DOC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"COD_CLIENTE","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_CLIENTE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"RAZAO_SOCIAL","TRB",/*Titulo*/,/*Picture*/,30,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Nome_Vendedor","TRB",/*Titulo*/,/*Picture*/,30,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Vlr_Produtos","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Desconto"   ,"TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Total_Bruto","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Total_ST"	,"TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Total_IPI" 	,"TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Total_FCP_ST","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Vlr_Pedido","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Status","TRB",/*Titulo*/,/*Picture*/,20,/*lPixel*/,/*{|| code-block de impressao }*/)

/*
oBreak := TRBreak():New(oSection1,oSection1:Cell("Nome_Vendedor"),"Sub-Total ")

TRFunction():New(oSection1:Cell("Vlr_Produtos"),"Total Grupos","SUM",oBreak,,'@E 999,999,999,999.99',,.F.,.F.)
TRFunction():New(oSection1:Cell("Desconto"),"Total Grupos","SUM",oBreak,,'@E 999,999,999,999.99',,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_Bruto"),"Total Grupos","SUM",oBreak,,'@E 999,999,999,999.99',,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_ST"),"Total Grupos","SUM",oBreak,,'@E 999,999,999,999.99',,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_IPI"),"Total Grupos","SUM",oBreak,,'@E 999,999,999,999.99',,.F.,.F.)
TRFunction():New(oSection1:Cell("Vlr_Pedido"),"Total Grupos","SUM",oBreak,,'@E 999,999,999,999.99',,.F.,.F.)
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
Local dAuxDt	:=	ctod('//')

Local cVend 	:=	''
Local cNomVnd	:=	''
Local nVlr01	:=	0
Local nVlr02	:=	0
Local nVlr03	:=	0
Local nVlr04	:=	0
Local nVlr05	:=	0
Local nVlr06	:=	0
Local nVlr07	:=	0
Local nTot01	:=	0
Local nTot02	:=	0
Local nTot03	:=	0
Local nTot04	:=	0
Local nTot05	:=	0
Local nTot06	:=	0
Local nTot07	:=	0

Private cRet := ""

/*
MV_PAR01 := " "
MV_PAR02 := "ZZ"
MV_PAR03 := "004"
MV_PAR04 := "004"
MV_PAR05 := " "
MV_PAR06 := "ZZ"
MV_PAR07 := CTOD("01/05/2022")
MV_PAR08 := CTOD("05/05/2022")
*/

cQuery := " SELECT "
cQuery += " C5_FILIAL, C5_EMISSAO AS EMISSAO, C5_NUM AS Nro_Pedido,"
cQuery += " C5_CLIENTE  AS COD_CLIENTE,C5_LOJACLI,C5_XTOTNF,C5_XTOTFCP,"
cQuery += " SUM(C6_XVLIMP1) AS Tt_ST,"
cQuery += " SUM(C6_XVLIMP2) AS Tt_Ipi,"
cQuery += " SUM(C6_PRUNIT*C6_QTDVEN) AS PREUNIT,"
cQuery += " F2_DOC AS Nro_NFE,F2_SERIE,F2_VALMERC AS Vlr_Produtos,"
cQuery += " F2_DESCONT AS Desconto, F2_VALBRUT AS Total_Bruto,"
cQuery += " F2_ICMSRET AS Total_ST,F2_VALIPI AS Total_IPI,"
cQuery += " F2_BSFCPST AS Total_FCP_ST,"
cQuery += " A1_NOME AS RAZAO_SOCIAL, A1_EST AS UF,"
cQuery += " A3_NOME AS Nome_Vendedor, C5_VEND1"

cQuery += " FROM "+RetSQLName("SC5")+" C5"

cQuery += "		INNER JOIN "+RetSQLName("SC6")+" C6"
cQuery += " ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C6.D_E_L_E_T_=' '"

cQuery += "		INNER JOIN "+RetSQLName("SA1")+" A1"
cQuery += " ON A1_FILIAL= '"+xFilial("SA1")+"' AND C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA "
cQuery += "  AND A1.D_E_L_E_T_=' ' AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" 
cQuery += "  AND A1_EST BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " 

cQuery += "		LEFT JOIN "+RetSQLName("SA3")+" A3"
cQuery += " ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += "  AND A3_COD BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"'"  

cQuery += "		LEFT JOIN "+RetSQLName("SF2")+" F2"
cQuery += " ON F2_FILIAL = C5_FILIAL AND F2_DOC = C5_NOTA AND F2_SERIE=C5_SERIE "
cQuery += " AND F2_CLIENTE = C5_CLIENTE AND F2_LOJA = C5_LOJACLI AND F2.D_E_L_E_T_=' '"

cQuery += " WHERE "
cQuery += " C5.D_E_L_E_T_=' '"
cQuery += " AND C5_FILIAL BETWEEN ' ' AND 'ZZZ' "
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR07)+"' AND '"+dtos(MV_PAR08)+"'" 
cQuery += " GROUP BY C5_FILIAL, C5_EMISSAO, C5_NUM, C5_CLIENTE ,C5_LOJACLI,C5_XTOTNF,C5_XTOTFCP, F2_DOC, F2_SERIE, F2_VALMERC, F2_DESCONT, F2_VALBRUT, F2_ICMSRET, F2_VALIPI, F2_BSFCPST, A1_NOME, A1_EST, A3_NOME, C5_VEND1 "
cQuery += " ORDER BY C5_VEND1, C5_EMISSAO"

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
cVend  := TRB->C5_VEND1
cNomVnd := TRB->Nome_Vendedor

While !oReport:Cancel() .And. !TRB->(Eof()) 

	If cNomVnd <> TRB->Nome_Vendedor
		oReport:SkipLine()
		oSection1:Cell("EMISSAO"):SetValue("")
		oSection1:Cell("Nro_Pedido"):SetValue("")
		oSection1:Cell("Nro_NFE"):SetValue("")
		oSection1:Cell("COD_CLIENTE"):SetValue("")    
		oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total")
		oSection1:Cell("Nome_Vendedor"):SetValue(cNomVnd)
		oSection1:Cell("Vlr_Produtos"):SetValue(Transform(nVlr01,"@E 999,999,999.99"))
		oSection1:Cell("Desconto"):SetValue(Transform(nVlr02,"@E 999,999,999.99"))
		oSection1:Cell("Total_Bruto"):SetValue(Transform(nVlr03,"@E 999,999,999.99"))
		oSection1:Cell("Total_ST"):SetValue(Transform(nVlr04,"@E 999,999,999.99"))
		oSection1:Cell("Total_IPI"):SetValue(Transform(nVlr05,"@E 999,999,999.99"))
		oSection1:Cell("Total_FCP_ST"):SetValue(Transform(nVlr06,"@E 999,999,999.99"))
		oSection1:Cell('Vlr_Pedido'):SetValue(Transform(nVlr07,"@E 999,999,999.99"))
		oSection1:Cell('Status'):SetValue("")
		oSection1:PrintLine()
		oReport:SkipLine()
		
		cNomVnd := TRB->Nome_Vendedor
		nVlr01 := 0
		nVlr02 := 0
		nVlr03 := 0
		nVlr04 := 0
		nVlr05 := 0
		nVlr06 := 0
		nVlr07 := 0
	EndIf 

    cnota := alltrim(TRB->Nro_NFE)
	cserie := TRB->F2_SERIE
	cRet := ""
	
	If cnota <> ""
		BuscaSts(cnota,cserie,@cRet)
	else
		/*aAuxImp	 := U__VlrImp(TRB->Nro_Pedido)
		nVlrPv	:= aAuxImp[1,4]*/
		nVlrPv  := TRB->C5_XTOTNF
		cRet := 'Nao faturado'
	EndIf


    oSection1:Cell("EMISSAO"):SetValue(stod(TRB->EMISSAO))
    oSection1:Cell("Nro_Pedido"):SetValue(TRB->Nro_Pedido)
    oSection1:Cell("Nro_NFE"):SetValue(TRB->Nro_NFE)
    oSection1:Cell("COD_CLIENTE"):SetValue(TRB->COD_CLIENTE)    
	oSection1:Cell("RAZAO_SOCIAL"):SetValue(TRB->RAZAO_SOCIAL)
	oSection1:Cell("Nome_Vendedor"):SetValue(TRB->Nome_Vendedor)

	If cnota <> ""
		nVlr01 += TRB->Vlr_Produtos
		nVlr02 += TRB->Desconto
		nVlr03 += TRB->Total_Bruto
		nVlr04 += TRB->Total_ST
		nVlr05 += TRB->Total_IPI
		nVlr06 += TRB->Total_FCP_ST
		nVlr07 += TRB->Vlr_Produtos+TRB->Total_ST+TRB->Total_IPI+TRB->Total_FCP_ST-TRB->Desconto

		nTot01 += TRB->Vlr_Produtos
		nTot02 += TRB->Desconto
		nTot03 += TRB->Total_Bruto
		nTot04 += TRB->Total_ST
		nTot05 += TRB->Total_IPI
		nTot06 += TRB->Total_FCP_ST
		nTot07 += TRB->Vlr_Produtos+TRB->Total_ST+TRB->Total_IPI+TRB->Total_FCP_ST-TRB->Desconto

		oSection1:Cell("Vlr_Produtos"):SetValue(Transform(TRB->Vlr_Produtos,"@E 999,999,999.99"))
		oSection1:Cell("Desconto"):SetValue(Transform(TRB->Desconto,"@E 999,999,999.99"))
		oSection1:Cell("Total_Bruto"):SetValue(Transform(TRB->Total_Bruto,"@E 999,999,999.99"))
		oSection1:Cell("Total_ST"):SetValue(Transform(TRB->Total_ST,"@E 999,999,999.99"))
		oSection1:Cell("Total_IPI"):SetValue(Transform(TRB->Total_IPI,"@E 999,999,999.99"))
		oSection1:Cell("Total_FCP_ST"):SetValue(Transform(TRB->Total_FCP_ST,"@E 999,999,999.99"))
		oSection1:Cell('Vlr_Pedido'):SetValue(Transform(TRB->Vlr_Produtos+TRB->Total_ST+TRB->Total_IPI+TRB->Total_FCP_ST-TRB->Desconto,"@E 999,999,999.99"))
	Else
		nTot01 += TRB->PREUNIT //aAuxImp[1,6]
		nTot02 += TRB->Desconto
		nTot03 += TRB->PREUNIT //aAuxImp[1,6]
		nTot04 += TRB->Tt_ST //aAuxImp[1,2]
		nTot05 += TRB->Tt_Ipi // aAuxImp[1,3]
		nTot06 += TRB->C5_XTOTFCP //aAuxImp[1,5]
		nTot07 += TRB->C5_XTOTNF //aAuxImp[1,6]+aAuxImp[1,2]+aAuxImp[1,3]+aAuxImp[1,5]-TRB->Desconto

		nVlr01 += TRB->PREUNIT //aAuxImp[1,6]
		nVlr02 += TRB->Desconto
		nVlr03 += TRB->PREUNIT //aAuxImp[1,6]
		nVlr04 += TRB->Tt_ST //aAuxImp[1,2]
		nVlr05 += TRB->Tt_Ipi //aAuxImp[1,3]
		nVlr06 += TRB->C5_XTOTFCP //aAuxImp[1,5]
		nVlr07 += TRB->C5_XTOTNF //aAuxImp[1,6]+aAuxImp[1,2]+aAuxImp[1,3]+aAuxImp[1,5]-TRB->Desconto
		
		oSection1:Cell("Vlr_Produtos"):SetValue(Transform(TRB->PREUNIT,"@E 999,999,999.99"))
		oSection1:Cell("Desconto"):SetValue(Transform(TRB->Desconto,"@E 999,999,999.99"))
		oSection1:Cell("Total_Bruto"):SetValue(Transform(TRB->PREUNIT,"@E 999,999,999.99"))
		oSection1:Cell("Total_ST"):SetValue(Transform(TRB->Tt_ST,"@E 999,999,999.99"))
		oSection1:Cell("Total_IPI"):SetValue(Transform(TRB->Tt_Ipi,"@E 999,999,999.99"))
		oSection1:Cell("Total_FCP_ST"):SetValue(Transform(TRB->C5_XTOTFCP,"@E 999,999,999.99"))
		oSection1:Cell('Vlr_Pedido'):SetValue(Transform(TRB->C5_XTOTNF,"@E 999,999,999.99"))
	EndIf 

	If Empty(cRet)
		cRet := 'Em Aberto'
	EndIf

	oSection1:Cell('Status'):SetValue(cRet)

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	
	oSection1:PrintLine()
	
	dbSelectArea("TRB")
	dbSkip()
EndDo                     
	
oSection1:Cell("EMISSAO"):SetValue("")
oSection1:Cell("Nro_Pedido"):SetValue("")
oSection1:Cell("Nro_NFE"):SetValue("")
oSection1:Cell("COD_CLIENTE"):SetValue("")    
oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total")
oSection1:Cell("Nome_Vendedor"):SetValue(cNomVnd)
oSection1:Cell("Vlr_Produtos"):SetValue(Transform(nVlr01,"@E 999,999,999.99"))
oSection1:Cell("Desconto"):SetValue(Transform(nVlr02,"@E 999,999,999.99"))
oSection1:Cell("Total_Bruto"):SetValue(Transform(nVlr03,"@E 999,999,999.99"))
oSection1:Cell("Total_ST"):SetValue(Transform(nVlr04,"@E 999,999,999,999.99"))
oSection1:Cell("Total_IPI"):SetValue(Transform(nVlr05,"@E 999,999,999.99"))
oSection1:Cell("Total_FCP_ST"):SetValue(Transform(nVlr06,"@E 999,999,999.99"))
oSection1:Cell('Vlr_Pedido'):SetValue(Transform(nVlr07,"@E 999,999,999.99"))
oSection1:Cell('Status'):SetValue("")
oSection1:PrintLine()
oReport:SkipLine()
oReport:SkipLine()

oSection1:Cell("EMISSAO"):SetValue("")
oSection1:Cell("Nro_Pedido"):SetValue("")
oSection1:Cell("Nro_NFE"):SetValue("")
oSection1:Cell("COD_CLIENTE"):SetValue("")    
oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total")
oSection1:Cell("Nome_Vendedor"):SetValue("Total Geral")
oSection1:Cell("Vlr_Produtos"):SetValue(Transform(nTot01,"@E 999,999,999.99"))
oSection1:Cell("Desconto"):SetValue(Transform(nTot02,"@E 999,999,999.99"))
oSection1:Cell("Total_Bruto"):SetValue(Transform(nTot03,"@E 999,999,999.99"))
oSection1:Cell("Total_ST"):SetValue(Transform(nTot04,"@E 999,999,999,999.99"))
oSection1:Cell("Total_IPI"):SetValue(Transform(nTot05,"@E 999,999,999.99"))
oSection1:Cell("Total_FCP_ST"):SetValue(Transform(nTot06,"@E 999,999,999.99"))
oSection1:Cell('Vlr_Pedido'):SetValue(Transform(nTot07,"@E 999,999,999.99"))
oSection1:Cell('Status'):SetValue("")
oSection1:PrintLine()

oSection1:Finish()
oReport:EndPage() 

Return Nil

//
//Pesquisa titulos na SE1
Static Function BuscaSts(cnota,cserie,cRet)

Local aArea := GetArea()
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
		cRet += "Baixado"
	ElseIf aAux[nCont,02] > ddatabase
		cRet := "Em Aberto"
	EndIf

Next nCont

If Empty(cRet)
	cRet := "Em Aberto"
EndIf 
RestArea(aAreA)
	
Return(cRet)
