#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
//#Include "aarray.ch"
//#Include "json.ch"
#DEFINE pulapula "<BR>"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER02  บAutor  ณJackson E. de Deus  บ Data ณ  13/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJob de criacao de OS no Equipe Remota                       บฑฑ
ฑฑบ          ณcom base no plano de trabalho                               บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ13/01/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ27/05/14ณ02.00 |Alteracao no agendamento das maquinas   ณฑฑ
ฑฑณ			          			  Calculo do tempo de prep. e desloc.     ณฑฑ
ฑฑณJackson		 ณ07/07/14ณ03.00 |Alteracao no agendamento das maquinas   ณฑฑ
ฑฑณ								  Criadas 2 novas funcoes: CalcHora1 e    ณฑฑ
ฑฑณ								  CalcHora2 - obtem ou calcula os horariosณฑฑ
ฑฑณJackson	     ณ21/10/14ณ03.01 |Ajustes efetuados:     				  ณฑฑ
ฑฑณ								  Contemplar mais de um atendimento/dia   ณฑฑ 
ฑฑณ								  ao patrimonio;					      ณฑฑ 
ฑฑณ								  Melhoria na consulta de patrimonios;	  ณฑฑ 
ฑฑณ								  Alteracao no calculo de deslocamento    ณฑฑ 
ฑฑณ								  para considerar trajeto resid/cliente;  ณฑฑ
ฑฑณ								  Adicao de coluna no email - hora agend.;ณฑฑ
ฑฑณ								  Adicao de nova tabela no email - erros; ณฑฑ
ฑฑณJackson	     ณ22/10/14ณ03.01 | Correcao na funcao de obtencao dos     ณฑฑ
ฑฑณ								  horarios de atendimento;				  ณฑฑ
ฑฑณ								  Incluida opcao de execucao no modo 	  ณฑฑ
ฑฑณ								  simulacao - nao gera OS Mobile 		  ณฑฑ
ฑฑณJackson	     ณ23/10/14ณ03.01 | Correcao - area de trabalho TRB estava ณฑฑ
ฑฑณ								  se perdendo e deixando de gerar OS.	  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

//User Function TTOPER02(cEmp, cFil, cRota, lSimula)
User Function TTOPER02(aParam)

Local aDados		:= {}    
Local cTarget		:= If(cEmpAnt == "01",SuperGetMV("MV_XOPER02",.T.,"jnascimento@toktake.com.br;rjesus@toktake.com.br;ronaldo.gomesj@gmail.com"),"") //"jnascimento@toktake.com.br;rjesus@toktake.com.br;ronaldo.gomesj@gmail.com"
//Local cTarget		:= GetMV("MV_XOPER02")
Local cRemete		:= ""
Local cSubject		:= ""
Local aAttach		:= {}
Local cBody			:= ""
Local cCodFil		:= ""	// filial do plano de trabalho
Local cCliente		:= ""
Local cLoja			:= ""
Local cMensal		:= ""	// ano mes frequencia dias do plano de trabalho
Local cFrequen		:= ""	// frequencia da criacao de OS
Local cAnoPlan		:= ""	// ano do plano de trabalho
Local cMesPLan		:= ""	// mes do plano de trabalho
Local cDiasMes		:= ""	// dias do mes do plano de trabalho
Local cTipoPLan		:= ""	// tipo da planilha
Local nTpServ		:= 0	// tipo do servico - OS Equipe Remota
Local cNumChapa		:= ""	// numero do patrimonio  
Local cDescPatr		:= ""
Local nSeq			:= 0	// sequencia da execucao do trabalho
Local aDoc			:= {}
Local cNumNF		:= ""
Local cSerie		:= ""
Local nAgenteOS		:= 0	// Agente que vai receber a OS - DEFINIR COMO BUSCAR O AGENTE
Local cNumOs		:= ""	// numero da OS gerada
Local aOS			:= {}	// todas as os geradas
Local cHoraFunc		:= ""	// hora inicial do turno do funcionario
Local cTecnico		:= ""	// codigo do tecnico
Local nQtdOS		:= 0
Local lExist		:= .F.	// controle da geracao da OS na data
Local cHoraOS		:= ""
Local lFechamento	:= .F.  
Local cHoraAgend	:= ""
Local aInfLacr		:= {}
Local cSisPg		:= ""	// sistema de pagamento
Local aERROS		:= {}
Local lJob			:= .F.
Local nIst1			:= 0
Local cmsgtab		:= ""
Local nRecnoSZR		:= 0
Local cAudit		:= ""
Local lResid		:= .F.
Local lExistOS		:= .F.
Local nZ			:= 0      
Local dAgend		:= Date()
Local cEmp			:= "" //"01"
Local cFil			:= "" // "01"
Local cRota			:= "" //""
Local lSimula		:= .F.
Local lNovoFrm		:= .F.
Local aDadosOS		:= {}
Local cTabPreco		:= ""
Local cTpAbast		:= ""
Local cTipBeb		:= ""
Local cEndereco		:= ""
LOcal cDescPA		:= ""
Local cNomeCli		:= ""
Local cCodFrm		:= ""
Local cDescFrm		:= ""
Local cLocFis		:= ""
Default aParam := {"01","01","",.F.}

If cEmpAnt <> "01"	
	Return
EndIF
If Empty(FunName()) //__cinternet
	lJob := .T.
EndIf

If lJob
	ConOut("# TTOPER02 - Iniciando Job de criacao de OS do plano de trabalho - Integracao Mobile #")
	cHora := Time()
	cRota := ""
	lSimula := .F.
	RpcSetType(3)
	RpcSetEnv(aParam[1],aParam[2])
	dAgend++
Else
	cEmp := aParam[1]
	cFil := aParam[2]
	cRota := aParam[3]
	lSimula := aParam[4]
	If Empty(cRota)
		If !MsgYesNo("Nenhuma rota foi informada." +CRLF +"Considerar todas?")
			Return nQtdOS
		EndIf
	EndIf	
EndIf
     
cRemete := SuperGetMV("MV_RELACNT",.T.,"microsiga",) 
cSubject := "Plano de trabalho - Abertura de Ordens de Servi็o"

// busca os dados   
aDados := PlTrab(cRota,dAgend,lSimula)

If !lJob
	ProcRegua(Len(aDados))
EndIf

