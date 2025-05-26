#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "FWBROWSE.CH"
#Include "FWMVCDEF.CH"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Totvs.Ch"

Static lCRMTerr	:= Nil 
Static cDir  	:= "INTEGRADOR"
Static cFCria   := "db" + "Create"

// Variaveis utilizadas no tratamento das tabelas FK's funções fCreateFK7 e fCreateFKs
Static aCamposFK1 	:= U_XFINLisCpo('FK1')
Static aCamposFK2 	:= U_XFINLisCpo('FK2')
Static aCamposFK5 	:= U_XFINLisCpo('FK5')
Static aCamposFK6 	:= U_XFINLisCpo('FK6')
Static aCamposFK8 	:= U_XFINLisCpo('FK8')
Static aDeParaFK1 	:= U_XFINLisCpo('FK1')
Static aDeParaFK5 	:= U_XFINLisCpo('FK5')
Static aDeParaFK2 	:= U_XFINLisCpo('FK2')
Static aDeParaFK6 	:= U_XFINLisCpo('FK6')
Static __aRFK6SE5 	:= {}
Static lFilExclus 	:= FWModeAccess("SE5",3) == "E"
Static nTamFil		:= Len(cFilAnt)
Static __nTamSeq	:= Nil
Static lSE5GRVFK	:= ExistBlock("SE5GRVFK")
Static aSE5GRVFK	:= {}
Static lBxMovPA 	:= .F.
Static _lTemMR		:= If(FindFunction("FTemMotor"), FTemMotor(), .F.)
Static __lTemCmp 	:= FindFunction("CtbLP596Cr")
Static __aVaToCTB	:= {}
Static __lFK7Cpos	:= NIL
Static __aTamCpos	:= {}
Static _aCmpFKC
Static _lInDicFKK
Static _lInDicFKC
Static _lInDicFKD
//Static __cQryFKK 

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦                                                     
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ TINCWHXF ¦ Autor ¦ Alexandre Venancio     ¦ Data ¦ 25/06/24¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Rotina para realizar as integrações das tabelas do WebHook ¦¦¦
¦¦¦          ¦ com seus destinos finais                            		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ SQUAD INCORPORADOR                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function TINCWHXF(nOpcao,aArray,cTabela,nRecP98,cArquivo,cUsrLog,aLogP98,cCodPN2,nRec2P98,cQtdLog,/*cTextoLog,cArqLog,*/oIntegraMais)

	Local aArea 	:= GetArea()
	Local cRet 		:= ''

	//Private cInicLog	:= ''
	//Private cLocArq	:= cArqLog

	Default nOpcao  := 1
	Default aArray  := {}
	Default cTabela := ''
	Default nRecP98 := 0
	Default aLogP98 := {}
	Default cCodPN2 := ""
	Default nRec2P98:= 0
	Default oIntegraMais := nil

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("00","00001000100")
	EndIf

	// If nOpcao <> 5
	// 	cInicLog	:= Time()
	// 	cTextoLog 	+= 'Tabela - '+ cTabela +CRLF
	// 	cTextoLog 	+= "Registro Processado: " + cQtdLog +CRLF	
	// 	cTextoLog 	+= 'Hora Inicio: ' + cInicLog +CRLF
	// 	cTextoLog 	+= 'Recno P98: '+ cValToChar(nRecP98) +CRLF
	// EndIf

	If nOpcao == 1
    	cRet := AtuaSA1(aArray,nRecP98,cUsrLog,/*cTextoLog,*/oIntegraMais)
	ElseIf nOpcao == 2
    	cRet := AtuaSA2(aArray,nRecP98,cUsrLog,/*cTextoLog,*/oIntegraMais)
	ElseIf nOpcao == 3
		cRet := GrRcLk(aArray,cTabela,nRecP98,cUsrLog,/*cTextoLog,*/oIntegraMais)
	ElseIf nOpcao == 4
		cRet := _ExcAto(aArray,cTabela,nRecP98,cUsrLog,nRec2P98,/*cTextoLog,*/oIntegraMais)
	ElseIf nOpcao == 5
		cRet := FWMsgRun(, {|| U_TINCWHCT(cCodPN2,aArray,'c:\temp',,'c:\temp\migratotvs'+dtos(ddatabase)+'.txt',,cArquivo,@aLogP98)},"","Processando os dados...")
		//cRet := FWMsgRun(, {|| U_TINCWHCT(cCodPN2,aArray,'c:\temp',,'c:\temp\migratotvs'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt',,cArquivo,@aLogP98)},"","Processando os dados...")
	EndIf

	RestArea(aArea)

Return(cRet)

