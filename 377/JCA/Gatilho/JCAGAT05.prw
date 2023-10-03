#INCLUDE 'PROTHEUS.CH'

User Function JCAGAT05

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
