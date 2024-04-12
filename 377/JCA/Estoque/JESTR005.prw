#INCLUDE "MATR900.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR900  � Autor � Nereu Humberto Junior � Data � 25.07.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex fisico - financeiro                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function JESTR005()
Local oReport

oReport:= ReportDef()
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �25.07.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         |
//����������������������������������������������������������������
Local lCusFil      := AllTrim(SuperGetMV( 'MV_CUSFIL' ,.F.,"A")) == "F"
Local lCusEmp      := AllTrim(SuperGetMv( 'MV_CUSFIL' ,.F.,"A")) == "E"

//��������������������������������������������������������������Ŀ
//�MV_CUSREP - Parametro utilizado para habilitar o calculo do   �
//�            Custo de Reposicao.                               �
//����������������������������������������������������������������
Local lCusRep      := SuperGetMv("MV_CUSREP",.F.,.F.) .And. MA330AvRep()

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR900",STR0001,"MTR900", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003)
oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

//���������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                      �
//�����������������������������������������������������������
//����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                     �
//� mv_par01         // Do produto                           �
//� mv_par02         // Ate o produto                        �
//� mv_par03         // Do tipo                              �
//� mv_par04         // Ate o tipo                           �
//� mv_par05         // Da data                              �
//� mv_par06         // Ate a data                           �
//� mv_par07         // Lista produtos s/movimento           �
//� mv_par08         // Qual Local (almoxarifado)            �
//� MV_par09         // (d)OCUMENTO/(s)EQUENCIA              �
//� mv_par10         // moeda selecionada ( 1 a 5 )          �
//� mv_par11         // Seq.de Digitacao /Calculo            �
//� mv_par12         // Pagina Inicial                       �
//� mv_par13         // Lista Transf Locali (Sim/Nao)        �
//� mv_par14         // Do  Grupo                            �
//� mv_par15         // Ate o Grupo                          �
//� mv_par16         // Seleciona Filial?                    �
//� mv_par17         // Qual Custo ? ( Medio / Reposicao )   �
//������������������������������������������������������������
Pergunte("MTR900",.F.)

Aadd( aOrdem, STR0004 ) // " Codigo Produto "
Aadd( aOrdem, STR0005 ) // " Tipo do Produto"

//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 1 - Dados do Produto                     �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 2 - Cont. dos dados do Produto           �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 3 - Movimentos                           �
//����������������������������������������������������������������
oSection3 := TRSection():New(oSection2,STR0061,{"SD1","SD2","SD3"}) //"Movimenta��o dos Produtos"
//oSection3 :SetHeaderPage()
//oSection3 :SetTotalInLine(.F.)
//oSection3 :SetTotalText(STR0021) //"T O T A I S  :"
//oSection3 :SetReadOnly()

