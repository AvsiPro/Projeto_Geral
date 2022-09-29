#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO15    �Autor  �Alexandre Venancio  � Data �  05/23/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para manutencao do tempo de abastecimento e atendi- ���
���          �mento de cada tipo de maquina                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTOPER05()

Local aArea	:=	GetArea()

If cEmpAnt == "01"      
	Axcadastro("ZZP","Tempo de Tarefas do Patrim�nio")
EndIf

RestArea(aArea)

Return