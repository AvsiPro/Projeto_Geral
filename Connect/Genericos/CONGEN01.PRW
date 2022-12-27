#INCLUDE 'PROTHEUS.CH'
#include "topconn.ch"
#include "tbiconn.ch"
#include "fileio.ch"

User Function CONGEN01

Local aAux := {}
Local cQuery := ''
Local nCont 
Private nHandlel	:=	fcreate('C:\TEMP\TABELAS.txt' , FO_READWRITE + FO_SHARED )

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

cQuery := "SELECT X2_CHAVE FROM SX2010 WHERE X2_CHAVE>'Z01' AND X2_CHAVE NOT IN ('Z06') ORDER BY X2_CHAVE"

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
    cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName(aAux[nCont])
    
    If Select('TRB') > 0
        dbSelectArea('TRB')
        dbCloseArea()
    EndIf

    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

    DbSelectArea("TRB")

    If TRB->QTD > 0
        FWrite(nHandlel,"Tabela - "+aAux[nCont]+" / Qtd "+cvaltochar(TRB->QTD)+CRLF,1000)
    EndIf 

    dbSelectArea(aAux[nCont])
    dbCloseArea()

Next nCont

Fclose()

Return
