#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'
#INCLUDE 'APVT100.CH'

Static cMaskTel   := "@R (99) 99999999"                                                    //Máscara de telefone / fax
Static cMaskCNPJ  := "@R 99.999.999/9999-99"                                               //Máscara de CNPJ
Static cMaskCEP   := "@R 99999-999"                                                        //Máscara de CEP

 /*/{Protheus.doc} GerExNS
Geração ou Exclusão da Nota de Saída

@author    Paulo Lima
@since    13/12/2021
@return    Nil
/*/
User Function GerExNS(nOpcao)
	Local cAlias		:= GetNextAlias()
	Local cQuery 		:= ""
	//Local lContinua		:= .T.
	//Local lOpca			:= .T.
	Local cFila
	Local aTela
	//Local nOpc
	Local cNota			:= CriaVar("CB6_NOTA")
	Private cNome		:= CriaVar("A1_NOME")
	Private cEnder		:= CriaVar("A1_END")
	Private cBairro		:= CriaVar("A1_BAIRRO")
	Private cEstado		:= CriaVar("A1_EST")
	Private cCidade		:= CriaVar("A1_MUN")
	Private cCep		:= CriaVar("A1_CEP")
	Private cDdd		:= CriaVar("A1_DDD")
	Private cTel		:= CriaVar("A1_TEL")
	Private cTransp		:= CriaVar("A4_NREDUZ")
	Private cOrdemPal	:= 1 //CriaVar("A4_ZZORDEM")
	Private cTpTransp	:= CriaVar("GUB_DSCLFR")
	Private cEndTransp	:=""

	dbSelectArea("CB1")
	dbSetOrder(2)
	if dbSeek(xFilial("CB1")+__cUserId)
		cFila:= CB1->CB1_ZZFILA
	else
		aTela := VtSave()
		VTCLear()
		VtBeep(3)
		VTALERT("Usuario nao pode utilizar esta rotina","Aviso",.T.,4000,3)
	endif

	dbSelectArea("CB9")
	dbSeek(xFilial("CB9")+cOrdSep)
	cPedido:= CB9->CB9_PEDIDO

	If nOpcao == 1
		geraDadosNF(CB9->CB9_PEDIDO)
	EndIf

	dbSelectArea("SC5")
	DbSetOrder(1)
	dbSeek(xFilial("SC5")+cPedido)
	IF SC5->C5_TRANSP <> ""
		cQuery := "SELECT SC5.C5_NUM, SC5.C5_TRANSP,					   				"+CRLF
	ELSE
		cQuery := "SELECT SC5.C5_NUM,									   				"+CRLF
	ENDIF
	cQuery += "       SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_EST, SA1.A1_MUN, 	"+CRLF
	cQuery += "       SA1.A1_CEP, SA1.A1_DDD, SA1.A1_TEL, 								"+CRLF
	cQuery += "       SA4.A4_NREDUZ,A4_END,A4_BAIRRO,A4_MUN,A4_EST						"+CRLF
	cQuery += "FROM " + RetSQLName("SC5")+ " SC5 "										 +CRLF
	cQuery += "INNER JOIN "+RetSqlName('SA1')+" SA1 "									 +CRLF
	cQuery += "	      ON SA1.A1_FILIAL	= '"+xFilial('SA1')+"' 						AND	"+CRLF
	cQuery += "	         SA1.A1_COD		= SC5.C5_CLIENTE							AND "+CRLF
	cQuery += "	         SA1.A1_LOJA	= SC5.C5_LOJACLI							AND	"+CRLF
	cQuery += "	      SA1.D_E_L_E_T_	= ' ' "											 +CRLF
	cQuery += "LEFT JOIN "+RetSqlName('SA4')+" SA4 "									 +CRLF
	cQuery += "	      ON SA4.A4_FILIAL	= '"+xFilial('SA4')+"' 						AND "+CRLF
	IF SC5->C5_TRANSP <> ""
		cQuery += "	         SA4.A4_COD		= SC5.C5_TRANSP							AND "+CRLF
	ELSE
		cQuery += "	         SA4.A4_COD		= '00001'								AND "+CRLF
	ENDIF
	cQuery += "	      SA4.D_E_L_E_T_	= ' ' "											 +CRLF
	cQuery += "WHERE 																	"+CRLF
	cQuery += "    SC5.C5_FILIAL 	= '" + xFilial("SC5") + "'						AND "+CRLF
	cQuery += "    SC5.C5_NUM		= '" + cPedido + "'								AND "+CRLF
	cQuery += "SC5.D_E_L_E_T_ = ' ' 													"+CRLF

	TcQuery cQuery New Alias &cAlias

	cNome		:= (cAlias)->A1_NOME
	cEnder		:= (cAlias)->A1_END
	cBairro		:= (cAlias)->A1_BAIRRO
	cEstado		:= (cAlias)->A1_EST
	cCidade		:= (cAlias)->A1_MUN
	cCep		:= (cAlias)->A1_CEP
	cDdd		:= (cAlias)->A1_DDD
	cTel		:= (cAlias)->A1_TEL
	cTransp		:= Substr((cAlias)->A4_NREDUZ,1,9)
	cTpTransp	:= "           "//Substr((cAlias)->GUB_DSCLFR,1,11)
	cEndTransp	:= ALLTRIM(A4_END)+ALLTRIM(A4_BAIRRO)+ALLTRIM(A4_MUN)+ALLTRIM(A4_EST)
	cPedido		:= (cAlias)->C5_NUM
	cOrdemPal	:= 1 //(cAlias)->A4_ZZORDEM

	(cAlias)->(dbCloseArea())

	if nOpcao = 2
		fImpEtq(cPedido,cFila,@cNota,nOpcao)
	EndIf

