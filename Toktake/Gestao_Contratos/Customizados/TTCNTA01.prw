#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA01  ºAutor  ³Alexandre Venancio  º Data ³  08/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina criada para importar os ativos existentes para os   º±±
±±º          ³novos contratos cadastrados.                                º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³08/02/13³01.00 |Criacao                                 ³±±
±±³Jackson       ³10/09/14³01.01 |Ajuste feito gravar os patrimonios na   ³±±
±±³								  tabela SZQ - patrimonios x contratos	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTCNTA01(cContra,cRevisa,aAux)

Local aCabec	:= {}
Local aItens	:= {}
Local aLinha	:= {}
Local nX		:= 0
Local nY		:= 0
Local cDocIni	:= "000001"
Local cDoc		:= cDocIni
Local lOk		:= .T.
Local lVldNum	:= .F.    
Local aAux2		:= {}
Local aAux3		:= {}
Local aAuxGrp	:= {}
Local cQuery	:= ""
Local cPatr		:= "" 
Local nVlr		:= 0
Local aPatrSZQ	:= {}
Local cCodcli := ""
Local cLojaCli := ""


Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.
Private cEspctr   := "1"
Private oGetDad1  

If cEmpAnt <> "01"
	Return
EndIf

If lOk
	dbSelectArea("CN9")	
	dbSetOrder(1)	
	If !dbSeek(xFilial("CN9")+cContra+cRevisa)
		MsgAlert("Contrato inexistente, favor verificar!!!","TTCNTA01")
		Return
	EndIf		
	
	dbSelectArea("CNA")	
	dbSetOrder(1)
	While !lVldNum
		If DbSeek(xFilial("CNA")+cContra+SPACE(3)+cDoc)
			cDoc := SOMA1(cDoc)
		Else
			lVldNum := .T.	
		EndIf
	End
    cDocIni := cDoc
    
	dbSelectArea("CNC")	
	dbSetOrder(1)	
	dbSeek(xFilial("CNC")+cContra)	
	aCabec := {}	
	aItens := {}	
	
	If Empty(cDoc)
		cDoc := StrZero(1,Len(CNA->CNA_NUMERO))	
	Else
	//	cDoc := Soma1(cDoc)	
	EndIf
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta cabecalho - CNA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	aadd(aCabec,{"CNA_CONTRA"   ,cContra})	
	aadd(aCabec,{"CNA_NUMERO"   ,cDoc})
	aadd(aCabec,{"CNA_REVISA"   ,CN9->CN9_REVISA})	
	aadd(aCabec,{"CNA_CLIENT"   ,CN9->CN9_CLIENT})	
	aadd(aCabec,{"CNA_LOJACL"   ,CN9->CN9_LOJACL})	
	aadd(aCabec,{"CNA_DTINI"    ,CN9->CN9_DTINIC})	
	aadd(aCabec,{"CNA_VLTOT"    ,1000})		//ACERTAR
	aadd(aCabec,{"CNA_SALDO"    ,0})		//ACERTAR
	aadd(aCabec,{"CNA_TIPPLA"   ,"004"})	//ACERTAR
	aadd(aCabec,{"CNA_DTFIM"    ,CN9->CN9_DTFIM})	//ACERTAR
	aadd(aCabec,{"CNA_CRONOG"   ,""})	
	aadd(aCabec,{"CNA_FLREAJ"   ,"1"})                      
    
    cTpCont := CN9->CN9_XTPCNT
    
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ!
	//³Monta itens - CNB³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ!
	*/
    // Caso seja um contrato do tipo 'selecionado' - prepara array auxiliar aglutinando os itens conforme campo 'selecao'
  	If cTpCont == "3"
  		// Procura os itens que foram selecionados com algum valor no campo 'selecao'
  		For nX:= 1 to len(aAux)                                                                          
  			If aAux[nX][11] <> 0
   				AADD(aAux2,aAux[nX])
   			EndIf
		Next nX
   		
		// Agrupa
		For nX:= 1 to len(aAux2)
			If nX == 1
				AADD(aAuxGrp, aAux2[nX])
				aAuxGrp[len(aAuxGrp),02] := Alltrim(aAuxGrp[len(aAuxGrp),02]+"="+cvaltochar(aAuxGrp[len(aAuxGrp),10])+"|")
				Loop				
			EndIf
	
	 		nRes := aScan(aAuxGrp, { |x| aAux2[nX][11] == x[11] } )
	 
			If nRes > 0                          
				aAuxGrp[nRes][10] += aAux2[nX][10]		// incrementa valor
				aAuxGrp[nRes][2] += AllTrim(aAux2[nX][2]) +"=" +cValToChar(aAux2[nX][10])	// incrementa patrimonio
				If nX <> Len(aAux2)
					aAuxGrp[nRes][2] +=	"|"
				EndIf
			Else
				AADD(aAuxGrp,aAux2[nX])
				aAuxGrp[len(aAuxGrp),02] := Alltrim(aAuxGrp[len(aAuxGrp),02]+"="+cvaltochar(aAuxGrp[len(aAuxGrp),10])+"|")
			EndIf     
		Next nX
	 	aAux := AClone(aAuxGrp)
  	EndIf
  	
	//	Gera planilhas
  	For nX := 1 To Len(aAux)
	  	aPatrSZQ := {}
  		aLinha := {}
  		
  		If nX > 1
			cDoc := Soma1(cDoc)
			aCabec[02,02] := cDoc //altera o numero do documento no cabecalho
		EndIf
			
		aadd(aLinha,{"CNB_NUMERO"   ,cDoc								,Nil})		  
  		aadd(aLinha,{"CNB_REVISA"   ,CN9->CN9_REVISA					,Nil})		
		aadd(aLinha,{"CNB_ITEM"     ,StrZero(nX,len(CNB->CNB_ITEM))	,Nil})
		aadd(aLinha,{"CNB_CONTRA"   ,cContra							,Nil})		
		aadd(aLinha,{"CNB_DTCAD"    ,CN9->CN9_DTINIC					,Nil})  //ACERTAR
  		                  
	   	// Individual - gerar varias planilhas com um item em cada
		If cTpCont == "1"
			AADD(aPatrSZQ, {cContra,cDoc,aAux[nX,02], aAux[nX,10], Date() } )

		//Agrupado - gera somente uma planilha com o valor e patrimonios agrupados (aglutinacao)
		ElseIf cTpCont == "2"
			For nY := 1 to Len(aAux)
				AADD(aPatrSZQ, {cContra,cDoc,aAux[nY,02], aAux[nY,10], Date() } )
			Next nY
			
			nVlr := 0
 			For nY := 1 to len(aAux)
 				nVlr += aAux[nY,10]
 			Next nY
 			            
 		// Selecionado	
 		ElseIf cTpCont == "3"                  
 			cPatr := aAux[nX][2]
 			If SubStr(cPatr,Len(cPatr),1) == "|"
 				cPatr := SubStr(cPatr,1,Len(cPatr)-1)
 			EndIf
 			aAux2 := StrtoKarr(cPatr,"|")
			For nY := 1 to Len(aAux2)
				aAux3 := StrtoKarr(aAux2[nY],"=")
				AADD(aPatrSZQ, {cContra,cDoc,AllTrim(aAux3[1]), Val(aAux3[2]), Date() } )
			Next nY
 		EndIf
    	
    	
    	aadd(aitens, alinha)
		
		// Se for individual ou selecionado, gera uma planilha para cada item no laço( uma planilha para cada agrupamento)
		// 
		// Se estiver errado, alterar a regra para gerar uma planilha um item para cada agrupamento
		If cTpCont == "1" .Or. cTpCont == "3"
			CNTA200(aCabec,aItens,3,.F.)
			aitens := {}
			alinha := {}
	
			If !lMsErroAuto
				DbSelectArea("CNB")
				DbSetOrder(1)	//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM 
				If DbSeek(xFilial("CNB")+cContra+space(3)+cDoc+StrZero(nX,3))	
					Reclock("CNB",.F.)  
					CNB->CNB_PRODUT		:=	'7000077'
					CNB->CNB_DESCRI		:=	'LOCAC MAQUINAS E EQUIPAMENTOS'
					CNB->CNB_UM			:=	'UN'
					CNB->CNB_QUANT		:=	aAux[nX,08]
					CNB->CNB_VLUNIT		:=	aAux[nX,10]
					CNB->CNB_VLTOT		:=	CNB->CNB_QUANT * CNB->CNB_VLUNIT
					CNB->CNB_DTANIV		:=	aAux[nX,07]
					CNB->CNB_SLDMED		:=	aAux[nX,08]
					CNB->CNB_SLDREC		:=	aAux[nX,08]           
				   //CNB->CNB_XPATRI		:=	aAux[nX,02]
					CNB->CNB_TS			:=	'900'
					MsUnLock()
					
					// Atualiza CNA
					UpdateCNA(cContra,CNB->CNB_NUMERO)
					
					// Grava na tabela dos patrimonios x contratos - SZQ - ACERTAR PARA GRAVAR O CLIENTE/LOJA
					If !IsInCallStack("U_TTCNTA15")
						For nX := 1 To Len(aPatrSZQ)
							cCodcli := Posicione("SN1",2,xFilial("SN1") +AvKey(aPatrSZQ[nX][3],"N1_CHAPA"), "N1_XCLIENT" )
							cLojaCli := Posicione("SN1",2,xFilial("SN1") +AvKey(aPatrSZQ[nX][3],"N1_CHAPA"), "N1_XLOJA" )
							U_TTCNTA14(1,aPatrSZQ[nX][1],aPatrSZQ[nX][2],aPatrSZQ[nX][3],aPatrSZQ[nX][4],aPatrSZQ[nX][5],cCodcli,cLojaCli)     
						Next nX
					EndIf	
				EndIf
			Else
				Mostraerro()	
			EndIf
		// Se for agrupado - salva somente uma vez
		ElseIf cTpCont == "2"
			CNTA200(aCabec,aItens,3,.F.)

			If !lMsErroAuto
				DbSelectArea("CNB")
				DbSetOrder(1)	//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM 
				If DbSeek(xFilial("CNB")+cContra+space(3)+cDoc+StrZero(nX,3))	
					Reclock("CNB",.F.)  
					
					CNB->CNB_PRODUT		:=	'7000077' //aAux[nX,03]
					CNB->CNB_DESCRI		:=	'LOCAC MAQUINAS E EQUIPAMENTOS'
					CNB->CNB_UM			:=	'UN'
					CNB->CNB_QUANT		:=	aAux[nX,08]
					CNB->CNB_VLUNIT		:=	nVlr
					CNB->CNB_VLTOT		:=	CNB->CNB_QUANT * CNB->CNB_VLUNIT
					CNB->CNB_DTANIV		:=	aAux[nX,07]
					CNB->CNB_SLDMED		:=	aAux[nX,08]
					CNB->CNB_SLDREC		:=	aAux[nX,08]           
					CNB->CNB_XPATRI		:=	cPatr
					CNB->CNB_TS			:=	'900'
					MsUnLock()
					
					// Atualiza CNA
					UpdateCNA(cContra,CNB->CNB_NUMERO)
					
					// Grava na tabela dos patrimonios x contratos - SZQ - ACERTAR PARA GRAVAR O CLIENTE/LOJA
					If !IsInCallStack("U_TTCNTA15")
						For nX := 1 To Len(aPatrSZQ)
							cCodcli := Posicione("SN1",2,xFilial("SN1") +AvKey(aPatrSZQ[nX][3],"N1_CHAPA"), "N1_XCLIENT" )
							cLojaCli := Posicione("SN1",2,xFilial("SN1") +AvKey(aPatrSZQ[nX][3],"N1_CHAPA"), "N1_XLOJA" )
							U_TTCNTA14(1,aPatrSZQ[nX][1],aPatrSZQ[nX][2],aPatrSZQ[nX][3],aPatrSZQ[nX][4],aPatrSZQ[nX][5],cCodcli,cLojaCli)     
						Next nX      
					EndIf
				EndIf
			Else
				Mostraerro()	
			EndIf		
			Exit // Sai do laço pois a geracao é feita uma unica vez com somente um item
		EndIf	
	Next nX
