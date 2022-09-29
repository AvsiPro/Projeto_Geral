

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM001    บAutor  ณJackson E. de Deus  บ Data ณ  25/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os produtos ativos do Mix                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM001()

Local cTpInsumo := ""
Local aCateg := {}
Local aCat := {}
Local cGrupo := ""
Local cQuery := ""
Local nCount := 0
Local aJson := {}
Local oObj
Local oItem

If cEmpAnt <> "01"
	Return
EndIf

/*
LAYOUT DO ARQUIVO DE TABELA DE PRODUTOS
PRODUTO | DESCRICAO | CODIGO DE BARRAS | TIPO_SERVICO | ORDEM_LISTA | QTD_INSUMO | TIPO_INSUMO
*/

aCateg := { { "copo"		, {"0070","0071","0072"} },;
			{"palheta"		, {"0108"}},;
			{"cafe_grao"	, {"0040"}},;
			{"cafe_soluvel"	, {"0041"}},;
			{"acucar"		, {"0004","0005","0006"}},;
			{"leite"		, {"0096","0097"}},;
			{"chocolate"	, {"0002"}},;
			{"cha"			, {"0052","0053","0054","0055","0056"}}}


cQuery := "SELECT B1_COD, B1_DESC, B1_XSECAO,B1_XSECAOT,B1_XFAMILI, B1_XFAMLIT,B1_GRUPO, B1_XGRUPOT, B1_XTIPMAQ, B1_PESBRU,B1_CODBAR FROM " +RetSqlName("SB1")
cQuery += " WHERE B1_XMIXENT = '1' AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY B1_XSECAO, B1_XFAMILI, B1_GRUPO, B1_DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf      

MpSysOpenQuery( cQuery,"TRB" )
dbSelectArea("TRB") 
While !EOF()

	nCount++
	cTpInsumo := ""
	
	cGrupo := TRB->B1_GRUPO
	For nJ := 1 To Len(aCateg)
		aCat := aclone(aCateg[nJ][2])
		For nK := 1 To Len(aCat)
			If AllTrim(aCat[nK]) == AllTrim(cGrupo)
				cTpInsumo := aCateg[nJ][1]
				Exit
			EndIf
		Next nK
		If !Empty(cTpInsumo)
			Exit
		EndIf
	Next nJ				
		
	If Empty(cTpInsumo)
		cTpInsumo := "X"
	EndIf
	
	oItem := JsonObject():New()
	oItem:PutVal( "codigo", AllTrim(TRB->B1_COD) )
	oItem:PutVal( "desc", AllTrim(TRB->B1_DESC) )
	oItem:PutVal( "codbar", AllTrim(TRB->B1_CODBAR) )
	oItem:PutVal( "tpmaq", Val(TRB->B1_XTIPMAQ) )
	oItem:PutVal( "pos", nCount )
	oItem:PutVal( "peso", TRB->B1_PESBRU )
	oItem:PutVal( "tpinsumo", cTpInsumo )
     
	AADD( aJson,oItem ) 
	
	TRB->(dbSkip())
End

If !Empty(aJson)
	oObj := JsonObject():New()
	oObj:PutVal("produtos",aJson)
	
	cJson := oObj:ToJson()
	
	If Empty(cJson)
		cJSon := "{}"
	EndIf
Else
	cJSon := "{}"
EndIf							 
							 
Return cJson