#INCLUDE 'TOTVS.ch'
#INCLUDE 'TBICONN.ch'
#Include "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function xCNTA301()
	Local lRet 	 := .F.
	Local nRegs
	Local aPergs := {}
	Local cSetFilter := ""
	Local cCntrD := Space(TAMSX3("CN9_NUMERO")[1])
	Local cCntrA := Space(TAMSX3("CN9_NUMERO")[1])
	Local cRevD  := Space(TAMSX3("CN9_REVISA")[1])
	Local cRevA  := Space(TAMSX3("CN9_REVISA")[1])
	Local aCN9   := {}
	Local aCNA   := {}
	Local aCNB   := {}
	Local aCNC   := {}
	Local aCNN   := {}
	Local aCPD   := {}
	Local aRet	 := {}
	Local nCNA	 := 0
	Local aCNAPlan	:= {}
	Local aCNBItens := {}
	Local aCNNUsr := {}
	Local aCPDFil := {}
	Local lTemCrono := .F.
	Local aContratos:= {} 
	Local nCont := 0
	
	aAdd(aPergs,{1,"Contrato De? " ,cCntrD,"@!",'.T.',"CN9",'.T.',100,.F.})  
	aAdd(aPergs,{1,"Contrato Até? ",cCntrA,"@!",'.T.',"CN9",'.T.',100,.F.})   
	aAdd(aPergs,{1,"Revisão De? "  ,cRevD,"@!",'.T.',,'.T.',03,.F.})   
	aAdd(aPergs,{1,"Revisão Até? " ,cRevA,"@!",'.T.',,'.T.',03,.F.})

	If ParamBox(aPergs ,"Transf. de Contrato Vigente Emp 020101 P/ 010101 ",aRet)      
		lRet := .T.   
		
		cSetFilter	:= " CN9->CN9_SITUAC = '05' .AND. CN9->CN9_FILIAL ='020101' "	//Contrato Vigente
		If !Empty(aRet[1])
			cSetFilter	+= " .AND. CN9->CN9_NUMERO >= '"+aRet[1]+"' .AND. CN9->CN9_NUMERO <= '"+aRet[2]+"' "
		EndIf
		
		If !Empty(aRet[3])
			cSetFilter	+= "  .AND. CN9->CN9_REVISA >= '"+aRet[3]+"' .AND. CN9->CN9_REVISA <= '"+aRet[4]+"' "
		EndIf
		
		CN9->(dbSetFilter( {|| &cSetFilter }, cSetFilter ))
		CN9->(DbGoTop())

		DbSelectArea("CN9")
		Count To nRegs
		CN9->(DbSetOrder(1))
		CN9->(DbGoTop())
		//grava o recno dos contratos
		While !EOF()
			AADD(aContratos,CN9->(recno()))
			CN9->(DbSkip())
		Enddo

			For nCont := 1 to len(aContratos)
				CN9->(DBGoTo(aContratos[nCont]))
							
					LjMsgRun("Importando contrato:" + CN9->CN9_NUMERO)
					//Cabeçalho do Contrato
					aCN9 := {}
					aCNAPlan	:= {}
					aCNBItens := {}
					aCNNUsr := {}
					aCPDFil := {}

					AADD(aCN9,CN9->CN9_FILIAL) 
					AADD(aCN9,CN9->CN9_TPCTO )
					AADD(aCN9,CN9->CN9_DTINIC) 
					AADD(aCN9,CN9->CN9_NUMERO) 
					AADD(aCN9,CN9->CN9_NUMERO) 
					AADD(aCN9,CN9->CN9_DTASSI) 
					AADD(aCN9,CN9->CN9_UNVIGE) 
					AADD(aCN9,CN9->CN9_VIGE  )
					AADD(aCN9,CN9->CN9_DTFIM )
					AADD(aCN9,CN9->CN9_ASSINA) 
					AADD(aCN9,CN9->CN9_MOEDA )
					AADD(aCN9,CN9->CN9_CONDPG) 
					AADD(aCN9,CN9->CN9_VLINI )
					AADD(aCN9,CN9->CN9_VLATU )
					AADD(aCN9,CN9->CN9_FLGREJ) 
					AADD(aCN9,CN9->CN9_INDICE) 
					AADD(aCN9,CN9->CN9_REVISA) 
					AADD(aCN9,CN9->CN9_FLGCAU) 
					AADD(aCN9,CN9->CN9_TPCAUC) 
					AADD(aCN9,CN9->CN9_MINCAU) 
					AADD(aCN9,CN9->CN9_TIPREV) 
					AADD(aCN9,CN9->CN9_SALDO )
					AADD(aCN9,CN9->CN9_CODCLA) 
					AADD(aCN9,CN9->CN9_DTREV )
					AADD(aCN9,CN9->CN9_VLREAJ) 
					AADD(aCN9,CN9->CN9_DTULST) 
					AADD(aCN9,CN9->CN9_SITUAC) 
					AADD(aCN9,CN9->CN9_VLDCTR) 
					AADD(aCN9,"010101") 
					AADD(aCN9,CN9->CN9_ESPCTR) 
					AADD(aCN9,CN9->CN9_FILCTR) 
					AADD(aCN9,CN9->CN9_NATURE) 
					AADD(aCN9,CN9->CN9_PERI  )
					AADD(aCN9,CN9->CN9_UNPERI) 
					AADD(aCN9,CN9->CN9_MODORJ) 
					AADD(aCN9,CN9->CN9_PRORAT) 
					AADD(aCN9,CN9->CN9_PROXRJ)
					AADD(aCN9,CN9->CN9_XCODCL) 
					AADD(aCN9,CN9->CN9_XLOJCL) 
					AADD(aCN9,CN9->CN9_XNOMCL) 
					AADD(aCN9,CN9->CN9_XREDCL)
					//AADD(aCN9,aCN9)
					
					//Cliente/Fornecedor do Contrato
					aCNC := {}
					CNC->(dbSetOrder(1))
					If CNC->(dbSeek(CN9->CN9_FILIAL+CN9->CN9_NUMERO+CN9->CN9_REVISA))
						AADD(aCNC,CNC->CNC_FILIAL) 
						AADD(aCNC,CNC->CNC_NUMERO) 
						AADD(aCNC,CNC->CNC_REVISA) 
						AADD(aCNC,CNC->CNC_CLIENT) 
						AADD(aCNC,CNC->CNC_LOJACL) 				
					EndIf
					
					//Planilhas do Contrato
					aCNA := {}
					cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
					cQuery += " FROM " + RetSQLName("CNA") + " CNA "
					cQuery += " WHERE D_E_L_E_T_ = ''"
					cQuery += " AND CNA_FILIAL = '"+CN9->CN9_FILIAL+"'"
					cQuery += " AND CNA_CONTRA = '"+CN9->CN9_NUMERO+"'"
					cQuery += " AND CNA_REVISA = '"+CN9->CN9_REVISA+"'"
					cAliasCNA := MPSysOpenQuery(ChangeQuery(cQuery))
					If (cAliasCNA)->TOTREG > 0 
						While !(cAliasCNA)->(Eof())		
							AADD(aCNA,(cAliasCNA)->CNA_FILIAL) 
							AADD(aCNA,(cAliasCNA)->CNA_CONTRA) 
							AADD(aCNA,(cAliasCNA)->CNA_NUMERO) 
							AADD(aCNA,(cAliasCNA)->CNA_REVISA) 
							AADD(aCNA,(cAliasCNA)->CNA_CLIENT) 
							AADD(aCNA,(cAliasCNA)->CNA_LOJACL) 
							AADD(aCNA,StoD(Alltrim((cAliasCNA)->CNA_DTINI)))
							AADD(aCNA,(cAliasCNA)->CNA_VLTOT )
							AADD(aCNA,(cAliasCNA)->CNA_SALDO )
							AADD(aCNA,(cAliasCNA)->CNA_TIPPLA) 
							AADD(aCNA,StoD(Alltrim((cAliasCNA)->CNA_DTFIM)))
							AADD(aCNA,(cAliasCNA)->CNA_FLREAJ) 
							AADD(aCNA,(cAliasCNA)->CNA_INDICE) 
							AADD(aCNA,StoD(Alltrim((cAliasCNA)->CNA_PROXRJ))) 
							AADD(aCNA,(cAliasCNA)->CNA_DIASEM) 
							AADD(aCNA,(cAliasCNA)->CNA_UNPERI) 
							AADD(aCNA,(cAliasCNA)->CNA_PERI  )
							AADD(aCNA,(cAliasCNA)->CNA_PRORAT) 
							AADD(aCNA,StoD(Alltrim((cAliasCNA)->CNA_DTREAJ))) 
							AADD(aCNA,(cAliasCNA)->CNA_RPGANT)
							AADD(aCNA,(cAliasCNA)->CNA_CRONOG) 
							AADD(aCNAPlan,aCNA)
							aCNA := {}
							(cAliasCNA)->(DbSkip())
						EndDo
						(cAliasCNA)->(DBCloseArea())
					Endif
					
					//Itens da Planilha do Contrato
					aCNB := {}
					cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
					cQuery += " FROM " + RetSQLName("CNB") + " CNB "
					cQuery += " WHERE D_E_L_E_T_ = ''"
					cQuery += " AND CNB_FILIAL = '"+CN9->CN9_FILIAL+"'"
					cQuery += " AND CNB_CONTRA = '"+CN9->CN9_NUMERO+"'"
					cQuery += " AND CNB_REVISA = '"+CN9->CN9_REVISA+"'"
					cAliasCNB := MPSysOpenQuery(ChangeQuery(cQuery))
					//MsgAlert("Array (Itens) Planilha "+cValtoChar((cAliasCNB)->TOTREG))
					If (cAliasCNB)->TOTREG > 0 
						While !(cAliasCNB)->(Eof())		
							//MsgAlert("Array (Itens) Planilha Quant: "+cValtoChar((cAliasCNB)->CNB_QUANT)+" VLTOt"+cValtoChar((cAliasCNB)->CNB_VLTOT))
							AADD(aCNB,(cAliasCNB)->CNB_FILIAL) //1
							AADD(aCNB,(cAliasCNB)->CNB_NUMERO) //2
							AADD(aCNB,(cAliasCNB)->CNB_REVISA) //3
							AADD(aCNB,(cAliasCNB)->CNB_ITEM  ) //4
							AADD(aCNB,(cAliasCNB)->CNB_PRODUT) //5
							AADD(aCNB,(cAliasCNB)->CNB_DESCRI) //6
							AADD(aCNB,(cAliasCNB)->CNB_UM    ) //7
							AADD(aCNB,(cAliasCNB)->CNB_XQMIN ) //8
							AADD(aCNB,(cAliasCNB)->CNB_QUANT ) //9
							AADD(aCNB,(cAliasCNB)->CNB_VLUNIT) //10
							AADD(aCNB,(cAliasCNB)->CNB_VLTOT ) //11
							AADD(aCNB,(cAliasCNB)->CNB_DESC  ) //12
							AADD(aCNB,(cAliasCNB)->CNB_CONTRA) //13
							AADD(aCNB,StoD(Alltrim((cAliasCNB)->CNB_DTCAD))) //14
							AADD(aCNB,(cAliasCNB)->CNB_PRCORI) //15
							AADD(aCNB,(cAliasCNB)->CNB_QTDORI) //16
							AADD(aCNB,(cAliasCNB)->CNB_SLDMED) //17
							AADD(aCNB,(cAliasCNB)->CNB_SLDREC) //18
							AADD(aCNB,(cAliasCNB)->CNB_TS    ) //19
							AADD(aCNB,"010101") //20
							AADD(aCNB,StoD(Alltrim((cAliasCNB)->CNB_PROXRJ))) //21
							AADD(aCNB,StoD(Alltrim((cAliasCNB)->CNB_DTANIV))) //22
							AADD(aCNB,(cAliasCNB)->CNB_QTDMED) //23
							AADD(aCNB,(cAliasCNB)->CNB_CONTA ) //24
							AADD(aCNB,(cAliasCNB)->CNB_RATEIO) //25
							AADD(aCNB,(cAliasCNB)->CNB_PRCORI) //26
							AADD(aCNB,(cAliasCNB)->CNB_FLGCMS) //27
							//AADD(aCNB,(cAliasCNB)->CNB_RJRTO ) //28
							AADD(aCNB,(cAliasCNB)->CNB_FLGCMS ) //28
							AADD(aCNB,(cAliasCNB)->CNB_PEDTIT) //29
							AADD(aCNB,(cAliasCNB)->CNB_BASINS) //30
							AADD(aCNB,(cAliasCNB)->CNB_CC    ) //31
							AADD(aCNB,(cAliasCNB)->CNB_GERBIN) //32
							AADD(aCNB,(cAliasCNB)->CNB_ATIVO ) //33
							AADD(aCNB,StoD(Alltrim((cAliasCNB)->CNB_DTREAJ))) //34
							AADD(aCNB,(cAliasCNB)->CNB_FLREAJ) //35
							AADD(aCNB,(cAliasCNB)->CNB_ARREND) //36
							AADD(aCNBItens,aCNB)
							aCNB := {}
							(cAliasCNB)->(DbSkip())
						EndDo
						(cAliasCNB)->(DBCloseArea())
					Endif
					
					//Amarração Usuário x Contrato
					aCNN := {}
					cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
					cQuery += " FROM " + RetSQLName("CNN") + " CNN "
					cQuery += " WHERE D_E_L_E_T_ = ''"
					cQuery += " AND CNN_FILIAL = '"+CN9->CN9_FILIAL+"'"
					cQuery += " AND CNN_CONTRA = '"+CN9->CN9_NUMERO+"'"
					cAliasCNN := MPSysOpenQuery(ChangeQuery(cQuery))
					
					If (cAliasCNN)->TOTREG > 0 
						While !(cAliasCNN)->(Eof())
							aCNN := {}				
							AADD(aCNN,(cAliasCNN)->CNN_FILIAL)
							AADD(aCNN,(cAliasCNN)->CNN_CONTRA) 
							AADD(aCNN,(cAliasCNN)->CNN_USRCOD) 
							AADD(aCNN,(cAliasCNN)->CNN_TRACOD) 
							AADD(aCNNUsr,aCNN)
							(cAliasCNN)->(DbSkip())
						EndDo
						(cAliasCNN)->(DBCloseArea())
					Endif
					
					//Amarração Filial x Contrato
					aCPD := {}
					cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
					cQuery += " FROM " + RetSQLName("CPD") + " CPD "
					cQuery += " WHERE D_E_L_E_T_ = ''"
					cQuery += " AND CPD_FILIAL = '"+CN9->CN9_FILIAL+"'"
					cQuery += " AND CPD_CONTRA = '"+CN9->CN9_NUMERO+"'"
					cAliasCPD := MPSysOpenQuery(ChangeQuery(cQuery))
					
					If (cAliasCPD)->TOTREG > 0 
						While !(cAliasCPD)->(Eof())
							aCPD := {}				
							AADD(aCPD,(cAliasCPD)->CPD_FILIAL)
							AADD(aCPD,(cAliasCPD)->CPD_CONTRA) 
							AADD(aCPD,(cAliasCPD)->CPD_NUMPLA) 
							AADD(aCPD,(cAliasCPD)->CPD_FILAUT) 
							AADD(aCPDFil,aCPD)
							(cAliasCPD)->(DbSkip())
						EndDo
						(cAliasCPD)->(DBCloseArea())
					Endif
					
					If U_xCNTA300(aCN9,aCNC,aCNAPlan,aCNBItens,aCNNUsr,aCPDFil)
						nCNA := 0
						For nCNA := 1 to Len(aCNAPlan)
							//Planilhas do Contrato
							aCNA := {}
							cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
							cQuery += " FROM " + RetSQLName("CNA") + " CNA "
							cQuery += " WHERE D_E_L_E_T_ = ''"
							cQuery += " AND CNA_FILIAL = '010101'"
							cQuery += " AND CNA_CONTRA = '"+aCNAPlan[nCNA][2]+"'"
							cQuery += " AND CNA_REVISA = '"+aCNAPlan[nCNA][4]+"'"
							cQuery += " AND CNA_NUMERO = '"+aCNAPlan[nCNA][3]+"'"
							cAliasCNA := MPSysOpenQuery(ChangeQuery(cQuery))
							If (cAliasCNA)->TOTREG > 0 
								dbSelectArea("CNA")
								While !(cAliasCNA)->(Eof())		
									CNA->(DBGoTo((cAliasCNA)->RECNO))
										Reclock("CNA",.F.)
											CNA->CNA_VLTOT := aCNAPlan[nCNA][8]
											CNA->CNA_SALDO := aCNAPlan[nCNA][9]
											If !Empty(aCNAPlan[nCNA][21])
												lTemCrono := .T. 
											Endif 
										CNA->(MsUnLock())
									(cAliasCNA)->(DbSkip())
								EndDo
								(cAliasCNA)->(DBCloseArea())
							EndIF
						Next nCNA
						
						//atualiza CN9
						cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
						cQuery += " FROM " + RetSQLName("CN9") + " CN9 "
						cQuery += " WHERE D_E_L_E_T_ = ''"
						cQuery += " AND CN9_FILIAL = '010101'"
						cQuery += " AND CN9_NUMERO = '"+aCN9[5]+"'" 
						cQuery += " AND CN9_REVISA = '"+aCN9[17]+"'"
						cAliasCN9 := MPSysOpenQuery(ChangeQuery(cQuery))
						If (cAliasCN9)->TOTREG > 0 
							dbSelectArea("CN9")
							While !(cAliasCN9)->(Eof())		
								CN9->(DBGoTo((cAliasCN9)->RECNO))
									Reclock("CN9",.F.)
										//se não tem crongrama
										If !lTemCrono
											CN9->CN9_SITUAC := "05"
										Endif 	
									CN9->(MsUnLock())
								(cAliasCN9)->(DbSkip())
							EndDo
							(cAliasCN9)->(DBCloseArea())
						EndIF
					Else 
						MsgAlert("ERRO")
					EndIF
			Next nCont
			CN9->(DBClearFilter())
		Else      
			lRet := .F.   
		EndIf

	//Enddo 	
