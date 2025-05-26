#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FRFAT01  ³ Autor ³ Alexandre Venancio  ³ Data ³22/05/2025 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório da Receita Diferida x Reconhecimento da Receita  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FRFAT01

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","01")
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

Pergunte("FFATR01",.F.)

oReport := TReport():New("FFATR01",cTitle,If(lAuto,Nil,"FFATR01"), {|oReport| ReportPrint(oReport)},"") 
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
oSection1:= TRSection():New(oReport,"FLYWHEEL",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltANDo uma pagina em branco no inicio da impressao 

//Contrato	Pedido	Data Emissão	Cod.Cliente	Nome Cliente	Estado	Dt Prev Faturam. 	Valor ped.venda	Data RPS	Num.RPS	Produto	    Descr.Prod	Valor apropr.	Receita diferida	I S S	P I S	COFINS	Clientes a faturar	Receita faturada	    Contas a receber	Rec. Reconhecida	I S S	P I S	COFINS	 Variação Cambial 
//C6_XCTRSF	C6_NUM	C5_EMISSAO	    C6_CLI	    A1_NOME	        A1_EST	C6_ENTREG	        C6_VALOR	    C6_DATFAT	C6_NOTA	C6_PRODUTO	C6_DESCRI	C6_XVLRAPR	    C6_XVLRAPR	        F01	    F02	    F03	    C6_XVLRAPR	        D2_TOTAL	            D2_TOTAL	        C6_XVLRAPR	        F01	    F02	    F03	     F04

TRCell():New(oSection1,"Contrato","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_XCTRSF")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_NUM")[1],/*lPixel*/)
TRCell():New(oSection1,"Data Emissão","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Cod.Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_CLI")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Nome Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Estado","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_EST")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Dt Prev Faturam.","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_ENTREG")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor ped.venda","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Data RPS","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_DATFAT")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Num.RPS","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_NOTA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Produto","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_PRODUTO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Descr.Prod","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_DESCRI")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor apropr.","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_XVLRAPR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Receita diferida","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_XVLRAPR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"I S S","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"P I S","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"COFINS","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Clientes a faturar","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_XVLRAPR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Receita faturada","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Contas a receber","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Rec. Reconhecida","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_XVLRAPR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"I S S","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"P I S","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"COFINS","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Variação Cambial","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

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
//Local aTotReg   :=  {}

//               Parâmetros			
// Cod	Pergunta		Conteúdo
// P1	Pedido Venda De:		
// P2	Pedido Venda Até:		ZZZZ
// P3	Dt Emissão De:		1/5/2024
// P4	Dt Emissão Até:		31/12/2025
// P5	Cod Cliente De:		
// P6	Cod Cliente Até:		ZZZ
// P7	Data referência:		10/7/2024
// P8	Câmbio de referência: 		5,04

//Campos
//Contrato	Pedido	Data Emissão	Cod.Cliente	Nome Cliente	Estado	Dt Prev Faturam. 	Valor ped.venda| Data RPS	Num.RPS	Produto	    Descr.Prod	Valor apropr.	Receita diferida	I S S	P I S	COFINS	Clientes a faturar	Receita faturada	Contas a receber	Rec. Reconhecida	I S S	P I S	COFINS	 Variação Cambial 
// ( A )	( B )	 ( C )	        ( D )	    ( E )	        ( F )	( G )	            ( H )	         ( I ) 	    ( J )	( K )	    ( L )	    ( M )	        ( N )	            (O)	    (P)	    (Q)	    ( R )	            ( S )	            ( T )	            ( U )	            ( V )	( W )	( X )	    ( Y )
//C6_XCTRSF	C6_NUM	C5_EMISSAO	    C6_CLI	    A1_NOME	        A1_EST	C6_ENTREG	        C6_VALOR	     C6_DATFAT	C6_NOTA	C6_PRODUTO	C6_DESCRI   C6_XVLRAPR	    C6_XVLRAPR	        F01	    F02	    F03	    C6_XVLRAPR	        D2_TOTAL	        D2_TOTAL	        C6_XVLRAPR	        F01	    F02	    F03	        F04

