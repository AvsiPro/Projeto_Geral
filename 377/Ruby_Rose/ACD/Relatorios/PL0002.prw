#Include "Protheus.ch"
#Include "Topconn.ch"

#define PAD_LEFT 		0
#define PAD_RIGHT 	1
#define PAD_CENTER 	2

/*/{Protheus.doc}	Picki-List
Rotina responsável para imprimir o PickList de Separação.

@author				Paulo Lima
@since				13/12/2021
@return				Nil
/*/

/*/
****************************************************************************************
****************************************************************************************
// Picki-List de Separação de Produtos por Pedido de Venda                           //
****************************************************************************************
****************************************************************************************
/*/
User Function PL0002(cPedInf)
	Local lReg			:= .T.				 	// Verifica a existência de Registros
	Local cTitulo		:= "PICK-LIST"
	Local cNomeSecao	:= "printer_" + GetComputerName()
	Local cNomImpAnt	:= ""
	Local cLocalAnt		:= ""
	Local cOrientAnt	:= ""
	Local cNomeImp		:= AllTrim(SuperGetMv("ZZ_IMPPLPV", .F., "PICKLIST"))
	Local cSubTit		:= "NAO CONTROLADO"
	Local cMens			:= "Não há registros para os parametros informados !!"

	Private lImp		:= .T.
	Private lRep		:= .T.
	Private nPag		:= 1
	Private nLin  	 	:= 9000
	Private oFont1 		:= TFont():New("Arial",09,14,		,.T.,,,,,.F.)
	Private oFont2  	:= TFont():New("Arial",09,09,		,.F.,,,,,.F.)
	Private oFont3  	:= TFont():New("Arial",10,10,.T.	,.T.,,,,,.F.)
	Private oFont4  	:= TFont():New("Arial",12,12,.T.   	,.T.,,,,,.F.)
	Private oFont5  	:= TFont():New("Arial",12,12,.F.   	,.F.,,,,,.F.)
	Private oFont6  	:= TFont():New("Arial",20,20,.F.   	,.F.,,,,,.F.)
	Private oPrint 		:= TMSPrinter():New("Pick-List")
	Private cTexAdv		:= 	AllTrim(SuperGetMv("ZZ_TEXPROB",.F.,""))
	Private lConsu		:= .F.
	Private lICMSST		:= .F.
	
	If AllTrim(FunName()) != "PICKLIST"
		// Salva os conteúdos configurados anteriormente para depois voltar antes de sair da rotina.
		cNomImpAnt	:= GetProfString(cNomeSecao, "default",		cNomeImp)		// Nome da impressora
		cLocalAnt	:= GetProfString(cNomeSecao, "local",		"SERVER")		// Nome da impressora
		cOrientAnt	:= GetProfString(cNomeSecao, "orientation",	"PORTRAIT")		// Nome da impressora

		// Configura as informacões do usuário que ficam armazenadas dentro de um arquivo ".ini" na pasta %Temp%
		//WriteProfString(cNomeSecao, "default",		cNomeImp,	.T.)			// Nome da impressora - Ex. PDFCreator
		//WriteProfString(cNomeSecao, "local",		"SERVER",	.T.)			// Local de impressão	(SERVER / LOCAL)
		//WriteProfString(cNomeSecao, "orientation",	"PORTRAIT",	.T.)			// Orientação			(PORTRAIT / LANDSCAPE)
	EndIf

	Private PixelX 	:= oPrint:nLogPixelX()
	Private PixelY 	:= oPrint:nLogPixelY()

	Private nLinb	:= 4.9
	Private nCol0	:= 40
	Private nCol1	:= 50					// Endereço
	Private nCol2	:= nCol1  + 0420		// CódigoAdmin
	Private nCol3	:= nCol2  + 0080 		// Descrição
	Private nCol4	:= nCol3  + 1350 		// Quantidade
	Private nCol5	:= nCol4  + 0160		// Qtd. Caixas
	Private nCol6	:= nCol3  + 1070		// Lote
	Private nCol7	:= nCol5  + 0231		// Embalagem
	Private nCol8	:= nCol7  + 0085		// UM

