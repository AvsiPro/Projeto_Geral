#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณAlexandre Venancio  บ Data ณ  10/08/13   บฑฑ
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

User Function TTFINR14(aRet)

Local aArea	:=	GetArea()
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local nLinha	:=	30                                  
Local nCol1		:=	5
Local nCol2		:=	30
Private oFont0	:= TFont():New('Courier new',,-04,.T.,.F.)
Private oFont1 	:= TFont():New('Courier New',,-18,.T.)
Private oFont2	:= TFont():New('Courier new',,-10,.T.,.T.)
Private oFont3	:= TFont():New('Courier new',,-08,.T.,.F.)   
Private oFont4	:= TFont():New('Courier new',,-06,.T.,.T.)    
Private oFont5	:= TFont():New('Courier new',,-05,.T.,.T.)    
Private oPrinter  
Private cRota	:=	sPace(6)
Private dDia	:=	ctod("  /  /  ")
Private aPergs	:=	{}   
Private aRetFdo	:=	{}  //Chamado da rotina de conferencia de caixa
Private _nPag	:= 0


//Private aRet	:=	{'RT0001',CTOD('21/10/2014')}
Default aRet	:=	{}

If cEmpAnt <> "01"
	Return
EndIf
//Prepare Environment Empresa "01" Filial "01" //Modulo "FAT" Tables "SUD" 

If len(aRet) == 0
	aAdd(aPergs ,{1,"Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",100,.F.})
	aAdd(aPergs ,{1,"Data",dDia,"99/99/99","","","",0,.F.})
	
	If ParamBox(aPergs ,"Imprimir Roteiro",@aRet)
		If Empty(aRet[1]) .Or. Empty(aRet[2])
			MsgAlert("Informe a Rota e o dia a ser impresso")
			Return
		Else
			Aadd(aRet,.F.)
		EndIf
	EndIf
EndIf
	
	cRota	:=	aRet[1]
	dDia	:=	aRet[2]
	
	If !aRet[3]
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
		nLinha := Lacres(aCol[1],5,30)
		Rodap(nLinha,nCol1,nCol2)
		
		oPrinter:EndPage()
		
		oPrinter:Preview()
		
		FreeObj(oPrinter)  
		
		oPrinter := Nil
	Else
		Rota(nLinha,nCol1,nCol2,.T.)
	EndIF	  
//EndIf
RestArea(aArea)

Return(aRetFdo) 



// rodape
Static Function CBC1(nLinha,nCol1,nCol2)

_nPag++


oPrinter:Say(nLinha, nCol1		,"Rota"	,	oFont3)
oPrinter:Say(nLinha, nCol1+20	,cRota	,	oFont2)

oPrinter:Say(nLinha, nCol1+75	,"Responsแvel",	oFont3) 
oPrinter:Say(nLinha, nCol1+125	,getNome(cRota),	oFont2) 

oPrinter:Say(nLinha, nCol1+345	,"Data", 		oFont3)	// acrescentar hora - SZN
oPrinter:Say(nLinha, nCol1+365	,CVALTOCHAR(dDia) +" - DATA DA CONFERสNCIA", 		oFont2)

// pagina
oPrinter:Say(nLinha, nCol1+550	,"p." +CVALTOCHAR(_nPag), 		oFont2)


nLinha += 5

oPrinter:Say(nLinha, nCol1, Replicate("_", 68), oFont1)

nLinha += 10

Return nLinha 

                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
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


nLinha := CBC1(nLinha,5,30)
/*
oPrinter:Say(nLinha, nCol1		,"Rota"	,	oFont3)
oPrinter:Say(nLinha, nCol1+20	,cRota	,	oFont2)

oPrinter:Say(nLinha, nCol1+75	,"Responsแvel",	oFont3) 
oPrinter:Say(nLinha, nCol1+125	,getNome(cRota),	oFont2) 

oPrinter:Say(nLinha, nCol1+345	,"Data", 		oFont3)	// acrescentar hora - SZN
oPrinter:Say(nLinha, nCol1+365	,CVALTOCHAR(dDia) +" - DATA DA CONFERสNCIA", 		oFont2)


//oPrinter:Line( nLinha-5, nCol1+315, 600, nCol1+315, ,'-1')
nLinha += 5

oPrinter:Say(nLinha, nCol1, Replicate("_", 68), oFont1)
*/

nLinha += 10
//nCol1 5 nCol2 40
oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio 
oPrinter:Say(nLinha+5,nCol1+2,"Patrim."	,oFont4)

