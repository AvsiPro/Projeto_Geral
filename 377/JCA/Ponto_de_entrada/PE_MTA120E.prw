#INCLUDE 'PROTHEUS.CH'

User Function MTA120E()

Local ExpN1 := PARAMIXB[1]
//Local ExpC1 := PARAMIXB[2]
Local ExpL1 := .T.
Local cNumCot   := SC7->C7_NUMCOT 

If ExpN1 == 1
     

    If !Empty(cNumCot)
        DbSelectArea("SC8")
        DbSetOrdeR(1)
        If Dbseek(xFilial("SC8")+cNumCot+SC7->C7_FORNECE+SC7->C7_LOJA+'0001')
            While !EOF() .AND. SC8->C8_FILIAL == xFilial("SC8") .AND. SC8->C8_NUM == cNumCot
                If SC8->C8_NUMPED == SC7->C7_NUM 
                    Reclock("SC8",.F.)
                    SC8->C8_NUMPED := SPACE(6)
                    SC8->C8_ITEMPED:= SPACE(4)
                    SC8->(MSUNLOCK())
                EndIf 
                Dbskip()
            EndDo
        EndIf 
    EndIf 

EndIf 

Return (ExpL1) 
