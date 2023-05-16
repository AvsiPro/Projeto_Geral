#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function M410LIOK
    @type    @author user
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function M410LIOK()

Local lRet := .T.
/*
If ALTERA 
    IF ACOLS[N,LEN(AHEADER)+1]
        MsgAlert("Não é permitido excluir linhas do pedido")
        lRet := .F.
    EndIf
EndIf 
*/
Return(lRet)
