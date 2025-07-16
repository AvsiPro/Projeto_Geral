#include "PROTHEUS.CH"

/*/{Protheus.doc} CIFINJ01
	Comunicacao Bancaria - Retorno
	@type function
	@author Fabrica
	@since 05/2025
	@param cAlias, character, param_description
	@return logical, return_description
/*/

/*-------------------------------------------------------*/
/*                 Atualizacoes                          */
/*                                                       */
/* ZPZ_STATUS : X - TITULO NAO ENCONTRADO                */
/*              B - TITULO ENCONTRADO E ESTA BAIXADO     */
/*              '' - TITULO ENCONTRADO E SERA PROCESSADO */
/*              E - Erro na baixa                        */
/*-------------------------------------------------------*/


User Function CIFINJ01()

	Local nF
	Local cPasta   := "/nexxera/download/BAIXA_PAGAR/
	Local cPathBkp := "/Nexxera/DOWNLOAD/BAIXA_PAGAR_PROCESSADOS/"


	Private lExecJob := .T. //ExecSchedule()
	Private cArquivo := ""
	Private cArqConf := ""
	
	Default cEmpJob := '01'
	Default cFilJob := '01'

	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(cEmpJob, cFilJob)

	Conout("[CIFINJ01] - Iniciando Execucao " + cEmpJob + "/ " + cFilJob + "")

	aArquivos := Directory( cPasta + "Pag*.ret" )

	For nF := 1 To Len( aArquivos )

		cArquivo := cPasta + aArquivos[ nF , 1 ]
		cArqConf := "bradesco.2pr"

		//Conout("[CIFINJ01] - Arquivo: " + cArquivo)

		LerCnab("SE2")

		//copia o arquivo para o diretorio de backup
		If _CopyFile(cPasta + aArquivos[ nF , 1 ], cPathBkp + aArquivos[ nF , 1 ] ) 
			// Exclui o arquivo processado.
			If FErase(cPasta + aArquivos[ nF , 1 ]) < 0
				//Conout("Não foi possível excluir o arquivo" + cPasta + aArquivos[ nF , 1 ])
				//Conout("fErase: Erro " + cValToChar(FError())) 
			EndIf
		EndIf
	
	Next nF
Return


