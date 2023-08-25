#INCLUDE 'PROTHEUS.CH'

User Function WSteste01

Local cQuery    := ''
Local aListAux3 := {}

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0801")
ENDIF

cAliasTMP := GetNextAlias()
	
    cPriDia := '20220101'
    cUltDia := '20231231'
	cAno1 := year(stod(cPriDia))
    cAno2 := year(stod(cUltDia))

	cQuery := " SELECT   " 
	cQuery += " COALESCE(ROUND(SUM(CASE YEAR(C5_EMISSAO) WHEN "+cvaltochar(cAno2)+" THEN C6_VALOR END),2),0) ANO_ATUAL,"
    cQuery += " COALESCE(ROUND(SUM(CASE YEAR(C5_EMISSAO) WHEN "+cvaltochar(cAno1)+" THEN C6_VALOR END),2),0) ANO_ANTERIOR,"
	cQuery += "   MONTH(C5_EMISSAO) AS ANO " 
	cQuery += "   FROM " + RetSQLName("SC5") + " SC5   " 
	cQuery += "   INNER JOIN " + RetSQLName("SC6") + " SC6 ON C6_FILIAL = C5_FILIAL   " 
	cQuery += " 		 AND C6_NUM = C5_NUM   " 
	cQuery += " 		 AND C6_CLI = C5_CLIENTE   " 
	cQuery += " 		 AND C6_LOJA = C5_LOJACLI   " 
	cQuery += " 		 AND SC6.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SA3") + " SA3 ON A3_FILIAL = ' '   " 
	cQuery += " 		 AND A3_COD = C5_VEND1   " 
	cQuery += " 		 AND SA3.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = ' '   " 
	cQuery += " 		 AND B1_COD = C6_PRODUTO   " 
	cQuery += " 		 AND SB1.D_E_L_E_T_ = ' '   " 
	cQuery += "   INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL = ' '   " 
	cQuery += " 		 AND BM_GRUPO = B1_GRUPO   " 
	cQuery += " 		 AND SBM.D_E_L_E_T_ = ' '   " 
	cQuery += "   WHERE  C5_FILIAL = '"+FWxFilial('SC5')+"'   " 
	cQuery += " 		 AND SC5.D_E_L_E_T_ = ' '   " 
	cQuery += " 		 AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"' "
	cQuery += " GROUP BY MONTH(C5_EMISSAO)  " 
	cQuery += " ORDER BY 3  "

	MPSysOpenQuery(cQuery, cAliasTMP)
	
	nAux := 0

    (cAliasTMP)->(Dbgotop())

	While (cAliasTMP)->(!EoF())
		nAux++
		aAdd(aListAux3 , JsonObject():New() )
		
		aListAux3[nAux]['current_year'] := cAno2
		aListAux3[nAux]['months'] := Array(1)
		
			
        aListAux3[nAux]['months'][1] := JsonObject():New()
        aListAux3[nAux]['months'][1]['name'] := (cAliasTMP)->ANO
        aListAux3[nAux]['months'][1]['value'] := (cAliasTMP)->ANO_ATUAL
		
        nAux++
		aAdd(aListAux3 , JsonObject():New() )
		
		aListAux3[nAux]['last_year'] := cAno1
		aListAux3[nAux]['months'] := Array(1)
		
        aListAux3[nAux]['months'][1] := JsonObject():New()
        aListAux3[nAux]['months'][1]['name'] := (cAliasTMP)->ANO
        aListAux3[nAux]['months'][1]['value'] := (cAliasTMP)->ANO_ANTERIOR
		
		(cAliasTMP)->(DbSkip())
	EndDo

	(cAliasTMP)->(DBCloseArea())

Return 
