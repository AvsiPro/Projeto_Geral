#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"

#DEFINE IMP_SPOOL  6
#DEFINE DMPAPER_A4 9 /* A4 210 x 297 mm */

/*/{Protheus.doc} REPORT4
Funcao para adicionar linha vazia
@author BRB Digital
@since 25/05/2022
@version 1.0
@type function
/*/

User Function RSC6001()

Private nTaxa     := 0
Private cDtTime 	:= DTOS(dDatabase)+StrTran(Time(),":")
Private npZebrado	:= 0
Private cPerg    	:= "RSC6000001"
Private cArquivo 	:= "" 
Private oFWMsExcel
Private oExcel

ValidPerg(cPerg)
Pergunte(cPerg,.T.)

LJMsgRun("Processando.....Pedidos de Vendas.....","Aguarde....",{|| XGera1() })

Return    

/*/{Protheus.doc} REPORT3
Funcao para adicionar linha vazia
@author BRB Digital
@since 25/05/2022
@version 1.0
@type function
/*/

Static Function XGera1()
Local aDados   := {}
Local nUlt 		 := 0 
Local nP       := 0
Local aArea	   := GetArea()
Local aCliente := {}
Local aEmpty   := {} 
Local ACOLPR   := {}
Local cXLS     := "RSC6001"+cDtTime+".XML"
Local cTmp     := getTempPath()
Local cFile 	 := ""

Private aCheck := {}

cPath := tFileDialog( "Selecione a pasta ",'Selecao de pasta',, cTmp, .F., GETF_RETDIRECTORY+GETF_LOCALFLOPPY+GETF_LOCALHARD )

cQuery:=""
cQuery+=" SELECT C6_NUM,A1_COD,A1_LOJA,A1_NOME,C6_PRODUTO,C6_QTDVEN,C5_CONDPAG,C5_VEND1,A3_NOME,E4_DESCRI,A1_END,A1_BAIRRO,A1_CONTATO,A1_CGC,A1_INSCR,A1_DDD,A1_TEL, "
cQuery+=" A1_ENDENT,A1_BAIRROE,A1_CEPE,A1_CEP,A1_EMAIL,C6_ITEM,A1_EST,A1_ESTE "
cQuery+=" FROM " + RetSqlName("SC6")+" SC6 " 
cQuery+=" INNER JOIN "+ RetSqlName("SA1") + " SA1  ON C6_CLI=A1_COD AND C6_LOJA=A1_LOJA AND SA1.D_E_L_E_T_ = ' '"
cQuery+=" INNER JOIN "+ RetSqlName("SC5") + " SC5  ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND SC5.D_E_L_E_T_=' ' "
cQuery+=" INNER JOIN "+ RetSqlName("SE4") + " SE4  ON C5_CONDPAG=E4_CODIGO AND SE4.D_E_L_E_T_=' ' "
cQuery+=" INNER JOIN "+ RetSqlName("SA3") + " SA3  ON C5_VEND1=A3_COD AND SA3.D_E_L_E_T_=' '"
cQuery+=" WHERE "
cQuery+=" C6_FILIAL = '" + MV_PAR01 + "' AND  C6_NUM='" + MV_PAR02 + "' AND SC6.D_E_L_E_T_ = ' '  "
cQuery+=" ORDER BY C6_PRODUTO"


If Select("XQRY") > 0
	XQRY->(DbCloseArea())
EndIf

TCQuery cQuery New Alias "XQRY"  

If MV_PAR03==1//PDF
		cFile := "RSC6001"+cDtTime
		fGeraPdf(cPath,cFile)	
