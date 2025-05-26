#include 'protheus.ch'
#INCLUDE 'totvs.ch'
#include 'parmtype.ch'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

Static oPanelSUP
Static oPanelINF

user function BREAJUST()
	Private dDataAtual := ddatabase
	Private cTitulo    := "SELEÇÃO DE CONTRATOS"
	Private oOk        := LoadBitmap(GetResources(),"LBOK")
	Private oNo        := LoadBitmap(GetResources(),"LBNO")
	Private cVar
	Private oDlg
	Private oChk
	Private oLbx
	Private lChk       := .F.
	Private lMark      := .F.
	Private aVetor     := {}
	Private cPerg      := "REAJUST"

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
	Private cQuery 		:= ""

	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf

	cQuery := " SELECT DISTINCT CN9.CN9_NUMERO, CN9.CN9_REVISA ,CN9.CN9_DTINIC, CN9.CN9_VIGE, CN9.CN9_DTFIM, CN9.CN9_SALDO, CNA.CNA_PROXRJ, CNA.CNA_CLIENT, CNA.CNA_LOJACL, SA1.A1_NOME FROM "
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
                                                                         	
	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	TcSetField("TMP","CNA_PROXRJ","D")
	TcSetField("TMP","CN9_DTFIM" ,"D")
	TcSetField("TMP","CN9_DTINIC","D")
	TcSetField("TMP","CN9_SALDO"  ,"N",12,2)
	DbSelectArea("TMP")
	DbGoTop()

	While !TMP->(Eof())
		aAdd(aVetor, { lMark, TMP->CNA_PROXRJ,TMP->CN9_NUMERO, TMP->CN9_REVISA ,TMP->CNA_CLIENT, TMP->CNA_LOJACL, TMP->A1_NOME, TMP->CN9_VIGE, TMP->CN9_DTINIC, TMP->CN9_DTFIM, AllTrim(Transform(TMP->CN9_SALDO,"@E 999,999,999,999.99")) })
		DbSelectArea("TMP")
		DbSkip()
	End

	DbSelectArea("TMP")
	DbCloseArea()
	
	If Len(aVetor) == 0
		MsgAlert("Não foi Selecionado nenhum Contrato para Reajuste",cTitulo)
		Return
	EndIf

	oDlg  := MSDialog():New(000,000,511,1292,cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.) 
	getThema(oDlg)

	@000,000 LISTBOX oLbx VAR cVar FIELDS Header " ", "Data Reajuste","Nº Contrato", "Revisão", "Cod. Cliente", "Loja", "Nome Cliente", "Vigencia", "Data Inicio", "Data Fim", "Valor do Saldo R$" SIZE (oPanelSUP:nClientWidth/2),(oPanelSUP:nClientHeight/2) Of oPanelSUP PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
	oLbx:SetArray(aVetor)
	oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10],aVetor[oLbx:nAt,11] }}
	If oChk <> Nil
		@000,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" Size 60,007 PIXEL Of oPanelINF On Click(Iif(lChk,Marca(lChk),Marca(lChk)))
	EndIf
	@000,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" SIZE 60,007 PIXEL Of oPanelINF On Click(aEval(aVetor,{|x| x[1] := lChk}),oLbx:Refresh())

	//@243,530 BUTTON "Aditivo"          SIZE 050, 011 Font oDlg:oFont ACTION CARVET01(aVetor) Of oDlg PIXEL
    //@243,370 BUTTON "Envia Email"      SIZE 070, 011 Font oDlg:oFont ACTION CARVET03(aVetor)OF oDlg PIXEL
	@003,490 BUTTON "Reajuste e Envio" SIZE 070, 021 Font oDlg:oFont ACTION CARVET02(aVetor) OF oPanelINF PIXEL
	@003,560 BUTTON "Cancela"          SIZE 070, 021 Font oDlg:oFont ACTION oDlg:End() OF oPanelINF PIXEL
	
	oDlg:lCentered := .T.
	oDlg:Activate()
Return


