#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RRESTR2  ³ Autor ³ Alexandre Venancio  ³ Data ³30/05/2020 ³±±
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
User Function RRESTR2

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

Local cTitle := "Relatório de Movimentação de Estoques"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01    Data De                                          ³
//³ mv_par02    Data Ate                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("RRESTR2",.F.)

oReport := TReport():New("RRESTR2",cTitle,If(lAuto,Nil,"RRESTR2"), {|oReport| ReportPrint(oReport)},"") 
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

oSection0:= TRSection():New(oReport,"",{"TRB"},/*aOrdem*/)
oSection0:SetHeaderPage()


TRCell():New(oSection0,"Produto","TRB",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection0,"Descricao","TRB",/*Titulo*/,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:= TRSection():New(oReport,"",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"Data","TRB",/*Titulo*/,/*Picture*/,8,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pedido","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"N.F.","TRB",/*Titulo*/,/*Picture*/,11,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Tipo","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Status"   ,"TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/)
TRCell():New(oSection1,"Vendedor","TRB",/*Titulo*/,/*Picture*/,35,/*lPixel*/)
TRCell():New(oSection1,"Cod_Clifor"	,"TRB",/*Titulo*/,/*Picture*/,6,/*lPixel*/)
TRCell():New(oSection1,"Razao"	,"TRB",/*Titulo*/,/*Picture*/,35,/*lPixel*/)
TRCell():New(oSection1,"Entrada","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Saida","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)
TRCell():New(oSection1,"Saldo","TRB",/*Titulo*/,/*Picture*/,18,/*lPixel*/)

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

Local oSection1 := oReport:Section(2)
Local cQuery 	:= ""
Local aAux      :=  {}
Local nCont
Local nSldFim   :=  0

/*
MV_PAR01 := '299'
MV_PAR02 := '299'
MV_PAR03 := CTOD('01/05/2022')
MV_PAR04 := CTOD('31/05/2022')
MV_PAR05 := ' '
MV_PAR06 := 'ZZ'
*/
cQuery := "SELECT DISTINCT SDB.DB_FILIAL,SDB.DB_PRODUTO,SDB.DB_ORIGEM,SDB.DB_LOCAL,SDB.DB_LOCALIZ,"
cQuery += "SDB.DB_NUMSERI,SDB.DB_LOTECTL,SDB.DB_NUMLOTE,SDB.DB_DATA,SDB.DB_NUMSEQ,SDB.DB_IDOPERA,"
cQuery += "SDB.DB_DOC,SDB.DB_SERIE,SDB.DB_TM,SDB.DB_QUANT,SDB.DB_ESTORNO, SB1.B1_COD, SB1.B1_DESC,"
cQuery += " SB2.B2_LOCAL,SDB.DB_CLIFOR,SDB.DB_LOJA,SDB.DB_TIPO"				
cQuery += "				FROM "+RetSQLName("SB2")+" SB2"
cQuery += "					INNER JOIN "+RetSQLName("SB1")+" SB1"
cQuery += "  ON ( SB1.B1_FILIAL =  '"+xFilial("SB1")+"'  AND SB2.B2_FILIAL =  '"+xFilial("SB2")+"' AND SB1.B1_COD = SB2.B2_COD )"
cQuery += "					LEFT OUTER JOIN "+RetSQLName("SBZ")+" SBZ ON ( SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"'  AND SB1.B1_FILIAL =  '"+xFilial("SB1")+"'   AND SBZ.BZ_COD = SB1.B1_COD AND SBZ.D_E_L_E_T_=' ')	
cQuery += "					LEFT JOIN "+RetSQLName("SDB")+" SDB ON
cQuery += "						(SDB.DB_FILIAL = '"+xFilial("SDB")+"' AND SB2.B2_FILIAL =  '"+xFilial("SB2")+"' AND "
cQuery += "						SDB.DB_PRODUTO = SB2.B2_COD AND "
cQuery += "						SDB.DB_LOCAL = SB2.B2_LOCAL AND "
cQuery += "						SDB.DB_LOCAL >= ' ' AND "
cQuery += "						SDB.DB_LOCAL <= 'ZZ' AND "
cQuery += "						SDB.DB_DATA >= '"+DTOS(MV_PAR03)+"' AND "
cQuery += "						SDB.DB_DATA <= '"+DTOS(MV_PAR04)+"' AND " 
cQuery += "						SDB.D_E_L_E_T_= ' ' )		
cQuery += "				WHERE ( CASE WHEN( SBZ.BZ_LOCALIZ IS NOT NULL ) THEN( SBZ.BZ_LOCALIZ ) ELSE( SB1.B1_LOCALIZ ) END ) = 'S'
cQuery += "						AND SB2.B2_LOCAL >= '"+MV_PAR05+"'  AND SB2.B2_LOCAL <= '"+MV_PAR06+"'"
cQuery += "						AND SB1.D_E_L_E_T_=' '" 
cQuery += "						AND SB2.D_E_L_E_T_=' ' AND SDB.DB_ESTORNO<>'S'" 
cQuery += "               AND SDB.DB_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += "				ORDER BY SB1.B1_COD,SDB.DB_DATA,SDB.DB_IDOPERA" //

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")



cCodPrB := ''
//oSection1:SetParentQuery()
nSaldo := 0

While !EOF()
    
    If Empty(cCodPrB) .Or. cCodPrB <> TRB->DB_PRODUTO
        nSaldoIni:=nEntrada:=nSaida:=0                                         
			
        If !Empty(TRB->DB_LOCAL) // Se DB_LOCAL vazio nao houve movimentacao no armazem
            nSaldoIni := CalcEstL(TRB->B1_COD,TRB->DB_LOCAL,mv_par03,TRB->DB_LOTECTL,TRB->DB_NUMLOTE,TRB->DB_LOCALIZ,TRB->DB_NUMSERI)[1]
        Else
            nSaldoIni := CalcEst(TRB->B1_COD,TRB->B2_LOCAL,mv_par03,,,)[1]
        EndIf                                      

        nSaldo := nSaldoIni

        Aadd(aAux,{TRB->DB_PRODUTO,;
                TRB->B1_DESC,;
                cvaltochar(mv_par03-1),;
                '',;
                '',;
                '',;
                '',;
                '',;
                'Saldo Inicial',;
                '',;
                0,;
                0,;
                nSaldoIni,;
                '1'})

        cCodPrB := TRB->DB_PRODUTO
    Endif 

    cDocPed := ''
    cDocNot := ''
    cStatus := ''
    cCodCli := ''
    cNomCli := ''
    cCodVnd := ''
    cSituac := ''
    nQtdEnt := 0
    nQtdSai := 0

    If TRB->DB_ORIGEM == "SD1" 
        cDocNot := TRB->DB_DOC
        cStatus := 'Compra'
        cSituac := 'Compra'
        cCodCli := TRB->DB_CLIFOR 
        cNomCli := Posicione("SA2",1,xFilial("SA2")+cCodCli,"A2_NOME")

    ElseIf !Empty(TRB->DB_SERIE)
        cDocNot := TRB->DB_DOC
        cStatus := 'Venda'
        cSituac := 'Faturado'
        aAuxNf := BuscNf(cDocNot,TRB->DB_SERIE)

        If len(aAuxNf) < 1
            Dbskip()
            loop
        Else 
            //    Aadd(aRet,{TRB->RCDL,TRB->D2_PEDIDO,TRB->F2_CLIENTE,TRB->A1_NOME,TRB->A3_NOME})
            If aAuxNf[1,1] > 0
                Dbskip()
                loop
            Else
                cCodCli :=  aAuxNf[1,3] //Posicione("SF2",1,xFilial("SF2")+cDocNot+TRB->DB_SERIE,"F2_CLIENTE")
                cNomCli :=  Alltrim(aAuxNf[1,4]) //Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME")
                cCodVnd :=  Alltrim(aAuxNf[1,5]) //Posicione("SA3",1,xFilial("SA3")+Posicione("SF2",1,xFilial("SF2")+TRB->DB_DOC+TRB->DB_SERIE,"F2_VEND1"),"A3_NOME")
                cDocPed :=  aAuxNf[1,2] //Posicione("SD2",3,xFilial("SD2")+cDocNot+TRB->DB_SERIE,"D2_PEDIDO")
            EndIf 
        EndIF     
    ElseIf TRB->DB_ORIGEM == "SC6" .And. Empty(TRB->DB_SERIE)
        cDocPed := TRB->DB_DOC
        cStatus := 'Venda'
        cCodCli := Posicione("SC5",1,xFilial("SC5")+cDocPed,"C5_CLIENTE")
        cCodVnd := Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,xFilial("SC5")+cDocPed,"C5_VEND1"),"A3_NOME")
        cNomCli := Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME")
        cSituac := Posicione("SC5",1,xFilial("SC5")+cDocPed,"C5_NOTA")

        If !Empty(cSituac)
            cSituac := 'Empenhado'
        Else
            cSituac := 'Faturado'
        EndIF 
    ElseIf TRB->DB_ORIGEM == "SD3" .And. Empty(TRB->DB_SERIE) 
        If Len(Alltrim(TRB->DB_DOC)) == 6
            cDocPed := TRB->DB_DOC
            cCodCli := Posicione("SC5",1,xFilial("SC5")+cDocPed,"C5_CLIENTE")
            cCodVnd := Posicione("SA3",1,xFilial("SA3")+Posicione("SC5",1,xFilial("SC5")+cDocPed,"C5_VEND1"),"A3_NOME")
        Else
            cDocNot := TRB->DB_DOC
            cCodCli := Posicione("SF2",1,xFilial("SF2")+cDocNot+TRB->DB_SERIE,"F2_CLIENTE")
            cDocPed := Posicione("SD2",3,xFilial("SD2")+cDocNot+TRB->DB_SERIE,"D2_PEDIDO")
        EndIf 
        
        cNomCli := Posicione("SA1",1,xFilial("SA1")+cCodCli,"A1_NOME")
        cSituac := Posicione("SC5",1,xFilial("SC5")+cDocPed,"C5_NOTA")

        If !Empty(cSituac)
            If Val(TRB->DB_TM) < 500
                cSituac := 'Estorno'
            else
                cSituac := 'Empenhado'
            EndIf 
        ElseIf Alltrim(cDocPed) == "INVENT"
            cSituac := 'Inventario'
            cNomCli := 'Movimento de Inventario do produto'
        Else
            cSituac := 'Faturado'
        EndIF

        If TRB->DB_TIPO <> 'D'
            If Empty(cDocPed)
                cStatus := 'Transferencia'
                cSituac := 'Mov. Interno'
                cNomCli := 'Movimentação de transferencia interna'
            eLSE
                cStatus := 'Venda'
            EndIf
        
        else
            cStatus := 'Devolucao'
            cSituac := 'Mov. Interno'
            cNomCli := 'Movimentação de Estoque interna'
        EndIf 

         
    EndIf 

    If Val(TRB->DB_TM) < 500
        nQtdEnt := TRB->DB_QUANT
    else
        nQtdSai := TRB->DB_QUANT
    EndIf 

    nSaldo := nSaldo + nQtdEnt - nQtdSai 

    Aadd(aAux,{TRB->DB_PRODUTO,;
                TRB->B1_DESC,;
                cvaltochar(STOD(TRB->DB_DATA)),;
                cDocPed,;
                cDocNot,;
                If(val(TRB->DB_TM) < 500,'Entrada','Venda'),;
                If(val(TRB->DB_TM) < 500 .AND. UPPER(cSituac)=='FATURADO','Entrada',cSituac),;
                cCodVnd,;
                cCodCli,;
                cNomCli,;
                nQtdEnt,;
                nQtdSai,;
                nSaldo,;
                '2'})
    Dbskip()
