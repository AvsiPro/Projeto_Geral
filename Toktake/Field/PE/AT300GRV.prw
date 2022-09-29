#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAT300GRV  บAutor  ณJackson E. de Deus  บ Data ณ  18/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE Acionado apos a gravacao do chamado tecnico.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ07/05/14ณ01.01 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ19/05/14ณ01.02 |Inclusao da Transf. de Os Mobile		  ณฑฑ
ฑฑณJackson       ณ17/12/14ณ01.03 |Tratamento alt. sist. pagamento		  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AT300GRV()

Local aArea			:= GetArea()
Local cChamado		:= AB1->AB1_NRCHAM
Local cCliente		:= AB1->AB1_CODCLI
Local cLoja			:= AB1->AB1_LOJA
Local cContato		:= AB1->AB1_CONTAT
Local cAtendente	:= AllTrim(AB1->AB1_ATEND)
Local cEmissao		:= AB1->AB1_EMISSA
Local cHora			:= AB1->AB1_HORA
Local aItens		:= {}
Local cCodTec		:= ""
Local cNomeTec		:= ""
Local nTpserv		:= 7
Local nAgente		:= 0
Local cNumOS		:= ""
Local cMsgOS		:= ""
Local aDoc			:= {}
Local cRota			:= ""
Local aAux			:= {}
Local nREcSN1		:= 0
Local nPosFim		:= TamSX3("AB2_NUMOS")[1]
Local cProblema		:= ""
Local cOsFldAux		:= ""
Local cOSField		:= ""
Local cItem			:= ""
Local lAltTec		:= .F.
Local lTransf		:= .F.
Local cNumTMK		:= AB1->AB1_NUMTMK
Local cHoraAgen		:= "" 
Local cDtAgen       
Local cDadosCnt		:=	'' 
Local aRelacao		:=	{{'001',7},{'002',5},{'003',6},{'004',16},{'005',17}}
Local dDtOrig		:= stod("")
Local cHrIni		:= ""
Local nCont		 	:= 0 
Local lEdi1		 	:= .F.       
Local lNovoFrm		:= .F.
Local cLocal		:= ""
Local cEndCli		:= ""
Local cEndereco		:= ""
Local nI
Private nContOS		:= 0

If cEmpAnt == "10"
	Return
EndIf

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTTMKA31#U_TTGENC07"
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo

