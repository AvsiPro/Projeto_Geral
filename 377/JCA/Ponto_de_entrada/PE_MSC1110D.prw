#INCLUDE 'PROTHEUS.CH'

User Function MSC1110D() 

Local lExclui := .T.
Local nCont   := 0
Local nSaldP  := 0
Local nPosPrd := Ascan(aHeader,{|x| alltrim(x[2]) == "C1_PRODUTO"})
Local nPosQtd := Ascan(aHeader,{|x| alltrim(x[2]) == "C1_QUANT"})
Local nPosLoc := Ascan(aHeader,{|x| alltrim(x[2]) == "C1_LOCAL"})
Local cProdPai := ''

For nCont := 1 to len(aCols)
    dbSelectArea("SB2")
    dbSetOrder(1) // Filial + Produto + Local

    cProdPai := Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosPrd],"B1_XCODPAI")

    If !Empty(cProdPai)
        If SB2->(dbSeek( xFilial("SB2") + aCols[nCont,nPosPrd] + aCols[nCont,nPosLoc]) )
            //B2_QATU+B2_SALPEDI-B2_QPEDVEN
            nSaldP := SB2->B2_SALPEDI
            If aCols[nCont,nPosQtd] > nSaldP  
                Reclock("SB2",.F.)
                SB2->B2_SALPEDI := nSaldP + aCols[nCont,nPosQtd] 
                SB2->(Msunlock())
            EndIf
        EndIf 
    EndIf

Next nCont

Return (lExclui) 
