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
User Function CONFSR02(cXTitle, xFatur, xPedido,nOpc,cPasta,ccnpj,ccontr,cNota)

	Local aCombo := {"1=ExtraTo de Leitura", "2=Demonstrativo de Consumo", "3=Todos" }
	Local aPergs := {}
	Local dDtDe  := CToD(" / / ")
	Local dDtAt  := CToD(" / / ")
	
	Private _aList := aClone(aList)
	Private _aList2 := aClone(aList2)
	Private _aList3 := aClone(aList3)
	Private _aList4 := aClone(aList4)
	Private _aList5 := aClone(aList5)
	Private _aList5B := aClone(aList5B)
	Private cTitle := cXTitle
	Private ccont	:=	""
	Private nOpca 	:=	0

	Default xFatur   := .F.
	Default xPedido  := ''
	Default nOpc := 0
	Default ccont := "" 
	Default cNota := ""

	nOpca	  := nOpc
	lFatur 	  := xFatur
	_cPedido  := xPedido
	ccont 	  := ccontr
	
	If nOpc == 0
		aAdd( aPergs ,{2,"Escolha uma opção : ",0,aCombo,100,"",.T.})
		aAdd( aPergs ,{1,"Leitura De : ", dDtDe,"@!",'.T.',,'.T.',40,.F.})
		aAdd( aPergs ,{1,"Leitura Até : ", dDtAt,"@!",'.T.',,'.T.',40,.F.})

		If nOpc == 0
			If !ParamBox(aPergs ,"Parametros ")
				Return
			EndIf
		EndIf

		If MV_PAR01 == "1" .OR. nOpc == 1
			ExtLeitura('',nOpc,cNota)
		ElseIf MV_PAR01 == "2" .OR. nOpc == 2
			DemonsCon()
		ElseIf MV_PAR01 == "3" .OR. nOpc == 3
			ExtLeitura('',nOpc,cNota)
			DemonsCon()
		EndIf
	else

		If SubStr(cPasta, Len(cPasta), 1) != "\"
            cPasta := cPasta+"\"+ccnpj+"\"
            If !ExistDir(cPasta)
            	Makedir(cPasta)
            EndIf
        Else
        	cPasta := cPasta+ccnpj+"\"
            If !ExistDir(cPasta)
            	Makedir(cPasta)
            EndIf
        EndIf

		ExtLeitura(cPasta,nOpc,cNota)
	EndIf

Return

