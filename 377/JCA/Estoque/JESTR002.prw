#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
/*
    Rotina para impress�o de etiquetas
    35-MIT 44_ESTOQUE_EST017 - Criar programa para impress�o de etiqueta
    
    DOC MIT
    
	DOC Entrega
    https://docs.google.com/document/d/1jefVMEpeQ6nl4ghy2sUK1D65O5tv92yc/edit
    
*/
User Function JESTR002(nOpc)

	Default nOpc := 0

	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","00090276")
	EndIf

	TelaPar()
	
Return
 
/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 07/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function TelaPar()

Local nOpcao := 0

Private cPar01 := space(TamSX3("NNR_CODIGO")[1])
Private cPar02 := Replicate("Z",TamSX3("NNR_CODIGO")[1])
Private cPar03 := space(TamSX3("B1_COD")[1])
Private cPar04 := Replicate("Z",TamSX3("B1_COD")[1])
Private cPar05 := space(TamSX3("BE_LOCALIZ")[1])
Private cPar06 := Replicate("Z",TamSX3("BE_LOCALIZ")[1])
Private aSimNao := {'1=Sim','2=Nao'}
Private cPar07 := aSimNao[1]
Private cPar08 := space(TamSX3("F1_DOC")[1])
Private cPar09 := space(TamSX3("A2_COD")[1])
Private cPar10 := space(TamSX3("A2_LOJA")[1])
Private aTipImp := {'1=Produto','2=Prateleira'}
Private cPar11 := aTipImp[1]
Private aLocImp := {'ZEBRA','PDF'}
Private cPar12 := aLocImp[1]
Private cPar13 := space(TamSX3("F1_SERIE")[1])

Private oDlg1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11
Private oGet1,oGet2,oGet3,oGet4,oGet5,oGet6,oCBox1,oGet7,oGet8,oGet9,oCBox2,oCBox3
Private oBtn1,oBtn2
Private aList := {}
Private oList 

Aadd(aList,{'','','',''})

//aLocImp := GetImpWindows(.f.)