If (INCLUI .Or. ALTERA) .And. !lEdi1

	dbSelectArea("SA1")
	dbSetOrder(1)   
	If MsSeek( xFilial("SA1") +avKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA")  )
		cEndCli := AllTrim( SA1->A1_END ) +"," +AllTrim( SA1->A1_BAIRRO ) +"," +AllTrim( SA1->A1_MUN )  
	EndIf

	// Busca os itens do atendimento
	dbSelectArea("AB2")
	dbSetOrder(1)
	If dbSeek( xFilial("AB2") +AvKey(cChamado, "AB2_NRCHAM") )
		While AB2->AB2_FILIAL == AB1->AB1_FILIAL .And. AB2->AB2_NRCHAM == cChamado ;
	    				.And. AB2->AB2_CODCLI == cCliente .And. AB2->AB2_LOJA == cLoja .And. AB2->( !EOF() )
	    	lAltTec := .F.		
			cDescri := Posicione("SN1",1,xFilial("SN1") +AvKey(AB2->AB2_NUMSER,"N1_CHAPA"),"N1_DESCRIC")                                     
			dbSelectArea("AB2")
			nAgente++      
			If !TrocaTec(AB2->AB2_XOSMOB)
				lAltTec := .T.
			EndIf
    			
			AADD(aItens, { AllTrim(AB2->AB2_NUMSER),;						// [1] patrimonio
							AllTrim(MSMM(AB2->AB2_MEMO)),;					// [2] defeito apresentado	-> RETIRAR DEPOIS A DESCRICAO DA MAQUINA
							Recno(),; 										// [3] recno do registro do item do chamado - AB2
							AllTrim(AB2->AB2_XOSMOB),;						// [4] OS Mobile que sera gerada
							cDescri,;										// [5] descricao patrimonio
							AllTrim(AB2->AB2_NUMOS),;						// [6] numero OS Field
							0,;												// [7] recno do registro do item da OS - AB7
							lAltTec,;										// [8] transferencia de OS
							AB2->AB2_XTEC,;									// [9] tecnico do item do chamado.
							Posicione("AAG",1,xFilial("AAG")+AB2->AB2_CODPRB,"AAG_XCODOS"),;  // [10] codigo da os a ser gerada
							Posicione("AAG",1,xFilial("AAG")+AB2->AB2_CODPRB,"AAG_XPRAZO") }) //[11] SLA
			AB2->( dbSkip() ) 
		End
	EndIf
	
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCarrega a observacao do problema na Ordem de Servicoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/  
	For nI := 1 To Len(aItens)
		cProblema := aItens[nI][2]
		cOsFldAux := aItens[nI][6]
		
		cOSField := SubStr(cOsFldAux,1,nPosFim-2)
		cItem := SubStr(cOsFldAux,nPosFim-1)
		
		dbSelectArea("AB6")
		dbSetOrder(1)
		If dbSeek( xFilial("AB6") +AvKey( cOSField,"AB6_NUMOS") )
			dbSelectArea("AB7")
			dbSetOrder(1)	// filial + os + item
			If dbSeek( xFilial("AB7") +AvKey(cOSField,"AB7_NUMOS") +AvKey( cItem,"AB7_ITEM") )
				MSMM(AB7->AB7_MEMO1,,,,2)           
				MSMM(AB7->AB7_MEMO1,,,cProblema,1,,,"AB7","AB7_MEMO1")
				aItens[nI][7] := Recno()	// adiciona o recno do registro da OS para posterior gravacao da OS mobile
			EndIf	   
		EndIf
	Next nI
	             
	// Cria ou Transfere a OS Mobile
	For nI := 1 To Len(aItens)
		cLocal		:= ""
		cEndereco	:= ""
		aDoc := {}
		lOk := .F.
		lTransf	:= aItens[nI][8]
			
		// Se ja existir OS e nao for alteracao de tecnico, pula para o proximo
		If !Empty(aItens[nI][4]) .And. !lTransf
			Loop
		EndIf  
		
		// caso seja transferencia e a OS estiver cancelada, deve gerar uma nova
		If !Empty(aItens[nI][4]) .And. lTransf
			dbSelectArea("SZG")
			dbSetOrder(1)
			If dbSeek( xFilial("SZG") +AvKey( aItens[nI][4],"ZG_NUMOS") )
				If AllTrim(SZG->ZG_STATUS) $ "CTEC|COPE|CCLI"
					lTransf := .F.
				EndIf
			EndIf
		EndIf
		
		// Se OS esta vazio, deve gerar uma nova
		If Empty(aItens[nI][4])
			lTransf := .F.
		EndIf
		    
		//Agente por linha
		dbSelectArea("AA1")
		dbSetOrder(1)
		If dbSeek( xFilial("AA1") +AvKey(aItens[nI,09],"AA1_CODTEC") )
			cNomeTec := AllTrim(AA1->AA1_NOMTEC)
			cRota := AllTrim(AA1->AA1_LOCAL)
			
			If !Empty(AA1->AA1_PAGER)
				nAgente := Val(AA1->AA1_PAGER)			
			//novo app
			Else
				lNovoFrm := .T.
			EndIf
		EndIf
			
		If !lTransf
			//If lNovoFrm                            
				dbSelectArea("SN1")
				dbSetOrder(2)
				If MsSeek( xFilial("SN1") +AvKey(aItens[nI][1],"N1_CHAPA") )
					If !Empty(SN1->N1_XPA)
						dbSelectArea("ZZ1")
						dbSetOrder(1)
						If MsSeek( xFilial("ZZ1") +AvKey(SN1->N1_XPA,"ZZ1_COD") )
							cLocal := AllTrim(ZZ1->ZZ1_DESCRI)
							cEndereco := AllTrim(ZZ1->ZZ1_END) + "," +AllTrim(ZZ1->ZZ1_BAIRRO) + "," +AllTrim(ZZ1->ZZ1_MUN)
						EndIf
					Else             
						cEndereco := cEndCli
					EndIf
					
					cEndereco += CRLF +"Local Fํsico: " +AllTrim(SN1->N1_XLOCINS)					
				EndIf
			//EndIf
		
			AADD(aDoc, aItens[nI][1])	// patrimonio
			AADD(aDoc, cRota)			// rota 
			
			//If lNovoFrm
				AADD(aDoc, cLocal)			// local pa
				AADD(aDoc, cEndereco)		// endereco pa
				AADD(aDoc, aItens[nI][2])	// defeito apresentado
			//EndIf
			
			dbSelectArea("SUC")
			dbSetOrder(1)
			If dbSeek( xFilial("SUC") +AvKey(cNumTMK,"UC_CODIGO") )
				dDtOrig := SUC->UC_DATA
				cHrIni := SUC->UC_INICIO
				dbSelectArea("SU5")
				dbSetOrder(1)
				If Dbseek(xFilial("SU5")+SUC->UC_CODCONT)
					cDadosCnt := "Contatos do Reclamante - "
					cDadosCnt += Alltrim(SU5->U5_CONTAT)+" - "+Alltrim(SU5->U5_FONE)
					cDadosCnt += " " +Alltrim(SU5->U5_CELULAR) +" " +Alltrim(SU5->U5_FCOM1)
					cDadosCnt += " " +Alltrim(SU5->U5_FCOM2)+chr(13)+Chr(10)
					cDadosCnt += "Chamado Call Center "+cNumTMK +chr(13)+Chr(10)
				EndIf
			EndIf
			  
			cDtAgen := stod("")
			cHoraAgen := ""
			
			// calcula datahora do agendamento com base no SLA
			HoraFut( dDtOrig,cHrIni,Val(aItens[nI][11]),@cDtAgen,@cHoraAgen )
			
			If lNovoFrm
				cHoraAgen += ":00"
			EndIf
			          
			nTpServ := aRelacao[Ascan(aRelacao,{|x| x[1] == Alltrim(aItens[nI,10])}),02]
			AADD(aDoc, aItens[nI][2])	// defeito apresentado
			
	
			Processa( { || EnviaOS(@cNumOS,nTpServ,cCliente,cLoja,aDoc,nAgente,cHoraAgen,cDtAgen,cDadosCnt,lNovoFrm,AA1->AA1_CODTEC)  },"Gera็ใo de ordem de servi็o, aguarde..")
			
			If !Empty(cNumOS) 
				If Val(cNumOS) > 0   
				
					aItens[nI][4] := cNumOS
					                  
					// grava a OS mobile no chamado tecnico
					dbSelectArea("AB2")
					dbGoto(aItens[nI][3])
					If AB2->AB2_XOSMOB <> cNumOS
						If RecLock("AB2",.F.)
							AB2->AB2_XOSMOB := cNumOS
							AB2->( MsUnLock() )
						EndIf                       
					EndIf
					                                  
					// grava a OS mobile na OS Field Service
					dbSelectArea("AB7")
					dbGoto(aItens[nI][7])
					If AB7->AB7_XOSMOB <> cNumOS
						If RecLock("AB7",.F.)
							AB7->AB7_XOSMOB := cNumOS					
							AB7->( MsUnLock() )
						EndIf
					EndIf 
					
					nContOs++
				EndIf
			EndIf
		Else
			Processa( { || TransfOS(@lOk,aItens[nI][4],nAgente,lNovoFrm,AA1->AA1_CODTEC)  },"Transfer๊ncia de ordem de servi็o, aguarde.." )
			If lOk
				aItens[nI][8] := .T.
				nContOS++
			EndIf
		EndIf	
	Next nI
	
	If nContOS > 0
		cMsgOS := "Ordem de servi็o m๓vel" +CRLF 
		cMsgOS += "T้cnico: " +cNomeTec +CRLF
		For nI := 1 to Len(aItens)
			cMsgOS += AllTrim(aItens[nI][1]) + " - " +aItens[nI][5]  +" / " +"OS -> " +aItens[nI][4] +CRLF
		Next nI
		Aviso("AT300GRV",cMsgOS,{"Ok"},3)
	EndIf
	
	// envia o email para o operador
	If FindFunction("U_TTMAILN")
		EnviaEmail(cChamado,cEmissao,cHora,cCliente,cLoja,cContato,cAtendente,aItens,cNomeTec,cDadosCnt)
	EndIf
EndIf	
	
MsUnLockAll()

RestArea(aArea)

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaOS  บAutor  ณJackson E. de Deus   บ Data ณ  10/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a ordem de servico no sistema Equipe Remota            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaOS(cNumOs,nTpServ,cCliente,cLoja,aDoc,nAgente,cHoraAgen,cDtAten,cDadosCnt,lNovoFrm,cCodTec)
                   
Local aDadosOS := {}
Local aSisPg := {}
Local cForm := ""
Local cDescFrm := ""
Local cLocal := ""
Local cTroco := ""
procregua(2)



// desconsiderar se for instalacao/remocao
If nTpServ == 16 .Or. nTpServ == 17 .And. !FwIsInCallStack("U_TTGENC07")
	MsgAlert("Ordem de Servi็o de Instala็ใo ou Remo็ใo s๓ deve ser criada via OMM.")
	Return
EndIf



                  
If nTpServ == 5 //14
	aSisPg := SisPgto()
EndIf

IncProc("Gerando ordem de servi็o..")

If !lNovoFrm		
	//cNumOS := U_WSKPF009(nTpServ,cCliente,cLoja,aDoc,nAgente,cHoraAgen,,cDtAten,cDadosCnt,aSisPg)
Else
	// montar aqui aDadosOS // cCodTec
	If nTpServ == 6 .Or. nTpServ == 5
		cForm := "06"
		cDescFrm := "MANUTENCAO"
	ElseIf nTpServ == 16
		cForm := "16"
		cDescFrm := "INSTALACAO DE MAQUINA"
	ElseIf nTpServ == 17
		cForm := "17"                     
		cDescFrm := "REMOCAO DE MAQUINA"
	EndIf
	
	If nTpServ == 5 .And. !Empty(aSisPg)
		If Upper(aSisPg[1][2]) == "SIM" 	//pos
			cDadosCnt += "Incluir sistema de pagamento POS"
		EndIf
		
		If Upper(aSisPg[2][2]) == "SIM"	// smart
			cDadosCnt += "Incluir sistema de pagamento SMART"
		EndIf   
		
		If Upper(aSisPg[3][2]) == "SIM"  	// cedula
			cDadosCnt += "Incluir sistema de pagamento CEDULA"
		EndIf 
		
		If Upper(aSisPg[4][2]) == "SIM"	// moedeiro
			cDadosCnt += "Incluir sistema de pagamento MOEDEIRO"
		EndIf
		
		// troco moedeiro
		If Upper(aSisPg[4][2]) == "SIM"
			cTroco := "MC=SIM"
		EndIf
	EndIf
	
	
	aDadosOS := { cForm,;
				cDescFrm,;
				cCodTec,;
				AllTrim(AA1->AA1_NOMTEC),;
				AllTrim(aDoc[1]),;
				Posicione("SN1",2,xFilial("SN1")+AvKey(aDoc[1],"N1_CHAPA"),"N1_DESCRIC" ) ,;
				"",;
				"",;
				cDtAten,;
				cHoraAgen,;
				Posicione("SA1",1,xFilial("SA1")+AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA") ,"A1_NREDUZ"),;
				aDoc[4],;
				"",;
				AllTrim(aDoc[5]) +CRLF +AllTrim(cDadosCnt),;
				"",;
				aDoc[3],;
				"",;
				"",;
				"",;
				cCliente,;
				cLoja,;
				{},;
				"" }
	
	cNumOS := U_MOBILE(aDadosOS)
	If !Empty(cNumOS) .And. !Empty(cTroco)
		dbSelectArea("SZG")
		dbSetOrder(1)
		If MsSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
			RecLock("SZG",.F.)
			SZG->ZG_OBSRET := cTroco
			MsUnlock()
		EndIf
	EndIf
EndIf

If !Empty(cNumOS)
	If Val(cNumOS) > 0
		IncProc("Ordem de servico gerada: " +cNumOS)
	Else
		IncProc("Houve erro ao gerar a ordem de servi็o")	
	EndIf
Else
	IncProc("Houve erro ao gerar a ordem de servi็o")	
EndIf

Return
     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTransfOS  บAutor  ณJackson E. de Deus  บ Data ณ  13/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTransfere a OS para outro Tecnico/Agente                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TransfOS(lOk,cNumOS,nAgente,lNovoFrm,cCodTec)                                                                                                             

procregua(1)

IncProc("Transferindo Ordem de Servi็o..")


lOk := STATICCALL( TTPROC30, PrcTnsf2, cNumOs,cCodTec )


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaEmail  บAutor  ณJackson E. de Deusบ Data ณ  11/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia email para o operador                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaEmail(cChamado,cEmissao,cHora,cCliente,cLoja,cContato,cAtendente,aItens,cNomeTec,cDadosCnt)

Local cDestino	:= 	UsrRetMail(__cUserID)
Local cAssunto	:= IIF(INCLUI.Or.ALTERA, IIF(INCLUI,"Abertura de Chamado T้cnico - nบ " +cChamado, "Altera็ใo de Chamado T้cnico - nบ " +cChamado ) ,  )                       
Local cHtml		:= ""
Local nI		:= 0
Local cNomeFant	:= ""
Local cEndereco := ""
Local cBairro	:= ""
Local cCidade	:= ""
Local cUF		:= ""
Local cTelefone	:= ""

  
cNomeFant := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja,"A1_NREDUZ" ) 
cEndereco := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja,"A1_END" ) 
cBairro := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja,"A1_BAIRRO" ) 
cCidade := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja,"A1_MUN" ) 
cUF := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja,"A1_EST" ) 
cTelefone := Posicione("SA1",1,xFilial("SA1") +cCliente+cLoja,"A1_TEL" ) 
    

