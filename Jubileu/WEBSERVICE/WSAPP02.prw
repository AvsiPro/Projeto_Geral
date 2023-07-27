#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP02 Description "Clientes API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData byId		 AS Boolean	Optional
	WsData token	 AS String  Optional
	WsData customer  AS Boolean	Optional

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
		token      , caracter, token vendedor
		customer   , logico, indica se a pesquisa e do cliente

@return cResponse  , caracter, JSON contendo a lista de clientes

/*/

WsMethod GET customers WsReceive searchKey, page, pageSize, token, customer WsRest WSAPP02
	
	Local lRet:= .T.
	lRet := Customers( self )

Return( lRet )

Static Function Customers( oSelf )

Local aListCli	    := {}
Local oJsonAux	    := Nil
Local cJsonCli		:= ''
Local cSearch		:= ''
Local cVend 		:= ''
Local cWhere		:= ''
Local nAux			:= 0
Local aRegiao 		:=	{}
Local nCont 

Default oself:searchKey :=	''
Default oself:page		:=	1
Default oself:pageSize	:= 	20
Default oself:byId		:=	.F.
Default oself:customer  :=	.F.
Default oself:token		:=	''

	RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv('01','0801')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := "AND SA1.A1_FILIAL = '"+FWxFilial('SA1')+"'"

	// Tratativas para realizar os filtros
	If !Empty(oself:searchKey) //se tiver chave de busca no request
		cSearch := Upper( oself:SearchKey )
		cVend   := fVendToken( oself:token )
		

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

			If !Empty(cVend)
				aRegiao := BuscaRegiao(cVend)

				/*IF len(aRegiao) > 0
					cRegiao := ""
					nCont   := 0
					cVirgula:= ""
					For nCont := 1 to len(aRegiao)
						cRegiao += cVirgula + aRegiao[nCont]
						cVirgula := "','"
						
					Next nCont
					cWhere += " AND SA1.A1_EST IN('"+upper(cRegiao)+"')"
				EndIf*/
				
			EndIf
		EndIf

	ElseIf !Empty(oself:token) .And. !oself:customer //se tiver chave de busca no request
		cVend := fVendToken( oself:token )

		If !Empty(cVend)
			aRegiao := BuscaRegiao(cVend)
			
			/*IF len(aRegiao) > 0
				cRegiao := ""
				nCont   := 0
				cVirgula:= ""
				For nCont := 1 to len(aRegiao)
					cRegiao += cVirgula + aRegiao[nCont]
					cVirgula := "','"
					
				Next nCont
				cWhere += " AND SA1.A1_EST IN('"+upper(cRegiao)+"')"
			EndIf*/
			
		EndIf
	EndIf

	cQuery := " SELECT A1_COD, A1_LOJA, A1_END, A1_BAIRRO, A1_COMPLEM, A1_CGC, A1_INSCR, "
	cQuery += " A1_NOME, A1_NREDUZ, A1_MUN, A1_EST, A1_CEP, A1_CONTATO, A1_EMAIL, A1_DDD, "
	cQuery += " A1_TEL, A1_ULTCOM, A1_PRICOM, A1_RISCO, A1_LC, A1_SALDUP, A1_MCOMPRA, "
	cQuery += " A1_NROCOM, A1_ATR, A1_MATR, A1_PAGATR, A1_COND "
	cQuery += " FROM "+RetSqlName('SA1')+" SA1 "
	cQuery += " WHERE SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.D_E_L_E_T_ = ' ' "
	
	If !oself:customer
		cQuery += " AND A1_VEND IN('      ','"+cVend+"')"
	EndIf

	cQuery += " AND SA1.A1_MSBLQL <> '1' "+cWhere

	If !oself:byId
		cQuery += " ORDER BY " + SqlOrder(SA1->(IndexKey(1)))
		cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
	EndIf
	
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListCli , JsonObject():New() )

		cIdAux := '{"SA1",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_COD))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))+'"'+;
		'}'

		cCond := Iif(Empty((cAliasTMP)->A1_COND),'000',(cAliasTMP)->A1_COND)
		
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
				(cAliasTMP)->A1_PAGATR,;
				cCond,;
				Posicione('SE4',1,FwxFilial('SE4')+cCond, 'Alltrim(E4_COND)'),;
				If(Ascan(aRegiao,{|x| Alltrim(x) == Alltrim((cAliasTMP)->A1_EST)})==0,.F.,.T.);
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
			fConsulBraApi(cSearch, @aListCli,aRegiao)

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


Static Function fConsulBraApi(cSearch, aListCli,aRegiao)
			
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
				0,;
				'',;
				'',;
				If(Ascan(aRegiao,{|x| Alltrim(x) == Alltrim(upper(oJsonCNPJ["uf"]))})==0,.F.,.T.);
			};
		)
	EndIf

Return


