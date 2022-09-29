#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT500APO�Autor  �Jackson E. de Deus    � Data �  27/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE - executado ap�s a elimina��o de res�duo por registro 	  ���
���				do SC6													  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson	       �27/04/15�01.00 |Criacao                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT500APO()

Local aArea	:= GetArea()
Local cSql	:= ""
Local aAux := {}
Local nI

If cEmpant == "01"
	// se for pedido originado de faturamento de orcamentos
	If AllTrim(SC5->C5_XPREPED) == "S"
		cSql := "SELECT CK_NUM, R_E_C_N_O_ CKREC FROM " +RetSqlName("SCK")
		cSql += " WHERE CK_FILIAL = '"+xFilial("SCK")+"' "
		cSql += " AND CK_CLIENTE = '"+SC6->C6_CLI+"' "
		cSql += " AND CK_LOJA = '"+SC6->C6_LOJA+"' "
		cSql += " AND CK_NUMPV = '"+SC6->C6_NUM+"' "
		cSql += " AND CK_PRODUTO = '"+SC6->C6_PRODUTO+"'"
		cSql += " AND D_E_L_E_T_ = '' "
		
		If Select("TRBQ") > 0
			TRBQ->(dbCloseArea())
		EndIf
		
		TcQuery cSql New Alias "TRBQ"
		
		dbSelectArea("TRBQ")
		While TRBQ->( !EOF() )
			AADD( aAux, { TRBQ->CK_NUM,TRBQ->CKREC } )
			TRBQ->( dbSkip() )
		End
		TRBQ->( dbCloseArea() )
		
		dbSelectArea("SCK")
		dbSetOrder(1)
		For nI := 1 To Len(aAux)
			dbSelectArea("SCK")
			dbGoTo(aAux[nI][2])
			If Recno() == aAux[nI][2]
				If RecLock("SCK",.F.)
					SCK->CK_NUMPV := ""
					SCK->( MsUnLock() )
				EndIf
			EndIf
			dbSelectArea("SCJ")
			dbSetOrder(1)
			If dbSeek( xFilial("SCJ") +AvKey(aAux[nI][1],"CJ_NUM") )
				If AllTrim(SCJ->CJ_STATUS) <> "A"
					If RecLock("SCJ",.F.)    
						SCJ->CJ_XNUMPV := ""
						SCJ->CJ_STATUS := "A"
						SCJ->( MsUnLock() )
					EndIf
				EndIf
				
				// flega contador SZN
				dbSelectArea("SZN")
				dbSetOrder(4)
				If dbSeek( xFilial("SZN") +AvKey(SCJ->CJ_XNUMOS,"ZN_NUMOS") )
					RecLock("SZN",.F.)
					SZN->ZN_FECHAM := ""
					MsUnLock()
				EndIf
			EndIf                              
		Next nI
	EndIf
EndIf	

RestArea(aArea)

Return