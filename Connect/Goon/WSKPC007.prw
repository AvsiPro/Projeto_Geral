#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC007 �Autor  �Jackson E. de Deus  � Data �  04/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exclui OS gerada no Equipe Remota.					      ���
���          � M�todo: DeactivateOrdemServicoByNumeroOS.		          ���
�������������������������������������������������������������������������͹��
���Uso       � Exclus�o do Documento de Entrada		                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC007(aDados)

/*------------------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro			|
|	aDados[x]														|
|                                               					|
|	Posicao			Campo							Tipo			|
|-------------------------------------------------------------------+
|	aDados[1]		authCode						-> String		|
|	aDados[2]		clientCode						-> String		|
|	aDados[3]		numeroOS						-> Int			|
|																	|
+------------------------------------------------------------------*/

Local oWS		:= NIL	// Objeto do WebService
Local cMetodo	:= "DeactivateOrdemServicoByNumeroOS"
Local cResult	:= ""
Local nX
Default aDados	:= {}
                            

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC007")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Par�metro AuthCode inv�lido! " +CRLF +"Favor preencher.","WSKPC007")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Par�metro ClientCode inv�lido! " +CRLF +"Favor preencher.","WSKPC007")
	Return
EndIf

// Verifica parametro numeroOS
If aDados[3] == 0
	MsgAlert("Par�metro numeroOS inv�lido" +CRLF +"Favor preencher.","WSKPC007")
	Return
EndIf


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> GetAnswerFormByListOfOrdemNumeroOS
If oWS:DeactivateOrdemServicoByNumeroOS(aDados[1],aDados[2],aDados[3])
		                                         
	// Sucesso
	cResult := oWs:cDeactivateOrdemServicoByNumeroOSResult
	
Else
	
	cResult := GetWSCError()
 	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC007")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
            
EndIf


Return cResult