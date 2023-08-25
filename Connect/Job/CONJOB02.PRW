#INCLUDE 'PROTHEUS.CH'

User Function CONJOB02()

Local aDados    := {}
Local cResult   := ''
Local aAux   
Local cError    :=  ''
Local cWarning  :=  ''
Local oXml      :=  NIL
Local nI 

Aadd(aDados,'1AD4457221B86EDD00007A96EA7D9EBB58C1702A')
Aadd(aDados,'Q64E8XIJ6NV4F1KGU3I1')
Aadd(aDados,{3235})

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

cResult := U_WSKPC006(aDados)
FWJsonDeserialize(cResult, @aAux)
        
oXml := XmlParser( aAux:ANSWERSXML, "_", @cError, @cWarning )

If oXml <> Nil
	dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
	cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 ) 
	
	cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
	cCodCli := SubStr(cCodCli,1,Len(cCodCli)-2)
	cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )
	
	cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
	cLjCli := SubStr(cLjCli, Len(cLjCli)-1, Len(cLjCli) )

    cNumOs := oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT		
	
	// sequencias de atualizacao de status
	aSequencia := oXml:_FormAnswers:_FormAnswer:_STATUSSEQUENCE:_STATUSINFO
	For nI := 1 To Len( aSequencia ) 
		If AllTrim(aSequencia[nI]:_STATUS:TEXT) == "INIC"
			dDataIni := CtoD( SubStr( aSequencia[nI]:_DATAHORA:TEXT,1,10 ) )
   			cHoraIni := SubStr(aSequencia[nI]:_DATAHORA:TEXT,12 ) 
		EndIf
	Next nI
EndIf

RETURN
