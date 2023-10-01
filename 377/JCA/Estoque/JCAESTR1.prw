#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJCAESTR1   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function JCAESTR1()

Local oReport 

oReport	:= ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJCAESTR1   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
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

Local oReport,oSection1,oSection2,oSection3
Local cReport := "JCAESTR1"
Local cTitulo := OemToAnsi("Solicita็๕es de pe็as") 
Local cDescri := OemToAnsi("Este programa imprimi ordens de servi็os.")


Pergunte( "HIT101X" , .F. )
                   
oReport  := TReport():New( cReport, cTitulo, "HIT101X" , { |oReport| ReportPrint( oReport, "TRB" ) }, cDescri )

oReport:SetLandScape()

oSection1 := TRSection():New( oReport,"Codigo" , {"TRB","SA1"},{"Codigo Cliente","Nome Cliente"},/*Campos do SX3*/,/*Campos do SIX*/)

TRCell():New(oSection1,"REQUISICAO"	,"",'Requisicao',/*Picture*/,TamSx3("CP_NUM")[1]/*Tamanho*/,/*lPixel*/,{||TRB->CAMPO06})
TRCell():New(oSection1,"LOCAL"	,"",'Filial',/*Picture*/,TamSx3("CP_FILIAL")[1]/*Tamanho*/,/*lPixel*/,{||TRB->CAMPO07})
TRCell():New(oSection1,"OS"	,"",'OS',/*Picture*/,TamSx3("CP_OP")[1]/*Tamanho*/,/*lPixel*/,{||TRB->CAMPO08})
TRCell():New(oSection1,"SOLICITANTE"	,"",'Solicitante',/*Picture*/,TamSx3("CP_SOLICIT")[1]/*Tamanho*/,/*lPixel*/,{||TRB->CAMPO09})
//TRCell():New(oSection1,"CENTRO CUSTO"	,"",'STR0019',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,"SETOR"	,"",'STR0019',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,"HORA"	,"",'STR0019',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DATA"	,"",'Emissao',/*Picture*/,TamSx3("CP_EMISSAO")[1]/*Tamanho*/,/*lPixel*/,{||TRB->CAMPO10})
//TRCell():New(oSection1,"VEICULO"	,"",'STR0019',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oSection1,"ALMOXARIFE"	,"",'STR0019',/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2 := TRSection():New( oSection1,"Itens da Solicita็ใo" , {"TRB","SCP"} ) 

TRCell():New( oSection2, "CAMPO01","" ,/*X3Titulo*/ ,/*Picture*/,TamSx3("CP_PRODUTO")[1],/*lPixel*/,{||TRB->CAMPO01})
TRCell():New( oSection2, "CAMPO02","" ,/*X3Titulo*/ ,/*Picture*/,TamSx3("CP_DESCRI")[1],/*lPixel*/,{||TRB->CAMPO02})	
TRCell():New( oSection2, "CAMPO03","" , /*X3Titulo()*/,/*Picture*/,TamSx3("ZPM_DESC")[1],/*lPixel*/,{||TRB->CAMPO03 })
TRCell():New( oSection2, "CAMPO04","" , /*X3Titulo()*/,/*Picture*/,TamSx3("CP_QUANT")[1],/*lPixel*/,{||TRB->CAMPO04 })
TRCell():New( oSection2, "CAMPO05","" , /*X3Titulo()*/,/*Picture*/,TamSx3("B2_CM1")[1],/*lPixel*/,{||TRB->CAMPO05 })