Return

User Function xCNTA300(aCN9,aCNC,aCNAPlan,aCNBItens,aCNNUsr,aCPDFil)
	Local aErro     := {}
    Local oModel    := Nil
	Local nCNB		:= 0
	Local nCNA		:= 0
	Local nCNN		:= 0
	Local nCPD		:= 0
	Local cFilBkp	:= ""
	Local lRet 		:= .T.
	Local lExisteCont := .F.
	
	cFilBkp := cFilAnt
	cFilAnt := "010101"

	//verificar se já existe contrato na filial 010101
	//atualiza CN9
	cQuery := " SELECT COUNT(*) OVER (PARTITION BY ' ') TOTREG,R_E_C_N_O_ RECNO,*"
	cQuery += " FROM " + RetSQLName("CN9") + " CN9 "
	cQuery += " WHERE D_E_L_E_T_ = ''"
	cQuery += " AND CN9_FILIAL = '010101'"
	cQuery += " AND CN9_NUMERO = '"+aCN9[5]+"'" 
	cQuery += " AND CN9_REVISA = '"+aCN9[17]+"'"
	cAliasCN9 := MPSysOpenQuery(ChangeQuery(cQuery))
	If (cAliasCN9)->TOTREG > 0 
		lExisteCont := .T.
	Else
		lExisteCont := .F.
	Endif 

	If !lExisteCont
    	oModel := FWLoadModel('CNTA301')
    	oModel:SetOperation(MODEL_OPERATION_INSERT)
    	oModel:Activate()
    
		//Cabeçalho do Contrato
		oModel:LoadValue('CN9MASTER','CN9_FILIAL',"010101") 
		oModel:LoadValue('CN9MASTER','CN9_TPCTO ',aCN9[2])
		oModel:LoadValue('CN9MASTER','CN9_DTINIC',aCN9[3]) 
		oModel:LoadValue('CN9MASTER','CN9_NUMERO',aCN9[5]) 
		oModel:LoadValue('CN9MASTER','CN9_DTASSI',aCN9[6]) 
		oModel:LoadValue('CN9MASTER','CN9_UNVIGE',aCN9[7]) 
		oModel:LoadValue('CN9MASTER','CN9_VIGE  ',aCN9[8])
		oModel:LoadValue('CN9MASTER','CN9_DTFIM ',aCN9[9])
		oModel:LoadValue('CN9MASTER','CN9_ASSINA',aCN9[10]) 
		oModel:LoadValue('CN9MASTER','CN9_MOEDA ',aCN9[11])
		oModel:LoadValue('CN9MASTER','CN9_CONDPG',aCN9[12]) 
		oModel:LoadValue('CN9MASTER','CN9_VLINI ',aCN9[13])
		oModel:LoadValue('CN9MASTER','CN9_VLATU ',aCN9[14])
		oModel:LoadValue('CN9MASTER','CN9_FLGREJ',aCN9[15]) 
		oModel:LoadValue('CN9MASTER','CN9_INDICE',aCN9[16]) 
		oModel:LoadValue('CN9MASTER','CN9_REVISA',aCN9[17]) 
		oModel:LoadValue('CN9MASTER','CN9_FLGCAU',aCN9[18]) 
		oModel:LoadValue('CN9MASTER','CN9_TPCAUC',aCN9[19]) 
		oModel:LoadValue('CN9MASTER','CN9_MINCAU',aCN9[20]) 
		oModel:LoadValue('CN9MASTER','CN9_TIPREV',aCN9[21]) 
		oModel:LoadValue('CN9MASTER','CN9_SALDO ',aCN9[22])
		oModel:LoadValue('CN9MASTER','CN9_CODCLA',aCN9[23]) 
		oModel:LoadValue('CN9MASTER','CN9_DTREV ',aCN9[24])
		oModel:LoadValue('CN9MASTER','CN9_VLREAJ',aCN9[25]) 
		oModel:LoadValue('CN9MASTER','CN9_DTULST',aCN9[26]) 
		oModel:LoadValue('CN9MASTER','CN9_SITUAC',aCN9[27]) 
		oModel:LoadValue('CN9MASTER','CN9_VLDCTR',aCN9[28]) 
		oModel:LoadValue('CN9MASTER','CN9_FILORI',aCN9[29]) 
		oModel:LoadValue('CN9MASTER','CN9_ESPCTR',aCN9[30]) 
		oModel:LoadValue('CN9MASTER','CN9_FILCTR',aCN9[31]) 
		oModel:LoadValue('CN9MASTER','CN9_NATURE',aCN9[32]) 
		oModel:LoadValue('CN9MASTER','CN9_PERI  ',aCN9[33])
		oModel:LoadValue('CN9MASTER','CN9_UNPERI',aCN9[34]) 
		oModel:LoadValue('CN9MASTER','CN9_MODORJ',aCN9[35]) 
		oModel:LoadValue('CN9MASTER','CN9_PRORAT',aCN9[36]) 
		oModel:LoadValue('CN9MASTER','CN9_PROXRJ',aCN9[37])
		oModel:LoadValue('CN9MASTER','CN9_XCODCL',aCN9[38]) 
		oModel:LoadValue('CN9MASTER','CN9_XLOJCL',aCN9[39]) 
		oModel:LoadValue('CN9MASTER','CN9_XNOMCL',aCN9[40]) 
		oModel:LoadValue('CN9MASTER','CN9_XREDCL',aCN9[41])
		oModel:LoadValue('CN9MASTER','CN9_AUTO',  '1') 
		
		//Cliente/Fornecedor do Contrato
		oModel:LoadValue('CNCDETAIL','CNC_CLIENT',aCNC[4]) 
		oModel:LoadValue('CNCDETAIL','CNC_LOJACL',aCNC[5]) 
		
		//Planilhas do Contrato
		nCNA := 0
		For nCNA := 1 to Len(aCNAPlan)
			If nCNA > 1 
				//Cliente/Fornecedor do Contrato
				oModel:LoadValue('CNCDETAIL','CNC_CLIENT',aCNC[4]) 
				oModel:LoadValue('CNCDETAIL','CNC_LOJACL',aCNC[5])
				oModel:GetModel('CNADETAIL'):AddLine()
			Endif
			
			oModel:LoadValue('CNADETAIL','CNA_FILIAL',"010101")
			oModel:LoadValue('CNADETAIL','CNA_CONTRA',aCNAPlan[nCNA][2])
			oModel:LoadValue('CNADETAIL','CNA_NUMERO',aCNAPlan[nCNA][3])
			oModel:LoadValue('CNADETAIL','CNA_REVISA',aCNAPlan[nCNA][4])
			oModel:LoadValue('CNADETAIL','CNA_CLIENT',aCNAPlan[nCNA][5])
			oModel:LoadValue('CNADETAIL','CNA_LOJACL',aCNAPlan[nCNA][6])
			oModel:LoadValue('CNADETAIL','CNA_DTINI ',aCNAPlan[nCNA][7])
			oModel:LoadValue('CNADETAIL','CNA_VLTOT ',aCNAPlan[nCNA][8])
			oModel:LoadValue('CNADETAIL','CNA_TIPPLA',aCNAPlan[nCNA][10])
			oModel:LoadValue('CNADETAIL','CNA_DTFIM ',aCNAPlan[nCNA][11])
			oModel:LoadValue('CNADETAIL','CNA_FLREAJ',aCNAPlan[nCNA][12])
			oModel:LoadValue('CNADETAIL','CNA_INDICE',aCNAPlan[nCNA][13])
			oModel:LoadValue('CNADETAIL','CNA_PROXRJ',aCNAPlan[nCNA][14])
			oModel:LoadValue('CNADETAIL','CNA_DIASEM',aCNAPlan[nCNA][15])
			oModel:LoadValue('CNADETAIL','CNA_UNPERI',aCNAPlan[nCNA][16])
			oModel:LoadValue('CNADETAIL','CNA_PERI  ',aCNAPlan[nCNA][17])
			oModel:LoadValue('CNADETAIL','CNA_PRORAT',aCNAPlan[nCNA][18])
			oModel:LoadValue('CNADETAIL','CNA_DTREAJ',aCNAPlan[nCNA][19])
			oModel:LoadValue('CNADETAIL','CNA_RPGANT',aCNAPlan[nCNA][20])
			//oModel:LoadValue('CNADETAIL','CNA_CRONOG',aCNAPlan[nCNA][21])
					
			//Itens da Planilha do Contrato
			nCNB := 0
			For nCNB := 1 to Len(aCNBItens) 
				If Alltrim(aCNBItens[nCNB,2]) == Alltrim(aCNAPlan[nCNA,3]) 
					If Val(Alltrim(aCNBItens[nCNB,4])) > 1  
						oModel:GetModel('CNBDETAIL'):AddLine()
					Endif
					
					oModel:LoadValue('CNBDETAIL','CNB_FILIAL',"010101")
					oModel:LoadValue('CNBDETAIL','CNB_NUMERO',aCNBItens[nCNB][2])
					oModel:LoadValue('CNBDETAIL','CNB_REVISA',aCNBItens[nCNB][3])
					oModel:LoadValue('CNBDETAIL','CNB_ITEM  ',aCNBItens[nCNB][4])  //SUGESTÃO RONI SILVA STRZERO(CNUM,3)
					oModel:LoadValue('CNBDETAIL','CNB_PRODUT',aCNBItens[nCNB][5]) 
					oModel:LoadValue('CNBDETAIL','CNB_DESCRI',aCNBItens[nCNB][6]) 
					oModel:LoadValue('CNBDETAIL','CNB_UM    ',aCNBItens[nCNB][7]) 
					oModel:LoadValue('CNBDETAIL','CNB_XQMIN ',aCNBItens[nCNB][8])
					oModel:LoadValue('CNBDETAIL','CNB_QUANT ',IIF(aCNBItens[nCNB][9]=0,1,aCNBItens[nCNB][9]))
					oModel:LoadValue('CNBDETAIL','CNB_VLUNIT',aCNBItens[nCNB][10])
					oModel:LoadValue('CNBDETAIL','CNB_VLTOT ',aCNBItens[nCNB][11])
					oModel:LoadValue('CNBDETAIL','CNB_DESC  ',aCNBItens[nCNB][12])
					oModel:LoadValue('CNBDETAIL','CNB_CONTRA',aCNBItens[nCNB][13])
					oModel:LoadValue('CNBDETAIL','CNB_DTCAD ',aCNBItens[nCNB][14]) 
					oModel:LoadValue('CNBDETAIL','CNB_PRCORI',aCNBItens[nCNB][15])
					oModel:LoadValue('CNBDETAIL','CNB_QTDORI',aCNBItens[nCNB][16])
					oModel:LoadValue('CNBDETAIL','CNB_SLDMED',aCNBItens[nCNB][17])
					oModel:LoadValue('CNBDETAIL','CNB_SLDREC',aCNBItens[nCNB][18])
					oModel:LoadValue('CNBDETAIL','CNB_TS    ',aCNBItens[nCNB][19])
					oModel:LoadValue('CNBDETAIL','CNB_FILORI',aCNBItens[nCNB][20])
					oModel:LoadValue('CNBDETAIL','CNB_PROXRJ',aCNBItens[nCNB][21])
					oModel:LoadValue('CNBDETAIL','CNB_DTANIV',aCNBItens[nCNB][22])
					oModel:LoadValue('CNBDETAIL','CNB_QTDMED',aCNBItens[nCNB][23])
					oModel:LoadValue('CNBDETAIL','CNB_CONTA ',aCNBItens[nCNB][24])
					oModel:LoadValue('CNBDETAIL','CNB_RATEIO',aCNBItens[nCNB][25])
					oModel:LoadValue('CNBDETAIL','CNB_PRCORI',aCNBItens[nCNB][26])
					oModel:LoadValue('CNBDETAIL','CNB_FLGCMS',aCNBItens[nCNB][27])
					oModel:LoadValue('CNBDETAIL','CNB_PEDTIT',aCNBItens[nCNB][29])
					oModel:LoadValue('CNBDETAIL','CNB_BASINS',aCNBItens[nCNB][30])
					oModel:LoadValue('CNBDETAIL','CNB_CC    ',aCNBItens[nCNB][31])
					oModel:LoadValue('CNBDETAIL','CNB_GERBIN',aCNBItens[nCNB][32])
					oModel:LoadValue('CNBDETAIL','CNB_ATIVO ',aCNBItens[nCNB][33])
					oModel:LoadValue('CNBDETAIL','CNB_DTREAJ',CtoD(Alltrim(aCNBItens[nCNB][34])))
					oModel:LoadValue('CNBDETAIL','CNB_FLREAJ',aCNBItens[nCNB][35])
					oModel:LoadValue('CNBDETAIL','CNB_ARREND',aCNBItens[nCNB][36])
				Endif
			Next nCNB
		Next nCNA
		
		//Validação e Gravação do Modelo
		If oModel:VldData()
			oModel:CommitData()
			lRet := .T.
			//grava numa planilha em excel 
			//MsgInfo("Contrato atualizado com sucesso","INFO")
						
			/*
			For nCNN := 1 to Len(aCNNUsr)
				CNN->( dbSetOrder( 1 ) )
				If !(CNN->(dbSeek("010101" + aCNNUsr[nCNN][3] + CN9->CN9_NUMERO)))
					CNN->(RecLock('CNN',.T.))
					CNN->CNN_FILIAL := "010101"
					CNN->CNN_CONTRA := aCNNUsr[nCNN][2]
					CNN->CNN_USRCOD := aCNNUsr[nCNN][3]
					CNN->CNN_TRACOD := aCNNUsr[nCNN][4]
					CNN->( MsUnLock() )
				Endif
			Next 
			
			For nCPD := 1 to Len(aCPDFil)
				CPD->( dbSetOrder( 1 ) )
				If !CPD->(MsSeek("010101" + CN9->CN9_NUMERO + aCPDFil[nCPD][3]))
					CPD->(RecLock('CNN',.T.))
					CPD->CPD_FILIAL := "010101"
					CPD->CPD_CONTRA := aCPDFil[nCPD][2]
					CPD->CPD_NUMPLA := aCPDFil[nCPD][3]
					CPD->CPD_FILAUT := aCPDFil[nCPD][4]
					CPD->( MsUnLock() )
				Endif
			Next
			*/ 
		Else
			lRet := .F.
			aErro := oModel:GetErrorMessage()
			MsgAlert('Erro: Contrato: '+ AllToChar( aErro[6] + ' '+ AllToChar( aErro[4] + Dtoc(DATE())+' - '+Time())))
		Endif
	Else 
		MsgAlert("Contrato "+aCN9[5]+" já importado","Importa Contrato")
	EndIf
	cFilAnt := cFilBkp 
Return lRet
