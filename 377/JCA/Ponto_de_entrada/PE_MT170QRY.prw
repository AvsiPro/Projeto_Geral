#INCLUDE 'PROTHEUS.CH'

/*
    N�o permitir incluir produto pai na solicita��o por ponto de pedido
*/

USER FUNCTION MT170QRY()

Local cNewQry := ParamIXB[1]

cNewQry += " AND SB1.B1_ZMARCA=' '"


Return (cNewQry)
