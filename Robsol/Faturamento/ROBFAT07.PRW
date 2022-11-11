#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

User Function ROBFAT07()

    Local nLarg
    Local nAlt
    Local aItens1 := {'Todos', 'Selecionados', 'Nao Selecionados'}
    Local aItens2 := {'Tamanho Mala', 'Mala P', 'Mala G'}
    Local nX
    Local aRet   := {}
    Local cQuery
    Local nOpc   := 0

    Private oDlg1,oGrp1,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oBtn6,oList1,oList2,oList3,oComb1,oComb2,oSay1,oSay2,oSay3,oSay4
    Private oFont1         :=    TFont():New( 'Arial',, 20,, .T.,,,,, .T., )
    Private aList1         :=    {}
    Private aList2         :=    {}
    Private aList3         :=    {}
    Private aList3B        :=    {}
    Private cCombo1        :=    ''
    Private cCombo2        :=    ''
    Private oOk            :=    LoadBitmap(GetResources(),'br_verde')
    Private oNo            :=    LoadBitmap(GetResources(),'br_vermelho')
    Private cMarca         :=    '1'
    Private lRet           :=    .F.
    Private lMsErroAuto    :=    .F.
    Private nQtdTot        :=    0
    Private nQtdNotas

    If Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0103")
    EndIf

    buscaGeren()

    cQuery := " "
    cQuery += " SELECT Z03_CODGRI FROM "+RetSQLName("Z03")
    cQuery += " WHERE Z03_FILIAL='"+xFilial("Z03")+"' AND D_E_L_E_T_=' '"
    cQuery += " AND Z03_MSBLQL<>'1'"

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    While !EOF()
        Aadd(aItens1, AllTrim(TRB->Z03_CODGRI))
        DBSKIP()
    End

    oDlg1      := MSDialog():New( 100, 200, 750, 1500, "",,, .F.,,,,,, .T.,,, .T. )
    oGrp1      := TGroup():New( 005, 005, 300, 645, "", oDlg1, CLR_BLACK, CLR_WHITE, .T., .F. )
     
    oList1     := TCBrowse():New( 012, 008, 190, 135,, {'', 'Codigo','Gerente','Regiao'}, {10,25,90,25}, oGrp1,,,, {|| buscaRepre(oList1:nAt)},,,,,,,,,, .T.,,,, .F., .T. )
    oList1:SetArray(aList1)
    oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
                                      aList1[oList1:nAt,2],;
                                      aList1[oList1:nAt,3],;
                                      aList1[oList1:nAt,4]}}
    
    oList2     := TCBrowse():New( 012, 200, 440, 135,, {'','Codigo','Representante','Malas', 'Regioes'},, oGrp1,,,, {|| buscaProd(oList2:nAt)},,,,,,,,,, .T.,,,, .F., .T. )
    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
                                     aList2[oList2:nAt,2],;
                                     aList2[oList2:nAt,3],;
                                     aList2[oList2:nAt,4],;
                                     aList2[oList2:nAt,5]}}

    oList3     := TCBrowse():New( 150, 008, 500, 145,, {'', 'Codigo', 'Descricao', 'Saldo 3', 'Saldo Estoque', 'Preco UN'}, {,,200,,}, oGrp1,,,,, {|| selecProd(oList3:nAt)},,,,,,,,, .T.,,,, .F., .T. )
    oList3:SetArray(aList3)
    oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),;
                                      aList3[oList3:nAt,2],;
                                      aList3[oList3:nAt,3],;
                                      aList3[oList3:nAt,4],;
                                      aList3[oList3:nAt,5]}}

    nLarg := 052*1.5
    nAlt  := 012*1.5
    nLinha:= 128
    
    oComb1     := TComboBox():New( nLinha+26, 510, {|u| IF( PCount() > 0, cCombo1 := u, cCombo1 )}, aItens1, nLarg-25, nAlt, oGrp1,, {|| filtraLista()},, CLR_BLACK, CLR_WHITE, .T.,, "",,,,,,, )
    oComb2     := TComboBox():New( nLinha+51, 510, {|u| IF( PCount() > 0, cCombo2 := u, cCombo2 )}, aItens2, nLarg-25, nAlt, oGrp1,,                   ,, CLR_BLACK, CLR_WHITE, .T.,, "",,,,,,, )
    
    oBtn1      := TButton():New( nLinha+25,   564,  "Ok",                   oGrp1, {|| oDlg1:end(nOpc:=1)},      nLarg,    nAlt,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( nLinha+50,   564,  "Marca/Desmarca Todos", oGrp1, {|| marcaTodos()},            nLarg,    nAlt,,,,.T.,,"",,,,.F. )
    oBtn4      := TButton():New( nLinha+100,  564,  "Sair",                 oGrp1, {|| oDlg1:end(nOpc:=0)},      nLarg,    nAlt,,,,.T.,,"",,,,.F. )
    oBtn5      := TButton():New( nLinha+75,   510,  "Ir ao In�cio",         oGrp1, {|| oList3:GoTop()},          nLarg-25, nAlt,,,,.T.,,"",,,,.F. )
    oBtn6      := TButton():New( nLinha+100,  510,  "Ir ao Fim",            oGrp1, {|| oList3:GoBottom()},       nLarg-25, nAlt,,,,.T.,,"",,,,.F. )

    oSay1:= TSay():New( nLinha+180, 10, {||'Quantidade total de produtos: '}, oDlg1,,      ,,,, .T., CLR_BLACK,, 200, 20 )
    oSay2:= TSay():New( nLinha+177, 85, {||''},                               oDlg1,,oFont1,,,, .T., CLR_BLACK,, 200, 20 )
    oSay3:= TSay():New( nLinha+180, 140, {||'Quantidade de notas: '}, oDlg1,,      ,,,, .T., CLR_BLACK,, 200, 20 )
    oSay4:= TSay():New( nLinha+177, 195, {||''},                               oDlg1,,oFont1,,,, .T., CLR_BLACK,, 200, 20 )

    oDlg1:Activate( ,,, .T. )

    if nOpc == 1
        for nX := 1 to len(aList1)
            if aList1[nX,1]
                Aadd(aRet, aList1[nX])
            endif
        next

        for nX := 1 to len(aList2)
            if aList2[nX,1]
                Aadd(aRet, aList2[nX])
            endif
        next

        for nX := 1 to len(aList3B)
            if aList3B[nX,1]
                Aadd(aRet, aList3B[nX]) 
            endif
        next
    
        Processa({|| geraPV(aRet)}, "Gerando Pedido de Venda...")
        if lRet
            // Processa({|| geraPDEeDE(aRet)}, "Gerando Pr�-Documento de Entrada e Documento de Entrada...")  
        endif
        
        if !lRet
            MsgAlert("Pedido n�o conclu�do!", "Erro!")
        endif
    endif

Return

Static Function buscaGeren()
    
    Local cQuery := ''

    cQuery := " "
    cQuery += " SELECT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO " 
    cQuery += " FROM " + RetSQLName("SA3") + " SA3 " 
    cQuery += " LEFT JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_FILIAL=SA3.A3_FILIAL AND Z30.Z30_CODVEN = SA3.A3_COD AND Z30.D_E_L_E_T_=' ' " 
    cQuery += " WHERE SA3.A3_FILIAL='"+xFilial("SA3")+"' AND SA3.A3_XFUNCAO = '2' AND SA3.D_E_L_E_T_=' '" 

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    While !EOF()
        Aadd(aList1, { .F., TRB->A3_COD, AllTrim(TRB->A3_NOME), AllTrim(TRB->Z30_REGIAO)})
        DBSKIP()
    End

Return

Static Function buscaRepre(nLinha)

    Local cQuery := ''
    Local cGeren := aList1[nLinha,2]
    Local nX

    aList2 := {}
    
    cQuery := " "
    cQuery += " SELECT DISTINCT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO,SA1.A1_COD,SA1.A1_LOJA,SA1.A1_TIPO " 
    cQuery += " FROM   " + RetSQLName("SA3") + " SA3 " 
    cQuery += " INNER JOIN " + RetSQLName("Z30") + " Z30 ON SA3.A3_COD = Z30.Z30_CODVEN " 
    cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON SA1.A1_CGC = SA3.A3_CGC "
    cQuery += " WHERE Z30.Z30_FILIAL='"+xFilial("Z30")+"' AND Z30.Z30_CODGER = '"+ cGeren +"' "
    cQuery += " AND  SA3.A3_XFUNCAO != '2' "
    cQuery += " AND  Z30.Z30_MALA != '' "

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    While !EOF()
        Aadd(aList2, { .F., TRB->A3_COD, AllTrim(TRB->A3_NOME), AllTrim(TRB->Z30_MALA), AllTrim(TRB->Z30_REGIAO),TRB->A1_COD,TRB->A1_LOJA,TRB->A1_TIPO})
        DBSKIP()
    End

    If aList1[nLinha,1] == .T.
        aList1[nLinha,1] := .F.

    Else
        aList1[nLinha,1] := .T.
    EndIf

    for nX := 1 to len(aList1)
        if nX == nLinha
            nX++
        endif
        if !(nX > len(aList1))
            aList1[nX,1] := .F.
        endif
    next

    oList1:SetArray(aList1)
    oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),;
                                     aList1[oList1:nAt,2],;
                                     aList1[oList1:nAt,3],;
                                     aList1[oList1:nAt,4]}}
    oList1:Refresh()

    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
                                     aList2[oList2:nAt,2],;
                                     aList2[oList2:nAt,3],;
                                     aList2[oList2:nAt,4],;
                                     aList2[oList2:nAt,5]}}
    oList2:Refresh()

