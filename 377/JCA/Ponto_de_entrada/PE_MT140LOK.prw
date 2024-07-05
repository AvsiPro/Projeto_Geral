#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para validação de linhas do pedido de compras

    Solicitado pelo Caio por email em 19/12

    Doc Mit
    
    Doc Entrega
    
    
*/

User Function MT140LOK 

Local lRet 		:= .T.
Local cconta	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_CONTA"})]
Local ccc    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_CC"})]


If FunName() <> "COMXCOL"

    If !aCols[n,len(aHeader)+1]
        If substr(cconta,1,1) $ "4/5" .And. Empty(ccc)
            MsgAlert("Contas Contabeis iniciadas em 4 e 5, necessitam que o campo centro de custo seja digitado")
            lRet := .F.
        EndIf 
    EndIf 
EndIf 

Return(lRet)