Static Function CARVET01(aVetor)

	Processa( {|| BRADITIV(aVetor) }, "Aguarde...", "Atualizando Contratos - aditivos...",.F.)

	ddatabase := dDataAtual 

Return


Static Function CARVET02(aVetor)
	Local nConta as Numeric

	aEval(aVetor, {|X| iif(X[1],nConta++,0) })
	if nConta > 0
		Processa( {|| U_CN301REV(aVetor) }, "Aguarde...")
	else
		FWAlertInfo("Precisa ser selecionado o registro para processamento","Atenção!") 
	endif 

Return

Static Function CARVET03(aVetor)

	Processa( {|| Envemail(aVetor) }, "Aguarde...")

Return

/*/{Protheus.doc} CN301REV
Rotina para geração de reajuste 
automático
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 09/10/2023
@param aVetor, array, Vetor de Seleção
@return variant, Nil
/*/
User Function CN301REV(aVetor)
	Local oModel    := Nil	
	Local cTipRev   := '001'
	Local cJustific := 'Reajuste Automatico'	
	Local nNx       := 0
	Local aParam    := {}
	Local aRET      := {}
	Local cMotivo   := Space(100)
	Local nPerc     := 0
	Local cMesAno   := cValToChar(MONTH( dDatabase ))+"/"+cValToChar(Year(dDatabase))
	Local lResp     := .F.

	aAdd(aParam,{3,"Reajuste Padrão:",1,{"Não", "Sim"}, 90, .T.,.F.})
	aAdd(aParam,{1,"Motivo",cMotivo	,"@!",".T.","","",90,.F.})
	aAdd(aParam,{1,"Índice negociação(%)",nPerc	,"@E 999.99",".T.","","",90,.T.})
	aAdd(aParam,{1,"Mês/Ano negociação",cMesAno	,"@R 99/9999",".T.","","",90,.T.})
	aAdd(aParam,{3,"Edita E-mail:",1,{"Não", "Sim"}, 90, .T.,.F.})

	lResp := ParamBox(aParam, "Informe os Dados", @aRET)	
	if !lResp 
		cMsg := "Deseja realmente siar? Todo o processo será cancelado"
		lResp := Aviso("Atenção!", cMsg, {"Sim", "Não"}, 2, "Reajuste Automático")
		if lResp 
		   Return
		endif 
	Endif 
	
	For nNx := 1 to len(aVetor)

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
				oModel:SetValue( 'CN9MASTER'       , 'CN9_TIPREV' , cTipRev)       //- É obrigatório o preenchimento do tipo de revisão do contrato.		
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
				U_CN300AP(CN9->CN9_NUMERO, cRevisa) //Aprova revisão 
				U_IncluiRev(CN9->CN9_NUMERO, cRevisa)
				cRevisa := CnUltRev(CN9->CN9_NUMERO, cFilAnt)
				U_CN300AP(CN9->CN9_NUMERO, cRevisa)

				FWMsgRun(,{|| BRRELAJUST(aVetor[nNx,3]) },"Aguarde","Gerando Relatório - Contrato: "+aVetor[nNx,3])
			EndIf

		EndIf	
		
	Next

Return 


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



/*### Exemplo de aprovação utilizando a função CN300Aprov ###*/
 
User Function CN300AP(cContra,cRevisa)

//Local cFilCont := ' < FILIAL_DO_CONTRATO > '
//Local cContra  := ' < NÚMERO_DO_CONTRATO > '
//Local cRevisa  := ' <NÚMERO_DA_REVISÃO> '
Local nRet     := 0
Local cMsgErro := ""
Local lRet     := .F.
Local aArea    := CN9->(GetArea())
 
//=== Preparação do contrato para revisão ==================================CN301REVEMAIL===========================================================
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


