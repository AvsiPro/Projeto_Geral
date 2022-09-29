#INCLUDE "Protheus.ch"

User Function MT103GET()

Local aArea	:=	GetArea()
Local lRet	:=	.T.

RestArea(aArea)

Return(lRet)    

User Function MT103DRF()

Local aArea	:=	GetArea()
Local aret	:=	{} 
//aImpRet[1]=Nome do Imposto aImpRet[2]=Nova posição do combo (1=sim;2=não) aImpRet[3]=Novo código de retenção
If cEmpAnt == "01"
	aadd(aret,{"DI2",2,"5522"})
EndIf

RestArea(aArea)

Return(aret)