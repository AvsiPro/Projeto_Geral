#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} IVLDCPO2
Ponto de entrada na inclusão de PA pelo pedido de compra
não permitir incluir PA com valor superior ao pedido
Quando estiver sendo gerado pelo pedido de compra
@type user function
@author Alexandre Venâncio
@since 11/06/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User function F050ADPC()

Local aValor := paramixb
Local lTeste := .t.

Public lIPAPA := .F.

If M->E2_VALOR > aValor[1,6] 	
    lTeste := .F.	
    MsgAlert("Não é permitido incluir uma PA com valor superior ao pedido de compra!!!")
Else 
    lIPAPA := .T.
EndIF

MV_PAR05 := 2
MV_PAR09 := 2 


Return lTeste
