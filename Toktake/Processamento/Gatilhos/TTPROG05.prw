
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROG05  �Autor  �Jackson E. de Deus  � Data �  11/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para preenchimento da loja do cliente/forn.	      ���
���          �Inclusao de Ordem de Servico - Equipe Remota                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTPROG05()

Local aArea := GetArea()
Local cLoja := ""           

If cEmpAnt <> "01"
	return
EndIF
  
If !Empty(M->ZG_CLIFOR)
	If Empty(M->ZG_LOJA)
		If Type("_cLoja") == "C"
			If !Empty(_cLoja)
				M->ZG_LOJA := _cLOja
				cLoja := _cLoja
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aArea)
      
Return cLoja 