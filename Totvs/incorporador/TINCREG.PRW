#INCLUDE 'TOTVS.CH'

User Function INCREG1(cPar)
    Local aPar      := {}
    Local cIdProc   := ""
    Local cCodRot   := ""
    Local cTMP      := ""
    Local cUNAtu    := ""
    Local aArea     := GetArea()
    Local aAreaPGG  := PGG->(GetArea())
    Local aAreaPGH  := PGH->(GetArea())
    Local cChaveTit := ""
    Local cChave    := ""
    Local cQuery    := ""
    Local cNumTit   := "" 
    Local cPrefixo  := ""
    Local cParcela  := "" 
    Local cTipTit   := ""
    Local cFilPJ9   := ""
    Local cLote     := "" 
    Local cFilTit   := ""
    Local nRecno    := 0
    Local nTot      := 0
    Local aPergunte := {}
    Local aIncRod	:= {}

    FWJsonDeserialize(cPar, @aPar)
    cIdProc := aPar[1]
    cCodRot := aPar[2]

    If Len(aPar) > 2
        aPergunte := aPar[3]
    EndIF

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cIDProc ))

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

    cUNAtu := PGG->PGG_FILORI
    cUNNova:= PGG->PGG_FILDES

    aIncRod := U_INCFUN1(cUNAtu)

    If len(aIncRod) > 0

        cTMP := MontaQry(cUNAtu, @cQuery)

        If Empty(cTMP)
            MsgAlert("Não existem dados na unidade " + cUNAtu)
            Return 
        EndIf 
        
        IF (cTMP)->(! Eof())
            nTot := (cTMP)->TOTREG
            ProcRegua(nTot)
        ENDIF

        While  (cTMP)->(! Eof())
            cFilPJ9  := (cTMP)->PJ9_FILIAL
            cLote    := (cTMP)->PJ9_LOTE
            cFilTit  := (cTMP)->PJ9_FILTIT
            cNumTit  := (cTMP)->PJ9_NUMTIT
            cPrefixo := (cTMP)->PJ9_PREFIX
            cParcela := (cTMP)->PJ9_PARCEL
            cTipTit  := (cTMP)->PJ9_TIPTIT
            nRecno    := (cTMP)->RECNO 

            cChaveTit := cPrefixo+cNumTit+cParcela

            If ! IsBlind()
                IncProc("Gerando Log título: " + cPrefixo+"-"+cNumTit+"-"+cParcela )
                ProcessMessage()
            EndIf
            If lAbortPrint
                exit
            Endif 

            cChave := cFilPJ9 + cLote + cFilTit + cChaveTit + cTipTit // PJ9_FILIAL, PJ9_LOTE, PJ9_FILTIT, PJ9_PREFIX, PJ9_NUMTIT, PJ9_PARCEL, PJ9_TIPTIT
            u_TILogNew(cIdProc, cCodRot, cChave, cQuery, "PJ9", nRecno)

            (cTMP)->(DbSkip())
        End
    else
        MsgAlert("Não encontrado itens na tabela de De/Para da filial de origem - ZX5 tabela _INCDP")
    EndIf

    RestArea(aAreaPGH)
    RestArea(aAreaPGG)
    RestArea(aArea)

Return 

Static Function MontaQry(cUNAtu, cQuery)

    Local cTMP      := GetNextAlias()

    cQuery := " "
    cQuery += " SELECT COUNT(PJ9_FILIAL) OVER (PARTITION BY ' ') TOTREG,PJ9_FILIAL,PJ9_LOTE,PJ9_FILTIT,PJ9_PREFIX,PJ9_NUMTIT,PJ9_PARCEL,PJ9_TIPTIT,PJ9_CODCLI,PJ9_LOJA,PJ9_VENREA,PJ9_ATRASO,PJ9_DATA,PJ9_HORA,PJ9_STATUS,PJ9_ERRO,PJ9_HLCAVI,PJ9_SUPBLQ,PJ9_HLCBLQ,PJ9_IDSMS,PJ9_HLCDTB,PJ9_CODREG,PJ9_SEQ,PJ9_CODACA,PJ9_DATINI,PJ9_HORINI,PJ9_TIPEXE,PJ9_TPCLI,PJ9_PROPEN,PJ9_SALDO,PJ9_SLQLIQ,PJ9_TPSLD,PJ9_REEXEC,PJ9_CLISPR, PJ9.R_E_C_N_O_ AS RECNO  " 
    cQuery += "FROM " + RETSQLNAME("PJ9") + " PJ9 "
    cQuery += "INNER JOIN " + RETSQLNAME("SE1") + " SE1 ON E1_FILIAL = PJ9_FILTIT "
    cQuery += "AND E1_NUM = PJ9_NUMTIT "
    cQuery += "AND E1_PREFIXO = PJ9_PREFIX "
    cQuery += "AND E1_PARCELA = PJ9_PARCEL "
    cQuery += "AND E1_TIPO = PJ9_TIPTIT "
    cQuery += "AND E1_CLIENTE = PJ9_CODCLI "
    cQuery += "AND E1_LOJA = PJ9_LOJA "
    cQuery += "WHERE PJ9_FILTIT = '" + cUNAtu + "' AND TRIM(PJ9_FILIAL) = SUBSTR(PJ9_FILTIT,1,3) "
    cQuery += "AND E1_SALDO > 0 "
    cQuery += "AND E1_TIPO NOT LIKE '%-' "
    cQuery += "AND PJ9.D_E_L_E_T_ = ' ' "
    cQuery += "AND SE1.D_E_L_E_T_ = ' ' "

    DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
	If (cTMP)->(Eof())		
        (cTMP)->(DbCloseArea())
        Return ""
    EndIf

