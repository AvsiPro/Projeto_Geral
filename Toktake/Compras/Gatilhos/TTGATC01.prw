#Include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTGATC01  �Autor  �Alexandre Venancio  � Data �  06/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Item 56 da lista de pendencias. Validar se o produto esta  ���
���          �bloqueado para novas compras.                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTGATC01()

Local aArea	:=	GetArea()
Local cCampo:=	Alltrim(ReadVar())       
Local cRet	:=	&(cCampo)

If cEmpAnt == "01"
	If Posicione("SB1",1,xFilial("SB1")+&(cCampo),"B1_XBLQCOM") 
		MsgAlert("Este produto encontra-se bloqueado para novas compras","TTGATC01")
		cRet := space(15)  
		&cCampo := SPACE(15)
		aCols[n,Ascan(aHeader,{|x| x[2] = substr(cCampo,4,15)})] := SPACE(15)
	EndIf
EndIF

RestArea(aArea)
    
Return(cRet)