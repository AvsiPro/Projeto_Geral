#INCLUDE 'PROTHEUS.CH'

User Function MTA120E()

Local ExpN1 := PARAMIXB[1]
//Local ExpC1 := PARAMIXB[2]
Local ExpL1 := .T.
Local cNumCot   := SC7->C7_NUMCOT 
Local nNumSc    := SC7->C7_NUMSC

//If ExpN1 == 1
     

    If !Empty(cNumCot)
        DbSelectArea("SC8")
        DbSetOrdeR(1)
        DbGotop()
        If Dbseek(xFilial("SC8")+cNumCot)
            While !EOF() .AND. SC8->C8_FILIAL == xFilial("SC8") .AND. SC8->C8_NUM == cNumCot
                If SC8->C8_NUMPED == SC7->C7_NUM .OR. Alltrim(SC8->C8_NUMPED) == 'XXXXXX' 
                    Reclock("SC8",.F.)
                    SC8->C8_NUMPED := SPACE(6)
                    SC8->C8_ITEMPED:= SPACE(4)
                    SC8->C8_NUMCON := SPACE(15)
                    SC8->(MSUNLOCK())
                EndIf 
                Dbskip()
            EndDo
        EndIf 

        DbSelectArea("SCE")
        DbSetOrDer(1)
        If Dbseek(xFilial("SCE")+cNumCot)
            While !EOF() .AND. SCE->CE_FILIAL == xFilial("SCE") .and. SCE->CE_NUMCOT == cNumCot
                Reclock("SCE",.F.)
                Dbdelete()
                SCE->(Msunlock())
                Dbskip()
            EndDo 
        EndIf 

        If !Empty(nNumSc)
            DbSelectArea("SC1")
            DbSetOrder(1)
            If Dbseek(xFilial("SC1")+nNumSc)
                While !EOF() .AND. SC1->C1_FILIAL == xFilial("SC1") .AND. SC1->C1_NUM == nNumSc
                    Reclock("SC1",.F.)
                    SC1->C1_PEDIDO := SPACE(6)
                    SC1->C1_ITEMPED:= SPACE(4)
                    SC1->C1_QUJE   := 0
                    SC1->C1_FORNECE:= SPACE(6)
                    SC1->C1_LOJA   := SPACE(4)
                    SC1->(MSUNLOCK())
                    DBSKIP()
                ENDDO
            EndIf
        EndIf 
    EndIf 


//EndIf 

Return (ExpL1) 
