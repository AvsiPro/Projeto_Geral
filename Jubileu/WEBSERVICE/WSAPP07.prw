#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP07 Description "pedidos API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData searchKey AS String	Optional
	WsData byId		 AS Boolean	Optional
	WsData type		 As String	Optional
	WsData token     AS String

WsMethod GET orders;
    Description 'Lista de pedidos';
    WsSyntax '/WSAPP07';
    Path '/WSAPP07';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de pedidos.

@param	SearchKey  , caracter, chave de pesquisa utilizada em diversos campos
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		byId	   , logico  , indica se deve filtrar apenas pelo codigo
		type 	   , C=Cliente / V=Vendedor
		token      , caracter, token vendedor que usara como filtro

@return cResponse  , caracter, JSON contendo a lista de pedidos

/*/

WsMethod GET orders WsReceive searchKey, page, pageSize, token, type WsRest WSAPP07
	Local lRet:= .T.
	lRet := orders( self )
Return( lRet )

Static Function orders( oSelf )

Local aListAux	    := {}
Local aC6Aux		:= {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local cSearch		:= ''
Local cWhere		:= ''
Local nAux			:= 0
Local nAux1			:= 0

Default oself:searchKey := ''
Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:byId		:=.F.
Default oself:token  	:=''
Default oself:type  	:='V'
	
    RpcSetType(3)
    RPCSetEnv('01','0101')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := ''

	// Tratativas para realizar os filtros
	If !Empty(oself:searchKey) //se tiver chave de busca no request
		cSearch := Upper( oself:SearchKey )

		If oself:byId //se filtra somente por ID
			cWhere += " AND SC5.C5_NUM = '"	+ cSearch + "'"
		Else//busca chave nos campos abaixo
			cWhere += " AND ( SC5.C5_NUM LIKE 	'%"	+ cSearch + "%' OR "
			cWhere	+= " SA1.A1_NOME LIKE 		'%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SA1.A1_NREDUZ LIKE 	'%" + FwNoAccent( cSearch ) + "%' OR "
			cWhere	+= " SA1.A1_NREDUZ LIKE 	'%" + cSearch  + "%' OR "
			cWhere	+= " SA1.A1_CGC LIKE	 	'%" + StrTran(StrTran(StrTran(StrTran(cSearch, " ", ""), "-", ""), ".", ""), "/", "")  + "%' OR "
			cWhere	+= " SA1.A1_NOME LIKE 		'%" + cSearch + "%' ) "
		EndIf
	EndIf

	cQuery := " SELECT SC5.*, SA1.* " 
	cQuery += " FROM   " + RetSQLName("SC5") + " SC5   " 

	If oself:type == 'V'
		cQuery += " INNER JOIN " + RetSQLName("SA3") + " SA3 "
		cQuery += " 	   ON A3_FILIAL = '"+FwxFilial("SA3")+"' " 
		cQuery += "        AND A3_COD = C5_VEND1   " 
		cQuery += "        AND SA3.D_E_L_E_T_ = ' '   "
	EndIf
	
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 "
	cQuery += " 	   ON A1_FILIAL = '"+FwxFilial("SA1")+"' " 
	cQuery += "        AND A1_COD = C5_CLIENTE   " 
	cQuery += "        AND A1_LOJA = C5_LOJACLI   " 
	cQuery += "        AND SA1.D_E_L_E_T_ = ' '   " 
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '   " +cWhere
	cQuery += " 	   AND UPPER("+If(oself:type == 'V', 'A3_TOKEN', 'A1_TOKEN' )+") = '"+Upper(oself:token)+"' "
	cQuery += " ORDER BY C5_EMISSAO DESC, C5_NUM DESC"
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
	
	MPSysOpenQuery(cQuery, cAliasTMP)

	DbSelectArea("SC6")
	SC6->(DBSetOrder(1))

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		cIdAux := '{"SC5",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->C5_NUM))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_COD))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_LOJA))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->C5_EMISSAO))+'"'+;
		'}

		cNotaC6 := ''
		cSeriC6 := ''
		nQtdFat := 0
		nVlrFat := 0
		nQtdVen := 0
		nVlrVen := 0
		nAux1   := 0
		aC6Aux  := {}

		SC6->(DBGoTop())
		If SC6->(MsSeek((cAliasTMP)->C5_FILIAL+(cAliasTMP)->C5_NUM))
			While SC6->(!EoF()) .And. SC6->C6_FILIAL == (cAliasTMP)->C5_FILIAL .AND. SC6->C6_NUM == (cAliasTMP)->C5_NUM

				nAux1++
				aAdd(aC6Aux, JsonObject():New())

				cIdAuxC6 := '{"SC6",'+;
					'"'+Alltrim(EncodeUTF8(SC6->C6_NUM))+'",'+;
					'"'+Alltrim(EncodeUTF8(SC6->C6_PRODUTO))+'"'+;
				'}

				aC6Aux[nAux1]['id']	            	:= Encode64(cIdAuxC6)
				aC6Aux[nAux1]['product']	    	:= fRemoveCarc(SC6->C6_PRODUTO)
				aC6Aux[nAux1]['description']		:= fRemoveCarc(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC"))
				aC6Aux[nAux1]['sold_amount']		:= SC6->C6_QTDVEN
				aC6Aux[nAux1]['value_sold']	    	:= SC6->C6_PRCVEN
				aC6Aux[nAux1]['invoiced_quantity']	:= SC6->C6_QTDENT
				aC6Aux[nAux1]['billed_amount']	   	:= Iif(SC6->C6_QTDENT > 0, SC6->C6_QTDENT * SC6->C6_PRCVEN, 0)

				nQtdFat += SC6->C6_QTDENT
				nVlrFat += Iif(SC6->C6_QTDENT > 0, SC6->C6_QTDENT * SC6->C6_PRCVEN, 0)
				nQtdVen += SC6->C6_QTDVEN
				nVlrVen += SC6->C6_VALOR

				If !Empty(SC6->C6_NOTA) .And. Empty(cNotaC6)
					cNotaC6 := SC6->C6_NOTA 
					cSeriC6 := SC6->C6_SERIE
				EndIf 
				SC6->(DBSkip())
			EndDo
		EndIf

		SC6->(DbCloseArea())

		cNota  := Iif('XXX' $ (cAliasTMP)->C5_NOTA,cNotaC6,(cAliasTMP)->C5_NOTA)
		cSerie := Iif('XXX' $ (cAliasTMP)->C5_NOTA,cSeriC6,(cAliasTMP)->C5_SERIE)
		cDtFat := ''

		If !Empty(cNota)
			cDtFat := Posicione("SF2",1,(cAliasTMP)->C5_FILIAL + cNota + cSerie,"F2_EMISSAO")
		EndIf 

		aListAux[nAux]['id']	                := Encode64(cIdAux)
		aListAux[nAux]['document']	            := Alltrim(EncodeUTF8((cAliasTMP)->C5_NUM))
		aListAux[nAux]['status']     		    := Iif(!Empty(cNota),'Faturado em '+cValToChar(cDtFat),(Iif((cAliasTMP)->C5_OK == "3","Pendencias","Em Aberto")))
		aListAux[nAux]['customer']			    := Alltrim(EncodeUTF8((cAliasTMP)->A1_COD))
		aListAux[nAux]['customer_name']	        := Alltrim(EncodeUTF8((cAliasTMP)->A1_NOME))
		aListAux[nAux]['customer_cnpj']	        := Alltrim(EncodeUTF8((cAliasTMP)->A1_CGC))
		aListAux[nAux]['issue_date']	        := Alltrim(EncodeUTF8((cAliasTMP)->C5_EMISSAO))
		aListAux[nAux]['invoice']	    	    := Alltrim(EncodeUTF8(cNota))
		aListAux[nAux]['invoice_series']	    := Alltrim(EncodeUTF8(cSerie))
		aListAux[nAux]['total_quantity_sold']   := nQtdVen
		aListAux[nAux]['total_amount_sold']     := nVlrVen
		aListAux[nAux]['total_amount_invoiced']	:= nQtdFat
		aListAux[nAux]['total_billed_amount']	:= nVlrFat
		aListAux[nAux]['items']					:= aC6Aux

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
