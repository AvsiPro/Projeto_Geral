#include "rwmake.ch"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦M460FIM()    ¦ Autor ¦ Ricardo Souza	¦ Data ¦20.05.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ ponto de entrada executado após a gravação da nota fiscal  ¦¦¦
¦¦¦			 ¦ ultilizado para alterar Natureza SE1.			  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function M460FIM()

	Local aArea		:= GetArea()
	Local aAreage1 	:= SE1->(GetArea())

	IF SC5->C5_CONDPAG $ 'LNK|PIX|BLU'
		DbSelectArea("SE1")
		DbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		If DbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)
			While !EOF() .AND. SF2->F2_CLIENTE == SE1->E1_CLIENTE .AND. SF2->F2_LOJA == SE1->E1_LOJA .AND. SF2->F2_DOC == SE1->E1_NUM
				Reclock("SE1",.F.)
				IF	SC5->C5_CONDPAG == "LNK"
					SE1->E1_NATUREZ	:= "11010008"
				ELSEIF SC5->C5_CONDPAG == "PIX"
					SE1->E1_NATUREZ	:= "11010009"
				ELSEIF SC5->C5_CONDPAG == "BLU"
					SE1->E1_NATUREZ	:= "11010010"
				ENDIF
				SE1->(Msunlock())
				DbSkip()
			EndDo
		EndIf
	ENDIF
	RestArea(aAreage1)
	RestArea(aArea)
Return
