#Include "Protheus.ch"

User Function TC450COR()

Local aCores := ParamIXB	 		

Aadd(aCores, {"AB6_STATUS !='E' .AND. AB6_XSTATU == 'A'" , "BR_LARANJA"})

Return aCores
