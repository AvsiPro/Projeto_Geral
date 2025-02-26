#Include 'Protheus.ch'

 /*/{Protheus.doc} IMG05
Impress�o de etiquetas de identifica��o do volume tempor�rio.

@author   Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function IMG05()
	
	Local lRet := .T.
	
	lRet := U_ImpEtqId(PARAMIXB)
	
Return(lRet)
