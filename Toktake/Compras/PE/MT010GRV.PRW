/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT010GRV ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 31/08/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada de controle da tabela de preço            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT010GRV()
Local aArea	:= GetArea()
Local cUserLib  := Upper(AllTrim(cusername))
Local cCADVIP   := If(cEmpAnt == "01",AllTrim(SuperGetMv("MV_XCADVIP")),"")

If SM0->M0_CODIGO=='01' // .OR. SM0->M0_CODIGO=='11'

	IF cUserLib$(cCADVIP)
		If !(MsgYesNo("Confirma a liberação da Tabela de Preços ?"))
			RecLock("AIA",.F.)
			AIA->AIA_DATATE  := ddatabase-1
			MsUnLock()
		Endif
	Else
		RecLock("AIA",.F.)
		AIA->AIA_DATATE  := ddatabase-1
		MsUnLock()
		MsgInfo("Esta tabela de Preços permanecerá Inativa até que seja feita a avaliação da controladoria." ,"I N F O R M A Ç Ã O")
	End
End
RestArea(aArea)
Return Nil
