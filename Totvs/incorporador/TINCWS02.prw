#include "totvs.ch"
#include "restful.ch"
#include "parmtype.ch"
#include "tryexception.ch"

// Define usado pela static function CampoProt 
#define IDUSRFULL "000000" // ID do Usuário com Acesso Full
#define IDUSRLIMT "000000" // ID do Usuário Limitado (Padrão)
#define LGDP .F.           // Habilita o Uso da LGPD

#define POSTUSASX2 "" // Relação de Tabelas permitidas no POST (Incluir)

	CLASS TINCWS02Adapter FROM FWAdapterBaseV2
		METHOD New()
		METHOD GetListMod()
		METHOD GetListMany()
	EndClass

Method New( cVerb ) CLASS TINCWS02Adapter
	_Super:New( cVerb, .T. )
return

Method GetListMany( cTabela, cOrdem, oRelation, lFilial, cApiName ) CLASS TINCWS02Adapter
	Local aArea 	AS ARRAY
	Local cWhere	AS CHAR
	Local cCpoFil := GetSX3Filial(cTabela)
	aArea   := FwGetArea()
	//Adiciona o mapa de campos Json/ResultSet
	AddFldMany( self, cTabela, cOrdem, oRelation )
	//Informa a Query a ser utilizada pela API
	::SetQuery( GetQueryMany(cTabela, oRelation, lFilial, cApiName) )
	//Informa a clausula Where da Query
	cWhere := " " + cTabela + ".D_E_L_E_T_ = ' ' "
	If !Empty(cCpoFil) .and. lFilial
		cWhere += " AND " + cTabela + "."+cCpoFil+" = '" + xFilial(cTabela) + "'"
	EndIf
	If PosicioneZX5(cApiName, cTabela)
		If !Empty(ZX5->ZX5_COMPL)
			cWhere += " AND (" + ALLTRIM(ZX5->ZX5_COMPL) + ")"
		EndIf
	EndIf

	::SetWhere( cWhere )
	//Informa a ordenação padrão a ser Utilizada pela Query
	::SetOrder( cOrdem )
	//Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
	If ::Execute()
		// Gera o arquivo Json com o retorno da Query
		// Pode ser reescrita, iremos ver em outro artigo de como fazer
		::FillGetResponse()
	EndIf
	FwrestArea(aArea)
Return

Method GetListMod( cTabela, cOrdem, lFilial, cApiName ) CLASS TINCWS02Adapter
	Local aArea 	AS ARRAY
	Local cWhere	AS CHAR
	Local cCpoFil := iif(lFilial, GetSX3Filial(cTabela), "")
	aArea   := FwGetArea()
	//Adiciona o mapa de campos Json/ResultSet
	AddMapFields( self, cTabela, cOrdem)
	//Informa a Query a ser utilizada pela API
	::SetQuery( GetQuery(cTabela) )
	//Informa a clausula Where da Query
	cWhere := " " + cTabela + ".D_E_L_E_T_ = ' ' "
	If !Empty(cCpoFil)
		cWhere += " AND " + cTabela + "."+cCpoFil+" = '" + xFilial(cTabela) + "'"
	EndIf
  
  If PosicioneZX5(cApiName, cTabela)
     If !Empty(ZX5->ZX5_COMPL)
        cWhere += " AND (" + ALLTRIM(ZX5->ZX5_COMPL) + ")"
    EndIf
  EndIf

	::SetWhere( cWhere )
	//Informa a ordenação padrão a ser Utilizada pela Query
	::SetOrder( cOrdem )
	//Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
	If ::Execute()
		// Gera o arquivo Json com o retorno da Query
		// Pode ser reescrita, iremos ver em outro artigo de como fazer
		::FillGetResponse()
	EndIf
	FwrestArea(aArea)
Return

Static Function AddMapFields( oSelf, cTab, cOrd )

	Local aCampos := FWSX3Util():GetAllFields( cTab, .F. )
	Local nCampo  := 0
	Local aOrds := StrToKarr(upper(cOrd),",")		

	For nCampo := 1 to Len(aCampos)
		If !(At("USERLGI",aCampos[nCampo]) > 0 .or. At("USERLGA",aCampos[nCampo]) > 0)
			oSelf:AddMapFields( aCampos[nCampo]	, aCampos[nCampo] , .T., Ascan(aOrds,upper(aCampos[nCampo])) > 0, { aCampos[nCampo], GetSx3Cache(aCampos[nCampo], 'X3_TIPO'), TamSX3( aCampos[nCampo] )[1], TamSX3( aCampos[nCampo] )[2] } )
		EndIf
	Next

