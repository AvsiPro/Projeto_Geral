#include 'totvs.ch'

/*/{Protheus.doc}	LibPedVist
Classe de Apoio à Rotina de Controle de Pedido à Vista

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			nil
/*/
CLASS LibPedVist

	Data cPedido		as String
	Data cCondPgto	as String
	Data cCliente		as String
	Data cLoja			as String
	Data cOrdSep		as String

	METHOD NewLibPedVist() CONSTRUCTOR		//Construtor
	
	//Setters
	Method setPedido()						//Configura numero do Pedido
	Method setCondPgto()						//Configura Condição de Pagamento
	Method setCliente()						//Configura Cliente
	Method setLoja()							//Configura Loja
	Method setOrdSep()						//Configura Ordem de Separação
	
	//Getters
	Method getPedido()						//Retorna numero do Pedido
	Method getCondPgto()						//Retorna Condição de Pagamento
	Method getCliente()						//Retorna Cliente
	Method getLoja()							//Retorna Loja
	Method getBloqPer()						//Retorna se Bloqueio for personalizado
	Method getOrdSep()						//Retorna Ordem se Separação
	
	//Metodos Funcionais
	Method fExistPed()						//Verifica se Existe Pedido Liberado
	Method fGetQuery()						//Query do Pedido
	Method fVldBlqCre()						//Valida se condição de Pagamento Bloqueia Credito
	Method fBloqCred()						//Bloqueia o Credito
	Method fGerOrdSep()						//Verifica se Foi gerada Ordem de Separação
	
ENDCLASS

/*/{Protheus.doc}	NewLibPedVist
Metodo Construtor da Classe

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			nil
/*/
METHOD NewLibPedVist() CLASS LibPedVist

	::cPedido		:= ""
	::cCondPgto	:= ""
	::cCliente		:= ""
	::cLoja		:= ""
	::cOrdSep		:= ""

Return

//Setters
Method setPedido(cPedido) Class LibPedVist
	::cPedido		:= cPedido
return

Method setCondPgto(cCondPgto) Class LibPedVist
	::cCondPgto	:= cCondPgto
return

Method setCliente(cCliente) Class LibPedVist
	::cCliente		:= cCliente
return

Method setLoja(cLoja) Class LibPedVist
	::cLoja		:= cLoja
Return

Method setOrdSep(cOrdSep) Class LibPedVist
	::cOrdSep		:= cOrdSep
Return

//Getters
Method getPedido() Class LibPedVist
return (Self:cPedido)

Method getCondPgto() Class LibPedVist
return (Self:cCondPgto)

Method getCliente() Class LibPedVist
return (Self:cCliente)

Method getLoja() Class LibPedVist
return (Self:cLoja)

Method getOrdSep() Class LibPedVist
return (Self:cOrdSep)

/*/{Protheus.doc}	fBloqCred
Bloqueia Pedido

@author			Julio Lisboa
@since				12/05/2014
@version			1.0
@return			lRet
/*/
Method fBloqCred(cPedido) Class LibPedVist

	Local lRet			:= .F.
	Local aAreaATU	:= GetArea()
	Local aAreaSC9	:= SC9->(GetArea())
	Local cAlias		:= ::fGetQuery(cPedido)
	
	If (cAlias)->(!Eof())
		lRet	:= .T.
		(cAlias)->(DbGoTop())
		While (cAlias)->(!Eof()) 
			
			SC9->(DbGoTo( (cAlias)->(NREC)) )
			If Empty(SC9->C9_BLCRED) .and. Empty(SC9->C9_BLEST)
				RecLock("SC9",.F.)
				SC9->C9_BLCRED	:= "01"	
				//SC9->C9_ZZBLOQ	:= "SIM"
				SC9->(MsUnlock())
				Conout("Pedido " + AllTrim(SC9->C9_PEDIDO) + " Bloqueado por personalização")
			EndIf
			
			(cAlias)->(DbSkip())
		EndDo
		
	EndIf
	
	(cAlias)->(DbCloseArea())

	RestArea(aAreaSC9)
	RestArea(aAreaATU)
	
Return lRet