cHtml := "<html>"
cHtml += "<head>"
cHtml += "<title>" +cAssunto +"</title>"
	
// Estilos 
cHtml += "<style type='text/css'>"
cHtml += "	table.bordasimples {border-collapse: collapse;}"
cHtml += "	table.bordasimples tr td {border:1px solid #BC8F8F;}"
cHtml += "	body { background-color: #FFFFFF;"
cHtml += "	color: #5D665B; "
cHtml += "	margin: 50px;"
cHtml += "	font-family: Times New Roman, Times, serif;"
cHtml += "	font-size: small;"
cHtml += " 	}"
cHtml += "</style>"
    
cHtml += "</head>"

// Corpo
cHtml += "<body>"
cHtml += "<p><strong>Chamado T้cnico nบ " +cChamado  +"</strong></p>"
cHtml += "<p>Cliente: "						+cCliente +"/" +cLoja +"</p>"
cHtml += "<p>Nome fantasia: "				+cNomeFant +"</p>"

cHtml += "<p>Endere็o: "					+cEndereco
If !Empty(cBairro)
	cHtml += ", " +cBairro
EndIf                     

If !Empty(cCidade)
	cHtml += ", " +cCidade
EndIf           

If !Empty(cUF)
	cHtml += ", " +cUF
EndIf 

