/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M415FSQL�Autor  �Jackson E. de Deus    � Data �  24/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE - Filtro dos dados do Browse de Orcamentos				  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson	       �24/04/15�01.00 |Criacao                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function M415FSQL()

Local cFiltro := ""     
Local cUsrVip := ""	//SuperGetMV("MV_XFAT001",.T.,"ADMIN")
Local aArea := GetArea()

/*
regra de filtro utilizada para nao mostrar os orcamentos originados de leituras de OS
esse orcamentos serao mostrados atraves de rotina customizada
foi feito assim pois a rotina padrao MATA415 nao possui ponto de entrada para bloqueio de alteracao de orcamentos
*/
If cEmpant == "01"
	cUsrVip := SuperGetMV("MV_XFAT001",.T.,"ADMIN")
	If ! UPPER(cUserName) $ UPPER(cUsrVip)
		If FieldPos("CJ_XNUMOS") > 0
			cFiltro := "CJ_XNUMOS = ''" 
		EndIf                 
	EndIf
EndIf


RestArea(aArea)

Return cFiltro