ENDDO

cQuery := "SELECT C6_PRODUTO,C6_DESCRI,C5_EMISSAO,C6_NUM,'' AS NOTA,'Venda' as Tipo,"
cQuery += "'Empenhado' AS SITUACAO,A3_NOME,C6_CLI,A1_NOME,0 AS Entrada,C6_QTDVEN,0 AS SALDO"
cQuery += " FROM "+RetSQLName("SC6")+" C6"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
cQuery += " AND C6_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND C6_NOTA=' '"
cQuery += " AND C6_RESERVA<>' ' AND C6.D_E_L_E_T_=' '"
cQuery += " ORDER BY C6_PRODUTO,C5_EMISSAO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    If Ascan(aAux,{|x| X[1]+X[4] == TRB->C6_PRODUTO+TRB->C6_NUM}) == 0
        Aadd(aAux,{TRB->C6_PRODUTO,;
                    TRB->C6_DESCRI,;
                    cvaltochar(STOD(TRB->C5_EMISSAO)),;
                    TRB->C6_NUM,;
                    TRB->NOTA,;
                    TRB->Tipo,;
                    TRB->SITUACAO,;
                    Alltrim(TRB->A3_NOME),;
                    TRB->C6_CLI,;
                    Alltrim(TRB->A1_NOME),;
                    TRB->Entrada,;
                    TRB->C6_QTDVEN,;
                    TRB->SALDO,;
                    '3'})
    EndIf
         
    Dbskip()
