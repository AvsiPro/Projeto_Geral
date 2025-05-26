#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

USER FUNCTION BRIntWeb()

	LOCAL aSay      := {}             
	LOCAL aButtons  := {}
	LOCAL cCadastro := "Integração Web Gstão Contratos"
	LOCAL nOpc	    := 0

	AADD( aSay, "Está rotina fazer as Medições do Contrato ")
	AADD( aSay, "atravez de uma integração WEB.           " )
	
	AADD( aButtons, { 1,.T.,{|| nOpc := 1, FECHABATCH() } } ) //-- Botao OK - Processa
	AADD( aButtons, { 2,.T.,{|| nOpc := 0, FECHABATCH() } } ) //-- Botao Cancelar 

	FORMBATCH( cCadastro, aSay, aButtons,,200,425 ) //-- Monta Tela de Processamento

	IF nOpc == 1
		INTWEB001()
	ENDIF
	
RETURN()

STATIC FUNCTION INTWEB001()

	LOCAL aCabCND    := {}
	LOCAL aItemCNE   := {}
	LOCAL aItemCXN   := {}
	LOCAL aContrato  := {}
	LOCAL aPlanilha  := {}
	LOCAL aProduto   := {}
	LOCAL aIntWeb    := {}

	LOCAL cNumMed    := ""
	LOCAL cNrContra  := SPACE(TAMSX3("CN9_NUMERO")[1])
	LOCAL cNrRevisa  := SPACE(TAMSX3("CN9_REVISA")[1])
	LOCAL cNrPlan    := SPACE(TAMSX3("CNA_NUMERO")[1])
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

	LOCAL lRet       := .T.

	//Carrega Array com os CONTRATOS, PLANILHA e PRODUTO
	/*
	aContrato := {}
	aPlanilha := {}
	aProduto  := {}
	
	AADD( aContrato, "000000000000006" )
	AADD( aContrato, SPACE(03) )
	
	AADD( aPlanilha, "000001" )
	
	AADD( aProduto, { "000000000000001", 10 } )
	AADD( aProduto, { "000000000000002", 10 } )
	
	AADD(aIntWeb, { aContrato, aPlanilha, aProduto } )
	
	aContrato := {}
	aPlanilha := {}
	aProduto  := {}

	AADD( aContrato, "000000000000005" )
	AADD( aContrato, SPACE(03) )

	AADD( aPlanilha, "000001" )

	AADD( aProduto, { "000000000000001", 10 } )
	AADD( aProduto, { "000000000000002", 10 } )

	AADD(aIntWeb, { aContrato, aPlanilha, aProduto } )

	aContrato := {}
	aPlanilha := {}
	aProduto  := {}

	AADD( aContrato, "000000000000005" )
	AADD( aContrato, SPACE(03) )

	AADD( aPlanilha, "000002" )

	AADD( aProduto, { "000000000000001", 10 } )
	AADD( aProduto, { "000000000000002", 10 } )

	AADD(aIntWeb, { aContrato, aPlanilha, aProduto } )
	aContrato := {}
	aPlanilha := {}
	aProduto  := {}
	
	AADD( aContrato, "000000000000007" )
	AADD( aContrato, SPACE(03) )
	
	AADD( aPlanilha, "000001" )
	
	AADD( aProduto, { "000000000000001", 10 } )
	
	AADD(aIntWeb, { aContrato, aPlanilha, aProduto } )	
	*/

	aContrato := {}
	aPlanilha := {}
	aProduto  := {}
	
	AADD( aContrato, "000000000000001") 
	AADD( aContrato, SPACE(03) )
	
	AADD( aPlanilha, "000001" ) 
	
	AADD( aProduto, { "SV0000000000005" , 1 } ) //"00002"
	
	AADD(aIntWeb, { aContrato, aPlanilha, aProduto } )	

	//Inicia pelo CONTRATO
	FOR nX := 1 TO LEN(aIntWeb)

		lRet      := .T.
		cNrContra := aIntWeb[nX][01][01]
		cNrRevisa := aIntWeb[nx][01][02]

		MSGALERT( "Numero Contrato: " + cNrContra, "Atenção" )

		//Pesquisa Contrato - CN9
		DBSELECTAREA("CN9")
		CN9->( DBSETORDER( 01 ) )
		IF !CN9->( DBSEEK( xFILIAL("CN9") + cNrContra + cNrRevisa ) )
			MSGINFO("Numero de Contrato: " + cNrContra + " Não Localizado!!!", "INFORMAÇÃO")
			lRet := .F.
		ELSE
			MSGALERT( "Situação: " + CN9->CN9_SITUAC, "Atenção" )
			//Situação do Congrato
			IF CN9->CN9_SITUAC <> "05"
				MSGINFO("Contrato não esta em VIGÊNCIA", "INFORMAÇÃO" )
				lRet := .F.
			ENDIF

			IF lRet
				//Especie do Contrato ('1'-Compra '2'-Venda)
				IF CN9->CN9_ESPCTR <> "2"
					MSGINFO("Contrato não se refere a VENDAS", "INFORMAÇÃO" )
					lRet := .F.
				ENDIF
			ENDIF	
		ENDIF

		IF lRet

			cCompet   := SUBSTR(DTOS(CN9->CN9_DTINIC),5,2) + "/" + SUBSTR(DTOS(CN9->CN9_DTINIC),1,4)
			CMoeda    := "01"
		
			cNrPlan   := aIntWeb[nX][02][01]
			aPlanilha := aIntWeb[nX][02]
			aProduto  := aIntWeb[nX][03]

			cItem     := "000"
		
			//Pesquisa Cabeçalho da Planilha - CNA
			DBSELECTAREA("CNA")
			CNA->( DBSETORDER( 01 ) )
			IF !CNA->( DBSEEK( xFILIAL("CNA") + CN9->CN9_NUMERO + CN9->CN9_REVISA + cNrPlan ) )
				MSGINFO("Planilha: " + cNrPlan + " Não Localizada", "INFORMAÇÃO")
				lRet := .F.
			ELSE
				//Pesquisa Cliente (SA1)
				DBSELECTAREA("SA1")
				SA1->( DBSETORDER( 01 ) )
				IF !SA1->( DBSEEK( xFILIAL("SA1") + CNA->CNA_CLIENT + CNA->CNA_LOJACL ) )
					MSGINFO("Cliente/Loja: " + ALLTRIM(CNA->CNA_CLIENT) + "-" + ALLTRIM(CNA->CNA_LOJACL) + " Não Localizado", "INFORMAÇÃO")
					lRet := .F.
				ELSE
					//Valida de Cliente esta Bloqueado
					IF SA1->A1_MSBLQL == "1"
						MSGINFO("Cliente/Loja: " + ALLTRIM(SA1->A1_COD) + "-" + ALLTRIM(SA1->A1_LOJA) + " Esta Bloqueado", "INFORMAÇÃO")
						lRet := .F.
					ENDIF	
				ENDIF
				
				IF lRet
					cNumMed := CriaVar("CND_NUMMED")
					//Carrega Cabeçalho das Mediçoes
					aCabCND := {}
					AADD( aCabCND, { "CND_NUMMED", cNumMed  , NIL } )
					AADD( aCabCND, { "CND_CONTRA", cNrContra, NIL } )
					AADD( aCabCND, { "CND_REVISA", cNrRevisa, NIL } )
					AADD( aCabCND, { "CND_COMPET", cCompet  , NIL } )
					AADD( aCabCND, { "CND_NUMERO", cNrPlan  , NIL } )
					
					IF !EMPTY(CND->(FIELDPOS("CND_PARCEL")))
						AADD( aCabCND, { "CND_PARCEL", cNrParcel, NIL } )
					ENDIF
					AADD( aCabCND, { "CND_MOEDA", cMoeda, NIL } )
					AADD( aCabCND, { "CND_SERVIC", "1", NIL } )

					MSGALERT( "Planilha: " + cNrPlan , "Atenção" )
					MSGALERT( "Medição.: " + cNumMed , "Atenção" )
				ENDIF
			ENDIF	
		
		ENDIF
		
		IF lRet
		
			FOR nY := 1 TO LEN(aProduto)

				cProduto := aProduto[nY][01]
				nQuant   := aProduto[nY][02]

				//Pesquisa Itens da Planilha - CNB
				DBSELECTAREA("CNB")
				CNB->( DBSETORDER( 04 ) )
				IF !CNB->( DBSEEK( xFILIAL("CNB") + CN9->CN9_NUMERO + cNrPlan + cProduto ) )
					MSGINFO("Produto na Planilha não localizado", "INFORMAÇÃO")
					lRet := .F.
				ELSE
					//Valida a Quantidade
					IF nQuant + CNB->CNB_QTDMED > CNB->CNB_QUANT
						MSGINFO("Quantidade Informada Ultrapassa a Quantidade das Medições", "INFORMAÇÃO")
						lRet := .F.
					ENDIF 

					IF lRet
						//Array dos Itens
						cItem     := SOMA1(cItem)	
						nVlUnit   := CNB->CNB_VLUNIT
						nVlTotal  := nQuant * nVlUnit
						dDtEnt    := dDATABASE
						cTesSaida := CNB->CNB_TS

						MSGALERT( "Item...: " + cItem   , "Atenção" )
						MSGALERT( "Produto: " + cProduto, "Atenção" )

						//Carrega Itens das Medições
						AADD( aItemCNE, {} )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_ITEM"  , cItem    , NIL } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_PRODUT", cProduto , NIL } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_QUANT" , nQuant   , NIL } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_VLUNIT", nVlUnit  , NIL } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_VLTOT" , nVlTotal , NIL } )
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_DTENT" , dDATABASE, NIL } )          
						AADD( aItemCNE[LEN(aItemCNE)], { "CNE_TS"    , cTesSaida, NIL } )

						//Carrega Itens Planilha Medição de Contratos
						AADD( aItemCXN, {} )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_CHECK"  , .T.       , NIL } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_CONTRA" , cNrContra , NIL } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_REVISA" , cNrRevisa , NIL } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_NUMMED" , cNumMed   , NIL } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_NUMPLA" , cNrPlan   , NIL } )
						AADD( aItemCXN[LEN(aItemCXN)], { "CXN_PARCEL" , cNrParcel , NIL } )          

					ENDIF
				ENDIF

			NEXT nY

			IF lRet
				//Processa Medicao - CNTA120
				//MSGRUN("Aguarde, Processsando Medição... ", "SIGAGCT", {|| GRVMED(aCabCND,aItemCNE)}) //SIGAGCT - Aguarde, processsando Medição...

				U_BRINTA02(aCabCND, aItemCNE, aItemCXN)
			ENDIF

		ENDIF

	NEXT nX

