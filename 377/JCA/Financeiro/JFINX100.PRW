#INCLUDE "rwMake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#Include "RPTDEF.CH"
#INCLUDE "topconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "AP5MAIL.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ JFINX100 ³ Autor ³ Microsigal ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCARIO COM CODIGO DE BARRAS          ³±±
±±³          ³ Banco Santander                                            ³±±
±±³          ³ Banco do Brasil                                            ³±±
±±³          ³ Banco Bradesco                                             ³±±
±±³          ³ Banco Itau                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±f±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JFINX100(lDanfe,lEmail,lTitulo)
	Local 	aMV		  	:= {}
	Local 	aParam		:= {}
	Local 	aRet		:= {}
	Local 	nXi			:= 0
	Local   cSubCta		:= "REA"
	local aBcoPad := {}
	//Local   aBcoPad		:= StrToKarr( Alltrim( SuperGetMV("FS_BCOPAD",.T.,"SUB;BCO;AGE;CTA") ), ";" )

	Private lExec      := .F.
	Private cIndexName := ''
	Private cIndexKey  := ''
	Private cFilter    := ''
	Private cMarca  	:= GetMark()
	Private cCadastro   := 'Impressao de Boleto com Codigo de Barras'
	Private aRotina 	:= {}

	private lBolSeparado := SuperGetMV("FS_BOLSEP",.T.,.T.)
	private cCmpVencto :=  SuperGetMV("FS_CMPVENC",.T.,"SE1->E1_VENCTO")
	private lBolEmail := SuperGetMV("FS_BOLEMAI",.T.,.F.)
	
	Default lDanfe 		:= .f.
	Default lEmail		:= .f.
	Default lTitulo		:= .f.
	
	if lBolEmail
		aRotina := {{ 'Imprime Boletos' , 'U_RF01BImp(.F.)' , 0, 1 },;
					{ 'Envia Boletos' , 'U_RF01BImp(.T.)' , 0, 1 }}
	else
		aRotina := {{ 'Imprime Boletos' , 'U_RF01BImp(.F.)' , 0, 1 }}
	endif

	aadd(aMV,MV_PAR01)
	aadd(aMV,MV_PAR02)
	aadd(aMV,MV_PAR03)
	aadd(aMV,MV_PAR04)
	aadd(aMV,MV_PAR05)
	aadd(aMV,MV_PAR06)
	aadd(aMV,MV_PAR07)
	aadd(aMV,MV_PAR08)
	aadd(aMV,MV_PAR09)
	aadd(aMV,MV_PAR10)
	aadd(aMV,MV_PAR11)
	aadd(aMV,MV_PAR12)
	aadd(aMV,MV_PAR13)
	aadd(aMV,MV_PAR14)
	aadd(aMV,MV_PAR15)
	aadd(aMV,MV_PAR16)
	aadd(aMV,MV_PAR17)
	aadd(aMV,MV_PAR18)
	aadd(aMV,MV_PAR19)
	aadd(aMV,MV_PAR20)
	aadd(aMV,MV_PAR21)
	aadd(aMV,MV_PAR22)
	
	cPerg              := "JFINX100"
	
	dbSelectArea("AC8")
	dbSetOrder(1)
	dbSelectArea("SU5")
	dbSetOrder(1)
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSelectArea("SA6")
	dbSetOrder(1)
	dbSelectArea("SA1")
	dbSetOrder(1)
	DbSelectArea("SEE")
	dbSetOrder(1)
	DbSelectArea("SE4")
	dbSetOrder(1)
	
			
	If !lDanfe .and. !lTitulo
	
		VldPrg1()
	
		Pergunte("JFINX100",.F. )
		aSays 		:= {}
		aButtons 	:= {}
		nOpca		:= 0
		lPerg		:= .T.

		AADD(aSays,OemToAnsi( 'Rotina de Impressao de Boleto' ) ) 
		
		AADD(aButtons, { 5,.T.,{|| lPerg := Pergunte("JFINX100",.T. ) } } )
		AADD(aButtons, { 1,.T.,{|| iif(lPerg,(nOpca:= 1, FechaBatch()),nOpca := 0) }} )
		AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
		
		FormBatch( cCadastro, aSays, aButtons ,,,370)	

		If nOpca != 1
			Return .f.
		Endif	
	Else
		aBcoPad := EscolheBco(SF2->F2_CLIENTE+SF2->F2_LOJA)
		
		if Empty(aBcoPad)
			return
		endif
		
		if Len(aBcoPad) >= 1
			//MV_PAR20 := AvKey(aBcoPad[1],"EE_CODIGO")
			MV_PAR20 := aBcoPad[1]
		else
			MV_PAR20 := AvKey("","EE_CODIGO")
		endif
		
		if Len(aBcoPad) >= 2
			//MV_PAR21 := AvKey(aBcoPad[2],"EE_AGENCIA")
			MV_PAR21 := aBcoPad[2]
		else
			MV_PAR21 := AvKey("","EE_AGENCIA")
		endif
		
		if Len(aBcoPad) >= 3
			//MV_PAR22 := AvKey(aBcoPad[3],"EE_CONTA")
			MV_PAR22 := aBcoPad[3]
		else
			MV_PAR22 := AvKey("","EE_CONTA")
		endif
		
		if Len(aBcoPad) >= 4
			//MV_PAR19 := AvKey(aBcoPad[4],"EE_SUBCTA")
			MV_PAR19 := aBcoPad[4]
		else
			MV_PAR19 := AvKey("","EE_SUBCTA")
		endif
		
	Endif
	
	/*If len(aBcoPad) >= 1
		MV_PAR19 := AvKey(aBcoPad[1],"EE_SUBCTA")
	Else	
		MV_PAR19 := AvKey("","EE_SUBCTA")
	Endif	
	
	If len(aBcoPad) >= 2
		MV_PAR20 := AvKey(aBcoPad[2],"EE_CODIGO")
	Else	
		MV_PAR20 := AvKey("","EE_CODIGO")
	Endif	

	If len(aBcoPad) >= 3
		MV_PAR21 := AvKey(aBcoPad[3],"EE_AGENCIA")
	Else	
		MV_PAR21 := AvKey("","EE_AGENCIA")
	Endif	

	If len(aBcoPad) >= 4
		MV_PAR22 := AvKey(aBcoPad[4],"EE_CONTA")
	Else	
		MV_PAR22 := AvKey("","EE_CONTA")
	Endif	*/

	If lDanfe
		if FunName() == "LOJA701"
			dbSelectArea("SF2")
			dbSetOrder(1)
			dbSeek(xFilial("SL1")+SL1->L1_DOC+SL1->L1_SERIE)
		endif
	
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
				
		// Nao imprime Se Cliente Não imprime boleto A1_BLEMAIL == 1
		If SA1->(FieldPos("A1_BLEMAIL")) > 0
			If SA1->A1_BLEMAIL != "1"
				Help(" ",1,"JFINX100",,"Cliente da NF "+SF2->F2_DOC+" nao esta liberado para gerar boleto. Boleto nao sera impresso.",1,0)
				Return .f.	
			Endif
		Endif	
		
		/*
		// Nao imprime Se Cliente nao é privado A1_TPCLIEN == 1
		If SA1->(FieldPos("A1_TPCLIEN")) > 0
			If SA1->A1_TPCLIEN != "1"
				Help(" ",1,"JFINX100",,"Cliente da NF "+SF2->F2_DOC+" nao e um cliente privado. Boleto nao sera impresso.",1,0)
				Return .f.	
			Endif
		Endif
		*/	
		
		// Nao imprime Se Cond Pagamento == A Vista
		If Alltrim(SF2->F2_COND) == "001"
			Help(" ",1,"JFINX100",,"Condicao de Pagamento A VISTA. Boleto nao sera impresso.",1,0)
			Return .f.	
		Endif			
					
		// Atualiza parametro do banco MV_PAR20 A MV_PAR21

		MV_PAR01	:= SPACE(TamSX3("E1_PREFIXO")[1])					//De Prefixo
		MV_PAR02	:= Replicate("Z",TamSX3("E1_PREFIXO")[1])			//Ate Prefixo
		MV_PAR03	:= SF2->F2_DOC										//De Numero
		MV_PAR04	:= SF2->F2_DOC										//Ate Numero
		MV_PAR05	:= SPACE(TamSX3("E1_PARCELA")[1])					//De Parcela
		MV_PAR06	:= Replicate("Z",TamSX3("E1_PARCELA")[1])			//Ate Parcela
		MV_PAR07	:= SPACE(TamSX3("E1_PORTADO")[1])					//De Portador
		MV_PAR08	:= Replicate("Z",TamSX3("E1_PORTADO")[1])			//Ate Portador
		MV_PAR09	:= SF2->F2_CLIENTE									//De Cliente
		MV_PAR10	:= SF2->F2_CLIENTE									//Ate Cliente
		MV_PAR11	:= SF2->F2_LOJA										//De Loja
		MV_PAR12	:= SF2->F2_LOJA										//Ate Loja
		MV_PAR13	:= SF2->F2_EMISSAO									//De Emissao
		MV_PAR14	:= SF2->F2_EMISSAO									//Ate Emissao
		MV_PAR15	:= SF2->F2_EMISSAO-5000								//De Vencimento
		MV_PAR16	:= SF2->F2_EMISSAO+5000								//Ate Vencimento
		MV_PAR17	:= SPACE(TamSX3("E1_NUMBOR")[1])					//Do Bordero
		MV_PAR18	:= Replicate("Z",TamSX3("E1_NUMBOR")[1])			//Ate Bordero
	ElseIf lTitulo	
	
	
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				
		// Nao imprime Se Cliente Não imprime boleto A1_BLEMAIL == 1
		If SA1->(FieldPos("A1_BLEMAIL")) > 0
			If SA1->A1_BLEMAIL != "1"
				Help(" ",1,"JFINX100",,"Cliente da NF "+SE1->E1_NUM+" nao esta liberado para gerar boleto. Boleto nao sera impresso.",1,0)
				Return .f.	
			Endif
		Endif	
		
		// Nao imprime Se Cliente nao é privado A1_TPCLIEN == 1
		If SA1->(FieldPos("A1_TPCLIEN")) > 0
			If SA1->A1_TPCLIEN != "1"
				Help(" ",1,"JFINX100",,"Cliente da NF "+SE1->E1_NUM+" nao e um cliente privado. Boleto nao sera impresso.",1,0)
				Return .f.	
			Endif
		Endif				
					
		// Atualiza parametro do banco MV_PAR20 A MV_PAR21
		MV_PAR01	:= SPACE(TamSX3("E1_PREFIXO")[1])				//De Prefixo
		MV_PAR02	:= Replicate("Z",TamSX3("E1_PREFIXO")[1])		//Ate Prefixo
		MV_PAR03	:= SE1->E1_NUM									//De Numero
		MV_PAR04	:= SE1->E1_NUM									//Ate Numero
		MV_PAR05	:= SPACE(TamSX3("E1_PARCELA")[1])				//De Parcela
		MV_PAR06	:= Replicate("Z",TamSX3("E1_PARCELA")[1])		//Ate Parcela
		MV_PAR07	:= SPACE(TamSX3("E1_PORTADO")[1])				//De Portador
		MV_PAR08	:= Replicate("Z",TamSX3("E1_PORTADO")[1])		//Ate Portador
		MV_PAR09	:= SE1->E1_CLIENTE								//De Cliente
		MV_PAR10	:= SE1->E1_CLIENTE								//Ate Cliente
		MV_PAR11	:= SE1->E1_LOJA									//De Loja
		MV_PAR12	:= SE1->E1_LOJA									//Ate Loja
		MV_PAR13	:= SE1->E1_EMISSAO								//De Emissao
		MV_PAR14	:= SE1->E1_EMISSAO								//Ate Emissao
		MV_PAR15	:= &(cCmpVencto)-5000							//De Vencimento
		MV_PAR16	:= &(cCmpVencto)+5000							//Ate Vencimento
		MV_PAR17	:= SPACE(TamSX3("E1_NUMBOR")[1])				//Do Bordero
		MV_PAR18	:= Replicate("Z",TamSX3("E1_NUMBOR")[1])		//Ate Bordero	

		lBolSeparado := .F.
	Endif

	cIndexName	:= Criatrab(Nil,.F.)
	cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
	cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
	cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And."
	cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
	cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
	cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
	cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
	cFilter		+= "E1_LOJA >='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
	cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
	cFilter		+= "DTOS("+AllTrim(SubStr(cCmpVencto,6,10))+")>='"+DTOS(mv_par15)+"'.and.DTOS("+AllTrim(SubStr(cCmpVencto,6,10))+")<='"+DTOS(mv_par16)+"'.And."
	cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
	cFilter     += "!(E1_TIPO$MVABATIM)"// .And. E1_TIPO$'"+SuperGetMV("FS_TIPBOL",.F.,"NF/BOL")+"'"
	//cFilter     += "!(E1_TIPO$MVABATIM) .And. "
	//cFilter     += "!(E1_TIPO$MVABATIM) .And. E1_TIPO$'"+SuperGetMV("FS_TIPBOL",.T.,"BOL")+"' .And."
	//cFilter		+= "(E1_PORTADO = '   ' .or. E1_PORTADO = '"+ MV_PAR20 +"' ) "
	//cFilter     += "EXECBLOCK('FBLEMAIL',.F.,.F.,{SE1->E1_CLIENTE,SE1->E1_LOJA})"
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")
	dbGoTop()

	DbSelectArea("SE1")
	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	SE1->(dbGoTop())
	
	If lDanfe .or. lTitulo
		If !SE1->(Eof())
			dbSelectArea("SE1")
			SE1->(dbGotop())
			While !SE1->(Eof())
				RecLock( "SE1", .F. )
				Replace E1_OK With cMarca
				MsUnLock()
				SE1->(dbSkip())
			EndDo
			SE1->(dbGotop())
			U_RF01BImp(lEmail)
		Endif	
	Else	
		MarkBrow ("SE1","E1_OK",,,,cMarca,"U_RF01BMarcaT(.T.)",,,,"U_RF01BMarcaT(.F.)",,,,,,,,.F.)
	Endif	
	RetIndex("SE1")
	Ferase(cIndexName+OrdBagExt())
	
	MV_PAR01 := aMV[1]
	MV_PAR02 := aMV[2]
	MV_PAR03 := aMV[3]
	MV_PAR04 := aMV[4]
	MV_PAR05 := aMV[5]
	MV_PAR06 := aMV[6]
	MV_PAR07 := aMV[7]
	MV_PAR08 := aMV[8]
	MV_PAR09 := aMV[9]
	MV_PAR10 := aMV[10]
	MV_PAR11 := aMV[11]
	MV_PAR12 := aMV[12]
	MV_PAR13 := aMV[13]
	MV_PAR14 := aMV[14]
	MV_PAR15 := aMV[15]
	MV_PAR16 := aMV[16]
	MV_PAR17 := aMV[17]
	MV_PAR18 := aMV[18]
	MV_PAR19 := aMV[19]
	MV_PAR20 := aMV[20]
	MV_PAR21 := aMV[21]
	MV_PAR22 := aMV[22]

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³MARCATODOSºAutor  ³ Ernani Forastieri  º Data ³  27/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Auxiliar para marcar/desmarcar todos os itens do    º±±
±±º          ³ ListBox ativo                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RF01BImp(lEmail)

	Local aArea  := GetArea()
	Local cRetCam := ''
	Default lEmail := .f.
	

	lProblema := .F.
	lExec := .T.
	SE1->(dbGoTop())
	
	if lEmail .or. lBolSeparado
		While !SE1->(EOF())
	
			If !(SE1->E1_OK == cMarca) //Caio de Castro - 30/07/12 - Somente registro marcados
				SE1->(dbSkip())
				Loop
			EndIf
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					
			// Nao imprime Se Cliente Não imprime boleto A1_BLEMAIL == 1
			If SA1->(FieldPos("A1_BLEMAIL")) > 0
				If SA1->A1_BLEMAIL != "1"
					Help(" ",1,"JFINX100",,"Cliente da NF "+SE1->E1_NUM+" nao esta liberado para gerar boleto. Boleto nao sera impresso.",1,0)
					SE1->(dbSkip())
					Loop
				Endif
			Endif
			
			// Nao gera boleto se não estiver o tipo no parametro
			//If !(AllTrim(SE1->E1_TIPO) $ SuperGetMV("FS_TIPBOL",.T.,"BOL"))
				//Help(" ",1,"JFINX100",,"O tipo do titulo "+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" nao e aceito para emitir boleto.",1,0)
				//SE1->(dbSkip())
				//Loop	
			//Endif
			
			// Nao envia novamente boleto para cliente
			If SE1->(FieldPos("E1_ZIMPBOL")) > 0 .AND. lEmail
				If SE1->E1_ZIMPBOL == "2"
					if !MSGYESNO("O boleto <b>"+AllTrim(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA))+"</b> já foi enviado para o cliente <b>"+AllTrim(SA1->A1_NREDUZ)+IIf(SA1->(FieldPos("A1_EMAIL")) > 0,"</b> no e-mail <u>"+AllTrim(SA1->A1_EMAIL)+"</u>.",".")+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Deseja reenviar?","Reenviar Boleto")
						SE1->(dbSkip())
						Loop	
					endif
				Endif
			Endif
			
			cNumTit := AllTrim(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA))
			
			if !lEmail
				lProblema := U_RF01B062(,,,, lEmail)
			else
				lProblema := FWMsgRun(, {|| U_RF01B062(,,,, lEmail) }, "Aguarde...", "Gerando o boleto para ser enviado no e-mail do cliente...")
			endif
			
			if lProblema
				//DbSelectArea("SE1")
				//dbSkip()
				//Loop
				exit
			endif
		EndDo
	else
		cRetCam := RF02B062(,,,, lEmail)
	endif

	RestArea(aArea)
	
