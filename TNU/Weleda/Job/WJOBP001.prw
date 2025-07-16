#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WJOBP001
Job para envio do estoque por armazem para o IQVIA
@type user function
@author Alexandre Venâncio
@since 03/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WJOBP001(cCodigo)

	Local aArea 	:= 	GetArea()
	Local aBody 	:= 	''
	Local oJson 	:= 	Nil
	Local aCampos 	:= 	{}
	Local cCampos 	:= 	""
	Local aHeader1	:=	{}
	Local aHeader2	:=	{}
	Local aHeader3	:=	{}
	Local cQuery 	:=	""
	Local lOk 		:=	.F.
	Local cJson		:=	""
	Local aPath1	:=	{}
	Local aPath2	:=	{}
	Local aPath3	:=	{}
	Local aRet 		:=	{}
	Local lQuery	:=	.T.

	Private CTIMESTAMP := ''
	
	Default cCodigo	:= 	'000002'

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","010101")
	EndIf	

	//Environment de chamada
	cEnviron := UPPER(GetEnvServer())

	aBody := U_WGENM001(cCodigo,.F.)

	If len(aBody) > 0
		oJson := JsonObject():New()
		ret := oJson:FromJson(aBody[1])
		
		if ValType(ret) == "C"
			conout("Falha ao transformar texto em objeto json. Erro: " + ret)
			return
		endif

		//Busca Campos configurados e aHeader de cada ambiente
		U_WFUNX006(aBody,@aCampos,@cCampos,@aHeader1,@aHeader2,@aHeader3)

		CTIMESTAMP := aBody[2,16]
		//Busca as informações de destino da API - Path
		U_WFUNX003(@aPath1,@aPath2,@aPath3,aBody[2])

		lQuery := aPath1[3] != "2"
		
		//Monta os aheaders por ambiente
		U_WFUNX008(@aHeader1,@aHeader2,@aHeader3)
		
		If lQuery
			If !Empty(aBody[2,17])
				cQuery := aBody[2,17]
				If !Empty(cCampos)
					cQuery := strtran(UPPER(cQuery),"%CAMPOS%",cCampos)
				EndIf 

				If "%CTIMESTAMP%" $ upper(cQuery) .And. valtype(CTIMESTAMP) == "C"
					cQuery := strtran(upper(cQuery),"%CTIMESTAMP%",CTIMESTAMP)
				EndIf 
			Else 
				cQuery := MontaQry(cCampos)
			EndIf 

			PlsQuery(cQuery, "TRB")
			DbSelectArea("TRB")
			nTotal := 0
			Count To nTotal
		
			//Caso não seja para enviar os itens todos em uma chamada só, 
			// mudar aqui para pegar pelo total item a item
			//Atualiza o objeto do json com os dados resultantes da query
			lOk := U_WFUNX002(cQuery,aBody[3],@oJson,aCampos)
		Else 
			lOk := .T.
		EndIf

		If lOk 
			cJson := oJson:toJson()
			If "DEV" $ cEnviron 
				aRet := U_WFUNX009(cEnviron,aPath1,cJson,aHeader1)
			ElseIf "QA" $ cEnviron
				aRet := U_WFUNX009(cEnviron,aPath2,cJson,aHeader2)
			ElseIf "PROD" $ cEnviron
				aRet := U_WFUNX009(cEnviron,aPath3,cJson,aHeader3)
			EndIf 
			
			If len(aRet) < 1
				aRet := {{.F.,''}}
			EndIf 
			
		Else 
			cJson := '{Sem dados para envio}'
			aRet := {{.T.,''}}
		EndIF 

		//Gravar retorno da API de destino
		U_WFUNX004(aPath2,cJson,aHeader2,aRet,cCodigo)
		//Atualizar o campo com a data e hora da ultima execução para comparação com o stamp depois
		U_WFUNX005(cCodigo)

	Else 

	EndIf 

	RestArea(aArea)

Return

/*/{Protheus.doc} MontaQry
	Monta a query desta integração
	@type  Static Function
	@author user
	@since 10/04/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function MontaQry(cCampos)

Local cQuery 	:= " "

//cQuery += " SELECT B2_FILIAL,B2_LOCAL,NNR_DESCRI,B2_COD,B2_DMOV,B2_QATU-B2_RESERVA AS B2_QATU   " 
cQuery := " SELECT "+cCampos
cQuery += " FROM   SB2010 B2   " 
cQuery += " INNER JOIN NNR010 NR ON NNR_FILIAL='D MG'   " 
cQuery += "        AND NNR_CODIGO=B2_LOCAL   " 
cQuery += "        AND NR.D_E_L_E_T_=' '   " 
cQuery += " WHERE  B2_QATU-B2_RESERVA>0   " 
cQuery += "        AND B2_FILIAL='D MG 01 '   " 
cQuery += "        AND B2.D_E_L_E_T_=' '   " 
//cQuery += "        AND B2_DMOV>='20230101'   " 
//cQuery += " 	   AND COALESCE(TO_CHAR(SB2010.S_T_A_M_P_,'YYYYMMDDHH24MISS'),'19810101000000' ) >= 'CTIMESTAMP' "
cQuery += "  AND ISNULL(CONVERT(VARCHAR(14), B2.S_T_A_M_P_, 112) + RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(HOUR, B2.S_T_A_M_P_)), 2) + "
cQuery += "  RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(MINUTE, B2.S_T_A_M_P_)), 2) + "
cQuery += "  RIGHT('0' + CONVERT(VARCHAR(2), DATEPART(SECOND, B2.S_T_A_M_P_)), 2), '19810101000000') >= '"+CTIMESTAMP+"'"

Return(cQuery)
