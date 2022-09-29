#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GOOGLE01   ºAutor  ³Jackson E. de Deus º Data ³  07/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ API Google Cloud Messaging                                 º±±
±±º          ³ Dispara notificacao para aparelho                          º±±
±±º          ³ Compilar esse fonte em formato de PATCH                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GOOGLE01(cRegID,cMsg)

Local nTimeOut := 5000
Local cResponse := ""
Local aHeadOut := {}
Local cHeadRet := ""
Local cUrlGCM	:= GetMV("MV_XMB001",,"") //"https://android.googleapis.com/gcm/send"
Local cApiKeySrv := GetMV("MV_XMB002",,"") //"AIzaSyAQRUszR01El0tPD584lMwoY04tfsXRKd4" // AIzaSyBAYtdYAYuA-vJooVNl73y9aCWtOjSUt8E
Local lFCM := .F.
Default cRegID := ""
Default cMsg := ""

If Empty(cRegID) .Or. Empty(cMsg)
	Conout("# GOOGLE01 -> Parametros invalidos #")
	Return cHeadRet
EndIf     

If Empty(cUrlGCM) .Or. Empty(cApiKeySrv)
	Conout("# GOOGLE01 -> CONFIGURE O GCM #")
	Return cHeadRet
EndIf

If ":" $ cRegID
	lFCM := .T.
EndIf  

// Envia POST direto para o aparelho via Firebase Cloud Messagind/Google Cloud Messaging
If !lFCM
	AADD( aHeadOut, "Content-Type: application/x-www-form-urlencoded" )
	AADD( aHeadOut, "Authorization: key="+cApiKeySrv )	
	cResponse := HttpPost( cUrlGCM,, "registration_id="+cRegID +"&data.msg="+cMsg,nTimeOut,aHeadOut,@cHeadRet )
Else
	AADD( aHeadOut, "Content-Type: application/json" )
	AADD( aHeadOut, "Authorization: key="+cApiKeySrv )		
	cJson := '{'
	cJson += 	'"to" : "' +cRegID +'",'
	cJson +=	'"notification" : { "body" : "Nova Ordem de Servico", "title" : "Tok Take App" }' +','
	cJson += 	'"data" : ' +cMsg 
	cJson += '}'
	cResponse := HttpPost( "http://fcm.googleapis.com/fcm/send", , cJson,nTimeOut,aHeadOut,@cHeadRet )	
EndIf

//Conout("# GOOGLE01 -> " +cHeadRet +" #")

Return cHeadRet