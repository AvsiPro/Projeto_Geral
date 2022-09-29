#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC40 ºAutor  ³Jackson E. de Deus   º Data ³  06/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna os itens contados e divergentes                    º±±
±±º          ³ Controle de Entregas										  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson	       ³06/04/15³01.00 |Criacao                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTPROC40(cNumNf,cSerie,cCliente,cLoja,aDados) 

Local aArea := GetArea()
Local axItens := {}
Local cSql := ""
Local cNumItem := ""
Local nQtdFis := 0
Local cCod := ""
Local cDesc := ""
Local nDifer := 0
Local nValor := 0
Local nY

If cEmpAnt <> "01"
	return
EndIF

cSql := "SELECT D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, F2.R_E_C_N_O_ REC FROM " +RetSqlName("SF2") +" F2"
cSql += " INNER JOIN " +RetSqlName("SD2") +" D2 ON "
cSql += " F2.F2_FILIAL = D2.D2_FILIAL "
cSql += " AND F2.F2_DOC = D2.D2_DOC "
cSql += " AND F2.F2_SERIE = D2.D2_SERIE "
cSql += " AND F2.F2_CLIENTE = D2.D2_CLIENTE "
cSql += " AND F2.F2_LOJA = D2.D2_LOJA "
cSql += " WHERE "
cSql += " F2_FILIAL = '"+xFilial("SF2")+"' "
cSql += " AND  F2_DOC = '"+cNumNf+"' AND F2_SERIE = '"+cSerie+"' " 
cSql += " AND F2_CLIENTE = '"+cCliente+"' AND F2_LOJA = '"+cLoja+"' "
cSql += " AND F2.D_E_L_E_T_ = '' "
cSql += " ORDER BY D2_ITEM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	cNumItem := PaDL( Val(TRB->D2_ITEM),TamSX3("D1_ITEM")[1],"0")	// acerta zeros a esquerda igual na nota de entrada - 4 caracteres
	nQtdFis := TRB->D2_QUANT
	cCod := AllTrim(TRB->D2_COD)
	cDesc := AllTrim( Posicione( "SB1",1,xFilial("SB1") +AvKey(cCod,"B1_COD"), "B1_DESC" ) )
	/*
	For nY := 1 To Len(aDados[9][2])
		If cNumItem == aDados[9][2][nY][1]
			If nQtdFis <> aDados[9][2][nY][2]
				nDifer := nQtdFis - aDados[9][2][nY][2]              
				If nDifer > 0
					nValor := Round( nDifer*TRB->D2_PRCVEN,2 )
					AADD( axItens, { aDados[9][2][nY][1], nDifer, cCod, cDesc, nValor,TRB->D2_PRCVEN  } )	// item diferenca produto descricao valor total vl unit
				EndIf
				Exit
			EndIf
		EndIf
	Next nY
	*/
	

	For nY := 2 To Len( aConf )
		aItem := aClone( aConf[nY] )					          
		For nZ := 1 To Len( aItem )
			If aItem[2][2] == cNumItem
				If nQtdFis <> Val(aItem[4][2])
					nDifer := ( nQtdFis - Val(aItem[4][2]) )
					If nDifer > 0
						nValor := Round( nDifer*TRB->D2_PRCVEN,2 )
						AADD( axItens, { cNumItem, nDifer, cCod, cDesc, nValor,TRB->D2_PRCVEN  } )	// item diferenca produto descricao valor total vl unit
					EndIf
				EndIf
				Exit
			EndIf
		Next nZ
	Next nY

		
	dbSkip()
End
dbCloseArea()

RestArea(aArea)

Return axItens