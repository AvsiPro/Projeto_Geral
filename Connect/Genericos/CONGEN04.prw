#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "fileio.ch"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ AVSIXML  ณ Autor ณ Alexandre Venancio    ณ Data ณ 31/03/17 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Importador XML para geracao de NF de entrada.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AVSIXML
    
Local nX,nXz
Private oDlg1,oGrp1,oTree1,oGrp2,oBrw1,oGrp5,oSay2,oSay3,oSay4,oSay5,oSay1,oSay6,oSay14
Private oSay8,oSay9,oSay10,oSay11,oSay12,oGrp3,oBrw2,oBrw3,oBtn1,oFld1,oBrw5,oBrw6,oFld9
Private oBrw7,oList1,oList2,oList3,oList4,oList5,oList6,oList7,oSay13,oTButton1,oMenu
Private cPathL		:= SUPERGETMV("MV_XPATH",.F.,"C:\xml_imp\")  	//Diretorio padrao onde devem estar os arquivos xmls para serem importados
Private cPathLC		:= SUPERGETMV("MV_XPATH2",.F.,"C:\xml_imp\")  	//Diretorio padrao onde devem estar os arquivos xmls para serem importados CT-es
//Private lCoffe		:= If(substr(cPathL,1,3)<>"C:\",.T.,.F.)
Private cPath		:=	"\spool\"
Private aArquivo	:= directory(cPathL+"*.xml","D")		//Varredura no Diretorio padrao onde devem se encontrar os xmls para importacao
Private aArqCTE		:= directory(cPathLC+"*.*","D")		//Varredura no Diretorio padrao onde devem se encontrar os xmls para importacao
//Private lBlqCHV		:= SuperGetMV("MV_XBLQCHV",.T.,.F.)
//Private cTpChkProd	:= SuperGetMV("MV_XXMLPRD",.T.,"1")	// 1 - SA5 | 2 - EAN | 3 - Ambos
//Private cCfoDev		:= SuperGetMV("MV_XCFODEV",.T.,"201/202/410/411/556/906/918/949")   
Private aCnpjL		:= strtokarr(SuperGetMV("MV_XCNPJL",.T.,"0001-22"),"/")
Private aArq		:= {}
Private cNum		:= ""	// Numero da Nota
Private cFornec		:= ""   // Fornecedor
Private cLjFornec	:= ""	// Loja
Private cNomeFor	:= ""
Private cEstFor 	:= ""
Private cDtEmissao	:= ""
Private	cForCond	:= ""
Private cEndFor		:= ""		
Private cForEst		:= ""    
Private cEspecie	:= ""
Private cCNPJ_FIL			// Cnpj da Loja
Private cCNPJ_FOR			// Cnpj da Loja 
Private cIE_FOR				// IE fornecedor
Private cCcd				// Centro de Custo
Private cFilorig			// Filial de Origem
Private nDescVar
Private nDescNota	:=	0
Private nDescItens
Private nIcms
Private nIcmsRet
Private nIcmsRepa
Private nIcmsSubs
Private nSeguro
Private nFrete
Private nAdicional
Private nIcmsPer
Private nIcmsBase
Private cSerie		:= ""	// S้rie  
Private cNatOp		:= ""	//Natureza da operacao
Private cTipo		:= "N"	// Tipo
Private nCont
Private cCodigo
Private cDescProd
Private cUM
Private bLote
Private cLote
Private cValidade
Private cCodBarra
Private nQuant
Private nPrcUnLiq
Private nDescItem			// %
Private nValDesc			// $
Private nItem			:= 0
Private bMed
Private nContLote			// Contador do For
Private nTotalMed			// Len do Array Med
Private nQtdeLote			// Qtde do Lote Atual
Private nDescLote			// Desconto do Lote Atual
Private nValLote			// Valor do Lote Atual
Private nDescTT				// Acumulado do Desconto
Private nValorTT			// Acumulado
Private cUnidad				// Unidade do fornecedor
Private nFator				// Fator de Conversao
Private nNumItens
Private nNumUnid
Private nTotalMerc
Private cNumTitulo
Private nValor
Private cVencimento
Private aVencimento		:=	{}
Private nDescDia
Private nDescFin
Private nJurosDia
Private nMulta
Private nAcrescimo
Private cChave_NFe	:= ""	// Chave de Acesso da NFe
Private aCabec		:= {}	// Array de cabecalho da NF - para ExecAuto
Private aItens		:= {}	// Array de itens da NF - para ExecAuto
Private aLinha		:= {}	// Array de linhas da NF - para ExecAuto	
Private lMsErroAuto	:= .F.
Private lMsHelpAuto	:= .T.
Private cFound		:= 0	// Resultado de Busca
Private aItensXML			// Itens do arquivo XML 
Private aRotina		:= {{"Visualizar"	,"A103NFiscal('SF1',Recno(),2)"	,0,1}}
Private aProdInt	:= {}	// produtos internos
Private aPedido		:= {}	// Dados dos Pedidos de Compra do Fornecedor 
Private aRelaProd	:= {}	// Relacao Itens NF x Itens Empresa
Private cNumPed		:= ""	// Numero do Pedido de Compra
Private lExistXPed	:= .F.	// controle - se existe a TAG xPed no XML
Private nExistTag	:= 0	// qtd de Tags xPed que existem no arquivo XML
Private lVzRelaPrd	:= .T.	// controle - se existe a relacao de itens nf x itens empresa
Private cItemPC		:= ""	// Item do Pedido de Compra - para ser usado nos istens do Array para o ExecAuto
Private cPedEmissao			// Data de Emissao do Pedido de Compra
Private cPedAtual	:= ""	// N๚mero do Pedido Atual - para ser usado nos itens do Array para o ExecAuto
Private lPedTotal	:= .F.	// variแvel de controle - Importa็ใo utilizando somente um Pedido
Private lPedParc	:= .F.	// variแvel de controle - Importa็ใo utilizando mais de um Pedido
Private lPedSem		:= .F.	// variแvel de controle - Importa็ใo sem Pedido
Private cPedTotVlr	:= ""	// Valor Total do Pedido de Compra - Somente para Importa็ใo com somente 1 Pedido
Private aList1		:= {}	//Itens do xml da nota.
Private aList2		:= {}  //Pedidos do fornecedor
Private aList3		:= {}  //ITens do pedido de compra
Private aList4		:= {}
Private aList5		:= {}
Private aList6		:= {}
Private aList7		:= {} 
Private aList3B		:= {}
Private aItensCad 	:= Array(0)
Private nBaseIcm	
Private nVlrIcm
Private lNfImp		:=	.F.
Private oOk   		:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   		:= LoadBitmap(GetResources(),'br_vermelho')  
Private aCnpj		:= {}
Private aAno		:= {}
Private aMes		:= {}  
Private lCoffe		:= if(substr(cPathL,1,3)=="C:\",.F.,.T.)
Private lDevCmp		:= .F. 
Private lRetBen		:= .F.  
Private nDiasDp		:=	''
Private aItemNF		:=	{}     
Private aBcoXml		:=	{}
Private oTable  	:= CriaTemp() 

If Len(aArquivo) == 0
 	MSGALERT("Nใo existem arquivos para serem importados.") 	
   	Return
EndIf

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0104" MODULO "EST" TABLES "SA2"

Aadd(aList1,{"0","0","","0","0","0","0","0","","0","0","0",'','','','',.F.,'','','','','','','',''})
Aadd(aList2,{.F.,"0","0","",""})
Aadd(aList3,{.F.,"0","0","0","0","0","0"}) 
Aadd(aList4,{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"})
Aadd(aList5,{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"})
Aadd(aList6,{"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"})
 
If !ExistDir( cPathL )
	MakeDir( cPathL )
EndIF

If !ExistDir( cPathL+"\Processados" )
	MakeDir( cPathL+"\Processados" )
EndIf
	
For nX := 1 to len(aArquivo)
	If Alltrim(aArquivo[nX,01]) <> "." .And. Alltrim(aArquivo[nX,01]) <> ".." .And. aArquivo[nX,05] <> "D"
		CpyT2S(cPathL+Alltrim(aArquivo[nX,01]),cPath)
		Processa({|| gravaxml(aArquivo[nX,01])},"Lendo xml "+cPathL+Alltrim(aArquivo[nX,01]))
	EndIF
Next nX
  
For nX := 1 to len(aCnpjL)
	aCnpjL[nX] := substr(aCnpjL[nX],1,4)+"-"+substr(aCnpjL[nX],5,2)
	&("aListC"+cvaltochar(nX)) := {'','','',''}
Next nX

For nX := 1 to len(aCnpjL)
	&("aListC"+cvaltochar(nX)) := buscabco(aCnpjL[nX])
Next nX

For nXz := 1 to len(aCnpjL)
	bcoxml(&("aListC"+cvaltochar(nXz)))
Next nX
  
oDlg1      := MSDialog():New( 023,028,619,1322,"Importador XML",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 000,004,168,256,"Arquivos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oFld9      := TFolder():New( 008,008,aCnpjL,aCnpjL,oGrp1,,,,.T.,.F.,245,155,)
		
		For nX := 1 to len(aCnpjL)
			
			&("oListC"+cvaltochar(nX)):= 	TCBrowse():New(004,004,245,130,, {'Documento','Serie','CNPJ','Data Emissใo'},{40,30,50,40},;
		                            			oFld9:aDialogs[nX],,,,{|| Fhelp(ofld9:noption)},{|| /*editcol1(oList1:nAt,1,.F.)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
			&("oListC"+cvaltochar(nX)):SetArray(&("aListC"+cvaltochar(nX)))
			&("oListC"+cvaltochar(nX)):bLine := {||{&("aListC"+cvaltochar(nX))[&("oListC"+cvaltochar(nX)):nAt,01],; 
			 					 					&("aListC"+cvaltochar(nX))[&("oListC"+cvaltochar(nX)):nAt,02],;
			 					 					&("aListC"+cvaltochar(nX))[&("oListC"+cvaltochar(nX)):nAt,09],;
			 					 					&("aListC"+cvaltochar(nX))[&("oListC"+cvaltochar(nX)):nAt,04]}}  
			&("oListC"+cvaltochar(nX)):refresh()
		Next nX
		nX := len(aCnpjL)
		oFld9:bSetOption := {|| functr(oFld9:nOption)} 
		
	oGrp2      := TGroup():New( 000,260,160,636,"Pr้-Nota",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        //cNumItem,cCodItem,PadR('',TamSX3("B1_COD")[1]), cDescItem,nQtdC,nVlrUn,nVlrTo,cCfop,cNCM,cUNd,cOutro,cCest,cNum,cSerie
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{076,264,156,632},,, oGrp2 ) 
	    oList1:= 	TCBrowse():New(076,264,369,080,, {'Item','Cod_Forn','Cod_Proprio','Descri็ใo','Qtd','Vlr Unit.','Vlr Total',;
	    												'CFOP','NCM','UM','Despesas','CEST'},{10,20,20,40,20,20,20,20,20,20,20,20},;
	                            oGrp2,,,,{|| },{|| editcol(oList1:nAt,1)},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList1:SetArray(aList1)
		oList1:bLine := {||{aList1[oList1:nAt,01],; 
		 					 aList1[oList1:nAt,02],;
		 					 aList1[oList1:nAt,03],;
		 					 aList1[oList1:nAt,04],; 
		 					 aList1[oList1:nAt,05],;
		 					 aList1[oList1:nAt,06],;
		 					 aList1[oList1:nAt,07],; 
		 					 aList1[oList1:nAt,08],;
		 					 aList1[oList1:nAt,09],;
		 					 aList1[oList1:nAt,10],; 
		 					 aList1[oList1:nAt,11],;
		 					 aList1[oList1:nAt,12]}}


	    
	oGrp2      := TGroup():New( 008,264,072,632,"Cabe็alho",oGrp2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oSay2      := TSay():New( 016,268,{||"Fornecedor"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay3      := TSay():New( 016,316,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,312,008)
		oSay4      := TSay():New( 028,268,{||"Endere็o"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay5      := TSay():New( 028,316,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,312,008)
		oSay1      := TSay():New( 040,268,{||"CNPJ"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 040,316,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,092,008)
		oSay7      := TSay():New( 040,416,{||"IE"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,008,008)
		oSay8      := TSay():New( 040,468,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,108,008)
		oSay9      := TSay():New( 052,268,{||"Natureza da Opera็ใo"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
		oSay10     := TSay():New( 052,336,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,216,008)
		oSay11     := TSay():New( 062,286,{||"Nota"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,064,008)
		oSay12     := TSay():New( 062,350,{||"S้rie"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,032,008)
		oSay13     := TSay():New( 062,400,{||"Data de Emissใo"},oGrp5,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,092,008)
        oSay14     := TSay():New( 062,530,{||""},oGrp5,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,092,008)

	oGrp3      := TGroup():New( 160,260,256,636,"Pedidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{184,264,260,412},,, oGrp3 ) 
		//oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{184,416,260,632},,, oGrp3 ) 
                                                                                                        
	    oList2:= 	TCBrowse():New(172,264,140,080,, {'','Pedido','Emissใo','Entrega'},{10,30,20,20},;
	                            oGrp3,,,,{|| FhelpPC(oList2:nAt) },{|| editcol(oList2:nAt,2)},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
		 					 aList2[oList2:nAt,02],;
		 					 aList2[oList2:nAt,03],;
		 					 aList2[oList2:nAt,04]}}

	    oList3:= 	TCBrowse():New(172,406,226,080,, {'','Item','Codigo','Descri็ใo','Qtd','Vlr Unit.','Vlr Total'},{10,10,20,50,20,30,30},;
	                            oGrp3,,,,{|| },{|| editcol(oList3:nAt,3)},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
		 					 aList3[oList3:nAt,02],;
		 					 aList3[oList3:nAt,03],;
		 					 aList3[oList3:nAt,04],; 
		 					 aList3[oList3:nAt,05],;
		 					 aList3[oList3:nAt,06],;
		 					 aList3[oList3:nAt,07]}}

	oFld1      := TFolder():New( 172,004,{"Totais da Nota","TES","Exce็๕es Fiscais","oaDialogs4","oaDialogs5"},{},oDlg1,,,,.T.,.F.,252,100,)

		//oBrw5      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{004,004,100,244},,, oFld1:aDialogs[2] ) 
		oList4:= 	TCBrowse():New(004,004,245,080,, {'Base ICMS','Vlr ICMS','Base ST','Vlr ST','Total Prod.',;
														'Frete','Seguro','Desconto','Desp. Ac.','IPI','Total NF'},{30,30,30,30,30,30,30,30,30,30,30},;
	                            oFld1:aDialogs[1],,,,{|| },{|| /*editcol1(oList1:nAt,1,.F.)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList4:SetArray(aList4)
		oList4:bLine := {||{aList4[oList4:nAt,01],; 
		 					 aList4[oList4:nAt,02],;
		 					 aList4[oList4:nAt,03],;
		 					 aList4[oList4:nAt,04],;
		 					 aList4[oList4:nAt,05],; 
		 					 aList4[oList4:nAt,06],;
		 					 aList4[oList4:nAt,07],;
		 					 aList4[oList4:nAt,08],;
		 					 aList4[oList4:nAt,09],; 
		 					 aList4[oList4:nAt,10],;
		 					 aList4[oList4:nAt,11]}}

		//oBrw6      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{004,004,088,244},,, oFld1:aDialogs[3] )

		oList5:= 	TCBrowse():New(004,004,245,080,, {'','Codigo','Finalidade','Resumo','Calc ICMS','Calc IPI',;
														'Duplicata','Estoque','CFOP','Base ICM','Sit Trib ICM','Sit Trib PIS','Sit Trib COF'},{10,30,30,30,30,30,30,30,30,30,30,20,20},;
	                            oFld1:aDialogs[2],,,,{|| },{|| /*editcol1(oList1:nAt,1,.F.)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList5:SetArray(aList5)
		oList5:bLine := {||{aList5[oList5:nAt,01],; 
		 					 aList5[oList5:nAt,02],;
		 					 aList5[oList5:nAt,03],;
		 					 aList5[oList5:nAt,04],;
		 					 aList5[oList5:nAt,05],; 
		 					 aList5[oList5:nAt,06],;
		 					 aList5[oList5:nAt,07],;
		 					 aList5[oList5:nAt,08],;
		 					 aList5[oList5:nAt,09],; 
		 					 aList5[oList5:nAt,10],;
		 					 aList5[oList5:nAt,11],;
		 					 aList5[oList5:nAt,12],;
		 					 aList5[oList5:nAt,13]}}

		oList6:= 	TCBrowse():New(004,004,245,080,, {'','Grupo','Aliq. Int','Aliq. Ext','IVA','Aliq. Pis',;
														'Aliq. Cof','Base ICMS','Sit Trib','Base ICM ST'},;
														{10,30,30,30,30,30,30,30,30,30,30,20,20},;
	                            oFld1:aDialogs[3],,,,{|| },{|| /*editcol1(oList1:nAt,1,.F.)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList6:SetArray(aList6)
		oList6:bLine := {||{aList6[oList6:nAt,01],; 
		 					 aList6[oList6:nAt,02],;
		 					 aList6[oList6:nAt,03],;
		 					 aList6[oList6:nAt,04],;
		 					 aList6[oList6:nAt,05],; 
		 					 aList6[oList6:nAt,06],;
		 					 aList6[oList6:nAt,07],;
		 					 aList6[oList6:nAt,08],;
		 					 aList6[oList6:nAt,09],; 
		 					 aList6[oList6:nAt,10]}}

	
	//Bot๕es diversos
	oMenu := TMenu():New(0,0,0,0,.T.)
	// Adiciona itens no Menu
	oTMenuIte1 := TMenuItem():New(oDlg1,"Gerar Pr้-Nota",,,,{|| Processa({||prenota(),"Aguarde..."})},,,,,,,,,.T.) 
	oTMenuIte2 := TMenuItem():New(oDlg1,"Pesquisar por cnpj",,,,{|| Processa({||procurar(),"Aguarde..."})},,,,,,,,,.T.) 
	oTMenuIte9 := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()} ,,,,,,,,,.T.)
	
	oMenu:Add(oTMenuIte1)
	oMenu:Add(oTMenuIte2)
	oMenu:Add(oTMenuIte9)
	oTButton1 := TButton():New( 262, 591, "Op็๕es",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	// Define botใo no Menu
	oTButton1:SetPopupMenu(oMenu)
    
	// Menu popup grid 1
	MENU oMenu POPUP 
	//MENUITEM "Alterar Qtd Conf. Cadastro" ACTION (altqtd())
	MENUITEM "Utilizar este codigo para os demais itens" ACTION (outritm(oList1:nAt))
	ENDMENU                                                                           

	oList1:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
    
    oList1:setfocus()
    
oDlg1:Activate(,,,.T.)

Return
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  03/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Carregar arquivos                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carregar

Local aArea	:=	GetArea()
Local lCte	:=	.F.
Local nX,nP

cCNPJ_FOR 	:=	''
cNomeFor 	:=	''
cEndFor  	:=	''
cIE_FOR  	:=	''
cNum 		:=	''
cSerie 		:=	''
    
aList1 		:= {}
aList2 		:= {}   
aList3 		:= {}   
aList4 		:= {}   
aList5 		:= {}
aList6 		:= {}    
aList3B		:= {}
  
oSay6:settext("") //CNPJ
oSay3:settext("") //NOME
oSay5:settext("") //ENDERECO
oSay8:settext("") //IE    
oSay10:settext("") //Natureza da operacao
oSay11:settext("") //NOTA
oSay12:settext("") //SERIE
oSay13:settext("") //SERIE
oSay14:settext("") //NF jแ importada
                
If ".XML" $ UPPER(aArq[val(oTree1:currentnodeid),01]) .AND. !'\CT-es\' $ aArq[val(oTree1:currentnodeid),02] //val(oTree1:currentnodeid) != 1
	
	//If !File(cPath+aArq[val(oTree1:currentnodeid)-1,01],2)
	If !File(aArq[val(oTree1:currentnodeid),02],2)
		If !lCoffe
			CpyT2S(cPathL+aArq[val(oTree1:currentnodeid),01],cPath)
		//CpyT2S(aArq[val(oTree1:currentnodeid),02],cPath)
		//FRename(aArq[val(oTree1:currentnodeid),02],cPath+aArq[val(oTree1:currentnodeid),01])
		EndIF
	EndIF       
	//Buscando os dados do XML
	//XMLNfe(aArq[val(oTree1:currentnodeid)-1,01])
	XMLNfe(aArq[val(oTree1:currentnodeid),01]) //aArq[val(oTree1:currentnodeid),02])
	
	oSay6:settext(Transform(cCNPJ_FOR,"@R 99.999.999/9999-9#"))
	oSay3:settext(cNomeFor)
	oSay5:settext(cEndFor)
	oSay8:settext(Transform(cIE_FOR,"@R 999.999.999.99#"))    
	oSay10:settext(cNatOp)
	oSay11:settext("Nota "+cvaltochar(cNum))
	oSay12:settext("S้rie " +cvaltochar(cSerie))
	oSay13:settext("Data de Emissใo "+cDtEmissao)
	oSay14:settext(If(lNfImp,"Nota jแ lan็ada!!!",""))
	
	For nX := 1 to len(aItensCad)
		Aadd(aList1,aItensCad[nX])	
		Aadd(aList1[len(aList1)],.F.)
		Aadd(aList1[len(aList1)],"")  //TES
		Aadd(aList1[len(aList1)],"")  //Nota origem
		Aadd(aList1[len(aList1)],"")  //Serie origem
		Aadd(aList1[len(aList1)],"")  //Item origem 
		Aadd(aList1[len(aList1)],"")  //Pedido de Compra 
		Aadd(aList1[len(aList1)],"")  //Item Pedido de Compra
		Aadd(aList1[len(aList1)],"")  //Centro de Custo PCompra

	/*	If SUBSTR(aList1[len(aList1),08],2,3) $ cCfoDev
			lDevCmp := .T.      
			//Retorno de Beneficiamento
			If SUBSTR(aList1[len(aList1),08],2,3) $ "906"
				lRetBen := .T.
			EndIf
		EndIf
		*/
	Next nX         
	Pedidos(cFornec,cLjFornec)
Else
	If !File(aArq[val(oTree1:currentnodeid),02],2)
		If !lCoffe
			CpyT2S(cPathL+aArq[val(oTree1:currentnodeid),01],cPath)
		//CpyT2S(aArq[val(oTree1:currentnodeid),02],cPath)
		//FRename(aArq[val(oTree1:currentnodeid),02],cPath+aArq[val(oTree1:currentnodeid),01])
		EndIF
	EndIF       
	//Buscando os dados do XML
	XMLCTE(aArq[val(oTree1:currentnodeid),01]) //aArq[val(oTree1:currentnodeid),02])
	
	oSay6:settext(Transform(cCNPJ_FOR,"@R 99.999.999/9999-9#"))
	oSay3:settext(cNomeFor)
	oSay5:settext(cEndFor)
	oSay8:settext(Transform(cIE_FOR,"@R 999.999.999.99#"))    
	oSay10:settext(cNatOp)
	oSay11:settext("Nota "+cvaltochar(cNum))
	oSay12:settext("S้rie " +cvaltochar(cSerie))
	oSay13:settext("Data de Emissใo "+cDtEmissao)
	oSay14:settext(If(lNfImp,"Nota jแ lan็ada!!!",""))
	
	For nX := 1 to len(aItensCad)
		Aadd(aList1,aItensCad[nX])	
		Aadd(aList1[len(aList1)],.F.)
		Aadd(aList1[len(aList1)],aItemNF[1,3])  //TES
		Aadd(aList1[len(aList1)],"")  //Nota origem
		Aadd(aList1[len(aList1)],"")  //Serie origem
		Aadd(aList1[len(aList1)],"")  //Item origem
		Aadd(aList1[len(aList1)],"")  //Pedido de Compra 
		Aadd(aList1[len(aList1)],"")  //Item Pedido de Compra
		Aadd(aList1[len(aList1)],"")  //Centro de Custo PCompra

	/*	
		If SUBSTR(aList1[len(aList1),08],2,3) $ cCfoDev
			lDevCmp := .T.      
			//Retorno de Beneficiamento
			If SUBSTR(aList1[len(aList1),08],2,3) $ "906"
				lRetBen := .T.
			EndIf
		EndIf
		*/
	Next nX 
	lCte := .T.        
	//Pedidos(cFornec,cLjFornec)
EndIf                      
	
If len(aList1) < 1
	Aadd(aList1,{"0","0","","0","0","0","0","0","","0","0","0",'','','','',.F.,'','','','','','','',''})
Else 
	If !lCte
		BuscaTes()
		excefis() 
	EndIf	
EndIf


If len(aList2) < 1
	Aadd(aList2,{.F.,'Nใo hแ','0','0','0','0','0','0','0','0','0','0','0','0'})
EndIF


If len(aList3B) < 1
	Aadd(aList3,{.F.,'','','','','','','','','','','','',''}) 
Else
	For nP := 1 to len(aList3B)
		If aList3B[nP,8] == aList2[oList2:nAt,02]
			Aadd(aList3,aList3B[nP])
		EndIf
	Next nP
EndIF

If len(aList4) < 1
	Aadd(aList4,{'','','','','','','','','','','','','','','','','','','',''})
EndIF

If len(aList5) < 1
	Aadd(aList5,{'','','','','','','','','','','','','','','','','','','',''})
EndIF

If len(aList6) < 1
	Aadd(aList6,{'','','','','','','','','','','','','','','','','','','',''})
EndIF

oList1:SetArray(aList1)
oList1:bLine := {||{aList1[oList1:nAt,01],; 
 					 aList1[oList1:nAt,02],;
 					 aList1[oList1:nAt,03],;
 					 aList1[oList1:nAt,04],; 
 					 Transform(aList1[oList1:nAt,05],"@E 999,999.9999"),;
 					 Transform(aList1[oList1:nAt,06],"@E 999,999.9999"),;
 					 Transform(aList1[oList1:nAt,07],"@E 999,999.9999"),; 
 					 aList1[oList1:nAt,08],;
 					 aList1[oList1:nAt,09],;
 					 aList1[oList1:nAt,10],; 
 					 aList1[oList1:nAt,11],;
 					 aList1[oList1:nAt,12]}}
 					 
oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
 					 aList2[oList2:nAt,02],;
 					 aList2[oList2:nAt,03],;
 					 aList2[oList2:nAt,04]}}

oList3:SetArray(aList3)
oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
 					 aList3[oList3:nAt,02],;
 					 aList3[oList3:nAt,03],;
 					 aList3[oList3:nAt,04],; 
 					 aList3[oList3:nAt,05],;
 					 aList3[oList3:nAt,06],;
 					 aList3[oList3:nAt,07]}}

oList4:SetArray(aList4)
oList4:bLine := {||{Transform(aList4[oList4:nAt,01],"@E 999,999.99"),; 
 					 Transform(aList4[oList4:nAt,02],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,03],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,04],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,05],"@E 999,999.99"),; 
 					 Transform(aList4[oList4:nAt,06],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,07],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,08],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,09],"@E 999,999.99"),; 
 					 Transform(aList4[oList4:nAt,10],"@E 999,999.99"),;
 					 Transform(aList4[oList4:nAt,11],"@E 999,999.99")}}

