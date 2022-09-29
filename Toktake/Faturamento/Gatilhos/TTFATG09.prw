#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATG09  �Autor  �Microsiga           � Data �  11/26/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATG09()

Local aArea	:=	GetArea()
Local lRet	:=	.T.

// Tratamento para AMC
If cEmpAnt == "10"
	Return lRet
EndIf
            
If M->C5_XFINAL == "3" .AND. SUBSTR(M->C5_LOJAENT,3,2) == CFILANT
	MsgAlert("N�o � permitido fazer uma transfer�ncia para a mesma filial, volte no cliente e altere seu c�digo, ou utilize outra finalidade","TTFATG09")
	lRet := .F.
EndIf

RestArea(aArea)

Return(lRet)