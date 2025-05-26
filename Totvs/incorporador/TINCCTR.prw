#INCLUDE 'TOTVS.CH'

User Function INCCTR1(cPar)
    Local aPar      := {}
    Local cIdProc   := ""
    Local cCodRot   := ""
    Local cTMP      := ""
    Local cUNAtu    := ""
    Local nOpSel    := 1
    Local cGrpSl    := ""
    Local cPrdSl    := ""
    Local cCliSl    := ""
    Local aArea     := GetArea()
    Local aAreaPGG  := PGG->(GetArea())
    Local aAreaPGH  := PGH->(GetArea())
    Local cContrato := ""
    Local cChave    := ""
    Local cQuery    := ""
    Local cRevisa   := ""   
    Local nRecno    := 0
    //Local aPergunte := {}

    FWJsonDeserialize(cPar, @aPar)
    cIdProc := aPar[1]
    cCodRot := aPar[2]
    If Len(aPar) > 2
        //aPergunte := aPar[3]
        cGrpSl := Alltrim(U_TIncISX1(cCodRot, aPar[3], "02")) //Alltrim(aPergunte[1,2,2,3]))
        nOpSel := U_TIncISX1(cCodRot, aPar[3], "03") //aPergunte[1,2,3,3]
        cPrdSl := Alltrim(U_TIncISX1(cCodRot, aPar[3], "04"))
        cCliSl := Alltrim(U_TIncISX1(cCodRot, aPar[3], "05"))
    EndIF

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cIDProc ))

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

    cUNAtu := PGG->PGG_FILORI

    cTMP := MontaQry(cUNAtu, @cQuery,cGrpSl,nOpSel, cPrdSl,cCliSl)
    If Empty(cTMP)
        MsgAlert("Não existem contratos na unidade " + cUNAtu)
        Return 
    EndIf 

    While  (cTMP)->(! Eof())
        cContrato := (cTMP)->CONTRATO
        cRevisa   := (cTMP)->REVISA
        nRecno    := (cTMP)->RECNO 
		
        If ! IsBlind()
            IncProc("Gerando Log contrato: " + cContrato   )
            ProcessMessage()
        EndIf
		If lAbortPrint
			exit
        Endif 

        cChave := cContrato + cRevisa 
        u_TILogNew(cIdProc, cCodRot, cChave, cQuery, "CN9", nRecno)

        (cTMP)->(DbSkip())
    End

    
    RestArea(aAreaPGH)
    RestArea(aAreaPGG)
    RestArea(aArea)

Return 



Static Function MontaQry(cUNAtu, cQuery,cGrpSl,nOpSel,cPrdSl,cCliSl)

    Local cTMP      := GetNextAlias()
    Local aAuxCli   := {}
    Local nCont 

    If ',' $ cGrpSl
        //Quando existir mais de um grupo de produto
        cGrpSl := strtran(cGrpSl,",","','")
    EndIf 

    If ',' $ cPrdSl
        cPrdSl := strtran(cPrdSl,",","','")
    EndIf

    If !Empty(cCliSl)
        If ',' $ cCliSl
            cCliSl := strtran(cCliSl,",","','")
        EndIf 

        If '-' $ cCliSl
            aAuxCli := separa(cCliSl,"-")
        EndIf 
    EndIf 

    cQuery := " "
    cQuery += " SELECT DISTINCT CN9.CN9_FILIAL, CN9.CN9_NUMERO CONTRATO, CN9.CN9_REVISA REVISA, CN9.R_E_C_N_O_ RECNO  " 
    cQuery += " FROM "+RetSQLName("CN9")+" CN9  " 
    cQuery += "     INNER JOIN "+RetSQLName("CNB")+" CNB  " 
    cQuery += "     ON  CNB_FILIAL = '           '   " 
    cQuery += "         AND CNB.CNB_CONTRA = CN9.CN9_NUMERO   " 
    cQuery += "         AND CNB.CNB_REVISA = CN9.CN9_REVISA      " 
    
    If nOpsel == 1 
        cQuery += "         AND CNB.CNB_UNINEG = '" + cUNAtu + "'  " 
    ElseIf nOpsel == 2
        cQuery += " AND CNB.CNB_PRODUT IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_GRUPO IN ('"+cGrpSl+"') AND D_E_L_E_T_=' ')"
    ElseIf nOpsel == 3
        cQuery += "         AND CNB.CNB_UNINEG = '" + cUNAtu + "'  " 
        cQuery += "         AND CNB.CNB_PRODUT IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_GRUPO IN ('"+cGrpSl+"') AND D_E_L_E_T_=' ')"
    ElseIf nOpsel == 4
        cQuery += " AND CNB.CNB_PRODUT IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD IN ('"+cPrdSl+"') AND D_E_L_E_T_=' ')"
    ElseIf nOpsel == 5
        cQuery += "         AND CNB.CNB_UNINEG = '" + cUNAtu + "'  " 
        cQuery += "         AND CNB.CNB_PRODUT IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD IN ('"+cPrdSl+"') AND D_E_L_E_T_=' ')"
    EndIF 

    
    
    cQuery += "         AND CNB.D_E_L_E_T_ = ' '  " 
    cQuery += " WHERE  CN9.CN9_FILIAL = ' '  " 
    cQuery += "    AND CN9.CN9_SITUAC = '05'   " 
    cQuery += "    AND CN9.CN9_REVATU = ' '   " 
    cQuery += "    AND CN9.CN9_ESPCTR = '2'   " 
    cQuery += "    AND CN9_TPCTO = '013'  " 
    cQuery += "    AND CN9.D_E_L_E_T_ = ' '  " 

    If !Empty(cCliSl)
        
        If len(aAuxCli) > 0
            For nCont := 1 to len(aAuxCli)
                If len(aAuxCli[nCont]) == 6
                    aAuxCli[nCont] := 'CON'+alltrim(aAuxCli[nCont])
                EndIf 
            Next nCont

            cQuery += " AND CN9.CN9_NUMERO BETWEEN '"+aAuxCli[1]+"' AND '"+aAuxCli[2]+"'"
        Else
            cQuery += " AND CN9.CN9_NUMERO IN('"+cCliSl+"')"
        EndIf 
    EndIf 

    DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
	If (cTMP)->(Eof())		
        (cTMP)->(DbCloseArea())
        Return ""
    EndIf

