/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � M020INC � Autor � Artur Nucci Ferrari    � Data � 14/01/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controle na Inclus�o de Fornecedores                        ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok-Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
#include "rwmake.ch"

User Function M020INC()

Local _cRotina  := Alltrim(FunName())
Local aArea		:= GetArea()

If SM0->M0_CODIGO=="01"
	RecLock("SA2",.F.)
	SA2->A2_MSBLQL := "1"
	MsUnLock()
	MsgBox ("Este fornecedor somente ser� desbloqueado ap�s a revis�o dos Deptos. Fiscal/Contabilidade/Financeiro.","Informa��o","INFO")
	RestArea(aArea)
EndIf


Return()