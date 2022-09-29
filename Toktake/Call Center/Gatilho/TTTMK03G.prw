#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTMK03G    �Autor  �Jackson E. de Deus� Data �  26/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para alterar o status quando o status do item for   ���
���          �alterado.		                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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