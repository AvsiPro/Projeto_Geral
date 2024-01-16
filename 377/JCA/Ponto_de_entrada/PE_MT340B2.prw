#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para ajuste do custo médio quando inventário trouxer zerado
    MIT 44_ESTOQUE_EST018 - Inventário - Custo Médio Apropriado

    DOC MIT
    https://docs.google.com/document/d/114YryGubvN0IFTM2zJQUM5jsilgHWzky/edit
    
    DOC Entrega
    
    
*/
User Function MT340B2

Local aArea     := GetArea()
Local nVlrCm    := 0

If SB2->B2_CM1 == 0
    nVlrCm := BuscaCM(SB2->B2_FILIAL,SB2->B2_COD)
    SB2->B2_CM1 := nVlrCm
    SB2->B2_VATU1 := SB2->B2_CM1 * SB2->B2_QATU
EndIf

RestArea(aArea)

Return

/*/{Protheus.doc} BuscaCM
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaCM(cFilCn,cProdCn)

Local aArea := GetArea()
Local cQuery 
Local nRet  := 0

cQuery := "SELECT 'D3',D3_COD AS PRODUTO,MAX(D3_CUSTO1) AS CUSTOMAX"
cQuery += " FROM "+RetSQLName("SD3")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND D3_COD ='"+cProdCn+"' AND D3_FILIAL='"+cFilCn+"'"
cQuery += " GROUP BY D3_COD"
cQuery += " UNION "
cQuery += " SELECT 'D1',D1_COD AS PRODUTO,MAX(D1_CUSTO) AS CUSTOMAX"
cQuery += " FROM "+RetSQLName("SD1")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND D1_COD ='"+cProdCn+"' AND D1_FILIAL='"+cFilCn+"'"
cQuery += " GROUP BY D1_COD"
cQuery += " ORDER BY 3 DESC"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    If nRet == 0 .Or. nRet > TRB->CUSTOMAX
        nRet := TRB->CUSTOMAX
    EndIf 
    Dbskip()
EndDo 

RestArea(aArea)

Return(nRet)