Return(cRetCam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³MARCATODOSºAutor  ³ Ernani Forastieri  º Data ³  27/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Auxiliar para marcar/desmarcar todos os itens do    º±±
±±º          ³ ListBox ativo                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RF01BMarcaT( lMarkAll )

	Local aArea	:= GetArea()
	Local cMarkAll

	If lMarkAll
		dbSelectArea("SE1")
		dbGotop()
		If !SE1->(Eof())
			cMarkAll := IIf(SE1->E1_OK == cMarca ,Space(2), cMarca)
			While !SE1->(Eof())
				RecLock( "SE1", .F. )
				Replace E1_OK With cMarkAll
				MsUnLock()
				SE1->(dbSkip())
			EndDo
		EndIf
	Else
		RecLock( "SE1", .F. )
		Replace E1_OK With IIf(SE1->E1_OK == cMarca ,Space(2), cMarca)
		MsUnLock()
	EndIf

	RestArea(aArea)
	Return

Return NIL
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RF01B062 ³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DE BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//Desta forma posso chamar direto da nota por exemplo, passando os parametros
User Function RF01B062(xBanco,xAgencia,xConta,xSubCt, lEmail)

	Local cDir			:= Alltrim(GetTempPath()) //Busca Pasta temporaria do Usuario
	Local cPath 		:= Replace( cDir, "\\", "\" )
	Local cRutaSmr 		:= Alltrim(GetTempPath()) 
	Local cPDFNom		:= "BOLETO_"+Dtos(MSDate())+StrTran(Time(),":","")
	Local oPrint
	Local nX 			:= 0
	Local cNroDoc 	   	:=  " "
	Local aDadosEmp
	Local lGerBol		:= .f.

	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	Local aBolText

	Local nI           := 1
	Local aCB_RN_NN    := {}
	Local nVlrAbat	   := 0
	Local nDvnn 	   := 0
	Local aTo		   := {}
	
	Local lProblema		:= .F.
	Local cLib

	Private cBanco   	:= ""
	Private cAgencia 	:= ""
	Private cConta   	:= ""
	Private aCabec  	:= {}
	
	Default lEmail		:= .f.
	Default	xBanco		:= ""
	Default xAgencia	:= ""
	Default xConta		:= ""
	Default xSubCt		:= ""

	/*IF ISSRVUNIX()
		cPath := Replace( cPath, "\", "/" )
	End If*/
	
	if GetRemoteType(@cLib) == 2
		cPath := StrTran(cPath,"\","/")
	endif
	
	lAdjustToLegacy 	:= .t. // Inibe legado de resolução com a TMSPrinter
	oPrint 				:= FWMSPrinter():New(cPdfNom, IMP_PDF, lAdjustToLegacy, /*cPathFile*/, .T. /*lSetup*/,, /*oSetup*/,, .T., .F.,, .T.)

	// CAMINHO DO ARQUIVO PDF
	oPrint:cPathPDF	:= cPath	

	// SELECIONA O OBJETO DE IMPRESSÃO PARA PDF.
	oPrint:setDevice(IMP_PDF)
	
	IF !lEmail
		// INDICA SE O RELATORIO SERÁ VISUALIZADO APOS IMPRESSÃO.
		oPrint:lViewPDF := .t.
	Else
		oPrint:lViewPDF := .f.
	Endif	
	
	// INDICA QUE A IMPRESSÃO SERÁ VIA SERVER.
	oPrint:lServer	:= .F.
	
	// DEFINE A ORIENTAÇÃO COMO PAISAGEM.
	oPrint:SetPortrait(.T.)	
		
	// DEFINE O TAMANHO DO PAPEL.
	oPrint:SetPaperSize(DMPAPER_A4)

	// DEFINE RESOLUÇÃO DO RELATORIO
	oPrint:SetResolution(80)		
	
	dbGoTop()

	//ProcRegua(RecCount())

	//While !SE1->(EOF())

		//If !(SE1->E1_OK == cMarca) //Caio de Castro - 30/07/12 - Somente registro marcados
			//SE1->(dbSkip())
			//Loop
		//EndIf
		
		// Nao envia novamente boleto para cliente
		/*If SE1->(FieldPos("E1_ZIMPBOL")) > 0 .AND. lEmail
			If SE1->E1_ZIMPBOL == "2"
				if !MSGYESNO("O boleto <b>"+AllTrim(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA))+"</b> já foi enviado para o cliente <b>"+AllTrim(SA1->A1_NREDUZ)+"</b> no e-mail <u>"+AllTrim(SA1->A1_EMAIL)+"</u>."+Chr(13)+Chr(10)+"Deseja enviar novamente?","Reenviar Boleto")
					SE1->(dbSkip())
					Loop	
				endif
			Endif
		Endif	
		

		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				
		// Nao imprime Se Cliente Não imprime boleto A1_BLEMAIL == 1
		If SA1->(FieldPos("A1_BLEMAIL")) > 0
			If SA1->A1_BLEMAIL != "1"
				SE1->(dbSkip())
				Loop
			Endif
		Endif	*/
		
		/*
		// Nao imprime Se Cliente nao é privado A1_TPCLIEN == 1
		If SA1->(FieldPos("A1_TPCLIEN")) > 0
			If SA1->A1_TPCLIEN != "1"
				SE1->(dbSkip())
				Loop
			Endif
		Endif				
		*/	
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		
		// Busca contatos para envio de e-mail
		aTo := BuscaCont()

		xBanco   := SA1->A1_BCO1
		aBco	 := VerBco(Alltrim(SA1->A1_BCO1))

		xAgencia := aBco[1]
		xConta   := aBco[2]

		If !Empty(xAgencia) .and. !Empty(xConta)
			xSubct   := aBco[3]
		Else
			xSubct   := MV_PAR19
		EndIf

		If !Empty(MV_PAR20) .and. Empty(xBanco)
			xBanco := MV_PAR20
		EndIf

		If !Empty(MV_PAR21) .and. Empty(xAgencia)
			xAgencia := MV_PAR21
		EndIf

		If !Empty(MV_PAR22) .and. Empty(xConta)
			xConta := MV_PAR22
		EndIf
		
		cBanco   := iif(xBanco		==nil,SE1->E1_PORTADO,xBanco)
		cAgencia := iif(xAgencia	==nil,SE1->E1_AGEDEP,xAgencia)
		cConta   := iif(xConta		==nil,SE1->E1_CONTA,xConta)
		cSubct   := iif(xSubCt		==nil,MV_PAR19,xSubCt)
		
		cBanco   := AllTrim(cBanco)+Space(TamSX3("EE_CODIGO")[1]-Len(AllTrim(cBanco)))
		cAgencia := AllTrim(cAgencia)+Space(TamSX3("EE_AGENCIA")[1]-Len(AllTrim(cAgencia)))
		cConta   := AllTrim(cConta)+Space(TamSX3("EE_CONTA")[1]-Len(AllTrim(cConta)))
		cSubct   := AllTrim(cSubct)+Space(TamSX3("EE_SUBCTA")[1]-Len(AllTrim(cSubct)))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SA6 (Bancos)    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbGoTop()
		If !DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco não localizado"),{"OK"})
			DbSelectArea("SE1")
			//dbSkip()
			//Loop
			lProblema := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona na Arq de Parametros CNAB   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SEE")
		DbSetOrder(1)
		DbGoTop()
		
		If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCt)
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não localizado banco no cadastro de parâmetros para envio"),{"OK"})
			DbSelectArea("SE1")
			//dbSkip()
			//Loop
			lProblema := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SA1 (Cliente)             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		
		// Busca contatos para envio de email
		
		

		DbSelectArea("SE1")

	 	if SEE->EE_CODIGO $"341"
			_cconta :=  StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),5)
		elseif SEE->EE_CODIGO $"033"
			_cconta := StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),Len(AllTrim(SA6->A6_NUMCON))-1)
		else
			_cconta := StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),7)
		endif

		if SEE->EE_CODIGO $ "033"
			cCtaCorrente := IIf(Empty(SEE->EE_NUMCTR),SUBSTR(SA6->A6_NUMCON,1,6),SEE->EE_NUMCTR)
		else
			cCtaCorrente := SUBSTR(SA6->A6_NUMCON,1,6)
		endif

		aDadosBanco  := {SEE->EE_CODIGO  						 ,;	//	[1]	Numero do Banco
		SUBSTR(Alltrim(SA6->A6_NOME),1,15)	,;	//	[2]	Nome do Banco
		SUBSTR(SEE->EE_AGENCIA, 1, 4)		,;	//	[3]	Agência
		cCtaCorrente	      			    ,;	//	[4]	Conta Corrente
		SUBSTR(SA6->A6_DVCTA,1,1)        	,;	//	[5]	Dígito da conta corrente
		SUBSTR(SEE->EE_CODCART,1,3)         ,;
		SUBSTR(SEE->EE_DVAGE,1,1)           ,;
		AllTrim(SA6->A6_NUMCON)}

		// Ajsute do Nome do Banco
		Do Case
			Case aDadosBanco[1] == "341"
				aDadosBanco[2] := "Banco Itaú SA"
			Case aDadosBanco[1] == "237"
				aDadosBanco[2] := "Bradesco"				
			Case aDadosBanco[1] == "001"
				aDadosBanco[2] := "Banco Brasil"
			Case aDadosBanco[1] == "104"
				aDadosBanco[2] := "Caixa Econômica"				

		EndCase		
		
		cmsg1 := " "
		cmsg2 := " "
		cmsg3 := " "
		cmsg4 := " "

		If !Empty(SEE->EE_FORMEN1)
			cmsg1 := AllTrim(&(SEE->EE_FORMEN1))
		EndIf

		If !Empty(SEE->EE_FORMEN2)
			cmsg2 := AllTrim(&(SEE->EE_FORMEN2))
		EndIf

		If !Empty(SEE->EE_FOREXT1)
			cmsg3 := AllTrim(&(SEE->EE_FOREXT1))
		EndIf

		If !Empty(SA1->A1_PRIOR)
			cmsg4 := AllTrim(cValToChar(SE1->E1_HIST))
		EndIf

		aBolText     := {   cmsg1                                                   ,; //[1] TEXTO 1
		cmsg2                                               	,; //[2] TEXTO 1
		cmsg3													,; //[3] TEXTO 1
		cmsg4													}  //[4] TEXTO 1

		/*aDadosEmp    := {	SM0->M0_NOMECOM															                 ,;	//	[1]	Nome da Empresa
		SM0->M0_ENDCOB																             ,;	//	[2]	Endereço
		AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB                ,;	//	[3]	Complemento
		"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)			                 ,;	//	[4]	CEP
		"PABX/FAX: "+SM0->M0_TEL													             ,;	//	[5]	Telefones
		"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+				              ;	   //	[6]
		Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+					   	              ;	   //	[6]
		Subs(SM0->M0_CGC,13,2)													              	 ,;	//	[6]	CGC
		"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			                  ;	//	[7]
		Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)							   }	        //	[7]	I.E*/

		if SuperGetMV("FS_ENDCOBB",.T.,.T.)		//Cobranca
			aDadosEmp := {SM0->M0_NOMECOM,;																//[1]Nome da Empresa
						SM0->M0_ENDCOB,;																//[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB,;	//[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),;				//[4]CEP
						"PABX/FAX: "+SM0->M0_TEL,;													//[5]Telefones
						"CNPJ: "+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"),;						//[6]CNPJ
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+;				//[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)}							//[7]I.E
		else									//Entrega
			aDadosEmp := {SM0->M0_NOMECOM,;																//[1]Nome da Empresa
						SM0->M0_ENDENT,;																//[2]Endereço
						AllTrim(SM0->M0_BAIRENT)+", "+AllTrim(SM0->M0_CIDENT)+", "+SM0->M0_ESTENT,;	//[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPENT,1,5)+"-"+Subs(SM0->M0_CEPENT,6,3),;				//[4]CEP
						"PABX/FAX: "+SM0->M0_TEL,;													//[5]Telefones
						"CNPJ: "+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"),;						//[6]CNPJ
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+;				//[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)}							//[7]I.E
		endif

		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)				         ,;	//	[1]	Razão Social
			AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA				         ,;	//	[2]	Código
			AllTrim(SA1->A1_END )+" - "+AllTrim(SA1->A1_BAIRRO)	         ,;	//	[3]	Endereço
			AllTrim(SA1->A1_MUN )								         ,;	//	[4]	Cidade
			SA1->A1_EST											         ,;	//	[5]	Estado
			SA1->A1_CEP											         ,;	//	[6]	CEP
			SA1->A1_CGC											         ,;	//	[7]	CGC
			SA1->A1_PESSOA										         ,;	//	[8]	PESSOA
			IIf(SA1->(FieldPos("A1_EMAIL")) > 0,SA1->A1_EMAIL,"")	}	//	[9]	E-mail
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)				        ,;	//	[1]	Razão Social
			AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA				        ,;	//	[2]	Código
			AllTrim(SA1->A1_ENDCOB)+" - "+AllTrim(SA1->A1_BAIRRO)        ,;	//	[3]	Endereço
			AllTrim(SA1->A1_MUN)						        		,;	//	[4]	Cidade
			SA1->A1_EST										        ,;	//	[5]	Estado
			SA1->A1_CEP						         				,;	//	[6]	CEP
			SA1->A1_CGC										         	,;	//	[7]	CGC
			SA1->A1_PESSOA										        ,;	//	[8]	PESSOA
			IIf(SA1->(FieldPos("A1_EMAIL")) > 0,SA1->A1_EMAIL,"") 	}	//	[9]	E-mail
		Endif

		nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		cParcel  := If(Empty(SE1->E1_PARCELA),"00",SE1->E1_PARCELA)

		If !Empty(SE1->E1_NUMBCO) // reimpressao

			If aDadosBanco[1] == "001"
				cNroDoc	:= StrZero(Val(SE1->E1_NUMBCO),5)
			ElseIf aDadosBanco[1] = "237"
				cNroDoc :=  StrZero(Val(Substr(SE1->E1_NUMBCO,1,11)),11)
			ElseIf aDadosBanco[1] == "341"
				cNroDoc := StrZero(Val(SE1->E1_NUMBCO),8)
			ElseIf aDadosBanco[1] == "033"
				cNroDoc := StrZero(Val(SE1->E1_NUMBCO),12)
			ElseIf aDadosBanco[1] == "104"
				cNroDoc := StrZero(Val(SE1->E1_NUMBCO),12)
			EndIf
			//cNroDoc := AllTrim(SE1->E1_NUMBCO)

		ElseIf !Empty(SEE->EE_FAXATU)   // a partir da 2 vez vez

			If aDadosBanco[1] == "001"
				cNroDoc	:= StrZero(Val(SEE->EE_FAXATU),5)
			ElseIf aDadosBanco[1] = "237"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),11)
			ElseIf aDadosBanco[1] == "341"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),8)
			ElseIf aDadosBanco[1] == "033"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),12)
			ElseIf aDadosBanco[1] == "104"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),12)
			EndIf

		Else
			cNroDoc	:= StrZero(1,8)//STRZERO(VAL(SE1->E1_NUM),10)	// primeira vez
		EndIf

		//cNroDoc	:= STRZERO(VAL(cNroDoc),10)

		if SEE->EE_CODIGO $ "033"
			cCodConvenio := IIf(Empty(SEE->EE_NUMCTR),SEE->EE_CODEMP,SEE->EE_NUMCTR)
		else
			cCodConvenio := SEE->EE_CODEMP
		endif

		//Monta codigo de barras
		aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9" 	    ,; //Banco
		Subs(aDadosBanco[3],1,4)			    ,;//Agencia
		aDadosBanco[4]						,;//Conta
		aDadosBanco[5]						,;//Digito da Conta
		aDadosBanco[6]						,;//Carteira
		AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;//Documento
		(SE1->E1_SALDO-nVlrAbat+SE1->E1_ACRESC-SE1->E1_DECRESC)					,;//Valor do Titulo
		&(cCmpVencto)						,;//Vencimento               // ALTERADO EM 20.09.2010 ERA E1_VENCREA, MAS TAVA DANDO ERRO ERRO DE FATOR DE VENCTO
		cCodConvenio	  						,;//Convenio
		cNroDoc  								,;//Sequencial
		Iif(SE1->E1_DECRESC > 0,.t.,.f.)		,;//Se tem desconto
		SE1->E1_PARCELA						,;//Parcela
		aDadosBanco[3])						  //Agencia Completa
		aDadosTit := {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;  //	[1]	Número do título
		E1_EMISSAO						,;  //	[2]	Data da emissão do título
		dDataBase						,;  //	[3]	Data da emissão do boleto
		&(cCmpVencto)						,;  //	[4]	Data do vencimento
		(SE1->E1_SALDO - nVlrAbat + SE1->E1_ACRESC-SE1->E1_DECRESC)			,;  //	[5]	Valor do título
		aCB_RN_NN[3]					,;  //	[6]	Nosso número (Ver fórmula para calculo)
		SE1->E1_PREFIXO						,;  //	[7]	Prefixo da NF
		SE1->E1_TIPO							}   //	[8]	Tipo do Titulo

		if !lProblema
			If xBanco == nil
				If Marked("E1_OK")
					Impres2(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,lEmail)
					lGerBol := .t.
					nX := nX + 1
				EndIf
			Else
				Impres2(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,lEmail)
				lGerBol := .t.
				nX := nX + 1
			EndIf
	
			DbSelectArea("SE1")
			SE1->(dbSkip())
			//IncProc()
			nI := nI + 1
		endif

	//EndDo

	If !lEmail
		If lGerBol
			oPrint:Preview()// Visualiza antes de imprimir
		Endif
		FreeObj(oPrint)		
	Else
		If lGerBol
			If len(aTo) > 0
				oPrint:Preview()// Visualiza antes de imprimir
				File2Printer(oPrint:CFILEPRINT, "PDF" )	
				cDirRel	:= oPrint:cPathPDF
				cArqRel := cPdfNom+".PDF"
				EnvBoleto( cDir,cArqRel,aTo)
			Else
				Help(" ",1,"JFINX100",,"Nao existe e-mail de contato cadastrado para envio.",1,0)
			Endif				
			FErase(cArqRel)	
		Endif	
		FreeObj(oPrint)
	Endif
	
	oPrint := Nil	

