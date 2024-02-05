#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} WSRESTFUL EMAPI016
EMAPI016 - Prorrogar Vencimento Títulos a Receber.
@obs Especificação Funcional - MIT041 - FINANCEIRO - RFP - 1_36
@author Desenvolvedores Grupo 377
@since 01.11.2023
/*/
WSRESTFUL EMAPI016 DESCRIPTION 'Emive - Webservice de integrações' FORMAT APPLICATION_JSON
	WSMETHOD POST DESCRIPTION "Prorrogar Vencimento Títulos a Receber" PATH '/api/EMAPI016' WSSYNTAX '/api/EMAPI016' PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} POST
Processa as informações e retorna o json
@author Desenvolvedores Grupo 377
@since 01.11.2023
/*/
WSMETHOD POST WSSERVICE EMAPI016
	Local cRet		:= ""
	Local cJsRet	:= ""
	Local nDias 	:= GetMv("EM_QTDIAS")
	Local nVezes 	:= GetMv("EM_NVEZES")
	Local cBco 		:= GetMv("EM_ZBANCO")
	Local cAge 		:= GetMv("EM_ZAGENC")
	Local cConta 	:= GetMv("EM_ZCONTA")
	Local cAliasA 	:= ""
	//Local cAliasB 	:= ""
	Local _nMulta	:= 0
	Local _nJuros	:= 0
	Local aLog		:= {}
	Local nY		:= 0
	Local cErr		:= ""

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .T.
	Private lAutoErrNoFile 	:= .T.

	cBody := ::GetContent()
	::SetContentType("application/json")
	oJson := JsonObject():new()
	cRet := oJson:fromJson(FwNoAccent(cBody))

	If ValType(cRet) <> "U"
		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "Estrutura Json invalida" '
		cJsRet += '}'
		::SetResponse(cJsRet)
		Return .T.
	EndIf

	DbSelectArea('SE1')
	DbSelectArea("SA6")
	DbSelectArea("SEE")

	//Busca juros e multa da SEE
	SEE->(DbSetOrder(1))
	If SEE->(DbSeek(xFilial("SEE") + Padr(AllTrim(cBco),TamSx3("EE_CODIGO")[1]) + Padr(AllTrim(cAge),TamSx3("EE_AGENCIA")[1]) + Padr(AllTrim(cConta),TamSx3("EE_CONTA")[1]) ))
		_nMulta	:= SEE->EE_ZMULTA
		_nJuros	:= SEE->EE_ZJUROS
	EndIf

	cQry := " SELECT A6_COD, R_E_C_N_O_ AS RECSA6 FROM ? "
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += " AND A6_FILIAL = ? "
	cQry += " AND A6_COD = ? "
	cQry += " AND A6_AGENCIA = ? "
	cQry += " AND A6_NUMCON = ? "
	cQry := ChangeQuery(cQry)
	oQry := FWPreparedStatement():New(cQry)

	oQry:SetUnsafe(1, RetSqlName( "SA6" ))
	oQry:SetString(2, xFilial("SA6"))
	oQry:SetString(3, cBco)
	oQry:SetString(4, cAge)
	oQry:SetString(5, cConta)

	cQry	:= oQry:GetFixQuery()
	cAliasA	:= MPSysOpenQuery( cQry )

	(cAliasA)->( DbGoTop() )
	If Empty((cAliasA)->A6_COD)
		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "Banco/Agencia/Conta nao encontrado" '
		cJsRet += '}'
		::SetResponse(cJsRet)
		Return .T.
	Else
		SA6->( DbGoTo( (cAliasA)->RECSA6 ) )
	EndIf
	(cAliasA)->( DbCloseArea() )

	cQry := " SELECT A1_COD, A1_LOJA FROM ? SA1 "
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += " AND A1_ZCODPAR = ? "
	cQry := ChangeQuery(cQry)
	oQry := FWPreparedStatement():New(cQry)

	oQry:SetUnsafe(1, RetSqlName( "SA1" ))
	oQry:SetString(2, oJson["codparc (Identificador do Cliente)"])

	cQry	:= oQry:GetFixQuery()
	cAliasA	:= MPSysOpenQuery( cQry )

	(cAliasA)->( DbGoTop() )
	If Empty((cAliasA)->A1_COD)
		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "Cliente nao encontrado" '
		cJsRet += '}'
		::SetResponse(cJsRet)
		Return .T.
	Else
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1") + (cAliasA)->A1_COD + (cAliasA)->A1_LOJA))
	EndIf
	(cAliasA)->( DbCloseArea() )

	cQry := " SELECT SE1.R_E_C_N_O_ AS RECSE1 FROM ? SE1 "
	cQry += " INNER JOIN ? SA1 ON SA1.D_E_L_E_T_ <> '*' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA "
	cQry += " WHERE SE1.D_E_L_E_T_ <> '*' "
	cQry += " AND E1_SALDO > 0 "
	cQry += " AND E1_NUM = ? "
	cQry += " AND E1_VENCTO = ? "
	cQry += " AND E1_TIPO = ? "
	cQry += " AND E1_CLIENTE = ? "
	cQry += " AND E1_LOJA = ? "
	cQry := ChangeQuery(cQry)
	oQry := FWPreparedStatement():New(cQry)

	oQry:SetUnsafe(1, RetSqlName( "SE1" ))
	oQry:SetUnsafe(2, RetSqlName( "SA1" ))
	oQry:SetString(3, oJson["Titulo"][1]["Numero do titulo"])
	oQry:SetString(4, DtoS(CtoD(oJson["Titulo"][1]["Data de Vencimento"])))
	oQry:SetString(5, oJson["Titulo"][1]["tipo"])
	oQry:SetString(6, SA1->A1_COD)
	oQry:SetString(7, SA1->A1_LOJA)

	cQry 		:= oQry:GetFixQuery()
	cAliasA	:= MPSysOpenQuery( cQry )

	(cAliasA)->(DbGoTop())
	If (cAliasA)->(Eof())
		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "Titulo nao encontrado ou nao ha saldo para prorrogacao" '
		cJsRet += '}'
		(cAliasA)->( DbCloseArea() )
		::SetResponse(cJsRet)
		Return .T.
	EndIf

	SE1->( DbGoTo( (cAliasA)->RECSE1 ) )
	Begin Transaction
		//Primeiro check -> verificar se a qtde de vezes prorrogado condiz com o parâmetro
		If SE1->E1_ZNVEZES > nVezes
			cJsRet := '{'
			cJsRet += '"Codigo": "400",'
			cJsRet += '"Mensagem": "Numero de vezes de prorrogacao ja ultrapassado" '
			cJsRet += '}'
			(cAliasA)->( DbCloseArea() )
			::SetResponse(cJsRet)
			Return .T.
		EndIf

		//Segundo check -> verificar se a qtde de dias solicitados condiz com o parâmetro
		If CtoD(oJson["Titulo"][1]["Data de Vencimento"])-SE1->E1_VENCTO > nDias
			cJsRet := '{'
			cJsRet += '"Codigo": "400",'
			cJsRet += '"Mensagem": "Numero de dias maior que o permitido" '
			cJsRet += '}'
			(cAliasA)->( DbCloseArea() )
			::SetResponse(cJsRet)
			Return .T.
		EndIf

		//Terceiro check -> verificar se titulo vencido
		If SE1->E1_VENCTO > Date()
			cJsRet := '{'
			cJsRet += '"Codigo": "400",'
			cJsRet += '"Mensagem": "Titulo nao vencido, nao pode ser prorrogado" '
			cJsRet += '}'
			(cAliasA)->( DbCloseArea() )
			::SetResponse(cJsRet)
			Return .T.
		EndIf

		cFil		:= SE1->E1_FILIAL
		cPrefixo 	:= SE1->E1_PREFIXO
		cNum 		:= SE1->E1_NUM
		cParc 		:= SE1->E1_PARCELA
		cTipE1 		:= SE1->E1_TIPO
		cCliente 	:= SE1->E1_CLIENTE
		cLoja 		:= SE1->E1_LOJA
		cNature 	:= SE1->E1_NATUREZ
		nValor 		:= SE1->E1_SALDO
		dVencto 	:= SE1->E1_VENCTO

		aBaixa := {}
		aBaixa:={	{"E1_FILIAL"	,SE1->E1_FILIAL 			,Nil},;
			{"E1_PREFIXO" 	,SE1->E1_PREFIXO 			,Nil},;
			{"E1_NUM" 		,SE1->E1_NUM 				,Nil},;
			{"E1_PARCELA" 	,SE1->E1_PARCELA 			,Nil},;
			{"E1_TIPO" 		,SE1->E1_TIPO 				,Nil},;
			{"E1_NATUREZ" 	,SE1->E1_NATUREZ 			,Nil},;
			{"E1_CLIENTE" 	,SE1->E1_CLIENTE 			,Nil},;
			{"E1_LOJA" 		,SE1->E1_LOJA 				,Nil},;
			{"AUTMOTBX"	 	, "NOR" 					,Nil},;
			{"AUTBANCO" 	, SA6->A6_COD 				,Nil},;
			{"AUTAGENCIA" 	, SA6->A6_AGENCIA 			,Nil},;
			{"AUTCONTA" 	, SA6->A6_NUMCON 			,Nil},;
			{"AUTDTBAIXA"	, Date() 					,Nil},;
			{"AUTDTDEB"		, Date() 					,Nil},;
			{"AUTHIST"	    , "PRORROGACAO DE TITULO" 	,Nil}}

		MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

		If lMsErroAuto
			aLog := GetAutoGRLog()
			For nY := 1 To Len(aLog)
				cErr += AllTrim(aLog[nY])
			Next nY
			cErr := StrTran(cErr,CHR(13)+CHR(10))

			cJsRet := '{'
			cJsRet += '"Codigo": "400",'
			cJsRet += '"Mensagem": "'+cErr+'" '
			cJsRet += '}'
			(cAliasA)->( DbCloseArea() )
			DisarmTransaction()
			::SetResponse(cJsRet)
			Return .T.
		Else
			SE1->(RecLock("SE1",.F.))
			SE1->E1_ZNVEZES += 1
			SE1->(MsUnLock())
		EndIf

		//calculo de multa e juros
		nDias := CtoD(oJson["Titulo"][1]["Nova data de Vencimento"])-SE1->E1_VENCREA //SE1->E1_VENCTO
		_nMulta	:= nValor * (_nMulta/100)
		_nJuros	:= (nValor * ((_nJuros/100)/30)) * nDias

		cNumero := GetSxeNum("SE1","E1_NUM")
		/*
		cQry := " SELECT MAX(E1_NUM) AS E1_NUM FROM ? (NOLOCK) "
		cQry += " WHERE D_E_L_E_T_ = '' "
		cQry += " AND E1_FILIAL = ? "
		cQry += " AND E1_TIPO = ? "
		cQry := ChangeQuery(cQry)
		oQry := FWPreparedStatement():New(cQry)

		oQry:SetUnsafe(1, RetSqlName( "SE1" ))
		oQry:SetString(2, xFilial("SE1"))
		oQry:SetString(3, cTipE1)

		cQry 	:= oQry:GetFixQuery()
		cAliasB	:= MPSysOpenQuery( cQry )

		(cAliasB)->(DbGoTop())
		cNumero := Padl(AllTrim(Str(Val(AllTrim((cAliasB)->E1_NUM))+1)),9,"0")
		(cAliasB)->(DbCloseArea())
		*/

		CFILANT := cFil
		
		aTit := {}
		aAdd(aTit, { "E1_FILIAL"	, cFil 				, Nil})		//FWxFilial("SE1")
		aAdd(aTit, { "E1_NUM"		, cNumero			, Nil})
		aAdd(aTit, { "E1_PREFIXO"	, cPrefixo			, Nil})
		aAdd(aTit, { "E1_PARCELA"	, cParc				, Nil})
		aAdd(aTit, { "E1_TIPO"		, cTipE1				, Nil})
		aAdd(aTit, { "E1_NATUREZ"	, cNature		, Nil})
		aAdd(aTit, { "E1_CLIENTE"	, cCliente	, Nil})
		aAdd(aTit, { "E1_LOJA"		, cLoja		, Nil})
		aAdd(aTit, { "E1_EMISSAO"	, Date()			, Nil})
		aAdd(aTit, { "E1_VENCTO"	, DataValida(CtoD(oJson["Titulo"][1]["Nova data de Vencimento"]),.T.)			, Nil})
		aAdd(aTit, { "E1_VENCREA"	, DataValida(CtoD(oJson["Titulo"][1]["Nova data de Vencimento"]),.T.)			, Nil})
		aAdd(aTit, { "E1_VALOR"		, nValor+_nMulta+_nJuros			, Nil})
		aAdd(aTit, { "E1_ZCHAVE" 	, cFil+cPrefixo+cNum+cParc+cTipE1+cCliente+cLoja	, Nil})
		aAdd(aTit, { "E1_ZVENCTO" 	, dVencto	, Nil})

		//Função ordenar um vetor conforme o dicionário para uso em, por exemplo, rotinas de MSExecAuto.
		aTit := FWVetByDic(aTit, "SE1")

		nModulo    := 6
		SetFunName("FINA040")

		lAutoErrNoFile 	:= .T.
		lMsErroAuto 	:= .F.
		MSExecAuto({|x,y| FINA040(x,y)}, aTit, 3)

		If lMsErroAuto
			RollbackSx8()
			aLog := GetAutoGRLog()
			For nY := 1 To Len(aLog)
				cErr += AllTrim(aLog[nY])
			Next nY
			cErr := StrTran(cErr,CHR(13)+CHR(10))

			cJsRet := '{'
			cJsRet += '"Codigo": "400",'
			cJsRet += '"Mensagem": "'+cErr+'" '
			cJsRet += '}'
			(cAliasA)->( DbCloseArea() )
			DisarmTransaction()
			::SetResponse(cJsRet)
			Return .T.
			(cAliasA)->( DbCloseArea() )
		Else
			ConfirmSx8()
		EndIf

		cJsRet := '{'
		cJsRet += '"Codigo": "200",'
		cJsRet += '"Mensagem": "Titulo prorrogado com sucesso" '
		cJsRet += '}'

		// Devolve o retorno para o Rest
		::SetResponse(cJsRet)

		FreeObj(oJson)
	End Transaction
Return .T.
