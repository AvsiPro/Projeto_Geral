#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC41  บAutor  ณMicrosiga           บ Data ณ  06/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o retorno da OS de instalacao/remocao de maquina  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC41(aDados)

Local nAgente := 0
Local cCodCli := ""
Local cLoja := ""
Local cOSMobile := ""
Local dDtIni := stod("")
Local cHrIni :=  ""
Local dDtFim := stod("")
Local cHrFim := ""
Local nRecSN1 := 0
Local nRecSZN := 0
Local cPatr := ""
Local cCodTec := ""
Local cSuperVsor := ""
Local cRota := ""
Local cNomAg := ""
Local cProduto := ""
Local nPosO := 0
Local cOmm := ""
Local lRemov := .F.
Local cRota := "" 
Local nLimtro := 0
Local cCodPa := ""
Local cSisPg := ""
Local cTpCnt := ""
Local cBotP := ""
Local cmailf := ""
Local nPosP := 0
Local nPosC := 0
Local nPosS := 0
Local nPosL := 0
Local nPosT := 0
Local nPos1 := 0
Local nRecUD := 0
Local cTabela := ""
Local cTempo := ""
Local cCont1 := ""
Local cTensao := ""
Local cLocIns := ""
Local cMsg := ""
Local aModf := {}
Local nRecPos := 0
Local cCont1 := ""
Local cBarra := ""
Local aContr := {}
Local lRemoveu := .F.
Local lNovoFrm := .F.
Local nPos := 0
Local aInst := {}
Local aRem := {}
Local nNumAtu := 0
Local nTotCash := 0
Local nBotTest := 0
Local nParcial := 0
Local cNumPos := ""  
Local aLeitura := {}
Local nI
Local cOpPtH := ""
Local lFoundAB2 := .F.
Local aAux2 := {}

If cEmpAnt <> "01"
	return
EndIF

nPos := ascan(aDados,{|x| Alltrim(x[1]) == "NUMERO"})
If nPos > 0
	lNovoFrm := .T.
	cOSMobile := PadL(aDados[nPos][2],TamSx3("ZG_NUMOS")[1],"0")
Else
	cOSMobile := aDados[1][2]
EndIf

dbSelectArea("SZG")
dbSetOrder(1)
If MSSeek( xFilial("SZG") +AvKey( cOSMobile,"ZG_NUMOS") )
	cForm := AllTrim(SZG->ZG_FORM)
	cCodTec := SZG->ZG_CODTEC
	                     
	nAgente := SZG->ZG_AGENTE
	cCodCli := SZG->ZG_CLIFOR
	cLoja := SZG->ZG_LOJA	
	dDtIni := SZG->ZG_DATAINI
	cHrIni := SZG->ZG_HORAINI	
	dDtFim := SZG->ZG_DATAFIM
	cHrFim := SZG->ZG_HORAFIM
	
	cPatr := SZG->ZG_PATRIM
EndIf

// dados form
// instalacao
If cForm == "16"
	nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "INSTALACAO"})
	If nPos > 0
		For nI := 2 To Len(aDados[nPos])
			AADD(aInst, { aDados[nPos][nI][1],aDados[nPos][nI][2] } )
		Next nI
	EndIf
		 
	If !Empty(aInst)        
		nPos := Ascan( aInst, { |x| x[1] == "LOCAL_FISICO" } )
		If nPos > 0
			cLocIns := aInst[nPos][2]
		EndIf
		
		nPos := Ascan( aInst, { |x| x[1] == "POS" } )
		If nPos > 0
			cNumPos := aInst[nPos][2]
		EndIf
		
		
		// ponto hidraulico - opc2
		nPos := Ascan( aInst, { |x| x[1] == "OPC2" } )
		If nPos > 0
			cOpPtH := IIF( aInst[nPos][2]=="S","1","2" )
		EndIf
		
		// bomba galao - opc3
		nPos := Ascan( aInst, { |x| x[1] == "OPC3" } )
		If nPos > 0
			cOpPtH := IIF( aInst[nPos][2]=="S","2","1" )
		EndIf
		
		// transformador - opc4
		nPos := Ascan( aInst, { |x| x[1] == "OPC4" } )
		If nPos > 0
			cTensao := IIF( aInst[nPos][2]=="S","220","110" )
		EndIf
	EndIf
	
	nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "LEITURA"})
	If nPos > 0
		For nI := 2 To Len(aDados[nPos])
			AADD(aLeitura, { aDados[nPos][nI][1],aDados[nPos][nI][2] } )
		Next nI
	EndIf
