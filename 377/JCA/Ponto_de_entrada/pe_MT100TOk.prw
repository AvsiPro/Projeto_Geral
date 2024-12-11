#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100TOk �Autor  �Maicon Brito        � Data �  11/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. para validar se o item original foi preenchido em notas���
���          �de devolucao e/ou entrada de nf sem pedido para produtos    ���
���          �diferentes de servicos TIPO = SV e especie diferente de FAT ���
�������������������������������������������������������������������������͹��
���Uso       � Tekbond                                                    ���
�������������������������������������������������������������������������͹��
���Altera��o �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				Aviso("Conta contabil Obrigat�rio","Conta Contabil n�o foi informado, favor preencher.",{"&Voltar"})
			Endif
		Endif	
	Next nLoop	
EndIf

RestArea(aAreaSB1)
RestArea(aAreaCT1)
RestArea(aAreaAtu)
RestOrd(aArea)

Return(lRet)
