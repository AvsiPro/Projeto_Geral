#Include 'protheus.ch'
#Include 'parmtype.ch'

/*/{Protheus.doc} BRINTGCT
description "Rotina para fazer a medição de contrato Utlizando WEBSERVICE"
@type USER function
@version 
@author TOTVS NU
@since 02/07/2020
@return return_type, return_description
/*/
USER function BRINTGCT()

	PRIVATE cAliasCTR   := GETNEXTALIAS()
	PRIVATE aRotina 	:= MENUDEF()
	PRIVATE cCadastro 	:= OEMTOANSI("Medição de Contratos")

	DBSELECTAREA("CN9")
	CN9->( DBSETORDER(01) )

	MBROWSE( 6, 1,22,75,"CN9",,,,,,)

return( .T. )


/*/{Protheus.doc} MENUDEF
description "Definição do Menu" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function MENUDEF()

	LOCAL aRotina := { 	{ OEMTOANSI("Pesquisar") , "AxPesqui"   , 0 , 1 ,,.F. },;
					    { OEMTOANSI("Periodo")   , "U_BRFILGCT" , 0 , 2       },;
					    { OEMTOANSI("Visualizar"), "U_BRVISGCT" , 0 , 3       } }

return( aRotina )


/*/{Protheus.doc} BRFILGCT
description "Função para Informar o Periodo da Medição" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
USER function BRFILGCT(cAlias,nReg,nOpcx)

	LOCAL oPanel := nil
	LOCAL oDlg   := nil
	LOCAL nOpca  := 0
	LOCAL nX     := 0

	PRIVATE dDataDe   := CTOD( SPACE(08) )
	PRIVATE dDataAte  := CTOD( SPACE(08) )

	PRIVATE cTrbCTR   := "TRBCTR" 	//GetNextAlias()
	PRIVATE cNomeARQ  := ""
	PRIVATE cArqIND   := ""

	PRIVATE oTmpCTR   := nil

	PRIVATE aStrBRW   := {}
	PRIVATE aCposBRW  := {}
	PRIVATE aCposCTR  := {}

	//Monta Tela de Parametros
	//------------------------
	define MSDIALOG oDlg from 022,009 to 110,540 TITLE OEMTOANSI("Informe o Periodo da Medição") pixel STYLE DS_MODALFRAME

	oDlg:lMaximized := .F.
	oDlg:lEscClose  := .F.

	oPanel := TPANEL():NEW(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 006, 005 to 038, 223 of oPanel pixel

	@ 012, 012 SAY OEMTOANSI("Data De ") SIZE 55, 07 of oPanel pixel
	@ 012, 066 SAY OEMTOANSI("Data Até") SIZE 55, 07 of oPanel pixel

	@ 022, 012 MSGET dDataDe  Valid if( !EMPTY(dDataDe),.T.,.F.)		                     SIZE 50, 11 of oPanel pixel HASBUTTON
	@ 022, 066 MSGET dDataAte Valid if( !EMPTY(dDataAte) .and. dDataAte >= dDataDe ,.T.,.F.) SIZE 50, 11 of oPanel pixel HASBUTTON

	define SBUTTON from 07, 230 TYPE 1 ACTION ( nOpca := 0, if( CONFIRMA(), nOpca := 1, nOpca := 0 ), oDlg:end()) ENABLE of oDlg
	define SBUTTON from 21, 230 TYPE 2 ACTION ( nOpca := 0, oDlg:end() )                                          ENABLE of oDlg

	activate MSDIALOG oDlg centered

	if nOpca == 0
		return()
	endif

	//Campos da MarkBrowse
	//--------------------
	AADD( aStrBRW, { "cMARK" 	  ,;
					 "CN9_NUMERO" ,;
					 "CN9_DTINIC" ,;
					 "CN9_DTFIM"  ,;
					 "CNA_NUMERO" ,;
					 "CNA_REVISA" ,;
					 "CNA_CLIENT" ,;
					 "CNA_LOJACL" ,;
					 "A1_NOME" 	  ,;
					 "A1_CGC"     } )

	DBSELECTAREA( "SX3" )
	SX3->( DBSETORDER(02) )

	for nX := 01  to LEN( aStrBRW[01] )
		if aStrBRW[01][nX] == "cMARK"
			AADD( aCposBRW, { "cMARK", "", "", SX3->X3_PICTURE } )
			AADD( aCposCTR, { "cMARK", "C", 2, 0 } )
		else
			SX3->( DBSEEK( aStrBRW[01][nx]) )
			AADD( aCposBRW, { ALLTRIM(SX3->X3_CAMPO), "", ALLTRIM(SX3->X3_TITULO) ,SX3->X3_PICTURE } )
			AADD( aCposCTR, { ALLTRIM(SX3->X3_CAMPO), SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		endif
	next nX

	//Deleta Arquivo Temporario caso Exista
	//-------------------------------------
	if oTmpCTR <> nil
		oTmpCTR:DELETE()
	endif

	//Cria o Objeto do FwTemporaryTable
	//oTmpSE1 := FwTemporaryTable():New("TRBSE1")
	//Cria a estrutura do alias temporario
	//oTmpSE1:SetFields(aCampos)
	//Adiciona o indicie na tabela temporaria
	//oTmpSE1:AddIndex("1",{"E1CLINOME","E1PREFIXO","E1NUM","E1PARCELA"})
	//Criando a Tabela Temporaria
	//oTmpSE1:Create()
	//--------------------------------------------------------------------
	oTmpCTR := FWTemporaryTable():NEW(cTrbCTR)
	oTmpCTR:SetFields(aCposCTR)
	oTmpCTR:AddIndex("indice1", {"CN9_NUMERO","CNA_NUMERO"} )
	oTmpCTR:Create()

	//cTrbSE1 := oTmpSE1:GetAlias()
	//cTrbNom := oTmpSE1:GetRealName()

	//Filtra os Registros conforme InformaÃ§ao dos Parametros
	//------------------------------------------------------
	if FILTRACTR()

		//Tela para Marcar os Contratos
		//-----------------------------
		TELAMARK()

		//Gera TÂ´tilos e efetua as baixas
		//-------------------------------
		PROCESSA( {|lEnd| GRMEDCTR()},  "Aguarde...","Gerando Medição...", .T. )

	endif

	oTmpCTR:DELETE()

return()


/*/{Protheus.doc} CONFIRMA
description "Função para confirmar o Periodo da Medição" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function CONFIRMA()

	LOCAL lRet := .T.

	lRet := MSGYESNO( "Confirma Dados?", "Atenção" )

return( lRet )


/*/{Protheus.doc} FILTRACTR
description "Função para Filtrar os Contatos" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function FILTRACTR()

	LOCAL cAliasCTR  := GETNEXTALIAS()
	LOCAL cCN9TPCTO  := "001"
	LOCAL cCN9SITUAC := "05"
	LOCAL lRet       := .T.

	BeginSql Alias cAliasCTR
	 
	//%noParser% 

	COLUMN CN9_DTINIC AS DATE
	COLUMN CN9_DTFIM  AS DATE
	
	SELECT CN9_NUMERO, CN9_DTINIC, CN9_DTFIM, CNA_NUMERO, CNA_REVISA, CNA_CLIENT, CNA_LOJACL, A1_NOME, A1_CGC
	  FROM %TABLE:CN9% CN9 (NOLOCK) 
     INNER JOIN %TABLE:CNA% CNA (NOLOCK)
             ON CNA.%notDel%
            AND CNA.CNA_FILIAL = CN9.CN9_FILIAL
            AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
     INNER JOIN %TABLE:SA1% SA1 (NOLOCK)
             ON SA1.%notDel%
            AND SA1.A1_COD = CNA.CNA_CLIENT
            AND SA1.A1_LOJA = CNA.CNA_LOJACL
 	 WHERE CN9.%notDel% 
       AND CN9.CN9_TPCTO = %EXP:cCN9TPCTO%
	   AND CN9.CN9_SITUAC = %EXP:cCN9SITUAC%
       //AND CN9.CN9_DTINIC >= %EXP:DTOS(dDataDe)%
       //AND CN9.CN9_DTFIM <= %EXP:DTOS(dDataAte)%
     ORDER BY CN9_NUMERO, CNA_NUMERO
			
	EndSql

	//Processando as linhas GetLastQuery()[02]
	//-----------------------------------------
	DBSELECTAREA( cAliasCTR )
	(cAliasCTR)->( DBGOTOP() )
	while (cAliasCTR)->( !EOF() )

		DBSELECTAREA( cTrbCTR )
		(cTrbCTR)->( RECLOCK(cTrbCTR,.T.) )
			(cTrbCTR)->cMARK     := SPACE(02)
			(cTrbCTR)->CN9_NUMERO := (cAliasCTR)->CN9_NUMERO
			(cTrbCTR)->CN9_DTINIC := (cAliasCTR)->CN9_DTINIC
			(cTrbCTR)->CN9_DTFIM  := (cAliasCTR)->CN9_DTFIM
			(cTrbCTR)->CNA_NUMERO := (cAliasCTR)->CNA_NUMERO
			(cTrbCTR)->CNA_REVISA := (cAliasCTR)->CNA_REVISA
			(cTrbCTR)->CNA_CLIENT := (cAliasCTR)->CNA_CLIENT
			(cTrbCTR)->CNA_LOJACL := (cAliasCTR)->CNA_LOJACL
			(cTrbCTR)->A1_NOME    := (cAliasCTR)->A1_NOME
			(cTrbCTR)->A1_CGC     := (cAliasCTR)->A1_CGC
		(cTrbCTR)->( MSUNLOCK() )

		(cAliasCTR)->( DBSKIP() )

	enddo

	//Fechando os Alias
	//-----------------
	(cAliasCTR)->( DBCLOSEAREA() )

	//Valida se encontrou registros
	//-----------------------------
	DBSELECTAREA( cTrbCTR )
	(cTrbCTR)->( DBGOTOP() )
	if (cTrbCTR)->( EOF() )
		MSGALERT( "NÃ£o Foi Localizado Registros com a Data Informada...", "Aviso" )
		lRet := .F.
	endif

return( lRet )


/*/{Protheus.doc} FILTRACTR
description "Função de tela para Selecionar os Contratos" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function TELAMARK()

	LOCAL nOpca     := 0

	PRIVATE cMarca   := GetMark()
	PRIVATE oMark    := nil
	PRIVATE oPanel1  := nil
	PRIVATE oDlgTit  := nil
	PRIVATE lInverte := .F.

	//Deixa Todos Registros Marcados
	//------------------------------
	//MARKCTR(cMarca, .T., "")

	//Monta Browse com os Titulos
	//---------------------------
	define MSDIALOG oDlgTit from 005,001 to 599,1339  TITLE OEMTOANSI("Selecione os Contratos") pixel STYLE DS_MODALFRAME

	oDlgTit:lMaximized := .F.
	oDlgTit:lEscClose  := .F.

	oPanel1 := TPANEL():NEW(0,0,'',oDlgTit,, .T., .T.,, ,20,20)
	oPanel1:Align := CONTROL_ALIGN_ALLCLIENT

	oMark := MSSELECT():NEW( cTrbCTR, "cMARK",, aCposBRW, @lInverte, @cMarca,{ 30, 00, 295, 671 } )
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:bAllMark := { || MARKCTR( cMarca, .T., oMark ) }

	oDlgTit:SetText( OEMTOANSI( "Selecione os Contratos" ) )

	activate MsDialog oDlgTit On Init ENCHOICEBAR( oDlgTit, { || If( VLDMARCA(), ODlgTit:end(), ) }, { || ODlgTit:end() } ) centered

	if nOpca == 0
		lRet := .F.
	else
		lRet := .T.
	endIf

return( lRet )


/*/{Protheus.doc} FILTRACTR
description "Função marcar os desmarcar todos os contratos" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function MARKCTR(cMarca, lTodos, oMark)

	LOCAL nReg := (cTrbCTR)->( RECNO() )

	if lTodos
		(cTrbCTR)->( DBGOTOP() )
	endif

	While !lTodos .or. !(cTrbCTR)->( EOF() )

		if (cTrbCTR)->cMARK == cMARCA
			(cTrbCTR)->( RECLOCK( cTrbCTR, .F. ) )
				(cTrbCTR)->cMARK := SPACE(02)
			(cTrbCTR)->( MSUNLOCK() )
		else
			(cTrbCTR)->( RECLOCKk( cTrbCTR, .F. ) )
				(cTrbCTR)->cMARK := cMarca
			(cTrbCTR)->( MSUNLOCK() )
		endif

		if lTodos
			(cTrbCTR)->( DBSKIP() )
		else
			exit
		endif

	enddo

	(cTrbCTR)->( DBGOTO(nReg) )

return( nil )


/*/{Protheus.doc} FILTRACTR
description "Função Valida se algum contrato foi selecionado" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function VLDMARCA()

	LOCAL lRet  := .F.
	LOCAL aArea := (cTrbCTR)->( GETAREA() )

	DBSELECTAREA(cTrbCTR)
	(cTrbCTR)->( DBGOTOP() )
	while (cTrbCTR)->( !EOF() )

		if !Empty((cTrbCTR)->cMARK)
			lRet := .T.
			exit
		endif

		(cTrbCTR)->( DBSKIP() )

	enddo

	if !lRet
		MSGALERT( "Necessario selecionar um Contrato !!!", "Aviso" )
	endif

	RESTAREA( aArea )

return( lRet )

/*/{Protheus.doc} GRMEDCTR
description "Função Identifica Contratos Selecionado" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function GRMEDCTR()

	LOCAL cA1CGC  := ""
	LOCAL aMedCTR := {}

	//Le Registros a Faturar
	//----------------------
	DBSELECTAREA( cTrbCTR )
	(cTrbCTR)->( DBSETORDER(01) )
	(cTrbCTR)->( DBGOTOP() )

	PROCREGUA( (cTrbCTR)->(RECCOUNT()) )

	while (cTrbCTR)->( !EOF() )

		//VALIDA SE REGISTRO ESTA MARCADO
		//-------------------------------
		if EMPTY( (cTrbCTR)->cMARK )
			(cTrbCTR)->( DBSKIP() )
			loop
		endif

		cA1CGC := (cTrbCTR)->A1_CGC

		aMEDCTR := BRWSCTR(cA1CGC)

		if LEN(aMEDCTR) > 0
			VALIDACTR(aMEDCTR)
		endif

		(cTrbCTR)->( DBSKIP() )

	ENDDO

return()


/*/{Protheus.doc} BRWSCTR
description "Função Consulta Medição WBSERVICE" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function BRWSCTR(cA1CGC)

	LOCAL oWS  := nil
	LOCAL oRet := nil
	LOCAL aRetorno := {}

	LOCAL cUsuario := "integra.erp.totvs"
	LOCAL cSenha   := "3ZSQ9U9Y4PSD"

	LOCAL cCNPJ        := "006888683000141" //	cA1CGC
	LOCAL cDataInicio  := SUBSTR(DTOS(dDataDe),1,4)  + "-" + SUBSTR(DTOS(dDataDe),5,2)  + "-" + SUBSTR(DTOS(dDataDe),7,2)  + " " + "00:00"  //"2020-01-01 00:00"
	LOCAL cDataTermino := SUBSTR(DTOS(dDataAte),1,4) + "-" + SUBSTR(DTOS(dDataAte),5,2) + "-" + SUBSTR(DTOS(dDataAte),7,2) + " " + "00:00"  //"2020-02-01 00:00"

   
	oWS	:= WSEebServiceCTR():New()
	oWS:BuscarDadosTotvsBR( cUsuario,cSenha,cCNPJ,cDataInicio,cDataTermino )

	oRet := oWS:oWSRetornoIntegracaoTotvsBR

	if oRet:CMENSAGEMDERETORNO == "OK"
		AADD( aRetorno,{ "NLIBERACOES"                             , oRet:NLIBERACOES                             , "" } )
		AADD( aRetorno,{ "NPERIODOFATURAMENTOCOMPLEMENTARMOTORISTA", oRet:NPERIODOFATURAMENTOCOMPLEMENTARMOTORISTA, "SV0000000000047" } )
		AADD( aRetorno,{ "NPERIODOFATURAMENTOCOMUMMOTORISTA"       , oRet:NPERIODOFATURAMENTOCOMUMMOTORISTA       , "SV0000000000044" } )
		AADD( aRetorno,{ "NPERIODOFATURAMENTOVEICULO"              , oRet:NPERIODOFATURAMENTOVEICULO              , "SV0000000000045" } )
		AADD( aRetorno,{ "NPERIODOSOLICITANTECOMPLEMENTARMOTORISTA", oRet:NPERIODOSOLICITANTECOMPLEMENTARMOTORISTA, "SV0000000000004" } )
		AADD( aRetorno,{ "NPERIODOSOLICITANTECOMUMMOTORISTA"       , oRet:NPERIODOSOLICITANTECOMUMMOTORISTA       , "SV0000000000001" } )
		AADD( aRetorno,{ "NPERIODOSOLICITANTEVEICULO"              , oRet:NPERIODOSOLICITANTEVEICULO              , "SV0000000000002" } )
		AADD( aRetorno,{ "NTOTALVIAGENS"                           , oRet:NTOTALVIAGENS                           , "" } )
		AADD( aRetorno,{ "NVEICULOSFROTA"                          , oRet:NVEICULOSFROTA                          , "SV0000000000027" } )
		AADD( aRetorno,{ "NVIAGENSAVULSAS"                         , oRet:NVIAGENSAVULSAS                         , "SV0000000000028" } )
		AADD( aRetorno,{ "NVIAGENSTELEMONITORADAS"                 , oRet:NVIAGENSTELEMONITORADAS                 , "SV0000000000046" } )
	endif

return( aRetorno )


/*/{Protheus.doc} VALIDACTR
description "Função Produtod retornados do WBSERVICE" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function VALIDACTR(aMedCTR)

	LOCAL aCabCND    := {}
	LOCAL aItemCNE   := {}
	LOCAL aItemCXN   := {}
	LOCAL aContrato  := {}
	LOCAL aPlanilha  := {}
	LOCAL aProduto   := {}
	LOCAL aProdCTR   := {}
	LOCAL aIntWeb    := {}

	LOCAL cNumMed    := ""
	LOCAL cNrContra  := (cTrbCTR)->CN9_NUMERO
	LOCAL cNrRevisa  := (cTrbCTR)->CNA_REVISA
	LOCAL cNrPlan    := (cTrbCTR)->CNA_NUMERO
	LOCAL cCompet    := SPACE(TAMSX3("CND_COMPET")[1])
	LOCAL cMoeda     := SPACE(TAMSX3("CND_MOEDA" )[1])
	LOCAL cNrParcel  := SPACE(TAMSX3("CND_PARCEL")[1])
	LOCAL cItem      := SPACE(TAMSX3("CNE_ITEM"  )[1])
	LOCAL cProduto   := SPACE(TAMSX3("CNE_PRODUT")[1])
	LOCAL cTesSaida  := SPACE(TAMSX3("CNE_TS"    )[1])
	LOCAL dDtEnt     := SPACE(TAMSX3("CNE_DTENT" )[1])

	LOCAL nQuant     := 0
	LOCAL nVlUnit    := 0
	LOCAL nVlTotal   := 0
	LOCAL nPos       := 0
	LOCAL nX         := 0
	LOCAL nY         := 0

	LOCAL lRet       := .T.

	//Adiciona Contrato e Revisao
	//---------------------------
	AADD( aContrato, cNrContra )
	AADD( aContrato, cNrRevisa )

	//Adiciona Planilha
	//-----------------	
	AADD( aPlanilha, cNrPlan )

	//Busca Produtos no Contrato
	//--------------------------
	aProdCTR := VLDPRDCTR()

	for nX := 1 to LEN( aProdCTR)

		cProduto := aProdCTR[nX][1]

		//Pesquisa Produto no WS
		//----------------------
		nPos := ASCAN( aMedCTR, {|x| ALLTRIM(x[3]) == ALLTRIM(cProduto) } )

		//Adiciona Produtos
		//-----------------
		if nPos > 0
			//Valida se quanridade retornada da consulta Maior que Zero
			//---------------------------------------------------------
			if aMedCTR[nPos][2] > 0
				AADD( aProduto, { aMedCTR[nPos][3], aMedCTR[nPos][2] } )
			endif
		endif

	next nX

	if LEN(aProduto) == 0
		MSGALERT( "Produtos Retornado na Consulta não Consta no Contrato??", "AVISO" )
		return()
	endif

	AADD( aIntWeb, { aContrato, aPlanilha, aProduto } )

	//Inicia pelo CONTRATO
	//--------------------
	for nX := 1 to LEN(aIntWeb)

		lRet      := .T.
		cNrContra := aIntWeb[nX][01][01]
		cNrRevisa := aIntWeb[nx][01][02]

		//Pesquisa Contrato - CN9
		//-----------------------
		DBSELECTAREA("CN9")
		CN9->( DBSETORDER( 01 ) )
		if !CN9->( DBSEEK( xFILIAL("CN9") + cNrContra + cNrRevisa ) )
			MSGINFO("Numero de Contrato: " + cNrContra + " Nãoo Localizado!!!", "AVISO")
			lRet := .F.
		else
			//Situação do Contrato
			//--------------------
			if CN9->CN9_SITUAC <> "05"
				MSGINFO("Contrato nãp esta em VIGÊNCIA", "AVISO" )
				lRet := .F.
			endif

			if lRet
				//Especie do Contrato ('1'-Compra '2'-Venda)
				//------------------------------------------
				if CN9->CN9_ESPCTR <> "2"
					MSGINFO("Contrato não se refere a VENDAS", "AVISO" )
					lRet := .F.
				endif
			endif
		endif

		if lRet

			cCompet   := SUBSTR(DTOS(CN9->CN9_DTINIC),5,2) + "/" + SUBSTR(DTOS(CN9->CN9_DTINIC),1,4)
			CMoeda    := "01"

			cNrPlan   := aIntWeb[nX][02][01]
			aPlanilha := aIntWeb[nX][02]
			aProduto  := aIntWeb[nX][03]

			cItem     := "000"

			//Pesquisa CabeÃ§alho da Planilha - CNA
			//-------------------------------------
			DBSELECTAREA("CNA")
			CNA->( DBSETORDER( 01 ) )
			if !CNA->( DBSEEK( xFILIAL("CNA") + CN9->CN9_NUMERO + CN9->CN9_REVISA + cNrPlan ) )
				MSGINFO("Planilha: " + cNrPlan + " Não Localizada", "AVISO")
				lRet := .F.
			else
				//Pesquisa Cliente (SA1)
				//----------------------
				DBSELECTAREA("SA1")
				SA1->( DBSETORDER( 01 ) )
				if !SA1->( DBSEEK( xFILIAL("SA1") + CNA->CNA_CLIENT + CNA->CNA_LOJACL ) )
					MSGINFO("Cliente/Loja: " + ALLTRIM(CNA->CNA_CLIENT) + "-" + ALLTRIM(CNA->CNA_LOJACL) + " Não Localizado", "AVISO")
					lRet := .F.
				else
					//Valida de Cliente esta Bloqueado
					//--------------------------------
					if SA1->A1_MSBLQL == "1"
						MSGINFO("Cliente/Loja: " + ALLTRIM(SA1->A1_COD) + "-" + ALLTRIM(SA1->A1_LOJA) + " Esta Bloqueado", "AVISO")
						lRet := .F.
					endif
				endif

				if lRet

					cNumMed := CRIAVAR("CND_NUMMED")

					//Carrega CabeÃ§alho das Medições
					//-------------------------------
					aCabCND := {}
					AADD( aCabCND, { "CND_NUMMED", cNumMed  , nil } )
					AADD( aCabCND, { "CND_CONTRA", cNrContra, nil } )
					AADD( aCabCND, { "CND_REVISA", cNrRevisa, nil } )
					AADD( aCabCND, { "CND_COMPET", cCompet  , nil } )
					AADD( aCabCND, { "CND_NUMERO", cNrPlan  , nil } )
					if !EMPTY(CND->(FIELDPOS("CND_PARCEL")))
						AADD( aCabCND, { "CND_PARCEL", cNrParcel, nil } )
					endif
					AADD( aCabCND, { "CND_MOEDA", cMoeda, nil } )
					AADD( aCabCND, { "CND_SERVIC", "1", nil } )

				endif

			endif

		endif

		if lRet

			for nY := 1 to LEN(aProduto)

				cProduto := aProduto[nY][01]
				nQuant   := aProduto[nY][02]

				//Pesquisa Itens da Planilha - CNB
				//--------------------------------
				DBSELECTAREA("CNB")
				CNB->( DBSETORDER( 04 ) )
				if !CNB->( DBSEEK( xFILIAL("CNB") + CN9->CN9_NUMERO + cNrPlan + cProduto ) )
					MSGINFO("Produto na Planilha não localizado", "AVISO")
					lRet := .F.
				else
					//Valida a Quantidade
					//-------------------
					if nQuant + CNB->CNB_QTDMED > CNB->CNB_QUANT
						MSGINFO("Quantidade Informada Ultrapassa a Quantidade das Medições", "AVISO")
						lRet := .F.
					endif

					if lRet
						//Array dos Itens
						//---------------
						cItem     := SOMA1(cItem)
						nVlUnit   := CNB->CNB_VLUNIT
						nVlTotal  := nQuant * nVlUnit
						dDtEnt    := dDATABASE
						cTesSaida := CNB->CNB_TS

						//Carrega Itens das Mediçõrs
						//--------------------------
						AADD( aItemCNE, {} )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_ITEM"  , cItem    , nil } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_PRODUT", cProduto , nil } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_QUANT" , nQuant   , nil } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_VLUNIT", nVlUnit  , nil } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_VLTOT" , nVlTotal , nil } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_DTENT" , dDATABASE, nil } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_TS"    , cTesSaida, nil } )

						//Carrega Itens Planilha Medição de Contratos
						//-------------------------------------------
						AADD( aItemCXN, {} )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_CHECK"  , .T.       , nil } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_CONTRA" , cNrContra , nil } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_REVISA" , cNrRevisa , nil } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_NUMMED" , cNumMed   , nil } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_NUMPLA" , cNrPlan   , nil } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_PARCEL" , cNrParcel , nil } )

					endif
				
				endif

			next nY

			if lRet
				//Processa Medicao - CNTA120
				//MSGRUN("Aguarde, Processsando Medição... ", "SIGAGCT", {|| GRVMED120(aCabCND,aItemCNE)}) //SIGAGCT - Aguarde, processsando MediÃ§Ã£o...
				GRVMED120(aCabCND,aItemCNE)

				//Processa Medicao - CNTA121
				//GERMED121(aCabCND, aItemCNE, aItemCXN)
			endif

		endif

	next nX

