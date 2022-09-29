#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SD1100I   �Autor  �Alexandre Venancio  � Data �  04/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE apos gravar o item da nf de entrada, utilizado para gra-���
���          �var o custo standard no produto quando nao existir.         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SD1100I() 

Local aArea	:= GetArea()
Local ExpN1	:= PARAMIXB[3]
Local cTFord
Local cPFord

//Caso nao haja um custo standard cadastrado no produto, pega o custo da mercadoria e salva no produto.  
//Item 174 da lista de pendencias.
If 	ExpN1 == 1 .AND. SB1->B1_CUSTD == 0
	Reclock("SB1",.F.)
	SB1->B1_CUSTD := SD1->D1_CUSTO / SD1->D1_QUANT
	SB1->(Msunlock())
EndIf                               
        

RestArea(aArea)

Return Nil