Return cTMP




User Function INCCTR2(cPar)
    Local cId         := ""
    Local cCodRot     := ""
    Local cChave      := ""
    Local lSimula     := .F.
    Local aPar        := {}
    Local lRepresa    := .F.

    Local cContrato   := ""
	Local cRevisa     := Space(6)
    Local cChaveLock  := ""
    Local cMsg        := ""  
    Local aAreaCN9    := CN9->(GetArea())
    Local cRevAtu     := ""
    Local cObs        := ""
    Local cMsgLog     := ""
    Local nOpSel      := 1
    Local cGrpSl      := ""
    Local cPrdSl      := ""
    Local cCliSl      := ""

    FWJsonDeserialize(cPar, @aPar)
    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]

    If Len(aPar[5]) > 0
        lRepresa := U_TIncISX1(cCodRot, aPar[5], "01") == 1
        cGrpSl := Alltrim(U_TIncISX1(cCodRot, aPar[5], "02")) //Alltrim(aPergunte[1,2,2,3])
        nOpSel := U_TIncISX1(cCodRot, aPar[5], "03") //aPergunte[1,2,3,3]
        cPrdSl := Alltrim(U_TIncISX1(cCodRot, aPar[5], "04")) //aPergunte[1,2,3,4]
        cCliSl := Alltrim(U_TIncISX1(cCodRot, aPar[5], "05"))
    EndIF

    cContrato   := Left(cChave, 15)
    cRevisa     := Subs(cChave, 16, 6)

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cId ))

    cUNAtu  := PGG->PGG_FILORI
    cUNNova := PGG->PGG_FILDES
    cObs    := PGG->PGG_DESCRI

    // Posiciona contrato
    CN9->(dbSetOrder(8))// Posiciona na Revisão Atual
    If ! CN9->(dbSeek(xFilial("CN9") + cContrato + Space(6)))
        Return "Contrato " + cContrato + " não encontrado!!!"
    EndIf
    cRevAtu := CN9->CN9_REVISA

    U_TILogBegin(cId, cCodRot, cChave, lSimula)

    cChaveLock:= "CN9" + xFilial("CN9") + CN9->CN9_NUMERO

    Begin Transaction
        
        If ! U_GVFUNLOC(1, cChaveLock, , .F.)
            cMsg := "Contrato: " + cContrato + " bloqueado por outra estação"
            If ! IsBlind()
                IncProc(cMsg)
                ProcessMessage()
            EndIf
            DisarmTransaction()
            Break
        EndIf

        If ! CheckContrato(cContrato, cRevAtu, @cMsg, lRepresa, @cMsgLog)
            DisarmTransaction()
            Break
        EndIf 

        If ! lSimula 

            u_TILogMsg(cId, cCodRot, cChave, "Atualizando Contrato")
            cRevisa := AtuContrato(cContrato, cUNAtu, cUNNova, cGrpSl, nOpSel, cPrdSl, cCliSl ) // Gera a revisão do contrato
            CriaPHB(cContrato, cRevisa, cObs)
            
            u_TILogMsg(cId, cCodRot, cChave, "Atualizando PH8")
            PH8->(AtuPH8(cContrato, cRevisa, cUNAtu, cUNNova))
            
            u_TILogMsg(cId, cCodRot, cChave, "Atualizando PHM")
            PHM->(AtuPHM(cContrato, cRevisa, cUNAtu, cUNNova))

            u_TILogMsg(cId, cCodRot, cChave, "Atualizando Cronograma Contabil Contrato")
            ProcCTB(cUNAtu, cUNNova,cContrato,ddatabase)

            u_TILogMsg(cId, cCodRot, cChave, "Atualizando os itens represados do Contrato")
            ProcRepr(cUNAtu, cUNNova,cContrato)
        EndIf 

    End Transaction

    If ! Empty(cMsg)
        U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
    Else
        U_TILogEnd(cId, cCodRot, cChave, lSimula, cMsgLog)
    EndIf 

    U_GVFUNLOC(2, cChaveLock)  // Destrava o contrato

    RestArea(aAreaCN9)

Return cMsg



Static Function CheckContrato(cContrato, cRevisa, cMsg, lRepresa, cMsgLog)

    If lRepresa
        TemRepresado(cContrato, cRevisa, @cMsgLog)
    Else
        TemRepresado(cContrato, cRevisa, @cMsg)
    EndIF
    TemMedAberto(cContrato, cRevisa, @cMsg)

Return Empty(cMsg)


