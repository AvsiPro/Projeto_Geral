
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097SCR     �Autor  �Jackson E. de Deus Data �  18/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE na fun��o A097Libera - Programa de Libera��o de Pedidos ��� 
���			 � de Compras, no final da montagem da tela de libera��o,	  ���
���			 � antes da apresenta��o desta.								  ���
���			 � O ponto de entrada disponibiliza como par�metro o Objeto	  ���
���			 � da dialog ' oDlg ' para manipula��o do usu�rio.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT097SCR()

Local oDlg 		:= ParamIXB[1]
Local _cTitulo	:= "Vis. CC"
Local _cCaption	:= "Vis. CC"
 
// Altera o Caption do bot�o da Libera��o de Pedidos [ Utilizado no PE U_MT097BUT() ]
oDlg:ACONTROLS[29]:CCAPTION		:= _cCaption
oDlg:ACONTROLS[29]:CTITLE		:= _cTitulo      
  




Return