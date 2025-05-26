#INCLUDE 'TOTVS.CH'

Static FILIAL_ORIGEM	:=	1
Static FILIAL_DESTINO	:=	2
Static DATA_CORTE		:=	3
Static GRUPO_ORIGEM		:=	4
Static GRUPO_DESTINO	:=	5

/*/{Protheus.doc} INCCP1

	Função do incoporador para simulação da transferência 
    do processo de contas a pagar entre filiais.
    
	Issue: TICONTIN-859

	@author nascimento.denison	

	@since 25/03/2021
 
/*/
User Function INCCP1(cPar)

    Local aPar      := {}
    Local cIdProc   := ''
    Local cCodRot   := ''
    Local cTMP      := ''
    Local cUNAtu    := ''
    Local aArea     := GetArea()
    Local aAreaPGG  := PGG->(GetArea())
    Local aAreaPGH  := PGH->(GetArea())
    Local cQuery    := ''
	Local aResp 	:= {}
	Local cGrpAtu	:= ''	//Issue TIPDBP-1112
	Local cGrpDes	:= ''	//Issue TIPDBP-1112
	Local cBkpGrp	:=	cEmpAnt
	Local lGrpDif 	:=	.F.
	Local aIntGrp	:=	{} 	//Issue TIPDBP-1112
	Local nCont 	:=	0

    FWJsonDeserialize(cPar, @aPar)

    cIdProc := aPar[1]
    cCodRot := aPar[2]

	aAdd(aResp, U_TIncISX1(cCodRot, aPar[3], "01"))//Data Corte

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cIDProc ))

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

    cUNAtu := PGG->PGG_FILORI
    cUNNova:= PGG->PGG_FILDES

	cGrpAtu	:= PGG->PGG_GRPORI	//Issue TIPDBP-1112
	GrpDes	:= PGG->PGG_GRPDES	//Issue TIPDBP-1112

	lGrpDif := cGrpAtu <> cGrpDes  //Issue TIPDBP-1112

	If lGrpDif
		//Issue TIPDBP-1112
		cEmpAnt := cGrpAtu
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpAnt,cUNAtu)
	EndIf 

    cTMP := MontaQry(cUNAtu, @cQuery, DToS(aResp[1]))
	

    If Empty(cTMP)

        MsgAlert("Não existem Contas a Pagar na unidade " + cUNAtu)

		//Issue TIPDBP-1112
		If lGrpDif .And. cEmpAnt <> cBkpGrp
			cEmpAnt := cBkpGrp
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(cEmpAnt,cUNNova)
		EndIF

        Return 

    EndIf 

	//Issue TIPDBP-1112
	If lGrpDif
		//Migração de dados entre grupos de empresas diferentes
		//Jogando em array primeiro, pois fazendo direto, quando limpa o environment limpa a tabela que esta percorrendo junto.
	
		While  (cTMP)->(! Eof())

			//u_TILogNew(cIdProc, cCodRot, (cTMP)->CHAVE, cQuery, "SE2", (cTMP)->RECNO )
			Aadd(aIntGrp,{cIdProc, cCodRot, (cTMP)->TITKEY, cQuery, "SE2", (cTMP)->REGE2})

			(cTMP)->(DbSkip())
		End

		(cTMP)->(DbCloseArea())

		If cEmpAnt <> cBkpGrp
			cEmpAnt := cBkpGrp
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(cEmpAnt,cUNNova)
			
		EndIf 

		For nCont := 1 to len(aIntGrp)
			u_TILogNew(aIntGrp[nCont,01],aIntGrp[nCont,02],aIntGrp[nCont,03],aIntGrp[nCont,04],aIntGrp[nCont,05],aIntGrp[nCont,06])
		Next nCont 
	Else
		While  (cTMP)->(! Eof())

			u_TILogNew(cIdProc, cCodRot, (cTMP)->TITKEY, cQuery, "SE2", (cTMP)->REGE2 )
			
			(cTMP)->(DbSkip())
		End
	EndIf 
    
    RestArea(aAreaPGH)
    RestArea(aAreaPGG)
    RestArea(aArea)

Return 

