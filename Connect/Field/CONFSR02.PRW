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
User Function CONFSR02(aXList,aXList2,aXList3,aXList4,aXList5,cXTitle,nOpc)

	Local aCombo := {"1=Extrato de Leitura", "2=Demonstrativo de Consumo", "3=Todos" }
	Local aPergs := {}
	Local dDtDe  := CTOD(" / / ")
	Local dDtAt  := CTOD(" / / ")

	Private aList := aXList
	Private aList2 := aXList2
	Private aList3 := aXList3
	Private aList4 := aXList4
	Private aList5 := aXList5
	Private cTitle := cXTitle

	Default nOpc := 0

	aAdd( aPergs ,{2,"Escolha uma opção : ",0,aCombo,100,"",.T.})
	aAdd( aPergs ,{1,"Leitura De : ", dDtDe,"@!",'.T.',"AANX",'.T.',40,.T.})
	aAdd( aPergs ,{1,"Leitura Até : ", dDtAt,"@!",'.T.',"AANX",'.T.',40,.T.})

	if nOpc == 0
		If !ParamBox(aPergs ,"Parametros ")
			Return
		EndIf
	endif

	if MV_PAR01 == "1" .OR. nOpc == 1
		ExtLeitura()
	elseif MV_PAR01 == "2" .OR. nOpc == 2
		DemonsCon()
	elseif MV_PAR01 == "3" .OR. nOpc == 3
		ExtLeitura()
		DemonsCon()
	endif

Return