For nIst1 := 1 To Len(aDados)
	If !lJob
		IncProc("Gerando OS - Patrim๔nio " +aDados[nIst1][6])
	EndIf
	aDadosOS	:= {}
	cCodFrm		:= ""
	cDescFrm	:= ""
	cTabPreco	:= ""
	cTpAbast	:= ""
	cTipBeb		:= ""
	cEndereco	:= ""
	aDoc		:= {}
	cHoraAgend	:= ""
	cCodFil		:= ""
	cCliente	:= ""
	cLoja		:= ""
	cMensal		:= ""
	cAnoPlan 	:= ""
	cMesPlan 	:= ""
	cDiasMes 	:= ""
	cFrequen	:= ""
	cTipoPLan	:= ""
	cNumChapa	:= ""
	cDescPatr	:= ""
	cRota		:= ""
	nSeq		:= 0
	nTpServ		:= 0
	cNumOS		:= ""			
	nRecnoSZR	:= 0
	cDescPA		:= ""
	cLocFis		:= ""
    
	lNovoFrm	:= .F.           
	lResid		:= .F.
	lFechamento := .F.
	cCodFil		:= aDados[nIst1][1]
	cCliente	:= aDados[nIst1][2]
	cLoja		:= aDados[nIst1][3]
	cMensal		:= aDados[nIst1][8]
	cAnoPlan	:= SubStr(cMensal,1,4)
	cMesPlan	:= SubStr(cMensal,5,2)
	cDiasMes	:= SubStr(cMensal,9)
	cFrequen	:= aDados[nIst1][4]	
	cTipoPLan	:= aDados[nIst1][9]
	cNumChapa	:= aDados[nIst1][6]
	cRota		:= aDados[nIst1][7]
	nSeq		:= aDados[nIst1][10]
	cEmpReg		:= aDados[nIst1][13]
	cTecnico	:= aDados[nIst1][14]
	cSisPg		:= aDados[nIst1][24]
	cHoraAgend	:= aDados[nIst1][16] 
	nRecnoSZR	:= aDados[nIst1][27] 
	cAudit		:= ""
	cCodPA		:= ""
	
	// residente?
	dbSelectArea("AA1")
	dbSetOrder(1)
	If msSeek( xFilial("AA1") +AvKey(cTecnico,"AA1_CODTEC") )
		cNomeAtend := AllTrim(AA1->AA1_NOMTEC)
		If AllTrim(AA1->AA1_XARMOV) == "N"
			lResid := .T.
		EndIf
	EndIf
	
	If !Empty(cHoraAgend)	// ajustado em 13/08/2014 - o horario estava errado
		If "." $ cHoraAgend
			cHoraAgend := StrTran( aDados[nIst1][16], ".", ":" )
		EndIf
		cHoraAgend += ":00"
	EndIf
	
	// verifica se eh fechamento
	IIF(aDados[nIst1][15],lFechamento := .T.,lFechamento := .F.)
	
	// valida o codigo do agente/filial de atendimento
	If Empty(cCliente) .Or. Empty(cLoja)	// .Or. Empty(aDados[nIst1][11]) .Or. Empty(aDados[nIst1][12])
		Conout("# TTOPER02 - OS nao pode ser gerada | ROTA:  " +cRota +" | PATRIMONIO: " +cNumChapa +" #")
		AADD( aERROS, { cRota, cNumChapa  } )
		//Loop
	EndIf                  
	
	nAgenteOs := Val(aDados[nIst1][11])
	    
	// novo formulario
	If nAgenteOS == 0
		lNovoFrm := .T.
	EndIf

	lNovoFrm := .T.
	
	cLocFis := Posicione( "SN1",2,xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA"),"N1_XLOCINS" )

	// SANGRIA
	If SubStr(cTipoPlan,1,1) == "1" .Or. SubStr(cTipoPlan,1,1) == "5"
		nTpServ := 3
		cCodFrm := "03"
  			cDescFrm := IIF( SubStr(cTipoPlan,1,1) == "1","SANGRIA","AUDITORIA" )
  			
  			If !Empty(cNumChapa)
  				dbSelectArea("SN1")
  				dbSetOrder(2)
  				If MsSeek( xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA") )
  					cDescPatr := SN1->N1_DESCRIC
  					cCodPA := SN1->N1_XPA
  				EndIf

			If Empty(cCodPA)
				Conout("TTOPER02 -> PATRIMONIO SEM PA:" +cNumChapa)
				AADD( aERROS, { cRota, cNumChapa  } )
				Loop
			EndIf
						
			If !Empty(cCodPA)
				dbSelectArea("ZZ1")
				dbSetOrder(1)
				If MsSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
					cDescPA := AllTrim(ZZ1->ZZ1_DESCRI)
					cEndereco := AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST) +CRLF +"Local Fํsico: " +cLocFis
				EndIf
			EndIf
			
			cNomeCli := AllTrim(Posicione("SA1",1,xFilial("SA1")+AvKey(cCliente,"A1_COD")+AvKey(cLoja,"A1_LOJA"),"A1_NREDUZ"))	  			            
  			
			aDadosOS := { cCodFrm,;
						cDescFrm,;
						AllTrim(cTecnico),;
						AllTrim(cNomeAtend),;
						AllTrim(cNumChapa),;
						AllTrim(cDescPatr),;
						"",;
						"",;
						dAgend,;
						cHoraAgend,;
						cNomeCli,;
						cEndereco,;
						""/*contato*/,;
						""/*mensagem*/,;
						cRota,;
						cDescPA,;
						"",;
						"",;
						"",;
						cCliente,;
						cLoja,;
						{},;	// informacoes lacre
						cDescPatr,;
						cCodPA}				
			
	  	EndIf
  			  					
	// ABASTECIMENTO
	ElseIf SubStr(cTipoPlan,1,1) == "2"
		If Posicione("SB1",1,xFilial("SB1")+(Posicione("SN1",2,xFilial("SN1")+Avkey(cNumChapa,"N1_CHAPA"),"N1_PRODUTO")),"B1_XFAMILI") $ "144/153"
 				nTpServ := 8
 			cCodFrm := "08"
  				cDescFrm := "ABASTECIMENTO BEBIDAS"
	  	Else
	  		nTpServ := 4
	   		cCodFrm := "04"
  			cDescFrm := "ABASTECIMENTO"
	  	EndIf
				
  			If !Empty(cNumChapa)
  				dbSelectArea("SN1")
  				dbSetOrder(2)
  				If MsSeek( xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA") )
  					cDescPatr := SN1->N1_DESCRIC
	  				cTabPreco := SN1->N1_XTABELA
	  				cCodPA := SN1->N1_XPA
  				EndIf
							
			If Empty(cTabPreco)
				Conout("TTOPER02 -> PATRIMONIO SEM TABELA DE PRECO:" +cNumChapa)
				AADD( aERROS, { cRota, cNumChapa  } )
				Loop
			EndIf
			
			If Empty(cCodPA)
				Conout("TTOPER02 -> PATRIMONIO SEM PA:" +cNumChapa)
				AADD( aERROS, { cRota, cNumChapa  } )
				Loop
			EndIf
						
			cTpAbast := "1"	
			cTipBeb := Posicione("SB1",1,xFilial("SB1")+Posicione("SN1",2,xFilial("SN1")+AvKey(cNumChapa,"N1_CHAPA"),"N1_PRODUTO"),"B1_XFAMILI")    
			If cTipBeb == "144"
				cTpAbast := "3"
			ElseIf cTipBeb == "153"
				cTpAbast := "2"
			EndIf     		
						
			If !Empty(cCodPA)
				dbSelectArea("ZZ1")
				dbSetOrder(1)
				If MsSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
					cDescPA := AllTrim(ZZ1->ZZ1_DESCRI)
					cEndereco := AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST) +CRLF +"Local Fํsico: " +cLocFis
				EndIf
			EndIf
			
			cNomeCli := AllTrim(Posicione("SA1",1,xFilial("SA1")+AvKey(cCliente,"A1_COD")+AvKey(cLoja,"A1_LOJA"),"A1_NREDUZ"))	  			            
  			
			aDadosOS := { cCodFrm,;
						cDescFrm,;
						AllTrim(cTecnico),;
						AllTrim(cNomeAtend),;
						AllTrim(cNumChapa),;
						AllTrim(cDescPatr),;
						cTpAbast,;
						cTabPreco,;
						dAgend,;
						cHoraAgend,;
						cNomeCli,;
						cEndereco,;
						""/*contato*/,;
						""/*mensagem*/,;
						cRota,;
						cDescPA,;
						"",;
						"",;
						"",;
						cCliente,;
						cLoja,;
						{},;
						cDescPatr,;
						cCodPA}	
						
		
	  	EndIf
	EndIf
		
	
	If !lSimula
		// troca de filial	-> alterado em 20/07/2016 - Jackson
		cFilAnt := cCodFil
	
		dbSelectArea("SZG")
		dbSetOrder(2)
		If MsSeek( AvKey(xFilial("SZG"),"ZG_FILIAL")+AvKey(cNumChapa,"ZG_PATRIM") +avKey(cCodFrm,"ZG_FORM") +AvKey(DTOS(dAgend),"ZG_DATAINI") +AvKey(cHoraAgend,"ZG_HORAINI") )
			If ! AllTrim(SZG->ZG_STATUS) $ "CTEC|CCLI|COPE"
				Loop
			EndIf
		EndIf
		
		If !Empty(aDadosOS)
			cNumOS := U_MOBILE(aDadosOS)
		EndIf
	
		If !Empty(cNumOS)
			If Val(cNumOS) > 0
				If nRecnoSZR > 0
					dbSelectArea("SZR")
					dbGoTo(nRecnoSZR)
					If Recno() == nRecnoSZR
						If Empty(SZR->ZR_NUMOS)
							If RecLock("SZR",.F.)
								SZR->ZR_NUMOS := cNumOS
								SZR->(MSUNLOCK())
							EndIf                 
						EndIf
					EndIf
				EndIf
			Else
				Conout( "#TTOPER02 -> ERRO - PATRIMONIO: " +cNumChapa +" - HORARIO: " +cHoraAgend )			
				AADD( aERROS, { cRota, cNumChapa  } )
			EndIf
		Else
			Conout( "#TTOPER02 -> ERRO - PATRIMONIO: " +cNumChapa +" - HORARIO: " +cHoraAgend )	
			AADD( aERROS, { cRota, cNumChapa  } )
		EndIf
	Else
		cNumOS := CVALTOCHAR(nIst1)
	EndIf
	
	If !Empty(cNumOS)
		If Val(cNumOS) > 0
			AADD( aOS, { cNumOS,;
						cCliente,;
						cLoja,;                           
						cNumChapa,;
						cRota,;
						cNumNF,;
						cSerie,;
						nAgenteOS,;
						nTpServ,;
						cHoraAgend,;
						nRecnoSZR,;
						cTecnico })
						
			Conout( "TOTAL -> " +cvaltochar(Len(aOS)) )
		EndIf					
	EndIf
Next nIst1

// inventarios PA - ZZ1
/*
If GetEnvServer() == "SCHEDULE" .And. !FwIsInCallStack("U_TTPROC30")
	aDadosInv := OSInvent( dAgend )
	For nI := 1 To Len( aDadosInv )
		If Val( aDadosInv[nI][7] ) == 0
			lNovoFrm := .T.
		EndIf
		
		If lNovoFrm	
			aDadosOS := { "21",;
						"INVENTARIO",;
						AllTrim(aDadosInv[nI][3]),;
						AllTrim(aDadosInv[nI][4]),;
						"",;
						"",;
						"",;
						"",;
						dAgend,;
						"18:00:00",;
						aDadosInv[nI][2],;
						aDadosInv[nI][6],;
						"",;
						"Aponte o inventแrio assim que realizar todas as OS de abastecimento do dia.",;
						aDadosInv[nI][1],;
						aDadosInv[nI][2],;
						"",;
						"",;
						"",;
						"000001",;
						"0001"}     
																		
		EndIf
		
		If !lSimula
			If lNovoFrm
				If !Empty(aDadosOS)
					cNumOS := U_MOBILE(aDadosOS)
				EndIf
			EndIf
			
			If !Empty(cNumOS)
				If Val(cNumOs) > 0
					Conout("#TTOPER02 -> OS DE INVENTARIO CRIADA: " +cNumOs)
				EndIf
			EndIf		
		Else
			cNumOS := CVALTOCHAR(nIst1)
		EndIf
	Next nI
EndIf
*/

// dispara o email
If Len(aOS) > 0                                          
	nQtdOS := Len(aOS)
	cBody := CorpoEmail(aOS,aERROS,lSimula)
	U_TTMailN(cRemete,cTarget,cSubject,cBody,aAttach,.F.)
EndIf              

If lJob
	RpcClearEnv()
EndIf
    
Return nQtdOS


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCorpoEmail บAutor  ณJackson E. de Deus บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o corpo do email                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CorpoEmail(aOS,aERROS,lSimula)

Local cBody := ""
Local nI := 0          
Local nTpServ := 0
Local cNomeAgente := ""
Local cFormulario := ""
Local nRecnoSZR := 0
Local nAgenteOs := 0
LOcal cTecnico := ""
Default aERROS := {}

// Gera o html para enviar por email 
cbody := "<html>"
cbody += "<head>"
cbody += "<title>Abertura de Ordens de Servi็o</title>"

// Estilos
cbody += "<style type='text/css'>"
cbody += "	table.bordasimples {border-collapse: collapse;}"
cbody += "	table.bordasimples tr td {border:1px solid #BC8F8F;}"
cbody += "	body { background-color: #FFFFFF;"
cbody += "	color: #5D665B; "
cbody += "	margin: 50px;"
cbody += "	font-family: Georgia, 'Times New Roman', Times, serif;"
cbody += "	font-size: small;"
cbody += " 	}"
cbody += "</style>"
cbody += "</head>"

// Corpo	
cbody += "<body>"
If lSimula
	cbody += "<p><strong>Simula็ใo</strong></p>"
EndIf
cbody += "<p><strong>Plano de trabalho - Abertura de Ordens de Servi็o</strong></p>"
cbody += "<p>&nbsp;</p>"


// Tabela com os dados
//cbody += "<p><strong>Ordens de Servi็o abertas:</strong></p>"
cbody += "<table class='bordasimples'>"          
cbody += "<tr>"	
cbody += 	"<th>OS</th>"
cbody += 	"<th>Cliente</th>"
cbody += 	"<th>Loja</th>"
cbody += 	"<th>Nome</th>"
cbody += 	"<th>Patrim๔nio</th>"
cbody += 	"<th>Rota</th>"
//cbody += 	"<th>Nota Fiscal</th>"
//cbody += 	"<th>S้rie</th>"
cbody += 	"<th>Agente</th>"
cbody += 	"<th>Nome</th>"
cbody += 	"<th>Formulแrio</th>" 
cbody += 	"<th>Hora agendada</th>" 
cbody += "</tr>"

dbSelectArea("SZR")			
For nI := 1 To Len(aOS)
	nTpServ := aOS[nI][9]
	nRecnoSZR := aOS[nI][11]
	cHoraAgend	:= StrTran(aOS[nI][10],".",":")
	nAgenteOs := aOS[nI][8]
	cTecnico := aOS[nI][12]
	
	
	If nTpServ == 3
		cFormulario := "Sangria"   	
	ElseIf nTpServ == 4 .Or. nTpServ == 8
	  	cFormulario := "Abastecimento"	
	ElseIf nTpServ == 2
		cFormulario := "Leitura de Mแquina"
	EndIf
    
    If nRecnoSZR > 0  
		dbGoTo(nRecnoSZR)
		If Recno() == nRecnoSZR
			If Empty(SZR->ZR_NUMOS) .And. !lSimula
				AADD( aERROS, { SZR->ZR_ROTA, SZR->ZR_CHAPA }  )
			EndIf
			
			cbody += "<tr>"							
			cbody += 	"<td>" +SZR->ZR_NUMOS +"</td>"	
			cbody += 	"<td>" +SZR->ZR_CLIENTE +"</td>"	
			cbody += 	"<td>" +SZR->ZR_LOJA +"</td>"	
			cbody += 	"<td>" +Posicione("SA1",1,xFilial("SA1") +SZR->ZR_CLIENTE +SZR->ZR_LOJA,"A1_NREDUZ" ) +"</td>"	
			cbody += 	"<td>" +SZR->ZR_CHAPA +"</td>"	
			cbody += 	"<td>" +SZR->ZR_ROTA +"</td>"	
			cbody += 	"<td>" +cTecnico +"</td>"
			cbody += 	"<td>" +Posicione("AA1",1,xFilial("AA1") +AvKey(cTecnico,"AA1_CODTEC") ,"AA1_NOMTEC" ) +"</td>"	
			cbody += 	"<td>" +cFormulario +"</td>"
			cbody += 	"<td>" +cHoraAgend +"</td>"
			cbody += "</tr>"
		EndIf
	EndIf		
Next nI
cbody += "</table>"

cbody += "<p>&nbsp;</p>"

// Colocado para ajudar identificar os patrimonios que ficam sem OS
If Len(aERROS) > 0
	cbody += "<p><strong><font color = 'red'>Erros - Ordens de Servi็o nใo geradas</font></strong></p>"
	cbody += "<table class='bordasimples'>"          
	cbody += "<tr>"	
	cbody += 	"<th>Rota</th>"
	cbody += 	"<th>Patrim๔nio</th>"
	cbody += "</tr>"
	
	For nI := 1 To Len(aERROS)
		cbody += "<tr>"							
		cbody += 	"<td>" +aERROS[nI][1] +"</td>"	
		cbody += 	"<td>" +aERROS[nI][2] +"</td>"	
		cbody += "</tr>"
	Next nI
	cbody += "</table>"
	
	cbody += "<p>&nbsp;</p>"
EndIf	

cbody += "<p>E-mail automแtico enviado via protheus.</p>"
cbody += "<p>Favor nใo responder.</p>"
cbody += "</body>"
cbody += "</html>
  
Return cBody


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER02  บAutor  ณMicrosiga           บ Data ณ  05/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OSInvent( dAgend )

Local aDadosInv := {}
Local cQuery := ""

cQuery := "SELECT * FROM " +RetSqlName("ZZ1") + " ZZ1 "
cQuery += " INNER JOIN " +RetSqlName("AA1") + " AA1 ON "
cQuery += " AA1_CODTEC = ZZ1_XATEND AND AA1.D_E_L_E_T_ = '' " 
cquery += " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND SUBSTRING(ZZ1_COD,1,1) = 'P' AND ZZ1_MSBLQL = '2' AND ZZ1.D_E_L_E_T_ = '' AND ZZ1_XATEND <> '' AND ZZ1_XAGEND <> '' "

MPSysOpenQuery( cQuery , "TRBI" )                        

dbSelectArea("TRBI")
While TRBI->(!EOF())

	If Val(TRBI->ZZ1_XAGEND) <> Dow(dAgend)
		TRBI->(dbSkip())
		Loop
	EndIf

	AADD( aDadosInv, { "A" +SubStr(TRBI->ZZ1_COD,2),;
						 TRBI->ZZ1_DESCRI,;
						  TRBI->ZZ1_XATEND,;
						  TRBI->ZZ1_XNOMAT,;
						   TRBI->ZZ1_XAGEND,;
						   AllTrim(TRBI->ZZ1_END) +"," +AllTrim(TRBI->ZZ1_MUN) +"," +AllTrim(TRBI->ZZ1_EST),;
						   TRBI->AA1_PAGER } )
	TRBI->(dbSkip())
End


Return aDadosInv


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlTrab    บAutor  ณJackson E. de Deus  บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca no trabalho de trabalho o que tem para a data do dia  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PlTrab(cRota,dData,lSimula)

Local cQuery := ""
Local nJ, nX    
Local nPosd	:= 0
Local cDiasMensal := ""
Local cMes := ""
Local aAux := {}
Local aAux2 := {}
Local aRotas := {}
Local cDia := ""
Local aTecInfo := {"","","",""}
Local aDados := {}
Local dDiaMes := ""
Local nPosDia := 8
Local axSEQ := {}
Local aAxSq := {}
Local nSeq := 0
Local nCount := 0

Default cRota := ""
Default dData := Date()
Default lSimula := .F.

nPosDia += Day(dData)
cMes := SubStr(dtos(dData),1,6)
                                                     
// monta query
cQuery += "SELECT "
cQuery += " ZE_FILIAL, ZE_CLIENTE, ZE_LOJA, ZE_FREQUEN, ZE_FECHAME, ZE_CHAPA, ZE_ROTA, ZE_MENSAL, ZE_TIPOPLA, ZE_SEQ, AA1_PAGER, ZE_TABELA, "
cQuery += " AA1_XFILAT, AA1_XEMPRE, AA1_CODTEC, NL_DESCRIC, A1_END, A1_MUN, A1_EST, N1_PRODUTO, AA1_TURNO, N1_XSISPG, ZE_ROTAAUX, ZE_SEQAUX, "          
cQuery += " SUBSTRING(ZE_MENSAL,"+CVALTOCHAR(nPosDia)+",1) AS TROCA,N1_XPA"

cQuery += " FROM " +RetSqlName("SZE") + " SZE "

cQuery += " INNER JOIN " +RetsqlName("AA1") + " AA1 ON "
cQuery += " AA1.AA1_LOCAL = SZE.ZE_ROTA AND AA1.D_E_L_E_T_ = SZE.D_E_L_E_T_ " 

cQuery += " INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
cQuery += " A1_COD = SZE.ZE_CLIENTE AND A1_LOJA = ZE_LOJA AND SA1.D_E_L_E_T_ = SZE.D_E_L_E_T_ "

cQuery += " INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
cQuery += " SN1.N1_CHAPA = SZE.ZE_CHAPA AND SN1.D_E_L_E_T_ = SZE.D_E_L_E_T_ "

cQuery += " LEFT JOIN " +RetSQLName("SNL") +" SNL ON "
cQuery += " SNL.NL_CODIGO = SN1.N1_LOCAL AND SNL.D_E_L_E_T_='' "
cQuery += " WHERE ZE_MENSAL LIKE '%"+cMes+"%' AND SUBSTRING(ZE_MENSAL,"+CVALTOCHAR(nPosDia)+",1) IN ('1','F','T') "

If !Empty(cRota)
	cQuery += " AND ZE_ROTA IN ('"+cRota+"') "
EndIf

cQuery += " AND SZE.D_E_L_E_T_ = '' AND ZE_CLIENTE <> '' AND ZE_LOJA <> '' AND ZE_CHAPA <> '' " 
cQuery += " ORDER BY ZE_ROTA, ZE_SEQ"

cQuery := ChangeQuery(cQuery)

MemoWrite("TTOPER02_1"+DTOS(dData) +".SQL",cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()  
While !EOF()
	axSEQ := {}                            
	AADD(aDados, {TRB->ZE_FILIAL, TRB->ZE_CLIENTE, TRB->ZE_LOJA, TRB->ZE_FREQUEN, TRB->ZE_FECHAME, TRB->ZE_CHAPA, TRB->ZE_ROTA, TRB->ZE_MENSAL,;
					TRB->ZE_TIPOPLA, Val(TRB->ZE_SEQ), TRB->AA1_PAGER, TRB->AA1_XFILAT, TRB->AA1_XEMPRE, TRB->AA1_CODTEC,; 
					IIF(cDia=="F",.T.,.F.),;	//[15] fechamento?
					"",;						//[16] hora agendamento
					IF(!EMPTY(TRB->NL_DESCRIC),TRB->NL_DESCRIC,TRB->A1_END), IF(!EMPTY(TRB->NL_DESCRIC),'',TRB->A1_MUN), TRB->A1_EST, TRB->N1_PRODUTO,;
					"",;						//[21] tempo prep maquina
					"",;						//[22] tempo deslocamento
					TRB->AA1_TURNO, TRB->N1_XSISPG, If(TRB->TROCA=="T",TRB->ZE_TABELA,''),TRB->N1_XPA, 0 })
						
			
	// Residente - Mais de um atendimento para o mesmo patrimonio e mesmo residente                         
	If AllTrim(TRB->ZE_FREQUEN) $ "2D|3D" .And. Empty(TRB->ZE_ROTAAUX)
		If Empty(TRB->ZE_SEQAUX)
			AADD( axSEQ, Val(TRB->ZE_SEQ) ) 
		Else
			aAxSq := StrToKarr( TRB->ZE_SEQAUX, "/" )
			If Len(aAxSq) > 0
				For nX := 1 To Len(aAxSq)
					AADD( axSEQ, Val(aAxSq[nX]) )
				Next nX
			EndIf	
		EndIf
		
		For nX := 1 To Len(axSEQ)	// para cada sequencia -> UMA OS DIFERENTE
			nSeq := axSEQ[nX]
			AADD(aDados, {TRB->ZE_FILIAL, TRB->ZE_CLIENTE, TRB->ZE_LOJA, TRB->ZE_FREQUEN, TRB->ZE_FECHAME, TRB->ZE_CHAPA, TRB->ZE_ROTA,;	
						TRB->ZE_MENSAL, TRB->ZE_TIPOPLA, nSeq, TRB->AA1_PAGER, TRB->AA1_XFILAT, TRB->AA1_XEMPRE, TRB->AA1_CODTEC,;			
						IIF(cDia=="F",.T.,.F.), "", IF(!EMPTY(TRB->NL_DESCRIC),TRB->NL_DESCRIC,TRB->A1_END), IF(!EMPTY(TRB->NL_DESCRIC),'',TRB->A1_MUN),;			
						TRB->A1_EST, TRB->N1_PRODUTO, "", "", TRB->AA1_TURNO, TRB->N1_XSISPG, If(TRB->TROCA=="T",TRB->ZE_TABELA,''),TRB->N1_XPA,0 })			
		Next nX						
	EndIf
			
	// Residente - Mais de um atendimento para o mesmo patrimonio e residentes diferentes				
	If AllTrim(TRB->ZE_FREQUEN) $ "2D|3D" .And. !Empty(TRB->ZE_ROTAAUX)
		If Empty(TRB->ZE_SEQAUX)
			AADD( axSEQ, Val(TRB->ZE_SEQ) ) 
		Else
			aAxSq := StrToKarr( TRB->ZE_SEQAUX, "/" )
			If Len(aAxSq) > 0
				For nX := 1 To Len(aAxSq)
					AADD( axSEQ, Val(aAxSq[nX]) )
				Next nX
			EndIf	
		EndIf
		
		aAux := StrToKarr(TRB->ZE_ROTAAUX,"/")
		For nJ := 1 To Len(aAux)
			If Len(axSEQ) >= nJ
				nSeq := axSEQ[nJ]
			Else
				nSeq := Val(TRB->ZE_SEQ)
			EndIf
		
			aTecInfo := {"","","",""}
			ChkTec(aAux[nJ],@aTecInfo)
			If !Empty(aTecInfo[1])
				AADD(aDados, {TRB->ZE_FILIAL, TRB->ZE_CLIENTE, TRB->ZE_LOJA, TRB->ZE_FREQUEN, TRB->ZE_FECHAME, TRB->ZE_CHAPA, aAux[nJ],;		
							TRB->ZE_MENSAL, TRB->ZE_TIPOPLA, nSeq, aTecInfo[1], aTecInfo[2], aTecInfo[3], aTecInfo[4],;			
							IIF(cDia=="F",.T.,.F.), "", IF(!EMPTY(TRB->NL_DESCRIC),TRB->NL_DESCRIC,TRB->A1_END), IF(!EMPTY(TRB->NL_DESCRIC),'',TRB->A1_MUN),;		
							TRB->A1_EST, TRB->N1_PRODUTO, "", "", TRB->AA1_TURNO, TRB->N1_XSISPG, If(TRB->TROCA=="T",TRB->ZE_TABELA,''),TRB->N1_XPA,0 })			
			EndIf
		Next nJ
	EndIf

	TRB->(dbSkip())
End

dbCloseArea()

aAux := {}

// Ordena o Array: Rota -> Sequencia
For nI := 1 To Len(aDados)     
	If aScan( aRotas, { |x| AllTrim(x) == AllTrim(aDados[nI][7]) } ) > 0
		Loop
	EndIf
	AADD( aRotas, aDados[nI][7] )
Next nI

For nI := 1 To Len(aRotas)
	For nJ := 1 To Len(aDados)
		If aDados[nJ][7] == aRotas[nI]
			AADD( aAux, aDados[nJ] )
		EndIf
	Next nJ
	aSort( aAux,,,{ |x,y| x[10] < y[10] } )
	AADD( aAux2, aAux )
	aAux := {}
Next nI

aDados := {}

// se for chamado do plano de trabalho - faz todo o calculo
If IsInCallStack("U_TTOPER01") .And. !lSimula
	aDados := CalcHora2(dData,@aAux2)
// retorna os horarios previamente configurados no plano de trabalho - ja gravados na SZR
Else
	If Len(aAux2) > 0                                               
		aDados := CalcHora1(dData,@aAux2,lSimula)
	EndIf
EndIf	


Return aDados
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkTec	บAutor  ณJackson E. de Deus  บ Data ณ  31/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca dados do Tecnico com base no codigo da Rota           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkTec(cLocal,aTecInfo)

Local cSql := ""
Local aArea := GetArea()

cSql := "SELECT AA1_PAGER, AA1_XFILAT, AA1_XEMPRE, AA1_CODTEC, AA1_TURNO FROM " +RetSqlName("AA1") + " WHERE AA1_LOCAL = '"+cLocal+"' "

If Select("TRBX") > 0
	TRBX->( dbCloseArea() ) 
EndIf                     
       
TcQuery cSql New Alias "TRBX"

dbSelectArea("TRBX")
While !EOF()
	aTecInfo[1] := TRBX->AA1_PAGER
	aTecInfo[2] := TRBX->AA1_XFILAT
	aTecInfo[3] := TRBX->AA1_XEMPRE
	aTecInfo[4] := TRBX->AA1_CODTEC
	aTecInfo[5] := TRBX->AA1_TURNO
	TRBX->(dbSkip())
End
            
TRBX->(dbCloseArea())
    
RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTempoMaq  บAutor  ณJackson E. de Deus  บ Data ณ  21/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca o tempo de preparacao das maquinas                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TempoMaq(aAux2)

Local cQuery := ""
Local nI,nJ,nPos := 0
Local aTempos := {}

cQuery := "SELECT * FROM " +RetSqlName("ZZP") +" WHERE D_E_L_E_T_ = '' "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
                        
TcQuery cQuery New Alias "TRBZ" 

dbSelectArea("TRBZ")
While !EOF()
	AADD( aTempos, {TRBZ->ZZP_CODIGO, TRBZ->ZZP_TEMPO} )
	dbSkip()	
End

For nI := 1 To Len(aAux2)
	For nJ := 1 To Len(aAux2[nI])
		nPos := aScan( aTempos, { |x|, AllTrim(x[1]) == AllTrim(aAux2[nI][nJ][20]) } ) 
		If nPos > 0
			If substr(aAux2[nI][nJ][07],1,2) == "RT" .And. substr(aAux2[nI][nJ][09],1,1) != "1"
				aAux2[nI][nJ][21] := "00:00"
			Else
				aAux2[nI][nJ][21] := SubStr(aTempos[nPos][2],1,2) + ":" + SubStr(aTempos[nPos][2],3)
			EndIf
		EndIf
	Next nJ		
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSmaHra  บAutor  ณJackson E. de Deus    บ Data ณ  21/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSoma horas                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SmaHra(cHora1,cHora2)

Local cHoraRet := ""
Local cAux := ""
Default cHora1 := Nil
Default cHora2 := Nil

If cHora1 == Nil .Or. cHora2 == Nil
	Return Nil
EndIf
   
cHoraRet := SomaHoraS(cHora1,cHora2) 
cHoraRet := cValToChar(cHoraRet)

If Len(cHoraRet) < 3
	cHoraRet := PadL(cHoraRet,2,'0')
	cHoraRet := cHoraRet + ":00"
EndIf
cHoraRet := StrTran(cHoraRet,".",":")

If Len( SubStr( cHoraRet, At(":",cHoraRet)+1 ) ) == 1
	cHoraRet += "0"
EndIf

If Len( SubStr( cHoraRet, 1,At(":",cHoraRet)-1 ) ) == 1
	cHoraRet := "0" +cHoraRet
EndIf

Return cHoraRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSubHra  บAutor  ณJackson E. de Deus    บ Data ณ  27/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSubtrai horas                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SubHra(cHora1,cHora2)

Local cHoraRet := ""
Default cHora1 := Nil
Default cHora2 := Nil

If cHora1 == Nil .Or. cHora2 == Nil
	Return Nil
EndIf
   
cHoraRet := SubHoras(cHora1,cHora2) 
cHoraRet := cValToChar(cHoraRet)

If Len(cHoraRet) == 1
	cHoraRet += "0:00"
EndIf  
cHoraRet := StrTran(cHoraRet,".",":")

If Len( SubStr( cHoraRet, At(":",cHoraRet)+1 ) ) == 1
	cHoraRet += "0"
EndIf

If Len( SubStr( cHoraRet, 1,At(":",cHoraRet)-1 ) ) == 1
	cHoraRet := "0" +cHoraRet
EndIf

Return cHoraRet

             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTmpDesloc  บAutor  ณJackson E. de Deus บ Data ณ  27/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o deslocamento entre 2 enderecos                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TmpDesloc(cOrigem,cDestino)

Local cXml := ""
Local cError := ""
Local cWarning := ""
Local aDados := {} 
Local cTempo := ""
Local nMin := 0
Local nSeg := 0
Local lFim := .F.
Local nTotalHora := 0 
Local cTipo := "xml"
Local cRet := ""

Default cOrigem := ""
Default cDestino := ""

If Empty(cOrigem) .Or. Empty(cDestino)
	Return cTempo
EndIf

If " " $ cOrigem
	cOrigem := StrTran(cOrigem," ","+")
EndIf                                

If " " $ cDestino
	cDestino := StrTran(cDestino," ","+")
EndIf  
       

cRet := U_XGAPI02(cTipo,cOrigem,cDestino)

// retorno em xml
If cTipo == "xml"
	/*
	OK: indica que a resposta cont้m um result vแlido.
	INVALID_REQUEST: indica que a solicita็ใo fornecida ้ invแlida.
	MAX_ELEMENTS_EXCEEDED: indica que o produto de origem vezes o destino excede o limite por solicita็ใo.
	OVER_QUERY_LIMIT: indica que o servi็o recebeu muitas solicita็๕es de seu aplicativo no perํodo de tempo permitido.
	REQUEST_DENIED: indica que o servi็o negou o uso da Matriz de distโncias ao seu aplicativo.
	UNKNOWN_ERROR:ทindica que nใo foi possํvel processar uma solicita็ใo da Matriz de distโncias devido a um erro do servidor. A solicita็ใo pode ser processada; tente novamente.
	*/
	If Empty(cRet)
		Return cTempo
	EndIf
	nPos := At("Content",cRet)
   	If "200 OK" $ SubStr(cRet,1,nPos) 
    	nPosIni := At("<?xml",cRet)
    	cRet := SubStr(cRet,nPosIni)
 	EndIf

	oXml := XmlParser( cRet, "_", @cError, @cWarning )
	If (oXml == NIL )	
		//MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
		Return cTempo
	Endif
	If AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_STATUS:TEXT ) == "OK"
		If  AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_ROW:_ELEMENT:_STATUS:TEXT ) == "OK"
			nSeg := Val( oXml:_DISTANCEMATRIXRESPONSE:_ROW:_ELEMENT:_DURATION:_VALUE:TEXT )	// duracao - segundos
		EndIf
	ElseIf AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_STATUS:TEXT ) $ "INVALID_REQUEST|OVER_QUERY_LIMIT|REQUEST_DENIED"
		
		U_TTGENC01(xFilial("SZR"),"TTOPER02","DISTANCIA - GOOGLE","","","",cusername,dtos(date()),time(),,AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_STATUS:TEXT ),"","","SZR")	
		// SERVICO NEGADO
		//U_TTMAILN('microsiga@toktake.com.br','jdeus@toktake.com.br','Google API',oXml:_DISTANCEMATRIXRESPONSE:_ERROR_MESSAGE:TEXT,{},.F.)
		Return cTempo
	EndIf		
