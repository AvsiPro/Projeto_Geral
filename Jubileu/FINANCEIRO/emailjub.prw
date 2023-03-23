#include "protheus.ch"
#include 'Ap5Mail.ch'
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTMAILN   บAutor  ณ Alexandre Venancio  บ Data ณ  09/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de emails                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function emailjub(cFrom,_cPara,cSubject,cBody,cAnexos,lConfirm)//,cCompEm)

    Local cUser := "", cPass := "", cSendSrv := ""
    Local cMsg := ""
    Local nSendPort := 0, nSendSec := 2, nTimeout := 0
    Local xRet
    Local oServer, oMessage
    Local cFile := cAnexos//"\data\cliente.csv"
    //Local nNumMsg := 1

    cUser :="cobranca@jubileudistribuidora.com"//"testemovidesk@clinicasinteligentes.com.br"//"thiagoprado_@hotmail.com" //define the e-mail account username

    cPass := "Ju142536!"//"12345678" //define the e-mail account password

    cSendSrv := "mail.exchangecorp.com.br"//"smtp.gmail.com"//"outlook.office365.com" // define the send server

    nTimeout := 60 // define the timout to 60 seconds


    oServer := TMailManager():New()

    oServer:SetUseSSL( .F. )
    oServer:SetUseTLS( .F. )

    if nSendSec == 0
        nSendPort := 25 //default port for SMTP protocol
    elseif nSendSec == 1
        nSendPort := 465 //default port for SMTP protocol with SSL
        oServer:SetUseSSL( .T. )
    else
        nSendPort := 587 //default port for SMTPS protocol with TLS
        oServer:SetUseTLS( .T. )
    endif

    // once it will only send messages, the receiver server will be passed as ""
    // and the receive port number won't be passed, once it is optional
    xRet := oServer:Init( "", cSendSrv, cUser, cPass, 0 , nSendPort )
    if xRet != 0
        cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
        conout( cMsg )
        return
    endif

    // the method set the timout for the SMTP server
    xRet := oServer:SetSMTPTimeout( nTimeout )
    if xRet != 0
        cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
        conout( cMsg )
    endif

    // estabilish the connection with the SMTP server
    xRet := oServer:SMTPConnect()
    if xRet <> 0
        cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
        conout( cMsg )
        return
    endif

    // authenticate on the SMTP server (if needed)
    xRet := oServer:SmtpAuth( cUser, cPass )
    if xRet <> 0
        cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
        conout( cMsg )
        oServer:SMTPDisconnect()
        return
    endif

    oMessage := TMailMessage():New()
    oMessage:Clear()

    oMessage:cDate := cValToChar( Date() )
    oMessage:cFrom := "cobranca@jubileudistribuidora.com"//"thiagoprado_@hotmail.com"

    oMessage:cTo := _cPara //"rodrigo.barreto@avsipro.com.br"//"thiago.pradototvs.com"//"cobranca@jubileudistribuidora.com"//
    oMessage:cCC := ''//cCompEm//cUserEm//"rodrigo.barreto@grupo377.com.br"//"thiago.prado@totvs.com.br;giovanna@bambinidecoracoes.com.br"

    oMessage:cSubject := cSubject//"Test"
    oMessage:cBody := cBody//"Email Test"
    //anexo

    If len(cFile) > 0
        xRet := oMessage:AttachFile( cFile )
        if xRet < 0
            cMsg := "Could not attach file " + cFile
            conout( cMsg )
            return
        endif
    EndIf
    xRet := oMessage:Send( oServer )
    if xRet <> 0
        cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
        conout( cMsg )
    endif

    xRet := oServer:SMTPDisconnect()
    if xRet <> 0
        cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
        conout( cMsg )
    endif
return .T.

