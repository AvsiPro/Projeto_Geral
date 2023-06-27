#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP05 Description "titulos API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData byId		 AS Boolean	Optional
	WsData customer  AS String
	WsData type 	 AS String  Optional
	WsData seller    AS String  Optional

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
		type	   , caracter, tipo vendedor / cliente
		seller     , caracter, codigo vendedor

@return cResponse  , caracter, JSON contendo a lista de titulos

/*/

WsMethod GET financial WsReceive searchKey, page, pageSize, customer, type, seller WsRest WSAPP05
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
Default oself:type		:= ''
Default oself:seller	:= ''
	
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

	cQuery := " SELECT ISNULL(F2_FILIAL,'') AS F2_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE, "
	cQuery += " E1_LOJA,E1_EMISSAO,E1_VENCREA,E1_VALOR,E1_BAIXA,A1_NOME,A1_CGC "
	cQuery += " FROM " + RetSQLName("SE1") + " SE1 " 
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 "
	cQuery += "        ON SA1.A1_FILIAL='"+FwxFilial("SA1")+"' "
	cQuery += "        AND SA1.A1_COD=E1_CLIENTE " 
	cQuery += "        AND SA1.A1_LOJA=E1_LOJA " 
	cQuery += "        AND SA1.D_E_L_E_T_=' ' " 
	cQuery += " LEFT JOIN " + RetSQLName("SF2") + " SF2 "
	cQuery += "        ON SF2.F2_DOC = E1_NUM " 
	cQuery += "        AND SF2.F2_SERIE = E1_PREFIXO " 
	cQuery += "        AND SF2.F2_CLIENTE = E1_CLIENTE " 
	cQuery += "        AND SF2.F2_LOJA = E1_LOJA " 
	cQuery += "        AND SF2.D_E_L_E_T_=' ' "
	cQuery += " WHERE  SE1.D_E_L_E_T_=' ' "

	If !Empty(oself:seller)
		cQuery += " AND SF2.F2_VEND1 = '"+oself:seller+"' "
	EndIf

	If !Empty(oself:customer)
		cQuery += " AND SA1.A1_CGC = '"+oself:customer+"' "+cWhere
	EndIf
	
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
		lGrava  := .T.
		
		If (oself:type == 'v' .And. cStatus != 'Atrasado')
			lGrava := .F.
		EndIf
		
		If lGrava
			aListAux[nAux]['id']	            := Encode64(cIdAux)
			aListAux[nAux]['branch_invoice']    := Alltrim(EncodeUTF8((cAliasTMP)->F2_FILIAL))
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
		EndIf

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
