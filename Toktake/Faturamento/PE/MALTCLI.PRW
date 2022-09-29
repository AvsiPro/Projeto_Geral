#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MALTCLI  ³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 14/01/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controle na Alteração de Clientes                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Tok-Take                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function MALTCLI()


Local aArea		:= GetArea()
Local _cRotina  := Alltrim(FunName())
Local cUserLib  := Upper(AllTrim(cusername))
Local cUserFre  := ""	//Upper(AllTrim(SuperGetMv("MV_XUSRMST")))
Local cUserSB1  := ""
Local lRevFAB := .F.
Local lRevFIS := .F.
Local lRevCTB := .F.
Local lBlqCad := .F.
Local lBlqUsr := .F.


// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf

cUserFre  := Upper(AllTrim(SuperGetMv("MV_XUSRMST")))

If !(cUserLib$cUserFre)
	If SM0->M0_CODIGO=="01" .OR. SM0->M0_CODIGO=="11"
		If AllTrim(SubStr(SA1->A1_CGC,1,8))<>'00777022'
			cUserSB1 := AllTrim(SuperGetMv("MV_XSB1FIS"))
			lRevFIN  := SA1->A1_XREVFA
			lRevFIS  := SA1->A1_XREVFIS
			lRevCTB  := SA1->A1_XREVCTB
			If !(lRevFIN)
				MsgBox ("Cadastro sem revisão do Financeiro. O cliente ficará bloqueado.","Informação","INFO")
			End
			
			If !(lRevFIS)
				MsgBox ("Cadastro sem revisão Fiscal. O cliente ficará bloqueado.","Informação","INFO")
			End
			
			If !(lRevCTB)
				MsgBox ("Cadastro sem revisão Contábil. O cliente ficará bloqueado.","Informação","INFO")
			End
			
			//If !Empty(SB1->B1_XDATBLQ)
			//	MsgBox ("Cadastro foi bloqueado pelo usuário.","Informação","INFO")
			//End
			//VERIFICA BLOQUEIO DE CADASTRO
			If (lRevFIN .AND.lRevFIS .AND. lRevCTB)
				lBlqCad := .T.
			End
			
			//VERIFICA BLOQUEIO DE USUARIO
			//If Empty(SB1->B1_XDATBLQ)
			//	lBlqUsr := .T.
			//End
			
			If lBlqCad
				RecLock("SA1",.F.)
				SA1->A1_MSBLQL := "2"
				MsUnLock()
				MsgBox ("Cliente Desbloqueado.","Informação","INFO")
			Else
				RecLock("SA1",.F.)
				SA1->A1_MSBLQL := "1"
				MsUnLock()
				MsgBox ("Cliente Bloqueado.","Informação","INFO")
			End
		End
	ElseIf SM0->M0_CODIGO=="02"
		//VERIFICA BLOQUEIO DE USUARIO
		If Empty(SA1->A1_XDATBLQ)
			lBlqUsr := .T.
		End
		If lBlqUsr
			RecLock("SA1",.F.)
			SA1->A1_MSBLQL := "2"
			MsUnLock()
			MsgBox ("Cliente Desbloqueado.","Informação","INFO")
		Else
			RecLock("SA1",.F.)
			SA1->A1_MSBLQL := "1"
			MsUnLock()
			MsgBox ("Cliente Bloqueado.","Informação","INFO")
		End
		
	End
End
RestArea(aArea)

Return