Return lProblema

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³                       ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Del Valle                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Modulo10(cData)
	Local L,D,P := 0
	Local B     := .F.

	L := Len(cData)  //TAMANHO DE BYTES DO CARACTER
	B := .T.
	D := 0     //DIGITO VERIFICADOR
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End

Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData,cBanc)
	Local L, D, P := 0

	If cBanc == "001"  // Banco do brasil
		L := Len(cdata)
		D := 0
		P := 10
		While L > 0
			P := P - 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 2
				P := 10
			End
			L := L - 1
		End
		D := mod(D,11)
		If D == 10
			D := "X"
		Else
			D := AllTrim(Str(D))
		End
	ElseIf cBanc == "341" .Or. cBanc == "453" .Or. cBanc == "399" .or. cBanc == "422" // Itau/Mercantil/Rural/HSBC/Safra
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))

		If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422")
			D := 1
		End
		If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453" .Or. cBanc == "399")
			D := 0
		End
		D := AllTrim(Str(D))

	ElseIf cBanc == "237"// Bradesco Calculo do Modulo11 base 7

		L := Len(cdata)
		D := 0
		P := 2

		While L > 0
			D := D + Val(SubStr(cdata, L, 1)) * P
			P := P + 1
			L := L - 1
			IF P = 8
				P:= 2
			End
		End

		If mod(D,11) = 0
			D := str(0)
		Else
			D := str(11 - (mod(D,11)))
		End

		If D = str(10)
			D := "P"
		End

		D := AllTrim(D)

	ElseIf cBanc == "389" //Mercantil
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := mod(D,11)
		If D == 1 .Or. D == 0
			D := 0
		Else
			D := 11 - D
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "479"  //BOSTON
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "409"  //UNIBANCO
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10 .or. D == 0
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "356"  //Real
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10 .or. D == 0
			D := 0
		End
		D := AllTrim(Str(D))

	ElseIf cBanc == "748"// Sicredi Calculo do Modulo11 base 7

		L := Len(cdata)
		D := 0
		P := 2

		While L > 0
			D := D + Val(SubStr(cdata, L, 1)) * P
			P := P + 1
			L := L - 1
			IF P = 8
				P:= 2
			End
		End

		If mod(D,11) = 0
			D := str(0)
		Else
			D := str(11 - (mod(D,11)))
		End

		If D = str(10)
			D := "P"
		End

		D := AllTrim(D)

	Else

		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))
		If (D == 10 .Or. D == 11)
			D := 1
		End
		D := AllTrim(Str(D))
	Endif

Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta,_NSOMA,_NDVCALC,_NmULT,_CNOSSONUM,_LGEROU,_AAREA)

	//Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,4)),4)
	//Local cNumSeq := strzero(val(cSequencial),5)
	//Local cNumSeq := strzero(val(SubStr(cNroDoc,1,7)),7)
	//Local bldocnufinal := strzero(val(cNroDoc),9)

	Local cCodEmp         := IIf("033" $ cBanco,StrZero(Val(cConvenio),7),StrZero(Val(SubStr(cConvenio,1,6)),6))
	Local cNumSeq         := strzero(val(Right(cSequencial,5)),5)
	Local blvalorfinal    := strzero((nValor*100),10)
	Local cNNumSDig       := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
	Local cNossoNum
	Local _cDigito        := ""
	Local _cSuperDig      := ""
	IF Substr(cBanco,1,3) $ '341|033'
		cCarteira := Right(cCarteira,3)
	Else
		cCarteira := Right(cCarteira,2)
	Endif

	_cParcela := NumParcela(_cParcela)

	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)

	//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
	//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
	//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

	//Campo Livre (Definir campo livre com cada banco)

	If Substr(cBanco,1,3) == "001"  // Banco do brasil

		If Len(AllTrim(cConvenio)) == 7
			//Nosso Numero sem digito
			cNNumSDig := AllTrim(cConvenio)+strzero(val(cSequencial),10)
			//Nosso Numero com digito
			cNNum := cNNumSDig

			//Nosso Numero para impressao
			cNossoNum := cNNumSDig

			//		cCpoLivre := "000000"+cNNumSDig+AllTrim(cConvenio)+strzero(val(cSequencial),10)+ cCarteira
			cCpoLivre := "000000"+cNNumSDig+cCarteira
		Else
			//Nosso Numero sem digito
			cNNumSDig := cCodEmp+cNumSeq
			//Nosso Numero com digito
			cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

			//Nosso Numero para impressao
			cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

			cCpoLivre := cNNumSDig+cAgencia + StrZero(Val(cConta),8) + cCarteira

		Endif

	ElseIf Substr(cBanco,1,3) == "033"

		cNumSeq := strzero(val(cNumSeq),11)
		//Nosso Numero sem digito
		cNNumSDig := cNumSeq
		//Nosso Numero
		cNNum := cNumSeq
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig //+"-"+ sMod11(cNNumSDig,2,9)

		cCpoLivre := "9" + cCodEmp + cNNumSDig + sMod11(cNNumSDig,2,9) + "0" + cCarteira

	Elseif Substr(cBanco,1,3) == "389" // Banco mercantil
		//Nosso Numero sem digito
		cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
		//Nosso Numero
		cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")

		//Elseif Substr(cBanco,1,3) == "237" // Banco bradesco
		//Nosso Numero sem digito
		//	cNNumSDig := cCarteira + bldocnufinal
		//Nosso Numero
		//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		//Nosso Numero para impressao
		//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )

		//	cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"
		*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Composicao do Campo Livre (25 posições)                              ³
		//³                                                                     ³
		//³20 a 23 - (04) - Agencia cedente (sem o digito), completar com zeros ³
		//³                 a esquerda se necessario	                        ³
		//³24 a 25 - (02) - Carteira                                            ³
		//³26 a 36 - (11) - Nosso Numero (sem o digito verificador)             ³
		//³37 a 43 - (07) - Conta do cedente, sem o digito verificador, complete³
		//³                 com zeros a esquerda, se necessario                 ³
		//³44 a 44 - (01) - Fixo "0"                                            ³
		//³                                                                     ³
		//³Composicao do Nosso Número                                           ³
		//³01 a 02 - (02) - Número da Carteira (SEE->EE_SUBCTA)                 ³
		//³                 06 para Sem Registro 19 para Com Registro           ³
		//³03 a 13 - (11) - Nosso Número (SEE->EE_FAXATU)                       ³
		//³04 a 14 - (01) - Dígito do Nosso Número (Modulo 11)                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Elseif Substr(cBanco,1,3) == "237" // Banco bradesco

		cNrDoc := Right(cSequencial,11)

		//Nosso Numero sem digito
		cNNumSDig := Right(cCarteira,2) + cNrDoc

		//Nosso Numero
		//cNNum := cNNumSDig + AllTrim( Str( modulo11( cNNumSDig ) ) )
		cNNum := cNNumSDig + AllTrim( modulo11( cNNumSDig ) )

		//Nosso Numero para impressao
		//cNossoNum := cCarteira + '/' + Substr(cNrDoc,1,2)+"/"+Substr(cNrDoc,3,9) + '-' + AllTrim( Str( modulo11( cNNumSDig ) ) )
		cNossoNum := Right(cCarteira,2) + '/'+ Right(cNrDoc,11) + '-' + AllTrim( modulo11( cNNumSDig,"237" ) )

		cCpoLivre := cAgencia + Right(cCarteira,2) + cNrDoc + StrZero(Val(cConta),7) + "0"

		//cCpoLivre := strzero(val(substr(cAgencia,1,3)),4) + Right(cCarteira,2) + substr(digv,3,11) + StrZero(Val(cConta),7) + "0"

	Elseif Substr(cBanco,1,3)$("341")  // Banco Itau
		//Nosso Numero sem digito
		cNNumSDig := cCarteira+strzero(val(/*cNroDoc*/cSequencial),/*6*/8)/*+ _cParcela*/
		//Nosso Numero
		cNNum := cCarteira+strzero(val(/*cNroDoc*/cSequencial),/*6*/8) /*+_cParcela*/ + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
		//Nosso Numero para impressao
		cNossoNum := cCarteira+"/"+strzero(val(/*cNroDoc*/cSequencial),/*6*/8)/*+_cParcela*/ +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )

		cCpoLivre := cNNumSDig+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"

	Elseif Substr(cBanco,1,3) == "453"  // Banco rural
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),7)
		//Nosso Numero
		cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )

		cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"

	Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC
		//Nosso Numero sem digito
		cNNumSDig := StrZero(Val(SubStr(cConvenio,1,5)),5)+strzero(val(cSequencial),5)
		//Nosso Numero
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cNNum+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+"001"

	Elseif Substr(cBanco,1,3) == "422"  // Banco Safra
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),8)
		//Nosso Numero
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10)+cNNum+"2"

	Elseif Substr(cBanco,1,3) == "479" // Banco Boston
		cNumSeq := strzero(val(cSequencial),8)
		cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),8)
		//Nosso Numero
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cCodEmp+"000000"+cNNum+"8"

	Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO
		cNumSeq := strzero(val(cSequencial),10)
		cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),10)
		//Nosso Numero
		_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//Calculo do super digito
		_cSuperDig := modulo11("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
		cNNum := "1"+cNNumSDig + _cDigito + _cSuperDig
		//Nosso Numero para impressao
		cNossoNum := "1/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig
		// O codigo fixo "04" e para a combranco som registro
		cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig

	Elseif Substr(cBanco,1,3) == "356" // Banco REAL
		cNumSeq := strzero(val(cNumSeq),13)
		//Nosso Numero sem digito
		cNNumSDig := cNumSeq
		//Nosso Numero
		cNNum := cNumSeq
		//Nosso Numero para impressao
		cNossoNum := cNNum
		cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig

	Endif

	
	//Dados para Calcular o Dig Verificador Geral
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	//Codigo de Barras Completo
	cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre
	
	//Digito Verificador do Primeiro Campo                  
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))
	
	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))
	
	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)
	
	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo

