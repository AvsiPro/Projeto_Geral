/**/
User function TTCOMC18( cPedido )

Local aArea := GetArea()
Local cNome := ""

If cEmpAnt == "10"
	dbSelectArea("SC7")
	dbSetOrder(1)
	If MsSeek( xFilial("SC7") +AvKey(cPedido,"C7_NUM") )
		dbSelectArea("SA2")
		dbSetOrder(1)
		If MsSeek( xFilial("SA2") +Avkey(SC7->C7_FORNECE,"A2_COD") +AvKey(SC7->C7_LOJA,"A2_LOJA") ) 
			cNome := ALLtRIM( SA2->A2_NOME )
		EndIf
	EndIf
EndIf

RestARea(aArea)


Return cNome