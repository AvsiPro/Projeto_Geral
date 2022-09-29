#INCLUDE "TOPCONN.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR04  บAutor  ณAlexandre Venancio  บ Data ณ  16/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorios de sangria de patrimonios 					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROR04()
	Local oReport
	If cEmpAnt <> "01"
		return
	EndIF
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	Else
		Alert("Esta op็ใo ainda nใo estแ disponํvel")
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR04  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
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

	Local oReport
	Local oSection
	Local clDesc	:="Este relat๓rio exibe as Sangrias e Vendas POS dos patrimonios nos clientes."
	Local clTitulo	:="Patrimonios"
	Local clProg	:="TTPROR04"
	Private cPerg	:="TTPROR04"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Sangrias"),{"TRB"})
	
   	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"			,"@!"	,02)	
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI"		,"@!"	,06)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA"			,"@!"	,04)	
	TRCell():New(oSection1,"NOME"		,"TRB","NOME"			,"@!"	,50)
	TRCell():New(oSection1,"UF"			,"TRB","UF"				,"@!"	,02)
	TRCell():New(oSection1,"CIDADE"		,"TRB","CIDADE"			,"@!"	,50)
	TRCell():New(oSection1,"PATRIMONIO"	,"TRB","PATRIMONIO"		,"@!"	,06)	
	TRCell():New(oSection1,"MODELO"		,"TRB","MODELO"			,"@!"	,25)	
	TRCell():New(oSection1,"DATA_LEIT"	,"TRB","DATA_LEIT"		,		,08)	
	TRCell():New(oSection1,"DATA_INS"	,"TRB","DATA_INS"		,		,08)	
	TRCell():New(oSection1,"DATA_REM"	,"TRB","DATA_REM"		,		,08)
	
	TRCell():New(oSection1,"CEDULA"		,"TRB","CEDULA"			,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"MOEDA"		,"TRB","MOEDA"			,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"POS"		,"TRB","POS"			,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"VLSANG"		,"TRB","VALOR SANGRADO"	,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"AB_TROCO" 	,"TRB","AB_TROCO"		,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"VENDA"		,"TRB","VENDA"			,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"ADLIQ"		,"TRB","FALTA DE DINHEIRO" ,"@E 999,999,999.99"	,15)
	TRCell():New(oSection1,"FNDTRCO"	,"TRB","FUNDO TROCO"	,"@E 999,999,999.99"	,15)
	
	//TRCell():New(oSection1,"TOTAL"		,"TRB","TOTAL"			,"@E 999,999,999.99"	,15)
	
	TRCell():New(oSection1,"CONTANT"	,"TRB","CONTADOR ANT"	,"@!"	,25)
	TRCell():New(oSection1,"DTCNTANT"	,"TRB","DATA_LEIT"		,		,08)
	TRCell():New(oSection1,"CONTATU"	,"TRB","CONTADOR ATUAL"	,"@!"	,25)
	TRCell():New(oSection1,"USEROS"		,"TRB","USUARIO OS"		,"@!"	,30)


	//CEDULA	MOEDA	POS	VALOR SANGRADO	AB_TROCO	VENDA	DIF_DINHEIRO	FUNDO TROCO	CASH ANT	DATA_LEIT	CASH ATUAL	USUARIO OS.
	
	
		
	// venda
	// contador inicial
	// data contador inicial
	// contador final
	// data contador final
	// valor sangrado
	// adicao liq
	// fundo de troco
	// usuario
	
	
	/*
	venda - acertar formatacao
	contador - ้ o cASH
	*/

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR04  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*----------------------------------------------------------------------------| 		    			           
	|sele็ao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-----------------------------|
	| impressao da primeira se็ao  | 
	|-----------------------------*/
	
	DbSelectArea("TRB")
	DbGoTop()
	oReport:SetMeter(RecCount())
	oSection1:Init()         
	While  !Eof()
		If oReport:Cancel()
			Exit
		EndIf
		oSection1:PrintLine()
		DbSelectArea("TRB")
		DbSkip()            
		oReport:IncMeter()
	EndDo
	oSection1:Finish()		
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR04  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSelDados()
	
