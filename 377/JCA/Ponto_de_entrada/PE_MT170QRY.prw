#INCLUDE 'PROTHEUS.CH'

USER FUNCTION MT170QRY()

Local cNewQry := ParamIXB[1]

cNewQry += " AND SB1.B1_ZMARCA=' '"


Return (cNewQry)