/*/{Protheus.doc}	fGetQuery
Query do SC9

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			lRet
/*/
Method fGetQuery(cPedido) Class LibPedVist

	Local cAliasSC9	:= GetNextAlias()
	Local cNulo		:= " "
	
	beginsql Alias cAliasSC9
		SELECT
			C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9.R_E_C_N_O_ AS NREC
		FROM
			%TABLE:SC9% C9
		WHERE
			C9_FILIAL = %XFILIAL:SC9% AND
			C9_PEDIDO = %exp:cPedido% AND
			C9_BLCRED = %exp:cNulo% AND
			C9.%NOTDEL%
	endsql
	
	If (cAliasSC9)->(!Eof())
		(cAliasSC9)->(DbGoTop())
	EndIf

Return (cAliasSC9)

/*/{Protheus.doc}	fExistPed
Verifica Existencia do pedido no SC9

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			lRet
/*/
Method fExistPed(cPedido, cCliente, cLoja) Class LibPedVist

	Local lRet 	:= .F.
	Local cAlias	:= GetNextAlias()
	
	beginsql Alias cAlias
		SELECT
			C9_PEDIDO, C9_CLIENTE, C9_LOJA
		FROM
			%TABLE:SC9% C9
		WHERE
			C9_FILIAL = %XFILIAL:SC9% AND
			C9_CLIENTE = %exp:cCliente% AND
			C9_LOJA = %exp:cLoja% AND
			C9_PEDIDO = %exp:cPedido% AND
			C9.%NOTDEL%
	endsql
	
	If (cAlias)->(!Eof())
		lRet	:= .T.
	EndIf
	
	(cAlias)->(DbCloseArea())
	
Return lRet

/*/{Protheus.doc}	fVldBlqCre
Valida se a Condição de Pgto bloqueia Credito

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			lRet
/*/
Method fVldBlqCre(cCondPgto) Class LibPedVist

	Local lRet		:= .F.
	Local cAlias	:= GetNextAlias()
	
	beginsql Alias cAlias
		SELECT E4_ZZBLQCR 
		  FROM %TABLE:SE4% E4
		 WHERE %XFILIAL:SE4% = E4_FILIAL
		   AND E4_CODIGO = %exp:cCondPgto%
		   AND E4_ZZBLQCR = 'S'
		   AND E4.%NOTDEL%
	endsql
	
	(cAlias)->(DbGoTop())
	
	If (cAlias)->(!Eof())
		lRet	:= .T.
	EndIf
	
	(cAlias)->(DbCloseArea())

Return lRet

/*/{Protheus.doc}	getBloqPer
Retorna Verdadeiro se bloqueio for personalizado

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			lRet
/*/
Method getBloqPer() Class LibPedVist

	Local lRet			:= .F.
	Local aAreaATU	:= GetArea()
	Local aAreaSC9	:= SC9->(GetArea())
	
	SC9->(DbSetOrder(1))
	
	If SC9->(DbSeek( xFilial("SC9") + Self:cPedido ))
		
		If AllTrim(SC9->C9_ZZBLOQ) == "SIM"
			lRet := .T.
		EndIf
		
	EndIf
	
	RestArea(aAreaSC9)
	RestArea(aAreaATU)

Return lRet

/*/{Protheus.doc}	fGerOrdSep
Retorna Verdadeiro se Foi gerada Ordem de Separação

@author			Paulo Lima
@since			15/12/2021
@version		1.0
@return			lRet
/*/
Method fGerOrdSep() Class LibPedVist
	
	Local lRet 		:= .F.
	Local aAreaATU	:= GetArea()
	Local aAreaCB7	:= CB7->(GetArea())
	Local aAreaCB8	:= CB8->(GetArea())
	Local cOrdSep		:= ""
	
	//FILIAL + PEDIDO + LOCAL + STATUS + CLIENTE + LOJA
	CB7->(DbSetOrder(2))
	
	If CB7->(DbSeek( xFilial("CB7") + Self:cPedido ))
		
		cOrdSep := CB7->CB7_ORDSEP
		
		//FILIAL + ORDSEP + ITEM + SEQUENCIA + PRODUTO
		CB8->(DbSetOrder(1))
		
		If CB8->(DbSeek( xFilial("CB8") + cOrdSep))
			
			lRet := .T.
			
			//Seta Ordem de Separação
			::setOrdSep(cOrdSep)
			
		EndIf
		
	EndIf
	
	RestArea(aAreaCB8)	
	RestArea(aAreaCB7)	
	RestArea(aAreaATU)	
	
Return (lRet)
