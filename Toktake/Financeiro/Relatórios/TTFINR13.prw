#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR13  บAutor  ณAlexandre Venancio  บ Data ณ  10/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Roteiro de Sangria de Patrimonios em PDF                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบVers๕es   ณ 22/05/14 - Correcao no print do plano de filiais. Alexandreบฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINR13()

Local aArea	:=	GetArea()
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.

Local nLinha	:=	30                                  
Local nCol1		:=	5
Local nCol2		:=	30
Private oFont0	:= TFont():New('Courier new',,-15,.T.,.F.)
Private oFont1 	:= TFont():New('Courier New',,-18,.T.)
Private oFont2	:= TFont():New('Courier new',,-10,.T.,.T.)
Private oFont3	:= TFont():New('Courier new',,-08,.T.,.F.)   
Private oFont4	:= TFont():New('Courier new',,-06,.T.,.T.)
Private oPrinter  
Private cRota	:=	sPace(6)
Private dDia	:=	ctod("  /  /  ")
Private aPergs	:=	{}
Private aRet	:=	{}

If cEmpAnt <> "01"
	Return
EndIf

//Prepare Environment Empresa "01" Filial "01" //Modulo "FAT" Tables "SUD" 
aAdd(aPergs ,{1,"Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",100,.F.})
aAdd(aPergs ,{1,"Data",dDia,"99/99/99","","","",0,.F.})

If ParamBox(aPergs ,"Imprimir Roteiro",@aRet)
	cRota	:=	aRet[1]
	dDia	:=	aRet[2]
	If oPrinter == Nil
		lPreview := .T.
		oPrinter := FWMSPrinter():New("Rota.rel", 6, lAdjustToLegacy, , lDisableSetup)
		
		// Ordem obrigแtoria de configura็ใo do relat๓rio
		oPrinter:SetResolution(72)
		oPrinter:SetPortrait()
		oPrinter:SetPaperSize(DMPAPER_A4)
		oPrinter:SetMargin(60,60,60,60) 
		// nEsquerda, nSuperior, nDireita, nInferior 
		oPrinter:cPathPDF := "\SPOOL\"     
		oPrinter:Setup()
	EndIf               
	
	oPrinter:StartPage()
	 
	nLinha := Cabec(nLinha,nCol1,nCol2)
	aCol   := Rota(nLinha,nCol1,nCol2)
	Lacres(nLinha,aCol[1],aCol[2])
	Rodap()
	
	oPrinter:EndPage()
	
	oPrinter:Preview()
	
	FreeObj(oPrinter)  
	
	oPrinter := Nil	  
EndIf
RestArea(aArea)

Return                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR13  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec(nLinha,nCol1,nCol2)

Local aArea	:=	GetArea()

oPrinter:Say(nLinha, nCol1		,"Rota"	,	oFont3)
oPrinter:Say(nLinha, nCol1+20	,cRota	,	oFont2)

oPrinter:Say(nLinha, nCol1+75	,"Responsแvel",	oFont3) 
oPrinter:Say(nLinha, nCol1+125	,STATICCALL( TTFINR14,getNome,cRota),	oFont2) 

oPrinter:Say(nLinha, nCol1+345	,"Data", 		oFont3)	// acrescentar hora - SZN - aqui nao da pra colocar a hora pois essa informacao esta contida nos lancamentos
oPrinter:Say(nLinha, nCol1+365	,CVALTOCHAR(dDia) +" - DATA DA SAIDA", 		oFont2)

oPrinter:Line( nLinha-5, nCol1+315, 600, nCol1+315, ,'-1')
nLinha += 5

oPrinter:Say(nLinha, nCol1, Replicate("_", 68), oFont1)

nLinha += 10
//nCol1 5 nCol2 40
oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio 
oPrinter:Say(nLinha+5,nCol1+2,"Patrim."	,oFont4)

