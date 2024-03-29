#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � PutX1TT  � Autor � RICARDO SOUZA         � Data � 26/09/11 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Validar se existe o grupo de perguntas no SX1.             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� c_Perg    => Codigo do grupo de perguntas                  ���
���          � a_Regs    => Array com as perguntas                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nil       => Nenhum                                        ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function PutX1TT(c_Perg, a_Regs)

Local a_AreaATU	:= GetArea()
Local i			:= 0
Local j			:= 0

c_Perg := c_Perg + Replicate(" ", 10 - Len(c_Perg))

DbSelectArea("SX1")
DbSetOrder(1)

For i := 1 To Len(a_Regs)
	If !SX1->(DbSeek(c_Perg+a_Regs[i,2], .F.))
		RecLock("SX1", .T.)
		For j := 1 To FCount()
			If j <= Len(a_Regs[i])
				FieldPut(j,a_Regs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next i

RestArea(a_AreaATU)

Return Nil