#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F150EXC   ºAutor  ³Alexandre Venancio  º Data ³  06/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE utilizado para bloquear o envio de um titulo a receber  º±±
±±º          ³ao banco quando o romaneio ainda nao tiver sido baixado.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Item 52 da lista de pendencias de sistema.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F150EXC()

Local aArea	:=	GetArea()
Local lRet	:=	.T.

If SM0->M0_CODIGO=="01"
	If !Empty(Posicione("SF2",1,SUBSTR(SE1->E1_PREFIXO,1,2)+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1),"F2_XCARGA")) 
		If Posicione("SF2",1,SUBSTR(SE1->E1_PREFIXO,1,2)+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1),"F2_XRECENT") != "S"
			//Alert("Carga "+Posicione("SF2",1,xFilial("SF2")+SE1->E1_NUM+SUBSTR(SE1->E1_PREFIXO,3,1),"F2_XCARGA"))
			MsgAlert("O Titulo "+SE1->E1_NUM+" não poderá ser enviado ao banco, pois ainda não foi efetuada a baixa do romaneio desta Nota Fiscal","F150EXC")
			lRet	:=	.F.
		EndIf
	EndIf
EndIf	
RestArea(aArea)

Return(lRet)