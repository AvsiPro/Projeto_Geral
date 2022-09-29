#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0101   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HIT0101()

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
ฑฑบPrograma  ณHIT0101   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
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
Local cReport := "HIT0101"
Local cTitulo := OemToAnsi("Vendas Por Cliente") 
Local cDescri := OemToAnsi("Este programa imprimir  la demsotraciขn contable de Vendedores.")+" "+OemToAnsi("Se puede  emitir  todo  el movimiento de los ")
Local nTamCli:= TamSx3("A3_NOME")[1] 
Pergunte( "HIT101X" , .F. )
                   
oReport  := TReport():New( cReport, cTitulo, "HIT101X" , { |oReport| ReportPrint( oReport, "TRB" ) }, cDescri )
oReport:SetLandScape()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a 1a. secao do relatorio Valores nas Moedas   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oSection1 := TRSection():New( oReport,"Codigo" , {"TRB","SA1"},{"Codigo Cliente","Nome Cliente"},/*Campos do SX3*/,/*Campos do SIX*/)                      //"Cliente"
//D2_CLIENTE,A1_NOME,E1_NUM,E1_EMISSAO,'SALES ID',D2_ITEM,B1_DESC,'REASON',D2_PRUNIT,D2_QUANT,D2_VALBRUT,B1_CUSTD 
oSection2 := TRSection():New( oSection1,"Notas por Cliente" , {"TRB","SD2"} ) //
TRCell():New( oSection2, "CAMPO01","" ,/*X3Titulo*/ ,/*Picture*/,TamSx3("D2_CLIENTE")[1],/*lPixel*/,{||TRB->CAMPO01})
TRCell():New( oSection2, "CAMPO02","" ,/*X3Titulo*/ ,/*Picture*/,TamSx3("A1_NOME")[1],/*lPixel*/,{||TRB->CAMPO02})	

TRCell():New( oSection2, "CAMPO03","" , /*X3Titulo()*/,PesqPict("SE1","E1_NUM")/*Picture*/		,15,/*lPixel*/,{||TRB->CAMPO03 })
TRCell():New( oSection2, "CAMPO04","" , /*X3Titulo()*/,PesqPict("SE1","E1_EMISSAO")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO04 })
TRCell():New( oSection2, "CAMPO05","" , /*X3Titulo()*/,PesqPict("SD2","D2_DOC")/*Picture*/		,15,/*lPixel*/,{||TRB->CAMPO05 })
TRCell():New( oSection2, "CAMPO06","" , /*X3Titulo()*/,PesqPict("SD2","D2_ITEM")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO06 })
TRCell():New( oSection2, "CAMPO07","" , /*X3Titulo()*/,PesqPict("SB1","B1_DESC")/*Picture*/	,45,/*lPixel*/,{||TRB->CAMPO07 })

TRCell():New( oSection2, "CAMPO08","" , /*X3Titulo()*/,SPACE(20)		/*Picture*/				,20,/*lPixel*/,{||TRB->CAMPO08 })
TRCell():New( oSection2, "CAMPO09","" , /*X3Titulo()*/,PesqPict("SD2","D2_PRUNIT")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO09 })
TRCell():New( oSection2, "CAMPO10","" , /*X3Titulo()*/,PesqPict("SD2","D2_QUANT")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO10 })
TRCell():New( oSection2, "CAMPO11","" , /*X3Titulo()*/,PesqPict("SD2","D2_VALBRUT")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO11 })
TRCell():New( oSection2, "CAMPO12","" , /*X3Titulo()*/,PesqPict("SB1","B1_CUSTD")/*Picture*/	,15,/*lPixel*/,{||TRB->CAMPO12 })

