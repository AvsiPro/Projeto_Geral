#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTA11  บAutor  ณJackson E. de Deus  บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Renova os contratos passados via parametro.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ04/11/13ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTCNTA11(aContratos,lJob)

Private lGravou	:= .F.
Private lEnd := .F.

Default aContratos := {}

If cEmpAnt == "01"
	
	If !lJob
		oProcess := MsNewProcess():New( {|lEnd| Ajusta(aContratos, @oProcess, @lEnd) }, "Renova็ใo de contratos", "Renovando os contratos..", .T. )
		oProcess:Activate()
	Else
		ConOut("## Iniciando renovacao dos contratos.. ## ")
	EndIf                                                 
EndIF
    	
Return lGravou

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta บAutor ณJackson E. de Deus    	 บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Renova os contratos selecionados.						  บฑฑ
ฑฑบ          ณ        													  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ajusta(aContratos, oProcess, lEnd)

Local oExcel
Local cContrato		:= ""
Local cSituacao		:= ""
Local dDtAtual		:= Date()
Local dDtIni
Local dDtFim
Local dNovoInicio
Local dNovoFim
Local nVigencia		:= 0
Local nAnos			:= 0
Local nDias			:= 0
Local dAno
Local nCont			:= 0
Local cCronog
Local nParcel
Local cCompet
Local dVencto
Local nValParc
Local nMaxPar
Local nDiaPar
Local nMoeda
Local cPeriod
Local cCondPg
Local cCompetAux
Local cDiaComp
Local cMesComp
Local cAnoComp										
Local nParcelCNS
lOCAL dDtIniPlan
Local dDtEmissao										
Local cNaturez		:= ""
Local aTitulos		:= {}
Local cTitulo		:= ""
Local aSE1			:= {}
Local lCancelou		:= .F.
Local aAux			:= {}
Local lErroSE1		:= .F.
Local lAltCNB		:= .F.
Local nSaldoCont	:= 0
Local nTotCNB		:= 0
Local nTotMed		:= 0
Local lTemCNF		:= .T.

Private cpCliente	:= ""			// codigo do cliente
Private cpLoja		:= ""			// loja do cliente
Private lMsErroAuto	:= .F.

Default lEnd		:= .F.			// valor default para a variavel logica de controle da MsNewProcess
     
                               

If !lJob
	oProcess:SetRegua1(Len(aContratos))
EndIf

