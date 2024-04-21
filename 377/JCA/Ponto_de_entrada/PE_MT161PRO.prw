#INCLUDE 'PROTHEUS.CH'
#include "topconn.ch"
/*
    Ponto de entrada
    Ao clicar no botão Analisar cotações

    Utilizado para recalcular os valores das cotações considerando impostos
    e determinando o real vencedor após esse calculo.

    Doc Mit
    
    Doc Validação entrega
    
    
    
*/
User Function MT161PRO()

Local aPropostas    := PARAMIXB[1]
Local aRet          := aPropostas
Local nCont,nX,nJ,nW
Local nSoma         :=  0
Local aProdPai      := {}

//Zerar primeiro todas para verificar a vencedora de cada fornecedor
For nW := 1 to len(aRet)
    For nCont := 1 to len(aRet[nW])
        If len(aRet[nW,nCont,1]) > 0
            aRet[nW,nCont,1,7] := 0
        EndIf 
    Next nCont 
Next nW 

For nW := 1 to len(aRet)
    For nCont := 1 to len(aRet[nW])
        If len(aRet[nW,nCont,1]) > 6
            For nX := 2 to len(aRet[nW,nCont])
                For nJ := 1 to len(aRet[nW,nCont,nX])
                    aRet[nW,nCont,nX,nJ,1] := .F.
                    nPosP := Ascan(aProdPai,{|x| alltrim(x[1]) == substr(aRet[nW,nCont,nX,nJ,3],1,8)})
                    If nPosP > 0
                        If aProdPai[nPosP,02] > aRet[nW,nCont,nX,nJ,4] .And. aRet[nW,nCont,nX,nJ,4] > 0//18
                            aProdPai[nPosP,02] := aRet[nW,nCont,nX,nJ,4] //18
                            aProdPai[nPosP,03,01] := nW
                            aProdPai[nPosP,03,02] := nCont
                            aProdPai[nPosP,03,03] := nX
                            aProdPai[nPosP,03,04] := nJ
                        /*Else 
                            aRet[nW,nCont,nX,nJ,1] := .F.*/
                        EndIf 
                    Else    
                        If aRet[nW,nCont,nX,nJ,4] > 0
                            Aadd(aProdPai,{substr(aRet[nW,nCont,nX,nJ,3],1,8),;
                                                    aRet[nW,nCont,nX,nJ,4],;
                                                    {nW,nCont,nX,nJ}}) 
                        EndIf 
                    EndIf
                Next nJ
            Next nX 
        EndIf 
    Next nCont 
Next nW

For nW := 1 to len(aProdPai)
    If len(aProdPai[nW]) > 2
        aRet[aProdPai[nW,3,1],aProdPai[nW,3,2],aProdPai[nW,3,3],aProdPai[nW,3,4],1] := .T.
    EndIf 
Next nW 

aProdPai := {}

//Soma dos itens vencedores para atualizar o cabeçalho com itens de medalha
For nW := 1 to len(aRet)
    For nCont := 1 to len(aRet[nW])
        If len(aRet[nW,nCont,1]) > 6
            nSoma := 0
            aProdPai := {}
            For nX := 2 to len(aRet[nW,nCont])
                For nJ := 1 to len(aRet[nW,nCont,nX])
                    If aRet[nW,nCont,nX,nJ,1]

                        nPosP := Ascan(aProdPai,{|x| alltrim(x[1]) == substr(aRet[nW,nCont,nX,nJ,3],1,8)})
                        If nPosP > 0
                            If aProdPai[nPosP,02] > aRet[nW,nCont,nX,nJ,4] .And. aRet[nW,nCont,nX,nJ,4] > 0//18
                                aProdPai[nPosP,02] := aRet[nW,nCont,nX,nJ,4] //18
                            /*Else 
                                aRet[nW,nCont,nX,nJ,1] := .F.*/
                            EndIf 
                        Else    
                            Aadd(aProdPai,{substr(aRet[nW,nCont,nX,nJ,3],1,8),aRet[nW,nCont,nX,nJ,4]}) //18
                        EndIf 
                    EndIf
                Next nJ
            Next nX

        
            Aeval(aProdPai,{|x| nSoma+= x[2]})

            aRet[nW,nCont,1,7] := nSoma
        EndIf 
    Next nCont 
Next nW 


For nW := 1 to len(aRet)
    //Soma para itens derrotados que o fornecedor não tenha nenhum item com medalha
    aProdPai := {}
    For nCont := 1 to len(aRet[nW])
        If len(aRet[nW,nCont,1]) > 6
            nSoma := 0
            If aRet[nW,nCont,1,7] == 0
                For nX := 2 to len(aRet[nW,nCont])
                    For nJ := 1 to len(aRet[nW,nCont,nX])
                        If !aRet[nW,nCont,nX,nJ,1]
                            nPosP := Ascan(aProdPai,{|x| alltrim(x[1]) == substr(aRet[nW,nCont,nX,nJ,3],1,8)})
                            If nPosP > 0
                                If aProdPai[nPosP,02] > aRet[nW,nCont,nX,nJ,4] .And. aRet[nW,nCont,nX,nJ,4] > 0 //18
                                    aProdPai[nPosP,02] := aRet[nW,nCont,nX,nJ,4] //18
                                EndIf 
                            Else    
                                Aadd(aProdPai,{substr(aRet[nW,nCont,nX,nJ,3],1,8),aRet[nW,nCont,nX,nJ,4],.F.}) //18
                            EndIf 
                        EndIf 
                    Next nJ
                Next nX

                Aeval(aProdPai,{|x| nSoma+= If(!x[3],x[2],0)})

                aRet[nW,nCont,1,7] := nSoma

                aProdPai := {}
            EndIf 
        EndIf 
    Next nCont
Next nW 

Return aRet