nCol1 := nCol2 + 1
nCol2 += 80

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Modelo
oPrinter:Say(nLinha+5,nCol1+5,"Modelo"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 55

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Cliente   80
oPrinter:Say(nLinha+5,nCol1+5,"Cliente"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 35

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Troco     40
oPrinter:Say(nLinha+5,nCol1+5,"Troco"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 38

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//C้dulas   40
oPrinter:Say(nLinha+5,nCol1+5,"C้dulas"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 38

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Moedas    40		310
oPrinter:Say(nLinha+5,nCol1+5,"Moedas"		,oFont4)  

nCol1 := nCol2 + 1
nCol2 += 43

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//POS		    40		310
oPrinter:Say(nLinha+5,nCol1+5,"POS "				,oFont4)

nCol1 := nCol2 + 1
nCol2 += 63

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Dif Leitura    40		310
oPrinter:Say(nLinha+5,nCol1+5,"Venda R$"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 63

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Total Operacao    40		310
oPrinter:Say(nLinha+5,nCol1+2,"Valor Sangria"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 63

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Valor Abastecido no patrimonio    40		310
oPrinter:Say(nLinha+5,nCol1+1,"Adi็ใo Liquida"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 63

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Fundo de troco.    40		310
oPrinter:Say(nLinha+5,nCol1+1,"Fundo Troco"		,oFont4)

nCol1 := nCol2 + 1
nCol2 += 43

//oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2+45)		//Fundo de troco.    40		310
//oPrinter:Say(nLinha+5,nCol1+5,"Resultado"		,oFont4)

nCol1 := nCol2 + 2             //239 + 2 + 43
nCol2 += 50                    //276 + 50 + 43 

/*
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
*/ 
RestArea(aArea)

Return(nLinha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rota(nLinha,nCol1,nCol2,lFdt)
                              
Local aArea	:=	GetArea() 
Local aRet	:=	{}  
Local nBkC1	:=	nCol1
Local nBkC2	:=	nCol2
Local cQuery
Local aSisPg:=	{}   
Local nTotTr:=	0
Local nTotCd:=	0
Local nTotMd:=	0
Local aRetVen	:=	{}
Local nVendAt	:=	0
Local nVendAn	:=	0            
Local nTrcLn	:=	0
Local nVndLn	:=	0
Local nVlrLn	:=	0  
Local nTotFdA	:=	0  
Local nTotPos	:=	0
Local nTotVTo	:=	0
Local nTotSng	:=	0
Default lFdt	:= .F.



// nova consulta
/*
cQuery	:=	"SELECT ZF_ALTERAD,ZN_PATRIMO,ZF_CLIENTE,ZF_LOJA,ZN_TROCO,ZN_MOEDA1R,ZN_NOTA01,N1_XSISPG,N1_DESCRIC,A1_NREDUZ,ZN_NUMATU,ZE_TIPOPLA,ZN_HORA,ZN_COTCASH,ZN_LOGC01,ZN_LOGC02,ZN_LOGC03"  
cQuery 	+=	" FROM "+RetSQLName("SZN")+" ZN"
cQuery 	+=	" INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA = ZN_PATRIMO AND N1.D_E_L_E_T_=''" 
cQuery 	+=	" LEFT JOIN "+RetSQLName("SZF")+" ZF ON ZN_PATRIMO=ZF_PATRIMO AND ZN_FILIAL=ZF_FILIAL AND ZN_DATA=ZF_DATA  AND ZN_ROTA=ZF_ROTA" 
cQuery 	+=	" LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=N1_XCLIENT AND A1_LOJA=N1_XLOJA AND A1.D_E_L_E_T_=''"

cQuery 	+=	" LEFT JOIN "+RetSQLName("SZE")+" ZE ON ZE_CHAPA=ZN_PATRIMO AND ZE_ROTA=ZF_ROTA AND ZE_MENSAL LIKE '"+substr(dtos(dDia),1,6)+"%' AND SUBSTRING(ZE_MENSAL,"+cvaltochar(8+day(dDia))+",1)='1' AND ZE.D_E_L_E_T_=''" 

cQuery 	+=	" WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_ROTA='"+cRota+"' AND ZF_DATA='"+dtos(dDia)+"' AND ZF.D_E_L_E_T_='' AND ZN_PATRIMO<>''  AND ZN_TIPINCL IN ('SANGRIA','AUDITORIA') AND ZN.D_E_L_E_T_='' "    
cQuery 	+=	" ORDER BY ZN.R_E_C_N_O_"
*/


// nova consulta - pegar direto da szn - pois se pegar da szf, pode ter novas maquinas atendidas no dia
cQuery	:=	"SELECT ZN_PATRIMO,ZN_CLIENTE,ZN_LOJA,ZN_TROCO,ZN_MOEDA1R,ZN_NOTA01,N1_XSISPG,N1_DESCRIC,A1_NREDUZ,ZN_NUMATU,ZE_TIPOPLA,ZN_HORA,ZN_COTCASH,ZN_LOGC01,ZN_LOGC02,ZN_LOGC03"  
cQuery 	+=	" FROM "+RetSQLName("SZN")+" ZN"
cQuery 	+=	" INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA = ZN_PATRIMO AND N1.D_E_L_E_T_=''" 
cQuery 	+=	" LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZN_CLIENTE AND A1_LOJA=N1_LOJA AND A1.D_E_L_E_T_=''"
cQuery 	+=	" LEFT JOIN "+RetSQLName("SZE")+" ZE ON ZE_CHAPA=ZN_PATRIMO AND ZE_ROTA=ZN_ROTA AND ZE_MENSAL LIKE '"+substr(dtos(dDia),1,6)+"%' AND SUBSTRING(ZE_MENSAL,"+cvaltochar(8+day(dDia))+",1)='1' AND ZE.D_E_L_E_T_=''" 
cQuery 	+=	" WHERE ZN_FILIAL='"+xFilial("SZN")+"' AND ZN_ROTA='"+cRota+"' AND ZN_DATA='"+dtos(dDia)+"' AND ZN.D_E_L_E_T_='' AND ZN_PATRIMO<>''  AND ZN_TIPINCL IN ('SANGRIA','AUDITORIA') "    
cQuery 	+=	" ORDER BY ZN.R_E_C_N_O_"



If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")    

While !EOF()
 
	//If !Empty(TRB->ZF_PATRIMO) 
		nTotTr	+=	TRB->ZN_TROCO
		nTotMd	+=	TRB->ZN_MOEDA1R
		nTotCd	+=	TRB->ZN_NOTA01 
		nLinha += 10
		nCol1 := nBkC1
		nCol2 := nBkC2

		//Venda Atual e Anterior 
		nVendAt := TRB->ZN_COTCASH / 100
		aRetVen := VendAnt(TRB->ZN_PATRIMO,dDia)
        
        If len(aRetVen) > 0
			nVendPOS := VendPOS(TRB->ZN_PATRIMO,dDia,TRB->ZN_HORA,aRetVen[2],aRetVen[3])
		Else
			nVendPOS := 0
		EndIF
		
		//Venda anterior
		If len(aRetVen) > 0
			If aRetVen[1] > 0
				nVendAn := aRetVen[1]/100
				nVenda :=  nVendAt - nVendAn 
			Else
				nVendAn := (VAL(TRB->ZN_LOGC01)+VAL(TRB->ZN_LOGC02)+VAL(TRB->ZN_LOGC03) - (VAL(aRetVen[4])+VAL(aRetVen[5])+VAL(aRetVen[6]))) / 100
				nVenda :=  nVendAn // nVendAt - nVendAn 
			EndIf
			
		Else
			nVenda := 0
		EndIF 
		
		nTrcLn := TRB->ZN_TROCO
		nVndLn := nVenda
		nVlrLn := TRB->ZN_MOEDA1R+TRB->ZN_NOTA01+nVendPOS
		
		nTotVTo += nVenda
		nTotPos	+= nVendPOS
		nTotSng	+= nVlrLn
		
		//Chamado pela rotina de conferencia de caixa
		If lFdt
			If len(aRetFdo) == 0
				Aadd(aRetFdo,{cRota,nTotTr,nTotMd,nTotCd,nVendPOS,nVenda,nVlrLn,nVenda-nVlrLn})
			Else
				aRetFdo[1,2] :=  nTotTr
				aRetFdo[1,3] :=  nTotMd
				aRetFdo[1,4] :=  nTotCd
				aRetFdo[1,5] +=  nVendPOS
				aRetFdo[1,6] +=  nVenda
				aRetFdo[1,7] +=  nVlrLn
				aRetFdo[1,8] +=  nVenda-nVlrLn
			EndIf
			Dbskip()  
			loop
		EndIf
		
		//nCol1 5 nCol2 40
		//If !Empty(TRB->ZF_ALTERAD)
		//	oPrinter:Say(nLinha+5,nCol1-5,Alltrim(TRB->ZF_ALTERAD)	,oFont4)
		//EndIf
		
		If nLinha >= 600
			
			// data hora da impressao
			RodUsr(nLinha,nCol1)
			
			nLinha := 30
			oPrinter:EndPage()
			oPrinter:StartPage()
			nLinha := CBC1(nLinha,5,30)
			
		EndIf
			
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio 
		oPrinter:Say(nLinha+5,nCol1+2,TRB->ZN_PATRIMO	,oFont4)
		
		If Substr(TRB->ZE_TIPOPLA,1,1) == "6"
			oPrinter:Say(nLinha+9,nCol1+8,'LOG'	,oFont0)
		EndIf			
		
		nCol1 := nCol2 + 1
		nCol2 += 80
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Modelo
		oPrinter:Say(nLinha+5,nCol1+3,substr(TRB->N1_DESCRIC,1,22)		,oFont4)
		
		nCol1 := nCol2 + 1
		nCol2 += 55
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Cliente   80
		oPrinter:Say(nLinha+5,nCol1+3,substr(TRB->A1_NREDUZ,1,15)	,oFont4)
		
		nCol1 := nCol2 + 1
		nCol2 += 35
		aSisPg := strtokarr(Alltrim(TRB->N1_XSISPG),"|")
		
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
		
		If TRB->ZN_TROCO > 0
			oPrinter:Say(nLinha+5,nCol1+2,Transform(TRB->ZN_TROCO,"@E 99,999.99")		,oFont4)  
		Else
			oPrinter:Say(nLinha+5,nCol1+2,Transform(0,"@E 99,999.99")		,oFont4)  
		EndIF
		
		nCol1 := nCol2 + 1
		nCol2 += 38
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//C้dulas   40     
		//Tem Cedulas
		If Ascan(aSisPg,{|x| X = "CE"}) > 0
			If substr(aSisPg[Ascan(aSisPg,{|x| X = "CE"})],4,1) == "1"
				oPrinter:Say(nLinha+4,nCol1+4,"x"		,oFont4)
   			Else
   				oPrinter:Say(nLinha+5,nCol1-5,""		,oFont4)
   			EndIf
		Else
			oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)
		EndIf  
		
		If TRB->ZN_NOTA01 > 0
			oPrinter:Say(nLinha+5,nCol1-7,Transform(TRB->ZN_NOTA01,"@E 9,999,999.99")		,oFont4)
      	Else
			oPrinter:Say(nLinha+5,nCol1-7,Transform(0,"@E 9,999,999.99")		,oFont4)
		EndIf
		
		nCol1 := nCol2 + 1
		nCol2 += 38
		
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
		
		If TRB->ZN_MOEDA1R > 0
			oPrinter:Say(nLinha+5,nCol1-5,Transform(TRB->ZN_MOEDA1R,"@E 9,999,999.99")		,oFont4)
		Else
			oPrinter:Say(nLinha+5,nCol1-5,Transform(0,"@E 9,999,999.99")		,oFont4)
		EndIf  
		
		nCol1 := nCol2 + 1
		nCol2 += 43
		
         
		DbSelectArea("TRB")
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//POS    40		310
		oPrinter:Say(nLinha+5,nCol1+1,Transform(nVendPOS,"@E 9,999,999.99")		,oFont4)
		
		nCol1 := nCol2 + 1
		nCol2 += 63
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Dif Leitura    40		310
		//nVendAt := VAL(SUBSTR(CVALTOCHAR(TRB->ZN_NUMATU),1,LEN(CVALTOCHAR(TRB->ZN_NUMATU))-2)+"."+SUBSTR(CVALTOCHAR(TRB->ZN_NUMATU),LEN(CVALTOCHAR(TRB->ZN_NUMATU))-2,2))

       
		If len(aRetVen) > 0
			oPrinter:Say(nLinha+5,nCol1+0.5,substr(cvaltochar(aRetVen[2]),1,5)		,oFont0)
		EndIf
		
		oPrinter:Say(nLinha+5,nCol1+20,Transform(nVenda,"@E 99,999,999.99")		,oFont4)
        

		nCol1 := nCol2 + 1
		nCol2 += 63
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//TOTAL OPERACAO    40		310
		//oPrinter:Say(nLinha+5,nCol1+10,Transform((nVndLn+nTrcLn)-(nVlrLn),"@E 99,999.99")		,oFont4)
		oPrinter:Say(nLinha+5,nCol1+20,Transform(nVlrLn,"@E 99,999,999.99")		,oFont4)
        
		nCol1 := nCol2 + 1
		nCol2 += 63
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//adicao liquida    40		310
		oPrinter:Say(nLinha+5,nCol1+20,Transform(nVenda-nVlrLn,"@E 99,999,999.99")		,oFont4)
		nTotFdA += nVenda-nVlrLn
		                                                                       
		nCol1 := nCol2 + 1
		nCol2 += 63
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Fundo de troco    40		310
		oPrinter:Say(nLinha+5,nCol1+20,Transform(FundTrc(TRB->ZN_PATRIMO,dDia),"@E 99,999,999.99")		,oFont4)

		//nCol1 := nCol2 + 1
		//nCol2 += 43
		//oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2+45)		//Fundo de troco.    40		310
		//oPrinter:Say(nLinha+5,nCol1+5,""		,oFont4)

		
		
	//EndIF
	DbSkip()
EndDo

If !lFdt
	If nLinha >= 600
		nLinha := 30
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha := CBC1(nLinha,5,30)
	EndIf
	                                                        
	oPrinter:Say(nLinha+15,010,'TOTAIS'									,oFont4)
	oPrinter:Say(nLinha+15,162,Transform(nTotTr,"@E 9,999,999.99")		,oFont4)
	oPrinter:Say(nLinha+15,200,Transform(nTotCd,"@E 9,999,999.99")		,oFont4)
	oPrinter:Say(nLinha+15,238,Transform(nTotMd,"@E 9,999,999.99")		,oFont4) 
	
	oPrinter:Say(nLinha+15,277,Transform(nTotPos,"@E 99,999,999.99")		,oFont4) 
	oPrinter:Say(nLinha+15,335,Transform(nTotVTo,"@E 99,999,999.99")		,oFont4) 
	oPrinter:Say(nLinha+15,402,Transform(nTotSng,"@E 99,999,999.99")		,oFont4) 
	oPrinter:Say(nLinha+15,463,Transform(nTotFdA,"@E 99,999,999.99")		,oFont4)               
	nLinha += 35
	Aadd(aRet,nLinha)
	Aadd(aRet,nCol1)
	Aadd(aRet,nCol2)
EndIf


Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  07/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca o contador cash anterior a leitura sendo executada. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendAnt(cpatrim,ddata)

Local aArea	:=	GetArea()
Local aRet	:=	{}

cQuery := "SELECT TOP 1 ZN_COTCASH,ZN_DATA,ZN_HORA,ZN_LOGC01,ZN_LOGC02,ZN_LOGC03,ZN_LOGC04,ZN_NUMATU FROM "+RetSQLName("SZN")
cQuery += " WHERE ZN_FILIAL='"+xFilial("SZN")+"' AND ZN_PATRIMO='"+cpatrim+"' AND ZN_DATA<'"+dtos(ddata)+"'"
cQuery += " AND D_E_L_E_T_='' AND ZN_TIPINCL IN ('SANGRIA','AUDITORIA') AND ZN_NUMOS<>'' ORDER BY ZN_DATA DESC"   //AND ZN_NUMATU<>'0' 

If Select("TRB2") > 0
	dbSelectArea("TRB2")
	dbCloseArea()
EndIf
  
MemoWrite( "TTFINR142.SQL",cQuery )

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB2',.F.,.T.)   

DbSelectArea("TRB2")

If !Empty(TRB2->ZN_COTCASH) .OR. !Empty(TRB2->ZN_LOGC01)
	aRet := {TRB2->ZN_COTCASH,STOD(TRB2->ZN_DATA),TRB2->ZN_HORA,TRB2->ZN_LOGC01,TRB2->ZN_LOGC02,TRB2->ZN_LOGC03,TRB2->ZN_LOGC04,TRB2->ZN_NUMATU}
EndIf

RestArea(aArea)

Return(aRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
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
Local aLacr	:=	{}
Local aEnve	:=	{}
Local aGlen	:=	{} 
Local aAux	:=	{}
Local nTot	:=	0
Local nTotr	:=	0
Local nTotA := 0
Local cQuery	 
Local nBklin:=  0
                  
nLinha	+= 10
//nCol1 	:= nCol2 + 2
//nCol2 	+= 50 

cQuery	:=	"SELECT ZF_LACRE,ZF_ENVELOP,ZF_GLENVIE FROM "+RetSQLName("SZF")
cQuery 	+=	" WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_ROTA='"+cRota+"' AND ZF_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
cQuery 	+=	" AND (ZF_LACRE<>'' OR ZF_ENVELOP<>'' OR ZF_GLENVIE<>'') ORDER BY R_E_C_N_O_"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
//aLacr  
While !EOF() 
    If !Empty(TRB->ZF_LACRE)
    	Aadd(aLacr,{TRB->ZF_LACRE,''})
    EndIf
    If !Empty(TRB->ZF_ENVELOP)
    	Aadd(aEnve,{TRB->ZF_ENVELOP,''})
    EndIf
    If !Empty(TRB->ZF_GLENVIE)
    	Aadd(aGlen,{TRB->ZF_GLENVIE,''})
    EndIf
    DbSkip()
EndDo

For nX := 1 to len(aLacr) 
	cQuery := "SELECT ZN_PATRIMO,ZN_LACCMOE,ZN_BANANIN,ZN_GLENVIE FROM "+RetSQLName("SZN")
	cQuery += " WHERE ZN_FILIAL='"+xFilial("SZF")+"' AND ZN_ROTA='"+cRota+"' AND ZN_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
	//cQuery += " AND ZN_LACCMOE='"+aLacr[nX,01]+"' "//cQuery += " AND ZN_LACCMOE='"+aLacr[nX,01]+"'"
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTATFC07.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")
	
	aLacr[nX,02] := TRB->ZN_PATRIMO
	
	If Ascan(aEnve,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_BANANIN)}) > 0
		aEnve[Ascan(aEnve,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_BANANIN)}),02] := TRB->ZN_PATRIMO
	EndIf
	
	If Ascan(aGlen,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_GLENVIE)}) > 0
		aGlen[Ascan(aGlen,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_GLENVIE)}),02] := TRB->ZN_PATRIMO
	EndIf
	
