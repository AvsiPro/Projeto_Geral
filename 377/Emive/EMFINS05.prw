#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "CNTA130.CH"

/*/{Protheus.doc} EMFINS05
Schedule para checar a baixa de titulos prorrogados.
Especificação Funcional - MIT041 - FINANCEIRO - RFP - 1_36
@author Desenvolvedores Grupo 377
@since 01.10.2023
/*/
User Function EMFINS05()
	Local cQry 		:= ""
	Local cAliasA 	:= ""
	Local oQry		:= Nil
	Local cBco 		:= ""
	Local cAge 		:= ""
	Local cConta 	:= ""
	Local nY		:= 0
	Local lJob		:= Select( "SX6" ) == 0
	Local cJobEmp	:= '01'
	Local cJobFil	:= '01001'
	Local cErr		:= ""
	Local aEmp		:= {}
	Local nX 		:= 0

	If lJob
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .T.
	Private lAutoErrNoFile 	:= .T.

	ProcLogIni( {},"EMFINS05" )
	ProcLogAtu("INICIO", "SE1 - Checar baixa de titulos prorrogados")

	While SM0->(!EOF())
		aAdd(aEmp, {SM0->M0_CODIGO,SM0->M0_CODFIL})
		SM0->(DbSkip())
	EndDo

	For nX := 1 To Len(aEmp)
		cJobEmp := aEmp[nX][1]
		cJobFil := aEmp[nX][2]

		RpcClearEnv()
		RpcSetEnv( cJobEmp, cJobFil )

		cBco	:= SuperGetMv("EM_ZBANCO",.F.,"",cFilAnt)
		cAge	:= SuperGetMv("EM_ZAGENC",.F.,"",cFilAnt)
		cConta 	:= SuperGetMv("EM_ZCONTA",.F.,"",cFilAnt)

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
			ProcLogAtu("MENSAGEM", "Banco/Agencia/Conta nao encontrado")
			(cAliasA)->( DbCloseArea() )
			Loop
		Else
			SA6->( DbGoTo( (cAliasA)->RECSA6 ) )
		EndIf
		(cAliasA)->( DbCloseArea() )

		cQry := " SELECT R_E_C_N_O_ AS RECSE1 FROM ? "
		cQry += " WHERE D_E_L_E_T_ <> '*' "
		cQry += " AND E1_SALDO > 0 "
		cQry += " AND E1_ZCHAVE <> '' "
		cQry += " AND E1_VENCTO < ? "
		cQry := ChangeQuery(cQry)
		oQry := FWPreparedStatement():New(cQry)

		oQry:SetUnsafe(1, RetSqlName( "SE1" ))
		oQry:SetString(2, DtoS(Date()))

		cQry 		:= oQry:GetFixQuery()
		cAliasA	:= MPSysOpenQuery( cQry )

		(cAliasA)->( DbGoTop() )
		While (cAliasA)->(!Eof())
			DbSelectarea('SE1')
			SE1->( DbGoTo( (cAliasA)->RECSE1 ) )

			cChave := SE1->E1_ZCHAVE

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
				ProcLogAtu("MENSAGEM", cErr)
				(cAliasA)->( DbSkip() )
				Loop
			Else
				SE1->( DbSetOrder(1))
				SE1->(DbSeek(cChave))

				aBaixa := {}
				aBaixa:={	{"E1_FILIAL"	,SE1->E1_FILIAL 			,Nil},;
					{"E1_PREFIXO" 	,SE1->E1_PREFIXO 			,Nil},;
					{"E1_NUM" 		,SE1->E1_NUM 				,Nil},;
					{"E1_PARCELA" 	,SE1->E1_PARCELA 			,Nil},;
					{"E1_TIPO" 		,SE1->E1_TIPO 				,Nil},;
					{"E1_NATUREZ" 	,SE1->E1_NATUREZ 			,Nil},;
					{"E1_CLIENTE" 	,SE1->E1_CLIENTE 			,Nil},;
					{"E1_LOJA" 		,SE1->E1_LOJA 				,Nil}}

				MSExecAuto({|x,y,b,a| Fina070(x,y,b,a)},aBaixa,5)

				If lMsErroAuto
					aLog := GetAutoGRLog()
					For nY := 1 To Len(aLog)
						cErr += AllTrim(aLog[nY])
					Next nY
					cErr := StrTran(cErr,CHR(13)+CHR(10))
					ProcLogAtu("MENSAGEM", cErr)
					(cAliasA)->( DbSkip() )
					Loop
				EndIf
			EndIf
			(cAliasA)->( DbSkip() )
		End
		(cAliasA)->( DbCloseArea() )
	Next nX
	ProcLogAtu("FIM")

Return
