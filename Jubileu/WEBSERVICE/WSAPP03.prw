#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP03 Description "produtos API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData copyItems AS String	Optional
	WsData byId		 AS Boolean	Optional

WsMethod GET products;
    Description 'Lista de produtos';
    WsSyntax '/WSAPP03';
    Path '/WSAPP03';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET / Produto
Retorna a lista de produtos.

@param	SearchKey  , caracter, chave de pesquisa utilizada em diversos campos
		copyItems  , caracter, itens para a copia
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		byId	   , logico, indica se deve filtrar apenas pelo codigo

@return cResponse  , caracter, JSON contendo a lista de produtos

/*/

WsMethod GET products WsReceive searchKey, copyItems, page, pageSize WsRest WSAPP03
	Local lRet:= .T.
	lRet := products( self )
Return( lRet )

Static Function products( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local cSearch		:= ''
Local cWhere		:= ''
Local nAux			:= 0
Local oPrice1
Local oPrice2
Local oPrice3

Default oself:searchKey := ''
Default oself:copyItems := ''
Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:byId		:=.F.
	
    RpcSetType(3)
    RPCSetEnv('01','0801')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := " AND SB1.B1_FILIAL = '"+FwxFilial('SB1')+"' "

	// Tratativas para realizar os filtros
	
	If !Empty(oself:copyItems)
		cWhere += " AND SB1.B1_COD IN (" + oself:copyItems + " ) "
	Else
		If !Empty(oself:searchKey) //se tiver chave de busca no request
			cSearch := Upper( oself:SearchKey )

			If oself:byId //se filtra somente por ID
				cWhere += " AND SB1.B1_COD = '"	+ cSearch + "'"
			Else//busca chave nos campos abaixo
				cWhere += " AND ( SB1.B1_COD LIKE 	'%"	+ cSearch + "%' OR "
				cWhere += " SB1.B1_DESC LIKE 		'%" + cSearch + "%' ) "
			EndIf
		EndIf
	EndIf

	cQuery := " SELECT B1_COD, B1_DESC, B1_TIPO, B1_GRUPO, B1_CODBAR, B1_POSIPI, B1_FABRIC, B1_PRV1, "
	cQuery += " DA1_PRCVEN, DA1_XPRCV2, DA1_XPRCV3, DA1_XQTRG1, DA1_XQTRG2, DA1_XQTRG3,B2_QATU-B2_RESERVA AS SALDO"
	cQuery += " FROM "+RetSqlName('SB1')+" SB1 "
	cQuery += " INNER JOIN "+RetSQLName('DA1')+" DA1 ON DA1_FILIAL='"+FWxFilial("DA1")+"' AND DA1_CODPRO=B1_COD AND DA1.D_E_L_E_T_=' ' "
	cQuery += " INNER JOIN "+RetSQLName('SB2')+" B2 ON B2_FILIAL='"+FWxFilial("SB2")+"' AND B2_COD=B1_COD AND B2_LOCAL=B1_LOCPAD AND B2.D_E_L_E_T_=' ' "
	cQuery += " WHERE SB1.D_E_L_E_T_ = ' ' ""
	cQuery += " AND SB1.B1_MSBLQL <> '1' "+cWhere

	If Empty(oself:copyItems) .And. !oself:byId
		cQuery += " ORDER BY " + SqlOrder(SB1->(IndexKey(1)))
		cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
	EndIf
	
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		cIdAux := '{"SB1",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->B1_COD))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->B1_TIPO))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->B1_GRUPO))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->B1_CODBAR))+'"'+;
		'}
		
		oPrice1 := NIL
		oPrice2 := NIL
		oPrice3 := NIL

		oPrice1 := JsonObject():New()
		oPrice1['min'] 	 := 1
		oPrice1['max'] 	 := (cAliasTMP)->DA1_XQTRG1
		oPrice1['price'] := (cAliasTMP)->DA1_PRCVEN

		oPrice2 := JsonObject():New()
		oPrice2['min'] 	 := (cAliasTMP)->DA1_XQTRG1+1
		oPrice2['max'] 	 := (cAliasTMP)->DA1_XQTRG2
		oPrice2['price'] := (cAliasTMP)->DA1_XPRCV2

		oPrice3 := JsonObject():New()
		oPrice3['min'] 	 := (cAliasTMP)->DA1_XQTRG2+1
		oPrice3['max'] 	 := (cAliasTMP)->DA1_XQTRG3
		oPrice3['price'] := (cAliasTMP)->DA1_XPRCV3

		aListAux[nAux]['id']	            := Encode64(cIdAux)
		aListAux[nAux]['code']	            := Alltrim(EncodeUTF8((cAliasTMP)->B1_COD))
		aListAux[nAux]['description']       := Alltrim(EncodeUTF8((cAliasTMP)->B1_DESC))
		aListAux[nAux]['type']       		:= Alltrim(EncodeUTF8((cAliasTMP)->B1_TIPO))
		aListAux[nAux]['group']       		:= Alltrim(EncodeUTF8(Posicione("SBM",1,FwxFilial("SBM")+(cAliasTMP)->B1_GRUPO,"BM_DESC")))
		aListAux[nAux]['ncm']       		:= Alltrim(EncodeUTF8((cAliasTMP)->B1_POSIPI))
		aListAux[nAux]['ean']       		:= Alltrim(EncodeUTF8((cAliasTMP)->B1_CODBAR))
		aListAux[nAux]['brand']       		:= Alltrim(EncodeUTF8((cAliasTMP)->B1_FABRIC))
		aListAux[nAux]['gender']       		:= "F"
		aListAux[nAux]['line']       		:= "Oculos Receituario"
		aListAux[nAux]['material']       	:= "Acetato"
		aListAux[nAux]['price']       		:= oPrice1
		aListAux[nAux]['price2']       		:= oPrice2
		aListAux[nAux]['price3']       		:= oPrice3
		aListAux[nAux]['balance']       	:= (cAliasTMP)->SALDO
		aListAux[nAux]['selected_quantity']	:= 0
		aListAux[nAux]['marked']	       	:= .F.

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
