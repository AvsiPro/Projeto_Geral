#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'

User Function JESTR002(nOpc)

	//Local lFinal	:= .T.
	Local nCont 
	Default nOpc := 0

	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","00020087")
	EndIf

	If nOpc == 1	
		nPosPrd  := Ascan(aHeader,{|x| Alltrim(x[2]) == "D1_COD"})
		nPosQtd  := Ascan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT"})

		For nCont := 1 to len(aCols)
			
			MV_PAR01 := aCols[nCont,nPosPrd]
			MV_PAR02 := aCols[nCont,nPosPrd]
			MV_PAR03 := aCols[nCont,nPosQtd]
			MV_PAR04 := "1"
			MV_PAR05 := 'PDFCreator'
			MV_PAR06 := SPACE(9)
			MV_PAR07 := ctod(' / / ')
			ImpEtiq()
		Next nCont

	Else 
		If ValidPerg()
			MsAguarde({|| ImpEtiq() },"Impress�o de etiqueta","Aguarde...")
		EndIf
	EndIf
Return
 
Static Function ImpEtiq()

	Local cQuery	:= ""
	Local cProdDe	:= MV_PAR01
	Local cProdAte	:= MV_PAR02
	Local nQuant	:= MV_PAR03
	Local cImpress  := Alltrim(MV_PAR05) //pego o nome da impressora
	Local cTipo     := Alltrim(MV_PAR04)
	Local oFont08	:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
	Local cNota  	:= MV_PAR06
	Local dData 	:= MV_PAR07
	//Local oFont16	:= TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
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
    cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
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
			If cTipo == "1"
            	oPrinter:Box(10,5,100,160)
			else
				oPrinter:Box(10,5,080,160)
			EndIf
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

			If len(alltrim(QRYTMP->DESCRI)) > 30
				oPrinter:Say(nLin-1,nCol,substr(QRYTMP->DESCRI,1,30) ,oFont08)
				
				oPrinter:Say(nLin+5,nCol,substr(QRYTMP->DESCRI,31) ,oFont08)
			Else 
            	oPrinter:Say(nLin,nCol,alltrim(QRYTMP->DESCRI) ,oFont10) 
			EndIf
            
            //nLinC += 1
			oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            
			oPrinter:Say(nLin+20,nCol-5,alltrim(QRYTMP->CODIGO) ,oFont08)
            
			If cTipo == "1"
				nLin+= 45
				oPrinter:Say(nLin,nCol,alltrim(QRYTMP->MARCA) ,oFont10)
				oPrinter:Say(nLin,nCol+100,"UM:"+alltrim(QRYTMP->UM) ,oFont10)

				nLin+= 10
				oPrinter:Say(nLin,nCol,"NF: "+cNota ,oFont10)
				nLin+= 10
				oPrinter:Say(nLin,nCol,"DATA: "+cvaltochar(dData)  ,oFont10)
            EndIf
			
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
	Local aParamBox	:= {}
	Local lRet 		:= .F.
	Local aOpcoes	:= {}
	Local cProdDe	:= ""
	Local cProdAte	:= ""
	Local cNota 	:= space(9)
	Local dDataNF	:= CTOD(' / / ')
	Local aTipos	:= {"1=Produto","2=Prateleira"}
	
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
	aadd(aParamBox,{02,"Tipo Etiqueta"			,Space(50)	,aTipos				,100,".T."	,.T.,".T."})	// MV_PAR04
 	aadd(aParamBox,{02,"Imprimir em"			,Space(50)	,aOpcoes			,100,".T."	,.T.,".T."})	// MV_PAR04

	aAdd(aParamBox,{01,"Nota"		  			,cNota 		,""					,"","SF1"	,"", 60,.F.})	// MV_PAR01
	aAdd(aParamBox,{01,"Data"		  			,dDataNF 	,""					,"",""		,"", 60,.F.})	// MV_PAR01
	
 
	If ParamBox(aParamBox,"Etiqueta Produto",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
 
		If ValType(MV_PAR04) == "N" //Algumas vezes ocorre um erro de ao inv�s de selecionar o conte�do, seleciona a ordem, ent�o verifico se � numerico, se for, eu me posiciono na impressora desejada para pegar o seu nome
			MV_PAR04 := aOpcoes[MV_PAR04]
		EndIf
 
		lRet := .T.
	EndIf
Return lRet
