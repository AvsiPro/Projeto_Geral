#Include "Protheus.ch"

/*/{Protheus.doc} RFatA002
Job para inclusao de pedido de venda e titulos a receber
@author Totvs
@since Out/22
@version 1
@type function
/*/

User Function RFatA002(aParam)

Local cCodEmp   := "01"
Local cCodFil   := "01"
Local cQ    	:= ""
Local cTab      := ""
Local lContinua := .T.
Local aParcelas := {}
Local cDias     := ""
Local dVencto   := Date()
Local aCab      := {}
Local aItem     := {}
Local aItens    := {}
Local cItem     := ""
Local aLog      := {}
Local cErro     := ""
Local cMsgErro  := ""
Local cCodigo := ""
Local cOper := ""
Local lErro := .F.
Local lOperadora := .F.
Local nValAdt := 0
//Local cTipPagCartao := ""
//Local cTipPagDinheiro := ""
//Local cTipPagFinanc := ""
Local lCriaTit := .T.
Local aTit := {}
Local cSeq := "000"
Local cAliasTrb := ""
Local cTipoPag := ""
Local cNat := ""
Local nRegs := 0
Local lAdt := .T.
Local dVencAdt := cTod("")
Local cCliOpera := ""
Local cLojaOpera := ""
Local lIncTit := .T.
Local lAchouPV := .F.
Local lPVAberto := .T.
Local cPVAlt := ""
//Local cBco := ""
//Local cAge := ""
//Local cConta := ""
Local cBcoDH := ""
Local cAgeDH := ""
Local cContaDH := ""
Local aBaixa := {}
Local nSldPVTrans := 0
Local nVlrPVTrans := 0
Local cBcoAdt := ""
Local cAgeAdt := ""
Local cContaAdt := ""
Local aRegTitInc := {}
Local nCnt := 0
Local lResiduo := .F.
Local nRegSC5Inc := 0
Local lTransPaciente := .F.
Local cCliLojaAnt := ""
Local lBxAdtTran := .F.
Local cFilNao := ""
Local lFirstErro := .T.
Local cBandeira := ""
Local dDataBaseSav := cTod("")

Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .T.
Private lMsHelpAuto    := .F.

Default aParam := {"01","000101","000101"} // VOLTAR DEPOIS
//Default aParam := {"01","022801","022801"} // DELETAR DEPOIS

RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cCodEmp, cCodFil)

Conout("[RFatA002] - Iniciando processamento " + cCodEmp + "/ " + cCodFil + "")

nRegs := GetMv("MV_XRGPRPV",,100) // quantidade de registros a serem processados em cada execucao, no processo de inclusao de pedidos
cNat := GetMv("FS_CLINAT",,"11014")
cBcoDH := GetMv("MV_XBABXDI",,"")
cAgeDH := GetMv("MV_XAGBXDI",,"")
cContaDH := GetMv("MV_XCOBXDI",,"")
//cBco := GetMv("MV_XBABXDA",,"")
//cAge := GetMv("MV_XAGBXDA",,"")
//cConta := GetMv("MV_XCOBXDA",,"")
cBcoAdt := GetMv("MV_XBAADT",,"")
cAgeAdt := GetMv("MV_XAGADT",,"")
cContaAdt := GetMv("MV_XCOADT",,"")
dDataBaseSav := dDataBase
//cTipPagCartao := GetMv("MV_XTPPGCA",,"CC/CD")
//cTipPagDinheiro := GetMv("MV_XTPPGCA",,"DH")
//cTipPagFinanc := GetMv("MV_XTPPGCA",,"FI")



cQ := "SELECT R_E_C_N_O_,ZP2_FILIAL,ZP2_CONTRO "
cQ += "FROM " + RetSQLName("ZP2") + " ZP2 (NOLOCK) "
cQ += "WHERE ZP2_STATUS = '0' "
//cQ += " AND ZP2_FILIAL = '015601'"
cQ += " AND ZP2.D_E_L_E_T_ = ' ' " + CRLF
cQ += "ORDER BY ZP2_FILIAL,ZP2_CONTRO "



//If Len(aParam) > 3
//	For nCnt:=1 To Len(aParam)
//		If nCnt < 4
//			Loop
//		Endif	
//		cFilNao := cFilNao+"/"+aParam[nCnt]
//	Next	
//	If !Empty(cFilNao)
//		cFilNao := Subs(cFilNao,2,Len(cFilNao))
//	Endif	
//Endif	

//cQ := "SELECT TOP "+Alltrim(Str(nRegs))+" R_E_C_N_O_,ZP2_FILIAL,ZP2_CONTRO "
//cQ += "FROM " + RetSQLName("ZP2") + " ZP2 (NOLOCK) "
//cQ += "WHERE ZP2_STATUS = '0' "
//cQ += " AND ( "
//cQ += " ZP2_DTPROC = ' ' OR "
//cQ += " ZP2_DTPROC < '"+dTos(dDataBase)+"' OR "
//cQ += " ZP2_DTPROC = '"+dTos(dDataBase)+"' AND ZP2_HRPROC <= '"+StrTran(StrZero((SubHoras(Time(),"1")),5,2),".",":")+":00"+"' " // //VOLTAR DEPOIS
//cQ += " ZP2_DTPROC = '"+dTos(dDataBase)+"' " // DELETAR DEPOIS
//cQ += " ) "
//cQ += " AND ZP2_FILIAL BETWEEN '"+aParam[2]+"' AND '"+aParam[3]+"' "
//If !Empty(cFilNao)
//	cQ += " AND ZP2_FILIAL NOT IN "+FormatIn(cFilNao,"/")+" "
//Endif	
//cQ += "	AND ZP2.D_E_L_E_T_ = ' ' " + CRLF
//cQ += "ORDER BY ZP2_FILIAL,ZP2_CONTRO "
//cQ += "	,T0.ZPC_DTINI" + CRLF
//cQ += "	,T0.ZPC_HRINI" + CRLF

cTab := MPSysOpenQuery(cQ)

If (LockByName("RFatA002", .T., .F.))
	While ((cTab)->(!Eof()))

		dbSelectArea("ZP2")
		ZP2->(dbGoto((cTab)->R_E_C_N_O_))

		ZP2->(RecLock("ZP2",.F.))
		ZP2->ZP2_DTPROC := dDataBase
		ZP2->ZP2_HRPROC := Time()
		ZP2->(MsUnlock())
		(cTab)->(dbSkip())
	Enddo

	UnlockByName("RFatA002", .T., .F.)
Else
	Conout("[RFatA002] - Aguardando semáforo")			
	(cTab)->(DbCloseArea())

	Return()
