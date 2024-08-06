#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na baixa de requisi��o ao armaz�m
    Localiza��o: Function A185Gera(Gera requisicoes.) e A185GeraAut(Gera as requisicoes usando o Movimentos Modelo 2).

    Em que ponto: E chamado apos a grava��o de todos os dados, inclusive apos gerar a requisi��o no arquivo de movimentos internos (SD3).

*/
User Function M185GRV() 
Local lRet := .T.    
Local aAux1 := If(Funname()=="MATA185",if(valtype("aDadosCQ")=="A",aDadosCQ,{}),{})
Local aAux2 := {}
Local nCont := 0
Local lLiga := SuperGetMV("TI_LIGVPR",.F.,.F.)
//lLiga colocado pois foi solicitado para retirar da baixa esta valida��o.
//como a regra j� mudou v�rias vezes, vou manter assim ao inv�s de retirar o fonte do rpo

If lLiga
    DbSelectArea("SCP")

    If Funname() == "MATA185"
        
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
EndIf 

Return(lRet)


