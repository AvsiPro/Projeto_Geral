/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � MA030TOK � Autor � Artur Nucci Ferrari    � Data � 14/01/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controle na Inclus�o/Altera��o de Clientes                  ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok-Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
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
	MsgBox ("Este cliente somente ser� desbloqueado ap�s a revis�o dos Deptos. Fiscal/Contabilidade/Financeiro.","Informa��o","INFO")
End
End
If ALTERA
If SM0->M0_CODIGO=="01"
	cUserSB1 := AllTrim(SuperGetMv("MV_XSB1FIS"))
	lRevFIN  := M->A1_XREVFA
	lRevFIS  := M->A1_XREVFIS
	lRevCTB  := M->A1_XREVCTB
	If !(lRevFIN)
		MsgBox ("Cadastro sem revis�o do Financeiro. O cliente ficar� bloqueado.","Informa��o","INFO")
	End
	If !(lRevFIS)
		MsgBox ("Cadastro sem revis�o Fiscal. O cliente ficar� bloqueado.","Informa��o","INFO")
	End
		If !(lRevCTB)
		MsgBox ("Cadastro sem revis�o Cont�bil. O cliente ficar� bloqueado.","Informa��o","INFO")
	End
	If !Empty(SB1->B1_XDATBLQ)
		MsgBox ("Cadastro foi bloqueado pelo usu�rio.","Informa��o","INFO")
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
		MsgBox ("Cliente Desbloqueado.","Informa��o","INFO")
	Else
		RecLock("SA1",.F.)
		M->A1_MSBLQL := "1"
		MsUnLock()
		MsgBox ("Cliente Bloqueado.","Informa��o","INFO")
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
		MsgBox ("Cliente Desbloqueado.","Informa��o","INFO")
	Else
		RecLock("SA1",.F.)
		M->A1_MSBLQL := "1"
		MsUnLock()
		MsgBox ("Cliente Bloqueado.","Informa��o","INFO")
	End  
End
End
RestArea(aArea)
Return .T.
