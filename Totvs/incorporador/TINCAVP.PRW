#INCLUDE 'TOTVS.CH'
//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCAVP
Rotina para transferir o AVP de uma filial para outra

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCAVP1(cPar)
Local aPar      := {}
Local cIdProc   := ""
Local cCodRot   := ""
Local cTMP      := ""
Local cFIP      := ""
Local cFWU      := ""
Local cFIO      := ""
Local cFWV      := ""
Local cUNAtu    := ""
Local aArea     := GetArea()
Local aAreaPGG  := PGG->(GetArea())
Local aAreaPGH  := PGH->(GetArea())
Local cPrefixo  := ""
Local cChave    := ""
Local cQuery    := ""
Local cQueryFIP := ""
Local cQueryFWU := ""
Local cQueryFIO := ""
Local cQueryFWV := ""
Local cNum      := ""
Local cParcela  := ""
Local cTipo     := ""
Local cCliente  := ""   
Local cLoja     := ""
Local cSeq      := "" 
Local cFIPProc  := ""
Local cFIPIdMov := ""
Local nRecno    := 0
Local aPergunte := {}
Local cFWUPref  := ""
Local cFWUNum   := ""
Local cFWUPar   := ""   
Local cFWUTipo  := ""       
Local cFWUClie  := ""   
Local cFWULoja  := ""       
Local cFWUSeq   := ""   
Local cFWUDoc   := ""    
Local cFWUSer   := ""
Local cFWUIte   := ""           
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
        MsgAlert("Não existem registros de AVP CR na unidade " + cUNAtu)
        Return 
    EndIf 

    While  (cTMP)->(! Eof())
        // X2_UNICO:                 FIN_FILIAL+FIN_PREFIX+FIN_NUM+FIN_PARCEL+FIN_TIPO+FIN_CLIENT+FIN_LOJA+FIN_SEQ                                                                                                                                                                             
        cPrefixo := (cTMP)->FIN_PREFIX
        cNum     := (cTMP)->FIN_NUM
        cParcela := (cTMP)->FIN_PARCEL
        cTipo    := (cTMP)->FIN_TIPO
        cCliente := (cTMP)->FIN_CLIENT
        cLoja    := (cTMP)->FIN_LOJA
        cSeq     := (cTMP)->FIN_SEQ
        nRecno   := (cTMP)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log FIN: " + cPrefixo+cNum+cParcela+cTipo+cCliente+cLoja+cSeq)
            ProcessMessage()
        EndIf
        If lAbortPrint
            exit
        Endif 

        cChave := cPrefixo+cNum+cParcela+cTipo+cCliente+cLoja+cSeq 
        u_TILogNew(cIdProc, cCodRot, cChave, cQuery, "FIN", nRecno)

        (cTMP)->(DbSkip())
    End


    cFIP := TransFIP(cUNAtu, @cQueryFIP)
    If Empty(cFIP)
        MsgAlert("Não existem registros de Mov AVP CR" + cUNAtu)
        Return 
    EndIf 

    While  (cFIP)->(! Eof())
        // X2_UNICO:                 FIP_FILIAL+FIP_PROC+FIP_IDMOV                                                                                                                                                                                                                             
        cFIPProc := (cFIP)->FIP_PROC    
        cFIPIdMov:= (cFIP)->FIP_IDMOV 
        nRecno   := (cFIP)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log FIP: " + cFIPProc + cFIPIdMov)
            ProcessMessage()
        EndIf
        If lAbortPrint
            exit
        Endif 

        cChave := cFIPProc + cFIPIdMov
        u_TILogNew(cIdProc, cCodRot, cChave, cQueryFIP, "FIP", nRecno)

        (cFIP)->(DbSkip())
    End


    cFWU := TransFWU(cUNAtu, @cQueryFWU)
    If Empty(cFWU)
        MsgAlert("Não existem registros de Rat NF AVP CR" + cUNAtu)
        Return 
    EndIf 

    While  (cFWU)->(! Eof())
        // X2_UNICO:FWU_FILIAL+FWU_PREFIX+FWU_NUM+FWU_PARCEL+FWU_TIPO+FWU_CLIENT+FWU_LOJA+FWU_SEQ+FWU_DOC+FWU_SERIE+FWU_ITEM                                                                                                                                                                    
        
        cFWUPref := (cFWU)->FWU_PREFIX 
        cFWUNum  := (cFWU)->FWU_NUM
        cFWUPar  := (cFWU)->FWU_PARCEL   
        cFWUTipo := (cFWU)->FWU_TIPO       
        cFWUClie := (cFWU)->FWU_CLIENT   
        cFWULoja := (cFWU)->FWU_LOJA       
        cFWUSeq  := (cFWU)->FWU_SEQ   
        cFWUDoc  := (cFWU)->FWU_DOC    
        cFWUSer  := (cFWU)->FWU_SERIE
        cFWUIte  := (cFWU)->FWU_ITEM           
        nRecno   := (cFWU)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log FWU: " + cFWUPref+cFWUNum+cFWUPar+cFWUTipo+cFWUClie+cFWULoja+cFWUSeq+cFWUDoc+cFWUSer+cFWUIte )
            ProcessMessage()
        EndIf
        If lAbortPrint
            exit
        Endif 

        cChave := cFWUPref+cFWUNum+cFWUPar+cFWUTipo+cFWUClie+cFWULoja+cFWUSeq+cFWUDoc+cFWUSer+cFWUIte
        u_TILogNew(cIdProc, cCodRot, cChave, cQueryFWU, "FWU", nRecno)

        (cFWU)->(DbSkip())
    End

    cFIO := TransFIO(cUNAtu, @cQueryFIO)
    If Empty(cFIO)
        MsgAlert("Não existem registros de Proc AVP CR" + cUNAtu)
        Return 
    EndIf 

    While  (cFIO)->(! Eof())
        //X2_UNICO : FIO_FILIAL+FIO_PROC
        cFIOProc    := (cFIO)->FIO_PROC           
        nRecno      := (cFIO)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log FWU: " + cFIOProc )
            ProcessMessage()
        EndIf

        If lAbortPrint
            exit
        Endif 

        cChave := cFIOProc
        u_TILogNew(cIdProc, cCodRot, cChave, cQueryFIO, "FIO", nRecno)

        (cFIO)->(DbSkip())
    END

    cFWV:= TransFWV(cUNAtu, @cQueryFWV)
    If Empty(cFWV)
        MsgAlert("Não existem registros de Mov NF AVP CR" + cUNAtu)
        Return 
    EndIf 

    While  (cFWV)->(! Eof())
        //X2_UNICO : FWV_FILIAL+FWV_PROC+FWV_IDMOV+FWV_ITRAT 
        cFWVProc    := (cFWV)->FWV_PROC
        cFWVIdmv    := (cFWV)->FWV_IDMOV
        cFWVItrt    := (cFWV)->FWV_ITRAT
        nRecno      := (cFWV)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Log FWV: " + cFWVProc+cFWVIdmv+cFWVItrt )
            ProcessMessage()
        EndIf
        If lAbortPrint
            exit
        Endif 

        cChave := cFWVProc+cFWVIdmv+cFWVItrt
        u_TILogNew(cIdProc, cCodRot, cChave, cQueryFWV, "FWV", nRecno)

        (cFWV)->(DbSkip())
    END
    
    If Select(cTMP) > 0
        (cTMP)->(DBCloseArea())
    Endif

    If Select(cFIP) > 0
        (cFIP)->(DBCloseArea())
    Endif

    If Select(cFWU) > 0
        (cFWU)->(DBCloseArea())
    Endif

    If Select(cFIO) > 0
        (cFIO)->(DBCloseArea())
    Endif

    If Select(cFWV) > 0
        (cFWV)->(DBCloseArea())
    Endif
