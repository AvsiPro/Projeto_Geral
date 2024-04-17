#INCLUDE 'PROTHEUS.CH'
User Function MT105COR()

Local aCores := ParamIXB[1]

Local aRet   := { { "!Empty(CP_XTIPO)", "BR_LARANJA" } }

aEval( aCores, { |x| aAdd( aRet, x ) } )

Return aRet
