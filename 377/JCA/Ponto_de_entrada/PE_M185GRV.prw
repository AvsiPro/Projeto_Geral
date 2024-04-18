#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na baixa de requisição ao armazém
    Localização: Function A185Gera(Gera requisicoes.) e A185GeraAut(Gera as requisicoes usando o Movimentos Modelo 2).

    Em que ponto: E chamado apos a gravação de todos os dados, inclusive apos gerar a requisição no arquivo de movimentos internos (SD3).

*/
User Function M185GRV() 
Local lRet := .T.    
Local aAux1 := If(Funname()=="MATA185",aDadosCQ,{})
Local aAux2 := {}
Local nCont := 0
//Local lAux2 := .F.

DbSelectArea("SCP")

If Funname() == "MATA185"
    /*
    nSaldo := SaldoSB2()

    If nSaldo < SCP->CP_QUANT
        lAux2 := .T.
    EndIf 
    If nPosD3 > 0
        lAux2 := ((aAutoSD3[nPosD3,02] - SCP->CP_QUANT) * (-1)) <> 0
    Else 
        lAux2 := ((aAutoSCP[5,2] - SCP->CP_QUANT) * (-1)) <> 0
    Endif
    

    If lAux2  
        Aadd(aAux2,{ SCP->CP_PRODUTO,;
                    Posicione("SB1",1,xFilial("SB1")+SCP->CP_PRODUTO,"B1_DESC"),;
                    SCP->CP_QUANT,;
                    (nSaldo - SCP->CP_QUANT) * (-1),;
                    "",;
                    "",;
                    SCP->(Recno())})
    EndIf 
Else */
    For nCont := 1 to len(aAux1)
        Dbgoto(aAux1[nCont,21])
        If SCP->CP_QUANT > aAux1[nCont,09]
            Aadd(aAux2,{aAux1[nCont,04],;
                        aAux1[nCont,05],;
                        SCP->CP_QUANT,;
                        (aAux1[nCont,09] - SCP->CP_QUANT) * (-1),;
                        "",;
                        "",;
                        aAux1[nCont,21]})
        Endif 
    Next nCont 
EndIf

If len(aAux2) > 0
    U_JGENX006(aAux2)
EndIf 

Return(lRet)


