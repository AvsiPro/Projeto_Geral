#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA15  ºAutor  ³Jackson E. de Deus  º Data ³  03/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a inclusao/remocao de patrimonios na planilha do clienteº±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³03/02/13³01.00 |Criacao                                 ³±±
±±³Jackson       ³10/09/14³01.01 |Ajuste feito no tratamento inicial do   ³±±
±±³								  tipo de contrato						  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTCNTA15(cNumTmk,nTipo,cContrato,cPlanilha,cpCliente,cpLoja,cPatrimo,nVlAlug,dData,lProRata)

Local lRet		:= .F.
Local cBody		:= ""
Local cRemete	:= SuperGetMV("MV_RELACNT",.T.,"microsiga",)
Local cTarget	:= AllTrim(UsrRetMail(__cUserID))
Local cSubject	:= "Ordem de Movimentação de Maquina - Nº "+cNumTmk
Local aAttach	:= {}
Local cTpLocac	:= SuperGetMV("MV_XTMK020",.T.,"")		// Tipo de contrato de locacao
Local aAuxPlan	:= {}
Local lSalvou	:= .F.
Local nRecPlan	:= 0
Local cTpContr
Local cContrCli
Local cContrLj
Local nPatVal                                        
Local cVarAux	:= ""
Local nSaldoCont := 0
Local oDlgValor
Local oSay
Local oSay1
Local oGrp1
Local oSBtn1
Local aPlan		:= {}
Local aPatrim	:= {}
Local cTpMovi	:= "OMM - ATUALIZACAO"
	
Default cNumTmk		:= ""
Default nTipo		:= 0
Default cContrato	:= ""
Default cPlanilha	:= ""
Default cpCliente	:= ""
Default cpLoja		:= ""
Default cPatrimo	:= ""
Default nvlAlug		:= 0
Default dData		:= ctod("")
   
