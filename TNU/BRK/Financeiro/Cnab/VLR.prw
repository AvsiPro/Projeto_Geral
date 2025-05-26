#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
���Programa  �VLRDESC   �Autor  � Eduardo Augusto    � Data �  15/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna Valor liquido para montagem do CNAB                 ���
�������������������������������������������������������������������������͹��
���Uso       � Rentank	                                                  ���
���������������������������������������������������������������������������*/

User Function VLR()

Local cValLiq	:= ""
Local nAbat	:= 0
Local nDecres	:= 0
Local nAcresc	:= 0
Local nJuros	:= 0
Local nMulta	:= 0

nAbat	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)
nAcresc := SE1->E1_SDACRES
nDecres := SE1->E1_SDDECRE
nJuros	:= SE1->E1_JUROS
nMulta	:= SE1->E1_MULTA
cValLiq := PadL(Alltrim(Str((SE1->E1_SALDO - nAbat + nAcresc - nDecres + nJuros + nMulta) * 100 )), 13 , "0")

Return(cValLiq)