return()


/*/{Protheus.doc} GRVMED120
description "Função Gera Medição via EXECAUTO CNTA120" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function GRVMED120(aCab,aItens)

	LOCAL aArea := GETAREA()

	PRIVATE lMsErroAuto := .F.

	//Gera a Medição
	//--------------
	MSEXECAUTO({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,3)

	if lMsErroAuto
		MOSTRAERRO()
	endif

	//Encerra a Medição
	//-----------------
	if !lMsErroAuto

		MSEXECAUTO({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,6)

		if lMsErroAuto
			MOSTRAERRO()
		else
			MSGINFO( "Contrato: " + aCab[2][2]  + CRLF + CRLF + ;
				"Medição.: " + aCab[1][2]  + CRLF + CRLF + ;
				"Pedido..: " + SC5->C5_NUM + CRLF + CRLF + ;
				"Foram Gerados com SUCESSO..." )
		endif

	endif

	RESTAREA(aArea)

return()


/*/{Protheus.doc} GERMED121
description "Função Gera Medição via EXECAUTO CNTA121" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function GERMED121(_aCabec, _aItCNE, _aItCXN)

	LOCAL oModel  := nil
	LOCAL aError  := {}
	LOCAL _lOk	  := .F.
	LOCAL cErro   := ""
	LOCAL _nx     := 0

	PRIVATE cFilCtr := ""
	PRIVATE lAuto   := .F.

	//Manter a compatibilidade com o execauto CTNA121
	//-----------------------------------------------
	cFilCtr	:= cFilAnt

	oModel 	:= FWLoadModel("CNTA121")
	oModel:SetOperation(3)
	oModel:activate()

	for _nx := 1 to Len(_aCabec)

		if !EMPTY(_aCabec[_nx,2])
			oModel:SetValue("CNDMASTER",_aCabec[_nx,1],_aCabec[_nx,2])
		endif

	next

	//CXN
	oModel := PROCITENS(oModel,'CXNDETAIL',_aItCXN)

	//CNE
	oModel := PROCITENS(oModel,'CNEDETAIL',_aItCNE)

	IF oModel:VldData()
		oModel:CommitData()
		_lOk := .T.
	else
		aError := oModel:GetErrorMessage()

		for _nx := 1 to LEN(aError)
			cErro += if( VALTYPE(aError[_nx]) == "C", aError[_nx]+CRLF, "" )
		next
		ConOut('Erro:' + ALLTRIM(cErro))
	endif

	oModel:DeActivate(.T.)

	if _lOk
		//cNumMed := CND->CND_NUMMED
		// oModel:DeActivate()
		_lOk := CN121Encerr(.T.) //Realiza o encerramento da mediÃ§Ã£o
	endif

