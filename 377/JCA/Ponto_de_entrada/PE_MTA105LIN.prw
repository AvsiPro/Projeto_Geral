#INCLUDE 'PROTHEUS.CH'

User Function MTA105LIN

Local aArea := GetArea()
//Local lSld  := U_xJCOMA03()
Local lRet  := .T.
//Local nPosL := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_XTIPO"})
/*
If lSld .And. Empty(aCols[n,nPosL])
    MsgAlert('Item sem saldo em estoque, informe o motivo para a venda perdida')
    lRet := .F.
EndIf 
*/
RestArea(aArea)

Return(lRet)
