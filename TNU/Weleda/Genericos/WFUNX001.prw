#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WFUNX001
Função generica para tratamentos diversos das integrações
@type user function
@author Alexandre Venâncio
@since 10/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WFUNX001(aJson,oJson)

	Local aArea := GetArea()
	Local aJAux		:= {}
	Local nCont 
	Local aCpoDst   := {} 

	For nCont := 1 to len(aJson)
		If aJson[nCont,06] == "P"
			Aadd(aJAux,{aJson[nCont,01],aJson[nCont,03],aJson[nCont,02]})
		EndIf 
	Next nCont 

	For nCont := 1 to len(aJAux)
		If Empty(aJAux[nCont,01])
			If oJson:hasProperty(aJAux[nCont,02])
				Aadd(aCpoDst,oJson[aJAux[nCont,02]][1]:Getnames())
				Aadd(aCpoDst[len(aCpoDst)],aJAux[nCont,02]+"#"+aJAux[nCont,01]+"#"+aJAux[nCont,03])
			EndIf 
		Else
			nPos := Ascan(aJAux,{|x| x[2] == aJAux[nCont,01]})
			If nPos > 0
				//Pai Esta na Raiz
				If Empty(aJAux[nPos,01])
					Aadd(aCpoDst,oJson[aJAux[nCont,01]][1][aJAux[nCont,02]][1]:Getnames())
					Aadd(aCpoDst[len(aCpoDst)],aJAux[nCont,02]+"#"+aJAux[nCont,01]+"#"+aJAux[nCont,03])
				EndIf 
			EndIf 
		EndIf 
	Next nCont 

	RestArea(aArea)

Return(aCpoDst)