/*/
	Private nCol2	:= nCol1  + 0420		// CódigoAdmin
	Private nCol3	:= nCol2  + 0080 		// Descrição
	Private nCol4	:= nCol3  + 1250		// Quantidade
	Private nCol5	:= nCol4  + 0250		// Lote
	Private nCol6	:= nCol5  + 0230		// Embalagem
	Private nCol7	:= nCol6  + 0075		// UM
/*/




	MsgRun("Aguarde...", "Selecionando Registros...", {|| RunRel(@lReg, cTitulo, cMens, cSubTit, cPedInf)})

	If alltrim(FunName()) == "PICKLIST"
		oPrint:Preview()

		If !Empty(AllTrim(cNomImpAnt) + AllTrim(cLocalAnt) + AllTrim(cOrientAnt))
			// Recupera os conteúdos configurados anteriormente.
			//WriteProfString(cNomeSecao, "default",		cNomImpAnt,	.T.)			// Nome da impressora - Ex. PDFCreator
			//WriteProfString(cNomeSecao, "local",		cLocalAnt,	.T.)			// Local de impressão	(SERVER / LOCAL)
			//WriteProfString(cNomeSecao, "orientation",	cOrientAnt,	.T.)			// Orientação			(PORTRAIT / LANDSCAPE)
		EndIf
	Else
		oPrint:Print()
	EndIf
Return

