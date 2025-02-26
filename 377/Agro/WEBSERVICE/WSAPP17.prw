#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"

WsRestFul WSAPP17 Description "API" FORMAT APPLICATION_JSON
	WsData ano		 AS Integer	Optional
	WsData mes       AS Integer	Optional
 
WsMethod GET WSAPP17;
    Description 'GET Dinamico';
    WsSyntax '/WSAPP17';
    Path '/WSAPP17';
    Produces APPLICATION_JSON
End WsRestFul

WsMethod GET WSAPP17 WsReceive ano, mes WsRest WSAPP17

	Local lRet:= .T.
	lRet := fGet( self )

Return( lRet )

Static Function fGet( oSelf )

    Local oJsonAux	    := Nil
    Local cJsonAux		:= ''

    Local aData1 := {}	
    Local aData2 := {}
    Local aData3 := {}
    Local aData4 := {}	

    RpcSetType(3)
    RPCSetEnv('01','0801')

	If oSelf:Ano == 2023
		If oSelf:Mes == 7
			aData1 := { 444, 391, 240, 220, 204, 194, 185, 59 }
			aData2 := { 441, 286, 331, 165, 183, 264, 163, 130 }
			aData3 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3, 2 }
			aData4 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0, 0.1, 0.1, 0.1, 0, 0 }
		Else
			aData1 := { 444, 391, 240, 220, 204, 194, 185, 59 }
			aData2 := { 441, 286, 331, 165, 183, 264, 163, 130 }
			aData3 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3, 2 }
			aData4 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0, 0.1, 0.1, 0.1, 0, 0 }
		EndIf
	Else
		If oSelf:Mes == 7
			aData1 := { 444, 391, 240, 220, 204, 194, 185, 59 }
			aData2 := { 441, 286, 331, 165, 183, 264, 163, 130 }
			aData3 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3, 2 }
			aData4 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0, 0.1, 0.1, 0.1, 0, 0 }
		Else
			aData1 := { 444, 391, 240, 220, 204, 194, 185, 59 }
			aData2 := { 441, 286, 331, 165, 183, 264, 163, 130 }
			aData3 := { 1, 4, 2, 0.2, 0.2, 1, 0.2, 3, 2, 2, 3, 2 }
			aData4 := { 0.1, 0.1, 0.1, 0.2, 0, 0, 0, 0.1, 0.1, 0.1, 0, 0 }
		EndIf
	EndIf

    oJsonAux  := JsonObject():New()
	oResult := JsonObject():New()

    oResult['header'] := Array(5)
    oResult['header'][1] := JsonObject():New()
    oResult['header'][1]['title'] := "Vlr. Total Vendas"
    oResult['header'][1]['type'] := "k"
    oResult['header'][1]['value'] := 1936

    oResult['header'][2] := JsonObject():New()
    oResult['header'][2]['title'] := "LV Vlr. Vendas"
    oResult['header'][2]['type'] := "k"
    oResult['header'][2]['value'] := 1019

    oResult['header'][3] := JsonObject():New()
    oResult['header'][3]['title'] := "YoY"
    oResult['header'][3]['type'] := "percent"
    oResult['header'][3]['value'] := 89.92

    oResult['header'][4] := JsonObject():New()
    oResult['header'][4]['title'] := "Vlr. Ticket Médio"
    oResult['header'][4]['type'] := "number"
    oResult['header'][4]['value'] := 701.63

    oResult['header'][5] := JsonObject():New()
    oResult['header'][5]['title'] := "Num Vendas"
    oResult['header'][5]['type'] := ""
    oResult['header'][5]['value'] := 2759

    oResult['option1'] := JsonObject():New()
    oResult['option1']['chart'] := JsonObject():New()
    oResult['option1']['chart']['type'] := "bar"
    oResult['option1']['chart']['foreColor'] := "themeContext.text"

    oResult['option1']['colors'] := Array(2)
    oResult['option1']['colors'][1] := "#0D6EFD"
    oResult['option1']['colors'][2] := "#FD7E14"

    oResult['option1']['plotOptions'] := JsonObject():New()
    oResult['option1']['plotOptions']['bar'] := JsonObject():New()
    oResult['option1']['plotOptions']['bar']['horizontal'] := .T.
    oResult['option1']['plotOptions']['bar']['dataLabels'] := JsonObject():New()
    oResult['option1']['plotOptions']['bar']['dataLabels']['position'] := "top"

    oResult['option1']['dataLabels'] := JsonObject():New()
    oResult['option1']['dataLabels']['enabled'] := .T.
    oResult['option1']['dataLabels']['offsetX'] := 25
    oResult['option1']['dataLabels']['style'] := JsonObject():New()
    oResult['option1']['dataLabels']['style']['fontSize'] := "12px"
    oResult['option1']['dataLabels']['style']['colors'] := Array(1)
    oResult['option1']['dataLabels']['style']['colors'][1] := "themeContext.text"

    oResult['option1']['stroke'] := JsonObject():New()
    oResult['option1']['stroke']['show'] := .F.

    oResult['option1']['tooltip'] := JsonObject():New()
    oResult['option1']['tooltip']['shared'] := .T.
    oResult['option1']['tooltip']['intersect'] := .F.

    oResult['option1']['xaxis'] := JsonObject():New()
    oResult['option1']['xaxis']['categories'] := Array(8)
    oResult['option1']['xaxis']['categories'][1] := "Guarulhos"
    oResult['option1']['xaxis']['categories'][2] := "Lapa"
    oResult['option1']['xaxis']['categories'][3] := "Caieiras"
    oResult['option1']['xaxis']['categories'][4] := "Casa Verde"
    oResult['option1']['xaxis']['categories'][5] := "Osasco"
    oResult['option1']['xaxis']['categories'][6] := "Barueri"
    oResult['option1']['xaxis']['categories'][7] := "Franco da Rocha"
    oResult['option1']['xaxis']['categories'][8] := "Maua"

    oResult['series1'] := Array(2)
    oResult['series1'][1] := JsonObject():New()
    oResult['series1'][1]['name'] := "Valor Vendas"
    oResult['series1'][1]['data'] := aData1

    oResult['series1'][2] := JsonObject():New()
    oResult['series1'][2]['name'] := "Valor Meta Ate a Data"
    oResult['series1'][2]['data'] := aData2

    oResult['option2'] := JsonObject():New()
    oResult['option2']['chart'] := JsonObject():New()
    oResult['option2']['chart']['height'] := 350
    oResult['option2']['chart']['type'] := "line"
    oResult['option2']['chart']['foreColor'] := "themeContext.text"
    oResult['option2']['chart']['toolbar'] := JsonObject():New()
    oResult['option2']['chart']['toolbar']['show'] := .T.

    oResult['option2']['chart'] := JsonObject():New()
    oResult['option2']['colors'] := Array(2)
    oResult['option2']['colors'][1] := "rgb(0, 143, 251)"
    oResult['option2']['colors'][2] := "#0D6EFD"

    oResult['option2']['dataLabels'] := JsonObject():New()
    oResult['option2']['dataLabels']['enabled'] := .F.

    oResult['option2']['stroke'] := JsonObject():New()
    oResult['option2']['stroke']['curve'] := "smooth"

    oResult['option2']['grid'] := JsonObject():New()
    oResult['option2']['grid']['borderColor'] := "#E7E7E7"
    oResult['option2']['grid']['row'] := JsonObject():New()
    oResult['option2']['grid']['row']['colors'] := Array(1)
    oResult['option2']['grid']['row']['colors'][1] := "transparent"
    oResult['option2']['grid']['row']['opacity'] := 0.5

    oResult['option2']['markers'] := JsonObject():New()
    oResult['option2']['markers']['size'] := 1

    oResult['option2']['xaxis'] := JsonObject():New()
    oResult['option2']['xaxis']['categories'] := Array(12)
    oResult['option2']['xaxis']['categories'][1] := "Jan"
    oResult['option2']['xaxis']['categories'][2] := "Fev"
    oResult['option2']['xaxis']['categories'][3] := "Mar"
    oResult['option2']['xaxis']['categories'][4] := "Abr"
    oResult['option2']['xaxis']['categories'][5] := "Mai"
    oResult['option2']['xaxis']['categories'][6] := "Jun"
    oResult['option2']['xaxis']['categories'][7] := "Jul"
    oResult['option2']['xaxis']['categories'][8] := "Ago"
    oResult['option2']['xaxis']['categories'][9] := "Set"
    oResult['option2']['xaxis']['categories'][10] := "Out"
    oResult['option2']['xaxis']['categories'][11] := "Nov"
    oResult['option2']['xaxis']['categories'][12] := "Dez"

    oResult['option2']['xaxis']['title'] := JsonObject():New()
    oResult['option2']['xaxis']['title']['text'] := "2022"

    oResult['option2']['yaxis'] := JsonObject():New()
    oResult['option2']['yaxis']['title'] := JsonObject():New()
    oResult['option2']['yaxis']['title']['text'] := "Milhoes"

    oResult['option2']['legend'] := JsonObject():New()
    oResult['option2']['legend']['position'] := "top"
    oResult['option2']['legend']['horizontalAlign'] := "left"
    oResult['option2']['legend']['floating'] := .F.

    oResult['series2'] :=  Array(2)
    oResult['series2'][1] := JsonObject():New()
    oResult['series2'][1]['name'] := "Valor Vendas"
    oResult['series2'][1]['data'] := aData3

    oResult['series2'][2] := JsonObject():New()
    oResult['series2'][2]['name'] := "LY Valor Vendas"
    oResult['series2'][2]['data'] := aData4

    oResult['dataTable'] := Array(1)
    oResult['dataTable'][1] := JsonObject():New()
    oResult['dataTable'][1]['classe'] := "Lente Oftalmica"
    oResult['dataTable'][1]['vlrVendas'] := 351878
    oResult['dataTable'][1]['percTotal'] := 62.8
    oResult['dataTable'][1]['quant'] := 1191
    oResult['dataTable'][1]['numVendas'] := 550
    oResult['dataTable'][1]['vlrDesc'] := 62617
    oResult['dataTable'][1]['vlrVBrut'] := 414495
    oResult['dataTable'][1]['subgrupos'] := Array(4)
    oResult['dataTable'][1]['subgrupos'][1] := JsonObject():New()
    oResult['dataTable'][1]['subgrupos'][1]['name'] := "MF"
    oResult['dataTable'][1]['subgrupos'][1]['vlrVendas'] := 124141
    oResult['dataTable'][1]['subgrupos'][1]['percTotal'] := 22.1
    oResult['dataTable'][1]['subgrupos'][1]['quant'] := 358
    oResult['dataTable'][1]['subgrupos'][1]['numVendas'] := 175
    oResult['dataTable'][1]['subgrupos'][1]['vlrDesc'] := 22468
    oResult['dataTable'][1]['subgrupos'][1]['vlrVBrut'] := 146610

    oResult['dataTable'][1]['subgrupos'][2] := JsonObject():New()
    oResult['dataTable'][1]['subgrupos'][2]['name'] := "Outros"
    oResult['dataTable'][1]['subgrupos'][2]['vlrVendas'] := 111788
    oResult['dataTable'][1]['subgrupos'][2]['percTotal'] := 19.9
    oResult['dataTable'][1]['subgrupos'][2]['quant'] := 159
    oResult['dataTable'][1]['subgrupos'][2]['numVendas'] := 80
    oResult['dataTable'][1]['subgrupos'][2]['vlrDesc'] := 25049
    oResult['dataTable'][1]['subgrupos'][2]['vlrVBrut'] := 136137

    oResult['dataTable'][1]['subgrupos'][3] := JsonObject():New()
    oResult['dataTable'][1]['subgrupos'][3]['name'] := "LP"
    oResult['dataTable'][1]['subgrupos'][3]['vlrVendas'] := 94839
    oResult['dataTable'][1]['subgrupos'][3]['percTotal'] := 169
    oResult['dataTable'][1]['subgrupos'][3]['quant'] := 608
    oResult['dataTable'][1]['subgrupos'][3]['numVendas'] := 282
    oResult['dataTable'][1]['subgrupos'][3]['vlrDesc'] := 10376
    oResult['dataTable'][1]['subgrupos'][3]['vlrVBrut'] := 105216

    oResult['dataTable'][1]['subgrupos'][4] := JsonObject():New()
    oResult['dataTable'][1]['subgrupos'][4]['name'] := "VS"
    oResult['dataTable'][1]['subgrupos'][4]['vlrVendas'] := 14580
    oResult['dataTable'][1]['subgrupos'][4]['percTotal'] := 2.6
    oResult['dataTable'][1]['subgrupos'][4]['quant'] := 47
    oResult['dataTable'][1]['subgrupos'][4]['numVendas'] := 24
    oResult['dataTable'][1]['subgrupos'][4]['vlrDesc'] := 4187
    oResult['dataTable'][1]['subgrupos'][4]['vlrVBrut'] := 18767

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
