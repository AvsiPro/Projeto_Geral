User Function MT110CP2()
Local aAreaSC1 := SC1->(GetArea())
Local aItens := PARAMIXB[1]
Local oQual  := PARAMIXB[2]
Local nX  := 0

// Adiciona titulo da coluna que esta sendo incluída
AADD(PARAMIXB[2]:AHEADERS,RetTitle("C1_XTIPCOT"))

// Adiciona campo da coluna que esta sendo incluída
cNumSC := SC1->C1_NUM
DbSelectArea("SC1")
DbSetOrder(1)
For nX := 1 To Len(PARAMIXB[2]:AARRAY)
 MsSeek(xFilial("SC1")+cNumSC)
 While !Eof() .And. C1_FILIAL == xFilial("SC1") .And. C1_NUM == cNumSc
  If C1_PRODUTO == PARAMIXB[2]:AARRAY[nX][1] .And. ;
   C1_UM  == PARAMIXB[2]:AARRAY[nX][2] .And. ;
   C1_QUANT == PARAMIXB[2]:AARRAY[nX][3] .And. ;
   C1_OBS  == PARAMIXB[2]:AARRAY[nX][4] .And. ;
   C1_EMISSAO == PARAMIXB[2]:AARRAY[nX][5] .And. ;
   C1_DESCRI == PARAMIXB[2]:AARRAY[nX][6] .And. ;
   C1_FILENT == PARAMIXB[2]:AARRAY[nX][7]
   AADD(PARAMIXB[2]:AARRAY[nX],SC1->C1_XTIPCOT)
   Exit
  EndIf
  DbSkip()
 EndDo
Next nX

// Redefine bLine do objeto oQual inlcuindo a coluna nova
aItens := PARAMIXB[2]:AARRAY
PARAMIXB[2]:bLine := { || {aItens[oQual:nAT][1],aItens[oQual:nAT][2],aItens[oQual:nAT][3],aItens[oQual:nAT][4],aItens[oQual:nAT][5],aItens[oQual:nAT][6],aItens[oQual:nAT][7],aItens[oQual:nAT][8]}}
// 1-Produto; 2-Unid.Medida; 3-Quantidade; 4-Obs.; 5-Dt.Emissao; 6-Descricao; 7-Fil.Entrega

RestArea(aAreaSC1)

Return
