#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP18 Description "chamados API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData token     AS String
    WsData ano		 AS Integer	Optional
	WsData mes       AS Integer	Optional

WsMethod GET dailysales;
    Description 'Venda Diaria';
    WsSyntax '/WSAPP18';
    Path '/WSAPP18';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a venda diária do vendedor.

@param	Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		token      , caracter, token vendedor que usara como filtro
        ano        , numerico, ano de consulta
        mes        , numerico, mes de consulta

@return cResponse  , caracter, JSON contendo a venda diária do vendedor
/*/

WsMethod GET dailysales WsReceive page, pageSize, token, ano, mes WsRest WSAPP18
	Local lRet:= .T.
	lRet := dailysales( self )
Return( lRet )

Static function dailysales( oSelf )

Local cJsonCli      := ""
Local oJsonAux	    := Nil
Local aListCli      := {}
Local cVend 
Local cQuery 
Local cPriDia
Local cUltDia
Local nAux          :=  0
Local oResult 
Local aAux1             :=  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local aAux2             :=  {0,0,0,0,0}

Default oself:page		:=	1
Default oself:pageSize	:= 	20
Default oself:ano		:=  2023
Default oself:mes       :=	7
Default oself:token		:=	''

conout('chegou wsapp18')

RpcClearEnv()
RpcSetType(3)
RPCSetEnv('01','0801')

    If !Empty(oself:ano) .And. !Empty(oself:mes)
        cPriDia := cvaltochar(oself:ano)+cvaltochar(strzero(oself:mes,2))+'01'
        cUltDia := dtos(ctod(cvaltochar(lastday(stod(cPriDia)))))
    EndIf

    conout('passou dias wsapp18')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

    If !Empty(oself:token)
        conout('antes vendedor')
        cVend   := fVendToken( oself:token )
        conout('depois vendedor')
        conout(cvaltochar(cPriDia))
        conout(cvaltochar(cUltDia))

        cQuery := "SELECT C5_EMISSAO,SUM(C6_VALOR) AS VALOR"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6.D_E_L_E_T_=' '"
        cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        cQuery += " GROUP BY C5_EMISSAO"
        cQuery += " ORDER BY 1"
        cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "

        MPSysOpenQuery(cQuery, cAliasTMP)

	    While (cAliasTMP)->(!Eof())
            nPos := day(stod((cAliasTMP)->C5_EMISSAO))
            aAux1[nPos] := round((cAliasTMP)->VALOR / 1000,1)
            nAux++

            (cAliasTMP)->(DBSkip())
        EndDo

        (cAliasTMP)->(DBCloseArea())

        oStatus := JsonObject():New()
        oResult := JsonObject():New()

        oResult['series1'] := Array(1)
        oResult['series1'][1] := JsonObject():New()
        oResult['series1'][1]['name'] := "Valor Vendas"
        oResult['series1'][1]['data'] := aAux1

        conout(cvaltochar(len(aListCli)))
        
        If nAux > 0
            oStatus['code']    := '#200'
            oStatus['message'] := 'sucesso'

        Else
            oStatus['code']    := '#400'
            oStatus['message'] := 'nao encontrado'
        EndIf 

    EndIf 

    oJsonAux['status'] := oStatus
	oJsonAux['result'] := Array(1)
	oJsonAux['result'][1] := oResult

	cJsonCli := FwJsonSerialize(oJsonAux)
    
    conout('json # ' + cJsonCli)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonCli)

    

Return .T.

/*/{Protheus.doc} fVendToken
   @description: Token Vendedor
   @type: Static Function
   @author: Felipe Mayer
   @since: 19/06/2023
/*/

Static Function fVendToken(cToken)

Local cRet  := ''
Local aArea := GetArea()
	
	cQuery := " SELECT * FROM "+RetSqlName('SA3')+" " + CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND UPPER(A3_TOKEN) = '"+Upper(cToken)+"' " + CRLF
	
	cAliasTMP := GetNextAlias()
	MPSysOpenQuery(cQuery, cAliasTMP)
	
	If (cAliasTMP)->(!EoF())
		cRet := (cAliasTMP)->A3_COD
	EndIf
	
	(cAliasTMP)->(DbCloseArea())

RestArea(aArea)

Return cRet

Static Function fGeraResult(aListCli, nAux, aListAux)

	aListCli[nAux]['day']	            	:= aListAux[1]
	aListCli[nAux]['amount']            	:= aListAux[2]
	

Return
