User Function MNTA2317()

Local lRet := .T.                 

If !Empty(cPNEUOLD)	
    MsgAlert("Clique primeiro em 'Disponível' para retirar o pneu.","Atenção")	
    lRet := .F.
EndIf

Return lRet

User Function MNTA2314(xy)
Local nT   := Len(aARTROLOC)
Local nTRB := nTamTRB+1
//A array aARRAYINI foi aumentada em algum momento do programa e agora o conteúdo está sendo 
//jogado na ultima posição da array aARTROLOC
//aAdd(aARTROLOC[nT],aARRAYINI[xy][nTRB])

Return Nil