Return

static function geraDadosNF(cPed)
	local aAreaSC5	:= SC5->(getArea())
	local aAreaSF2	:= SF2->(getArea())
	local cAlias 	:= getNextAlias()
	local nPLiqui 	:= 0
	local nPBruto 	:= 0
	local nVolume   := 0
	local nRegSC5   := 0
	local nRegSF2   := 0
	local cEspecie	:= ""
	local cPedido	:= ""
	local cDoc		:= ""
	local cSerie	:= ""

	BeginSql Alias cAlias
		SELECT F2.R_E_C_N_O_ AS REGSF2, C5.R_E_C_N_O_ AS REGSC5, D2_QTSEGUM, D2_QUANT, D2_COD, D2_PEDIDO, D2_DOC, D2_SERIE
		  FROM %TABLE:SD2% D2
		       INNER JOIN %TABLE:SF2% F2
		               ON %XFILIAL:SF2% = F2_FILIAL
		              AND F2_DOC = D2_DOC
		              AND F2_SERIE = D2_SERIE
		              AND F2_CLIENTE = D2_CLIENTE
		              AND F2_LOJA = D2_LOJA
		              AND F2.D_E_L_E_T_ = ' '
		       INNER JOIN %TABLE:SC5% C5
		               ON %XFILIAL:SC5% = C5_FILIAL
		              AND C5_NUM = D2_PEDIDO
		              AND C5.D_E_L_E_T_ = ' '
		 WHERE %XFILIAL:SD2% = D2_FILIAL
		   AND D2_PEDIDO = %EXP:cPed%
		   AND D2.D_E_L_E_T_ = ' '
	EndSql
	(cAlias)->(dbGoTop())
	Do While !(cAlias)->(eof())

			nPLiqui+= (cAlias)->D2_QTSEGUM * Posicione("SB1", 1, xFilial("SB1") + (cAlias)->D2_COD, "B1_PESO")
			nPBruto+= (cAlias)->D2_QUANT * Posicione("SB1", 1, xFilial("SB1") + (cAlias)->D2_COD, "B1_PESBRU")
			nRegSC5:= (cAlias)->REGSC5
			nRegSF2:= (cAlias)->REGSF2
			cPedido:= (cAlias)->D2_PEDIDO
			cDoc	:= (cAlias)->D2_DOC
			cSerie	:= (cAlias)->D2_SERIE

		(cAlias)->(dbSkip())
	endDo

	getEspec(cDoc, cSerie, @cEspecie, @nVolume)

	grvSC5(nPLiqui, nPBruto, nVolume, cEspecie, nRegSC5)
	grvSF2(nPLiqui, nPBruto, nVolume, cEspecie, nRegSF2)
	
	(cAlias)->(dbCloseArea())

	restArea(aAreaSC5)
	restArea(aAreaSF2)
