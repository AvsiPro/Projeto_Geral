
#INCLUDE "FINR550.CH"                          
#INCLUDE "PROTHEUS.CH" 

#TRANSLATE INSIDE(<cTp>)  ;
	=> If(mv_par11 != 1, .T.,<cTp> $ cTipos)

#DEFINE S1_DAT			1
#DEFINE S1_HISTORICO	2
#DEFINE S1_TITULO		3
#DEFINE S1_EMISSAO		4
#DEFINE S1_VENCIMENTO	5
#DEFINE S1_BAIXA		6
#DEFINE S1_DEBITO		7
#DEFINE S1_CREDITO		8
#DEFINE S1_SALDO_ATU	9
#DEFINE S1_DIGITO		10

#DEFINE S2_DESCRICAO	1
#DEFINE S2_SD_ANTERIOR	2
#DEFINE S2_DIG1			3
#DEFINE S2_DEB			4
#DEFINE S2_CRED			5
#DEFINE S2_SD_ATUAL		6
#DEFINE S2_DIG2			7 

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTFINR550() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATORIO DE CLIENTES/FORNECEDOR							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO	                                        	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTFINR550() // Funcao antiga FINR550()

	Local oReport
	Private cAuxFoot := ""
	Private lImprime
	Private nSaldoAtu := 0
	
	If FindFunction("TRepInUse") .And. TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	Endif

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF	 ¦ Autor ¦ FABIO SALES		    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ DEFINICAO DO LAYOUT DO RELATORIO							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO	                                        	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport  
	Local oSection1
	Local oSection2
	Local nTamTit
	
	oReport := TReport():New("TTFINR550",STR0007,"FIN550", {|oReport| ReportPrint(oReport)},STR0001+STR0002+STR0003) //"RAZONETE DE CONTAS CORRENTES DE "
	
	pergunte("FIN550",.F.)
	
	/*-----------------------------------------------------------|
	| 			Variaveis utilizadas para parametros			 |
	|____________________________________________________________|
	 mv_par01            -> A partir de                          |
	 mv_par02            -> Ate a data                           |
	 mv_par03            -> Carteira (Receber ou Pagar)          |
	 mv_par04            -> Do Codigo                            |
	 mv_par05            -> Ate o Codigo                         |
	 mv_par06            -> Imprime Valores Financeiros (Sim/Nao)|
	 mv_par07            -> Impime (Todos,Normais,Adiantamentos) |
	 mv_par08            -> Do Prefixo                           |
	 mv_par09            -> Ate o Prefixo                        |
	 mv_par10            -> Lista Por 1 - Filial     2 -Empresa  |
	 mv_par11            -> Seleciona Tipos                      |
	 mv_par12            -> Natureza de  ?                       |
	 mv_par13            -> Natureza ate ?                       |
	 mv_par14            -> Anal¡tico/Sint‚tico                  |
	 mv_par15            -> Filtra Prefixo para Saldo Anterior   |
	 mv_par16            -> Folha De ?                           |
	 mv_par17            -> Folha Ate ?                          |
	 mv_par18            -> Filtra Contas Contabeis              |
	 mv_par19            -> Conta Inicial                        |
	 mv_par20            -> Conta Final                          |
	 mv_par21            -> Impr. Saldo Contabil                 |
	 mv_par22            -> Impr. Cli/Forn s/ Movim.?            |
	 mv_par23  			 -> Linhas por Página ?                  |
	 mv_par24            -> Historico                            |
	-------------------------------------------------------------*/
	
	oReport:SetPortrait(.T.)
	
	nTamTit	:= TamSX3("E1_PREFIXO")[1] + TamSX3("E1_NUM")[1] + TamSX3("E1_PARCELA")[1] + 3
	
	oSection1 := TRSection():New(oReport,STR0068,{"cNomeArq"},) 			//"ANALITICO"
	
	TRCell():New(oSection1,"DESCRICAO"	,		,"COD_FORCLI-->LOJA",,46	,.F.,) //"CLIENTE"/"FORNECEDOR"
	TRCell():New(oSection1,"E1_VENCTO"	,"SE1"	,STR0056,,			,.F.,) 	//"DATA"
	TRCell():New(oSection1,"E1_HIST"	,"SE1"	,STR0057,,20		,.F.,) 	//"HISTORICO"
	TRCell():New(oSection1,"TITULO"		,		,STR0058,,nTamTit	,.F.,)  //"PRF NUMERO PC"
	TRCell():New(oSection1,"E1_EMISSAO"	,"SE1"	,STR0059,,			,.F.,) 	//"EMISSAO"
	TRCell():New(oSection1,"E1_VENCREA"	,"SE1"	,STR0060,,			,.F.,) 	//"VENCTO"
	TRCell():New(oSection1,"E2_DTFATUR"	,"SE2"	,STR0061,,			,.F.,) 	//"BAIXA"
	TRCell():New(oSection1,"E1_VLCRUZ"	,"SE1"	,STR0062,,			,.F.,) 	//"DEBITO"
	TRCell():New(oSection1,"E2_VLCRUZ"	,"SE2"	,STR0063,,			,.F.,) 	//"CREDITO"
	TRCell():New(oSection1,"E1_SALDO"	,"SE1"	,STR0064,,			,.F.,) 	//"SALDO ATUAL"
	TRCell():New(oSection1,"DIGITO"		,		,"DC"	,,1			,.F.,) 
	oSection1:AutoSize()
	
	oSection2 := TRSection():New( oReport,STR0069, {"cNomeArq"},) //SINTETICO"
	
	TRCell():New(oSection2,"DESCRICAO"	,		,		,,46	,.F.,) //"CLIENTE"/"FORNECEDOR"
	TRCell():New(oSection2,"E2_SALDO"	,"SE2"	,STR0067,,		,.F.,) //"SALDO ANTERIOR"
	TRCell():New(oSection2,"DIGITO1"	,,"DC1"	,		,1		,.F.,) 
	TRCell():New(oSection2,"E1_VLCRUZ"	,"SE1"	,STR0062,,		,.F.,) //"DEBITO"
	TRCell():New(oSection2,"E2_VLCRUZ"	,"SE2"	,STR0063,,		,.F.,) //"CREDITO"
	TRCell():New(oSection2,"E1_SALDO"	,"SE1"	,STR0064,,		,.F.,) //"SALDO ATUAL"
	TRCell():New(oSection2,"DIGITO2"	,,"DC2"	,,1,.F.,)
	oSection2:AutoSize() 

