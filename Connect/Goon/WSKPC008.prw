#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WSKPC008 ºAutor  ³Jackson E. de Deus  º Data ³  04/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acessa WebService da Keeple para obter a rota tracada pelo º±±
±±º          ³ agente.												      º±±
±±º          ³ Método: GetAgentRoute.		          					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                       									  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WSKPC008(aDados)

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
Local cMetodo	:= "GetAgentRoute"
Local cResult	:= ""
Default aDados	:= {}
                            

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("Não foram informados os parâmetros necessários!","WSKPC008")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Parâmetro AuthCode inválido! " +CRLF +"Favor preencher.","WSKPC008")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Parâmetro ClientCode inválido! " +CRLF +"Favor preencher.","WSKPC008")
	Return
EndIf


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// Método -> GetAnswerFormByListOfOrdemNumeroOS
If oWS:GetAgentRoute(aDados[1],aDados[2],aDados[3],aDados[4])
	// Sucesso
	cResult := oWs:cGetAgentRouteResult
Else
	cResult := GetWSCError()
	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Função: U_WSKPF007" +CRLF +"Não encontrada no RPO." +CRLF +"O Log de erros não será gerado.","WSKPC008")    
	Else
	    //U_WSKPF007(cMetodo,cResult,aDados)
    EndIf     
EndIf


Return cResult