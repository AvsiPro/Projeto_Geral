#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"

WsRestFul WSAPP16 Description "API" FORMAT APPLICATION_JSON
	WsData ano		 AS Integer	Optional
	WsData mes       AS Integer	Optional
 
WsMethod GET WSAPP16;
    Description 'GET Dinamico';
    WsSyntax '/WSAPP16';
    Path '/WSAPP16';
    Produces APPLICATION_JSON
End WsRestFul


WsMethod GET WSAPP16 WsReceive ano, mes WsRest WSAPP16

	Local lRet:= .T.
	lRet := fGet( self )
Return( lRet )

Static Function fGet( oSelf )

    Local oJsonAux	    := Nil
    Local cJsonAux		:= ''

	Local aCtg1 := {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"}
	Local aCtg2 := {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"}

    Local aVlrPag1 := {}	
    Local aVlrRec1 := {}
    Local aVlrPag2 := {}
    Local aVlrRec2 := {}	

    RpcSetType(3)
    RPCSetEnv('01','0801')

	If oSelf:Ano == 2023
		If oSelf:Mes == 7
			aVlrPag1 := { 5, 1, 0, 6, 5, 5, 3 }
			aVlrRec1 := { 3, 0.2, 0.1, 0, 0.5, 0.6, 0.7 }
			aVlrPag2 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3 }
			aVlrRec2 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0 , 0.1, 0.1, 0.1, 0 }
		Else
			aVlrPag1 := { 5, 1, 0, 6, 5, 5, 3 }
			aVlrRec1 := { 3, 0.2, 0.1, 0, 0.5, 0.6, 0.7 }
			aVlrPag2 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3 }
			aVlrRec2 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0 , 0.1, 0.1, 0.1, 0 }
		EndIf
	Else
		If oSelf:Mes == 7
			aVlrPag1 := { 5, 1, 0, 6, 5, 5, 3 }
			aVlrRec1 := { 3, 0.2, 0.1, 0, 0.5, 0.6, 0.7 }
			aVlrPag2 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3 }
			aVlrRec2 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0 , 0.1, 0.1, 0.1, 0 }
		Else
			aVlrPag1 := { 5, 1, 0, 6, 5, 5, 3 }
			aVlrRec1 := { 3, 0.2, 0.1, 0, 0.5, 0.6, 0.7 }
			aVlrPag2 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3 }
			aVlrRec2 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0 , 0.1, 0.1, 0.1, 0 }
		EndIf
	EndIf

    oJsonAux  := JsonObject():New()
	oResult := JsonObject():New()

	oResult['option1'] := JsonObject():New()
	oResult['option1']['chart'] := JsonObject():New()
	oResult['option1']['chart']['height'] := 350
	oResult['option1']['chart']['type'] := "line"
	oResult['option1']['chart']['foreColor'] := "themeContext.text"
	oResult['option1']['chart']['toolbar'] := JsonObject():New()
	oResult['option1']['chart']['toolbar']['show'] := .T.

	oResult['option1']['colors'] := {"#FFC107", "#198754"}

	oResult['option1']['dataLabels'] := JsonObject():New()
	oResult['option1']['dataLabels']['enabled'] := .F.

	oResult['option1']['stroke'] := JsonObject():New()
	oResult['option1']['stroke']['curve'] := "smooth"

	oResult['option1']['grid'] := JsonObject():New()
	oResult['option1']['grid']['borderColor'] := "#E7E7E7"
	oResult['option1']['grid']['row'] := JsonObject():New()
	oResult['option1']['grid']['row']['colors'] := {"transparent"}
	oResult['option1']['grid']['row']['opacity'] := 0.5

	oResult['option1']['markers'] := JsonObject():New()
	oResult['option1']['markers']['size'] := 1

	oResult['option1']['xaxis'] := JsonObject():New()
	oResult['option1']['xaxis']['categories'] := aCtg1
	oResult['option1']['xaxis']['title'] := JsonObject():New()
	oResult['option1']['xaxis']['title']['text'] := fMes(oSelf:Mes)

	oResult['option1']['yaxis'] := JsonObject():New()
	oResult['option1']['yaxis']['title'] := JsonObject():New()
	oResult['option1']['yaxis']['title']['text'] := "Milhoes"

	oResult['option1']['legend'] := JsonObject():New()
	oResult['option1']['legend']['position'] := "top"
	oResult['option1']['legend']['horizontalAlign'] := "left"
	oResult['option1']['legend']['floating'] := .F.

	oResult['series1'] := Array(2)
	oResult['series1'][1] := JsonObject():New()
	oResult['series1'][1]['name'] := "Valor a Pagar"
	oResult['series1'][1]['data'] := aVlrPag1

	oResult['series1'][2] := JsonObject():New()
	oResult['series1'][2]['name'] := "Valor Receber"
	oResult['series1'][2]['data'] := aVlrRec1

	oResult['option2'] := JsonObject():New()
	oResult['option2']['chart'] := JsonObject():New()
	oResult['option2']['chart']['height'] := 350
	oResult['option2']['chart']['type'] := "line"
	oResult['option2']['chart']['foreColor'] := "themeContext.text"
	oResult['option2']['chart']['toolbar'] := JsonObject():New()
	oResult['option2']['chart']['toolbar']['show'] := .T.

	oResult['option2']['colors'] := {"#FFC107", "#198754"}

	oResult['option2']['dataLabels'] := JsonObject():New()
	oResult['option2']['dataLabels']['enabled'] := .F.

	oResult['option2']['stroke'] := JsonObject():New()
	oResult['option2']['stroke']['curve'] := "smooth"

	oResult['option2']['grid'] := JsonObject():New()
	oResult['option2']['grid']['borderColor'] := "#E7E7E7"
	oResult['option2']['grid']['row'] := JsonObject():New()
	oResult['option2']['grid']['row']['colors'] := {"transparent"}
	oResult['option2']['grid']['row']['opacity'] := 0.5

	oResult['option2']['markers'] := JsonObject():New()
	oResult['option2']['markers']['size'] := 1

	oResult['option2']['xaxis'] := JsonObject():New()
	oResult['option2']['xaxis']['categories'] := aCtg2
	oResult['option2']['xaxis']['title'] := JsonObject():New()
	oResult['option2']['xaxis']['title']['text'] := fMes(oSelf:Mes)

	oResult['option2']['yaxis'] := JsonObject():New()
	oResult['option2']['yaxis']['title'] := JsonObject():New()
	oResult['option2']['yaxis']['title']['text'] := "Milhoes"

	oResult['option2']['legend'] := JsonObject():New()
	oResult['option2']['legend']['position'] := "top"
	oResult['option2']['legend']['horizontalAlign'] := "left"
	oResult['option2']['legend']['floating'] := .F.

	oResult['series2'] := Array(2)
	oResult['series2'][1] := JsonObject():New()
	oResult['series2'][1]['name'] := "Valor a Pagar"
	oResult['series2'][1]['data'] := aVlrPag2

	oResult['series2'][2] := JsonObject():New()
	oResult['series2'][2]['name'] := "Valor Receber"
	oResult['series2'][2]['data'] := aVlrRec2

	oResult['fields1'] := Array(13)
	oResult['fields1'][1] := JsonObject():New()
	oResult['fields1'][1]['field'] := "date"
	oResult['fields1'][1]['headerText'] := "Data"
	oResult['fields1'][1]['textAlign'] := "Center"
	
	oResult['fields1'][2] := JsonObject():New()
	oResult['fields1'][2]['field'] := "valueTotal"
	oResult['fields1'][2]['headerText'] := "Vlr. Total Pagar"
	oResult['fields1'][2]['textAlign'] := "Center"
	oResult['fields1'][2]['width'] := "100px"
	
	oResult['fields1'][3] := JsonObject():New()
	oResult['fields1'][3]['field'] := "valueVcto"
	oResult['fields1'][3]['headerText'] := "Vlr. Pago Data Venc"
	oResult['fields1'][3]['textAlign'] := "Center"
	oResult['fields1'][3]['width'] := "100px"
	
	oResult['fields1'][4] := JsonObject():New()
	oResult['fields1'][4]['field'] := "valueLiqd"
	oResult['fields1'][4]['headerText'] := "Vlr. Pago Data Liquid."
	oResult['fields1'][4]['textAlign'] := "Center"
	oResult['fields1'][4]['width'] := "100px"
	
	oResult['fields1'][5] := JsonObject():New()
	oResult['fields1'][5]['field'] := "valueReceive"
	oResult['fields1'][5]['headerText'] := "Vlr. Recebido"
	oResult['fields1'][5]['textAlign'] := "Center"
	oResult['fields1'][5]['width'] := "100px"
	
	oResult['fields1'][6] := JsonObject():New()
	oResult['fields1'][6]['field'] := "valueCards"
	oResult['fields1'][6]['headerText'] := "Vlr. Recebido Cartoes"
	oResult['fields1'][6]['textAlign'] := "Center"
	oResult['fields1'][6]['width'] := "100px"
	
	oResult['fields1'][7] := JsonObject():New()
	oResult['fields1'][7]['field'] := "valueRTotal"
	oResult['fields1'][7]['headerText'] := "Vlr. Total recebido"
	oResult['fields1'][7]['textAlign'] := "Center"
	oResult['fields1'][7]['width'] := "100px"
	
	oResult['fields1'][8] := JsonObject():New()
	oResult['fields1'][8]['field'] := "valueFluxo"
	oResult['fields1'][8]['headerText'] := "Vlr. Fluxo Caixa"
	oResult['fields1'][8]['textAlign'] := "Center"
	oResult['fields1'][8]['width'] := "100px"
	
	oResult['fields1'][9] := JsonObject():New()
	oResult['fields1'][9]['field'] := "valueOpen"
	oResult['fields1'][9]['headerText'] := "Vlr. Pagar Aberto"
	oResult['fields1'][9]['textAlign'] := "Center"
	oResult['fields1'][9]['width'] := "100px"
	
	oResult['fields1'][10] := JsonObject():New()
	oResult['fields1'][10]['field'] := "openPercent"
	oResult['fields1'][10]['headerText'] := "% Aberto"
	oResult['fields1'][10]['textAlign'] := "Center"
	oResult['fields1'][10]['width'] := "100px"
	
	oResult['fields1'][11] := JsonObject():New()
	oResult['fields1'][11]['field'] := "valueCardsN"
	oResult['fields1'][11]['headerText'] := "Vlr. Cartoes Nao Conciliados"
	oResult['fields1'][11]['textAlign'] := "Center"
	oResult['fields1'][11]['width'] := "100px"
	
	oResult['fields1'][12] := JsonObject():New()
	oResult['fields1'][12]['field'] := "valueReceiveO"
	oResult['fields1'][12]['headerText'] := "Vlr. Receber Aberto"
	oResult['fields1'][12]['textAlign'] := "Center"
	oResult['fields1'][12]['width'] := "100px"
	
	oResult['fields1'][13] := JsonObject():New()
	oResult['fields1'][13]['field'] := "valueReceiveC"
	oResult['fields1'][13]['headerText'] := "Vlr. Aberto Cartoes"
	oResult['fields1'][13]['textAlign'] := "Center"
	oResult['fields1'][13]['width'] := "100px"

	oResult['dataTable1'] := Array(1)
	oResult['dataTable1'][1] := JsonObject():New()
	oResult['dataTable1'][1]['date'] := '20230601'
	oResult['dataTable1'][1]['valueTotal'] := 536990
	oResult['dataTable1'][1]['valueVcto'] := 468689
	oResult['dataTable1'][1]['valueLiqd'] := 536990
	oResult['dataTable1'][1]['valueReceive'] := 468689
	oResult['dataTable1'][1]['valueCards'] := 450230
	oResult['dataTable1'][1]['valueRTotal'] := 17444
	oResult['dataTable1'][1]['valueFluxo'] := -432786
	oResult['dataTable1'][1]['valueOpen'] := 21289
	oResult['dataTable1'][1]['openPercent'] := 4
	oResult['dataTable1'][1]['valueCardsN'] := 0
	oResult['dataTable1'][1]['valueReceiveO'] := 0
	oResult['dataTable1'][1]['valueReceiveC'] := 0

	oResult['header'] := Array(6)
	oResult['header'][1] := JsonObject():New()
	oResult['header'][1]['title'] := 'Vlr. Total a Pagar'
	oResult['header'][1]['type'] := 'number'
	oResult['header'][1]['value'] := 5539012
	
	oResult['header'][2] := JsonObject():New()
	oResult['header'][2]['title'] := 'Vlr. Pago'
	oResult['header'][2]['type'] := 'number'
	oResult['header'][2]['value'] := 2616654

	oResult['header'][3] := JsonObject():New()
	oResult['header'][3]['title'] := 'Pago'
	oResult['header'][3]['type'] := 'percent'
	oResult['header'][3]['value'] := 47.2

	oResult['header'][4] := JsonObject():New()
	oResult['header'][4]['title'] := 'Vlr. Pagar Aberto'
	oResult['header'][4]['type'] := 'number'
	oResult['header'][4]['value'] := 2485237

	oResult['header'][5] := JsonObject():New()
	oResult['header'][5]['title'] := 'Vlr. Total Recebido'
	oResult['header'][5]['type'] := 'number'
	oResult['header'][5]['value'] := 224886

	oResult['header'][6] := JsonObject():New()
	oResult['header'][6]['title'] := 'Vlr. Total Receber'
	oResult['header'][6]['type'] := 'number'
	oResult['header'][6]['value'] := 24750

    oStatus := JsonObject():New()

	oStatus['code']    := '#200'
	oStatus['message'] := 'sucesso'

    oJsonAux['status'] := oStatus
	oJsonAux['result'] := Array(1)
	oJsonAux['result'][1] := oResult

	cJsonAux := FwJsonSerialize(oJsonAux)

	FreeObj(oJsonAux)
    FreeObj(oStatus)
    FreeObj(oResult)

	oSelf:SetResponse(cJsonAux)
    
Return .T.

Static Function fMes(nMes)
	
	Local cRet := ""

	Do Case
	Case nMes == 1
		cRet := "Janeiro"
	Case nMes == 2
		cRet := "Fevereiro"
	Case nMes == 3
		cRet := "Marco"
	Case nMes == 4
		cRet := "Abril"
	Case nMes == 5
		cRet := "Maio"
	Case nMes == 6
		cRet := "Junho"
	Case nMes == 7
		cRet := "Julho"
	Case nMes == 8
		cRet := "Agosto"
	Case nMes == 9
		cRet := "Setembro"
	Case nMes == 10
		cRet := "Outubro"
	Case nMes == 11
		cRet := "Novembro"
	Case nMes == 12
		cRet := "Dezembro"
	Otherwise
		cRet := "Corrente"
	EndCase

Return cRet
