//AB2_TIPO   '5'
//AB2_CLASSI '005'
//AB2_CODPRB '000003'

User Function AT450OKA()

    Local aArea   := GetArea()

    DbSelectArea("AB2")
    DbSetOrder(1)
    if DBSEEK(xFilial("AB2")+SubStr(AB7->AB7_NRCHAM,1,8)+"01"+AB7->AB7_CODPRO+AB7->AB7_NUMSER)
        if AB7->AB7_TIPO == "5" .AND. AB2->AB2_CODPRB == "000003" .AND. AB2->AB2_CLASSI == "005" .AND. AB2->AB2_TIPO == "3"

            RecLock("AA3", .F.)
                DBDELETE()
            MsUnlock()

            DbSelectArea("SN1")
            DbSetOrder(2)
            if DBSEEK(xFilial("SN1")+AB7->AB7_NUMSER)
                RecLock("SN1", .F.)
                    SN1->N1_XCLIENT := ""
                    SN1->N1_XLOJA   := ""
                MsUnlock()
            ENDIF
            DBCLOSEAREA()

            DbSelectArea("AAN")
            DbSetOrder(3)
            if DBSEEK(xFilial("AAN")+AB7->AB7_NUMSER)
                RecLock("AAN", .F.)
                    DBDELETE()
                MsUnlock()
            endif
            DBCLOSEAREA()

        endif
    endif
    
    RestArea(aArea)

Return 
