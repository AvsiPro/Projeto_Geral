#include 'protheus.ch'
#include 'parmtype.ch'

/*/{@Protheus.doc} BRENVBOL
Preparando envio de e-mail
@type function
@version  1.0
@author Valdemir Rabelo
@since 16/01/2022
/*/
User Function BRENVBOL(cMail,cNome,cCGC,cNf,cSer,cLocal,cArq,clink,cCodV,cNFS)
	Local xmCorpo := ""
	Local cPath   := GetSrvProfString( 'Startpath' , '' )
	Local aAnexos := {}
	Local cCCEML  := GetMV('BR_MAILCOB',.f.,'faturamento@brasilrisk.com.br')  // Valdemir Rabelo 11/02/2024
	Local xmEnviou

	If Empty(cMail)
		FWAlertHelp('Email não pode ser enviado. Cliente: '+alltrim(cNome)+' sem Email cadastrado','Informar o e-mail no cadastro de clientes.')
		Return()
	Endif

	if lDebug
		MsgAlert( "Foi montado corpo do e-mail") 
	endif
	xmCorpo := CorpoEml(cNf,cNome,cCGC,clink,cCodV,cNFS)
	IF !Empty(cArq)
	   AADD(aAnexos, cLocal+cArq )
	Endif 
	if lDebug
		MsgAlert( "Entrando para ser gerado o arquivo do Mapa.") 
	endif		
	cMapa := U_BRPEDVEN(cNf,cSer)
	if lChk2        // Valdemir Rabelo 01/04/2022
	   __CopyFile(cMapa, cDirLocal+ RETFILENAME(cMapa) + ".pdf")
		if lDebug
			MsgAlert( "Realizado copia do arquivo do mapa, para maquina local.") 
		endif	   
	endif 
	IF !Empty(cMapa)
	   AADD(aAnexos,cMapa )
    Endif 
	xmEnviou := U_BRENMAIL({Alltrim(cMail),'Cobrança Brasil Risk',xmCorpo,cCCEML,cCCEML,aAnexos,""})

	If xmEnviou == 0
		//Aviso("Atenção","E-mail enviado com sucesso!",{"Sair"})
		if lDebug
			MsgAlert( "E-mail enviado com sucesso!.") 
		endif		
	Else
		//Aviso("Atenção","Ocorreu algum erro no envio do E-mail!",{"Sair"})
		FWMsgRun(,{|| Sleep(2000)},'Informativo',"Ocorreu algum erro no envio do E-mail!")
	Endif

return

