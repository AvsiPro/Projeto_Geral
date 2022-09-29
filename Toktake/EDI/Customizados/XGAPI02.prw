#include 'totvs.ch'
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XGAPI02	ºAutor  ³Jackson E. de Deus  º Data ³  27/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Traca rota entre dois pontos via API do Google Distance	  º±±
±±º          ³Matrix													  º±±
±±º          ³https://developers.google.com/maps/documentation/distancematrix/ º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³27/05/14³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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
  //cRet := "Google API: Falha na conexão"
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
	//cRet := "Google API: Erro - dados não transmitidos" 
	//MsgAlert(cRet)
 	Return cRet 
EndIf

nResp := oObj:Receive( @cBuffer, nTimeOut ) 
If( nResp >= 0 )
	cRet := cBuffer
EndIf

oObj:CloseConnection()

Return cRet