Else

	aAdd(aEmpty,{ "","","","","" })
	aAdd(aColPr,{ "Produto","Quantidade","","","" })

	aCheck := {}
	aAdd(aCheck,"liberado:")	//01
	aAdd(aCheck,"data:")		//02
	aAdd(aCheck,"hora:") 		//03
	aAdd(aCheck,"tirado:") 		//04
	aAdd(aCheck,"data:") 		//05
	//aAdd(aCheck,"hora:") 		//06
	aAdd(aCheck,"confirmado:")	//07
	aAdd(aCheck,"data:")		//08
	//aAdd(aCheck,"hora:")		//09
	aAdd(aCheck,"embalado:")	//10
	aAdd(aCheck,"data:")		//11
	aAdd(aCheck,"hora:")		//12
	aAdd(aCheck,"")				//13
	aAdd(aCheck,"tirado da mesa:")//14
	aAdd(aCheck,"data:")		//15
	aAdd(aCheck,"hora:")		//16
	aAdd(aCheck,"")				//13
	aAdd(aCheck,"fechado caixa:")//17
	aAdd(aCheck,"data:")		//18
	//aAdd(aCheck,"hora:")		//19
	//aAdd(aCheck,"")				//20
	aAdd(aCheck,"Altura:")		//21
	//aAdd(aCheck,"")//22
	aAdd(aCheck,"Largura:")		//23
	//aAdd(aCheck,"")//24
	aAdd(aCheck,"Comprimento:")//25
	///aAdd(aCheck,"")//26
	aAdd(aCheck,"Peso:")//27
	aAdd(aCheck,"")//27
	aAdd(aCheck,"Garantia:")//27
	aAdd(aCheck,"Sacola:")//27
	aAdd(aCheck,"")//27
	aAdd(aCheck,"Flanela:")//27
	aAdd(aCheck,"Estojo:")//27
	
	nSel:=0
	nTotalVendor :=0
	DbSelectArea("XQRY")
	XQRY->(DbGoTop())

	oFWMsExcel := FWMsExcelEx():New()
	oFWMsExcel:AddworkSheet("Pedido de Venda")
	oFWMsExcel:AddTable( "Pedido de Venda" ,"Pedido de Venda "+MV_PAR02)
	oFWMsExcel:AddColumn("Pedido de Venda" ,"Pedido de Venda "+MV_PAR02 ,Space(40)			  ,1)       // 4-Produto
	oFWMsExcel:AddColumn("Pedido de Venda" ,"Pedido de Venda "+MV_PAR02 ,Space(15)        ,3,2)     // 5-Quantidade                           
	oFWMsExcel:AddColumn("Pedido de Venda" ,"Pedido de Venda "+MV_PAR02 ,Space(5)					,1)       // 6-Quantidade                           
	oFWMsExcel:AddColumn("Pedido de Venda" ,"Pedido de Venda "+MV_PAR02 ,Space(15)			  ,1)       // 7-Quantidade                           
	oFWMsExcel:AddColumn("Pedido de Venda" ,"Pedido de Venda "+MV_PAR02 ,Space(10) 	      ,1)       // 8-Quantidade                           
	oFWMsExcel:SetTitleBgColor("#fff2cc")
	oFWMsExcel:SetHeaderSizeFont(12)
	oFWMsExcel:SetHeaderBold(.T.)
	oFWMsExcel:SetBgColorHeader("#9bc2e6")

	aSM0:={}
	aAdd(aSM0,{;
											"" + Alltrim(SM0->M0_NOMECOM) +' - ' +Alltrim(SM0->M0_FILIAL) ,;
											"",;
											"",;
											"",;
											"";
											};
											)

	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aSM0[1] , {1,2,3,4,5} )

	aCliente:={}
	aAdd(aCliente,{;
											"Cliente: " + Alltrim(XQRY->A1_COD) + ' - ' + Alltrim(XQRY->A1_NOME) ,;
											"",;
											"",;
											"",;
											"";
											};
											)

	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aCliente[1] , {1,2,3,4,5} )
				

	aContato :={}
	aAdd(aContato,{;
											"Contato: " + Alltrim(XQRY->A1_CONTATO),;
											"",;
											"",;
											"",;
											"";
											};
											)

	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aContato[1] , {1,2,3,4,5} )

	aVendedor :={}
	aAdd(aVendedor,{;
											"Vendedor: " + Alltrim(XQRY->A3_NOME),;
											"",;
											"",;
											"",;
											"";
											};
											)

	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aVendedor[1] , {1,2,3,4,5} )


	aCondPag :={}
	aAdd(aCondPag,{;
											"Pagamento: " + Alltrim(XQRY->C5_CONDPAG) + ' - '+ Alltrim(XQRY->E4_DESCRI) ,;
											"",;
											"",;
											"",;
											"";
											};
											)

	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aCondPag[1] , {1,2,3,4,5} )


	aEndereco :={}
	aAdd(aEndereco,{;
											"Endereço: " + Alltrim(XQRY->A1_END) + ' - Bairro: '+ Alltrim(XQRY->A1_BAIRRO)+' - CEP: '+ Alltrim(XQRY->A1_CEP) + ' - Estado: '+XQRY->A1_EST,;
											"",;
											"",;
											"",;
											"";
											};
											)

	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aEndereco[1] , {1,2,3,4,5} )


	aEnd2 :={}
	aAdd(aEnd2,{;
											"Endereço Entrega: " + Alltrim(XQRY->A1_ENDENT) + ' - Bairro: '+ Alltrim(XQRY->A1_BAIRROE)+' - CEP: '+ Alltrim(XQRY->A1_CEPE)+' - Estado: '+XQRY->A1_ESTE ,;
											"",;
											"",;
											"",;
											"";
											};
											)

	//printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aEnd2[1] , {1,2,3,4,5} )
	printInfo( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aEnd2[1] , {1,2,3,4,5} )

	printInfo( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aEmpty[1] , {1,2,3,4,5} )
	printTotLi( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aColPr[1] , {1,2,3,4,5} )
	XQRY->(DbGoTop())
	WHILE XQRY->(!Eof()) 

				nSel   += 1

				aAdd(aDados,{;
											Alltrim(XQRY->C6_PRODUTO),;
											XQRY->C6_QTDVEN,;
											"",;
											"",;
											"";
											};
											)

				If nSel>0 .And. nSel<=28
					aDados[Len(aDados)][4] := aCheck[nSel]
					If nSel==1
						aDados[nSel][5] := cUserName
					Endif
					If nSel==2
						aDados[nSel][5] := DTOC(dDatabase)
					Endif
					If nSel==3
						aDados[nSel][5] := Time()
					Endif
				Endif

				printInfo( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aDados[nSel] , {1,2,3,4,5} )
				
			
				nTotalVendor  += XQRY->C6_QTDVEN

		XQRY->(DbSkip()) 													
	End	

	If nSel<27
		nUlt := Len(aDados) + 1
		For nP := nUlt  To 27
			aAdd(aDados,{;
											"",;
											"",;
											"",;
											"",;
											"";
											};
											)
			aDados[Len(aDados)][4] := aCheck[nP]

			if nP>1
				aDados[1][5] := cUserName
			Endif	
			if nP==2
				aDados[2][5] := DTOC(dDatabase)
			endif
			if nP==3
				aDados[3][5] := Time()
			Endif	

			printInfo( @oFWMsExcel,"Pedido de Venda","Pedido de Venda "+MV_PAR02, aDados[nP] , {1,2,3,4,5} )
		Next
	Endif

	aTotal:={}
	aAdd(aTotal,{ "Total","",nTotalVendor,"","" })  
	printTotLi( oFWMsExcel, "Pedido de Venda", "Pedido de Venda "+MV_PAR02, aTotal[1] , {1,2,3,4,5} )            

	If Substr(cPath,Len(cPath),1)<>"\"
		cPath := cPath+"\"
	Endif	

	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cPath+cXLS)
	ShellExecute("Open",cPath +cXLS,"","",1)

