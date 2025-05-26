#INCLUDE "TOTVS.CH"

#DEFINE FILIAL_ORIGEM			1
#DEFINE FILIAL_DESTINO			2
#DEFINE DATA_CORTE				3
#DEFINE SERIE_PREFIXO_DESTINO	4
#DEFINE GRUPO_ORIGEM			5
#DEFINE GRUPO_DESTINO			6
#DEFINE DISPO_DATA_BAIXA		7


/*/{Protheus.doc} INCCR1
	Função do incoporador para simulação da transferência 
    do processo de contas a Receber entre filiais.
	@author Telso Carneiro	
	@since 05/04/2021
/*/
User Function INCCR1(cPar)

Local aPar      := {}
Local cIdProc   := ''
Local cCodRot   := ''
Local cTMP      := ''
Local cUNAtu    := ''
Local cUNNova	:= ''
Local cGrpAtu	:= ''	//Issue TIPDBP-1113
Local cGrpDes	:= ''	//Issue TIPDBP-1113
Local aArea     := GetArea()
Local aAreaPGG  := PGG->(GetArea())
Local aAreaPGH  := PGH->(GetArea())
Local cQuery    := ''
//Local aResp 	:= ARRAY(4)
Local aIncRod	:= {}
Local aItmRod	:= {}
Local lLibera	:= .T.
Local nCont 	:= 0
Local cBkpGrp	:=	cEmpAnt
Local lGrpDif 	:=	.F.
Local aIntGrp	:=	{} 	//Issue TIPDBP-1113

FWJsonDeserialize(cPar, @aPar)

cIdProc := aPar[1]
cCodRot := aPar[2]

PGG->(DbSetOrder(1))
PGG->(DbSeek(xFilial("PGH") + cIDProc ))

PGH->(DbSetOrder(1))
PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

cGrpAtu	:= PGG->PGG_GRPORI	//Issue TIPDBP-1113
cUNAtu 	:= PGG->PGG_FILORI
cGrpDes	:= PGG->PGG_GRPDES	//Issue TIPDBP-1113
cUNNova := PGG->PGG_FILDES

lGrpDif := cGrpAtu <> cGrpDes  //Issue TIPDBP-1113

aIncRod := U_INCFUN2(cUNAtu,cUNNova)
aItmRod := Separa(Alltrim(SuperGetMV("TI_INCLIB",,"U_INCCOM1/U_INCAVP1/U_INCPDD1",cUNAtu)), "/", .T.) 

IF !(EXISTBLOCK("F070VMOT_PE"))
	MsgAlert("Ponto de Entrada F070VMOT_PE não compilado no RPO")
	Return
EndIf

IF !MovBcobx("TRA", .T.)
	MsgAlert("MOTIVO DA BAIXA DO TITULO NO FINANCEIRO 'TRA', DEVE ESTAR COM MOV. BANCARIA = SIM")	
	Return
EndIF

If len(aIncRod) > 0
	For nCont := 1 to len(aItmRod)
		nPos := Ascan(aIncRod,{|x| Alltrim(x[3]) == Alltrim(aItmRod[nCont])})
		If nPos == 0
			//MsgAlert("Processo "+substr(aItmRod[nCont],6,3)+" deve ser rodado antes do processo de Contas a Receber")
			//#lLibera := .F.
		EndIf
	Next nCont 

	If lLibera
		//Issue TIPDBP-1113
		If lGrpDif
			cEmpAnt := cGrpAtu
			RpcClearEnv()
			RpcSetType(3)
    		RPCSetEnv(cEmpAnt,cUNAtu)
		EndIF 

		cTMP := MontaQry(cUNAtu, @cQuery)

		If Empty(cTMP)

			MsgAlert("Não existem Contas a Receber na unidade " + cUNAtu)

			//Issue TIPDBP-1113
			If lGrpDif
				cEmpAnt := cBkpGrp
				RpcClearEnv()
				RpcSetType(3)
				RPCSetEnv(cEmpAnt,cUNNova)
			EndIF

			RestArea(aAreaPGH)
			RestArea(aAreaPGG)
			RestArea(aArea)

			Return 

		EndIf 

		//Issue TIPDBP-1113
		If lGrpDif
			//Migração de dados entre grupos de empresas diferentes
			//Jogando em array primeiro, pois fazendo direto, quando limpa o environment limpa a tabela que esta percorrendo junto.
			While  (cTMP)->(! Eof())
				
				//u_TILogNew(cIdProc, cCodRot, (cTMP)->CHAVE, cQuery, "SE1", (cTMP)->RECNO )
				Aadd(aIntGrp,{cIdProc, cCodRot, (cTMP)->TITKEY, cQuery, "SE1", (cTMP)->REGE1})

				(cTMP)->(DbSkip())
			End

			(cTMP)->(DbCloseArea())

			cEmpAnt := cBkpGrp
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(cEmpAnt,cUNNova)

			For nCont := 1 to len(aIntGrp)
				u_TILogNew(aIntGrp[nCont,01],aIntGrp[nCont,02],aIntGrp[nCont,03],aIntGrp[nCont,04],aIntGrp[nCont,05],aIntGrp[nCont,06])
			Next nCont 
		Else 
			While  (cTMP)->(! Eof())
				
				u_TILogNew(cIdProc, cCodRot, (cTMP)->TITKEY, cQuery, "SE1", (cTMP)->REGE1 )

				(cTMP)->(DbSkip())
			End

			(cTMP)->(DbCloseArea())
		EndIf 
	EndIf
else
	MsgAlert("Ainda não foram rodados os processos de Comissão,AVP e PDD que devem obrigatoriamente serem rodados antes do Contas a Receber")
EndIf

RestArea(aAreaPGH)
RestArea(aAreaPGG)
RestArea(aArea)

Return 

/*/{Protheus.doc} MontaQry

	Função de retorno da query dos processos de contas 
    a receber que serão transferidos entre filias.
	@author nascimento.denison		
	@since 05/04/2021

/*/
Static Function MontaQry(cUNAtu, cQuery)

Local cAliasTrb := GetNextAlias()

BeginSql Alias cAliasTrb
	SELECT  SE1.E1_FILIAL||SE1.E1_PREFIXO||SE1.E1_NUM||SE1.E1_PARCELA||SE1.E1_TIPO TITKEY,
			SE1.R_E_C_N_O_ REGE1
	FROM %table:SE1% SE1
	WHERE SE1.E1_FILIAL = %exp:cUNAtu%
		AND SE1.E1_SALDO > 0
		AND SE1.E1_TIPO NOT LIKE '%-'			
		AND SE1.%notDel%
	ORDER BY E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO	
EndSql

cQuery := GetLastQuery()[2]

If (cAliasTrb)->(Eof())		
	(cAliasTrb)->(DbCloseArea())
	Return ''
EndIf

Return cAliasTrb

/*/{Protheus.doc} INCCR2
	Função do incoporador para efetivação da transferência 
    do processo de contas a rececber entre filiais.    
	@author Telso Carneiro	
	@since 12/04/2021
/*/
User Function INCCR2(cPar)

Local cMsgLog   := ''
Local lRet      := .F.
Local aPar      := {}
Local cBxDtFin  := ""
Local cFilOrig  := ""
Local cDtCorte  := ""
Local nRecnoSE1 := 0
Local lComisLib := .F.
Local cFilOld   := cFilAnt
Local oObjFIN   := NIL
Local aPergun1  := {}
Local aPergun2  := {}
Local aRetPar   := {}
Local lMonoTrd  := .F.
Local aCampX1	:= {"X1_PRESEL","X1_CNT01","X1_GRUPO","X1_ORDEM"}
Local nRecPGI 	:=	0	//Issue TIPDBP-1113
Local nCont 			//Issue TIPDBP-1113

Private aResp   := ARRAY(7)
Private cId     := ''
Private cCodRot	:= ''
Private cChave	:= ''
Private lSimula := .F.
Private cErroCP	:= ''	
//Issue TIPDBP-1113
Private cEmpBkp	:=	cEmpAnt
Private cFilBkp	:=	cFilant 
Private aLogsFim:=	{} 	//Issue TIPDBP-1113

FWJsonDeserialize(cPar, @aPar)

cId     := aPar[1]
cCodRot := aPar[2]
cChave  := aPar[3]
lSimula := aPar[4]

aRetPar := U_JLoadPar("INCORPORADOR") 

