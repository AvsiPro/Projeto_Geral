#Include 'Protheus.ch'

User Function MT161CIT()

Local cFiltro := ''
Local cMarca  := Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_ZMARCA")

If Empty(cMarca)
    cFiltro := " AND C8_PRODUTO <> '"+SC8->C8_PRODUTO+"'"
EndIf 

Return (cFiltro)
