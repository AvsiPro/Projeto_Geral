
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPER16  �Autor  �Jackson E. de Deus  � Data �  02/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacoes do calendario do plano de trabalho              ���
���          �															  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �02/12/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

/*
recebe apenas o parametro data
nenhum outro parametro deve ser definido
todos os outros tratamentos devem ser feitos com base na area de trabalho atual e variaveis private definidas anteriormente
*/

User Function TTOPER16(cData)

Local lRet := .T.
Local dData := SToD(CValToChar(cData))

If cEmpAnt <> "01"
	
	// validacoes OMM
	If FwIsInCallStack("U_TTTMKA04")
		If SUD->UD_OCORREN == "000180"
			If dData < SUD->UD_XDTINST
				MsgAlert("A data escolhida n�o pode ser inferior a data agendada da instala��o!")
				lRet := .F.
				Return lRet
			EndIf                         
		EndIf
	EndIf
EndIF

Return lRet