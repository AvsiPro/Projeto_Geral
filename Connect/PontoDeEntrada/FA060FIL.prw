#INCLUDE "PROTHEUS.CH"


User Function FA60FIL()

//Local cFiltr1 := ' Posicione("SC5",3,xFilial("SC5")+SE1->(E1_CLIENTE+E1_LOJA+E1_PEDIDO),"C5_CONDPAG") != "001" '
//Local cFiltr2 := ' AllTrim(Posicione("SF2",1,xFilial("SF2")+SE1->(E1_NUM+E1_PREFIXO+E1_CLIENTE+E1_LOJA),"F2_CHVNFE")) != "" '
//Local cFiltr3 := ' Alltrim(SE1->E1_TIPO) $ ("NEG/DP")'

//Local cFiltro := '( ' + cFiltr1 + '.And.' + cFiltr2 +' )  .OR. ' +cFiltr3
Local cFiltro := ' !Empty(SE1->E1_NUMBCO) '


Return cFiltro
