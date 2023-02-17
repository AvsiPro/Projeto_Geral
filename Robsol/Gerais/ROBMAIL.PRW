#include "protheus.ch" 
#include 'Ap5Mail.ch'
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTMAILN   �Autor  � Alexandre Venancio  � Data �  09/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envio de emails                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROBMAIL(cFrom,cTo,cSubject,cBody,aAttach,lConfirm,cCC,cBCC)

Local lRet			:= .F.  
Local oServer
Local oMessage
Local cMailServer	:= ""
Local cSmtpServer	:=  strtran(Alltrim( GetMV("MV_RELSERV") ),":587") //'smtp.avsipro.com.br'
Local cAccount		:=  'noreply@robsol.com.br' //Alltrim( GetMV("MV_RELACNT") ) // 'suporte@avsipro.com.br'
Local cPassword		:=  alltrim( GetMV("MV_RELPSW")  ) //'noreply50821955'
Local lAuth			:=  .T. //GETMV("MV_RELAUTH")
Local nMailPort		:= 0
Local nSmtpPort		:= 587
Local nI			:= 0
Local nErro			:= 0
Local cAttach		:= ""
Local cContent		:= ""
Default cFrom		:= ""
Default cTo			:= ""
Default cCC			:= ""
Default cBCC		:= ""
Default cSubject	:= ""
Default cBody		:= ""
Default aAttach		:= {}
Default lConfirm	:= .F.


If Empty(cFrom) .Or. Empty(cTo) .Or. Empty(cSubject)
	Conout("#TTMAILN: PARAMETROS DE ENTRADA INVALIDOS")
	Return lRet 
EndIf

If Empty(cSmtpServer) .Or. Empty(cAccount) .Or. Empty(cPassword)
	Conout("#TTMAILN: ERRO NOS PARAMETROS DE CONFIGURACAO DO EMAIL -> REVISAR MV_RELSERV/MV_RELAUSR/MV_RELAPSW")
	Return lRet
EndIf

// Cria a conex�o com o server STMP ( Envio de e-mail )
oServer := TMailManager():New()

oServer:Init( cMailServer, cSmtpServer, cAccount, cPassword, nMailPort, nSmtpPort )

// seta um tempo de time out com servidor de 1min
If oServer:SetSmtpTimeOut( 120 ) != 0
	Conout( "#TTMAILN: FALHA AO SETAR TIMEOUT" )
	Return lRet
EndIf
	  
// realiza a conexao SMTP
If oServer:SmtpConnect() != 0
	Conout( "#TTMAILN: FALHA AO CONECTAR" )
	//Return lRet
EndIf

// autentica no servidor SMTP
If lAuth
	nErro := oServer:SMTPAuth( cAccount, cPassword )
	If nErro != 0
		Conout( "#TTMAILN: ERRO AO AUTENTICAR -> ", oServer:GetErrorString( nErro ) )
		Return lRet
	EndIf   
EndIf

  
// Apos a conex�o, cria o objeto da mensagem
oMessage := TMailMessage():New()
  
// Limpa o objeto
oMessage:Clear()
  
// Popula com os dados de envio
oMessage:cFrom		:= cFrom
oMessage:cTo		:= cTo
oMessage:cCc		:= cCC
oMessage:cBcc		:= cBcc
oMessage:cSubject	:= cSubject
oMessage:cBody		:= cBody
oMessage:MsgBodyType( "text/html" )
  
// Adiciona um attach
For nI := 1 To Len(aAttach)
	cAttach := aAttach[nI][1]
	cContent := aAttach[nI][2]
	If File(cAttach)
		If oMessage:AttachFile( cAttach ) < 0
			Conout( "#TTMAILN: ERRO AO ATTACHAR O ARQUIVO" )
		Else
			//adiciona uma tag informando que � um attach e o nome do arq
			oMessage:AddAtthTag( cContent+";filename=" +cAttach ) //oMessage:AddAtthTag( "Content-ID: " +"<" +cContent +">" /*+";filename=" +cAttach*/ )
		EndIf
	Else
		Conout( "#TTMAILN: ARQUIVO ANEXO NAO ENCONTRADO -> " +cAttach )
	EndIf 
Next nI

// confirmacao de leitura  
If lConfirm
	oMessage:SetConfirmRead( .T. )
EndIf
	
// Envia o e-mail
nErro := oMessage:Send( oServer )
If nErro <> 0
	Conout( "#TTMAILN: ERRO AO ENVIAR O EMAIL -> ", oServer:GetErrorString( nErro ) )
Else
	lRet := .T.
EndIf

// Desconecta do servidor
If oServer:SmtpDisconnect() != 0
	Conout( "#TTMAILN: ERRO AO DESCONECTAR DO SERVIDOR SMTP" )
EndIf 
   
Return lRet


/*


*/
User Function EnviarEmail(cPara,cAssunto,cBody,cAtach,lLog)
	Local cServer := Alltrim( GetMV("MV_RELSERV") )
	Local cMail   := Alltrim( GetMV("MV_RELACNT") ) //'marketing@robsol.com.br' //
	Local cPass	  := Alltrim( GetMV("MV_RELPSW")  ) //'mkt50821955' //
	Local cErro
	
	Default cAtach  := if(cAtach==nil,"",cAtach)
	Default lLog    := if(lLog  == nil .Or. Empty(lLog),.f.,lLog)
	
	CONNECT SMTP SERVER cServer ACCOUNT cMail PASSWORD cPass RESULT lOk
	
	If !lOK
		cErro := MailGetErr()
		If !lLog
			//Alert("Erro ao Conectar o Servidor - "+cErro)
		Endif
		Return .F.
	Endif
	
	//Servidor de Autenticacao
	lRelauth := GetNewPar("MV_RELAUTH",.F.)
	
	If lRelAuth
		lOk := MailAuth( GetMV("MV_RELACNT") , GetMV("MV_RELPSW") )
		If !lOK
			cErro := MailGetErr()
			//Alert("Erro ao conectar com autenticacao - " + cErro)
			lOk := MailSmtpOff()
			Return .F.
		Endif
	Endif
	
	SEND MAIL FROM cMail TO cPara SUBJECT cAssunto BODY cBody ATTACHMENT cAtach RESULT lOK 
	
	If !lOK
		cErro := MailGetErr()

		if !lLog
			//Alert("Erro ao Enviar Mensagem - " + cErro)
		endif
		lOk := MailSmtpOff()
		Return .F.
	EndIf
	
	lOk := MailSmtpOff()
	
	If !lOK
		if !lLog
			//Alert("Erro ao Desconectar do Servidor")
		endif
		Return .F.
	EndIf

Return .T.
