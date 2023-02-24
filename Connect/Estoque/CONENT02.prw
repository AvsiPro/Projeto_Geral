#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONENT02  ³ Autor ³ Leonardo Paiva ³ Data ³23/02/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Entrada						                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CONENT02

Local oReport

PRIVATE lAuto    := .F. 

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
±±³Programa  ³ ReportDef³Autor  ³Leonardo Paiva     ³Data  ³23/02/2023 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Dados para exibição                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
Static Function ReportDef()
Local oReport 
Local oSection1 
//Local oBreak
Local cTitle := "Relatório de Entrada"

Pergunte("CONENT02",.F.)

oReport := TReport():New("CONENT02",cTitle,If(lAuto,Nil,"CONENT02"), {|oReport| ReportPrint(oReport)},"") 
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
oSection1:= TRSection():New(oReport,"Connect",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"Filial","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_FILIAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Documento","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_DOC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Item","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_ITEM")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Codigo","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_COD")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descricao"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_DESC")[1],/*lPixel*/)
TRCell():New(oSection1,"Uni_Med","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_UM")[1],/*lPixel*/)
TRCell():New(oSection1,"Quantidade"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_QUANT")[1],/*lPixel*/)

TRCell():New(oSection1,"Valor_Unit","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D1_VUNIT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Total","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D1_TOTAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)


Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
Local cQuery 	:= ""
Local aAux      :=  {}
Local nCont

cQuery := " SELECT D1_FILIAL,D1_DOC,D1_ITEM,D1_COD,B1_DESC,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_EMISSAO "
cQuery += " FROM "+RetSQLName("SD1")+" D1"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=D1_COD AND B1.D_E_L_E_T_=' '"
cQuery += " WHERE D1_FILIAL ='"+ MV_PAR01 +"' AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
cQuery += " AND D1.D_E_L_E_T_='' AND D1_COD LIKE 'I%'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")


While !EOF()
        Aadd(aAux,{TRB->D1_FILIAL,TRB->D1_DOC,TRB->D1_ITEM,TRB->D1_COD,;
                    TRB->B1_DESC,TRB->D1_UM,TRB->D1_QUANT,;
                    TRB->D1_VUNIT,TRB->D1_TOTAL,TRB->D1_EMISSAO})
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()
 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Filial'):SetValue(aAux[nCont,01])
    oSection1:Cell('Documento'):SetValue(aAux[nCont,02])
    oSection1:Cell('Item'):SetValue(aAux[nCont,03])
    oSection1:Cell('Codigo'):SetValue(aAux[nCont,04])
    oSection1:Cell('Descricao'):SetValue(aAux[nCont,05])
    oSection1:Cell('Uni_Med'):SetValue(aAux[nCont,06])
    oSection1:Cell('Quantidade'):SetValue(aAux[nCont,07])
    oSection1:Cell('Valor_Unit'):SetValue(aAux[nCont,08])
    oSection1:Cell('Valor_Total'):SetValue(aAux[nCont,09])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,10]))

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
