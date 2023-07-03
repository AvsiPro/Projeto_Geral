#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"


User Function WSAPP15()
Return

WsRestFul WSAPP15 DESCRIPTION "API REST - Evento SendWarrantyImage" 
	
	WsMethod POST Description "API REST - Evento SendWarrantyImage - METODO POST "  WsSyntax "WSAPP15"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService WSAPP15

	Local cCode	     := "#200"
	Local cMessage	 := ''
    Local cResult    := ''
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
        
        cImage    := oParser:image
        cName     := fRemoveCarc(oParser:image_name)
        cWarranty := "chamado_"+oParser:warranty+"\"
        
        cImage 	 := SubStr(cImage, At(";base64,", cImage) + Len(';base64,'))

        If !ExistDir("\updchamados\"+cWarranty)
            MakeDir("\updchamados\"+cWarranty)
        EndIf

        oFWriter := FWFileWriter():New("\updchamados\"+cWarranty+cName, .T.)

        If oFWriter:Create()
            oFWriter:Write(Decode64(cImage))
            oFWriter:Close()
        EndIf

        cMessage := "Upload de imagens realizado com sucesso"
	EndIf

    cResult := '{'
    cResult += '"status" : {'
    cResult += '"code" : "'+cCode+'",'
    cResult += '"message" : "'+cMessage+'"'
    cResult += '}'
    cResult += '}'

    ::SetContentType('application/json')
    ::SetResponse(cResult)

	RpcClearEnv()

Return lRet


Static Function fRemoveCarc(cWord)

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
    cWord := Alltrim(cWord)
Return cWord