If Len(aRetPar)==0 .OR. (Len(aRetPar) >= 4 .And. lower(aRetPar[4])=="mono")
	lMonoTrd := .T.
ENDIF   

If !lMonoTrd
	cErroCP := "Este processo deve ser executado em MonoThread"
	U_TILogMsg(cId, cCodRot, cChave, cErroCP)
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
	Return cErroCP
ENDIF

PGG->(DbSetOrder(1))
PGG->(DbSeek(xFilial("PGH") + cId ))

aResp[FILIAL_ORIGEM] 		:= PGG->PGG_FILORI
aResp[FILIAL_DESTINO]		:= PGG->PGG_FILDES
aResp[DATA_CORTE]	 		:= STOD(DTOS(U_TIncISX1(cCodRot, aPar[5], "01")))//Data Corte
aResp[SERIE_PREFIXO_DESTINO]:= {}
//Issue TIPDBP-1113
aResp[GRUPO_ORIGEM] 		:= PGG->PGG_GRPORI
aResp[GRUPO_DESTINO]		:= PGG->PGG_GRPDES
//aResp[7]					:= U_TIncISX1(cCodRot, aPar[5], "03")//Disponibilização Data Baixa
//DISPO_DATA_BAIXA


If !lSimula
 	PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cId + cCodRot + cChave))
	If PGI->PGI_STEXEC == "3"
		Return cMsgLog
 	EndIf
EndIf

U_TILogBegin(cId, cCodRot, cChave, lSimula)

cFilOrig := aResp[FILIAL_ORIGEM]
cDtCorte := DTOS(aResp[DATA_CORTE])
nRecnoSE1:= PGI->PGI_RECORI
nRecPGI	 := PGI->(Recno()) //Issue TIPDBP-1113

//Issue TIPDBP-1113
If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
	cEmpAnt := aResp[GRUPO_ORIGEM]
	RpcClearEnv()
	RpcSetType(3)
	RPCSetEnv(cEmpAnt,cFilOrig)
EndIF 

cFilAnt := aResp[FILIAL_ORIGEM] 
lComisLib := GetMv("TI_COMISLB",,.F.)  //Criado para garantir que a comissão rode primeiro e só após o ok do pessoal referente a conferencia rodar as outras funções
cFilAnt := cFilOld // Restaura filial atual
cEmpAnt := cEmpBkp

If !lComisLib
	cErroCP := "Comissao não liberada verifique o parametro TI_COMISLB (SX6) "
	If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpBkp,cFilBkp)
	EndIf
	U_TILogMsg(cId, cCodRot, cChave, cErroCP)
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
	Return cErroCP
EndIf

__cInternet := 'AUTOMATICO'
cModulo		:= 'FIN'
nModulo		:= 6		
cBxDtFin    := GetMv("MV_BXDTFIN")

cAliasX	:=	"SX1"
// Força pergunte para não contabilizar on-line
oObjFIN := FWSX1Util():New()
oObjFIN:AddGroup("FIN070")
oObjFIN:AddGroup("FIN080")
oObjFIN:SearchGroup()
PERGUNTE("FIN070",.F.)
aPergun1 := oObjFIN:GetGroup("FIN070")
If ( MV_PAR04 == 1 .OR.  aPergun1[2,4]:NX1_PRESEL == 1 )
	If &(cAliasX)->(dbSeek(Pad("FIN070",Len(&(cAliasX+"->"+aCampX1[3])))+Pad("04",Len(&(cAliasX+"->"+aCampX1[4])))))
		RecLock(cAliasX,.F.)	
		&(cAliasX+"->"+aCampX1[1]) := 2
		&(cAliasX+"->"+aCampX1[2]) := "2"
		MsUnLock()
	EndIf
EndIf

PERGUNTE("FIN080",.F.)
aPergun2 := oObjFIN:GetGroup("FIN080")
If ( MV_PAR03 == 1 .OR. aPergun2[2,3]:NX1_PRESEL == 1 )
	If &(cAliasX)->(dbSeek(Pad("FIN080",Len(&(cAliasX+"->"+aCampX1[2])))+Pad("03",Len(&(cAliasX+"->"+aCampX1[4])))))
		RecLock(cAliasX,.F.)	
		&(cAliasX+"->"+aCampX1[1]) := 2
		&(cAliasX+"->"+aCampX1[2]) := "2"
		MsUnLock()
	EndIf
EndIf

oObjFIN:Destroy()
FreeObj(oObjFIN)

IF !(EXISTBLOCK("F070VMOT"))
	cErroCP := "PONTO DE ENTRADA 'F070VMOT_PE.PRW' NAO COMPILADO NO AMBIENTE "
	If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpBkp,cFilBkp)
	EndIf
	U_TILogMsg(cId, cCodRot, cChave, cErroCP)
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
	Return cErroCP
EndIf

IF !MovBcobx("TRA", .T.)
	cErroCP := "MOTIVO DA BAIXA DO TITULO NO FINANCEIRO 'TRA', DEVE ESTAR COM MOV. BANCARIA = SIM"
	If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpBkp,cFilBkp)
	EndIf
	U_TILogMsg(cId, cCodRot, cChave, cErroCP)
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
	Return cErroCP
EndIF

SE1->(DbGoto(nRecnoSE1))

aResp[SERIE_PREFIXO_DESTINO] := U_INCFUN1(aResp[FILIAL_ORIGEM])  //If(Empty(aResp[SERIE_PREFIXO_DESTINO]),SE1->E1_PREFIXO,aResp[SERIE_PREFIXO_DESTINO])

Begin Transaction

	If (lRet := TransfPDP())
		
		//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"PDP (RPS) data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
		Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"PDP (RPS) data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
		
		If cEmpAnt <> aResp[GRUPO_ORIGEM]
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
		EndIf

		SE1->(DbGoto(nRecnoSE1))
		
		If (lRet := TransfPDQ())
			//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"PDQ (GUIAS) data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
			Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"PDQ (GUIAS) data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
		EndIf 
	EndIf

	If lRet
		If cEmpAnt <> aResp[GRUPO_ORIGEM]
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
		EndIf
		SE1->(DbGoto(nRecnoSE1))
		If ( lRet := TransfSE1() )
			//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"Titulo SE1 data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
			Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"Titulo SE1 data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
			
			If cEmpAnt <> aResp[GRUPO_ORIGEM]
				RpcClearEnv()
				RpcSetType(3)
				RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
			EndIf

			SE1->(DbGoto(nRecnoSE1))
			If ( lRet := TransfNFS() )
				//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"NOTAS SAIDA data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")					
				Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"NOTAS SAIDA data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
				
				If cEmpAnt <> aResp[GRUPO_ORIGEM]
					RpcClearEnv()
					RpcSetType(3)
					RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
				EndIf

				SE1->(DbGoto(nRecnoSE1))
				If ( lRet := TransfBoleto() )
					//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"BOLETOS data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
					Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"BOLETOS data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
					
					If cEmpAnt <> aResp[GRUPO_ORIGEM]
						RpcClearEnv()
						RpcSetType(3)
						RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
					EndIf

					SE1->(DbGoto(nRecnoSE1))
					// Se houve uma baixa parcial no titulo, efetua a transferência da moVimentação bancária
					If !(Str(SE1->E1_SALDO,18,2) == Str(SE1->E1_VALOR,18,2))
						IF (lRet := TrfMovCR())
							//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"houve uma baixa parcial no titulo moVimentação bancária data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
							Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"houve uma baixa parcial no titulo moVimentação bancária data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
							
						EndIf
					Endif
					If lRet
						If cEmpAnt <> aResp[GRUPO_ORIGEM]
							RpcClearEnv()
							RpcSetType(3)
							RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
						EndIf

						SE1->(DbGoto(nRecnoSE1))

						If !lSimula .And. !Empty(SE1->E1_IDCNAB)
							SE1->(DbGoto(nRecnoSE1))
							// Troca o ID CNAB na filial de origem, para que as baixas CNAB
							// seja executadas na nova filial
							RecLock("SE1",.F., , .T. , .T. )
							SE1->E1_IDCNAB := "-" + Substr(SE1->E1_IDCNAB,2) 
							MsUnLock()

							//U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"Troca o ID CNAB na filial de origem E1_IDCNAB data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
							Aadd(aLogsFim,{cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"Troca o ID CNAB na filial de origem E1_IDCNAB data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK"})
						EndIf
					EndIf			
				EndIf
			EndIf
		EndIf
	EndIf		

	If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpBkp,cFilBkp)
	EndIf

	For nCont := 1 to len(aLogsFim)
		U_TILogMsg(aLogsFim[nCont,01],aLogsFim[nCont,02],aLogsFim[nCont,03],aLogsFim[nCont,04])
	Next nCont 

	If lRet
		cErroCP := ""
		U_TILogMsg(cId, cCodRot, cChave, If(lSimula,"Simulacao: ","Execucao: ")+"Transferência do título a receber realizada com sucesso data/hora:"+Dtoc(dDatabase)+"/"+time()+" -> OK")
	Else
		cErroCP := "Erro na Transferência do título a receber com ROLLBACK -> ERROR"
		U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		DisarmTransaction()
	EndIf

