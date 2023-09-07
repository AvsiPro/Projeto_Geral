#INCLUDE 'PROTHEUS.CH'
/*
    Gatilho campo Grupo para produto para criar sequencial do codigo de acordo
    com grupo selecionado
    MIT 44_ESTOQUE_EST001 - Codificação de Produtos
    https://docs.google.com/document/d/10vxbtI4iBcPuf7l3qImxY1BYB1OKtP3Q/edit
    
*/
User Function JCAGAT01()

Local cRet := ''
Local cQuery := ''

cQuery := "SELECT MAX(SUBSTRING(B1_COD,5,4))+1 AS SEQ"
cQuery += " FROM "+RetSQLName("SB1")
cQuery += " WHERE SUBSTRING(B1_COD,1,4) ='"+M->B1_GRUPO+"'"
cQuery += " ORDER BY 1"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

cRet := Alltrim(M->B1_GRUPO)+Strzero(TRB->SEQ,4)

Return(cRet)
