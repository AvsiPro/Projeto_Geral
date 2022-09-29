
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER19   บAutor  ณJackson E. de Deus บ Data ณ  06/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica e ajusta saldo a devolver                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTOPER19( cCodPa,aLista ) 

Local nI
Local cNF := ""
Local cSerie := ""
Local cItem := ""
Local nQtd := 0
Local nPrc := 0
Local aNF := {}                               

If cEmpAnt <> "01"
	
	For nI := 1 To Len( aLista )
		If AScan( aNF, { |x| x == aLista[nI][4] } ) == 0
			AADD( aNF, aLista[nI][4] )
		EndIf
	Next nI
																
	For nI := 1 To Len( aLista )
		
		cNF := aLista[nI][4]
		cSerie := aLista[nI][5]
		cItem := aLista[nI][6]
		nPrc := aLista[nI][3]                      
		nQtd := aLista[nI][2]
			
		Avalia( cCodPa,aNF,aLista[nI][1],nQtd,@cNf, @cSerie, @cItem,@nPrc ) 	// produto qtd nf serie item PRECO
		
		aLista[nI][4] := cNf
		aLista[nI][5] := cSerie
		aLista[nI][6] := cItem
		aLista[nI][3] := nPrc
			
	Next nI
EndIf

Return
                 
      
      
// Avalia o produto/NF
Static Function Avalia( cCodPa,aNF,cProduto,nQtd,cNf,cSerie,cItem,nPrc )

Local cQuery := ""
Local nDevolvido := 0

cQuery := "SELECT D1_QUANT FROM " +RetSqlName( "SD1" )
cQuery += " WHERE D1_NFORI = '"+cNF+"' AND D1_COD = '"+cProduto+"' AND D1_ITEMORI = '"+cItem+"' "

MpSysOpenQuery( cQuery,"TRBD1" )

dbSelectArea("TRBD1")

While !EOF()
	nDevolvido += TRBD1->D1_QUANT
	dbSkip()
End

TRBD1->( dbCloseArea() )

// ja devolveu mais do que a quantidade que precisa ser devolvida agora. -> PROCURAR ENTAO OUTRA NOTA MAIS ANTIGA PARA CONSEGUIR FAZER A DEVOLUCAO
dbSelectArea("SD2")
dbSetOrder(3)	// doc serie cliente loja produto item
If MSSeek( cFilAnt +AvKey(cNf,"D2_DOC") +AvKey(cSerie,"D2_SERIE") +AvKey("000001","F2_CLIENTE") +AvKey("0001","F2_LOJA") +AvKey(cProduto,"D2_COD") +AvKey(cItem,"D2_ITEM")  )
	If ( SD2->D2_QUANT - nDevolvido ) < nQtd
		cQuery := "SELECT TOP 100 D2_DOC,D2_SERIE, D2_ITEM , D2_PRCVEN, D2_QUANT,'D1TOTAL' = (
		cQuery += 		" SELECT SUM(D1_QUANT) FROM " +RetSqlName("SD1") 
		cQuery += 		" WHERE D1_FILIAL = D2_FILIAL "
		cQuery += 		" AND D1_NFORI = D2_DOC " 
		cQuery += 		" AND D1_SERIORI = D2_SERIE "
		cQuery += 		" AND D1_ITEMORI = D2_ITEM "
		cQuery += 		" AND D1_COD = D2_COD "
		cQuery += 		" AND D_E_L_E_T_= '' " 
		cQuery += 		" ) "
		
		cQuery += " FROM " +RetSqlName("SD2") + " SD2 "
		
		cQuery += " INNER JOIN " +RetSqlName("SF2") + " SF2 ON "
		cQuery += " F2_FILIAL = D2_FILIAL "
		cQuery += " AND F2_DOC = D2_DOC "
		cQuery += " AND F2_SERIE = D2_SERIE "
		
		cQuery += " WHERE D2_COD = '"+cProduto+"' AND D2_QUANT >= '"+CVALTOCHAR(nQtd)+"' "
		cQuery += " AND F2_XCODPA = '"+cCodPa+"' AND SF2.D_E_L_E_T_ = '' AND F2_EMISSAO < '"+DTOS(dDatabase)+"' "
		cQuery += " AND F2_DOC <> '"+cNf+"' "
		
		cQuery += " ORDER BY F2_EMISSAO DESC "
		
		MpSysOpenQuery( cQuery, "TRBD2" )
		dbSelectARea("TRBD2")
		While !EOF()         
		
			If AScan( aNF, { |x| AllTrim(x) == AllTrim(TRBD2->D2_DOC) } ) == 0		
				If ( TRBD2->D2_QUANT - TRBD2->D1TOTAL ) >= nQtd
					cNf := TRBD2->D2_DOC
					cSerie := TRBD2->D2_SERIE
					cItem := TRBD2->D2_ITEM
					nPrc := TRBD2->D2_PRCVEN
					Exit                    
				EndIf
			EndIf
		
			TRBD2->( dbSkip() )
		End
			
	EndIf
EndIf


Return