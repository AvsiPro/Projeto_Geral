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

MemoWrite("WESTJ001.SQL",cQuery)
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
					nPos2 := Ascan(aCpoDst,{|x| aCpoDst[nCont,nX] $ x[len(x)]})
					If Empty(aCorte[2]) .And. nPos2 == 0
						oJson[aCorte[1]][1][aCpoDst[nCont,nX]] := &("TRB->"+aCampos[nPos,01])
					Else 
						oJson[aCorte[2]][1][aCorte[1]][1][aCpoDst[nCont,nX]] := &("TRB->"+aCampos[nPos,01])
					EndIf 
				Else 
					nPos2 := Ascan(aCpoDst,{|x| aCpoDst[nCont,nX] $ x[len(x)]})
					If nPos2 == 0
						If Empty(aCorte[2])
							oJson[aCorte[1]][1][aCpoDst[nCont,nX]] := ""
							//oJson["Content"][1]["Items"][1][aCpoDst[nCont,nX]] := &("TRB->"+aCampos[nPos,01])
						Else 
							oJson[aCorte[2]][1][aCorte[1]][1][aCpoDst[nCont,nX]] := ""
						EndIf 
					endIf 
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
						oItem[aCpoDst[nCont,nX]] := &("TRB->"+aCampos[nPos,01])
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
*/
Aadd(aPath1,Alltrim(aArray[2]))
Aadd(aPath1,Alltrim(aArray[5]))
Aadd(aPath1,Alltrim(aArray[1]))
Aadd(aPath1,Alltrim(aArray[9]))
Aadd(aPath1,Alltrim(aArray[10]))
Aadd(aPath1,Alltrim(aArray[11]))

Aadd(aPath2,Alltrim(aArray[3]))
Aadd(aPath2,Alltrim(aArray[6]))
Aadd(aPath2,Alltrim(aArray[1]))
Aadd(aPath2,Alltrim(aArray[9]))
Aadd(aPath2,Alltrim(aArray[10]))
Aadd(aPath2,Alltrim(aArray[11]))

Aadd(aPath3,Alltrim(aArray[4]))
Aadd(aPath3,Alltrim(aArray[7]))
Aadd(aPath3,Alltrim(aArray[1]))
Aadd(aPath3,Alltrim(aArray[9]))
Aadd(aPath3,Alltrim(aArray[10]))
Aadd(aPath3,Alltrim(aArray[11]))

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
    oJsonBt    := TButton():New( 292,144,"Sair",oJsonShow,{||oJsonShow:end()},037,012,,,,.T.,,"",,,,.F. )

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
