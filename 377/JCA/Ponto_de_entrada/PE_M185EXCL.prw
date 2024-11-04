#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada para validar saldo dos itens da pre-requisição e gravar vendas perdidas por falta de saldo.
    MIT 44_ESTOQUE_EST009 - Rotina para apurar as vendas perdidas e consulta
    MIT 44_ESTOQUE_EST012 - Processamento rotina gerar pre-requisição de forma automática
    
    Doc Mit
    https://docs.google.com/document/d/19LU8dgLuT44NOOVOlN3fwa9iECYmcjHm/edit
    Doc Entrega
    
    
*/

User Function M185EXCL

Local aArea := GetArea()

DbSelectArea("ZPC")
DbSetOrder(1)
If Dbseek(xFilial("ZPC")+SCP->CP_NUM+SCP->CP_ITEM)
    While !EOF() .AND. ZPC->ZPC_REQUIS == SCP->CP_NUM .AND. ZPC->ZPC_ITEM == SCP->CP_ITEM
        Reclock("ZPC",.F.)
        DBDelete()
        ZPC->(Msunlock())
        Dbskip()
    EndDo 
EndIf 

RestArea(aArea)

Return 
