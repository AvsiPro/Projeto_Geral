
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKBARLA  �Autor  �Marcio Domingos     � Data �  01/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada do m�dulo Televendas para criar bot�o para���
���          � consulta de estoques de todas as filiais / armaz�ns        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMKBARLA()
Local _aButton := {}

If cEmpAnt == "01"
	Aadd( _aButton, { "S4WB011N", { || U_TTTMKA02()}, OemToAnsi( "Consulta estoques" ) } )
	Aadd( _aButton, { "S4WB016N", { || U_TTTMKA10()}, OemToAnsi( "Patrimonios no cliente" ) } )
	Aadd( _aButton, { "S4WB018N", { || U_TTTMKA11()}, OemToAnsi( "Imprimir OP" ) } )
	Aadd( _aButton, { "S4WB016N", { || U_TTATFR01()}, OemToAnsi( "Consulta patrimonios" ) } )
EndIF

Return( _aButton )   