Return

Static Function GetQuery(cTab)
	Local cQuery := ""

	cQuery += " SELECT #QueryFields# "
	cQuery +=   " FROM " + RetSqlName( cTab ) + " " + cTab + " "
	cQuery += " WHERE #QueryWhere# "
	//FwLogMsg("INFO", , "WSADAPT", FunName(), "", "01", "GetQuery = " + cQuery)

Return cQuery

Static Function AddFldMany( oSelf, cTab, cOrd, oRelation )

	Local aCampos := {}
	Local nCampo  := 0
	Local aOrds   := StrToKarr(upper(cOrd),",")
	Local aTab    := {}
	Local cTbl    := ""
	Local nTbl    := 0

	aTab := oRelation:GetNames()

	aadd(aTab, cTab)

	For nTbl:= 1 to len(aTab)
		cTbl := aTab[nTbl]
		aCampos := FWSX3Util():GetAllFields( Right(cTbl,3), .F. )
		For nCampo := 1 to len(aCampos)
			If cTbl <> cTab
				If oRelation[cTbl]["TYPE"] == "DETAIL"
					Loop
				EndIf
			EndIf
			If !(At("USERLGI",aCampos[nCampo]) > 0 .or. At("USERLGA",aCampos[nCampo]) > 0)
				oSelf:AddMapFields( aCampos[nCampo]	, aCampos[nCampo] , .T., Ascan(aOrds,upper(aCampos[nCampo])) > 0, { aCampos[nCampo], GetSx3Cache(aCampos[nCampo], 'X3_TIPO'), TamSX3( aCampos[nCampo] )[1], TamSX3( aCampos[nCampo] )[2] } )
			EndIf
		Next
	Next

Return

Static Function GetQueryMany(cTab, oRelation, lFilial, cApiName)
	Local cQuery := ""

	Local aTbl := ASORT(oRelation:GetNames())
	Local nTbl := 0
	Local cTbl := ""
	Local aCpo := {}
	Local nCpo := ""

	cQuery += " SELECT #QueryFields# "
	cQuery += " FROM " + RetSqlName( cTab ) + " " + cTab + "  "
	For nTbl := 1 to Len(aTbl)
		cTbl := aTbl[nTbl]
		If oRelation[cTbl]["TYPE"] == "MASTER"
			cQuery += " " + oRelation[cTbl]["JOIN"] + " JOIN " + RetSqlName( Right(cTbl,3) ) + " " + Right(cTbl,3) + " "
			cQuery += " ON ( "
			aCpo := oRelation[cTbl]["FIELDS"]
			For nCpo := 1 to Len(aCpo)
				cQuery += " " + iif(nCpo == 1, "", " AND ") + aCpo[nCpo][1] + " = " + aCpo[nCpo][2]
			Next
			If PosicioneZX5(cApiName, Right(cTbl,3))
				If !Empty(ZX5->ZX5_COMPL)
					cWhere += " AND (" + ALLTRIM(ZX5->ZX5_COMPL) + ")"
				EndIf
			EndIf

			cQuery += " AND " + Right(cTbl,3) + ".D_E_L_E_T_ = ' ' ) "
		EndIf
	Next
	cQuery += " WHERE #QueryWhere# "

	//FwLogMsg("INFO", , "WSADAPT", FunName(), "", "01", "GetQueryMany = " + cQuery)

Return cQuery

Static Function GetSX3Filial(cTab) // Retorna campo filial da tabela informada

	Local aCampos := FWSX3Util():GetAllFields( Right(cTab,3), .F. )
	Local nCampo  := aScan(aCampos, {|campo| "FILIAL" $ UPPER(ALLTRIM(campo)) })
	If nCampo > 0
		Return aCampos[nCampo]
	Else
		Return ""
	EndIf

Return ""

	WSRESTFUL TINCWS02 DESCRIPTION 'TINCWS02 API: oData by Integrador' FORMAT "application/json,text/html"

		WSDATA Page     AS INTEGER OPTIONAL
		WSDATA PageSize AS INTEGER OPTIONAL
		WSDATA Order    AS CHARACTER
		WSDATA Fields   AS CHARACTER OPTIONAL
		WSDATA Filter   AS CHARACTER OPTIONAL
		WSDATA apiname  AS CHARACTER

		WSMETHOD GET ModList;
			DESCRIPTION "Retorna uma lista de dados";
			WSSYNTAX "/tincws02";
			PATH "/tincws02/{cnpj}/{tabela}" ;
			PRODUCES APPLICATION_JSON

		WSMETHOD POST ModListMany;
			DESCRIPTION "Retorna uma lista com dados relacionados";
			WSSYNTAX "/tincws02/relacionados" ;
			PATH "/tincws02/relacionados/{cnpj}/{tabela}" ;
			PRODUCES APPLICATION_JSON

	END WSRESTFUL