EndIf
	
// remocao
If cForm == "17"
	nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "REMOCAO"})
	If nPos > 0
		For nI := 2 To Len(aDados[nPos])
			AADD(aRem, { aDados[nPos][nI][1],aDados[nPos][nI][2] } )
		Next nI
	EndIf
	
	nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "LEITURA"})
	If nPos > 0
		For nI := 2 To Len(aDados[nPos])
			AADD(aLeitura, { aDados[nPos][nI][1],aDados[nPos][nI][2] } )
		Next nI
	EndIf
EndIf
	
// dados da leitura
If !Empty(aLeitura)
	nPos := Ascan( aLeitura, { |x| x[1] == "CONT_TOTCASH" } )
	If nPos > 0
		nTotCash := Val(aLeitura[nPos][2])
	EndIf
	
	nPos := Ascan( aLeitura, { |x| x[1] == "CONT_TOTSALE" } )
	If nPos > 0
		nNumAtu := Val(aLeitura[nPos][2])
	EndIf

	nPos := Ascan( aLeitura, { |x| x[1] == "CONT_PARCIAL" } )
	If nPos > 0
		nParcial := Val(aLeitura[nPos][2])
	EndIf
              
	nPos := Ascan( aLeitura, { |x| x[1] == "CONT_TESTES" } )
	If nPos > 0
		nBotTest := Val(aLeitura[nPos][2])
	EndIf
EndIf


dbSelectArea("AA1")
dbSetOrder(1)	// filial + ATENDENTE
If dbSeek( xFilial("AA1") +AvKey(cCodTec,"AA1_CODTEC") )
	cSuperVsor	:= AA1->AA1_XSUPER
	cRota		:= AA1->AA1_LOCAL
	cNomAg		:= AA1->AA1_NOMTEC
EndIf


dbSelectArea("SN1")
dbSetOrder(2)
If MSSeek(xFilial("SN1") +AvKey(cPatr,"N1_CHAPA") )
	cProduto := SN1->N1_PRODUTO
	nRecSN1 := Recno()
EndIf

// pegar dados da OMM
dbSelectArea("AB2")
dbSetOrder(4)
MsSeek( xFilial("AB2") +AvKey(cOsMobile,"AB2_XOSMOB") )
lFoundAB2 := Found()
If lFoundAB2
	nRecUD := BuscaSUD(cPatr,AB2->AB2_NRCHAM)
	If nRecUD == 0
		Return
	EndIf     
			
	dbSelectArea("SUD")
	dbGoTo(nRecUD)
	cOMM := SUD->UD_CODIGO
	
	cmailf := AllTrim( Posicione("SZ9",1,xFilial("SZ9") +SUD->UD_XTAREF,"Z9_EMAILF") )
	cTabela := SUD->UD_XTABPRC
	cTempo := SUD->UD_XTMPMAQ

	aAux := strtokarr(SUD->UD_XDOSES,"|")
	If Len(aAux) > 0
		nLimtro := val(aAux[1])
	EndIf
	cCodPa	:=	SUD->UD_XPA
	cTpCnt	:=	Alltrim(SUD->UD_XTPCONT)
	cSisPg	:=	SUD->UD_XMOEDA
// nao avancar caso nao encontre a OMM
Else                                  
	U_TTMAILN('OMM@toktake.com.br','jdeus@toktake.com.br;jnascimento@toktake.com.br;cpomini@toktake.com.br','Problema no processamento de OS de instala็ใo/remo็ใo',"OMM nใo encontrada - OS: " +cOSMobile,{},.F.)
	Return
EndIf	