Local aRet		:=	{}  
Local aCampos	:=	{}
Local nVendaPOS := 0

_aStru	:= {} 

AADD(_aStru,{"COD_CLI"		,"C",06,0})
AADD(_aStru,{"LOJA"			,"C",04,0})
AADD(_aStru,{"NOME"			,"C",50,0})
AADD(_aStru,{"PATRIMONIO"	,"C",06,0})
AADD(_aStru,{"MODELO"		,"C",25,0})
AADD(_aStru,{"DATA_LEIT"	,"D",08,0})
AADD(_aStru,{"DATA_INS"		,"D",08,0})
AADD(_aStru,{"DATA_REM"		,"D",08,2})
AADD(_aStru,{"AB_TROCO"		,"N",15,2})
AADD(_aStru,{"CEDULA"		,"N",15,2})
AADD(_aStru,{"MOEDA"		,"N",15,2}) 
AADD(_aStru,{"POS"			,"N",15,2})
AADD(_aStru,{"TOTAL"		,"N",15,2})
AADD(_aStru,{"FILIAL"		,"C",02,0})
AADD(_aStru,{"UF"			,"C",02,0})
AADD(_aStru,{"CIDADE"		,"C",50,0})

AADD(_aStru,{"VENDA"		,"N",15,2})	// ZN_RESCASH
AADD(_aStru,{"CONTANT"		,"N",25,0})	// ZN_NUMANT
AADD(_aStru,{"DTCNTANT"		,"D",08,2})	// ZN_DTANT
AADD(_aStru,{"CONTATU"		,"N",25,0})	// ZN_NUMATU
AADD(_aStru,{"VLSANG"		,"N",15,2})	// ZI_VLRSAN
AADD(_aStru,{"ADLIQ"		,"N",15,2})	// ZI_ADLIQ
AADD(_aStru,{"FNDTRCO"		,"N",15,2})	// ZI_FDOTRO


// USUARIO DA OS
AADD(_aStru,{"USEROS"		,"C",30,0})
			
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
//IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
// Busca dados dos contadores - cedulas/moedas
clQuery := " SELECT ZN_FILIAL,ZN_NUMOS,ZN_COTCASH,ZN_DATA, ZN_HORA, ZG_HORAFIM, ZG_AGENTED, ZN_CLIENTE,"
clQuery += "ZN_LOJA,ZN_DESCCLI,ZN_PATRIMO,ZN_TIPMAQ,ZN_TROCO,ZN_MOEDA1R,ZN_NOTA01,ZN_RESCASH,ZN_NUMANT,ZN_DTANT, ZN_NUMATU"
clQuery += " FROM "+RetSQLName("SZN")+" ZN "
clQuery += " INNER JOIN " +RetSqlName("SZG") +" ZG ON "
clQuery += " ZG_FILIAL = ZN_FILIAL AND ZG_NUMOS = ZN_NUMOS "
clQuery += " WHERE ZN.D_E_L_E_T_ = '' AND ZN_TIPINCL IN ('SANGRIA','AUDITORIA') "

If !Empty(MV_PAR01)
	clQuery += " AND ZN_CLIENTE = '"+MV_PAR01+"' "
EndIf

If !Empty(MV_PAR02)
	clQuery += " AND ZN_PATRIMO = '"+MV_PAR02+"' "
EndIf

If EMPTY(MV_PAR04) .OR. EMPTY(MV_PAR05)
	return
Else
	clQuery += " AND ZN_DATA BETWEEN '"+dtos(MV_PAR04)+"' AND '"+dtos(MV_PAR05)+"' "
EndIf


If Select("TRBROTA") > 0
	dbSelectArea("TRBROTA")
	DbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBROTA",.F.,.T.)

dbSelectArea("TRBROTA")
dbGotop()