Static Function fGeraResult(aListCli, nAux, aListAux)

	aListCli[nAux]['id']	            	:= aListAux[1]
	aListCli[nAux]['code']	            	:= aListAux[2]
	aListCli[nAux]['branch']            	:= aListAux[3]
	aListCli[nAux]['address']           	:= aListAux[4]
	aListCli[nAux]['district']          	:= aListAux[5]
	aListCli[nAux]['complement']        	:= aListAux[6]
	aListCli[nAux]['cnpj']              	:= aListAux[7]
	aListCli[nAux]['state_regist']      	:= aListAux[8]
	aListCli[nAux]['name']              	:= aListAux[9]
	aListCli[nAux]['short_name']        	:= aListAux[10]
	aListCli[nAux]['city']              	:= aListAux[11]
	aListCli[nAux]['uf']                	:= aListAux[12]
	aListCli[nAux]['cep']               	:= aListAux[13]
	aListCli[nAux]['contact']           	:= aListAux[14]
	aListCli[nAux]['email']             	:= aListAux[15]
	aListCli[nAux]['phone']             	:= aListAux[16]
	aListCli[nAux]['last_purchase']     	:= aListAux[17]
	aListCli[nAux]['first_purchase']    	:= aListAux[18]
	aListCli[nAux]['risk']              	:= aListAux[19]
	aListCli[nAux]['credit_limit']      	:= aListAux[20]
	aListCli[nAux]['balance']           	:= aListAux[21]
	aListCli[nAux]['biggest_purchase']  	:= aListAux[22]
	aListCli[nAux]['amount_purchases']  	:= aListAux[23]
	aListCli[nAux]['amount_delays']     	:= aListAux[24]
	aListCli[nAux]['biggest_delays']    	:= aListAux[25]
	aListCli[nAux]['late_payments']     	:= aListAux[26]
	aListCli[nAux]['financial']				:= fTitulos(aListAux[2],aListAux[3])
	aListCli[nAux]['another_address']   	:= ''
	aListCli[nAux]['another_cep']   		:= ''
	aListCli[nAux]['another_district']  	:= ''
	aListCli[nAux]['payment']  				:= aListAux[27]
	aListCli[nAux]['payment_description']  	:= aListAux[28]
	aListCli[nAux]['allowed_region']  	  	:= aListAux[29]

Return


/*/{Protheus.doc} fTitulos
   @description: Verifica se possui titulos em aberto
   @type: Static Function
   @author: Felipe Mayer
   @since: 18/06/2023
/*/
Static Function fTitulos(cCodeA1, cLojaA1)

Local nAux 	   := 0
Local aListAux := {}
Local aArea    := GetArea()

	cQuery := " SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,"
	cQuery += " E1_EMISSAO,E1_VENCREA,E1_VALOR,E1_BAIXA,A1_NOME,A1_CGC "
	cQuery += " FROM "+RetSqlName('SE1')+" SE1 "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cQuery += " 	ON SA1.A1_FILIAL='"+FwxFilial("SA1")+"' "
	cQuery += " 	AND SA1.A1_COD = E1_CLIENTE "
	cQuery += " 	AND SA1.A1_LOJA = E1_LOJA "
	cQuery += " 	AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SE1.D_E_L_E_T_ = ' ' "
	cQuery += "		AND SE1.E1_BAIXA = ' ' "
	cQuery += "		AND SE1.E1_VENCREA < '"+DToS(Date())+"' "
	cQuery += " 	AND SA1.A1_COD = '"+cCodeA1+"' "
	cQuery += " 	AND SA1.A1_LOJA = '"+cLojaA1+"' "

	cAliasE1 := GetNextAlias()
	MPSysOpenQuery(cQuery, cAliasE1)

	While (cAliasE1)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		cIdAux := '{"SE1",'+;
			'"'+Alltrim(EncodeUTF8((cAliasE1)->E1_NUM))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasE1)->E1_PARCELA))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasE1)->E1_PREFIXO))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasE1)->E1_CLIENTE))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasE1)->E1_LOJA))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasE1)->E1_VENCREA))+'"'+;
		'}

		aListAux[nAux]['id']	            := Encode64(cIdAux)
		aListAux[nAux]['document']	        := Alltrim(EncodeUTF8((cAliasE1)->E1_NUM))
		aListAux[nAux]['prefix']     		:= Alltrim(EncodeUTF8((cAliasE1)->E1_PREFIXO))
		aListAux[nAux]['installments']		:= Alltrim(EncodeUTF8((cAliasE1)->E1_PARCELA))
		aListAux[nAux]['customer']			:= Alltrim(EncodeUTF8((cAliasE1)->E1_CLIENTE))
		aListAux[nAux]['emission']			:= Alltrim(EncodeUTF8((cAliasE1)->E1_EMISSAO))
		aListAux[nAux]['expiration']		:= Alltrim(EncodeUTF8((cAliasE1)->E1_VENCREA))
		aListAux[nAux]['value']				:= (cAliasE1)->E1_VALOR
		aListAux[nAux]['status']			:= EncodeUTF8('Atrasado')
		aListAux[nAux]['customerName']		:= Alltrim(EncodeUTF8((cAliasE1)->A1_NOME))
		aListAux[nAux]['customerCNPJ']		:= Alltrim(EncodeUTF8((cAliasE1)->A1_CGC))

		(cAliasE1)->(DBSkip())
	EndDo

	(cAliasE1)->(DbCloseArea())
	
	RestArea(aArea)

Return aListAux

/*/{Protheus.doc} BuscaRegiao
	(long_description)
	@type  Static Function
	@author user
	@since 19/06/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
STATIC Function BuscaRegiao(cVendedor)

Local aArray := {}
Local aAux   := {}
Local cQuery
Local nCont  := 0

cQuery := "SELECT Z30_REGIAO FROM "+RetSQLName("Z30")
cQuery += " WHERE Z30_CODVEN='"+cVendedor+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	aAux := Strtokarr(Alltrim(TRB->Z30_REGIAO),"/")
	For nCont := 1 to len(aAux)
		Aadd(aArray,aAux[nCont])
	Next nCont
	Dbskip()
EndDo
	
conout(cvaltochar(aArray))
Return(aArray)


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
