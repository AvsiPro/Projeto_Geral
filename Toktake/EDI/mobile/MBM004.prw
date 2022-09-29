#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM004    บAutor  ณMicrosiga           บ Data ณ  12/14/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM004(cRetorno)
           
Local cJson := ""
Local cSql := ""
Local aAx := {}
Local aRT := {}
Local nI
Local cData := ""
Local nTot := 0
Local nSld := 0
Local oObj
Local aJson := {}
Local oItem
Local aStat := {}
Local aRes := {}

If cEmpAnt <> "01"
	Return
EndIf

cSql := "SELECT Z7_ARMMOV,Z7_SAIDA SAIDA, SUM(Z7_QUANT) TOTAL, SUM(Z7_QATU) SALDO FROM SZ7010 " //+RetSqlName("SZ7")
cSql += " WHERE D_E_L_E_T_ = '' "
cSql += " AND Z7_STATUS = '1' "
cSql += " AND Z7_RETORNO = '' "
cSql += " GROUP BY Z7_ARMMOV,Z7_SAIDA "
cSql += " ORDER BY Z7_ARMMOV, Z7_SAIDA "
	
	
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	AADD( aAx, { AllTrim(TRB->Z7_ARMMOV), STOD(TRB->SAIDA), TRB->TOTAL, TRB->SALDO  } )  
	dbSkip()
End
	
For nI := 1 To Len(aAx)
	If Ascan( aRT, { |x| AllTrim(x[1]) == AllTrim(aAx[nI][1]) } ) == 0
		AADD( aRT, { AllTrim(aAx[nI][1]), "", 0 } )
	EndIf
Next nI

For nI := 1 To Len(aRT)
	cdata := ""
	nTot := 0
	nSld := 0
	For nJ := 1 To Len(aAx)
		If aAx[nJ][1] == aRT[nI][1]
			If Empty(cdata)
				cdata := dtoc(aAx[nJ][2]+1)
			EndIf
			nTot += aAx[nJ][3]
			nSld += aAx[nJ][4]
		EndIf
	Next nJ
	
	aRT[nI][2] := cdata
	aRT[nI][3] := Round(( nSld/nTot) * 100,2)
Next nI
			

// -> nome total percentual concluido
oObj := JsonObject():New()
	
If Len(aRT) > 0   	      
	For nI := 1 To Len(aRT)
		oItem := JsonObject():New()
		oItem:PutVal("rt", AllTrim(aRT[nI][1]) )
		oItem:PutVal("inicio", aRT[nI][2] )
		oItem:PutVal("perc", aRT[nI][3] )
		AADD(aJson,oItem)
	Next nI
	oObj:PutVal("status","ok")
	oObj:PutVal("result","tudo ok")
	oObj:PutVal("lista",aJson)
	cJson := oObj:ToJson()
EndIf
	   
Return cJson