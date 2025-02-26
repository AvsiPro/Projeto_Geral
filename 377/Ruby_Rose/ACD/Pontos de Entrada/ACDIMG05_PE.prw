#Include 'Protheus.ch'

 /*/{Protheus.doc} IMG05
Impressão de etiquetas de identificação do volume temporário.

@author   Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function IMG05()
	
	Local lRet := .T.
	
	lRet := U_ImpEtqId(PARAMIXB)
	
Return(lRet)
