#Include "topconn.ch"
#INCLUDE "PROTHEUS.CH"

*************************
user function MT100CLA()
*************************

Local aAreaX 	:= GetArea()
Local ctabSE2 	:= GetNextAlias()
Local cQuery	:= ""
Local aAreaSE2 	:= SE2->(GetArea())

cQuery	:= " SELECT SE2.R_E_C_N_O_ AS RECSE2 FROM " + RETSQLNAME("SE2") + " SE2 "
cQuery	+= " WHERE D_E_L_E_T_ = ' ' "
cQuery	+= " AND E2_FILIAL = '"+SF1->F1_FILIAL+"' "
cQuery	+= " AND E2_PREFIXO	= '"+SF1->F1_SERIE+"' " 
cQuery	+= " AND E2_NUM	= '"+SF1->F1_DOC+"' "
cQuery	+= " AND E2_FORNECE	= '"+SF1->F1_FORNECE+"' "
cQuery	+= " AND E2_LOJA = '"+SF1->F1_LOJA+"' "
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),ctabSE2,.T.,.T.)

DBSELECTAREA("SE2")
SE2->(DBSETORDER(1))
While (ctabSE2)->(!EOF())
	SE2->(dbGoTo((cTabSE2)->RECSE2))
	RECLOCK("SE2",.F.)
	SE2->E2_XVLLIQ := SE2->(E2_VALOR-E2_PIS-E2_COFINS-E2_CSLL-E2_IRRF+E2_VRETIRF)
	SE2->(MSUNLOCK())
	(ctabSE2)->(DbSkip())
End
(ctabSE2)->(DbCloseArea())

RestArea(aAreaSE2)
RestArea(aAreax)
	
return
