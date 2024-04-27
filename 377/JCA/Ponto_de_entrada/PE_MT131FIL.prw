#Include 'Protheus.ch'
/*
    Nao incluir itens com bloqueio de marca na filial na solicitação de compras
*/
User Function MT131FIL()

Local cItmNeg    := BuscaIt(cfilant)
Local cFiltroSC1 := "!C1_FILIAL+C1_PRODUTO $ '"+cItmNeg+"'"


Return cFiltroSC1




/*/{Protheus.doc} BuscaIt
    (long_description)
    @type  Static Function
    @author user
    @since 15/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaIt(cfilant)

Local aArea := GetArea()
//Local aRet  := {}
Local cQuery 
Local cRet  := ""
Local cBarra:= ""

cQuery := " SELECT ZPN_FILIAL,ZPN_PRODUT"
cQuery += " FROM "+RetSQLName("ZPN")
cQuery += " WHERE ZPN_FILIAL='"+cFilant+"' AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("MT131FIL.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
    cRet += cBarra + TRB->ZPN_FILIAL+TRB->ZPN_PRODUT
    cBarra := "/"
    Dbskip()
ENDDO 

RestArea(aArea)

Return(cRet)
