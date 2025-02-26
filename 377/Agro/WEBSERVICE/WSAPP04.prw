#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP04 Description "condicao de pagamento API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData byId		 AS Boolean	Optional

WsMethod GET payment;
    Description 'Lista de condicao de pagamento';
    WsSyntax '/WSAPP04';
    Path '/WSAPP04';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET / Produto
Retorna a lista de condicao de pagamento.

@param	SearchKey  , caracter, chave de pesquisa utilizada em diversos campos
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		byId	   , logico, indica se deve filtrar apenas pelo codigo

@return cResponse  , caracter, JSON contendo a lista de condicao de pagamento

/*/

WsMethod GET payment WsReceive searchKey, page, pageSize WsRest WSAPP04
	Local lRet:= .T.
	lRet := payment( self )
Return( lRet )

Static Function payment( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local cSearch		:= ''
Local cWhere		:= ''
Local nAux			:= 0

Default oself:searchKey := ''
Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:byId		:=.F.
	
	RpcClearEnv()	
	RpcSetType(3)
	RPCSetEnv('01','0801')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := "AND SE4.E4_FILIAL = '"+FwxFilial('SE4')+"' AND SE4.E4_XENVAPP='1' "

	// Tratativas para realizar os filtros
	If !Empty(oself:searchKey) //se tiver chave de busca no request
		cSearch := Upper( oself:SearchKey )

		If oself:byId //se filtra somente por ID
			cWhere += " AND SE4.E4_CODIGO = '"	+ cSearch + "'"
		Else//busca chave nos campos abaixo
			cWhere += " AND ( SE4.E4_CODIGO LIKE '%" + cSearch + "%' OR "
			cWhere += " SE4.E4_COND   LIKE '%" + cSearch + "%' OR "
			cWhere += " SE4.E4_DESCRI LIKE '%" + cSearch + "%' ) "
		EndIf

		//cWhere += " AND SE4.E4_XENVAPP='1' "
	EndIf

	cQuery := " SELECT E4_CODIGO,E4_DESCRI,E4_COND "
	cQuery += " FROM "+RetSqlName('SE4')+" SE4 "
	cQuery += " WHERE SE4.D_E_L_E_T_ = ' ' ""
	cQuery += " AND SE4.E4_MSBLQL <> '1' "+cWhere
	cQuery += " ORDER BY " + SqlOrder(SE4->(IndexKey(1)))
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
	
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		cIdAux := '{"SE4",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->E4_CODIGO))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->E4_COND))+'"'+;
		'}

		aListAux[nAux]['id']	            := Encode64(cIdAux)
		aListAux[nAux]['code']	            := Alltrim(EncodeUTF8((cAliasTMP)->E4_CODIGO))
		aListAux[nAux]['description']       := Alltrim(EncodeUTF8((cAliasTMP)->E4_DESCRI))
		aListAux[nAux]['form']       		:= Alltrim(EncodeUTF8((cAliasTMP)->E4_COND))

		(cAliasTMP)->(DBSkip())
	EndDo

	(cAliasTMP)->(DBCloseArea())

    oStatus := JsonObject():New()

	If Len(aListAux) > 0
		oStatus['code']    := '#200'
		oStatus['message'] := 'sucesso'
	Else
		oStatus['code']    := '#400'
		oStatus['message'] := 'nao econtrado'
	EndIf

    oJsonAux['status'] := oStatus
	oJsonAux['result'] := aListAux

	cJsonAux := FwJsonSerialize(oJsonAux)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonAux)
    
Return .T.
