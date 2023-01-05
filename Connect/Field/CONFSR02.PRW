#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "FILEIO.CH"

/*/{Protheus.doc} User Function U_CONFSR02
    Impressão de relatórios
    @type  Function
    @author Diogo de Jesus Gasparini
    @since 16/12/2022
    @version 1
    /*/
User Function CONFSR02(aXList,aXList2,aXList3,aXList4,aXList5,cXTitle)

	Local aCombo := {"1=Recibo de Locação", "2=Extrato de Leitura", "3=Demonstrativo de Consumo", "4=Todos" }
	Local aPergs := {}

	Private aList := aXList
	Private aList2 := aXList2
	Private aList3 := aXList3
	Private aList4 := aXList4
	Private aList5 := aXList5
	Private cTitle := cXTitle

	aAdd( aPergs ,{2,"Escolha uma opção : ",0,aCombo,100,"",.T.})

	If !ParamBox(aPergs ,"Parametros ")
		Return
	EndIf

	if MV_PAR01 == "1"
		ReciboLoc()
	elseif MV_PAR01 == "2"
		ExtLeitura()
	elseif MV_PAR01 == "3"
		DemonsCon()
	elseif MV_PAR01 == "4"
		ReciboLoc()
		ExtLeitura()
		DemonsCon()
	endif

Return

