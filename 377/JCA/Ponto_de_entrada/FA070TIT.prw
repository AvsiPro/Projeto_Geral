#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#Include "RPTDEF.CH"
#INCLUDE "topconn.ch"

/*

	Ponto de entrada FA070TIT sera executado apos a confirmacao da baixa do contas a receber.

	Utilizado para enviar ao Tracker as baixas das faturas realizadas

*/
User function FA070TIT()

	Local cInst         := GETMV("MV_INSCOB")
	Local cTipBx        := SuperGetmv("TI_TIPBXT",.F.,"FT")
	Local lLigaTr       := SuperGetmv("TI_LIGINT",.F.,.T.)
	Private nBkpRec		:= SE1->(recno())
	Private aItemsFI2   := {}
	Private nVlrOrig 	:= 0
	Private nValBai		:= 0
	Private nVlrBaixa   := 0
	Private aRecLiq  := {}

	IF cInst == "1" .And. !EMPTY(SE1->E1_IDCNAB) .And. !EMPTY(SE1->E1_NUMBOR)
		If  MSGYESNO("Titulo se encontra em cobrança bancária. Deseja gerar instrução de cobrança? ")
			DbselectArea("FI2")
			DbSetOrder(1)//FI2_FILIAL+FI2_CARTEI+FI2_NUMBOR+FI2_PREFIX+FI2_TITULO+FI2_PARCEL+FI2_TIPO+FI2_CODCLI+FI2_LOJCLI+FI2_OCORR+FI2_GERADO
			If !Dbseek(xFilial("FI5")+SE1->E1_SITUACA+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+"02"+"2")
				Aadd(aItemsFI2,{"02","","",dtoc(ddatabase),"E1_BAIXA","D"})
				U_F040GrvFI2(aItemsFI2)
			EndIf
			FI2->(MsUnLock())
		EndIf
	EndIf

	If lLigaTr
		If !Empty(cTipBx)
			If !Empty(SE1->E1_NUMLIQ)
				nSaldo := conssld()
				//posiciona novamente
				SE1->(DbGoTo(nBkpRec))
				If Alltrim(SE1->E1_TIPO) $ cTipBx //.And. (nSaldo == nValrec .or. (nSaldo == 0 .And. nVlrOrig > 0))
					If nSaldo == 0 .And. nVlrOrig > 0
						nVlrBaixa := SldLiq()
						IF nVlrOrig == nValBai + nValrec
							EnvTrck(nVlrOrig)
						ENDIF
						//ÊnVlrBaixa := nVlrOrig
					//Else
					//	nVlrBaixa := SldLiq()
					EndIf
					//EnvTrck(nVlrBaixa)
				EndIf
				SE1->(DbGoTo(nBkpRec))
			Else
				nSaldo := SldParc()
				If Alltrim(SE1->E1_TIPO) $ cTipBx 
					If (SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC) == nValrec
						nValrec := SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC+nSaldo
						EnvTrck(nValrec)
					ElseIf  (nSaldo+SE1->E1_SALDO-SE1->E1_ACRESC-SE1->E1_DECRESC) == SE1->E1_VALOR .aND. (nSaldo+nValrec-SE1->E1_ACRESC-SE1->E1_DECRESC) == SE1->E1_VALOR
						nValrec := SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_DECRESC
						EnvTrck(nValrec)
					EndIf 
					
				EndIf
			EndIf
		EndIf
	EndIF

