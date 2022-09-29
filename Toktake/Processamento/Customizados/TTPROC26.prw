#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC26  ºAutor  ³Jackson E. de Deus  º Data ³  15/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Salva o atendimento da Ordem de Servico no Field Service    º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³15/05/14³01.01 |Criacao                                 ³±±
±±³Jackson       ³21/10/14³01.02 |Alterado para utilizar MSExecAuto		  ³±±
±±³Jackson       ³24/11/14³01.02 |Incluido tratamento de sist. pagto	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTPROC26(aDados,cmsgErro,nTipoF)

Local lRet			:= .F.
Local aCabec		:= {}
Local aItens		:= {}
Local aItem			:= {}
Local nAgente		:= 0              
Local cOSMobile		:= ""
Local cNumChapa		:= ""
Local cDefeito		:= ""
Local cCausaProv	:= ""
Local cCodTec		:= ""
Local cItem			:= ""
Local dDtIni
Local cHrIni
Local dDtFim
Local cHrFim
Local cCodProblem
Local cCodCli		:= ""
Local cLoja			:= ""
Local cProduto		:= ""
Local cSolucao		:= ""
Local cTotHoras		:= ""
Local lSalvou		:= .F. 
Local lOSFim		:= .F.
Local cNumOSField	:= "" // AB6
Local cChamadoTec	:= "" // AB1
Local cLaudo		:= ""  
Local cRota			:= "" 
Local cNomAg		:= "" 
Local cSuperVsor	:= ""
Local lRemov		:= .F.
Local cBotP			:= "" 
Local cCont1		:= ""
Local cCont2		:= ""
Local cCodDef		:= ""
Local cDefEsc		:= ""
Local lNovoFrm		:= .F.
Local nI
Local nPos			:= 0 
Local aMnt			:= {}
Local cForm			:= ""
Local aContent		:= {}
Private lMsErroAuto	:= .F.
Private cLimTro		:=	0 
Private cCodPa		:=	'' 
Private aPs			:= {}
Private cSisPg		:= ''
Private cTpCnt		:= ''

Default nTipoF 		:= 1

If cEmpAnt <> "01"
	return
EndIF

nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "NUMERO"})
If nPos > 0
	lNovoFrm := .T.
	cOSMobile := PadL(aDados[nPos][2],TamSx3("ZG_NUMOS")[1],"0")
	dbSelectArea("SZG")
	dbSetOrder(1)
	If MsSeek( xFilial("SZG") +AvKey(cOSMobile,"ZG_NUMOS") )
		cForm := AllTrim(SZG->ZG_FORM)
	EndIf
EndIf


If !lNovoFrm
	nAgente := aDados[2][2]     
	cCodCli := aDados[3][2]
	cLoja := aDados[4][2]
	cOSMobile := aDados[1][2]
	dDtIni := aDados[5][2]
	cHrIni :=  SubStr(aDados[6][2],1,5)
	dDtFim := aDados[7][2]
	cHrFim := SubStr(aDados[8][2],1,5)
// novo form
Else
	dbSelectArea("SZG")
	dbSetOrder(1)
	If !MSSeek( xFilial("SZG") +AvKey( cOsMobile,"ZG_NUMOS") )
		Return
	EndIf
	
	cCodTec := SZG->ZG_CODTEC
	cCodCli := SZG->ZG_CLIFOR
	cLoja := SZG->ZG_LOJA
	dDtIni := SZG->ZG_DATAFIM	//SZG->ZG_DATAINI
	cHrIni := SZG->ZG_HORAFIM	//SZG->ZG_HORAINI
	dDtFim := SZG->ZG_DATAFIM
	cHrFim := SZG->ZG_HORAFIM
EndIf          