Return

Static Function buscaProd(nLinha)

    Local cQuery       :=    ""
    Local nX         
    Local cValid       :=    ""
    Local cBarra       

    cQuery := " "
    cQuery += " SELECT BM_XMODELO,B1_COD,B1_DESC,B2_QATU,B1_PRV1,BM_XMODELO,B1_LOCPAD,B6_SALDO,B6_PRUNIT "
    cQuery += " FROM " + RetSQLName("SB6") + " SB6 "
    cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON B6_FILIAL='"+xFilial("SB6")+"' AND B6_PRODUTO = B1_COD "
    cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL='"+xFilial("SBM")+"' AND BM_GRUPO = B1_GRUPO "
    cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON B2_FILIAL=B6_FILIAL AND B2_COD = B1_COD "
    cQuery += " WHERE B6_CLIFOR = '" + aList2[nLinha,6] + "' AND B6_TIPO = 'E' AND B6_SALDO > '0' "
    cQuery += " AND B6_PODER3 = 'R' AND B2_QATU >= '50' " 
    cQuery += " ORDER BY B1_COD " 

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    aList3 := {}

    While !EOF()
        if Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(TRB->B1_COD)}) == 0
            Aadd(aList3, { .T., AllTrim(TRB->B1_COD), AllTrim(TRB->B1_DESC), TRB->B6_SALDO, TRB->B2_QATU, TRB->B6_PRUNIT, TRB->BM_XMODELO,TRB->B1_LOCPAD})
            cValid := cBarra + TRB->B1_COD
            cBarra := "','"
        endif
        DBSKIP()
    End

        
    If len(aList3) > 0
        cMarca := '2'
    EndIf

    if aList2[nLinha,1] == .T.
        aList2[nLinha,1] := .F.
    else
        aList2[nLinha,1] := .T.
    endif

    for nX := 1 to len(aList2)
        if nX == nLinha
            nX++
        endif
        if !(nX > len(aList2))
            aList2[nX,1] := .F.
        endif
    Next

    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
                                     aList2[oList2:nAt,2],;
                                     aList2[oList2:nAt,3],;
                                     aList2[oList2:nAt,4],;
                                     aList2[oList2:nAt,5]}}
    oList2:Refresh()

    aList3B := aList3

    oList3:SetArray(aList3)
    oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),;
                                      aList3[oList3:nAt,2],;
                                      aList3[oList3:nAt,3],;
                                      aList3[oList3:nAt,4],;
                                      aList3[oList3:nAt,5],;
                                      aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()
    qtdNotas()