Next nX

For nX := 1 to len(aLacr)
	If Empty(aLacr[nX,02])
		cQuery := "SELECT ZZO_BLACKL FROM "+RetSQLName("ZZO")+" WHERE ZZO_ROTA='"+cRota+"' AND ZZO_DATSAI='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
		cQuery += " AND ZZO_LACRE='"+aLacr[nX,01]+"'"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB") 
		
		If !Empty(TRB->ZZO_BLACKL)
			aLacr[nX,02] := "Lista negra"
		EndIf
	EndIf
Next nX

For nX := 1 to len(aEnve)
	If Empty(aEnve[nX,02])
		
		cQuery := "SELECT ZN_PATRIMO,ZN_BANANIN,ZN_GLENVIE FROM "+RetSQLName("SZN")
		cQuery += " WHERE ZN_FILIAL='"+xFilial("SZF")+"' AND ZN_ROTA='"+cRota+"' AND ZN_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
		cQuery += " AND ZN_BANANIN='"+aEnve[nX,01]+"'"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB")

		aEnve[nX,02] := TRB->ZN_PATRIMO
		
		If Ascan(aGlen,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_GLENVIE)}) > 0
			aGlen[Ascan(aGlen,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_GLENVIE)}),02] := TRB->ZN_PATRIMO
		EndIf
		
	EndIf
