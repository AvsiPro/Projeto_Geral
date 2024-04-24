#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada rotina de solicitação ao armazem

    inclusão de cores de legendas novas.
*/
User Function MT105COR()

Local aCores := ParamIXB[1]

Local aRet   := { { "!Empty(CP_XTIPO)", "BR_LARANJA" } }

aEval( aCores, { |x| aAdd( aRet, x ) } )

Return aRet