/*/{Protheus.doc} LerCnab
	Comunicacao Bancaria - Retorno
	@type function
	@author Fabrica
	@since 05/2025
	@param cAlias, character, param_description
	@return logical, return_description
/*/
Static Function LerCnab(cAlias as Character) as Logical

	Local cRejeicao     as Character
	Local cChave430     as Character
	Local cNumSe2       as Character
	Local cChaveSe2     as Character
	Local cArqEnt       as Character
	Local cPadrao       as Character
	Local cFilOrig      as Character
	Local xBuffer       as Variant
	Local lMovAdto      as Logical
	Local lHeader       as Logical
	Local lRet          as Logical
	Local nLidos        as Numeric
	Local nPos          as Numeric
	Local nPosEsp       as Numeric
	Local nBloco        as Numeric
	Local nSavRecno     as Numeric
	Local nTamForn      as Numeric
	Local nTamOcor      as Numeric
	Local nTamEEOcor    as Numeric
	Local aTabela       as Array
	Local aLeitura      as Array
	Local aValores      as Array
	Local dDebito       as Date
	Local nTamPre       as Numeric
	Local nTamNum       as Numeric
	Local nTamPar       as Numeric
	Local nTamTit       as Numeric
	Local lAchouTit     as Logical
	Local lAchouSEA     as Logical
	Local nTamBco       as Numeric
	Local nTamAge       as Numeric
	Local nTamCta       as Numeric
	Local lOk           as Logical
	Local aArqConf      as Array // Atributos do arquivo de configuracao
	Local lCtbExcl      as Logical
	Local aDtMvFinOk    as Array //Array para as datas de baixa válidas
	Local aDtMvFinNt    as Array //Array para as datas de baixa inconsistentes com o parâmetro MV_DATAFIN

	//DDA - Debito Direto Autorizado
	Local lUsaDDA       as Logical
	Local lProcDDA      as Logical

	//Reestruturacao SE5
	Local cLog          as Character
	Local cBcoOfi       as Character
	Local cAgeOfi       as Character
	Local cCtaOfi       as Character
	Local cLocRec       as Character
	Local cCGCFilHeader as Character
	Local nMoeda        as Numeric
	Local nTxMoeda      as Numeric
	Local lPagAnt       as Logical
	Local nLinhas       as Numeric
	Local lArqErro      as Logical
	Local nRecnoSE2     as Numeric
	Local nEstOrig      as Numeric
	Local lOkSEB        as Logical
	Local nTamIdCNAB    as Numeric
	Local lPermBx		as Logical
	Local nX			as Logical
	Local cTab          := ""

	cRejeicao     := ""
	cChave430     := ""
	cNumSe2       := ""
	cChaveSe2     := ""
	cArqEnt       := ""
	cPadrao       := ""
	cFilOrig      := cFilAnt // Salva a filial para garantir que nao seja alterada em customizacao
	lHeader       := .F.
	lPermBx		  := .T.
	lRet          := .T.
	nLidos        := 0
	nPos          := 0
	nPosEsp       := 0
	nBloco        := 0
	nSavRecno     := Recno()
	nTamForn      := Tamsx3("E2_FORNECE")[1]
	nTamOcor      := TamSx3("EB_REFBAN")[1]
	nTamEEOcor    := 2
	aTabela       := {}
	aLeitura      := {}
	aValores      := {}
	nTamPre       := TamSX3("E1_PREFIXO")[1]
	nTamNum       := TamSX3("E1_NUM")[1]
	nTamPar       := TamSX3("E1_PARCELA")[1]
	nTamTit       := nTamPre + nTamNum + nTamPar
	lAchouTit     := .F.
	lAchouSEA     := .F.
	nTamBco       := Tamsx3("A6_COD")[1]
	nTamAge       := TamSx3("A6_AGENCIA")[1]
	nTamCta       := Tamsx3("A6_NUMCON")[1]

	
	lOk           := .F. //Controla se foi confirmada a distribuicao

	aArqConf      := {} // Atributos do arquivo de configuracao
	lCtbExcl      := !Empty( xFilial("CT2") )

	aDtMvFinOk    := {} //Array para as datas de baixa válidas
	aDtMvFinNt    := {} //Array para as datas de baixa inconsistentes com o parâmetro MV_DATAFIN

	//DDA - Debito Direto Autorizado
	lUsaDDA       := FDDAInUse()
	lProcDDA      := .F.


	cLog          := ""
	cBcoOfi       := ""
	cAgeOfi       := ""
	cCtaOfi       := ""
	cLocRec       := SuperGetMV( "MV_LOCREC" , .F. , .F. )
	cCGCFilHeader := ""
	nMoeda        := 0
	nTxMoeda      := 0
	lPagAnt       := .F.
	nLinhas       := 0
	lArqErro      := .F.
	nRecnoSE2     := 0
	nEstOrig      := 0
	lOkSEB        := .T.
	nTamIdCNAB    := TamSX3("E2_IDCNAB")[1]

	Private cBanco        as Character
	Private cAgencia      as Character
	Private cConta        as Character
	Private cHist070      as Character
	
	Private lAut          as Logical
	Private nTotAbat      as Numeric
	Private cCheque       as Character
	Private cPortado      as Character
	Private lAdiantamento as Logical
	Private cNumBor       as Character
	Private cForne        as Character
	Private cCgc          as Character
	Private cDebito       as Character
	Private cModSpb       as Character
	Private cAutentica    as Character
	Private cLote         as Character
	Private cBenef        as Character
	Private nMoedaBco     as Numeric
	Private nVA           as Numeric

	lAut          := .F.
	nTotAbat      := 0
	cCheque       := " "
	cPortado      := " "
	lAdiantamento := .F.
	cNumBor       := " "
	cForne        := " "
	cCgc          := ""
	cDebito       := ""
	cModSpb       := "1"
	cAutentica    := Space(25)
	cLote         := Space(TamSX3("EE_LOTECP")[1])
	cBenef        := ""
	nMoedaBco     := 0
	nVA           := 0

	If Type("aMsgSch") == "U"
		Private aMsgSch := {}
	Endif
	
	nBloco := 242

	lRet := .T.
	If lRet
		//Verifica o numero do Lote
		LoteCont("FIN")

		//Abre arquivo de configuracao
		If !(File(cArqConf))
			if ! lExecJob
				Help(" ",1,"NOARQPAR")
			Else
				//Conout("Arquivo de configuracao "+cArqConf+" nao localizado.") 
				Aadd(aMsgSch, "Arquivo de configuracao "+cArqConf+" nao localizado.") 
			Endif
			//Atualiza o log de processamento com o erro
			ProcLogAtu("ERRO","NOARQPAR",Ap5GetHelp("NOARQPAR"))

			lRet:= .F.
		EndIf
	EndIf
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		//MV_LOCREC  -Parâmetro onde será gravado o diretório.
		If (lExecJob .Or. (Empty(cLocRec) .And. !lExecJob))
			cArqEnt := cArquivo
			//Conout("[CIFINJ01] - Arquivo: " + cArquivo)
			//Conout("[CIFINJ01] - ArqEnt: " + cArqEnt)
		Else
			//Verifica qual barra está o parâmetro , e o que está na ultima posição através do RAT
			If AT("\",alltrim(cLocRec))>0 .and. RAT("\",SUBSTR(alltrim(cLocRec),LEN(alltrim(cLocRec)),1)) = 0
				cArqEnt := cLocRec+"\"+TRIM(cArquivo)
			ElseIf AT("\",alltrim(cLocRec))>0 .and. RAT("\",SUBSTR(alltrim(cLocRec),LEN(alltrim(cLocRec)),1)) > 0
				cArqEnt := cLocRec+TRIM(cArquivo)
			ElseIf AT("/",alltrim(cLocRec))>0 .and. RAT("/",SUBSTR(alltrim(cLocRec),LEN(alltrim(cLocRec)),1)) > 0
				cArqEnt  := SuperGetMV( "MV_LOCREC" , .F. , .F. )+TRIM(cArquivo)
			ElseIf AT("/",alltrim(cLocRec))>0 .and. RAT("/",SUBSTR(alltrim(cLocRec),LEN(alltrim(cLocRec)),1)) = 0
				cArqEnt := cLocRec+"/"+TRIM(cArquivo)
			Endif
		Endif

		//Validar as Inconsistências
		If !Empty(cLocRec) .and. (Empty(cArquivo) .or. AT(":",cArquivo)>0 .or. (AT("/",cArquivo)>0 .or. AT("\",cArquivo)>0))
			Help(" ",1,"F150ARQ",,"Nome do Arquivo de Saida Inválido",1,0) 
			Return .F.
		Endif
			//Conout("[CIFINJ01] - Arquivo 2: " + cArquivo)
			//Conout("[CIFINJ01] - ArqEnt 2: " + cArqEnt)
		If !FILE(cArqEnt)
			If !lExecJob
				Help(" ",1,"NOARQENT")
			Else
				Aadd(aMsgSch, "Arquivo de entrada "+cArqEnt+" nao localizado.")
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento com o erro  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcLogAtu("ERRO","NOARQENT",Ap5GetHelp("NOARQENT"))

			lRet:= .F.
		Else
			nHdlBco:=FOPEN(cArqEnt,0+64)
		EndIF
	EndIf

	//Conout("[CIFINJ01] - lRet: " + cValToChar(lRet))

	If lRet
		//Lê arquivo enviado pelo banco
		nLidos:=0
		FSEEK(nHdlBco,0,0)
		nTamArq:=FSEEK(nHdlBco,0,2)
		FSEEK(nHdlBco,0,0)

		// Validação de Integridade do Arquivo de Retorno
		nLinhas := nTamArq/nBloco
		lArqErro := (nLinhas - Int(nLinhas)) <> 0 // Arquivo Corrompido

		If lArqErro
			lRet := .F.

		EndIf
	EndIf

	cTabela := "17"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a tabela existe           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aContSX5 := FWGetSX5(cTabela)

	For nX := 1 to Len(aContSX5)
		AADD(aTabela,{Alltrim(aContSX5[nX][4]),PadR(AllTrim(aContSX5[nX][3]),3)})
	Next nX

	//Conout("[CIFINJ01] - lRet2: " + cValToChar(lRet))
	If lRet

		aArqConf := Directory(cArqConf)

		Begin Transaction
			SEB->(dbSetOrder(1))

			While nLidos <= nTamArq
				IncProc()
				nDespes    :=0
				nDescont   :=0
				nAbatim    :=0
				nValRec    :=0
				nJuros     :=0
				nMulta     :=0
				nValCc     :=0
				nValPgto   :=0
				nMoeda	   :=0
				nTxMoeda   :=0
				nCM        :=0
				ABATIMENTO := 0
				lPagAnt	   := .F.
				lProcDDA   := .F.
				cFilAnt    := cFilOrig
				lPosSE2    := .F.
				nRecnoSE2  := 0
				nEstOrig   := 0
				nVA        := 0
				lMovAdto   := .F.

				aLeitura   := ReadCnab2(nHdlBco,cArqConf,nBloco,aArqConf)
				cNumTit    := SubStr(aLeitura[1],1, nTamTit)
				cData      := aLeitura[04]
				//cData      := ChangDate(cData,SEE->EE_TIPODAT)
				dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
				cTipo      := aLeitura[02]
				cNsNum     := aLeitura[11]
				nDespes    := aLeitura[06]
				nDescont   := aLeitura[07]
				nAbatim    := aLeitura[08]
				nValPgto   := aLeitura[05]
				nJuros     := aLeitura[09]
				nMulta     := aLeitura[10]
				cNsNum     := aLeitura[11]
				nTamEEOcor := 2
				cOcorr     := PadR( Left(Alltrim(aLeitura[03]),nTamEEOcor) , nTamOcor)
				cForne     := aLeitura[16]
				dDebito	   := dBaixa
				xBuffer	   := aLeitura[17]
				lAchouTit  := .F.

				//Segmento Z - Autenticacao
				If Len(aLeitura) > 17
					cAutentica := aLeitura[18]
				Endif

				//CGC
				If Len(aLeitura) > 19
					cCgc := aLeitura[20]
				Endif

                    
				//DDA - Debito Direto Autorizado
				If lUsaDDA
					If Len(aLeitura) > 23
						//Caso o CNPJ do Fornecedor seja retornado no Segmento H, assumo este valor
						If !Empty(aLeitura[24]) .And. Substr(aLeitura[24],1,7) != "0000000"
							cCgc := aLeitura[24]
						Endif

						cCodBar  := aLeitura[25]
						lProcDDA := !Empty(cCodBar)
					Endif
					If Len(aLeitura) > 25
						//Caso o CNPJ da empresa seja retornado no Segmento H, assumo este valor
						If !Empty(aLeitura[26]) .And. Substr(aLeitura[26],1,7) != "0000000"
							cCGCFilHeader := aLeitura[26]
						Endif
					Endif
				Endif

				If Empty(cNumTit) .And. !lProcDDA
					nLidos += nBloco
					Loop
				Endif

				If !(Empty(cNumTit))
					//Verifica se possui espaço em branco antes do número
					If Len(LTrim(cNumTit)) < nTamIdCNAB
						cNumTit := AjstIdCNAB(cNumTit)
					EndIf
					
					If !lProcDDA
						nRecnoSE2 := F430FilTit(cNumTit)
					EndIf
				EndIf

				//Verifica especie do titulo
				cEspecie	:= "  "

				If (nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})) != 0
					cEspecie := aTabela[nPos][2]
				EndIf

				If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
					Loop
				EndIf

				aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValPgto, nJuros, nMulta, cForne, cOcorr, cCGC, nCM, cRejeicao, xBuffer })
				
				//Processamento normal - Nao se trata de processamento de arquivo de DDA
				If !lProcDDA
					//Se nao achou, utiliza metodo antigo (titulo)
					If nRecnoSE2 == 0 .And. SE2->(!Found())
						SE2->(dbSetOrder(1))
						//Chave retornada pelo banco
						cChave430 := IIf(!Empty(cForne), Pad(cNumTit, nTamTit) + cEspecie + SubStr(cForne, 1, nTamForn), Pad(cNumTit, nTamTit) + cEspecie)
						
						While !lAchouTit
							If !SE2->(DbSeek(xFilial() + cChave430))
								nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,3))},nPos+1)

								If nPos != 0
									cEspecie := aTabela[nPos][2]
									cChave430 := IIf(!Empty(cForne), Pad(cNumTit, nTamTit) + cEspecie + SubStr(cForne, 1, nTamForn), Pad(cNumTit, nTamTit) + cEspecie)
								Else
									Exit
								Endif
							Else
								lAchouTit := .T.
							Endif
						Enddo
						
						//Chave retornada pelo banco com a adicao de espacos para tratar chave enviada ao banco com
						//tamanho de nota de 6 posicoes e retornada quando o tamanho da nota e 9 (atual)
						If !lAchouTit
							cNumTit   := SubStr(cNumTit, 1, nTamPre) + Padr(Substr(cNumTit, 4, 6), nTamNum) + SubStr(cNumTit, 10, nTamPar)
							cChave430 := IIf(!Empty(cForne), Pad(cNumTit, nTamTit) + cEspecie + SubStr(cForne, 1, nTamForn), Pad(cNumTit, nTamTit) + cEspecie)
							nPos      := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo, 1, 3))})

							While !lAchouTit
								If !dbSeek(xFilial()+cChave430)
									nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,3))},nPos+1)

									If nPos != 0
										cEspecie  := aTabela[nPos][2]
										cChave430 := IIf(!Empty(cForne), Pad(cNumTit, nTamTit) + cEspecie + SubStr(cForne, 1, nTamForn), Pad(cNumTit, nTamTit) + cEspecie)
									Else
										Exit
									Endif
								Else
									lAchouTit := .T.
								Endif
							Enddo
						Endif

						//Se achou o titulo, verificar o CGC do fornecedor
						If lAchouTit
							cNumSe2   := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
							cChaveSe2 := IIf(!Empty(cForne), cNumSe2 + SE2->E2_FORNECE, cNumSe2)
							nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso encontre o titulo

							While SE2->(!Eof()) .And. SE2->E2_FILIAL + cChaveSe2 == xFilial("SE2") + cChave430
								nPos := nPosEsp

								If Empty(cCgc)
									Exit
								Endif

								SA2->(DbSetOrder(1))

								If (SA2->(DbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA))) .And. (Substr(SA2->A2_CGC, 1, 14) == cCGC .Or. StrZero(Val(SA2->A2_CGC), 14, 0) == StrZero(Val(cCGC), 14, 0))
									Exit
								Endif

								SE2->(DbSkip())
								cNumSe2   := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)
								cChaveSe2 := IIf(!Empty(cForne), cNumSe2 + SE2->E2_FORNECE, cNumSe2)
								nPos 	  := 0
							Enddo
						EndIf
					Else
						nPos := 1
						lAchouTit := If(lAchouTit, lAchouTit, nRecnoSE2 > 0)
					EndIf

					lHelp := nPos == 0

				EndIf

				/* Posiciona no bordero para pegar dados bancarios.
				
				If lAchouTit
					DbSelectArea("SEA")
					SEA->( DbSetOrder( 1 ) )
					If SEA->( DbSeek( SE2->E2_FILORIG + SE2->E2_NUMBOR + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA ) )
						lAchouSEA := .T.
					EndIf
				EndIf
				*/
				/*----------------------------------------------------------------------------------------------------------------
					O array aValores permitirá que qualquer exceção ou necessidade seja tratado no ponto de entrada em PARAMIXB.
					Estrutura de aValores
					Numero do Título	- 01
					Data da Baixa		- 02
					Tipo do Título		- 03
					Nosso Numero		- 04
					Valor da Despesa	- 05
					Valor do Desconto	- 06
					Valor do Abatiment	- 07
					Valor Pagamento   	- 08
					Juros				- 09
					Multa				- 10
					Fornecedor			- 11
					Ocorrencia			- 12
					CGC					- 13
					nCM					- 14
					Rejeicao			- 15
					Linha Inteira		- 16
					Autenticacao 	    - 17
					Banco             	- 18
					Agencia           	- 19
					Conta             	- 20
					aValores := ({cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValPgto, nJuros, nMulta, cForne, cOcorr, cCGC, nCM, cRejeicao, xBuffer, cAutentica, cBanco, cAgencia, cConta})
					aValores := ({cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValPgto, nJuros, nMulta, cForne, cOcorr, cCGC, nCM, cRejeicao, xBuffer })
				----------------------------------------------------------------------------------------------------------------------*/
				//Conout("[CIFINJ01] - Arquivo ANTES DA ZPZ: " + cArquivo)
				//Conout("[CIFINJ01] - ArqEnt ANTES DA ZPZ: " + cArqEnt)

				DbSelectArea("ZPZ")
				ZPZ->( Reclock("ZPZ" , .T. ) )
				
				ZPZ->ZPZ_IDCNAB	:= aValores[01]
				ZPZ->ZPZ_BAIXA	:= aValores[02]
				ZPZ->ZPZ_TIPO	:= aValores[03]
				ZPZ->ZPZ_FATURA	:= aValores[04]
				ZPZ->ZPZ_ACRCN	:= aValores[05] //aqui
				ZPZ->ZPZ_DESCCN	:= aValores[06] //aqui
				ZPZ->ZPZ_ABATIM	:= aValores[07]
				ZPZ->ZPZ_VALOR	:= aValores[08]
				ZPZ->ZPZ_JURCN	:= aValores[09] //aqui
				ZPZ->ZPZ_MULCN	:= aValores[10] //aqui
				//ZPZ->ZPZ_CGC	:= aValores[13]
				//ZPZ->ZPZ_BANCO	:= aValores[18]
				//ZPZ->ZPZ_AGENCI	:= aValores[19]
				//ZPZ->ZPZ_CONTA	:= aValores[20]
				ZPZ->ZPZ_ARQUIV	:= cArquivo
				ZPZ->ZPZ_DTIMPA := Date()
				ZPZ->ZPZ_HIST   := "[CIFINJ01] - TITULO NAO ENCONTRADO NA SE2"
				ZPZ->ZPZ_STATUS := "X"
				ZPZ->ZPZ_FILIAL	:= "XXXXXX"
				ZPZ->ZPZ_PREFIX	:= "XX"
				ZPZ->ZPZ_NUM	:= "XXXXXXXXXX"
				ZPZ->ZPZ_PARCEL	:= "XX"
				ZPZ->ZPZ_TIPO	:= "XXE"
				ZPZ->ZPZ_FORNEC	:= "XXXXXX"
				ZPZ->ZPZ_LOJA	:= "XX"
				ZPZ_OCORRE      := aValores[12]

				If lAchouTit
					ZPZ->ZPZ_FILIAL	:= SE2->E2_FILIAL
					ZPZ->ZPZ_PREFIX	:= SE2->E2_PREFIXO
					ZPZ->ZPZ_NUM	:= SE2->E2_NUM
					ZPZ->ZPZ_PARCEL	:= SE2->E2_PARCELA
					ZPZ->ZPZ_TIPO	:= SE2->E2_TIPO
					ZPZ->ZPZ_FORNEC	:= SE2->E2_FORNECE
					ZPZ->ZPZ_LOJA	:= SE2->E2_LOJA
					ZPZ->ZPZ_EMISSA	:= SE2->E2_EMISSAO
					ZPZ->ZPZ_VENCTO	:= SE2->E2_VENCTO
					ZPZ->ZPZ_VENCRE	:= SE2->E2_VENCREA
					ZPZ->ZPZ_NUMBOR	:= SE2->E2_NUMBOR
					ZPZ->ZPZ_SALDO  := SE2->E2_SALDO
					ZPZ->ZPZ_VALLIQ := SE2->E2_VALLIQ
					ZPZ->ZPZ_DESCON := SE2->E2_DESCONT
					ZPZ->ZPZ_MULTA  := SE2->E2_MULTA
					ZPZ->ZPZ_JUROS  := SE2->E2_JUROS 
					ZPZ->ZPZ_ACRESC := SE2->E2_ACRESC
					ZPZ->ZPZ_HIST   := "[CIFINJ01] - TITULO ENCONTRADO EM ABERTO"
					ZPZ->ZPZ_STATUS := ""

					IF SE2->E2_SALDO == 0
						ZPZ->ZPZ_STATUS = "B"
						ZPZ->ZPZ_BAIXA  = SE2->E2_BAIXA
						ZPZ->ZPZ_HIST   = "[CIFINJ01] - TITULO JA BAIXADO EM SE2"
					ENDIF

					// Pesquisa banco oficial para baixa dos titulos 
					cQuery := "SELECT * " + CRLF
					cQuery += "FROM " + RetSQLName("SEE") + " T0" + CRLF
					cQuery += "WHERE T0.EE_FILIAL = '" + SE2->E2_FILIAL + "'"  + CRLF
					cQuery += "	AND T0.EE_OPER = 'RETORNO'" + CRLF
					cQuery += " AND T0.EE_SUBCTA = '002'"   + CRLF
					cQuery += " AND T0.EE_CODOFI <> ''"     + CRLF
					cQuery += "	AND T0.D_E_L_E_T_ = ''"     
					
					cTab := MPSysOpenQuery(cQuery)

					If (cTab)->(!Eof())
						cBanco	 := (cTab)->EE_CODOFI
						cAgencia := (cTab)->EE_AGEOFI
						cConta	 := (cTab)->EE_CTAOFI
						ZPZ->ZPZ_BANCO	:= cBanco
						ZPZ->ZPZ_AGENCI	:= cAgencia
						ZPZ->ZPZ_CONTA	:= cConta
					ENDIF
					
					(cTab)->(dbCloseArea())

				ENDIF
				
				ZPZ->( MsUnlock() )
				nLidos += nBloco
			EndDo // while
		End Transaction

		VALOR := 0
		dbSelectArea( cAlias )
		dbGoTo(nSavRecno)

	EndIf

	//Fecha os arquivos
	If nHdlBco > 0
		FCLOSE(nHdlBco)
	Endif

	cFilAnt := cFilOrig

	Conout("[CIFINJ01] - Finalizando Execucao " + cEmpJob + "/ " + cFilJob + "")
 
