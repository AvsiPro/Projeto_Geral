#Include 'Protheus.ch'
/*
    Incluir F5 na tela de solicitação ao armazem para que se possa consultar o saldo de todos os itens relacionados ao código (pai e filhos)
*/
User Function MTA261MNU()

Local aRotina := {}
//Customizações do cliente

//
SetKey(VK_F5, { || U_JESTC001(M->D3_COD,3) })

Return aRotina