If !lNovoFrm
	If nTipoF == 1
		cDefeito := aDados[9][2]
		cCausaProv := aDados[10][2]
		cSolucao := aDados[11][2]
	ElseIf nTipoF == 2
		// tratar aqui inclusao/alteracao de sist. de pagamento
		nPosDados := ascan(aDados,{|x| upper(Alltrim(x[1])) == "MANUTENCAO"}) 
		If nPosDados > 0
			If len(aDados[nPosDados]) > 1
				cDefeito 	:= aDados[nPosDados,2,2]
				cCausaProv 	:= aDados[nPosDados,3,2]
				cSolucao	:= aDados[nPosDados,4,2]
			Else              
				cDefeito := 'Nenhum'
				cCausaProv := 'Nenhum'
				cSolucao := ''
			EndIf
		Endif
		dbSelectArea("SZG")
		dbSetOrder(1)
		If !MSSeek( xFilial("SZG") +AvKey(cOSMobile,"ZG_NUMOS") )
			cMsgErro += "Ordem de servico mobile nao encontrada."
			Return lRet
		EndIf
		cNumChapa := SZG->ZG_PATRIM
		
		// inc. sist. pag.
		If SZG->ZG_TPFORM == 5 //14
			For nX := 10 to len(aDados)
				cSolucao += aDados[nX,01] + " - " + aDados[nX,02] + CRLF
			Next nX
			StaticCall(TTPROC39,tratarSP,aDados,cNumChapa)   
		                  
		// alt. sist. pag
		ElseIf SZG->ZG_TPFORM == 6 //15
			lRet := StaticCall(TTPROC39,tratSP2,aDados,cNumChapa)
			If !lRet       
				CONOUT("#TTPROC26 -> Erro ao processar a alteracao do sistema de pagamento")
			EndIf
		EndIf
	ElseIf nTipoF == 3
		cDefeito := 'Nenhum'
		cCausaProv := 'Nenhum'
		cSolucao := ''
	    For nX := 9 to len(aDados)
	    	If !Empty(aDados[nX,02])
	    		cSolucao += aDados[nX,01]+chr(13)+chr(10)
	    		cSolucao += aDados[nX,02]+chr(13)+chr(10)
	    	EndIf
	    Next nX
	    
	    U_TTPROC41(aDados)
	EndIf
// novo form
Else
	// manutencao                         
	If cForm == "06"
		nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "MANUTENCAO"})
		If nPos > 0
			If Len(aDados[nPos]) > 1
				For nI := 2 To Len(aDados[nPos])
					AADD(aMnt, { aDados[nPos][nI][1],aDados[nPos][nI][2] } )
				Next nI
			EndIf
			//aMnt := Aclone( aDados[nPos] )
		EndIf 
		
	 	nPos := Ascan( aMnt, { |x| AllTrim(x[1]) == "DEFEITO_OPC" } )
		If nPos > 0
			cDefEsc := UPPER(aMnt[nPos][2])
		EndIf
		
		nPos := Ascan( aMnt, { |x| AllTrim(x[1]) == "DEFEITO" } )
		If nPos > 0
			cDefeito := aMnt[nPos][2]
		EndIf
		
		nPos := Ascan( aMnt, { |x| AllTrim(x[1]) == "CAUSA" } )
		If nPos > 0
			cCausaProv := aMnt[nPos][2]
		EndIf
		
		nPos := Ascan( aMnt, { |x| AllTrim(x[1]) == "SOLUCAO" } )
		If nPos > 0
			cSolucao := aMnt[nPos][2]
		EndIf
		
		If !Empty(cDefEsc)
			aContent := FWGetSX5( "ZQ" )
			For nI := 1 To Len(aContent)
				If AllTrim(aContent[nI][4]) == cDefEsc
					cCodDef := AllTrim(aContent[nI][3])
				EndIf
			Next nI
		EndIf
		/*
		dbSelectArea("SX5")
		dbSetOrder(1)
		If MsSeek( xFilial("SX5") +AvKey("ZQ","X5_TABELA") )
			While SX5->X5_FILIAL == xFilial("SX5") .And. AllTrim(SX5->X5_TABELA) == "ZQ" .And. !EOF()
				If AllTrim(SX5->X5_DESCRI) == cDefEsc
					cCodDef := AllTrim(SX5->X5_CHAVE)
					Exit
				EndIf
				dbSkip()
			End
		EndIf	
        */
		STATICCALL( TTPROC39, SisPgto,cOSMobile,aMnt )
		
	// instalacao
	ElseIf cForm == "16"
		U_TTPROC41(aDados)

	// remocao
	ElseIf cForm == "17"	
		U_TTPROC41(aDados)
	EndIf	