WSMETHOD GET ModList WSRECEIVE apiname WSREST TINCWS02
Return getModList(self)

Static Function getModList( oWS )
	Local lRet  as logical
	Local oMod as object
	Local cResponse := ""
	Local nPosEmp   := 0
	Local nEmp   := 0
	Local nRec   := 0
	Local aEmpresas := FwLoadSM0()
	Local oEmpresas := JsonObject():New()
	Local nEmpresa  := 1
    Local cApiName  := oWS:apiname
	Local cCNPJURL  := Upper(AllTrim(oWS:aURLParms[1]))
	Local lFilial   := len(cCNPJURL) == 14
	Local lEmpresas := .F.
	Local aGrupos   := {}
	Local nGrupo    := 1
	Local oResponse := JsonObject():New()
	Local cCpoFil   := ""

	DEFAULT oWS:Page      := 1
	DEFAULT oWS:PageSize  := 10
	DEFAULT oWS:Fields    := ""
	DEFAULT oWS:Filter    := ""
	DEFAULT oWS:Order     := ""

	lRet        := .T.

	If Empty(cApiName)
		SetRestFault(400,MyEncode("Nome da API não informado","cp1252"))
		Return .F.
  EndIf

  

	If cCNPJURL == "ALL" .OR. cCNPJURL == "TODOS"
		SetRestFault(400,MyEncode("Em Desenvolvimento","cp1252"))
		return .F.

		nPosEmp := 1
		lEmpresas := .T.
		For nEmpresa := 1 to len(aEmpresas)
			nGrupo := Ascan(aGrupos,{|grupo| grupo[1] = aEmpresas[nEmpresa][1]})
		Next

	Else
		If len(cCNPJURL) = 8
			nPosEmp := Ascan(aEmpresas, {|x| Left(Alltrim(x[18]),8) == Left(AllTrim(oWS:aURLParms[1]),8) })
		ElseIf len(cCNPJURL) = 14
			nPosEmp := Ascan(aEmpresas, {|x| Alltrim(x[18]) == AllTrim(oWS:aURLParms[1]) })
		EndIf
	EndIf

	If nPosEmp == 0
		SetRestFault(400,MyEncode("Empresa não encontrada","cp1252"))
		return .F.
	Else
		cEmpAnt := aEmpresas[nPosEmp][1]
		cFilAnt := aEmpresas[nPosEmp][2]
	EndIf

	if Empty(FWSX2Util():GetFile( oWS:aURLParms[2] ))
		SetRestFault(400,MyEncode("Tabela não encontrada","cp1252"))
		return .F.
	endif

  If !PosicioneZX5(cApiName, oWS:aURLParms[2])
     SetRestFault(400,MyEncode("API [" + cApiName + "] e Tabela [" + oWS:aURLParms[2] + "] não encontrada","cp1252"))
		 Return .F.
	EndIf

	//FwLogMsg("INFO", , "WSADAPT", FunName(), "", "01", "oEmpresas:ToJSON()"+CRLF+oEmpresas:ToJSON()+CRLF)

	cCpoFil := GetSX3Filial(oWS:aURLParms[2])
	If !Empty(oWS:Fields)
		If !(cCpoFil $ oWS:Fields)
			oWS:Fields += "," + cCpoFil
		EndIf
	EndIf
	/*
	oMod := TINCWS02Adapter():new( 'GET' )
	oMod:setPage(oWS:Page)
	oMod:setPageSize(oWS:PageSize)
	oMod:SetOrderQuery(oWS:Order)
	oMod:SetUrlFilter(oWS:aQueryString )
	oMod:SetFields( oWS:Fields )
	oMod:GetListMod(oWS:aURLParms[2], oWS:Order, lFilial)
	*/
	ADPTRGET(@oMod, oWS, lFilial, cApiName)
	//Se tudo ocorreu bem, retorna os dados via Json

	If oMod:lOk
		cResponse := MyEncode(oMod:getJSONResponse(),"cp1252")

		cErrorJson := oResponse:FromJson(cResponse)

		If ValType(cErrorJson) == "C"
			SetRestFault(400, MyEncode("Erro no parse do response:"+cErrorJson,"cp1252"))
			Return .F.
		EndIf

		//FwLogMsg("INFO", , "WSADAPT", FunName(), "", "01", "oResponse:ToJSON()"+CRLF+oResponse:ToJSON()+CRLF)
		oWS:SetResponse(MyEncode(oResponse:ToJson(),"cp1252"))

	Else
		//Ou retorna o erro encontrado durante o processamento
		SetRestFault(oMod:GetCode(),oMod:GetMessage())
		lRet := .F.
	EndIf

	oMod:DeActivate()
	oMod := nil
