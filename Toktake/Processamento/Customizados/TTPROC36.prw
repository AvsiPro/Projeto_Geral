#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC36  ºAutor  ³Jackson E. de Deus  º Data ³  06/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conferencia nota de entrada                                º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³06/11/14³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTPROC36(cNumNf,cSerie,cFornece,cLoja,aDados)

Local cSql := ""
Local lRet := .T.
Local aProds := {}
Local nI
Local nJ
Local nQtd := 0
Local cItem := ""
Local cNumItem := ""
Local nQtdFis := 0

If cEmpAnt <> "01"
	return
EndIF

For nI := 1 To Len(aDados)
	If aDados[nI][1] == "CONFERENCIA"
		For nJ := 2 To Len(aDados[nI])
			AADD( aProds, aDados[nI][nJ] )
		Next nJ
	EndIf
Next nI

cSql := "SELECT D1_ITEM, D1_QUANT, R_E_C_N_O_ REC FROM " +RetSqlName("SD1")
cSql += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' "
cSql += " AND  D1_DOC = '"+cNumNf+"' AND D1_SERIE = '"+cSerie+"' AND D1_FORNECE = '"+cFornece+"' AND D1_LOJA = '"+cLoja+"' "
cSql += " AND D_E_L_E_T_ = '' ORDER BY D1_ITEM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	cNumItem := PaDL( Val(TRB->D1_ITEM),TamSX3("D1_ITEM")[1],"0")	// Item
	nQtdFis := TRB->D1_QUANT
	
	For nI := 1 To Len(aProds)
		For nJ := 1 To Len(aProds[nI])
			If aProds[nI][nJ][1] == "ITEM"
				cItem := aProds[nI][nJ][2]
			ElseIf aProds[nI][nJ][1] == "QTD"
				nQtd := Val(aProds[nI][nJ][2])
			EndIf
		Next nJ
		If cItem == cNumItem
			dbSelectArea("SD1")
			dbGoTo(TRB->REC)
			If RecLock("SD1",.F.)
				SD1->D1_XCLASPN := nQtd
				SD1->(MsUnLock())
			EndIf
			Exit
		EndIf	
	Next nI            
	
	dbSelectArea("TRB")		
	dbSkip()
End
dbCloseArea()

// grava no Log
If FindFunction("U_TTGENC01")
	U_TTGENC01( xFilial("SZG"),"TTWS","ORDEM DE SERVICO","",cNumNf,cSerie,"WS",dtos(date()),time(),,"Itens da nota alterados - Quantidade fisica contada",,,"SD1" )
EndIf  

Return lRet