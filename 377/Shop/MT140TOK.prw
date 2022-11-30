#INCLUDE "TOTVS.CH"	
#INCLUDE "PROTHEUS.CH"
//#INCLUDE "MATA103X.CH"
/*/{Protheus.doc} MT140TOK
Localiza��o : Function MA140Tudok() - Respons�vel por validar todos os itens do pr�-documento  
Finalidade..: Este ponto � executado ap�s verificar se existem itens a serem gravados e tem como objetivo validar todos os itens do pr�-documento

Programa Fonte
MATA140.PRW
Sintaxe
MT140TOK - Valida todos os �tens do Pr�-Documento ( [ PARAMIXB[1] ] ) --> lRet

PARAMIXB[1]			L�gico			.T. dados v�lidos .F. dados inv�lidos

@author Jonas Gouveia
@since 10/11/2015
@version 13.0

@history 24/07/2015,Jonas Gouveia,altera��o na valida��o no preenchimento do link do Documento
@history 20/12/2017,Jonas Gouveia,inclu�do tela para avalia��o do fornecedor 
@history 19/09/2019,Jonas Gouveia,ajuste na mensagem de integra��o com a API do Movidesk 
@history 04/10/2019,Jonas Gouveia,alterado a URL para comunica��o via HTTPS
@history 20/11/2019,Jonas Gouveia,valida��o inclu�da para n�o realizar integra��o com o Movidesk quando estiver no ambiente de teste (EO8PBV_TESTE_P12) 
@history 24/11/2020,Jonas Gouveia,comentado a chamada de avalia��o do fornecedor
@obs

Obrigar preenchimento do link do Documento
Realizar avalia��o de fornecedores
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
//Fun��o do Fluig para inclus�o da Pre-Nota
If UPPER(Funname()) ==  "INCDOCENT"
   Return .T.
End
*/

//30/06/2020 - Selecionado a tabela SC7 no pedido de compra e Item
dbSelectArea('SC7')
dbSetOrder(1)
dbSeek(xFilial('SC7') + cPedido + cItemPC)
cXDesc  := SC7->C7_DESCRI

// Valida digita��o do link do Documento
		// Se n�o vier da rotina autom�tica da aparova�ao de pedido
If Type("cXTexto") <> "U"
	If Empty(cXTexto)
	   MsgStop("Favor digitar o link do Documento.")
	   lXRetorno := .F.
	   Return lXRetorno
	ElseIf UPPER("https://seu.acesso.io/shopcidadao/") $ UPPER(cXTexto)
	   lXRetorno := .T.
	Else
	   MsgStop("Favor digitar um link do Documento v�lido.")
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