Return lRet

Static Function ADPTRGET(oMod, oWS, lFilial, cApiName)

	oMod := TINCWS02Adapter():new( 'GET' )
	oMod:setPage(oWS:Page)
	oMod:setPageSize(oWS:PageSize)
	oMod:SetOrderQuery(oWS:Order)
	oMod:SetUrlFilter({{"ORDER", oWS:Order},{"FILTER", oWS:Filter}} )
	oMod:SetFields( oWS:Fields )
	oMod:GetListMod(oWS:aURLParms[2], oWS:Order, lFilial, cApiName)

Return .t.

WSMETHOD POST ModListMany WSRECEIVE apiname WSREST TINCWS02
Return postModListMany(self)

Static Function postModListMany( oWS )
	Local lRet  as logical
	Local oMod as object
	Local oModDetail as object
	Local oResponse := JsonObject():New()
	Local oRespDetl := JsonObject():New()
	Local nItemResp := 0
	Local cResponse := ""
	Local cErrorJson:= ""
	Local nPosEmp   := 0
	Local nField
	Local nItem  := 0
	Local aEmpresas := FwLoadSM0()
	Local oEmpresas := JsonObject():New()
	Local cBody     := oWS:GetContent()
	Local oBody     := JsonObject():New()
	Local aTab      := {}
	Local nTab      := 0
	Local aProp     := {}
	Local nProp     := {}
	Local lType     := .F.
	Local lJoin     := .F.
	Local lFields   := .F.
	Local lTable    := .F.
	Local lDetail   := .F.
	Local aFields   := {}
	Local aTabSX3   := {}
	Local nCpoDtl
	Local aCpoDtl
	Local cOrderDtl
	Local nFieldDtl
	Local aFieldDtl
	Local cFieldDtl
    Local cApiName  := oWS:apiname
	Local cCNPJURL  := Upper(AllTrim(oWS:aURLParms[2]))
	Local lFilial   := len(cCNPJURL) == 14
	Local lEmpresas := .F.
	Local cCpoFil   := ""
	Local nEmp   := 1
	Local nRec   := 1
	Local oBodyDetail := JsonObject():New()
	Local aTabDtl := {}

	DEFAULT oWS:Page      := 1
	DEFAULT oWS:PageSize  := 10
	DEFAULT oWS:Fields    := ""
	DEFAULT oWS:Filter    := ""
	DEFAULT oWS:Order     := ""

	lRet        := .T.

  If Empty(cApiName)
    SetRestFault(400,MyEncode("Nome da API não informado","cp1252"))
    Return .F.
  EndIf

	cErrorJson := oBody:FromJson(cBody)  

	If ValType(cErrorJson) == "C"
		SetRestFault(400, MyEncode("Erro no parse do body:"+cErrorJson,"cp1252"))
		Return .F.
	EndIf

	//FwLogMsg("INFO", , "WSADAPT", FunName(), "", "01", "oBody:ToJSON()"+CRLF+oBody:ToJSON()+CRLF)

	If cCNPJURL == "ALL" .OR. cCNPJURL == "TODOS"
		nPosEmp := 1
		lEmpresas := .T.
	Else
		If len(cCNPJURL) = 8
			nPosEmp := Ascan(aEmpresas, {|x| Left(Alltrim(x[18]),8) == Left(AllTrim(oWS:aURLParms[2]),8) })
		ElseIf len(cCNPJURL) = 14
			nPosEmp := Ascan(aEmpresas, {|x| Alltrim(x[18]) == AllTrim(oWS:aURLParms[2]) })
		EndIf
	EndIf

	//nPosEmp := Ascan(aEmpresas, {|x| Alltrim(x[18]) == AllTrim(oWS:aURLParms[2]) })

	If nPosEmp == 0
		SetRestFault(400,MyEncode("Empresa não encontrada:"+AllTrim(oWS:aURLParms[2]),"cp1252"))
		return .F.
	Else
		//RpcClearEnv()
		//RpcSetType(3)
		//RpcSetEnv(aEmpresas[nPosEmp][1],aEmpresas[nPosEmp][2])
		cEmpAnt := aEmpresas[nPosEmp][1]
		cFilAnt := aEmpresas[nPosEmp][2]

	EndIf

	if Empty(FWSX2Util():GetFile( oWS:aURLParms[3] ))
		SetRestFault(400,MyEncode("Tabela "+oWS:aURLParms[3]+" não encontrada","cp1252"))
		return .F.
	endif

  If !PosicioneZX5(cApiName, oWS:aURLParms[3])
     SetRestFault(400,MyEncode("API [" + cApiName + "] e Tabela [" + oWS:aURLParms[3] + "] não encontrada","cp1252"))
     Return .F.
  EndIf


	cCpoFil := GetSX3Filial(oWS:aURLParms[3])
	If !Empty(oWS:Fields)
		If !(cCpoFil $ oWS:Fields)
			oWS:Fields += "," + cCpoFil
		EndIf
	EndIf

	aTab := oBody:GetNames()
	aTabSX3 := AClone(aTab)
	aadd(aTabSX3, oWS:aURLParms[3])
	For nTab := 1 to Len(aTab)

		lType     := .F.
		lJoin     := .F.
		lFields   := .F.
		lTable    := .F.

		if Empty(FWSX2Util():GetFile( right(aTab[nTab],3) ))
			SetRestFault(400,MyEncode("Tabela: "+aTab[nTab]+" não encontrada","cp1252"))
			Exit
		endif

    If !PosicioneZX5(cApiName, right(aTab[nTab],3))
       SetRestFault(400,MyEncode("API [" + cApiName + "] e Tabela [" + right(aTab[nTab],3) + "] não encontrada","cp1252"))
  		 Exit
    EndIf

		lTable := .T.
		aProp := oBody[aTab[nTab]]:GetNames()

		For nProp := 1 to len(aProp)
			Do Case
			Case aProp[nProp] == "TYPE"
				If oBody[aTab[nTab]][aProp[nProp]] $ "MASTER#DETAIL"
					if oBody[aTab[nTab]][aProp[nProp]] == "DETAIL"
						lDetail := .T.
					Endif
					lType := .T.
				Else
					SetRestFault(400, MyEncode("TYPE não é válido: " + oBody[aTab[nTab]][aProp[nProp]],"cp1252"))
					Exit
				EndIf
			Case aProp[nProp] == "JOIN"
				If oBody[aTab[nTab]][aProp[nProp]] $ "LEFT#RIGHT#INNER"
					lJoin     := .T.
				Else
					SetRestFault(400, MyEncode("Tipo do JOIN não é válido: " + oBody[aTab[nTab]][aProp[nProp]],"cp1252"))
					Exit
				EndIf
			Case aProp[nProp] == "FIELDS"
				aFields := oBody[aTab[nTab]][aProp[nProp]]
				If valtype(aFields) == "A"
					lFields := .T.
					For nField := 1 to Len(aFields)
						For nItem := 1 to Len(aFields[nField])
							If !CheckSX3(aTabSX3, aFields[nField][nItem])
								SetRestFault(400, MyEncode("Campo: " + aFields[nField][nItem] + " não existe nas tabelas informadas","cp1252"))
								lFields := .F.
								Exit
							EndIf
						Next
					Next
				EndIf
			End Case
		Next
	Next

	If !lType .OR. !lJoin .OR. !lFields .OR. !lTable
		Return .F.
	EndIf

	oMod := TINCWS02Adapter():new( 'GET' )
	oMod:setPage(oWS:Page)
	oMod:setPageSize(oWS:PageSize)
	oMod:SetOrderQuery(oWS:Order)
	oMod:SetUrlFilter({{"ORDER", oWS:Order},{"FILTER", oWS:Filter}} ) //oMod:SetUrlFilter(oWS:aQueryString)
	oMod:SetFields( oWS:Fields )
	oMod:GetListMany(oWS:aURLParms[3], oWS:Order, oBody, lFilial, cApiName)
	//Se tudo ocorreu bem, retorna os dados via Json
	If oMod:lOk
		cResponse := MyEncode(oMod:getJSONResponse(),"cp1252")

		cErrorJson := oResponse:FromJson(cResponse)

		If ValType(cErrorJson) == "C"
			SetRestFault(400, MyEncode("Erro no parse do response:"+cErrorJson,"cp1252"))
			Return .F.
		EndIf


		If lDetail

			For nItemResp := 1 to Len(oResponse["items"])
				For nTab := 1 to Len(aTab)
					aTabDtl := {}
					Tbl2Detalhe(oBody[aTab[nTab]],@aTabDtl)
					aadd(aTabDtl,aTab[nTab])
					If oBody[aTab[nTab]]["TYPE"] == "DETAIL"
						nFieldDtl := 0
						aFieldDtl := StrToKarr(oWS:Fields, ",")
						cFieldDtl := ""
						For nFieldDtl := 1 to Len(aFieldDtl)
							if CheckSX3(aTabDtl,alltrim(aFieldDtl[nFieldDtl]))
								cFieldDtl += aFieldDtl[nFieldDtl]+","
							endif
						Next
						cFieldDtl:=left(cFieldDtl,len(cFieldDtl)-1)

						cOrderDtl := ""
						cFilteDtl := ""
						aCpoDtl := oBody[aTab[nTab]]["FIELDS"]
						nCpoFil := 0
						//1 C5_FILIAL C6_FILIAL
						//2 C6_FILIAL C5_FILIAL
						//nPassou := 0
						For nCpoDtl := 1 to Len(aCpoDtl)

							if CheckSX3({aTab[nTab]}, aCpoDtl[nCpoDtl][1])
								cOrderDtl += aCpoDtl[nCpoDtl][1]+","
								cFilteDtl += " "+aCpoDtl[nCpoDtl][1]+" "
								nCpoFil++
								cFilteDtl += " eq "
								cFilteDtl += " '"+oResponse["items"][nItemResp][LOWER(aCpoDtl[nCpoDtl][2])]+"' "
							else
								if CheckSX3({aTab[nTab]}, aCpoDtl[nCpoDtl][2])
									cOrderDtl += aCpoDtl[nCpoDtl][2]+","
									cFilteDtl += " "+aCpoDtl[nCpoDtl][2]+" "
									nCpoFil++
								endif
								cFilteDtl += " eq "
								cFilteDtl += " '"+oResponse["items"][nItemResp][LOWER(aCpoDtl[nCpoDtl][1])]+"' "
							endif
							/*
							if CheckSX3({aTab[nTab]}, aCpoDtl[nCpoDtl][2])
								cOrderDtl += aCpoDtl[nCpoDtl][2]+","
								cFilteDtl += " "+aCpoDtl[nCpoDtl][2]+" "
								nCpoFil++
							else
								cFilteDtl += " '"+oResponse["items"][nItemResp][LOWER(aCpoDtl[nCpoDtl][2])]+"' "
							endif
							*/
							if (nCpoDtl) < Len(aCpoDtl)
								cFilteDtl +=" AND "
							endif
						Next nCpoDtl
						cOrderDtl := left(cOrderDtl,len(cOrderDtl)-1)

						If nCpoFil == 0
							SetRestFault(400, MyEncode("Campos do atributo FIELD devem ter ao menos 1 campo da tabela:"+aTab[nTab],"cp1252"))
							Return .F.
						Endif

						oModDetail := TINCWS02Adapter():new( 'GET' )
						oModDetail:setPage(1)
						oModDetail:setPageSize(999999)
						oModDetail:SetOrderQuery(cOrderDtl)
						oModDetail:SetUrlFilter({{"ORDER",cOrderDtl},{"FILTER", cFilteDtl}})
						oModDetail:SetFields(cFieldDtl)
						JsonDetalhe(oBody[aTab[nTab]],@oBodyDetail)
						oModDetail:GetListMany(aTab[nTab], cOrderDtl, oBodyDetail, lFilial, cApiName)

						If oModDetail:lOk
							cErrorJson := oRespDetl:FromJson(oModDetail:getJSONResponse())

							If ValType(cErrorJson) == "C"
								SetRestFault(400, MyEncode("Erro no parse do response:"+cErrorJson,"cp1252"))
								Return .F.
							EndIf

							oResponse["items"][nItemResp][aTab[nTab]] := oRespDetl["items"]
						EndIf
						oModDetail:DeActivate()
					EndIf

				Next nRab
			Next nItemResp
		Endif

		oWS:SetResponse(MyEncode(oResponse:ToJson(),"cp1252"))
	Else
		//Ou retorna o erro encontrado durante o processamento
		SetRestFault(oMod:GetCode(), oMod:GetMessage())
		lRet := .F.
	EndIf

	oMod:DeActivate()
	oMod := nil
