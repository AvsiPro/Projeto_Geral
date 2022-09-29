#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTMK02G    �Autor  �Jackson E. de Deus� Data �  26/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para alterar o status quando o status do cabecalho  ���
���          �for alterado.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTTMK02G()

Local alArea	 := GetArea()
Local cStatusSUC := M->UC_STATUS
Local nPosStat	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_STATUS"})	
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
                                       
// Se alterou no cabecalho para Encerrado - Altera no item tambem
If cStatusSUC == "3"
	For nI := 1 To Len(aCols)
		If aCols[nI][nPosStat] <> "2"
			aCols[nI][nPosStat] := "2"  
		EndIf
	Next nI
// Se alterou para Pendente
ElseIf cStatusSUC == "2"
	For nI := 1 To Len(aCols)       
		If aCols[nI][nPosStat] <> "1"
			aCols[nI][nPosStat] := "1"   
		EndIf
	Next nI
EndIf

If !lEdi1
	oGetTmk:Refresh()	// Refresh da GetDados
EndIf

RestArea(alArea)
Return cStatusSUC