Return 

Static Function selecProd(nLinha)
    
    Local nX
    Local nPos
    Local nColPos := oList3:nColpos
    Local cBkpCol := aList3[nLinha,4]

    if nColPos == 4
        leditcell(aList3,oList3,'@E 9,999',4)
        if !(aList3[nLinha,4] == cBkpCol)
            if aList3[nLinha,4] > aList3[nLinha,5]
                aList3[nLinha,4] := aList3[nLinha,5]
            endif
            
            aList3[nLinha,1] := .T.
            
            for nX := 1 to len(aList3B)
                if AScan(aList3B[nX], aList3[nLinha,2]) > 0
                    nPos := AScan(aList3B[nX], aList3[nLinha,2])
                    aList3B[nX] := aList3[nLinha]
                endif
            next
        endif
    else
        if aList3[nLinha,1] == .T.
            aList3[nLinha,1] := .F.
            for nX := 1 to len(aList3B)
                if AScan(aList3B[nX], aList3[nLinha,2]) > 0
                    nPos := AScan(aList3B[nX], aList3[nLinha,2])
                    aList3B[nX] := aList3[nLinha]
                endif
            next
        else
            aList3[nLinha,1] := .T.
            for nX := 1 to len(aList3B)
                if AScan(aList3B[nX], aList3[nLinha,2]) > 0
                    nPos := AScan(aList3B[nX], aList3[nLinha,2])
                    aList3B[nX] := aList3[nLinha]
                endif
            next
        endif
    endif

    oList3:SetArray(aList3)
    oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
                                     aList3[oList3:nAt,2],;
                                     aList3[oList3:nAt,3],;
                                     aList3[oList3:nAt,4],;
                                     aList3[oList3:nAt,5],;
                                     aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()
    qtdNotas()

