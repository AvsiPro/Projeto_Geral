#include 'protheus.ch'
#include 'parmtype.ch'
#include "TopConn.ch"
#include "FWMVCDEF.CH"

#define DEBITO  1
#define CREDITO 2

#define ERROR_AMARRAC_COMB_CONTABIL  "AMARRAÇÃO PRÉ CADASTRO ATIVO COM COMBINAÇÃO CONTÁBIL NÃO ENCONTRADA"
#define ERROR_CT2_SEM_COMBINACOES    "NÃO FOI LOCALIZADO REGISTROS NA CT2 COM AS DEVIDAS COMBINAÇÕES CADASTRADAS. "

/*/{Protheus.doc} ROT002
//Integração Ativo Intangível
@author Gustavo
@since 10/03/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function ROT002()

	local nI 	:= 0
	Local aZ05AtivosPreCadastro := {}

	private lMsErroAuto 		:= .F.
	private lMsHelpAuto 		:= .T.
	private aLogInt				:= {}
	private aZ04AtivosPreCad 	:= {}

	if fShowParam()

		FWMsgRun(, {|| aZ04AtivosPreCad := fGetAtivosPreCadastro()}, "Aguarde", "Verificando Pré Cadastro")
		For nI := 1 to Len(aZ04AtivosPreCad) 
			aZ05AtivosPreCadastro := {}
			FWMsgRun(, {|| aZ05AtivosPreCadastro := fGetCombinacoesContab(aZ04AtivosPreCad[nI])}, "Aguarde", "Obtendo as combinações contábeis")
			if len(aLogInt) == 0
				Processa( {|| fProcess(aZ04AtivosPreCad[nI],aZ05AtivosPreCadastro)}, "Aguarde...", "Executando rotina", .F. )
			EndIf	
			if len(aLogInt) > 0
				fGeralog()
			endIf
		Next nI			
		If Len(aZ04AtivosPreCad) == 0 
			ApMsgInfo( "Não há dados a serem integrados.<br><br>.","Atenção")
		endIf
	endIf
return

/**
* Realiza o processamento
**/
static function fProcess(aZ04_Atual,aZ05AtivosPreCadastro)

	local nQtdRegsToInteg := len(aZ05AtivosPreCadastro) //fGetQdtRegsToInt(@aZ05AtivosPreCadastro) // alteracao solicitado WANDER 25/10/2023
	local nI			  := 0
	local nX 		 	  := 0	
	local nTotalDebito	  := 0
	local nTotalCredito	  := 0
	local cDataini		  := dTos(MV_PAR01)
	local cDataFim		  := dTos(MV_PAR02)
	local cCodBase		  := ""
	local cCCINVE		  := ""
	local cITINVE		  := ""
	local cCLINVE         := ""
	local cCTINVE         := ""
	local nQtdCrd 		  := 0
	local nQtdDeb 		  := 0
	Private cRecCt2		  := ''
	
	ProcRegua(nQtdRegsToInteg)

	for nI := 1 to nQtdRegsToInteg

		cCodBase := aZ05AtivosPreCadastro[nI][1]

		IncProc()

		lMsErroAuto         := .F.
		lMsHelpAuto			:= .T.

		if fExistCombinacoesToCt2(cDataini, cDataFim, aZ05AtivosPreCadastro[nI], @nQtdDeb, @nQtdCrd)

			For nX := 1 to nQtdDeb

				nTotalDebito 		:= fGetTotalDebito(cDataini, cDataFim, aZ05AtivosPreCadastro[nI])
				nTotalCredito		:= fGetTotalCredito(cDataini, cDataFim, aZ05AtivosPreCadastro[nI])
				nValor		 		:= nTotalDebito - nTotalCredito
				
				fSaveToATFA012(aZ04_Atual,nValor, aZ05AtivosPreCadastro[nI], nI, cDataini, cDataFim)	
			
			Next nX 

		else

			cCCINVE		  := allTrim(aZ05AtivosPreCadastro[nI][3])
			cITINVE		  := allTrim(aZ05AtivosPreCadastro[nI][4])
			cCLINVE       := allTrim(aZ05AtivosPreCadastro[nI][5])
			cCTINVE       := allTrim(aZ05AtivosPreCadastro[nI][6])	//-20230221

			//cMsgLog := "NÃO FORAM LOCALIZADOS REGISTROS DE LANÇAMENTOS CONTÁBEIS COM AS REGRAS DE "
			//cMsgLog += "C.C.INVESTIMENTO = "+cCCINVE+", IC INVESTIMEN.= "+cITINVE+", CV INVESTIMEN = "+cCLINVE+" e CTA.C.INVEST.TRANSITÓRIO = "+cCTINVE

			//aAdd(aLogInt, {allTrim(cCodBase), cMsgLog} )
			
		endIf

	next nI

	if len(aLogInt) > 0
		ApMsgInfo( "Registros processados com Erros.<br><br>"+;
		"<b>Solução:</b> Verifique o Log de Erros  .","Atenção")
	else
		ApMsgInfo( "Registros processados com Sucesso.<br><br>.","Atenção")
	endIf

return

