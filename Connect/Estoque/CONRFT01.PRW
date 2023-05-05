#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONRFT01 ³ Autor ³ Leonardo Paiva      ³ Data ³23/02/2023 ³±±
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
User Function CONRFT01

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
±±³Programa  ³ ReportDef³Autor  Leonardo Paiva     ³Data  ³23/02/2023 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Dados para exibição                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
Static Function ReportDef()
    Local oReport 
    Local oSection1 
    //Local oBreak
    Local cTitle := "Relatório de Saídas"

Pergunte("CONRFT01",.F.)

oReport := TReport():New("CONRFT01",cTitle,If(lAuto,Nil,"CONRFT01"), {|oReport| ReportPrint(oReport)},"") 
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

TRCell():New(oSection1,"Filial","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_FILIAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Documento","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_DOC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Item","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_ITEM")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Codigo","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_COD")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descricao"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("B1_DESC")[1],/*lPixel*/)
TRCell():New(oSection1,"Uni_Med","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_UM")[1],/*lPixel*/)
TRCell():New(oSection1,"Quantidade"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_QUANT")[1],/*lPixel*/)

TRCell():New(oSection1,"Preco_Venda","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D2_PRCVEN")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Total","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"PontoVenda","TRB",/*Titulo*/,/*Picture*/,TamSX3("NNR_DESCRI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)


Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1) 
    Local cQuery 	:= ""
    Local aAux      :=  {}
    Local nCont

cQuery := "SELECT D2_FILIAL,D2_DOC,D2_ITEM,D2_COD,B1_DESC,D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_EMISSAO,C5_XCODPA,A1_COD,A1_NOME"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5.D_E_L_E_T_=' ' AND C5_XTPPED='A' "
cQuery += " WHERE D2.D_E_L_E_T_=' '"
cQuery += " AND D2_FILIAL = '"+ MV_PAR01  +"' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"'"
cQuery += " AND D2_COD LIKE 'I%' "

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
        Aadd(aAux,{TRB->D2_FILIAL,;
                    TRB->D2_DOC,;
                    TRB->D2_ITEM,;
                    TRB->D2_COD,;
                    TRB->B1_DESC,;
                    TRB->D2_UM,;
                    TRB->D2_QUANT,;
                    TRB->D2_PRCVEN,;
                    TRB->D2_TOTAL,;
                    TRB->D2_EMISSAO,;
                    TRB->C5_XCODPA,;
                    TRB->A1_COD,;
                    TRB->A1_NOME})  
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    cDestino := ""

    If !Empty(aAux[nCont,11])
        cDestino := aAux[nCont,11]+"-"+Posicione("NNR",1,xFilial("NNR")+aAux[nCont,11],"NNR_DESCRI")
    Else 
        cDestino := aAux[nCont,12]+"-"+Alltrim(aAux[nCont,13])
    EndIf 

    oSection1:Cell('Filial'):SetValue(aAux[nCont,01])
    oSection1:Cell('Documento'):SetValue(aAux[nCont,02])
    oSection1:Cell('Item'):SetValue(aAux[nCont,03])
    oSection1:Cell('Codigo'):SetValue(aAux[nCont,04])
    oSection1:Cell('Descricao'):SetValue(aAux[nCont,05])
    oSection1:Cell('Uni_Med'):SetValue(aAux[nCont,06])
    oSection1:Cell('Quantidade'):SetValue(aAux[nCont,07])
    oSection1:Cell('Preco_Venda'):SetValue(aAux[nCont,08])
    oSection1:Cell('Valor_Total'):SetValue(aAux[nCont,09])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,10]))
    oSection1:Cell('PontoVenda'):SetValue(cDestino)

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
/*	dbSelectArea("TRB")
	dbSkip()
EndDo                     
*/
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