/*
// retorno em json
ElseIf cTipo == "json"

*/
EndIf                          

While !lFim
	If nSeg >= 60
		nMin += 1
		nSeg := nSeg - 60		
	EndIf

	If nMin >= 60
		nTotalHora += 1
		nMin := nMin - 60
	EndIf	
	                 
	If nSeg <= 59 .And. nMin <= 59
		lFim := .T.
	EndIf
End

If nTotalHora > 0 .Or. nMin > 0
	cTempo := PADL( cvaltochar(nTotalHora), 2, "0" ) +":" +PADL( cvaltochar(nMin),2,"0" ) //+":" +cvaltochar(nSeg)
EndIf

// log quantidade
U_TTGENC01(xFilial("SZR"),"TTOPER02","DISTANCIA - GOOGLE","","","",cusername,dtos(date()),time(),,"CONSUMO API","","","SZR")	

Return cTempo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcHora1  บAutor  ณJackson E. de Deus บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o horario do patrimonio para a rota conforme  o diaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcHora1(dDiaMes,aAux2,lSimula)
                  
Local cHora := ""
Local cCodFil := ""
Local cRota := ""
Local cCliente := ""
Local cLoja := ""
Local cPatrim := ""                    
Local cTpPlan := ""
Local cDiaMes := StrZero(Day(dDiaMes),2)
Local cAno := cvaltochar(Year(dDiaMes))
Local cMes := StrZero(Month(dDiaMes),2)
Local aHoras := {}
Local aDados := {}
Local cHora := ""                 
Local nRecZR := 0
Local cNumOS := ""        

