#INCLUDE 'PROTHEUS.CH'

/*
    Gatilho campos de quantidades
*/
User Function GATRRS01(npocg)

Local aArea :=  GetArea()
Local nRet  :=  If(npocg==1,M->C7_QUANT,IF(npocg==2,M->C7_QTSEGUM,M->C7_QTDSEQ))
Local nFatConv := ''
Local nVlrConv := 0
Local nPosPr    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_PRODUTO"})
Local nPosQ1    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_QUANT"})
Local nPosQ2    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_QTSEGUM"})
Local nPosQ3    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_QTDSEQ"})
Local nPosP1    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_PRCSEQ"})
Local nPosP2    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_PRECO"})
Local nPosP3    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})
Local nQuantCx  :=  0

DbselectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+aCols[n,nPosPr])

nFatConv := SB1->B1_TIPCONV
nVlrConv := SB1->B1_CONV

If nFatConv == "D"

    If SB1->B1_UM == "DZ" 
        If npocg == 1
            aCols[n,nPosQ2] := aCols[n,nPosQ1] / nVlrConv 
            aCols[n,nPosQ3] := aCols[n,nPosQ1] * 12
        ElseIf npocg == 2

            aCols[n,nPosQ1] := nVlrConv * aCols[n,nPosQ2]
            aCols[n,nPosQ3] := aCols[n,nPosQ1] * 12
            
        ElseIf npocg == 3
            aCols[n,nPosQ1] := aCols[n,nPosQ3] / 12 
            
            nQuantCx := nVlrConv * 12
            
            aCols[n,nPosQ2] := aCols[n,nPosQ3] / nQuantCx

            
        EndIf

        If aCols[n,nPosP1] > 0
            aCols[n,nPosP2] := aCols[n,nPosP1] * 12
            aCols[n,nPosP3] := aCols[n,nPosP2] * aCols[n,nPosQ1]
        EndIf
        
    ENDIF 
    
ENDIF

RestArea(aArea)

Return(nRet)

/*
    Gatilhos de preços
*/
User Function GATRRS02(npocg)

Local aArea :=  GetArea()
Local nRet  := 0
Local nPosQ1    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_QUANT"})
Local nPosP1    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_PRCSEQ"})
Local nPosP2    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_PRECO"})
Local nPosP3    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})

If aCols[n,nPosP1] > 0
    aCols[n,nPosP2] := aCols[n,nPosP1] * 12
    aCols[n,nPosP3] := aCols[n,nPosP2] * aCols[n,nPosQ1]
    nRet := aCols[n,nPosP1]
EndIf

RestArea(aArea)

Return(nRet)