Return({cCodBarra,cLinDig,cNossoNum})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³NumParcelaº Autor ³                    º Data ³  30/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ajusta a parcela.                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function NumParcela(_cParcela)
	Local _cRet := ""
	If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
		_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
	Else
		_cRet := StrZero(Val(_cParcela),2)
	Endif
Return(_cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VldPrg1 º Autor ³                    º Data ³  03/05/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VldPrg1()

	Local _sAlias := Alias()
	Local aRegs   := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := PADR(cPerg,10)
	aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",TamSX3("E1_PREFIXO")[1],0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate Prefixo    ?","","","mv_ch2","C",TamSX3("E1_PREFIXO")[1],0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","De Numero      ?","","","mv_ch3","C",TamSX3("F2_DOC")[1],0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Ate Numero     ?","","","mv_ch4","C",TamSX3("F2_DOC")[1],0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","De Parcela     ?","","","mv_ch5","C",TamSX3("E1_PARCELA")[1],0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Ate Parcela    ?","","","mv_ch6","C",TamSX3("E1_PARCELA")[1],0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","De Portador    ?","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"08","Ate Portador   ?","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"09","De Cliente     ?","","","mv_ch9","C",TamSX3("A1_COD")[1],0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"10","Ate Cliente    ?","","","mv_cha","C",TamSX3("A1_COD")[1],0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	aAdd(aRegs,{cPerg,"11","De Loja        ?","","","mv_chb","C",TamSX3("A1_LOJA")[1],0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12","Ate Loja       ?","","","mv_chc","C",TamSX3("A1_LOJA")[1],0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"13","De Emissao     ?","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"14","Ate Emissao    ?","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"15","De Vencimento  ?","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"16","Ate Vencimento ?","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"17","Do Bordero     ?","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"18","Ate Bordero    ?","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"19","Subconta       ?","","","mv_chj","C",TamSX3("EE_SUBCTA")[1],0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"20","Banco          ?","","","mv_chk","C",TamSX3("EE_CODIGO")[1],0,0,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	aAdd(aRegs,{cPerg,"21","Agencia        ?","","","mv_chl","C",TamSX3("EE_AGENCIA")[1],0,0,"G","","MV_PAR21","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"22","Conta          ?","","","mv_chm","C",TamSX3("EE_CONTA")[1],0,0,"G","","MV_PAR22","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//aAdd(aRegs,{cPerg,"20","Env.E-mail     ?","","","mv_chk","N",1,0,2,"C","","MV_PAR20","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impres2(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,lEmail)

	LOCAL oFont8
	LOCAL oFont11c
	LOCAL oFont11
	LOCAL oFont9
	LOCAL oFont10
	LOCAL oFont13
	LOCAL oFont16n
	LOCAL oFont15
	LOCAL nI := 0

	LOCAL cMailDestino := Space(70)
	LOCAL oMailDestino
	LOCAL _oDlg

	LOCAL cMsg 	       := " "

	Local cBitmap      := IIf(File(aDadosBanco[1]+".bmp"),aDadosBanco[1]+".bmp","") // Logo da empresa
	//Local cBitmap2      := IIf(File("hylik.bmp"),"hylik.bmp","") // Logo da empresa
	//Parametros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	
	
	oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9   := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	oBrush1  := TBrush():New( , CLR_BLACK )

	oPrint:StartPage()   // Inicia uma nova página

	/******************/
	/* PRIMEIRA PARTE */
	/******************/

	nRow1 := 0

	tms_Line(oPrint,nRow1+0150,500,nRow1+0070, 500)
	tms_Line(oPrint,nRow1+0150,710,nRow1+0070, 710)

	If aDadosBanco[1] $ "237/033"
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow1+0055,100,cBitmap,0260,0060)
			//oPrint:SayBitMap(nRow1+0080,100,cBitMap,0220,0070)
		else
			oPrint:Say  (nRow1+0084,100,aDadosBanco[2],oFont10)			// [2]Nome do Banco
		endif
	Elseif aDadosBanco[1] == "001"
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow1+0065,100,cBitmap,0300,0090)
		else
			oPrint:Say  (nRow1+0084,170,aDadosBanco[2],oFont10)			// [2]Nome do Banco
		endif
	Else
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow1+0035,100,cBitmap,0400,0080)
			//oPrint:SayBitMap(nRow1+0035,100,cBitMap,0400,0110)
		else
			oPrint:Say  (nRow1+0099,220,aDadosBanco[2],oFont9)					// [2]Nome do Banco
		endif
	EndIf

	If aDadosBanco[1] $ "341/033"
		oPrint:Say  (nRow1+00080,513,aDadosBanco[1]+"-7",oFont20)		// [1]Numero do Banco
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (nRow1+0080,513,aDadosBanco[1]+"-0",oFont20)		// [1]Numero do Banco
	ElseIf aDadosBanco[1] == "237"
		oPrint:Say  (nRow1+0080,513,aDadosBanco[1]+"-2",oFont20)	// 	[1]Numero do Banco
	Else
		oPrint:Say  (nRow1+0080,513,aDadosBanco[1]+"-9",oFont20)		// [1]Numero do Banco
	Endif

	oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
	tms_Line(oPrint,nRow1+0150,100,nRow1+0150,2300)

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow1+0150,100 ,"Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow1+0150,100 ,"Cedente",oFont8)
	EndIf

	oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow1+0150,1060,"Agência/Código Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente",oFont8)
	EndIf

	// alterado em 16.09.2010 - incluido o digito da agencia para o banco do brasil
	If aDadosBanco[1] == "001"
		//oPrint:Say  (nRow1+0200,1060,Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+STR(VAL(aDadosBanco[4]),4)+"-"+aDadosBanco[5]),oFont10)
		oPrint:Say  (nRow1+0200,1060,Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]),oFont10)
	elseif aDadosBanco[1] == "033"
		oPrint:Say  (nRow1+0200,1060,Alltrim(aDadosBanco[3]+IIf(Empty(aDadosBanco[7]),"","-"+aDadosBanco[7])+"/"+aDadosBanco[4]),oFont10)
	elseif aDadosBanco[1] == "341"	
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+Alltrim(Str(Val(aDadosBanco[4])))+"-"+aDadosBanco[5],oFont10)
	else
		oPrint:Say  (nRow1+0200,1060,aDadosBanco[3]+"/"+Alltrim(Str(Val(aDadosBanco[4])))+"-"+aDadosBanco[5],oFont10)
	endif

	oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
	oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow1+0250,100 ,"Pagador",oFont8)
	Else
		oPrint:Say  (nRow1+0250,100 ,"Sacado",oFont8)
	EndIf

	oPrint:Say  (nRow1+0300,100 ,left(aDatSacado[1],30),oFont10)				//Nome

	oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
	oPrint:Say  (nRow1+0300,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

	oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
	oPrint:Say  (nRow1+0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

	oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/título"	,oFont10)
	oPrint:Say  (nRow1+0450,0100,"com as características acima."	,oFont10)
	oPrint:Say  (nRow1+0350,1060,"Data"								,oFont8)
	oPrint:Say  (nRow1+0350,1410,"Assinatura"						,oFont8)
	oPrint:Say  (nRow1+0450,1060,"Data"								,oFont8)
	oPrint:Say  (nRow1+0450,1410,"Entregador"						,oFont8)

	tms_Line(oPrint,nRow1+0250, 100,nRow1+0250,1900 )
	tms_Line(oPrint,nRow1+0350, 100,nRow1+0350,1900 )
	tms_Line(oPrint,nRow1+0450,1050,nRow1+0450,1900 )
	tms_Line(oPrint,nRow1+0550, 100,nRow1+0550,2300 )

	tms_Line(oPrint,nRow1+0550,1050,nRow1+0150,1050 )
	tms_Line(oPrint,nRow1+0550,1400,nRow1+0350,1400 )
	tms_Line(oPrint,nRow1+0350,1500,nRow1+0150,1500 )
	tms_Line(oPrint,nRow1+0550,1900,nRow1+0150,1900 )

	oPrint:Say  ( nRow1+0165,1910,"(  )Mudou-se"					,oFont11)
	oPrint:Say  ( nRow1+0205,1910,"(  )Ausente"						,oFont11)
	oPrint:Say  ( nRow1+0245,1910,"(  )Não existe nº indicado"		,oFont11)
	oPrint:Say  ( nRow1+0285,1910,"(  )Recusado"					,oFont11)
	oPrint:Say  ( nRow1+0325,1910,"(  )Não procurado"				,oFont11)
	oPrint:Say  ( nRow1+0365,1910,"(  )Endereço insuficiente"		,oFont11)
	oPrint:Say  ( nRow1+0405,1910,"(  )Desconhecido"				,oFont11)
	oPrint:Say  ( nRow1+0445,1910,"(  )Falecido"					,oFont11)
	oPrint:Say  ( nRow1+0485,1910,"(  )Outros(anotar no verso)"		,oFont11)

	/*****************/
	/* SEGUNDA PARTE */
	/*****************/

	nRow2 := 0
	/*
	//Pontilhado separador
	For nI := 100 to 2300 step 50
	oPrint:Line(0580, nI,nRow2+0580, nI+30)
	Next nI
	*/

	tms_Line(oPrint,0710,100,nRow2+0710,2300)
	tms_Line(oPrint,0710,500,nRow2+0630, 500)
	tms_Line(oPrint,0710,710,nRow2+0630, 710)

	If aDadosBanco[1] $ "237/033"
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow2+0613,100,cBitMap,0260,0060)
			//oPrint:SayBitMap(nRow2+0638,100,cBitMap,0220,0070)
		else
			oPrint:Say  (0644,100,aDadosBanco[2],oFont11)		// [2]Nome do Banco
		endif
	Elseif aDadosBanco[1] == "001"
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow2+0615,100,cBitMap,0300,0090)
		else
			oPrint:Say  (nRow2+0644,170,aDadosBanco[2],oFont11)		// [2]Nome do Banco
		endif
	Else
		if !Empty(cBitmap)
			oPrint:SayBitMap(0595,100,cBitMap,0400,0080)
			//oPrint:SayBitMap(0595,100,cBitMap,0400,0110)
		else
			oPrint:Say  (0665,220,aDadosBanco[2],oFont9)		// [2]Nome do Banco
		endif
	EndIf

	If aDadosBanco[1] $ "341/033"
		oPrint:Say  (nRow2+0640,513,aDadosBanco[1]+"-7",oFont20)	// [1]Numero do Banco
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (nRow2+0640,513,aDadosBanco[1]+"-0",oFont20)	// [1]Numero do Banco
	ElseIf aDadosBanco[1] == "237"
		oPrint:Say  (nRow2+0640,513,aDadosBanco[1]+"-2",oFont20)	// 	[1]Numero do Banco
	Else
		oPrint:Say  (nRow2+0640,513,aDadosBanco[1]+"-9",oFont20)	// [1]Numero do Banco
	EndIf

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow2+0644,1800,"Recibo do Pagador",oFont10)
	Else
		oPrint:Say  (nRow2+0644,1800,"Recibo do Sacado",oFont10)
	EndIf

	tms_Line(oPrint,nRow2+0810,100,nRow2+0810,2300 )
	tms_Line(oPrint,nRow2+0910,100,nRow2+0910,2300 )
	tms_Line(oPrint,nRow2+0980,100,nRow2+0980,2300 )
	tms_Line(oPrint,nRow2+1050,100,nRow2+1050,2300 )

	tms_Line(oPrint,nRow2+0910,500,nRow2+1050,500)
	tms_Line(oPrint,nRow2+0980,750,nRow2+1050,750)
	tms_Line(oPrint,nRow2+0910,1000,nRow2+1050,1000)
	tms_Line(oPrint,nRow2+0910,1300,nRow2+0980,1300)
	tms_Line(oPrint,nRow2+0910,1480,nRow2+1050,1480)

	oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
	If aDadosBanco[1] == "237"
		oPrint:Say  (nRow2+0725,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
	Elseif aDadosBanco[1] == "341"
		oPrint:Say  (nRow2+0755,100 ,"Até o vencimento, preferencialmente no Itaú. Após o vencimento, somente no Itaú.",oFont11)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)
	Elseif aDadosBanco[1] == "033"
		oPrint:Say  (nRow2+0725,400 ,"Pagável preferencialmente nas agências do Banco Santander.",oFont10)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)
	else
		oPrint:Say  (nRow2+0725,400 ,"Pagavél em qualquer Banco até o vencimento",oFont10)
		oPrint:Say  (nRow2+0765,400 ," ",oFont10)
	EndIf

	oPrint:Say  (nRow2+0710,1810,"Vencimento",oFont8)
	cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

	If aDadosBanco[1] == "341" .or. aDadosBanco[1] == "748" .or. aDadosBanco[1] == "237"
		oPrint:Say  (nRow2+0810,100 ,"Beneficiário",oFont8)
		oPrint:Say  (/*nRow2+0850*/nRow2+0840,100 ,alltrim(aDadosEmp[1])+"-"+alltrim(aDadosEmp[6]),oFont10) //Nome + CNPJ 0850
		oPrint:Say  (nRow2+0875,100 ,alltrim(aDadosEmp[3])+"-"+alltrim(aDadosEmp[4]),oFont8) //Endereço
	Else
		oPrint:Say  (nRow2+0810,100 ,"Cedente",oFont8)
		oPrint:Say  (nRow2+0850,100 ,alltrim(aDadosEmp[1])+"-"+alltrim(aDadosEmp[6]),oFont10) //Nome + CNPJ
	EndIf

	If aDadosBanco[1] == "341" .or. aDadosBanco[1] == "748" .or. aDadosBanco[1] == "237"
		oPrint:Say  (nRow2+0810,1810,"Agência/Código Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
	EndIf

	if aDadosBanco[1] == "033"
		cString := Alltrim(aDadosBanco[3]+IIf(Empty(aDadosBanco[7]),"","-"+aDadosBanco[7])+"/"+aDadosBanco[4])
	elseif aDadosBanco[1] == "341"	
		cString := Alltrim(aDadosBanco[3]+"/"+Alltrim(Str(Val(aDadosBanco[4])))+"-"+aDadosBanco[5])
	Else
		cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+Alltrim(Str(Val(aDadosBanco[4])))+"-"+aDadosBanco[5])
	endif

	nCol := 1810+(420-(len(cString)*22)) //374
	oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0910,100 ,"Data do Documento",oFont8)
	oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)
	//BrenoInicio
	oPrint:Say  (nRow2+0910,505 ,"Nro.Documento",oFont8)
	oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow2+0910,1005,"Espécie Doc.",oFont8)
	//oPrint:Say  (nRow2+0940,1050,aDadosTit[8],oFont10) //Tipo do Titulo
	oPrint:Say  (nRow2+0940,1050,"DM",oFont10) //Tipo do Titulo  ALTERADO EM 16.09.2010

	oPrint:Say  (nRow2+0910,1305,"Aceite",oFont8)
	oPrint:Say  (nRow2+0940,1400,"N",oFont10)

	oPrint:Say  (nRow2+0910,1485,"Data do Processamento",oFont8)
	oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao
	//BrenoFim
	oPrint:Say  (nRow2+0910,1810,"Nosso Número",oFont8)

	If aDadosBanco[1] == "001"
		cString := Alltrim(aCB_RN_NN[3])
	Else
		cString := Alltrim(aDadosTit[6])
	EndIf

	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

	oPrint:Say  (nRow2+0980,100 ,"Uso do Banco",oFont8)

	oPrint:Say  (nRow2+0980,505 ,"Carteira",oFont8)

	If aDadosBanco[1] == '237'
		oPrint:Say  (nRow2+1010,555 ,substr(aDadosBanco[6],2,2),oFont10)
	else
		oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6],oFont10)
	endif

	oPrint:Say  (nRow2+0980,755 ,"Espécie",oFont8)
	oPrint:Say  (nRow2+1010,805 ,"R$",oFont10)

	oPrint:Say  (nRow2+0980,1005,"Quantidade",oFont8)
	oPrint:Say  (nRow2+0980,1485,"Valor"     ,oFont8)

	oPrint:Say  (nRow2+0980,1810,"Valor do Documento",oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

	//oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (nRow2+1050,100 ,"Instruções de responsabilidade do BENEFICIÁRIO. Qualquer duvida sobre este boleto, contade o BENEFICIÁRIO",oFont8)
	Elseif aDadosBanco[1] == "748" .or. aDadosBanco[1] == "237"
		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8)
	Else
		oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	EndIf

	dbSelectArea("SE1")

	aValorTit 	:= Alltrim(Transform(SE1->E1_VALOR,"@E 99,999,999.99"))
	aValorAcres := Alltrim(Transform((SE1->E1_VALOR*SEE->EE_ZPMULTA)/100,"@E 99,999,999.99"))
	aValorJuros := Alltrim(Transform(SEE->EE_ZPMULTA,"@E 99,999,999.99"))
	aValorMora 	:= Alltrim(Transform((SE1->E1_VALOR*SEE->EE_ZPJUROS)/100,"@E 99,999,999.99"))

	If SEE->EE_ZPMULTA>0
		oPrint:Say  (nRow2+1090,100 ,"Após o vencimento cobrar multa de: "+aValorAcres+".",oFont10)
		oPrint:Say  (nRow2+1150,100 ,"Após o vencimento cobrar juros de: "+aValorMora+" ao dia.",oFont10)
		//oPrint:Say  (nRow2+1200,100 ,aBolText[1],oFont10)
		oPrint:Say  (nRow2+1250,100 ,aBolText[1],oFont10)
		oPrint:Say  (nRow2+1300,100 ,aBolText[2],oFont10)
		//oPrint:Say  (nRow2+1300,100 ,aBolText[4],oFont10)
		//oPrint:Say  (nRow2+1090,100 ,aBolText[1],oFont10)
		//oPrint:Say  (nRow2+1140,100 ,aBolText[2],oFont10)
		//oPrint:Say  (nRow2+1190,100 ,aBolText[3],oFont10)
	
	EndIf

	If !Empty(SE1->E1_INSTR1)
			
		oPrint:Say  (nRow2+1200,100 ,"Protestar após"+" "+SE1->E1_INSTR1+" dias."  ,oFont10)
		
	elseif SA1->A1_TEMVIS>0
		
		oPrint:Say  (nRow2+1200,100 ,"Protestar após"+" "+Alltrim(Transform(SA1->A1_TEMVIS,"@E 999"))+" dias."  ,oFont10)
		
	EndIf

	oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento",oFont8)
	oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"    ,oFont8)
	oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"         ,oFont8)
	oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"  ,oFont8)
	oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"      ,oFont8)

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow2+1400,100 ,"Pagador",oFont8)
	Else
		oPrint:Say  (nRow2+1400,100 ,"Sacado",oFont8)
	EndIf

	oPrint:Say  (nRow2+1430,400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
	oPrint:Say  (nRow2+1483,400 ,aDatSacado[3],oFont10)
	oPrint:Say  (nRow2+1536,400 ,"CEP: "+aDatSacado[6]+"    "+"Cidade:"+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

	if aDatSacado[8] = "J"
		oPrint:Say  (nRow2+1589,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
	Else
		oPrint:Say  (nRow2+1589,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
	EndIf

	If aDadosBanco[1] == "409"
		oPrint:Say  (nRow2+1589,1850,aDadosTit[6],oFont10)
	Else
		oPrint:Say  (nRow2+1589,1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont10)
	EndIf

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow2+1605,100 ,"Pagador/Avalista",oFont8)
	Else
		oPrint:Say  (nRow2+1605,100 ,"Sacador/Avalista",oFont8)
	EndIf

	oPrint:Say  (nRow2+1645,1500,"Autenticação Mecânica",oFont8)

	tms_Line(oPrint,nRow2+0710,1800,nRow2+1400,1800 )
	tms_Line(oPrint,nRow2+1120,1800,nRow2+1120,2300 )
	tms_Line(oPrint,nRow2+1190,1800,nRow2+1190,2300 )
	tms_Line(oPrint,nRow2+1260,1800,nRow2+1260,2300 )
	tms_Line(oPrint,nRow2+1330,1800,nRow2+1330,2300 )
	tms_Line(oPrint,nRow2+1400,100 ,nRow2+1400,2300 )
	tms_Line(oPrint,nRow2+1640,100 ,nRow2+1640,2300 )

	/******************/
	/* TERCEIRA PARTE */
	/******************/

	nRow3 := 0

	For nI := 100 to 2300 step 50
		oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
	Next nI

	tms_Line(oPrint,nRow3+2000,100,nRow3+2000,2300)
	tms_Line(oPrint,nRow3+2000,500,nRow3+1920, 500)
	tms_Line(oPrint,nRow3+2000,710,nRow3+1920, 710)

	If aDadosBanco[1] $ "237/033"
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow3+1905,100,cBitMap,0260,0060)
			//oPrint:SayBitMap(nRow3+1930,100,cBitMap,0220,0070)
		else
			oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont11)		// 	[2]Nome do Banco
		endif
	ElseIf aDadosBanco[1] == "001"
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow3+1909,100,cBitMap,0300,0090)
		else
			oPrint:Say(nRow3+1934,170,aDadosBanco[2],oFont11)
		endif
	Else
		if !Empty(cBitmap)
			oPrint:SayBitMap(nRow3+1885,100,cBitMap,0400,0080)
			//oPrint:SayBitMap(nRow3+1885,100,cBitMap,0400,0110)
		else
			oPrint:Say  (nRow3+1940,220,aDadosBanco[2],oFont9)		// 	[2]Nome do Banco
		endif
	EndIf

	If aDadosBanco[1] $ "341/033"

		oPrint:Say  (nRow3+1930,513,aDadosBanco[1]+"-7",oFont20)	// 	[1]Numero do Banco
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (nRow3+1930,513,aDadosBanco[1]+"-0",oFont20)	// 	[1]Numero do Banco
	ElseIf aDadosBanco[1] == "237"

		oPrint:Say  (nRow3+1930,513,aDadosBanco[1]+"-2",oFont20)	// 	[1]Numero do Banco
	Else
		oPrint:Say  (nRow3+1930,513,aDadosBanco[1]+"-9",oFont20)	// 	[1]Numero do Banco
	EndIf

	oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15)			//		Linha Digitavel do Codigo de Barras

	tms_Line(oPrint,nRow3+2100,100,nRow3+2100,2300 )
	tms_Line(oPrint,nRow3+2200,100,nRow3+2200,2300 )
	tms_Line(oPrint,nRow3+2270,100,nRow3+2270,2300 )
	tms_Line(oPrint,nRow3+2340,100,nRow3+2340,2300 )

	tms_Line(oPrint,nRow3+2200,500 ,nRow3+2340,500 )
	tms_Line(oPrint,nRow3+2270,750 ,nRow3+2340,750 )
	tms_Line(oPrint,nRow3+2200,1000,nRow3+2340,1000)
	tms_Line(oPrint,nRow3+2200,1300,nRow3+2270,1300)
	tms_Line(oPrint,nRow3+2200,1480,nRow3+2340,1480)

	oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
	If aDadosBanco[1] == "237"
		oPrint:Say  (nRow3+2015,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont10)
	Elseif aDadosBanco[1] == "341"
		oPrint:Say  (nRow3+2035,100 ,"Até o vencimento, preferencialmente no Itaú. Após o vencimento, somente no Itaú.",oFont10)
		oPrint:Say  (nRow3+2055,400 ," ",oFont10)
	Elseif aDadosBanco[1] == "033"
		oPrint:Say  (nRow3+2015,400 ,"Pagável preferencialmente nas agências do Banco Santander.",oFont10)
		oPrint:Say  (nRow3+2055,400 ," ",oFont10)
	else
		oPrint:Say  (nRow3+2015,400 ,"Pagavél em qualquer Banco até o vencimento",oFont10)
		oPrint:Say  (nRow3+2055,400 ," ",oFont10)
	EndIf
	//oPrint:Say  (nRow3+2015,400 ,"Pagavél em qualquer Banco até o vencimento",oFont10)
	oPrint:Say  (nRow3+2055,400 ," ",oFont10)

	oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
	cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
	nCol	 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)
	/*
	oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
	oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1],oFont10) //Nome + CNPJ
	*/
	If aDadosBanco[1] == "341" .or. aDadosBanco[1] == "748" .or. aDadosBanco[1] == "237"
		oPrint:Say  (nRow3+2100,100 ,"Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
	EndIf

	oPrint:Say  (/*nRow3+2140*/nRow3+2130,100 ,alltrim(aDadosEmp[1])+"-"+alltrim(aDadosEmp[6]),oFont10) //Nome + CNPJ
	oPrint:Say  (nRow3+2165,100 ,alltrim(aDadosEmp[3])+"-"+alltrim(aDadosEmp[4]),oFont8) //Endereço

	If aDadosBanco[1] == "341" .or. aDadosBanco[1] == "748" .or. aDadosBanco[1] == "237"
		oPrint:Say  (nRow3+2100,1810,"Agência/Código Beneficiário",oFont8)
	Else
		oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
	EndIf

	if aDadosBanco[1] == "033"
		cString := Alltrim(aDadosBanco[3]+IIf(Empty(aDadosBanco[7]),"","-"+aDadosBanco[7])+"/"+aDadosBanco[4])
	Elseif aDadosBanco[1] == "341"	
		cString := Alltrim(aDadosBanco[3]+"/"+Alltrim(Str(Val(aDadosBanco[4])))+"-"+aDadosBanco[5])
	else
		cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+Alltrim(Str(Val(aDadosBanco[4])))+"-"+aDadosBanco[5])
	endif

	nCol 	 := 1810+(420-(len(cString)*22))
	oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

	oPrint:Say  (nRow3+2200,100 ,"Data do Documento",oFont8)
	oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

	oPrint:Say  (nRow3+2200,505 ,"Nro.Documento",oFont8)
	oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

	oPrint:Say  (nRow3+2200,1005,"Espécie Doc.",oFont8)
	oPrint:Say  (nRow3+2230,1050,"DM",oFont10) //Tipo do Titulo  -- alterado em 16.09.2010

	oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
	oPrint:Say  (nRow3+2230,1400,"N"     ,oFont10)

	oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
	oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

	oPrint:Say  (nRow3+2200,1810,"Nosso Número",oFont8)

	If aDadosBanco[1] == "001"
		cString := Alltrim(aCB_RN_NN[3])
	Else
		cString := Alltrim(aDadosTit[6])
	EndIf

	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

	oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

	oPrint:Say  (nRow3+2270,505 ,"Carteira",oFont8)

	If aDadosBanco[1] == '237'
		oPrint:Say  (nRow2+2300,555 ,substr(aDadosBanco[6],2,2),oFont10)
	else
		oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6],oFont10)
	endif

	oPrint:Say  (nRow3+2270,755 ,"Espécie",oFont8)
	oPrint:Say  (nRow3+2300,805 ,"R$"     ,oFont10)

	oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
	oPrint:Say  (nRow3+2270,1485,"Valor"     ,oFont8)

	oPrint:Say  (nRow3+2270,1810,"Valor do Documento",oFont8)
	cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
	nCol 	 := 1810+(374-(len(cString)*22))
	oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

	//oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	If aDadosBanco[1] == "341"
		oPrint:Say  (nRow2+2340,100 ,"Instruções de responsabilidade do BENEFICIÁRIO. Qualquer duvida sobre este boleto, contade o BENEFICIÁRIO",oFont8)
	Elseif aDadosBanco[1] == "748" .or. aDadosBanco[1] == "237"
		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do beneficiário)",oFont8)
	Else
		oPrint:Say  (nRow3+2340,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
	Endif

	dbSelectArea("SE1")

	aValorTit := Alltrim(Transform(SE1->E1_VALOR,"@E 99,999,999.99"))
	aValorAcres := Alltrim(Transform((SE1->E1_VALOR*SEE->EE_ZPMULTA)/100,"@E 99,999,999.99"))
	aValorJuros := Alltrim(Transform(SEE->EE_ZPMULTA,"@E 99,999,999.99"))
	aValorMora := Alltrim(Transform((SE1->E1_VALOR*SEE->EE_ZPJUROS)/100,"@E 99,999,999.99"))

	If SEE->EE_ZPMULTA>0
		oPrint:Say  (nRow2+2390,100 ,"Após o vencimento cobrar multa de: "+aValorAcres+".",oFont10)
		oPrint:Say  (nRow2+2450,100 ,"Após o vencimento cobrar juros de: "+aValorMora+" ao dia.",oFont10)
		//oPrint:Say  (nRow2+2500,100 ,aBolText[1] /*/+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       /*/,oFont10)
		oPrint:Say  (nRow2+2550,100 ,aBolText[1] /*/+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  /*/,oFont10)
		oPrint:Say  (nRow2+2600,100 ,aBolText[2],oFont10)
		//oPrint:Say  (nRow2+2600,100 ,aBolText[4],oFont10)
		//oPrint:Say  (nRow2+2390,100 ,aBolText[1] /*/+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       /*/,oFont10)
		//oPrint:Say  (nRow2+2440,100 ,aBolText[2] /*/+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  /*/,oFont10)
		//oPrint:Say  (nRow2+2490,100 ,aBolText[3],oFont10)
	
	EndIf

	If !Empty(SE1->E1_INSTR1)
			
		oPrint:Say  (nRow2+2500,100 ,"Protestar após"+" "+SE1->E1_INSTR1+" dias."  ,oFont10)
		
	elseif SA1->A1_TEMVIS>0
		
		oPrint:Say  (nRow2+2500,100 ,"Protestar após"+" "+Alltrim(Transform(SA1->A1_TEMVIS,"@E 999"))+" dias."  ,oFont10)
		
	EndIf


	oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento",oFont8)
	oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"    ,oFont8)
	oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"         ,oFont8)
	oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"  ,oFont8)
	oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"      ,oFont8)

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow3+2690,100 ,"Pagador",oFont8)
	Else
		oPrint:Say  (nRow3+2690,100 ,"Sacado",oFont8)
	EndIf

	oPrint:Say  (nRow3+2700,400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont9)

	if aDatSacado[8] = "J"
		oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont9) // CGC
	Else
		oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont9) 	// CPF
	EndIf

	oPrint:Say  (nRow3+2753,400 ,aDatSacado[3],oFont9)
	oPrint:Say  (nRow3+2806,400 ,"CEP: "+aDatSacado[6]+"    "+"Cidade: "+aDatSacado[4]+" - "+aDatSacado[5],oFont9) // CEP+Cidade+Estado

	If aDadosBanco[1] == "409"
		oPrint:Say  (nRow3+2806,1750,aDadosTit[6] ,oFont9)
	Else
		oPrint:Say  (nRow3+2806,1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont9)
	EndIf

	If aDadosBanco[1] == "237" .or. aDadosBanco[1] == "341"
		oPrint:Say  (nRow3+2815,100 ,"Pagador/Avalista",oFont8)
	Else
		oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista",oFont8)
	EndIf

	oPrint:Say  (nRow3+2855,1500,"Autenticação Mecânica - Ficha de Compensação",oFont8)

	tms_Line(oPrint,nRow3+2000,1800,nRow3+2690,1800)
	tms_Line(oPrint,nRow3+2410,1800,nRow3+2410,2300)
	tms_Line(oPrint,nRow3+2480,1800,nRow3+2480,2300)
	tms_Line(oPrint,nRow3+2550,1800,nRow3+2550,2300)
	tms_Line(oPrint,nRow3+2620,1800,nRow3+2620,2300)
	tms_Line(oPrint,nRow3+2690,100 ,nRow3+2690,2300)
	tms_Line(oPrint,nRow3+2850,100 ,nRow3+2850,2300)

	//MSBAR("INT25"  ,24.6,1.0, aCB_RN_NN[1] ,oPrint,.F.,,,,1.3,1.0,,,.F.)
	oPrint:FWMsBar("INT25" , 65, 02  , aCB_RN_NN[1], oPrint, .F.  ,     , .T. , 0.025 , 1.5   , .F.   , "Arial", NIL, .F., 2, 2, .F.)
		
	//MSBAR3("INT25", 24.3, 1, aCB_RN_NN[1], oPrint, .F., Nil, Nil, 0.025, 1.5, Nil, Nil, "A", .F.)

	If Empty(Alltrim(SE1->E1_NUMBCO)) //Caio de Castro - 10/08 - Somente atualiza faixa se não for reimpressão de boleto
		DbSelectArea("SEE")
		RecLock("SEE",.f.)
		SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU) + 1,10)  //INCREMENTA P/ TODOS OS BANCOS
		DbUnlock()
	EndIf

	DbSelectArea("SE1")

	If aDadosBanco[1] == "001"
		cNumBco := SubStr(Alltrim(aCB_RN_NN[3]),1,11)+SubStr(Alltrim(aCB_RN_NN[3]),13,1) //SubStr(Alltrim(aCB_RN_NN[3]),7,5)//Right(Alltrim(aCB_RN_NN[3]),10)
	ElseIf aDadosBanco[1] == "237"
		cNumBco := SubStr(Alltrim(aCB_RN_NN[3]),4)   //Elton
	ElseIf aDadosBanco[1] == "341"
		cNumBco := SubStr(aCB_RN_NN[3],5,8)
	ElseIf aDadosBanco[1] == "033"
		cNumBco := Right(aCB_RN_NN[3],12)
	EndIf
	
	cNumBco := StrTran(cNumBco,"\","")
	cNumBco := StrTran(cNumBco,"/","")
	cNumBco := StrTran(cNumBco,"-","")
	cNumBco := StrTran(cNumBco,"_","")

	RecLock("SE1",.f.)
	If Empty(Alltrim(SE1->E1_NUMBCO))
		SE1->E1_NUMBCO 	:= cNumBco
	Endif

	SE1->E1_PORTADO := aDadosBanco[1]	//Banco
	SE1->E1_AGEDEP  := cAgencia			//Agencia
	SE1->E1_CONTA   := cConta		  	//Conta

	If SE1->(FieldPos("E1_ZIMPBOL")) > 0
		SE1->E1_ZIMPBOL :=  IIf(lEmail,"2","1")		//1-Boleto impresso 2-Boleto por email
	Endif	

	DbUnlock()

	oPrint:EndPage() // Finaliza a página

Return Nil

////////////////////////////////////////////////////////////////////////////////

Static Function tms_Line(oPrint,n1,n2,n3,n4)

if n1 = n3
   //oPrint:FillRect( {n1,n2,n3+2,n4}, oBrush1)
   oPrint:FillRect( {n1-17,n2,n3-15,n4}, oBrush1)
Elseif n2 = n4
   //oPrint:FillRect( {n1,n2,n3,n4}, oBrush1)
   oPrint:FillRect( {n1-17,n2,n3-17,n4}, oBrush1)
endif


Return (NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ sMod11   ³ Autor ³ Wanderley Monteiro    ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calcula o digito verificador com Modelo 11                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function sMod11(cStr,nPeso1,nPeso2) // módulo 11, com pesos nPeso1 (inicial) a nPeso2 (final), que
	local nTot := 0                     // serão utilizados no multiplicador dos dígitos, apanhados da
	local nMul := nPeso1                 // direita para a esquerda. Tal multiplicador será reciclado e
	local i                              // voltará para nPeso1, quando o limite (nPeso2) for atingido.

	for i := Len(cStr) to 1 step -1
		nTot += Val(SubStr(cStr,i,1)) * nMul
		nMul := if(nMul=nPeso2, nPeso1, nMul+1)
	next
return if(nTot%11 < 2, "0", Str(11-(nTot%11),1))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VerBco   ³ Autor ³                       ³ Data ³  Abr/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica informacoes de banco.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VerBco(cBanco)

	Local cAg		:= " "
	Local cCta		:= " "
	Local cSubCta 	:= " "
	Local cQuery	:= " "

	//Se existir mais de uma conta do mesmo banco que seja com registro, sera considerado o primeiro registro
	cQuery := "SELECT EE_AGENCIA AGENCIA,EE_CONTA CONTA,EE_SUBCTA SUBCTA "
	cQuery += " FROM "+RetSqlName("SEE")+" SEE "
	cQuery += " WHERE EE_FILIAL = '"+xFilial("SEE")+"' "
	cQuery += " AND EE_CODIGO = '"+cBanco+"' "
	cQuery += " AND SEE.D_E_L_E_T_ <> '*' "

	U_MONTAQRY(cQuery,"TRB")

	If Select("TRB") > 0
		cAg	:=  TRB->AGENCIA
		cCta	:= TRB->CONTA
		cSubCta := TRB->SUBCTA

		DbSelectArea("TRB")
		("TRB")->(DbCloseArea())
	EndIf

Return({cAg,cCta,cSubCta})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MontaQry  ³ Autor ³       TOTVS           ³ Data ³ Abr/2009  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³Cria tabela temporaria com Select via query.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1: Varivel com a query desejada.                        ³±±
±±³          ³ ExpA2: Nome da tabela temporaria a ser criada.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Numeros de registros retornados pela Select.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Exemplo da chamada da funcao

cQuery := "SELECT COUNT(*) "
cQuery += " FROM "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += " WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += " SA1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY A1_COD DESC "

U_MONTAQRY(cQuery,"TRB")
*/
User Function MontaQry(cSql,cAliasTRB)

	Local nCnt := 0
	Local bSql := ChangeQuery( cSql )

	// Verificar se o Alias ja esta aberto.
	If Select(cAliasTRB) > 0

		DbSelectArea(cAliasTRB)
		//DbCloseArea(cAliasTRB)
		(cAliasTRB) -> (DbCloseArea())

	EndIf

	//Grava o script da query no system
	//MemoWrit(Alltrim(FunName())+Alltrim(cAliasTRB)+".SQL",cSql)

	DbUseArea( .T., "TOPCONN", TcGenQry(,,bSql), cAliasTRB, .T., .F. )
	DbSelectArea(cAliasTRB)
	DbGoTop()

	// Conta quantos sao os registros retornados pelo Select.
	DbEval( {|| nCnt++ })

	DbSelectArea(cAliasTRB)
	DbGoTop()

Return(nCnt)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ EnvBoleto() ³ Autor ³ Alex T Souza		 ³ Data ³21/05r/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±                     
±±³Descricao ³Enviar Boleto por e-mail									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico . 		                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvBoleto(cDir,cArq,aTo)
Local lOk 		:= .t.
Local cEmail	:= ""
Local nXi		:= 0
	
	For nXi := 1 to len(aTo)
		cEmail += aTo[nXi]
		
		If nXi < len(aTo)
			cEmail += ";"
		Endif
	Next		
		

	ConOut("******************************************************************************")
	ConOut("* Vai enviar e-mail ")
	ConOut("******************************************************************************")

	If File(cDir+cArq)	
	
		If CpyT2S( cDir+cArq, "\system\", .F. )
			Sleep(5000)
			lOk := OkProc(cEMail,"\system\"+cArq)
			Sleep(5000)
			fErase("\system\"+cArq)
		Endif	
	Else
		ConOut("******************************************************************************")
		ConOut("* Nao encontrou o arquivo ")
		ConOut("******************************************************************************")		
	Endif	

Return  lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ OKPROC   ºAutor  ³ Alex T. Souza  		º Data ³ 21/05/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍ¼ÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao Secundaria de Processamento E-mail.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkProc(cEMail,cArq)
Local cMailDestino := ""
Local lOk := .t.

	if Alltrim(cEMail) <> ""
		cAssunto 	 := "Boleto da Empresa "+SM0->M0_FILIAL
  		
		cTexto := "<html>"
		cTexto += "<body>"
		cTexto += '<p align="center">'
		cTexto += '<b>'
		cTexto += '<font color="#000080" face="Arial" size="4">'
		cTexto += "Segue Boleto." 
		cTexto += '</font>'
		cTexto += '</b>'
		cTexto += '</p>'
		cTexto += '<hr>'

		cTexto += '<font face="Arial">'
		cTexto += '<p align="justify">Prezado Cliente,</p>'
		cTexto += '<p></p>
		cTexto += '<p>Você está recebendo em anexo o boleto da empresa '+SM0->M0_FILIAL+'. </p>
		cTexto += '<p></p>				
		cTexto += '<p></p>
		cTexto += '<p></p>		
		cTexto += '<p align="LEFT"><b>'
		cTexto += '<p>Dúvidas? Fale com:</p><a href="mailto:'+GetMV("FS_MAILTO")+'">'+GetMV("FS_MAILTO")+'</a>'
		cTexto += '<br>'
		//cTexto += '<a href="mailto:'+GetMV("FS_MAILTO")+'">'+GetMV("FS_MAILTO")
		cTexto += '<p>Atenciosamente,</p>
		cTexto += '<br>'
		cTexto += '<p>Departamento de Contas a Receber.</p>			
		cTexto += '</b></p>'
		cTexto += '</body>'
		cTexto += '</html>'
		
		cMailDestino := Alltrim(cEMail) 
                                 
	  	lOk := MailFunc(cTexto,cAssunto,cArq,cEMail)
	endif

Return lOk

Static Function MailFunc(cPage,cSubject,cAnexos,cTo)
Local cServer   := AllTrim(GetNewPar("MV_RELSERV"," "))
Local cAccount  := AllTrim(GetNewPar("MV_RELFROM"," "))
Local cPassword := AllTrim(GetNewPar("MV_RELPSW" ," "))
Local cCC		:= GetMV("FS_MAILTO")
Local lSmtpAuth := GetMv("MV_RELAUTH",,.F.)
Local cFrom     := cAccount
Local lOk       := .T.
Local cErro		:= ""													//Retorno de erro do envio de mensagem

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lOk
If ( lSmtpAuth )
	lAutOk := MailAuth(cAccount,cPassword)
Else
	lAutOk := .T.
EndIf
If lOk .and. lAutOk
	SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT Alltrim(cSubject) BODY cPage ATTACHMENT cAnexos Result lOk
	If lOk       
		ConOut("******************************************************************************")
		ConOut("* Enviou email " )
		ConOut("******************************************************************************")	
	Else
		GET MAIL ERROR cErro
		ConOut("******************************************************************************")
		ConOut("* Erro no envio do email ")
		ConOut("******************************************************************************")	
	EndIf
Else
	//GET MAIL ERROR cErro
	ConOut("******************************************************************************")
	ConOut("* Erro no envio do email - Nao foi autorizado o envio pela funcao MailAuth ")
	ConOut("******************************************************************************")	
EndIf
DISCONNECT SMTP SERVER

Return lOK

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BuscaCont   ºAutor  ³ Alex T. Souza     º Data ³ 21/05/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍ¼ÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Busca dados do contato.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaCont()
Local aTo 		:= {}
Local cChave	:= ""
 
 	SU5->(DbSetOrder(1))
	AC8->(DbSetOrder(2))

	cChave :=  xFilial("AC8")+ "SA1" + xFilial("SA1") + SA1->A1_COD + SA1->A1_LOJA

	AC8->(DbSeek(cChave))
	     
	While  AC8->(!Eof() ) .And. Rtrim(AC8->(AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT )) == cChave 
    	If SU5->(DbSeek(xFilial("SU5") + AC8->AC8_CODCON)) 
    		If !Empty(SU5->U5_EMAIL)
    			If ascan(aTo,{|cEle|  cEle == Alltrim(SU5->U5_EMAIL) }) <= 0
    				aadd(aTo,Alltrim(SU5->U5_EMAIL))
    			Endif	
    		Endif	 		
    	EndIf
	  	AC8->(DbSkip())
	End

	if SA1->(FieldPos("A1_EMAIL")) > 0
		If !Empty(Alltrim(SA1->A1_EMAIL))
			If ascan(aTo,{|cEle|  cEle == Alltrim(SA1->A1_EMAIL) }) <= 0
				aadd(aTo,Alltrim(SA1->A1_EMAIL))
			Endif	
		Endif
	endif
	
Return aTo	

Static Function RF02B062(xBanco,xAgencia,xConta,xSubCt, lEmail)

	Local cDir			:= Alltrim(GetTempPath()) //Busca Pasta temporaria do Usuario
	Local cPath 		:= Replace( cDir, "\\", "\" )
	Local cRutaSmr 		:=  Alltrim(GetTempPath()) 
	Local cPDFNom		:= "BOLETO_"+Dtos(MSDate())+StrTran(Time(),":","")
	Local oPrint
	Local nX 			:= 0
	Local cNroDoc 	   	:=  " "
	Local aDadosEmp
	Local lGerBol		:= .f.

	Local aDadosTit
	Local aDadosBanco
	Local aDatSacado
	Local aBolText

	Local nI           := 1
	Local aCB_RN_NN    := {}
	Local nVlrAbat	   := 0
	Local nDvnn 	   := 0
	Local aTo		   := {}
	
	Local lProblema		:= .F.
	Local cLib

	Private cBanco   	:= ""
	Private cAgencia 	:= ""
	Private cConta   	:= ""
	Private aCabec  	:= {}
	
	Default lEmail		:= .f.
	Default	xBanco		:= ""
	Default xAgencia	:= ""
	Default xConta		:= ""
	Default xSubCt		:= ""

	/*IF ISSRVUNIX()
		cPath := Replace( cPath, "\", "/" )
	End If*/
	
	if GetRemoteType(@cLib) == 2
		cPath := StrTran(cPath,"\","/")
	endif
	
	lAdjustToLegacy 	:= .t. // Inibe legado de resolução com a TMSPrinter
	oPrint 				:= FWMSPrinter():New(cPdfNom, IMP_PDF, lAdjustToLegacy, /*cPathFile*/, .T. /*lSetup*/,, /*oSetup*/,, .T., .F.,, .T.)

	// CAMINHO DO ARQUIVO PDF
	oPrint:cPathPDF	:= cPath	

	// SELECIONA O OBJETO DE IMPRESSÃO PARA PDF.
	oPrint:setDevice(IMP_PDF)
	
	IF !lEmail
		// INDICA SE O RELATORIO SERÁ VISUALIZADO APOS IMPRESSÃO.
		oPrint:lViewPDF := .f.
	Else
		oPrint:lViewPDF := .f.
	Endif	
	
	// INDICA QUE A IMPRESSÃO SERÁ VIA SERVER.
	oPrint:lServer	:= .F.
	
	// DEFINE A ORIENTAÇÃO COMO PAISAGEM.
	oPrint:SetPortrait(.T.)	
		
	// DEFINE O TAMANHO DO PAPEL.
	oPrint:SetPaperSize(DMPAPER_A4)

	// DEFINE RESOLUÇÃO DO RELATORIO
	oPrint:SetResolution(80)		
	
	dbGoTop()

	ProcRegua(RecCount())

	While !SE1->(EOF())

		If !(SE1->E1_OK == cMarca) //Caio de Castro - 30/07/12 - Somente registro marcados
			SE1->(dbSkip())
			Loop
		EndIf
		
		// Nao envia novamente boleto para cliente
		If SE1->(FieldPos("E1_ZIMPBOL")) > 0 .AND. lEmail
			If SE1->E1_ZIMPBOL == "2"
				if !MSGYESNO("O boleto <b>"+AllTrim(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA))+"</b> já foi enviado para o cliente <b>"+AllTrim(SA1->A1_NREDUZ)+"</b> no e-mail <u>"+AllTrim(SA1->A1_EMAIL)+"</u>."+Chr(13)+Chr(10)+"Deseja enviar novamente?","Reenviar Boleto")
					SE1->(dbSkip())
					Loop	
				endif
			Endif
		Endif	
		

		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				
		// Nao imprime Se Cliente Não imprime boleto A1_BLEMAIL == 1
		If SA1->(FieldPos("A1_BLEMAIL")) > 0
			If SA1->A1_BLEMAIL != "1"
				SE1->(dbSkip())
				Loop
			Endif
		Endif	
		
		/*
		// Nao imprime Se Cliente nao é privado A1_TPCLIEN == 1
		If SA1->(FieldPos("A1_TPCLIEN")) > 0
			If SA1->A1_TPCLIEN != "1"
				SE1->(dbSkip())
				Loop
			Endif
		Endif				
		*/	
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		
		// Busca contatos para envio de e-mail
		aTo := BuscaCont()

		xBanco   := SA1->A1_BCO1
		aBco	 := VerBco(Alltrim(SA1->A1_BCO1))

		xAgencia := aBco[1]
		xConta   := aBco[2]

		If !Empty(xAgencia) .and. !Empty(xConta)
			xSubct   := aBco[3]
		Else
			xSubct   := MV_PAR19
		EndIf

		If !Empty(MV_PAR20) .and. Empty(xBanco)
			xBanco := MV_PAR20
		EndIf

		If !Empty(MV_PAR21) .and. Empty(xAgencia)
			xAgencia := MV_PAR21
		EndIf

		If !Empty(MV_PAR22) .and. Empty(xConta)
			xConta := MV_PAR22
		EndIf
		
		cBanco   := iif(xBanco		==nil,SE1->E1_PORTADO,xBanco)
		cAgencia := iif(xAgencia	==nil,SE1->E1_AGEDEP,xAgencia)
		cConta   := iif(xConta		==nil,SE1->E1_CONTA,xConta)
		cSubct   := iif(xSubCt		==nil,MV_PAR19,xSubCt)
		
		cBanco   := AllTrim(cBanco)+Space(TamSX3("EE_CODIGO")[1]-Len(AllTrim(cBanco)))
		cAgencia := AllTrim(cAgencia)+Space(TamSX3("EE_AGENCIA")[1]-Len(AllTrim(cAgencia)))
		cConta   := AllTrim(cConta)+Space(TamSX3("EE_CONTA")[1]-Len(AllTrim(cConta)))
		cSubct   := AllTrim(cSubct)+Space(TamSX3("EE_SUBCTA")[1]-Len(AllTrim(cSubct)))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SA6 (Bancos)    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbGoTop()
		If !DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco não localizado"),{"OK"})
			DbSelectArea("SE1")
			//dbSkip()
			//Loop
			lProblema := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona na Arq de Parametros CNAB   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SEE")
		DbSetOrder(1)
		DbGoTop()
		
		If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCt)
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não localizado banco no cadastro de parâmetros para envio"),{"OK"})
			DbSelectArea("SE1")
			//dbSkip()
			//Loop
			lProblema := .T.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona o SA1 (Cliente)             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		
		// Busca contatos para envio de email
		
		

		DbSelectArea("SE1")

	 	if SEE->EE_CODIGO $"341"
			_cconta :=  StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),5)
		elseif SEE->EE_CODIGO $"033"
			_cconta := StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),Len(AllTrim(SA6->A6_NUMCON))-1)
		else
			_cconta := StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),7)
		endif

		if SEE->EE_CODIGO $ "033"
			cCtaCorrente := IIf(Empty(SEE->EE_NUMCTR),SUBSTR(SA6->A6_NUMCON,1,6),SEE->EE_NUMCTR)
		else
			cCtaCorrente := SUBSTR(SA6->A6_NUMCON,1,6)
		endif

		aDadosBanco  := {SEE->EE_CODIGO  						 ,;	//	[1]	Numero do Banco
		SUBSTR(Alltrim(SA6->A6_NOME),1,15)	,;	//	[2]	Nome do Banco
		SUBSTR(SEE->EE_AGENCIA, 1, 4)		,;	//	[3]	Agência
		cCtaCorrente	      			    ,;	//	[4]	Conta Corrente
		SUBSTR(SA6->A6_DVCTA,1,1)        	,;	//	[5]	Dígito da conta corrente
		SUBSTR(SEE->EE_CODCART,1,3)         ,;
		SUBSTR(SEE->EE_DVAGE,1,1)           ,;
		AllTrim(SA6->A6_NUMCON)}

		// Ajsute do Nome do Banco
		Do Case
			Case aDadosBanco[1] == "341"
				aDadosBanco[2] := "Banco Itaú SA"
			Case aDadosBanco[1] == "237"
				aDadosBanco[2] := "Bradesco"				
			Case aDadosBanco[1] == "001"
				aDadosBanco[2] := "Banco Brasil"
			Case aDadosBanco[1] == "104"
				aDadosBanco[2] := "Caixa Econômica"				

		EndCase		
		
		cmsg1 := " "
		cmsg2 := " "
		cmsg3 := " "
		cmsg4 := " "

		If !Empty(SEE->EE_FORMEN1)
			cmsg1 := AllTrim(&(SEE->EE_FORMEN1))
		EndIf

		If !Empty(SEE->EE_FORMEN2)
			cmsg2 := AllTrim(&(SEE->EE_FORMEN2))
		EndIf

		If !Empty(SEE->EE_FOREXT1)
			cmsg3 := AllTrim(&(SEE->EE_FOREXT1))
		EndIf

		If !Empty(SA1->A1_PRIOR)
			cmsg4 := AllTrim(cValToChar(SE1->E1_HIST))
		EndIf

		aBolText     := {   cmsg1                                                   ,; //[1] TEXTO 1
		cmsg2                                               	,; //[2] TEXTO 1
		cmsg3													,; //[3] TEXTO 1
		cmsg4													}  //[4] TEXTO 1

		aDadosEmp    := {	SM0->M0_NOMECOM															                 ,;	//	[1]	Nome da Empresa
		SM0->M0_ENDCOB																             ,;	//	[2]	Endereço
		AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB                ,;	//	[3]	Complemento
		"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)			                 ,;	//	[4]	CEP
		"PABX/FAX: "+SM0->M0_TEL													             ,;	//	[5]	Telefones
		"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+				              ;	   //	[6]
		Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+					   	              ;	   //	[6]
		Subs(SM0->M0_CGC,13,2)													              	 ,;	//	[6]	CGC
		"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+			                  ;	//	[7]
		Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)							   }	        //	[7]	I.E

		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)				         ,;	//	[1]	Razão Social
			AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA				         ,;	//	[2]	Código
			AllTrim(SA1->A1_END )+" - "+AllTrim(SA1->A1_BAIRRO)	         ,;	//	[3]	Endereço
			AllTrim(SA1->A1_MUN )								         ,;	//	[4]	Cidade
			SA1->A1_EST											         ,;	//	[5]	Estado
			SA1->A1_CEP											         ,;	//	[6]	CEP
			SA1->A1_CGC											         ,;	//	[7]	CGC
			SA1->A1_PESSOA										         ,;	//	[8]	PESSOA
			SA1->A1_EMAIL								          		}	//	[9]	E-mail
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)				        ,;	//	[1]	Razão Social
			AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA				        ,;	//	[2]	Código
			AllTrim(SA1->A1_ENDCOB)+" - "+AllTrim(SA1->A1_BAIRRO)        ,;	//	[3]	Endereço
			AllTrim(SA1->A1_MUN)						        		,;	//	[4]	Cidade
			SA1->A1_EST										        ,;	//	[5]	Estado
			SA1->A1_CEP						         				,;	//	[6]	CEP
			SA1->A1_CGC										         	,;	//	[7]	CGC
			SA1->A1_PESSOA										        ,;	//	[8]	PESSOA
			SA1->A1_EMAIL									         	}	//	[9]	E-mail
		Endif

		nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		cParcel  := If(Empty(SE1->E1_PARCELA),"00",SE1->E1_PARCELA)

		If !Empty(SE1->E1_NUMBCO) // reimpressao

			If aDadosBanco[1] == "001"
				cNroDoc	:= StrZero(Val(SE1->E1_NUMBCO),5)
			ElseIf aDadosBanco[1] = "237"
				cNroDoc :=  StrZero(Val(Substr(SE1->E1_NUMBCO,1,11)),11)
			ElseIf aDadosBanco[1] == "341"
				cNroDoc := StrZero(Val(SE1->E1_NUMBCO),8)
			ElseIf aDadosBanco[1] == "033"
				cNroDoc := StrZero(Val(SE1->E1_NUMBCO),12)
			ElseIf aDadosBanco[1] == "104"
				cNroDoc := StrZero(Val(SE1->E1_NUMBCO),12)
			EndIf
			//cNroDoc := AllTrim(SE1->E1_NUMBCO)

		ElseIf !Empty(SEE->EE_FAXATU)   // a partir da 2 vez vez

			If aDadosBanco[1] == "001"
				cNroDoc	:= StrZero(Val(SEE->EE_FAXATU),5)
			ElseIf aDadosBanco[1] = "237"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),11)
			ElseIf aDadosBanco[1] == "341"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),8)
			ElseIf aDadosBanco[1] == "033"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),12)
			ElseIf aDadosBanco[1] == "104"
				cNroDoc := StrZero(Val(SEE->EE_FAXATU),12)
			EndIf

		Else
			cNroDoc	:= StrZero(1,8)//STRZERO(VAL(SE1->E1_NUM),10)	// primeira vez
		EndIf

		//cNroDoc	:= STRZERO(VAL(cNroDoc),10)

		if SEE->EE_CODIGO $ "033"
			cCodConvenio := IIf(Empty(SEE->EE_NUMCTR),SEE->EE_CODEMP,SEE->EE_NUMCTR)
		else
			cCodConvenio := SEE->EE_CODEMP
		endif

		//Monta codigo de barras
		aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9" 	    ,; //Banco
		Subs(aDadosBanco[3],1,4)			    ,;//Agencia
		aDadosBanco[4]						,;//Conta
		aDadosBanco[5]						,;//Digito da Conta
		aDadosBanco[6]						,;//Carteira
		AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;//Documento
		(SE1->E1_SALDO-nVlrAbat+SE1->E1_ACRESC-SE1->E1_DECRESC)					,;//Valor do Titulo
		(SE1->E1_VENCTO)						,;//Vencimento               // ALTERADO EM 20.09.2010 ERA E1_VENCREA, MAS TAVA DANDO ERRO ERRO DE FATOR DE VENCTO
		cCodConvenio	  						,;//Convenio
		cNroDoc  								,;//Sequencial
		Iif(SE1->E1_DECRESC > 0,.t.,.f.)		,;//Se tem desconto
		SE1->E1_PARCELA						,;//Parcela
		aDadosBanco[3])						  //Agencia Completa
		aDadosTit := {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;  //	[1]	Número do título
		E1_EMISSAO						,;  //	[2]	Data da emissão do título
		dDataBase						,;  //	[3]	Data da emissão do boleto
		(SE1->E1_VENCTO)						,;  //	[4]	Data do vencimento
		(SE1->E1_SALDO - nVlrAbat + SE1->E1_ACRESC-SE1->E1_DECRESC)			,;  //	[5]	Valor do título
		aCB_RN_NN[3]					,;  //	[6]	Nosso número (Ver fórmula para calculo)
		SE1->E1_PREFIXO						,;  //	[7]	Prefixo da NF
		SE1->E1_TIPO							}   //	[8]	Tipo do Titulo

		if !lProblema
			If xBanco == nil
				If Marked("E1_OK")
					Impres2(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,lEmail)
					lGerBol := .t.
					nX := nX + 1
				EndIf
			Else
				Impres2(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,lEmail)
				lGerBol := .t.
				nX := nX + 1
			EndIf
	
			
		endif

		DbSelectArea("SE1")
		SE1->(dbSkip())
		//IncProc()
		nI := nI + 1
	EndDo

	If !lEmail
		If lGerBol
			oPrint:Preview()// Visualiza antes de imprimir
		Endif
		FreeObj(oPrint)		
	Else
		If lGerBol
			If len(aTo) > 0
				oPrint:Preview()// Visualiza antes de imprimir
				File2Printer(oPrint:CFILEPRINT, "PDF" )	
				cDirRel	:= oPrint:cPathPDF
				cArqRel := cPdfNom+".PDF"
				EnvBoleto( cDir,cArqRel,aTo)
			Else
				Help(" ",1,"JFINX100",,"Nao existe e-mail de contato cadastrado para envio.",1,0)
			Endif				
			FErase(cArqRel)	
		Endif	
		FreeObj(oPrint)
	Endif
	
	oPrint := Nil	

