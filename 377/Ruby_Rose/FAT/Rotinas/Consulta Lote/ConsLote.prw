#Include 'Protheus.ch'
#Include 'TopConn.ch'

#DEFINE LOTE 	1
#DEFINE DVALID 	2
#DEFINE PRCLOTE 3

/**
* Rotina	:   ConsLote
* Autor		:   Paulo Lima
* Data		:   11/02/22
* Descricao	:   Consulta personalizada de LOTES (MATA410) - SIGAFAT
**/

User Function ConsLote(cProd, nValor)

	Local aReturn 	:= {}
	Local cQry		:= ""
	Local lRet		:= .T.
	//Local lSuperv	:= VerPermissao()

	Default cProd := ""
	Default nValor:= 0

	Private lPromo		:= .F.
	Private oConsLote 	:= ConsPrdSel():New()

	Public cConsLote := ""

	oConsLote:SetDlgLeft(105)

	// Query Consulta Padrao
	if !Empty(cProd)
		oConsLote:cQry := QryProd(cProd)
	else
		if AllTrim(FunName()) $ "TMKA271/TMKA380"
			oConsLote:cQry := QryProd(aCols[n,GdFieldPos("C6_PRODUTO")])
		elseif AllTrim(FunName()) == "MATA410"
			// Query da Consulta Padrao
			oConsLote:cQry := QryProd(aCols[n,GdFieldPos("C6_PRODUTO")])
		endIf
	endIf

	oConsLote:cTitulo 		:= " Consulta Padrão - Lotes "
	oConsLote:aListHeader 	:= {"Cod Produto","Num Lote","Qtd Est","Qtd Est 2UM","Preco Lote","Lote Fab.","UM","Validade","Fabricacao","Origem","Empenho","Armazem","Localizacao", "Qtd Total"}
	oConsLote:aVarReturn	:= {"Num Lote","Validade","Preco Lote"}
	oConsLote:cToolTip		:= "Duplo click Seleciona o Item"

	// Apresentação da tela de consulta
	aReturn := oConsLote:Execute()

	// Caso tenha selecionado algum registro
	if Len(aReturn) > 0

		// Caso  Modulo seja CallCenter
		if AllTrim(FunName()) $ "TMKA271/TMKA380"
		
		elseIf AllTrim(FunName()) == "MATA410"

			GdFieldPut("C6_LOTECTL",aReturn[LOTE])
			GdFieldPut("C6_DTVALID",aReturn[DVALID])

		endIf
	else
		lRet := .F.
	endIf

	oConsLote := Nil

Return(lRet)
/**
 * Função:			QryProd
 * Autor:			Paulo Lima
 * Data:			11/02/22
 * Descrição:		Query
 */
Static Function QryProd(cProd)

	Local cQry 		:= ""

	cQry := "SELECT B8_PRODUTO, B8_LOTECTL, "+CRLF
	//cQry += " (B8_SALDO - B8_EMPENHO) AS B8_SALDO, "+CRLF
	//cQry += " (B8_SALDO2 - B8_EMPENH2) AS B8_SALDO2, B8_PRCLOT, B8_LOTEFOR, B1_UM, B8_DTVALID, B8_DFABRIC, B8_ORIGEM, B8_EMPENHO, B8_LOCAL, BF_LOCALIZ "+CRLF
	cQry += "(BF_QUANT - BF_EMPENHO) AS SALDO1, "+CRLF
	cQry += "(BF_QTSEGUM - BF_EMPEN2) AS SALDO2, "+CRLF
	cQry += "B8_PRCLOT, B8_LOTEFOR, B1_UM, CASE WHEN (BF_QUANT - BF_EMPENHO) <= 0 THEN ' ' ELSE B8_DTVALID END B8_DTVALID, B8_DFABRIC, B8_ORIGEM, BF_EMPENHO, B8_LOCAL, BF_LOCALIZ, BF_QUANT "+CRLF
	cQry += "  FROM "+RetSqlName('SB8')+" SB8 "+CRLF
	cQry += "       INNER JOIN "+RetSqlName('SBF')+" SBF "+CRLF
	cQry += "               ON BF_FILIAL = '"+xFilial("SBF")+"' AND BF_PRODUTO = B8_PRODUTO "+CRLF
	cQry += "              AND BF_LOCAL = B8_LOCAL "+CRLF
	cQry += "              AND BF_LOTECTL = B8_LOTECTL "+CRLF
	cQry += "              AND SBF.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "       INNER JOIN "+RetSqlName('SB1')+" SB1 "+CRLF
	cQry += "               ON B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQry += "              AND B8_LOCAL IN "+FormatIn(GetMv("ZZ_ARMVEND"),"/")+" "+CRLF
	cQry += "              AND B1_COD = B8_PRODUTO "+CRLF
	cQry += "              AND SB1.D_E_L_E_T_ <> '*' "+CRLF
	cQry += "WHERE SB8.B8_FILIAL = '" + xFilial('SB8') + "' AND "+CRLF
	if(!Empty(cProd))
    	cQry += " Ltrim(Rtrim(SB8.B8_PRODUTO))  = '" + Alltrim(cProd) + "' AND "+CRLF
	endIf
	//cQry += " B8_SALDO > 0 AND "+CRLF
	cQry += " BF_QUANT > 0 AND "+CRLF
	cQry += " SB8.D_E_L_E_T_ <> '*' " + CRLF
	cQry += "ORDER BY B8_DTVALID ASC, B8_LOTECTL DESC"

Return(cQry)
/**
 * Função:			VerPermissao
 * Autor:			Paulo Lima
 * Data:			21/02/13
 * Descrição:		Verifica a permissão para acesso a lotes com preço promocional
 */
Static Function VerPermissao()

	Local lRet := .T.
/*/
	Local cQuery 	:= ""
    Local cAlSU7VP 	:= GetNextAlias()   
    
    cQuery	:=	"SELECT U7_CODUSU, U7_COD, U7_CODVEN, U7_TIPO "
	cQuery	+=	"FROM SU7010 U7VP "	
	cQuery	+=	"WHERE U7_FILIAL = '0101' and U7_COD = '"+ U_GetUsrLogado() +"' and D_E_L_E_T_ = ' ' "
	
	TcQuery cQuery NEW Alias &cAlSU7VP   
    If !Empty( (cAlSU7VP)->U7_COD )
    	if ((cAlSU7VP)->U7_TIPO == '1')//Operador
			lRet := .F.
		elseif ((cAlSU7VP)->U7_TIPO == '2')//Supervisor
			lRet := .T.
		endIf
    EndIf		
    (cAlSU7VP)->(DBCloseArea())    

/*/
    lRet:= lRet

Return (lRet)
