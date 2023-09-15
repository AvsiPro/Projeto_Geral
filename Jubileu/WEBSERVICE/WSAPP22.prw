#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP22 Description "painel financeiro semanal API" FORMAT APPLICATION_JSON
	WsData ano AS Integer Optional
	WsData mes AS Integer Optional

WsMethod GET painelfinanceiroweek;
    Description 'Lista de painel financeiro semanal';
    WsSyntax '/WSAPP22';
    Path '/WSAPP22';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de painel financeiro semanal.

@param	
	ano , numerico, ano de consulta
	mes , numerico, mes de consulta
		
@return cResponse  , caracter, JSON contendo a lista de painel financeiro semanal

/*/

WsMethod GET painelfinanceiroweek WsReceive ano, mes WsRest WSAPP22
	Local lRet:= .T.
	lRet := painelfinanceiroweek( self )
Return( lRet )

Static Function painelfinanceiroweek( oSelf )

Local aListAux1	:= {}
Local aListAux2	:= {}
Local aListAux3	:= {}
Local oJsonAux	:= Nil
Local cJsonAux	:= ''
Local cUltDia	:= ''
Local cPridMA	:= ''
Local nAux		:= 0


Default oself:ano :=  2023
Default oself:mes :=	7

	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv('01', '0801')

	ndias := dow(ddatabase) - 2
	nSexta := 6 - dow(ddatabase)

	If nDias > 0
		cPridMA := dtos(ddatabase-ndias)
	else
		cPridMA := dtos(ddatabase)
	EndIF 

	cUltDia := dtos(ddatabase)
	cUltSem := dtos(ddatabase+nSexta)

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

	cQuery := " SELECT   " 
	cQuery += "   E81.E8_BANCO AS BANCO,E81.E8_AGENCIA AS AGENCIA,E81.E8_CONTA AS CONTA,"
    cQuery += "   E81.E8_DTSALAT AS DATASALDO,E81.E8_SALATUA AS SALDO  " 
	cQuery += "   FROM " + RetSQLName("SE8") + " E81 " 
	cQuery += "   WHERE  E81.E8_FILIAL ='"+FWxFilial('SE8')+"'   " 
	cQuery += " 		 AND E81.D_E_L_E_T_=' '   " 
	cQuery += "         AND E81.E8_DTSALAT IN((SELECT MAX(E82.E8_DTSALAT) "
    cQuery += "         FROM " + RetSQLName("SE8") + " E82 "
    cQuery += "         WHERE E82.E8_FILIAL=E81.E8_FILIAL AND E82.E8_BANCO=E81.E8_BANCO"
    cQuery += "         AND E82.E8_AGENCIA=E81.E8_AGENCIA AND E82.E8_CONTA=E81.E8_CONTA ))"
	cQuery += " GROUP BY E81.E8_BANCO,E81.E8_AGENCIA,E81.E8_CONTA,E8_DTSALAT,E81.E8_SALATUA " 
	
	MPSysOpenQuery(cQuery, cAliasTMP)

    nAux := 0

	While (cAliasTMP)->(!EoF())
		nAux++
		aAdd(aListAux1 , JsonObject():New() )

		aListAux1[nAux]['banco']    :=  (cAliasTMP)->BANCO
		aListAux1[nAux]['agencia']  :=  (cAliasTMP)->AGENCIA
		aListAux1[nAux]['conta']    :=  (cAliasTMP)->CONTA
		aListAux1[nAux]['data']     :=  (cAliasTMP)->DATASALDO
        aListAux1[nAux]['saldo']    :=  (cAliasTMP)->SALDO

		(cAliasTMP)->(DbSkip())
	EndDo

	(cAliasTMP)->(DBCloseArea())

	cAliasTMP := GetNextAlias()

	cQuery := " SELECT 'Entradas' AS TIPO, SUM(E1_VALOR-E1_SALDO) AS VALOR FROM "+RetSQLName("SE1")
	cQuery += " WHERE E1_FILIAL=' ' AND E1_BAIXA BETWEEN '"+cPridMA+"' AND '"+cUltDia+"' AND D_E_L_E_T_=' '
	cQuery += " UNION ALL
	cQuery += " SELECT 'Saidas' AS TIPO, SUM(E2_VALOR-E2_SALDO) AS VALOR FROM "+RetSQLName("SE2")
	cQuery += " WHERE E2_FILIAL=' ' AND E2_BAIXA BETWEEN '"+cPridMA+"' AND '"+cUltDia+"' AND D_E_L_E_T_=' '"
	cQuery += " UNION ALL
	cQuery += " SELECT 'Receber' AS TIPO, SUM(E1_VALOR) AS VALOR FROM "+RetSQLName("SE1")
	cQuery += " WHERE E1_FILIAL=' ' AND E1_VENCREA BETWEEN '"+cPridMA+"' AND '"+cUltSem+"' AND D_E_L_E_T_=' '"
	cQuery += " AND E1_BAIXA=' '"
	cQuery += " UNION ALL
	cQuery += " SELECT 'Pagar' AS TIPO, SUM(E2_VALOR) AS VALOR FROM "+RetSQLName("SE2")
	cQuery += " WHERE E2_FILIAL=' ' AND E2_VENCREA BETWEEN '"+cPridMA+"' AND '"+cUltSem+"' AND D_E_L_E_T_=' '"
	cQuery += " AND E2_BAIXA=' '"
	
    
	MPSysOpenQuery(cQuery, cAliasTMP)

    nAux := 0

	While (cAliasTMP)->(!EoF())
		nAux++
		aAdd(aListAux2 , JsonObject():New() )
		aListAux2[nAux]['tipo']    :=  (cAliasTMP)->TIPO
		aListAux2[nAux]['valor']   :=  (cAliasTMP)->VALOR

		(cAliasTMP)->(DbSkip())
	EndDo

	(cAliasTMP)->(DBCloseArea())


	oStatus := JsonObject():New()

	If Len(aListAux1) > 0
		oStatus['code']    := '#200'
		oStatus['message'] := 'sucesso'
	Else
		oStatus['code']    := '#400'
		oStatus['message'] := 'nao econtrado'
	EndIf

    oJsonAux['status'] := oStatus
	oJsonAux['card1'] := aListAux1
	oJsonAux['card2'] := aListAux2
	
	cJsonAux := FwJsonSerialize(oJsonAux)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonAux)
    
Return .T.


user function xbig01

RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv('01', '0801')

	ndias := dow(ddatabase) - 2
	nSexta := 6 - dow(ddatabase)

	If nDias > 0
		cPridMA := dtos(ddatabase-ndias)
	else
		cPridMA := dtos(ddatabase)
	EndIF 

	cUltDia := dtos(ddatabase)
	cUltSem := dtos(ddatabase+nSexta)

return