else
    MsgAlert("Não encontrado itens na tabela de De/Para da filial de origem - ZX5 tabela _INCDP")
EndIf

RestArea(aAreaPGH)
RestArea(aAreaPGG)
RestArea(aArea)


Return 

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} MontaQry
Rotina para selecionar os títulos AVP 

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function MontaQry(cUNAtu, cQuery)

Local cTMP      := GetNextAlias()
// Seleciona os titulos envolvidos
cQuery := " "
cQuery += " SELECT COUNT(FIN_FILIAL) OVER (PARTITION BY ' ') TOTREG, FIN.R_E_C_N_O_ RECORI, FIN_FILIAL, FIN_PREFIX, FIN_NUM, FIN_PARCEL, FIN_TIPO, FIN_CLIENT, FIN_LOJA, FIN_SEQ "
cQuery +=   "FROM " + RETSQLNAME("FIN") + " FIN "
cQuery +=   " INNER JOIN  " + RETSQLNAME("SE1") + " SE1 "
cQuery +=   "   ON E1_FILIAL = FIN_FILIAL   " 
cQuery +=   "   AND E1_PREFIXO = FIN_PREFIX   " 
cQuery +=   "   AND E1_NUM = FIN_NUM   " 
cQuery +=   "   AND E1_PARCELA = FIN_PARCEL   " 
cQuery +=   "   AND E1_TIPO = FIN_TIPO   " 
cQuery += " WHERE E1_FILIAL='" + cUNAtu + "'  " 
cQuery += " AND FIN_STATUS='A' "
cQuery += " AND E1_SALDO > 0 "
cQuery += " AND FIN.D_E_L_E_T_ = ' ' "
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
If (cTMP)->(Eof())		
    (cTMP)->(DbCloseArea())
    Return ""
