#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC009 �Autor  �Jackson E. de Deus  � Data �  13/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple e transfere a Ordem de Servico ���
���          � para outro agente.									      ���
���          � M�todo: SetAcompanhamentoOrdemServicoByNumeroOS.			  ���
�������������������������������������������������������������������������͹��
���Uso       �                       									  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC009(aDados)

/*------------------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro			|
|	aDados[x]														|
|                                               					|
|	Posicao			Campo							Tipo			|
|-------------------------------------------------------------------+
|	aDados[1]		authCode						-> String		|
|	aDados[2]		clientCode						-> String		|
|	aDados[3]		numeroOs						-> Int			|
|	aDados[4]		ordemPrioridadeInsertPlace		-> Int			|
|	aDados[5]		agenteCodigo					-> Int			| 
|	aDados[6]		dataHoraAgendamento				-> dateTime		| 
|	aDados[7]		status							-> String		|             
|	aDados[8]		notificaAgente					-> Boolean		|             
+------------------------------------------------------------------*/

Local oWS		:= NIL	// Objeto do WebService
Local cMetodo	:= "SetAcompanhamentoOrdemServicoByNumeroOS"
Local cResult	:= ""
Default aDados	:= {}
                            

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC009")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Par�metro AuthCode inv�lido! " +CRLF +"Favor preencher.","WSKPC009")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Par�metro ClientCode inv�lido! " +CRLF +"Favor preencher.","WSKPC009")
	Return
EndIf


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> GetAnswerFormByListOfOrdemNumeroOS
If oWS:SetAcompanhamentoOrdemServicoByNumeroOS(aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],aDados[6],aDados[7],aDados[8])
	// Sucesso
	cResult := oWs:cSetAcompanhamentoOrdemServicoByNumeroOSResult
Else
	cResult := GetWSCError()
	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC009")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf     
EndIf


Return cResult