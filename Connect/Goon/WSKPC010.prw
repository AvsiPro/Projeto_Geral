#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WSKPC010 ºAutor  ³Jackson E. de Deus  º Data ³  27/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acessa WebService da Keeple para obter a lista de status   º±±
±±º          ³ do agente. (usado para obter o KM)					      º±±
±±º          ³ Método: GetAgentStatusList.          					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                       									  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WSKPC010(aDados)

/*------------------------------------------------------------------+
|	Estrutura do Array que deve ser passado como parâmetro			|
|	aDados[x]														|
|                                               					|
|	Posicao			Campo							Tipo			|
|-------------------------------------------------------------------+
|	aDados[1]		authCode						-> String		|
|	aDados[2]		clientCode						-> String		|
|	aDados[3]		agenteCodigo					-> Int			|
|	aDados[4]		data							-> dateTime		|
+------------------------------------------------------------------*/

Local oWS		:= NIL	// Objeto do WebService
Local cMetodo	:= "GetAgentStatusList"
Local cResult	:= ""
Default aDados	:= {}
                            

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("Não foram informados os parâmetros necessários!","WSKPC010")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Empty(aDados[1])
	MsgAlert("Parâmetro AuthCode inválido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf    

// Verifica parametro ClientCode
If Empty(aDados[2])
	MsgAlert("Parâmetro ClientCode inválido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf

// Verifica parametro agenteCodigo
If Empty(aDados[3])
	MsgAlert("Parâmetro agenteCodigo inválido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf

// Verifica parametro data
If Empty(aDados[4])
	MsgAlert("Parâmetro data inválido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf


oWS	:= WSKeepleFieldIntegration():New()

// Método -> GetAgentStatusList
If oWS:GetAgentStatusList(aDados[1],aDados[2],aDados[3],aDados[4])
	// Sucesso
	cResult := oWs:cGetAgentStatusListResult
Else
	cResult := GetWSCError()
	Conout( "# WSKPC010 - AGENTE: " +cvaltochar(aDados[3]) +" DATA: " +aDados[4] +" -> " + cResult )
EndIf


Return cResult