/*/
/////////////////////////////////////////////////////////////////////////////////////
// Seleciona Registros da tabela SC9 - Pedido de Venda e imprime Relatório            //
/////////////////////////////////////////////////////////////////////////////////////
/*/
Static Function RunRel(lRet, cTitulo, cMens, cSubTit, cPedInf)
	Local aAreaATU		:= GetArea()
	Local aAreaSC5		:= SC5->(GetArea())
	Local aControla		:= {}
	Local aImpTxt		:= {}
	Local cMeTmk	 	:= ""
	//Local cTextoTmp		:= ""
	Local cTexto	 	:= ""
	Local nI		 	:= 0
	Local nQtdLin	 	:= 0
	Local nMaxCar	 	:= 110
	Local cAlias	 	:= GetNextAlias()
	Local cPedido		:= CriaVar("C9_PEDIDO")
	Local cOrdSep		:= CriaVar("C9_ORDSEP")
	Local cCompara		:= CriaVar("BE_ZZNIVEL")
	Local cObs			:= CriaVar("C2_OBS")
	Local cTransp		:= CriaVar("A4_NREDUZ")
	Local lNaoContr		:= .F.
	Local lPgtoaVista	:= .F.	
	
	Private cEst		:= ""
	Private cEstado		:= ""
	Private cSegmento	:= ""
	Private cCliente	:= ""

	cQuery	:=	"SELECT "																										+ CRLF
	cQuery	+=	"	SUM(DC_QTSEGUM) DC_QTSEGUM, "																				+ CRLF
	cQuery	+=	"	C9_PEDIDO, C9_LOTECTL, C9_ORDSEP, "																			+ CRLF
	cQuery	+=	"	DC_LOCALIZ, DC_QUANT, DC_PRODUTO, "																					+ CRLF
	cQuery	+=	"	C5_MENNOTA, C5_CONDPAG, SC5.R_E_C_N_O_ SC5RECNO, "															+ CRLF
	cQuery	+=	"	C6_PICMRET, C6_CF, "																						+ CRLF
	cQuery	+=	"	ISNULL(A4_NREDUZ, '') AS A4_NREDUZ,  "																								+ CRLF
	cQuery	+=	"	B1_CONV, B1_UM, B1_DESC, "																					+ CRLF
	cQuery	+=	"	BE_ZZNIVEL, BE_ZZCONTR, BE_ZZDESC, "																		+ CRLF
	cQuery	+= " C5_CLIENTE, C5_LOJACLI, C5_TIPOCLI, C6_PRODUTO, C6_TES, C6_QTDVEN, C6_PRCVEN, C6_VALOR,   "					+ CRLF
	cQuery	+=	" A1_EST, X5_DESCRI,A1_NOME "																							+ CRLF
	cQuery	+=	"FROM "																											+ CRLF
	cQuery	+=	"	"					+ RetSQLName("SC9")	+ " SC9 "															+ CRLF
	cQuery	+=	"	INNER JOIN "		+ RetSqlName("SDC")	+ " SDC ON "														+ CRLF
	cQuery	+=	"		DC_FILIAL = '"	+ xFilial("SDC")	+ "' AND DC_PRODUTO	= C9_PRODUTO AND DC_LOCAL = C9_LOCAL AND "		+ CRLF
	cQuery	+=	"		DC_ITEM = C9_ITEM AND DC_SEQ = C9_SEQUEN AND DC_PEDIDO = C9_PEDIDO AND SDC.D_E_L_E_T_ = ' ' "			+ CRLF
	cQuery	+=	"	INNER JOIN "		+ RetSqlName("SC5")	+ " SC5 ON "														+ CRLF
	cQuery	+=	"		C5_FILIAL = '"	+ xFilial("SC5")	+ "' AND C5_NUM = C9_PEDIDO AND SC5.D_E_L_E_T_ = ' ' "				+ CRLF
	cQuery	+=	"	INNER JOIN "		+ RetSqlName("SC6")	+ " SC6 ON "														+ CRLF
	cQuery	+=	"		C6_FILIAL = '"	+ xFilial("SC6")	+ "' AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND "				+ CRLF
	cQuery	+=	"		C6_PRODUTO = C9_PRODUTO AND C6_NOTA = ' ' AND SC6.D_E_L_E_T_ = ' ' "									+ CRLF
	cQuery	+=	"	LEFT JOIN "		+ RetSqlName("SA4")	+ " SA4 ON "														+ CRLF
	cQuery	+=	"		A4_FILIAL = '"	+ xFilial("SA4")	+ "' AND A4_COD = C5_TRANSP AND SA4.D_E_L_E_T_ = ' ' "				+ CRLF
	cQuery	+=	"	INNER JOIN "		+ RetSqlName("SB1")	+ " SB1 ON "														+ CRLF
	cQuery	+=	"		B1_FILIAL = '"	+ xFilial("SB1")	+ "' AND B1_COD = C9_PRODUTO AND SB1.D_E_L_E_T_	= ' ' "				+ CRLF
	cQuery	+=	"	INNER JOIN "		+ RetSqlName("SBE")	+ " SBE ON "														+ CRLF
	cQuery	+=	"		BE_FILIAL = '"	+ xFilial("SBE")	+ "' AND BE_LOCALIZ = DC_LOCALIZ AND BE_LOCAL = DC_LOCAL AND "		+ CRLF
	cQuery	+=	"		SBE.D_E_L_E_T_ = ' ' "																					+ CRLF
	cQuery +=	"	INNER JOIN "		+ RetSqlName("SA1")	+ " SA1 ON "														+ CRLF
	cQuery	+=	"		A1_FILIAL = '"	+ xFilial("SA1")	+ "' AND A1_COD = C9_CLIENTE AND A1_LOJA = C9_LOJA "				+ CRLF
	cQuery +=	"		AND SA1.D_E_L_E_T_ = ' ' "																				+ CRLF
	cQuery +=	"	LEFT JOIN "		+ RetSqlName("SX5")	+ " SX5 ON "															+ CRLF
	cQuery +=	"		X5_TABELA = '12' AND X5_CHAVE = A1_EST AND SX5.D_E_L_E_T_ = ' ' 		"								+ CRLF
	cQuery	+=	"WHERE "																										+ CRLF
	cQuery	+=	"	C9_FILIAL = '"		+ xFilial("SC9")	+ "' AND "															+ CRLF

	If alltrim(FunName()) == "PICKLIST"
		cQuery	+=	"	C9_PEDIDO = '"		+ mv_par02			+ "' AND "														+ CRLF
	else
		cQuery	+=	"	C9_PEDIDO = '"		+ cPedInf			+ "' AND "														+ CRLF
	endif

	cQuery	+=	"	C9_NFISCAL = ' ' AND "																						+ CRLF
	cQuery	+=	"	C9_LOCAL != '99' AND "																						+ CRLF
	cQuery	+=	"	SC9.D_E_L_E_T_ = ' ' "																						+ CRLF
	cQuery	+=	"GROUP BY C9_PEDIDO, C9_LOTECTL, C9_ORDSEP, "																	+ CRLF
	cQuery	+=	"C6_CF, DC_LOCALIZ, DC_PRODUTO,	DC_QUANT, C6_PICMRET, C6_PRODUTO, C6_TES, C6_QTDVEN, C6_PRCVEN, C6_VALOR, "				+ CRLF
	cQuery	+=	"C5_MENNOTA, C5_CONDPAG, SC5.R_E_C_N_O_ , C5_CLIENTE, C5_LOJACLI, C5_TIPOCLI, "									+ CRLF
	cQuery	+=	"A4_NREDUZ, "																									+ CRLF
	cQuery	+=	"B1_CONV, B1_UM, B1_DESC, "																						+ CRLF
	cQuery	+=	"BE_ZZNIVEL, BE_ZZCONTR, BE_ZZDESC, "																			+ CRLF
	cQuery	+=	"A1_EST, "																										+ CRLF
	cQuery	+=	"X5_DESCRI,A1_NOME "																									+ CRLF
	cQuery 	+= "	      "																										+ CRLF
	cQuery	+=	"ORDER BY "																										+ CRLF
	cQuery	+=	" BE_ZZNIVEL, DC_LOCALIZ, DC_PRODUTO "																			+ CRLF

	//MemoWrite("\PL0002.txt", cQuery)

	TcQuery cQuery New Alias &cAlias

	(cAlias)->(dbGotop())
	ProcRegua( (cAlias)->( LastRec() ) )
	
	MaFisSave()
	MaFisEnd()

	if (cAlias)->(!eof())
		
		cSegmento := " "

		oPrint:SetPortrait()
		
		CalcImp(cAlias)

		nQtdCaixas:= 0
		
		While (cAlias)->(!eof())
			
			BscVlrIpst(cAlias)

			cPedido		:= (cAlias)->C9_PEDIDO
			cOrdSep		:= (cAlias)->C9_ORDSEP
			cObs		:= (cAlias)->C5_MENNOTA
			lPgtoaVista	:= (cAlias)->C5_CONDPAG == "001" //para ver se é alguma condição de pagamento especial do tipo ENTREGA AGORA
			cTransp		:= (cAlias)->A4_NREDUZ
			cEst		:= (cAlias)->A1_EST
			cEstado		:= (cAlias)->X5_DESCRI
			cCliente	:= (cAlias)->A1_NOME
			
			If (cAlias)->C6_CF = '6107' //CONSUMIDOR FINAL para alguma ENTREGA DIFERENCIADA FORA DO ESTADO
				lConsu		:= .T.
			EndIf  
			
			// Pega os dados do campo memo da tabela SC5.
			SC5->(DbGoTo((cAlias)->SC5RECNO))
			cMeTmk := AllTrim(StrTran(SC5->C5_ZZMETMK, CRLF, " "))

			//Grava o STATUS do pedido para "EM SEPARAÇÃO"
			

			IncProc("Processando...")

			cCompara:= (cAlias)->BE_ZZNIVEL

			if (cAlias)->BE_ZZCONTR != "1"   //Não Controlada

				lNaoContr:= .t.

				if nLin >= 2350
					oPrint:EndPage()
					ImpCabec(cPedido,cTitulo,cSubTit,cOrdSep,cCliente)
					nLinb	:= 4.9
				endIf
					
				//Verifica se pode imprimir os itens
				If lImp
					
					cTexto := IIf(Empty(Alltrim((cAlias)->BE_ZZNIVEL	)), "??",						Alltrim((cAlias)->BE_ZZNIVEL	)) + ")"
					cTexto += IIf(Empty(Alltrim((cAlias)->BE_ZZDESC		)), " [ NÍVEL NÃO INFORMADO ]",	Alltrim((cAlias)->BE_ZZDESC		))
					cTexto += Replicate("-", 220)
					oPrint:Say(nLin, nCol0, cTexto													,oFont3)
					nLin += 70
				
				Else
					If	lRep
						oPrint:Say(nLin, nCol0, cTexAdv													,oFont6)
						lRep := .F.
					EndIf
				endIf

				While (cAlias)->(!eof()) .and. (cAlias)->BE_ZZNIVEL == cCompara

					//Verifica se pode imprimir os itens
					If lImp
						if nLin >= 2350
							oPrint:EndPage()
							ImpCabec(cPedido,cTitulo,cSubTit,cOrdSep,cCliente)
							cTexto := IIf(Empty(Alltrim((cAlias)->BE_ZZNIVEL	)), "??",						Alltrim((cAlias)->BE_ZZNIVEL	)) + ")"
							cTexto += IIf(Empty(Alltrim((cAlias)->BE_ZZDESC		)), " [ NÍVEL NÃO INFORMADO ]",	Alltrim((cAlias)->BE_ZZDESC		))
							cTexto += Replicate("-", 220)
							oPrint:Say(nLin, nCol0, cTexto											,oFont3)
							nLin+= 70
							nLinb	:= 4.9
						endIf

						cDescri:= Posicione("SB1", 1, xFilial("SB1") + (cAlias)->DC_PRODUTO, "B1_DESC")

						oPrint:Say(nLin,nCol1  ,Alltrim((cAlias)->DC_LOCALIZ)						,oFont2)
						oPrint:Say(nLin,nCol2  ,AllTrim((cAlias)->DC_PRODUTO)						,oFont2,,,,PAD_RIGHT)
						oPrint:Say(nLin,nCol3  ,Alltrim(cDescri)									,oFont2)
						oPrint:Say(nLin,nCol4  ,Transform((cAlias)->DC_QUANT,   "@E 999,999,999.99"),oFont2,,,,PAD_RIGHT)
						oPrint:Say(nLin,nCol5  ,Transform((cAlias)->DC_QTSEGUM, "@E 999,999,999.99"),oFont2,,,,PAD_RIGHT)
						nQtdCaixas := nQtdCaixas + (cAlias)->DC_QTSEGUM
						oPrint:Say(nLin,nCol6  ,(cAlias)->C9_LOTECTL								,oFont2,,,,PAD_RIGHT)
						oPrint:Say(nLin,nCol7  ,Transform((cAlias)->B1_CONV, "@E 99,999")		,oFont2,,,,PAD_RIGHT)
						oPrint:Say(nLin,nCol8  ,(cAlias)->B1_UM										,oFont2,,,,PAD_RIGHT)