End Transaction

If Alltrim(cBxDtFin) <> Alltrim(GetMv("MV_BXDTFIN"))
	// Restaura o parâmetro
	PutMv("MV_BXDTFIN", cBxDtFin)
EndIf

If lRet
	U_TILogEnd(cId, cCodRot, cChave, lSimula, cMsgLog)
Else        
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
EndIf 

Return cErroCP


/*/{Protheus.doc} INCCR2
	Função do incoporador para efetivação da transferência 
    do processo de contas a rececber entre filiais.    
	@author Telso Carneiro	
	@since 12/04/2021
/*/
Static Function TransfPDP()

Local cAliasTrb 	:= GetNextAlias()
Local lRet 			:= .T.
Local aCposAlt 		:= {}
Local cFilOrig  	:= aResp[FILIAL_ORIGEM]
Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
Local aGrpDif		:=	{}
Local nCont 		:=	0

BeginSql Alias cAliasTrb
	//JOIN %table:SF2% SF2 ON F2_FILIAL = %exp:cFilDest% 
	SELECT COUNT(*) OVER (PARTITION BY ' ') TOT, PDP.R_E_C_N_O_ RECNOTAB
	FROM %table:PDP%  PDP
	JOIN %table:SF2% SF2 ON F2_FILIAL = %exp:cFilOrig% 
		AND SF2.F2_DOC = %exp:SE1->E1_NUM%
		AND SF2.F2_SERIE = %exp:SE1->E1_PREFIXO%
		AND SF2.F2_CLIENT = %exp:SE1->E1_CLIENTE%
		AND SF2.F2_LOJA = %exp:SE1->E1_LOJA%		 	
		AND SF2.F2_DOC = PDP_DOC 
		AND SF2.F2_CLIENTE = PDP_CLIENT 
		AND SF2.%notdel%
	WHERE PDP_FILIAL = %exp:cFilOrig%    
		AND PDP.%notdel%
EndSql


SM0->(DbSeek(aResp[GRUPO_DESTINO]+aResp[FILIAL_DESTINO]) )

While !(cAliasTrb)->(Eof())

	PDP->(DbGoto((cAliasTrb)->RECNOTAB))

	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(PDP->PDP_SERIE)})
	
	cPreDest := ''
	
	If nPosDp > 0
		cPreDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf

	aCposAlt := { 	{ "PDP_FILIAL"  , aResp[FILIAL_DESTINO] } ,; // Codigo da filial que recebera o titulo
					{ "PDP_SERIE"   , If(Empty(cPreDest),PDP->PDP_SERIE,cPreDest)   },; // Prefixo do título destino
					{ "PDP_EMPRES"  , SM0->M0_NOMECOM },;
					{ "PDP_ENDEMP"  , SM0->M0_ENDENT  },;
					{ "PDP_BAIREM"  , SM0->M0_BAIRENT },;
					{ "PDP_CIDEMP"  , SM0->M0_CIDENT  },;
					{ "PDP_UFEMP"   , SM0->M0_ESTENT  },;
					{ "PDP_CEPEMP"  , SM0->M0_CEPENT  },;
					{ "PDP_TELEMP"  , SM0->M0_TEL     },;
					{ "PDP_CNPJEM"  , Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")    },;
					{ "PDP_IEEMP"   , SM0->M0_INSC    },;
					{ "PDP_IMEMP"   , SM0->M0_INSCM   } }

	//Issue TIPDBP-1113
	If lGrpDif
		Aadd(aGrpDif,{(cAliasTrb)->RECNOTAB,aCposAlt})
	Else 
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg("PDP",aCposAlt) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> PDP"
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf

	EndIf

	(cAliasTrb)->(DbSkip())
End

(cAliasTrb)->(DBCloseArea())

//Issue TIPDBP-1113
If lGrpDif
	For nCont := 1 to len(aGrpDif)
		DbSelectArea("PDP")
		DbGoto(aGrpDif[nCont,01])
		aCposAlt := aGrpDif[nCont,02]
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg("PDP",aCposAlt) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> PDP"
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf
	Next nCont
EndIF

Return lRet


/*/{Protheus.doc} 
	Função do incoporador para efetivação da transferência 
    do processo de contas a rececber entre filiais.    
	@author Telso Carneiro	
	@since 12/04/2021
/*/
Static Function TransfPDQ()

Local cAliasTrb 	:= GetNextAlias()
Local lRet 			:= .T.
Local aCposAlt 		:= {}
Local cFilOrig  	:= aResp[FILIAL_ORIGEM]
Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
Local aGrpDif		:=	{}
Local nCont 		:=	0

BeginSql Alias cAliasTrb
	SELECT COUNT(*) OVER (PARTITION BY ' ') TOT, PDQ.R_E_C_N_O_ RECNOTAB
	FROM %table:PDQ%  PDQ
	JOIN %table:SF2% SF2 ON F2_FILIAL = %exp:cFilOrig% 
		AND SF2.F2_DOC = %exp:SE1->E1_NUM%
		AND SF2.F2_SERIE = %exp:SE1->E1_PREFIXO%
		AND SF2.F2_CLIENT = %exp:SE1->E1_CLIENTE%
		AND SF2.F2_LOJA = %exp:SE1->E1_LOJA%		 	
		AND SF2.F2_DOC = PDQ_DOC 
		AND SF2.F2_CLIENTE = PDQ_CLIENT 
		AND SF2.%notDel%
	WHERE PDQ_FILIAL = %exp:cFilOrig%
		AND PDQ.%notDel%
EndSql

SM0->(DbSeek(aResp[GRUPO_DESTINO]+aResp[FILIAL_DESTINO]) )
//SM0->(DbSeek(cEmpAnt+aResp[FILIAL_DESTINO]) )

// Processa os registros da PRB envolvidos
While !(cAliasTrb)->(Eof())

	PDQ->(DbGoto((cAliasTrb)->RECNOTAB))

	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(PDQ->PDQ_SERIE)})
	cPreDest := ''
	If nPosDp > 0
		cPreDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf

	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(PDQ->PDQ_PREFIX)})
	cPrexDest := ''
	If nPosDp > 0
		cPrexDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf

	aCposAlt := { 	{ "PDQ_FILIAL"  , aResp[FILIAL_DESTINO] } ,; // Codigo da filial que recebera o titulo
					{ "PDQ_SERIE"   , If(Empty(cPreDest),PDQ->PDQ_SERIE,cPreDest)   },; // Prefixo do título destino
					{ "PDQ_PREFIX"  , If(Empty(cPrexDest),PDQ->PDQ_PREFIX,cPrexDest)   },; // Prefixo do título destino
					{ "PDQ_FILRPS"  , aResp[FILIAL_DESTINO] } }

	//Issue TIPDBP-1113
	If lGrpDif
		Aadd(aGrpDif,{(cAliasTrb)->RECNOTAB,aCposAlt})
	Else 
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg("PDQ",aCposAlt) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> PDQ"
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf
	EndIf

	(cAliasTrb)->(DbSkip())
End

(cAliasTrb)->(DBCloseArea())

//Issue TIPDBP-1113
If lGrpDif
	For nCont := 1 to len(aGrpDif)
		DbSelectArea("PDQ")
		DbGoto(aGrpDif[nCont,01])
		aCposAlt := aGrpDif[nCont,02]
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg("PDQ",aCposAlt) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> PDQ"
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf
	Next nCont
EndIF

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TransfSE1
Transfere Titulos a Receber em aberto da Filial Origem para filial destino,
baixando o titulo na filial origem e incluindo na filial destino