For nI := 1 To Len(aAux2)
	For nJ := 1 To Len(aAux2[nI])
		cCodfil := aAux2[nI][nJ][1]
		cRota := aAux2[nI][nJ][7]
		cCliente := aAux2[nI][nJ][2]
		cLoja := aAux2[nI][nJ][3]
		cPatrim := aAux2[nI][nJ][6]
		cSeq := cvaltochar(aAux2[nI][nJ][10])
		cTpPlan := aAux2[nI][nJ][9]
		cHora := "" 
		nRecZR := 0
		cNumOS := ""
		
		If FindFunction("U_TTOPER06")		
			aHoras := U_TTOPER06( cCodfil,cRota, cCliente, cLoja, cPatrim, cAno, cMes, cDiaMes, cSeq, cTpPlan)
			If Len(aHoras) > 0
				cHora := AllTrim(aHoras[1][8])
				nRecZR := aHoras[1][10]
				cNumOS := aHoras[1][11]
			//Else
				//U_TTOPER07(cCodFil,cRota,cCliente,cLoja,cPatrim,cAno,cMes,cDia,"",cSeq)
			EndIf
		EndIf		                                         
		If Empty(cHora) .Or. cHora == ": :" 
			cHora := "08:12"
		EndIf
		aAux2[nI][nJ][16] := cHora
		aAux2[nI][nJ][27] := nRecZR
		
		If Empty(cNumOS) .Or. lSimula	// somente considerar caso OS nao tenha sido gerada ainda
			AADD( aDados, aAux2[nI][nJ] )
		EndIf
	Next nJ	
