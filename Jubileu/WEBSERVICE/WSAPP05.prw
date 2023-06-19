#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP05 Description "titulos API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData byId		 AS Boolean	Optional
	WsData customer  AS String

WsMethod GET financial;
    Description 'Lista de titulos';
    WsSyntax '/WSAPP05';
    Path '/WSAPP05';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET / Produto
Retorna a lista de titulos.

@param	SearchKey  , caracter, chave de pesquisa utilizada em diversos campos
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		byId	   , logico  , indica se deve filtrar apenas pelo codigo
		customer   , caracter, cliente que usara como filtro

@return cResponse  , caracter, JSON contendo a lista de titulos

/*/

WsMethod GET financial WsReceive searchKey, page, pageSize, customer WsRest WSAPP05
	Local lRet:= .T.
	lRet := financial( self )
Return( lRet )

Static Function financial( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local cSearch		:= ''
Local cWhere		:= ''
Local nAux			:= 0

Default oself:searchKey := ''
Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:byId		:= .F.
Default oself:customer  := ''
	
    RpcSetType(3)
    RPCSetEnv('01','0101')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := "AND SE1.E1_FILIAL = '"+FwxFilial('SE1')+"'"

	// Tratativas para realizar os filtros
	If !Empty(oself:searchKey) //se tiver chave de busca no request
		cSearch := Upper( oself:SearchKey )

		If oself:byId //se filtra somente por ID
			cWhere += " AND SE1.E1_NUM = '"	+ cSearch + "'"
		EndIf
	EndIf

	If !Empty(oself:customer)
		cQuery := " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,"
		cQuery += " E1_EMISSAO,E1_VENCREA,E1_VALOR,E1_BAIXA,A1_NOME,A1_CGC "
		cQuery += " FROM "+RetSqlName('SE1')+" SE1 "
		cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
		cQuery += " ON SA1.A1_FILIAL='"+FwxFilial("SA1")+"' "
		cQuery += " AND SA1.A1_COD=E1_CLIENTE "
		cQuery += " AND SA1.A1_LOJA=E1_LOJA "
		cQuery += " AND SA1.D_E_L_E_T_=' ' "
		cQuery += " WHERE SE1.D_E_L_E_T_=' ' "
		cQuery += " AND SA1.A1_CGC = '"+oself:customer+"' "+cWhere
		cQuery += " ORDER BY " + SqlOrder(SE1->(IndexKey(1)))
		cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
		
		MPSysOpenQuery(cQuery, cAliasTMP)

		While (cAliasTMP)->(!Eof())
			nAux++
			aAdd(aListAux , JsonObject():New() )

			cIdAux := '{"SE1",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->E1_NUM))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->E1_PARCELA))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->E1_PREFIXO))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->E1_CLIENTE))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->E1_LOJA))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->E1_VENCREA))+'"'+;
			'}

			cStatus := If(!Empty((cAliasTMP)->E1_BAIXA),'Pago', If(SToD((cAliasTMP)->E1_VENCREA) >= Date(),"Em Aberto","Atrasado"))

			aListAux[nAux]['id']	            := Encode64(cIdAux)
			aListAux[nAux]['document']	        := Alltrim(EncodeUTF8((cAliasTMP)->E1_NUM))
			aListAux[nAux]['prefix']     		:= Alltrim(EncodeUTF8((cAliasTMP)->E1_PREFIXO))
			aListAux[nAux]['installments']		:= Alltrim(EncodeUTF8((cAliasTMP)->E1_PARCELA))
			aListAux[nAux]['customer']			:= Alltrim(EncodeUTF8((cAliasTMP)->E1_CLIENTE))
			aListAux[nAux]['emission']			:= Alltrim(EncodeUTF8((cAliasTMP)->E1_EMISSAO))
			aListAux[nAux]['expiration']		:= Alltrim(EncodeUTF8((cAliasTMP)->E1_VENCREA))
			aListAux[nAux]['value']				:= (cAliasTMP)->E1_VALOR
			aListAux[nAux]['status']			:= Alltrim(EncodeUTF8(cStatus))
			aListAux[nAux]['customerName']		:= Alltrim(EncodeUTF8((cAliasTMP)->A1_NOME))
			aListAux[nAux]['customerCNPJ']		:= Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))

			(cAliasTMP)->(DBSkip())
		EndDo

		(cAliasTMP)->(DBCloseArea())
	EndIf
	
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