Static Function TemRepresado(cContrato, cRevisa, cMsg)
	Local cQuery    := ""
	Local clAlias	:= GetNextAlias()
	Local cAnoMes   := Left(Dtos(MsDate()), 6)
    Local cNumero   := ""
    Local cItem     := ""
    Local cCodProd   := ""
    Local cCompet   := ""
    
    cQuery := " "
	cQuery := " SELECT PH5_COMPET, PH5_ANOMES, PH5_NUMERO, PH5_ITEM  "
	cQuery += " FROM " + RetSqlName("PH5") + " PH5 "
	cQuery += " WHERE PH5_FILIAL = '"+ FWxFilial("PH5") +"' "
	cQuery += " AND PH5_CONTRA = '"+ cContrato +"' "
	cQuery += " AND PH5_REVISA = '"+ cRevisa +"' "
	cQuery += " AND PH5_VLRFAT > 0 "
	cQuery += " AND PH5_NOTA = ' '"
	cQuery += " AND PH5_ANOMES < '" + cAnoMes + "' "
	cQuery += " AND PH5.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY 2"

	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), clAlias , .T., .T.)
     
    While (clAlias)->(!Eof())
        cNumero   := (clAlias)->PH5_NUMERO
        cItem     := (clAlias)->PH5_ITEM
        cCompet   := (clAlias)->PH5_COMPET

        cMsg +=  "Contrato :" + cContrato + "-" + cNumero + "-" + cItem + "-" + cCodProd + " represado em: " + cCompet + CRLF 
        
        (clAlias)->(dbSkip())
        
    EndDo
	(clAlias)->( dbCloseArea() )


Return 

Static Function TemMedAberto(cContrato, cRevisa, cMsg)
	Local cQuery    := ""
	Local clAlias	:= GetNextAlias()
	Local cNumero   := ""
    Local cItem     := ""
    Local cCodProd   := ""
    Local cCompet   := ""

    cQuery := " "
	cQuery := " SELECT PH5_COMPET, PH5_ANOMES, PH5_NUMERO, PH5_ITEM  "
	cQuery += " FROM " + RetSqlName("PH5") + " PH5 "
	cQuery += " WHERE PH5_FILIAL = '"+ FWxFilial("PH5") +"' "
	cQuery += " AND PH5_CONTRA = '"+ cContrato +"' "
	cQuery += " AND PH5_REVISA = '"+ cRevisa +"' "
	cQuery += " AND PH5_VLRFAT > 0 "
  	cQuery += " AND PH5_NUMMED  != '' "
	cQuery += " AND PH5_NOTA = ' '"
	cQuery += " AND PH5.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY 2"

	DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), clAlias , .T., .T.)
     
    While (clAlias)->(!Eof())
        cNumero   := (clAlias)->PH5_NUMERO
        cItem     := (clAlias)->PH5_ITEM
        cCompet   := (clAlias)->PH5_COMPET

        cMsg +=  "Contrato :" + cContrato + "-" + cNumero + "-" + cItem + "-" + cCodProd + " medição em aberto: " + cCompet + CRLF
        
        (clAlias)->(dbSkip())
        
    EndDo
	(clAlias)->( dbCloseArea() )

Return 