Return lRet

Static Function CheckSX3(aTab, cCpo)
	Local nTbl    := 0
	Local nCampo  := 0
	Local cTab    := ""
	Local aFld    := {}
	Local nFld    := 0
	For nTbl := 1 to Len(aTab)
		cTab := Right(aTab[nTbl],3)
		nCampo  := (cTab)->(FieldPos(cCpo))
		if (nCampo > 0)
			Exit
		endif
	Next

	If (nCampo == 0)
		For nTbl := 1 to Len(aTab)
			cTab := Right(aTab[nTbl],3)
			aFld := FWSX3Util():GetListFieldsStruct( cTab , .F. )
			For nFld := 1 to Len(aFld)
				If aFld[nFld][1] $ cCpo
					nCampo := nFld
					Exit
				EndIf
			Next
		Next
	EndIf

Return nCampo > 0

Static Function Tbl2Detalhe(oBody, aTab)
	Local aAtrib := {}
	Local nAtrib := 1

	aAtrib := oBody:GetNames()

	For nAtrib := 1 to len(aAtrib)

		if !(aAtrib[nAtrib] $ "TYPE#JOIN#FIELDS")
			aadd(aTab, aAtrib[nAtrib])
		endif

	Next nAtrib

Return .t.
Static Function JsonDetalhe(oBody, oDetail)
	Local aAtrib := {}
	Local nAtrib := 1

	aAtrib := oBody:GetNames()

	For nAtrib := 1 to len(aAtrib)

		if !(aAtrib[nAtrib] $ "TYPE#JOIN#FIELDS")
			oDetail[aAtrib[nAtrib]] := oBody[aAtrib[nAtrib]]
		endif

	Next nAtrib

