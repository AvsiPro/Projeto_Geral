#Include 'Protheus.ch'
#Include 'Topconn.ch'

/**
 * Função:			ExclSep
 * Autor:			Alterado: Paulo Lima
 * Data:			15/12/2021
 * Descrição:		
 */

User Function ExclSep()
	Local lRet		:= .t.
	Local cMens		:= ""

	Private aRegSD3 := {} // Uso da Função a260Processa
	private cCusMed := GetMv("MV_CUSMED") // Uso da Função a260Processa

	if ValidPerg()
	
		Processa({||fExcluiTab(@lRet,@cMens) },"Selecionando informações para exclusão..." )

		if lRet
			MsgInfo("Ordem de Separação excluída com sucesso.","Atenção")
			//U__GlogGrl("EXCLSEP", "FAT", "Ordem de Separação excluída "+mv_par01)
		else
			MsgInfo(cMens,"Atenção")
		endif
	EndIf
Return

//Função: fExcluiTab() - Exclui Registros das Tabelas CB6, CB7, CB8, CB9 e Limpa Campos do SC9 para Liberar
//                       Pedido de Venda, caso não exista Nota Fiscal Gerada.
Static Function fExcluiTab(lRet,cMens)
	Local aVol		:= {}
	Local aTransfer	:= {}
	Local aItens	:= {}
	Local cPedido	:= CriaVar("CB8_PEDIDO")

	Local cArmaz 	:= GetMv("MV_ZZARMAZ")
	Local cEnder	:= GetMv("MV_ZZENDER")
	//Local cAlias	:= GetNextAlias()
	//Local cQuery	:= ""
	Local nQtd2		:= 0
	Local dDtaValid := CTOD("")
	local aAreaSC6	:= Nil
	local xPto
	local yPto

	Begin Transaction
		dbSelectArea("CB7")
		CB7->(dbSetOrder(1))
		if dbSeek(xFilial("CB7")+mv_par01)
			if Empty(CB7->(CB7_NOTA+CB7_SERIE))
				lRet:= .t.

				IncProc()
				
				///deve depois para caso ocorra um erro ao excluir possa tentar novamente
				//Do While !CB7->(Eof()) .and. CB7->CB7_ORDSEP == mv_par01
				//	CB7->(RecLock("CB7", .F.))
				//	CB7->(dbDelete())
				//	CB7->(MsUnlock())
				//	CB7->(dbSkip())
				//enddo

				dbSelectArea("CB8")
				CB8->(dbSetOrder(1))
				if dbSeek(xFilial("CB8")+mv_par01)
					cPedido:= CB8->CB8_PEDIDO

					Do While !CB8->(Eof()) .and. CB8->CB8_ORDSEP == mv_par01
						CB8->(RecLock("CB8", .F.))
						CB8->(dbDelete())
						CB8->(MsUnlock())
						CB8->(dbSkip())
					enddo
				endif

				CB9->(dbSetOrder(1))
				if CB9->(dbSeek(xFilial("CB9")+mv_par01))
					Do While !CB9->(Eof()) .and. CB9->CB9_ORDSEP == mv_par01
						///cLocaliz	:= Posicione("SDC", 1, xFilial("SDC") + CB9->(CB9_PROD+CB9_LOCAL+"SC6"+CB9_PEDIDO+CB9_ITESEP), "DC_LOCALIZ")
						nQtd2   	:= Posicione("SC9", 1, xFilial("SC9") + CB9->(CB9_PEDIDO+CB9_ITESEP+CB9_SEQUEN+CB9_PROD), "C9_QTDLIB2")
						dDtaValid	:= Posicione("SC9", 1, xFilial("SC9") + CB9->(CB9_PEDIDO+CB9_ITESEP+CB9_SEQUEN+CB9_PROD), "C9_DTVALID")

						nPos := aScan(aVol, {|x| x[1] == CB9->CB9_VOLUME })
						if nPos == 0
							AAdd(aVol, {CB9->CB9_VOLUME	})
						endif

						AAdd(aItens, {		CB9->CB9_PROD	,;
											CB9->CB9_ITESEP	})
								
						AAdd(aTransfer, { 	CB9->CB9_PROD	,;
											CB9->CB9_LOCAL	,;
											CB9->CB9_PEDIDO	,;
											CB9->CB9_QTESEP	,;
											nQtd2		 	,;
											CB9->CB9_LOTECT ,;
											dDtaValid		,;
											CB9->CB9_LCALIZ   })
											///cLocaliz		})

						CB9->(RecLock("CB9", .F.))
						CB9->(dbDelete())
						CB9->(MsUnlock())

						CB9->(dbSkip())
					enddo
				endif

				if Len(aVol) > 0
					For xPto := 1 to Len(aVol)
						dbSelectArea("CB6")
						if CB6->(dbSeek(xFilial("CB6") + aVol[xPto, 1]))
							Do While !CB6->(Eof()) .and. CB6->CB6_VOLUME == aVol[xPto,1]
								CB6->(RecLock("CB6", .F.))
								CB6->(dbDelete())
								CB6->(MsUnlock())

								CB6->(dbSkip())
							enddo
						endif
					Next xPto
				endif
		
				aAreaSC6:=SC6->(getArea())
				if Len(aItens) > 0
					For yPto := 1 to Len(aItens)
						dbSelectArea("SC6")
						dbSetOrder(2)
						if dbSeek(xFilial("SC6")+aItens[yPto,1]+cPedido+aItens[yPto,2])
							RecLock("SC6", .F.)
								SC6->C6_LOCAL	:= cArmaz
								SC6->C6_LOCALIZ	:= cEnder
							MsUnlock()
						endif
					Next yPto
				endif
				restArea(aAreaSC6)

				///deve depois para caso ocorra um erro ao excluir possa tentar novamente
				Do While !CB7->(Eof()) .and. CB7->CB7_ORDSEP == mv_par01
					CB7->(RecLock("CB7", .F.))
					CB7->(dbDelete())
					CB7->(MsUnlock())

					CB7->(dbSkip())
				enddo
				///
				
				dbSelectArea("SC9")
				if dbSeek(xFilial("SC9")+cPedido)
					Do While SC9->(!Eof()) .and. SC9->C9_PEDIDO == cPedido
						SC9->(A460ESTORNA())
						SC9->(dbSkip())
					enddo
				endif
				
				//Faz ajustes no Status do Pedido
				dbSelectArea("ZZ1")
				If dbSeek(xFilial("ZZ1")+cPedido)
				RecLock("ZZ1",.F.)
					/*/
					ZZ1_FILIAL      := xFilial("ZZ1")
					ZZ1->ZZ1_PEDIDO := cPedido
					/*/
					ZZ1->ZZ1_I_FS01 := DtoS(Date()) + Time()
					ZZ1->ZZ1_F_FS01 := Space(13)
					ZZ1->ZZ1_I_FS02 := Space(13)
					ZZ1->ZZ1_F_FS02 := Space(13)
					ZZ1->ZZ1_I_FS03 := Space(13)
					ZZ1->ZZ1_F_FS03 := Space(13)
					ZZ1->ZZ1_I_FS04 := Space(13)
					ZZ1->ZZ1_F_FS04 := Space(13)
					ZZ1->ZZ1_I_FS05 := Space(13)
					ZZ1->ZZ1_F_FS05 := Space(13)
					ZZ1->ZZ1_I_FS06 := Space(13)
					ZZ1->ZZ1_F_FS06 := Space(13)
					ZZ1->ZZ1_EXCLUS := DtoS(Date()) + Time()
				MsUnlock()
				EndIf
				
				dbSelectArea("SC5")
					if dbSeek(xFilial("SC5")+cPedido)
						RecLock("SC5",.F.)
							SC5->C5_ZZSTATU := " "
						MsUnlock()
					EndIf

				// Faz Transferência de Armazem e Endereço
				fTransfere(aTransfer,cArmaz,cEnder)
			
			else
				lRet:= .f.
				cMens:= "Não foi possível excluir a Ordem de Separação pois já foi gerada Nota Fiscal."
			endif
		else
			lRet:= .f.
			cMens:= "Não foi possível encontrar a Ordem de Separação informada."
		endif
	End Transaction
