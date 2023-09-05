#INCLUDE 'PROTHEUS.CH'

User Function  MT110LOK()

Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nPosItem   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ITEM'})
Local nPosTpCt   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XTIPCOT'})
Local lValido    := .T.
Local nCont      := 1

If nPosTpCt > 0
    dbSelectArea('SC1')
    dbSetOrder(2)
    For nCont := 1 to len(aCols)
        If MsSeek(xFilial('SC1')+aCols[nCont][nPosPrd]+cA110Num+aCols[nCont][nPosItem])
            aCols[nCont][nPosTpCt] := cvaltochar(nEditS)
        EndIf 
    Next nCont
EndIf

Return(lValido) 
