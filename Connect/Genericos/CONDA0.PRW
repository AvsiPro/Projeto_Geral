#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

User Function CONDA0()
    
    Local cQuery  := ""
    Local aAux    := {}
    Local nX      := 0
    Local cCodTab := ""
    Local cItem   := ""

    cQuery := " "
    cQuery += " SELECT AAM_CODCLI,AAM_XNOMCL,Z07_CODPRO,AAM_CONTRT,COUNT(*)   " 
    cQuery += " FROM   " + RetSQLName("AAM") + " AAM   " 
    cQuery += " INNER JOIN " + RetSQLName("AAN") + " AAN ON AAM_FILIAL = AAN_FILIAL   " 
    cQuery += "        AND AAM_CONTRT = AAN_CONTRT   " 
    cQuery += "        AND AAN.D_E_L_E_T_=' '   " 
    cQuery += "        AND AAN_XCBASE<>' '   " 
    cQuery += " INNER JOIN " + RetSQLName("Z07") + " Z07 ON Z07_CHAPA = AAN_XCBASE   " 
    cQuery += "        AND Z07_CLIENT = AAM_CODCLI   " 
    cQuery += "        AND Z07_LOJA = AAM_LOJA   " 
    cQuery += "        AND Z07.D_E_L_E_T_=' '   " 
    cQuery += " WHERE  AAM.D_E_L_E_T_=' ' "
    cQuery += " GROUP BY AAM_CODCLI,AAM_XNOMCL,Z07_CODPRO,AAM_CONTRT   " 

    If Select("TRB") > 0
        DbSelectArea("TRB")
        DbCloseArea()
    EndIf

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

    while !EOF()
        Aadd(aAux, {TRB->AAM_CODCLI,TRB->AAM_XNOMCL,TRB->Z07_CODPRO,TRB->AAM_CONTRT})
        dbskip()
    end

    DbSelectArea("DA0")
    DA0->(DbSetOrder(1))

    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))

    DbSelectArea("AAM")
    AAM->(DbSetOrder(1))

    BEGIN TRANSACTION

    for nX := 1 to len(aAux)

        AAM->(DbSeek(xFilial("AAM") + aAux[nX,04]))

        if Empty(AAM->AAM_XCODTA) .OR. AAM->AAM_XCODTA == '001' 
            
            cCodTab := GetSXENum("DA0", "DA0_CODTAB")

            while DA0->(DbSeek(xFilial("DA0") + cCodtab))
                cCodTab := Soma1(cCodTab)
            end

            RecLock("DA0", .T.)
                DA0->DA0_CODTAB := cCodTab
                DA0->DA0_DESCRI := AvKey("TAB " + aAux[nX,02], "DA0_DESCRI")
                DA0->DA0_DATDE  := dDataBase
                DA0->DA0_HORADE := SubStr(cValToChar(Time()), 1,5)
                DA0->DA0_TPHORA := "1"
                DA0->DA0_ATIVO  := "1"
                DA0->DA0_FILIAL := xFilial("DA0")
            MsUnlock()

            ConfirmSX8()

            RecLock("DA1", .T.)
                DA1->DA1_FILIAL := xFilial("DA1")
                DA1->DA1_ITEM   := "0001"
                DA1->DA1_CODTAB := cCodTab
                DA1->DA1_CODPRO := aAux[nX,03]
                DA1->DA1_ATIVO  := "1"
                DA1->DA1_MOEDA  := 1
                DA1->DA1_DATVIG := dDataBase
            MsUnlock()

            RecLock("AAM", .F.)
                AAM->AAM_XCODTA := cCodTab
            MsUnlock()

        else
            if DA0->(DbSeek(xFilial("DA0") + AAM->AAM_XCODTA))

                cCodTab := DA0->DA0_CODTAB
                cItem := "0001"
                
                DA1->(DbSetOrder(1))
                if !(DA1->(DbSeek(xFilial("DA1") + cCodTab + aAux[nX,03])))

                    DA1->(DbSetOrder(3))
                    while DA1->(DbSeek(xFilial("DA1") + cCodTab + cItem))
                        cItem := Soma1(cItem)
                    end

                    RecLock("DA1", .T.)
                        DA1->DA1_FILIAL := xFilial("DA1")
                        DA1->DA1_ITEM   := cItem
                        DA1->DA1_CODTAB := cCodTab
                        DA1->DA1_CODPRO := aAux[nX,03]
                        DA1->DA1_ATIVO  := "1"
                        DA1->DA1_MOEDA  := 1
                        DA1->DA1_DATVIG := dDataBase
                    MsUnlock()
                endif
            else
                
                cCodTab := GetSXENum("DA0", "DA0_CODTAB")

                while DA0->(DbSeek(xFilial("DA0") + cCodtab))
                    cCodTab := Soma1(cCodTab)
                end

                RecLock("DA0", .T.)
                    DA0->DA0_CODTAB := cCodTab
                    DA0->DA0_DESCRI := AvKey("TAB " + aAux[nX,02], "DA0_DESCRI")
                    DA0->DA0_DATDE  := dDataBase
                    DA0->DA0_HORADE := SubStr(cValToChar(Time()), 1,5)
                    DA0->DA0_TPHORA := "1"
                    DA0->DA0_ATIVO  := "1"
                    DA0->DA0_FILIAL := xFilial("DA0")
                MsUnlock()

                ConfirmSX8()

                RecLock("DA1", .T.)
                    DA1->DA1_FILIAL := xFilial("DA1")
                    DA1->DA1_ITEM   := "0001"
                    DA1->DA1_CODTAB := cCodTab
                    DA1->DA1_CODPRO := aAux[nX,03]
                    DA1->DA1_ATIVO  := "1"
                    DA1->DA1_MOEDA  := 1
                    DA1->DA1_DATVIG := dDataBase
                MsUnlock()

                RecLock("AAM", .F.)
                    AAM->AAM_XCODTA := cCodTab
                MsUnlock()

            EndIf


        endif

    next

    END TRANSACTION

    MsgAlert("Tabelas Atualizadas!", "Fim!")

Return 