Static Function AtuContrato(cContrato, cUNAtu, cUNNova, cGrpSl, nOpSel, cPrdSl, cCliSl)
    Local aArqs   := {}
	Local nx      := 0
    
    Local cAlias   := ""
    Local nOrdem   := 0
    Local aArea    := GetArea()
    Local aAreaCN9 := CN9->(GetArea())
	Local aAreaCNB := CNB->(GetArea())
	
    Local cMemJust  := ""
	Local aUniNeg   := {}
    Local cNameRev  := ""
    Local cNameUN   := ""
	Local aArqsAtu  := {}
    Local aArqsUNeg := {}
    Local cNameCmp  := ""
   

    Local cRevisa  := ""
    Local cNovo    := ""
    

    cContrato := Padr(cContrato, 15)

    aadd(aArqs, {"CN9", "CN9_FILIAL + CN9_NUMERO + CN9_REVISA", "CN9_REVISA", ""          , 1}) //
    aadd(aArqs, {"CNA", "CNA_FILIAL + CNA_CONTRA + CNA_REVISA", "CNA_REVISA", ""          , 1}) //
    aadd(aArqs, {"CNB", "CNB_FILIAL + CNB_CONTRA + CNB_REVISA", "CNB_REVISA", "CNB_UNINEG", 1}) // OK
    aadd(aArqs, {"CNC", "CNC_FILIAL + CNC_NUMERO + CNC_REVISA", "CNC_REVISA", ""          , 1}) //
    aadd(aArqs, {"PH3", "PH3_FILIAL + PH3_CONTRA + PH3_REVISA", "PH3_REVISA", "PH3_UNINEG", 1}) // OK
    aadd(aArqs, {"PH4", "PH4_FILIAL + PH4_CONTRA + PH4_REVISA", "PH4_REVISA", "PH4_UNINEG", 1}) // OK
    aadd(aArqs, {"PHG", "PHG_FILIAL + PHG_CONTRA + PHG_REVISA", "PHG_REVISA", "PHG_UNINEG", 1}) // OK
    aadd(aArqs, {"PHN", "PHN_FILIAL + PHN_CONTRA + PHN_REVISA", "PHN_REVISA", "PHN_UNINEG", 1}) // OK
    aadd(aArqs, {"PH9", "PH9_FILIAL + PH9_CONTRA + PH9_REVISA", "PH9_REVISA", ""          , 1}) //
    aadd(aArqs, {"PN0", "PN0_FILIAL + PN0_CONTRA + PN0_REVISA", "PN0_REVISA", ""          , 1})
    aadd(aArqs, {"PHA", "PHA_FILIAL + PHA_CONTRA + PHA_REVISA", "PHA_REVISA", ""          , 1}) //
    aadd(aArqs, {"PHV", "PHV_FILIAL + PHV_CONTRA + PHV_REVISA", "PHV_REVISA", "PHV_UNINEG", 1}) // OK
    aadd(aArqs, {"PHH", "PHH_FILIAL + PHH_CONTRT + PHH_REVCON", "PHH_REVCON", "PHH_SITEFT", 4}) // OK
    aadd(aArqs, {"PHD", "PHD_FILIAL + PHD_CONTRA + PHD_REVISA", "PHD_REVISA", ""          , 2}) // 
    aadd(aArqs, {"PH5", "PH5_FILIAL + PH5_CONTRA + PH5_REVISA", "PH5_REVISA", "PH5_UNINEG", 1}) // OK
    aadd(aArqs, {"PH6", "PH6_FILIAL + PH6_CONTRA + PH6_REVISA", "PH6_REVISA", "PH6_UNINEG", 1}) // OK
    aadd(aArqs, {"PH7", "PH7_FILIAL + PH7_CONTRA + PH7_REVISA", "PH7_REVISA", "PH7_UNINEG", 1}) // OK 
    
    aadd(aArqsAtu, {"CND", "CND_FILIAL + CND_CONTRA", "CND_REVISA", 1 }) //CND_FILIAL+CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED           INDICE 1   "CND_FILCTR"
    aadd(aArqsAtu, {"CNE", "CNE_FILIAL + CNE_CONTRA", "CNE_REVISA", 1 }) //CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED+CNE_ITEM  INDICE 1   "CNE_XGU"
    aadd(aArqsAtu, {"CXN", "CXN_FILIAL + CXN_CONTRA", "CXN_REVISA", 1 }) //CXN_FILIAL+CXN_CONTRA+CXN_REVISA+CXN_NUMMED+CXN_NUMPLA           INDICE 1   "CXN_XGU"
    aadd(aArqsAtu, {"SC5", "C5_FILIAL  + C5_MDCONTR", "C5_XMDREV" , 8 }) //C5_FILIAL+C5_MDCONTR+C5_XMDREV+C5_MDPLANI+C5_XCOMPET+C5_CLIENTE+C5_LOJACLI+C5_CONDPAG  INDICE 8


    aadd(aArqsUNeg, {"PHK", "PHK_FILIAL+PHK_CONTRA", "PHK_UNINEG" , "PHK_CMPDIF", 1 }) //PHK_FILIAL+PHK_CONTRA+PHK_NUMERO+PHK_ITEM+PHK_CMPDIF+PHK_STATUS                                                                                                 
    aadd(aArqsUNeg, {"PHL", "PHL_FILIAL+PHL_CONTRA", "PHL_UNINEG" , "PHL_CMPDIF", 1 }) //PHL_FILIAL+PHL_CONTRA+PHL_NUMERO+PHL_ITEM+PHL_CMPDIF+PHL_STATUS                                                                                                 
    
        
    
    // Posiciona contrato
    CN9->(dbSetOrder(8))// Posiciona na Revisão Atual
    If ! CN9->(dbSeek(xFilial("CN9") + cContrato + Space(6)))
        Return
    EndIf
    cRevisa := CN9->CN9_REVISA
    cNovo := Soma1(cRevisa)

	aUniNeg := {}
	CNB->(DbSetOrder(1))
	CNB->(Dbseek(xFilial("CNB") + cContrato +  cRevisa))
	While CNB->(! Eof() .and. CNB_FILIAL+CNB_CONTRA + CNB_REVISA == xFilial("CNB") + cContrato  + cRevisa )
		If Ascan(aUniNeg, CNB->CNB_UNINEG) == 0
 			Aadd(aUniNeg, CNB->CNB_UNINEG)
		EndIf
		CNB->(DbSkip())
	End

    Begin Transaction
        
        CN9->(RecLock("CN9", .F.))
        CN9->CN9_SITUAC := "10"  ///01=Cancelado;02=Elaboracao;03=Emitido;04=Aprovacao;05=Vigente;06=Paralisa.;07=Sol. Finalizacao;08=Finaliz;09=Revisao;10=Revisado
        CN9->CN9_REVATU := cNovo
        CN9->(MsUnLock())
        
        For nx := 1 to len(aArqs)
            cAlias   := aArqs[nx, 1]
            cNameKey := aArqs[nx, 2]
            cNameRev := aArqs[nx, 3]
            cNameUN  := aArqs[nx, 4]
            nOrdem   := aArqs[nx, 5]
           

            (cAlias)->(Revisa(cAlias, cNameKey, nOrdem, cContrato, cNameRev, cRevisa, cNovo, cNameUN, cUNAtu, cUNNova, cGrpSl, nOpSel, cPrdSl, cCliSl))
        Next

        CN9->(DbSetOrder(1))  
        CN9->(DbSeek(xFilial("CN9") + cContrato + cNovo))
        CN9->(RecLock("CN9", .F.))
        CN9->CN9_SITUAC := "05"
        CN9->CN9_REVATU := ""
        CN9->CN9_DTREV  := Date()
        CN9->CN9_TIPREV := "018"
        CN9->CN9_LOGDAT := Date()
        CN9->CN9_LOGHOR := Time()
        CN9->CN9_LOGUSR := __cUserId
        cMemJust := "Alteração Unidade de negocio TOTVS SERVICOS"
        CN9->(MsUnLock())
        MSMM(CN9->CN9_CODJUS, , , cMemJust, 1,,, "CN9", "CN9_CODJUS")

        For nx := 1 to len(aArqsAtu)
            cAlias   := aArqsAtu[nx, 1]
            cNameKey := aArqsAtu[nx, 2]
            cNameRev := aArqsAtu[nx, 3]
            nOrdem   := aArqsAtu[nx, 4]
            
            (cAlias)->(AtuRevisa(cAlias, cNameKey, nOrdem, aUniNeg, cContrato, cNameRev, cNovo ))
        Next


        For nx := 1 to len(aArqsUNeg)
            cAlias   := aArqsUNeg[nx, 1]
            cNameKey := aArqsUNeg[nx, 2]
            cNameUN  := aArqsUNeg[nx, 3]
            cNameCmp := aArqsUNeg[nx, 4]
            nOrdem   := aArqsUNeg[nx, 5]
           
            (cAlias)->(AtuUniNeg(cAlias, cNameKey, nOrdem, cContrato, cNameUN, cUNAtu, cUNNova, cNameCmp ))
        Next

    End Transaction

    RestArea(aAreaCNB)
    RestArea(aAreaCN9)
    RestArea(aArea)