BeginTran()
For nI := 1 To Len(aContratos)
	aAux := {.F.,;	// atualizou contrato?
			.F.,;	// atualizou cronograma financeiro?
			.F.,;	// atualizou cronograma fisico?
			.F.}	// atualizou titulos a receber?
	
	cContrato := aContratos[nI][1]
	dDtIni := aContratos[nI][2]
	dDtFim := aContratos[nI][3]
	cpCliente := aContratos[nI][4]
	cpLoja := aContratos[nI][5]
	
	lAltCNB := .F.
	lErroSE1 := .F.              
	nParcel := 0
	nParcelCNS := 0
	aTitulos := {}
	nCont := 0
	cCompetAux := ""
	dDtEmissao := ctod("  /  /    ")
	cSituacao := GetAdvFVal("CN9","CN9_SITUAC",xFilial("CN9")+cContrato,1)
	
	If cSituacao <> "05"	// considera somente contratos vigentes
		//Loop
	EndIf
		
	If lEnd
		DisarmTransaction()
		lCancelou := .T.		
		Exit		
	EndIf
	
	If !lJob
		oProcess:IncRegua1("Contrato: " +cContrato)
		sleep(5)
	EndIf
	
	If !lJob
		oProcess:SetRegua2(4)	// 4 passos: contrato - cronograma financeiro - cronograma fisico - titulos provisorios	  
	EndIf

	// Pega a vigencia - 12/24/36/48.. se for 0 considera 12 meses
	nVigencia := GetAdvFVal("CN9","CN9_VIGE",xFilial("CN9")+cContrato,1)
	If nVigencia == 0
		nVigencia := 12
	EndIf
	nAnos := nVigencia/12
	
	For dAno := Year(dDtFim)+1 To Year(dDtFim)+nAnos
		If (dAno % 4 == 0 .And. (dAno % 400 == 0 .Or. dAno % 100 <> 0))
			nDias += 366			// bissexto - 366 dias
		Else
			nDias += 365			// nao bissexto - 365 dias
		EndIf       	
	Next dAno
	
	If !lJob
		oProcess:IncRegua2("Atualizando contrato..")
	EndIf
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xFilial("CN9")+cContrato)
		SoftLock("CN9")
		RecLock("CN9",.F.)
		CN9->CN9_DTFIM := dDtFim + nDias	//data do vencimento + qtd dias conforme campo vigencia
		CN9->(MsUnLock())
		// Atualizou contrato aAux[1]
		aAux[1] := .T.
		
		If !lJob
			oProcess:IncRegua2("Atualizando cronograma financeiro..")
		EndIf
		
		dbSelectArea("CNA")
		dbSetOrder(1) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO (filial+contrato+revisao+planilha)
	    If dbSeek(xFilial("CNA") +AvKey(cContrato,"CNA_CONTRA"))
		    SoftLock("CNA")
	    	While CNA->CNA_CONTRA == cContrato .And. CNA->( !EOF() )
	    		
	    		lAltCNB := .F.
	    		
	    		If AllTrim(CNA->CNA_CRONOG) == ""
	    			lTemCNF := .F.	// planilha sem cronograma
	    		EndIf
	    	   
	    	    dDtIniPlan := CNA->CNA_DTINI                                 

		    	// considera somente locacao
	    		If CNA->CNA_TIPPLA <> "001"
	    			CNA->( dbSkip() )
	    			Loop
	    		EndIf
	    		
    			dbSelectArea("CNB")
    			dbSetOrder(1)	//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM 
    			If DbSeek( xFilial("CNB")+AvKey(cContrato,"CNB_CONTRA")+AvKey("","CNA_REVISA") +AvKey(CNA->CNA_NUMERO,"CNB_NUMERO") )
	    			SoftLock("CNB")
    				While CNB->CNB_NUMERO == CNA->CNA_NUMERO .And. CNB->CNB_CONTRA == cContrato .And. CNB->( !EOF() )
    					// Altera a Qtd de parcelas da planilha
    					If RecLock("CNB",.F.)       
	    					CNB->CNB_SLDREC := CNB->CNB_SLDREC + nVigencia
	    					CNB->CNB_SLDMED := CNB->CNB_SLDMED + nVigencia
	    					CNB->CNB_QUANT := CNB->CNB_QUANT + nVigencia
	    					CNB->CNB_VLTOT := CNB->CNB_VLUNIT * CNB->CNB_QUANT
	    					CNB->( MsUnLock() )

   							nTotMed := CNB->CNB_SLDMED * CNB->CNB_VLUNIT	// saldo
	    					nTotCNB := CNB->CNB_VLTOT
	    					lAltCNB := .T.       
    					EndIf
    					
    					// Gera novas parcelas do cronograma financeiro/fisico e titulos
    					If lTemCNF
	    					dbSelectArea("CNF")
							dbSetOrder(3)	// filial + contrato + revisao + cronograma + parcela
							If dbSeek(xFilial("CNF")+AvKey(cContrato,"CNF_CONTRA")+AvKey("","CNF_REVISA") +AvKey(CNA->CNA_CRONOG,"CNF_NUMERO") +AvKey("001","CNF_PARCEL") )
								While CNF->CNF_FILIAL == xFilial("CNF") .And. CNF->CNF_CONTRA == cContrato .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG .And. CNF->( !EOF() )			
									cCronog := CNF->CNF_NUMERO
									nParcel := Val(CNF->CNF_PARCEL)
									cCompet := CNF->CNF_COMPET
									dVencto := CNF->CNF_DTVENC
									nValParc:= CNF->CNF_VLPREV
									nMaxPar := CNF->CNF_MAXPAR
									nDiaPar := CNF->CNF_DIAPAR
									nMoeda := CNF->CNF_TXMOED
									cPeriod := CNF->CNF_PERIOD
									cCondPg := CNF->CNF_CONDPG
									
									nCont++
									CNF->(dbSkip())
								End
							    
							    cCompetAux := cCompet
							    cDiaComp := SubStr( DtoC(dVencto),1,2)
						 
								If nParcel != 0
									If !lJob
										oProcess:SetRegua2(nCont)                  
									EndIf
									
									For nJ := 1 To nVigencia
										nParcel++
										If !lJob
											oProcess:IncRegua2("Parcela: "+StrZero(nParcel,3))
										EndIf
										
										If lEnd
											DisarmTransaction()
											lCancelou := .T.		
											Exit		
										EndIf
										
										cMesComp := SubStr(cCompetAux,1,2) 
										cAnoComp := SubStr(cCompetAux,4)
										If Val(cMesComp) == 12
											cMesComp := "01"
											cAnoComp := Soma1(cAnoComp)
											cCompetAux := cMesComp  +"/" +cAnoComp								
										Else                                             
											cMesComp := Soma1(cMesComp)
											cCompetAux := cMesComp  +"/" +cAnoComp
										EndIf
									
										dVencto := LastDay( CtoD( "01" +"/" +cMesComp +"/" +cAnoComp ) )
											
										RecLock("CNF",.T.)
										CNF->CNF_FILIAL := xFilial("CNF")
							        	CNF->CNF_NUMERO := cCronog
							        	CNF->CNF_CONTRA := cContrato
							        	CNF->CNF_PARCEL := StrZero(nParcel,3)
							        	CNF->CNF_COMPET := cCompetAux 
							        	CNF->CNF_VLPREV := nValParc 
							        	CNF->CNF_SALDO := nValParc 
							        	CNF->CNF_DTVENC := dVencto
							        	CNF->CNF_PRUMED := dVencto
							        	CNF->CNF_MAXPAR := nMaxPar
							        	CNF->CNF_TXMOED := nMoeda
							        	CNF->CNF_PERIOD := cPeriod
							        	CNF->CNF_DIAPAR := nDiaPar
							        	CNF->CNF_CONDPG := cCondPg
										CNF->(MsUnLock())
										
										// Atualizou cronograma financeiro aAux[2]
										aAux[2] := .T.
											
										// Alimenta o array dos titulos provisorios
										AADD(aTitulos, {StrZero(nParcel,3),;		//[1] Parcela
														dVencto,;					//[2] Vencimento
														nValParc})					//[3] Valor
									Next nJ
								EndIf
							
								nCont := 0
								
								If !lJob
									oProcess:IncRegua2("Atualizando cronograma fisico..")
								EndIf
							
								dbSelectArea("CNS")
								dbSetOrder(1)	// filial + contrato + revisao + cronograma + parcela + item
								If dbSeek(xFilial("CNS")+AvKey(cContrato,"CNS_CONTRA")+AvKey("","CNS_REVISA")+AvKey(CNA->CNA_CRONOG,"CNS_CRONOG")+AvKey("001","CNS_PARCEL")+AvKey(CNB->CNB_ITEM,"CNS_ITEM") )
									While CNS->CNS_FILIAL == xFilial("CNS") .And. CNS->CNS_CONTRA == cContrato .And. CNS->(!EOF())
										If CNS->CNS_PLANI == CNB->CNB_NUMERO
											nParcelCNS := VAL(CNS->CNS_PARCEL)
											nCont++
										EndIf
										CNS->(dbSkip())
									End
								         
									If nParcelCNS != 0
										If !lJob
											oProcess:SetRegua2(nCont)    
										EndIf
									
										For nJ := 1 To nVigencia
											nParcelCNS++
											
											If !lJob
												oProcess:IncRegua2("Parcela: "+StrZero(nParcelCNS,3))
											EndIf
											
											If lEnd
												DisarmTransaction()
												lCancelou := .T.		
												Exit		
											EndIf
												
											RecLock("CNS",.T.)
								        	CNS->CNS_FILIAL := xFilial("CNS")
									    	CNS->CNS_CONTRA := cContrato
									    	CNS->CNS_CRONOG := CNA->CNA_CRONOG
									    	CNS->CNS_PARCEL := StrZero(nParcelCNS,3)
									    	CNS->CNS_PLANI := CNB->CNB_NUMERO
									    	CNS->CNS_ITEM := CNB->CNB_ITEM
									    	CNS->CNS_PRVQTD := 1
									    	CNS->CNS_RLZQTD := 0
									    	CNS->CNS_SLDQTD := 1
									    	CNS->(MsUnLock())
								    		// Atualizou cronograma fisico aAux[3]
											aAux[3] := .T.
										Next nJ
									EndIf 
								EndIf
							
								
								// Cria titulos provisorios
								/*
								If !lJob
									oProcess:IncRegua2("Atualizando titulos provisorios..")
									oProcess:SetRegua2(Len(aTitulos))                          
								EndIf
								
								dbSelectArea("SE1")
								dbSetOrder(2) // filial + cliente + loja + prefixo + titulo + parcela + tipo
								If dbSeek(xFilial("SE1")+avKey(cpCliente, "E1_CLIENTE")+AvKey(cpLoja, "E1_LOJA")+AvKey("CTR","E1_PREFIXO"))
									While SE1->E1_FILIAL == xFilial("SE1") .And. AllTrim(SE1->E1_CLIENTE) == AllTrim(cpCliente) .And. AllTrim(SE1->E1_LOJA) == AllTrim(cpLoja)  .And. SE1->(!EOF())
										If SE1->E1_PREFIXO == "CTR" .And. AllTrim(SE1->E1_TIPO) == "PR" .And. AllTrim(SE1->E1_MDCONTR) == AllTrim(cContrato) .And. AllTrim(SE1->E1_MDPLANI) == AllTrim(CNA->CNA_NUMERO) .And. AllTrim(SE1->E1_MDCRON) == AllTrim(cCronog) .And. AllTrim(SE1->E1_ORIGEM) == "CNTA100"
											dDtEmissao := SE1->E1_EMISSAO
											Exit
										EndIf
										SE1->( dbSkip() )
									End
								EndIf
								
								If DtoC(dDtEmissao) == "  /  /    " 
									dDtEmissao := dDtIniPlan
								EndIf          
							
								For nJ := 1 To Len(aTitulos)
									If !lJob
										oProcess:IncRegua2("Parcela: "+aTitulos[nJ][1])
									EndIf
									
									If lEnd
										DisarmTransaction()
										lCancelou := .T.		
										Exit		
									EndIf
						
									cTitulo := GetSX8NUM("SE1","E1_NUM")
									cNaturez := GetAdvFVal("SA1","A1_NATUREZ",xFilial("SA1")+cpCliente+cpLoja,1)
									                          
									aAdd(aSE1,{"E1_FILIAL" 	,xFilial("SE1")					,Nil})	// Codigo da Filial
									aAdd(aSE1,{"E1_PREFIXO"	,"CTR"      					,Nil})	// Prefixo do Titulo
									aAdd(aSE1,{"E1_NUM"    	,cTitulo       					,Nil})	// Numero do Titulo
									aAdd(aSE1,{"E1_PARCELA"	,aTitulos[nJ][1]				,Nil})	// Parcela do pedido
									aAdd(aSE1,{"E1_TIPO"   	,"PR"	      					,Nil})	// Tipo do Titulo
									aAdd(aSE1,{"E1_CLIENTE"	,cpCliente						,Nil})	// Codigo do cliente
									aAdd(aSE1,{"E1_LOJA"	,cpLoja  						,Nil})	// Loja do cliente
									aAdd(aSE1,{"E1_EMISSAO"	,dDtEmissao  					,Nil})	// Data de emissao (retroativa)
									aAdd(aSE1,{"E1_VENCTO"	,aTitulos[nJ][2]  				,Nil})	// Data do vencimento
									aAdd(aSE1,{"E1_VENCREA"	,DataValida(aTitulos[nJ][2],.T.),Nil})	// Vencimento Real
									aAdd(aSE1,{"E1_VALOR"	,aTitulos[nJ][3]    			,Nil})	// Valor do titulo
									aAdd(aSE1,{"E1_SALDO"	,aTitulos[nJ][3]    			,Nil})	// Saldo do titulo	
									aAdd(aSE1,{"E1_NATUREZ"	,cNaturez      					,Nil})	// Natureza do Titulo
									aAdd(aSE1,{"E1_MSFIL"	,cFilAnt						,Nil})	// Filial de Origem
									aAdd(aSE1,{"E1_MDCONTR"	,cContrato						,Nil})	// contrato 
									aAdd(aSE1,{"E1_MDPLANI"	,CNB->CNB_NUMERO				,Nil})	// planilha
									aAdd(aSE1,{"E1_MDPARCE"	,aTitulos[nJ][1]				,Nil})	// parcela
									aAdd(aSE1,{"E1_MDCRON"	,CNA->CNA_CRONOG				,Nil})	// cronograma
									aAdd(aSE1,{"E1_ORIGEM"	,"CNTA100"						,Nil})	// Origem	
						
									MSExecAuto({|x,y,z| FINA040(x,y,z)},aSE1,3)
		 
									If lMsErroAuto
										RollBackSX8()
									    MostraErro()
									    lErroSE1 := .T.
									Else
							    		ConfirmSX8()
									Endif             
								
									lMsErroAuto := .F.
									aSE1 := {}
								Next nJ
								If !lErroSE1
									// Atualizou titulos aAux[4]
									aAux[4] := .T.
								EndIf
								*/
							EndIf	         
						EndIf
	    				CNB->( dbSkip() )
	    			End
	    		EndIf
			// Aumenta as parcelas da planilha e altera o saldo da planilha/contrato	
    		If lAltCNB
    			If RecLock("CNA",.F.) 
    				CNA->CNA_DTFIM := dDtFim + nDias
    				CNA->CNA_VLTOT := nTotCNB
   					CNA->CNA_VLCOMS := nTotCNB
   					CNA->CNA_SALDO := nTotMed
    				CNA->( MsUnLock() ) 
    			EndIf
    			
    			//Atualiza o saldo do contrato
				RetSldCont(cContrato,@nSaldoCont)
				If nSaldoCont <> 0
					If RecLock("CN9",.F.)   
						CN9->CN9_SALDO := nSaldoCont
						CN9->(MsUnLock())
					EndIF
				EndIf    		
    		EndIf
	    	CNA->( dbSkip() )
			End
	 	EndIf
		aContratos[nI][15] := "OK"	// contrato processado
		AADD(aContratos[nI], aAux )
	EndIf
