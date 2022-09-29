/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � MT010INC � Autor � Artur Nucci Ferrari    � Data � 17/11/10 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controle na Inclus�o de Produtod                            ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok-Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
#include "rwmake.ch"

User Function MT010INC()

Local _cRotina  := Alltrim(FunName())
Local aArea		:= GetArea()

If SM0->M0_CODIGO=="01" .OR. SM0->M0_CODIGO == "02"
	RecLock("SB1",.F.)
	SB1->B1_MSBLQL := "1"
	MsUnLock()
	MsgBox ("Este produto somente ser� desbloqueado ap�s a revis�o dos Deptos. Fiscal/Contabilidade/F�brica.","Informa��o","INFO")
	RestArea(aArea)             
	If SM0->M0_CODIGO=="01"
		//Validacao para tornar a cubagem do produto obrigatoria
		//Item 18 da lista de pendencias - Alexandre Venancio 26/04/12   
		If SB1->B1_XCBGEM
			U_TTCOMC04()
		EndIf   
	EndIf
End

Return