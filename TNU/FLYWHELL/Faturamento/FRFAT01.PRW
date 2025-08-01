#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FRFAT01  � Autor � Alexandre Venancio  � Data �22/05/2025 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio da Receita Diferida x Reconhecimento da Receita  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Venancio     �Data  �20/09/2023 ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � Dados para exibi��o                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: nReg =                                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection1 
//Local oBreak
Local cTitle := "Relat�rio de Analise de Notas de Sa�da"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("FFATR01",.F.)

oReport := TReport():New("FFATR01",cTitle,If(lAuto,Nil,"FFATR01"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLANDscape() 

//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,"FLYWHEEL",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltANDo uma pagina em branco no inicio da impressao 

//Contrato	Pedido	Data Emiss�o	Cod.Cliente	Nome Cliente	Estado	Dt Prev Faturam. 	Valor ped.venda	Data RPS	Num.RPS	Produto	    Descr.Prod	Valor apropr.	Receita diferida	I S S	P I S	COFINS	Clientes a faturar	Receita faturada	    Contas a receber	Rec. Reconhecida	I S S	P I S	COFINS	 Varia��o Cambial 
//C6_XCTRSF	C6_NUM	C5_EMISSAO	    C6_CLI	    A1_NOME	        A1_EST	C6_ENTREG	        C6_VALOR	    C6_DATFAT	C6_NOTA	C6_PRODUTO	C6_DESCRI	C6_XVLRAPR	    C6_XVLRAPR	        F01	    F02	    F03	    C6_XVLRAPR	        D2_TOTAL	            D2_TOTAL	        C6_XVLRAPR	        F01	    F02	    F03	     F04

TRCell():New(oSection1,"Contrato","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_XCTRSF")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("C6_NUM")[1],/*lPixel*/)
TRCell():New(oSection1,"Data Emiss�o","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
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
TRCell():New(oSection1,"Varia��o Cambial","TRB",/*Titulo*/,/*Picture*/,TamSX3("D2_TOTAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
Local cQuery 	:= ""
Local aAux      :=  {}
Local nCont
//Local aTotReg   :=  {}

//               Par�metros			
// Cod	Pergunta		Conte�do
// P1	Pedido Venda De:		
// P2	Pedido Venda At�:		ZZZZ
// P3	Dt Emiss�o De:		1/5/2024
// P4	Dt Emiss�o At�:		31/12/2025
// P5	Cod Cliente De:		
// P6	Cod Cliente At�:		ZZZ
// P7	Data refer�ncia:		10/7/2024
// P8	C�mbio de refer�ncia: 		5,04

//Campos
//Contrato	Pedido	Data Emiss�o	Cod.Cliente	Nome Cliente	Estado	Dt Prev Faturam. 	Valor ped.venda| Data RPS	Num.RPS	Produto	    Descr.Prod	Valor apropr.	Receita diferida	I S S	P I S	COFINS	Clientes a faturar	Receita faturada	Contas a receber	Rec. Reconhecida	I S S	P I S	COFINS	 Varia��o Cambial 
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

    // Colunas  a preencher	Descri��o	Preencher com (*/**)	Regra para "Colunas a preencher"					Observa��o
    // ( * ) verificar necessidade de convers�o ( F ) e as regras antes do preenchimento da coluna:        1- cliente nacional preencher com C6_XVLRAPR ou D2_TOTAL de acordo com a coluna        2- cliente do exterior - converter o valor da apropria��o pelo c�mbio informado no par�metro do relat�rio ( C6_XVLRAPR * P8 ) se al�m disso o pedido for em d�lar (C5_MOEDA = 2)  ( ** ) a vari�vel C6_XVLRAPR deve ser considerada quando ela existir no item do pedido de venda porque ela � v�lida SOMENTE durante o per�odo da presta��o do servi�o								
    // N	Receita Diferida	M = C6_XVLRAPR	PV emitidos no intervalo de P3 a P4 com data emiss�o ( C ) > P7 e data RPS ( I ) = [vazio]					
    //     Se "N" for preenchido aplicar  f�rmula para preencher "O/P/Q" N�O preencher "P/Q" para cliente do exterior (coluna F = EX)
    // R	Cliente a Faturar	M = C6_XVLRAPR	PV emitidos no intervalo de P3 a P4 com data emiss�o ( C ) <= P7 e data RPS ( I ) = [vazio]					
    // S	Receita Faturada	D2_TOTAL	PV emitidos no intervalo de P3 a P4 com data RPS ( I ) <= P7 e com num.RPS ( J )					
    // T	Contas a Receber	D2_TOTAL	PV emitidos no intervalo de P3 a P4 com data RPS ( I ) <= P7 e com num.RPS ( J )					
    // U	Receita Reconhecida	M = C6_XVLRAPR	PV emitidos no intervalo de P3 a P4 com data RPS ( I ) <= P7 e SEM num.RPS ( J )					Se "N" for preenchido aplicar  f�rmula para preencher "O/P/Q" N�O preencher "P/Q" para cliente do exterior (coluna F = EX)

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
    // Varia��o Cambial	F04	Y = ( - S + U )

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
    oSection1:Cell("Data Emiss�o"):SetValue(aAux[nCont,03])
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
    oSection1:Cell("Varia��o Cambial"):SetValue(aAux[nCont,25])
    

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont



oSection1:Finish()
oReport:EndPage() 

Return Nil

