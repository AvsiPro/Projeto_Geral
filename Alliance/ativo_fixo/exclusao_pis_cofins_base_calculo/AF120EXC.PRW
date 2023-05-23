/*//#########################################################################################
Project  : project
Module   : module
Source   : AF120EXC
Autor    : JOSE DE ASSUNCAO S. JUNIOR - TOTVS RJ 
Objective:  Permite informar valor a excluir da base de calculo 
            para geração do registro F120 Sped Pis/Cofins.
*///#########################################################################################

#INCLUDE 'TOTVS.CH'

User Function AF120EXC()

Local nValorExc     := 0
Local xAreaSn1		:= SN1->(GetArea())
Local xAreaSn3		:= SN3->(GetArea())
Local xAreaSn4		:= SN4->(GetArea())

nValorExc := GETADVFVAL('SN1','N1_XDEDUZ',xFilial('SN1')+PARAMIXB[2]+PARAMIXB[3],1)

SN1->(RestArea(xAreaSn1))
SN3->(RestArea(xAreaSn3))	
SN4->(RestArea(xAreaSn4))

Return(nValorExc)