#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKMDC    �Autor  �Jackson E. de Deus  � Data �  10/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado apos o cancelamento do atendimento.            ���
���          �Utilizado para restaurar o status dos patrim�nios em OMMs.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMKMDC()

Local cNumTmk	:= SUC->UC_CODIGO
Local aArea		:= GetArea()                 
Local cAssOMM	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK002",.T.,""),"")	// assunto OMM
Local cOcorrIns	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK003",.T.,""),"")	// ocorrencia de instalacao
Local cOcorrRem	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK004",.T.,""),"")	// ocorrencia de remocao
Local nRecno	:= 0

If cEmpAnt <> "01"
	Return
EndIf

dbSelectArea("SUD")
dbSetOrder(1)
If dbSeek(xFilial("SUD")+cNumTmk) 
	While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
		// A validacao deve ser somente para atendimentos de OMM, outros atendimentos podem ser cancelados
		If SUD->UD_ASSUNTO <> cAssOMM 
			dbSkip()
		EndIf
		
		/*
		//�������������������������������������������������������������������������������������Ŀ
		//�	No caso de um atendimento de OMM - Instalacao                                      �
		//�	Ajusta o status do patrimonio no Ativo Fixo - volta para status "Disponivel"       �
		//���������������������������������������������������������������������������������������
		*/
		If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrIns
			If AllTrim(SUD->UD_XNPATRI) <> ""
				dbSelectArea("SN1")
				dbSetOrder(2)	// filial + plaqueta
				nRecno := U_TTTMKA19(SUD->UD_XNPATRI)
				If nRecno > 0
					SN1->( dbGoTo(nRecno) )
					If AllTrim(SN1->N1_XSTATTT) $ "2|5" // esta empenhado/transito?
						If RecLock("SN1",.F.)
							SN1->N1_XSTATTT := "1"	// disponivel
							SN1->(MsUnlock())
						EndIf
					EndIf   
				EndIf
			EndIf
		/*
		//�����������������������������������������������������������������������������X�
		//�No caso de um atendimento de OMM - Remocao                                  �
		//�Ajusta o status do patrimonio no Ativo Fixo - volta para status "Em Cliente"�
		//�����������������������������������������������������������������������������X�
		*/
		ElseIf SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrRem
			If AllTrim(SUD->UD_XNPATRI) <> ""
				dbSelectArea("SN1")
				dbSetOrder(2)	// filial + plaqueta
				nRecno := U_TTTMKA19(SUD->UD_XNPATRI)
				If nRecno > 0
					SN1->( dbGoTo(nRecno) )
					If AllTrim(SN1->N1_XSTATTT) == "6" // esta em remocao?
						If RecLock("SN1",.F.)
							SN1->N1_XSTATTT := "3"	// em cliente
							SN1->(MsUnlock())
						EndIf
					EndIf   
				EndIf
			EndIf
		EndIf              
		SUD->(dbSkip())
	End While
EndIf
	
RestArea(aArea)

Return