#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"


User Function WSAPP13()
Return

WsRestFul WSAPP13 DESCRIPTION "API REST - Evento Cadastro Cliente" 
	
	WsMethod POST Description "API REST - Evento Cadastro Cliente - METODO POST "  WsSyntax "WSAPP13"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService WSAPP13

	Local cCode	     := "#200"
	Local cMessage	 := ''
    Local cResult    := ''
    Local cVend      := ''
	Local lRet	     := .T.
    Local nCont      := 0
    Local aDadCl     := {}
    Local aAI0Auto	 :=	{}
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

        DbSelectArea('SA1')
        DbSetOrder(3)

		If SA1->(Dbseek(xFilial("SA1")+oParser:cnpj))
			Reclock("SA1",.F.)
                SA1->A1_CONTATO := oParser:contact
                SA1->A1_EMAIL   := oParser:email
                SA1->A1_END     := Alltrim(oParser:address)
                SA1->A1_TEL     := fRemoveCarc(SubStr(oParser:phone,3))
                
                If !Empty(oParser:another_address)
                    SA1->A1_ENDENT := oParser:another_address
                EndIf

                If !Empty(oParser:another_district)
                    SA1->A1_BAIRROE := oParser:another_district
                EndIf

                If !Empty(oParser:another_cep)
                    SA1->A1_CEPE := fRemoveCarc(oParser:another_cep)
                EndIf
			SA1->(MsUnlock())

            cMessage := 'Cadastro de cliente atualizado com sucesso'
		Else
            DbSelectArea("CC2")
		    DbSetOrder(4)

        	If Dbseek(xFilial("CC2")+Upper(oParser:uf)+Upper(oParser:city))
				cCodeMun := CC2->CC2_CODMUN
			Else
				cCodeMun := '50308'
			EndIf
			
            ccnpjx := oParser:cnpj
			cCnpj  := SubStr(ccnpjx,1,If(len(ccnpjx)>11,8,9))
			cLoja  := SubStr(ccnpjx,If(len(ccnpjx)>11,9,10),If(len(ccnpjx)>11,4,2))
            cVend  := fVendToken(oParser:token)

			Aadd(aDadCl,{"A1_CGC"   ,   ccnpjx              		            , Nil})
			Aadd(aDadCl,{"A1_PESSOA",   If(len(ccnpjx) > 11,'J','F')            , Nil})
			Aadd(aDadCl,{"A1_TIPO"  ,   'R'                     	            , Nil})
			Aadd(aDadCl,{"A1_COD_MUN",  cCodeMun                                , Nil})
            Aadd(aDadCl,{"A1_NOME"  ,   Upper(oParser:name)  	                , Nil})
            Aadd(aDadCl,{"A1_NREDUZ",   Upper(oParser:short_name)               , Nil})
            Aadd(aDadCl,{"A1_END"   ,   Alltrim(Upper(oParser:address))         , Nil})
            Aadd(aDadCl,{"A1_CEP"   ,   fRemoveCarc(oParser:cep)		        , Nil})
            Aadd(aDadCl,{"A1_BAIRRO",   SubStr(Upper(oParser:district),1,30)    , Nil})
            Aadd(aDadCl,{"A1_EST"   ,   Upper(oParser:uf)                       , Nil})
            Aadd(aDadCl,{"A1_MUN"   ,   SubStr(Upper(oParser:city),1,60)        , Nil})
            Aadd(aDadCl,{"A1_EMAIL" ,   Upper(oParser:email)                    , Nil})
            Aadd(aDadCl,{"A1_DDD"   ,   fRemoveCarc(SubStr(oParser:phone,1,2))  , Nil})
            Aadd(aDadCl,{"A1_TEL"   ,   fRemoveCarc(SubStr(oParser:phone,3))    , Nil})
            Aadd(aDadCl,{"A1_CONTATO",  oParser:contact		          	        , Nil})
			Aadd(aDadCl,{"A1_PAIS"  ,   '105'                                   , Nil})
			Aadd(aDadCl,{"A1_CODPAIS",  '01058'                                 , Nil})
			Aadd(aDadCl,{"A1_TPESSOA",  'CI'    	                            , Nil})
			Aadd(aDadCl,{"A1_VEND"	 ,   cVend                                  , Nil})

            If !Empty(oParser:another_address)
                Aadd(aDadCl,{"A1_ENDENT" , oParser:another_address , Nil})
            EndIf

            If !Empty(oParser:another_district)
                Aadd(aDadCl,{"A1_BAIRROE" , oParser:another_district , Nil})
            EndIf

            If !Empty(oParser:another_cep)
                Aadd(aDadCl,{"A1_CEPE" , fRemoveCarc(oParser:another_cep) , Nil})
            EndIf

			aAdd(aAI0Auto,{"AI0_SALDO" ,0    ,Nil})
			aAdd(aDadCl  ,{"A1_LOJA", cLoja , Nil})
			
			lMsErroAuto := .F.
			MSExecAuto({|a,b,c| CRMA980(a,b,c)}, aDadCl, 3, aAI0Auto)
			
			If lMsErroAuto 
				DbSelectArea("SA1")
				Reclock("SA1",.T.)
                    SA1->A1_FILIAL 	:= xFilial("SA1")
                    SA1->A1_COD 	:= cCnpj
                    SA1->A1_LOJA 	:= cLoja
                    
                    For nCont := 1 to len(aDadCl)
                        &("SA1->"+aDadCl[nCont,01]) := aDadCl[nCont,02]
                    Next nCont 
				SA1->(MsUnlock())
			EndIf
			
            cMessage := 'Cliente cadastrado com sucesso'
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
    cWord := StrTran(cWord, "-", "")
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


/*/{Protheus.doc} fVendToken
   @description: Token Vendedor
   @type: Static Function
   @author: Felipe Mayer
   @since: 19/06/2023
/*/
Static Function fVendToken(cToken)

Local cRet  := ''
Local aArea := GetArea()
	
	cQuery := " SELECT * FROM "+RetSqlName('SA3')+" " + CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND UPPER(A3_TOKEN) = '"+Upper(cToken)+"' " + CRLF
	
	cAliasTMP := GetNextAlias()
	MPSysOpenQuery(cQuery, cAliasTMP)
	
	If (cAliasTMP)->(!EoF())
		cRet := (cAliasTMP)->A3_COD
	EndIf
	
	(cAliasTMP)->(DbCloseArea())

RestArea(aArea)

Return cRet
