#INCLUDE 'PROTHEUS.CH'
/*
    Informa��es complementares ao finaliza��o solicita��o por ponto de pedido
*/
User Function MT170SC1

Local aArea     := GetArea()

Reclock("SC1",.F.)
SC1->C1_OBS     := 'SC gerada por ponto de pedido'
SC1->C1_XTIPCOT := '1'
SC1->C1_XTPPROD := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_TIPO") 
SC1->(Msunlock())


RestArea(aArea)

Return