Endif	

(cTab)->(dbGotop())

dbSelectArea("ZPC")
dbSetOrder(3)
While (cTab)->(!Eof())
	cFilAnt := (cTab)->ZP2_FILIAL
	dDataBase := dDataBaseSav // restaura database original

	ZP2->(dbGoto((cTab)->R_E_C_N_O_))

	ZPC->(dbSeek(xFilial("ZPC")+ZP2->ZP2_CONTRO))
	If ZPC->(!Found())
		(cTab)->(dbSkip())
		GrvZP2("P")
		Loop
	Endif	

	If !(ZPC->ZPC_STATUS == "2")
		(cTab)->(dbSkip())
		// desmarca registro da ZP2, para possibilitar registro ser processando novamente, quando ZPC_STATUS estiver 
		// igual a "2"
		ZP2->(RecLock("ZP2",.F.))
		ZP2->ZP2_DTPROC := cTod("")
		ZP2->ZP2_HRPROC := ""
		ZP2->(MsUnlock())
		Loop
	Endif

	lContinua := .T.
	lErro := .F.

	If !(Empty(ZPC->ZPC_PEDIDO))
		ZPC->(RecLock("ZPC", .F.))
		ZPC->ZPC_STATUS := "3"
		ZPC->ZPC_EXEC   := ""
		ZPC->(MsUnlock())

		GrvZP2("1")

		lContinua := .F.
	Endif

	//If Empty(cBco) .or. Empty(cAge) .or. Empty(cConta)
	//	lContinua := .F.
	//	Conout("[RFatA002] - Não encontrado dados bancarios de baixa por Dacao nos parametros.")
	//Endif	

	If Empty(cBcoDH) .or. Empty(cAgeDH) .or. Empty(cContaDH)
		lContinua := .F.
		Conout("[RFatA002] - Não encontrado dados bancarios de baixa por Dinheiro nos parametros.")
	Endif	

	If Empty(cBcoAdt) .or. Empty(cAgeAdt) .or. Empty(cContaAdt)
		lContinua := .F.
		Conout("[RFatA002] - Não encontrado dados bancarios de Adiantamento nos parametros.")
	Endif	

	If (lContinua)
		//cFilAnt := ZPC->ZPC_FILIAL
		cCodigo := ZPC->ZPC_CODIGO
		cOper := ZPC->ZPC_OPER
		lOperadora := .F.
		nValAdt := 0
		lCriaTit := .T.
		lAdt := .T.
		aTit := {}
		cSeq := "000"
		cTipoPag := ""
		dVencAdt := cTod("")
		cCliOpera := ""
		cLojaOpera := ""
		lIncTit := .T.
		lAchouPV := .F.
		lPVAberto := .T.
		cPVAlt := ""
		aBaixa := {}
		nSldPVTrans := 0
		nVlrPVTrans := 0
		aRegTitInc := {}
		lResiduo := .F.
		lTransPaciente := .F.
		cCliLojaAnt := ""
		lBxAdtTran := .F.
		lFirstErro := .T.
		cBandeira := ""

		Begin Transaction

		While ZPC->(!Eof()) .and. ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO == xFilial("ZPC")+cCodigo

			DbSelectArea("ZP0")
			dbSetOrder(1)

			DbSelectArea("ZPI")
			dbSetOrder(2)
			ZPI->(DbSeek(ZPC->ZPC_FILIAL + ZPC->ZPC_CODIGO + ZPC->ZPC_IDPV))

			DbSelectArea("ZPP")
			dbSetOrder(1)
			If cOper == "I"
				ZPP->(DbSeek(ZPC->ZPC_FILIAL + ZPC->ZPC_CODIGO))
				If (Empty(ZPC->ZPC_CONDPG))
					aParcelas := {}
					cDias     := ""

					While ZPP->(!Eof()) .And. ZPP->ZPP_FILIAL + ZPP->ZPP_CODIGO == ZPC->ZPC_FILIAL + ZPC->ZPC_CODIGO

						// para pagamentos em dinheiro/pix/debito, ajustar a database para o dia do movimento financeiro
						U_TipoPag(ZPP->ZPP_TPPAG,@cTipoPag)
						If cTipoPag $ "CD/DH"
							dDataBase := Min(dDataBase,ZPP->ZPP_DATA)
						Endif	
						cTipoPag := ""

						If !Empty(ZPP->ZPP_CNPJOP)
							lOperadora := .T.
						Endif
						If (Upper(AllTrim(ZPP->ZPP_TPPAG)) == "DINHEIRO")
							dVencto := dDataBase
						Elseif (ZPP->ZPP_VENCTO < dDataBase)
							dVencto := dDataBase
						Else
							dVencto := ZPP->ZPP_VENCTO
						Endif

						aAdd(aParcelas, dVencto - dDataBase)
						cDias += Iif(Empty(cDias), "", ",") + cValToChar(dVencto - dDataBase)

						ZPP->(DbSkip())
					Enddo

					If (Len(aParcelas) == 0)
						ZPC->(RecLock("ZPC", .F.))
						ZPC->ZPC_STATUS := "P"
						ZPC->ZPC_DTFIM  := Date()
						ZPC->ZPC_HRFIM  := Time()
						ZPC->ZPC_EXEC   := ""
						ZPC->ZPC_ERRO   := "Erro: sem parcelas"
						ZPC->ZPC_ERRLNG := "Precisa adicionar parcelas ou informar uma condição de pagamento ao registro"
						//ZPC->ZPC_PROC   := ""
						ZPC->(MsUnlock())
						
						GrvZP2("P")

						lContinua := .F.
					Elseif ((Len(aParcelas) == 1) .And. (aParcelas[1] == 0))
						ZPC->(RecLock("ZPC", .F.))
						ZPC->ZPC_CONDPG := SuperGetMV("ES_AVISTA",,"001")
						ZPC->(MsUnlock())
					Else
						If !(criaCond(cDias))
							lContinua := .F.
						Endif
					Endif
				Endif
			Endif

			If (lContinua)
				aCab   := {}
				aItem  := {}
				aItens := {}
				cItem  := StrZero(1,TamSX3("C6_ITEM")[1])
				cCliLojaAnt := ZPC->ZPC_CLIENT+ZPC->ZPC_LOJA

				If cOper == "T"
					cQ := "SELECT C5_FILIAL,C5_NUM,C5_NOTA,C5_LIBEROK,C5_BLQ,SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C6_VALOR,C5_CONDPAG "
					cQ += "FROM "+RetSqlName("SC5")+" SC5 (NOLOCK) "
					cQ += "INNER JOIN "+RetSqlName("SC6")+" SC6 (NOLOCK) "
					cQ += "ON C5_FILIAL = C6_FILIAL "
					cQ += "AND C5_NUM = C6_NUM "
					cQ += "AND C6_BLQ <> 'R' "
					cQ += "AND SC6.D_E_L_E_T_ = ' ' "
					cQ += "WHERE SC5.D_E_L_E_T_ = ' ' "
					cQ += "AND C5_XIDPV = '"+ZPC->ZPC_IDPVTR+"' "
					cQ += "GROUP BY C5_FILIAL,C5_NUM,C5_NOTA,C5_LIBEROK,C5_BLQ,C5_CONDPAG "

					cAliasTrb := MPSysOpenQuery(cQ)

					If (cAliasTrb)->(!Eof())
						lAchouPV := .T.
						cPVAlt := (cAliasTrb)->C5_NUM
						nSldPVTrans := (cAliasTrb)->C6_VALOR
						If !Empty((cAliasTrb)->C5_NOTA) .or. (cAliasTrb)->C5_LIBEROK == "E" .and. Empty((cAliasTrb)->C5_BLQ)
							lPVAberto := .F.
						Endif	

						// grava a condicao de pagamento do pedido de origem
						ZPC->(RecLock("ZPC", .F.))
						ZPC->ZPC_CONDPG := (cAliasTrb)->C5_CONDPAG
						ZPC->(MsUnlock())
					Endif	

					(cAliasTrb)->(dbCloseArea())

					If !lAchouPV
						lErro := .T.
						cErro := "Pedido de venda id: "+ZPC->ZPC_IDPVTR+" nao localizado no Protheus."
						DisarmTransaction()
						Exit
					Endif
					If !lPVAberto
						lErro := .T.
						cErro := "Pedido de venda id: "+ZPC->ZPC_IDPVTR+" ja esta encerrado no Protheus. Pedido nao podera ser alterado/excluido."
						DisarmTransaction()
						Exit
					Endif
					If lAchouPV	.and. lPVAberto
						SC5->(dbSetOrder(1))
						If SC5->(!dbSeek(xFilial("SC5")+cPVAlt))
							lErro := .T.
							cErro := "Pedido de venda id: "+ZPC->ZPC_IDPVTR+" não localizado no Protheus. Pedido nao podera ser alterado/excluido."
							DisarmTransaction()
							Exit
						Endif	
					Endif	
				Endif	

				aAdd(aCab, {"C5_TIPO"   , "N"            , Nil})
				aAdd(aCab, {"C5_CLIENTE", ZPC->ZPC_CLIENT, Nil})
				aAdd(aCab, {"C5_LOJACLI", ZPC->ZPC_LOJA  , Nil})
				aAdd(aCab, {"C5_CONDPAG", ZPC->ZPC_CONDPG, Nil})
				aAdd(aCab, {"C5_MENNOTA", ZPI->ZPI_DESCRI, Nil})
				aAdd(aCab, {"C5_XIDPV"	, ZPC->ZPC_IDPV  , Nil})

				While ZPI->(!Eof()) .and. ZPI->ZPI_FILIAL+ZPI->ZPI_CODIGO == ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO .and. Empty(ZPI->ZPI_IDPV)
					ZPI->(dbSkip())
				Enddo	

				While ZPI->(!Eof()) .and. ZPI->ZPI_FILIAL+ZPI->ZPI_CODIGO+ZPI->ZPI_IDPV == ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO+ZPC->ZPC_IDPV
					aItem := {}

					aAdd(aItem, {"C6_ITEM"   , cItem           , Nil})
					aAdd(aItem, {"C6_PRODUTO", ZPI->ZPI_PRODUT , Nil})
					aAdd(aItem, {"C6_QTDVEN" , ZPI->ZPI_VUNIT  , Nil})
					aAdd(aItem, {"C6_PRCVEN" , 1			   , Nil})
					aAdd(aItem, {"C6_PRUNIT" , 1               , Nil})

					aAdd(aItens, aItem)
					If cOper == "T"
						nVlrPVTrans := ZPI->ZPI_VUNIT
						If nSldPVTrans == ZPI->ZPI_VUNIT
							lResiduo := .T.
						Elseif nSldPVTrans < ZPI->ZPI_VUNIT	
							lErro := .T.
							cErro := "Pedido de venda id: "+ZPC->ZPC_IDPVTR+" sem saldo para ser transferido. Saldo pedido: "+Alltrim(Str(nSldPVTrans))+", Valor do pedido: "+Alltrim(Str(ZPI->ZPI_VUNIT))+" ."
							DisarmTransaction()
							Exit
						Endif	
					Endif	
					//cItem := Soma1(cItem)
					//ZPI->(DbSkip())
					Exit // sempre 1 item por pedido
				Enddo

				If lErro
					Exit
				Endif	

				lMsErroAuto := .F.

				MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 3)

				If lMsErroAuto
					TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
					RollbackSX8()
					Exit
				Else
					ConfirmSX8()
					
					// inclui ZP0 para os demais pedidos, faz aqui, pois os titulos jah foram incluidos
					For nCnt:=1 To Len(aRegTitInc)
						GrvZP0(SC5->(Recno()),aRegTitInc[nCnt],cOper)
					Next	

					If cOper == "T"
						nRegSC5Inc := SC5->(Recno())
						SC5->(dbSetOrder(1))
						If SC5->(dbSeek(xFilial("SC5")+cPVAlt))
							If !(cCliLojaAnt == SC5->C5_CLIENTE+SC5->C5_LOJACLI)
								lTransPaciente := .T.
							Endif	
							If lResiduo
								Ma410Resid("SC5",SC5->(RECNO()),2,.T.)
								lMsErroAuto := .F. // forca .F., pois variavel estah sendo retornada .T.
							Else
								// altera o pedido a ser transferido para o novo valor
								aCab := {}
								aAdd(aCab, {"C5_NUM"    , SC5->C5_NUM    , Nil})
								aAdd(aCab, {"C5_TIPO"   , "N"            , Nil})
								aAdd(aCab, {"C5_CLIENTE", SC5->C5_CLIENTE, Nil})
								aAdd(aCab, {"C5_LOJACLI", SC5->C5_LOJACLI, Nil})
								aAdd(aCab, {"C5_CONDPAG", SC5->C5_CONDPAG, Nil})

								SC6->(dbSetOrder(1))
								If SC6->(dbSeek(xFilial("SC6")+cPVAlt))
									While SC6->(!Eof()) .and. xFilial("SC6")+cPVAlt == SC6->C6_FILIAL+SC6->C6_NUM
										aItem := {}
										aitens := {}

										aAdd(aItem, {"C6_ITEM"   , SC6->c6_ITEM    	, Nil})
										aAdd(aItem, {"C6_PRODUTO", SC6->C6_PRODUTO 	, Nil})
										aAdd(aItem, {"C6_QTDVEN" , nSldPVTrans-nVlrPVTrans	, Nil})
										aAdd(aItem, {"C6_PRCVEN" , 1				, Nil})
										aAdd(aItem, {"C6_PRUNIT" , 1				, Nil})

										aAdd(aItens, aItem)
										Exit // sempre 1 item por pedido
									Enddo

									lMsErroAuto := .F.

									MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCab, aItens, 4)

									If lMsErroAuto
										TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
										RollbackSX8()
										Exit
									Else
										ConfirmSX8()
										/*
										// verifica se o pedido ja ficou encerrado por residuo, caso nao tenha ficado
										// e nao tenha mais saldo, encerra por residuo
										SC6->(dbSetOrder(1))
										If SC6->(dbSeek(xFilial("SC6")+cPVAlt))
											If !(SC5->C5_NOTA == Replicate("X",TamSX3("C5_NOTA")[1])) .and. ;
											SC6->C6_QTDVEN - SC6->C6_QTDENT == 0
												Ma410Resid("SC5",SC5->(RECNO()),2,.T.)
												lMsErroAuto := .F. // forca .F., pois variavel estah sendo retornada .T.
											Endif
										Endif		
										*/
									Endif
								Endif	
							Endif	
						Endif
						// retorna ao pedido que foi incluido
						SC5->(dbGoto(nRegSC5Inc))	

						// carrega titulos de adiantamento e recebiveis associados ao pedido anterior, para fazer 
						// a associacao do novo pedido a estes titulos		
						If !lMsErroAuto .and. !lTransPaciente
							cAliasTrb := U_AchZP0PV(ZPC->ZPC_IDPVTR)
					
							While (cAliasTrb)->(!Eof())
								SE1->(dbGoto((cAliasTrb)->ZP0_RECTIT))
								If SE1->(Recno()) == (cAliasTrb)->ZP0_RECTIT
									GrvZP0(SC5->(Recno()),(cAliasTrb)->ZP0_RECTIT,cOper)
								Endif
								(cAliasTrb)->(dbSkip())
							Enddo
						Endif	
					Endif
					
					If lCriaTit .and. !(cOper == "T" .and. !lTransPaciente) // transferencia sem troca de paciente, nao altera financeiro
						lCriaTit := .F.

						cQ := "SELECT MAX(E1_NUM) E1_NUM "
						cQ += "FROM "+RetSQLName("SE1")+" SE1 (NOLOCK) "
						cQ += "WHERE E1_FILIAL = '"+ZPC->ZPC_FILIAL+"' "
						cQ += "	AND SUBSTRING(E1_NUM,1,6) = '"+Subs(dTos(dDataBase),3)+"' "
						cQ += "	AND SE1.D_E_L_E_T_ = ' ' "

						cAliasTrb := MPSysOpenQuery(cQ)

						If (cAliasTrb)->(!Eof()) .and. !Empty((cAliasTrb)->E1_NUM)
							cSeq := Right(Alltrim((cAliasTrb)->E1_NUM),3)
						Endif	
						cSeq := Soma1(cSeq)
						
						(cAliasTrb)->(dbCloseArea())

						ZPP->(DbSeek(ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO))
						While ZPP->(!Eof()) .and. ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO == xFilial("ZPP")+ZPP->ZPP_CODIGO .and. Empty(ZPP->ZPP_IDTRAN)
							ZPP->(dbSkip())
						Enddo	

						While IIf(cOper=="I",ZPP->(!Eof()) .and. ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO == xFilial("ZPP")+ZPP->ZPP_CODIGO,IIf(cOper=="T",.T.,.F.))
							aTit := {}
							aBaixa := {}

							If lAdt
								lAdt := .F.

								If cOper == "I"
									cAliasTrb := AchZPPCli(ZPP->ZPP_CODIGO)

									While (cAliasTrb)->(!Eof()) .and. (!Empty((cAliasTrb)->ZPP_VALOR) .or. !Empty((cAliasTrb)->ZPP_VENCTO))
										If Empty(nValAdt)
											nValAdt := (cAliasTrb)->ZPP_VALOR
										Endif	
										If Empty(dVencAdt)
											dVencAdt := sTod((cAliasTrb)->ZPP_VENCTO)
										Endif	
										(cAliasTrb)->(dbSkip())
									Enddo

									(cAliasTrb)->(dbCloseArea())

								Endif	
								If cOper == "T"
									nValAdt := nVlrPVTrans
									
									cAliasTrb := U_AchZP0PV(ZPC->ZPC_IDPVTR)
									
									// carrega titulos recebiveis associados ao pedido anterior, para fazer 
									// a associacao do novo pedido a estes titulos		
									While (cAliasTrb)->(!Eof())
										SE1->(dbGoto((cAliasTrb)->ZP0_RECTIT))
										If SE1->(Recno()) == (cAliasTrb)->ZP0_RECTIT
											If !(SE1->E1_TIPO $ MVRECANT)
												GrvZP0(SC5->(Recno()),(cAliasTrb)->ZP0_RECTIT,cOper)
											Endif	
										Endif
										(cAliasTrb)->(dbSkip())
									Enddo

									// baixa adt, sutraindo o valor transferido
									// busca adt para baixar
									(cAliasTrb)->(dbGotop())
									While (cAliasTrb)->(!Eof())
										SE1->(dbGoto((cAliasTrb)->ZP0_RECTIT))
										If SE1->(Recno()) == (cAliasTrb)->ZP0_RECTIT
											// somente adt
											If !(SE1->E1_TIPO $ MVRECANT)
												(cAliasTrb)->(dbSkip())
												Loop
											Endif	
											If SE1->E1_SALDO >= nVlrPVTrans
												dVencAdt := SE1->E1_VENCTO
												
												SA6->(dbSetOrder(1)) // RETIRAR DEPOIS
												If SA6->(dbSeek(xFilial("SA6")))
													cBco := SA6->A6_COD 
													cAge := SA6->A6_AGENCIA
													cConta := SA6->A6_NUMCON
												Endif	

												If Empty(cBco) .or. Empty(cAge) .or. Empty(cConta) // RETIRAR DEPOIS
													lErro := .T.
													cErro := "Não encontrado dados bancarios de baixa por Dacao nos parametros."
													DisarmTransaction()
													Exit
												Endif	

												Pergunte("FIN070", .F.)

												aBaixa := {}
												aAdd(aBaixa, {"E1_FILIAL"   ,SE1->E1_FILIAL							,Nil})
												aAdd(aBaixa, {"E1_PREFIXO"  ,SE1->E1_PREFIXO						,Nil})
												aAdd(aBaixa, {"E1_NUM"      ,SE1->E1_NUM							,Nil})
												aAdd(aBaixa, {"E1_PARCELA"  ,SE1->E1_PARCELA						,Nil})
												aAdd(aBaixa, {"E1_TIPO"     ,SE1->E1_TIPO							,Nil})
												aAdd(aBaixa, {"AUTMOTBX"    ,"DAC"                  				,Nil})
												//aAdd(aBaixa, {"AUTBANCO"    ,PADR(cBco,TamSX3("A6_COD")[1])     	,Nil})
												//aAdd(aBaixa, {"AUTAGENCIA"  ,PADR(cAge,TamSX3("A6_AGENCIA")[1])     ,Nil})
												//aAdd(aBaixa, {"AUTCONTA"    ,PADR(cConta,TamSX3("A6_NUMCON")[1])    ,Nil})
												aAdd(aBaixa, {"AUTBANCO"    ,PADR(" ",TamSX3("A6_COD")[1])    	 	,Nil})
												aAdd(aBaixa, {"AUTAGENCIA"  ,PADR(" ",TamSX3("A6_AGENCIA")[1])  	,Nil})
												aAdd(aBaixa, {"AUTCONTA"    ,PADR(" ",TamSX3("A6_NUMCON")[1])    	,Nil})
												aAdd(aBaixa, {"AUTDTBAIXA"  ,dDataBase 		          				,Nil})
												aAdd(aBaixa, {"AUTDTCREDITO",dDataBase		           				,Nil})
												aAdd(aBaixa, {"AUTHIST"     ,"VALOR RECEBIDO S/TITULO"      		,Nil})
												aAdd(aBaixa, {"AUTVALREC"   ,nVlrPVTrans                     		,Nil})

												MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

												If lMsErroAuto
													TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
													Exit
												Else
													lBxAdtTran := .T.
													Exit
												Endif
											Else
											Endif	
										Endif	
										(cAliasTrb)->(dbSkip())
									Enddo
									(cAliasTrb)->(dbCloseArea())

									If !lBxAdtTran
										lErro := .T.
										cErro := "Adiantamento: "+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+", sem saldo para ser baixado. Saldo Adt: "+Alltrim(Str(SE1->E1_SALDO))+", Valor a baixar: "+Alltrim(Str(nVlrPVTrans))+" ."
										DisarmTransaction()
										Exit
									Endif	
								Endif	

								If !Empty(nValAdt)
									
									SA6->(dbSetOrder(1)) // RETIRAR DEPOIS
									If SA6->(dbSeek(xFilial("SA6")))
										cBcoAdt := SA6->A6_COD 
										cAgeAdt := SA6->A6_AGENCIA
										cContaAdt := SA6->A6_NUMCON
									Endif	

									If Empty(cBcoAdt) .or. Empty(cAgeAdt) .or. Empty(cContaAdt) // RETIRAR DEPOIS
										lErro := .T.
										cErro := "Não encontrado dados bancarios de Adiantamento nos parametros."
										DisarmTransaction()
										Exit
									Endif	

									//Pergunte("FIN040", .F.) // RETIRAR DEPOIS
									//mv_par03 := 2 // nao contabiliza
									//SetMVValue("FIN040","MV_PAR03",2)
									// ATE AQUI

									aAdd(aTit, {"E1_FILIAL"	,xFilial("SE1")					, Nil})
									aAdd(aTit, {"E1_PREFIXO",""								, Nil})
									aAdd(aTit, {"E1_NUM"	,Subs(dTos(dDataBase),3)+cSeq  	, Nil})
									aAdd(aTit, {"E1_PARCELA",CriaVar("E1_PARCELA")         	, Nil})
									aAdd(aTit, {"E1_TIPO"	,"RA"		 					, Nil})
									aAdd(aTit, {"E1_NATUREZ",cNat			    	    	, Nil})
									aAdd(aTit, {"E1_CLIENTE",ZPC->ZPC_CLIENT  	 			, Nil})
									aAdd(aTit, {"E1_LOJA"	,ZPC->ZPC_LOJA  		   		, Nil})
									aAdd(aTit, {"E1_EMISSAO",dDataBase  					, Nil})
									aAdd(aTit, {"E1_VENCTO"	,dVencAdt						, Nil})
									aAdd(aTit, {"E1_VALOR"  ,nValAdt			           	, Nil})
									aAdd(aTit, {"E1_HIST"	,""					            , Nil})
									//aAdd(aTit, {"E1_XIDPV"	,ZPC->ZPC_IDPV		            , Nil})
									aAdd(aTit, {"E1_XIDTRAN",IIf(cOper=="I",ZPP->ZPP_IDTRAN,"")	            , Nil})
									aAdd(aTit, {"E1_PORTADO",cBcoAdt	    		        , Nil})
									aAdd(aTit, {"E1_AGEDEP"	,cAgeAdt	 					, Nil})
									aAdd(aTit, {"E1_CONTA"	,cContaAdt			            , Nil})

									MSExecAuto({|x,y| FINA040(x,y)},aTit,3)

									If lMsErroAuto
										TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
										Exit
									Else
										GrvZP0(SC5->(Recno()),SE1->(Recno()),cOper)	
										aAdd(aRegTitInc,SE1->(Recno()))
									Endif
								Endif
							Endif		

							If cOper == "I"
								If lOperadora
									cCliOpera := GetAdvfVal("SA1","A1_COD",xFilial("SA1")+Alltrim(ZPP->ZPP_CNPJOP),3,"")
									cLojaOpera := GetAdvfVal("SA1","A1_LOJA",xFilial("SA1")+Alltrim(ZPP->ZPP_CNPJOP),3,"")
								Endif	

								If Empty(cCliOpera) .or. Empty(cLojaOpera)
									
									SA1->(DbSetOrder(1)) // RETIRAR DEPOIS
									SA1->(dbSeek(xFilial("SA1")))
									cCliOpera := SA1->A1_COD
									cLojaOpera := SA1->A1_LOJA
									If Empty(cCliOpera) .or. Empty(cLojaOpera)
									// ---- ate aqui
									
									lErro := .T.
									cErro := "Não encontrado cadastro da Operadora com o CNPJ: "+ZPP->ZPP_CNPJOP
									DisarmTransaction()
									Exit
									Endif
								Endif	

								U_TipoPag(ZPP->ZPP_TPPAG,@cTipoPag)

								If Empty(cTipoPag)
									lErro := .T.
									cErro := "Não cadastrado de/para do Tipo de Pagamento: "+cTipoPag
									DisarmTransaction()
									Exit
								Endif	

								// valida de/para de bandeiras
								If !Empty(ZPP->ZPP_BANDEI) .and. !(Alltrim(Upper(ZPP->ZPP_BANDEI)) == "NULL")
									cQ := "SELECT X5_CHAVE "
									cQ += "FROM "+RetSqlName("SX5")+" SX5 (NOLOCK) "
									cQ += "WHERE X5_FILIAL = ' ' "
									cQ += "AND X5_TABELA = 'ZZ' "
									cQ += "AND X5_DESCRI = '"+Alltrim(Upper(ZPP->ZPP_BANDEI))+"' "
									cQ += "AND SX5.D_E_L_E_T_ = ' ' "

									cAliasTrb := MPSysOpenQuery(cQ)

									If (cAliasTrb)->(!Eof())
										cBandeira := (cAliasTrb)->X5_CHAVE
									Endif	

									(cAliasTrb)->(dbCloseArea())
									If Empty(cBandeira)
										lErro := .T.
										cErro := "Não cadastrado de/para da Bandeira (arquivo: SX5, tabela: ZZ): "+Upper(ZPP->ZPP_BANDEI)
										DisarmTransaction()
										Exit
									Endif									
								Endif	

								If lIncTit
									cSeq := Soma1(cSeq)
									lIncTit := .F.
								Endif	
								
								//Pergunte("FIN040", .F.) // RETIRAR DEPOIS
								//mv_par03 := 2 // nao contabiliza
								//SetMVValue("FIN040","MV_PAR03",2)
								// ATE AQUI

								aTit := {}	
								aAdd(aTit, {"E1_FILIAL"	,xFilial("SE1")					, Nil})
								aAdd(aTit, {"E1_PREFIXO",""								, Nil})
								aAdd(aTit, {"E1_NUM"	,Subs(dTos(dDataBase),3)+cSeq  	, Nil})
								aAdd(aTit, {"E1_PARCELA",StrZero(Val(ZPP->ZPP_PARC),TamSX3("E1_PARCELA")[1])        	, Nil})
								aAdd(aTit, {"E1_TIPO"	,cTipoPag	 					, Nil})
								aAdd(aTit, {"E1_NATUREZ",cNat			    	    	, Nil})
								If lOperadora
									aAdd(aTit, {"E1_CLIENTE",cCliOpera		  	 			, Nil})
									aAdd(aTit, {"E1_LOJA"	,cLojaOpera		  		   		, Nil})
								Else
									aAdd(aTit, {"E1_CLIENTE",ZPC->ZPC_CLIENT  	 			, Nil})
									aAdd(aTit, {"E1_LOJA"	,ZPC->ZPC_LOJA	  		   		, Nil})
								Endif	
								aAdd(aTit, {"E1_EMISSAO",IIf(ZPP->ZPP_DATA>ZPP->ZPP_VENCTO,ZPP->ZPP_VENCTO,ZPP->ZPP_DATA)  				, Nil})
								aAdd(aTit, {"E1_VENCTO"	,ZPP->ZPP_VENCTO				, Nil})
								aAdd(aTit, {"E1_VALOR"  ,ZPP->ZPP_VALOR		           	, Nil})
								aAdd(aTit, {"E1_HIST"	,ZPP->ZPP_HISTOR	            , Nil})
								//aAdd(aTit, {"E1_XIDPV"	,ZPC->ZPC_IDPV		            , Nil})
								aAdd(aTit, {"E1_XIDTRAN",ZPP->ZPP_IDTRAN	            , Nil})
								If lOperadora
									aAdd(aTit, {"E1_NSUTEF" ,ZPP->ZPP_NSU	            , Nil})
									aAdd(aTit, {"E1_CARTAUT",ZPP->ZPP_CODAUT            , Nil})
									aAdd(aTit, {"E1_XCARTHR",ZPP->ZPP_HORA	            , Nil})
									aAdd(aTit, {"E1_NUMCART",ZPP->ZPP_CARTAO            , Nil})
									aAdd(aTit, {"E1_XIDPIX" ,ZPP->ZPP_IDPIX	            , Nil})
									aAdd(aTit, {"E1_XBANDEI",cBandeira		            , Nil})
								Endif	
						
								MSExecAuto({|x,y| FINA040(x,y)},aTit,3)

								If lMsErroAuto
									TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
									Exit
								Else
									GrvZP0(SC5->(Recno()),SE1->(Recno()),cOper)
									aAdd(aRegTitInc,SE1->(Recno()))
									If cTipoPag == "DH"
										
										SA6->(dbSetOrder(1)) // RETIRAR DEPOIS
										If SA6->(dbSeek(xFilial("SA6")))
											cBcoDH := SA6->A6_COD 
											cAgeDH := SA6->A6_AGENCIA
											cContaDH := SA6->A6_NUMCON
										Endif	

										If Empty(cBcoDH) .or. Empty(cAgeDH) .or. Empty(cContaDH) // RETIRAR DEPOIS
											lErro := .T.
											cErro := "Não encontrado dados bancarios de baixa por Dinheiro nos parametros."
											DisarmTransaction()
											Exit
										Endif	

										Pergunte("FIN070", .F.)

										aBaixa := {}
										aAdd(aBaixa, {"E1_FILIAL"   ,SE1->E1_FILIAL							,Nil})
										aAdd(aBaixa, {"E1_PREFIXO"  ,SE1->E1_PREFIXO						,Nil})
										aAdd(aBaixa, {"E1_NUM"      ,SE1->E1_NUM							,Nil})
										aAdd(aBaixa, {"E1_PARCELA"  ,SE1->E1_PARCELA						,Nil})
										aAdd(aBaixa, {"E1_TIPO"     ,SE1->E1_TIPO							,Nil})
										aAdd(aBaixa, {"AUTMOTBX"    ,"NOR"                  				,Nil})
										aAdd(aBaixa, {"AUTBANCO"    ,PADR(cBcoDH,TamSX3("A6_COD")[1])     	,Nil})
										aAdd(aBaixa, {"AUTAGENCIA"  ,PADR(cAgeDH,TamSX3("A6_AGENCIA")[1])   ,Nil})
										aAdd(aBaixa, {"AUTCONTA"    ,PADR(cContaDH,TamSX3("A6_NUMCON")[1])  ,Nil})
										aAdd(aBaixa, {"AUTDTBAIXA"  ,dDataBase		           				,Nil})
										aAdd(aBaixa, {"AUTDTCREDITO",dDataBase		           				,Nil})
										aAdd(aBaixa, {"AUTHIST"     ,"VALOR RECEBIDO S/TITULO"      		,Nil})
										aAdd(aBaixa, {"AUTVALREC"   ,SE1->E1_VALOR                     		,Nil})

										MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)

										If lMsErroAuto
											TrataErro(@cErro,@cMsgErro,@aLog,@lErro)
											Exit
										Endif
									Endif
								Endif
							Endif	

							If lErro
								Exit
							Endif	

							// para transferencia, nao tem ZPP
							If cOper == "T"
								Exit
							Endif	

							ZPP->(dbSkip())
						Enddo	
					Endif	
				Endif	

				If !lErro
					ZPC->(RecLock("ZPC", .F.))
					ZPC->ZPC_PEDIDO := SC5->C5_NUM
					ZPC->ZPC_STATUS := "3"
					ZPC->ZPC_DTFIM  := Date()
					ZPC->ZPC_HRFIM  := Time()
					ZPC->ZPC_EXEC   := ""
					ZPC->ZPC_ERRO   := ""
					ZPC->ZPC_ERRLNG := ""
					//ZPC->ZPC_PROC   := ""
					ZPC->(MsUnlock())

					GrvZP2("1")	
				Else
					Exit	
				Endif	
			Endif
			ZPC->(dbSkip())
		Enddo	

		If lErro
			While ZPC->(!Eof()) .and. ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO == xFilial("ZPC")+cCodigo 
				ZPC->(RecLock("ZPC", .F.))
				ZPC->ZPC_STATUS := "P"
				ZPC->ZPC_DTFIM  := Date()
				ZPC->ZPC_HRFIM  := Time()
				ZPC->ZPC_EXEC   := ""
				If lFirstErro
					ZPC->ZPC_ERRO   := Iif(Empty(cErro), "Erro de execauto: MATA410, vide erro longo", cErro)
					ZPC->ZPC_ERRLNG := cMsgErro
				Else
					ZPC->ZPC_ERRO   := "Erro na importacao do item anterior deste processo. Processo abortado"
					ZPC->ZPC_ERRLNG := ""
				Endif	
				//ZPC->ZPC_PROC   := ""
				ZPC->(MsUnlock())

				GrvZP2("P")	
				lFirstErro := .F.

				ZPC->(DbSkip())
			Enddo	
		Endif

		End Transaction

	Endif	
	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

