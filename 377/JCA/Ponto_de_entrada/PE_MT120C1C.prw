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
user function MT120VIT()         
ExpA1 := ParamIxb[1]            
ExpN2 := ParamIxb[2]    
//Customização do usuário para manipulação dos campos do array na seleção da Solicitação de Compras (Item) - F5 no Pedido de Compras.

Return ExpA1

User function MT120LCT

local aarea := getarea()

restarea(aarea)

return