EndIf

Return cTMP

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransFIP
Rotina para selecionar os Mov AVP CR                    

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransFIP(cUNAtu, cQueryFIP)

Local cFIP      := GetNextAlias()
// Seleciona os Mov AVP CR                    
cQueryFIP := " "
cQueryFIP += " SELECT COUNT(FIP_FILIAL) OVER (PARTITION BY ' ') TOTREG, FIP.R_E_C_N_O_ RECORI, FIP_FILIAL, FIP_PREFIX, FIP_NUM, FIP_PARCEL, FIP_TIPO, FIP_PROC,FIP_IDMOV "
cQueryFIP +=   "FROM " + RETSQLNAME("FIP") + " FIP "
cQueryFIP +=   " INNER JOIN  " + RETSQLNAME("FIN") + " FIN "
cQueryFIP +=   "   ON FIP_FILIAL = FIN_FILIAL   " 
cQueryFIP +=   "   AND FIP_PREFIX = FIN_PREFIX   " 
cQueryFIP +=   "   AND FIP_NUM = FIN_NUM   " 
cQueryFIP +=   "   AND FIP_PARCEL = FIN_PARCEL   " 
cQueryFIP +=   "   AND FIP_TIPO = FIN_TIPO   " 
cQueryFIP += " WHERE FIP_FILIAL='" + cUNAtu + "'  " 
cQueryFIP += " AND FIN_STATUS='A' "
cQueryFIP += " AND FIN.D_E_L_E_T_ = ' ' "
cQueryFIP += " AND FIP.D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryFIP), cFIP, .T., .F.)
If (cFIP)->(Eof())		
    (cFIP)->(DbCloseArea())
    Return ""
EndIf

Return cFIP

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransFWU
Rotina para selecionar os Rat NF AVP CR

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransFWU(cUNAtu, cQueryFWU)

Local cFWU      := GetNextAlias()

// Seleciona os Rat NF AVP CR 
cQueryFWU := " "
cQueryFWU += " SELECT COUNT(FWU_FILIAL) OVER (PARTITION BY ' ') TOTREG, FWU.R_E_C_N_O_ RECORI, FWU_PREFIX,FWU_NUM,FWU_PARCEL,FWU_TIPO,FWU_CLIENT,FWU_LOJA,FWU_SEQ,FWU_DOC,FWU_SERIE,FWU_ITEM "
cQueryFWU +=   "FROM " + RETSQLNAME("FWU") + " FWU "
cQueryFWU +=   " INNER JOIN  " + RETSQLNAME("FIN") + " FIN "
cQueryFWU +=   "   ON FWU_FILIAL = FIN_FILIAL   " 
cQueryFWU +=   "   AND FWU_PREFIX = FIN_PREFIX   " 
cQueryFWU +=   "   AND FWU_NUM = FIN_NUM   " 
cQueryFWU +=   "   AND FWU_PARCEL = FIN_PARCEL   " 
cQueryFWU +=   "   AND FWU_TIPO = FIN_TIPO   " 
cQueryFWU += " WHERE FWU_FILIAL='" + cUNAtu + "'  " 
cQueryFWU += " AND FIN_STATUS='A' "
cQueryFWU += " AND FIN.D_E_L_E_T_ = ' ' "
cQueryFWU += " AND FWU.D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryFWU), cFWU, .T., .F.)
If (cFWU)->(Eof())		
    (cFWU)->(DbCloseArea())
    Return ""
