#INCLUDE 'PROTHEUS.CH'

User function MT160WF

Local aArea     := GetArea()
Local cCotacao  := Paramixb[1]
Local cPedido   := SC7->C7_NUM

DbSelectArea("SC8")
DbSetOrder(1)
If DbSeek(xFilial("SC8")+cCotacao+SC8->C8_FORNECE+SC8->C8_LOJA+'0001')
    While !EOF() .And. SC8->C8_FILIAL == xFilial("SC8") .And. SC8->C8_NUM == cCotacao 
        If Empty(SC8->C8_NUMPED)
            Reclock("SC8",.F.)
            SC8->C8_NUMPED := cPedido
            SC8->(MSUNLOCK())
        EndIf 
        Dbskip()
    EndDo 
EndIf 

RestArea(aArea)

Return