@author		Claudio Donizete
@since		27/07/2018
@version	1.0
/*/
//-------------------------------------------------------------------
Static Function TransfSE1()

Local lRet 		:= .T.
Local aAreaSE1 	:= SE1->(GetArea())
Local cFilSe1 	:= aResp[FILIAL_ORIGEM]
Local cChaveSE1
Local cChaveNSE1
Local cTitPai
Local nRecNoSe1	:= SE1->(Recno())
Local nY
Local aTit 		:= {}
Local cTipoTrf
Local cTipoTit
Local aRecno	:= {}
Local aCposAlt
Local cFilOld 	:= cFilAnt

//Issue TIPDBP-1113
Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
Local aGrpDif		:=	{}
Local nCont 		:=	0


//.T. - Gera o titulo de ISS (se houver) na filial de destino juntamente com o titulo NF, baixando o titulo ISS na origem
//.F. - Nã gera o titulo de ISS na filial de destino, permanecendo o titulo ISS na origem em aberto.
Local lTrfISSf	:= GetNewPar("MV_TRFISSF",.T.)
Local cParcela 	:= ""
Local dOldDtBase := dDataBase
Local cErro
Local cAliasSev := "SEV_"+GetNextAlias()
Local cAliasSez := "SEZ_"+GetNextAlias()
Local aDatHist  := {}
Local cParTiBx  := SuperGetMV("TI_TIPDTBX",.F.,"3")

Private cNmFilD	:=	''	//Issue TIPDBP-1113

SE1->(DbSetOrder(1))
cChaveSE1 := cFilSe1 + SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)
cTitPai := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
cTipoTrf := SE1->E1_TIPO

nRecNoSe1 := SE1->(Recno())
// Posiciona no registro a ser transferido
SE1->(MsSeek(cChaveSE1))
// Primeiro adiciona os registros a serem transferidos, pois 00801000100	primeiro
// deve-se transferir o titulo principal, depois os agragados. Como os agragados podem
// vir primeiro, entao utiliza-se uma matriz de recnos para transferir os titulos na ordem
// em que foram incluidos, pois um abatimento nunca eh incluido primeiro que um titulo
// principal
// Os titulos de impostos nao se incluem nesta lista visto que os mesmos serao incluidos junto com
// o titulo principal
While SE1->(!Eof()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == cChaveSE1
	// Nao eh abatimento
	If (SE1->E1_TIPO $ MVABATIM) .Or. SE1->E1_TIPO == cTipoTrf // Titulo Principal
		Aadd(aRecno, SE1->(Recno()))
	ElseIf (SE1->E1_TIPO $ (MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT+"/"+MVISABT+"/"+MVFUABT))
		If !Empty(SE1->E1_TITPAI) .AND. Alltrim(SE1->E1_TITPAI) <> AllTrim(cTitPai)
			SE1->(DbSkip())
			Loop
		Endif
		Aadd(aRecno, SE1->(Recno()))
	EndIf
	SE1->(DbSkip())
End
aSort(aRecno)
// Transfere todos os titulos agregados
nY := 1
lMsErroAuto := .F.

While lRet .And. ! lMsErroAuto .And. nY <= Len(aRecno)
	SE1->(DbGoto(aRecno[nY]))
	cTipoTit := SE1->E1_TIPO  //Tipo do titulo que sera incluido para verificar a parcela
	// Incrementa a parcela para que nao haja registro duplicado na filial de Destino
	cParcela := SE1->E1_PARCELA
	
	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(SE1->E1_PREFIXO)})
	cPreDest := ''
	If nPosDp > 0
		cPreDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf
	cChaveNSE1 := aResp[FILIAL_DESTINO] + SE1->(If(Empty(cPreDest),SE1->E1_PREFIXO,cPreDest) + E1_NUM+cParcela+cTipoTit)

	While SE1->(MsSeek(cChaveNSE1))
		cParcela := Soma1(cParcela)
		cChaveNSE1 := aResp[FILIAL_DESTINO] + SE1->(If(Empty(cPreDest),SE1->E1_PREFIXO,cPreDest)+E1_NUM+cParcela+cTipoTit)
	End

	// Não transfere se o titulo já existir na filial de destino
	If SE1->(MsSeek(cChaveNSE1))
		lRet := .F.
		cErroCP := "Titulo já existe na filial de destino"
		U_TILogMsg(cId, cCodRot, cChave, cErroCP)
	Else
		lRet := .T.
		//ponteiro pode ter sido desposicionado ao buscar pelas parcelas do Titulo
		SE1->(DbGoto(aRecno[nY]))
		// Preenche o E1_TIPOLIQ, para que o cálculo de baixas parciais do novo titulo seja efetuada pela
		// dif. entre E1_VALOR - E1_SALDO e não pela soma das baixas do SE5 (não terá SE5 no novo titulo)
		// No CP não precisa fazer isso.
		aCposAlt := { 	{ "E1_FILIAL"  , aResp[FILIAL_DESTINO] } ,; // Codigo da filial que recebera o titulo
						{ "E1_FILORIG" , If(!(Alltrim(SE1->E1_FILIAL)==Alltrim(SE1->E1_FILORIG)), SE1->E1_FILORIG, aResp[FILIAL_DESTINO])	} ,; // Codigo da filial de origem do titulo
						{ "E1_MSFIL"   , If(!(Alltrim(SE1->E1_FILIAL)==Alltrim(SE1->E1_MSFIL)), SE1->E1_MSFIL, aResp[FILIAL_DESTINO])	} ,; // Codigo da filial de origem do titulo
						{ "E1_TIPOLIQ" , If(Alltrim(SE1->E1_TIPO)$MVRECANT,"","XXX")	} ,;
						{ "E1_LA"	   , "S"},;
						{ "E1_HIST"	   , Alltrim(SE1->E1_HIST) + " - TITULO ORIGINADO MIGRACAO DA FILIAL : " + aResp[FILIAL_ORIGEM] },;
						{ "E1_ORIGEM"  , "TINCCR" } ,; // Codigo da Rotina que originou o titulo
						{ "E1_PARCELA" , cParcela   } ,;
						{ "E1_TITPAI"  , If(!Empty(SE1->E1_TITPAI),If(Empty(cPreDest),SE1->E1_TITPAI,cPreDest+Substr(SE1->E1_TITPAI,4)), " ") },; // Troca o prefixo também no E1_TITPAI, para que consiga encontrar os impostos do novo titulo
						{ "E1_PREFIXO" , If(Empty(cPreDest),SE1->E1_PREFIXO,cPreDest)  } } // Prefixo do título destino
		
		//Issue TIPDBP-1113
		If lGrpDif
			Aadd(aGrpDif,{aRecno[nY],aCposAlt,"SE1",cChaveNSE1})
		Else 
			// Transfere o titulo para filial de destino
			If !lSimula .And. !(lRet := DuplicReg("SE1",aCposAlt) > 0)
				cErroCP := "Erro na criação do registro na filial de destino"
				U_TILogMsg(cId, cCodRot, cChave, cErroCP)
			EndIf
		EndIf 
		
		cAliasSev := "SEV_"+GetNextAlias()
		BeginSql Alias cAliasSev
			SELECT R_E_C_N_O_ RECNOSEV 
			FROM %table:SEV%
			WHERE EV_FILIAL = %exp:SE1->E1_FILIAL%
				AND EV_PREFIXO = %exp:SE1->E1_PREFIXO%
				AND EV_NUM = %exp:SE1->E1_NUM%
				AND EV_PARCELA = %exp:SE1->E1_PARCELA%
				AND EV_TIPO = %exp:SE1->E1_TIPO%
				AND EV_CLIFOR = %exp:SE1->E1_CLIENTE%
				AND EV_LOJA = %exp:SE1->E1_LOJA%
				AND EV_RECPAG = 'R'
				AND EV_IDENT = '1'
				AND %notDel%
		EndSql
		While !(cAliasSev)->(Eof())
			SEV->(DbGoto((cAliasSev)->RECNOSEV))
			aCposAlt := { 	{ "EV_FILIAL"  , aResp[FILIAL_DESTINO] },; // Codigo da filial que recebera o titulo
							{ "EV_PREFIXO" , If(Empty(cPreDest),SEV->EV_PREFIXO,cPreDest) } }  // Prefixo novo do titulo
			
			//Issue TIPDBP-1113
			If lGrpDif
				Aadd(aGrpDif,{(cAliasSev)->RECNOSEV,aCposAlt,"SEV"})
			Else 
				If !lSimula .And. !(lRet := DuplicReg("SEV",aCposAlt) > 0)
					cErroCP := "Erro na criação do registro na filial de destino"
					U_TILogMsg(cId, cCodRot, cChave, cErroCP)
				EndIf
			EndIf

			cAliasSez := "SEZ_"+GetNextAlias()
			BeginSql Alias cAliasSez
				SELECT R_E_C_N_O_ RECNOSEZ
				FROM %table:SEZ%
				WHERE EZ_FILIAL = %exp:SEV->EV_FILIAL%
					AND EZ_PREFIXO = %exp:SEV->EV_PREFIXO%
					AND EZ_NUM = %exp:SEV->EV_NUM%
					AND EZ_PARCELA = %exp:SEV->EV_PARCELA%
					AND EZ_TIPO = %exp:SEV->EV_TIPO%
					AND EZ_CLIFOR = %exp:SEV->EV_CLIFOR%
					AND EZ_LOJA = %exp:SEV->EV_LOJA%
					AND EZ_NATUREZ = %exp:SEV->EV_NATUREZ%
					AND EZ_IDENT = %exp:SEV->EV_IDENT%
					AND EZ_RECPAG = %exp:SEV->EV_RECPAG%
					AND %notDel%
			EndSql

			While !(cAliasSez)->(Eof())
				SEZ->(DbGoto((cAliasSev)->RECNOSEZ))
				aCposAlt := { 	{ "EZ_FILIAL"  , aResp[FILIAL_DESTINO] },;  // Codigo da filial que recebera o titulo
								{ "EZ_PREFIXO" , If(cPreDest,SEZ->EZ_PREFIXO,cPreDest) } }
				
				//Issue TIPDBP-1113
				If lGrpDif
					Aadd(aGrpDif,{(cAliasSev)->RECNOSEZ,aCposAlt,"SEZ"})
				Else
					If !lSimula .And. !(lRet := DuplicReg("SEZ",aCposAlt) > 0)
						cErroCP := "Erro na criação do registro na filial de destino"
						U_TILogMsg(cId, cCodRot, cChave, cErroCP)
					EndIf
				EndIf 
				(cAliasSez)->(DBSkip())
			End
			(cAliasSez)->(DBCloseArea())
			(cAliasSev)->(DBSkip())
		End
		(cAliasSev)->(DBCloseArea())
	EndIf
	nY++
End // Aqui efetuou a transferência dos titulos e seus agregados (Abatimentos)

//Issue TIPDBP-1113
If lGrpDif
	For nCont := 1 to len(aGrpDif)
		//Issue TIPDBP-1113
		If cEmpant <> aResp[GRUPO_ORIGEM]
			cEmpAnt := aResp[GRUPO_ORIGEM]
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])
		EndIF
		DbSelectArea(aGrpDif[nCont,03])
		DbGoto(aGrpDif[nCont,01])
		aCposAlt := aGrpDif[nCont,02]
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg(aGrpDif[nCont,03],aCposAlt,aGrpDif[nCont,04]) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> "+aGrpDif[nCont,03]
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf

		//Issue TIPDBP-1113
		/*cEmpAnt := aResp[GRUPO_ORIGEM]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])*/

	Next nCont

	

