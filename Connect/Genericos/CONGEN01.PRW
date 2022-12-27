#INCLUDE 'PROTHEUS.CH'
#include "topconn.ch"
#include "tbiconn.ch"


User Function CONGEN01

Local aAux := {}
Local cQuery := ''
Local nCont 

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

cQuery := "SELECT X2_CHAVE FROM SX2010 ORDER BY X2_CHAVE"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,TRB->X2_CHAVE)
    Dbskip()
EndDo 

For nCont := 1 to len(aAux)
    Chkfile(aAux[nCont],.T.)
Next nCont

Return