EndIf

Return cFWU

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransFIO
Rotina para selecionar os Proc AVP CR                    

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransFIO(cUNAtu, cQueryFIO)

Local cFIO      := GetNextAlias()
// Seleciona os Mov AVP CR                    
cQueryFIO := " "
cQueryFIO += " SELECT COUNT(FIO_FILIAL) OVER (PARTITION BY ' ') TOTREG, R_E_C_N_O_ RECORI, FIO_PROC "
cQueryFIO += " FROM " + RETSQLNAME("FIO") + " FIO "
cQueryFIO += " WHERE FIO_FILIAL = '" + cUNAtu + "'  " 
cQueryFIO += " AND FIO.D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryFIO), cFIO, .T., .F.)

If (cFIO)->(Eof())		
    (cFIO)->(DbCloseArea())
    Return ""
EndIf

Return cFIO

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransFWV
Rotina para selecionar os Mov AVP CR                    

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransFWV(cUNAtu, cQueryFWV)

Local cFWV      := GetNextAlias()
// Seleciona os Mov AVP CR                    
cQueryFWV := " "
cQueryFWV += " SELECT COUNT(FWV_FILIAL) OVER (PARTITION BY ' ') TOTREG, R_E_C_N_O_ RECORI, FWV_PROC, FWV_IDMOV, FWV_ITRAT "
cQueryFWV += " FROM " + RETSQLNAME("FWV") + " FWV "
cQueryFWV += " WHERE FWV_FILIAL = '" + cUNAtu + "'  " 
cQueryFWV += " AND FWV.D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryFWV), cFWV, .T., .F.)

If (cFWV)->(Eof())		
    (cFWV)->(DbCloseArea())
    Return ""
EndIf

Return cFWV

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCAVP2
Rotina para Processar registros AVP                    

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCAVP2(cPar)

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
            
            
            If PGI->PGI_TABORI == "FIN"
                nPosDP := Ascan(aParDePa,{|x| Alltrim(x[1]) == Alltrim(FIN->FIN_PREFIX)})
                cPreDest := ''

                If nPosDp > 0
                    cPreDest := Alltrim(aParDePa[nPosDP,02])
                EndIf

                lRet := ProcFIN(cUNAtu,cUNNova,nRecReg,cPreDest)
                If !lRet
                    cMsg := "Erro na transferência FIN"
                EndIf
            ELSEIf PGI->PGI_TABORI == "FIP"
                nPosDP := Ascan(aParDePa,{|x| Alltrim(x[1]) == Alltrim(FIP->FIP_PREFIX)})
                cPreDest := ''

                If nPosDp > 0
                    cPreDest := Alltrim(aParDePa[nPosDP,02])
                EndIf
                
                lRet := ProcFIP(cUNAtu,cUNNova,nRecReg,cPreDest)
                If !lRet
                    cMsg := "Erro na transferência FIP"
                EndIf
            ELSEIf PGI->PGI_TABORI == "FWU"
                nPosDP := Ascan(aParDePa,{|x| Alltrim(x[1]) == Alltrim(FWU->FWU_PREFIX)})
                cPreDest := ''
                
                If nPosDp > 0
                    cPreDest := Alltrim(aParDePa[nPosDP,02])
                EndIf

                lRet := ProcFWU(cUNAtu,cUNNova,nRecReg,cPreDest)
                If !lRet
                    cMsg := "Erro na transferência FWU"
                EndIf
            ELSEIf PGI->PGI_TABORI == "FIO"
                lRet := ProcFIO(cUNAtu,cUNNova,nRecReg)
                If !lRet
                    cMsg := "Erro na transferência FIO"
                EndIf
            ELSEIf PGI->PGI_TABORI == "FWV"
                lRet := ProcFWV(cUNAtu,cUNNova,nRecReg)
                If !lRet
                    cMsg := "Erro na transferência FWV"
                EndIf
            ENDIF
        EndIf 

    End Transaction

    If ! Empty(cPerg)
        cPerg := "Pergunta: " + cPerg
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