Conout("[RFatA002] - Finalizando processamento " + cCodEmp + "")

Return()

/*/{Protheus.doc} criaCond
Rotina que cria condição de pagamento
@type function
@author DWC
@since 11/04/2022
/*/

Static Function criaCond(cCond)
Local cQ     := ""
Local cTab       := ""
Local cCondPagto := ""
Local aMata360   := {}
Local cErro      := ""
Local cMsgErro   := ""
Local aLog       := {}
Local nI         := 0

cQ := "SELECT T0.E4_CODIGO " + CRLF
cQ += "FROM " + RetSQLName("SE4") + " T0 (NOLOCK) " + CRLF
cQ += "WHERE T0.E4_FILIAL = '" + xFilial("SE4") + "' " + CRLF
cQ += "	AND T0.E4_COND = '" + cCond + "' " + CRLF
cQ += "	AND T0.E4_MSBLQL <> '1' " + CRLF
cQ += "	AND T0.D_E_L_E_T_ = '' " + CRLF

cTab := MPSysOpenQuery(cQ)

DbSelectArea((cTab))
(cTab)->(dbGotop())

While ((cTab)->(!Eof()))
	cCondPagto := (cTab)->E4_CODIGO

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

If (Empty(cCondPagto))
	cQ := "SELECT MAX(T0.E4_CODIGO) E4_CODIGO " + CRLF
	cQ += "FROM " + RetSQLName("SE4") + " T0 (NOLOCK) " + CRLF
	cQ += "WHERE T0.E4_FILIAL = '" + xFilial("SE4") + "' " + CRLF
	cQ += "	AND T0.E4_COND = '" + cCond + "' " + CRLF
	cQ += "	AND T0.E4_MSBLQL <> '1' " + CRLF
	cQ += "	AND T0.D_E_L_E_T_ = '' " + CRLF

	cTab := MPSysOpenQuery(cQ)

	DbSelectArea((cTab))
	(cTab)->(DbGoTop())

	While ((cTab)->(!Eof()))
		cCondPagto := Soma1((cTab)->E4_CODIGO)

		(cTab)->(DbSkip())
	Enddo

	(cTab)->(DbCloseArea())

	aMata360 := {}
	aAdd(aMata360, {"E4_CODIGO", cCondPagto   , Nil})
	aAdd(aMata360, {"E4_TIPO"  , "1"          , Nil})
	aAdd(aMata360, {"E4_COND"  , cCond        , Nil})
	aAdd(aMata360, {"E4_DESCRI", cCond + " DD", Nil})
	aAdd(aMata360, {"E4_DDD"   , "L"          , Nil})
	aAdd(aMata360, {"E4_CTRADT", "1"          , Nil})

	lMsErroAuto := .F.

	MsExecAuto({|x, y, z| MATA360(x, y, z)}, aMata360, , 3)

	If lMsErroAuto
		cErro    := ""
		cMsgErro := ""
		aLog     := GetAutoGRLog()

		For nI := 1 To Len(aLog)
			If ("< -- Inv" $ aLog[nI])
				cErro := aLog[nI]
			Endif

			cMsgErro += aLog[nI] + CRLF
		Next nI

		RollbackSX8()
	Else
		ConfirmSX8()

		cCondPagto := SE4->E4_CODIGO
	Endif
