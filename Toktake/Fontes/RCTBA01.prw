#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RCTBA01   �Autor  �  Cadubitski        � Data �  08/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao utilizada no X3_VLDUSER do campo CTD_ITEM para      ���
���          � validar parte do codigo.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RCTBA01()

Local aArea 	:= GetArea()
Local aAreaSA1 	:= SA1->(GetArea())
Local lRet		:= .t.   
Local cCliente	:= SubStr(Alltrim(M->CTD_ITEM),1,6)
Local cLoja		:= SubStr(Alltrim(M->CTD_ITEM),7,4)

If cEmpAnt <> "01"
	Return lRet
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+cCliente+cLoja)
	lRet := .t.
Else
	Aviso("Verifica��o","As 10 primeiras posi��oes n�o correspondem a um codigo e loja de cliente valido. Favor verificar.",{"Ok"},,"Aten��o:")
	lRet := .f.
EndIf


RestArea(aAreaSA1)
RestArea(aArea)

Return(lRet)