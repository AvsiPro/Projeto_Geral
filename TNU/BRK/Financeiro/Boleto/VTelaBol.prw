#Include "Protheus.Ch"
#INCLUDE 'Fileio.ch'
#INCLUDE "TOPCONN.CH"

Static oOk       := LoadBitmap(GetResources(),"LBOK")
Static oNo       := LoadBitmap(GetResources(),"LBNO")
Static oDlg      := nil
Static oChk      := nil
Static oChk2     := nil
Static oConteudo := nil
Static oTMPCent  := nil 


Static cNumTit := CriaVar("E1_NUM")
Static oNumTit := Nil
Static cCNPJ   := CriaVar("A1_CGC")
Static oCNPJ   := Nil
Static cVencto := CriaVar("E1_VENCREA")
Static oVencto := Nil
Static cValor  := CriaVar("E1_VALOR")
Static oValor  := Nil
Static cNomCli := CriaVar("A1_NREDUZ")
Static oNomCli := Nil
Static cCODCLI :=  CriaVar("A1_COD")
Static oCodCli := Nil 
Static oNFTran := nil 
Static cNFTra  := CriaVar("FT_NFELETR")
Static aVetor  := {}
Static aDados  := {}
Static aTipo   := {"1° Via", "2° Via"}
Static aLocal  := {"1-Nota","2-CNPJ","3-Vencimento","4-Valor","5-Cod.Cliente","6-Nome","7-NF transmitida"}

Static _cBanco    := ""
Static _cAgencia  := ""
Static _cConta    := ""
Static _cSubConta := ""
Static _Tipo      := 1
Static _lGerouPdf := .F.
Static _lSche     := .F.
Static nOpcao     := 0
Static nLocal     := 1
Static _lAutoriza := .T.
Static lChk       := .F.
Static lMark      := .F.
Static cConteudo  := Space(30)

Static nPosSel    := 1
Static nPosSerie  := 2
Static nPosNota   := 3
Static nPosParc   := 4
Static nPosCodC   := 5
Static nPosLoja   := 6
Static nPosNom    := 7
Static nPosDtE    := 8
Static nPosVlr    := 9
Static nPosVct    := 10
Static nPosVcR    := 11
Static nPosTip    := 12
Static nPosPor    := 13
Static nPosAge    := 14
Static nPosCnt    := 15
Static nPosCNPJ   := 16
Static nPosBor    := 17
Static nPosNNro   := 18
Static nPosNFTR   := 19
Static nPosFil    := 20

