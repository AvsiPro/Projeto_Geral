#include "Protheus.ch"

//Ponto de entrada na geração do cnab de pagamentos para validar data de pagamento do arquivo.

User Function FIN420_1

    local dDtAge := DATAVALIDA(MV_PAR15,.t.) //Data Pagamento?   AFI42             

    If dDtAge >= date()
        RecLock("SE2", .F.)
        SE2->E2_DATAAGE := dDtAge
    else
        alert("A data de pagamento não pode ser inferior a data base do sistema.")
    EndIf
Return
