/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � TTVERTI    � Autor � Artur Nucci Ferrari    � Data � 14/07/10 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao p/ retorno do Grupo de Pedido de Vendas                 ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Tok Take Alimentacao                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function TTVERTI(cGPV,cFinal)
Local aArea	 	:= GetArea()
Local c_EOL	    := CHR(13)+CHR(10)
Local lReturn   := .F.
cQuery := "SELECT ZZ5_OPERA" + c_EOL
cQuery += "FROM " + RetSqlName("ZZ5") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND ZZ5_FILIAL='"+xFilial("ZZ5")+"' " + c_EOL
cQuery += "AND ZZ5_GPV='"+cGPV+"' " + c_EOL
cQuery += "AND ZZ5_FINAL='"+cFinal+"' " + c_EOL
MemoWrite("TTVERTI.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
If Eof()
lReturn   := .F.
Else
lReturn   := .T.
End
RestArea(aArea)
Return lReturn



