#INCLUDE 'PROTHEUS.CH'
/*
    Solicitado pelo Caio em 20/12/23 para replicar o tipo de cotação
    para os filhos quando o pai for alterado.

    Doc Mit
    
    Doc Entrega
    
    
*/

User Function JCOMG006

Local nCont 
Local nRet       := M->C1_XTIPCOT
Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local cCodPai    := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosPrd],"B1_XCODPAI")
Local nPosTip    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XTIPCOT'})
Local nPosDat    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_DATPRF'})
Local lPrdPai    := Empty(cCodPai)
Local dDatPrf    := aCols[n,nPosDat]

If Altera
    //Solicitado pelo Caio em 20/12 para permitir incluir produtos filhos na solicitação quando o pai nao estiver.
    If lPrdPai

        For nCont := 1 to len(aCols)
            If Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosPrd],"B1_XCODPAI")) == alltrim(aCols[n,nPosPrd])
                aCols[nCont,nPosTip] := aCols[n,nPosTip]
                If Empty(cCodPai)
                    aCols[nCont,nPosDat] := dDatPrf
                EndIf 
            EndIf 
        Next nCont
    
    EndIF 
ElseIf Inclui
    For nCont := 1 to len(aCols)
        If Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosPrd],"B1_XCODPAI")) == alltrim(aCols[n,nPosPrd])
            aCols[nCont,nPosTip] := aCols[n,nPosTip]
        EndIf 
    Next nCont
EndIf

Return(nRet)
