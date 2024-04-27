/*
    Ponto de entrada rotina MNTA655 Abastecimento manual
    
    Validar se o produto ARLA foi preenchido e a quantidade tambem.
*/

user function MNTA6553

Local aArea := GetArea()
Local lRet  := .T.


If !Empty(M->TQN_ZPRARL)
    If M->TQN_QTDARL == 0
        MsgAlert("N�o foi informado a quantidade para o ARLA","MNTA6553")
        lRet := .F.
    EndIf 
Else 
    If M->TQN_QTDARL > 0
        MsgAlert("Foi informado a quantidade para o ARLA, mas n�o foi informado o produto","MNTA6553")
        lRet := .F.
    EndIf 
Endif 

RestArea(aArea)

Return(lRet) 
