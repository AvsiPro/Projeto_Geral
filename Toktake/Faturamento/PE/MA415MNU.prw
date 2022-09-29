/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA415MNU � Autor � Artur Nucci Ferrari  �Data�  08/06/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para inclusao de funcao no menu de or�.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#Include 'Protheus.ch'

User Function MA415MNU()

// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf

Aadd(aRotina,{"Aprova��o","U_MA415TT"	, 0 , 4, 0 ,NIL})

Return


User Function MA415TT()

Static cUserLib  := Upper(AllTrim(cusername))
Static cUserMV   := ""	//AllTrim(SuperGetMv("MV_XUSRORC"))


// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf

cUserMV   := AllTrim(SuperGetMv("MV_XUSRORC"))

RecLock("SCJ",.F.)
SCJ->CJ_STATUS := "A"
SCJ->CJ_USERAPR := Upper(AllTrim(cusername))
SCJ->CJ_DTAPR   := DATE()
SCJ->CJ_HRAPR   := TIME()	
MsUnLock()

Return