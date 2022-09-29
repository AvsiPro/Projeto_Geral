
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA06 บAutor  ณJackson E. de Deus   บ Data ณ  01/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVefifica existencia das tabelas e campos customizados.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ aFields[1]		- Tabela                                  บฑฑ
ฑฑบ			 ณ aFields[2][x]	- Campos								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
			ShowHelpDlg("TTTMKA06", {"Tabela: " +aFields[nI][1] + CRLF + " Nใo encontrada no cadastro de tabelas (SX2)."},5,{"Solicite a cria็ใo da tabela."},5)							
		Else
			ConOut("TTTMKA06 - Tabela: " +aFields[nI][1] +" Nใo encontrada no cadastro de tabelas (SX2). Solicite a cria็ใo da tabela.")
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
				ShowHelpDlg("TTTMKA06",{"Campo " +cCampo +"nใo existe."},5,{"O campo deve ser criado."},5)
			Else 
				ConOut("TTTMKA06 - Campo " +cCampo +"nใo existe. O campo deve ser criado.")
			EndIf
			lRet := .F.
			Return lRet
		EndIf
	Next nJ
Next nI


RestArea(aArea)

Return .T.