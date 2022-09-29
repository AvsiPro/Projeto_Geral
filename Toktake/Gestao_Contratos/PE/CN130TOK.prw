#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CN130TOK  �Autor  �Microsiga           � Data �  04/29/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE para nao permitir medir parcelas do contrato de compras ���
���          �antes do periodo de competencia.                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CN130TOK()
//Valida��es espec�ficas
Local lRet := .T.

If cEmpAnt == "01"
	
	If strzero(month(ddatabase),2) == substr(m->cnd_compet,1,2) .or. strzero(month(ddatabase)+1,2) == substr(m->cnd_compet,1,2)
		lRet := .T.
	Else
		MsgAlert("Compet�ncia n�o permitida para medi��o","CN130TOK")
		lRet := .F.
	EndIf
EndIf

Return lRet