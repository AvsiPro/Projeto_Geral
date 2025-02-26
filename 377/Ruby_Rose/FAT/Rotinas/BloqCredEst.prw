#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc}	bloqCredEst
Rotina chamada no P.E. M450FLB para bloquear todos os itens do Pedido de Venda caso já existisse um item bloqueado 
pela Rotina Padrão.

@author				Paulo Lima
@since				17/12/2021
@return				Nil
/*/
user function bloqCredEst(cPedido)
	
	local aArea  	:= getArea()
	local aAreaSC9  := SC9->(getArea())
	
	if temItemBloqueado(cPedido)
	
		SC9->(dbSetOrder(1))
		If SC9->(MsSeek(xFilial("SC9")+cPedido))
			Do While SC9->(!Eof()) .And. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + cPedido
				
					SC9->(RecLock("SC9",.F.)) // Bloqueia por Crédito			
						SC9-> C9_BLCRED = '01' // Rejeitado				
					SC9->(MsUnlock())
				
				SC9->(dbSkip())
			endDo
		endIf
	endIf
	
	restArea(aAreaSC9)
	restArea(aArea)
	
return

static function temItemBloqueado(cPedido)
	
	local lRet	 := .F.
	local cAlias := getNextAlias()
	local cQuery := ""
	
	cQuery := " SELECT DISTINCT C9_PEDIDO,C9_ITEM, C9_SEQUEN, C9_PRODUTO " ;
            + " FROM " + retSqlName("SC9") + " SC9 " ;
       
    cQuery += " WHERE C9_FILIAL      = '" + xFilial("SC9") + "' And " ;
    		+ "		  C9_PEDIDO      = '" + cPedido + "' And (" ;
    		+ "		  C9_BLEST       <> ' ' or " ;
            + "       C9_BLCRED      <> ' ' ) And " ;
            + "       SC9.D_E_L_E_T_ = ' ' "
       
	TcQuery cQuery New Alias &cAlias
	
	(cAlias)-> (dbGoTop())
	
	lRet :=  !( (cAlias)-> (Eof()) )
	
	(cAlias)-> (dbcloseArea())

	
	
return (lRet)
