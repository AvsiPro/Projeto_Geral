#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"

 /*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBJOB04

Local cQuery
Local aAux      :=  {}
Local nX        :=  1
Local cCodigo 

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

cQuery := "SELECT A1_CGC,A1_COD,A1_LOJA,LTRIM(RTRIM(A1_NREDUZ)) AS NOME"
cQuery += "  FROM "+RetSQLName("SA1")
cQuery += " WHERE D_E_L_E_T_=' ' "
cQuery += " AND A1_CGC NOT IN (SELECT RTRIM(AI3_LOGIN)" 
cQuery += "     FROM "+RetSQLName("AI3")+" WHERE D_E_L_E_T_=' ')"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

DbSelectArea("QUERY")

While !EOF()
    Aadd(aAux,{QUERY->A1_CGC,QUERY->A1_COD,QUERY->A1_LOJA,QUERY->NOME})
    Dbskip()
EndDo 

DbSelectArea("AI3")
DbSelectArea("AI4")
cCodigo := ''

For nX := 1 to len(aAux)
    cCodigo := GetSXENum("AI3","AI3_CODUSU")
    ConfirmSX8()
    Reclock("AI3",.T.)
    AI3->AI3_FILIAL := xFilial("AI3")
    AI3->AI3_CODUSU :=  cCodigo
    AI3->AI3_LOGIN  :=  aAux[nX,01]
    AI3->AI3_NOME   :=  Alltrim(aAux[nX,04])
    AI3->AI3_PSW    :=  '123456'
    AI3->AI3_ADMIN  :=  '2'
    AI3->AI3_XACESS :=  '000012'
    AI3->(Msunlock())
    Reclock("AI4",.T.)
    AI4->AI4_FILIAL :=  xFilial("AI4")
    AI4->AI4_CODUSU :=  cCodigo
    AI4->AI4_CODCLI :=  aAux[nX,02]
    AI4->AI4_LOJCLI :=  aAux[nX,03]
    AI4->(MsUnlock())
Next nX 

Return
