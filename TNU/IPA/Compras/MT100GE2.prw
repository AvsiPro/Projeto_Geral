#Include 'Protheus.ch'
/*
    Ponto de entrada documento de entrada no momento da criação do titulo a pagar
    Quando vencimento - emissão for menor que 8, jogar emissão + 8 no vencimento.
    Alexandre Venancio 10/06/2025 TNU
*/
User Function MT100GE2()

Local nOpc      := PARAMIXB[2]
Local nDiasVct  := Alltrim(SuperGetMV("TI_DIAVCT",.F.,"8"))
Local nPosPc    := Ascan(aHeader,{|x| alltrim(x[2]) == "D1_PEDIDO"})
Local nCont 
Local cPedido   := ''
Local cBarra    := ''

If nOpc == 1
    If SE2->E2_VENCTO - SE2->E2_EMISSAO < VAL(nDiasVct)
        SE2->E2_VENCTO := SE2->E2_EMISSAO + VAL(nDiasVct)
        SE2->E2_VENCREA:= datavalida(SE2->E2_VENCTO)
    EndIf 

    If nPosPc > 0
        For nCont := 1 to len(aCols)
            If !Empty(aCols[nCont,nPosPc])
                cPedido += cBarra + aCols[nCont,nPosPc]

                cBarra := "/"
            Endif
        Next nCont 

        If !Empty(cPedido)
            SE2->E2_HIST := 'PEDIDO DE COMPRA '+cPedido
        ENDiF 
    EndIf 
Endif

Return
