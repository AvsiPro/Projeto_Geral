#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"   
#include "ap5mail.ch"

#DEFINE CRLF Chr(13)+Chr(10)
#DEFINE TAB  Chr(09)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  U_ENVWORK � Autor�Gabriel Melo De Campos� Data �14/08/2020���
�������������������������������������������������������������������������Ĵ��
��                                                                        ���
�������������������������������������������������������������������������Ĵ��
���Descricao � ROTINA PADRAO PARA ENVIO DE E-MAIL CONFORME PARAMETROS     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Parametro Tipo Descricao                                   ��� 
���          � _cPara    C                                                ���
���          � _cCc      C                                                ���
���          � _cBCC     C                                                ���
���          � _cTitulo  C                                                ���
���          � _aAnexo   A                                                ���
���          � _cMsg     C                                                ���
���          � _lAudit   L                                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � LOGICO -> (.T.) ENVIO OK / (.F.) FALHA NO ENVIO            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao � GENERICO                                                   ���
���          �   u_ENVWORK("teste@teste.com.br",;     //_cPara            ���
���          �             "teste@teste.com.br",;     //_cCc              ���
���          �             "",;                         //_cBCC           ���
���          �             "Rotina de Importacao XML",; //_cTitulo        ���
���          �             aDados,;                     //_aAnexo         ���
���          �             cMsg,;                       //_cMsg           ���
���          �             .T.)                         //_lAudit         ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � ADICIONAR A TAG ABAIXO NO APPSERVER CASO HAJA PROBLEMAS:   ���
���          �    [MAIL]                                                  ���
���          �    AUTHLOGIN=1                                             ���
���          �    AUTHNTLM=0                                              ���
���          �    ExtendSMTP=1                                            ���
���          �    Protocol=POP3                                           ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.    �  Data  � Manutencao Efetuada                       ���
�������������������������������������������������������������������������Ĵ��
���GABRIEL MELO DE CAMPOS�14/08/2020�Desenvolvimento da rotina U_ENVWORK()���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function ENVWORK(_cPara,_cCc,_cBCC, _cTitulo, _aAnexo, _cMsg, _lAudit, _cMailFrom)
Local oMail
Local oMessage
Local nRet
Local nTimeout		:= GetMV("MV_RELTIME")		//Timeout no Envio de E-Mail;
Local cServer		:= GetMV("MV_RELSERV")		//Nome do Servidor de Envio de E-Mail utilizado nos relatorios;
Local cEmail		:= GetMV("MV_RELACNT")		//Conta a ser utilizada no envio de E-Mail para os relatorios;
Local cEmailA		:= GetMV("MV_RELAUSR")		//Usuario para Autenticacao no Servidor de E-Mail;
Local cEmailFr		:= GetMV("MV_RELFROM")		//E-Mail utilizado no campo FROM no envio de relatorios por E-Mail;
Local cPass			:= GetMV("MV_RELPSW")		//Senha da Conta de E-Mail para envio de relatorios;
Local lAuth			:= GetMV("MV_RELAUTH")		//Servidor de E-Mail necessita de Autenticacao? Determina se o Servidor necessita de Autenticacao;
Local cMailAud		:= GetMV("MV_MAILADT")		//Conta oculta de auditoria utilizada no envio de E-Mail para os relatorios;
Local lUseSSL		:= GetMV("MV_RELSSL")		//Define se o envio e recebimento de E-Mail na rotina SPED utilizara conexao segura (SSL);
Local lUseTLS		:= GetMV("MV_RELTLS")		//Informe se o servidor de SMTP possui conexao do tipo segura (SSL/TLS);
Local _nPorta		:= GetMV("MV_POPPORT")		//Porta Default;
DEFAULT _cPara		:= ""
DEFAULT _cCc		:= ""
DEFAULT _cBCC		:= ""
DEFAULT _cMsg		:= ""
DEFAULT _aAnexo		:= {}
DEFAULT _cTitulo	:= ""
DEFAULT _lAudit		:= .F.
DEFAULT _cMailFrom	:= "" 

If _cMailFrom == GetMV("MV_RELFROM")

	cEmail	 := GetMV("MV_RELACNT")
	cEmailA  := GetMV("MV_RELAUSR")
	cEmailFr := GetMV("MV_RELFROM")
	cPass	 := GetMV("MV_RELPSW")
	
