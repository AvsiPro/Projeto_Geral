#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "FILEIO.CH"

User Function CONGEN03()

	Local lAdjustToLegacy  := .F.
	Local lDisableSetup    := .T.
	Local lOK              := .F.
	Local cQuery           := ""
    Local aAux := {}
    Local cNum := ""
	Local cEmissao := ""
	Local cValor := ""
	Local cNota := ""
	Local cMes := ""
	Local cVencimento := ""
	Local cLogoD := ""

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

	Local aPergs := {}

	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","01")
	EndIf

	cLogoD := "\SYSTEM\blogo_connect.bmp"

    aAdd( aPergs ,{01,"Pedido de"                  ,"                          "     ,""                    ,"","SC5"    ,"", 60,.F.})  

	If !ParamBox(aPergs ,"Parametros ")
		Return
	EndIf

    cNum := MV_PAR01

	cQuery := " "
	cQuery += " SELECT C5_NUM,C6_PRCVEN,C6_VALOR,C5_EMISSAO,C6_NOTA,C6_DATFAT,C6_PEDCLI,A1_NOME,A1_CGC,A1_END,A1_NREDUZ,C6_DESCRI " 
	cQuery += " FROM " + RetSQLName("SC5") + " " 
	cQuery += " INNER JOIN " + RetSQLName("SC6") + " ON C5_NUM = C6_NUM " 
	cQuery += " AND C5_FILIAL=C6_FILIAL " 
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " ON A1_COD = C5_CLIENTE AND C5_LOJACLI = A1_LOJA" 
	cQuery += " WHERE  C5_NUM = '" + AllTrim(cNum) + "' "

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	while !EOF()

		aAux := {TRB->C5_NUM,TRB->C5_EMISSAO,TRB->C6_PRCVEN,TRB->C6_VALOR,TRB->C6_NOTA,TRB->C6_DATFAT,TRB->C6_PEDCLI,TRB->A1_NOME,TRB->A1_CGC,TRB->A1_END,TRB->A1_NREDUZ,TRB->C6_NOTA,TRB->C6_DESCRI}
				//aAux[1]    aAux[2]         aAux[3]        aAux[4]       aAux[5]      aAux[6]        aAux[7]

		lOK := .T.
		DBSKIP()
	end

	if !lOK
		MsgAlert("Maquina sem Pedido de Venda, nao foi possivel gerar o recibo!", "Erro!")
		RETURN
	endif

	cNum := zTiraZeros(aAux[12])
	cEmissao := dtoc(stod(aAux[2]))
	cValor := "R$ " + Transform(aAux[3], "@E 999,999.99")
	cValor1 := Transform(aAux[3], "@E 999,999.99")
	cNota := aAux[5]
	cMes := mesextenso(month(stod(aAux[6])))
	cVencimento += AllTrim(aAux[7])
    cCli := aAux[8]
    cCli1 := aAux[11]
    cCnpj := Transform(val(aAux[9]), "@E 99,999,999/9999-99")
    cPeriodo := "Locação de máquina referente mês " + SubStr(aAux[6],5,2) + "/" + SubStr(aAux[6],3,2)
    cPonto := aAux[13]
    cEmitente := SM0->M0_NOMECOM + " " + Transform(val(SM0->M0_CGC), "@E 99,999,999/9999-99")
    cEnd :=  aAux[10]
    cEndEmit := SM0->M0_ENDENT

	Private oPrinter := FWMSPrinter():New( "recibo_loc_"+cNum+".pdf",IMP_PDF,lAdjustToLegacy,"C:\temp\",lDisableSetup,,,,,,,, )

	oPrinter:StartPage()
	oPrinter:SetMargin( 000, 000, 000, 000 )

	oBrush1 := TBrush():New( , rgb(237, 237, 237) )
	oPrinter:Fillrect( { 26, 500, 74, 590 }, oBrush1, "-2")

	// oPrinter:SayBitmap(045,003,cLogoD,200,200)

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
	oPrinter:Say( 100, 505,cCnpj, oF13FFF,, /*Cor*/ )

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
	oPrinter:Print()

Return

Static Function zTiraZeros(cTexto)
    Local aArea     := GetArea()
    Local cRetorno  := ""
    Local lContinua := .T.
    Default cTexto  := ""
 
    //Pegando o texto atual
    cRetorno := Alltrim(cTexto)
 
    //Enquanto existir zeros a esquerda
    While lContinua
        //Se a priemira posição for diferente de 0 ou não existir mais texto de retorno, encerra o laço
        If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
            lContinua := .f.
        EndIf
         
        //Se for continuar o processo, pega da próxima posição até o fim
        If lContinua
            cRetorno := Substr(cRetorno, 2, Len(cRetorno))
        EndIf
    EndDo
     
    RestArea(aArea)
Return cRetorno