/*/{Protheus.doc} ProcFIN
Funcao para duplicar registros FIN 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcFIN(cUNAtu,cUNNova,nRecReg,cPreDest)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("FIN")
    FIN->(DbGoto(nRecReg))

    aCposAlt := { 	{ "FIN_FILIAL"  , cUNNova } ,; // Codigo da filial que recebera o titulo
					{ "FIN_PREFIX" , If(!Empty(cPreDest),cPreDest,FIN->FIN_PREFIX) } } // Prefixo do título destino
		

    If DuplicReg("FIN",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("FIN",.F.)
        FIN->FIN_FILIAL := StrTran(cUNAtu,"0","X")
        MsUnLock()
    else
        lRet := .F.
    EndIf

    RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} ProcFIP
Funcao para duplicar registros FIP 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcFIP(cUNAtu,cUNNova,nRecReg,cPreDest)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("FIP")
    FIP->(DbGoto(nRecReg))

    aCposAlt := { 	{ "FIP_FILIAL"  , cUNNova } ,; // Codigo da filial que recebera o titulo
					{ "FIP_PREFIX" , If(!Empty(cPreDest),cPreDest,FIP->FIP_PREFIX) } } // Prefixo do título destino
		

    If DuplicReg("FIP",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("FIP",.F.)
        FIP->FIP_FILIAL := StrTran(cUNAtu,"0","X")
        MsUnLock()
    else
        lRet := .F.
    EndIf

    RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} ProcFWU
Funcao para duplicar registros FWU

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcFWU(cUNAtu,cUNNova,nRecReg,cPreDest)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("FWU")
    FWU->(DbGoto(nRecReg))

    aCposAlt := { 	{ "FWU_FILIAL"  , cUNNova } ,; // Codigo da filial que recebera o titulo
					{ "FWU_PREFIX" , If(!Empty(cPreDest),cPreDest,FWU->FWU_PREFIX) } } // Prefixo do título destino
		

    If DuplicReg("FWU",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("FWU",.F.)
        FWU->FWU_FILIAL := StrTran(cUNAtu,"0","X")
        MsUnLock()
    else
        lRet := .F.
    EndIf

    RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} ProcFIO
Funcao para duplicar registros FIO 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcFIO(cUNAtu,cUNNova,nRecReg)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("FIO")
    FIO->(DbGoto(nRecReg))

    aCposAlt := { 	{ "FIO_FILIAL"  , cUNNova } ,; // Codigo da filial que recebera o titulo
                    { "FIO_PROC"    , "1"+Substr(FIO->FIO_PROC,2)} }

    If DuplicReg("FIO",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("FIO",.F.)
        FIO->FIO_FILIAL := StrTran(cUNAtu,"0","X")
        MsUnLock()
    else
        lRet := .F.
    EndIf

    RestArea(aArea)

Return(lRet)


/*/{Protheus.doc} ProcFWV
Funcao para duplicar registros FWV 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcFWV(cUNAtu,cUNNova,nRecReg)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    Local aCposAlt  :=  {}

    DbSelectArea("FWV")
    FWV->(DbGoto(nRecReg))

    aCposAlt := { 	{ "FWV_FILIAL"  , cUNNova }  ,; // Codigo da filial que recebera o titulo
                    { "FWV_PROC"    , "1"+SUBSTR(FWV->FWV_PROC,2)} }
                    
    If DuplicReg("FWV",aCposAlt) > 0
	    // Atualiza a filial na filial origem, para não perder o registro.
        RecLock("FWV",.F.)
        FWV->FWV_FILIAL := StrTran(cUNAtu,"0","X")
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
