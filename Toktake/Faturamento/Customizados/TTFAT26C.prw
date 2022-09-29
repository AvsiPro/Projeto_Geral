#include "protheus.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT26C บAutor  ณJackson E. de Deus   บ Data ณ  25/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para configuracao de TES dos itens do pedido          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT26C( aTES )

Local cTes		:= ""      
Local nI,nJ
Local aSize		:= MsAdvSize()
Local oDlg
Local oLayer	:= FWLayer():new()
Local oFont		:= TFont():New('Arial',,-12,.T.,.T.)
Local oPnlCab
Local aAlter	:= {"T_TES"}
Local nTamanho	:= 0.6
Local lAjuste	:= .F.
Local nLin		:= 0
//Private n		:= 0
Private aHeader	:= {}
Private aCols	:= {}

If cEmpAnt <> "01" 
	Return
EndIF

dbSelectArea("SX3")
dbSetOrder(2)
MsSeek( "B1_COD" )
Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,"",SX3->X3_TIPO,"","" })	

MsSeek( "B1_DESC" )
Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,30,SX3->X3_DECIMAL,SX3->X3_VALID,"",SX3->X3_TIPO,"","" })	

MsSeek( "C6_TES" )
Aadd(aHeader,{Trim(X3Titulo()),"T_TES",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"SF4","" })	
                
MsSeek( "F4_FINALID" )
Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,30,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"","" })	

        
// carrega acols
For nI := 1 To Len(aTES)
	// tratamento para mostrar somente produtos que estao sem TES - 25/07/2016
	If !Empty(aTES[nI][2])
		Loop
	EndIf

	AAdd(aCols, Array(Len(aHeader)+1))
	nLin := Len(aCols)
	
	aCols[nLin][1] := aTES[nI][1]
	aCols[nLin][2] := Posicione( "SB1",1,xFilial("SB1") +AvKey( aTES[nI][1],"B1_COD"),"B1_DESC" )
	aCols[nLin][3] := aTES[nI][2]
	aCols[nLin][4] := IIF(!Empty(aTES[nI][2]),Posicione( "SF4",1,xFilial("SF4") +AvKey( aTES[nI][2],"F4_CODIGO"),"F4_FINALID" ),Space(TamSx3("F4_FINALID")[1]))
	
	aCols[nLin][Len(aHeader)+1] := .F.		
Next nI


aSize[1] := aSize[1] * nTamanho
aSize[2] := aSize[2] * nTamanho
aSize[3] := aSize[3] * nTamanho
aSize[4] := aSize[4] * nTamanho
aSize[5] := aSize[5] * nTamanho
aSize[6] := aSize[6] * nTamanho
aSize[7] := aSize[7] * nTamanho

//RegtoMemory("SC5")

oDlg := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Configura็ใo de TES",,,.F.,,,,,,.T.,,,.T. )	

	// GRID
	oPanel2 := tPanel():New(0,0,"",oDlg,,,,,,100,020)
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGetDB :=	MsNewGetDados():New(0,0,0,0,GD_UPDATE,"AllwaysTrue()","AllwaysTrue()","",aAlter,0,99,'STATICCALL(TTFAT26C,VldCampo)','','AllwaysTrue()',oPanel2,aHeader,aCols,{ || /**/ })
	oGetDB:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
 
    // painel rodape - botoes acao
	oPanel3 := tPanel():New(0,0,"",oDlg,,,,,,0,020)
	oPanel3:align := CONTROL_ALIGN_BOTTOM

	oSBtn1 := TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || Salvar(@aTES),oDlg:End()  } , oPanel3, "Salvar" , ,)
	oSBtn1:Align := CONTROL_ALIGN_RIGHT
oDlg:Activate(,,,.T.,,,)


Return aTES


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCampo  บAutor  ณJackson E. de Deus  บ Data ณ  07/25/15   บฑฑ
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
            
Local lREt := .T.
Local cDescTes := ""
Local nX

If __readvar == "M->T_TES"
	If !Empty(M->T_TES)      
		lRet := ExistCPO("SF4",M->T_TES)
		If lRet
			cDescTes := AllTrim( Posicione( "SF4",1,xFilial("SF4") +AvKey( M->T_TES,"F4_CODIGO"),"F4_FINALID" ) )
			oGetDB:aCols[oGetDb:nAt][4] := cDescTes
			
			If oGetDb:nAt == 1 .And. oGetDb:nAt <> Len(oGetDB:aCols)
				If MsgYesNo("Deseja replicar para os pr๓ximos produtos?")
					For nX := oGetDb:nAt To Len(oGetDB:aCols)
						oGetDB:aCols[nX][3] := M->T_TES
						oGetDB:aCols[nX][4] := cDescTes
					Next nX
				EndIf
			EndIf
		EndIf
	EndIf	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSalvar    บAutor  ณJackson E. de Deus  บ Data ณ  07/25/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Salvar(aTES)
    
For nI := 1 To Len(oGetDB:aCols)
	For nJ := 1 To Len(aTES)
		If aTES[nJ][1] == oGetDB:aCols[nI][1]
			aTES[nJ][2] := oGetDB:aCols[nI][3]
		EndIf
	Next nJ
Next nI

Return aTES