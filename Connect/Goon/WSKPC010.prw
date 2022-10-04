#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC010 �Autor  �Jackson E. de Deus  � Data �  27/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple para obter a lista de status   ���
���          � do agente. (usado para obter o KM)					      ���
���          � M�todo: GetAgentStatusList.          					  ���
�������������������������������������������������������������������������͹��
���Uso       �                       									  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC010(aDados)

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
Local cMetodo	:= "GetAgentStatusList"
Local cResult	:= ""
Default aDados	:= {}
                            

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC010")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Empty(aDados[1])
	MsgAlert("Par�metro AuthCode inv�lido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf    

// Verifica parametro ClientCode
If Empty(aDados[2])
	MsgAlert("Par�metro ClientCode inv�lido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf

// Verifica parametro agenteCodigo
If Empty(aDados[3])
	MsgAlert("Par�metro agenteCodigo inv�lido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf

// Verifica parametro data
If Empty(aDados[4])
	MsgAlert("Par�metro data inv�lido! " +CRLF +"Favor preencher.","WSKPC010")
	Return
EndIf


oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> GetAgentStatusList
If oWS:GetAgentStatusList(aDados[1],aDados[2],aDados[3],aDados[4])
	// Sucesso
	cResult := oWs:cGetAgentStatusListResult
Else
	cResult := GetWSCError()
	Conout( "# WSKPC010 - AGENTE: " +cvaltochar(aDados[3]) +" DATA: " +aDados[4] +" -> " + cResult )
EndIf


Return cResult