User Function IncluiRev(cContra, cRevisa)    
	Local aErro      := {}
	Local _oModelGct := Nil
	Local cTipR      := '010'
	Local cJustific  := 'Aditivo Automatico'
	Local nVige
	Local dDatafim
	Local lCabCro    := .f.
	Local oObjCNB    := Nil
	Local _lRet      := .F.

	CN9->(DBSetOrder(1))
	If CN9->(DbSeek(xFilial("CN9")+cContra+cRevisa))

		nVige    := CN9->CN9_VIGE+12
		dDatafim := MonthSum(CN9->CN9_DTFIM,12)
	
		A300STpRev("G")                                
	
		_oModelGct := FWLoadModel("CNTA301")               
		_oModelGct:SetOperation(3)    
		_lRet := _oModelGct:Activate(.T.) 
			
		if _lRet
			_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_TIPREV' , cTipR)       //- É obrigatório o preenchimento do tipo de revisão do contrato.
			_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_JUSTIF' , cJustific)   //- É obrigatório o preenchimento da justificativa de revisão do contrato.
			_oModelGct:SetValue( 'CN9MASTER'       , 'CN9_VIGE'   , nVige) 
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
				_lRet := .F.
			EndIf	
			if _lRet
			   
			endif 
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



Static Function Envemail(aVetor)
	Local nNx

	For nNx := 1 to len(aVetor)

		CNC->(DBSetOrder(1))
		If CNC->(DbSeek(xFilial("CNC")+aVetor[nNx,3]+aVetor[nNx,4]))

			DbSelectArea("SA1")
			DbSetOrder(1)
			SA1->(DbSeek(xFilial("SA1")+CNC->CNC_CLIENT+CNC->CNC_LOJACL)) 

			xmMail:= SA1->A1_EMAIL
			xmTitulo := "REAJUSTE DE CONTRATO - "+Alltrim(aVetor[nNx,3])
			xmCorpo  := mailhtm(cMes, cPerc)

			U_BRENMAIL({xmMail,xmTitulo,xmCorpo,'','','',''})

		EndIf	

	Next	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ mailOrc         ºAutor³ Natalia Perioto             º Data ³ 31/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao³ Tabulacao de e-mail de orcamento                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function mailhtm(cMes, cPerc)
	Local _cTexto := ""

	_cTexto	+= '<html>'
	_cTexto	+= '<head>'
	_cTexto	+= '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
	_cTexto	+= '</head>'
	_cTexto	+= '<body>'
	_cTexto	+= '<p><span style="color:black">COMUNICADO</span> </p>'
	_cTexto	+= '<p><span style="color:black">Ref: REAJUSTE DE PREÇOS</span> </p>'
	_cTexto	+= '<p><span style="color:black">Prezado Cliente,</span> </p>'
	_cTexto	+= '<p><span style="color:black">Servimo-nos da presente, para lhes comunicar que os '
	_cTexto	+= 'valores dos serviços prestados, serão reajustados a partir de '+cMes+' na base de '+cPerc+'% em face do IGPM. </span></p>'
	_cTexto	+= '<p><span style="color:black">Cumpre ressaltar que o(s) valor(es) descrito(s) no anexo sofrerão reajuste conforme os termos '
	_cTexto	+= 'do contrato de prestação de serviços em vigor, especificamente na Cláusula que prevê a "Forma de Reajuste". </span></p>'
	_cTexto	+= '<p><span style="color:black">Agradecemos a compreensão e nos colocamos à disposição para esclarecer eventuais dúvidas. </span></p> '
	_cTexto	+= '<p><span style="color:black">Atenciosamente,</span> </p> '
	_cTexto	+= '<p class="MsoNormal">&nbsp;</p> '
	_cTexto	+= '<p><span style="color:black">DEPARTAMENTO JURÍDICO.</span> </p> '
	_cTexto	+= '<p><span style="color:black">BRK Tecnologia.</span> </p> '
	_cTexto	+= '</body>'
	_cTexto	+= '</html>'

Return(_cTexto)


 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Marca     ºAutor  ³Eduardo Augusto     º Data ³  22/10/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que Perguntas do SX1.					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ I2I Eventos						                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ValidPerg()
Local i
Local j
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
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
