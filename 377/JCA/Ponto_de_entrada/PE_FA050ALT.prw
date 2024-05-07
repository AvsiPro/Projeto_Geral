#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na rotina de contas a pagar
    alteração
    Utilizado para não permitir inclusão de titulo com centro de custo vazio 
    para contas contabeis iniciadas em 4 ou 5

*/
User Function FA050ALT

Local aArea := GetArea()
Local lRet  := .T.

If substr(M->E2_CONTAD,1,1) $ '4/5' .And. !'GLB' $ M->E2_PREFIXO
    If Empty(M->E2_CCUSTO)
        MsgAlert("Para contas contábeis iniciadas em ( 4 ou 5 ) o campo Centro de Custo é de preenchimento obrigatório")
        lRet := .F.
    EndIf 
Endif 
RestArea(aArea)

Return(lRet)
