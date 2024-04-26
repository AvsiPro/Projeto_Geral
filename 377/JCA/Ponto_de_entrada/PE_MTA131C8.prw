#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada na geração de cotação

    utilizado para incluir campo com a quantidade original da cotação
*/
User Function MTA131C8()

Local oModFor := PARAMIXB[1]

//Customizações do usuario
oModFor:LoadValue("C8_XQTDATU",SC8->C8_QUANT) 
oModFor:SetValue("C8_XQTDATU",SC8->C8_QUANT)

Return

