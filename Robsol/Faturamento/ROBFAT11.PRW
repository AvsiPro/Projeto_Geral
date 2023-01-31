#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"    
#INCLUDE "FONT.CH"

User Function ROBFAT11()
    
    Local nOpc    := 0
    Local nX      := 0
    Local nQtdLib := 0
    Local aAux    := {}

    Private aList := {}

    Private oYe   	:= LoadBitmap(GetResources(),'br_verde') //Liberado e possui saldo maior que quantidade liberada
    Private oMe   	:= LoadBitmap(GetResources(),'br_amarelo') //Liberado e possui saldo igual a quantidade liberada
    Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho') //Não Liberado

    SetPrvt("oDlg1", "oGrp1", "oGrp2", "oGrp3", "oSay1", "oSay2", "oSay3", "oList")

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbSeek(xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI))

    DbSelectArea("SA3")
    SA3->(DbSetOrder(1))
    SA3->(DbSeek(xFilial("SA3") + SC5->C5_VEND1))

    Busca()

    oDlg1      := MSDialog():New( 092,232,770/*Y*/,1672/*X*/,"Liberacao de Pedido",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 002,004,336/*Y*/,710/*X*/,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

        oGrp2      := TGroup():New( 008,008,072,700,"Dados do Pedido",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            oSay1      := TSay():New( 024,012,{||SC5->C5_NUM + " - " + Transform(val(SA1->A1_CGC), "@E 99,999,999/9999-99") + " (" + AllTrim(SA1->A1_NOME) + ") "},oGrp2,,/*Fonte*/,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,500,008)
            oSay3      := TSay():New( 040,012,{||SA3->A3_COD + " - " + SA3->A3_NOME},oGrp2,,/*Fonte*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,500,008)
        
        oGrp3      := TGroup():New( 076,008,335,710,"Itens do Pedido",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            oList 	   := TCBrowse():New(084/*Y*/,010/*X*/,690/*X*/,245/*Y*/,, {"", "Item", "Cod Produto", "Descricao", "QTD Vend", "QTD Liberada", "Saldo"},/*Tamanho das colunas*/,;
                                    oGrp3,,,,{|| }/*Posiciona na Linha*/,{|| editcol(oList:nAt)}/*Duplo Clique*/,, ,,,  ,,.F.,,.T.,,.F.,,,)
            oList:SetArray(aList)
            oList:bLine := {||{IF(aList[oList:nAt, 01] == "1",oYe,IF(aList[oList:nAt,01] == "2",oMe,oNo)),;
                                aList[oList:nAt, 02],;
                                aList[oList:nAt, 03],;
                                aList[oList:nAt, 04],;
                                aList[oList:nAt, 05],;
                                aList[oList:nAt, 06],;
                                aList[oList:nAt, 07]}}

        oBtn3      := TButton():New( 024/*Y*/,600/*X*/,"Confirmar",oDlg1,{|| oDlg1:end(nOpc:=1)},030,012,,,,.T.,,"",,,,.F. )
        oBtn4      := TButton():New( 024/*Y*/,635/*X*/,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},030,012,,,,.T.,,"",,,,.F. )
                                    
    oDlg1:Activate(,,,.T.)

    if nOpc == 1
        
        for nX := 1 to len(aList)
            if aList[nX,01] $ "1/2"
                Aadd(aAux, aList[nX])
            endif
        next

        for nX := 1 to len(aAux)
            dbSelectArea("SC9")
            if !dbSeek(xFilial("SC9")+SC5->C5_NUM+aAux[nX,02])
                nQtdLib := aAux[nX,06]
                //nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
                nQtdLib := MaLibDoFat(aAux[nX,08],nQtdLib,.F.,.F.,.F.,.F.,.F.,.F.)
            Endif
        next

        MsgInfo("Rotina Finalizada!", "Fim!")

    endif

Return 

Static Function Busca()
    
    Local cQuery := ""

    cQuery := " "
    cQuery += " SELECT C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,B2_QATU,SC6.R_E_C_N_O_ AS ALIASREC   " 
    cQuery += " FROM   " + RetSQLName("SC6") + " SC6   " 
    cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON C6_PRODUTO = B2_COD   " 
    cQuery += "        AND C6_LOCAL = B2_LOCAL   " 
    cQuery += "        AND C6_FILIAL = B2_FILIAL   " 
    cQuery += "        AND SB2.D_E_L_E_T_ = ' '   " 
    cQuery += " WHERE  C6_NUM = '" + SC5->C5_NUM + "'   " 
    cQuery += "        AND C6_FILIAL = '" + SC5->C5_FILIAL + "' " 
    cQuery += " ORDER BY  C6_ITEM   " 

    If Select("TRB") > 0
        DbSelectArea("TRB")
        DbCloseArea()
    EndIf

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

    while !EOF()
        Aadd(aList, {IF(TRB->C6_QTDVEN < TRB->B2_QATU,"1",IF(TRB->C6_QTDVEN == TRB->B2_QATU,"2", "3")),;
                        TRB->C6_ITEM,;
                        AllTrim(TRB->C6_PRODUTO),;
                        AllTrim(TRB->C6_DESCRI),;
                        TRB->C6_QTDVEN,;
                        If(TRB->C6_QTDVEN<TRB->B2_QATU,TRB->C6_QTDVEN,0),;
                        TRB->B2_QATU,;
                        TRB->ALIASREC})
        dbskip()
    end

Return 

Static Function editcol(nLin)

    Local aArea     :=  GetArea()
    Local nPosic    :=  oList:nColpos
    Local nBkpL6    :=  aList[nLin,06]

    If nPosic == 6
        lEditCell( aList, oList, "@!", nPosic)
        IF aList[nLin,06] > aList[nLin,05]
            MsgAlert("Quantidade atendida não pode ser maior que quantidade vendida")
            aList[nLin,06] := nBkpL6
        EndIf
        //aList[nLin,06] := StrZero(val(aList[nLin,06]), 3)

        if aList[nLin,06] == 0
            aList[nLin,01] := "3"
        elseif aList[nLin,06] > aList[nLin,07]
            MsgAlert("Quantidade maior que o saldo disponível")
            aList[nLin,06] := aList[nLin,07] //StrZero(aList[nLin,07], 3)
        endif

        aList[nLin,01] := IF(aList[nLin,06] < aList[nLin,07] .AND. aList[nLin,06] != 0,"1",IF(aList[nLin,06] == aList[nLin,07],"2", "3"))

    elseif aList[nLin,01] $ "1/2"
        aList[nLin,01] := "3"
    else
        aList[nLin,01] := IF(aList[nLin,06] < aList[nLin,07],"1",IF(aList[nLin,06] == aList[nLin,07],"2", "3"))
    EndIf

    oList:refresh()
    oDlg1:refresh()

    RestArea(aArea)

Return
