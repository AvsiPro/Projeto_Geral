#INCLUDE "CNTR050.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CNTR050  ³ Autor ³ Microsiga S/A         ³ Data ³23/04/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Listagem de Medicao X Notas Fiscais                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
User Function TTCNTR050()
Local oReport

If cEmpAnt == "01"
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
EndIF

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Microsiga S/A         ³ Data ³23.04.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oMedicao
Local oMedicao2
Local lRetSE1  := !Empty( SE1->( FieldPos( "E1_RETCNTR" ) ) )
Local lRetSE2  := !Empty( SE2->( FieldPos( "E2_RETCNTR" ) ) )
Private lPedVazio := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o Grupo de Perguntas                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01         // Numero inicial da medicao ?          ³
//³ mv_par02         // Numero Final da medicao ?            ³
//³ mv_par03         // Numero inicial do contrato ?         ³
//³ mv_par04         // Numero final do contrato ?           ³
//³ mv_par05         // Codigo inicial do fornecedor ?       ³
//³ mv_par06         // Codigo final do fornecedor ?         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("CNT050",.F.)

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
oReport:= TReport():New("CNTR050",STR0001,"CNT050", {|oReport| ReportPrint(oReport)},STR0002) //"Este relatorio emite uma relacao de medicoes por notas fiscais geradas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 1 - Medicao x Notas Fiscais - Compra                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMedicao := TRSection():New(oReport,STR0003,{"CND","CNE","SD1"})
oMedicao:SetTotalInLine(.F.)
oMedicao:SetNoFilter("SD1")
oMedicao:SetNoFilter("CNE")
oMedicao:SetReadOnly()

