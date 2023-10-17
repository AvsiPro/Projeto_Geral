#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JGFRR002  ³ Autor ³ Alexandre Venancio  ³ Data ³18/09/2023  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Durabilidade de peças                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function JGFRR002

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf	

oReport:= ReportDef()
oReport:PrintDialog()
                                               
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³Alexandre Venancio     ³Data  ³18/09/2023 ±±
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
//Local oBreak
Local cTitle := "Relatório de Durabilidade de peças"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("JGFRR002",.F.)

oReport := TReport():New("JGFRR002",cTitle,If(lAuto,Nil,"JGFRR002"), {|oReport| ReportPrint(oReport)},"") 
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
oSection1:= TRSection():New(oReport,"Robsol",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"Material","TRB",/*Titulo*/,/*Picture*/,TamSX3("B1_DESC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Veiculo","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_CODBEM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Requisicao","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_NUMSA")[1]+TamSX3("TL_ITEMSA")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Data_Saida","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_DTMPFIM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Qtde"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_QUANTID")[1],/*lPixel*/)
TRCell():New(oSection1,"Vlr.Saida","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("TL_CUSTO")[1],/*lPixel*/)
TRCell():New(oSection1,"Vlr.Atual"	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("TL_CUSTO")[1],/*lPixel*/)
TRCell():New(oSection1,"Filial" 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_FILIAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Loc","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_LOCAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Km na data","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_POSCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Km Ult. Trc","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_POSCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Dt Ult. Trc","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_DTMPFIM")[1],/*lPixel*/)
TRCell():New(oSection1,"KM","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_DTMPFIM")[1],/*lPixel*/)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Alexandre Inacio Lemes ³Data  ³11/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao das Solicitacoes de Compras                        ³±±
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
Local aAux      :=  {}
Local nCont

//TL_CODIGO,B1_DESC,TJ_CODBEM,TL_NUMSA+TL_ITEMSA,TJ_DTMPFIM,TL_QUANTID,TL_CUSTO,
//TL_CUSTO,TJ_FILIAL,TL_LOCAL,TL_POSCONT,TL_SEQRELA,'ULTIMATROCA','DATAULTIMATROCA','KMULTIMATROCA'

cQuery := "SELECT TL_CODIGO,B1_DESC,TJ_CODBEM,TL_NUMSA+TL_ITEMSA AS REQUISICAO,"
cQuery += " TJ_DTMPFIM,TL_QUANTID,TL_CUSTO,TJ_FILIAL,TL_LOCAL,TJ_POSCONT,"
cQuery += " TL_SEQRELA,'ULTIMATROCA' AS ULTTROCA,'DATAULTIMATROCA' AS DATULTTR,'KMULTIMATROCA' AS KMULTTR"
cQuery += " FROM "+RetSQLName("STL")+" STL"
cQuery += " INNER JOIN "+RetSQLName("STJ")+" STJ ON TJ_FILIAL=TL_FILIAL AND TJ_ORDEM=TL_ORDEM AND TJ_PLANO=TL_PLANO AND STJ.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=TL_CODIGO AND B1.D_E_L_E_T_=' '
cQuery += " WHERE STL.D_E_L_E_T_=' '"
cQuery += " ORDER BY TJ_CODBEM,TJ_ORDEM,TL_SEQRELA DESC,TL_CODIGO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->TL_CODIGO+Alltrim(TRB->B1_DESC),;
                TRB->TJ_CODBEM,;
                TRB->REQUISICAO,;
                TRB->TJ_DTMPFIM,;
                TRB->TL_QUANTID,;
                TRB->TL_CUSTO,;
                TRB->TL_CUSTO,;
                TRB->TJ_FILIAL,;
                TRB->TL_LOCAL,;
                TRB->TJ_POSCONT,;
                TRB->ULTTROCA,;
                TRB->DATULTTR,;
                TRB->KMULTTR })
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Material'):SetValue(aAux[nCont,01])
    oSection1:Cell('Veiculo'):SetValue(aAux[nCont,02])
    oSection1:Cell('Requisicao'):SetValue(aAux[nCont,03])
    oSection1:Cell('Data_Saida'):SetValue(stod(aAux[nCont,04]))
    oSection1:Cell('Qtde'):SetValue(aAux[nCont,05])
    oSection1:Cell('Vlr.Saida'):SetValue(aAux[nCont,06])
    oSection1:Cell('Vlr.Atual'):SetValue(aAux[nCont,07])
    oSection1:Cell('Filial'):SetValue(aAux[nCont,08])
    oSection1:Cell('Loc'):SetValue(aAux[nCont,09])
    oSection1:Cell('Km na data'):SetValue(aAux[nCont,10])
    oSection1:Cell('Km Ult. Trc'):SetValue(aAux[nCont,11])
    oSection1:Cell('Dt Ult. Trc'):SetValue(aAux[nCont,12])
    oSection1:Cell('KM'):SetValue(aAux[nCont,13])
    
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	

Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
