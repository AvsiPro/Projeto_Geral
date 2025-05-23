#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � MTALCALT	� Autor � Eder Franca   � Data � 14/07/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada utilizado para altera��o da tabela SCR 
���(Documentos com al�ada) ap�s opera��o de inclus�o.                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTALCALT() 

Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
Local aAreaSC7	:= SC7->(GetArea())
Local cNum      := Alltrim(SCR->CR_NUM)

IF !cEmpAnt $ cEmpNExc 
    Return ( Nil )
endif

DbSelectArea("SC7")
SC7->(DbSetOrder(1))

If SC7->(dbseek(xfilial("SC7")+cNum))
	
	If Reclock("SCR",.F.)
		SCR->CR_OBS		:= "** PC "+cNum+" : "+SC7->C7_OBSM
		MsUnLock() 
	Endif

Endif

RestArea(aAreaSC7)

Return ( Nil )
