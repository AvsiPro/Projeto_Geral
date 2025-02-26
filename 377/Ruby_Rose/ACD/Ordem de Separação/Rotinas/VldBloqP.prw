#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} VldBloqP


@author		Paulo Lima
@since		13/12/2021
@return		lRet	Pedido possui algum item com bloqueio (T = Sim, F = Não)
/*/
User Function VldBloqP()
	Local cQuery	:= ""
	Local lRet		:= .F.
	Local nRegs		:= 0
	Local cPedC9	:= SC9->C9_PEDIDO

	If Select ("QRYC9") > 0
		QRYC9->(dbCloseArea())
	EndIf

	cQuery	:=	"SELECT "
	cQuery	+=	"	1 "
	cQuery	+=	"FROM "
	cQuery	+=	"	" + RetSqlName("SC9") + " SC9 "
	cQuery	+=	"WHERE "
	cQuery	+=	"	C9_FILIAL = '" + xFilial("SC9") + "' AND "
	cQuery	+=	"	C9_PEDIDO = '" + cPedC9 + "' AND "
	cQuery	+=	"	(C9_BLCRED != ' ' OR C9_BLEST != ' ') AND "
	cQuery	+=	"	SC9.D_E_L_E_T_ = ' ' "

	TcQuery cQuery New Alias "QRYC9"

	Count To nRegs

	If nRegs > 0
		lRet := .T.
	EndIf
Return(lRet)
