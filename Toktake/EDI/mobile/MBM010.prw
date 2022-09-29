
/*
Funcao: MBM010 - Maquinas para Mapa
@author Jackson E. de Deus - XCode Mobile
*/
User Function MBM010( Atendente )

Local cJson := ""
Local aJson := {}
Local oObj := Nil
Local oItem := Nil
Local cQuery := ""

If cEmpAnt <> "01"
	Return
EndIf

// - ALTERAR CONSULTA -> CONSIDERAR AS MAQUINAS DO PLANO DE TRABALHO DO ATENDENTE

cQuery := "SELECT ZG_PATRIM, ZG_PATRIMD FROM " +RetSqlName("SZG")
cQuery += " WHERE ZG_CODTEC = '"+Atendente+"' AND ZG_DATAINI = '"+DTOS(date())+"' AND D_E_L_E_T_ = '' "
cQuery += " AND ZG_FORM IN ('04','08') "
cQuery += " ORDER BY ZG_PATRIM "

MPSysOpenQuery( cQuery , "TRBZ" )  

dbSelectArea("TRBZ")

While !EOF()	
	oItem := JsonObject():New()
	oItem:PutVal("plaqueta", AllTrim(TRBZ->ZG_PATRIM) )	
	oItem:PutVal("modelo", AllTrim(TRBZ->ZG_PATRIMD) )	
			
	AADD(aJson,oItem)
		
	TRBZ->(dbSkip())
End	

oObj := JsonObject():New()
If !Empty(aJson)
	oObj:PutVal("lista",aJson)
	cJson := oObj:ToJson()
Else
	oObj:PutVal("lista","[]")
	cJson := oObj:ToJson()	
EndIf


Return cJson