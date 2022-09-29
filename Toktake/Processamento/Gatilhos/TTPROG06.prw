/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTPROG06  �Autor  �Jackson E. de Deus  � Data �  11/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho para preenchimento do nome do tecnico.			  ���
���          �Inclusao de Ordem de Servico - Equipe Remota                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TTPROG06()

Local cNome := ""     
Local cAgente := ""
Local cRota := ""
Local cDescRota := ""

If cEmpAnt <> "01"
	return
EndIF

If !Empty(M->ZG_AGENTE)
	cAgente := cvaltochar(M->ZG_AGENTE)
	dbSelectArea("AA1")
	dbSetOrder(7)
	If dbSeek( xFilial("AA1") +AvKey(cAgente,"AA1_PAGER") )	
		cNome := AA1->AA1_NOMTEC
		cRota := AA1->AA1_LOCAL
	EndIf
	
	If !Empty(cRota)
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +AvKey(cRota,"ZZ1_COD"), "ZZ1_DESCRI" )
		M->ZG_ROTA := cRota
		M->ZG_ROTAD := cDescRota
	EndIf
EndIf            

Return cNome