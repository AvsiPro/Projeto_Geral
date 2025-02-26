#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP08 Description "faturamento API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData token     AS String
	WsData type      AS String

WsMethod GET invoices;
    Description 'Lista de faturamento';
    WsSyntax '/WSAPP08';
    Path '/WSAPP08';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de faturamento.

@param	Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		token      , caracter, token vendedor que usara como filtro
		type 	   , caracter, tipo cliente ou vendedor

@return cResponse  , caracter, JSON contendo a lista de faturamento

/*/

WsMethod GET invoices WsReceive page, pageSize, token, type WsRest WSAPP08
	Local lRet:= .T.
	lRet := invoices( self )
Return( lRet )

Static Function invoices( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local nAux			:= 0

Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:token  	:= ''
Default oself:type  	:= ''
	
    RpcSetType(3)
    RPCSetEnv('01','0101')

	conout(Alltrim(Upper(oself:token)))
	conout(oself:token)
	
    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

	cQuery := " SELECT * FROM " + RetSQLName("SF2") + " SF2 "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cQuery += " 	ON SA1.A1_FILIAL='"+FwxFilial("SA1")+"' "
	cQuery += " 	AND SA1.A1_COD = F2_CLIENTE "
	cQuery += " 	AND SA1.A1_LOJA = F2_LOJA "
	cQuery += " 	AND SA1.D_E_L_E_T_=' ' "
	
	If oself:type == 'C'
		cQuery += " AND RTRIM(UPPER(A1_TOKEN)) = '"+Alltrim(Upper(oself:token))+"' "
	EndIf

	If oself:type == 'V'
		cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 "
		cQuery += " 	ON A3_FILIAL = '"+FwxFilial("SA3")+"' "
		cQuery += " 	AND A3_COD = F2_VEND1 "
		cQuery += " 	AND SA3.D_E_L_E_T_ = ' '   "
		cQuery += " AND UPPER(A3_TOKEN) = '"+Upper(oself:token)+"' "
	EndIf

	cQuery += " WHERE SF2.D_E_L_E_T_ = ' '  "
	cQuery += " ORDER BY " + SqlOrder(SF2->(IndexKey(1)))
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "

	conout(cQuery)
			
	MPSysOpenQuery(cQuery, cAliasTMP)

	DbSelectArea("SD2")
	SD2->(DBSetOrder(3))

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		cIdAux := '{"SF2",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->F2_DOC))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->F2_SERIE))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->F2_EMISSAO))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_COD))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_LOJA))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))+'"'+;
		'}

		nAux1   := 0
		aD2Aux  := {}

		SD2->(DBGoTop())
		If SD2->(MsSeek(cIndexD2 := (cAliasTMP)->F2_FILIAL+(cAliasTMP)->F2_DOC+(cAliasTMP)->F2_SERIE+(cAliasTMP)->F2_CLIENTE+(cAliasTMP)->F2_LOJA))
			While SD2->(!EoF()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cIndexD2

				nAux1++
				aAdd(aD2Aux, JsonObject():New())

				cIdAuxD2 := '{"SD2",'+;
					'"'+Alltrim(EncodeUTF8(SD2->D2_DOC))+'",'+;
					'"'+Alltrim(EncodeUTF8(SD2->D2_COD))+'"'+;
				'}

				aD2Aux[nAux1]['id']	            := Encode64(cIdAuxD2)
				aD2Aux[nAux1]['product']	    := fRemoveCarc(SD2->D2_COD)
				aD2Aux[nAux1]['description']	:= fRemoveCarc(Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC"))
				aD2Aux[nAux1]['quantity']		:= SD2->D2_QUANT
				aD2Aux[nAux1]['unitary_value']	:= SD2->D2_PRCVEN
				aD2Aux[nAux1]['billed_amount']	:= SD2->D2_TOTAL

				SD2->(DBSkip())
			EndDo
		EndIf

		aListAux[nAux]['id']	                := Encode64(cIdAux)
		aListAux[nAux]['branch_invoice']	    := Alltrim(EncodeUTF8((cAliasTMP)->F2_FILIAL))
		aListAux[nAux]['invoice']	            := Alltrim(EncodeUTF8((cAliasTMP)->F2_DOC))
		aListAux[nAux]['invoice_series']     	:= Alltrim(EncodeUTF8((cAliasTMP)->F2_SERIE))
		aListAux[nAux]['customer']			    := Alltrim(EncodeUTF8((cAliasTMP)->A1_COD))
		aListAux[nAux]['customer_name']	        := Alltrim(EncodeUTF8((cAliasTMP)->A1_NOME))
		aListAux[nAux]['customer_cnpj']	        := Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))
		aListAux[nAux]['emission']	        	:= Alltrim(EncodeUTF8((cAliasTMP)->F2_EMISSAO))
		aListAux[nAux]['items']					:= aD2Aux

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


Static Function fRemoveCarc(cWord)

    cWord := FwNoAccent(cWord)
    cWord := FwCutOff(cWord)
    cWord := strtran(cWord,"ã","a")
    cWord := strtran(cWord,"º"," ")
    cWord := strtran(cWord,"%"," ")
    cWord := strtran(cWord,"*"," ")     
    cWord := strtran(cWord,"&"," ")
    cWord := strtran(cWord,"$"," ")
    cWord := strtran(cWord,"#"," ")
    cWord := strtran(cWord,"§"," ") 
    cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,","," ")
    cWord := strtran(cWord,"."," ")
    cWord := StrTran(cWord, "'", " ")
    cWord := StrTran(cWord, "#", " ")
    cWord := StrTran(cWord, "%", " ")
    cWord := StrTran(cWord, "*", " ")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, "!", " ")
    cWord := StrTran(cWord, "@", " ")
    cWord := StrTran(cWord, "$", " ")
    cWord := StrTran(cWord, "(", " ")
    cWord := StrTran(cWord, ")", " ")
    cWord := StrTran(cWord, "_", " ")
    cWord := StrTran(cWord, "+", " ")
    cWord := StrTran(cWord, "{", " ")
    cWord := StrTran(cWord, "}", " ")
    cWord := StrTran(cWord, "[", " ")
    cWord := StrTran(cWord, "]", " ")
    cWord := StrTran(cWord, ".", " ")
    cWord := StrTran(cWord, "|", " ")
    cWord := StrTran(cWord, ";", " ")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := strtran(cWord,""+'"'+""," ")
    cWord := RTrim(cWord)
Return cWord
