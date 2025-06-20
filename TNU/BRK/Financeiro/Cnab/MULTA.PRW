#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
���Programa  �MULTA()   �Autor  �Eduardo Augusto     � Data �  14/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � FONTE DESENVOLVIDO PARA CALCULO DE VLR FIXO OU PERC MULTA, ���
���          � CONFORME LAYOUT CNAB BRADESCO COBRAN�A (POSICOES 066 A 070)���
�������������������������������������������������������������������������͹��
���Uso       � HAKUNA MATATA                                              ���
���������������������������������������������������������������������������*/

User Function MULTA()

Local _nMulta 	:= 0
Local _cBanco	:= SEE->EE_CODIGO
Local _cAgencia	:= SEE->EE_AGENCIA
Local _cConta	:= SEE->EE_CONTA
Local _cSubcta	:= SEE->EE_SUBCTA

DbSelectArea("SEE")       
Dbsetorder(1)
Dbseek(xfilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta)                     

If _cBanco == "341"
	_nMulta := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XMULTA)/100),"@E 99,999,999.99"),",","")), 13, "0" )
ElseIf _cBanco $ "001/033"
	_nMulta := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XMULTA)/100),"@E 999,999,999,999.99"),",","")), 15, "0" )
Else                                                                                                                        
	_nMulta := Padl( Alltrim(StrTran(Transform((SEE->EE_XMULTA),"@E 99,999,999.99"),",","")), 04, "0" )
EndIf
Return _nMulta
