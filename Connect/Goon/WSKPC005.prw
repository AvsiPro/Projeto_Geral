#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � WSKPC005 �Autor  �Jackson E. de Deus  � Data �  04/17/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple para obter o resultado do      ���
���          � preenchimento dos formul�rios nas Ordens de Servi�o.       ���
���          � M�todo: GetAnswerFormByListOfOrdemServicoExternalID.       ���
�������������������������������������������������������������������������͹��
���Uso       � Classifica��o do Documento de Entrada                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC005(aDados)

/*------------------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro			|
|	aDados[x]														|
|                                               					|
|	Posicao			Campo							Tipo			|
+-------------------------------------------------------------------+
|	aDados[1]		authCode						-> String		|
|	aDados[2]		clientCode						-> String		|
|	aDados[3][x]	externalIDList					-> Array Int	|
|																	|
+------------------------------------------------------------------*/

Local oWS		:= NIL	// Objeto do WebService
Local oWSArray	:= NIL	// Objeto Array de Int
Local cMetodo	:= "GetAnswerFormByListOfOrdemServicoExternalID"
Local cResult	:= ""
Local nX
Default aDados	:= {}

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC005")
	Return     	
EndIf
           
// Valida valores dos par�metros authCode e ClientCode

// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Par�metro AuthCode inv�lido! " +CRLF +"Favor preencher.","WSKPC005")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Par�metro ClientCode inv�lido! " +CRLF +"Favor preencher.","WSKPC005")
	Return
EndIf

// Verifica parametro externalIDList 
If aDados[3][1] == 0
	MsgAlert("Par�metro externalIDList inv�lido" +CRLF +"Favor preencher.","WSKPC005")
	Return
EndIf


// Instancia Classe de montagem do Array de Int - 3� parametro
oWSArray := KeepleFieldIntegration_ArrayOfInt():New()
	
For nX := 1 To Len(aDados[3])
   	AADD(oWSArray:nInt, aDados[3][nX])
Next nX
	
AADD(aDados, oWSArray)           


// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> GetAnswerFormByListOfOrdemServicoExternalID
If oWS:GetAnswerFormByListOfOrdemServicoExternalID(aDados[1],aDados[2],aDados[4])
		                                         
	// Sucesso
	cResult := oWs:cGetAnswerFormByListOfOrdemServicoExternalIDResult
	
Else                    

	cResult := GetWSCError()    
 // Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC005")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
	
EndIf


Return cResult