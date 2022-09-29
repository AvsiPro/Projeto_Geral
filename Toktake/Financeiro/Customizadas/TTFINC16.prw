#include "topconn.ch"

// Gatilho para preenchimento do cliente e loja
User Function TTFINC16()

Local aArea := GetArea()
Local nPosChapa := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_PATRIMO"})
Local nPosCli := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_CLIENTE"})
Local nPosLoja := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_LOJA"})
Local cNumChapa := aCols[n][nPosChapa]


dbSelectArea("SN1")
dbSetOrder(2)
dbSeek(xFilial("SN1")+AvKey(cNumChapa,"N1_CHAPA"))
If Found()
	If FieldPos("N1_XCLIENT") > 0 .AND. FieldPos("N1_XLOJA") > 0
		If AllTrim(SN1->N1_XCLIENT) <> "" .And. AllTrim(SN1->N1_XLOJA) <> ""
			aCols[n][nPosCli] := SN1->N1_XCLIENT
			aCols[n][nPosLoja] := SN1->N1_XLOJA
		EndIf
	EndIf
EndIf
                         
RestArea(aArea)

Return