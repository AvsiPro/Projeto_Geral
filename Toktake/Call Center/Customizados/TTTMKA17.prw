#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA17  บAutor  ณJackson E. de Deus  บ Data ณ  29/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra tela com historico dos patrimonios.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA17(aSZD)

Local oDlg2
Local oBtn1
Local oBtn2
Local oBtn3
Local aDimension	:= MsAdvSize()
Local aInfo 		:= Array(0)
Local aObjects		:= Array(0)             
Local aPosObj		:= Array(0)
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Private oINc		:= LoadBitMap(GetResources(), "BR_VERMELHO")
Private oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oNo			:= LoadBitMap(GetResources(), "BR_PRETO")

If cEmpAnt <> "01"
	Return
EndIf
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ฟ
//ณInconsistente - 1 | Cor Vermelhoณ
//ณAtivo - 2 | Cor Verde           ณ
//ณInativo - 3 | Cor Preto         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ู
*/
For nI := 1 To Len(aSZD)                                           
	//Esta como ativo mas tem data de remocao
	If AllTrim(aSZD[nI][9]) == "1" .And. AllTrim(aSZD[nI][7]) <> "" 
		AADD(aSZD[nI], "1")
		 
	//Esta como ativo mas nao tem data de instalacao
	ElseIf AllTrim(aSZD[nI][9]) == "1" .And. AllTrim(aSZD[nI][5]) == "" 
		AADD(aSZD[nI], "1")
		
	//Esta como inativo mas nao tem data de remocao	
	ElseIf AllTrim(aSZD[nI][9]) == "0" .And. AllTrim(aSZD[nI][7]) == "" 
		AADD(aSZD[nI], "1")
			
	//Esta como inativo mas nao tem data de instalacao	
	ElseIf AllTrim(aSZD[nI][9]) == "0" .And. AllTrim(aSZD[nI][5]) == "" 
		AADD(aSZD[nI], "1")
	
	//Esta como ativo, tem data de instalacao e nao tem data de remocao - OK
	ElseIf AllTrim(aSZD[nI][9]) == "1" .And. AllTrim(aSZD[nI][5]) <> "" .And. AllTrim(aSZD[nI][7]) == "" 
		AADD(aSZD[nI], "2")
		
	//Esta como Inativo, tem data de instalacao e tem data de remocao - OK
	ElseIf AllTrim(aSZD[nI][9]) == "0" .And.AllTrim(aSZD[nI][5]) <> "" .And. AllTrim(aSZD[nI][7]) <> "" 
		AADD(aSZD[nI], "3")
	EndIf
	
	aSZD[nI][5] := StoD(aSZD[nI][5])
	aSZD[nI][7] := StoD(aSZD[nI][7])
Next nI


aSort(aSZD,,,{|x,y| x[5] > y[5]})


aAdd(aObjects,{000, 010, .T., .F. })	
aAdd(aObjects,{000, 000, .T., .T. })

aDimension[1] := aDimension[1]/2
aDimension[2] := aDimension[2]/2
aDimension[3] := aDimension[3]/2
aDimension[4] := aDimension[4]/2
aDimension[5] := aDimension[5]/2
aDimension[6] := aDimension[6]/2
aDimension[7] := aDimension[7]/2

                                
aInfo := {aDimension[1],aDimension[2],aDimension[3],aDimension[4], 3 /*distancia horizontal*/, 3 /*distancia vertical*/}
aPosObj := MsObjSize(aInfo,aObjects)


//Monta a janela
oDlg2	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Hist๓rico do Patrim๔nio",,,.F.,,,,,,.T.,,,.T. )	
	
	//oGrp1 := TGroup():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2 := TSay():New( aPosObj[1][1]+7,aPosObj[1][2]+2,{|| "Hist๓rico do patrim๔nio no cliente:" },oDlg2,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)    
	
	oList2 := TCBrowse():New(aPosObj[2][1]+6,aPosObj[2][2]+1,aPosObj[2][4]-3,aPosObj[2][3]-50,,{" ","Patrim๔nio","OMM","Data Instala็ใo","Hora", "Data Remo็ใo", "Hora","Status"},{05,10,10,15,10,15,10,10},oDlg2,,,,/*{|| troca de linha*/,/*{|| duplo clique }*/,/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aSZD) > 0},.F.,,.T.,.T.,)	
	oList2:nScrollType := 1 //SCROLL VRC
	oList2:SetArray(aSZD)                                                      
	
	// Monta a linha a ser exibida no Browse
	oList2:bLine := {||{	IIF(aSZD[oList2:nAt,11]=="1",oINc, IIF(aSZD[oList2:nAt,11]=="2",oOK,oNo)  ),;	//[1] Ativo ou Inativo ou Inconsistente?
							aSZD[oList2:nAt,04],;															//[3] Patrimonio
							aSZD[oList2:nAt,03],;															//[4] OMM
							aSZD[oList2:nAt,05],;															//[5] Data instalacao
							aSZD[oList2:nAt,06],;															//[6] Hora instalacao
							aSZD[oList2:nAt,07],;															//[7] Data remocao
							aSZD[oList2:nAt,08],;															//[8] Hora remocao
							IIF(aSZD[oList2:nAt,09]=="1","Ativo","Inativo")}}								//[9] Status
			 
	oBtn3	:= TBtnBmp2():New( aDimension[6]-45, aDimension[5]-50, 40, 40, 'CANCEL' , , , ,{||oDlg2:End() } , oDlg2, "Sair" , ,)
	
oDlg2:Activate(,,,.T.)
																	
Return