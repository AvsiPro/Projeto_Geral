#Include 'Protheus.ch'

/*/{Protheus.doc}	MT450MAN
Executado ao ser acionado a opcao de liberacao manual que 
podera ou nao ser realizada, conforme retorno deste P.E.

@author				Paulo Lima
@since				15/12/2021
@return				lRet
/*/
User Function MT450MAN()

	Local lRet		:= .T.

	//Rotina de Desbloqueio de Pedido e Gera��o de Ordem de Separa��o
	lRet := U_DesblPed()

Return (lRet)

