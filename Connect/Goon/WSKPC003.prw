#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WSKPC003 ºAutor  ³Jackson E. de Deus  º Data ³  04/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acessa WebService da Keeple para                           º±±
±±º          ³ alterar uma Ordem de Serviço.			                  º±±
±±º          ³ Método: SetAcompanhamentoOrdemServico	                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WSKPC003(aDados)

/*----------------------------------------------------------+
|	Estrutura do Array que deve ser passado como parâmetro	|
|	aDados[x]												|
|                                               			|
|	Posicao		Campo							Tipo		|
|-----------------------------------------------------------|
|	aDados[1]	authCode						-> String	|
|	aDados[2]	clientCode						-> String	|
|	aDados[3]	externalOrdemServicoID			-> Int		|
|	aDados[4]	ordemrPrioridadeInsertPlace		-> Int		|	//0 - Primeiro da Lista, 1 - Último da Lista, 2 - De acordo com a data de agendamento
|	aDados[5]	agenteCodigo					-> Int		|
|	aDados[6]	dataHoraAgendada				-> DateTime	|	// Data no formato	YYYY-MM-DDThh:mm:ss
|	aDados[7]	Status							-> String	|
|	aDados[8]	notificaAgente					-> Bool		|
|															|
+----------------------------------------------------------*/

Local oWS					// Objeto do WebService
Local cResult	:= ""		// Retorno da função
Local cMetodo	:= "SetAcompanhamentoOrdemServico"
Default aDados	:= {}

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("Não foram informados os parâmetros necessários!","WSKPC003")
	Return     	
EndIf

// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// Método -> SetAcompanhamentoOrdemServico
If oWS:SetAcompanhamentoOrdemServico(aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],aDados[6],aDados[7],aDados[8])

	cResult := oWS:cSetAcompanhamentoOrdemServicoResult		                                         

Else

	cResult := GetWSCError()
 	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Função: U_WSKPF007" +CRLF +"Não encontrada no RPO." +CRLF +"O Log de erros não será gerado.","WSKPC003")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
    
EndIf



Return cResult