Next nI

Return aDados


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcHora2  บAutor  ณJackson E. de Deus บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula o horario do patrimonio para a rota conforme  o diaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcHora2(dDiaMes,aAux2)

Local cHoraAgend := ""
Local cTmpDesloc := ""
Local lFimRota := .F.
Local aTurno := ""
Local aAuxHr := ""
Local cHrIni := ""
Local cHrIniAlm := ""
Local cHrFimAlm := ""
Local cHrFim := ""
Local nPos := 0
Local cHrIniSab := ""
Local cHrFimSab := ""
Local aDados := {}
Local aCalculado := {}	// patrimonios com horario ja calculado
Local cRota := ""
Local aFunc := {} 	

TempoMaq(@aAux2)
	
For nI := 1 To Len(aAux2)
	lFimRota := .F.

	cHrTurno := ""
	aAuxHr := {}
	cHrIni := ""
	cHrIniAlm := ""
	cHrFimAlm := ""
	cHrFim := ""
	For nJ := 1 To Len(aAux2[nI])
   		cRota := aAux2[nI][nJ][7]
   	
		// desconsidera patrimonio ja calculado - patrimonio duplicado por causa de tipo de servico diferente
		If AScan( aCalculado, { |x| AllTrim(x[1]) == AllTrim(aAux2[nI][nJ][6]) .And. x[2] == aAux2[nI][nJ][10] }  ) > 0
			Loop
		EndIf
		
		// Calcula o horario do atendimento
		If nJ == 1
			aTurno := StaticCall( TTOPER17,Turno,aAux2[nI][nJ][23],dDiaMes )	//HoraFunc(aAux2[nI][nJ][14],aAux2[nI][nJ][23]) 
			If !Empty(aTurno)
				If Len(aTurno) >= 4
					cHrIni := aTurno[1]
					cHrIniAlm := aTurno[2]
					cHrFimAlm := aTurno[3]
					cHrFim := aTurno[4]
				EndIf
				// trata o sabado
				If Dow(dDiaMes) == 7
					If Len(aAuxHr) >= 2
						cHrIni := aTurno[1]
						cHrFim := aTurno[2]
					EndIf
				EndIf	
			EndIf
		EndIf
		
		If Empty(cHrIni)
			cHrIni := "08:12"
		EndIf
		
		cTempoMaq := If( substr(cRota,1,2)=="RT","00:10",aAux2[nI][nJ][21] )
			
		// Se primeiro atendimento - hora inicial do turno do funcionario + tempo da maquina
		If nJ == 1
			// hora inicio do turno + tempo de preparacao da maquina
			cHoraAgend := SmaHra( cHrIni,cTempoMaq )
			
			// Se rota estiver na ZZ1, considerar tempo de deslocamento ate o cliente
			dbSelectArea("ZZ1")
			If dbSeek( xFilial("ZZ1") +AvKey(cRota,"ZZ1_COD") )
				ChkFunc( aAux2[nI][nJ][14], @aFunc )
				If Len(aFunc) == 2
					cOrigem := AllTrim( aFunc[1] +"," +aFunc[2] )
					cDestino := AllTrim( aAux2[nI][nJ][17]) +"," +AllTrim(aAux2[nI][nJ][18] ) 
					cTmpDesloc := TmpDesLoc( cOrigem,cDestino )
				EndIf		 
			EndIf
			If Empty(cTmpDesloc)
				cTmpDesloc := "00:30"
			EndIf
			cHoraAgend := SmaHra( cHoraAgend,cTmpDesloc )
      			
		// hora final do ultimo atendimento + tempo da maquina
		Else
			cOrigem := AllTrim(aAux2[nI][nJ-1][17]) +"," +AllTrim(aAux2[nI][nJ-1][18])
			cDestino := AllTrim(aAux2[nI][nJ][17]) +"," +AllTrim(aAux2[nI][nJ][18]) 
			
			If nJ == Len(aAux2[nI])
				lFimRota := .T.
			EndIf
			
			If !lFimRota
				// Se o proximo cliente/loja forem iguais
				If aAux2[nI][nJ-1][2] == aAux2[nI][nJ][2] .And. aAux2[nI][nJ-1][3] == aAux2[nI][nJ][3]
					cTmpDesloc := "00:05"
				Else
					//if provisorio
					If substr(cRota,1,2) != "RT"
						cTmpDesloc := TmpDesLoc(cOrigem,cDestino)
					Else
						cTmpDesloc := "00:10"
					EndIf
					If Empty(cTmpDesloc)
						cTmpDesloc := "00:30"
					EndIf
				EndIf                                        
				
				cHoraAgend := SmaHra(cHoraAgend,cTmpDesloc)
				cHoraAgend := SmaHra(cHoraAgend,cTempoMaq) 	
			Else
				//if provisorio
				If substr(cRota,1,2) != "RT"
					cTmpDesloc := TmpDesLoc(cOrigem,cDestino)
				Else
					cTmpDesloc := "00:10"
				EndIf
					
				If Empty(cTmpDesloc)
					cTmpDesloc := "00:30"
				EndIf
				cHoraAgend := SmaHra(cHoraAgend,cTmpDesloc) 
				cHoraAgend := SmaHra(cHoraAgend,cTempoMaq)
			EndIf	
		EndIf
		
		// Ate 15 min antes do almoco - atende - caso contrario ADIAR
		If cHoraAgend > SubHra( cHrIniAlm,"00:01" ) .And. cHoraAgend <= cHrFimAlm
			cHoraAgend := SmaHra( cHrFimAlm,cTempoMaq )
		EndIf
		
		// Se passar do dia atual considera mesmo horario do patrimonio anterior
		If cHoraAgend > "23:59"
			cHoraAgend := aAux2[nI][nJ-1][16]
		EndIf
		
		aAux2[nI][nJ][16] := cHoraAgend
		
		AADD( aCalculado, { aAux2[nI][nJ][6],aAux2[nI][nJ][10]  } )
		AADD( aDados, aAux2[nI][nJ] )
	Next nJ	