Return cNovo


Static Function Revisa(cAlias, cNameKey, nOrdem, cContrato, cCpoRev, cRevisa, cNovo, cNameUN, cUNAtu, cUNNova, cGrpSl, nOpSel, cPrdSl, cCliSl)
    Local aArea   := GetArea()
    Local cChave  := xFilial(cAlias) + cContrato + cRevisa
    Local nLimite := 100
    Local aCampos := {}
    Local lAtuUN  := .F.
    Local cChavePH6,cChavePHV,cChvPHVAnt
    Local lMigra  := .F.
    
    DbSetOrder(nOrdem)
    DbSeek(cChave)
    While ! Eof() .and. &cNameKey == cChave
        aCampos := {}
        lMigra  := .F.
        If ! IsBlind()
            If nLimite == 100
                IncProc("Criando revisão contrato: " + cContrato + " Tabela: " + cAlias + ":" + Alltrim(Str((cAlias)->(Recno()))))
                ProcessMessage()
                nLimite := 0
            EndIf
            nLimite++
        EndIf
        lAtuUN  := .T.
        aadd(aCampos, {cCpoRev, cNovo})
        If cAlias == "PH5" 
            cChavePH6 := xFilial("PH6")+ PH5->(PH5_CONTRA + PH5_REVISA + PH5_NUMERO + PH5_COMPET + PH5_CONDIC + PH5_CLIENT + PH5_LOJA + PH5_CONDPG + PH5_NOTASE + PH5_MOEDA + PH5_MASCCC + PH5_GU + PH5_SEQ)
            If PH6->(DbSeek(cChavePH6)) .AND. ! PH6->PH6_STATUS $ "00/03"   //00-Aberto;03-Represado
                lAtuUN  := .F.
            EndIf
        EndIf 
        If cAlias == "PH7" .AND. ! PH7->PH7_STATUS $ "00/05/06"  //00-Aberto;05-Represado Parcialmente;06-Represado Totalmente;
            lAtuUN  := .F.
        EndIf
        If cAlias == "PH6" .AND. ! PH6->PH6_STATUS $ "00/03"   //00-Aberto;03-Represado
            lAtuUN  := .F.
        EndIf

        If cAlias == "PHV"
            cChvPHVAnt := xFilial("PHV") + PHV->(PHV_CONTRA + PHV_REVISA + PHV_GRUPO + PHV->PHV_UNINEG)
            cChavePHV := xFilial("PHV") + PHV->(PHV_CONTRA + PHV_REVISA + PHV_GRUPO + cUNNova)
            If PHV->(DbSeek(cChavePHV))
                lAtuUN  := .F.
            EndIf
            PHV->(DbSeek(cChvPHVAnt))

            If PHV->PHV_UNINEG <> cUNAtu
                lAtuUN  := .F.
            EndIf
            
        EndIf 

        If ! Empty(cNameUN) .and. FieldGet(FieldPos(cNameUN)) == cUNAtu .AND. lAtuUN
            
            aadd(aCampos, {cNameUN, cUNNova})
             
            If cAlias == "PHV"
                aadd(aCampos, {"PHV_MSFIL", cUNNova})
            EndIf 

            If cAlias == "CNB" 
               aadd(aCampos, {"CNB_OBSERV", iif(!Empty(Alltrim(CNB->CNB_OBSERV)), Alltrim(CNB->CNB_OBSERV)+" TRANSF. [ " + cUNAtu + " ] EM [ " + DtoC( MSDATE() ) + " ]","TRANSF. [ " + cUNAtu + " ] EM [ " + DtoC( MSDATE() ) + " ]" ) } )   
            EndIf    
            
            /*
            If cAlias == "CNB"
                If CNB->CNB_SITUAC == "A" .And. CNB->CNB_STATRM == "000" 
                    aadd(aCampos, {"CNB_STATRM", "133"})   //Contratos TOTVS JUNDIAI Ativo
                ElseIf CNB->CNB_SITUAC == "P"
                    aadd(aCampos, {"CNB_STATRM", "134"})
                EndIf
            EndIf
            */

        EndIf

        //Atualizacao para tratamento de migração de itens do contrato por grupo
        //TECHFIN foi a primeira 06/2022
        If cAlias == "PH3" .AND. cvaltochar(nOpSel) $ '2/3/4/5'
            If cvaltochar(nOpSel) $ '2/3'
                If Alltrim(Posicione("SB1",1,xFilial("SB1")+PH3->PH3_PRODUT,"B1_GRUPO")) $ cGrpSl 
                    aadd(aCampos, {cNameUN, cUNNova})
                ELSE
                    lAtuUN  := .F.
                ENDIF 
            ElseIf cvaltochar(nOpSel) $ '4/5'
                If Alltrim(PH3->PH3_PRODUT) $ cPrdSl 
                    aadd(aCampos, {cNameUN, cUNNova})
                ELSE
                    lAtuUN  := .F.
                ENDIF 
            EndIf
        EndIf 
        If cAlias == "PH4" .AND. cvaltochar(nOpSel) $ '2/3/4/5'
            If cvaltochar(nOpSel) $ '2/3'
                If Alltrim(Posicione("SB1",1,xFilial("SB1")+PH4->PH4_PRODUT,"B1_GRUPO")) $ cGrpSl 
                    aadd(aCampos, {cNameUN, cUNNova})
                ELSE
                    lAtuUN  := .F.
                ENDIF
            ElseIf cvaltochar(nOpSel) $ '4/5'
                If Alltrim(PH4->PH4_PRODUT) $ cPrdSl 
                    aadd(aCampos, {cNameUN, cUNNova})
                ELSE
                    lAtuUN  := .F.
                ENDIF 
            EndIf 
        EndIf 
        If cAlias == "CNB" .AND. cvaltochar(nOpSel) $ '2/3/4/5'
            If cvaltochar(nOpSel) $ '2/3'
                If Alltrim(Posicione("SB1",1,xFilial("SB1")+CNB->CNB_PRODUT,"B1_GRUPO")) $ cGrpSl 
                    aadd(aCampos, {cNameUN, cUNNova})
                    aadd(aCampos, {"CNB_OBSERV", iif(!Empty(Alltrim(CNB->CNB_OBSERV)), Alltrim(CNB->CNB_OBSERV)+" TRANSF. [ " + cUNAtu + " ] EM [ " + DtoC( MSDATE() ) + " ]","TRANSF. [ " + cUNAtu + " ] EM [ " + DtoC( MSDATE() ) + " ]" ) } )   
                ELSE
                    lAtuUN  := .F.
                ENDIF 
            ElseIf cvaltochar(nOpSel) $ '4/5'
                If Alltrim(CNB->CNB_PRODUT) $ cPrdSl 
                    aadd(aCampos, {cNameUN, cUNNova})
                ELSE
                    lAtuUN  := .F.
                ENDIF 
            EndIf 
        EndIf 
        

        If ! Empty(cNameUN) .and. FieldGet(FieldPos(cNameUN)) == cUNAtu .AND. lAtuUN  .AND. !cvaltochar(nOpSel) $ '2/3/4/5' //nOpSel != 2

            aadd(aCampos, {cNameUN, cUNNova})

            If cAlias == "CNB" 
               aadd(aCampos, {"CNB_OBSERV", iif(!Empty(Alltrim(CNB->CNB_OBSERV)), Alltrim(CNB->CNB_OBSERV)+" TRANSF. [ " + cUNAtu + " ] EM [ " + DtoC( MSDATE() ) + " ]","TRANSF. [ " + cUNAtu + " ] EM [ " + DtoC( MSDATE() ) + " ]" ) } )   
            EndIf    
            
            /*
            If cAlias == "CNB"
                If CNB->CNB_SITUAC == "A" .And. CNB->CNB_STATRM == "000" 
                    aadd(aCampos, {"CNB_STATRM", "133"})   //Contratos TOTVS JUNDIAI Ativo
                ElseIf CNB->CNB_SITUAC == "P"
                    aadd(aCampos, {"CNB_STATRM", "134"})
                EndIf
            EndIf
            */

        EndIf

        RevCopyRec(aCampos)

        DbSkip()
    End
    RestArea(aArea)
