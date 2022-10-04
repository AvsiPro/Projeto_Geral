#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC003 �Autor  �Jackson E. de Deus  � Data �  04/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple para                           ���
���          � alterar uma Ordem de Servi�o.			                  ���
���          � M�todo: SetAcompanhamentoOrdemServico	                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC003(aDados)

/*----------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro	|
|	aDados[x]												|
|                                               			|
|	Posicao		Campo							Tipo		|
|-----------------------------------------------------------|
|	aDados[1]	authCode						-> String	|
|	aDados[2]	clientCode						-> String	|
|	aDados[3]	externalOrdemServicoID			-> Int		|
|	aDados[4]	ordemrPrioridadeInsertPlace		-> Int		|	//0 - Primeiro da Lista, 1 - �ltimo da Lista, 2 - De acordo com a data de agendamento
|	aDados[5]	agenteCodigo					-> Int		|
|	aDados[6]	dataHoraAgendada				-> DateTime	|	// Data no formato	YYYY-MM-DDThh:mm:ss
|	aDados[7]	Status							-> String	|
|	aDados[8]	notificaAgente					-> Bool		|
|															|
+----------------------------------------------------------*/

Local oWS					// Objeto do WebService
Local cResult	:= ""		// Retorno da fun��o
Local cMetodo	:= "SetAcompanhamentoOrdemServico"
Default aDados	:= {}

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC003")
	Return     	
EndIf

// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> SetAcompanhamentoOrdemServico
If oWS:SetAcompanhamentoOrdemServico(aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],aDados[6],aDados[7],aDados[8])

	cResult := oWS:cSetAcompanhamentoOrdemServicoResult		                                         

Else

	cResult := GetWSCError()
 	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC003")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
    
EndIf



Return cResult