Endif

ZPC->(RecLock("ZPC", .F.))
If (!Empty(cCondPagto))
	ZPC->ZPC_CONDPG := cCondPagto
Else
	ZPC->ZPC_STATUS := "P"
	ZPC->ZPC_DTFIM  := Date()
	ZPC->ZPC_HRFIM  := Time()
	ZPC->ZPC_EXEC   := ""
	ZPC->ZPC_ERRO   := Iif(Empty(cErro), "Erro Inclusão Cond.Pagto", cErro)
	ZPC->ZPC_ERRLNG := cMsgErro
	//ZPC->ZPC_PROC   := ""

	GrvZP2("P")	
Endif
ZPC->(MsUnlock())

Return(!Empty(cCondPagto))


Static Function	TrataErro(cErro,cMsgErro,aLog,lErro)

Local nI := 0

cErro    := ""
cMsgErro := ""
aLog     := GetAutoGRLog()

For nI := 1 To Len(aLog)
	If ("< -- Inv" $ aLog[nI])
		cErro := aLog[nI]
	Endif
	cMsgErro += aLog[nI] + CRLF
Next nI

DisarmTransaction()
lErro := .T.

Return()


User Function TipoPag(cTipo,cTipoPag)

cTipo := Upper(Alltrim(FWNoAccent(cTipo)))
If "CREDITO" $ cTipo
	cTipoPag := "CC"