cHtml += "</p>"          

cHtml += "<p>Telefone: " +cTelefone +"</p>"
cHtml += "<p>Contato: "	 +cDadosCnt +"</p>"
cHtml += "<p>T้cnico: "	 +cNomeTec +"</p>"
cHtml += "<p>Atendente: " +cAtendente +"</p>"
cHtml += "<p>Emissใo: "	+Dtoc(cEmissao) +"</p>"
cHtml += "<p>Hora: " +cHora +"</p>"
                                  
cHtml += "<p>&nbsp;</p>"


If nContOS > 0
	cHtml += "<p><strong>Ordens de Servi็o geradas para o sistema mobile:</strong></p>"
EndIf

// Os geradas			
For nI := 1 To Len(aItens) 	
 	If !Empty(aItens[nI][4])
 		cHtml += "<p>N๚mero da OS: " +aItens[nI][4] +"</p>"
 	EndIf	
 	
	cHtml += "<p>Patrim๔nio: " +aItens[nI][1] +" - " +aItens[nI][5] +"</p>"
	cHtml += "<p>Problema: " +aItens[nI][2] +"</p>"
	
	If aItens[nI][8]
		cHtml += "<p>Obs: Transferida entre t้cnicos.</p>"
	EndIf
	
	cHtml += "<p>" +Replicate("_",100) +"</p>"
