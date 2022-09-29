/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TTREGNEG    ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 06/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao p/ retorno do Grupo de Pedido de Vendas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Tok Take Alimentacao                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TTREGNEG(cGrpVen,cTipRet)
Local aArea	 	:= GetArea()
Local c_EOL	    := CHR(13)+CHR(10)
cQuery := "SELECT ACS_CODREG,ACT_CODTAB,DA1_MOEDA " + c_EOL
cQuery += "FROM " + RetSqlName("ACS") + c_EOL
cQuery += "INNER JOIN " + RetSqlName("ACT") + c_EOL
cQuery += "ON ACT_FILIAL=ACS_FILIAL" + c_EOL
cQuery += "AND ACT_CODREG=ACS_CODREG" + c_EOL
cQuery += "AND  " + RetSqlName("ACT") +".D_E_L_E_T_='' " + c_EOL
cQuery += "INNER JOIN  " + RetSqlName("DA1") + c_EOL
cQuery += "ON DA1_CODTAB=ACT_CODTAB" + c_EOL
cQuery += "AND DA1_ITEM='0001'" + c_EOL
cQuery += "AND " + RetSqlName("DA1") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "WHERE  " + RetSqlName("ACS") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "AND ACS_GRPVEN='" + cGrpVen + "'
MemoWrite("C:\TTREGNEG.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")                                                                 
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
If cTipRet=="T"
	cRet := TRB->ACT_CODTAB
ElseIf cTipRet=="M"
	cRet := TRB->DA1_MOEDA
End
RestArea(aArea)    
Return cRet