EndIF

SE1->(DbGoto(nRecNoSe1))

If lRet // .And. !(Alltrim(SE1->E1_TIPO) $ MVRECANT)

	//Issue TIPDBP-1113
	If cEmpant <> aResp[GRUPO_ORIGEM]
		cEmpAnt := aResp[GRUPO_ORIGEM]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])
	EndIF

	SE1->(DbGoto(nRecNoSe1))
	// Altera para filial do titulo de origem para fazer a baixa
	cFilAnt := cFilSe1
	aTit := {}
	aDatHist := strtokarr(cvaltochar(date()),"/")
	cHistDt  := aDatHist[1]+"/"+aDatHist[2]+"/"+substr(aDatHist[3],3)
	dDataBase := Min(SE1->E1_VENCREA, Date())
	//SM0->(DbSeek(cEmpant+aResp[FILIAL_DESTINO]) )
	AADD(aTit , {"E1_FILIAL"	, SE1->E1_FILIAL	, NIL})
	AADD(aTit , {"E1_PREFIXO"	, SE1->E1_PREFIXO	, NIL})
	AADD(aTit , {"E1_NUM"		, SE1->E1_NUM		, NIL})
	AADD(aTit , {"E1_PARCELA"	, SE1->E1_PARCELA	, NIL})
	AADD(aTit , {"E1_TIPO"		, SE1->E1_TIPO		, NIL})
	AADD(aTit , {"E1_CLIENTE"	, SE1->E1_CLIENTE	, NIL})
	AADD(aTit , {"E1_LOJA"		, SE1->E1_LOJA		, NIL})
	AADD(aTit , {"AUTMOTBX"		, "TRA"				, NIL})
	
	

	AADD(aTit , {"AUTDTBAIXA"	, dDataBase			, NIL})
	//AADD(aTit , {"AUTDTCREDITO" , dDataBase			, NIL})
	
	//AADD(aTit , {"AUTDTCREDITO" , If(aResp[7] == 3, DATE(), If(aResp[7] == 1, dDataBase, dDataBase+1)), NIL}) 
	AADD(aTit , {"AUTDTCREDITO" , If(cParTiBx == "3", DATE(), If(cParTiBx == "1", dDataBase, dDataBase+1)), NIL}) 
	AADD(aTit , {"AUTHIST"		, "Venda p/ "+Subs(ALLTRIM(SM0->M0_FILIAL),1,16)+" "+cHistDt,NIL}) 

	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))
		
	If Substr(SE1->E1_FILIAL,1,3) <> '000'
		
		SM0->(DbSeek(aResp[GRUPO_ORIGEM]+aResp[FILIAL_ORIGEM]) )

	Else 
		/*AADD(aTit , {"AUTBANCO"    	,SE1->E1_PORTADO       						,Nil    })
		AADD(aTit , {"AUTAGENCIA"  	,Avkey(SE1->E1_AGEDEP,"A6_AGENCIA")			,Nil    })
		AADD(aTit , {"AUTCONTA"    	,Avkey(ALLTRIM(SE1->E1_CONTA),"A6_NUMCON")  ,Nil    })*/
		
		AADD(aTit , {"AUTBANCO"    	,'CX1' 			      						,Nil    })
		AADD(aTit , {"AUTAGENCIA"  	,Avkey('00001',"A6_AGENCIA")				,Nil    })
		AADD(aTit , {"AUTCONTA"    	,Avkey('0000000001',"A6_NUMCON")  			,Nil    })
	EndIf 

	SA6->(DbSeek(xFilial("SA6")+SE1->E1_PORTADO+Avkey(SE1->E1_AGEDEP,"A6_AGENCIA")+Avkey(ALLTRIM(SE1->E1_CONTA),"A6_NUMCON")))
	

	// Executa a Baixa do Titulo
	lMsErroAuto := .F.
	lRet := .T.

	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	If !lSimula
		cNomFun := Funname()
		SetFunName("FINA070")
		MSExecAuto({|x, y| FINA070(x, y)}, aTit, 3)
		SetFunName(cNomFun)
	EndIf

	If lMsErroAuto
		cErro := MostraErro("\logs")
		cErroCP := "Erro na baixa do titulo via ExecAuto " + cErro
		U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		lRet := .F.
	Else
		If !lSimula .AND. lRet 
			SE1->(DbGoto(nRecNoSe1))
			RECLOCK("SE1",.F., , .T. , .T. )
			//SE1->E1_HIST := ALLTRIM(SE1->E1_HIST) + "Venda p/ "+Subs(ALLTRIM(SM0->M0_FILIAL),1,16)+" "+ cHistDt //" - TITULO BAIXADO MIGRACAO PARA FILIAL: " + aResp[FILIAL_DESTINO]
			SE1->E1_HIST := ALLTRIM(SE1->E1_HIST) + "Venda p/ "+Subs(ALLTRIM(SM0->M0_FILIAL),1,16)+" "+ cHistDt //" - TITULO BAIXADO MIGRACAO PARA FILIAL: " + aResp[FILIAL_DESTINO]
			//Ultima alteracao relacionada a data de baixa solicitada pela Sabrina
			//as datas devem ser preenchidas com o dia da incorporação.
			SE1->E1_BAIXA := date()
			SE1->(MSUNLOCK())
			//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
			DbSelectArea("SE5")
			DbSetOrder(7)
			cIDSE5 := ""
			If Dbseek(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
				Reclock("SE5",.F. , .T. , .T. )
				SE5->E5_DATA 	:= Date()
				SE5->E5_DTDIGIT := Date()
				SE5->E5_DTDISPO := Date()
				SE5->E5_BANCO   := ''
				SE5->E5_AGENCIA := ''
				SE5->E5_CONTA   := ''
				cIDSE5 := SE5->E5_IDORIG
				SE5->(MSUNLOCK())
			EndIf 

			If !Empty(cIDSE5)
				DbSelectArea("FK1")
				DbSetOrder(1)
				If Dbseek(SE1->E1_FILIAL+cIDSE5)
					Reclock("FK1",.F. , .T. , .T. )
					FK1->FK1_DATA 	:= Date()
					FK1->FK1_DTDIGI := Date()
					FK1->FK1_DTDISP := Date()
					FK1->(Msunlock())
				EndIf 
			EndIF 

			DbSelectArea("SE1")
			SE1->(DbGoto(nRecNoSe1))
		EndIf
	Endif

	If lRet
		SE1->(MsGoto(nRecNoSe1))
		If SE1->E1_ISS != 0 .And. lTrfISSf //.F. // SE1->E1_ISS != 0 .And. lTrfISSf -> comentado provisoriamente
			// Baixa tambem os registro de impostos-ISS
			SE2->(dbSetOrder(1)) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
			If SE2->(dbSeek(aResp[FILIAL_ORIGEM]+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA)))
				If AllTrim(SE2->E2_NATUREZ) == Alltrim(&(GetMv("MV_ISS"))) .and. STR(SE2->E2_SALDO,17,2) == STR(SE2->E2_VALOR,17,2)
					dDataBase := SE2->E2_VENCREA
					aTit := {}
					// Altera para filial do titulo de origem para fazer a baixa
					cFilAnt := aResp[FILIAL_ORIGEM]
					SM0->(DbSeek(cEmpant+aResp[FILIAL_ORIGEM]) )

					AADD(aTit , {"E2_FILIAL"	, SE2->E2_FILIAL	, NIL})
					AADD(aTit , {"E2_PREFIXO"	, SE2->E2_PREFIXO	, NIL})
					AADD(aTit , {"E2_NUM"		, SE2->E2_NUM		, NIL})
					AADD(aTit , {"E2_PARCELA"	, SE2->E2_PARCELA	, NIL})
					AADD(aTit , {"E2_TIPO"		, SE2->E2_TIPO		, NIL})
					AADD(aTit , {"E2_NATUREZ"	, SE2->E2_NATUREZ	, NIL})
					AADD(aTit , {"E2_FORNECE"	, SE2->E2_FORNECE	, NIL})
					AADD(aTit , {"E2_LOJA"		, SE2->E2_LOJA		, NIL})
					AADD(aTit , {"AUTMOTBX"		, "TRA"				, NIL})
					AADD(aTit , {"AUTDTBAIXA"	, dDataBase			, NIL})
					AADD(aTit , {"AUTHIST"		, "Venda p/ "+Subs(ALLTRIM(SM0->M0_FILIAL),1,16)+" "+ DTOC(aResp[DATA_CORTE]),NIL})
					
					// Executa a Baixa do Titulo
					lMsErroAuto := .F.
					
					If !lSimula
						MSExecAuto({|x, y| FINA080(x, y)}, aTit, 3)						
					EndIf
					If lMsErroAuto
						lRet	:= .F.
						cErro := MostraErro("\logs")
						cErroCP := "Erro na baixa via ExecAuto " + cErro
						U_TILogMsg(cId, cCodRot, cChave, cErroCP)
					Endif
				EndIf
			Endif
		EndIf
	EndIf