//					MSBAR3("CODE128",nLinb*(300/PixelY),02.1*(299/PixelX),Alltrim((cAlias)->DC_PRODUTO),oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.5,/*lBanner*/,/*cFont*/,"C",.F.)
//					MSBAR3("CODE128",nLinb*(300/PixelY),15.2*(299/PixelX),Alltrim((cAlias)->C9_LOTECTL),oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.5,/*lBanner*/,/*cFont*/,"C",.F.)

						nLinb+= 1.1
						nLin+= 130

					endIf
					(cAlias)->(dbSkip())
				enddo
				nLin+= 20
				nLinb+= 0.8
			else

				aAdd( aControla , {	(cAlias)->BE_ZZNIVEL	,;
					(cAlias)->BE_ZZDESC	,;
					(cAlias)->DC_LOCALIZ	,;
					(cAlias)->DC_QUANT		,;
					(cAlias)->DC_QTSEGUM	,;
					(cAlias)->B1_DESC		,;
					(cAlias)->C9_LOTECTL	,;
					(cAlias)->DC_PRODUTO	,;
					(cAlias)->B1_CONV		,;
					(cAlias)->B1_UM		,;
					cObs					})

				(cAlias)->(dbSkip())
			endif
		enddo
		
		lICMSST := (MaFisRet(, "NF_VALSOL")) > 0

		if lNaoContr
			nLin+= 30
			oPrint:Say(nLin,0020,Replicate("_",200)										,oFont2)
			nLin+= 70
			oPrint:Say(nLin,nCol1  ,"TRANSPORTADORA:  "+Alltrim(cTransp)				,oFont4)
			oPrint:Say(nLin,nCol6  ,"Total Caixas:  "				,oFont4)
			oPrint:Say(nLin,nCol5  ,Transform(nQtdCaixas, "@E 99,999")				,oFont4)
			  
			if len(aControla) > 0
				nLin+= 100
				oPrint:Say(nLin,nCol1  ,"*** CONTEM PRODUTOS CONTROLADOS *** "			,oFont4)
			endif
			nLin+= 100
			// alterado em 31/05/2016 para sair aviso de consumidor final (CFOP 6107)
			if lICMSST .or. lConsu 
				If lICMSST
					oPrint:Say(nLin,0600  ,">>> P E D I D O   E S P E C I A L  (S T) <<<"	,oFont4)
				Else 
					oPrint:Say(nLin,If(lConsu .and. lICMSST, 1500, 0600)  ,">>> C O N S U M I D O R    F I N A L <<<"	,oFont4)
				EndIf
				oPrint:Say(nLin + 0060,0600 , cEst + " - " + cEstado,oFont4)
				nLin+= 70
			endif
			//
			oPrint:Say(nLin,0020,Replicate("_",200)			,oFont2)
			nLin += 20

			If lPgtoaVista
				nLin += 20
				cTexto		:= "ATENÇÃO - VENDA À VISTA, NÃO SEPARAR OS PRODUTOS. FAVOR ENTRAR EM CONTATO COM O DEPARTAMENTO FINANCEIRO." //financeiro verifica se o pagamento já foi efetivado **** proxima fase do projeto **** financeiro troca a condição de pagamento
				oPrint:Say(nLin, nCol0, cTexto, oFont5)
				nLin += 20
			EndIf

			// Primeiro testa se tem conteúdo
			If !Empty(cMeTmk)
				nLin += 20

				cTexto		:= "Informações Complementares: " + cMeTmk
				
				// Verifica quantas linhas serão necessárias para a impressão, quebrando o texto.
				nQtdLin	:= MLCount(cTexto, nMaxCar)

				// Faz a quebra propriamente dita gerando um pequeno array temporário.
				aImpTxt := {}
				For nI := 1 To nQtdLin
					aAdd(aImpTxt, Memoline(cTexto, nMaxCar, nI))
				Next nI

				// Imprime o array temporário que contém os textos com quebras.
				For nI := 1 To Len(aImpTxt)
					nLin += 040
					cTexto		:= aImpTxt[nI]
					oPrint:Say(nLin, nCol0, cTexto, oFont5)
				Next nI
			EndIf

			nLin += 20
			oPrint:Say(nLin,0020,Replicate("_",200)			,oFont2)

			oPrint:EndPage()
		endif
		if Len(aControla) > 0
			RunContr(aControla,cPedido,cTitulo,cSubTit,cTransp,cOrdSep)
		endif
	else
		msgAlert(cMens,"Atenção")
	endif

	RestArea(aAreaSC5)
	RestArea(aAreaATU)
