#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

User Function ROBFAT07()

    Local nLarg
    Local nAlt
    Local aItens := {'Todos','CV','DI','EU','FX','MP','RO','SS','TS','TR','FL'}
    Local nX
    Local aRet   := {}

    Private oDlg1,oGrp1,oBtn1,oBtn2,oBtn3,oList1,oList2,oList3,oComb1
    Private aList1    :=    {}
    Private aList2    :=    {}
    Private aList3    :=    {}
    Private aList3B    :=    {}
    Private cCombo1   :=    ''
    Private oOk       :=    LoadBitmap(GetResources(),'br_verde')
    Private oNo       :=    LoadBitmap(GetResources(),'br_vermelho')
    Private cMarca    :=    '1'

    If Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0103")
    EndIf

    buscaGeren()

    oDlg1      := MSDialog():New( 100,200,700,1500,"",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 005,005,300,645,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
     
    oList1     := TCBrowse():New( 012, 008, 190, 135, , {'', 'Codigo','Gerente','Região'}, {10,25,90,25}, oGrp1, , , , {|| buscaRepre(oList1:nAt)}, , , , , , , , , , .T., , , , .F., .T. )
    oList1:SetArray(aList1)
    oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
                                      aList1[oList1:nAt,2],;
                                      aList1[oList1:nAt,3],;
                                      aList1[oList1:nAt,4]}}
    
    oList2     := TCBrowse():New( 012, 200, 440, 135, , {'','Código','Representante','Malas', 'Regiões'}, /*{10,25,20,20}*/, oGrp1, , , , {|| buscaProd(oList2:nAt)}, , , , , , , , , , .T., , , , .F., .T. )
    oList2:SetArray(aList2)
    oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
                                     aList2[oList2:nAt,2],;
                                     aList2[oList2:nAt,3],;
                                     aList2[oList2:nAt,4],;
                                     aList2[oList2:nAt,5]}}

    oList3     := TCBrowse():New( 150, 008, 500, 145, , {'', 'Cod', 'Desc', 'Qtd', 'Saldo Total', 'Vlr'}, {,,200,,}, oGrp1, , , , /*{|| selecProd(oList3:nAt)}*/, {|| selecProd(oList3:nAt)}, , , , , , , , , .T., , , , .F., .T. )
    oList3:SetArray(aList3)
    oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),;
                                      aList3[oList3:nAt,2],;
                                      aList3[oList3:nAt,3],;
                                      aList3[oList3:nAt,4],;
                                      aList3[oList3:nAt,5]}}

    nLarg := 052*1.5
    nAlt  := 012*1.5
    nLinha:= 128
    oComb1     := TComboBox():New( nLinha+25,510,{|u|IF(PCount()>0,cCombo1:=u,cCombo1)},aItens,nLarg-25,nAlt,oGrp1,,{|| filtraLista()},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    oBtn1      := TButton():New( nLinha+25,564,"Ok",oGrp1,{|| oDlg1:end(nOpc:=1)},nLarg,nAlt,,,,.T.,,"",,,,.F. )
    oBtn1      := TButton():New( nLinha+50,564,"Marca/Desmarca Todos",oGrp1,{|| marcaTodos()},nLarg,nAlt,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( nLinha+75,564,"Ignora Ultimo PV",oGrp1,{|| buscaProd(oList2:nAt,1)},nLarg,nAlt,,,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( nLinha+100,564,"Sair",oGrp1,{|| oDlg1:end(nOpc:=0)},nLarg,nAlt,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

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
    
        Processa({|| geraPV(aRet)})
        
    endif

Return

Static Function buscaGeren()
    
    Local cQuery := ''

    cQuery := " "
    cQuery += " SELECT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO   " 
    cQuery += " FROM   " + RetSQLName("SA3") + " SA3   " 
    cQuery += " LEFT JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_CODVEN = SA3.A3_COD   " 
    cQuery += " WHERE SA3.A3_XFUNCAO != '1'  " 

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
    cQuery += " WHERE  Z30.Z30_CODGER = '"+ cGeren +"' "
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

Static Function buscaProd(nLinha, nIgnora)

    Local cQuery := ""
    Local nX
    Local aMalas := strTokArr(aList2[nLinha,4], '/')
    Local cMalas := ""

    cQuery := " "
    cQuery += " SELECT MAX(C5_EMISSAO) AS ULTIMOPEDIDO FROM " + RetSQLName("SC5") + " SC5 " 
    cQuery += " WHERE C5_TIPO = 'N' AND C5_CLIENTE = '" + aList2[nLinha,6] + "' AND C5_LOJACLI = '" + aList2[nLinha,7] + "' "

    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    cData := TRB->ULTIMOPEDIDO

    if AllTrim(cData) == '' .or. nIgnora == 1

        For nX := 1 To len(aMalas)
        cMalas += "'"
        cMalas += aMalas[nX]
        cMalas += "'"
        cMalas += ","
        Next

        cMalas := SubStr(cMalas, 0, len(cMalas) - 1)

        aList3 := {}

        cQuery := " "
        cQuery += " SELECT DISTINCT SB1.B1_COD, SB1.B1_DESC, SB2.B2_QATU,SB1.B1_PRV1,SBM.BM_XMODELO,SB1.B1_LOCPAD  " 
        cQuery += " FROM " + RetSQLName("SB1") + " SB1  " 
        cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON SB1.B1_GRUPO = SBM.BM_GRUPO  " 
        cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON SB1.B1_COD = SB2.B2_COD   " 
        cQuery += " WHERE SB2.B2_QATU > '50' AND SB2.B2_LOCAL = '101'  " 
        cQuery += " AND SBM.BM_XMODELO IN (" + cMalas + ")  " 
        cQuery += " AND SB1.B1_PRV1 > '0'  " 
        cQuery += " AND SB1.B1_MSBLQL != '1'  " 

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        While !EOF()
                Aadd(aList3, { .F., AllTrim(TRB->B1_COD), AllTrim(TRB->B1_DESC), 0001,TRB->B2_QATU, TRB->B1_PRV1, TRB->BM_XMODELO,SB1->B1_LOCPAD})
            DBSKIP()
        End

        If len(aList3) == 0
            Aadd(aList3, { .F., '', '', '', '', '', '',''})
        EndIf

        if nIgnora != 1
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
        endif
        
    else

        cQuery := " "
        cQuery += " SELECT C5_NUM FROM " + RetSQLName("SC5") + " " 
        cQuery += " WHERE C5_TIPO = 'N' AND C5_CLIENTE = '" + aList2[nLinha,6] + "' " 
        cQuery += " AND C5_LOJACLI = '" + aList2[nLinha,7] + "' " 
        cQuery += " AND C5_EMISSAO = '" + cData + "' " 

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        cNum := TRB->C5_NUM

        cQuery := " "
        cQuery += " SELECT C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_PRCVEN,C6_PRUNIT,C6_TES,C6_LOCAL,SB1.B1_DESC,SB2.B2_QATU,SB1.B1_PRV1,SBM.BM_XMODELO,SB1.B1_LOCPAD FROM " + RetSQLName("SC6") + " " 
        cQUery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.B1_COD = C6_PRODUTO " 
        cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON SB1.B1_COD = SB2.B2_COD " 
        cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON SB1.B1_GRUPO = SBM.BM_GRUPO " 
        cQUery += " WHERE C6_NUM = '" + cNum + "' " 
        cQuery += " AND SB2.B2_QATU > '50' AND SB2.B2_LOCAL = '101' " 

        If Select('TRB') > 0
            dbSelectArea('TRB')
            dbCloseArea()
        EndIf

        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        aList3 := {}

        While !EOF()
                Aadd(aList3, { .T., AllTrim(TRB->C6_PRODUTO), AllTrim(TRB->B1_DESC), 0001,TRB->B2_QATU, TRB->B1_PRV1, TRB->BM_XMODELO,TRB->B1_LOCPAD})
            DBSKIP()
        End
    
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

    endif

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

Return


Static Function marcaTodos()
    
    Local nX
    Local nY

    if cMarca == '1'
        for nX := 1 to len(aList3)
            aList3[nX,1] := .T.
            for nY := 1 to len(aList3B)
                if AScan(aList3B[nY], aList3[nX,2]) > 0
                    nPos := AScan(aList3B[nY], aList3[nX,2])
                    aList3B[nY] := aList3[nX]
                endif
            next
        next
        cMarca := '2'
    else
        for nX := 1 to len(aList3)
            aList3[nX,1] := .F.
            for nY := 1 to len(aList3B)
                if AScan(aList3B[nY], aList3[nX,2]) > 0
                    nPos := AScan(aList3B[nY], aList3[nX,2])
                    aList3B[nY] := aList3[nX]
                endif
            next
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

Return 


Static Function filtraLista()
    
    Local nX

    aList3 := {}

    if cCombo1 == 'Todos'
        aList3 := aList3B
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

    Private lRet        :=    .F.
    Private lMsErroAuto := .F.

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
    aadd(aCabec, { "C5_NATUREZ" ,"11010007" ,Nil })  
    aadd(aCabec, { "C5_VEND1"   ,aRet[2,2]  ,Nil })

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
        aadd(aLinha,{ "C6_TES"     ,'502'      ,Nil })
        aadd(aLinha,{ "C6_LOCAL"   ,aRet[nX,8] ,Nil })
        
        cItem := Soma1(cItem)
        aadd(aItens, aLinha)

    NEXT

    lMsErroAuto := .F.

    Begin Transaction 

    // MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)
    
    If !lMsErroAuto
        ConOut("Incluído com sucesso! " + cDoc)
        ConfirmSX8()
        lRet := .T.
    Else
        MostraErro(cPathL,"_erro.txt")
        ConOut("Erro na inclusão!")
        lRet := .F.
    EndIf

    End Transaction 

    RestAreA(aArea)

Return
