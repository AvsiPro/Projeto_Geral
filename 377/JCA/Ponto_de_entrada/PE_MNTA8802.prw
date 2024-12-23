#INCLUDE "PROTHEUS.CH"
/*
    PE para controle de quais usuários podem reabrir uma OS por grupo
    
    Alexandre 01/09/24    
    
*/
User Function MNTA8802()
 
    Local lRet     := .F.
    Local cTipLib  := SuperGetMV("TI_TIPLIB",.F.,"2/3")
    Local aGrupo   := gruplib(RetCodUsr())
    Local nCont    

    For nCont := 1 to len(aGrupo)
        If aGrupo[nCont] $ cTipLib
            lRet := .T.
            exit
        EndIf 
    Next nCont 

    If !lRet 
        MsgAlert("Reabertura de O.S. nao permitida para este usuario","MNTA8802")
    EndIf 
   
 
Return lRet

/*/{Protheus.doc} gruplib
    (long_description)
    @type  Static Function
    @author user
    @since 17/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gruplib(cCodUsr)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT ZPT_ROTINA"
cQuery += " FROM "+RetSQLName("ZPT")
cQuery += " WHERE ZPT_FILIAL='"+xFilial("ZPT")+"'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " AND ZPT_USER='"+cCodUsr+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("TIINCP01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aRet,TRB->ZPT_ROTINA)
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