Endif	

XQRY->(DbCloseArea())
RestArea(aArea)

Return

/*/{Protheus.doc} printInfo
Funcao para adicionar linha vazia
/*/
Static Function printInfo( oExcel, clAba, clTab, aDados , aPositions )

local alPosition	:= getAllPos( aPositions )

oExcel:SetCelUnderLine( .f. )
//setZebra( @oExcel )
oExcel:SetCelSizeFont( 11 )
oExcel:SetCelBgColor("#FFFFFF")
oExcel:SetCelBold(.T.)

oExcel:AddRow(clAba,clTab,aDados,aPositions)	

Return

/*/{Protheus.doc} printEmpty
Funcao para adicionar linha vazia
@author BRB Digital
@since 25/05/2022
@version 1.0
@param oExcel, object, objeto do excel
@param clAba, characters, codigo da aba
@param clTab, characters, codigo da tabela
@param alColumns, array of logical, array com definicao das colunas
@type function
/*/

Static Function printEmpty( oExcel, clAba, clTab, alColumns )

	local alPosition	:= getAllPos( alColumns )

	oExcel:SetCelUnderLine( .F. )
	oExcel:SetCelBgColor("#FFFFFF")
	oExcel:AddRow( clAba, clTab, array( len( alColumns ) ), alPosition )

