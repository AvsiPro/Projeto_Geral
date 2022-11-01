#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AT250ROT �Autor  �Alexandre Venancio  � Data �  10/10/22   ���
�������������������������������������������������������������������������͹��
���Desc.     �   PE para incluir rotinas em a��es relacionadas de contrato���
���          � de servi�os.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AT250ROT()

Local aRet := { }

aAdd(aRet, {'Pre-Faturamento','U_CONFSC01', 0 , 2} )
aAdd(aRet, {'Leiautes de Maquina','U_CONOPC03', 0 , 2} )

Return aRet
