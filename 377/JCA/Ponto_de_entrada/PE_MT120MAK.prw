#INCLUDE 'PROTHEUS.CH'

User Function MT120MAK()//Rotina do usuario para adicionar campos....

Return( { "C1_XTIPCOT" } )
user function MT120VSC()         
ExpA1 := ParamIxb[1]            
ExpN2 := ParamIxb[2]    
//Customização do usuário para manipulação dos campos do array na seleção da Solicitação de Compras ou Contrato de Parceria - F4 no Pedido de Compras.
Return ExpA1 
