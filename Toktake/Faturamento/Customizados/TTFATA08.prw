/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATA08() �Autor � Artur Nucci Ferrari� Data �  01/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para cadastro dos usuarios com permissao a digitar  ���
���			 � Pedidos de Vendas   .									  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#INCLUDE "rwmake.ch"
User Function TTFATA08()

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
	Private cString := "ZZ0" 
		
	dbSelectArea(cString)
	dbSetOrder(1)
		
	AxCadastro(cString,"Gerenciamento de Pedidos de Venda",cVldExc,cVldAlt)
Return
