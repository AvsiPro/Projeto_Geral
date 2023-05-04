#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP02 Description "Clientes API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData byId		 AS Boolean	Optional

WsMethod GET customers;
    Description 'Lista de Clientes';
    WsSyntax '/WSAPP02';
    Path '/WSAPP02';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET / cliente
Retorna a lista de clientes.

@param	SearchKey  , caracter, chave de pesquisa utilizada em diversos campos
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		byId	   , logico, indica se deve filtrar apenas pelo codigo

@return cResponse  , caracter, JSON contendo a lista de clientes

/*/

WsMethod GET customers WsReceive searchKey, page, pageSize WsRest WSAPP02
	Local lRet:= .T.
	lRet := Customers( self )
Return( lRet )

Static Function Customers( oSelf )

Local aListCli	    := {}
Local oJsonAux	    := Nil
Local cJsonCli		:= ''
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
    cWhere    := "AND SA1.A1_FILIAL = '"+FWxFilial('SA1')+"'"

	// Tratativas para realizar os filtros
	If !Empty(oself:searchKey) //se tiver chave de busca no request
		cSearch := Upper( oself:SearchKey )

		If oself:byId //se filtra somente por ID
			cWhere += " AND SA1.A1_COD = '"	+ cSearch + "'"
		Else//busca chave nos campos abaixo
			cWhere  += " AND ( SA1.A1_COD LIKE 	'%"	+ cSearch + "%' OR "
			cWhere	+= " SA1.A1_LOJA LIKE 		'%" + cSearch + "%' OR "
			cWhere	+= " SA1.A1_NOME LIKE 		'%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SA1.A1_NREDUZ LIKE 	'%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SA1.A1_NREDUZ LIKE 	'%" + cSearch  + "%' OR "
			cWhere	+= " SA1.A1_CGC LIKE	 	'%" + StrTran(StrTran(StrTran(StrTran(cSearch, " ", ""), "-", ""), ".", ""), "/", "")  + "%' OR "
			cWhere	+= " SA1.A1_NOME LIKE 		'%" + cSearch + "%' ) "
		EndIf
	EndIf

	cQuery := " SELECT A1_COD, A1_LOJA, A1_END, A1_BAIRRO, A1_COMPLEM, A1_CGC, A1_INSCR, "
	cQuery += " A1_NOME, A1_NREDUZ, A1_MUN, A1_EST, A1_CEP, A1_CONTATO, A1_EMAIL, A1_DDD, "
	cQuery += " A1_TEL, A1_ULTCOM, A1_PRICOM, A1_RISCO, A1_LC, A1_SALDUP, A1_MCOMPRA, "
	cQuery += " A1_NROCOM, A1_ATR, A1_MATR, A1_PAGATR "
	cQuery += " FROM "+RetSqlName('SA1')+" SA1 "
	cQuery += " WHERE SA1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SA1.A1_MSBLQL <> '1' "+cWhere
	cQuery += " ORDER BY " + SqlOrder(SA1->(IndexKey(1)))
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
	
	MPSysOpenQuery(cQuery, cAliasTMP)


	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListCli , JsonObject():New() )

		cIdAux := '{"SA1",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_COD))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))+'"'+;
		'}'
		
		fGeraResult(;
			@aListCli,;
			nAux,;
			{;
				Encode64(cIdAux),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_COD)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_LOJA)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_END)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_BAIRRO)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_COMPLEM)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_INSCR)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_NOME)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_NREDUZ)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_MUN)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_EST)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_CEP)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_CONTATO)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_EMAIL)),;
				Alltrim(EncodeUTF8(Alltrim((cAliasTMP)->A1_DDD))+(cAliasTMP)->A1_TEL),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_ULTCOM)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_PRICOM)),;
				Alltrim(EncodeUTF8((cAliasTMP)->A1_RISCO)),;
				(cAliasTMP)->A1_LC,;
				(cAliasTMP)->A1_SALDUP,;
				(cAliasTMP)->A1_MCOMPRA,;
				(cAliasTMP)->A1_NROCOM,;
				(cAliasTMP)->A1_ATR,;
				(cAliasTMP)->A1_MATR,;
				(cAliasTMP)->A1_PAGATR;
			};
		)

		(cAliasTMP)->(DBSkip())
	EndDo

	(cAliasTMP)->(DBCloseArea())

    oStatus := JsonObject():New()

    If Len(aListCli) > 0
		oStatus['code']    := '#200'
		oStatus['message'] := 'sucesso'

	Else
		If !Empty(oself:searchKey)
			cSearch := StrTran(StrTran(StrTran(StrTran(oself:SearchKey, " ", ""), "-", ""), ".", ""), "/", "")
			fConsulBraApi(cSearch, @aListCli)

			If Len(aListCli) > 0
				oStatus['code']    := '#200'
				oStatus['message'] := 'sucesso'
			Else
				oStatus['code']    := '#400'
				oStatus['message'] := 'nao encontrado'
			EndIf
		EndIf
    EndIf
	
	oJsonAux['status'] := oStatus
	oJsonAux['result'] := aListCli

	cJsonCli := FwJsonSerialize(oJsonAux)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonCli)
    
Return .T.


Static Function fConsulBraApi(cSearch, aListCli)
			
	oRestClient  := FWRest():New("https://brasilapi.com.br/api")
	oRestClient:setPath("/cnpj/v1/" + cSearch)

	If oRestClient:Get()
		oJsonCNPJ := JsonObject():New()
		oJsonCNPJ:FromJson(oRestClient:CRESULT)

		aAdd(aListCli , JsonObject():New() )

		cIdAux := '{"SA1",'+;
			'"Nao Cadastrado",'+;
			'"'+Alltrim(EncodeUTF8(oJsonCNPJ["cnpj"]))+'"'+;
		'}'
		
		fGeraResult(;
			@aListCli,;
			1,;
			{;
				Encode64(cIdAux),;
				EncodeUTF8('Não cadastrado'),;
				'',;
				Alltrim(EncodeUTF8(SubStr(oJsonCNPJ["descricao_tipo_de_logradouro"] + " " + oJsonCNPJ["logradouro"] + " " + oJsonCNPJ["numero"], 1, 80))),;
				Alltrim(EncodeUTF8(oJsonCNPJ["bairro"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["complemento"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["cnpj"])),;
				'',;
				Alltrim(EncodeUTF8(oJsonCNPJ["razao_social"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["nome_fantasia"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["municipio"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["uf"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["cep"])),;
				'',;
				'',;
				Alltrim(EncodeUTF8(oJsonCNPJ["ddd_telefone_1"])),;
				'',;
				'',;
				'',;
				0,;
				0,;
				0,;
				0,;
				0,;
				0,;
				0;
			};
		)
	EndIf

Return


Static Function fGeraResult(aListCli, nAux, aListAux)

	aListCli[nAux]['id']	            := aListAux[1]
	aListCli[nAux]['code']	            := aListAux[2]
	aListCli[nAux]['branch']            := aListAux[3]
	aListCli[nAux]['address']           := aListAux[4]
	aListCli[nAux]['district']          := aListAux[5]
	aListCli[nAux]['complement']        := aListAux[6]
	aListCli[nAux]['cnpj']              := aListAux[7]
	aListCli[nAux]['state_regist']      := aListAux[8]
	aListCli[nAux]['name']              := aListAux[9]
	aListCli[nAux]['short_name']        := aListAux[10]
	aListCli[nAux]['city']              := aListAux[11]
	aListCli[nAux]['uf']                := aListAux[12]
	aListCli[nAux]['cep']               := aListAux[13]
	aListCli[nAux]['contact']           := aListAux[14]
	aListCli[nAux]['email']             := aListAux[15]
	aListCli[nAux]['phone']             := aListAux[16]
	aListCli[nAux]['last_purchase']     := aListAux[17]
	aListCli[nAux]['first_purchase']    := aListAux[18]
	aListCli[nAux]['risk']              := aListAux[19]
	aListCli[nAux]['credit_limit']      := aListAux[20]
	aListCli[nAux]['balance']           := aListAux[21]
	aListCli[nAux]['biggest_purchase']  := aListAux[22]
	aListCli[nAux]['amount_purchases']  := aListAux[23]
	aListCli[nAux]['amount_delays']     := aListAux[24]
	aListCli[nAux]['biggest_delays']    := aListAux[25]
	aListCli[nAux]['late_payments']     := aListAux[26]

Return
