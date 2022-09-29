#include "rwmake.ch"
/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �  F200VAR � Autor � Rodrigo Barreto        � Data � 19/09/22 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Altera��o no indice para leitura atrav�s do nosso numeto    ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Especifico    Criar o indice 29 Filia + numbco              ���
��������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function F200VAR()

	Local aDados     := PARAMIXB
	Local aAreaSE1   := SE1->(GetArea())
	Local cNumTitulo := Alltrim(Paramixb[1][1])
	Local cNsNum := Alltrim(Paramixb[1][4])
	Local nValLiq    := 0

	If cNsNum <> ""
		dbSelectArea("SE1")
		SE1->( dbSetOrder(29) )
		If SE1->(dbSeek(xFilial("SE1")+cNsNum ))
			cNumTit := SE1->E1_IDCNAB
			aDados[1][1] := cNumTit
		EndIf
	EndIf
	RestArea(aAreaSE1)

Return(aDados)
