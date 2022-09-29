
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO17    บAutor  ณMicrosiga           บ Data ณ  04/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTOPER18()

Local oTela
Private aHeader 	:= {}
Private aCols		:= {}
Private oGrid  
Private aAlter		:= {"ZZ1_XATEND","ZZ1_XAGEND"/*,"ZZ1_XPULAS"*/}

If cEmpAnt <> "01"
	
	LoadHead()
	
	
	oTela := MSDialog():New( 0,0,400,800,"Inventแrio de Armazem",,,.F.,,,,,,.T.,,,.T. )
		oTela:lEscClose := .F.
		
		oGrid := MsNewGetDados():New(0,0,0,0,GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAlter,1,999,"STATICCALL(TTOPER18,VldCampo)","","AllwaysTrue()",oTela,aHeader,aCols,{ ||  } )
		oGrid:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		
		oTela:bStart := { || LoadCols() }
		                          
	oTela:Activate(,,,.T.)       
EndIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER18  บAutor  ณMicrosiga           บ Data ณ  04/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadHead()

dbSelectArea("SX3")
dbSetOrder(2)
If MsSeek( "ZZ1_COD" )
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT, SX3->X3_CBOX})
EndIf

If MsSeek( "ZZ1_DESCRI" )
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT, SX3->X3_CBOX})
EndIf

If MsSeek( "ZZ1_XATEND" )
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT, SX3->X3_CBOX})
EndIf

If MsSeek( "ZZ1_XNOMAT" )
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT, SX3->X3_CBOX})
EndIf

If MsSeek( "ZZ1_XAGEND" )
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT, SX3->X3_CBOX})
EndIf

/*
If MsSeek( "ZZ1_XPULAS" )
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT, SX3->X3_CBOX})
EndIf
*/

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER18  บAutor  ณMicrosiga           บ Data ณ  04/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Loadcols()

dbSelectArea("ZZ1")
dbSetOrder(1)
dbGoTop()
While ZZ1->ZZ1_FILIAL == xFilial("ZZ1") .And. !EOF() 
	If SubStr(ZZ1->ZZ1_COD,1,1) == "P" 
	 	AAdd(aCols, Array(Len(aHeader)+1))
	 	nLin := Len(aCols)
		For nI := 1 To Len(aHeader)
			If !Empty(ZZ1->&(aHeader[nI][2]))	
				aCols[nLin][nI] := AllTrim(ZZ1->&(aHeader[nI][2]))
			Else
				aCols[nLin][nI] := Space(TamSx3(aHeader[nI][2])[1])
			EndIf
		Next nI
	
		aCols[nLin][Len(aHeader)+1] := .F.		
		
		//AADD( aCols, { ZZ1->ZZ1_COD, ZZ1->ZZ1_DESCRI, ZZ1->ZZ1_XATEND, ZZ1->ZZ1_XNOMAT, ZZ1->ZZ1_XAGEND } )
	EndIf
	dbSkip()
End

oGrid:Acols := aClone(aCols)
oGrid:Enable()
oGrid:Refresh(.T.)
oGrid:GoTop()	  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER18  บAutor  ณMicrosiga           บ Data ณ  04/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldCampo()

Local nPosPA := Ascan( aHeader, { |x| AllTrim(x[2]) == "ZZ1_COD" } )
Local nPosNome := Ascan( aHeader, { |x| AllTrim(x[2]) == "ZZ1_XNOMAT" } )

dbSelectArea("ZZ1")
dbSetOrder(1)

If __readVar == "M->ZZ1_XATEND"
	oGrid:aCols[oGrid:oBrowse:nAt][nPosNome] := AllTrim(AA1->AA1_NOMTEC)
	
	If MsSeek( xFilial("ZZ1") +AvKey( oGrid:aCols[oGrid:oBrowse:nAt][nPosPA],"ZZ1_COD") )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_XATEND := M->ZZ1_XATEND
		ZZ1->ZZ1_XNOMAT := Posicione( "AA1", 1, xFilial("AA1") +AvKey(M->ZZ1_XATEND,"AA1_COD"),"AA1_NOMTEC" )
		MsUnLock()                     
	EndIf	
ElseIf __readVar == "M->ZZ1_XAGEND"
	If MsSeek( xFilial("ZZ1") +AvKey( oGrid:aCols[oGrid:oBrowse:nAt][nPosPA],"ZZ1_COD") )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_XAGEND := AllTrim(M->ZZ1_XAGEND)
		MsUnLock()
	EndIf/*                          
ElseIf __readVar == "M->ZZ1_XPULAS"	
	If MsSeek( xFilial("ZZ1") +AvKey( oGrid:aCols[oGrid:oBrowse:nAt][nPosPA],"ZZ1_COD") )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_XPULAS := AllTrim(M->ZZ1_XPULAS)
		MsUnLock()
	EndIf  */  		
EndIf


Return .T.