Return

Static Function AtuRevisa(cAlias, cNameKey, nOrdem, aUniNeg, cContrato, cNameRev, cNovo)
	Local nx      := 0
	Local cChave  := ""
	Local aArea   := GetArea()
	Local aRec    := {}

	For nx := 1 to len(aUniNeg)
		cChave := aUniNeg[nx] + cContrato
		DbSetOrder(nOrdem)
		Dbseek(cChave)
		While ! Eof() .and. &cNameKey == cChave 
			aadd(aRec, Recno())
			DbSkip()
		End
	Next

	For nx := 1 to len(aRec)
		DbGoto(aRec[nx])
		RecLock(cAlias, .F.)
        FieldPut(FieldPos(cNameRev), cNovo)
		MsUnLock()
	Next

	RestArea(aArea)
Return


Static Function AtuUniNeg(cAlias, cNameKey, nOrdem, cContrato, cNameUN, cUNAtu, cUNNova, cNameCmp )
	Local nx      := 0
	Local cChave  := ""
	Local aArea   := GetArea()
	Local aRec    := {}
    Local cAMRef  := Left(Dtos(Date()), 6)

	
    cChave := xFilial(cAlias) + cContrato
    DbSetOrder(nOrdem)
    Dbseek(cChave)
    While ! Eof() .and. &cNameKey == cChave 
        If FieldGet(FieldPos(cNameUN)) <> cUNAtu
            DbSkip()
            Loop 
        EndIf 
        If FieldGet(FieldPos(cNameCmp)) < cAMRef
            DbSkip()
            Loop 
        EndIf 
        aadd(aRec, Recno())
        DbSkip()
    End

	For nx := 1 to len(aRec)
		DbGoto(aRec[nx])
		RecLock(cAlias, .F.)
        FieldPut(FieldPos(cNameUN), cUNNova)
		MsUnLock()
	Next

	RestArea(aArea)
