#INCLUDE 'PROTHEUS.CH'
/*
    Gatilhar o campo com quantidade na atualização de cotações
    MIT 44_COMPRAS_COM010 - Histórico de Renegociações com Fornecedor - processo cotação

    Doc Mit
    https://docs.google.com/document/d/16xzLf8aK-K80MuSAq9ejX0ExjPrX7efc/edit
    Doc Entrega
    https://docs.google.com/document/d/1JhdsRjmUgZ7KhZ0-5UaWeBTaWKrNXyRu/edit
    
*/
User Function JCOMG003

Local aArea := GetArea()
Local nRet  := M->C8_XQTDATU
Local nPosV := Ascan(aHeader,{|x| Alltrim(x[2]) == "C8_PRECO"})
Local nPosT := Ascan(aHeader,{|x| Alltrim(x[2]) == "C8_TOTAL"})
Local nPosQ := Ascan(aHeader,{|x| Alltrim(x[2]) == "C8_QUANT"})

M->C8_QUANT := nRet 

aCols[n,nPosQ] := nRet
aCols[n,nPosT] := aCols[n,nPosQ] * aCols[n,nPosV]

RestArea(aArea)

Return(nRet)