Static Function ReciboLoc()

	Local lAdjustToLegacy  := .F.
	Local lDisableSetup    := .T.
	Local lOK              := .F.
	Local cQuery           := ""
	Local cMes             := ""
	Local cNum             := "" 
	Local cCli             := aList[oList:nAt,5]
	Local cEnd             := aList[oList:nAt,06]+" / "+aList[oList:nAt,07]+" / "+aList[oList:nAt,08]
	Local cCnpj            := AllTrim(aList[oList:nAt,3]) + "-" + AllTrim(aList[oList:nAt,4])
	Local cValor           := "R$ "
	Local cPeriodo         := "Locação de máquina referente ao mês " + cValToChar(Month(stod(aList5[1,6]))) + "/" + cValToChar(Year(stod(aList5[1,6])))
	Local cVencimento      := "P.O: " 
	Local cPonto           := AllTrim(StrToKarr(cTitle, "-")[2])
	Local cEmitente        := AllTrim(SM0->M0_NOMECOM)+" (CNPJ:"+AllTrim(SubStr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+SubStr(SM0->M0_CGC,6,3)+"/"+SubStr(SM0->M0_CGC,9,4)+"-"+SubStr(SM0->M0_CGC,13,2))+" - IE:"+AllTrim(SM0->M0_INSC)+")"
	Local cEndEmit         := AllTrim(SM0->M0_ENDENT)+" - "+AllTrim(SM0->M0_CIDENT)+"/"+AllTrim(SM0->M0_ESTENT)+" - "+StrTran(Transform(Val(AllTrim(SM0->M0_CEPENT)), "@E 99,999-999"), " ", "0")
	Local cEmissao         := dtoc(dDataBase)

	//Fontes
	Local oF10FFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF10TFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FTF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF10FFT          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF12FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF13FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF13TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF13FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF13FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF15FFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15TFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FTF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FFT          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF20FFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF20TFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FTF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FFT          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF25FFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25TFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FTF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FFT          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )

	cQuery := " "
	cQuery += " SELECT C5_NUM,C6_PRCVEN,C6_VALOR,C5_EMISSAO,C6_NOTA,C6_DATFAT,C6_PEDCLI " 
	cQuery += " FROM " + RetSQLName("SC5") + " " 
	cQuery += " INNER JOIN " + RetSQLName("SC6") + " ON C5_NUM = C6_NUM " 
	cQuery += " AND C5_FILIAL=C6_FILIAL " 
	cQuery += " WHERE  C5_XTPPED = 'L' "
	cQuery += " AND C5_CLIENTE = '" + aList[oList:nAt,3] + "' " 
	cQuery += " AND C5_LOJACLI = '" + aList[oList:nAt,4] + "' " 
	cQuery += " AND C5_EMISSAO BETWEEN '" + "20" + substr(cPeri,3,2) + Substr(cPeri,1,2) + "01" + "' " 
	cQuery += " AND '" + "20" + substr(cPeri,3,2) + Substr(cPeri,1,2) + "31" + "' " 
	cQuery += " AND C6_NOTA != '' " 
	cQuery += " AND C6_CONTRT == '" + aList[oList:nAt,contrato] + "' " 

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	while !EOF()

		aAux := {TRB->C5_NUM,TRB->C5_EMISSAO,TRB->C6_PRCVEN,TRB->C6_VALOR,TRB->C6_NOTA,TRB->C6_DATFAT,TRB->C6_PEDCLI}
				//aAux[1]    aAux[2]         aAux[3]        aAux[4]       aAux[5]      aAux[6]        aAux[7]

		lOK := .T.
		DBSKIP()
	end

	if !lOK
		MsgAlert("Maquina sem Pedido de Venda, nao foi possivel gerar o recibo!", "Erro!")
		RETURN
	endif

	cNum := aAux[1]
	cEmissao := dtoc(stod(aAux[2]))
	cValor += cValToChar(aAux[3])
	cValor += cValToChar(aAux[4])
	cNota := aAux[5]
	cMes := mesextenso(month(stod(aAux[6])))
	cVencimento += AllTrim(aAux[7])

	Private oPrinter := FWMSPrinter():New( "recibo_loc_"+cNum+".pdf",IMP_PDF,lAdjustToLegacy,"C:\temp\",lDisableSetup,,,,,,,, )

	oPrinter:StartPage()
	oPrinter:SetMargin( 000, 000, 000, 000 )

	oBrush1 := TBrush():New( , rgb(237, 237, 237) )
	oPrinter:Fillrect( { 26, 500, 74, 590 }, oBrush1, "-2")

	oPrinter:Box( 25, 5, 25, 590, "-9" )
	oPrinter:Say( 55, 125,"FATURA " + cNum + " - LOCAÇÃO DE " + Upper(cMes), oF20TFF )
	oPrinter:Say( 35, 510,"NÚMERO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 55, 530,cNum, oF20TFF )
	oPrinter:Box( 75, 5, 75, 590, "-9" )
	oPrinter:Box( 25, 500, 75, 500, "-9" )

	oPrinter:Box( 75, 500, 150, 500, "-1" )
	oPrinter:Say( 85, 10,"RECEBEMOS DE", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 100, 10,cCli, oF13FFF,, /*Cor*/ )
	oPrinter:Say( 115, 10,cEnd, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 85, 510,"CNPJ OU CPF", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 95, 510,cCnpj, oF13FFF,, /*Cor*/ )

	oPrinter:Box( 150, 5, 150, 590,"-1" )
	oPrinter:Say( 160, 10,"O VALOR DE", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 175, 10,cValor, oF13FFF,, /*Cor*/ )

	oPrinter:Box( 200, 5, 200, 590,"-1" )
	oPrinter:Say( 210, 10,"REFERENTES A", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 225, 10,cPeriodo, oF13FFF,, /*Cor*/ )
	oPrinter:Say( 240, 10,cVencimento, oF13FFF,, /*Cor*/ )

	oPrinter:Box( 250, 5, 250, 590,"-1" )
	oPrinter:Say( 260, 10,"DETALHAMENTO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 275, 10,cPonto, oF13FFF,, /*Cor*/ )
	oPrinter:Say( 275, 500,cValor, oF13FFF,, /*Cor*/ )

	oPrinter:Box( 300, 5, 300, 590,"-1" )
	oPrinter:Say( 310, 10,"EMITENTE", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 325, 10,cEmitente, oF13FFF,, /*Cor*/ )
	oPrinter:Say( 340, 10,cEndEmit, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )

	oPrinter:Fillrect( { 350, 300, 400, 590 }, oBrush1, "-2")
	oPrinter:Box( 350, 5, 350, 590,"-1" )
	oPrinter:Box( 350, 300, 400, 300,"-1" )
	oPrinter:Box( 400, 5, 400, 590,"-1" )
	oPrinter:Say( 360, 10,"DATA DE EMISSÃO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 375, 10,cEmissao, oF13FFF,, /*Cor*/ )
	oPrinter:Say( 360, 310,"ASSINATURA", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )

	oPrinter:Say( 735, 5,"_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ", oF10FFF )
	oPrinter:Box( 750, 100, 750, 590,"-1" )
	oPrinter:Box( 785, 100, 785, 590,"-1" )
	oPrinter:Box( 825, 100, 825, 590,"-1" )
	oPrinter:Box( 750, 300, 785, 420,"-1" )
	oPrinter:Box( 750, 420, 785, 500,"-1" )
	oPrinter:Box( 750, 420, 825, 420,"-1" )
	oPrinter:Fillrect( { 750, 30, 825, 85 }, oBrush1, "-2")
	oPrinter:Say( 760, 43,"NÚMERO", oF10TFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 820, 12,"COMPROVANTE", oF10FFF,, /*Cor*/, 270 /*Angulo*/ )
	oPrinter:Say( 820, 22,"   DE ENTREGA", oF10FFF,, /*Cor*/, 270 /*Angulo*/ )
	oPrinter:Say( 760, 110,"DESTINATÁRIO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 760, 305,"CNPJ OU CPF", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 760, 425,"EMISSÃO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 760, 505,"VALOR", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 795, 110,"RECEBIDO POR", oF10TFF,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 795, 175,"(nome e assinatura, por gentileza)", oF10FFT,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 795, 425,"DATA", oF10TFF,, rgb(102, 102, 102)/*Cor*/ )

	oPrinter:EndPage()
	oPrinter:Print()

Return

Static Function ExtLeitura()

	Local lAdjustToLegacy  := .F.
	Local lDisableSetup    := .T.
	Local aPontos          := {}
	Local aAux             := {}
	Local aProd            := {}
	Local cEntre           := ""
	Local cCon1            := ""
	Local cQuery           := ""
	Local nCon1            := 0
	// Local cSub1            := ""
	// Local nSub1            := 0
	// Local cConRS1          := ""
	// Local nConRS1          := 0
	Local cTot1            := ""
	Local nTot1            := 0
	Local cProd            := ""
	Local nMin             := 99999999
	Local nMax             := 0
	Local nX               := 0
	Local nY               := 0
	Local nLin             := 0

	//Fontes
	Local oF10FFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10TFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FTF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FFT          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF12FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF12FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF15FFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF15TFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FTF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FFT          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF20FFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20TFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FTF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FFT          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF25FFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF25TFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FTF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FFT          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )

	Private oPrinter := FWMSPrinter():New( "extrato_leitura_.pdf",IMP_PDF,lAdjustToLegacy,"C:\temp\",lDisableSetup,,,,,,,, )

	//SELECT Z08_COD,Z07_CHAPA,Z08_NUMSER,Z08_QTDLID,Z07_VLRVND,Z07_CONSUM,Z08_PRODUT,Z07_CODPRO,Z08_SELECA FROM Z08010 INNER JOIN Z07010 ON Z08_NUMSER = Z07_CHAPA AND Z08_SELECA = Z07_SELECA WHERE  Z07_CHAPA IN ('0669','0564') AND Z08_PERIOD = '1122'

	cQuery := " "
	cQuery += " SELECT Z08_COD,Z07_CHAPA,Z08_NUMSER,Z08_QTDLID,Z07_VLRVND,Z07_CONSUM,Z08_PRODUT,Z07_CODPRO,Z08_SELECA,AAN_CONTRT,AAN_ITEM   " 
	cQuery += " FROM   " + RetSQLName("Z08") + " Z08   " 
	cQuery += " INNER JOIN " + RetSQLName("Z07") + " Z07 ON Z08_NUMSER = Z07_CHAPA   " 
	cQuery += "        AND Z08_SELECA = Z07_SELECA   " 
	cQuery += " INNER JOIN " + RetSQLName("AAN") + " AAN ON Z07_CHAPA = AAN_XCBASE   " 
	cQuery += " WHERE  Z07_CHAPA IN (" + aChapas + ")   " 
	cQuery += "        AND Z08_PERIOD = '" + cPeri + "'   " 
	cQuery += "        AND Z07.D_E_L_E_T_ = ' '   " 
	cQuery += "        AND Z08.D_E_L_E_T_ = ' '   " 
	cQuery += "        AND AAN.D_E_L_E_T_ = ' '   " 
	cQuery += " ORDER BY  Z08_COD,Z07_CHAPA,Z08_SELECA   " 

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	while !EOF()
		Aadd(aAux, {TRB->Z08_COD,TRB->Z07_CHAPA,TRB->Z08_QTDLID,TRB->Z07_VLRVND,TRB->Z07_CONSUM,TRB->Z08_PRODUT,TRB->Z08_SELECA,TRB->AAN_CONTRT,AAN_ITEM})
		DBSKIP()
	end

	//Replicar aPontos por meio da query para trazer dados faltantes

	for nX := 1 to len(aList5B)
		if len(aList5B[nX]) > 4
			Aadd(aPontos, aList5B[nX])
		endif
	next

	Asort(aPontos,,,{|x,y| x[2] < y[2]})

	for nX := 1 to len(aPontos)
		for nY := 5 to len(aPontos[nX])
			if nMin > Val(aPontos[nX,nY,6])
				nMin := Val(aPontos[nX,nY,6])
			elseif nMax < Val(aPontos[nX,nY,6])
				nMax := Val(aPontos[nX,nY,6])
			endif
		next
	next

	cEntre := DTOC(STOD(cValToChar(nMin))) + "e" + DTOC(STOD(cValToChar(nMax)))

	nCon1 := 0
	// nSub1 := 0
	// nConRS1 := 0
	nTot1 := 0

	for nX := 1 to len(aPontos)
		for nY := 5 to len(aPontos[nX])
			nCon1 += aPontos[nX,nY,8]
			// nSub1 += aPontos[nX,nY,8]
			// nConRS1 += aPontos[nX,nY,8]
			nTot1 += aPontos[nX,nY,10]
		next
	next

	cCon1 := cValToChar(nCon1)
	// cSub1 := cValToChar(nSub1)
	// cConRS1 := cValToChar(nConRS1)
	cTot1 := cValToChar(nTot1)

	oPrinter:StartPage()
	oPrinter:SetMargin( 005, 005, 005, 005 )

	oBrush1 := TBrush():New( , rgb(0, 0, 0) )
	oBrush2 := TBrush():New( , rgb(238, 238, 238) )
	oBrush3 := TBrush():New( , rgb(0, 99, 125) )

	oPrinter:Say( nLin+=40, 10,"Extrato de Leituras", oF25TFF,, rgb(0, 99, 125) )
	oPrinter:Say( nLin+=10, 10,"Realizadas entre " + cEntre, oF12FFT,, rgb(102, 102, 102) )

	oPrinter:Fillrect( { nLin+=30, 10, nLin+30, 590 }, oBrush2, "-2")
	oPrinter:Fillrect( { nLin+=10, 20, nLin+10, 30 }, oBrush1, "-2")
	oPrinter:Say( nLin+5, 45,"TOTAL GERAL", oF15TFF )
	oPrinter:Say( nLin+15, 45,"Totalizando 1 Cliente", oF10FFF )

	oPrinter:Say( nLin+=10, 360,cCon1, oF10FFF )
	// oPrinter:Say( nLin, 410,cSub1, oF10FFF )
	// oPrinter:Say( nLin, 480,cConRS1, oF10FFF )
	oPrinter:Say( nLin, 550,cTot1, oF10FFF )

	oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
	oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
	oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
	oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
	oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
	oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

	for nX := 1 to len(aPontos)
		for nY := 5 to len(aPontos[nX])
			Aadd(aProd, aPontos[nX,nY])
		next
	next

	Asort(aProd,,,{|x,y| x[2] < y[2]})

	for nX := 1 to len(aProd)
		if aProd[nX,2] == cProd
			for nY := 1 to len(aAux)
				if aAux[nY,2] == aProd[nX,2]
					aAux[nY,8] += aProd[nX,8]
					aAux[nY,10] += aProd[nX,10]
				endif
			next
		else
			Aadd(aAux, aProd[nX])
			cProd := aProd[nX,2]
		endif
	next

	// for nX := 1 to len(aProd)
		
	// 	cQuery := " "
	// 	cQuery += " SELECT DA1_CODPRO,DA1_PRCVEN,DA1_XCONSU " 
	// 	cQuery += " FROM " + RetSQLName("DA1") + " INNER JOIN " + RetSQLName("AAM") + " ON AAM_XCODTA = DA1_CODTAB " 
	// 	cQuery += " AND AAM_FILIAL = '" + xFilial("AAM") + "' " 
	// 	cQuery += " WHERE AAM_CONTRT = '" + aList3[1,5] + "' " 
	// 	cQuery += " AND DA1_CODPRO = '" + aProd[nX,2] + "' " 
	// 	cQuery += " AND DA1_FILIAL = '" + xFilial("DA1") + "' " 

	// 	If Select("TRB") > 0
	// 		dbSelectArea("TRB")
	// 		dbCloseArea()
	// 	EndIf

	// 	cQuery := ChangeQuery(cQuery)

	// 	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	// 	while !EOF()
	// 		Aadd(aProd[nX], TRB->DA1_PRCVEN)
	// 		Aadd(aProd[nX], TRB->DA1_XCONSU)
	// 		DBSKIP()
	// 	end

	// next
		
	nCon1 := 0
	// nSub1 := 0
	// nConRS1 := 0
	nTot1 := 0

	for nX := 1 to len(aAux)
		nCon1 += aAux[nX,8]
		// nSub2 += aAux[nX,2]
		// nConRS2 += aAux[nX,2]
		nTot1 += aAux[nX,10]
	next

	cCon1 := cValToChar(nCon1)
	// cSub1 := cValToChar(nSub1)
	// cConRS1 := cValToChar(nConRS1)
	cTot1 := cValToChar(nTot1)

	for nX := 1 to len(aPontos)
		for nY := 5 to len(aPontos[nX])
			oPrinter:Say( nLin+=20, 45,aPontos[nX,nY,2], oF10FFF )
			oPrinter:Say( nLin, 100,AllTrim(aPontos[nX,nY,3]), oF10FFF )
			oPrinter:Say( nLin, 360,cValToChar(aPontos[nX,nY,8]), oF10FFF )
			oPrinter:Say( nLin, 410,"0000", oF10FFF )
			oPrinter:Say( nLin, 480,"0000", oF10FFF )
			oPrinter:Say( nLin, 550,cValToChar(aPontos[nX,nY,10]), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		next
	next

	oPrinter:Fillrect( { nLin+=20, 10, nLin+30, 590 }, oBrush3, "-2")

	oPrinter:Say( nLin+12, 30,SubStr(aList[oList:nAt,5],1,55), oF12FFF,, rgb(238, 238, 238) )
	oPrinter:Say( nLin+24, 30,AllTrim(aList[oList:nAt,3]) + "-" + AllTrim(aList[oList:nAt,4]), oF10FFF,, rgb(238, 238, 238) )

	oPrinter:Say( nLin+=60, 10,"CONSOLIDADO", oF15FFF )
	oPrinter:Fillrect( { nLin+=5, 10, nLin, 590 }, oBrush1, "-2")
	oPrinter:Fillrect( { nLin+=15, 10, nLin+30, 590 }, oBrush2, "-2")
	oPrinter:Fillrect( { nLin+10, 20, nLin+20, 30 }, oBrush3, "-2")
	oPrinter:Say( nLin+15, 40,SubStr(aList[oList:nAt,5],1,55), oF12FFF )
	oPrinter:Say( nLin+25, 40,"Totalizando " + cValToChar(len(aList2)) + " Pontos de Venda", oF10FFF )
	oPrinter:Say( nLin+=15, 360,cCon1, oF10FFF )
	// oPrinter:Say( nLin, 410,cSub1, oF10FFF )
	// oPrinter:Say( nLin, 480,cConRS1, oF10FFF )
	oPrinter:Say( nLin, 550,cTot1, oF10FFF )

	oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
	oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
	oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
	oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
	oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
	oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

	for nX := 1 to len(aProd)
		oPrinter:Say( nLin+=20, 45,aProd[nX,2], oF10FFF )
		oPrinter:Say( nLin, 100,AllTrim(aProd[nX,3]), oF10FFF )
		oPrinter:Say( nLin, 360,cValToChar(aProd[nX,8]), oF10FFF )
		// oPrinter:Say( nLin, 410,"0000", oF10FFF ) //Pendente Subsidiado
		// oPrinter:Say( nLin, 480,"0000", oF10FFF ) //Pendente Consumo - Subsidiado
		oPrinter:Say( nLin, 550,cValToChar(aProd[nX,10]), oF10FFF )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
	next

	for nX := 1 to len(aPontos)

		oPrinter:StartPage()

		nCon1 := 0
		// nSub1 := 0
		// nConRS1 := 0
		nTot1 := 0

		for nY := 5 to len(aPontos[nX])
			nCon1 += aPontos[nX,nY,8]
			// nSub1 := aPontos[nX,nY,8]
			// nConRS1 := aPontos[nX,nY,8]
			nTot1 += aPontos[nX,nY,10]
		next

		cCon1 := cValToChar(nCon1)
		// cSub1 := cValToChar(nSub1)
		// cConRS1 := cValToChar(nConRS1)
		cTot1 := cValToChar(nTot1)

		oPrinter:Say( nLin:=20, 10,". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .", oF25TFF,, rgb(0, 99, 125) )
		oPrinter:Say( nLin+=15, 10,"PONTO DE VENDA", oF15FFF )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush1, "-2")
		oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
		oPrinter:Fillrect( { nLin+20, 30, nLin+30, 20 }, oBrush1, "-2")
		oPrinter:Say( nLin+25, 40,SubStr(aList[oList:nAt,5],1,55), oF12FFF )
		oPrinter:Say( nLin+35, 40,AllTrim(aPontos[nX,2]), oF10FFF )
		oPrinter:Say( nLin+25, 360,cCon1, oF10FFF )
		// oPrinter:Say( nLin+25, 410,cSub1, oF10FFF ) //Pendente Subsidio
		// oPrinter:Say( nLin+25, 480,cConRS1, oF10FFF ) //Pendente Consumido - subsidio
		oPrinter:Say( nLin+25, 550,cTot1, oF10FFF )

		oPrinter:Say( nLin+=50, 25,"Mola", oF10FFF )
		oPrinter:Say( nLin, 50,"Produto", oF10FFF )
		oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
		oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
		oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

		for nY := 5 to len(aPontos[nX])

			if nLin > 800
				nLin := 0
				oPrinter:StartPage()
			endif

			oPrinter:Say( nLin+=20, 25,aPontos[nX,nY,1], oF10FFF )
			oPrinter:Say( nLin, 50,AllTrim(aPontos[nX,nY,2]), oF10FFF )
			oPrinter:Say( nLin, 100,AllTrim(aPontos[nX,nY,3]), oF10FFF )
			oPrinter:Say( nLin, 360,cValToChar(aPontos[nX,nY,8]), oF10FFF )
			// oPrinter:Say( nLin, 410,"cSubsidi", oF10FFF ) //Pendente Subsidio
			// oPrinter:Say( nLin, 480,"cConsumi", oF10FFF ) //Pendente Consumido - subsidio
			oPrinter:Say( nLin, 550,cValToChar(aPontos[nX,nY,10]), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		next

		nCon1 := 0
		nTot1 := 0

		for nY := 5 to len(aPontos[nX])
			nCon1 += aPontos[nX,nY,8]
			nTot1 += aPontos[nX,nY,10]
		next

		cCon1 := CValToChar(nCon1)
		cTot1 := CValToChar(nTot1)

		oPrinter:Say( nLin+=30, 10,"Leituras no Período", oF15FFF )
		oPrinter:Fillrect( { nLin-2.5, 120, nLin, 590 }, oBrush1, "-6")
		oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
		oPrinter:Say( nLin+=25, 15,"22/11/22 10:00", oF15TFF )
		oPrinter:Say( nLin, 100,"cCod", oF10FFF ) //Pendente codigo?
		oPrinter:Say( nLin, 360,cCon1, oF10FFF )
		// oPrinter:Say( nLin, 410,"cTotSub", oF10FFF ) //Pendente total subsidio
		// oPrinter:Say( nLin, 480,"cTotConsu", oF10FFF ) //Pendente total consumido - subsidio
		oPrinter:Say( nLin, 550,cTot1, oF10FFF )

		oPrinter:Say( nLin+=30, 25,"Mola", oF10FFF )
		oPrinter:Say( nLin, 50,"Produto", oF10FFF )
		oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
		oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
		oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

		for nY := 5 to len(aPontos[nX])

			if nLin > 800
				nLin := 0
				oPrinter:StartPage()
			endif

			oPrinter:Say( nLin+=20, 25,aPontos[nX,nY,1], oF10FFF )
			oPrinter:Say( nLin, 50,aPontos[nX,nY,2], oF10FFF )
			oPrinter:Say( nLin, 100,aPontos[nX,nY,3], oF10FFF )
			oPrinter:Say( nLin, 360,cValToChar(aPontos[nX,nY,8]), oF10FFF )
			// oPrinter:Say( nLin, 410,"cSubsidi", oF10FFF ) //Pendente Subsidio
			// oPrinter:Say( nLin, 480,"cConsumi", oF10FFF ) //Pendente Consumo - subsidio
			oPrinter:Say( nLin, 550,cValToChar(aPontos[nX,nY,10]), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		next
	next

	oPrinter:EndPage()
	oPrinter:Print()

Return

Static Function DemonsCon()

	Local lAdjustToLegacy  := .F.
	Local lDisableSetup    := .T.
	Local aPontos          := {}
	Local aProd            := {}
	Local aAux             := {}
	Local cQuery           := ""
	Local cProd            := ""
	Local cCon1            := ""
	Local nCon1            := 0
	Local cUni1            := ""
	Local nUni1            := 0
	Local cTot1            := ""
	Local nTot1            := 0
	Local nX               := 0
	Local nY               := 0
	Local nLin             := 0
	Local nTot             := 0

	//Fontes
	Local oF10FFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10TFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FTF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FFT          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF12FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF15FFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF15TFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FTF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FFT          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF20FFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF20TFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FTF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FFT          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF25FFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF25TFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FTF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF25FFT          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )

	Private oPrinter := FWMSPrinter():New( "demons_consumo_.pdf",IMP_PDF,lAdjustToLegacy,"C:\temp\",lDisableSetup,,,,,,,, )

	for nX := 1 to len(aList5B)
		if len(aList5B[nX]) > 4
			Aadd(aPontos, aList5B[nX])
		endif
	next

	for nX := 1 to len(aPontos)
		for nY := 5 to len(aPontos[nX])
			Aadd(aPontos[nX,nY], aPontos[nX,2])
			Aadd(aProd, aPontos[nX,nY])
		next
	next

	Asort(aProd,,,{|x,y| x[2] < y[2]})

	oPrinter:StartPage()
	oPrinter:SetMargin( 005, 005, 005, 005 )

	oBrush1 := TBrush():New( , rgb(0, 0, 0) )
	oBrush2 := TBrush():New( , rgb(238, 238, 238) )
	oBrush3 := TBrush():New( , rgb(0, 99, 125) )

	oPrinter:Say( nLin+=20, 125,AllTrim(SM0->M0_NOMECOM), oF15TFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+12, 125,Transform(val(AllTrim(SM0->M0_CGC)), "@E 99,999,999/9999-99"), oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+24, 125,AllTrim(SM0->M0_ENDENT), oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+36, 125,StrTran(Transform(val(AllTrim(SM0->M0_CEPENT)), "@E 99,999-999"), " ", "0")+" - "+AllTrim(SM0->M0_CIDENT)+"-"+AllTrim(SM0->M0_ESTENT), oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+48, 125,IF((len(AllTrim(SM0->M0_TEL)) > 10), Transform(val(AllTrim(SM0->M0_TEL)), "@E (99) 99999-9999"), Transform(val(AllTrim(SM0->M0_TEL)), "@E (99) 9999-9999")), oF15FFF,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin+=55, 10, nLin, 590 }, oBrush1, "-2")
	oPrinter:Box( nLin+=20, 30, nLin+100, 350,"-1" )

	cQuery := " SELECT A1_CEP,A1_CGC,A1_MUN,A1_EST "
	cQuery += " FROM SA1010 "
	cQuery += " WHERE A1_COD = '" + aList[oList:nAt,3] + "' AND A1_LOJA = '" + aList[oList:nAt,4] + "' "

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	while !EOF()
		aAux := {AllTrim(TRB->A1_CEP),AllTrim(TRB->A1_CGC),AllTrim(TRB->A1_MUN),AllTrim(TRB->A1_EST)}
		DBSKIP()
	end

	oPrinter:Say( nLin+20, 35,SubStr(aList[oList:nAt,5],1 ,30), oF20TFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+32, 35,Transform(val(aAux[2]), "@E 99,999,999/9999-99"), oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+44, 35,aList[oList:nAt,6], oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+56, 35,Transform(val(aAux[1]), "@E 99999-999") + " - " + AllTrim(aAux[3]) + "-" + aAux[4], oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+68, 35,"Este é o seu demonstrativo de consumo para o período", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+80, 35,"de " + dtoc(stod(aProd[1,4])) + " a " + dtoc(stod(aProd[1,6])) + " ", oF15FFF,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin, 360, nLin+100, 570 }, oBrush2, "-1")

	for nX := 1 to len(aProd)
		nTot += aProd[nX,10]
	next

	oPrinter:Say( nLin+40, 430,Transform(nTot, "@E 999,999.99"), oF25TFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+52, 400,"vencimento em 22/12/22", oF15FFF,, rgb(0, 0, 0) ) //Pendente vencimento
	oPrinter:Say( nLin+64, 410,"pagamento via Boleto", oF15FFF,, rgb(0, 0, 0) ) //Pendente pagamento

	// oPrinter:Fillrect( { nLin+=100, 10, nLin, 590 }, oBrush2, "-1")

	aAux := {}
	Aadd(aAux, {})
	cProd := aProd[1,2]

	for nX := 1 to len(aProd)
		if aProd[nX,2] == cProd
			Aadd(aAux[len(aAux)], aProd[nX])
		else
			Aadd(aAux, {})
			Aadd(aAux[len(aAux)], aProd[nX])
		endif
		cProd := aProd[nX,2]
	next
	//Cabeçalho
	oPrinter:Say( nLin+=120, 400,"Consumo", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin, 400+70,"Unitário (R$)", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin, 400+70+70,"Total (R$)", oF15FFF,, rgb(0, 0, 0) )

	for nX := 1 to len(aAux)

		if nLin > 800
			nLin := 0
			oPrinter:StartPage()
		endif

		nCon1 := 0
		nTot1 := 0
		nUni1 := 0

		for nY := 1 to len(aAux[nX])
			nCon1 += aAux[nX,nY,8]
			nUni1 += aAux[nX,nY,9]
			nTot1 += aAux[nX,nY,10]
		next

		cCon1 := CValToChar(nCon1)
		cUni1 := CValToChar(nUni1)
		cTot1 := CValToChar(nTot1)

		//Totalizadores
		oPrinter:Fillrect( { nLin+5, 10, nLin+25, 590 }, oBrush2, "-1")
		oPrinter:Say( nLin+=20, 30,AllTrim(aAux[nX,1,3]), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 400,Transform(val(cCon1), "@E 999,999"), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 400+70,Transform(val(cUni1), "@E 999,999.99"), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 400+70+70,Transform(val(cTot1), "@E 999,999.99"), oF15FFF,, rgb(0, 0, 0) )

		for nY := 1 to len(aAux[nX])

			if nLin > 800
				nLin := 0
				oPrinter:StartPage()
			endif

			oPrinter:Say( nLin+=20, 30,dtoc(stod(aAux[nX,nY,6])) + " em " + aAux[nX,nY,15] + " - MÁQ " + aAux[nX,nY,15], oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 400,Transform(aAux[nX,nY,8], "@E 999,999"), oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 400+70,Transform(aAux[nX,nY,9], "@E 999,999.99"), oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 400+70+70,Transform(aAux[nX,nY,10], "@E 999,999.99"), oF10FFF,, rgb(0, 0, 0) )
		next
	next

	oPrinter:EndPage()
	oPrinter:Print()

Return
