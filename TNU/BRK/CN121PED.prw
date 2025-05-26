#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

user function CN121PED()
	
Local ExpA1 := PARAMIXB[1]
Local ExpA2 := PARAMIXB[2]
Local Nx    
Local aArea    := GetArea()
Local aAreaCNE := GetArea('CNE')
Local cTabPrc  := ""
Local cProduto := ""
Local nQuant   := ""

If CN9->CN9_ESPCTR == '2'
	
	AADD(ExpA1,{"C5_MENNOTA",CND->CND_XPERIO,NIL})
	AADD(ExpA1,{"C5_XVLRMED",CND->CND_VLTOT,NIL})
	If !Empty(Alltrim(SA1->A1_XFORISS))
		AADD(ExpA1,{"C5_FORNISS",SA1->A1_XFORISS,NIL})
		AADD(ExpA1,{"C5_MUNPRES",SA1->A1_XMUPRES,NIL})
		AADD(ExpA1,{"C5_DESCMUN",SA1->A1_XDESMUN,NIL})
		AADD(ExpA1,{"C5_ESTPRES",SA1->A1_XUFPRES,NIL})
	EndIf	

	For Nx := 1 to Len(ExpA2)

		_cQuery := " SELECT CNE_TABPRC, CNE_PRODUT, CNE_QUANT FROM "+RETSQLNAME("CNE")+" "
		_cQuery += " WHERE D_E_L_E_T_ = '' AND CNE_FILIAL = '"+xFilial("CNE")+"' AND CNE_CONTRA = '"+CND_CONTRA+"' AND CNE_REVISA = '"+CND_REVISA+"' "
		_cQuery += " AND CNE_NUMMED = '"+CND_NUMMED+"' AND CNE_ITEM = '"+ExpA2[nX][14][2]+"' "
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)

		cTabPrc  := QUERY->CNE_TABPRC
		cProduto := QUERY->CNE_PRODUT
		nQuant   := QUERY->CNE_QUANT 

		QUERY->(DBCLOSEAREA())

		If !Empty(cTabPrc)

			_cQuery := " SELECT DA1_CODTAB, DA1_CODPRO, DA1_PRCVEN,DA1_QTDLOT FROM "+RETSQLNAME("DA1")+" "
			_cQuery += " WHERE D_E_L_E_T_ = '' AND DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1_CODTAB = '"+cTabPrc+"' "
			_cQuery += " AND DA1_CODPRO = '"+cProduto+"' AND DA1_QTDLOT >= '"+str(nQuant)+"' "

			dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)

			ExpA2[nX][6][2] := QUERY->DA1_PRCVEN //PRUNIT
			ExpA2[nX][7][2] := QUERY->DA1_PRCVEN //PRCVEN

			QUERY->(DBCLOSEAREA())
		

		EndIf

	Next Nx

	
ENDIF

RestArea(aArea)
RestArea(aAreaCNE)


Return {ExpA1,ExpA2}
