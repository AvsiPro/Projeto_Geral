#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410PVNF  � Autor � Artur Nucci Ferrari  �Data�  04/05/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar a preparacao da NFs           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	MsgBox ("Reservas de estoque para Pedido de Venda est�o bloquadas.","Erro!!!","STOP")   
	cRet := .F.
	Return(cRet)
End
//If SC5->C5_XSTLIB<>0
//	AVISO("MESSAGEM","Este pedido dever� passar pela aprova��o para ser liberado.",{"OK"},1)
//	lRet := .F.
//Else
	dbSelectAre('SC6')
	dbSetOrder(1)
	dbSeek(xFilial('SC6')+cNumPed)
	While SC6->C6_NUM==cNumPed .AND. !Eof()
		If SC6->C6_TES=='888'
			AVISO("MESSAGEM","Este pedido contem itens com a TES 888 e n�o pode ser faturado.",{"OK"},1)
			lRet := .F.
			Exit
		End
		If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05' .OR. SM0->M0_CODIGO=="11"
			If SM0->M0_CODFIL=='01'
				If SC6->C6_CF=='000'
		  			AVISO("MESSAGEM","Este pedido contem itens com a CFOP 000 e n�o pode ser faturado.",{"OK"},1)
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