Return

//-------------------------------------
/*/{Protheus.doc}F430FilTit
Posiciona na filial de origem do título

@param cIdCnab, Identificador do título de retorno
@return nRecnoSE2, Recno do título a ser processado
@author Sivaldo Oliveira
@since  16/12/2019
@version 12
/*/
//-------------------------------------
Static Function F430FilTit(cIdCnab As Character) As Numeric
	Local nRecnoSE2 As Numeric
	Local lRet      As Logical

	//Inicializa variáveis
	nRecnoSE2 := 0
	lRet      := .F.

	Default cIdCnab := ""
   
	If !Empty(cIdCnab)
		SE2->(dbSetOrder(13))

		If !(lRet := SE2->(DbSeek(Substr(cIdCnab, 1, 10))) .And. !Empty(SE2->E2_FILORIG))
			SE2->(dbSetOrder(11))
			lRet := SE2->(DbSeek(xFilial("SE2") + Substr(cIdCnab, 1, 10))) .And. !Empty(SE2->E2_FILORIG)
		Endif

		If lRet
			cFilAnt	  := SE2->E2_FILORIG

			nRecnoSE2 := SE2->(Recno())
		EndIf
	EndIf

Return nRecnoSE2

/*/{Protheus.doc} AjstIdCNAB
Ajusta ID CNAB caso o mesmo não possua zeros a esquerda, apenas 6 caracters.

@type  		Function
@since 		24/09/2021
@param 		cIdCNAB, character, id cnab
@return 	character, novo Id CNAB modificado com 0 a esquerda
/*/
Static Function AjstIdCNAB(cIdCNAB As Character) As Character

	Local cNovIdCNAB	As Character
	Local cSubIdCNAB	As Character
	Local cZero			As Character

	Local nLenIdCNAB	As Numeric
	Local nTamIdCNAB	As Numeric

	Default cIdCNAB		:= ""	

	cNovIdCNAB	:= ""
	cZero		:= ""
	nLenIdCNAB	:= Len(cSubIdCNAB := LTrim(cIdCNAB))
	nTamIdCNAB	:= TamSX3("E2_IDCNAB")[1]

	cZero := Replicate("0", nTamIdCNAB - nLenIdCNAB)

	cNovIdCNAB := cZero + cSubIdCNAB

Return cNovIdCNAB
