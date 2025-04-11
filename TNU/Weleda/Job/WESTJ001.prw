#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WESTJ001
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
User Function WESTJ001(cCodigo)

Local aArea 	:= 	GetArea()
Local aBody 	:= 	''
Local oJson 	:= 	Nil
Local nCont 	:= 	0

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

Default cCodigo	:= 	'000003'

If Empty(FunName())
	RpcSetType(3)
	RPCSetEnv("T1","D MG 01 ")
EndIf	

//Environment de chamada
cEnviron := GetEnvServer()

aBody := U_WGENM001(cCodigo,.F.)

If len(aBody) > 0
	oJson := JsonObject():New()
	ret := oJson:FromJson(aBody[1])
	
	if ValType(ret) == "C"
		conout("Falha ao transformar texto em objeto json. Erro: " + ret)
		return
	endif

	For nCont := 1 to len(aBody[3])
		If !Empty(aBody[3,nCont,4])
			Aadd(aCampos,{	aBody[3,nCont,4],;	
							aBody[3,nCont,3],;
							aBody[3,nCont,1],;
							space(val(aBody[3,nCont,8]))})
		EndIF 
	Next nCont 

	AEval(aCampos,{|x| cCampos += If(!x[1] $ cCampos,x[1]+",","")})

	cCampos := substr(cCampos,1,len(cCampos)-1)

	aHeader1 := separa(aBody[2,12],";")
	aHeader2 := separa(aBody[2,13],";")
	aHeader3 := separa(aBody[2,14],";")

	U_WFUNX003(@aPath1,@aPath2,@aPath3,aBody[2])

	lQuery := aPath1[3] != "2"
	
	If len(aHeader1) > 0
		aHeader1 := InfoHead(aHeader1)
	EndIf 
	If len(aHeader2) > 0
		aHeader2 := InfoHead(aHeader2)
	EndIF 
	If len(aHeader3) > 0
		aHeader3 := InfoHead(aHeader3)
	EndIf 

	If lQuery
		cQuery := MontaQry(cCampos)

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
			//[3] 1-Post 2-Get 3-Put 4-Delete 5-Patch
			//[4] 1-Rest 2-Soap
			//[5] 1-Sincrono 2-Assincrono
			//[6] 1-Sim 2-Nao - Requer autenticação
			If aPath1[3] == "1"
				aRet := U_WAPIPOST(aPath1,cJson,aHeader1)
			ElseIf aPath1[3] == "2"
				aRet := U_WAPIGET(aPath1,cJson,aHeader1)
			EndIf 
		ElseIf "QA" $ cEnviron
			If aPath2[3] == "1"
				aRet := U_WAPIPOST(aPath2,cJson,aHeader2)
			EndIF 
		ElseIf "PROD" $ cEnviron
			If aPath3[3] == "1"
				aRet := U_WAPIPOST(aPath3,cJson,aHeader3)
			EndIf 
		EndIf 

		U_WFUNX004(aPath2,cJson,aHeader2,aRet,cCodigo)
		
	EndIF 

Else 

EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} InfoHead
	Informações referentes aos headers da chamada
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
Static Function InfoHead(aHeader)

Local aArea := GetArea()
Local nCont 
Local nX 
Local aAux 		:=	{}
Local aAux2		:=	{}
Local cAux 		:= 	''
Local cAux2 	:=	''
Local nTamAr	:=	len(aHeader)