/*/{@Protheus.doc} VTelabol
description
@type function
@version  1.0
@author Valdemir Rabelo
@since 15/01/2022
A1_BLEMAIL - ENVIA BOLETO 1=SIM 2=NAO
/*/
User Function VTelabol
	Local bGetExec     :={|| Filtro(), CargaBD(), Interface()}
	Local cDirLocal    := GETMV("FS_PathLoc",.f.,"C:\Temp\Boletos\")
	Local aCoordenadas := MsAdvSize(.T.)
	Private lDebug     := .F. 
	Private cTitulo    := "SELEÇÃO DE BOLETOS"
	Private _cDirPdf   := GetMV("MV_XBOLITAU",.f.,"C:\Temp")
	Private lChk2      := .F.
	Private cCadastro
	Private _EmisIni   := Ctod(" / / ")
	Private _EmisFim   := Ctod(" / / ")
	Private oLbx       := nil

	MakeDir("C:\Temp\")
	MakeDir(cDirLocal)

	//DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 To 511,1292 PIXEL
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM aCoordenadas[7],000 To aCoordenadas[6],aCoordenadas[5] COLORS 0,16772829 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )

	Eval(bGetExec)

	ACTIVATE MSDIALOG oDlg CENTER

Return .T.


/*/{@Protheus.doc} CargaBD
	description
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 15/01/2022
/*/
Static Function CargaBD()
/*	Local cQuery := ""
	Local aTMP   := {}
*/
	aVetor := {}

	if ValType(_Tipo)=="C"
		_Tipo := Val(_Tipo)
	Endif
/*
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
*/
	BrkClassGen():CargaTelaBol(_Tipo, @aVetor, @aDados)
/*
	cQuery := " SELECT E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VALOR, E1_VENCTO, E1_VENCREA, E1_TIPO, E1_PORTADO, E1_NUMBOR, E1_NUMBCO FROM " + CRLF
	cQuery += RetSqlName("SE1") + " " + CRLF
	cQuery += " WHERE " + CRLF
	cQuery += "    D_E_L_E_T_ = '' AND  " + CRLF
	cQuery += "    E1_FILIAL = '" + xFilial( "SE1" ) + "'  " + CRLF
	cQuery += " AND E1_SALDO <> 0    " + CRLF
	If _Tipo == 1
		cQuery += " AND E1_NUMBCO   = ''   " + CRLF
		cQuery += " AND E1_PORTADO  = ''   " + CRLF
		cQuery += " AND E1_NUMBOR   = ''   " + CRLF
	ElseIf _Tipo == 2
		cQuery += " AND E1_NUMBCO   <> ''   " + CRLF
		cQuery += " AND E1_PORTADO  <> ''   " + CRLF
		cQuery += " AND E1_NUMBOR   <> ''   " + CRLF
	EndIf
	cQuery += " AND E1_TIPO = 'NF'   " + CRLF
	cQuery += " AND E1_EMISSAO BETWEEN '" + DtoS(_EmisIni) + "' AND '" + DTOS(_EmisFim) + "' "+ CRLF
	cQuery += " ORDER BY  E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA  " + CRLF

	If Select("TMP") > 0
		TMP->(DbcloseArea())
	EndIf

	TCQuery cQuery NEW ALIAS "TMP"

	DbSelectArea("TMP")
	DbGoTop()

	While !TMP->(Eof())
		aTMP := Array(20)
		SA1->( dbSeek(xFilial('SA1')+TMP->E1_CLIENTE+TMP->E1_LOJA))
		If TMP->E1_TIPO == "NF"   // Títulos com Tipo NF

			DbSelectArea("SF3")
			SF3->(DbSetOrder(4)) // F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE

			If	SF3->(DbSeek(xFilial("SF3")+TMP->E1_CLIENTE+TMP->E1_LOJA+TMP->E1_NUM+TMP->E1_PREFIXO))
				If	SF3->F3_ESPECIE == "RPS"
					If	((SF3->F3_CODRSEF == "100") .or. (alltrim(SF3->F3_CODRSEF) $ "S/T"))
						_lAutoriza := .T.
					Else
						_lAutoriza := .F.
					EndIf
				EndIf
			Else
				_lAutoriza := .F.
			EndIf

		EndIf

		If	_lAutoriza   // Se foi autorizado
			aTMP[nPosSel]   := lMark
			aTMP[nPosSerie] := TMP->E1_PREFIXO
			aTMP[nPosNota]  := TMP->E1_NUM
			aTMP[nPosParc]  := TMP->E1_PARCELA
			aTMP[nPosCodC]  := TMP->E1_CLIENTE
			aTMP[nPosLoja]  := TMP->E1_LOJA
			aTMP[nPosNom ]  := TMP->E1_NOMCLI
			aTMP[nPosDtE]   := Stod(TMP->E1_EMISSAO)
			aTMP[nPosVlr]   := AllTrim(Transform(TMP->E1_VALOR,"@E 999,999,999.99"))
			aTMP[nPosVct]   := Stod(TMP->E1_VENCTO)
			aTMP[nPosVcR]   := Stod(TMP->E1_VENCREA)
			aTMP[nPosTip]   := TMP->E1_TIPO
			aTMP[nPosPor]   := TMP->E1_PORTADO
			aTMP[nPosAge]   := TMP->E1_AGEDEP
			aTMP[nPosCnt]   := TMP->E1_CONTA
			aTMP[nPosCNPJ]  := Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
			aTMP[nPosBor]   := TMP->E1_NUMBOR
			aTMP[nPosNNro]  := TMP->E1_NUMBCO
			aTMP[nPosNFTR]  := SFT->FT_NFELETR
			aTMP[nPosFil ]  := TMP->E1_FILIAL
			aAdd(aVetor, aClone(aTMP))
		EndIf

		TMP->(dbSkip())
	Enddo

	if Empty(aVetor)
		aAdd(aVetor, { lMark, "", "", "", "", "", "", Stod(""), AllTrim(Transform(0,"@E 999,999,999.99")), Stod(""), Stod(""), "", "", "", "", "", "", "","","" })
		FWMsgRun(,{|| Sleep(3000)},"Informativo","Não existe dados a serem apresentados...")
		Return .F.
	Endif

	// Backup dos registros
	aDados  := aVetor

	DbSelectArea("TMP")
	DbCloseArea()
*/
Return .T.


/*/{@Protheus.doc} Filtro
	description
	@type function
	@version 1.0
	@author Valdemir Rabelo
	@since 15/01/2022
/*/
Static Function Filtro()
	Local aPerg  := {}
	Local aRET   := {}
	Local lRET   := .F.

	AADD(aPerg,{2,"Tipo Impressão"  ,1	,aTipo		,70		,".T."	,.T.,".T."})
	AADD(aPerg,{1,"Emissão De"         ,DDATABASE,'@D 99/99/9999',"","","",70,.T.})
	AADD(aPerg,{1,"Emissão Até"        ,DDATABASE,'@D 99/99/9999',"","","",70,.T.})

	If ParamBox(aPerg,"Informe os Dados",@aRET,,,,,,,"VTELABOL",.T.,.T.)
		lRET     := .T.
		_Tipo    := aRET[01]
		_EmisIni := aRET[02]
		_EmisFim := aRET[03]
	EndIf

Return lRET


/*/{@Protheus.doc} Interface
	description
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 15/01/2022
/*/
Static Function Interface()
	Local nLinObj  := 019
	Local nLiSay   := 005
	Local nLiGet   := 014
	Local nAjBT    := 45
	Local nCBParam := IIF(VALTYPE(_Tipo)=="C",VAL(_Tipo),_Tipo)
	Local dDTEMIS  := _EmisIni
	Local dDTEFIM  := _EmisFim
	Local oCBParam := nil
	Local aObjMnt  := MntTela()
	Local oObjLeft := aObjMnt[1]
	Local oObjCent := aObjMnt[2]
	Local oPanel   := TPanel():New(0, 0, , oObjCent, , , , , CLR_WHITE, 0, 15, .F., .F.)

	oTMPCent := oObjCent

	oGrFIL := tGroup():New(nLiSay-5,01,155,(oObjLeft:nClientWidth/2)-1,'[ Filtro ]',oObjLeft,CLR_BLUE,,.T.)
	@ nLiSay+1, 004 SAY oSayTit PROMPT "Nro.Nota" SIZE 030,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oNumTit VAR cNumTit PICTURE "@!" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj
	nLiGet += nLinObj
	@ nLiSay, 004 SAY oSayNFT PROMPT "NF Transmitida" SIZE 050,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oNFTran VAR cNFTra PICTURE "@!" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj
	nLiGet += nLinObj
	@ nLiSay, 004 SAY oSayVct PROMPT "Vencimento" SIZE 030,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oVencto VAR cVencto PICTURE "@D 99/99/9999" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj
	nLiGet += nLinObj
	@ nLiSay, 004 SAY oSayVlr PROMPT "Valor" SIZE 030,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oValor VAR cValor PICTURE "@E 999,999,999.99" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj
	nLiGet += nLinObj
	@ nLiSay, 004 SAY oSayNum PROMPT "CNPJ" SIZE 030,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oCNPJ VAR cCNPJ PICTURE "@R 99.999.999/9999-99" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj
	nLiGet += nLinObj
	@ nLiSay, 004 SAY oSayCodC PROMPT "Cod.Cliente" SIZE 030,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oCodCli VAR cCODCLI PICTURE "@!" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj
	nLiGet += nLinObj
	@ nLiSay, 004 SAY oSayNom PROMPT "Nome" SIZE 030,08 OF oObjLeft COLORS 16711680, 16777215 PIXEL
	@ nLiGet, 004 MSGET oNomCli VAR cNomCli PICTURE "@!" SIZE 080, 008  WHEN .T. OF oObjLeft COLORS 0, 16777215 PIXEL

	nLiSay += nLinObj
	@nLiSay+2,003 BUTTON oBTLimpa PROMPT "Limpar Filtro" SIZE ((oObjLeft:nClientWidth/2)-9)/2, 013 Font oDlg:oFont ACTION FWMsgRun(,{|| ClearFil() },'Aguarde','Removendo Filtro') OF oObjLeft PIXEL
	@nLiSay+2,((oObjLeft:nClientWidth/2)-8)/2+4 BUTTON oBTAtua PROMPT "Filtrar" SIZE ((oObjLeft:nClientWidth/2)-9)/2, 013 Font oDlg:oFont ACTION { FWMsgRun(,{|| VLDGER()},'Aguarde','Filtrando registro') } OF oObjLeft PIXEL
	oBTLimpa:SetCSS(SetCssImg("Warning"))
	oBTAtua:SetCSS(SetCssImg("Primary"))

	oPanel:Align := CONTROL_ALIGN_TOP
	@005,003 LISTBOX oLbx VAR cVar FIELDS Header " ", "Serie", "Nota", "Parcela", "Cod. Cliente", "Loja", "Nome Cliente", "Data Emissão", "Valor R$", "Vencimento", "Vencimento Real", "Tipo", "Portador", "Agencia", "Conta","CNPJ" ,"Bordero", "Nosso N° Sistema", "NF Transmitida","Filial" SIZE 630,200 Of oObjCent PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT
	BrkClassGen():AtuList(aVetor)
	oLbx:Refresh()
	oLbx:SetFocus()

	@003,003 CHECKBOX oChk  VAR lChk  Prompt "Marca/Desmarca" SIZE 60,007 PIXEL Of oPanel On Click(aEval(aVetor,{|x| x[1] := lChk}),oLbx:Refresh())
	@003,070 CHECKBOX oChk2 VAR lChk2 Prompt "Copia PDF para maquina local" SIZE 90,007 PIXEL Of oPanel
	@003,170 SAY oSayTit PROMPT "Procurar" SIZE 023,08 OF oPanel  PIXEL
	@003,195 MSCOMBOBOX oLocal VAR nLocal ITEMS aLocal SIZE 050, 008 OF oPanel COLORS 0, 16777215 PIXEL ON CHANGE LocalReg()
	@003,245 MSGET oConteudo VAR cConteudo PICTURE "@!" SIZE 080, 008  WHEN .T. OF oPanel COLORS 0, 16777215 PIXEL
	@003,325 BUTTON oBTLoc PROMPT "OK" SIZE 16, 010 Font oDlg:oFont ACTION { LocalReg('L') } OF oPanel PIXEL
	oBTLoc:SetCSS(SetCssImg("Primary"))
	oBTLoc:cToolTip := "Localiza registro"

	nLiSay += nLinObj
	oGropFIL := tGroup():New(nLiSay,01,175+33,(oObjLeft:nClientWidth/2)-1,'[ Seleção Principal ]',oObjLeft,CLR_BLUE,,.T.)
	nLiSay += nLinObj-8
	@nLiSay,063 BUTTON oBTAtu PROMPT "OK" SIZE 16, 021 Font oDlg:oFont ACTION {VLDFIL(nCBParam, dDTEMIS,dDTEFIM)} OF oObjLeft PIXEL
	@ nLiSay, 011 MSCOMBOBOX oCBParam VAR nCBParam ITEMS aTipo SIZE 050, 010 OF oGropFIL COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj-8
	@ nLiSay, 011 MSGET oDTEMIS  VAR dDTEMIS PICTURE "@D 99/99/9999" SIZE 050, 010  WHEN .T.  OF oGropFIL COLORS 0, 16777215 PIXEL
	nLiSay += nLinObj-6
	@ nLiSay, 011 MSGET oDTEMIS2 VAR dDTEFIM PICTURE "@D 99/99/9999" SIZE 050, 010  WHEN .T.  OF oGropFIL COLORS 0, 16777215 PIXEL
	oBTAtu:SetCSS(SetCssImg("Primary"))
	oBTAtu:cToolTip := "Atualiza Dados Parâmetro Principal"
	
	nAjBT += 44
	oGropBT := tGroup():New(120+nAjBT,01,180+nAjBT,(oObjLeft:nClientWidth/2)-1,'[ Botões de Ações ]',oObjLeft,CLR_BLUE,,.T.)
	@130+nAjBT,005 BUTTON oBTConf PROMPT "Confirmar" SIZE (oObjLeft:nClientWidth/2)-12, 015 Font oDlg:oFont ACTION ConfOK() OF oObjLeft PIXEL
	@146+nAjBT,005 BUTTON oBTCons PROMPT "Consulta"  SIZE (oObjLeft:nClientWidth/2)-12, 015 Font oDlg:oFont ACTION VisuSE1() Of oObjLeft PIXEL
	@162+nAjBT,005 BUTTON oBTSair PROMPT "Sair"      SIZE (oObjLeft:nClientWidth/2)-12, 015 Font oDlg:oFont ACTION oDlg:End() OF oObjLeft PIXEL
	oBTConf:SetCSS(SetCssImg("Success"))
	oBTCons:SetCSS(SetCssImg("Primary"))
	obtSair:SetCSS(SetCssImg("Danger"))
	oBTCons:cToolTip := "Consulta Registro"
	oBTConf:cToolTip := "confirmação para Processamento"
	obtSair:cToolTip := "Sair da tela"
Return



/*/{@Protheus.doc} Interface
	description
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 15/01/2022
/*/
Static Function MntTela()
	Local aRET      := {}
	Local oFWLMain  := Nil
	Local oWinSup01 := Nil
	Local oWinSup02 := Nil

	oFWLMain := FWLayer():New()
	oFWLMain:Init( oDlg, .F. )

	// Linhas
	oFWLMain:AddLine("LineSup" ,100,.T.)

	// Colunas
	oFWLMain:AddCollumn( "ColSup01", 015, .T.,"LineSup" )
	oFWLMain:AddCollumn( "ColSup02", 085, .T.,"LineSup" )

	// Janelas
	oFWLMain:AddWindow( "ColSup01", "WinSup01", "Ações",                 100, .T., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
	oFWLMain:AddWindow( "ColSup02", "WinSup02", "Selecione os Registros", 100, .T., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)

	// Gerando Objeto Superior
	oWinSup01 := oFWLMain:GetWinPanel('ColSup01','WinSup01',"LineSup" )
	oWinSup02 := oFWLMain:GetWinPanel('ColSup02','WinSup02',"LineSup" )

	aRET := {oWinSup01, oWinSup02}

Return aRET



/*/{@Protheus.doc} ConfOK
	description
	Rotina que irá confirmar o processamento
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 15/01/2022
/*/
Static Function ConfOK()
    BrkClassGen():ConfirmaBol(_Tipo,aVetor)
	oLbx:Refresh()
	oLbx:SetFocus()

/*
	Local nX         := 0
	Local _lSche     := .F.
	Local _lMail     := .F.
	Local cDirLocal  := GETMV("FS_PathLoc",.f.,"C:\Temp\Boletos\")

	SM0->(DbSetOrder(1)) 
	SM0->(DbSeek(cEmpAnt + cFilAnt ))
	
	aEval(aVetor, { |X| iif(X[1],nX++,0) })

	if (nX==0)
		FWAlertInfo("Não foi selecionado nenhum registro.","Atenção!")
		Return .T.
	endif

	If _Tipo == 1
		DbSelectArea("SA6")
		SA6->(DbSetOrder(3))
		If SA6->(DbSeek( FWxFilial("SA6") + SM0->M0_CGC ))
			_cBanco 	:= SA6->A6_COD
			_cAgencia 	:= SA6->A6_AGENCIA
			_cConta		:= SA6->A6_NUMCON
			_cSubConta	:= "001"

			If !GeraBor(aVetor, _cBanco, _cAgencia, _cConta)
				FWAlertWarning("O borderô não pôde ser gerado, favor verificar.","Atenção!")
				Return
			EndIf
		EndIf
	ElseIf _Tipo == 2
		For nX := 1 to Len( aVetor )
			If aVetor[nX][1] == .T.
				_cBanco 	:= aVetor[nX][nPosPor]
				_cAgencia 	:= aVetor[nX][nPosAge]
				_cConta		:= aVetor[nX][nPosCnt]
				_cSubConta	:= "001"
			Endif
		Next
	EndIf

	If _cBanco == "341"
		If FUNNAME() == 'FISA022'
			_lMail := .T.
		EndIf*/
		// Gera PDF do Boleto
		//U_ProcesBol(@aVetor,_cBanco,_cAgencia,_cConta,_cSubConta, 1,_EmisIni,_EmisIni,""/*SF2->F2_DOC*/,_lSche, _cDirPdf,_lMail)
/*		CargaBD()
		AtuList()
		
		if lChk2
			WINEXEC("Explorer.exe "+cDirLocal )
		endif
	EndIf
*/
Return .T.




/*/{@Protheus.doc} SetCssImg
	description
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function SetCssImg(cTipo)
	Local cCssRet := ""

	cCssRet := BrkClassGen():SetCssBot(cTipo)

/*	Default cTipo := "Primary"

	IF cTipo == "Success"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: green }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #53BD33 } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: green }"
		cCssRet += "QPushButton:focus { background-color: #66E83F } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	
	EndIf

	IF cTipo == "Primary"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: blue }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #434bdf } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: #373fd4 }"
		cCssRet += "QPushButton:focus { background-color: #1c25d7 } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	
	EndIf

	IF cTipo == "Danger"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: Red }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #E63223 } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: Red }"
		cCssRet += "QPushButton:focus { background-color: #F73626 } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	
	EndIf

	IF cTipo == "Warning"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: orange }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #E3CC10 } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: #F5DC11 }"
		cCssRet += "QPushButton:focus { background-color: #F5DC11 } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	

	EndIf
*/
Return cCssRet

/*/{@Protheus.doc} VLDFIL
	description
	Rotina para atualizar os registros coom parâmetro informado
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function VLDFIL(nCBParam, dDTEMIS, dDTEFIM)
	_Tipo    := nCBParam
	_EmisIni := dDTEMIS
	_EmisFim := dDTEFIM
	CargaBD()
	BrkClassGen():AtuList(aVetor)	
	oLbx:Refresh()
	oLbx:SetFocus()


Return


/*/{@Protheus.doc} AtuList
	description
	Rotina para atualizar o grid
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
/*
Static Function AtuList()

	oLbx:SetArray(aVetor)
	oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10], aVetor[oLbx:nAt,11], aVetor[oLbx:nAt,12], aVetor[oLbx:nAt,13], aVetor[oLbx:nAt,14], aVetor[oLbx:nAt,15], aVetor[oLbx:nAt,16], aVetor[oLbx:nAt,17], aVetor[oLbx:nAt,18], aVetor[oLbx:nAt,19], aVetor[oLbx:nAt,20] }}
	oLbx:Refresh()
	oLbx:SetFocus()

Return
*/

/*/{@Protheus.doc} ClearFil
	description
	Rotina limpar campos
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function ClearFil()
	cNumTit := CriaVar("E1_NUM")
	cCNPJ   := CriaVar("A1_CGC")
	cVencto := CriaVar("E1_VENCREA")
	cValor  := CriaVar("E1_VALOR")
	cNomCli := CriaVar("A1_NREDUZ")
	cCODCLI := CriaVar("A1_COD")
	cNFTra  := CriaVar("FT_NFELETR")
	aTipo   := {"1° Via", "2° Via"}

	// Carrega registros
	CargaBD()

	BrkClassGen():AtuList(aVetor)
	oLbx:Refresh()
	oLbx:SetFocus()
Return .T.

/*/{@Protheus.doc} VLDGER
	description
	Rotina que fará a validação conforme campo informado
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function VLDGER()
	Local aTMP := aClone(aVetor)
	Local nX   := 0

	aVetor := {}

	For nX := 1 to Len(aDados)
		if (!Empty(cNumTit)) .or. (!Empty(cCNPJ)) .or. (!Empty(Left(Alltrim(dtos(cVencto)),2))) .or. (!Empty(cValor))  .or. (!Empty(cNomCli)) .or. (!Empty(cCODCLI)) .or. (!Empty(cNFTra))
			if ( (Alltrim(aDados[nX][nPosNota]) == Alltrim(cNumTit) .AND. (!Empty(cNumTit))) .or.;
					(Alltrim(aDados[nX][nPosCNPJ]) == Transform(Alltrim(cCNPJ),"@R 99.999.999/9999-99") .AND. (!Empty(cCNPJ))) .or.;
					(Alltrim(dtos(aDados[nX][nPosVct])) == Alltrim(dtos(cVencto) ) .AND. (!Empty(Left(Alltrim(dtos(cVencto)),2)))) .or. ;
					(cValtochar(aDados[nX][nPosVlr])==alltrim(Transform(cValor, "@E 999,999,999.99")) .AND. (!Empty(cValor))) .or.;
					(Left(Alltrim(aDados[nX][nPosNom]),Len(Alltrim(cNomCli))) $ Alltrim(cNomCli) .AND. (!Empty(cNomCli)) ) ) .or. ;
					(Alltrim(aDados[nX][nPosCodC]) $ Alltrim(cCODCLI) .AND. (!Empty(cCODCLI))) .or. ;
					(Alltrim(aDados[nX][nPosNFTR]) $ Alltrim(cNFTra) .AND. (!Empty(cNFTra)))
				aAdd(aVetor, aDados[nX])
			endif
		endif
	Next

	if Empty(aVetor)
		FWMsgRun(,{|| Sleep(3000)},"Informativo","Não encontrou registros com filtro informado.")
		aVetor := aClone(aTMP)
		Return .T.
	endif

	aSort(aVetor,,,{ |x,y| x[nPosNota] < y[nPosNota] })
	if oLbx != nil 
	   oLbx := nil 
	   	@005,003 LISTBOX oLbx VAR cVar FIELDS Header " ", "Serie", "Nota", "Parcela", "Cod. Cliente", "Loja", "Nome Cliente", "Data Emissão", "Valor R$", "Vencimento", "Vencimento Real", "Tipo", "Portador", "Agencia", "Conta","CNPJ" ,"Bordero", "Nosso N° Sistema", "NF Transmitida","Filial" SIZE 630,200 Of oTMPCent PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT		   
	endif 
	BrkClassGen():AtuList(aVetor)	
	oLbx:SetFocus()
Return .T.

/*/{@Protheus.doc} VisuSE1
	description
	@type function
	@version 1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function VisuSE1()
	Local aArea := GetArea()
	Local nReg  := 0
	Local _cTitN:= aVetor[oLbx:nAT, nPosNota]

	if !Empty(_cTitN)
		DbSelectArea("SE1")
		nReg  := getRegPos(_cTitN)
		if nReg > 0
			SE1->( dbGoto(nReg) )
			FWMsgRun(,{|| AxVisual("SE1", nReg, 2) },"Aguarde","Carregando interface do registro")
		endif
	else
		FWAlertInfo("Não existe registro a ser visualizado","Atenção!")
	endif

	RestArea( aArea )
Return

/*/{@Protheus.doc} getRegPos
	description
	Rotina para posicionar no registro CR
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function getRegPos(pTitulo)
	Local nReg := 0
	Local cQry := ""
	Local aTMP := GetArea()

	cQry := "SELECT R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME("SE1") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND A.E1_NUM='" + pTitulo + "' " + CRLF

	IF SELECT("TMP") > 0
		TMP->( DbCloseArea() )
	ENDIF
	TCQuery cQry NEW ALIAS "TMP"

	if TMP->( !Eof() )
		nReg := TMP->REG
	Endif

	IF SELECT("TMP") > 0
		TMP->( DbCloseArea() )
	ENDIF

	RestArea( aTMP )

Return nReg


/*/{@Protheus.doc} GeraBor
description
Rotina Gerar Bordero
@type function
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function GeraBor(aVetor, _cBanco, _cAgencia, _cConta)
    Local lRET as logical

	lRET :=  BrkClassGen():GeraBordero(aVetor, _cBanco, _cAgencia, _cConta, .F.)
	
	/*Local aTit		as array
	Local aBor		as array
	Local aErroAuto as array
	Local lRet      as logical
	Local nX		as numeric
	Local nCntErr	as numeric
	Local cErroRet  as char

	Private lMsErroAuto as logical
	Private lAutoErrNoFile as logical

	aTit	  := {}
	aBor	  := {}
	aErroAuto := {}
	lRet	  := .F.
	nX		  := 0
	nCntErr	  := 0
	cErroRet  := ""

	lMsErroAuto := .F.
	lAutoErrNoFile:= .T.

	For nX := 1 To Len(aVetor)
		aTit := {}
		aBor := {}
		If aVetor[nX][1]
			if SA1->( DbSeek(xFilial("SA1") + aVetor[nX, 5]+aVetor[nX, 6]) )
				IF (SA1->A1_BLEMAIL=='1')
					
					cNumBor := Soma1(GetMV("MV_NUMBORR"),6)

					aAdd(aBor, {"AUTBANCO" , _cBanco })
					aAdd(aBor, {"AUTAGENCIA" , _cAgencia })
					aAdd(aBor, {"AUTCONTA" , _cConta })
					aAdd(aBor, {"AUTSITUACA" , PadR("1" ,TamSX3("E1_SITUACA")[1]) })
					aAdd(aBor, {"AUTNUMBOR" , cNumBor })
					aAdd(aTit,;
						{;
						{"E1_FILIAL" ,	aVetor[nX][nPosFil] },;
						{"E1_PREFIXO" ,	aVetor[nX][nPosSerie]  },;
						{"E1_NUM" ,		aVetor[nX][nPosNota]  },;
						{"E1_PARCELA" ,	aVetor[nX][nPosParc]  },;
						{"E1_TIPO" ,	aVetor[nX][nPosTip] };
						})

					if Len(aTit) > 0
						MSExecAuto({|a, b| FINA060(a, b)}, 3,{aBor,aTit})
					endif

					If lMsErroAuto

						//MostraErro()
						aErroAuto := GetAutoGRLog()
						For nCntErr := 1 To Len(aErroAuto)
							cErroRet += aErroAuto[nCntErr]
						Next

						FWAlertError(cErroRet,"Erro na geração Borderô para o título: "+aVetor[nX][nPosNota]+", caso tenha mais seleção irá tentar o proximo.")

					Else
						lRet := .T.
						PUTMV("MV_NUMBORR", cNumBor)				
					EndIf

				Endif
			endif
		EndIf

	Next nX
*/
Return lRet

/*/{@Protheus.doc} LocalReg
	description
	Rotina para licalizar registro
	@type function
	@version 1.0
	@author Valdemir Rabelo
	@since 17/01/2022
/*/
Static Function LocalReg(pOPC)
	Local nOpc   := iif(ValType(nLocal)=="C",Val(Left(nLocal,1)),nLocal)
	Local nPosCPO:= 0
	Default pOPC := ""

	if Empty(pOPC)
		if (nopc==2)        // CNPJ
			aSort(aVetor,,,{ |x,y| x[nPosCNPJ] < y[nPosCNPJ] })
			cConteudo := CriaVar("A1_CGC")
			oConteudo:PICTURE := "@R 99.999.999/9999-99"
		elseif (nopc==3)    // Vencimento
			aSort(aVetor,,,{ |x,y| x[nPosVct] < y[nPosVct] })
			cConteudo := CriaVar("E1_VENCREA")
			oConteudo:PICTURE := "@D 99/99/9999"
		elseif (nopc==4)    // Valor
			aSort(aVetor,,,{ |x,y| x[nPosVlr] < y[nPosVlr] })
			cConteudo := 0
			oConteudo:PICTURE := "@E 999,999,999.99"
		elseif (nopc==5)    // CodCli
			aSort(aVetor,,,{ |x,y| x[nPosCodC] < y[nPosCodC] })
			cConteudo := CriaVar("A1_COD")
			oConteudo:PICTURE := "@!"
		elseif (nopc==6)    // Nome
			aSort(aVetor,,,{ |x,y| x[nPosNom] < y[nPosNom] })
			cConteudo := CriaVar("A1_NREDUZ")
			oConteudo:PICTURE := "@!"
		elseif (nopc==7)    // NFETRANS
			aSort(aVetor,,,{ |x,y| x[nPosNFTR] < y[nPosNFTR] })
			cConteudo := CriaVar("FT_NFELETR")
			oConteudo:PICTURE := "@!"
		else				// Nota
			aSort(aVetor,,,{ |x,y| x[nPosNota] < y[nPosNota] })
			cConteudo := CriaVar("E1_NUM")
			oConteudo:PICTURE := "@!"
		Endif
		oLbx:nAt := 1
		oLbx:Refresh()
		oConteudo:SETFOCUS()
	Else
		if (nopc==2)        // CNPJ
			nPos := Ascan(aVetor,{ |x,y| Alltrim(x[nPosCNPJ]) == Transform(Alltrim(cConteudo),"@R 99.999.999/9999-99") })
		elseif (nopc==3)    // Vencimento
		    if ValType(cConteudo)=="C"
			   cConteudo := ctod(alltrim(cConteudo))
			endif 
			nPos := Ascan(aVetor,{ |x,y| Dtos(x[nPosVct]) == Dtos(cConteudo) })
		elseif (nopc==4)    // Valor
			nPos := Ascan(aVetor,{ |x,y| StrTran(StrTran(x[nPosVlr],".",""),",",".") == StrTran(StrTran(Alltrim(Transform(cConteudo,"@E 999999999.99")),".",""),",",".") })
		elseif (nopc==5) .or. (nopc==6) .or. (nopc==7)  // Cod.Cli / Nome / NFTRANSM
		    nPosCPO := iif(nopc==5,nPosCodC, iif(nopc==6,nPosNom,nPosNFTR))	
			if (nopc==5) .or. (nopc==7)	
			   nPos := Ascan(aVetor,{ |x| Left(Upper(Alltrim(x[nPosCPO])),Len(Upper(Alltrim(cConteudo)))) == Upper(Alltrim(cConteudo)) })
			else 
				nPos := Ascan(aVetor,{ |x| Left(Upper(Alltrim(x[nPosCPO])),Len(Upper(Alltrim(cConteudo)))) $ Upper(Alltrim(cConteudo)) })
			endif 
		else				// Nota
			nPos := Ascan(aVetor,{ |x,y| Alltrim(x[nPosNota]) == Alltrim(cConteudo) })
		Endif
		if nPos > 0
			oLbx:nAt := nPos
			oLbx:SETFOCUS()
		else
		   FWMsgRun(,{|| Sleep(3000)},"Informativo","Registro não encontrado")
		   oLbx:nAt := 1 
		   oConteudo:SETFOCUS()
		endif 
	Endif

Return


user function EVTESTE
	u_VTELABOL()
return
