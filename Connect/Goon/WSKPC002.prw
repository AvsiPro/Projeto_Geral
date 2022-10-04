#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WSKPC002  �Autor  �Alexandre Venancio  � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Acessa WebService da Keeple para                           ���
���          � Abrir nova Ordem de Servi�o.				                  ���
���			 � M�todo: OpenOrdemServico									  ���
�������������������������������������������������������������������������͹��
���Uso       � Inclus�o de Documento de Entrada                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function WSKPC002(aDados)

/*----------------------------------------------------------+
|	Estrutura do Array que deve ser passado como par�metro	|
|	aDados[x]												|
|                                               			|
|	Posicao		Campo							Tipo		|
|-----------------------------------------------------------|
|	aDados[1]	authCode						-> String	|
|	aDados[2]	clientCode						-> String	|
|	aDados[3]	externalID						-> Int		|
|	aDados[4]	externalClienteID				-> Int		|
|	aDados[5]	externalTipoServicoID			-> Int		|
|	aDados[6]	externalAtendenteID				-> Int		|
|	aDados[7]	dataSolicitacao					-> DateTime	|	// Data no formato	YYYY-MM-DDThh:mm:ss
|	aDados[8]	prioridade						-> String	|
|	aDados[9]	contatoNome						-> String	|
|	aDados[10]	contatoTelefone					-> String	|
|	aDados[11]	endereco						-> String	|
|	aDados[12]	enderecoNumero					-> String	|
|	aDados[13]	enderecoComplemento				-> String	|
|	aDados[14]	enderecoBairro					-> String	|
|	aDados[15]	cidade							-> String	|
|	aDados[16]	uF								-> String	|
|	aDados[17]	cEP								-> String	|
|	aDados[18]	descricao						-> String	|
|	aDados[19]	latitude						-> double	|
|	aDados[20]	longitude						-> double	|
|	aDados[21]	dataCriacao						-> DateTime	|	// Data no formato	YYYY-MM-DDThh:mm:ss
|	aDados[22]	enderecoReferencia				-> String	|
|	aDados[23]	numeroOS						-> Int		|
|	aDados[24]	dynFormCreateFormXML			-> String	|
|	aDados[25]	agenteCodigo					-> Int		|
|	aDados[26]	dataHoraAgendamento				-> DateTime	|	// Data no formato	YYYY-MM-DDThh:mm:ss
|															|
+----------------------------------------------------------*/

Local oWS								// Objeto do WebService
Local cMetodo	:= "OpenOrdemServico"	// Nome do metodo, vai ser passado para a funcao geradora de log de erro
Local cResult	:= ""					// Retorno da fun��o

Default aDados	:= {}

// Verifica tamanho do Array
If Len(aDados) == 0
	MsgAlert("N�o foram informados os par�metros necess�rios!","WSKPC002")
	Return
EndIf

// Instancia a Classe (Client WebService gerado no DevStudio)
oWS	:= WSKeepleFieldIntegration():New()

// M�todo -> OpenOrdemServico
If oWS:OpenOrdemServico(aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],aDados[6],aDados[7],aDados[8],aDados[9],aDados[10],aDados[11],aDados[12],aDados[13],aDados[14],aDados[15],aDados[16],aDados[17],aDados[18],aDados[19],aDados[20],aDados[21],aDados[22],aDados[23],aDados[24],aDados[25],aDados[26])
	cResult := oWs:cOpenOrdemServicoResult
Else
	cResult := GetWSCError() 
 // Gera Log de Erro
    If !FindFunction("U_WSKPF007")
		MsgAlert("Fun��o: U_WSKPF007" +CRLF +"N�o encontrada no RPO." +CRLF +"O Log de erros n�o ser� gerado.","WSKPC002")    
	Else
	    U_WSKPF007(cMetodo,cResult,aDados)
    EndIf
	    	
EndIf

If "false" $ cResult
	U_WSKPF007(cMetodo,cResult,aDados)
EndIf

Return cResult