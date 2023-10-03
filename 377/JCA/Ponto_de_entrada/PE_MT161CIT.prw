#Include 'Protheus.ch'

User Function MT161CIT()

Local cFiltro := ''
Local cBackpc8 := SC8->C8_NUM

DbSelectArea("SC8")
DbSetOrder(1)
DbSeek(xfilial("SC8")+cBackpc8)

While !EOF() .AND. SC8->C8_NUM == cBackpc8 .AND. SC8->C8_FILIAL == xFilial("SC8")

    cMarca  := Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_ZMARCA")

    If Empty(cMarca)
        cFiltro += " AND C8_PRODUTO <> '"+SC8->C8_PRODUTO+"'"
    EndIf 

    Dbskip()
EndDo 

Return (cFiltro)
