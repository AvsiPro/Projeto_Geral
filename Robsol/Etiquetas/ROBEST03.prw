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
±±³Descricao ³   IMpressão de Etiquetas Projeto Oticas                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function EtPJub01()
    Local lFinal    := .T.


    If ValidPerg()
        MsAguarde({|| ImpEtiq() },"Impressão de etiqueta","Aguarde...")
    EndIf
Return

Static Function ImpEtiq()
    Local cQuery    := ""
    Local cDescP    := ""
    Local cProdDe    := MV_PAR01
    Local nQuant    := MV_PAR03
    Local cImpress  := Alltrim(MV_PAR04) //pego o nome da impressora
    Local cLogo     := ""
    Local oFont16    := TFont():New('Arial',12,9,,.F.,,,,.T.,.F.,.F.)
    Local oFont16N    := TFont():New('Segoe UI Black',12,9,,.T.,,,,.T.,.F.,.F.)
    Local lAdjustToLegacy     := .F.
    Local lDisableSetup      := .T.
    Local nLin        := 0
    Local nCol        := 0
    Local nLinC        := 0
    Local nColC        := 0
    Local nWidth    := 0
    Local nHeigth   := 0
    Local cTam  := ""
    Local cCor  := ""
    Local nAux1 := 0
    Local nAux2 := 0
    Local nAux := 0
    Local lBanner    := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
    Local nPFWidth    := 0
    Local nPFHeigth    := 0
    Local lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
    Local nI,nR 

    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress),,,,, /*parametro que recebe a impressora*/)

    //Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
    cQuery := " SELECT B1_CODBAR CODBAR,B1_COD CODIGO,B1_DESC FROM "+RetSqlName('SB1')+" B1 "
    cQuery += " Where B1.D_E_L_E_T_='' AND B1_COD = '"+ alltrim(cProdDe) +"' "

    TcQuery cQuery New Alias "QRYTMP"
    QRYTMP->(DbGoTop())
    oPrinter:SetMargin(001,001,001,001)
    While QRYTMP->(!Eof())
        For nR := 1 to nQuant

            nLin := 10
            nCol := 22

            oPrinter:StartPage()
            If AT( "EYEFLY", QRYTMP->B1_DESC )
                cLogo := "\system\EYEFLY.jpg"
            ElseIf AT( "CAMBRIDGE", QRYTMP->B1_DESC )
                cLogo := "\system\CAMBRIDGE.jpg"
            ElseIf AT( "TNG", QRYTMP->B1_DESC )
                cLogo := "\system\TNG.jpg"
            ElseIf AT( "NOVA", QRYTMP->B1_DESC )
                cLogo := "\system\NOVA.jpg"
            Else
                cLogo :=  "\system\logo.jpg"
            EndIf


            oPrinter:SayBitmap(nLin,nCol+55,cLogo,45,030)
            nLin+= 10
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO),oFont16N)

            //tamanho e cor de acordo B1_DESC /COR/TAMANHO
            nAux := len(alltrim(QRYTMP->B1_DESC)) //guarda quantidade de caracteres na descrição do produto
            nAux1 :=  AT( "/", alltrim(QRYTMP->B1_DESC) )  //guarda a primeira posição de "/"
            nAux2 := AT( "/", alltrim(QRYTMP->B1_DESC), nAux1+1) //segunda posição de /
            nAux3 := nAux2 - (nAux1+1)

            If nAux1 > 0
                cCor := substr(alltrim(QRYTMP->B1_DESC),nAux1+1,nAux3)
                nAux3 := nAux - nAux2
                cTam := substr(alltrim(QRYTMP->B1_DESC),nAux2+1,nAux3)
            EndIf

            nTam      := len(cCor)
            nLin := mlcount(cCor,90)
            nLinRel := 50
            For nI := 1 to nLin
                If nI = 1
                    oPrinter:Say( nLinRel + 10, 22, memoline(cCor,90,nI),oFont16N,,,270     )
                    nLinRel := nLinRel - 5
                    oPrinter:Say( nLinRel , 32, memoline(cTam,90,nI),oFont16N,,,270 )
                EndIf
            Next


            //oPrinter:Say(nLin,nCol,"Produto",oFont16)
            nLinC        := 4        //Linha que será impresso o Código de Barra
            nColC        := 2.3        //Coluna que será impresso o Código de Barra
            nWidth         := 0.0164    //Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
            nHeigth       := 0.6        //Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
            lBanner        := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
            nPFWidth    := 0.2        //Número do índice de ajuste da largura da fonte. Default 1
            nPFHeigth    := 0.3        //Número do índice de ajuste da altura da fonte. Default 1
            lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
            oPrinter:FWMSBAR("EAN13" , nLinC , nColC, alltrim(QRYTMP->CODBAR), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)

            //imprimir 2 etiqueta

            nLin := 10
            nCol := 22
            oPrinter:SayBitmap(nLin,nCol+180,cLogo,45,030)
            nLin+= 10
            oPrinter:Say(nLin,nCol+125,alltrim(QRYTMP->CODIGO),oFont16N)

            nLin := mlcount(cCor,90)
            nLinRel := 50
            For nI := 1 to nLin
                If nI = 1
                    oPrinter:Say( nLinRel + 10, 145, memoline(cCor,90,nI),oFont16N,,,270     )
                    nLinRel := nLinRel - 5
                    oPrinter:Say( nLinRel , 155, memoline(cTam,90,nI),oFont16N,,,270 )
                EndIf
            Next

            //oPrinter:Say(nLin,nCol,"Produto",oFont16)
            nLinC        := 4        //Linha que será impresso o Código de Barra
            nColC        := 12.8        //Coluna que será impresso o Código de Barra
            nWidth         := 0.0164    //Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
            nHeigth       := 0.6        //Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
            lBanner        := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
            nPFWidth    := 0.2        //Número do índice de ajuste da largura da fonte. Default 1
            nPFHeigth    := 0.3        //Número do índice de ajuste da altura da fonte. Default 1
            lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
            oPrinter:FWMSBAR("EAN13" , nLinC , nColC, alltrim(QRYTMP->CODBAR), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            
            nLin+= 40
            nCol+= 30
            oPrinter:EndPage()
        Next
        QRYTMP->(DbSkip())
    EndDo
    oPrinter:Print()
    QRYTMP->(DbCloseArea())
Return

/*Montagem da tela de perguntas*/

Static Function ValidPerg()
    Local aRet         := {}
    Local aParamBox    := {}
    Local lRet         := .F.
    Local aOpcoes    := {}
    Local cProdDe    := ""
    Local cProdAte    := ""
    Local cLocal    := Space(99)
    If Empty(getMV("MV_XIMPRES")) //se o parametro estiver vazio, ja o defino com a impressora PDFCreator
        aOpcoes := {"PDFCreator"}
    Else
        aOpcoes := Separa(getMV("MV_XIMPRES"),";")
    Endif
    cProdDe := space(TamSX3("B1_COD")[1])
    cProdAte:= REPLICATE("Z",TAMSX3("B1_COD")[1])
    aAdd(aParamBox,{01,"Produto de"                  ,cProdDe     ,""                    ,"","SB1"    ,"", 60,.F.})    // MV_PAR01
    aAdd(aParamBox,{01,"Produto ate"               ,cProdAte    ,""                    ,"","SB1"    ,"", 60,.T.})    // MV_PAR02
    aAdd(aParamBox,{01,"Quantidade Etiqueta"    ,1            ,"@E 9999"            ,"",""        ,"", 60,.F.})    // MV_PAR03
    aadd(aParamBox,{02,"Imprimir em"            ,Space(50)    ,aOpcoes            ,100,".T.",.T.,".T."})        // MV_PAR04
    If ParamBox(aParamBox,"Etiqueta Produto",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        If ValType(MV_PAR04) == "N" //Algumas vezes ocorre um erro de ao invés de selecionar o conteúdo, seleciona a ordem, então verifico se é numerico, se for, eu me posiciono na impressora desejada para pegar o seu nome
            MV_PAR04 := aOpcoes[MV_PAR04]
        EndIf
        lRet := .T.
    EndIf
Return lRet
