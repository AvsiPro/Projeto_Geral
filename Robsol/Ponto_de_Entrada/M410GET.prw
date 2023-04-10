#Include 'Totvs.ch'

User Function M410GET()

    SC9->(DbSetOrder(2))
	If SC9->(DbSeek(xFilial('SC9')+M->C5_CLIENTE+M->C5_LOJACLI+M->C5_NUM))
        If MsgYesNo('O pedido selecionado foi liberado anteriormente, deseja manter a liberação?')
            Public _PMantLiB := .T.
        EndIf
    EndIf

Return