Static Function ExtLeitura()

	Local lAdjustToLegacy  := .F.
	Local lDisableSetup    := .T.
	Local aPontos          := {}
	Local aAux             := {}
	Local aProd            := {}
	Local cEntre           := ""
	Local cCon1            := ""
	Local nCon1            := 0
	Local cSub1            := ""
	Local nSub1            := 0
	Local cConRS1          := ""
	Local nConRS1          := 0
	Local cTot1            := ""
	Local nTot1            := 0
	Local cProd            := ""
	// Local nMin             := 99999999
	// Local nMax             := 0
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

	//Replicar aPontos por meio da query para trazer dados faltantes

	for nX := 1 to len(aList5B)
		if len(aList5B[nX]) > 4
			Aadd(aPontos, aList5B[nX])
		endif
	next

	Asort(aPontos,,,{|x,y| x[2] < y[2]})

	//cEntre := DTOC(STOD(aPontos[1,5,4])) + " e " + DTOC(STOD(aPontos[1,5,6]))
	cEntre := DTOC(MV_PAR02) + " e " + DTOC(MV_PAR03)

	nCon1 := 0
	nSub1 := 0
	nConRS1 := 0
	nTot1 := 0

	for nX := 1 to len(aPontos)
		for nY := 5 to len(aPontos[nX])
			nCon1 += aPontos[nX,nY,8]
			nSub1 += aPontos[nX,nY,9]
			nConRS1 += aPontos[nX,nY,15]
			nTot1 += aPontos[nX,nY,10]
		next
	next

	cCon1 := cValToChar(nCon1)
	cSub1 := cValToChar(nSub1)
	cConRS1 := cValToChar(nConRS1)
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
		
	nCon1 := 0
	nSub1 := 0
	nConRS1 := 0
	nTot1 := 0

	for nX := 1 to len(aAux)
		nCon1 += aAux[nX,8]
		nSub1 += aAux[nX,9] * aAux[nX,8]
		nConRS1 += aAux[nX,15] * aAux[nX,8]
		nTot1 += aAux[nX,10]
	next

	cCon1 := cValToChar(nCon1)
	cSub1 := cValToChar(nSub1)
	cConRS1 := cValToChar(nConRS1)
	cTot1 := cValToChar(nTot1)

	oPrinter:Say( nLin+=10, 360,cCon1, oF10FFF )
	oPrinter:Say( nLin, 410,transform(val(cSub1), "@E 99,999.99"), oF10FFF )
	oPrinter:Say( nLin, 480,transform(val(cConRS1), "@E 99,999.99"), oF10FFF )
	oPrinter:Say( nLin, 550,transform(val(cTot1), "@E 99,999.99"), oF10FFF )

	oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
	oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
	oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
	oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
	oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
	oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

	for nX := 1 to len(aAux)
		oPrinter:Say( nLin+=20, 45,aAux[nX,2], oF10FFF )
		oPrinter:Say( nLin, 100,AllTrim(aAux[nX,3]), oF10FFF )
		oPrinter:Say( nLin, 360,cvaltochar(aAux[nX,8]), oF10FFF )
		oPrinter:Say( nLin, 410,Transform(aAux[nX,9]*aAux[nX,8], "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 480,Transform(aAux[nX,15]*aAux[nX,8], "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 550,Transform(aAux[nX,10], "@E 99,999.99"), oF10FFF )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
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
	oPrinter:Say( nLin, 410,Transform(val(cSub1), "@E 99,999.99"), oF10FFF )
	oPrinter:Say( nLin, 480,Transform(val(cConRS1), "@E 99,999.99"), oF10FFF )
	oPrinter:Say( nLin, 550,Transform(val(cTot1), "@E 99,999.99"), oF10FFF )

	oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
	oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
	oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
	oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
	oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
	oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

	for nX := 1 to len(aAux)
		oPrinter:Say( nLin+=20, 45,aAux[nX,2], oF10FFF )
		oPrinter:Say( nLin, 100,AllTrim(aAux[nX,3]), oF10FFF )
		oPrinter:Say( nLin, 360,cvaltochar(aAux[nX,8]), oF10FFF )
		oPrinter:Say( nLin, 410,Transform(aAux[nX,9]*aAux[nX,8], "@E 99,999.99"), oF10FFF ) //Pendente Subsidiado
		oPrinter:Say( nLin, 480,Transform(aAux[nX,15]*aAux[nX,8], "@E 99,999.99"), oF10FFF ) //Pendente Consumo - Subsidiado
		oPrinter:Say( nLin, 550,Transform(aAux[nX,10], "@E 99,999.99"), oF10FFF )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
	next

	for nX := 1 to len(aPontos)

		oPrinter:StartPage()

		nCon1 := 0
		nSub1 := 0
		nConRS1 := 0
		nTot1 := 0

		for nY := 5 to len(aPontos[nX])
			nCon1 += aPontos[nX,nY,8]
			nSub1 += aPontos[nX,nY,9] * aPontos[nX,nY,8]
			nConRS1 += aPontos[nX,nY,15] * aPontos[nX,nY,8]
			nTot1 += aPontos[nX,nY,10]
		next

		cCon1 := cValToChar(nCon1)
		cSub1 := cValToChar(nSub1)
		cConRS1 := cValToChar(nConRS1)
		cTot1 := cValToChar(nTot1)

		oPrinter:Say( nLin:=20, 10,". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .", oF25TFF,, rgb(0, 99, 125) )
		oPrinter:Say( nLin+=15, 10,"PONTO DE VENDA", oF15FFF )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush1, "-2")
		oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
		oPrinter:Fillrect( { nLin+20, 30, nLin+30, 20 }, oBrush1, "-2")
		oPrinter:Say( nLin+25, 40,SubStr(aList[oList:nAt,5],1,55), oF12FFF )
		oPrinter:Say( nLin+35, 40,AllTrim(aPontos[nX,2]), oF10FFF )
		oPrinter:Say( nLin+25, 360,cCon1, oF10FFF )
		oPrinter:Say( nLin+25, 410,Transform(val(cSub1), "@E 99,999.99"), oF10FFF ) //Pendente Subsidio
		oPrinter:Say( nLin+25, 480,Transform(val(cConRS1), "@E 99,999.99"), oF10FFF ) //Pendente Consumido - subsidio
		oPrinter:Say( nLin+25, 550,Transform(val(cTot1), "@E 99,999.99"), oF10FFF )

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
			oPrinter:Say( nLin, 360,cvaltochar(aPontos[nX,nY,8]), oF10FFF )
			oPrinter:Say( nLin, 410,Transform(aPontos[nX,nY,9]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //Pendente Subsidio
			oPrinter:Say( nLin, 480,Transform(aPontos[nX,nY,15]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //Pendente Consumido - subsidio
			oPrinter:Say( nLin, 550,Transform(aPontos[nX,nY,10], "@E 99,999.99"), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		next

		nCon1 := 0
		nSub1 := 0
		nConRS1 := 0
		nTot1 := 0

		for nY := 5 to len(aPontos[nX])
			nCon1 += aPontos[nX,nY,8]
			nSub1 += aPontos[nX,nY,9] * aPontos[nX,nY,8]
			nConRS1 += aPontos[nX,nY,15] * aPontos[nX,nY,8]
			nTot1 += aPontos[nX,nY,10]
		next

		cCon1 := CValToChar(nCon1)
		cSub1 := CValToChar(nSub1)
		cConRS1 := CValToChar(nConRS1)
		cTot1 := CValToChar(nTot1)

		oPrinter:Say( nLin+=30, 10,"Leituras no Período", oF15FFF )
		oPrinter:Fillrect( { nLin-2.5, 120, nLin, 590 }, oBrush1, "-6")
		oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
		oPrinter:Say( nLin+=25, 15,dtoc(Stod(aPontos[nX,5,6])), oF15TFF )
		oPrinter:Say( nLin, 100,cvaltochar(val(aPontos[nX,5,11])), oF10FFF ) //Pendente codigo?
		oPrinter:Say( nLin, 360,cCon1, oF10FFF )
		oPrinter:Say( nLin, 410,transform(val(cSub1), "@E 99,999.99"), oF10FFF ) //Pendente total subsidio
		oPrinter:Say( nLin, 480,transform(val(cConRS1), "@E 99,999.99"), oF10FFF ) //Pendente total consumido - subsidio
		oPrinter:Say( nLin, 550,transform(val(cTot1), "@E 99,999.99"), oF10FFF )

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
			oPrinter:Say( nLin, 360,cvaltochar(aPontos[nX,nY,8]), oF10FFF )
			oPrinter:Say( nLin, 410,transform(aPontos[nX,nY,9]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //Pendente Subsidio
			oPrinter:Say( nLin, 480,transform(aPontos[nX,nY,15]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //Pendente Consumo - subsidio
			oPrinter:Say( nLin, 550,transform(aPontos[nX,nY,10], "@E 99,999.99"), oF10FFF )
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
	Local cLogoD           := "\SYSTEM\lgrl01.bmp"

	//Fontes
	Local oF10FFF          := TFont():New('Ambra Sans' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10TFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FTF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF10FFT          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF12FFF          := TFont():New('Ambra Sans' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12TFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FTF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF12FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF15FFF          := TFont():New('Ambra Sans' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF15TFF          := TFont():New('Ambra Sans' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FTF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF15FFT          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF20FFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF20TFF          := TFont():New('Ambra Sans' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FTF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.T. /*Sublinhado*/,.F. /*Italico*/ )
	// Local oF20FFT          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	// Local oF25FFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF25TFF          := TFont():New('Ambra Sans' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
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

	oPrinter:SayBitmap(001,020,cLogoD,075,075)

	oPrinter:Say( nLin+=20, 125,AllTrim(SM0->M0_NOMECOM), oF15TFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+12, 125,Transform(val(AllTrim(SM0->M0_CGC)), "@E 99,999,999/9999-99"), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+24, 125,AllTrim(SM0->M0_ENDENT), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+36, 125,StrTran(Transform(val(AllTrim(SM0->M0_CEPENT)), "@E 99,999-999"), " ", "0")+" - "+AllTrim(SM0->M0_CIDENT)+"-"+AllTrim(SM0->M0_ESTENT), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+48, 125,IF((len(AllTrim(SM0->M0_TEL)) > 10), Transform(val(AllTrim(SM0->M0_TEL)), "@E (99) 99999-9999"), Transform(val(AllTrim(SM0->M0_TEL)), "@E (99) 9999-9999")), oF12FFF,, rgb(0, 0, 0) )

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
	oPrinter:Say( nLin+32, 35,Transform(val(aAux[2]), "@E 99,999,999/9999-99"), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+44, 35,aList[oList:nAt,6], oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+56, 35,Transform(val(aAux[1]), "@E 99999-999") + " - " + AllTrim(aAux[3]) + "-" + aAux[4], oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+68, 35,"Este é o seu demonstrativo de consumo para o período", oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+80, 35,"de " + dtoc(stod(aProd[1,4])) + " a " + dtoc(stod(aProd[1,6])) + " ", oF12FFF,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin, 360, nLin+100, 570 }, oBrush2, "-1")

	for nX := 1 to len(aProd)
		nTot += aProd[nX,10]
	next

	oPrinter:Say( nLin+40, 380,Transform(nTot, "@E 999,999.99"), oF25TFF,, rgb(0, 0, 0) )
	// oPrinter:Say( nLin+52, 400,"vencimento em 22/12/22", oF12FFF,, rgb(0, 0, 0) ) //Pendente vencimento
	oPrinter:Say( nLin+52, 410,"Pagamento via Boleto", oF12FFF,, rgb(0, 0, 0) ) //Pendente pagamento

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
	oPrinter:Say( nLin+=120, 330,"Consumo", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin, 350+50,"Unitário (R$)", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin, 350+70+90,"Total (R$)", oF15FFF,, rgb(0, 0, 0) )

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
			nUni1 := aAux[nX,nY,9]
			nTot1 += aAux[nX,nY,10]
		next

		cCon1 := CValToChar(nCon1)
		cUni1 := CValToChar(nUni1)
		cTot1 := CValToChar(nTot1)

		//Totalizadores
		oPrinter:Fillrect( { nLin+5, 10, nLin+25, 590 }, oBrush2, "-1")
		oPrinter:Say( nLin+=20, 30,AllTrim(aAux[nX,1,3]), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 320,Transform(val(cCon1), "@E 999,999"), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 350+30,Transform(val(cUni1), "@E 999,999.99"), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 350+70+70,Transform(val(cTot1), "@E 999,999.99"), oF15FFF,, rgb(0, 0, 0) )

		for nY := 1 to len(aAux[nX])

			if nLin > 800
				nLin := 0
				oPrinter:StartPage()
			endif

			oPrinter:Say( nLin+=20, 30,dtoc(stod(aAux[nX,nY,6])) + " em " + aAux[nX,nY,16] + " - MÁQ " + aAux[nX,nY,16], oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 330,Transform(aAux[nX,nY,8], "@E 999,999"), oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 350+50,Transform(aAux[nX,nY,9], "@E 999,999.99"), oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 350+70+90,Transform(aAux[nX,nY,10], "@E 999,999.99"), oF10FFF,, rgb(0, 0, 0) )
		next
	next

	oPrinter:EndPage()
	oPrinter:Print()

Return