Return .t.

Static Function MyEncode(cJson, cCodePage)
	Local cRegEx := "Â°#Âº#Âª#&#'#<#>"
	Local aRegex := StrToKarr(cRegEx, "#")
	Local cUTF8  := ""
	Local nChar  := 1
	Local aCaracteresEspeciais  := {}
	Local cCharEspecial         := ""
	Local cCharCorreto          := ""
	Local nT                    := 0
	Default cJson               := ""

	aAdd( aCaracteresEspeciais, { 'Ã¡',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã¡',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã ',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã¢',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã£',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã¤',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã€',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã‚',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ãƒ',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã„',  'A' } )
	aAdd( aCaracteresEspeciais, { 'Ã©',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ã¨',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ãª',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ãª',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ã‰',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ãˆ',  'E' } )
	aAdd( aCaracteresEspeciais, { 'ÃŠ',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ã‹',  'E' } )
	aAdd( aCaracteresEspeciais, { 'Ã­',  'I' } )
	aAdd( aCaracteresEspeciais, { 'Ã¬',  'I' } )
	aAdd( aCaracteresEspeciais, { 'Ã®',  'I' } )
	aAdd( aCaracteresEspeciais, { 'Ã¯',  'I' } )
	aAdd( aCaracteresEspeciais, { 'Ã',  'I' } )
	aAdd( aCaracteresEspeciais, { 'ÃŒ',  'I' } )
	aAdd( aCaracteresEspeciais, { 'ÃŽ',  'I' } )
	aAdd( aCaracteresEspeciais, { 'Ã',  'I' } )
	aAdd( aCaracteresEspeciais, { 'Ã³',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã²',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã´',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ãµ',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã¶',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã“',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã’',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã”',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã•',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ã–',  'O' } )
	aAdd( aCaracteresEspeciais, { 'Ãº',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ã¹',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ã»',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ã¼',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ãš',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ã™',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ã›',  'U' } )
	aAdd( aCaracteresEspeciais, { 'Ã§',  'C' } )
	aAdd( aCaracteresEspeciais, { 'Ã‡',  'C' } )
	aAdd( aCaracteresEspeciais, { 'Ã±',  'N' } )
	aAdd( aCaracteresEspeciais, { 'Ã‘',  'N' } )
	aAdd( aCaracteresEspeciais, { '&',  'E' } )
	aAdd( aCaracteresEspeciais, { "'",  '' } )
	aAdd( aCaracteresEspeciais, { chr(160),  '' } )

	For nT := 1 To Len( aCaracteresEspeciais )
		cCharCorreto    := aCaracteresEspeciais[nT][2]
		cCharEspecial   := aCaracteresEspeciais[nT][1]

		If cCharEspecial $ cJson
			cJson := StrTran( cJson, cCharEspecial, cCharCorreto )
		EndIf

	Next nT

	For nChar := 1 To Len(aRegex)
		cJSON := StrTran(cJSON, aRegex[nChar], "")
	Next nChar

	cJSON := FwCutOff(cJSON, .t.)
	cJSON := noAcento(cJSON)
	cJSON := FwNoAccent(cJSON)
	cUTF8 := EncodeUtf8(cJSON)
	If ValType(cUTF8) = "C"
		cJSON := cUTF8
	EndIf
Return cJSON


User Function TINCWS02()
	
  Local aArea         := GetArea()
	Local aPBoxPrm		:= {}
	Local aRet			:= {}
	Local aCampos       := {"ZX5_CHAVE", "ZX5_DESCRI", "ZX5_CHAVE2", "ZX5_COMPL"}
	Local nCampo 	    := 1
	Local nPBox			:= 0
  Local cTitCpo := "" 
  Local lObriga := .F.
  Local lJob := Select("SX2") == 0

  If (lJob)
		RpcClearEnv()
		RpcSetType(3)
		lOk := RpcSetEnv("00", "00001000100")
		If ! lOk
			cMsg := '[TINCWS02] Falha na abertura do Ambiente'
			FwLogMsg("ERROR", , "TINCWS02", FunName(), "", "01", cMsg, 0, (Seconds()), {})
		EndIf
	Endif

	For nCampo := 1 to Len(aCampos)
    Do Case
    Case aCampos[nCampo] == "ZX5_CHAVE"
      cTitCpo := "Nome da API"
      lObriga := .T.
    Case aCampos[nCampo] == "ZX5_DESCRI"
      cTitCpo := "Descrição da API"  
      lObriga := .T.
    Case aCampos[nCampo] == "ZX5_CHAVE2"
      cTitCpo := "Tabela (Ex: SB1, SA1)"      
      lObriga := .T.
    Case aCampos[nCampo] == "ZX5_COMPL"
      cTitCpo := "Filtro (Ex: A1_MSBLQL = '1')"  
      lObriga := .F.
    End Case  
		
		aAdd(aPBoxPrm,Array(9))
		nPBox:=Len(aPBoxPrm)
		aPBoxPrm[nPBox][1] := 1                                //[1]:1 - MsGet
		aPBoxPrm[nPBox][2] := cTitCpo                          //[2]:Descricao
		aPBoxPrm[nPBox][3] := CriaVar( aCampos[nCampo], .T. )  //[3]:String contendo o inicializador do campo
		aPBoxPrm[nPBox][4] := "@!"                             //[4]:String contendo a Picture do campo
		aPBoxPrm[nPBox][5] := ""                               //[5]:String contendo a validacao
		aPBoxPrm[nPBox][6] := ""                               //[6]:Consulta F3
		aPBoxPrm[nPBox][7] := "AllwaysTrue()"                  //[7]:String contendo a validacao When
		aPBoxPrm[nPBox][8] := FwGetSx3Cache(aCampos[nCampo],"X3_TAMANHO")*10  //[8]:Tamanho do MsGet
		aPBoxPrm[nPBox][9] := lObriga //[9]:Flag .T./.F. Parametro Obrigatorio ?

	Next

	If ParamBox(aPBoxPrm ,"Parametrizar API TINCWS02",@aRet,,,,,,,,.F.,.T.)  		
     CreateZX5(aRet[1], aRet[3], aRet[2], aRet[4]) // cApiName, cTabela, cDescricao, cFiltro
	EndIf

	RestArea(aArea)

Return .T.

Static Function CreateZX5(cApiName, cTabela, cDescricao, cFiltro)
    Local cKey := Padr("INCWS2", TamSX3("ZX5_TABELA")[1])
    Local lExiste := PosicioneZX5(cApiName, cTabela)
    If RecLock('ZX5', !lExiste)
       ZX5->ZX5_TABELA := Upper(Alltrim(cKey))
       ZX5->ZX5_CHAVE  := Upper(Alltrim(cApiName))
       ZX5->ZX5_CHAVE2 := Upper(Alltrim(cTabela))
       ZX5->ZX5_DESCRI := Upper(Alltrim(cDescricao))
       ZX5->ZX5_COMPL  := Alltrim(cFiltro)
       ZX5->(MsUnlock())
    EndIf
    
Return .T.

Static Function PosicioneZX5(cApiName, cTabela)

    Local cKey := Padr("INCWS2", TamSX3("ZX5_TABELA")[1])
    Local lExiste := .F.
    
    cApiName :=  Upper(Padr(cApiName, TamSX3("ZX5_CHAVE")[1]))
    cTabela :=  Upper(Padr(AllTrim(cTabela), TamSX3("ZX5_CHAVE2")[1]))
    
    DbSelectArea("ZX5")
    ZX5->(DbSetOrder(1)) // ZX5_FILIAL+ZX5_TABELA+ZX5_CHAVE+ZX5_CHAVE2
    lExiste := ZX5->(DbSeek(xFilial("ZX5") + cKey + cApiName + cTabela))
    
Return lExiste
