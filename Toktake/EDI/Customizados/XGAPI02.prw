#include 'totvs.ch'
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XGAPI02	�Autor  �Jackson E. de Deus  � Data �  27/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Traca rota entre dois pontos via API do Google Distance	  ���
���          �Matrix													  ���
���          �https://developers.google.com/maps/documentation/distancematrix/ ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �27/05/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function XGAPI02(cTipo,cOrigem,cDestino)

Local nPort := 80
Local nIP := 'maps.googleapis.com' 
Local nTimeOut := 5000
Local oObj
Local cBuffer := ""
Local cRet := ""

Default cOrigem := ""
Default cDestino := ""

If Empty(cOrigem) .Or. Empty(cDestino)
	Return
EndIf

If cEmpAnt <> "01"
	Return
EndIf

oObj := tSocketClient():New()
nResp := oObj:Connect( nPort,nIp,nTimeOut )

If( !oObj:IsConnected() ) 
  //cRet := "Google API: Falha na conex�o"
  //MsgAlert(cRet,"U_XGAPI02")
  Return cRet
Endif

cSend := 'GET /maps/api/distancematrix/' +cTipo +'?origins=' +cOrigem +'&destinations=' +cDestino 
cSend +='&mode=driving&language=pt-BR&sensor=false HTTP/1.0' +CRLF

cSend += 'Accept: */*' +CRLF
cSend += 'Accept-Language: pt-br' +CRLF
cSend += 'User-Agent: Mozilla/4.0 (compatible)' +CRLF
cSend += CRLF

nResp := oObj:Send( cSend )
If( nResp != Len( cSend ) )
	//cRet := "Google API: Erro - dados n�o transmitidos" 
	//MsgAlert(cRet)
 	Return cRet 
EndIf

nResp := oObj:Receive( @cBuffer, nTimeOut ) 
If( nResp >= 0 )
	cRet := cBuffer
EndIf

oObj:CloseConnection()

Return cRet