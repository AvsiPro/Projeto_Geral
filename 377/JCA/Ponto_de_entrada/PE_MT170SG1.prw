#INCLUDE 'PROTHEUS.CH'

User Function MT170SG1

Local aProds := Paramixb
Local lRet   := .T.

Return lRet

User Function MS170QPP

Local aProds := Paramixb 

Return 

User Function MT170SC1

SC1->C1_OBS := 'SC gerada por ponto de pedido'

Return

User Function MT170QRY
Local cNewQry := ParamIXB[1]
//-- Manipulação da query/filtro para condição do usuário
Return (cNewQry)
