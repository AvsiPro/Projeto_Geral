#INCLUDE "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410LEG  �Autor  �Alexandre Venancio  � Data �  03/13/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Este ponto de entrada pertence a rotina de pedidos de venda,���
���          � MATA410(). Usado, em conjunto com o ponto MA410COR, para   ���
���          � alterar os textos da legenda, que representam o status do  ���
���          �  pedido. 												  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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