nCol1 := nCol2 + 1
nCol2 += 80

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Modelo
oPrinter:Say(nLinha+5,nCol1+5,"Modelo"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 80

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Cliente   80
oPrinter:Say(nLinha+5,nCol1+5,"Cliente"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 43

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Troco     40
oPrinter:Say(nLinha+5,nCol1+5,"Troco"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 43

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//C้dulas   40
oPrinter:Say(nLinha+5,nCol1+5,"C้dulas"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 43

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Moedas    40		310
oPrinter:Say(nLinha+5,nCol1+5,"Moedas"		,oFont4) 

nCol1 := nCol2 + 2
nCol2 += 50

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
oPrinter:Say(nLinha+5,nCol1+2,"Lacres"		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
oPrinter:Say(nLinha+5,nCol1+2,"Patrim."		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Bananinha
oPrinter:Say(nLinha+5,nCol1+1,"Bananinha"	,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
oPrinter:Say(nLinha+5,nCol1+2,"Patrim."		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Glenview
oPrinter:Say(nLinha+5,nCol1+2,"Glenview"	,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
oPrinter:Say(nLinha+5,nCol1+2,"Patrim."		,oFont4) 
 
RestArea(aArea)

Return(nLinha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR13  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rota(nLinha,nCol1,nCol2)
                              
Local aArea	:=	GetArea() 
Local aRet	:=	{}  
Local nBkC1	:=	nCol1
Local nBkC2	:=	nCol2
Local cQuery
Local aSisPg:=	{} 

cQuery	:=	"SELECT * FROM "+RetSQLName("SZF")
cQuery 	+=	" WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_ROTA='"+cRota+"' AND ZF_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")    

While !EOF() 
	If !Empty(TRB->ZF_PATRIMO)
		nLinha += 10
		nCol1 := nBkC1
		nCol2 := nBkC2
		//nCol1 5 nCol2 40
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio 
		oPrinter:Say(nLinha+5,nCol1+2,TRB->ZF_PATRIMO	,oFont4)
		
		nCol1 := nCol2 + 1
		nCol2 += 80
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Modelo
		oPrinter:Say(nLinha+5,nCol1+3,substr(Posicione("SN1",2,xFilial("SN1")+TRB->ZF_PATRIMO,"N1_DESCRIC"),1,22)		,oFont4)
		
		nCol1 := nCol2 + 1
		nCol2 += 80
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Cliente   80
		oPrinter:Say(nLinha+5,nCol1+3,substr(Posicione("SA1",1,xFilial("SA1")+TRB->ZF_CLIENTE+TRB->ZF_LOJA,"A1_NREDUZ"),1,15)	,oFont4)
		
		nCol1 := nCol2 + 1
		nCol2 += 43
		aSisPg := strtokarr(Posicione("SN1",2,xFilial("SN1")+TRB->ZF_PATRIMO,"N1_XSISPG"),"|")
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Troco     40
		//Tem Moedeiro com troco
		If Ascan(aSisPg,{|x| X = "MC"}) > 0
			If substr(aSisPg[Ascan(aSisPg,{|x| X = "MC"})],4,1) == "1"
				oPrinter:Say(nLinha+4,nCol1+2,"x"		,oFont4)	
			Else
				oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
			EndIf
		Else
			oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
		EndIf
		
		nCol1 := nCol2 + 1
		nCol2 += 43
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//C้dulas   40     
		//Tem Cedulas
		If Ascan(aSisPg,{|x| X = "CE"}) > 0
			If substr(aSisPg[Ascan(aSisPg,{|x| X = "CE"})],4,1) == "1"
				oPrinter:Say(nLinha+4,nCol1+2,"x"		,oFont4)
   			Else
   				oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
   			EndIf
		Else
			oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
		EndIf
		
		nCol1 := nCol2 + 1
		nCol2 += 43
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Moedas    40		310
		If Ascan(aSisPg,{|x| X = "MC"}) > 0 .OR. Ascan(aSisPg,{|x| X = "MS"}) > 0
        	If substr(aSisPg[Ascan(aSisPg,{|x| X = "MC"})],4,1) == "1" .or. substr(aSisPg[Ascan(aSisPg,{|x| X = "MS"})],4,1) == "1"
	        	oPrinter:Say(nLinha+4,nCol1+2,"x"		,oFont4)
        	Else
        		oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
        	EndIf
		Else
			oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
		EndIf
	EndIF
	DbSkip()
EndDo


Aadd(aRet,nCol1)
Aadd(aRet,nCol2)

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR13  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Lacres(nLinha,nCol1,nCol2)
 
Local aArea	:=	GetArea()
Local nBkC1	:=	nCol2 + 2
Local nBkC2	:=	nCol2 + 50 
Local aMoed	:=	{'0,05','0,10','0,25','0,50','1,00'}
Local nTot	:=	0
Local cQuery	

nLinha	+= 10
//nCol1 	:= nCol2 + 2
//nCol2 	+= 50 

cQuery	:=	"SELECT * FROM "+RetSQLName("SZF")
cQuery 	+=	" WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_ROTA='"+cRota+"' AND ZF_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
cQuery 	+=	" AND (ZF_LACRE<>'' OR ZF_ENVELOP<>'' OR ZF_GLENVIE<>'')"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF() 
 	nCol1 := nBkC1
 	nCol2 := nBkC2		
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
	oPrinter:Say(nLinha+5,nCol1+2,TRB->ZF_LACRE		,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
	oPrinter:Say(nLinha+5,nCol1+2,""		,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Bananinha
	oPrinter:Say(nLinha+5,nCol1+1,TRB->ZF_ENVELOP	,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
	oPrinter:Say(nLinha+5,nCol1+2,""		,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Glenview
	oPrinter:Say(nLinha+5,nCol1+2,TRB->ZF_GLENVIE	,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
	oPrinter:Say(nLinha+5,nCol1+2,""		,oFont4) 
	nLinha += 10
	DbSkip()
EndDo


cQuery	:=	"SELECT * FROM "+RetSQLName("SZF")
cQuery 	+=	" WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_ROTA='"+cRota+"' AND ZF_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
cQuery 	+=	" AND (ZF_MOEDA01 > 0 OR ZF_MOEDA02 > 0 OR ZF_MOEDA03 > 0 OR ZF_MOEDA04 > 0 OR ZF_MOEDA05 > 0)"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

nLinha += 30

nCol1 := nBkC1
nCol2 := nBkC2 

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2+80)		//Lacre
oPrinter:Say(nLinha+5,nCol1+2,'Moedas Para Troco'		,oFont4) 

    nLinha += 10

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
oPrinter:Say(nLinha+5,nCol1+2,''		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
oPrinter:Say(nLinha+5,nCol1+2,"Saํda"		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Bananinha
oPrinter:Say(nLinha+5,nCol1+1,"Retorno"		,oFont4) 

While !EOF() 
 	For nX := 1 to 5 
		nLinha += 10		
		nCol1 := nBkC1
 		nCol2 := nBkC2
 		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
		oPrinter:Say(nLinha+5,nCol1+2,aMoed[nX]		,oFont4) 
		
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
		oPrinter:Say(nLinha+5,nCol1+2,cvaltochar(&("TRB->ZF_MOEDA0"+cvaltochar(nX)))		,oFont4) 
		
		nTot += &("TRB->ZF_MOEDA0"+cvaltochar(nX)) * val(strtran(aMoed[nX],",","."))
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Bananinha
		oPrinter:Say(nLinha+5,nCol1+1,''	,oFont4)   

	Next nX
	
	nLinha += 10
	nCol1 := nBkC1
	nCol2 := nBkC2 
	 		
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
	oPrinter:Say(nLinha+5,nCol1+2,'Total $'			,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
	oPrinter:Say(nLinha+5,nCol1+2,Transform(nTot,"@E 9,999.99")		,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Bananinha
	oPrinter:Say(nLinha+5,nCol1+1,""		,oFont4) 
	
	DbSkip()
EndDo

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR13  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rodap()

Local aArea	:=	GetArea() 
Local aMsg	:=	{}

Aadd(aMsg,"Declaro que recebi o material relacionado acima para a realiza็ใo dos servi็os de coleta de valores das mแquinas")
Aadd(aMsg,"relacionadas, ficando responsแvel por executar os servi็os de acordo com os procedimentos da empresa, retornar")
Aadd(aMsg,"os valores coletados bem como os materiais nใo utilizados, estando ciente que qualquer neglig๊ncia na sua utiliza็ใo")
Aadd(aMsg,"ou seu extravio acarretarแ em desconto dos seus respectivos valores em folha de pagamento.")
 
// nova frase
Aadd(aMsg,"Declaramos que conferimos conjuntamente os materiais.") 
   
nLinha 	:= 600
nCol1  	:= 5
nCol2 	:= 540

oPrinter:Box(nLinha,nCol1,nLinha+60,nCol2)	

For nX := 1 to len(aMsg)
	oPrinter:Say(nLinha+5,nCol1+2,aMsg[nX]	,oFont4)
	nLinha += 10
Next nX

oPrinter:Box(nLinha,nCol1,nLinha+60,nCol2)
//oPrinter:Line(nLinha, nCol1+315, nLinha+60, nCol1+315, ,'-1')
	
oPrinter:Say(nLinha+5,nCol1+30,"CONFERสNCIA DE SAอDA"	,oFont4)
//oPrinter:Say(nLinha+5,nCol1+430,"CONFERสNCIA DE RETORNO"	,oFont4)
oPrinter:Say(nLinha+55,nCol1+30,"ASSINATURA LEGอVEL"	,oFont4)
//oPrinter:Say(nLinha+55,nCol1+430,"ASSINATURA LEGอVEL"	,oFont4)

oPrinter:Say(nLinha+45,nCol1+5,"Responsแvel pela entrega"	,oFont4)
oPrinter:Say(nLinha+45,nCol1+200,"Coletor"	,oFont4)

//oPrinter:Say(nLinha+45,nCol1+320,"Responsแvel pela confer๊ncia"	,oFont4)
//oPrinter:Say(nLinha+45,nCol1+480,"Coletor"	,oFont4)


// data hora da impressao
nLinha += 20
oPrinter:Say(nLinha+45,nCol1,"Data hora impressใo: " +dtoc(date()) +" - " +Time()	,oFont4)

//nome usuario
nLinha += 60
oPrinter:Say(nLinha,nCol1,"Usuแrio: " +UsrFullName(__cUserID)	,oFont4)

RestArea(aArea)

Return 