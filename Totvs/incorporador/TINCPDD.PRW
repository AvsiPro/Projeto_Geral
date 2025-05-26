#INCLUDE 'TOTVS.CH'
//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCPDD
Rotina para transferir o PDD de uma filial para outra

@author		Alexandre Venancio
@since		01/10/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCPDD1(cPar)
Local aPar      := {}
Local cIdProc   := ""
Local cCodRot   := ""
Local cUNAtu    := ""
Local aArea     := GetArea()
Local aAreaPGG  := PGG->(GetArea())
Local aAreaPGH  := PGH->(GetArea())
Local cChave    := ""
Local cQueryPSN := ""
Local cQueryPRF := ""
Local nRecno    := 0
Local aPergunte := {}
Local aIncRod	:= {}

FWJsonDeserialize(cPar, @aPar)
cIdProc := aPar[1]
cCodRot := aPar[2]
If Len(aPar) > 2
    aAdd(aPergunte, U_TIncISX1(cCodRot, aPar[3], "01"))
EndIF

PGG->(DbSetOrder(1))
PGG->(DbSeek(xFilial("PGH") + cIDProc ))

PGH->(DbSetOrder(1))
PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

cUNAtu := PGG->PGG_FILORI
cUNNova:= PGG->PGG_FILDES

aIncRod := U_INCFUN1(cUNAtu)

If len(aIncRod) > 0
    
    cPSN := TransfPsn(cUNAtu, @cQueryPSN,aPergunte[1])
    If Empty(cPSN)
        MsgAlert("Não existem registros de Mov PDD CR" + cUNAtu)
        Return 
    EndIf 

    While  (cPSN)->(! Eof())
        // X2_UNICO:                 PSN_FILIAL+PSN_PREFIX+PSN_NUM+PSN_PARCEL+PSN_TIPO+PSN_COMPET
        cPSNFil  := (cPSN)->PSN_FILIAL
        cPSNPref := (cPSN)->PSN_PREFIX    
        cPSNNum  := (cPSN)->PSN_NUM
        cPSNParc := (cPSN)->PSN_PARCEL 
        cPSNTipo := (cPSN)->PSN_TIPO
        cPSNComp := (cPSN)->PSN_COMPET
        nRecno   := (cPSN)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log PSN: " + cPSNFil + cPSNPref + cPSNNum + cPSNParc + cPSNTipo + cPSNComp)
            ProcessMessage()
        EndIf

        If lAbortPrint
            exit
        Endif 

        cChave :=  cPSNFil + cPSNPref + cPSNNum + cPSNParc + cPSNTipo + cPSNComp + cvaltochar(nRecno)
        u_TILogNew(cIdProc, cCodRot, cChave, cQueryPSN, "PSN", nRecno)

        (cPSN)->(DbSkip())
    End


    cPRF := TransPRF(cUNAtu, @cQueryPRF,aPergunte[1])
    If Empty(cPRF)
        MsgAlert("Não existem registros de Rat NF PDD CR" + cUNAtu)
        Return 
    EndIf 

    While  (cPRF)->(! Eof())
        // X2_UNICO:    PRF_FILIAL+PRF_DOC+PRF_SERIE+PRF_CLIENT+PRF_LOJA
        
        cPRFDoc  := (cPRF)->PRF_DOC
        cPRFSer  := (cPRF)->PRF_SERIE   
        cPRFCli  := (cPRF)->PRF_CLIENT       
        cPRFLoj  := (cPRF)->PRF_LOJA           
        nRecno   := (cPRF)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log PRF: " + cPRFDoc+cPRFSer+cPRFCli+cPRFLoj)
            ProcessMessage()
        EndIf
        If lAbortPrint
            exit
        Endif 

        cChave := cPRFDoc+cPRFSer+cPRFCli+cPRFLoj+cvaltochar(nRecno)
        u_TILogNew(cIdProc, cCodRot, cChave, cQueryPRF, "PRF", nRecno)

        (cPRF)->(DbSkip())
    End
    
    If Select(cPSN) > 0
        (cPSN)->(DBCloseArea())
    Endif

    If Select(cPRF) > 0
        (cPRF)->(DBCloseArea())
    Endif
else
    MsgAlert("Não encontrado itens na tabela de De/Para da filial de origem - ZX5 tabela _INCDP")
