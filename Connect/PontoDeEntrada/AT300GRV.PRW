#include "protheus.ch"

User Function AT300GRV()

Local aArea			:= GetArea()
Local cChamado		:= AB1->AB1_NRCHAM
Local cCliente		:= AB1->AB1_CODCLI
Local cLoja			:= AB1->AB1_LOJA
Local cContato		:= AB1->AB1_CONTAT
Local nI			:= 0
Local aItens        := {}
Local nPosFim		:= TamSX3("AB2_NUMOS")[1]
Local aDoc          :=  {}
Local cLocal
Local cNumOS
Local nTpServ       :=  25
Local cCbase		:=	""
Local lChamados		:=	SUPERGETMV( "CN_CHGOON", .F., .F. )
Local nAgente		:=	0
Local cPntVnd		:=	''

If lChamados
	If (INCLUI .Or. ALTERA)

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
				
				If !Empty(AB2->AB2_XTEC)
					lAltTec := .F.		

					//cDescri := Posicione("SN1",1,xFilial("SN1") +AvKey(AB2->AB2_NUMSER,"N1_CHAPA"),"N1_DESCRIC")
					cCbase := Posicione("AA3",6,xFilial("AA3")+AB2->AB2_NUMSER,"AA3_CBASE")
					DbSelectArea("SN1")
					DbSetOrder(1)
					DbSeek(xFilial("SN1")+cCbase)
					cDescri := SN1->N1_DESCRIC
					cPntVnd := SN1->N1_XPTVEND

					If !Empty(cPntVnd)
						DBSelectArea("NNR")
						DbSetOrder(1)
						DbSeek(xFilial("NNR")+cPntVnd)

						cPntVnd := Alltrim(cPntVnd)+" - "+Alltrim(NNR->NNR_DESCRI)
						If !Empty(NNR->NNR_XEND)
							cPntVnd += " / " + Alltrim(NNR->NNR_XEND) + " - " + Alltrim(NNR->NNR_XBAIRR)+" - "+Alltrim(NNR->NNR_XMUN)
						EndIf
					EndIf

					dbSelectArea("AB2")
						
					AADD(aItens, { AllTrim(cCbase),;								// [1] patrimonio - AB2->AB2_NUMSER
									AllTrim(MSMM(AB2->AB2_MEMO)),;					// [2] defeito apresentado	-> RETIRAR DEPOIS A DESCRICAO DA MAQUINA
									Recno(),; 										// [3] recno do registro do item do chamado - AB2
									"",;                    						// [4] OS Mobile que sera gerada
									cDescri,;										// [5] descricao patrimonio
									AllTrim(AB2->AB2_NUMOS),;						// [6] numero OS Field
									0,;												// [7] recno do registro do item da OS - AB7
									lAltTec,;										// [8] transferencia de OS
									AB2->AB2_XTEC,;									// [9] tecnico do item do chamado.
									"",;                                            // [10] codigo da os a ser gerada
									"",;                                            //[11] SLA
									AB2->AB2_NRCHAM,;								//[12]
									AB2->AB2_ITEM,;									//[13]
									AB2->AB2_CODPRO,;								//[14]
									AB2->AB2_NUMSER,;								//[15]
									'',;											//[16]
									POSICIONE("AAG",1,XFILIAL("AAG")+AB2->AB2_CODPRB,"AAG_XFORGO"),;	//[17]
									cPntVnd})										//[18]
				EndIf
				AB2->( dbSkip() ) 
			End
		EndIf


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
		

			dbSelectArea("AA1")
			dbSetOrder(1)
			If dbSeek( xFilial("AA1") +AvKey(aItens[nI,09],"AA1_CODTEC") )
				cNomeTec := AllTrim(AA1->AA1_NOMTEC)
				cRota := AllTrim(AA1->AA1_LOCAL)
				
				If !Empty(AA1->AA1_PAGER)
					nAgente := Val(AA1->AA1_PAGER)			
				EndIf
			EndIf

			If nAgente > 0
				AADD(aDoc, aItens[nI][1])	// patrimonio
				AADD(aDoc, cRota)			// rota 
				
				AADD(aDoc, cLocal)			// local pa
				AADD(aDoc, aItens[nI][18])		    // endereco pa
				AADD(aDoc, aItens[nI][02])	// defeito apresentado

				cHoraAgen := cvaltochar(time())
				cDtAgen   := ddatabase

				Processa( { || aItens[nI,16] := EnviaOS(cNumOS,VAL(aItens[nI,17]),cCliente,cLoja,aDoc,nAgente,cHoraAgen,cDtAgen,AA1->AA1_CODTEC,cContato,aItens[nI,17],aItens[nI,05])  },"Gera��o de ordem de servi�o, aguarde..")
				
			endif
		Next nI

	EndIF

	For nI := 1 to len(aItens)
		DbSelectArea("AB2")
		DbSetOrder(1)
		If Dbseek(xFilial("AB2")+aItens[nI,12]+aItens[nI,13]+aItens[nI,14]+aItens[nI,15])
			Reclock("AB2",.F.)
			AB2->AB2_XOS := cvaltochar(aItens[nI,16])
			AB2->(Msunlock())
		EndIf 
	Next nI
EndIF

RestArea(aArea)

Return


Static Function EnviaOS(cNumOs,nTpServ,cCliente,cLoja,aDoc,nAgente,cHoraAgen,cDtAten,cCodTec,cContato,cForm,cDesAtv)
                   
Local aArea     :=  Getarea()
Local aDadosOS  := {}
Local cDescFrm  := ""

Default cForm     := ""

cDescFrm := "CHAMADO TECNICO"

aDadosOS := {   Alltrim(cForm),;
				cDescFrm,;
				cCodTec,;
				AllTrim(AA1->AA1_NOMTEC),;
				AllTrim(aDoc[1]),;
				cDesAtv ,;
				"",;
				"",;
				cDtAten,;
				cHoraAgen,;
				Posicione("SA1",1,xFilial("SA1")+AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA") ,"A1_NREDUZ"),;
				aDoc[4],;
				"",;
				AllTrim(aDoc[5]),;
				"",;
				aDoc[3],;
				"",;
				"",;
				"",;
				cCliente,;
				cLoja,;
				{},;
				"" ,;
				aDoc[4]}

cNumOs := U_CONWSC04(nTpServ,cCliente,cLoja,aDadosOS,nAgente,cHoraAgen,.F.,cDtAgen,'','','',cContato,'','','')

RestArea(aArea)

Return(cNumOs)
