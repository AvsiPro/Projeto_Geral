#include "protheus.ch"

/*/{Protheus.doc} MT103FIM
Tratamento para gravar o ticket e situação nf de entrada
utilizado aqui, pois ao incluir o registro ainda não esta criado para
utilizar no ponto de entrada MT100TOK
@type user function
@author user
@since 15/07/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function MT103FIM() 

    Local nOpcao    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
    Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO
    Local lStClas   := type("_XSTTCLA") != "U" 
    Local lTicket   := type("_XTICKET") != "U" 

    If nOpcao == 3 .And. nConfirma == 1
        If lStClas .And. lTicket
            Reclock("SF1",.F.)
            SF1->F1_XSTTCLA := _XSTTCLA
            SF1->F1_XTICKET := _XTICKET
            SF1->(Msunlock())
        EndIf 
    EndIf 
Return()