// gravacao dos dados
// instalacao
If SZG->ZG_TPFORM == 16
	cCont1 := "Instala็ใo"
	
	dbSelectArea("SN1")
	dbGoTo(nRecSN1)
	If Recno() == nRecSN1
		RecLock("SN1",.F.)
		SN1->N1_XTENSIN	:= cTensao
		SN1->N1_XLOCINS	:= cLocIns   
		SN1->N1_XCLIENT	:= cCodCli      
		SN1->N1_XLOJA 	:= cLoja
		SN1->N1_XSTATTT	:= "3" 
		SN1->N1_XTABELA	:= cTabela
		SN1->N1_XTMPMAQ := cTempo
		SN1->N1_XPTHDL	:= cOpPtH
		SN1->(Msunlock())	
	EndIf
	

	// atualizar contrato
	If Alltrim(cTpCnt) $ "1|6|7|8"
		If Empty( SUD->UD_XCONTRA ) .Or. Empty(SUD->UD_XPLAN)
			CONOUT("#TTPROC41 - OMM: " +cOMM + " - MAQUINA SEM CONTRATO/PLANILHA " +" -> " +cPatr)
		Else
			U_TTCNTA14(1, SUD->UD_XCONTRA, SUD->UD_XPLAN, cPatr, SUD->UD_XVLALUG, dDtFim, cCodCli, cLoja )
		EndIf			
	EndIf

	dbSelectArea("SN1")
	dbGoTo(nRecSN1)
	If Recno() == nRecSN1
		RecLock("SN1",.F.) 
		SN1->N1_XLIMTRO	:= nLimtro  
		SN1->N1_XPA		:= cCodPa 
		SN1->N1_XSISPG	:= cSisPg
		SN1->N1_XTPSERV	:= cTpCnt  
		
		// ajustar as doses aqui
		For nPy := 2 To Len(aAux)
			cBotP := cvaltochar(nPy-1)
			aAux2 := StrToKarr( aAux[nPy],";" )
			&("SN1->N1_XP"+cBotP) := aAux2[1]
		Next nPy  
		
		SN1->(Msunlock())
	EndIf

	dbSelectArea("SZD")
	dbSetOrder(1)	// cliente loja patr omm
	If !MSSeek( xFilial("SZD") +AvKey(cCodCli,"ZD_CLIENTE") +AvKey(cLoja,"ZD_LOJA") +AvKey(cPatr,"ZD_PATRIMO") +AvKey(cOMM,"ZD_NROOMM") )
		If RecLock("SZD",.T.)
			SZD->ZD_CLIENTE	:=	cCodCli
			SZD->ZD_LOJA	:=	cLoja
			SZD->ZD_NOME	:=	Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja,"A1_NOME")
			SZD->ZD_PATRIMO	:=	cPatr
			SZD->ZD_NROOMM	:=	cOMM
			SZD->ZD_DATAINS	:=	dDtFim
			SZD->ZD_HORAINS	:=	cHrFim	//cHrFim+":00"
			SZD->ZD_IDSTATU	:=	"1"
			SZD->ZD_CODPA	:= cCodPa
			SZD->(Msunlock())
		EndIf
	EndIf	
	
	dbSelectArea("SZN")
	dbSetOrder(4)	// filial OS
	If !MSSeek( xFilial("SZN") +AvKey( cOSMobile,"ZN_NUMOS") )
		If Reclock("SZN",.T.)
		    SZN->ZN_FILIAL	:= xFilial("SZN")
		    SZN->ZN_TIPINCL	:= "INSTALACAO"
		    SZN->ZN_DATA	:= dDtFim
		    SZN->ZN_ROTA	:= cRota
		    SZN->ZN_PATRIMO	:= cPatr
		    SZN->ZN_TIPMAQ	:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ESPECIF")
		    SZN->ZN_CLIENTE	:= cCodCli
		    SZN->ZN_LOJA	:= cLoja
		    SZN->ZN_NUMANT	:= nNumAtu
		    SZN->ZN_NUMATU	:= nNumAtu
		    SZN->ZN_COTCASH	:= nTotCash
		    SZN->ZN_BOTTEST	:= nBotTest
		    SZN->ZN_HORA	:= cHrFim
		    SZN->ZN_NUMOS	:= cOSMobile
		    SZN->ZN_PARCIAL	:= nParcial
		    //SZN->ZN_AGENTE	:= nAgente
		    SZN->ZN_NOMAGEN	:= cNomAg 
                
      		//Preenchendo a quantidade de botoes P que tem na maquina      	
			For nI := 1 To Len(aLeitura)
				If "CONT_P" $ aLeitura[nI][1] .And. aLeitura[nI][1] <> "CONT_PARCIAL"					
					nPos := At( "P",aLeitura[nI][1] )
					cP := PadL( SubStr( aLeitura[nI][1],nPos+1 ),2,"0" )
					&("SZN->ZN_BOTAO"+cP) := Val(aLeitura[nI][2])
				EndIf
			Next nI
					
		    SZN->(Msunlock())
		    nRecSZN := Recno()
		EndIf
	EndIf
		
	dbSelectArea("SZI")
	dbSetOrder(3)
	If !MSSeek( xFilial("SZI") +AvKey(cOSMobile,"ZI_NUMOS") )
		If RecLock("SZI",.T.)
		    SZI->ZI_FILIAL	:= xFilial("SZI")
			SZI->ZI_PATRIMO	:= cPatr
			SZI->ZI_DATA 	:= dDtFim
			SZI->ZI_TIPO 	:= "0"
			SZI->ZI_LIMTRO 	:= nLimtro
			SZI->ZI_VLRTRO 	:= 0          
			SZI->ZI_VLRSAN 	:= 0
			SZI->ZI_CNTCAS 	:= cvaltochar(nTotCash)
			SZI->ZI_FDOTRO 	:= 0
			SZI->ZI_CLIENTE	:= cCodCli
			SZI->ZI_LOJA 	:= cLoja
			SZI->ZI_RECSZN	:= nRecSZN
			SZI->ZI_NUMOS	:= cOSMobile
			SZI->(MsUnLock())
		EndIf
	EndIf	
		
	If !Empty(cNumPos)
		cMsg := ''
		dbSelectArea("ZZN")
		dbSetOrder(1)
		If MSSeek(xFilial("ZZN") +AvKey(cNumPos,"ZZN_IDPDV"))
			aModf := {}        
			If !Empty(ZZN->ZZN_PATRIM)
				aadd(aModf,ZZN->ZZN_PATRIM)
				aadd(aModf,ZZN->ZZN_CLIENT)
				aadd(aModf,ZZN->ZZN_LOJA)
			EndIf
			Reclock("ZZN",.F.)
			ZZN->ZZN_PATRIM	:= cPatr
			ZZN->ZZN_CLIENT	:= cCodCli
			ZZN->ZZN_LOJA	:= cLoja
			ZZN->ZZN_LOCALZ	:= "1"
			ZZN->(Msunlock())
			
			If len(aModf) > 0                                                                                                 
				cMsg := "O Pos "+cNumPos+" foi apontado pelo t้cnico "+Alltrim(cNomAg)+" na instala็ใo do patrimonio "+cPatr +chr(13)+chr(10)
				cMsg += "Por้m, ele jแ constava atrelado ao Patrimonio "+aModf[1]+" no cliente "+aModf[2]+" loja "+aModf[3] 
			EndIf
		Else
			cMsg := "O Pos "+cNumPos+" foi apontado pelo t้cnico "+Alltrim(cNomAg)+" na instala็ใo do patrimonio "+cPatr +chr(13)+chr(10)
			cMsg += "Por้m, ele nใo se encontra cadastrado na base de dados"				
		EndIf  
		U_TTMAILN('OMM@toktake.com.br','jnascimento@toktake.com.br','POS apontado na instala็ใo de maquinas',cMsg,{},.F.)
	EndIf
	/*
	DbSelectArea("AA3")
	DbSetOrder(1)
	If !DbSeek(xFilial("AA3")+cCodCli+cLoja+SN1->N1_PRODUTO+cPatr)
		U_TTTECC05(1,cCodCli,cLoja,cPatr,dDtFim,SUD->UD_XCONTRA)
	EndIf*/

