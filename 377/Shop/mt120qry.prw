#include 'protheus.ch'
/*/{Protheus.doc} m120qry
//PE usado para filtrar fornecedor PJ
//caso de alteracao ver os fontes: mt120qry, m103filb, mt104fil, mt61fil, mt150fil
@author marcos
@since 14/11/2022
@version 1.0
/*/
User Function mt120qry()
	Local cFiltro := ''
	Local aGrpUsr := FWSFUsrGrps(RetCodUsr())
	Local cGrpPJ := SuperGetMV('SC_GRPVEPJ', .T., '000000')

	If aScan(aGrpUsr, cGrpPJ) == 0 //usuario nao pode ver NF dos PJ
		//filtro expressao SQL
		cFiltro := " (SELECT A2_USER FROM "
		cFiltro += RetSqlName("SA2") + " SA2 "
		cFiltro += " WHERE A2_FILIAL = '" + FWxFilial('SA2') + "'"
		cFiltro += "   AND A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ') IN ('', '" + RetCodUsr() + "')"
	EndIf
	Return(cFiltro)
