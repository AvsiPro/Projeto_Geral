#INCLUDE 'PROTHEUS.CH'

User Function MT170SC1

Local aArea     := GetArea()

Reclock("SC1",.F.)
SC1->C1_OBS     := 'SC gerada por ponto de pedido'
SC1->C1_XTIPCOT := '1' 
SC1->(Msunlock())


RestArea(aArea)

Return




