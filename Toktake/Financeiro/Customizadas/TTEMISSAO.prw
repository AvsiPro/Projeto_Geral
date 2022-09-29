#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function TTEMISSAO()

Local aArea	   := GetArea()
Local cDoc     := E5_NUMERO
Local cClifor  := E5_CLIFOR
Local cLoja    := E5_LOJA
Local cRecPag  := E5_RECPAG
Local cEmissao := ""
Local cSerie   := ""
Local cCC      := ""
Local cQry2    := ""

If  cRecPag == "R"
	cQry2 := "SELECT F2_EMISSAO,F2_DOC,F2_SERIE "
	cQry2 += " FROM "+RetSqlName("SF2")
	cQry2 += " WHERE F2_CLIENTE = '"+cClifor+"' "
	cQry2 += " AND F2_LOJA = '"+cLoja+"' "
	cQry2 += " AND F2_DOC =  '"+cDoc+"' "
	cQry2 += " AND D_E_L_E_T_ <> '*' "
Else
	cQry2 := "SELECT F1_EMISSAO,F1_DOC,F1_SERIE "
	cQry2 += " FROM " +RetSqlName("SF1")
	cQry2 += " WHERE F1_FORNECE = '"+cClifor+"' "
	cQry2 += " AND F1_LOJA = '"+cLoja+"' "
	cQry2 += " AND F1_DOC =  '"+cDoc+"' "
	cQry2 += " AND D_E_L_E_T_ <> '*' "
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cQry2 New Alias "TRB"

dbSelectArea("TRB")

While !EOF()
	
	If  cRecPag == "R"
		cEmissao   := STOD(TRB->F2_EMISSAO)
	Else
		cEmissao   := STOD(TRB->F1_EMISSAO)
	Endif
	
	DbSkip()
	
Enddo

RestArea(aArea)

Return(cEmissao)