Next nI

Return aDados

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkFunc  บAutor  ณJackson E. de Deus   บ Data ณ  16/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna dados do funcionario - SRA                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkFunc(cMat, aFunc)

Local cQuery := ""
Local cEmpresa := ""

Default cMat := ""

If Empty(cMat)
	Return
EndIf     

dbSelectArea("AA1")
dbSetOrder(1)
If dbSeek( xFilial("AA1") +AvKey(cMat,"AA1_CODTEC") )
	cEmpresa := AllTrim(AA1->AA1_XEMPRE)
	If Empty(cEmpresa)
		Conout("#TTOPER02 - Cadastro de Tecnico sem campo 'Empresa' preenchido #")
		Return
	EndIf     
	
	cQuery := "SELECT RA_ENDEREC, RA_MUNICIP FROM SRA" +cEmpresa +"0" +" WHERE RA_MAT = '"+cMat+"' AND D_E_L_E_T_ = '' "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf                  
	
	TcQuery cQuery New Alias "TRB"         
	dbSelectArea("TRB")
	If !EOF()
		If !Empty(TRB->RA_ENDEREC) .And. !Empty(TRB->RA_MUNICIP)
			AADD( aFunc, AllTrim(TRB->RA_ENDEREC) )
			AADD( aFunc, AllTrim(TRB->RA_MUNICIP) )
		EndIf
	EndIf
	                 
	dbCloseArea()
EndIf

Return