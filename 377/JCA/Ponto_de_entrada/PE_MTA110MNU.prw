#Include 'Protheus.ch'

User Function MTA110MNU()

Local aRotina := {}
//Customiza��es do cliente

//Incluir F5 na tela de solicita��o ao armazem para que se possa consultar o saldo de todos os itens relacionados ao c�digo (pai e filhos)
SetKey(VK_F5, { || U_JESTC001(M->C1_PRODUTO,2) })

Return aRotina
