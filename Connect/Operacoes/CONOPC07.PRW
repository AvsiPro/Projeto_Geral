#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"


//Colocar em outras acoes de contrato na area de trabalho e colocar consulta que só traz itens dentro daquele contrato
User Function CONOPC07()

    Local aArea  :=	GetArea()
    Local cQuery :=	""
    Local cItem  :=	""
    Local lOK    :=	.T.
    Local lAA3   :=	.F.
    Local lAA4   :=	.F.
    Local lSN1   :=	.F.
    Local nRecno := 0
    Local aPergs := {}

    MsgInfo("Essa rotina tem como objetivo retirar um ativo do contrato sem gerar nota!", "Info!")

    BEGIN TRANSACTION

    aAdd( aPergs ,{1,"Item do Contrato : ", Space(TamSx3("AAN_ITEM")[1]),"@!",'.T.',"AANX",'.T.',40,.T.})

    If !ParamBox(aPergs ,"Parametros ")
        MsgInfo("Abortado!", "Fim!")
        Return
    EndIf

    //Verifica se existe AA3
    DbSelectArea("AA3")
    DbSetOrder(1)
    if DBSEEK(xFilial("AA3") + AAM->AAM_CODCLI + AAM->AAM_LOJA + AAN->AAN_CODPRO + Posicione("SN1", 2, xFilial("SN1") + AvKey(AAN->AAN_XCBASE, "N1_CBASE"), "N1_XNUMSER") + xFilial("AA3"))
        lAA3 := .T.
    endif

    //Verifica se existe AA4
    DbSelectArea("AA4")
    DbSetOrder(2)
    if DBSEEK(xFilial("AA4") + AAM->AAM_CODCLI + AAM->AAM_LOJA + AAN->AAN_CODPRO + AAN->AAN_XCBASE)
        lAA4 := .T.
    endif

    //Verifica se existe SN1
    DbSelectArea("SN1")
    DbSetOrder(2)
    if DBSEEK(xFilial("SN1")+AvKey(AAN->AAN_XCBASE, "N1_CBASE"))
        lSN1 := .T.
    endif

    //Deleta AA3
    if lAA3
        RecLock("AA3", .F.)
            DBDelete()
        AA3->(MsUnlock())
    endif

    //Deleta AA4
    if lAA4
        RecLock("AA4", .F.)
            DBDelete()
        AA4->(MsUnlock())
    endif

    //Limpa campos na SN1
    if lSN1
        RecLock("SN1", .F.)
            SN1->N1_XCLIENT := ""
            SN1->N1_XLOJA   := ""
        SN1->(MsUnlock())
    endif

    RecLock("AAN", .F.)
        DbDelete()
    AAN->(MsUnlock())

    //Query para verificar se AAN esta vazia
    cQuery := " SELECT AAN_CONTRT FROM " + RetSQLName("AAN") + " " 
    cQuery += " WHERE AAN_CONTRT = '" + AAM->AAM_CONTRT + "' "
    cQuery += " AND D_E_L_E_T_ = ' ' "
    cQuery += " AND AAN_FILIAL = '" + xFilial("AAN") + "' "

    If Select("TRB") > 0
        dbSelectArea("TRB")
        dbCloseArea()
    EndIf
    
    MemoWrite("MSD2520.SQL",cQuery)
    cQuery:= ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

    //Se entrar no loop, significa que contrato não esta vazio
    DbSelectArea("TRB")
    while TRB->(!EOF())
        lOK := .F.
        TRB->(DBSKIP())
    end

    //Entra caso seja necessario colocar item "CONTRATO NOVO"
    if lOK
        //Query verifica se item "CONTRATO NOVO" ja esta vinculado porem deletado, e traz RECNO
        cQuery := " SELECT R_E_C_N_O_ AS ALIASREC, AAN_CODPRO, AAN_ITEM FROM " + RetSQLName("AAN") + " WHERE AAN_CONTRT = '" + AAM->AAM_CONTRT + "'"

        If Select("TRB") > 0
            dbSelectArea("TRB")
            dbCloseArea()
        EndIf
        
        MemoWrite("MSD2520.SQL",cQuery)
        cQuery:= ChangeQuery(cQuery)
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
        DbSelectArea("TRB")   

        cItem := TRB->AAN_ITEM

        //Grava Recno e certifica que "CONTRATO NOVO" esta vinculado
        While !EOF()
            If AllTrim(TRB->AAN_CODPRO) == "CONTRATO"
                nRecno := TRB->ALIASREC
                lOK := .F.
            EndIf

            if val(cItem) < val(TRB->AAN_ITEM)
                cItem := TRB->AAN_ITEM
            endif

            DBSKIP()
        End

        // Se .T. cria item "CONTRATO NOVO", se .F. faz Recall no Recno 
        if lOK
            DbSelectArea("AAN")
            RecLock("AAN", .T.)
                AAN->AAN_FILIAL := xFilial("AAN")
                AAN->AAN_CONTRT := AAM->AAM_CONTRT
                AAN->AAN_ITEM   := Soma1(cItem)
                AAN->AAN_CODPRO := "CONTRATO"
                AAN->AAN_QUANT  := 1
                AAN->AAN_VLRUNI := 0.01                                                                                                            
                AAN->AAN_VALOR  := 0.01                                                                                                            
                AAN->AAN_INICOB := dDataBase                                                                                                                       
                AAN->AAN_FIMCOB := YEARSUM(DDATABASE,1)                                                                                                            
                AAN->AAN_CONPAG := "001"                                                                                                            
            AAN->(MsUnlock())
        else
            DbSelectArea("AAN")
            DBGOTO( nRecno )
            RecLock("AAN", .F.)
                DBRecall()
            AAN->(MsUnlock())
        EndIf

    endif

    END TRANSACTION

    RestArea(aArea)

    MsgInfo("Rotina Finalizada!", "Fim!")

Return
