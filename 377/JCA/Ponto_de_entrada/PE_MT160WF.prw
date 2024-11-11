#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada na finalização da analise de cotação

    Utilizado para complementar da solicitação pai quando gerar o pedido para os filhos
*/
User function MT160WF

	Local aArea     := GetArea()
	Local cCotacao  := Paramixb[1]
	Local cPedido   := SC7->C7_NUM
	Local cNumSc    := SC7->C7_NUMSC
	Local aItenSc1  := {}
	Local aGerou    := {}

	DbselectArea("SC7")
	DbSetOrder(1)
	If Dbseek(xFilial("SC7")+cPedido)
		While !EOF() .AND. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == cPedido
			Aadd(aGerou,{SC7->C7_PRODUTO,Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_XCODPAI")})
			Dbskip()
		EndDo
	EndIf


	DbSelectArea("SC8")
	DbSetOrder(1)
	If DbSeek(xFilial("SC8")+cCotacao+SC8->C8_FORNECE+SC8->C8_LOJA+'0001')
		While !EOF() .And. SC8->C8_FILIAL == xFilial("SC8") .And. SC8->C8_NUM == cCotacao
			If Empty(SC8->C8_NUMPED)
				Reclock("SC8",.F.)
				SC8->C8_NUMPED := cPedido
				SC8->(MSUNLOCK())
			EndIf
			Dbskip()
		EndDo
	EndIf

	DbSelectArea("SC1")
	DbSetOrder(1)
	If DbSeek(xFilial("SC1")+cNumSc)
		While !EOF() .AND. SC1->C1_FILIAL == xFilial("SC1") .And. SC1->C1_NUM == cNumSc
			cProdPai := Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_XCODPAI")
			nPosfilho := Ascan(aGerou,{|x| alltrim(x[1]) == alltrim(SC1->C1_PRODUTO)})
			nPosPai := Ascan(aGerou,{|x| alltrim(x[2]) == alltrim(cProdPai)})

			Aadd(aItenSc1,{SC1->C1_NUM,SC1->C1_ITEM,SC1->C1_XTIPCOT,SC1->C1_QUANT,SC1->C1_ZPRECAR})


			If (Empty(cProdPai) .Or. nPosPai > 0) .AND. nPosfilho == 0 //EMPTY(SC1->C1_COTACAO) .And.

				//Aadd(aItenSc1,{SC1->C1_NUM,SC1->C1_ITEM,SC1->C1_XTIPCOT,SC1->C1_QUANT})

				If Empty(SC1->C1_PEDIDO)
					Reclock("SC1",.F.)
					SC1->C1_PEDIDO := 'XXX'
					SC1->C1_QUJE   := SC1->C1_QUANT
					SC1->(Msunlock())
				EndIf

			EndIf

			Dbskip()
		EndDo
	EndIf


	DbSelectArea("SC7")
	DbGotop()
	DbSetOrder(1)
	Dbseek(xFilial("SC7")+cPedido)
	While !EOF() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cPedido
		//Reclock("SC7",.F.)
	//	SC7->C7_ZTPCOM := aItenSc1[nPos,03] //SC1->C1_XTIPCOT
		nPos := Ascan(aItenSc1,{|x| x[1]+x[2] == SC7->C7_NUMSC+SC7->C7_ITEMSC})
		If nPos > 0
			Reclock("SC7",.F.)
			SC7->C7_ZTPCOM := aItenSc1[nPos,03] //SC1->C1_XTIPCOT
            SC7->C7_ZPRECAR := aItenSc1[nPos,05] // SC7->C7_ZPRECAR

			If SC7->C7_QTDSOL == 0 .AND. aItenSc1[nPos,04] > 0
				SC7->C7_QTDSOL := SC7->C7_QUANT
			EndIf

			If Empty(SC7->C7_DESCRI)
				SC7->C7_DESCRI := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
			EndIf

			If Empty(SC7->C7_UM)
				SC7->C7_UM := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_UM")
			EndIf

			If Empty(SC7->C7_CONTA)
				SC7->C7_CONTA := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_CONTA")
			EndIf

			If Empty(SC7->C7_LOCAL)
				SC7->C7_LOCAL := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_LOCPAD")
			EndIf

			SC7->(MSUNLOCK())
		EndIf
		Dbskip()
	EndDo

	RestArea(aArea)

Return
