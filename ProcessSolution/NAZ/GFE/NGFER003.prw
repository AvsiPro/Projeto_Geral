#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ NGFER003  ³ Autor ³ AlexANDre Venancio  ³ Data ³10/04/2025 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Valores de Frete por Regional por cliente     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NGFER003

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","11")
EndIf	

oReport:= ReportDef()
oReport:PrintDialog()
                                               
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ReportDef³Autor  ³AlexANDre Venancio     ³Data  ³20/09/2023 ±±
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
Local cTitle := "Relatório de Analise de fretes"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("GFER040",.F.)

oReport := TReport():New("GFER040",cTitle,If(lAuto,Nil,"GFER040"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLANDscape() 

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
oSection1:= TRSection():New(oReport,"NAZ",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltANDo uma pagina em branco no inicio da impressao 

//Periodo	Regional	Valor Faturamento Bruto	Valor de frete s/ imposto 	% Frete s/ imposto

TRCell():New(oSection1,"Data","TRB",/*Titulo*/,/*Picture*/,30/*TamSX3("GW1_DTEMIS")[1]*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Regional","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_REGCOM")[1],/*lPixel*/)
TRCell():New(oSection1,"Código Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_CDDEST")[1],/*lPixel*/)
TRCell():New(oSection1,"Nome Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_NMDEST")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor Faturamento Bruto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Peso NF","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW3_FRPESO")[1],/*lPixel*/)
TRCell():New(oSection1,"Nome Transporadora","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW3_NMEMIS")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor Frete s/ Imposto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"% Frete s/ Imposto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³AlexANDre Inacio Lemes ³Data  ³11/07/2006³±±
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
Local aTotReg   :=  {}

//cQuery := " SELECT GW1_DTEMIS,GW1_REGCOM,GW1_CDDEST,SUM(GW8_VALOR) AS TOTAL  " 
cQuery := " SELECT GW1_REGCOM,GW1_CDDEST,SUM(GW8_VALOR) AS TOTAL  " 
cQuery += " FROM " + RetSQLName("GW1") + " GW1  " 
cQuery += " INNER JOIN " + RetSQLName("GW8") + " GW8 ON GW8_FILIAL = GW1_FILIAL AND GW1_CDTPDC=GW8_CDTPDC AND GW1_EMISDC=GW8_EMISDC AND GW1_SERDC=GW8_SERDC AND GW1_NRDC=GW8_NRDC AND GW8.D_E_L_E_T_=' '  " 
cQuery += " WHERE GW1_FILIAL+GW1_NRDC+GW1_CDTPDC+GW1_SERDC+GW1_EMISDC IN "
cQuery += "      (SELECT GW4_FILIAL+GW4_NRDC+GW4_TPDC+GW4_SERDC+GW4_EMISDC FROM " + RetSQLName("GW4") + " GW4  " 
cQuery += "         INNER JOIN " + RetSQLName("GW3") + " GW3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_EMISDF = GW4_EMISDF AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND GW3_DTEMIS = GW4_DTEMIS AND GW3.D_E_L_E_T_=' ' " 
cQuery += " WHERE GW4.D_E_L_E_T_=' ')  " 
cQuery += " AND GW1_DTEMIS BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' AND GW1_REGCOM<>' '  " 
//cQuery += " GROUP BY GW1_DTEMIS,GW1_REGCOM,GW1_CDDEST " 
cQuery += " GROUP BY GW1_REGCOM,GW1_CDDEST  " 
cQuery += " ORDER BY 1  " 

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
// SERIE,NOTA,EMISSAO,CFOP,CST,CNPJ,TIPOMOV,VALOR,ALIQUOTA,BASE,VALICM,CHAVE
    nPos := Ascan(aTotReg,{|x| x[1] == TRB->GW1_REGCOM} ) 
    //GW1_CDDEST,GW1_NMDEST,GW3_NMEMIS
    If nPos == 0
        Aadd(aTotReg,{TRB->GW1_REGCOM,TRB->TOTAL,0})
    Else 
        aTotReg[nPos,02] += TRB->TOTAL
    EndIf 

    ////POSICIONE("GU3",1,XFILIAL("GU3")+GW1->GW1_CDDEST,"GU3_NMEMIT")   
    //POSICIONE("GU3",1,XFILIAL("GU3")+GW3->GW3_EMISDF,"GU3_NMEMIT")                                 

    //TRB->GW1_NMDEST
    //TRB->GW3_NMEMIS
    //POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW3_EMISDF,"GU3_NMEMIT")
    // Aadd(aAux,{ TRB->GW1_DTEMIS,;
    //             TRB->GW1_REGCOM,;
    //             TRB->GW1_CDDEST,;
    //             POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW1_CDDEST,"GU3_NMEMIT"),;
    //             '',;
    //             TRB->TOTAL,;
    //             0,;
    //             0})
    Aadd(aAux,{ cvaltochar(MV_PAR09)+' a '+cvaltochar(MV_PAR10),;
                TRB->GW1_REGCOM,;
                TRB->GW1_CDDEST,;
                POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW1_CDDEST,"GU3_NMEMIT"),;
                '',;
                TRB->TOTAL,;
                0,;
                0,;
                0})

    Dbskip()
ENDDO

//GW3_BASIMP - GW3_VALIMP - GW3_VLCOF - GW3_VLPIS
//cQuery := "SELECT GW1_DTEMIS, GW1_REGCOM,GW1_CDDEST,GW3_EMISDF, SUM(GW3_BASIMP - GW3_VLIMP - GW3_VLCOF - GW3_VLPIS) AS FRETE " 
cQuery := "SELECT GW1_REGCOM,GW1_CDDEST,GW3_EMISDF,GW3_FRPESO, SUM(GW3_BASIMP - GW3_VLIMP - GW3_VLCOF - GW3_VLPIS) AS FRETE " 
cQuery += " FROM GW1010 GW1 " 
cQuery += " INNER JOIN GW4010 GW4 ON GW4_FILIAL = GW1_FILIAL AND GW1_NRDC = GW4_NRDC AND GW1_CDTPDC = GW4_TPDC AND GW1_SERDC = GW4_SERDC AND GW1_EMISDC = GW4_EMISDC AND GW4.D_E_L_E_T_ = ' ' " 
cQuery += " INNER JOIN GW3010 GW3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_EMISDF = GW4_EMISDF AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND GW3_DTEMIS = GW4_DTEMIS AND GW3.D_E_L_E_T_ = ' ' " 
cQuery += " WHERE GW1_DTEMIS BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"' AND GW1_REGCOM <> ' ' " 
//cQuery += " GROUP BY GW1_DTEMIS, GW1_REGCOM,GW1_CDDEST,GW3_EMISDF " 
cQuery += " GROUP BY GW1_REGCOM,GW1_CDDEST,GW3_EMISDF,GW3_FRPESO " 
cQuery += " ORDER BY 1"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    //,GW1_CDDEST,GW1_NMDEST,GW3_NMEMIS
    nPos := Ascan(aAux,{|x| x[2]+x[3] == TRB->GW1_REGCOM+TRB->GW1_CDDEST})
    
    If nPos > 0
        If Empty(aAux[nPos,05])
            aAux[nPos,05] := POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW3_EMISDF,"GU3_NMEMIT")
        EndIf 

        aAux[nPos,07] += TRB->FRETE 
        aAux[nPos,08] := aAux[nPos,07] / aAux[nPos,06]
        aAux[nPos,09] += TRB->GW3_FRPESO
    Else 
        // Aadd(aAux,{ TRB->GW1_DTEMIS,;
        //             TRB->GW1_REGCOM,;
        //             TRB->GW1_CDDEST,;
        //             POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW1_CDDEST,"GU3_NMEMIT"),;
        //             POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW3_EMISDF,"GU3_NMEMIT"),;
        //             0,;
        //             TRB->FRETE ,;
        //             0})
        Aadd(aAux,{ cvaltochar(MV_PAR09)+' a '+cvaltochar(MV_PAR10),;
                    TRB->GW1_REGCOM,;
                    TRB->GW1_CDDEST,;
                    POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW1_CDDEST,"GU3_NMEMIT"),;
                    POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW3_EMISDF,"GU3_NMEMIT"),;
                    0,;
                    TRB->FRETE ,;
                    0,;
                    TRB->GW3_FRPESO})
    EndIf 

    nPos := Ascan(aTotReg,{|x| x[1] == TRB->GW1_REGCOM} ) 

    If nPos == 0
        Aadd(aTotReg,{TRB->GW1_REGCOM,0,TRB->FRETE})
    Else 
        aTotReg[nPos,03] += TRB->FRETE
    EndIf

    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
