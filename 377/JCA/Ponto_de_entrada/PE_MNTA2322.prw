#INCLUDE 'PROTHEUS.CH'
/*
    PNEU002
    Ponto de entrada ao selecionar o estoque na retirada do pneu do desenho do veículo
    11/06/24 - Foi solicitado para que o conteúdo do estoque seja fixo em 08 através da atualização da mit pneu002
*/

User Function MNTA2322

Local lRet := .T.
Local cOpcao := Paramixb[1]

If cOpcao == "E"
    M->TQY_STATUS := '08'
EndIf

Return lRet 
