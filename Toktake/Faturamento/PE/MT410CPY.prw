#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410CPY  ºAutor  ³Alexandre Venancio  º Data ³  04/26/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE utilizado para validar os itens de um pedido de venda   º±±
±±º          ³que esta sendo copiado, item 124 da lista de pendencias.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION MT410CPY()

Local aArea := GetArea()
Local lRet := .T.
Local nPosPRCVEN 	:= GDFIELDPOS("C6_PRCVEN")
Local nPosPRCTOT 	:= GDFIELDPOS("C6_VALOR") 
Local nPosQTD	 	:= GDFIELDPOS("C6_QTDVEN") 
Local nPosPrd		:= GDFIELDPOS("C6_PRODUTO")
Local nPosTES 		:= GDFIELDPOS("C6_TES")
Local nPosCF 		:= GDFIELDPOS("C6_CF")          
Local nPosArm		:= GDFIELDPOS("C6_LOCAL")          
Local nPosDt		:= GDFIELDPOS("C6_ENTREG")
Local nx 			:= 0 
Local lTabIn		:= .F.    
Local lPreco		:= .F.
Local lTes			:= .F.
Local lArmazem		:= .F.   
Local lDelPrd		:= .F.

M->C5_XDTENTR 	:= dDataBase + 1


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf

    
//Validando se a tabela de preco esta ativa no sistema.
If !empty(M->C5_TABELA)
	If Posicione("DA0",1,xFilial("DA0")+M->C5_TABELA,"DA0_ATIVO") == "2" .Or. (Posicione("DA0",1,xFilial("DA0")+M->C5_TABELA,"DA0_DATATE") < dDataBase .AND. !EMPTY(Posicione("DA0",1,xFilial("DA0")+M->C5_TABELA,"DA0_DATATE")))
		MsgAlert("A Tabela de preço contida no pedido original não esta mais ativa, selecione outra","MT410CPY")
		M->C5_TABELA := space(3)
		lTabIn	:=	.T.
	EndIf
EndIf

For nx := 1 To Len(aCols)      
	//Verificando se o produto esta ativo no sistema.
	If Posicione("SB1",1,xFilial("SB1")+aCols[nx][nPosPrd],"B1_MSBLQL") == "1"
		MsgAlert("O Produto "+aCols[nx][nPosPrd]+Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[nx][nPosPrd],"B1_DESC"))+" não esta mais ativo no sistema, portanto será removido do novo pedido.","MT410CPY")
		aCols[nx][len(aHeader)+1] := .T.         
		lDelPrd	:=	.T.
	EndIf                                          
	//Validacao do preco de tabela do produto.   
	If !Empty(M->C5_TABELA)
		nValor	:=	Posicione("DA1",1,xFilial("DA1")+M->C5_TABELA+aCols[nx][nPosPrd],"DA1_PRCVEN")
		If nValor != aCols[nx][nPosPRCVEN]
			lPreco := .T.
			aCols[nx][nPosPRCVEN] := nValor   
			aCols[nx][nPosPRCTOT] := nValor * aCols[nx][nPosQTD]
		EndIF                             
	EndIf	              
	If lTabIn
		aCols[nx][nPosPRCVEN] := 0
		aCols[nx][nPosPRCTOT] := 0
	EndIf
	
	//Validacao de TES
	If Posicione("SF4",1,xFilial("SF4")+aCols[nx][nPosTES],"F4_MSBLQL") == "1"
		aCols[nx][nPosTES] := space(3)
		aCols[nx][nPosCF] := space(4)   
		lTes	:=	.T.
	Else
		//aCols[nx][nPosCF] = Posicione("SF4",1,xFilial("SF4")+aCols[nx][nPosTES],"F4_CF")
		aCols[nx][nPosTES] := Space(3)	// alterado conforme solicitacao de thiago/gustavo 20/10/2016 
	EndIf     
	
	
	//Data de entrega
	aCols[nx][nPosDt] := dDataBase+1
	//Validacao do armazem
	If Posicione("ZZ1",1,xFilial("ZZ1")+aCols[nx][nPosArm],"ZZ1_MSBLQL") == "1"
		aCols[nx][nPosArm] := space(6)
		lArmazem := .T.
	EndIf
Next nx

//Removendo do novo PV o item que esta bloqueado
If lDelPrd                
	nx := 1
	While nx <= len(aCols)
		If aCols[nx][len(aHeader)+1]
			ADEL(aCols,nx)     
			ASIZE(aCols,LEN(aCols)-1)
		Else
			nx++
		EndIf
	EndDo      
EndIf

If lPreco
	MsgAlert("O Preço do produto esta sendo alterado devido a alteração de tabela.","MT410CPY")
EndIf

If lTes
    MsgAlert("A Tes contida em um ou mais itens do novo pedido não esta mais ativa no sistema, selecione outra.","MT410CPY")
EndIf

If lArmazem
	MsgAlert("O Armazem contido no pedido original esta bloqueado para utilização, selecione outro","MT410CPY")
EndIf

//Gravando o grupo do novo usuário na copia de pedidos
M->C5_XCODUSR	:= RetCodUsr()
M->C5_XNOMUSR	:= cusername	                                                       
M->C5_XGPV		:= U_TTUSRGPV(cusername)		


RestArea(aArea)

RETURN lRet