Return

//Função: fTransfere() - Faz a Transferência de Armazém e Endereço
Static Function fTransfere(aTransfer,cArmaz,cEnder)
	Local t		:= 0
	
	For t := 1 to Len(aTransfer)

		a260Processa(	aTransfer[t,1]					,;  		// ExpC01: 	Codigo do Produto Origem 	- Obrigatorio
						aTransfer[t,2]					,;	 		// ExpC02: 	Almox Origem             	- Obrigatorio
						aTransfer[t,4]					,;			// ExpN01: Quantidade 1a UM        		- Obrigatorio
						aTransfer[t,3]					,;			// ExpC03: Documento               		- Obrigatorio
						dDatabase						,;			// ExpD01: Data                     	- Obrigatorio
						aTransfer[t,5]					,; 			// ExpN02: Quantidade 2a UM				-
						""								,;			// ExpC04: Sub-Lote                 	- Obrigatorio se Rastro "S"
						aTransfer[t,6]					,;			// ExpC05: Lote                     	- Obrigatorio se usa Rastro
						aTransfer[t,7]					,;			// ExpD02: Validade                 	- Obrigatorio se usa Rastro
						nil								,;			// ExpC06: Numero de Serie				-
						aTransfer[t,8]					,;			// ExpC07: Localizacao Origem			-
						aTransfer[t,1]					,; 			// ExpC08: Codigo do Produto Destino	- Obrigatorio
						cArmaz							,;			// ExpC09: Almox Destino            	- Obrigatorio
						cEnder							,;			// ExpC10: Localizacao Destino			-
						.F.,NIL,NIL,"MATA260")

																	/*/

																	ExpL01: Indica se movimento e estorno
																	ExpN03: Numero do registro original (utilizado estorno)
																	ExpN04: Numero do registro destino (utilizado estorno)
																	ExpC11: Indicacao do programa que originou os lancamentos
																	ExpC12: cEstFis    - Estrutura Fisica          (APDL)
																	ExpC13: cServico   - Servico                   (APDL)
																	ExpC14: cTarefa    - Tarefa                    (APDL)
																	ExpC15: cAtividade - Atividade                 (APDL)
																	ExpC16: cAnomalia - Houve Anomalia? (S/N)     (APDL)
																	ExpC17: cEstDest   - Estrututa Fisica Destino (APDL)
																	ExpC18: cEndDest   - Endereco Destino          (APDL)
																	ExpC19: cHrInicio - Hora Inicio               (APDL)
																	ExpC20: cAtuEst    - Atualiza Estoque? (S/N)   (APDL)
																	ExpC21: cCarga     - Numero da Carga           (APDL)
																	ExpC22: cUnitiza   - Numero do Unitizador      (APDL)
																	ExpC23: cOrdTar    - Ordem da Tarefa           (APDL)
																	ExpC24: cOrdAti    - Ordem da Atividade        (APDL)
																	ExpC25: cRHumano   - Recurso Humano            (APDL)
																	ExpC26: cRFisico   - Recurso Fisico            (APDL)
																	ExpN05: nPotencia - Potencia do Lote               
																	ExpC27: cLoteDest - Lote Destino da Transferencia   
																	ExpD03: dDtVldDest - Validade Lote Destino da Trasnferencia
																	/*/


		ConOut("Transferencia item: " + StrZero(t, 03))
	Next t
Return

// Funcao: ValidPerg(cPerg)
// Descricao: Verifica a existencia do grupo de perguntas, caso nao exista cria.

Static Function ValidPerg()
	
	Local aParBox	:= {}
	Local cPerg		:= "ZZEXCOS"
			
	aAdd(aParBox,{1,"Ordem de Separação:"	, "      " ,"","", "CB7",,50,.F.,})//MV_PAR01
			
Return ParamBox(aParBox, "Exclusão de Ordem Separação",,,,,,,, cPerg, .T., .T.)


