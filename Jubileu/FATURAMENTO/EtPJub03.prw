#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
#include 'tbiconn.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ETPJub03         ³ Autor ³: Rodrigo Barreto Data ³ 27/08/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³   IMpressão de Etiquetas Caixa Projeto Oticas              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function EtPJub03()
    Local lFinal    := .T.

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0101"
    If ValidPerg()
        MsAguarde({|| ImpEtiq() },"Impressão de etiqueta","Aguarde...")
    EndIf
Return
Static Function ImpEtiq()
    Local cQuery    := ""
    Local cProdDe    := MV_PAR01
    Local nQtdPcs   := MV_PAR02
    Local nQuant    := MV_PAR03
    Local cImpress  := Alltrim(MV_PAR04) //pego o nome da impressora
    Local cTamArm    := MV_PAR05
    Local cCorArm   := MV_PAR06
    Local cLogo     := "\system\jub.jpg"
    Local oFont16    := TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
    Local oFont16N    := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.,.F.)
    Local lAdjustToLegacy     := .F.
    Local lDisableSetup      := .T.
    Local nLin        := 0
    Local nCol        := 0
    Local nLinC        := 0
    Local nColC        := 0
    Local nWidth    := 0
    Local nHeigth   := 0
    Local lBanner    := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
    Local nPFWidth    := 0
    Local nPFHeigth    := 0
    Local lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
    //Local cTam  := ""
    Local cCod  := ""
    Local nAux := 0
    Local nAux1 := 0
    Local nAux2 := 0
    Local nAux3 := 0
    //MsProcTxt("Identificando a impressora...")
    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress),,,,, /*parametro que recebe a impressora*/)
    
    //Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
    cQuery := " SELECT B1_CODBAR CODBAR,B1_COD CODIGO,B1_DESC FROM "+RetSqlName('SB1')+" B1 "
    //cQuery += " LEFT JOIN "+RetSqlName ('SB1')+" B1 ON B1_COD=LK_CODIGO AND B1.D_E_L_E_T_='' "
    cQuery += " Where B1.D_E_L_E_T_='' AND B1_COD = '"+ alltrim(cProdDe) +"' "
    
    TcQuery cQuery New Alias "QRYTMP"
    QRYTMP->(DbGoTop())
    oPrinter:SetMargin(001,001,001,001)
    While QRYTMP->(!Eof())

            //tamanho e cor de acordo B1_DESC /COR/TAMANHO
            /*nAux := len(alltrim(QRYTMP->B1_CODIGO)) //guarda quantidade de caracteres na descrição do produto
            nAux1 :=  AT( "/", alltrim(QRYTMP->B1_DESC) )  //guarda a primeira posição de "/"
            nAux2 := AT( "/", alltrim(QRYTMP->B1_DESC), nAux1+1) //segunda posição de /
            nAux3 := nAux2 - (nAux1+1)*/
            
            //If nAux1 > 0
            cCod := substr(alltrim(QRYTMP->CODIGO),1,9)
                //nAux3 := nAux - nAux2
               // cTam := substr(alltrim(QRYTMP->B1_DESC),nAux2+1,nAux3)
            //EndIf
        For nR := 1 to nQuant
            nLin := 10
            nCol := 22
            //MsProcTxt("Imprimindo "+alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC)+"...")
            
            
            oPrinter:StartPage()
            //oPrinter:Box( 10, 10, 300, 500, "0.5")
            oPrinter:Say(nLin,nCol,alltrim("MODEL   "+cCod),oFont16N)
            oPrinter:Say(nLin + 12,nCol,alltrim("SIZE        "+cTamArm),oFont16N)
            oPrinter:Say(nLin + 24,nCol,alltrim("COLOR  "+cCorArm),oFont16N)
            oPrinter:Say(nLin + 36,nCol,alltrim("PCS       "+cValToChar(nQtdPcs)),oFont16N)
            oPrinter:SayBitmap(nLin + 5,nCol + 88,cLogo,70,030)
            nLin+= 45
            //oPrinter:Say(nLin,nCol,alltrim(QRYTMP->B1_DESC),oFont16)
            //oPrinter:Say(nLin,nCol,"Produto",oFont16)
            nLinC        := 5.95        //Linha que será impresso o Código de Barra
            nColC        := 4        //Coluna que será impresso o Código de Barra
            nWidth         := 0.0194    //Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
            nHeigth       := 0.6        //Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
            lBanner        := .T.        //Se imprime a linha com o código embaixo da barra. Default .T.
            nPFWidth    := 1.8        //Número do índice de ajuste da largura da fonte. Default 1
            nPFHeigth    := 1.9        //Número do índice de ajuste da altura da fonte. Default 1
            lCmtr2Pix    := .T.        //Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
            oPrinter:FWMSBAR("EAN13" , nLinC , nColC, alltrim(QRYTMP->CODBAR), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            nLin+= 40
            nCol+= 30
            //oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->B1_DESC),oFont16)
            //oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODBAR),oFont16)
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
    Local cCorArm    := space(6)
    Local cTamArm    := space(6)
    Local cLocal    := Space(99)
    If Empty(getMV("MV_XIMPRES")) //se o parametro estiver vazio, ja o defino com a impressora PDFCreator 
        aOpcoes := {"PDFCreator"}
    Else
        aOpcoes := Separa(getMV("MV_XIMPRES"),";")
    Endif
    cProdDe := space(TamSX3("B1_COD")[1])
    //cProdAte:= REPLICATE("Z",TAMSX3("B1_COD")[1])
    aAdd(aParamBox,{01,"Produto de"                  ,cProdDe     ,""                    ,"","SB1"    ,"", 60,.F.})    // MV_PAR01
    aAdd(aParamBox,{01,"Quantidade de Pcs"               ,1   ,"@E 9999"            ,"",""        ,"", 60,.F.})    // MV_PAR02   // MV_PAR02
    aAdd(aParamBox,{01,"Quantidade Etiqueta"    ,1            ,"@E 9999"            ,"",""        ,"", 60,.F.})    // MV_PAR03
    aadd(aParamBox,{02,"Imprimir em"            ,Space(50)    ,aOpcoes            ,100,".T.",.T.,".T."})        // MV_PAR04
    aAdd(aParamBox,{01,"Tamanho"                  ,cCorArm     ,""                    ,"",""    ,"", 60,.T.})    // MV_PAR05
    aAdd(aParamBox,{01,"Cor"                  ,cTamArm     ,""                    ,"",""    ,"", 60,.T.})    // MV_PAR05
    
    If ParamBox(aParamBox,"Etiqueta Produto",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        If ValType(MV_PAR04) == "N" //Algumas vezes ocorre um erro de ao invés de selecionar o conteúdo, seleciona a ordem, então verifico se é numerico, se for, eu me posiciono na impressora desejada para pegar o seu nome
            MV_PAR04 := aOpcoes[MV_PAR04]
        EndIf
        lRet := .T.
    EndIf
Return lRet
