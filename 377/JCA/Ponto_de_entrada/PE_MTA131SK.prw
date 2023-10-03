#INCLUDE 'PROTHEUS.CH'

User Function MTA131SK()

Local lReturn := .T.

nQtdPai := cntfilho(SC1->C1_PRODUTO)

If nQtdPai > 0
    Reclock("SC1",.F.)
    SC1->C1_COTACAO := 'XXX'
    SC1->(Msunlock())
    lReturn := .F.
EndIf 

Return lReturn


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 02/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function cntfilho(cProd)

Local aArea := GetArea()
Local nQtd  := 0

cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("SB1")
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += " AND D_E_L_E_T_=' ' AND B1_XCODPAI='"+cProd+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

nQtd := TRB->QTD

RestArea(aArea)

Return(nQtd)
