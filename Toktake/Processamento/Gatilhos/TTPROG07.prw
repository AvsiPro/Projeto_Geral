
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROG07  �Autor  �Jackson E. de Deus  � Data �  11/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para preenchimento da descricao do cliente/forn.	  ���
���          �Inclusao de Ordem de Servico - Equipe Remota                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTPROG07()

Local aArea := GetArea()
Local cDescri := ""
 
If cEmpAnt <> "01"
	return
EndIF
         
If !Empty(M->ZG_CLIFOR) .And. !Empty(M->ZG_LOJA)
	If M->ZG_FORM == "01" .And. AllTrim(M->ZG_TPDOC) == "1"
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") +M->ZG_CLIFOR +M->ZG_LOJA )
			cDescri := SA2->A2_NREDUZ
		EndIf
	Else 
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek( xFilial("SA1") +M->ZG_CLIFOR +M->ZG_LOJA )
			cDescri := SA1->A1_NREDUZ
		EndIf
	EndIf
EndIf

RestArea(aArea)
      
Return cDescri