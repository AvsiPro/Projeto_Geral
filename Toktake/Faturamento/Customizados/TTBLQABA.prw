/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TTBLQABA    ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 14/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao controle de Bloqueio de Abastecimento                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Tok Take Alimentacao                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TTBLQABA(cCodPa)
Local aArea	 	:= GetArea()
Local c_EOL	    := CHR(13)+CHR(10)
Local lRetBlq   := Space(15)
cQuery := "SELECT TOP 1 A1_XBLQABA AS BLQABA " + c_EOL
cQuery += "FROM " + RetSqlName("ZZ1") + c_EOL
cQuery += "INNER JOIN " +  RetSqlName("ZZ3") + c_EOL
cQuery += "ON ZZ1_FILIAL=ZZ3_FILIAL " + c_EOL
cQuery += "AND ZZ1_SITE=ZZ3_CODIGO " + c_EOL
cQuery += "AND " +  RetSqlName("ZZ3") +".D_E_L_E_T_=''" + c_EOL
cQuery += "INNER JOIN " +  RetSqlName("SA1") + c_EOL
cQuery += "ON A1_COD=ZZ3_CODCLI " + c_EOL
cQuery += "AND " +  RetSqlName("SA1") +".D_E_L_E_T_=''" + c_EOL
cQuery += "WHERE " +  RetSqlName("ZZ1") +".D_E_L_E_T_=''" + c_EOL
cQuery += "AND ZZ1_COD='" + cCodPA + "' " + c_EOL
cQuery += "AND ZZ1_FILIAL='" + xFilial("ZZ1") + "' " + c_EOL
cQuery += "ORDER BY A1_COD,A1_LOJA " + c_EOL
MemoWrite("TTBLQABA.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
If TRB->BLQABA=='T'
	lRetBlq := .T.
Else
	lRetBlq := .F.
End
RestArea(aArea)
Return lRetBlq