return( _lOk )


/*/{Protheus.doc} PROCITENS
description 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function PROCITENS(oModel,_cDetail,_aItem)

	LOCAL _nx, _ny

	for _nx := 1 to LEN(_aItem)
		for _ny := 1 to LEN(_aItem[_nx])

			if !EMPTY(_aItem[_nx,_ny,2])
				oModel:SetValue(_cDetail,_aItem[_nx,_ny,1],_aItem[_nx,_ny,2])
			endif
		next
	next

return( oModel )


/*/{Protheus.doc} PROCITENS
description Função Retorna os Produtos da Planilha
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function VLDPRDCTR()

	LOCAL cAliasCNB  := GETNEXTALIAS()
	LOCAL cCNBCONTRA := (cTrbCTR)->CN9_NUMERO
	LOCAL cCNBNUMERO := (cTrbCTR)->CNA_NUMERO
	LOCAL aRetorno   := {}

	BeginSql Alias cAliasCNB
	 
	//%noParser% 

	COLUMN CN9_DTINIC AS DATE
	COLUMN CN9_DTFIM  AS DATE
	
	SELECT CNB_CONTRA, CNB_NUMERO, CNB_ITEM, CNB_PRODUT, CNB_QUANT
	  FROM %TABLE:CNB% CNB (NOLOCK) 
 	 WHERE CNB.%notDel% 
       AND CNB.CNB_CONTRA = %EXP:cCNBCONTRA%
       AND CNB.CNB_NUMERO = %EXP:cCNBNUMERO%
     ORDER BY CNB_NUMERO, CNB_ITEM
			
	EndSql

	//Processando as linhas GetLastQuery()[02]
	//----------------------------------------
	DBSELECTAREA( cAliasCNB )
	(cAliasCNB)->( DBGOTOP() )
	while (cAliasCNB)->( !EOF() )

		AADD( aRetorno, { (cAliasCNB)->CNB_PRODUT } )

		(cAliasCNB)->( DBSKIP() )

	enddo

	//Fechando os Alias
	//-----------------
	(cAliasCNB)->( DBCLOSEAREA() )

return( aRetorno )

