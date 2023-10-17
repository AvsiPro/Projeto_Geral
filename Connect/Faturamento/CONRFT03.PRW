#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONRFT03 ³ Autor ³ Alexandre Venancio      ³ Data ³28/07/23 ³±±
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
User Function CONRFT03

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
±±³Programa  ³ ReportDef³Autor  Alexandre Venancio     ³Data  ³28/07/23 ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Dados para exibição                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
Static Function ReportDef()
    Local oReport 
    Local oSection1 
    //Local oBreak
    Local cTitle := "Relatório de Vendas Diárias"

Pergunte("CONRFT03",.F.)

oReport := TReport():New("CONRFT03",cTitle,If(lAuto,Nil,"CONRFT03"), {|oReport| ReportPrint(oReport)},"") 
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
TRCell():New(oSection1,"Nota_Fiscal","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_DOC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Serie","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_SERIE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Codigo_Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_CLIENTE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Loja_Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_LOJA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Razao_Social","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CNPJ","TRB",/*Titulo*/,/*Picture*/"@R 99.999.999/9999-99",TamSX3("A1_CGC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Data_Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Tipo","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_TIPO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Produto","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_COD")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descricao","TRB",/*Titulo*/,/*Picture*/,TamSX3("B1_DESC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Quantidade","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_QUANT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor_Unitario","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_PRCVEN")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor_Total","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Armazem","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_LOCAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"CFOP","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_CF")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TES","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TES")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_PEDIDO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Item_NF","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_ITEM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor_Ipi","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_VALIPI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor_Icms","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_VALICM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor_ISS","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_VALISS")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descricao_CFOP","TRB",/*Titulo*/,/*Picture*/,TamSX3("F4_FINALID")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Despesas","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_DESPESA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Filial","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_FILIAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Periodo","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_PEDIDO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)


Static Function ReportPrint(oReport)
    Local oSection1 := oReport:Section(1) 
    Local cQuery 	:= ""
    Local aAux      :=  {}
    Local nCont

cQuery := "SELECT F2_CLIENTE,F2_LOJA,A1_NOME,A1_CGC,F2_EMISSAO,F2_TIPO,D2_COD,B1_DESC,"
cQuery += " D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_LOCAL,D2_CF,D2_TES,D2_PEDIDO,D2_ITEM,F2_DOC,F2_SERIE,"
cQuery += " D2_VALIPI,D2_VALICM,D2_VALISS,D2_DESPESA,F4_FINALID,F2_FILIAL,MONTH(D2_EMISSAO) AS MES"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL='"+xFilial("SF4")+"' AND F4_CODIGO=D2_TES AND F4_DUPLIC='S' AND F4.D_E_L_E_T_=' '"
cQuery += " WHERE F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"
cQuery += " AND F2.D_E_L_E_T_=' ' "

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")
						
While !EOF()
        Aadd(aAux,{ TRB->F2_DOC,;
                    TRB->F2_SERIE,;
                    TRB->F2_CLIENTE,;
                    TRB->F2_LOJA,;
                    TRB->A1_NOME,;
                    TRB->A1_CGC,;
                    TRB->F2_EMISSAO,;
                    TRB->F2_TIPO,;
                    TRB->D2_COD,;
                    TRB->B1_DESC,;
                    TRB->D2_QUANT,;
                    TRB->D2_PRCVEN,;
                    TRB->D2_TOTAL,;
                    TRB->D2_LOCAL,;
                    TRB->D2_CF,;
                    TRB->D2_TES,;
                    TRB->D2_PEDIDO,;
                    TRB->D2_ITEM,;
                    TRB->D2_VALIPI,;
                    TRB->D2_VALICM,;
                    TRB->D2_VALISS,;
                    TRB->F4_FINALID,;
                    TRB->D2_DESPESA,;
                    TRB->F2_FILIAL,;
                    TRB->MES})  
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

For nCont := 1 to len(aAux) 

    cDestino := ""

    oSection1:Cell('Nota_Fiscal'):SetValue(aAux[nCont,01])
    oSection1:Cell('Serie'):SetValue(aAux[nCont,02])
    oSection1:Cell('Codigo_Cliente'):SetValue(aAux[nCont,03])
    oSection1:Cell('Loja_Cliente'):SetValue(aAux[nCont,04])
    oSection1:Cell('Razao_Social'):SetValue(aAux[nCont,05])
    oSection1:Cell('CNPJ'):SetValue(aAux[nCont,06])
    oSection1:Cell('Data_Emissao'):SetValue(stod(aAux[nCont,07]))
    oSection1:Cell('Tipo'):SetValue(aAux[nCont,08])
    oSection1:Cell('Produto'):SetValue(aAux[nCont,09])
    oSection1:Cell('Descricao'):SetValue(aAux[nCont,10])
    oSection1:Cell('Quantidade'):SetValue(aAux[nCont,11])
    oSection1:Cell('Valor_Unitario'):SetValue(aAux[nCont,12])
    oSection1:Cell('Valor_Total'):SetValue(aAux[nCont,13])
    oSection1:Cell('Armazem'):SetValue(aAux[nCont,14])
    oSection1:Cell('CFOP'):SetValue(aAux[nCont,15])
    oSection1:Cell('TES'):SetValue(aAux[nCont,16])
    oSection1:Cell('Pedido'):SetValue(aAux[nCont,17])
    oSection1:Cell('Item_NF'):SetValue(aAux[nCont,18])
    oSection1:Cell('Valor_Ipi'):SetValue(aAux[nCont,19])
    oSection1:Cell('Valor_Icms'):SetValue(aAux[nCont,20])
    oSection1:Cell('Valor_ISS'):SetValue(aAux[nCont,21])
    oSection1:Cell('Descricao_CFOP'):SetValue(aAux[nCont,22])
    oSection1:Cell('Despesas'):SetValue(aAux[nCont,23])
    oSection1:Cell('Filial'):SetValue(aAux[nCont,24])
    oSection1:Cell('Periodo'):SetValue(aAux[nCont,25])


	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
