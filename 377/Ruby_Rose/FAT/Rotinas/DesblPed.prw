#Include 'Protheus.ch'
#Include "Topconn.ch"

/*/{Protheus.doc}	DesblPed
Executado ao ser acionado a opcao de liberacao manual

@author				Paulo Lima
@since				15/12/2021
@return				lRet
/*/
User Function DesblPed()

	Local oPedido		:= LibPedVist():NewLibPedVist()
	Local aAreaATU		:= GetArea()
	Local aAreaSC9		:= SC9->(GetArea())
	Local aAreaSC5		:= SC5->(GetArea())
	Local lRet			:= .T.
	Local cTexto		:= ""
	Local cTitulo		:= ""
	Local cTitle		:= "Pedido Bloqueado !"
	Local cMsgAviso		:= ""
	local cAlias 		:= getNextAlias()
	local cQuery 		:= ""
	Local cPedido		:= SC9->C9_PEDIDO
	
	If oPedido:fExistPed( SC9->C9_PEDIDO, SC9->C9_CLIENTE, SC9->C9_LOJA)
	
		//verifica no pedido se tem algum item sem empenho (liberação do estoque)

				cQuery	:= "SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDEMP "
				cQuery	+= "FROM " + RetSQLName("SC6") + " SC6 "
				cQuery	+= "WHERE"
				cQuery	+= " C6_FILIAL = '" + xFilial("SC6") + "' AND"
				cQuery  += " C6_NUM = '" + cPedido + "'	    AND"
				cQuery	+= " SC6.D_E_L_E_T_ = ' '"
				cQuery	+= " ORDER BY C6_ITEM"
				
				TcQuery cQuery New Alias &cAlias

				Do While !(cAlias)->(Eof())

					If (cAlias)->C6_QTDVEN <> (cAlias)->C6_QTDEMP
						MsgAlert("Não pode ser liberado. Existem itens no Pedido sem liberação de estoque!", "ATENÇÃO")
					 	(cAlias)->(dbCloseArea())	
						Return(.f.)
					Endif
				 
				 (cAlias)->(dbSkip())
				Enddo

				(cAlias)->(dbCloseArea())	

		SC5->(DbSetOrder(1))
	
		If SC5->(DbSeek( xFilial("SC5") + SC9->C9_PEDIDO ))
		
			oPedido:setPedido(SC5->C5_NUM)
			oPedido:setCondPgto(SC5->C5_CONDPAG)
			oPedido:setCliente(SC5->C5_CLIENTE)
			oPedido:setLoja(SC5->C5_LOJACLI)

			//Verifica Condição de Pagamento, bloqueio por crédito e se bloqueio foi personalizado
			If oPedido:fVldBlqCre( oPedido:getCondPgto() ) .and. oPedido:getBloqPer() .and. (SC9->C9_BLCRED == "01" .or. SC9->C9_BLCRED == "09")
				
				cMsgAviso := Upper("O pedido " + AllTrim(oPedido:getPedido()) + " está bloqueado por condição de Pagamento.") + CRLF
				cMsgAviso += " " + CRLF
				cMsgAviso += Upper("Para liberá-lo, clique em 'SIM' ") + CRLF
				cMsgAviso += " " + CRLF
				cMsgAviso += " " + CRLF
				cMsgAviso += " " + CRLF
				cMsgAviso += "***       PEDIDO BLOQUEADO POR CONDIÇÃO DE PAGAMENTO         ***" + CRLF
				cMsgAviso += "*** NÃO PODE SER LIBERADO PELA ROTINA PADRÃO (LIBERAR TODOS) ***"
				
				If MsgYesNo(cMsgAviso,cTitle)
				
					///_SBFPED
				
					While SC9->(!Eof()) .and. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + oPedido:getPedido()
				
						lRet := .F.
					
						//Limpa o Campo de Bloqueio
						RecLock("SC9",.F.)
						SC9->C9_BLCRED 	:= " "
						SC9->C9_ZZBLOQ	:= "LIB"
						MsUnlock()
				
						SC9->(DbSkip())
					
					EndDo

					//Gera Ordem de Separação
					U_GeraOSep("SC5")
				
					If oPedido:fGerOrdSep()
						cTitulo	:= "Ordem de Separação " + oPedido:getOrdSep()
						cTexto		:= "Pedido " + oPedido:getPedido() + " liberado com sucesso !"
					Else
						cTitulo	:= "Erro"
						cTexto		:= "Não foi possível gerar a ordem de separação do pedido " + oPedido:getPedido()
					EndIf
				
					Aviso(cTitulo,cTexto,{"OK"},3)
				
				Else
					lRet := .T.
				endIf
				
			EndIf
	
		EndIf
		
	EndIf
	
	freeobj(oPedido)
	
	RestArea(aAreaSC5)
	RestArea(aAreaSC9)
	RestArea(aAreaATU)
	
Return (lRet)
