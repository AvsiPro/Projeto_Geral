#INCLUDE "PROTHEUS.CH"

User Function MA020TDOK

Local lRet:= .T.	

//-- Rotina de customiza��o do usu�rio
IF M->A2_EST <> "EX" .AND. EMPTY(M->A2_CGC)
    MSGALERT("CNPJ OBRIGATORIO PARA FORNECEDORES NACIONAIS")
    lRet := .F.
EndIf 

Return lRet