Endif

// Garante que o titulo voltará o mesmo originalmente posicionado
SE1->(RestArea(aAreaSE1))
cFilAnt := cFilOld // Restaura filial atual
dDataBase := dOldDtBase
If !lRet
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
EndIf 

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TransfNFS
Transfere Notas Fiscais de Saida, Item da NF, Pedido e Item do pedido 
da Filial Origem para filial destino, referente ao titulo a receber posicionado

@author		Claudio Donizete
@since		27/07/2018
@version	1.0
/*/
//-------------------------------------------------------------------
Static Function TransfNFS()
Local lRet := .T.
Local cAliasTrb := GetNextAlias()
Local cAliasItNf := "ITNF" + GetNextAlias()
Local cAliasSC9 := "SC9" + GetNextAlias()
Local cPedido
Local cNumPed := ""
Local cFilOld := cFilAnt
Local aCposAlt
Local cFilOrig := aResp[FILIAL_ORIGEM]
//Issue TIPDBP-1113
Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
Local aGrpDif		:=	{}
Local nCont 		:=	0
Local aDadosAGH		:=	{}		//Nova tabela a ser migrada - AGH 09/08/24 Venancio

BeginSql Alias cAliasTrb
	SELECT COUNT(F2_FILIAL) OVER (PARTITION BY ' ') TOTREG, SF2.R_E_C_N_O_ RECNOSF2
	FROM %table:SF2% SF2
	WHERE F2_FILIAL=%exp:cFilOrig%
		AND F2_DOC = %exp:SE1->E1_NUM%
		AND F2_SERIE = %exp:SE1->E1_PREFIXO%
		AND F2_CLIENT = %exp:SE1->E1_CLIENTE%
		AND F2_LOJA = %exp:SE1->E1_LOJA%
		AND SF2.%notDel%

EndSql

SD2->(DbSetOrder(2)) // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SF2->(DbSetOrder(1)) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
SC5->(DbSetOrder(1)) // C5_FILIAL+C5_NUM
SC6->(DbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC9->(DbSetOrder(1)) // C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
AGH->(DbSetOrder(1)) //	AGH_FILIAL+AGH_NUM+AGH_SERIE+AGH_FORNEC+AGH_LOJA+AGH_ITEMPD+AGH_ITEM
// Muda para Filial destino
cFilAnt := aResp[FILIAL_DESTINO]

// Transfere a NF
While lRet .And. !(cAliasTrb)->(Eof())

	SF2->(DbGoto((cAliasTrb)->RECNOSF2))

	// Pesquisa a NF na filial de destino, pois pode haver mais de uma parcela no SE1
	SF2->(DbSetOrder(1)) 

	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(SF2->F2_SERIE)})
	cPreDest := ''
	If nPosDp > 0
		cPreDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf

	If !SF2->(DBSeek(aResp[FILIAL_DESTINO]+SF2->(F2_DOC+If(Empty(cPreDest),F2_SERIE,cPreDest) )))

		// Posiciona no RECNO Original da tabela
		SF2->(DbGoto((cAliasTrb)->RECNOSF2))

		aDadosAGH := {}

		BeginSql Alias cAliasItNf
			SELECT COUNT(D2_FILIAL) OVER (PARTITION BY ' ') TOTREG,  SD2.R_E_C_N_O_ RECNOSD2, SD2.D2_PEDIDO
			FROM %table:SD2% SD2
			WHERE D2_FILIAL=%exp:cFilOrig%
				AND D2_DOC = %exp:SF2->F2_DOC%
				AND D2_SERIE = %exp:SF2->F2_SERIE%
				AND SD2.%notDel%
			ORDER BY SD2.D2_PEDIDO, SD2.R_E_C_N_O_

		EndSql

		If (cAliasItNf)->(Eof())
			cErroCP := "Itens da NF não encontrados na filial origem"
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		Endif

		aCposAlt := { 	{"F2_FILIAL", aResp[FILIAL_DESTINO] } ,;
						{"F2_SERIE" , If(Empty(cPreDest), SF2->F2_SERIE, cPreDest ) },;
						{"F2_PREFIXO", If(Empty(cPreDest), SF2->F2_PREFIXO, cPreDest ) } ,;
						{"F2_DTDIGIT", Date()        } }

		//Issue TIPDBP-1113
		If lGrpDif
			Aadd(aGrpDif,{(cAliasTrb)->RECNOSF2,aCposAlt,"SF2"})
		Else
			If !lSimula .And. !(lRet := DuplicReg("SF2",aCposAlt) > 0)
				cErroCP := "Itens da NF não encontrados na filial origem"
				U_TILogMsg(cId, cCodRot, cChave, cErroCP)
			EndIf
		EndIf

		// Transfere os itens da NF
		While lRet .And. !(cAliasItNf)->(Eof())

			cPedido := 	(cAliasItNf)->D2_PEDIDO
			cNumPed := cPedido
			SD2->(DbGoto((cAliasItNf)->RECNOSD2))

			// Gera com novo nr. de pedido para não duplicar na filial destino
			If SC5->(DBSeek(aResp[FILIAL_DESTINO]+cPedido))
				cFilOld := cFilAnt
				cFilAnt := aResp[FILIAL_DESTINO]
				If !lSimula 
					While SC5->(DBSeek(aResp[FILIAL_DESTINO]+cNumPed))					
						cNumPed := GetSXENum("SC5","C5_NUM")
						ConfirmSx8()
					End
				EndIf
				cFilAnt := cFilOld
			Endif

			While lRet .And. !(cAliasItNf)->(Eof()) .And. (cAliasItNf)->D2_PEDIDO == cPedido
				SD2->(DbGoto((cAliasItNf)->RECNOSD2))

				Aadd(aDadosAGH,{SD2->D2_FILIAL,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM})

				aCposAlt := { 	{"D2_FILIAL", aResp[FILIAL_DESTINO] } ,;
								{"D2_SERIE" , If(Empty(cPreDest),SD2->D2_SERIE,cPreDest)  } ,;
								{"D2_ORDSEP", SD2->D2_PEDIDO },; // Guarda o nr. do pedido de origem
								{"D2_DTDIGIT", Date()        },;
								{"D2_PEDIDO", cNumPed  } } // Guarda o nr do novo pedido


				//Issue TIPDBP-1113
				If lGrpDif
					Aadd(aGrpDif,{(cAliasItNf)->RECNOSD2,aCposAlt,"SD2"})
				Else	
					If !lSimula .And. !(lRet := DuplicReg("SD2",aCposAlt) > 0)
						cErroCP := "Problemas na criação dos itens na SD2"
						U_TILogMsg(cId, cCodRot, cChave, cErroCP)
					EndIf
				EndIf 

				(cAliasItNf)->(DbSkip())
			End


			//Validação para rateio de SAAS - processo de rateio de SAAS inicio em maio/24
			For nCont := 1 to len(aDadosAGH)
				If AGH->(DBSeek(aDadosAGH[nCont,01]+aDadosAGH[nCont,02]+aDadosAGH[nCont,03]+aDadosAGH[nCont,04]+aDadosAGH[nCont,05]+aDadosAGH[nCont,06]))
					aCposAlt := { 	{"AGH_FILIAL", aResp[FILIAL_DESTINO] } ,;
									{"AGH_SERIE" , If(Empty(cPreDest), SC5->C5_SERIE,cPreDest) }  }
					
					//Issue TIPDBP-1113
					If lGrpDif
						Aadd(aGrpDif,{AGH->(Recno()),aCposAlt,"AGH"})
					Else
						If !lSimula .And. !(lRet := DuplicReg("AGH",aCposAlt) > 0)
							cErroCP := "Problemas na criação do rateio SAAS - AGH"
							U_TILogMsg(cId, cCodRot, cChave, cErroCP)
						EndIf
					EndIF
				EndIf 
			Next nCont 

			// Transfere os pedidos e os itens dos pedidos
			If SC5->(DBSeek(aResp[FILIAL_ORIGEM]+cPedido))
				aCposAlt := { 	{"C5_FILIAL", aResp[FILIAL_DESTINO] } ,;
								{"C5_SERIE" , If(Empty(cPreDest), SC5->C5_SERIE,cPreDest) } ,;
								{"C5_NUM"	  , cNumPed  },;
								{"C5_DTTXREF", Date()} }
					
				//Issue TIPDBP-1113
				If lGrpDif
					Aadd(aGrpDif,{SC5->(Recno()),aCposAlt,"SC5"})
				Else
					If !lSimula .And. !(lRet := DuplicReg("SC5",aCposAlt) > 0)
						cErroCP := "Problemas na criação do pedido SC5"
						U_TILogMsg(cId, cCodRot, cChave, cErroCP)
					EndIf
				EndIF

				If SC6->(DBSeek(aResp[FILIAL_ORIGEM]+cPedido))
					While lRet .And. !SC6->(Eof()) .And. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)
						aCposAlt := { 	{"C6_FILIAL", aResp[FILIAL_DESTINO] },;
										{"C6_SERIE" , If(Empty(cPreDest),SC6->C6_SERIE,cPreDest) },;
										{"C6_NUM"	  , cNumPed  },;
										{"C6_DTVALID", Date() } }
							
						//Issue TIPDBP-1113
						If lGrpDif
							Aadd(aGrpDif,{SC6->(Recno()),aCposAlt,"SC6"})
						Else
							If !lSimula .And. !(lRet := DuplicReg("SC6",aCposAlt) > 0)
								cErroCP := "Problemas na criação dos itens na SC6"
								U_TILogMsg(cId, cCodRot, cChave, cErroCP)
								exit
							EndIf
						EndIF 

						BeginSql Alias cAliasSC9
							SELECT SC9.R_E_C_N_O_ RECNOSC9
							FROM %table:SC9% SC9
							WHERE C9_FILIAL=%exp:cFilOrig%
								AND C9_PEDIDO = %exp:SC6->C6_NUM%
								AND C9_ITEM = %exp:SC6->C6_ITEM%
								AND C9_PRODUTO = %exp:SC6->C6_PRODUTO%
								AND SC9.%notDel%
							ORDER BY SC9.C9_SEQUEN

						EndSql

						// Transfere SC9
						While lRet .And. !(cAliasSC9)->(Eof())
							SC9->(DbGoto((cAliasSC9)->RECNOSC9))

							aCposAlt := { 	{"C9_FILIAL" , aResp[FILIAL_DESTINO] } ,;
											{"C9_SERIENF", If(Empty(SC9->C9_SERIENF).Or.Empty(cPreDest),SC9->C9_SERIENF,cPreDest) },;
											{"C9_PEDIDO" , cNumPed  },;
											{"C9_DTVALID", Date() }  }

							//Issue TIPDBP-1113
							If lGrpDif
								Aadd(aGrpDif,{(cAliasSC9)->RECNOSC9,aCposAlt,"SC9"})
							Else	
								If !lSimula .And. !(lRet := DuplicReg("SC9",aCposAlt) > 0)
									cErroCP := "Problemas na criação da SC9"
									U_TILogMsg(cId, cCodRot, cChave, cErroCP)
									exit
								EndIf
							Endif

							(cAliasSC9)->(DbSkip())
						End
						(cAliasSC9)->(DBCloseArea())

						If !lRet
							exit
						EndIf
						SC6->(DbSkip())
					End
				Else
					cErroCP := "Itens do Pedido " + cPedido + " não encontrados na filial origem"
					U_TILogMsg(cId, cCodRot, cChave, cErroCP)					
					lRet := .F.
					exit
				Endif
			Else
				cErroCP := "Pedido " + cPedido + " não encontrado na filial origem"
				U_TILogMsg(cId, cCodRot, cChave, cErroCP)					
				lRet := .F.
				exit
			EndIf
		End // Terminou de transferir os itens da NF, os pedidos, os itens dos pedidos e a SC9
		(cAliasItNf)->(DBCloseArea())
	Else
		cErroCP := "NFS já existe na filial de destino"
		U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		Exit			
	EndIf

	If !lRet
		exit
	EndIf

	(cAliasTrb)->(DbSkip())

End	// Terminou de transferir as NF

(cAliasTrb)->(DBCloseArea())

//Issue TIPDBP-1113
If lGrpDif
	For nCont := 1 to len(aGrpDif)
		DbSelectArea(aGrpDif[nCont,03])
		DbGoto(aGrpDif[nCont,01])
		aCposAlt := aGrpDif[nCont,02]
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg(aGrpDif[nCont,03],aCposAlt) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> "+aGrpDif[nCont,03]
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf

		//Issue TIPDBP-1113
		cEmpAnt := aResp[GRUPO_ORIGEM]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])

	Next nCont

	

EndIF

cFilAnt  := cFilOld
If !lRet
	cErroCP := "NOTAS SAIDA - Data/Hora: "+DTOC(MSDATE())+" - "+TIME()+"-> Erro"
	U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TransfBoleto
Transfere Boletos a Receber da Filial Origem para filial destino, 
referente ao titulo a receber posicionado

@author		Claudio Donizete
@since		27/07/2018
@version	1.0
/*/
//-------------------------------------------------------------------
Static Function TransfBoleto()
Local lRet 			:= .T.
Local cAliasTrb 	:= GetNextAlias()
Local aCposAlt
Local cFilOrig 		:= aResp[FILIAL_ORIGEM]
//Issue TIPDBP-1113
Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
Local aGrpDif		:=	{}
Local nCont 		:=	0

