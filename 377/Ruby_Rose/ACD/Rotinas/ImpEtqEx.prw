#Include 'Protheus.ch'

 /*/{Protheus.doc} ImpEtqEx()
Impressão da Etiqueta de Expedição.

@author    Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function ImpEtqEx()

	Local aArea			:= GetArea()
	Local cPedido		:= CriaVar("CB9_PEDIDO")
	
	dbSelectArea("CB9")
	dbSeek(xFilial("CB9")+cOrdSep)
	cPedido:= CB9->CB9_PEDIDO
	
	//ExecBlock(U_ETQEXP(cPedido))
	
	ExecBlock(Alltrim(GETMV("MV_CBIXBNF")))
	
	RestArea(aArea)

Return

