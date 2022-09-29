#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0102   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HIT0102()

Local oReport 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInterface de impressao                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport	:= ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0102   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

Local oReport,oSection1,oSection2
Local cReport := "HIT0102"
Local cTitulo := OemToAnsi("Compras por Fornecedor") 
Local cDescri := OemToAnsi("Este programa imprimir  la demsotraciขn contable de Vendedores.")+" "+OemToAnsi("Se puede  emitir  todo  el movimiento de los ")
Local nTamCli:= TamSx3("A2_NOME")[1] 
Pergunte( "HIT102X" , .F. )
                   
oReport  := TReport():New( cReport, cTitulo, "HIT102X" , { |oReport| ReportPrint( oReport, "TRB" ) }, cDescri )
oReport:SetLandScape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a 1a. secao do relatorio Valores nas Moedas   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oSection1 := TRSection():New( oReport,"Codigo" , {"TRB","SA2"},{"Codigo Fornecedor","Nome Fornecedor"},/*Campos do SX3*/,/*Campos do SIX*/)                      //"Cliente"
 
oSection2 := TRSection():New( oSection1,"Compras por Fornecedor" , {"TRB","SD1"} ) //
TRCell():New( oSection2, "CAMPO01","" ,/*X3Titulo*/ ,/*Picture*/,TamSx3("D1_FORNECE")[1],/*lPixel*/,{||TRB->CAMPO01})
TRCell():New( oSection2, "CAMPO02","" ,/*X3Titulo*/ ,/*Picture*/,TamSx3("A2_NOME")[1],/*lPixel*/,{||TRB->CAMPO02})	

TRCell():New( oSection2, "CAMPO03","" , /*X3Titulo()*/,PesqPict("SD1","D1_COD")/*Picture*/		,25,/*lPixel*/,{||TRB->CAMPO03 })
TRCell():New( oSection2, "CAMPO04","" , /*X3Titulo()*/,PesqPict("SB1","B1_DESC")/*Picture*/	,35,/*lPixel*/,{||TRB->CAMPO04 })
TRCell():New( oSection2, "CAMPO05","" , /*X3Titulo()*/,PesqPict("SD1","D1_QUANT")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO05 })
TRCell():New( oSection2, "CAMPO06","" , /*X3Titulo()*/,PesqPict("SD1","D1_UM")/*Picture*/		,15,/*lPixel*/,{||TRB->CAMPO06 })
TRCell():New( oSection2, "CAMPO07","" , /*X3Titulo()*/,PesqPict("SD1","D1_TOTAL")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO07 })

oSection2:Cell("CAMPO01"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO02"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO03"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO04"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO05"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO06"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO07"):lHeaderSize	:=	.T.

Return oReport
                                                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0102   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint( oReport )

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)         
Local oBreak1 
Local nOrder	:=oReport:Section(1):GetOrder()
Local cIndice	:=	""
Local CbCont,CbTxt
Local nQuebra:=0,lImprAnt := .F.
Local cNome

Local	nVlCli01	   
Local	nVlCli02	   
Local	nVlCli03	   
Local	nVlCli04	   
Local	nVlCli05	   
Local	nVlCli06	  
Local	nVlCli07	   
Local 	nQtdTot		:=	0
Local 	nVlrTot		:=	0
            
Private aCampos	:=	{}
Private cNomeArq

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao dos cabecalhos                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Titulo := OemToAnsi("Compras por Fornecedor") //
Titulo += Space(1)
//Titulo += OemToAnsi(" Emissใo De: ")+DTOC(dFechaIni)+OemToAnsi("  At้ : ")+DTOC(dFechaFim)  //###

