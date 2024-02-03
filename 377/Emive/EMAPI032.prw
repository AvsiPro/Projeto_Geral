#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} WSRESTFUL EMAPI032
EMAPI032 - API para alterar Pedido de Vendas
@obs 	Especificação Funcional - MIT041 - Integrações - GAP - 1.30
		Especificação Funcional - MIT041 - Integrações - GAP - 1.32
		Especificação Funcional - MIT041 - Integrações - GAP - 1.33
@author Desenvolvedores Grupo 377
@since 01.12.2023
/*/
WSRESTFUL EMAPI032 DESCRIPTION 'Emive - Webservice de integrações' FORMAT APPLICATION_JSON
	WSDATA filial 		As STRING
	WSDATA pedidode 	As STRING
	WSDATA pedidoate 	As STRING
	WSDATA codparc 		As STRING
	WSDATA cpfcnpj 		As STRING
	WSDATA vendedor 	As STRING

	WSMETHOD POST DESCRIPTION "API para incluir Pedido de Vendas" PATH '/api/EMAPI032' WSSYNTAX '/api/EMAPI032' PRODUCES APPLICATION_JSON
	WSMETHOD PUT DESCRIPTION "API para alterar Pedido de Vendas" PATH '/api/EMAPI032' WSSYNTAX '/api/EMAPI032' PRODUCES APPLICATION_JSON
	WSMETHOD GET DESCRIPTION "API para consultar Pedido de Vendas" PATH '/api/EMAPI032' WSSYNTAX '/api/EMAPI032' PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} POST
Processa as informações e retorna o json
@author Desenvolvedores Grupo 377
@since 01.12.2023
/*/
WSMETHOD POST WSSERVICE EMAPI032
	Local cBody     := ''          // Recebe o conteudo do Rest
	Local oJson     := NIL         // Recebe o JSON de Entrada
	Local oJsonRet  := NIL         // Recebe o JSON de Saida
	Local nX 		:= 0
	Local aForPag	:= {}
	Local nA		:= 0

	Local _aCab := {} //Array do Cabeçalho do Orçamento
	Local _aItem := {} //Array dos Itens do Orçamento
	Local _aParcelas := {} //Array das Parcelas do Orçamento
	Local nTamProd := 0
	Local nTamUM := 0
	Local nTamTabela := 0

	Private lMsHelpAuto := .T. //Variavel de controle interno do ExecAuto
	Private lMsErroAuto := .F. //Variavel que informa a ocorrência de erros no ExecAuto
	Private INCLUI := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
	Private ALTERA := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão

	::SetContentType("application/json")

	cBody := ::GetContent()
	oJson := JsonObject():new()
	oJson:fromJson(FwNoAccent(cBody))

	nTamProd := TamSX3("LR_PRODUTO")[1]
	nTamUM := TamSX3("LR_UM")[1]
	nTamTabela := TamSX3("LR_TABELA")[1]

	cQry := " SELECT A1_COD, A1_LOJA FROM ? SA1 "
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	//cQry += " AND A1_ZCODPAR = ? "
	cQry += " AND A1_COD = ? "
	cQry := ChangeQuery(cQry)
	oQry := FWPreparedStatement():New(cQry)

	oQry:SetUnsafe(1, RetSqlName( "SA1" ))
	oQry:SetString(2, oJson["Codparc"])

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

	//Array forma de pagamento
	For nA := 1 To Len(oJson['Forma de Pagamento'])
		If oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '2' //dinheiro
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '3' //cheque a vista
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '4' //boleto
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '5' //cheque pre datado
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '7' //cartao de credito
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Token do Cartao de Credito'],oJson['Forma de Pagamento'][nA]['Numero do Cartao'],oJson['Forma de Pagamento'][nA]['Vencimento'],oJson['Forma de Pagamento'][nA]['Nome Titular'],oJson['Forma de Pagamento'][nA]['Bandeira do Cartao'],oJson['Forma de Pagamento'][nA]['Provedor'],oJson['Forma de Pagamento'][nA]['NSU'],oJson['Forma de Pagamento'][nA]['TID'],oJson['Forma de Pagamento'][nA]['Codigo de Autorizacao'],oJson['Forma de Pagamento'][nA]['Quantidade de Parcelas']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '12' //debito automatico
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '14' //pix
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['TX ID'],oJson['Forma de Pagamento'][nA]['END TO END ID'],oJson['Forma de Pagamento'][nA]['Chave PIX'],oJson['Forma de Pagamento'][nA]['Provedor']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '15' //credito conta corrente
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		EndIf
	Next nA

	aAdd( _aCab, {"LQ_VEND" , "000001" , NIL} )
	aAdd( _aCab, {"LQ_COMIS" , 0 , NIL} )
	aAdd( _aCab, {"LQ_CLIENTE" , SA1->A1_COD , NIL} )
	aAdd( _aCab, {"LQ_LOJA" , SA1->A1_LOJA , NIL} )
	aAdd( _aCab, {"LQ_TIPOCLI" , SA1->A1_TIPO , NIL} )
	aAdd( _aCab, {"LQ_DESCONT" , 0 , NIL} )
	aAdd( _aCab, {"LQ_DTLIM" , dDatabase , NIL} )
	aAdd( _aCab, {"LQ_EMISSAO" , dDatabase , NIL} )
	aAdd( _aCab, {"LQ_CONDPG" , "001" , NIL} )
	aAdd( _aCab, {"LQ_NUMMOV" , "1 " , NIL} )

	For nX := 1 To Len(oJson['Itens'])
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + oJson['Itens'][nX]['Codigo do Produto'])

		aAdd( _aItem, {} )
		aAdd( _aItem[Len(_aItem)], {"LR_PRODUTO", PadR(SB1->B1_COD,nTamProd) , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_QUANT" , oJson['Itens'][nX]['Quantidade'] , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_UM" , PadR(SB1->B1_UM,nTamUM) , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_DESC" , 0 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_VALDESC", 0 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_TABELA" , PadR("001",nTamTabela) , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_DESCPRO", 0 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_VEND" , "000001" , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_ENTREGA", "5"                 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_FILRES", xFilial("SLR")                 , NIL} )
	Next

	For nA := 1 To Len(oJson['Forma de Pagamento'])
		DbSelectArea("P04")
		P04->(DbSetOrder(1))
		P04->(DbSeek(xFilial("P04")+oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento']))

		If AllTrim(oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento']) == "7"
			For nX := 1 To Val(oJson['Forma de Pagamento'][nA]['Quantidade de Parcelas'])
				aAdd( _aParcelas, {} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_DATA" , dDatabase , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_VALOR" , oJson['Forma de Pagamento'][nX]['Valor'] , NIL} )
				//aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" , AllTrim(P04->P04_ESPEC) , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" , AllTrim(P04->P04_FINANC) , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_NUMCART" , AllTrim(oJson['Forma de Pagamento'][nX]['Numero do Cartao']) , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMAID" , " " , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_MOEDA" , 1 , NIL} )
			Next nX
		Else
			aAdd( _aParcelas, {} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_DATA" , dDatabase , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_VALOR" , oJson['Forma de Pagamento'][nX]['Valor'] , NIL} )
			//aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" , AllTrim(P04->P04_ESPEC) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" , AllTrim(P04->P04_FINANC) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMAID" , " " , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_MOEDA" , 1 , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_AGENCIA" , AllTrim(oJson['Forma de Pagamento'][nX]['Banco']) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_CONTA" , AllTrim(oJson['Forma de Pagamento'][nX]['Agencia']) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_NSUTEF" , AllTrim(oJson['Forma de Pagamento'][nX]['Numero da Conta']) , NIL} )
		EndIf
	Next

	SetFunName("LOJA701")

	MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},_aCab,_aItem ,_aParcelas)

	If lMsErroAuto
		cErroTemp 	:= Mostraerro("\system\", AllTrim(SL1->L1_NUM)+DtoS(Date())+StrTran(Time(),":") + ".log")
		nLinhas 	:= MLCount(cErroTemp)
		cBuffer 	:= ""
		cCampo 		:= ""
		nErrLin 	:= 1
		cBuffer 	:= RTrim(MemoLine(cErroTemp,,nErrLin))

		While (nErrLin <= nLinhas)
			nErrLin++
			cBuffer += RTrim(MemoLine(cErroTemp,,nErrLin)) +CRLF
			If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
				cCampo := cBuffer
				Exit
			EndIf
		EndDo

		If Empty(cCampo)
			cCampo := U_EMFUNX02(AllTrim(cBuffer) )
		EndIf

		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "'+U_EMFUNX02(cBuffer)+'" '
		cJsRet += '}'
		::SetResponse(cJsRet)
	Else
		//Gravar a forma de pagamento tabela P05
		DbSelectArea("P05")
		//Array forma de pagamento
		For nA := 1 To Len(oJson['Forma de Pagamento'])
			If oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] $ '2#4' //boleto
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				MsUnLock()
			ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '7' //cartao de credito
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				P05->P05_TOKEN    	:= aForPag[nA][5]
				P05->P05_DATPAG 	:= CtoD(aForPag[nA][2])
				P05->P05_DATVEN 	:= aForPag[nA][3]
				P05->P05_NUMCAR 	:= aForPag[nA][6]
				P05->P05_NOMTIT 	:= aForPag[nA][8]
				P05->P05_BANCAR 	:= aForPag[nA][8]
				P05->P05_PRVCAR 	:= aForPag[nA][10]
				P05->P05_CARNSU 	:= aForPag[nA][11]
				P05->P05_TIDCAR 	:= aForPag[nA][12]
				P05->P05_CODAUT 	:= aForPag[nA][13]
				P05->P05_PARCEL 	:= aForPag[nA][15]
				MsUnLock()
			ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '3#5#12#15' //debito automatico
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				P05->P05_BANCO 		:= aForPag[nA][5]
				P05->P05_AGENC 		:= aForPag[nA][6]
				P05->P05_CONTA 		:= aForPag[nA][7]
				MsUnLock()
			ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '14' //pix
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				P05->P05_TXID 		:= aForPag[nA][5]
				P05->P05_ENDID 		:= aForPag[nA][6]
				P05->P05_CHVPIX 	:= aForPag[nA][7]
				P05->P05_PRVPIX 	:= aForPag[nA][8]
				MsUnLock()
			EndIf
		Next nA
		cJsRet := '{'
		cJsRet += '"Codigo": "200",'
		cJsRet += '"Mensagem": "Pedido gerado com sucesso" '
		cJsRet += '}'
		::SetResponse(cJsRet)
	EndIf

	FreeObj(oJsonRet)
	FreeObj(oJson)
Return .T.

/*/{Protheus.doc} PUT
Processa as informações e retorna o json
@author Desenvolvedores Grupo 377
@since 01.12.2023
/*/
WSMETHOD PUT WSSERVICE EMAPI032
	Local cBody     := ''          // Recebe o conteudo do Rest
	Local oJson     := NIL         // Recebe o JSON de Entrada
	Local oJsonRet  := NIL         // Recebe o JSON de Saida
	Local nX 		:= 0
	Local aForPag	:= {}
	Local nA		:= 0

	Local _aCab := {} //Array do Cabeçalho do Orçamento
	Local _aItem := {} //Array dos Itens do Orçamento
	Local _aParcelas := {} //Array das Parcelas do Orçamento
	Local nTamProd := 0
	Local nTamUM := 0
	Local nTamTabela := 0

	Private lMsHelpAuto := .T. //Variavel de controle interno do ExecAuto
	Private lMsErroAuto := .F. //Variavel que informa a ocorrência de erros no ExecAuto
	Private INCLUI := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
	Private ALTERA := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão

	::SetContentType("application/json")

	cBody := ::GetContent()
	oJson := JsonObject():new()
	oJson:fromJson(FwNoAccent(cBody))

	nTamProd := TamSX3("LR_PRODUTO")[1]
	nTamUM := TamSX3("LR_UM")[1]
	nTamTabela := TamSX3("LR_TABELA")[1]

	cQry := " SELECT A1_COD, A1_LOJA FROM ? SA1 "
	cQry += " WHERE D_E_L_E_T_ <> '*' "
	cQry += " AND A1_ZCODPAR = ? "
	cQry := ChangeQuery(cQry)
	oQry := FWPreparedStatement():New(cQry)

	oQry:SetUnsafe(1, RetSqlName( "SA1" ))
	oQry:SetString(2, oJson["Codparc"])

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

	//Antes, excluir o pedido de venda e o orçamento no loja:
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(oJson['Filial'] + oJson['Numero do Pedido'])

	aAuto:= {}
	aAdd( aAuto, {"C5_NUM"         , SC5->C5_NUM         , Nil} )
	aAdd( aAuto, {"C5_TIPO"        , SC5->C5_TIPO        , Nil} )
	aAdd( aAuto, {"C5_CLIENTE"     , SC5->C5_CLIENTE     , Nil} )
	aAdd( aAuto, {"C5_LOJACLI"     , SC5->C5_LOJACLI     , Nil} )
	aAdd( aAuto, {"C5_LOJAENT"     , SC5->C5_LOJAENT     , Nil} )
	aAdd( aAuto, {"C5_CONDPAG"     , SC5->C5_CONDPAG     , Nil} )
	lMsErroAuto := .F.
	MSExecAuto({|_x, _y, _z| mata410(_x, _y, _z)}, aAuto, {}, 5) // Exclusão

	If lMsErroAuto
		cErroExec := ""
		aLogAuto  := {}
		aLogAuto  := GetAutoGrLog()
		For nX := 1 To Len(aLogAuto)
			cErroExec += FwNoAccent( aLogAuto[nX] )
		Next
		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "'+AllTrim(cErroExec)+'" '
		cJsRet += '}'
		::SetResponse(cJsRet)
		Return .T.
	EndIf

	cQuery := " UPDATE "+RetSqlName("SL1")
	cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND L1_PEDRES =  '"+oJson['Numero do Pedido']+"'"
	cQuery += " AND L1_FILIAL = '"+oJson['Filial']+"'"
	TCSQLExec(cQuery)

	cQuery := " UPDATE "+RetSqlName("SL2")
	cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND L2_PEDRES =  '"+oJson['Numero do Pedido']+"'"
	cQuery += " AND L2_FILIAL = '"+oJson['Filial']+"'"
	TCSQLExec(cQuery)

	cQuery := " UPDATE "+RetSqlName("SL4")
	cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND L4_PEDRES =  '"+oJson['Numero do Pedido']+"'"
	cQuery += " AND L4_FILIAL = '"+oJson['Filial']+"'"
	TCSQLExec(cQuery)
	
	//Array forma de pagamento
	For nA := 1 To Len(oJson['Forma de Pagamento'])
		If oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '2' //dinheiro
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '3' //cheque a vista
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '4' //boleto
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '5' //cheque pre datado
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '7' //cartao de credito
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Token do Cartao de Credito'],oJson['Forma de Pagamento'][nA]['Numero do Cartao'],oJson['Forma de Pagamento'][nA]['Vencimento'],oJson['Forma de Pagamento'][nA]['Nome Titular'],oJson['Forma de Pagamento'][nA]['Bandeira do Cartao'],oJson['Forma de Pagamento'][nA]['Provedor'],oJson['Forma de Pagamento'][nA]['NSU'],oJson['Forma de Pagamento'][nA]['TID'],oJson['Forma de Pagamento'][nA]['Codigo de Autorizacao'],oJson['Forma de Pagamento'][nA]['Quantidade de Parcelas']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '12' //debito automatico
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '14' //pix
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['TX ID'],oJson['Forma de Pagamento'][nA]['END TO END ID'],oJson['Forma de Pagamento'][nA]['Chave PIX'],oJson['Forma de Pagamento'][nA]['Provedor']})
		ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '15' //credito conta corrente
			aAdd(aForPag,{oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'],oJson['Forma de Pagamento'][nA]['Data de pagamento'],oJson['Forma de Pagamento'][nA]['Data de vencimento'],oJson['Forma de Pagamento'][nA]['Valor'],oJson['Forma de Pagamento'][nA]['Banco'],oJson['Forma de Pagamento'][nA]['Agencia'],oJson['Forma de Pagamento'][nA]['Numero da Conta']})
		EndIf
	Next nA

	aAdd( _aCab, {"LQ_VEND" , "000001" , NIL} )
	aAdd( _aCab, {"LQ_COMIS" , 0 , NIL} )
	aAdd( _aCab, {"LQ_CLIENTE" , SA1->A1_COD , NIL} )
	aAdd( _aCab, {"LQ_LOJA" , SA1->A1_LOJA , NIL} )
	aAdd( _aCab, {"LQ_TIPOCLI" , SA1->A1_TIPO , NIL} )
	aAdd( _aCab, {"LQ_DESCONT" , 0 , NIL} )
	aAdd( _aCab, {"LQ_DTLIM" , dDatabase , NIL} )
	aAdd( _aCab, {"LQ_EMISSAO" , dDatabase , NIL} )
	aAdd( _aCab, {"LQ_CONDPG" , "001" , NIL} )
	aAdd( _aCab, {"LQ_NUMMOV" , "1 " , NIL} )

	For nX := 1 To Len(oJson['Itens'])
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + oJson['Itens'][nX]['Codigo do Produto'])

		aAdd( _aItem, {} )
		aAdd( _aItem[Len(_aItem)], {"LR_PRODUTO", PadR(SB1->B1_COD,nTamProd) , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_QUANT" , oJson['Itens'][nX]['Quantidade'] , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_UM" , PadR(SB1->B1_UM,nTamUM) , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_DESC" , 0 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_VALDESC", 0 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_TABELA" , PadR("001",nTamTabela) , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_DESCPRO", 0 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_VEND" , "000001" , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_ENTREGA", "5"                 , NIL} )
		aAdd( _aItem[Len(_aItem)], {"LR_FILRES", xFilial("SLR")                 , NIL} )
	Next

	For nA := 1 To Len(oJson['Forma de Pagamento'])
		DbSelectArea("P04")
		P04->(DbSetOrder(1))
		P04->(DbSeek(xFilial("P04")+oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento']))

		If AllTrim(oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento']) == "7"
			For nX := 1 To Val(oJson['Forma de Pagamento'][nA]['Quantidade de Parcelas'])
				aAdd( _aParcelas, {} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_DATA" , dDatabase , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_VALOR" , oJson['Forma de Pagamento'][nX]['Valor'] , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" , AllTrim(P04->P04_ESPEC) , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_NUMCART" , AllTrim(oJson['Forma de Pagamento'][nX]['Numero do Cartao']) , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMAID" , " " , NIL} )
				aAdd( _aParcelas[Len(_aParcelas)], {"L4_MOEDA" , 1 , NIL} )
			Next nX
		Else
			aAdd( _aParcelas, {} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_DATA" , dDatabase , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_VALOR" , oJson['Forma de Pagamento'][nX]['Valor'] , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMA" , AllTrim(P04->P04_ESPEC) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_FORMAID" , " " , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_MOEDA" , 1 , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_AGENCIA" , AllTrim(oJson['Forma de Pagamento'][nX]['Banco']) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_CONTA" , AllTrim(oJson['Forma de Pagamento'][nX]['Agencia']) , NIL} )
			aAdd( _aParcelas[Len(_aParcelas)], {"L4_NSUTEF" , AllTrim(oJson['Forma de Pagamento'][nX]['Numero da Conta']) , NIL} )
		EndIf
	Next

	SetFunName("LOJA701")

	MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},_aCab,_aItem ,_aParcelas)

	If lMsErroAuto
		cErroTemp 	:= Mostraerro("\system\", AllTrim(SL1->L1_NUM)+DtoS(Date())+StrTran(Time(),":") + ".log")
		nLinhas 	:= MLCount(cErroTemp)
		cBuffer 	:= ""
		cCampo 		:= ""
		nErrLin 	:= 1
		cBuffer 	:= RTrim(MemoLine(cErroTemp,,nErrLin))

		While (nErrLin <= nLinhas)
			nErrLin++
			cBuffer += RTrim(MemoLine(cErroTemp,,nErrLin)) +CRLF
			If (Upper(SubStr(cBuffer,Len(cBuffer)-7,Len(cBuffer))) == "INVALIDO")
				cCampo := cBuffer
				Exit
			EndIf
		EndDo

		If Empty(cCampo)
			cCampo := U_EMFUNX02(AllTrim(cBuffer) )
		EndIf

		cJsRet := '{'
		cJsRet += '"Codigo": "400",'
		cJsRet += '"Mensagem": "'+U_EMFUNX02(cBuffer)+'" '
		cJsRet += '}'
		::SetResponse(cJsRet)
	Else
		//Gravar a forma de pagamento tabela P05
		DbSelectArea("P05")
		//Array forma de pagamento
		For nA := 1 To Len(oJson['Forma de Pagamento'])
			If oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] $ '2#4' //boleto
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				MsUnLock()
			ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '7' //cartao de credito
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				P05->P05_TOKEN    	:= aForPag[nA][5]
				P05->P05_DATPAG 	:= CtoD(aForPag[nA][2])
				P05->P05_DATVEN 	:= aForPag[nA][3]
				P05->P05_NUMCAR 	:= aForPag[nA][6]
				P05->P05_NOMTIT 	:= aForPag[nA][8]
				P05->P05_BANCAR 	:= aForPag[nA][8]
				P05->P05_PRVCAR 	:= aForPag[nA][10]
				P05->P05_CARNSU 	:= aForPag[nA][11]
				P05->P05_TIDCAR 	:= aForPag[nA][12]
				P05->P05_CODAUT 	:= aForPag[nA][13]
				P05->P05_PARCEL 	:= aForPag[nA][15]
				MsUnLock()
			ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '3#5#12#15' //debito automatico
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				P05->P05_BANCO 		:= aForPag[nA][5]
				P05->P05_AGENC 		:= aForPag[nA][6]
				P05->P05_CONTA 		:= aForPag[nA][7]
				MsUnLock()
			ElseIf oJson['Forma de Pagamento'][nA]['Codigo da Forma de Pagamento'] == '14' //pix
				RecLock("P05",.T.)
				P05->P05_FILIAL		:= xFilial("P05")
				P05->P05_ITEM  		:= Padl(AllTrim(Str(nA)),TamSx3("P05_ITEM")[1],"0")
				P05->P05_CONTRA  	:= SL1->L1_NUM
				P05->P05_CODIGO     := aForPag[nA][1]
				P05->P05_VALOR    	:= aForPag[nA][4]
				P05->P05_TXID 		:= aForPag[nA][5]
				P05->P05_ENDID 		:= aForPag[nA][6]
				P05->P05_CHVPIX 	:= aForPag[nA][7]
				P05->P05_PRVPIX 	:= aForPag[nA][8]
				MsUnLock()
			EndIf
		Next nA
		cJsRet := '{'
		cJsRet += '"Codigo": "200",'
		cJsRet += '"Mensagem": "Pedido gerado com sucesso" '
		cJsRet += '}'
		::SetResponse(cJsRet)
	EndIf

	FreeObj(oJsonRet)
	FreeObj(oJson)
Return .T.

/*/{Protheus.doc} GET
Processa as informações e retorna o json
@author Desenvolvedores Grupo 377
@since 01.12.2023
/*/
WSMETHOD GET WSRECEIVE filial,pedidode,pedidoate,codparc,cpfcnpj,vendedor WSREST EMAPI032
	Local nX 		:= 0
	Local aPedidos	:= ""
	Local cQry := ""
	Local cAliasA := GetNextAlias()

	cQry := " SELECT C5_FILIAL, C5_NUM, C5_TIPO, A1_ZCODPAR, SUM(C6_VALOR) AS C6_VALOR FROM "+RetSqlName("SC5")+" SC5 "
	cQry += " INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.D_E_L_E_T_ <> '*' AND C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM "
	cQry += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_ <> '*' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI "
	cQry += " WHERE SC5.D_E_L_E_T_ <> '*' "
	cQry += " AND C5_FILIAL = '"+::filial+"' "
	cQry += " AND C5_NUM BETWEEN '"+::pedidode+"' AND '"+::pedidoate+"' "
	If !Empty(::codparc)
		cQry += " AND A1_ZCODPAR = '"+::codparc+"' "
	EndIf
	If !Empty(::cpfcnpj)
		cQry += " AND A1_CGC = '"+::cpfcnpj+"' "
	EndIf
	If !Empty(::vendedor)
		cQry += " AND C5_VEND1 = '"+::vendedor+"' "
	EndIf
	cQry += " GROUP C5_FILIAL, C5_NUM, C5_TIPO, A1_ZCODPAR "
	cQry := ChangeQuery(cQry)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

	(cAliasA)->(DbGoTop())
	If (cAliasA)->(Eof())
		cJson := '{'
		cJson += '"Codigo": "400",'
		cJson += '"Mensagem": "Dados nao encontrados, revise os parametros" '
		cJson += '}'
		::SetResponse(cJson)
		Return .T.
	EndIf

	While (cAliasA)->(!Eof())
		aAdd(aPedidos,{AllTrim((cAliasA)->C5_FILIAL), AllTrim((cAliasA)->C5_NUM), AllTrim((cAliasA)->C5_TIPO), AllTrim((cAliasA)->A1_ZCODPAR), AllTrim((cAliasA)->C6_VALOR)})
		(cAliasA)->(DbSkip())
	End
	(cAliasA)->(DbCloseArea())

	cJson := '{'
	cJson += '	"Codigo": "200",'
	cJson += '	"Pedidos": ['
	For nX := 1 To Len(aPedidos)
		cJson += '	{'
		cJson += '		"Filial": "'+AllTrim(aPedidos[nX][1])+'",'
		cJson += '		"Tipo do Pedido": "'+AllTrim(aPedidos[nX][3])+'",'
		cJson += '		"Numero Pedido": "'+AllTrim(aPedidos[nX][2])+'",'
		cJson += '		"Codparc": "'+AllTrim(aPedidos[nX][4])+'",'
		cJson += '		"Valor Total": '+AllTrim(Str(aPedidos[nX][5]))+','
		cJson += '		"Itens": ['

		cQry := " SELECT C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_TES, C6_CC FROM "+RetSqlName("SC6")
		cQry += " WHERE D_E_L_E_T_ <> '*' "
		cQry += " AND C6_FILIAL = '"+aPedidos[nX][1]+"' "
		cQry += " AND C6_NUM = '"+aPedidos[nX][2]+"' "
		cQry := ChangeQuery(cQry)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

		(cAliasA)->(DbGoTop())
		While (cAliasA)->(!Eof())
			cJson += '		{'
			cJson += '			"Codigo do Produto": "'+(cAliasA)->C6_PRODUTO+'",'
			cJson += '			"Quantidade": '+AllTrim(Str((cAliasA)->C6_QTDVEN))+','
			cJson += '			"Valor Unitario": '+AllTrim(Str((cAliasA)->C6_PRCVEN))+','
			cJson += '			"Codigo DePara para TES": "'+AllTrim((cAliasA)->C6_TES)+'",'
			cJson += '			"Centro de Custo": "'+AllTrim((cAliasA)->C6_CC)+'"'
			cJson += '		},'
			(cAliasA)->(DbSkip())
		End
		(cAliasA)->(DbCloseArea())

		If Substr( cJson, Len(cJson), 1 ) == ","
			cJson := Substr( cJson, 1, Len(cJson) - 1 )
		EndIf

		cJson += '	],'
		cJson += '	"Forma de Pagamento": ['

		cQry := " SELECT * FROM "+RetSqlName("SL4")
		cQry += " WHERE D_E_L_E_T_ <> '*' "
		cQry += " AND L4_FILIAL = '"+aPedidos[nX][1]+"' "
		cQry += " AND L4_PEDRES = '"+aPedidos[nX][2]+"' "
		cQry := ChangeQuery(cQry)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

		(cAliasA)->(DbGoTop())
		While (cAliasA)->(!Eof())
			If AllTrim((cAliasA)->L4_FORMA) == 'CR#CD'
				cJson += '		{'
				cJson += '			"Codigo da Forma de Pagamento": "'+AllTrim((cAliasA)->L4_FORMA)+'",'
				cJson += '			"Data de pagamento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Data de Vencimento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Valor": '+AllTrim(Str((cAliasA)->L4_VALOR))+','
				cJson += '			"Quantidade de Parcelas": "'+AllTrim((cAliasA)->P05_PARCEL)+'",'
				cJson += '			"Numero do Cartao": "'+AllTrim((cAliasA)->L4_NUMCART)+'",'
				cJson += '			"Vencimento": "'+AllTrim((cAliasA)->L4_NUMCART)+'",'
				cJson += '			"Nome Titular": "'+AllTrim((cAliasA)->P05_NOMTIT)+'",'
				cJson += '			"Bandeira do Cartao": "'+AllTrim((cAliasA)->P05_BANCAR)+'",'
				cJson += '			"Provedor": "'+AllTrim((cAliasA)->P05_PRVCAR)+'",'
				cJson += '			"NSU": "'+AllTrim((cAliasA)->P05_CARNSU)+'",'
				cJson += '			"TID": "'+AllTrim((cAliasA)->P05_TIDCAR)+'",'
				cJson += '			"Codigo de Autorizacao": "'+AllTrim((cAliasA)->P05_CODAUT)+'"'
				cJson += '		},'
			ElseIf AllTrim((cAliasA)->L4_FORMA) == 'PD'
				cJson += '		{'
				cJson += '			"Codigo da Forma de Pagamento": "'+AllTrim((cAliasA)->L4_FORMA)+'",'
				cJson += '			"Data de pagamento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Data de Vencimento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Valor": '+AllTrim(Str((cAliasA)->L4_VALOR))+','
				cJson += '			"TX ID": "'+AllTrim((cAliasA)->P05_TXID)+'",'
				cJson += '			"END TO END ID": "'+AllTrim((cAliasA)->P05_ENDID)+'",'
				cJson += '			"Chave PIX": "'+AllTrim((cAliasA)->P05_CHVPIX)+'",'
				cJson += '			"Provedor": "'+AllTrim((cAliasA)->P05_PRVPIX)+'"'
				cJson += '		},'
			ElseIf AllTrim((cAliasA)->L4_FORMA) == 'BOL#R$#CH'
				cJson += '		{'
				cJson += '			"Codigo da Forma de Pagamento": "'+AllTrim((cAliasA)->L4_FORMA)+'",'
				cJson += '			"Data de pagamento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Data de Vencimento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Valor": '+AllTrim(Str((cAliasA)->L4_VALOR))+''
				cJson += '		},'
			ElseIf AllTrim((cAliasA)->L4_FORMA) == 'CR#DA'
				cJson += '		{'
				cJson += '			"Codigo da Forma de Pagamento": "'+AllTrim((cAliasA)->L4_FORMA)+'",'
				cJson += '			"Data de pagamento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Data de Vencimento": "'+DtoS(StoD((cAliasA)->L4_FORMA))+'",'
				cJson += '			"Valor": '+AllTrim(Str((cAliasA)->L4_VALOR))+','
				cJson += '			"Banco": "'+AllTrim((cAliasA)->L4_BANCO)+'",'
				cJson += '			"Agencia": "'+AllTrim((cAliasA)->L4_AGENCIA)+'",'
				cJson += '			"Numero da Conta": "'+AllTrim((cAliasA)->L4_CONTA)+'"'
				cJson += '		}'
			EndIf
			(cAliasA)->(DbSkip())
		End
		(cAliasA)->(DbCloseArea())

		If Substr( cJson, Len(cJson), 1 ) == ","
			cJson := Substr( cJson, 1, Len(cJson) - 1 )
		EndIf

		cJson += '			]'
		cJson += '		},'
	Next nX

	If Substr( cJson, Len(cJson), 1 ) == ","
		cJson := Substr( cJson, 1, Len(cJson) - 1 )
	EndIf

	cJson += '	]'
	cJson += '}'

	// Devolve o retorno para o Rest
	::SetResponse(cJsRet)
Return .T.
