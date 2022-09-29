#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFING03  �Autor  �Guilherme - RFB     � Data �  04/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para preencher o digito verificador corretamente no���
���          �CNAB do Santander.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CGCSANT()

Local cRetorno := " "

IF SA1->A1_PESSOA == "F"
	
	cRetorno:= "000"+SUBS(SA1->A1_CGC,1,11)
Else
	cRetorno:= SUBS(SA1->A1_CGC,1,14)
Endif

Return(cRetorno)