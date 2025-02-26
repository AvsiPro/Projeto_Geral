#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"

WsRestFul WSAPP21 Description "API" FORMAT APPLICATION_JSON
	WsData token AS String	Optional
 
WsMethod GET WSAPP21;
    Description 'GET Dinamico';
    WsSyntax '/WSAPP21';
    Path '/WSAPP21';
    Produces APPLICATION_JSON
End WsRestFul

WsMethod GET WSAPP21 WsReceive token WsRest WSAPP21

	Local lRet:= .T.
	lRet := fGet( self )

Return( lRet )

Static Function fGet( oSelf )

    Local oJsonAux := Nil
    Local cJsonAux := ''
    Local aData    := {0,0,0,0,0,0,0,0,0,0,0,0}
    Local aData1   := {0,0,0}

    Default oself:token := ''

	RpcClearEnv()
	RpcSetType(3)
	RPCSetEnv('01','0801')

    cQuery := " WITH TRB1 AS (  " 
    cQuery += " 	SELECT  SUBSTRING(E1_VENCREA,0,5) AS ANO, CAST(SUBSTRING(E1_VENCREA,5,2) AS INT) AS MES, SUM(E1_VALOR) AS VALOR  " 
    cQuery += " 	FROM " + RetSQLName("SE1") + " SE1  " 
    cQuery += " 	INNER JOIN " + RetSQLName("SA1") + " SA1  " 
    cQuery += " 		ON A1_FILIAL = '"+FWxFilial('SA1')+"'  " 
    cQuery += " 		AND A1_COD = E1_CLIENTE  " 
    cQuery += " 		AND A1_LOJA = E1_LOJA  " 
    cQuery += " 		AND UPPER(A1_TOKEN) = '"+Upper(oself:token)+"'  " 
    cQuery += " 		AND SA1.D_E_L_E_T_ = ''  " 
    cQuery += " 	INNER JOIN " + RetSQLName("SF2") + " SF2  "
    cQuery += " 		ON SF2.F2_DOC = E1_NUM  " 
    cQuery += " 		AND SF2.F2_SERIE = E1_PREFIXO  " 
    cQuery += " 		AND SF2.F2_CLIENTE = E1_CLIENTE  "
    cQuery += " 		AND SF2.F2_LOJA = E1_LOJA  " 
    cQuery += " 		AND SF2.D_E_L_E_T_=' '  " 
    cQuery += " 	WHERE SE1.D_E_L_E_T_ = ''  " 
    cQuery += " 		AND E1_FILIAL = '"+FWxFilial('SE1')+"'  " 
    cQuery += " 	GROUP BY SUBSTRING(E1_VENCREA,0,5), SUBSTRING(E1_VENCREA,5,2)  " 
    cQuery += " )  " 
    cQuery += " SELECT 	   ISNULL([1],0) AS JANEIRO  " 
    cQuery += "          , ISNULL([2],0) AS FEVEREIRO  " 
    cQuery += "          , ISNULL([3],0) AS MARCO  " 
    cQuery += " 		 , ISNULL([4],0) AS ABRIL  " 
    cQuery += "          , ISNULL([5],0) AS MAIO  " 
    cQuery += "          , ISNULL([6],0) AS JUNHO  " 
    cQuery += "          , ISNULL([7],0) AS JULHO  " 
    cQuery += "          , ISNULL([8],0) AS AGOSTO  " 
    cQuery += "          , ISNULL([9],0) AS SETEMBRO  " 
    cQuery += "          , ISNULL([10],0) AS OUTUBRO  " 
    cQuery += " 		 , ISNULL([11],0) AS NOVEMBRO  " 
    cQuery += "          , ISNULL([12],0) AS DEZEMBRO  " 
    cQuery += " FROM TRB1   " 
    cQuery += " PIVOT (SUM(VALOR) FOR MES IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))P  " 
    cQuery += " WHERE ANO = '"+Year2Str(Date())+"'  " 
    cQuery += " ORDER BY 1  " 

    conout(cQuery)

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)
    
    If (cAliasTMP)->(!EoF())
        aData := {;
            (cAliasTMP)->JANEIRO,;
            (cAliasTMP)->FEVEREIRO,;
            (cAliasTMP)->MARCO,;
            (cAliasTMP)->ABRIL,;
            (cAliasTMP)->MAIO,;
            (cAliasTMP)->JUNHO,;
            (cAliasTMP)->JULHO,;
            (cAliasTMP)->AGOSTO,;
            (cAliasTMP)->SETEMBRO,;
            (cAliasTMP)->OUTUBRO,;
            (cAliasTMP)->NOVEMBRO,;
            (cAliasTMP)->DEZEMBRO ;
        }
    EndIf
    
    (cAliasTMP)->(DbCloseArea())



    cQuery := " WITH TRB1 AS(  " 
    cQuery += " SELECT  " 
    cQuery += " CASE   " 
    cQuery += " 	WHEN E1_BAIXA != '' THEN 'PAGO'  " 
    cQuery += " 	WHEN E1_BAIXA = '' AND E1_VENCREA >= CONVERT(varchar, GETDATE(), 112) THEN 'ABERTO'  " 
    cQuery += " 	ELSE 'ATRASADO'  " 
    cQuery += " END AS STATUS,  " 
    cQuery += " E1_VALOR AS VALOR, " 
    cQuery += " SUBSTRING(E1_VENCREA,0,5) AS ANO  " 
    cQuery += " FROM " + RetSQLName("SE1") + " SE1  " 
    cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1  " 
    cQuery += " 	ON A1_FILIAL = '"+FWxFilial('SA1')+"'  " 
    cQuery += " 	AND A1_COD = E1_CLIENTE  " 
    cQuery += " 	AND A1_LOJA = E1_LOJA  " 
    cQuery += " 	AND UPPER(A1_TOKEN) = '"+Upper(oself:token)+"'  " 
    cQuery += " 	AND SA1.D_E_L_E_T_ = ''  " 
    cQuery += " INNER JOIN " + RetSQLName("SF2") + " SF2  " 
    cQuery += " 	ON SF2.F2_DOC = E1_NUM  " 
    cQuery += " 	AND SF2.F2_CLIENTE = E1_CLIENTE  " 
    cQuery += " 	AND SF2.F2_LOJA = E1_LOJA  " 
    cQuery += " 	AND SF2.D_E_L_E_T_=' '  " 
    cQuery += " WHERE SE1.D_E_L_E_T_ = ''  " 
    cQuery += " 	AND E1_FILIAL = '"+FWxFilial('SE1')+"'  " 
    cQuery += " )  " 
    cQuery += " SELECT   " 
    cQuery += " 	ISNULL([ATRASADO],0) AS ATRASADO,  " 
    cQuery += " 	ISNULL([ABERTO],0) AS ABERTO,  " 
    cQuery += " 	ISNULL([PAGO],0) AS PAGO  " 
    cQuery += " FROM TRB1  " 
    cQuery += " PIVOT (SUM(VALOR) FOR STATUS IN ([ATRASADO],[ABERTO],[PAGO]))P  "
    cQuery += " WHERE ANO = '"+Year2Str(Date())+"' "

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)

    If (cAliasTMP)->(!EoF())
        aData1 := {;
            (cAliasTMP)->PAGO,;
            (cAliasTMP)->ABERTO,;
            (cAliasTMP)->ATRASADO;
        }
    EndIf
    
    (cAliasTMP)->(DbCloseArea())

    oJsonAux  := JsonObject():New()
    oResult := JsonObject():New()

    oResult['series'] := Array(1)
    oResult['series'][1] := JsonObject():New()
    oResult['series'][1]['name'] := 'Valor'
    oResult['series'][1]['data'] := aData

    oResult['series1'] := Array(3)

    oResult['series1'][1] := JsonObject():New()
    oResult['series1'][1]['title'] := 'Titulos pagos'
    oResult['series1'][1]['type']  := 'number'
    oResult['series1'][1]['value'] := aData1[1]
    oResult['series1'][1]['icon']  := 'paid'

    oResult['series1'][2] := JsonObject():New()
    oResult['series1'][2]['title'] := 'Titulos em aberto'
    oResult['series1'][2]['type']  := 'number'
    oResult['series1'][2]['value'] := aData1[2]
    oResult['series1'][2]['icon']  := 'open'

    oResult['series1'][3] := JsonObject():New()
    oResult['series1'][3]['title'] := 'Titulos em atraso'
    oResult['series1'][3]['type']  := 'number'
    oResult['series1'][3]['value'] := aData1[3]
    oResult['series1'][3]['icon']  := 'late'

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
