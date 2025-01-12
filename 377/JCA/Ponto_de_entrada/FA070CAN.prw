#INCLUDE "FONT.CH"
#Include "RPTDEF.CH"
#INCLUDE "topconn.ch"

/*

	Ponto de entrada FA070CAN sera executado apos a confirmacao 
    do cancelamento da baixa do contas a receber.

	Utilizado para enviar ao Tracker os cancelamentos das baixas das faturas realizadas

*/
User Function FA070CAN

	Local cTipBx        := SuperGetmv("TI_TIPBXT",.F.,"FT")
	Local lLigaTr       := SuperGetmv("TI_LIGINT",.F.,.T.)
	Private nBkpRec		:= SE1->(recno())
	Private aItemsFI2   := {}
	Private nVlrOrig 	:= 0
	Private nValBai		:= 0
	Private nValEst     := 0
	Private aRecLiq  := {}

	If lLigaTr
		If !Empty(cTipBx)
			If Alltrim(SE1->E1_TIPO) $ cTipBx .and. !Empty(SE1->E1_NUMLIQ)
				nSaldo := conssld()
				//posiciona novamente
				SE1->(DbGoTo(nBkpRec))
				If nValBai + nValEst >= nVlrOrig
					EnvTrck(nVlrOrig)
				EndIf
				SE1->(DbGoTo(nBkpRec))
			Else
				If Alltrim(SE1->E1_TIPO) $ cTipBx .And. Empty(SE1->E1_NUMLIQ) //SE1->E1_SALDO == nValrec
					EnvTrck(nVlrOrig)
				EndIf
			EndIf

		EndIf
	EndIf
return