Return


Static Function marcaTodos()
    
    Local nX

    if cMarca == '1'
        for nX := 1 to len(aList3)
            aList3[nX,1] := .T.
            nPos := Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aList3[nX,02])})
            If nPos > 0
                aList3B[nPos,01] := .t.
            EndIf 
            /*for nY := 1 to len(aList3B)
                if AScan(aList3B[nY], aList3[nX,2]) > 0
                    nPos := AScan(aList3B[nY], aList3[nX,2])
                    aList3B[nY] := aList3[nX]
                endif
            next*/
        next
        cMarca := '2'
    else
        for nX := 1 to len(aList3)
            aList3[nX,1] := .F.
            
            nPos := Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aList3[nX,02])})
            If nPos > 0
                aList3B[nPos,01] := .f.
            EndIf 
            /*for nY := 1 to len(aList3B)
                if AScan(aList3B[nY], aList3[nX,2]) > 0
                    nPos := AScan(aList3B[nY], aList3[nX,2])
                    aList3B[nY] := aList3[nX]
                endif
            next*/
        next
        cMarca := '1'
    endif

    oList3:SetArray(aList3)
    oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
                                     aList3[oList3:nAt,2],;
                                     aList3[oList3:nAt,3],;
                                     aList3[oList3:nAt,4],;
                                     aList3[oList3:nAt,5],;
                                     aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()
    qtdNotas()

Return 

Static Function filtraLista()
    
    Local nX

    aList3 := {}

    if cCombo1 == 'Todos'
        aList3 := aList3B
    elseif cCombo1 == 'Selecionados'
        for nX := 1 to len(aList3B)
            if aList3B[nX,1]
                Aadd(aList3, aList3B[nX])
            endif
        next
    elseif cCombo1 == 'Nao Selecionados'
        for nX := 1 to len(aList3B)
            if !aList3B[nX,1]
                Aadd(aList3, aList3B[nX])
            endif
        next
    else
        for nX := 1 to len(aList3B)
            if aList3B[nX,7] == cCombo1
                Aadd(aList3, aList3B[nX])    
            endif
        next
    endif

    oList3:SetArray(aList3)
    oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
                                     aList3[oList3:nAt,2],;
                                     aList3[oList3:nAt,3],;
                                     aList3[oList3:nAt,4],;
                                     aList3[oList3:nAt,5],;
                                     aList3[oList3:nAt,6]}}
    oList3:Refresh()

    qtdTot()
    qtdNotas()