EndIf
		
Return


// Atualiza a tabela CNA
Static Function UpdateCNA(cCont,cPlan)

Local cQuery := ""

// Atualiza CNA
cQuery := "UPDATE "+RetSQLName("CNA")+" SET CNA_VLTOT=(SELECT SUM(CNB_VLTOT) FROM "+RetSQLName("CNB")+" WHERE CNB_CONTRA='"+If(Empty(cCont),CNA->CNA_CONTRA,cCont)+"' AND CNB_NUMERO='"+cPlan+"' AND D_E_L_E_T_='')
cQuery += ",CNA_SALDO=(SELECT SUM(CNB_VLTOT) FROM CNB010 WHERE CNB_CONTRA='"+If(Empty(cCont),CNA->CNA_CONTRA,cCont)+"' AND CNB_NUMERO='"+cPlan+"' AND D_E_L_E_T_='')
cQuery += ",CNA_VLCOMS=(SELECT SUM(CNB_VLTOT) FROM CNB010 WHERE CNB_CONTRA='"+If(Empty(cCont),CNA->CNA_CONTRA,cCont)+"' AND CNB_NUMERO='"+cPlan+"' AND D_E_L_E_T_='')
cQuery += " WHERE D_E_L_E_T_='' AND CNA_CONTRA='"+If(Empty(cCont),CNA->CNA_CONTRA,cCont)+"' AND CNA_NUMERO='"+cPlan+"'"
		
MemoWrite("UPDCNA.SQL",cQuery)
TcSqlExec(cQuery)             


Return