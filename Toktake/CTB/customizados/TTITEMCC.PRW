/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TTITEMCC    ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 08/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao p/ retorno do Item Contábil a partir da PA              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Tok Take Alimentacao                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TTITEMCC(cCodPA)
Local aArea	  := GetArea()
Local c_EOL	  := CHR(13)+CHR(10)
Local cItemCC := ""
cQuery := "SELECT " + c_EOL
cQuery += "A1_COD+A1_LOJA+ZZ3_CODIGO+ZZ1_COD AS ITEM " + c_EOL
cQuery += ",ZZ1_DESCRI AS PA " + c_EOL
cQuery += ",CTD_ITEM AS CTD " + c_EOL
cQuery += "FROM " + RetSqlName("ZZ1") + c_EOL
cQuery += "INNER JOIN " + RetSqlName("ZZ3") + c_EOL
cQuery += "ON ZZ3_FILIAL=ZZ1_FILIAL " + c_EOL
cQuery += "AND ZZ3_CODIGO=ZZ1_SITE " + c_EOL
cQuery += "AND " + RetSqlName("ZZ3") +".D_E_L_E_T_='' " + c_EOL
cQuery += "INNER JOIN " + RetSqlName("SA1") + c_EOL
cQuery += "ON A1_COD=ZZ3_CODCLI " + c_EOL
cQuery += "AND A1_LOJA=ZZ3_LOJA " + c_EOL
cQuery += "AND " + RetSqlName("SA1") +".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("CTD") + c_EOL
cQuery += "ON CTD_ITEM=A1_COD+A1_LOJA+ZZ3_CODIGO+ZZ1_COD " + c_EOL
cQuery += "AND " + RetSqlName("CTD") +".D_E_L_E_T_='' " + c_EOL
cQuery += "WHERE " + RetSqlName("ZZ1") +".D_E_L_E_T_='' " + c_EOL
cQuery += "AND ZZ1_FILIAL='"+xFilial("ZZ1")+"' " + c_EOL
cQuery += "AND ZZ1_COD='"+cCodPA+"' " + c_EOL
MemoWrite("TTITEMCC.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
If !Eof()
	cItemCC :=  TRB->ITEM
	If Empty(TRB->CTD)
		RecLock("CTD",.T.)
		CTD->CTD_FILIAL := xFilial("CTD")
		CTD->CTD_ITEM   := TRB->ITEM
		CTD->CTD_CLASSE := "2"
		CTD->CTD_DESC01 := TRB->PA
		MsUnLock()
	End
End
RestArea(aArea)
Return cItemCC
