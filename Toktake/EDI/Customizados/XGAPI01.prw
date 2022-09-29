#include 'totvs.ch'
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XGAPI01	ºAutor  ³Jackson E. de Deus  º Data ³  26/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Traca rota entre dois pontos via API do Google Directions	  º±±
±±º          ³https://developers.google.com/maps/documentation/directions º±±
±±º          ³ Integracoes com Google API								  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³26/11/13³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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