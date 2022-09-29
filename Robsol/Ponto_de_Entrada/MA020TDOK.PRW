#INCLUDE "PROTHEUS.CH"

User Function MA020TDOK

Local lRet:= .T.	

//-- Rotina de customização do usuário
IF M->A2_EST <> "EX" .AND. EMPTY(M->A2_CGC)
    MSGALERT("CNPJ OBRIGATORIO PARA FORNECEDORES NACIONAIS")
    lRet := .F.
EndIf 

Return lRet
