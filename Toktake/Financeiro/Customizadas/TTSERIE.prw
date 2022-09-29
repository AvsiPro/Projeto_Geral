#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function TTSERIE()

Local aArea	   := GetArea()
Local cDoc     := E5_NUMERO
Local cClifor  := E5_CLIFOR
Local cLoja    := E5_LOJA
Local cRecPag  := E5_RECPAG
Local cEmissao := ""
Local cSerie   := ""
Local cCC      := ""
Local cQry1    := ""


If  cRecPag == "R"
	cQry1 := "SELECT F2_EMISSAO,F2_DOC,F2_SERIE "
	cQry1 += " FROM "+RetSqlName("SF2")
	cQry1 += " WHERE F2_CLIENTE = '"+cClifor+"' "
	cQry1 += " AND F2_LOJA = '"+cLoja+"' "
	cQry1 += " AND F2_DOC =  '"+cDoc+"' "
	cQry1 += " AND D_E_L_E_T_ <> '*' "
Else
	cQry1 := "SELECT F1_EMISSAO,F1_DOC,F1_SERIE "
	cQry1 += " FROM " +RetSqlName("SF1")
	cQry1 += " WHERE F1_FORNECE = '"+cClifor+"' "
	cQry1 += " AND F1_LOJA = '"+cLoja+"' "
	cQry1 += " AND F1_DOC =  '"+cDoc+"' "
	cQry1 += " AND D_E_L_E_T_ <> '*' "
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cQry1 New Alias "TRB"

dbSelectArea("TRB")

While !EOF()
	
	If  cRecPag == "R"
		cSerie   := TRB->F2_SERIE
	Else
		cSerie   := TRB->F1_SERIE
	Endif
	
	DbSkip()
	
Enddo

RestArea(aArea)  

Return(cSerie)