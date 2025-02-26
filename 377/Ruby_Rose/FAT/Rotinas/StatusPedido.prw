    //Bibliotecas
#INCLUDE 'PROTHEUS.CH'
#Include 'RWMake.ch'
#INCLUDE 'FWMVCDEF.CH'
#Include 'Topconn.ch'

/*/{Protheus.doc} zStatusP
Tela gráfica para mostrar o STATUS DO PEDIDO COM ACD
@type function
@author Paulo Lima
@since 01/02/2022
@version 1.0
	@example
	u_zStatusP()
/*/

User Function zStatusP()
    Local aCoors    := FWGetDialogSize( oMainWnd )
    Local aArea     := GetArea()
    Local nTotPed   := 0

    Private cHDIni  := ""
    Private cHDFim  := ""

    Private cHorita1 := ""
    Private cHorita2 := ""
    Private cHorita3 := ""
    Private cHorita4 := ""
    Private cHorita5 := ""
    Private cHorita6 := ""
    Private cHorita7 := ""

    oFont16         := TFont():New('Arial',,16,.T.)
    oFont12         := TFont():New('Arial',,12,.T.)

 	//Selecionando o Status
	cQryPed := " SELECT "                                       + CRLF
	cQryPed += "    ZZ1_FILIAL, "                               + CRLF
	cQryPed += "    ZZ1_PEDIDO, "                               + CRLF
	cQryPed += "    ZZ1_I_FS01, "                               + CRLF
	cQryPed += "    ZZ1_F_FS01, "                               + CRLF
	cQryPed += "    ZZ1_I_FS02, "                               + CRLF
	cQryPed += "    ZZ1_F_FS02, "                               + CRLF
	cQryPed += "    ZZ1_I_FS03, "                               + CRLF
	cQryPed += "    ZZ1_F_FS03, "                               + CRLF
	cQryPed += "    ZZ1_I_FS04, "                               + CRLF
	cQryPed += "    ZZ1_F_FS04, "                               + CRLF
	cQryPed += "    ZZ1_I_FS05, "                               + CRLF
	cQryPed += "    ZZ1_F_FS05, "                               + CRLF
	cQryPed += "    ZZ1_I_FS06, "                               + CRLF
    cQryPed += "    ZZ1_F_FS06, "                               + CRLF
	cQryPed += "    ZZ1_EXCLUS "                                + CRLF
	cQryPed += " FROM "                                         + CRLF
	cQryPed += "    "+RetSQLName("ZZ1")+" ZZ1 "                 + CRLF
	cQryPed += " WHERE "                                        + CRLF
	cQryPed += "    ZZ1.ZZ1_FILIAL   = '"+FWxFilial("ZZ1")+"' " + CRLF
	cQryPed += "    AND ZZ1_PEDIDO =  " + SC5->C5_NUM           + CRLF
	cQryPed += "    AND ZZ1.D_E_L_E_T_ = ' ' "                  + CRLF

	TCQuery cQryPed New Alias "QRY_PED"
    Count To nTotPed

    DEFINE DIALOG oDlg TITLE "STATUS DO PEDIDO" FROM aCoors[1], aCoors[2] To aCoors[3], aCoors[4] PIXEL

    //MAPEAMENTO NA REDE OBRIGATÓRIO PARA APARECER AS IMAGENS NO STATUS DO PEDIDO
    // totvs(//rr-dcfs) (M:)

 	If nTotPed != 0
        QRY_PED->(DbGoTop())
           //fase 1  -> PEDIDO EM ABERTO
        If AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS01) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS01) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS02) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status1.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 1")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(1)
           
           //fase 1 Exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_I_FS01) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS01) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS02) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status1E.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 1 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(1)
           
           //fase 2  -> LIBERAÇÃO DO FINANCEIRO
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS02) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS02) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS03) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status2.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 2")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.
            
            CalcTime(2)

           //fase 2 Exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_I_FS02) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS02) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS03) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status2E.PNG",.T.,oDlg,;
                {||Alert("Clicou em 2 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(2)

           //fase 3  -> EM SEPARAÇÃO
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS03) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS03) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS04) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status3.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 3")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(3)

           //fase 3 Exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_I_FS03) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS03) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS04) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status3E.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 3 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(3)

           //fase 4  -> EM CONFERENCIA
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS04) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS04) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS05) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status4.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 4")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(4)

           //fase 4 Exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_I_FS04) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS04) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS05) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status4E.PNG",.T.,oDlg,;
                {||Alert("Clicou em 4 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(4)

           //fase 5  -> EM PRE NOTA FISCAL
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS05) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS05) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS06) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status5.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 5")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(5)

           //fase 5 Exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_I_FS05) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS05) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS06) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status5E.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 5 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.
           
           CalcTime(5)

           //fase 6  -> FATURANDO
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_I_FS06) <> "".AND. AllTrim(QRY_PED->ZZ1_F_FS06) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\Imagens\status6.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 6")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(6)

           //fase 6 Exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_I_FS06) <> "".AND. AllTrim(QRY_PED->ZZ1_F_FS06) == ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\Imagens\status6E.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 6 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(6)

         //fase 7 --> Transmissão da nota concluida
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) == "" .AND. AllTrim(QRY_PED->ZZ1_F_FS06) <> ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\Imagens\status7.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 7 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(7)

         //fase 7 exclusão
         ElseIf AllTrim(QRY_PED->ZZ1_EXCLUS) <> "" .AND. AllTrim(QRY_PED->ZZ1_F_FS06) <> ""
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\Imagens\status7E.PNG",.T.,oDlg,;
                {||Alert("Clicou em fase 7 Exclusão")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.

            CalcTime(7)

        Else // imagem com status vazio
            oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status0.PNG",.T.,oDlg,;
                {||Alert("Clicou em Fase 0 com contagem")},,.F.,.F.,,,.F.,,.T.,,.F.)
            oTBitmap1:lAutoSize := .T.
		//Se houver pedidos
        EndIf

    Else // imagem com status vazio                totvs(//rr-dcfs) (M:)
        oTBitmap1 := TBitmap():New(01,01,260,184,,"M:\IMAGENS\status0.PNG",.T.,oDlg,;
            {||Alert("Clicou em Fase 0 sem contagem")},,.F.,.F.,,,.F.,,.T.,,.F.)
        oTBitmap1:lAutoSize := .T.

    EndIf
    
    ACTIVATE DIALOG oDlg CENTERED

    QRY_PED->(DbCloseArea())
    RestArea(aArea)