Elseif "DEBITO" $ cTipo	
	cTipoPag := "CD"
Elseif "DINHEIRO" $ cTipo	
	cTipoPag := "DH"
Elseif "PIX" $ cTipo	
	cTipoPag := "CD"
Elseif "LOSANGO" $ cTipo	
	cTipoPag := "FI"
Elseif "CASH" $ cTipo	
	cTipoPag := "FI"
Elseif "CRED" $ cTipo	
	cTipoPag := "CC"
Elseif "BRASIL CARD" $ cTipo	
	cTipoPag := "CC"
Endif

Return()


Static Function GrvZP0(nRecnoSC5,nRecnoSE1,cOper)

ZP0->(dbSetOrder(1))
If ZP0->(dbSeek(xFilial("ZP0")+Alltrim(Str(nRecnoSC5))))
	While ZP0->(!Eof()) .and. xFilial("ZP0")+Alltrim(Str(nRecnoSC5)) == ZP0->ZP0_FILIAL+Alltrim(Str(ZP0->ZP0_RECPED))
		If !(Alltrim(Str(nRecnoSE1)) == Alltrim(Str(ZP0->ZP0_RECTIT)))
			ZP0->(RecLock("ZP0",.T.))
			ZP0->ZP0_FILIAL := xFilial("ZP0")
			ZP0->ZP0_RECPED := nRecnoSC5
			ZP0->ZP0_RECTIT := nRecnoSE1
			ZP0->(MsUnlock())
		Endif
		ZP0->(dbSkip())
	Enddo
