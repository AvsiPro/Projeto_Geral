#Include "Protheus.ch"

/*/{Protheus.doc}	M450FLB
Ponto de Entrada da Rotina de Análise Credito Pedido - Faturamento.

@author				Paulo Lima
@since				15/12/2021
@return				Nil
/*/
user function M450FLB()
	local cFiltro := paramIXB[1]
	
	// Realiza o Bloqueio dos itens do Pedido caso houve algum já bloqueado pela Rotina Padrão.
	//U_bloqCredEst()
	
return (cFiltro)
