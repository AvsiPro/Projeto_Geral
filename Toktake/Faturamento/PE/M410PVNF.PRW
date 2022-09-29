#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410PVNF  º Autor ³ Artur Nucci Ferrari  ºData³  04/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para validar a preparacao da NFs           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410PVNF()
Local aArea		:= GetArea()
Local aAreaSC6	:= SC6->(GetArea())
Local cNumPed   := SC5->C5_NUM
Local lRet		:= .T. 
Local dDtLib   := stod("")	//SuperGetMV("MV_XBLQLIB")


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf

dDtLib   := SuperGetMV("MV_XBLQLIB")


If date() <= dDtLib
	MsgBox ("Reservas de estoque para Pedido de Venda estão bloquadas.","Erro!!!","STOP")   
	cRet := .F.
	Return(cRet)
End
//If SC5->C5_XSTLIB<>0
//	AVISO("MESSAGEM","Este pedido deverá passar pela aprovação para ser liberado.",{"OK"},1)
//	lRet := .F.
//Else
	dbSelectAre('SC6')
	dbSetOrder(1)
	dbSeek(xFilial('SC6')+cNumPed)
	While SC6->C6_NUM==cNumPed .AND. !Eof()
		If SC6->C6_TES=='888'
			AVISO("MESSAGEM","Este pedido contem itens com a TES 888 e não pode ser faturado.",{"OK"},1)
			lRet := .F.
			Exit
		End
		If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05' .OR. SM0->M0_CODIGO=="11"
			If SM0->M0_CODFIL=='01'
				If SC6->C6_CF=='000'
		  			AVISO("MESSAGEM","Este pedido contem itens com a CFOP 000 e não pode ser faturado.",{"OK"},1)
					lRet := .F.
				Exit
				End
			End	
		End
		dbSkip()
		Loop
	End
	dbSelectAre('SC5')
//End
RestArea(aAreaSC6)
RestArea(aArea)

Return(lRet)