return

static function grvSF2(nPLiqui, nPBruto, nVol, cEspec, nRegSF2)
	SF2->(dbGoto(nRegSF2))
	RecLock("SF2", .F.)
		SF2->F2_PLIQUI	:= nPLiqui
		SF2->F2_PBRUTO  := nPBruto
		SF2->F2_VOLUME1 := nVol
		SF2->F2_ESPECI1 := cEspec
	SF2->(MsUnlock())
return

static function grvSC5(nPLiqui, nPBruto, nVol, cEspec, nRegSC5)
	Local aArea			:= GetArea()
	SC5->(dbGoto(nRegSC5))
	RecLock("SC5", .F.)
		SC5->C5_VOLUME1 := nVol
		SC5->C5_ESPECI1 := cEspec
		SC5->C5_PESOL   := nPLiqui
		SC5->C5_PBRUTO  := nPBruto
		SC5->C5_ZZSTATU := "D" // AGUARDANDO TRANSMISSÃO FATURAMENTO
	SC5->(MsUnlock())

	//grvZZ1
	dbSelectArea("ZZ1")
    if dbSeek(xFilial("ZZ1")+cPedido)
        RecLock("ZZ1",.F.)
            /*/
            ZZ1_FILIAL      := xFilial("ZZ1")
            ZZ1->ZZ1_PEDIDO := cPedido
            ZZ1->ZZ1_I_FS01 := cDataHr
            ZZ1->ZZ1_F_FS01 := SPACE(13)
            ZZ1->ZZ1_I_FS02 := SPACE(13)
            ZZ1->ZZ1_F_FS02 := cDataHr
            ZZ1->ZZ1_I_FS03 := cDataHr
            ZZ1->ZZ1_F_FS03 := SPACE(13)
            ZZ1->ZZ1_I_FS04 := SPACE(13)
            ZZ1->ZZ1_F_FS04 := cDataHr
            ZZ1->ZZ1_I_FS05 := cDataHr
            /*/
            ZZ1->ZZ1_F_FS05 := DtoS(Date()) + Time()
            ZZ1->ZZ1_I_FS06 := DtoS(Date()) + Time()
			ZZ1->ZZ1_F_FS06 := SPACE(13)
			//ZZ1->ZZ1_EXCLUS := cDataHr
        MsUnlock()
    EndIf

	RestArea(aArea)
return

static function getEspec(cDoc, cSerie, cEspec, nVol)
	local cAlias 	:= getNextAlias()

	BeginSql Alias cAlias
		SELECT CB3_DESCRI, count(CB6_VOLUME) CB6_VOLUME
		  FROM %TABLE:CB6% CB6
		       INNER JOIN %TABLE:CB3% CB3
		               ON %XFILIAL:CB3% = CB3_FILIAL
		              AND CB3_CODEMB = CB6_TIPVOL
		              AND CB3.D_E_L_E_T_ = ' '
		 WHERE %XFILIAL:CB6% = CB6_FILIAL
		   AND CB6_NOTA =  %exp:cDoc%
		   AND CB6_SERIE =  %exp:cSerie%
		   AND CB6.D_E_L_E_T_ = ' '
		 GROUP BY CB3_DESCRI
	EndSql
	(cAlias)->(dbGoTop())
	
	if !(cAlias)->(eof())
		cEspec 	:= (cAlias)->CB3_DESCRI
		nVol 		:= (cAlias)->CB6_VOLUME
	endIf

	(cAlias)->(dbCloseArea())
