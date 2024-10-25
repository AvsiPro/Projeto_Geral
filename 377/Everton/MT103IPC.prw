#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103IPC  �Autor  �Totvs Centro Norte � Data �  25/06/22    ���
�������������������������������������������������������������������������͹��
���Desc.     � IMPORTACAO DOS ITENS DO PEDIDO DE COMPRA						  ���
���          � Na nota de entrada, no momento de importacao dos itens do  ���
���          � pedido de compras ( SC7 ).                                 ���
���@Altera��o - Everton Rosa 24/10/2024 - Retirar a funcionalidade para o grupo de empresa 03���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103IPC

Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
Local _nI     := ParamIXB[1]
Local _nPDesc := aScan( aHeader, {|x| AllTrim(x[2]) == "D1_DESCRIC" }) 
Local _nPProd := aScan( aHeader, {|x| AllTrim(x[2]) == "D1_COD" })

IF !cEmpAnt $ cEmpNExc 
		Return( Nil )
	endif
//Tratamento da descricao do produto considerando que na tabela de Pedido SC7 ja exista a coluna fisica com a descricao preenchida.
aCols[_nI][_nPDesc] := SC7->C7_DESCRI

//Tratamento da descricao do produto considerando que nao exista a coluna descricao na Tabela SC7, entao usa o posicione
//aCols[_nI][_nPDesc] := Posicione('SB1',1,xFilial('SB1')+aCols[_nI][_nPProd],'B1_DESC')

Return( Nil )
