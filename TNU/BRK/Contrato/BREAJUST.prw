#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

Static oPanelSUP
Static oPanelINF



/*/{Protheus.doc} BREAJUST
Rotina para Reajuste de Contrato
@type function
@version 12.1.33
@author Roni / Atualizado por Valdemir Rabelo
@since 10/10/2023
@return variant, Nil
/*/
user function BREAJUST()
	Private dDataAtual := ddatabase
	Private cTitulo    := "SELEÇÃO DE CONTRATOS"
	Private oOk        := LoadBitmap(GetResources(),"LBOK")
	Private oNo        := LoadBitmap(GetResources(),"LBNO")
	Private lChk       := .F.
	Private lMark      := .F.
	Private aVetor     := {}
	Private cPerg      := "REAJUST"
	Private cVar
	Private oDlg
	Private oChk
	Private oLbx
	
	ValidPerg()
	If !Pergunte(cPerg,.T.)	
		Return
	EndIf

	Private _EmisIni	:= Mv_Par01
	Private _EmisFim	:= Mv_Par02
	Private _cContra1   := Mv_Par03
	Private _cContra2   := Mv_Par04
	Private _cCli1      := Mv_Par05
	Private _cCli2      := Mv_Par06

	GetRegis()

	If Len(aVetor) == 0
		MsgAlert("Não foi Selecionado nenhum Contrato para Reajuste",cTitulo)
		Return
	EndIf

	oDlg  := MSDialog():New(000,000,511,1292,cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.) 
	getThema(oDlg)

	@010,010 LISTBOX oLbx VAR cVar FIELDS Header " ", "Data Reajuste","Nº Contrato", "Revisão", "Cod. Cliente", "Loja", "Nome Cliente", "Vigencia", "Data Inicio", "Data Fim", "Valor do Saldo R$" SIZE (oPanelSUP:nClientWidth/2),(oPanelSUP:nClientHeight/2) Of oPanelSUP PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
	oLbx:SetArray(aVetor)
	oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10],aVetor[oLbx:nAt,11] }}
	If oChk <> Nil
		@003,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" Size 60,007 PIXEL Of oPanelINF On Click(Iif(lChk,Marca(lChk),Marca(lChk)))
	EndIf
	@003,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" SIZE 60,007 PIXEL Of oPanelINF On Click(aEval(aVetor,{|x| x[1] := lChk}),oLbx:Refresh())

	//@003,420 BUTTON "Envio Email"         				SIZE 070, 021 Font oDlg:oFont ACTION CARVET03(aVetor) OF oPanelINF PIXEL
    @003,490 BUTTON oBtReaj PROMPT "Envia E-mail"  SIZE 070, 021 Font oDlg:oFont ACTION CARVET02(aVetor) OF oPanelINF PIXEL    // Valdemir Rabelo 02/04/2024
	@003,560 BUTTON oBtSair PROMPT "Cancela"       SIZE 070, 021 Font oDlg:oFont ACTION oDlg:End() OF oPanelINF PIXEL
	oBtReaj:SETCSS( SetCssImg("Primary") )
	oBtSair:SETCSS( SetCssImg("Danger") )
	oBtReaj:cToolTip  := "Reajuste do contrato e faz envio do e-mail"
	oBTSair:cToolTip  := "Volta a tela principal"

	oDlg:lCentered := .T.
	oDlg:Activate()

Return

// Não sendo utilizado - Valdemir Rabelo
/*Static Function CARVET01(aVetor)

	Processa( {|| BRADITIV(aVetor) }, "Aguarde...", "Atualizando Contratos - aditivos...",.F.)
	ddatabase := dDataAtual 

Return
*/

/*/{Protheus.doc} CARVET02
Rotina que faz a chamada para reajuste
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param aVetor, array, Array de Dados
@return variant, Nil
/*/
Static Function CARVET02(aVetor)

	Processa( {|| /*U_CN301REV(aVetor),*/ CARVET03(aVetor) }, "Aguarde...")   // Removido conforme solicitado 02/04/2024

Return