// remocao
ElseIf SZG->ZG_TPFORM == 17
	nRecPos := recpos(cPatr)
	cCont1 := "Remo็ใo"
	If nRecPos <> 0
		DbSelectArea("ZZN")
		DbGoto(nRecPos)
		Reclock("ZZN",.F.)
		ZZN->ZZN_PATRIM	:= ""
		ZZN->ZZN_CLIENT	:= ""
		ZZN->ZZN_LOJA	:= ""
		ZZN->ZZN_LOCALZ	:= "4"
		ZZN->(Msunlock())
	EndIf
		
	DbSelectArea("SN1")
	dbGoTo(nRecSN1)
	If Recno() == nRecSN1
		cTpCnt := SN1->N1_XTPSERV
		Reclock("SN1",.F.)
		SN1->N1_XTENSIN	:= ""
		SN1->N1_XLOCINS	:= ""
		SN1->N1_XCLIENT	:= ""
		SN1->N1_XLOJA 	:= ""
		SN1->N1_XSTATTT	:= "4" 
		SN1->N1_XLIMTRO	:= 0
		SN1->N1_XPA		:= ""
		SN1->N1_XSISPG	:= ""
		SN1->N1_XTPSERV	:= ""
		SN1->N1_XPTHDL	:= ""
		
		For nPy := 1 to 25
			&("SN1->N1_XP"+cvaltochar(nPy)) := ""
		Next nPy  
		SN1->(Msunlock())	
	EndIf 
	
	dbSelectArea("SZD")
	dbSetOrder(1)
	If MSSeek(xFilial("SZD")+cCodCli+cLoja+cPatr)
		While !EOF() .And. SZD->ZD_CLIENTE == cCodCli .AND. SZD->ZD_LOJA == cLoja .AND. Alltrim(SZD->ZD_PATRIMO) == Alltrim(cPatr)
			If Alltrim(SZD->ZD_IDSTATU) == "1" .AND. Empty(SZD->ZD_DATAREM)
				If !lRemoveu
					Reclock("SZD",.F.)
					SZD->ZD_DATAREM := dDtFim
					SZD->ZD_HORAREM := cHrFim	//cHrFim+':00'
					SZD->ZD_IDSTATU := "0"
					SZD->ZD_NROOMMR := cOMM
					SZD->(Msunlock())
					lRemoveu := .T.
				// duplicidade
				Else
					Reclock("SZD",.F.)
					SZD->ZD_DATAREM := SZD->ZD_DATAINS
					SZD->ZD_HORAREM := SZD->ZD_HORAINS
					SZD->ZD_IDSTATU := "0"
					SZD->ZD_NROOMMR := SZD->ZD_NROOMM
					SZD->(Msunlock())
				EndIf	
			EndIf 
			dbskip()
		EndDo
	EndIf
		
	// remover da base instalada
	U_TTTECC05(2,"000001", "0001", cPatr)	//U_TTTECC05(2,cCodCli, cLoja, cPatr)
						
	//remover os itens do plano de trabalho do patrimonio
	U_TTOPER03(cCodCli, cLoja, cPatr)

	// atualizar contrato
	If Alltrim(cTpCnt) $ "1|6|7|8"		
		cQuery := "SELECT * FROM " +RetSqlName("SZQ")
		cQuery += " WHERE ZQ_PATRIM = '"+cPatr+"' "
		cQuery += " AND ZQ_CLIENTE = '"+cCodCli+"' AND ZQ_LOJA = '"+cLoja+"' AND ZQ_DATAREM = '' AND D_E_L_E_T_ = '' "           
		
		If Select("TRBX") > 0
			TRBX->( dbCloseArea() )
		EndIf                     
		
		TcQuery cQuery New Alias "TRBX"
		
		dbSelectArea("TRBX")
		If !EOF()
			U_TTCNTA14(2, TRBX->ZQ_CONTRA, TRBX->ZQ_PLAN, cPatr, 0, dDtFim, cCodCli, cLoja )	
		EndIf
		TRBX->(dbCloseArea())
	EndIf			

	
	dbSelectArea("SZN")
	dbSetOrder(4)	// filial OS
	If !MSSeek( xFilial("SZN") +AvKey( cOSMobile,"ZN_NUMOS") )
		If Reclock("SZN",.T.)
		    SZN->ZN_FILIAL	:= xFilial("SZN")
		    SZN->ZN_TIPINCL	:= "REMOCAO"
		    SZN->ZN_DATA	:= dDtFim
		    SZN->ZN_ROTA	:= cRota
		    SZN->ZN_PATRIMO	:= cPatr
		    SZN->ZN_TIPMAQ	:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ESPECIF")
		    SZN->ZN_CLIENTE	:= cCodCli
		    SZN->ZN_LOJA	:= cLoja
		    SZN->ZN_NUMANT	:= nNumAtu
		    SZN->ZN_NUMATU	:= nNumAtu
		    SZN->ZN_COTCASH	:= nTotCash
		    SZN->ZN_BOTTEST	:= nBotTest
		    SZN->ZN_HORA	:= cHrFim
		    SZN->ZN_NUMOS	:= cOSMobile
		    SZN->ZN_PARCIAL	:= nParcial
		    //SZN->ZN_AGENTE	:= nAgente
		    SZN->ZN_NOMAGEN	:= cNomAg 
            
          
			For nI := 1 To Len(aLeitura)
				If "CONT_P" $ aLeitura[nI][1] .And. aLeitura[nI][1] <> "CONT_PARCIAL"					
					nPos := At( "P",aLeitura[nI][1] )
					cP := PadL( SubStr( aLeitura[nI][1],nPos+1 ),2,"0" )
					&("SZN->ZN_BOTAO"+cP) := Val(aLeitura[nI][2])
				EndIf
			Next nI
		
			
		    SZN->(Msunlock())
			nRecSZN := Recno()
		EndIf
	EndIf
		
	// colocar tratamento para nao duplicar registro do mesmo dia
	dbSelectArea("SZI")
	dbSetOrder(3)
	If !MSSeek( xFilial("SZI") +AvKey(cOsmObile,"ZI_NUMOS") )
		If RecLock("SZI",.T.)
		    SZI->ZI_FILIAL	:= xFilial("SZI")
			SZI->ZI_PATRIMO	:= cPatr
			SZI->ZI_DATA 	:= dDtFim
			SZI->ZI_TIPO 	:= "9"
			SZI->ZI_LIMTRO 	:= nLimtro
			SZI->ZI_VLRTRO 	:= 0          
			SZI->ZI_VLRSAN 	:= 0
			SZI->ZI_CNTCAS 	:= cvaltochar(nTotCash)
			SZI->ZI_FDOTRO 	:= STATICCALL( TTAUDT02, SaldoFD, cPatr, dDtFim,RECNO(),.T. )
			SZI->ZI_CLIENTE	:= cCodCli
			SZI->ZI_LOJA 	:= cLoja
			SZI->ZI_RECSZN	:= nRecSZN
			SZI->ZI_NUMOS	:= cOSMobile
			SZI->(MsUnLock())
		EndIf
	EndIf	