/*/{Protheus.doc} MontaQry

	Função de retorno da query dos processos de contas 
    a pagar que serão transferidos entre filias.
    
	Issue: TICONTIN-859

	@author nascimento.denison	

	@since 25/03/2021

/*/
Static Function MontaQry(cUNAtu, cQuery, cDtCorte, lNota, cUNDes)

    Local cAliasTrb := GetNextAlias()
	Default lNota := .T.
	Default cUNDes := ""

    If Select(cAliasTrb) > 0
        
        (cAliasTrb)->(DbCloseArea())

    EndIf

	If lNota
		BeginSql Alias cAliasTrb

			SELECT  E2_FILIAL||E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA TITKEY,
					R_E_C_N_O_ REGE2 
			FROM 
					%table:SE2%
			WHERE 
					E2_FILIAL=%exp:cUNAtu%
					AND E2_SALDO > 0
					AND E2_TIPO NOT LIKE '%-'					
					AND %notDel%

		EndSql
	Else
		BeginSql Alias cAliasTrb
			%noparser%
			SELECT C7_FILIAL||C7_NUM CHAVE	
				FROM %table:SC7% SC7
				WHERE C7_FILIAL = %exp:cUNAtu% 
					AND SC7.%notDel%
					AND SC7.C7_ENCER <> 'E'
					AND (SELECT COUNT(*) FROM %table:SD1% SD1 WHERE D1_FILIAL = C7_FILIAL AND D1_PEDIDO = C7_NUM AND D1_FORNECE = C7_FORNECE AND D1_LOJA = C7_LOJA AND SD1.%notDel%) = 0
					AND (SELECT COUNT(*) FROM %table:SC7% B WHERE B.C7_FILIAL = %exp:cUNDES%  AND B.C7_NUM = SC7.C7_NUM AND B.C7_FORNECE = SC7.C7_FORNECE AND B.C7_LOJA = SC7.C7_LOJA AND B.%notDel%) = 0
			 GROUP BY C7_FILIAL,C7_NUM
			 ORDER BY C7_FILIAL,C7_NUM
		EndSql	
	EndIf

    cQuery := GetLastQuery()[2]

	If (cAliasTrb)->(Eof())		
        (cAliasTrb)->(DbCloseArea())
        Return ''
    EndIf

Return cAliasTrb

/*/{Protheus.doc} INCCP2

	Função do incoporador para efetivação da transferência 
    do processo de contas a pagar entre filiais.
    
	Issue: TICONTIN-859

	@author nascimento.denison	

	@since 25/03/2021

/*/
User Function INCCP2(cPar)

    Local cMsgLog   := ''
    Local lRet      := .F.
    Local aPar      := {}
	
    Private aResp   := ARRAY(5)
    Private cId     := ''
    Private cCodRot	:= ''
    Private cChave	:= ''
	Private lSimula := .F.
	Private cErroCP	:= ''	
	//Issue TIPDBP-1112
	Private cEmpBkp	:=	cEmpAnt
	Private cFilBkp	:=	cFilant 
	Private nRecNoSe2

    FWJsonDeserialize(cPar, @aPar)

    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cId ))

	aResp[FILIAL_ORIGEM] 	:= PGG->PGG_FILORI
	aResp[FILIAL_DESTINO]	:= PGG->PGG_FILDES
	aResp[DATA_CORTE]	 	:= STOD(DTOS(U_TIncISX1(cCodRot, aPar[5], "01")))//Data Corte
	nRecnoSE2				:= PGI->PGI_RECORI

	//Issue TIPDBP-1112
	aResp[GRUPO_ORIGEM] 		:= PGG->PGG_GRPORI
	aResp[GRUPO_DESTINO]		:= PGG->PGG_GRPDES
	
	U_TILogBegin(cId, cCodRot, cChave, lSimula)

	//Issue TIPDBP-1112
	/*If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
		cEmpAnt := aResp[GRUPO_ORIGEM]
		RpcClearEnv()
		RpcSetType(3) 
		RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
	EndIF*/

	DbSelectArea("SE2")
    SE2->(DbSetOrder(1))

    //If SE2->(DbSeek(cChave))

		__cInternet := 'AUTOMATICO'
		cModulo		:= 'FIN'
		nModulo		:= 6

		Begin Transaction
		SE2->(DbGoto(nRecnoSE2))
		If ( lRet := TransfSE2() )
			SE2->(DbGoto(nRecnoSE2))
			U_TILogMsg(cId, cCodRot, cChave, "Transferência do título a pagar realizada com sucesso.")

			If cEmpAnt <> aResp[GRUPO_ORIGEM] //<> aResp[GRUPO_DESTINO]
				RpcClearEnv()
				RpcSetType(3)
				RPCSetEnv(aResp[GRUPO_ORIGEM],aResp[FILIAL_ORIGEM])
			EndIf 

			SE2->(DbGoto(nRecnoSE2))
			If ( lRet := TransfNFE() )// Transfere NF e Pedidos

				U_TILogMsg(cId, cCodRot, cChave, "Transferência da NF'(s)/Pedido(s) de Compra realizada com sucesso.")

				If !lSimula .And. !Empty(SE2->E2_IDCNAB)

					// Troca o ID CNAB na filial de origem, para que as baixas CNAB
					// seja executadas na nova filial                        
					RecLock("SE2",.F., , .T. , .T. )
						SE2->E2_IDCNAB := "-" + Substr(SE2->E2_IDCNAB,2) 
					MsUnLock()

				EndIf   

			EndIf

		EndIf

		If !lRet

			DisarmTransaction()

		EndIf

		End Transaction

    /*Else

        Return "Chave de Título " + cChave + " não encontrado!"

    EndIf*/


    If lRet
        U_TILogEnd(cId, cCodRot, cChave, lSimula, cMsgLog)
    Else        
		U_TILogErro(cId, cCodRot, cChave, cErroCP , lSimula)
    EndIf 