oList5:SetArray(aList5)
oList5:bLine := {||{aList5[oList5:nAt,01],; 
 					 aList5[oList5:nAt,02],;
 					 aList5[oList5:nAt,03],;
 					 aList5[oList5:nAt,04],;
 					 aList5[oList5:nAt,05],; 
 					 aList5[oList5:nAt,06],;
 					 aList5[oList5:nAt,07],;
 					 aList5[oList5:nAt,08],;
 					 aList5[oList5:nAt,09],; 
 					 aList5[oList5:nAt,10],;
 					 aList5[oList5:nAt,11],;
 					 aList5[oList5:nAt,12],;
 					 aList5[oList5:nAt,13]}}

oList6:SetArray(aList6)
oList6:bLine := {||{aList6[oList6:nAt,01],; 
 					 aList6[oList6:nAt,02],;
 					 aList6[oList6:nAt,03],;
 					 aList6[oList6:nAt,04],;
 					 aList6[oList6:nAt,05],; 
 					 aList6[oList6:nAt,06],;
 					 aList6[oList6:nAt,07],;
 					 aList6[oList6:nAt,08],;
 					 aList6[oList6:nAt,09],; 
 					 aList6[oList6:nAt,10]}}



oList1:refresh()
oList2:refresh()
oList3:refresh()
oList4:refresh()
oList5:refresh()
oList6:refresh()

oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  03/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Importando os arquivos xmls                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function XMLNfe(cFile)

Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL
Local lCadOk		:= .F.
Local cTagAnt		:= ""
Local cTagAtu		:= ""
Local lPrimeira		:= .T.
Local nX
Local nCont

aItensCad := {}
cEspecie := "SPED"
//"Iniciando leitura do arquivo.."
// Gera o objeto com dados do XML
If !lCoffe
	oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
Else
	oXml := XmlParserFile( aArq[val(oTree1:currentnodeid),02], "_", @cError, @cWarning )
EndIF 

If ValType(oXml) != "O"
     MsgAlert(cFile+" - "+cError)
     Return()
Endif

cVersaoNFE := oXML:_nfeProc:_versao:TEXT

// -> Verifica se NF estแ autorizada na Sefaz
cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)

If Empty(cChave_NFe)
	MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
	Return
EndIf   

/*
If lBlqCHV
	ConsNFeChave(cChave_NFe,@cRetChv)
	If !"AUTORIZADO" $ cRetChv
		cRetChv += +CRLF +"Chave NFe: " +cChave_NFe
		MsgAlert(cRetChv,"XMLNfe")
		Return  
	EndIf
EndIf
*/  
// Se a Tag NFEPROC:NFE:INFNFE:_DET for Objeto
If ValType(oXml:_NfeProc:_Nfe:_InfNfe:_DET) = "O"
     XmlNode2Arr(oXml:_NfeProc:_Nfe:_InfNfe:_DET, "_DET")
EndIf

// Gera Array com os dados dos produtos do XML
aItensXML	:= oXML:_nfeProc:_NFe:_infNFe:_Det
aItensXML	:= IIf(ValType(aItensXML)=="O", {aItensXML}, aItensXML)

If Len(aItensXML) == 0
	MsgAlert("Erro na estrutura dos Itens do arquivo XML!", "XMLNfe")
	Return
EndIf

// Inicializa as variaveis de controle
nError := 0
cFilorig := "XX"


//OpenSm0()
SM0->(dbGoTop())
While !SM0->(Eof())
     If cEmpAnt != SM0->M0_CODIGO
          SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
          loop
     Endif
     
     If cCNPJ_FIL == SM0->M0_CGC
          cFilorig := SM0->M0_CODFIL
          Exit //Forca a saida
     Endif
     
     SM0->(dbskip())
EndDo

cFilant := cFilorig
//Opensm0(cempant+cFilant)
//Openfile(cempant+cFilant)

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT , "_CNPJ" ) != Nil
	cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
Else
	cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT
EndIf
//Verificando fornecedor: " +cCNPJ_FOR)                  
cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
cSerie	:= STRZero(val(Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)
cNatOp	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_NATOP:Text,45," ")


//cnpj
cCNPJ_FIL := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT

DbSelectArea("ZZ0")
DbSetOrder(1)
IF !DbSeek(xFilial("ZZ0")+cChave_NFe)
	nHandle := FT_FUse(cPath+cFile) 
	cLine := ''
	While !FT_FEOF()                                              
		cLine	+= FT_FReadLn() // Retorna a linha corrente  
		FT_FSKIP()
	End
	 	
	Reclock("ZZ0",.T.)
	ZZ0->ZZ0_CHAVE	:=	cChave_NFe
	ZZ0->ZZ0_CNPJF	:=	cCNPJ_FOR
	ZZ0->ZZ0_CNPJC	:=	cCNPJ_FIL
	ZZ0->ZZ0_DOC	:=	cNum
	ZZ0->ZZ0_SERIE	:=	cSerie
	ZZ0->ZZ0_FLAGIM	:=	"1"
	//ZZ0->ZZ0_XMLNFE	:=	cLine 
	ZZ0->ZZ0_XMLNFA	:=	cLine 
	ZZ0->(Msunlock())
