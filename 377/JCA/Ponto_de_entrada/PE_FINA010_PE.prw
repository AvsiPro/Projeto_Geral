#INCLUDE 'PROTHEUS.CH'

User Function FINA010

LOCAL AAREA := GETAREA()
Local aAux  := Paramixb
Local lRet  := .T.

If len(aAux) > 3
    If aAux[4] == "SETVALUE"
        If LEN(Alltrim(M->ED_CODIGO)) > 6
            MsgAlert("N�o � permitido inclus�o de c�digos de naturezas com mais de 6 digitos")
            M->ED_CODIGO := SPACE(10)
            lRet := .F.
        EndIf 
    EndIf 
EndIf 

RESTAREA(AAREA)

RETURN(lRet)