Return cErroCP

//-------------------------------------------------------------------
/*/{Protheus.doc} TransfSE2
Transfere Titulos a Pagar em aberto da Filial Origem para filial destino, 
Baixando o titulo na filial Origem e incluindo na filial destino

@author		Claudio Donizete
@since		27/07/2018
@version	1.0
/*/
//-------------------------------------------------------------------

Static Function TransfSE2()

	Local lRet 		:= .T.
	Local aCposAlt	:= {}
	Local nRecNoSe2 := SE2->(Recno())
	Local cFilSe2 	:= aResp[FILIAL_ORIGEM]
	Local cTipoTit	:= ''
	Local cFilOld   := cFilAnt 
	Local aAreaSE2  := SE2->(GetArea())
	Local cFornece	:= ''
	Local cLoja		:= ''
	Local aRecno	:= {}
	Local dOldDtBase:= dDataBase
	Local cAliasSev := "SEV_"+GetNextAlias()
	Local cAliasSez := "SEZ_"+GetNextAlias()
	Local cAliasSe5 := "SE5_"+GetNextAlias()
	Local cChaveNF 	:= ''
	Local cE5_IDORIG:= ''

	//Issue TIPDBP-1112 
	Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
	Local aGrpDif		:=	{}
	Local nCont 		:=	0
	
	Private cNmFilD	:=	''	//Issue TIPDBP-1112

	// Primeiro adiciona os registros a serem transferidos, pois os primeiro
	// deve-se transferir o titulo principal, depois os agragados. Como os agragados podem
	// vir primeiro, entao utiliza-se uma matriz de recnos para transferir os titulos na ordem
	// em que foram incluidos, pois um abatimento nunca eh incluido primeiro que um titulo
	// principal
	// Os titulos de impostos nao se incluem nesta lista visto que os mesmos serao incluidos junto com
	// o titulo principal
	cChaveNF := cFilSe2 + SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
	cFornece := SE2->E2_FORNECE
	cLoja	 := SE2->E2_LOJA
	cTipoTit := SE2->E2_TIPO

	SE2->(DbSetOrder(1)) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	SE2->(MsSeek(cChaveNF))
	While SE2->(!Eof()) .And. SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA) == cChaveNF
		If (SE2->(E2_FORNECE+E2_LOJA) == cFornece+cLoja .And. SE2->E2_TIPO $ MVABATIM) .Or.	;
		(SE2->(E2_FORNECE+E2_LOJA) == cFornece+cLoja .And. SE2->E2_TIPO == cTipoTit)
			Aadd(aRecno, SE2->(Recno()))
		EndIf	
		SE2->(DbSkip())
	Enddo

	aSort(aRecno)

	// Transfere todos os titulos agregados
	nY := 1
	lMsErroAuto := .F.

	While lRet .And. !lMsErroAuto .And. nY <= Len(aRecno)

		SE2->(MsGoto(aRecno[nY]))
		cTipoTit := SE2->E2_TIPO  //Tipo do titulo que sera incluido para verificar a parcela

		// Incrementa a parcela para que nao haja registro duplicado na filial Debito
		cParcela := SE2->E2_PARCELA
		cChaveNF := aResp[FILIAL_DESTINO] + SE2->(E2_PREFIXO+E2_NUM+cParcela+cTipoTit+SE2->E2_FORNECE+SE2->E2_LOJA)
		
		While SE2->(MsSeek(cChaveNF))
			cParcela := Soma1(cParcela)
			cChaveNF := aResp[FILIAL_DESTINO] + SE2->(E2_PREFIXO+E2_NUM+cParcela+cTipoTit+SE2->E2_FORNECE+SE2->E2_LOJA)
		Enddo

		// Não transfere caso o titulo já exista na filial de destino
		If SE2->(MsSeek(cChaveNF))
			lRet := .F.			
			cErroCP := "Titulo já existe na filial de destino."
            U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		Else
			lRet := .T.
			SE2->(MsGoto(aRecno[nY])) //ponteiro pode ter sido desposicionado ao buscar pelas parcelas do Titulo	

			aCposAlt := {   { "E2_FILIAL"    , aResp[FILIAL_DESTINO]   } ,; // Codigo da filial que recebera o titulo
							{ "E2_FILORIG"   , If(!(Alltrim(SE2->E2_FILIAL)==Alltrim(SE2->E2_FILORIG)), SE2->E2_FILORIG, aResp[FILIAL_DESTINO])	} ,; // Codigo da filial de origem do titulo
							{ "E2_ORIGEM"    , "TFINA900" } ,;
							{ "E2_PARCELA"   , cParcela   } ,;
							{ "E2_HIST"	     , Alltrim(SE2->E2_HIST) + " - TITULO ORIGINADO MIGRACAO BASE FILIAL: " + aResp[FILIAL_ORIGEM] },;
							{ "E2_LA"		 , "S"        } }


			//Issue TIPDBP-1112
			If lGrpDif
				Aadd(aGrpDif,{aRecno[nY],aCposAlt,"SE2"})
			Else
				If !lSimula
					If !(lRet := DuplicReg("SE2",aCposAlt) > 0)
						cErroCP := "Problemas na criação do titulo SE2."
						U_TILogMsg(cId, cCodRot, cChave, cErroCP)
					EndIf
				EndIf
			EndIf

			/* Transferir movimentos bancários de um PA (SE5/FK5) */
			If cTipoTit $ MVPAGANT
				BeginSql Alias cAliasSE5 
					SELECT R_E_C_N_O_ RECNOSE5,E5_IDORIG 
					FROM %table:SE5%
					WHERE E5_FILIAL = %exp:SE2->E2_FILIAL%
					AND E5_PREFIXO = %exp:SE2->E2_PREFIXO%
					AND E5_NUMERO = %exp:SE2->E2_NUM%
					AND E5_PARCELA = %exp:SE2->E2_PARCELA%
					AND E5_CLIFOR = %exp:SE2->E2_FORNECE%
					AND E5_LOJA = %exp:SE2->E2_LOJA%
					AND E5_RECPAG = 'P'
					AND E5_TIPO = 'PA'
					AND %notDel%
				EndSql
				
				While !(cAliasSe5)->(Eof())
					cE5_IDORIG := (cAliasSe5)->E5_IDORIG
					//(cAliasSe5)->(DbGoto(RECNOSE5))	
					SE5->(DbGoto((cAliasSE5)->RECNOSE5))				
					aCposAlt := { 	{ "E5_FILIAL"  , aResp[FILIAL_DESTINO] } ,;
					                { "E5_FILORIG" , aResp[FILIAL_DESTINO] }   }
					
					//Issue TIPDBP-1112
					If lGrpDif
						Aadd(aGrpDif,{(cAliasSe5)->RECNOSE5,aCposAlt,"SE5"})
					Else
						If !lSimula
							If lRet := DuplicReg("SE5",aCposAlt) > 0

							    IF !(lRet := TransFK5(cAliasSe5,aResp[FILIAL_ORIGEM],aResp[FILIAL_DESTINO],cE5_IDORIG) )
									cErroCP := "Erro na criação do registro na filial de destino - CP-FK5."
									U_TILogMsg(cId, cCodRot, cChave, cErroCP)
								Endif
							Else
								cErroCP := "Erro na criação do registro na filial de destino - CP-SE5."
								U_TILogMsg(cId, cCodRot, cChave, cErroCP)								
							EndIf
						EndIf
					EndIf 
					(cAliasSe5)->(DBSkip())
				Enddo
			(cAliasSe5)->( dbCloseArea() )
			ENDIF
			/* Fim das transferências dos movimentos bancários do PA */
			
			BeginSql Alias cAliasSev 
				SELECT R_E_C_N_O_ RECNOSEV 
				FROM %table:SEV%
				WHERE EV_FILIAL = %exp:SE2->E2_FILIAL%
				AND EV_PREFIXO = %exp:SE2->E2_PREFIXO%
				AND EV_NUM = %exp:SE2->E2_NUM%
				AND EV_PARCELA = %exp:SE2->E2_PARCELA%
				AND EV_TIPO = %exp:SE2->E2_TIPO%
				AND EV_CLIFOR = %exp:SE2->E2_FORNECE%
				AND EV_LOJA = %exp:SE2->E2_LOJA%
				AND EV_RECPAG = 'P'
				AND EV_IDENT = '1'
				AND %notDel%
			EndSql

			While !(cAliasSev)->(Eof())
				SEV->(DbGoto((cAliasSev)->RECNOSEV))
				aCposAlt := { 	{ "EV_FILIAL"  , aResp[FILIAL_DESTINO] } }

				//Issue TIPDBP-1112
				If lGrpDif
					Aadd(aGrpDif,{(cAliasSev)->RECNOSEV,aCposAlt,"SEV"})
				Else
					If !lSimula
						If !(lRet := DuplicReg("SEV",aCposAlt) > 0)
							cErroCP := "Erro na criação do registro na filial de destino - CP."
							U_TILogMsg(cId, cCodRot, cChave, cErroCP)
						EndIf
					EndIf
				EndIf 

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
					SEZ->(DbGoto((cAliasSez)->RECNOSEZ))
					aCposAlt := { 	{ "EZ_FILIAL"  , aResp[FILIAL_DESTINO] } } 

					//Issue TIPDBP-1112
					If lGrpDif
						Aadd(aGrpDif,{(cAliasSev)->RECNOSEZ,aCposAlt,"SEZ"})
					Else
						If !lSimula
							If !(lRet := DuplicReg("SEZ",aCposAlt) > 0)
								cErroCP := "Erro na criação do registro na filial de destino - CP."
								U_TILogMsg(cId, cCodRot, cChave, cErroCP)
							EndIf
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
	End

	//Issue TIPDBP-1112
	If lGrpDif
		For nCont := 1 to len(aGrpDif)
			If cEmpAnt <> aResp[GRUPO_ORIGEM]
				//Issue TIPDBP-1112
				cEmpAnt := aResp[GRUPO_ORIGEM]
				RpcClearEnv()
				RpcSetType(3)
				RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])
			EndIf 
			DbSelectArea(aGrpDif[nCont,03])
			DbGoto(aGrpDif[nCont,01])
			aCposAlt := aGrpDif[nCont,02]
			// Transfere o titulo para filial de destino
			If !lSimula .And. !(lRet := DuplicReg(aGrpDif[nCont,03],aCposAlt) > 0)
				cErroCP :=  "Erro na criação do registro na filial de destino -> "+aGrpDif[nCont,03]
				U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
				Exit		
			EndIf

			
			
		Next nCont

	EndIF

	If cEmpAnt <> aResp[GRUPO_ORIGEM]
		//Issue TIPDBP-1112
		cEmpAnt := aResp[GRUPO_ORIGEM]
		cFilant := aResp[FILIAL_ORIGEM]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpAnt,cFilant)
		DbSelectArea("SE2")
		

	EndIf 
	SE2->(DbGoTo(nRecNoSe2))

	If !lSimula .And. lRet .And. !(Alltrim(SE2->E2_TIPO) $ MVPAGANT)

		aTit := {}
		// Altera para filial do titulo de origem para fazer a baixa
		cFilAnt := cFilSe2
		dDataBase := Min(SE2->E2_VENCREA, Date())

		AADD(aTit , {"E2_PREFIXO"	, SE2->E2_PREFIXO	, NIL})
		AADD(aTit , {"E2_NUM"		, SE2->E2_NUM		, NIL})
		AADD(aTit , {"E2_PARCELA"	, SE2->E2_PARCELA	, NIL})
		AADD(aTit , {"E2_TIPO"		, SE2->E2_TIPO		, NIL})
		AADD(aTit , {"E2_FORNECE"	, SE2->E2_FORNECE	, NIL})
		AADD(aTit , {"E2_LOJA"		, SE2->E2_LOJA		, NIL})
		AADD(aTit , {"AUTMOTBX"		, "TRA"				, NIL})
		AADD(aTit , {"AUTDTBAIXA"	, dDataBase			, NIL})
		AADD(aTit , {"AUTHIST"		, "fil " + aResp[FILIAL_ORIGEM] + " p/" + aResp[FILIAL_DESTINO] + " " + DTOC(aresp[DATA_CORTE]),NIL})

		// Executa a Baixa do Titulo
		lMsErroAuto := .F.
		lRet := .T.
	
		MSExecAuto({|x, y| FINA080(x, y)}, aTit, 3)

		If lMsErroAuto
			lRet := .F.
			cErroCP := "Erro na baixa via ExecAuto " + MostraErro("\logs")
            U_TILogMsg(cId, cCodRot, cChave,  cErroCP)
		ELSE
			RECLOCK("SE2",.F., , .T. , .T. )
			SE2->E2_HIST := ALLTRIM(SE2->E2_HIST) + " - [TITULO BAIXADO MIGRACAO PARA FILIAL "+aResp[FILIAL_DESTINO]+" ]"
			SE2->( MSUNLOCK() )
		Endif
	Endif

	// Garante que o titulo voltará o mesmo originalmente posicionado
	SE2->(RestArea(aAreaSE2))
	cFilAnt := cFilOld // Restaura filial atual	
	dDataBase := dOldDtBase
	cErroCP := "SE2 - Data/Hora Final : " + DTOC(MSDATE()) + " - " + TIME()
    
	/*If aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpBkp,cFilBkp)
	EndIf*/ 

	U_TILogMsg(cId, cCodRot, cChave,  cErroCP)	

Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} TransfNFE
Transfere Notas Fiscais de Entrada, Item da NF e Pedido da Filial Origem para filial destino, 
referente ao titulo a pagar posicionado

