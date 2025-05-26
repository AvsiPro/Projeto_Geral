#include 'protheus.ch'
#include 'parmtype.ch'


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa      ³Envemail                                        º Data ³ 22/07/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao     ³ Funçao para envio de email                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desenvolvedor ³ Natalia Perioto	     º Empresa ³ Totvs Nacoes Unidas	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÊÍÍÍÍÍÍËÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Linguagem     ³ eAdvpl     º Versao ³ 12    º Sistema ³ Microsiga                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Modulo(s)     ³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Tabela(s)     ³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observacao    ³ Array com dados do email                                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function BRENMAIL(aEmail)

	/*---------------------------
	aEmail[1] -> Destinatário
	aEmail[2] -> Assunto
	aEmail[3] -> Corpo E-mail
	aEmail[4] -> Copia
	aEmail[5] -> Copia Oculta
	aEmail[6] -> Caminho do Arquivo Anexo
	aEmail[7] -> Email remetente
	----------------------------*/

	Local oMail := tMailManager():NEW()
	Local nRet := 0     
	Local lUseSSL      := GetMv("MV_RELSSL")
	Local cAtivaPr     := GetMV("MV_ATVEMLP",.F.,"")    // Valdemir Rabelo 14/02/2024

	Local cFrom        := Alltrim(GetMV("FS_MAILBOL"))
	Local cUser        := cFrom      // Alterado por Valdemir Rabelo 05/10/2023 - //SubStr(cFrom, 1, At('@', cFrom)-1)
	Local cPass        := Alltrim(GetMV("FS_SMAILBO"))
	Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
	Local cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
	Local nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
	Local nAtual

	//oPopServer     := TMailManager():New() 
	oMail:SetUseSSL(lUseSSL)    //Obs: Apenas se servidor de e-mail utiliza autenticacao SSL para envio
	oMail:SetUseTLS(.T.)     //Obs: Apenas se servidor de e-mail utiliza autenticacao TLS para recebimento      

	oMail:Init("", cServer, cUser, cPass, 0, nPort)

	nret := oMail:SetSMTPTimeout(60) //1 min

	If nRet == 0
		conout("SetSMTPTimeout Sucess")
	Else
		conout(nret)
		conout(oMail:GetErrorString(nret))
	Endif


	nret := oMail:SMTPConnect()

	If nRet == 0
		conout("Sucess Connecting to SMTP")
	Else
		conout(nret)
		conout(oMail:GetErrorString(nret))
	Endif
	//------------------------------------autenticação----------------------------------

	// try with account and pass
	nRet := oMail:SMTPAuth(cUser, cPass)
	If nRet != 0
		conout("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
		conout("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
		
		conout("[AUTH] TRY with USER() and PASS()")
		// try with user and pass
		nRet := oMail:SMTPAuth(cFrom, cPass)
		If nRet != 0
			conout("[AUTH] FAIL TRY with USER() and PASS()")
			conout("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			Return nRet
		else
			conout("[AUTH] SUCEEDED TRY with USER() and PASS()")
		Endif
	else
		conout("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
	Endif

	//----------------------------------------------------------------------------------

	//Apos a conexão, cria o objeto da mensagem
	oMessage := TMailMessage():New()
	
	//Limpa o objeto
	oMessage:Clear()
   
    //Popula com os dados de envio
	oMessage:cFrom              := cFrom
	oMessage:cTo                := IIF(!EMPTY( cAtivaPr ),Alltrim(aEmail[1]),"valdemir_sistemas@hotmail.com;claudio.yoshiro@tnuservicos.com.br")+';'+aEmail[4]    // Valdemir Rabelo 14/02/2024
	oMessage:cCc                := aEmail[4]
	oMessage:cBcc               := aEmail[5]
	oMessage:cSubject           := aEmail[2]
	oMessage:cBody              := aEmail[3]
	
	aAnexos :=  aEmail[6]

	//Percorre os anexos
	For nAtual := 1 To Len(aAnexos)
				
		//Se o arquivo existir
		If File(aAnexos[nAtual])
	
			//Anexa o arquivo na mensagem de e-Mail
			nRet := oMessage:AttachFile(aAnexos[nAtual])
			If nRet < 0
				Conout( "Erro ao atachar o arquivo"+aAnexos[nAtual]+"!" )
				Return nRet
			EndIf
	
		//Senao, acrescenta no log
		Else
			Conout( "arquivo"+aAnexos[nAtual]+" nao encontrado!")
			nRet := 1
			Return nRet
			
		EndIf
	Next

	nRet := oMessage:Send( oMail )

	If nRet == 0
		conout("SendMail Sucess")
		if FWISINCALLSTACK( "U_JOBENVBO" )    // Valdemir Rabelo 14/02/2024
		   IF SE1->( FIELDPOS( "E1_XENVJOB" )) > 0
			RecLock("SE1",.F.)
				SE1->E1_XENVJOB := "S"
			MsUnlock()
		   Endif 
		Endif 
	Else
		conout(nret)
		conout(oMail:GetErrorString(nret))
	Endif

	oMail:SmtpDisconnect()
	
return  nret
