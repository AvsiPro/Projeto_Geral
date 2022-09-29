/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT010ALT ³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 17/11/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Controle na Inclusão de Produtod                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Tok-Take                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"

User Function MT010ALT()

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
	If SM0->M0_CODIGO=="01" .OR. SM0->M0_CODIGO=="11" .OR. SM0->M0_CODIGO=="02"
		cUserSB1 := AllTrim(SuperGetMv("MV_XSB1FIS"))
		//cUserFAT := AllTrim(SuperGetMv("MV_XSB1FAT"))
		lRevFAB  := SB1->B1_XREVFAB
		lRevFIS  := SB1->B1_XREVFIS
		lRevCTB  := SB1->B1_XREVCTB
		//lRevFAT  := SB1->B1_XREVFAT

		If !(lRevFIS)
			MsgBox ("Cadastro sem revisão Fiscal. O produto ficará bloqueado.","Informação","INFO")
		End
		
		If !(lRevCTB)
			MsgBox ("Cadastro sem revisão Contábil. O produto ficará bloqueado.","Informação","INFO")
		End
		
		If !Empty(SB1->B1_XDATBLQ)
			MsgBox ("Cadastro foi bloqueado pelo usuário.","Informação","INFO")
		End
		
		//VERIFICA BLOQUEIO DE CADASTRO
		If (lRevFIS .AND. lRevCTB) // .AND. lRevFAB .AND.  lRevFAT)
			lBlqCad := .T.
		End
		
		//VERIFICA BLOQUEIO DE USUARIO
		If Empty(SB1->B1_XDATBLQ)
			lBlqUsr := .T.
		End
		
		If (lBlqCad .and. lBlqUsr)
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "2"
			MsUnLock()
			MsgBox ("Produto Desbloqueado.","Informação","INFO")
		Else
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "1"
			MsUnLock()
			MsgBox ("Produto Bloqueado.","Informação","INFO")
		End    
                 
		If SM0->M0_CODIGO=="01" .OR. SM0->M0_CODIGO=="11"
			//Validacao para tornar a cubagem do produto obrigatoria
			//Item 18 da lista de pendencias - Alexandre Venancio 26/04/12
			If SB1->B1_XCBGEM
				DbSelectArea("SB5")
				DbSetOrder(1)
				If !DbSeek(xFilial("SB5")+SB1->B1_COD) 
					MsgAlert("Não consta informação sobre cubagem para este produto, favor informa-la."+Chr(13)+Chr(10)+"Caso você não seja um usuário do depto. de Compras entre em contato para que eles possam lhe passar esta informação!","MT010ALT")
					U_TTCOMC04()
				EndIf                                                         
			EndIf
			
			//Validacao para bloqueio de produtos para novas compras
			//Item da lista de pendencias solicitado pelo Jorge do Compras - Alexandre 28/06/12
			If SB1->B1_XBLQCOM
				SB1->B1_XUSBLCO	:= Alltrim(cusername)
				SB1->B1_XDTBLCO	:= dDatabase  
			Else
				SB1->B1_XUSBLCO	:= ''
				SB1->B1_XDTBLCO	:= CTOD(" /  /   ")
			EndIf 
		EndIf
	/*	
	ElseIf SM0->M0_CODIGO=="02"
		//VERIFICA BLOQUEIO DE USUARIO
		If Empty(SB1->B1_XDATBLQ)
			lBlqUsr := .T.
		End
		If lBlqUsr
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "2"
			MsUnLock()
			MsgBox ("Produto Desbloqueado.","Informação","INFO")
		Else
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "1"
			MsUnLock()
			MsgBox ("Produto Bloqueado.","Informação","INFO")
		End
	*/	
	
	End
End
RestArea(aArea)
Return()