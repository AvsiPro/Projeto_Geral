#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function TTCC()

Local aArea	   := GetArea()
Local cDoc     := E5_NUMERO
Local cClifor  := E5_CLIFOR
Local cLoja    := E5_LOJA
Local cRecPag  := E5_RECPAG
Local cEmissao := ""
Local cSerie   := ""
Local cCC      := ""
Local cQry3    := ""


If  cRecPag == "R"
	cQry3 := "SELECT D2_EMISSAO,D2_DOC,D2_SERIE,D2_CONTA,CT1_DESC01 "
	cQry3 += " FROM " +RetSqlName("SD2")
	cQry3 += " 		INNER JOIN " +RetSqlName("CT1")+ " ON CT1_CONTA = D2_CONTA "
	cQry3 += " WHERE D2_CLIENTE = '"+cClifor+"' "
	cQry3 += " AND D2_LOJA = '"+cLoja+"' "
	cQry3 += " AND D2_DOC =  '"+cDoc+"' "
	cQry3 += " AND "+RetSqlName("SD2")+ ".D_E_L_E_T_ <> '*' "
	cQry3 += " AND "+RetSqlName("CT1")+ ".D_E_L_E_T_ <> '*' "
	cQry3 += " GROUP BY D2_EMISSAO,D2_DOC,D2_SERIE,D2_CONTA,CT1_DESC01 "
Else
	cQry3 := "SELECT D1_EMISSAO,D1_DOC,D1_SERIE,D1_CONTA,CT1_DESC01 "
	cQry3 += " FROM " +RetSqlName("SD1")                 
	cQry3 += " 		INNER JOIN " +RetSqlName("CT1")+ " ON CT1_CONTA = D1_CONTA "
	cQry3 += " WHERE D1_FORNECE = '"+cClifor+"' "
	cQry3 += " AND D1_LOJA = '"+cLoja+"' "
	cQry3 += " AND D1_DOC =  '"+cDoc+"' "
	cQry3 += " AND "+RetSqlName("SD1")+ ".D_E_L_E_T_ <> '*' "
	cQry3 += " AND "+RetSqlName("CT1")+ ".D_E_L_E_T_ <> '*' "
	cQry3 += " GROUP BY D1_EMISSAO,D1_DOC,D1_SERIE,D1_CONTA,CT1_DESC01 "
Endif

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cQry3 New Alias "TRB"

dbSelectArea("TRB")

While !EOF()
	
	If  cRecPag == "R"
		
		cCC      := ALLTRIM(TRB->D2_CONTA)

	Else
		cCC      := ALLTRIM(TRB->D1_CONTA)

	Endif
	
	DbSkip()
	
Enddo

RestArea(aArea)

Return(cCC)