#INCLUDE 'PROTHEUS.CH'
/////////////////////////////////////////////////////////////////////////////////
//    Ponto de entrada na rotina de contas a pagar                             // 
//    inclusao                                                                 // 
//    Utilizado para não permitir inclusão de titulo com centro de custo vazio //
//   para contas contabeis iniciadas em 4 ou 5                                 // 
/////////////////////////////////////////////////////////////////////////////////
// Rodrigo Gomes - 06/05/24 = inclusão linhas 15 a 17                          // 
// Alexandre Venancio - 07/05/24 - nao bloquear notas importadas por xml       //
/////////////////////////////////////////////////////////////////////////////////

User Function FA050INC

Local aArea :=  GetArea()
Local lRet  :=  .T.

If FunName() == "GPEM670"
    lRet  := .T.
Else 
    If FunName() <> "COMXCOL"
        If substr(M->E2_CONTAD,1,1) $ '4/5' .And. !'GLB' $ M->E2_PREFIXO
            If Empty(M->E2_CCUSTO)
                MsgAlert("Para contas contábeis iniciadas em ( 4 ou 5 ) o campo Centro de Custo é de preenchimento obrigatório")
                lRet := .F.
            EndIf 
        Endif 
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)
