User Function MTA131C8()

Local oModFor := PARAMIXB[1]

//Customizações do usuario
oModFor:LoadValue("C8_XQTDATU",SC8->C8_QUANT) 
oModFor:SetValue("C8_XQTDATU",SC8->C8_QUANT)

Return