oReport:SetMeter(TRB->(LastRec()))

dbSelectArea("TRB")               
Dbgotop()

oSection1:Init()

For nCont := 1 to len(aAux) 

    oSection1:Cell('Data'):SetValue(aAux[nCont,01])
    oSection1:Cell('Regional'):SetValue(aAux[nCont,02])
    oSection1:Cell('Código Cliente'):SetValue(aAux[nCont,03])
    oSection1:Cell('Nome Cliente'):SetValue(aAux[nCont,04])
    oSection1:Cell('Valor Faturamento Bruto'):SetValue(aAux[nCont,06])
    oSection1:Cell('Peso NF'):SetValue(aAux[nCont,09])
    oSection1:Cell('Nome Transporadora'):SetValue(aAux[nCont,05])
    oSection1:Cell('Valor Frete s/ Imposto'):SetValue(aAux[nCont,07])
    oSection1:Cell('% Frete s/ Imposto'):SetValue((aAux[nCont,08]*100))
    

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Cell('Data'):SetValue('')
oSection1:Cell('Regional'):SetValue('')
oSection1:Cell('Código Cliente'):SetValue('')
oSection1:Cell('Nome Cliente'):SetValue('')
oSection1:Cell('Valor Faturamento Bruto'):SetValue('')
oSection1:Cell('Peso NF'):SetValue('')
oSection1:Cell('Nome Transporadora'):SetValue('')
oSection1:Cell('Valor Frete s/ Imposto'):SetValue('')
oSection1:Cell('% Frete s/ Imposto'):SetValue('')
oSection1:PrintLine()
oSection1:PrintLine()
oSection1:PrintLine()
oSection1:PrintLine()
oSection1:PrintLine()