/*/{@Protheus.doc} CorpoEml
description
Rotina que monta o corpo do e-mail
@type function
@version  1.0
@author Valdemir Rabelo
@since 16/01/2022
/*/
Static Function CorpoEml(_cDoc,_cNome,_cCgcC,_cLinkNFE,cCodV,cNFS)
	Local _cTexto      := ""
	Local cCompanyName := FWCompanyName()

	_cTexto := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
	_cTexto += '<HTML>'
	_cTexto += '<HEAD>'
	_cTexto += '<TITLE>Atenção</TITLE>'
	_cTexto += '<META NAME="GENERATOR" CONTENT="MAXs HTML Beauty++ ME">'
	_cTexto += '</HEAD>'
	_cTexto += '<BODY>'

	_cTexto += '<span style="font-size: 10.0pt; font-family: Courier New; color: black">'
	_cTexto += '<p>Caro cliente, <br>'
	_cTexto += '<br>'
	_cTexto += 'Essa mensagem se refere á nota de Serviços abaixo:<br>'
	_cTexto += '<br>'
	_cTexto += 'RPS: &nbsp; <b>' +_cDoc+ '</b> <br>'
	_cTexto += '<br>'
	_cTexto += 'Emitida Por:' + Alltrim(SM0->M0_NOMECOM) + '<br>'
	_cTexto += 'CNPJ: ' +Alltrim(SM0->M0_CGC) + '<br>'
	_cTexto += 'CCM: ' +Alltrim(SM0->M0_INSCM) + '<br>'
	_cTexto += '<br>'
	_cTexto += 'Tomador de serviço: <br>'
	_cTexto += 'Razão Social <b>' +_cNome+ '</b><br>'
	_cTexto += 'CNPJ: <b>' +_cCgcC+ '</b><br>'
	_cTexto += '<br>'
	_cTexto += '<br>'
	If !Empty(_cLinkNFE)
		_cTexto	+= 'Se preferir, visualize a nota fiscal de serviço no endereço: <br>'
		_cTexto	+= '<br>'
		_cTexto	+= '<a href="'+_cLinkNFE+'">'+_cLinkNFE+'</a><br>'
	EndIf
	_cTexto	+= '<p>Dados para acesso a nota fiscal de serviço:<br>'
	_cTexto	+= '&nbsp;</p>'
	_cTexto	+= '<p>CNPJ tomador: '+Alltrim(SM0->M0_CGC)+'</p>'
	_cTexto	+= '<p>Número da Nota: '+cNFS+'</p>'
	_cTexto	+= '<p>Código de Verificação: '+cCodV+'</p>'
	_cTexto	+= '<p><br>'
	_cTexto	+= '<br>'
	_cTexto	+= '<br>'
	_cTexto += '<span style="font-size: 10.0pt; font-family: Courier New; color: black"> '
	_cTexto += 'Ficamos à sua disposição para quaisquer dúvidas.</span></p><BR>'
	_cTexto += '<span style="font-size: 10.0pt; font-family: Courier New; color: black"> '
	_cTexto += '<B>Dúvidas sobre Notas:</B>'
	_cTexto += '<p>Faturamento - faturamento@brktecnologia.com.br'
	_cTexto += '<p>Fone: (11) 91327-7759 / (11) 94071-1355<BR><BR>'
	_cTexto += '<B>Dúvidas sobre boletos e conciliações:</B>'
	_cTexto += '<p>Contas a Receber - cobranca@brktecnologia.com.br'
	_cTexto += '<p>Fone: (11) 97651-2783 / (11) 94071-1355<BR><BR>'	

    _cTexto += '<p class="MsoNormal">'
    _cTexto += '<span style="font-size: 10.0pt; font-family: Courier New; color: black">Desde já '
    _cTexto += 'agradecemos!</span></p><BR>'  

    _cTexto += '<p class="MsoNormal">&nbsp;</p>'
    _cTexto += '<table border="0" width="50%">'
    _cTexto += '	<tr>'
    _cTexto += '		<td>'
    _cTexto += '		<span style="font-size: 10.0pt; font-family: Courier New; color: black">'
    _cTexto += '		'+cCompanyName+'.</span></td>'
    _cTexto += '	</tr>'
    _cTexto += '	<tr>'
    _cTexto += '		<td><span style="font-size: 10.0pt; font-family: Courier New; color: black">Rua Werner Von Siemens, 111 - Lapa de Baixo</span></td>'
    _cTexto += '	</tr>'
    _cTexto += '	<tr>'
    _cTexto += '		<td><span style="font-size: 10.0pt; font-family: Courier New; color: black">CEP: 05069-900 - São Paulo - SP</span></td>'
    _cTexto += '	</tr>'
    _cTexto += '	<tr>'
    _cTexto += '		<td><span style="font-size: 10.0pt; font-family: Courier New; color: black">site: www.brktecnologia.com.br</span></td>'
    _cTexto += '	</tr>'
    _cTexto += '</table>'
    _cTexto += '<span style="font-size: 10.0pt; font-family: Courier New; color: black"> '
    _cTexto += 'Aproveite para adicionar o e-mail faturamento.brk@brktecnologia.com.br como seguro,'
    _cTexto += 'e assim garantir o recebimento de todas as Notas e Boletos enviados pela '
    _cTexto += 'BRK GERENCIAMENTO DE RISCOS LTDA, evitando que sejam direcionados para seu lixo'
    _cTexto += 'eletrônico ou spam.'
    _cTexto += '</span></p><BR>'   

	_cTexto	+= '&nbsp;</p>'
	_cTexto += '</BODY>'
	_cTexto += '</HTML>'

Return(_cTexto)
