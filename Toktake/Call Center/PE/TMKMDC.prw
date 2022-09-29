#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKMDC    ºAutor  ³Jackson E. de Deus  º Data ³  10/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado apos o cancelamento do atendimento.            º±±
±±º          ³Utilizado para restaurar o status dos patrimônios em OMMs.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKMDC()

Local cNumTmk	:= SUC->UC_CODIGO
Local aArea		:= GetArea()                 
Local cAssOMM	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK002",.T.,""),"")	// assunto OMM
Local cOcorrIns	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK003",.T.,""),"")	// ocorrencia de instalacao
Local cOcorrRem	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK004",.T.,""),"")	// ocorrencia de remocao
Local nRecno	:= 0

If cEmpAnt <> "01"
	Return
EndIf

dbSelectArea("SUD")
dbSetOrder(1)
If dbSeek(xFilial("SUD")+cNumTmk) 
	While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
		// A validacao deve ser somente para atendimentos de OMM, outros atendimentos podem ser cancelados
		If SUD->UD_ASSUNTO <> cAssOMM 
			dbSkip()
		EndIf
		
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³	No caso de um atendimento de OMM - Instalacao                                      ³
		//³	Ajusta o status do patrimonio no Ativo Fixo - volta para status "Disponivel"       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrIns
			If AllTrim(SUD->UD_XNPATRI) <> ""
				dbSelectArea("SN1")
				dbSetOrder(2)	// filial + plaqueta
				nRecno := U_TTTMKA19(SUD->UD_XNPATRI)
				If nRecno > 0
					SN1->( dbGoTo(nRecno) )
					If AllTrim(SN1->N1_XSTATTT) $ "2|5" // esta empenhado/transito?
						If RecLock("SN1",.F.)
							SN1->N1_XSTATTT := "1"	// disponivel
							SN1->(MsUnlock())
						EndIf
					EndIf   
				EndIf
			EndIf
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
		//³No caso de um atendimento de OMM - Remocao                                  ³
		//³Ajusta o status do patrimonio no Ativo Fixo - volta para status "Em Cliente"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
		*/
		ElseIf SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrRem
			If AllTrim(SUD->UD_XNPATRI) <> ""
				dbSelectArea("SN1")
				dbSetOrder(2)	// filial + plaqueta
				nRecno := U_TTTMKA19(SUD->UD_XNPATRI)
				If nRecno > 0
					SN1->( dbGoTo(nRecno) )
					If AllTrim(SN1->N1_XSTATTT) == "6" // esta em remocao?
						If RecLock("SN1",.F.)
							SN1->N1_XSTATTT := "3"	// em cliente
							SN1->(MsUnlock())
						EndIf
					EndIf   
				EndIf
			EndIf
		EndIf              
		SUD->(dbSkip())
	End While
EndIf
	
RestArea(aArea)

Return