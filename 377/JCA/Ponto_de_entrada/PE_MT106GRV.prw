#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada para validar saldo dos itens da pre-requisição e gravar vendas perdidas por falta de saldo.
    MIT 44_ESTOQUE_EST009 - Rotina para apurar as vendas perdidas e consulta

    Doc Mit
    https://docs.google.com/document/d/19LU8dgLuT44NOOVOlN3fwa9iECYmcjHm/edit
    Doc Entrega
    
    
*/

User Function MT106GRV

Local aArea := GetArea()

RestArea(aArea)

Return
