#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM005    บAutor  ณJackson E. de Deus  บ Data ณ  17/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as OS do atendente                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM005(Atendente)
           
Local cJson := ""
Local cSql := ""
Local cEnd := ""
Local cPaMaq := ""  
Local aOS := {}
Local aOS2 := {}
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
Local lAtvVldOS := SuperGetMv("MV_XMB006",.F.,.F.)

If cEmpAnt <> "01"
	Return
EndIf

// OS em aberto
cSql := "SELECT ZG_FILIAL, ZG_NUMOS FROM " +RetSqlName("SZG") +" WITH (NOLOCK) WHERE ZG_CODTEC = '"+Atendente+"' AND ZG_STATUS = 'OPEN' AND D_E_L_E_T_ = '' "
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

Tcquery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	
	AADD( aOS, { TRB->ZG_NUMOS,"",TRB->ZG_FILIAL } )
	
	dbSelectArea("TRB")
	dbSkip()
End

// OS finalizada porem precisam ser reabertas
If lAtvVldOS
	cSql := "SELECT ZG_NUMOS FROM " +RetSqlName("SZG")
	cSql += " WHERE ZG_CODTEC = '"+Atendente+"' AND ZG_STATUS = 'FIOK' AND ZG_NOVOFRM = 'T' AND D_E_L_E_T_ = '' " 
	cSql += " AND ZG_FORM IN ('04','08') AND ZG_VLDRET = 'ERROR' AND ZG_NTRY = '1' "

	MPSysOpenQuery( cSql , "TRB" )  		
	dbSelectArea("TRB")
	While !EOF()		
		AADD( aOS2, { TRB->ZG_NUMOS,"" } )		
		dbSelectArea("TRB")
		dbSkip()
	End	
EndIf


dbSelectArea("SZG")
dbSetOrder(1)
For nI := 1 To Len(aOS)
	If msSeek( aOS[nI][3] +AvKey(aOS[nI][1],"ZG_NUMOS") )
		If !Empty(SZG->ZG_ENVIO)
			aOS[nI][2] := AllTrim(SZG->ZG_ENVIO)
		EndIf
	EndIf
Next nI

//If !Empty(aOS)
	//oObj := JsonObject():New()	
	cJsAux := "["
	For nI := 1 To Len(aOS)                                      
		cJsOS := aOS[nI][2]
		cJsAux += cJsOS
		If nI <> Len(aOS)
			cJsAux += ","
		EndIf
	Next nI
	cJsAux += "]"
	
	//cJson := '{ "status":"ok", "result": "ok", "lista":' +cJsAux  +"}"
//EndIf


//If !Empty(aOS2)
If lAtvVldOS
	cJsAux2 := "["
	For nI := 1 To Len(aOS2)
	                                      
		cJsAux2 += "{" ;
						+cvaltochar(Val(aOS2[nI][1])) ;
					+"}"
					
		If nI <> Len(aOS2)
			cJsAux2 += ","
		EndIf
	Next nI
	cJsAux2 += "]"
	
	cJson := '{ "status":"ok", "result": "ok", "lista":' +cJsAux +"," +'"reabrir":' +cJsAux2  +"}"
Else
	cJson := '{ "status":"ok", "result": "ok", "lista":' +cJsAux  +"}"
EndIf
//EndIf

CONOUT("#MBM005 " +ATENDENTE + " -> " +cJson)

	   
Return cJson