#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ JFISR03  ³ Autor ³ Alexandre Venancio  ³ Data ³20/09/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Vendas						                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function JFISR03

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
±±³Programa  ³ ReportDef³Autor  ³Alexandre Venancio     ³Data  ³20/09/2023 ±±
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
Local cTitle := "Relatório de Analise de Notas de Saída"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("JFISR03",.F.)

oReport := TReport():New("JFISR03",cTitle,If(lAuto,Nil,"JFISR03"), {|oReport| ReportPrint(oReport)},"") 
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
oSection1:= TRSection():New(oReport,"JCA",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"Serie","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_SERIE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pulo","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_SERIE")[1],/*lPixel*/)
TRCell():New(oSection1,"Nota Fiscal","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_NFISCAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_EMISSAO")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"CNPJ Destino","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_CGC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Tipo Saída"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("X5_DESCRI")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Base"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_BASEICM")[1],/*lPixel*/)
TRCell():New(oSection1,"Aliq." 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_ALIQICM")[1],/*lPixel*/)
TRCell():New(oSection1,"ICMS","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_VALICM")[1],/*lPixel*/)
TRCell():New(oSection1,"CFOP","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_CFO")[1],/*lPixel*/)

TRCell():New(oSection1,"CST","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_CSTCOF")[1],/*lPixel*/)
TRCell():New(oSection1,"Chave de Acesso","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_CHVNFE")[1],/*lPixel*/)
TRCell():New(oSection1,"MOD","TRB",/*Titulo*/,/*Picture*/,3,/*lPixel*/)
TRCell():New(oSection1,"GLB","TRB",/*Titulo*/,/*Picture*/,1,/*lPixel*/)
TRCell():New(oSection1,"SEF","TRB",/*Titulo*/,/*Picture*/,1,/*lPixel*/)
TRCell():New(oSection1,"INT","TRB",/*Titulo*/,/*Picture*/,1,/*lPixel*/)
TRCell():New(oSection1,"ESF","TRB",/*Titulo*/,/*Picture*/,1,/*lPixel*/)

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

/*
cQuery := "SELECT F3_SERIE,F3_NFISCAL,F3_EMISSAO,F3_CFO,F3_CSTCOF,"
cQuery += " CASE WHEN FT_TIPOMOV='S' OR FT_TIPO IN('B','D') THEN A1_CGC ELSE A2_CGC END AS CNPJ,"
cQuery += " FT_TIPOMOV,F3_VALCONT,F3_ALIQICM,F3_BASEICM,F3_VALICM,F3_BASEIPI,F3_VALIPI,F3_ICMSRET,F3_DESPESA,"
cQuery += " F3_OBSERV,FT_FRETE,FT_SEGURO,FT_DESCONT,F3_CHVNFE"
cQuery += " FROM "+RetSQLName("SF3")+" F3"
cQuery += " INNER JOIN "+RetSQLName("SFT")+" FT ON FT_FILIAL=F3_FILIAL AND FT_SERIE=F3_SERIE AND FT_NFISCAL=F3_NFISCAL AND FT_CLIEFOR=FT_CLIEFOR AND FT_LOJA=F3_LOJA AND FT.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F3_CLIEFOR AND A1_LOJA=F3_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=F3_CLIEFOR AND A2_LOJA=F3_LOJA AND A2.D_E_L_E_T_=' '"
cQuery += " WHERE F3.D_E_L_E_T_=' '"
cQuery += " AND F3_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F3_ENTRADA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQuery += " ORDER BY F3_FILIAL,F3_NFISCAL,FT_ITEM"
*/
cQuery := "SELECT F2_SERIE AS SERIE,F2_DOC AS NOTA,F2_EMISSAO AS EMISSAO,D2_CF AS CFOP,D2_CLASFIS AS CST,A1_CGC AS CNPJ,'S - '+X5_DESCRI AS TIPOMOV,F2_VALBRUT AS VALOR,
cQuery += " D2_PICM AS ALIQUOTA,F2_BASEICM AS BASE,F2_VALICM AS VALICM,F2_CHVNFE AS CHAVE 
cQuery += " FROM "+RetSQLName("SF2")+" F2
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SX5")+" X5 ON X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='13' AND X5_CHAVE=D2_CF AND X5.D_E_L_E_T_=' '
cQuery += " WHERE F2.D_E_L_E_T_=' '
cQuery += " AND F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQuery += " UNION ALL
cQuery += " SELECT F1_SERIE AS SERIE,F1_DOC AS NOTA,F1_EMISSAO AS EMISSAO,D1_CF AS CFOP,D1_CLASFIS AS CST,A2_CGC AS CNPJ,'E - '+X5_DESCRI AS TIPOMOV,F1_VALBRUT AS VALOR,
cQuery += " D1_PICM AS ALIQUOTA,F1_BASEICM AS BASE,F1_VALICM AS VALICM,F1_CHVNFE AS CHAVE 
cQuery += " FROM "+RetSQLName("SF1")+" F1
cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND A2.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SX5")+" X5 ON X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='13' AND X5_CHAVE=D1_CF AND X5.D_E_L_E_T_=' '
cQuery += " WHERE F1.D_E_L_E_T_=' '
cQuery += " AND F1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
// SERIE,NOTA,EMISSAO,CFOP,CST,CNPJ,TIPOMOV,VALOR,ALIQUOTA,BASE,VALICM,CHAVE

    nPos := Ascan(aAux,{|x| x[1]+x[3]+x[11] == TRB->SERIE+TRB->NOTA+TRB->CFOP})
    If nPos == 0
   
        Aadd(aAux,{ TRB->SERIE,;
                    '',;
                    TRB->NOTA,;
                    TRB->EMISSAO,;
                    TRB->CNPJ,;
                    TRB->TIPOMOV,;
                    TRB->VALOR,;
                    TRB->BASE,;
                    TRB->ALIQUOTA,;
                    TRB->VALICM,;
                    TRB->CFOP,;
                    TRB->CST,;
                    TRB->CHAVE,;
                    '',;
                    '',;
                    '',;
                    '',;
                    ''})
    
    EndIf
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Serie'):SetValue(aAux[nCont,01])
    oSection1:Cell('Pulo'):SetValue(aAux[nCont,02])
    oSection1:Cell('Nota Fiscal'):SetValue(aAux[nCont,03])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,04]))
    oSection1:Cell('CNPJ Destino'):SetValue(aAux[nCont,05])
    oSection1:Cell('Tipo Saída'):SetValue(aAux[nCont,06])
    oSection1:Cell('Valor'):SetValue(aAux[nCont,07])
    oSection1:Cell('Base'):SetValue(aAux[nCont,08])
    oSection1:Cell('Aliq.'):SetValue(aAux[nCont,09])
    oSection1:Cell('ICMS'):SetValue(aAux[nCont,10])
    oSection1:Cell('CFOP'):SetValue(aAux[nCont,11])
    oSection1:Cell('CST'):SetValue(aAux[nCont,12])
    oSection1:Cell('Chave de Acesso'):SetValue(aAux[nCont,13])
    oSection1:Cell('MOD'):SetValue(aAux[nCont,14])
    oSection1:Cell('GLB'):SetValue(aAux[nCont,15])
    oSection1:Cell('SEF'):SetValue(aAux[nCont,16])
    oSection1:Cell('INT'):SetValue(aAux[nCont,17])
    oSection1:Cell('ESF'):SetValue(aAux[nCont,18])
    

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