AADD(aCampos,{"CAMPO01","C",TamSx3('D1_FORNECE')[1],0})
AADD(aCampos,{"CAMPO02","C",TamSx3('A2_NOME')[1],0})
AADD(aCampos,{"CAMPO03","C",TamSX3('D1_COD')[1],0})
AADD(aCampos,{"CAMPO04","C",TamSX3('B1_DESC')[1],0})
AADD(aCampos,{"CAMPO05","N",15,2})
AADD(aCampos,{"CAMPO06","C",TamSX3('D1_UM')[1],0})
AADD(aCampos,{"CAMPO07","N",15,2})

cNomeArq  := CriaTrab(aCampos)

dbUseArea( .T., __cRDDNTTS, cNomeArq,"TRB", if(.F. .Or. .F., !.F., NIL), .F. )
If nOrder	==	1
	cIndice	:=	"CAMPO01"
Endif
IndRegua("TRB",cNomeArq,cIndice,,,OemToAnsi("Selecionando Registros..."))  //

Processa({|lEnd| GeraTra(oSection1:GetAdvplExp('SD2'),oSection1:GetAdvplExp('SA3'))},,OemToAnsi("Preparando Transitขrio..."))  //

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia rotina de impressao                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbGoTop()


oSection2:SetParentFilter({|cParam| TRB->CAMPO01+TRB->CAMPO02 == cParam },{||SA3->A3_COD+SA3->A3_NOME}) 

	//Totalizadores
	TRFunction():New(oSection2:Cell("CAMPO01")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO02")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO03")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO04")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO05")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO06")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO07")	, ,"SUM", , , , , .F. ,)
	
	//oculta
	
	//Define valores para as secoes
	oSection2:Cell("CAMPO01"):SetBlock({|| nVlCli01 })
	oSection2:Cell("CAMPO02"):SetBlock({|| nVlCli02 })
	oSection2:Cell("CAMPO03"):SetBlock({|| nVlCli03 })
	oSection2:Cell("CAMPO04"):SetBlock({|| nVlCli04 })
	oSection2:Cell("CAMPO05"):SetBlock({|| nVlCli05 })
	oSection2:Cell("CAMPO06"):SetBlock({|| nVlCli06 })
	oSection2:Cell("CAMPO07"):SetBlock({|| nVlCli07 })
	
oSection1:SetOrder(1) 
oSection1:SetTotalInLine(.T.)
oReport:SetTotalInLine(.F.)

Trposition():New(oSection1,"SF2",1,{|| "Compras por Fornecedor"})  
//Trposition():New(oSection1,"SA3",1,{|| xFilial('SA3')+TRB->NOME} )  

