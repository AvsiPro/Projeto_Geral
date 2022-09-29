#include 'totvs.ch'
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XGAPI03	�Autor  �Jackson E. de Deus  � Data �  27/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Converte endereco em coordenadas via API do Google Geocoding���
���          � Integracoes com Google API								  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �27/05/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function XGAPI03(cTipo,cEndereco)

Local nIP := "maps.googleapis.com/maps/api/geocode/"
Local nTimeOut := 5000
Local cResponse := "" 
Local aHeadOut := {}
Local cHeadRet := ""
Local cSend := ""
Default cTipo := "xml"
Default cEndereco := "" 

If cEmpAnt <> "01"
	Return
EndIf

nIP += cTipo
cSend += "?address=" +cEndereco +"&sensor=false"                

cResponse := HTTPCGet( nIP ,cSend,nTimeOut,aHeadOut,@cHeadRet )

Return cResponse