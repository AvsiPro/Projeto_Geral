#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
/*
    Rotina para impressão de etiquetas
    35-MIT 44_ESTOQUE_EST017 - Criar programa para impressão de etiqueta
    
    DOC MIT
    
	DOC Entrega
    https://docs.google.com/document/d/1jefVMEpeQ6nl4ghy2sUK1D65O5tv92yc/edit
    
*/
User Function JESTR002(nOpc)

	Default nOpc := 0

	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","00020087")
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
Private aLocImp := {'1=PDF Creator','2=Impressora'}
Private cPar12 := aLocImp[1]

Private oDlg1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11
Private oGet1,oGet2,oGet3,oGet4,oGet5,oGet6,oCBox1,oGet7,oGet8,oGet9,oCBox2,oCBox3
Private oBtn1,oBtn2
Private aList := {}
Private oList 

Aadd(aList,{'','','',''})

oDlg1      := MSDialog():New( 186,980,914,1624,"Etiqueta de Produto",,,.F.,,,,,,.T.,,,.T. )

	oSay1      := TSay():New( 012,044,{||"Armazém de ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oGet1      := TGet():New( 012,132,{|u| If(Pcount()>0,cPar01:=u,cPar01)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"NNR","",,)
	
	oSay2      := TSay():New( 033,044,{||"Armazém Ate ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	oGet2      := TGet():New( 032,132,{|u| If(Pcount()>0,cPar02:=u,cPar02)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"NNR","",,)
	
	oSay3      := TSay():New( 052,044,{||"Produto de ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oGet3      := TGet():New( 052,132,{|u| If(Pcount()>0,cPar03:=u,cPar03)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	
	oSay4      := TSay():New( 073,044,{||"Produto Ate ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oGet4      := TGet():New( 072,132,{|u| If(Pcount()>0,cPar04:=u,cPar04)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	
	oSay5      := TSay():New( 093,044,{||"Endereço de ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	oGet5      := TGet():New( 092,132,{|u| If(Pcount()>0,cPar05:=u,cPar05)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBE","",,)
	
	oSay6      := TSay():New( 112,044,{||"Endereço Ate ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,039,008)
	oGet6      := TGet():New( 112,132,{|u| If(Pcount()>0,cPar06:=u,cPar06)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBE","",,)
	
	oSay7      := TSay():New( 133,044,{||"Deseja utilizar NF ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
	oCBox1     := TComboBox():New( 132,132,{|u| If(Pcount()>0,cPar07:=u,cPar07)},aSimNao,072,010,oDlg1,,{|| Usanf(cPar07)},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay8      := TSay():New( 152,044,{||"Nota Fiscal ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oGet7      := TGet():New( 152,132,{|u| If(Pcount()>0,cPar08:=u,cPar08)},oDlg1,060,008,'',{||busca()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1J01","",,)
	
	oSay9      := TSay():New( 172,044,{||"Cód. Fornecedor"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet8      := TGet():New( 172,132,{|u| If(Pcount()>0,cPar09:=u,cPar09)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","",,)
	
	oSay10     := TSay():New( 193,044,{||"Loja"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet9      := TGet():New( 192,132,{|u| If(Pcount()>0,cPar10:=u,cPar10)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay11     := TSay():New( 213,044,{||"Tipo Etiqueta ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oCBox2     := TComboBox():New( 212,132,{|u| If(Pcount()>0,cPar11:=u,cPar11)},aTipImp,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay12     := TSay():New( 232,044,{||"Imprimir em ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)
	oCBox3     := TComboBox():New( 232,132,{|u| If(Pcount()>0,cPar12:=u,cPar12)},aLocImp,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oGrp1      := TGroup():New( 248,024,336,300,"Itens NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{256,028,332,296},,, oGrp1 ) 
		oList    := TCBrowse():New(256,028,268,075,, {'Código','Descrição','Qtd NF','Qtd Etiquetas'},;
                                                        {40,60,40,40},;
                                                        oGrp1,,,,{|| /*FHelp(oList:nAt)*/},{|| QtdEtq(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
        oList:SetArray(aList)
		oList:bLine := {||{ aList[oList:nAt,01],; 
							aList[oList:nAt,02],;
							aList[oList:nAt,03],; 
							aList[oList:nAt,04]}}
	
	oBtn1      := TButton():New( 341,092,"Ok",oDlg1,{|| oDlg1:end(nOpcao:=1)},037,008,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 341,169,"Cancelar",oDlg1,{|| oDlg1:end(nOpcao:=0)},037,008,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpcao == 1
	If cPar11 == "1"
		//EtiqtaNF(aList)
		Etqpnf()
	Else 
		//EtiqtaPR()
		Etqprat()
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
	oGet7      := TGet():New( 152,132,{|u| If(Pcount()>0,cPar08:=u,cPar08)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet8:disable()
	oGet9:disable()
	oGrp1:disable()
	oList:disable()

Else 
	oSay8:settext("")
	oSay8:settext("Nota Fiscal")
	oGet7      := TGet():New( 152,132,{|u| If(Pcount()>0,cPar08:=u,cPar08)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1J01","",,)
	oGet8:enable()
	oGet9:enable()
	oGrp1:enable()
	oList:enable()
EndIf 

oGet7:refresh()
oGet8:refresh()
oGet9:refresh()
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

cQuery := "SELECT D1_COD,B1_DESC,D1_QUANT,D1_DOC,D1_DTDIGIT,D1_UM,B1_FABRIC,B1_ZMARCA,BZ_XLOCALI,ZPM_DESC"
cQuery += " FROM "+RetSQLName("SD1")+" D1"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += "  AND B1_COD=D1_COD AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL='"+xFilial("ZPM")+"' AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
//cQuery += " LEFT JOIN "+RetSQLName("SBE")+" BE ON BE_FILIAL=D1_FILIAL AND BE_CODPRO=D1_COD AND BE_LOCAL=D1_LOCAL"
cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL=D1_FILIAL AND BZ_COD=D1_COD AND BZ.D_E_L_E_T_=' '"
//cQuery += "  AND BE.D_E_L_E_T_=' '"
cQuery += " WHERE D1_FILIAL='"+xFilial("SD1")+"' AND D1_DOC='"+cPar08+"' AND D1_FORNECE='"+cPar09+"'"
cQuery += " AND D1_LOJA='"+cPar10+"' AND D1.D_E_L_E_T_=' '"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTR002.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	Aadd(aList,{alltrim(TRB->D1_COD),;
				alltrim(TRB->B1_DESC),;
				TRB->D1_QUANT,;
				TRB->D1_QUANT,;
				TRB->D1_DOC,;
				TRB->D1_DTDIGIT,;
				TRB->D1_UM,;
				TRB->B1_FABRIC,;
				TRB->ZPM_DESC,;
				TRB->BZ_XLOCALI})
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
 
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
    Local nR 

	Local nLin		:= 0
	Local nCol		:= 0
	Local nLinC		:= 0
	Local nColC		:= 0
	Local nWidth	:= 0
	Local nHeigth   := 0
	Local lBanner	:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	Local nPFWidth	:= 0
	Local nPFHeigth	:= 0
	Local lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
	Local nCont

	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	
	oPrinter:StartPage()
	nLin := 20
	nCol := 09
	nLin2 := 10
	nLin4 := 90
	nLinC		:= 2.70		//Linha que será impresso o Código de Barra
	nColC		:= 5.7		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 0.8		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
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
				nLinC		:= 2.70		//Linha que será impresso o Código de Barra
				nColC		:= 5.7		//Coluna que será impresso o Código de Barra
				nWidth	 	:= 0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
				nHeigth   	:= 0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
				lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
				nPFWidth	:= 0.8		//Número do índice de ajuste da largura da fonte. Default 1
				nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
				lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
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

	Local cImpress  := Alltrim(MV_PAR05) //pego o nome da impressora
	Local oFont06	:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Local oFont07	:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.,.F.)
	Local oFont08	:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.,.F.)
	Local oFont09	:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.,.F.)
	Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
 
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
/*
	Local cQuery	:= ""
	Local cProdDe	:= cPar03
	Local cProdAte	:= cPar04
	Local nQuant	:= val(cPar08)
	Local cTipo     := cPar11
	Local oFont08	:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
	
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
    Local nR 
*/
	Local nLin		:= 0
	Local nCol		:= 0
	Local nLinC		:= 0
	Local nR 
	Local nCont 
	Local nColC		:= 0
	Local nWidth	:= 0
	Local nHeigth   := 0
	Local lBanner	:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	Local nPFWidth	:= 0
	Local nPFHeigth	:= 0
	Local lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 
	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	
	//Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
 /*
	cQuery := "SELECT DISTINCT B1_COD AS CODIGO,B1_DESC AS DESCRI,B1_CODBAR AS CODBAR,ZPM_DESC AS MARCA,B1_UM AS UM,"
	cQuery += " B1_FABRIC,BZ_XLOCALI"
    cQuery += " FROM "+RetSQLName("SB1")+" B1"
    cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
	cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL='"+xFilial("SBZ")+"' AND BZ_COD=B1_COD AND BZ.D_E_L_E_T_=' '"
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"

    cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'"
	
	cQuery += " AND B1.D_E_L_E_T_=' ' "

	TcQuery cQuery New Alias "QRYTMP"
	QRYTMP->(DbGoTop())
*/
	oPrinter:SetLandscape()
 
	oPrinter:SetMargin(001,001,001,001)
 
	oPrinter:StartPage()
	nLin := 175 //20
	nCol := 15 //20 9
	nLin2 := 05
	nLin4 := 90

	nLinC		:= 1.7 //2.70		//Linha que será impresso o Código de Barra
	nColC		:= 2.70 //5.7		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.0164 //0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 0.02 //0.8		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
	
	nPula		:= 0
	nEtiquetas := 0
	nColBox1   := 180
	nColBox2   := 15

	//While QRYTMP->(!Eof())
	//	For nR := 1 to 2 //nQuant
	For nCont := 1 to len(aList)
		For nR := 1 to aList[nCont,04]
			If nEtiquetas  > 9
				oPrinter:EndPage()
				oPrinter:StartPage()
				nLin := 175 //20
				nCol := 15 //20 09
				nLin2 := 05
				nLin4 := 90
				nLinC		:= 1.7//2.70		//Linha que será impresso o Código de Barra
				nColC		:= 2.7 //5.7		//Coluna que será impresso o Código de Barra
				nWidth	 	:= 0.0164 //0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
				nHeigth   	:= 0.8 //0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
				lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
				nPFWidth	:= 0.2 //0.8		//Número do índice de ajuste da largura da fonte. Default 1
				nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
				lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
				nPula		:= 0
				nEtiquetas := 0
			EndIf 		

			//If cTipo == "1"
            	//oPrinter:Box(10,5,100,160)
				oPrinter:Box(nColBox1,nLin2,nColBox2,nLin4)
			/*else
				//oPrinter:Box(nLin2,5,nLin4,170)

				//oPrinter:Box(180,nLin2,15,nLin4)
				//				180		10	   15	   70
				oPrinter:Box(nColBox1,nLin2,nColBox2,nLin4)*/
			//EndIf
 
            oPrinter:Say(nLin,nCol,alltrim(aList[nCont,01]) ,oFont10,,,270)
            
			nCol += 10

			If len(alltrim(aList[nCont,02])) > 30
				oPrinter:Say(nLin,nCol-1,substr(aList[nCont,02],1,37) ,oFont08,,,270)
				
				oPrinter:Say(nLin,nCol+9,substr(aList[nCont,02],38) ,oFont08,,,270)
			Else 
            	oPrinter:Say(nLin,nCol,alltrim(aList[nCont,02]) ,oFont10,,,270) 
			EndIf
            
			if nEtiquetas > 2
				nColC -= 0.28
			endif
			
			oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(aList[nCont,01]), oPrinter,/*lCheck*/,/*Color*/,.F./*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
			
			nCol += 12
			oPrinter:Say(nLin,nCol,alltrim(aList[nCont,08]) ,oFont08,,,270)
            nCol += 10
			oPrinter:Say(nLin,nCol,alltrim(aList[nCont,10]) ,oFont06,,,270)
			
			nCol += 10
			oPrinter:Say(nLin,nCol,substr(aList[nCont,09],1,12) ,oFont07,,,270)
			nCol += 10
			oPrinter:Say(nLin,nCol,"NF: "+aList[nCont,05] ,oFont07,,,270)
			oPrinter:Say(nLin-100,nCol,"UM:"+alltrim(aList[nCont,07]) ,oFont07,,,270)

			nCol += 10
			oPrinter:Say(nLin,nCol,"DATA: "+cvaltochar(stod(aList[nCont,06]))  ,oFont07,,,270)

			nCol +=  28 //38 //50
			nColC += 7.7 //2
			nLin2 += 90
			nLin4 += 90
			
			nEtiquetas++
		
		Next nR
	Next nCont 
	/*	QRYTMP->(DbSkip())
	EndDo*/

	oPrinter:EndPage()
	oPrinter:Print()
      

	//QRYTMP->(DbCloseArea())
 
Return

/*/{Protheus.doc} nomeStaticFunction
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
	Local lBanner	:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	Local nPFWidth	:= 0
	Local nPFHeigth	:= 0
	Local lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 
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

	nLinC		:= 2.70		//Linha que será impresso o Código de Barra
	nColC		:= 5.7		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 0.8		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
	
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
				nLinC		:= 2.70		//Linha que será impresso o Código de Barra
				nColC		:= 5.7		//Coluna que será impresso o Código de Barra
				nWidth	 	:= 0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
				nHeigth   	:= 0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
				lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
				nPFWidth	:= 0.8		//Número do índice de ajuste da largura da fonte. Default 1
				nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
				lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
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
	Local nQuant	:= val(cPar08)
	Local cImpress  := cPar12 
	Local cTipo     := cPar11
	Local oFont08	:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.,.F.)
	Local oFont10	:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.,.F.)
	
	Local lAdjustToLegacy 	:= .F.
	Local lDisableSetup  	:= .T.
    Local nR 

	Local nLin		:= 0
	Local nCol		:= 0
	Local nLinC		:= 0
	Local nColC		:= 0
	Local nWidth	:= 0
	Local nHeigth   := 0
	Local lBanner	:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	Local nPFWidth	:= 0
	Local nPFHeigth	:= 0
	Local lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 
	Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_PDF,lAdjustToLegacy,"C:\TEMP\",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)
	
	//Para saber mais sobre o componente FWMSPrinter acesse http://tdn.totvs.com/display/public/mp/FWMsPrinter
 
	cQuery := "SELECT DISTINCT B1_COD AS CODIGO,B1_DESC AS DESCRI,B1_CODBAR AS CODBAR,ZPM_DESC AS MARCA,B1_UM AS UM,"
	cQuery += " B1_FABRIC,BZ_XLOCALI"
    cQuery += " FROM "+RetSQLName("SB1")+" B1"
    cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"
	cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL='"+xFilial("SBZ")+"' AND BZ_COD=B1_COD AND BZ.D_E_L_E_T_=' '"
    cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"

    cQuery += " AND B1_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"'"
	
	cQuery += " AND B1.D_E_L_E_T_=' ' "

	TcQuery cQuery New Alias "QRYTMP"
	QRYTMP->(DbGoTop())

	oPrinter:SetLandscape()
 
	oPrinter:SetMargin(001,001,001,001)
 
	oPrinter:StartPage()
	nLin := 175 //20
	nCol := 15 //20 9
	nLin2 := 05
	nLin4 := 70

	nLinC		:= 1.7 //2.70		//Linha que será impresso o Código de Barra
	nColC		:= 2.70 //5.7		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.0164 //0.0484	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 0.02 //0.8		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
	
	nPula		:= 0
	nEtiquetas := 0
	nColBox1   := 180
	nColBox2   := 15

	While QRYTMP->(!Eof())
		For nR := 1 to nQuant
			If nEtiquetas  > 12
				oPrinter:EndPage()
				oPrinter:StartPage()
				nLin := 175 //20
				nCol := 15 //20 09
				nLin2 := 05
				nLin4 := 70
				nLinC		:= 1.7//2.70		//Linha que será impresso o Código de Barra
				nColC		:= 2.7 //5.7		//Coluna que será impresso o Código de Barra
				nWidth	 	:= 0.0164 //0.0464	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
				nHeigth   	:= 0.8 //0.7		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
				lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
				nPFWidth	:= 0.2 //0.8		//Número do índice de ajuste da largura da fonte. Default 1
				nPFHeigth	:= 0.9		//Número do índice de ajuste da altura da fonte. Default 1
				lCmtr2Pix	:= .T.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
				nPula		:= 0
				nEtiquetas := 0
			EndIf 		

			If cTipo == "1"
            	oPrinter:Box(10,5,100,160)
			else
				//oPrinter:Box(nLin2,5,nLin4,170)

				//oPrinter:Box(180,nLin2,15,nLin4)
				//				180		10	   15	   70
				oPrinter:Box(nColBox1,nLin2,nColBox2,nLin4)
			EndIf
 
            oPrinter:Say(nLin,nCol,alltrim(QRYTMP->CODIGO) ,oFont10,,,270)
            
			nCol += 10

			If len(alltrim(QRYTMP->DESCRI)) > 30
				oPrinter:Say(nLin,nCol-1,substr(QRYTMP->DESCRI,1,60) ,oFont08,,,270)
				
				oPrinter:Say(nLin,nCol+9,substr(QRYTMP->DESCRI,61) ,oFont08,,,270)
			Else 
            	oPrinter:Say(nLin,nCol,alltrim(QRYTMP->DESCRI) ,oFont10,,,270) 
			EndIf
            
			if nEtiquetas > 2
				nColC += 0.28
			endif
			
			oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,.F./*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
			
			nCol += 12
			oPrinter:Say(nLin,nCol,alltrim(QRYTMP->B1_FABRIC) ,oFont08,,,270)
            nCol += 10
			oPrinter:Say(nLin,nCol,alltrim(QRYTMP->BZ_XLOCALI) ,oFont08,,,270)
			
			nCol += 38 //50
			nColC += 5.7 //2
			nLin2 += 70
			nLin4 += 70
			
			nEtiquetas++
		
		Next
		QRYTMP->(DbSkip())
	EndDo

	oPrinter:EndPage()
	oPrinter:Print()
      

	QRYTMP->(DbCloseArea())
 
Return
