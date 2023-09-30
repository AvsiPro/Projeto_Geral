#INCLUDE 'PROTHEUS.CH'

User Function MT170SC1

Local aArea     := GetArea()

SC1->C1_OBS     := 'SC gerada por ponto de pedido'
SC1->C1_XTIPCOT := '1' 



RestArea(aArea)

Return




