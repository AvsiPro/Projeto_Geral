#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXGAPI05   บAutor  ณMicrosiga           บ Data ณ  08/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function XGAPI05(nTipo, cRegID,cMsg)

Local nTimeOut := 5000
Local cResponse := ""
Local aHeadOut := {}
Local cHeadRet := ""
Local cUrlServ := "190.120.30.105:81/push/gcm_server_php/send_message.php"
Local cUrlGCM	:= 'https://android.googleapis.com/gcm/send'
Local cApiKeySrv := "AIzaSyCuzMSNZUZ63-Wzn6npVrVZaXr0nELZnO4"

Default nTipo := 1
Default cRegID := "APA91bEg3bSnhKlVeHENLu24-4WJDI3eSjFHZL3ntIOJyIskSx9ht8SJOI4bOu2x35BP3UPIqgIPqCIKb60dsgGISwSsHxcFRM_nlpbi4TVPa72tGdYIv9uK39rCt8CC4jZFA9rmaKEg" //"APA91bFK95yeRiqwlnelud0tAdHtol4M7O6NJsqwZk6xHNropdi7CBQORbGDdPoV28wr26DKcijkWvlGFVrrkUXESMTzyy9dNc84-sNo4630gXx0hgmn7AzCJLYd9GDFYV_y9_-qlcGw58QObPI2wGncyoxDcaA0_g"
Default cMsg := "TESTE"

If Empty(cRegID)
	Return
EndIf     
If cEmpAnt <> "01"
	Return
EndIf

// Envia direto para o aparelho via Google Cloud Messaging
If nTipo == 1
	AADD( aHeadOut, "Content-Type: application/x-www-form-urlencoded" )
	AADD( aHeadOut, "Authorization: key="+cApiKeySrv )	
	cResponse := HttpPost( cUrlGCM, , "registration_id="+cRegID +"&data.msg="+cMsg,nTimeOut,aHeadOut,@cHeadRet )
	Conout("GCM-1: " +cHeadRet)

// Envia para servidor intermediario	     
ElseIf nTipo == 2
	cResponse := HTTPCGet( cUrlServ ,"?regId="+cRegID +"&message="+cMsg,nTimeOut,aHeadOut,@cHeadRet )
	Conout("GCM-2: " +cHeadRet)
EndIf	

Return