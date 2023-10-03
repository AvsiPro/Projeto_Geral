#INCLUDE 'PROTHEUS.CH'

User Function  MT120OK()
    
    Local nPosCot   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NUMCOT'})
    Local lValido   := .T.
    Local nX        := 0
    Local aCotacao  := {}

    For nX :=1 To Len( aCols )    
        If !Empty(aCols[nx][nPosCot]) 
            Aadd(aCotacao,aCols[nx][nPosCot])
        EndIf
    Next nX
    
    
Return(lValido)
