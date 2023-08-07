#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP19 Description "tabelas API" FORMAT APPLICATION_JSON
	
WsMethod GET orders;
    Description 'Lista de tabelas';
    WsSyntax '/WSAPP19';
    Path '/WSAPP19';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de tabelas.

@param	SearchKey  , caracter, chave de pesquisa utilizada em diversos campos
		Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		
@return cResponse  , caracter, JSON contendo a lista de tabelas

/*/

WsMethod GET orders WsReceive WsRest WSAPP19
	Local lRet:= .T.
	lRet := orders( self )
Return( lRet )

Static Function orders( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local cWhere		:= ''
Local nAux			:= 0
	
    RpcSetType(3)
    RPCSetEnv('01','0801')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()
    cWhere    := ''

	// Tratativas para realizar os filtros
	
	cQuery := " SELECT DA0_CODTAB,DA0_DESCRI " 
	cQuery += " FROM   " + RetSQLName("DA0") + " DA0   " 

	cQuery += " WHERE DA0.D_E_L_E_T_ = ' '   " +cWhere
	cQuery += " AND (DA0_DATATE=' ' OR DA0_DATATE>='"+dtos(ddatabase)+"') AND DA0_ATIVO='1'"
    cQuery += " ORDER BY 1"
	
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		aListAux[nAux]['id']	                := Alltrim((cAliasTMP)->DA0_CODTAB)
		aListAux[nAux]['description']           := Alltrim(EncodeUTF8((cAliasTMP)->DA0_DESCRI))
		

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
