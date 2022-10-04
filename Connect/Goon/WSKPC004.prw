#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WSKPC004 ºAutor  ³Jackson E. de Deus  º Data ³  04/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acessa WebService da Keeple para                           º±±
±±º          ³ Visualizar status da Ordem de Serviço.				      º±±
±±º          ³ Método: GetAcompanhamentoOrdemServico.				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Classificação do Documento de Entrada                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WSKPC004(aDados)

/*----------------------------------------------------------+
|	Estrutura do Array que deve ser passado como parâmetro	|
|	aDados[x]												|
|                                               			|
|	Posicao		Campo							Tipo		|
|-----------------------------------------------------------|
|	aDados[1]	authCode						-> String	|
|	aDados[2]	clientCode						-> String	|
|	aDados[3]	externalOrdemServicoID			-> Int		|
|															|
+----------------------------------------------------------*/

Local oWS					// Objeto do WebService
Local cResult	:= ""		// Retorno da função
Local cMetodo	:= "GetAcompanhamentoOrdemServico"

// Verifica tamanho do Array
If Len(aDados) == 0 
	MsgAlert("Não foram informados os parâmetros necessários!","WSKPC004")
	Return    
EndIf

// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Parâmetro AuthCode inválido! " +CRLF +"Favor preencher.","WSKPC004")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Parâmetro ClientCode inválido! " +CRLF +"Favor preencher.","WSKPC004")
	Return
EndIf

// Verifica parametro externalIDList 
If aDados[3] == 0
	MsgAlert("Parâmetro externalIDList inválido" +CRLF +"Favor preencher.","WSKPC004")
	Return
EndIf


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// Método -> GetAcompanhamentoOrdemServico
If oWS:GetAcompanhamentoOrdemServico(aDados[1],aDados[2],aDados[3])
		                                         
	// Sucesso
	cResult := oWs:cGetAcompanhamentoOrdemServicoResult
	
Else

	cResult := GetWSCError()
 	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Função: U_WSKPF007" +CRLF +"Não encontrada no RPO." +CRLF +"O Log de erros não será gerado.","WSKPC004")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
    
EndIf


Return cResult