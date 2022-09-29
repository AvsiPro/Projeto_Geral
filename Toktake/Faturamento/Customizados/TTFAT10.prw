#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFAT10   �Autor  �Alexandre Venancio  � Data �  09/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do campo TES para que nao seja utilizada uma TES ���
���          �que nao gere financeiro onde a finalidade de venda nao seja @ �
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFAT10()

Local aArea	:=	GetArea()
Local lRet	:=	.T.    
Local cTsF	:=	If(cEmpAnt=="01",GetMv("MV_XTSFTCT"),"")
            
If cEmpAnt <> "01"
	Return lRet
EndIf

If M->C5_XFINAL != "@" .And. M->C6_TES $ Alltrim(cTsF)
	MsgAlert("Esta TES somente pode ser utilizada para pedidos de venda onde a finalidade seja igual a @","TTFAT10")
	lRet := .F.
EndIf

RestArea(aArea) 

Return(lRet)