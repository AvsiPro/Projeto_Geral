#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100TOk ºAutor  ³Maicon Brito        º Data ³  11/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E. para validar se o item original foi preenchido em notasº±±
±±º          ³de devolucao e/ou entrada de nf sem pedido para produtos    º±±
±±º          ³diferentes de servicos TIPO = SV e especie diferente de FAT º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Tekbond                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT100TOk()

Local lRet 		:= .T.
Local aAreaAtu	:= GetArea()
Local aAreaCT1	:= CT1->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local nPosCta	:= GdFieldPos("D1_CONTA")
Local nLoop		:= 0
Local cTipoNF	:= cTipo
Local aArea		:= SaveOrd({"SF1","SD1","SED"})

IF cTipoNF == "N" //Verifica se o tipo eh normal
	
	// Verifica conta contabil
	For nLoop := 1 To Len(aCols)
		
		// Verifica se a linha esta deletada
		If (aCols[nLoop,Len(aHeader)+1])
			Loop
		EndIf
		
		If aCols[nLoop][nPosRat] <> "1"
			If Empty(aCols[nLoop][nPosCta])
				lRet := .F.
				Aviso("Conta contabil Obrigatório","Conta Contabil não foi informado, favor preencher.",{"&Voltar"})
			Endif
		Endif	
	Next nLoop	
EndIf

RestArea(aAreaSB1)
RestArea(aAreaCT1)
RestArea(aAreaAtu)
RestOrd(aArea)

Return(lRet)