BeginSql Alias cAliasTrb
	SELECT COUNT(PDR_FILIAL) OVER (PARTITION BY ' ') TOTREG, R_E_C_N_O_ RECNOTAB 
	FROM %table:PDR%
	WHERE PDR_FILIAL=%exp:cFilOrig%
		AND PDR_PREFIX = %exp:SE1->E1_PREFIXO%
		AND PDR_NUM = %exp:SE1->E1_NUM%
		AND PDR_PARCEL = %exp:SE1->E1_PARCELA%
		AND PDR_TIPO = %exp:SE1->E1_TIPO%
		AND PDR_CLIENT = %exp:SE1->E1_CLIENTE%
		AND PDR_LOJA = %exp:SE1->E1_LOJA%
		AND %notDel%
EndSql
While lRet .And. !(cAliasTrb)->(Eof())
	// Posiciona no RECNO Original da tabela
	PDR->(DbGoto((cAliasTrb)->RECNOTAB))

	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(PDR->PDR_PREFIX)})
	cPreDest := ''
	If nPosDp > 0
		cPreDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf

	aCposAlt := { 	{"PDR_FILIAL", aResp[FILIAL_DESTINO] } ,;
					{"PDR_PREFIX", If(Empty(cPreDest),PDR->PDR_PREFIX,cPreDest) },;
					{"PDR_ID"	 , aResp[FILIAL_DESTINO]+PDR->PDR_NUM },;
					{"PDR_STATUS", "M"},;
					{"PDR_COMPSA", "X"} }

	//{"PDR_ID", strtran(PDR->PDR_ID,aResp[FILIAL_ORIGEM],aResp[FILIAL_DESTINO])},;
					
	//Issue TIPDBP-1113
	If lGrpDif
		Aadd(aGrpDif,{(cAliasTrb)->RECNOTAB,aCposAlt,"PDR"})
	Else
		If !lSimula .And. !(lRet := DuplicReg("PDR",aCposAlt) > 0)
			cErroCP := "Problemas na criação dos boletos na PDR"
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		EndIf
	EndIf

	(cAliasTrb)->(DbSkip())