/***
* Salvam o valor na ATF012
**/
static function fSaveToATFA012(aZ04_Atual, nValor, aZ05AtivosPreCadastro, nI, cDataini, cDataFim)

	local cItem		 := ''	
	local cCodBase	 := aZ05AtivosPreCadastro[1]
	local xErro		 := {}
	local cErro		 := ""
	local aArea		 := getArea()
	local aAreaSN1	 := SN1->(getArea())
	local aAreaSN3   := SN3->(getArea())
	local aAreaCT2	 := CT2->(getArea())
	
	begin transaction	

		fPosicionaTables(aZ05AtivosPreCadastro)

		//fExecRotAutom(aCabecalho, aItens, aParam)
		fExecRotMVC(aZ04_Atual,aZ05AtivosPreCadastro, nValor, @cITEM)

		if lMsErroAuto

			xErro := mostraErro("\")
			cErro := fConvertArrToStr(xErro)
			aAdd(aLogInt, {allTrim(cCodBase), cErro} )				
		else
			aCommandsUPDCT2 := fGetSQLScriptFlagCT2(cITEM, cDataini, cDataFim, aZ05AtivosPreCadastro)
			fExecUpdateFlagCT2(aCommandsUPDCT2)	
			fExec1UpdateHistSN3(aZ04_Atual)
		endIf

	end transaction

	restArea(aAreaSN1)
	restArea(aAreaSN3)
	restArea(aAreaCT2)
	restArea(aArea)

return

/**
* posiciona nas tabelas especificas
**/
static function fPosicionaTables(aZ05AtivosPreCadastro)

	local lPos	  := .F.

	CTT->(dbSetOrder(1))
	CTD->(dbSetOrder(1))
	CTH->(dbSetOrder(1))
/*
	if CTT->(dbSeek(fwxFilial("CTT") + cCCINVE))
		if CTD->(dbSeek(fwxFilial("CTD") + cITINVE))
			if CTH->(dbSeek(fwxFilial("CTH") + cCLINVE))
				if CT1->(dbSeek(fwxFilial("CT1") + cCTINVE))
					lPos := .T.
				endIf
			endIf
		endIf
	endIf
*/
	if CTT->(dbSeek(fwxFilial("CTT") + aZ05AtivosPreCadastro[7]))
		if CTD->(dbSeek(fwxFilial("CTD") + aZ05AtivosPreCadastro[8]))
			if CT1->(dbSeek(fwxFilial("CT1") + aZ05AtivosPreCadastro[9]))
				lPos := .T.
			endIf
		endIf
	endIf
return lPos

/**
* Converte o array para string
**/
static function fConvertArrToStr(xErro)

	local cErro := ""
	local nI	:= 0

	if valType(xErro) == "A"
		for nI := 1 to len(xErro)
			cErro += xErro[nI] + CRLF
		next nI
	else
		cErro := xErro
	endIf

return cErro

/**
* Verifica se gravou o ativo. 
* Necessário, pos caso um ativo seja excluído pela rotina de exlusão via menu,
* ao executar o execAuto novamente, dá erro, porém o ativo volta de DELETADO para ATIVO
**/
static function fGravouAtivo(aZ05AtivosPreCadastro)

	local aArea 	:= getArea()
	local cBase 	:= aZ05AtivosPreCadastro[1]
	local lGravou	:= .F.

	SN1->(dbSetOrder(1))

	if SN1->(dbSeek(fwxFilial("SN1") + cBase))
		lGravou := .T.
	endIf

	restArea(aArea)

return lGravou

/**
* executa a rotina automática
**/
static function fExecRotAutom(aCabecalho, aItens, aParam)

	MSExecAuto({|x,y,z| Atfa012(x,y,z)},aCabecalho,aItens,3,aParam)

return

/**
* Ontém os itens
**/
static function fGetItens(aZ04_Atual, aZ05AtivosPreCadastro, nI, nValor, cDescriFull)

	local aItem 		:= {}
	local aItens		:= {}
	local cGrupo		:= aZ04_Atual[3]
	local cTipoIt		:= "13"
	local cDescIt		:= "VALOR INTEGRACAO INVESTIMENTO " + cValToChar(dDataBase)
//aAtivosPreCad
	cCCINVE				:= aZ05AtivosPreCadastro[3] //INVESTIMENTO
	cITINVE				:= aZ05AtivosPreCadastro[4] //INVESTIMENTO
	cCLINVE				:= aZ05AtivosPreCadastro[5] //INVESTIMENTO
	cCTINVE				:= aZ05AtivosPreCadastro[6] //-20230221

	cCCDEPR				:= aZ05AtivosPreCadastro[8] //INVESTIMENTO
	cCTDEPR				:= aZ05AtivosPreCadastro[9] //-20230221

	SNG->(dbSetOrder(1))
	if Empty(cCTDEPR) .And. SNG->(dbSeek(xFilial("SNG")+cGrupo))
		cCTDEPR				:= SNG->NG_CCDEPR // Alteracao Solicitado Por Wnader 25/10/2023
	endif	

	FNG->(dbSetOrder(1))
	if FNG->(dbSeek(xFilial("FNG")+cGrupo))
		cTipoIt:= FNG->FNG_TIPO
		cDescIt:= Alltrim(FNG->FNG_HISTOR) + " " + cValToChar(dDataBase)
	endif	

//	aAdd(aItem,{"N3_TIPO" 		, "13" 													,nil}) 
//	aAdd(aItem,{"N3_HISTOR" 	, "VALOR INTEGRACAO INVESTIMENTO " + cValToChar(dDataBase)		,nil})  
	aAdd(aItem,{"N3_TIPO" 		, cTipoIt												,nil}) 
	aAdd(aItem,{"N3_HISTOR" 	, cDescIt												,nil})  
	aAdd(aItem,{"N3_CUSTBEM" 	, cCCINVE												,nil}) 
	aAdd(aItem,{"N3_SUBCCON" 	, cITINVE												,nil}) 	
	aAdd(aItem,{"N3_CLVLCON" 	, cCLINVE												,nil})	
	aAdd(aItem,{"N3_CDEPREC" 	, cCTDEPR												,nil})	//-20230221
	aAdd(aItem,{"N3_VORIG1" 	, nValor												,nil}) 	
	aAdd(aItem,{"N3_CODIND" 	, '02'  												,nil}) 	
	aAdd(aItem,{"N3_ZZDESCR" 	, cDescriFull											,nil}) 	

	aItem:= FwVetByDic(aItem, "SN3")

	aAdd(aItens, aItem)

return aItens

/**
* Obtém o cabeçalho da rotina automática cadastro de Ativos (ATFA012).
**/
static function fGetCabecalho(aZ04_Atual, aZ05AtivosPreCadastro, nI,nValor, cITEM, cDescriFull)

	local cCBASE	 	:= ""		
	local nQUANTD		:= 0	
	local cPATRIM		:= ""
	local cGRUPO		:= ""
	local aCabecalho 	:= {}
	local cDescPreCad	:= ""

	cCBASE	 			:= aZ04_Atual[1]
	cPatrim				:= aZ04_Atual[2]
	cGrupo				:= aZ04_Atual[3]
	cITEM				:= getMaxItemN1(cCBASE)
	cDescPreCad			:= allTrim(aZ04_Atual[4]) 
	cDescriFull			:= allTrim(aZ04_Atual[4]) + " " + cValToChar(nValor) + " " + cValToChar(dDataBase)
	nQUANTD				:= 1		

	aAdd(aCabecalho,{"N1_FILIAL" 	, fwxFilial("SN1") 		,nil})
	aAdd(aCabecalho,{"N1_GRUPO" 	, cGrupo 				,nil})
	aAdd(aCabecalho,{"N1_CBASE" 	, cCBASE 				,nil})
	aAdd(aCabecalho,{"N1_ITEM" 		, cITEM 				,nil})
	aAdd(aCabecalho,{"N1_AQUISIC" 	, dDataBase 			,nil})
	aAdd(aCabecalho,{"N1_QUANTD" 	, 1 					,nil})
	aAdd(aCabecalho,{"N1_DESCRIC" 	, cDescPreCad			,nil})	
	aAdd(aCabecalho,{"N1_PATRIM" 	, cPatrim 				,nil})
	aAdd(aCabecalho,{"N1_ZZDESCR" 	, cDescriFull 			,nil})
//	aAdd(aCabecalho,{"N1_CHAPA" 	, Alltrim(Str(Val(cCBASE)))        		,nil})

	//aAdd(aCabecalho,{"N1_MARGEM" 	, cGrupo 		,nil}) //PODE SER QUE JÁ GATILHA

	aCabecalho:= FwVetByDic(aCabecalho, "SN1")

return aCabecalho

/**
* Obtém os recnos da CT2 para marcar o flag posteriormente
**/
static function fGetSQLScriptFlagCT2(cITEM, cDataini, cDataFim, aZ05AtivosPreCadastro)

	local cSqlUpdDEBITO 	:= fGetSqlUpdCT2(	DEBITO	, aZ05AtivosPreCadastro, cITEM, cDataini, cDataFim)
	local cSqlUpdCREDITO 	:= fGetSqlUpdCT2(CREDITO	, aZ05AtivosPreCadastro, cITEM, cDataini, cDataFim)	

return {cSqlUpdDEBITO, cSqlUpdCREDITO}

/**
* Obtém o script CT2 para para atualização de campos FLAG
**/
static function fGetSqlUpdCT2(nTipo, aZ05AtivosPreCadastro, cITEM, cDataini, cDataFim)

	local cCCINVE				:= ""
	local cITINVE				:= ""
	local cCLINVE				:= ""
	local cCTINVE				:= ""
	local cCBASE				:= ""
	local cQuery 				:= ""

	if len(aZ05AtivosPreCadastro) > 0

		cCBASE  := aZ05AtivosPreCadastro[1]
		cCCINVE := aZ05AtivosPreCadastro[3]
		cITINVE := aZ05AtivosPreCadastro[4]
		cCLINVE := aZ05AtivosPreCadastro[5]
		cCTINVE := aZ05AtivosPreCadastro[6]	//-20230221

		cQuery := " UPDATE  " + retSqlName("CT2")    										 + CRLF
		cQuery += " SET CT2_ZZINTA = '1', "    										 	 	 + CRLF
		cQuery += "     CT2_ZZFILA = '"+fwxFilial("CT2")+"', "    							 + CRLF
		cQuery += "     CT2_ZZCAI = '"+cCBASE+"', "    							 			 + CRLF
		cQuery += "     CT2_ZZITAI = '"+cITEM+"', "    							 			 + CRLF
		cQuery += "     CT2_ZZDTAI = '"+dTos(dDataBase)+"', "    							 + CRLF
		cQuery += "     CT2_ZZHRAI = '"+time()+"' "   									 	 + CRLF
		cQuery += " WHERE 1 = 1 "  								 	 				 		 + CRLF
		cQuery += "    AND CT2_FILIAL = '"+fwxFilial("CT2")+"' "						 	 + CRLF

		if nTipo == DEBITO
			If !Empty(cCCINVE)	
				cQuery += "    AND CT2_CCD    = '"+cCCINVE+"' "	 			 					 + CRLF
			EndIf 
			If !Empty(cITINVE)				
				cQuery += "    AND CT2_ITEMD  = '"+cITINVE+"' "	 		 					 	 + CRLF
			EndIf 
			If !Empty(cCLINVE)	
				cQuery += "    AND CT2_CLVLDB = '"+cCLINVE+"' "	 			 					 + CRLF			
			EndIf 
			If !Empty(cCTINVE)	
				cQuery += "    AND CT2_DEBITO = '"+cCTINVE+"' "	 			 					 + CRLF			
			EndIf 
		ElseIf nTipo == CREDITO
			If !Empty(cCCINVE)	
				cQuery += "    AND CT2_CCC    = '"+cCCINVE+"' "	 			 					 + CRLF
			EndIf 
			If !Empty(cITINVE)				
				cQuery += "    AND CT2_ITEMC  = '"+cITINVE+"' "	 		 						 + CRLF
			EndIf 
			If !Empty(cCLINVE)				
				cQuery += "    AND CT2_CLVLCR = '"+cCLINVE+"' "	 			 					 + CRLF		
			EndIf 
			If !Empty(cCTINVE)				
				cQuery += "    AND CT2_CREDIT = '"+cCTINVE+"' "	 			 					 + CRLF			
			EndIf 
		EndIf
		cQuery += "    AND CT2_TPSALD = '1' "	 										 	 + CRLF
		cQuery += "    AND CT2_ZZFILA = ' ' "	 										 	 + CRLF
		cQuery += "    AND CT2_ZZCAI  = ' ' "	 									 	 	 + CRLF
		cQuery += "    AND CT2_ZZITAI = ' ' "	 										 	 + CRLF
		cQuery += "    AND CT2_ZZDTAI = ' ' "	 										 	 + CRLF
		cQuery += "    AND CT2_ZZHRAI = ' ' "	 										 	 + CRLF
		cQuery += "    AND CT2_ROTINA NOT LIKE '%ATF%' "								 	 + CRLF
		cQuery += "    AND CT2_DATA BETWEEN '" + cDataini + "' AND '" + cDataFim + "' "		 + CRLF
		cQuery += "    AND D_E_L_E_T_ = ' '"	 										 	 + CRLF

	endIf

return cQuery

/**
* Obtém o total débito
**/
static function fGetTotalDebito(cDataini, cDataFim, aZ05AtivosPreCadastro)

	local cQuery 		:= fGet3QueryCT2(DEBITO, aZ05AtivosPreCadastro, cDataini, cDataFim)
	local cAlias 		:= getNextAlias()
	local nTotalDebito	:= 0

	TCQUERY cQuery NEW ALIAS (cAlias)	

	if (cAlias)->(!eof())
		nTotalDebito := (cAlias)->TOTAL	
		cRecCt2 += cvaltochar((cAlias)->REGCT2) + '/'
	endIf

	(cAlias)->(dbCloseArea())	

return nTotalDebito

/**
* Obtém o total crédito
**/
static function fGetTotalCredito(cDataini, cDataFim, aZ05AtivosPreCadastro)

	local cQuery 		:= fGet3QueryCT2(CREDITO, aZ05AtivosPreCadastro, cDataini, cDataFim)
	local cAlias 		:= getNextAlias()
	local nTotalCredit	:= 0

	TCQUERY cQuery NEW ALIAS (cAlias)	

	if (cAlias)->(!eof())
		nTotalCredit := (cAlias)->TOTAL	
		cRecCt2 += cvaltochar((cAlias)->REGCT2) + '/'
	endIf

	(cAlias)->(dbCloseArea())	

return nTotalCredit

/**
* obtém a query da CT2 para obter o saldo
**/
static function fGet3QueryCT2(nTipo, aZ05AtivosPreCadastro, cDataini, cDataFim)

	local cCCINVE				:= ""
	local cITINVE				:= ""
	local cCLINVE				:= ""
	local cCTINVE				:= ""
	local cQuery 				:= ""
	local aRecnos				:= separa(cRecCt2,'/')
	local nX 					:= 0

	if len(aZ05AtivosPreCadastro) > 0

		cCCINVE := aZ05AtivosPreCadastro[3]
		cITINVE := aZ05AtivosPreCadastro[4]
		cCLINVE := aZ05AtivosPreCadastro[5]
		cCTINVE := aZ05AtivosPreCadastro[6]	//-20230221

		//cQuery := " SELECT SUM(CT2.CT2_VALOR) TOTAL FROM " + 	retSqlName("CT2") + " CT2 "  + CRLF
		cQuery := " SELECT CT2.CT2_VALOR TOTAL, CT2.R_E_C_N_O_ AS REGCT2 "
		cQuery += "  FROM " + 	retSqlName("CT2") + " CT2 "  + CRLF
		cQuery += " WHERE 1 = 1 "  								 	 				 		 + CRLF
		cQuery += "    AND CT2.CT2_FILIAL = '"+fwxFilial("CT2")+"' "						 + CRLF

		if nTipo == DEBITO
			iF !Empty(cCCINVE)
				cQuery += "    AND CT2.CT2_CCD   = '"+cCCINVE+"' "	 			 				 + CRLF
			EndIf 
			If !Empty(cITINVE)	
				cQuery += "    AND CT2.CT2_ITEMD = '"+cITINVE+"' "	 		 					 + CRLF
			EndIf 
			If !Empty(cCLINVE)	
				cQuery += "    AND CT2_CLVLDB    = '"+cCLINVE+"' "	 			 				 + CRLF			
			EndIf 
			If !Empty(cCTINVE)	
				cQuery += "    AND CT2_DEBITO    = '"+cCTINVE+"' "	 			 				 + CRLF
			EndIf 
			cQuery += "    AND CT2_DC IN ('3','1')"	 					 					 + CRLF			

			cQuery += "    AND SUBSTRING(CT2.CT2_CCD,1,4)   = '1631' " 					 		 + CRLF			
			cQuery += "    AND SUBSTRING(CT2.CT2_DEBITO,1,1)   = '4' " 					 		 + CRLF			

		elseIf nTipo == CREDITO
			iF !Empty(cCCINVE)
				cQuery += "    AND CT2.CT2_CCC   = '"+cCCINVE+"' "	 			 				 + CRLF
			EndIf 
			If !Empty(cITINVE)	
				cQuery += "    AND CT2.CT2_ITEMC = '"+cITINVE+"' "	 		 					 + CRLF
			EndIf 
			If !Empty(cCLINVE)	
				cQuery += "    AND CT2_CLVLCR    = '"+cCLINVE+"' "	 			 				 + CRLF		
			EndIf 
			If !Empty(cCTINVE)	
				cQuery += "    AND CT2_CREDIT    = '"+cCTINVE+"' "	 			 				 + CRLF
			EndIf 
			cQuery += "    AND CT2_DC IN ('3','2') "	 				 					 + CRLF		

			cQuery += "    AND SUBSTRING(CT2.CT2_CCC,1,4)   = '1631' " 					 		 + CRLF			
			cQuery += "    AND SUBSTRING(CT2.CT2_CREDITO,1,1)   = '4' " 					 		 + CRLF			

		endIf

		cQuery += "    AND CT2.CT2_TPSALD = '1' "											 + CRLF
		cQuery += "    AND CT2_ZZINTA != '1'"	  											 + CRLF
		cQuery += "    AND CT2.CT2_ROTINA NOT LIKE '%ATF%'"	  								 + CRLF
		cQuery += "    AND CT2_DATA BETWEEN '" + cDataini + "' AND '" + cDataFim + "' "		 + CRLF
		cQuery += "    AND CT2.D_E_L_E_T_ = ' ' "	 										 + CRLF

		If len(aRecnos) > 0
			cQuery += " AND CT2.R_E_C_N_O_ NOT IN ('"
			cVirg := ""

			For nX := 1 to len(aRecnos)
				cQuery += cVirg + aRecnos[nX]
				cVirg := "','"
			Next nX 

			cQuery += " ')"
		EndIf 

	endIf

return cQuery

/**
* Obtém as combinações contábeis dos ativos do pré cadastro
**/
static function fGetCombinacoesContab(aZ04AtivosPreCad)

	local cCodBem				:= ""
	local cQuery				:= ""
	local cAlias				:= "" 
	Local aZ05AtivosPreCadastro	:= {}

	//for nI := 1 to len(aZ04AtivosPreCad)

		cAlias  := getNextAlias()
		cCodBem := aZ04AtivosPreCad[1]
		cQuery  := fGetQueryCombinacoesContab(cCodBem)	


		TCQUERY cQuery NEW ALIAS (cAlias)	

		if (cAlias)->(!eof())
			while (cAlias)->(!eof())
				aAdd(aZ05AtivosPreCadastro,{cCodBem,'',(cAlias)->Z05_CCINVE,;
											 (cAlias)->Z05_ITINVE, (cAlias)->Z05_CLINVE, (cAlias)->Z05_CTINVE,;
											 (cAlias)->Z05_ITDEPR, (cAlias)->Z05_CCDEPR, (cAlias)->Z05_CTDEPR })
				(cAlias)->(dbSkip())
			endDo
		else

			aAdd(aLogInt, {allTrim(cCodBem), ERROR_AMARRAC_COMB_CONTABIL})

		endIf

		(cAlias)->(dbCloseArea())

	//next nI

return(aZ05AtivosPreCadastro)

/**
* Obtém a query da combinação contábil
**/
static function  fGetQueryCombinacoesContab(cCodBem)

	local cQuery := ""

	cQuery := " SELECT * FROM " + retSqlName("Z05") + " Z05" 	+ CRLF
	cQuery += " WHERE 1 = 1" 								 	+ CRLF
	cQuery += "    AND Z05.Z05_FILIAL = '"+fwxFilial("Z05")+"'" + CRLF
	cQuery += "    AND Z05.Z05_CBASE= '"+cCodBem+"'" 			+ CRLF
	cQuery += "    AND Z05.Z05_STATUS = '1' "			+ CRLF
	cQuery += "    AND Z05.D_E_L_E_T_ = ' '" 					+ CRLF	

return cQuery

/**
* Obtém os ativos do pré cadastro para serem integrados
**/
static function fGetAtivosPreCadastro()

	local cQuery 			:= ""
	local cAlias			:= getNextAlias()
	local aZ04AtivosPreCad	:= {}
	Local sDeZ5_Base    	:= MV_PAR03
	Local sAteZ5_Base   	:= MV_PAR04
	
	cQuery := " SELECT * FROM " + 	retSqlName("Z04") + " Z04 " + CRLF
	cQuery += " WHERE 1 = 1 " 									+ CRLF
	cQuery += "    AND Z04.Z04_FILIAL= '"+fwxFilial("Z04")+"' " + CRLF
	cQuery += "    AND Z04.Z04_CBASE BETWEEN '"+Alltrim(sDeZ5_Base)+"' AND '"+Alltrim(sAteZ5_Base)+"' "	+ CRLF
	cQuery += "    AND Z04.Z04_BLOQ= 'N' " 						+ CRLF
	cQuery += "    AND Z04.D_E_L_E_T_= ' ' "  					+ CRLF	

	TCQUERY cQuery NEW ALIAS (cAlias)

	if (cAlias)->(!eof())

		while (cAlias)->(!eof())

			//MANTER O NIL SEMPRE POR ÚLTIMO
			aAdd(aZ04AtivosPreCad, {	(cAlias)->Z04_CBASE,;
									(cAlias)->Z04_PATRIM,;
									(cAlias)->Z04_GRUPO,;
									AllTrim((cAlias)->Z04_DESCRI),;
									(cAlias)->Z04_QUANTD,;
									(cAlias)->Z04_INCLUS,;
									nil })

			(cAlias)->(dbSkip())
		endDo
	endIf
	(cAlias)->(dbCloseArea())

return aZ04AtivosPreCad

/**
* exibe os parâmetros
**/
static function fShowParam()

	local aArea		:= GetArea()
	local cPerg		:= "ROT002"
	local aParambox	:= {}
	local lStatus	:= .F.

	aAdd(aParamBox,{1,"De  Data: ",Ctod(""),"","","","",50,.T.}) 
	aAdd(aParamBox,{1,"Até Data: ",Ctod(""),"","","","",50,.T.}) 	
	aAdd(aParamBox,{1,"De  Ativo Base: ",Space(TamSX3('Z05_CBASE')[01]),"","","Z05","",50,.T.}) 	
	aAdd(aParamBox,{1,"Ate Ativo Base: ",Space(TamSX3('Z05_CBASE')[01]),"","","Z05","",50,.T.}) 	

	If ParamBox(aParamBox,"Integração Ativos intangíveis",,,,,,,,cPerg,.T.,.T.)
		lStatus := .T.
	EndIf

	RestArea(aArea)

return lStatus

/**
* Obtém a quantidade de  registros a serem integrados e refatora o array
**/
static function fGetQdtRegsToInt(aZ05AtivosPreCadastro)

	local nI 						:= 0
	local aAtivosTempPreCadastro	:= {}
	local nQtdRegs					:= 0

	for nI := 1 to len(aZ05AtivosPreCadastro)

	//	if !empty(aZ05AtivosPreCadastro[nI][len(aZ05AtivosPreCadastro[nI])])
			aAdd(aAtivosTempPreCadastro, aZ05AtivosPreCadastro[nI])
			nQtdRegs ++			
	//	endIf

	next nI

	aZ05AtivosPreCadastro := aAtivosTempPreCadastro

return nQtdRegs

/**
* executa o update na CT2
**/
static function fExecUpdateFlagCT2(aCommandsUPDCT2)

	local nI 		:= 0
	local cCommand	:= ""
	local lStatus	:= .F.

	for nI := 1 to len(aCommandsUPDCT2)
		cCommand := aCommandsUPDCT2[nI]
		if TCSqlExec(cCommand)
			lStatus := .T.
		endIf
	next nI

return

/**
* Gera log
**/
static function fGeralog()

	private oExcel 			:= FWMSExcel():New()
	private cPlanMemoria	:= "LOGINTEG"
	private cTableMemoria 	:= "LOG DE INTEGRAÇÃO"
	private cEndSalPlani	:= SuperGetMV("ZZ_DIRLOGI",,"c:\log_integracao_ativo\")

	fCheckDir(cEndSalPlani)

	Processa( {|| fProcessLog() 	}, "Aguarde...", "Gerando Log",			.F.)

return

/** 
* Processa log
**/
static function fProcessLog()

	local nI	:= 0

	ProcRegua(len(aLogInt))

	fInstExcel()

	for nI := 1 to len(aLogInt)

		IncProc()

		fADDDadosExcel(aLogInt[nI])

	next nI

	cNomeArq 			:= + allTrim(fGetNomeArq())
	oExcel:Activate()

	FWMsgRun(, {|| oExcel:GetXmlFile(allTrim(cEndSalPlani) + cNomeArq ) }, "Aguarde", "gerando o log...")	

	WinExec("Explorer " + allTrim(cEndSalPlani) + cNomeArq)
	MsgInfo("Log Gerado com Sucesso","Aviso")

return

/**
* instancia a classe excel com as colunas
**/
static function fInstExcel()

	oExcel:AddWorkSheet(cPlanMemoria)
	oExcel:AddTable (cPlanMemoria,cTableMemoria)

	oExcel:AddColumn(cPlanMemoria,cTableMemoria,"CODIGO BEM",							1,1)
	oExcel:AddColumn(cPlanMemoria,cTableMemoria,"OBSERVAÇÃO",							1,1)	

return

/**
* adiciona dados no excel
**/
static function fADDDadosExcel(aLogInt)

	oExcel:AddRow(cPlanMemoria,cTableMemoria,{;
	allTrim(aLogInt[1])										,;		
	allTrim(aLogInt[2])							 		 	 ;			
	})

return

/**
*	Retorna o nome do arquivo
**/
static function fGetNomeArq()

	Local dDt:= DToS(dDataBase)
	Local hora	:= strTran(time(),":","")

Return dDt+hora + ".xls"

/**
* checa o diretório
**/
static function fCheckDir(cEndSalPlani)

	if !existDir(cEndSalPlani)
		makeDir(cEndSalPlani)
	endIf

return

/**
* Verifica se existe combinações na CT2 qua ainda não esteja integradas
**/
static function fExistCombinacoesToCt2(cDataini, cDataFim, aZ05AtivosPreCadastro, nQtdDeb, nQtdCrd)

	local cQueryDeb 		:= fGet2QueryCT2Comb(DEBITO	, aZ05AtivosPreCadastro, cDataini, cDataFim)
	local cQueryCred		:= fGet2QueryCT2Comb(CREDITO	, aZ05AtivosPreCadastro, cDataini, cDataFim)
	local cAlias 			:= getNextAlias()
	local nQtdRegsDeb		:= 0
	local nQtdRegsCred		:= 0
	local lExistComb		:= .F.

	TCQUERY cQueryDeb NEW ALIAS (cAlias)	

	if (cAlias)->(!eof())
		nQtdRegsDeb := (cAlias)->QTD_REGS
		nQtdDeb := 	(cAlias)->QTD_REGS
	endIf

	(cAlias)->(dbCloseArea())	

	TCQUERY cQueryCred NEW ALIAS (cAlias)	

	if (cAlias)->(!eof())
		nQtdRegsCred := (cAlias)->QTD_REGS	
		nQtdCrd := (cAlias)->QTD_REGS
	endIf

	(cAlias)->(dbCloseArea())	
	
	//TODO só vai integrar caso tenha a quantidade de registros débito/crédito deferente de 0?
	if nQtdRegsDeb != 0 .or. nQtdRegsCred != 0
		lExistComb := .T.
	endIf
	
return lExistComb

/**
* obtem a query da CT2 com as combinações
**/
static function fGet2QueryCT2Comb(nTipo, aZ05AtivosPreCadastro, cDataini, cDataFim)

	local cCCINVE				:= ""
	local cITINVE				:= ""
	local cCLINVE				:= ""
	local cCTINVE				:= ""
	local cQuery 				:= ""

	if len(aZ05AtivosPreCadastro) > 0

		cCCINVE := aZ05AtivosPreCadastro[3]
		cITINVE := aZ05AtivosPreCadastro[4]
		cCLINVE := aZ05AtivosPreCadastro[5]
		cCTINVE := aZ05AtivosPreCadastro[6]	//-20230221

		cQuery := " SELECT COUNT(*) QTD_REGS FROM " + 	retSqlName("CT2") + " CT2 "  + CRLF
		cQuery += " WHERE 1 = 1 "  								 	 				 		 + CRLF
		cQuery += "    AND CT2.CT2_FILIAL = '"+fwxFilial("CT2")+"'"	 						 + CRLF

		if nTipo == DEBITO
			If !Empty(cCCINVE)	
				cQuery += "    AND CT2.CT2_CCD   = '"+cCCINVE+"'"	 		 					 + CRLF
			EndIf 
			If !Empty(cITINVE)	
				cQuery += "    AND CT2.CT2_ITEMD = '"+cITINVE+"'"	 		 					 + CRLF
			EndIf 
			If !Empty(cCLINVE)	
				cQuery += "    AND CT2_CLVLDB    = '"+cCLINVE+"'"	 		 					 + CRLF
			EndIf 
			If !Empty(cCTINVE)	
				cQuery += "    AND CT2_DEBITO    = '"+cCTINVE+"'"	 		 					 + CRLF
			EndIf 
		elseIf nTipo == CREDITO
			If !Empty(cCCINVE)	
				cQuery += "    AND CT2.CT2_CCC   = '"+cCCINVE+"'"	 		 					 + CRLF
			EndIf 
			If !Empty(cITINVE)	
				cQuery += "    AND CT2.CT2_ITEMC = '"+cITINVE+"'"	 		 					 + CRLF
			EndIf 
			If !Empty(cCLINVE)	
				cQuery += "    AND CT2_CLVLCR    = '"+cCLINVE+"'"	 		 					 + CRLF
			EndIf 
			If !Empty(cCTINVE)	
				cQuery += "    AND CT2_CREDIT    = '"+cCTINVE+"'"	 			 				 + CRLF
			EndIf 
		endIf
		
		cQuery += "    AND CT2.CT2_TPSALD = '1' "											 + CRLF
		cQuery += "    AND CT2_ZZINTA != '1'"	 			 					 			 + CRLF		
		cQuery += "    AND CT2.CT2_ROTINA NOT LIKE '%ATF%'"	  								 + CRLF
		cQuery += "    AND CT2_DATA BETWEEN '" + cDataini + "' AND '" + cDataFim + "' "		 + CRLF
		cQuery += "    AND CT2.D_E_L_E_T_ = ' '"	 										 + CRLF

	endIf

return cQuery

/**
* Teste execAuto MVC
**/
static function fExecRotMVC(aZ04_Atual, aZ05AtivosPreCadastro, nValor, cITEM)

	local oModel 		:= nil 	
	local cDescriFull 	:= ""
	local aErro			:= {}

	private INCLUI		:= .T.

	oModel := FWLoadModel("ATFA012")
	oModel:SetOperation(MODEL_OPERATION_INSERT )
	oModel:Activate()

	fPopulaModelMaster(@oModel, aZ04_Atual, aZ05AtivosPreCadastro, nValor, @cITEM, @cDescriFull)
	fPopula1ModelDetails(@oModel, aZ04_Atual, aZ05AtivosPreCadastro, nValor, cDescriFull)

	if oModel:VldData()
		oModel:CommitData()
	else
		disarmTransaction()
		aErro := oModel:GetErrorMessage()
							
		AutoGrLog( "Id do formulário de origem:"+ ' [' + AllToChar( aErro[1] ) + ']')
		AutoGrLog( "Id do campo de origem: " 	+ ' [' + AllToChar( aErro[2] ) + ']')
		AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']')
		AutoGrLog( "Id do campo de erro: " 		+ ' [' + AllToChar( aErro[4] ) + ']')
		AutoGrLog( "Id do erro: " 				+ ' [' + AllToChar( aErro[5] ) + ']')
		AutoGrLog( "Mensagem do erro: " 		+ ' [' + AllToChar( aErro[6] ) + ']')
		AutoGrLog( "Mensagem da solução: " 		+ ' [' + AllToChar( aErro[7] ) + ']')
		AutoGrLog( "Valor atribuído: " 			+ ' [' + AllToChar( aErro[8] ) + ']')
		AutoGrLog( "Valor anterior: " 			+ ' [' + AllToChar( aErro[9] ) + ']')

		lMsErroAuto := .T.
	endIf

	oModel:DeActivate()
    oModel:Destroy()
    oModel:= nil

return

/**
* popula os campos master
**/
static function fPopulaModelMaster(oModel, aZ04_Atual, aZ05AtivosPreCadastro, nValor, cITEM, cDescriFull)

	local cCBASE	 	:= ""		
	local nQUANTD		:= 0	
	local cPATRIM		:= ""
	local cGRUPO		:= ""
	local cDescPreCad	:= ""	

	cCBASE	 			:= aZ04_Atual[1]
	cPatrim				:= aZ04_Atual[2]
	cGrupo				:= aZ04_Atual[3]
	cDescPreCad			:= allTrim(aZ04_Atual[4]) 
	cITEM				:= getMaxItemN1(cCBASE)	
	nQUANTD				:= 1		

	oModel:SetValue( "SN1MASTER",  "N1_FILIAL", fwxFilial("SN1"))
	oModel:SetValue( "SN1MASTER",  "N1_GRUPO", cGrupo			)
	oModel:SetValue( "SN1MASTER",  "N1_CBASE", cCBASE			)
	oModel:SetValue( "SN1MASTER",  "N1_ITEM", cITEM				)
	oModel:SetValue( "SN1MASTER",  "N1_AQUISIC", dDataBase		)
	oModel:SetValue( "SN1MASTER",  "N1_QUANTD", 1				)
	oModel:SetValue( "SN1MASTER",  "N1_DESCRIC", cDescPreCad	)
	oModel:SetValue( "SN1MASTER",  "N1_PATRIM", cPatrim			)
	oModel:SetValue( "SN1MASTER",  "N1_CHAPA", Alltrim(cCBASE)+Alltrim(cITEM)  		) // colocado o mesmo numero do bem na plaqueta

return

/**
* popula os campos details
**/
static function fPopula1ModelDetails(oModel, aZ04_Atual, aZ05AtivosPreCadastro, nValor, cDescriFull)
	
	local cGrupo		:= aZ04_Atual[3]
	local cTipoIt		:= "13"
	local cDescIt		:= "VALOR INTEGRACAO INVESTIMENTO " + cValToChar(dDataBase)
	local nX 			:= 0

//	cCCINVE				:= aZ05AtivosPreCadastro[3] //INVESTIMENTO		
//	cITINVE				:= aZ05AtivosPreCadastro[4] //INVESTIMENTO		
//	cCLINVE				:= aZ05AtivosPreCadastro[5] //INVESTIMENTO	
//	cCTINVE				:= aZ05AtivosPreCadastro[6] //INVESTIMENTO

	FNG->(dbSetOrder(1))
	if FNG->(dbSeek(xFilial("FNG")+cGrupo))
		While !FNG->(EOF()) .AND. ALLTRIM(FNG->FNG_GRUPO) == ALLTRIM(cGrupo)
			nX++
			cTipoIt := FNG->FNG_TIPO

			If !oModel:GetModel("SN3DETAIL"):SeekLine({{'N3_TIPO',cTipoIt}}) .AND. nX > 1
				oModel:GetModel("SN3DETAIL"):AddLine()
			Endif
			
			If oModel:CanSetValue("SN3DETAIL", "N3_TIPO")
				oModel:SetValue( "SN3DETAIL",  "N3_TIPO", cTipoIt)
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_TIPO", cTipoIt)
			EndIf

			If oModel:CanSetValue("SN3DETAIL", "N3_HISTOR")
				oModel:SetValue( "SN3DETAIL",  "N3_HISTOR", cDescIt)
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_HISTOR", cDescIt)
			EndIf
			oModel:SetValue( "SN3DETAIL",  "N3_CODIND", '02')

			If oModel:CanSetValue("SN3DETAIL", "N3_CUSTBEM")
				oModel:SetValue( "SN3DETAIL",  "N3_CUSTBEM", aZ05AtivosPreCadastro[7])
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_CUSTBEM", aZ05AtivosPreCadastro[7])
			EndIf

			If oModel:CanSetValue("SN3DETAIL", "N3_SUBCCON")
				oModel:SetValue( "SN3DETAIL",  "N3_SUBCCON", aZ05AtivosPreCadastro[8])
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_SUBCCON", aZ05AtivosPreCadastro[8])
			EndIf
/*
			If oModel:CanSetValue("SN3DETAIL", "N3_CLVLCON")
				oModel:SetValue( "SN3DETAIL",  "N3_CLVLCON", cCLINVE)
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_CLVLCON", cCLINVE)
			EndIf
*/
			//-20230221
			If oModel:CanSetValue("SN3DETAIL", "N3_CDEPREC")
				oModel:SetValue( "SN3DETAIL",  "N3_CDEPREC", aZ05AtivosPreCadastro[9])
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_CDEPREC", aZ05AtivosPreCadastro[9])
			EndIf

			If oModel:CanSetValue("SN3DETAIL", "N3_VORIG1")
				oModel:SetValue( "SN3DETAIL",  "N3_VORIG1", nValor)
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_VORIG1", nValor)
			EndIf	

			If oModel:CanSetValue("SN3DETAIL", "N3_ZZDESCR")
				oModel:SetValue( "SN3DETAIL",  "N3_ZZDESCR", cDescriFull)
			else		
				oModel:LoadValue("SN3DETAIL",  "N3_ZZDESCR", cDescriFull)
			EndIf

			FNG->(DbSkip())
		Enddo		
	endif
return

/**
* atualização de campo N3_HIST com N3_TIPO = '15'
**/
Static Function fExec1UpdateHistSN3(aZ04_Atual)
local cDescIt		:= "VALOR INTEGRACAO INVESTIMENTO " + cValToChar(dDataBase)

/*FNG->(dbSetOrder(1))
if FNG->(dbSeek(xFilial("FNG")+cGrupo))
	cDescIt:= Alltrim(FNG->FNG_HISTOR) + " " + cValToChar(dDataBase)
endif*/	
//aAtivosPreCad
dbSelectArea("SN3")
RecLock("SN3",.f.)
//SN3->N3_HISTOR:= "VALOR INTEGRACAO INVESTIMENTO " + cValToChar(dDataBase)
SN3->N3_HISTOR:= cDescIt
Msunlock()

Return


/**
* Obtém o max item (N1_ITEM) da tabela SN1 tendo como base o campo N1_CBASE
**/
static function getMaxItemN1(cCBASE)

	local cQuery 		:= ""
	local cAlias 		:= getNextAlias()
	local cMaxItemN1 	:= ""

	cQuery := " SELECT MAX(SN1.N1_ITEM) MAX_ITEM FROM "+retSqlName("SN1")+" SN1 " 	+ CRLF
	cQuery += " WHERE 1 = 1" 														+ CRLF
	cQuery += "    AND SN1.N1_FILIAL = '"+fwxFilial("SN1")+"'" 						+ CRLF
	cQuery += "    AND SN1.N1_CBASE ='"+cCBASE+"'" 									+ CRLF
	cQuery += "    AND SN1.D_E_L_E_T_ = ' '" 										+ CRLF

	TCQUERY cQuery NEW ALIAS (cAlias)

	if (cAlias)->(!eof())
		cMaxItemN1 := (cAlias)->MAX_ITEM
		if empty(cMaxItemN1)
			cMaxItemN1 := padl("0001", tamSx3("N1_ITEM")[1], "0")
		else
			cMaxItemN1 := soma1(cMaxItemN1)
		endIf
	endIf

	(cAlias)->(dbCloseArea())

return cMaxItemN1
