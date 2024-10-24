#include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     �Autor  �Microsiga           � Data �  02/06/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Alimenta o campo TIPO DE COMPRA na analise da cota��o     ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AVALCOT()

Local nEvento := PARAMIXB[1]
Local aArea := GetArea()

If nEvento == 4
	
	cSc 	:= SC7->C7_NUMSC 
	cTipCot := Posicione("SC1",1,xFilial("SC1")+cSc,"C1_XTIPCOT")
	
	dbSelectArea('SC7')       	
	RecLock('SC7',.F.)    
	SC7->C7_ZTPCOM	:=	cTipCot
	SC7->(MsUnlock())      

EndIf

RestArea(aArea)

Return             