Return .T.

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
Static Function EnvTrck(nVlrBaixa)

	Local aArea     := GetArea()
	Local oEnvio    := JsonObject():New()
	Local cApiDest  := SuperGetMV("TI_APIDES",.F.,"https://buslog.track3r.com.br")
	Local cEndPnt   := SuperGetMV("TI_ENDPNT",.F.,"/api/totvs-protheus/confirma-pagamento-fatura")
	Local cToken    := SuperGetMV("TI_TOKTRK",.F.,'0D901F83-1739-41E3-995B-7303EF0BB19A')
	Local nCont 	:= 0


	IF len(aRecLiq) == 0

		//DbselectArea("SE1")
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
		oEnvio['valor']     := If(nVlrBaixa>0,nVlrBaixa,SE1->E1_VALOR) //SE1->E1_VALOR
		oEnvio['historico'] := SE1->E1_HIST
		oEnvio['motivo_baixa'] := cMotBx
		oEnvio['movimento'] := 'liquidacao'
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
			oEnvio['valor']     := aRecLiq[nCont,2]//?SE1->E1_VALOR//If(nVlrBaixa>0,nVlrBaixa,SE1->E1_VALOR)
			oEnvio['historico'] := SE1->E1_HIST
			oEnvio['motivo_baixa'] := cMotBx
			oEnvio['movimento'] := 'liquidacao'
			oEnvio['usuario']   := cusername

			cRet := oEnvio:toJson()

			ApiEnv04(cApiDest,cEndPnt,cRet,cToken)

		NEXT nCont
	ENDIF
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
	cQuery := "SELECT DISTINCT E5.E5_VALOR,E1.R_E_C_N_O_ E1RECNO,E1_NUMLIQ,E1_TIPOLIQ"
	cQuery += " FROM "+RetSQLName("SE5")+" E5"
	cQuery += " INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E1_CLIENTE=E5_CLIFOR AND E1_LOJA=E5_LOJA AND E1.D_E_L_E_T_=' '"
	//cQuery += " INNER JOIN "+RetSQLName("FO0")+" FO0 ON FO0_FILIAL=E5_FILIAL AND FO0_NUMLIQ=E5_DOCUMEN AND FO0.D_E_L_E_T_=' '"
	cQuery += " WHERE "
	cQuery += " E5_IDORIG IN (SELECT E5_IDORIG FROM "+RetSQLName("SE5")+" E5 "
	cQuery += "     INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=E5_FILIAL AND E1_PREFIXO=E5_PREFIXO AND E1_NUM=E5_NUMERO AND E1_PARCELA=E5_PARCELA AND E1_CLIENTE=E5_CLIFOR AND E1_LOJA=E5_LOJA AND E1.D_E_L_E_T_=' '"
	cQuery += "     WHERE E5_FILIAL='"+SE1->E1_FILIAL+"' AND E5_CLIFOR='"+SE1->E1_CLIENTE+"' AND E1_NUMLIQ='"+SE1->E1_NUMLIQ+"' AND E5.D_E_L_E_T_=' ') "
	cQuery += " OR E5_DOCUMEN='"+SE1->E1_NUMLIQ+"' AND E1_TIPOLIQ = 'LIQ'"
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
			nValBai += TRB->E5_VALOR
			//exit
		EndIf
		Dbskip()
	EndDo

	If nRecPrcp == 0
		nCont := 1

		while nCont <= len(aLiquida)
			cQuery := "SELECT DISTINCT E1.R_E_C_N_O_ E1RECNO,E1_NUMLIQ,E1_TIPOLIQ"
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

/*/{Protheus.doc} SldLiq
    Soma total dos titulos liquidados
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
Static Function SldLiq()

	Local aArea := GetArea()
	Local nRet  :=  0
	Local cQuery

	cQuery := "SELECT E1_NUMLIQ,SUM(E1_VALOR) AS TOTAL"
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

	nRet := TRB->TOTAL

	RestArea(aArea)

Return(nRet)

/*/{Protheus.doc} SldParc()
	(long_description)
	@type  Static Function
	@author user
	@since 15/01/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function SldParc()

Local aArea  := GetArea()
Local cQuery := ""	
Local nRet   := 0

cQuery := "SELECT SUM(E5_VALOR) AS SLDBAIXA FROM "+RetSQLName("SE5")      
cQuery += " WHERE E5_FILIAL='"+SE1->E1_FILIAL+"' AND E5_CLIFOR='"+SE1->E1_CLIENTE+"'"
cQuery += " AND E5_PREFIXO='"+SE1->E1_PREFIXO+"' AND E5_NUMERO='"+SE1->E1_NUM+"'"
cQuery += " AND E5_PARCELA='"+SE1->E1_PARCELA+"' AND E5_TIPODOC NOT IN('JR','ES') AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
ENDIF

MemoWrite("FA070TIT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

nRet := TRB->SLDBAIXA

cQuery := "SELECT SUM(E5_VALOR) AS SLDBAIXA FROM "+RetSQLName("SE5")      
cQuery += " WHERE E5_FILIAL='"+SE1->E1_FILIAL+"' AND E5_CLIFOR='"+SE1->E1_CLIENTE+"'"
cQuery += " AND E5_PREFIXO='"+SE1->E1_PREFIXO+"' AND E5_NUMERO='"+SE1->E1_NUM+"'"
cQuery += " AND E5_PARCELA='"+SE1->E1_PARCELA+"' AND E5_TIPODOC ='ES' AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
ENDIF

MemoWrite("FA070TIT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

nRet -= TRB->SLDBAIXA

RestArea(aArea)

Return(nRet) 
