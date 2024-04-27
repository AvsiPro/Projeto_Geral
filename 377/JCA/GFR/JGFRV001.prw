#INCLUDE 'PROTHEUS.CH'

/*
    Validação do campo TQN_QTDARL

    Trabalha com conjunto com o COMB006 para validação do ARLA digitado no abastecimento

*/

User Function JGFRV001

Local aArea := GetArea()
Local lRet  := .T.
Local nSaldo 

If M->TQN_QTDARL <> 0
    If !Empty(M->TQN_ZPRARL)
        DbSelectArea("SB2")
        DbSetOrder(1)
        cLocPad := Posicione("SB1",1,xFilial("SB1")+M->TQN_ZPRARL,"B1_LOCPAD")
        If Dbseek(xFilial("SB2")+M->TQN_ZPRARL+cLocPad)
            nSaldo := SaldoSB2()

            If M->TQN_QTDARL > nSaldo 
                MsgAlert("Produto sem saldo para movimentação","JGFRV001")
                lRet := .F.
            EndIf 
        Else 
            MsgAlert("Produto sem saldo para movimentação","JGFRV001")
            lRet := .F.
        EndIf 
    Else 
        MsgAlert("Não preenchido o campo do produto ARLA","JGFRV001")
        lRet := .F.
    EndIf
EndIf 

RestArea(aArea)

Return(lRet)
