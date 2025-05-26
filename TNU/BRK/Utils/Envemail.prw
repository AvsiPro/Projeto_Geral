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

user function Envemail(aEmail)

/*---------------------------
aEmail[1] -> Destinatário
aEmail[2] -> Assunto
aEmail[3] -> Corpo E-mail
aEmail[4] -> Copia
aEmail[5] -> Copia Oculta
aEmail[6] -> Caminho do Arquivo Anexo
aEmail[7] -> Email remetente
----------------------------*/
Local cACCOUNT       :=  'brasil risk'
Local cFULL          :=  'brasilrisk2020@gmail.com'
Local cPASSWORD      :=  'brasil2020'
Local cSMTPSERVER    :=  'smtp.gmail.com'

Local oMail := tMailManager():NEW()
Local nRet := 0     
//Local lUseSSL           := GetMv("MV_RELSSL")

//oPopServer     := TMailManager():New() 
//oMail:SetUseSSL(lUseSSL)    //Obs: Apenas se servidor de e-mail utiliza autenticacao SSL para envio
oMail:SetUseTLS(.T.)     //Obs: Apenas se servidor de e-mail utiliza autenticacao TLS para recebimento      

oMail:Init("", cSMTPSERVER, cACCOUNT, cPASSWORD,0,587)

nret := oMail:SetSMTPTimeout(60) //1 min

If nRet == 0
	ALERt("SetSMTPTimeout Sucess")
Else
	//conout(nret)
	//conout(oMail:GetErrorString(nret))
	ALERt(oMail:GetErrorString(nret))
Endif


nret := oMail:SMTPConnect()

If nRet == 0
	ALERt("Sucess Connecting to SMTP")
Else
	//conout(nret)
	//conout(oMail:GetErrorString(nret))
	ALERt(oMail:GetErrorString(nret))
Endif
//------------------------------------autenticação----------------------------------

		// try with account and pass
		nRet := oMail:SMTPAuth(cFULL, cPASSWORD)
		If nRet != 0
			//conout("[AUTH] FAIL TRY with ACCOUNT() and PASS()")
			//conout("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
			ALERT("[AUTH] FAIL TRY with ACCOUNT() and PASS() " + oMail:GetErrorString(nRet))
			
			//conout("[AUTH] TRY with USER() and PASS()")
			// try with user and pass
			nRet := oMail:SMTPAuth(cACCOUNT, cPASSWORD)
			If nRet != 0
				//conout("[AUTH] FAIL TRY with USER() and PASS()")
				//conout("[AUTH][ERROR] " + str(nRet,6) , oMail:GetErrorString(nRet))
				ALERT("[AUTH] FAIL TRY with USER() and PASS() " + oMail:GetErrorString(nRet))
				Return nRet
			else
				//conout("[AUTH] SUCEEDED TRY with USER() and PASS()")
				ALERt("SUCEEDED TRY with USER() and PASS()")
			Endif
		else
			//conout("[AUTH] SUCEEDED TRY with ACCOUNT and PASS")
			ALERt("SUCEEDED TRY with ACCOUNT and PASS()")
		Endif

//----------------------------------------------------------------------------------

 //Apos a conexão, cria o objeto da mensagem
  oMessage := TMailMessage():New()
   
  //Limpa o objeto
  oMessage:Clear()
   
  //Popula com os dados de envio
  If !Empty(Alltrim(aEmail[7]))
  	oMessage:cFrom              := Alltrim(aEmail[7])
  Else
  	oMessage:cFrom              := cFULL
  Endif	
  oMessage:cTo                := Alltrim(aEmail[1])
  oMessage:cCc                := aEmail[4]
  oMessage:cBcc               := aEmail[5]
  oMessage:cSubject           := aEmail[2]
  oMessage:cBody              := aEmail[3]
  
If !Empty(aEmail[6])  
   
  //Adiciona um attach
  If oMessage:AttachFile( aEmail[6] ) < 0
    ALERT( "Erro ao atachar o arquivo" )
    Return .F.
  EndIf
Endif  

nRet := oMessage:Send( oMail )

If nRet == 0
	ALERT("SendMail Sucess")
Else
	//conout(nret)
	ALERT(oMail:GetErrorString(nret))
Endif


oMail:SmtpDisconnect()



/*nRet := oMail:SendMail(EMAIL_FULL ,;
         aEmail[1] ,;
         aEmail[2] ,;
         aEmail[3] ,;
         aEmail[4],;
         aEmail[5],; 
         {aEmail[6]} ,;
         1 )
//cFrom;cTo;cSubject;cBody;cCC;cBCC;aAttach;nNumAttach         

If nRet == 0
	conout("SendMail Sucess")
Else
	conout(nret)
	conout(oMail:GetErrorString(nret))
Endif


	oMail:SmtpDisconnect()*/
	
return  nret