Return

#Include 'Protheus.ch'
/*
 * Função:			MA410MNU
 * Autor:			Paulo Lima
 * Data:			01/02/2022
 * Descrição:		Chamado pelo Browse de Pedidos,
 *					com o objetivo de incluir botões de usuário.
 *					Neste caso irá ser incluído um botão para chamar o Status do Pedido.
 */
User Function MA410MNU()
   
    If !IsBlind()
        aAdd(aRotina,{'Status do Pedido'               ,'U_zStatusP'     ,0,3,0,NIL})
        //aAdd(aRotina,{'Teste Qtd Horas'                ,'U_retQtdHrs'    ,0,3,0,NIL})
        aAdd(aRotina,{"Confirmar Entrega"			,	"U_RRFAT01()"	,0,2,0,NIL})
        aadd(aRotina,{'Imprimir Romaneio','U_zRPedVen(2)' , 0 , 3,0,NIL}) //Impressão dos Pedidos a Faturar

    EndIf

Return Nil

//time() ddatabase
User Function retQtdHrs(cHDIni,cHDFim)

//Local cHDIni    := '2022020209:00' //DIA E HORA INICIAL
//Local cHDFim    := '2022020408:37' //DIA E HORA FINAL
Local dDiaIni   := ''
Local dDiaFim   := ''
Local cHoraIni  := ''
Local cHoraFim  := ''

dDiaIni     := Stod(SubStr(cHDIni, 1, 8))
dDiaFim     := Stod(SubStr(cHDFim, 1, 8))
cHoraIni    := SubStr(cHDIni, 9, 5) + ":00"
cHoraFim    := SubStr(cHDFim, 9, 5) + ":00"

//nHoras := NGCALENHORA(23/08/2018,"00:00",26/08/2018,"24:00","001")
nQtdDias    := DateDiffDay(dDiaIni,dDiaFim)

cQtdHoras   := ELAPTIME( cHoraIni, cHoraFim )

If cHoraFim < cHoraIni
    IF nQtdDias > 0
        nQtdDias := nQtdDias -1
    EndIf
EndIf

cRetorno := str(nQtdDias) + " d  || " + SubStr(cQtdHoras, 1, 5) + " h/m"

Return (cRetorno)

