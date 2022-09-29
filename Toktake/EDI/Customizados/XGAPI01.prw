#include 'totvs.ch'
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XGAPI01	�Autor  �Jackson E. de Deus  � Data �  26/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Traca rota entre dois pontos via API do Google Directions	  ���
���          �https://developers.google.com/maps/documentation/directions ���
���          � Integracoes com Google API								  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �26/11/13�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function XGAPI01(cOrigem,cDestino,aWayPoints)

Local nIP := 'maps.googleapis.com' +'/maps/api/directions/xml' 
Local nTimeOut	:= 5000
Local aHeadOut := {}
Local cHeadRet := ""
Default cOrigem := ""
Default cDestino := ""
Default aWayPoints := {}

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cOrigem) .Or. Empty(cDestino)
	MsgAlert("Parametros incorretos!","XGAPI01")
	Return cResponse	
EndIf

cSend := '?origin=' +cOrigem +'&destination=' +cDestino 

// Busca com pontos intermediarios
If Len(aWayPoints) > 0
	cSend += "&waypoints=optimize:true|"
	For nI := 1 To Len(aWayPoints)
		cSend += aWayPoints[nI]
		If nI <> Len(aWayPoints)
			cSend += "|"
		EndIf
	Next nI
EndIf

cSend +='&sensor=false"  
cResponse := HTTPCGet( nIP ,cSend,nTimeOut,aHeadOut,@cHeadRet )

Return cResponse