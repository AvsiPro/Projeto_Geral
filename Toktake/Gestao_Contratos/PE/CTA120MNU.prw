
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTA120MNU �Autor  �Jackson E. de Deus  � Data �  02/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Localizado na rotina de Medi��o do Contrato.                ���
���          �Adiciona bot�es ao menu principal da rotina.				  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTA120MNU()
 

Local aArea		:=	GetArea()

If cEmpAnt == "01"

	Aadd(aRotina,{"Pedido de Insumo","U_TTCNTA05",0,6})

EndIF

RestArea(aArea)

Return