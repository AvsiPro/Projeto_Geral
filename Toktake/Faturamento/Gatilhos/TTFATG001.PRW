/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � TTFATG001� Autor � Artur Nucci Ferrari   � Data � 14/07/10 ���
�������������������������������������������������������������������������Ĵ��
���Classe    � Gatilho                                                    ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Abre tela de digitacao de dados para historico, natureza a ���
���          � serem gravadas no finaceiro e motivo da devolucao.         ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Gomes da Costa                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#include "rwmake.ch"   

User Function TTFATG001()
cCliente := M->C5_CLIENTE
cRet  := cCliente
dDatC := MsDate()

If cEmpAnt <> "01"
	Return
EndIf

dDtBloqPV := SuperGetMV("MV_XBLQPED")
If dDatC <= dDtFech
   MsgBox ("Entrada de Pedidos de Venda bloqueada.","Erro!!!","STOP")
   cRet := Space(6)
End     
If Empty(U_TTUSRGPV("")) 
   MsgBox ("Usu�rio sem Grupo de Venda. Inclus�o/Altera��o de Pedido de Venda n�o permitida.","Erro!!!","STOP")
   cRet := Space(6)
End
Return(cRet)  




