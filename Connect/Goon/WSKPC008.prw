#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC008 �Autor  �Jackson E. de Deus  � Data �  04/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple para obter a rota tracada pelo ���
���          � agente.												      ���
���          � M�todo: GetAgentRoute.		          					  ���
�������������������������������������������������������������������������͹��
���Uso       �                       									  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC008(aDados)

/*------------------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro			|
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
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC008")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Par�metro AuthCode inv�lido! " +CRLF +"Favor preencher.","WSKPC008")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Par�metro ClientCode inv�lido! " +CRLF +"Favor preencher.","WSKPC008")
	Return
EndIf


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> GetAnswerFormByListOfOrdemNumeroOS
If oWS:GetAgentRoute(aDados[1],aDados[2],aDados[3],aDados[4])
	// Sucesso
	cResult := oWs:cGetAgentRouteResult
Else
	cResult := GetWSCError()
	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC008")    
	Else
	    //U_WSKPF007(cMetodo,cResult,aDados)
    EndIf     
EndIf


Return cResult