EndIF

DBSelectArea("SA2")
DBSetOrder(3)
If DbSeek(xFilial("SA2")+cCNPJ_FOR) .And. !"DEV" $ cNatOp
	cFornec		:= SA2->A2_COD
	cLjFornec	:= SA2->A2_LOJA
	cEstFor		:= SA2->A2_EST
	cNomeFor	:= SA2->A2_NOME
	cForCond	:= SA2->A2_COND  
	cEndFor		:= Alltrim(SA2->A2_END)+" - "+Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+cEstFor
	cIE_FOR		:= SA2->A2_INSCR
Else 
	If "DEV" $ cNatOp
		DbSelectArea("SA1")
		DbSetOrder(3)
		If Dbseek(xFilial("SA1")+cCNPJ_FOR)
			cFornec		:= SA1->A1_COD
			cLjFornec	:= SA1->A1_LOJA
			cEstFor		:= SA1->A1_EST
			cNomeFor	:= SA1->A1_NOME
			cForCond	:= SA1->A1_COND  
			cEndFor		:= Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+cEstFor
			cIE_FOR		:= SA1->A1_INSCR
		EndIf
	Else
		MSGALERT("Fornecedor inexistente!" + cCNPJ_FOR +CRLF) 
		cFornec		:= 'XXXXXX'
		cLjFornec	:= 'XX'
		cEstFor		:= SA2->A2_EST
		cNomeFor	:= UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_XNOME:TEXT)+" / "+ UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_XFANT:TEXT)
		cForCond	:= '' //SA2->A2_COND  
		cEndFor		:= UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XLGR:TEXT)+", "+oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_NRO:TEXT+" - "+UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)+" - "+UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XMUN:TEXT)+" - "+UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_UF:TEXT)
		cIE_FOR		:= oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_IE:TEXT
			
	EndIf
Endif


// -> Verifica se jแ existe essa NF na base de dados
DBSelectArea("SF1")
DbSetorder(1)
If DbSeek(xFilial("SF1")+AvKey(cNum,"F1_DOC")+AvKey(cSerie,"F1_SERIE")+AvKey(cFornec,"F1_FORNECE")+AvKey(cLjFornec,"F1_LOJA")+AvKey(If(substr(cNatOp,1,3) $ "DEV/RET",If(substr(cNatOp,1,3)<>"RET","D","B"),cTipo),"F1_TIPO")/*,.T.*/)
	//MsgAlert(OemToAnsi("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."))
	MSGALERT("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."  +CRLF)  
	lNfImp := .T.
	IF !ExistDir(substr(aArq[val(oTree1:currentnodeid),02],1,at(aArq[val(oTree1:currentnodeid),01],aArq[val(oTree1:currentnodeid),02])-1)+"Processados\")
		MakeDir(substr(aArq[val(oTree1:currentnodeid),02],1,at(aArq[val(oTree1:currentnodeid),01],aArq[val(oTree1:currentnodeid),02])-1)+"Processados\")
	EndIF
	FRename(aArq[val(oTree1:currentnodeid),02],substr(aArq[val(oTree1:currentnodeid),02],1,at(aArq[val(oTree1:currentnodeid),01],aArq[val(oTree1:currentnodeid),02])-1)+"Processados\"+aArq[val(oTree1:currentnodeid),01])
	oTree1:DelItem() 
	oTree1:refresh()
	oDlg1:refresh()
Else 
	lNfImp := .F.
EndIf     

nNumItens	:= Len(oXml:_NfeProc:_Nfe:_InfNfe:_DET)

If cVersaoNFE == "2.00"                                   
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dEmi:Text
Else
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
EndIf

cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)

//Base ICMS
nBaseIcm	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:Text)
//Valor ICMS
nVlrIcm		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:Text)
// Valor Mercadorias
nTotalMerc	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text)  
//Base ST
nBaseSt		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:Text)	
// -> Inicializa a variavel para realizar o somatorio de descontos da nota.
nDescNota	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
//Valor IPI
nVlrIPI 	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:Text)

cNumTitulo      := cNum
nValor          := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
	nAcrescimo := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
Else
     nAcrescimo := 0
Endif

cVencimento := ""

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE , "_COBR" ) != Nil
// Voltar mas tem que alterar para aceitar varias parcelas.   
	aVencimento := {}
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_COBR,"_DUP" ) != Nil 
		If Valtype(oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP) <> "A"
			If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP,"_DVENC" ) != Nil
				cVencimento	:= oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP:_DVENC:Text
				cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
				nDiasDp := Cvaltochar(Ctod(cVencimento) - Ctod(cDtEmissao))
				Aadd(aVencimento,cVencimento)
			EndIF
		Else
			aAuxV := oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP
			cBarra := "'%"
			For nX := 1 to len(aAuxV)
				cVencimento := aAuxV[nX]:_DVENC:TEXT  
				cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
				nDias := Ctod(cVencimento) - Ctod(cDtEmissao)
				nDiasDp += cBarra + cvaltochar(nDias)
				cBarra := ","
				Aadd(aVencimento,cVencimento)
			Next nX	
			nDiasDp += "%'"
		EndIf
		CondPag()
	EndIf
EndIf

nFrete	:= val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)

nSeguro	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)
//Valor ST
nIcmsSubs	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
 
Aadd(aList4,{nBaseIcm,nVlrIcm,nBaseSt,nIcmsSubs,nTotalMerc,nFrete,nSeguro,nDescNota,nAcrescimo,nVlrIPI,nValor}) 

For nCont := 1 To nNumItens
	If XmlChildEx(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD, "_xPed") != Nil .And. XmlChildEx(oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD, "_nItemPed") != Nil
	    nExistTag++	
	EndIf
Next
                    
// Verifica se Todas as TAGS possuem o numero do Pedido de Compras e o numero do Item
If nExistTag == nNumItens
    lExistxPed := .T.
EndIf

If lExistxPed
	// Verifica se ้ o mesmo Pedido de Compra em todas as TAGS
	cTagAnt := ""
	cTagAtu	:= ""
	lPrimeira := .T.
	For nCont := 1 To nNumItens                                        
		If lPrimeira
			cTagAnt := oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_xPed:Text
		EndIf
		
		If !lPrimeira
			cTagAtual := oXml:_NfeProc:_Nfe:_InfNfe:_DET[nCont]:_PROD:_xPed:Text
			If cTagAtual <> cTagAnt
				lPedUnico := .F.
				Exit
			EndIf
		EndIf
		lPrimeira := .F.			
	Next

	// Vai utilizar o mesmo numero de Pedido para todos os itens
	If lPedUnico
		lPedTotal := .T.
		cNumPed := oXml:_NfeProc:_Nfe:_InfNfe:_DET[1]:_PROD:_xPed:Text
		
		// Busca itens do pedido de compra com base no pedido de compra do XML
		// Alimenta Array aPedido
		//ItensPed()	
	EndIf
EndIf  
	
// Verifica Produtos - amarra็ใo
lCadOk	:= ValProd(cFornec, cLjFornec, aItensXML)

nItem	:= 0
aCabec	:= {}
aItens	:= {}
aLinha	:= {}

lExistArq	:= .F.
lIniLog		:= .F.
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  03/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Separa Arquivo do Path                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xGetFile(cArq, cPath)

Local cBarra  := "\"
Local nPos    := AT(cBarra,cArq)

Default cArq := ""
Default cPath := "" 

While nPos > 0                     
	cPath += SubStr(cArq, 1, nPos)
	cArq  := SubStr(cArq, nPos + 1)
	nPos := AT(cBarra, cArq)
Enddo

Return cArq   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValProd   บAutor  ณAlexandre Venancio  บ Data ณ 02/05/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que verifica a amarracao entre					  บฑฑ
ฑฑบ          ณ Produto X Fornecedor								          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValProd(cCodFrn, cLojaFrn, aItensXML)
 
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cProdsForn := ""
Local aAux		:= {}
Local nI		:= 0
Local cCodItem	:= ""
Local cDescItem	:= ""
Local lRet		:= .F.
Local cNumItem	:= ""
Local nX
Local ccnpjf 	:= Posicione("SA2",1,xFilial("SA1")+cCodFrn+cLojaFrn,"A2_CGC")
Local aCgcProp	:= FWLoadSM0()
Local lForAtv 	:= ASCAN(aCgcProp,{|X| X[18] == ccnpjf }) > 0 //Alltrim(ccnpjf) $ '04765858000106'


cBarra := ''
cProdsForn := ''

For nI := 1 To Len(aItensXML)
	cNumItem	:= Strzero(val(aItensXML[nI]:_nITEM:Text),4)
	cCodItem	:= Alltrim(aItensXML[nI]:_prod:_cProd:Text)
	cDescItem	:= AllTrim(aItensXML[nI]:_prod:_xProd:Text)
	cCfop		:= AllTrim(aItensXML[nI]:_prod:_CFOP:Text) 
	cNCM		:= AllTrim(aItensXML[nI]:_prod:_NCM:Text)
	nQtdC		:= val(aItensXML[nI]:_prod:_QTRIB:Text) 
	nQtdP		:= val(aItensXML[nI]:_prod:_QCOM:Text) 
	cUNd		:= AllTrim(aItensXML[nI]:_prod:_UCOM:Text)  
	
	If XmlChildEx( aItensXML[nI]:_prod, "_VOUTRO" ) != Nil
		cOutro := AllTrim(aItensXML[nI]:_prod:_VOUTRO:Text)
	Else
		cOutro := 0
	Endif
	If XmlChildEx( aItensXML[nI]:_prod, "_CEST" ) != Nil
		cCest	:= AllTrim(aItensXML[nI]:_prod:_CEST:Text)
	Else
		cCest	:=	''
	EndIF
	nVlrUn		:= val(aItensXML[nI]:_prod:_VUNCOM:Text)
	nVlrSeg 	:= val(aItensXML[nI]:_prod:_VUNTRIB:Text)
	nVlrTo		:= val(aItensXML[nI]:_prod:_VPROD:Text)
	
	cProdsForn += cBarra + Alltrim(cCodItem)
	cBarra := "','"  
	 
	//If(cCNPJ_FIL==sm0->m0_cgc,'04765858000106',PadR('',TamSX3("B1_COD")[1]))
	aAdd(aItensCad, {cNumItem,cCodItem,If(lForAtv,cCodItem,PadR('',TamSX3("B1_COD")[1])), cDescItem,nQtdP,nVlrUn,nVlrTo,cCfop,cNCM,cUNd,cOutro,cCest,cNum,cSerie,nVlrSeg,nQtdC})
Next     

// Busca os produtos na tabela SA5
cQuery += "SELECT A5_PRODUTO, A5_NOMPROD, A5_CODPRF " +CRLF
cQuery += "FROM " +RetSqlName("SA5") + " SA5 " +CRLF
cQuery += "WHERE  " +CRLF
cQuery += "A5_FORNECE = '"+cCodFrn+"' " +CRLF
//cQuery += "AND A5_LOJA = '"+cLojaFrn+"' " +CRLF
cQuery += "AND A5_CODPRF IN ('"+cProdsForn+"') " +CRLF
cQuery += "AND D_E_L_E_T_ = '' " +CRLF
cQuery += "ORDER BY A5_PRODUTO " +CRLF

cQuery := ChangeQuery(cQuery)

If Select("TRBSA5") > 0
	TRBSA5->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRBSA5"

dbSelectArea("TRBSA5")
dbGotop()
While !EOF()
	AADD(aAux, {TRBSA5->A5_PRODUTO,;	// [1] produto interno
				TRBSA5->A5_NOMPROD,;	// [2] descricao
				TRBSA5->A5_CODPRF})		// [3] produto fornecedor
	dbSkip()
End
dbCloseArea()

If Len(aAux) > 0  
	For nX := 1 to len(aItensCad)
		nRes := aScan(aAux, { |x| Alltrim(x[3]) == Alltrim(aItensCad[nX,02]) } )
	 	If nRes > 0
	 		aItensCad[nX,03] := aAux[nRes,01]
	 	EndIf
	Next nX

EndIf                           


RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsNFeChaบAutor  ณAlexandre Venancio  บ Data ณ 02/05/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta NF-e atraves da chave                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ConsNFeChave(cChaveNFe,cRetChv)

Local cIdEnt	:= ""
Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWS
Default cChaveNfe := ""

If Empty(cChaveNFe)
	Return
EndIf
 
// Obtem o codigo da Entidade
GetIdEnt(@cIdEnt)
         
oWs:= WsNFeSBra():New()
oWs:cUserToken   := "TOTVS"
oWs:cID_ENT		 := cIdEnt
ows:cCHVNFE		 := cChaveNFe
oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"

If oWs:ConsultaChaveNFE()
	cRetChv := oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE +CRLF	// AUTORIZADO O USO DA NF-E ?
Else
	IIf(Empty(GetWscError(3)),cRetChv := GetWscError(1), cRetChv := GetWscError(3))
	MsgStop(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),"ConsNFeChave")
	Return
EndIf

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetIdEnt  บAutor  ณAlexandre Venancio  บ Data ณ  25/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obtem o codigo da entidade.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetIdEnt(cIdEnt)

Local aArea  := GetArea()
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObtem o codigo da entidade                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"
	
oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),/*{STR0114}*/{"Ok"},3)
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca Pedidos do fornecedor.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pedidos(cFornec,cLjFornec)

Local aArea	:=	GetArea()
Local cQuery := ''

cQuery := "SELECT * FROM "+RetSQLName("SC7")
cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND C7_FORNECE='"+cFornec+"' AND C7_LOJA='"+cLjFornec+"'"
cQuery += " AND D_E_L_E_T_='' AND C7_QUJE<C7_QUANT"

cQuery := ChangeQuery(cQuery)
	
If Select("TRBSC7") > 0
	TRBSC7->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRBSC7"

dbSelectArea("TRBSC7")
dbGotop()
While !EOF()
	IF Ascan(aList2,{|x| x[2] == TRBSC7->C7_NUM}) == 0
		AADD(aList2,{.F.,;
					TRBSC7->C7_NUM,;	// [1] produto interno
					stod(TRBSC7->C7_EMISSAO),;	// [2] descricao
					stod(TRBSC7->C7_DATPRF),;		// [3] produto fornecedor
					TRBSC7->C7_CONAPRO})	// [4] Pedido bloqueado ou liberado
	EndIF
	//'','Item','Codigo','Descri็ใo','Qtd','Vlr Unit.','Vlr Total'
	Aadd(aList3B,{.F.,TRBSC7->C7_ITEM,TRBSC7->C7_PRODUTO,TRBSC7->C7_DESCRI,TRBSC7->C7_QUANT,TRBSC7->C7_PRECO,TRBSC7->C7_TOTAL,TRBSC7->C7_NUM,TRBSC7->C7_CC})	
				
	dbSkip()
End

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Linhas editaveis                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function editcol(nLinha,nOpcao)

Local aArea	:=	GetArea()
Local lProd :=	.F.
Local nJ
Local lPrdOk	:=	.F.