Return cTMP


User Function INCREG2(cPar)
    Local cId         := ""
    Local cCodRot     := ""
    Local cChave      := ""
    Local lSimula     := .F.
    Local aPar        := {}
    Local cPrefixo    := ""
    Local cNumTit     := ""
    Local cParcela    := ""
    Local cChaveTit   := ""
    Local cTipTit     := ""
    Local cFilPJ9     := ""
    Local cLote       := ""
    Local cFilTit     := ""
    Local cMsg        := ""  

    Local aAreaPJ9    := PJ9->(GetArea())
    Local cObs        := ""
    Local cMsgLog     := ""

    FWJsonDeserialize(cPar, @aPar)
    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]

    // PJ9_FILIAL, PJ9_LOTE, PJ9_FILTIT, PJ9_PREFIX, PJ9_NUMTIT, PJ9_PARCEL, PJ9_TIPTIT
    cFilPJ9  := SubStr(cChave,1,11)
    cLote    := SubStr(cChave,12,6)
    cFilTit  := SubStr(cChave,18,11)
    cPrefixo := SubStr(cChave,29,3)
    cNumTit  := SubStr(cChave,32,9)
    cParcela := SubStr(cChave,41,3)
    cChaveTit := cPrefixo+cNumTit+cParcela
    cTipTit  := SubStr(cChave,44,3)

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cId ))

    cUNAtu  := PGG->PGG_FILORI
    cUNNova := PGG->PGG_FILDES
    cObs    := PGG->PGG_DESCRI

    // X2_UNICO: PJ9_FILIAL+PJ9_LOTE+PJ9_FILTIT+PJ9_PREFIX+PJ9_NUMTIT+PJ9_PARCEL+PJ9_TIPTIT                                                                                                                                                                                
    // Posiciona PJ9

    PJ9->(dbSetOrder(1))  // PJ9_FILIAL, PJ9_LOTE, PJ9_FILTIT, PJ9_PREFIX, PJ9_NUMTIT, PJ9_PARCEL, PJ9_TIPTIT
    IF !PJ9->(dbSeek(cFilPJ9+cLote+cFiltit+cChavetit+cTipTit)) 
        RETURN "PJ9 do título " + cChaveTit + " não encontrado!!!"
    ENDIF

   U_TILogBegin(cId, cCodRot, cChave, lSimula)

   BEGIN TRANSACTION

    If ! lSimula 

        u_TILogMsg(cId, cCodRot, cChave, "Atualizando PJ9 "+cChave)
        cMsg += AtuPJ9(cChave, cUNAtu, cUNNova ) 

    EndIf 


   END TRANSACTION

    If ! Empty(cMsg)
        U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
    Else
        U_TILogEnd(cId, cCodRot, cChave, lSimula, cMsgLog)
    EndIf 


    RestArea(aAreaPJ9)

Return cMsg


Static Function AtuPJ9(cChave, cUNAtu, cUNNova ) 

Local lRet     := .T.
Local cRet     := ""
Local aCposAlt := {}
Local cErro    := ""
Local aArea    := GetArea()
Local aAreaPJ9 := PJ9->(GetArea())

Local cFilPJ9  := PADR(SUBSTR(cUNAtu,1,3),11)
Local cLote    := SubStr(cChave,12,6)
Local cPrefixo := SubStr(cChave,29,3)
Local cNumTit  := SubStr(cChave,32,9)
Local cParcela := SubStr(cChave,41,3)
Local cChaveTit := ""    
Local cTipTit  := SubStr(cChave,44,3)

cChaveTit := cPrefixo+cNumTit+cParcela

// Posiciona PJ9
PJ9->(dbSetOrder(1))  // PJ9_FILIAL, PJ9_LOTE, PJ9_FILTIT, PJ9_PREFIX, PJ9_NUMTIT, PJ9_PARCEL, PJ9_TIPTIT
IF !PJ9->(dbSeek(cFilPJ9+cLote+cUNAtu+cChaveTit+cTipTit))
    cRet := "Não foi possível encontrar: " + cFilPJ9+cLote+cUNAtu+cChaveTit+cTipTit
    lRet := .F.
ENDIF

If lRet
    Begin Transaction

        aCposAlt := { {"PJ9_FILTIT" , cUNNova},;
                        {"PJ9_FILIAL" , PADR(SUBSTR(cUNNova,1,3),11) },;
                        {"PJ9_PREFIX" , U_From2Inc(cPrefixo,cUNAtu) }  }

        If !( DuplicReg("PJ9", aCposAlt) > 0)
            cErro := "Problemas na criação da PJ9."
            U_TILogMsg(cId, cCodRot, cChave, cErro)
        EndIf

    END TRANSACTION
Endif

RestArea(aAreaPJ9)
RestArea(aArea)

Return cRet


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

	RecLock( cArquiv1, .T., , .T. , .T. )
	For nContador := 1 To nCampos
		// dbSelectArea(cArquiv2 )
		// FieldPut(FieldPos(aCampos[nContador, 1],aCampos[nContador, 2]) )
		cVar 		:= (cArquiv1+"->"+aCampos[nContador,1]) 
		&cVar		:= aCampos[nContador, 2]
	Next 
	MsUnlock()         
	nReturn := RECNO()	

	(cArquiv1)->(RestArea(aArea1))
	RestArea(aArea)       

Return(nReturn)