Do While TRBROTA->(!Eof())
	
	If !Empty(TRBROTA->ZN_PATRIMO)	
	
		aRet := ChkSZD(TRBROTA->ZN_PATRIMO,TRBROTA->ZN_DATA)
		cEst := Posicione( "SA1",1,xFilial("SA1") +AvKey(TRBROTA->ZN_CLIENTE,"A1_COD") +AvKey(TRBROTA->ZN_LOJA,"A1_LOJA"),"A1_EST" )
		cMun := Posicione( "SA1",1,xFilial("SA1") +AvKey(TRBROTA->ZN_CLIENTE,"A1_COD") +AvKey(TRBROTA->ZN_LOJA,"A1_LOJA"),"A1_MUN" )
				 
		nVlSang := 0
		nAdLiq := 0
		nFdTroco := 0
		
		// filtro Estado do cliente
		If !Empty(MV_PAR06)
			If AllTrim(cEst) <> AllTrim(MV_PAR06)
				dbSelectArea("TRBROTA")
				dbSkip()
				Loop
			EndIf
		EndIf  
		
		
		dbSelectArea("SZI")
		dbSetOrder(3)
		If MsSeek( xFilial("SZI") +Avkey(TRBROTA->ZN_NUMOS,"ZI_NUMOS") )
			nVlSang := SZI->ZI_VLRSAN
			//nAdLiq := SZI->ZI_ADLIQ
			nFdTroco := SZI->ZI_FDOTRO
		EndIf
		
		nNumAnt := 0
		nVendaPOS := 0
		dDtAnt := stod("")
		cHrOSAnt := ""
		cHrOSAtu := TRBROTA->ZN_HORA
		aVndAnt := {}
		nVendaCash := 0
		nValSang := 0
		nCashAnt := 0
		
		If AllTrim(TRBROTA->ZN_FILIAL) != AllTrim(cFilAnt)
			cFilAnt := TRBROTA->ZN_FILIAL
		EndIf
		
		// leitur anterior
		//LeitAnt( TRBROTA->ZN_PATRIMO,stod(TRBROTA->ZN_DATA),@dDtAnt,@cHrOSAnt,@nNumAnt  )
		aVndAnt := STATICCALL( TTFINR14, VendAnt, TRBROTA->ZN_PATRIMO, STOD(TRBROTA->ZN_DATA) )
		
		//{TRB2->ZN_COTCASH,STOD(TRB2->ZN_DATA),TRB2->ZN_HORA,TRB2->ZN_LOGC01,TRB2->ZN_LOGC02,TRB2->ZN_LOGC03,TRB2->ZN_LOGC04,TRB2->ZN_NUMATU}
		If !Empty(aVndAnt)
			nCashAnt := aVndAnt[1]
			dDtAnt := aVndAnt[2]
			cHrOSAnt := aVndAnt[3]
			nNumAnt := aVndAnt[8]
		EndIf
		
		If !Empty(dDtAnt) .And. !Empty(cHrOSAnt) .And. !Empty(aVndAnt)
			// venda POS
			//nVendaPOS := vendaPOS( TRBROTA->ZN_PATRIMO, dDtAnt, cHrOSAnt, stod(TRBROTA->ZN_DATA), TRBROTA->ZN_HORA )
			nVendaPOS := STATICCALL( TTAUDT02,VendaPOS,TRBROTA->ZN_PATRIMO, {  { TRBROTA->ZN_DATA,cHrOSAtu},{DTOS(dDtAnt),cHrOSAnt} } )
		EndIf
		
		If Empty(TRBROTA->ZN_RESCASH)
			nVendaCash :=  ( TRBROTA->ZN_COTCASH - nCashAnt )
		Else
			nVendaCash := TRBROTA->ZN_RESCASH
		EndIf
		
		nValSang :=  ( TRBROTA->ZN_NOTA01 + TRBROTA->ZN_MOEDA1R + nVendaPOS )
		nAdLiq := nValSang - (nVendaCash/100) - TRBROTA->ZN_TROCO
		
		//If nAdLiq == 0
			//nAdLiq := ( nVendaPOS + TRBROTA->ZN_NOTA01 + TRBROTA->ZN_MOEDA1R ) - (nVendaCash/100) - TRBROTA->ZN_TROCO
			//nAdLiq := nVendaCash/100 - TRBROTA->ZN_TROCO - TRBROTA->ZN_NOTA01 - TRBROTA->ZN_MOEDA1R - nVendaPOS
			
			// ??
			// ALTERAR PARA:
			// venda + troco - cedula - moeda - pos
			
			// acertar numero da venda dividi
		//EndIf
		
		// TESTES 1045 - 08/02 - 14/02 - ACERTAR LEITURA ANTERIOR + CALCULO VENDA POS 
		
		/* adicao liquida - calcular aqui
		pos + moeda + cedula - venda - troco
		*/
	
		dbSelectArea("TRBROTA")
						     				
		Aadd(aCampos,{TRBROTA->ZN_CLIENTE,TRBROTA->ZN_LOJA,TRBROTA->ZN_DESCCLI,TRBROTA->ZN_PATRIMO,;
					TRBROTA->ZN_TIPMAQ,STOD(TRBROTA->ZN_DATA),aRet[6],aRet[7],TRBROTA->ZN_TROCO,;
					TRBROTA->ZN_NOTA01,TRBROTA->ZN_MOEDA1R,nVendaPOS,;
					TRBROTA->ZN_NOTA01 + TRBROTA->ZN_MOEDA1R, TRBROTA->ZN_FILIAL, cEst, cMun,;
					(nVendaCash/100),;
					nCashAnt,;
					IIF( TRBROTA->ZN_DTANT < "20170215",dDtAnt,stod(TRBROTA->ZN_DTANT) ) ,TRBROTA->ZN_COTCASH,;
					nValSang, nAdLiq,nFdTroco,;
					TRBROTA->ZG_AGENTED })
												
	EndIf
	
	dbSelectArea("TRBROTA")

	DbSkip()