EndIf

RestArea(aAreaPGH)
RestArea(aAreaPGG)
RestArea(aArea)



Return 

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransfPsn
Rotina para selecionar os Mov PDD CR                    

@author		Alexandre Venancio
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransfPsn(cUNAtu, cQueryPSN,cPSNComp)

Local cPSN      := GetNextAlias()
// Seleciona os Mov PDD CR                    
cQueryPSN := " "
cQueryPSN += " SELECT COUNT(PSN_FILIAL) OVER (PARTITION BY ' ') TOTREG, PSN.R_E_C_N_O_ RECORI,PSN_FILIAL,PSN_PREFIX,PSN_NUM,PSN_PARCEL,PSN_TIPO,PSN_COMPET"
cQueryPSN +=   " FROM " + RETSQLNAME("PSN") + " PSN "
cQueryPSN +=   " INNER JOIN  " + RETSQLNAME("SE1") + " SE1 "
cQueryPSN +=   "   ON E1_FILIAL='" + cUNAtu + "'  " 
cQueryPSN +=   "   AND E1_SALDO > 0 "
cQueryPSN +=   "   AND E1_PREFIXO = PSN_PREFIX "
cQueryPSN +=   "   AND E1_NUM = PSN_NUM "
cQueryPSN +=   "   AND E1_PARCELA = PSN_PARCEL "
cQueryPSN +=   "   AND E1_TIPO = PSN_TIPO "
cQueryPSN += " WHERE PSN_FILIAL='" + cUNAtu + "'  " 
cQueryPSN += " AND PSN.D_E_L_E_T_ = ' ' "
cQueryPSN += " AND SE1.D_E_L_E_T_ = ' ' "
cQueryPSN += " AND PSN_COMPET='"+cPSNComp+"'"

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryPSN), cPSN, .T., .F.)
If (cPSN)->(Eof())		
    (cPSN)->(DbCloseArea())
    Return ""
EndIf

Return cPSN

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransPRF
Rotina para selecionar os Rat NF PDD CR

@author		Alexandre Venancio
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransPRF(cUNAtu, cQueryPRF,cPSNComp)

Local cPRF      := GetNextAlias()

// Seleciona os Rat NF PDD CR 
cQueryPRF := " "
cQueryPRF += " SELECT COUNT(PRF_FILIAL) OVER (PARTITION BY ' ') TOTREG, PRF.R_E_C_N_O_ RECORI, PRF_FILIAL,PRF_DOC,PRF_SERIE,PRF_CLIENT,PRF_LOJA "
cQueryPRF +=   " FROM " + RETSQLNAME("PRF") + " PRF "
cQueryPRF +=   " INNER JOIN  " + RETSQLNAME("SE1") + " SE1 "
cQueryPRF +=   "   ON E1_FILIAL='" + cUNAtu + "'  " 
cQueryPRF +=   "   AND E1_SALDO > 0 "
cQueryPRF +=   "   AND E1_PREFIXO = PRF_SERIE "
cQueryPRF +=   "   AND E1_NUM = PRF_DOC "
cQueryPRF +=   "   AND E1_PARCELA = PRF_PARCEL "
cQueryPRF +=   "   AND E1_TIPO = PRF_TIPO " 
cQueryPRF += " WHERE PRF_FILPRJ='" + cUNAtu + "'  " 
cQueryPRF += " AND PRF.D_E_L_E_T_ = ' ' "
cQueryPRF += " AND SE1.D_E_L_E_T_ = ' ' "
cQueryPRF += " AND PRF_COMPET='"+cPSNComp+"'"

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryPRF), cPRF, .T., .F.)
If (cPRF)->(Eof())		
    (cPRF)->(DbCloseArea())
    Return ""
EndIf

Return cPRF


//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCPDD2
Rotina para Processar registros PDD                    

