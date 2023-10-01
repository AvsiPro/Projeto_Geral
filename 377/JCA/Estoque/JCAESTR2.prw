#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
User Function JCAESTR2()
	Local lFinal	:= .T.
 If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf
	If ValidPerg()
		MsAguarde({|| ImpEtiq() },"Impress�o de etiqueta","Aguarde...")
	EndIf
 
Return
 
Static Function ImpEtiq()
	Local cQuery	:= ""
	Local cProdDe	:= MV_PAR01
	Local cProdAte	:= MV_PAR02
	Local nQuant	:= MV_PAR03
	Local cImpress  := Alltrim(MV_PAR04) //pego o nome da impressora
	Local cLogo 	:= "\system\logo.jpg"
    Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
	Local oFont16	:= TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
	//Local oFont16N	:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.,.F.)
 
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
    Local nR 

	Local nLin		:= 0
	Local nCol		:= 0
	Local nLinC		:= 0
	Local nColC		:= 0
	Local nWidth	:= 0
	Local nHeigth   := 0
	Local lBanner	:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	Local nPFWidth	:= 0
	Local nPFHeigth	:= 0
	Local lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
 
	//MsProcTxt("Identificando a impressora...")
 
	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	//oPrint 	:= FWMSPrinter():New("Boleto_"+strzero(VAL(MV_PAR02),9)+".rel",  IMP_PDF IMP_SPOOL, lAdjustToLegacy, cPasta, lDisableSetup,,,,.F.,,,.F.)

	//Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
 
	cQuery := "SELECT B1_COD AS CODIGO,B1_DESC AS DESCRI,B1_CODBAR AS CODBAR,ZPM_DESC AS MARCA,B1_UM AS UM"
    cQuery += " FROM "+RetSQLName("SB1")+" B1"
    cQuery += " INNER JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"

    cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'"
 
	TcQuery cQuery New Alias "QRYTMP"
	QRYTMP->(DbGoTop())
 
	oPrinter:SetMargin(001,001,001,001)
 
	While QRYTMP->(!Eof())
		For nR := 1 to nQuant
			nLin := 20
			nCol := 12
 
			//MsProcTxt("Imprimindo "+alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->DESC)+"...")
 
			oPrinter:StartPage()
 
			//oPrinter:SayBitmap(nLin,nCol,cLogo,100,030)
            oPrinter:Box(10,5,100,160)
			//nLin+= 45
			//oPrinter:Say(nLin,nCol,"Produto",oFont16)
 
			nLinC		:= 3.10		//Linha que ser� impresso o C�digo de Barra
			nColC		:= 4.3		//Coluna que ser� impresso o C�digo de Barra
			nWidth	 	:= 0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
			nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
			lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
			nPFWidth	:= 0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
			nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
			lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
 
			//nLin+= 10
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) ,oFont10)
            nLin+= 10
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->DESCRI) ,oFont10) 
            
            //nLinC += 1
			oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            nLin+= 45
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->MARCA) ,oFont10)
            oPrinter:Say(nLin,nCol+100,"UM:"+alltrim(QRYTMP->UM) ,oFont10)

            nLin+= 10
            oPrinter:Say(nLin,nCol,"NF:" ,oFont10)
            nLin+= 10
            oPrinter:Say(nLin,nCol,"DATA:" ,oFont10)
            
			
			oPrinter:EndPage()
		Next
		QRYTMP->(DbSkip())
	EndDo

    //oPrinter:Preview()
	oPrinter:Print()
      

	QRYTMP->(DbCloseArea())
 
Return
 
/*Montagem da tela de perguntas*/
Static Function ValidPerg()
	Local aRet 		:= {}
	Local aParamBox	:= {}
	Local lRet 		:= .F.
	Local aOpcoes	:= {}
	Local cProdDe	:= ""
	Local cProdAte	:= ""
	Local cLocal	:= Space(99)
 
	If Empty(getMV("ZZ_IMPRESS")) //se o parametro estiver vazio, ja o defino com a impressora PDFCreator 
		aOpcoes := {"PDFCreator"}
	Else
		aOpcoes := Separa(getMV("ZZ_IMPRESS"),";")
	Endif
 
	cProdDe := space(TamSX3("B1_COD")[1])
	cProdAte:= REPLICATE("Z",TAMSX3("B1_COD")[1])
 
	aAdd(aParamBox,{01,"Produto de"	  			,cProdDe 	,""					,"","SB1"	,"", 60,.F.})	// MV_PAR01
	aAdd(aParamBox,{01,"Produto ate"	   		,cProdAte	,""					,"","SB1"	,"", 60,.T.})	// MV_PAR02
	aAdd(aParamBox,{01,"Quantidade Etiqueta"	,1			,"@E 9999"			,"",""		,"", 60,.F.})	// MV_PAR03
	aadd(aParamBox,{02,"Imprimir em"			,Space(50)	,aOpcoes			,100,".T.",.T.,".T."})		// MV_PAR04
 
	If ParamBox(aParamBox,"Etiqueta Produto",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
 
		If ValType(MV_PAR04) == "N" //Algumas vezes ocorre um erro de ao inv�s de selecionar o conte�do, seleciona a ordem, ent�o verifico se � numerico, se for, eu me posiciono na impressora desejada para pegar o seu nome
			MV_PAR04 := aOpcoes[MV_PAR04]
		EndIf
 
		lRet := .T.
	EndIf
Return lRet