oSection2:Cell("CAMPO01"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO02"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO03"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO04"):lHeaderSize	:=	.T.
oSection2:Cell("CAMPO05"):lHeaderSize	:=	.T.

oSection3 := TRSection():New(oSection1,"Assinaturas", ("TRB","") )  // STR0025

TRCell():New( oSection3, "Assinatura"	,"",,/*Picture*/,40,/*lPixel*/,{||"__________________________" })	// PRF
TRCell():New( oSection3, "Encarregado"	,"",,/*Picture*/,40,/*lPixel*/,{||"__________________________" })	// PRF


Return oReport
                                                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJCAESTR1   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
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
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(2)         
Local nOrder	:= oReport:Section(1):GetOrder()
Local cIndice	:= ""

Local	nVlCli01	   
Local	nVlCli02	   
Local	nVlCli03	   
Local	nVlCli04	   
Local	nVlCli05	   
Local   cNum    := ''

Private aCampos	:=	{}
Private cNomeArq

Titulo := OemToAnsi("Entrega de pe็as") 
Titulo += Space(1)

AADD(aCampos,{"CAMPO01","C",TamSx3('CP_PRODUTO')[1],0})
AADD(aCampos,{"CAMPO02","C",TamSx3('CP_DESCRI')[1],0})
AADD(aCampos,{"CAMPO03","C",TamSX3('ZPM_DESC')[1],0})
AADD(aCampos,{"CAMPO04","N",TamSX3('CP_QUANT')[1],0})
AADD(aCampos,{"CAMPO05","N",TamSX3('B2_CM1')[1],0})

AADD(aCampos,{"CAMPO06","C",TamSX3('CP_NUM')[1],0})
AADD(aCampos,{"CAMPO07","C",TamSX3('CP_FILIAL')[1],0})
AADD(aCampos,{"CAMPO08","C",TamSX3('CP_OP')[1],0})
AADD(aCampos,{"CAMPO09","C",TamSX3('CP_SOLICIT')[1],0})
AADD(aCampos,{"CAMPO10","D",TamSX3('CP_EMISSAO')[1],0})

cNomeArq  := CriaTrab(aCampos)

dbUseArea( .T., __cRDDNTTS, cNomeArq,"TRB", if(.F. .Or. .F., !.F., NIL), .F. )
If nOrder	==	1
	cIndice	:=	"CAMPO01"
Endif
IndRegua("TRB",cNomeArq,cIndice,,,OemToAnsi("Selecionando Registros..."))  

Processa({|lEnd| GeraTra(oSection1:GetAdvplExp('SD2'),oSection1:GetAdvplExp('SA1'))},,OemToAnsi("Preparando Transitขrio...")) 

dbSelectArea("TRB")
dbGoTop()

oSection2:SetParentFilter({|cParam| TRB->CAMPO01+TRB->CAMPO02 == cParam },{||SA1->A1_COD+SA1->A1_NOME}) 

oSection1:SetOrder(1) 

Trposition():New(oSection1,"SCP",1,{|| "LISTA DE ITENS"})  

oSection2:SetLineCondition({||&cImpSldChq})
oSection2:Cell("CAMPO01"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Material")  ) //
oSection2:Cell("CAMPO02"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Descri็ใo")  ) 
oSection2:Cell("CAMPO03"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Marca")  )
oSection2:Cell("CAMPO04"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Qtde")  )
oSection2:Cell("CAMPO05"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Vlr. unit.")  )

oSection2:SetHeaderPage()

oReport:SetTitle(titulo)

oReport:SetMeter(RecCount())
dbSelectArea("TRB")
DbGotop()

oSection1:Init()


While !TRB->(EOF())  
 	oSection2:Init()
       
    nVlCli01	   := ''
    nVlCli02	   := ''
    nVlCli03	   := ''
    nVlCli04	   := ''
    nVlCli05	   := ''
                    
    If !Empty(cNum)
        oSection3:Init()	 
        oSection3:nLinesBefore := 20
	    oSection3:SetLineBreak()
        oSection3:PrintLine()
        oSection3:Finish()
        oReport:EndPage()
        oReport:StartPage()
        oSection1:Finish()	
        oSection1:Init()
    EndIf 

    cNum := TRB->CAMPO06
    oSection1:PrintLine()


    While cNum == TRB->CAMPO06  .And. !TRB->(EOF())
		oReport:IncMeter()    	
			nVlCli01	   := TRB->CAMPO01
			nVlCli02	   := TRB->CAMPO02
			nVlCli03	   := TRB->CAMPO03
			nVlCli04	   := TRB->CAMPO04
			nVlCli05	   := TRB->CAMPO05
			
            oSection2:nLinesBefore := 5
	        oSection2:SetLineBreak()
	   		oSection2:PrintLine()	
            
  		Dbskip()
  	EndDo               
  	
    oSection2:Finish()	
	//oReport:ThinLine()
	
EndDo     
                                       
oSection3:Init()	 
oSection3:PrintLine()
oSection3:Finish()

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
ฑฑบPrograma  ณJCAESTR1   บAutor  ณMicrosiga           บ Data ณ  02/12/12   บฑฑ
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

Local cQuery 

nCount := 1000

cQuery := "SELECT CP_FILIAL,CP_NUM,CP_ITEM,CP_PRODUTO,CP_DESCRI,CP_QUANT,CP_EMISSAO,CP_SOLICIT,CP_OP,ZPM_DESC,B2_CM1"
cQuery += " FROM "+RetSQLName("SCP")+" CP"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=CP_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '" 
cQuery += " INNER JOIN "+RetSQLName("SB2")+" B2 ON B2_FILIAL=CP_FILIAL AND B2_COD=CP_PRODUTO AND B2_LOCAL=B1_LOCPAD AND B2.D_E_L_E_T_=' '"
cQuery += " WHERE CP_FILIAL='"+xFilial("SCP")+"' AND CP_OP=' '"
/*cQuery += " AND D2_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"*/
//cQuery += " AND D2.D_E_L_E_T_<>'*'"

	If Select('QUERY') > 0
		dbSelectArea('QUERY')
		dbCloseArea()
	EndIf
	
	MemoWrite("JCAESTR1.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )
	

	DbSelectArea( "QUERY" )  
	While !EOF()
                      
		IncProc(OemtoAnsi("Procesando solicitacao ")+QUERY->CP_NUM)  //""
		RecLock("TRB",.T.)
		TRB->CAMPO01    	:= 	QUERY->CP_PRODUTO
		TRB->CAMPO02      	:= 	QUERY->CP_DESCRI
		TRB->CAMPO03   		:= 	QUERY->ZPM_DESC
		TRB->CAMPO04  		:=	QUERY->CP_QUANT
		TRB->CAMPO05  		:= 	QUERY->B2_CM1                              
		TRB->CAMPO06		:= 	QUERY->CP_NUM
		TRB->CAMPO07	   	:= 	QUERY->CP_FILIAL
		TRB->CAMPO08	   	:= 	QUERY->CP_OP
		TRB->CAMPO09	   	:= 	QUERY->CP_SOLICIT
		TRB->CAMPO10	   	:= 	STOD(QUERY->CP_EMISSAO)
		
		TRB->(MsUnLock())
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo

Return
