#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
#include 'tbiconn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ETPJub01         ³ Autor ³: Rodrigo Barreto Data ³ 27/08/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³   IMpressão de Etiquetas Produtos                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function EtProJub()

    // Local lFinal    := .T.
    Private Imprime := IMP_SPOOL

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0301")
        Imprime := IMP_PDF
	EndIf

    If ValidPerg()
        if AllTrim(MV_PAR04) == "P"
            MsAguarde({|| ImpEtiqP() },"Impressão de etiqueta","Aguarde...")
        elseif AllTrim(MV_PAR04) == "M"
            MsAguarde({|| ImpEtiqM() },"Impressão de etiqueta","Aguarde...")
        elseif AllTrim(MV_PAR04) == "G"
            MsAguarde({|| ImpEtiqG() },"Impressão de etiqueta","Aguarde...")
        endif
    EndIf

Return

Static Function ImpEtiqG()

    Local cQuery              := ""
    Local cProdDe             := MV_PAR01
    // Local cProdAte            := MV_PAR02
    Local nQuant              := MV_PAR03
    Local cImpress            := Alltrim(MV_PAR04) //pego o nome da impressora
    //Local cLogo     := "\system\logo.jpg"
    Local cLogo               := ""
    Local oFont16             := TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
    // Local oFont16N            := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.,.F.)
    Local lAdjustToLegacy     := .F.
    Local lDisableSetup       := .T.
    Local nLin                := 0
    Local nCol                := 0
    Local nLinC               := 0
    Local nColC               := 0
    Local nWidth              := 0
    Local nHeigth             := 0
    Local nPFWidth            := 0
    Local nPFHeigth           := 0
    Local nR                  := 0
    Local lBanner             := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
    Local lCmtr2Pix           := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.

    //MsProcTxt("Identificando a impressora...")
    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",Imprime,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
    
    //Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
    cQuery := " SELECT B1_CODBAR CODBAR,B1_COD CODIGO,B1_DESC FROM "+RetSqlName('SB1')+" B1 "
    //cQuery += " LEFT JOIN "+RetSqlName ('SB1')+" B1 ON B1_COD=LK_CODIGO AND B1.D_E_L_E_T_='' "
    cQuery += " Where B1.D_E_L_E_T_='' AND B1_COD = '"+ alltrim(cProdDe) + "' " //AND '" + AllTrim(cProdAte) + "' "
    
    TcQuery cQuery New Alias "QRYTMP"
    
    QRYTMP->(DbGoTop())
    oPrinter:SetMargin(001,001,001,001)
    
    While QRYTMP->(!Eof())
        For nR := 1 to nQuant
            
            nLin := 10
            nCol := 22
            
            //MsProcTxt("Imprimindo "+alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC)+"...")
            oPrinter:StartPage()

            If AT( "EYEFLY", QRYTMP->B1_DESC )
                cLogo := "\system\EYEFLY.jpg"
            ElseIf AT( "CAMBRIDGE", QRYTMP->B1_DESC )
                cLogo := "\system\CAMBRIDGE.jpg"
            ElseIf AT( "TNG", QRYTMP->B1_DESC )
                cLogo := "\system\TNG.jpg"
            ElseIf AT( "NOVA", QRYTMP->B1_DESC )
                cLogo := "\system\NOVA.jpg"
            ElseIf AT( "MX", QRYTMP->B1_DESC )
                cLogo := "\system\MX.jpg"
            ElseIf AT( "FEEL", QRYTMP->B1_DESC )
                cLogo := "\system\FEEL.jpg"
            Else    
                cLogo := "\system\logo.jpg"
            EndIf

            oPrinter:SayBitmap(nLin,nCol,cLogo,90,025)
            
            nLin+= 45
            
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->B1_DESC),oFont16)
            
            //oPrinter:Say(nLin,nCol,"Produto",oFont16)
            nLinC        := 4.95        //Linha que será impresso o Código de Barra
            nColC        := 3        //Coluna que será impresso o Código de Barra
            nWidth       := 0.0164    //Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
            nHeigth      := 0.6        //Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
            lBanner      := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
            nPFWidth     := 0.8        //Número do índice de ajuste da largura da fonte. Default 1
            nPFHeigth    := 0.9        //Número do índice de ajuste da altura da fonte. Default 1
            lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
            
            oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODBAR), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            
            nLin+= 40
            nCol+= 30
            
            //oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC),oFont16)
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODBAR),oFont16)
            oPrinter:EndPage()
        Next
        QRYTMP->(DbSkip())
    EndDo
    oPrinter:Print()
    QRYTMP->(DbCloseArea())

