#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"


User Function WSAPP10()
Return

WsRestFul WSAPP10 DESCRIPTION "API REST - Evento SendWarranty" 
	
	WsMethod POST Description "API REST - Evento SendWarranty - METODO POST "  WsSyntax "WSAPP10"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService WSAPP10

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
        
        cKeyZ50 := xFilial('Z50');
			+AvKey(oParser:invoice,'Z50_NOTA');
			+AvKey(oParser:customer,'Z50_CODCLI');
			+AvKey(oParser:customer_branch,'Z50_LOJCLI');
			+AvKey(oParser:emission,'Z50_EMISSA');
			+AvKey(oParser:product,'Z50_PROD')

        cWarranty := GetSXEnum("Z50","Z50_CODIGO")
        
        If !Z50->(DbSeek(cKeyZ50))
			RecLock('Z50', .T.)
				Z50->Z50_CODIGO := cWarranty
				Z50->Z50_NOTA 	:= oParser:invoice
				Z50->Z50_ITEM 	:= oParser:item
				Z50->Z50_PROD 	:= oParser:product
				Z50->Z50_CODCLI := oParser:customer
				Z50->Z50_LOJCLI := oParser:customer_branch
				Z50->Z50_EMISSA := SToD(oParser:emission)
				Z50->Z50_PRECO  := oParser:price
				Z50->Z50_QUANT  := oParser:quantity
				Z50->Z50_OPCTRC := oParser:option
				Z50->Z50_OBS	:= fRemoveCarc(oParser:obs)
				Z50->Z50_DTCRIA := Date()
				Z50->Z50_HRCRIA := Time()
				Z50->Z50_STATUS := '1'
				Z50->Z50_DEFEIT := oParser:defect
				Z50->Z50_TPDEFE := oParser:defect_type
				Z50->Z50_OUTEND := fRemoveCarc(oParser:another_address)
				Z50->Z50_FILPED := oParser:branch_invoice
				ConfirmSx8()
			Z50->(MsUnlock())

            cPatch := '\updchamados\chamado_'+Alltrim(cWarranty)

            If !ExistDir(cPatch)
                Makedir(cPatch)
            EndIf
            
            nHandle := FCREATE(cPatch+'\notification.txt')

			If nHandle = -1
				conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
			Else
				FWrite(nHandle, 'visualizou')
				FClose(nHandle)
			EndIf

            cMessage := 'Chamado criado com sucesso: '+cWarranty
        Else
            RollbackSx8()
			cMessage := 'chamado ja criado para esse produto e nota'+Z50->Z50_CODIGO
            cCode := '#400'
		EndIf
	
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
    cWord := FwNoAccent(cWord)
    cWord := FwCutOff(cWord)
    cWord := strtran(cWord,"ã","a")
    cWord := strtran(cWord,"º"," ")
    cWord := strtran(cWord,"%"," ")
    cWord := strtran(cWord,"*"," ")     
    cWord := strtran(cWord,"&"," ")
    cWord := strtran(cWord,"$"," ")
    cWord := strtran(cWord,"#"," ")
    cWord := strtran(cWord,"§"," ") 
    cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,","," ")
    cWord := strtran(cWord,"."," ")
    cWord := StrTran(cWord, "'", " ")
    cWord := StrTran(cWord, "#", " ")
    cWord := StrTran(cWord, "%", " ")
    cWord := StrTran(cWord, "*", " ")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, "!", " ")
    cWord := StrTran(cWord, "@", " ")
    cWord := StrTran(cWord, "$", " ")
    cWord := StrTran(cWord, "(", " ")
    cWord := StrTran(cWord, ")", " ")
    cWord := StrTran(cWord, "_", " ")
    cWord := StrTran(cWord, "+", " ")
    cWord := StrTran(cWord, "{", " ")
    cWord := StrTran(cWord, "}", " ")
    cWord := StrTran(cWord, "[", " ")
    cWord := StrTran(cWord, "]", " ")
    cWord := StrTran(cWord, ".", " ")
    cWord := StrTran(cWord, "|", " ")
    cWord := StrTran(cWord, ";", " ")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := strtran(cWord,""+'"'+""," ")
    cWord := RTrim(cWord)
Return cWord
