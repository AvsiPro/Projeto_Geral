#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC28 บAutor  ณJackson E. de Deus   บ Data ณ  04/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gravacao da contagem do inventario                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC28(cNumeroOS,aDadosOS)

Local aArea := GetArea()
Local axItens := {}
Local aItens := {}
Local aItensDS := {}
Local aExced := {}
Local aTotFica := {}
Local nI,nJ
Local cDoc := ""
Local cArmazem := ""     
Default cNumeroOS := ""
Default aDadosOS := {}

If cEmpAnt <> "01"
	return
EndIF

If Empty( aDadosOS ) .Or. Empty( cNumeroOS )
	Return
EndIf

cArmazem := SZG->ZG_PA
If Empty(cArmazem)
	Return
EndIf

// se ja gravou os dados dessa OS, cancela
dbSelectArea("SZC")
dbSetOrder(3) // filial os
If MSSeek( xFilial("SZC") +AvKey(cNumeroOS,"ZC_NUMOS") )
	Return
EndIf


For nI := 1 To Len(aDadosOS)          
	If aDadosOS[nI][1] == "INVENTARIO"
		For nJ := 2 To Len(aDadosOS[nI])
			AADD( axItens, ACLONE(aDadosOS[nI][nJ]) )
		Next nJ
	EndIf	
Next nI

For nI := 1 To Len( axItens )
	AADD( aItens, { axitens[nI][1][2], Val(axItens[nI][2][2]) } )
	AADD( aItensDs, { axitens[nI][1][2], Val(axItens[nI][3][2]) } )
	AADD( aExced, { axitens[nI][1][2], Val(axItens[nI][4][2]) } )
	AADD( aTotFica, { axitens[nI][1][2], Val(axItens[nI][7][2]) } )
Next nI


	
cDoc := NextNumZC()

dbSelectArea("SZC")
dbSetOrder(2) // filial local produto data tipo // TODO: ALTERAR INDICE PARA CONTEMPLAR O TIPO DA GRAVACAO

For nI := 1 To Len( aItens )
	//If !MsSeek( xFilial("SZC") +AvKey(cArmazem,"ZC_LOCAL") +AvKey(aItens[nI][1],"ZC_COD") +AvKey(dtos(SZG->ZG_DATAFIM),"ZC_DATA") )
		RecLock("SZC",.T.)
		SZC->ZC_FILIAL := xFilial("SZC")
		SZC->ZC_INVENT := cDoc
		SZC->ZC_DATA := SZG->ZG_DATAFIM
		SZC->ZC_LOCAL := cArmazem
		SZC->ZC_COD := aItens[nI][1]
		SZC->ZC_QTD := aItens[nI][2]
		SZC->ZC_TIPO := "1"
		SZC->ZC_NUMOS := cNumeroOS
		MsUnLock()
	//EndIf
Next nI

For nI := 1 To Len( aItensDs )
	//If !MsSeek( xFilial("SZC") +AvKey(cArmazem,"ZC_LOCAL") +AvKey(aItens[nI][1],"ZC_COD") +AvKey(dtos(SZG->ZG_DATAFIM),"ZC_DATA") )
		RecLock("SZC",.T.)
		SZC->ZC_FILIAL := xFilial("SZC")
		SZC->ZC_INVENT := cDoc
		SZC->ZC_DATA := SZG->ZG_DATAFIM
		SZC->ZC_LOCAL := cArmazem
		SZC->ZC_COD := aItensDs[nI][1]
		SZC->ZC_QTD := aItensDs[nI][2]
		SZC->ZC_TIPO := "2"
		SZC->ZC_NUMOS := cNumeroOS
		MsUnLock()
	//EndIf
Next nI
       

For nI := 1 To Len( aExced )
	//If !MsSeek( xFilial("SZC") +AvKey(cArmazem,"ZC_LOCAL") +AvKey(aItens[nI][1],"ZC_COD") +AvKey(dtos(SZG->ZG_DATAFIM),"ZC_DATA") )
		RecLock("SZC",.T.)
		SZC->ZC_FILIAL := xFilial("SZC")
		SZC->ZC_INVENT := cDoc
		SZC->ZC_DATA := SZG->ZG_DATAFIM
		SZC->ZC_LOCAL := cArmazem
		SZC->ZC_COD := aExced[nI][1]
		SZC->ZC_QTD := aExced[nI][2]
		SZC->ZC_TIPO := "3"
		SZC->ZC_NUMOS := cNumeroOS
		MsUnLock()
	//EndIf
Next nI

For nI := 1 To Len( aTotFica )
	//If !MsSeek( xFilial("SZC") +AvKey(cArmazem,"ZC_LOCAL") +AvKey(aItens[nI][1],"ZC_COD") +AvKey(dtos(SZG->ZG_DATAFIM),"ZC_DATA") )
		RecLock("SZC",.T.)
		SZC->ZC_FILIAL := xFilial("SZC")
		SZC->ZC_INVENT := cDoc
		SZC->ZC_DATA := SZG->ZG_DATAFIM
		SZC->ZC_LOCAL := cArmazem
		SZC->ZC_COD := aTotFica[nI][1]
		SZC->ZC_QTD := aTotFica[nI][2]
		SZC->ZC_TIPO := "4"
		SZC->ZC_NUMOS := cNumeroOS
		MsUnLock()
	//EndIf
Next nI


// OS em processamento de dados
dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cNumeroOS,"ZG_NUMOS") )
	Reclock("SZG",.F.)
	SZG->ZG_PROC := "BR_ROSA"
	MsUnlock()
EndIf


RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC28  บAutor  ณMicrosiga           บ Data ณ  04/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NextNumZC()

Local aArea := GetArea()
Local cDoc := ""
Local cQuery := ""

cQuery := "SELECT MAX(ZC_INVENT) DOC FROM " +RetSqlName("SZC")

If Select("TRBZ") > 0
	TRBZ->( dbCloseArea() )
EndIf
                        
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBZ",.F.,.T.)  

dbSelectArea("TRBZ")

If !Empty(TRBZ->DOC)
	cDoc := SOMA1(TRBZ->DOC)
Else
	cDoc := PadL("1",TamSx3("ZC_INVENT")[1],"0")	
EndIf

TRBZ->(dbCloseArea())

RestArea(aArea)

Return cDoc