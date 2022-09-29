#INCLUDE "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410LEG  ºAutor  ³Alexandre Venancio  º Data ³  03/13/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este ponto de entrada pertence a rotina de pedidos de venda,º±±
±±º          ³ MATA410(). Usado, em conjunto com o ponto MA410COR, para   º±±
±±º          ³ alterar os textos da legenda, que representam o status do  º±±
±±º          ³  pedido. 												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA410LEG()

Local aCores := {}

// Tratamento para AMC
/*If cEmpAnt == "10"
	Return aCores
EndIf*/


If SC5->(FieldPos("C5_BLQ")) == 0
	aCores := {{"ENABLE","Pedido em aberto"},;     //Pedido em aberto
				{"DISABLE","Pedido encerrado"},;   //Pedido encerrado
				{"BR_AMARELO","Pedido liberado"},;
				{"BR_MARRON","Pedido liberado parcialmente"},; //Pedido parcialmente liberado
				{"BR_PINK","Pedido de Venda Parcialmente Faturado"}}      
Else
	aCores := {{"ENABLE","Pedido em aberto"},;      //Pedido em aberto
				{"DISABLE","Pedido encerrado"},;    //Pedido encerrado
				{"BR_AMARELO","Pedido liberado"},;
				{"BR_AZUL","Pedido bloqueado por regra"},;
				{"BR_LARANJA",'Pedido bloquedo por valor'},;
				{"BR_MARRON",'Pedido liberado parcialmente'},;
				{"BR_PINK ","Pedido de Venda Parcialmente Faturado"}}  //Pedido parcialmente faturado
EndIf

Return(aCores)