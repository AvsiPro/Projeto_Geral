#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTECG01  ºAutor  ³Jackson E. de Deus  º Data ³  09/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho - preenchimento dados do funcionario               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTTECG01()

Local aArea := GetArea()
Local cNome := ""
Local cEmp	:= ""
Local aEmp := {"01","03","04","05","06","07","08","11","12","13"}
Local nX 

	
If !FindFunction("U_TTTECC03")
	Return cNome
EndIf

U_TTTECC03(M->AA1_CODTEC)

dbSelectArea("TRBSRA")

M->AA1_NOMTEC := ""
M->AA1_FUNCAO := ""
M->AA1_TURNO := ""
M->AA1_XEMPRE := ""

If !EOF()
	cNome := TRBSRA->RA_NOME
	M->AA1_NOMTEC := TRBSRA->RA_NOME
	M->AA1_FUNCAO := TRBSRA->RA_CODFUNC
	M->AA1_TURNO := TRBSRA->RA_TNOTRAB
	 
	For nX := 1 To Len(aEmp)
		If aEmp[nX] == cEmpAnt
			Loop
		EndIf
		cSql := "SELECT RA_MAT FROM SRA" +aEmp[nX] + "0" + " WHERE D_E_L_E_T_ = '' AND RA_DEMISSA = '' AND RA_MAT = '"+M->AA1_CODTEC+"' "
		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf		           
		TcQuery cSql New Alias "TRB"
		dbSelectArea("TRB")
		If !Empty(TRB->RA_MAT)
			cEmp := aEmp[nX]
			Exit
		EndIf
	Next nX
	                     
	M->AA1_XEMPRE := cEmp
	
EndIf

RestArea(aArea)		

Return cNome