EndIf


//colocar aqui o email de finalizacao de omm
//cCont1 cTpCnt
If !Empty(cCont1)
	If empty(cTpCnt)
		cTpCnt := '1'
	EndIf
	
	aContr := {"Loca็ใo","Serv.Caf้","LA","S.A","Kit Lanche","Caf้ + Loca็ใo","LA + Loca็ใo","SA + Loca็ใo"}		//[8]

	//TTMAILN                                                                                     
	cMsg := 'Tipo de contrato '+aContr[val(cTpCnt)]+'<br>'
	cMsg += 'Codigo Cliente '+cCodCli+'<br>'
	cMsg += 'Nome Cliente '+Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja,"A1_NREDUZ")+'<br>'
	cMsg += 'Tipo de OMM '+cCont1+'<br>'
	cMsg += 'Data '+cvaltochar(dDtFim)+'<br>'
	cMsg += 'Patrim๔nio '+cPatr+'<br>'
	cMsg += 'OMM '+cOMM+'<br>'
	U_TTMAILN('OMM@toktake.com.br',alltrim(cmailf),'Finaliza็ใo de OMM de '+cCont1,cMsg,{},.F.)
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC26  บAutor  ณMicrosiga           บ Data ณ  03/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function recpos(cpatr)

Local aArea	:=	GetArea()
Local nRec	:=	0
Local cQuery

cQuery := "SELECT R_E_C_N_O_ AS REC FROM "+RetSQLName("ZZN")+" WHERE ZZN_PATRIM='"+cpatr+"' AND D_E_L_E_T_=''"
 
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")            

nRec := TRB->REC

RestArea(aArea)

Return(nrec)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC41  บAutor  ณMicrosiga           บ Data ณ  07/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaSUD(cPatr,cChamado)

Local nRec := 0           
Local aArea := GetArea()
Local cQuery

cQuery := "SELECT R_E_C_N_O_ AS REC FROM "+RetSQLName("SUD")+" WHERE UD_ASSUNTO = '000007' AND UD_XNPATRI = '"+cPatr+"' AND UD_XNRCHAM='"+cChamado+"' AND D_E_L_E_T_='' "
 
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")            

nRec := TRB->REC

RestArea(aArea)


Return nRec