Return(cPath+cPdfNom) //lProblema
	

user function FBLEMAIL()
	local lRet := .F.
	
	if Posicione("SA1",1,xFilial("SA1")+PARAMIXB[1]+PARAMIXB[2],"A1_BLEMAIL") == "1"
		lRet := .T.
	endif
return lRet

static function EscolheBco(cCliLoj)
	local aRet := {}
	local cComboBo1 := ""
	local aItens := {}
	local cBcoCli := ""
	local oDlgSEE, oButton1, oButton2, oComboBo1
	local aSalvSEE := SEE->(GetArea())
	local aSalvSA1 := SA1->(GetArea())

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())

	/*if SA1->(FieldPos("A1_ZBCO")) > 0 .and. SA1->(FieldPos("A1_ZAGC")) > 0 .and. SA1->(FieldPos("A1_ZCTA")) > 0
		if SA1->(DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.))
			cBcoCli := SA1->(A1_ZBCO+A1_ZAGC+A1_ZCTA)
		endif
	endif*/
	
	if Empty(cBcoCli)
		if SEE->(FieldPos("EE_ZEMIBOL")) > 0
			DbSelectArea("SEE")
			SEE->(DbSetOrder(1))
			SEE->(DbGoTop())
			
			while !SEE->(Eof())
				if SEE->EE_ZEMIBOL == "S"
					AAdd(aItens,AllTrim(SEE->EE_CODIGO)+" | "+AllTrim(SEE->EE_AGENCIA)+" | "+AllTrim(SEE->EE_CONTA)+" | "+AllTrim(SEE->EE_SUBCTA)+" | "+Posicione("SA6",1,xFilial("SA6")+SEE->(EE_CODIGO+EE_AGENCIA+EE_CONTA),"A6_NOME"))
				endif
				
				SEE->(DbSkip())
			enddo
		else
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("O campo EE_ZEMIBOL não está criado."),{"OK"})

			return
		endif
		
		RestArea(aSalvSEE)
		RestArea(aSalvSA1)
		
		if !Empty(aItens)
			cComboBo1 := aItens[1]
			
			define msdialog oDlgSEE title "Gerar Boleto" from 000,000 to 060,425 colors 0,16777215 pixel
				@003,004 mscombobox oComboBo1 var cComboBo1 items aItens size 207,010 of oDlgSEE colors 0,16777215 pixel
				@016,133 button oButton2 prompt "Cancelar" size 037,012 of oDlgSEE action oDlgSEE:End() pixel
				@016,173 button oButton1 prompt "Confirmar" size 037,012 of oDlgSEE action fSetSEE(@oDlgSEE,@aRet,cComboBo1) pixel
			activate msdialog oDlgSEE center
		else
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Parâmetro de banco sem permissão para gerar boleto"),{"OK"})
		endif
	else
		if SEE->(FieldPos("EE_ZEMIBOL")) > 0
			DbSelectArea("SEE")
			SEE->(DbSetOrder(1))
			SEE->(DbGoTop())

			if SEE->(DbSeek(xFilial("SEE")+cBcoCli,.F.))
				while !SEE->(Eof()) .and. SEE->(EE_CODIGO+EE_AGENCIA+EE_CONTA) == cBcoCli
					if SEE->EE_ZEMIBOL == "S"
						AAdd(aItens,AllTrim(SEE->EE_CODIGO)+" | "+AllTrim(SEE->EE_AGENCIA)+" | "+AllTrim(SEE->EE_CONTA)+" | "+AllTrim(SEE->EE_SUBCTA)+" | "+Posicione("SA6",1,xFilial("SA6")+SEE->(EE_CODIGO+EE_AGENCIA+EE_CONTA),"A6_NOME"))
					endif

					SEE->(DbSkip())
				enddo
			endif
		else
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("O campo EE_ZEMIBOL não está criado."),{"OK"})

			return
		endif

		RestArea(aSalvSEE)
		RestArea(aSalvSA1)

		if !Empty(aItens)
			aRet := AClone(aItens)
		else
			Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Parâmetro de banco sem permissão para gerar boleto"),{"OK"})
		endif
	endif
return aRet

static function fSetSEE(oDlgSEE,aRet,cComboBo1)
	aRet := StrToKarr(cComboBo1,"|")
	
	oDlgSEE:End()
return
