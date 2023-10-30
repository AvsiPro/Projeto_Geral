#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para validação de linhas da solicitação
    MIT 44_COMPRAS_COM011 _ Tipos de solicitação de compras
    
    Doc Mit
    https://docs.google.com/document/d/1ESMwrvQ37rSRT1_DmEgjO9yVyINOCblA/edit
    Doc Entrega
    https://docs.google.com/document/d/1WLVRJPTqv6ou7Q4bhUW5dIJZCuDqy2v8/edit
    
*/
User Function  MT110LOK()

Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
Local nPosItem   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ITEM'})
Local nPosTpCt   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XTIPCOT'})
Local nPosQtd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_QUANT'})
Local nPosQtO    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_QTDORIG'})
Local lValido    := .T.
Local lPrdPai    := Empty(Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosPrd],"B1_XCODPAI"))
Local nCont      := 1
Local lQtdAlt    := aCols[n,nPosQtd] <> aCols[n,nPosQtO]

If !lPrdPai 
    cProdPai := Posicione("SB1",1,xFilial("SB1")+aCols[n,nPosPrd],"B1_XCODPAI") 
    nPosPai := Ascan(aCols,{ |x| alltrim(x[nPosPrd]) == alltrim(cProdPai)})
    If nPosPai > 0
        lQtdPai := aCols[nPosPai,nPosQtd] <> aCols[n,nPosQtd]
        If lQtdPai .And. lQtdAlt
            lValido := .F.
            nPosTpCt := 0
            MsgAlert("Não é permitido alterar a quantidade dos produtos filhos","PE_MT110LOK")
        EndIf 
    Else 
        lValido := .F.
        nPosTpCt := 0
        MsgAlert("Produto pai não encontrado na solicitação de compra","PE_MT110LOK")
    EndIf 

EndIf 

If nPosTpCt > 0
    dbSelectArea('SC1')
    dbSetOrder(2)
    For nCont := 1 to len(aCols)
        If MsSeek(xFilial('SC1')+aCols[nCont][nPosPrd]+cA110Num+aCols[nCont][nPosItem])
            If Empty(aCols[nCont][nPosTpCt]) 
                aCols[nCont][nPosTpCt] := cvaltochar(nEditS)
            EndIf 
            
            If lPrdPai .And. lQtdAlt
                If Alltrim(Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosPrd],"B1_XCODPAI")) == alltrim(aCols[n,nPosPrd])
                    aCols[nCont,nPosQtd] := aCols[n,nPosQtd]
                EndIf 
            EndIf
        EndIf 
    Next nCont
EndIf

Return(lValido) 
