#Include 'Protheus.ch'
#Include 'topconn.ch'

 /*/{Protheus.doc} GeraOSep

@author    Paulo Lima
@since    02/12/2021
@param    xNomParam, cTipParam, cDesParam
@return    Nil
/*/
User Function GeraOSep(cOrigem)

local aAreaSC5		:= SC5->(GetArea())

	If cOrigem == ("SC5")

			OrdSepSC5()
		
	ElseIf cOrigem == ("SC2")
		//OrdSepSC2() //ordem de separação na produção PCP
		//MsgAlert("Não implantado ACD para PCP", "ALERTA")
	EndIf
	
restArea(aAreaSC5)

Return

/*/{Protheus.doc}	OrdSepSC5
Rotina responsável por fazer a geração do CB7 / CB8 com dados oriundos do SC5 e SC9.

@author				Paulo Lima
@since				02/12/2021
@return				cOrdSep
/*/
Static Function OrdSepSC5()
	Local aAreaATU		:= GetArea()
	Local aAreaCB7		:= CB7->(GetArea())
	Local aAreaSC9		:= SC9->(GetArea())
	Local aAreaSDC		:= SDC->(GetArea())
	Local nCont			:= 0
	Local cOrdSep		:= ""
	Local cChave		:= ""
	Local cPedido		:= SC5->C5_NUM
	Local cMarcaATU		:= ThisMark()
	Local lTemSep		:= .F.
	Local lContinua		:= .F.
	Local cVldTpc5		:= Posicione("SC5", 1, xFilial("SC5") + cPedido, "C5_TIPO")

	SDC->(DbSetOrder(1))	// DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_ORIGEM + DC_PEDIDO + DC_ITEM + DC_SEQ + DC_LOTECTL + DC_NUMLOTE + DC_LOCALIZ + DC_NUMSERI
	SC9->(DbSetOrder(1))	// C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	
	If SC9->(DbSeek(xFilial("SC9") + cPedido))
		// Testa se tem o registro no CDC. So fazer caso este exista.	
		cChave := xFilial("SDC") + SC9->C9_PRODUTO + SC9->C9_LOCAL + "SC6" + cPedido
		If SDC->(DbSeek(cChave)) .and. cVldTpc5 <> "D"
			// Posiciona no primeiro registro do SC9.
			CB7->(DbSetOrder(2))	// CB7_FILIAL + CB7_PEDIDO + CB7_LOCAL + CB7_STATUS + CB7_CLIENT + CB7_LOJA + CB7_COND + CB7_LOJENT + CB7_AGREG
	
			If !CB7->(DbSeek(xFilial("CB7") + cPedido))
				// Caso não haja nenhum item do pedido com bloqueio
				If Len(getBloqItens(cPedido)) == 0
					
					/*/		   //GETSXENUM( <alias>, <campo>, <aliasSXE>, <ordem> )
					cOrdSep := GetSxeNum("CB7","CB7_ORDSEP")
					
					// É feito um tratamento bruto de erro. Caso não dê certo, é feito um rollback da numeração
					if reclock('CB7',.T.)
						// Utilize o CB7_ORDSEP neste bloco na gravação de campo(s).
						ConfirmSx8()
						msunlock('SE1')
					else
						RollbackSx8()
					endif
					/*/

					cOrdSep := CB_SXESXF("CB7", "CB7_ORDSEP",, 1)
					ConfirmSX8()

					lContinua := .T.
		
					RecLock("CB7", .T.)
						CB7->CB7_FILIAL			:= xFilial("CB7")
						CB7->CB7_ORDSEP			:= cOrdSep
						CB7->CB7_PEDIDO			:= cPedido
						CB7->CB7_CLIENT			:= SC9->C9_CLIENTE
						CB7->CB7_LOJA			:= SC9->C9_LOJA
						CB7->CB7_COND			:= Posicione("SC5", 1, xFilial("SC5") + cPedido, "C5_CONDPAG"	)
						CB7->CB7_LOJENT			:= Posicione("SC5", 1, xFilial("SC5") + cPedido, "C5_LOJAENT"	)
						CB7->CB7_TRANSP			:= Posicione("SC5", 1, xFilial("SC5") + cPedido, "C5_TRANSP"	)
						CB7->CB7_LOCAL			:= SC9->C9_LOCAL
						CB7->CB7_DTEMIS			:= dDataBase
						CB7->CB7_HREMIS			:= Time()
						CB7->CB7_STATUS			:= "0"
						CB7->CB7_CODOPE			:= " "
						CB7->CB7_PRIORI			:= "1"
						CB7->CB7_ORIGEM			:= "1"
						CB7->CB7_TIPEXP			:= "00*02*03*11*08*10*"
					CB7->(MsUnLock())
		
					nCont := 0
		
					// Neste momento já verifiquei se existem item bloqueados no SC9, e o resultado desta verificação está na variavel lContinua
					if lContinua
						Do While SC9->(!Eof()) .And. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + cPedido
							// Posiciona no SDC que para cada registro no SC9, pode ter vários registros no SDC.
							// DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_ORIGEM + DC_PEDIDO + DC_ITEM + DC_SEQ + DC_LOTECTL + DC_NUMLOTE + DC_LOCALIZ + DC_NUMSERI
							cChave := xFilial("SDC") + SC9->C9_PRODUTO + SC9->C9_LOCAL + "SC6" + cPedido + SC9->C9_ITEM + SC9->C9_SEQUEN
							SDC->(DbSeek(cChave))
							Do While SDC->(!Eof()) .And. SDC->(DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_ORIGEM + DC_PEDIDO + DC_ITEM + DC_SEQ) == cChave
								nCont ++
								lTemSep	:= .T.
		
								RecLock("CB8", .T.)
									CB8->CB8_FILIAL	:= xFilial("CB8")
									CB8->CB8_ORDSEP	:= cOrdSep
									CB8->CB8_ITEM	:= SDC->DC_ITEM //StrZero(nCont, 02)
									CB8->CB8_PEDIDO	:= cPedido
									CB8->CB8_PROD	:= SC9->C9_PRODUTO
									CB8->CB8_LOCAL	:= SC9->C9_LOCAL
									CB8->CB8_QTDORI	:= SDC->DC_QUANT
									CB8->CB8_SALDOS	:= SDC->DC_QUANT
									CB8->CB8_SALDOE	:= SDC->DC_QUANT
									CB8->CB8_LCALIZ	:= SDC->DC_LOCALIZ
									CB8->CB8_SEQUEN	:= SDC->DC_SEQ
									CB8->CB8_LOTECT	:= SDC->DC_LOTECTL
									CB8->CB8_NUMLOT	:= SDC->DC_NUMLOTE
									CB8->CB8_CFLOTE	:= "1"
								CB8->(MsUnLock())
		
								RecLock("CB7", .F.)
									CB7->CB7_NUMITE ++
								CB7->(MsUnLock())
		
								SDC->(DbSkip())
							EndDo
		
							RecLock("SC9", .F.)
								SC9->C9_OK		:= cMarcaATU
								SC9->C9_ORDSEP	:= cOrdSep
							SC9->(MsUnLock())
		
							SC9->(DbSkip())
						EndDo
					endIf
				EndIf
		
				//Neste momento os registros na CB7 e CB8 (cabecalho e itens de ordem de separação) foram gravados
				//imprime o Piklist da ordem de separação para início do processo de separação + conferênica + geracao da NF + envio da NFE e posterior envio para a transportadora (entrega)
				If lTemSep
					dbSelectArea("ZZ1")
					if dbSeek(xFilial("ZZ1")+cPedido)
						RecLock("ZZ1",.F.)
							//ZZ1->ZZ1_EXCLUS := SPACE(13)
							//ZZ1->ZZ1_I_FS01 := SPACE(13)
							//ZZ1->ZZ1_F_FS01 := SPACE(13)
							//ZZ1->ZZ1_I_FS02 := DtoS(Date()) + Time()
							ZZ1->ZZ1_F_FS02 := DtoS(Date()) + Time()
							ZZ1->ZZ1_I_FS03 := DtoS(Date()) + Time()
							ZZ1->ZZ1_F_FS03 := SPACE(13)
							ZZ1->ZZ1_I_FS04 := SPACE(13)
							ZZ1->ZZ1_F_FS04 := SPACE(13)
							ZZ1->ZZ1_I_FS05 := SPACE(13)
							ZZ1->ZZ1_F_FS05 := SPACE(13)
							ZZ1->ZZ1_I_FS06 := SPACE(13)
							ZZ1->ZZ1_F_FS06 := SPACE(13)
						MsUnlock()
					EndIf
					
					SC5-> (recLock("SC5",.F.))
            		SC5-> C5_ZZSTATU := "A" //AGUARDANDO SEPARAÇÃO
            		SC5-> (msUnlock())
					
					U_PL0002(cPedido)
				EndIf
			EndIf
		Else // falta credito
			dbSelectArea("ZZ1")
				if dbSeek(xFilial("ZZ1")+cPedido)
					RecLock("ZZ1",.F.)
					//ZZ1->ZZ1_EXCLUS := SPACE(13)
					//ZZ1->ZZ1_I_FS01 := SPACE(13)
					//ZZ1->ZZ1_F_FS01:= DtoS(Date()) + Time()
					ZZ1->ZZ1_I_FS02 := DtoS(Date()) + Time()
					ZZ1->ZZ1_F_FS02 := SPACE(13)
					ZZ1->ZZ1_I_FS03 := SPACE(13)
					ZZ1->ZZ1_F_FS03 := SPACE(13)
					ZZ1->ZZ1_I_FS04 := SPACE(13)
					ZZ1->ZZ1_F_FS04 := SPACE(13)
					ZZ1->ZZ1_I_FS05 := SPACE(13)
					ZZ1->ZZ1_F_FS05 := SPACE(13)
					ZZ1->ZZ1_I_FS06 := SPACE(13)
					ZZ1->ZZ1_F_FS06 := SPACE(13)
					MsUnlock()
				EndIf
				
				SC5-> (recLock("SC5",.F.))
            	SC5-> C5_ZZSTATU := " " //AGUARDANDO FINANCEIRO
            	SC5-> (msUnlock())

		EndIf
	Else // sem liberaçao de estoque e credito
 	 	dbSelectArea("ZZ1")
	 	If dbSeek(xFilial("ZZ1")+cPedido)
	  		RecLock("ZZ1",.F.)
			
			ZZ1->ZZ1_I_FS01 := DtoS(Date()) + Time()
			ZZ1->ZZ1_F_FS01 := SPACE(13)
			ZZ1->ZZ1_I_FS02 := SPACE(13)
			ZZ1->ZZ1_F_FS02 := SPACE(13)
			ZZ1->ZZ1_I_FS03 := SPACE(13)
			ZZ1->ZZ1_F_FS03 := SPACE(13)
			ZZ1->ZZ1_I_FS04 := SPACE(13)
			ZZ1->ZZ1_F_FS04 := SPACE(13)
			ZZ1->ZZ1_I_FS05 := SPACE(13)
			ZZ1->ZZ1_F_FS05 := SPACE(13)
			ZZ1->ZZ1_I_FS06 := SPACE(13)
			ZZ1->ZZ1_F_FS06 := SPACE(13)
			//ZZ1->ZZ1_EXCLUS := SPACE(13)
			
	  		MsUnlock()
	 	EndIf
		
		SC5-> (recLock("SC5",.F.))
        SC5-> C5_ZZSTATU := " " //AGUARDANDO LIBERAÇÃO DO PEDIDO
        SC5-> (msUnlock())
	EndIf

	RestArea(aAreaCB7)
	RestArea(aAreaSC9)
	RestArea(aAreaSDC)
	RestArea(aAreaATU)
