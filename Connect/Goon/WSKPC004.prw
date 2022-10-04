#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC004 �Autor  �Jackson E. de Deus  � Data �  04/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple para                           ���
���          � Visualizar status da Ordem de Servi�o.				      ���
���          � M�todo: GetAcompanhamentoOrdemServico.				      ���
�������������������������������������������������������������������������͹��
���Uso       � Classifica��o do Documento de Entrada                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC004(aDados)

/*----------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro	|
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
Local cResult	:= ""		// Retorno da fun��o
Local cMetodo	:= "GetAcompanhamentoOrdemServico"

// Verifica tamanho do Array
If Len(aDados) == 0 
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC004")
	Return    
EndIf

// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Par�metro AuthCode inv�lido! " +CRLF +"Favor preencher.","WSKPC004")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Par�metro ClientCode inv�lido! " +CRLF +"Favor preencher.","WSKPC004")
	Return
EndIf

// Verifica parametro externalIDList 
If aDados[3] == 0
	MsgAlert("Par�metro externalIDList inv�lido" +CRLF +"Favor preencher.","WSKPC004")
	Return
EndIf


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> GetAcompanhamentoOrdemServico
If oWS:GetAcompanhamentoOrdemServico(aDados[1],aDados[2],aDados[3])
		                                         
	// Sucesso
	cResult := oWs:cGetAcompanhamentoOrdemServicoResult
	
Else

	cResult := GetWSCError()
 	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC004")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
    
EndIf


Return cResult