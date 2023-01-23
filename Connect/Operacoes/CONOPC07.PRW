#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"


//Colocar em outras acoes de contrato na area de trabalho e colocar consulta que só traz itens dentro daquele contrato
User Function CONOPC07(cContrt)

    Local aArea  :=	GetArea()
    Local cQuery :=	""
    Local cMaq   :=	""
    Local lOK    :=	.T.
    Local nRecno := 0

    DbSelectArea("AAN")
    DbSetOrder(1)
    If Dbseek(xFilial("AAN")+cContrt+cItCont)
        RecLock("AAN", .F.)
        cMaq := AAN->AAN_XCBASE
        DBDelete()
        AAN->(MsUnlock())
    EndIf 

    DbSelectArea("SN1")
    DbSetOrder(2)
    if DBSEEK(xFilial("SN1")+AvKey(cMaq, "N1_CBASE"))
        RecLock("SN1", .F.)
            SN1->N1_XCLIENT := ""
            SN1->N1_XLOJA   := ""	
        MsUnlock()
    endif

    cQuery := " SELECT AAN_CONTRT FROM " + RetSQLName("AAN") + " WHERE AAN_CONTRT = '" + cContrt + "' "
    cQuery += " AND D_E_L_E_T_ = ' ' "
    cQuery += " AND AAN_FILIAL = '" + xFilial("AAN") + "' "

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf
    
    MemoWrite("MSD2520.SQL",cQuery)
    cQuery:= ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
    DbSelectArea("TRB")   

    while !EOF()
        lOK := .F.
        DBSKIP()
    end

    if lOK
        cQuery := " SELECT R_E_C_N_O_ AS ALIASREC, AAN_CODPRO FROM " + RetSQLName("AAN") + " WHERE AAN_CONTRT = '" + cContrt + "'"

        If Select("TRB") > 0
            dbSelectArea("TRB")
            dbCloseArea()
        EndIf
        
        MemoWrite("MSD2520.SQL",cQuery)
        cQuery:= ChangeQuery(cQuery)
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
        DbSelectArea("TRB")   

        while !EOF()
            if AllTrim(TRB->AAN_CODPRO) == "CONTRATO"
                nRecno := TRB->ALIASREC
            endif
            DBSKIP()
            lOK := .F.
        end

        if lOK
            DbSelectArea("AAN")
            RecLock("AAN", .T.)
                AAN->AAN_FILIAL := xFilial("AAN")
                AAN->AAN_CODPRO := "CONTRATO"
                AAN->AAN_DESCRI := "CONTRATO NOVO"
                AAN->AAN_QTD    := 1
            AAN->(MsUnlock())
        else
            DbSelectArea("AAN")
            DBGOTO( nRecno )
            RecLock("AAN", .F.)
                DBRecall()
            AAN->(MsUnlock())
        EndIf

    endif

    RestArea(aArea)

Return