/*/{Protheus.doc} WFUNX002
Executa querys e atualiza objeto do json com os dados
@type user function
@author user
@since 10/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WFUNX002(cQuery,aJson,oJson,aCampos)

	Local aArea := GetArea()
	Local nCont 
	Local nX 
	Local aCpoDst	:= U_WFUNX001(aJson,oJson)  //colocar em uma função para usar em todas
	Local lFirst	:= .T.
	Local aCorte	:= {}
	Local lRet      := .F.


	IF Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	ENDIF

	MemoWrite("WFUNX002.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	DbSelectArea("TRB")  

	While !EOF()
		lRet := .T.
		If lFirst
			For nCont := 1 to len(aCpoDst)
				aCorte := separa(aCpoDst[nCont,len(aCpoDst[nCont])],"#")
				For nX := 1 to len(aCpoDst[nCont])-1
					nPos := Ascan(aCampos,{|x| x[2]+x[3] == aCpoDst[nCont,nX]+aCorte[1]})
					If nPos > 0
						cContCpo := &("TRB->"+aCampos[nPos,01])
						
						If aCampos[nPos,5] == "S" .And. aCampos[nPos,6] > 0
							If len(cContCpo) > aCampos[nPos,6]
								cContCpo := substr(cContCpo,1,aCampos[nPos,6])
							EndIf 
						ElseIf aCampos[nPos,5] == "D"
							cContCpo := substr(cContCpo,1,4)+"-"+substr(cContCpo,5,2)+"-"+substr(cContCpo,7,2)+"T00:00:00.000Z"
						EndIf 

						nPos2 := Ascan(aCpoDst,{|x| aCpoDst[nCont,nX] $ x[len(x)]})
						If Empty(aCorte[2]) .And. nPos2 == 0
							//Validação para quando tiver uma macro para tratar o campo
							If aCampos[nPos,01] == oJson[aCorte[1]][1][aCpoDst[nCont,nX]]
								oJson[aCorte[1]][1][aCpoDst[nCont,nX]] := cContCpo
							Else 
								If "(" $ oJson[aCorte[1]][1][aCpoDst[nCont,nX]]
									oJson[aCorte[1]][1][aCpoDst[nCont,nX]] := &(oJson[aCorte[1]][1][aCpoDst[nCont,nX]])
								EndIf 
							EndIf 
						Else 
							oJson[aCorte[2]][1][aCorte[1]][1][aCpoDst[nCont,nX]] := cContCpo
						EndIf 
					// Else 
					// 	nPos2 := Ascan(aCpoDst,{|x| aCpoDst[nCont,nX] $ x[len(x)]})
					// 	If nPos2 == 0
					// 		If Empty(aCorte[2])
					// 			oJson[aCorte[1]][1][aCpoDst[nCont,nX]] := ""
								
					// 		Else 
					// 			oJson[aCorte[2]][1][aCorte[1]][1][aCpoDst[nCont,nX]] := ""
					// 		EndIf 
					// 	endIf 
					EndIf 
				Next nX 
			Next nCont
			lFirst := .F. 
		Else 
			//Aqui só percorre as chaves que são do tipo Array para incrementar
			For nCont := 1 to len(aCpoDst)
				aCorte := separa(aCpoDst[nCont,len(aCpoDst[nCont])],"#")

				If aCorte[3] == "1"
					oItem := JsonObject():New()
			
					For nX := 1 to len(aCpoDst[nCont])-1
						nPos := Ascan(aCampos,{|x| x[2]+x[3] == aCpoDst[nCont,nX]+aCorte[1]})
						If nPos > 0
							cContCpo := &("TRB->"+aCampos[nPos,01])
						
							If aCampos[nPos,5] == "S" .And. aCampos[nPos,6] > 0
								If len(cContCpo) > aCampos[nPos,6]
									cContCpo := substr(cContCpo,1,aCampos[nPos,6]-1)
								EndIf 
							ElseIf aCampos[nPos,5] == "D"
								cContCpo := substr(cContCpo,1,4)+"-"+substr(cContCpo,5,2)+"-"+substr(cContCpo,7,2)+"T00:00:00.000Z"
							ElseIf aCampos[nPos,5] == "N"
								cContCpo := Round(cContCpo,0)
							EndIf 

							//oItem[aCpoDst[nCont,nX]] := cContCpo //&("TRB->"+aCampos[nPos,01])

							//Validação para quando tiver uma macro para tratar o campo
							If !Empty(aCampos[nPos,07]) //aCampos[nPos,01] == oItem[aCpoDst[nCont,nX]]
								If "(" $ aCampos[nPos,07]
									oItem[aCpoDst[nCont,nX]] := &(aCampos[nPos,07])
								Else 
									oItem[aCpoDst[nCont,nX]] := aCampos[nPos,07]
								EndIf 
							Else
								oItem[aCpoDst[nCont,nX]] := cContCpo
							EndIf 
						Else 
							oItem[aCpoDst[nCont,nX]] := ""
						EndIf 
					Next nX 

					If Empty(aCorte[2])
						Aadd(oJson[aCorte[1]][1],oItem)
					Else 
						Aadd(oJson[aCorte[2]][1][aCorte[1]],oItem)
					EndIf 

					
				EndIf 
			Next nCont 
			
		EndIf 

		Dbskip()
	EndDo 

	RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} WFUNX003
Monta os arrays com as informações de path de destino
@type user function
@author user
@since 10/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WFUNX003(aPath1,aPath2,aPath3,aArray)

	Local aArea := GetArea()
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
			15 - Z90_CALLBA
			16 - Z90_EXECUT
			17 - Z90_QUERY
	*/

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
	Aadd(aPath1,Alltrim(aArray[2]))
	Aadd(aPath1,Alltrim(aArray[5]))
	Aadd(aPath1,Alltrim(aArray[1]))
	Aadd(aPath1,Alltrim(aArray[9]))
	Aadd(aPath1,Alltrim(aArray[10]))
	Aadd(aPath1,Alltrim(aArray[11]))
	Aadd(aPath1,Alltrim(aArray[15]))
	Aadd(aPath1,Alltrim(aArray[16]))
	Aadd(aPath1,Alltrim(aArray[17]))

	Aadd(aPath2,Alltrim(aArray[3]))
	Aadd(aPath2,Alltrim(aArray[6]))
	Aadd(aPath2,Alltrim(aArray[1]))
	Aadd(aPath2,Alltrim(aArray[9]))
	Aadd(aPath2,Alltrim(aArray[10]))
	Aadd(aPath2,Alltrim(aArray[11]))
	Aadd(aPath2,Alltrim(aArray[15]))
	Aadd(aPath2,Alltrim(aArray[16]))
	Aadd(aPath2,Alltrim(aArray[17]))

	Aadd(aPath3,Alltrim(aArray[4]))
	Aadd(aPath3,Alltrim(aArray[7]))
	Aadd(aPath3,Alltrim(aArray[1]))
	Aadd(aPath3,Alltrim(aArray[9]))
	Aadd(aPath3,Alltrim(aArray[10]))
	Aadd(aPath3,Alltrim(aArray[11]))
	Aadd(aPath3,Alltrim(aArray[15]))
	Aadd(aPath3,Alltrim(aArray[16]))
	Aadd(aPath3,Alltrim(aArray[17]))

	RestArea(aArea)