@author		Claudio Donizete
@since		27/07/2018
@version	1.0
/*/
//-------------------------------------------------------------------
Static Function TransfNFE()

	Local lRet 			:= .T.
	Local cAliasTrb 	:= GetNextAlias()
	Local cAliasPed 	:= "PED" + GetNextAlias()
	Local cAliasItNf	:= "ITNF" + GetNextAlias()
	Local cAliasSch 	:= "SCH_"+ GetNextAlias()
	Local cAliasSCR 	:= "SCR_"+GetNextAlias()
	Local nRecnoSf1
	Local nRecnoSC7
	Local cNumPed		:= ""
	Local cFilOld 		:= cFilAnt 
	Local aCposAlt
	Local cPedido
	Local cFilOrig		:= aResp[FILIAL_ORIGEM]
	//Issue TIPDBP-1112
	Local lGrpDif 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
	Local aGrpDif		:=	{}
	Local nCont 		:=	0
	Local cErroCP		:=	''

	BeginSql Alias cAliasTrb
		SELECT COUNT(F1_FILIAL) OVER (PARTITION BY ' ') TOTREG, SF1.R_E_C_N_O_ RECNOSF1
		FROM %table:SF1% SF1

		WHERE F1_FILIAL=%exp:cFilOrig%
		AND F1_DOC = %exp:SE2->E2_NUM%
		AND F1_SERIE = %exp:SE2->E2_PREFIXO%
		AND F1_FORNECE = %exp:SE2->E2_FORNECE%
		AND F1_LOJA = %exp:SE2->E2_LOJA%
		AND SF1.%notDel%
		ORDER BY SF1.R_E_C_N_O_ 

	EndSql

	SF1->(DbSetOrder(1)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	// Muda para Filial destino
	cFilAnt := aResp[FILIAL_DESTINO]
	
	// Transfere a NF
	While lRet .And. !(cAliasTrb)->(Eof())

		nRecnoSf1 := (cAliasTrb)->RECNOSF1
		// Posiciona no RECNO Original da tabela
		SF1->(DbGoto(nRecnoSf1))

		// Pesquisa a NF na filial de destino, pois pode haver mais de uma parcela no SE2
		If !SF1->(DBSeek(aResp[FILIAL_DESTINO]+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)))

			// Posiciona no RECNO Original da tabela
			SF1->(DbGoto(nRecnoSf1))

			aCposAlt := { {"F1_FILIAL", aResp[FILIAL_DESTINO] },;
                          {"F1_VEICUL1", Replicate("X",Len(SF1->F1_VEICUL1))} }

			//Issue TIPDBP-1112
			If !lSimula
				If lGrpDif
					Aadd(aGrpDif,{nRecnoSf1,aCposAlt,"SF1"})
				Else
					If !(lRet := DuplicReg("SF1",aCposAlt) > 0)
						cErroCP += "Problemas na criação da NFE SF1."+CRLF
						//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
					EndIf
				EndIf
			EndIf 

			BeginSql Alias cAliasItNf
				SELECT COUNT(D1_FILIAL) OVER (PARTITION BY ' ') TOTREG,  SD1.R_E_C_N_O_ RECNOSD1, SD1.D1_PEDIDO
				FROM %table:SD1% SD1

				WHERE D1_FILIAL=%exp:cFilOrig%
				AND D1_DOC = %exp:SF1->F1_DOC%
				AND D1_SERIE = %exp:SF1->F1_SERIE%
                AND D1_FORNECE = %exp:SF1->F1_FORNECE%
                AND D1_LOJA = %exp:SF1->F1_LOJA%
				AND SD1.%notDel%
				ORDER BY SD1.D1_PEDIDO, SD1.R_E_C_N_O_

			EndSql

			If (cAliasItNf)->(Eof())
				cErroCP += "Itens da NFE não encontrados na filial origem."+CRLF
				//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
			EndIf

			// Transfere os itens da NF
			While lRet .And. !(cAliasItNf)->(Eof())

				cPedido := 	(cAliasItNf)->D1_PEDIDO
                cNumPed := cPedido
                SD1->(DbGoto((cAliasItNf)->RECNOSD1))

				// Gera com novo nr. de pedido para não duplicar na filial destino
				SC7->(DbSetorder(1))
				If SC7->(DBSeek(aResp[FILIAL_DESTINO]+cNumPed)) 
					cFilOld := cFilAnt
					cFilAnt := aResp[FILIAL_DESTINO]
					While !lSimula .And. SC7->(DBSeek(aResp[FILIAL_DESTINO]+cNumPed)) 
						cNumPed := GetSXENum("SC7","C7_NUM")
						ConfirmSx8()
					End    
					cFilAnt := cFilOld
				EndIf 

				While lRet .And. !(cAliasItNf)->(Eof()) .And. (cAliasItNf)->D1_PEDIDO == cPedido

					SD1->(DbGoto((cAliasItNf)->RECNOSD1))

					If !lSimula
						aCposAlt := { {"D1_FILIAL", aResp[FILIAL_DESTINO] },;
									{"D1_PEDIDO", cNumPed  },;
									{"D1_DTVALID", Date()  } } // Guarda o nr do novo pedido

						//Issue TIPDBP-1112
						If lGrpDif
							Aadd(aGrpDif,{(cAliasItNf)->RECNOSD1,aCposAlt,"SD1"})
						Else
							If !(lRet := DuplicReg("SD1",aCposAlt) > 0)
								cErroCP += "Problemas na criação dos itens da NFE SD1"+CRLF
								//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
							EndIf
						EndIf 
					EndIf

					(cAliasItNf)->(DbSkip())
				End 

				// Seleciona os pedidos do Item da NF
				BeginSql Alias cAliasPed
					SELECT COUNT(C7_FILIAL) OVER (PARTITION BY ' ') TOTREG, SC7.R_E_C_N_O_ RECNOSC7
					FROM %table:SC7% SC7

					WHERE C7_FILIAL=%exp:cFilOrig%
					AND C7_NUM = %exp:cPedido%
					AND C7_FORNECE = %exp:SD1->D1_FORNECE%
					AND C7_LOJA = %exp:SD1->D1_LOJA%
					AND SC7.%notDel%
					ORDER BY SC7.R_E_C_N_O_ 

				EndSql

				If !lSimula .And. (cAliasPed)->(Eof())
					cErroCP += "Pedido "+cPedido+" não encontrado na filial origem."+CRLF
					//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
				EndIf
				// Transfere os pedidos

				While lRet .And. !(cAliasPed)->(Eof())
					nRecnoSC7 := (cAliasPed)->RECNOSC7
					// Posiciona no RECNO Original da tabela
					SC7->(DbGoto(nRecnoSC7))

					If !lSimula
						aCposAlt := { 	{"C7_FILIAL"	, aResp[FILIAL_DESTINO] },;
										{"C7_FILENT"    , aResp[FILIAL_DESTINO] },;
										{"C7_NUM"	  	, cNumPed  				},;
										{"C7_CONTROL"	, SC7->C7_NUM			},;
										{"C7_CONF_PE"	, Date()  				} } // Gera com novo nr. de pedido para não duplicar na filial destino

						//Issue TIPDBP-1112
						If lGrpDif
							Aadd(aGrpDif,{nRecnoSC7,aCposAlt,"SC7"})
						Else
							If !(lRet := DuplicReg("SC7", aCposAlt) > 0)
								cErroCP += "Problemas na criação dos pedidos de compra SC7."+CRLF
								//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
							EndIf
						ENDIF
					EndIf

					// Seleciona os pedidos do Item da NF
					BeginSql Alias cAliasSch
						SELECT SCH.R_E_C_N_O_ RECNOSCH
						FROM %table:SCH% SCH

						WHERE CH_FILIAL=%exp:cFilOrig%
						AND CH_PEDIDO = %exp:cPedido%
						AND CH_FORNECE = %exp:SC7->C7_FORNECE%
						AND CH_LOJA = %exp:SC7->C7_LOJA%
						AND CH_ITEMPD = %exp:SC7->C7_ITEM%
						AND %notDel%
						ORDER BY SCH.R_E_C_N_O_ 

					EndSql

					While !(cAliasSch)->(Eof())
						SCH->(DbGoto((cAliasSch)->RECNOSCH))

						If !lSimula

							aCposAlt := { {"CH_FILIAL", aResp[FILIAL_DESTINO] },;
										{"CH_PEDIDO", cNumPed  },;
										{"CH_EC05DB", Replicate("X",Len(SCH->CH_EC05DB))} } // Gera com novo nr. de pedido para não duplicar na filial destino

							//Issue TIPDBP-1112
							If lGrpDif
								Aadd(aGrpDif,{(cAliasSch)->RECNOSCH,aCposAlt,"SCH"})
							Else
								If !(lRet := DuplicReg("SCH", aCposAlt) > 0)
									cErroCP += "Problemas na criação dos pedidos de compra SCH."+CRLF
									//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
								EndIf
							EndIf 

						EndIf

						(cAliasSch)->(DbSkip())
					End

					(cAliasSch)->(DBCloseArea())

					BeginSql Alias cAliasSCR
						SELECT R_E_C_N_O_ RECNOSCR
						FROM %table:SCR%
						WHERE CR_FILIAL = %exp:cFilOrig%
						AND CR_NUM = %exp:SC7->C7_NUM%
						AND %notDel%
					EndSql

					While !(cAliasSCR)->(Eof())

						If !lSimula
							SCR->(DbGoto((cAliasSCR)->RECNOSCR))
							aCposAlt := { {"CR_FILIAL" , aResp[FILIAL_DESTINO] },;
										  {"C7_FILENT" , aResp[FILIAL_DESTINO] },;
										  {"CR_NUM"    , cNumPed },;
										  {"CR_ULTAVIS", Date()} } 

							//Issue TIPDBP-1112
							If lGrpDif
								Aadd(aGrpDif,{(cAliasSCR)->RECNOSCR,aCposAlt,"SCR"})
							Else
								If !(lRet := DuplicReg("SCR", aCposAlt) > 0)
									cErroCP += "Problemas na criação dos pedidos de compra SCR."+CRLF
									//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
								EndIf
							ENDIF
						EndIf

						(cAliasSCR)->(DbSkip())
					End
					(cAliasSCR)->(DBCloseArea())
					(cAliasPed)->(DbSkip())
				End	
				(cAliasPed)->(DBCloseArea())
			End // Terminou os Itens da NF e Pedidos de Compra
			(cAliasItNf)->(DBCloseArea())
		Else
			cErroCp += "NFE já existe na filial de destino."+CRLF
			//U_TILogMsg(cId, cCodRot, cChave, cErroCP)
		EndIf
		(cAliasTrb)->(DbSkip())	
	End
	(cAliasTrb)->(DBCloseArea())

	cFilAnt := cFilOld

	//Issue TIPDBP-1112
	If lGrpDif
		If cEmpAnt <> aResp[GRUPO_ORIGEM]
			cEmpAnt := aResp[GRUPO_ORIGEM]
			RpcClearEnv()
			RpcSetType(3)
			RPCSetEnv(cEmpAnt,aResp[FILIAL_ORIGEM])
		ENDIF

		For nCont := 1 to len(aGrpDif)
			DbSelectArea(aGrpDif[nCont,03])
			DbGoto(aGrpDif[nCont,01])
			aCposAlt := aGrpDif[nCont,02]
			// Transfere o titulo para filial de destino
			If !lSimula .And. !(lRet := DuplicReg(aGrpDif[nCont,03],aCposAlt) > 0)
				cErroCP +=  "Erro na criação do registro na filial de destino -> "+aGrpDif[nCont,03]+CRLF
				
				//U_TILogMsg(cId, cCodRot, cChave, cErroCP)	
				Exit		
			EndIf


		Next nCont


	EndIF

If !Empty(cErroCP)
	If cEmpBkp <> aResp[GRUPO_ORIGEM] //<> aResp[GRUPO_DESTINO]
		RpcClearEnv()
		RpcSetType(3)
		RPCSetEnv(cEmpBkp,cFilBkp)
	EndIf
	U_TILogMsg(cId, cCodRot, cChave, cErroCP)
EndIf

Return lRet

/*/{Protheus.doc} DuplicReg
Funcao para duplicação de registros 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function DuplicReg(cArquiv1, aCposAlt)
	Local aArea   		:= GetArea()
	Local aArea1   		:= (cArquiv1)->(GetArea())
	Local aCampos  		:= {}
	Local nCampos		:= 0
	Local nContador		:= 0
	Local nElem			:= 0
	Local nReturn		:= 0
	Local lGrupo 		:= aResp[GRUPO_ORIGEM] <> aResp[GRUPO_DESTINO]
	Local cBkEnv		:= cEmpAnt 

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

	//Issue TIPDBP-1112
	If lGrupo
		cEmpAnt := aResp[GRUPO_DESTINO]
		cFilant := aResp[FILIAL_DESTINO]

		If Select("TRB") > 0
			TRB->(DbcloseArea())
		EndIf 

		DbUseArea(.F.,"TOPCONN",cArquiv1+'000',"TRB",.T.,.F.)
		DbSelectArea("TRB")
		DbSetIndex(cArquiv1+cEmpAnt+'01') // Tabela + Indice
		cArquiv1 := "TRB"

	EndIF

	RecLock( cArquiv1, .T., , .T. , .T. )
	For nContador := 1 To nCampos
		cVar 		:= (cArquiv1+"->"+aCampos[nContador,1]) 
		&cVar		:= aCampos[nContador, 2]
	Next 
	MsUnlock()         
	nReturn := RECNO()	

	(cArquiv1)->(RestArea(aArea1))
	RestArea(aArea) 

	cEmpAnt := cBkEnv

Return(nReturn)

/*/{Protheus.doc} TransFK5
Funcao para duplicação da FK5 na filial destino

@author		Julio Saraiva
@since		30/08/2024
@version	1.0
/*/

Static Function TransFK5(cAliasSE5,cFilOrig,cFilDest,cIDorig)
Local aArea     := GetArea()
Local aArea1  	:= (cAliasSE5)->(GetArea())
Local lRet      := .T.
Local aCposAlt  := {}

dbSelectArea("FK5")
dbSetOrder(1)

If MsSeek(cFilOrig+cIDorig)
	aCposAlt := { 	{ "FK5_FILIAL"  , cFilDest } ,;
	                { "FK5_FILORI"  , cFilDest }   }
	If !(lRet := DuplicReg("FK5",aCposAlt) > 0)
		cErroCP := "Erro na criação do registro na filial de destino - CP-FK5."
		U_TILogMsg(cId, cCodRot, cChave, cErroCP)
	Endif
Endif

FK5->( dbCloseArea() )

(cAliasSE5)->(RestArea(aArea1))
RestArea(aArea)

Return lRet