// Numero do Contrato
TRCell():New(oMedicao,'CND_CONTRA'	,'CND',STR0004+CRLF+STR0005,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Numero da Medicao
TRCell():New(oMedicao,'CND_NUMMED'	,'CND',STR0006+CRLF+STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Valor da Medicao
TRCell():New(oMedicao,'CNE_VLTOT'	,'CNE',STR0008+CRLF+STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

// Numero do Pedido de venda
TRCell():New(oMedicao,'PEDIDO'		,'SC6',"NUMERO" +CRLF +"PEDIDO",/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")

// Numero da Nota Fiscal
TRCell():New(oMedicao,'D1_DOC'		,'SD1',STR0009+CRLF+STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Serie da Nota Fiscal
TRCell():New(oMedicao,'D1_SERIE'		,'SD1',STR0011+CRLF+STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Valor Total da Nota Fiscal
TRCell():New(oMedicao,'D1_TOTAL'		,'SD1',STR0008+CRLF+STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
// Valor Total Pago (Titulo)
TRCell():New(oMedicao,'E2_SALDO'		,'SE2',STR0008+CRLF+STR0012,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
// Valor da Retencao (Titulo)
If lRetSE2
	TRCell():New(oMedicao,'E2_RETCNTR'	,'SE2',STR0008+CRLF+STR0013,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
EndIf	

oMedicao:SetTotalText(STR0016)  //"Total Geral :"
TRFunction():New(oMedicao:Cell("CNE_VLTOT")	,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oMedicao:Cell("D1_TOTAL")		,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oMedicao:Cell("E2_SALDO")		,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
If lRetSE2
	TRFunction():New(oMedicao:Cell("E2_RETCNTR")	,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sessao 2 - Medicao x Notas Fiscais - Venda                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMedicao2 := TRSection():New(oReport,STR0018,{"CND","CNE","SD2"})
oMedicao2:SetTotalInLine(.F.)
oMedicao2:SetNoFilter("SD2")
oMedicao2:SetNoFilter("CNE")     
oMedicao2:SetReadOnly()

// Numero do Contrato
TRCell():New(oMedicao2,'CND_CONTRA'	,'CND',STR0004+CRLF+STR0005,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Numero da Medicao
TRCell():New(oMedicao2,'CND_NUMMED'	,'CND',STR0006+CRLF+STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Valor da Medicao
TRCell():New(oMedicao2,'CNE_VLTOT'	,'CNE',STR0008+CRLF+STR0007,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

// Numero do Pedido de venda
TRCell():New(oMedicao2,'PEDIDO'		,'SC6',"NUMERO" +CRLF +"PEDIDO",/*Picture*/,14,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
     
// Numero da Nota Fiscal
TRCell():New(oMedicao2,'D2_DOC'		,'SD1',STR0009+CRLF+STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Serie da Nota Fiscal
TRCell():New(oMedicao2,'D2_SERIE'		,'SD1',STR0011+CRLF+STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"CENTER")
// Valor Total da Nota Fiscal
TRCell():New(oMedicao2,'D2_TOTAL'		,'SD1',STR0008+CRLF+STR0010,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
// Valor Total Pago (Titulo)
TRCell():New(oMedicao2,'E1_SALDO'		,'SE2',STR0008+CRLF+STR0012,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
// Valor da Retencao (Titulo)
If lRetSE1
	TRCell():New(oMedicao2,'E1_RETCNTR'	,'SE2',STR0008+CRLF+STR0013,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
EndIf

oMedicao2:SetTotalText(STR0016)  //"Total Geral :"
TRFunction():New(oMedicao2:Cell("CNE_VLTOT")	,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oMedicao2:Cell("D2_TOTAL")		,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oMedicao2:Cell("E1_SALDO")		,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
If lRetSE1
	TRFunction():New(oMedicao2:Cell("E1_RETCNTR")	,NIL,"SUM",/*oBreak1*/,,/*cPicture*/,/*uFormula*/,.T.,.F.)
EndIf

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Microsiga S/A         ³ Data ³23.04.2007³±±
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

Local oMedicao := oReport:Section(1)
Local oMedicao2:= oReport:Section(2)
Local cAliasRel:= GetNextAlias()
Local cAliasSD1:= GetNextAlias()
Local cAliasSE2:= GetNextAlias()
Local cAliasSD2:= GetNextAlias()
Local cAliasSE1:= GetNextAlias()
Local cNumPed  := ''
Local cNumDoc  := ''
Local cSerie   := ''
Local lFstCpr  := .T.
Local lFstVnd  := .T.
Local oBreak01
Local oBreak02
Local lRetSE1  := !Empty( SE1->( FieldPos( "E1_RETCNTR" ) ) )
Local lRetSE2  := !Empty( SE2->( FieldPos( "E2_RETCNTR" ) ) )  
Local cFornece := ''
Local cLoja    := ''
Local nMoedaD  := 1
Local dDataRef := If(Empty(mv_par09),dDataBase,mv_par09)
Local lPedSem := .F.
Local cExpCompet := ""



// Quebra por Contrato
If mv_par05 == 1
	// Sub-Totais por Contrato
	oBreak01 := TRBreak():New(oMedicao,oMedicao:Cell("CND_CONTRA"),STR0017,.F.) //"Sub-Total por Contrato :"
	TRFunction():New(oMedicao:Cell("CNE_VLTOT")	,NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oMedicao:Cell("D1_TOTAL")	,NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oMedicao:Cell("E2_SALDO")	,NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	If lRetSE2
		TRFunction():New(oMedicao:Cell("E2_RETCNTR"),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	EndIf

	// Sub-Totais por Contrato
	oBreak02 := TRBreak():New(oMedicao2,oMedicao2:Cell("CND_CONTRA"),STR0017,.F.) //"Sub-Total por Contrato :"
	TRFunction():New(oMedicao2:Cell("CNE_VLTOT")	,NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oMedicao2:Cell("D2_TOTAL")	,NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oMedicao2:Cell("E1_SALDO")	,NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	If lRetSE1
		TRFunction():New(oMedicao2:Cell("E1_RETCNTR"),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	EndIf
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipo := If(MV_PAR06==1,"1','2',' ",If(MV_PAR06==2,"1',' ","2"))


oMedicao:BeginQuery()	
	BeginSql Alias cAliasRel
		SELECT DISTINCT CND_CONTRA, CND_NUMMED ,SUM(CNE_VLTOT) CNE_VLTOT ,CNE_PEDIDO, CN1_ESPCTR, CND_MOEDA, CN9_MOEDA
		FROM %table:CND% CND, %table:CNE% CNE, %table:CN9% CN9, %table:CN1% CN1
		WHERE CND_FILIAL = %xFilial:CND% AND 
				CNE_FILIAL = %xFilial:CNE% AND 
				CN9_FILIAL = %xFilial:CN9% AND 
				CN1_FILIAL = 	%xFilial:CN1% AND 
				CND_CONTRA = CNE_CONTRA AND
				CND_NUMMED = CNE_NUMMED AND 
				CND_CONTRA = CN9_NUMERO AND
				CND_REVISA = CN9_REVISA AND
				CNE_REVISA = CND_REVISA AND
				CN1_CODIGO = CN9_TPCTO AND
				CND_CONTRA >= %Exp:mv_par01% AND
				CND_CONTRA <= %Exp:mv_par02% AND
				CNE_NUMMED >= %Exp:mv_par03% AND
				CNE_NUMMED <= %Exp:mv_par04% AND 
				CN1_ESPCTR in (%Exp:cTipo%) AND
				CND_COMPET = %Exp:mv_par10% AND 	//COMPETENCIA
				//CNE_PEDIDO <> %Exp:" "% AND
				CND.%NotDel%  AND
				CNE.%NotDel% AND
				CN9.%NotDel% AND
				CN1.%NotDel%
		GROUP BY CND_CONTRA,CND_REVISA,CND_NUMMED,CND_MOEDA,CN9_MOEDA,CNE_PEDIDO,CN1_ESPCTR
		ORDER BY CN1_ESPCTR,CND_CONTRA,CND_NUMMED
	EndSql
oMedicao:EndQuery()

If mv_par07 == 4
	nMoedaD := mv_par08 + 1
	oReport:SetTitle(oReport:Title() +STR0019 +AllTrim(GetMv("MV_SIMB" +Ltrim(Str(nMoedaD)))) +")")
EndIf

dbSelectArea(cAliasRel)
dbGoTop()

Do While !oReport:Cancel() .And. !(cAliasRel)->(Eof())

	If mv_par07 == 1
		nMoedaD := (cAliasRel)->CND_MOEDA
	ElseIf mv_par07 == 2
		nMoedaD := (cAliasRel)->CN9_MOEDA
	EndIf

	oReport:IncMeter()

	cNumPed := (cAliasRel)->CNE_PEDIDO

	If (cAliasRel)->CN1_ESPCTR == '1' .OR. Empty((cAliasRel)->CN1_ESPCTR)
		If lFstCpr
			oMedicao:Init()
			lFstCpr := .F.
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query utilizada para compor o valor total da nota de entrada - SD1      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BeginSql Alias cAliasSD1
			SELECT D1_DOC, D1_SERIE, SUM(D1_TOTAL) D1_TOTAL, D1_FORNECE, D1_LOJA 
			FROM %table:SD1% SD1
			WHERE D1_FILIAL = %xFilial:SD1% AND 
					D1_PEDIDO = %Exp:cNumPed% AND
					SD1.%NotDel%
			GROUP BY D1_DOC,D1_SERIE, D1_FORNECE, D1_LOJA
		EndSql
		
		dbSelectArea(cAliasSD1)
		dbGoTop()
		Do While !Eof()
	
			cNumDoc := (cAliasSD1)->D1_DOC
			cSerie  := (cAliasSD1)->D1_SERIE 
			cFornece:= (cAliasSD1)->D1_FORNECE
			cLoja   := (cAliasSD1)->D1_LOJA
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Query utilizada para compor o valor total do titulo - SE2               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRetSE2
				BeginSql Alias cAliasSE2
					SELECT SUM(E2_VALOR) E2_VALOR,SUM(E2_SALDO) E2_SALDO,SUM(E2_RETCNTR) E2_RETCNTR, E2_MOEDA
					FROM %table:SE2% SE2
					WHERE E2_FILIAL = %xFilial:SE2%    AND 
							E2_NUM = %Exp:cNumDoc%     AND
							E2_PREFIXO = %Exp:cSerie%  AND
							E2_FORNECE = %Exp:cFornece% AND
							E2_LOJA    = %Exp:cLoja%   AND
							SE2.%NotDel%
					GROUP BY E2_PREFIXO,E2_NUM,E2_MOEDA
				EndSql
			Else
				BeginSql Alias cAliasSE2
					SELECT SUM(E2_VALOR) E2_VALOR,SUM(E2_SALDO) E2_SALDO, E2_MOEDA
					FROM %table:SE2% SE2
					WHERE E2_FILIAL = %xFilial:SE2%     AND 
							E2_NUM = %Exp:cNumDoc%      AND
							E2_PREFIXO = %Exp:cSerie%   AND  
							E2_FORNECE = %Exp:cFornece% AND
							E2_LOJA    = %Exp:cLoja%    AND
							SE2.%NotDel%
					GROUP BY E2_PREFIXO,E2_NUM,E2_MOEDA
				EndSql			
			EndIf
		
			dbSelectArea(cAliasSE2)
			dbGoTop()
			Do While !Eof()
				oMedicao:Cell('CND_CONTRA'):SetValue((cAliasRel)->CND_CONTRA)
				oMedicao:Cell('CND_NUMMED'):SetValue((cAliasRel)->CND_NUMMED)
				oMedicao:Cell('CNE_VLTOT' ):SetValue(Round(xMoeda((cAliasRel)->CNE_VLTOT,(cAliasRel)->CND_MOEDA,nMoedaD,dDataRef,6),TamSX3('CNE_VLTOT')[2]))
				oMedicao:Cell('D1_DOC'    ):SetValue((cAliasSD1)->D1_DOC)
				oMedicao:Cell('D1_SERIE'  ):SetValue((cAliasSD1)->D1_SERIE)
				oMedicao:Cell('D1_TOTAL'  ):SetValue(Round(xMoeda((cAliasSD1)->D1_TOTAL,1,nMoedaD,dDataRef,6),TamSX3('D1_TOTAL')[2]))
				oMedicao:Cell('E2_SALDO'  ):SetValue(Round(xMoeda((cAliasSE2)->E2_VALOR - (cAliasSE2)->E2_SALDO,(cAliasSE2)->E2_MOEDA,nMoedaD,dDataRef,6),TamSX3('E2_SALDO')[2]))
				If lRetSE2
					oMedicao:Cell('E2_RETCNTR'):SetValue(Round(xMoeda((cAliasSE2)->E2_RETCNTR,(cAliasSE2)->E2_MOEDA,nMoedaD,dDataRef,6),TamSX3('E2_RETCNTR')[2]))
				EndIf
			 	oMedicao:PrintLine()
				dbSelectArea(cAliasSE2)
				dbSkip()
			EndDo
	
			// Fecha o alias da query
			(cAliasSE2)->(dbCloseArea())
	
			dbSelectArea(cAliasSD1)
			dbSkip()
		EndDo
	
		// Fecha o alias da query
		(cAliasSD1)->(dbCloseArea())
	Else
		If lFstVnd
			If !lFstCpr
				oMedicao:Finish()
				lFstCpr:=.T.
			EndIf
			
			oMedicao2:Init()
			lFstVnd := .F.
		EndIf
	    
	    // Existe pedido, procura a nf e titulo
		If AllTrim(cNumPed) <> ""
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Query utilizada para compor o valor total da nota de saida - SD2        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			BeginSql Alias cAliasSD2
				SELECT D2_DOC, D2_SERIE, SUM(D2_TOTAL) D2_TOTAL
				FROM %table:SD2% SD2
				WHERE D2_FILIAL = %xFilial:SD2% AND 
						D2_PEDIDO = %Exp:cNumPed% AND
						SD2.%NotDel%
				GROUP BY D2_DOC,D2_SERIE
			EndSql

			dbSelectArea(cAliasSD2)
			dbGoTop()
			Do While !Eof()
		
				cNumDoc := (cAliasSD2)->D2_DOC
				cSerie  := (cAliasSD2)->D2_SERIE
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Query utilizada para compor o valor total do titulo - SE1               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRetSE1
					BeginSql Alias cAliasSE1
						SELECT SUM(E1_VALOR) E1_VALOR,SUM(E1_SALDO) E1_SALDO,SUM(E1_RETCNTR) E1_RETCNTR, E1_MOEDA
						FROM %table:SE1% SE1
						WHERE E1_FILIAL = %xFilial:SE1% AND 
								E1_NUM = %Exp:cNumDoc%    AND
								E1_SERIE = %Exp:cSerie% AND
								SE1.%NotDel%
						GROUP BY E1_PREFIXO,E1_NUM,E1_MOEDA
					EndSql
				Else
					BeginSql Alias cAliasSE1
						SELECT SUM(E1_VALOR) E1_VALOR,SUM(E1_SALDO) E1_SALDO, E1_MOEDA, E1_MOEDA
						FROM %table:SE1% SE1
						WHERE E1_FILIAL = %xFilial:SE1% AND 
								E1_NUM = %Exp:cNumDoc%    AND
								E1_SERIE = %Exp:cSerie% AND
								SE1.%NotDel%
						GROUP BY E1_PREFIXO,E1_NUM,E1_MOEDA
					EndSql			
				EndIf        
		
				dbSelectArea(cAliasSE1)
				dbGoTop()
				Do While !Eof()
					cNumPed := Padc(cNumPed,14)
					oMedicao2:Cell('CND_CONTRA'):SetValue((cAliasRel)->CND_CONTRA)
					oMedicao2:Cell('CND_NUMMED'):SetValue((cAliasRel)->CND_NUMMED)
					oMedicao2:Cell('CNE_VLTOT' ):SetValue(Round(xMoeda((cAliasRel)->CNE_VLTOT,(cAliasRel)->CND_MOEDA,nMoedaD,dDataRef,6),TamSX3('CNE_VLTOT')[2]))
					oMedicao2:Cell('PEDIDO'    ):SetValue(cNumPed)
					oMedicao2:Cell('D2_DOC'    ):SetValue((cAliasSD2)->D2_DOC)
					oMedicao2:Cell('D2_SERIE'  ):SetValue((cAliasSD2)->D2_SERIE)
					oMedicao2:Cell('D2_TOTAL'  ):SetValue(Round(xMoeda((cAliasSD2)->D2_TOTAL,1,nMoedaD,dDataRef,6),TamSX3('D1_TOTAL')[2]))
					oMedicao2:Cell('E1_SALDO'  ):SetValue(Round(xMoeda((cAliasSE1)->E1_VALOR - (cAliasSE1)->E1_SALDO,(cAliasSE1)->E1_MOEDA,nMoedaD,dDataRef,6),TamSX3('E1_SALDO')[2]))
					If lRetSE1
						oMedicao2:Cell('E1_RETCNTR'):SetValue(Round(xMoeda((cAliasSE1)->E1_RETCNTR,(cAliasSE1)->E1_MOEDA,nMoedaD,dDataRef,6),TamSX3('E1_RETCNTR')[2]))
					EndIf
				 	oMedicao2:PrintLine()
					dbSelectArea(cAliasSE1)
					dbSkip()
				EndDo
		
				// Fecha o alias da query
				(cAliasSE1)->(dbCloseArea())
		
				dbSelectArea(cAliasSD2)
				dbSkip()
			EndDo
			
			// tem pedido mas nao encontrou nota
			If cNumDoc == "" .And. cSerie == ""
				lPedSem := .T.
			EndIf 
			
			// Fecha o alias da query
			(cAliasSD2)->(dbCloseArea())
	    EndIf
		          
		// possui pedido mas nao encontrou a nota, vai mostrar sem nota e sem valor
		If lPedSem .Or. AllTrim(cNumPed) == ""
			If Alltrim(cNumPed) == ""
				cNumPed := "PV NAO GERADO"
			Else	
				cNumPed := PadC(cNumPed,14)
			EndIf
			oMedicao2:Cell('CND_CONTRA'):SetValue((cAliasRel)->CND_CONTRA)
			oMedicao2:Cell('CND_NUMMED'):SetValue((cAliasRel)->CND_NUMMED)
			oMedicao2:Cell('CNE_VLTOT' ):SetValue(Round(xMoeda((cAliasRel)->CNE_VLTOT,(cAliasRel)->CND_MOEDA,nMoedaD,dDataRef,6),TamSX3('CNE_VLTOT')[2]))
			oMedicao2:Cell('PEDIDO'    ):SetValue(cNumPed)
			oMedicao2:Cell('D2_DOC'    ):SetValue("")
			oMedicao2:Cell('D2_SERIE'  ):SetValue("")
			oMedicao2:Cell('D2_TOTAL'  ):SetValue(0)
			oMedicao2:Cell('E1_SALDO'  ):SetValue(0)
			If lRetSE1
				oMedicao2:Cell('E1_RETCNTR'):SetValue(0)
			EndIf
		 	oMedicao2:PrintLine()
		 EndIf	
	EndIf
	
	cNumDoc := ""
	cSerie := ""
	cNumPed := ""                            
		
	dbSelectArea(cAliasRel)
	dbSkip()
EndDo

If !lFstCpr
	oMedicao:Finish()
EndIf

If !lFstVnd
	oMedicao2:Finish()
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AjustaSX1³ Autor ³ Microsiga S/A         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta as perguntas do SX1                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTR050		                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local cPerg	   := "CNT050"

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Numero inicial do contrato"}
aHelpEng := {"Contract initial number."}
aHelpSpa := {"Numero inicial del contrato. "}

PutSX1(cPerg,"01","Contrato de","","","mv_ch1","C",15,0,0,"G","","CN9","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Numero final do contrato"}
aHelpEng := {"Contract final number."}
aHelpSpa := {"Numero final del contrato. "}

PutSX1(cPerg,"02","Contrato ate","","","mv_ch2","C",15,0,0,"G","","CN9","","S","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Numero inicial da medicao"}
aHelpEng := {"Measurement initial number"}
aHelpSpa := {"Numero inicial del medicion"}

PutSX1(cPerg,"03","Medicao de","","","mv_ch3","C",6,0,0,"G","","CND","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor := {"Numero final da medicao"}
aHelpEng := {"Measurement final number"}
aHelpSpa := {"Numero final del medicion"}

PutSX1(cPerg,"04","Medicao ate","","","mv_ch4","C",6,0,0,"G","","CND","","S","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor := {"Quebra o relatorio por subtotais"}
aHelpEng := {"subtotals report breaks"}
aHelpSpa := {"Quiebras el informe por subtotais"}

PutSX1(cPerg,"05","Imprimir Subtotais"     ,"","","mv_ch5","N",1,0,0,"C","","","","","mv_par05","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor := {"Filtra especie do contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"06","Esp. Contrato" ,"Esp. Contrat","ContractType","mv_ch6","N",1,0,0,"C","","","","","mv_par06","Ambos","Ambos","Both","","Compra","Compra","Purchase","Venda","Venta","Sale","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR07--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+"07")) 	
	aHelpPor := {"Define se a impressão dos valores","no relatório será realizada na","moeda da medição, contrato ou outra."}
	aHelpEng := {"Define if the values will be printed","using measurement, contract","or other currency."}
	aHelpSpa := {"Define si la impresión de los valores","en el informe será realizada en la ","moneda de la medición, contrato o otra."}
	
	PutSX1(cPerg,"07","Imprimir valores na moeda","Imprimir valores en moneda","Print values in currency","mv_ch7","N",1,0,0,"C","","","","S","mv_par07","Da medição","De la medición","From measurem.","","Do contrato","Del contrato","Of Contract","Da NF","De la Factura","From Invoice","Informada","Informada","Informed","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf

//---------------------------------------MV_PAR08--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+"08")) 	
	aHelpPor := {"Indica a moeda para impressão","dos valores. A pergunta anterior",'deve estar como "Informada".'}
	aHelpEng := {"Indica la moneda para impresión","de los valores. La pregunta anterior",'debe estar como "Informada".'}
	aHelpSpa := {"Indicates the values currency ","printing. The previous question must",'be set as "Informed".'}
	
	PutSX1(cPerg,"08","Moeda","Moneda","Currency","mv_ch8","N",1,0,0,"C","","","","S","mv_par08","Moeda 2","Moneda 2","Currency 2","","Moeda 3","Moneda 3","Currency 3","Moeda 4","Moneda 4","Currency 4","Moeda 5","Moneda 5","Currency 5","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf

//---------------------------------------MV_PAR09--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+"09")) 	
	aHelpPor := {"Data de referência para conversão","dos valores entre moedas."}
	aHelpEng := {"Fecha de referencia para conversión","de los valores entre monedas."}
	aHelpSpa := {"Reference date for values","convertion between currency."}
	
	PutSX1(cPerg,"09","Data de referencia","Fecha de referencia","Reference date","mv_ch9","D",8,0,0,"G","","","","S","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf


//---------------------------------------MV_PAR10--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+"10")) 	
	aHelpPor := {"Mês/Ano de Competência"}
	aHelpEng := {"Fecha de referencia para conversión","de los valores entre monedas."}
	aHelpSpa := {"Reference date for values","convertion between currency."}
	
	PutSX1(cPerg,"10","Mês/Ano Competência","Fecha de referencia","Reference date","mv_cha","C",7,0,0,"G","","","","S","mv_par10","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf


RestArea(aAreaAnt)
Return