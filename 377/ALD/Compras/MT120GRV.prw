User Function MT120GRV

Local lInclui   := PARAMIXB[2]
Local lAltera   := PARAMIXB[3]
Local lExclui   := PARAMIXB[4]
Local lRet      :=  .T.
Local nPosTot   := Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})
Local nPosDtE   := Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_DATPRF"})
Local nTotPed   := 0

If lInclui .or. lAltera
    If cOpcAD == "1"
        Aeval(aCols,{|x| nTotPed += x[nPosTot]})
        Processa({|| lRet := U_ACOM001(nTotPed,cCondicao,aCols[1,nPosDtE],If(lInclui,1,2)) },"Gerando titulos AD")
    EndIf 
ElseIf lExclui
    If cOpcAD == "1"
        Processa({|| U_ACOMD01(CA120NUM+'AD') },"Excluindo titulos AD")
    EndIf
EndIF 

Return lRet