Return


/*/{Protheus.doc} getAllPos
Funcao para retornar todas as posicoes das colunas da planilha
@author Sergio Celestino
@since 25/05/2022
@version 1.0
@param alColumns, array of logical, array das colunas da planilha
@type function
/*/

Static Function getAllPos( alColumns )

	local alPos := {}
	local nlx
	
	for nlx := 1 to len( alColumns )
		AADD( alPos, nlx )
	next nlx

Return alPos


/*/{Protheus.doc} setZebra
Funcao de controle das cores zebradas
@author Sergio Celestino
@since 25/05/2022
@version 1.0
@param oExcel, object, objeto do excel
@type function
/*/

Static Function setZebra( oExcel )

	oExcel:SetCelSizeFont( 8 )
	if ( mod( npZebrado, 2 ) == 0 )
		oExcel:SetCelBgColor("#DCDCDC")
	else
		oExcel:SetCelBgColor("#DCDCDC")
	endif
	npZebrado++

Return

/*/{Protheus.doc} printTotLi
Funcao de controle das cores zebradas
@author Sergio Celestino
@since 25/05/2022
@version 1.0
@param oExcel, object, objeto do excel
@type function
/*/

Static Function printTotLi( oExcel, clAba, clTab, alColumns , aPosLay )
Local alPosition	:= getAllPos( alColumns )

oExcel:SetCelUnderLine( .F. )
setZebra( @oExcel )
oExcel:SetCelSizeFont( 11 )
oExcel:SetCelBgColor("#fff2cc")
oExcel:SetCelBold(.T.)


oExcel:AddRow(clAba,clTab,alColumns,aPosLay)	


Return


/*
		Gerar PDF
*/
Static Function fGeraPdf(cPath,cFile)
Local lAdjustToLegacy	:= .T. 

Private cDirTmp    := Alltrim(GetTempPath())
Private cStartPath := GetSrvProfString("Startpath","")

Private nPagina:= 0     
Private oFont1 := TFont():New( "Arial 12cpi"   ,, 12,, .t.,,,,    , .f. )
Private oFont11:= TFont():New( "Arial 12cpi"   ,, 16,, .t.,,,,    , .f. )
Private oFont2 := TFont():New( "TAHOMA"        ,, 10,, .f.,,,,    , .f. )
Private oFont2n:= TFont():New( "TAHOMA"        ,, 10,, .t.,,,,    , .f. )
Private oFont3 := TFont():New( "Arial  8cpi"   ,, 08,, .t.,,,,    , .f. )
Private oFont4 := TFont():New( "Arial 12cpi"   ,, 12,, .t.,,,,    , .f. )
Private oFont41:= TFont():New( "Arial"         ,, 12,, .t.,,,,    , .f. )
Private oFont5 := TFont():New( "Arial 10cpi"   ,, 10,, .f.,,,,    , .f. )
Private oFont6 := TFont():New( "TAHOMA"        ,, 10,, .f.,,,,    , .f. )
Private oFont7 := TFont():New( "Arial  8cpi"   ,, 06,, .t.,,,,    , .f. )

If Substr(cPath,Len(cPath),1)<>"\"
	cPath := cPath+"\"
Endif

oPrn := FwMSPrinter():New( cFile  , 6 , lAdjustToLegacy, cPath , .T., , , , , .F., ,.F. )
oPrn:cPathPDF := cPath
oPrn:SetPortrait()		// Modo retrato 
oPrn:SetPaperSize(9)	// Papel A4
oPrn:lInJob:= .T.

RptStatus( { |lEnd| ImpReport(@lEnd)}, "Aguarde...","Impressão em PDF", .T. )

Return .T.


Static Function ImpReport( lEnd ) 

Local nLin    := 500
Local nPagina := 1
Local lFirst  := .T.
Local nRecs   := 0
Local nCont   := 1
Local nL			:= 1

XQRY->(dbGotop())

Count To nRecs

SetRegua( nRecs )

XQRY->(dbGotop())
If XQRY->(Eof())
	FwAlertInfo("Não Existem dados para serem impressos.")
	Return
Else
	XQRY->(dbGotop())
	WHILE XQRY->(!Eof()) 
		IncRegua("Imprimindo aguarde...")
		ImpCab(@nPagina)
	END
