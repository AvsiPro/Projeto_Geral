#Include 'Totvs.ch'
#Include 'Tbiconn.ch'
#Include "Topconn.ch"

/*/{Protheus.doc} ROBTFT04
    @description Relatorio controle de pedidos.
    @type User Function
    @author Felipe Mayer
    @since 28/02/2023
/*/
User Function ROBTFT04()

Local dDataDe := CToD("  /  /    ")
Local dDataAt := CToD("  /  /    ")
Local aPergs  := {}

If Empty(FunName())
    RpcSetType(3)
    RpcSetEnv('01', '0103')
EndIf

aAdd(aPergs, {1, "Data de emissao De",  dDataDe,  "", ".T.", "", ".T.", 100,  .F.})
aAdd(aPergs, {1, "Data de emissao Até", dDataAt,  "", ".T.", "", ".T.", 100,  .T.})

If ParamBox(aPergs, "Informe os parâmetros")
    cPeriod := DToC(MV_PAR01) + " - " + DToC(MV_PAR02)
    Processa({|| ROBTFT04A()}, "Gerando Relatorio...")
EndIf

Return


Static Function ROBTFT04A()

Local cStat   := ''
Local nTotReg := 0
Local nAtual  := 0
Local nX      := 0
Local aValAux := {0,0,0,0,0,0,0,0,0,0,0,0}

Private aNomAux := {'Analisados','Liberados','Pendentes','Em aberto (nao foi tratado ainda)'}
Private aSubAux := {}

For nX := 1 To Len(aNomAux)
    aAdd(aSubAux, {aNomAux[nX],{;
        {0,0,0} /*Informacoes cadastrais*/,;
        {0,0,0} /*Limite de credito*/,;
        {0,0,0} /*Boletos em atraso*/,;
        {0,0,0} /*Aguardando blu*/,;
        {0,0,0} /*Aguardando pix*/,;
        {0,0,0} /*Aguardandochq*/,;
        {0,0,0} /*Aguardando representante*/,;
        {0,0,0} /*Serasa*/,;
        {0,0,0} /*Outros*/;
    }})
Next nX

dUltDom := DaySub(dDataBase,Dow(dDataBase)-1)
dProSab := DaySum(DaySub(dDataBase,Dow(dDataBase)-1),6)

cQuery := " SELECT COALESCE(CAST(CAST(C5_XOBSLIB AS VARBINARY(8000)) AS VARCHAR(8000)),' ') AS OBS, * FROM " + RetSQLName("SC5") + " SC5  " 
cQuery += " WHERE SC5.D_E_L_E_T_= ' '   " 
cQuery += " AND C5_EMISSAO BETWEEN '"+DToS(mv_par01)+"' AND '"+DToS(mv_par02)+"' " 
cQuery += " AND C5_FILIAL = " + xFilial('SC5') + "  " 

TCQuery cQuery New Alias "QRYAUX"

Count To nTotReg
ProcRegua(nTotReg)

QRYAUX->(DbGoTop())

While QRYAUX->(!EoF())

    nAtual++
    IncProc("Registro " + cValToChar(nAtual) + " de " + cValToChar(nTotReg))

    cAuxObs := Alltrim(FwCutOff(QRYAUX->OBS,.T.))
    For nX := 1 To len(cAuxObs)

        If At("<mpen>",  cAuxObs, nX) != 0
            nPosIni  := At("<mpen>",  cAuxObs, nX)
            nPosFim  := At("</mpen>",  cAuxObs, nX) + Len("</mpen>")
            nLeitura := nPosFim - nPosIni

            cStat :=  StrTran(StrTran(Alltrim(SubStr(cAuxObs, nPosIni, nLeitura)), "<mpen>", ""), "</mpen>", "")
        EndIf

        If Substr(cAuxObs, nX, 4) == "Data"
            dData := CToD(SubStr(cAuxObs, nX + 5, 10))
        EndIf
    Next nX

    fAuxValores(@aValAux,dData,dUltDom,dProSab,cStat)

    QRYAUX->(DbSkip())
EndDo

fGeraRel(aValAux)

Return


