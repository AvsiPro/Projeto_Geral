#Include 'protheus.ch'
#Include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

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
	PRIVATE cContratD := Space(15)
	PRIVATE cContratA := Space(15)

	PRIVATE cTrbCTR   := "TRBCTR" 	//GetNextAlias()
	PRIVATE cNomeARQ  := ""
	PRIVATE cArqIND   := ""

	PRIVATE oTmpCTR   := nil

	PRIVATE aStrBRW   := {}
	PRIVATE aCposBRW  := {}
	PRIVATE aCposCTR  := {}

	//Monta Tela de Parametros
	//------------------------
	define MSDIALOG oDlg from 022,009 to 210,540 TITLE OEMTOANSI("Informe o Periodo da Medição") pixel STYLE DS_MODALFRAME

	oDlg:lMaximized := .F.
	oDlg:lEscClose  := .F.

	oPanel := TPANEL():NEW(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 006, 005 to 078, 223 of oPanel pixel

	@ 012, 012 SAY OEMTOANSI("Data De ") SIZE 55, 07 of oPanel pixel
	@ 012, 066 SAY OEMTOANSI("Data Até") SIZE 55, 07 of oPanel pixel

	@ 022, 012 MSGET dDataDe  Valid if( !EMPTY(dDataDe),.T.,.F.)		                     SIZE 50, 11 of oPanel pixel HASBUTTON
	@ 022, 066 MSGET dDataAte Valid if( !EMPTY(dDataAte) .and. dDataAte >= dDataDe ,.T.,.F.) SIZE 50, 11 of oPanel pixel HASBUTTON

	@ 042, 012 SAY OEMTOANSI("Contrato De: ") SIZE 55, 07 of oPanel pixel
	@ 042, 066 SAY OEMTOANSI("Contrato Até") SIZE 55, 07 of oPanel pixel

	@ 052, 012 MSGET cContratD  SIZE 50, 11  F3 "CN9" of oPanel pixel HASBUTTON
	@ 052, 066 MSGET cContratA  SIZE 50, 11  F3 "CN9" of oPanel pixel HASBUTTON

	define SBUTTON from 07, 230 TYPE 1  ACTION ( nOpca := 0, if( CONFIRMA(), nOpca := 1, nOpca := 0 ), oDlg:end()) ENABLE of oDlg
	define SBUTTON from 21, 230 TYPE 2  ACTION ( nOpca := 0, oDlg:end() )   
	//define SBUTTON from 35, 230 TYPE 15 ACTION ( nOpca := 2, GdSeek(oDlg,"Busca Itens",oDlg:aStrBRW,oDlg:aCposCTR,If(Type("oGetItens:aIniCpos")=="A",.T.,)) oDlg:end() ) , , oDlg:end()) ENABLE of oDlg 


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
	oTmpCTR:AddIndex("01", {"CN9_NUMERO"} )
	oTmpCTR:AddIndex("02", {"CN9_NUMERO","CNA_NUMERO"} )
	oTmpCTR:AddIndex("03", {"CNA_CLIENT","CNA_LOJACL"} )
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
	LOCAL cCN9ESPCTR  := "2"
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
		AND CNA.CNA_REVISA = CN9.CN9_REVISA
		AND CNA.CNA_TIPPLA IN (SELECT   CNL.CNL_CODIGO
    						FROM    %Table:CNL% CNL
    						WHERE   CNL.%NotDel%
    						AND     CNL.CNL_FILIAL = %xFilial:CNL%
    						AND     CNL.CNL_CTRFIX = '3' )
		INNER JOIN %TABLE:SA1% SA1 (NOLOCK)
		ON SA1.%notDel%
		AND SA1.A1_COD = CNA.CNA_CLIENT
		AND SA1.A1_LOJA = CNA.CNA_LOJACL
		AND SA1.A1_MSBLQL <> '1'
		WHERE CN9.%notDel% 
		AND CN9.CN9_FILIAL = %xfilial:CN9%
		AND CN9.CN9_ESPCTR = %EXP:cCN9ESPCTR%
		AND CN9.CN9_SITUAC = %EXP:cCN9SITUAC%
		AND (CN9.CN9_REVATU = '  '  OR  CN9.CN9_REVATU = '')  
		AND CN9.CN9_DTINIC <= %EXP:DTOS(dDataAte)%
		AND CN9.CN9_DTFIM > %EXP:DTOS(dDataDe)% 
		AND CN9.CN9_NUMERO >= %EXP:cContratD%
		AND CN9.CN9_NUMERO <= %EXP:cContratA%
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
	PRIVATE aBotoes  := {}

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
	
	//aAdd(aSeek,{"Contrato"    ,{{"","C",050,0,"Nome"    ,"@!"}} } )

	oMark:= MSSELECT():NEW( cTrbCTR, "cMARK",, aCposBRW, @lInverte, @cMarca,{ 30, 00, 295, 671 } ) //FWMarkBrowse():New()//
	/*oMark:SetAlias((cTrbCTR))
	oMark:SetFieldMark("cMARK") 
	oMark:SetTemporary()
	//oMark:SetColumns(aCposCTR)
	oMark:SetSeek(.T.)
	oMark:bAllMark := { || MARKCTR( cMarca, .T., oMark )}
	oMark:Activate()*/
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:bAllMark := { || MARKCTR( cMarca, .T., oMark )}


	oDlgTit:SetText( OEMTOANSI( "Selecione os Contratos" ) )

	//AAdd(aBotoes,{"BMPCONS",{|| GdSeek(oTmpCTR,"Busca Itens",,cTrbCTR,,,,) },"Procurar"} )

	activate MsDialog oDlgTit On Init ENCHOICEBAR( oDlgTit, { || If( VLDMARCA(), ODlgTit:end(), ) }, { || ODlgTit:end() }) centered

	
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
			(cTrbCTR)->( RECLOCK( cTrbCTR, .F. ) )
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
	LOCAL nNx      := 0

	LOCAL cUsuario := "integra.erp.totvs"
	LOCAL cSenha   := "3ZSQ9U9Y4PSD"
	LOCAL cMsg     := ''

	LOCAL cCNPJ        := cA1CGC
	LOCAL cDataInicio  := SUBSTR(DTOS(dDataDe),1,4)  + "-" + SUBSTR(DTOS(dDataDe),5,2)  + "-" + SUBSTR(DTOS(dDataDe),7,2)  + " " + "00:00"  //"2020-01-01 00:00"
	LOCAL cDataTermino := SUBSTR(DTOS(dDataAte),1,4) + "-" + SUBSTR(DTOS(dDataAte),5,2) + "-" + SUBSTR(DTOS(dDataAte),7,2) + " " + "23:59"  //"2020-02-01 00:00"


	oWS	:= WSEebServiceCTR():New()
	oWS:BuscarDadosTotvsBR( cUsuario,cSenha,cCNPJ,cDataInicio,cDataTermino )

	oRet := oWS:oWSRetornoIntegracaoTotvsBR

	if oRet:CMENSAGEMDERETORNO == "OK"
		AADD( aRetorno,{ "NLIBERACOES"                             , oRet:NLIBERACOES                             , "" } )
		AADD( aRetorno,{ "NPERIODOFATURAMENTOCOMPLEMENTARMOTORISTA", oRet:NPERIODOFATURAMENTOCOMPLEMENTARMOTORISTA, "SV0000000000047" } )
		AADD( aRetorno,{ "NPERIODOFATURAMENTOCOMUMMOTORISTA"       , oRet:NPERIODOFATURAMENTOCOMUMMOTORISTA       , "SV0000000000044" } )//"SV0000000000044" } )
		AADD( aRetorno,{ "NPERIODOFATURAMENTOVEICULO"              , oRet:NPERIODOFATURAMENTOVEICULO              , "SV0000000000044" } )//"SV0000000000044" } )
		AADD( aRetorno,{ "NPERIODOSOLICITANTECOMPLEMENTARMOTORISTA", oRet:NPERIODOSOLICITANTECOMPLEMENTARMOTORISTA, "SV0000000000004" } )
		AADD( aRetorno,{ "NPERIODOSOLICITANTECOMUMMOTORISTA"       , oRet:NPERIODOSOLICITANTECOMUMMOTORISTA       , "SV0000000000001" } )
		AADD( aRetorno,{ "NPERIODOSOLICITANTEVEICULO"              , oRet:NPERIODOSOLICITANTEVEICULO              , "SV0000000000001" } )
		AADD( aRetorno,{ "NTOTALVIAGENS"                           , oRet:NTOTALVIAGENS                           , "" } )
		AADD( aRetorno,{ "NVEICULOSFROTA"                          , oRet:NVEICULOSFROTA                          , "SV0000000000027" } )
		AADD( aRetorno,{ "NVIAGENSAVULSAS"                         , oRet:NVIAGENSAVULSAS                         , "SV0000000000028" } )
		AADD( aRetorno,{ "NVIAGENSTELEMONITORADAS"                 , oRet:NVIAGENSTELEMONITORADAS                 , "SV0000000000046" } )
		AADD( aRetorno,{ "NLIBERACOESTRANSPORTADORES"              , oRet:NLIBERACOESTRANSPORTADORES               , "SV0000000000021" } )
	endif

	/*cMsg := ''

	For nNx :=1 to len(aRetorno)
	
		cMsg += aRetorno[nNx][1] + " Qtd: " + Alltrim(str(aRetorno[nNx][2])) + " Prd.: " + aRetorno[nNx][3] + Chr(13) + Chr(10)

	Next nNx	

	U_zMsgLog(cMsg , "RETORNO BRSYSTEM ")*/

return( aRetorno )


/*/{Protheus.doc} VALIDACTR
description "Função Produtos retornados do WBSERVICE" 
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function VALIDACTR(aMedCTR)

	LOCAL aContrato  := {}
	LOCAL aPlanilha  := {}
	LOCAL aProduto   := {}
	LOCAL aProdutos  := {}
	LOCAL aProdCTR   := {}
	LOCAL aIntWeb    := {}

	LOCAL cNumMed    := ""

	LOCAL cNrContra  := (cTrbCTR)->CN9_NUMERO
	LOCAL cNrRevisa  := (cTrbCTR)->CNA_REVISA
	LOCAL cNrPlan    := (cTrbCTR)->CNA_NUMERO
	LOCAL cCompet    := SPACE(TAMSX3("CND_COMPET")[1])
	LOCAL cMoeda     := SPACE(TAMSX3("CND_MOEDA" )[1])
	LOCAL cProduto   := SPACE(TAMSX3("CNE_PRODUT")[1])

	LOCAL nQuant     := 0
	LOCAL nX         := 0
	LOCAL nY         := 0
	Local nNx        := 0
	Local nCont      := 0

	LOCAL lRet       := .T.
	LOCAL cMsg       := ''
	

	//Adiciona Contrato e Revisao
	//---------------------------
	AADD( aContrato, cNrContra )
	AADD( aContrato, cNrRevisa )

	//Adiciona Planilha
	//-----------------	
	AADD( aPlanilha, cNrPlan )

	//Busca Produtos no Contrato
	//--------------------------
	aProdCTR := VLDPRDCTR(cNrContra,cNrRevisa,cNrPlan )

	for nX := 1 to LEN( aProdCTR)

		cProduto := aProdCTR[nX][1]

		For nNx := 1 to len(aMedCTR)
		
			If aMedCTR[nNx][3] == cProduto
				linc := .F.

				//If aMedCTR[nNx][2] > 0
					//Pesquisa Produto no WS
					//----------------------
					For nCont := 1 to Len(aProdutos)
						If Alltrim(aProdutos[nCont][1]) == Alltrim(aMedCTR[nNx][3])
							linc := .T. 

							If aProdutos[nCont][2] < aMedCTR[nNx][2]
								aProdutos[nCont][2] := aMedCTR[nNx][2]
							EndIf
						Endif
					Next nCont	

					If !lInc 

						AADD( aProdutos, { aMedCTR[nNx][3], aMedCTR[nNx][2], aProdCTR[nX][2], aProdCTR[nX][3], aProdCTR[nX][4], aProdCTR[nX][5]} )	

					EndIf

				//EndIf	

			EndIf	

		Next nNx	

	
	next nX

	
	//cMsg := ''

	For nNx := 1 to len(aProdutos)
		If aProdutos[nNx][2] > 0 .or. aProdutos[nNx][5] > 0
			aadd(aProduto,{ aProdutos[nNx][1], aProdutos[nNx][2], aProdutos[nNx][3], aProdutos[nNx][4], aProdutos[nNx][5], aProdutos[nNx][6]})
		EndIf	
	Next nNx

	/*For nNx :=1 to len(aProduto)
	
		cMsg += aProduto[nNx][1] + " Qtd: " + Alltrim(str(aProduto[nNx][2])) + " Min. qtd: " + Alltrim(str(aProduto[nNx][5])) + Chr(13) + Chr(10)

	Next nNx	

	U_zMsgLog(cMsg , "RETORNO PROTHEUS ")*/



	if LEN(aProduto) == 0
		//MSGALERT( "Produtos retornado na consulta não constam no contrato!", "AVISO" )
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
			MSGINFO("Numero de Contrato: " + cNrContra + " Não Localizado!!!", "AVISO")
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

			cCompet   := SUBSTR(DTOS(dDataDe),5,2)  + "/" + SUBSTR(DTOS(dDataDe),1,4)//SUBSTR(DTOS(CN9->CN9_DTINIC),5,2) + "/" + SUBSTR(DTOS(CN9->CN9_DTINIC),1,4)
			CMoeda    := "01"

			cNrPlan   := aIntWeb[nX][02][01]
			aPlanilha := aIntWeb[nX][02]
			aProduto  := aIntWeb[nX][03]


			//Pesquisa CabeÃ§alho da Planilha - CNA
			//-------------------------------------
			DBSELECTAREA("CNA")
			CNA->( DBSETORDER( 01 ) )
			if !CNA->( DBSEEK( xFILIAL("CNA") + CN9->CN9_NUMERO + CN9->CN9_REVISA + cNrPlan ) )
				MSGINFO("Planilha: " + cNrPlan + " Não Localizada", "AVISO")
				lRet := .F.
			else
				DBSELECTAREA("CNL")
				CNL->(DbSetOrder(1))
				CNL->( DBSEEK( xFILIAL("CNL") + CNA->CNA_TIPPLA ))
				If CNL->CNL_CTRFIX <> '3'
					lRet := .F.
				EndIf	
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
						//MSGINFO("Cliente/Loja: " + ALLTRIM(SA1->A1_COD) + "-" + ALLTRIM(SA1->A1_LOJA) + " Esta Bloqueado", "AVISO")
						lRet := .F.
					endif
				endif

				if lRet

					CN9->(DbSetOrder(1))
         
    				If CN9->( DBSEEK( xFILIAL("CN9") + cNrContra + cNrRevisa ) )//Posicionar na CN9 para realizar a inclusão
        				
						//aCompets := CtrCompets()
 
        				//nCompet := aScan(aCompets, {|x| AllTrim(x) == cCompet })

						oModel := FWLoadModel("CNTA121")
						oModel:SetOperation(MODEL_OPERATION_INSERT)
        				If(oModel:CanActivate())           
            				oModel:Activate()
            				oModel:SetValue("CNDMASTER","CND_CONTRA"    ,CN9->CN9_NUMERO)
							oModel:SetValue("CNDMASTER","CND_REVISA"    ,cNrRevisa      )
							oModel:SetValue("CNDMASTER","CND_COMPET"    ,cCompet        )
							oModel:SetValue("CNDMASTER","CND_NUMERO"    ,cNrPlan       )//Selecionar competência
							oModel:SetValue("CNDMASTER","CND_XPERIO"    ,'Periodo de '+substr(dtos(dDataDe),7,2) + "/" + substr(dtos(dDataDe),5,2) + "/" + substr(dtos(dDataDe),1,4)+ ' até '+substr(dtos(dDataAte),7,2) + "/" + substr(dtos(dDataAte),5,2) + "/" + substr(dtos(dDataAte),1,4)      )
							oModel:SetValue("CNDMASTER","CND_XCLINM"    ,ALLTRIM(SA1->A1_NOME)       )
							oModel:SetValue("CNDMASTER","CND_XNOMRE"    ,ALLTRIM(SA1->A1_NREDUZ)       )

							oModel:GetModel("CXNDETAIL"):GoLine(VAL(ALLTRIM(cNrPlan)))
							oModel:SetValue("CXNDETAIL","CXN_CHECK" , .T.)//Marcar a planilha(nesse caso apenas uma)
							
							for nY := 1 to LEN(aProduto)

								cProduto := aProduto[nY][01]
								nQuant   := aProduto[nY][02]
								nItem    := aProduto[nY][03]
								nVlrUnt  := aProduto[nY][04]
								nQmin    := aProduto[nY][05]
								ntabPrc  := aProduto[nY][06]

								If nQmin > nQuant
									nQuant := nQmin
								EndIf  


								oModel:GetModel('CNEDETAIL'):GoLine(val(nItem))//oModel:SetValue( 'CNEDETAIL' , 'CNE_ITEM'   , nItem)
								oModel:SetValue('CNEDETAIL' , 'CNE_PRODUT'  , cProduto  )
            					oModel:SetValue('CNEDETAIL' , 'CNE_QUANT'   , nQuant    )
								oModel:SetValue('CNEDETAIL' , 'CNE_TABPRC'  , ntabPrc   )

							Next nY	
             
           					 If (oModel:VldData()) /*Valida o modelo como um todo*/
               					 oModel:CommitData()
           					 EndIf
        				EndIf
         
       					If(oModel:HasErrorMessage())
            				aErro := oModel:GetErrorMessage()
							//Alert('Erro: ' + AllToChar( aErro[6] + ' '+ AllToChar( aErro[4] + Dtoc(DATE())+' - '+Time())))
        				Else
            				cNumMed := CND->CND_NUMMED          
           					oModel:DeActivate()        
            				lRet := CN121Encerr(.T.) //Realiza o encerramento da medição                  
        				EndIf
   					EndIf
				EndIf 
			EndIf	
		EndIf	
		cQuer := " Select CNE.CNE_ITEM, CNE.R_E_C_N_O_ AS REC "
		cQuer += " FROM " + RETSQLNAME()
			     
	next nX

return()

/*/{Protheus.doc} VLDPRDCTR
description Função Retorna os Produtos da Planilha
@type STATIC function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@return return_type, return_description
/*/
STATIC function VLDPRDCTR(cNrContra,cNrRevisa,cNrPlan )

	LOCAL cAliasCNB  := GETNEXTALIAS()
	LOCAL cCNBCONTRA := cNrContra
	LOCAL cCNBNUMERO := cNrPlan 
	LOCAL cCNBREVISA := cNrRevisa 
	LOCAL aRetorno   := {}
	

	BeginSql Alias cAliasCNB

		//%noParser% 

		COLUMN CN9_DTINIC AS DATE
		COLUMN CN9_DTFIM  AS DATE

		SELECT CNB_CONTRA, CNB_NUMERO, CNB_ITEM, CNB_PRODUT, CNB_QUANT, CNB_VLUNIT, CNB_XQMIN, CNB_TABPRC
		FROM %TABLE:CNB% CNB (NOLOCK) 
		WHERE CNB.%notDel% 
		AND CNB.CNB_FILIAL = %xfilial:CNB%
		AND CNB.CNB_CONTRA = %EXP:cCNBCONTRA%
		AND CNB.CNB_NUMERO = %EXP:cCNBNUMERO%
		AND CNB.CNB_REVISA = %EXP:cCNBREVISA%
		ORDER BY CNB_NUMERO, CNB_ITEM

	EndSql

	//Processando as linhas GetLastQuery()[02]
	//----------------------------------------
	DBSELECTAREA( cAliasCNB )
	(cAliasCNB)->( DBGOTOP() )
	while (cAliasCNB)->( !EOF() )


		AADD( aRetorno, { (cAliasCNB)->CNB_PRODUT, (cAliasCNB)->CNB_ITEM , (cAliasCNB)->CNB_VLUNIT, (cAliasCNB)->CNB_XQMIN, (cAliasCNB)->CNB_TABPRC })

		(cAliasCNB)->( DBSKIP() )

	enddo

	//Fechando os Alias
	//-----------------
	(cAliasCNB)->( DBCLOSEAREA() )

return( aRetorno )