Return

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

/*/{Protheus.doc} WFUNX004
Gravação do log de integração geral
@type user function
@author user
@since 10/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WFUNX004(aPath,cJson,aHeader,aRet,cCodApi)

    //[3] 1-Post 2-Get 3-Put 4-Delete 5-Patch
    //[4] 1-Rest 2-Soap
    //[5] 1-Sincrono 2-Assincrono
    //[6] 1-Sim 2-Nao - Requer autenticação
    Local aArea   := GetArea()
    Local cCodigo := GetSXEnum("Z92","Z92_COD")
    Local cHeader := ''

	Aeval(aHeader,{|x| cHeader += x + CHR(13)+CHR(10)})

    DbSelectArea("Z92")
    Reclock("Z92",.T.)
    Z92->Z92_COD    :=  cCodigo
    Z92->Z92_DATA   :=  dDataBase 
    Z92->Z92_HORA   :=  cvaltochar(time())
    Z92->Z92_FUNCAO :=  funname()
    Z92->Z92_URL    :=  aPath[1]
    Z92->Z92_PATH   :=  aPath[2]
    Z92->Z92_VERBO  :=  aPath[3]
    Z92->Z92_TIPO   :=  aPath[4]
    Z92->Z92_MODO   :=  aPath[5]
    Z92->Z92_REQAUT :=  aPath[6]
    Z92->Z92_HEADER :=  cHeader
    Z92->Z92_JSONEN :=  cJson
    Z92->Z92_STATUS :=  aRet[1,1]
    Z92->Z92_JSONRE :=  aRet[1,2]
	Z92->Z92_CODAPI :=  cCodApi
    Z92->(Msunlock())

	ConfirmSX8()
    RestArea(aArea)

Return

/*/{Protheus.doc} WFUNX005
Grava data e hora da ultima execução do job
@type user function
@author user
@since 15/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WFUNX005(cCodigo)

	Local aArea := GetArea()
	Local cTime := dtos(ddatabase)+strtran(cvaltochar(time()),":")

	DbSelectArea("Z90")
	DbSetOrder(1)
	If Dbseek(xFilial("Z90")+cCodigo)
		Reclock("Z90",.F.)
		Z90->Z90_ULTEXC := cTime 
		Z90->(Msunlock())
	EndIf 

	RestArea(aArea)

Return

