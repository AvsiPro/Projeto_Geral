#include 'PROTHEUS.CH'

User function AF012ROT

Local aArea := GetArea()
Local aRet  := Paramixb[1]

AAdd( aRet, { "Estornar Classificação", "U_ROT006()", 2, 0 } )

RestArea(aArea)

Return(aRet)
