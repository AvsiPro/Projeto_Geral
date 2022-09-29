/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TTUSRGPV    ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 14/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao p/ retorno do Grupo de Pedido de Vendas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Tok Take Alimentacao                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TTOPERA(cGPV,cTpCli,cFinal,cEPP)
Local aArea	 	:= GetArea()
Local c_EOL	    := CHR(13)+CHR(10)
Local cOpera    := Space(02)
cQuery := "SELECT ZZ5_OPERA" + c_EOL
cQuery += "FROM " + RetSqlName("ZZ5") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND ZZ5_FILIAL='"+xFilial("ZZ5")+"' " + c_EOL
cQuery += "AND ZZ5_GPV='"+cGPV+"' " + c_EOL
cQuery += "AND ZZ5_TIPCLI='"+cTpCli+"' " + c_EOL
cQuery += "AND ZZ5_FINAL='"+cFinal+"' " + c_EOL
cQuery += "AND ZZ5_EPP='"+cEPP+"' " + c_EOL
MemoWrite("TTOPERA0.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
If Eof()
	cQuery := "SELECT ZZ5_OPERA" + c_EOL
	cQuery += "FROM " + RetSqlName("ZZ5") + c_EOL
	cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
	cQuery += "AND ZZ5_FILIAL='"+xFilial("ZZ5")+"' " + c_EOL
	cQuery += "AND ZZ5_GPV='"+cGPV+"' " + c_EOL
	cQuery += "AND ZZ5_TIPCLI='"+cTpCli+"' " + c_EOL
	cQuery += "AND ZZ5_FINAL='"+cFinal+"' " + c_EOL
	MemoWrite("TTOPERA1.sql",cQuery)
	If Select("TRBA") > 0
		dbSelectArea("TRBA")
		DbCloseArea()
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBA",.F.,.T.)
	dbSelectArea("TRBA")
	If Eof()
		cQuery := "SELECT ZZ5_OPERA" + c_EOL
		cQuery += "FROM " + RetSqlName("ZZ5") + c_EOL
		cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
		cQuery += "AND ZZ5_FILIAL='"+xFilial("ZZ5")+"' " + c_EOL
		cQuery += "AND ZZ5_GPV='"+cGPV+"' " + c_EOL
		cQuery += "AND ZZ5_FINAL='"+cFinal+"' " + c_EOL
		MemoWrite("TTOPERA2.sql",cQuery)
		If Select("TRBB") > 0
			dbSelectArea("TRBB")
			DbCloseArea()
		EndIf
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBB",.F.,.T.)
		dbSelectArea("TRBB")
		If Eof()
			cOpera := ""
		Else
			cOpera := TRBB->ZZ5_OPERA
		End
	Else
		cOpera := TRBA->ZZ5_OPERA
	End
Else
	cOpera := TRB->ZZ5_OPERA
End
RestArea(aArea)
Return cOpera


