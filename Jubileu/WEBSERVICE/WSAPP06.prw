#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"


User Function WSAPP06()
Return

WsRestFul WSAPP06 DESCRIPTION "API REST - Evento Change Password" 
	
	WsMethod POST Description "API REST - Evento Change Password - METODO POST "  WsSyntax "WSAPP06"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService WSAPP06

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
        cNewPass := oParser:newpass
    
        If lRet
            Z01->(DbSetOrder(1))
            If Z01->(DbSeek(xFilial('Z01')+AvKey(Alltrim(Upper(cUser)),'Z01_USER')))
                If Alltrim(cPass) == Alltrim(Z01->Z01_PASS)
                    
                    RecLock('Z01', .F.)
                        Z01->Z01_PASS := cNewPass
                    Z01->(MsUnlock())
                    
                    cResultAux := '"user" : "'+Alltrim(cUser)+'",'
                    cResultAux += '"oldPass" : "'+Alltrim(cPass)+'",'
                    cResultAux += '"newPass" : "'+Alltrim(cNewPass)+'"'

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
