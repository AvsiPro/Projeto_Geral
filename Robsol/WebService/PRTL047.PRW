#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"
#include "fileio.ch"
#include "rwmake.ch"

#Define Enter Chr(13)+Chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} PRTL047
Descricao: Servico API Rest Evento upload de PDFs

@author Felipe Mayer
@since 27/09/2022
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
USER Function PRTL047()
Return

// Servico.
WsRestFul PRTL047 DESCRIPTION "API REST - Upload de PDFs | PORTAL ROBSOL " 
	
	WsMethod POST Description "API REST - Upload de PDFs - METODO POST "  WsSyntax "PRTL047"

End WsRestFul
//-------------------------------------------------------------------
/*/{Protheus.doc} Metodo Post | Evento Implantacao 
Descricao: 	Servico Rest contendo o Metodo POST do evento de 
				Portal Robsol

@author Felipe Mayer
@since 27/09/2022
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
WsMethod POST WsReceive RECEIVE WsService PRTL047

	Local cCode			As Character 
	Local cMessage		As Character
	Local cCode64		As Character
	Local cNome			As Character
	Local cPedido		As Character
	Local cEmail		As Character
	Local cEmp			As Character
	Local cFil			As Character
	Local lRet			As Logical 
	Local oBody			As J

	cCode	:= ''
	cMessage	:= ''
	lRet	:= .T.

	conout("chegou aqui PRTL047")

	oBody  := JsonObject():New()

	If ValType(oBody:fromJson( AllTrim( self:getContent() ) )) != 'U'	
		cCode 		:= "#500"
		cMessage	:= "Formato Json nao reco`nhecido. Revisar a estrutura e layout informado."
		lRet		:= .F.
	Else
		cEmp := '01'
		cFil := '0103'

		cCode64 := oBody:getJsonText("CODE64")
		cNome	:= cFil+oBody:getJsonText("NOME")
		cPedido := oBody:getJsonText("PEDIDO")
		cEmail  := oBody:getJsonText("EMAIL")
		
		If !ExistDir("\clientes\cnpj\updpdf")
			MakeDir("\clientes\cnpj\updpdf")
		EndIf

		oFWriter := FWFileWriter():New("\clientes\cnpj\updpdf\"+cNome, .T.)

		If oFWriter:Create()
			oFWriter:Write(Decode64(cCode64))
			oFWriter:Close()
		EndIf

		sleep(3000)

		RpcSetType(3)
		RPCSetEnv(cEmp,cFil)

		GERHTML(cPedido,GetSrvProfString("Startpath","")+"clientes\cnpj\updpdf\"+cNome,/*cEmail*/'cnoculos@hotmail.com')

		cCode 	 := "#200"
		cMessage := "Enviado e-mail com a copia do pedido"
		lRet 	 := .T.

	EndIf

	//-> Mensagem de Retorno da requisicao
	self:setContentType("application/json")
	self:setResponse(fwJsonSerialize(StatReq(cCode,cMessage)))

	// Realiza o fechamento do Ambiente
	RpcClearEnv()
	Freeobj(oBody)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} StatReq
Descricao: 	Realiza o Tratamento para envio de Mensagem de Retorno 
				da API 

@author Felipe Mayer
@since 27/09/2022
@version 1.0

@Param: 
	cCode 	= 	Codigo do Erro que sera informado no Retorno da API
	cMessage	= 	Mensagem de Retorno que sera informado no Retorno 
					da API

