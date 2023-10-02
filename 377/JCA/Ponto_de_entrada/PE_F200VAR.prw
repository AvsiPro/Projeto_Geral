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


/*
    {Protheus.doc} F200VAR
	    Ponto de entrada F200VAR para alterar as variaveis antes da baixa do retorno CNAB
  	    06-MIT 44 FINANCEIRO FIN017- Gerar boleto de Adiantamento - RA
 		https://docs.google.com/document/d/1lEfWblcls4_Z28sdq9QI0cB5Mw0om2Fc/edit
*/

User Function F200VAR()

	Local aArea	 := GetArea()
	Local aAreaSE1	 := SE1->(GetArea())
	Local cNumTitulo := Alltrim(Paramixb[1][1])

	dbSelectArea("SE1")
	SE1->( dbSetOrder(16) )
	cChave:=SE1->(dbSeek(xFilial("SE1")+cNumTitulo))

	If SE1->E1_TIPO == "BOL"
		cMOTBX := "DAC"
		U_JFINM017()
	EndIf

	RestArea(aAreaSE1)
	RestArea(aArea)
Return
