#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"

#Define Enter Chr(13)+Chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} PRTL002
Descricao: Serviço API Rest Evento Menus Portal por usuario

@author Alexandre Venancio
@since 21/09/2021
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
USER Function PRTL002()

Return

// Servico.
WsRestFul MenusPrt DESCRIPTION "API REST - EVENTO MENUS | PORTAL ROBSOL " 
	
	WSDATA CODIGOMENU As String 

	//WsMethod POST Description "API REST - EVENTO PRODUTOS - METODO POST "  WsSyntax "PRTL010"
	WsMethod GET Description "Retorna o Menu do usuario" WSSYNTAX "/MenusPrt/{CODIGOMENU}" 

End WsRestFul

//-------------------------------------------------------------------
/*/{Protheus.doc} Metodo Post | Evento Implantacao 
Descricao: 	Servico Rest contendo o Metodo POST do evento de 
				Portal Robsol

@author Alexandre Venancio
@since 21/09/2021
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
WsMethod GET WsReceive CODIGOMENU WsService MenusPrt

	Local cCode 	:= Self:CODIGOMENU
	Local aArea		:= GetArea()
	Local cJson		:= ''
	Local cVirg		:= ""
	Local cCodBkp	:= ""
	
	lRet					:= .T.
	
	conout("chegou aqui PRTL002")
	
	::SetContentType("application/json")
	
	RpcSetType(3)
	RPCSetEnv("01","0101")
	
	DbSelectArea("AI8")
	DbsetOrder(1)
	If Dbseek(xFilial("AI8")+cCode)
		
		cJson += '['
		
		
		While !EOF() .and. AI8->AI8_PORTAL == cCode

			If Empty(cCodBkp) .OR. (cCodBkp <> AI8->AI8_CODMNU .And. Empty(AI8->AI8_CODPAI))

				If Empty(AI8->AI8_CODPAI) .And. !Empty(cCodBkp)
					cJson += ']'
					cJson += '},'
				EndIf

				cCodBkp := AI8->AI8_CODMNU

				
				cJson += '{'
				cJson += '"label":"'+Alltrim(AI8->AI8_TEXTO)+'",'
				cJson += '"icon":"",'
				cJson += '"shortLabel":"'+Alltrim(AI8->AI8_TEXTO)+'",'
				cJson += '"subItems": ['

				cVirg := ''
				
			Else
				cJson += cVirg + '{"label":"'+Alltrim(AI8->AI8_TEXTO)+'",'
				cJson += '"link":"'+Alltrim(AI8->AI8_XWSROB)+'",'
				cJson += '"id":"'+cvaltochar(Recno())+'"}'
				cVirg := ','
			EndIf

			Dbskip()
		EndDo

		
		cJson += ']'
		cJson += '}'
		cJson += ']'
		
		
	else
		cJson += '{ "codigo":"#400",'
		cJson += '"Erro": "Portal nao encontrado",}'
		
	EndIf
	
	::SetResponse(cJson)

RestArea(aArea)
	
Return lRet