Return

/*/
/////////////////////////////////////////////////////////////////////////////////////
// Impressão do Relatório de Ítens Controlados (Vetor aControla)                      //
/////////////////////////////////////////////////////////////////////////////////////
/*/
Static Function RunContr(aControla,cPedido,cTitulo,cSubTit,cTransp,cOrdSep)

	Local x			:= 0
	Local nTam		:= 1


	nLinb:= 4.8
	nLin:= 9000
	cSubTit:= " CONTROLADO (SUB PEDIDO) "

	aSort(aControla,,,{|x,y|x[1]+x[3]+x[7]<y[1]+y[3]+y[7]})

	For x:= 1 to Len(aControla)

		//cOp		:= aControla[x,10]
		cObs	:= aControla[x,10]

		if nLin >= 2350
			oPrint:EndPage()
			ImpCabec(cPedido,cTitulo,cSubTit,cOrdSep,cCliente)
			nLinb	:= 4.8
		endIf

		cCompara:= aControla[x,01]

		oPrint:Say(nLin,nCol0  ,Alltrim(aControla[x,01])+") "+Alltrim(aControla[x,02])+Replicate("-",220)	,oFont3)
		nLin+= 60

		While nTam <= Len(aControla)

			if aControla[x,01] == cCompara

				if nLin >= 2350
					oPrint:EndPage()
					ImpCabec(cPedido,cTitulo,cSubTit,cOrdSep,cCliente)
					if !Empty(aControla[x,01])
						oPrint:Say(nLin,nCol0  ,Alltrim(aControla[x,01])+") "+Alltrim(aControla[x,02])+Replicate("-",220)	,oFont3)
					endif
					nLin+= 60
					nLinb	:= 4.8
				endIf

				cDescri:= Posicione("SB1", 1, xFilial("SB1") + aControla[x,07], "B1_DESC")

				oPrint:Say(nLin,nCol1  ,Alltrim(aControla[x,03])							,oFont2)
				oPrint:Say(nLin,nCol2  ,aControla[x,07]										,oFont2,,,,PAD_RIGHT)
				oPrint:Say(nLin,nCol3  ,Alltrim(cDescri)									,oFont2)
				oPrint:Say(nLin,nCol4  ,Transform(aControla[x,04], "@E 999,999,999.99")		,oFont2,,,,PAD_RIGHT)
				oPrint:Say(nLin,nCol5  ,aControla[x,06]										,oFont2,,,,PAD_RIGHT)
				oPrint:Say(nLin,nCol6  ,Transform(aControla[x,08]	, "@E 99,999.9999")		,oFont2,,,,PAD_RIGHT)
				oPrint:Say(nLin,nCol7  ,aControla[x,09]										,oFont2,,,,PAD_RIGHT)

