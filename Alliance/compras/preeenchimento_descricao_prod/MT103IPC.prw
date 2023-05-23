#include 'protheus.ch'
#include 'parmtype.ch'
**************************
user function MT103IPC()
**************************
Local lRet	:= .T.
Local nCodi	:= AScan(aHeader,{|x| alltrim(x[2])=='D1_COD'}) 
Local aAreaX 	:= GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local Y := 0
For Y := 1 To Len(aCols)
	aCols[Y][3] := POSICIONE("SB1",1,xFilial("SB1")+aCols[Y][nCodi],"B1_DESC")
Next Y
RestArea(aAreaSb1)
RestArea(aAreax)

return(lRet)