/*/{Protheus.doc} WFUNX006
Montagem dos cabeçalhos generica
@type user function
@author user
@since 15/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WFUNX006(aBody,aCampos,cCampos,aHeader1,aHeader2,aHeader3)

	Local nCont := 0
	
	For nCont := 1 to len(aBody[3])
		If !Empty(aBody[3,nCont,4])
			Aadd(aCampos,{	aBody[3,nCont,4],;	
							aBody[3,nCont,3],;
							aBody[3,nCont,1],;
							space(val(aBody[3,nCont,8])),;
							aBody[3,nCont,6],;
							val(aBody[3,nCont,8]),;
							aBody[3,nCont,5]})
		EndIF 
	Next nCont 

	AEval(aCampos,{|x| cCampos += If(!x[1] $ cCampos,x[1]+",","")})

	cCampos := substr(cCampos,1,len(cCampos)-1)

	If len(aBody[2]) > 1
		aHeader1 := separa(aBody[2,12],";")
		aHeader2 := separa(aBody[2,13],";")
		aHeader3 := separa(aBody[2,14],";")
	Else 
		aHeader1 := {}
		aHeader2 := {}
		aHeader3 := {}
	EndIf 

Return

/*/{Protheus.doc} WFUNX007
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
User Function WFUNX007(aHeader)

	Local aArea 	:=	GetArea()
	Local nCont 
	Local nX,nY 
	Local aAux 		:=	{}
	Local aAux2		:=	{}
	Local cAux 		:= 	''
	Local cAux2 	:=	''
	Local nTamAr	:=	len(aHeader)
	Local cBkGetm	:=	""

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
			15 - Z90_CALLBA
			16 - Z90_ULTEXC
			17 - Z90_QUERY

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
					For nY := 1 to len(aAux2)
						If "GETMV" $ upper(aAux2[nY])
							cBkGetm := substr(aAux2[nY],at("(",aaux2[nY]),at(")",aaux2[nY]))
							cBkGetm := "SUPERGETMV"+substr(cBkGetm,1,len(cBkGetm)-1)+",.F.,'')"
						EndIf 
					Next nY 
					
					cAux  := &(cBkGetm)
					aAux[nX] := aAux2[1]+"="+If(valtype(cAux)<>"C","Parametro nao encontrado",cAux)
					// cAux  := &(aAux2[2])
					// aAux[nX] := aAux2[1]+"="+If(valtype(cAux)<>"C","Parametro nao encontrado",cAux)
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

/*/{Protheus.doc} WFUNX008
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
User Function WFUNX008(aHeader1,aHeader2,aHeader3)

	If len(aHeader1) > 0
		aHeader1 := U_WFUNX007(aHeader1)
	EndIf 
	If len(aHeader2) > 0
		aHeader2 := U_WFUNX007(aHeader2)
	EndIF 
	If len(aHeader3) > 0
		aHeader3 := U_WFUNX007(aHeader3)
	EndIf 

Return 
/*/{Protheus.doc} WFUNX009
	Função que faz a chamada de cada metodo da api configurada
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
User Function WFUNX009(cEnviron,aPath,cJson,aHeader)

	Local aArea := GetArea() 
	Local aRet  := {}

	//[3] 1-Post 2-Get 3-Put 4-Delete 5-Patch
	//[4] 1-Rest 2-Soap
	//[5] 1-Sincrono 2-Assincrono
	//[6] 1-Sim 2-Nao - Requer autenticação
	If aPath[3] == "1"
		aRet := U_WAPIPOST(aPath,cJson,aHeader)
	ElseIf aPath[3] == "2"
		aRet := U_WAPIGET(aPath,cJson,aHeader)
	EndIf 

	If aPath[5] == "1"
		If !Empty(aPath[7])

		EndIf 
	EndIf 

	// If "DEV" $ cEnviron .or. 'P2310' $ cEnviron
	// 	//[3] 1-Post 2-Get 3-Put 4-Delete 5-Patch
	// 	//[4] 1-Rest 2-Soap
	// 	//[5] 1-Sincrono 2-Assincrono
	// 	//[6] 1-Sim 2-Nao - Requer autenticação
	// 	If aPath1[3] == "1"
	// 		aRet := U_WAPIPOST(aPath1,cJson,aHeader1)
	// 	ElseIf aPath1[3] == "2"
	// 		aRet := U_WAPIGET(aPath1,cJson,aHeader1)
	// 	EndIf 

	// 	If aPath1[5] == "1"
	// 		If !Empty(aPath1[7])

	// 		EndIf 
	// 	EndIf 
	// ElseIf "QA" $ cEnviron
	// 	If aPath2[3] == "1"
	// 		aRet := U_WAPIPOST(aPath2,cJson,aHeader2)
	// 	ElseIf aPath2[3] == "2"
	// 		aRet := U_WAPIGET(aPath2,cJson,aHeader2)
	// 	EndIf 

	// 	If aPath2[5] == "1"
	// 		If !Empty(aPath2[7])

	// 		EndIf 
	// 	EndIf  
	// ElseIf "PROD" $ cEnviron
	// 	If aPath3[3] == "1"
	// 		aRet := U_WAPIPOST(aPath3,cJson,aHeader3)
	// 	ElseIf aPath3[3] == "2"
	// 		aRet := U_WAPIGET(aPath3,cJson,aHeader3)
	// 	EndIf 

	// 	If aPath3[5] == "1"
	// 		If !Empty(aPath3[7])

	// 		EndIf 
	// 	EndIf 
	// EndIf
	RestArea(aArea)
	