cQuery := " SELECT C6_XCTRSF,C6_NUM,C5_EMISSAO,C6_CLI,A1_NOME,A1_EST,C6_ENTREG,C6_VALOR,C6_DATFAT,C6_NOTA,C6_PRODUTO,C6_DESCRI,B1_ALIQISS,B1_TPREG,C6_ITEM,C6_FILIAL " 
cQuery += " FROM " + RetSQLName("SC5") + " SC5 " 
cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND SA1.D_E_L_E_T_=' '  " 
cQuery += " INNER JOIN " + RetSQLName("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL AND C6_NUM=C5_NUM AND C5_CLIENTE=C6_CLI AND C6_LOJA=C5_LOJACLI AND SC6.D_E_L_E_T_=' '  " 
cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND SB1.D_E_L_E_T_=' '"
cQuery += " WHERE SC5.D_E_L_E_T_=' ' " 
cQuery += " AND C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"
cQuery += " AND C5_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"

//cQuery += " AND C5_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()

    // Colunas  a preencher	Descrição	Preencher com (*/**)	Regra para "Colunas a preencher"					Observação
    // ( * ) verificar necessidade de conversão ( F ) e as regras antes do preenchimento da coluna:        1- cliente nacional preencher com C6_XVLRAPR ou D2_TOTAL de acordo com a coluna        2- cliente do exterior - converter o valor da apropriação pelo câmbio informado no parâmetro do relatório ( C6_XVLRAPR * P8 ) se além disso o pedido for em dólar (C5_MOEDA = 2)  ( ** ) a variável C6_XVLRAPR deve ser considerada quando ela existir no item do pedido de venda porque ela é válida SOMENTE durante o período da prestação do serviço								
    // N	Receita Diferida	M = C6_XVLRAPR	PV emitidos no intervalo de P3 a P4 com data emissão ( C ) > P7 e data RPS ( I ) = [vazio]					
    //     Se "N" for preenchido aplicar  fórmula para preencher "O/P/Q" NÃO preencher "P/Q" para cliente do exterior (coluna F = EX)
    // R	Cliente a Faturar	M = C6_XVLRAPR	PV emitidos no intervalo de P3 a P4 com data emissão ( C ) <= P7 e data RPS ( I ) = [vazio]					
    // S	Receita Faturada	D2_TOTAL	PV emitidos no intervalo de P3 a P4 com data RPS ( I ) <= P7 e com num.RPS ( J )					
    // T	Contas a Receber	D2_TOTAL	PV emitidos no intervalo de P3 a P4 com data RPS ( I ) <= P7 e com num.RPS ( J )					
    // U	Receita Reconhecida	M = C6_XVLRAPR	PV emitidos no intervalo de P3 a P4 com data RPS ( I ) <= P7 e SEM num.RPS ( J )					Se "N" for preenchido aplicar  fórmula para preencher "O/P/Q" NÃO preencher "P/Q" para cliente do exterior (coluna F = EX)

    //N 
    NRECDIF := 0
    If STOD(TRB->C5_EMISSAO) >= MV_PAR03 .AND. STOD(TRB->C5_EMISSAO) <= MV_PAR04 .AND. STOD(TRB->C5_EMISSAO) > MV_PAR07 .AND. Empty(TRB->C6_DATFAT)
        NRECDIF := TRB->C6_XVLRAPR
    EndIF 
    //R
    NCLIFAT := 0
    If STOD(TRB->C5_EMISSAO) >= MV_PAR03 .AND. STOD(TRB->C5_EMISSAO) <= MV_PAR04 .AND. STOD(TRB->C5_EMISSAO) <= MV_PAR07 .AND. !Empty(TRB->C6_DATFAT)
        NCLIFAT := TRB->C6_XVLRAPR
    EndIF 
    //S e T
    NRECFAT := 0
    If STOD(TRB->C5_EMISSAO) >= MV_PAR03 .AND. STOD(TRB->C5_EMISSAO) <= MV_PAR04 .AND. STOD(TRB->C6_DATFAT) <= MV_PAR07 .AND. !Empty(TRB->C6_NOTA)
        NRECFAT := POSICIONE("SD2",8,TRB->C6_FILIAL+TRB->C6_NUM+TRB->C6_ITEM,"D2_TOTAL")
    EndIF 
    //U
    NRECREC := 0
    If STOD(TRB->C5_EMISSAO) >= MV_PAR03 .AND. STOD(TRB->C5_EMISSAO) <= MV_PAR04 .AND. STOD(TRB->C6_DATFAT) <= MV_PAR07 .AND. Empty(TRB->C6_NOTA)
        NRECREC := POSICIONE("SD2",8,TRB->C6_FILIAL+TRB->C6_NUM+TRB->C6_ITEM,"D2_TOTAL")
    EndIF 
    
    
    // ISS	F01	C6_XVLRAPR * B1_ALIQISS
    // PIS	F02	IIF(!TRIM(SC6->C6_PRODUTO)$"90", IIF(!SB1->B1_TPREG $"1",(SC6->C6_XVLRAPR*0.0065),(SC6->C6_XVLRAPR*0.0165)), 0)
    // COFINS	F03	IIF(!TRIM(SC6->C6_PRODUTO)$"90", IIF(!SB1->B1_TPREG $"1",(SC6->C6_XVLRAPR*0.0300),(SC6->C6_XVLRAPR*0.0760)), 0)
    // Variação Cambial	F04	Y = ( - S + U )

    F01 := TRB->C6_XVLRAPR * TRB->B1_ALIQISS
    F02	:= IIF(!TRIM(TRB->C6_PRODUTO)$"90", IIF(!TRB->B1_TPREG $"1",(TRB->C6_XVLRAPR*0.0065),(TRB->C6_XVLRAPR*0.0165)), 0)
    F03	:= IIF(!TRIM(TRB->C6_PRODUTO)$"90", IIF(!TRB->B1_TPREG $"1",(TRB->C6_XVLRAPR*0.0300),(TRB->C6_XVLRAPR*0.0760)), 0)
    F04 := -TRB->D2_TOTAL + TRB->C6_XVLRAPR
    //C6_XCTRSF	C6_NUM	C5_EMISSAO	C6_CLI	A1_NOME	A1_EST	C6_ENTREG	C6_VALOR	C6_DATFAT	C6_NOTA	C6_PRODUTO	C6_DESCRI	
    //C6_XVLRAPR	C6_XVLRAPR	F01	F02	F03	C6_XVLRAPR	D2_TOTAL	D2_TOTAL	C6_XVLRAPR	F01	F02	F03	F04

    Aadd(aAux,{ TRB->C6_XCTRSF,;
                TRB->C6_NUM,;
                TRB->C5_EMISSAO,;
                TRB->C6_CLI,;
                TRB->A1_NOME,;
                TRB->A1_EST,;
                TRB->C6_ENTREG,;
                TRB->C6_VALOR,;
                TRB->C6_DATFAT,;
                TRB->C6_NOTA,;
                TRB->C6_PRODUTO,;
                TRB->C6_DESCRI,;
                C6_XVLRAPR,;
                NRECDIF,;
                F01,;
                F02,;
                F03,;
                NCLIFAT,;
                NRECFAT,;
                NRECFAT,;
                NRECREC,;
                F01,;
                F02,;
                F03,;
                F04})

    Dbskip()
ENDDO


oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
oReport:SetMeter(TRB->(LastRec()))

dbSelectArea("TRB")               
Dbgotop()

oSection1:Init()

For nCont := 1 to len(aAux) 

    oSection1:Cell("Contrato"):SetValue(aAux[nCont,01])
    oSection1:Cell("Pedido"):SetValue(aAux[nCont,02])
    oSection1:Cell("Data Emissão"):SetValue(aAux[nCont,03])
    oSection1:Cell("Cod.Cliente"):SetValue(aAux[nCont,04])
    oSection1:Cell("Nome Cliente"):SetValue(aAux[nCont,05])
    oSection1:Cell("Estado"):SetValue(aAux[nCont,06])
    oSection1:Cell("Dt Prev Faturam."):SetValue(aAux[nCont,07])
    oSection1:Cell("Valor ped.venda"):SetValue(aAux[nCont,08])
    oSection1:Cell("Data RPS"):SetValue(aAux[nCont,09])
    oSection1:Cell("Num.RPS"):SetValue(aAux[nCont,10])
    oSection1:Cell("Produto"):SetValue(aAux[nCont,11])
    oSection1:Cell("Descr.Prod"):SetValue(aAux[nCont,12])
    oSection1:Cell("Valor apropr."):SetValue(aAux[nCont,13])
    oSection1:Cell("Receita diferida"):SetValue(aAux[nCont,14])
    oSection1:Cell("I S S"):SetValue(aAux[nCont,15])
    oSection1:Cell("P I S"):SetValue(aAux[nCont,16])
    oSection1:Cell("COFINS"):SetValue(aAux[nCont,17])
    oSection1:Cell("Clientes a faturar"):SetValue(aAux[nCont,18])
    oSection1:Cell("Receita faturada"):SetValue(aAux[nCont,19])
    oSection1:Cell("Contas a receber"):SetValue(aAux[nCont,20])
    oSection1:Cell("Rec. Reconhecida"):SetValue(aAux[nCont,21])
    oSection1:Cell("I S S"):SetValue(aAux[nCont,22])
    oSection1:Cell("P I S"):SetValue(aAux[nCont,23])
    oSection1:Cell("COFINS"):SetValue(aAux[nCont,24])
    oSection1:Cell("Variação Cambial"):SetValue(aAux[nCont,25])
    

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont



oSection1:Finish()
oReport:EndPage() 

Return Nil