Static Function ExtLeitura(cCaminho,nOpc,cNota)

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
	Local nX               := 0
	Local nY               := 0
	Local nLin             := 0

	//Fontes
	Local oF10FFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF12FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF12FFT          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF15FFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF15TFF          := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF25TFF          := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	
	Private oPrinter := FWMSPrinter():New( "extrato_leitura_"+cNota+dtos(ddatabase)+".pdf",IMP_PDF,lAdjustToLegacy,"",lDisableSetup,,,,,,,.f., )

	oPrinter:cPathPDF := If(!Empty(cCaminho),cCaminho,"C:\temp\")

	If lFatur
		cQuery := " SELECT Z08.Z08_NUMSER,Z08.Z08_PRODUT,Z08.Z08_SELECA,SB1.B1_DESC,Z08.Z08_DATA,"
		cQuery += " SUM(Z08.Z08_CONSUM) AS CONSUMO,SUM(Z08.Z08_VLRFAT) AS VALOR,"
		cQuery += " SUM(Z08.Z08_CONSUM) * DA1.DA1_XCONSU AS CONSUMIDOR,"
		cQuery += " SUM(Z08.Z08_CONSUM) * DA1.DA1_PRCVEN AS SUBSIDI,SA1.A1_NOME,SA1.A1_NREDUZ,SA1.A1_COD,SA1.A1_LOJA   " 
		cQuery += " FROM   " + RetSQLName("Z08") + " Z08   " 
		cQuery += " INNER JOIN " + RetSQLName("AAM") + " AAM ON AAM_FILIAL='"+xFilial("AAM")+"' AND AAM.AAM_CONTRT = Z08.Z08_CONTRT   " 
		cQuery += " INNER JOIN " + RetSQLName("DA1") + " DA1 ON DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.DA1_CODTAB = AAM.AAM_XCODTA   " 
		cQuery += "        AND DA1_CODPRO = Z08.Z08_PRODUT   " 
		cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.B1_COD = Z08.Z08_PRODUT   " 
		cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD = AAM.AAM_CODCLI AND SA1.A1_LOJA = AAM.AAM_LOJA   " 
		cQuery += " WHERE  Z08.Z08_PEDIDO = '" + _cPedido + "' " 
		cQuery += " AND Z08_CONTRT='"+If(nOpca==0,aList[oList:nAt,01],ccont)+"'"
		cQuery += "        AND DA1.D_E_L_E_T_ = ' '   " 
		cQuery += "        AND Z08.D_E_L_E_T_ = ' '   "
		cQuery += " GROUP BY Z08.Z08_NUMSER, Z08.Z08_SELECA,Z08.Z08_PRODUT,SB1.B1_DESC,Z08.Z08_DATA,SA1.A1_NOME,SA1.A1_NREDUZ,SA1.A1_COD,SA1.A1_LOJA,DA1.DA1_XCONSU,DA1.DA1_PRCVEN   " 
		cQuery += " ORDER BY  Z08.Z08_NUMSER,Z08.Z08_PRODUT   " 

		If Select("TRB") > 0
			dbSelectArea("TRB")

			dbCloseArea()
		EndIf

		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"ToPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
			
		DbSelectArea("TRB")   

		While !EoF()
			aAdd(aAux,{;
				TRB->Z08_NUMSER,;
				TRB->Z08_PRODUT,;
				TRB->CONSUMO,;
				TRB->VALOR,;
				TRB->SUBSIDI,;
				TRB->CONSUMIDOR,;
				TRB->B1_DESC,;
				Alltrim(TRB->A1_NOME)+" / "+Alltrim(TRB->A1_NREDUZ),;
				TRB->A1_COD,;
				TRB->A1_LOJA,;
				TRB->Z08_SELECA,;
				TRB->Z08_DATA,;
				Posicione("SB1",1,xFilial("SB1")+TRB->Z08_PRODUT,"B1_POSIPI")} )
			Dbskip()
		End

		If !(Len(aAux) > 0)
			Return
		EndIf

		aAdd(aPontos,{})

		For nX := 1 To Len(aAux)
			If aAux[nX,01] == aAux[If(nX == 01,01,nX-1),01]
				aAdd(aPontos[Len(aPontos)],aAux[nX])
			Else
				aAdd(aPontos,{aAux[nX]})
			EndIf
		Next

		cEntre := DToC(MV_PAR02) + " e " + DToC(MV_PAR03)

		nCon1 := 0
		nSub1 := 0
		nConRS1 := 0
		nTot1 := 0

		For nX := 1 To Len(aPontos)
			For nY := 1 To Len(aPontos[nX])
				nCon1 += aPontos[nX,nY,3]
				nSub1 += aPontos[nX,nY,5]
				nConRS1 += aPontos[nX,nY,6]
				nTot1 += aPontos[nX,nY,4]
			Next
		Next

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
		oPrinter:Say( nLin+5, 45,"Totaal Geral", oF15TFF )
		oPrinter:Say( nLin+15, 45,"Totalizando 1 Cliente", oF10FFF )

		For nX := 1 To Len(aPontos)
			For nY := 1 To Len(aPontos[nX])
				aAdd(aProd, aPontos[nX,nY])
			Next
		Next

		aAux := {}

		For nX := 1 to len(aProd)
			nPos := Ascan(aAux,{|x| Alltrim(x[2]) == Alltrim(aProd[nX,02])})
			If nPos == 0
				aAdd(aAux, {aProd[nX,01],;
							aProd[nX,02],;
							aProd[nX,03],;
							aProd[nX,04],;
							aProd[nX,05],;
							aProd[nX,06],;
							aProd[nX,07],;
							aProd[nX,08],;
							aProd[nX,09],;
							aProd[nX,10],;
							aProd[nX,11],;
							aProd[nX,12],;
							aProd[nX,13]})
			Else 
				aAux[nPos,3] += aProd[nX,3]
				aAux[nPos,4] += aProd[nX,4]
				aAux[nPos,5] += aProd[nX,5]
			EndIf 
		Next nX 
			
		nCon1 := 0
		nSub1 := 0
		nConRS1 := 0
		nTot1 := 0

		For nX := 1 To Len(aAux)
			nCon1 += aAux[nX,3]
			nSub1 += aAux[nX,5]
			nConRS1 += aAux[nX,6]
			nTot1 += aAux[nX,4]
		Next

		cCon1 := cValToChar(nCon1)
		cSub1 := cValToChar(nSub1)
		cConRS1 := cValToChar(nConRS1)
		cTot1 := cValToChar(nTot1)

		oPrinter:Say( nLin+=10, 360,cCon1, oF10FFF )
		oPrinter:Say( nLin, 410,transForm(val(cSub1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 480,transForm(val(cConRS1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 550,transForm(val(cTot1), "@E 99,999.99"), oF10FFF )

		oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
		oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
		oPrinter:Say( nLin, 280,"NCM", oF10FFF )
		oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
		oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

		For nX := 1 To Len(aAux)
			oPrinter:Say( nLin+=20, 45,aAux[nX,2], oF10FFF )
			oPrinter:Say( nLin, 100,AllTrim(aAux[nX,7]), oF10FFF )
			oPrinter:Say( nLin, 280,AllTrim(aAux[nX,13]), oF10FFF )
			oPrinter:Say( nLin, 360,Transform(aAux[nX,3], "@R 99,999.99" ), oF10FFF )
			oPrinter:Say( nLin, 410,TransForm(aAux[nX,5], "@E 999,999.99"), oF10FFF )
			oPrinter:Say( nLin, 480,TransForm(aAux[nX,6], "@E 999,999.99"), oF10FFF )
			oPrinter:Say( nLin, 550,TransForm(aAux[nX,4], "@E 999,999.99"), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		Next

		oPrinter:Fillrect( { nLin+=20, 10, nLin+30, 590 }, oBrush3, "-2")

		oPrinter:Say( nLin+12, 30,SubStr(aAux[1,8],1,55), oF12FFF,, rgb(238, 238, 238) )
		oPrinter:Say( nLin+24, 30,AllTrim(aAux[1,9]) + "-" + AllTrim(aAux[1,10]), oF10FFF,, rgb(238, 238, 238) )

		oPrinter:Say( nLin+=60, 10,"CONSOLIDADO", oF15FFF )
		oPrinter:Fillrect( { nLin+=5, 10, nLin, 590 }, oBrush1, "-2")
		oPrinter:Fillrect( { nLin+=15, 10, nLin+30, 590 }, oBrush2, "-2")
		oPrinter:Fillrect( { nLin+10, 20, nLin+20, 30 }, oBrush3, "-2")
		oPrinter:Say( nLin+15, 40,SubStr(aAux[1,8],1,55), oF12FFF )
		oPrinter:Say( nLin+25, 40,"Totalizando " + cValToChar(Len(aPontos)) + " Pontos de Venda", oF10FFF )
		oPrinter:Say( nLin+=15, 360,cCon1, oF10FFF )
		oPrinter:Say( nLin, 410,TransForm(val(cSub1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 480,TransForm(val(cConRS1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 550,TransForm(val(cTot1), "@E 99,999.99"), oF10FFF )

		oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
		oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
		oPrinter:Say( nLin, 280,"NCM", oF10FFF )
		oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
		oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

		For nX := 1 To Len(aAux)
			oPrinter:Say( nLin+=20, 45,aAux[nX,2], oF10FFF )
			oPrinter:Say( nLin, 100,AllTrim(aAux[nX,7]), oF10FFF )
			oPrinter:Say( nLin, 280,AllTrim(aAux[nX,13]), oF10FFF )
			oPrinter:Say( nLin, 360,cvalTochar(aAux[nX,3]), oF10FFF )
			oPrinter:Say( nLin, 410,TransForm(aAux[nX,5], "@E 99,999.99"), oF10FFF ) //PEndente Subsidiado
			oPrinter:Say( nLin, 480,TransForm(aAux[nX,6], "@E 99,999.99"), oF10FFF ) //PEndente Consumo - Subsidiado
			oPrinter:Say( nLin, 550,TransForm(aAux[nX,4], "@E 99,999.99"), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		Next

		For nX := 1 To Len(aPontos)

			oPrinter:StartPage()

			nCon1 := 0
			nSub1 := 0
			nConRS1 := 0
			nTot1 := 0

			For nY := 1 To Len(aPontos[nX])
				nCon1 += aPontos[nX,nY,3]
				nSub1 += aPontos[nX,nY,5]
				nConRS1 += aPontos[nX,nY,6]
				nTot1 += aPontos[nX,nY,4]
			Next

			cCon1 := cValToChar(nCon1)
			cSub1 := cValToChar(nSub1)
			cConRS1 := cValToChar(nConRS1)
			cTot1 := cValToChar(nTot1)

			oPrinter:Say( nLin:=20, 10,". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .", oF25TFF,, rgb(0, 99, 125) )
			oPrinter:Say( nLin+=15, 10,"Ponto de Venda", oF15FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush1, "-2")
			oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
			oPrinter:Fillrect( { nLin+20, 30, nLin+30, 20 }, oBrush1, "-2")
			oPrinter:Say( nLin+25, 40,SubStr(aPontos[nX,1,8],1,55), oF12FFF )
			oPrinter:Say( nLin+35, 40,AllTrim(aPontos[nX,1,1]), oF10FFF )
			oPrinter:Say( nLin+25, 360,cCon1, oF10FFF )
			oPrinter:Say( nLin+25, 410,TransForm(val(cSub1), "@E 99,999.99"), oF10FFF ) //PEndente Subsidio
			oPrinter:Say( nLin+25, 480,TransForm(val(cConRS1), "@E 99,999.99"), oF10FFF ) //PEndente Consumido - subsidio
			oPrinter:Say( nLin+25, 550,TransForm(val(cTot1), "@E 99,999.99"), oF10FFF )

			oPrinter:Say( nLin+=50, 25,"Mola", oF10FFF )
			oPrinter:Say( nLin, 50,"ProduTo", oF10FFF )
			oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
			oPrinter:Say( nLin, 280,"NCM", oF10FFF )
			oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
			oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
			oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
			oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

			For nY := 1 To Len(aPontos[nX])

				If nLin > 800
					nLin := 0
					oPrinter:StartPage()
				EndIf

				oPrinter:Say( nLin+=20, 25,aPontos[nX,nY,11], oF10FFF )
				oPrinter:Say( nLin, 50,AllTrim(aPontos[nX,nY,2]), oF10FFF )
				oPrinter:Say( nLin, 100,AllTrim(aPontos[nX,nY,7]), oF10FFF )
				oPrinter:Say( nLin, 280,AllTrim(aPontos[nX,nY,13]), oF10FFF )
				oPrinter:Say( nLin, 360,Transform(aPontos[nX,nY,3], "@R 99,999.99"), oF10FFF )
				oPrinter:Say( nLin, 410,TransForm(aPontos[nX,nY,5], "@E 999,999.99"), oF10FFF ) //PEndente Subsidio
				oPrinter:Say( nLin, 480,TransForm(aPontos[nX,nY,6], "@E 999,999.99"), oF10FFF ) //PEndente Consumido - subsidio
				oPrinter:Say( nLin, 550,TransForm(aPontos[nX,nY,4], "@E 999,999.99"), oF10FFF )
				oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
			Next

			nCon1 := 0
			nSub1 := 0
			nConRS1 := 0
			nTot1 := 0

			For nY := 1 To Len(aPontos[nX])
				nCon1 += aPontos[nX,nY,3]
				nSub1 += aPontos[nX,nY,5]
				nConRS1 += aPontos[nX,nY,6]
				nTot1 += aPontos[nX,nY,4]
			Next

			cCon1 := CValToChar(nCon1)
			cSub1 := CValToChar(nSub1)
			cConRS1 := CValToChar(nConRS1)
			cTot1 := CValToChar(nTot1)

			oPrinter:Say( nLin+=30, 10,"Leituras no Período", oF15FFF )
			oPrinter:Fillrect( { nLin-2.5, 120, nLin, 590 }, oBrush1, "-6")
			oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
			oPrinter:Say( nLin+=25, 15,dToc(STod(aPontos[nX,1,12])), oF15TFF )
			// oPrinter:Say( nLin, 100,cvalTochar(val(aPontos[nX,1,12])), oF10FFF ) //PEndente codigo?
			oPrinter:Say( nLin, 360,cCon1, oF10FFF )
			oPrinter:Say( nLin, 410,transForm(val(cSub1), "@E 99,999.99"), oF10FFF ) //PEndente Total subsidio
			oPrinter:Say( nLin, 480,transForm(val(cConRS1), "@E 99,999.99"), oF10FFF ) //PEndente Total consumido - subsidio
			oPrinter:Say( nLin, 550,transForm(val(cTot1), "@E 99,999.99"), oF10FFF )

			oPrinter:Say( nLin+=30, 25,"Mola", oF10FFF )
			oPrinter:Say( nLin, 50,"ProduTo", oF10FFF )
			oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
			oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
			oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
			oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
			oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

			For nY := 1 To Len(aPontos[nX])

				If nLin > 800
					nLin := 0
					oPrinter:StartPage()
				EndIf

				oPrinter:Say( nLin+=20, 25,aPontos[nX,nY,11], oF10FFF )
				oPrinter:Say( nLin, 50,aPontos[nX,nY,2], oF10FFF )
				oPrinter:Say( nLin, 100,aPontos[nX,nY,7], oF10FFF )
				oPrinter:Say( nLin, 280,aPontos[nX,nY,13], oF10FFF )
				oPrinter:Say( nLin, 360,cvalTochar(aPontos[nX,nY,3]), oF10FFF )
				oPrinter:Say( nLin, 410,transForm(aPontos[nX,nY,5], "@E 99,999.99"), oF10FFF ) //PEndente Subsidio
				oPrinter:Say( nLin, 480,transForm(aPontos[nX,nY,6], "@E 99,999.99"), oF10FFF ) //PEndente Consumo - subsidio
				oPrinter:Say( nLin, 550,transForm(aPontos[nX,nY,4], "@E 99,999.99"), oF10FFF )
				oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
			Next
		Next

		oPrinter:EndPage()
		oPrinter:Print()
	Else
		
		//Replicar aPontos por meio da query para trazer dados faltantes
		For nX := 1 To Len(_aList5B)
			If Len(_aList5B[nX]) > 4
				aAdd(aPontos, _aList5B[nX])
			EndIf
		Next

		cEntre := DToC(MV_PAR02) + " e " + DToC(MV_PAR03)

		nCon1 := 0
		nSub1 := 0
		nConRS1 := 0
		nTot1 := 0

		For nX := 1 To Len(aPontos)
			For nY := 5 To Len(aPontos[nX])
				nCon1 += aPontos[nX,nY,8]
				nSub1 += aPontos[nX,nY,9]
				nConRS1 += aPontos[nX,nY,15]
				nTot1 += aPontos[nX,nY,10]
			Next
		Next

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
		oPrinter:Say( nLin+5, 45,"Total Geral", oF15TFF )
		oPrinter:Say( nLin+15, 45,"Totalizando 1 Cliente", oF10FFF )

		For nX := 1 To Len(aPontos)
			For nY := 5 To Len(aPontos[nX])
				aAdd(aProd, aPontos[nX,nY])
			Next
		Next

		For nX := 1 to len(aProd)
			nPos := Ascan(aAux,{|x| Alltrim(x[2]) == Alltrim(aProd[nX,02])})
			If nPos == 0
				aAdd(aAux, aProd[nX])
			Else 
				aAux[nPos,8] += aProd[nX,8]
				aAux[nPos,10] += aProd[nX,10]
			EndIf 
		Next nX 
					
		nCon1 := 0
		nSub1 := 0
		nConRS1 := 0
		nTot1 := 0

		For nX := 1 To Len(aAux)
			nCon1 += aAux[nX,8]
			nSub1 += aAux[nX,9] * aAux[nX,8]
			nConRS1 += aAux[nX,15] * aAux[nX,8]
			nTot1 += aAux[nX,10]
		Next

		cCon1 := cValToChar(nCon1)
		cSub1 := cValToChar(nSub1)
		cConRS1 := cValToChar(nConRS1)
		cTot1 := cValToChar(nTot1)

		oPrinter:Say( nLin+=10, 360,cCon1, oF10FFF )
		oPrinter:Say( nLin, 410,transForm(val(cSub1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 480,transForm(val(cConRS1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 550,transForm(val(cTot1), "@E 99,999.99"), oF10FFF )

		oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
		oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
		oPrinter:Say( nLin, 280,"NCM", oF10FFF )
		oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
		oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

		For nX := 1 To Len(aAux)
			oPrinter:Say( nLin+=20, 45,aAux[nX,2], oF10FFF )
			oPrinter:Say( nLin, 100,AllTrim(aAux[nX,3]), oF10FFF )
			oPrinter:Say( nLin, 280,AllTrim(aAux[nX,13]), oF10FFF )
			oPrinter:Say( nLin, 360,Transform(aAux[nX,8], "@R 99,999.99"), oF10FFF )
			oPrinter:Say( nLin, 410,TransForm(aAux[nX,9]*aAux[nX,8], "@E 999,999.99"), oF10FFF )
			oPrinter:Say( nLin, 480,TransForm(aAux[nX,15]*aAux[nX,8], "@E 999,999.99"), oF10FFF )
			oPrinter:Say( nLin, 550,TransForm(aAux[nX,10], "@E 999,999.99"), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		Next

		oPrinter:Fillrect( { nLin+=20, 10, nLin+30, 590 }, oBrush3, "-2")

		oPrinter:Say( nLin+12, 30,SubStr(_aList[oList:nAt,5],1,55), oF12FFF,, rgb(238, 238, 238) )
		oPrinter:Say( nLin+24, 30,AllTrim(_aList[oList:nAt,3]) + "-" + AllTrim(_aList[oList:nAt,4]), oF10FFF,, rgb(238, 238, 238) )

		oPrinter:Say( nLin+=60, 10,"CONSOLIDADO", oF15FFF )
		oPrinter:Fillrect( { nLin+=5, 10, nLin, 590 }, oBrush1, "-2")
		oPrinter:Fillrect( { nLin+=15, 10, nLin+30, 590 }, oBrush2, "-2")
		oPrinter:Fillrect( { nLin+10, 20, nLin+20, 30 }, oBrush3, "-2")
		oPrinter:Say( nLin+15, 40,SubStr(_aList[oList:nAt,5],1,55), oF12FFF )
		oPrinter:Say( nLin+25, 40,"Totalizando " + cValToChar(Len(_aList2)) + " Pontos de Venda", oF10FFF )
		oPrinter:Say( nLin+=15, 360,cCon1, oF10FFF )
		oPrinter:Say( nLin, 410,TransForm(val(cSub1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 480,TransForm(val(cConRS1), "@E 99,999.99"), oF10FFF )
		oPrinter:Say( nLin, 550,TransForm(val(cTot1), "@E 99,999.99"), oF10FFF )

		oPrinter:Say( nLin+=30, 45,"Produto", oF10FFF )
		oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
		oPrinter:Say( nLin, 280,"NCM", oF10FFF )
		oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
		oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

		For nX := 1 To Len(aAux)
			oPrinter:Say( nLin+=20, 45,aAux[nX,2], oF10FFF )
			oPrinter:Say( nLin, 100,AllTrim(aAux[nX,3]), oF10FFF )
			oPrinter:Say( nLin, 280,AllTrim(aAux[nX,13]), oF10FFF )
			oPrinter:Say( nLin, 360,TransForm(aAux[nX,8], "@R 99,999.99"), oF10FFF )
			oPrinter:Say( nLin, 410,TransForm(aAux[nX,9]*aAux[nX,8], "@E 999,999.99"), oF10FFF ) //PEndente Subsidiado
			oPrinter:Say( nLin, 480,TransForm(aAux[nX,15]*aAux[nX,8], "@E 999,999.99"), oF10FFF ) //PEndente Consumo - Subsidiado
			oPrinter:Say( nLin, 550,TransForm(aAux[nX,10], "@E 999,999.99"), oF10FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		Next

		For nX := 1 To Len(aPontos)

			oPrinter:StartPage()

			nCon1 := 0
			nSub1 := 0
			nConRS1 := 0
			nTot1 := 0

			For nY := 5 To Len(aPontos[nX])
				nCon1 += aPontos[nX,nY,8]
				nSub1 += aPontos[nX,nY,9] * aPontos[nX,nY,8]
				nConRS1 += aPontos[nX,nY,15] * aPontos[nX,nY,8]
				nTot1 += aPontos[nX,nY,10]
			Next

			cCon1 := cValToChar(nCon1)
			cSub1 := cValToChar(nSub1)
			cConRS1 := cValToChar(nConRS1)
			cTot1 := cValToChar(nTot1)

			oPrinter:Say( nLin:=20, 10,". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .", oF25TFF,, rgb(0, 99, 125) )
			oPrinter:Say( nLin+=15, 10,"Ponto de Venda", oF15FFF )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush1, "-2")
			oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
			oPrinter:Fillrect( { nLin+20, 30, nLin+30, 20 }, oBrush1, "-2")
			oPrinter:Say( nLin+25, 40,SubStr(_aList[oList:nAt,5],1,55), oF12FFF )
			oPrinter:Say( nLin+35, 40,AllTrim(aPontos[nX,2]), oF10FFF )
			oPrinter:Say( nLin+25, 360,cCon1, oF10FFF )
			oPrinter:Say( nLin+25, 410,TransForm(val(cSub1), "@E 99,999.99"), oF10FFF ) //PEndente Subsidio
			oPrinter:Say( nLin+25, 480,TransForm(val(cConRS1), "@E 99,999.99"), oF10FFF ) //PEndente Consumido - subsidio
			oPrinter:Say( nLin+25, 550,TransForm(val(cTot1), "@E 99,999.99"), oF10FFF )

			oPrinter:Say( nLin+=50, 25,"Mola", oF10FFF )
			oPrinter:Say( nLin, 50,"ProduTo", oF10FFF )
			oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
			oPrinter:Say( nLin, 280,"NCM", oF10FFF )
			oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
			oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
			oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
			oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

			For nY := 5 To Len(aPontos[nX])

				If nLin > 800
					nLin := 0
					oPrinter:StartPage()
				EndIf

				oPrinter:Say( nLin+=20, 25,aPontos[nX,nY,1], oF10FFF )
				oPrinter:Say( nLin, 50,AllTrim(aPontos[nX,nY,2]), oF10FFF )
				oPrinter:Say( nLin, 100,AllTrim(aPontos[nX,nY,3]), oF10FFF )
				oPrinter:Say( nLin, 280,AllTrim(aPontos[nX,nY,13]), oF10FFF )
				oPrinter:Say( nLin, 360,cvalTochar(aPontos[nX,nY,8]), oF10FFF )
				oPrinter:Say( nLin, 410,TransForm(aPontos[nX,nY,9]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //PEndente Subsidio
				oPrinter:Say( nLin, 480,TransForm(aPontos[nX,nY,15]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //PEndente Consumido - subsidio
				oPrinter:Say( nLin, 550,TransForm(aPontos[nX,nY,10], "@E 99,999.99"), oF10FFF )
				oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
			Next

			nCon1 := 0
			nSub1 := 0
			nConRS1 := 0
			nTot1 := 0

			For nY := 5 To Len(aPontos[nX])
				nCon1 += aPontos[nX,nY,8]
				nSub1 += aPontos[nX,nY,9] * aPontos[nX,nY,8]
				nConRS1 += aPontos[nX,nY,15] * aPontos[nX,nY,8]
				nTot1 += aPontos[nX,nY,10]
			Next

			cCon1 := CValToChar(nCon1)
			cSub1 := CValToChar(nSub1)
			cConRS1 := CValToChar(nConRS1)
			cTot1 := CValToChar(nTot1)

			oPrinter:Say( nLin+=30, 10,"Leituras no Período", oF15FFF )
			oPrinter:Fillrect( { nLin-2.5, 120, nLin, 590 }, oBrush1, "-6")
			oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
			oPrinter:Say( nLin+=25, 15,dToc(STod(aPontos[nX,5,6])), oF15TFF )
			oPrinter:Say( nLin, 100,cvalTochar(val(aPontos[nX,5,11])), oF10FFF ) //PEndente codigo?
			oPrinter:Say( nLin, 360,cCon1, oF10FFF )
			oPrinter:Say( nLin, 410,transForm(val(cSub1), "@E 99,999.99"), oF10FFF ) //PEndente Total subsidio
			oPrinter:Say( nLin, 480,transForm(val(cConRS1), "@E 99,999.99"), oF10FFF ) //PEndente Total consumido - subsidio
			oPrinter:Say( nLin, 550,transForm(val(cTot1), "@E 99,999.99"), oF10FFF )

			oPrinter:Say( nLin+=30, 25,"Mola", oF10FFF )
			oPrinter:Say( nLin, 50,"ProduTo", oF10FFF )
			oPrinter:Say( nLin, 100,"Descrição", oF10FFF )
			oPrinter:Say( nLin, 280,"NCM", oF10FFF )
			oPrinter:Say( nLin, 360,"Consumo", oF10FFF )
			oPrinter:Say( nLin, 410,"Subsidiado R$", oF10FFF )
			oPrinter:Say( nLin, 480,"Ao Consumidor R$", oF10FFF )
			oPrinter:Say( nLin, 550,"Total R$", oF10FFF )

			For nY := 5 To Len(aPontos[nX])

				If nLin > 800
					nLin := 0
					oPrinter:StartPage()
				EndIf

				oPrinter:Say( nLin+=20, 25,aPontos[nX,nY,1], oF10FFF )
				oPrinter:Say( nLin, 50,aPontos[nX,nY,2], oF10FFF )
				oPrinter:Say( nLin, 100,aPontos[nX,nY,3], oF10FFF )
				oPrinter:Say( nLin, 280,aPontos[nX,nY,13], oF10FFF )
				oPrinter:Say( nLin, 360,cvalTochar(aPontos[nX,nY,8]), oF10FFF )
				oPrinter:Say( nLin, 410,transForm(aPontos[nX,nY,9]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //PEndente Subsidio
				oPrinter:Say( nLin, 480,transForm(aPontos[nX,nY,15]*aPontos[nX,nY,8], "@E 99,999.99"), oF10FFF ) //PEndente Consumo - subsidio
				oPrinter:Say( nLin, 550,transForm(aPontos[nX,nY,10], "@E 99,999.99"), oF10FFF )
				oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
			Next
		Next

		oPrinter:EndPage()
		oPrinter:Print()

	EndIf

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
	Local oF10FFF          := TFont():New('Ambra Sans' /*Fonte*/,,10 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF12FFF          := TFont():New('Ambra Sans' /*Fonte*/,,12 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF15FFF          := TFont():New('Ambra Sans' /*Fonte*/,,15 /*Tamanho*/,,.F. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF15TFF          := TFont():New('Ambra Sans' /*Fonte*/,,15 /*Tamanho*/,,.T. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF20TFF          := TFont():New('Ambra Sans' /*Fonte*/,,20 /*Tamanho*/,,.T. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF25TFF          := TFont():New('Ambra Sans' /*Fonte*/,,25 /*Tamanho*/,,.T. /*NegriTo*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	
	Private oPrinter := FWMSPrinter():New( "demons_consumo_.pdf",IMP_PDF,lAdjustToLegacy,"C:\temp\",lDisableSetup,,,,,,,, )

	For nX := 1 To Len(_aList5B)
		If Len(_aList5B[nX]) > 4
			aAdd(aPontos, _aList5B[nX])
		EndIf
	Next

	For nX := 1 To Len(aPontos)
		For nY := 5 To Len(aPontos[nX])
			aAdd(aPontos[nX,nY], aPontos[nX,2])
			aAdd(aProd, aPontos[nX,nY])
		Next
	Next

	oPrinter:StartPage()
	oPrinter:SetMargin( 005, 005, 005, 005 )

	oBrush1 := TBrush():New( , rgb(0, 0, 0) )
	oBrush2 := TBrush():New( , rgb(238, 238, 238) )
	oBrush3 := TBrush():New( , rgb(0, 99, 125) )

	oPrinter:SayBitmap(001,020,cLogoD,075,075)

	oPrinter:Say( nLin+=20, 125,AllTrim(SM0->M0_NOMECOM), oF15TFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+12, 125,TransForm(val(AllTrim(SM0->M0_CGC)), "@E 99,999,999/9999-99"), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+24, 125,AllTrim(SM0->M0_EndENT), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+36, 125,StrTran(TransForm(val(AllTrim(SM0->M0_CEPENT)), "@E 99,999-999"), " ", "0")+" - "+AllTrim(SM0->M0_CIDENT)+"-"+AllTrim(SM0->M0_ESTENT), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+48, 125,If((Len(AllTrim(SM0->M0_TEL)) > 10), TransForm(val(AllTrim(SM0->M0_TEL)), "@E (99) 99999-9999"), TransForm(val(AllTrim(SM0->M0_TEL)), "@E (99) 9999-9999")), oF12FFF,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin+=55, 10, nLin, 590 }, oBrush1, "-2")
	oPrinter:Box( nLin+=20, 30, nLin+100, 350,"-1" )

	cQuery := " SELECT A1_CEP,A1_CGC,A1_MUN,A1_EST "
	cQuery += " FROM SA1010 "
	cQuery += " WHERE A1_COD = '" + _aList[oList:nAt,3] + "' AND A1_LOJA = '" + _aList[oList:nAt,4] + "' "

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"ToPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	While !EOF()
		aAux := {AllTrim(TRB->A1_CEP),AllTrim(TRB->A1_CGC),AllTrim(TRB->A1_MUN),AllTrim(TRB->A1_EST)}
		DBSKIP()
	End

	oPrinter:Say( nLin+20, 35,SubStr(_aList[oList:nAt,5],1 ,30), oF20TFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+32, 35,TransForm(val(aAux[2]), "@E 99,999,999/9999-99"), oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+44, 35,_aList[oList:nAt,6], oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+56, 35,TransForm(val(aAux[1]), "@E 99999-999") + " - " + AllTrim(aAux[3]) + "-" + aAux[4], oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+68, 35,"Este é o seu demonstrativo de consumo para o período", oF12FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+80, 35,"de " + dToc(sTod(aProd[1,4])) + " a " + dToc(sTod(aProd[1,6])) + " ", oF12FFF,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin, 360, nLin+100, 570 }, oBrush2, "-1")

	For nX := 1 To Len(aProd)
		nTot += aProd[nX,10]
	Next

	oPrinter:Say( nLin+40, 380,TransForm(nTot, "@E 999,999.99"), oF25TFF,, rgb(0, 0, 0) )
	// oPrinter:Say( nLin+52, 400,"vencimenTo em 22/12/22", oF12FFF,, rgb(0, 0, 0) ) //PEndente vencimenTo
	oPrinter:Say( nLin+52, 410,"PagamenTo via BoleTo", oF12FFF,, rgb(0, 0, 0) ) //PEndente pagamenTo

	// oPrinter:Fillrect( { nLin+=100, 10, nLin, 590 }, oBrush2, "-1")

	aAux := {}
	aAdd(aAux, {})
	cProd := aProd[1,2]

	For nX := 1 To Len(aProd)
		If aProd[nX,2] == cProd
			aAdd(aAux[Len(aAux)], aProd[nX])
		Else
			aAdd(aAux, {})
			aAdd(aAux[Len(aAux)], aProd[nX])
		EndIf
		cProd := aProd[nX,2]
	Next
	//Cabeçalho
	oPrinter:Say( nLin+=120, 330,"Consumo", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin, 350+50,"Unitário (R$)", oF15FFF,, rgb(0, 0, 0) )
	oPrinter:Say( nLin, 350+70+90,"Total (R$)", oF15FFF,, rgb(0, 0, 0) )

	For nX := 1 To Len(aAux)

		If nLin > 800
			nLin := 0
			oPrinter:StartPage()
		EndIf

		nCon1 := 0
		nTot1 := 0
		nUni1 := 0

		For nY := 1 To Len(aAux[nX])
			nCon1 += aAux[nX,nY,8]
			nUni1 := aAux[nX,nY,9]
			nTot1 += aAux[nX,nY,10]
		Next

		cCon1 := CValToChar(nCon1)
		cUni1 := CValToChar(nUni1)
		cTot1 := CValToChar(nTot1)

		//Totalizadores
		oPrinter:Fillrect( { nLin+5, 10, nLin+25, 590 }, oBrush2, "-1")
		oPrinter:Say( nLin+=20, 30,AllTrim(aAux[nX,1,3]), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 320,TransForm(val(cCon1), "@E 999,999"), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 350+30,TransForm(val(cUni1), "@E 999,999.99"), oF15FFF,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 350+70+70,TransForm(val(cTot1), "@E 999,999.99"), oF15FFF,, rgb(0, 0, 0) )

		For nY := 1 To Len(aAux[nX])

			If nLin > 800
				nLin := 0
				oPrinter:StartPage()
			EndIf

			oPrinter:Say( nLin+=20, 30,dToc(sTod(aAux[nX,nY,6])) + " em " + aAux[nX,nY,16] + " - MÁQ " + aAux[nX,nY,16], oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 330,TransForm(aAux[nX,nY,8], "@E 999,999"), oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 350+50,TransForm(aAux[nX,nY,9], "@E 999,999.99"), oF10FFF,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 350+70+90,TransForm(aAux[nX,nY,10], "@E 999,999.99"), oF10FFF,, rgb(0, 0, 0) )
		Next
	Next

	oPrinter:EndPage()
	oPrinter:Print()

Return
