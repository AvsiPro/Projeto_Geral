

#include "tbiconn.ch"


User Function TTIMPSE2()

Local aVetor := {}
Local cFile		:= "C:\temp\pagar_amc_cod.csv"     //arquivo a ser importado
Local nHandle 	:= FT_FUse(cFile)
Local cLine		:= ""
Local nX		:= 0
Private lmsErroAuto	:=	.F.


Prepare Environment EMPRESA "10" FILIAL "01"


nHandle := FT_FUse(cFile)

FT_FGoTop()

While !FT_FEOF() 
	//Cabecalho do arquivo a ser importado
	If nX == 0
		nX++
	Else
		aItens := StrToKarr(FT_FReadLn(),";")   
		If Len(aItens) < 17
			FT_FSKIP()
			Loop
		EndIf
		
	
		cUnidN := Alltrim( aItens[4] )
		cPref := aItens[5]
		cNum := aItens[6] 
		cParc := aItens[7]
		cNat := ""
		cForn := aItens[16]
		cLoja := aItens[17]
		cNomeFor := Posicione( "SA2",1,xFilial("SA2") +AvKey(cForn,"A2_COD") +AvKey(cLoja,"A2_LOJA"),"A2_NOME" )
		dEmiss := ctod(aItens[10])
		dVenc := ctod(aItens[2])
		dVencR := ctod(aItens[2])
		dVencOr := ctod(aItens[3])
		
		//nValor := val(aItens[8]) 
		//nSaldo := val(aItens[9])
		
		cValAux := StrTran(aItens[8],",",".")     
		nValor := Val(cValAux)           
		
		cSldAux := StrTran(aitens[9],",",".")
		nSaldo := Val(cSldAux)
		
		cObsHis := aItens[15]
	
		cNatur := "20101001"       
		
		If cParc == "x"
			cParc := ""
		EndIf  
		
		If cObsHis == "x"
			cObsHis := ""
		EndIf        
		
		
		If cUnidN == "A MAQUINA DE CAFÉ - CENTRO"
			cFilAnt := "03"
		ElseIf cUnidN == "A MAQUINA DE CAFÉ - MATRIZ"
			cFilAnt := "01"
		ElseIf cUnidN == "A MAQUINA DE CAFÉ  - SUL"
			cFilAnt := "02"
		ElseIf cUnidN == "A MAQUINA DE CAFÉ - OESTE"
			cFilAnt := "04"
		EndIf
		
		dbSelectArea("SE2")
		dbSetOrder(1)	// prefixo titulo parcela tipo FORNECEDOR LOJA
		If !MsSeek( xFilial("SE2") +AvKey(cPref,"E2_PREFIXO") +AvKey(cNUm,"E2_NUM") +AvKey(cParc,"E2_PARCELA") +AvKey("NF","E2_TIPO") +AvKey(cForn,"E2_FORNECE") +AvKey(cLoja,"E2_LOJA") )
			RecLock("SE2",.T.)
			SE2->E2_FILIAL := xfilial("SE2")
			SE2->E2_PREFIXO := cPref
			SE2->E2_NUM := cNum
			SE2->E2_PARCELA := cParc 
			SE2->E2_TIPO := "NF"
			SE2->E2_NATUREZ := cNatur
			SE2->E2_FORNECE := cForn
			SE2->E2_LOJA := cLoja
			SE2->E2_EMISSAO := dEmiss
			SE2->E2_VENCTO := dVenc
			SE2->E2_VENCREA := dVenc
			SE2->E2_VALOR := nValor
			SE2->E2_NOMFOR := cNOmeFor
			SE2->E2_EMIS1 := dEmiss
			SE2->E2_HIST := cObsHis
			SE2->E2_SALDO := nSaldo
			SE2->E2_VENCORI := dVencOr
			SE2->E2_MOEDA := 1
			SE2->E2_VLCRUZ := nValor
			//SE2->E2_MSFIL := cfilAnt
			SE2->E2_FILORIG := cFilAnt
			MsUnlock()
		Else/*
			RecLock("SE2",.F.)
			SE2->E2_VALOR := nValor
			SE2->E2_SALDO := nSaldo
			MsUnLock()*/
		EndIf
		
		/*
		AADD(aVetor, {"E2_PREFIXO", cPref						, Nil})
		aAdd(aVetor, {"E2_NUM"    , cNum		 				, Nil})
		aAdd(aVetor, {"E2_PARCELA", ""							, Nil})
		aAdd(aVetor, {"E2_TIPO"   , "NF"			 			, Nil})
		aAdd(aVetor, {"E2_NATUREZ", cNatur			, Nil})
		aAdd(aVetor, {"E2_FORNECE", cForn		 				, Nil})
		aAdd(aVetor, {"E2_LOJA"   , cLoja		 				, Nil})
		aAdd(aVetor, {"E2_EMISSAO", dEmiss				 		, Nil})
		aAdd(aVetor, {"E2_VENCTO" , dVenc				 		, Nil})
		aAdd(aVetor, {"E2_VENCREA", dVencR						, Nil})
		aAdd(aVetor, {"E2_VALOR"  , nValor						, Nil})
		aAdd(aVetor, {"E2_NOMFOR" , cNomeFor					, Nil})
		aAdd(aVetor, {"E2_EMIS1"  , dEmiss		 				, Nil})
		aAdd(aVetor, {"E2_HIST"   , cHist						, Nil})
		aAdd(aVetor, {"E2_SALDO"  , nSaldo		 				, Nil})
		aAdd(aVetor, {"E2_VENCORI", dVencOr						, Nil})
		aAdd(aVetor, {"E2_MOEDA"  , 1 							, Nil})
		aAdd(aVetor, {"E2_VLCRUZ" , nValor						, Nil})
		aAdd(aVetor, {"E2_MSFIL"  , xFilial("SE2") 				, Nil})
		aAdd(aVetor, {"E2_ORIGEM" , "MATA103"					, Nil}) 
			
	
		MSExecAuto({|x,y,z| Fina050(x,y,z)}, aVetor,, 3) 
		
		If lmsErroAuto
			MostraErro()
		EndIf 
		*/ 
	EndIf
	
	FT_FSKIP()
