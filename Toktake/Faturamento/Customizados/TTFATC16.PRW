/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC16  บAutor  ณJackson E. de Deus  บ Data ณ  12/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBaixa o titulo a pagar NDF								  บฑฑ
ฑฑบ          ณGera o titulo a receber NDV.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTFATC16(cCodFil,cCodForn,cLjForn,cNFOrig,cSerieOrig,cCodForn,cLjForn,cNFSaida,cSerie)

Local aIncNDV		:= {}
Local cPrefixo		:= cCodFil+cSerie
Local cNatureza		:= ""
Local cMotivo		:= "BAIXADO VIA NF DE DEVOLUCAO"
Local cTitulo		:= cNFSaida
Local cParcela		:= "1"
Local cTipo			:= "NDV"
Local cTxtTipo		:= "NOTA DEVOLUCAO FORNECEDOR"
Local nDiasVcto		:= SuperGetMv("MV_XNDV002",.T.,10)
Local dDataVcto		:= dDatabase+nDiasVcto
Local dDtVctReal	:= DataValida(dDatabase+nDiasVcto,.T.)
Local cCGCForn      := " "
Local lCliente      := .F.

Private lMsErroAuto := .F.
Private lIncNDV     := .F.

If cEmpAnt <> "01"
	Return
EndIf


ProcRegua(2)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBaixa o titulo NDF - a pagar.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

