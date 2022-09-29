#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA05     บAutor  ณJackson E. de Deus  บ Data ณ  26/06/13บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida permissao de acesso.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA05(cNumAtend)

Local lRet			:= .F.
Local aGrpAtend		:= {}
Local aGrpUsr		:= {}
Local cAssOMM		:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK002",.T.,""),"")
Local cGrpProc		:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK006",.T.,""),"")	// Grupo do Processamento
Local lGrpProc		:= .F.
Local nI
Local nJ

Default cNumAtend	:= ""

If cEmpAnt <> "01"
	lRet := .T.
	Return(lRet)
EndIf

If Empty(cNumAtend)
	Aviso("TTTMKA05","O campo n๚mero do atendimento nใo foi informado.",{"Ok"})
	Return lRet
EndIf

If AllTrim(cAssOMM) == ""
	Aviso("TTTMKA05","O parโmetro MV_XTMK002 [Assunto - OMM] nใo estแ preenchido. Verifique com o Depto de TI.",{"Ok"})
	Return lRet
EndIf

If AllTrim(cGrpProc) == ""
	Aviso("TTTMKA05","O parโmetro MV_XTMK006 [Grupo Processamento] nใo estแ preenchido. Verifique com o Depto de TI.",{"Ok"})
	Return lRet
EndIf


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณA validacao da permissao de alteracao deve acontecer somente quando o atendimento for de uma OMMณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
If dbSeek(xFilial("SUD")+AvKey(cNumAtend,"UD_CODIGO"))
	If Alltrim(SUD->UD_ASSUNTO) <> cAssOMM
		lRet := .T.
	Else
		PswOrder(1)	// ordem de pesquisa - por usuario
		If PswSeek(SUD->UD_OPERADO, .T.)
			aGrpAtend := PswRet(1)[1][10]	// grupos do responsavel do atendimento
		EndIf	
		
		If PswSeek(__cUserId, .T.)
			aGrpUsr := PswRet(1)[1][10]	// grupos do usuario atual
		EndIf
				
		//aGrpAtend := UsrRetGRP(SUD->UD_OPERADO)			// grupo do responsavel do atendimento
		//aGrpUsr := UsrRetGRP(__cUserID)					// grupo do usuario atual

		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida a atualizacao das acoes no botao customizado 'Atualizar'ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		If IsInCallStack("U_TTTMKA04")
			If cUserName $ "ADMINISTRADOR|AVENANCIO|JDEUS|FBORGES"
				lRet := .T.	
				Return lRet
			EndIf
			
			If Len(aGrpUsr) > 0 .And. Len(aGrpAtend) > 0            
				For nI := 1 To Len(aGrpAtend)
					For nJ := 1 To Len(aGrpUsr)                                   
						If aGrpUsr[nJ] == aGrpAtend[nI] .OR. aGrpUsr[nJ] == cGrpProc
							lRet := .T.
							Exit
						EndIf
					Next nJ                     
				Next nI
			Else
				If Len(aGrpUsr) == 0
					Aviso("TTTMKA05","O seu usuแrio nใo possui grupo definido. Verifique.",{"Ok"})
					lRet := .F.
					Return lRet		
				EndIf
				If Len(aGrpAtend) == 0
					Aviso("TTTMKA05","O responsแvel pela a็ใo nใo possui grupo definido. Verifique.",{"Ok"})
					lRet := .F.
					Return lRet		
				EndIf
			EndIf
		EndIf
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤญAฟ
		//ณSe foi chamada do PE do botao alterar, deve validar para que somente o grupo do Processamento possa fazer a alteracaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤญAู
		*/
		If IsInCallStack("U_TK271ABR")
			If cUserName $ "ADMINISTRADOR|AVENANCIO|JDEUS|FBORGES"
				lRet := .T.	
				Return lRet
			EndIf
			
			If Len(aGrpUsr) > 0
				For nI := 1 To Len(aGrpUsr)
					If aGrpUsr[nI] == cGrpProc
						lRet := .T.
						Exit
					EndIf
				Next nI
			Else
				Aviso("TTTMKA05","O seu usuแrio nใo possui grupo definido. Verifique.",{"Ok"})		
				lRet := .F.
				Return lRet	
			EndIf
		EndIf
		
		// Se nao validou
		If !lRet
			Aviso("TTTMKA05", "O seu grupo de usuแrio nใo possui permissใo de altera็ใo dos atendimentos de OMM.", {"Ok"})
		EndIf
	EndIf	            
EndIf

	
Return lRet