oDlg1      := MSDialog():New( 186,980,914,1624,"Etiqueta de Produto",,,.F.,,,,,,.T.,,,.T. )

	oSay1      := TSay():New( 012,044,{||"Armaz�m de ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oGet1      := TGet():New( 012,132,{|u| If(Pcount()>0,cPar01:=u,cPar01)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"NNR","",,)
	
	oSay2      := TSay():New( 029,044,{||"Armaz�m Ate ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	oGet2      := TGet():New( 029,132,{|u| If(Pcount()>0,cPar02:=u,cPar02)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"NNR","",,)
	
	oSay3      := TSay():New( 046,044,{||"Produto de ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oGet3      := TGet():New( 046,132,{|u| If(Pcount()>0,cPar03:=u,cPar03)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	
	oSay4      := TSay():New( 063,044,{||"Produto Ate ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oGet4      := TGet():New( 063,132,{|u| If(Pcount()>0,cPar04:=u,cPar04)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	
	oSay5      := TSay():New( 080,044,{||"Endere�o de ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	oGet5      := TGet():New( 080,132,{|u| If(Pcount()>0,cPar05:=u,cPar05)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBE","",,)
	
	oSay6      := TSay():New( 097,044,{||"Endere�o Ate ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	oGet6      := TGet():New( 097,132,{|u| If(Pcount()>0,cPar06:=u,cPar06)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBE","",,)
	
	oSay7      := TSay():New( 114,044,{||"Deseja utilizar NF ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
	oCBox1     := TComboBox():New( 114,132,{|u| If(Pcount()>0,cPar07:=u,cPar07)},aSimNao,072,010,oDlg1,,{|| Usanf(cPar07)},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay8      := TSay():New( 131,044,{||"Nota Fiscal ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oGet7      := TGet():New( 131,132,{|u| If(Pcount()>0,cPar08:=u,cPar08)},oDlg1,060,008,'',{||busca()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1","",,)
	
	oSay13      := TSay():New( 148,044,{||"Serie"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet10      := TGet():New( 148,132,{|u| If(Pcount()>0,cPar13:=u,cPar13)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay9      := TSay():New( 165,044,{||"C�d. Fornecedor"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet8      := TGet():New( 165,132,{|u| If(Pcount()>0,cPar09:=u,cPar09)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","",,)
	
	oSay10     := TSay():New( 182,044,{||"Loja"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet9      := TGet():New( 182,132,{|u| If(Pcount()>0,cPar10:=u,cPar10)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay11     := TSay():New( 199,044,{||"Tipo Etiqueta ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oCBox2     := TComboBox():New( 199,132,{|u| If(Pcount()>0,cPar11:=u,cPar11)},aTipImp,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay12     := TSay():New( 216,044,{||"Imprimir em ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oCBox3     := TComboBox():New( 216,132,{|u| If(Pcount()>0,cPar12:=u,cPar12)},aLocImp,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oGrp1      := TGroup():New( 233,024,336,300,"Itens NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
								//248
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{256,028,332,296},,, oGrp1 ) 
		//							256
		oList    := TCBrowse():New(241,028,268,075,, {'C�digo','Descri��o','Qtd NF','Qtd Etiquetas'},;
                                                        {40,60,40,40},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| QtdEtq(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
		oList:bLine := {||{ aList[oList:nAt,01],; 
							aList[oList:nAt,02],;
							aList[oList:nAt,03],; 
							aList[oList:nAt,04]}}
	
	oBtn1      := TButton():New( 326,092,"Ok",oDlg1,{|| oDlg1:end(nOpcao:=1)},037,008,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 326,169,"Cancelar",oDlg1,{|| oDlg1:end(nOpcao:=0)},037,008,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpcao == 1
	If cPar11 == "1"
		//EtiqtaNF(aList)
		Etqpnf()
	Else 
		//EtiqtaPR() antiga
		Etqprat() //nova
		
	EndIf 
EndIf 

Return

/*/{Protheus.doc} Usanf(cPar07)
	(long_description)
	@type  Static Function
	@author user
	@since 07/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Usanf(cPar07)

Local aArea := GetArea()

If cPar07 == "2"
	oSay8:settext("")
	oSay8:settext("Quantidade")
	oGet7      := TGet():New( 131,132,{|u| If(Pcount()>0,cPar08:=u,cPar08)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet8:disable()
	oGet9:disable()
	oGet10:disable()
	oGrp1:disable()
	oList:disable()

Else 
	oSay8:settext("")
	oSay8:settext("Nota Fiscal")
	oGet7      := TGet():New( 131,132,{|u| If(Pcount()>0,cPar08:=u,cPar08)},oDlg1,060,008,'',{||busca()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1","",,)
	oGet8:enable()
	oGet9:enable()
	oGet10:enable()
	oGrp1:enable()
	oList:enable()
EndIf 

oGet7:refresh()
oGet8:refresh()
oGet9:refresh()
oGet10:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} Busca
	(long_description)
	@type  Static Function
	@author user
	@since 07/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Busca()

Local aArea := GetArea()
Local cQuery 

aList := {}

cQuery := "SELECT DISTINCT D1_ITEM,D1_COD,B1_DESC,D1_QUANT,D1_DOC,D1_DTDIGIT,D1_UM,B1_FABRIC,B1_ZMARCA,BE_LOCALIZ,ZPM_DESC" //BZ_XLOCALI
cQuery += " FROM "+RetSQLName("SD1")+" D1"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += "  AND B1_COD=D1_COD AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL='"+xFilial("ZPM")+"' AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SBE")+" BE ON BE_FILIAL=D1_FILIAL AND BE_LOCAL=D1_LOCAL" //AND BE_CODPRO=D1_COD 
cQuery += " AND (CASE WHEN B1_XCODPAI = ' ' THEN B1_COD ELSE B1_XCODPAI END = BE_CODPRO)"
cQuery += " AND BE_LOCALIZ BETWEEN '"+cPar05+"' AND '"+cPar06+"'"
//cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL=D1_FILIAL AND BZ_COD=D1_COD AND BZ.D_E_L_E_T_=' '"
cQuery += "  AND BE.D_E_L_E_T_=' '"
cQuery += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_DOC='"+cPar08+"' AND D1_FORNECE='"+cPar09+"'"
cQuery += " AND D1_LOJA='"+cPar10+"' AND D1_SERIE='"+cPar13+"' AND D1.D_E_L_E_T_=' '"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTR002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	If Ascan(aList,{|x| x[11] == TRB->D1_ITEM}) == 0
		Aadd(aList,{alltrim(TRB->D1_COD),;
					alltrim(TRB->B1_DESC),;
					TRB->D1_QUANT,;
					TRB->D1_QUANT,;
					TRB->D1_DOC,;
					TRB->D1_DTDIGIT,;
					TRB->D1_UM,;
					TRB->B1_FABRIC,;
					TRB->ZPM_DESC,;
					TRB->BE_LOCALIZ,;
					TRB->D1_ITEM})
	EndIf 
	Dbskip()
EndDo 

If len(aList) < 1
	Aadd(aList,{'','',0,0})
else
	oGet8:disable()
	oGet9:disable()
EndIf 

oList:SetArray(aList)
oList:bLine := {||{ aList[oList:nAt,01],; 
					aList[oList:nAt,02],;
					aList[oList:nAt,03],; 
					aList[oList:nAt,04]}}

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} QtdEtq
	(long_description)
	@type  Static Function
	@author user
	@since 07/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function QtdEtq(nLinha)

Local aArea := GetArea()

lEditCell(aList,oList,"@E 999",4)

RestArea(aArea)

Return

/*/{Protheus.doc} Etiqueta Nota
	(long_description)
	@type  Static Function
	@author user
	@since 07/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function EtiqtaNF(aList)

	Local cImpress  := Alltrim(MV_PAR05) //pego o nome da impressora
	Local oFont06	:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Local oFont07	:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.,.F.)
	Local oFont08	:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.,.F.)
	Local oFont09	:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.,.F.)
	Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)

	Local oFont20	:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.,.F.)
 
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
	Local nCont

	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	
	oPrinter:StartPage()
	nLin := 20
	nCol := 09
	nLin2 := 10
	nLin4 := 90
	nLinC		:= 2.70		//Linha que ser� impresso o C�digo de Barra
	nColC		:= 5.7		//Coluna que ser� impresso o C�digo de Barra
	nWidth	 	:= 0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
	nHeigth   	:= 0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
	lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	nPFWidth	:= 0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
	nPula		:= 0
	nEtiquetas	:= 0

	//Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
	For nCont := 1 to len(aList)
		For nR := 1 to aList[nCont,04]

			If nEtiquetas  > 8
				oPrinter:EndPage()
				oPrinter:StartPage()
				nLin := 20
				nCol := 09
				nLin2 := 10
				nLin4 := 90
				nLinC		:= 2.70		//Linha que ser� impresso o C�digo de Barra
				nColC		:= 5.7		//Coluna que ser� impresso o C�digo de Barra
				nWidth	 	:= 0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
				nHeigth   	:= 0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
				lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
				nPFWidth	:= 0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
				nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
				lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
				nPula		:= 0
				nEtiquetas := 0
			EndIf 		

			//oPrinter:Box(10,5,090,170)
			oPrinter:Box(nLin2,5,nLin4,170)
		
			
		    oPrinter:Say(nLin,nCol,alltrim(aList[nCont,01]) ,oFont10)
        
		    nLin+= 10

			If len(alltrim(aList[nCont,02])) > 30
				oPrinter:Say(nLin-1,nCol,substr(aList[nCont,02],1,30) ,oFont07)
				
				oPrinter:Say(nLin+9,nCol,substr(aList[nCont,02],31) ,oFont07)
			Else 
            	oPrinter:Say(nLin,nCol,alltrim(aList[nCont,02]) ,oFont10) 
			EndIf
            
        	oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(aList[nCont,01]), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            
			nLin += 18
			oPrinter:Say(nLin,nCol,alltrim(aList[nCont,08]) ,oFont06)
            nLin += 10
			oPrinter:Say(nLin,nCol,alltrim(aList[nCont,10]) ,oFont06)
            nLin += 10
			oPrinter:Say(nLin,nCol,alltrim(aList[nCont,09]) ,oFont07)
			oPrinter:Say(nLin,nCol+100,"UM:"+alltrim(aList[nCont,07]) ,oFont07)
			nLin += 10
			oPrinter:Say(nLin,nCol,"NF: "+aList[nCont,05] ,oFont07)
			nLin += 10
			oPrinter:Say(nLin,nCol,"DATA: "+cvaltochar(stod(aList[nCont,06]))  ,oFont07)
			nLin += 22
	
			nLin2 += 90
			nLin4 += 90
			nLinC += 7.5 + nPula 
			nPula := 0.1
			nEtiquetas++
		Next
	
	Next nCont
     
	oPrinter:EndPage()
	
	oPrinter:Print()
      
Return


/*/{Protheus.doc} Etqpnf
	Etiqueta produto (NF) vertical
	@type  Static Function
	@author user
	@since 08/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Etqpnf()

	Local cImpress  := cPar12 //Alltrim(MV_PAR05) //pego o nome da impressora
	//Local oFont16	:= TFont():New('Arial',16,16,,.F.,,,,.T.,.F.,.F.)
	Local oFont17	:= TFont():New('Arial',17,17,,.F.,,,,.T.,.F.,.F.)
	Local oFont18	:= TFont():New('Arial',18,18,,.F.,,,,.T.,.F.,.F.)
	//Local oFont09	:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.,.F.)
	Local oFont20	:= TFont():New('Arial',20,20,,.F.,,,,.T.,.F.,.F.)
 
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.

	Local nLin		:= 0
	Local nCol		:= 0
	Local nLinC		:= 0
	Local nR 
	Local nCont 
	Local nColC		:= 0
	Local nWidth	:= 0
	Local nHeigth   := 0
	Local lBanner	:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	Local nPFWidth	:= 0
	Local nPFHeigth	:= 0
	Local lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
 
	Private oPrinter 
	
	If cImpress <> 'ZEBRA'
		oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
		
		oPrinter:SetMargin(001,001,001,001)
	
		oPrinter:StartPage()
	EndIf 

	nLin := 175 //20
	nCol := 15 //20 9
	nLin2 := 05
	nLin4 := 90

	nLinC		:= 1.7 //2.70		//Linha que ser� impresso o C�digo de Barra
	nColC		:= 2.70 //5.7		//Coluna que ser� impresso o C�digo de Barra
	nWidth	 	:= 0.0164 //0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
	lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	nPFWidth	:= 0.02 //0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
	
	nPula		:= 0
	nEtiquetas := 0
	nColBox1   := 180
	nColBox2   := 15

	For nCont := 1 to len(aList)
		If cImpress == 'ZEBRA'
			u_jestr008(aList[nCont,01],aList[nCont,02],aList[nCont,09],aList[nCont,10],cImpress,aList[nCont,04],'1',aList[nCont,08],aList[nCont,05],stod(aList[nCont,06]),aList[nCont,07])
		Else 
			
			For nR := 1 to aList[nCont,04]
					If nR > 1
						oPrinter:EndPage()
						oPrinter:StartPage()
					
					EndIf 		

					oPrinter:Say(nLin-130,nCol+095,alltrim(aList[nCont,01]) ,oFont20,,,90)
					
					If len(alltrim(aList[nCont,02])) > 30
						oPrinter:Say(nLin-130,nCol+75,substr(aList[nCont,02],1,37) ,oFont20,,,90)
						
						oPrinter:Say(nLin-130,nCol+65,substr(aList[nCont,02],38) ,oFont20,,,90)
					Else 
						oPrinter:Say(nLin-130,nCol+75,alltrim(aList[nCont,02]) ,oFont20,,,90) 
					EndIf
					
					oPrinter:FWMSBAR("CODE128" , nLinC+27 , nColC, alltrim(aList[nCont,01]), oPrinter,/*lCheck*/,/*Color*/,.F./*lHorz*/, nWidth, nHeigth+0.7,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
					
					oPrinter:Say(nLin-130,nCol+50,alltrim(aList[nCont,08]) ,oFont18,,,90)
					
					oPrinter:Say(nLin-130,nCol+35,alltrim(aList[nCont,10]) ,oFont18,,,90)
					
					oPrinter:Say(nLin-130,nCol+22,substr(aList[nCont,09],1,12) ,oFont17,,,90)
					
					oPrinter:Say(nLin-130,nCol+10,"NF: "+aList[nCont,05] ,oFont17,,,90)
					oPrinter:Say(nLin,nCol+10,"UM:"+alltrim(aList[nCont,07]) ,oFont17,,,90)

					oPrinter:Say(nLin-130,nCol-4,"DATA: "+cvaltochar(stod(aList[nCont,06]))  ,oFont17,,,90)
				 
			Next nR
		endif
	Next nCont 
	
	If cImpress <> 'ZEBRA'
		oPrinter:EndPage()
		oPrinter:Print()
	EndIf 
 
Return

/*/{Protheus.doc} EtiqtaPR
	Etiqueta Prateleira horizontal
	@type  Static Function
	@author user
	@since 08/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function EtiqtaPR()

	Local cQuery	:= ""
	Local cProdDe	:= cPar03
	Local cProdAte	:= cPar04
	Local nQuant	:= val(cPar07)
	Local cImpress  := cPar12 //pego o nome da impressora
	Local cTipo     := cPar11
	Local oFont08	:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
	//Local cNota  	:= MV_PAR06
	//Local dData 	:= MV_PAR07
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
 
	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	
	//Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
 
	cQuery := "SELECT B1_COD AS CODIGO,B1_DESC AS DESCRI,B1_CODBAR AS CODBAR,ZPM_DESC AS MARCA,B1_UM AS UM,"
	cQuery += " B1_FABRIC,BZ_XLOCALI"
    cQuery += " FROM "+RetSQLName("SB1")+" B1"
    cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
	cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL='"+xFilial("SBZ")+"' AND BZ_COD=B1_COD AND BZ.D_E_L_E_T_=' '"
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"

    cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'"
 
	TcQuery cQuery New Alias "QRYTMP"
	QRYTMP->(DbGoTop())
 
	oPrinter:SetMargin(001,001,001,001)
 
	oPrinter:StartPage()
	nLin := 20
	nCol := 9
	nLin2 := 10
	nLin4 := 70

	nLinC		:= 2.70		//Linha que ser� impresso o C�digo de Barra
	nColC		:= 5.7		//Coluna que ser� impresso o C�digo de Barra
	nWidth	 	:= 0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
	lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	nPFWidth	:= 0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
	
	nPula		:= 0
	nEtiquetas := 0

	While QRYTMP->(!Eof())
		For nR := 1 to nQuant
			If nEtiquetas  > 8
				oPrinter:EndPage()
				oPrinter:StartPage()
				nLin := 20
				nCol := 09
				nLin2 := 10
				nLin4 := 70
				nLinC		:= 2.70		//Linha que ser� impresso o C�digo de Barra
				nColC		:= 5.7		//Coluna que ser� impresso o C�digo de Barra
				nWidth	 	:= 0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
				nHeigth   	:= 0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
				lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
				nPFWidth	:= 0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
				nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
				lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
				nPula		:= 0
				nEtiquetas := 0
			EndIf 		

			If cTipo == "1"
            	oPrinter:Box(10,5,100,160)
			else
				oPrinter:Box(nLin2,5,nLin4,170)
			EndIf
 
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) ,oFont10)
            nLin+= 10

			If len(alltrim(QRYTMP->DESCRI)) > 30
				oPrinter:Say(nLin-1,nCol,substr(QRYTMP->DESCRI,1,30) ,oFont08)
				
				oPrinter:Say(nLin+9,nCol,substr(QRYTMP->DESCRI,31) ,oFont08)
			Else 
            	oPrinter:Say(nLin,nCol,alltrim(QRYTMP->DESCRI) ,oFont10) 
			EndIf
            
			oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
            
			nLin += 18
			oPrinter:Say(nLin,nCol,alltrim(QRYTMP->B1_FABRIC) ,oFont08)
            nLin += 10
			oPrinter:Say(nLin,nCol,alltrim(QRYTMP->BZ_XLOCALI) ,oFont08)

			nLin += 32
	
			nLin2 += 70
			nLin4 += 70
			nLinC += 5.92 //+ nPula 
			//nPula := 0.1
			nEtiquetas++
		
		Next
		QRYTMP->(DbSkip())
	EndDo

	oPrinter:EndPage()
	oPrinter:Print()
      

	QRYTMP->(DbCloseArea())
 
Return



/*/{Protheus.doc} Etqprat
	Etiqueta prateleira vertical
	@type  Static Function
	@author user
	@since 08/03/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Etqprat()

	Local cQuery	:= ""
	Local cProdDe	:= cPar03
	Local cProdAte	:= cPar04
	Local nQuant	:= If(cPar07<>'1',val(cPar08),'')
	Local cImpress  := cPar12 
	Local oFont40	:= TFont():New('Arial',80,80,,.F.,,,,.T.,.F.,.F.)
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
	Local lTrocaPag := .F.
	Local nCont 

	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	
	If len(aList[1]) < 5
		cQuery := "SELECT DISTINCT B1_COD AS CODIGO,B1_DESC AS DESCRI,B1_CODBAR AS CODBAR,ZPM_DESC AS MARCA,B1_UM AS UM,"
		cQuery += " B1_FABRIC,BE_LOCALIZ,B1_XCODPAI" //BZ_XLOCALI
		cQuery += " FROM "+RetSQLName("SB1")+" B1"
		
		cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
		//cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL='"+xFilial("SBZ")+"' AND BZ_COD=B1_COD AND BZ.D_E_L_E_T_=' '"
		cQuery += " LEFT JOIN "+RetSQLName("SBE")+" BE ON BE_FILIAL='"+xFilial("SBE")+"' AND BE.D_E_L_E_T_=' '"
		cQuery += " AND BE_LOCALIZ BETWEEN '"+cPar05+"' AND '"+cPar06+"'"
		
		cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"

		cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'"
		
		cQuery += " AND B1.D_E_L_E_T_=' ' "

		TcQuery cQuery New Alias "QRYTMP"
		QRYTMP->(DbGoTop())
	EndIf 

	If cImpress <> 'ZEBRA'
		oPrinter:SetMargin(001,001,001,001)
	
		oPrinter:StartPage()
	EndIf 

	nLin := 175 //20
	nCol := 55//15 //20 9
	nLin2 := 05
	nLin4 := 70

	nLinC		:= 1.7 //2.70		//Linha que ser� impresso o C�digo de Barra
	nColC		:= 2.70 //5.7		//Coluna que ser� impresso o C�digo de Barra
	nWidth	 	:= 0.0164 //0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
	lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	nPFWidth	:= 0.02 //0.8		//N�mero do �ndice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//N�mero do �ndice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
	
	nPula		:= 0
	nEtiquetas := 0
	nColBox1   := 180
	nColBox2   := 15
	
	If len(aList[1]) < 5
		While QRYTMP->(!Eof())

			If cImpress == 'ZEBRA'
				If nQuant < 1
					nQuant := 1
				EndIf 

				u_jestr008(alltrim(QRYTMP->CODIGO),alltrim(QRYTMP->DESCRI),alltrim(QRYTMP->B1_FABRIC),alltrim(QRYTMP->BE_LOCALIZ),cImpress,nQuant)
				
			Else
				For nR := 1 to nQuant
					If lTrocaPag
						oPrinter:EndPage()
						oPrinter:StartPage()
					endIf 
					

					oPrinter:Say(nLin-130,nCol+445,alltrim(QRYTMP->CODIGO) ,oFont40,,,90)
					
					If len(alltrim(QRYTMP->DESCRI)) > 30
						oPrinter:Say(nLin-130,nCol+395,substr(QRYTMP->DESCRI,1,60) ,oFont40,,,90)
						
						oPrinter:Say(nLin-130,nCol+394,substr(QRYTMP->DESCRI,61) ,oFont40,,,90)
					Else 
						oPrinter:Say(nLin-130,nCol+395,alltrim(QRYTMP->DESCRI) ,oFont40,,,90) 
					EndIf
					
					
					oPrinter:FWMSBAR("CODE128" , nLinC+27 , nColC, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,.F./*lHorz*/, nWidth, nHeigth+0.7,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
					
					oPrinter:Say(nLin-130,nCol+50,alltrim(QRYTMP->B1_FABRIC) ,oFont40,,,90)
					
					oPrinter:Say(nLin-130,nCol+35,alltrim(QRYTMP->BE_LOCALIZ) ,oFont40,,,90)
					
					lTrocaPag := .t.
				
				Next
			EndIf 
			QRYTMP->(DbSkip())
		EndDo
	Else 
		For nCont := 1 to len(aList)
			If cImpress == 'ZEBRA'
				u_jestr008(aList[nCont,01],aList[nCont,02],aList[nCont,09],aList[nCont,10],cImpress,aList[nCont,04],'2',aList[nCont,08],aList[nCont,05],stod(aList[nCont,06]),aList[nCont,07])
			EndIF 
		Next nCont
	EndIf 

	If cImpress <> 'ZEBRA'
		oPrinter:EndPage()
		oPrinter:Print()
	EndIf 
      
	If len(aList[1]) < 5
		QRYTMP->(DbCloseArea())
	EndIf 
 
Return
