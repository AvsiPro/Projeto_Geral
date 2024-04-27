/*
    Incluir campo solicitação de compras
*/
User Function MT120C1D

Local aRetDados := PARAMIXB

If Alias() == 'SC1'
    Aadd(aRetDados, SC1->C1_XTIPCOT)     
Endif

Return(aRetDados)

User Function MT120C1C

Local aRetTitle := PARAMIXB

If Alias() == 'SC1'
    Aadd(aRetTitle, RetTitle('C1_XTIPCOT'))    
Endif

Return(aRetTitle)



