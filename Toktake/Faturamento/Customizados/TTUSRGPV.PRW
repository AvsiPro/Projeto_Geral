/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � TTUSRGPV    � Autor � Artur Nucci Ferrari   � Data � 14/07/10 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao p/ retorno do Grupo de Pedido de Vendas                 ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Tok Take Alimentacao                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function TTUSRGPV(cUser)
Local aArea	 	:= GetArea()
Local c_EOL	     := CHR(13)+CHR(10)
Local cRetGPV   := Space(15)
If Empty(cUser)
	cUser := Upper(AllTrim(cusername))
End
cQuery := "SELECT ZZ0_XGPV AS GPV" + c_EOL
cQuery += "FROM " + RetSqlName("ZZ0") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND ZZ0_XUSER='" + cUser + "' " + c_EOL
MemoWrite("TTUSRGPV.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
cRetGPV := TRB->GPV
RestArea(aArea)
Return cRetGPV
                                         