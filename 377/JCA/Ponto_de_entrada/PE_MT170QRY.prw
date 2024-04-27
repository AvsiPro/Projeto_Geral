#INCLUDE 'PROTHEUS.CH'

/*
    Não permitir incluir produto pai na solicitação por ponto de pedido
*/

USER FUNCTION MT170QRY()

Local cNewQry := ParamIXB[1]

cNewQry += " AND SB1.B1_ZMARCA=' '"


Return (cNewQry)