ENDDO


If len(aAux) > 0
    cCodPrd := aAux[1,1]
    nSldAtu := aAux[1,13]
    For nCont := 1 to len(aAux)
        If cCodPrd <> aAux[nCont,1]
            cCodPrd := aAux[nCont,1]
            nSldAtu := aAux[nCont,13]
        else
            aAux[nCont,13] := nSldAtu + aAux[nCont,11] - aAux[nCont,12]
            nSldAtu := aAux[nCont,13]
        EndIf 
    Next nCont
EndIf 

aSort(aAux,,,{|x,y| x[1]+dtos(ctod(x[3]))+x[14] < y[1]+dtos(ctod(y[3]))+y[14]})

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


cCodPrB := ''
nSldFim := 0

For nCont := 1 to len(aAux) 
    If Empty(cCodPrB) .Or. aAux[nCont,01] <> cCodPrB
        If !Empty(cCodPrB)
            oSection1:Cell('Data'):SetValue("")
            oSection1:Cell('Pedido'):SetValue("")
            oSection1:Cell('N.F.'):SetValue("")
            oSection1:Cell('Tipo'):SetValue("")
            oSection1:Cell('Status'):SetValue("")
            oSection1:Cell('Vendedor'):SetValue("Saldo Final")
            oSection1:Cell('Cod_Clifor'):SetValue("")
            oSection1:Cell('Razao'):SetValue("")
            
            oSection1:Cell('Entrada'):HIDE()
            oSection1:Cell('Saida'):HIDE()
            //oSection1:Cell('Entrada'):SetValue(0)
            //oSection1:Cell('Saida'):SetValue(0)
            oSection1:Cell('Saldo'):SetValue(Transform(nSldFim,"@E 999,999,999.99"))
            oReport:ThinLine()
            oSection1:PrintLine()
        ENDIF

        cCodPrB := aAux[nCont,01]
        
        oSection1:Cell('Data'):SetValue("")
        oSection1:Cell('Pedido'):SetValue("")
        oSection1:Cell('N.F.'):SetValue("")
        oSection1:Cell('Tipo'):SetValue("")
        oSection1:Cell('Status'):SetValue(aAux[nCont,01])
        oSection1:Cell('Vendedor'):SetValue(aAux[nCont,01])
        oSection1:Cell('Cod_Clifor'):SetValue("")
        oSection1:Cell('Razao'):SetValue("")
        //oSection1:Cell('Entrada'):SetValue(0)
        //oSection1:Cell('Saida'):SetValue(0)
        oSection1:Cell('Entrada'):HIDE()
        oSection1:Cell('Saida'):HIDE()
        oSection1:Cell('Saldo'):SetValue(Transform(aAux[nCont,13],"@E 999,999,999.99"))
        oReport:ThinLine()
        //oSection1:PrintLine()*/
            
    Else 
        //If upper(aAux[nCont,09]) <> 'SALDO INICIAL'
            oSection1:Cell('Data'):SetValue(aAux[nCont,03])
            oSection1:Cell('Pedido'):SetValue(aAux[nCont,04])
            oSection1:Cell('N.F.'):SetValue(aAux[nCont,05])
            oSection1:Cell('Tipo'):SetValue(aAux[nCont,06])
            oSection1:Cell('Status'):SetValue(aAux[nCont,07])
            oSection1:Cell('Vendedor'):SetValue(aAux[nCont,08])
            oSection1:Cell('Cod_Clifor'):SetValue(aAux[nCont,09])
            oSection1:Cell('Razao'):SetValue(aAux[nCont,10])

            If aAux[nCont,11] <> 0
                oSection1:Cell('Entrada'):Show()
                //oSection1:Cell('Entrada'):SetValue(If(aAux[nCont,11]<>0,aAux[nCont,11],''))
                oSection1:Cell('Entrada'):SetValue(Transform(aAux[nCont,11],"@E 999,999,999.99"))
            ELSE
                oSection1:Cell('Entrada'):Hide()
            EndIf 

            If aAux[nCont,12] <> 0
                oSection1:Cell('Saida'):Show()
                oSection1:Cell('Saida'):SetValue(Transform(aAux[nCont,12],"@E 999,999,999.99"))
                //oSection1:Cell('Saida'):SetValue(If(aAux[nCont,12]<>0,aAux[nCont,12],''))
            else
                oSection1:Cell('Saida'):Hide()
            EndIf
            oSection1:Cell('Saldo'):SetValue(Transform(aAux[nCont,13],"@E 999,999,999.99"))
    EndIf 
    
    nSldFim := aAux[nCont,13]
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	