Else
	ZP0->(RecLock("ZP0",.T.))
	ZP0->ZP0_FILIAL := xFilial("ZP0")
	ZP0->ZP0_RECPED := nRecnoSC5
	ZP0->ZP0_RECTIT := nRecnoSE1
	ZP0->(MsUnlock())
Endif			

Return()


Static Function GrvZP2(cStatus)	

ZP2->(RecLock("ZP2",.F.))
ZP2->ZP2_STATUS := cStatus
ZP2->(MsUnlock())

Return()


Static Function AchZPPCli(cCodigo)

Local cAliasTrb := GetNextAlias()
Local cQ := ""

cQ := "SELECT * "
cQ += "FROM ( "
cQ += "SELECT SUM(ZPP_VALOR) ZPP_VALOR,'' ZPP_VENCTO "
cQ += "FROM "+RetSQLName("ZPP")+" ZPP (NOLOCK) "
cQ += "WHERE ZPP_FILIAL = '"+xFilial("ZPP")+"' "
cQ += "	AND ZPP_CODIGO = '"+cCodigo+"' "
cQ += " AND ZPP_IDTRAN <> ' ' "
cQ += "	AND ZPP.D_E_L_E_T_ = ' ' "
cQ += "UNION ALL "
cQ += "SELECT 0 ZPP_VALOR,MAX(ZPP_VENCTO) ZPP_VENCTO "
cQ += "FROM "+RetSQLName("ZPP")+" ZPP (NOLOCK) "
cQ += "WHERE ZPP_FILIAL = '"+xFilial("ZPP")+"' "
cQ += "	AND ZPP_CODIGO = '"+cCodigo+"' "
cQ += " AND ZPP_IDTRAN <> ' ' "
cQ += "	AND ZPP.D_E_L_E_T_ = ' ' "
cQ += ") T "

