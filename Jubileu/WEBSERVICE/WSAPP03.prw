#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP03 Description "produtos API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
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
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		byId	   , logico, indica se deve filtrar apenas pelo codigo

@return cResponse  , caracter, JSON contendo a lista de produtos

/*/

WsMethod GET products WsReceive searchKey, page, pageSize WsRest WSAPP03
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

Default oself:searchKey := ''
Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:byId		:=.F.
	
    RpcSetType(3)
    RPCSetEnv('01','0101')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := "AND SB1.B1_FILIAL = '"+FwxFilial('SB1')+"'"

	// Tratativas para realizar os filtros
	If !Empty(oself:searchKey) //se tiver chave de busca no request
		cSearch := Upper( oself:SearchKey )

		If oself:byId //se filtra somente por ID
			cWhere += " AND SB1.B1_COD = '"	+ cSearch + "'"
		Else//busca chave nos campos abaixo
			cWhere += " AND ( SB1.B1_COD LIKE 	'%"	+ cSearch + "%' OR "
			cWhere += " SB1.B1_DESC LIKE 		'%" + cSearch + "%' ) "
		EndIf
	EndIf

	cQuery := " SELECT B1_COD, B1_DESC, B1_TIPO, B1_GRUPO, B1_CODBAR, B1_POSIPI, B1_FABRIC, B1_PRV1 "
	cQuery += " FROM "+RetSqlName('SB1')+" SB1 "
	cQuery += " WHERE SB1.D_E_L_E_T_ = ' ' ""
	cQuery += " AND SB1.B1_MSBLQL <> '1' "+cWhere
	cQuery += " ORDER BY " + SqlOrder(SB1->(IndexKey(1)))
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
	
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
		aListAux[nAux]['price']       		:= 100
		aListAux[nAux]['price2']       		:= 100
		aListAux[nAux]['price3']       		:= 100
		aListAux[nAux]['balance']       	:= 200
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