If nOpcao == 1     
	cBkp	:= aList1[oList1:nAt,03]
	
	
	//lProd	:= ConPad1(,,,"SB1",,,.f.)
	While !lPrdOk
		lEditCell(aList1, oList1, "@!" , 3)
		DbSelectArea("SB1")
		DbSetOrder(1)
		If Dbseek(xFilial("SB1")+aList1[oList1:nAT,03])
			lPrdOk := .T.
			lProd  := .T.
		EndIf
	EndDo

	//Usuario pressionou o ok
	If lProd
		aList1[oList1:nAt,03] := SB1->B1_COD
		aList1[oList1:nAt,18] := SB1->B1_TE	//TES padrao de entrada cadastrada no produto - levar para o campo D1_TESACLA
		If Alltrim(cBkp) <> Alltrim(aList1[oList1:nAt,03])
		    If MsgYesNo("Confirma a amarra็ใo deste item com o fornecedor?","editcol - AVSIXML")
				dbSelectArea("SA5")
				dbSetOrder(2)
				If !DBSeek(xFilial("SA5")+Avkey(aList1[oList1:nAt,03],"A5_PRODUTO")+cFornec+cLjFornec)
			    	RecLock("SA5",.T.)
					SA5->A5_FILIAL     := xFilial("SA5")
					SA5->A5_FORNECE    := cFornec
					SA5->A5_LOJA       := cLjFornec
					SA5->A5_NOMEFOR    := Posicione("SA2",1,xFilial("SA2")+cFornec+cLjFornec,"A2_NOME")
					SA5->A5_PRODUTO    := aList1[oList1:nAt,03]
					SA5->A5_NOMPROD    := Posicione("SB1",1,xFilial("SB1")+aList1[oList1:nAt,03],"B1_DESC")
					SA5->A5_CODPRF     := aList1[oList1:nAt,02]
					SA5->(MSUnLock())
				Else
					If Alltrim(SA5->A5_CODPRF) == "" .Or. AllTrim(SA5->A5_CODPRF) == "0" // Atualiza a amarracao se nao tiver o codigo do fornecedor cadastrado.         
						RecLock("SA5",.F.)
						A5_CODPRF     := aList1[oList1:nAt,02]
						MSUnLock()
					EndIf
				EndIF
		    EndIF
		EndIf
		//Chamada da tela para classificar itens de devolucao de compra.
		If lDevCmp .And. Empty(aList1[oList1:nAt,18])
	   		Processa({|| NFDev(oList1:nAt),"Nota de Devolu็ใo de Compra, Aguarde!!!"+chr(13)+chr(10)+"Buscando notas de saํda do cliente"})		
		EndIf
	EndIf
	oList1:refresh()
	oDlg1:refresh()        
ElseIf nOpcao == 2         
	If aList2[oList2:nAt,01]
		aList2[oList2:nAt,01] := .F.
		For nJ := 1 to len(aList3)
			If aList3[nJ,01]
				aList3[nJ,01] := .F.
			Else
				aList3[nJ,01] := .T.
			EndIF
		Next nJ
	Else   
		If aList2[oList2:nAt,05] == "B"
			MsgAlert("Pedido de Compra ainda em fase de libera็ใo")
		Else
			aList2[oList2:nAt,01] := .T.
			For nJ := 1 to len(aList3)
				If aList3[nJ,01]         
					aList3[nJ,01] := .F.
					aList1[oList1:nAt,22] := ''
					aList1[oList1:nAt,23] := ''
					aList1[oList1:nAt,24] := ''
				Else
					aList3[nJ,01] := .T.
					aList1[oList1:nAt,22] := aList2[oList2:nAt,02]
					aList1[oList1:nAt,23] := aList3[nJ,02]
					aList1[oList1:nAt,24] := aList3[nJ,09]
				EndIF
			Next nJ
		EndIf
	EndIf           
	
	oList2:SetArray(aList2)
	oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04]}}
	    
	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
	 					 aList3[oList3:nAt,02],;
	 					 aList3[oList3:nAt,03],;
	 					 aList3[oList3:nAt,04],; 
	 					 aList3[oList3:nAt,05],;
	 					 aList3[oList3:nAt,06],;
	 					 aList3[oList3:nAt,07]}}
	
	oList3:refresh()
	oList2:refresh()
	oDlg1:refresh()
ElseIf nOpcao == 3   
	If aList3[oList3:nAt,01]
		aList3[oList3:nAt,01] := .F.
		aList1[oList1:nAt,22] := ''
		aList1[oList1:nAt,23] := ''    
		aList1[oList1:nAt,24] := ''
	Else
		aList3[oList3:nAt,01] := .T.
		aList1[oList1:nAt,22] := aList2[oList2:nAt,02]
		aList1[oList1:nAt,23] := aList3[oList3:nAt,02]
		aList1[oList1:nAt,24] := aList3[oList3:nAt,09]
	EndIF
	
	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
	 					 aList3[oList3:nAt,02],;
	 					 aList3[oList3:nAt,03],;
	 					 aList3[oList3:nAt,04],; 
	 					 aList3[oList3:nAt,05],;
	 					 aList3[oList3:nAt,06],;
	 					 aList3[oList3:nAt,07]}}
	
	oList3:refresh()
	oDlg1:refresh()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Tes possiveis para entrada da nf.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaTes()

Local aArea	:=	GetArea()
Local cQuery
      
If len(aList4) > 0
	cQuery := "SELECT * FROM "+RetSQLName("SF4")
	cQuery += " WHERE F4_CODIGO <= '500' AND D_E_L_E_T_=''"
	//Calcula ICMS
	If aList4[oList4:nAt,01] > 0
		cQuery += " AND F4_ICM='S'"
	EndIf             
	//Calcula ST
	If aList4[oList4:nAt,03] > 0
		cQuery += " AND F4_CREDST IN('2')"
	EndIF
	//Calcula IPI
	If aList4[oList4:nAt,10] > 0
		cQuery += " AND F4_IPI='S'"
	EndIf

	cQuery := ChangeQuery(cQuery)
		
	If Select("TRBSF4") > 0
		TRBSF4->(dbCloseArea())
	EndIf
							
	TCQuery cQuery New Alias "TRBSF4"

	dbSelectArea("TRBSF4")
	/*
	'Base ICMS','Vlr ICMS','Base ST','Vlr ST','Total Prod.',;
	'Frete','Seguro','Desconto','Desp. Ac.','IPI','Total NF'
	'','Codigo','Finalidade','Resumo','Calc ICMS','Calc IPI',;
	'Duplicata','Estoque','CFOP','Base ICM','Sit Trib ICM','Sit Trib PIS','Sit Trib COF'
	*/

	While !EOF()
		Aadd(aList5,{'',TRBSF4->F4_CODIGO,TRBSF4->F4_FINALID,TRBSF4->F4_TEXTO,TRBSF4->F4_ICM,;
					TRBSF4->F4_IPI,TRBSF4->F4_DUPLIC,TRBSF4->F4_ESTOQUE,TRBSF4->F4_CF,TRBSF4->F4_BASEICM,;
					TRBSF4->F4_SITTRIB,TRBSF4->F4_CSTPIS,TRBSF4->F4_CSTCOF})
		Dbskip()
	EndDo
EndIf

RestArea(aArea)

Return        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Excecoes Fiscais possiveis para a entrada da nf           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function excefis()

Local aArea	:=	GetArea()
Local cQuery
Local nX

cQuery := "SELECT DISTINCT F7.*"
cQuery += " FROM "+RetSQLName("SF7")+" F7"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_GRTRIB=F7_GRTRIB AND B1.D_E_L_E_T_=''"
cQuery += " 	AND B1_COD IN('"
cBarra := ''                      

For nX := 1 to len(aList1)
	cQuery += cBarra + Alltrim(aList1[nX,03])
	cBarra := "','"
Next nX            

cQuery += "')"

cQuery += " WHERE F7.D_E_L_E_T_='' AND F7_EST='"+cEstFor+"'
      
cQuery := ChangeQuery(cQuery)
	
If Select("TRBSF4") > 0
	TRBSF4->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRBSF4"

dbSelectArea("TRBSF4")
      
/*'','Grupo','Aliq. Int','Aliq. Ext','IVA','Aliq. Pis',
'Aliq. Cof','Base ICMS','Sit Trib','Base ICM ST'*/

While !EOF()
    Aadd(aList6,{'',TRBSF4->F7_GRTRIB,TRBSF4->F7_ALIQINT,TRBSF4->F7_ALIQEXT,TRBSF4->F7_MARGEM,TRBSF4->F7_ALIQPIS,;
    			TRBSF4->F7_ALIQCOF,TRBSF4->F7_BASEICM,TRBSF4->F7_SITTRIB,TRBSF4->F7_BSICMST})
	Dbskip()
EndDo

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gerar Pre-Nota de entrada                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function prenota()

Local aArea	:=	GetArea()
Local nX 
Local nXz 
Local nJx
Local nXp 
Local cFileLoc := Alltrim(aListC1[oListC1:nat,08])

aCabec := {}
aLinha := {}
aItens := {}

// Alteracao da filial corrente. 
cFilAtu := cFilAnt
cFilAnt := cFilOrig   

If lNfImp
	MsgAlert("Nota jแ importada","prenota - AVSIXML")
	Return
EndIf

For nX := 1 to len(aList1)
	If Empty(aList1[nX,03])
		MsgAlert("O Item "+aList1[nX,02]+" nใo foi atrelado a um c๓digo de produto local")
		Return
	EndIF
Next nX

//Notas de devolucao de compras jแ devem entrar no sistema classificadas.
If lDevCmp
	For nXZ := 1 to len(aList1)
		If Empty(aList1[nXZ,18]) .OR. Empty(aList1[nXZ,19]) .Or. Empty(aList1[nXZ,20]) .Or. Empty(aList1[nXZ,21])
			Processa({|| NFDev(nXZ),"Nota de Devolu็ใo de Compra sem devida amarra็ใo, Aguarde!!!"+chr(13)+chr(10)+"Buscando notas de saํda do cliente"})			
		EndIf
	Next nXZ    
	//Return
Endif
 
cCusto := space(15)

 
cPedC := ''
lNPC  := .F.
/*
For nXp := 1 to len(aList2)
	If aList2[nXp,01]
		cPedC := aList2[nXp,02]
		
		For nJx := 1 to len(aList3B)
		
			If aList3B[nJx,08] == aList2[nXp,02]
				If !Empty(aList3B[nJx,09])
					lNPC := .T.
				EndIf
			EndIf
		Next nJx
		exit
	endIf
Next nXp

For nX := 1 to len(aList1)
	If !Empty(aList1[nX,24])
		lNPC := .T.
	EndIf
Next nX
       
If !lNPC    
	aRetc := {}  
	aPergsc 	:= {}

	If cEspecie != "CTE"
	
		aAdd(aPergsc ,{1,"Centro de Custo?	"			,cCusto   ,'',"","","",70,.F.})
		
		If !ParamBox(aPergsc ,"Filtro",@aRetc) 
			MsgAlert("Nใo foi informado o Centro de Custo para importa็ใo do xml")
			Return
		EndIf 
	Else
	
	 	cCc := Posicione("SB1",1,xFilial("SB1")+aList1[1,03],"B1_CC")
	 	If Empty(cCc)
	 		aAdd(aPergsc ,{1,"Centro de Custo?	"			,cCusto   ,'',"","","",70,.F.})
		
			If !ParamBox(aPergsc ,"Filtro",@aRetc) 
				MsgAlert("Nใo foi informado o Centro de Custo para importa็ใo do xml")
				Return
			EndIf 
	 	Else
		 	aadd(aRetc,cCc)
		EndIF
	EndIf
EndIF
*/
                    

For nX := 1 to len(aList1)        
	DbselectArea("SB1")
	DbSetOrder(1)   
	DbSeek(xFilial("SB1")+aList1[nX,03])

	DbSelectArea("SB2")
	DbSetOrder(1)
	If !Dbseek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	EndIf
	// -> Alimenta Array dos Itens
		
	aLinha := {}
	Aadd(aLinha,	{"D1_ITEM"		, STRZERO(VAL(aList1[nX,01]),4), Nil})
	Aadd(aLinha,	{"D1_FILIAL"	, xFilial("SD1")				, Nil})
	Aadd(aLinha,	{"D1_DOC"		, cNum							, Nil})
	Aadd(aLinha,	{"D1_SERIE"		, cSerie						, Nil})
	Aadd(aLinha,	{"D1_COD"		, aList1[nX,03]					, Nil})
	//Aadd(aLinha,	{"D1_X_DESCP"	, Posicione("SB1",1,xFilial("SB1")+aList1[nX,03],"B1_DESC")					, Nil})
	
	Aadd(aLinha,	{"D1_QUANT"		, aList1[nX,05]					, Nil})
	Aadd(aLinha,	{"D1_VUNIT"		, aList1[nX,06]					, Nil})
	If !Empty(SB1->B1_SEGUM)
		Aadd(aLinha,	{"D1_QTSEGUM"	, aList1[nX,16]					, Nil})
	EndIf
		
	Aadd(aLinha,	{"D1_TOTAL"		, aList1[nX,07]					, Nil}) //Valor total proporcional
	Aadd(aLinha,	{"D1_VALDESC"	, 0								, Nil}) //Valor Desconto proporcional /*nValDesc/nQuant*nQuantLt*/
	Aadd(aLinha,	{"D1_UM"		, SB1->B1_UM					, Nil}) 
	Aadd(aLinha,	{"D1_SEGUM"		, SB1->B1_SEGUM					, Nil}) 
	Aadd(aLinha,	{"D1_LOCAL"		, SB1->B1_LOCPAD				, Nil}) 
	Aadd(aLinha,	{"D1_CLASFIS"	, SB1->B1_ORIGEM				, Nil})  
	
	If lDevCmp
		Aadd(aLinha,	{"D1_TES"		, aList1[nX,18]				, Nil}) 
		Aadd(aLinha,	{"D1_NFORI"		, aList1[nX,19]				, Nil}) 
		Aadd(aLinha,	{"D1_SERIORI"	, aList1[nX,20]				, Nil}) 
		Aadd(aLinha,	{"D1_ITEMORI"	, aList1[nX,21]				, Nil})  
		//Gravar informa็ใo de identificacao da tabela SB6 - Controle de terceiros.
		/*If lRetBen
			cIdentB6 := Control3(aList1[nX,03],aList1[nX,19],aList1[nX,20],aList1[nX,21])  
			//aSldSB6 := CalcTerc(aList1[nX,03],cFornec,cLjFornec,cIdentB6,'400','B')
			Aadd(aLinha,	{"D1_IDENTB6"	, cIdentB6			, Nil})  
		EndIF*/
	Else
		If !Empty(aList1[nX,18])
			Aadd(aLinha,	{"D1_TESACLA"		, aList1[nX,18]				, Nil})   
		else
			If !Empty(SB1->B1_TE)
				Aadd(aLinha,	{"D1_TESACLA"		, aList1[nX,18]				, Nil})   
			endIf
		EndIf
	EndIf   
	
	// Caso seja importa็ใo sem Pedido, nใo adiciona o Pedido/Item
	//If !lPedSem
	
	If !Empty(aList1[nX,22])
		Aadd(aLinha,	{"D1_PEDIDO"	, aList1[nX,22]				, Nil}) // Numero do Pedido de Compra  
		Aadd(aLinha,	{"D1_ITEMPC"	, aList1[nX,23]				, Nil}) // Numero do Item do Pedido de Compra
	EndIf
	//aadd(aCabec,	{"D1_FILIAL"	, xFilial("SD1")						,NIL})

	//Aadd(aLinha,	{"D1_CC"	, If(!lNPC,aRetc[1],aList1[nX,24])				, Nil}) // Numero do Pedido de Compra
	
	//EndIf
	// Incluir sempre no ultimo elemento do array de cada item
	Aadd(aLinha,{"AUTDELETA"	, "N"					,Nil}) 
	Aadd(aItens,aLinha)  
Next nX	

If lDevCmp			
	DbselectArea("SA1")
	DbSetOrder(3)
	If Dbseek(xFilial("SA1")+cCNPJ_FOR)
		cFornec 	:= SA1->A1_COD
		cLjFornec 	:= SA1->A1_LOJA
	EndIf
EndIf

cCondPg := CondPag()