Return(aRet) 

/*/{Protheus.doc} WFUNX010
Validação de digitação do campo Pai, verifica se o conteúdo digitado esta presente no grid
@type user function
@author user
@since 25/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
/*User Function Z91bPos()

	// Local oModelPad  := FWModelActive()
    // Local cDescri    := oModelPad:GetValue('Z91DETAIL', 'Z91_CPOPAI')
    // Local lRet       := .F.
     
    // //Se a descrição estiver em branco
    // If Empty(cDescri) //.Or. Alltrim(Upper(cDescri)) == cDefault
    //     lRet := .F.
    //     Aviso('Atenção', 'Campo Descrição esta em branco!', {'OK'}, 03)
    // EndIf
	Local oModel   := FWGetModel("Z90MASTER")
    Local oDetail  := oModel:GetModel("Z91DETAIL")
    Local aItens   := oDetail:GetRows()
    Local nI, cCampo, xValor

    For nI := 1 To Len(aItens)
        cCampo := aItens[nI]["Z91_CAMPO"] // exemplo de campo
        xValor := aItens[nI]["Z91_VALOR"] // exemplo de valor
        
        If Empty(cCampo)
            FWAlertError("Campo 'Z91_CAMPO' está vazio na linha " + AllTrim(Str(nI)))
            Return .F.
        EndIf
    Next

Return(lRet)*/

/*/{Protheus.doc} VerJson()
    Carregar o json enviado pela API
    @type  Static Function
    @author user
    @since 31/10/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function _VerJson(cJson)

    Local cJsonFormatado := ''
    
    cJsonFormatado := JsonFormatar(cJson)
    // Exibe o JSON formatado em tela
    oJsonShow  := MSDialog():New( 092,232,727,915,"Json Recebido",,,.F.,,,,,,.T.,,,.T. )
    oMGet1     := TMultiGet():New( 004,008,{|u| If(Pcount()>0,cJsonFormatado:=u,cJsonFormatado)},oJsonShow,320,284,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
    //oJsonBt    := TButton():New( 292,144,"Sair",oJsonShow,{||oJsonShow:end()},037,012,,,,.T.,,"",,,,.F. )

    oJsonShow:Activate(,,,.T.)
    
Return

// Função para formatar o JSON
Static Function JsonFormatar(cJson)
    Local cResultado := ""
    Local nIndent := 0
    Local nLen := Len(cJson)
    Local i

    For i := 1 To nLen
        cChar := SubStr(cJson, i, 1)
        
        // Adiciona quebras de linha e indentação conforme necessário
        Do Case
            Case cChar == "{".Or.cChar == "["
                nIndent++
                cResultado += cChar + CRLF + Replicate(" ", nIndent * 4)
            Case cChar == "}".Or.cChar == "]"
                nIndent--
                cResultado += CRLF + Replicate(" ", nIndent * 4) + cChar
            Case cChar == ","
                cResultado += cChar + CRLF + Replicate(" ", nIndent * 4)
            Case cChar == ":"
                cResultado += cChar + " "
            Otherwise
                cResultado += cChar
        EndCase
    Next i

Return cResultado