oSection1:Cell('Data'):SetValue('')
oSection1:Cell('Regional'):SetValue('Totais por Região')
oSection1:Cell('Código Cliente'):SetValue('')
oSection1:Cell('Nome Cliente'):SetValue('')
oSection1:Cell('Valor Faturamento Bruto'):SetValue('')
oSection1:Cell('Peso NF'):SetValue('')
oSection1:Cell('Nome Transporadora'):SetValue('')
oSection1:Cell('Valor Frete s/ Imposto'):SetValue('')
oSection1:Cell('% Frete s/ Imposto'):SetValue('')
oSection1:PrintLine()

For nCont := 1 to len(aTotReg)
    oSection1:Cell('Data'):SetValue('')
    oSection1:Cell('Regional'):SetValue(aTotReg[nCont,01])
    oSection1:Cell('Código Cliente'):SetValue('')
    oSection1:Cell('Nome Cliente'):SetValue('')
    oSection1:Cell('Valor Faturamento Bruto'):SetValue(aTotReg[nCont,02])
    oSection1:Cell('Peso NF'):SetValue('')
    oSection1:Cell('Nome Transporadora'):SetValue('')
    oSection1:Cell('Valor Frete s/ Imposto'):SetValue(aTotReg[nCont,03])
    oSection1:Cell('% Frete s/ Imposto'):SetValue((aTotReg[nCont,03] / aTotReg[nCont,02])*100)
    oSection1:PrintLine()
Next nCont 

oSection1:Finish()
oReport:EndPage() 

Return Nil


// SELECT GW1_REGCOM,GW1_CDDEST,SUM(GW8_VALOR) AS TOTAL   
// FROM GW1010 GW1   
// INNER JOIN GW8010 GW8 ON GW8_FILIAL = GW1_FILIAL AND GW1_CDTPDC=GW8_CDTPDC AND GW1_EMISDC=GW8_EMISDC AND GW1_SERDC=GW8_SERDC AND GW1_NRDC=GW8_NRDC AND GW8.D_E_L_E_T_=' '   
// WHERE GW1_FILIAL+GW1_NRDC+GW1_CDTPDC+GW1_SERDC+GW1_EMISDC IN 
//      (SELECT GW4_FILIAL+GW4_NRDC+GW4_TPDC+GW4_SERDC+GW4_EMISDC FROM GW4010 GW4   
//         INNER JOIN GW3010 GW3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_EMISDF = GW4_EMISDF AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND GW3_DTEMIS = GW4_DTEMIS AND GW3.D_E_L_E_T_=' '  
// WHERE GW4.D_E_L_E_T_=' ')   
// AND GW1_DTEMIS BETWEEN '20250101' AND '20250131' AND GW1_REGCOM<>' '  
// GROUP BY GW1_REGCOM,GW1_CDDEST  
// ORDER BY 1  