Enddo


// REGRA POS
// DATA E HORA DA SANGRIA ANTERIOR ATE A DATA E HORA DA SANGRIA POSICIONADA
// PEGAR A VENDA DO POS COM BASE NO PERIODO ACIMA

// RETIRAR PARAMETRO DA CONSULTA DE CEDULA/MOEDA/POS
// CONSIDERAR TODA A VENDA - CEDULAR/MOEDAS/POS

// CONSULTA COMECA DIRETO NO LANCAMENTO DOS CONTADORES
// PEGA VENDA DO POS DA TABELA ZZE


For nX := 1 to len(aCampos)
	DbSelectArea("TRB")
	RecLock("TRB",.T.)   
	TRB->COD_CLI 	:=	aCampos[nX,01]
	TRB->LOJA		:=	aCampos[nX,02]
	TRB->NOME		:=	aCampos[nX,03]		
	TRB->PATRIMONIO	:=	aCampos[nX,04]
	TRB->MODELO		:=	aCampos[nX,05] 
	TRB->DATA_LEIT 	:=	aCampos[nX,06] 
	TRB->DATA_INS 	:=	aCampos[nX,07] 
	TRB->DATA_REM 	:=	aCampos[nX,08] 
	TRB->AB_TROCO	:=	aCampos[nX,09] 
	TRB->CEDULA		:=	aCampos[nX,10] 
	TRB->MOEDA		:=	aCampos[nX,11] 
	TRB->POS		:=	aCampos[nX,12]  
	TRB->TOTAL		:=	aCampos[nX,13]
	TRB->FILIAL		:=  aCampos[nX,14]
	TRB->UF			:=  aCampos[nX,15]
	TRB->CIDADE		:=  aCampos[nX,16]
	
	TRB->VENDA		:=  aCampos[nX][17]
	
	
	TRB->CONTANT	:= aCampos[nX][18]
	TRB->DTCNTANT	:= aCampos[nX][19]
	TRB->CONTATU	:= aCampos[nX][20]
	TRB->VLSANG		:= aCampos[nX][21]
	TRB->ADLIQ		:= aCampos[nX][22]
	TRB->FNDTRCO	:= aCampos[nX][23]
	TRB->USEROS		:= aCampos[nX][24]
		
	MsUnlock()	