oSection2:Cell("CAMPO01"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO02"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO03"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO04"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO05"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO06"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO07"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO08"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO08"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO10"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO11"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO12"):lHeaderSize	:=	.T.

Return oReport
                                                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0101   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
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
Local	nVlCli08	   
Local	nVlCli09	   
Local	nVlCli10	   
Local	nVlCli11	   
Local	nVlCli12	   
Local 	nTot1		:=	0
Local 	nTot2		:=	0
Local 	nTot3		:=	0
            
Private aCampos	:=	{}
Private cNomeArq

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Definicao dos cabecalhos                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Titulo := OemToAnsi("Vendor Item Statistics") //
Titulo += Space(1)
//Titulo += OemToAnsi(" Emissใo De: ")+DTOC(dFechaIni)+OemToAnsi("  At้ : ")+DTOC(dFechaFim)  //###
//D2_CLIENTE,A1_NOME,E1_NUM,E1_EMISSAO,'SALES ID',D2_ITEM,B1_DESC,'REASON',D2_PRUNIT,D2_QUANT,D2_VALBRUT,B1_CUSTD 
AADD(aCampos,{"CAMPO01","C",TamSx3('D2_CLIENTE')[1],0})
AADD(aCampos,{"CAMPO02","C",TamSx3('A1_NOME')[1],0})
AADD(aCampos,{"CAMPO03","C",TamSX3('E1_NUM')[1],0})
AADD(aCampos,{"CAMPO04","C",TamSX3('E1_EMISSAO')[1],0})
AADD(aCampos,{"CAMPO05","C",TamSX3('D2_DOC')[1],0})
AADD(aCampos,{"CAMPO06","C",TamSX3('D2_ITEM')[1],0})
AADD(aCampos,{"CAMPO07","C",TamSX3('B1_DESC')[1],0})
AADD(aCampos,{"CAMPO08","C",TamSX3('D2_ITEM')[1],0})
AADD(aCampos,{"CAMPO09","N",TamSX3('D2_PRUNIT')[1],2})
AADD(aCampos,{"CAMPO10","N",TamSX3('D2_QUANT')[1],2})
AADD(aCampos,{"CAMPO11","N",TamSX3('D2_VALBRUT')[1],2})
AADD(aCampos,{"CAMPO12","N",TamSX3('B1_CUSTD')[1],2})






cNomeArq  := CriaTrab(aCampos)

dbUseArea( .T., __cRDDNTTS, cNomeArq,"TRB", if(.F. .Or. .F., !.F., NIL), .F. )
If nOrder	==	1
	cIndice	:=	"CAMPO01"
Endif
IndRegua("TRB",cNomeArq,cIndice,,,OemToAnsi("Selecionando Registros..."))  //

Processa({|lEnd| GeraTra(oSection1:GetAdvplExp('SD2'),oSection1:GetAdvplExp('SA1'))},,OemToAnsi("Preparando Transitขrio..."))  //

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia rotina de impressao                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbGoTop()


oSection2:SetParentFilter({|cParam| TRB->CAMPO01+TRB->CAMPO02 == cParam },{||SA1->A1_COD+SA1->A1_NOME}) 

	//Totalizadores
	TRFunction():New(oSection2:Cell("CAMPO01")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO02")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO03")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO04")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO05")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO06")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO07")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO08")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO09")	, ,"", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO10")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO11")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("CAMPO12")	, ,"SUM", , , , , .F. ,)

	//oculta
	
	//Define valores para as secoes
	oSection2:Cell("CAMPO01"):SetBlock({|| nVlCli01 })
	oSection2:Cell("CAMPO02"):SetBlock({|| nVlCli02 })
	oSection2:Cell("CAMPO03"):SetBlock({|| nVlCli03 })
	oSection2:Cell("CAMPO04"):SetBlock({|| nVlCli04 })
	oSection2:Cell("CAMPO05"):SetBlock({|| nVlCli05 })
	oSection2:Cell("CAMPO06"):SetBlock({|| nVlCli06 })
	oSection2:Cell("CAMPO07"):SetBlock({|| nVlCli07 })
	oSection2:Cell("CAMPO08"):SetBlock({|| nVlCli08 })
	oSection2:Cell("CAMPO09"):SetBlock({|| nVlCli09 })
	oSection2:Cell("CAMPO10"):SetBlock({|| nVlCli10 })
	oSection2:Cell("CAMPO11"):SetBlock({|| nVlCli11 })
	oSection2:Cell("CAMPO12"):SetBlock({|| nVlCli12 })
	
oSection1:SetOrder(1) 
oSection1:SetTotalInLine(.T.)
oReport:SetTotalInLine(.F.)

Trposition():New(oSection1,"SF2",1,{|| "CREDIT NOTE LIST"})  

