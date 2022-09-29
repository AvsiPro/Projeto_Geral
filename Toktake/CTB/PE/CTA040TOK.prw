#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTA040TOK �Autor  �Alexandre Venancio  � Data �  04/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE utilizado para nao permitir nomes de itens contabeis    ���
���          �duplicados.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTA040TOK()

Local lRet := .F.   
Local cQuery   

cQuery := "SELECT CTD_ITEM,CTD_DESC01 FROM "+RetSQLName("CTD")
cQuery += " WHERE D_E_L_E_T_='' AND CTD_ITEM<>'"+M->CTD_ITEM+"' AND CTD_DESC01='"+M->CTD_DESC01+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("CTA040TOK.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	MsgAlert("Esta descri��o j� esta sendo utilizada no item Contabil "+TRB->CTD_ITEM+" - "+TRB->CTD_DESC01,"CTA040TOK")
	lRet	:= .T.
	DbSkip()
EndDo


Return(lRet)