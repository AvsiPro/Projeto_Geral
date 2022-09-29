#Include 'rwmake.ch'     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TKGRPED   �Autor  �Microsiga           � Data �  11/08/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esse ponto de entrada � executado antes da grava��o do     ���
���          � atendimento na rotina de televendas. Ao iniciar a grava��o ���
���          � do atendimento / or�amento, quando o campo UA_OPER = 2     ���
���          � (Or�amento), se sim n�o permitir que os campos UA_PROXLIG e��� 
���          � UA_HRPEND estejam em branco / vazios.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TOKTAKE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TkGrPed()
Local _lRet	:= .T.

If M->UA_OPER = "2"

	If Empty(M->UA_PROXLIG) .Or. Empty(M->UA_HRPEND)
	
		MsgBox("Favor informar a data e hora de retorno !")
		_lRet := .F.
		
	Endif
	
Endif			

Return _lRet