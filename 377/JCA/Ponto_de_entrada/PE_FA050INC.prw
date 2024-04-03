#INCLUDE 'PROTHEUS.CH'

User Function FA050INC

Local aArea := GetArea()
Local lRet  := .T.

If substr(M->E2_CONTAD,1,1) $ '4/5'
    If Empty(M->E2_CCUSTO)
        MsgAlert("Para contas contábeis iniciadas em ( 4 ou 5 ) o campo Centro de Custo é de preenchimento obrigatório")
        lRet := .F.
    EndIf 
Endif 
RestArea(aArea)

Return(lRet)
