#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFATC21C ºAutor  ³Jackson E. de Deus  º Data ³  27/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclusao de Pedido de Venda								  º±±
±±º          ³Abastecimento												  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson	       ³27/04/15³01.00 |Criacao                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTFAT21C( cCodCli,cLoja,axItens,cNumOS,axCab,cCusto )

Local aArea			:= GetArea()
Local aCab			:= {}
Local aItens		:= {}
Local nOpcAuto		:= 3		// OPERACAO - inclusao
Local cPrePed		:= "N"
Local cNumPed		:= ""
Local cMenNota		:= ""
Local cCondPg		:= "020"	// condicao pagamento
Local cTransp		:= "000019"	// transportadora
Local cVend			:= "000001"	// vendedor
Local nVol			:= 0
Local cxgpv			:= "PRO-A"
Local cCodPa		:= ""		// definir PA pelo patrimonio da OS
Local cItem			:= "00"
Local cLocal		:= "D00001"
Local cTes			:= ""	//581 definir TES
Local cProduto		:= ""
Local nQuant		:= 0
Local nPreco		:= 0
Local nTotProd		:= 0
Local cItemCC		:= ""	//Posicione("ZZ1",1,xFilial("ZZ1") +cArmazem,"ZZ1_ITCONT")	
Local nCont			:= 0
Local cFinal		:= ""
Local aTES			:= {}
Local aProds		:= {}
Local lAjustaTES	:= .F. 
Local cTpPag		:= ""
Local aBlqLoc		:= {}
Local aBlqProd		:= {}
Local lBlQSA1		:= .F.
Local aCustProd		:= {}
Local lVldPedido	:= .F.
Private lMsErroAuto	:= .F.
Private aHeader		:= {}
Private n			:= 0
Default cCodCli		:= ""
Default cLoja		:= ""
Default axItens		:= {}
Default cNumOS		:= ""
Default axCab		:= {}
Default cCusto		:= ""	// centro de custo?????

If cEmpAnt <> "01"
	Return
EndIF

dbSelectArea("SA1")
dbSetOrder(1)
If !MSSeek( xFilial("SA1")+AvKey(cCodCli,"A1_COD")+AvKey(cLoja,"A1_LOJA") )
	Return cNumPed
EndIf

cFinal	:= axCab[ascan(axCab,{|x| Alltrim(x[1]) == "C5_XFINAL"})][2]
cCondPg := axCab[ascan(axCab,{|x| Alltrim(x[1]) == "C5_CONDPAG"})][2]
cTpPag	:= axCab[ascan(axCab,{|x| Alltrim(x[1]) == "C5_XTPPAG"})][2]
cPrePed := axCab[ascan(axCab,{|x| Alltrim(x[1]) == "C5_XPREPED"})][2]
cCodPa	:= axCab[ascan(axCab,{|x| Alltrim(x[1]) == "C5_XCODPA"})][2]
cMenNota := axCab[ascan(axCab,{|x| Alltrim(x[1]) == "C5_MENNOTA"})][2]

cTipoCli := Posicione( "SA1",1,xFilial("SA1")+AvKey(cCodCli,"A1_COD")+AvKey(cLoja,"A1_LOJA"),"A1_TIPO" )                              
cRazao   := Posicione("SA1",1,xFilial("SA1") +AvKey(cCodCli,"A1_COD")+AvKey(cLoja,"A1_LOJA"),"A1_NOME" )
cEPP	:= IIF('EPP'$cRazao,'S','N')    
cOpera	:= U_TTOPERA(cxgpv,cTipoCli,cFinal,cEPP)

While !lVldPedido
	cNumPed := GetSX8NUM("SC5","C5_NUMERO")
	lVldPedido := STATICCALL( TTPROC25, VldNumPed,cNumPed,cFilAnt)
	If !lVldPedido
		RollBackSx8()
	EndIf
End

dbSelectArea("SX3")
dbSetOrder(2)
MsSeek( "C6_TES" )
Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,"",SX3->X3_TIPO,"","" })	


For nI := 1 To Len(axItens)
	If AScan( aTES, { |x| x[1] == axItens[nI][1] } ) == 0
		AADD( aTES, { axItens[nI][1], "" } )
	EndIf
Next nI

dbSelectArea("SB2")
dbSetOrder(1)
For nI := 1 To Len(aTES)
	n := nI 
	cTes := MaTesInt(2,cOpera,cCodCli,cLoja,"C",aTES[nI][1],"C6_TES")
	If Empty(cTes)
		lAjustaTES := .T.
		aTES[nI][2] := Space(3)
	Else
		aTES[nI][2] := cTes
	EndIf	
