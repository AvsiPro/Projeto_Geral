#INCLUDE 'TOTVS.CH'


//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCCTB
Rotina para transferir o CTB de uma filial para outra

@author		Alexandre Venancio
@since		01/10/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCCTB1(cPar)
Local aPar      := {}
Local cIdProc   := ""
Local cCodRot   := ""
Local cUNAtu    := ""
Local aArea     := GetArea()
Local aAreaPGG  := PGG->(GetArea())
Local aAreaPGH  := PGH->(GetArea())
Local cChave    := ""
Local cQueryCTB := ""
Local nQtdReg   := 0
Local aPergunte := {}
Local dDtCorte  :=  ctod(" / /")
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
    
    dDtCorte := STOD(DTOS(U_TIncISX1(cCodRot, aPar[3], "01")+31))

    cCTB := TransfCtb(cUNAtu, @cQueryCTB, dDtCorte)

    If Empty(cCTB)
        MsgAlert("Não existem registros de Mov CTB CR" + cUNAtu)
        Return 
    EndIf 

    While  (cCTB)->(! Eof())
        
        nQtdReg   := (cCTB)->QTDREG

        If ! IsBlind()
            IncProc("Gerando Log PHK: " + cQueryCTB)
            ProcessMessage()
        EndIf
        If lAbortPrint
            exit
        Endif 

        cChave :=  cvaltochar(nQtdReg)

        u_TILogNew(cIdProc, cCodRot, cChave, cQueryCTB, "PHK", nQtdReg)

        (cCTB)->(DbSkip())
    End
    
    If Select(cCTB) > 0
        (cCTB)->(DBCloseArea())
    Endif
else
    MsgAlert("Não encontrado itens na tabela de De/Para da filial de origem - ZX5 tabela _INCDP")
EndIf

RestArea(aAreaPGH)
RestArea(aAreaPGG)
RestArea(aArea)


Return 

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} TransfCtb
Rotina para selecionar os Mov CTB CR                    

@author		Alexandre Venancio
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
Static Function TransfCtb(cUNAtu, cQueryCTB,dDtCorte)

Local cCTB      := GetNextAlias()
// Seleciona os Mov CTB CR                    
cQueryCTB := " "
cQueryCTB += " SELECT COUNT(*) QTDREG FROM " + RetSqlName("PHK") 
cQueryCTB += " WHERE PHK_FILIAL = '" + xFilial("PHK") +"'"
cQueryCTB += " AND PHK_UNINEG = '" + cUNAtu  + "'"
cQueryCTB += " AND PHK_CMPDIF >= '" + DTOS(dDtCorte) +"' AND D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQueryCTB), cCTB, .T., .F.)

If (cCTB)->(Eof())		
    (cCTB)->(DbCloseArea())
    Return ""
EndIf

Return cCTB



//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCCTB2
Rotina para Processar registros CTB                    

@author		Alexandre Venancio
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCCTB2(cPar)

    Local cUNAtu      := ""
    Local cUNNova     := ""
    Local nRecReg     := 0  

    Local cId         := ""
    Local cCodRot     := ""
    Local cChave      := ""
    Local lSimula     := .F.
    Local aPar        := {}
    Local cPerg       := ""
    Local cPreDest
    Local lRet        := .T.
    Local dDtCorte    := "" 
    Private cMsg        := ""
    
    FWJsonDeserialize(cPar, @aPar)
    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]
    
    dDtCorte := STOD(DTOS(U_TIncISX1(cCodRot, aPar[5], "01")+31))
    
    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGG") + cId ))

    cUNAtu  := PGG->PGG_FILORI
    cUNNova := PGG->PGG_FILDES
    nRecReg := PGI->PGI_RECORI

    U_TILogBegin(cId, cCodRot, cChave, lSimula)

    Begin Transaction

        If ! lSimula 
            lRet := ProcCTB(cUNAtu,cUNNova,nRecReg,cPreDest,dDtCorte)           
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

/*/{Protheus.doc} ProcCTB
Funcao para duplicar registros PSN 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function ProcCTB(cUNAtu,cUNNova,nRecReg,cPreDest,dDtCorte)

    Local aArea     :=  GetArea()
    Local lRet      :=  .T.
    
    Local cSQL      :=  ""

    cSQL := "UPDATE " + RetSqlName("PHK") + " SET PHK_UNINEG='" + cUNNova + "' WHERE PHK_FILIAL = '" + xFilial("PHK") +"' AND PHK_UNINEG = '" + cUNAtu  + "' AND PHK_CMPDIF >= '" + SubStr(dtos(dDtCorte),1,6) +"' AND D_E_L_E_T_ = ' ' "

	If (nError := TCSQLExec(cSQL)) <> 0
        lRet := .F.
        cMsg := AllTrim(Str(nError)) + "-" + TCSQLError()
    ENDIF

    cSQL := "UPDATE " + RetSqlName("PHL") + " SET PHL_UNINEG='" + cUNNova + "' WHERE PHL_FILIAL = '" + xFilial("PHL") +"' AND PHL_UNINEG = '" + cUNAtu  + "' AND PHL_CMPDIF >= '"+ SubStr(dtos(dDtCorte),1,6) +"' AND D_E_L_E_T_ = ' ' "

	If (nError := TCSQLExec(cSQL)) <> 0
        lRet := .F.
        cMsg := AllTrim(Str(nError)) + "-" + TCSQLError()
    ENDIF

    RestArea(aArea)

Return(lRet)
