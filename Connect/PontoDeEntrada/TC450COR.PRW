#Include "Protheus.ch"

User Function TC450COR()

// Local aCores := ParamIXB
Local aCores := {}

// Aadd(aCores, {"AB6_STATUS != 'E' .AND. AB6_XSTATU == 'A'" , "BR_LARANJA"})

aCores := {{"AB6_STATUS=='A' .AND. AB6_XSTATU!='A'","ENABLE"},{"AB6_STATUS=='E'","DISABLE"},{"AB6_STATUS=='B' .AND. AB6_XSTATU!='A'","BR_AMARELO"},{"AB6_XSTATU=='A'","BR_LARANJA"}}

Return aCores
