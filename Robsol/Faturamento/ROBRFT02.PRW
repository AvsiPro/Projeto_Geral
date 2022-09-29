#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ROBRFT02  ³ Autor ³ Alexandre Venancio  ³ Data ³30/05/2020 ³±±
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
User Function ROBRFT02

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
Local cTitle := "Relatório de Notas"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("ROBRFT02",.F.)

oReport := TReport():New("ROBRFT02",cTitle,If(lAuto,Nil,"ROBRFT02"), {|oReport| ReportPrint(oReport)},"") 
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

TRCell():New(oSection1,"Filial","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_FILIAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_ENTRADA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TipoMov","TRB",/*Titulo*/,/*Picture*/,TamSX3("FT_TIPOMOV")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"CFOP","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_CFO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Natureza"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_TIPO")[1],/*lPixel*/)
TRCell():New(oSection1,"NotaFiscal","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_NFISCAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Cod_CliFor"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_CLIEFOR")[1],/*lPixel*/)
TRCell():New(oSection1,"Nome" 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/)
TRCell():New(oSection1,"Estado","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_ESTADO")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Total","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)

TRCell():New(oSection1,"Base_Icms","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Icms","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Base_IPI","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_IPI","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_ST","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Despesa","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Frete","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Seguro","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor_Desconto","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F3_VALCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Observacao","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_OBSERV")[1],/*lPixel*/)
TRCell():New(oSection1,"Chave_NFe","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_CHVNFE")[1],/*lPixel*/)

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

cQuery := "SELECT F3_FILIAL,FT_TIPOMOV,FT_ITEM,FT_PRODUTO,F3_ENTRADA,FT_TIPOMOV,"
cQuery += " F3_ALIQICM,F3_CFO,F3_TIPO,F3_NFISCAL,F3_CLIEFOR,F3_LOJA,"
cQuery += " CASE WHEN FT_TIPOMOV='S' OR FT_TIPO IN('B','D') THEN A1_NOME ELSE A2_NOME END AS NOME,F3_ESTADO,"
cQuery += " F3_VALCONT,F3_BASEICM,F3_VALICM,F3_BASEIPI,F3_VALIPI,F3_ICMSRET,F3_DESPESA,"
cQuery += " F3_OBSERV,FT_FRETE,FT_SEGURO,FT_DESCONT,F3_CHVNFE"
cQuery += " FROM "+RetSQLName("SF3")+" F3"
cQuery += " INNER JOIN "+RetSQLName("SFT")+" FT ON FT_FILIAL=F3_FILIAL AND FT_SERIE=F3_SERIE AND FT_NFISCAL=F3_NFISCAL AND FT_CLIEFOR=FT_CLIEFOR AND FT_LOJA=F3_LOJA AND FT.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F3_CLIEFOR AND A1_LOJA=F3_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=F3_CLIEFOR AND A2_LOJA=F3_LOJA AND A2.D_E_L_E_T_=' '"
cQuery += " WHERE F3.D_E_L_E_T_=' '"
cQuery += " AND F3_ENTRADA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuery += " ORDER BY F3_FILIAL,F3_NFISCAL,FT_ITEM"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    nPos := Ascan(aAux,{|x| x[6]+x[4]+cvaltochar(x[22]) == TRB->F3_NFISCAL+TRB->F3_CFO+cvaltochar(TRB->F3_ALIQICM)})
    If nPos == 0
        Aadd(aAux,{TRB->F3_FILIAL,TRB->F3_ENTRADA,TRB->FT_TIPOMOV,TRB->F3_CFO,;
                    Posicione("SX5",1,xFilial("SX5")+"13"+TRB->F3_CFO,"X5_DESCRI"),;
                    TRB->F3_NFISCAL,TRB->F3_CLIEFOR,TRB->NOME,TRB->F3_ESTADO,;
                    TRB->F3_VALCONT,TRB->F3_BASEICM,TRB->F3_VALICM,TRB->F3_BASEIPI,;
                    TRB->F3_VALIPI,TRB->F3_ICMSRET,TRB->F3_DESPESA,TRB->FT_FRETE,;
                    TRB->FT_SEGURO,TRB->FT_DESCONT,TRB->F3_OBSERV,TRB->F3_CHVNFE,;
                    TRB->F3_ALIQICM})
    /*
    else
        aAux[nPos,12] += TRB->F3_VALICM
        aAux[nPos,14] += TRB->F3_VALIPI
        aAux[nPos,15] += TRB->F3_ICMSRET
        aAux[nPos,16] += TRB->F3_DESPESA
        aAux[nPos,17] += TRB->FT_FRETE
        aAux[nPos,18] += TRB->FT_SEGURO
        aAux[nPos,19] += TRB->FT_DESCONT*/     
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

    oSection1:Cell('Filial'):SetValue(aAux[nCont,01])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,02]))
    oSection1:Cell('TipoMov'):SetValue(aAux[nCont,03])
    oSection1:Cell('CFOP'):SetValue(aAux[nCont,04])
    oSection1:Cell('Natureza'):SetValue(aAux[nCont,05])
    oSection1:Cell('NotaFiscal'):SetValue(aAux[nCont,06])
    oSection1:Cell('Cod_CliFor'):SetValue(aAux[nCont,07])
    oSection1:Cell('Nome'):SetValue(aAux[nCont,08])
    oSection1:Cell('Estado'):SetValue(aAux[nCont,09])
    oSection1:Cell('Valor_Total'):SetValue(aAux[nCont,10])
    oSection1:Cell('Base_Icms'):SetValue(aAux[nCont,11])
    oSection1:Cell('Valor_Icms'):SetValue(aAux[nCont,12])
    oSection1:Cell('Base_IPI'):SetValue(aAux[nCont,13])
    oSection1:Cell('Valor_IPI'):SetValue(aAux[nCont,14])
    oSection1:Cell('Valor_ST'):SetValue(aAux[nCont,15])
    oSection1:Cell('Valor_Despesa'):SetValue(aAux[nCont,16])
    oSection1:Cell('Valor_Frete'):SetValue(aAux[nCont,17])
    oSection1:Cell('Valor_Seguro'):SetValue(aAux[nCont,18])
    oSection1:Cell('Valor_Desconto'):SetValue(aAux[nCont,19])
    oSection1:Cell('Observacao'):SetValue(aAux[nCont,20])
    oSection1:Cell('Chave_NFe'):SetValue(aAux[nCont,21])


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
