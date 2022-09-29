#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC89  บAutor  ณJackson E. de Deusบ   Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Estorno de movimentacoes originadas de OS mobile           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATC89()

Local oDlgMain		:= Nil
Local aCoordenadas	:= MsAdvSize(.T.)
Local aSD3			:= {}
Local nOpcClick		:= 0
Local i
Local lOk			:= .T.
Local aPergs := {}
Local aRet := {}
Local cMaquina := "" 
Local dInicio := dDatabase
Local dFim := dDatabase
Local cArmazem := ""
Local cArmA := ""
Local aOS := {}
Local nCntProc := 0

If cEmpAnt <> "01"
	Return
EndIf

aAdd(aPergs ,{1,"Rota/PA"		,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Mแquina"		,space(TamSx3("AA3_CHAPA")[1]),"@!",".T.","SN1",".T.",60,.F.})
aAdd(aPergs ,{1,"Data Inicio"	,dInicio,"99/99/99","","","",60,.F.})
aAdd(aPergs ,{1,"Data Fim"		,dFim,"99/99/99","","","",60,.F.})
 	
If ParamBox(aPergs ,"Ajuste movimentos",@aRet)
	cArmazem := aRet[1]
	cMaquina := aRet[2]
	dInicio := aRet[3]
	dFim := aRet[4]
	If Empty(cArmazem)
		MsgAlert("Informe um armazem vแlido!")
		Return
	EndIf
	
	
	If dInicio <> Date() .Or. dFim <> Date()
		MsgAlert("O estorno ้ vแlido somente para as Ordens de Servi็o de hoje!")
		Return
	EndIf     
	
	If Time() > "19:30:00"
		MsgAlert("O estorno ้ vแlido somente para as Ordens de Servi็o de hoje e antes do processamento para tabela de movimentos internos - SD3.")
		Return
	EndIf                           
EndIf

If SubStr(cArmazem,1,1) == "R"
	nTipoArm := 1
ElseIf SubStr(cArmazem,1,1) == "P"
	nTipoArm := 2
EndIf

// ROTA
// Sai do R
// Entra no P
// Entra no N SZ0

// PA
// sai do A
// Entra no N

FWMsgRun(, { |oSay| Process( oSay,nTipoArm,cArmazem,dInicio,dFim,@aSD3,cMaquina ) } )

If Len(aSD3) == 0
	MsgAlert("Aten็ใo, nenhum documento de distribui็ใo foi localizado para esse armaz้m.")
	Return()
EndIf
     
// data os produto
Asort(aSD3,,,{|x,y| x[6] < y[6] .And. x[2] < y[2] .And. x[7] < y[7] })


// mostrar tela com ordens de servico


// tela
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Estorno de Documentos de Distribui็ใo"),,,,,,,,oMainWnd,.T.)
	                  
	oImg := TBitmap():New(0,5,10,10,"WATCH","",.T.,oDlgMain,{ || MsgInfo("Os estornos serใo gravados em Log para auditoria.") },,.F.,.T.,,,.F.,,.T.,,.F.)
	
	TGroup():New(014,003,oDlgMain:nClientHeight/2-30,oDlgMain:nClientWidth/2-5,"Marque os movimentos que serใo estornados",oDlgMain,,,.T.)
	oListBox := TWBrowse():New(024,005,oDlgMain:nClientWidth/2-12,oDlgMain:nClientHeight/2-60,,{" ","OS mobile","Patrim๔nio","Modelo","Documento","Data","Produto","Descri็ใo","Quantidade","Armazem","Descricao","Movimento" },,oDlgMain,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aSD3)
	oListBox:bLine := {||{ 	IIf(aSD3[oListBox:nAt][1],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
								aSD3[oListBox:nAt][2],;
								aSD3[oListBox:nAt][3],;
								aSD3[oListBox:nAt][4],;
								aSD3[oListBox:nAt][5],;
								aSD3[oListBox:nAt][6],;
								aSD3[oListBox:nAt][7],;
								aSD3[oListBox:nAt][8],;
								Transform(aSD3[oListBox:nAt][9],"@E 999,999,999.99"),;
								aSD3[oListBox:nAt][10],;
								aSD3[oListBox:nAt][11],;
								IIf(aSD3[oListBox:nAt][13]=="600",LoadBitmap( GetResources(), "METAS_BAIXO_16" ),LoadBitmap( GetResources(), "METAS_CIMA_16" ))	 }}
								
								oListBox:bLDblClick := { || aSD3[oListBox:nAt,1] := !aSD3[oListBox:nAt,1], oListBox:Refresh() }
	                                 	
	EnchoiceBar(oDlgMain,{ || lOk := fChoice(aSD3), If(lOk,oDlgMain:End(nOpcClick := 1),/**/)  },{ || oDlgMain:End(nOpcClick := 0)} )
oDlgMain:Activate(,,,.T.)

//Faz o estorno dos movimentos marcados
If nOpcClick == 1
	For i := 1 To Len(aSD3)
		If !aSD3[i][1]
			Loop
		EndIf
		
		LJMsgRun("Estornando movimento: " + aSD3[i][4],"Aguarde...",{|| Estorno(aSD3[i],nTipoArm) })
		
		If Ascan( aOS, { |x| x == aSD3[i][2] } ) == 0
			AADD( aOS, aSD3[i][2] )
		EndIf
	Next i
	/*
	dbSelectArea("SZG")
	dbSetOrder(1)
	For nI := 1 To Len( aOS )
		If MsSeek( xFilial("SZG") +AvKey(aOS[nI],"ZG_NUMOS") )
			RecLock("SZG",.F.)
			SZG->ZG_PROC := ""
			MsUnLock()
			nCntProc++
		EndIf
	Next nI
	
	MsgInfo("Total de Ordens de Servi็o para novo reprocessamento: " +cvaltochar(nCntProc) )*/
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChoice  บAutor  ณJackson E. de Deus   บ Data ณ  09/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChoice(aSD3)

Local lRet	:= .T.
Local nI
Local nPos	:= 0
Local nErro := 0    

For nI := 1 To Len(aSD3)
	If aSD3[nI][1]
		If aSD3[nI][13] == "600"
			// OS PRODUTO QTD LOCAL
			nPos := aScan( aSD3, { |x| x[2] == aSD3[nI][2] .And. x[7] == aSD3[nI][7] .And.;
									 x[9] == aSD3[nI][9]  .And. x[13] == "100"  } )
			If nPos > 0
				If !aSD3[nPos][1]
					nErro++
				EndIf
			EndIf 
		ElseIf aSD3[nI][13] == "100"
			nPos := aScan( aSD3, { |x| x[2] == aSD3[nI][2] .And. x[7] == aSD3[nI][7] .And.;
									 x[9] == aSD3[nI][9]  .And. x[13] == "600"  } )
			If nPos > 0
				If !aSD3[nPos][1]
					nErro++
				EndIf
			EndIf 
		EndIf
	EndIf
Next nI

If nErro > 0
	lRet := .F.
	MsgAlert("Revise os movimentos marcados! Para movimentos de Rota para PA ้ necessแrio marcar a saํda da Rota e entrada na PA.")
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcess  บAutor  ณJackson E. de Deus   บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os movimentos do periodo                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Process( oSay,nTipoArm,cArmazem,dInicio,dFim,aSD3,cMaquina )

Local cArmA := ""

Local cQuery := ""

cQuery := "SELECT Z5_NUMOS,Z5_TM, Z5_CHAPA, Z5_DOC, Z5_COD, Z5_QUANT, Z5_LOCAL, Z5_EMISSAO, SZ5.R_E_C_N_O_ Z5REC FROM SZ5010 SZ5 WITH (NOLOCK) "
cQuery += "INNER JOIN SZG010 ON ZG_NUMOS = Z5_NUMOS "
cQuery += "WHERE ZG_DATAFIM BETWEEN '"+DTOS(dInicio)+"' AND '"+DTOS(dFim)+"' "
cQuery += " AND ZG_ROTA = '"+cArmazem+"' "
cQuery += " AND ZG_FORM IN ('04','08') "
cQuery += " AND SZ5.D_E_L_E_T_ = '' "

If !Empty(cMaquina)
	cQuery += " AND Z5_CHAPA = '"+cMaquina+"' "
EndIf

cQuery += " ORDER BY Z5_NUMOS, Z5_COD, Z5_TM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	AAdd(aSD3,{	.T.,;
				TRB->Z5_NUMOS,;
				TRB->Z5_CHAPA,;
				Posicione("SN1",1,xFilial("SN1") +AvKey(TRB->Z5_CHAPA,"N1_CHAPA"),"N1_DESCRIC" ),;
				TRB->Z5_DOC,;
				STOD(TRB->Z5_EMISSAO),;
				TRB->Z5_COD,;
				Posicione("SB1",1,xFilial("SB1") +AvKey(TRB->Z5_COD,"B1_COD"),"B1_DESC" ),;
				TRB->Z5_QUANT,;
				TRB->Z5_LOCAL,;
				Posicione("ZZ1",1,xFilial("ZZ1") +AvKey(TRB->Z5_LOCAL,"ZZ1_COD"),"ZZ1_DESCRI" ),;
				0,;
				TRB->Z5_TM,;
				TRB->Z5REC })  	
	dbSkip()
End
TRB->(dbCloseArea())	

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEstorno  บAutor  ณJackson E. de Deus   บ Data ณ  12/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz o estorno das movimenta็๕es                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Estorno(aSD3,nTipoArm)

Local aSD3Auto		:= {}
Local cTipo			:= ""
Local lBaixa		:= .T.
Private lMsErroAuto := .F.


Begin Transaction      
	dbSelectArea("SZ5")
	dbGoTo(aSD3[14])
	cTm := AllTrim(SZ5->Z5_TM)
	nQtd := SZ5->Z5_QUANT
	cLocal := SZ5->Z5_LOCAL
	cProd := SZ5->Z5_COD
	cTipo := SZ5->Z5_TIPO
	cMola := SZ5->Z5_MOLA
	
	If cTm == "100"
		cTm := "600"
	ElseIf cTm == "600"
		cTm := "100"
	EndIf
	
	/*     
	// AJUSTAR - LANCAR MOVIMENTO REVERSO
	RecLock("SZ5",.F.)
	SZ5->Z5_ESTORNO := "S"
	MSUnlock()
	
	
	U_MntSZ5( cLocal,cProd,cTM,aSD3[6],nQtd,aSD3[2],cMola,"ESTORNO MOVIMENTO OS","TTFATC89",aSD3[3],cTipo,IIF(nTipoArm==1,"R","P") )
	*/
	
	// AJUSTAR - EXCLUIR REGISTRO PARA NOVO PROCESSAMENTO
	RecLock("SZ5",.F.)
	dbDelete()
	MSUnlock()
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If MsSeek( xFilial("SZ6") +AvKey(cLocal,"Z6_LOCAL") +AvKey(cProd,"Z6_COD") )		
		// saida - verifica se saldo eh suficiente
		If cTM > "500"
			If SZ6->Z6_QATU < nQtd
				CONOUT("#TTFATC89 -> SALDO INSUFICIENTE PARA BAIXA: " +cLocal + ":" +cProd +":" +cvaltochar(nQtd)) 
			Else
				If RecLock("SZ6",.F.)
					If cTM <= "500"
						SZ6->Z6_QATU += nQtd
					Else 
						SZ6->Z6_QATU -= nQtd
					EndIf		
					SZ6->( MsUnLock() )
				EndIf
			EndIf
		EndIf
	EndIf
	
	nRecZ0 := fRecSZ0( aSD3[2], aSD3[3], aSD3[7], aSD3[9],cTipo,cMola )	// os patrimonio produto quant
	If nRecZ0 > 0
		dbSelectArea("SZ0")
		dbGoTo(nRecZ0)
		RecLock("SZ0",.F.)
		dbDelete()
		MsUnlock()
	EndIf
	
	// SD3
	/*If aSD3[12] > 0
		dbSelectArea("SD3")
		dbGoTo(aSD3[12])
		If SubStr(SD3->D3_LOCAL,1,1) $ "R#P#A"
			RecLock("SD3",.F.)
			dbDelete()
			MsUnLock()
		EndIf
	EndIf*/
		
	//If cTm > "500" .And. SubStr(cLocal,1,1) == "R" 
	If cTipo == "100"
		StaticCall( TTPROC25,SBArmMov,cLocal,cProd,nQtd )	
	EndIf

End Transaction


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRecSZ0  บAutor  ณJackson E. de Deus   บ Data ณ  15/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o recno do registro na SZ0                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function fRecSZ0( cNumOS, cNumChapa, cProduto, nQuant,cTipo,cMOla )

Local cSql := ""
Local nRecno := 0

cSql := "SELECT R_E_C_N_O_ Z0REC FROM " + RetSqlName("SZ0")
cSql += " WHERE "
cSql += " Z0_NUMOS = '"+cNumOS+"' AND Z0_CHAPA = '"+cNumChapa+"' AND Z0_PRODUTO = '"+cProduto+"' AND Z0_MOLA = '"+cMOla+"' "
cSql += " AND D_E_L_E_T_ = '' "

/*    
// abastecimento
If cTipo == "A"
	cSql += " AND Z0_ABAST = '"+cvaltochar(nQuant)+"' "

// retirada
ElseIf cTipo == "R"
	cSql += " AND Z0_RETIR = '"+cvaltochar(nQuant)+"' "
	
// descarte
ElseIf cTipo == "D"
	cSql += " AND Z0_AVARIA = '"+cvaltochar(nQuant)+"' "
EndIf
*/

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
If !EOF()
	nRecno := TRB->Z0REC
EndIf

TRB->(dbCloseArea())

Return nRecno