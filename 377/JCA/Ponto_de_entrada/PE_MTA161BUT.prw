#Include 'Protheus.ch'

User Function MTA161BUT()

Local aRotina:= PARAMIXB[1]

Aadd(aRotina,{"Avaliar cota��es do item","U_JCOMC001()" , 0 , 2 , 0 , Nil})
Aadd(aRotina,{"Imprimir Negocia��es","U_JCOMR001()" , 0 , 2 , 0 , Nil})


Return (aRotina)
