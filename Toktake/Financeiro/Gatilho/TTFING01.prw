#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFING01  �Autor  �Alexandre Venancio  � Data �  01/20/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho responsavel por trazer o valor total do bordero p/ ���
���          �arquivo de CNAB receber banco Santader (santenv)            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFING01()

Local aArea		:=	GetArea()
Local cQuery 
Local cRetorno	:=	""

cQuery := "SELECT SUM(E1_VALOR) AS TOTAL FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_FILIAL='"+xFilial("SE1")+"'"
cQuery += " AND E1_NUMBOR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND D_E_L_E_T_<>'*'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

cRetorno := Strzero(val(StrTran(Transform(TRB->TOTAL,"@E 999999999.99"),",")),13)
//cvaltochar(Strzero(VAL(Transform(TRB->TOTAL,"@E 99999999999.99")),13))


RestArea(aArea)

Return(cRetorno)