EndIf

	/*-----------+-----------------------------------------------------------------------------+----------------------+----------------------+------------------------+
	| PARAMETRO  | DESCRICAO                                                                   | EXEMPLO E-MAIL TOTVS | EXEMPLO E-MAIL GMAIL | EXEMPLO E-MAIL LOCAWEB |
	+------------+-----------------------------------------------------------------------------+----------------------+----------------------+------------------------+
	| MV_MAILADT |Conta oculta de auditoria utilizada no envio de E-Mail para os relatorios; ..|email@dominio.com.br  |email@dominio.com.br  |email@dominio.com.br    |
	| MV_RELACNT |Conta a ser utilizada no envio de E-Mail para os relatorios; ................|usuario               |usuario@gmail.com     |nfe@pradolux.com.br     |
	| MV_RELAUSR |Usuario para Autenticacao no Servidor de E-Mail; ............................|usuario               |usuario@gmail.com     |nfe@pradolux.com.br     |
	| MV_RELAUTH |Servidor de E-Mail necessita de Autenticacao? Determina se o Servidor........|.T.                   |.T.                   |.T.                     |
	|            |necessita de Autenticacao; ..................................................|                      |                      |                        |
	| MV_RELFROM |E-Mail utilizado no campo FROM no envio de relatorios por E-Mail; ...........|usuario@totvs.com.br  |usuario@gmail.com     |nfe@pradolux.com.br     |
	| MV_RELPSW  |Senha da Conta de E-Mail para envio de relatorios; ..........................|*** senha ***         |*** senha ***         |*** senha ***           |
	| MV_RELSERV |Nome do Servidor de Envio de E-Mail utilizado nos relatorios; ...............|mail.totvs.com.br:587 |smtp.gmail.com:465    |smtp.pradolux.com.br:587|
	| MV_RELSSL  |Define se o envio e recebimento de E-Mail na rotina SPED utilizara conexao...|.F.                   |.T.                   |.F.                     |
	|            |segura (SSL); ...............................................................|                      |                      |                        |
	| MV_RELTIME |Timeout no Envio de E-Mail; .................................................|120                   |120                   |120                     |
	| MV_RELTLS  |Informe se o servidor de SMTP possui conexao do tipo segura (SSL/TLS); ......|.T.                   |.F.                   |.F.                     |
	+------------+-----------------------------------------------------------------------------+----------------------+----------------------+-----------------------*/

	ProcRegua(15)


	//---------------------------------------------------------------------------------------------------------------------
	//CASO O ENDERECO DO SERVER TENHA A PORTA INFORMADA, SEPARA OS CAMPOS
	If(At(":",cServer) > 0)
		_nPorta := Val(Substr(cServer,At(":",cServer)+1,Len(cServer)))
		cServer := Substr(cServer,0,At(":",cServer)-1)
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CRIA UMA INSTANCIA DA CLASSE TMAILMANAGER
	oMail := TMailManager():New()
	If(lUseSSL)
		oMail:SetUseSSL(lUseSSL)
	EndIf
	If(lUseTLS)
		oMail:SetUseTLS(lUseTLS)
	EndIf 
	
    IF alltrim(FUNNAME()) == 'MONWORFLW'
    cEmail	 := GetMV("MV_RELACNT")
	cEmailA  := GetMV("MV_RELAUSR")
	cEmailFr := GetMV("MV_RELFROM")
	cPass	 := GetMV("MV_RELPSW")

    endif
	
   	//---------------------------------------------------------------------------------------------------------------------
	//DEFINE AS CONFIGURACOES, DA CLASSE TMAILMANAGER, PARA REALIZAR UMA CONEXAO COM O SERVIDOR DE E-MAIL
	oMail:Init("",cServer,cEmail,cPass,0,_nPorta)

	//---------------------------------------------------------------------------------------------------------------------
	//DEFINE O TEMPO DE ESPERA PARA UMA CONEXAO ESTABELECIDA COM O SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL)
	If (nTimeout <= 0)
		ConOut("[TIMEOUT] DISABLE")
	Else
		IncProc("[TIMEOUT] ENABLE()")
		ConOut("[TIMEOUT] ENABLE()")
		nRet := oMail:SetSmtpTimeOut(nTimeout)

		If nRet != 0
			ConOut("[TIMEOUT] Fail to set")
			ConOut("[TIMEOUT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			MsgBox("[TIMEOUT][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao ENVWORK","STOP")
			oMail:SMTPDisconnect()
			Return(.F.)
		EndIf
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CONECTA COM O SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL)
	IncProc("[SMTPCONNECT] connecting ...")
	ConOut("[SMTPCONNECT] connecting ...")
	nRet := oMail:SmtpConnect()
	If nRet <> 0
		ConOut("[SMTPCONNECT] Falha ao conectar")
		ConOut("[SMTPCONNECT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		MsgBox("[SMTPCONNECT][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao ENVWORK","STOP")
		oMail:SMTPDisconnect()
		Return(.F.)
	Else
		ConOut("[SMTPCONNECT] Sucesso ao conectar")
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//REALIZA A AUTENTICACAO NO SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL) PARA ENVIO DE MENSAGENS
	If lAuth
		IncProc("[AUTH] ENABLE")
		ConOut("[AUTH] ENABLE")
		ConOut("[AUTH] TRY with ACCOUNT() and PASS()")

		nRet := oMail:SMTPAuth(cEmailA,cPass)
		If nRet != 0
			IncProc("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			ConOut("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			ConOut("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			ConOut("[AUTH] TRY with USER() and PASS()")
			MsgBox("[AUTH][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao ENVWORK","STOP")
			nRet := oMail:SMTPAuth(cEmailA,cPass)

			If nRet != 0
				ConOut("[AUTH] FAIL TRY with USER() and PASS()")
				ConOut("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
				MsgBox("[AUTH][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao ENVWORK","STOP")
				oMail:SMTPDisconnect()
				Return(.F.)
			Else
				IncProc("[AUTH] SUCEEDED TRY with USER() and PASS()")
				ConOut("[AUTH] SUCEEDED TRY with USER() and PASS()")
			EndIf
		Else
			IncProc("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
			ConOut("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
		EndIf
	Else
		IncProc("[AUTH] DISABLE")
		ConOut("[AUTH] DISABLE")
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//CRIA UMA INSTANCIA DA CLASSE TMAILMANAGER
	IncProc("[MESSAGE] Criando mail message")
	ConOut("[MESSAGE] Criando mail message")
	oMessage := TMailMessage():New()
	oMessage:Clear()
	oMessage:cFrom    := cEmailFr
	oMessage:cTo      := _cPara
	oMessage:cCc      := _cCc
	oMessage:cBCC     := IIF(_lAudit, cMailAud, "") 	
	oMessage:cSubject := _cTitulo
	oMessage:cBody    := _cMsg
	
	For _nX := 1 to Len(_aAnexo)
		oMessage:AddAttHTag("Content-ID: <" + _aAnexo[_nX][01] + ">")	//Essa tag, � a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
		oMessage:AttachFile(_aAnexo[_nX][02])							//Adiciona um anexo, nesse caso a imagem esta no root
	Next _nX
	oMessage:MsgBodyType("text/html")

	//---------------------------------------------------------------------------------------------------------------------
	//ENVIA E-MAIL ATRAV�S DO PROTOCOLO SMTP
	IncProc("[SEND] Sending ...")
	ConOut("[SEND] Sending ...")
	nRet := oMessage:Send(oMail)
	If nRet <> 0
		ConOut("[SEND] Fail to send message")
		ConOut("[SEND][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		MsgBox("[SEND][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao ENVWORK","STOP")
		oMail:SMTPDisconnect()
		Return(.F.)
	Else
		IncProc("[SEND] Success to send message")
		ConOut("[SEND] Success to send message")
	EndIf

	//---------------------------------------------------------------------------------------------------------------------
	//FINALIZA A CONEXAO ENTRE A APLICACAO E O SERVIDOR DE E-MAIL SMTP (SIMPLE MAIL TRANSFER PROTOCOL)
	IncProc("[DISCONNECT] smtp disconnecting ... ")
	ConOut("[DISCONNECT] smtp disconnecting ... ")
	oMail:SMTPDisconnect()
	If nRet != 0
		IncProc("[DISCONNECT] Fail smtp disconnecting ... ")
		ConOut("[DISCONNECT] Fail smtp disconnecting ... ")
		ConOut("[DISCONNECT][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		MsgBox("[DISCONNECT][ERROR] " + str(nRet,6) + " - " + oMail:GetErrorString(nRet),"Funcao ENVWORK","STOP")
	Else
		IncProc("[DISCONNECT] Success smtp disconnecting ... ")
		ConOut("[DISCONNECT] Success smtp disconnecting ... ")
	EndIf

Return(.T.)