Return

Static Function ImpEtiqM()

    Local cQuery              := ""
    Local cProdDe             := MV_PAR01
    // Local cProdAte            := MV_PAR02
    Local nQuant              := MV_PAR02
    Local cImpress            := Alltrim(MV_PAR03) //pego o nome da impressora
    //Local cLogo     := "\system\logo.jpg"
    Local cLogo               := ""
    Local oFont16             := TFont():New('Arial',14,14,,.F.,,,,.T.,.F.,.F.)
    // Local oFont16N            := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.,.F.)
    Local lAdjustToLegacy     := .F.
    Local lDisableSetup       := .T.
    Local nLin                := 0
    Local nCol                := 0
    Local nLinC               := 0
    Local nColC               := 0
    Local nWidth              := 0
    Local nHeigth             := 0
    Local nPFWidth            := 0
    Local nPFHeigth           := 0
    Local nR                  := 0
    Local lBanner             := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
    Local lCmtr2Pix           := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.

    //MsProcTxt("Identificando a impressora...")
    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",Imprime,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
    
    //Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
    cQuery := " SELECT B1_CODBAR CODBAR,B1_COD CODIGO,B1_DESC FROM "+RetSqlName('SB1')+" B1 "
    //cQuery += " LEFT JOIN "+RetSqlName ('SB1')+" B1 ON B1_COD=LK_CODIGO AND B1.D_E_L_E_T_='' "
    cQuery += " Where B1.D_E_L_E_T_='' AND B1_COD = '"+ alltrim(cProdDe) + "' " //AND '" + AllTrim(cProdAte) + "' "
    
    TcQuery cQuery New Alias "QRYTMP"
    
    QRYTMP->(DbGoTop())
    oPrinter:SetMargin(001,001,001,001)
    
    While QRYTMP->(!Eof())
        For nR := 1 to nQuant
            
            nLin := 10
            nCol := 22
            
            //MsProcTxt("Imprimindo "+alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC)+"...")
            oPrinter:StartPage()

            If AT( "EYEFLY", QRYTMP->B1_DESC )
                cLogo := "\system\EYEFLY.jpg"
            ElseIf AT( "CAMBRIDGE", QRYTMP->B1_DESC )
                cLogo := "\system\CAMBRIDGE.jpg"
            ElseIf AT( "TNG", QRYTMP->B1_DESC )
                cLogo := "\system\TNG.jpg"
            ElseIf AT( "NOVA", QRYTMP->B1_DESC )
                cLogo := "\system\NOVA.jpg"
            ElseIf AT( "MX", QRYTMP->B1_DESC )
                cLogo := "\system\MX.jpg"
            ElseIf AT( "FEEL", QRYTMP->B1_DESC )
                cLogo := "\system\FEEL.jpg"
            Else    
                cLogo := "\system\logo.jpg"
            EndIf

            //60/90

            // oPrinter:Box(0,0,100,100,"-6")
            // oPrinter:Box(0,0,90,90,"-6")
            // oPrinter:Box(0,0,80,80,"-6")
            // oPrinter:Box(0,0,70,70,"-6")
            // oPrinter:Box(0,0,60,60,"-6")
            // oPrinter:Box(0,0,50,50,"-6")
            // oPrinter:Box(0,0,40,40,"-6")
            // oPrinter:Box(0,0,30,30,"-6")
            // oPrinter:Box(0,0,20,20,"-6")
            // oPrinter:Box(0,0,10,10,"-6")

            oPrinter:Box(0,0,60,90,"-6")

            oPrinter:SayBitmap(nLin,5,cLogo,25,25)
            
            nLin+= 45
            
            // oPrinter:Say(nLin,nCol,alltrim(QRYTMP->B1_DESC),oFont16)
            oPrinter:Say(15,30,alltrim(QRYTMP->CODIGO),oFont16)
            
            //oPrinter:Say(nLin,nCol,"Produto",oFont16)
            nLinC        := 4.95        //Linha que será impresso o Código de Barra
            nColC        := 3        //Coluna que será impresso o Código de Barra
            nWidth       := 0.0164    //Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
            nHeigth      := 0.3        //Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
            lBanner      := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
            nPFWidth     := 0.8        //Número do índice de ajuste da largura da fonte. Default 1
            nPFHeigth    := 0.9        //Número do índice de ajuste da altura da fonte. Default 1
            lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
            
            // oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODBAR), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            oPrinter:QRCode( 70, 25, alltrim(QRYTMP->CODBAR), 0.7 )

            nLin+= 40
            nCol+= 30
            
            //oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC),oFont16)
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODBAR),oFont16)
            oPrinter:EndPage()
        Next
        QRYTMP->(DbSkip())
    EndDo
    oPrinter:Print()
    QRYTMP->(DbCloseArea())