Return oReport 

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport ¦ Autor ¦ FABIO SALES		    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦CRIADA PARA TODOS OS RELATORIOS QUE PODERAO SER AGENDADOS   ¦¦¦
¦¦¦			 ¦PELO USUARIO												  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO	                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                             

Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	
	Local aSec1[11]
	Local aSec2[7]
	Local cTexto
	LOCAL cString:="SE1"
	Local cTitulo
	LOCAL CbCont,CbTxt
	LOCAL nQuebra:=0,lImprAnt := .F.
	LOCAL cNome,nTotDeb:=0,nTotCrd:=0,nTotDebG:=0,nTotCrdG:=0,nSalAtuG:=0,nSalAntG:=0
	LOCAL dEmissao:=CTOD(""),dVencto:=CTOD("")
	LOCAL nRec,nPrim,cPrefixo,cNumero,cParcela,cTipo,cNaturez,nValliq
	LOCAL nAnterior:=0,cAnterior,cFornece,dDtDigit,cRecPag,cSeq
	LOCAL cCodigo, cLoja
	LOCAL lNoSkip := .T.
	LOCAL lFlag := .F.
	LOCAL nSaldoFinal:=0
	LOCAL aCampos:={},aTam:={}
	LOCAL aInd:={}
	LOCAL cCondE1:=cCondE2:=cCondE5:=" "
	LOCAL cIndE1 :=cIndE2 :=cIndE5 :=cIndA1 :=cIndA2 :=" "
	LOCAL nRegAtu
	Local bBlockDC := {| nNum | if(int(nNum*100)=0," ",if(nNum>0,"C","D")) }
	Local nX := 0
	
	Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
					 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
					 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
					 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
	#IFDEF TOP
		Local aStru 	:= {}
	#ELSE
		Local nRec1
	#ENDIF	
	Local aSdoContabil
	Local nTamNro	:= TamSx3("E1_NUM")[1]
	Local nTamParc := TamSx3("E1_PARCELA")[1]
	Local nTamTitulo := TamSx3("E1_PREFIXO")[1] + nTamNro + nTamParc + 3
	Local nI
	Local aDados := Array(If(lPccBaixa,17,11))
	Local aImp10925:= {}
	Local aDadosAbat:= {}
	Local nLinReport := 8
	Local nLinPag	 := 0
	Local nSaldoTra  := 0
	
	If !Empty(mv_par23)
		nLinPag := IIf(MV_PAR23>=70,70,MV_PAR23)
	Else
		nLinPag := 70	
	EndIf		
	
	
	
	lImprime := .F.
	
	cTipos := ""
	
	oSection1:Cell("DESCRICAO"):SetBlock( { || aSec2[S2_DESCRICAO] })
	oSection1:Cell("E1_VENCTO"):SetBlock( { || aSec1[S1_DAT] })
	oSection1:Cell("E1_HIST"):SetBlock( { || aSec1[S1_HISTORICO] })
	oSection1:Cell("TITULO"):SetBlock( { || aSec1[S1_TITULO] })
	oSection1:Cell("E1_EMISSAO"):SetBlock( { || aSec1[S1_EMISSAO] })
	oSection1:Cell("E1_VENCREA"):SetBlock( { || aSec1[S1_VENCIMENTO] })
	oSection1:Cell("E2_DTFATUR"):SetBlock( { || aSec1[S1_BAIXA] })
	oSection1:Cell("E1_VLCRUZ"):SetBlock( { || aSec1[S1_DEBITO] })
	oSection1:Cell("E2_VLCRUZ"):SetBlock( { || aSec1[S1_CREDITO] })
	oSection1:Cell("E1_SALDO"):SetBlock( { || aSec1[S1_SALDO_ATU] })
	oSection1:Cell("DIGITO"):SetBlock( { || aSec1[S1_DIGITO] })
	oSection1:Cell("DIGITO"):HideHeader()
	
	oSection2:Cell("DESCRICAO"):SetBlock( { || aSec2[S2_DESCRICAO] })
	oSection2:Cell("DESCRICAO"):SetTitle(If(mv_par03==1,STR0008,STR0009))
	oSection2:Cell("E2_SALDO"):SetBlock( { || aSec2[S2_SD_ANTERIOR] })
	oSection2:Cell("DIGITO1"):SetBlock( { || aSec2[S2_DIG1] })
	oSection2:Cell("DIGITO1"):HideHeader()
	oSection2:Cell("E1_VLCRUZ"):SetBlock( { || aSec2[S2_DEB] })
	oSection2:Cell("E2_VLCRUZ"):SetBlock( { || aSec2[S2_CRED] })
	oSection2:Cell("E1_SALDO"):SetBlock( { || aSec2[S2_SD_ATUAL] })
	oSection2:Cell("DIGITO2"):SetBlock( { || aSec2[S2_DIG2] })
	oSection2:Cell("DIGITO2"):HideHeader()
	                                                                           
	If mv_par14 == 1  // Analitico
		oSection1:SetHeaderPage()
		oSection2:SetHeaderSection(.F.)
		oSection1:OnPrintLine({|| F550LinPag(nLinPag,@nLinReport,oReport,@nSaldoTra)}) 
	Else
		oSection1:SetHeaderSection(.F.)
		oSection2:OnPrintLine({|| F550LinPag(nLinPag,@nLinReport,oReport,@nSaldoTra)})
	EndIf
	
	//impressao do numero de pagina conforme pergunta 16 e 17
	
	oReport:SetPageNumber(MV_PAR16)
	oReport:OnPageBreak({||	If ( oReport:Page() > MV_PAR17, oReport:SetPageNumber(2), "") })
	
	oReport:SetPageFooter( 5 , {|| IIF((lImprime .Or. (nSaldoAtu != 0)),;
										F550RODAPE(oReport,nSaldoTra,Eval(bBlockDC,nSaldoTra),aSec1), nil) } )
	
	/*---------------------------------------------------------------|
	| Ponto de entrada para Filtrar os tipos sem entrar na tela do   |
	| FINRTIPOS(), localizacao Argentina.                          	 |
	|---------------------------------------------------------------*/
	
	IF cPaisLoc <> "BRA"
		IF EXISTBLOCK("FARGTIP")
			cTipos	:=	EXECBLOCK("FARGTIP")
		ENDIF
	ENDIF		
	
	/*------------------------------------------------------------------------|
	| Alimenta vetor com os impostos que devem gerar movimentos de historico  |
	|------------------------------------------------------------------------*/
	
	aadd(aImp10925,{"SE2->E2_VRETPIS","Pis"})
	aadd(aImp10925,{"SE2->E2_VRETCOF","Cofins"})
	aadd(aImp10925,{"SE2->E2_VRETCSL","Csll"})
	
	/*------------------------------------------------------------------|
	| Referencia para imprimir descricao dos tipos de cliente A1_TIPO   |
	|------------------------------------------------------------------*/
	
	If cPaisLoc != "BRA"
		SX3->(dbSetOrder(2))
		SX3->(dbSeek("A1_TIPO"))
		If SX3->(Found())
			cTipoCli := AllTrim(SX3->(X3CBox()) )
			cTipoCli := '{"'+StrTran(cTipoCli,';','","')+'"}'
			aTipoCli := &(cTipoCli)
		Else            
			cTipoCli := ""
			aTipoCli := {}
		EndIf
	EndIf
		
	/*--------------------------------|
	|   Verifica se seleciona tipos   |
	|--------------------------------*/ 
	
	If mv_par11 == 1
		finRTipos()
	Endif
	
	/*---------------------------------------------------------------|
	|   For‡a ser por filial quando exista somente 1 filial,indepen- |
	|   dente da resposta                                            |
	|---------------------------------------------------------------*/ 
	
	mv_par10 := If(SM0->(Reccount())==1,1,mv_par10) // Lista Por 1 - Filial     2 -Empresa
	
	/*-----------------------------|
	|   Definicao dos cabecalhos   |                                  
	|-----------------------------*/
	
	cTitulo := oReport:Title() + " " + If(mv_par03==1,STR0008,STR0009)  //"RAZONETE DE CONTAS CORRENTES DE "###"CLIENTES"###"FORNECEDORES"
	oReport:SetTitle(cTitulo)
	
	/*---------------------------|
	|  Gera arquivo de Trabalho  |             
	|---------------------------*/ 
	
	aTam:=TamSX3("E1_CLIENTE")
	AADD(aCampos,{"CODIGO" ,"C",aTam[1],aTam[2]})
	aTam:=TamSX3("E1_LOJA")
	AADD(aCampos,{"LOJA"   ,"C",aTam[1],aTam[2]})
	aTam:=TamSX3("E1_EMISSAO")
	AADD(aCampos,{"DATAEM"   ,"D",aTam[1],aTam[2]})
	AADD(aCampos,{"NUMERO" ,"C",nTamTitulo,0})
	aTam:=TamSX3("E1_TIPO")
	AADD(aCampos,{"TIPO"   ,"C",aTam[1],aTam[2]})
	aTam:=TamSX3("E1_PORTADO")
	AADD(aCampos,{"BANCO"  ,"C",aTam[1],aTam[2]})
	aTam:=TamSX3("E1_EMISSAO")
	AADD(aCampos,{"EMISSAO","D",aTam[1],aTam[2]})
	AADD(aCampos,{"BAIXA"  ,"D",aTam[1],aTam[2]})
	aTam:=TamSX3("E1_VENCREA")
	AADD(aCampos,{"VENCTO" ,"D",aTam[1],aTam[2]})
	AADD(aCampos,{"VALOR"  ,"N",18,2})
	AADD(aCampos,{"HISTOR" ,"C",40,0})
	AADD(aCampos,{"DC"     ,"C", 1,0})
	AADD(aCampos,{"MOEDA"  ,"N", TamSX3("E1_MOEDA")[1],0}) // Utilizada para saldo contabil
	cNomeArq:=CriaTrab(aCampos)
	dbUseArea( .T., __cRDDNTTS, cNomeArq, "cNomeArq", if(.F. .Or. .F., !.F., NIL), .F. )
	
	IF mv_par03 == 1
	
	/*------------------------------------------------------------------|
	| 		Localiza e grava 'titulo a receber dentro dos parametros    |
	|------------------------------------------------------------------*/
	
		dbSelectArea("SE1")
		dbSetOrder(2)
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				aStru:= SE1->(dbStruct())
				cCondE1:=".T."
				cQuery := "SELECT * FROM " + RetSqlName("SE1") + " WHERE"
				cIndE1	:=IndexKey()
				If mv_par10 = 1
					cQuery += " E1_FILIAL = '" + xFilial("SE1") + "' AND "
				else
					cQuery += " E1_FILIAL BETWEEN '  ' AND 'ZZ' AND"	  
					cIndE1 :=Right(cIndE1,Len(cIndE1)-10)
				endif
				cIndE1 := SqlOrder(cIndE1)
				
				dbSelectArea("SE1")
				dbCloseArea()
				dbSelectArea("SA1")
				
				cQuery += " E1_CLIENTE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
				cQuery += " AND E1_EMISSAO <= '" + DTOS(dDataBase) + "'"
				cQuery += " AND E1_EMISSAO <= '" + DTOS(mv_par02) + "'"
				cQuery += " AND E1_TIPO NOT LIKE 'PR%'"
				If mv_par15 == 1
					cQuery += " AND E1_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
				Endif
				cQuery += " AND E1_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
				If mv_par11 == 1
					cQuery += " AND E1_TIPO IN " + FORMATIN(cTipos,"/")
				Endif
				cQuery += " AND D_E_L_E_T_ <> '*'"
				  
	/*--------------------------------|
	| verifica quais serao impressos  |
	|--------------------------------*/
										
				If mv_par07 == 2 // So'Normais
					cQuery += " And E1_TIPO NOT IN " + FORMATIN(MVRECANT,"/") 
				Endif                                            
						
				If mv_par07 == 3 // So'Adiantamentos
					cQuery += " And E1_TIPO IN " + FORMATIN(MVRECANT,"/")
				End			
					
	/*------------------------------------------------------------------|
	| Lê registros com datas anteriores a data inicial(para compor)     |
	|os saldos)ate a data final										    |
	|------------------------------------------------------------------*/
				
				cQuery += " And E1_EMISSAO <= '" + dtos(mv_par02) + "'"																	
				
				If mv_par18 == 1 .And. TcGetDb() $ "MSSQL/MSSQL7"		// Seleciona clientes por conta contabil
					cFilial := xFilial()
					cQuery += " AND EXISTS ("					
					cQuery += "SELECT * FROM " +RetSqlName("SA1")+" SA1, "+RetSqlName("SE1")+" SE1 WHERE "
					cQuery += "SA1.A1_FILIAL = '" + cFilial + "' And SA1.A1_COD = SE1.E1_CLIENTE And SA1.A1_LOJA = SE1.E1_LOJA And "
					cQuery += "SA1.A1_CONTA BETWEEN '" + mv_par19 + "' AND '" + mv_par20 + "')"			
				Endif									
				cQuery += " ORDER BY " + cIndE1
				
				cQuery := ChangeQuery(cQuery)
				
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .F., .T.)
				
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C'
						TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
			else
		#ENDIF
			If mv_par10 = 1
				dbSeek(xFilial()+mv_par04,.T.)
				cCondE1:="xFilial()==SE1->E1_FILIAL .and. SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
			Else
				cArqTrab :=CriaTrab(NIL,.F.)
				AADD(aInd,cArqTrab)
				cIndE1   :=IndexKey()
				cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
				IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
				cCondE1:="SE1->E1_CLIENTE >= mv_par04 .And. SE1->E1_CLIENTE <= mv_par05"
				dbCommit()
				nIndex:=RetIndex("SE1")
				dbSelectArea("SE1")
				#IFNDEF TOP
					dbSetIndex(cArqTrab+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndex+1)
				dbSeek(mv_par04,.T.)
			EndIf
		#IFDEF TOP
			EndIf
		#ENDIF
		
		While !SE1->(Eof()) .and. &(cCondE1)		
			If SE1->E1_NATUREZ < mv_par12 .Or. SE1->E1_NATUREZ > mv_par13
				SE1->(dbSkip())
				Loop
			EndIf
			If mv_par18 == 1		// Seleciona clientes por conta contabil
				dbSelectArea("SA1")
				MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
				If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
					dbSelectArea("SE1")
					dbSkip()
					Loop
				Endif
			Endif
			dbSelectArea("SE1")
	
			IF SE1->E1_TIPO $ MVPROVIS
				SE1->(dbSkip())
				Loop
			Endif
			
	/*---------------------------------|
	| verifica quais serao impressos   |
	|----------------------------------*/        
		
			If mv_par07 == 2 .and. E1_TIPO $ MVRECANT  // So'Normais
				dbSkip( )
				Loop
			Endif
			
			If mv_par07 == 3 .and. !E1_TIPO $ MVRECANT // So'Adiantamentos
				dbSkip( )
				Loop
			End 
			
	/*------------------------------------------------------------------|
	| Lê registros com datas anteriores a data inicial(para compor)     |
	|os saldos)ate a data final										    |
	|------------------------------------------------------------------*/
	
			If SE1->E1_EMISSAO > mv_par02
				SE1->(dbSkip( ) )
				Loop
			End
			
			IF ! Inside(SE1->E1_TIPO)
				dbSkip()
				Loop
			End
			
			IF SE1->E1_EMISSAO >= mv_par01 .or. mv_par15 == 1 
			
	/*------------------------------------------------------------------|
	| verifica prefixo caso a movimentacao nao seja interpretada para   |
	| para calculo do saldo anterior ou quando solicitado				|
	|------------------------------------------------------------------*/
			
				If SE1->E1_PREFIXO < mv_par08 .Or. SE1->E1_PREFIXO > mv_par09
					SE1->(dbSkip())
					Loop
				Endif
			Endif
			
			If SE1->E1_TIPO $ MVABATIM
				AAdd( aDadosAbat, {SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_EMISSAO,SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA,;
										 SE1->E1_PORTADO,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_VLCRUZ,SE1->E1_BAIXA} )
			EndIf
			
	/*-------------------------------------|
	| grava debito no arquivo de trabalho  |
	|-------------------------------------*/					
	
			dbSelectArea("cNomeArq")
			Reclock("cNomeArq",.t.)
			Replace CODIGO  With SE1->E1_CLIENTE
			Replace LOJA    With SE1->E1_LOJA
			Replace DATAEM  With SE1->E1_EMISSAO
			Replace NUMERO  With SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
			Replace TIPO    With SE1->E1_TIPO
			Replace BANCO   With SE1->E1_PORTADO
			Replace EMISSAO With SE1->E1_EMISSAO
			Replace VENCTO  With SE1->E1_VENCREA
			Replace VALOR   With SE1->E1_VLCRUZ
			Replace MOEDA   With SE1->E1_MOEDA
			If cPaisLoc <> "BRA"
				If SE1->E1_TIPO $ MV_CRNEG
					cHistor := OemToAnsi(STR0030)  //"NOTA DE CREDITO No. "
				ElseIf SE1->E1_TIPO $ MV_CPNEG
					cHistor := OemToAnsi(STR0031)  //"NOTA DE DEBITO No. "
				ElseIf ALLTRIM(SE1->E1_TIPO) $ "NF|FT"
					cHistor := OemToAnsi(STR0032)  //"FACTURA No. "
				ElseIf SE1->E1_TIPO == "RA "
					cHistor := OemToAnsi(STR0033)  //"ANTICIPO"
				ElseIf SE1->E1_TIPO == "NCI"
					cHistor := OemToAnsi(STR0034)  //"NOTA DE CRED. INTERNA"
				ElseIf SE1->E1_TIPO == "NDI"
					cHistor := OemToAnsi(STR0035)  //"NOTA DE DEB. INTERNA"
				Else
				    cHistor := SE1->E1_HIST	
				EndIf
				Replace HISTOR  With cHistor
			ElseIf SE1->E1_FATURA=="NOTFAT".and. cPaisLoc == "BRA"
				Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi(STR0029),SE1->E1_HIST)  //"Pela Emissao da Fatura"
			Else
				Replace HISTOR  With IIF(Empty(SE1->E1_HIST),OemToAnsi(STR0012),SE1->E1_HIST)  //"Pela Emissao do Titulo"
			Endif
			If SE1->E1_TIPO $ MVRECANT+"/"+MVABATIM+"/"+MV_CRNEG
				Replace DC   With "C"
			Else
				Replace DC   With "D"
			Endif
			MsUnlock()
		
			dbSelectArea("SE1")
			dbSkip()
		Enddo
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				DBSelectArea("SE1")
				DbCloseArea()
				ChkFile("SE1")
			Endif
		#ENDIF
	Endif
	
	IF mv_par03 == 2
	
	/*-------------------------------------------------------|
	| localiza e grava titulos a pagar dentro dos parametros |	
	|-------------------------------------------------------*/
	
		dbSelectArea("SE2")
		dbSetOrder (6)
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				aStru:= SE2->(dbStruct())
				cCondE2:=".T."
				cQuery := "SELECT * FROM " + RetSqlName("SE2") + " WHERE"
				cIndE2	:=IndexKey()
				If mv_par10 = 1
					cQuery += " E2_FILIAL = '" + xFilial("SE2") + "' AND "
				else
					cQuery += " E2_FILIAL BETWEEN '  ' AND 'ZZ' AND"
					cIndE2 :=Right(cIndE2,Len(cIndE2)-10)
				endif
				cIndE2 := SqlOrder(cIndE2)
				
				dbSelectArea("SE2")
				dbCloseArea()
				dbSelectArea("SA1")
				cQuery += " E2_FORNECE BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
				cQuery += " AND E2_EMIS1 <= '" + DTOS(mv_par02)  + "'"
				cQuery += " AND E2_EMIS1 <= '" + DTOS(dDataBase) + "'"
				If mv_par15 == 1
					cQuery += " AND E2_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
				Endif
				cQuery += " AND E2_TIPO NOT LIKE '"+MVPROVIS+"'"
				cQuery += " AND E2_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
				If mv_par11 == 1
					cQuery += " AND E2_TIPO IN " + FORMATIN(cTipos,"/")
				Endif
				cQuery += " AND D_E_L_E_T_ <> '*'" 
				
	/*-------------------------------|
	| verifica quais serao impressos |								    |
	|-------------------------------*/
	
				If mv_par07 == 2 // So'Normais
					cQuery += " And E2_TIPO NOT IN " + FORMATIN(MVRECANT,"/") 
				Endif                                            
						
				If mv_par07 == 3 // So'Adiantamentos
					cQuery += " And E2_TIPO IN " + FORMATIN(MVRECANT,"/")
				End
				
	/*------------------------------------------------------------------|
	| Lê registros com datas anteriores a data inicial(para compor)     |
	|os saldos)ate a data final										    |
	|------------------------------------------------------------------*/			
				
				cQuery += " And E2_EMIS1 <= '" + dtos(mv_par02) + "'"																	
				
				If mv_par18 == 1 .And. TcGetDb() $ "MSSQL/MSSQL7"		// Seleciona clientes por conta contabil
					cFilial := xFilial()
					cQuery += " AND EXISTS ("					
					cQuery += "SELECT * FROM " +RetSqlName("SA2")+" SA2, "+RetSqlName("SE2")+" SE2 WHERE "
					cQuery += "SA2.A2_FILIAL = '" + cFilial + "' And SA2.A2_COD = SE2.E2_FORNECE And SA2.A2_LOJA = SE2.E2_LOJA And "
					cQuery += "SA2.A2_CONTA BETWEEN '" + mv_par19 + "' AND '" + mv_par20 + "')"			
				Endif									
				cQuery += " ORDER BY " + cIndE2			
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)
				
				For ni := 1 to Len(aStru)
					If aStru[ni,2] != 'C'
						TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
					Endif
				Next
			Else
		#ENDIF
			dbSetOrder (6)
			If mv_par10 = 1
				dbSeek(xFilial()+mv_par04,.T.)
				cCondE2:="SE2->E2_FILIAL==xFilial() .and. SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
			Else
				cArqTrab :=CriaTrab(NIL,.F.)
				AADD(aInd,cArqTrab)
				cIndE2   :=IndexKey()
				cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
				IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
				cCondE2:="SE2->E2_FORNECE >= mv_par04 .And. SE2->E2_FORNECE <= mv_par05"
				dbCommit()
				nIndex:=RetIndex("SE2")
				dbSelectArea("SE2")
				#IFNDEF TOP
					dbSetIndex(cArqTrab+OrdBagExt())
				#ENDIF
				dbSetOrder(nIndex+1)
				dbSeek(mv_par04,.T.)
			EndIf
			#IFDEF TOP
			EndIf
			#ENDIF
		
		While !SE2->(Eof()) .and. &(cCondE2)
			
			If ( SE2->E2_NATUREZ < mv_par12 .Or. SE2->E2_NATUREZ > mv_par13 )
				SE2->(dbSkip())
				Loop
			EndIf
			
			IF SE2->E2_TIPO $ MVPROVIS
				SE2->(dbSkip())
				Loop
			End
			If mv_par18 == 1		// Seleciona fornecedores por conta contabil
				dbSelectArea("SA2")
				MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
				If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
					dbSelectArea("SE2")
					dbSkip()
					Loop
				Endif
			Endif
	      dbSelectArea("SE2")
	      
	/*------------------------------|
	| verifica quais serao impresso |
	|------------------------------*/
	
			If mv_par07 == 2 .and. SE2->E2_TIPO $ MVPAGANT // So'Normais
				dbSkip()
				Loop
			Endif
			
			If mv_par07 == 3 .and. !SE2->E2_TIPO $ MVPAGANT //So'Adiantamentos
				dbSkip()
				Loop
			Endif
			
	/*------------------------------------------------------------------|
	| Lê registros com datas anteriores a data inicial(para compor)     |
	|os saldos)ate a data final										    |
	|------------------------------------------------------------------*/
	
			If SE2->E2_EMIS1 > mv_par02
				SE2->(dbSkip())
				Loop
			End
			
			if ! Inside(SE2->E2_TIPO)
				dbSkip()
				Loop
			End
			
			IF SE2->E2_EMIS1 >= mv_par01 .or. mv_par15 == 1
			
	/*-----------------------------------------------------------|
	| verifica prefixo caso a movimentacao nao seja interpretada |
	| para calculo do saldo anterior ou quando solicitado		 | 											    |
	|-----------------------------------------------------------*/ 
	
				If SE2->E2_PREFIXO < mv_par08 .Or. SE2->E2_PREFIXO > mv_par09
					SE2->(dbSkip())
					Loop
				EndIf
			Endif
			
	/*------------------------------------|
	| grava debito no arquivo de trabalho |   
	|------------------------------------*/
			
			Reclock("cNomeArq",.t.)
			Replace CODIGO  With SE2->E2_FORNECE
			Replace LOJA    With SE2->E2_LOJA
			Replace DATAEM   With SE2->E2_EMIS1
			Replace NUMERO  With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
			Replace TIPO    With SE2->E2_TIPO
			Replace BANCO   With SE2->E2_PORTADO
			Replace EMISSAO With SE2->E2_EMISSAO
			Replace VENCTO  With SE2->E2_VENCREA
			Replace VALOR   With SE2->E2_VLCRUZ
			Replace MOEDA   With SE2->E2_MOEDA
			
			
			If SE2->E2_FATURA=="NOTFAT" .and. cPaisLoc == 'BRA'
				Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi(STR0029),SE2->E2_HIST)  //"Pela Emissao da Fatura"
			Else
				Replace HISTOR  With IIF(Empty(SE2->E2_HIST),OemToAnsi(STR0012),SE2->E2_HIST)  //"Pela Emissao do Titulo"
			Endif
			IF SE2->E2_TIPO$ MVPAGANT+"/"+MVABATIM+"/"+MV_CPNEG
				Replace DC     With "D"
			Else
				Replace DC     With "C"     //Abatimentos
			Endif
			MsUnlock()
	
	/*------------------------------------------------------|
	| abatimentos que fizeram parte do abatimento da fatura |
	|------------------------------------------------------*/
			
			IF SE2->E2_TIPO $ MVABATIM .and. !Empty(SE2->E2_FATURA) .and. ;
					SE2->E2_FATURA != "NOTFAT" .and. SE2->E2_DTFATUR <= mv_par02
	
				Reclock("cNomeArq",.t.)
				Replace CODIGO  With SE2->E2_FORNECE
				Replace LOJA    With SE2->E2_LOJA
				Replace DATAEM  With SE2->E2_EMIS1
				Replace NUMERO  With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
				Replace TIPO    With SE2->E2_TIPO
				Replace BANCO   With SE2->E2_PORTADO
				Replace EMISSAO With SE2->E2_EMISSAO
				Replace VENCTO  With SE2->E2_VENCREA
				Replace VALOR   With SE2->E2_VLCRUZ
				Replace BAIXA   With SE2->E2_DTFATUR
				Replace HISTOR  With OemToAnsi(STR0013)+SE2->E2_FATURA  //"BX EMIS FAT "
				Replace DC      With "C"     //Baixa de Abatimento por emissao de fatura
				MsUnlock()
	                                                
			Endif	
			
	/*-----------------------------------------------------------------------|
	| gera movimento de historicos no caso de retençao de pis,confins e csll |
	|-----------------------------------------------------------------------*/
			
			If lPCCBaixa .And. SE2->E2_TIPO $ MVPAGANT  //Verifico se eh PA para exibir tx's na emissao
				For nX:= 1 To Len(aImp10925)
					If &(aImp10925[nX][1]) > 0
						Reclock("cNomeArq",.T.)
						Replace CODIGO 	With SE2->E2_FORNECE
						Replace LOJA		With SE2->E2_LOJA
						Replace DATAEM		With SE2->E2_EMIS1
						Replace NUMERO 	With SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
						Replace EMISSAO	With SE2->E2_EMISSAO
						Replace VALOR		With &(aImp10925[nX][1])
						Replace HISTOR 	With STR0047 + " - " + aImp10925[nX][2]  //Desc.Imposto
						Replace VENCTO		With SE2->E2_VENCREA
						Replace DC	  		With "D"
						MsUnlock()
					Endif
				Next
			Endif
				
			dbSelectArea("SE2")
			dbSkip()
		Enddo
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				DBSelectArea("SE2")
				DbCloseArea()
				ChkFile("SE2")
			Endif
		#ENDIF
	Endif
	
	/*------------------------------------------------------------------|
	| 			Ordena o array de abatimentos de contas a receber       |
	|------------------------------------------------------------------*/
	
	If Len(aDadosAbat) > 0
		aSort(aDadosAbat,,,{|x,y| x[1]+x[2]+x[4] > y[1]+y[2]+y[4]})
	Endif
	
	/*---------------------------------------------------------|
	| localiza na movimentacao bancaria,os titulo do periodo   |
	|---------------------------------------------------------*/
	
	dbSelectArea("SE5")               
	ChkFile("SE5",.F.,"NEWSE5")
	dbSelectArea("SE5")
	dbSetOrder(7)
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			// Alterado por Alex Sandro Valario  em desenvolvimento 1Inicio
			aStru := SE5->(dbStruct())
			
			cCondE5:=".T."
			cQuery := "SELECT * FROM " + RetSqlName("SE5") + " WHERE"
			cIndE5	:=IndexKey()
			If mv_par10 = 1
				cQuery += " E5_FILIAL = '" + xFilial("SE5") + "' AND "
			else
				cQuery += " E5_FILIAL BETWEEN '  ' AND 'ZZ' AND"
				cIndE5 :=Right(cIndE5,Len(cIndE5)-10)
			endif
			cIndE5 := SqlOrder(cIndE5)
			
			dbSelectArea("SE5")
			dbCloseArea()
			dbSelectArea("SA1")
			
			cQuery += " E5_DTDIGIT <= '" + DTOS(mv_par02) + "'"
			cQuery += " AND E5_NUMERO <> '" +space(6)+"'"
			cQuery += " AND E5_SITUACA    <> 'C'"
			cQuery += " AND E5_SITUACA    <> 'X'"
			cQuery += " AND E5_DTDIGIT    <= '"+DTOS(dDataBase)+ "'"
			If mv_par15 == 1
				cQuery += " AND E5_PREFIXO BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "'"
			Endif
			cQuery += " AND E5_CLIFOR BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'"
			cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par12 + "' AND '" + mv_par13 + "'"
			If mv_par11 == 1
				cQuery += " AND E5_TIPO IN " + FORMATIN(cTipos,"/")
			Endif
			cQuery += " AND E5_TIPODOC IN ('VL','VM','BA','CP','LJ','V2','ES')" 
			cQuery += " AND D_E_L_E_T_ <> '*'"
			If mv_par03 == 1
				cQuery += " AND ((E5_RECPAG = 'R' AND E5_TIPODOC <> 'ES')"
				cQuery += " OR (E5_TIPODOC = 'ES' AND E5_RECPAG = 'P')"
				cQuery += " OR (E5_TIPO IN ('"+MV_CRNEG+"','"+MVRECANT+"')))"
			Endif
			If mv_par03 == 2
				cQuery += " AND ((E5_RECPAG = 'P' AND E5_TIPODOC <> 'ES')"
				cQuery += " OR  (E5_TIPODOC = 'ES' AND E5_RECPAG = 'R')"
				cQuery += " OR (E5_TIPO IN ('"+MV_CPNEG+"','"+MVPAGANT+"')))"
			Endif
			
	/*-----------------------------------------------------------------------------------------------------|
	| tratamento para restringir os registros da query do SE5 aos que possuam seus respectivos SE1 ou SE2  |
	|-----------------------------------------------------------------------------------------------------*/
			
			If TcGetDb() $ "MSSQL/MSSQL7"
			
				cQuery += "AND EXISTS ("		
				
				cQuery += " SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA FROM "+RetSqlName("SE1")+" SE1, "+RetSqlName("SE5")+" SE5 WHERE "
				cQuery += " SE1.E1_FILIAL = SE5.E5_FILIAL AND "
				cQuery += " SE1.E1_PREFIXO = SE5.E5_PREFIXO AND "
				cQuery += " SE1.E1_NUM = SE5.E5_NUMERO AND "
				cQuery += " SE1.E1_PARCELA = SE5.E5_PARCELA AND "
				cQuery += " SE1.E1_TIPO	= SE5.E5_TIPO AND "
				cQuery += " SE1.E1_CLIENTE = SE5.E5_CLIFOR AND "
				cQuery += " SE1.E1_LOJA = SE5.E5_LOJA "
				cQuery += " UNION "
				cQuery += " SELECT SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, SE2.E2_FORNECE, SE2.E2_LOJA FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SE5")+" SE5 WHERE "
				cQuery += " SE2.E2_FILIAL = SE5.E5_FILIAL AND "
				cQuery += " SE2.E2_PREFIXO = SE5.E5_PREFIXO AND "
				cQuery += " SE2.E2_NUM = SE5.E5_NUMERO AND "
				cQuery += " SE2.E2_PARCELA = SE5.E5_PARCELA AND "
				cQuery += " SE2.E2_TIPO	= SE5.E5_TIPO AND "
				cQuery += " SE2.E2_FORNECE = SE5.E5_CLIFOR AND "
				cQuery += " SE2.E2_LOJA	= SE5.E5_LOJA"
				
				cQuery += ") "
				
			Endif
	
			cQuery += " ORDER BY " + cIndE5
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .F., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		Else
	#ENDIF
		If mv_par10 = 1
			dbSeek(xFilial(),.T.) // Com SoftSeek ON
			cCondE5:="xFilial('SE5') == SE5->E5_FILIAL"
		Else
			cArqTrab :=CriaTrab(NIL,.F.)
			AADD(aInd,cArqTrab)
			cIndE5   :=IndexKey()
			cIndE5   :=Right(cIndE5,Len(cIndE5)-10)
			IndRegua("SE5",cArqTrab,cIndE5,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
			cCondE5:=".T."
			dbCommit()
			nIndex:=RetIndex("SE5")
			dbSelectArea("SE5")
			#IFNDEF TOP
				dbSetIndex(cArqTrab+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbGoTop()
		EndIf
	#IFDEF TOP
		EndIf
	#ENDIF
	If mv_par03 == 1 //Carteira a Receber
		dbSelectArea("SE1")
		dbSetOrder(1)
		cArqTrab :=CriaTrab(NIL,.F.)
		AADD(aInd,cArqTrab)
		cIndE1   :=IndexKey()
		cIndE1   :=Right(cIndE1,Len(cIndE1)-10)
		IndRegua("SE1",cArqTrab,cIndE1,,,OemToAnsi(STR0011)) //"Selecionando Registros..."
		dbCommit()
		nIndexSE1:=RetIndex("SE1")
		dbSelectArea("SE1")
		#IFNDEF TOP
			dbSetIndex(cArqTrab+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndexSE1+1)
		dbGoTop()
	Endif
	
	If mv_par03 == 2 //Carteira a Pagar
		dbSelectArea("SE2")
		dbSetOrder(1)
		cArqTrab :=CriaTrab(NIL,.F.)
		AADD(aInd,cArqTrab)
		cIndE2   :=IndexKey()
		cIndE2   :=Right(cIndE2,Len(cIndE2)-10)
		IndRegua("SE2",cArqTrab,cIndE2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
		dbCommit()
		nIndexSE2:=RetIndex("SE2")
		dbSelectArea("SE2")
		#IFNDEF TOP
			dbSetIndex(cArqTrab+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndexSE2+1)
		dbGotop()
	Endif	
	
	dbSelectArea("SE5")
	
	While !SE5->(Eof()) .and. &(cCondE5)
	
		#IFNDEF TOP 
		
	/*------------------------------------------------------------------------------------------|
	| tratamento das consistencias dos registros do SE5 quando o mesmo nao for tratdo por query |
	|------------------------------------------------------------------------------------------*/
			
			If !ValidSE5()
				SE5->(dbSkip())
				Loop
			Endif
		
		#ELSE
			If TcSrvType() == "AS/400"
		
				If !ValidSE5()
					SE5->(dbSkip())
					Loop
				Endif
		
			Endif
		#ENDIF
		
		dbSelectArea("SE5")
		
		If SE5->E5_RECPAG == "R" .and. mv_par03 == 1
		
	/*-------------------------------|
	| verifica quais serao impressos |
	|-------------------------------*/
		
			If mv_par07 == 2 .and. E5_TIPO $ MVRECANT   // So'Normais
				dbSkip()
				Loop
			Endif
			
			If mv_par07 == 3 .and. !E5_TIPO $ MVRECANT  // So'Adiantamentos
				dbSkip()
				Loop
			Endif
		ElseIf SE5->E5_RECPAG == "P" .and. mv_par03 == 2
		
	/*-------------------------------|
	| verifica quais serao impressos |
	|-------------------------------*/
		
			If mv_par07 == 2 .and. E5_TIPO $ MVPAGANT  // So'Normais
				dbSkip( )
				Loop
			Endif
			
			If mv_par07 == 3 .and. !E5_TIPO $ MVPAGANT // So'Adiantamentos
				dbSkip()
				Loop
			Endif
			
	/*--------------------------------------|
	| Ignora PA`s pagos com junta de cheque |
	|--------------------------------------*/
		
			If E5_TIPO $ MVPAGANT .and. E5_TIPODOC == "BA" .And. !E5_MOTBX $ "CMP"
				DbSkip()
				Loop
			Endif
		Endif
	
		IF mv_par03 == 1 .and. SE5->E5_RECPAG != "R"
			If (!(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG ) .AND. SE5->E5_TIPODOC !="ES") .or. ; //Baixa de RA
				(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de PA
				((SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 2).or. ;
				(!(SE5->E5_TIPO $ MVRECANT) .AND. MV_PAR07 == 3)
				SE5->(dbSkip())
				Loop
			Endif
		EndIF
		IF mv_par03 == 2 .and. SE5->E5_RECPAG != "P"
			If (!( SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG ) .AND. SE5->E5_TIPODOC !="ES") .or.;   //Baixa de PA
				(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC =="ES") .or. ; //Estorno da Baixa de RA
				(( SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 2).or. ;
				(!(SE5->E5_TIPO $ MVPAGANT) .AND. mv_par07 == 3)
				SE5->(dbSkip())
				Loop
			Endif
		Endif
	
		If mv_par03 == 1        // Se for baixa de adiantamentos
			If SE5->E5_RECPAG == "R" .and. E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
				dbSkip()
				LOOP
			EndIf
		EndIf
		
		If mv_par03 == 2        // Se for baixa de adiantamentos
			If SE5->E5_RECPAG == "P" .and. E5_TIPO $ MVRECANT+"/"+MV_CRNEG .AND. SE5->E5_TIPODOC $ "VL/BA/DC/D2/MT/JR/J2/M2/CM/C2/CX"
				dbSkip()
				LOOP
			End
		End 
		
	/*------------------------------------------------------------------|
	| Nao considera registro de de estorno de conpensacao de cheques    |
	|------------------------------------------------------------------*/         
	
		If SE5->E5_TIPODOC = "ES" .And. SE5->E5_RECPAG = "P"
			aAreaSE5 := SE5->(GetArea())	
			dbSelectArea("NEWSE5")
			dbSetOrder(2)
			If MsSeek(xFilial("SE5")+"CH"+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
				SE5->(dbSkip())
				Loop
			EndIf
			RestArea(aAreaSE5)
		EndIf	
		     
	/*---------------------------------|
	| localiza o cliente ou fornecedor |
	|---------------------------------*/
	
		cCarteira := SE5->E5_RECPAG
		If SE5->E5_RECPAG == "R"
			If ((SE5->E5_TIPO$MVPAGANT+"/"+MV_CPNEG));
				.OR. ((!SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG) .And. SE5->E5_TIPODOC =="ES")
				cCarteira := "P"        //Baixa de adiantamento (inverte)
			Endif 
		Endif
		
		If SE5->E5_RECPAG == "P"
			If ((SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG));
				.OR. ((!SE5->E5_TIPO$MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG) .And. SE5->E5_TIPODOC =="ES")
				cCarteira := "R"        //Baixa de adiantamento (inverte)
			Endif 
		Endif
	
		IF cCarteira == "R"   
			dbSelectArea("SE1")
			If mv_par10 = 1
				dbSetOrder(1)
				dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
			Else
				dbSetOrder(nIndexSE1+1)
				dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
			EndIf 
			
	/*------------------------------------------------------------|
	| caso nao ache o registro no SE1,nao considero os movimentos |
	|------------------------------------------------------------*/
		
			If !Found()
				dbSelectArea("SE5")
				DbSkip()
				Loop
			Else
				If mv_par18 == 1		// Seleciona clientes por conta contabil
					dbSelectArea("SA1")
					MsSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
					If SA1->A1_CONTA < mv_par19 .or. SA1->A1_CONTA > mv_par20
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
				Endif	
			Endif				
		Else
			dbSelectArea("SE2")
			If mv_par10 = 1
				dbSetOrder(1)
				dbSeek(xFilial()+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
			Else
				dbSetOrder(nIndexSE2+1)
				dbSeek(SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA)
			Endif
	/*------------------------------------------------------------------|
	| caso nao encontre os registros no SE2,nao considera os movimentos |
	|------------------------------------------------------------------*/
		
			If !Found()
				dbSelectArea("SE5")
				DbSkip()
				Loop
			Else
				If mv_par18 == 1	// Seleciona fornecedores por conta contabil
					dbSelectArea("SA2")
					MsSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
					If SA2->A2_CONTA < mv_par19 .or. SA2->A2_CONTA > mv_par20
						dbSelectArea("SE5")
						dbSkip()
						Loop
					Endif
				Endif	
			Endif
		Endif		
		dbSelectArea("SE5")
		IF cCarteira == "R"
			dEmissao := SE1->E1_EMISSAO
			dVencto  := SE1->E1_VENCREA
		Else
			dEmissao := SE2->E2_EMISSAO
			dVencto  := SE2->E2_VENCREA
		Endif  
	
		aDados[1] := E5_CLIFOR
		aDados[2] := E5_LOJA
		aDados[3] := E5_DTDIGIT
		aDados[4] := E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA
		aDados[5] := E5_BANCO
		aDados[6] := E5_DATA
		aDados[7] := E5_HISTOR
		aDados[8] := E5_RECPAG
		aDados[9] := E5_TIPO
		aDados[10]:= E5_TIPODOC
		aDados[11]:= E5_VALOR
		//
		If lPccBaixa
			aDados[12]:= E5_PRETPIS
			aDados[13]:= E5_PRETCOF
			aDados[14]:= E5_PRETCSL
			
			aDados[15]:= E5_VRETPIS
			aDados[16]:= E5_VRETCOF
			aDados[17]:= E5_VRETCSL
		Endif	
	
		nValliq := E5_VALOR
		If mv_par06 == 2  //  Nao Imprime valor Financeiro
			nValliq -=	(E5_VLJUROS + E5_VLMULTA + E5_VLCORRE - E5_VLDESCO)
		Endif
		If E5_TIPODOC == "VM" // Correcao Monetaria
	
			If E5_VALOR > 0
				cTipo  := "C"
			Else
				If E5_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG
					cTipo  := "D"			
				Else
					cTipo  := "C"			
				Endif			
			Endif
	
			GravaTrab(cTipo,dEmissao,dVencto,nValliq,aDados,aDadosAbat,,.T.)  // Registro principal
		Else
			GravaTrab("B",dEmissao,dVencto,nValliq,aDados,aDadosAbat,.T.)  // Registro principal
		Endif
		If mv_par06 == 1  // Imprime valor financeiro
			For nX := 1 to 4
				DO CASE
					CASE nX == 1		
						cCampo := "E5_VLJUROS"
						cTipo  := "J"
						aDados[7] := STR0050 //"Juros s/ Baixa"
					CASE nX == 2		
						cCampo := "E5_VLMULTA"
						cTipo  := "M"
						aDados[7] := STR0051 //"Multa s/ Baixa"
					CASE nX == 3		
						cCampo := "E5_VLDESCO"
						cTipo  := "D"
						aDados[7] := STR0052 //"Desconto s/ Baixa"
					CASE nX == 4		
						cCampo := "E5_VLCORRE"
						If &(cCampo) > 0
							cTipo  := "C" //IIF(E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG,"D","C")
						Else
							cTipo  := "D" //IIF(E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG,"D","C")
						Endif
						aDados[7] := STR0053 //"C.Monetaria s/ Baixa"
				ENDCASE
				If &(cCampo) > 0 .or. (cCampo == "E5_VLCORRE" .and. &(cCampo) != 0)  //Correcao pode ter valor negativo
					GravaTrab(cTipo,dEmissao,dVencto,&(cCampo),aDados,aDadosAbat,,(cCampo == "E5_VLCORRE"))  // Registro principal	
				Endif
			Next				
		Endif
		dbSelectArea("SE5")
		dbSkip()
	End
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			DBSelectArea("SE5")
			DbCloseArea()
			ChkFile("SE5")
		Endif
	#ENDIF
	
	/*-----------------------------|
	| inicia a rotina de impressao |
	|-----------------------------*/
	
	oSection1:Init()
	oSection2:Init()
	aFill(aSec1,nil)
	aFill(aSec2,nil)
	
	dbSelectArea("cNomeArq")
	IndRegua("cNomeArq",cNomeArq,"CODIGO+LOJA+Dtos(DATAEM)+Numero",,,OemToAnsi(STR0011))  //"Selecionando Registros..."
	dbGoTop()
	nTotDebG := 0
	nTotCrdG := 0
	nSalAtuG := 0
	
	While !Eof()
		
		cCodigo	:= CODIGO
		cLoja		:= LOJA
		nSaldoAtu:= 0
		nTotDeb	:= 0
		nTotCrd	:= 0
		
		nRegAtu := Recno()
		lImprime := .F.
		
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
			
			If DATAEM >= mv_par01     // Procura titulos no intervalo e
				lImprime := .T.     // se houver, dever  imprimir
				Exit
			EndIf
			dbSkip()
		EndDo
		
		dbGoto(nRegAtu)
		aSdoContabil := {} // Saldo da conta contabil do fornecedor
		cConta := ""
		While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And. ! Eof()
		
	/*------------------------------------|
	| loop para calculo do saudo anterior |
	|------------------------------------*/
		
			While cNomeArq->CODIGO == cCodigo .And. cNomeArq->LOJA == cLoja .And.;
				cNomeArq->DATAEM < mv_par01 .And. ! Eof() .And. (mv_par22 == 1 .or. lImprime)
				If DC == "C"
					nSaldoAtu += ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu -= ABS(cNomeArq->VALOR)
				EndIf
				
				dbSkip()
				If cNomearq->CODIGO != ccodigo .Or. cNomeArq->LOJA != cLoja
					lNoSkip := .T.
				Endif
			Enddo
			
			If lImprime .Or. nSaldoAtu != 0
				If cAuxFoot = "A TRANSPORTAR"
					
					If nQuebra == 1
						If mv_par03==1
							dbSelectArea("SA1")
							If mv_par10 = 1
								dbSeek(xFilial()+cCodigo+cLoja)
							Else
								If cIndA1 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									AADD(aInd,cArqTrab)
									cIndA1   :=IndexKey()
									cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
									IndRegua("SA1",cArqTrab,cIndA1,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
									dbCommit()
									nIndex:=RetIndex("SA1")
									dbSelectArea("SA1")
									#IFNDEF TOP
										dbSetIndex(cArqTrab+OrdBagExt())
									#ENDIF
									dbSetOrder(nIndex+1)
								EndIf
								dbSeek(cCodigo+cLoja)
							EndIf
							If mv_par14 == 1  // Analitico
								cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
							Else
								cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
							Endif
							cConta := SA1->A1_CONTA
							If mv_par21 ==1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
							
	/*------------------------------------|
	| obtem o saldo da conta do fornecedor|
	|------------------------------------*/
								
								aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
							Endif	
						Else
							dbSelectArea("SA2")
							If mv_par10 = 1
								dbSeek(xFilial()+cCodigo+cLoja)
							Else
								If cIndA2 == " "
									cArqTrab :=CriaTrab(NIL,.F.)
									AADD(aInd,cArqTrab)
									cIndA2   :=IndexKey()
									cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
									IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
									dbCommit()
									nIndex:=RetIndex("SA2")
									dbSelectArea("SA2")
									#IFNDEF TOP
										dbSetIndex(cArqTrab+ordBagExt())
									#ENDIF
									dbSetOrder(nIndex+1)
								EndIf
								dbSeek(cCodigo+cLoja)
							EndIf
							If mv_par14 == 1  // Analitico
								cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
							Else
								cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
							Endif
							cConta := SA2->A2_CONTA
							If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)

	/*------------------------------------|
	| obtem o saldo da conta do fornecedor|
	|------------------------------------*/
								
								aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
							Endif	
						EndIF
						
						If cPaisLoc == 'BRA'
							If mv_par14 == 1   // Analitico
								dbSelectArea("cNomeArq")
								aSec1[S1_HISTORICO]	:= STR0028 //"DE TRANSPORTE : "
								aSec1[S1_SALDO_ATU]	:= Abs(nSaldoAtu)
								aSec1[S1_DIGITO]		:= Eval(bBlockDC,nSaldoAtu)
								F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
								aFill(aSec1,nil)								
							Endif
						EndIf
					EndIf
					cAuxFoot = "X"
				Endif
			EndIf
			
			If nQuebra == 0 .and. (lImprime .Or. nSaldoAtu != 0 )
				nQuebra  := 1
				lImprAnt := .F.
				IF mv_par03 == 1
					dbSelectArea("SA1")
					If mv_par10 = 1
						dbSeek(xFilial()+cCodigo+cLoja)
					Else
						If cIndA1 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							AADD(aInd,cArqTrab)
							cIndA1   :=IndexKey()
							cIndA1   :=Right(cIndA1,Len(cIndA1)-10)
							IndRegua("SA1",cArqTrab,cIndA1,,,STR0011 )  //"Selecionando Registros..."
							dbCommit()
							nIndex:=RetIndex("SA1")
							dbSelectArea("SA1")
							#IFNDEF TOP
								dbSetIndex(cArqTrab+OrdBagEXt())
							#ENDIF
							dbSetOrder(nIndex+1)
						EndIf
						dbSeek(cCodigo+cLoja)
					EndIf
					If mv_par14 == 1  // Analitico
						cNome := SA1->A1_NOME+" "+SA1->A1_CGC+" "+SA1->A1_CONTA
					Else
						cNome := Substr(SA1->A1_NOME,1,33)+" "+IIF(mv_par18 == 1,SA1->A1_CONTA,SA1->A1_CGC)
					Endif
					cConta := SA1->A1_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA1->A1_CONTA)
					
	/*------------------------------------|
	| obem o saldo da conta do fornecedor |
	|------------------------------------*/
						
						aSdoContabil := SdoContabil(SA1->A1_CONTA,MV_PAR02,"01","1")	
					Endif	
				Else
					dbSelectArea("SA2")
					If mv_par10 = 1
						dbSeek(xFilial()+cCodigo+cLoja)
					Else
						If cIndA2 == " "
							cArqTrab :=CriaTrab(NIL,.F.)
							AADD(aInd,cArqTrab)
							cIndA2   :=IndexKey()
							cIndA2   :=Right(cIndA2,Len(cIndA2)-10)
							IndRegua("SA2",cArqTrab,cIndA2,,,OemToAnsi(STR0011))  //"Selecionando Registros..."
							dbCommit()
							nIndex:=RetIndex("SA2")
							dbSelectArea("SA2")
							#IFNDEF TOP
								dbSetIndex(cArqTrab+OrdBagExt())
							#ENDIF
							dbSetOrder(nIndex+1)
						EndIf
						dbSeek(cCodigo+cLoja)
					EndIf
					If mv_par14 == 1  // Analitico
						cNome := SA2->A2_NOME+" "+SA2->A2_CGC+" "+SA2->A2_CONTA
					Else
						cNome := Substr(SA2->A2_NOME,1,33)+" "+IIF(mv_par18 == 1,SA2->A2_CONTA,SA2->A2_CGC)
					Endif
					cConta := SA2->A2_CONTA
					If mv_par21 == 1 .And. Empty(aSdoContabil) .And. !Empty(SA2->A2_CONTA)
					
	/*------------------------------------|
	|obtem o saldo da conta do fornecedor |
	|------------------------------------*/
						
						aSdoContabil := SdoContabil(SA2->A2_CONTA,MV_PAR02,"01","1")	
					Endif	
				EndIF
				
				If cPaisLoc == "BRA"
					If mv_par14 == 1  // Analitico
					
						aSec2[S2_DESCRICAO] := cCodigo +"-->"+cLoja
						
						dbSelectArea("cNomeArq")
						aSec1[S1_HISTORICO] := STR0016  //"SALDO ANTERIOR : "
						aSec1[S1_SALDO_ATU] := Abs(nSaldoAtu)
						aSec1[S1_DIGITO]:= Eval(bBlockDC,nSaldoAtu)
						F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
						aFill(aSec1,nil)
						oReport:SkipLine()
						
						nSalAntG += nSaldoAtu
					Else
						aSec2[S2_DESCRICAO] := Substr(cCodigo + "-" + cLoja + " " + cNome,1,64)
						aSec2[S2_SD_ANTERIOR] := Abs(nSaldoAtu)
						aSec2[S2_DIG1] := Eval(bBlockDC,nSaldoAtu)
						nSalAntG += nSaldoAtu
					Endif	
				EndIf
			End
			dbSelectArea("cNomeArq")
			
			If cNomeArq->DATAEM >= mv_par01 .And. !lNoSkip
				If DC == "D"
					nSaldoAtu -= ABS(cNomeArq->VALOR)
					nTotDeb   += ABS(cNomeArq->VALOR)
					nTotDebG  += ABS(cNomeArq->VALOR)
					nSalAtuG  -= ABS(cNomeArq->VALOR)
				Else
					nSaldoAtu += ABS(cNomeArq->VALOR)
					nTotCrd   += ABS(cNomeArq->VALOR)
					nTotCrdG  += ABS(cNomeArq->VALOR)
					nSalAtuG  += ABS(cNomeArq->VALOR)
				End
				If mv_par14 == 1  // Analitico
	
					aSec1[S1_DAT]		:= DATAEM
					
					If OemToAnsi(STR0040)$ HISTOR  //"Recibo"/"Receipt"
						aSec1[S1_HISTORICO] := If(mv_par24=1,Substr(HISTOR, At(OemToAnsi(STR0040),HISTOR),20),HISTOR)
					Else
						aSec1[S1_HISTORICO] := If(mv_par24=1,SubStr(HISTOR,1,20),HISTOR)
					EndIf
					aSec1[S1_TITULO] := SubStr(NUMERO, 1,3) + " " + SubStr(NUMERO, 4,nTamNro) + " " + SubStr(NUMERO,nTamNro+4,nTamParc)
					aSec1[S1_EMISSAO] := EMISSAO
					aSec1[S1_VENCIMENTO] := VENCTO
					IF !Empty(BAIXA)
						aSec1[S1_BAIXA] := BAIXA
					End
					If DC=="D"
						aSec1[S1_DEBITO] := ABS(cNomeArq->VALOR)
					Else
						aSec1[S1_CREDITO] := ABS(cNomeArq->VALOR)
					EndIf
					aSec1[S1_SALDO_ATU] := Abs(nSaldoAtu)
					aSec1[S1_DIGITO] := Eval(bBlockDC,nSaldoAtu)
					F550Print(oReport,If(Len(Trim(HISTOR))>20,.T.,.F.))
					aFill(aSec1,nil)
				Endif
			End
			lFlag := .T.
			If ! lNoSkip
				dbSkip( )
			End
			lNoSkip := .F.
		End
		If lImprime .Or. nSaldoAtu != 0
			If mv_par14 == 1		// Analitico
				aSec2[S2_DESCRICAO] := STR0017 + If(mv_par03==1,STR0018,STR0019)  //"T o t a i s  d o  "###"C l i e n t e"###"F o r n e c e d o r"
			Endif
			aSec2[S2_DEB] := nTotDeb
			aSec2[S2_CRED] := nTotCrd
			aSec2[S2_SD_ATUAL] := Abs(nSaldoAtu)
			aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoAtu)
			oSection2:PrintLine()
			aFill(aSec2,nil)
			
			If mv_par21 == 1 .And. !Empty(aSdoContabil) // Impr. Saldo Contabil
				aSec2[S2_DESCRICAO] := STR0046+If(mv_par03==1,STR0018,STR0019) + If(!Empty(cConta)," ("+cConta+")","") // //"T o t a i s  d o  c o n t a"###"C l i e n t e"###"F o r n e c e d o r"
				aSec2[S2_DEB] := Abs(aSdoContabil[4])
				aSec2[S2_CRED] := Abs(aSdoContabil[5])
				aSec2[S2_SD_ATUAL] := Abs(aSdoContabil[1])
				aSec2[S2_DIG2] := Eval(bBlockDC,aSdoContabil[1])
				oSection2:PrintLine()
				aFill(aSec2,nil)
			EndIf
	
			If mv_par14 == 1 // Anal¡tico/Sint‚tico
				oReport:ThinLine()
			Endif
		Endif
		nQuebra:=0
	End
	
	If nQuebra # 0 .and.(lImprime .Or. nSaldoAtu != 0)
		If mv_par14 == 1		// Anal¡tico/Sint‚tico
			aSec2[S2_DESCRICAO] := STR0017+If(mv_par03==1,STR0018,STR0019)  //"T o t a i s  d o  "###"C l i e n t e"###"F o r n e c e d o r"
		Endif
		aSec2[S2_DEB] := nTotDeb
		aSec2[S2_CRED] := nTotCrd
		aSec2[S2_SD_ATUAL] := Abs(nSaldoAtu)
		aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoAtu)
		oSection2:PrintLine()
		aFill(aSec2,nil)
	End
	
	If lFlag
		oReport:SkipLine()
		oReport:ThinLine()
		nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
		aSec2[S2_DESCRICAO] := STR0020 + If(mv_par03==1,STR0021,STR0022)  //"T o t a l   G e r a l  d o s  "###"C l i e n t e s"###"F o r n e c e d o r e s"
		aSec2[S2_SD_ANTERIOR] := nSalAntG
		aSec2[S2_DIG1] := Eval(bBlockDC,nSalAntG)
		aSec2[S2_DEB] := nTotDebG
		aSec2[S2_CRED] := nTotCrdG
		aSec2[S2_SD_ATUAL] := Abs(nSaldoFinal)
		aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoFinal)
		oSection2:PrintLine()
		aFill(aSec2,nil)
	
		nSaldoFinal := (nSalAntG-nTotDebG+nTotCrdG)
	
		oReport:ThinLine()
		aSec2[S2_DESCRICAO] := 	STR0023  //"S a l d o   F i n a l   d o   R e l a t o r i o : "
		aSec2[S2_SD_ATUAL] := Abs(nSaldoFinal)
		aSec2[S2_DIG2] := Eval(bBlockDC,nSaldoFinal)
		oSection2:PrintLine()
		aFill(aSec2,nil)
		oReport:ThinLine()
	End
	
	oSection1:Finish()
	oSection2:Finish()
	
	
	dbSelectArea("cNomeArq")
	Use
	Ferase(cNomeArq+GetDBExtension())	// Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())    	// Elimina arquivos de Trabalho
	
	dbSelectArea("SA1")
	RetIndex("SA1")
	dbSetOrder(1)
	Set Filter To
	
	dbSelectArea("SA2")
	RetIndex("SA2")
	dbSetOrder(1)
	Set Filter To
	
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			dbSelectArea("SE1")
			dbCloseArea()
			ChKFile("SE1")
			dbSelectArea("SE1")
			dbSetOrder(1)
			
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSelectArea("SE2")
			dbSetOrder(1)
			
			dbSelectArea("SE5")
			dbCloseArea()
			ChKFile("SE5")
			dbSelectArea("SE5")
			dbSetOrder(1)
		Else
	#ENDIF
		dbSelectArea("SE1")
		RetIndex("SE1")
		dbSetOrder(1)
		Set Filter To
		
		dbSelectArea("SE2")
		RetIndex("SE2")
		dbSetOrder(1)
		Set Filter To
		
		dbSelectArea("SE5")
		RetIndex("SE5")
		dbSetOrder(1)
		Set Filter To
	#IFDEF TOP
		EndIF
	#ENDIF                   
	
	NEWSE5->(dbCloseArea())
	
	For nI:=1 to Len(aInd)
		if File(aInd[nI]+OrdBagExt())
			Ferase(aInd[nI]+OrdBagExt())
		Endif
	Next
	
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦F550RODAPE () ¦ Autor ¦ FABIO SALES	    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ ROTINA DE IMPRESSAO DOS TOTAIS NA QUEBRA DE PAGINA R4	  ¦¦¦
¦¦¦			 ¦ 							 								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO	                                        	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function F550RODAPE(oReport,nSaldoTra,cDigito,aSec1)

	Local oSection1 := oReport:Section(1)
	
	oReport:PrintText(STR0015+Transform(Abs(nSaldoTra),tm(Abs(nSaldoTra),14))+" "+cDigito,,oSection1:Cell("E2_VLCRUZ"):ColPos()+1)

Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦F550Print () ¦ Autor ¦ FABIO SALES	    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ IMPRESSAO DA SECCAO 1, RESPEITANDO O PARAMETRO MV_PAR24	  ¦¦¦
¦¦¦			 ¦ 							 								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO	                                        	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function F550Print(oReport,lQuebra)
	
	Local oSection1 := oReport:Section(1)
	
	If mv_par24 == 2 .And. lQuebra
	   oSection1:Cell("E1_HIST"):SetSize(20)
	   oSection1:Cell("E1_HIST"):Hide()
	   oSection1:PrintLine()
	   oSection1:Cell("E1_HIST"):SetSize(40)
	   oSection1:Cell("E1_HIST"):Show()
	   oSection1:Cell("E1_VENCTO"):Hide()
	   oSection1:Cell("TITULO"):Hide()
	   oSection1:Cell("E1_EMISSAO"):Hide()
	   oSection1:Cell("E1_VENCREA"):Hide()
	   oSection1:Cell("E2_DTFATUR"):Hide()
	   oSection1:Cell("E1_VLCRUZ"):Hide()
	   oSection1:Cell("E2_VLCRUZ"):Hide()
	   oSection1:Cell("E1_SALDO"):Hide()
	   oSection1:Cell("DIGITO"):Hide()
	   oSection1:PrintLine()
 	   oSection1:Cell("E1_VENCTO"):Show()
	   oSection1:Cell("E1_HIST"):Show()
	   oSection1:Cell("TITULO"):Show()
	   oSection1:Cell("E1_EMISSAO"):Show()
	   oSection1:Cell("E1_VENCREA"):Show()
	   oSection1:Cell("E2_DTFATUR"):Show()
	   oSection1:Cell("E1_VLCRUZ"):Show()
	   oSection1:Cell("E2_VLCRUZ"):Show()
	   oSection1:Cell("E1_SALDO"):Show()
	   oSection1:Cell("DIGITO"):Show()
	   oSection1:Cell("E1_HIST"):SetSize(20)
	Else
		oSection1:PrintLine() 
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦F550LinPag() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FAZ A QUEBRA DE PAGINA DE ACORDO COM O PARAMETRO "LINHAS	  ¦¦¦
¦¦¦			 ¦ POR PAGINAS ?"(MV_PAR23) 								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TTFINR550	                                        	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function F550LinPag(nLinPag,nLinReport,oReport,nSaldoTra)

	nLinReport++
	
	If nLinReport > (nLinPag + 9)
		oReport:EndPage()
		nLinReport := 8
	Else
		nSaldoTra := nSaldoAtu	
	EndIf

Return Nil

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦GravaTrab() ¦ Autor ¦ FABIO SALES	  	    ¦ Data ¦16.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ grava um registro no arquivo de trabalho para impressao	  ¦¦¦
¦¦¦			 ¦ do razonete				 								  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO	                                        	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function GravaTrab( cTipo,dEmissao,dVencto,nValor,aDados,aDadosAbat,lPrincipal,lCm)

	Local cDCR,cDCP,cAlias:=Alias()
	Local nX := 0
	Local nY := {}
	Local nPos := 0 

	/*--------------------------------------
	|controla o pis confins e csll na baixa|              
    |-----------------------------------  */                     

	Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
					 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
					 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
					 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
	DEFAULT aDadosAbat := {}
	DEFAULT lPrincipal := .F.
	DEFAULT lCm 		 := .F.
	
				 
	If aDados[3] >= mv_par01 .or. mv_par15 == 1
	
	/*-------------------------------------------------------------------------------------------------------------|
	|verifica prefixo caso a movimentacao nao seja interpretada para calculo do saldo anterior ou quando solicitado|              
    |-----------------------------------------------------------------------------------------------------------  */                     

		If Substr(aDados[4],1,3) < mv_par08 .Or. Substr(aDados[4],1,3) > mv_par09
			Return NIL
		EndIf
	Endif
	
	nValor := Iif( nValor=Nil,aDados[11],nValor )
	
	If cTipo $ "B#D" .And.  (lCm .Or. nValor >= 0)
		cDCR="C"
		cDCP="D"
	Else
		cDCR="D"
		cDCP="C"
	EndIf

	/*-------------------------------------|
	|grava registro no arquivo de trabalho |              
    |-------------------------------------*/                     

	Reclock("cNomeArq",.t.)
	Replace CODIGO  With aDados[1]	//CLIFOR
	Replace LOJA    With aDados[2]	//LOJA
	Replace DATAEM  With aDados[3]	//DTDIGIT
	Replace NUMERO  With aDados[4]	//PREFIXO+NUMERO+PARCELA
	Replace BANCO   With aDados[5]	//BANCO
	Replace BAIXA   With aDados[6]	//DATA
	Replace VALOR   With nValor
	Replace EMISSAO With dEmissao
	Replace VENCTO  With dVencto
	Replace HISTOR  With Iif(Empty(aDados[7]) .Or.;
                         Upper(aDados[7]) = Upper(OemToAnsi(STR0047)),;  // "Valor recebido s/ Titulo"
                         OemtoAnsi(STR0048), aDados[7]) // "Baixa de Titulo"
	If cPaisLoc == "BRA"
		If aDados[8] == "R"				// SE5->E5_RECPAG
			Replace DC With Iif((!(aDados[9] $ MVRECANT+"/"+MV_CRNEG) .or.;      //TIPO
			aDados[10]=="ES" ) .and. (!(aDados[9] $ MVPAGANT+"/"+MV_CPNEG .and. SE5->E5_MOTBX = "CMP" .and. aDados[10]=="ES")) ;  //Estorno de compensacao do adiantamento
			.and. aDados[11] >= 0 ,cDCR,cDCP)      //TIPODOC  VALOR
		Else
			Replace DC With Iif((!( aDados[9] $ MVPAGANT+"/"+MV_CPNEG) .or. ;
			aDados[10]=="ES" ) .and. (!( aDados[9] $ MVRECANT+"/"+MV_CRNEG .and. SE5->E5_MOTBX = "CMP" .and. aDados[10]=="ES")) ;   //Estorno de compensacao do adiantamento
			.and. aDados[11] >= 0 ,cDCP,cDCR) 
		EndIf
		MsUnlock()
	EndIf           

	If (SE5->E5_MOTBX == "CMP")

	/*----------------------------------------|
	|verifica se é a baixa principal do titulo|              
    |----------------------------------------*/                     

		If mv_par03 == 1 .And. lPrincipal .and. !(SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVRECANT+"/"+MV_CRNEG) .And. SE5->E5_TIPODOC == "CP"
			//Verificar se o valor da baixa eh igual ao valor do titulo.
			IF STR(SE5->E5_VALOR,17,2) == STR(SE1->E1_VALOR,17,2)
				nPos := Ascan(aDadosAbat, { |x| x[1] + x[2] + x[4] == SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA })
				If nPos > 0                                         
					For nY:=nPos to Len(aDadosAbat) 
						If aDadosAbat[nY][1]+aDadosAbat[nY][2]+aDadosAbat[nY][4] == SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
							Reclock("cNomeArq",.t.)
							Replace CODIGO  With aDadosAbat[nY][1]
							Replace LOJA    With aDadosAbat[nY][2]
							Replace DATAEM  With aDadosAbat[nY][3]
							Replace NUMERO  With aDadosAbat[nY][4]
							Replace BANCO   With aDadosAbat[nY][5]
							Replace EMISSAO With aDadosAbat[nY][6]
							Replace VENCTO  With aDadosAbat[nY][7]
							Replace VALOR   With aDadosAbat[nY][8]
							Replace BAIXA   With aDadosAbat[nY][9]
							Replace HISTOR  With STR0054  //"Baixa por Compensaca"
							Replace DC      With "D"
							MsUnlock()                      
						Else
							Exit					
						Endif
					Next
				Endif
			Endif
		Endif
	Endif

	If lPCCBaixa .and. !(cTipo $ 'M|J|D')

	/*--------------------------------------------------------------------|
	|gera movimento de estorico em casos de retencao de pis,confins e csll|              
    |--------------------------------------------------------------------*/ 
    
		For nX := 1 To 3
			If Empty(aDados[11+nX]) 
				If aDados[14+nX] > 0
					Reclock("cNomeArq",.t.)
					Replace CODIGO  With aDados[1]
					Replace LOJA    With aDados[2]
					Replace DATAEM  With aDados[3]
					Replace NUMERO  With aDados[4]
					Replace BANCO   With aDados[5]
					Replace EMISSAO With dEmissao
					Replace VENCTO  With dVencto
					Replace VALOR   With aDados[14+nX]
					Replace BAIXA   With aDados[6]
					Replace HISTOR  With STR0047 + " - " + If(nX=1,"Pis",If(nX=2,"Cofins","Csll")) //Desc.Imposto
					Replace DC      With IIf(aDados[8]=="R","C","D") //Verifico se o titulo eh a pagar ou a receber
					MsUnlock()
				Endif
			Endif
		Next
	Endif
	
	dbSelectArea(cAlias)
Return Nil