@author		Alexandre Venancio
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCPDD2(cPar)

    Local cUNAtu      := ""
    Local cUNNova     := ""
    Local cMsg        := ""
    Local nRecReg     := 0  

    Local cId         := ""
    Local cCodRot     := ""
    Local cChave      := ""
    Local lSimula     := .F.
    Local aPar        := {}
    Local aPergunte   := {}
    Local cPerg       := ""
    Local lSemInc     := .F.
    Local cPreDest
    Local aParDePa    := {}
    Local lRet        := .T.

    FWJsonDeserialize(cPar, @aPar)
    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]

    If Len(aPar) > 4
        aPergunte := aPar[5]
        cPerg := U_TIncISX1(cCodRot, aPergunte, "01")
        lSemInc := U_TIncISX1(cCodRot, aPergunte, "02") == 1
    EndIF    

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGG") + cId ))

    cUNAtu  := PGG->PGG_FILORI
    cUNNova := PGG->PGG_FILDES
    nRecReg := PGI->PGI_RECORI

    cPreDest    := '' 
    aParDePa    := U_INCFUN1(cUNAtu)

    U_TILogBegin(cId, cCodRot, cChave, lSimula)

    Begin Transaction

        If ! lSimula 
            cPreDest := ''
            
            If PGI->PGI_TABORI == "PSN"
                nPosDP := Ascan(aParDePa,{|x| Alltrim(x[1]) == Alltrim(PSN->PSN_PREFIX)})
                cPreDest := ''

                If nPosDp > 0
                    cPreDest := Alltrim(aParDePa[nPosDP,02])
                EndIf
            
                lRet := ProcPSN(cUNAtu,cUNNova,nRecReg,cPreDest)
                If !lRet
                    cMsg := "Erro na transferência PSN"
                EndIf
            ELSEIf PGI->PGI_TABORI == "PRF"
                nPosDP := Ascan(aParDePa,{|x| Alltrim(x[1]) == Alltrim(PRF->PRF_SERIE)})
                cPreDest := ''

                If nPosDp > 0
                    cPreDest := Alltrim(aParDePa[nPosDP,02])
                EndIf

                lRet := ProcPRF(cUNAtu,cUNNova,nRecReg,cPreDest)
                If !lRet
                    cMsg := "Erro na transferência PRF"
                EndIf
            
            ENDIF
        EndIf 

    End Transaction

    If ! Empty(cPerg)
        cPerg := "Pergunta: " + cvaltochar(cPerg)
        IF ! Empty(cMsg)
            cMsg += cPerg
        EndIF
    EndIf

    If ! Empty(cMsg)
        U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
    Else
        U_TILogEnd(cId, cCodRot, cChave, lSimula, cPerg)
    EndIf 


Return cMsg

/*/{Protheus.doc} ProcPSN
Funcao para duplicar registros PSN 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcPSN(cUNAtu,cUNNova,nRecReg,cPreDest)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("PSN")
    PSN->(DbGoto(nRecReg))

    aCposAlt := { 	{ "PSN_FILIAL"  , cUNNova } ,; // Codigo da filial que recebera o titulo
					{ "PSN_HIST"    , Alltrim(PSN->PSN_HIST) + " trf fil " + cUNAtu } ,;
					{ "PSN_PREFIX"  , If(!Empty(cPreDest),cPreDest,PSN->PSN_PREFIX)  } } // Prefixo do título destino

    If DuplicReg("PSN",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("PSN",.F.)
        PSN->PSN_FILIAL := StrTran(cUNAtu,"0","X")
        MsUnLock()
    else
        lRet := .F.
    EndIf

    RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} ProcPRF
Funcao para duplicar registros PRF 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcPRF(cUNAtu,cUNNova,nRecReg,cPreDest)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("PRF")
    PRF->(DbGoto(nRecReg))

    aCposAlt := { 	{ "PRF_FILPRJ"  , cUNNova } ,; // Codigo da filial que recebera o titulo
                    { "PRF_FILIAL"  , "XXX" } ,;
                    { "PRF_SERIE" , If(!Empty(cPreDest),cPreDest,PRF->PRF_SERIE)} } 	

    If DuplicReg("PRF",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("PRF",.F.)
        PRF->PRF_FILIAL := StrTran(cUNAtu,"0","X")
        MsUnLock()
    else
        lRet := .F.
    EndIf

    RestArea(aArea)

Return(lRet)

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

RecLock( cArquiv1, .t. )
For nContador := 1 To nCampos
    cVar 		:= (cArquiv1+"->"+aCampos[nContador,1])
    &cVar		:= aCampos[nContador, 2]
Next
MsUnlock()
nReturn := RECNO()

(cArquiv1)->(RestArea(aArea1))
RestArea(aArea)

Return(nReturn)