aadd(aCabec,	{"F1_FILIAL"	, xFilial("SF1")						,NIL})
aadd(aCabec,	{"F1_TIPO"		, IF(!lDevCmp,"N",If(lRetBen,"B","D"))	,NIL})
aadd(aCabec,	{"F1_FORMUL"	, "N"									,NIL})
aadd(aCabec,	{"F1_DOC"		, cNum									,NIL})
aadd(aCabec,	{"F1_SERIE"		, cSerie								,NIL})
aadd(aCabec,	{"F1_EMISSAO"	, ctod(cDtEmissao)						,NIL})
aadd(aCabec,	{"F1_FORNECE"	, cFornec								,NIL})
aadd(aCabec,	{"F1_LOJA"		, cLjFornec								,NIL})
aadd(aCabec,	{"F1_ESPECIE"	, cEspecie								,NIL})
aAdd(aCabec,	{"F1_COND"		, If(!Empty(cForCond),cForCond,cCondPg),NIL})
aAdd(aCabec,	{"F1_EST"		, cEstFor 								,NIL})
aadd(aCabec,	{"F1_SEGURO"	, nSeguro								,NIL})
aadd(aCabec,	{"F1_FRETE"		, nFrete								,NIL})
aadd(aCabec,	{"F1_DESCONT"	, nDescNota								,NIL})
aadd(aCabec,	{"F1_VALMERC"	, nTotalMerc							,NIL})
aadd(aCabec,	{"F1_VALBRUT"	, nTotalMerc+nSeguro+nFrete+nIcmsSubs	,NIL})
aAdd(aCabec,	{"F1_CHVNFE"	, cChave_NFe        					,NIL})    

If cEspecie == "CTE"
	aAdd(aCabec,	{"F1_TPCTE"	, "N"	 	        					,NIL})    
EndIf
 
//MsProcTxt("Salvando Nota Fiscal na base de dados")
//BeginTran()
     


IF !lDevCmp
	MATA140(aCabec,aItens,3)		// Pr้-Nota
Else
	MATA103(aCabec,aItens,3,.t.)	// Documento de Entrada
EndIf

cFilAnt := cFilAtu
     
If !lMsErroAuto
	//EndTran() 
	If MsgYesNo("O arquivo XML foi importado com sucesso!" +CRLF +"Deseja visualizar a Pr้-Nota?")
		A103NFiscal('SF1',Recno(),1)
	EndIf
	//FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".auto")
	FRename(cPathL+cFileLoc, cPathL+"\Processados\"+strtran(upper(cFileLoc),".XML",".PROC"))
	
	/*IF !ExistDir(substr(aArq[val(oTree1:currentnodeid),02],1,at(aArq[val(oTree1:currentnodeid),01],aArq[val(oTree1:currentnodeid),02])-1)+"Processados\")
		MakeDir(substr(aArq[val(oTree1:currentnodeid),02],1,at(aArq[val(oTree1:currentnodeid),01],aArq[val(oTree1:currentnodeid),02])-1)+"Processados\")
	EndIF
	FRename(aArq[val(oTree1:currentnodeid),02],substr(aArq[val(oTree1:currentnodeid),02],1,at(aArq[val(oTree1:currentnodeid),01],aArq[val(oTree1:currentnodeid),02])-1)+"Processados\"+aArq[val(oTree1:currentnodeid),01])
*/
	/*oTree1:DelItem() 
	oTree1:refresh()*/
	oDlg1:refresh()
Else
	MostraErro()
	lMsErroAuto := .F.
	//FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".auto")
	//DisarmTransaction()	// desfaz as alteracoes ja efetuadas.
EndIf   
//MSUnlockAll()
	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/02/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FhelpPC(nLinha)

Local aArea	:=	GetArea()
Local nX 

aList3 := {}
     
For nX := 1 to len(aList3B)
	If Alltrim(aList3B[nX,08]) == Alltrim(aList2[nLinha,02])
		Aadd(aList3,aList3B[nX])
	EndIf
Next nX
      
If len(aList3) < 1
	Aadd(aList3,{.F.,"","","","","",""}) 
EndIf
      
oList3:SetArray(aList3)
oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
 					 aList3[oList3:nAt,02],;
 					 aList3[oList3:nAt,03],;
 					 aList3[oList3:nAt,04],; 
 					 aList3[oList3:nAt,05],;
 					 aList3[oList3:nAt,06],;
 					 aList3[oList3:nAt,07]}}

oList3:refresh()
oDlg1:refresh()
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Clique botao direito grid 1 para alterar quantidade do     บฑฑ
ฑฑบ          ณproduto de entrada conforme cadastro.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function altqtd()

Local aArea	:=	GetArea()
Local cPeso
Local nQtd1                                                                           
Local aPergs	:=	{}
Local aRet		:=	{}
Local nX 

If Empty(aList1[oList1:nAt,03])
	MsgAlert("Produto ainda nใo classificado com o c๓digo pr๓prio.","altqtd - AVSIXML")
	Return
EndIf

aAdd(aPergs ,{2,"Converter por?"	,"",{"1=Peso","2=Fator de Conversใo"},100,"",.F.})	

If !ParamBox(aPergs ,"Filtro",@aRet)
	Return
EndIf

If aRet[1] == "1"    
	For nX := 1 to len(aList1)
		If !Empty(aList1[nX,03])
			cPeso := Posicione("SB1",1,xFilial("SB1")+aList1[nX,03],"B1_PESO")
			
		    //Re-calculando as quantidades de entrada conforme a regra de utilizacao da empresa (Peso ou fator de conversใo)
		    //quando os itens da nota de entrada vierem na unidade de medida do cliente ou fornecedor.
			//5,6,7 
			If !aList1[nX,17]
				aList1[nX,05] := aList1[nX,05] * cPeso
				aList1[nX,06] := aList1[nX,07] / aList1[nX,05]
				aList1[nX,17] := .T.
			EndIF
		EndIF
	Next nX
	oList1:refresh()
	oDlg1:refresh()
Else
	For nX := 1 to len(aList1)
		If !Empty(aList1[nX,03])
			nQtd1 := Posicione("SB1",1,xFilial("SB1")+aList1[nX,03],"B1_CONV")
		    If nQtd1 == 0        
		    	aPergs 	:=	{}
		    	aRet 	:=	{}
				nQtCx := space(5)
		    	aAdd(aPergs ,{1,"Quantidade por Caixa"			,nQtCx   ,'',"","","",70,.F.})
            
				If !ParamBox(aPergs ,"Filtro",aRet)
					Return
				EndIf
				nQtd1 := val(aRet[1])
			EndIf

		    //Re-calculando as quantidades de entrada conforme a regra de utilizacao da empresa (Peso ou fator de conversใo)
		    //quando os itens da nota de entrada vierem na unidade de medida do cliente ou fornecedor.
			//5,6,7 
			If !aList1[nX,17]
				aList1[nX,05] := aList1[nX,05] * nQtd1
				aList1[nX,06] := aList1[nX,07] / aList1[nX,05]
				aList1[nX,17] := .T.
			EndIF
		EndIF
	Next nX
	oList1:refresh()
	oDlg1:refresh()
EndIF

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Amarracao nota de saida com nota de devolucao             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NFDev(nLinha)
      
Local aArea	:=	GetArea()                   
Local cNome := ''
Local cProd	:= ''  
Local nOpcao:= 0        
Local lSair := .F.
Local nX 
Local nLin 

Private oDlgNFD,oGrNFD,oSayNF1,oSayNF2,oBNFD
Private aNfs	:=	{}
Private oNfs	:=	{}
 
cQuery := "SELECT D2_ITEM,D2_COD,D2_QUANT,D2_QTDEDEV,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_EMISSAO,A1_NOME,B1_DESC,F4_TESDV,D2_PRCVEN"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL="+xFilial("SA1")+" AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_=''"
cQuery += "	AND A1_CGC='"+cCNPJ_FOR+"'"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL="+xFilial("SB1")+" AND B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_CODIGO=D2_TES AND F4.D_E_L_E_T_=''"
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"' AND D2.D_E_L_E_T_='' AND D2_EMISSAO>='20130601'"
cQuery += " AND D2_COD='"+aList1[nLinha,03]+"'"
cQuery += " ORDER BY D2_EMISSAO DESC"
 
cQuery := ChangeQuery(cQuery)

If Select("TRBSD2") > 0
	TRBSD2->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRBSD2"

dbSelectArea("TRBSD2")
While !EOF()
	Aadd(aNfs,{TRBSD2->D2_ITEM,TRBSD2->D2_COD,TRBSD2->D2_QUANT,TRBSD2->D2_QTDEDEV,TRBSD2->D2_DOC,TRBSD2->D2_SERIE,;
			TRBSD2->D2_CLIENTE,TRBSD2->D2_LOJA,stod(TRBSD2->D2_EMISSAO),TRBSD2->F4_TESDV,.F.,TRBSD2->D2_PRCVEN})
	cNome := TRBSD2->A1_NOME 
	cProd := TRBSD2->B1_DESC
	Dbskip()
EndDo


For nX := 1 to len(aNfs) 
	cIdentB6 := Control3(aNfs[nX,02],aNfs[nX,05],aNfs[nX,06],aNfs[nX,01])  
	aSaldo:= CalcTerc(aNfs[nX,02],aNfs[nX,07],aNfs[nX,08],cIdentB6,aNfs[nX,10],,aNfs[nX,09],aNfs[nX,09])  
	//aSldSB6 := CalcTerc(aCols[n][nPosCod],cA100For,cLoja,aCols[n][nPosIdentB6],aCols[n][nPosTES],cTipo)
	aNfs[nX,04] := aSaldo[1]
Next nX

If len(aNfs) > 0

	While !lSair	
		oDlgNFD      := MSDialog():New( 092,232,579,924,"Notas de Saํda para o Cliente",,,.F.,,,,,,.T.,,,.T. )
		//oDlgNFD:escclose := .F.
		
		oGrNFD     := TGroup():New( 004,008,044,332,"oGrNFD",oDlgNFD,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSayNF1      := TSay():New( 013,044,{||cNome},oGrNFD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,248,008)
			oSayNF2      := TSay():New( 028,044,{||cProd},oGrNFD,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,276,008)
		
			//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{048,008,216,332},,, oDlg1 ) 
		    oNfs:= 	TCBrowse():New(048,008,332,160,, {'','Item','Codigo','Qtd Saida','Saldo','Nota','Serie','Emissใo'},;
		    						{10,30,30,30,30,30,30,30},;
		                            oDlgNFD,,,,{|| },{|| marklin(oNfs:nAt,nLinha)},, ,,,  ,,.F.,,.T.,,.F.,,,)
			oNfs:SetArray(aNfs)
			oNfs:bLine := {||{ If(aNfs[oNfs:nAt,11],oOk,oNo),;
								aNfs[oNfs:nAt,01],; 
			 					 aNfs[oNfs:nAt,02],;
			 					 aNfs[oNfs:nAt,03],;
			 					 aNfs[oNfs:nAt,04],; 
			 					 aNfs[oNfs:nAt,05],;
			 					 aNfs[oNfs:nAt,06],;
			 					 aNfs[oNfs:nAt,09]}}
		
			oBNFD      := TButton():New( 220,140,"Confirmar",oDlgNFD,{||oDlgNFD:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )
			
		oDlgNFD:Activate(,,,.T.)
		
		If nOpcao == 1
			For nLin := 1 to len(aNfs)
				If aNfs[nLin,11]
					aList1[nLinha,18] := aNfs[nLin,10] //TES
					aList1[nLinha,19] := aNfs[nLin,05] //NFORI
					aList1[nLinha,20] := aNfs[nLin,06] //SERIORI
					aList1[nLinha,21] := aNfs[nLin,01] //ITEMORI
					If aList1[nLinha,06] <> aNfs[nLin,12]
						aList1[nLinha,06] := aNfs[nLin,12]
						aList1[nLinha,07] := aList1[nLinha,06] * aList1[nLinha,05] 
					EndIf
					lSair := .T.
					exit
				EndIf
			Next nLin
		EndIf
	EndDo      
Else
	MsgAlert("Nใo hแ notas de saํda para este cliente, favor verificar.")
EndIF
 
RestArea(aArea)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Seleciona ou desmarca a linha atual                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function marklin(nLinha,nLin2)

Local aArea	:=	GetArea()
Local nX 

For nX := 1 to len(aNfs)
	If nX <> nLinha
		aNfs[nX,11] := .F.
	EndIF
Next nX  

If aNfs[nLinha,11]
	aNfs[nLinha,11] := .F.
Else
	aNfs[nLinha,11] := .T.
EndIf

oNfs:refresh()
oBNFD:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Identificacao do item na sb6 - controle de terceiro      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Control3(cProd3,cNota3,cSer3,cItem3)               

Local aArea	:=	GetArea()
Local cretorno	:=	''
                
cQuery := "SELECT B6_IDENT FROM "+RetSQLName("SB6")+" B6"
cQuery += " WHERE B6_FILIAL='"+xFilial("SB6")+"' AND B6_PRODUTO='"+cProd3+"' AND B6_SERIE='"+cSer3+"' AND B6_DOC='"+cNota3+"'"
                
cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRB"

dbSelectArea("TRB")

cRetorno := TRB->B6_IDENT

RestArea(aArea)

Return(cretorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida condicao de pagamento da nota de entrada           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CondPag()

Local aArea	:=	GetArea()  
Local cCond	:=	''

If Empty(nDiasDp)
	Return(cCond)
endIf

cQuery := "SELECT E4_CODIGO FROM "+RetSQLName("SE4")+" E4"
cQuery += " WHERE E4_FILIAL='"+xFilial("SE4")+"' AND E4_TIPO='1' AND E4_COND LIKE "+cvaltochar(nDiasDp)
                
cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRB"

dbSelectArea("TRB")

cCond := TRB->E4_CODIGO

If Empty(cCond)                                                                                                                                                     
	/*If MsgYesno("Nใo encontrada nenhuma condi็ใo que atenda estes vencimentos contidos na NF."+Chr(13)+Chr(10)+"Deseja cadastrar a condi็ใo de acordo com a Nota?","CondPag - AVSIXML")
		
	Else
	
	EndIf*/
	cCond := '001'
EndIF

RestArea(aArea)

Return(cCond)             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  06/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Importacao dos arquivos CTE                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function XMLCTE(cFile)

Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL
Local oXmlWS		:= NIL	// Objeto XML que serแ utilizado na abertura da OS no Keeple
Local aPergs		:= {}	// Utilizado no ParamBox no inicio da execu็ใo
Local aRet			:= {}	// Utilizado no ParamBox no inicio da execu็ใo
Local nPapel 

aItensCad := {}
cEspecie  := "CTE"
//MsProcTxt("Iniciando leitura do arquivo..")
// Gera o objeto com dados do XML
oXml := XmlParserFile( cFile, "_", @cError, @cWarning )   //
If ValType(oXml) != "O"
     //Alert(cFile+" - "+cError)
     Return()
Endif

// Objeto XML para ser utilizado no WS do Keeple - copiado pois o Objeto original tera sua estrutura modificada
oXmLWS := oXML

cVersaoCTE := oXML:_CTEProc:_versao:TEXT   //oXml:_CTEPROC:_VERSAO:TEXT

// -> Verifica se NF estแ autorizada na Sefaz
cChave_Nfe := SubStr(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4)

If Empty(cChave_Nfe)
	MsgAlert("A chave de acesso nใo foi informada!","XMLCTE")
	Return
EndIf                                

// Inicializa as variaveis de controle
nError := 0
cFilorig := '' //xFilial("SF1") //"XX"
//Busca pelo cnpj do remetente pois o destinatario no CTe e o cliente que recebera a mercadoria.
cCNPJ_FIL := oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT //oxml:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
aFils 	:=	{}
//MsProcTxt("Verificando filial: " +cEmpAnt)
OpenSm0()
SM0->(dbGoTop())
While !SM0->(Eof())
     If cEmpAnt != SM0->M0_CODIGO
          SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
          loop
     Endif
     
     If cCNPJ_FIL == SM0->M0_CGC
          cFilorig := SM0->M0_CODFIL
          Exit //Forca a saida
     Endif
     
     Aadd(aFils,SM0->M0_CODFIL)
     
     SM0->(dbskip())
EndDo

/*
If Empty(cFilorig)
	aPergs	:= {}
	aRet 	:= {}
	
	aAdd(aPergs,{2,"Selecione a Filial de entrada","",aFils,080,'',.T.})

	If !ParamBox(aPergs ,"Filtro",aRet)
		Return	
	Else	
		cFilorig := aRet[1]
	EndIf
EndIf
*/

cNatOp	:= PadR(oXml:_cteProc:_cte:_Infcte:_IDE:_NATOP:Text,45," ")

cCNPJ_FOR := oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
//MsProcTxt("Verificando fornecedor: " +cCNPJ_FOR)
DBSelectArea("SA2")
DBSetOrder(3)
If DbSeek(xFilial("SA2")+cCNPJ_FOR)
	cFornec		:= SA2->A2_COD
	cLjFornec	:= SA2->A2_LOJA
	cEstFor		:= SA2->A2_EST
	cNomeFor	:= SA2->A2_NOME
	cForCond	:= SA2->A2_COND
	cEndFor		:= Alltrim(SA2->A2_END)+" - "+Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+cEstFor
	cIE_FOR		:= SA2->A2_INSCR
Else
	MsgAlert(OemToAnsi("Fornecedor inexistente! " + cCNPJ_FOR +CRLF))
Endif

cNum	:= PadL(Alltrim(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT),9,"0") //Nro da Nota
cSerie	:= PadR(oXml:_CTEProc:_CTE:_InfCTE:_IDE:_Serie:Text,3," ")


// -> Verifica se jแ existe essa NF na base de dados
//MsProcTxt("Verificando exist๊ncia da Nota Fiscal: " +cNum)
DBSelectArea("SF1")
DbSetorder(1)
If DbSeek(cFilorig+AvKey(cNum,"F1_DOC")+AvKey(cSerie,"F1_SERIE")+AvKey(cFornec,"F1_FORNECE")+AvKey(cLjFornec,"F1_LOJA")+AvKey(cTipo,"F1_TIPO")/*,.T.*/)
	If lExecMenu
		Alert(OemToAnsi("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."))
		GeraLog("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."  +CRLF)
		FClose(nHdl)
		Return()
	Else
		ConOut("Nao importada. Nota Fiscal jแ consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
		GeraLog("Nao importada. Nota Fiscal jแ consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
		FClose(nHdl)
		Return()
	EndIf
EndIf     

cDtEmissao	:= oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_dhEmi:Text

cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)
            
cNumTitulo      := cNum
nTotalMerc      := Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)

cVencimento := ""  

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC, "_INFNFE" ) != Nil
	If Valtype(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE) <> "A"
		cChvNFS := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
		aItemNF := {} //BuscNFT(cChvNFS,'')   
	Else
		aChaves := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
		cBarra := ''
		cChvNFS:= ''
		For nPapel := 1 to len(aChaves)
			cChvNFS += cBarra + aChaves[nPapel]:_CHAVE:TEXT
			cBarra := "','"
		Next nPapel
		
		aItemNF 	:= {} //BuscNFT(cChvNFS,'')
		
	EndIF
Else
                                   
	cNfs	:=	space(150)
	aAdd(aPergs ,{1,"Numero das NFs?"			,cNfs   ,'',"","","",120,.F.})

	If !ParamBox(aPergs ,"Filtro",aRet)
		Return	
	Else
		aItemNF := {} //BuscNFT('',aRet[1])
	EndIf
EndIf

nFrete := 0
nSeguro := 0
nIcmsSubs := 0
	
//aAdd(aItensCad, {'01','FRETE','FRETE','FRETE',1,nTotalMerc,nTotalMerc,'cfop','ncm','cund','outro','cest',cNum,cSerie,'seguro',0})

cTable := oTable:GetAlias()

DbSelectArea(cTable)
DbSetOrder(1)
IF !DbSeek(cChave_NFe)
	nHandle := FT_FUse(cFile) 
	cLine := ''
	While !FT_FEOF()                                              
		cLine	+= FT_FReadLn() // Retorna a linha corrente  
		FT_FSKIP()
	End
	 	
	Reclock(cTable,.T.)
	&(cTable+"->TMP_CHAVE")	:=	cChave_NFe
	&(cTable+"->TMP_CNPJF")	:=	cCNPJ_FOR
	&(cTable+"->TMP_CNPJC")	:=	cCNPJ_FIL
	&(cTable+"->TMP_NUM")	:=	cNum
	&(cTable+"->TMP_PREFIX"):=	cSerie
	&(cTable+"->TMP_FLAGIM"):=	"1"      
	&(cTable+"->TMP_EMISSA"):=	ctod(cDtEmissao)
	//ZZ0->ZZ0_XMLNFE	:=	cLine 
	&(cTable+"->TMP_XMLNFA"):=	cLine
	&(cTable+"->TMP_FILE")	:=	cFile 
	&(cTable)->(Msunlock())
EndIF 

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  06/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca notas de saida ou entrada que foram transportadas   บฑฑ
ฑฑบ          ณde acordo com o conhecimento de transporte                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscNFT(cChave,cNotas)

Local aArea		:=	GetArea()
Local cQuery 
Local aItens	:=	{}  
Local nOpc		:=	0
Local aRet		:=	{}
Local aSplit	:=	strtokarr(cNotas,",")
Local nX 

Private aItmCT	:=	{}
Private oFret1
Private oFret2


SetPrvt("oItemCT","oGCT1","oBrw1","oGCT2","oBrw2","oBCT1")

cQuery := "SELECT B1_COD,B1_DESC,B1_TE,F4_FINALID FROM "+RetSQLName("SB1")+" B1"
cQuery += " LEFT JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL='"+xFilial("SF4")+"' AND F4_CODIGO=B1_TE AND F4.D_E_L_E_T_=''"
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD IN('883','884','886','887','888','889','890') AND B1.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIXML.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aItmCT,{.F.,Alltrim(TRB->B1_COD),Alltrim(TRB->B1_DESC),Alltrim(TRB->B1_TE),Alltrim(TRB->F4_FINALID)})
	Dbskip()
EndDo

cQuery := "SELECT F2_DOC,D2_COD,B1_DESC,D2_TES,D2_CF,F4_FINALID"
cQuery += " FROM "+RetSQLName("SF2")+" F2"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_CODIGO=D2_TES AND F4.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
cQuery += " WHERE F2.D_E_L_E_T_=''"

If !Empty(cChave)
	If "," $ cChave
		cQuery += " AND F2_CHVNFE IN('"+cChave+"')"
	Else
		cQuery += "	AND F2_CHVNFE='"+cChave+"'"
	EndIf
Else
	cQuery += " AND F2_DOC IN('" 
	cBarra := ''
	
	For nX := 1 to len(aSplit)
		cQuery += cBarra + Strzero(val(aSplit[nX]),9)
		cBarra := "','"
	Next nX            
	
	cQuery += "')"
EndIf

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIXML.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aItens,{TRB->F2_DOC,Alltrim(TRB->D2_COD),Alltrim(TRB->B1_DESC),TRB->D2_TES,TRB->D2_CF,Alltrim(TRB->F4_FINALID)})
	Dbskip()
