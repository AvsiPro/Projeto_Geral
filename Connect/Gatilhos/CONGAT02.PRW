#INCLUDE "PROTHEUS.CH"

User Function CONGAT02

Local aArea :=  GetArea()
Local cRet  :=  ''

cRet := Posicione("SD2",3,SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_PEDIDO")

RestArea(aArea)

Return(cRet)

User Function CONGAT2X

Local aArea :=  GetArea()
Local cRet  :=  ''
Local cPed  :=  ''
Local aTip  := {{'A','Abastecimento'},{'F','Faturamento Dose'},{'V','Venda'},{'L','Locação'},{'I','Instalar Ativo'}}

cPed := Posicione("SD2",3,SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_PEDIDO")

cRet := Posicione("SC5",1,xFilial("SC5")+cPed,"C5_XTPPED")

nPos := Ascan(aTip,{|x| x[1] == Alltrim(cRet)})

If nPos > 0
    cRet := aTip[nPos,02]
EndIF 

RestArea(aArea)

Return(cRet)
