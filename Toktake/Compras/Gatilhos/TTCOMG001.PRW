/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � TTCOMG001� Autor � Artur Nucci Ferrari   � Data � 14/07/10 ���
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

User Function TTCOMG001()

cProd := M->D1_COD
cRet  := cProd
dDatC := MsDate()

// AMC
If cEmpAnt == "10"
	Return cRet
EndIf

dDtFech := SuperGetMV("MV_XBLQNFE")


If dDataBase <= dDtFech
   MsgBox ("Entrada de NFE bloqueada.","Erro!!!","STOP")
   cRet := Space(15)
End
If dDataBase > dDatc
   MsgBox ("N�o � permitido incluir NF com data posterior.","Erro!!!","STOP")
   cRet := Space(15)
ElseIf dDataBase < dDatc .and. ((dDatc-dDataBase)>2)
   MsgBox ("Nao e permitido incluir NF com data retroativa.","Erro!!!","STOP")
   cRet := Space(15)
End
Return(cRet)