Endif

Return .T.

Static Function ImpCab(nPagina)

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
	Local nTotal    := 0
	Local oFont14n	:= TFont():New("Cambria"	,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont14		:= TFont():New("Cambria"	,9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont16n	:= TFont():New("Cambria"	,9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	Local cStartPath:= GetSrvProfString("StartPath","")
	Local cBmp			:= "robsol.bmp"

	cStartPath	:= AllTrim(cStartPath)
	If SubStr(cStartPath,Len(cStartPath),1) <> "\"
		cStartPath	+= "\"
	EndIf
	cBmp	:= cStartPath+cBmp

	oPrn:StartPage()
	oPrn:SayBitMap( 0010 , 1950 , cBmp , 350 , 230 )

	oPrn:Box(0240,0050 , 2950 , 2350 , "-4")
	oPrn:Say(0110,050,"PEDIDO DE VENDA",oFont16n)
	oPrn:Say(0160,050,"Nº "+MV_PAR02,oFont16n)

	oPrn:SayAlign( 0250, 060, Alltrim(SM0->M0_NOMECOM) +' - ' +Alltrim(SM0->M0_FILIAL), oFont14n, 2350, 050 , 0, 2, 0)
	oPrn:Line(0290,050,0290, 2350 , /*nColor*/ , "-4" )

	oPrn:Line(0290,0150,0910, 0150 , /*nColor*/ , "-4" )
	oPrn:Line(0910,0050,0910, 2350 , /*nColor*/ , "-4" )
	oPrn:Say(0650,095,"DADOS CLIENTE",oFont14n,0,,270)

	oPrn:Say(0315,170,"Código/Loja:",oFont14n)
	oPrn:Say(0315,470,XQRY->A1_COD+"/"+XQRY->A1_LOJA,oFont14n)

	oPrn:Say(0355,170,"Razão Social:",oFont14n)
	oPrn:Say(0355,470,XQRY->A1_NOME,oFont14n)

	oPrn:Say(0405,170,"CNPJ:",oFont14n)
	oPrn:Say(0405,470,Transform(XQRY->A1_CGC,"@R 99.999.999/9999-99") ,oFont14n)

	oPrn:Say(0455,170,"Insc. Estadual:")
	oPrn:Say(0455,470,XQRY->A1_INSCR,oFont14n)

	oPrn:Say(0505,170,"Endereço:",oFont14n)
	oPrn:Say(0505,470,Alltrim(XQRY->A1_END)+" "+Alltrim(XQRY->A1_BAIRRO)+" "+XQRY->A1_CEP+" "+XQRY->A1_ESTE,oFont14n)

	oPrn:Say(0555,170,"Contato:" ,oFont14n)
	oPrn:Say(0555,470,Alltrim(XQRY->A1_CONTATO) ,oFont14n)

	oPrn:Say(0605,170,"E-mail:"  ,oFont14n)
	oPrn:Say(0605,470,Alltrim(XQRY->A1_EMAIL)  ,oFont14n)

	oPrn:Say(0655,170,"Telefone:",oFont14n)
	oPrn:Say(0655,470,"("+Alltrim(XQRY->A1_DDD)+") "+Transform(XQRY->A1_TEL,"@R 9999-9999"),oFont14n)

	oPrn:Say(0710,170,"Endereço Entrega:",oFont14n)
	oPrn:Say(0710,470,Alltrim(XQRY->A1_ENDENT)+" "+Alltrim(XQRY->A1_BAIRROE)+" "+XQRY->A1_CEPE+" "+XQRY->A1_EST,oFont14n)
	
	oPrn:Say(0760,170,"Vendedor:",oFont14n)
	oPrn:Say(0760,470,XQRY->A3_NOME,oFont14n)

	oPrn:Say(0810,170,"Pagamento:",oFont14n)
	oPrn:Say(0810,470,Alltrim(XQRY->C5_CONDPAG) + ' - '+ Alltrim(XQRY->E4_DESCRI),oFont14n)
	
	oPrn:Say(0860,170,"Emissao:",oFont14n)
	oPrn:Say(0860,470,DtoC(ddatabase),oFont14n)
	
	oPrn:Line(0960,0150,0960, 0150 , /*nColor*/ , "-4" )
	oPrn:Line(0960,0950,0960, 0950 , /*nColor*/ , "-4" )
	oPrn:Line(0960,1300,0960, 1300 , /*nColor*/ , "-4" )
	oPrn:Line(0960,1500,0960, 1500 , /*nColor*/ , "-4" )
	oPrn:Line(0960,1950,0960, 1950 , /*nColor*/ , "-4" )

	oPrn:Say(0940,0060,"Item"   					 ,oFont14n)
	oPrn:Say(0940,0160,"Produto/Descrição" ,oFont14n)
	oPrn:Say(0940,0960,"Quantidade"				 ,oFont14n)
	oPrn:Say(0940,1310,""          				 ,oFont14n)
	oPrn:Say(0940,1510,""          				 ,oFont14n)
	oPrn:Say(0940,1960,""          				 ,oFont14n)
	
	oPrn:Say(0990,1510,"liberado: "+cUserName 			,oFont14n) 	//01
	oPrn:Say(1040,1510,"data: "+DTOC(Date())			,oFont14n) 	//02
	oPrn:Say(1090,1510,"hora: "+Time()					,oFont14n) 	//03
	oPrn:Say(1140,1510,"tirado: "   					,oFont14n) 	//04
	oPrn:Say(1190,1510,"data: "     					,oFont14n) 	//05
	oPrn:Say(1290,1510,"confirmado: "					,oFont14n) 	//07
	oPrn:Say(1340,1510,"data: "							,oFont14n) 	//08
	oPrn:Say(1440,1510,"embalado: "						,oFont14n) 	//10
	oPrn:Say(1490,1510,"data: "							,oFont14n) 	//11
	oPrn:Say(1540,1510,"hora: "							,oFont14n) 	//12
	oPrn:Say(1590,1510,""								,oFont14n) 	//13
	oPrn:Say(1640,1510,"tirado da mesa: "				,oFont14n) 	//14
	oPrn:Say(1690,1510,"data: "							,oFont14n) 	//15
	oPrn:Say(1740,1510,"hora: "							,oFont14n) 	//16
	oPrn:Say(1840,1510,"fechado caixa: "				,oFont14n) 	//17
	oPrn:Say(1890,1510,"data: "							,oFont14n) 	//18
	//oPrn:Say(1940,1510,"hora: "							,oFont14n) 	//19 1940
	oPrn:Say(1940,1510,"Altura: "						,oFont14n) 	//21 1990
	oPrn:Say(1990,1510,"Largura: "						,oFont14n) 	//23 2040
	oPrn:Say(2040,1510,"Comprimento: "					,oFont14n) 	//25 2090
	oPrn:Say(2090,1510,"Peso: "							,oFont14n) 	//27 2140

	//oPrn:Say(2190,1510,""								,oFont14n) 	//13 2190
	oPrn:Say(2190,1510,"Garantia"						,oFont14n) 	//13 2240
	oPrn:Say(2240,1510,"Sacola"							,oFont14n) 	//13 2290
 	oPrn:Say(2390,1510,"Flanela"						,oFont14n) 	//13 2340
	oPrn:Say(2590,1510,"Estojo"							,oFont14n) 	//13 2390
	oPrn:Say(2440,1510,""								,oFont14n) 	//13
	
	nLinha  := 0990
	While XQRY->(!Eof()) 

		If nLinha>=2700
		
			oPrn:EndPage()
			oPrn:StartPage()
			oPrn:SayBitMap( 0010 , 1950 , cBmp , 350 , 230 )

			oPrn:Box( 260, 050 , 2950 , 2350 , "-4")
			oPrn:Say(0110,050,"PEDIDO DE VENDA",oFont16n)
			oPrn:Say(0160,050,"Nº "+MV_PAR01,oFont16n)

			oPrn:SayAlign( 0260, 060, Alltrim(SM0->M0_NOMECOM), oFont14n, 2350, 050 , 0, 2, 0)
			oPrn:Line(0310,050,0310, 2350 , /*nColor*/ , "-4" )

			oPrn:Line(310,0150,360, 0150 , /*nColor*/ , "-4" )
			oPrn:Line(310,0950,360, 0950 , /*nColor*/ , "-4" )
			oPrn:Line(310,1300,360, 1300 , /*nColor*/ , "-4" )
			oPrn:Line(310,1500,360, 1500 , /*nColor*/ , "-4" )
			oPrn:Line(310,1950,360, 1950 , /*nColor*/ , "-4" )

			oPrn:Say(340,060,"Item"								,oFont14n)
			oPrn:Say(340,160,"Produto/Descrição"	,oFont14n)
			oPrn:Say(340,960,"Quantidade"					,oFont14n)
			oPrn:Say(340,1310,""									,oFont14n)
			oPrn:Say(340,1510,""									,oFont14n)
			oPrn:Say(340,1960,""									,oFont14n)

			oPrn:Line(360,050,360, 2350 , /*nColor*/ , "-4" )

			nLinha  := 390
	
		Endif
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+XQRY->C6_PRODUTO)

		oPrn:Say(nLinha,0060 , XQRY->C6_ITEM,oFont14)
		oPrn:Say(nLinha,0160 , Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC),oFont14)
		oPrn:Say(nLinha,0960 , Transform(XQRY->C6_QTDVEN,"@E 9,999,999.99"),oFont14)
		oPrn:Say(nLinha,1310 , "" ,oFont14)
		oPrn:Say(nLinha,1510,  "" ,oFont14)
		oPrn:Say(nLinha,1960,  "" ,oFont14)

		oPrn:Line(nLinha+10,050,nLinha+10, 2350 , /*nColor*/ , "-4" )

		nLinha += 50
		nTotal += XQRY->C6_QTDVEN
		XQRY->(dbSkip())
	End

	If nLinha>=2700
			oPrn:EndPage()
			oPrn:StartPage()
			oPrn:SayBitMap( 0010 , 1950 , cBmp , 350 , 230 )

			oPrn:Box( 260, 050 , 2950 , 2350 , "-4")
			oPrn:Say(0110,050,"PEDIDO DE VENDA",oFont16n)
			oPrn:Say(0160,050,"Nº "+MV_PAR01,oFont16n)

			oPrn:SayAlign( 0260, 060, Alltrim(SM0->M0_NOMECOM), oFont14n, 2350, 050 , 0, 2, 0)
			oPrn:Line(0310,050,0310, 2350 , /*nColor*/ , "-4" )
			nLinha:=360
	Endif
	
	oPrn:Say(nLinha,060,"TOTAL ",oFont16n)
	oPrn:Say(nLinha,960,Transform(nTotal,"@E 9,999,999.99"),oFont16n)
	
	If nLinha < 2700
		While nLinha < 2900
			oPrn:Line(nLinha+10,050,nLinha+10, 2350 , /*nColor*/ , "-4" )

			nLinha += 50
		ENDDO
	EndIf 

	oPrn:EndPage()

	oPrn:SetViewPDF(.T.)
	oPrn:Print()

Return Nil


/*/{Protheus.doc} ValidPerg
@author BRB Digital
@since 25/05/2022
/*/

Static Function ValidPerg(cPerg)

	Local aArea  := SX1->(GetArea())
	Local aRegs := {}
	Local i,j

	aadd( aRegs, { cPerg,"01","Filial?"         ,"","","mv_ch1","C", TamSx3("C6_FILIAL")[1],0,0,"G","","mv_par01",""   ,"",""," ","",""," ","","","","","","","","","","","","","","","","","","SM0" 	})
	aadd( aRegs, { cPerg,"02","Pedido de Venda?","","","mv_ch2","C", TamSx3("C6_NUM")[1]   ,0,0,"G","","mv_par02",""   ,"",""," ","",""," ","","","","","","","","","","","","","","","","","","SC5"	})
	aadd( aRegs, { cPerg,"03","Gerar ?"     ,"","","mv_ch3","N", 1                     ,0,0,"C","","mv_par03","PDF","","","","","EXCEL"," ","","","","","","","","","","","","","","","","","","","","","","" } )

	
	DbselectArea('SX1')
	SX1->(DBSETORDER(1))
	For i:= 1 To Len(aRegs)
		If ! SX1->(DBSEEK( AvKey(cPerg,"X1_GRUPO") +aRegs[i,2]) )
			Reclock('SX1', .T.)
			FOR j:= 1 to SX1->( FCOUNT() )
				IF j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				ENDIF
			Next j
			SX1->(MsUnlock())
		Endif
	Next i 
	RestArea(aArea) 

Return(cPerg)
