#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410VIS   ºAutor  ³Alexandre Venancio  º Data ³  03/13/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este ponto de entrada pertence à rotina de pedidos de vendaº±±
±±º          ³ MATA410(). Está localizado na rotina de visualização do    º±±
±±º          ³ pedido, executado antes de o pedido ser apresentado.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410VIS()         

Local aArea		:= GetArea()
Local aArC5		:= SC5->(GetArea())
Local aArC9		:= SC9->(GetArea())
Local nPosQLib	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_QTDLIB" })			//Posicao da Quantidade Liberada
Local nPosQVen	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_QTDVEN" })			//Posicao da Quantidade Vendida
Local nPosItem	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_ITEM" })			//Posicao do Item do Pedido


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf


dbSelectArea("SC9")
dbSetOrder(1)
	
For nI := 1 to Len(aCols)
	If SC9->(dbSeek(xFilial("SC9") + SC5->C5_NUM + aCols[nI][nPosItem]))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica todas as liberacoes, para o Pedido de ³
		//³Venda que esta sendo alterado.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !SC9->(Eof()) .AND. SC9->C9_PEDIDO == SC5->C5_NUM .AND. SC9->C9_ITEM == aCols[nI][nPosItem]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Recupera somente a quantidade, de liberacoes que³
			//³ainda nao foram Faturadas.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(SC9->C9_NFISCAL)
				aCols[nI][nPosQLib] += SC9->C9_QTDLIB
			EndIf
			SC9->(dbSkip())
		End
	EndIf
Next nI


RestArea(aArC5)
RestArea(aArC9)
RestArea(aArea)    

Return