Return

Static Function ImpEtiqP()

    Local cQuery              := ""
    Local cProdDe             := MV_PAR01
    // Local cProdAte            := MV_PAR02
    Local nQuant              := MV_PAR02
    Local cImpress            := Alltrim(MV_PAR03) //pego o nome da impressora
    // Local cLogo               := "\system\logo.jpg"
    Local cLogo               := ""
    Local oFont16             := TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
    // Local oFont16N            := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.,.F.)
    Local lAdjustToLegacy     := .F.
    Local lDisableSetup       := .T.
    Local nLin                := 0
    Local nCol                := 0
    Local nLinC               := 0
    Local nColC               := 0
    Local nWidth              := 0
    Local nHeigth             := 0
    Local nPFWidth            := 0
    Local nPFHeigth           := 0
    Local nR                  := 0
    Local lBanner             := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
    Local lCmtr2Pix           := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.

    //MsProcTxt("Identificando a impressora...")
    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",Imprime,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
    
    //Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
    cQuery := " SELECT B1_CODBAR CODBAR,B1_COD CODIGO,B1_DESC FROM "+RetSqlName('SB1')+" B1 "
    //cQuery += " LEFT JOIN "+RetSqlName ('SB1')+" B1 ON B1_COD=LK_CODIGO AND B1.D_E_L_E_T_='' "
    cQuery += " Where B1.D_E_L_E_T_='' AND B1_COD = '"+ alltrim(cProdDe) + "' " //AND '" + AllTrim(cProdAte) + "' "
    
    TcQuery cQuery New Alias "QRYTMP"
    
    QRYTMP->(DbGoTop())
    oPrinter:SetMargin(001,001,001,001)
    
    While QRYTMP->(!Eof())
        For nR := 1 to nQuant
            
            nLin := 10
            nCol := 22
            
            //MsProcTxt("Imprimindo "+alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC)+"...")
            oPrinter:StartPage()

            If AT( "EYEFLY", QRYTMP->B1_DESC )
                cLogo := "\system\EYEFLY.jpg"
            ElseIf AT( "CAMBRIDGE", QRYTMP->B1_DESC )
                cLogo := "\system\CAMBRIDGE.jpg"
            ElseIf AT( "TNG", QRYTMP->B1_DESC )
                cLogo := "\system\TNG.jpg"
            ElseIf AT( "NOVA", QRYTMP->B1_DESC )
                cLogo := "\system\NOVA.jpg"
            ElseIf AT( "MX", QRYTMP->B1_DESC )
                cLogo := "\system\MX.jpg"
            ElseIf AT( "FEEL", QRYTMP->B1_DESC )
                cLogo := "\system\FEEL.jpg"
            Else    
                cLogo := "\system\logo.jpg"
            EndIf

            //30/90

            // oPrinter:Box(0,0,100,100,"-6")
            // oPrinter:Box(0,0,90,90,"-6")
            // oPrinter:Box(0,0,80,80,"-6")
            // oPrinter:Box(0,0,70,70,"-6")
            // oPrinter:Box(0,0,60,60,"-6")
            // oPrinter:Box(0,0,50,50,"-6")
            // oPrinter:Box(0,0,40,40,"-6")
            // oPrinter:Box(0,0,30,30,"-6")
            // oPrinter:Box(0,0,20,20,"-6")
            // oPrinter:Box(0,0,10,10,"-6")
            // oPrinter:Box(0,0,375,275,"-6")
            // oPrinter:Box(0,0,350,250,"-6")
            // oPrinter:Box(0,0,325,225,"-6")
            // oPrinter:Box(0,0,300,200,"-6")

            oPrinter:Box(0,0,30,90,"-6")

            oPrinter:SayBitmap(nLin,nCol,cLogo,90,025)
            
            nLin+= 45
            
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->B1_DESC),oFont16)
            
            //oPrinter:Say(nLin,nCol,"Produto",oFont16)
            nLinC        := 4.95   // Linha que será impresso o Código de Barra
            nColC        := 3      // Coluna que será impresso o Código de Barra
            nWidth       := 0.0164 // Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
            nHeigth      := 0.6    // Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
            lBanner      := .T.    // Se imprime a linha com o código embaixo da barra. Default .T.
            nPFWidth     := 0.8    // Número do índice de ajuste da largura da fonte. Default 1
            nPFHeigth    := 0.9    // Número do índice de ajuste da altura da fonte. Default 1
            lCmtr2Pix    := .T.    // Utiliza o método Cmtr2Pix() do objeto Printer. Default .T.
            
            oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODBAR), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)

            nLin+= 40
            nCol+= 30
            
            //oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC),oFont16)
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODBAR),oFont16)
            oPrinter:EndPage()

        Next
        QRYTMP->(DbSkip())
    EndDo
    oPrinter:Print()
    QRYTMP->(DbCloseArea())

