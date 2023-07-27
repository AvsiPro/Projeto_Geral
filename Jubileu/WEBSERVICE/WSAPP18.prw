#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP18 Description "chamados API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData token     AS String
    WsData ano		 AS Integer	Optional
	WsData mes       AS Integer	Optional

WsMethod GET dailysales;
    Description 'Venda Diaria';
    WsSyntax '/WSAPP18';
    Path '/WSAPP18';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a venda diária do vendedor.

@param	Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		token      , caracter, token vendedor que usara como filtro
        ano        , numerico, ano de consulta
        mes        , numerico, mes de consulta

@return cResponse  , caracter, JSON contendo a venda diária do vendedor
/*/

WsMethod GET dailysales WsReceive page, pageSize, token, ano, mes WsRest WSAPP18
	Local lRet:= .T.
	lRet := dailysales( self )
Return( lRet )

Static function dailysales( oSelf )

Local oJsonAux	    := Nil
Local aListCli      := {}
Local cVend 
Local cQuery 
Local cPriDia
Local cUltDia
Local nAux          :=  0

Default oself:page		:=	1
Default oself:pageSize	:= 	20
Default oself:ano		:=  ''
Default oself:mes       :=	''
Default oself:token		:=	''

RpcClearEnv()
RpcSetType(3)
RPCSetEnv('01','0801')

    If !Empty(oself:ano) .And. !Empty(oself:mes)
        cPriDia := cvaltochar(oself:ano)+cvaltochar(oself:mes)+'01'
        cUltDia := cvaltochar(lastday(stod(cPriDia)))
    EndIf

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

    If !Empty(oself:token)
        cVend   := fVendToken( oself:token )

        cQuery := "SELECT C5_EMISSAO,SUM(C6_VALOR) AS VALOR"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6.D_E_L_E_T_=' '"
        cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZ'" 
        cQuery += " AND C5_VEND1='000005'"
        cQuery += " AND C5_EMISSAO BETWEEN '20230701' AND '20230727'"
        cQuery += " GROUP BY C5_EMISSAO"
        cQuery += " ORDER BY 1"
        cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "

        MPSysOpenQuery(cQuery, cAliasTMP)

	    While (cAliasTMP)->(!Eof())
            nAux++
            aAdd(aListCli , JsonObject():New() )
            conout('linha '+cvaltochar(nAux))
            fGeraResult(;
			@aListCli,;
			nAux,;
			{;
                day(stod((cAliasTMP)->C5_EMISSAO)),;
                (cAliasTMP)->VALOR;
            })

            (cAliasTMP)->(DBSkip())
        EndDo

        (cAliasTMP)->(DBCloseArea())

        oStatus := JsonObject():New()

        conout(cvaltochar(len(aListCli)))
        
        If Len(aListCli) > 0
            oStatus['code']    := '#200'
            oStatus['message'] := 'sucesso'

        Else
            oStatus['code']    := '#400'
            oStatus['message'] := 'nao encontrado'
        EndIf 

    EndIf 

    oJsonAux['status'] := oStatus
	oJsonAux['result'] := aListCli

	cJsonCli := FwJsonSerialize(oJsonAux)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonCli)

    RpcClearEnv()

Return

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

Static Function fGeraResult(aListCli, nAux, aListAux)

	aListCli[nAux]['id']	            	:= aListAux[1]
	aListCli[nAux]['code']	            	:= aListAux[2]
	

Return
