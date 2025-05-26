#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
���Programa  �MORA()   �Autor  �Eduardo Augusto      � Data �  14/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � FONTE DESENVOLVIDO PARA CALCULO DE JUROS MORA/DIA,         ���
���          � CONFORME LAYOUT CNAB ITAU COBRAN�A. (POSICOES 161 A 173)   ���
�������������������������������������������������������������������������͹��
���Uso       � VF										                 ���
���������������������������������������������������������������������������*/

User Function MORA()
Local _nMora 	:= 0
Local _cBanco	:= SEE->EE_CODIGO
Local _cAgencia	:= SEE->EE_AGENCIA
Local _cConta	:= SEE->EE_CONTA
Local _cSubCta	:= SEE->EE_SUBCTA
DbSelectArea("SEE")       
SEE->(Dbsetorder(1))
SEE->(Dbseek(xfilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubCta))
If _cBanco $ "001/341"
	_nMora := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XJUROS)/100)/30,"@E 99,999,999.99"),",","")), 13, "0" )
ElseIf _cBanco == "033"
	_nMora := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XJUROS)/100)/30,"@E 99,999,999.99"),",","")), 15, "0" )
Else                                                                                                                        
	_nMora := Padl( Alltrim(StrTran(Transform(((SE1->E1_VALOR*SEE->EE_XJUROS)/100)/30,"@E 99,999,999.99"),",","")), 13, "0" )
EndIf
Return _nMora