#INCLUDE 'PROTHEUS.CH'
//ACRESCENTADO VALIDA��O DE CAMPO X3_VALIDUSR PARA ESTA FUN��O NO SC1->C1_PRODUTO
User Function JCAGAT06

Local aArea := GetArea()
Local lRet  := .T.
Local aAux  := {}

DbSelectArea("SB1")
DbSetOrder(1)
If Dbseek(xFilial("SB1")+M->C1_PRODUTO)
    If !Empty(SB1->B1_XCODPAI)
        aAux := U__SearchSon(SB1->B1_XCODPAI)

        If Ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(M->C1_PRODUTO)}) == 0
            MsgAlert("Produto com restri��o de compra para esta marca x filial","JCAGAT06")
            lRet := .F.
        EndIf 
        
    EndIf 
EndIf 


RestArea(aArea)

Return(lRet)