Next nX

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR04  บAutor  ณMicrosiga           บ Data ณ  03/25/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkSZD(cNumChapa,dData)

Local aRet := {"","","","","",stod(""),stod("")}
Local cQuery := ""      
Local lAchou := .F.
Local aArea := GetArea()

cQuery := "SELECT ZD_DATAINS, ZD_DATAREM, ZD_IDSTATU, A1_COD, A1_LOJA, A1_NREDUZ, A1_EST, A1_MUN FROM " +RetSqlName("SZD") + " SZD "
cQuery += " INNER JOIN " +RetSqlName("SA1") + " SA1 ON "
cQuery += " SA1.A1_COD = SZD.ZD_CLIENTE AND SA1.A1_LOJA = SZD.ZD_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery += " WHERE ZD_PATRIMO = '"+cNumChapa+"' AND SZD.D_E_L_E_T_ = '' "

// Busca por Cliente
If !Empty(MV_PAR01)
	cQuery += "AND A1_COD = '"+MV_PAR01+"'"
EndIf
    
// Busca por Estado                                           
If !Empty(MV_PAR06)
	cQuery += " AND A1_EST='"+MV_PAR06+"'"
EndIf                  

cQuery += " ORDER BY SZD.ZD_DATAINS "

If Select("TRBZD") > 0
	TRBZD->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZD",.F.,.T.)
dbSelectArea("TRBZD")

While !EOF()
	If stod(dData) >= stod(TRBZD->ZD_DATAINS) .And. stod(dData) <= stod(TRBZD->ZD_DATAREM)
		lAchou := .T.
		aRet[1] := TRBZD->A1_COD
		aRet[2] := TRBZD->A1_LOJA
		aRet[3] := TRBZD->A1_NREDUZ
		aRet[4] := TRBZD->A1_EST
		aRet[5] := TRBZD->A1_MUN
		aRet[6] := stod(TRBZD->ZD_DATAINS)
		aRet[7] := stod(TRBZD->ZD_DATAREM)
		Exit
	EndIf
	
	dbSkip()
End

// Pega a instalacao ATIVA
If !lAchou
	dbGoTop()
	While !EOF()
		If stod(dData) >= stod(TRBZD->ZD_DATAINS) .And. Empty(TRBZD->ZD_DATAREM) .And. AllTrim(TRBZD->ZD_IDSTATU) == "1"
			aRet[1] := TRBZD->A1_COD
			aRet[2] := TRBZD->A1_LOJA
			aRet[3] := TRBZD->A1_NREDUZ
			aRet[4] := TRBZD->A1_EST
			aRet[5] := TRBZD->A1_MUN
			aRet[6] := stod(TRBZD->ZD_DATAINS)
			aRet[7] := stod(TRBZD->ZD_DATAREM)
			lAchou := .T.
			Exit
		EndIf                          
		dbSkip()
	End
EndIf

If !lAchou
	aRet[1] := Posicione("SN1",2,xFilial("SN1")+AvKey(cNumChapa,"N1_CHAPA"),"N1_XCLIENT")
	aRet[2] := Posicione("SN1",2,xFilial("SN1")+AvKey(cNumChapa,"N1_CHAPA"),"N1_XLOJA")
EndIf  

dbcloseArea()

RestArea(aArea)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR08  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPerg(cPerg)

PutSx1(cPerg,'01','Cliente?','','','mv_ch1','C',6, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','','','','','','','','','','SA1')
PutSx1(cPerg,'02','Patrimonio?','','','mv_ch2','C',6, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'03','POS','','','mv_ch3','C',10, 0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'04','Data de','','','mv_ch4','D',8, 0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'05','Data ate','','','mv_ch5','D',8, 0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'06','Estado','','','mv_ch6','C',2, 0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')                                                                                                                                 


Return                                        
