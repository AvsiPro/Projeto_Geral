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
                            If aProdPai[nPosP,02] > aRet[nW,nCont,nX,nJ,18] //4
                                aProdPai[nPosP,02] := aRet[nW,nCont,nX,nJ,18] //4
                            Else 
                                aRet[nW,nCont,nX,nJ,1] := .F.
                            EndIf 
                        Else    
                            Aadd(aProdPai,{substr(aRet[nW,nCont,nX,nJ,3],1,8),aRet[nW,nCont,nX,nJ,18]}) //4
                        EndIf 
                    EndIf
                Next nJ
            Next nX

        
            Aeval(aProdPai,{|x| nSoma+= x[2]})

            aRet[nW,nCont,1,7] := nSoma
        EndIf 
    Next nCont 
Next nW 

aProdPai := {}
For nW := 1 to len(aRet)
    //Soma para itens derrotados que o fornecedor não tenha nenhum item com medalha
    For nCont := 1 to len(aRet[nW])
        If len(aRet[nW,nCont,1]) > 6
            nSoma := 0
            If aRet[nW,nCont,1,7] == 0
                For nX := 2 to len(aRet[nW,nCont])
                    For nJ := 1 to len(aRet[nW,nCont,nX])
                        If !aRet[nW,nCont,nX,nJ,1]
                            nPosP := Ascan(aProdPai,{|x| alltrim(x[1]) == substr(aRet[nW,nCont,nX,nJ,3],1,8)})
                            If nPosP > 0
                                If aProdPai[nPosP,02] > aRet[nW,nCont,nX,nJ,18] //4
                                    aProdPai[nPosP,02] := aRet[nW,nCont,nX,nJ,18] //4
                                EndIf 
                            Else    
                                Aadd(aProdPai,{substr(aRet[nW,nCont,nX,nJ,3],1,8),aRet[nW,nCont,nX,nJ,18],.F.}) //4
                            EndIf 
                        EndIf 
                    Next nJ
                Next nX

                Aeval(aProdPai,{|x| nSoma+= If(!x[3],x[2],0)})

                aRet[nW,nCont,1,7] := nSoma
            EndIf 
        EndIf 
    Next nCont
Next nW 

Return aRet