EndDo       

If len(aItens) < 1       
	cQuery := "SELECT F1_DOC,D1_TES,D1_COD,B1_DESC,D1_CF,F4_FINALID"
	cQuery += " FROM "+RetSQLName("SF1")+" F1"
	cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1.D_E_L_E_T_=''
	cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_CODIGO=D1_TES AND F4.D_E_L_E_T_=''
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D1_COD AND B1.D_E_L_E_T_=''"
	cQuery += " WHERE F1.D_E_L_E_T_=''"
	
	If !Empty(cChave)
		If "," $ cChave
			cQuery += " AND F1_CHVNFE IN('"+cChave+"')"
		Else
			cQuery += "	AND F1_CHVNFE='"+cChave+"'"
		EndIf
	Else
		cQuery += " AND F1_DOC IN('" 
		cBarra := ''
		
		For nX := 1 to len(aSplit)
			cQuery += cBarra + Strzero(val(aSplit[nX]),9)
			cBarra := "','"
		Next nX            
		
		cQuery += "')"
	EndIf                 
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("AVSIXML.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")  
	
	While !EOF()
	    Aadd(aItens,{Alltrim(TRB->F1_DOC),Alltrim(TRB->D1_COD),Alltrim(TRB->B1_DESC),TRB->D1_TES,TRB->D1_CF,Alltrim(TRB->F4_FINALID)})
		Dbskip()
	EndDo  
EndIf

If len(aItens) < 1
	MsgAlert("Nใo encontrada a nota de origem do Frete")
    Aadd(aItens,{'','','','','',''})
EndIf

