#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCNTA09  �Autor  �Jackson E. de Deus  � Data �  17/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o cronograma e titulos provisorios do contrato.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TTCNTA09(cCliente, cLoja, cContrato, cPlanilha, nValorUnit, cCronog, dVencto)

Local aArea := GetArea()
                         
/*
//�����������������������������Ĵ[�
//�Ajusta os titulos provisorios�
//�����������������������������Ĵ[�
*/
If cEmpAnt == "01"
	
	dbSelectArea("SE1")
	dbSetOrder(2) // filial + cliente + loja + prefixo + titulo + parcela + tipo
	If dbSeek(xFilial("SE1")+avKey(cCliente, "E1_CLIENTE")+AvKey(cLoja, "E1_LOJA")+AvKey("CTR","E1_PREFIXO"))
		While SE1->E1_FILIAL == xFilial("SE1") .And. AllTrim(SE1->E1_CLIENTE) == AllTrim(cCliente) .And. AllTrim(SE1->E1_LOJA) == AllTrim(cLoja)  .And. !EOF()
			If SE1->E1_PREFIXO == "CTR" .And. AllTrim(SE1->E1_TIPO) == "PR" .And. AllTrim(SE1->E1_MDCONTR) == AllTrim(cContrato) .And. AllTrim(SE1->E1_MDPLANI) == AllTrim(cPlanilha) .And. AllTrim(SE1->E1_MDCRON) == AllTrim(cCronog) .And. AllTrim(SE1->E1_ORIGEM) == "CNTA100"
				If SE1->E1_VENCTO > dVencto
					RecLock("SE1",.F.)
					SE1->E1_VALOR := nValorUnit
				 	SE1->E1_SALDO := nValorUnit
				 	SE1->E1_VLCRUZ := nValorUnit
					MsUnLock()
				EndIf
			EndIf
			dbSkip()
		End
	EndIf
	
	
	/*
	//����������������������������������
	//�Atualiza o cronograma financeiro�
	//����������������������������������
	*/
	dbSelectArea("CNF")
	dbSetOrder(1) // filial + cronograma + contrato + revisao
	If dbSeek(xFilial("CNF")+AvKey(cCronog,"CNF_NUMERO")+AvKey(cContrato,"CNF_CONTRA"))
		While CNF->CNF_FILIAL == xFilial("CNF") .And. CNF->CNF_CONTRA == cContrato .And. CNF->CNF_NUMERO == cCronog
			If CNF->CNF_DTVENC > dVencto
				RecLock("CNF",.F.)
				CNF->CNF_VLPREV := nValorUnit
				CNF->CNF_SALDO := nValorUnit
				MsUNLock()
			EndIf
			dbSkip()
		End
	EndIf
EndIf

RestArea(aArea)

Return