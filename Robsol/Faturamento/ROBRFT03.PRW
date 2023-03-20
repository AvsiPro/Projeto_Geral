#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ROBRFT03  ³ Autor ³ Alexandre Venancio  ³ Data ³30/05/2020 ³±±
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
User Function ROBRFT03

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
±±³Programa  ³ ReportDef³Autor  ³Alexandre Venancio     ³Data  ³30/05/2020 ±±
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
Local cTitle := "Relatório de Chamados"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("ROBRFT03",.F.)

oReport := TReport():New("ROBRFT03",cTitle,If(lAuto,Nil,"ROBRFT03"), {|oReport| ReportPrint(oReport)},"") 
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

TRCell():New(oSection1,"Codigo","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_CODIGO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Atendente","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_ATENDE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_PEDVEN")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Nota_Chamado","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_NOTA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Cliente"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_CODCLI")[1],/*lPixel*/)
TRCell():New(oSection1,"Razao","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/)
TRCell():New(oSection1,"Emissao"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_EMISSA")[1],/*lPixel*/)
TRCell():New(oSection1,"Item_Nota" 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_ITEM")[1],/*lPixel*/)
TRCell():New(oSection1,"Produto","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_PROD")[1],/*lPixel*/)
TRCell():New(oSection1,"Qtd","TRB",/*Titulo*/,'@E 999.99'/*Picture*/,TamSX3("Z50_QUANT")[1],/*lPixel*/)
TRCell():New(oSection1,"Preco","TRB",/*Titulo*/,'@E 99,999.99'/*Picture*/,TamSX3("Z50_PRECO")[1],/*lPixel*/)
TRCell():New(oSection1,"Obs_Chamado","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_OBS")[1],/*lPixel*/)
TRCell():New(oSection1,"Data_Criacao","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_DTCRIA")[1],/*lPixel*/)
TRCell():New(oSection1,"Hora_Criacao","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_HRCRIA")[1],/*lPixel*/)
TRCell():New(oSection1,"Status","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_STATUS")[1],/*lPixel*/)
TRCell():New(oSection1,"Opcao_Troca","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_OPCTRC")[1],/*lPixel*/)
TRCell():New(oSection1,"Defeito","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_DEFEIT")[1],/*lPixel*/)
TRCell():New(oSection1,"Tipo_Defeito","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_TPDEFE")[1],/*lPixel*/)
TRCell():New(oSection1,"Procede","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_PROCED")[1],/*lPixel*/)
TRCell():New(oSection1,"Obs_Atend","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_OBSATD")[1],/*lPixel*/)
TRCell():New(oSection1,"Titulo_Cobrar","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_NUM")[1],/*lPixel*/)
TRCell():New(oSection1,"Vencimento","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_VENCREA")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_VALOR")[1],/*lPixel*/)

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

cQuery := "SELECT ISNULL(CAST(CAST(Z50_OBSATD AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS_ATD,"
cQuery += " A1_NOME AS RAZAO,E1_NUM,E1_VENCREA,E1_VALOR,Z50_PROCED,*"
cQuery += " FROM "+RetSQLName("Z50")+" Z50"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=Z50_CODCLI AND A1_LOJA=Z50_LOJCLI AND A1.D_E_L_E_T_=' '" 
cQuery += " LEFT JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL='"+xFilial("SE1")+"' AND E1_NUM=Z50_NOTA AND E1_FILORIG=Z50_FILPED AND E1_PREFIXO='GAR' AND E1.D_E_L_E_T_=' '"
cQuery += " WHERE Z50.D_E_L_E_T_=' '
cQuery += " AND Z50_DTCRIA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
        Aadd(aAux,{ TRB->Z50_CODIGO,;
                    TRB->Z50_ATENDE,;
                    TRB->Z50_PEDVEN,;
                    TRB->Z50_NOTA,;
                    TRB->Z50_CODCLI,;
                    TRB->RAZAO,;
                    TRB->Z50_EMISSA,;
                    TRB->Z50_ITEM,;
                    TRB->Z50_PROD,;
                    TRB->Z50_QUANT,;
                    TRB->Z50_PRECO,;
                    TRB->Z50_OBS,;
                    TRB->Z50_DTCRIA,;
                    TRB->Z50_HRCRIA,;
                    TRB->Z50_STATUS,;
                    TRB->Z50_OPCTRC,;
                    TRB->Z50_DEFEIT,;
                    TRB->Z50_TPDEFE,;
                    TRB->Z50_PROCED,;
                    TRB->OBS_ATD,;
                    TRB->E1_NUM,;
                    TRB->E1_VENCREA,;
                    TRB->E1_VALOR})
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

For nCont := 1 to len(aAux) 

    oSection1:Cell('Codigo'):SetValue(aAux[nCont,01])
    oSection1:Cell('Atendente'):SetValue(aAux[nCont,02])
    oSection1:Cell('Pedido'):SetValue(aAux[nCont,03])
    oSection1:Cell('Nota_Chamado'):SetValue(aAux[nCont,04])
    oSection1:Cell('Cliente'):SetValue(aAux[nCont,05])
    oSection1:Cell('Razao'):SetValue(aAux[nCont,06])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,07]))
    oSection1:Cell('Item_Nota'):SetValue(aAux[nCont,08])
    oSection1:Cell('Produto'):SetValue(aAux[nCont,09])
    oSection1:Cell('Qtd'):SetValue(aAux[nCont,10])
    oSection1:Cell('Preco'):SetValue(aAux[nCont,11])
    oSection1:Cell('Obs_Chamado'):SetValue(aAux[nCont,12])
    oSection1:Cell('Data_Criacao'):SetValue(stod(aAux[nCont,13]))
    oSection1:Cell('Hora_Criacao'):SetValue(aAux[nCont,14])
    oSection1:Cell('Status'):SetValue(aAux[nCont,15])
    oSection1:Cell('Opcao_Troca'):SetValue(aAux[nCont,16])
    oSection1:Cell('Defeito'):SetValue(aAux[nCont,17])
    oSection1:Cell('Tipo_Defeito'):SetValue(aAux[nCont,18])
    oSection1:Cell('Procede'):SetValue(If(aAux[nCont,19]=="1","Sim","Nao"))
    oSection1:Cell('Obs_Atend'):SetValue(aAux[nCont,20])
    oSection1:Cell('Titulo_Cobrar'):SetValue(aAux[nCont,21])
    oSection1:Cell('Vencimento'):SetValue(cvaltochar(stod(aAux[nCont,22])))
    oSection1:Cell('Valor'):SetValue(aAux[nCont,23])
    
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	

Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
