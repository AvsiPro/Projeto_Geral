#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function MA410COR

Local aCores := {} //PARAMIXB

/*/
01	WHITE	    BR_BRANCO
02	GRAY	    BR_CINZA OK
03	GREEN	    BR_VERDE OK
04	RED	        BR_VERMELHO
05	BROWN	    BR_MARROM OK
06	BLUE	    BR_AZUL OK
07	YELLOW	    BR_AMARELO OK
08	BLACK	    BR_PRETO OK
09	PINK	    BR_PINK OK
10	F12_MARR	BR_VIOLETA OK
11	ORANGE	    BR_PRETO_0
12	LIGHTBLU	BR_PRETO_1
13	 	        BR_PRETO_3
14	 	        BR_CANCEL
15	 	        BR_VERDE_ESCURO
16	 	        BR_MARROM
17	 	        BR_MARRON_OCEAN
18	 	        BR_AZUL_CLARO
/*/

aAdd( aCores, {"Empty(C5_LIBEROK) .AND. Empty(C5_NOTA) .AND. Empty(ALLTRIM(C5_BLQ)) .AND. !(C5_ZZSTATU $ 'X/B/C/F/G/H')",     "ENABLE",            'Pedido Em Aberto' } ) // Pedido em Aberto
aAdd( aCores, {"!Empty(C5_NOTA) .OR. C5_LIBEROK == 'E' .AND. Empty(ALLTRIM(C5_BLQ))",                                        "DISABLE",             'Pedido Encerrado'} ) // Pedido Encerrado
aAdd( aCores, {"!Empty(C5_LIBEROK) .AND. Empty(C5_NOTA) .AND. Empty(ALLTRIM(C5_BLQ)) .AND. Empty(C5_MSBLQL)",             "BR_AMARELO", 'Pedido Aguardando Financeiro'} ) // Liberado sem bloqueio
aAdd( aCores, {"C5_MSBLQL == '2'.AND. Empty(C5_ZZSTATU)",                                                                    "BR_AZUL", 'Pedido Aguardando Financeiro'} ) // Pedido Bloquedo por regra
aAdd( aCores, {"C5_BLQ == '2'.AND. Empty(C5_ZZSTATU)",                                                                    "BR_LARANJA", 'Pedido Aguardando Financeiro'} ) // Pedido Bloquedo por verba
aAdd( aCores, {"C5_ZZSTATU == 'A'",                                                                                        "BR_MARROM",             'Pedido Conferido'} ) // Pedido "Em Separação"
aAdd( aCores, {"C5_ZZSTATU == 'B'",                                                                                          "BR_PINK",       'Bloqueio Inadimplência'} ) // Pedido "Em Conferencia"
aAdd( aCores, {"C5_ZZSTATU == 'C'",                                                                                  "BR_VERDE_ESCURO",  'Aguardando Resposta Cliente'} ) // Pedido "Em Conferencia"
aAdd( aCores, {"C5_ZZSTATU == 'F'",                                                                                         "BR_CINZA",                     'Impresso'} ) // Pedido "Em Conferencia"
aAdd( aCores, {"C5_ZZSTATU == 'G'",                                                                                         "BR_PRETO",                    'Cancelado'} ) // Pedido "Em Conferencia"
aAdd( aCores, {"C5_ZZSTATU == 'H'",                                                                                        "BR_BRANCO",        'Liberado Para Estoque'} ) // Pedido "Em Conferencia"
aAdd( aCores, {"C5_ZZSTATU == 'X'",                                                                                       "BR_VIOLETA",       'Pedido Gerado Pelo APP'} ) // PRE NOTA FISCAL

PARAMIXB := aCores

return( PARAMIXB )

User Function MA410LEG()
 
Local aLegNew := PARAMIXB

aLegNew[5][2] := "Pedido de venda em analise."

AADD( aLegNew, {"BR_MARROM",                     "Pedido Conferido"} )
AADD( aLegNew, {"BR_PINK",                 "Bloqueio Inadimplência"} )
AADD( aLegNew, {"BR_VERDE_ESCURO",    "Aguardando Resposta Cliente"} )
AADD( aLegNew, {"BR_VIOLETA",              "Pedido Gerado Pelo App"} )


Return( aLegNew )


User Function ZZSTATUAL()

Local cRet := ""

If Empty(C5_LIBEROK) .AND. Empty(C5_NOTA) .AND. Empty(ALLTRIM(C5_BLQ)) .AND. !(C5_ZZSTATU $ 'X/B/C/F/G/H')
    cRet := "Pedido em Aberto"
ElseIf (!Empty(C5_NOTA) .OR. C5_LIBEROK == 'E' .AND. Empty(ALLTRIM(C5_BLQ))) .AND. Empty(C5_ZZSTATU)
    cRet := "Pedido Encerrado"
ElseIf !Empty(C5_LIBEROK) .AND. Empty(C5_NOTA) .AND. Empty(ALLTRIM(C5_BLQ)) .AND. Empty(C5_MSBLQL)
    cRet := "Pedido Aguardando Financeiro"
ElseIf C5_MSBLQL == '2' .AND. Empty(C5_ZZSTATU)
    cRet := "Pedido Aguardando Financeiro"
ElseIf C5_ZZSTATU == "A"
    cRet := "Pedido Conferido"
ElseIf C5_ZZSTATU == "B"
    cRet := "Bloqueio Inadimplência"
ElseIf C5_ZZSTATU == "C"
    cRet := "Aguardando Resposta Cliente"
ElseIf C5_ZZSTATU == "D"
    cRet := "Aguardando Transmissão da NFe"
ElseIf C5_ZZSTATU == "E"
    cRet := "Faturado"
ElseIf C5_ZZSTATU == "F"
    cRet := "Impresso"
ElseIf C5_ZZSTATU == "G"
    cRet := "Cancelado"
ElseIf C5_ZZSTATU == "H"
    cRet := "Liberado Para Estoque"
ElseIf C5_ZZSTATU == "X"
    cRet := "Pedido Gerado Pelo App"
Else
    cRet := "Ver Status"
EndIf

Return (cRet)
