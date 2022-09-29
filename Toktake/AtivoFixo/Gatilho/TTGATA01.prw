#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTGATA01  �Autor  �Alexandre Venancio  � Data �  05/24/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para nao permitir que um codigo de serie seja digi-���
���          �tado duas vezes para um bem de um mesmo fabricante.         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTGATA01()

Local aArea		:=	GetArea()
Local cRetorno  :=  space(12)
Local cBem		:=	Posicione("SN1",9,xFilial("SN1")+M->N1_FORNEC+M->N1_LOJA+M->N1_XNSERFA,"N1_CBASE")

If !empty(cBem)
	MsgAlert("Este N�mero de s�rie j� esta sendo utilizado para o Bem Ativo "+cBem+chr(13)+chr(10)+"Portanto n�o ser� poss�vel utiliz�-lo para este bem","TTGATA01")
Else
	cRetorno := M->N1_XNSERFA
EndIf	

RestArea(aArea)

Return(cRetorno)