EndDo         

FClose(nHandle)

FT_FUSE()	
	
Return



User Function TTIMPSE1()


Local aArray := {}
Local cFile		:= "C:\temp\receber_amc.csv"     //arquivo a ser importado
Local nCount 	:= 0
Local nX		:= 0   
Local lGrava	:= .t.
Private lmsErroAuto	:=	.F.



Prepare Environment EMPRESA "10" FILIAL "01"


nHandle := FT_FUse(cFile)

FT_FGoTop()

While !FT_FEOF() 
	//Cabecalho do arquivo a ser importado
	If nX == 0
		nX++
	Else
		aItens := StrToKarr(FT_FReadLn(),";")   
		If Len(aItens) < 16
			FT_FSKIP()
			Loop
		EndIf
	
		dINc := ctod(aItens[1])
		dVenc := ctod(aItens[2])
		dVencO := ctod(aItens[3])
		
		cUnidN := AllTrim(aItens[4])
		cPref := aItens[5]
		cNum := aItens[6]
		cParc := aItens[8]         
		                             
		//cValAux := StrTran(aItens[10],".","")
		cValAux := StrTran(aItens[10],",",".")     
		nValor := Val(cValAux)     
		                               
		//cSldAux := StrTran(aitens[11],".","")
		cSldAux := StrTran(aitens[11],",",".")
		nSaldo := Val(cSldAux)
		
		//nValor := val(aItens[10])
		//nSaldo := val(aItens[11])
		               
		dEmiss := ctod(aItens[12])
		
		cEmpCigam := aItens[14]
		cObsHist := aItens[16]
		
		If cParc == "x"
			cParc := ""
		EndIf 
		
		If cObsHist == "x"
			cObsHist := ""
		EndIf
	
		cNatur := "10101001"
		
		cCliente := ""
		cLoja := ""
		//cNatur := ""	// VER COM FINANCEIRO
		
		ChkCli( cEmpCigam,@cCliente,@cLoja )
		
		
		If cUnidN == "A MAQUINA CAFÉ CENTRO"
			cFilAnt := "03"
		ElseIf cUnidN == "A MAQUINA DE CAFÉ - MATRIZ"
			cFilAnt := "01"
		ElseIf cUnidN == "A MAQUINA CAFÉ SUL"
			cFilAnt := "02"
		ElseIf cUnidN == "A MAQUINA CAFÉ OESTE"
			cFilAnt := "04"
		EndIf
		
		If lGrava
			dbSelectArea("SE1")
			dbSetOrder(1)	// prefixo titulo parcela tipo
			If !MsSeek( xFilial("SE1") +AvKey(cPref,"E1_PREFIXO") +AvKey(cNUm,"E1_NUM") +AvKey(cParc,"E1_PARCELA") +AvKey("NF","E1_TIPO") )
				RecLock("SE1",.T.)
				SE1->E1_FILIAL := xFilial("SE1")
				SE1->E1_PREFIXO := cPref
				SE1->E1_NUM := cNUm
				SE1->E1_TIPO := "NF"
				SE1->E1_PARCELA := cParc
				SE1->E1_NATUREZ := cNatur
				SE1->E1_CLIENTE := cCliente
				SE1->E1_LOJA := cLoja
				SE1->E1_NOMCLI := Posicione( "SA1",1,xFilial("SA1") +AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA"),"A1_NOME" )
				SE1->E1_EMISSAO := dEmiss
				SE1->E1_VENCTO := dVenc
				SE1->E1_VENCREA := dVenc
				SE1->E1_VENCORI := dVencO
				SE1->E1_VALOR := nValor
				SE1->E1_HIST := cObsHist
				SE1->E1_SALDO := nSaldo
				SE1->E1_FILORIG := cFilAnt
				SE1->E1_MSFIL := cFilAnt 
				MsUnLock()
			ELSE
				If Empty(SE1->E1_CLIENTE)
					RecLock("SE1",.F.)
					//SE1->E1_FILORIG := cFilAnt
					//SE1->E1_MSFIL := cFilAnt 
					SE1->E1_CLIENTE := cCliente
					SE1->E1_LOJA := cLoja
					//SE1->E1_VALOR := nValor
					//SE1->E1_SALDO := nSaldo
					MsUnLock()
				EndIf
			EndIf
		EndIf
		
		/*
		aArray := { { "E1_PREFIXO"  , cPref             	, NIL },;
		            { "E1_NUM"      , cNum	            	, NIL },;
		            { "E1_TIPO"     , "NF"              	, NIL },;
		            { "E1_NATUREZ"  , cNatur           		, NIL },;
		            { "E1_CLIENTE"  , cCliente         		, NIL },;
		            { "E1_LOJA"  	, cLoja         		, NIL },;
		            { "E1_EMISSAO"  , dEmiss				, NIL },;
		            { "E1_VENCTO"   , dVenc					, NIL },;
		            { "E1_VENCREA"  , dVenc					, NIL },;
		            { "E1_VENCORI"	, dVencO				, NIL },;
		            { "E1_VALOR"    , nValor              	, NIL },;
		            { "E1_HIST"		, cObsHist				, NIL },;
		            { "E1_SALDO"	, nSaldo				,	NIL}}
		 
		MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3) 

		If !lMsErroAuto
			nCount++
		Else
			Conout("ttimpse1;"+cNum)	
		EndIf
		*/
	EndIf
	
	FT_FSKIP()
EndDo         

FClose(nHandle)

FT_FUSE()	

Return


Static Function ChkCli( cEmpCigam,cCliente,cLoja )

Local cQuery := ""

cQuery := "SELECT A1_COD, A1_LOJA FROM SA1100 WHERE A1_XCODANT = '"+cEmpCigam+"' "

MpSysOpenQuery( cQuery,"TRB" )

dbSelectArea("TRB")

cCliente := TRB->A1_COD
cLoja := TRB->A1_LOJA


Return
