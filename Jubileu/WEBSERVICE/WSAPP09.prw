#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP09 Description "chamadosXnotas API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData token     AS String
	WsData product   AS String

WsMethod GET warrantyxinvoices;
    Description 'Lista de chamadosXnotas';
    WsSyntax '/WSAPP09';
    Path '/WSAPP09';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de chamadosXnotas.

@param	Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		token      , caracter, token vendedor que usara como filtro
		product    , caracter, codigo do produto

@return cResponse  , caracter, JSON contendo a lista de chamadosXnotas
/*/

WsMethod GET warrantyxinvoices WsReceive page, pageSize, token, product WsRest WSAPP09
	Local lRet:= .T.
	lRet := warrantyxinvoices( self )
Return( lRet )

Static Function warrantyxinvoices( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local nAux			:= 0

Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:token  	:= ''
Default oself:product   := ''
	
    RpcSetType(3)
    RPCSetEnv('01','0101')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

	cQuery := " SELECT D2_DOC,D2_SERIE,D2_QUANT,D2_PRCVEN,D2_CF,D2_FILIAL,D2_EMISSAO,D2_COD,D2_ITEM,X5_DESCRI,D2_BASEICM,D2_CLIENTE,D2_LOJA, "
	cQuery += " D2_VALICM,D2_VALIPI,F2_CHVNFE,M0_NOMECOM,M0_ENDENT,M0_COMPENT,M0_BAIRENT,M0_CIDENT,M0_ESTENT,M0_CGC,M0_INSC,M0_CEPENT " 
	cQuery += " FROM   " + RetSQLName("SD2") + " D2   " 
	cQuery += " INNER JOIN " + RetSQLName("SF2") + " F2  " 
	cQuery += "        ON F2_FILIAL=D2_FILIAL "
	cQuery += "        AND F2_DOC=D2_DOC   " 
	cQuery += "        AND F2_SERIE=D2_SERIE   " 
	cQuery += "        AND F2_CLIENT=D2_CLIENTE   " 
	cQuery += "        AND F2_LOJA=D2_LOJA   " 
	cQuery += "        AND F2.D_E_L_E_T_=' '   " 
	cQuery += " INNER JOIN " + RetSQLName("SX5") + " X5 "
	cQuery += "        ON X5_FILIAL='"+FWxFilial('SX5')+"' "
	cQuery += "        AND X5_TABELA='13'   " 
	cQuery += "        AND X5_CHAVE=D2_CF   " 
	cQuery += "        AND X5.D_E_L_E_T_=' '   " 
	cQuery += " INNER JOIN SYS_COMPANY M0 " 
	cQuery += "        ON M0_CODIGO='01' "
	cQuery += "        AND M0_CODFIL=D2_FILIAL   " 
	cQuery += "        AND M0.D_E_L_E_T_=' '   " 
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 "
	cQuery += "        ON A1_FILIAL='"+FWxFilial('SA1')+"' "
	cQuery += "        AND A1_COD = D2_CLIENTE   " 
	cQuery += "        AND A1_LOJA = D2_LOJA   " 
	cQuery += "        AND UPPER(A1_TOKEN) = '"+Upper(oself:token)+"'   " 
	cQuery += "        AND SA1.D_E_L_E_T_ = ' '   " 
	cQuery += " WHERE  D2_COD='"+oself:product+"'   " 
	cQuery += " ORDER BY " + SqlOrder(SD2->(IndexKey(1)))
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
			
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!Eof())
	    cKeyZ50 := FWxFilial('Z50');
			+AvKey((cAliasTMP)->D2_DOC,'Z50_NOTA');
			+AvKey((cAliasTMP)->D2_CLIENTE,'Z50_CODCLI');
			+AvKey((cAliasTMP)->D2_LOJA,'Z50_LOJCLI');
			+AvKey((cAliasTMP)->D2_EMISSAO,'Z50_EMISSA');
			+AvKey((cAliasTMP)->D2_COD,'Z50_PROD')

		If !Z50->(DbSeek(cKeyZ50))	
			nAux++
			aAdd(aListAux , JsonObject():New() )

			cIdAux := '{"SD2",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->D2_DOC))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->D2_SERIE))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->D2_COD))+'",'+;
				'"'+Alltrim(EncodeUTF8((cAliasTMP)->D2_EMISSAO))+'"'+;
			'}

			aListAux[nAux]['id']	          		:= Encode64(cIdAux)
			aListAux[nAux]['invoice']	      		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_DOC))
			aListAux[nAux]['invoice_series']  		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_SERIE))
			aListAux[nAux]['emission']	      		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_EMISSAO))
			aListAux[nAux]['quantity']		  		:= (cAliasTMP)->D2_QUANT
			aListAux[nAux]['price']	      	  		:= (cAliasTMP)->D2_PRCVEN
			aListAux[nAux]['desc_cfop']	      		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_CF+"-"+Alltrim((cAliasTMP)->X5_DESCRI)))
			aListAux[nAux]['base_icm']	      		:= (cAliasTMP)->D2_BASEICM
			aListAux[nAux]['value_icm']	      		:= (cAliasTMP)->D2_VALICM
			aListAux[nAux]['value_ipi']	      		:= (cAliasTMP)->D2_VALIPI
			aListAux[nAux]['key_nfe']	      		:= Alltrim(EncodeUTF8((cAliasTMP)->F2_CHVNFE))
			aListAux[nAux]['company_name'] 	  		:= Alltrim(EncodeUTF8((cAliasTMP)->M0_NOMECOM))
			aListAux[nAux]['company_ender']	  		:= Alltrim(EncodeUTF8(Alltrim((cAliasTMP)->M0_ENDENT)+', '+Alltrim((cAliasTMP)->M0_COMPENT)))
			aListAux[nAux]['company_district']		:= Alltrim(EncodeUTF8((cAliasTMP)->M0_BAIRENT))
			aListAux[nAux]['company_city']	  		:= Alltrim(EncodeUTF8((cAliasTMP)->M0_CIDENT))
			aListAux[nAux]['company_cep']  	  		:= Alltrim(EncodeUTF8((cAliasTMP)->M0_CEPENT))
			aListAux[nAux]['company_state']	  		:= Alltrim(EncodeUTF8((cAliasTMP)->M0_ESTENT))
			aListAux[nAux]['company_cnpj']	  		:= Alltrim(EncodeUTF8((cAliasTMP)->M0_CGC))
			aListAux[nAux]['company_state_reg']	    := Alltrim(EncodeUTF8((cAliasTMP)->M0_INSC))
			aListAux[nAux]['branch_invoice']	    := Alltrim(EncodeUTF8((cAliasTMP)->D2_FILIAL))
			aListAux[nAux]['product']	      	    := Alltrim(EncodeUTF8((cAliasTMP)->D2_COD))
			aListAux[nAux]['item']	      	  		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_ITEM))
			aListAux[nAux]['customer']     	  		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_CLIENTE))
			aListAux[nAux]['customer_branch']  		:= Alltrim(EncodeUTF8((cAliasTMP)->D2_LOJA))
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