/*/{Protheus.doc} EnvTrck
    Enviar informações de baixa para a tracker (equalizar as bases)
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function EnvTrck(nVlrOrig)

	Local aArea     := GetArea()
	Local oEnvio    := JsonObject():New()
	Local cApiDest  := SuperGetMV("TI_APIDES",.F.,"https://buslog.track3r.com.br")
	Local cEndPnt   := "/api/totvs-protheus/cancela-pagamento-fatura"
	Local cToken    := SuperGetMV("TI_TOKTRK",.F.,'0D901F83-1739-41E3-995B-7303EF0BB19A')
	Local nCont 	:= 0


	If	len(aRecLiq) == 0
		DbselectArea("SE1")
		//DbGoto(aRecLiq[nCont,1])

		oEnvio['filial']    := SE1->E1_FILIAL
		oEnvio['prefixo']   := SE1->E1_PREFIXO
		oEnvio['titulo']    := SE1->E1_NUM
		oEnvio['parcela']   := SE1->E1_PARCELA
		oEnvio['tipo']      := SE1->E1_TIPO
		oEnvio['natureza']  := SE1->E1_NATUREZ
		oEnvio['cliente']   := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")
		oEnvio['emissao']   := cvaltochar(SE1->E1_EMISSAO)
		oEnvio['vencimento']:= cvaltochar(SE1->E1_VENCTO)
		oEnvio['vencto_real']:= cvaltochar(SE1->E1_VENCREA)
		oEnvio['data_baixa']:= cvaltochar(dDataBase)
		oEnvio['valor']     := SE1->E1_VALOR//If(nVlrBaixa>0,nVlrBaixa,SE1->E1_VALOR)
		oEnvio['historico'] := SE1->E1_HIST
		//oEnvio['motivo_baixa'] := cMotBx
		oEnvio['movimento'] := 'estorno'
		oEnvio['usuario']   := cusername

		cRet := oEnvio:toJson()

		ApiEnv04(cApiDest,cEndPnt,cRet,cToken)

	else
		nCont := 1
		For nCont := 1 to len(aRecLiq)

			DbselectArea("SE1")
			DbGoto(aRecLiq[nCont,1])

			oEnvio['filial']    := SE1->E1_FILIAL
			oEnvio['prefixo']   := SE1->E1_PREFIXO
			oEnvio['titulo']    := SE1->E1_NUM
			oEnvio['parcela']   := SE1->E1_PARCELA
			oEnvio['tipo']      := SE1->E1_TIPO
			oEnvio['natureza']  := SE1->E1_NATUREZ
			oEnvio['cliente']   := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")
			oEnvio['emissao']   := cvaltochar(SE1->E1_EMISSAO)
			oEnvio['vencimento']:= cvaltochar(SE1->E1_VENCTO)
			oEnvio['vencto_real']:= cvaltochar(SE1->E1_VENCREA)
			oEnvio['data_baixa']:= cvaltochar(dDataBase)
			oEnvio['valor']     := aRecLiq[nCont,2]//SE1->E1_VALOR//If(nVlrBaixa>0,nVlrBaixa,SE1->E1_VALOR)
			oEnvio['historico'] := SE1->E1_HIST
			//oEnvio['motivo_baixa'] := cMotBx
			oEnvio['movimento'] := 'estorno'
			oEnvio['usuario']   := cusername

			cRet := oEnvio:toJson()

			ApiEnv04(cApiDest,cEndPnt,cRet,cToken)

		NEXT nCont
	endif
	RestArea(aArea)
Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ApiEnv04(cUrlDest,cPathDest,cJson,cToken)

	Local oRest
	Local oJson     :=  ""
	Local aHeader   :=  {}
	Local cRetorno  :=  ""
	Local lRet      :=  .T.
	Local cUrlInt	:=	Alltrim(cUrlDest)
	Local cPath     :=  Alltrim(cPathDest)

	Aadd(aHeader,'Content-Type: application/json')
	Aadd(aHeader,'Token: '+cToken)

	oRest := FWRest():New(cUrlInt)

	oRest:SetPath(cPath)

	oRest:SetPostParams(cJson)

	If oRest:Post(aHeader)
		oJson := JsonObject():New()
		cRet  := oRest:GetResult()
		oRet := oJson:FromJson(cRet)
		lRet := .T.
	else
		cRetorno := Alltrim(oRest:GetLastError())
		cRet := Alltrim(oRest:cresult)
		oBody  := JsonObject():New()
		oBody:fromJson(cRet)
		lRet := .F.
	Endif

Return(cRet)

/*/{Protheus.doc} conssld
    (long_description)
    @type  Static Function
    @author user
    @since 23/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function conssld()

	Local aArea := GetArea()
	Local nRet  :=  0
	Local cQuery
	Local nCont
	Local aLiquida := {}
	Local nRecPrcp := 0

	//cQuery := "SELECT DISTINCT E5_FILIAL,E5_DATA,E5_NATUREZ,E5_NUMERO,E5_PREFIXO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_VALOR,E1.R_E_C_N_O_ E1RECNO,E1_NUMLIQ,E1_TIPOLIQ,FO0_PROCES,E5_DOCUMEN"
	cQuery := "SELECT DISTINCT E5.E5_VALOR,E1.R_E_C_N_O_ E1RECNO,E1_NUMLIQ,E1_TIPOLIQ,E5_TIPODOC"
	cQuery += " FROM "+RetSQLName("SE5")+" E5"
	cQuery += " INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E1_CLIENTE=E5_CLIFOR AND E1_LOJA=E5_LOJA AND E1.D_E_L_E_T_=' '"
	//cQuery += " INNER JOIN "+RetSQLName("FO0")+" FO0 ON FO0_FILIAL=E5_FILIAL AND FO0_NUMLIQ=E5_DOCUMEN AND FO0.D_E_L_E_T_=' '"
	cQuery += " WHERE "
	cQuery += " E5_IDORIG IN (SELECT E5_IDORIG FROM "+RetSQLName("SE5")+" E5 "
	cQuery += "     INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E1_CLIENTE=E5_CLIFOR AND E1_LOJA=E5_LOJA AND E1.D_E_L_E_T_=' '"
	cQuery += "     WHERE E5_FILIAL='"+SE1->E1_FILIAL+"' AND E5_CLIFOR='"+SE1->E1_CLIENTE+"' AND E1_NUMLIQ='"+SE1->E1_NUMLIQ+"' AND E5.D_E_L_E_T_=' ') "
	cQuery += " OR E5_DOCUMEN='"+SE1->E1_NUMLIQ+"'AND E1_TIPOLIQ = 'LIQ'"
	cQuery += " ORDER BY E1_TIPOLIQ DESC "

	IF Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	ENDIF

	MemoWrite("FA070TIT.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	DbSelectArea("TRB")

	While !EOF()
		Aadd(aLiquida,{TRB->E1_NUMLIQ,TRB->E1_TIPOLIQ,TRB->E1RECNO})
		If Empty(TRB->E1_NUMLIQ)
			nRecPrcp := TRB->E1RECNO
			Aadd(aRecLiq,{TRB->E1RECNO,TRB->E5_VALOR})
		else
			IF ALLTRIM(TRB->E5_TIPODOC) == "ES"
				nValBai -= TRB->E5_VALOR
			ELSEIF TRB->E1RECNO != nBkpRec
				nValBai += TRB->E5_VALOR
			Else
				nValEst := TRB->E5_VALOR
			ENDIF
			//exit
		EndIf
		Dbskip()
	EndDo

	If nRecPrcp == 0
		nCont := 1

		while nCont <= len(aLiquida)
			cQuery := "SELECT DISTINCT E1.R_E_C_N_O_ E1RECNO,E1_NUMLIQ,E1_TIPOLIQ,E5_TIPODOC""
			cQuery += " FROM "+RetSQLName("SE5")+" E5"
			cQuery += " INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E1_CLIENTE=E5_CLIFOR AND E1_LOJA=E5_LOJA AND E1.D_E_L_E_T_=' '"
			cQuery += " WHERE "
			cQuery += " E5_IDORIG IN (SELECT E5_IDORIG FROM "+RetSQLName("SE5")+" E5 "
			cQuery += "     INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E1_CLIENTE=E5_CLIFOR AND E1_LOJA=E5_LOJA AND E1.D_E_L_E_T_=' '"
			cQuery += "     WHERE E5_FILIAL='"+SE1->E1_FILIAL+"' AND E5_CLIFOR='"+SE1->E1_CLIENTE+"' AND E1_NUMLIQ='"+aLiquida[nCont,01]+"' AND E5.D_E_L_E_T_=' ') "
			cQuery += " OR E5_DOCUMEN='"+aLiquida[nCont,01]+"'"
			cQuery += " ORDER BY E1_TIPOLIQ DESC"

			IF Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			ENDIF

			MemoWrite("FA070TIT.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

			DbSelectArea("TRB")

			While !EOF()
				Aadd(aLiquida,{TRB->E1_NUMLIQ,TRB->E1_TIPOLIQ,TRB->E1RECNO})
				If Empty(TRB->E1_NUMLIQ)
					nRecPrcp := TRB->E1RECNO
					Aadd(aRecLiq,{TRB->E1RECNO,TRB->E5_VALOR})
				else
					IF ALLTRIM(TRB->E5_TIPODOC) == "ES"
						nValBai -= TRB->E5_VALOR
					ELSEIF TRB->E1RECNO != nBkpRec
						nValBai += TRB->E5_VALOR
					Else
						nValEst := TRB->E5_VALOR
					ENDIF
					//exit
				EndIf
				Dbskip()
			EndDo

			/*If nRecPrcp > 0
				exit
			EndIf*/
			nCont++
			//Asize(aLiquida,len(aLiquida))
		enddo

	EndIf

	IF len(aRecLiq) > 0
		nCont := 1

		while nCont <= len(aRecLiq)
			DbselectArea("SE1")
			DbGoto(aRecLiq[nCont,1])
			nVlrOrig += aRecLiq[nCont,2]//SE1->E1_VALOR
			
			cQuery := "SELECT E1_NUMLIQ,SUM(E1_VALOR) AS TOTAL,SUM(E1_SALDO) AS SALDO,"
			cQuery += " SUM(E1_VALOR-E1_SALDO) AS BAIXADOS"
			cQuery += " FROM "+RetSQLName("SE1")
			cQuery += " WHERE E1_FILIAL='"+SE1->E1_FILIAL+"'"
			cQuery += " AND E1_NUM='"+SE1->E1_NUM+"'"
			cQuery += " AND E1_PREFIXO='"+SE1->E1_PREFIXO+"'"
			cQuery += " AND E1_CLIENTE='"+SE1->E1_CLIENTE+"'"
			cQuery += " AND E1_LOJA='"+SE1->E1_LOJA+"'"
			cQuery += " AND E1_TIPO='"+SE1->E1_TIPO+"'"
			cQuery += " AND E1_NUMLIQ='"+SE1->E1_NUMLIQ+"'"
			cQuery += " GROUP BY E1_NUMLIQ"

			IF Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			ENDIF

			MemoWrite("FA070TIT.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

			DbSelectArea("TRB")

			While !EOF()
				nRet += TRB->SALDO
				Dbskip()
			EndDo
			nCont++
					//Asize(aLiquida,len(aLiquida))
		EndDo
	ENDIF

RestArea(aArea)

Return(nRet)

