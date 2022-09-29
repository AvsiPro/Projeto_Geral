/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FA080TIT ³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 18/11/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controle na Baixa de Pagamento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Tok Take                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "rwmake.ch"

User Function Fa080tit()
Local _cAlias  := Alias()
Local _nIndex  := IndexOrd()
Local _nReg    := Recno()
Local cRet := .T.
Local _nDias := 2
If Dow(date())==2
	_nDias := 3
End

If dbaixa<>ddatabase
	MsgBox ("A data do pagamento deve ser a mesma da data base do sistema. Baixa nao Realizada","Atencao!!!","ALERT")
	cRet := .F.
End


If ddebito<>ddatabase
	MsgBox ("A data do débito deve ser a mesma da data base do sistema. Baixa nao Realizada","Atencao!!!","ALERT")
	cRet := .F.
End
If SM0->M0_CODIGO=="01"
		If SE2->E2_XTIPLIB=='D'
			If SE2->E2_SALDO==SE2->E2_VALOR
				MsgBox ("Este título deve estar compensado com uma Nota de Devolução. Baixa nao Realizada","Atencao!!!","ALERT")
				cRet := .F.
			End
		ElseIf SE2->E2_XTIPLIB=='N'
			If ((SE2->E2_SALDO+SE2->E2_ACRESC)-SE2->E2_DECRESC)==SE2->E2_VALOR
				MsgBox ("Este título deve estar compensado com uma Nota de Débito (NDF). Baixa nao Realizada","Atencao!!!","ALERT")
				cRet := .F.
			End
		End

	If cRet
		If !(SE2->E2_TIPO$'RA/NCF')
			If U_TT_TEA("P",SE2->E2_FORNECE,SE2->E2_LOJA) > 0
				IF MsgBox ("Existem títulos que podem ser compensados. Deseja continuar com a baixa ?","Escolha","YESNO")
					cRet := .T.
				Else
					cRet := .F.
				End
			End
		End
	End
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna Area Inicial                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)
Return(cRet)