Next nI	     

If !lCancelou
	EndTran()
	For nI := 1 To Len(aContratos)
		If FindFunction("U_TTGENC01")
			U_TTGENC01( xFilial("CN9"),"TTCNTA11","RENOVACAO DE CONTRATO","",,"",cUserName,dtos(date()),time(),,"CONTRATO " +aContratos[nI][1] +" RENOVADO",,,"CN9" )	
		EndIf
	Next nI
EndIf	

MsUNLockAll()
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetSldContบAutor  ณJackson E. de Deus  บ Data ณ  14/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o saldo do contrato                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetSldCont(cContrato, nSaldoCont)

Local cQuery := ""

cQuery += "SELECT SUM(CNA_VLTOT) - "
cQuery += 	"( "
cQuery += 		"SELECT SUM(CND_VLTOT) FROM " +RetSqlName("CND") "
cQuery += 			"WHERE CND_CLIENT = '"+cpCliente+"' "
cQuery += 			"AND CND_LOJACL = '"+cpLoja+"' "
cQuery += 			"AND CND_CONTRA = '"+cContrato+"') SALDO "

cQuery += "FROM " +RetSqlName("CNA") "
cQuery += "WHERE CNA_CLIENT = '"+cpCliente+"' "
cQuery += "AND CNA_LOJACL = '"+cpLoja+"' "
cQuery += "AND CNA_CONTRA = '"+cContrato+"' "

cQuery := ChangeQuery(cQuery)

If Select("TCN9") > 0
	TCN9->(dbCloseArea())
EndIf                    

TcQuery cQuery New Alias "TCN9"

dbSelectArea("TCN9")
dbGoTop()
While !EOF()
	nSaldoCont := TCN9->SALDO
	dbSkip()
End
dbCloseArea()


Return