#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para validação de linhas da solicitação
    MIT 44_COMPRAS_COM011 _ Tipos de solicitação de compras
    
    Doc Mit
    https://docs.google.com/document/d/1ESMwrvQ37rSRT1_DmEgjO9yVyINOCblA/edit
    Doc Entrega
    https://docs.google.com/document/d/1WLVRJPTqv6ou7Q4bhUW5dIJZCuDqy2v8/edit
    
*/

User Function JCOMG005

Local nCont 
Local nRet       := M->C1_QUANT
Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local cCodPai    := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosPrd],"B1_XCODPAI")
Local nPosQtd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_QUANT'})
Local lPrdPai    := Empty(cCodPai)
Local nPosQtO    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_QTDORIG'})
Local nPaiCols   := Ascan(aCols,{|x| Alltrim(x[nPosPrd]) == Alltrim(cCodPai)})
Local lQtdAlt    := aCols[n,nPosQtd] <> aCols[n,nPosQtO]

If Altera
    //Solicitado pelo Caio em 20/12 para permitir incluir produtos filhos na solicitação quando o pai nao estiver.
    If (!lPrdPai .And. nPaiCols > 0) .or. lPrdPai

    //Else 
        If lQtdAlt .AND. !lPrdPai
            MsgAlert("Somente pode ser alterada a quantidade do produto pai","JCOMG005")
            aCols[n,nPosQtd] := aCols[n,nPosQtO]
            M->C1_QUANT      := aCols[n,nPosQtO]
            nRet             := aCols[n,nPosQtO]
        Else 
            For nCont := 1 to len(aCols)
                If Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosPrd],"B1_XCODPAI")) == alltrim(aCols[n,nPosPrd])
                    aCols[nCont,nPosQtd] := aCols[n,nPosQtd]
                EndIf 
            Next nCont
        EndIf
    EndIF 
ElseIf Inclui
    For nCont := 1 to len(aCols)
        If Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosPrd],"B1_XCODPAI")) == alltrim(aCols[n,nPosPrd])
            aCols[nCont,nPosQtd] := aCols[n,nPosQtd]
        EndIf 
    Next nCont
EndIf

Return(nRet)
