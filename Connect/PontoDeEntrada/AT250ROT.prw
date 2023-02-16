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

aAdd(aRet, {'Faturamento'                   ,'U_CONFSC01()'     , 0 , 2} )
aAdd(aRet, {'Status Contrato'               ,'U_CONFSC05()'     , 0 , 2} )
aAdd(aRet, {'Incluir Maquina'               ,'U_CONFSC06()'     , 0 , 2} )
aAdd(aRet, {'Retira Maquina'                ,'U_CONOPC07()'     , 0 , 2} )
aAdd(aRet, {'Atualiza Tabelas de Preco'     ,'U_CONDA0()'       , 0 , 2} )
aAdd(aRet, {'Faturar Franquia'              ,'U_CONFSC07()'     , 0 , 2} )

Return aRet
