#include "RWMAKE.CH"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � MT030INC � Autor � Artur Nucci Ferrari    � Data � 14/01/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controle na Inclus�o de Clientes                            ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok-Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function M030INC()

Local _cRotina  := Alltrim(FunName())
Local aArea		:= GetArea()                                            

//Alterada a condicao para validar corretamente quando a inclusao do cliente esta sendo efetivada
//sem o paramixb esta sempre bloqueando o primeiro cliente da base indiferente de ter cancelado 
//a operacao. - Alexandre 24/01/2012
If (SM0->M0_CODIGO=="01") .AND. Paramixb != 3
	RecLock("SA1",.F.)
	SA1->A1_MSBLQL := "1"
	MsUnLock()
	MsgBox ("Este cliente somente ser� desbloqueado ap�s a revis�o dos Deptos. Fiscal/Contabilidade/Financeiro.","Informa��o","INFO")
End
RestArea(aArea)

Return