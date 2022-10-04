#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WSKPC001  ºAutor  ³Alexandre Venancio º Data ³  08/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acessa WebService da Keeple para                           º±±
±±º          ³ Incluir ou atualizar cadastro de cliente.                  º±±
±±º			 ³ Método: SaveOrUpdateCliente								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WSKPC001(aDados)

/*----------------------------------------------------------+
|	Estrutura do Array que deve ser passado como parâmetro	|
|	aDados[x]												|
|                                               			|
|	Posicao		Campo							Tipo		|
|-----------------------------------------------------------|
|	aDados[1]	authCode						-> String	|
|	aDados[2]	clientCode						-> String	|
|	aDados[3]	externalID						-> Int		|
|	aDados[4]	matricula						-> String	|
|	aDados[5]	nome							-> String	|
|	aDados[6]	fisicaJuridica					-> String	|
|	aDados[7]	cPFCNPJ							-> String	|
|	aDados[8]	classificacao					-> String	|
|	aDados[9]	endereco						-> String	|
|	aDados[10]	enderecoNumero					-> String	|
|	aDados[11]	enderecoComplemento				-> String	|
|	aDados[12]	enderecoBairro					-> String	|
|	aDados[13]	cidade							-> String	|
|	aDados[14]	uF								-> String	|
|	aDados[15]	cEP								-> String	|
|	aDados[16]	telefoneResidencial				-> String	|
|	aDados[17]	telefoneComercial				-> String	|
|	aDados[18]	telefoneCelular					-> String	|
|	aDados[19]	email							-> String	|
|	aDados[20]	observacao						-> String	|
|	aDados[21]	contatoNome						-> String	|
|	aDados[22]	clienteAtivo					-> bool		|
|	aDados[23]	atendidoEmTodosTiposServicos	-> bool		|
|															|
+----------------------------------------------------------*/

Local oWS					
Local cResult	:= ""
Local cMetodo	:= "SaveOrUpdateCliente"
Default aDados	:= {}
          
// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("Não foram informados os parâmetros necessários!","WSKPC001")
	Return
EndIf

// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// Método -> SaveOrUpdateCliente
If oWS:SaveOrUpdateCliente(aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],aDados[6],aDados[7],aDados[8],aDados[9],aDados[10],aDados[11],aDados[12],aDados[13],aDados[14],aDados[15],aDados[16],aDados[17],aDados[18],aDados[19],aDados[20],aDados[21],aDados[22],aDados[23])
	cResult := oWs:cSaveOrUpdateClienteResult                                         
Else
	cResult := GetWSCError()    
    // Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Função: U_WSKPF007" +CRLF +"Não encontrada no RPO." +CRLF +"O Log de erros não será gerado.","WSKPC001")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
EndIf

If "false" $ cResult
	U_WSKPF007(cMetodo,cResult,aDados)
EndIf
  
Return cResult