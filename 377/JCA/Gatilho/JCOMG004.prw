#INCLUDE 'PROTHEUS.CH'
//ACRESCENTADO VALIDAÇÃO DE CAMPO X3_VALIDUSR PARA ESTA FUNÇÃO NO SC1->C1_PRODUTO

/*
    Validação de campo C1_PRODUTO para bloqueio de itens não permitidos comprar na filial
    MIT 44_ESTOQUE_EST008 - Cadastro de produto com as informações de produto alternativo e marcas

    Doc Mit
    https://docs.google.com/document/d/1e3oKJMW61KBxCwqDd90V2X_GzJZ4SVdZ/edit
    Doc Entrega
    https://docs.google.com/document/d/1tbJ0AWOkZ22TW2QLqiWWy2nesJ0zD9Bf/edit
    
*/

User Function JCOMG004

Local aArea := GetArea()
Local lRet  := .T.
Local aAux  := {}

DbSelectArea("SB1")
DbSetOrder(1)
If Dbseek(xFilial("SB1")+M->C1_PRODUTO)
    If !Empty(SB1->B1_XCODPAI)
        aAux := U__SearchSon(SB1->B1_XCODPAI)

        If Ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(M->C1_PRODUTO)}) == 0
            MsgAlert("Produto com restrição de compra para esta marca x filial","JCAGAT06")
            lRet := .F.
        EndIf 
        
    EndIf 
EndIf 


RestArea(aArea)

Return(lRet)
