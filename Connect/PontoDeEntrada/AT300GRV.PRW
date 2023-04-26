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
Local lChamados		:=	SUPERGETMV( "CN_CHGOON", .F., .F. )

__cErroA := ''

While ( !Empty(ProcName(ni)) )
	__cErroA +=	Trim(ProcName(ni)) +"(" + Alltrim(Str(ProcLine(ni))) + ") " + CRLF
	ni++
End

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
				
				lAltTec := .F.		

				cDescri := Posicione("SN1",1,xFilial("SN1") +AvKey(AB2->AB2_NUMSER,"N1_CHAPA"),"N1_DESCRIC")                                     
				dbSelectArea("AB2")
					
				AADD(aItens, { AllTrim(AB2->AB2_NUMSER),;						// [1] patrimonio
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
								AB2->AB2_NRCHAM,;
								AB2->AB2_ITEM,;
								AB2->AB2_CODPRO,;
								AB2->AB2_NUMSER,;
								'',;
								POSICIONE("AAG",1,XFILIAL("AAG")+AB2->AB2_CODPRB,"AAG_XFORGO")})

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
				AADD(aDoc, cEndCli)		    // endereco pa
				AADD(aDoc, aItens[nI][2])	// defeito apresentado

				cHoraAgen := cvaltochar(time())
				cDtAgen   := ddatabase

				Processa( { || aItens[nI,16] := EnviaOS(cNumOS,VAL(aItens[nI,17]),cCliente,cLoja,aDoc,nAgente,cHoraAgen,cDtAgen,AA1->AA1_CODTEC,cContato,aItens[nI,17])  },"Geração de ordem de serviço, aguarde..")
				
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


Static Function EnviaOS(cNumOs,nTpServ,cCliente,cLoja,aDoc,nAgente,cHoraAgen,cDtAten,cCodTec,cContato,cForm)
                   
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
				Posicione("SN1",2,xFilial("SN1")+AvKey(aDoc[1],"N1_CHAPA"),"N1_DESCRIC" ) ,;
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
				"" }

cNumOs := U_CONWSC04(nTpServ,cCliente,cLoja,aDadosOS,nAgente,cHoraAgen,.F.,cDtAgen,'','','',cContato,'','','')

RestArea(aArea)

Return(cNumOs)
