#INCLUDE "PROTHEUS.CH"
User Function  SF2460I()

Local aArea :=  GetArea()
Local aPV   :=  {}
Local nCont :=  0
Local lFaturado := .F.
Local lPodeExcluir := .F.
Local nTotFat   :=  0
Local nVlrFat   :=  0


DbSelectArea("SD2")
DbSetOrdeR(3)
DbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

While !EOF() .AND. SD2->D2_FILIAL == SF2->F2_FILIAL .AND. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
    nTotFat += SD2->D2_QUANT
    nVlrFat += SD2->D2_TOTAL

    If Ascan(aPV,{|x| Alltrim(x) == Alltrim(SD2->D2_PEDIDO)}) == 0
        Aadd(aPV,SD2->D2_PEDIDO)
    EndIf 
    Dbskip()
EndDo

If len(aPV) > 0
    For nCont := 1 to len(aPV)
        SC6->( dbSeek( SF2->F2_FILIAL + aPV[nCont] ) )
        while !SC6->(EOF()) .AND. SC6->C6_FILIAL == SF2->F2_FILIAL .AND. SC6->C6_NUM == aPV[nCont]
            
            lFaturado := (SC6->C6_QTDENT > 0)
            
            // se há faturamento, o item do pedido não pode ser eliminado residuo!
            if lFaturado
                lPodeExcluir := .F.
            Else
                lPodeExcluir := .T.
            endif

            // se não foi faturado eliminar o resíduo do item
            if lPodeExcluir 
                MaResDoFat()
            endif

            SC6->( dbSkip() )
        enddo
        
        SC5->( dbSeek( SF2->F2_FILIAL + aPV[nCont] ) )
        Reclock("SC5",.F.)
        SC5->C5_XQTDNF := nTotFat
        SC5->C5_XTOTNF := nVlrFat
        SC5->(Msunlock())
    Next nCont
EndIf 

RestArea(aArea)

Return()
