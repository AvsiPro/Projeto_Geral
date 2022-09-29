#include 'protheus.ch'

           
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TK271ABR  �Autor  �Jackson E. de Deus  � Data �  06/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado ao clicar no bot�o Alterar.					  ���
���			 �Permite tratamentos espec�ficos e de valida��o ao tentar    ���
���          �incluir, alterar ou consultar um novo atendimento           ���
���          �televendas, cancelando, se necess�rio, a abertura da janela ���
���          �de atendimento.											  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TK271ABR()

Local lRet		:= .T.
Local aArea		:= GetArea()
Local cNumAtend := ""


/*
//����������������������������������������������������������������������������Ŀ
//�Verifica se o usuario tem permissao para acessar a rotina. CHAVE - PERMISSAO�
//������������������������������������������������������������������������������
*/
If Paramixb[1] == 4
	dbSelectArea("SUC")
	cNumAtend := SUC->UC_CODIGO

	dbSelectArea("SUD")
	dbSetOrder(1)

	lRet := U_TTTMKA05(cNumAtend)
	If ValType(lRet) == "L"
		Return lRet
	EndIf
EndIf 

RestArea(aArea)

Return(lRet)