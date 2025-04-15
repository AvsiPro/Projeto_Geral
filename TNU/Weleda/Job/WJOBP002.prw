#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WJOBP001
Job para envio dos clientes para o IQVIA
@type user function
@author Alexandre Venâncio
@since 14/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WJOBP002(cCodigo)

    Local aArea 	:= 	GetArea()

    Default cCodigo	:= 	'000002'

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("T1","D MG 01 ")
	EndIf
    
    RestArea(aArea)

Return
