
#INCLUDE 'PROTHEUS.CH'
User Function MT105LEG()

Local aItLeg := ParamIXB[1]

Local aRet   := { { "BR_LARANJA", 'Venda Perdida' } }

aEval( aItLeg, { |x| aAdd( aRet, x ) } )

Return aRet
