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

        RpcSetType(3)
        RPCSetEnv('01','0101')

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
            Z01->(DbSetOrder(1))
            If Z01->(DbSeek(xFilial('Z01')+AvKey(Alltrim(Upper(cUser)),'Z01_USER')))
                If Alltrim(cPass) == Alltrim(Z01->Z01_PASS)
                    
                    cQuery := " SELECT A3_NREDUZ, A3_EMAIL, A3_END, A3_BAIRRO, A3_MUN, A3_DDDTEL, A3_TEL FROM "+RetSqlName('SA3')+" "
                    cQuery += " WHERE A3_TOKEN = '"+Z01->Z01_TOKEN+"'

                    cAliasTMP := GetNextAlias()
                    MPSysOpenQuery(cQuery, cAliasTMP)

                    cAddress := Alltrim((cAliasTMP)->A3_END) + " - " + Alltrim((cAliasTMP)->A3_BAIRRO) + " - " + Alltrim((cAliasTMP)->A3_MUN)
                    cPhone   := Alltrim((cAliasTMP)->A3_DDDTEL) + Alltrim((cAliasTMP)->A3_TEL)

                    cResultAux := '"token" : "'+Z01->Z01_TOKEN+'",'
                    cResultAux += '"name" : "'+fRemoveCarc((cAliasTMP)->A3_NREDUZ)+'",'
                    cResultAux += '"email" : "'+Alltrim(Lower((cAliasTMP)->A3_EMAIL))+'",'
                    cResultAux += '"address" : "'+fRemoveCarc(cAddress)+'",'
                    cResultAux += '"phone" : "'+fRemoveCarc(cPhone)+'",'
                    cResultAux += '"type" : "'+Z01->Z01_TYPE+'"'

                    cMessage := 'sucesso'
                Else
                    cMessage := "invalidpass"
                    cCode := "#400"
                EndIf
            Else
                cMessage := "invaliduser"
                cCode := "#400"
            EndIf
            
            Z01->(DbCloseArea())
            
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

	RpcClearEnv()

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