If len(aItens) > 0

	oItemCT    := MSDialog():New( 092,232,568,852,"Nota de Origem do Frete",,,.F.,,,,,,.T.,,,.T. )

		oGCT1      := TGroup():New( 004,004,104,300,"Nota e Item",oItemCT,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,008,100,296},,, oGCT1 ) 
	    oFret1:= 	TCBrowse():New(012,008,285,090,, {'Nota','Codigo','Descri็ใo','TES','CFOP','Finalidade'},{35,30,50,30,30,50},;
	                            oGCT1,,,,{|| },{|| /*editcol(oList1:nAt,1)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oFret1:SetArray(aItens)
		oFret1:bLine := {||{aItens[oFret1:nAt,01],; 
		 					 aItens[oFret1:nAt,02],;
		 					 aItens[oFret1:nAt,03],;
		 					 aItens[oFret1:nAt,04],; 
		 					 aItens[oFret1:nAt,05],;
		 					 aItens[oFret1:nAt,06]}}
	
		oGCT2      := TGroup():New( 108,004,208,300,"Produto e TES CTe",oItemCT,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{116,008,204,296},,, oGCT2 ) 
 
	    oFret2:= 	TCBrowse():New(116,008,285,090,, {'','Codigo','Descri็ใo','TES','Finalidade'},{10,30,50,30,50},;
	                            oGCT2,,,,{|| },{|| editct(oFret2:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oFret2:SetArray(aItmCT)
		oFret2:bLine := {||{If(aItmCT[oFret2:nAt,01],oOk,oNo),; 
							 aItmCT[oFret2:nAt,02],; 
		 					 aItmCT[oFret2:nAt,03],;
		 					 aItmCT[oFret2:nAt,04],;
		 					 aItmCT[oFret2:nAt,05]}}
		 					 
		oBCT1      := TButton():New( 212,124,"Confirmar",oItemCT,{||oItemCT:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
	
	oItemCT:Activate(,,,.T.)
EndIf

If nOpc == 1
	For nX := 1 to len(aItmCT)
		If aItmCT[nX,01]
			Aadd(aRet,{aItmCT[nX,02],aItmCT[nX,03],aItmCT[nX,04]}) 
			exit
		EndIf
	Next nX
EndIf

RestArea(aArea)

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  06/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marca e desmarca o produto que vai para a nota de          บฑฑ
ฑฑบ          ณconhecimento de transporte                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editct(nLinha)    

Local aArea	:=	GetArea()
Local nX 

For nX := 1 to len(aItmCT)
	If aItmCT[nX,01]	
		aItmCT[nX,01]	:= .F.
	EndIf
Next nX  

aItmCT[nLinha,01] := .T.

oFret2:refresh()
oItemCT:refresh()

RestArea(aArea)

Return                                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  08/21/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Procurar()

Local aPergs		:= {}	// Utilizado no ParamBox no inicio da execu็ใo
Local aRet			:= {}	// Utilizado no ParamBox no inicio da execu็ใo
Local cCIC			:= space(14)   
Local aItSrc		:= {}
Local nX 

aAdd(aPergs ,{1,"CNPJ	"			,cCIC   ,'',"","","",70,.F.})

If !ParamBox(aPergs ,"Filtro",@aRet) 
	Return
EndIf

nPos := Ascan(aListC1,{|x| substr(x[9],1,len(alltrim(aRet[1]))) == Alltrim(aRet[1])})

If nPos > 0
	oListC1:nAT := nPos
	oListC1:refresh()
	oDlg1:refresh()
ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  08/23/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscCnpj(cArquivo)

Local oXmlx			:= NIL
Local cCNPJ			:= '' 
Local cError		:= ""
Local cWarning		:= ""

oXmlx := XmlParserFile( cArquivo, "_", @cError, @cWarning )

If XmlChildEx( oXmlx, "_NFEPROC" ) != Nil
	cCNPJ := oxmlx:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
EndIf 

Return(cCNPJ)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  12/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function gravaxml(cFile)

Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL

aItensCad := {}
cEspecie := "SPED"
//"Iniciando leitura do arquivo.."
// Gera o objeto com dados do XML
If !lCoffe
	oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
Else
	oXml := XmlParserFile( aArq[val(oTree1:currentnodeid),02], "_", @cError, @cWarning )
EndIF

If ValType(oXml) != "O"
     MsgAlert(cFile+" - "+cError)
     Return()
Endif

IF XmlChildEx(oXml , "_CTEPROC") != NIL 
	oXml := NIL
	XMLCTE(cPath+cFile)
	return
EndIf

If XmlChildEx(oXml , "_NFEPROC") != Nil

	cVersaoNFE := oXML:_nfeProc:_versao:TEXT

	// -> Verifica se NF estแ autorizada na Sefaz
	cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)

	If Empty(cChave_NFe)
		MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
		Return
	EndIf   
	 
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT , "_CNPJ" ) != Nil
		cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	Else
		cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT
	EndIf
	//Verificando fornecedor: " +cCNPJ_FOR)                  
	cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
	cSerie	:= STRZero(val(Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)

	//cnpj
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_DEST , "_CNPJ" ) != NIL
		cCNPJ_FIL := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	else
		cCNPJ_FIL := cCNPJ_FOR
	EndIf 

	dDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
else
	cVersaoNFE := oXML:_NFE:_INFNFE:_versao:TEXT

	// -> Verifica se NF estแ autorizada na Sefaz
	cChave_NFe := SubStr(oxml:_NFE:_INFNFE:_ID:TEXT,4)

	If Empty(cChave_NFe)
		MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
		Return
	EndIf   
	 
	If XmlChildEx( oXml:_NFE:_INFNFE:_EMIT , "_CNPJ" ) != Nil
		cCNPJ_FOR := oxml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	Else
		cCNPJ_FOR := oxml:_NFE:_INFNFE:_EMIT:_CPF:TEXT
	EndIf
	//Verificando fornecedor: " +cCNPJ_FOR)                  
	cNum	:= PadL(Alltrim(oXml:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
	cSerie	:= STRZero(val(Alltrim(oXml:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)

	//cnpj
	If XmlChildEx( oXml:_NFE:_INFNFE:_DEST , "_CNPJ" ) != NIL
		cCNPJ_FIL := oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	else
		cCNPJ_FIL := cCNPJ_FOR
	EndIf 

	dDtEmissao	:= oXml:_NFE:_INFNFE:_IDE:_dhEmi:Text
EndIf 

cTable := oTable:GetAlias()

DbSelectArea(cTable)
DbSetOrder(1)
IF !DbSeek(cChave_NFe)
	nHandle := FT_FUse(cPathL+cFile) 
	cLine := ''
	While !FT_FEOF()                                              
		cLine	+= FT_FReadLn() // Retorna a linha corrente  
		FT_FSKIP()
	End
	 	
	Reclock(cTable,.T.)
	&(cTable+"->TMP_CHAVE")	:=	cChave_NFe
	&(cTable+"->TMP_CNPJF")	:=	cCNPJ_FOR
	&(cTable+"->TMP_CNPJC")	:=	cCNPJ_FIL
	&(cTable+"->TMP_NUM")	:=	cNum
	&(cTable+"->TMP_PREFIX"):=	cSerie
	&(cTable+"->TMP_FLAGIM"):=	"1"      
	&(cTable+"->TMP_EMISSA"):=	stod(strtran(substr(dDtEmissao,1,10),"-"))
	//ZZ0->ZZ0_XMLNFE	:=	cLine 
	&(cTable+"->TMP_XMLNFA"):=	cLine
	&(cTable+"->TMP_FILE")	:=	cFile 
	&(cTable)->(Msunlock())
EndIF 

FRename(cPathL+cFile,cPathL+"\Processados\"+cFile)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  12/10/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function buscabco(fincnpj)
            
Local cQuery 
Local aRet	:=	{}
    
//cQuery := "SELECT ZZ0_DOC,ZZ0_SERIE,ZZ0_CNPJC,ZZ0_DTEMIS,R_E_C_N_O_ AS REC,LEN(ZZ0_XMLNFA) AS TAM FROM "+RetSQLName("ZZ0")+" ZZ0"
cQuery := "SELECT TMP_CHAVE,TMP_CNPJF,TMP_CNPJC,TMP_PREFIX,TMP_NUM,TMP_FLAGIM,TMP_EMISSA,LEN(TMP_XMLNFA) AS TAM,TMP_FILE"
cQuery += " FROM "+oTable:GetRealName()
cQuery += " WHERE "//TMP_CNPJC LIKE '%"+strtran(fincnpj,"-")+"' AND "
cQuery += " TMP_FLAGIM IN('1','3')"
cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                         
TCQuery cQuery New Alias "TRB"

dbSelectArea("TRB")

While !EOF()         
    Aadd(aRet,{TRB->TMP_NUM,TRB->TMP_PREFIX,TRB->TMP_CHAVE,;
		STOD(TRB->TMP_EMISSA),'',0,TRB->TAM,TRB->TMP_FILE,;
		TRB->TMP_CNPJF})
	Dbskip()
EndDo

If len(aRet) < 1
	Aadd(aRet,{'','','',ctod('//'),'',0,0,'',''})
endif              

	//ISNULL(CONVERT(VARCHAR(max), CONVERT(VARBINARY(max), ZZ0_XMLNFE)),'') AS XML,

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  12/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fhelp(nop)

Local nP 
Local nX 

If valtype(&("oListC"+cvaltochar(nop))) == "O"  
	
	cCNPJ_FOR 	:=	''
	cNomeFor 	:=	''
	cEndFor  	:=	''
	cIE_FOR  	:=	''
	cNum 		:=	''
	cSerie 		:=	''
	    
	aList1 		:= {}
	aList2 		:= {}   
	aList3 		:= {}   
	aList4 		:= {}   
	aList5 		:= {}
	aList6 		:= {}    
	aList3B		:= {}
	  
	oSay6:settext("") //CNPJ
	oSay3:settext("") //NOME
	oSay5:settext("") //ENDERECO
	oSay8:settext("") //IE    
	oSay10:settext("") //Natureza da operacao
	oSay11:settext("") //NOTA
	oSay12:settext("") //SERIE
	oSay13:settext("") //SERIE
	oSay14:settext("") //NF jแ importada
	
	&("oListC"+cvaltochar(nop)):SetArray(&("aListC"+cvaltochar(nop)))
	&("oListC"+cvaltochar(nop)):bLine := {||{&("aListC"+cvaltochar(nop))[&("oListC"+cvaltochar(nop)):nAt,01],; 
						   			&("aListC"+cvaltochar(nop))[&("oListC"+cvaltochar(nop)):nAt,02],;
		 				   			&("aListC"+cvaltochar(nop))[&("oListC"+cvaltochar(nop)):nAt,09],;
		 				   			&("aListC"+cvaltochar(nop))[&("oListC"+cvaltochar(nop)):nAt,04]}}  
	
	&("oListC"+cvaltochar(nop)):refresh()
	
	cXml := ''
	
	For nP := 1 to len(aBcoXml)
		If cvaltochar(aBcoXml[nP,01]) == cvaltochar(&("aListC"+cvaltochar(nop))[&("oListC"+cvaltochar(nop)):nAt,01])
			cXml += aBcoXml[nP,02]
		EndIF  
	Next nP
	
	Processa({|| XMLBDO(cXml)},"Aguarde...")

	oSay6:settext(Transform(cCNPJ_FOR,"@R 99.999.999/9999-9#"))
	oSay3:settext(cNomeFor)
	oSay5:settext(cEndFor)
	oSay8:settext(Transform(cIE_FOR,"@R 999.999.999.99#"))    
	oSay10:settext(cNatOp)
	oSay11:settext("Nota "+cvaltochar(cNum))
	oSay12:settext("S้rie " +cvaltochar(cSerie))
	oSay13:settext("Data de Emissใo "+cDtEmissao)
	oSay14:settext(If(lNfImp,"Nota jแ lan็ada!!!",""))
	
	For nX := 1 to len(aItensCad)
		Aadd(aList1,aItensCad[nX])	
		Aadd(aList1[len(aList1)],.F.)
		Aadd(aList1[len(aList1)],"")  //TES
		Aadd(aList1[len(aList1)],"")  //Nota origem
		Aadd(aList1[len(aList1)],"")  //Serie origem
		Aadd(aList1[len(aList1)],"")  //Item origem 
		Aadd(aList1[len(aList1)],"")  //Pedido de Compra 
		Aadd(aList1[len(aList1)],"")  //Item Pedido de Compra
		Aadd(aList1[len(aList1)],"")  //Centro de Custo PCompra

		/*
		If SUBSTR(aList1[len(aList1),08],2,3) $ cCfoDev
			lDevCmp := .T.      
			//Retorno de Beneficiamento
			If SUBSTR(aList1[len(aList1),08],2,3) $ "906"
				lRetBen := .T.
			EndIf
		EndIf
		*/
	Next nX         
	//Pedidos(cFornec,cLjFornec)

	If len(aList1) < 1
		Aadd(aList1,{"0","0","","0","0","0","0","0","","0","0","0",'','','','',.F.,'','','','','','','',''})
	Else 
		BuscaTes()
		excefis() 
	EndIf
	
	
	If len(aList2) < 1
		Aadd(aList2,{.F.,'Nใo hแ','0','0','0','0','0','0','0','0','0','0','0','0'})
	EndIF
	
	
	If len(aList3B) < 1
		Aadd(aList3,{.F.,'','','','','','','','','','','','',''}) 
	Else
		For nP := 1 to len(aList3B)
			If aList3B[nP,8] == aList2[oList2:nAt,02]
				Aadd(aList3,aList3B[nP])
			EndIf
		Next nP
	EndIF
	
	If len(aList4) < 1
		Aadd(aList4,{'','','','','','','','','','','','','','','','','','','',''})
	EndIF
	
	If len(aList5) < 1
		Aadd(aList5,{'','','','','','','','','','','','','','','','','','','',''})
	EndIF
	
	If len(aList6) < 1
		Aadd(aList6,{'','','','','','','','','','','','','','','','','','','',''})
	EndIF
	
	oList1:SetArray(aList1)
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03],;
	 					 aList1[oList1:nAt,04],; 
	 					 Transform(aList1[oList1:nAt,05],"@E 999,999.9999"),;
	 					 Transform(aList1[oList1:nAt,06],"@E 999,999.9999"),;
	 					 Transform(aList1[oList1:nAt,07],"@E 999,999.9999"),; 
	 					 aList1[oList1:nAt,08],;
	 					 aList1[oList1:nAt,09],;
	 					 aList1[oList1:nAt,10],; 
	 					 aList1[oList1:nAt,11],;
	 					 aList1[oList1:nAt,12]}}
	 					 
	oList2:SetArray(aList2)
	oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04]}}
	
	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
	 					 aList3[oList3:nAt,02],;
	 					 aList3[oList3:nAt,03],;
	 					 aList3[oList3:nAt,04],; 
	 					 aList3[oList3:nAt,05],;
	 					 aList3[oList3:nAt,06],;
	 					 aList3[oList3:nAt,07]}}
	
	oList4:SetArray(aList4)
	oList4:bLine := {||{Transform(aList4[oList4:nAt,01],"@E 999,999.99"),; 
	 					 Transform(aList4[oList4:nAt,02],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,03],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,04],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,05],"@E 999,999.99"),; 
	 					 Transform(aList4[oList4:nAt,06],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,07],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,08],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,09],"@E 999,999.99"),; 
	 					 Transform(aList4[oList4:nAt,10],"@E 999,999.99"),;
	 					 Transform(aList4[oList4:nAt,11],"@E 999,999.99")}}
	
	oList5:SetArray(aList5)
	oList5:bLine := {||{aList5[oList5:nAt,01],; 
	 					 aList5[oList5:nAt,02],;
	 					 aList5[oList5:nAt,03],;
	 					 aList5[oList5:nAt,04],;
	 					 aList5[oList5:nAt,05],; 
	 					 aList5[oList5:nAt,06],;
	 					 aList5[oList5:nAt,07],;
	 					 aList5[oList5:nAt,08],;
	 					 aList5[oList5:nAt,09],; 
	 					 aList5[oList5:nAt,10],;
	 					 aList5[oList5:nAt,11],;
	 					 aList5[oList5:nAt,12],;
	 					 aList5[oList5:nAt,13]}}
	
	oList6:SetArray(aList6)
	oList6:bLine := {||{aList6[oList6:nAt,01],; 
	 					 aList6[oList6:nAt,02],;
	 					 aList6[oList6:nAt,03],;
	 					 aList6[oList6:nAt,04],;
	 					 aList6[oList6:nAt,05],; 
	 					 aList6[oList6:nAt,06],;
	 					 aList6[oList6:nAt,07],;
	 					 aList6[oList6:nAt,08],;
	 					 aList6[oList6:nAt,09],; 
	 					 aList6[oList6:nAt,10]}}
	
	
	
	oList1:refresh()
	oList2:refresh()
	oList3:refresh()
	oList4:refresh()
	oList5:refresh()
	oList6:refresh()
	
	

	oDlg1:refresh()
EndIF

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  12/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XMLBDO(cFile)

Local cError		:= ""
Local cWarning		:= ""
Local oXml			:= NIL
Local lCadOk		:= .F.
Local cTagAnt		:= ""
Local cTagAtu		:= ""
Local lPrimeira		:= .T.
Local nX 
Local nCont 
Local nPapel

aItensCad := {}
cEspecie := "SPED"      

oXml := XmlParser( cFile, "_", @cError, @cWarning )
If (oXml == NIL )
  MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
  Return
Endif

If XmlChildEx(oXml , "_CTEPROC") != NIL
	cVersaoCTE := oXML:_CTEProc:_versao:TEXT   //oXml:_CTEPROC:_VERSAO:TEXT

	// -> Verifica se NF estแ autorizada na Sefaz
	cChave_Nfe := SubStr(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4)

	If Empty(cChave_Nfe)
		MsgAlert("A chave de acesso nใo foi informada!","XMLCTE")
		Return
	EndIf                                

	// Inicializa as variaveis de controle
	nError := 0
	cFilorig := '' //xFilial("SF1") //"XX"
	//Busca pelo cnpj do remetente pois o destinatario no CTe e o cliente que recebera a mercadoria.
	cCNPJ_FIL := oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT //oxml:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT
	aFils 	:=	{}
	//MsProcTxt("Verificando filial: " +cEmpAnt)
	OpenSm0()
	SM0->(dbGoTop())
	While !SM0->(Eof())
		If cEmpAnt != SM0->M0_CODIGO
			SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
			loop
		Endif
		
		If cCNPJ_FIL == SM0->M0_CGC
			cFilorig := SM0->M0_CODFIL
			Exit //Forca a saida
		Endif
		
		Aadd(aFils,SM0->M0_CODFIL)
		
		SM0->(dbskip())
	EndDo

	If Empty(cFilorig)
		aPergs	:= {}
		aRet 	:= {}
		
		aAdd(aPergs,{2,"Selecione a Filial de entrada","",aFils,080,'',.T.})

		If !ParamBox(aPergs ,"Filtro",aRet)
			Return	
		Else	
			cFilorig := aRet[1]
		EndIf
	EndIf

	cNatOp	:= PadR(oXml:_cteProc:_cte:_Infcte:_IDE:_NATOP:Text,45," ")

	cCNPJ_FOR := oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
	//MsProcTxt("Verificando fornecedor: " +cCNPJ_FOR)
	DBSelectArea("SA2")
	DBSetOrder(3)
	If DbSeek(xFilial("SA2")+cCNPJ_FOR)
		cFornec		:= SA2->A2_COD
		cLjFornec	:= SA2->A2_LOJA
		cEstFor		:= SA2->A2_EST
		cNomeFor	:= SA2->A2_NOME
		cForCond	:= SA2->A2_COND
		cEndFor		:= Alltrim(SA2->A2_END)+" - "+Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+cEstFor
		cIE_FOR		:= SA2->A2_INSCR
	Else
		MsgAlert(OemToAnsi("Fornecedor inexistente! " + cCNPJ_FOR +CRLF))
	Endif

	cNum	:= PadL(Alltrim(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT),9,"0") //Nro da Nota
	cSerie	:= PadR(oXml:_CTEProc:_CTE:_InfCTE:_IDE:_Serie:Text,3," ")


	// -> Verifica se jแ existe essa NF na base de dados
	//MsProcTxt("Verificando exist๊ncia da Nota Fiscal: " +cNum)
	DBSelectArea("SF1")
	DbSetorder(1)
	If DbSeek(cFilorig+AvKey(cNum,"F1_DOC")+AvKey(cSerie,"F1_SERIE")+AvKey(cFornec,"F1_FORNECE")+AvKey(cLjFornec,"F1_LOJA")+AvKey(cTipo,"F1_TIPO")/*,.T.*/)
		If lExecMenu
			Alert(OemToAnsi("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."))
			GeraLog("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."  +CRLF)
			FClose(nHdl)
			Return()
		Else
			ConOut("Nao importada. Nota Fiscal jแ consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
			GeraLog("Nao importada. Nota Fiscal jแ consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
			FClose(nHdl)
			Return()
		EndIf
	EndIf     

	cDtEmissao	:= oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_dhEmi:Text

	cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)
				
	cNumTitulo      := cNum
	nTotalMerc      := Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)

	cVencimento := ""  

	If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC, "_INFNFE" ) != Nil
		If Valtype(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE) <> "A"
			cChvNFS := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
			aItemNF := {} //BuscNFT(cChvNFS,'')   
		Else
			aChaves := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
			cBarra := ''
			cChvNFS:= ''
			For nPapel := 1 to len(aChaves)
				cChvNFS += cBarra + aChaves[nPapel]:_CHAVE:TEXT
				cBarra := "','"
			Next nPapel
			
			aItemNF 	:= {} //BuscNFT(cChvNFS,'')
			
		EndIF
	Else
									
		cNfs	:=	space(150)
		aAdd(aPergs ,{1,"Numero das NFs?"			,cNfs   ,'',"","","",120,.F.})

		If !ParamBox(aPergs ,"Filtro",aRet)
			Return	
		Else
			aItemNF := {} //BuscNFT('',aRet[1])
		EndIf
	EndIf

	nFrete := 0
	nSeguro := 0
	nIcmsSubs := 0
		
	aAdd(aItensCad, {'01','FRETE','FRETE','FRETE',1,nTotalMerc,nTotalMerc,'cfop','ncm','cund','outro','cest',cNum,cSerie,'seguro',0})