TRCell():New(oSection3, "cLocal"    	, " ", 'Local'             	, "@!"       , /*Tamanho*/   , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection3, "cPrateleira"   , " ", 'Prateleira'			, /*Picture*/,       , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection3, "cProduto"   	, " ", 'Material'			, /*Picture*/, 25    , /*lPixel*/, )
TRCell():New(oSection3, "cDescric" 		,"SB1",'Descri��o'          , /*Picture*/, 40         , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection3, "cDoc"     		, " ", 'C�digo'+CRLF+'Original', "@!"       , 30   , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection3, "cTraco1"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection3, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
TRCell():New(oSection3, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
TRCell():New(oSection3, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
TRCell():New(oSection3, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
TRCell():New(oSection3, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
TRCell():New(oSection3, "cTraco5"  		, " ", ""        			, /*Picture*/, 1             , /*lPixel*/, )
TRCell():New(oSection3, "nENTQtd"  		, " ", 'Qtde'+CRLF+'Inicial', cPicD1Qt   , cTamD1Qt      , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection3, "cTraco2"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection3, "nENTCus"  		, " ", 'Qtde'+CRLF+'Entradas', cPicD1Cust , cTamD1Cust    , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection3, "cTraco3"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection3, "nSAIQtd"  		, " ", 'Qtde'+CRLF+'Sa�das', cPicB2Cust , cTamB2Cust    , /*lPixel*/, /*{|| code-block de impressao }*/)
TRCell():New(oSection3, "cTraco4"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
TRCell():New(oSection3, "nSALDQtd" 		, " ", 'Qtde'+CRLF+'Atual' , cPicD2Qt   , cTamD2Qt      , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection3, "nSAICus"  		, " ", STR0047+CRLF+STR0044, cPicD2Cust , cTamD2Cust    , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection3, "cTraco6"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
//TRCell():New(oSection3, "nSALDQtd" 		, " ", STR0048+CRLF+STR0043, cPicB2Qt   , cTamB2Qt      , /*lPixel*/, /*{|| code-block de impressao }*/)
//TRCell():New(oSection3, "cTraco7"  		, " ", "|"+CRLF+"|"        , /*Picture*/, 1             , /*lPixel*/, {|| "|" })
//TRCell():New(oSection3, "nSALDCus" 		, " ", STR0048+CRLF+STR0049, cPicB2Tot  , cTamB2Tot     , /*lPixel*/, /*{|| code-block de impressao }*/)


// Definir o formato de valores negativos (para o caso de devolucoes)
oSection3:Cell("nENTQtd"):SetNegative("PARENTHESES")
//oSection3:Cell("nENTCus"):SetNegative("PARENTHESES")
oSection3:Cell("nSAIQtd"):SetNegative("PARENTHESES")
//oSection3:Cell("nSAICus"):SetNegative("PARENTHESES")

TRFunction():New(oSection3:Cell("nENTQtd")	,NIL,"SUM"		,/*oBreak*/,"",cPicD1Qt		,{|| oSection3:Cell("nENTQtd"):GetValue(.T.) },.T.,.F.)
//TRFunction():New(oSection3:Cell("nENTCus")	,NIL,"SUM"		,/*oBreak*/,"",cPicD1Cust	,{|| oSection3:Cell("nENTCus"):GetValue(.T.) },.T.,.F.)

TRFunction():New(oSection3:Cell("nSAIQtd")	,NIL,"SUM"		,/*oBreak*/,"",cPicD2Qt		,{|| oSection3:Cell("nSAIQtd"):GetValue(.T.) },.T.,.F.)
//TRFunction():New(oSection3:Cell("nSAICus")	,NIL,"SUM"		,/*oBreak*/,"",cPicD2Cust	,{|| oSection3:Cell("nSAICus"):GetValue(.T.) },.T.,.F.)

TRFunction():New(oSection3:Cell("nSALDQtd"),NIL,"ONPRINT"	,/*oBreak*/,"",cPicB2Qt		,{|| oSection3:Cell("nSALDQtd"):GetValue(.T.) },.T.,.F.)
//TRFunction():New(oSection3:Cell("nSALDCus"),NIL,"ONPRINT"	,/*oBreak*/,"",cPicB2Tot	,{|| oSection3:Cell("nSALDCus"):GetValue(.T.) },.T.,.F.)

oSection3:SetNoFilter("SD1")
oSection3:SetNoFilter("SD2")
oSection3:SetNoFilter("SD3")

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �21.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local cFromSBZ  := ''
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
//��������������������������������������������������������������Ŀ
//� Codigo do produto importado - NAO DEVE SER LISTADO           �
//����������������������������������������������������������������
Local cProdImp := GetMV("MV_PRODIMP")

Local cWhereB1A:= " "
Local cWhereB1B:= " "
Local cWhereB1C:= " "
Local cWhereB1D:= " "

Local cQueryB1A:= " "
Local cQueryB1B:= " "
Local cQueryB1C:= " "
Local cQueryB1D:= " "

//��������������������������������������������������������������Ŀ
//� Concessionaria de Veiculos                                   �
//����������������������������������������������������������������
Local lVEIC    := Upper(GetMV("MV_VEICULO"))=="S"

Local lImpSMov := .F.
LOCAL cProdMNT := GetMv("MV_PRODMNT")
LOCAL cProdTER := GetMv("MV_PRODTER")
Local aProdsMNT := {}

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para processamento de Filiais           �
//����������������������������������������������������������������
Local aFilsCalc := MatFilCalc( Iif (!IsBlind(), mv_par16 == 1, .F.))
Local cFilBack  := cFilAnt
Local nForFilial:= 0

//�����������������������������������������������������Ŀ
//� Variavel utilizada para inicar a pagina do relatorio�
//�������������������������������������������������������
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
Local lLoop		:= .F.
Local cDadosProd    := SuperGetMV("MV_ARQPROD",.F.,"SB1")
Local cSimbMoed := ''
Local aSldDia   := {}
Local nSldDia	:=	0

Private bBloco   := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }

//��������������������������������������������������������������Ŀ
//�MV_CUSREP - Parametro utilizado para habilitar o calculo do   �
//�            Custo de Reposicao.                               �
//����������������������������������������������������������������
Private lCusRep  := SuperGetMv("MV_CUSREP",.F.,.F.) .And.MA330AvRep()

cProdMNT := cProdMNT + Space(15-Len(cProdMNT))
cProdTER := cProdTER + Space(15-Len(cProdTER))

//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         |
//����������������������������������������������������������������
Private lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
Private lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

lCusFil:=lCusFil .And. mv_par08 == Repl("*",TamSX3("B2_LOCAL")[1])
lCusEmp:=lCusEmp .And. mv_par08 == Repl("#",TamSX3("B2_LOCAL")[1])

Private lDev := .F. // Flag que indica se nota � devolu�ao (.T.) ou nao (.F.)

oReport:SetPageNumber(n_pag)
//��������������������������������������������������������������Ŀ
//� Alerta o usuario que o custo de reposicao esta desativado.   �
//����������������������������������������������������������������
If mv_par17==2 .And. !lCusRep
	Help(" ",1,"A910CUSRP")
	mv_par17 := 1
EndIf

If lCusEmp .And. !Empty(aFilsCalc)
	If MV_PAR16 == 1
		For nForFilial := 1 To Len( aFilsCalc )
			If aFilsCalc[ nForFilial, 1 ]
				aAdd(aFils, aFilsCalc[ nForFilial, 2 ])
			EndIf 
		Next nForFilial
	Else
		For nForFilial := 1 To Len( aFilsCalc )
			aAdd(aFils, aFilsCalc[ nForFilial, 2 ])
		Next nForFilial
	EndIf
EndIf 

//��������������������������������������������������������������Ŀ
//� aFilsCalc - Array com filiais a serem processadas            �
//����������������������������������������������������������������
If !Empty(aFilsCalc)

	For nForFilial := 1 To Len( aFilsCalc )

		If aFilsCalc[ nForFilial, 1 ]

			cFilAnt := aFilsCalc[ nForFilial, 2 ]

			oReport:EndPage() //Reinicia Pagina

			oReport:SetTitle(OemToAnsi(STR0008) + IIf(mv_par11==1,IIf(lCusRep .And. mv_par17==2,STR0065,STR0009),IIf(lCusRep .And. mv_par17==2,STR0066,STR0010) ) + " " + IIf(lCusFil .Or. lCusEmp,"",OemToAnsi(STR0011)+" "+mv_par08) ) // "KARDEX FISICO-FINANCEIRO "###"(SEQUENCIA)"###"(CALCULO)"###"L O C A L :"
			
			cSimbMoed := A900GetMV(1, "MV_SIMB"+Ltrim(Str(mv_par10)))

			If nOrdem == 1
				oReport:SetTitle( oReport:Title()+Alltrim(STR0017+STR0004+STR0018+AllTrim(cSimbMoed)+")")+' - ' + aFilsCalc[ nForFilial, 3 ] ) //" (Por "###" ,em "
			Else
				oReport:SetTitle( oReport:Title()+Alltrim(STR0017+STR0005+STR0018+AllTrim(cSimbMoed)+")")+' - ' + aFilsCalc[ nForFilial, 3 ] ) //" (Por "###" ,em "
			EndIf

			If lVeic
				oSection1:Cell("cProduto"	):Disable()
				oSection1:Cell("B1_UM"		):Disable()
				oSection1:Cell("cTipo"		):Disable()
				oSection1:Cell("B1_GRUPO"	):Disable()
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

			//������������������������������������������������������������������������Ŀ
			//�Filtragem do relatorio                                                  �
			//��������������������������������������������������������������������������

			MakeSqlExpr(oReport:uParam)

			//������������������������������������������������������������������������Ŀ
			//�Query do relatorio da secao 1                                           �
			//��������������������������������������������������������������������������
			oReport:Section(1):BeginQuery()

			//������������������������������������������������������������������������Ŀ
			//�Complemento do SELECT da tabela SD1                                     �
			//��������������������������������������������������������������������������
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
			//������������������������������������������������������������������������Ŀ
			//�Complemento do SELECT da tabela SB1 para MV_VEICULO                     �
			//��������������������������������������������������������������������������
			cSelectVe := "%"
			cSelectVe += ","
			If lVEIC
				cSelectVe += "SB1.B1_CODITE B1_CODITE,"
			EndIf
			cSelectVe += "%"
			//������������������������������������������������������������������������Ŀ
			//�Complemento do Where da tabela SD1                                      �
			//��������������������������������������������������������������������������
			cWhereD1 := "%"
			cWhereD1 += "AND"
			If !(lCusFil .Or. lCusEmp)
				cWhereD1 += " D1_LOCAL = '" + mv_par08 + "' AND"
			EndIf
			cWhereD1 += "%"
			//������������������������������������������������������������������������Ŀ
			//�Ajuste do From SB1 / SBZ                                                �
			//��������������������������������������������������������������������������
			If !lCusEmp
				cFromSBZ := '%'+RetSqlName('SB1')+' SB1 %'
			ELse
				If cDadosProd <> 'SBZ'		
					cFromSBZ := '%'+RetSqlName('SB1')+' SB1 %'
				Else
					cFromSBZ := '%'+RetSqlName('SB1')+' SB1,'+RetSqlName('SBZ')+' SBZ %'
				EndIf
			EndIf 
			//������������������������������������������������������������������������Ŀ
			//�Complemento do Where da tabela SD1 (Tratamento Filial)                  �
			//��������������������������������������������������������������������������
			If lCusEmp
				cWhereD1C := "%"
				If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SF4") == "E"
					cWhereD1C += " D1_FILIAL = F4_FILIAL AND "
				EndIf
				If FWModeAccess("SD1") == "E" .AND. FWModeAccess("SB1") == "E"
					If cDadosProd <> 'SBZ'
						cWhereD1C += "SD1.D1_FILIAL = SB1.B1_FILIAL AND "
					else
						cWhereD1C += "SD1.D1_FILIAL = SBZ.BZ_FILIAL AND "
						cWhereD1C += "SBZ.BZ_FILIAL = SB1.B1_FILIAL AND "
						cWhereD1C += "SBZ.BZ_COD = SB1.B1_COD AND "
						cWhereD1C += "SBZ.D_E_L_E_T_ = ' ' AND "
					EndIf	
				EndIf
				If  'E' $ SM0->M0_LEIAUTE .And. FWModeAccess("SB1") == "C" .and. FWModeAccess("SB1",1) <> 'C' 
					cTamEMPR := cValtochar(Rat('E',SM0->M0_LEIAUTE)) 
					cWhereD1C += " SUBSTRING(SB1.B1_FILIAL,1,"+cTamEMPR+") = SUBSTRING(SD1.D1_FILIAL,1,"+cTamEMPR+") AND " 
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
			//������������������������������������������������������������������������Ŀ
			//�Complemento do SELECT da tabela SD2                                     �
			//��������������������������������������������������������������������������
			If lCusRep .And. mv_par17==2
				cSelectD2 := "% D2_CUSRP"
				cSelectD2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
			Else
				cSelectD2 := "% D2_CUSTO"
				cSelectD2 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
			EndIf
			cSelectD2 += " CUSTO,"
			cSelectD2 += "%"
			//������������������������������������������������������������������������Ŀ
			//�Complemento do Where da tabela SD1                                      �
			//��������������������������������������������������������������������������
			cWhereD2 := "%"
			cWhereD2 += "AND"
			If !(lCusFil .Or. lCusEmp)
				cWhereD2 += " D2_LOCAL = '" + mv_par08 + "' AND"
			EndIf
			cWhereD2 += "%"
			//������������������������������������������������������������������������Ŀ
			//�Complemento do Where da tabela SD2 (Tratamento Filial)                  �
			//��������������������������������������������������������������������������
			If lCusEmp
				cWhereD2C := "%"
				If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SF4") == "E"
					cWhereD2C += " D2_FILIAL = F4_FILIAL AND "
				EndIf
				If FWModeAccess("SD2") == "E" .AND. FWModeAccess("SB1") == "E"
					If cDadosProd <> 'SBZ'
						cWhereD2C += "SD2.D2_FILIAL = SB1.B1_FILIAL AND "
					else
						cWhereD2C += "SD2.D2_FILIAL = SBZ.BZ_FILIAL AND "
						cWhereD2C += "SBZ.BZ_FILIAL = SB1.B1_FILIAL AND "
						cWhereD2C += "SBZ.BZ_COD = SB1.B1_COD AND "
						cWhereD2C += "SBZ.D_E_L_E_T_ = ' ' AND "
					EndIf
				EndIf
				If  'E' $ SM0->M0_LEIAUTE .And. FWModeAccess("SB1") == "C" .and. FWModeAccess("SB1",1) <> 'C' 
					cTamEMPR := cValtochar(Rat('E',SM0->M0_LEIAUTE)) 
					cWhereD2C += " SUBSTRING(SB1.B1_FILIAL,1,"+cTamEMPR+") = SUBSTRING(SD2.D2_FILIAL,1,"+cTamEMPR+") AND " 
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
			//������������������������������������������������������������������������Ŀ
			//�Complemento do SELECT da tabelas SD3                                    �
			//��������������������������������������������������������������������������
			If lCusRep .And. mv_par17==2
				cSelectD3 := "% D3_CUSRP"
				cSelectD3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
			Else
				cSelectD3 := "% D3_CUSTO"
				cSelectD3 += Str(mv_par10,1,0) // Coloca a Moeda do Custo
			EndIf
			cSelectD3 +=	" CUSTO,"
			cSelectD3 += "%"
			//������������������������������������������������������������������������Ŀ
			//�Complemento do WHERE da tabela SD3                                      �
			//��������������������������������������������������������������������������
			cWhereD3 := "%"
			If A900GetMV(2, 'MV_D3ESTOR', .F., 'N') == 'N'
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
				If FWModeAccess("SD3") == "E" .AND. FWModeAccess("SB1") == "E"
					If cDadosProd <> 'SBZ'
						cWhereD3 += " SD3.D3_FILIAL = SB1.B1_FILIAL AND "
					else
						cWhereD3 += " SD3.D3_FILIAL = SBZ.BZ_FILIAL AND "
						cWhereD3 += " SBZ.BZ_FILIAL = SB1.B1_FILIAL AND "
						cWhereD3 += " SBZ.BZ_COD = SD3.D3_COD AND "
						cWhereD3 += " SBZ.D_E_L_E_T_ = ' ' AND "
					EndIf
				EndIf
				If  'E' $ SM0->M0_LEIAUTE .And. FWModeAccess("SB1") == "C" .and. FWModeAccess("SB1",1) <> 'C' 
					cTamEMPR := cValtochar(Rat('E',SM0->M0_LEIAUTE)) 
					cWhereD3 += " SUBSTRING(SB1.B1_FILIAL,1,"+cTamEMPR+") = SUBSTRING(SD3.D3_FILIAL,1,"+cTamEMPR+") AND " 
				EndIf
			Else
				cWhereD3 += " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
			EndIf
			cWhereD3 += " SB1.B1_GRUPO >= '"+mv_par14+"' AND SB1.B1_GRUPO <= '"+mv_par15+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
			cWhereD3 += " SB1.D_E_L_E_T_=' ' AND"
			cWhereD3 += "%"
			//������������������������������������������������������������������������Ŀ
			//�Complemento do Where da tabela SD3 (Tratamento Filial)                  �
			//��������������������������������������������������������������������������
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
			//������������������������������������������������������������������������Ŀ
			//�Complemento do WHERE da tabela SB1 para todos os selects                �
			//��������������������������������������������������������������������������
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
			//��������������������������������������������������������Ŀ
			//� So inclui as condicoes a seguir qdo lista produtos sem �
			//� movimento                                              �
			//����������������������������������������������������������
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
			If A900GetMV(2, 'MV_D3ESTOR', .F., 'N') == 'N'
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

				SELECT 	'SD1' ARQ, 				//-- 01 ARQ
						SB1.B1_COD PRODUTO, 	//-- 02 PRODUTO
						SB1.B1_TIPO TIPO, 		//-- 03 TIPO
						SB1.B1_UM,   			//-- 04 UM
						SB1.B1_GRUPO,      	//-- 05 GRUPO
						SB1.B1_DESC,      		//-- 06 DESCR
						SB1.B1_POSIPI, 		//-- 07
						D1_SEQCALC SEQCALC,    //-- 08
						D1_DTDIGIT DTDIGIT,		//-- 09 DTDIGIT
						D1_TES TES,			//-- 10 TES
						D1_CF CF,				//-- 11 CF
						D1_NUMSEQ SEQUENCIA,	//-- 12 SEQUENCIA
						D1_DOC DOCUMENTO,		//-- 13 DOCUMENTO
						D1_SERIE SERIE,		//-- 14 SERIE
						D1_QUANT QUANTIDADE,	//-- 15 QUANTIDADE
						D1_QTSEGUM QUANT2UM,	//-- 16 QUANT2UM
						D1_LOCAL ARMAZEM,		//-- 17 ARMAZEM
						' ' PROJETO,			//-- 18 PROJETO
						' ' OP,				//-- 19 OP
						' ' CC,				//-- 20 OP
						D1_FORNECE FORNECEDOR,	//-- 21 FORNECEDOR
						D1_LOJA LOJA,			//-- 22 LOJA
						' ' PEDIDO,            //-- 23 PEDIDO
						D1_TIPO TIPONF,		//-- 24 TIPO NF
						%Exp:cSelectD1%		//-- 25 CUSTO
						' ' TRT, 				//-- 26 TRT
						D1_LOTECTL LOTE 	   	//-- 27 LOTE
						%Exp:cSelectVe%       	//-- 28 CODITE
						SD1.R_E_C_N_O_ NRECNO,  //-- 29 RECNO
						SD1.D1_LOCAL ARMLOC

				FROM %Exp:cFromSBZ%,%table:SD1% SD1,%table:SF4% SF4

				WHERE	SB1.B1_COD     =  SD1.D1_COD		AND  	%Exp:cWhereD1C%
						SD1.D1_TES     =  SF4.F4_CODIGO	AND
						SF4.F4_ESTOQUE =  'S'				AND 	SD1.D1_DTDIGIT >= %Exp:mv_par05%	AND
						SD1.D1_DTDIGIT <= %Exp:mv_par06%	AND		SD1.D1_ORIGLAN <> 'LF'
						%Exp:cWhereD1%
						SD1.%NotDel%						AND 	SF4.%NotDel%
						%Exp:cWhereB1A%                   AND
						%Exp:cWhereB1C%

				UNION

					SELECT 'SD2',
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
						%Exp:cSelectD2%
						' ',
						D2_LOTECTL
						%Exp:cSelectVe%
						SD2.R_E_C_N_O_ SD2RECNO, //-- 29 RECNO
						SD2.D2_LOCAL
					FROM %Exp:cFromSBZ%,%table:SD2% SD2,%table:SF4% SF4

					WHERE	SB1.B1_COD     =  SD2.D2_COD		AND	%Exp:cWhereD2C%
							SD2.D2_TES     =  SF4.F4_CODIGO		AND
							SF4.F4_ESTOQUE =  'S'				AND	SD2.D2_EMISSAO >= %Exp:mv_par05%	AND
							SD2.D2_EMISSAO <= %Exp:mv_par06%	AND	SD2.D2_ORIGLAN <> 'LF'
							%Exp:cWhereD2%
							SD2.%NotDel%						AND SF4.%NotDel%
							%Exp:cWhereB1A%                     AND
							%Exp:cWhereB1C%

				UNION

					SELECT 	'SD3',
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
							%Exp:cSelectD3%
							D3_TRT,
							D3_LOTECTL
							%Exp:cSelectVe%
							SD3.R_E_C_N_O_ SD3RECNO, //-- 29 RECNO
							SD3.D3_LOCAL

					FROM %Exp:cFromSBZ%,%table:SD3% SD3

					WHERE	SB1.B1_COD     =  SD3.D3_COD 		AND %Exp:cWhereD3C%
							SD3.D3_EMISSAO >= %Exp:mv_par05%	AND	SD3.D3_EMISSAO <= %Exp:mv_par06%	AND
							%Exp:cWhereD3%
							SD3.%NotDel%

				%Exp:cUnion%

				ORDER BY %Exp:cOrder%

			EndSql
			oSection2:SetParentQuery()
			//������������������������������������������������������������������������Ŀ
			//�Metodo EndQuery ( Classe TRSection )                                    �
			//�                                                                        �
			//�Prepara o relatorio para executar o Embedded SQL.                       �
			//�                                                                        �
			//�ExpA1 : Array com os parametros do tipo Range                           �
			//�                                                                        �
			//��������������������������������������������������������������������������
			oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

			//������������������������������������������������������������������������Ŀ
			//�Inicio da impressao do fluxo do relatorio                               �
			//��������������������������������������������������������������������������
			dbSelectArea(cAliasTop)
			oReport:SetMeter(nTotRegs)

			TcSetField(cAliasTop,DTDIGIT ,"D", TamSx3("D1_DTDIGIT")[1], TamSx3("D1_DTDIGIT")[2] )

			While !oReport:Cancel() .And. !(cAliasTop)->(Eof())

				If oReport:Cancel()
					Exit
				EndIf

				oReport:IncMeter()

				//��������������������������������������������������Ŀ
				//�Executa filtro de usuario - SB1					 �
				//����������������������������������������������������

				If !Empty(cFilUsrSB1)
					DbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					SB1->(dbSeek( xFilial("SB1") + (cAliasTop)->PRODUTO))
					If !(&(cFilUsrSB1))
						(cAliasTop)->(dbSkip())
						Loop
					EndIf
				EndIf

				//��������������������������������������������������Ŀ
				//�Executa filtro de usuario - SB2					 �
				//����������������������������������������������������

				If !Empty(cFilUsrSB2)
					DbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					SB2->(dbSeek( xFilial("SB2") + (cAliasTop)->PRODUTO))
					If !(&(cFilUsrSB2))
						(cAliasTop)->(dbSkip())
						Loop
					EndIf
				EndIf

				//��������������������������������������������������Ŀ
				//� Se nao encontrar no arquivo de saldos ,nao lista �
				//����������������������������������������������������
				dbSelectArea("SB2")
				If lCusEmp 
					lLoop := .T.
					For nFils := 1 to len(aFils)
						If dbSeek(aFils[nFils]+(cAliasTop)->PRODUTO+"")
							lLoop := .F.
						EndIf
					Next nFils
				Else
					lLoop := .F.
					If !dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))
						lLoop := .T.
					EndIf
				EndIf 
				If lLoop
					dbSelectArea(cAliasTop)
					dbSkip()
					loop
				Endif 

				dbSelectArea(cAliasTop)
				cProdAnt  := (cAliasTop)->PRODUTO
				cLocalAnt := alltrim(SB2->B2_LOCAL)
				cDescric  := Posicione("SB1",1,xFilial("SB1")+cProdAnt,"B1_DESC")
				cFabric   := Posicione("SB1",1,xFilial("SB1")+cProdAnt,"B1_FABRIC")
				lFirst:=.F.
				cPratel   := Posicione("SBZ",1,SB2->B2_FILIAL+(cAliasTop)->PRODUTO,"BZ_XLOCALI")

				MR900ImpS1(@aSalAtu,cAliasTop,.T.,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport,aFils)

				If Ascan(aSldDia,{|x| x[1]+x[3] == cLocalAnt+cProdAnt}) == 0
					Aadd(aSldDia,{cLocalAnt,cPratel,cProdAnt,cDescric,cFabric,aSalAtu[1],0,0,0})
				EndIf 

				oSection3:Init()
				While !oReport:Cancel() .And. !(cAliasTop)->(Eof()) .And. (cAliasTop)->PRODUTO = cProdAnt .And. If(lCusFil .Or. lCusEmp .Or. lLocProc,.T.,IIf(alltrim((cAliasTop)->ARQ) <> 'SB1',alltrim((cAliasTop)->ARMAZEM)==cLocalAnt,.T.))
					oReport:IncMeter()
					lContinua := .F.
					lImpSMov  := .F.
					If Alltrim((cAliasTop)->ARQ) $ "SD1/SD2"
						lFirst:=.T.
					ElseIf Alltrim((cAliasTop)->ARQ) == "SD3"
						lFirst:=.T.
						//����������������������������������������������������������������Ŀ
						//� Quando movimento ref apropr. indireta, so considera os         �
						//� movimentos com destino ao almoxarifado de apropriacao indireta.�
						//������������������������������������������������������������������
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
						//����������������������������������������������������������������Ŀ
						//� Caso seja uma transferencia de localizacao verifica se lista   �
						//� o movimento ou nao                                             �
						//������������������������������������������������������������������
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
									
									If aDadosTran[1] <= "500"
										oSection3:Cell("nENTQtd"):Show()
										oSection3:Cell("nENTCus"):Show()
										aSldDia[len(aSldDia),07] += aDadosTran[2]

										aSalAtu[1] += aDadosTran[2]
										aSalAtu[mv_par10+1] += aDadosTran[3]
										aSalAtu[7] += aDadosTran[4]
									Else
										oSection3:Cell("nSAIQtd"):Show()
										oSection3:Cell("nSAICus"):Show()

										aSldDia[len(aSldDia),08] += aDadosTran[2]

										aSalAtu[1] -= aDadosTran[2]
										aSalAtu[mv_par10+1] -= aDadosTran[3]
										aSalAtu[7] -= aDadosTran[4]
									EndIf

									lTransEnd := .T.
								EndIf
							EndIf
						EndIf
					EndIf
					
					Do Case
						Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua .And. lTransEnd
							lDev:=MTR900Dev("SD1",cAliasTop)
							If (cAliasTOP)->TES <= "500" .And. !lDev
								
								oSection3:Cell("nENTQtd"):Show()
								oSection3:Cell("nENTCus"):Show()

								aSldDia[len(aSldDia),07] +=  (cAliasTOP)->QUANTIDADE

								aSalAtu[1] += (cAliasTOP)->QUANTIDADE
								aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
								aSalAtu[7] += (cAliasTOP)->QUANT2UM
							Else
								oSection3:Cell("nSAIQtd"):Show()
								oSection3:Cell("nSAICus"):Show()

								If lDev
						
									aSldDia[len(aSldDia),07] +=  (cAliasTOP)->QUANTIDADE

									aSalAtu[1] += (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1] += (cAliasTOP)->CUSTO
									aSalAtu[7] += (cAliasTOP)->QUANT2UM
								Else
						
									aSldDia[len(aSldDia),08] +=  (cAliasTOP)->QUANTIDADE

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

									aSldDia[len(aSldDia),07] +=  (cAliasTOP)->QUANTIDADE

									aSalAtu[1] 			-= (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
									aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
								Else
									oSection3:Cell("nENTQtd"):Show()
									oSection3:Cell("nENTCus"):Show()

									aSldDia[len(aSldDia),08] +=  (cAliasTOP)->QUANTIDADE

									aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
									aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
								EndIf
							Else
								oSection3:Cell("nSAIQtd"):Show()
								oSection3:Cell("nSAICus"):Show()

								aSldDia[len(aSldDia),07] +=  (cAliasTOP)->QUANTIDADE

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
									aSldDia[len(aSldDia),08] +=  (cAliasTOP)->QUANTIDADE

									aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
									aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
								Else
									oSection3:Cell("nSAIQtd"):Show()
									oSection3:Cell("nSAICus"):Show()
						
									aSldDia[len(aSldDia),07] +=  (cAliasTOP)->QUANTIDADE

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
									aSldDia[len(aSldDia),07] +=  (cAliasTOP)->QUANTIDADE

									aSalAtu[1]			+= (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1]	+= (cAliasTOP)->CUSTO
									aSalAtu[7]			+= (cAliasTOP)->QUANT2UM
								Else
									oSection3:Cell("nSAIQtd"):Show()
					
									aSldDia[len(aSldDia),08] +=  (cAliasTOP)->QUANTIDADE

									aSalAtu[1]			-= (cAliasTOP)->QUANTIDADE
									aSalAtu[mv_par10+1]	-= (cAliasTOP)->CUSTO
									aSalAtu[7]			-= (cAliasTOP)->QUANT2UM
								EndIf
								If lCusFil .Or. lCusEmp
									lPriApropri:=.T.
								EndIf
							EndIf
					EndCase
					

					// Tratamento para impressao em formato tabela quanto o produto nao tiver movimentacao
					If lFormTab .And. Iif(len(aDadosTran) >13, Alltrim(aDadosTran[14]) == "SB1",Alltrim((cAliasTop)->ARQ) == "SB1")
						//oSection3:Cell("dDtMov"):SetValue(STOD(""))
						/*oSection3:Cell("cLocal"):SetValue("")
						oSection3:Cell("cTES"):SetValue("")
						oSection3:Cell("cProduto"):SetValue("")
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
						oSection3:PrintLine()*/
					EndIf

					aDadosTran := {}
					lTransEnd := .T.

					If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
						If !lContinua //Acerto para utilizar o Array aDadosTranf[]
							dbSkip()
						EndIf
					EndIf
				EndDo

				oSection1:Finish()
				oSection2:Finish()
				If !lImpSMov .Or. (lFormTab .And. Alltrim((cAliasTop)->ARQ) == "SB1")
					oSection3:Finish()
				Endif
			EndDo

			//aqui imprime 
			//aSldDia
			For nSldDia := 1 to len(aSldDia)
				oSection3:Cell("cLocal"):SetValue(aSldDia[nSldDia,01])
				oSection3:Cell("cPrateleira"):SetValue(aSldDia[nSldDia,02])
				oSection3:Cell("cProduto"):SetValue(aSldDia[nSldDia,03])
				oSection3:Cell("cDescric"):SetValue(aSldDia[nSldDia,04])
				oSection3:Cell("cDoc"):SetValue(aSldDia[nSldDia,05])
				oSection3:Cell("nENTQtd"):SetValue(aSldDia[nSldDia,06])
				oSection3:Cell("nENTCus"):SetValue(aSldDia[nSldDia,07])
				oSection3:Cell("nSAIQtd"):SetValue(aSldDia[nSldDia,08])
				oSection3:Cell("nSALDQtd"):SetValue(aSldDia[nSldDia,06] + aSldDia[nSldDia,07] - aSldDia[nSldDia,08])
				oSection3:PrintLine()
			Next nSldDia

			dbSelectArea(cAliasTop)

			If lCusEmp
				Exit
			EndIf

		EndIf

	Next nForFilial

EndIf

// Restaura Filial Corrente
cFilAnt := cFilBack

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR900val� Autor � Paulo Boschetti       � Data � 22.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valida parametro mv_par09 - (d)OCUMENTO/(s)EQUENCIA        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Mtr900val()
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MTR900Dev� Autor � Rodrigo de A. Sartorio� Data � 17/07/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Avalia se item pertence a uma nota de devolu�ao             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MTR900Dev(ExpC1,ExpC2)				                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias                                              ���
���          � ExpC2 = Alias Top                                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR900VAlm � Autor �Rodrigo de A. Sartorio � Data �26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida Almoxarifado do KARDEX com relacao a custo unificado ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T. / .F.                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MTR900VAlm()
Local lRet:=.T.
Local cConteudo:=&(ReadVar())
Local nOpc:=2
//��������������������������������������������������������������Ŀ
//�MV_CUSFIL - Parametro utilizado para verificar se o sistema   |
//|utiliza custo unificado por:                                  |
//|      F = Custo Unificado por Filial                          |
//|      E = Custo Unificado por Empresa                         |
//|      A = Custo Unificado por Armazem                         |
//����������������������������������������������������������������
Local lCusFil    := AllTrim(SuperGetMV('MV_CUSFIL' ,.F.,"A")) == "F"
Local lCusEmp    := AllTrim(SuperGetMv('MV_CUSFIL' ,.F.,"A")) == "E"

If lCusFil .And. cConteudo != Repl("*",TamSX3("B2_LOCAL")[1])
	nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten��o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
If lCusEmp .And. cConteudo != Repl("#",TamSX3("B2_LOCAL")[1])
	nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten��o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MR900ImpS1� Autor � Nereu Humberto Junior � Data � 25/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime a secao 1 e 2 (Dados do produto)                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �MR900ImpS1(@ExpA1,ExpC1,ExpL1,ExpL2,ExpL3,ExpO1,ExpO2,ExpO3)���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com informacoes do saldo inicial do item     ���
���          �   [1] = Saldo inicial em quantidade                        ���
���          �   [2] = Saldo inicial em valor                             ���
���          �   [3] = Saldo inicial na 2a unidade de medida              ���
���          � ExpC1 = Alias                                              ���
���          � ExpL1 = Top                                                ���
���          � ExpL2 = Veiculo                                            ���
���          � ExpL3 = Custo Unificado                                    ���
���          � ExpO1 = Secao 1                                            ���
���          � ExpO2 = Secao 2                                            ���
���          � ExpO3 = obj Report                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MR900ImpS1(aSalAtu,cAliasTop,lQuery,lVEIC,lCusFil,lCusEmp,oSection1,oSection2,oReport,aFils)

Local aArea     := GetArea()
Local nCusMed   := 0
Local i         := 0
Local nIndice   := 0
Local aSalAlmox := {}
Local cSeek     := ""
Local cFilBkp   := cFilAnt
Local cTrbSB2	:= CriaTrab(,.F.)
Local lSB2Mode  := .F.

Default lQuery   := .F.
Default cAliasTop:="SB1"
Default lCusFil  := .F.
default lCusEmp  := .F.
Default aFils    := {}

//������������������������������������������������Ŀ
//� Calcula o Saldo Inicial do Produto             �
//��������������������������������������������������
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
	aArea	 := GetArea()
	aSalAtu  := { 0,0,0,0,0,0,0 }
	dbSelectArea("SB2")
	dbSetOrder(1)
	INDREGUA("SB2",cTrbSB2,"B2_COD+B2_LOCAL",,,STR0019)	//"Selecionando Registros"
	nIndice := RetIndex("SB2")
	dbSetOrder(nIndice+1)
	dbSeek(cSeek:=If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD))
	While !Eof() .And. SB2->B2_COD == cSeek
		If !Empty(xFilial("SB2"))
			cFilAnt := SB2->B2_FILIAL
		Else
			lSB2Mode := .T.
		EndIf
		If (!lSB2Mode .And. aScan(aFils, {|x| AllTrim(cFilAnt) $  AllTrim(x) }) > 0) .Or. lSB2Mode
			aSalAlmox := CalcEst(If(lQuery,(cAliasTOP)->PRODUTO,SB1->B1_COD),SB2->B2_LOCAL,mv_par05,,,( lCusRep .And. mv_par17==2 ) )
			For i:=1 to Len(aSalAtu)
				aSalAtu[i] += aSalAlmox[i]
			Next i
		EndIf
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
//������������������������������������������������Ŀ
//� Calcula o Custo de Reposicao do Produto        �
//��������������������������������������������������
If lCusRep .And. mv_par17==2
	aSalAtu := {aSalAtu[1],aSalAtu[18],aSalAtu[19],aSalAtu[20],aSalAtu[21],aSalAtu[22],aSalAtu[07]}
EndIf
//������������������������������������������������Ŀ
//� Calcula o Custo Medio do Produto               �
//��������������������������������������������������
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
If lVEIC
	oSection2:Cell("cProduto"):SetValue((cAliasTop)->PRODUTO)
	oSection2:Cell("cTipo"	 ):SetValue((cAliasTop)->TIPO	)
Endif

dbSelectArea("SB2")
MsSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusFil .Or. lCusEmp,"",mv_par08))

//oSection1:PrintLine()
//oSection2:PrintLine()

RestArea(aArea)

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR900IsMNT� Autor � Lucas                � Data � 03.10.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se ha integra��o com o modulo SigaMNT/NG          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR900                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Retorna descri��o referente a OP ou Ordem de servi�o

@autor Maria Elisandra de Paula
@since 15/07/2021
@param cOp, string, n�mero da ordem de produ��o
@param lFuncMnt, boolean, se existe fun��o
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

/*/{Protheus.doc} A900GetMV
	GetMV
	@type  Static Function
	@author g.moreira
	@since 10/04/2023
/*/
Static Function A900GetMV(nTipo, cParam, lHelp, xDefault, cFilMv)
	Local xRet := Nil
	If nTipo == 1
		xRet := GetMv(cParam, lHelp, xDefault)
	Else
		xRet := SuperGetMv(cParam, lHelp, xDefault, cFilMv)
	EndIf
Return xRet
