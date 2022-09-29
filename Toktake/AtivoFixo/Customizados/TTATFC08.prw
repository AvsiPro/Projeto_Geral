#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTATFC08  �Autor  �Microsiga           � Data �  10/25/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Alterar o Status TT de um Patrimonio de Manutencao para   ���
���          �disponivel                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTATFC08(cPatr)

Local aArea	:=	Getarea()
Local aPergs	:= 	{} 
Local aRet		:= 	{} 

DbSelectArea("SN1")
DbSetOrder(2)
If DbSeek(xFilial("SN1")+Avkey(cPatr,"N1_CHAPA"))	
	If SN1->N1_XSTATTT = "4" 
		Reclock("SN1",.F.)
		SN1->N1_XSTATTT := '1'
		SN1->(Msunlock())
	Else
		MsgAlert("Patrim�nio n�o consta como Em Manuten��o","TTATFC08")
	EndIf
EndIf

RestArea(aArea)

Return