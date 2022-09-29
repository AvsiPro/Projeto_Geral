#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCNTA17  �Autor  �Jackson E. de Deus  � Data �  16/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o valor total em loca��es por contrato/planilha     ���
���          �Considera apenas m�quinas instaladas.                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTCNTA17(cContrato, cPlanilha)

Local cQuery := ""
Local nTotal := 0

If cEmpAnt == "01"
	             
	cQuery := "SELECT SUM(ZQ_VALOR) TOTAL FROM " +RetSqlName("SZQ") + " SZQ "
	cQuery += "WHERE "
	cQuery += "ZQ_CONTRA = '"+cContrato+"' "
	cQuery += "AND ZQ_PLAN = '"+cPlanilha+"' "
	cQuery += "AND ZQ_DATAREM = '' "
	cQuery += "AND D_E_L_E_T_ = '' "
	
	
	If Select("TSZQ") > 0
		TSZQ->(dbCloseArea())
	EndIf                    
	
	TcQuery cQuery New Alias "TSZQ"
	
	dbSelectArea("TSZQ")
	
	nTotal := TSZQ->TOTAL
	
	TSZQ->( dbCloseArea() )
EndIF

Return nTotal