/*/
//-------------------------------------------------------------------
Static Function StatReq(cCode As Character, cMessage As Character) As J

	Local oJsonBody	As J
	Local oJsonRet 	As J

	Default cCode		:= ''
	Default cMessage	:= ''

	//Cria o Objeto de Retono da RequisiÃ§Ã£o.
	oJsonRet  := JsonObject():New()
	oJsonRet["statusrequest"] := {}

	oJsonBody := JsonObject():New()
	oJsonBody["code"]      := cCode
	oJsonBody["message"]   := cMessage

	AAdd( oJsonRet["statusrequest"], oJsonBody )

Return oJsonRet


Static Function fRemoveCarc(cWord)

    cWord := strtran(cWord,"ã","a")
	cWord := strtran(cWord,"á","a")
	cWord := strtran(cWord,"à","a")
	cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,",","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, ">", "")
    cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "(", "")
    cWord := StrTran(cWord, ")", "")
    cWord := StrTran(cWord, "_", "")
    cWord := StrTran(cWord, "=", "")
    cWord := StrTran(cWord, "+", "")
    cWord := StrTran(cWord, "{", "")
    cWord := StrTran(cWord, "}", "")
    cWord := StrTran(cWord, "[", "")
    cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, "\", "")
    cWord := StrTran(cWord, "|", "")
    cWord := StrTran(cWord, ":", "")
    cWord := StrTran(cWord, ";", "")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := Alltrim(cWord)
Return cWord


Static Function GERHTML(cPedido,cArq,cEmail)

Default cEmail := 'alexandre.venancio@avsipro.com.br'

Local cHtml 	:= ''
Local cRemete   := "Marketing Robsol <marketing@robsol.com.br>"                               
Local cSubject	:=	"Pedido de Venda"
Local aArquivos := {}           
Local cDestino	:=	cEmail
Local lEnviar	:=	.F.

cHtml := '<h1 style="color: #5e9ca0;">Pedido de Venda Gerado!</h1>'
cHtml += '<h2 style="color: #2e6c80;">Seu pedido foi gerado com sucesso!!!</h2>
cHtml += '<p>Seu pedido foi gerado em nossa base e logo estaremos realizando o atendimento para realiza&ccedil;&atilde;o da entrega das mercadorias.</p>
cHtml += '<h2 style="color: #2e6c80;">Informa&ccedil;&otilde;es do pedido: Pedido numero '+cPedido+'</h2>
cHtml += '<table class="editorDemoTable" style="width: 544px; height: 72px;">
cHtml += '<thead>
cHtml += '<tr style="height: 18px;">
cHtml += '<td style="width: 148.188px; height: 18px;">Produto</td>
cHtml += '<td style="width: 231.95px; height: 18px;">Descri&ccedil;&atilde;o</td>
cHtml += '<td style="width: 60.575px; height: 18px;">Qtd</td>
cHtml += '<td style="width: 77.2875px; height: 18px;">Valor</td>
cHtml += '</tr>
cHtml += '</thead>
cHtml += '<tbody>

DbSelectArea("SC6")
DbSetOrder(1)
If Dbseek(xFilial("SC6")+AvKey(cPedido,"C6_NUM"))
	While !EOF() .And. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cPedido
		cHtml += '<tr style="height: 18px;">
		cHtml += '<td style="width: 148.188px; height: 18px;">'+ALLTRIM(SC6->C6_PRODUTO)+'</td>'
		cHtml += '<td style="width: 231.95px; height: 18px;">'+ALLTRIM(SC6->C6_DESCRI)+'</td>'
		cHtml += '<td style="width: 60.575px; height: 18px;">'+TRANSFORM(SC6->C6_QTDVEN,"@E 9999")+'</td>'
		cHtml += '<td style="width: 77.2875px; height: 18px;">'+TRANSFORM(SC6->C6_PRCVEN,"@E 999,999,999.99")+'</td>'
		cHtml += '</tr>'
		lEnviar := .T.
		Dbskip()
	EndDo
endif

cHtml += '</tbody>
cHtml += '</table>
cHtml += '<p><strong>&nbsp;</strong></p>
cHtml += '<p>&nbsp;</p>'

If lEnviar
	Aadd(aArquivos,{cArq,''})
	U_robmail(cRemete,cDestino,cSubject,cHtml,aArquivos,.T.)
EndIf 

Return 
