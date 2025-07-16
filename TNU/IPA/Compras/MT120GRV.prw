#INCLUDE 'Protheus.ch'
/*/{Protheus.doc} MT120GRV
Ponto de entrada na gravação do pedido de compra
verificação se o item já esta liberado para ser utilizada no ponto de entrada mt120fim
@type user function
@author user
@since 02/05/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function MT120GRV

Local lRet      :=  .T.
Local lPaGer    := type("lIPAPA") != "U"

Public lLibera  :=  SC7->C7_CONAPRO == "L"

If lPaGer
    DbSelectArea("SE2")
    DbSetOrder(1)
    If Dbseek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO)
        Reclock("SE2",.F.)
        SE2->E2_TIPO := 'PP'
        SE2->(Msunlock())

        
    EndIf 
EndIF 

Return lRet




