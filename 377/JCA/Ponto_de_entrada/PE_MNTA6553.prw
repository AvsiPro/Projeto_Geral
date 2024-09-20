/*
    Ponto de entrada rotina MNTA655 Abastecimento manual
    
    Validar se o produto ARLA foi preenchido e a quantidade tambem.
*/

user function MNTA6553

Local lRet      := .T.
Local aArea     := GetArea()
Local aAreaTT8  := TT8->(GetArea("TT8"))

If !Empty(M->TQN_ZPRARL)
    If M->TQN_QTDARL == 0
        M->TQN_ZPRARL := ''
        lRet := .T.
    else
        
        dbSelectArea("TT8")
		dbSetOrder(2)
		        
       If ! dbSeek(xFilial("TT8")+ M->TQN_FROTA+'2'+M->TQN_ZPRARL)
            MsgAlert("Verique cadastro veículo, Aba COMBUSTIVEL, pois este aditivo não se encontra cadastrado","MNTA6553")
            lRet := .F.
       Else 
           If M->TQN_QTDARL > TT8->TT8_CAPMAX
                MsgAlert("Quantidade Arla informada é maior que a capacidade do tanque","MNTA6553")
                lRet := .F.
            Endif
        EndIf 
        
        RestArea(aAreaTT8)  
        RestArea(aArea)
       
    Endif
Else 
    If M->TQN_QTDARL > 0
        MsgAlert("Foi informado a quantidade para o ARLA, mas não foi informado o produto","MNTA6553")
        lRet := .F.
    EndIf 
Endif 

RestArea(aArea)

Return(lRet) 