Next nI

cHtml += "<p>&nbsp;</p>"
	
cHtml += "<p>E-mail automแtico enviado via protheus.</p>"
cHtml += "<p>Favor nใo responder.</p>"
cHtml += "</body>"
cHtml += "</html>
      
U_TTMailN("microsiga",cDestino,cAssunto,cHtml,{},.F.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAT300GRV  บAutor  ณMicrosiga           บ Data ณ  09/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TrocaTec(cNumOs)

Local aArea	:=	GetArea()
Local cQuery                           
Local lRet	:=	.T.

cQuery := "SELECT ZG_CODTEC,AB2_XTEC FROM "+RetSQLName("SZG")+" ZG"
cQuery += " INNER JOIN "+RetSQLName("AB2")+" AB2 ON AB2_XOSMOB=ZG_NUMOS AND AB2.D_E_L_E_T_=''"
cQuery += " WHERE ZG_NUMOS='"+cNumOs+"' AND ZG.D_E_L_E_T_=''"      

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("AT300GRV.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

If TRB->ZG_CODTEC != TRB->AB2_XTEC
	lRet := .F.
EndIf

RestArea(aArea)

Return(lRet)               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAT300GRV  บAutor  ณMicrosiga           บ Data ณ  11/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Sistema de pagamento a ser adicionado na maquina          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SisPgto()

Local oDlg1,oGrp1,oCBox1,oCBox2,oCBox3,oCBox4,oSBtn1 
Local aRet := {{"POS",'Nao'},{"Smart",'Nao'},{"Cedula",'Nao'},{"Moedeiro",'Nao'},{"Troco_Moedeiro",""}}
Local lCheck1 := .F.
Local lCheck2 := .F.
Local lCheck3 := .F.
Local lCheck4 := .F.
Local nTroco := 2

oDlg1      := MSDialog():New( 091,232,326,484,"Inclusใo de Sist. de Pagto",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,092,116,"Informe o Sist. Pagto a adicionar",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCBox1     := TCheckBox():New( 024,036,"POS",{|u|If(Pcount()>0,lCheck1:=u,lCheck1)},oGrp1,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox2     := TCheckBox():New( 040,036,"Smart",{|u|If(Pcount()>0,lCheck2:=u,lCheck2)},oGrp1,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox3     := TCheckBox():New( 056,036,"Cedula",{|u|If(Pcount()>0,lCheck3:=u,lCheck3)},oGrp1,060,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBox4     := TCheckBox():New( 072,036,"Moedeiro",{|u|If(Pcount()>0,lCheck4:=u,lCheck4)},oGrp1,060,008,,{ || IF(lCheck4,nTroco:=Aviso("Tipo do moedeiro","Moedeiro com troco?",{"Sim","Nao"}),nTroco:=2)},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oSBtn1     := SButton():New( 096,048,1,{||oDlg1:end()},oDlg1,,"OK", )

oDlg1:Activate(,,,.T.)

If lCheck1
	aRet[1,2] := 'Sim'
EndIf

If lCheck2
	aRet[2,2] := 'Sim'
EndIf   

If lCheck3
	aRet[3,2] := 'Sim'  
	//aRet[6,2] := 'Sim'
EndIf 

If lCheck4
	aRet[4,2] := 'Sim'
	//aRet[5,2] := 'Sim'
	If nTroco == 1
		aRet[5,2] := 'Sim'
	ElseIf nTroco == 2
		aRet[5,2] := 'Nao'
	EndIf
EndIf

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHoraFut  บAutor  ณJackson E. de Deus   บ Data ณ  17/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula a datahora de agendamento com base no SLA          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function HoraFut(dDtIni,cHrIni,nSomaHs,dDtFim,cHrFim)

Local nDias := 0
Local nPrazo := 0
Local nHora := horatoint(cHrIni)
Local dDia := dDtIni
Local nHrAx := 0


/*
// calculo simples cheio
nSomaHs  += HoraToInt(cHora)
nDias    := Int(nSomaHs/24)
dDtFim   += nDias
cHrFim   := IntToHora(nSomaHs-(nDias*24))
*/


// nova regra - desconsiderar sabado/domingo/feriado
While nPrazo < nSomaHs
	dDia := DataValida(dDia,.T.)
	
	nHrAx := SomaHoras(nHora,"01:00")
	
	If Int(nHrAx) == 24
		dDia++
		nHora := nHrAx-24
	Else
		nHora++	
	EndIf

	nPrazo++
End

dDtFim := dDia
cHrFim := IntToHora(nHora)

Return 