EndIf
      
cLaudo := "# DEFEITO CONSTATADO:" +CRLF
cLaudo += cDefEsc + CRLF
cLaudo += cDefeito +CRLF
cLaudo += "# CAUSA PROVÁVEL:" +CRLF
cLaudo += cCausaProv +CRLF
cLaudo += "# SOLUÇÃO:" +CRLF
cLaudo += cSolucao
	
// total horas
If !lNovoFrm
	cTotHoras := IntToHora(SubtHoras(dDtIni, cHrIni,dDtFim,cHrFim))
Else 
	cTotHoras := IntToHora(SubtHoras(dDtFim, cHrFim,dDtFim,cHrFim))
EndIf


If !lNovoFrm
	dbSelectArea("AA1")
	dbSetOrder(7)	// filial + pager
	If dbSeek( xFilial("AA1") +AvKey(cvaltochar(nagente),"AA1_PAGER") )
		cCodTec	:= AA1->AA1_CODTEC
		cSuperVsor := AA1->AA1_XSUPER
		cRota	:= AA1->AA1_LOCAL
		cNomAg	:= AA1->AA1_NOMTEC
	EndIf
// novo frm
Else 
	dbSelectArea("AA1")
	dbSetOrder(1)	// filial + tecnico
	If MSSeek( xFilial("AA1") +AvKey(cCodTec,"AA1_CODTEC") )
		cSuperVsor := AA1->AA1_XSUPER
		cRota	:= AA1->AA1_LOCAL
		cNomAg	:= AA1->AA1_NOMTEC
	EndIf
EndIf

If Empty(cCodTec) .And. !lNovoFrm
	cMsgErro += " Tecnico nao encontrado - agente " +cvaltochar(nAgente)
	Return lRet
EndIf

If !Empty(cSuperVsor)
	dbSetOrder(1)
	If dbSeek( xFilial("AA1") +AvKey(cSuperVsor,"AA1_CODTEC") )
		cMailSpvsr := ALLTRIM(AA1->AA1_EMAIL)
	EndIf
EndIf

// Verifica primeiro se encontra o chamado tecnico, se nao encontrar, tenta encontrar pela Ordem de Servico
// Item do Chamado Tecnico
dbSelectArea("AB2")
dbSetOrder(4)	// filial + os mobile
If !dbSeek( xFilial("AB2") +AvKey( cOSMobile,"AB2_XOSMOB") )
	dbSelectArea("AB7")
	dbSetOrder(8)	// filial + os mobile
	If !dbSeek( xFilial("AB7") +AvKey( cOSMobile,"AB7_XOSMOB") )
		cMsgErro += " Nao foi encontrado nenhum chamado tecnico/ordem de servico vinculado a essa OS Mobile."
		Return lRet
	EndIf
EndIf
			
// Alterar Ordem de Servico
dbSelectArea("AB7")
dbSetOrder(8)	// filial + os mobile
If !dbSeek( xFilial("AB7") +AvKey(cOSMobile,"AB7_XOSMOB") )
	cMsgErro += " Nao foi encontrado nenhum item da ordem de servico relacionado a essa OS Mobile."
	Return lRet
EndIf
	
If AllTrim(AB7->AB7_TIPO) $ "4|5"
	cMsgErro += " Atendimento ja efetuado."
	Return lRet
EndIf
     
