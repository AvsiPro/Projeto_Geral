#Include "Rwmake.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA60BDE  �Autor  �Sandra Nishida      � Data �  10/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tratamento para gravar taxa de permanencia do banco         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA60BDE()
         
cAlias := alias()

If cEmpAnt == "01"
	DbSelectArea("SE1")
	nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	_nJuros := Round(((SE1->E1_SALDO - nVlrAbat)*sa6->a6_xtxper)/100,2)
	RecLock("SE1",.f.)
	se1->e1_porcjur := sa6->a6_xtxper
	se1->e1_valjur  := _njuros/30 
	MsunLock()
EndIF
  
Return