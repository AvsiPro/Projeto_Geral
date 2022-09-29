#include 'totvs.ch'
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XGAPI06	�Autor  �Jackson E. de Deus  � Data �  06/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Traca rota entre dois pontos via API do Google Distance	  ���
���          �Matrix													  ���
���          � Integracoes com Google API								  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �06/11/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function XGAPI06(cTipo,cOrigem,cDestino)
                                       
Local nIP := 'maps.googleapis.com' +'/maps/api/distancematrix/' +cTipo 
Local nTimeOut := 5000
Local cSend := ""
Local cResponse := "" 
Local aHeadOut := {}
Local cHeadRet := ""
Default cTipo := "xml" 
Default cOrigem := ""
Default cDestino := ""

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cOrigem) .Or. Empty(cDestino)  
	MsgAlert("Parametros incorretos!","XGAPI06")
	Return
EndIf

cSend := '?origins=' +cOrigem +'&destinations=' +cDestino
cSend +='&mode=driving&language=pt-BR&region=br&sensor=false
 
cResponse := HTTPCGet( nIP ,cSend,nTimeOut,aHeadOut,@cHeadRet )

Return cResponse