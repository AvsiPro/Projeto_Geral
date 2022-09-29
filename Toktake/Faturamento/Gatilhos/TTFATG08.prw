#INCLUDE "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATG08  �Autor  �Microsiga           � Data �  11/23/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFATG08()

Local aArea	:=	GetArea()
Local cRet	:=	M->C5_DESC1
Local nX	:=	0     
Local nPosT	:=	Ascan(aHeader,{|x| x[2] = "C6_VALOR"})
Local nPosU	:=	Ascan(aHeader,{|x| x[2] = "C6_PRCVEN"})
Local nPosQ	:=	Ascan(aHeader,{|x| x[2] = "C6_QTDVEN"})

// Tratamento para AMC
If cEmpAnt == "10"
	Return cRet
EndIf


For nX := 1 to len(aCols)
	aCols[nX,nPosT] := aCols[nX,nPosU] * aCols[nX,nPosQ]
Next nX		

oGetDad:oBrowse:Refresh()

RestArea(aArea)


Return(cRet)