#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na rotina de contas a receber
    Valida��o solicitada pelo Caio para n�o permitir incluir naturezas com mais de 6 digitos

*/
User Function FINA010

LOCAL AAREA := GETAREA()
Local aAux  := Paramixb
Local lRet  := .T.

If len(aAux) > 3
    If valtype(aAux[4]) <> "L"
        If aAux[4] == "SETVALUE"
            If LEN(Alltrim(M->ED_CODIGO)) > 6
                MsgAlert("N�o � permitido inclus�o de c�digos de naturezas com mais de 6 digitos")
                M->ED_CODIGO := SPACE(10)
                lRet := .F.
            EndIf 
        EndIf 
    EndIf 
EndIf 

RESTAREA(AAREA)

RETURN(lRet)
