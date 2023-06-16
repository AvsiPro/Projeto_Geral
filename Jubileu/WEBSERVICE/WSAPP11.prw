#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP11 Description "chamados API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData token     AS String

WsMethod GET warranty;
    Description 'Lista de chamados';
    WsSyntax '/WSAPP11';
    Path '/WSAPP11';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a lista de chamados.

@param	Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		token      , caracter, token vendedor que usara como filtro

@return cResponse  , caracter, JSON contendo a lista de chamados
/*/

WsMethod GET warranty WsReceive page, pageSize, token WsRest WSAPP11
	Local lRet:= .T.
	lRet := warranty( self )
Return( lRet )

Static Function warranty( oSelf )

Local aListAux	    := {}
Local oJsonAux	    := Nil
Local cJsonAux		:= ''
Local nAux			:= 0

Default oself:page		:= 1
Default oself:pageSize	:= 20
Default oself:token  	:= ''
	
    RpcSetType(3)
    RPCSetEnv('01','0101')

    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

	cQuery := " SELECT Z50.*, ISNULL(CAST(CAST(Z50_OBSATD AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS Z50_OBSATD "
	cQuery += " FROM "+RetSQLName("Z50")+" Z50 "
	cQuery += " INNER JOIN "+RetSQLName('SA1')+" SA1 "
	cQuery += " 	ON A1_FILIAL = '"+FWxFilial('SA1')+"' "
	cQuery += " 	AND Z50_CODCLI = A1_COD "
	cQuery += " 	AND Z50_LOJCLI = A1_LOJA "
	cQuery += " 	AND SA1.D_E_L_E_T_=' ' "
	cQuery += " WHERE Z50.D_E_L_E_T_=' ' "
	cQuery += " 	AND UPPER(A1_TOKEN) = '"+Upper(oself:token)+"' "
	cQuery += " ORDER BY " + SqlOrder(Z50->(IndexKey(1)))
	cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
	cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "
			
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!Eof())
		nAux++
		aAdd(aListAux , JsonObject():New() )

		cIdAux := '{"Z50",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->Z50_CODIGO))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->Z50_CODCLI))+'",'+;
			'"'+Alltrim(EncodeUTF8((cAliasTMP)->Z50_LOJCLI))+'"'+;
		'}

		If !ExistDir('\updchamados\')
			Makedir('\updchamados\')
		EndIf
		
		oFile := FWFileReader():New('\updchamados\chamado_'+AllTrim((cAliasTMP)->Z50_CODIGO)+'\notification.txt')

		cNotif := 'visualizou'

		If (oFile:Open())
			If !(oFile:EoF())
				cNotif := oFile:FullRead()
			EndIf

			oFile:Close()
		EndIf

		aListAux[nAux]['id']	        := Encode64(cIdAux)
		aListAux[nAux]['warranty']	    := Alltrim(EncodeUTF8((cAliasTMP)->Z50_CODIGO))
		aListAux[nAux]['invoice']	    := Alltrim(EncodeUTF8((cAliasTMP)->Z50_NOTA))
		aListAux[nAux]['item']	     	:= Alltrim(EncodeUTF8((cAliasTMP)->Z50_ITEM))
		aListAux[nAux]['emission']	    := Alltrim(EncodeUTF8((cAliasTMP)->Z50_EMISSA))
		aListAux[nAux]['product']	    := Alltrim(EncodeUTF8((cAliasTMP)->Z50_PROD))
		aListAux[nAux]['description']	:= Alltrim(EncodeUTF8(Posicione("SB1",1,FWxFilial("SB1")+(cAliasTMP)->Z50_PROD,"B1_DESC")))
		aListAux[nAux]['quantity']	    := (cAliasTMP)->Z50_QUANT
		aListAux[nAux]['defect']	    := fComboDefeito(1,(cAliasTMP)->Z50_DEFEIT)
		aListAux[nAux]['defect_type']	:= fComboDefeito(2,(cAliasTMP)->Z50_TPDEFE)
		aListAux[nAux]['price']	     	:= (cAliasTMP)->Z50_PRECO
		aListAux[nAux]['order']	     	:= Alltrim(EncodeUTF8((cAliasTMP)->Z50_PEDVEN))
		aListAux[nAux]['obs_atend']	    := Alltrim(EncodeUTF8((cAliasTMP)->Z50_OBSATD))
		aListAux[nAux]['notification']	:= Alltrim(cNotif)
		aListAux[nAux]['status']	    := Alltrim(EncodeUTF8((cAliasTMP)->Z50_STATUS))

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


Static Function fComboDefeito(nTipo,cProp)

Local cRet := ''

// 1-Defeito / 2-Tipo Defeito
If nTipo == 1
	If cProp == '1'
		cRet := 'Frontal'
	ElseIf cProp == '2'
		cRet := 'Hastes'
	ElseIf cProp == '3'
		cRet := 'Charneiras'
	ElseIf cProp == '4'
		cRet := 'Lentes'
	EndIf
Else
	If cProp == 'A'
		cRet := 'Descascando'
	ElseIf cProp == 'B'
		cRet := 'Trincado'
	ElseIf cProp == 'C'
		cRet := 'Oxidação'
	ElseIf cProp == 'D'
		cRet := 'Riscada'
	ElseIf cProp == 'E'
		cRet := 'Quebrada'
	ElseIf cProp == 'F'
		cRet := 'Quebrada na Solda'
	ElseIf cProp == 'G'
		cRet := 'Solta'
	ElseIf cProp == 'H'
		cRet := 'Parafuso Espanado'
	ElseIf cProp == 'I'
		cRet := 'Defeito na Ponteira'
	ElseIf cProp == 'J'
		cRet := 'Tonalidades diferentes'
	ElseIf cProp == 'L'
		cRet := 'Manchada'
	ElseIf cProp == 'M'
		cRet := 'Defeito na Mola'
	ElseIf cProp == 'N'
		cRet := 'Suporte de Plaquetas'
	EndIf
EndIf

Return cRet
