
/*
Funcao: MBM009 - Expediente Tecnico
@author Jackson E. de Deus - XCode Mobile
*/
User Function MBM009( Atendente,dtHrIni,LatIni,LngIni,dtHrFim,LatFim,LngFim )

Local cJson := ""
Local oObj := Nil
Local lOk := .F.
Local dDtIni := stod("")
Local cHrIni := ""
Local nLatIni := 0
Local nLngIni := 0
Local dDtFim := stod("")
Local cHrFim := ""
Local nLatFim := 0
Local nLngFim := 0
Local aAuxDt := {}

If cEmpAnt <> "01"
	Return
EndIf

aAuxDt := StrToKarr( dtHrIni," " )
If Len(aAuxDt) == 2
	dDtIni := CTOD(aAuxDt[1])
	cHrIni := aAuxDt[2]
EndIf

aAuxDt := StrToKarr( dtHrFim," " )
If Len(aAuxDt) == 2
	dDtFim := CTOD(aAuxDt[1])
	cHrFim := aAuxDt[2]
EndIf



dbSelectArea("SZM")
dbSetOrder(1)	// Tecnico DiaInicio
If !MSSeek( xFilial("SZM") +AvKey(Atendente,"ZM_CODTEC") +AvKey(DTOS(dDtIni),"ZM_DATAINI") +AvKey(cHrIni,"ZM_HORAINI")  )	
	RecLock("SZM",.T.)
	SZM->ZM_CODTEC := Atendente
	SZM->ZM_DATAINI := dDtIni
	SZM->ZM_HORAINI := cHrIni
	SZM->ZM_DATAFIM := dDtFim
	SZM->ZM_HORAFIM := cHrFim
	
	SZM->ZM_GPSINI := LatIni +"," +LngIni
	
	MsUnLock()
	
	lOk := .T.
Else
	RecLock("SZM",.F.)
	//SZM->ZM_DATAINI := dDiaIni
	//SZM->ZM_HORAINI := cHoraIni
	SZM->ZM_DATAFIM := dDtFim
	SZM->ZM_HORAFIM := cHrFim
	
	SZM->ZM_GPSFIM := LatFim +"," +LngFim
	//SZM->ZM_TOTHORAS := ElapTime(  )
	
	MsUnLock()	
	
	lOk := .T.
EndIf

If lOk
	oObj := JsonObject():New()
	oObj:PutVal("status","ok")
	cJson := oObj:ToJson()
Else
	oObj := JsonObject():New()
	oObj:PutVal("status","error")
	cJson := oObj:ToJson()	
EndIf

Return cJson