Next nX

For nX := 1 to len(aEnve)
	If Empty(aEnve[nX,02])
		cQuery := "SELECT ZZO_BLACKL FROM "+RetSQLName("ZZO")+" WHERE ZZO_ROTA='"+cRota+"' AND ZZO_DATSAI='"+dtos(dDia)+"' AND D_E_L_E_T_=''" 
		cQuery += " AND ZZO_LACRE='"+aEnve[nX,01]+"'"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB") 
		
		If !Empty(TRB->ZZO_BLACKL)
			aEnve[nX,02] := "Lista negra"
		EndIf
	EndIf
Next nX

For nX := 1 to len(aGlen)
	If Empty(aGlen[nX,02])
		   
		cQuery := "SELECT ZN_PATRIMO FROM "+RetSQLName("SZN")
		cQuery += " WHERE ZN_FILIAL='"+xFilial("SZF")+"' AND ZN_ROTA='"+cRota+"' AND ZN_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"
		cQuery += " AND ZN_BANANIN='"+aGlen[nX,01]+"'"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB")
        aGlen[nX,02] := TRB->ZN_PATRIMO   
        
	EndIf
Next nX

For nX := 1 to len(aGlen)
	If Empty(aGlen[nX,02])
		cQuery := "SELECT ZZO_BLACKL FROM "+RetSQLName("ZZO")+" WHERE ZZO_ROTA='"+cRota+"' AND ZZO_DATSAI='"+dtos(dDia)+"' AND D_E_L_E_T_=''" 
		cQuery += " AND ZZO_LACRE='"+aGlen[nX,01]+"'"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB") 
		
		If !Empty(TRB->ZZO_BLACKL)
			aGlen[nX,02] := "Lista negra"
		EndIf
	EndIf
