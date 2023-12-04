#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "FILEIO.CH"


#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6

User Function CONGEN03(cNumNF,cSerNF,cPathNF,cCNPJNF,cFilNf)

	Local lAdjustToLegacy  := .F.
	Local lDisableSetup    := .T.
	Local lOK              := .F.
	Local cQuery           := ""
    Local aAux             := {}
    Local aMaquinas        := {}
    Local cNum             := ""
	Local cEmissao         := ""
	Local cValor           := ""
	Local cMes             := ""
	Local cVencimento      := ""
	Local cLogoD           := ""
	Local cNotD 	       := space(9)
	Local cNotA 	       := 'ZZZZZZZZZ'
	Local cFilD 	       := cFilNf //xFilial("SF2")
	Local cFilA 	       := cFilNf //xFilial("SF2")
	Local nCont            := 0
	Local nValor           := 0
	Local nX               := 0
	Local nLinha           := 0
	Local cSerie 	       := "'LOC','LRJ','LPR'"
	Local cCaminho		   := "C:\TEMP\"

	//Fontes
	Local oF10FFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF10TFF          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF10FFT          := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
	Local oF13FFF          := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	Local oF20TFF          := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
	
	Local aPergs := {}

	Private oPrinter

	Default cNumNF			:=	""
	Default cSerNF			:=	""
	Default	cPathNF			:=	""
	Default cCNPJNF			:=	""
	Default cFilNf			:=	""
	
	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	If !Empty(cNumNF)

		cNotA := cNumNF
		cNotD := cNumNF

	EndIf

	If !Empty(cSerNF)

		cSerie := "'"+Alltrim(cSerNF)+"'" 
	
	EndIf

	If !Empty(cPathNF)

		cCaminho := cPathNF 

	ENDIF

	cLogoD := "\SYSTEM\lgrl01.bmp"

    aAdd( aPergs ,{01,"Nota de"   ,cNotD   ,"@!"       ,".T.","SF2"    ,".T.", 80,.F.})  
	aAdd( aPergs ,{01,"Nota Ate"  ,cNotA   ,"@!"       ,".T.","SF2"    ,".T.", 80,.F.})  

	aAdd( aPergs ,{01,"Filial de"   ,IF(Empty(cPathNF),space(4),cFilD)   ,"@!"       ,".T.",""    ,".T.", 80,.F.})  
	aAdd( aPergs ,{01,"Filial Ate"  ,IF(Empty(cPathNF),space(4),cFilA)   ,"@!"       ,".T.",""    ,".T.", 80,.F.})  

	If Empty(cPathNF)
		If !ParamBox(aPergs ,"Parametros ")
			Return
		EndIf

		cNotD := MV_PAR01
		cNotA := MV_PAR02
		cFilD := MV_PAR03
		cFilA := MV_PAR04
	Else
		cFilD := ' ' 
		cFilA := 'ZZZ' 
	EndIf 

	If !Empty(cFilNf)
		cFilD := cFilNf
		cFilA := cFilNf
	EndIf


	

    cQuery := "SELECT DISTINCT D2_PEDIDO,D2_PRCVEN,D2_TOTAL,F2_EMISSAO,F2_DOC,F2_EMISSAO,"
	cQuery += " C5_XTPPED,C6_PEDCLI,A1_NOME,A1_CGC,A1_END,A1_NREDUZ,B1_DESC,C5_FILIAL,E1_VENCREA"
	cQuery += " FROM "+RetSQLName("SF2")+" F2 "
	cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5_CLIENTE=F2_CLIENTE AND C5_LOJACLI=F2_LOJA AND C5.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND C6.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_=' '"
	cQuery += " LEFT JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL='"+xFilial("SE1")+"' AND E1_PREFIXO=F2_SERIE AND E1_NUM=F2_DOC AND E1_CLIENTE=F2_CLIENTE AND E1_LOJA=F2_LOJA AND E1.D_E_L_E_T_=' '"
	cQuery += " WHERE F2_FILIAL BETWEEN '"+cFilD+"' AND '"+cFilA+"'"
	cQuery += " AND F2_SERIE IN("+cSerie+")"
	cQuery += " AND F2.D_E_L_E_T_=' '"
	cQuery += " AND F2_DOC BETWEEN '"+cNotD+"' AND '"+cNotA+"'"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	while !EOF()
		Aadd(aAux,{	TRB->D2_PEDIDO,;	//01
					TRB->F2_EMISSAO,;	//02
					TRB->D2_PRCVEN,;	//03
					TRB->D2_TOTAL,;		//04
					TRB->F2_DOC,;		//05
					TRB->F2_EMISSAO,;	//06
					TRB->C6_PEDCLI,;	//07
					TRB->A1_NOME,;		//08
					TRB->A1_CGC,;		//09
					TRB->A1_END,;		//10
					TRB->A1_NREDUZ,;	//11
					TRB->F2_DOC,;		//12
					TRB->B1_DESC,;		//13
					TRB->C5_XTPPED,;	//14
					TRB->C5_FILIAL,;	//15
					TRB->E1_VENCREA})	//16
				
		lOK := .T.
		DBSKIP()
	end

	/*if !lOK
		MsgAlert("Maquina sem Pedido de Venda, nao foi possivel gerar o recibo!", "Erro!")
		RETURN
	endif*/


	For nCont := 1 to len(aAux)
		
		cQuery := " SELECT C6_VALOR FROM " + RetSQLName("SC6") + " WHERE C6_NUM = '" + aAux[nCont,1] + "' AND C6_FILIAL BETWEEN '" + cFilD + "' AND '" + cFilA + "' AND D_E_L_E_T_ = ' ' "

		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf

		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

		nValor := 0

		while !EOF()
				nValor += TRB->C6_VALOR
			DBSKIP()
		end

		CFILANT := aAux[nCont,15]

		aSM0Data2 := FWSM0Util():GetSM0Data()

		cNum := cvaltochar(val(aAux[nCont,12]))
		cEmissao := dtoc(stod(aAux[nCont,2]))
		cVencto  := dtoc(stod(aAux[nCont,16]))
		cValor := "R$ " + Transform(nValor, "@E 999,999.99")
		cValor1 := Transform(nValor, "@E 999,999.99")
		cNota := aAux[nCont,5]
		cMes := mesextenso(month(stod(aAux[nCont,6])))
		cVencimento += AllTrim(aAux[nCont,7])
		cCli := aAux[nCont,8]
		cCli1 := aAux[nCont,11]
		cCnpj := Transform(val(aAux[nCont,9]), "@E 99,999,999/9999-99")
		cPeriodo := If(aAux[nCont,14] <> "G","Locação de máquina referente mês " + SubStr(aAux[nCont,6],5,2) + "/" + SubStr(aAux[nCont,6],3,2),"")
		
		If "DOSE COMPLE" $ Alltrim(aAux[nCont,13])
			cPonto := cvaltochar(round(aAux[nCont,04]/aAux[nCont,03],0)) + " - "+aAux[nCont,13]
		Else
			cPonto := aAux[nCont,13]
		EndIf 

		cCGC := aSM0Data2[ASCAN(aSM0Data2,{|X| X[1] == "M0_CGC"}),02]
		cEmitente := SM0->M0_NOMECOM + " " + Transform(cCGC, "@R 99.999.999/9999-99")

		cEnd :=  aAux[nCont,10]
		cEndEmit := SM0->M0_ENDENT

		aPergs := {}

		aAdd( aPergs ,{9,"Nome: " + cCli,150,7,.T.})
		aAdd( aPergs ,{9,"Nome Reduz: " + cCli1,150,7,.T.})
		aAdd( aPergs ,{9,"Nota: " + StrZero(val(cNum), 9),150,7,.T.})
		aAdd( aPergs ,{11,"Informe sessao referentes:"   ,"",".T.",".T.",.T.})  

		If Empty(cPathNF)
			If !ParamBox(aPergs ,"Observacoes ")
				Return
			EndIf

			cReferentes := MV_PAR04
		else
			cReferentes := 'NR. PO '+aAux[nCont,7]
		ENDIF

		

		oPrinter := FWMSPrinter():New( "recibo_loc_"+strzero(val(cNum),9)+".rel",IMP_PDF,lAdjustToLegacy,cCaminho+(If(!Empty(cCNPJNF),cCNPJNF+"\","")),lDisableSetup,,,,.F.,,,.F.)
		
		oPrinter:StartPage()
		oPrinter:SetMargin( 000, 000, 000, 000 )
		oPrinter:cPathPDF := cCaminho+(If(!Empty(cCNPJNF),cCNPJNF+"\",""))

		oBrush1 := TBrush():New( , rgb(237, 237, 237) )
		oPrinter:Fillrect( { 26, 500, 74, 590 }, oBrush1, "-2")

		oPrinter:SayBitmap(031,013,cLogoD,040,040)

		oPrinter:Box( 25, 5, 25, 590, "-9" )

		If aAux[nCont,14] == "F"
			oPrinter:Say( 55, 125,"NOTA DE DÉBITO" , oF20TFF )
		else
			oPrinter:Say( 55, 125,"FATURA " + cNum + If(aAux[nCont,14] <> "G"," - LOCAÇÃO DE " + Upper(cMes)," - FRETE "), oF20TFF )
		EndIf 
		oPrinter:Say( 35, 510,"NÚMERO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 55, 530,cNum, oF20TFF )
		oPrinter:Box( 75, 5, 75, 590, "-9" )
		oPrinter:Box( 25, 500, 75, 500, "-9" )

		oPrinter:Box( 75, 500, 150, 500, "-1" )
		oPrinter:Say( 85, 10,"RECEBEMOS DE", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 100, 10,cCli, oF13FFF,, /*Cor*/ )
		oPrinter:Say( 115, 10,cEnd, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 85, 510,"CNPJ OU CPF", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 100, 505,cCnpj, oF13FFF,, /*Cor*/ )

		oPrinter:Box( 150, 5, 150, 590,"-1" )
		oPrinter:Say( 160, 10,"O VALOR DE", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 175, 10,cValor, oF13FFF,, /*Cor*/ )

		oPrinter:Box( 200, 5, 200, 590,"-1" )
		oPrinter:Say( 210, 10,"REFERENTES A", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 225, 10,cReferentes, oF13FFF,, /*Cor*/ )
		// oPrinter:Say( 225, 10,cPeriodo, oF13FFF,, /*Cor*/ )
		// oPrinter:Say( 240, 10,cVencimento, oF13FFF,, /*Cor*/ )

		oPrinter:Box( 250, 5, 250, 590,"-1" )
		oPrinter:Say( 260, 10,"DETALHAMENTO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 275, 10,cPonto, oF13FFF,, /*Cor*/ )
		oPrinter:Say( 275, 500,cValor1, oF13FFF,, /*Cor*/ )

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
		oPrinter:Say( 360, 180,"DATA DE VENCTO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 375, 180,cVencto, oF13FFF,, /*Cor*/ )
		oPrinter:Say( 360, 310,"ASSINATURA", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )

		nLinha := 390

		cQuery := " SELECT C5_MENNOTA FROM " + RetSQLName("SC5") + " WHERE C5_NUM = '" + aAux[nCont,1] + "' "

		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf

		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

		cMenNota := AllTrim(TRB->C5_MENNOTA)

		if Empty(cMenNota)
			MsgAlert("Area de mencao nota vazio!", "Atencao!")
		else
			aMaquinas := StrToKarr(AllTrim(Substr(cMenNota, 39)), "/")

			for nX := 1 to len(aMaquinas)
				
				oPrinter:Fillrect( { nLinha += 20, 005, nLinha + 15, 590 }, oBrush1, "-2")
				oPrinter:Say( nLinha+10, 10,"Patrimônio - " + aMaquinas[nX], oF13FFF,, rgb(102, 102, 102)/*Cor*/ )

				DbSelectArea("AAN")
				DbSetOrder(3)
				if DbSeek(xFilial("AAN") + AvKey(aMaquinas[nX], "AAN_XCBASE"))
					oPrinter:Say( nLinha+10, 500,"R$" + Transform(AAN->AAN_VALOR, "@E 999,999.99"), oF13FFF,, /*Cor*/ )
				endif

			next
		endif

		oPrinter:Say( 735, 5,"_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ", oF10FFF )
		oPrinter:Box( 750, 100, 750, 590,"-1" )
		oPrinter:Box( 785, 100, 785, 590,"-1" )
		oPrinter:Box( 825, 100, 825, 590,"-1" )
		oPrinter:Box( 750, 300, 785, 420,"-1" )
		oPrinter:Box( 750, 420, 785, 500,"-1" )
		oPrinter:Box( 750, 420, 825, 420,"-1" )
		oPrinter:Fillrect( { 750, 30, 825, 85 }, oBrush1, "-2")
		oPrinter:Say( 760, 43,"NÚMERO", oF10TFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 780, 41,cNum, oF20TFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 820, 12,"COMPROVANTE", oF10FFF,, /*Cor*/, 270 /*Angulo*/ )
		oPrinter:Say( 820, 22,"   DE ENTREGA", oF10FFF,, /*Cor*/, 270 /*Angulo*/ )
		oPrinter:Say( 760, 110,"DESTINATÁRIO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 775, 110,cCli1, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 760, 305,"CNPJ OU CPF", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 775, 305,cCnpj, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 760, 425,"EMISSÃO", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 775, 425,cEmissao, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 760, 505,"VALOR", oF10FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 775, 505,cValor1, oF13FFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 795, 110,"RECEBIDO POR", oF10TFF,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 795, 175,"(nome e assinatura, por gentileza)", oF10FFT,, rgb(102, 102, 102)/*Cor*/ )
		oPrinter:Say( 795, 425,"DATA", oF10TFF,, rgb(102, 102, 102)/*Cor*/ )

		oPrinter:EndPage()
		//If Empty(cPathNF)
			oPrinter:Print()
		//EndIf
	Next nCont 

Return
