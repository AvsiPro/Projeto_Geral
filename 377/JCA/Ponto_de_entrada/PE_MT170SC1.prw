#INCLUDE 'PROTHEUS.CH'
/*
    Informações complementares ao finalização solicitação por ponto de pedido
*/
User Function MT170SC1

    Local aArea     := GetArea()

    Reclock("SC1",.F.)
    SC1->C1_OBS     := 'SC gerada por ponto de pedido'
    SC1->C1_XTIPCOT := '1'
    SC1->C1_XTPPROD := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_TIPO") 
    SC1->(Msunlock())

    FWAlertSuccess("MT170SC1 - Gerada a solictação de numero : "+SC1->C1_NUM,"Atenção")

    RestArea(aArea)

Return




