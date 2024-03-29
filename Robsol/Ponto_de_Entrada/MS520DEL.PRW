#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MS520DEL  �Autor  �Alexandre Venancio  � Data �  29/10/21   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE executado antes da exclus�o do registro da tabela SF2.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento - Exclus�o de Doc de Sa�da                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MS520DEL()

Local aArea := GetArea()

DbSelectArea("Z40")
DbSetOrder(4)
If DBSeek(xFilial("Z40")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

    While !EOF() .And. Z40->Z40_NOTA == SF2->F2_DOC .AND. Z40->Z40_SERIE == SF2->F2_SERIE .AND. Z40->Z40_CLIENT == SF2->F2_CLIENTE .AND. Z40->Z40_LOJA == SF2->F2_LOJA
        RecLock("Z40", .F.)
        DbDelete()
        Z40->(MsUnlock())
        Dbskip()
    EndDo

EndIf

RestArea(aArea)

Return