Static Function fAuxValores(aValAux,dData,dUltDom,dProSab,cStat)

    If Empty(QRYAUX->C5_LIBEROK) .And. Empty(QRYAUX->C5_NOTA) .And. Empty(Alltrim(QRYAUX->C5_BLQ)) .And. !(QRYAUX->C5_ZZSTATU $ 'X/B/C/F/G/H')
        fAuxSubVal(cStat,4)
        aValAux[10]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[11]++
        EndIf
        If dData == dDataBase
            aValAux[12]++
        EndIf
    ElseIf (!Empty(QRYAUX->C5_NOTA) .Or. QRYAUX->C5_LIBEROK == 'E' .And. Empty(Alltrim(QRYAUX->C5_BLQ))) .And. Empty(QRYAUX->C5_ZZSTATU)
        fAuxSubVal(cStat,2)
        aValAux[4]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[5]++
        EndIf
        If dData == dDataBase
            aValAux[6]++
        EndIf
    ElseIf !Empty(QRYAUX->C5_LIBEROK) .And. Empty(QRYAUX->C5_NOTA) .And. Empty(Alltrim(QRYAUX->C5_BLQ)) .And. Empty(QRYAUX->C5_MSBLQL)
        fAuxSubVal(cStat,3)
        aValAux[7]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[8]++
        EndIf
        If dData == dDataBase
            aValAux[9]++
        EndIf
    ElseIf QRYAUX->C5_MSBLQL == '2' .And. Empty(QRYAUX->C5_ZZSTATU)
        fAuxSubVal(cStat,3)
        aValAux[7]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[8]++
        EndIf
        If dData == dDataBase
            aValAux[9]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "A"
        fAuxSubVal(cStat,1)
        aValAux[1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[2]++
        EndIf
        If dData == dDataBase
            aValAux[3]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "B"
        fAuxSubVal(cStat,3)
        aValAux[7]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[8]++
        EndIf
        If dData == dDataBase
            aValAux[9]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "C"
        fAuxSubVal(cStat,3)
        aValAux[7]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[8]++
        EndIf
        If dData == dDataBase
            aValAux[9]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "D"
        fAuxSubVal(cStat,3)
        aValAux[7]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[8]++
        EndIf
        If dData == dDataBase
            aValAux[9]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "E"
        fAuxSubVal(cStat,2)
        aValAux[4]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[5]++
        EndIf
        If dData == dDataBase
            aValAux[6]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "F"
        fAuxSubVal(cStat,1)
        aValAux[1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[2]++
        EndIf
        If dData == dDataBase
            aValAux[3]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "H"
        fAuxSubVal(cStat,2)
        aValAux[4]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[5]++
        EndIf
        If dData == dDataBase
            aValAux[6]++
        EndIf
    ElseIf QRYAUX->C5_ZZSTATU == "X"
        fAuxSubVal(cStat,4)
        aValAux[10]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aValAux[11]++
        EndIf
        If dData == dDataBase
            aValAux[12]++
        EndIf
    EndIf

Return


Static Function fAuxSubVal(cStat,nPosi)

If !Empty(cStat)
    If cStat == "Informacoes cadastrais"
        aSubAux[nPosi,2,1,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,1,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,1,3]++
        EndIf
    ElseIf cStat == "Limite de credito"
        aSubAux[nPosi,2,2,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,2,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,2,3]++
        EndIf
    ElseIf cStat == "Boletos em atraso"
        aSubAux[nPosi,2,3,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,3,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,3,3]++
        EndIf
    ElseIf cStat == "Aguardando blu"
        aSubAux[nPosi,2,4,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,4,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,4,3]++
        EndIf
    ElseIf cStat == "Aguardando pix"
        aSubAux[nPosi,2,5,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,5,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,5,3]++
        EndIf
    ElseIf cStat == "Aguardando chq"
        aSubAux[nPosi,2,6,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,6,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,6,3]++
        EndIf
    ElseIf cStat == "Aguardando representante"
        aSubAux[nPosi,2,7,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,7,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,7,3]++
        EndIf
    ElseIf cStat == "Serasa"
        aSubAux[nPosi,2,8,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,8,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,8,3]++
        EndIf
    Else
        aSubAux[nPosi,2,9,1]++
        If !(dData - dUltDom > 6) .And. dData - dUltDom >= 0 .And. dData - dProSab >= -6
            aSubAux[nPosi,2,9,2]++
        EndIf
        If dData == dDataBase
            aSubAux[nPosi,2,9,3]++
        EndIf
    EndIf
EndIf

Return


Static Function fGeraRel(aValAux)

Local oExcel   := FWMsExcelEx():New()
Local dDataGer := Date()
Local cHoraGer := Time()
Local cArq     := ""
Local cNome    := "Sintetico"
Local cNome2   := "Analitico"
Local cTabela  := "Periodo "+cPeriod
Local cDirTmp  := ""
Local nX       := 0

oExcel:AddworkSheet(cNome) 

oExcel:AddTable(cNome,cTabela)
oExcel:AddColumn(cNome,cTabela,"Controle de Pedidos Pendentes",1,1)
oExcel:AddColumn(cNome,cTabela,"Mês",2,1)
oExcel:AddColumn(cNome,cTabela,"Semana",2,1)
oExcel:AddColumn(cNome,cTabela,"Dia",2,1)

oExcel:AddRow(cNome, cTabela, {"Analisados", cValToChar(aValAux[1]), cValToChar(aValAux[2]), cValToChar(aValAux[3])})
oExcel:AddRow(cNome, cTabela, {"Liberados", cValToChar(aValAux[4])  , cValToChar(aValAux[5])  , cValToChar(aValAux[6])})
oExcel:AddRow(cNome, cTabela, {"Pendentes", cValToChar(aValAux[7]) , cValToChar(aValAux[8]) , cValToChar(aValAux[9])})
oExcel:AddRow(cNome, cTabela, {"Em aberto (nao foi tratado ainda)", cValToChar(aValAux[10]), cValToChar(aValAux[11]), cValToChar(aValAux[12])})
oExcel:AddRow(cNome, cTabela, {"","","",""})
oExcel:AddRow(cNome, cTabela, {"-----> Totais", cValToChar(aValAux[1]+aValAux[4]+aValAux[7]+aValAux[10]),cValToChar(aValAux[2]+aValAux[5]+aValAux[8]+aValAux[11]), cValToChar(aValAux[3]+aValAux[6]+aValAux[9]+aValAux[12])})

oExcel:AddworkSheet(cNome2) 

oExcel:AddTable(cNome2,cTabela)
oExcel:AddColumn(cNome2,cTabela,"Detalhes Pendencias",1,1)
oExcel:AddColumn(cNome2,cTabela,"Mês",2,1)
oExcel:AddColumn(cNome2,cTabela,"Semana",2,1)
oExcel:AddColumn(cNome2,cTabela,"Dia",2,1)


For nX := 1 To Len(aSubAux)
    If nX > 1
        oExcel:AddRow(cNome2, cTabela, {"", "", "", ""})
    EndIf

    oExcel:AddRow(cNome2, cTabela, {"", "", "", ""})

    oExcel:SetCelBold(.T.)
    oExcel:SetCelSizeFont(12)
    oExcel:AddRow(cNome2, cTabela, {'- '+aSubAux[nX,1], "", "", ""},{1})

    oExcel:AddRow(cNome2, cTabela, {"'          Informacoes cadastrais", cValToChar(aSubAux[nX,2,1,1]), cValToChar(aSubAux[nX,2,1,2]), cValToChar(aSubAux[nX,2,1,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Limite de credito", cValToChar(aSubAux[nX,2,2,1])  , cValToChar(aSubAux[nX,2,2,2])  , cValToChar(aSubAux[nX,2,2,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Boletos em atraso", cValToChar(aSubAux[nX,2,3,1]) , cValToChar(aSubAux[nX,2,3,2]) , cValToChar(aSubAux[nX,2,3,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Aguardando blu", cValToChar(aSubAux[nX,2,4,1]) , cValToChar(aSubAux[nX,2,4,2]) , cValToChar(aSubAux[nX,2,4,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Aguardando pix", cValToChar(aSubAux[nX,2,5,1]) , cValToChar(aSubAux[nX,2,5,2]) , cValToChar(aSubAux[nX,2,5,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Aguardando chq", cValToChar(aSubAux[nX,2,6,1]) , cValToChar(aSubAux[nX,2,6,2]) , cValToChar(aSubAux[nX,2,6,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Aguardando representante", cValToChar(aSubAux[nX,2,7,1]) , cValToChar(aSubAux[nX,2,7,2]) , cValToChar(aSubAux[nX,2,7,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Serasa", cValToChar(aSubAux[nX,2,8,1]) , cValToChar(aSubAux[nX,2,8,2]) , cValToChar(aSubAux[nX,2,8,3])})
    oExcel:AddRow(cNome2, cTabela, {"'          Outros", cValToChar(aSubAux[nX,2,9,1]) , cValToChar(aSubAux[nX,2,9,2]) , cValToChar(aSubAux[nX,2,9,3])})
    
    nTot1 := aSubAux[nX,2,1,1]+aSubAux[nX,2,2,1]+aSubAux[nX,2,3,1]+aSubAux[nX,2,4,1]+aSubAux[nX,2,5,1]+aSubAux[nX,2,6,1]+aSubAux[nX,2,7,1]+aSubAux[nX,2,8,1]+aSubAux[nX,2,9,1]
    nTot2 := aSubAux[nX,2,1,2]+aSubAux[nX,2,2,2]+aSubAux[nX,2,3,2]+aSubAux[nX,2,4,2]+aSubAux[nX,2,5,2]+aSubAux[nX,2,6,2]+aSubAux[nX,2,7,2]+aSubAux[nX,2,8,2]+aSubAux[nX,2,9,2]
    nTot3 := aSubAux[nX,2,1,3]+aSubAux[nX,2,2,3]+aSubAux[nX,2,3,3]+aSubAux[nX,2,4,3]+aSubAux[nX,2,5,3]+aSubAux[nX,2,6,3]+aSubAux[nX,2,7,3]+aSubAux[nX,2,8,3]+aSubAux[nX,2,9,3]

    oExcel:AddRow(cNome2, cTabela, {"-----> Totais", cValToChar(nTot1),cValToChar(nTot2),cValToChar(nTot3)})
Next nX


cDirTmp := cGetFile( '*.csv|*.csv' , 'Selecionar um diretório para salvar', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )

oExcel:Activate()
cArq := DToS(dDataGer) + "_" + StrTran(cHoraGer, ':', '-') + ".xml" 

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