/*
	Informações do Header
		01 - Z90_VERBO		1-Post 2-Get 3-Put 4-Delete 5-Patch
		02 - Z90_URLDEV
		03 - Z90_URLQA
		04 - Z90_URLPRD
		05 - Z90_ENDDEV
		06 - Z90_ENDQA
		07 - Z90_ENDPRD
		08 - Z90_DESC
		09 - Z90_TIPO		1-Rest 2-Soap
		10 - Z90_MODCOM		1-Sincrono 2-Assincrono
		11 - Z90_REQAUT  	1-Sim 2-Nao
		12 - Z90_HEADDV		
		13 - Z90_HEADQA
		14 - Z90_HEADPR

		Se requer autenticação, criar parametro MV_PARXX e colocar a informação 
			no Header (DEV,QA,PRD) a chamada do parametro no seguinte formato
			
		Para envio somente de usuário e senha
		[AUTHENTICATOR%user=MV_PARXX%,%password=MV_PARXX%]
		Quando há necessidade de primeiro fazer uma chamada para recuperar o token
		[AUTHENTICATOR#token#%user=MV_PARXX%,%password=MV_PARXX%]
		Quando o Token já é fornecido antecipadamente
		[AUTHENTICATOR#token=MV_PARXX]

		Em seguida, colocar a informação de autorização no header após as demais informações de header para a api

		exemplo
		Content-Type: application/json
		Authorization Basic ou Bearer token

*/
For nCont := 1 to len(aHeader)	
	aHeader[nCont] := strtran(aHeader[nCont],CHR(13)+CHR(10),"")
	cAux2 := ''

	If "[" $ aHeader[nCont]
		cAux := strtran(strtran(strtran(aHeader[nCont],"[",""),"]",""),"%","")
		aAux := separa(cAux,",")
		For nX := 1 to len(aAux)
			If "GETMV" $ upper(aAux[nX])
				aAux2 := separa(strtran(aAux[nX],'AUTHENTICATOR#',''),"=")
				cAux  := &(aAux2[2])
				aAux[nX] := aAux2[1]+"="+If(valtype(cAux)<>"C","Parametro nao encontrado",cAux)
			EndIF 
		Next nX 	

		Aeval(aAux,{|x| cAux2 += x + ','})	
		aHeader[nCont] := If("[AUTHENTICATOR" $ aHeader[nCont],"AUT_","")+substr(cAux2,1,len(cAux2)-1)
	EndIf 

	If "GETMV" $ upper(aHeader[nCont])
		cCmd1 := SUBSTR(aHeader[nCont],at("GETMV",UPPER(aHeader[nCont])),at(")",aHeader[nCont]))
		cCmd2 := 'SUBSTR(aHeader[nCont],at("GETMV",UPPER(aHeader[nCont])),at(")",aHeader[nCont]))'
		aHeader[nCont] := strtran(aHeader[nCont],cCmd1,&(&(cCmd2)))
	EndIf 

	If "!TOKEN?" $ upper(aHeader[nCont])
		nPos := Ascan(aHeader,{|x| 'TOKEN=' $ upper(x)})

		If nPos > 0
			aHeader[nCont] := strtran(aHeader[nCont],'!token?',substr(aHeader[nPos],AT('token=',aHeader[nPos])+6))
		EndIf 
	EndIf 
Next nCont

nX := 1

While nX <= nTamAr
	If Empty(aHeader[nX]) .Or. substr(aHeader[nX],1,4) == "AUT_"
		Adel(aHeader,nX)
		Asize(aHeader,len(aHeader)-1)
		nTamAr--
	Else 
		nX++
	EndIF 
	
EndDo

RestArea(aArea)

Return(aHeader)


/*
	Informações dos itens

		01 - Z91_CPOPAI	
		02 - Z91_TIPPAI		1-Array 2-Objeto
		03 - Z91_CPODES
		04 - Z91_CPOORI
		05 - Z91_CNTFIX		Conteudo fixo
		06 - Z91_TIPCNT		S-String D-Datetime B-Boolean P-Pai
		07 - Z91_ITEM
		08 - Z91_MAXLEN		Tamanho maximo do campo no destino
*/

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
cQuery += " FROM   SB2T10 B2   " 
cQuery += " INNER JOIN NNRT10 NR ON NNR_FILIAL='D MG'   " 
cQuery += "        AND NNR_CODIGO=B2_LOCAL   " 
cQuery += "        AND NR.D_E_L_E_T_=' '   " 
cQuery += " WHERE  B2_QATU-B2_RESERVA>0   " 
cQuery += "        AND B2_FILIAL='D MG 01 '   " 
cQuery += "        AND B2.D_E_L_E_T_=' '   " 
cQuery += "        AND B2_DMOV>='20230101'   " 

Return(cQuery)
