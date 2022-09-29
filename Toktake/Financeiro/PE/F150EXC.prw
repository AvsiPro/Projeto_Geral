#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F150EXC   �Autor  �Alexandre Venancio  � Data �  06/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE utilizado para bloquear o envio de um titulo a receber  ���
���          �ao banco quando o romaneio ainda nao tiver sido baixado.    ���
�������������������������������������������������������������������������͹��
���Uso       � Item 52 da lista de pendencias de sistema.                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F150EXC()

Local aArea	:=	GetArea()
Local lRet	:=	.T.

If SM0->M0_CODIGO=="01"
	If !Empty(Posicione("SF2",1,SUBSTR(SE1->E1_PREFIXO,1,2)+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1),"F2_XCARGA")) 
		If Posicione("SF2",1,SUBSTR(SE1->E1_PREFIXO,1,2)+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1),"F2_XRECENT") != "S"
			//Alert("Carga "+Posicione("SF2",1,xFilial("SF2")+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1),"F2_XCARGA"))
			MsgAlert("O Titulo "+SE1->E1_NUM+" n�o poder� ser enviado ao banco, pois ainda n�o foi efetuada a baixa do romaneio desta Nota Fiscal","F150EXC")
			lRet	:=	.F.
		EndIf
	EndIf
EndIf	
RestArea(aArea)

Return(lRet)