/*/{Protheus.doc} CARVET03
Rotina que fará o envio de Relatórios e E-mail
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param aVetor, array, Array Dados
@return variant, Nil
/*/
Static Function CARVET03(aVetor)
	Local lRET := .F.

	Processa( {|| lRET := Envemail(aVetor) }, "Aguarde...")
	

Return lRET

/*/{Protheus.doc} CN301REV
Reajuste Automatico
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param aVetor, array, Array Dados
@return variant, Nil
/*/
User Function CN301REV(aVetor)
	Local oModel    := Nil 
	Local cTipRev   := '001'
	Local cJustific := 'Reajuste Automatico' 
	Local nNx
	
	procregua(len(aVetor))

	For nNx := 1 to len(aVetor)
		IncProc()
		If aVetor[nNx,1]
			ddatabase := aVetor[nNx,2]
			CN9->(DBSetOrder(1))
			If CN9->(DbSeek(xFilial("CN9")+aVetor[nNx,3]+aVetor[nNx,4]))         
			
				A300STpRev("2")                                
			
				oModel := FWLoadModel("CNTA301") 					
				oModel:SetOperation(MODEL_OPERATION_INSERT)    											
				oModel:Activate(.t.)

				//=== Preenchimento das alterações da revisão. =======================================================================================
				//== Cabeçalho
				oModel:SetValue( 'CN9MASTER'       , 'CN9_TIPREV' , cTipRev)      //- É obrigatório o preenchimento do tipo de revisão do contrato.		
				oModel:SetValue( 'CN9MASTER'       , 'CN9_JUSTIF' , cJustific)    //- É obrigatório o preenchimento da justificativa de revisão do contrato.
				oModel:SetValue( 'CN9MASTER'       , 'CN9_DREFRJ' , ddatabase)
				

				/*CN300RdSld(oModel)  
				lRet := oModel:VldData() .And. oModel:CommitData()
				If !lRet
				
					aErro := oModel:GetErrorMessage()
					Alert('Erro: ' + AllToChar( aErro[6] + ' '+ AllToChar( aErro[4] + Dtoc(DATE())+' - '+Time())))
				Endif */
				CN300Reaju(oModel)
				If oModel:VldData()
					oModel:CommitData()
				Else          
					aErro := oModel:GetErrorMessage()
					Alert('Erro: ' + AllToChar( aErro[6] + ' '+ AllToChar( aErro[4] + Dtoc(DATE())+' - '+Time())))
				EndIf	

				oModel:DeActivate()
				oModel:Destroy()

				cRevisa := CnUltRev(CN9->CN9_NUMERO, cFilAnt)
				U_CN300AP(CN9->CN9_NUMERO, cRevisa) 			//Aprova revisão 
				U_IncluiRev(CN9->CN9_NUMERO, cRevisa)
				cRevisa := CnUltRev(CN9->CN9_NUMERO, cFilAnt)
				U_CN300AP(CN9->CN9_NUMERO, cRevisa)

			EndIf
		EndIf	
		
	Next

Return 

// Não sendo utilizado - Valdemir Rabelo
/*
Static Function BRADITIV(aVetor)
	Local nNx
	Local cRevisa := ""

	
	For nNx := 1 to len(aVetor)

		//IncProc("Atualizando contrato " + Alltrim(aVetor[nNx,3]) + "...")
		If aVetor[nNx,1]	
			U_IncluiRev(aVetor[nNx,3],aVetor[nNx,4])
			cRevisa := CnUltRev(aVetor[nNx,3], cFilAnt)
			U_CN300AP(aVetor[nNx,3], cRevisa)
		EndIf	

	Next

Return
*/