//				MSBAR3("CODE128",nLinb*(300/PixelY),02.1*(299/PixelX),Alltrim(aControla[x,07]),oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.5,/*lBanner*/,/*cFont*/,"C",.F.)
//				MSBAR3("CODE128",nLinb*(300/PixelY),15.2*(299/PixelX),Alltrim(aControla[x,06]),oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.5,/*lBanner*/,/*cFont*/,"C",.F.)

				nLinb+= 1.1
				nLin+= 130

				nTam++
				x++
			else
				exit
			endif
		enddo

		nLin+= 60
		oPrint:Say(nLin,0020,Replicate("_",200)			,oFont2)
		nLin+= 70
		oPrint:Say(nLin,nCol1  ,"TRANSPORTADORA:  "+Alltrim(cTransp)	,oFont4)
		nLin+= 100

		if lICMSST .or. lConsu 
			If lICMSST
				oPrint:Say(nLin,0600  ,">>> P E D I D O   E S P E C I A L  (S T) <<<"	,oFont4)
			Else 
				oPrint:Say(nLin,If(lConsu .and. lICMSST, 1500, 0600)  ,">>> C O N S U M I D O R    F I N A L <<<"	,oFont4)
			EndIf
			oPrint:Say(nLin + 0060,0600 , cEst + " - " + cEstado,oFont4)
			nLin+= 70
		endif
		//
		oPrint:Say(nLin,0020,Replicate("_",200)			,oFont2)

		nLinb:= 4.8
		nLin:= 9000  //+= 20
		x:= nTam - 1
	Next x


	oPrint:EndPage()

