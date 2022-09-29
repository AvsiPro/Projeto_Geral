#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC25  �Autor  �Microsiga           � Data �  10/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do campo ZF_LACRE para nao permitir reutilizar   ���
���          �um lacre ou utilizar um que esteja na black list.           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFINC25()

Local aArea	:=	Getarea()
Local lRet	:=	.T.
Local cQuery

cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("ZZO")
cQuery += " WHERE ZZO_FILIAL='"+xFilial("ZZO")+"' AND ZZO_LACRE='"+M->ZF_LACRE+"'"
cQuery += " AND D_E_L_E_T_=''"
cQuery += " AND (ZZO_DATUTI<>'' OR ZZO_BLACKL<>'')"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

IF TRB->QTD > 0
	MsgAlert("Este lacre j� foi utilizado em outro patrim�nio ou esta na Lista Negra.","TTFINC25")
	lRet	:=	.F.
Endif
    

RestArea(aArea)                         	

Return(lRet)