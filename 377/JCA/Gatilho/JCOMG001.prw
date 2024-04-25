#INCLUDE 'PROTHEUS.CH'
/*
    Gatilho campo Grupo para produto para criar sequencial do codigo de acordo
    com grupo selecionado
    MIT 44_ESTOQUE_EST001 - Codificação de Produtos

    Doc MIT
    https://docs.google.com/document/d/10vxbtI4iBcPuf7l3qImxY1BYB1OKtP3Q/edit
    Doc Entrega
    https://docs.google.com/document/d/1qU10HGIjy-NU6P6bpPoa5rTvqtE3AaQX/edit
    
*/
User Function JCOMG001()

Local cRet := ''
Local cQuery := ''
Local lCopJca := .F.
Local nPos  :=  0

 While !Empty(procname(nPos))
    If 'JCOMG002' $ Alltrim(upper(procname(nPos)))
        lCopJca := .T.
        exit 
    EndIf 
    nPos++
EndDo

If !lCopJca
    cQuery := "SELECT MAX(SUBSTRING(B1_COD,5,4))+1 AS SEQ"
    cQuery += " FROM "+RetSQLName("SB1")
    cQuery += " WHERE SUBSTRING(B1_COD,1,4) ='"+M->B1_GRUPO+"' AND D_E_L_E_T_=' '"
    cQuery += " ORDER BY 1"

    IF Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    ENDIF

    MemoWrite("CONFATC01.SQL",cQuery)
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")  

    cRet := Alltrim(M->B1_GRUPO)+Strzero(If(TRB->SEQ < 1,1,TRB->SEQ),4)
else
    cRet := M->B1_COD
EndIf 

Return(cRet)
