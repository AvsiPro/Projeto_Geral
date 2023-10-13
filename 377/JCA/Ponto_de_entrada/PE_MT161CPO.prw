#INCLUDE "PROTHEUS.CH"
 
User Function MT161CPO()
 
Local aPropostas := PARAMIXB[1] // Array com os dados das propostas dos Fornecedores
Local aItens     := PARAMIXB[2] // Array com os dados da grid "Produtos"
Local aCampos    := {"C8_QUANT"} // Array com os campos adicionados na grid "Item da Proposta"
Local aCposProd  := {"C8_QTSEGUM","C8_SEGUM"} // Array com os campos adicionados na grid "Produtos"
Local aRetorno   := {}
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nCount     := 0
Local aAreaSC8   := SC8->(GetArea())
 
For nX := 1 To Len(aPropostas)
    For nY := 1 To Len(aPropostas[nX])
        For nZ := 1 To Len(aPropostas[nX][nY][2])
            nCount++
 
            //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO
            If Len(aPropostas[nX][nY][1]) > 0
                cTexto := Posicione("SC8",1,SC8->(C8_FILIAL+C8_NUM)+aPropostas[nX][nY][1][1]+aPropostas[nX][nY][1][2]+aPropostas[nX][nY][2][nZ][2]+aPropostas[nX][nY][2][nZ][12], "C8_QUANT")
                AADD(aPropostas[nX][nY][2][nZ], cTexto)
                /*cTexto := Posicione("SC8",1,SC8->(C8_FILIAL+C8_NUM)+aPropostas[nX][nY][1][1]+aPropostas[nX][nY][1][2]+aPropostas[nX][nY][2][nZ][2]+aPropostas[nX][nY][2][nZ][12], "C8_PRECO")
                AADD(aPropostas[nX][nY][2][nZ], cTexto)*/
            Else
                AADD(aPropostas[nX][nY][2][nZ],0)
            EndIf
        Next nZ
    Next nY
Next nX
 
 
For nX := 1 To Len(aItens)
    //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO
    AADD(aItens[nX], Posicione("SC8",1,SC8->(C8_FILIAL+C8_NUM)+aItens[nX][10]+aItens[nX][11]+aItens[nX][12]+aItens[nX][13], "C8_QTSEGUM"))
    AADD(aItens[nX], Posicione("SC8",1,SC8->(C8_FILIAL+C8_NUM)+aItens[nX][10]+aItens[nX][11]+aItens[nX][12]+aItens[nX][13], "C8_SEGUM"))
Next nX

AADD(aRetorno, aPropostas)
AADD(aRetorno, aCampos)
AADD(aRetorno, aItens)
AADD(aRetorno, aCposProd)
 
RestArea(aAreaSC8)
 
Return aRetorno