Return


Static Function RevCopyRec(aCampos)
    Local nRegOri:= Recno()
    Local nRecno
    Local aDados:={}
    Local nX
    Local cCampo
    Local nPos
    For nX := 1 to FCount()
        cCampo := FieldName(nX)
        nPos := Ascan(aCampos,{|x| Alltrim(x[1]) == Alltrim(cCampo)})
        If Empty(nPos)
            aadd(aDados,FieldGet(nX))
        Else
            aadd(aDados,aCampos[nPos,2])
        EndIf
    Next
    RecLock(Alias(), .T., , .T. )
    For nX := 1 to FCount()
        FieldPut(nX,aDados[nX])
    Next
    MsUnLock()
    nRecno := Recno()
    Dbgoto(nRegOri)
Return nRecno


Static Function CriaPHB(cContra, cRevisa, cObs)
    Local cSeq   := "000"
    Local cChave := ""
    Local cCodMot:= GetMv("TIINCCRT",,"257")

    PHB->(DbSetOrder(1)) // 'PHB_FILIAL+PHB_CONTRA+PHB_REVISA+DTOS(PHB_DATA)+PHB_SEQ'
    cChave := PHB->(xFilial() + cContra)
    PHB->(DbSeek(cChave))
    While PHB->(! Eof() .and. cChave == PHB_FILIAL+PHB_CONTRA)                
        cSeq := PHB->PHB_SEQ
        PHB->(DbSkip())
    END
    cSeq := Soma1(cSeq)
	
    PHB->(Reclock('PHB',.T.))
    PHB->PHB_FILIAL	:= xFilial('PHB')
    PHB->PHB_SEQ	:= cSeq
    PHB->PHB_CONTRA	:= cContra
    PHB->PHB_REVISA	:= cRevisa
    PHB->PHB_DATA	:= dDatabase
    PHB->PHB_HORA	:= time()
    If Empty(__cUserId)
        PHB->PHB_CODUSR	:= "000000"
        PHB->PHB_USRNAM	:= "INCORPORAÇÃO FILIAL "
    Else 
        PHB->PHB_CODUSR	:= __cUserId
        PHB->PHB_USRNAM	:= cUserName 
    EndIf 
    PHB->PHB_TPATEN	:= '2'   
    PHB->PHB_MOTIVO	:= cCodMot
    PHB->PHB_OBSERV	:= cObs
    PHB->(MsUnlock())

Return

Static Function AtuPH8(cContrato, cRevisa, cUNAtu, cUNNova)
    Local cAlias   := "PH8"
    Local cNameKey := ""
    Local nOrdem   := 1
    Local aArea   := GetArea()
    Local cChave  := xFilial(cAlias) + cContrato 

    cNameKey := "PH8_FILIAL + PH8_CONTRA"

    DbSetOrder(nOrdem)
    DbSeek(cChave)
    While ! Eof() .and. &cNameKey == cChave
        If FieldGet(FieldPos("PH8_UNINEG")) == cUNAtu
            RecLock(cAlias, .F.)
            FieldPut(FieldPos("PH8_UNINEG"), cUNNova)
            MsUnLock()
        EndIf
        DbSkip()
    End
    RestArea(aArea)
Return

Static Function AtuPHM(cContrato, cRevisa, cUNAtu, cUNNova)
    Local cAlias   := "PHM"
    Local cNameKey := ""
    Local nOrdem   := 1
    Local aArea   := GetArea()
    Local cChave  := xFilial(cAlias) + cContrato

    cNameKey := "PHM_FILIAL + PHM_CONTRA"

    DbSetOrder(nOrdem)
    DbSeek(cChave)
    While ! Eof() .and. &cNameKey == cChave
        If FieldGet(FieldPos("PHM_UNINEG")) == cUNAtu
            RecLock(cAlias, .F.)
            FieldPut(FieldPos("PHM_UNINEG"), cUNNova)
            MsUnLock()
        EndIf
        DbSkip()
    End
    RestArea(aArea)
Return

