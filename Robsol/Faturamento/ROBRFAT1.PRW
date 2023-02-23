#Include 'protheus.ch'
#Include 'tbiconn.ch'
#Include "topconn.ch"

User Function ROBRFAT1()

If Empty(FunName())
    RpcSetType(3)
    RpcSetEnv('01', '0103')
EndIf

Processa({|| fGeraRel()}, "Gerando Relatorio...")

Return


Static Function fGeraRel()

    Local cQuery      :=    ""
    Local cArq        :=    ""
    Local cNome       :=    "Relatorio"
    Local cTabela     :=    "Relatorio"
    Local cDirTmp     :=    ""
    Local cData       :=    ""
    Local nX          :=    0
    Local nLibM       :=    0
    Local nLibS       :=    0
    Local nLibD       :=    0
    Local nAnaliM     :=    0
    Local nAnaliS     :=    0
    Local nAnaliD     :=    0
    Local nAbertM     :=    0
    Local nAbertS     :=    0
    Local nAbertD     :=    0
    Local nPendM      :=    0
    Local nPendS      :=    0
    Local nPendD      :=    0
    Local nTotReg     :=    0
    Local nAtual      :=    0
    Local oExcel      :=    FWMSEXCEL():New()
    Local dDataGer    :=    Date()
    Local cHoraGer    :=    Time()
    Local dUltDom     :=    DaySub(dDataBase,Dow(dDataBase)-1)
    Local dProSab     :=    DaySum(DaySub(dDataBase,Dow(dDataBase)-1),6)

    cQuery := " SELECT C5_FILIAL,C5_NUM,C5_EMISSAO,C5_ZZSTATU,COALESCE(CAST(CAST(C5_XOBSLIB AS VARBINARY(8000)) AS VARCHAR(8000)),' ') AS OBS,C5_LIBEROK,C5_NOTA,C5_BLQ,C5_MSBLQL   " 
    cQuery += " FROM   " + RetSQLName("SC5") + " SC5   " 
    cQuery += " WHERE  C5_FILIAL = '" + xFilial("SC5") + "'   " 
    cQuery += "        AND SUBSTRING(COALESCE(CAST(CAST(C5_XOBSLIB AS VARBINARY(8000)) AS VARCHAR(8000)),' '),9,7) = '" + StrZero(Month(dDataBase), 2) + "/" + cValToChar(Year(dDataBase)) + "' "
    cQuery += "        AND D_E_L_E_T_='' "
    cQuery += " UNION   " 
    cQuery += " SELECT C5_FILIAL,C5_NUM,C5_EMISSAO,C5_ZZSTATU,COALESCE(CAST(CAST(C5_XOBSLIB AS VARBINARY(8000)) AS VARCHAR(8000)),' ') AS OBS,C5_LIBEROK,C5_NOTA,C5_BLQ,C5_MSBLQL   " 
    cQuery += " FROM   " + RetSQLName("SC5") + "   " 
    cQuery += " WHERE  C5_EMISSAO BETWEEN '" + DtoS(FirstDate(dDataBase)) + "'   " 
    cQuery += "        AND '" + DtoS(LastDate(dDataBase)) + "'   " 
    cQuery += "        AND C5_FILIAL = '" + xFilial("SC5") + "' AND D_E_L_E_T_=''   " 
    cQuery += " ORDER BY C5_NUM "

    TCQuery cQuery New Alias "QRYAUX"

    Count To nTotReg
    ProcRegua(nTotReg)
    
    QRYAUX->(DbGoTop())
    While QRYAUX->(!EoF())

        //Incrementa a mensagem na régua
        nAtual++
        IncProc("Registro " + cValToChar(nAtual) + " de " + cValToChar(nTotReg) + "...")

        cData := QRYAUX->C5_EMISSAO
        For nX := 1 To len(StrTran(QRYAUX->OBS, " ", ""))
            If Substr(StrTran(QRYAUX->OBS, " ", ""), nX, 4) == "Data"
                cData := DtoS(CtoD(SubStr(StrTran(QRYAUX->OBS, " ", ""), nX + 4, 10)))
            EndIf
        Next nX

        If Empty(QRYAUX->C5_LIBEROK) .AND. Empty(QRYAUX->C5_NOTA) .AND. Empty(ALLTRIM(QRYAUX->C5_BLQ)) .AND. !(QRYAUX->C5_ZZSTATU $ 'X/B/C/F/G/H')
            nAbertM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nAbertS++
            EndIf
            If cData == dtos(dDataBase)
                nAbertD++
            EndIf
        ElseIf (!Empty(QRYAUX->C5_NOTA) .OR. QRYAUX->C5_LIBEROK == 'E' .AND. Empty(ALLTRIM(QRYAUX->C5_BLQ))) .AND. Empty(QRYAUX->C5_ZZSTATU)
            nLibM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nLibS++
            EndIf
            If cData == dtos(dDataBase)
                nLibD++
            EndIf
        ElseIf !Empty(QRYAUX->C5_LIBEROK) .AND. Empty(QRYAUX->C5_NOTA) .AND. Empty(ALLTRIM(QRYAUX->C5_BLQ)) .AND. Empty(QRYAUX->C5_MSBLQL)
            nPendM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nPendS++
            EndIf
            If cData == dtos(dDataBase)
                nPendD++
            EndIf
        ElseIf QRYAUX->C5_MSBLQL == '2' .AND. Empty(QRYAUX->C5_ZZSTATU)
            nPendM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nPendS++
            EndIf
            If cData == dtos(dDataBase)
                nPendD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "A"
            nAnaliM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nAnaliS++
            EndIf
            If cData == dtos(dDataBase)
                nAnaliD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "B"
            nPendM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nPendS++
            EndIf
            If cData == dtos(dDataBase)
                nPendD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "C"
            nPendM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nPendS++
            EndIf
            If cData == dtos(dDataBase)
                nPendD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "D"
            nPendM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nPendS++
            EndIf
            If cData == dtos(dDataBase)
                nPendD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "E"
            nLibM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nLibS++
            EndIf
            If cData == dtos(dDataBase)
                nLibD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "F"
            nAnaliM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nAnaliS++
            EndIf
            If cData == dtos(dDataBase)
                nAnaliD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "H"
            nLibM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nLibS++
            EndIf
            If cData == dtos(dDataBase)
                nLibD++
            EndIf
        ElseIf QRYAUX->C5_ZZSTATU == "X"
            nAbertM++
            If !(val(cData) - val(dtos(dUltDom)) > 6) .AND. val(cData) - val(dtos(dUltDom)) >= 0 .AND. val(cData) - val(dtos(dProSab)) >= -6
                nAbertS++
            EndIf
            If cData == dtos(dDataBase)
                nAbertD++
            EndIf
        EndIf
        QRYAUX->(DbSkip())
    EndDo

    oExcel:AddworkSheet(cNome) 

    oExcel:AddTable(cNome,cTabela)
    oExcel:AddColumn(cNome,cTabela,"Controle de Pedidos Pendentes",2,1)
    oExcel:AddColumn(cNome,cTabela,"Mês",2,1)
    oExcel:AddColumn(cNome,cTabela,"Semana",2,1)
    oExcel:AddColumn(cNome,cTabela,"Dia",2,1)

    oExcel:AddRow(cNome, cTabela, {"", "", "", ""})
    oExcel:AddRow(cNome, cTabela, {"Analisados", cValToChar(nAnaliM), cValToChar(nAnaliS), cValToChar(nAnaliD)})
    oExcel:AddRow(cNome, cTabela, {"Liberados", cValToChar(nLibM)  , cValToChar(nLibS)  , cValToChar(nLibD)})
    oExcel:AddRow(cNome, cTabela, {"Pendentes", cValToChar(nPendM) , cValToChar(nPendS) , cValToChar(nPendD)})
    oExcel:AddRow(cNome, cTabela, {"Em aberto (nao foi tratado ainda)", cValToChar(nAbertM), cValToChar(nAbertS), cValToChar(nAbertD)})

    cDirTmp := cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

    oExcel:Activate()

    cArq := dTos(dDataGer) + "_" + StrTran(cHoraGer, ':', '-') + ".xml" 

    oExcel:GetXMLFile(cArq)
    
    If __CopyFile(cArq,cDirTmp + cArq)
        
        oExcelApp := MSExcel():New()
        oExcelApp:WorkBooks:Open(cDirTmp + cArq)
        oExcelApp:SetVisible(.T.)
        oExcelApp:Destroy()
        
        MsgInfo("O arquivo Excel foi gerado no diretório: " + cDirTmp + cArq + ". ")
    Else
        MsgAlert("Erro ao criar o arquivo Excel!")
    EndIf

Return