Return


/*/
//////////////////////////////////////////////////////////////////////////////////////////////
//Impressão do Cabeçalho                                                                       //
//////////////////////////////////////////////////////////////////////////////////////////////
/*/
Static Function ImpCabec(cPedido,cTitulo,cSubTit,cOrdSep,cCliente)

	Local cLogo:= AllTrim(GetMV("ZZ_LOGO"))
	local cData	:= Posicione("CB7", 1, xFilial("CB7") + cPedido, "CB7_DTEMIS")
	local cHora	:= Posicione("CB7", 1, xFilial("CB7") + cPedido, "CB7_HREMIS")

	nLin := 12
	If nPag != 1
		oPrint:EndPage()
	EndIf

	oPrint:StartPage()

/*/
Parâmetros
 ************    SayBitmap         **************
Sintaxe
TMSPrinter(): SayBitmap ( [ nRow], [ nCol], [ cBitmap], [ nWidth], [ nHeight], [ uParam6], [ uParam7] ) -->

Nome	Tipo		Descrição
nRow	Numérico	Indica a coordenada vertical em pixels ou caracteres.	
nCol	Numérico	Indica a coordenada horizontal em pixels ou caracteres.	
cBitmap	Caracter	Indica o diretório e o nome, com extensão BMP (Bitmap), da imagem.	
nWidth	Numérico	Indica a largura em pixels do objeto.	
nHeight	Numérico	Indica a altura em pixels do objeto.	
uParam6	Numérico	Compatibilidade.	
uParam7	Lógico		Compatibilidade.	
/*/

	oPrint:SayBitmap( 0043, 0092,cLogo,(710 * 0.50), (400 * 0.50))
	nLin+=050
	oPrint:Say(nLin,0900, cTitulo+Space(10)+"( "+cSubTit+" )"		,oFont4)
	nLin+=030
	oPrint:Say(nLin,2350,"Página : "+StrZero(nPag,3)				,oFont2,,,,PAD_RIGHT)
	nLin += 050
	oPrint:Say(nLin,2350,"Geração: "+DtoC(cData)+" - "+cValToChar(cHora)+":00"	,oFont2,,,,PAD_RIGHT)
	nLin += 050
	//Danuza - 17/05/2016 - segmento do cliente
	oPrint:Say(nLin,1300,cSegmento	,oFont4,,,,PAD_RIGHT)
	//
	oPrint:Say(nLin,2350,"Emissão: "+DtoC(dDatabase)+" - "+Time()	,oFont2,,,,PAD_RIGHT)
	nLin+= 83
	oPrint:Say(nLin,nCol1, "(Pedido de Venda: "+cPedido+")"		,oFont4)
	oPrint:Say(nLin+67,nCol1, cCliente,oFont2)
	MSBAR3("CODE128",10*(70/PixelY),5.7*(299/PixelX),Alltrim(cPedido),oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.5,/*lBanner*/,/*cFont*/,"C",.F.)
	oPrint:Say(nLin,1550, "(Ordem Separação : "+cOrdSep+")"		,oFont4)
	MSBAR3("CODE128",10*(70/PixelY),18.5*(299/PixelX),Alltrim(cOrdSep),oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.5,/*lBanner*/,/*cFont*/,"C",.F.)
	nLin += 80
	oPrint:Say(nLin,0020,Replicate("_",200)						,oFont2)
	nLin += 060

	oPrint:Say(nLin,nCol1 ,"Endereço"								,oFont3)
	oPrint:Say(nLin,nCol2 ,"Código"									,oFont3,,,,PAD_RIGHT)
	oPrint:Say(nLin,nCol3 ,"Descrição"								,oFont3)
	oPrint:Say(nLin,nCol4 ,"Qtd"									,oFont3,,,,PAD_RIGHT)
	oPrint:Say(nLin,nCol5 ,"Caixas"									,oFont3,,,,PAD_RIGHT)
	oPrint:Say(nLin,nCol6 ,"Lote"									,oFont3,,,,PAD_RIGHT)
	oPrint:Say(nLin,(nCol7+100) ,"Embalagem"								,oFont3,,,,PAD_RIGHT)

	nLin += 50
	oPrint:Say(nLin,0020,Replicate("_",200)						,oFont2)
	nLin += 050

	nPag++

