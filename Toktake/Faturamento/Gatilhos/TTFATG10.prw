#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATG10  �Autor  �Microsiga           � Data �  12/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para preencher os campos peso liquido e bruto no   ���
���          �cabecalho do pedido de venda conforme digitar os itens.     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATG10()

Local nRet		:= M->C6_QTDVEN 
Local lEdi1		:= .F.
Local nCont		:= 0

// Tratamento para AMC
If cEmpAnt == "10"
	Return nRet
EndIf


While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTEDI101/U_TTEDI110/CNTA120/U_TTFAT11C/U_TTEDI200/U_TTTMKA03/U_TTPROC22"
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo

If !lEdi1
	U_TTFAT04C()
EndIf


Return(nRet)