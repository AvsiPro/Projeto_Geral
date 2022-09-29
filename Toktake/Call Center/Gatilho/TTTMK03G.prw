#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTMK03G    ºAutor  ³Jackson E. de Deusº Data ³  26/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para alterar o status quando o status do item for   º±±
±±º          ³alterado.		                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTTMK03G()

Local alArea	 := GetArea()
Local cStatusSUC := M->UC_STATUS
Local nPosStat   := Ascan(aHeader,{|x|AllTrim(x[2])=="UD_STATUS"})	
Local cStatusSUD := M->UD_STATUS
Local nI 
Local nCont		 := 0 
Local lEdi1		 := .F.       

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTTMKA31"
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo
                                
// Se alterou no item para Encerrado - Altera no cabecalho tambem
If cStatusSUD == "1"
	For nI := 1 To Len(aCols)
		If aCols[nI][nPosStat] <> "1"
			aCols[nI][nPosStat] := "1"
		EndIf	
	Next nI
	M->UC_STATUS := "2"
ElseIf cStatusSUD == "2"
	For nI := 1 To Len(aCols)
		If aCols[nI][nPosStat] <> "2"
			aCols[nI][nPosStat] := "2"
		EndIf	
	Next nI
	M->UC_STATUS := "3"
EndIf	

If !lEdi1
	oGetTmk:Refresh()		// Refresh da GetDados
	Tk273FRefresh()			// Refresh do folder - nao esta funcionando
EndIf

RestArea(alArea)
Return cStatusSUD