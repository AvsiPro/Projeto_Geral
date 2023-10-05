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