Next nCont

oSection1:Cell('Data'):SetValue("")
oSection1:Cell('Pedido'):SetValue("")
oSection1:Cell('N.F.'):SetValue("")
oSection1:Cell('Tipo'):SetValue("")
oSection1:Cell('Status'):SetValue("")
oSection1:Cell('Vendedor'):SetValue("Saldo Final")
oSection1:Cell('Cod_Clifor'):SetValue("")
oSection1:Cell('Razao'):SetValue("")
oSection1:Cell('Entrada'):SetValue(Transform(0,"@E 999,999,999.99"))
oSection1:Cell('Saida'):SetValue(Transform(0,"@E 999,999,999.99"))
oSection1:Cell('Saldo'):SetValue(Transform(nSldFim,"@E 999,999,999.99"))
oReport:ThinLine()
oSection1:PrintLine()

oSection1:Finish()
oReport:EndPage() 

Return Nil

/*/{Protheus.doc} BuscNf
    (long_description)
    @type  Static Function
    @author user
    @since 13/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscNf(cDoc,cSer)
    
Local aArea :=  GetArea()
Local cQuery 
Local aRet  :=  {}

cQuery := "SELECT DISTINCT F2.R_E_C_D_E_L_ AS RCDL,D2_PEDIDO,F2_CLIENTE,A1_NOME,A3_NOME"
cQuery += " FROM "+RetSQLName("SF2")+" F2" 
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND F2_CLIENTE=D2_CLIENTE AND D2_LOJA=F2_LOJA"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=F2_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC='"+cDoc+"' AND F2_SERIE='"+cSer+"'"

If Select('QUERY') > 0
	dbSelectArea('QUERY')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QUERY",.F.,.T.)

dbSelectArea("QUERY")

While !EOF()
    Aadd(aRet,{QUERY->RCDL,QUERY->D2_PEDIDO,QUERY->F2_CLIENTE,QUERY->A1_NOME,QUERY->A3_NOME})
    Dbskip()
EndDo

RestArea(aArea)

Return(aRet)