Return

static function CalcImp(cAlias)

	MaFisIni(	(cAlias)->C5_CLIENTE	,;	// 1-Codigo Cliente/Fornecedor
	(cAlias)->C5_LOJACLI	,;	// 2-Loja do Cliente/Fornecedor
	"C"					,;	// 3-C:Cliente , F:Fornecedor
	"N"					,;	// 4-Tipo da NF
	(cAlias)->C5_TIPOCLI ,;	// 5-Tipo do Cliente/Fornecedor
	NIL					,;
		NIL					,;
		NIL					,;
		NIL					,;
		"PICKLIST"			)

Return

static function BscVlrIpst(cAlias)

	MaFisAdd((cAlias)->C6_PRODUTO	,;	// 1-Codigo do Produto ( Obrigatorio )
	(cAlias)->C6_TES					,;	// 2-Codigo do TES ( Opcional )
	(cAlias)->C6_QTDVEN				,;	// 3-Quantidade ( Obrigatorio )
	(cAlias)->C6_PRCVEN				,;	// 4-Preco Unitario ( Obrigatorio )
	0									,;	// 5-Valor do Desconto ( Opcional )
	""									,;	// 6-Numero da NF Original ( Devolucao/Benef )
	""									,;	// 7-Serie da NF Original ( Devolucao/Benef )
	0									,;	// 8-RecNo da NF Original no arq SD1/SD2
	0									,;	// 9-Valor do Frete do Item ( Opcional )
	0									,;	// 10-Valor da Despesa do item ( Opcional )
	0									,;	// 11-Valor do Seguro do item ( Opcional )
	0									,;	// 12-Valor do Frete Autonomo ( Opcional )
	(cAlias)->C6_VALOR 				,;	// 13-Valor da Mercadoria ( Obrigatorio )
	0									)	// 14-Valor da Embalagem ( Opcional )

return