Return 

Static Function geraPV(aRet)

    Local aArea     :=    GetArea()
    Local aCabec    :=    {}
    Local aItens    :=    {}
    Local aLinha    :=    {}
    Local cDoc      :=    GetSxeNum("SC5", "C5_NUM")
    Local nX        :=    0
    Local cItem     :=    '01'
    Local cPathL    :=    'C:\00'

    Dbselectarea("SA1")
    DbSetOrder(1)
    Dbseek(xFilial("SA1")+aRet[2,6]+aRet[2,7])

    aadd(aCabec, { "C5_NUM"     ,cDoc       ,Nil })
    aadd(aCabec, { "C5_TIPO"    ,"N"        ,Nil })
    aadd(aCabec, { "C5_CLIENTE" ,aRet[2,6]  ,Nil })
    aadd(aCabec, { "C5_LOJACLI" ,aRet[2,7]  ,Nil })
    aadd(aCabec, { "C5_LOJAENT" ,aRet[2,7]  ,Nil })
    aadd(aCabec, { "C5_EMISSAO" ,dDatabase  ,Nil }) // Data de emissao
    aadd(aCabec, { "C5_TIPOCLI" ,aRet[2,8]  ,Nil }) // Tipo de cliente
    aadd(aCabec, { "C5_TIPOPV"  ,'1'        ,Nil }) //
    aadd(aCabec, { "C5_MOEDA"   ,1          ,Nil }) // Moeda
    aadd(aCabec, { "C5_CONDPAG" ,'001'      ,Nil })
    aadd(aCabec, { "C5_NATUREZ" ,"11010007" ,Nil }) //Perguntar para Michelle
    aadd(aCabec, { "C5_VEND1"   ,aRet[2,2]  ,Nil }) //Perguntar para Michelle

    FOR nX := 3 to len(aRet)
        aLinha := {}
        DbSelectArea("SB1")
        DbSetOrder(1)
        DbSeek(xFilial("SB1")+aRet[nX,2])
        //strzero(nX,2)
        aadd(aLinha,{ "C6_ITEM"    ,cItem      ,Nil })
        aadd(aLinha,{ "C6_PRODUTO" ,aRet[nX,2] ,Nil })
        aadd(aLinha,{ "C6_QTDVEN"  ,aRet[nX,4] ,Nil })
        aadd(aLinha,{ "C6_PRCVEN"  ,aRet[nX,6] ,Nil })
        aadd(aLinha,{ "C6_PRUNIT"  ,aRet[nX,6] ,Nil })
        aadd(aLinha,{ "C6_TES"     ,'502'      ,Nil }) //Perguntar para Michelle
        aadd(aLinha,{ "C6_LOCAL"   ,aRet[nX,8] ,Nil })
        
        cItem := Soma1(cItem)
        aadd(aItens, aLinha)

    NEXT

    lMsErroAuto := .F.

    Begin Transaction 

    MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)
    
    If !lMsErroAuto
        ConOut("Inclu�do com sucesso! " + cDoc)
        ConfirmSX8()
        lRet := .T.
    Else
        MostraErro(cPathL,"_erro.txt")
        ConOut("Erro na inclus�o!")
        lRet := .F.
    EndIf

    End Transaction 

    RestAreA(aArea)

Return


