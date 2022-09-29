#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATG04  �Autor  �Alexandre Venancio  � Data �  04/09/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para validacao da tabela contida no PV, n�o permitir��
���          �que seja alterada caso ela tenha sido trazida do cad cliente���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATG04()

Local aArea	:=	GetArea()
Local lRet	:=	.T. 
Local cTabC	:=	Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_TABELA")


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf

If !empty(cTabC) .And. M->C5_TABELA != cTabC
	MsgAlert("Quando o cliente j� tem uma tabela de pre�o amarrada a ele, este campo n�o pode ser alterado.","TTFATG04")
	lRet	:=	.F.
EndIf 
 

RestArea(aArea)

Return(lRet)