// Verifica se o titulo existe
dbSelectArea("SE2")
dbSetOrder(1)	//E2_FILIAL + E2_PREF + E2_NUM +E2_PARCELA +E2_TIPO +E2_FORNECE +E2_LOJA
cNatureza := Posicione("SE2",1,xFilial("SE2") +AvKey(cPrefixo,"E2_PREFIXO") +cNFSaida +AvKey("1","E2_PARCELA") +AvKey("NDF","E2_TIPO") +cCodForn +cLjForn,"E2_NATUREZ" )
dbSeek(xFilial("SE2") +AvKey(cPrefixo,"E2_PREFIXO") +cTitulo +AvKey(cParcela,"E2_PARCELA") +"NDF" +cCodForn +cLjForn)
If Found() .AND. SE2->E2_SALDO > 0
	
	_aBxSe2 := {{"E2_FILIAL"	,SE2->E2_FILIAL		,Nil},;
	{"E2_PREFIXO"  ,SE2->E2_PREFIXO					,Nil},;
	{"E2_NUM"      ,SE2->E2_NUM						,Nil},;
	{"E2_PARCELA"  ,SE2->E2_PARCELA  				,Nil},;
	{"E2_TIPO"     ,SE2->E2_TIPO     				,Nil},;
	{"E2_FORNECE"  ,SE2->E2_FORNECE    				,Nil},;
	{"E2_LOJA"     ,SE2->E2_LOJA     				,Nil},;
	{"AUTMOTBX"    ,'DAC'							,Nil},;
	{"AUTBANCO"    ," "								,Nil},;
	{"AUTAGENCIA"  ," "								,Nil},;
	{"AUTCONTA"    ," "								,Nil},;
	{"AUTDTBAIXA"  ,dDatabase						,Nil},;
	{"AUTDTCREDITO",dDatabase			  			,Nil},;
	{"AUTHIST"     ,"Baixa Devol็ใo/NDV" 			,Nil},;
	{"AUTVALREC"   ,0  				  				,Nil},;
	{"AUTJUROS"	,0					  				,Nil}}
	
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInclui o Fornecedor Como Clienteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	IncProc("Verificando Cadastro de Cliente..")
	
	
 	cCGCForn := Posicione("SA2",1,xFilial("SA2")+cCodForn+cLjForn,"A2_CGC")
	
	DbSelectArea("SA1")
	DbSetOrder(3)
	If Dbseek(xFilial("SA1")+cCGCForn) .AND. !EMPTY(cCGCForn)
		cCodCli  := SA1->A1_COD
		cLojaCli := SA1->A1_LOJA
		aCliente := {}
		lCliente := .T.
	Else
		
		cNewCod		:= GetSXENum("SA1","A1_COD")
		cNewLoja	:= "0001"
		
		aCliente :={{"A1_COD"    ,cNewCod                                                  ,Nil},;
		{"A1_LOJA"   ,cNewLoja                                                         		,Nil},;
		{"A1_NOME"   ,SubStr(SA2->A2_NOME,1,40)                                    		,Nil},;
		{"A1_NREDUZ" ,SubStr(SA2->A2_NREDUZ,1,20)                                    	    ,Nil},;
		{"A1_PESSOA" ,SA2->A2_TIPO                                               			,Nil},;
		{"A1_TIPO"   ,"F"																	,Nil},;
		{"A1_END" 	 ,SA2->A2_END                                               	        ,Nil},;
		{"A1_EST"    ,SA2->A2_EST															,Nil},;
		{"A1_ESTE"   ,SA2->A2_EST															,Nil},;
		{"A1_COD_MUN",SA2->A2_COD_MUN														,Nil},;
		{"A1_MUN"    ,SubStr(SA2->A2_MUN,1,25)                                   			,Nil},;
		{"A1_BAIRRO" ,SubStr(SA2->A2_BAIRRO,1,30)		                                   	,Nil},;
		{"A1_CEP"    ,SA2->A2_CEP	                                                    	,Nil},;
		{"A1_DDD"    ,"11"                                                    				,Nil},;
		{"A1_DDI"    ,"55"                                                   				,Nil},;
		{"A1_EMAIL"  ,"NFE@TOKTAKE.COM.BR"                                     				,Nil},;
		{"A1_TEL"    ,SA2->A2_TEL                                                    		,Nil},;
		{"A1_CGC"    ,SA2->A2_CGC                                                         	,Nil},;
		{"A1_INSCR"  ,SA2->A2_INSCR                                               			,Nil},;
		{"A1_PAIS","105"                                                         			,Nil},;
		{"A1_CODPAIS","01058"                                                         		,Nil},;
		{"A1_CONTA" ,GETMV("MV_XCCCLI")                                                		,Nil},;
		{"A1_TIPFRET","C"                                                         			,Nil},;
		{"A1_TRANSP","000001"                                                         		,Nil},;
		{"A1_CONTATO","TOK_TAKE"                                                       		,Nil},;
		{"A1_MSBLQL" ,"1"                                                				    ,Nil}}
		
	Endif
	
	// Verifica se ja existe o novo tipo NDV
	dbSelectArea("SX5")
	dbSetOrder(1) // filial + tabela + chave
	dbSeek(xFilial("SX5") +"05" +cTipo)
	If !Found()
		If RecLock("SX5",.T.)
			SX5->X5_FILIAL	:= xFilial("SX5")
			SX5->X5_TABELA	:= "05"
			SX5->X5_CHAVE	:= cTipo
			SX5->X5_DESCRI	:= cTxtTipo
			SX5->X5_DESCSPA := cTxtTipo
			SX5->X5_DESCENG := cTxtTipo
			MsUnlock()
		EndIf
	EndIf
	
	// Verifica se o titulo ja existe
	dbSelectArea("SE1")
	dbSetOrder(1)	//E1_FILIAL + E1_PREF + E1_NUM +E1_PARCELA +E1_TIPO
	dbSeek(xFilial("SE1") +AvKey(cPrefixo,"E2_PREFIXO") +cNFSaida +"   " +"NDV")
	If Found()
		Alert("Tํtulo CR/CP Jแ Criado: "+SF2->F2_DOC + "-" + SF2->F2_SERIE)
		lIncNDV := .T.
		return()
	EndIf
	
	aIncNDV  := {	{"E1_PREFIXO" ,cPrefixo		,Nil},;
	{"E1_NUM"	  ,cNFSaida		,Nil},;
	{"E1_PARCELA" ,"   "   		,Nil},;
	{"E1_TIPO"	  ,"NDV"   		,Nil},;
	{"E1_NATUREZ" ,cNatureza	,Nil},;
	{"E1_CLIENTE" ,IIF(lCliente == .T.,cCodCli,cNewCod)	,Nil},;
	{"E1_LOJA"	  ,IIF(lCliente == .T.,cLojaCli	,cNewLoja)	,Nil},;
	{"E1_EMISSAO" ,dDataBase	,Nil},;
	{"E1_VENCTO"  ,dDataVcto	,Nil},;
	{"E1_VENCREA" ,dDtVctReal	,Nil},;
	{"E1_NUMNOTA" ,cNFSaida	    ,Nil},;
	{"E1_SERIE"	  ,cSerie	    ,Nil},;
	{"E1_ORIDOC"  ,cNFOrig	    ,Nil},;
	{"E1_ORISER"  ,cSerieOrig   ,Nil},;
	{"E1_MOTIVO"  ,"DEVOLUCAO"  ,Nil},;
	{"E1_XUSERPR" ,cUserName	,Nil},;
	{"E1_XUSERDT" ,dDatabase	,Nil},;
	{"E1_XUSERHR" ,Time()		,Nil},;
	{"E1_VALOR"	  ,nValor := Posicione("SF2",2, xFilial("SF2") +cCodForn+cLjForn+cNFSaida +cSerie,"F2_VALBRUT")       ,Nil }}
	
	If len(aCliente) > 0
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณInclusao de Fornecedor como Clienteณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		MSExecAuto({|x,y| Mata030(x,y)},aCliente,3) //Inclusao
		
		IncProc("Incluindo Cadastro de Cliente..")
		If lMsErroAuto
			MostraErro()
			Alert("Erro ao incluir Cliente. Contate o Administrador.")
			Return()
		Else
			ConfirmSX8()
		Endif
		
	Endif
	
	If len(_aBxSe2) > 0 .AND. len(aIncNDV) > 0
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณBaixa o Titulo NDF				  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		IncProc("Baixando tํtulo NDF..")
		MSExecAuto({|x,y| FINA080(x,y)},_aBxSe2,3)
		
		If lMsErroAuto
			MostraErro()
			lMsErroAuto := .F.
		Endif
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGera o titulo NDV - a receberณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		IncProc("Incluindo tํtulo NDV..")
		MSExecAuto({|x,y| Fina040(x,y)},aIncNDV,3) //Inclusao
		
		If lMsErroAuto
			MostraErro()
		EndIf
		
	Endif	
	
	Return()
	
Else
	Alert("Tํtulo Jแ Baixado: "+SF2->F2_DOC + "-" + SF2->F2_SERIE)
EndIf


Return()