End

(cAliasTrb)->(DBCloseArea())

//Issue TIPDBP-1113
If lGrpDif
	For nCont := 1 to len(aGrpDif)
		DbSelectArea(aGrpDif[nCont,03])
		DbGoto(aGrpDif[nCont,01])
		aCposAlt := aGrpDif[nCont,02]
		// Transfere o titulo para filial de destino
		If !lSimula .And. !(lRet := DuplicReg(aGrpDif[nCont,03],aCposAlt) > 0)
			cErroCP :=  "Erro na criação do registro na filial de destino -> "+aGrpDif[nCont,03]
			U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
			Exit		
		EndIf

		//Issue TIPDBP-1113
		cEmpAnt := aResp[GRUPO_ORIGEM]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])

	Next nCont

EndIF

Return lRet


/*/{Protheus.doc} 
	Função do incoporador para efetivação da transferência 
    do processo de contas a rececber entre filiais.    
	@author Telso Carneiro	
	@since 12/04/2021
/*/
Static Function TrfMovCR()
Local lRet := .T.
Local cAliasTrb := GetNextAlias()
Local aCposAlt
Local cFilOrig  := aResp[FILIAL_ORIGEM]
Local cPreDest  := ""

BeginSql Alias cAliasTrb
	SELECT COUNT(E5_FILIAL) OVER (PARTITION BY ' ') TOTREG, R_E_C_N_O_ RECNOTAB 
	FROM %table:SE5% 
	WHERE E5_FILORIG = %exp:cFilOrig%
			AND E5_PREFIXO=%exp:SE1->E1_PREFIXO% 
			AND E5_NUMERO=%exp:SE1->E1_NUM% 
			AND E5_PARCELA=%exp:SE1->E1_PARCELA% 
			AND E5_TIPO=%exp:SE1->E1_TIPO% 
			AND E5_CLIFOR=%exp:SE1->E1_CLIENTE% 
			AND E5_LOJA=%exp:SE1->E1_LOJA% 
			AND E5_MOTBX<>'TRA'
			AND %notDel%
EndSql

// Transfere a SE5. As FK serão criadas com o migrador do padrão.
While !(cAliasTrb)->(Eof())
	SE5->(DbGoto((cAliasTrb)->RECNOTAB))

	nPosDP := Ascan(aResp[SERIE_PREFIXO_DESTINO],{|x| Alltrim(x[1]) == Alltrim(SE5->E5_PREFIXO)})
	cPreDest := ''
	If nPosDp > 0
		cPreDest := Alltrim(aResp[SERIE_PREFIXO_DESTINO][nPosDP,02])
	EndIf
	
	aCposAlt := { 	{ "E5_FILIAL"  , aResp[FILIAL_DESTINO] } ,; // Codigo da filial que recebera o titulo
					{ "E5_FILORIG" , aResp[FILIAL_DESTINO] } ,;
					{ "E5_MOVFKS"  , "" } ,; // Limpa flag para permitir a execução do migrador das FK
					{ "E5_PREFIXO" , If(Empty(cPreDest),SE5->E5_PREFIXO,cPreDest)   } } // Prefixo do título destino

	// Transfere o titulo para filial de destino
	If !lSimula .And. !(lRet := DuplicReg("SE5",aCposAlt) > 0)
		cErroCP :=  "Erro na criação do registro na filial de destino -> SE5"
		U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
		Exit		
	EndIf

	(cAliasTrb)->(DBSkip())
End

(cAliasTrb)->(DBCloseArea())

Return lRet


/*/{Protheus.doc} DuplicReg
Funcao para duplicação de registros 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function DuplicReg(cArquiv1, aCposAlt,cChavnew)
Local aArea   		:= GetArea()
Local aArea1   		:= (cArquiv1)->(GetArea())
Local aCampos  		:= {}
Local nCampos		:= 0
Local nContador		:= 0
Local nElem			:= 0
Local nReturn		:= 0
Local lGrupo 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]

Default cChavnew	:=	""

If Len(aCposAlt) <= 0
	Return(nReturn)
EndIf

dbSelectArea(cArquiv1)
nCampos := FCOUNT()
For nContador := 1 To nCampos
	nElem	:= aScan(aCposAlt, { |x| AllTrim(x[1]) == FieldName(nContador) })
	If nElem > 0
		aAdd(aCampos, {FieldName(nContador), aCposAlt[nElem,2]		})
	Else
		aAdd(aCampos, {FieldName(nContador), FieldGet(nContador)	})
	EndIf
Next

//Issue TIPDBP-1113
If lGrupo
	cEmpAnt := aResp[GRUPO_DESTINO]
	RpcClearEnv()
	RpcSetType(3)
	RPCSetEnv(cEmpAnt,aResp[FILIAL_DESTINO])
	cNmFilD := SM0->M0_FILIAL
EndIF

	
If !Empty(cChavnew)
	DbSelectArea(cArquiv1)
	DbSetOrder(1)
	
	If !DbSeek(cChavnew)
		RecLock( cArquiv1, .T., , .T. , .T. )
		For nContador := 1 To nCampos
			cVar  := (cArquiv1+"->"+aCampos[nContador,1]) 
			&cVar := aCampos[nContador, 2]
		Next 
		MsUnlock()         
		nReturn := RECNO()
	else
		cErroCR := "Titulo já existe na filial de destino"
		
		Aadd(aLogsFim,{cId, cCodRot, cChave, cErroCR})
	EndIf 
else
	DbSelectArea(cArquiv1)
	RecLock( cArquiv1, .T., , .T. , .T. )
	For nContador := 1 To nCampos
		cVar  := (cArquiv1+"->"+aCampos[nContador,1]) 
		&cVar := aCampos[nContador, 2]
	Next 

	(cArquiv1)->(MsUnlock())
	nReturn := (cArquiv1)->(RECNO())

EndIf 	

(cArquiv1)->(RestArea(aArea1))
RestArea(aArea)       

Return(nReturn)
