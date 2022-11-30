#INCLUDE "TOTVS.CH"	
#INCLUDE "PROTHEUS.CH"
//#INCLUDE "MATA103X.CH"
/*/{Protheus.doc} MT140TOK
Localização : Function MA140Tudok() - Responsável por validar todos os itens do pré-documento  
Finalidade..: Este ponto é executado após verificar se existem itens a serem gravados e tem como objetivo validar todos os itens do pré-documento

Programa Fonte
MATA140.PRW
Sintaxe
MT140TOK - Valida todos os ítens do Pré-Documento ( [ PARAMIXB[1] ] ) --> lRet

PARAMIXB[1]			Lógico			.T. dados válidos .F. dados inválidos

@author Jonas Gouveia
@since 10/11/2015
@version 13.0

@history 24/07/2015,Jonas Gouveia,alteração na validação no preenchimento do link do Documento
@history 20/12/2017,Jonas Gouveia,incluído tela para avaliação do fornecedor 
@history 19/09/2019,Jonas Gouveia,ajuste na mensagem de integração com a API do Movidesk 
@history 04/10/2019,Jonas Gouveia,alterado a URL para comunicação via HTTPS
@history 20/11/2019,Jonas Gouveia,validação incluída para não realizar integração com o Movidesk quando estiver no ambiente de teste (EO8PBV_TESTE_P12) 
@history 24/11/2020,Jonas Gouveia,comentado a chamada de avaliação do fornecedor
@obs

Obrigar preenchimento do link do Documento
Realizar avaliação de fornecedores
Atualizar os chamados no Movidesk.
  
@type function/*/

User Function MT140TOK()

Local nPosPedi   := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_PEDIDO"})
Local nPItemPC   := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEMPC"})
Local cPedido    := aCols[n][nPosPedi]
Local cItemPC    := aCols[n][nPItemPC]
Local cXDesc	 := ""

Private lXRetorno    := .T.
If !"MATA094" $ Funname()
conout(Funname())
	//Valida rateio dos itens
	If Inclui .or. Altera
/*
//Função do Fluig para inclusão da Pre-Nota
If UPPER(Funname()) ==  "INCDOCENT"
   Return .T.
End
*/

//30/06/2020 - Selecionado a tabela SC7 no pedido de compra e Item
dbSelectArea('SC7')
dbSetOrder(1)
dbSeek(xFilial('SC7') + cPedido + cItemPC)
cXDesc  := SC7->C7_DESCRI

// Valida digitação do link do Documento
		// Se não vier da rotina automática da aparovaçao de pedido
If Type("cXTexto") <> "U"
	If Empty(cXTexto)
	   MsgStop("Favor digitar o link do Documento.")
	   lXRetorno := .F.
	   Return lXRetorno
	ElseIf UPPER("https://seu.acesso.io/shopcidadao/") $ UPPER(cXTexto)
	   lXRetorno := .T.
	Else
	   MsgStop("Favor digitar um link do Documento válido.")
	   lXRetorno := .F.
	   Return lXRetorno
	EndIf
Else
	lXRetorno := .F. 
	MsgStop("Favor digitar o link do Documento.")
	Return lXRetorno
EndIf
	Endif
Endif

Return lXRetorno