Next nI

If lAjustaTES
	aTES := U_TTFAT26C( aTES )
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
If MsSeek( xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
	If AllTrim(SA1->A1_MSBLQL) == "1"
		RecLock("SA1",.F.)
		SA1->A1_MSBLQL := "2"
		MsUnLock()
		lBlQSA1 := .T.
	EndIf
EndIf

cCusto := "70500001"	
For nI := 1 To Len(axItens)
	cItem := Soma1(cItem)
	cProduto := axItens[nI][1]
	nQuant := axItens[nI][2]
	nPreco := axItens[nI][3]
	cLocal := axItens[nI][5]
	cItemCC := Posicione("ZZ1",1,xFilial("ZZ1") +cLocal,"ZZ1_ITCONT")	

	dbSelectArea("ZZ1")
	dbSetOrder(1)
	If MsSeek( xFilial("ZZ1") +AvKey(cLocal,"ZZ1_COD") )
		If AllTrim(ZZ1->ZZ1_MSBLQL) == "1"
			RecLock("ZZ1",.F.)
			ZZ1->ZZ1_MSBLQL := "2"
			MsUnLock()            
			AADD( aBlqLoc, cLocal )
		EndIf
	EndIf
	  
	dbSelectArea("SB1")
	dbSetOrder(1)
	If MsSeek( xFilial("SB1") +AvKey(cProduto,"B1_COD") )
		If AllTrim(SB1->B1_MSBLQL) == "1"
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "2"
			MsUnlock()           
			AADD( aBlqProd, cProduto )
		EndIf
		If SB1->B1_CUSTD == 0
			RecLock("SB1",.F.)
			SB1->B1_CUSTD := 1
			MsUnlock()
			AADD( aCustProd, cProduto )           	
		EndIf
	EndIf
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !MSSeek( cFilAnt +AvKey(cProduto,"B1_COD") +Avkey(cLocal ,"B2_LOCAL") )
		CriaSB2(cProduto,cLocal)
	Endif
	             
	For nJ := 1 To Len(aTES)
		If aTES[nJ][1] == cProduto
			cTes := aTES[nJ][2]
			Exit
		EndIf
	Next nJ
		
	AADD( aItens,{{"C6_FILIAL"	 	,cFilAnt				,Nil},;
					{"C6_NUM"    	,cNumPed				,Nil},;
					{"C6_CLI"		,cCodCli				,Nil},;
					{"C6_LOJA"		,cLoja		  			,Nil},;
					{"C6_ITEM"   	,cItem 					,Nil},;
					{"C6_PRODUTO"	,cProduto				,Nil},;
					{"C6_QTDVEN" 	,nQuant					,Nil},;
					{"C6_XQTDORI"	,nQuant					,Nil},;
					{"C6_PRCVEN"	,nPreco		  			,Nil},;
					{"C6_PRUNIT"	,nPreco		  			,Nil},;
					{"C6_VALOR"		,Round(nQuant*nPreco,6)	,Nil},;
					{"C6_LOCAL"		,cLocal			 		,Nil},;
					{"C6_TES"		,cTes					,Nil},;
					{"C6_TPOP"		,"F"					,Nil},;					
					{"C6_CCUSTO"	,cCusto					,Nil},;
					{"C6_ITEMCC"	,cItemCC				,Nil},;
					{"C6_ENTREG"	,dDataBase	 			,Nil},;
					{"C6_UM"		,Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_UM")		,Nil},;
					{"C6_SEGUM"		,Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_SEGUM")	,Nil},;
					{"C6_XGPV"		,cxgpv			 		,Nil},;
					{"C6_ENTREG"	, dDatabase				,Nil},;
					{"C6_XDTEORI"	,dDataBase				,Nil},;
					{"C6_XHRINC"	,Time()					,Nil},;
					{"C6_XDATINC"	,Date()		 			,Nil},;
					{"C6_XUSRINC"	,cUsername 	 			,Nil}}) 
					
    
	nVol += nQuant
Next nI


// montar cabecalho
AADD( aCab, {"C5_FILIAL" 	,cFilAnt			,Nil})
AADD( aCab,	{"C5_NUM"    	,cNumPed			,Nil})
AADD( aCab,	{"C5_TIPO"   	,"N"      			,Nil})
AADD( aCab,	{"C5_CLIENTE"	,cCodCli 			,Nil})
AADD( aCab,	{"C5_LOJACLI"	,cLoja				,Nil})
AADD( aCab,	{"C5_CLIENT"	,cCodCli 			,Nil})
AADD( aCab,	{"C5_LOJAENT"	,cLoja				,Nil})
AADD( aCab,	{"C5_XDTENTR"	,dDatabase			,Nil})
AADD( aCab,	{"C5_XNFABAS"	,"2"				,Nil})
AADD( aCab,	{"C5_XCODPA"	,cCodPa				,Nil})
AADD( aCab,	{"C5_XFINAL" 	,cFinal				,Nil})
AADD( aCab,	{"C5_TRANSP" 	,cTransp			,Nil})
AADD( aCab,	{"C5_XTPCARG"	,"1"				,Nil})      
AADD( aCab,	{"C5_XHRPREV"	,"00:00"			,Nil})  
AADD( aCab,	{"C5_CONDPAG"	,cCondPg			,Nil})
AADD( aCab,	{"C5_MOEDA"		,1 					,Nil})
AADD( aCab,	{"C5_FRETE"		,0 					,Nil})
AADD( aCab,	{"C5_TXMOEDA"	,0 					,Nil})
AADD( aCab,	{"C5_EMISSAO"	,dDatabase			,Nil})
AADD( aCab,	{"C5_MENNOTA"	,cMenNota			,Nil})
AADD( aCab,	{"C5_ESPECI1"	,"UN"				,Nil})
AADD( aCab,	{"C5_XHRINC"	,Time()				,Nil})
AADD( aCab,	{"C5_XDATINC"	,Date()				,Nil})
AADD( aCab,	{"C5_XNOMUSR"	,cUserName			,Nil})
AADD( aCab,	{"C5_XCODUSR"	,__cUserID			,Nil})
AADD( aCab,	{"C5_XDESCLI"	,cRazao				,Nil})
AADD( aCab,	{"C5_TPFRETE" 	,"C" 				,Nil})
AADD( aCab,	{"C5_TIPOCLI"	,cTipoCli			,Nil})
AADD( aCab,	{"C5_TIPLIB" 	,"1"         		,Nil})
AADD( aCab,	{"C5_VEND1"  	,"000023"			,Nil})
AADD( aCab,	{"C5_VOLUME1"	,nVol				,Nil})
AADD( aCab,	{"C5_XTPPAG"	,cTpPag				,Nil})
AADD( aCab,	{"C5_XGPV"	 	,cxgpv				,Nil})
Aadd( aCab, {"C5_XCCUSTO"	,cCusto				,Nil})
Aadd( aCab, {"C5_XITEMCC"	,cItemCC			,Nil})
//Aadd( aCab, {"C5_XMESREF"	,cMesRef			,Nil})
AADD( aCab,	{"C5_XPREPED"	,cPrePed			,Nil})	// controle - pedido originado de fechamento de faturamento
AADD( aCab,	{"C5_XNUMOS"	,cNumOS				,Nil})	// controle - OS de origem


MSExecAuto( { |x,y,z| MATA410(x,y,z) },aCab,aItens,nOpcAuto )

dbSelectArea("SC5")
dbSetOrder(1)
If MSSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
	ConfirmSx8()
	CONOUT( "#TTFAT21C -> PEDIDO GERADO: " +cNumPed +" - REF OS: " +cNumOS )            
Else
	RollBackSx8()
	cNumPed := ""
	If lMsErroAuto
		MostraErro()
	EndIf
EndIf          
 

If lBlQSA1
	dbSelectArea("SA1")
	dbSetOrder(1)
	If MsSeek( xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
		RecLock("SA1",.F.)
		SA1->A1_MSBLQL := "1"
		MsUnLock()
	EndIf	
EndIf

If !Empty(aBlqLoc)
	dbSelectArea("ZZ1")
	For nI := 1 To Len(aBlqLoc)
		If MsSeek( xFilial("ZZ1") +AvKey(cLocal,"ZZ1_COD") )		
			RecLock("ZZ1",.F.)
			ZZ1->ZZ1_MSBLQL := "1"
			MsUnLock()            
		EndIf
	Next nI
EndIf

If !Empty(aBlqProd)
	dbSelectArea("SB1")
	For nI := 1 To Len(aBlqProd)
		If MsSeek( xFilial("SB1") +AvKey(aBlqProd[nI],"B1_COD") )
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "1"
			MsUnlock()           
		EndIf
	Next nI
EndIf

If !Empty(aCustProd)
	dbSelectArea("SB1")
	For nI := 1 To Len(aCustProd)
		If MsSeek( xFilial("SB1") +AvKey(aCustProd[nI],"B1_COD") )
			RecLock("SB1",.F.)
			SB1->B1_CUSTD := 0
			MsUnlock()           
		EndIf
	Next nI
EndIf

RestArea(aArea)

Return cNumPed