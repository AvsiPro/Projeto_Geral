#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://integracaototvsbr.brasilrisk.com.br/service.asmx?WSDL
Gerado em        23/07/25 21:02:35
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _SVUOBPJ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSEebServiceCTR
------------------------------------------------------------------------------- */

WSCLIENT WSEebServiceCTR

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD BuscarDadosTotvsBR
	WSMETHOD BuscarDadosTotvsSemGerarFaturamento

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cUsuario                  AS string
	WSDATA   cSenha                    AS string
	WSDATA   cCNPJ                     AS string
	WSDATA   cDataInicio               AS string
	WSDATA   cDataTermino              AS string
	WSDATA   oWSRetornoIntegracaoTotvsBR AS Service_DadosRetorno

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSEebServiceCTR
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.210324P-20240219] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSEebServiceCTR
	::oWSRetornoIntegracaoTotvsBR := Service_DADOSRETORNO():New()
Return

WSMETHOD RESET WSCLIENT WSEebServiceCTR
	::cUsuario           := NIL 
	::cSenha             := NIL 
	::cCNPJ              := NIL 
	::cDataInicio        := NIL 
	::cDataTermino       := NIL 
	::oWSRetornoIntegracaoTotvsBR := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSEebServiceCTR
Local oClone := WSEebServiceCTR():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cUsuario      := ::cUsuario
	oClone:cSenha        := ::cSenha
	oClone:cCNPJ         := ::cCNPJ
	oClone:cDataInicio   := ::cDataInicio
	oClone:cDataTermino  := ::cDataTermino
	oClone:oWSRetornoIntegracaoTotvsBR :=  IIF(::oWSRetornoIntegracaoTotvsBR = NIL , NIL ,::oWSRetornoIntegracaoTotvsBR:Clone() )
Return oClone

// WSDL Method BuscarDadosTotvsBR of Service WSEebServiceCTR