Next nX

 	nCol1 := nBkC1
 	nCol2 := nBkC2	
 	nLbk  := nLinha
 	
 	For nX := 1 to len(aLacr)
		If !Empty(aLacr[nX,02])
			Aadd(aAux,{aLacr[nX,02],Alltrim(aLacr[nX,01])})
		Else
			If Ascan(aAux,{|x| Alltrim(x[1]) == 'Lacres Retornados'}) == 0
				Aadd(aAux,{'Lacres Retornados',Alltrim(aLacr[nX,01])})
			else
				aAux[Ascan(aAux,{|x| Alltrim(x[1]) == 'Lacres Retornados'}),02] += ',' + Alltrim(aLacr[nX,01])
			endif 	                                           
		EndIf
 	Next nX
 	
 	For nX := 1 to len(aEnve)
		If !Empty(aEnve[nX,02])
			If Ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(aEnve[nX,02])}) > 0
			    aAux[Ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(aEnve[nX,02])}),02] += ',' + Alltrim(aEnve[nX,01])
			Else
				Aadd(aAux,{aEnve[nX,02],Alltrim(aEnve[nX,01])})
			EndIf
		Else
			If Ascan(aAux,{|x| Alltrim(x[1]) == 'Bananinhas Retornadas'}) == 0
				Aadd(aAux,{'Bananinhas Retornadas',Alltrim(aEnve[nX,01])})
			else
				aAux[Ascan(aAux,{|x| Alltrim(x[1]) == 'Bananinhas Retornadas'}),02] += ',' + Alltrim(aEnve[nX,01])
			endif 	                                           
		EndIf
 	Next nX

	For nX := 1 to len(aGlen) 
		If !Empty(aGlen[nX,02])
			If Ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(aGlen[nX,02])}) > 0
			    aAux[Ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(aGlen[nX,02])}),02] += ',' + Alltrim(aGlen[nX,01])
			Else
				Aadd(aAux,{aGlen[nX,02],aGlen[nX,01]})
			EndIf
		Else
			If Ascan(aAux,{|x| Alltrim(x[1]) == 'Glenviews Retornados'}) == 0
				Aadd(aAux,{'Glenviews Retornados',Alltrim(aGlen[nX,01])})
			else
				aAux[Ascan(aAux,{|x| Alltrim(x[1]) == 'Glenviews Retornados'}),02] += ',' + Alltrim(aGlen[nX,01])
			endif 	                                           
		EndIf
	Next nX
	
	Asort(aAux,,,{|x,y| x[1] < y[1] })
	
	// quebra pagina
	If nLinha >= 600
		// data hora da impressao
		RodUsr(nLinha,nCol1)
		
		nLinha := 30
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha := CBC1(nLinha,5,30)
	EndIf
	
	
	
	oPrinter:Box(nLinha,nBkC1,nLinha+10,nBkC2+465)		//Lacre
	oPrinter:Say(nLinha+5,nBkC1+200,'Itens utilizados e retornados'		,oFont4) 
	nLinha += 10
	
	For nX := 1 to len(aAux)
   		nCol1 := nBkC1
		nCol2 := nBkC2+25
		
		// quebra pagina
		If nLinha >= 800
		
			// data hora da impressao
			RodUsr(nLinha,nCol1)
		
			nLinha := 30
			oPrinter:EndPage()
			oPrinter:StartPage()
			nLinha := CBC1(nLinha,5,30)
			
			oPrinter:Box(nLinha,nBkC1,nLinha+10,nBkC2+465)		//Lacre
			oPrinter:Say(nLinha+5,nBkC1+200,'Itens utilizados e retornados'		,oFont4) 
			nLinha += 10
			
		EndIf
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
		oPrinter:Say(nLinha+5,nCol1+2,aAux[nX,01]		,oFont4) 
		
		nCol1 := nCol2 + 1
		nCol2 += 440
		
		oPrinter:Box(nLinha,nCol1,nLinha+if(len(aAux[nX,2])>125,20,10),nCol2)		//Patrimonio  
		If len(aAux[nX,2]) > 125
			oPrinter:Say(nLinha+5,nCol1+2,substr(aAux[nX,02],1,125)	,oFont4) 
			oPrinter:Say(nLinha+15,nCol1+2,substr(aAux[nX,02],126)	,oFont4) 
		else
			oPrinter:Say(nLinha+5,nCol1+2,aAux[nX,02]	,oFont4) 
		EndIf
		nLinha += 10		
	Next nX
	
	/* 	
 	For nX := 1 to len(aLacr)	
		
		nCol1 := nBkC1
		nCol2 := nBkC2
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Lacre
		oPrinter:Say(nLinha+5,nCol1+2,aLacr[nX,01]		,oFont4) 
		
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
		oPrinter:Say(nLinha+5,nCol1+2,If(!Empty(aLacr[nX,02]),aLacr[nX,02],'Retornou')		,oFont4) 
		nLinha += 10
	Next nX
	
	nBklin := nLinha
	nLinha := nLbk  
	nBkC3  := nCol2 + 1
	nBkC4  := nCol2 + 40
	//nCol1 := nCol2 + 1
	//nCol2 += 40
	
	For nX := 1 to len(aEnve)

		nCol1 := nBkC3
		nCol2 := nBkC4
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Bananinha
		oPrinter:Say(nLinha+5,nCol1+1,aEnve[nX,01]	,oFont4) 
		
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
		oPrinter:Say(nLinha+5,nCol1+2,If(!Empty(aEnve[nX,02]),aEnve[nX,02],'Retornou')		,oFont4)
		nLinha += 10 
	Next nX
	
	If nLinha > nBklin
		nBklin := nLinha
	EndIf
	
	nLinha := nLbk 
	nBkC5  := nCol2 + 1
	nBkC6  := nCol2 + 40
	//nCol1 := nCol2 + 1
	//nCol2 += 40
	                  
	For nX := 1 to len(aGlen) 
		
		nCol1 := nBkC5
		nCol2 := nBkC6
	
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Glenview
		oPrinter:Say(nLinha+5,nCol1+2,aGlen[nX,01]	,oFont4) 
		
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//Patrimonio
		oPrinter:Say(nLinha+5,nCol1+2,If(!Empty(aGlen[nX,02]),aGlen[nX,02],'Retornou')		,oFont4) 
		nLinha += 10
	Next nX
    */
	If nLinha > nBklin
		nBklin := nLinha
	EndIf


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

