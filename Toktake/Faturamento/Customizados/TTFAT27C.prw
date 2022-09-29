#INCLUDE "PROTHEUS.CH"
#Include "aarray.ch"
#Include "json.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT27C    บAutor  ณJackson E. de Deusบ Data ณ  06/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza estoque de armazem movel                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT27C( cNumNf,cSerie,cCliente,cLoja,nOpc )

Local aArea := GetArea()
Local cTpEnt := ""
Local cArmazem := ""          
Default nOpc := 0
     
If cEmpAnt <> "01"
	Return
EndIf

If nOpc == 0
	RestArea(aArea)
	Return
EndIf

dbSelectArea("SF2")
dbsetOrder(2)
If MsSeek( cFilAnt +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
	If AllTrim(SF2->F2_TIPO) == "N" .And. !Empty(SF2->F2_XCODPA) .And. AllTrim(SF2->F2_XNFABAS) == "1" .And. AllTrim(SF2->F2_XFINAL) == "4"
		
		cArmazem := SF2->F2_XCODPA
		If SubStr(SF2->F2_XCODPA,1,1) <> "R" 
			//RestArea(aArea)
			//Return
			//cArmazem := "A" +SubStr( SF2->F2_XCODPA,2 )
		EndIf
		
		dbSelectArea("ZZ1")
		dbSetOrder(1)
		If MsSeek( xFilial("ZZ1") +AvKey(SF2->F2_XCODPA,"ZZ1_COD") )
			cTpEnt := ZZ1->ZZ1_TIPO
		EndIf
		
		Begin Transaction
		
			dbSelectArea("SD2")
			dbSetOrder(3)	// doc serie cliente loja produto item
			If MsSeek( cFilAnt +AvKey(cNumNF,"D2_DOC") +AvKey(cSerie,"D2_SERIE") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA")  )
				While SD2->D2_FILIAL == SF2->F2_FILIAL .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And.;
					SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA
				    				 	
				  	dbSelectArea("SZ7")
				  	dbSetOrder(1) // filial nota serie cliente loja item produto 
			  		// inclusao
			  		If nOpc == 3
					  	If !dbSeek( xFilial("SZ7") +AvKey(SF2->F2_DOC,"Z7_DOC") +AvKey(SF2->F2_SERIE,"Z7_SERIE") +AvKey(SF2->F2_CLIENTE,"Z7_CLIENTE") +AvKey(SF2->F2_LOJA,"Z7_LOJA") +AvKey(SD2->D2_ITEM,"Z7_ITEM") +AvKey(SD2->D2_COD,"Z7_COD") )
						  	If RecLock("SZ7",.T.)
						  		SZ7->Z7_FILIAL	:= xFilial("SZ7")
						  		SZ7->Z7_DOC		:= SF2->F2_DOC		// numero nf
						  		SZ7->Z7_SERIE	:= SF2->F2_SERIE	// serie nf
						  		SZ7->Z7_EMISSAO	:= SF2->F2_EMISSAO	// emissao nf
						  		SZ7->Z7_SAIDA	:= dDatabase		// data saida
						  		SZ7->Z7_CLIENTE	:= SF2->F2_CLIENTE	// cliente
						  		SZ7->Z7_LOJA	:= SF2->F2_LOJA		// loja
						  		SZ7->Z7_TPENTRE	:= cTpEnt			// tipo carga - 
						  		SZ7->Z7_ARMMOV	:= cArmazem			// armazem
						  		SZ7->Z7_ITEM	:= SD2->D2_ITEM		// item nf
						  		SZ7->Z7_COD		:= SD2->D2_COD		// produto
						  		SZ7->Z7_QUANT	:= SD2->D2_QUANT	// qtd
						  		SZ7->Z7_QATU	:= SD2->D2_QUANT	// saldo disponivel
						  		SZ7->Z7_ARMORI	:= SD2->D2_LOCAL	// armazem origem
						  		SZ7->Z7_STATUS	:= "1"				// 1 = em aberto / 2 = prestando contas / 3 = fechado
						  		SZ7->(MsUnLock())
						  		
						  	EndIf
					  	EndIf
					  	
					  					  	
				  	// exclusao
				  	ElseIf nOpc == 5
					  	If dbSeek( xFilial("SZ7") +AvKey(SF2->F2_DOC,"Z7_DOC") +AvKey(SF2->F2_SERIE,"Z7_SERIE") +AvKey(SF2->F2_CLIENTE,"Z7_CLIENTE") +AvKey(SF2->F2_LOJA,"Z7_LOJA") +AvKey(SD2->D2_ITEM,"Z7_ITEM") +AvKey(SD2->D2_COD,"Z7_COD") )
							If RecLock("SZ7",.F.)
						  		SZ7->(dbDelete())
						  		SZ7->(MsUnLock())
						  	EndIf
						EndIf
					EndIf	
				  	
					dbSelectArea("SD2")
					SD2->(dbSkip())
				End
			EndIf
		
		End Transaction
	EndIf	
EndIf
		
RestArea(aArea)

Return	