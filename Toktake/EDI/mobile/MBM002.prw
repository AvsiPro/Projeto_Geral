
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM002    บAutor  ณJackson E. de Deus  บ Data ณ  25/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as capacidades de maquinas de cafe                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM002()

Local cJson := ""
Local aJson := {}
Local oItem
Local oObj
Local cFamilia := ""

If cEmpAnt <> "01"
	Return
EndIf

aJson := {}
dbSelectArea("ZZP")
dbGoTop()
While !EOF()
	cModelo := ZZP->ZZP_CODIGO
	cFamilia := Posicione( "SB1",1,xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI" )
	dbSelectArea("ZZP") 
	If cFamilia == "153"
		oItem := JsonObject():New()
		oItem:PutVal("modelo", AllTrim(cModelo))
		oItem:PutVal("descricao", AllTrim(ZZP->ZZP_DESC) ) 
		oItem:PutVal("copo", ZZP->ZZP_CAP1)
		oItem:PutVal("palheta", ZZP->ZZP_CAP2)
		oItem:PutVal("cafe_grao", ZZP->ZZP_CAP3)
		oItem:PutVal("cafe_soluvel", ZZP->ZZP_CAP4)
		oItem:PutVal("acucar", ZZP->ZZP_CAP5)
		oItem:PutVal("leite", ZZP->ZZP_CAP6)
		oItem:PutVal("chocolate", ZZP->ZZP_CAP7)
		oItem:PutVal("cha", ZZP->ZZP_CAP8)
		AADD(aJson,oItem) 
	EndIf
	ZZP->(dbSkip())
End

If !Empty(aJson)
	oObj := JsonObject():New()
	oObj:PutVal("capacidades",aJson)
	
	cJson := oObj:ToJson()
	
	If Empty(cJson)
		cJSon := "{}"
	/*Else 	        
		nPosC := At("[", cJson) 
		cJson := SubStr( cJson,nPosC,Len(cJson) )
		cJSon := SubStr( cJson,1, Len(cJson)-1 )*/
	EndIf
Else
	cJSon := "{}"	
EndIf


Return cJson