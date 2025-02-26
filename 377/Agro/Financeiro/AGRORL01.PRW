#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AGRORL01 ³ Autor ³ Alexandre Venancio      ³ Data ³28/07/23 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de saídas						                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AGRORL01

Local oReport

PRIVATE lAuto     := .F. 

oReport:= ReportDef()
oReport:PrintDialog()
                                               
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  Alexandre Venancio     ³Data  ³28/07/23 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Dados para exibição                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
Static Function ReportDef()
    Local oReport 
    Local oSection1 
    //Local oBreak
    Local cTitle := "Relatório de Vendas Titulos"

Pergunte("AGRORL01",.F.)

oReport := TReport():New("AGRORL01",cTitle,If(lAuto,Nil,"AGRORL01"), {|oReport| ReportPrint(oReport)},"") 
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
oSection1:= TRSection():New(oReport,"Agro",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
//Produto |Descrição prod |Emissão |vencimento(E2)| |Quantidade |Fornecedor | Descrição Forn| Lote | Valor (em moeda 2| Valor R$ |  Classe valor | Centro de custo
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 
TRCell():New(oSection1,"Produto","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_COD")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descrição","TRB",/*Titulo*/,/*Picture*/,TamSX3("B1_DESC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Data_Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Vencimento","TRB",/*Titulo*/,/*Picture*/,TamSX3("E2_VENCREA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Quantidade","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_QUANT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Fornecedor","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_FORNECE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descrição Fornecedor","TRB",/*Titulo*/,/*Picture*/,TamSX3("A2_NOME")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Lote","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_LOTECTL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor","TRB",/*Titulo*/,/*Picture*/ "@E 999,999,999.99",TamSX3("D1_VUNIT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Classe Valor","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_CLVL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Centro de Custo","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_CC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)


Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1) 
    Local cQuery 	:= ""
    Local aAux      :=  {}
    Local nCont
/*
MV_PAR01 := ' '
MV_PAR02 := 'zz'
MV_PAR03 := ctod('01/01/2020')
MV_PAR04 := ctod('31/12/2022')
*/
cQuery := "SELECT DISTINCT * "
cQuery += " FROM "+RetSQLName("SF1")+" F1"
cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND A2.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D1_COD AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SE2")+" E2 ON E2_FILIAL=F1_FILIAL AND E2_NUM=F1_DOC AND E2_PREFIXO=F1_SERIE AND E2_FORNECE=F1_FORNECE AND E2_LOJA=F1_LOJA AND E2.D_E_L_E_T_=' '"
cQuery += " WHERE F1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F1_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"
cQuery += " AND F1.D_E_L_E_T_=' ' "

If MV_PAR05 == 1
    cQuery += " AND F1_MOEDA='1'"
Else 
    cQuery += " AND F1_MOEDA='2'"
EndIf 

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")
						
While !EOF()
        Aadd(aAux,{ TRB->D1_COD,;
                    TRB->B1_DESC,;
                    TRB->F1_EMISSAO,;
                    TRB->E2_VENCREA,;
                    TRB->D1_QUANT,;
                    TRB->A2_COD+TRB->A2_LOJA,;
                    TRB->A2_NOME,;
                    TRB->D1_LOTECTL,;
                    TRB->D1_VUNIT,;
                    TRB->D1_CLVL,;
                    TRB->D1_CC,;
                    TRB->F1_MOEDA})  
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

For nCont := 1 to len(aAux) 

    cDestino := ""

    oSection1:Cell('Produto'):SetValue(aAux[nCont,01])
    oSection1:Cell('Descrição'):SetValue(aAux[nCont,02])
    oSection1:Cell('Data_Emissao'):SetValue(stod(aAux[nCont,03]))
    oSection1:Cell('Vencimento'):SetValue(stod(aAux[nCont,04]))
    oSection1:Cell('Quantidade'):SetValue(aAux[nCont,05])
    oSection1:Cell('Fornecedor'):SetValue(aAux[nCont,06])
    oSection1:Cell('Descrição Fornecedor'):SetValue(aAux[nCont,07])
    oSection1:Cell('Lote'):SetValue(aAux[nCont,08])

    If aAux[nCont,12] == 1
        oSection1:Cell('Valor'):SetValue(aAux[nCont,09])
    else 
        dbSelectArea("SM2")
        DbSetOrder(1)
        If Dbseek(xFilial("SM2")+aAux[nCont,03])
            oSection1:Cell('Valor'):SetValue((aAux[nCont,09] * SM2->M2_MOEDA2))
        Else 
            oSection1:Cell('Valor'):SetValue(aAux[nCont,09])
        endif 
    EndIf 

    oSection1:Cell('Classe Valor'):SetValue(aAux[nCont,10])
    oSection1:Cell('Centro de Custo'):SetValue(aAux[nCont,11])
    
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