Return

/*/{Protheus.doc}	OrdSepSC2
Rotina responsável por fazer a geração do CB7 / CB8 com dados oriundos do SC2 e SD4.

@author				Paulo Lima
@since				02/12/2021
@return				cOrdSep
/*/
/*/
Static Function OrdSepSC2()
	Local aAreaATU		:= GetArea()
	Local aAreaCB7		:= CB7->(GetArea())
	Local aAreaSD4		:= SD4->(GetArea())
	Local aAreaSDC		:= SDC->(GetArea())
	Local aAreaSC2		:= SC2-> (getARea())
	Local nCont			:= 0
	Local cOrdSep		:= ""
	Local cChave		:= ""
	Local cNumOP		:= "" //SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD
	Local cNumOpAux		:= SC2->C2_NUM
	//Local dDtEmissao	:= SC2->C2_EMISSAO
	//Local cCodProd		:= SC2->C2_PRODUTO
	Local lTemSep		:= .F.
 
	CB7->(DbSetOrder(5))					// CB7_FILIAL + CB7_OP + CB7_LOCAL + CB7_STATUS
	SD4->(DbSetOrder(2))					// D4_FILIAL + D4_OP + D4_COD + D4_LOCAL
	SDC->(DbSetOrder(2))					// DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_OP + DC_TRT + DC_LOTECTL + DC_NUMLOTE + DC_LOCALIZ + DC_NUMSERI

	// Gerar Ordem de Separação para todos os Itens e Sequencias //	
	if SC2-> (dbSeek(xFilial("SC2") + cNumOpAux))
		while SC2-> (!eof()) .AND. SC2-> C2_FILIAL == xFilial("SC2") .AND. SC2-> C2_NUM == cNumOpAux		
			cNumOP := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD
			
			If !CB7->(DbSeek(xFilial("CB7") + cNumOP))
				cOrdSep := CB_SXESXF("CB7", "CB7_ORDSEP",, 1)
				ConfirmSX8()

				ConOut("Gerando Separação (CB7) [ " + cOrdSep + " ] para a OP [ " + cNumOP + " ]")
		
				RecLock("CB7", .T.)
					CB7->CB7_FILIAL		:= xFilial("CB7")
					CB7->CB7_ORDSEP		:= cOrdSep
					CB7->CB7_DTEMIS		:= dDataBase
					CB7->CB7_HREMIS		:= Time()
					CB7->CB7_STATUS		:= "0"
					CB7->CB7_CODOPE		:= ""
					CB7->CB7_PRIORI		:= "1"
					CB7->CB7_ORIGEM		:= "3"
					CB7->CB7_TIPEXP		:= "00*08*09*"
					CB7->CB7_OP			:= cNumOP
				CB7->(MsUnLock())
		
				nCont := 0
		
				// Posiciona no SD4 que para uma mesma OP, pode ter vários SD4.
				SD4->(DbSeek(xFilial("SD4") + cNumOP + Left(SC2->C2_PRODUTO, 09)))
				Do While SD4->(!Eof()) .And. SD4->D4_FILIAL + SD4->D4_OP + AllTrim(SD4->D4_COD) == xFilial("SD4") + cNumOP + Left(SC2->C2_PRODUTO, 09)
					If Left(SD4->D4_COD, 03) != "MOD" .And. SD4->D4_LOCAL != "99"
						// Posiciona no SDC que para cada registro no SD4, pode ter vários registros no SDC.
						cChave := xFilial("SDC") + SD4->D4_COD + SD4->D4_LOCAL + cNumOP + SD4->D4_TRT + SD4->D4_LOTECTL + SD4->D4_NUMLOTE
						SDC->(DbSeek(cChave))
						Do While SDC->(!Eof()) .And. SDC->(DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_OP + DC_TRT + DC_LOTECTL + DC_NUMLOTE) == cChave
							nCont ++
							lTemSep	:= .T.
							ConOut("Gerando Separação (CB8) [ " + cOrdSep + " ] para a OP [ " + cNumOP + " ] item [ " + StrZero(nCont, 02) + " ]")
		
							RecLock("CB8", .T.)
								CB8->CB8_FILIAL		:= xFilial("CB8")
								CB8->CB8_ORDSEP		:= cOrdSep
								CB8->CB8_ITEM		:= StrZero(nCont, 02)
								CB8->CB8_PROD		:= SDC->DC_PRODUTO
								CB8->CB8_LOCAL		:= SDC->DC_LOCAL
								CB8->CB8_QTDORI		:= SDC->DC_QTDORIG
								CB8->CB8_SALDOS		:= SDC->DC_QTDORIG
								CB8->CB8_SALDOE		:= 0
								CB8->CB8_LCALIZ		:= SDC->DC_LOCALIZ
								CB8->CB8_LOTECT		:= SDC->DC_LOTECTL
								CB8->CB8_NUMLOT		:= SDC->DC_NUMLOTE
								CB8->CB8_CFLOTE		:= "1"
								CB8->CB8_OP			:= cNumOP
								CB8->CB8_SLDPRE		:= SDC->DC_QTDORIG
							CB8->(MsUnLock())
		
							RecLock("CB7", .F.)
								CB7->CB7_NUMITE ++
							CB7->(MsUnLock())
							
							SDC->(DbSkip())
						EndDo
					EndIf
		
					SD4->(DbSkip())
				EndDo
			EndIf
			
			RecLock("SC2", .F.)
				SC2->C2_ORDSEP := cOrdSep
			SC2->(MsUnLock())
			
			SC2->(dbSkip())
		endDo
	endIf

	//Neste momento os registros na CB7 e CB8 (cabecalho e itens de ordem de separação) foram gravados
	//imprime o Piklist da ordem de PRODUÇÃO para início do processo de endereçamento
	If lTemSep
		U_PL0001(cNumOP)
		//U_RelOP(Left(cNumOP, 11), dDtEmissao, cCodProd)
	EndIf
	
	RestArea(aAreaSC2)
	RestArea(aAreaCB7)
	RestArea(aAreaSD4)
	RestArea(aAreaSDC)
	RestArea(aAreaATU)
Return
/*/

static function getBloqItens(cPedido)

	local aItens := {}
	local cAlias := getNextAlias()
	local cQuery := ""

	cQuery := " SELECT DISTINCT C9_PEDIDO,C9_ITEM, C9_SEQUEN, C9_PRODUTO " ;
            + " FROM " + retSqlName("SC9") + " SC9 " ;

    cQuery += " WHERE C9_FILIAL      = '" + xFilial("SC9") + "' And " ;
    		+ "		  C9_PEDIDO      = '" + cPedido + "' And (" ;
    		+ "		  C9_BLEST       != ' ' or " ;
            + "       C9_BLCRED      != ' ' ) And " ;
            + "       SC9.D_E_L_E_T_ = ' ' "

	TcQuery cQuery New Alias &cAlias

	do while (cAlias)-> (!Eof())

			aAdd(aItens, {  (cAlias)-> C9_PEDIDO , ;
						    (cAlias)-> C9_ITEM   , ;
						    (cAlias)-> C9_SEQUEN , ;
						    (cAlias)-> C9_PRODUTO  ;
				         })

		(cAlias)-> (dbSkip())
	EndDo

	(cAlias)-> (dbcloseArea())
return (aItens)