/*/{Protheus.doc} CN300AP
Rotina que realizará aprovação
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param cContra, character, Contrato
@param cRevisa, character, Revisão
@return variant, Nil
/*/ 
User Function CN300AP(cContra,cRevisa)
	//Local cFilCont := ' < FILIAL_DO_CONTRATO > '
	//Local cContra  := ' < NÚMERO_DO_CONTRATO > '
	//Local cRevisa  := ' <NÚMERO_DA_REVISÃO> '
	Local nRet     := 0
	Local cMsgErro := ""
	Local lRet     := .F.
	Local aArea    := CN9->(GetArea())
 
	//=== Preparação do contrato para revisão =============================================================================================
	CN9->(DBSetOrder(1))
	If CN9->( DbSeek( xFilial("CN9") + cContra + cRevisa ))
		nRet := CN300Aprov(.T.,,@cMsgErro)  //- Função retorna 0 em caso de falha e 1 em caso de sucesso, também retorna a mensagem de erro por referência através do parâmetro cMsgErro.
		If nRet == 1
			lRet := .T.
			//Else
			//MSGInfo("","Erro ao aprovar o contrato "+cContra+" "+cMsgErro)
		EndIf
	EndIf

	RestArea(aArea)
  
Return lRet


/*/{Protheus.doc} IncluiRev
Rotina que irá gerar aditivo automático
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param cContra, character, Contrato
@param cRevisa, character, Revisão
@return variant, Nil
/*/
User Function IncluiRev(cContra, cRevisa)    
	Local aErro := {}
    Local _oModelGct := Nil
	Local cTipR   := '010'
	Local cJustific := 'Aditivo Automatico'
	Local nVige    
	Local dDatafim 
	Local lCabCro := .f.
	Local oObjCNB	:= Nil
	Local _lRet		:= .F.

	CN9->(DBSetOrder(1))
	If CN9->(DbSeek(xFilial("CN9")+cContra+cRevisa))

		nVige := CN9->CN9_VIGE+12   
		dDatafim := MonthSum(CN9->CN9_DTFIM,12)      
     
    	A300STpRev("G")                                
     
    	_oModelGct := FWLoadModel("CNTA301")               
		_oModelGct:SetOperation(3)    
		_lRet := _oModelGct:Activate(.T.) 
    	    
		if _lRet
		_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_TIPREV' , cTipR)       //- É obrigatório o preenchimento do tipo de revisão do contrato.
	 
			_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_JUSTIF' , cJustific)    //- É obrigatório o preenchimento da justificativa de revisão do contrato.

			_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_VIGE'  , nVige) 
			//_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_DTFIM' , dDatafim ) 

			DbSelectArea("CNA")
			CNA->(DbSetOrder(1))
			DbSelectArea("CNL")
			CNL->(DbSetOrder(1))
			DbSelectArea("CNB")
			CNA->(DbSeek(xFilial("CNA")+cContra+cRevisa))

			While CNA->(!EOF()) .and. CNA->CNA_FILIAL == xFilial("CNA") .and. CNA->CNA_CONTRA == cContra .and. CNA->CNA_REVISA == cRevisa

				CNL->(DbSeek(xFilial("CNL")+CNA->CNA_TIPPLA))
				
				If CNL->CNL_CTRFIX == '1'
				
					_oModelGct:GetModel('CNADETAIL'):GoLine(val(CNA->CNA_NUMERO))
					CNB->(DbSeek(xFilial("CNB")+cContra+cRevisa+CNA->CNA_NUMERO))
					nLine := 0
					
					oObjCNB	:= _oModelGct:GetModel('CNBDETAIL')
					
					While CNB->(!EOF()) .and. CNB->CNB_FILIAL == xFilial("CNB") .and. CNB->CNB_CONTRA == cContra .and. CNB->CNB_REVISA == cRevisa .and. CNB->CNB_NUMERO == CNA->CNA_NUMERO

						if (CNB->CNB_XPCANC=='1')      // Valdemir Rabelo
						   CNB->(DbSkip())
						   Loop
						Endif 
						nLine +=1
						oObjCNB:GoLine(nLine)	
						CNTA300BlMd(oObjCNB,.F.)
						MtBCMod(_oModelGct , {oObjCNB:CID} , {||.T.} )						
						oObjCNB:SetValue('CNB_QUANT', nVige)
						
						CNTA300BlMd(oObjCNB,.t.)
						
						CNB->(DbSkip())
					EndDo		

					If !lCabCro
						_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_ARRAST' , '1')
						_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_REDVAL' , '1')
						_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_QTDPAR' , 12 )
						lCabCro := .t.
					EndIf	
					CN300AtCrs(_oModelGct)
				
				EndIf	
				CNA->(DbSkip())
			EndDo 
		endif

		If _lRet
			_lRet := _oModelGct:VldData()
			If _lRet
				_oModelGct:CommitData()
			Else          
				aErro := _oModelGct:GetErrorMessage()
				Alert('Erro: ' + AllToChar( aErro[6] + ' '+ AllToChar( aErro[4] + Dtoc(DATE())+' - '+Time())))
			EndIf	
		endif	

		_oModelGct:DeActivate()
        
	EndIf
	If ValType( _oModelGct ) <> "U"
		_oModelGct:Destroy()
		FreeObj( _oModelGct )
		_oModelGct:= NIL		
	EndIf
