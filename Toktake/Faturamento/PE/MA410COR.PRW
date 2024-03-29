/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410COR  �Autor  �Alexandre Venancio  � Data �  13/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada pertence � rotina de pedidos de venda���
���Desc.     �MATA410(). Usado, em conjunto com o ponto MA410LEG, para    ���
���Desc.     � alterar cores do �browse� do cadastro, que representam o   ���
���Desc.     � status� do pedido. 										  ���
���          � liberados ou faturados parcialmente.                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Copel                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410COR()

Local aArea		:= GetArea()
Local aCores	:= {}

// Tratamento para AMC
/*If cEmpAnt == "10"
	Return aCores
EndIf */


//�������������������������������������������������������ͻ
//� Status    � C5_LIBEROK � C5_NOTA � C5_BLQ � C9_PEDIDO �
//�������������������������������������������������������͹
//� Aberto    �   Vazio    �  Vazio  � Vazio  �   Vazio   �
//� Encerrado �    'E'     �Nao Vazio� Vazio  � Nao Vazio �
//� Liberado  � Nao Vazio  �  Vazio  � Vazio  � --------- �
//� Blq. Regra� ---------- � ------- �  '1'   � --------- �
//� Blq. Verba� ---------- � ------- �  '2'   � --------- �
//� Parc. Lib.�   Vazio    �  Vazio  � Vazio  �   Vazio   �
//�������������������������������������������������������ͼ

If SC5->(FieldPos("C5_BLQ")) == 0
	aCores := {	{"Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .AND. Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_PEDIDO'))",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA) .Or. C5_LIBEROK == 'E'",'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA)",'BR_AMARELO'},;	//Pedido Liberado
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !Empty(Posicione('SC6',1,SC6->C6_FILIAL + SC6->C6_NUM,'C6_OP'))",'BR_MARROM'},;
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. !Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_PEDIDO'))","BR_PINK" }}	//Pedido Parcialmente Liberado
Else
	aCores := {{"Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_NFISCAL'))",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA) .Or. C5_LIBEROK == 'E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ)",'BR_AMARELO'},;
				{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
				{ "C5_BLQ == '2'",'BR_LARANJA'},;	//Pedido Bloquedo por verba  
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !Empty(Posicione('SC6',1,SC6->C6_FILIAL + SC6->C6_NUM,'C6_OP'))",'BR_MARRON'},;
				{ "Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. !Empty(Posicione('SC9',1,SC5->C5_FILIAL + SC5->C5_NUM,'C9_NFISCAL'))","BR_PINK" }}	//Pedido Parcialmente Liberado - JM 20/03/07

Endif

RestArea(aArea)

Return aCores