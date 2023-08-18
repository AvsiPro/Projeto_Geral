#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP20 Description "painel vendas API" FORMAT APPLICATION_JSON
	WsData ano AS Integer Optional
	WsData mes AS Integer Optional

WsMethod GET painelvendas;
    Description 'Lista de painel vendas';
    WsSyntax '/WSAPP20';
    Path '/WSAPP20';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de painel vendas.

@param	
	ano , numerico, ano de consulta
	mes , numerico, mes de consulta
		
@return cResponse  , caracter, JSON contendo a lista de painel vendas

/*/

WsMethod GET painelvendas WsReceive ano, mes WsRest WSAPP20
	Local lRet:= .T.
	lRet := painelvendas( self )
Return( lRet )

Static Function painelvendas( oSelf )

Local aListAux	:= {}
Local aListAux1	:= {}
Local oJsonAux	:= Nil
Local cJsonAux	:= ''
Local cQryAux 	:= ''
Local cPriDia	:= ''
Local cUltDia	:= ''
Local nAux		:= 0
Local nX 		:= 0
Local aBrands 	:= {}

Default oself:ano :=  2023
Default oself:mes :=	7

	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv('01', '0801')

	DbSelectArea('SBM')
	DbSetOrder(1)
	DbGoTop()

	If !Empty(oself:ano) .And. !Empty(oself:mes)
        cPriDia := cValToChar(oself:ano)+cValToChar(StrZero(oself:mes,2))+'01'
        cUltDia := DToS(CToD(cValToChar(LastDay(SToD(cPriDia)))))
    EndIf

	While SBM->(!EoF())
		aAdd(aBrands, Alltrim(SBM->BM_DESC))
		SBM->(DbSkip())
	EndDo

	For nX := 1 To Len(aBrands)
		cAliasCpo := StrTran(aBrands[nX],' ','_')
		cQryAux += " ISNULL(ROUND(SUM(CASE BM_DESC WHEN '"+aBrands[nX]+"' THEN C6_QTDVEN END),2),0) "+cAliasCpo+"_QTD,  "
		cQryAux += " ISNULL(ROUND(SUM(CASE BM_DESC WHEN '"+aBrands[nX]+"' THEN C6_VALOR END),2),0) "+cAliasCpo+"_VLR,   "
	Next nX

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

	cQuery := " SELECT   " 
	cQuery += cQryAux
	cQuery += "   	A3_NOME,  " 
	cQuery += " 	ROUND(SUM(C6_VALOR),2) AS TOTAL  " 
	cQuery += "   FROM " + RetSQLName("SC5") + " SC5   " 
	cQuery += "   INNER JOIN " + RetSQLName("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL   " 
	cQuery += " 		 AND C6_NUM = C5_NUM   " 
	cQuery += " 		 AND C6_CLI = C5_CLIENTE   " 
	cQuery += " 		 AND C6_LOJA = C5_LOJACLI   " 
	cQuery += " 		 AND SC6.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SA3") + " SA3 ON A3_FILIAL = ' '   " 
	cQuery += " 		 AND A3_COD = C5_VEND1   " 
	cQuery += " 		 AND SA3.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = ' '   " 
	cQuery += " 		 AND B1_COD = C6_PRODUTO   " 
	cQuery += " 		 AND SB1.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL = ' '   " 
	cQuery += " 		 AND BM_GRUPO = B1_GRUPO   " 
	cQuery += " 		 AND SBM.D_E_L_E_T_ = ' '   " 
	cQuery += "   WHERE  C5_FILIAL = '"+FWxFilial('SC5')+"'   " 
	cQuery += " 		 AND SC5.D_E_L_E_T_ = ' '   " 
	cQuery += " 		 AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"' "
	cQuery += " GROUP BY A3_NOME  " 
	cQuery += " ORDER BY SUM(C6_VALOR) DESC  "

	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!EoF())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		aListAux[nAux]['name'] := (cAliasTMP)->A3_NOME
		aListAux[nAux]['brands'] := Array(Len(aBrands))

		For nX := 1 To Len(aBrands)
			cAliasCpo := StrTran(aBrands[nX],' ','_')

			aListAux[nAux]['brands'][nX] := JsonObject():New()
			aListAux[nAux]['brands'][nX]['title'] := aBrands[nX]
			aListAux[nAux]['brands'][nX]['quantity'] := &('(cAliasTMP)->'+cAliasCpo+'_QTD')
			aListAux[nAux]['brands'][nX]['value'] := &('(cAliasTMP)->'+cAliasCpo+'_VLR')
		Next nX

		(cAliasTMP)->(DbSkip())
	EndDo

	(cAliasTMP)->(DBCloseArea())


    cAliasTMP := GetNextAlias()

	cQuery := " SELECT   " 
	cQuery += "   	A3_NOME,  " 
	cQuery += " 	ROUND(SUM(C6_VALOR),2) AS TOTAL  " 
	cQuery += "   FROM " + RetSQLName("SC5") + " SC5   " 
	cQuery += "   INNER JOIN " + RetSQLName("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL   " 
	cQuery += " 		 AND C6_NUM = C5_NUM   " 
	cQuery += " 		 AND C6_CLI = C5_CLIENTE   " 
	cQuery += " 		 AND C6_LOJA = C5_LOJACLI   " 
	cQuery += " 		 AND SC6.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SA3") + " SA3 ON A3_FILIAL = ' '   " 
	cQuery += " 		 AND A3_COD = C5_VEND1   " 
	cQuery += " 		 AND SA3.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = ' '   " 
	cQuery += " 		 AND B1_COD = C6_PRODUTO   " 
	cQuery += " 		 AND SB1.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL = ' '   " 
	cQuery += " 		 AND BM_GRUPO = B1_GRUPO   " 
	cQuery += " 		 AND SBM.D_E_L_E_T_ = ' '   " 
	cQuery += "   WHERE  C5_FILIAL = '"+FWxFilial('SC5')+"'   " 
	cQuery += " 		 AND SC5.D_E_L_E_T_ = ' '   " 
	cQuery += " 		 AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"' "
	cQuery += " GROUP BY A3_NOME  " 
	cQuery += " ORDER BY SUM(C6_VALOR) DESC  "

	MPSysOpenQuery(cQuery, cAliasTMP)

	nAux := 0
	While (cAliasTMP)->(!EoF())
		nAux++
		aAdd(aListAux1 , JsonObject():New() )

        nAting := (cAliasTMP)->TOTAL
        nMeta := 100000
        
		aListAux1[nAux]['nome']  := (cAliasTMP)->A3_NOME
		aListAux1[nAux]['total'] := Round(nAting,2)
		aListAux1[nAux]['meta']  := Round(nMeta,2)
		aListAux1[nAux]['atingPercent'] :=Round((nAting / nMeta) * 100,2)
    
		dUltimoDiaMes := LastDate(Date())
		nDiasRestantes := Day(dUltimoDiaMes) - Day(Date()) + 1
		nMediaDiaria := (cAliasTMP)->TOTAL / Day(Date())
		nProjecao := nMediaDiaria * nDiasRestantes

		aListAux1[nAux]['projecao'] := Round(nProjecao,2)

		(cAliasTMP)->(DbSkip())
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
	oJsonAux['card1'] := aListAux
	oJsonAux['card2'] := aListAux1

	cJsonAux := FwJsonSerialize(oJsonAux)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonAux)
    
Return .T.
