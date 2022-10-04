#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WSKPC006 ºAutor  ³Jackson E. de Deus  º Data ³  04/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acessa WebService da Keeple para obter o resultado do      º±±
±±º          ³ preenchimento dos formulários nas Ordens de Serviço.       º±±
±±º          ³ Método: GetAnswerFormByListOfOrdemNumeroOS.		          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Classificação do Documento de Entrada                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WSKPC006(aDados)

/*------------------------------------------------------------------+
|	Estrutura do Array que deve ser passado como parâmetro			|
|	aDados[x]														|
|                                               					|
|	Posicao			Campo							Tipo			|
|-------------------------------------------------------------------+
|	aDados[1]		authCode						-> String		|
|	aDados[2]		clientCode						-> String		|
|	aDados[3][x]	numeroOSList					-> Array Int	|
|																	|
+------------------------------------------------------------------*/

Local oWS		:= NIL	// Objeto do WebService
Local oWSArray	:= NIL	// Objeto Array de Int
Local cMetodo	:= "GetAnswerFormByListOfOrdemNumeroOS"
Local cResult	:= ""
Local nX
Default aDados	:= {}
                            

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("Não foram informados os parâmetros necessários!","WSKPC006")
	Return     	
EndIf
           
// Verifica parametro AuthCode
If Alltrim(aDados[1]) == ""
	MsgAlert("Parâmetro AuthCode inválido! " +CRLF +"Favor preencher.","WSKPC006")
	Return
EndIf    

// Verifica parametro ClientCode
If AllTrim(aDados[2]) == ""
	MsgAlert("Parâmetro ClientCode inválido! " +CRLF +"Favor preencher.","WSKPC006")
	Return
EndIf
/*
// Verifica parametro numeroOSList 
If aDados[3][1] == 0
	MsgAlert("Parâmetro numeroOSList inválido" +CRLF +"Favor preencher.","WSKPC006")
	Return
EndIf
*/

// Instancia Classe de montagem do Array de Int - 3º parametro
oWSArray := KeepleFieldIntegration_ArrayOfInt():New()
	
For nX := 1 To Len(aDados[3])
   	AADD(oWSArray:nInt, aDados[3][nX])
Next nX
	
AADD(aDados, oWSArray)           
	

// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// Método -> GetAnswerFormByListOfOrdemNumeroOS
If oWS:GetAnswerFormByListOfOrdemServicoNumeroOS(aDados[1],aDados[2],aDados[4])
	// Sucesso
	cResult := oWs:cGetAnswerFormByListOfOrdemServicoNumeroOSResult
Else
	cResult := GetWSCError()
	// Gera Log de Erro
    If !FindFunction("U_WSKPF007")
//		MsgAlert("Função: U_WSKPF007" +CRLF +"Não encontrada no RPO." +CRLF +"O Log de erros não será gerado.","WSKPC006")    
	Else
//	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf     
EndIf


Return cResult