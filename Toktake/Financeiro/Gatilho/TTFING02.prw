#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFING02  �Autor  �Alexandre Venancio  � Data �  03/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para trazer o valor total do bordero para o arquivo���
���          �do cnab a pagar (utilizacao inicial Santander)              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFING02()

Local aArea		:=	GetArea()
Local cQuery 
Local cRetorno	:=	""

cQuery := "SELECT SUM(E2_VALOR) AS TOTAL FROM "+RetSQLName("SE2")
cQuery += " WHERE E2_FILIAL='"+xFilial("SE1")+"'"
cQuery += " AND E2_NUMBOR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND D_E_L_E_T_<>'*'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

cRetorno := TRB->TOTAL //cvaltochar(Strzero(VAL(Transform(TRB->TOTAL,"@R 9999999999999")),13))


RestArea(aArea)

Return(cRetorno)