#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROCG01 บAutor  ณAlexandre Venancio  บ Data ณ  06/22/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Preenchimento dos campos cliente e loja na digitacao do   บฑฑ
ฑฑบ          ณinventario da PA                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROG01(cCod,cTab)

Local aArea	:=	GetArea()
Local cRet	:=	""

If cEmpAnt <> "01"
	return
EndIF

If !EMPTY(Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_ITCONT"))
	If cCod != "Nome"
		cRet 	:= Substr(Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_ITCONT"),If(cCod=="Cli",1,7),If(cCod=="Cli",6,4))
	Else             
		cRet 	:=	Posicione("SA1",1,xFilial("SA1")+Substr(Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_ITCONT"),1,10),"A1_NOME")
	EndIf
ElseIf !EMPTY(Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_SITE"))
	If cCod != "Nome"
		cRet	:= Posicione("ZZ3",1,xFilial("ZZ3")+Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_SITE"),If(cCod=="Cli","ZZ3_CODCLI","ZZ3_LOJA"))
	Else       
		cCod	:=	Posicione("ZZ3",1,xFilial("ZZ3")+Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_SITE"),"ZZ3_CODCLI")
		cLoj	:=	Posicione("ZZ3",1,xFilial("ZZ3")+Posicione("ZZ1",1,xFilial("ZZ1")+If(cTab=="ZC",M->ZC_CODPA,M->Z6_CODPA),"ZZ1_SITE"),"ZZ3_LOJA")
		cRet	:=	Posicione("SA1",1,xFilial("SA1")+cCod+cLoj,"A1_NOME")
	EndIf
EndIf

RestArea(aArea)

Return(cRet)                 