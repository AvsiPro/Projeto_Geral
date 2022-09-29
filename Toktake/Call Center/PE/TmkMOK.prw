#Include 'rwmake.ch'  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKMOK    �Autor  �Marcio Domingos     � Data �  07/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esse ponto de entrada � executado antes da grava��o do     ���
���          � atendimento. Para que seja poss�vel identificar se o status��� 
���          � do atendimento esteja como Pendente o sistema n�o poder�   ���
���          � permitir a confirma��o do atendimento sem as informa��es   ���
���          � RETORNO e HORA DO RETORNO.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TOKTAKE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function TmkMOK()
Local _lRet	:= .T.  

If M->UC_STATUS = "2" // Pendente

	If Empty(M->UC_PENDENT) .Or. Empty(M->UC_HRPEND)
	
		MsgBox("Para atendimentos pendentes, favor informar a data e hora de retorno !")
		_lRet  := .F.
		
	Endif
	
Endif

Return _lRet		