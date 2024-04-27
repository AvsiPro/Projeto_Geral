#Include 'Protheus.ch'
/*
    nao permitir incluir produto pai na cotação
*/  
User Function MT161CIT()

Local cFiltro := ''
Local cBackpc8 := SC8->C8_NUM

DbSelectArea("SC8")
DbSetOrder(1)
DbSeek(xfilial("SC8")+cBackpc8)

While !EOF() .AND. SC8->C8_NUM == cBackpc8 .AND. SC8->C8_FILIAL == xFilial("SC8")

    cMarca  := Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_ZMARCA")
    nQtdFil := cntfilho(SC8->C8_PRODUTO)

    If Empty(cMarca) .And. nQtdFil > 0
        cFiltro += " AND C8_PRODUTO <> '"+SC8->C8_PRODUTO+"'"
    EndIf 

    Dbskip()
EndDo 

Return (cFiltro)


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