cAliasTrb := MPSysOpenQuery(cQ)

Return(cAliasTrb)


User Function AchZP0PV(cPV)

Local cAliasTrb := GetNextAlias()
Local cQ := ""
//Local cSepRec := IIf("|"$MVRECANT,"|",",")

cQ := "SELECT ZP0_RECTIT "
cQ += "FROM "+RetSQLName("SC5")+" SC5 (NOLOCK) "
cQ += "INNER JOIN "+RetSQLName("ZP0")+" ZP0 (NOLOCK) "
cQ += "ON ZP0_FILIAL = '"+xFilial("ZP0")+"' "
cQ += " AND ZP0_RECPED = SC5.R_E_C_N_O_ "
cQ += "	AND ZP0.D_E_L_E_T_ = ' ' "
cQ += "WHERE C5_FILIAL = '"+xFilial("SC5")+"' "
cQ += "	AND C5_XIDPV = '"+cPV+"' "
cQ += "	AND SC5.D_E_L_E_T_ = ' ' "
/*
cQ += "UNION "
cQ += "SELECT E1.R_E_C_N_O_ ZP0_RECTIT "
cQ += "FROM "+RetSQLName("SE1")+" SE1 (NOLOCK) "
cQ += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
cQ += "	AND E1_CLIENTE = '"+cCliente+"' "
cQ += "	AND E1_LOJA = '"+cLoja+"' "
cQ += "	AND E1_SALDO > 0 "
cQ += "	AND E1_TIPO IN "+FormatIn(MVRECANT,cSepRec)+" "
cQ += "	AND SE1.D_E_L_E_T_ = ' ' "
*/
cAliasTrb := MPSysOpenQuery(cQ)

Return(cAliasTrb)


User Function AchZP0Tit(nRecTit)

Local cAliasTrb := GetNextAlias()
Local cQ := ""

cQ := "SELECT ZP0_RECPED "
cQ += "FROM "+RetSQLName("SE1")+" SE1 (NOLOCK) "
cQ += "INNER JOIN "+RetSQLName("ZP0")+" ZP0 (NOLOCK) "
cQ += "ON ZP0_FILIAL = '"+xFilial("ZP0")+"' "
cQ += " AND ZP0_RECTIT = SE1.R_E_C_N_O_ "
cQ += "	AND ZP0.D_E_L_E_T_ = ' ' "
cQ += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
cQ += "	AND SE1.R_E_C_N_O_ = '"+Alltrim(Str(nRecTit))+"' "
cQ += "	AND SE1.D_E_L_E_T_ = ' ' "

cAliasTrb := MPSysOpenQuery(cQ)

Return(cAliasTrb)