Static Function geraPDEeDE(aRet)
 
    Local nX
    Local aCabec      := {}
    Local aItens      := {}
    Local aLinha      := {}
    Local lMsErroAuto := .F.
    Local cDoc        := GetSxeNum("SF1","F1_DOC")

    // [2]aList2 [1].F. [2]TRB->A3_COD [3]AllTrim(TRB->A3_NOME) [4]AllTrim(TRB->Z30_MALA) [5]AllTrim(TRB->Z30_REGIAO) [6]TRB->A1_COD [7]TRB->A1_LOJA [8]TRB->A1_TIPO
    // [3+]aList3 [1].F. [2]AllTrim(TRB->B1_COD) [3]AllTrim(TRB->B1_DESC) [4]0001 [5]TRB->B2_QATU [6]TRB->B1_PRV1 [7]TRB->BM_XMODELO [8]TRB->B1_LOCPAD

    aAdd( aCabec, {'F1_TIPO'    ,'N'       ,NIL} )
    aAdd( aCabec, {'F1_FORMUL'  ,'N'       ,NIL} )
    aAdd( aCabec, {'F1_DOC'     ,cDoc      ,NIL} )
    aAdd( aCabec, {"F1_SERIE"   ,"01"      ,NIL} ) //Perguntar para Michelle
    aAdd( aCabec, {"F1_EMISSAO" ,dDataBase ,NIL} )
    aAdd( aCabec, {'F1_FORNECE' ,aRet[2,6] ,NIL} )
    aAdd( aCabec, {'F1_LOJA'    ,aRet[2,7] ,NIL} )
    aAdd( aCabec, {"F1_ESPECIE" ,"NF"      ,NIL} )
    aAdd( aCabec, {"F1_COND"    ,'001'     ,NIL} ) //Perguntar para Michelle
    aAdd( aCabec, {"F1_STATUS"  ,''        ,NIL} )
    
    For nX := 3 to Len(aRet)
        
        aItens := {}

        aAdd( aItens ,{'D1_ITEM'  ,StrZero(nX-2,4)       ,NIL} )
        aAdd( aItens ,{'D1_COD'   ,aRet[nX,2]            ,NIL} )
        aAdd( aItens ,{"D1_QUANT" ,aRet[nX,4]            ,Nil} )
        aAdd( aItens ,{"D1_VUNIT" ,aRet[nX,6]            ,Nil} )
        aAdd( aItens ,{"D1_TOTAL" ,aRet[nX,4]*aRet[nX,6] ,Nil} ) 
        aAdd( aItens ,{"D1_TES"   ,''                    ,NIL} ) //Perguntar para Michelle
        
        aAdd( aLinha ,aItens )
        
    NEXT nX

    lMsErroAuto := .F.

    MSExecAuto( {|x,y,z,a,b| MATA140(x,y,z,a,b)} ,aCabec ,aLinha ,3 , , )
    
    If lMsErroAuto
        mostraerro()
    Else
        MsgInfo("Pr� - Documento de Entrada conclu�do com sucesso!", "�xito!")
    EndIf

    lMsErroAuto := .F.

    MSExecAuto( {|x,y,z,a| MATA103(x,y,z,a)} ,aCabec ,aLinha ,3 , .T. )

    If lMsErroAuto
        mostraerro()
    Else
        MsgInfo("Documento de Entrada conclu�do com sucesso!", "�xito!")
    EndIf
  
Return

Static Function qtdTot()
    
    Local nX

    nQtdTot := 0

    for nX := 1 to len(aList3B)
        if aList3B[nX,1]
            nQtdTot += aList3B[nX,4]
        endif
    next

    oSay2:SetText(nQtdTot)
    oSay2:CtrlRefresh()
    
Return 


Static Function qtdNotas()

    Local nAux := len(aList3B) / 487
    Local nX
    Local nQtdProd := 0

    aAux := aList3B

    for nX := 1 to len(aList3B)
        if aList3B[nX,7] == if(cCombo1 == "Todos" .OR. cCombo1 == "Selecionados" .OR. cCombo1 == "Nao Selecionados", ".F.", cCombo1) .AND. aList3B[nX,1]
            nQtdProd++
        elseif (cCombo1 == "Selecionados" .OR. cCombo1 == "Todos") .AND. aList3B[nX,1]
            nQtdProd++
        endif
    next

    nQtdNotas := Round(nQtdProd / 487, 0)

    if nQtdNotas < nAux
        nQtdNotas++
    endif

    oSay4:SetText(nQtdNotas)
    oSay4:CtrlRefresh()

Return 