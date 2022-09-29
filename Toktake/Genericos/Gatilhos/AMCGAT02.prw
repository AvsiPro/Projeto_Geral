#INCLUDE 'PROTHEUS.CH'

User Function AMCGAT02(cCampo,cSeq,cValor)

Local aArea	:=	GetArea()
Local cCod	:=	If(val(cSeq)<3,M->A2_COD,M->A1_COD)

//FORNECEDOR
If cCampo == "A2_CGC"
	DbSelectArea("SA2")
	DbSetOrder(3)
	If cSeq == "1"
		If Dbseek(xFilial("SA2")+substr(cValor,1,8))           
			cCod := SA2->A2_COD
		EndIf
	Else
		cCod := substr(cValor,9,4)
	EndIf
EndIf
//CLIENTE
If cCampo == "A1_CGC"
	DbSelectArea("SA1")
	DbSetOrder(3)
	If cSeq == "1"
		If Dbseek(xFilial("SA2")+substr(cValor,1,8))           
			cCod := SA2->A2_COD
		EndIf
	Else
		cCod := substr(cValor,9,4)
	EndIf
EndIf

RestArea(aArea)     

Return(cCod)