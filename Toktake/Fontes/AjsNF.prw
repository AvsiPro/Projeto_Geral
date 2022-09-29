#include "tbiconn.ch"
#include "protheus.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJSNF     ºAutor  ³Microsiga           º Data ³  06/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AjsNF()

If cEmpAnt == "01"
	Processa( { || Fproc() },"Aguarde...","Importando notas..")
EndIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJSNF     ºAutor  ³Microsiga           º Data ³  06/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FProc()


Local aArquivos	:= {}
Local oXml		:= Nil
Local cError	:= ""
Local cWarning	:= ""
Local nI
Local nJ
Local nK
Local cFile		:= "" 
Local aPula		:= {}
Local cPath		:= "\system\xmlsaida\" 
Local cPathProc	:= "\system\xmlsaida\processados\"
Local aProc		:= {}
Local cMsg		:= ""
Private aHeader	:= {}
Private n		:= 0  


aArquivos := Directory(cPath +"*.xml")

ProcRegua( Len(aArquivos) )


If !ExistDir( cPathProc )
	MakeDir( cPathProc )
EndIf

For nI := 1 To Len(aArquivos)

	IncProc( "" )
	      
	nRecC5 := 0
	nRecC6 := 0
	aSC6 := {} 
	cNumNf := ""
	cSerie := ""
	cCnpjCli := ""
	cCodCli := ""
	cLoja := "" 
	cInfo := ""
	nPosIni := 0
	cInf2 := "" 
	cCodPa := ""                
	nPosP := 0
	cPedido := ""
	nValTot := 0
	nVol := 0
	nPesBru := 0  
	nPesLiq := 0
	aItens := {}
	cItem := ""
	cProd := ""
	ccFOP := ""
	cUM := ""
	nQtd := 0
	nValor := 0
	nTot := 0  
	cxnfabas := ""
	cFinal := ""
	cChvNfe := ""
	aImposto := {}
	
	cCond := ""
	dEmissao := dDatabase
	cEst := ""
	cTipCli := ""
	cTransp := ""
	cPrefix := ""
	cEPP	:= ""  
	cOpera	:= ""
	cRazao := "" 
	aTES := {}
	lAjTes := .F.
	cCnpjEmit := "" 
	cTes := ""
	cLocal := ""    
	aIT := {}
	aAux := {}
	lGerarPEd := .F.
	cGPV := ""
	cFile := aArquivos[nI][1] 
	cFilAnt := "01"           
	
	
	// Gera o objeto com dados do XML
	oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
	If ValType(oXml) != "O"
		AADD( aPula, { cFile, cError,cWarning,"ERRO ABERTURA"  } )
		Loop
	EndIf
	
 	// Verifica Tag inicial do arquivo XML
	If XmlChildEx( oXml, "_NFEPROC" ) == Nil
		AADD( aPula, { cFile, cError,cWarning,"ERRO ESTRUTURA"  } )
		Loop
	EndIf

	If XmlChildEx( oXml:_NFEPROC:_NFE, "_INFNFE" ) == Nil
		AADD( aPula, { cFile, cError,cWarning,"ERRO ESTRUTURA"  } )
		Loop
	EndIf
	
	cChvNfe := oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
	
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
	cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)
	dEmissao := ctod( cDtEmissao )
	
	// cnpj emitente
	cCnpjEmit := oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
	
	// SM0
	OpenSm0()
	SM0->(dbGoTop())
	While !SM0->(Eof())
		If AllTrim(cCnpjEmit) == AllTrim(SM0->M0_CGC)
			If cFilAnt <> SM0->M0_CODFIL
				cFilAnt := AllTrim(SM0->M0_CODFIL)
				Exit
			EndIf
		EndIf
		SM0->(dbskip())
	EndDo
	  
	    
	// DEST
	cCnpjCli := oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
	dbSelectArea("SA1")
	dbSetOrder(3)
	If MsSeek( xFilial("SA1") +AvKey(cCnpjCli,"A1_CGC") )
		cCodCli := SA1->A1_COD
		cLoja := SA1->A1_LOJA
		cEst := SA1->A1_EST
		cTipCli := SA1->A1_TIPO
		cRazao := SA1->A1_NOME
		cEPP	:= IIF('EPP'$cRazao,'S','N')  
	EndIf
	
	
	// VERIFICA SE NF JA EXISTE - TRATAR CASO DE REPROCESSAMENTO
	cNumNf := PADL( oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT,9,"0" )
	cSerie := oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
	
	dbSelectArea("SF2")
	dbsetOrder(2)
	If MSSeek( cFilAnt +AvKey(cCodCli,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNf,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
		AADD( aPula, { cFile, cError,cWarning,"JA EXISTE"  } )
		//Loop
	EndIf
	
	

	// INFADIC
	cInfo := oXml:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT
	//nPosIni := At( "P.A.:",cInfo )
	//cInf2 := SubStr( cInfo,39,12 ) 
	//cCodPa := SubStr( cInf2,6 )   
	                            
	//nPosP := At( "Pedido",cInfo )
	//cPedObs := SubStr( cInfo,3+8,6 )
	
	aAux := StrToKarr( cInfo,"-" )
	For nJ := 1 To Len( aAux )
		If "Pedido" $ aAux[nJ]
			nPosP := At( "Pedido",aAux[nJ] )
			cPedObs := SubStr( aAux[nJ],nPosP+8,6 )
		EndIf
	Next nJ 
	
	// DADOS DO PEDIDO
	If Empty(cPedOBS)
		cQuery := "SELECT C5_NUM FROM SC5010 WHERE C5_NOTA = '"+cNumNF+"' AND C5_FILIAL = '"+xFilial("SC5")+"' AND D_E_L_E_T_ = '' "
		MpSysOpenQuery( cQuery,"TRB" )
		dbSelectArea("TRB")
		cPedido := TRB->C5_NUM
	Else
		cPedido := cPedOBS
	EndIf	
	
	
	If !Empty(cPedido)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If !MSSeek( xFilial("SC5") +AvKey(cPedido,"C5_NUM") ) 
			lGerarPed := .T.
		Else
			nRecC5 := REcno() 
			                                                
			cCodPA := SC5->C5_XCODPA
			cxnfabas := SC5->C5_XNFABAS
			cFinal := SC5->C5_XFINAL
			cCond := SC5->C5_CONDPAG
			cTransp := SC5->C5_TRANSP
			
		
			dbSelectArea("SC6")
			dbSetOrder(1)
			If MSSeek( xFilial("SC6") +AvKey(SC5->C5_NUM,"C6_NUM") )
			
				While SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM
				
					AADD( aSC6, { AllTrim(SC6->C6_ITEM), AllTrim(SC6->C6_PRODUTO), SC6->C6_TES, Recno(), SC6->C6_LOCAL } )
				   
					SC6->( dbSkip() )
				End
			
			EndIf
		EndIf    
	Else
		lGerarPed := .T.
	EndIf
	            
	
	If lGerarPed
		lGerarPed := .F.
		AADD( aPula, { cFile, "","","SEM PEDIDO"  } )
	EndIf
		 
	cNumPed := ""
	If lGerarPed	
		cNumPed := cPedido
		lVldPedido := STATICCALL( TTPROC25, VldNumPed, cNumPed,cFilAnt )
		While !lVldPedido
			cNumPed := GetSX8NUM("SC5","C5_NUMERO")
			lVldPedido := STATICCALL( TTPROC25, VldNumPed, cNumPed,cFilAnt )
			If !lVldPedido
				RollBackSx8()
			EndIf
		End	
	EndIf
	
	// TOTAL
	nValTot := VAL( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT )
	nValProd := VAL( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:TEXT )
	
	// TRANSP
	nVol := VAL( oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT )
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL, "_PESOB" ) <> Nil
		nPesBru := VAL( oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT )   
		nPesLiq := VAL( oXml:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT )
	EndIf
	
	// DET - ITENS                                    
	If ValType( oXml:_NFEPROC:_NFE:_INFNFE:_DET ) == "O"
		XmlNode2Arr( oXml:_NFEPROC:_NFE:_INFNFE:_DET,"_DET" )	
	EndIf 
	aItens := Aclone( oXml:_NFEPROC:_NFE:_INFNFE:_DET )

	For nJ := 1 To Len( aItens )
	
		cTes := ""
		cLocal := ""
		nRecC6 := 0
	
		cItem := PADL( aItens[nJ]:_NITEM:TEXT,TamSX3("D2_ITEM")[1], "0" )
		cProd := aItens[nJ]:_PROD:_CPROD:TEXT
		ccFOP := aItens[nJ]:_PROD:_CFOP:TEXT
		cUM := aItens[nJ]:_PROD:_UCOM:TEXT
		nQtd := Val( aItens[nJ]:_PROD:_QCOM:TEXT )
		nValor := VAL( aItens[nJ]:_PROD:_VUNCOM:TEXT ) 
		nTot := VAL ( aItens[nJ]:_PROD:_VPROD:TEXT )
		  
		
		// array produtos x TES                                    
		AADD( aTES, { cProd, cTes } ) 
		//AADD( aImposto, { cProd,  } )
		                              
		For nK := 1 To Len( aSC6 )
			If aSC6[nK][1] == cItem
				cTes := aSC6[nK][3]   
				nRecC6 := aSC6[nK][4] 
				cLocal := aSC6[nK][5] 
				Exit
			EndIf
		Next nK
		
		If Empty( cLocal )
			cLocal := Posicione( "SB1",1,xfilial("SB1") +aVKEY(cProd,"B1_COD"),"B1_LOCPAD" )
		EndIf
				
		AADD( aIT, { cItem,;
					cProd,;
					cUM,;
					nQtd,;
					nValor,;
					nTot,;
					cTes,;
					ccFOP,;
					cLocal  } )

	Next nJ
	        
	
	// finalidade?
	If Empty(cFinal)
		nTipo := Aviso( "","Escolha a finalidade de venda do pedido." +CRLF +cInfo,{"Abastecimento - 4","Venda - 2", "Doses - J"},3 )
		If nTipo == 1
			cFinal := "4"
			cxnfabas := "1"
		ElseIf nTipo == 2
			cFinal := "2"
			cxnfabas := "2"
		ElseIf nTipo == 3 		       
			cFinal := "J"
			cxnfabas := "2"
		EndIf
		/*
		If cCodCli == "000001" .And. cLoja == "0001"
			cFinal := "4"
			cxnfabas := "1"
		Else
			cFinal := "2"
			cxnfabas := "2"	
		EndIf
		*/
	EndIf
	
	// preencher TES
	// ESCOLHER O GRUPO
	If lGerarPed
		nGrupo := 1
		nGrupo := Aviso( "GPV","Escolha a grupo de venda do pedido." +CRLF +cInfo,{"PRO-A","PCA"},3 )
		If nGrupo == 1
			cGPV := "PRO-A"
		ElseIf nGrupo == 2
			cGPV := "PCA"
		EndIf
		
		cOpera	:= U_TTOPERA( cGPV,cTipCli,cFinal,cEPP )
		For nJ := 1 To Len( aTes )
			cTes := MaTesInt( 2,cOpera,cCodCli,cLoja,"C",aTES[nI][1],"C6_TES" )
			aTES[nJ][2] := cTes
			If Empty(cTes)
				lAjTes := .T.
			EndIf
		Next nJ
		
		If lAjTes
			aTES := U_TTFAT26C( aTES )
		EndIf
	EndIf
	
	
	For nJ := 1 To Len( aIT )
		                     
		cItem := aIT[nJ][1]
		cProd := aIT[nJ][2]
		cUM := aIT[nJ][3]
		nQtd := aIT[nJ][4]
		nValor := aIT[nJ][5]
		nTot := aIT[nJ][6]
		cLocal := aIT[nJ][9]
				
		cTes := ""
	
		If nRecC6 > 0
			dbSelectArea("SC6")
			dbGoTo(nRecC6)
			RecLock("SC6",.F.)
			SC6->C6_NOTA := cNumNf
			SC6->C6_SERIE := cSerie
			MsUnLock()
		Else
			If lGerarPed
				For nK := 1 To Len( aTES )
					If aTES[nK][1] == cProd
						cTes := aTES[nK][2]
						cCfop := Posicione( "SF4",1,xFilial("SF4") +AvKey(cTes,"F4_CODIGO"),"F4_CF" )
						Exit
					EndIf
				Next nK
			
				// gravar os itens do pedido
				dbSelectArea("SC6")
				RecLock("SC6",.T.)
				SC6->C6_FILIAL	:= xFilial("SC6")
				SC6->C6_NUM		:= cNumPed
				SC6->C6_CLI		:= cCodCli
				SC6->C6_LOJA	:= cLoja
				SC6->C6_ITEM	:= cItem
				SC6->C6_PRODUTO	:= cProd
				SC6->C6_PRCVEN	:= nValor
				SC6->C6_QTDVEN	:= nQtd
				SC6->C6_VALOR	:= nTot
				SC6->C6_TES		:= cTes
				SC6->C6_CF		:= cCfop
				SC6->C6_NOTA	:= cNumNf
				SC6->C6_SERIE	:= cSerie
				Msunlock()
			 EndIf
		EndIf
	      
		//gravar os itens              
		dbSelectArea("SD2")
		dbSetOrder(3)	// doc serie cliente loja produto item
		If !MSSeek( cFilAnt +AvKey(cNumNF,"D2_DOC") +AvKey(cSerie,"D2_SERIE") +AvKey(cCodCli,"D2_CLIENTE") +AvKey(cLoja,"D2_LOJA")  +Avkey(cProd,"D2_COD") +AvKey(cItem,"D2_ITEM") )
			RecLock("SD2",.T.)
			SD2->D2_FILIAL	:= xFilial("SD2")
			SD2->D2_DOC		:= cNumNF
			SD2->D2_SERIE	:= cSerie
			SD2->D2_EMISSAO	:= dEmissao
			SD2->D2_ITEM	:= cItem 
			SD2->D2_COD		:= cProd
			SD2->D2_UM		:= cUM
			SD2->D2_QUANT	:= nQtd
			SD2->D2_PRCVEN	:= nValor
			SD2->D2_TOTAL	:= nTot 
			SD2->D2_TES		:= cTes 
			SD2->D2_CF		:= cCfOP 
			SD2->D2_PEDIDO	:= cNumPed
			SD2->D2_ITEMPV	:= cItem
			SD2->D2_CLIENTE	:= cCodCli
			SD2->D2_LOJA	:= cLoja
			SD2->D2_LOCAL	:= cLocal
			SD2->D2_NUMSEQ	:= PROXNUM() 
		
			SD2->( MsUnLock() )  
		EndIf 
	
	Next nJ
	       
	// gravar o cabecalho
	dbSelectArea("SF2")
	dbsetOrder(2)
	If !MSSeek( cFilAnt +AvKey(cCodCli,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNf,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
		dbSelectArea("SF2")
		RecLock("SF2",.T.)     
		SF2->F2_FILIAL	:= xfilial("SF2")
		SF2->F2_DOC		:= cNumNF
		SF2->F2_SERIE	:= cSerie
		SF2->F2_CLIENTE	:= cCodCli
		SF2->F2_LOJA	:= cLoja
		SF2->F2_VALBRUT	:= nValTot
		SF2->F2_XNFABAS	:= cxnfabas
		SF2->F2_XCODPA	:= cCodPa
		SF2->F2_XFINAL	:= cFinal 
		SF2->F2_VOLUME1	:= nVol
		SF2->F2_COND	:= cCond
		SF2->F2_EMISSAO	:= dEmissao
		SF2->F2_EST		:= cEst
		SF2->F2_TIPOCLI	:= cTipCli
		SF2->F2_VALMERC	:= nValProd
		SF2->F2_TIPO	:= "N"
		SF2->F2_ESPECI1	:= "UN"
		SF2->F2_PLIQUI	:= nPesLiq
		SF2->F2_PBRUTO	:= nPesBru
		SF2->F2_TRANSP	:= cTransp
		SF2->F2_VALFAT	:= nValTot
		SF2->F2_ESPECIE	:= "SPED" 
		SF2->F2_CHVNFE	:= cChvNfe
		SF2->F2_DUPL	:= cNumNF
		SF2->F2_PREFIXO	:= cPrefix
		SF2->( MsUnLock() )
	EndIf

	          
	If nRecC5 > 0
		dbSelectArea("SC5")
		dbGoto(nRecC5)
		RecLock("SC5",.F.) 
		SC5->C5_NOTA := cNumNf
		SC5->C5_SERIE := cSerie
		MsUnlock()
	Else
		If lGerarPed
			// gravar o pedido
			dbSelectArea("SC5")
			RecLock("SC5",.T.)
			SC5->C5_FILIAL	:= xFilial("SC5")
			SC5->C5_NUM		:= cNumPed
			SC5->C5_CLIENTE	:= cCodCli
			SC5->C5_LOJACLI	:= cLoja
			SC5->C5_CLIENT	:= cCodCli
			SC5->C5_LOJAENT	:= cLoja                       
			SC5->C5_XFINAL	:= cFinal
			SC5->C5_XNFABAS	:= cxnfabas
			SC5->C5_XCODPA	:= cCodPa
			SC5->C5_NOTA	:= cNumNf
			SC5->C5_SERIE	:= cSerie
			SC5->C5_XDTENTR	:= dEmissao
			MsUnlock() 
		EndIf
	EndIf
	
	
	U_TTMAILN('microsiga@toktake.com.br','rjesus@toktake.com.br','XML NF saida',"NF: " +cNumNF + "/" +cSerie  +" -> OK",{},.F.) 
	
	
	// mover arquivo
	FRename( cPath+cFile, cPathProc+cFile)					
	
Next nI


cMsg := ""
For nI := 1 To Len(aPula)
	cMsg += "Arquivo: " +aPula[nI][1] +" -> " +aPula[nI][4] +CRLF
Next nI

If !Empty(cMsg)
	U_TTMAILN('microsiga@toktake.com.br','rjesus@toktake.com.br',cMsg,{},.F.) 
EndIf


Return