RETURN()


STATIC FUNCTION GRVMED(aCab,aItens)

	LOCAL aArea := GETAREA()

	PRIVATE lMsErroAuto := .F.

	//-- Gera a medicao
	MSEXECAUTO({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,3)		

	IF lMsErroAuto
		AVISO("SIGAGCT", "Erro no Primeiro (01) EXECAUTO.",{"Ok"}) //SIGAGCT - O pedido de venda número ### não foi vinculado ao contrato selecionado.
		MOSTRAERRO()
	ENDIF

	//-- Encerra a medicao
	IF !lMsErroAuto

		AVISO("SIGAGCT", "Irei para o Segundo (02) EXECAUTO.",{"Ok"}) //SIGAGCT - O pedido de venda número ### não foi vinculado ao contrato selecionado.

		MSEXECAUTO({|a,b,c|,CNTA120(a,b,c)},aCab,aItens,6)

		IF lMsErroAuto
			MOSTRAERRO()
			AVISO("SIGAGCT", "O pedido de venda número" + SC5->C5_NUM + "não foi vinculado ao contrato selecionado.",{"Ok"}) //SIGAGCT - O pedido de venda número ### não foi vinculado ao contrato selecionado.
		ENDIF

	ENDIF

	RESTAREA(aArea)

RETURN()            




/*/{Protheus.doc} GBINTA02
//TODO MSEXECAUTO MVC PARA MEDIÇÃO DE CONTRATO
@author Administrador
@since 23/07/2018
@version 1.0
@return ${return}, ${return_description}
@param _aCabec, , descricao
@param _aItCNE, , descricao
@param _aItCXN, , descricao
@type function
/*/
User Function BRINTA02(_aCabec, _aItCNE, _aItCXN)

	Local oModel
	Local _lOk		:= .F.
	Local aError	:= {}
	Local cErro		:= ''
	Local _nx

	Private cFilCtr 
	PRIVATE lAuto := .F.

	//u_GBCONNECT()

	//Manter a compatibilidade com o execauto CTNA121
	cFilCtr	:= cFilAnt
	oModel 	:= FWLoadModel("CNTA121")

	oModel:SetOperation(3)

	oModel:Activate()

	//CND
	For _nx := 1 to Len(_aCabec)

		If !Empty(_aCabec[_nx,2])
			oModel:SetValue("CNDMASTER",_aCabec[_nx,1],_aCabec[_nx,2])
		EndIf

	Next
	
	//CXN
	oModel := ProcItens(oModel,'CXNDETAIL',_aItCXN)

	//CNE
	oModel := ProcItens(oModel,'CNEDETAIL',_aItCNE)

	If oModel:VldData()
		oModel:CommitData()
		_lOk := .T.

	Else

		aError := oModel:GetErrorMessage()
		For _nx := 1 to Len(aError)
			cErro +=If(ValType(aError[_nx])=='C',aError[_nx]+CRLF,'')
		Next
		ConOut('Erro:' + AllTrim(cErro))

	EndIf

	oModel:DeActivate(.T.)

    IF _lOk
		//cNumMed := CND->CND_NUMMED          
        // oModel:DeActivate()        
        _lOk := CN121Encerr(.T.) //Realiza o encerramento da medição                   
	ENDIF

Return (_lOk)


Static Function ProcItens(oModel,_cDetail,_aItem)

	Local _nx, _ny

	For _nx := 1 to Len(_aItem)
		For _ny := 1 to Len(_aItem[_nx])

			If !Empty(_aItem[_nx,_ny,2])
				oModel:SetValue(_cDetail,_aItem[_nx,_ny,1],_aItem[_nx,_ny,2])
			EndIf

		Next
	Next

Return (oModel)

