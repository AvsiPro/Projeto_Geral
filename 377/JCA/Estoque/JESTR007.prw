#INCLUDE "MATR900.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR900  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 25.07.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex fisico - financeiro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function JESTR007()
	Local oReport

	oReport:= ReportDef()
	oReport:PrintDialog()

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³25.07.2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
	±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³Nenhum                                                      ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3
	Local aOrdem       := {}
	Local cPicB2Tot    := PesqPict("SB2","B2_VATU1" ,18)
	Local cTamB2Tot    := TamSX3( 'B2_VATU1' )[1]
	Local cPicB2Qt     := PesqPict("SB2","B2_QATU" ,18)
	Local cTamB2Qt     := TamSX3( 'B2_QATU' )[1]
	Local cPicB2Cust   := PesqPict("SB2","B2_CM1",18)
	Local cTamB2Cust   := TamSX3( 'B2_CM1' )[1]
	Local cPicD1Qt     := PesqPict("SD1","D1_QUANT" ,18)
	Local cTamD1Qt     := TamSX3( 'D1_QUANT' )[1]
	Local cPicD1Cust   := PesqPict("SD1","D1_CUSTO",18)
	Local cTamD1Cust   := TamSX3( 'D1_CUSTO' )[1]
	Local cPicD2Qt     := PesqPict("SD2","D2_QUANT" ,18)
	Local cTamD2Qt     := TamSX3( 'D2_QUANT' )[1]
	Local cPicD2Cust   := PesqPict("SD2","D2_CUSTO1",18)
	Local cTamD2Cust   := TamSX3( 'D2_CUSTO1' )[1]
	Local cTamD1CF     := TamSX3( 'D1_CF' )[1]
	Local cTamCCPVPJOP := TamSX3(MaiorCampo("D3_CC;D3_PROJPMS;D3_OP;D2_CLIENTE"))[1]
	Local lVEIC        := Upper(GetMV("MV_VEICULO"))=="S"
	Local nTamData     := IIF(__SetCentury(),10,8)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
	//|utiliza custo unificado por:                                  |
	//|      F = Custo Unificado por Filial                          |
	//|      E = Custo Unificado por Empresa                         |
	//|      A = Custo Unificado por Armazem                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lCusFil      := AllTrim(SuperGetMV( 'MV_CUSFIL' ,.F.,"A")) == "F"
	Local lCusEmp      := AllTrim(SuperGetMv( 'MV_CUSFIL' ,.F.,"A")) == "E"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_CUSREP - Parametro utilizado para habilitar o calculo do   ³
	//³            Custo de Reposicao.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lCusRep      := SuperGetMv("MV_CUSREP",.F.,.F.) .And. MA330AvRep()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= TReport():New("JESTR007",STR0001,"MTR900", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                     ³
	//³ mv_par01         // Do produto                           ³
	//³ mv_par02         // Ate o produto                        ³
	//³ mv_par03         // Do tipo                              ³
	//³ mv_par04         // Ate o tipo                           ³
	//³ mv_par05         // Da data                              ³
	//³ mv_par06         // Ate a data                           ³
	//³ mv_par07         // Lista produtos s/movimento           ³
	//³ mv_par08         // Qual Local (almoxarifado)            ³
	//³ MV_par09         // (d)OCUMENTO/(s)EQUENCIA              ³
	//³ mv_par10         // moeda selecionada ( 1 a 5 )          ³
	//³ mv_par11         // Seq.de Digitacao /Calculo            ³
	//³ mv_par12         // Pagina Inicial                       ³
	//³ mv_par13         // Lista Transf Locali (Sim/Nao)        ³
	//³ mv_par14         // Do  Grupo                            ³
	//³ mv_par15         // Ate o Grupo                          ³
	//³ mv_par16         // Seleciona Filial?                    ³
	//³ mv_par17         // Qual Custo ? ( Medio / Reposicao )   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("MTR900",.F.)

	Aadd( aOrdem, STR0004 ) // " Codigo Produto "
	Aadd( aOrdem, STR0005 ) // " Tipo do Produto"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao da Sessao 1 - Dados do Produto                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1 := TRSection():New(oReport,STR0059,{"SB1","SB2"},aOrdem) //"Produtos (Parte 1)"
	oSection1 :SetTotalInLine(.F.)
	oSection1 :SetReadOnly()
	oSection1 :SetLineStyle()

	If lVeic
		TRCell():New(oSection1,"B1_CODITE","SB1",/*Titulo*/				,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf
	TRCell():New(oSection1, "cProduto", " "  , /*Titulo*/                                    , /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	oSection1:Cell("cProduto"):GetFieldInfo("B1_COD")
	TRCell():New(oSection1, "B1_DESC" , "SB1", /*Titulo*/                                    , /*Picture*/, 30         , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "B1_UM"   , "SB1", STR0053                                       , /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "cTipo"   , " "  , STR0054                                       , "@!"       , 2          , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "B1_GRUPO", "SB1", STR0055                                       , /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "nCusMed" , " "  , IIf(lCusRep .And. mv_par17==2,STR0068,STR0056), cPicB2Cust , cTamB2Cust , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "nQtdSal" , " "  , STR0034                                       , cPicB2Qt   , cTamB2Qt   , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection1, "nVlrSal" , " "  , STR0035                                       , cPicB2Tot  , cTamB2Tot  , /*lPixel*/, /*{|| code-block de impressao }*/)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao da Sessao 2 - Cont. dos dados do Produto           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2 := TRSection():New(oSection1,STR0060,{"SB1","SB2","NNR"}) //"Produtos (Parte 2)"
	oSection2 :SetTotalInLine(.F.)
	oSection2 :SetReadOnly()
	oSection2 :SetLineStyle()

	If lVeic
		TRCell():New(oSection2, "cProduto", " "  , /*Titulo*/, /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
		oSection2:Cell("cProduto"):GetFieldInfo("B1_COD")
		TRCell():New(oSection2, "B1_UM"   , "SB1", STR0053   , /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
		TRCell():New(oSection2, "cTipo"   , " "  , STR0054   , "@!"       , 2          , /*lPixel*/, /*{|| code-block de impressao }*/)
		TRCell():New(oSection2, "B1_GRUPO", "SB1", STR0055   , /*Picture*/, /*Tamanho*/, /*lPixel*/, /*{|| code-block de impressao }*/)
	Endif
	If cPaisLoc<>"CHI"
		TRCell():New(oSection2	,"B1_POSIPI"	,"SB1",STR0057		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	Endif

	TRCell():New(oSection2		,'NNR_DESCRI'	,"NNR",STR0058		,/*Picture*/	,/*Tamanho*/,/*lPixel*/,{|| If(lCusFil .Or. lCusEmp , MV_PAR08 , Posicione("NNR",1,xFilial("NNR")+MV_PAR08,"NNR_DESCRI")) })
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao da Sessao 3 - Movimentos                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection3 := TRSection():New(oSection2,STR0061,{"SD1","SD2","SD3"}) //"Movimentação dos Produtos"
	oSection3 :SetHeaderPage()
	oSection3 :SetTotalInLine(.F.)
	oSection3 :SetTotalText(STR0021) //"T O T A I S  :"
	oSection3 :SetReadOnly()

	TRCell():New(oSection3, "dDtMov"   , " ", STR0036+CRLF+STR0037, /*Picture*/, nTamData      , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cLocal"   , " ", STR0069             , "@!"       , /*Tamanho*/   , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTES"     , " ", STR0038             , "@!"       , /*Tamanho*/   , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cCF"      , " ", STR0039             , "@!"       , cTamD1CF      , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cDoc"     , " ", STR0040+CRLF+STR0041, "@!"       , /*Tamanho*/   , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco1"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nENTQtd"  , " ", STR0042+CRLF+STR0043, cPicD1Qt   , cTamD1Qt      , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco2"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nENTCus"  , " ", STR0042+CRLF+STR0044, cPicD1Cust , cTamD1Cust    , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco3"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nCusMov"  , " ", STR0045+CRLF+STR0046, cPicB2Cust , cTamB2Cust    , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco4"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nSAIQtd"  , " ", STR0047+CRLF+STR0043, cPicD2Qt   , cTamD2Qt      , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco5"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nSAICus"  , " ", STR0047+CRLF+STR0044, cPicD2Cust , cTamD2Cust    , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco6"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nSALDQtd" , " ", STR0048+CRLF+STR0043, cPicB2Qt   , cTamB2Qt      , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco7"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "nSALDCus" , " ", STR0048+CRLF+STR0049, cPicB2Tot  , cTamB2Tot     , /*lPixel*/, /*{|| code-block de impressao }*/)
	TRCell():New(oSection3, "cTraco8"  , " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
	TRCell():New(oSection3, "cCCPVPJOP", " ", STR0050+CRLF+STR0051, "@!"       , cTamCCPVPJOP+2, /*lPixel*/, /*{|| code-block de impressao }*/)

	// Definir o formato de valores negativos (para o caso de devolucoes)
	oSection3:Cell("nENTQtd"):SetNegative("PARENTHESES")
	oSection3:Cell("nENTCus"):SetNegative("PARENTHESES")
	oSection3:Cell("nSAIQtd"):SetNegative("PARENTHESES")
	oSection3:Cell("nSAICus"):SetNegative("PARENTHESES")

	TRFunction():New(oSection3:Cell("nENTQtd")	,NIL,"SUM"		,/*oBreak*/,"",cPicD1Qt		,{|| oSection3:Cell("nENTQtd"):GetValue(.T.) },.T.,.F.)
	TRFunction():New(oSection3:Cell("nENTCus")	,NIL,"SUM"		,/*oBreak*/,"",cPicD1Cust	,{|| oSection3:Cell("nENTCus"):GetValue(.T.) },.T.,.F.)

	TRFunction():New(oSection3:Cell("nSAIQtd")	,NIL,"SUM"		,/*oBreak*/,"",cPicD2Qt		,{|| oSection3:Cell("nSAIQtd"):GetValue(.T.) },.T.,.F.)
	TRFunction():New(oSection3:Cell("nSAICus")	,NIL,"SUM"		,/*oBreak*/,"",cPicD2Cust	,{|| oSection3:Cell("nSAICus"):GetValue(.T.) },.T.,.F.)

	TRFunction():New(oSection3:Cell("nSALDQtd"),NIL,"ONPRINT"	,/*oBreak*/,"",cPicB2Qt		,{|| oSection3:Cell("nSALDQtd"):GetValue(.T.) },.T.,.F.)
	TRFunction():New(oSection3:Cell("nSALDCus"),NIL,"ONPRINT"	,/*oBreak*/,"",cPicB2Tot	,{|| oSection3:Cell("nSALDCus"):GetValue(.T.) },.T.,.F.)

	oSection3:SetNoFilter("SD1")
	oSection3:SetNoFilter("SD2")
	oSection3:SetNoFilter("SD3")

Return(oReport)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³21.06.2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
	±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local oSection3 := oReport:Section(1):Section(1):Section(1)
	Local nOrdem    := oReport:Section(1):GetOrder()
	Local cSelectD1 := '', cWhereD1 := '', cWhereD1C := ''
	Local cSelectD2 := '', cWhereD2 := '', cWhereD2C := ''
	Local cSelectD3 := '', cWhereD3 := '', cWhereD3C := ''
	Local cSelectVe := '%%', cUnion := '%%'
	Local aDadosTran:= {}
	Local lContinua := .F.
	Local lFirst    := .T.
	Local lTransEnd := .T.
	Local lFormTab  := oReport:nDevice == 4 .And. oReport:nExcelPrintType == 3
	Local aSalAtu   := { 0,0,0,0,0,0,0 }
	Local cPicB2Qt2 := PesqPictQt("B2_QTSEGUM" ,18)
	Local nTotRegs  := 0
	Local cProdAnt  := ""
	Local cLocalAnt := ""
	Local cNumSeqTr := ""
	Local cTipoNf   := ""
	Local cMvCQ		:= GetMvNNR('MV_CQ','98')
	// Indica se esta listando relatorio do almox. de processo
	Local lLocProc  := mv_par08 == GetMvNNR('MV_LOCPROC','99')
	// Indica se deve imprimir movimento invertido (almox. de processo)
	Local lInverteMov :=.F.
	Local lPriApropri :=.T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Codigo do produto importado - NAO DEVE SER LISTADO           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cProdImp := GetMV("MV_PRODIMP")

	Local cWhereB1A:= " "
	Local cWhereB1B:= " "
	Local cWhereB1C:= " "
	Local cWhereB1D:= " "

	Local cQueryB1A:= " "
	Local cQueryB1B:= " "
	Local cQueryB1C:= " "
	Local cQueryB1D:= " "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Concessionaria de Veiculos                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lVEIC    := Upper(GetMV("MV_VEICULO"))=="S"

	Local lImpSMov := .F.
	LOCAL cProdMNT := GetMv("MV_PRODMNT")
	LOCAL cProdTER := GetMv("MV_PRODTER")
	Local aProdsMNT := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para processamento de Filiais           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aFilsCalc := MatFilCalc( Iif (!IsBlind(), mv_par16 == 1, .F.))
	Local cFilBack  := cFilAnt
	Local nForFilial:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variavel utilizada para inicar a pagina do relatorio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local n_pag     := mv_par12
	Local cAliasTop := GetNextAlias()
	Local cFilUsrSB1:= oSection1:GetAdvplExp("SB1")
	Local cFilUsrSB2:= oSection1:GetAdvplExp("SB2")
	Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
	Local lD3Servi	:= IIF(lWmsNew,.F.,GetMV('MV_D3SERVI',.F.,'N')=='N')
	Local lFuncMnt  := FindFunction( 'MNTDESCOS' )
	Local cIdent    := ''
	Local aFils     := {}
	Local nFils     := 0
	LOCAL aProdPai := {}
    Local cBkpCPai  :=  ''
	
	Private aAuxPrt	:=	{}
	Private aPrintT	:=	{}

	PRIVATE nOrdPai := nOrdem
	Private bBloco   := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_CUSREP - Parametro utilizado para habilitar o calculo do   ³
	//³            Custo de Reposicao.                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And.MA330AvRep()

	cProdMNT := cProdMNT + Space(15-Len(cProdMNT))
	cProdTER := cProdTER + Space(15-Len(cProdTER))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
	//|utiliza custo unificado por:                                  |
	//|      F = Custo Unificado por Filial                          |
	//|      E = Custo Unificado por Empresa                         |
	//|      A = Custo Unificado por Armazem                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
	Private lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

	lCusFil:=lCusFil .And. mv_par08 == Repl("*",TamSX3("B2_LOCAL")[1])
	lCusEmp:=lCusEmp .And. mv_par08 == Repl("#",TamSX3("B2_LOCAL")[1])

	Private lDev := .F. // Flag que indica se nota ‚ devolu‡ao (.T.) ou nao (.F.)

	oReport:SetPageNumber(n_pag)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alerta o usuario que o custo de reposicao esta desativado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par17==2 .And. !lCusRep
		Help(" ",1,"A910CUSRP")
		mv_par17 := 1
	EndIf

	If lCusEmp .And. !Empty(aFilsCalc)
		For nForFilial := 1 To Len( aFilsCalc )
			If aFilsCalc[ nForFilial, 1 ]
				aAdd(aFils, aFilsCalc[ nForFilial, 2 ])
			EndIf
		Next nForFilial
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ aFilsCalc - Array com filiais a serem processadas            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aFilsCalc)

		For nForFilial := 1 To Len( aFilsCalc )

			If aFilsCalc[ nForFilial, 1 ]

				cFilAnt := aFilsCalc[ nForFilial, 2 ]

				oReport:EndPage() //Reinicia Pagina

				oReport:SetTitle(OemToAnsi(STR0008) + IIf(mv_par11==1,IIf(lCusRep .And. mv_par17==2,STR0065,STR0009),IIf(lCusRep .And. mv_par17==2,STR0066,STR0010) ) + " " + IIf(lCusFil .Or. lCusEmp,"",OemToAnsi(STR0011)+" "+mv_par08) ) // "KARDEX FISICO-FINANCEIRO "###"(SEQUENCIA)"###"(CALCULO)"###"L O C A L :"
				If nOrdem == 1
					oReport:SetTitle( oReport:Title()+Alltrim(STR0017+STR0004+STR0018+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par10))))+")")+' - ' + aFilsCalc[ nForFilial, 3 ] ) //" (Por "###" ,em "
				Else
					oReport:SetTitle( oReport:Title()+Alltrim(STR0017+STR0005+STR0018+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par10))))+")")+' - ' + aFilsCalc[ nForFilial, 3 ] ) //" (Por "###" ,em "
				EndIf

				If lVeic
					oSection1:Cell("cProduto"	):Disable()
					oSection1:Cell("B1_UM"		):Disable()
					oSection1:Cell("cTipo"		):Disable()
					oSection1:Cell("B1_GRUPO"	):Disable()
				EndIf

				If mv_par09 $ "Ss"
					oSection3:Cell("cDoc"):SetTitle(STR0052+CRLF+STR0041) //"SEQUENCIA"
				EndIf

				dbSelectArea("SD1")   // Itens de Entrada
				nTotRegs += LastRec()

				dbSelectArea("SD2")   // Itens de Saida
				nTotRegs += LastRec()

				dbSelectArea("SD3")   // movimentacoes internas (producao/requisicao/devolucao)
				nTotRegs += LastRec()

				dbSelectArea("SB2")  // Saldos em estoque
				dbSetOrder(1)
				nTotRegs += LastRec()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Filtragem do relatorio                                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				MakeSqlExpr(oReport:uParam)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Query do relatorio da secao 1                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oReport:Section(1):BeginQuery()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do SELECT da tabela SD1                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusRep .And. mv_par17==2
					cSelectD1 := "% D1_CUSRP"
					cSelectD1 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				Else
					cSelectD1 := "% D1_CUSTO"
					If mv_par10 > 1
						cSelectD1 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
					EndIf
				EndIf
				cSelectD1 += " CUSTO,"
				cSelectD1 += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do SELECT da tabela SB1 para MV_VEICULO                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cSelectVe := "%"
				cSelectVe += ","
				If lVEIC
					cSelectVe += "SB1.B1_CODITE B1_CODITE,"
				EndIf
				cSelectVe += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do Where da tabela SD1                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhereD1 := "%"
				cWhereD1 += "AND"
				If !(lCusFil .Or. lCusEmp)
					cWhereD1 += " D1_LOCAL = '" + mv_par08 + "' AND"
				EndIf
				cWhereD1 += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do Where da tabela SD1 (Tratamento Filial)                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusEmp
					cWhereD1C := "%"
					If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SF4") == "E"
						cWhereD1C += " D1_FILIAL = F4_FILIAL AND "
					EndIf
					If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SB1") == "E"
						cWhereD1C += " D1_FILIAL = B1_FILIAL AND "
					EndIf
					For nFils := 1 to len(aFils)
						If nFils = 1
							cWhereD1C += " D1_FILIAL IN ('"+aFils[nFils]+"'"
						else
							cWhereD1C += ",'"+aFils[nFils]+"'"
						EndIf
						If nFils = len(aFils)
							cWhereD1C += ") AND "
						EndIf
					Next nFils
					cWhereD1C += "%"
				Else
					cWhereD1C := "%"
					cWhereD1C += " D1_FILIAL ='" + xFilial("SD1") + "' AND "
					cWhereD1C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
					cWhereD1C += "%"
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do SELECT da tabela SD2                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusRep .And. mv_par17==2
					cSelectD2 := "% D2_CUSRP"
					cSelectD2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				Else
					cSelectD2 := "% D2_CUSTO"
					cSelectD2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				EndIf
				cSelectD2 += " CUSTO,"
				cSelectD2 += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do Where da tabela SD1                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhereD2 := "%"
				cWhereD2 += "AND"
				If !(lCusFil .Or. lCusEmp)
					cWhereD2 += " D2_LOCAL = '" + mv_par08 + "' AND"
				EndIf
				cWhereD2 += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do Where da tabela SD2 (Tratamento Filial)                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusEmp
					cWhereD2C := "%"
					If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SF4") == "E"
						cWhereD2C += " D2_FILIAL = F4_FILIAL AND "
					EndIf
					If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SB1") == "E"
						cWhereD2C += " D2_FILIAL = B1_FILIAL AND "
					EndIf
					For nFils := 1 to len(aFils)
						If nFils = 1
							cWhereD2C += " D2_FILIAL IN ('"+aFils[nFils]+"'"
						Else
							cWhereD2C += ",'"+aFils[nFils]+"'"
						EndIf
						If nFils = len(aFils)
							cWhereD2C += ") AND "
						EndIf
					Next nFils
					cWhereD2C += "%"
				Else
					cWhereD2C := "%"
					cWhereD2C += " D2_FILIAL ='" + xFilial("SD2") + "' AND "
					cWhereD2C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
					cWhereD2C += "%"
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do SELECT da tabelas SD3                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusRep .And. mv_par17==2
					cSelectD3 := "% D3_CUSRP"
					cSelectD3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				Else
					cSelectD3 := "% D3_CUSTO"
					cSelectD3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
				EndIf
				cSelectD3 +=	" CUSTO,"
				cSelectD3 += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do WHERE da tabela SD3                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhereD3 := "%"
				If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
					cWhereD3 += " D3_ESTORNO <> 'S' AND"
				EndIf
				If lD3Servi .And. IntDL()
					cWhereD3 += " ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
					cWhereD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='" + cMvCQ + "') ) AND"
				EndIf
				If !(lCusFil .Or. lCusEmp) .And. !lLocProc
					cWhereD3 += " D3_LOCAL = '"+mv_par08+"' AND"
				EndIf
				If	!lVEIC
					cWhereD3+= " SB1.B1_COD >= '"+mv_par01+"' AND SB1.B1_COD <= '"+mv_par02+"' AND"
				Else
					cWhereD3+= " SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"' AND"
				EndIf
				If lCusEmp
					cWhereD3 += " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
				Else
					cWhereD3 += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
				EndIf
				cWhereD3 += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
				cWhereD3 += " SB1.D_E_L_E_T_=' ' AND"
				cWhereD3 += "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do Where da tabela SD3 (Tratamento Filial)                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusEmp
					cWhereD3C := "%"
					For nFils := 1 to len(aFils)
						If nFils = 1
							cWhereD3C += " D3_FILIAL IN ('"+aFils[nFils]+"'"
						Else
							cWhereD3C += ",'"+aFils[nFils]+"'"
						EndIf
						If nFils = len(aFils)
							cWhereD3C += ") AND %"
						EndIf
					Next nFils
				Else
					cWhereD3C := "%"
					cWhereD3C += " D3_FILIAL ='" + xFilial("SD3")  + "' AND "
					cWhereD3C += "%"
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Complemento do WHERE da tabela SB1 para todos os selects                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cWhereB1A:= "%"
				cWhereB1B:= "%"
				cWhereB1C:= "%"
				cWhereB1D:= "%"
				If	!lVEIC
					cWhereB1A+= " AND SB1.B1_COD >= '"+mv_par01+"' AND SB1.B1_COD <= '"+mv_par02+"'"
					cWhereB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"
					If lCusEmp
						cWhereB1C+= " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_COD >= '"+mv_par01+"' AND SB1EXS.B1_COD <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					Else
						cWhereB1C+= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_COD >= '"+mv_par01+"' AND SB1EXS.B1_COD <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					EndIf
				Else
					cWhereB1A+= " AND SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"'"
					cWhereB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"
					If lCusEmp
						cWhereB1C+= " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					Else
						cWhereB1C+= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
						cWhereB1D+= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
					EndIf
				EndIf

				cWhereB1C += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
				cWhereB1C += " SB1.D_E_L_E_T_=' '"
				cWhereB1D += " SB1EXS.B1_GRUPO >= '"+mv_par14+"' AND SB1EXS.B1_GRUPO <= '"+mv_par15+"' AND SB1EXS.B1_COD <> '"+cProdimp+"' AND "
				cWhereB1D += " SB1EXS.D_E_L_E_T_=' '"

				cQueryB1A:= Subs(cWhereB1A,2)
				cQueryB1B:= Subs(cWhereB1B,2)
				cQueryB1C:= Subs(cWhereB1C,2)
				cQueryB1D:= Subs(cWhereB1D,2)

				cWhereB1A+= "%"
				cWhereB1B+= "%"
				cWhereB1C+= "%"
				cWhereB1D+= "%"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So inclui as condicoes a seguir qdo lista produtos sem ³
				//³ movimento                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cQueryD1 := " FROM "
				cQueryD1 += RetSqlName("SB1") + " SB1"
				cQueryD1 += (", " + RetSqlName("SD1")+ " SD1 ")
				cQueryD1 += (", " + RetSqlName("SF4")+ " SF4 ")
				cQueryD1 += " WHERE SB1.B1_COD = D1_COD"
				If lCusEmp
					If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SF4") == "E"
						cQueryD1 += " AND F4_FILIAL = D1_FILIAL "
					EndIf
				Else
					cQueryD1 += (" AND D1_FILIAL = '" + xFilial("SD1")+"'" )
					cQueryD1 += (" AND F4_FILIAL = '" + xFilial("SF4") + "'")
				EndIf
				cQueryD1 += (" AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'")
				cQueryD1 += (" AND D1_DTDIGIT >= '" + DTOS(mv_par05) + "'")
				cQueryD1 += (" AND D1_DTDIGIT <= '" + DTOS(mv_par06) + "'")
				cQueryD1 +=  " AND D1_ORIGLAN <> 'LF'"
				If !(lCusFil .Or. lCusEmp)
					cQueryD1 += " AND D1_LOCAL = '" + mv_par08 + "'"
				EndIf
				cQueryD1 += " AND SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"

				cQueryD2 := " FROM "
				cQueryD2 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD2")+ " SD2 , "+ RetSqlName("SF4")+" SF4 "
				cQueryD2 += " WHERE SB1.B1_COD = D2_COD "
				If lCusEmp
					If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SF4") == "E"
						cQueryD2 += " AND F4_FILIAL = D2_FILIAL "
					EndIf
				Else
					cQueryD2 += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
					cQueryD2 += " AND F4_FILIAL = '"+xFilial("SF4")+"' "
				EndIf
				cQueryD2 += " AND SD2.D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
				cQueryD2 += " AND D2_EMISSAO >= '"+DTOS(mv_par05)+"' AND D2_EMISSAO <= '"+DTOS(mv_par06)+"'"
				cQueryD2 += " AND D2_ORIGLAN <> 'LF'"
				If !(lCusFil .Or. lCusEmp)
					cQueryD2 += " AND D2_LOCAL = '"+mv_par08+"'"
				EndIf
				cQueryD2 += " AND SD2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"

				cQueryD3 := " FROM "
				cQueryD3 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD3")+ " SD3 "
				cQueryD3 += " WHERE SB1.B1_COD = D3_COD "
				If !lCusEmp
					cQueryD3 += " AND D3_FILIAL = '"+xFilial("SD3")+"' "
				EndIf
				cQueryD3 += " AND D3_EMISSAO >= '"+DTOS(mv_par05)+"' AND D3_EMISSAO <= '"+DTOS(mv_par06)+"'"
				If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
					cQueryD3 += " AND D3_ESTORNO <> 'S'"
				EndIf
				If lD3Servi .And. IntDL()
					cQueryD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
					cQueryD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+ cMvCQ +"') )"
				EndIf
				If !(lCusFil .Or. lCusEmp) .And. !lLocProc
					cQueryD3 += " AND D3_LOCAL = '"+mv_par08+"'"
				EndIf
				cQueryD3 += " AND SD3.D_E_L_E_T_=' '"

				cQuerySub:= "SELECT 1 "

				If mv_par07 == 1
					cQuery2 := " AND NOT EXISTS (" + cQuerySub + cQueryD1
					cQuery2 += cQueryB1B
					cQuery2 += " AND "
					cQuery2 += cQueryB1C
					cQuery2 += ") AND NOT EXISTS ("
					cQuery2 += cQuerySub + cQueryD2
					cQuery2 += cQueryB1B
					cQuery2 += " AND "
					cQuery2 += cQueryB1C
					cQuery2 += ") AND NOT EXISTS ("
					cQuery2 += cQuerySub + cQueryD3
					cQuery2 += cQueryB1B
					cQuery2 += " AND "
					cQuery2 += cQueryB1C + ")"

					cUnion := "%"
					cUnion += " UNION SELECT 'SB1'"		// 01
					cUnion += ", SB1EXS.B1_COD"			// 02
					cUnion += ", SB1EXS.B1_TIPO"		// 03
					cUnion += ", SB1EXS.B1_UM"			// 04
					cUnion += ", SB1EXS.B1_GRUPO"		// 05
					cUnion += ", SB1EXS.B1_DESC"		// 06
					cUnion += ", SB1EXS.B1_POSIPI"		// 07
					cUnion += ", ''"					// 08
					cUnion += ", ''"					// 09
					cUnion += ", ''"					// 10
					cUnion += ", ''"					// 11
					cUnion += ", ''"					// 12
					cUnion += ", ''"					// 13
					cUnion += ", ''"					// 14
					cUnion += ", 0"						// 15
					cUnion += ", 0"						// 16
					cUnion += ", ''"					// 17
					cUnion += ", ''"					// 18
					cUnion += ", ''"					// 19
					cUnion += ", ''"					// 20
					cUnion += ", ''"					// 21
					cUnion += ", ''"					// 22
					cUnion += ", ''"					// 23
					cUnion += ", ''"					// 24
					cUnion += ", 0"						// 25
					cUnion += ", ''"					// 26
					cUnion += ", ''"					// 27
					If lVEIC
						cUnion += ", SB1EXS.B1_CODITE CODITE"	// 28
					EndIf
					cUnion += ", 0"						// 29
					cUnion += ", ''"					// 30 local
					cUnion += " FROM "+RetSqlName("SB1") + " SB1EXS WHERE"
					cUnion += cQueryB1D
					cUnion += cQuery2
					cUnion += "%"
				EndIf

				cOrder := "%"
				If ! lVEIC
					If nOrdem == 1 //" Codigo Produto "###" Tipo do Produto"
						cOrder += " 2,"
					ElseIf nOrdem == 2
						cOrder += " 3,2,"
					EndIf
				Else
					If nOrdem ==1 //" Codigo Produto "###" Tipo do Produto"
						cOrder += " 28, 2, 5," 	// B1_CODITE, B1_COD, B1_GRUPO
					ElseIf nOrdem == 2
						cOrder += " 3, 28, 2, 5," // B1_TIPO, B1_CODITE, B1_COD, B1_GRUPO
					EndIf
				EndIf

				If mv_par11 == 1
					cOrder += "12"+IIf(lVEIC,',29',',28')
				Else
					If lCusFil .Or. lCusEmp
						cOrder += "8,12"+IIf(lVEIC,',29',',28')
					Else
						cOrder += "8"+IIf(lVEIC,',29',',28')
					EndIf
				EndIf
				cOrder += "%"

				BeginSql Alias cAliasTop
					SELECT
						'SD1' ARQ,
						//-- 01 ARQ
						SB1.B1_COD PRODUTO,
						//-- 02 PRODUTO
						SB1.B1_TIPO TIPO,
						//-- 03 TIPO
						SB1.B1_UM,
						//-- 04 UM
						SB1.B1_GRUPO,
						//-- 05 GRUPO
						SB1.B1_DESC,
						//-- 06 DESCR
						SB1.B1_POSIPI,
						//-- 07
						D1_SEQCALC SEQCALC,
						//-- 08
						D1_DTDIGIT DTDIGIT,
						//-- 09 DTDIGIT
						D1_TES TES,
						//-- 10 TES
						D1_CF CF,
						//-- 11 CF
						D1_NUMSEQ SEQUENCIA,
						//-- 12 SEQUENCIA
						D1_DOC DOCUMENTO,
						//-- 13 DOCUMENTO
						D1_SERIE SERIE,
						//-- 14 SERIE
						D1_QUANT QUANTIDADE,
						//-- 15 QUANTIDADE
						D1_QTSEGUM QUANT2UM,
						//-- 16 QUANT2UM
						D1_LOCAL ARMAZEM,
						//-- 17 ARMAZEM
						' ' PROJETO,
						//-- 18 PROJETO
						' ' OP,
						//-- 19 OP
						' ' CC,
						//-- 20 OP
						D1_FORNECE FORNECEDOR,
						//-- 21 FORNECEDOR
						D1_LOJA LOJA,
						//-- 22 LOJA
						' ' PEDIDO,
						//-- 23 PEDIDO
						D1_TIPO TIPONF,
						//-- 24 TIPO NF
						%Exp:cSelectD1% //-- 25 CUSTO
						' ' TRT,
						//-- 26 TRT
						D1_LOTECTL LOTE //-- 27 LOTE
						%Exp:cSelectVe% //-- 28 CODITE
						SD1.R_E_C_N_O_ NRECNO,
						//-- 29 RECNO
						SD1.D1_LOCAL ARMLOC
					FROM
						%table:SB1% SB1,%table:SD1% SD1,%table:SF4% SF4
					WHERE
						SB1.B1_COD = SD1.D1_COD
						AND %Exp:cWhereD1C% SD1.D1_TES = SF4.F4_CODIGO
						AND SF4.F4_ESTOQUE = 'S'
						AND SD1.D1_DTDIGIT >= %Exp:mv_par05%
						AND SD1.D1_DTDIGIT <= %Exp:mv_par06%
						AND SD1.D1_ORIGLAN <> 'LF' %Exp:cWhereD1% SD1.%NotDel%
						AND SF4.%NotDel% %Exp:cWhereB1A%
						AND %Exp:cWhereB1C%
					UNION
					SELECT
						'SD2',
						SB1.B1_COD,
						SB1.B1_TIPO,
						SB1.B1_UM,
						SB1.B1_GRUPO,
						SB1.B1_DESC,
						SB1.B1_POSIPI,
						D2_SEQCALC,
						D2_EMISSAO,
						D2_TES,
						D2_CF,
						D2_NUMSEQ,
						D2_DOC,
						D2_SERIE,
						D2_QUANT,
						D2_QTSEGUM,
						D2_LOCAL,
						' ',
						' ',
						' ',
						D2_CLIENTE,
						D2_LOJA,
						D2_PEDIDO,
						D2_TIPO,
						%Exp:cSelectD2% ' ',D2_LOTECTL %Exp:cSelectVe% SD2.R_E_C_N_O_ SD2RECNO,
						//-- 29 RECNO
						SD2.D2_LOCAL
					FROM
						%table:SB1% SB1,%table:SD2% SD2,%table:SF4% SF4
					WHERE
						SB1.B1_COD = SD2.D2_COD
						AND %Exp:cWhereD2C% SD2.D2_TES = SF4.F4_CODIGO
						AND SF4.F4_ESTOQUE = 'S'
						AND SD2.D2_EMISSAO >= %Exp:mv_par05%
						AND SD2.D2_EMISSAO <= %Exp:mv_par06%
						AND SD2.D2_ORIGLAN <> 'LF' %Exp:cWhereD2% SD2.%NotDel%
						AND SF4.%NotDel% %Exp:cWhereB1A%
						AND %Exp:cWhereB1C%
					UNION
					SELECT
						'SD3',
						SB1.B1_COD,
						SB1.B1_TIPO,
						SB1.B1_UM,
						SB1.B1_GRUPO,
						SB1.B1_DESC,
						SB1.B1_POSIPI,
						D3_SEQCALC,
						D3_EMISSAO,
						D3_TM,
						D3_CF,
						D3_NUMSEQ,
						D3_DOC,
						' ',
						D3_QUANT,
						D3_QTSEGUM,
						D3_LOCAL,
						D3_PROJPMS,
						D3_OP,
						D3_CC,
						' ',
						' ',
						' ',
						' ',
						%Exp:cSelectD3% D3_TRT,D3_LOTECTL %Exp:cSelectVe% SD3.R_E_C_N_O_ SD3RECNO,
						//-- 29 RECNO
						SD3.D3_LOCAL
					FROM
						%table:SB1% SB1,%table:SD3% SD3
					WHERE
						SB1.B1_COD = SD3.D3_COD
						AND %Exp:cWhereD3C% SD3.D3_EMISSAO >= %Exp:mv_par05%
						AND SD3.D3_EMISSAO <= %Exp:mv_par06%
						AND %Exp:cWhereD3% SD3.%NotDel% %Exp:cUnion%
					ORDER BY
						%Exp:cOrder%
				EndSql
				oSection2:SetParentQuery()

				oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)


				dbSelectArea(cAliasTop)
				oReport:SetMeter(nTotRegs)

				TcSetField(cAliasTop,DTDIGIT ,"D", TamSx3("D1_DTDIGIT")[1], TamSx3("D1_DTDIGIT")[2] )

                dbSelectArea(cAliasTop)

				While !oReport:Cancel() .And. !(cAliasTop)->(Eof())

					If oReport:Cancel()
						Exit
					EndIf

					oReport:IncMeter()

					If !Empty(cFilUsrSB1)
						DbSelectArea("SB1")
						SB1->(dbSetOrder(1))
						SB1->(dbSeek( xFilial("SB1") + (cAliasTop)->PRODUTO))
						If !(&(cFilUsrSB1))
							(cAliasTop)->(dbSkip())
							Loop
						EndIf
					EndIf


                    //Produto pai
                    IF LEN(ALLTRIM((cAliasTop)->PRODUTO)) > 8
                        CPRODPAI := Posicione("SB1",1,xFilial("SB1")+(cAliasTop)->PRODUTO,"B1_XCODPAI")
                        //aRetPai := pesqpai(CPRODPAI)
						If Ascan(aProdPai,{|x| Alltrim(x[1]) == Alltrim(CPRODPAI)}) == 0 .And. !Empty(CPRODPAI)
                            If len(aProdPai) > 0 .And. cBkpCPai <> Alltrim(CPRODPAI) 
                                iF  !aProdPai[len(aProdPai),05]
                                    totPai(aProdPai,oSection1,oSection3,oReport)
                                ENDIF
                            EndIf 
                            cBkpCPai := Alltrim(CPRODPAI)
                            Aadd(aProdPai,{Alltrim(CPRODPAI),0,0,0,.F.,Posicione("SB1",1,xFilial("SB1")+Alltrim(CPRODPAI),"B1_DESC")})
                        EndIf
                        
                    Else 
                        If len(aProdPai) > 0 .And. cBkpCPai <> ALLTRIM((cAliasTop)->PRODUTO) .And. !aProdPai[len(aProdPai),05]
                            totPai(aProdPai,oSection1,oSection3,oReport)
                        EndIf 

                        cBkpCPai := ALLTRIM((cAliasTop)->PRODUTO)
                    EndIf 

                    If !Empty(cFilUsrSB2)
                        DbSelectArea("SB2")
                        SB2->(dbSetOrder(1))
                        SB2->(dbSeek( xFilial("SB2") + (cAliasTop)->PRODUTO))
                        If !(&(cFilUsrSB2))
                            (cAliasTop)->(dbSkip())
                            Loop
                        EndIf
                    EndIf

                    dbSelectArea("SB2")
                    If !dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))
                        dbSelectArea(cAliasTop)
                        dbSkip()
                        Loop
                    EndIf


                    dbSelectArea(cAliasTop)
                    cProdAnt  := (cAliasTop)->PRODUTO
                    cLocalAnt := alltrim(SB2->B2_LOCAL)

                    lFirst:=.F.

                    MR900ImpS1(@aSalAtu,cAliasTop,.T.,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport)

					If len(aProdPai) > 0
						If Alltrim(aProdPai[len(aProdPai),01]) == substr(cProdAnt,1,8)
							aProdPai[len(aProdPai),04] += aSalAtu[1]
						endif 
					endif 

                    oSection3:Init()

                    While !oReport:Cancel() .And. !(cAliasTop)->(Eof()) .And. (cAliasTop)->PRODUTO = cProdAnt .And. If(lCusFil .Or. lCusEmp .Or. lLocProc,.T.,IIf(alltrim((cAliasTop)->ARQ) <> 'SB1',alltrim((cAliasTop)->ARMAZEM)==cLocalAnt,.T.))
                        oReport:IncMeter()
                        lContinua := .F.
                        lImpSMov  := .F.
						aAuxPrt   := {}

                        If Alltrim((cAliasTop)->ARQ) $ "SD1/SD2"
                            lFirst:=.T.
                        ElseIf Alltrim((cAliasTop)->ARQ) == "SD3"
                            lFirst:=.T.
                            lInverteMov:=.F.
                            If alltrim((cAliasTop)->ARMAZEM) != cLocalAnt .Or. lCusFil .Or. lCusEmp
                                If !(Substr((cAliasTop)->CF,3,1) == "3")
                                    If !(lCusFil .Or. lCusEmp)
                                        dbSkip()
                                        Loop
                                    EndIf
                                ElseIf lPriApropri
                                    lInverteMov:=.T.
                                EndIf
                            EndIf
                    
                            If mv_par13 == 2 .And. Substr((cAliasTop)->CF,3,1) == "4"

                                lTransEnd := .T.
                                If Localiza((cAliasTOP)->PRODUTO)
                                    cNumSeqTr  := (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM)
                                    aDadosTran := {(cAliasTOP)->TES,;
                                        (cAliasTOP)->QUANTIDADE,;
                                        (cAliasTOP)->CUSTO,;
                                        (cAliasTOP)->QUANT2UM,;
                                        (cAliasTOP)->TIPO,;
                                        (cAliasTOP)->DTDIGIT,;
                                        (cAliasTOP)->CF,;
                                        (cAliasTOP)->SEQUENCIA,;
                                        (cAliasTOP)->DOCUMENTO,;
                                        (cAliasTOP)->PRODUTO,;
                                        (cAliasTOP)->OP,;
                                        (cAliasTOP)->PROJETO,;
                                        (cAliasTOP)->CC,;
                                        alltrim((cAliasTOP)->ARQ),;
                                        (cAliasTOP)->ARMAZEM}
                                    dbSkip()
                                    If (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM) == cNumSeqTr
                                        dbSkip()
                                        Loop
                                    Else
                                        lContinua := .T.
                                        If lFirst
                                            oSection3:Cell("dDtMov"):SetValue(STOD(aDadosTran[6]))
                                            oSection3:Cell("cTES"):SetValue(aDadosTran[1])
                                            oSection3:Cell("cLocal"):SetValue(aDadosTran[15])

											Aadd(aAuxPrt,STOD(aDadosTran[6]))
											Aadd(aAuxPrt,aDadosTran[1])
											Aadd(aAuxPrt,aDadosTran[15])
											

                                            If ( cPaisLoc=="BRA" )
                                                oSection3:Cell("cCF"):Show()
                                                If	lInverteMov
                                                    oSection3:Cell("cCF"):SetValue(Substr(aDadosTran[7],1,3)+"*")

													Aadd(aAuxPrt,Substr(aDadosTran[7],1,3)+"*")
                                                Else
                                                    oSection3:Cell("cCF"):SetValue(aDadosTran[7])

													Aadd(aAuxPrt,aDadosTran[7])
                                                EndIf
                                            Else
                                                oSection3:Cell("cCF"):Hide()
                                                oSection3:Cell("cCF"):SetValue("   ")

												Aadd(aAuxPrt,"   ")
                                            EndIf
                                            If mv_par09 $ "Ss"
                                                oSection3:Cell("cDoc"):SetValue(aDadosTran[8])

												Aadd(aAuxPrt,aDadosTran[8])
                                            Else
                                                oSection3:Cell("cDoc"):SetValue(aDadosTran[9])

												Aadd(aAuxPrt,aDadosTran[9])
                                            Endif
                                        EndIf



                                        If aDadosTran[1] <= "500"
                                            oSection3:Cell("nENTQtd"):Show()
                                            oSection3:Cell("nENTCus"):Show()
                                            oSection3:Cell("nCusMov"):Show()

                                            oSection3:Cell("nENTQtd"):SetValue(aDadosTran[2])
                                            oSection3:Cell("nENTCus"):SetValue(aDadosTran[3])
                                            oSection3:Cell("nCusMov"):SetValue(aDadosTran[3] / aDadosTran[2])

                                            oSection3:Cell("nSAIQtd"):Hide()
                                            oSection3:Cell("nSAICus"):Hide()
                                            oSection3:Cell("nSAIQtd"):SetValue(0)
                                            oSection3:Cell("nSAICus"):SetValue(0)

											Aadd(aAuxPrt,aDadosTran[2])
											Aadd(aAuxPrt,aDadosTran[3])
											Aadd(aAuxPrt,aDadosTran[3] / aDadosTran[2])
											Aadd(aAuxPrt,0)
											Aadd(aAuxPrt,0)

                                            
                                            nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                            
                                            If nPosPai > 0
                                                aProdPai[nPosPai,02] += aDadosTran[2]
                                            EndIf 

                                            aSalAtu[1] += aDadosTran[2]
                                            aSalAtu[mv_par10+1] += aDadosTran[3]
                                            aSalAtu[7] += aDadosTran[4]
                                        Else
                                            oSection3:Cell("nENTQtd"):Hide()
                                            oSection3:Cell("nENTCus"):Hide()
                                            oSection3:Cell("nENTQtd"):SetValue(0)
                                            oSection3:Cell("nENTCus"):SetValue(0)

                                            oSection3:Cell("nCusMov"):Show()
                                            oSection3:Cell("nSAIQtd"):Show()
                                            oSection3:Cell("nSAICus"):Show()

                                            oSection3:Cell("nCusMov"):SetValue(aDadosTran[3] / aDadosTran[2])
                                            oSection3:Cell("nSAIQtd"):SetValue(aDadosTran[2])
                                            oSection3:Cell("nSAICus"):SetValue(aDadosTran[3])


											Aadd(aAuxPrt,0)
											Aadd(aAuxPrt,0)
											Aadd(aAuxPrt,aDadosTran[3] / aDadosTran[2])
											Aadd(aAuxPrt,aDadosTran[2])
											Aadd(aAuxPrt,aDadosTran[3])

                                            nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                            
                                            If nPosPai > 0
                                                aProdPai[nPosPai,03] += aDadosTran[2]
                                            EndIf 
                                            

                                            aSalAtu[1] -= aDadosTran[2]
                                            aSalAtu[mv_par10+1] -= aDadosTran[3]
                                            aSalAtu[7] -= aDadosTran[4]
                                        EndIf

                                        lTransEnd := .T.
                                    EndIf
                                EndIf
                            EndIf
                        EndIf

                        If lFirst .And. !lContinua .And. lTransEnd
                            oSection3:Cell("dDtMov"):SetValue(STOD(DTDIGIT))
                            oSection3:Cell("cTES"):SetValue(TES)
                            oSection3:Cell("cLocal"):SetValue(ARMLOC)

							Aadd(aAuxPrt,STOD(DTDIGIT))
							Aadd(aAuxPrt,TES)
							Aadd(aAuxPrt,ARMLOC)

                            If ( cPaisLoc=="BRA" )
                                oSection3:Cell("cCF"):Show()
                                oSection3:Cell("cCF"):SetValue(CF)
								
								Aadd(aAuxPrt,CF)

                                If	lInverteMov
                                    oSection3:Cell("cCF"):SetValue(Substr(CF,1,3)+"*")

									Aadd(aAuxPrt,Substr(CF,1,3)+"*")
                                Else
                                    oSection3:Cell("cCF"):SetValue(CF)

									Aadd(aAuxPrt,CF)
                                EndIf
                            Else
                                oSection3:Cell("cCF"):Hide()
                                oSection3:Cell("cCF"):SetValue("   ")
								Aadd(aAuxPrt," ")
                            EndIf
                            If mv_par09 $ "Ss"
                                oSection3:Cell("cDoc"):SetValue(SEQUENCIA)
								
								Aadd(aAuxPrt,SEQUENCIA)

                            Else
                                oSection3:Cell("cDoc"):SetValue(DOCUMENTO)

								Aadd(aAuxPrt,DOCUMENTO)
                            Endif
                        EndIf

                        Do Case
                        Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
                            lDev:=MTR900Dev("SD1",cAliasTop)
                            If (cAliasTOP)->TES <= "500" .And. !lDev
                                If (cAliasTOP)->TIPONF != "C"
                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

                                    oSection3:Cell("nCusMov"):Show()
                                Else
                                    oSection3:Cell("nCusMov"):SetValue(0)
									
									Aadd(aAuxPrt,0)

                                    oSection3:Cell("nCusMov"):Hide()
                                EndIf

                                oSection3:Cell("nENTQtd"):Show()
                                oSection3:Cell("nENTCus"):Show()

                                oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)

								Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
								Aadd(aAuxPrt,(cAliasTOP)->CUSTO)

                                oSection3:Cell("nSAIQtd"):Hide()
                                oSection3:Cell("nSAICus"):Hide()
                                oSection3:Cell("nSAIQtd"):SetValue(0)
                                oSection3:Cell("nSAICus"):SetValue(0)

								Aadd(aAuxPrt,0)
								Aadd(aAuxPrt,0)


                                nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                            
                                If nPosPai > 0
                                    aProdPai[nPosPai,02] += (cAliasTOP)->QUANTIDADE
                                EndIf 
                                

                                aSalAtu[1] += (cAliasTOP)->QUANTIDADE
                                aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
                                aSalAtu[7] += (cAliasTOP)->QUANT2UM
                            Else
                                If (cAliasTOP)->TIPONF != "C"
                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

                                    oSection3:Cell("nCusMov"):Show()
                                Else
                                    oSection3:Cell("nCusMov"):SetValue(0)

									Aadd(aAuxPrt,0)

                                    oSection3:Cell("nCusMov"):Hide()
                                EndIf

                                oSection3:Cell("nENTQtd"):Hide()
                                oSection3:Cell("nENTCus"):Hide()
                                oSection3:Cell("nENTQtd"):SetValue(0)
                                oSection3:Cell("nENTCus"):SetValue(0)

								Aadd(aAuxPrt,0)
								Aadd(aAuxPrt,0)
								
                                oSection3:Cell("nSAIQtd"):Show()
                                oSection3:Cell("nSAICus"):Show()

                                If lDev
                                    oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE * -1)
                                    oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO * -1)

									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE * -1)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO * -1)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                    If nPosPai > 0
                                        aProdPai[nPosPai,03] += (cAliasTOP)->QUANTIDADE
                                    EndIf 
                                    

                                    aSalAtu[1] += (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
                                    aSalAtu[7] += (cAliasTOP)->QUANT2UM
                                Else
                                    oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)

									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                    If nPosPai > 0
                                        aProdPai[nPosPai,03] -= (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1] 			-= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
                                EndIf
                            EndIf
                        Case Alltrim((cAliasTop)->ARQ) = "SD2" .And. !lContinua .And. lTransEnd
                            lDev:=MTR900Dev("SD2",cAliasTop)
                            If (cAliasTOP)->TES <= "500" .Or. lDev
                                If lDev
                                    oSection3:Cell("nENTQtd"):Show()
                                    oSection3:Cell("nENTCus"):Show()

                                    oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE * -1)
                                    oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO * -1)

									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE * -1)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO * -1)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                    If nPosPai > 0
                                        aProdPai[nPosPai,02] -= (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1] 			-= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
                                Else
                                    oSection3:Cell("nENTQtd"):Show()
                                    oSection3:Cell("nENTCus"):Show()

                                    oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)

									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                    If nPosPai > 0
                                        aProdPai[nPosPai,02] += (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
                                EndIf

                                If (cAliasTOP)->TIPONF != "C"
                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

                                    oSection3:Cell("nCusMov"):Show()
                                Else
                                    oSection3:Cell("nCusMov"):SetValue(0)
									
									Aadd(aAuxPrt,0)

                                    oSection3:Cell("nCusMov"):Hide()
                                EndIf
                                oSection3:Cell("nSAIQtd"):Hide()
                                oSection3:Cell("nSAICus"):Hide()
                                oSection3:Cell("nSAIQtd"):SetValue(0)
                                oSection3:Cell("nSAICus"):SetValue(0)

								Aadd(aAuxPrt,0)
								Aadd(aAuxPrt,0)

                            Else
                                If (cAliasTOP)->TIPONF != "C"
                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

                                    oSection3:Cell("nCusMov"):Show()
                                Else
                                    oSection3:Cell("nCusMov"):SetValue(0)

									Aadd(aAuxPrt,0)

                                    oSection3:Cell("nCusMov"):Hide()
                                EndIf

                                oSection3:Cell("nENTQtd"):Hide()
                                oSection3:Cell("nENTCus"):Hide()
                                oSection3:Cell("nENTQtd"):SetValue(0)
                                oSection3:Cell("nENTCus"):SetValue(0)

								Aadd(aAuxPrt,0)
								Aadd(aAuxPrt,0)
								
                                oSection3:Cell("nSAIQtd"):Show()
                                oSection3:Cell("nSAICus"):Show()

                                oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)

								Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
								Aadd(aAuxPrt,(cAliasTOP)->CUSTO)


                                nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                If nPosPai > 0
                                    aProdPai[nPosPai,02] -= (cAliasTOP)->QUANTIDADE
                                EndIf

                                aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
                                aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
                                aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
                            EndIf
                        Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua  .And. lTransEnd
                            lDev := .F.
                            If	lInverteMov
                                If (cAliasTOP)->TES > "500"
                                    oSection3:Cell("nENTQtd"):Show()
                                    oSection3:Cell("nENTCus"):Show()
                                    oSection3:Cell("nCusMov"):Show()

                                    oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)
                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

                                    oSection3:Cell("nSAIQtd"):Hide()
                                    oSection3:Cell("nSAICus"):Hide()
                                    oSection3:Cell("nSAIQtd"):SetValue(0)
                                    oSection3:Cell("nSAICus"):SetValue(0)

									Aadd(aAuxPrt,0)
									Aadd(aAuxPrt,0)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                    If nPosPai > 0
                                        aProdPai[nPosPai,02] += (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
                                Else
                                    oSection3:Cell("nENTQtd"):Hide()
                                    oSection3:Cell("nENTCus"):Hide()
                                    oSection3:Cell("nENTQtd"):SetValue(0)
                                    oSection3:Cell("nENTCus"):SetValue(0)

									Aadd(aAuxPrt,0)
									Aadd(aAuxPrt,0)

                                    oSection3:Cell("nCusMov"):Show()
                                    oSection3:Cell("nSAIQtd"):Show()
                                    oSection3:Cell("nSAICus"):Show()

                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)

									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                        
                                    If nPosPai > 0
                                        aProdPai[nPosPai,03] += (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
                                EndIf
                                If lCusFil .Or. lCusEmp
                                    lPriApropri:=.F.
                                EndIf
                            Else
                                If (cAliasTOP)->TES <= "500"
                                    oSection3:Cell("nENTQtd"):Show()
                                    oSection3:Cell("nENTCus"):Show()
                                    oSection3:Cell("nCusMov"):Show()

                                    oSection3:Cell("nENTQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nENTCus"):SetValue((cAliasTOP)->CUSTO)
                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)

                                    oSection3:Cell("nSAIQtd"):Hide()
                                    oSection3:Cell("nSAICus"):Hide()
                                    oSection3:Cell("nSAIQtd"):SetValue(0)
                                    oSection3:Cell("nSAICus"):SetValue(0)

									Aadd(aAuxPrt,0)
									Aadd(aAuxPrt,0)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                    
                                    If nPosPai > 0
                                        aProdPai[nPosPai,02] += (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
                                Else
                                    oSection3:Cell("nENTQtd"):Hide()
                                    oSection3:Cell("nENTCus"):Hide()
                                    oSection3:Cell("nENTQtd"):SetValue(0)
                                    oSection3:Cell("nENTCus"):SetValue(0)

									Aadd(aAuxPrt,0)
									Aadd(aAuxPrt,0)

                                    oSection3:Cell("nCusMov"):Show()
                                    oSection3:Cell("nSAIQtd"):Show()
                                    oSection3:Cell("nSAICus"):Show()

                                    oSection3:Cell("nCusMov"):SetValue((cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nSAIQtd"):SetValue((cAliasTOP)->QUANTIDADE)
                                    oSection3:Cell("nSAICus"):SetValue((cAliasTOP)->CUSTO)

									Aadd(aAuxPrt,(cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->QUANTIDADE)
									Aadd(aAuxPrt,(cAliasTOP)->CUSTO)

                                    nPosPai := Ascan(aProdPai,{|x| alltrim(x[1]) == substr((cAliasTOP)->PRODUTO,1,8)})
                                        
                                    If nPosPai > 0
                                        aProdPai[nPosPai,03] -= (cAliasTOP)->QUANTIDADE
                                    EndIf

                                    aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
                                    aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
                                    aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
                                EndIf
                                If lCusFil .Or. lCusEmp
                                    lPriApropri:=.T.
                                EndIf
                            EndIf
                        EndCase
                        If lFirst  .And. lTransEnd
                            oSection3:Cell("nSALDQtd"):SetValue(aSalAtu[1])
                            oSection3:Cell("nSALDCus"):SetValue(aSalAtu[mv_par10+1])

							Aadd(aAuxPrt,aSalAtu[1])
							Aadd(aAuxPrt,aSalAtu[mv_par10+1])

                        EndIf
                        Do Case
                        Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua  .And. lTransEnd
                            If Empty((cAliasTOP)->OP) .And. Empty((cAliasTOP)->PROJETO)
                                oSection3:Cell("cCCPVPJOP"):SetValue('CC'+(cAliasTOP)->CC)

								Aadd(aAuxPrt,'CC'+(cAliasTOP)->CC)
                            ElseIf !Empty((cAliasTOP)->PROJETO)
                                oSection3:Cell("cCCPVPJOP"):SetValue('PJ'+(cAliasTOP)->PROJETO)

								Aadd(aAuxPrt,'PJ'+(cAliasTOP)->PROJETO)

                            ElseIf !Empty((cAliasTOP)->OP)
                                cIdent := fIdentOS( (cAliasTOP)->OP, lFuncMnt )
                                oSection3:Cell("cCCPVPJOP"):SetValue( cIdent )

								Aadd(aAuxPrt,cIdent)
                            EndIf
                        Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
                            cTipoNf := 'F-'
                            SD1->(dbGoTo((cAliasTop)->NRECNO))
                            SD2->(dbSetOrder(3))
                            If SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA))
                                If SD2->D2_TIPO <> 'B'
                                    cTipoNf := 'C-'
                                EndIf
                            EndIf
                            oSection3:Cell("cCCPVPJOP"):SetValue(cTipoNf+(cAliasTOP)->FORNECEDOR)

							Aadd(aAuxPrt,cTipoNf+(cAliasTOP)->FORNECEDOR)

                        Case Alltrim((cAliasTop)->ARQ) == "SD2" .And. !lContinua .And. lTransEnd
                    
                            If ((cAliasTop)->TIPONF) $ "B|D"
                                oSection3:Cell("cCCPVPJOP"):SetValue('F-'+(cAliasTop)->FORNECEDOR)

								Aadd(aAuxPrt,'F-'+(cAliasTop)->FORNECEDOR)

                            Else
                                oSection3:Cell("cCCPVPJOP"):SetValue('C-'+(cAliasTop)->FORNECEDOR)

								Aadd(aAuxPrt,'C-'+(cAliasTop)->FORNECEDOR)

                            EndIf
                    
                        Case lContinua .And. aDadosTran[14] == "SD3" .And. lTransEnd
                            If Empty(aDadosTran[11]) .And. Empty(aDadosTran[12])
                                oSection3:Cell("cCCPVPJOP"):SetValue('CC'+aDadosTran[13])

								Aadd(aAuxPrt,'CC'+aDadosTran[13])

                            ElseIf !Empty(aDadosTran[12])
                                oSection3:Cell("cCCPVPJOP"):SetValue('PJ'+aDadosTran[12])

								Aadd(aAuxPrt,'PJ'+aDadosTran[12])

                            ElseIf !Empty(aDadosTran[11])
                                cIdent := fIdentOS( aDadosTran[11], lFuncMnt )
                                oSection3:Cell("cCCPVPJOP"):SetValue( cIdent )

								Aadd(aAuxPrt,cIdent)
                            EndIf
                        EndCase

                        // Tratamento para impressao em formato tabela quanto o produto nao tiver movimentacao
                        If lFormTab .And. Iif(len(aDadosTran) >13, Alltrim(aDadosTran[14]) == "SB1",Alltrim((cAliasTop)->ARQ) == "SB1")
                            oSection3:Cell("dDtMov"):SetValue(STOD(""))
                            oSection3:Cell("cLocal"):SetValue("")
                            oSection3:Cell("cTES"):SetValue("")
                            oSection3:Cell("cCF"):SetValue("")
                            oSection3:Cell("cDoc"):SetValue("")
                            oSection3:Cell("nENTQtd"):SetValue(0)
                            oSection3:Cell("nENTCus"):SetValue(0)
                            oSection3:Cell("nCusMov"):SetValue(0)
                            oSection3:Cell("nSAIQtd"):SetValue(0)
                            oSection3:Cell("nSAICus"):SetValue(0)
                            oSection3:Cell("nSALDQtd"):SetValue(0)
                            oSection3:Cell("nSALDCus"):SetValue(0)
                            oSection3:Cell("cCCPVPJOP"):SetValue("")

							Aadd(aAuxPrt,STOD(""))
							Aadd(aAuxPrt,"")
							Aadd(aAuxPrt,"")
							Aadd(aAuxPrt,"")
							Aadd(aAuxPrt,"")
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,0)
							Aadd(aAuxPrt,"")
                            oSection3:PrintLine()

							Aadd(aPrintT,aAuxPrt)
							aAuxPrt := {}
                        EndIf

                        If lFirst .And. lTransEnd
                            oSection3:PrintLine()
							Aadd(aPrintT,aAuxPrt)
							aAuxPrt := {}
                        Endif
                        aDadosTran := {}
                        lTransEnd := .T.

                        If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
                            If !lContinua //Acerto para utilizar o Array aDadosTranf[]
                                dbSkip()
                            EndIf
                        EndIf
                    EndDo
                    //aqui2

                    If lFirst
                        oReport:PrintText(STR0022+TransForm(aSalAtu[7],cPicB2Qt2),,oSection3:Cell('nSAICus'):ColPos()) //"QTD. NA SEGUNDA UM: "
                    Else
                        If !MTR900IsMNT()
                            oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
                            oReport:ThinLine()
                            lImpSMov := .T.
                        Else
                            aProdsMNT := aClone(NGProdMNT())
                            If aScan(aProdsMNT, {|x| AllTrim(x) == AllTrim(SB1->B1_COD) }) == 0
                                oReport:PrintText(STR0023)	//"NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
                                oReport:ThinLine()
                                lImpSMov := .T.
                            EndIf
                        EndIf
                    EndIf
                    //endif
                    oSection1:Finish()
                    oSection2:Finish()
                    If !lImpSMov .Or. (lFormTab .And. Alltrim((cAliasTop)->ARQ) == "SB1")
                        oSection3:Finish()
                    Endif
                    //ENDIF
                EndDo

                dbSelectArea(cAliasTop)

			EndIf

		Next nForFilial

	EndIf

// Restaura Filial Corrente
	cFilAnt := cFilBack

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR900val³ Autor ³ Paulo Boschetti       ³ Data ³ 22.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida parametro mv_par09 - (d)OCUMENTO/(s)EQUENCIA        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function Mtr900val()
	Local lRet := .T.

	If mv_par09 $ "dsDS"
		lRet := .T.
	Else
		lRet := .F.
	EndIf

	If IsInCallStack("MATR902") .and. mv_par09 $ "Ee"
		lRet := .T.
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR900Dev³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 17/07/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se item pertence a uma nota de devolu‡ao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR900Dev(ExpC1,ExpC2)				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias                                              ³±±
±±³          ³ ExpC2 = Alias Top                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR900                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR900Dev(cAlias,cAliasTop)
	Static lListaDev := NIL

	Local lRet:=.F.
	Local cSeek:= If(!Empty(cAliasTop),(cAliasTop)->DOCUMENTO+(cAliasTop)->SERIE+(cAliasTop)->FORNECEDOR+(cAliasTop)->LOJA,"")

	// Identifica se lista dev. na mesma coluna
	lListaDev := If(ValType(lListaDev)#"L",GetMV("MV_LISTDEV"),lListaDev)

	If lListaDev .And. cAlias == "SD1"
		dbSelectArea("SF1")
		If Empty(cSeek)
			cSeek:=SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		EndIf
		If dbSeek(xFilial("SF1") + cSeek) .And. SF1->F1_TIPO == "D"
			lRet:=.T.
		EndIf
	ElseIf lListaDev .And. cAlias == "SD2"
		dbSelectArea("SF2")
		If Empty(cSeek)
			cSeek:=+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		EndIf
		If dbSeek(xFilial("SF2") + cSeek) .And. SF2->F2_TIPO == "D"
			lRet:=.T.
		EndIf
	EndIf
	dbSelectArea(If(Empty(cAliasTop),cAlias,cAliasTop))
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR900VAlm ³ Autor ³Rodrigo de A. Sartorio ³ Data ³26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Almoxarifado do KARDEX com relacao a custo unificado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR900                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function MTR900VAlm()
	Local lRet:=.T.
	Local cConteudo:=&(ReadVar())
	Local nOpc:=2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
	//|utiliza custo unificado por:                                  |
	//|      F = Custo Unificado por Filial                          |
	//|      E = Custo Unificado por Empresa                         |
	//|      A = Custo Unificado por Armazem                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
	Local lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

	If lCusFil .And. cConteudo != Repl("*",TamSX3("B2_LOCAL")[1])
		nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten‡„o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
		If nOpc == 2
			lRet:=.F.
		EndIf
	EndIf
	If lCusEmp .And. cConteudo != Repl("#",TamSX3("B2_LOCAL")[1])
		nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten‡„o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
		If nOpc == 2
			lRet:=.F.
		EndIf
	EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR900ImpS1³ Autor ³ Nereu Humberto Junior ³ Data ³ 25/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a secao 1 e 2 (Dados do produto)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MR900ImpS1(@ExpA1,ExpC1,ExpL1,ExpL2,ExpL3,ExpO1,ExpO2,ExpO3)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do saldo inicial do item     ³±±
±±³          ³   [1] = Saldo inicial em quantidade                        ³±±
±±³          ³   [2] = Saldo inicial em valor                             ³±±
±±³          ³   [3] = Saldo inicial na 2a unidade de medida              ³±±
±±³          ³ ExpC1 = Alias                                              ³±±
±±³          ³ ExpL1 = Top                                                ³±±
±±³          ³ ExpL2 = Veiculo                                            ³±±
±±³          ³ ExpL3 = Custo Unificado                                    ³±±
±±³          ³ ExpO1 = Secao 1                                            ³±±
±±³          ³ ExpO2 = Secao 2                                            ³±±
±±³          ³ ExpO3 = obj Report                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR900                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR900ImpS1(aSalAtu,cAliasTop,lQuery,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport)

	Local aArea     := GetArea()
	Local nCusMed   := 0
	Local i         := 0
	Local nIndice   := 0
	Local aSalAlmox := {}
	Local cSeek     := ""
	Local cFilBkp   := cFilAnt
	Local cTrbSB2	:= CriaTrab(,.F.)

	Default lQuery   := .F.
	Default cAliasTop:="SB1"
	Default lCusFil  := .F.
	default lCusEmp  := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o Saldo Inicial do Produto             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCusFil
		aArea:=GetArea()
		aSalAtu  := { 0,0,0,0,0,0,0 }
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(cSeek:=xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
		While !Eof() .And. B2_FILIAL+B2_COD == cSeek
			aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
			For i:=1 to Len(aSalAtu)
				aSalAtu[i] += aSalAlmox[i]
			Next i
			dbSkip()
		End
		RestArea(aArea)
	ElseIf lCusEmp
		aArea:=GetArea()
		aSalAtu  := { 0,0,0,0,0,0,0 }
		dbSelectArea("SB2")
		dbSetOrder(1)
		INDREGUA("SB2",cTrbSB2,"B2_COD+B2_LOCAL",,,STR0019)	//"Selecionando Registros"
		nIndice := RetIndex("SB2")
		dbSetOrder(nIndice+1)
		dbSeek(cSeek:=If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
		While !Eof() .And. SB2->B2_COD == cSeek
			If !Empty(xFilial("SB2"))
				cFilAnt:=SB2->B2_FILIAL
			EndIf
			aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
			For i:=1 to Len(aSalAtu)
				aSalAtu[i] += aSalAlmox[i]
			Next i
			dbSkip()
		End
		dbSelectArea("SB2")
		If !Empty(cTrbSB2) .And. File(cTrbSB2 + OrdBagExt())
			RetIndex("SB2")
			Ferase(cTrbSB2+OrdBagExt())
		EndIf
		cFilAnt := cFilBkp
		RestArea(aArea)
	Else
		aSalAtu := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),mv_par08,mv_par05,,, ( lCusRep .And. mv_par17==2 ) )
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o Custo de Reposicao do Produto        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCusRep .And. mv_par17==2
		aSalAtu := {aSalAtu[1],aSalAtu[18],aSalAtu[19],aSalAtu[20],aSalAtu[21],aSalAtu[22],aSalAtu[07]}
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o Custo Medio do Produto               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SB2->(dbSetOrder(1))
	SB2->(MsSeek(xFilial("SB2") + If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD)))
	If aSalAtu[1] > 0
		nCusmed := aSalAtu[mv_par10+1]/aSalAtu[1]
	ElseIf aSalAtu[1] == 0 .and. aSalAtu[mv_par10+1] == 0
		nCusMed := 0
	Else
		nCusmed := &(Eval(bBloco,"SB2->B2_CM",mv_par10))
	EndIf

	oSection1:Init()
	oSection2:Init()

	oSection1:Cell("nCusMed" ):SetValue(nCusMed)
	oSection1:Cell("nQtdSal" ):SetValue(aSalAtu[1])
	oSection1:Cell("nVlrSal" ):SetValue(aSalAtu[mv_par10+1])
	oSection1:Cell("cProduto"):SetValue((cAliasTop)->PRODUTO)
	oSection1:Cell("cTipo"	 ):SetValue((cAliasTop)->TIPO	)

	Aadd(aAuxPrt,nCusMed)
	Aadd(aAuxPrt,aSalAtu[1])
	Aadd(aAuxPrt,aSalAtu[mv_par10+1])
	Aadd(aAuxPrt,(cAliasTop)->PRODUTO)
	Aadd(aAuxPrt,(cAliasTop)->TIPO)

	If lVEIC
		oSection2:Cell("cProduto"):SetValue((cAliasTop)->PRODUTO)
		oSection2:Cell("cTipo"	 ):SetValue((cAliasTop)->TIPO	)
	Endif

	dbSelectArea("SB2")
	MsSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))

	Aadd(aPrintT,aAuxPrt)

	aAuxPrt := {}

	oSection1:PrintLine()
	
	RestArea(aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR900IsMNT³ Autor ³ Lucas                ³ Data ³ 03.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se ha integração com o modulo SigaMNT/NG          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR900                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR900IsMNT()
	Local aArea      := {}
	Local aAreaSB1   := {}
	Local aProdsMNT  := {}
	Local nX         := 0
	Local lIntegrMNT := .F.

	//Esta funcao encontra-se no modulo Manutencao de Ativos (NGUTIL05.PRX), e retorna os produtos (pode ser MAIS de UM), dos parametros de
	//Manutencao - "M" (MV_PRODMNT) / Terceiro - "T" (MV_PRODTER) / ou Ambos - "*" ou em branco
	aProdsMNT := aClone(NGProdMNT("M"))
	If Len(aProdsMNT) > 0
		aArea	 := GetArea()
		aAreaSB1 := SB1->(GetArea())
		SB1->(dbSelectArea( "SB1" ))
		SB1->(dbSetOrder(1))
		For nX := 1 To Len(aProdsMNT)
			If SB1->(MsSeek( xFilial("SB1") + aProdsMNT[nX] ))
				lIntegrMNT := .T.
				Exit
			EndIf
		Next nX
		RestArea(aAreaSB1)
		RestArea(aArea)
	EndIf
Return( lIntegrMNT )

//----------------------------------------------------
/*/{Protheus.doc} fIdentOS
Retorna descrição referente a OP ou Ordem de serviço

@autor Maria Elisandra de Paula
@since 15/07/2021
@param cOp, string, número da ordem de produção
@param lFuncMnt, boolean, se existe função
@return string
/*/
//----------------------------------------------------
Static Function fIdentOS( cOp, lFuncMnt )
	Local aArea := {}
	Local cRet  := 'OP' + cOp

	If lFuncMnt

		If SubStr(cOP,7,2) == "OS"
			aArea := GetArea()

			dbSelectArea('STJ')
			dbSetOrder(1)
			If dbSeek( xFilial('STJ') + SubStr(cOp,1,6) )
				cRet := MNTDESCOS( STJ->TJ_ORDEM, STJ->TJ_CCUSTO )
			EndIf

			RestArea( aArea )
		EndIf
	EndIf

Return cRet

//QUERY PRODUTO PAI
STATIC FUNCTION pesqpai(CPRODPAI)

	Local cSelPAID1 := '', cWhpaiD1 := '', cWhpaiD1C := ''
	Local cSelPAID2 := '', cWhpaiD2 := '', cWhpaiD2C := ''
	Local cSelPAID3 := '', cWhpaiD3 := '', cWhpaiD3C := ''
	Local cSelpaiVe := '%%', cUnionPai := '%%'
	Local cWhPaiB1A:= " "
	Local cWhPaiB1B:= " "
	Local cWhPaiB1C:= " "
	Local cWhPaiB1D:= " "

	Local cQupaiB1A:= " "
	Local cQupaiB1B:= " "
	Local cQupaiB1C:= " "
	Local cQupaiB1D:= " "
	Local nFils := 0
	Local lVEIC        := Upper(GetMV("MV_VEICULO"))=="S"
	Local lWmsNew	:= SuperGetMv("MV_WMSNEW",.F.,.F.)
	Local lD3Servi	:= IIF(lWmsNew,.F.,GetMV('MV_D3SERVI',.F.,'N')=='N')
	Local lLocProc  := mv_par08 == GetMvNNR('MV_LOCPROC','99')
	Local cProdImp := GetMV("MV_PRODIMP")
	Local cAliasPAI := GetNextAlias()
	Local lTransEnd := .T.
	Local aRet := {}
	Local nCustoPai := 0
	local nQuantPai := 0
	local nCusPai := 0
	DEFAULT CPRODPAI := NIL

	If lCusRep .And. mv_par17==2
		cSelPAID1 := "% D1_CUSRP"
		cSelPAID1 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
	Else
		cSelPAID1 := "% D1_CUSTO"
		If mv_par10 > 1
			cSelPAID1 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
		EndIf
	EndIf
	cSelPAID1 += " CUSTO,"
	cSelPAID1 += "%"
	
	cSelpaiVe := "%"
	cSelpaiVe += ","
	If lVEIC
		cSelpaiVe += "SB1.B1_CODITE B1_CODITE,"
	EndIf
	cSelpaiVe += "%"
	
	cWhpaiD1 := "%"
	cWhpaiD1 += "AND"
	If !(lCusFil .Or. lCusEmp)
		cWhpaiD1 += " D1_LOCAL = '" + mv_par08 + "' AND"
	EndIf
	cWhpaiD1 += "%"
	
	If lCusEmp
		cWhpaiD1C := "%"
		If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SF4") == "E"
			cWhpaiD1C += " D1_FILIAL = F4_FILIAL AND "
		EndIf
		If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SB1") == "E"
			cWhpaiD1C += " D1_FILIAL = B1_FILIAL AND "
		EndIf
		For nFils := 1 to len(aFils)
			If nFils = 1
				cWhpaiD1C += " D1_FILIAL IN ('"+aFils[nFils]+"'"
			else
				cWhpaiD1C += ",'"+aFils[nFils]+"'"
			EndIf
			If nFils = len(aFils)
				cWhpaiD1C += ") AND "
			EndIf
		Next nFils
		cWhpaiD1C += "%"
	Else
		cWhpaiD1C := "%"
		cWhpaiD1C += " D1_FILIAL ='" + xFilial("SD1") + "' AND "
		cWhpaiD1C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
		cWhpaiD1C += "%"
	EndIf
	
	If lCusRep .And. mv_par17==2
		cSelPAID2 := "% D2_CUSRP"
		cSelPAID2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
	Else
		cSelPAID2 := "% D2_CUSTO"
		cSelPAID2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
	EndIf
	cSelPAID2 += " CUSTO,"
	cSelPAID2 += "%"
	
	cWhpaiD2 := "%"
	cWhpaiD2 += "AND"
	If !(lCusFil .Or. lCusEmp)
		cWhpaiD2 += " D2_LOCAL = '" + mv_par08 + "' AND"
	EndIf
	cWhpaiD2 += "%"
	
	If lCusEmp
		cWhpaiD2C := "%"
		If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SF4") == "E"
			cWhpaiD2C += " D2_FILIAL = F4_FILIAL AND "
		EndIf
		If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SB1") == "E"
			cWhpaiD2C += " D2_FILIAL = B1_FILIAL AND "
		EndIf
		For nFils := 1 to len(aFils)
			If nFils = 1
				cWhpaiD2C += " D2_FILIAL IN ('"+aFils[nFils]+"'"
			Else
				cWhpaiD2C += ",'"+aFils[nFils]+"'"
			EndIf
			If nFils = len(aFils)
				cWhpaiD2C += ") AND "
			EndIf
		Next nFils
		cWhpaiD2C += "%"
	Else
		cWhpaiD2C := "%"
		cWhpaiD2C += " D2_FILIAL ='" + xFilial("SD2") + "' AND "
		cWhpaiD2C += " SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND"
		cWhpaiD2C += "%"
	EndIf

	If lCusRep .And. mv_par17==2
		cSelPAID3 := "% D3_CUSRP"
		cSelPAID3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
	Else
		cSelPAID3 := "% D3_CUSTO"
		cSelPAID3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
	EndIf
	cSelPAID3 +=	" CUSTO,"
	cSelPAID3 += "%"
	
	cWhpaiD3 := "%"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cWhpaiD3 += " D3_ESTORNO <> 'S' AND"
	EndIf
	If lD3Servi .And. IntDL()
		cWhpaiD3 += " ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
		cWhpaiD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='" + cMvCQ + "') ) AND"
	EndIf
	If !(lCusFil .Or. lCusEmp) .And. !lLocProc
		cWhpaiD3 += " D3_LOCAL = '"+mv_par08+"' AND"
	EndIf
	If	!lVEIC
		cWhpaiD3+= " SB1.B1_XCODPAI = '"+CPRODPAI+"' AND"
	Else
		cWhpaiD3+= " SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"' AND"
	EndIf
	If lCusEmp
		cWhpaiD3 += " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
	Else
		cWhpaiD3 += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
	EndIf
	cWhpaiD3 += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
	cWhpaiD3 += " SB1.D_E_L_E_T_=' ' AND"
	cWhpaiD3 += "%"

	If lCusEmp
		cWhpaiD3C := "%"
		For nFils := 1 to len(aFils)
			If nFils = 1
				cWhpaiD3C += " D3_FILIAL IN ('"+aFils[nFils]+"'"
			Else
				cWhpaiD3C += ",'"+aFils[nFils]+"'"
			EndIf
			If nFils = len(aFils)
				cWhpaiD3C += ") AND %"
			EndIf
		Next nFils
	Else
		cWhpaiD3C := "%"
		cWhpaiD3C += " D3_FILIAL ='" + xFilial("SD3")  + "' AND "
		cWhpaiD3C += "%"
	EndIf

	cWhPaiB1A:= "%"
	cWhPaiB1B:= "%"
	cWhPaiB1C:= "%"
	cWhPaiB1D:= "%"
	If	!lVEIC
		cWhPaiB1A+= " AND SB1.B1_XCODPAI = '"+CPRODPAI+"'"
		cWhPaiB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"
		If lCusEmp
			cWhPaiB1C+= " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
			cWhPaiB1D+= " SB1EXS.B1_XCODPAI = '"+CPRODPAI+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
		Else
			cWhPaiB1C+= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
			cWhPaiB1D+= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_XCODPAI = '"+CPRODPAI+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
		EndIf
	Else
		cWhPaiB1A+= " AND SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"'"
		cWhPaiB1B+= " AND SB1.B1_COD = SB1EXS.B1_COD"
		If lCusEmp
			cWhPaiB1C+= " SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
			cWhPaiB1D+= " SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
		Else
			cWhPaiB1C+= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
			cWhPaiB1D+= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
		EndIf
	EndIf

	cWhPaiB1C += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
	cWhPaiB1C += " SB1.D_E_L_E_T_=' '"
	cWhPaiB1D += " SB1EXS.B1_GRUPO >= '"+mv_par14+"' AND SB1EXS.B1_GRUPO <= '"+mv_par15+"' AND SB1EXS.B1_COD <> '"+cProdimp+"' AND "
	cWhPaiB1D += " SB1EXS.D_E_L_E_T_=' '"

	cQupaiB1A:= Subs(cWhPaiB1A,2)
	cQupaiB1B:= Subs(cWhPaiB1B,2)
	cQupaiB1C:= Subs(cWhPaiB1C,2)
	cQupaiB1D:= Subs(cWhPaiB1D,2)

	cWhPaiB1A+= "%"
	cWhPaiB1B+= "%"
	cWhPaiB1C+= "%"
	cWhPaiB1D+= "%"

	cQuerPAD1 := " FROM "
	cQuerPAD1 += RetSqlName("SB1") + " SB1"
	cQuerPAD1 += (", " + RetSqlName("SD1")+ " SD1 ")
	cQuerPAD1 += (", " + RetSqlName("SF4")+ " SF4 ")
	cQuerPAD1 += " WHERE SB1.B1_COD = D1_COD"
	If lCusEmp
		If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SF4") == "E"
			cQuerPAD1 += " AND F4_FILIAL = D1_FILIAL "
		EndIf
	Else
		cQuerPAD1 += (" AND D1_FILIAL = '" + xFilial("SD1")+"'" )
		cQuerPAD1 += (" AND F4_FILIAL = '" + xFilial("SF4") + "'")
	EndIf
	cQuerPAD1 += (" AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'")
	cQuerPAD1 += (" AND D1_DTDIGIT >= '" + DTOS(mv_par05) + "'")
	cQuerPAD1 += (" AND D1_DTDIGIT <= '" + DTOS(mv_par06) + "'")
	cQuerPAD1 +=  " AND D1_ORIGLAN <> 'LF'"
	If !(lCusFil .Or. lCusEmp)
		cQuerPAD1 += " AND D1_LOCAL = '" + mv_par08 + "'"
	EndIf
	cQuerPAD1 += " AND SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"

	cQuerpaD2 := " FROM "
	cQuerpaD2 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD2")+ " SD2 , "+ RetSqlName("SF4")+" SF4 "
	cQuerpaD2 += " WHERE SB1.B1_COD = D2_COD "
	If lCusEmp
		If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SF4") == "E"
			cQuerpaD2 += " AND F4_FILIAL = D2_FILIAL "
		EndIf
	Else
		cQuerpaD2 += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
		cQuerpaD2 += " AND F4_FILIAL = '"+xFilial("SF4")+"' "
	EndIf
	cQuerpaD2 += " AND SD2.D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
	cQuerpaD2 += " AND D2_EMISSAO >= '"+DTOS(mv_par05)+"' AND D2_EMISSAO <= '"+DTOS(mv_par06)+"'"
	cQuerpaD2 += " AND D2_ORIGLAN <> 'LF'"
	If !(lCusFil .Or. lCusEmp)
		cQuerpaD2 += " AND D2_LOCAL = '"+mv_par08+"'"
	EndIf
	cQuerpaD2 += " AND SD2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"

	cQuerPAD3 := " FROM "
	cQuerPAD3 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD3")+ " SD3 "
	cQuerPAD3 += " WHERE SB1.B1_COD = D3_COD "
	If !lCusEmp
		cQuerPAD3 += " AND D3_FILIAL = '"+xFilial("SD3")+"' "
	EndIf
	cQuerPAD3 += " AND D3_EMISSAO >= '"+DTOS(mv_par05)+"' AND D3_EMISSAO <= '"+DTOS(mv_par06)+"'"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cQuerPAD3 += " AND D3_ESTORNO <> 'S'"
	EndIf
	If lD3Servi .And. IntDL()
		cQuerPAD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
		cQuerPAD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+ cMvCQ +"') )"
	EndIf
	If !(lCusFil .Or. lCusEmp) .And. !lLocProc
		cQuerPAD3 += " AND D3_LOCAL = '"+mv_par08+"'"
	EndIf
	cQuerPAD3 += " AND SD3.D_E_L_E_T_=' '"

	cQuePASub:= "SELECT 1 "

	If mv_par07 == 1
		cQueryPA2 := " AND NOT EXISTS (" + cQuePASub + cQuerPAD1
		cQueryPA2 += cQupaiB1B
		cQueryPA2 += " AND "
		cQueryPA2 += cQupaiB1C
		cQueryPA2 += ") AND NOT EXISTS ("
		cQueryPA2 += cQuePASub + cQuerpaD2
		cQueryPA2 += cQupaiB1B
		cQueryPA2 += " AND "
		cQueryPA2 += cQupaiB1C
		cQueryPA2 += ") AND NOT EXISTS ("
		cQueryPA2 += cQuePASub + cQuerPAD3
		cQueryPA2 += cQupaiB1B
		cQueryPA2 += " AND "
		cQueryPA2 += cQupaiB1C + ")"

		cUnionPai := "%"
		cUnionPai += " UNION SELECT 'SB1'"		// 01
		cUnionPai += ", SB1EXS.B1_COD"			// 02
		cUnionPai += ", SB1EXS.B1_TIPO"		// 03
		cUnionPai += ", SB1EXS.B1_UM"			// 04
		cUnionPai += ", SB1EXS.B1_GRUPO"		// 05
		cUnionPai += ", SB1EXS.B1_DESC"		// 06
		cUnionPai += ", SB1EXS.B1_POSIPI"		// 07
		cUnionPai += ", ''"					// 08
		cUnionPai += ", ''"					// 09
		cUnionPai += ", ''"					// 10
		cUnionPai += ", ''"					// 11
		cUnionPai += ", ''"					// 12
		cUnionPai += ", ''"					// 13
		cUnionPai += ", ''"					// 14
		cUnionPai += ", 0"						// 15
		cUnionPai += ", 0"						// 16
		cUnionPai += ", ''"					// 17
		cUnionPai += ", ''"					// 18
		cUnionPai += ", ''"					// 19
		cUnionPai += ", ''"					// 20
		cUnionPai += ", ''"					// 21
		cUnionPai += ", ''"					// 22
		cUnionPai += ", ''"					// 23
		cUnionPai += ", ''"					// 24
		cUnionPai += ", 0"						// 25
		cUnionPai += ", ''"					// 26
		cUnionPai += ", ''"					// 27
		If lVEIC
			cUnionPai += ", SB1EXS.B1_CODITE CODITE"	// 28
		EndIf
		cUnionPai += ", 0"						// 29
		cUnionPai += ", ''"					// 30 local
		cUnionPai += " FROM "+RetSqlName("SB1") + " SB1EXS WHERE"
		cUnionPai += cQupaiB1D
		cUnionPai += cQueryPA2
		cUnionPai += "%"
	EndIf

	cOrderpai := "%"
	If ! lVEIC
		If nOrdPai == 1 //" Codigo Produto "###" Tipo do Produto"
			cOrderpai += " 2,"
		ElseIf nOrdPai == 2
			cOrderpai += " 3,2,"
		EndIf
	Else
		If nOrdPai ==1 //" Codigo Produto "###" Tipo do Produto"
			cOrderpai += " 28, 2, 5," 	// B1_CODITE, B1_COD, B1_GRUPO
		ElseIf nOrdPai == 2
			cOrderpai += " 3, 28, 2, 5," // B1_TIPO, B1_CODITE, B1_COD, B1_GRUPO
		EndIf
	EndIf

	If mv_par11 == 1
		cOrderpai += "12"+IIf(lVEIC,',29',',28')
	Else
		If lCusFil .Or. lCusEmp
			cOrderpai += "8,12"+IIf(lVEIC,',29',',28')
		Else
			cOrderpai += "8"+IIf(lVEIC,',29',',28')
		EndIf
	EndIf
	cOrderpai += "%"

	BeginSql Alias cAliasPAI
		SELECT
			'SD1' ARQ,
			//-- 01 ARQ
			SB1.B1_COD PRODUTO,
			//-- 02 PRODUTO
			SB1.B1_TIPO TIPO,
			//-- 03 TIPO
			SB1.B1_UM,
			//-- 04 UM
			SB1.B1_GRUPO,
			//-- 05 GRUPO
			SB1.B1_DESC,
			//-- 06 DESCR
			SB1.B1_POSIPI,
			//-- 07
			D1_SEQCALC SEQCALC,
			//-- 08
			D1_DTDIGIT DTDIGIT,
			//-- 09 DTDIGIT
			D1_TES TES,
			//-- 10 TES
			D1_CF CF,
			//-- 11 CF
			D1_NUMSEQ SEQUENCIA,
			//-- 12 SEQUENCIA
			D1_DOC DOCUMENTO,
			//-- 13 DOCUMENTO
			D1_SERIE SERIE,
			//-- 14 SERIE
			D1_QUANT QUANTIDADE,
			//-- 15 QUANTIDADE
			D1_QTSEGUM QUANT2UM,
			//-- 16 QUANT2UM
			D1_LOCAL ARMAZEM,
			//-- 17 ARMAZEM
			' ' PROJETO,
			//-- 18 PROJETO
			' ' OP,
			//-- 19 OP
			' ' CC,
			//-- 20 OP
			D1_FORNECE FORNECEDOR,
			//-- 21 FORNECEDOR
			D1_LOJA LOJA,
			//-- 22 LOJA
			' ' PEDIDO,
			//-- 23 PEDIDO
			D1_TIPO TIPONF,
			//-- 24 TIPO NF
			%Exp:cSelPAID1% //-- 25 CUSTO
			' ' TRT,
			//-- 26 TRT
			D1_LOTECTL LOTE //-- 27 LOTE
			%Exp:cSelpaiVe% //-- 28 CODITE
			SD1.R_E_C_N_O_ NRECNO,
			//-- 29 RECNO
			SD1.D1_LOCAL ARMLOC
		FROM
			%table:SB1% SB1,%table:SD1% SD1,%table:SF4% SF4
		WHERE
			SB1.B1_COD = SD1.D1_COD
			AND %Exp:cWhpaiD1C% SD1.D1_TES = SF4.F4_CODIGO
			AND SF4.F4_ESTOQUE = 'S'
			AND SD1.D1_DTDIGIT >= %Exp:mv_par05%
			AND SD1.D1_DTDIGIT <= %Exp:mv_par06%
			AND SD1.D1_ORIGLAN <> 'LF' %Exp:cWhpaiD1% SD1.%NotDel%
			AND SF4.%NotDel% %Exp:cWhPaiB1A%
			AND %Exp:cWhPaiB1C%
		UNION
		SELECT
			'SD2',
			SB1.B1_COD,
			SB1.B1_TIPO,
			SB1.B1_UM,
			SB1.B1_GRUPO,
			SB1.B1_DESC,
			SB1.B1_POSIPI,
			D2_SEQCALC,
			D2_EMISSAO,
			D2_TES,
			D2_CF,
			D2_NUMSEQ,
			D2_DOC,
			D2_SERIE,
			D2_QUANT,
			D2_QTSEGUM,
			D2_LOCAL,
			' ',
			' ',
			' ',
			D2_CLIENTE,
			D2_LOJA,
			D2_PEDIDO,
			D2_TIPO,
			%Exp:cSelPAID2% ' ',D2_LOTECTL %Exp:cSelpaiVe% SD2.R_E_C_N_O_ SD2RECNO,
			//-- 29 RECNO
			SD2.D2_LOCAL
		FROM
			%table:SB1% SB1,%table:SD2% SD2,%table:SF4% SF4
		WHERE
			SB1.B1_COD = SD2.D2_COD
			AND %Exp:cWhpaiD2C% SD2.D2_TES = SF4.F4_CODIGO
			AND SF4.F4_ESTOQUE = 'S'
			AND SD2.D2_EMISSAO >= %Exp:mv_par05%
			AND SD2.D2_EMISSAO <= %Exp:mv_par06%
			AND SD2.D2_ORIGLAN <> 'LF' %Exp:cWhpaiD2% SD2.%NotDel%
			AND SF4.%NotDel% %Exp:cWhPaiB1A%
			AND %Exp:cWhPaiB1C%
		UNION
		SELECT
			'SD3',
			SB1.B1_COD,
			SB1.B1_TIPO,
			SB1.B1_UM,
			SB1.B1_GRUPO,
			SB1.B1_DESC,
			SB1.B1_POSIPI,
			D3_SEQCALC,
			D3_EMISSAO,
			D3_TM,
			D3_CF,
			D3_NUMSEQ,
			D3_DOC,
			' ',
			D3_QUANT,
			D3_QTSEGUM,
			D3_LOCAL,
			D3_PROJPMS,
			D3_OP,
			D3_CC,
			' ',
			' ',
			' ',
			' ',
			%Exp:cSelPAID3% D3_TRT,D3_LOTECTL %Exp:cSelpaiVe% SD3.R_E_C_N_O_ SD3RECNO,
			//-- 29 RECNO
			SD3.D3_LOCAL
		FROM
			%table:SB1% SB1,%table:SD3% SD3
		WHERE
			SB1.B1_COD = SD3.D3_COD
			AND %Exp:cWhpaiD3C% SD3.D3_EMISSAO >= %Exp:mv_par05%
			AND SD3.D3_EMISSAO <= %Exp:mv_par06%
			AND %Exp:cWhpaiD3% SD3.%NotDel% %Exp:cUnionPai%
		ORDER BY
			%Exp:cOrderpai%
	EndSql

	dbSelectArea(cAliasPAI)

	While !(cAliasPAI)->(Eof())

		dbSelectArea("SB2") //cPProd cPTipo cPUm cPGrupo cPdesc cPPos dPDigit cPTes
		If !dbSeek(xFilial("SB2")+(cAliasPAI)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))
			dbSelectArea(cAliasPAI)
			dbSkip()
			Loop
		EndIf

		dbSelectArea(cAliasPAI)
		cProdAnt  := (cAliasPAI)->PRODUTO
		cLocalAnt := alltrim(SB2->B2_LOCAL)

		lFirst:=.F.

		While !(cAliasPAI)->(Eof()) .And. (cAliaspai)->PRODUTO = cProdAnt .And. If(lCusFil .Or. lCusEmp .Or. lLocProc,.T.,IIf(alltrim((cAliasPAI)->ARQ) <> 'SB1',alltrim((cAliasPAI)->ARMAZEM)==cLocalAnt,.T.))
			lContinua := .F.
			lImpSMov  := .F.
			If Alltrim((cAliasPAI)->ARQ) $ "SD1/SD2"
				lFirst:=.T.
			ElseIf Alltrim((cAliasPAI)->ARQ) == "SD3"
				lFirst:=.T.

				lInverteMov:=.F.
				If alltrim((cAliasPAI)->ARMAZEM) != cLocalAnt .Or. lCusFil .Or. lCusEmp
					If !(Substr((cAliasPAI)->CF,3,1) == "3")
						If !(lCusFil .Or. lCusEmp)
							dbSkip()
							Loop
						EndIf
					ElseIf lPriApropri
						lInverteMov:=.T.
					EndIf
				EndIf

				If mv_par13 == 2 .And. Substr((cAliasPAI)->CF,3,1) == "4"

					lTransEnd := .T.
					If Localiza((cAliasPAI)->PRODUTO)
						cNumSeqTr  := (cAliasPAI)->(PRODUTO+SEQUENCIA+ARMAZEM)
						aDadosTran := {(cAliasPAI)->TES,;
							(cAliasPAI)->QUANTIDADE,;
							(cAliasPAI)->CUSTO,;
							(cAliasPAI)->QUANT2UM,;
							(cAliasPAI)->TIPO,;
							(cAliasPAI)->DTDIGIT,;
							(cAliasPAI)->CF,;
							(cAliasPAI)->SEQUENCIA,;
							(cAliasPAI)->DOCUMENTO,;
							(cAliasPAI)->PRODUTO,;
							(cAliasPAI)->OP,;
							(cAliasPAI)->PROJETO,;
							(cAliasPAI)->CC,;
							alltrim((cAliasPAI)->ARQ),;
							(cAliasPAI)->ARMAZEM}
						dbSkip()
						If (cAliasPAI)->(PRODUTO+SEQUENCIA+ARMAZEM) == cNumSeqTr
							dbSkip()
							Loop
						Else
							lContinua := .T.
							If aDadosTran[1] <= "500"
							Else
								oSection3:Cell("nENTQtd"):Hide()
							EndIf

							lTransEnd := .T.
						EndIf
					EndIf
				EndIf
			EndIf

			Do Case
			Case Alltrim((cAliasPAI)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
				lDev:=MTR900Dev("SD1",cAliasPAI)
				If (cAliasPAI)->TES <= "500" .And. !lDev
					If (cAliasPAI)->TIPONF != "C"
						nCustoPai 		+= (cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE
					EndIf

					nQuantPai 				+= (cAliasPAI)->QUANTIDADE
					nCusPai	  				+= (cAliasPAI)->CUSTO

				Else
					If (cAliasPAI)->TIPONF != "C"
						nCustoPai 			+= (cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE
					EndIf

					If lDev
						nQuantPai 			+= ((cAliasPAI)->QUANTIDADE * -1)
						nCusPai  			+= ((cAliasPAI)->CUSTO * -1)

					Else
						nQuantPai				+= (cAliasPAI)->QUANTIDADE
						nCusPAI					+= (cAliasPAI)->CUSTO

					EndIf
				EndIf
			Case Alltrim((cAliasPAI)->ARQ) = "SD2" .And. !lContinua .And. lTransEnd
				lDev:=MTR900Dev("SD2",cAliasPAI)
				If (cAliasPAI)->TES <= "500" .Or. lDev
					If lDev
						nQuantPAI 				+= ((cAliasPAI)->QUANTIDADE * -1)
						nCusPAI					+= ((cAliasPAI)->CUSTO * -1)

					Else
						nQuantPAI				+= ((cAliasPAI)->QUANTIDADE)
					EndIf

					If (cAliasPAI)->TIPONF != "C"
						nCustoPAI		+= ((cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE)
					EndIf
				Else
					If (cAliasPAI)->TIPONF != "C"
						nCustoPAI		+= ((cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE)
					EndIf
					nQuantPAI		+= ((cAliasPAI)->QUANTIDADE)
					nCusPAI			+= ((cAliasPAI)->CUSTO)

				EndIf
			Case Alltrim((cAliasPAI)->ARQ) == "SD3" .And. !lContinua  .And. lTransEnd
				lDev := .F.
				If	lInverteMov
					If (cAliasPAI)->TES > "500"
						nQuantPAI			+=	((cAliasPAI)->QUANTIDADE)
						nCusPAI				+=	((cAliasPAI)->CUSTO)
						nCustoPAI			+=	((cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE)

					Else

						nCustoPAI					+= ((cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE)
						nQuantPAI					+= ((cAliasPAI)->QUANTIDADE)
						nCusPAI						+= ((cAliasPAI)->CUSTO)

					EndIf
					If lCusFil .Or. lCusEmp
						lPriApropri:=.F.
					EndIf
				Else
					If (cAliasPAI)->TES <= "500"
						nQuantPAI 				+= ((cAliasPAI)->QUANTIDADE)
						nCusPAI					+= ((cAliasPAI)->CUSTO)
						nCustoPAI				+= ((cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE)

					Else
						nCustoPAI				+= ((cAliasPAI)->CUSTO / (cAliasPAI)->QUANTIDADE)
						nQuantPAI				+= ((cAliasPAI)->QUANTIDADE)
						nCusPAI					+= ((cAliasPAI)->CUSTO)

					EndIf
					If lCusFil .Or. lCusEmp
						lPriApropri:=.T.
					EndIf
				EndIf
			EndCase
			dbSkip()
		EndDo
		dbSkip()
	EndDo
	dbSelectArea(cAliasPAI)
	AADD(aRet,{nCustoPai,nQuantPAI,nCusPAI})
RETURN aRet

/*/{Protheus.doc} totPai
    (long_description)
    @type  Static Function
    @author user
    @since 28/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function totPai(aProdPai,oSection1,oSection3,oReport)

Local aArea := GetArea()


oSection3:Finish()


oSection1:Init()

oSection1:Cell("nCusMed" ):SetValue(0)
oSection1:Cell("nQtdSal" ):SetValue(aProdPai[len(aProdPai),04])
oSection1:Cell("nVlrSal" ):SetValue(0)
oSection1:Cell("cProduto"):SetValue(aProdPai[len(aProdPai),01])
oSection1:Cell("B1_DESC"):SetValue(aProdPai[len(aProdPai),06])
oSection1:Cell("cTipo"	 ):SetValue(Posicione("SB1",1,xFilial("SB1")+aProdPai[len(aProdPai),01],"B1_TIPO"))

oSection1:PrintLine()
oSection1:Finish()

oSection3:Init()

oSection3:Cell("nENTQtd"):show()
oSection3:Cell("nSAIQtd"):show()
oSection3:Cell("nSALDQtd"):show()

oSection3:Cell("nENTQtd"):setvalue(aProdPai[len(aProdPai),02])
oSection3:Cell("nSAIQtd"):setvalue(If(aProdPai[len(aProdPai),03]<0,(aProdPai[len(aProdPai),03]) * (-1),aProdPai[len(aProdPai),03]))
oSection3:Cell("nSALDQtd"):setvalue((aProdPai[len(aProdPai),04]+aProdPai[len(aProdPai),02]) - If(aProdPai[len(aProdPai),03]<0,(aProdPai[len(aProdPai),03]) * (-1),aProdPai[len(aProdPai),03]))

oSection3:Cell("dDtMov"):hide()
oSection3:Cell("cLocal"):hide()
oSection3:Cell("cTES"):hide()
oSection3:Cell("cCF"):hide()
oSection3:Cell("cDoc"):hide()
oSection3:Cell("nENTCus"):hide()
oSection3:Cell("nCusMov"):hide()
oSection3:Cell("nSAICus"):hide()

oSection3:Cell("nSALDCus"):hide()
oSection3:Cell("cCCPVPJOP"):hide()

oSection3:PrintLine()

oReport:ThinLine()

oSection3:Cell("dDtMov"):show()
oSection3:Cell("cLocal"):show()
oSection3:Cell("cTES"):show()
oSection3:Cell("cCF"):show()
oSection3:Cell("cDoc"):show()
oSection3:Cell("nENTCus"):show()
oSection3:Cell("nCusMov"):show()
oSection3:Cell("nSAICus"):show()
oSection3:Cell("nSALDQtd"):show()
oSection3:Cell("nSALDCus"):show()
oSection3:Cell("cCCPVPJOP"):show()

aProdPai[len(aProdPai),05] := .t.

RestArea(aArea)

Return
