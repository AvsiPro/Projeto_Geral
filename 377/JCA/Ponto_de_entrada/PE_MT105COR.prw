#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada rotina de solicita��o ao armazem

    inclus�o de cores de legendas novas.
*/
User Function MT105COR()

Local aCores := ParamIXB[1]

Local aRet   := { { "!Empty(CP_XTIPO)", "BR_LARANJA" } }

aEval( aCores, { |x| aAdd( aRet, x ) } )

Return aRet
