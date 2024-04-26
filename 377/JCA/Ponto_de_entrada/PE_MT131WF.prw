#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na geração da cotação

    utilizado para marcar os produtos pai na solicitação de compra
    como encerrados, pois estes não entram na cotação.
*/

USER FUNCTION MT131WF()

Local aArea := GetArea()
Local cSol  := SC1->C1_NUM
//LOCAL aRet  := ParamIXB[1] 
LOCAL aRet2 := ParamIXB[2]   
Local lGerou:= .F.
Local nCont := 0

For nCont := 1 to len(aRet2)
    If !Empty(aRet2[nCont])
        lGerou := .T.
        exit
    Endif 
Next nCont

If lGerou
    DbSelectArea("SC1")
    Dbgotop()
    If Dbseek(xFilial("SC1")+cSol)
        While !EOF() .AND. SC1->C1_NUM == cSol 
            cProdPai := Posicione("SB1",1,xFilial("SC1")+SC1->C1_PRODUTO,"B1_XCODPAI")
            If Empty(cProdPai) .AND. EMPTY(SC1->C1_COTACAO)
                Reclock("SC1",.F.)
                SC1->C1_COTACAO := 'XXX'
                SC1->(Msunlock())
            Endif 
            Dbskip()
        EndDo 
    EndIF 
EndIf 

RestArea(aArea)

Return Nil 
