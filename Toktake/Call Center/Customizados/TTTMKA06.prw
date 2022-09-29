
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTMKA06 �Autor  �Jackson E. de Deus   � Data �  01/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Vefifica existencia das tabelas e campos customizados.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Param.    � aFields[1]		- Tabela                                  ���
���			 � aFields[2][x]	- Campos								  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTTMKA06(aFields)

Local lRet := .T.
Local aArea := GetArea()
Local cCampo := ""
Local nI
Local nJ

If cEmpAnt <> "01"
	Return(lRet)
EndIf

// Verifica as tabelas/campos informados
For nI := 1 To Len(aFields)
	//dbSelectArea(aFields[nI][1])
	SX2->(dbSetOrder(1))
	If !SX2->(dbSeek(aFields[nI][1]))
		If !IsInCallStack("U_TTTMKA08")
			ShowHelpDlg("TTTMKA06", {"Tabela: " +aFields[nI][1] + CRLF + " N�o encontrada no cadastro de tabelas (SX2)."},5,{"Solicite a cria��o da tabela."},5)							
		Else
			ConOut("TTTMKA06 - Tabela: " +aFields[nI][1] +" N�o encontrada no cadastro de tabelas (SX2). Solicite a cria��o da tabela.")
		EndIf	
		lRet := .F.
		Return lRet
	EndIf
Next nI


For nI := 1 To Len(aFields)
	If Len(aFields[nI]) < 2
		Loop
	EndIf
	dbSelectArea(aFields[nI][1])
	For nJ := 1 To Len(aFields[nI][2])	
		cCampo := aFields[nI][2][nJ]	
		If FieldPos(cCampo) == 0
			If !IsInCallStack("U_TTTMKA08")
				ShowHelpDlg("TTTMKA06",{"Campo " +cCampo +"n�o existe."},5,{"O campo deve ser criado."},5)
			Else 
				ConOut("TTTMKA06 - Campo " +cCampo +"n�o existe. O campo deve ser criado.")
			EndIf
			lRet := .F.
			Return lRet
		EndIf
	Next nJ
Next nI


RestArea(aArea)

Return .T.