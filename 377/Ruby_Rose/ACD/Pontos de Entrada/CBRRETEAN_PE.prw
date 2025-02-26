#Include 'Protheus.ch'
#Include 'Topconn.ch'

 /*/{Protheus.doc} CBRETEAN
O Ponto de Entrada é chamado no momento da leitura de etiquetas quando não utilizado o parâmetro MV_ACDCB0.

@author   Paulo Lima
@since    16/12/2021
@return    aRet
/*/

User Function CBRETEAN()
 	
 	Local aRet := PARAMIXB

	VtBeep(3)
//	VTALERT("CAIXA","Aviso",.T.,4000,3)
 	
	 aRet := U_DadosEtq(PARAMIXB)

Return(aRet)
