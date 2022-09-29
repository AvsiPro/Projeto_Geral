#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC87    บAutor  ณMicrosiga         บ Data ณ  10/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorno da OS de inventario                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC87(aDados,cArmazem)

Local nI
Local aaux := {}
Local aItens := {}
Local cOSMobile := ""
Default aDados := {}
Default cArmazem := ""
Default lNovoFrm := .F.

If cEmpAnt <> "01"
	return
EndIF

For nI := 1 To Len(aDados)
	If aDados[nI][1] == "NUMEROOS"
		cOSMobile := aDados[nI][2]
	EndIf
	If aDados[nI][1] == "ABASTECIMENTO"
		aAux := aclone(aDados[nI][2])
		Exit
	EndIf
Next nI         

For nI := 1 To Len(aAux)
	If subStr(aAux[nI][1],1,1) <> "D"
		AADD( aItens, { aAux[nI][1], aAux[nI][2] } )
	EndIf
Next nI


If Empty(cArmazem) .And. !Empty(cOSMobile)
	dbSelectArea("SZG")
	dbSetOrder(1)
	If msSeek( xFilial("SZG") +AvKey(cOSMobile,"ZG_NUMOS") )
		cArmazem := SZG->ZG_ROTA
	EndIf             
EndIf

If !Empty(cArmazem)
	// zera armazem
	StaticCall( TTPROC57, Invent, cArmazem )
	
	// ajusta saldo novo
	StaticCall( TTPROC57, Invent, cArmazem ,3, aItens )
EndIf

Return