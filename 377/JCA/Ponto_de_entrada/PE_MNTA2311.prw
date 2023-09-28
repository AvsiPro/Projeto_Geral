#INCLUDE 'PROTHEUS.CH'

USER FUNCTION MNTA2311
//apos salvar  
//AARDELSTC - POSIC 2 BEM POSIC 13 PRODUTO SAIDA
LOCAL nCont := 1

For nCont := 1 to len(aArdelStc)
    DbSelectArea("ST9")
    DbSetOrder(1)
    If DbSeek(xFilial("ST9")+aArdelStc[nCont,02])
        Reclock("ST9",.F.)
        ST9->T9_CODESTO := aArdelStc[nCont,13]
        ST9->T9_LOCPAD  := Posicione("SB1",1,xFilial("SB1")+aArdelStc[nCont,13],"B1_LOCPAD")
    EndIf 
Next nCont 

RETURN




