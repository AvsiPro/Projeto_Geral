#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WESTJ001
Job para envio do estoque por armazem para o IQVIA
@type user function
@author Alexandre Venâncio
@since 03/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WESTJ001()

Local aArea := GetArea()

If Empty(FunName())
	RpcSetType(3)
	RPCSetEnv("00","00001000100")
EndIf	

RestArea(aArea)

Return
