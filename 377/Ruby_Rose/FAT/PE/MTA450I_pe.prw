#Include 'Protheus.ch'
 /*/{Protheus.doc} MTA450I

@author   Paulo Lima
@since    17/12/2021
@return   Nil
/*/
User Function MTA450I()
	
	Local nOpc := PARAMIXB[1]
	
	//S� considera gerar OS para op��o OK
	if nOpc == 1
	
		U_GeraOSep("SC5")				// Fun��o que gera os registros na tabela CB7 e CB8 baseados na SC5.
		
		U_bloqCredEst(SC9->C9_PEDIDO)
		
	endIf
Return