Static Function CalcTime(nFase)

    If nFase == 1
       cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
       cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
       cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
       oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
      ElseIf nFase == 2
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
        cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS02)=="", QRY_PED->ZZ1_F_FS01 , QRY_PED->ZZ1_I_FS02)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS02) == "",QRY_PED->ZZ1_F_FS01,QRY_PED->ZZ1_F_FS02)
        cHorita2:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp062  := TSay():New(  05.6, 3.4  ,{||cHorita2} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )                    
      ElseIf nFase == 3
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
        cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS02)=="", QRY_PED->ZZ1_F_FS01 , QRY_PED->ZZ1_I_FS02)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS02) == "",QRY_PED->ZZ1_F_FS01,QRY_PED->ZZ1_F_FS02)
        cHorita2:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp062  := TSay():New(  05.6, 3.4  ,{||cHorita2} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS03)=="", QRY_PED->ZZ1_F_FS02, QRY_PED->ZZ1_I_FS03)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS03)=="", QRY_PED->ZZ1_I_FS03, QRY_PED->ZZ1_F_FS03)
        cHorita3:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp063  := TSay():New(  09.1, 3.4  ,{||cHorita3} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
      ElseIf nFase == 4
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
        cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS02)=="", QRY_PED->ZZ1_F_FS01 , QRY_PED->ZZ1_I_FS02)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS02) == "",QRY_PED->ZZ1_F_FS01,QRY_PED->ZZ1_F_FS02)
        cHorita2:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp062  := TSay():New(  05.6, 3.4  ,{||cHorita2} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS03)=="", QRY_PED->ZZ1_F_FS02, QRY_PED->ZZ1_I_FS03)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS03)=="", QRY_PED->ZZ1_I_FS03, QRY_PED->ZZ1_F_FS03)
        cHorita3:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp063  := TSay():New(  09.1, 3.4  ,{||cHorita3} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS04)=="", QRY_PED->ZZ1_F_FS03, QRY_PED->ZZ1_I_FS04)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS04)=="", QRY_PED->ZZ1_I_FS04, QRY_PED->ZZ1_F_FS04)
        cHorita4:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp064  := TSay():New(  12.6, 3.4  ,{||cHorita4} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
      ElseIf nFase == 5
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
        cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS02)=="", QRY_PED->ZZ1_F_FS01 , QRY_PED->ZZ1_I_FS02)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS02) == "",QRY_PED->ZZ1_F_FS01,QRY_PED->ZZ1_F_FS02)
        cHorita2:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp062  := TSay():New(  05.6, 3.4  ,{||cHorita2} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS03)=="", QRY_PED->ZZ1_F_FS02, QRY_PED->ZZ1_I_FS03)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS03)=="", QRY_PED->ZZ1_I_FS03, QRY_PED->ZZ1_F_FS03)
        cHorita3:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp063  := TSay():New(  09.1, 3.4  ,{||cHorita3} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS04)=="", QRY_PED->ZZ1_F_FS03, QRY_PED->ZZ1_I_FS04)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS04)=="", QRY_PED->ZZ1_I_FS04, QRY_PED->ZZ1_F_FS04)
        cHorita4:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp064  := TSay():New(  12.6, 3.4  ,{||cHorita4} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS05)=="", QRY_PED->ZZ1_F_FS04, QRY_PED->ZZ1_I_FS05)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS05)=="", QRY_PED->ZZ1_I_FS05, QRY_PED->ZZ1_F_FS05)
        cHorita5:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp065  := TSay():New(  16.1, 3.4  ,{||cHorita5} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
      ElseIf nFase == 6
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
        cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS02)=="", QRY_PED->ZZ1_F_FS01 , QRY_PED->ZZ1_I_FS02)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS02) == "",QRY_PED->ZZ1_F_FS01,QRY_PED->ZZ1_F_FS02)
        cHorita2:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp062  := TSay():New(  05.6, 3.4  ,{||cHorita2} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS03)=="", QRY_PED->ZZ1_F_FS02, QRY_PED->ZZ1_I_FS03)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS03)=="", QRY_PED->ZZ1_I_FS03, QRY_PED->ZZ1_F_FS03)
        cHorita3:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp063  := TSay():New(  09.1, 3.4  ,{||cHorita3} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS04)=="", QRY_PED->ZZ1_F_FS03, QRY_PED->ZZ1_I_FS04)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS04)=="", QRY_PED->ZZ1_I_FS04, QRY_PED->ZZ1_F_FS04)
        cHorita4:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp064  := TSay():New(  12.6, 3.4  ,{||cHorita4} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS05)=="", QRY_PED->ZZ1_F_FS04, QRY_PED->ZZ1_I_FS05)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS05)=="", QRY_PED->ZZ1_I_FS05, QRY_PED->ZZ1_F_FS05)
        cHorita5:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp065  := TSay():New(  16.1, 3.4  ,{||cHorita5} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS06)=="", QRY_PED->ZZ1_F_FS05, QRY_PED->ZZ1_I_FS06)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS06)=="", QRY_PED->ZZ1_I_FS06, QRY_PED->ZZ1_F_FS06)
        cHorita6:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp066  := TSay():New(  19.6, 3.4  ,{||cHorita6} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
      ElseIf nFase == 7
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS01)=="", "0000000000:00", QRY_PED->ZZ1_I_FS01)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS01) == "",QRY_PED->ZZ1_I_FS01,QRY_PED->ZZ1_F_FS01)
        cHorita1:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp061  := TSay():New(  02.1, 3.4  ,{||cHorita1} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        //oSayTp061:reFresh(.T.)
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS02)=="", QRY_PED->ZZ1_F_FS01 , QRY_PED->ZZ1_I_FS02)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS02) == "", QRY_PED->ZZ1_F_FS01, QRY_PED->ZZ1_F_FS02)
        cHorita2:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp062  := TSay():New(  05.6, 3.4  ,{||cHorita2} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        oSayTp062:reFresh(.T.)
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS03)=="", QRY_PED->ZZ1_F_FS02, QRY_PED->ZZ1_I_FS03)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS03)=="", QRY_PED->ZZ1_I_FS03, QRY_PED->ZZ1_F_FS03)
        cHorita3:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp063  := TSay():New(  09.1, 3.4  ,{||cHorita3} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        oSayTp063:reFresh(.T.)
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS04)=="", QRY_PED->ZZ1_F_FS03, QRY_PED->ZZ1_I_FS04)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS04)=="", QRY_PED->ZZ1_I_FS04, QRY_PED->ZZ1_F_FS04)
        cHorita4:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp064  := TSay():New(  12.6, 3.4  ,{||cHorita4} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        oSayTp064:reFresh(.T.)
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS05)=="", QRY_PED->ZZ1_F_FS04, QRY_PED->ZZ1_I_FS05)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS05)=="", QRY_PED->ZZ1_I_FS05, QRY_PED->ZZ1_F_FS05)
        cHorita5:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp065  := TSay():New(  16.1, 3.4  ,{||cHorita5} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        oSayTp065:reFresh(.T.)
        cHDIni := IIF(AllTrim(QRY_PED->ZZ1_I_FS06)=="", QRY_PED->ZZ1_F_FS05, QRY_PED->ZZ1_I_FS06)
        cHDFim := IIF(AllTrim(QRY_PED->ZZ1_F_FS06)=="", QRY_PED->ZZ1_I_FS06, QRY_PED->ZZ1_F_FS06)
        cHorita6:= u_retQtdHrs(cHDIni,cHDFim)
        oSayTp066  := TSay():New(  19.6, 3.4  ,{||cHorita6} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
        oSayTp066:reFresh(.T.)

        SomaDia  := Val(Substr(cHorita1,1,14))+Val(Substr(cHorita2,1,14))
        SomaDia1 := SomaDia+Val(Substr(cHorita3,1,14))
        SomaDia2 := SomaDia1+Val(Substr(cHorita4,1,14))
        SomaDia3 := SomaDia2+Val(Substr(cHorita5,1,14))
        SomaDia4 := SomaDia3+Val(Substr(cHorita6,1,14))

        //IncTime([<cTime>],<nIncHours>,<nIncMinuts>,<nIncSeconds> ) -> Somar 
        SomaHora := IncTime(Substr(cHorita1,22,5)+":00",val(Substr(cHorita2,22,2)),val(Substr(cHorita2,25,2)),0)
        SomaHora1:= IncTime(SomaHora,val(Substr(cHorita3,22,2)),val(Substr(cHorita3,25,2)),0)
        SomaHora2:= IncTime(SomaHora1,val(Substr(cHorita4,22,2)),val(Substr(cHorita4,25,2)),0)
        SomaHora3:= IncTime(SomaHora2,val(Substr(cHorita5,22,2)),val(Substr(cHorita5,25,2)),0)
        SomaHora4:= IncTime(SomaHora3,val(Substr(cHorita6,22,2)),val(Substr(cHorita6,25,2)),0)

        cHorita7 := str(SomaDia4)+" d  || "+SomaHora4+" h/m/s"
        oSayTp067  := TSay():New(  23.1, 3.4  ,{||cHorita7} , oDlg , , oFont16 , , , ,   ,CLR_RED ,CLR_WHITE, , , , , , , , , , )
    EndIf
Return()
