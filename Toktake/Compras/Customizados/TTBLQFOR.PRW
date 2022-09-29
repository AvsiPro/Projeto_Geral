/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TTVERTI    ³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 14/07/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao p/ retorno do Grupo de Pedido de Vendas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Tok Take Alimentacao                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TTBLQFOR(cFornece,cLoja)
Local aArea	 	:= GetArea()
Local c_EOL	    := CHR(13)+CHR(10) 
Local c_Razao   := AllTrim(GetAdvFval("SA2","A2_NOME",xFilial("SA1")+cFornece+cLoja,1))
Local lReturn   := .F.

If cEmpAnt == "01"

	cQuery := "SELECT COUNT(*) AS 'NUMTIT' " + c_EOL
	cQuery += "FROM " + RetSqlName("SE2") + c_EOL
	cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
	cQuery += "AND E2_DATALIB='' " + c_EOL
	cQuery += "AND E2_USUALIB='' " + c_EOL
	cQuery += "AND E2_FORNECE='"+cFornece+"' " + c_EOL
	cQuery += "AND E2_LOJA='"+cLoja+"' " + c_EOL
	cQuery += "AND ( E2_MDCONTR = '' AND E2_TIPO <> 'PR' )"
	MemoWrite("TTBLQFOR.sql",cQuery)
	If Select("TRB") > 0
		dbSelectArea("TRB")
		DbCloseArea()
	EndIf                                                                                                                                
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")
	If TRB->NUMTIT>0
		MsgInfo("Existe(m) "+Str(TRB->NUMTIT,3,0)+" NF(s) com Bloqueio por Divergência para o Fornecedor ["+cFornece+"-"+cLoja+"/"+c_Razao+"], para que o Pedido de Compras possa ser feito, será necessário o desbloqueio." ,"I N F O R M A Ç Ã O")
		lReturn   := .F.
	Else
	    lReturn   := .T.	
	End
EndIf

RestArea(aArea)
Return lReturn



