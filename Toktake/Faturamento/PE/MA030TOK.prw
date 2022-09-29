/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MA030TOK ³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 14/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controle na Inclusão/Alteração de Clientes                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Tok-Take                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "RWMAKE.CH"
User Function MA030TOK()
Local _cRotina  := Alltrim(FunName())
Local aArea		:= GetArea()
Local cUserLib  := Upper(AllTrim(SubStr(cUsuario, 7, 15)))
Local cUserSB1  := ""
Local lRevFAB := .F.
Local lRevFIS := .F.
Local lRevCTB := .F.
Local lBlqCad := .F.
Local lBlqUsr := .F.

If INCLUI                
If SM0->M0_CODIGO=="01"
//	RecLock("SA1",.F.)
	M->A1_MSBLQL := "1"
//	MsUnLock()
	MsgBox ("Este cliente somente será desbloqueado após a revisão dos Deptos. Fiscal/Contabilidade/Financeiro.","Informação","INFO")
End
End
If ALTERA
If SM0->M0_CODIGO=="01"
	cUserSB1 := AllTrim(SuperGetMv("MV_XSB1FIS"))
	lRevFIN  := M->A1_XREVFA
	lRevFIS  := M->A1_XREVFIS
	lRevCTB  := M->A1_XREVCTB
	If !(lRevFIN)
		MsgBox ("Cadastro sem revisão do Financeiro. O cliente ficará bloqueado.","Informação","INFO")
	End
	If !(lRevFIS)
		MsgBox ("Cadastro sem revisão Fiscal. O cliente ficará bloqueado.","Informação","INFO")
	End
		If !(lRevCTB)
		MsgBox ("Cadastro sem revisão Contábil. O cliente ficará bloqueado.","Informação","INFO")
	End
	If !Empty(SB1->B1_XDATBLQ)
		MsgBox ("Cadastro foi bloqueado pelo usuário.","Informação","INFO")
	End
		//VERIFICA BLOQUEIO DE CADASTRO
	If (lRevFAB .AND.lRevFIS .AND. lRevCTB)
		lBlqCad := .T.
	End
		//VERIFICA BLOQUEIO DE USUARIO
	If Empty(SB1->B1_XDATBLQ)
		lBlqUsr := .T.
	End
	If (lBlqCad .and. lBlqUsr)
		RecLock("SA1",.F.)
		M->A1_MSBLQL := "2"
		MsUnLock()
		MsgBox ("Cliente Desbloqueado.","Informação","INFO")
	Else
		RecLock("SA1",.F.)
		M->A1_MSBLQL := "1"
		MsUnLock()
		MsgBox ("Cliente Bloqueado.","Informação","INFO")
	End  
ElseIf SM0->M0_CODIGO=="02"
	//VERIFICA BLOQUEIO DE USUARIO
	If Empty(SA1->A1_XDATBLQ)
		lBlqUsr := .T.
	End
	If lBlqUsr
		RecLock("SA1",.F.)
		M->A1_MSBLQL := "2"
		MsUnLock()
		MsgBox ("Cliente Desbloqueado.","Informação","INFO")
	Else
		RecLock("SA1",.F.)
		M->A1_MSBLQL := "1"
		MsUnLock()
		MsgBox ("Cliente Bloqueado.","Informação","INFO")
	End  
End
End
RestArea(aArea)
Return .T.