/*
    Atualizar cronograma contabil
    Andre solicitou voltar para este fonte para evitar esquecimentos quando migrarem os contratos.
    27/11/23 - Venancio
*/
Static Function ProcCTB(cUNAtu,cUNNova,cContrato,dDtCorte)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    
    Local cSQL      :=  ""

    cSQL := "UPDATE " + RetSqlName("PHK") + " SET PHK_UNINEG='" + cUNNova + "',PHK_ORIGEM='MIGRA' WHERE PHK_FILIAL = '" + xFilial("PHK") +"' AND PHK_UNINEG = '" + cUNAtu  + "' AND PHK_CONTRA = '"+cContrato+"' AND PHK_CMPDIF >= '" + SubStr(dtos(dDtCorte),1,6) +"' AND D_E_L_E_T_ = ' ' "

	If (nError := TCSQLExec(cSQL)) <> 0
        lRet := .F.
        cMsg := AllTrim(Str(nError)) + "-" + TCSQLError()
    ENDIF

    cSQL := "UPDATE " + RetSqlName("PHL") + " SET PHL_UNINEG='" + cUNNova + "',PHL_ORIGEM='MIGRA' WHERE PHL_FILIAL = '" + xFilial("PHL") +"' AND PHL_UNINEG = '" + cUNAtu  + "' AND PHL_CONTRA = '"+cContrato+"'  AND PHL_CMPDIF >= '"+ SubStr(dtos(dDtCorte),1,6) +"' AND D_E_L_E_T_ = ' ' "

	If (nError := TCSQLExec(cSQL)) <> 0
        lRet := .F.
        cMsg := AllTrim(Str(nError)) + "-" + TCSQLError()
    ENDIF

    //Atualização para não dar erro no reprocessamento do backlog
    //Na ultima incorporação "Alphaville" foi realizado o update direto na PHL em produção, atualizando todos os registros para origem igual a MIGRA
    //Fonte TGCVA089 só processa os registros de backlog diferentes de MIGRA
    //Venancio 10/06/2024
    cSQL := "UPDATE " + RetSqlName("PHL") + " SET PHL_ORIGEM='MIGRA' WHERE PHL_FILIAL = '" + xFilial("PHL") +"' AND PHL_UNINEG = '" + cUNAtu  + "' AND PHL_CONTRA = '"+cContrato+"' AND D_E_L_E_T_ = ' ' "

	If (nError := TCSQLExec(cSQL)) <> 0
        lRet := .F.
        cMsg := AllTrim(Str(nError)) + "-" + TCSQLError()
    ENDIF

    RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} ProcRepr
    Migração dos itens represados dos contratos
    @type  Static Function
    @author user
    @since 27/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ProcRepr(cUNAtu, cUNNova,cContrato)
    
    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    
    Local cSQL      :=  ""

    cSQL := "UPDATE CRTR1 SET UNINEG='" + cUNNova + "' WHERE UNINEG = '" + cUNAtu  + "' AND CONTRATO = '"+cContrato+"' AND D_E_L_E_T_ = ' ' "

	If (nError := TCSQLExec(cSQL)) <> 0
        lRet := .F.
        cMsg := AllTrim(Str(nError)) + "-" + TCSQLError()
    ENDIF


    RestArea(aArea)

Return(lRet)

Static Function AtuZTS(cUNAtu, cUNNova) 
    Local cQuery := ""
    Local aArea   := GetArea()

    cQuery := " UPDATE " + RetSqlName("ZTS") + " ZTS "
    cQuery += "    SET ZTS_FILFAT = '" + cUNNova + "' "
    cQuery += "  WHERE ZTS_FILIAL = '" + FWxFilial("ZTS") + "'"	
    cQuery += "    AND ZTS_FILFAT = '" + cUNAtu + "' "
    cQuery += "    AND ZTS.D_E_L_E_T_ = ' '"

    If TcSqlExec(cQuery) == 0
        TcSqlExec("COMMIT")
    EndIf
    RestArea(aArea)

Return


User Function INCCTR3(cPar)
    Local aPar      := {}
    Local cIdProc   := ""
    Local cCodRot   := ""
    Local cTMP      := ""
    Local cUNAtu    := ""
    Local aArea     := GetArea()
    Local aAreaPGG  := PGG->(GetArea())
    Local aAreaPGH  := PGH->(GetArea())
    Local cChave    := ""
    Local cQuery    := ""
    Local nRecno    := 0
    Local cIdREf    := ""
    
    FWJsonDeserialize(cPar, @aPar)
    cIdProc := aPar[1]
    cCodRot := aPar[2]

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cIDProc ))

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

    cUNAtu := PGG->PGG_FILORI

    cIdRef := PegaIDRef()
    If Empty(cIdRef) 
        Return 
    EndIf 


    cTMP := MntQryLote(cIdRef, cCodRot, @cQuery)
    If Empty(cTMP)
        MsgAlert("Não existem registros no IDRef " + cIdRef)
        Return 
    EndIf 

    While  (cTMP)->(! Eof())
        cChave := (cTMP)->PGI_CHAVE
        nRecno := (cTMP)->PGI_RECORI
		
        If ! IsBlind()
            IncProc("Gerando Log contrato: " + Alltrim(cChave)   )
            ProcessMessage()
        EndIf
		If lAbortPrint
			exit
        Endif 


        u_TILogNew(cIdProc, cCodRot, cChave, cQuery, "CN9", nRecno)

        (cTMP)->(DbSkip())
    End

    
    RestArea(aAreaPGH)
    RestArea(aAreaPGG)
    RestArea(aArea)

Return 

Static Function PegaIDRef()
    Local aParamBox := {}
    Local cIDRef    := ""
    Local aRet      := {}

    MV_PAR01:=""
    
    aAdd(aParamBox,{1,"ID Referencia",	Space(6), "999999", "NaoVazio()",,, 3, .T.})
    If ParamBox(aParamBox, "ID Anterior", @aRet) 
       cIDRef := aRet[1]
    EndIf

Return cIDRef


Static Function MntQryLote(cIdRef, cCodRef,  cQuery)

    Local cTMP      := GetNextAlias()

    cQuery := " "
    cQuery += " SELECT *   " 
    cQuery += " FROM   " + RetSQLName("PGI") + "   " 
    cQuery += " WHERE  PGI_IDPROC = '" + cIdRef + "'   " 
    cQuery += "        AND PGI_CODROT = '" + cCodRef + "'   " 
    cQuery += "        AND PGI_STEXEC = '3'   " 
    cQuery += "        AND D_E_L_E_T_ = ' '   " 


    DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
	If (cTMP)->(Eof())		
        (cTMP)->(DbCloseArea())
        Return ""
    EndIf

Return cTMP


