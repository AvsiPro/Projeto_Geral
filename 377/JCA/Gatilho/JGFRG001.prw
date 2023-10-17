#INCLUDE 'PROTHEUS.CH'
/*
    Gatilho TQN_FROTA -> TQN_FROTA
    
    Doc Mit
    
    Doc Entrega
    
    
*/
User Function JGFRG001

Local aArea  := GetArea()
Local cBem   := M->TQN_FROTA
Local nPosOr := ascan(aHeader,{|x| x[2] == "TQG_ORDENA"})
Local nPosPr := ascan(aHeader,{|x| x[2] == "TT_CODIGO"})
Local nPosLc := ascan(aHeader,{|x| x[2] == "TL_LOCAL"})


If 'PRODUTO' $ UPPER(nLanca)
    If !Empty(cTroca)
        aCols[n,nPosOr] := "1"
    ElseIf !Empty(cReposicao)
        aCols[n,nPosOr] := "2"
    EndIf

    If nPosPr > 0
        aCols[n,nPosPr] := Posicione("TT8",2,xFilial("TT8")+cBem+'2',"TT8_CODCOM")
        
        aCols[n,nPosLc] := "01"
    EndIf 
    //tt_codigo - 00310001       
    //tqg_ordena  / TTA_SERTRO TTA_SERREP
    //TL_LOCAL
ENDIF

RestArea(aArea)

Return(cBem)
