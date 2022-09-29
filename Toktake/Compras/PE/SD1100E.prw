#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD1100E  ºAutor  ³    Cadubitski      º Data ³  02/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na exclusão da nota de entrada para fazer  º±±
±±º          ³o estorno quando devolucao.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Toktake                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SD1100E()
Local aAreaBKP := GetArea()
Local aMata240 := {}    
Local cTM      := If(cEmpAnt == "01",GetMv("MV_XTMSD3",,"001"),"")  
Local cTFord   
Local cPFord

If cEmpAnt == "01"     
	//Tratamento na inclusao e classificacao
	//If l103Class .Or. EXCLUI
		If SD1->D1_TIPO == "D"
	
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3))
			SD2->(dbSeek(xFilial("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEMORI ))
			
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO ))
			
			If !Empty(SC5->C5_XCODPA) .And. SC5->C5_XNFABAS == "1"
				// PA - ROTA JA FAZ DEVOLUCAO NA ROTINA DO FECHAMENTO TTPROC57
				If SubStr(SC5->C5_XCODPA,1,1) == "P"
					aMata240 := {}
					aAdd(aMata240, {'D3_TM'     ,cTM			,Nil})
					aAdd(aMata240, {'D3_COD'    ,SD1->D1_COD    ,Nil})
					aAdd(aMata240, {'D3_UM'     ,SD1->D1_UM     ,Nil})
					aAdd(aMata240, {'D3_QUANT'  ,SD1->D1_QUANT  ,Nil})
					aAdd(aMata240, {'D3_LOCAL'  ,SC5->C5_XCODPA ,Nil})
					aAdd(aMata240, {'D3_EMISSAO',SD1->D1_EMISSAO,Nil})
					aAdd(aMata240, {'D3_DOC'    ,SD1->D1_DOC    ,Nil})
					aAdd(aMata240, {'D3_CONTA'  ,SD1->D1_CONTA  ,Nil})
					aAdd(aMata240, {'D3_CC'     ,SD1->D1_CC     ,Nil})
					aAdd(aMata240, {'D3_CLVL'   ,SD1->D1_CLVL   ,Nil})
					aAdd(aMata240, {'D3_ITEMCTA',SD1->D1_ITEMCTA,Nil})
					aAdd(aMata240, {'D3_XORIGEM',"SD1100E"		,Nil})
					                                               
					lMsErroAuto := .F.
					MSExecAuto({|x,y| Mata240(x,y)},aMata240,3)
					If lMsErroAuto
						MostraErro()
					Else
						RecLock("SD2",.f.)
							SD2->D2_XSLDPA += SD1->D1_QUANT //Volta o saldo
						MsUnLock()
					EndIf
				EndIf	
			EndIf		     
		EndIf
	//EndIf
	
	/*--------------------------------------------------------------------------------------------------------|
	|Código ultilizado para Limpar os campos customizados no caso de estorno das notas de entrada			|
	|---------------------------------------------------------------------------------------------------------|
	|Autor------>>Ricardo Souza|Data------>>08/09/2020														  |
	|--------------------------------------------------------------------------------------------------------*/
	If GetMv("MV_XDIVNF")==.T.
		RecLock("SD1",.F.)
			SD1->D1_XCLASPN	:=0		
		MsUnLock()
	EndIf
EndIF

RestArea(aAreaBKP)

Return(Nil)