If cEmpAnt == "01"
	   
	If nTipo == 1
		If AllTrim(cContrato) == "" .Or. AllTrim(cPatrimo) == "" .Or. dtoc(dData) == ""
			Return lRet                                                                      
		EndIf
	EndIf
	               
	If nTipo == 2
		If AllTrim(cPatrimo) == "" .Or. dtoS(dData) == ""
			Return lRet                                       
		EndIf
	EndIf
	
	If !FwIsInCallStack("U_TTTMKA04#U_TTPROC26#U_TTPROC41")
		cTpMovi := "AJUSTE PLANILHA"
	EndIf
	
	If !FindFunction("U_TTCNTA09")
		Aviso("TTCNTA15","Função U_TTCNTA09 não compilada no repositório.", {"Ok"})	
		Return lRet
	EndIf
			
	If !FindFunction("U_TTCNTA14")
		Aviso("TTCNTA15","Função U_TTCNTA14 não compilada no repositório.", {"Ok"})	
		Return lRet
	EndIf
												
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄ¿
	//³INSTALACAO³
	//ÀÄÄÄÄÄÄÄÄÄÄÙ
	*/
	If nTipo == 1
		dbSelectArea("CN9")
		dbSetOrder(1) //FILIAL+CONTRATO+REVISAO [CN9_FILIAL+CN9_NUMERO+CN9_REVISA]
		If !dbSeek(xFilial("CN9")+AvKey(cContrato,"CN9_NUMERO"))
			If FindFunction("U_TTMAILN")
				cBody := "Contrato informado na OMM não encontrado." +CRLF +"Não será possível incluir o patrimônio na planilha."
				cRemete += ";jdeus@toktake.com.br"
				U_TTMailN(cRemete,cTarget,cSubject,cBody,aAttach,.F.)
	  		EndIf
	   							
			U_TTGENC01(xFilial(),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"CONTRATO NAO ENCONTRADO: "+cContrato,cpCliente,cpLoja,"SUD")	
			Return lRet
		EndIf
		 
		If !FindFunction("U_TTCNTA01")
	 		Aviso("TTCNTA15","Função U_TTCNTA01 não compilada no repositório.",{"Ok"})	
			Return lRet
		EndIf
			
		If !FindFunction("U_TTCNTA17")
			Aviso("TTCNTA15","Função U_TTCNTA17 não compilada no repositório.", {"Ok"})	
			Return lRet
		EndIf
		
		cTpContr := CN9->CN9_XTPCNT
		
		If Empty(cTpContr) // nao continuar
			MsgAlert("O contrato do cliente não está configurado corretamente." +CRLF +"Informar a forma de fatura do contrato.", "TTCNTA15")	
			Return lRet
		EndIf	
		
		cContrCli := CN9->CN9_CLIENT
		cContrLj := CN9->CN9_LOJACL
	 	nPatVal := nVlAlug
	  		                      
	  	// Valida se contrato de locacao
	  	If AllTrim(CN9->CN9_TPCTO) <> AllTrim(cTpLocac)
	  		lRet := .T.
	  		Return lRet
	  	EndIf
				  		
	  	// Tratamento para nao deixar o valor zerado - solicitado em 17/10/2013
	  	If nVlAlug == 0
	  		If !FwIsInCallStack("U_TTPROC26")
			  	Aviso("TTCNTA15","Os patrimônios devem possuir um valor da locação." +CRLF +"Insira o valor da locação na próxima tela.",{"Ok"})
		  		While nVlAlug == 0
					oDlgValor := MSDialog():New( 230,300,425,640,"Valor de locação",,,.F.,,,,,,.T.,,,.T. )
						oSay  := TSay():New( 005,005,{|| "Patrimônio: " +cPatrimo +" - " +GetAdvFVal("SN1","N1_DESCRIC",xFilial("SN1")+cPatrimo,2) },oDlgValor,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
						oSay1 := TSay():New( 015,005,{|| "Digite o valor da locação + valor do moedeiro:"},oDlgValor,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
					
						oGrp1 := TGroup():New( 027,002,080,170,"",oDlgValor,CLR_BLACK,CLR_WHITE,.T.,.F. )
						@ 035,030 Say "Valor" 
						@ 045,030 MSGET nVlAlug	PICTURE pesqpict("SUD","UD_XVLALUG")		OF oDlgValor SIZE 050,008 PIXEL HASBUTTON							
						oSBtn1	:= SButton():New( 080,076,1,{|| oDlgValor:End() },oDlgValor,.T.,"", )
					oDlgValor:Activate(,,,.T.)
					If nVlAlug == 0
						If MsgYesNo("Deseja continuar sem digitar o valor de locação?")
							U_TTGENC01(xFilial("SUD"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO " +cPatrimo +" - INSTALADO SEM VALOR DE LOCACAO - CONFORME ACEITE DO USUARIO",cpCliente,cpLoja,"SUD")	
							Exit
						EndIf
					EndIf
		  		End  
	  		Else
	  			U_TTGENC01(xFilial("SUD"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO " +cPatrimo +" - INSTALADO SEM VALOR DE LOCACAO - VIA OS MOBILE",cpCliente,cpLoja,"SUD")	
	  		EndIf
	  	EndIf 
								
		// Busca a planilha do contrato
		If AllTrim(cTpContr) == "1"
			dbSelectArea("SZQ")
			dbSetOrder(1) //filial+contrato+planilha+patrimonio //CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM 
			If dbSeek(xFilial("SZQ")+cContrato)
				While SZQ->ZQ_FILIAL == SUD->UD_FILIAL .AND. SZQ->ZQ_CONTRA == CN9->CN9_NUMERO .AND. SZQ->( !EOF() )
					If AllTrim(SZQ->ZQ_PATRIM) == AllTrim(cPatrimo)
						AADD(aPlan,SZQ->ZQ_PLAN)
					EndIf       
					SZQ->( dbSkip() )
				End
			EndIf	
			
			// Encontrou o patrimonio em alguma planilha
			If Len(aPlan) > 0
				Aviso("TTCNTA15","Já existe planilha com o patrimônio informado.",{"Ok"})
				lRet := .T.
				Return lRet
			EndIf
			
			Aadd(aAuxPlan,{.F.,;
							cPatrimo,;
							"",;	//cProduto ??
							"",;
							"",;
							CN9->CN9_DTINIC,;
							dData,;
							CN9->CN9_VIGE,;
							CN9->CN9_UNVIGE,;
							nVlAlug,;
							0})
						
			//cria a planilha					
			U_TTCNTA01(cContrato,space(TamSx3("CNA_REVISA")[1]),aAuxPlan) 
			cPlanilha := ChkPlan(cContrato)                         
			If cPlanilha == ""
				Aviso("TTCNTA15","Erro ao salvar a planilha."+CRLF +"Tente novamente.",{"Ok"})
				Return lRet
			EndIf
			
			//AADD( aPatrim, { cContrato, cPlanilha, cPatrimo, nVlAlug, dData } )	
			lSalvou := U_TTCNTA14(nTipo, cContrato, cPlanilha, cPatrimo, nVlAlug, dData, cpCliente, cpLoja )
			If ValType(lSalvou) == "L"
				If !lSalvou
					Aviso("TTCNTA15","Erro ao salvar patrimônio na planilha." +CRLF +"Tente novamente.",{"Ok"})
					Return lRet
				EndIf
			EndIf      
			lRet := .T.
			Return lRet	
							                                               
		// Se for agrupado - adicionar na planilha existente
	 	ElseIf cTpContr == "2"
			DbSelectArea("CNB")
			DbSetOrder(1)	//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM 
			If !dbSeek( xFilial("CNB")+AvKey(cContrato,"CN9_NUMERO")+AvKey("","CNA_REVISA") )
				Aadd(aAuxPlan,{.F.,;
							cPatrimo,;
							"",;
							"",;
							"",;
							CN9->CN9_DTINIC,;
							dData,;
							CN9->CN9_VIGE,;
							CN9->CN9_UNVIGE,;
							nVlAlug,;
							0})
				//cria a planilha					
				U_TTCNTA01(cContrato,space(TamSx3("CNA_REVISA")[1]),aAuxPlan)
				DbSelectArea("CNB")
				DbSetOrder(1)	//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM 
				If !dbSeek( xFilial("CNB")+AvKey(cContrato,"CN9_NUMERO")+AvKey("","CNA_REVISA") )
					Aviso("TTCNTA15","Houve erro ao criar a planilha para o contrato." +CRLF +"Tente novamente.",{"Ok"})
					Return lRet
				EndIf 		
			EndIf
			cPlanilha := CNB->CNB_NUMERO
			
		// Se for selecionado - adicionar na planilha existente
		ElseIf cTpContr == "3"
			dbSelectArea("CNB")
			dbSetOrder(1)	//CNB_FILIAL+CNB_CONTRA+CNB_REVISA+CNB_NUMERO+CNB_ITEM  
	  		If !dbSeek( xFilial("CNB")+AvKey(cContrato,"CN9_NUMERO")+AvKey("","CNA_REVISA")+AvKey(cPlanilha,"CNB_NUMERO") )
				Aviso("TTCNTA15","Não foi encontrada planilha para o patrimônio/planilha informados na OMM.",{"Ok"})
				If FindFunction("U_TTMAILN")
					cBody := "Foi adicionado um patrimônio em um contrato do tipo selecionado." +"<br>" 
					If AllTrim(cPlanilha) == ""
						cBody += "Não foi informado o número da planilha do contrato." +"<br>"
					EndIf															
					cBody += "Patrimônio: " +AllTrim(cPatrimo) +"<br>"
					cBody += "Valor aluguel: " +CVALTOCHAR(nVlAlug)
					U_TTMailN(cRemete,cTarget,cSubject,cBody,aAttach,.F.)
	   			EndIf
	   			
	   			U_TTGENC01(xFilial("SUD"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PLANILHA NAO ENCONTRADA: "+cPLanilha,cpCliente,cpLoja,"CNB")	
	  			Return lRet
		   	EndIf
		EndIf    
		
	 	nPatVal := nVlAlug
		nPatQtd := CNB->CNB_SLDMED									
			
		// Prepara conteudo do campo ProRata
		cVarAux := AllTrim(CNB->CNB_XPRORA)  
		If AllTrim(cVarAux) <> "" .And. SubStr(cVarAux,Len(cVarAux),1) <> "|"
			cVarAux += "|"
		EndIf 
		cPatProRa := cVarAux +"I" +"," +Alltrim(cPatrimo) +"," +CValToChar(nVlAlug) +"," +DtoC(dData)	                                            
	/*
	//ÚÄÄÄÄÄÄÄ¿
	//³REMOCAO³
	//ÀÄÄÄÄÄÄÄÙ
	*/
	ElseIf nTipo == 2	
		//busca o recno do registro na SZQ
		RetPlan(cPatrimo,cpCliente,cpLoja,@nRecPlan,@cContrato,@cPlanilha) 
		If nRecPlan == 0
			U_TTGENC01(xFilial("SUD"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO NAO ENCONTRADO EM PLANILHA: "+cPatrimo,cpCliente,cpLoja,"SZQ") 
			lRet := .T.
			Return lRet
		EndIf                              
	                                                                        					
		dbSelectArea("CN9")
		dbSetOrder(1) //FILIAL+CONTRATO+REVISAO [CN9_FILIAL+CN9_NUMERO+CN9_REVISA]
		If dbSeek(xFilial("CN9")+AvKey(cContrato,"CN9_NUMERO"))
			cTpContr := CN9->CN9_XTPCNT
			cContrCli := CN9->CN9_CLIENT
			cContrLj := CN9_LOJACL
		EndIf
		
		// Valida se contrato de locacao
	  	If AllTrim(CN9->CN9_TPCTO) <> AllTrim(cTpLocac)
	  		lRet := .T.
	  		Return lRet
	  	EndIf
		
		dbSelectArea("SZQ")
		dbGoTo(nRecPlan)
		nPatVal := SZQ->ZQ_VALOR
		nVlAlug := nPatVal
	    
	    dbSelectArea("CNB")
	    dbSetOrder(1)
	    If !dbSeek( xFilial("CNB")+AvKey(cContrato,"CN9_NUMERO")+AvKey("","CNA_REVISA") +Avkey(cPlanilha,"CNB_NUMERO"))                       					
	    	//lRet := .T.
			Return lRet
		EndIf
		
		nPatQtd := CNB->CNB_SLDMED
	                                           			
		// Prepara conteudo do campo ProRata
		cVarAux := AllTrim(CNB->CNB_XPRORA)  
		If AllTrim(cVarAux) <> "" .And. SubStr(cVarAux,Len(cVarAux),1) <> "|"
			cVarAux += "|"
		EndIf 
		cPatProRa := cVarAux +"R" +"," +AllTrim(cPatrimo) +"," +cValtoChar(nPatVal) +"," +DtoC(dData)				// String a ser gravada no campo ProRata											   
	EndIf
	
	// GRAVA
	// inclusao
	If nTipo == 1
		If cTpContr $ "2|3"
			lSalvou := U_TTCNTA14(nTipo, cContrato, cPlanilha, cPatrimo, nVlAlug, dData, cpCliente, cpLoja )
			If ValType(lSalvou) == "L"
				If !lSalvou
					Aviso("TTCNTA15","Erro ao salvar patrimônio na planilha." +CRLF +"Tente novamente.", {"Ok"})	
					Return lRet	
				EndIf
			EndIf
			U_TTGENC01(xFilial("SZQ"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO INCLUIDO: "+cPatrimo,cpCliente,cpLoja,"SZQ") 
			
			nPatVlUnit := U_TTCNTA17(cContrato, cPlanilha)
			nPatVlTot := nPatVlUnit * nPatQtd	
									            	
			If RecLock("CNB",.F.)
				CNB->CNB_VLUNIT := nPatVlUnit
				CNB->CNB_VLTOT := nPatVlTot
				
				If lProRata
					CNB->CNB_XPRORA := cPatProRa
				EndIf
				
				CNB->(MSUnlock())
			EndIf
		
			//Atualiza CNA
			dbSelectArea("CNA")
			dbSetOrder(1) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO (filial+contrato+revisao+planilha)
			If dbSeek(xFilial("CNA")+CNB->CNB_CONTRA+AvKey("","CNA_REVISA")+cPlanilha)
				If RecLock("CNA",.F.)
					CNA->CNA_VLTOT := nPatVlTot
					CNA->(MsUnLock())
				EndIf   
			EndIf
		                  
		 	//Atualiza o saldo do contrato
			RetSldCont(cContrato,cContrCli,cContrLj,@nSaldoCont)
			If nSaldoCont <> 0
				If RecLock("CN9",.F.)   
					CN9->CN9_SALDO := nSaldoCont
					CN9->(MsUnLock())
				EndIf
			EndIf
				
			// Atualiza titulos a receber e cronograma financeiro          
			U_TTCNTA09(cpCliente, cpLoja, cContrato, cPLanilha, nPatVlUnit, CNA->CNA_CRONOG, DATE() )																
			
			U_TTGENC01(xFilial("SUD"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PLANILHA ALTERADA: "+cPlanilha,cpCliente,cpLoja,"CNB")	      
		
			lRet := .T.
	    EndIf
	// remocao    
	ElseIf nTipo == 2
		lSalvou := U_TTCNTA14(nTipo, cContrato, cPlanilha, cPatrimo, nVlAlug, dData, cpCliente, cpLoja )	
		If ValType(lSalvou) == "L"
			If !lSalvou
				Aviso("TTCNTA15","Erro ao salvar patrimônio na planilha." +CRLF +"Tente novamente.", {"Ok"})	
				Return lRet	
			EndIf
		EndIf
		U_TTGENC01(xFilial("SZQ"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO REMOVIDO: "+cPatrimo,cpCliente,cpLoja,"SZQ") 
		
		nPatVlUnit := U_TTCNTA17(cContrato, cPlanilha)
		nPatVlTot := nPatVlUnit * nPatQtd
						            	
		If RecLock("CNB",.F.)
			CNB->CNB_VLUNIT := nPatVlUnit
			CNB->CNB_VLTOT := nPatVlTot
			
			If lProRata
				CNB->CNB_XPRORA := cPatProRa
			EndIf
			
			CNB->(MSUnlock())
		EndIf
		
		//Atualiza CNA
		dbSelectArea("CNA")
		dbSetOrder(1) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO (filial+contrato+revisao+planilha)
		If dbSeek(xFilial("CNA")+CNB->CNB_CONTRA+AvKey("","CNA_REVISA")+cPlanilha)
			If RecLock("CNA",.F.)
				CNA->CNA_VLTOT := nPatVlTot
				CNA->(MsUnLock())
			EndIf   
		EndIf
		                  
	 	//Atualiza o saldo do contrato
		RetSldCont(cContrato,cContrCli,cContrLj,@nSaldoCont)
		If nSaldoCont <> 0
		 	dbSelectArea("CN9")
			If RecLock("CN9",.F.)   
				CN9->CN9_SALDO := nSaldoCont
				CN9->(MsUnLock())
			EndIf
		EndIf                              
				
		// Atualiza titulos a receber e cronograma financeiro          
		U_TTCNTA09(cpCliente, cpLoja, cContrato, cPLanilha, nPatVlUnit, CNA->CNA_CRONOG, Date() )																
		
		U_TTGENC01(xFilial("SUD"),"TTCNTA15",cTpMovi,"",cNumTMK,"",cusername,dtos(date()),time(),,"PLANILHA ALTERADA: "+cPlanilha,cpCliente,cpLoja,"CNB")	      
	
		lRet := .T.
	EndIf	
EndIF
		
Return lRet



//Valor total das planilhas - valor total ja medido   
Static Function RetSldCont(cContrato,cContrCli,cContrLj)

Local cQuery := ""
Local nSaldoCont := 0

cQuery += "SELECT SUM(CNA_VLTOT) - "
cQuery += "( "
cQuery += "SELECT SUM(CND_VLTOT) FROM " +RetSqlName("CND") "
cQuery += " WHERE CND_CLIENT = '"+cContrCli+"' "
cQuery += "AND CND_LOJACL = '"+cContrLj+"' "
cQuery += "AND CND_CONTRA = '"+cContrato+"') SALDO "

cQuery += "FROM " +RetSqlName("CNA") "
cQuery += " WHERE CNA_CLIENT = '"+cContrCli+"' "
cQuery += "AND CNA_LOJACL = '"+cContrLj+"' "
cQuery += "AND CNA_CONTRA = '"+cContrato+"' "

//cQuery := ChangeQuery(cQuery)
If Select("TCN9") > 0
	TCN9->(dbCloseArea())
EndIf                    

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TCN9",.F.,.T.)
//TcQuery cQuery New Alias "TCN9"

dbSelectArea("TCN9")
dbGoTop()
While !EOF()
	nSaldoCont := TCN9->SALDO
	dbSkip()
End
dbCloseArea()

Return nSaldoCont


// Verifica a ultima planilha do contrato
Static Function ChkPlan(cContrato)

Local cPlanilha := ""
Local cQuery := ""

cQuery := "SELECT CNA_NUMERO FROM " +RetSqlName("CNA") + " WHERE CNA_CONTRA = '"+cContrato+"' AND D_E_L_E_T_ = '' ORDER BY R_E_C_N_O_ DESC "             

If Select("TRBQ") > 0
	TRBQ->( dbCloseArea() )
EndIf
                           
TcQuery cQuery New Alias "TRBQ"

dbSelectArea("TRBQ")
cPlanilha := TRBQ->CNA_NUMERO                               

Return cPlanilha


/*
Retorna o Recno da planilha que contem o patrimonio informado
*/
Static Function RetPlan(cNumChapa,cpCliente,cpLoja,nRecPlan,cContrato,cPlanilha)

Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ ZQREC, ZQ_CONTRA CONTRATO, ZQ_PLAN PLANILHA FROM " +RetSqlName("SZQ") + " SZQ "
cQuery += "WHERE " 

cQuery += "ZQ_CONTRA IN "
cQuery += 			"( "
cQuery += 			"SELECT CN9_NUMERO FROM " +RetSqlName("CN9") + " CN9 "
cQuery += 			"WHERE "
cQuery += 			"CN9_CLIENT = '"+cpCliente+"' " 
cQuery += 			"AND CN9_TPCTO = '002' "
cQuery += 			"AND D_E_L_E_T_ = '' "
cQuery += 			") "

cQuery += " AND SZQ.D_E_L_E_T_='' "
cQuery += "AND ZQ_PATRIM = '"+cNumChapa+"' AND ZQ_DATAREM = '' "	//ZQ_CLIENTE = '"+cpCliente+"' AND ZQ_LOJA = '"+cpLoja+"' 

                                                              
If Select("TCNB") > 0
	TCNB->(dbCloseArea())
EndIf                    

TcQuery cQuery New Alias "TCNB"

dbSelectArea("TCNB")

nRecPlan := TCNB->ZQREC
cContrato := TCNB->CONTRATO

If Empty(cPlanilha)
	cPlanilha := TCNB->PLANILHA	
EndIf

dbCloseArea()

Return	