WSMETHOD BuscarDadosTotvsBR WSSEND cUsuario,cSenha,cCNPJ,cDataInicio,cDataTermino WSRECEIVE oWSRetornoIntegracaoTotvsBR WSCLIENT WSEebServiceCTR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarDadosTotvsBR xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("Usuario", ::cUsuario, cUsuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Senha", ::cSenha, cSenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataInicio", ::cDataInicio, cDataInicio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataTermino", ::cDataTermino, cDataTermino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarDadosTotvsBR>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/BuscarDadosTotvsBR",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://integracaototvsbr.brasilrisk.com.br/service.asmx")

::Init()
::oWSRetornoIntegracaoTotvsBR:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARDADOSTOTVSBRRESPONSE:_RETORNOINTEGRACAOTOTVSBR","DadosRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarDadosTotvsSemGerarFaturamento of Service WSService

WSMETHOD BuscarDadosTotvsSemGerarFaturamento WSSEND cUsuario,cSenha,cCNPJ,cDataInicio,cDataTermino WSRECEIVE oWSRetornoIntegracaoTotvsBR WSCLIENT WSService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BuscarDadosTotvsSemGerarFaturamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("Usuario", ::cUsuario, cUsuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("Senha", ::cSenha, cSenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CNPJ", ::cCNPJ, cCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataInicio", ::cDataInicio, cDataInicio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DataTermino", ::cDataTermino, cDataTermino , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BuscarDadosTotvsSemGerarFaturamento>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/BuscarDadosTotvsSemGerarFaturamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://integracaototvsbr.brasilrisk.com.br/service.asmx")

::Init()
::oWSRetornoIntegracaoTotvsBR:SoapRecv( WSAdvValue( oXmlRet,"_BUSCARDADOSTOTVSSEMGERARFATURAMENTORESPONSE:_RETORNOINTEGRACAOTOTVSBR","DadosRetorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure DadosRetorno

WSSTRUCT Service_DadosRetorno
	WSDATA   cMensagemDeRetorno        AS string OPTIONAL
	WSDATA   nPeriodoSolicitanteComumMotorista AS int
	WSDATA   nPeriodoSolicitanteComplementarMotorista AS int
	WSDATA   nPeriodoSolicitanteVeiculo AS int
	WSDATA   nPeriodoFaturamentoComumMotorista AS int
	WSDATA   nPeriodoFaturamentoComplementarMotorista AS int
	WSDATA   nPeriodoFaturamentoVeiculo AS int
	WSDATA   nPeriodoFaturamentoConjunto AS int
	WSDATA   nPesquisaFaturamentoConjuntoMotoristaUnitario AS int
	WSDATA   nPesquisaFaturamentoConjuntoVeiculoUnitario AS int
	WSDATA   nVeiculosFrota            AS int
	WSDATA   nViagensAvulsas           AS int
	WSDATA   nViagensTelemonitoradas   AS int
	WSDATA   nTotalViagens             AS int
	WSDATA   nLiberacoes               AS int
	WSDATA   nLiberacoesTransportadores AS int
	WSDATA   nTotalViagensSIPA         AS int
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT Service_DadosRetorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT Service_DadosRetorno
Return

WSMETHOD CLONE WSCLIENT Service_DadosRetorno
	Local oClone := Service_DadosRetorno():NEW()
	oClone:cMensagemDeRetorno   := ::cMensagemDeRetorno
	oClone:nPeriodoSolicitanteComumMotorista := ::nPeriodoSolicitanteComumMotorista
	oClone:nPeriodoSolicitanteComplementarMotorista := ::nPeriodoSolicitanteComplementarMotorista
	oClone:nPeriodoSolicitanteVeiculo := ::nPeriodoSolicitanteVeiculo
	oClone:nPeriodoFaturamentoComumMotorista := ::nPeriodoFaturamentoComumMotorista
	oClone:nPeriodoFaturamentoComplementarMotorista := ::nPeriodoFaturamentoComplementarMotorista
	oClone:nPeriodoFaturamentoVeiculo := ::nPeriodoFaturamentoVeiculo
	oClone:nPeriodoFaturamentoConjunto := ::nPeriodoFaturamentoConjunto
	oClone:nPesquisaFaturamentoConjuntoMotoristaUnitario := ::nPesquisaFaturamentoConjuntoMotoristaUnitario
	oClone:nPesquisaFaturamentoConjuntoVeiculoUnitario := ::nPesquisaFaturamentoConjuntoVeiculoUnitario
	oClone:nVeiculosFrota       := ::nVeiculosFrota
	oClone:nViagensAvulsas      := ::nViagensAvulsas
	oClone:nViagensTelemonitoradas := ::nViagensTelemonitoradas
	oClone:nTotalViagens        := ::nTotalViagens
	oClone:nLiberacoes          := ::nLiberacoes
	oClone:nLiberacoesTransportadores := ::nLiberacoesTransportadores
	oClone:nTotalViagensSIPA    := ::nTotalViagensSIPA
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT Service_DadosRetorno
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cMensagemDeRetorno :=  WSAdvValue( oResponse,"_MENSAGEMDERETORNO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::nPeriodoSolicitanteComumMotorista :=  WSAdvValue( oResponse,"_PERIODOSOLICITANTECOMUMMOTORISTA","int",NIL,"Property nPeriodoSolicitanteComumMotorista as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeriodoSolicitanteComplementarMotorista :=  WSAdvValue( oResponse,"_PERIODOSOLICITANTECOMPLEMENTARMOTORISTA","int",NIL,"Property nPeriodoSolicitanteComplementarMotorista as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeriodoSolicitanteVeiculo :=  WSAdvValue( oResponse,"_PERIODOSOLICITANTEVEICULO","int",NIL,"Property nPeriodoSolicitanteVeiculo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeriodoFaturamentoComumMotorista :=  WSAdvValue( oResponse,"_PERIODOFATURAMENTOCOMUMMOTORISTA","int",NIL,"Property nPeriodoFaturamentoComumMotorista as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeriodoFaturamentoComplementarMotorista :=  WSAdvValue( oResponse,"_PERIODOFATURAMENTOCOMPLEMENTARMOTORISTA","int",NIL,"Property nPeriodoFaturamentoComplementarMotorista as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeriodoFaturamentoVeiculo :=  WSAdvValue( oResponse,"_PERIODOFATURAMENTOVEICULO","int",NIL,"Property nPeriodoFaturamentoVeiculo as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPeriodoFaturamentoConjunto :=  WSAdvValue( oResponse,"_PERIODOFATURAMENTOCONJUNTO","int",NIL,"Property nPeriodoFaturamentoConjunto as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesquisaFaturamentoConjuntoMotoristaUnitario :=  WSAdvValue( oResponse,"_PESQUISAFATURAMENTOCONJUNTOMOTORISTAUNITARIO","int",NIL,"Property nPesquisaFaturamentoConjuntoMotoristaUnitario as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nPesquisaFaturamentoConjuntoVeiculoUnitario :=  WSAdvValue( oResponse,"_PESQUISAFATURAMENTOCONJUNTOVEICULOUNITARIO","int",NIL,"Property nPesquisaFaturamentoConjuntoVeiculoUnitario as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nVeiculosFrota     :=  WSAdvValue( oResponse,"_VEICULOSFROTA","int",NIL,"Property nVeiculosFrota as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nViagensAvulsas    :=  WSAdvValue( oResponse,"_VIAGENSAVULSAS","int",NIL,"Property nViagensAvulsas as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nViagensTelemonitoradas :=  WSAdvValue( oResponse,"_VIAGENSTELEMONITORADAS","int",NIL,"Property nViagensTelemonitoradas as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nTotalViagens      :=  WSAdvValue( oResponse,"_TOTALVIAGENS","int",NIL,"Property nTotalViagens as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLiberacoes        :=  WSAdvValue( oResponse,"_LIBERACOES","int",NIL,"Property nLiberacoes as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nLiberacoesTransportadores :=  WSAdvValue( oResponse,"_LIBERACOESTRANSPORTADORES","int",NIL,"Property nLiberacoesTransportadores as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nTotalViagensSIPA  :=  WSAdvValue( oResponse,"_TOTALVIAGENSSIPA","int",NIL,"Property nTotalViagensSIPA as s:int on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return