cChamadoTec := SubStr(AB7->AB7_NRCHAM,1,8)
cNumOSField := AB7->AB7_NUMOS
cItem := AB7->AB7_ITEM
cProduto := AB7->AB7_CODPRO
cCodProblem := AB7->AB7_CODPRB
cNumChapa := AB7->AB7_NUMSER
    			   

dbSetOrder(1)
dbSelectArea("AA1")
dbSetOrder(1)
    			   
AADD(aCabec, {"AB9_FILIAL"	,xFilial("AB9")		,Nil} )
AADD(aCabec, {"AB9_NUMOS"	,cNumOSField +cItem	,Nil} )
AADD(aCabec, {"AB9_CODTEC"	,cCodTec			,Nil} )
AADD(aCabec, {"AB9_SEQ"		,"01"				,Nil} )
AADD(aCabec, {"AB9_DTCHEG"	,dDtIni				,Nil} )
AADD(aCabec, {"AB9_HRCHEG"	,cHrIni				,Nil} )
AADD(aCabec, {"AB9_DTSAID"	,dDtFim				,Nil} )
AADD(aCabec, {"AB9_HRSAID"	,cHrFim				,Nil} )
AADD(aCabec, {"AB9_DTINI"	,dDtIni				,Nil} )
AADD(aCabec, {"AB9_HRINI"	,cHrIni				,Nil} )
AADD(aCabec, {"AB9_DTFIM"	,dDtFim				,Nil} )
AADD(aCabec, {"AB9_HRFIM"	,cHrFim				,Nil} )
AADD(aCabec, {"AB9_CODPRB"	,cCodProblem		,Nil} )
AADD(aCabec, {"AB9_GARANT"	,"S"				,Nil} )
AADD(aCabec, {"AB9_TIPO"	,"1"				,Nil} )
AADD(aCabec, {"AB9_CODCLI"	,cCodCli			,Nil} )
AADD(aCabec, {"AB9_LOJA"	,cLoja				,Nil} )
AADD(aCabec, {"AB9_CODPRO"	,cProduto			,Nil} )
AADD(aCabec, {"AB9_TOTFAT"	,cTotHoras			,Nil} )
AADD(aCabec, {"AB9_STATAR"	,"1"				,Nil} )   
AADD(aCabec, {"AB9_GARANT"	,"S"				,Nil} ) 
AADD(aCabec, {"AB9_ACUMUL"	,0					,Nil} )   
AADD(aCabec, {"AB9_XPATRI"	,cNumChapa			,Nil} )
AADD(aCabec, {"AB9_XDEF"	,cCodDef			,Nil} )
AADD(aCabec, {"AB9_XOSMOB"	,cOSMobile			,Nil} )

// Inserir aqui os itens utilizados no atendimento - caso existam
/*
aAdd(aItem,{"ABA_FILIAL"  ,xFilial("ABA")	,Nil})	
aAdd(aItem,{"AB9_ITEM"		,StrZero(1,2),Nil})	

aAdd(aItens,aItem)	
*/
lMsErroAuto := .F.
MsExecAuto({|x, y, z| TECA460(x, y, z)}, aCabec, aItens, 3)   
//TECA460(aCabec,aItens,3)
If !lMsErroAuto		
	// grava laudo na AB9
	MSMM(AB9->AB9_MEMO1,,,cLaudo,1,,,"AB9","AB9_MEMO1")
	// grava laudo na AB7
	MSMM(AB7->AB7_MEMO3,,,cLaudo,1,,,"AB7","AB7_MEMO3")

	lRet := .T.                                                                      
	Conout("# TTPROC26 -> Gravou laudo com sucesso! " +cOSMobile   +" #")                  
Else	                                           
	Conout("# TTPROC26 -> ERRO AO GRAVAR O ATENDIMENTO - MSEXECAUTO " +cOSMobile +" #")                  
	cMsgErro += " Houve erro ao salvar o atendimento."
	Return lRet
EndIf


MsUnLockAll()

Return lRet                 