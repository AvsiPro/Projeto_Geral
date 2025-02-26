#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"


User Function WSAPP01()
Return

WsRestFul WSAPP01 DESCRIPTION "API REST - Evento Login" 
	
	WsMethod POST Description "API REST - Evento Login - METODO POST "  WsSyntax "WSAPP01"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService WSAPP01

	Local cCode	     := "#200"
	Local cMessage	 := ''
    Local cResult    := ''
    Local cResultAux := ''
	Local lRet	     := .T.
    Local cJson      := ::GetContent()
    Local oParser

	oBody  := JsonObject():New()

	If !FwJsonDeserialize(cJson,@oParser)
		cCode 		:= "#500"
		cMessage	:= "Formato Json nao reconhecido. Revisar a estrutura e layout informado."
		lRet		:= .F.
	Else

        //RpcSetType(3)
        //RPCSetEnv('01','0101')

        cUser := oParser:user
        cPass := oParser:pass

        If Empty(cUser)
            cCode 	 := "#400"
            cMessage := "emptyuser"
        EndIf

        If Empty(cPass) .And. lRet
            cCode 	 := "#400"
            cMessage := "emptypass"
        EndIf
    
        If lRet
            /*Z01->(DbSetOrder(1))
            If Z01->(DbSeek(xFilial('Z01')+AvKey(Alltrim(Upper(cUser)),'Z01_USER')))
                If Alltrim(cPass) == Alltrim(Z01->Z01_PASS)
                    If Z01->Z01_TYPE $ 'V/A'
                        cQuery := " SELECT A3_COD CODE, A3_NREDUZ NOME, A3_EMAIL EMAIL, A3_END ENDER, A3_BAIRRO BAIRRO, A3_MUN MUN, A3_DDDTEL DDD, A3_TEL TEL FROM "+RetSqlName('SA3')+" "
                        cQuery += " WHERE A3_TOKEN = '"+Z01->Z01_TOKEN+"'
                    Else
                        cQuery := " SELECT A1_COD CODE, A1_NREDUZ NOME, A1_EMAIL EMAIL, A1_END ENDER, A1_BAIRRO BAIRRO, A1_MUN MUN, A1_DDD DDD, A1_TEL TEL FROM "+RetSqlName('SA1')+" "
                        cQuery += " WHERE A1_TOKEN = '"+Z01->Z01_TOKEN+"'
                    EndIf

                    cAliasTMP := GetNextAlias()
                    MPSysOpenQuery(cQuery, cAliasTMP)

                    If (cAliasTMP)->(!Eof())
                        cResultAux := '"user" : "'+Alltrim(cUser)+'",'
                        cResultAux += '"password" : "'+Alltrim(cPass)+'",'
                        cResultAux += '"code" : "'+Alltrim((cAliasTMP)->CODE)+'",'
                        cResultAux += '"token" : "'+Z01->Z01_TOKEN+'",'
                        cResultAux += '"name" : "'+fRemoveCarc((cAliasTMP)->NOME)+'",'
                        cResultAux += '"email" : "'+Alltrim(Lower((cAliasTMP)->EMAIL))+'",'
                        cResultAux += '"address" : "'+fRemoveCarc(Alltrim((cAliasTMP)->ENDER) + " - " + Alltrim((cAliasTMP)->BAIRRO) + " - " + Alltrim((cAliasTMP)->MUN))+'",'
                        cResultAux += '"phone" : "'+fRemoveCarc(Alltrim((cAliasTMP)->DDD) + Alltrim((cAliasTMP)->TEL))+'",'
                        cResultAux += '"type" : "'+Z01->Z01_TYPE+'"'

                        cMessage := 'sucesso'
                    Else
                        cMessage := 'notfound'
                        cCode := "#404"
                    EndIf
                Else
                    cMessage := "invalidpass"
                    cCode := "#400"
                EndIf
            Else
                cMessage := "invaliduser"
                cCode := "#400"
            EndIf
            
            Z01->(DbCloseArea())
            (cAliasTMP)->(DbCloseArea())*/

            cResultAux := '"user" : "Alexandre",'
            cResultAux += '"password" : "1234",'
            cResultAux += '"code" : "1234",'
            cResultAux += '"token" : "1234",'
            cResultAux += '"name" : "Alexandre Venancio",'
            cResultAux += '"email" : "avenanc@yahoo.com.br",'
            cResultAux += '"address" : "Campina Grande - ",'
            cResultAux += '"phone" : "11988236138",'
            cResultAux += '"type" : "1"'

            cMessage := 'sucesso'
        EndIf

	EndIf

    cResult := '{'
    cResult += '"status" : {'
    cResult += '"code" : "'+cCode+'",'
    cResult += '"message" : "'+cMessage+'"'
    cResult += '},'
    cResult += '"result" : {'
    cResult += cResultAux
    cResult += '}'
    cResult += '}'

    ::SetContentType('application/json')
    ::SetResponse(cResult)

	//RpcClearEnv()

Return lRet


Static Function fRemoveCarc(cWord)
    cWord := FwCutOff(cWord, .T.)
    cWord := strtran(cWord,"ã","a")
	cWord := strtran(cWord,"á","a")
	cWord := strtran(cWord,"à","a")
	cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,",","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, ">", "")
    cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "(", "")
    cWord := StrTran(cWord, ")", "")
    cWord := StrTran(cWord, "_", "")
    cWord := StrTran(cWord, "=", "")
    cWord := StrTran(cWord, "+", "")
    cWord := StrTran(cWord, "{", "")
    cWord := StrTran(cWord, "}", "")
    cWord := StrTran(cWord, "[", "")
    cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, "\", "")
    cWord := StrTran(cWord, "|", "")
    cWord := StrTran(cWord, ":", "")
    cWord := StrTran(cWord, ";", "")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := Alltrim(Lower(cWord))
Return cWord
