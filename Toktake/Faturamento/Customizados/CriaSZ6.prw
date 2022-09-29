
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaSZ6    �Autor  �Jackson E. de Deus � Data �  07/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria o saldo inicial do produto no armazem - SZ6           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CriaSZ6(cLocal,cProduto)

Local aArea := GetArea()

If cEmpAnt == "10"
	Return
EndIf

dbSelectArea("ZZ1")
dbSetOrder(1)
If !MsSeek( xFilial("ZZ1") +AvKey(cLocal,"ZZ1_COD") )
	RestArea(aArea)
	Return
EndIf     

dbSelectArea("SB1")
dbSetOrder(1)
If !MsSeek( xFilial("SB1") +AvKey(cProduto,"B1_COD") )
	RestArea(aArea)
	Return
EndIf

dbSelectArea("SZ6")
dbSetOrder(1)	// filial local produto
If !MSSeek( xFilial("SZ6") +AvKey(cLocal,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
	RecLock("SZ6",.T.)
	SZ6->Z6_FILIAL	:= xFilial("SZ6")
	SZ6->Z6_LOCAL	:= cLocal
	SZ6->Z6_COD		:= cProduto
	SZ6->Z6_QATU	:= 0
	MsUnLock()
EndIf

RestArea(aArea)

Return