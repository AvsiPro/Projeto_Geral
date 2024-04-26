#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada na gera��o de cota��o

    utilizado para incluir campo com a quantidade original da cota��o
*/
User Function MTA131C8()

Local oModFor := PARAMIXB[1]

//Customiza��es do usuario
oModFor:LoadValue("C8_XQTDATU",SC8->C8_QUANT) 
oModFor:SetValue("C8_XQTDATU",SC8->C8_QUANT)

Return

