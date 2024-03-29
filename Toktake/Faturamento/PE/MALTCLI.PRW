#include "rwmake.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � MALTCLI  � Autor � Artur Nucci Ferrari    � Data � 14/01/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controle na Altera��o de Clientes                           ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok-Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
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
				MsgBox ("Cadastro sem revis�o do Financeiro. O cliente ficar� bloqueado.","Informa��o","INFO")
			End
			
			If !(lRevFIS)
				MsgBox ("Cadastro sem revis�o Fiscal. O cliente ficar� bloqueado.","Informa��o","INFO")
			End
			
			If !(lRevCTB)
				MsgBox ("Cadastro sem revis�o Cont�bil. O cliente ficar� bloqueado.","Informa��o","INFO")
			End
			
			//If !Empty(SB1->B1_XDATBLQ)
			//	MsgBox ("Cadastro foi bloqueado pelo usu�rio.","Informa��o","INFO")
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
				MsgBox ("Cliente Desbloqueado.","Informa��o","INFO")
			Else
				RecLock("SA1",.F.)
				SA1->A1_MSBLQL := "1"
				MsUnLock()
				MsgBox ("Cliente Bloqueado.","Informa��o","INFO")
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
			MsgBox ("Cliente Desbloqueado.","Informa��o","INFO")
		Else
			RecLock("SA1",.F.)
			SA1->A1_MSBLQL := "1"
			MsUnLock()
			MsgBox ("Cliente Bloqueado.","Informa��o","INFO")
		End
		
	End
End
RestArea(aArea)

Return