/*/{Protheus.doc} AtuaSA1
    Atualização/Criação de clientes através do webhook
    @type  Static Function
    @author user
    @since 25/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AtuaSA1(aArray,nRecP98,cUsrLog,/*cTextoLog,*/oIntegraMais)

	Local aArea 		:= FwGetArea()
	Local nK,nY 
	Local aDataCab		:= {}
	Local aAreaFechar	:= {}
	Local cMsg 			:= ''
	Local cBkpCli		:= ''
	Local cBkpLjCli		:= ''
	Local cDetTabs		:= ''
	Local cVendMigra 	:= 'T99001'
	Local cCNPJ			:= ''
	Local cCodCli		:= ''
	Local cChave 		:= ''
	Local cChaveCpos	:= ''
	Local cValorCpo 	:= ''
	Local cAuxCnae		:= ''
	//Local cMensagemErro
	Local nTamSx3 		:= 0
	Local nLen			:= 0
	Local nDataCab		:= 0
	Local nA1Pessoa		:= 0
	Local nA1XUPMSHP	:= 0
	Local nA1CODSEG		:= 0
	//Local nPosDel		:= 0
	Local lSuspect		:= .F.
	Local lProspect		:= .F.

	Private lMsErroAuto := .F.
	Private lCli	:= .F.

	nLen := Len(aArray)

	For nK := 1 To nLen
		
		cChave := Alltrim(aArray[nK,01])
		cChaveCpos	:= 'A1_COD/A1_PESSOA/A1_CGC/A1_VEND/A1_XUPMSHP/A1_CNAE/A1_CODSEG/A1_EMAIL/A1_XEMAILF'

		If !SUBSTR(cChave,at("_",cChave)+1) $ 'P98REC/P98STA'
			Aadd(aDataCab,cChave)
		EndIf 

		If cChave $ cChaveCpos
			If cChave == "A1_COD"
				cCodCli := AllTrim(aArray[nK,02])
			ElseIf cChave == "A1_PESSOA"
				nA1Pessoa := nK
			ElseIf cChave == "A1_CGC"
				cCNPJ := aArray[nK,02]
			ElseIf cChave == "A1_VEND"
				cVendMigra := aArray[nK,02]
			ElseIf cChave == "A1_XUPMSHP"
				nA1XUPMSHP := nK
			ElseIf cChave == "A1_CNAE"
				cAuxCnae := AllTrim(aArray[nK,02])
				If Empty(cAuxCnae)  
					aArray[nK,02] := "9999-9/99"
				Else 
					cAuxCnae := Replace(cAuxCnae,'-','')
					cAuxCnae := Replace(cAuxCnae,'/','')
					aArray[nK,02] := Transform( AllTrim(cAuxCnae), "@R 9999-9/99" )
				EndIf
			ElseIf cChave == "A1_CODSEG"
				nA1CODSEG := nK

			/*	Tratamento para truncar o campo US_XEMAILF para os casos que vierem com mais 
			de 80 caracteres, que é o tamanho do campo na SUS, como o cliente será convertido 
			do prospect, o mesmo também terá apenas os primeiros 80 caracteres, mesmo a 
			capacidade do campo sendo 120 na tabela SA1; 	*/
			ElseIf cChave == "A1_EMAIL"
				If Len(AllTrim(aArray[nK,02])) > 80
					aArray[nK,02] := Left(AllTrim(aArray[nK,02]), 80)
				EndIf
			ElseIf cChave == "A1_XEMAILF"
				If Len(AllTrim(aArray[nK,02])) > 80
					aArray[nK,02] := Left(AllTrim(aArray[nK,02]), 80)
				EndIf
			EndIf

		EndIf

		cChave := ''

	Next nK 

		If(nA1XUPMSHP > 0)
			If aArray[nA1Pessoa,02] $ 'J/F' .And. Len(aArray[nA1CODSEG,02]) > 0
				aArray[nA1XUPMSHP,02] := '2'
			EndIf
		EndIf

	If Empty(cVendMigra)

		//---------------------------------------
		//Verifica se o cliente tem como Suspect
		//---------------------------------------
		ACH->(dbSetOrder(2))
		lSuspect := ACH->(dbSeek( xFilial("ACH") + PadR(cCNPJ, TamSx3("ACH_CGC")[1])) )

		//---------------------------------------
		//Verifica se o cliente tem como Prospect
		//---------------------------------------
			SUS->(dbSetOrder(4))
		lProspect := SUS->(dbSeek( xFilial("SUS") + PadR(cCNPJ, TamSx3("US_CGC")[1])) )

		If lProspect
				If !Empty(SUS->US_VEND)
					cVendMigra := SUS->US_VEND
				EndIf 
			EndIF 

		If !lProspect
			If lSuspect
				cVendMigra := ACH->ACH_VEND
			EndIf 
				EndIf 

		EndIf

		DbSelectArea('SA1')
		DbSetOrder(1)
	If DbSeek(xFilial("SA1") + cCodCli)
			lCli := .T.
		EndIf

		SA3->(dbSetOrder(1))
		SA3->(dbSeek( xFilial("SA3") + cVendMigra ))
		__cUserID := SA3->A3_CODUSR

		dbSelectArea("AZS")
		AZS->(dbSetOrder(4))
		If AZS->(dbSeek(xFilial("AZS")+SA3->A3_COD)) 
			If !empty(alltrim(AZS->AZS_CODUSR))
			__cUserID := AZS->AZS_CODUSR
			EndIf
		Else
			cMsg += "#ERRO - Não foi encontrado papel do vendedor do CRM, pelo vendedor do Pedido. (AZS)"+CRLF
		EndIf

		dbSelectArea("AO3")
		AO3->(dbSetOrder(1))
		If !AO3->(dbSeek(xFilial("AO3")+AZS->AZS_CODUSR))
			cMsg += "#ERRO - Não foi encontrado usuario do CRM, pelo vendedor do Pedido. (AZS)"+CRLF
		EndIf

		CRMXSETUSER(alltrim(__cUserID))
		CRMXSETPAPER(alltrim(AZS->AZS_CODUSR)+AZS->AZS_SEQUEN+AZS->AZS_PAPEL)

		aCRMPaper := CRMXGETPAPER()

		If Len(aCRMPaper) > 0
			_lEditaSa1 := .f.
			_lUpCpoAll := .f.

			dbSelectArea("SA1")
			SA1->(dbSetOrder(3))
			If SA1->(dbSeek(xFilial("SA1") + PadR(cCNPJ, TamSx3("A1_CGC")[1]))) 

			If alltrim(upper(cCodCli)) <> alltrim(upper(SA1->A1_COD))
					cMsg += "#AVISO CNPJ ja existe no cad. cliente( SA1 ) divergente do codigo .CSV! Procurar CST para atualização."+CRLF
					_lEditaSa1 := .f.
			Else
					cMsg += "#AVISO CNPJ ja importado na migração atual! Não pode ser atualizado."+CRLF
					_lEditaSa1 := .f.
			EndIf
				_lUpCpoAll := .f. 

				cRet := "#Aviso"
				cDetalhe := "Recno tabela SA1 - "+cvaltochar(SA1->(Recno()))
				U_TINCGRLG(nRecP98,SA1->(Recno()),"SA1",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

			Else

			If lSuspect .AND. !lProspect

				If Empty(ACH->ACH_VEND)
					If Reclock("ACH" , .F.)
						ACH->ACH_VEND := cVendMigra
						ACH->(MsUnlock())
					EndIf
				Else 
					cVendMigra := ACH->ACH_VEND
				EndIf

				If !TINC341X(ACH->ACH_CODIGO,ACH->ACH_LOJA,Nil,cVendMigra) 
					cMsg += "#ERRO - Problema ao efetivar o Suspect em Prospect"+CRLF
				Else
					lProspect := .T.
				EndIf
			EndIf

				If lProspect

					If !Empty(SUS->US_CODCLI) .OR. !Empty(SUS->US_LOJACLI)
						If RecLock("SUS",.F.)
							cBkpCli 		:= SUS->US_CODCLI
							cBkpLjCli		:= SUS->US_LOJACLI 
							SUS->US_CODCLI	:= SPACE(TAMSX3("US_CODCLI")[1])
							SUS->US_LOJACLI	:= SPACE(TAMSX3("US_LOJACLI")[1])
							SUS->(MsUnlock())
						EndIf
					EndIf
	
					// Converte Prospect em Cliente
					If !Tk273GrvPTC( SUS->US_COD , SUS->US_LOJA , .F. )
						cMsg += "#ERRO - Problema ao efetivar Prospect em Cliente"+CRLF
					// Tirar depois de homologar 
					// mostraerro()
					Else
						nRecSus := SUS->(Recno())
						DbSelectArea("SUS")
						DbGoto(nRecSus)
					If alltrim(upper(SUS->US_CODCLI)) <> alltrim(upper(cCodCli))
							If !lCli
							Reclock("SUS",.F.)
								SUS->US_CODCLI := cCodCli
							SUS->(MsUnlock())
							cDetTabs := fAtuTabs(cBkpCli,cBkpLjCli,cCodCli)
							EndIf
					EndIf
						_lEditaSa1 := .f.
						_cCodAI0 := ''

						SA1->(dbSetOrder(3))
						If SA1->(dbSeek( xFilial("SA1") + cCNPJ ))

							cMsg += "#SUCESSO - Cliente Gerado"+CRLF
							cRet := "#Sucesso"
							cDetalhe := "Recno tabela SA1 - "+cvaltochar(SA1->(Recno()))
							If !Empty(cBkpCli)
								cDetalhe += '| US_CODCLI - ANTIGO = ' + cBkpCli + cDetTabs
							EndIf
						U_TINCGRLG(nRecP98,SA1->(Recno()),"SA1",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
							
						If alltrim(upper(SA1->A1_COD)) <> alltrim(upper(cCodCli))
								_cCodAI0 := SA1->A1_COD+SA1->A1_LOJA
								If !lCli
								Reclock("SA1",.F.)
									SA1->A1_COD := cCodCli
								SA1->(MsUnlock())
								EndIf

								_lEditaSa1 := .t.
						EndIf
						Else
							cMsg += "#ERRO - Problema ao incluir o cliente"+CRLF
							cRet := "#Erro"
							cDetalhe := "Recno tabela SA1 - "+cvaltochar(SA1->(Recno()))
						U_TINCGRLG(nRecP98,SA1->(Recno()),"SA1",cRet,cDetalhe,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

						EndIf

					If !empty(_cCodAI0) .And. !lCli
						DbSelectArea( 'AI0' )
							AI0->(dbSetOrder(1))
							If !AI0->(dbSeek( xFilial("AI0") + cCodCli + '00' ))
								If AI0->(dbSeek( xFilial("AI0") + _cCodAI0 ))
									Reclock("AI0",.F.)
									AI0->AI0_CODCLI := cCodCli
									AI0->(MsUnlock())
								EndIf
							EndIf
					EndIf
					EndIf
				EndIf

				If !lProspect
					
				aDadosSUS 	:= {}
				nDataCab	:= Len(aDataCab)
				For nK := 1 To nDataCab
					cCabec := Alltrim(Upper(aDataCab[nK]))
					If !(cCabec $ "A1_COD/A1_MOEDALC/A1_CODSEG/A1_XCODSUB")
						If !(cCabec == "A1_DTNASC")  
							cCpoSUS := StrTran( aDataCab[nK] , "A1_" , "US_" )
						Else
								cCpoSUS := "US_XDTNAS"
						EndIf
							cOrdem 	:= GetSx3Cache(cCpoSUS,"X3_ORDEM")
							lAdd := !Empty(cOrdem)

							If lAdd

								lAdd := .F.
								nY := ascan(aArray,{|x| x[1] == aDataCab[nK]})
							cValorCpo := Alltrim(aArray[nY][2])

							If !Empty(cValorCpo)
								nTamSx3 := TamSx3(cCpoSUS)[1]
									cTipoCpo := GetSx3Cache(cCpoSUS,"X3_TIPO")

									If cTipoCpo == "C"
									cValorCpo := Iif(cCpoSUS <> "US_INSCR", cValorCpo, PADR(cValorCpo, nTamSx3))
									ElseIf cTipoCpo == "N"
									cValorCpo := Val(cValorCpo)
									ElseIf cTipoCpo == "D"
									cValorCpo := Iif('/' $ cValorCpo, CtoD(cValorCpo), StoD(cValorCpo))
								Else
									cValorCpo := PADR(cValorCpo, nTamSx3)
									EndIf

								Aadd( aDadosSUS , { cCpoSUS , cValorCpo , cOrdem } )
								EndIf
							EndIf
						EndIf
					Next nK 

					If Len(aDadosSUS) > 0

						ASORT(aDadosSUS, , , { | x,y | x[3] < y[3] } )
						lMsErroAuto := .F.

						If !lProspect
							TMKA260( aDadosSUS, 3 )

							SUS->(dbSetOrder(4))
							lProspect := SUS->(dbSeek( xFilial("SUS") + PadR(cCNPJ, TamSx3("US_CGC")[1])) )
						
						EndIf

						If lProspect 

							nRecSus := SUS->(Recno())

							If !Tk273GrvPTC( SUS->US_COD , SUS->US_LOJA , .F. )
								cMsg += "#ERRO - Problema ao efetivar Prospect em Cliente"+CRLF
							Else
								if alltrim(upper(SUS->US_CODCLI)) <> alltrim(upper(cCodCli))
									If !lCli
										DbSelectArea("SUS")
										DbGoto(nRecSus)
										Reclock("SUS",.F.)
										cBkpCli := SUS->US_CODCLI
										SUS->US_CODCLI := cCodCli
										SUS->(MsUnlock())
										
										cDetTabs := fAtuTabs(cBkpCli,cBkpLjCli,cCodCli)
									EndIf
								endif
								_lEditaSa1 := .f.
								_cCodAI0 := ''

								SA1->(dbSetOrder(3))
								If SA1->(dbSeek( xFilial("SA1") + cCNPJ ))
									cMsg += "#SUCESSO - Cliente Gerado"+CRLF
									cRet := "#Sucesso"
									cDetalhe := "Recno tabela SA1 - "+cvaltochar(SA1->(Recno()))
									If !Empty(cBkpCli)
										cDetalhe += '| US_CODCLI - ANTIGO = ' + cBkpCli + cDetTabs
									EndIf
								U_TINCGRLG(nRecP98,SA1->(Recno()),"SA1",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

									If alltrim(upper(SA1->A1_COD)) <> alltrim(upper(cCodCli))
										_cCodAI0 := SA1->A1_COD+SA1->A1_LOJA

										If !lCli
											Reclock("SA1",.F.)
											SA1->A1_COD := cCodCli
											SA1->(MsUnlock())
										EndIf

										_lEditaSa1 := .t.
									EndIf
								Else
									
									cMsg += "#ERRO - Problema ao incluir o cliente"+CRLF
									cRet := "#Erro"
									cDetalhe := "Recno tabela SA1 - "+cvaltochar(SA1->(Recno()))
								U_TINCGRLG(nRecP98,SA1->(Recno()),"SA1",cRet,cDetalhe,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
									
								EndIf

								If !empty(_cCodAI0)
									DbSelectArea( 'AI0' )
									AI0->(dbSetOrder(1))
									If !AI0->(dbSeek( xFilial("AI0") + cCodCli + '00' ))
										If AI0->(dbSeek( xFilial("AI0") + _cCodAI0 ))
											Reclock("AI0",.F.)
											AI0->AI0_CODCLI := cCodCli
											AI0->(MsUnlock())
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			cMsg += "#ERRO - Problema ao setar o papel do vendedor ( " + cVendMigra + " / " + __cUserID + " )"+CRLF
		EndIf

		//Para resolver a questão de utilizar com multithread e ficarem muitas areas abertas
		aAreaFechar := {'ACH','SUS','SA1','SA3','AZS','AO3','AI0'}

		For nY := 1 to len(aAreaFechar)
			If Select(aAreaFechar[nY]) > 0
				dbSelectArea(aAreaFechar[nY])
				dbCloseArea()
			EndIf
		Next nY

	FwRestArea(aArea)

Return(cMsg)

/*/{Protheus.doc} AtuaSA2(aArray)
	Criação de fornecedores
    @type  Static Function
    @author user
	@since 28/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AtuaSA2(aArray,nRecP98,cUsrLog,/*cTextoLog,*/oIntegraMais)

	Local aArea			:= FwGetArea()
	Local cMsg  		:= ""
	Local cChave		:= ""
	Local cChaveCpos	:= ""
	Local nA2Loja		:= 0
	Local nA2End		:= 0
	Local nA2Est		:= 0
	Local nA2Mun		:= 0
	Local nA2Pais		:= 0
	Local nA2Cgc		:= 0
	Local nA2Tipo		:= 0
	Local nA2Blq		:= 0
	Local nX			:= 0
	Local nK			:= 0
	Local nLen			:= 0
	Local nDataCab		:= 0
	Local aAux			:= {}
	Local aDataCab		:= {}
	Local lBloqueio 	:= .F.

	INCLUI	:= .T.
	ALTERA	:= .F.
	nLen	:= Len(aArray)

	For nK := 1 To nLen 

		cChave 		:= Alltrim(aArray[nK,01])
		cChaveCpos	:= 'A2_LOJA/A2_TIPO/A2_CGC/A2_MSBLQL/A2_END/A2_EST/A2_MUN/A2_PAIS'

		If !SUBSTR(cChave,at("_",cChave)+1) $ 'P98REC/P98STA'
			Aadd(aDataCab,cChave)
		EndIf

		If cChave $ cChaveCpos
			If cChave == "A2_LOJA"
				nA2Loja := nK
			ElseIf cChave == "A2_TIPO"
				nA2Tipo := nK
			ElseIf cChave == "A2_CGC"
				nA2Cgc := nK
			ElseIf cChave == "A2_MSBLQL"
				nA2Blq := nK
			ElseIf cChave == "A2_END"
				nA2End := nK
			ElseIf cChave == "A2_EST"
				nA2Est := nK
			ElseIf cChave == "A2_MUN"
				nA2Mun := nK
			ElseIf cChave == "A2_PAIS"
				nA2Pais := nK
				EndIf 
			EndIf

	Next nK 

	If nA2Blq > 0
		If cValToChar(aArray[nA2Blq,02]) == "1"
			lBloqueio := .T.
			aArray[nA2Blq,02] := "2"
		EndIf 
	EndIf 

	If nA2Loja == 0
		Aadd(aDataCab,"A2_LOJA")
		Aadd(aArray,{"A2_LOJA",""})
		nA2Loja := Len(aDataCab)
	EndIf 

	If nA2Pais == 0
		Aadd(aDataCab,"A2_PAIS")
		Aadd(aArray,{"A2_PAIS",""})
		nA2Pais := Len(aDataCab)
	EndIF 

	IF nA2Tipo == 0
		Aadd(aDataCab,"A2_TIPO")
		Aadd(aArray,{"A2_TIPO",If(LEN(aArray[nA2Cgc,02])<12,"F","J")})
		nA2Tipo := Len(aDataCab)
	EndIf 

		aAux := {}

		dbSelectArea("SA2")
		SA2->(dbSetOrder(3))
		If SA2->(dbSeek(xFilial("SA2") + PadR(aArray[nA2Cgc,02], TamSx3("A2_CGC")[1])))
			cMsg += "#AVISO - "+ aArray[nA2Cgc,02] + ";CNPJ ja existe"
			cRet := "#Aviso"
			cDetalhe := cMsg + " Recno tabela SA2 - "+cvaltochar(SA2->(Recno()))
			U_TINCGRLG(nRecP98,SA2->(Recno()),"SA2",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
		Else
			aArray[nA2Loja,02]	:= "00"

			If Empty(aArray[nA2End,02])
				aArray[nA2End,02] := "SEM ENDERECO"
			EndIf

			If Empty(aArray[nA2Est,02])
				aArray[nA2Est,02] := "SP"
			EndIf

			If Empty(aArray[nA2Mun,02])
				aArray[nA2Mun,02] := "SAO PAULO"
			EndIf

			If Empty(aArray[nA2Pais,02])
				aArray[nA2Pais,02] := "105"
			EndIf

			If Empty(aArray[nA2Cgc,02]) .And. Alltrim(aArray[nA2Tipo,02]) == "X"
				aArray[nA2Cgc,02] := "00000000000000"
			EndIf

		nDataCab := Len(aDataCab)
				
		For nX := 1 To nDataCab
				If !( AllTrim( aDataCab[nX] ) $ "A2_FILIAL|A2_COD|A2_IBGE|RecnoP98" .Or. "_FILIAL" $ aDataCab[nX] )
					If !Empty(aArray[nX,02])
						cTipoCpo := GetSx3Cache(aArray[nX,01],"X3_TIPO")

						If cTipoCpo == "D" .And. Valtype(aArray[nX,02]) <> "D"
							aArray[nX,02] := Ctod(aArray[nX,02])
						ElseIf cTipoCpo == "C" .And. Valtype(aArray[nX,02]) <> "C"
							aArray[nX,02] := AllTrim(cvaltochar(aArray[nX,02]))
						EndIf 

						AADD(aAux,{aDataCab[nX], aArray[nX,02], nil})
					EndIf
				EndIf
			Next nX

			lMsErroAuto := .F.

			NextHLock("SA2", "A2_COD", 1, .T.)

			MsExecAuto({|x,y| MATA020(x,y)}, aAux, 3)

			If lMsErroAuto
			cMensagemErro := mostraerro('\SYSTEM\')
				cMsg += "#ERRO - "+cMensagemErro + CRLF
				cRet := "#Erro"
				U_TINCGRLG(nRecP98,SA2->(Recno()),"SA2",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

			Else

				dbSelectArea("SA2")
				SA2->(dbSetOrder(3))
				If SA2->(dbSeek(xFilial("SA2") + PadR(aArray[nA2Cgc,02], TamSx3("A2_CGC")[1])))
					If lBloqueio 
						Reclock("SA2",.F.)
						SA2->A2_MSBLQL := "1"
						SA2->(Msunlock())
					EndIf 

					cMsg += "#SUCESSO - Codigo do Fornecedor "+SA2->A2_COD
					cRet := "#Sucesso"
					cDetalhe := cMsg + " Recno tabela SA2 - "+cvaltochar(SA2->(Recno()))
				U_TINCGRLG(nRecP98,SA2->(Recno()),"SA2",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

				EndIf 
				
				ConfirmSx8()
			EndIf
		EndIf

	FwRestArea(aArea)

Return(cMsg)

/*/{Protheus.doc} _ExcAto(aArray,cTabela)
	Rotina com os dados criados via Execauto
	Inicialmente Contas a Receber e Contas a Pagar
	@type  Static Function
	@author user
	@since 28/06/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function _ExcAto(aArray,cTabela,nRecP98,cUsrLog,nRec2P98,/*cTextoLog,*/oIntegraMais)

	Local aArea := GetArea()
	Local cRet  := ""
	//Local aTitulo := {}
	Local nY 
	Local aCab			:= {}
	Local aItens		:= {}
	Local lCondPg9		:= .F.
	Local nPosCnd		:= 0
	Local cBkpCnd		:= ""
	local oModel 		:= nil 	
	Local nTipo 		:= 3
	Local aRecCt2		:= {}

	local aErro			:= {}

	Private INCLUI		:= .T.
	Private ALTERA 	 	:= .F.
	Private lMsErroAuto := .F.


	If cTabela == "SE1"

		nPos1 := Ascan(aArray[1],{|x| x[1] == "E1_FILIAL"})
		nPos2 := Ascan(aArray[1],{|x| x[1] == "E1_PREFIXO"})
		nPos3 := Ascan(aArray[1],{|x| x[1] == "E1_NUM"})
		nPos4 := Ascan(aArray[1],{|x| x[1] == "E1_PARCELA"})
		nPos5 := Ascan(aArray[1],{|x| x[1] == "E1_TIPO"})

		DbSelectArea("SE1")
		DbSetOrder(1)
		If Dbseek(Avkey(aArray[1,nPos1,2],"E1_FILIAL")+Avkey(aArray[1,nPos2,2],"E1_PREFIXO")+Avkey(aArray[1,nPos3,2],"E1_NUM")+Avkey(aArray[1,nPos4,2],"E1_PARCELA")+Avkey(aArray[1,nPos5,2],"E1_TIPO"))
			cRet := "#AVISO"
			cMensagemErro := "Titulo ja lançado "+cvaltochar(SE1->(Recno()))
			U_TINCGRLG(nRecP98,0,"SE1",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
		Else 
			aCab := CabecExc(aArray,cTabela,oIntegraMais)

			//Verificação de banco agencia e conta cadastrada na filial
			nPos1 := Ascan(aCab,{|x| x[1] == "E1_PORTADO"})
			nPos2 := Ascan(aCab,{|x| x[1] == "E1_AGEDEP"})
			nPos3 := Ascan(aCab,{|x| x[1] == "E1_CONTA"})
			cBco  := ""
			cAge  := ""
			cCta  := ""

			DbSelectArea("SA6")
			DbSetOrder(1)
			If !DbSeek(xFilial("SA6")+Avkey(aCab[nPos1,2],"A6_COD")+Avkey(aCab[nPos2,2],"A6_AGENCIA")+Avkey(aCab[nPos3,2],"A6_NUMCON"))
				cBco  := aCab[nPos1,2]
				cAge  := aCab[nPos2,2]
				cCta  := aCab[nPos3,2]
				aCab[nPos1,2] := ''
				aCab[nPos2,2] := ''
				aCab[nPos3,2] := ''
			EndIf 

			//Data valida no vencimento real
			nPos4 := Ascan(aCab,{|x| x[1] == "E1_VENCREA"})
			
			If nPos4 > 0
				If aCab[nPos4,02] <> datavalida(aCab[nPos4,02])
					aCab[nPos4,02] := datavalida(aCab[nPos4,02])
				EndIF 
			EndIF 

			lMsErroAuto := .F.
			MSExecAuto({|x,y| FINA040(x,y)}, aCab, 3)

			If lMsErroAuto
				cRet := "#Erro"
				cMensagemErro := mostraerro('\SYSTEM\')
				U_TINCGRLG(nRecP98,0,"SE1",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
			Else
				nRecFim := SE1->(Recno())
				cRet := "#Sucesso"
				cDetalhe := "Recno tabela SE1 - "+cvaltochar(SE1->(Recno()))
				
				U_TINCGRLG(nRecP98,nRecFim,"SE1",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
				If !Empty(cBco)
					Reclock("SE1",.F.)
					SE1->E1_PORTADO := cBco
					SE1->E1_AGEDEP  := cAge
					SE1->E1_NUMCON  := cCta
					SE1->(MSUnlock())
				EndIf 
			EndIF 
		EndIf 

		
	ElseIf cTabela == "SE2"
		
		nPos1 := Ascan(aArray[1],{|x| x[1] == "E2_FILIAL"})
		nPos2 := Ascan(aArray[1],{|x| x[1] == "E2_PREFIXO"})
		nPos3 := Ascan(aArray[1],{|x| x[1] == "E2_NUM"})
		nPos4 := Ascan(aArray[1],{|x| x[1] == "E2_PARCELA"})
		nPos5 := Ascan(aArray[1],{|x| x[1] == "E2_TIPO"})
		nPos6 := Ascan(aArray[1],{|x| x[1] == "E2_FORNECE"})
		nPos7 := Ascan(aArray[1],{|x| x[1] == "E2_LOJA"})

		DbSelectArea("SE2")
		DbSetOrder(1)
		If Dbseek(Avkey(aArray[1,nPos1,2],"E2_FILIAL")+Avkey(aArray[1,nPos2,2],"E2_PREFIXO")+Avkey(aArray[1,nPos3,2],"E2_NUM")+Avkey(aArray[1,nPos4,2],"E2_PARCELA")+Avkey(aArray[1,nPos5,2],"E2_TIPO")+Avkey(aArray[1,nPos6,2],"E2_FORNECE")+Avkey(aArray[1,nPos7,2],"E2_LOJA"))
			cRet := "#AVISO"
			cMensagemErro := "Titulo ja lançado "+cvaltochar(SE2->(Recno()))
			U_TINCGRLG(nRecP98,0,"SE2",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
		Else 
			aCab := CabecExc(aArray,cTabela,oIntegraMais)

			nPos1 := Ascan(aCab,{|x| x[1] == "E2_BCOPAG"})
			
			If nPos1 > 0
				cBco  := aCab[nPos1,2]
				aCab[nPos1,2] := ''
			EndIF 
			
			//Data valida no vencimento real
			nPos4 := Ascan(aCab,{|x| x[1] == "E2_VENCREA"})
			
			If nPos4 > 0
				If aCab[nPos4,02] <> datavalida(aCab[nPos4,02])
					aCab[nPos4,02] := datavalida(aCab[nPos4,02])
				EndIF 
			EndIF 

			lMsErroAuto := .F.
			MSExecAuto({|x,y| FINA050(x,y)}, aCab, 3)

			If lMsErroAuto
				cRet := "#Erro"
				cMensagemErro := mostraerro('\SYSTEM\')
				U_TINCGRLG(nRecP98,0,"SE2",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
			Else
				nRecFim := SE2->(Recno())
				cRet := "#Sucesso"
				cDetalhe := "Recno tabela SE2 - "+cvaltochar(SE2->(Recno()))
				
				U_TINCGRLG(nRecP98,nRecFim,"SE2",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
				If !Empty(cBco)
					Reclock("SE2",.F.)
					SE2->E2_BCOPAG := cBco
					SE2->(MSUnlock())
				EndIf 
			EndIF 
		EndIf 
	ElseIf cTabela == "SE5"
		nPos1 := Ascan(aArray[1],{|x| x[1] == "E5_FILIAL"})
		nPos2 := Ascan(aArray[1],{|x| x[1] == "E5_PREFIXO"})
		nPos3 := Ascan(aArray[1],{|x| x[1] == "E5_NUMERO"})
		nPos4 := Ascan(aArray[1],{|x| x[1] == "E5_PARCELA"})
		nPos5 := Ascan(aArray[1],{|x| x[1] == "E5_TIPO"})
		nPos6 := Ascan(aArray[1],{|x| x[1] == "E5_CLIFOR"})
		nPos7 := Ascan(aArray[1],{|x| x[1] == "E5_LOJA"})

		DbSelectArea("SE5")
		DbSetOrder(1)
		If Dbseek(Avkey(aArray[1,nPos1,2],"E5_FILIAL")+Avkey(aArray[1,nPos2,2],"E5_PREFIXO")+Avkey(aArray[1,nPos3,2],"E5_NUMERO")+Avkey(aArray[1,nPos4,2],"E5_PARCELA")+Avkey(aArray[1,nPos5,2],"E5_TIPO")+Avkey(aArray[1,nPos6,2],"E5_CLIFOR")+Avkey(aArray[1,nPos7,2],"E5_LOJA"))
			cRet := "#AVISO"
			cMensagemErro := "Titulo ja lançado "+cvaltochar(SE5->(Recno()))
			U_TINCGRLG(nRecP98,0,"SE5",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
		Else 
			aCab := CabecExc(aArray,cTabela,oIntegraMais)

			nPos1 := Ascan(aCab,{|x| x[1] == "E5_BANCO"})
			nPos2 := Ascan(aCab,{|x| x[1] == "E5_AGENCIA"})
			nPos3 := Ascan(aCab,{|x| x[1] == "E5_CONTA"})
			nPos4 := Ascan(aCab,{|x| x[1] == "E5_RECPAG"})
			If nPos4 > 0
				nTipo  := If(aCab[nPos4,2]=="R",4,3)
			EndIF 

			DbSelectArea("SA6")
			DbSetOrder(1)
			If !DbSeek(xFilial("SA6")+Avkey(aCab[nPos1,2],"A6_COD")+Avkey(aCab[nPos2,2],"A6_AGENCIA")+Avkey(aCab[nPos3,2],"A6_NUMCON"))
				cBco  := aCab[nPos1,2]
				cAge  := aCab[nPos2,2]
				cCta  := aCab[nPos3,2]
				aCab[nPos1,2] := 'CX1'
				aCab[nPos2,2] := '0000 '
				aCab[nPos3,2] := '000000      '
			EndIf 

			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| FINA100(x,y,z)}, 0 , aCab, nTipo)

			If lMsErroAuto
				cRet := "#Erro"
				cMensagemErro := mostraerro('\SYSTEM\')
				U_TINCGRLG(nRecP98,0,"SE5",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
			Else
				nRecFim := SE5->(Recno())
				cRet := "#Sucesso"
				cDetalhe := "Recno tabela SE5 - "+cvaltochar(SE5->(Recno()))
				
				U_TINCGRLG(nRecP98,nRecFim,"SE5",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
				If !Empty(cBco)
					Reclock("SE5",.F.)
					SE5->E5_BANCO  := cBco
					SE5->E5_AGENCIA:= cAge
					SE5->E5_CONTA  := cCta
					SE5->(MSUnlock())
				EndIf 
			EndIF 
		EndIf
	ElseIf cTabela == "SC5"
		aCab := CabecExc(aArray,cTabela,oIntegraMais)
		//Tratamento para condições de pagamento do tipo 9
		//trocar para 000 a vista e depois de gerar o pedido voltar para a original do arquivo
		nPosCnd := Ascan(aCab,{|x| x[1] == "C5_CONDPAG"})
		If nPosCnd > 0
			lCondPg9 := Posicione("SE4",1,xFilial("SE4")+aCab[nPosCnd,2],"E4_TIPO") == "9"
			cBkpCnd  := aCab[nPosCnd,2]
			aCab[nPosCnd,2] := "000"
		EndIF 

		aItens := ItensExc(aArray,'SC6',oIntegraMais)

		lMsErroAuto := .F.

		cFilant := If(oIntegraMais<>Nil,oIntegraMais:cFildest,cFilDest)

		nPos1 := Ascan(aArray[1],{|x| x[1] == "C5_FILIAL"})
		nPos2 := Ascan(aArray[1],{|x| x[1] == "C5_NUM"})
		DbSelectArea("SC5")
		DbSetOrder(1)
		If Dbseek(Avkey(aArray[1,nPos1,2],"C5_FILIAL")+Avkey(aArray[1,nPos2,2],"C5_NUM"))
			cRet := "#AVISO"
			cMensagemErro := "Pedido ja lançado "+cvaltochar(SC5->(Recno()))
			U_TINCGRLG(nRecP98,0,"SC5",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			For nY := 2 to len(aArray)
				nPos1 := Ascan(aArray[nY],{|x| x[1] == "C6_P98REC"})
				U_TINCGRLG(aArray[nY,nPos1,2],0,"SC6",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			Next nY 
		Else 

			MsExecAuto( { | x, y, z | Mata410( x, y, z ) }, aCab, aItens, 3 )

			If lMsErroAuto
				cRet := "#Erro"
				cMensagemErro := mostraerro('\SYSTEM\')
				U_TINCGRLG(nRecP98,0,"SC5",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				For nY := 2 to len(aArray)
					nPos1 := Ascan(aArray[nY],{|x| x[1] == "C6_P98REC"})
					U_TINCGRLG(aArray[nY,nPos1,2],0,"SC6",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				Next nY 
			Else
				nRecFim := SC5->(Recno())
				cRet := "#Sucesso"
				cDetalhe := "Recno tabela SC5 - "+cvaltochar(SC5->(Recno()))
				
				U_TINCGRLG(nRecP98,nRecFim,"SC5",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
				For nY := 2 to len(aArray)
					nPos1 := Ascan(aArray[nY],{|x| x[1] == "C6_FILIAL"})
					nPos2 := Ascan(aArray[nY],{|x| x[1] == "C6_NUM"})
					nPos3 := Ascan(aArray[nY],{|x| x[1] == "C6_ITEM"})
					nPos4 := Ascan(aArray[nY],{|x| x[1] == "C6_PRODUTO"})
					nPos5 := Ascan(aArray[nY],{|x| x[1] == "C6_P98REC"})

					DbSelectArea("SC6")
					DbSetOrder(1)
					If Dbseek(Avkey(aArray[nY,nPos1,2],"C6_FILIAL")+Avkey(aArray[nY,nPos2,2],"C6_NUM")+Avkey(aArray[nY,nPos3,2],"C6_ITEM")+Avkey(aArray[nY,nPos4,2],"C6_PRODUTO"))
						cDetalhe += " # Recno tabela SC6 - "+cvaltochar(SC6->(Recno()))
						U_TINCGRLG(aArray[nY,nPos5,2],SC6->(Recno()),"SC6",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
					EndIf 
				Next nY 

				If lCondPg9
					Reclock("SC5",.F.)
					SC5->C5_CONDPAG := cBkpCnd
					SC5->(MSUnlock())
				EndIf 
			EndIf
		EndIf 
	ElseIf cTabela == "SF2"
		aCab := CabecExc(aArray,cTabela,oIntegraMais)
		
		aItens := ItensExc(aArray,'SD2',oIntegraMais)

		lMsErroAuto := .F.

		cFilant := If(oIntegraMais<>Nil,oIntegraMais:cFildest,cFilDest)

		nPos1 := Ascan(aArray[1],{|x| x[1] == "F2_FILIAL"})
		nPos2 := Ascan(aArray[1],{|x| x[1] == "F2_DOC"})
		nPos3 := Ascan(aArray[1],{|x| x[1] == "F2_SERIE"})
		nPos4 := Ascan(aArray[1],{|x| x[1] == "F2_CLIENTE"})
		nPos5 := Ascan(aArray[1],{|x| x[1] == "F2_LOJA"})

		DbSelectArea("SF2")
		DbSetOrder(1)
		If Dbseek(Avkey(aArray[1,nPos1,2],"F2_FILIAL")+Avkey(aArray[1,nPos2,2],"F2_DOC")+Avkey(aArray[1,nPos3,2],"F2_SERIE")+Avkey(aArray[1,nPos4,2],"F2_CLIENTE")+Avkey(aArray[1,nPos5,2],"F2_LOJA"))
			cRet := "#AVISO"
			cMensagemErro := "Nota ja lançada "+cvaltochar(SF2->(Recno()))
			U_TINCGRLG(nRecP98,0,"SF2",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			For nY := 2 to len(aArray)
				nPos1 := Ascan(aArray[nY],{|x| x[1] == "D2_P98REC"})
				U_TINCGRLG(aArray[nY,nPos1,2],0,"SD2",cRet,cMensagemErro,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			Next nY 
		Else 

			MsExecAuto( { |x, y, z | Mata920( x, y, z ) }, aCab, aItens, 3 )

			If lMsErroAuto
				cRet := "#Erro"
				cMensagemErro := mostraerro('\SYSTEM\')
				U_TINCGRLG(nRecP98,0,"SF2",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				For nY := 2 to len(aArray)
					nPos1 := Ascan(aArray[nY],{|x| x[1] == "D2_P98REC"})
					U_TINCGRLG(aArray[nY,nPos1,2],0,"SD2",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				Next nY 
			Else
				nRecFim := SF2->(Recno())
				cRet := "#Sucesso"
				cDetalhe := "Recno tabela SF2 - "+cvaltochar(SF2->(Recno()))
				
				U_TINCGRLG(nRecP98,nRecFim,"SF2",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
				For nY := 2 to len(aArray)
					nPos1 := Ascan(aArray[nY],{|x| x[1] == "D2_FILIAL"})
					nPos2 := Ascan(aArray[nY],{|x| x[1] == "D2_DOC"})
					nPos3 := Ascan(aArray[nY],{|x| x[1] == "D2_SERIE"})
					nPos4 := Ascan(aArray[nY],{|x| x[1] == "D2_CLIENTE"})
					nPos5 := Ascan(aArray[nY],{|x| x[1] == "D2_LOJA"})
					nPos6 := Ascan(aArray[nY],{|x| x[1] == "D2_P98REC"})

					DbSelectArea("SD2")
					DbSetOrder(3)
					If Dbseek(Avkey(aArray[nY,nPos1,2],"D2_FILIAL")+Avkey(aArray[nY,nPos2,2],"D2_DOC")+Avkey(aArray[nY,nPos3,2],"D2_SERIE")+Avkey(aArray[nY,nPos4,2],"D2_CLIENTE")+Avkey(aArray[nY,nPos5,2],"D2_LOJA"))
						cDetalhe += " # Recno tabela SD2 - "+cvaltochar(SD2->(Recno()))
						U_TINCGRLG(aArray[nY,nPos6,2],SD2->(Recno()),"SD2",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
					EndIf 
				Next nY 

				
			EndIf
		EndIf 
		
	ElseIf cTabela == "CT2"
		nPos1 := Ascan(aArray[1],{|x| x[1] == "CT2_DATA"})
		nPos2 := Ascan(aArray[1],{|x| x[1] == "CT2_LOTE"})
		nPos3 := Ascan(aArray[1],{|x| x[1] == "CT2_SBLOTE"})
		nPos4 := Ascan(aArray[1],{|x| x[1] == "CT2_DOC"})
		
		aCab	:= 	{ 	{'DDATALANC' 	, aArray[1,nPos1,2]					,NIL},;
						{'CLOTE' 		, aArray[1,nPos2,2]					,NIL},;
						{'CSUBLOTE' 	, aArray[1,nPos3,2] 				,NIL},;
						{'CDOC' 		, aArray[1,nPos4,2]				 	,NIL},;
						{'CPADRAO' 		, ''								,NIL},;
						{'NTOTINF' 		, 0 								,NIL},;
						{'NTOTINFLOT' 	, 0 								,NIL} }

		For nY := 1 to len(aArray)
			Aadd(aItens,aArray[nY])
		Next nY 

		MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3)

		If lMsErroAuto
			cRet := "#Erro"
			cMensagemErro := mostraerro('\SYSTEM\')
			//U_TINCGRLG(nRecP98,0,"CT2",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			For nY := 1 to len(aArray)
				nPos1 := Ascan(aArray[nY],{|x| x[1] == "CT2_P98REC"})
				U_TINCGRLG(aArray[nY,nPos1,2],0,"CT2",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			Next nY 
		Else
			nRecFim := CT2->(Recno())
			cRet := "#Sucesso"
			
			aRecCt2 := RecnCT2(aCab[1,2],aCab[2,2],aCab[3,2],aCab[4,2])

			For nY := 1 to len(aArray)
				nPos1 := Ascan(aArray[nY],{|x| x[1] == "CT2_LINHA"})
				nPos2 := Ascan(aRecCt2,{|x| x[1] == aArray[nY,nPos1,2]})
				nPos3 := Ascan(aArray[nY],{|x| x[1] == "CT2_P98REC"})
				cDetalhe := " # Recno tabela CT2 - "+cvaltochar(aRecCt2[nPos2,2])
				U_TINCGRLG(aArray[nY,nPos3,2],aRecCt2[nPos2,2],"CT2",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			Next nY 

				
		EndIf 

	ElseIf cTabela == "SN1"
		oModel := FWLoadModel("ATFA012")
		oModel:SetOperation(MODEL_OPERATION_INSERT )
		oModel:Activate()

		PrCabec(@oModel, aArray, cTabela, oIntegraMais)
		PrItemMVC(@oModel, aArray, cTabela, oIntegraMais)

		if oModel:VldData()
			oModel:CommitData()

			cRet := "#Sucesso"
			cDetalhe := "Recno tabela SN1 - "+cvaltochar(SN1->(Recno()))
			cDetalhe += " # Recno tabela SN3 - "+cvaltochar(SN3->(Recno()))
			U_TINCGRLG(nRecP98,SN1->(Recno()),"SN1",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			U_TINCGRLG(nRec2P98,SN3->(Recno()),"SN3",cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

			nPos := Ascan(aArray[2],{|x| x[1] == "N3_DINDEPR"})
			//Alteração para alterar a data de inicio de depreciação na N3, o execauto mantem a data do dia de inclusão
			If nPos > 0
				Reclock("SN3",.F.)
				cConteudo := aArray[2,nPos,02]
				if valtype(cConteudo) <> "D"
					cConteudo := IF(!"/" $ cConteudo,stod(cConteudo),ctod(cConteudo))
				endif 

				SN3->N3_DINDEPR := cConteudo
				SN3->(MSUnlock())
			EndIf 
			
		else
			disarmTransaction()
			aErro := oModel:GetErrorMessage()
								
			/*AutoGrLog( "Id do formulário de origem:"+ ' [' + AllToChar( aErro[1] ) + ']')
			AutoGrLog( "Id do campo de origem: " 	+ ' [' + AllToChar( aErro[2] ) + ']')
			AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']')
			AutoGrLog( "Id do campo de erro: " 		+ ' [' + AllToChar( aErro[4] ) + ']')
			AutoGrLog( "Id do erro: " 				+ ' [' + AllToChar( aErro[5] ) + ']')
			AutoGrLog( "Mensagem do erro: " 		+ ' [' + AllToChar( aErro[6] ) + ']')
			AutoGrLog( "Mensagem da solução: " 		+ ' [' + AllToChar( aErro[7] ) + ']')
			AutoGrLog( "Valor atribuído: " 			+ ' [' + AllToChar( aErro[8] ) + ']')
			AutoGrLog( "Valor anterior: " 			+ ' [' + AllToChar( aErro[9] ) + ']')*/

			cMensagemErro := AllToChar( aErro[1] ) +CRLF
			cMensagemErro += AllToChar( aErro[2] ) +CRLF
			cMensagemErro += AllToChar( aErro[3] ) +CRLF
			cMensagemErro += AllToChar( aErro[4] ) +CRLF
			cMensagemErro += AllToChar( aErro[5] ) +CRLF
			cMensagemErro += AllToChar( aErro[6] ) +CRLF
			cMensagemErro += AllToChar( aErro[7] ) +CRLF
			cMensagemErro += AllToChar( aErro[8] ) +CRLF
			cMensagemErro += AllToChar( aErro[9] ) +CRLF

			cRet := "#Erro"
			U_TINCGRLG(nRecP98,0,"SN1",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
			U_TINCGRLG(nRec2P98,0,"SN3",cRet,cMensagemErro,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

			lMsErroAuto := .T.
		endIf

		oModel:DeActivate()
		oModel:Destroy()
		oModel:= nil
	EndIf 

	RestArea(aArea)

Return(cRet)

//--------------------------------------------------
/*/{Protheus.doc} CabecExc
Trata o cabeçalho do execauto normal.

@author Alexandre Venancio
@since 04/04/2025
/*/
//--------------------------------------------------
Static Function CabecExc(aArray,cTabela,oIntegraMais)

	Local aArea := GetArea()
	Local aRet	:=	{}
	Local nZ 
	Local aEstrX3 := If(oIntegraMais<>Nil,oIntegraMais:aEstrutura,aEstrX3)
	Local nPsX3 := ascan(aEstrX3,{|x| x[LEN(X)] == cTabela})

	For nZ := 1 to len(aArray[1])
		If SUBSTR(aArray[1,nZ,01],at("_",aArray[1,nZ,01])+1) $ 'P98REC/P98STA'
			loop 
		EndIf 
		nPos := Ascan(aEstrX3[nPsX3],{|x| x[1] == aArray[1,nZ,1]}) 
		If nPos > 0 
			cConteudo := aArray[1,nZ,2]
			If valtype(cConteudo) <> aEstrX3[nPsX3,nPos,2]
				If aEstrX3[nPsX3,nPos,2] == "C" .And. valtype(cConteudo) <> "C"
					cConteudo := cvaltochar(cConteudo)
				ElseIf aEstrX3[nPsX3,nPos,2] == "D" .And. valtype(cConteudo) <> "D"
					cConteudo := IF(!"/" $ cConteudo,stod(cConteudo),ctod(cConteudo))
				ElseIf aEstrX3[nPsX3,nPos,2] == "N" .And. valtype(cConteudo) <> "N"
					cConteudo := val(cConteudo)
				EndIf 
			EndIf 
			
			IF valtype(cConteudo) == "C"
				cConteudo := alltrim(cConteudo)
			EndIf 

			Aadd(aRet,{aArray[1,nZ,1] , cConteudo , Nil })
		EndIf 
	Next nZ

	RestArea(aArea)

Return(aRet)

//--------------------------------------------------
/*/{Protheus.doc} ItensExc
Trata o cabeçalho do execauto normal.

@author Alexandre Venancio
@since 04/04/2025
/*/
//--------------------------------------------------
Static Function ItensExc(aArray,cTabela,oIntegraMais)

	Local aArea := GetArea()
	Local aRet	:=	{}
	Local aAux  :=  {}
	Local nZ,nX 
	Local aEstrX3 := If(oIntegraMais<>Nil,oIntegraMais:aEstrutura,aEstrX3)
	Local nPsX3 := ascan(aEstrX3,{|x| x[LEN(X)] == cTabela})

	For nX := 2 to len(aArray)
		aAux := {}
		For nZ := 1 to len(aArray[nX])
			If SUBSTR(aArray[nX,nZ,01],at("_",aArray[nX,nZ,01])+1) $ 'P98REC/P98STA'
				loop 
			EndIf 
			nPos := Ascan(aEstrX3[nPsX3],{|x| x[1] == aArray[nX,nZ,1]}) 
			If nPos > 0 
				cConteudo := aArray[nX,nZ,2]
				If valtype(cConteudo) <> aEstrX3[nPsX3,nPos,2]
					If aEstrX3[nPsX3,nPos,2] == "C" .And. valtype(cConteudo) <> "C"
						cConteudo := cvaltochar(cConteudo)
					ElseIf aEstrX3[nPsX3,nPos,2] == "D" .And. valtype(cConteudo) <> "D"
						cConteudo := IF(!"/" $ cConteudo,stod(cConteudo),ctod(cConteudo))
					ElseIf aEstrX3[nPsX3,nPos,2] == "N" .And. valtype(cConteudo) <> "N"
						cConteudo := val(cConteudo)
					EndIf 
				EndIf 
				
				IF valtype(cConteudo) == "C"
					cConteudo := alltrim(cConteudo)
				EndIf 
				
				Aadd(aAux,{aArray[nX,nZ,1] , cConteudo , Nil })
			EndIf 
		Next nZ

		Aadd(aRet,aAux)
	Next nX

	RestArea(aArea)

Return(aRet)
//--------------------------------------------------
/*/{Protheus.doc} PrCabec
Trata o cabeçalho do execauto via mvc.

@author Alexandre Venancio
@since 10/10/2024
/*/
//--------------------------------------------------
static function PrCabec(oModel,aArray,cTabela,oIntegraMais)

	Local aArea := GetArea()	
	Local nZ 
	Local aEstrX3 := If(oIntegraMais<>Nil,oIntegraMais:aEstrutura,aEstrX3)
	Local nPsX3 := ascan(aEstrX3,{|x| x[LEN(X)] == cTabela})
	Local nPos
	//Local cExcCpo := SuperGetMV("TI_XCPOEXC",.F.,"N1_CONSAB/N3_NOVO")
	/*oModel:SetValue( "SN1MASTER",  "N1_FILIAL", fwxFilial("SN1"))
	oModel:SetValue( "SN1MASTER",  "N1_GRUPO", cGrupo			)*/

	For nZ := 1 to len(aArray[1])
		If SUBSTR(aArray[1,nZ,01],at("_",aArray[1,nZ,01])+1) $ 'P98REC/P98STA'
			loop 
		EndIf 
		nPos := Ascan(aEstrX3[nPsX3],{|x| x[1] == aArray[1,nZ,1]}) 
		If nPos > 0 //.And. !Alltrim(aArray[1,nZ,1]) $ cExcCpo
			cConteudo := aArray[1,nZ,2]
			If valtype(cConteudo) <> aEstrX3[nPsX3,nPos,2]
				If aEstrX3[nPsX3,nPos,2] == "C" .And. valtype(cConteudo) <> "C"
					cConteudo := cvaltochar(cConteudo)
				ElseIf aEstrX3[nPsX3,nPos,2] == "D" .And. valtype(cConteudo) <> "D"
					cConteudo := IF(!"/" $ cConteudo,stod(cConteudo),ctod(cConteudo))
				ElseIf aEstrX3[nPsX3,nPos,2] == "N" .And. valtype(cConteudo) <> "N"
					cConteudo := val(cConteudo)
				EndIf 
			EndIf 
			oModel:SetValue( "SN1MASTER",  aArray[1,nZ,1] , cConteudo )
		EndIf 
	Next nZ 
	
	RestArea(aArea)

return
//--------------------------------------------------
/*/{Protheus.doc} PrItemMVC
Trata os itens do execauto via mvc.

@author Alexandre Venancio
@since 10/10/2024
/*/
//--------------------------------------------------
static function PrItemMVC(oModel, aArray, cTabela, oIntegraMais)
	
	Local aArea := GetArea()
	Local nZ 
	Local aEstrX3 := If(oIntegraMais<>Nil,oIntegraMais:aEstrutura,aEstrX3)
	//Local cExcCpo := SuperGetMV("TI_XCPOEXC",.F.,"N1_CONSAB/N3_NOVO")
	Local nPsX3 := ascan(aEstrX3,{|x| x[LEN(X)] == 'SN3'})
		
	oModel:GetModel("SN3DETAIL"):AddLine()

	For nZ := 1 to len(aArray[2])
		If SUBSTR(aArray[2,nZ,01],at("_",aArray[2,nZ,01])+1) $ 'P98REC/P98STA'
			loop 
		EndIf 

		nPos := Ascan(aEstrX3[nPsX3],{|x| x[1] == aArray[2,nZ,1]}) 
		If nPos > 0 //.And. !Alltrim(aArray[2,nZ,1]) $ cExcCpo
			cConteudo := aArray[2,nZ,2]
			If valtype(cConteudo) <> aEstrX3[nPsX3,nPos,2]
				If aEstrX3[nPsX3,nPos,2] == "C" .And. valtype(cConteudo) <> "C"
					cConteudo := cvaltochar(cConteudo)
				ElseIf aEstrX3[nPsX3,nPos,2] == "D"  .And. valtype(cConteudo) <> "D"
					cConteudo := IF(!"/" $ cConteudo,stod(cConteudo),ctod(cConteudo))
				ElseIf aEstrX3[nPsX3,nPos,2] == "N" .And. valtype(cConteudo) <> "N"
					cConteudo := val(cConteudo)
				EndIf 
			EndIf 

			If oModel:CanSetValue("SN3DETAIL", aArray[2,nZ,1])
				oModel:SetValue( "SN3DETAIL",  aArray[2,nZ,1], cConteudo)
			else		
				oModel:LoadValue("SN3DETAIL",  aArray[2,nZ,1], cConteudo)
			EndIf
		EndIf 
	Next nZ 
		
	RestArea(aArea)		
	
return
//--------------------------------------------------
/*/{Protheus.doc} FTrataErro
Trata o MostraErro identificando o erro e a solução.

@author Alexandre Venancio
@since 10/10/2024
/*/
//--------------------------------------------------
Static Function FTrataErro(cTexto)

	Local cRetorno := ""
	Local nX := 1
	Local aTexto := {}

	aTexto := Separa(cTexto,CRLF)

	For nX := 1 To Len(aTexto)
		If !Empty(aTexto[nX])
			If 	"-- Invalido" $ aTexto[nX] .OR. ;
					"Mensagem do erro:" $ aTexto[nX] .OR. ;
					"Mensagem da solucao:" $ aTexto[nX]
				cRetorno += aTexto[nX] + " / "
			EndIf
		EndIf
	Next nX

	While "  " $ cRetorno
		cRetorno := StrTran(cRetorno , "  " , " ")
	EndDo

	cRetorno := StrTran(cRetorno , ";" , "**")

Return cRetorno

/*/{Protheus.doc} RecnCT2
	Busca o recno dos lotes gerados na CT2 pelo execauto
	@type  Static Function
	@author user
	@since 07/04/2025
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function RecnCT2(dData,cLote,cSbLote,cDoc)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT CT2_LINHA,R_E_C_N_O_ AS RECCT2"
cQuery += " FROM "+RetSQLName("CT2")
cQuery += " WHERE CT2_FILIAL='"+cFilant+"' AND CT2_DATA='"+dtos(dData)+"' AND CT2_LOTE='"+cLote+"' AND CT2_SBLOTE='"+cSbLote+"'" // AND CT2_DOC='"+cDoc+"'"
cQuery += " AND D_E_L_E_T_=' '"

If Select('TRBCT2') > 0
    dbSelectArea('TRBCT2')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRBCT2", .F., .T. )

DbSelectArea("TRBCT2")

While !EOF()
	Aadd(aRet,{TRBCT2->CT2_LINHA,TRBCT2->RECCT2})
	Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
/*/{Protheus.doc} GrRcLk
	Registros que serão gravados via reclock
	na versão do migratotvs eles eram salvos via insert direto no banco
	porém, isso causa problema se não abrisse a tabela na sequencia.
	@author user
	@since 27/06/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function GrRcLk(aArray,cTabela,nRecP98,cUsrLog,/*cTextoLog,*/oIntegraMais)

	Local aArea := GetArea()
	Local cRet  := ""
	Local cLog	:= ""
	Local nCont 
	Local nZ 
	Local aReturn := {}
	Local aDicion := {}


	if IsInCallStack( "U_IM_MD_02_ThreadAuxiliarMigracaoDados" )

		aReturn:= FwSX2Util():GetSX2data(cTabela, {"X2_UNICO"})
		aDicion := FWSX3Util():GetListFieldsStruct( cTabela , .F. )
		aAux := FWSX3Util():GetFieldStruct( cTabela )

	Else 
		//trocar pelo array aX2Unq
		nPosX2 := Ascan(aX2Unq,{|x| x[1] == cTabela})

		If nPosX2 > 0
			Aadd(aReturn,aX2Unq[nPosX2])
		Else 
			aReturn:= FwSX2Util():GetSX2data(cTabela, {"X2_UNICO"})
		EndIf 
	EndIf

	DbSelectArea(cTabela)

	If len(aReturn) > 0
		cChave := ''
		If !Empty(alltrim(aReturn[1,2]))
			//aReturn[1,2] := strtran(strtran(aReturn[1,2],"DTOS(",""),")","")
			aAux := Separa(aReturn[1,2],"+")
			For nCont := 1 to len(aAux)
				//nPos := Ascan(aArray,{|x| alltrim(x[1]) == alltrim(aAux[nCont])})
				nPos := Ascan(aArray,{|x| alltrim(x[1]) == strtran(strtran(alltrim(aAux[nCont]),"DTOS(",""),")","")})
				If nPos == 0
					lKey := .F.
					cChave:= ''
					exit
				Else 
					If "DTOS" $ aAux[nCont]
						cChave += Avkey(aArray[nPos,2],dtos(ctod(aAux[nCont])))
					Else 
						cChave += Avkey(aArray[nPos,2],aAux[nCont])
					EndIf 
				EndIf 
			Next nCont
		Else 
				
			If cTabela $ "PHH/SE5"
				aInd := FWSIXUtil():GetAliasIndexes( cTabela  )

				If cTabela == "PHH"
					aAux := aInd[6]
				ElseIf cTabela == "SE5"
					aAux := aInd[7]
				EndIF 
			
				For nCont := 1 to len(aAux)
					nPos := Ascan(aArray,{|x| alltrim(x[1]) == alltrim(aAux[nCont])})
					If nPos > 0
						cChave += Avkey(aArray[nPos,2],aAux[nCont])
					EndIf 
				Next nCont
			EndIf 
		EndIf 
		
		If !Empty(cChave)
			if !IsInCallStack( "U_IM_MD_02_ThreadAuxiliarMigracaoDados" )
				nPosX3 := Ascan(aEstrX3,{|x| x[len(x)] == cTabela})
				If nPosX3 > 0
					aDicion := aEstrX3[nPosX3]
				EndIf 
			EndIf	
			//Algumas tabelas precisam alterar o indice para uma validação completa
			If cTabela == 'SD2'
				DbSetOrder(24)
			ElseIf cTabela == "PHH"
				DbSetOrder(6)
			ElseIf cTabela == "SE5"
				DbSetOrder(7)
			Else
				DbSetOrder(1)
			EndIf

			If !Dbseek(cChave)
				Reclock(cTabela,.T.)
				lGrava := .T.
			Else
				Reclock(cTabela,.F.)
				lGrava := .F.
			EndIf
			
				For nZ := 1 to len(aArray)  //-2 porque os dois ultimos registros do array são o recno e status da p98
					If SUBSTR(aArray[nZ,01],at("_",aArray[nZ,01])+1) $ 'P98REC/P98STA'
						loop 
					EndIf 
					
					if !IsInCallStack( "U_IM_MD_02_ThreadAuxiliarMigracaoDados" )
						If nPosX3 > 0
							nPosX3c := Ascan(aDicion,{|x| alltrim(x[1]) == alltrim(aArray[nZ,01])})
							If nPosX3c > 0
								aAux := aDicion[nPosX3c]
							else 
								loop
							EndIf 
						Else 
							aAux := FWSX3Util():GetFieldStruct( aArray[nZ,01] )
						EndIf 
					EndIf

					If aAux[2] == "D" .And. valtype(aArray[nZ,02]) <> "D"
						cLog += aArray[nZ,01]+' = '+DtoS(&(cTabela+"->"+aArray[nZ,01])) +"| "
						&(cTabela+"->"+aArray[nZ,01]) := ctod(aArray[nZ,02])

					ElseIf aAux[2] == "N" .And. valtype(aArray[nZ,02]) <> "N"
						cLog += aArray[nZ,01]+' = '+cvaltochar(&(cTabela+"->"+aArray[nZ,01])) +"| "
						&(cTabela+"->"+aArray[nZ,01]) := val(aArray[nZ,02])

					ElseIf aAux[2] == "C"
						cLog += aArray[nZ,01]+' = '+&(cTabela+"->"+aArray[nZ,01]) +"|"
						&(cTabela+"->"+aArray[nZ,01]) := cvaltochar(aArray[nZ,02])

					Else 
					cLog += aArray[nZ,01]+' = '+ cvaltochar(&(cTabela+"->"+aArray[nZ,01])) +"| "
						&(cTabela+"->"+aArray[nZ,01]) := aArray[nZ,02]

					EndIf 
				
				Next nZ

				&(cTabela)->(Msunlock())
			If lGrava

				cRet := "#Sucesso"
				cDetalhe := "Recno tabela "+cTabela+" - "+cvaltochar(&(cTabela)->(Recno()))
				U_TINCGRLG(nRecP98,&(cTabela)->(Recno()),cTabela,cRet,cDetalhe,'1',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)
				
			Else 
				
				cRet := "#Sucesso"
				cDetalhe :=  "Registro Atualizado na tabela "+cTabela+" - Recno "+cvaltochar(&(cTabela)->(Recno())) +" |# CONTEUDO ANTIGO #| "+ cLog
				U_TINCGRLG(nRecP98,&(cTabela)->(Recno()),cTabela,cRet,cDetalhe,'2',.F.,cUsrLog,/*cTextoLog,*/oIntegraMais)

			EndIf 
		EndIf 

	EndIf   

	RestArea(aArea)

Return(cRet)


//--------------------------------------------------
/*/{Protheus.doc} NextHLock
Confirma a numeração automática.

@author Totvs Matriz
@since 01/04/2020
/*/
//--------------------------------------------------
Static Function NextHLock(cAlias,cCampo,nIndice,lRollBack)

	Local nSaveSx8	:= GetSx8Len()
	Local cCodigo   := ""
	Local cMay      := ""
	Local aArea     := GetArea()

	DEFAULT lRollBack := .F.

	//GetArea( aArea, cAlias )

	cCodigo := GetSX8Num(cAlias,cCampo)
	FreeUsedCode()
	cMay    := Alltrim(xFilial(cAlias))+cCodigo

	(cAlias)->(dbSetOrder(nIndice) )

	Do While (cAlias)->(dbSeek(xFilial(cAlias)+cCodigo) ) .Or. !MayIUseCode(cMay)
		Do While (GetSX8Len() > nSaveSx8)
			ConfirmSx8()
		EndDo

		cCodigo := GetSX8Num(cAlias,cCampo)
		FreeUsedCode()
		cMay    := Alltrim(xFilial(cAlias))+cCodigo
	EndDo

	If lRollBack .And. __lSX8
		RollBackSX8()
		cCodigo := ""
	EndIf

	RestArea( aArea )

Return cCodigo

/*/{Protheus.doc} TINCGRLG
	Grava o log de execução da migração
	@author user
	@since 03/07/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function TINCGRLG(nRecOri,nRecDest,cTabela,cStatus,cDetalhe,cStsP98,lFKs,cUsrLog,/*cTextoLog,*/oIntegraMais)

	Local aArea 	:= GetArea()
	// Local cFimLog	:= Time()
	Local cCodPWU 	:= ''
	Local cUpdate	:= ''
	Local cTabTmp	:= ''
	Local cCodP98   := ''
	Local cPrfxCpo	:= ''
	Local lSucesso	:= .F.

	If !lFKs .And. nRecOri > 0
		DbSelectArea("P98")
		DbGoTo(nRecOri)
		RecLock('P98',.F.)
		P98->P98_STATUS := cStsP98
		P98->P98_DATPRO := Date()
		P98->P98_TIMERP := Time()
		P98->(Msunlock())

		cCodP98 := P98->P98_COD

		If oIntegraMais <> Nil 
			// Atualiza as tabelas temporarias (BR's)
			If cTabela == oIntegraMais:cTabSX2Cabec
				cTabTmp := oIntegraMais:cTabAuxCabec
			ElseIf cTabela == oIntegraMais:cTabSX2Itens
				cTabTmp := oIntegraMais:cTabAuxItens
			EndIf
		EndIf 

		If !Empty(cTabTmp)
			cPrfxCpo := PrefixoCPO(cTabela)
			cUpdate := " UPDATE "+cTabTmp+" SET "+cPrfxCpo+"_P98STA = "+cStsP98+" WHERE "+cPrfxCpo+"_P98REC = "+cValToChar(nRecOri)
			If TCSQLEXEC(cUpdate) <> 0
				FWAlertError("Não foi possível alterar o STATUS da TABELA "+ cTabTmp + CRLF + TCSqlError(),"ATENÇÂO !!!")
			Else
				lSucesso := .T.
			EndIf
		EndIF
		
	EndIf

	cCodPWU := GetSXENum("PWU","PWU_CODIGO")
	ConfirmSX8()


	DbSelectArea("PWU")
	Reclock("PWU",.T.)

	PWU->PWU_FILIAL := xFilial("PWU")
	PWU->PWU_DATA 	:= dDataBase
	PWU->PWU_HORA	:= cvaltochar(Time())

	If !lFKs .And. nRecOri > 0
		PWU->PWU_RECN98	:= nRecOri
		PWU->PWU_CODP98 := cCodP98
	EndIf

	PWU->PWU_USER 	:= cUsrLog
	PWU->PWU_RESULT := cStatus
	PWU->PWU_DET	:= cDetalhe
	PWU->PWU_RECNDS := nRecDest
	PWU->PWU_TABELA := cTabela
	PWU->PWU_CODIGO := cCodPWU
	PWU->PWU_CODP97 := cCodigo 

	PWU->(Msunlock())

	//Escreve no arquivo
	/*If !Empty(cTextoLog)
		cTextoLog += 'Código P98: ' + cCodP98 +CRLF
		cTextoLog += 'Hora Fim: ' + cFimLog +CRLF
		cTextoLog += 'Status: ' + cStatus +CRLF
		cTextoLog += 'Recno Destino: '+ cValToChar(nRecDest) +CRLF
		cTextoLog += 'Detalhe: ' +cDetalhe +CRLF
		cTextoLog += 'Tempo Total: ' + ElapTime(cInicLog,Time()) +CRLF	
		cTextoLog += 'Log salvo na Tabela PWU - Código: ' + cCodPWU +CRLF
		cTextoLog += '| ------------------------------------------------------------------------------------ |' +CRLF

		U_xAcaLog(cLocArq,cTextoLog)
		cTextoLog := ''
	EndIf*/

	RestArea(aArea)

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} TINC341X

Funcao para gravar no cadatro de prospect o CGC sem picture 

@sample 	TINC341X( cCodigo, cLoja, lProspect, cCodVend, aNewSUS, cCdProsp, lRezDisTRod )

Retirado do fonte original, por conta de erro na rotina padrão

@author		Vendas CRM
@since		10/09/07
@version	12
/*/
//------------------------------------------------------------------------------

Static Function TINC341X( cCodigo, cLoja, lProspect, cCodVend, aNewSUS, cCdProsp, lRezDisTRod )

	Local cCodPro 		:= ""		 // Futuro codigo do novo prospect que sera INCLUIDO no SUS
	Local lRet 	  		:= .T.							 // Retorno da gravacao
	Local nCont     	:= 0 							 // Contador de campos
	Local nSaveSx8 		:= GetSX8Len()					 // Funcao de numeracao
	Local aContato		:= {}							 // Dados dos contatos copiados
	Local cChave 		:= ""		
	Local aAutoAO4		:= {}
	Local aAutoAO4Aux	:= {}

	Local aAmarra		:= {}
	//--------------------------------------------------------
	// Pontos de entrada da gravacao de Suspect para Prospect
	//--------------------------------------------------------
	Local lTMKSUSP  	:= ExistBlock( "TMKSUSP" )	  	 // P.E. ANTES da gravacap de Suspect para Prospect
	Local lTMKGRSP		:= ExistBlock( "TMKGRSP" )	  	 // P.E. DEPOIS da gravacao de Suspect para Prospect
	Local lProcADL      := GetMv( "MV_CRMADL",,.T. )     // Indica se a ADL deverá ter manutenção
	Local lAtuADL		:= .F.

	Local aRegs			:= {}							 // Retorno esperado do P.E. TK341GPROS 
	Local lTK341GPROS	:= ExistBlock( "TK341GPROS" ) 	 // P.E. DEPOIS da gravacao de Suspect para Prospect 
	Local lCRMAZS		:= SuperGetMv("MV_CRMUAZS",, .F.)
	Local cCodUsr		:= If(lCRMAZS, CRMXCodUser(), RetCodUsr()) 
	Local lPropri		:= .T.
	Local aRole			:= CRMXGetPaper() 

	Default cCodVend 	:= "" 	//Na qualificacao do suspect o atendente informará qual vendedor recebera a conta. 
	Default aNewSUS		:= {}
	Default cCdProsp	:= ""
	Default lRezDisTRod := .F.	

	If lCRMTerr == Nil
		lCRMTerr := SuperGetMV("MV_CRMTERR",.F.,.F.)
	EndIf

	If lProcADL 
		SX2->( DbSetOrder( 1 ) )
		lAtuADL := SX2->( DbSeek( "ADL" ) )
	EndIf

	//--------------------------------------
	// Ponto de Entrada antes da conversao 
	//--------------------------------------
	If lTMKSUSP              		
	lRet :=	U_TMKSUSP( cCodigo + cLoja ,, cCodVend)
	If ValType( lRet ) <> "L"
		lRet := .F.
	Endif   
	Endif
	//Somente para campos do usuario no cadastro de Prospect
	If !lRet 
	Return( lRet )
	Endif

	//-----------------------------------------------------------------------
	// Ponto de Entrada para pegar o conteudo dos campos especificos do SUS 
	//-----------------------------------------------------------------------
	If lTK341GPROS
		aRegs := ExecBlock( "TK341GPROS", .F., .F. )  
		If ValType( aRegs ) <> "A"
		aRegs := {}
	Endif   
	Endif

	//-------------------------------------------------------
	// Grava informacoes do ACH para o cadastro de Prospect	            
	//-------------------------------------------------------
	DbSelectarea("ACH")
	DbSetorder( 1 )
	If DbSeek( xFilial("ACH") + cCodigo + cLoja )	               
		//------------------------------------------------------------------------------
		// Valida se realmente nao tem um PROSPECT com o mesmo codigo no cadastro atual
		//------------------------------------------------------------------------------
		Begin Transaction

		If Empty(cCdProsp)
			cCodPro := TkNumero( "SUS", "US_COD" )
		Else  
			cCodPro := cCdProsp 
		EndIf 
		
		//----------------------------
		// Inicia a Gravacao no SUS  
		//----------------------------                
		DbSelectarea("SUS")
		Reclock( "SUS", .T. )
		Replace US_FILIAL	With xFilial("SUS")
		Replace US_COD	    With cCodPro
		Replace US_LOJA	    With ACH->ACH_LOJA
		Replace US_TIPO	    With Tk341Tipo(ACH->ACH_TIPO)
		Replace US_NOME	    With ACH->ACH_RAZAO
		Replace US_NREDUZ   With IIf(Empty(ACH->ACH_NFANT),ACH->ACH_RAZAO,ACH->ACH_NFANT)
		Replace US_END      With ACH->ACH_END
		Replace US_BAIRRO   With ACH->ACH_BAIRRO		
		Replace US_CEP      With ACH->ACH_CEP
		Replace US_EST 	    With ACH->ACH_EST
		If cPaisLoc == "BRA"
			Replace US_COD_MUN 	With ACH->ACH_CODMUN	
		EndIf
		Replace US_MUN      With ACH->ACH_CIDADE
		If cPaisLoc == "BRA"
			Replace US_REGIAO 	With ACH->ACH_REGIAO	
			Replace US_DSCREG 	With ACH->ACH_DSCREG
		EndIf
		Replace US_DDD	    With ACH->ACH_DDD
		Replace US_DDI	    With ACH->ACH_DDI
		Replace US_TEL	    With SgLimpaTel(ACH->ACH_TEL)
		Replace US_FAX      With ACH->ACH_FAX
		Replace US_EMAIL    With ACH->ACH_EMAIL
		Replace US_URL	    With ACH->ACH_URL 
		If cPaisLoc == "BRA"             
			Replace US_PESSOA With ACH->ACH_PESSOA
		EndIf
		Replace US_CGC      With Tk341AjCGC( ACH->ACH_CGC )
		Replace US_STATUS   With "1"			// "Classificado" - Status inicial quando o suspect passa para Prospect
		Replace US_DTCAD    With Date()		// Data de cadastro com a data atual
		Replace US_HRCAD    With Time()		// Hora do cadastro com a hora atual
		If IsinCallStack("CRMA260")
			Replace US_TPCAMP		With FWFldGet("AOD_TPCAMP")
			Replace US_CHVCAM		With FWFldGet("AOD_CHVCAM")
		Else
			Replace US_TPCAMP		With ACH->ACH_TPCAMP
			Replace US_CHVCAM		With ACH->ACH_CHVCAM
		EndIf
		
		Replace US_CODSEG		 	With ACH->ACH_CODSEG
		If (SUS->(ColumnPos("US_NSOCIAL")) > 0) .And. (ACH->(ColumnPos("ACH_NSOCIA")) > 0)
			Replace US_NSOCIAL		With ACH->ACH_NSOCIA
		EndIf 
		
		//-------------------------------------------------------------------
		// Gravacao dos campos CNAE, Faturamento, Funcionarios, PaÍs e midia
		//-------------------------------------------------------------------
		Replace US_CNAE		With ACH->ACH_CNAE
		Replace US_FATANU	With ACH->ACH_FATANU
		Replace US_QTFUNC	With ACH->ACH_QTFUNC
		Replace US_PAIS		With ACH->ACH_PAIS
		Replace US_MIDIA	With ACH->ACH_MIDIA
		If	!lRezDisTRod
		
			Replace US_VEND	    With IIF(Empty(cCodVend),ACH->ACH_VEND,cCodVend)
			//--------------------------------------------------------------------------------------------------
			// Grava campos de territorio na qualificacao, caso rotina de distribuicao/rodizio esteja habilitado 
			//--------------------------------------------------------------------------------------------------
			If lCRMTerr == Nil
				lCRMTerr := SuperGetMV("MV_CRMTERR",.F.,.F.)
			EndIf
			If	lCRMTerr
				Replace US_CODTER	With ACH->ACH_CODTER
				Replace US_TPMEMB	With ACH->ACH_TPMEM
				Replace US_CODMEMB	With ACH->ACH_CODMEM
			Endif
		Endif 		
			
			
		//-------------------------------------------------------------------
		// Gravacao dos campos para replicar o nivel da estrutura de negocio
		//-------------------------------------------------------------------
		Replace US_IDESTN	 With ACH->ACH_IDESTN	
		Replace US_NVESTN	 With ACH->ACH_NVESTN	 
		
		//------------------------------------------------------
		// Gravacao dos campos para mapear a origem do prospect
		//------------------------------------------------------
		Replace US_ORIGEM   With ACH->ACH_ORIGEM		
		Replace US_ENTORI   With ACH->ACH_ENTORI	
		
		/*
		------------------------------------------------------------------
		Grava os campos de usuario atraves do retorno do P.E.  			
		Porque os campos podem nao tem o mesmo nome no SUS iguais ao ACH 
																		
		Estrutura do Array de Retorno                                    
		aRegs[1][1]  =  Codigo do Suspect   Ex: ACH->ACH_CODIGO          
		aRegs[1][2]  =  Campo               Ex: "US_xxxxxx"				
		aRegs[1][3]  =  Conteudo 		   Ex: "Microsiga Software SA"                                                                     
		------------------------------------------------------------------
		*/  
		If Len( aRegs ) > 0
			For nCont := 1 To Len( aRegs )
				If aRegs[nCont][1] == ACH->ACH_CODIGO   // Se este item pertencer ao registro posicionado grava.
					Replace &(aRegs[nCont][2]) With aRegs[nCont][3]
				Endif
			Next nCont
		Endif

		MsUnlock()
		FkCommit()
		While ( GetSx8Len() > nSaveSx8 )
			ConfirmSX8()
		EndDo

		// inserindo registro na tabela de privilegios automaticamente
		If !IsInCallStack( "CRMA040" )
			cChave := PadR( xFilial("SUS")+SUS->US_COD+SUS->US_LOJA,TAMSX3("AO4_CHVREG")[1])  		
				
			//Adiciona o privilegios para usuario logado ou seja quem incluiu o suspect.
			aAutoAO4 := CRMA200PAut(3,"SUS",cChave,cCodUsr,/*aPermissoes*/,/*aNvlEstrut*/,/*cCodUsrCom*/,/*dDataVld*/,,,lPropri)    

			//Adiciona vendedor responsavel pela conta.
			If !Empty(SUS->US_VEND)
				If lCRMAZS
					AZS->( DBSetOrder(4) )    // AZS_FILIAL+AZS_VEND
											
					If AZS->( DbSeek(xFilial("AZS") + SUS->US_VEND ) ) .And. ! Empty(aRole) 
						If ! ( AZS->AZS_CODUSR + AZS->AZS_SEQUEN + AZS->AZS_PAPEL == aRole[1] + aRole[2] + aRole[3] )
							aAutoAO4Aux := CRMA200PAut(3,"SUS",cChave,AZS->AZS_CODUSR,/*aPermissoes*/,/*aNvlEstrut*/,aRole[1],/*dDataVld*/,,,lPropri, AZS->AZS_SEQUEN + AZS->AZS_PAPEL )
							aAdd(aAutoAO4[2],aAutoAO4Aux[2][1])
						EndIf			
					EndIf 
				Else
					DbSelectArea("AO3")
					AO3->(DbSetOrder(2))	// AO3_FILIAL+AO3_VEND
					//Verifica se o usuario logado é o mesmo que está qualificando!
					//Caso seja diferente a conta será atribuida para vendedor informado no cadastro.
					If AO3->(DbSeek(xFilial("AO3")+SUS->US_VEND)) .And. AO3->AO3_CODUSR <> cCodUsr
						aAutoAO4Aux := CRMA200PAut(3,"SUS",cChave,AO3->AO3_CODUSR,/*aPermissoes*/,/*aNvlEstrut*/,cCodUsr,/*dDataVld*/)
						aAdd(aAutoAO4[2],aAutoAO4Aux[2][1])
					EndIf
				EndIf
			EndIf

			If !Empty(aAutoAO4)
				CRMA200Auto(aAutoAO4[1],aAutoAO4[2],3)
			EndIf
			
		EndIf
			
		//---------------------
		// Atualiza o Prospect 
		//--------------------- 
		If lProspect <> NIL
			lProspect := .T.
		Endif
		
		lRet := .T.
		
		//------------------------
		// Alteracao da entidade 
		//------------------------
		DbSelectArea("AC8")
		DbSetOrder( 2 ) //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
		If DbSeek( xFilial("AC8") + "ACH" + xFilial("ACH") + ALLTRIM( cCodigo + cLoja ) )
			While ( !Eof() ) 								.AND. ;
				( AC8->AC8_FILIAL == xFilial("AC8") ) 	.AND. ;
				( AC8->AC8_ENTIDA == "ACH" ) 				.AND. ;
				( AC8->AC8_FILENT == xFilial("ACH") ) 	.AND. ;
				( ALLTRIM( AC8->AC8_CODENT ) == ALLTRIM( cCodigo + cLoja ) )

				//----------------------------------------------------------
				// Armazena os contatos ja existentes no suspect para copia
				//----------------------------------------------------------
				AAdd( aContato,{	xFilial("AC8")	,;
								"SUS"					,;
								xFilial("SUS")		,;
								cCodPro + ACH->ACH_LOJA	,;
								AC8->AC8_CODCON			} )
				AC8->( DbSkip() )
			End
			
			//-----------------------------------
			// Copia os contatos para o prospect
			//-----------------------------------
			For nCont := 1 To Len( aContato )
				Reclock("AC8",.T.)
				Replace AC8_FILIAL  With aContato[nCont][1]
				Replace AC8_ENTIDA  With aContato[nCont][2]
				Replace AC8_FILENT  With aContato[nCont][3]
				Replace AC8_CODENT	With aContato[nCont][4]
				Replace AC8_CODCON	With aContato[nCont][5]
				MsUnlock()
				FkCommit()
			Next nCont

		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inclui os relacionamentos de segmento para a nova entidade - CLIENTES ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("AOW")
		dbSetOrder(1) //AOW_FILIAL+AOW_ENTIDA+AOW_FILENT+AOW_CODCNT+AOW_LOJCNT+AOW_CODSEG

		IF	dbSeek(xFilial("AOW")+"ACH"+xFilial("ACH")+ACH->ACH_CODIGO+ACH->ACH_LOJA+ACH->ACH_CODSEG)
			While ((!AOW->( Eof())) .And. (xFilial("AOW") == AOW->AOW_FILIAL) .And.;
				(AOW->AOW_ENTIDA == 'ACH') .And. (xFilial("ACH")==AOW->AOW_FILENT) .And.;
				(AOW->AOW_CODCNT == ACH->ACH_CODIGO) .And. (AOW->AOW_LOJCNT== ACH->ACH_LOJA) .And.;
				(AOW->AOW_CODSEG == ACH->ACH_CODSEG))
	
				AAdd( aAmarra,{xFilial("AOW"),;
								xFilial("ACH"),;
								cCodPro,;
								"SUS",;
								cLoja,;
								AOW->AOW_CODSEG,;
								AOW->AOW_SUBSEG} )
	
				AOW->( DbSkip() )            
			EndDo
			
			For nCont := 1 To Len( aAmarra )
				Reclock("AOW",.T.)
				AOW_FILIAL := aAmarra[nCont][1]
				AOW_FILENT := aAmarra[nCont][2]			
				AOW_CODCNT := aAmarra[nCont][3]			
				AOW_ENTIDA := aAmarra[nCont][4]
				AOW_LOJCNT := aAmarra[nCont][5]
				AOW_CODSEG := aAmarra[nCont][6]
				AOW_SUBSEG := aAmarra[nCont][7]
				MsUnlock()
				DbCommit()   
			Next
		Endif	
		
		DbSelectArea("ACH")
		Reclock( "ACH", .F., .T. )
		Replace ACH->ACH_CODPRO With cCodPro
		Replace ACH->ACH_LOJPRO With ACH->ACH_LOJA
		Replace ACH->ACH_STATUS With "6"
		Replace ACH->ACH_DTCONV With Date()
		Replace ACH->ACH_HRCONV With Time()
		MsUnlock()
		FkCommit()
		
		//---------------------------------------------------------
		//Atualiza o relacionamento com o ADL (conta do vendedor)
		//---------------------------------------------------------
		If lAtuADL
			Ft520UpdEn( "ACH", "SUS", ACH->ACH_CODIGO, SUS->US_COD	,;
				ACH->ACH_LOJA, SUS->US_LOJA	)
		EndIf
		
		End Transaction
		
		//---------------------------------------
		// Ponto de Entrada depois da conversao
		//---------------------------------------
		If lTMKGRSP
			U_TMKGRSP( cCodPro, ACH->ACH_LOJA , .F.)
		Endif
		If lRet 
			aNewSUS := {  SUS->US_COD, SUS->US_LOJA } 
		EndIf
	Endif 

Return( lRet )  


//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk341AjuCGC

Funcao para gravar no cadatro de prospect o CGC sem picture 

@sample 	Tk341AjuCGC( cCGC )

@param		cCGC	- numero do CNPJ/CPF	

@return   	cCGC    -  Retorna numero do CNPJ/CPF sem picture

@author		Vendas CRM
@since		10/09/07
@version	12
/*/
//------------------------------------------------------------------------------
Static Function Tk341AjCGC( cCGC )

	Default	cCGC := ""		// Variavel com o CGC

	If !Empty( cCGC )
		cCGC := StrTran( cCGC,".","" )
		cCGC := StrTran( cCGC,"-","" )
		cCGC := StrTran( cCGC,"/","" )   
				
		cCGC := PadR( cCGC, TamSX3( "A1_CGC" )[1] )
	Endif

Return( cCGC )   


//------------------------------------------------------------------------------
/*/{Protheus.doc} Tk341Tipo 

Conversao do tipo de consumidor 	

@sample 	Tk341Tipo( cTipo )

@param		cTipo 	- Tipo do Consumidor

@return   	cTipo   -  Retorna o Tipo do Consumidor

@author		Vendas CRM
@since		22/05/02 
@version	12
/*/
//------------------------------------------------------------------------------
Static Function Tk341Tipo( cTipo )

	If cTipo == "1"
		cTipo := "F"
	ElseIf cTipo == "2"
		cTipo := "L"
	ElseIf cTipo == "3"
		cTipo := "R"
	ElseIf cTipo == "4"
		cTipo := "S"
	ElseIf cTipo == "5"
		cTipo := "X"
	ElseIf cTipo == "6"	// Esse tipo e usado para localizacoes
		cTipo := "M"
	Endif

Return( cTipo )

/*/{Protheus.doc} fSuspect
    Prepara o array para ExecAuto de Suspect
    @type  Static Function
    @author user
    @since 05/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fSuspect()

	Local aAuxACH 	:= {}
	Local cACH		:= "LOJA,RAZAO,NFANT,TIPO,CGC,END,BAIRRO,CIDADE,EST,CEP,PAIS,RESERV,DDI,DDD,TEL,FAX,EMAIL,CNAE,PESSOA,CODMUN,MSBLQL,CODSEG"

	aAuxACH := Separa(cACH,',')
		
Return aAuxACH

/*/{Protheus.doc} fAtuTabs
	(long_description)
	@type  Static Function
	@author user
	@since 18/10/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fAtuTabs(cBkpCli,cBkpLjCli,cNewCod)

	Local cTMP    		:= GetNextAlias()
	Local cQuery 		:= ''
	Local cDetAIN		:= ''
	Local cDetAD1		:= ''
	Local cDetADY		:= ''
	Local nRecAIN		:= 0
	Local nRecAD1		:= 0
	Local nRecADY		:= 0
	Local nY			:= 0
	Local aAreaFechar	:= {}

	// Atualiza AIN
	DbselectArea("AIN")
	DbSetOrder(2)
	If Dbseek(xFilial("AIN")+'SA1'+cBkpCli)
		nRecAIN := AIN->(Recno())
		cDetAIN := ' '
		cDetAIN += ' | RECNO AIN ATUALIZADO - '+ cvaltochar(nRecAIN) + ' |' +CRLF
		FWLogMsg( "INFO | ", /*cTransactionId*/, cDetAIN, /*cCategory*/, /*cStep*/, /*cMsgId*/,"" , /*nMensure*/, /*nElapseTime*/, {} )
		RecLock("AIN", .F.)
		AIN->AIN_CODCTA := cNewCod
		MsUnlock()
	EndIf

	// Atualiza AD1
	cQuery := " "
	cQuery += " SELECT AD1_NROPOR,MAX(AD1_REVISA) AS AD1_REVISA,AD1_CODCLI,AD1_LOJCLI,R_E_C_N_O_ " 
	cQuery += " FROM   " + RetSQLName("AD1") + " AD1   " 
	cQuery += " WHERE  AD1_CODCLI = '" + cBkpCli + "'   " 
	cQuery += "        AND AD1_LOJCLI = '" + cBkpLjCli + "'   " 
	cQuery += "        AND AD1_STATUS = '1' " 
	cQuery += "        AND AD1.D_E_L_E_T_ = ' '   " 
	cQuery += " GROUP BY AD1_NROPOR,AD1_CODCLI,AD1_LOJCLI,R_E_C_N_O_   "

	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
	If !(cTMP)->(Eof())
		cDetAD1 := ' '
		cDetAD1 += ' | RECNOs AD1 ATUALIZADOS - '		
		FWLogMsg( "INFO | ", /*cTransactionId*/, cDetAD1, /*cCategory*/, /*cStep*/, /*cMsgId*/,"" , /*nMensure*/, /*nElapseTime*/, {} )		
		While  (cTMP)->(! Eof())
			
			DbselectArea("AD1")
			nRecAD1 := (cTMP)->R_E_C_N_O_
			AD1->(DbGoTo(nRecAD1))
			RecLock("AD1", .F.)
				AD1->AD1_CODCLI := cNewCod
				AD1->AD1_LOJCLI := '00'
			MsUnlock()
			cDetAD1 += cvaltochar(nRecAD1)+','

			(cTMP)->(DbSkip())
		End
		cDetAD1 += ' |'
	EndIf
	(cTMP)->(DbCloseArea())

	// Atualiza ADY
	cTMP   := GetNextAlias()
	cQuery := " "
	cQuery += " SELECT ADY_CODIGO, ADY_LOJA, R_E_C_N_O_   " 
	cQuery += " FROM   " + RetSQLName("ADY") + "   " 
	cQuery += " WHERE  ADY_CODIGO = '" + cBkpCli + "'   " 
	cQuery += "        AND ADY_LOJA = '" + cBkpLjCli + "'   " 
	cQuery += "        AND ADY_STATUS <> 'B' "
	cQuery += "        AND D_E_L_E_T_ = ' '   " 

	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
	If !(cTMP)->(Eof())
		cDetADY := ' '	
		cDetADY += ' | RECNOs ADY ATUALIZADOS - '	
		FWLogMsg( "INFO | ", /*cTransactionId*/, cDetADY, /*cCategory*/, /*cStep*/, /*cMsgId*/,"" , /*nMensure*/, /*nElapseTime*/, {} )	
		While  (cTMP)->(! Eof())
			
			DbselectArea("ADY")
			nRecADY := (cTMP)->R_E_C_N_O_
			ADY->(DbGoTo(nRecADY))
			RecLock("ADY", .F.)
				If ADY->ADY_CODIGO == ADY->ADY_CLIENT .And. ADY->ADY_LOJA == ADY->ADY_LOJENT
					ADY->ADY_CLIENT := cNewCod
					ADY->ADY_LOJENT	:= '00'
				EndIf
				ADY->ADY_CODIGO := cNewCod
				ADY->ADY_LOJA 	:= '00'
			MsUnlock()
			cDetADY += cvaltochar(nRecADY)+','

			(cTMP)->(DbSkip())
		End
		cDetADY += ' |'
	EndIf
	(cTMP)->(DbCloseArea())

	cDetRet := cDetAIN + cDetAD1 + CRLF + cDetADY

	//Para resolver a questão de utilizar com multithread e ficarem muitas areas abertas
	aAreaFechar := {'AIN','AD1','ADY'}

	For nY := 1 to len(aAreaFechar)
		If Select(aAreaFechar[nY]) > 0
			dbSelectArea(aAreaFechar[nY])
			dbCloseArea()
		EndIf
	Next nY
	
Return cDetRet

/*/{Protheus.doc} fCreateFK7
    Cria a FK7 
    @type  Static Function
    @author user Nicole Valario
    @since 05/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function fCreateFK7(cEmpresa,cFilDest,lByPass,cUsrLog)  //U_CRIA_FK7()
	Local cEmp     := ""
	Local cFil     := ""
	Local lRet     := .F.
	
	Local aRet   	:= {}
	Local aParamBox := {}
	
	Local cMsg      := ""
	
	Private oMsgIt3
	Private oSelWnd
	Private oMainWnd
	Private oFont

	Private lAbortPrint := .F.

	OpenSm0()
	dbSelectArea("SM0")

	oFont := TFont():New('Arial',, -11, .T., .T.)

	If !lByPass
		DEFINE WINDOW oSelWnd FROM 0,0 TO 1000, 1000 TITLE "Cria FK7 - Identificar empresa e filial."
		oSelWnd:oFont := oFont
		oSelWnd:SetColor(CLR_BLACK,CLR_WHITE)
		oSelWnd:nClrText := 0
		oSelWnd:ReadClientCoors()

		ACTIVATE WINDOW oSelWnd MAXIMIZED ON INIT (lRet := SelEmp(@cEmp, @cFil, oSelWnd,'FK7' ), oSelWnd:End())
	Else
		lRet := .T.
	EndIf

	cFilAnt := cFilDest

	If  ! lRet
		Return .F.
	Endif

	__cInterNet := Nil
	lmshelpauto := .F.
	

	aAdd(aParamBox,{2, "Processo: " ,      "P", {"R=Baixas a Receber(SE1)", "P=Baixas a Pagar(SE2)"}, 90 , ".T.", .T.}) 

	If ! ParamBox(aParamBox, "", @aRet)
		Return  
	EndIf 

	If MV_PAR01 == "R"
		cMsg      := "Confirma a Geração da FK7 de Contas a Receber?"
	Else 
		cMsg      := "Confirma a Geração da FK7 de Contas a Pagar?"
	EndIF 

	If ! FWAlertNoYes(cMsg)
		Return 
	EndIf 

	If MV_PAR01 == "R"
	 	FWMsgRun(, {|| FKS_SE1(cUsrLog)},"", "Gerando FK7 receber, aguarde...",,.T.) 
	Else 
		FWMsgRun(, {|| FKS_SE2(cUsrLog)},"", "Gerando FK7 pagar, aguarde...",,.T.) 
	EndIf 

	If lAbortPrint
        FWAlertError("Geração interrompida!",'Abortado')
		GrvArq("Geração interrompida!",'FK7')
    Else
        FWAlertSuccess("Geração Finalizada!",'Sucesso')
    EndIf

Return

Static Function FKS_SE1(cUsrLog)
    Local cIdDoc   := ""
	Local cChave   := ""
	Local nRecNo   := 0
	Local cSQL     := ""
	Local cAliasA  := GetNextAlias()
	Local cTexto   := space(250)

	cSQL += " SELECT COUNT(SE1.E1_FILIAL) OVER (PARTITION BY ' ') TOTREG, SE1.R_E_C_N_O_ RECE1   " 
	cSQL += " FROM  " + RetSQLName("SE1") + " SE1 " 
	cSQL += " WHERE  SE1.E1_FILIAL = '" + cFilAnt + "' " 
	cSQL += "        AND SE1.E1_BAIXA = ' ' " 
	cSQL += "        AND SE1.D_E_L_E_T_ = ' ' " 

	cTexto := FwInputBox("Deseja informar uma query personalizada?", cTexto)
	If AllTrim(cTexto) <> '' 
		cSQL := cTexto
	EndIf

	cSQL := ChangeQuery(cSQL)
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.)
	While ! (cAliasA)->(Eof())

        If lAbortPrint
            Exit
        EndIf

		nRecNo := (cAliasA)->RECE1 

		SE1->(dbGoTo(nRecNo))

		cChave := xFilial("SE1", SE1->E1_FILORIG) + "|" +;
		          SE1->E1_PREFIXO                 + "|" +;
				  SE1->E1_NUM                     + "|" +;
				  SE1->E1_PARCELA                 + "|" +;
				  SE1->E1_TIPO                    + "|" +;
				  SE1->E1_CLIENTE                 + "|" +;
				  SE1->E1_LOJA
		
		FK7->(DbSetOrder(2))  //FK7_FILIAL+FK7_ALIAS+FK7_CHAVE
		If ! FK7->(DbSeek(xFilial("SE1", SE1->E1_FILORIG) + "SE1" + cChave))
			
			cIdDoc := FINGRVFK7('SE1', cChave)  //GRAVA FK7
			cRet 		:= "#Sucesso"
			cDetalhe 	:= "Recno SE1 :" + cValToChar(nRecNo) +" Chave:" + cChave + " IdDoc:" + cIdDoc
			U_TINCGRLG('',FK7->(Recno()),"FK7",cRet,cDetalhe,'',.T.,cUsrLog,/*'',*/'')
		Else
			cRet 		:= "#Aviso"
			cDetalhe 	:= "Recno SE1 :" + cValToChar(nRecNo) +" Chave FK7: " + cChave + " já existe!" 
			U_TINCGRLG('',FK7->(Recno()),"FK7",cRet,cDetalhe,'',.T.,cUsrLog,/*'',*/'')
		EndIf 
		(cAliasA)->( dbSkip() )
	End
	(cAliasA)->( dbCloseArea() )

Return 	

Static Function FKS_SE2(cUsrLog)
	Local cIdDoc   := ""
	Local cChave   := ""
	Local nRecNo   := 0
	Local cSQL     := ""
	Local cAliasA  := GetNextAlias()
	Local cTexto   := space(250)


	cSQL += " SELECT COUNT(SE2.E2_FILIAL) OVER (PARTITION BY ' ') TOTREG, SE2.R_E_C_N_O_ RECE2   " 
	cSQL += " FROM  " + RetSQLName("SE2") + " SE2 " 
	cSQL += " WHERE  SE2.E2_FILIAL = '" + cFilAnt + "' "
	cSQL += "        AND SE2.E2_BAIXA = ' ' "  
	cSQL += "        AND SE2.D_E_L_E_T_ = ' ' " 

	
	cTexto := FwInputBox("Deseja informar uma query personalizada?", cTexto)
	If AllTrim(cTexto) <> '' 
		cSQL := cTexto
	EndIf

	cSQL := ChangeQuery(cSQL)
	IF Select( cAliasA ) > 0
		dbSelectArea( cAliasA )
		dbCloseArea()
	EndIF

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cSQL), cAliasA, .F., .T.)
	While ! (cAliasA)->(Eof())
		
	    If lAbortPrint
            Exit
        EndIf

		nRecNo := (cAliasA)->RECE2 

		SE2->(dbGoTo(nRecNo))

		cChave := xFilial("SE2", SE2->E2_FILORIG) + "|" +;
		          SE2->E2_PREFIXO                 + "|" +;
				  SE2->E2_NUM                     + "|" +;
				  SE2->E2_PARCELA                 + "|" +;
				  SE2->E2_TIPO                    + "|" +;
				  SE2->E2_FORNECE                 + "|" +;
				  SE2->E2_LOJA
		
		FK7->(DbSetOrder(2))  //FK7_FILIAL+FK7_ALIAS+FK7_CHAVE
		If ! FK7->(DbSeek(xFilial("SE2", SE2->E2_FILORIG) + "SE2" + cChave))
			cIdDoc := FINGRVFK7('SE2', cChave)  //GRAVA FK7
			cRet 		:= "#Sucesso"
			cDetalhe 	:= "Recno SE2 :" + cValToChar(nRecNo) +" Chave:" + cChave + " IdDoc:" + cIdDoc
			U_TINCGRLG('',FK7->(Recno()),"FK7",cRet,cDetalhe,'',.T.,cUsrLog,/*'',*/'')
		Else 
			cRet 		:= "#Aviso"
			cDetalhe 	:= "Recno SE2 :" + cValToChar(nRecNo) + " Chave FK7: " + cChave + " já existe!"
			U_TINCGRLG('',FK7->(Recno()),"FK7",cRet,cDetalhe,'',.T.,cUsrLog,/*'',*/'')
		EndIf 
		
		(cAliasA)->( dbSkip() )
	End
	(cAliasA)->( dbCloseArea() )

Return 	


Static Function GrvArq(cLinha, cTab)
    Local nHandle2 	:= 0
	Local cDirRmt	:= ''
	Local cArquivo	:= ''

    Default lEnter 	:= .T.

	cDirRmt := TFileDialog("All(*)",'Informe o diretorio para gravar o log',0,"/tmp",.F.,GETF_RETDIRECTORY)
    If Empty(cDirRmt)
        Return 
    EndIf 
    cArquivo := cDirRmt + "\CRIA"+cTab+"_logproc_" + cFilAnt + "_" + StrTran(Time(), ":", "") + ".log"

    If ! File(cArquivo)
        If (nHandle2 := TIFCreate(cArquivo,0)) == -1
            Return
        EndIf
    Else
        If (nHandle2 := TIOpen(cArquivo,2)) == -1
            Return
        EndIf
    EndIf
    FSeek(nHandle2,0,2)
    If lEnter
        FWrite(nHandle2, cLinha + CRLF)
    Else 
        FWrite(nHandle2, cLinha )
    EndIf 
    FClose(nHandle2)
Return

	/*
	/* Seleção de empresas       */
	/* Julio Saraiva - 2024      */
Static Function SelEmp(cEmp, cFil, oWnd, cFK)
	Local oModal
	Local oCbxEmp
	Local oFont
	Local cEmpAtu	:= ""
	Local lOk		:= .F.
	Local aCbxEmp	:= {}
	Local npB
	Local npT
	Local lRet
	Local __nWidth  := 0 
	Local __nHeight := 0

	oFont := TFont():New('Arial',, -11, .T., .T.)

		__nHeight := oWnd:nHeight - 100
		__nWidth  := oWnd:nWidth - 30

		oWnd:oFont := oFont
		oWnd:SetColor(CLR_BLACK,CLR_WHITE)
		oWnd:nClrText := 0

		oWnd:nBottom := 976
		oWnd:nHeight := 976
		oWnd:nRight  := 1910

	//EndIf

	SM0->(DbGotop())
	While ! SM0->(Eof())
		If cFK == 'FK7'
			Aadd(aCbxEmp,SM0->M0_CODIGO + '/' + SM0->M0_CODFIL + ' - ' + SM0->M0_FILIAL)
		Else
			Aadd(aCbxEmp,SM0->M0_CODIGO + '/' + SM0->M0_CODFIL + ' - ' + Alltrim(SM0->M0_NOME) + ' / ' + SM0->M0_FILIAL)
		EndIf
		SM0->(DbSkip())
	EndDo

	oModal  := FWDialogModal():New()
	oModal:SetEscClose(.f.)
	If cFK == 'FK7'
		oModal:setTitle("Selecione a filial: ")
	Else
		oModal:setTitle("Ambiente ")
	EndIf
	oModal:setSize(100, 200)
	oModal:createDialog()
	oModal:AddButton("OK",      {|| lOk := .t., oModal:DeActivate()}     , "OK",,.T.,.F.,.T.,)
	oModal:AddButton("Cancelar",{|| lOk := .F., oModal:DeActivate()}     , "Cancelar",,.T.,.F.,.T.,)

	@ 010,005 Say "Selecione a Empresa:" PIXEL of oModal:getPanelMain()  FONT oFont //
	@ 018,005 MSCOMBOBOX oCbxEmp VAR cEmpAtu ITEMS aCbxEmp SIZE 190,10 OF oModal:getPanelMain() PIXEL

	
	oModal:Activate()

	If lOk
        npB     := at("/", cEmpAtu)
        cEmp    := Left(cEmpAtu, npB - 1)
        cEmpAtu := Subs(cEmpAtu, npB + 1)
        npT     := at("-", cEmpAtu)
		If cFK == 'FK7'
		    cFil    := Left(cEmpAtu, npT - 3)
		Else
			cFil    := Left(cEmpAtu, npT - 2)
		EndIf
		RpcClearEnv()
		RpcSetType(3)

		FWMsgRun(, {||lRet := RpcSetEnv(cEmp,cFil) },"", "Aguarde...", "Montando Ambiente. Empresa [" + cEmp + "] Filial [" + cFil +"]."  )
		If !lRet
			Aviso("ATENCAO!!!","Falha na autenticacao."+ CRLF + CRLF +" Nao foi possivel montar o ambiente selecionado.",{ "Ok" }, 1 )
			Return .F.
		EndIf
	EndIf

Return lOk

/*/{Protheus.doc} CreateFKs
    Criação das FKs
    @type  Static Function
    @author user Nicole Valario
    @since 05/09/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function CreateFKs(cEmpresa,cFilDest,lByPass,cUsrLog) //U_CriaFks()
	Local cEmp     := ""
	Local cFil     := ""
	Local lRet     := .F.
	
	Local aRet   	:= {}
	Local aParamBox := {}
	
	Local aCombo  	:= {}
	Local aMsg    	:= {}
	
	Private oMsgIt3
	Private oSelWnd
	Private oMainWnd
	Private oFont

	Private lAbortPrint := .F.

	OpenSm0()
	dbSelectArea("SM0")

	oFont := TFont():New('Arial',, -11, .T., .T.)

	If !lByPass
		DEFINE WINDOW oSelWnd FROM 0,0 TO 1000, 1000 TITLE "Cria FK - Identificar empresa e filial."
		oSelWnd:oFont := oFont
		oSelWnd:SetColor(CLR_BLACK,CLR_WHITE)
		oSelWnd:nClrText := 0
		oSelWnd:ReadClientCoors()

		ACTIVATE WINDOW oSelWnd MAXIMIZED ON INIT (lRet := SelEmp(@cEmp, @cFil, oSelWnd,''), oSelWnd:End())
	Else
		lRet := .T.
	EndIf

	cFilAnt := cFilDest
	
	If  ! lRet
		Return .F.
	Endif

	__cInterNet := Nil
	lmshelpauto := .F.

	aCombo := {"1=Baixas a Receber"              ,;
	           "2=Baixas a Pagar"                ,;
			   "3=Movimentos de Baixas a Receber",;
			   "4=Movimentos de Baixas a Pagar"}

    aAdd(aParamBox,{2, "Natureza: ", "1", aCombo, 095, ".T.", .T.}) 

	If ! ParamBox(aParamBox, "", @aRet)
		Return  
	EndIf 

	aMsg := {"FKs dos Titulos Baixados de Contas a Receber"   ,;
			 "FKs dos Titulos Baixados de Contas a Pagar"     ,;
			 "FKs dos Movimentos Baixados de Contas a Receber",;
			 "FKs dos Movimentos Baixados de Contas a Pagar"}
	If ! FWAlertNoYes("Confirma a Qtde processada " + aMsg[val(MV_PAR01)])
		Return 
	EndIf 

	// GrvArq(aMsg[val(MV_PAR01)]  )
	
	FWMsgRun(, {|| ProcCria()},"", "Gerando " + aMsg[val(MV_PAR01)] + ", Aguarde",, .T.) 

Return    

Static Function ProcCria( aMsg)
    Local cQuery  := ""
    Local cTMP    := GetNextAlias()
	Local cRecPag := ""
	Local nRecE5  := 0
	Local nTipo   := 0
	Local nQtdLin := 0
	
	aMsg := {"FKs dos Titulos Baixados de Contas a Receber"   ,;
			 "FKs dos Titulos Baixados de Contas a Pagar"     ,;
			 "FKs dos Movimentos Baixados de Contas a Receber",;
			 "FKs dos Movimentos Baixados de Contas a Pagar"}

	If MV_PAR01 $ "1,3"
	   cRecPag := "R"
	ElseIf MV_PAR01 $ "2,4"
	   cRecPag := "P"
	EndIf  

	nTipo := Val(MV_PAR01)
  
    cQuery += " SELECT  R_E_C_N_O_ RECE5 "
	cQuery += "   FROM " + RetSqlName("SE5") + " "
	cQuery += "  WHERE E5_FILIAL = '" + cFilAnt + "'"
	cQuery += "    AND E5_RECPAG = '" + cRecPag + "' "
	cQuery += "    AND E5_MOVFKS <> 'S' " 
	cQuery += "    AND D_E_L_E_T_ = ' ' " 

	// GrvArq("Query utilizada:")

	// ProcRegua(1)
    DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
	If (cTMP)->(Eof())		
        (cTMP)->(DbCloseArea())
        Return 
    EndIf
	
    While  (cTMP)->(! Eof())
		nRecE5 := (cTMP)->RECE5
		SE5->(DbGoto(nRecE5)) 

		// IncProc("Processando linha: " + Alltrim(Str(++nQtdLin,5)))
		// ProcessMessage()
		If lAbortPrint 
			Exit 
		EndIf

		If nTipo == 1 //
			XXFnBaixaE1(nRecE5)
		ElseIf nTipo == 2 //	
			XFnBaixaE2(nRecE5)
		ElseIf nTipo == 3 .or. nTipo == 4 	
			XFnBuscaSE5(nRecE5)
		EndIf 
		
        (cTMP)->(DbSkip())
    End
    (cTMP)->(DbCloseArea())

	FWAlertSuccess("Qtde processada " + Alltrim(Str(nQtdLin,5)), 'Sucesso' )

	If lAbortPrint
		FWAlertError("Geração interrompida!",'Abortado')
		GrvArq("Processo interrompido !!!! --- " + aMsg[val(MV_PAR01)],'FKs')
    Else
		FWAlertSuccess("Processo Finalizado",'Sucesso')
    EndIf

Return  

//-------------------------------------------------------------------
/*/{Protheus.doc} FINProcFKs
Função para retornar a identificação do processo do movimento
financeiro

@param cChave, Identificação do registro de origem
@param cAlias, Identificação da tabela de origem
@param cSeq, Sequencia de baixa usando para rastreio de processos de baixas e adiantamento
@param lMovDireto Indica se é um movimento direto do FINA100
@return cRet, Número do processo

@author Totvs
@since 10/04/2014
@version P12
/*/
//-------------------------------------------------------------------

User Function XFINProcFKs(cChave, cAlias, cSeq, lMovDireto)
	Local cRet := ""
	Local aAreaAnt := GetArea()

	Default cChave := ""
	Default cAlias := ""
	Default cSeq := ""
	Default lMovDireto := .F.

	If lBxMovPA//Na bx de PA ou geração de mov. banc nas rotinas de bxs aut cp, utiliza o msm processo gerado na inclusão
		cRet := FKA->FKA_IDPROC
		lBxMovPA := .F.
	ElseIf !Empty(cChave) .And. !Empty(cAlias)
		dbSelectArea(cAlias)
		(cAlias)->( DbSetOrder(1) ) //Se FK1/FK2 - FILIAL + IDFK	Se FK5 FILIAL +

		If (lMovDireto .or. (cAlias)->(dbSeek(xFilial(cAlias)+cChave)) )
			dbSelectArea("FKA")
			FKA->( DbSetOrder( 3 ) ) //FKA_FILIAL+FKA_TABORI+FKA_IDORIG
			If dbSeek( xFilial("FKA") + cAlias + cChave)
				cRet := FKA->FKA_IDPROC
			Endif
		Endif
	EndIf
	RestArea( aAreaAnt )
Return cRet

/*/{Protheus.doc}FINLisCpo
Função de de/para das FKs para SE5.
@author William Matos Gundim Junior
@since  04/04/2014
@version 12
/*/
User Function XFINLisCpo(cTabela)
	
	Local aAux := {}
	Local aRet	 := {}
	Local lCmpFK1 	:= .T.
	Local lCmpFK2 	:= .T.
	Local lCmpFK6	:= .T.

	Default cTabela := ''

    RpcSetEnv("00","00202000300")
    lCmpFK1 	:= FK1->(FieldPos("FK1_DTDISP")) > 0 .and. FK1->(FieldPos("FK1_DTDIGI")) > 0
	lCmpFK2 	:= FK2->(FieldPos("FK2_DTDISP")) > 0 .and. FK2->(FieldPos("FK2_DTDIGI")) > 0
	lCmpFK6	    := FK6->(FieldPos("FK6_MOEDA"))	 > 0 .and. FK6->(FieldPos("FK6_TXMOED")) > 0
	
	Do Case
	Case cTabela == 'FK1' //Baixas a Pagar.

		aAdd(aAux,{'FK1_DATA','E5_DATA'})
		aAdd(aAux,{'FK1_VALOR','E5_VALOR'})
		aAdd(aAux,{'FK1_MOEDA','E5_MOEDA'})
		aAdd(aAux,{'FK1_NATURE','E5_NATUREZ'})
		aAdd(aAux,{'FK1_VENCTO','E5_VENCTO'})
		aAdd(aAux,{'FK1_RECPAG','E5_RECPAG'})
		aAdd(aAux,{'FK1_TPDOC','E5_TIPODOC'})
		aAdd(aAux,{'FK1_HISTOR','E5_HISTOR'})
		aAdd(aAux,{'FK1_VLMOE2','E5_VLMOED2'})
		aAdd(aAux,{'FK1_LOTE','E5_LOTE'})
		aAdd(aAux,{'FK1_MOTBX','E5_MOTBX'})
		aAdd(aAux,{'FK1_ORDREC','E5_ORDREC'})
		aAdd(aAux,{'FK1_FILORI','E5_FILORIG'})
		aAdd(aAux,{'FK1_ARCNAB',	'E5_ARQCNAB'})
		aAdd(aAux,{'FK1_CNABOC','E5_CNABOC'})
		aAdd(aAux,{'FK1_TXMOED','E5_TXMOEDA'})
		aAdd(aAux,{'FK1_SITCOB','E5_SITCOB'})
		aAdd(aAux,{'FK1_SERREC','E5_SERREC'})
		aAdd(aAux,{'FK1_MULNAT','E5_MULTNAT'})
		aAdd(aAux,{'FK1_AUTBCO','E5_AUTBCO'})
		aAdd(aAux,{'FK1_CCUSTO' ,'E5_CCUSTO'})
		aAdd(aAux,{'FK1_SEQ','E5_SEQ'})
		aAdd(aAux,{'FK1_DIACTB','E5_DIACTB'})
		aAdd(aAux,{'FK1_NODIA','E5_NODIA'})
		aAdd(aAux,{'FK1_LA','E5_LA'})
		aAdd(aAux,{'FK1_DOC','E5_DOCUMEN'})
		aAdd(aAux,{'FK1_ORIGEM','E5_ORIGEM'})
		If lCmpFK1
			aAdd(aAux,{'FK1_DTDISP','E5_DTDISPO'})
			aAdd(aAux,{'FK1_DTDIGI','E5_DTDIGIT'})
		EndIF
	Case cTabela == 'FK2' //Baixas a Pagar.

		aAdd(aAux,{'FK2_DATA','E5_DATA'})
		aAdd(aAux,{'FK2_VALOR','E5_VALOR'})
		aAdd(aAux,{'FK2_MOEDA','E5_MOEDA'})
		aAdd(aAux,{'FK2_NATURE','E5_NATUREZ'})
		aAdd(aAux,{'FK2_VENCTO','E5_VENCTO'})
		aAdd(aAux,{'FK2_RECPAG','E5_RECPAG'})
		aAdd(aAux,{'FK2_TPDOC','E5_TIPODOC'})
		aAdd(aAux,{'FK2_HISTOR','E5_HISTOR'})
		aAdd(aAux,{'FK2_VLMOE2','E5_VLMOED2'})
		aAdd(aAux,{'FK2_LOTE','E5_LOTE'})
		aAdd(aAux,{'FK2_MOTBX','E5_MOTBX'})
		aAdd(aAux,{'FK2_ORDREC','E5_ORDREC'})
		aAdd(aAux,{'FK2_FILORI','E5_FILORIG'})
		aAdd(aAux,{'FK2_ARCNAB','E5_ARQCNAB'})
		aAdd(aAux,{'FK2_CNABOC','E5_CNABOC'})
		aAdd(aAux,{'FK2_TXMOED','E5_TXMOEDA'})
		aAdd(aAux,{'FK2_MULNAT','E5_MULTNAT'})
		aAdd(aAux,{'FK2_AUTBCO','E5_AUTBCO'})
		aAdd(aAux,{'FK2_CCUSTO' ,'E5_CCUSTO'})
		aAdd(aAux,{'FK2_SEQ','E5_SEQ'})
		aAdd(aAux,{'FK2_DIACTB','E5_DIACTB'})
		aAdd(aAux,{'FK2_NODIA','E5_NODIA'})
		aAdd(aAux,{'FK2_LA','E5_LA'})
		aAdd(aAux,{'FK2_SERREC','E5_SERREC'})
		aAdd(aAux,{'FK2_DOC','E5_DOCUMEN'})
		aAdd(aAux,{'FK2_ORIGEM','E5_ORIGEM'})
		If lCmpFK2
			aAdd(aAux,{'FK2_DTDISP','E5_DTDISPO'})
			aAdd(aAux,{'FK2_DTDIGI','E5_DTDIGIT'})
		EndIF
	Case cTabela == 'FK3' //Impostos Calculados.

		aAdd(aAux,{'FK3_DATA','E5_DATA'})
		aAdd(aAux,{'FK3_RECPAG','E5_RECPAG'})
		aAdd(aAux,{'FK3_MOEDA','E5_MOEDA'})
		aAdd(aAux,{'FK3_FILORI','E5_FILORIG'})

	Case cTabela == 'FK4' //Impostos Retidos.

		aAdd(aAux,{'FK4_DATA','E5_DATA'})
		aAdd(aAux,{'FK4_RECPAG','E5_RECPAG'})
		aAdd(aAux,{'FK4_MOEDA','E5_MOEDA'})
		aAdd(aAux,{'FK4_FILORI','E5_FILORIG'})

	Case cTabela == 'FK5' //Mov. Bancaria

		aAdd(aAux,{'FK5_DATA','E5_DATA'})
		aAdd(aAux,{'FK5_VALOR','E5_VALOR'})
		aAdd(aAux,{'FK5_MOEDA','E5_MOEDA'})
		aAdd(aAux,{'FK5_NATURE','E5_NATUREZ'})
		aAdd(aAux,{'FK5_BANCO','E5_BANCO'})
		aAdd(aAux,{'FK5_AGENCI'	,'E5_AGENCIA'})
		aAdd(aAux,{'FK5_CONTA','E5_CONTA'})
		aAdd(aAux,{'FK5_NUMCH','E5_NUMCHEQ'})
		aAdd(aAux,{'FK5_DOC','E5_DOCUMEN'})
		aAdd(aAux,{'FK5_LOTE','E5_LOTE'})
		aAdd(aAux,{'FK5_RECPAG','E5_RECPAG'})
		aAdd(aAux,{'FK5_HISTOR','E5_HISTOR'})
		aAdd(aAux,{'FK5_TPDOC','E5_TIPODOC'})
		aAdd(aAux,{'FK5_VLMOE2','E5_VLMOED2'})
		aAdd(aAux,{'FK5_DTDISP','E5_DTDISPO'})
		aAdd(aAux,{'FK5_FILORI','E5_FILORIG'})
		aAdd(aAux,{'FK5_MODSPB','E5_MODSPB'})
		aAdd(aAux,{'FK5_SEQCON','E5_SEQCON'})
		aAdd(aAux,{'FK5_TERCEI','E5_TERCEIR'})
		aAdd(aAux,{'FK5_TPMOV','E5_TIPOMOV'})
		aAdd(aAux,{'FK5_OK','E5_OK'})
		aAdd(aAux,{'FK5_RATEIO','E5_RATEIO'})
		aAdd(aAux,{'FK5_SEQ','E5_SEQ'})
		aAdd(aAux,{'FK5_PROTRA','E5_PROCTRA'})
		aAdd(aAux,{'FK5_CCUSTO','E5_CCUSTO'})
		aAdd(aAux,{'FK5_LA','E5_LA'})
		aAdd(aAux,{'FK5_ORDREC','E5_ORDREC'})
		aAdd(aAux,{'FK5_TXMOED','E5_TXMOEDA'})
		aAdd(aAux,{'FK5_ORIGEM','E5_ORIGEM'})

	Case cTabela == 'FK6' //Valores Acessorios.

		aAdd(aAux,{'FK6_TPDESC','E5_TPDESC'})
		aAdd(aAux,{'FK6_TPDOC','E5_TIPODOC'})
		aAdd(aAux,{'FK6_RECPAG','E5_RECPAG'})
		aAdd(aAux,{'FK6_VALMOV','E5_VALOR'})
		aAdd(aAux,{'FK6_HISTOR','E5_HISTOR'})

		If lCmpFK6
			aAdd(aAux,{'FK6_DATA'  ,'E5_DATA'})
			aAdd(aAux,{'FK6_MOEDA' ,'E5_MOEDA'})
			aAdd(aAux,{'FK6_TXMOED','E5_TXMOEDA'})
			aAdd(aAux,{'FK6_VLMOE2','E5_VLMOED2'})
			aAdd(aAux,{'FK6_LA'    ,'E5_LA'})
			aAdd(aAux,{'FK6_TXMOED','E5_TXMOEDA'})
			aAdd(aAux,{'FK6_ORIGEM','E5_ORIGEM'})
		Endif

	Case cTabela == 'FK8'

		aAdd(aAux,{'FK8_TPLAN','E5_TIPOLAN'})
		aAdd(aAux,{'FK8_DEBITO','E5_DEBITO'})
		aAdd(aAux,{'FK8_CREDIT','E5_CREDITO'})
		aAdd(aAux,{'FK8_RATEIO','E5_RATEIO'})
		aAdd(aAux,{'FK8_CCD','E5_CCD'})
		aAdd(aAux,{'FK8_CCC','E5_CCC'})
		aAdd(aAux,{'FK8_ARQRAT','E5_ARQRAT'})
		aAdd(aAux,{'FK8_ITEMD','E5_ITEMD'})
		aAdd(aAux,{'FK8_ITEMC','E5_ITEMC'})
		aAdd(aAux,{'FK8_CLVLDB','E5_CLVLDB'})
		aAdd(aAux,{'FK8_CLVLCR','E5_CLVLCR'})
		aAdd(aAux,{'FK8_DIACTB','E5_DIACTB'})
		aAdd(aAux,{'FK8_NODIA','E5_NODIA'})

	Case cTabela == 'FK9'

		aAdd(aAux,{'FK9_SITUA','E5_SITUA'})
		aAdd(aAux,{'FK9_PRJPMS','E5_PROJPMS'})
		aAdd(aAux,{'FK9_EDTPMS','E5_EDTPMS'})
		aAdd(aAux,{'FK9_TASPMS','E5_TASKPMS'})
		aAdd(aAux,{'FK9_OPERAD','E5_OPERAD'})
		aAdd(aAux,{'FK9_NUMMOV','E5_NUMMOV'})
		aAdd(aAux,{'FK9_FLDMED','E5_FLDMED'})
		aAdd(aAux,{'FK9_FORMPG','E5_FORMAPG'})

	End Case

	aRet := aClone(aAux)
	aSize(aAux,0)
	aAux := Nil
Return aRet

/*/{Protheus.doc}FinGrvSE5
Função que faz a gravação dos valores na SE5.
@author William Matos Gundim Junior
@since  04/04/2014
@version 12
/*/
User Function XFinGrvSE5(aCamposOrig, aDePara,oDetail,nLinha)
	Local nY := 0
	Local nPos := 0
	Default oDetail :=  NIL
	Default aCamposOrig := {}
	Default aDePara 	  :=  {}
	Default nLinha := 1

	For nY := 1 To Len(aCamposOrig)

		If oDetail:IsFieldUpdated(aCamposOrig[nY][1])  //Retorna se campo foi atualizado.
			//Grava SE5 com valores da FK6.
			If ( nPos := aScan(aDePara,{|x| AllTrim( x[1] ) == aCamposOrig[nY][1] } ) ) > 0
				&(aDePara[nPos,2]) := oDetail:GetValue(aCamposOrig[nY][1],nLinha)
			EndIf
		EndIf

	Next nY

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} FINDELFKs
Função para retornar a identificação do processo do movimento
financeiro

@param cChave, Identificação do registro de origem
@param cAlias, Identificação da tabela de origem

@author Totvs
@since 18/04/2014
@version P12
/*/
//-------------------------------------------------------------------

User Function XFINDELFKs(cChave, cAlias)

	Local aArea := GetArea()
	Local cIdDOCFK7 := ""
	Local cChaveFKD := ""
	Local lLocBRA   := cPaisLoc == "BRA"

	dbSelectArea( "FK7" )
	FK7->(DbSetOrder(2)) //FK7_FILIAL+FK7_ALIAS+FK7_CHAVE
	If dbSeek(xFilial("FK7")+cAlias+cChave)
		If ExistBlock("FFKDLIB")
			ExecBlock("FFKDLIB",.F.,.F.)
		Endif

		cIdDOCFK7 := FK7->FK7_IDDOC

		If lLocBRA
            Fa986excl(cAlias)
        EndIf

		Reclock("FK7", .F.)
		FK7->(DbDelete())
		FK7->(Msunlock())

		//Valores Acessorios - Exclusão
		If U_XFInDicTVA()
			FKD->(dbSetOrder(2))		//FKD_FILIAL+FKD_IDDOC+FKD_CODIGO
			If FKD->(DbSeek(xFilial("FKD")+cIdDOCFK7))

				cChaveFKD := xFilial("FKD")+cIdDOCFK7

				While FKD->(!EOF()) .AND. FKD->(FKD_FILIAL+FKD_IDDOC) == cChaveFKD
					RecLock("FKD",.F.)
					FKD->(DbDelete())
					FKD->(MsUnlock())

					FKD->(dbSkip())
				EndDo

			Endif
		Endif
	Endif

	RestArea(aArea)

Return


/*{Protheus.doc}FINVerMov
Função que retorna se o TIPODOC movimenta banco
@author Totvs
@since  23/04/2014
@version P12
*/
User Function XFINVerMov(cTipoDoc)
	Local lRet := .T.
	Default cTipoDoc	:= ""

	lRet := GetAdvFVal("FKB","FKB_ATUBCO",xFilial("FKB")+cTipoDoc,1,"") == "1"

Return lRet


//----------------------------------------------------------------------
/*{Protheus.doc}FINGRVFK7
Verifica se existe FK7 para o título, caso não exista grava
Retorno: FK7_IDDOC
@author Totvs
@since  23/04/2014
@version P12
*/
//----------------------------------------------------------------------
User Function XXXFINGRVFK7(cAlias, cChave, cFilMov)
	Local aAreaAnt	:= GetArea()
	Local cRet 		:= ""
	Local lChave	:= .T.
	Local cFilFK7	:= ""

	If __lFK7Cpos == NIL
		__lFK7Cpos	:= FK7->(ColumnPos("FK7_CLIFOR")) > 0
	Endif

	Default cFilMov := Substr(cChave,1,nTamFil)

	cFilFK7 := PadR(xFilial("FK7", cFilMov),nTamFil)

	dbSelectArea("FK7")
	dbSetOrder(2)

	If dbSeek(cFilFK7 + cAlias + cChave)
		cRet := FK7->FK7_IDDOC
	Else
		//Tratativa para validar a ocorrência de repetição da chave da FWUUIDV4, caso ocorra
		FK7->(dbSetOrder(1))
		While lChave

			cRet := FWUUIDV4()
			If LockByName( cRet, .T./*lEmpresa*/, .T./*lFilial*/ )

				If dbSeek( cFilFK7 + cRet )
					lChave = .T.
				Else
					Reclock("FK7", .T.)
						FK7_FILIAL	:= xFilial("FK7", cFilMov)
						FK7_IDDOC	:= cRet
						FK7_ALIAS	:= cAlias
						FK7_CHAVE	:= cChave
					FK7->(MsUnlock())

					//Grava os novos campos
					If __lFK7Cpos .and. Empty(FK7->FK7_CLIFOR)
						U_XFinFK7Cpos (FK7->FK7_CHAVE)
					Endif

					lChave := .F.
				EndIf
				UnLockByName( cRet, .T./*lEmpresa*/, .T./*lFilial*/ )

			EndIf
		EndDo
	Endif

	RestArea(aAreaAnt)
	FwFreeArray(aAreaAnt)

Return cRet

/*/{Protheus.doc} FnBuscaSE5
Filtra os dados da SE5 com TIPODOC = '' ou TR.
@author William Matos Gundim Junior
@since 10/04/2014
@version P12
/*/
Static Function XFnBuscaSE5(nPosSE5)
	Local cQuery 	:= ""
	Local cProc		:= ""
	Local cIdOrig 	:= ""
	Local nX		:= 0
	Local lRet 		:= .T.
	Local cAliasSE5	:= GetNextAlias()
	Local cFilBkp 	:= cFilAnt
	Local cBanco 		:= ""
	Local cAgencia 	:= ""
	Local cConta 		:= ""
	Local cNatureza	:= ""
	Local cCart		:= ""
	Local cFilSe5		:= ""


	Default nPosSE5 := 0

	If nPosSE5 = 0
		cQuery := "SELECT SE5.R_E_C_N_O_ RECNO "	+ CRLF
		cQuery += " FROM " +	RetSQLTab('SE5')	+	 CRLF
		cQuery += " WHERE " +	 CRLF
		cQuery += " E5_TIPODOC IN('','TR') AND " 	 + CRLF
		cQuery += " E5_DATA >= '" + DTOS(MV_PAR01) + "' AND " + CRLF
		cQuery += " E5_DATA <= '" + DTOS(MV_PAR02) + "' AND " + CRLF
		cQuery += "	E5_SITUACA NOT IN ('C')  AND "			+ CRLF // retirada o X, pois se trata de momentos estornados pelo FINA100 e retirada o E que é o movimento de estorno em si
		// esses movimentos estornados estão visiveis no extrato e passiveis de conciliação.
		cQuery += " E5_MOVFKS  <> 'S' AND " 		+ CRLF
		cQuery += " SE5.D_E_L_E_T_ = ' ' AND " 		+ CRLF
		//JOSE MATHEUS
		//cQuery += " E5_FILIAL = '04001000100' " 		+ CRLF
		cQuery += " UNION " + CRLF

		//Documento que movimenta banco e não esta relacionado a nenhum titulo.
		cQuery += "SELECT SE5.R_E_C_N_O_ RECNO "	+ CRLF
		cQuery += " FROM " +	RetSQLTab('SE5')			+	CRLF
		cQuery += " WHERE E5_TIPODOC IN ( " 			+	CRLF
		cQuery += " 			SELECT FKB_TPDOC " + " FROM " +	RetSQLTab('FKB') + " WHERE FKB_ATUBCO = '1' AND "	+	CRLF
		//Cheques são filtrados na FnBuscaEF.
		cQuery += " 			FKB_TPDOC <> 'TR' AND D_E_L_E_T_ = ' ') AND " +	CRLF
		cQuery += " E5_DATA >= '" + DTOS(MV_PAR01) + "' AND " + CRLF
		cQuery += " E5_DATA <= '" + DTOS(MV_PAR02) + "' AND " + CRLF
		cQuery += "	E5_SITUACA NOT IN ('C','E','X')  		AND (( "	+ CRLF
		//Não relacionado a nenhum titulo.
		cQuery += " E5_PREFIXO = '' AND " 		+ CRLF
		cQuery += " E5_NUMERO  = '' AND " 		+ CRLF
		cQuery += " E5_PARCELA = '') OR " 		+ CRLF
		//Despesas bancárias geradas pelo retorno CNAB
		cQuery += " E5_TIPODOC IN ( 'DB', 'OD' )) AND " 		+ CRLF
		//
		cQuery += " E5_MOVFKS  <> 'S' AND " + CRLF
		cQuery += " SE5.D_E_L_E_T_ = ' ' AND " + CRLF
		//JOSE MATHEUS
		//cQuery += " E5_FILIAL = '04001000100' " 		+ CRLF
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5,.T.,.T.)
		dbSelectArea(cAliasSE5)
		DbGotop()
		lRet := !(cAliasSE5)->(EOF())

	EndIf

	dbSelectArea('SE5')
	dbSelectArea('SA6')
	SA6-> (DbSetOrder(1))

	While lRet

		If nPosSE5 = 0
			SE5->(dbGoTo(	(cAliasSE5)->RECNO))
		Else
			SE5->(dbGoTo(nPosSE5))
		EndIf
		If Alltrim(SE5->E5_TIPODOC) $ "BA|VL|V2|LJ|CP" .and. Empty(SE5->E5_KEY)
			If nPosSE5 > 0
				lRet := .F.
				Exit
			Else
				(cAliasSE5)->(dbSkip())
				lRet := !(cAliasSE5)->(EOF())
				Loop
			EndIf
		EndIf
		If lFilExclus
			cFilAnt := SE5->E5_FILIAL
		EndIf

		cBanco		:= SE5->E5_BANCO
		cAgencia 	:= SE5->E5_AGENCIA
		cConta	 	:= SE5->E5_CONTA
		cCart		:= SE5->E5_RECPAG
		cFilSe5		:= SE5->E5_FILIAL

		//Novo processo
		cProc	:= U_XFINFKSID('FKA','FKA_IDPROC')
		cIdOrig := FWUUIDV4()

		//Grava FKA - Auxiliar
		RecLock("FKA", .T.)
		FKA_FILIAL 	:= SE5->E5_FILIAL
		FKA_IDFKA	:= FWUUIDV4()
		FKA_IDPROC	:= cProc
		FKA_IDORIG	:= cIdOrig
		FKA_TABORI	:= "FK5"
		FKA->(MsUnlock())

		If lSE5GRVFK
			aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK5", aCamposFK5})
			If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
				aCamposFK5 := Aclone(aSE5GRVFK)
			EndIf
			Asize(aSE5GRVFK, 0)
			aSE5GRVFK := Nil
		EndIf

		RecLock("FK5", .T.)

		For nX := 1 To Len(aCamposFK5)

			nPos := SE5->(FieldPos(aCamposFK5[nX][2]) )
			If nPos > 0

				FieldPut(FK5->(FieldPos(aCamposFK5[nX][1])), SE5->(FieldGet(nPos) ) )

				If aCamposFK5[nX][2] == "E5_MOEDA" .AND. Empty(SE5->(FieldGet(nPos)))
					If SA6->(dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
						FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), StrZero(SA6->A6_MOEDA,2) )
					Else
						FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), "01" )
					EndIf
				EndIf
				If aCamposFK5[nX][2] == "E5_NATUREZ" .AND. Empty(SE5->(FieldGet(nPos)))
					cNatureza := U_XFINNATMOV(cCart)
					FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), cNatureza )
				EndIf
				If aCamposFK5[nX][2] == "E5_FILORIG" .AND. Empty(SE5->(FieldGet(nPos)))
					FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), cFilSe5 )
				EndIf

			EndIf

		Next nX

		FK5->FK5_FILIAL := SE5->E5_FILIAL
		FK5->FK5_IDMOV 	:= cIdOrig
		FK5->FK5_ORIGEM := "CRIAFK"
		FK5->FK5_STATUS := CriaVar("FK5_STATUS")
		FK5->FK5_TERCEI	:= CriaVar("FK5_TERCEI")
		FK5->FK5_TPMOV	:= CriaVar("FK5_TPMOV")

		If AllTrim(FK5->FK5_TPDOC) $ 'OD|DB' .And. !Empty(SE5->E5_NUMERO)
			cChave := xFilial("SE1", SE5->E5_FILORIG) + "|" +  SE5->E5_PREFIXO + "|" + SE5->E5_NUMERO + "|" + SE5->E5_PARCELA + "|" + SE5->E5_TIPO + "|" +;
			SE5->E5_CLIFOR + "|" + SE5->E5_LOJA

			FK5->FK5_IDDOC := U_XXXFINGRVFK7('SE1', cChave)
		EndIf

		If Empty(FK5->FK5_TPDOC)
			FK5->FK5_TPDOC := "DH"
		EndIf
		FK5->FK5_RATEIO := If(SE5->E5_RATEIO == 'S','1','2')
		FK5->(MsUnlock())

		//Grava valores na FK8 com os dados contabeis.
		If !Empty(SE5->E5_TIPOLAN)

			If lSE5GRVFK
				aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK8", aCamposFK8})
				If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
					aCamposFK8 := Aclone(aSE5GRVFK)
				EndIf
				Asize(aSE5GRVFK, 0)
				aSE5GRVFK := Nil
			EndIf

			RecLock("FK8", .T.)
			For nX := 1 To Len(aCamposFK8)

				nPos := SE5->(FieldPos(aCamposFK8[nX][2]) )
				If nPos > 0

					FieldPut(FK8->(FieldPos(aCamposFK8[nX][1])), SE5->(FieldGet(nPos) ) )

				EndIf

			Next nX
			FK8->FK8_FILIAL := SE5->E5_FILIAL
			FK8->FK8_IDMOV 	:= cIdOrig
			FK8->FK8_TPLAN := If(SE5->E5_TIPOLAN == 'D','1', If(SE5->E5_TIPOLAN == 'C','2','X'))
			FK8->(MsUnlock())

		EndIf

		//Atualiza o campo E5_MOVFKS = 'S' -> Campo de controle do migrador.
		Reclock("SE5", .F.)
		E5_MOVFKS := "S"
		E5_IDORIG := cIdOrig
		E5_TABORI := "FK5"
		SE5->(MsUnlock())

		If nPosSE5 > 0
			lRet := .F.
		Else
			(cAliasSE5)->(dbSkip())
			lRet := !(cAliasSE5)->(EOF())
		EndIf
	End
	If nPosSE5 = 0
		(cAliasSE5)->(DBCloseArea())
	EndIf
	FErase(cAliasSE5 + GetDBExtension())
	cFilAnt := cFilBkp
Return

/*/{Protheus.doc} FnBaixaE2
Filtra os dados baixados da SE2.
@author William Matos Gundim Junior
@since 10/04/2014
@version P12
/*/
Static Function XFnBaixaE2(nPosSE5, cArqLog)
	Local nX		:= 0
	Local cQuery	:= ''
	Local cChave	:= ''
	Local cIdDoc	:= ''
	Local cIdOrig	:= ''
	Local cIdOrigFK5 := ''
	Local cProc	:= ''
	Local cAliasSE2 := GetNextAlias()
	Local cGeraFK6  := 'C2|CM|CX|DC|J2|JR|M2|MT|VM'
	Local cTabOri := ""
	Local cIdOrigEs := ""
	Local cFilBkp := cFilAnt
	Local cSeqAtu := ""
	Local cChaveAnt 	:= ""
	Local cBanco 		:= ""
	Local cAgencia 	:= ""
	Local cConta 		:= ""
	Local cNatureza	:= ""
	Local cTipDoc :="ES"
	Local lCmpFK2 	:= FK2->(FieldPos("FK2_DTDISP")) > 0  .and. FK2->(FieldPos("FK2_DTDIGI")) > 0
	Local cTpDesc	:= ""

	Default nPosSE5 := 0 //Variavel com posição da SE5 que deve ser atualizada.

	If cPaisLoc<> "BRA"
		cTipDoc:="ES|BA|CP"
	EndIf

	//Baixas a Pagar.
	cQuery := "SELECT SE5.R_E_C_N_O_ RECNO, E5_TIPODOC TPDOC"	+ CRLF
	cQuery += " FROM " +	RetSQLTab('SE5')	+	 CRLF
	cQuery += "	JOIN " + RetSQLTab('SE2')+ CRLF
	cQuery += " ON   SE5.E5_FILORIG = SE2.E2_FILORIG	AND " + CRLF
	cQuery += "      SE5.E5_PREFIXO = SE2.E2_PREFIXO	AND " + CRLF
	cQuery += "      SE5.E5_NUMERO  = SE2.E2_NUM		AND " + CRLF
	cQuery += "      SE5.E5_PARCELA = SE2.E2_PARCELA 	AND " + CRLF
	cQuery += "      SE5.E5_TIPO	= SE2.E2_TIPO 		AND " + CRLF
	cQuery += "      SE5.E5_CLIFOR 	= SE2.E2_FORNECE 	AND " + CRLF
	cQuery += "      SE5.E5_CLIENTE	= ' '			 	AND " + CRLF
	cQuery += "      SE5.E5_LOJA	= SE2.E2_LOJA AND " 	      + CRLF
	cQuery += "      SE5.E5_NATUREZ = SE2.E2_NATUREZ AND " 	      + CRLF
	cQuery += "      SE2.D_E_L_E_T_ = ' ' " 	      + CRLF
	cQuery += " WHERE "  			 				+ CRLF

	//Filtra pelo RECNO informado.
	If nPosSE5 > 0
		cQuery += " E5_PREFIXO = '" + SE5->E5_PREFIXO	+ "' AND "	+ CRLF
		cQuery += " E5_NUMERO  = '" + SE5->E5_NUMERO	+ "' AND "	+ CRLF
		cQuery += " E5_PARCELA = '" + SE5->E5_PARCELA	+ "' AND "	+ CRLF
		cQuery += " E5_TIPO = '"	+ SE5->E5_TIPO		+ "' AND "	+ CRLF

		cQuery += " E5_CLIFOR = '"  + SE5->E5_CLIFOR	+ "' AND "	+ CRLF
		cQuery += " E5_LOJA = '"	+ SE5->E5_LOJA		+ "' AND "	+ CRLF
		cQuery += " E5_TIPODOC NOT IN ('PA') AND " + CRLF
		cQuery += " E5_SITUACA NOT IN ('C','E','X') AND "			+ CRLF

	Else

		cQuery += " E5_DATA >= '" 	+ DTOS(MV_PAR01) + "' AND " 	+ CRLF
		cQuery += " E5_DATA  <= '" + DTOS(MV_PAR02) + "' AND " 	+ CRLF
		cQuery += "	E5_SITUACA NOT IN ('C','E','X')  AND "				+ CRLF
		cQuery += " E5_MOVFKS  <> 'S' AND " 		+ CRLF
		cQuery += " E5_TIPODOC NOT IN ('PA') AND " + CRLF
		cQuery += " SE5.D_E_L_E_T_ = ' ' " 		+ CRLF

		cQuery += " UNION " + CRLF

		//Adiantamento - PA.
		cQuery += "SELECT SE5.R_E_C_N_O_ RECNO, E5_TIPODOC TPDOC"	+ CRLF
		cQuery += " FROM " +	RetSQLTab('SE5')	+	 CRLF
		cQuery += "	JOIN " + RetSQLTab('SE2')+ CRLF
		cQuery += " ON   SE5.E5_FILORIG = SE2.E2_FILORIG	AND " + CRLF
		cQuery += "      SE5.E5_PREFIXO = SE2.E2_PREFIXO	AND " + CRLF
		cQuery += "      SE5.E5_NUMERO  = SE2.E2_NUM		AND " + CRLF
		cQuery += "      SE5.E5_PARCELA = SE2.E2_PARCELA 	AND " + CRLF
		cQuery += "      SE5.E5_TIPO	= SE2.E2_TIPO 		AND " + CRLF
		cQuery += "      SE5.E5_CLIFOR 	= SE2.E2_FORNECE 	AND " + CRLF
		cQuery += "      SE5.E5_CLIENTE	= ' '			 	AND " + CRLF
		cQuery += "      SE5.E5_LOJA	= SE2.E2_LOJA AND " 	      + CRLF
		cQuery += "      SE5.E5_NATUREZ = SE2.E2_NATUREZ AND " 	      + CRLF
		cQuery += "      SE2.D_E_L_E_T_ = ' ' " 	      + CRLF
		cQuery += " WHERE "																									+ CRLF
		cQuery += " E5_TIPODOC IN('PA','BA') AND "  			 					+ CRLF
		cQuery += " E5_DATA >= '" + DTOS(MV_PAR01) + "' AND " 	+ CRLF
		cQuery += " E5_DATA <= '" + DTOS(MV_PAR02) + "' AND " 	+ CRLF
		cQuery += " E5_MOTBX <> 'CMP' AND " 													+ CRLF
		cQuery += "	E5_SITUACA NOT IN ('C','E','X')  AND "				+ CRLF
		cQuery += " E5_MOVFKS  <> 'S' AND " 		+ CRLF
	EndIf
	cQuery += " SE5.D_E_L_E_T_ = ' ' " 			+ CRLF
	cQuery += " ORDER BY RECNO,TPDOC " + CRLF

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)
	dbSelectArea(cAliasSE2)

	DbGotop()

	dbSelectArea('SE5')
	dbSelectArea('SA6')
	SA6-> (DbSetOrder(1))
	While !(cAliasSE2)->(Eof())

		SE5->(dbGoTo((cAliasSE2)->RECNO))

		cTabOri := ""
		cIdOrigFK5 := ""
		cProc := ""
		cIdOrigEs := ""

		If lFilExclus
			cFilAnt := SE5->E5_FILIAL
		EndIf
		//se for estorno de cheque, nao migrar aqui e sim este deve ser no finm030
		If Alltrim(SE5->E5_TIPODOC) == "ES" .And. Empty(SE5->E5_MOTBX) .And. !Empty(SE5->E5_NUMCHEQ)
			(cAliasSE2)->(dbSkip())
			Loop
		EndIf

		//Chave para ser gravada na FK7.
		cChave :=  xFilial("SE5", SE5->E5_FILORIG) + "|" +  SE5->E5_PREFIXO + "|" + SE5->E5_NUMERO + "|" + SE5->E5_PARCELA + "|" + SE5->E5_TIPO + "|" +;
					SE5->E5_CLIFOR + "|" + SE5->E5_LOJA

		//tratamento para base antiga em que os valores acessorios sao gravados primeiro
		// que o registro da Baixa, para que seja criado primeiro o registro FK1
		If (cSeqAtu != SE5->E5_SEQ .or. cChaveAnt != cChave .or. SE5->E5_TIPODOC $ cTipDoc)
			cIdOrig := FWUUIDV4()
			cSeqAtu := SE5->E5_SEQ
			cChaveAnt := cChave
		Endif

		//somente gera FK2 para tipodoc de baixa BA VL ou CP

		If Alltrim(SE5->E5_TIPODOC) $ "BA|VL|V2|ES|LJ|CP"
			cIdDoc := U_XXXFINGRVFK7('SE2', cChave)

			If Alltrim(SE5->E5_TIPODOC) == "ES"
				cIdOrigEs := XGeraEstFK5( "P" )
			EndIf

			//Novo processo
			If Empty(cProc := U_XFINProcFKs(If(!Empty(cIdOrigEs) ,cIdOrigEs,SE5->E5_IDORIG), "FK2" ))
				cProc := U_XFINFKSID('FKA','FKA_IDPROC')
			EndIf
			//Grava FKA - Rastreio de movimento---------------------
			RecLock("FKA", .T.)
			FKA_FILIAL	:= SE5->E5_FILIAL
			FKA_IDFKA	:= FWUUIDV4()
			FKA_IDPROC	:= cProc
			FKA_IDORIG	:= cIdOrig
			FKA_TABORI	:= "FK2"
			FKA->(MsUnlock())

			If lSE5GRVFK
				aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK2", aCamposFK2})
				If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
					aCamposFK2 := Aclone(aSE5GRVFK)
				EndIf
				Asize(aSE5GRVFK, 0)
				aSE5GRVFK := Nil
			EndIf

			RecLock("FK2", .T.)
			//Grava FK2 - Baixas a Pagar-----------------------------
			For nX := 1 To Len(aCamposFK2)
				nPos := SE5->(FieldPos(aCamposFK2[nX][2]) )
				If nPos > 0
					FieldPut(FK2->(FieldPos(aCamposFK2[nX][1])), SE5->(FieldGet(nPos) ) )
				EndIf
			Next nX

			FK2->FK2_FILIAL := SE5->E5_FILIAL
			FK2->FK2_IDFK2 := cIdOrig
			FK2->FK2_IDDOC  := cIdDoc
			FK2->FK2_IDPROC := SE5->E5_IDENTEE
			FK2->FK2_ORIGEM	:= "CRIAFK"
			If Empty(SE5->E5_MOEDA)
				FK2->FK2_MOEDA := "01"
			EndIf

			//Gravação dos campos FK2_DTDISP e FK2_DTDIG
			If lCmpFK2
				FK2->FK2_DTDISP := SE5->E5_DTDISPO
				FK2->FK2_DTDIGI := SE5->E5_DTDIGIT
			Endif

			FK2->(MsUnlock())
			cTabOri := "FK2"


		ElseIf Alltrim(SE5->E5_TIPODOC) == "CH"
			U_XXFnBuscaEF( (cAliasSE2)->RECNO )
			(cAliasSE2)->(dbSkip())
			Loop
		EndIf


		//------------------------------------------------------
		Do Case
			//Grava FK6 - Valores acessórios.
		Case SE5->E5_TIPODOC $ cGeraFK6

			cIdFK6 := U_XFINFKSID('FK6', 'FK6_IDFK6')

			If lSE5GRVFK
				aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK6", aCamposFK6})
				If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
					aCamposFK6 := Aclone(aSE5GRVFK)
				EndIf
				Asize(aSE5GRVFK, 0)
				aSE5GRVFK := Nil
			EndIf

			RecLock("FK6", .T.)
			For nX := 1 To Len(aCamposFK6)

				nPos := SE5->(FieldPos(aCamposFK6[nX][2]) )
				If nPos > 0

					FieldPut(FK6->(FieldPos(aCamposFK6[nX][1])),SE5->(FieldGet(nPos)))

				EndIf

			Next nX

			cTpDesc := IIF(FK6->FK6_TPDESC == "C","1","2")

			FK6->FK6_FILIAL := SE5->E5_FILIAL
			FK6->FK6_IDFK6	:= cIdFK6
			FK6->FK6_IDORIG := cIdOrig
			FK6->FK6_TABORI := 'FK2'
			FK6->FK6_TPDESC := cTpDesc

			FK6->(MsUnlock())
			cTabOri := "FK2"
			cIdFK6 := "" //Limpa o IDFK6
			// FK5 - Grava valores na tabela de movimentação bancaria.
		Case	U_XFINVerMov(SE5->E5_TIPODOC).AND. MovBcobx(SE5->E5_MOTBX , .F.)//Só gera FK5 se o motivo de baixa atualiza banco

			cIdOrigFK5 := FWUUIDV4()

			If Empty(cProc)
				If Empty(cProc := U_XFINProcFKs(SE5->E5_IDORIG, "FK2" ))
					cProc := U_XFINFKSID('FKA','FKA_IDPROC')
				EndIf
			EndIf
			cBanco		:= SE5->E5_BANCO
			cAgencia 	:= SE5->E5_AGENCIA
			cConta 	    := SE5->E5_CONTA

			//
			RecLock("FKA", .T.)
			FKA_FILIAL 	:= SE5->E5_FILIAL
			FKA_IDFKA	:= FWUUIDV4()
			FKA_IDPROC	:= cProc
			FKA_IDORIG	:= cIdOrigFK5
			FKA_TABORI	:= "FK5"
			FKA->(MsUnlock())

			If lSE5GRVFK
				aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK5", aCamposFK5})
				If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
					aCamposFK5 := Aclone(aSE5GRVFK)
				EndIf
				Asize(aSE5GRVFK, 0)
				aSE5GRVFK := Nil
			EndIf

			RecLock("FK5", .T.)

			For nX := 1 To Len(aCamposFK5)

				nPos := SE5->(FieldPos(aCamposFK5[nX][2]) )
				If nPos > 0

					FieldPut(FK5->(FieldPos(aCamposFK5[nX][1])), SE5->(FieldGet(nPos) ) )
					If aCamposFK5[nX][2] == "E5_MOEDA" .AND. Empty(SE5->(FieldGet(nPos)))
						If SA6->(dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
							FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), StrZero(SA6->A6_MOEDA,2) )
						Else
							FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), "01" )
						EndIf
					EndIf

					If aCamposFK5[nX][2] == "E5_NATUREZ" .AND. Empty(SE5->(FieldGet(nPos)))
						cNatureza := U_XFINNATMOV("P")
						FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), cNatureza )
					EndIf

				EndIf

			Next nX

			FK5->FK5_FILIAL := SE5->E5_FILIAL
			FK5->FK5_IDMOV 	:= cIdOrigFK5
			FK5->FK5_ORIGEM:= "CRIAFK"


			cTabOri := Iif(cTabOri == "FK2", cTabOri, "FK5")
			cIdOrig := Iif(cTabOri == "FK2",cIdOrig ,cIdOrigFK5)
			FK5->(MsUnlock())

		EndCase

		//Atualiza o campo E5_MOVFKS = 'S' -> Campo de controle do migrador.
		Reclock("SE5", .F.)
		E5_MOVFKS := "S"
		E5_IDORIG := cIdOrig
		E5_TABORI := cTabOri
		SE5->(MsUnlock())
		//-------------------------------------------------------------
		(cAliasSE2)->(dbSkip())

	Enddo
	(cAliasSE2)->(DBCloseArea())
	FErase(cAliasSE2 + GetDBExtension())

	//Reposiciona na SE5
	If nPosSE5 > 0
		SE5->(dbGoTo(nPosSE5))
	EndIf
	cFilAnt := cFilBkp
Return

/*/{Protheus.doc} FnBaixaE1
Filtra os dados baixados da SE1 - Baixas a Receber.
@author William Matos Gundim Junior
@since 10/04/2014
@version P12
/*/
Static Function XXFnBaixaE1(nPosSE5)
	Local nX 			:= 0
	Local cQuery := ''
	Local cProc	:= ''
	Local cChave := ''
	Local cIdDoc 	:= ''
	Local cIdOrig := ''
	Local cAliasSE1 := GetNextAlias()
	Local cGeraFK6  := 'C2|CM|CX|DC|J2|JR|M2|MT|VM'  
	Local cTabOri := ""
	Local cIdOrigFK5 := ""
	Local cIdOrigEs := ""
	Local cFilBkp := cFilAnt
	Local cSeqAtu	:= ""
	Local cChaveAnt := ""
	Local cBanco 		:= ""
	Local cAgencia 		:= ""
	Local cConta 		:= ""
	Local cNatureza	:= ""
	Local cTipDoc:="ES"
	Local cCodNat	:= U_XFINNATFKS()
	Local aAliasAnt	:= ""
	Local lCmpFK1 	:= FK1->(FieldPos("FK1_DTDISP")) .and. FK1->(FieldPos("FK1_DTDIGI"))
	Local lFina087	:= .F.
	Local aRecSe5	:= {}
	Local nCnt		:= 0
	Local cTpDesc	:=""
	Default nPosSE5 := 0

	If cPaisLoc<> "BRA"
		cTipDoc:="ES|BA|CP"
	EndIf

	//Baixas a Receber.
	cQuery := "SELECT SE5.R_E_C_N_O_ RECNO, E5_TIPODOC TPDOC"	+ CRLF
	cQuery += " FROM " +	RetSQLTab('SE5')	+	 CRLF
	cQuery += "	JOIN " + RetSQLTab('SE1')+ CRLF
	cQuery += " ON   SE5.E5_FILORIG = SE1.E1_FILORIG	AND " + CRLF
	cQuery += "      SE5.E5_PREFIXO = SE1.E1_PREFIXO	AND " + CRLF
	cQuery += "      SE5.E5_NUMERO  = SE1.E1_NUM		AND " + CRLF
	cQuery += "      SE5.E5_PARCELA = SE1.E1_PARCELA 	AND " + CRLF
	cQuery += "      SE5.E5_TIPO	= SE1.E1_TIPO 		AND " + CRLF
	cQuery += "      SE5.E5_CLIFOR 	= SE1.E1_CLIENTE 	AND " + CRLF
	cQuery += "      SE5.E5_FORNECE	= ' '			 	AND " + CRLF
	cQuery += "      SE5.E5_LOJA	= SE1.E1_LOJA AND " 	+ CRLF
	cQuery += "      SE5.E5_NATUREZ = SE1.E1_NATUREZ AND " 	+ CRLF
	cQuery += "      SE1.D_E_L_E_T_ = ' '   " 	+ CRLF
	cQuery += " WHERE " 	+ CRLF
	//Filtra apenas o recno informado.
	If nPosSE5 > 0
		cQuery += " E5_PREFIXO = '" + SE5->E5_PREFIXO  	+ "' AND "	+ CRLF
		cQuery += " E5_NUMERO  = '" + SE5->E5_NUMERO	+ "' AND "	+ CRLF
		cQuery += " E5_PARCELA = '" + SE5->E5_PARCELA	+ "' AND "	+ CRLF
		cQuery += " E5_TIPO = '"	+ SE5->E5_TIPO		+ "' AND "	+ CRLF
		cQuery += " E5_CLIFOR = '"	+ SE5->E5_CLIFOR	+ "' AND "	+ CRLF
		cQuery += " E5_LOJA = '"	+ SE5->E5_LOJA		+ "' AND "	+ CRLF
		cQuery += " E5_TIPODOC NOT IN ('RA') AND " 			+ CRLF //Não importar RA, pois o mesmo deve ser importado apenas para FK5
		cQuery += "	E5_SITUACA NOT IN ('C','E','X') AND	"			+ CRLF
		cQuery += " SE5.D_E_L_E_T_ = ' ' " 		+ CRLF
	Else

		cQuery += " E5_DATA >= '" 	+ DTOS(MV_PAR01)	+ "' AND " 	+ CRLF
		cQuery += " E5_DATA  <= '" + DTOS(MV_PAR02)		+ "' AND " 	+ CRLF
		cQuery += " E5_SITUACA NOT IN ('C','E','X') AND "			+ CRLF
		cQuery += " E5_MOVFKS  <> 'S' AND " 						+ CRLF
		cQuery += " E5_TIPODOC NOT IN ('RA') AND " 			+ CRLF //ADICIONEI TRATAMENTO A BAIXA DO TIPO BA
		cQuery += " SE5.D_E_L_E_T_ = ' ' " 							+ CRLF

		cQuery += " UNION "

		//Adiantamento - RA.
		cQuery += "SELECT SE5.R_E_C_N_O_ RECNO, E5_TIPODOC TPDOC"	+ CRLF
		cQuery += " FROM " +	RetSQLTab('SE5')	+	 CRLF
		cQuery += "	JOIN " + RetSQLTab('SE1')+ CRLF
		cQuery += " ON   SE5.E5_FILORIG = SE1.E1_FILORIG	AND " + CRLF
		cQuery += "      SE5.E5_PREFIXO = SE1.E1_PREFIXO	AND " + CRLF
		cQuery += "      SE5.E5_NUMERO  = SE1.E1_NUM		AND " + CRLF
		cQuery += "      SE5.E5_PARCELA = SE1.E1_PARCELA 	AND " + CRLF
		cQuery += "      SE5.E5_TIPO	= SE1.E1_TIPO 		AND " + CRLF
		cQuery += "      SE5.E5_CLIFOR 	= SE1.E1_CLIENTE 	AND " + CRLF
		cQuery += "      SE5.E5_FORNECE	= ' '			 	AND " + CRLF
		cQuery += "      SE5.E5_LOJA	= SE1.E1_LOJA AND "			  + CRLF
		cQuery += "      SE5.E5_NATUREZ	= SE1.E1_NATUREZ AND "			  + CRLF
		cQuery += "      SE1.D_E_L_E_T_ = ' ' "			  + CRLF
		cQuery += " WHERE " 				+ CRLF
		cQuery += " E5_TIPODOC IN('RA','BA') AND "  	 + CRLF
		cQuery += " E5_DATA >= '" + DTOS(MV_PAR01) + "' AND " 	+ CRLF
		cQuery += " E5_DATA <= '" + DTOS(MV_PAR02) + "' AND " 	+ CRLF
		cQuery += " E5_MOTBX <> 'CMP' AND " 					+ CRLF
		cQuery += "	E5_SITUACA NOT IN ('C','E','X')  AND "		+ CRLF
		cQuery += " E5_MOVFKS  <> 'S' AND " 	+ CRLF
		cQuery += " SE5.D_E_L_E_T_ = ' ' " 		+ CRLF
	EndIf

	cQuery += " ORDER BY RECNO,TPDOC "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
	dbSelectArea(cAliasSE1)
	DbGotop()

	dbSelectArea('SE5')
	dbSelectArea('SA6')
	SA6-> (DbSetOrder(1))
	While !(cAliasSE1)->(Eof())
		aRecSe5 := {}
		lFina087 := .F.
		SE5->(dbGoTo((cAliasSE1)->RECNO))
		aAdd(aRecSe5, (cAliasSE1)->RECNO)
		//Tratamento baixa por Recebimentos Diversos
		//Todos movimentos do recibo possuem o mesmo número de processo
		If AllTrim(SE5->E5_MOVFKS) $ "S"
			(cAliasSE1)->(DbSkip())
			Loop
		EndIf
		If AllTrim(SE5->E5_ORIGEM) $ 'FINA087A|FINA846|FINA840'
			aRecSe5 := U_XBxReciboE1((cAliasSE1)->RECNO)
			lFina087 := .T.
		EndIf
		cProc := ""
		For nCnt := 1 to Len(aRecSe5)
			SE5->(dbGoTo(aRecSe5[nCnt]))
			If Empty(SE5->E5_NATUREZ)
				aAliasAnt	:= GetArea()
				SE1->(dbSetOrder(1))
				If SE1->(dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
					Reclock("SE1",.F.)
					SE1->E1_NATUREZ	:= cCodNat
					MsUnlock()
				EndIf

				Reclock("SE5",.F.)
				SE5->E5_NATUREZ	:= cCodNat
				MsUnlock()
				RestArea(aAliasAnt)
			Endif
			cTabOri := ""
			cIdOrigFK5 := ""
			cIdOrigEs := ""
			If lFilExclus
				cFilAnt := SE5->E5_FILIAL
			EndIf

			//Chave para ser gravada na FK7.
			cChave := xFilial("SE1",SE5->E5_FILORIG) + "|" +  SE5->E5_PREFIXO + "|" + SE5->E5_NUMERO + "|" + SE5->E5_PARCELA + "|" + SE5->E5_TIPO + "|" +;
				SE5->E5_CLIFOR + "|" + SE5->E5_LOJA

			//se for estorno de cheque, nao migrar aqui e sim este deve ser no finm030
			If Alltrim(SE5->E5_TIPODOC) == "ES" .And. !Empty(SE5->E5_NUMCHEQ)
				(cAliasSE1)->(dbSkip())
				Loop
			EndIf

			//tratamento para base antiga em que os valores acessorios sao gravados primeiro
			// que o registro da Baixa, para que seja gravado o mesmo idorig
			If (cSeqAtu != SE5->E5_SEQ .or. cChaveAnt != cChave .or. SE5->E5_TIPODOC $ cTipDoc)
				cIdOrig := FWUUIDV4()
				cSeqAtu := SE5->E5_SEQ
				cChaveAnt:= cChave
			Endif

			// somente gera FK1 para tipodoc de baixa BA VL ou CP
			If Alltrim(SE5->E5_TIPODOC) $ "BA|VL|V2|ES|LJ|CP" .AND. !(lFina087 .AND. Alltrim(SE5->E5_TIPODOC) $ "VL")
				//Grava FK7 - Auxiliar da SE1|SE2-----------------------
				cIdDoc := U_XXXFINGRVFK7('SE1', cChave)  //GRAVA FK7
				cIdOrig := FWUUIDV4()

				If Alltrim(SE5->E5_TIPODOC) == "ES"
					cIdOrigEs := XGeraEstFK5( "R" )
				EndIf

				//Novo processo
				If !lFina087 .Or. Empty(cProc)
					If Empty(cProc := U_XFINProcFKs(Iif(!Empty(cIdOrigEs),cIdOrigEs,SE5->E5_IDORIG), "FK1" ))
						cProc := U_XFINFKSID('FKA','FKA_IDPROC')
					EndIf
				EndIf

				//Grava FKA - Rastreio de movimento---------------------
				RecLock("FKA", .T.)
				FKA_FILIAL 	    := SE5->E5_FILIAL
				FKA_IDFKA	 	:= FWUUIDV4()
				FKA_IDPROC		:= cProc
				FKA_IDORIG		:= cIdOrig
				FKA_TABORI		:= "FK1"
				FKA->(MsUnlock())

				If lSE5GRVFK
					aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK1", aCamposFK1})
					If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
						aCamposFK1 := Aclone(aSE5GRVFK)
					EndIf
					Asize(aSE5GRVFK, 0)
					aSE5GRVFK := Nil
				EndIf

				//Grava FK1 - Baixas a Receber-----------------------------
				RecLock("FK1", .T.)
				For nX := 1 To Len(aCamposFK1)

					nPos := SE5->(FieldPos(aCamposFK1[nX][2]) )
					If nPos > 0

						FieldPut(FK1->(FieldPos(aCamposFK1[nX][1])), SE5->(FieldGet(nPos) ) )

					EndIf

				Next nX

				FK1_FILIAL := SE5->E5_FILIAL
				FK1_IDFK1  := cIdOrig
				FK1_IDDOC  := cIdDoc
				FK1_IDPROC := SE5->E5_IDENTEE
				FK1_ORIGEM := If(Empty(FK1->FK1_ORIGEM),"CRIAFK",FK1->FK1_ORIGEM)

				cTabOri    := "FK1"

				//Gravação dos campos FK1_DTDISP e FK1_DTDIGI
				If lCmpFK1
					FK1->FK1_DTDISP := SE5->E5_DTDISPO
					FK1->FK1_DTDIGI := SE5->E5_DTDIGIT
				Endif
				FK1->(MsUnlock())

			ElseIf Alltrim(SE5->E5_TIPODOC) == "CH"
				U_XXFnBuscaEF( (cAliasSE1)->RECNO )
				(cAliasSE1)->(dbSkip())
				Loop

			EndIf


			//------------------------------------------------------
			Do Case

				//Grava FK6 - Valores acessórios.
			Case SE5->E5_TIPODOC $ cGeraFK6
				cIdFk6 := U_XFINFKSID('FK6', 'FK6_IDFK6')

				If lSE5GRVFK
					aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK6", aCamposFK6})
					If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
						aCamposFK6 := Aclone(aSE5GRVFK)
					EndIf
					Asize(aSE5GRVFK, 0)
					aSE5GRVFK := Nil
				EndIf

				RecLock("FK6", .T.)
				For nX := 1 To Len(aCamposFK6)

					nPos := SE5->(FieldPos(aCamposFK6[nX][2]) )
					If nPos > 0
						FieldPut(FK6->(FieldPos(aCamposFK6[nX][1])),SE5->(FieldGet(nPos)))
					EndIf

				Next nX

				cTpDesc := IIF(FK6->FK6_TPDESC == "C","1","2")

				FK6->FK6_FILIAL := SE5->E5_FILIAL
				FK6->FK6_IDFK6	:= cIdFk6
				FK6->FK6_IDORIG := cIdOrig
				FK6->FK6_TABORI := 'FK1'
				FK6->FK6_TPDESC := cTpDesc
				FK6->(MsUnlock())
				cTabOri := "FK1"
				cIdFk6 := "" //Limpa o ID gerado

				// FK5 - Grava valores na tabela de movimentação bancaria.
			Case U_XFINVerMov(SE5->E5_TIPODOC) .AND. (MovBcobx(SE5->E5_MOTBX , .F.) .OR. lFina087)//Só gera FK5 se o motivo de baixa atualiza banco

				cIdOrigFK5 := FWUUIDV4()
				If Empty(cProc)
					If Empty(cProc := U_XFINProcFKs(SE5->E5_IDORIG, "FK1" ))
						cProc := U_XFINFKSID('FKA','FKA_IDPROC')
					EndIf
				EndIf

				cBanco		:= SE5->E5_BANCO
				cAgencia 	:= SE5->E5_AGENCIA
				cConta 	    := SE5->E5_CONTA


				RecLock("FKA", .T.)
				FKA_FILIAL 	    := SE5->E5_FILIAL
				FKA_IDFKA		:= FWUUIDV4()
				FKA_IDPROC		:= cProc
				FKA_IDORIG		:= cIdOrigFK5
				FKA_TABORI		:= "FK5"
				FKA->(MsUnlock())

				If lSE5GRVFK
					aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK5", aCamposFK5})
					If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
						aCamposFK5 := Aclone(aSE5GRVFK)
					EndIf
					Asize(aSE5GRVFK, 0)
					aSE5GRVFK := Nil
				EndIf

				RecLock("FK5", .T.)

				For nX := 1 To Len(aCamposFK5)

					nPos := SE5->(FieldPos(aCamposFK5[nX][2]) )
					If nPos > 0
						FieldPut(FK5->(FieldPos(aCamposFK5[nX][1])), SE5->(FieldGet(nPos) ) )

						If aCamposFK5[nX][2] == "E5_MOEDA" .AND. Empty(SE5->(FieldGet(nPos)))
							If SA6->(dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
								FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), StrZero(SA6->A6_MOEDA,2) )
							Else
								FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), "01" )
							EndIf
						EndIf
						If aCamposFK5[nX][2] == "E5_NATUREZ" .AND. Empty(SE5->(FieldGet(nPos)))
							cNatureza := U_XFINNATMOV("R")
							FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), cNatureza )
						EndIf
					EndIf

				Next nX

				FK5->FK5_FILIAL	:= SE5->E5_FILIAL
				FK5->FK5_IDMOV 	:= cIdOrigFK5
				FK5->FK5_ORIGEM	:= If(Empty(FK5->FK5_ORIGEM),"CRIAFK",FK5->FK5_ORIGEM)

				If FK5->FK5_TPDOC == 'RA' .And. !Empty(SE5->E5_NUMERO)
					cChave := xFilial("SE1", SE5->E5_FILORIG) + "|" +  SE5->E5_PREFIXO + "|" + SE5->E5_NUMERO + "|" + SE5->E5_PARCELA + "|" + SE5->E5_TIPO + "|" +;
					SE5->E5_CLIFOR + "|" + SE5->E5_LOJA

					FK5->FK5_IDDOC := U_XXXFINGRVFK7('SE1', cChave)
				EndIf

				FK5->(MsUnlock())
				cTabOri := If(cTabOri == "FK1", cTabOri, "FK5")
				cIdOrig := If(cTabOri == "FK1",cIdOrig, cIdOrigFK5)
			EndCase

			//Atualiza o campo E5_MOVFKS = 'S' -> Campo de controle do migrador.
			Reclock("SE5", .F.)
			E5_MOVFKS := "S"
			E5_IDORIG := cIdOrig
			E5_TABORI := cTabOri
			SE5->(MsUnlock())
		Next
		//-------------------------------------------------------------
		(cAliasSE1)->(dbSkip())
	Enddo
	(cAliasSE1)->(DBCloseArea())
	FErase(cAliasSE1 + GetDBExtension())

	//Reposiciona na SE5
	If nPosSE5 > 0
		SE5->(dbGoTo(nPosSE5))
	EndIf
	cFilAnt := cFilBkp
Return

/*/{Protheus.doc} FnBuscaEF
Filtra os dados baixados da SEF - cheques.
@author William Matos Gundim Junior
@since 10/04/2014
@version P12
/*/
User Function XXFnBuscaEF(nPosSE5)
	Local nX 			:= 0
	Local cQuery 		:= ''
	Local cIdOrig 	    := ''
	Local cAliasSEF 	:= GetNextAlias()
	Local cProc		    := ''
	Local cFilBkp 	    := cFilAnt
	Local cBanco 		:= ""
	Local cAgencia	    := ""
	Local cConta 		:= ""
	Local cNatureza	    := ""
	Local cCart		    := ""

	Default nPosSE5 := 0 // Variavel com posição da SE5 que deve ser atualizado.

	//Cheque.
	cQuery := "SELECT SE5.R_E_C_N_O_ RECNO, SEF.R_E_C_N_O_ RECSEF "	+	CRLF
	cQuery += " FROM " +	RetSQLTab('SE5')			+	CRLF
	cQuery += "	JOIN " + RetSQLTab('SEF')			+	CRLF
	cQuery += " ON   SE5.E5_FILIAL  	= SEF.EF_FILIAL		AND " + CRLF
	cQuery += "      SE5.E5_PREFIXO  = SEF.EF_PREFIXO		AND " + CRLF
	cQuery += "      SE5.E5_NUMERO 		= SEF.EF_TITULO 		AND " + CRLF
	cQuery += "      SE5.E5_PARCELA  = SEF.EF_PARCELA  AND "		+ CRLF
	cQuery += "      SE5.E5_NUMCHEQ		= SEF.EF_NUM	AND	"			+ CRLF
	cQuery += " 	   SE5.E5_DATA   >= SEF.EF_DATA 		 " + CRLF

	cQuery += " WHERE " 				 			 					+ CRLF

	If nPosSE5 > 0
		cQuery += "      SE5.E5_PREFIXO  = '" + SE5->E5_PREFIXO + "' AND " + CRLF
		cQuery += "      SE5.E5_NUMERO 		= '" + SE5->E5_NUMERO  + "' AND " + CRLF
		cQuery += "      SE5.E5_PARCELA  = '" + SE5->E5_PARCELA + "' AND " + CRLF
		cQuery += "      SE5.E5_NUMCHEQ		= '" + SE5->E5_NUMCHEQ + "' AND " + CRLF
		cQuery += "      SE5.E5_BANCO		= '" + SE5->E5_BANCO + "' AND " + CRLF
		cQuery += "      SE5.E5_AGENCIA		= '" + SE5->E5_AGENCIA + "' AND " + CRLF
		cQuery += "      SE5.E5_CONTA		= '" + SE5->E5_CONTA + "' AND " + CRLF
		cQuery += " SE5.E5_TIPODOC = 'CH' AND "
	Else
		cQuery += " E5_DATA >= '" + DTOS(MV_PAR01) + "' AND " 		+ CRLF
		cQuery += " E5_DATA <= '" + DTOS(MV_PAR02) + "' AND " 		+ CRLF
		cQuery += "	E5_SITUACA NOT IN ('C','E','X') 			AND "	  	+ CRLF
		cQuery += " E5_MOVFKS  <> 'S' AND " + CRLF
		cQuery += " E5_TIPODOC = 'CH' AND " + CRLF
		cQuery += " E5_NUMCHEQ <> ''  AND " + CRLF
		cQuery += " SE5.E5_SEQ	  = SEF.EF_SEQUENC AND " + CRLF
	EndIf
	cQuery += " SEF.D_E_L_E_T_ = ' ' AND " 	+ CRLF
	cQuery += " SE5.D_E_L_E_T_ = ' ' " 	+ CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSEF,.T.,.T.)
	dbSelectArea(cAliasSEF)

	DbGotop()
	dbSelectArea('SEF')
	dbSelectArea('SE5')
	dbSelectArea('SA6')
	dbSelectArea('FKA')
	SA6-> (DbSetOrder(1))
	FKA-> (DbSetOrder(3))//FKA_FILIAL+FKA_TABORI+FKA_IDORIG
	While !(cAliasSEF)->(Eof())

		SE5->(dbGoTo(	(cAliasSEF)->RECNO))

		If lFilExclus
			cFilAnt := SE5->E5_FILIAL
		EndIf
		//tratamento para casos que houve a geracao e cancelamento do cheque e regerou novamente o mesmo numero
		If !Empty(SE5->E5_IDORIG)
			(cAliasSEF)->(DBSkip())
			Loop
		EndIf

		SEF->(dbGoTo(	(cAliasSEF)->RECSEF))
		If (FKA->(dbSeek(xFilial("FKA")+SEF->EF_IDSEF+"SEF")))
			(cAliasSEF)->(DBSkip())
			Loop
		EndIf

		If XTemEstChq( (cAliasSEF)->RECNO  )
			(cAliasSEF)->(dbSkip())
			Loop
		EndIf
		cCart		:= SE5->E5_RECPAG
		cBanco		:= SE5->E5_BANCO
		cAgencia 	:= SE5->E5_AGENCIA
		cConta 	    := SE5->E5_CONTA
		//
		cIdOrig     := FWUUIDV4()
		cProc	    := U_XFINFKSID('FKA','FKA_IDPROC')
		//
		RecLock("FKA", .T.)
		FKA_FILIAL  := SE5->E5_FILIAL
		FKA_IDFKA	:= FWUUIDV4()
		FKA_IDPROC	:= cProc
		FKA_IDORIG	:= cIdOrig
		FKA_TABORI	:= "FK5"
		FKA->(MsUnlock())

		If lSE5GRVFK
			aSE5GRVFK := ExecBlock("SE5GRVFK",.F.,.F.,{"FK5", aCamposFK5})
			If ValType(aSE5GRVFK) == "A" .and. !Empty(aSE5GRVFK)
				aCamposFK5 := Aclone(aSE5GRVFK)
			EndIf
			Asize(aSE5GRVFK, 0)
			aSE5GRVFK := Nil
		EndIf

		RecLock("FK5", .T.)

		For nX := 1 To Len(aCamposFK5)

			nPos := SE5->(FieldPos(aCamposFK5[nX][2]) )
			If nPos > 0

				FieldPut(FK5->(FieldPos(aCamposFK5[nX][1])), SE5->(FieldGet(nPos) ) )
				If aCamposFK5[nX][2] == "E5_MOEDA" .AND. Empty(SE5->(FieldGet(nPos)))
					If SA6->(dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta))
						FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), StrZero(SA6->A6_MOEDA,2) )
					Else
						FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), "01" )
					EndIf
				Endif
				If aCamposFK5[nX][2] == "E5_NATUREZ" .AND. Empty(SE5->(FieldGet(nPos)))
					cNatureza := FINNATMOV(cCart)
					FieldPut( FK5->(FieldPos(aCamposFK5[nX][1])), cNatureza )
				EndIf

			EndIf

		Next nX

		FK5->FK5_FILIAL := SE5->E5_FILIAL
		FK5->FK5_IDMOV 	:= cIdOrig
		FK5->FK5_ORIGEM := "CRIAFK"

		FK5->(MsUnlock())

		//Atualiza o campo E5_MOVFKS = 'S' -> Campo de controle do migrador.
		Reclock("SE5", .F.)
		E5_MOVFKS := "S"
		E5_IDORIG := cIdOrig
		E5_TABORI := "FK5"
		SE5->(MsUnlock())

		cIdOrig := FWUUIDV4()

		RecLock("FKA", .T.)
		FKA_FILIAL := SE5->E5_FILIAL
		FKA_IDFKA  := FWUUIDV4()
		FKA_IDPROC := cProc
		FKA_IDORIG := cIdOrig
		FKA_TABORI := "SEF"
		FKA->(MsUnlock())
		//Atualiza SEF.
		RecLock("SEF", .F.)
		EF_IDSEF   := cIdOrig
		SEF->(MsUnlock())

		(cAliasSEF)->(dbSkip())
	End//Do
	(cAliasSEF)->(DBCloseArea())
	FErase(cAliasSEF + GetDBExtension())
	cFilAnt := cFilBkp
Return

/*/{Protheus.doc} FINFKSID
Função para definir o ID usando GETSX8NUM
@author TOTVS
@since  09/02/2015
@version P12
/*/
User Function XFINFKSID(cAliasFks, cCampoFks, nIndex)
	Local cIdFks	:= ""
	Local aArea	:= GetArea()

	Default nIndex := 1 // Indice de ordenacao do cCampoFks

	DbSelectArea(cAliasFks)
	If cAliasFks == "FKA"
		nIndex := 2
		DbSetOrder(nIndex)//FKA_FILIAL+FKA_IDPROC+FKA_IDORIG+FKA_TABORI
	Else
		DbSetOrder(nIndex)
	EndIf

	While .T.
		cIdFks := GetSXENum(cAliasFks, cCampoFks,,nIndex)
		If !(DbSeek(xFilial(cAliasFks)+cIdFks))
			ConfirmSx8()
			Exit
		EndIf
	EndDo

	RestArea(aArea)

Return cIdFks

//Função que verifica se houve estorno do cheque,
//pois quando cancela o cheque e gera novamente N vezes, fica com a mesma chave
//não possibilitando a busca de qual foi a ultima geração ou estorno
Static Function XTemEstChq(nRecnoSE5)
	Local cQuery
	Local lEstorno := .F.
	Local cAliasSE5 := GetNextAlias()

	Default nRecnoSE5 := 0

	DbSelectArea("SE5")
	SE5->(DBGoto(nREcnoSE5))

	cQuery := "SELECT SE5.R_E_C_N_O_  FROM " + RetSqlName("SE5") + " SE5"
	cQuery += " WHERE SE5.E5_FILIAL = '" + SE5->E5_FILIAL  + "' "
	cQuery += " AND SE5.E5_BANCO = '"    + SE5->E5_BANCO   + "' "
	cQuery += " AND SE5.E5_AGENCIA = '"  + SE5->E5_AGENCIA + "' "
	cQuery += " AND SE5.E5_CONTA = '"    + SE5->E5_CONTA   + "' "
	cQuery += " AND SE5.E5_NUMCHEQ = '"  + SE5->E5_NUMCHEQ + "' "
	cQuery += " AND SE5.E5_PREFIXO = '"  + SE5->E5_PREFIXO + "' "
	cQuery += " AND SE5.E5_NUMERO = '"   + SE5->E5_NUMERO  + "' "
	cQuery += " AND SE5.E5_PARCELA = '"  + SE5->E5_PARCELA + "' "
	cQuery += " AND SE5.E5_SEQ = '"      + SE5->E5_SEQ     + "' "
	cQuery += " AND SE5.R_E_C_N_O_ > "   + str(nREcnoSE5)
	cQuery += " AND SE5.E5_TIPODOC = 'ES' "
	cQuery += " AND SE5.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE5,.T.,.T.)

	If (cAliasSE5)->(!Eof())
		//se encontrou TIPODOC = ES é porque houve estorno de cheque
		lEstorno := .T.
	EndIF
	(cAliasSE5)->(DBCloseArea())

	FErase(cAliasSE5 + GetDBExtension())
Return lEstorno

//Função que realiza o estorno de registro da SE5 de estorno
//que ainda não houve migração
Static Function XGeraEstFK5(cTipo)
	Local aAreaSE5 := GetArea()
	Local cQuery := ""
	Local cAliasTrb := GetNextAlias()
	Local cIdOrigBx := ""

	cQuery := "SELECT E5_IDORIG FROM " + RetSqlName("SE5")
	cQuery += " WHERE E5_FILIAL = '" + SE5->E5_FILIAL + "' AND "
	cQuery += "E5_PREFIXO='"+SE5->E5_PREFIXO+"' AND "
	cQuery += "E5_NUMERO='"+SE5->E5_NUMERO+"' AND "
	cQuery += "E5_PARCELA='"+SE5->E5_PARCELA+"' AND "
	cQuery += "E5_TIPO='"+SE5->E5_TIPO+"' AND "
	cQuery += "E5_CLIFOR='"+SE5->E5_CLIFOR+"' AND "
	cQuery += "E5_LOJA='"+SE5->E5_LOJA+"' AND "
	cQuery += "E5_SEQ='"+SE5->E5_SEQ+"' AND "
	cQuery += "E5_TIPODOC IN ('BA','VL', 'CP') AND "
	If cTipo == "R"
		cQuery += "E5_RECPAG = 'R' AND "
	Else
		cQuery += "E5_RECPAG = 'P' AND "
	EndIf
	cQuery += "D_E_L_E_T_ = ' '"

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
	If (cAliasTrb)->(!Eof())
		cIdOrigBx := (cAliasTrb)->E5_IDORIG
	EndIf

	(cAliasTrb)->(DbCloseArea())

	RestArea(aAreaSE5)

Return cIdOrigBx


/*/{Protheus.doc} FINNATMOV
Função gravar a natureza de movimento bancário, pagar ou receber
@author Pâmela Bernardo
@since  19/11/2015
@version P12
/*/
User Function XFINNATMOV(cCart)

	Local cNatureza := ""
	Local aArea		:= GetArea()
	Local nTamNat	:= TamSx3("E1_NATUREZ")[1]

	Default cCart 	:= "P"

	DbSelectArea("SED")
	DbSetOrder(1)

	If cCart == "P"
		cNatureza := Pad(SuperGetMV("MV_NATMOVP",,"NATMOVP"),nTamNat)
	Else
		cNatureza := Pad(SuperGetMV("MV_NATMOVR",,"NATMOVR"),nTamNat)
	Endif
	If ( ! DbSeek( xFilial("SED") + cNatureza ) )
		RecLock("SED",.T.)
		SED->ED_FILIAL  	:= xFilial("SED")
		SED->ED_CODIGO  	:= cNatureza
		SED->ED_CALCIRF 	:= "N"
		SED->ED_CALCISS 	:= "N"
		SED->ED_CALCINS 	:= "N"
		SED->ED_CALCCSL 	:= "N"
		SED->ED_CALCCOF 	:= "N"
		SED->ED_CALCPIS 	:= "N"
		SED->ED_DESCRIC 	:= If (cCart == "P", "PAGAR", "RECEBER")
		SED->ED_TIPO		:= "2"
		SED->ED_MOVBCO	:= "1"
		SED->ED_COND 		:= If (cCart == "P", "D","R" )
		MsUnlock()
	EndIf

	RestArea(aArea)

Return cNatureza

/*/{Protheus.doc} FINNATFKS
Função gravar a natureza no contas a receber
@author Simone Kakinoana
@since  09/02/2018
@version P12
/*/
User Function XFINNATFKS()

	Local cNatureza 	:= ""
	Local aArea		:=GetArea()
	Local nTamNat	:= TamSx3("E1_NATUREZ")[1]

	DbSelectArea("SED")
	DbSetOrder(1)

	cNatureza := Pad(SuperGetMV("MV_NATFKS",,"NAT_FK"),nTamNat)

	If ( ! DbSeek( xFilial("SED") + cNatureza ) )
		RecLock("SED",.T.)
		SED->ED_FILIAL  	:= xFilial("SED")
		SED->ED_CODIGO  	:= cNatureza
		SED->ED_CALCIRF 	:= "N"
		SED->ED_CALCISS 	:= "N"
		SED->ED_CALCINS 	:= "N"
		SED->ED_CALCCSL 	:= "N"
		SED->ED_CALCCOF 	:= "N"
		SED->ED_CALCPIS 	:= "N"
		SED->ED_DESCRIC 	:= "Natureza FKS"
		SED->ED_TIPO		:= "2"
		SED->ED_MOVBCO		:= "1"
		SED->ED_COND 		:= "R"
		MsUnlock()
	EndIf

	RestArea(aArea)

Return cNatureza

//------------------------------------------------------------------------------
/*/{Protheus.doc} FSetVA2CTB
Função para carregar os valores acessórios nas variáveis de contabilização
relacionadas

@author Pequim
@since  04/09/2015
@version P12
/*/
//------------------------------------------------------------------------------
User Function XFSetVA2CTB(cCodVA AS Character,nValVA AS Numeric)
	Local nPos AS Numeric
	DEFAULT cCodVA := ""
	DEFAULT nValVa := 0

	nPos := 0

	If U_XFInDicTVA()

		If !Empty(cCodVA)
			FKC->(dbSetOrder(1))
			If FKC->(dbSeek(xFilial("FKC")+cCodVA))

				// Valores Acessorios - Guarda as PRIVATEs criadas para zerar
				// toda vez que a FINCARVAR() for chamada.
				If (nPos := ASCAN(__aVaToCTB,{|e| e[1]==FKC->FKC_VARCTB})) == 0
					AADD(__aVaToCTB,{FKC->FKC_VARCTB,nValVa})
				Else
					__aVaToCTB[nPos][2] := nValVa
				EndIF

				&(Alltrim(FKC->FKC_VARCTB)) := ABS(nValVa)
			Endif
		Endif

	Endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} FSetMt2CTB
Função para carregar os valores de impostos retidos nas variáveis de
contabilização

@param cCodRet, Código do tipo de retenção cadastrado no FKM
@param nValRet, Valor de retenção

@author Pedro Alencar
@since 15/03/2018
@version P12
/*/
//-------------------------------------------------------------------
User Function XFSetMt2CTB( cCodRet As Char, nValRet As Numeric )
	Local cVarCtb As Char

	Default cCodRet := ""
	Default nValRet := 0

	//inicilaiza variáveis.
	cVarCtb := ""

	If !Empty( cCodRet )
		nRecFKK := FinFKKVig(cCodRet, dDataBase)
		FKK->(dbGoTo(nRecFKK))

		If !Empty(FKK->FKK_VARCTB)
			cVarCtb := Alltrim(FKK->FKK_VARCTB)

			If FKK->FKK_FATGER == "2" .And. Type(cVarCtb) == "N"
				&( cVarCtb ) := nValRet
			EndIf
		EndIf
	EndIf

Return Nil

/*/{Protheus.doc} BxReciboE1
	Busca todos movimentos do mesmo recibo
	@type  Function
	@author renato.ito
	@since 19/11/2019
	@version 12
	@param nRecSe5, Numeric, Recno da SE5 de partida para a busca
	@return aRet, Array, Retorna todos os recnos do mesmo recibo
/*/
User Function XBxReciboE1(nRecSe5 As Numeric) As Array

	Local aRet			As Array
	Local oTmpRecib 	As Object
	Local cQuery		As Character
	Local cTblRecib		As Character

	aRet		:= {}
	oTmpRecib	:= NIL
	cQuery		:= ""
	cTblRecib	:= ""

	DbSelectArea("SE5")
	SE5->(DbGoTo(nRecSe5))

	cQuery := "SELECT R_E_C_N_O_ RECNO FROM " + RetSqlName("SE5") + " SE5 WHERE "
	cQuery += " SE5.E5_FILIAL = ? "
	cQuery += " AND SE5.E5_ORDREC = ? "
	cQuery += " AND SE5.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	oTmpRecib:=FWPreparedStatement():New( cQuery )
	oTmpRecib:SetString( 1, SE5->E5_FILIAL )
	oTmpRecib:SetString( 2, SE5->E5_ORDREC )

	cQuery		:= oTmpRecib:GetFixQuery()
	cTblRecib	:= MpSysOpenQuery(cQuery)

	While (cTblRecib)->(!Eof())
		AAdd(aRet,(cTblRecib)->RECNO)
		(cTblRecib)->(DbSkip())
	EndDo
	(cTblRecib)->(DbCloseArea())

Return aRet


//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}FinFK7Cpos
Processa e retorna a chave do título gravada na tabela FK7 para a gravção dos campos referentes aos dados dos
títulos

@param cKeyOrig, Chave original gravada na tabela FK7 para processamento
@param cIdDoc, IdDoc da tabela FK7. Caso seja passado posicionará a tabela FK7 para obter a chave (FK7_CHAVE)

@author Mauricio Pequim Jr
@since  10/09/2020
@version 12.1.27
/*/
//-------------------------------------------------------------------------------------------------------------
User Function XFinFK7Cpos(cKeyOrig As Character, cIdDoc As Character)
	Local cChave	AS Character
	Local aQuebra	As Array

	Default cKeyOrig	:= ''
	Default cIdDoc		:= ''

	cChave	:= ""
	aQuebra := {}

	If Empty(__aTamCpos)
		aAdd(__aTamCpos,TamSXG('033')[1])
		aAdd(__aTamCpos,               3)
		aAdd(__aTamCpos,TamSXG('018')[1])
		aAdd(__aTamCpos,TamSXG('011')[1])
		aAdd(__aTamCpos,               3)
		aAdd(__aTamCpos,TamSXG('001')[1])
		aAdd(__aTamCpos,TamSXG('002')[1])
	Endif

	If !Empty(cIdDoc)
		FK7->(DbSetOrder(1)) // Filial + IdDoc
		FK7->(DbSeek(xFilial('FK7')+cIdDoc))
		cKeyOrig := FK7->FK7_CHAVE
	EndIf

	//Transforma a linha em um array com todos os registros
	aQuebra := StrToKarr(cKeyOrig,'|')

	If Len(aQuebra) == 7
		RecLock("FK7")
			FK7->FK7_FILTIT := PadR(aQuebra[1],__aTamCpos[1]) // Filial
			FK7->FK7_PREFIX := PadR(aQuebra[2],__aTamCpos[2]) // Prefixo
			FK7->FK7_NUM	:= PadR(aQuebra[3],__aTamCpos[3]) // Numero
			FK7->FK7_PARCEL	:= PadR(aQuebra[4],__aTamCpos[4]) // Parcela
			FK7->FK7_TIPO	:= PadR(aQuebra[5],__aTamCpos[5]) // Tipo
			FK7->FK7_CLIFOR	:= PadR(aQuebra[6],__aTamCpos[6]) // Cliente
			FK7->FK7_LOJA	:= PadR(aQuebra[7],__aTamCpos[7]) // Loja
		MsUnlock()
	Endif

	FwFreeArray(aQuebra)

Return

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc}FInDicTVA
Verifica se as tabelas referentes a VA (valores acessórios) estão no dicionário

@author Mauricio Pequim Jr
@since  04/04/2022
@version 12.1.33
/*/
//-------------------------------------------------------------------------------------------------------------
User Function XFInDicTVA()

	Local lRet AS Logical

	lRet := .F.

	If _lInDicFKC == nil
		_lInDicFKC := TableInDic("FKC")
	EndIF

	If _lInDicFKD == nil
		_lInDicFKD := TableInDic("FKD")
	EndIF

	If _lInDicFKC .and. _lInDicFKD
		lRet := .T.
	Endif

Return lRet


/*/{Protheus.doc} U_ViagemRD0
	Transfere participantes de uma filial para outra na RD0
   @type  User Function
   @author Julio Saraiva
   @since 25/10/2024
   @version version
   @param 
   @return 
   @example
   (examples)
/*/

User Function ViagemRD0()
	Local aArea 	:= GetArea()
	Local aParamBox := {}
	Local aRetPar   := {}
	Local cM0FilOri := cFilAnt
	Local cM0FilDes := cFilDest
	Local cGrupEmp  := cEmpAnt
	Local cQuery
	Local nError	:= 0
	Local cCliDe    := Space(6)
	Local cCliAte   := "ZZZZZZ"
	Local dDataDesl := dDataBase
	Local aRet		:= {}

	aAdd(aParamBox,{2, "Processo: " ,      "D", {"D=Desligamento de Participantes", "A=Ativação em nova filial"}, 110 , ".T.", .T.}) 
		
	If ! ParamBox(aParamBox, "Qual processo deseja fazer", @aRet)
		RestArea(aArea)
		Return  
	EndIf 
	aParamBox := {}
	If aRet[1]=="D"
		aAdd(aParamBox,{1 ,"Grupo Emp"     , cGrupEmp  , "@!", ".T." ,       , ,  50 , .T.})  
		aAdd(aParamBox,{1 ,"Filial de Desligamento (Origem)" , cM0FilOri , "@!", ".T." , "SM0" , ,  50 , .T.})
		aAdd(aParamBox,{1 ,"Filial Destino", cM0FilDes , "@!", ".T." , "SM0" , ,  50 , .T.})  
		aAdd(aParamBox,{1 ,"Participante de  (RD0_CODIGO)"   , cCliDe    , "@!", ".T." , "RD0" , ,  50 , .F.})  
		aAdd(aParamBox,{1 ,"Participante ate (RD0_CODIGO)"   , cCliAte   , "@!", ".T." , "RD0" , ,  50 , .T.})  
		aAdd(aParamBox,{1 ,"Data de Desligamento"      , dDataDesl    , "@D", ".T." , , ,  50 , .T.})  

		If ! ParamBox(aParamBox, "Desativação de Participantes " + cNomeFil, aRetPar) 
			RestArea(aArea)
			Return .F.
		EndIf

		cGrupEmp  := aRetPar[1]
		cM0FilOri := aRetPar[2]
		cM0FilDes := aRetPar[3]
		cCliDe    := aRetPar[4]
		cCliAte   := aRetPar[5]
		dDataDesl := aRetPar[6]

	ElseIf aRet[1]=="A"
		aAdd(aParamBox,{1 ,"Grupo Emp"     , cGrupEmp  , "@!", ".T." ,       , ,  50 , .T.})  
		aAdd(aParamBox,{1 ,"Filial Anterior (Origem)" , cM0FilOri , "@!", ".T." , "SM0" , ,  50 , .T.})
		aAdd(aParamBox,{1 ,"Nova Filial (Destino)", cM0FilDes , "@!", ".T." , "SM0" , ,  50 , .T.})  
		aAdd(aParamBox,{1 ,"Participante de  (RD0_CODIGO)"    , cCliDe    , "@!", ".T." , "RD0" , ,  50 , .F.})  
		aAdd(aParamBox,{1 ,"Participante ate (RD0_CODIGO)"   , cCliAte   , "@!", ".T." , "RD0" , ,  50 , .T.})  
		aAdd(aParamBox,{1 ,"Data da Ativação (demissão fil. anterior)"      , dDataDesl    , "@D", ".T." , , ,  50 , .T.})  

		If ! ParamBox(aParamBox, "Ativação de Participantes " + cNomeFil, aRetPar) 
			RestArea(aArea)
			Return .F.
		EndIf

		cGrupEmp  := aRetPar[1]
		cM0FilOri := aRetPar[2]
		cM0FilDes := aRetPar[3]
		cCliDe    := aRetPar[4]
		cCliAte   := aRetPar[5]
		dDataDesl := aRetPar[6]

	Endif

	If aRet[1]=="D"
		IF FWAlertYesNo("Confirma a desativação dos participantes da Filial anterior " + cM0FilOri + " - Data: " + dtoc(dDataDesl))
			// Processamento
			Begin Transaction 
			cQuery := " "
			cQuery += " UPDATE " + RetSQLName("RD0") + "   " 
			cQuery += " SET RD0_DTADEM = '"+DTOS(dDataDesl)+"', "
			cQuery += " RD0_RESERV = ' ', "
			cQuery += " RD0_MSBLQL = '1', "
			cQuery += " RD0_DVIAGE = '1', "
			cQuery += " RD0_EMAIL = UPPER(RD0_EMAIL)  " 
			cQuery += " WHERE RD0_FILATU = '" + AllTrim(cM0FilOri) + "'  " 
			cQuery += " AND RD0_CODIGO BETWEEN '" + cCliDe + "' AND '" + cCliAte + "' "
			cQuery += " AND RD0_MSBLQL <> '1' AND D_E_L_E_T_ = ' '  " 
			If (nError := TCSQLExec(cQuery)) <> 0
				Help(,, "Erro ao atualizar Participantes",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
				DisarmTransaction()
			Else
				FWAlertSuccess("Registros atualizados com sucesso!!!")
			EndIf
			End Transaction
		Endif
	ElseIf aRet[1]=="A"
		IF FWAlertYesNo("Confirma a Ativação dos participantes da Filial (Destino) " + cM0FilDes + " - Data: " + dtoc(dDataDesl))
			// Processamento
			Begin Transaction 
			cQuery := " "
			cQuery += " UPDATE " + RetSQLName("RD0") + "   " 
			cQuery += " SET RD0_DTADEM = ' ', "
			cQuery += " RD0_RESERV = ' ', "
			cQuery += " RD0_MSBLQL = '2', "
			cQuery += " RD0_DVIAGE = '2', "
			cQuery += " RD0_FILATU = '" + AllTrim(cM0FilDes) + "'  " 
			cQuery += " WHERE RD0_FILATU = '" + AllTrim(cM0FilOri) + "' "
			cQuery += " AND D_E_L_E_T_ = ' ' "
			cQuery += " AND RD0_DTADEM = '" + DTOS(dDataDesl) + "'  " 
			cQuery += " AND RD0_CIC <> ' ' "			
			If (nError := TCSQLExec(cQuery)) <> 0
				Help(,, "Erro ao atualizar Participantes",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
				DisarmTransaction()
			Else
				FWAlertSuccess("Registros atualizados com sucesso!!!")
			EndIf
			End Transaction		
		Endif
	Endif

	RestArea(aArea)
Return


/*/{Protheus.doc} CriarDTC
   @type  User Function
   @author Julio Saraiva
   @since 30/10/2024
   @version version
   @param cTabela
   @return 
   @example
   (examples)
/*/

User Function CriarDTC(cTabela) 
	Local aCampos	:= {}   //defino a variavel do tipo array para criar os campos  
	Local cArquivo	:= "system\" + cDir + "\" + cTabela + "_" + STRTRAN(TIME(),":")  // \SYSTEM\INTEGRADOR\CE1.DTC  	
	Local aDir		:= {}
	Local nI        := 0
	Local cArq      := ""
	Local cAliasBD	:= "" 
	Local cQuery    := ""
	Local cFile     := ""
	Local aArea     := GetArea()
	Local cTipoDB   := "CTR" + "EEC" + "DX"

	If !ExistDir(cDir)
		MakeDir(cDir)
	Endif
	aDir := Directory("system\" + cDir + "\*.*")
	
	For nI := 1 to len(aDir)
		cArq := Alltrim(aDir[nI, 1])
		FErase("system\" + cDir + "\" + Lower(cArq))
	Next

	cQuery += " SELECT * FROM "  

	Do Case
		Case cTabela == "CE1"
			cQuery += RetSQLName("CE1") + " WHERE CE1_FILIAL='"+cFilDest+"' "
	EndCase

	cQuery += " AND D_E_L_E_T_=' '   "

	cAliasBD := CriaTrab(Nil,.F.)

	If Select(cAliasBD) > 0
		(cAliasBD)->(dbCloseArea())
	Endif 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)

	If !(cAliasBD)->(Eof())
		FWMonitorMsg("Criando tabela "+cTabela+"..." )
		aCampos := (cAliasBD)->(dbStruct())

		If SELECT(cTabela) > 0
			(cTabela)->(dbCloseArea())
		Endif

		TCLink()

		&(cFCria)(cArquivo, aCampos, cTipoDB)
		dbUseArea(.T.,cTipoDB,cArquivo,cTabela,.F.,.F.)
		FWMonitorMsg("Appendando dados na tabela "+cTabela+"..." )	
		DbSelectArea(cTabela)

		APPEND FROM &cAliasBD VIA "TOPCONN"
		
		(cAliasBD)->(dbCloseArea())	

		TCUnlink()

		cFile := TFileDialog("Arquivos (*.dtc) |*.dtc|","Onde deseja salvar o arquivo",  , "C:\", .F., GETF_LOCALHARD + GETF_LOCALFLOPPY)

		If Empty(cFile)
			RestArea(aArea)
			Return .F.
		Endif
		
		If ! Lower(Right(cFile, 4)) == ".dtc"
			cFile += ".dtc"
		EndIf
		
		If File(cFile)
			If ! FWAlertYesNo("Confirma a substituição do arquivo?")
				RestArea(aArea)
				Return .F.
			EndIf
			FErase(cFile)
		EndIF
		If CpyS2T(cArquivo+".dtc", SubStr(cFile,1,RAT("\",cFile)))
			FWAlertSuccess("Arquivos copiados com sucesso ! - " + cFile)
		ELSE
			FWAlertError("Não foi possível a cópia dos arquivos !")
		ENDIF
	Endif


	RestArea(aArea)
Return


/*
Static Function MyGetFile(cMascara, cTitulo, nMascpadrao, cDirinicial, lSalvar, nOpcoes, lArvore, lKeepCase)
    Local cRet := ""
    Local cGF  := "cGetFile"

    cRet := &(cGF)(cMascara, cTitulo, nMascpadrao, cDirinicial, lSalvar, nOpcoes, lArvore, lKeepCase)

Return cRet
*/

/*/{Protheus.doc} fExecRep(aRep,cTabela,RecnoP98)
    (long_description)
    @type  User Function
    @author Geanlucas Sousa
    @since 05/11/2024
    @version version
    @param aRep[NOME_CAMPO,CONTEUDO]

/*/
User Function fExecRep(aRep,cTabela,nRecnoP98)

	Local aArea     := FWGetArea()
	Local cCodCli	:= ''
	Local cContrato	:= ''
	Local nK		:= 0
	Local nRecnoDs	:= 0
	Local nPos		:= 0 
	Local lCli		:= .F.
	Local xConteudo

	If cTabela == 'SA1'
		nPos := aScan(aRep,{|x| Alltrim(x[1]) == 'A1_CGC'} )
		If nPos > 0
			cCodCli := Posicione('SA1',3,xFilial('SA1')+ aRep[nPos,2],'A1_COD')
			If !Empty(cCodCli)
				cContrato := Posicione('CN9',1,xFilial('CN9')+ 'CON'+cCodCli,'CN9_NUMERO')
				If !Empty(cContrato)
					If !FWAlertYesNo("Já existe contrato com esse cliente, deseja continuar o Reprocessamento do mesmo ?")
						lCli := .T.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If !lCli
		cQuery := " "
		cQuery += " SELECT DISTINCT PWU_RECNDS FROM " + RetSQLName("PWU") + "        " 
		cQuery += " WHERE PWU_FILIAL='" + FwxFilial("PWU") + "'      " 
		cQuery += " AND PWU_TABELA='"+cTabela+"' " 
		cQuery += " AND PWU_RECN98="+cvaltochar(nRecnoP98) 
		cQuery += " AND D_E_L_E_T_=' '      " 

		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf

		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

		DbSelectArea("TRB")

		nRecnoDs := TRB->PWU_RECNDS

		If nRecnoDs > 0

			DbSelectArea(cTabela)

			DbGoto(nRecnoDs)
			Reclock(cTabela,.F.)

			For nK := 1 To Len(aRep)-1
				xConteudo := ""

				If cTabela == 'SA1' .And. aRep[nK,1] == 'A1_COD'
					Loop
				Else
					If GetSX3Cache(aRep[nK,1], "X3_TIPO") == "C" .And. ValType(aRep[nK,2]) <> "C" 
						xConteudo := cValToChar(aRep[nK,2])
					ElseIf GetSX3Cache(aRep[nK,1], "X3_TIPO") == "N" .And. ValType(aRep[nK,2]) <> "N"
						xConteudo := Val(aRep[nK,2])
					ElseIf GetSX3Cache(aRep[nK,1], "X3_TIPO") == "D" .And. ValType(aRep[nK,2]) <> "D"
						xConteudo := CtoD(aRep[nK,2])
					Else 
						xConteudo := aRep[nK,2]
					EndIF 

					If !(&(cTabela+"->"+aRep[nK,1]) == xConteudo)
						If aRep[nK,1] == 'A1_CNAE'
							&(cTabela+"->"+aRep[nK,1]) := Transform( AllTrim(xConteudo), "@R 9999-9/99" )
						Else
							&(cTabela+"->"+aRep[nK,1]) := xConteudo
						EndIf
					EndIf 
				EndIf
			Next nK 
			
			&(cTabela)->(MsUnlock())

		EndIf 
	Else
		FWAlertError("Cliente com o CNPJ: "+aRep[nPos,2]+" não reprocessado por já existir o contrato "+cContrato+" para o mesmo!",'Atenção !!')
	EndIf

	FWRestArea(aArea)

Return


/*/{Protheus.doc} DTCProd 
   Cria tabelas relacionadas aos produtos e grupos
   SB1, SB5, SBM e ZQK
   @type  User Function
   @author Julio Saraiva
   @since 08/11/2024
   @version version
   @param cTabela
   @return 
   @example
   (examples)
/*/

User Function DTCProd(cTabela) 
	Local aCampos	:= {}   //defino a variavel do tipo array para criar os campos  
	Local cArqSB1	:= "system\" + cDir + "\" + "SB1_"+STRTRAN(TIME(),":")  // \SYSTEM\INTEGRADOR\SB1.DTC  	
	Local cArqSB5	:= "system\" + cDir + "\" + "SB5_"+STRTRAN(TIME(),":")  // \SYSTEM\INTEGRADOR\SB5.DTC
	Local cArqSBM	:= "system\" + cDir + "\" + "SBM_"+STRTRAN(TIME(),":")  // \SYSTEM\INTEGRADOR\SBM.DTC
	Local cArqZQK	:= "system\" + cDir + "\" + "ZQK_"+STRTRAN(TIME(),":")  // \SYSTEM\INTEGRADOR\ZQK.DTC
	Local aDir		:= {}
	Local nI        := 0
	Local cArq      := ""
	Local cAliasBD	:= "" 
	Local cQuery    := ""
	Local cFile     := ""
	Local cProd     := Space(4)
	Local aParamBox := {} 
	Local aArea     := GetArea()
	Local aRet		:= {}
	Local aGrupos   := {}
	Local nPos      := 0
	Local cCodZQJ   := GetNewPar("TI_GRPSAAS", "000021") //000021 - Grupo de Produtos SAAS
	Local lokSB1	:= .T.
	Local lokSB5	:= .T.
	Local lokSBM	:= .T.
	Local lokZQK	:= .T.
	Local cMsg      := ""
	Local cTipoDB   := "CTR" + "EEC" + "DX"

	If !ExistDir(cDir)
		MakeDir(cDir)
	Endif
	aDir := Directory("system\" + cDir + "\*.*")
	
	For nI := 1 to len(aDir)
		cArq := Alltrim(aDir[nI, 1])
		FErase("system\" + cDir + "\" + Lower(cArq))
	Next

	cQuery := " "
	cQuery += " SELECT * FROM "  

	Do Case
		Case cTabela == "SB1"
			aAdd(aParamBox,{1, "Iniciais do Cód Produto: " , cProd, "@!", ".T." , , ,  50 ,.T.}) 
			If ! ParamBox(aParamBox, "Confirme o produto a ser copiado", @aRet)
				RestArea(aArea)
				Return  
			EndIf 		
			cQuery +=  RetSQLName("SB1")
			cQuery += " WHERE B1_COD LIKE '" + aRet[1] + "%' "
			cQuery += " AND B1_FILIAL='" + FwxFilial("SB1") + "'"
			cQuery += " AND D_E_L_E_T_=' '  ORDER BY  B1_COD    "
		
	EndCase

	cAliasBD := CriaTrab(Nil,.F.)

	If Select(cAliasBD) > 0
		(cAliasBD)->(dbCloseArea())
	Endif 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)

	If !(cAliasBD)->(Eof())
		While !(cAliasBD)->(Eof())
			nPos := aScan(aGrupos,UPPER(AllTrim((cAliasBD)->B1_GRUPO)))
			If nPos == 0
				AADD(aGrupos,(cAliasBD)->B1_GRUPO)
			ENDIF
			(cAliasBD)->( dbSkip() )
		ENDDO
		(cAliasBD)->( dbGoTop() )
		FWMonitorMsg("Criando tabela "+cTabela+"..." )
		aCampos := (cAliasBD)->(dbStruct())

		If SELECT(cTabela) > 0
			(cTabela)->(dbCloseArea())
		Endif
		
		TCLink()
		// ProcRegua(1)
		&(cFCria)(cArqSB1, aCampos, cTipoDB)
		dbUseArea(.T.,cTipoDB,cArqSB1,cTabela,.F.,.F.)
		FWMonitorMsg("Appendando dados na tabela "+cTabela+"..." )
		// IncProc("Appendando dados na tabela SB1..." )	
		DbSelectArea(cTabela)

		APPEND FROM &cAliasBD VIA "TOPCONN"
		
		(cAliasBD)->(dbCloseArea())
		
		TCUnlink()
	ENDIF
		
	//   INICIA COPIA DA SB5

	cQuery := " "
	cQuery += " SELECT * FROM "  
	cQuery +=  RetSQLName("SB5")
	cQuery += " WHERE B5_COD LIKE '" + aRet[1] + "%' "
	cQuery += " AND B5_FILIAL='" + FwxFilial("SB5") + "'"
	cQuery += " AND D_E_L_E_T_=' '  ORDER BY  B5_COD    "
		
	cAliasBD := CriaTrab(Nil,.F.)

	If Select(cAliasBD) > 0
		(cAliasBD)->(dbCloseArea())
	Endif 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)

	If !(cAliasBD)->(Eof())

		FWMonitorMsg("Criando tabela SB5..." )
		aCampos := (cAliasBD)->(dbStruct())

		If SELECT("SB5") > 0
			SB5->(dbCloseArea())
		Endif

		TCLink()
		// ProcRegua(1)
		&(cFCria)(cArqSB5, aCampos, cTipoDB)
		dbUseArea(.T.,cTipoDB,cArqSB5,"SB5",.F.,.F.)
		FWMonitorMsg("Appendando dados na tabela SB5..." )
		// IncProc("Appendando dados na tabela SB5..." )	
		DbSelectArea("SB5")

		APPEND FROM &cAliasBD VIA "TOPCONN"
		
		(cAliasBD)->(dbCloseArea())
		
		TCUnlink()

	ENDIF

	//   FIM DA COPIA DA SB5   -------------------------------------------------

	//   INICIA COPIA DA SBM

	If cTabela=="SB1" .and. !Empty(aGrupos)

		cQuery := " "
		cQuery += " SELECT * FROM "  
		cQuery +=  RetSQLName("SBM")
		cQuery += " WHERE BM_GRUPO IN " + Arr2SQL(aGrupos) 
		cQuery += " AND BM_FILIAL='" + FwxFilial("SBM") + "'"
		cQuery += " AND D_E_L_E_T_=' '  ORDER BY  BM_GRUPO    "

		cAliasBD := CriaTrab(Nil,.F.)

		If Select(cAliasBD) > 0
			(cAliasBD)->(dbCloseArea())
		Endif 

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)

		If !(cAliasBD)->(Eof())

			FWMonitorMsg("Criando tabela SBM..." )
			aCampos := (cAliasBD)->(dbStruct())

			If SELECT("SBM") > 0
				SBM->(dbCloseArea())
			Endif

			TCLink()
			// ProcRegua(1)
			&(cFCria)(cArqSBM, aCampos, cTipoDB)
			dbUseArea(.T.,cTipoDB,cArqSBM,"SBM",.F.,.F.)
			FWMonitorMsg("Appendando dados na tabela SBM..." )
			// IncProc("Appendando dados na tabela SBM..." )	
			DbSelectArea("SBM")

			APPEND FROM &cAliasBD VIA "TOPCONN"

			(cAliasBD)->(dbCloseArea())

			TCUnlink()

		ENDIF

	ENDIF
		
	//   FIM DA COPIA DA SBM -------------------------------------------------

	//   INICIA COPIA DA ZQK

	If cTabela=="SB1" .and. !Empty(aGrupos)
		cQuery := " "
		cQuery += " SELECT * FROM "  
		cQuery +=  RetSQLName("ZQK")
		cQuery += " WHERE ZQK_GRUPO IN " + Arr2SQL(aGrupos)
		cQuery += " AND ZQK_CODZQJ IN " + FormatIn(cCodZQJ, ";") 
		cQuery += " AND ZQK_FILIAL='" + FwxFilial("ZQK") + "'"
		cQuery += " AND D_E_L_E_T_=' '  ORDER BY  ZQK_CODZQJ,ZQK_ITEM,ZQK_GRUPO    "

		cAliasBD := CriaTrab(Nil,.F.)

		If Select(cAliasBD) > 0
			(cAliasBD)->(dbCloseArea())
		Endif 

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)

		If !(cAliasBD)->(Eof())

			FWMonitorMsg("Criando tabela ZQK..." )
			aCampos := (cAliasBD)->(dbStruct())

			If SELECT("ZQK") > 0
				ZQK->(dbCloseArea())
			Endif

			TCLink()
			// ProcRegua(1)
			&(cFCria)(cArqZQK, aCampos, cTipoDB)
			dbUseArea(.T.,cTipoDB,cArqZQK,"ZQK",.F.,.F.)
			FWMonitorMsg("Appendando dados na tabela ZQK..." )
			// IncProc("Appendando dados na tabela ZQK..." )	
			DbSelectArea("ZQK")

			APPEND FROM &cAliasBD VIA "TOPCONN"

			(cAliasBD)->(dbCloseArea())

			TCUnlink()

		ENDIF

	ENDIF
		
	//   FIM DA COPIA DA ZQK -------------------------------------------------

		cFile := TFileDialog("Arquivos (*.dtc) |*.dtc|","Onde deseja salvar o arquivo", , "C:\", .F., GETF_LOCALHARD + GETF_LOCALFLOPPY)

		If Empty(cFile)
			RestArea(aArea)
			Return .F.
		Endif
		
		If ! Lower(Right(cFile, 4)) == ".dtc"
			cFile += ".dtc"
		EndIf
		
		If File(cFile)
			If ! FWAlertYesNo("Confirma a substituição do arquivo?")
				RestArea(aArea)
				Return .F.
			EndIf
			FErase(cFile)
		EndIF

		lokSB1 := CpyS2T(cArqSB1+".dtc", SubStr(cFile,1,RAT("\",cFile)))
		lokSB5 := CpyS2T(cArqSB5+".dtc", SubStr(cFile,1,RAT("\",cFile)))
		lokSBM := CpyS2T(cArqSBM+".dtc", SubStr(cFile,1,RAT("\",cFile)))
		lokZQK := CpyS2T(cArqZQK+".dtc", SubStr(cFile,1,RAT("\",cFile)))
		cMsg := IIF(lokSB1,cArqSB1+".dtc - OK !",cArqSB1+".dtc - não copiado !") + CRLF
		cMsg += IIF(lokSB5,cArqSB5+".dtc - OK !",cArqSB5+".dtc - não copiado !") + CRLF
		cMsg += IIF(lokSBM,cArqSBM+".dtc - OK !",cArqSBM+".dtc - não copiado !") + CRLF
		cMsg += IIF(lokZQK,cArqZQK+".dtc - OK !",cArqZQK+".dtc - não copiado !")
		FWAlertInfo(cMsg,"Resultado da cópia dos arquivos na pasta: " + SubStr(cFile,1,RAT("\",cFile)))

	RestArea(aArea)
Return

/*/{Protheus.doc} DTCSM0 
   Cria uma cópia da tabela relacionada ao SYS_COMPANY
   @type  User Function
   @author Julio Saraiva
   @since 08/11/2024
   @version version
   @param cTabela
   @return 
   @example
   (examples)
/*/

User Function DTCSM0(cTabela) 
	Local aCampos	:= {}   //defino a variavel do tipo array para criar os campos  
	Local cArquivo	:= "system\" + cDir + "\" + "SYS_COMPANY_"+STRTRAN(TIME(),":")  // \SYSTEM\INTEGRADOR\SYS_COMPANY.DTC  	
	Local aDir		:= {}
	Local nI        := 0
	Local cArq      := ""
	Local cAliasBD	:= "" 
	Local cQuery    := ""
	Local cFile     := ""
	Local aArea     := GetArea()
	Local cTipoDB   := "CTR" + "EEC" + "DX"

	If !ExistDir(cDir)
		MakeDir(cDir)
	Endif
	aDir := Directory("system\" + cDir + "\*.*")
	
	For nI := 1 to len(aDir)
		cArq := Alltrim(aDir[nI, 1])
		FErase("system\" + cDir + "\" + Lower(cArq))
	Next

	cQuery := " "
	cQuery += " SELECT * FROM SYS_COMPANY "  
	cQuery += " WHERE M0_CODFIL =  '" + ALLTRIM(cFilDest)+"' "
	cQuery += " AND D_E_L_E_T_=' ' "

	cAliasBD := CriaTrab(Nil,.F.)

	If Select(cAliasBD) > 0
		(cAliasBD)->(dbCloseArea())
	Endif 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasBD,.T.,.T.)

	If !(cAliasBD)->(Eof())
		FWMonitorMsg("Criando tabela "+cTabela+"..." )
		aCampos := (cAliasBD)->(dbStruct())

		If SELECT(cTabela+"_wh") > 0
			(cTabela+"_wh")->(dbCloseArea())
		Endif
		
		TCLink()
		// ProcRegua(1)
		&(cFCria)(cArquivo, aCampos, cTipoDB)
		dbUseArea(.T.,cTipoDB,cArquivo,cTabela+"_wh",.F.,.F.)
		FWMonitorMsg("Appendando dados na tabela "+cTabela+"..." )
		// IncProc("Appendando dados na tabela SYS_COMPANY..." )	
		DbSelectArea(cTabela+"_wh")

		APPEND FROM &cAliasBD VIA "TOPCONN"
		
		(cAliasBD)->(dbCloseArea())
		
		TCUnlink()
	ENDIF
		

	cFile    := TFileDialog("Arquivos (*.dtc) |*.dtc|","Onde deseja salvar o arquivo",  , "C:\", .F., GETF_LOCALHARD + GETF_LOCALFLOPPY)

	If Empty(cFile)
		RestArea(aArea)
		Return .F.
	Endif

	If ! Lower(Right(cFile, 4)) == ".dtc"
		cFile += ".dtc"
	EndIf

	If File(cFile)
		If ! FWAlertYesNo("Confirma a substituição do arquivo?")
			RestArea(aArea)
			Return .F.
		EndIf
		FErase(cFile)
	EndIF
		
	If CpyS2T(cArquivo+".dtc", SubStr(cFile,1,RAT("\",cFile)))
		FWAlertSuccess("Arquivos copiados com sucesso em " + SubStr(cFile,1,RAT("\",cFile)))
	ELSE
		FWAlertError("Não foi possível a cópia dos arquivos !")
	ENDIF

	RestArea(aArea)

Return


/*/{Protheus.doc} U_ExclPN1 
   Exclui CNPJ's da PN1 de contratos previamente migrados
   @type  User Function
   @author Julio Saraiva
   @since 08/11/2024
   @version version
   @param cTabela
   @return 
   @example
   (examples)
/*/

User Function ExclPN1(cTabela)
	Local cAlias	:= "" 
	Local cQuery    := ""
	Local aArea     := GetArea()
	Local cRet      := Formatin(ALLTRIM(cFilPesq),",")
	Local aRecnos   := {}
	Local cString   := ""
	Local nError    := 0
	Local nI		:= 0

	If Empty(Alltrim(cFilPesq))
		FWAlertError("É necessário informar algum CNPJ !")
		RestArea(aArea)
		Return .F.
	Endif

	cQuery += " SELECT R_E_C_N_O_ AS RECPN1 FROM " + RetSQLName("PN1") 
	cQuery += " WHERE PN1_FILIAL='" + FwxFilial("PN1") + "' "
	cQuery += " AND PN1_ALIAS='CN9' "
	cQuery += " AND PN1_CHVFUL IN " + cRet + " AND D_E_L_E_T_=' '"

	cAlias := CriaTrab(Nil,.F.)

	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	Endif 

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	FWMonitorMsg("Selecionando registros na "+cTabela+"..." )

	While !(cAlias)->(Eof())
		AADD(aRecnos,(cAlias)->RECPN1)
		(cAlias)->( dbSkip() )
	ENDDO

	For nI:=1 to Len(aRecnos)
		cString += cValtoChar(aRecnos[nI])+","
	Next nI

	If Right(cString, 1) == ","
		cString := SubStr(cString,1,Len(cString)-1)
	Endif

	Begin Transaction 

	cQuery := "UPDATE " + RetSqlName("PN1") + " SET PN1_FILIAL='"+AllTrim(cFilDest)+"' WHERE R_E_C_N_O_ IN (" + AllTrim(cString) + ")"

	If (nError := TCSQLExec(cQuery)) <> 0
		FWAlertError("Erro ao atualizar " + cTabela + CRLF + AllTrim(Str(nError)) + "-" + TCSQLError())
		DisarmTransaction()
	Else
		FWAlertSuccess("Registros atualizados com sucesso!!!")
	EndIf

	End Transaction

	RestArea(aArea)
Return
/*
Retorna um Array formatado para ser usado em uma query. 
Julio Saraiva - 08/11/2024
Ex: ('123','456')
*/
Static Function Arr2SQL(aDados)
	Local cString  := ""
	Local cRet     := ""

	//Transforma o Array em uma String
	cString := CenArr2Str(aDados,"/")

	cRet := Formatin(cString,"/") 

Return cRet

Static Function TIFCreate(cFile, nAtt)
    Local nRet := 0
    Local cFun  := "MSFCreate"

    nRet := &(cFun)(cFile, nAtt)

Return nRet 


Static Function TIOpen(cFile, nAtt)
    Local nRet := 0
    Local cFun  := "FOpen"

    nRet := &(cFun)(cFile, nAtt)

Return nRet 

/*/{Protheus.doc} DuplDTC
   @type  User Function
   @author Julio Saraiva
   @since 21/01/2025
   @version version
   @param cTabela
   @return 
   @example
   (examples)
/*/

User Function DuplDTC(cTabela) 
	Local aArea		:= GetArea()
	Local aParamBox := {}
	Local lRet      := .T.
	Local aCposAlt  := {}
	Local aRet      := {}

	Do Case
		Case cTabela == "CE1"
			aAdd(aParamBox,{1, "Filial Orig.: " , cFilant,  "@!", ".T." ,"SM0"  , ,  50 ,.T.}) 
			aAdd(aParamBox,{1, "Filial Dest.: " , cFildest, "@!", ".T." ,"SM0"  , ,  50 ,.T.})

			If ! ParamBox(aParamBox, "Informe as filiais de Origem e Destino da tabela CE1", @aRet)
				RestArea(aArea)
				Return  
			EndIf 
		OtherWise
			lRet := .F.
	EndCase

	If lRet
		If AllTrim(aRet[1])==AllTrim(aRet[2])
			FWAlertError("Filial de Destino não pode ser igual a Filial de Origem !")
			RestArea(aArea)
			Return 	
		Endif
		dbSelectArea("CE1")	
		dbSetOrder(1)
		If dbSeek(AllTrim(aRet[2]))
			FWAlertError("Filial de Destino já possui a CE1 configurada !")
			RestArea(aArea)
			Return 	
		Endif

		aCposAlt := { {"CE1_FILIAL" , AllTrim(aRet[2])} }

		If dbSeek(AllTrim(aRet[1]))
			Begin Transaction
			While CE1->CE1_FILIAL == AllTrim(aRet[1]) .AND. !(EOF())       

				If !( DuplicReg("CE1", aCposAlt) > 0)
					FWAlertError("Problemas na criação da CE1.")
					lRet := .F.
				EndIf
				CE1->( DBSkip() )
			ENDDO

			END TRANSACTION
		Else
			FWAlertError("CE1 da filial "+AllTrim(aRet[1])+" não encontrada !")
			lRet := .F.
		Endif

	Endif
	If lRet
		FWAlertSuccess("Registros copiados com sucesso!!!")
	Endif

	RestArea(aArea)
Return

/*/{Protheus.doc} DuplicReg
Funcao para duplicação de registros 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function DuplicReg(cArquiv1, aCposAlt)
	Local aArea   		:= GetArea()
	Local aArea1   		:= (cArquiv1)->(GetArea())
	Local aCampos  		:= {}
	Local nCampos		:= 0
	Local nContador		:= 0
	Local nElem			:= 0
	Local nReturn		:= 0

	If Len(aCposAlt) <= 0
		Return(nReturn)
	EndIf

	dbSelectArea(cArquiv1)
	nCampos := FCOUNT()
	For nContador := 1 To nCampos
		nElem	:= aScan(aCposAlt, { |x| AllTrim(x[1]) == FieldName(nContador) })
		If nElem > 0
			aAdd(aCampos, {FieldName(nContador), aCposAlt[nElem,2]		})
		Else
			aAdd(aCampos, {FieldName(nContador), FieldGet(nContador)	})
		EndIf
	Next

	RecLock( cArquiv1, .T., , .T. , .T. )
	For nContador := 1 To nCampos
		cVar 		:= (cArquiv1+"->"+aCampos[nContador,1]) 
		&cVar		:= aCampos[nContador, 2]
	Next 
	MsUnlock()         
	nReturn := RECNO()	

	(cArquiv1)->(RestArea(aArea1))
	RestArea(aArea)       

Return(nReturn)


/*/{Protheus.doc} LstParam
Listagem de Parâmetros de uma determinada filial 

@author		Julio Saraiva
@since		19/02/2025
@version	1.0
/*/

User Function LstParam()
	Local cNameRel 		:= ""
	Local cArqXls 		:= ""
	Local aArea	    	:= GetArea()
	Local cAliasEx		:= GetNextAlias()
	Local cArqXlsRoot   := ""
	Local aParamBox		:= {}
	Local cFilBx    	:= Space(11)
	Local cFilBax       := cFilDest
	Local cQry          := ""

	cFilBx := CFILANT
	aAdd(aParamBox,{01,"Filial "	,cFilBx 	,""					,"","SM0","", 60,.F.})	// MV_PAR01

	If ParamBox(aParamBox,"Listagem de Parâmetros - Escolha uma filial:",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
		cFilBax := MV_PAR01

		// -- ZX5
		cNameRel := "ZX5_" + Alltrim(cFilBax) + DToS(Date()) + "_" + StrTran(Time(),":","") + ".xls"
		cQry := "SELECT * FROM " + RetSQLName("ZX5") + " WHERE (ZX5_FILIAL='" + ALLTRIM(cFilBax) + "' OR ZX5_CHAVE2 LIKE '%" + ALLTRIM(cFilBax) + "%' ) AND D_E_L_E_T_ = ' ' "
		dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)),cAliasEx, .F., .T.)
		cArqXlsRoot  := TFileDialog('Todos os arquivos (*.xls)| *.xls', 'Informe o diretorio para a geração do excel',  , Nil, .F., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)

		If Empty(cArqXlsRoot)
			MsgAlert("Diretorio não informado!")
    		RestArea(aArea)
    		If ( Select(cAliasEx) > 0 )
        		(cAliasEx)->( dbCloseArea() )
    		EndIf			
			Return
		EndIf 

		cArqXls := cArqXlsRoot + Lower(cNameRel)

		If File(cArqXls)
			FErase(cArqXls)
		EndIf 

		U_TIExcel(cAliasEx, cArqXlS)
		
		If ( Select(cAliasEx) > 0 )
			(cAliasEx)->( dbCloseArea() )
		EndIf


		// -- SX5
		// ---------
		cQry     := "SELECT * FROM " + RetSQLName("SX5") + " WHERE (X5_FILIAL='" + ALLTRIM(cFilBax) + "' OR X5_DESCRI LIKE '%" + ALLTRIM(cFilBax) + "%' ) AND D_E_L_E_T_ = ' ' "
		cNameRel := "SX5_" + Alltrim(cFilBax) + DToS(Date()) + "_" + StrTran(Time(),":","") + ".xls"
		cAliasEx := GetNextAlias()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)),cAliasEx, .F., .T.)

		cArqXls := cArqXlsRoot + Lower(cNameRel)
		
		If File(cArqXls)
			FErase(cArqXls)
		EndIf 

		U_TIExcel(cAliasEx, cArqXlS)
		
		If ( Select(cAliasEx) > 0 )
			(cAliasEx)->( dbCloseArea() )
		EndIf


		// -- SX6
		// ---------
		cQry     := "SELECT * FROM " + RetSQLName("SX6") + " WHERE (X6_FIL='" + ALLTRIM(cFilBax) + "' OR X6_CONTEUD LIKE '%" + ALLTRIM(cFilBax) + "%' ) AND D_E_L_E_T_ = ' '
		cNameRel := "SX6_" + Alltrim(cFilBax) + DToS(Date()) + "_" + StrTran(Time(),":","") + ".xls"
		cAliasEx := GetNextAlias()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)),cAliasEx, .F., .T.)

		cArqXls := cArqXlsRoot + Lower(cNameRel)
		
		If File(cArqXls)
			FErase(cArqXls)
		EndIf 

		U_TIExcel(cAliasEx, cArqXlS)
		
		If ( Select(cAliasEx) > 0 )
			(cAliasEx)->( dbCloseArea() )
		EndIf

		RestArea(aArea)

	Endif

Return