oSection2:SetLineCondition({||&cImpSldChq})
oSection2:Cell("CAMPO01"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Customer NO.")  ) //
oSection2:Cell("CAMPO02"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Customer Name")  ) 
oSection2:Cell("CAMPO03"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Credit Note ID")  )
oSection2:Cell("CAMPO04"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Invoiced")  )
oSection2:Cell("CAMPO05"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Data Sales ID")  )
oSection2:Cell("CAMPO06"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Item ID")  )
oSection2:Cell("CAMPO07"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Item Name")  )
oSection2:Cell("CAMPO08"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Return Reason")  )
oSection2:Cell("CAMPO09"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Sales Price")  )
oSection2:Cell("CAMPO10"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Qty")  )
oSection2:Cell("CAMPO11"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Amount")  )
oSection2:Cell("CAMPO12"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Coust Amount")  )

oSection2:SetHeaderPage()

oReport:SetTitle(titulo)

oReport:SetMeter(RecCount())
dbSelectArea("TRB")
DbGotop()

oSection1:Init() 
nTotCheque:=0
While !TRB->(EOF())  
 	oSection2:Init()
       //D2_CLIENTE,A1_NOME,E1_NUM,E1_EMISSAO,'doc d2 SALES ID',D2_ITEM,B1_DESC,'REASON',D2_PRUNIT,D2_QUANT,D2_VALBRUT,B1_CUSTD

		nVlCli01	   := ''
		nVlCli02	   := ''
		nVlCli03	   := ''
		nVlCli04	   := ''
		nVlCli05	   := ''
		nVlCli06	   := ''
		nVlCli07	   := ''
		nVlCli08	   := ''
		nVlCli09	   := 0
		nVlCli10	   := 0
		nVlCli11	   := 0
		nVlCli12	   := 0
				
		nTot1		   := 0
		nTot2		   := 0
		nTot3		   := 0
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
			nVlCli08	   := TRB->CAMPO08
			nVlCli09	   := TRB->CAMPO09
			nVlCli10	   := TRB->CAMPO10
			nVlCli11	   := TRB->CAMPO11
			nVlCli12	   := TRB->CAMPO12
			nTot1		   += TRB->CAMPO10
			nTot2	       += TRB->CAMPO11
			nTot3		   += TRB->CAMPO12
	   		oSection2:PrintLine()	
  		Dbskip()
  	EndDo               
  	//If mv_par05 == 2 //Sintetico
  		//oSection2:PrintLine()
  	//EndIf
  	oReport:PrintText(OemToAnsi("TOTAIS") + Space(187)+ Transf(nTot1,"@E 999,999,999.99")   +Transf(nTot2,"@E 999,999,999.99") + Transf(nTot3,"@E 999,999,999.99") )
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
ฑฑบPrograma  ณHIT0101   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
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

cQuery := "SELECT D2_CLIENTE,A1_NOME,E1_NUM,E1_EMISSAO,D2_DOC,D2_ITEM,B1_DESC,'REASON' AS REASON,D2_PRUNIT,D2_QUANT,D2_VALBRUT,B1_CUSTD"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA AND A1.D_E_L_E_T_<>'*'"
cQuery += " INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL='"+xFilial("SA1")+"' AND E1_NUM=D2_DOC AND E1_CLIENTE=D2_CLIENTE AND E1_LOJA=D2_LOJA AND E1.D_E_L_E_T_<>'*'"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SA1")+"' AND B1_COD=D2_COD AND B1.D_E_L_E_T_<>'*'"
cQuery += " WHERE D2_FILIAL='"+xFilial("SD2")+"'"
cQuery += " AND D2_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQuery += " AND D2.D_E_L_E_T_<>'*'"

	If Select('QUERY') > 0
		dbSelectArea('QUERY')
		dbCloseArea()
	EndIf
	
	MemoWrite("HIT0101.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )
	

	DbSelectArea( "QUERY" )  
	While !EOF()
                      
		IncProc(OemtoAnsi("Procesando vendedor ")+Subst(QUERY->A1_NOME,1,27))  //""
//D2_CLIENTE,A1_NOME,E1_NUM,E1_EMISSAO,'D2_DOC',D2_ITEM,B1_DESC,'REASON',D2_PRUNIT,D2_QUANT,D2_VALBRUT,B1_CUSTD"
		RecLock("TRB",.T.)
		TRB->CAMPO01    	:= 	QUERY->D2_CLIENTE
		TRB->CAMPO02      	:= 	QUERY->A1_NOME
		TRB->CAMPO03   		:= 	QUERY->E1_NUM
		TRB->CAMPO04  		:=	QUERY->E1_EMISSAO
		TRB->CAMPO05  		:= 	QUERY->D2_DOC                              
		TRB->CAMPO06		:= 	QUERY->D2_ITEM
		TRB->CAMPO07	   	:= 	QUERY->B1_DESC
		TRB->CAMPO08	   	:= 	QUERY->REASON
		TRB->CAMPO09	   	:= 	QUERY->D2_PRUNIT
		TRB->CAMPO10	   	:= 	QUERY->D2_QUANT
		TRB->CAMPO11	   	:= 	QUERY->D2_VALBRUT
		TRB->CAMPO12	   	:= 	QUERY->B1_CUSTD
		TRB->(MsUnLock())
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo

Return