return
/*/
*********************************************************************************************************************
*********************************************************************************************************************
// Função: fImpEtq() - Impressão da Etiqueta de Expedição                                                          //
*********************************************************************************************************************
*********************************************************************************************************************
/*/
Static Function fImpEtq(cPedido,cFila,cNota,nOpcao)
	Local cAlias		:= GetNextAlias()
	Local nQtdVol		:= 0
	Local nQtdIni		:= 1

	Local cEmpresa    := Iif(Empty(SM0->M0_NOMECOM), Alltrim(SM0->M0_NOME), Alltrim(SM0->M0_NOMECOM))
	Local cEmpTel     := Alltrim(Transform(SubStr(SM0->M0_TEL, 3, Len(SM0->M0_TEL)), cMaskTel))
//	Local cEmpFax     := Alltrim(Transform(SubStr(SM0->M0_FAX, 3, Len(SM0->M0_FAX)), cMaskTel))
	Local cEmpCidade  := AllTrim(SM0->M0_CIDENT)+" / "+SM0->M0_ESTENT + " - Brasil"
	Local cEmpEndere  := AllTrim(SM0->M0_ENDENT)
//	Local cEmpBairro  := AllTrim(SM0->M0_BAIRENT)
//	Local cEmpCnpj    := Alltrim(Transform(SM0->M0_CGC, cMaskCNPJ))
	Local cEmpCep     := Alltrim(Transform(SM0->M0_CEPENT, cMaskCEP))


   
	ConOut("GEREXNS ANTES [ " + cFila + " ]")
   
	dbselectArea("CB5")
	if dbSeek(xFilial("CB5")+cFila)
		ConOut("GEREXNS ACHOU A FILA NO CB5 [ " + cFila + " ]")
	else
		ConOut("GEREXNS NAO ACHOU A FILA NO CB5 [ " + cFila + " ]")
	endif
	If !CB5SetImp(cFila)
		VtAlert('Codigo do tipo de impressao invalido. A etiqueta não será impressa.')
		Return .f.
	EndIF
	
	ConOut("GEREXNS DEPOIS [ " + cFila + " ]")

	cQuery := "SELECT CB9.CB9_ORDSEP, CB9.CB9_VOLUME, CB9.CB9_PEDIDO,					"+CRLF
	cQuery += "       CB6.CB6_NOTA					 									"+CRLF
	cQuery += "FROM " + RetSQLName("CB9")+ " CB9 "										 +CRLF
	cQuery += "INNER JOIN "+RetSqlName('CB6')+" CB6 "+CRLF
	cQuery += "	      ON CB6.CB6_FILIAL	= '"+xFilial('CB6')+"' 						AND "+CRLF
	cQuery += "	         CB6.CB6_VOLUME = CB9.CB9_VOLUME							AND "+CRLF
	cQuery += "	      CB6.D_E_L_E_T_	= ' ' 											"+CRLF
	cQuery += "WHERE 																	"+CRLF
	cQuery += "    CB9.CB9_FILIAL 	= '" + xFilial("CB9") + "'						AND "+CRLF
	cQuery += "    CB9.CB9_PEDIDO	= '" + cPedido + "'								AND "+CRLF
	cQuery += "CB9.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "GROUP BY CB9_ORDSEP, CB9_VOLUME, CB9_PEDIDO, CB6_NOTA 					"+CRLF
	cQuery += "ORDER BY CB9_ORDSEP, CB9_VOLUME, CB9_PEDIDO, CB6_NOTA 					"+CRLF
	TcQuery cQuery New Alias &cAlias

	(cAlias)->(dbGotop())

	While !(cAlias)->(Eof())
		nQtdVol++
		(cAlias)->(dbSkip())
	enddo
	MSCBCHKSTATUS(.f.) //OK
	(cAlias)->(dbGotop())
	While !(cAlias)->(Eof())
	
		cNota:= (cAlias)->CB6_NOTA
		
		if nOpcao = 2
			if Empty(cNota)
				(cAlias)->(dbSkip())
				loop
			endif
		endif
   		
		MSCBBEGIN(1,5,97) //OK 
		MSCBWrite("^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ")					
		MSCBWrite("^XA")
		MSCBWrite("^MMT")
		MSCBWrite("^PW1059")
		MSCBWrite("^LL1772")
		MSCBWrite("^LS0")		
		//dados da NELIDA - cabeçalho				
		MSCBWrite("^FT100,715^A0B,30,30^FH\^FD"+cEmpresa+" ^FS")
		//MSCBWrite("^FT130,715^A0B,20,20^FH\^FD"+cEmpEndere+" - "+ cEmpCidade+" - CEP: "+ cEmpCep+" ^FS")
		MSCBWrite("^FT162,715^A0B,32,34^FH\^FD+"+cEmpTel+" ^FS")
		// linha 		
		//MSCBLINEV(27,8,192,4)		
		MSCBWrite("^FO175,040^GB0,680,4^FS")
				
				
		//MSCBWrite("^FT240,700^A0B,25,23^FH\^FDNr Controle ^FS")
		//MSCBWrite("^FT240,800^A0B,25,23^FH\^FD"+cVolume+"^FS")
		
		MSCBWrite("^FT240,350^A0B,33,36^FH\^FDNr Pedido ^FS")
		MSCBWrite("^FT240,170^A0B,33,36^FH\^FD"+cPedido+"^FS")		
		
		MSCBWrite("^FT300,780^A0B,25,23^FH\^FDDest.: ^FS")
		MSCBWrite("^FT300,700^A0B,33,36^FH\^FD"+Alltrim(cNome)+"^FS")
		//MSCBWrite("^FT350,780^A0B,25,23^FH\^FDEnd.: ^FS")
		//MSCBWrite("^FT350,700^A0B,33,36^FH\^FD"+Alltrim(cEnder)+"^FS")		
		//MSCBWrite("^FT390,700^A0B,33,36^FH\^FD"+Alltrim(cBairro)+"^FS")
		MSCBWrite("^FT440,780^A0B,25,23^FH\^FDCidade: ^FS")
		MSCBWrite("^FT440,700^A0B,33,36^FH\^FD"+Alltrim(cCidade)+" / "+Alltrim(cEstado)+"^FS")
		
		MSCBWrite("^FT440,290^A0B,37,38^FH\^FDCEP: "+Substr(cCep,1,5)+"-"+Substr(cCep,6,3)+" ^FS")
		
		//MSCBWrite("^FT490,780^A0B,25,23^FH\^FDFone: ^FS")
		//MSCBWrite("^FT490,700^A0B,33,36^FH\^FD("+cDdd+") "+cTel+" ^FS")
		
		MSCBWrite("^FT550,590^A0B,33,36^FH\^FDNota Fiscal ^FS")
		MSCBWrite("^FT630,590^A0B,52,90^FH\^FD"+cNota+"^FS")
		
		MSCBWrite("^FT580,780^A0B,43,45^FH\^FDVolume ^FS")
		MSCBWrite("^FT630,770^A0B,43,45^FH\^FD"+cValtoChar(nQtdIni)+" de "+cValtoChar(nQtdVol)+"^FS")
		
		MSCBWrite("^FT745,150^A0B,29,29^FH\^FD"+Substr(Time(),1,5)+"^FS")
		MSCBWrite("^FT770,150^A0B,29,29^FH\^FD"+DToc(Date())+"^FS")		
		
		MSCBWrite("^FT720,670^A0B,25,23^FH\^FD"+allTrim(cTpTransp)+"^FS")
		 
		// linhas pallet
		MSCBWrite("^FO700,120^GB110,0,4^FS")
		//MSCBWrite("^FO700,330^GB110,0,4^FS")
		//MSCBWrite("^FO700,690^GB110,0,4^FS")
		//MSCBWrite("^FO700,872^GB110,0,4^FS")		
		//MSCBWrite("^FO700,1150^GB110,0,4^FS")
		
		If cOrdemPal = 1
			MSCBWrite("^FT745,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cEndTransp)+"^FS")
		ElseIf cOrdemPal = 2
			MSCBWrite("^FT745,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cEndTransp)+"^FS")
		ElseIf cOrdemPal = 3
			MSCBWrite("^FT745,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cEndTransp)+"^FS")
		ElseIf cOrdemPal = 4
			MSCBWrite("^FT745,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cEndTransp)+"^FS")
		Else 
			MSCBWrite("^FT745,670^A0B,29,29^FH\^FD"+allTrim(cTransp)+"^FS")
			MSCBWrite("^FT770,670^A0B,29,29^FH\^FD"+allTrim(cEndTransp)+"^FS")
		EndIf
		
		// logotipo Ruby Rose
//		MSCBWrite("^FO32,736^GFA,06656,06656,00016,:Z64:")		
		MSCBWrite("^FO32,720^GFA,02016,02016,00032,:Z64:")		
		     //    ^FO18, 15^GFA,  405, 2016,   32,:Z64:
		
		cTextoLog := "eJytlT2OEzEUgJ81K0yxkrPd0mBRU223BYovgUSDBNyAMsVo4uy2ewhughFCKTdHsMQFXLowfrzn+V00corFidJ88/n9aoJYOw6qmLiD2nkez3UusM7lva/yS/hc5a/SbZVf5U2V39xd13nzssrf3F1W+Zc887d2hceZ6zV/czFxs+Y/kP/r02npf0iL/F4Qf8S89BH9xEv9R8SljxgmfiU27COrevLjxK/htvjuiT/zMr+jN37hx2bmZf5Hp5Z+FDMv+/Po1dJPsCiQ9+/opPsodlo65ekh5tKBPPU3cnzps4j6eyw80seUb2lE77ciaEwykNJCEJgAQ1MaUeI79jHLYPj+2GAWGFUptORvW+IuN+wnEWTYiwDKpSG+tuzbfRO2XD/VY+49KNsNfgccH4xg3krKRx88pd/28SkOBdXWHOKW+2uVVT+pArvtfcqT44M+xJY5tUr9SOSPPFOfyNd28In/RmsWvMTXtiV/j05TA9GZsjdcP9rU+4kqTtxF5TGO/EjP9/FtuyPOXaQKovnzfqjf2CH+NnL91EXlmmgARt/18eHd19I/9kXSA+f5F58KDsyj4o3J/UKP86P4Bl575kk5mnOr7Tz/jv0OeBEjZOq/ha5sVe8HGg0lAdrxfrU8P/69GOJTrkjzT8BKgkzzbzCpqX6SmUdQxe9ofwSWLRp9lekKHjnzfVkuD6PvRZSnnaZ6ZfENdULsaeNPML9/SzHKwr/nyfvnuXzlHfRfea7zJp3hsc5FqPPm25n8Vs55fu7/9xz/Cw/"
		cTextoLog := cTextoLog + "TG8k=:3315"
		MSCBWrite(cTextoLog)
		//
		MSCBWrite("^PQ1,0,1,Y^XZ")
		
		//incrementa volume
		nQtdIni++

		MSCBInfoEti("Primaria","100X200") //OK

		MSCBEND() // OK

		(cAlias)->(dbSkip())
	Enddo
	MSCBCLOSEPRINTER()

	(cAlias)->(dbCloseArea())

	ConOut("GEREXNS ETIQUETA [ " + cFila + " ]")
Return