ELSE
	If XmlChildEx(oXml , "_NFEPROC") != Nil
		cVersaoNFE := oXML:_nfeProc:_versao:TEXT

		// -> Verifica se NF estแ autorizada na Sefaz
		cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)

		If Empty(cChave_NFe)
			MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
			Return
		EndIf   


		// Se a Tag NFEPROC:NFE:INFNFE:_DET for Objeto
		If ValType(oXml:_NfeProc:_Nfe:_InfNfe:_DET) = "O"
			XmlNode2Arr(oXml:_NfeProc:_Nfe:_InfNfe:_DET, "_DET")
		EndIf

		// Gera Array com os dados dos produtos do XML
		aItensXML	:= oXML:_nfeProc:_NFe:_infNFe:_Det
		aItensXML	:= IIf(ValType(aItensXML)=="O", {aItensXML}, aItensXML)
	ELSE
		
		cVersaoNFE := oXML:_NFE:_INFNFE:_versao:TEXT

		// -> Verifica se NF estแ autorizada na Sefaz
		cChave_NFe := SubStr(oxml:_NFE:_INFNFE:_ID:TEXT,4)

		If Empty(cChave_NFe)
			MsgAlert("A chave de acesso nใo foi informada!","XMLNFE")
			Return
		EndIf   


		// Se a Tag NFEPROC:NFE:INFNFE:_DET for Objeto
		If ValType(oXml:_Nfe:_InfNfe:_DET) = "O"
			XmlNode2Arr(oXml:_Nfe:_InfNfe:_DET, "_DET")
		EndIf

		// Gera Array com os dados dos produtos do XML
		aItensXML	:= oXML:_NFe:_infNFe:_Det
		aItensXML	:= IIf(ValType(aItensXML)=="O", {aItensXML}, aItensXML)
	ENDIF

	If Len(aItensXML) == 0
		MsgAlert("Erro na estrutura dos Itens do arquivo XML!", "XMLNfe")
		Return
	EndIf

	// Inicializa as variaveis de controle
	nError := 0
	//cFilorig := "XX"


	//OpenSm0()
	SM0->(dbGoTop())
	While !SM0->(Eof())
		If cEmpAnt != SM0->M0_CODIGO
			SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
			loop
		Endif
		
		If cCNPJ_FIL == SM0->M0_CGC
			cFilorig := SM0->M0_CODFIL
			Exit //Forca a saida
		Endif
		
		SM0->(dbskip())
	EndDo

	//cFilant := cFilorig
	//Opensm0(cempant+cFilant)
	//Openfile(cempant+cFilant)


	If XmlChildEx(oXml , "_NFEPROC") != Nil
		If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT , "_CNPJ" ) != Nil
			cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
		Else
			cCNPJ_FOR := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CPF:TEXT
		EndIf
		//Verificando fornecedor: " +cCNPJ_FOR)                  
		cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
		cSerie	:= STRZero(val(Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)
		cNatOp	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_NATOP:Text,45," ")


		//cnpj
		If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_DEST , "_CNPJ" ) != NIL
			cCNPJ_FIL := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
		else
			cCNPJ_FIL := cCNPJ_FOR
		EndIf 
	else
		
		If XmlChildEx( oXml:_NFE:_INFNFE:_EMIT , "_CNPJ" ) != Nil
			cCNPJ_FOR := oxml:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
		Else
			cCNPJ_FOR := oxml:_NFE:_INFNFE:_EMIT:_CPF:TEXT
		EndIf
		//Verificando fornecedor: " +cCNPJ_FOR)                  
		cNum	:= PadL(Alltrim(oXml:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
		cSerie	:= STRZero(val(Alltrim(oXml:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)
		cNatOp	:= PadR(oXml:_Nfe:_InfNfe:_IDE:_NATOP:Text,45," ")


		//cnpj
		If XmlChildEx( oXml:_NFE:_INFNFE:_DEST , "_CNPJ" ) != NIL
			cCNPJ_FIL := oxml:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
		else
			cCNPJ_FIL := cCNPJ_FOR
		EndIf 
	ENDIF

	DBSelectArea("SA2")
	DBSetOrder(3)
	If DbSeek(xFilial("SA2")+cCNPJ_FOR) .And. !"DEV" $ cNatOp
		cFornec		:= SA2->A2_COD
		cLjFornec	:= SA2->A2_LOJA
		cEstFor		:= SA2->A2_EST
		cNomeFor	:= SA2->A2_NOME
		cForCond	:= SA2->A2_COND  
		cEndFor		:= Alltrim(SA2->A2_END)+" - "+Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+cEstFor
		cIE_FOR		:= SA2->A2_INSCR
	Else 
		If "DEV" $ cNatOp
			DbSelectArea("SA1")
			DbSetOrder(3)
			If Dbseek(xFilial("SA1")+cCNPJ_FOR)
				cFornec		:= SA1->A1_COD
				cLjFornec	:= SA1->A1_LOJA
				cEstFor		:= SA1->A1_EST
				cNomeFor	:= SA1->A1_NOME
				cForCond	:= SA1->A1_COND  
				cEndFor		:= Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+cEstFor
				cIE_FOR		:= SA1->A1_INSCR
			EndIf
		Else
			MSGALERT("Fornecedor inexistente!" + cCNPJ_FOR +CRLF) 
			cFornec		:= 'XXXXXX'
			cLjFornec	:= 'XX'
			cEstFor		:= SA2->A2_EST
			If XmlChildEx(oXml , "_NFEPROC") != Nil
				cNomeFor	:= UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_XNOME:TEXT)+" / "+ If(XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_EMIT , "_XFANT" ) != Nil,UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_XFANT:TEXT),"")
				cEndFor		:= UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XLGR:TEXT)+", "+oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_NRO:TEXT+" - "+UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)+" - "+UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XMUN:TEXT)+" - "+UPPER(oXml:_NfeProc:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_UF:TEXT)
				cIE_FOR		:= oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_IE:TEXT
			else
				cNomeFor	:= UPPER(oXml:_Nfe:_InfNfe:_EMIT:_XNOME:TEXT)+" / "+ If(XmlChildEx( oXml:_NFE:_INFNFE:_EMIT , "_XFANT" ) != Nil,UPPER(oXml:_Nfe:_InfNfe:_EMIT:_XFANT:TEXT),"")
				cEndFor		:= UPPER(oXml:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XLGR:TEXT)+", "+oXml:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_NRO:TEXT+" - "+UPPER(oXml:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)+" - "+UPPER(oXml:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_XMUN:TEXT)+" - "+UPPER(oXml:_Nfe:_InfNfe:_EMIT:_ENDEREMIT:_UF:TEXT)
				cIE_FOR		:= oxml:_NFE:_INFNFE:_EMIT:_IE:TEXT
			EndIf

			cForCond	:= '' //SA2->A2_COND  
				
		EndIf
	Endif

	DBSelectArea("SF1")
	DbSetorder(1)
	If DbSeek(xFilial("SF1")+AvKey(cNum,"F1_DOC")+AvKey(cSerie,"F1_SERIE")+AvKey(cFornec,"F1_FORNECE")+AvKey(cLjFornec,"F1_LOJA")+AvKey(If(substr(cNatOp,1,3) $ "DEV/RET",If(substr(cNatOp,1,3)<>"RET","D","B"),cTipo),"F1_TIPO")/*,.T.*/)
		//MsgAlert(OemToAnsi("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."))
		MSGALERT("A Nota Fiscal " +cNum +"/" +cSerie +" jแ consta no sistema."  +CRLF)  
		lNfImp := .T.
		FRename(cPathL+cFile, cPathL+"\Processados\"+strtran(upper(cFile),".XML",".PROC"))
	Else 
		lNfImp := .F.
	EndIf 

	If XmlChildEx(oXml , "_NFEPROC") != Nil
		nNumItens	:= Len(oXml:_NfeProc:_Nfe:_InfNfe:_DET)

		If cVersaoNFE == "2.00"                                   
			cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dEmi:Text
		Else
			cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
		EndIf

		cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)

		//Base ICMS
		nBaseIcm	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:Text)
		//Valor ICMS
		nVlrIcm		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:Text)
		// Valor Mercadorias
		nTotalMerc	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text)  
		//Base ST
		nBaseSt		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:Text)	
		// -> Inicializa a variavel para realizar o somatorio de descontos da nota.
		nDescNota	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
		//Valor IPI
		nVlrIPI 	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:Text)

		cNumTitulo      := cNum
		nValor          := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)

		If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
			nAcrescimo := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
		Else
			nAcrescimo := 0
		Endif

		cVencimento := ""

		If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE , "_COBR" ) != Nil
		// Voltar mas tem que alterar para aceitar varias parcelas.   
			aVencimento := {}
			If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_COBR,"_DUP" ) != Nil 
				If Valtype(oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP) <> "A"
					If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP,"_DVENC" ) != Nil
						cVencimento	:= oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP:_DVENC:Text
						cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
						nDiasDp := Cvaltochar(Ctod(cVencimento) - Ctod(cDtEmissao))
						Aadd(aVencimento,cVencimento)
					EndIF
				Else
					aAuxV := oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP
					cBarra := "'%"
					For nX := 1 to len(aAuxV)
						cVencimento := aAuxV[nX]:_DVENC:TEXT  
						cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
						nDias := Ctod(cVencimento) - Ctod(cDtEmissao)
						nDiasDp += cBarra + cvaltochar(nDias)
						cBarra := ","
						Aadd(aVencimento,cVencimento)
					Next nX	
					nDiasDp += "%'"
				EndIf
				CondPag()
			EndIf
		EndIf

		nFrete	:= val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)

		nSeguro	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)
		//Valor ST
		nIcmsSubs	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
	else
		nNumItens	:= Len(oXml:_Nfe:_InfNfe:_DET)

		If cVersaoNFE == "2.00"                                   
			cDtEmissao	:= oXml:_NFE:_INFNFE:_IDE:_dEmi:Text
		Else
			cDtEmissao	:= oXml:_NFE:_INFNFE:_IDE:_dhEmi:Text
		EndIf

		cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)

		//Base ICMS
		nBaseIcm	:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:Text)
		//Valor ICMS
		nVlrIcm		:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:Text)
		// Valor Mercadorias
		nTotalMerc	:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text)  
		//Base ST
		nBaseSt		:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:Text)	
		// -> Inicializa a variavel para realizar o somatorio de descontos da nota.
		nDescNota	:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
		//Valor IPI
		nVlrIPI 	:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:Text)

		cNumTitulo      := cNum
		nValor          := Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)

		If XmlChildEx( oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
			nAcrescimo := Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
		Else
			nAcrescimo := 0
		Endif

		cVencimento := ""

		If XmlChildEx( oXml:_NFE:_INFNFE , "_COBR" ) != Nil
		// Voltar mas tem que alterar para aceitar varias parcelas.   
			aVencimento := {}
			If XmlChildEx( oXml:_NFE:_INFNFE:_COBR,"_DUP" ) != Nil 
				If Valtype(oXml:_NFE:_INFNFE:_COBR:_DUP) <> "A"
					If XmlChildEx( oXml:_NFE:_INFNFE:_COBR:_DUP,"_DVENC" ) != Nil
						cVencimento	:= oXml:_NFE:_INFNFE:_COBR:_DUP:_DVENC:Text
						cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
						nDiasDp := Cvaltochar(Ctod(cVencimento) - Ctod(cDtEmissao))
						Aadd(aVencimento,cVencimento)
					EndIF
				Else
					aAuxV := oXml:_NFE:_INFNFE:_COBR:_DUP
					cBarra := "'%"
					For nX := 1 to len(aAuxV)
						cVencimento := aAuxV[nX]:_DVENC:TEXT  
						cVencimento	:= Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
						nDias := Ctod(cVencimento) - Ctod(cDtEmissao)
						nDiasDp += cBarra + cvaltochar(nDias)
						cBarra := ","
						Aadd(aVencimento,cVencimento)
					Next nX	
					nDiasDp += "%'"
				EndIf
				CondPag()
			EndIf
		EndIf

		nFrete	:= val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)

		nSeguro	:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)
		//Valor ST
		nIcmsSubs	:= Val(oXml:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
	EndIf
	
	Aadd(aList4,{nBaseIcm,nVlrIcm,nBaseSt,nIcmsSubs,nTotalMerc,nFrete,nSeguro,nDescNota,nAcrescimo,nVlrIPI,nValor}) 
							
	// Verifica Produtos - amarra็ใo
	lCadOk	:= ValProd(cFornec, cLjFornec, aItensXML)
ENDIF

nItem	:= 0
aCabec	:= {}
aItens	:= {}
aLinha	:= {}

lExistArq	:= .F.
lIniLog		:= .F.
	
Return                


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  12/11/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function bcoxml(aRet)

Local nX 
	
For nX := 1 to len(aRet)
	nTam := aRet[nX,07] 
	nFim := 8000
	nIni := 1
	While nTam > 0
		cQuery := "SELECT ISNULL(CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), SUBSTRING(TMP_XMLNFA,"+cvaltochar(nIni)+","+cvaltochar(nFim)+"))),'') AS XML"
		cQuery += " FROM "+oTable:GetRealName()
		cQuery += " WHERE TMP_CHAVE='"+cvaltochar(aRet[nX,03])+"'"  

		cQuery := ChangeQuery(cQuery)

		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf
		                         
		TCQuery cQuery New Alias "TRB"
		
		dbSelectArea("TRB")    
		
		Aadd(aBcoxml,{aRet[nX,01],Alltrim(TRB->XML)})
		nTam := nTam - 8000
		nIni += 8000
	EndDo
Next nX

Return

Static Function functr(noptico)


Return

/*/{Protheus.doc} CriaTemp
	(long_description)
	@type  Static Function
	@author user
	@since 22/12/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function CriaTemp()

Local aArea := GetArea()

// Instancio o objeto
oTable  := FwTemporaryTable():New('TRBXML')
 
aCpoData := {}
 
// Crio com array com os campos da tabela
aAdd(aCpoData, {'TMP_CHAVE' , TamSx3('F1_CHVNFE')[3]    , TamSx3('F1_CHVNFE')[1]    , 0})
aAdd(aCpoData, {'TMP_CNPJF'	, TamSx3('A2_CGC')[3]   	, TamSx3('A2_CGC')[1]   	, 0})
aAdd(aCpoData, {'TMP_CNPJC' , TamSx3('A2_CGC')[3]      	, TamSx3('A2_CGC')[1]      	, 0})
aAdd(aCpoData, {'TMP_PREFIX', TamSx3('F1_SERIE')[3]   	, TamSx3('F1_SERIE')[1]   	, 0})
aAdd(aCpoData, {'TMP_NUM'   , TamSx3('F1_DOC')[3]       , TamSx3('F1_DOC')[1]       , 0})
aAdd(aCpoData, {'TMP_FLAGIM', 'C'					    , 1						    , 0})
aAdd(aCpoData, {'TMP_EMISSA', TamSx3('F1_EMISSAO')[3]   , TamSx3('F1_EMISSAO')[1]   , 0})
aAdd(aCpoData, {'TMP_XMLNFA', 'M'					    , 80000	 				    , 0})
aAdd(aCpoData, {'TMP_FILE'	, 'C'					    , 150	 				    , 0})
 
// Adiciono os campos na tabela
oTable:SetFields(aCpoData)
 
// Adiciono os ํndices da tabela
oTable:AddIndex('01', {'TMP_CHAVE'})
//oTable:AddIndex('02', {'TMP_FILIAL','TMP_CLIENT','TMP_LOJA'})
 
// Crio a tabela no banco de dados
oTable:Create()

RestArea(aArea)

Return(oTable)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIXML   บAutor  ณMicrosiga           บ Data ณ  04/01/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Linhas editaveis                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function outritm(nLinha)

Local aArea		:=	GetArea()
Local lProd 	:=	.F.
Local cBkp		:=	aList1[nLinha,03]
Local nCont		:=	0	

If !Empty(cBkp)
	lProd := .T.
EndIf
	
	//Usuario pressionou o ok
If lProd	
	cCodP := ''
	cCodT := ''

	DbSelectArea("SB1")
	DbSetOrder(1)
	If Dbseek(xFilial("SB1")+cBkp)
		cCodP  := SB1->B1_COD
		cCodT  := SB1->B1_TE
	EndIf
	//aList1[oList1:nAt,03] := SB1->B1_COD
	//aList1[oList1:nAt,18] := SB1->B1_TE	//TES padrao de entrada cadastrada no produto - levar para o campo D1_TESACLA
	
	For nCont := nLinha+1 to len(aList1)
		dbSelectArea("SA5")
		dbSetOrder(2)
		
		RecLock("SA5",.T.)
		SA5->A5_FILIAL     := xFilial("SA5")
		SA5->A5_FORNECE    := cFornec
		SA5->A5_LOJA       := cLjFornec
		SA5->A5_NOMEFOR    := Posicione("SA2",1,xFilial("SA2")+cFornec+cLjFornec,"A2_NOME")
		SA5->A5_PRODUTO    := cBkp
		SA5->A5_NOMPROD    := Posicione("SB1",1,xFilial("SB1")+cBkp,"B1_DESC")
		SA5->A5_CODPRF     := aList1[nCont,02]
		SA5->A5_REFGRD	   := aList1[nCont,02]
		SA5->(MSUnLock())

		aList1[nCont,03]	:=	cCodP
		aList1[nCont,18]	:=  cCodT

	Next nCont
	
EndIf

oList1:refresh()
oDlg1:refresh()        

RestArea(aArea)

Return