nLinha := nBklin + 30

nCol1 := nBkC1
nCol2 := nBkC2 


// quebra pagina
If nLinha >= 600
	// data hora da impressao
	RodUsr(nLinha,nCol1)
		
	nLinha := 30
	oPrinter:EndPage()
	oPrinter:StartPage()
	nLinha := CBC1(nLinha,5,30)
EndIf

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2+80)
oPrinter:Say(nLinha+5,nCol1+2,'Moedas Para Troco'		,oFont4) 

nLinha += 10

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)
oPrinter:Say(nLinha+5,nCol1+2,''		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)
oPrinter:Say(nLinha+5,nCol1+2,"Saํda"		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40

oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)
oPrinter:Say(nLinha+5,nCol1+1,"Retorno"		,oFont4) 

nCol1 := nCol2 + 1
nCol2 += 40
                                                     
oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)	
oPrinter:Say(nLinha+5,nCol1+1,"Abastecido"		,oFont4) 


While !EOF() 
 	For nX := 1 to 5 
		nLinha += 10		
		nCol1 := nBkC1
 		nCol2 := nBkC2
 		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//MOEDA
		oPrinter:Say(nLinha+5,nCol1+2,aMoed[nX]		,oFont4) 
		
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//SAIDA
		oPrinter:Say(nLinha+5,nCol1+2,cvaltochar(&("TRB->ZF_MOEDA0"+cvaltochar(nX)))		,oFont4) 
		
		nTot += &("TRB->ZF_MOEDA0"+cvaltochar(nX)) * val(strtran(aMoed[nX],",","."))
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//RETORNO
		oPrinter:Say(nLinha+5,nCol1+1,cvaltochar(&("TRB->ZF_RETMOE"+cvaltochar(nX)))	,oFont4)   
		
		nTotr += &("TRB->ZF_RETMOE"+cvaltochar(nX)) * val(strtran(aMoed[nX],",","."))
		
		nCol1 := nCol2 + 1
		nCol2 += 40
		
		oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//ABASTECIDO
		nAbast := &("TRB->ZF_MOEDA0"+cvaltochar(nX)) - &("TRB->ZF_RETMOE"+cvaltochar(nX))
		oPrinter:Say(nLinha+5,nCol1+1,cvaltochar( nAbast )	,oFont4)   
		
		nTotA += nAbast * val(strtran(aMoed[nX],",","."))

	Next nX
	
	nLinha += 10
	nCol1 := nBkC1
	nCol2 := nBkC2 
	 		
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		
	oPrinter:Say(nLinha+5,nCol1+2,'Total $'			,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		// saida
	oPrinter:Say(nLinha+5,nCol1+2,Transform(nTot,"@E 9,999.99")		,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		// retorno
	oPrinter:Say(nLinha+5,nCol1+1,Transform(nTotr,"@E 9,999.99")		,oFont4) 
	
	nCol1 := nCol2 + 1
	nCol2 += 40
	
	//oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//retorno
	//oPrinter:Say(nLinha+5,nCol1+1,Transform(nTotr,"@E 9,999.99")		,oFont4) 
	   
	//nCol1 := nCol2 + 1
	//nCol2 += 40
	
	oPrinter:Box(nLinha,nCol1,nLinha+10,nCol2)		//abastecido
	oPrinter:Say(nLinha+5,nCol1+1,Transform(nTotA,"@E 9,999.99")		,oFont4) 
	
	DbSkip()
EndDo

// DIVERGENCIAS
nLinha += 10
oPrinter:Say( nLinha+5,30,"Diverg๊ncias serใo descontadas"		,oFont4) 


RestArea(aArea)

Return(nLinha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rodap(nLinha,nCol1,nCol2)

Local aArea	:=	GetArea() 
Local aMsg	:=	{}

Aadd(aMsg,"Declaro que recebi o material relacionado acima para a realiza็ใo dos servi็os de coleta de valores das mแquinas")
Aadd(aMsg,"relacionadas, ficando responsแvel por executar os servi็os de acordo com os procedimentos da empresa, retornar")
Aadd(aMsg,"os valores coletados bem como os materiais nใo utilizados, estando ciente que qualquer neglig๊ncia na sua utiliza็ใo")
Aadd(aMsg,"ou seu extravio acarretarแ em desconto dos seus respectivos valores em folha de pagamento.")

// nova frase
Aadd(aMsg,"Declaramos que conferimos conjuntamente os materiais.")


If nLinha < 600   
	nLinha 	:= 600 
Else
	nLinha 	:= nLinha + 15
	
	// quebra pagina
	If nLinha >= 600
		nLinha := 30
		oPrinter:EndPage()
		oPrinter:StartPage()
		nLinha := CBC1(nLinha,5,30)
	EndIf
	
	nLinha 	:= 600 
	
Endif

nCol1  	:= 5
nCol2 	:= 540


oPrinter:Box(nLinha,nCol1,nLinha+60,nCol2)	

For nX := 1 to len(aMsg)
	oPrinter:Say(nLinha+5,nCol1+2,aMsg[nX]	,oFont4)
	nLinha += 10
Next nX

oPrinter:Box(nLinha,nCol1,nLinha+60,nCol2)
//oPrinter:Line(nLinha, nCol1+315, nLinha+60, nCol1+315, ,'-1')
	
//oPrinter:Say(nLinha+5,nCol1+30,"CONFERสNCIA DE SAอDA"	,oFont4)
oPrinter:Say(nLinha+5,nCol1+430,"CONFERสNCIA DE RETORNO"	,oFont4)
//oPrinter:Say(nLinha+55,nCol1+30,"ASSINATURA LEGอVEL"	,oFont4)
oPrinter:Say(nLinha+55,nCol1+430,"ASSINATURA LEGอVEL"	,oFont4)

//oPrinter:Say(nLinha+45,nCol1+5,"Responsแvel pela entrega"	,oFont4)
//oPrinter:Say(nLinha+45,nCol1+200,"Coletor"	,oFont4)

oPrinter:Say(nLinha+45,nCol1+100,"Responsแvel pela confer๊ncia"	,oFont4)
oPrinter:Say(nLinha+45,nCol1+480,"Coletor"	,oFont4)


//If nLinha >= 800
// data hora da impressao
RodUsr(nLinha,nCol1)
//EndIf

/*
nLinha += 20
oPrinter:Say(nLinha+45,nCol1,"Data hora impressใo: " +dtoc(date()) +" - " +Time()	,oFont4)

//nome usuario
nLinha += 60
oPrinter:Say(nLinha,nCol1,"Usuแrio: " +UsrFullName(__cUserID)	,oFont4)
*/ 

RestArea(aArea)

Return



Static Function RodUsr(nLinha,nCol1)


nLinha := 700

// data hora da impressao
//nLinha += 20
oPrinter:Say(nLinha+45,nCol1,"Data hora impressใo: " +dtoc(date()) +" - " +Time()	,oFont4)

//nome usuario
nLinha += 40
oPrinter:Say(nLinha,nCol1,"Usuแrio: " +UsrFullName(__cUserID)	,oFont4)


Return nLinha

 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  09/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FundTrc(cPatr,dDia)

Local aArea	:=	GetArea()
Local nRet	:=	0

cQuery := "SELECT ZI_FDOTRO FROM "+RetSQLName("SZI")
cQuery += " WHERE ZI_PATRIMO='"+cPatr+"' AND ZI_DATA='"+dtos(dDia)+"' AND D_E_L_E_T_=''"

If Select("TRB3") > 0
	dbSelectArea("TRB3")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB3',.F.,.T.)   

DbSelectArea("TRB3")

//If TRB3->ZI_FDOTRO <> 0
	nRet := TRB3->ZI_FDOTRO
//EndIf

RestArea(aArea)

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR14  บAutor  ณMicrosiga           บ Data ณ  10/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Vendas em POS por patrimonio.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendPOS(cPatr,dDia1,cHora1,dDia2,cHora2)

Local aArea	:=	GetArea()
Local nRet	:=	0
Local aRet	:=	{}

Aadd(aRet,{dtos(dDia1),cHora1})
Aadd(aRet,{dtos(dDia2),cHora2})
//VendaPOS(cPatr,aRet)

nRet := STATICCALL( TTAUDT02, VendaPOS, cPatr, aRet )
 
RestArea(aArea)

Return(nRet)

// nome do atendente
Static Function getNome(cRota)

Local cNome := ""
Local cQuery := ""
Local aArea := GetArea()

cQuery := "SELECT AA1_NOMTEC FROM " +RetSqlName("AA1")
cQuery += " WHERE AA1_LOCAL = '"+cRota+"' AND D_E_L_E_T_ = ''  "

MpSysOpenQuery( cQuery,"TRBA" )

dbSelectArea("TRBA")
cNome := AllTrim(TRBA->AA1_NOMTEC)

dbCloseArea()


RestArea(aArea)

Return cNome