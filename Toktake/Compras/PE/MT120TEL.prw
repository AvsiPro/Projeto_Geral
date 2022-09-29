#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120TEL  บAutor  ณAlexandre Venancio  บ Data ณ  03/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPe utilizado para validar itens de um PC copiado, com relacaoฑฑ
ฑฑบ          ณaos dados atuais contidos no pedido.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120TEL()

Local aArea		:=	GetArea()
Local nPosPrd	:=	Ascan(aHeader,{|x| x[2] = "C7_PRODUTO"})
Local nPosTab	:=	Ascan(aHeader,{|x| x[2] = "C7_CODTAB"})
Local nPosPrc	:=	Ascan(aHeader,{|x| x[2] = "C7_PRECO"})
Local nPosTot	:=	Ascan(aHeader,{|x| x[2] = "C7_TOTAL"})
Local nPosDat	:=	Ascan(aHeader,{|x| x[2] = "C7_DATPRF"})
Local nPosQtd	:=	Ascan(aHeader,{|x| x[2] = "C7_QUANT"})
Local cForn		:=	If(cEmpAnt == "01",Posicione("SA2",2,xFilial("SA2")+aCols[1,Ascan(aHeader,{|x| x[2] = "C7_XFORNEC"})],"A2_COD"),"")
Local cLoja		:=	If(cEmpAnt == "01",Posicione("SA2",2,xFilial("SA2")+aCols[1,Ascan(aHeader,{|x| x[2] = "C7_XFORNEC"})],"A2_LOJA"),"")
Local nX		:=	0	

If cEmpAnt == "01"
	If Paramixb[4] == 6
		For nX := 1 to len(aCols)
			//Validando se o produto nao se encontra bloqueado
			If Posicione("SB1",1,xFilial("SB1")+aCols[nX,nPosPrd],"B1_MSBLQL") == "1"
				MsgAlert("O Produto "+aCols[nX,nPosPrd]+" encontra-se bloqueado para utiliza็ใo","MT120TEL")
				aCols[nX,len(aHeader)+1] := .T.
			EndIf 
			//Validando a tabela de preco
			If Posicione("AIA",1,xFilial("AIA")+cForn+cLoja+aCols[nX,nPosTab],"AIA_DATATE") < dDataBase
				MsgAlert("A Tabela de Pre็o "+aCols[nX,nPosTab]+" se encontra fora da data de vig๊ncia, selecione outra tabela para a c๓pia do pedido.","MT120TEL")
				//Outra Tabela
			EndIf
			//Validando o preco
			If Posicione("AIB",2,xFilial("AIB")+cForn+cLoja+aCols[nX,nPosTab]+aCols[nX,nPosPrd],"AIB_PRCCOM") != aCols[nX,nPosPrc]
				MsgAlert("O pre็o do produto "+aCols[nX,nPosPrd]+" esta sendo alterado de acordo com o novo pre็o contido na tabela "+aCols[nX,nPosTab],"MT120TEL")
				aCols[nX,nPosPrc] := Posicione("AIB",2,xFilial("AIB")+cForn+cLoja+aCols[nX,nPosTab]+aCols[nX,nPosPrd],"AIB_PRCCOM")
				aCols[nX,nPosTot] := aCols[nX,nPosPrc] * aCols[nX,nPosQtd]
			EndIf     
			//Validando data de entrega
			If aCols[nX,nPosDat] < dDataBase
				aCols[nX,nPosDat] := dDataBase
			EndIf
		Next nX
	
	EndIf 
EndIf     

RestArea(aArea)

Return