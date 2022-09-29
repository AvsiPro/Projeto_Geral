


/*BEGINDOC
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿯uncoes para manipulacao de dados das maquinas�
//쿕ackson E. de Deus 03/11/2016                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
ENDDOC*/


// Retorna o mapa da maquina
Static Function readMap( cMaquina )

Local cQuery := ""
Local aMapa := {}
Local cAlias := GetNextAlias()
Local cTabPrc := Posicione( "SN1",2,xFilial("SN1") +AvKey(cMaquina,"N1_CHAPA"),"N1_XTABELA" )	// alterar depois para pegar a tabela da tabela correta


cQuery := "SELECT SZH.*, SB1.DESC FROM " +RetSqlName("SZH") +" SZH "
cQuery += " INNER JOIN " +RetSqlName("SB1") + " SB1 ON "
cQuery += " AND B1_COD = ZH_CODPROD "

If !Empty(cTabPrc)
	cQuery += "LEFT JOIN " +RetSqlName("DA1") + " DA1 ON "
	cQuery += "DA1_FILIAL = ZH_FILIAL AND DA1_CODPROD = ZH_CODPROD "
EndIf

cQuery += " WHERE "
cQuery += " ZH_FILIAL = '"+xFilial("SZH")+"' AND ZH_CHAPA = '"+cMaquina+"' AND ZH_STATUS = '3' AND ZH_MSBLQL = '2' AND D_E_L_E_T_ = '' "

If !Empty(cTabPrc)
	cQuery += " AND DA1_CODTAB = '"+cTabPrc+"' "
EndIf

cQuery += " ORDER BY ZH_BANDEJA, ZH_MOLA "

MpSysOpenQuery( cQuery,cAlias )

dbSelectArea(cAlias)
While !EOF()
	AADD( aMapa, { &(cAlias)->ZH_BANDEJA, ;
					&(cAlias)->ZH_MOLA,;
					 &(cAlias)->TIPOMOL,;
					  &(cAlias)->ZH_CODPROD,;
					   &(cAlias)->B1_DESC,;
					    &(cAlias)->ZH_QUANT,;
					     IIF(!Empty(cTabPrc),&(cAlias)->DA1_XPRCPP,0),;
					      IIF(!Empty(cTabPrc),&(cAlias)->DA1_PRCVEN,0)} )
End

(&cAlias)->( dbClosearea() )

Return aMapa
                      

// Inclui um novo mapa
Static Function newMap( cMaquina,aMapa )


Return