//	FWRestRows(aSaveLines)
Return	     


/*/{Protheus.doc} Envemail
Rotina que fará o envio de e-mail
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param aVetor, array, Array de Dados
@return variant, Nil
/*/
Static Function Envemail(aVetor)
	Local nNx     := 0
	Local nconta  := 0
	Local aParam  := {}
	Local aRET    := {}
	Local aAnexos := {}
	Local cMotivo := Space(100)
	Local nPerc   := 0
	Local nReajus := 1
	Local cMesAno := Space(80)

	procregua(0)
	procregua(len(aVetor))
	For nNx := 1 to len(aVetor)
		incproc()
		CNC->(DBSetOrder(1))
		IF aVetor[nNx,1]
			If CNC->(DbSeek(xFilial("CNC")+aVetor[nNx,3]+aVetor[nNx,4]))

				DbSelectArea("SA1")
				DbSetOrder(1)
				SA1->(DbSeek(xFilial("SA1")+CNC->CNC_CLIENT+CNC->CNC_LOJACL)) 

				xmMail   := SA1->A1_MAILJUR  //SA1->A1_EMAIL
				//xmailcp:= "celi.fujihira@totvspartners.com.br"
				xmailcp  := ""
				xmailcco := "valdemir_sistemas@hotmail.com"
				xmTitulo := "REAJUSTE DE CONTRATO - "+Alltrim(aVetor[nNx,7]) 
				xindice  := aVetor[nNx,12]
				//
				MV_PAR01 = NIL
				MV_PAR02 = NIL
				MV_PAR03 = NIL
				MV_PAR04 = NIL
				MV_PAR05 = NIL
				aAdd(aParam,{3,"Reajuste Padrão:",nReajus,{"Não", "Sim"}, 90, .T.,.F.})
				aAdd(aParam,{1,"Motivo",cMotivo	,"@!",".T.","","",90,.F.})
				aAdd(aParam,{1,"Índice negociação(%)",nPerc	,"@E 999.99",".T.","",".T.",90,.F.})
				aAdd(aParam,{1,"Mês/Ano negociação",cMesAno	,"@R 99/9999","u_vldNeg()","","",90,.T.})
				aAdd(aParam,{3,"Edita E-mail:",1,{"Não", "Sim"}, 90, .T.,.F.})

				lResp := ParamBox(aParam, "Informe os Dados", @aRET)	
				if lResp
				    if ValType(aRET[1])=="C"
					   MV_PAR01 := IIF(Lower(aRET[1])=="sim",2,1)
					else 
						MV_PAR01 := aRET[1]
					endif 
					MV_PAR02 := aRET[2]
					MV_PAR03 := aRET[3]
					MV_PAR04 := aRET[4]
				    if ValType(aRET[5])=="C"
					   MV_PAR05 := IIF(Lower(aRET[5])=="sim",2,1)
					else 
					   MV_PAR05 := aRET[5]
					endif 
				Else 
				   cMensagem := "A não confirmação dos parâmetros, faz com que não seja gerado "+CRLF 
				   cMensagem += "O relatório de reajuste de contrato e envio do e-mail"+CRLF+CRLF
				   cMensagem += "Deseja realmente não dar seguimento?"
				   if FWAlertYesNo(cMensagem,"Atneção!")
				      Break
				   endif 
				endif 				

				// Gerando Relatório de Reajuste de Contrato
				U_BRRELAJUST( {aVetor[nNx,3],aVetor[nNx,4],aVetor[nNx,2]}, xindice)
				_cArq_contr     := strtran(aVetor[nNx,3], "/", "")
				cFileDestilocal := alltrim(strtran(_cArq_contr, ".", ""))+".pdf"
				cLocal          := GetTempPath()+"totvsprinter\"+cFileDestilocal
				xmCorpo         := mailhtm({aVetor[nNx,3], aVetor[nNx,4], aVetor[nNx,2]},xindice)
				CpyT2S(cLocal,"\System",.T.,.T.)

				if !Empty(cFileDestilocal)
				   aAdd(aAnexos, "system\"+cFileDestilocal)
				endif 
				if (MV_PAR05 == 2)    // Edita e-mail
					lret := U_zOutlook({xmMail,xmTitulo,xmCorpo,xmailcp,xmailcco,cFileDestilocal,''})
					If lret
						nconta++
					Endif
					FERASE(cLocal)
				else
					nret := U_BRENMAIL({xmMail,xmTitulo,xmCorpo,xmailcp,xmailcco,aAnexos,''})					       
					If nret = 0
						nconta++
					Endif
					FERASE(cLocal)
				endif
			EndIf	
		ENDIF

	Next

	if nconta > 0	
		ALERT( "Qtd: "+alltrim(str(nconta))+" e-mail(s) enviado(s)!!!" )
	endif

Return


/*/{Protheus.doc} mailhtm
Rotina para montagem do corpo do e-mail
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@param aVetor, array, Array Dados
@param xindice, variant, Indice
@return variant, Corpo Montado
/*/
Static Function mailhtm(aVetor,xindice)
	Local _cTexto		:= ""
	Local cDescPorc     := ""
	
	dData       := _EmisFim
	nMes        := Month(dData)
	cMesExtenso := MesExtenso(nMes)+"/"+cValToChar(Year(dData)) //Pega o mês por extenso
	cCompet     := aVetor[3]
	cCompet     := SUBSTR(DTOS(cCompet),5,2) + "/" + SUBSTR(DTOS(cCompet),1,4) //SUBSTR(DTOS(CN9->CN9_DTINIC),5,2) + "/" + SUBSTR(DTOS(CN9->CN9_DTINIC),1,4)
	cPerc 		:= iif(MV_PAR01 == 2,str(POSICIONE("CN7",2,XFILIAL("CN7")+xindice+cCompet,'CN7_VLREAL')),str(MV_PAR03))
	cDescPorc   := ALLTRIM(POSICIONE("CN7",2,XFILIAL("CN7")+xindice+cCompet,'CN7_DESCRI'))
	
	_cTexto	+= 'COMUNICADO'+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	_cTexto	+= 'Ref: REAJUSTE DE PREÇOS'+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	_cTexto	+= 'Prezado Cliente,'+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	_cTexto	+= 'Servimo-nos da presente, para lhes comunicar que os '
	_cTexto	+= 'valores referentes aos serviços prestados, serão reajustados a partir do mês de '+cMesExtenso+' na base de ( '+alltrim(cPerc)+' '+chr(37)+'  ) '
	_cTexto	+= ', em face do '+Alltrim(cDescPorc)+'. Cumpre ressaltar que o(s) valor(es) descrito(s) no anexo sofrerão reajuste'
	_cTexto	+= ' conforme os termos do contrato de '
	_cTexto	+= 'prestação de serviços em vigor especificamente na cláusula que prevê a Forma de Reajuste.'+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	_cTexto	+= 'Agradecemos a compreensão e nos colocamos à '
	_cTexto	+= 'disposição para esclarecer eventuais dúvidas.  '+CHR(13)+CHR(10)+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	_cTexto	+= 'Atenciosamente, '+CHR(13)+CHR(10)+CHR(13)+CHR(10)
	_cTexto	+= 'DEPARTAMENTO JURÍDICO. '+CHR(13)+CHR(10)
	_cTexto	+= 'BRK Tecnologia. '	

Return(_cTexto)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Marca     ºAutor  ³Eduardo Augusto     º Data ³  22/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que Perguntas do SX1.					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ I2I Eventos						                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidPerg()
	Local i       := 0
	Local j       := 0
	Local _sAlias := Alias()
	Local cPerg   := PADR(cPerg,10)
	Local aRegs   := {}
	
	DBSelectArea("SX1")
	DBSetOrder(1)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Reajuste de:"         ,"","","mv_ch1","D",08,0,0 ,"G","","mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Reajuste ate:"        ,"","","mv_ch2","D",08,0,0 ,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Contrato de:"         ,"","","mv_ch3","C",15,0,0 ,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	aAdd(aRegs,{cPerg,"04","Contrato ate:"        ,"","","mv_ch4","C",15,0,0 ,"G","","Mv_Par04","","","","","","","","","","","","","","","","","","","","","","","","","CN9",""})
	aAdd(aRegs,{cPerg,"05","Cliente de:"          ,"","","mv_ch5","C",06,0,0 ,"G","","mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
	aAdd(aRegs,{cPerg,"06","Cliente ate:"         ,"","","mv_ch6","C",06,0,0 ,"G","","Mv_Par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})

	For i:=1 to Len(aRegs)
		If ! DBSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
		EndIf
	Next

	DBSkip()
	DBSelectArea(_sAlias)
Return	




/*/{Protheus.doc} getThema
Rotina para montagem do layout
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 09/10/2023
@param poDlgX, variant, Objeto Formulario
@return variant, Nil
/*/
Static Function getThema(poDlgX)

	oLayer := FWLayer():New()

	oLayer:Init(poDlgX, .f.)
	oLayer:addLine("TOP",80,.F.)
	oLayer:addLine("INF",20,.F.)

	oLayer:addCollumn("COL_SUP",100,.f.,"TOP")
	oLayer:addCollumn("COL_INF",100,.f.,"INF")

	oLayer:AddWindow( "COL_SUP", "COL_SUP",  "Campos", 100, .T., .F.,/*bAction*/,"TOP",/*bGotFocus*/)
	oLayer:AddWindow( "COL_INF", "COL_INF",  "Botões", 100, .T., .F.,/*bAction*/,"INF",/*bGotFocus*/)

	oPanelSUP := oLayer:GetWinPanel('COL_SUP','COL_SUP',"TOP" )
	oPanelINF := oLayer:GetWinPanel('COL_INF','COL_INF',"INF" )

Return


/*/{Protheus.doc} GetRegis
Rotina que realiza o filtro de dados
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 10/10/2023
@return variant, Array de Dados
/*/
Static Function GetRegis()  //getDados()
	Local cQuery := ""

	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf

	cQuery := " SELECT DISTINCT CN9.CN9_NUMERO, CN9.CN9_REVISA ,CN9.CN9_DTINIC, CN9.CN9_VIGE, CN9.CN9_DTFIM, CN9.CN9_SALDO, CNA.CNA_PROXRJ, CNA.CNA_CLIENT, CNA.CNA_LOJACL,CNA.CNA_INDICE, SA1.A1_NOME FROM "
	cQuery += RetSqlName("CN9") +" CN9, " + RetSqlName("CNC") +" CNC, " + RetSqlName("CNA") +" CNA, " + RetSqlName("SA1") +" SA1 "
	cQuery += " WHERE CN9.D_E_L_E_T_ = '' "
	cQuery += " AND CNA.D_E_L_E_T_ = '' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	cQuery += " AND CN9.CN9_FILIAL = '"+xFilial("CN9")+"' "
	cQuery += " AND CNA.CNA_FILIAL = '"+xFilial("CN9")+"' "
	cQuery += " AND CN9.CN9_SITUAC = '05' 
	cQuery += " AND CN9.CN9_NUMERO BETWEEN  '" + _cContra1 + "' AND '" + _cContra2 + "' "
	cQuery += " AND CN9.CN9_NUMERO = CNA.CNA_CONTRA "
	cQuery += " AND CN9.CN9_REVISA = CNA.CNA_REVISA "
	cQuery += " AND CNA.CNA_PROXRJ BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "  
	cQuery += " AND CNA.CNA_CLIENT BETWEEN  '" + _cCli1 + "' AND '" + _cCli2 + "' "
	cQuery += " AND CNA.CNA_CLIENT = SA1.A1_COD "
	cQuery += " AND CNA.CNA_LOJACL = SA1.A1_LOJA "    
	cQuery += " AND CNA.CNA_XATIVO <> '2' "                             
																				
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	TcSetField("TMP","CNA_PROXRJ","D")
	TcSetField("TMP","CN9_DTFIM" ,"D")
	TcSetField("TMP","CN9_DTINIC","D")
	TcSetField("TMP","CN9_SALDO"  ,"N",12,2)
	DbSelectArea("TMP")
	DbGoTop()

	While !TMP->(Eof())
		aAdd(aVetor, { lMark, TMP->CNA_PROXRJ,TMP->CN9_NUMERO, TMP->CN9_REVISA ,TMP->CNA_CLIENT, TMP->CNA_LOJACL, TMP->A1_NOME, TMP->CN9_VIGE, TMP->CN9_DTINIC, TMP->CN9_DTFIM, AllTrim(Transform(TMP->CN9_SALDO,"@E 999,999,999.99")),TMP->CNA_INDICE })
		DbSelectArea("TMP")
		DbSkip()
	End

	DbSelectArea("TMP")
	DbCloseArea()

Return 


/*/{@Protheus.doc} SetCssImg
	description
	@type function
	@version  1.0
	@author Valdemir Rabelo
	@since 16/01/2022
/*/
Static Function SetCssImg(cTipo)
	Local cCssRet := ""
	Default cTipo := "Primary"

	IF cTipo == "Success"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: green }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #53BD33 } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: green }"
		cCssRet += "QPushButton:focus { background-color: #66E83F } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	
	EndIf

	IF cTipo == "Primary"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: blue }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #434bdf } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: #373fd4 }"
		cCssRet += "QPushButton:focus { background-color: #1c25d7 } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	
	EndIf

	IF cTipo == "Danger"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: Red }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #E63223 } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: Red }"
		cCssRet += "QPushButton:focus { background-color: #F73626 } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	
	EndIf

	IF cTipo == "Warning"
		cCssRet := "QPushButton { color: white }"
		cCssRet += "QPushButton { font-weight: bolder }"
		cCssRet += "QPushButton { border: 2px solid #CECECE }"
		cCssRet += "QPushButton { background-color: orange }"
		cCssRet += "QPushButton { border-radius: 8px }"
		cCssRet += "QPushButton:hover { background-color: #E3CC10 } "
		cCssRet += "QPushButton:hover { border-style: solid } "
		cCssRet += "QPushButton:hover { border-width: 4px }"
		//cCssRet += "QPushButton:pressed { background-color: #F5DC11 }"
		cCssRet += "QPushButton:focus { background-color: #F5DC11 } "
		cCssRet += "QPushButton:focus { border-style: solid } "
		cCssRet += "QPushButton:focus { border-width: 8px }"	

	EndIf

Return cCssRet


/*/{Protheus.doc} vldNeg
Rotina de Validação de mês
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 11/10/2023
@param cMesAno, character, Mes/Ano
@return variant, Lógico
/*/
User Function vldNeg()
	Local lRET as bool
	Local cMesAno := MV_PAR04
	
	lRET := .T.

	lRET := ((Val(Left(cMesAno,2)) <= 12) .and. (Val(Left(cMesAno,2)) > 0))

	if !lRET 
	   FwAlertInfo("Mês de negociação inválido","Atenção!")
	Endif 

Return lRET
