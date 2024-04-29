#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada inclusão de rotinas na solicitação de transferencia

*/

User Function MT311ROT

Local aArea := GetArea()

Local aRet := Paramixb // Array contendo os botoes padroes da rotina.

//Incluir F5 na tela de solicitação ao armazem para que se possa consultar o saldo de todos os itens relacionados ao código (pai e filhos)
SetKey(VK_F5, { || U_JESTC001(M->NNT_PROD,1) })


RestArea(aArea)

Return(aRet)
