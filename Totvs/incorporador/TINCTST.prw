#INCLUDE 'TOTVS.CH'

User Function INCTST1(cPar)
    Local aPar      := {}
    Local cIdProc   := ""
    Local cCodRot   := ""
    Local aArea     := GetArea()
    Local aAreaPGG  := PGG->(GetArea())
    Local aAreaPGH  := PGH->(GetArea())
    Local cChave    := ""
    
    Local nC        := 0
    Local cAlias    := "TST"
    Local cQuery    := "select * from..."
    Local nRecno    := 0
    Local aPergunte := {}
    Local cPerg02   := ""

    Private lAbortPrint := .F.

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

    // Pergunta de confirmação da execução
    /*
    If U_TIncISX1(cCodRot, aPergunte, "01") <> 1
        RecLock("PGH", .F.)
        PGH->PGH_OBS := AllTrim(PGH->PGH_OBS) + "Carga de Registros Cancelada pela pergunta 01" + CRLF
        MsUnLock()
        Return
    ElseIF (cPerg02 := U_TIncISX1(cCodRot, aPergunte, "02")) <> ""
        RecLock("PGH", .F.)
        PGH->PGH_OBS := AllTrim(PGH->PGH_OBS) + "Pergunta 02: " + cPerg02 + CRLF
        MsUnLock()
    EndIF
*/
    For nc := 1 to 100
 	
        If ! IsBlind()
            IncProc("processando  " + Str(nc, 3)   )
            ProcessMessage()
        EndIf

		If lAbortPrint
			exit
        Endif 
        
        cChave := "Documento " + Strzero(nc, 3) 
        nRecno := nc
        u_TILogNew(cIdProc, cCodRot, cChave, cQuery, cAlias, nRecno)
        
    End

    
    RestArea(aAreaPGH)
    RestArea(aAreaPGG)
    RestArea(aArea)

Return 



User Function INCTST2(cPar)
    Local cUNAtu      := ""
    Local cUNNova     := ""
    Local cMsg        := ""  

    Local cId         := ""
    Local cCodRot     := ""
    Local cChave      := ""
    Local lSimula     := .F.
    Local aPar        := {}
    Local aPergunte   := {}
    Local cPerg       := ""
    Local lSemInc     := .F.
    
    FWJsonDeserialize(cPar, @aPar)
    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]
    /*
    If Len(aPar) > 4
        aPergunte := aPar[5]
        cPerg := U_TIncISX1(cCodRot, aPergunte, "01")
        lSemInc := U_TIncISX1(cCodRot, aPergunte, "02") == 1
    EndIF    
*/
    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGG") + cId ))

    cUNAtu  := PGG->PGG_FILORI
    cUNNova := PGG->PGG_FILDES
    
    U_TILogBegin(cId, cCodRot, cChave, lSimula)

    If ! ValidInc(cId, cCodRot, cChave, lSimula, @cMsg, lSemInc)
        U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
        Return "Erro "
    EndIf 

    Sleep(2000)
    Begin Transaction

        If ! lSimula 

            AtuParte1(cId, cCodRot, cChave)
            AtuParte2(cId, cCodRot, cChave)
            AtuParte3(cId, cCodRot, cChave)
            
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

Static Function ValidInc(cId, cCodRot, cChave, lSimula, cMsg, lSemInc)
    Local lRet := .t.

    If Right(Alltrim(cChave), 3) ==  "011" .And. ! lSemInc
        lRet := .F.
        cMsg := "Não pode ser 011"
    Else 

        u_TILogMsg(cId, cCodRot, cChave, "Validação OK")
        cMsg := ""
    EndIf 
    // faz todas as validações necessarias  e atualiza cMsg que é passado como referencia
    

Return  lRet 

Static Function AtuParte1(cId, cCodRot, cChave)

    u_TILogMsg(cId, cCodRot, cChave, "Atualizando parte1")

    //...

Return 


Static Function AtuParte2(cId, cCodRot, cChave)
    
    u_TILogMsg(cId, cCodRot, cChave, "Atualizando parte2")

    //...

Return 

Static Function AtuParte3(cId, cCodRot, cChave)

    u_TILogMsg(cId, cCodRot, cChave, "Atualizando parte3")

    //...

Return 
