#Include 'Protheus.ch'
#Include 'Topconn.ch'

 /*/{Protheus.doc} ImpPkLis

@author    Paulo Lima
@since    14/12/2021
@return    Nil
/*/
User Function ImpPkLis()
	Local lImprime		:= .F.
	//Local lBloq			:= .F. // produto possui algum item com bloqueio (T = sim, F = não)
	Local cOrdem		:= ""
    Local cPedido		:= ""
    
	dbSelectArea("SC9")
	dbSetOrder(1)
	cPedido := SC9->C9_PEDIDO
		if dbSeek(xFilial("SC9")+M->C5_NUM)
//			if VldSDC()
			lImprime := U_VldBloqP() //T= possuiu algum item bloqueado, F = nenhum item bloqueado
				if !lImprime // não possui item bloqueado
					cOrdem := GeraOSep("M->") // função que gera os registros na tabela CB7 e CB8 baseados na SC5 e SC9
				endif
				While SC9->(!Eof()) .AND. SC9->C9_PEDIDO == M->C5_NUM
				/*	If (!empty(SC9->C9_BLEST) .OR. !empty(SC9->C9_BLCRED)) .AND. empty(SC9->C9_NFISCAL)
						lImprime := .T.
						Exit
					EndIf*/
					RecLock("SC9",.F.)
//						SC9->C9_ZZLOG := Alltrim(UsrRetName(RetCodUsr()))
						if !lImprime
							SC9->C9_ORDSEP := cOrdem
						endif
					MsUnlock()
					SC9->(dbSkip())
				EndDo 
			
//			If lImprime
		//		u_relPedBloq(M->C5_NUM)
//			EndIf
//			If alltrim(funName()) == "MATA410"
				If !lImprime
					//cOrdem := u_fGeraCB7("M->")
					U_PL0002(cPedido)
					//u_relPickList(M->C5_NUM)
				EndIf
			//Else
			//	u_relPickList(M->C5_NUM)
//			EndIf 
//			endif
		EndIf 
	
Return .T.

/*/{Protheus.doc} VldSDC


@author    Lucas Assis Mendes
@since    13/11/2013
@return    Nil
/*/
/*Static Function VldSDC()
	Local cQuery 	:= ""
	Local cAlias	:= GetNextAlias()
	Local lRet	 	:= .F. //Não possui (T = sim, F = não)
	Local nCont	 	:= 0
	Local cPedC9 	:= SC9->C9_PEDIDO
	Local cProdC9 	:= SC9->C9_PRODUTO
	
	cQuery 	:= 	" SELECT * " 											+CRLF
	cQuery  +=  " FROM "+RetSqlName('SDC')+" DC " 						+CRLF
	cQuery	+= 	" WHERE "												+CRLF
	cQuery	+= 	"   DC_FILIAL  = '" + xFilial("SDC") 	+ "'	AND "	+CRLF
	cQuery	+= 	"   DC_PEDIDO  = '" + AllTrim(cPedC9) 	+ "'	AND "	+CRLF
	cQuery 	+= 	"	DC_PRODUTO = '" + AllTrim(cProdC9) 	+ "'	AND "	+CRLF
	cQuery	+= 	" 	DC.D_E_L_E_T_ = ' ' "							 	+CRLF
	
	TcQuery cQuery New Alias cAlias
	
	Count to nCont
	
	if nCont > 0
		lRet := .T.
	endif

Return lRet*/