oSection2:SetLineCondition({||&cImpSldChq})
oSection2:Cell("CAMPO01"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Numero Fornecedor")  ) //
oSection2:Cell("CAMPO02"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Nome Fornecedor")  ) 
oSection2:Cell("CAMPO03"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Codigo Produto")  )
oSection2:Cell("CAMPO04"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Nome Produto")  )
oSection2:Cell("CAMPO05"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Qtd Comprada")  )
oSection2:Cell("CAMPO06"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Unidade")  )
oSection2:Cell("CAMPO07"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Valor Total")  )

oSection2:SetHeaderPage()

oReport:SetTitle(titulo)

oReport:SetMeter(RecCount())
dbSelectArea("TRB")
DbGotop()

oSection1:Init() 
nTotCheque:=0
While !TRB->(EOF())  
 	oSection2:Init()
		nVlCli01	   := ''
		nVlCli02	   := ''
		nVlCli03	   := ''
		nVlCli04	   := ''
		nVlCli05	   := 0
		nVlCli06	   := ''
		nVlCli07	   := 0
		nVlrTot		   := 0
		nQtdTot		   := 0
	cCliente:=TRB->CAMPO01+TRB->CAMPO02
   While cCliente==TRB->CAMPO01+TRB->CAMPO02  .And. !TRB->(EOF())
		oReport:IncMeter()    	
			nVlCli01	   := TRB->CAMPO01
			nVlCli02	   := TRB->CAMPO02
			nVlCli03	   := TRB->CAMPO03
			nVlCli04	   := TRB->CAMPO04
			nVlCli05	   := TRB->CAMPO05
			nVlCli06	   := TRB->CAMPO06
			nVlCli07	   := TRB->CAMPO07
			nQtdTot		   += TRB->CAMPO05
			nVlrTot        += TRB->CAMPO07
	   		oSection2:PrintLine()	
  		Dbskip()
  	EndDo               
  	//If mv_par05 == 2 //Sintetico
  		//oSection2:PrintLine()
  	//EndIf
  	oReport:PrintText(OemToAnsi("TOTAIS") + Space(112)+ Transf(nQtdTot,"@E 999,999,999.99") + Space(16) +Transf(nVlrTot,PesqPict("SD1","D1_TOTAL")))
  	oSection2:Finish()	
	oReport:ThinLine()
	
EndDo     
                                       

oSection1:Finish()		

dbSelectArea("TRB")
dbCloseArea()

Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())	 // Elimina arquivos de indice a partir do arquivo Trabalho

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0102   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraTra(cFltSE1,cFltSA1)

Local nDebito := 0.00
Local nCredito := 0.00
Local nPosTip
Local cTipos 		:=	""
Local nTaxa:= 0     
Local aTotG	:=	{}
Local cQuery 


nCount := 1000
/*
cQuery := "SELECT F2_VEND1 AS CODIGO,A3_NOME AS NOME,D2_COD AS PRODUTO,B1_DESC AS DESCRICAO,SUM(D2_QUANT) AS QTD,D2_UM AS UM,SUM(D2_VALBRUT) AS VALOR"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SF2")+" F2 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND F2.D_E_L_E_T_<>'*'"
cQuery += " 	AND F2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"
cQuery += "		AND F2_VEND1 BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD=F2_VEND1 AND A3.D_E_L_E_T_<>'*'"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_<>'*'"
cQuery += " 	AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"
cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"
cQuery += " AND D2.D_E_L_E_T_<>'*'"
cQuery += " GROUP BY F2_VEND1,A3_NOME,D2_COD,B1_DESC,D2_UM"
*/

cQuery := "SELECT D1_FORNECE AS CODIGO,A2_NOME AS NOME,D1_COD AS PRODUTO,B1_DESC AS DESCRICAO,D1_QUANT AS QTD,D1_UM AS UM,D1_TOTAL AS VALOR"
cQuery += "  FROM "+RetSQLName("SD1")+" D1"
cQuery += "  INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_COD=D1_FORNECE AND A2.D_E_L_E_T_<>'*'"
cQuery += "  INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D1_COD AND B1.D_E_L_E_T_<>'*'"
cQuery += "  WHERE D1_DTDIGIT BETWEEN '20120202' AND '20120202'"
cQuery += "  AND D1_FORNECE BETWEEN '000005' AND '000900'"
cQuery += "  AND D1_TIPO<>'D'"
cQuery += "  AND D1.D_E_L_E_T_<>'*'"

	If Select('QUERY') > 0
		dbSelectArea('QUERY')
		dbCloseArea()
	EndIf
	
	MemoWrite("HIT0102.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )
	

	DbSelectArea( "QUERY" )  
	While !EOF()
                      
		IncProc(OemtoAnsi("Procesando Fornecedor ")+Subst(QUERY->NOME,1,27))  //""

		RecLock("TRB",.T.)
		TRB->CAMPO01    	:= 	QUERY->CODIGO
		TRB->CAMPO02      	:= 	QUERY->NOME
		TRB->CAMPO03   		:= 	QUERY->PRODUTO
		TRB->CAMPO04  		:=	QUERY->DESCRICAO
		TRB->CAMPO05  		:= 	QUERY->QTD                              
		TRB->CAMPO06		:= 	QUERY->UM
		TRB->CAMPO07	   	:= 	QUERY->VALOR
		TRB->(MsUnLock())
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo

Return