Return

/*Montagem da tela de perguntas*/
Static Function ValidPerg()
    
    // Local aRet         := {}
    Local aParamBox    := {}
    Local lRet         := .F.
    Local aOpcoes      := {}
    Local aTamanhos    := {"P=Pequeno", "M=Medio", "G=Grande"}
    Local cProdDe      := ""
    Local cProdAte     := ""
    // Local cLocal    := Space(99)
    
    If Empty(getMV("MV_XIMPRES")) //se o parametro estiver vazio, ja o defino com a impressora PDFCreator 
        aOpcoes := {"PDFCreator"}
    Else
        aOpcoes := Separa(getMV("MV_XIMPRES"),";")
    Endif
    
    cProdDe  := space(TamSX3("B1_COD")[1])
    cProdAte := REPLICATE("Z",TAMSX3("B1_COD")[1])
    
    aAdd(aParamBox,{01,"Produto de"             ,cProdDe     ,""                    ,"","SB1"    ,"", 60,.F.})    // MV_PAR01
    // aAdd(aParamBox,{01,"Produto ate"            ,cProdAte    ,""                    ,"","SB1"    ,"", 60,.T.})    // MV_PAR02
    aAdd(aParamBox,{01,"Quantidade Etiqueta"    ,1            ,"@E 9999"            ,"",""        ,"", 60,.F.})   // MV_PAR02
    aadd(aParamBox,{02,"Imprimir em"            ,Space(50)    ,aOpcoes              ,100,".T.",.T.,".T."})        // MV_PAR03
    aadd(aParamBox,{02,"Tamanho da Impressao"   ,Space(50)    ,aTamanhos            ,100,".T.",.T.,".T."})        // MV_PAR04

    If ParamBox(aParamBox,"Etiqueta Produto",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        If ValType(MV_PAR04) == "N" //Algumas vezes ocorre um erro de ao invés de selecionar o conteúdo, seleciona a ordem, então verifico se é numerico, se for, eu me posiciono na impressora desejada para pegar o seu nome
            MV_PAR04 := aOpcoes[MV_PAR04]
        EndIf
        lRet := .T.
    EndIf

Return lRet
