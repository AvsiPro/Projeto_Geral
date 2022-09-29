#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://189.36.48.135:10142/ws/TTMWS.apw?WSDL
Gerado em        08/03/16 12:22:51
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _VWWORLX ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSTTMWS
------------------------------------------------------------------------------- */

WSCLIENT WSTTMWS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD DEVICEREGISTER
	WSMETHOD GETOS
	WSMETHOD GETOSCANCEL
	WSMETHOD GETSTATUSRT
	WSMETHOD GETSTCK
	WSMETHOD REGOUTPUTINVOICE
	WSMETHOD SETUPDOS
	WSMETHOD STARTDEVOLUTION
	WSMETHOD TESTEX
	WSMETHOD UPDMAPMACHINE

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cATENDENTE                AS string
	WSDATA   cAUTHCODE                 AS string
	WSDATA   cIMEI                     AS string
	WSDATA   cMANUF                    AS string
	WSDATA   cMODEL                    AS string
	WSDATA   cAPILVL                   AS string
	WSDATA   cOSVER                    AS string
	WSDATA   cAPPVER                   AS string
	WSDATA   cIDGCM                    AS string
	WSDATA   cCHIP1                    AS string
	WSDATA   cTPDEV                    AS string
	WSDATA   cRGOPER                   AS string
	WSDATA   cDEVICEREGISTERRESULT     AS string
	WSDATA   cGETOSRESULT              AS string
	WSDATA   cGETOSCANCELRESULT        AS string
	WSDATA   cGETSTATUSRTRESULT        AS string
	WSDATA   cARMAZEM                  AS string
	WSDATA   cPRODUTO                  AS string
	WSDATA   cGETSTCKRESULT            AS string
	WSDATA   cNF                       AS string
	WSDATA   cREGOUTPUTINVOICERESULT   AS string
	WSDATA   cIDNUMBER                 AS string
	WSDATA   cVALUES                   AS string
	WSDATA   cSETUPDOSRESULT           AS string
	WSDATA   cROTA                     AS string
	WSDATA   cSTARTDEVOLUTIONRESULT    AS string
	WSDATA   cTESTEXRESULT             AS string
	WSDATA   cMAQUINA                  AS string
	WSDATA   cMAPA                     AS string
	WSDATA   cUPDMAPMACHINERESULT      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSTTMWS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151103] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSTTMWS
Return

WSMETHOD RESET WSCLIENT WSTTMWS
	::cATENDENTE         := NIL 
	::cAUTHCODE          := NIL 
	::cIMEI              := NIL 
	::cMANUF             := NIL 
	::cMODEL             := NIL 
	::cAPILVL            := NIL 
	::cOSVER             := NIL 
	::cAPPVER            := NIL 
	::cIDGCM             := NIL 
	::cCHIP1             := NIL 
	::cTPDEV             := NIL 
	::cRGOPER            := NIL 
	::cDEVICEREGISTERRESULT := NIL 
	::cGETOSRESULT       := NIL 
	::cGETOSCANCELRESULT := NIL 
	::cGETSTATUSRTRESULT := NIL 
	::cARMAZEM           := NIL 
	::cPRODUTO           := NIL 
	::cGETSTCKRESULT     := NIL 
	::cNF                := NIL 
	::cREGOUTPUTINVOICERESULT := NIL 
	::cIDNUMBER          := NIL 
	::cVALUES            := NIL 
	::cSETUPDOSRESULT    := NIL 
	::cROTA              := NIL 
	::cSTARTDEVOLUTIONRESULT := NIL 
	::cTESTEXRESULT      := NIL 
	::cMAQUINA           := NIL 
	::cMAPA              := NIL 
	::cUPDMAPMACHINERESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSTTMWS
Local oClone := WSTTMWS():New()
	oClone:_URL          := ::_URL 
	oClone:cATENDENTE    := ::cATENDENTE
	oClone:cAUTHCODE     := ::cAUTHCODE
	oClone:cIMEI         := ::cIMEI
	oClone:cMANUF        := ::cMANUF
	oClone:cMODEL        := ::cMODEL
	oClone:cAPILVL       := ::cAPILVL
	oClone:cOSVER        := ::cOSVER
	oClone:cAPPVER       := ::cAPPVER
	oClone:cIDGCM        := ::cIDGCM
	oClone:cCHIP1        := ::cCHIP1
	oClone:cTPDEV        := ::cTPDEV
	oClone:cRGOPER       := ::cRGOPER
	oClone:cDEVICEREGISTERRESULT := ::cDEVICEREGISTERRESULT
	oClone:cGETOSRESULT  := ::cGETOSRESULT
	oClone:cGETOSCANCELRESULT := ::cGETOSCANCELRESULT
	oClone:cGETSTATUSRTRESULT := ::cGETSTATUSRTRESULT
	oClone:cARMAZEM      := ::cARMAZEM
	oClone:cPRODUTO      := ::cPRODUTO
	oClone:cGETSTCKRESULT := ::cGETSTCKRESULT
	oClone:cNF           := ::cNF
	oClone:cREGOUTPUTINVOICERESULT := ::cREGOUTPUTINVOICERESULT
	oClone:cIDNUMBER     := ::cIDNUMBER
	oClone:cVALUES       := ::cVALUES
	oClone:cSETUPDOSRESULT := ::cSETUPDOSRESULT
	oClone:cROTA         := ::cROTA
	oClone:cSTARTDEVOLUTIONRESULT := ::cSTARTDEVOLUTIONRESULT
	oClone:cTESTEXRESULT := ::cTESTEXRESULT
	oClone:cMAQUINA      := ::cMAQUINA
	oClone:cMAPA         := ::cMAPA
	oClone:cUPDMAPMACHINERESULT := ::cUPDMAPMACHINERESULT
Return oClone

// WSDL Method DEVICEREGISTER of Service WSTTMWS

WSMETHOD DEVICEREGISTER WSSEND cATENDENTE,cAUTHCODE,cIMEI,cMANUF,cMODEL,cAPILVL,cOSVER,cAPPVER,cIDGCM,cCHIP1,cTPDEV,cRGOPER WSRECEIVE cDEVICEREGISTERRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DEVICEREGISTER xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IMEI", ::cIMEI, cIMEI , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MANUF", ::cMANUF, cMANUF , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MODEL", ::cMODEL, cMODEL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("APILVL", ::cAPILVL, cAPILVL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("OSVER", ::cOSVER, cOSVER , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("APPVER", ::cAPPVER, cAPPVER , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDGCM", ::cIDGCM, cIDGCM , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CHIP1", ::cCHIP1, cCHIP1 , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("TPDEV", ::cTPDEV, cTPDEV , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("RGOPER", ::cRGOPER, cRGOPER , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</DEVICEREGISTER>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/DEVICEREGISTER",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cDEVICEREGISTERRESULT :=  WSAdvValue( oXmlRet,"_DEVICEREGISTERRESPONSE:_DEVICEREGISTERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETOS of Service WSTTMWS

WSMETHOD GETOS WSSEND cATENDENTE,cAUTHCODE WSRECEIVE cGETOSRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETOS xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/GETOS",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cGETOSRESULT       :=  WSAdvValue( oXmlRet,"_GETOSRESPONSE:_GETOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETOSCANCEL of Service WSTTMWS

WSMETHOD GETOSCANCEL WSSEND cATENDENTE,cAUTHCODE WSRECEIVE cGETOSCANCELRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETOSCANCEL xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETOSCANCEL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/GETOSCANCEL",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cGETOSCANCELRESULT :=  WSAdvValue( oXmlRet,"_GETOSCANCELRESPONSE:_GETOSCANCELRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETSTATUSRT of Service WSTTMWS

WSMETHOD GETSTATUSRT WSSEND cATENDENTE,cAUTHCODE WSRECEIVE cGETSTATUSRTRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETSTATUSRT xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETSTATUSRT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/GETSTATUSRT",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cGETSTATUSRTRESULT :=  WSAdvValue( oXmlRet,"_GETSTATUSRTRESPONSE:_GETSTATUSRTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETSTCK of Service WSTTMWS

WSMETHOD GETSTCK WSSEND cATENDENTE,cAUTHCODE,cARMAZEM,cPRODUTO WSRECEIVE cGETSTCKRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETSTCK xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ARMAZEM", ::cARMAZEM, cARMAZEM , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("PRODUTO", ::cPRODUTO, cPRODUTO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETSTCK>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/GETSTCK",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cGETSTCKRESULT     :=  WSAdvValue( oXmlRet,"_GETSTCKRESPONSE:_GETSTCKRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method REGOUTPUTINVOICE of Service WSTTMWS

WSMETHOD REGOUTPUTINVOICE WSSEND cATENDENTE,cAUTHCODE,cNF WSRECEIVE cREGOUTPUTINVOICERESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<REGOUTPUTINVOICE xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("NF", ::cNF, cNF , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</REGOUTPUTINVOICE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/REGOUTPUTINVOICE",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cREGOUTPUTINVOICERESULT :=  WSAdvValue( oXmlRet,"_REGOUTPUTINVOICERESPONSE:_REGOUTPUTINVOICERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SETUPDOS of Service WSTTMWS

WSMETHOD SETUPDOS WSSEND cATENDENTE,cAUTHCODE,cIDNUMBER,cVALUES WSRECEIVE cSETUPDOSRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SETUPDOS xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IDNUMBER", ::cIDNUMBER, cIDNUMBER , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VALUES", ::cVALUES, cVALUES , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</SETUPDOS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/SETUPDOS",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cSETUPDOSRESULT    :=  WSAdvValue( oXmlRet,"_SETUPDOSRESPONSE:_SETUPDOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method STARTDEVOLUTION of Service WSTTMWS

WSMETHOD STARTDEVOLUTION WSSEND cATENDENTE,cAUTHCODE,cROTA WSRECEIVE cSTARTDEVOLUTIONRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<STARTDEVOLUTION xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("ROTA", ::cROTA, cROTA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</STARTDEVOLUTION>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/STARTDEVOLUTION",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cSTARTDEVOLUTIONRESULT :=  WSAdvValue( oXmlRet,"_STARTDEVOLUTIONRESPONSE:_STARTDEVOLUTIONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method TESTEX of Service WSTTMWS

WSMETHOD TESTEX WSSEND cATENDENTE WSRECEIVE cTESTEXRESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<TESTEX xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</TESTEX>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/TESTEX",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cTESTEXRESULT      :=  WSAdvValue( oXmlRet,"_TESTEXRESPONSE:_TESTEXRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UPDMAPMACHINE of Service WSTTMWS

WSMETHOD UPDMAPMACHINE WSSEND cATENDENTE,cAUTHCODE,cMAQUINA,cMAPA WSRECEIVE cUPDMAPMACHINERESULT WSCLIENT WSTTMWS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UPDMAPMACHINE xmlns="http://189.36.48.135:10142/">'
cSoap += WSSoapValue("ATENDENTE", ::cATENDENTE, cATENDENTE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("AUTHCODE", ::cAUTHCODE, cAUTHCODE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MAQUINA", ::cMAQUINA, cMAQUINA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MAPA", ::cMAPA, cMAPA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</UPDMAPMACHINE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://189.36.48.135:10142/UPDMAPMACHINE",; 
	"DOCUMENT","http://189.36.48.135:10142/",,"1.031217",; 
	"http://189.36.48.135:10142/ws/TTMWS.apw")

::Init()
::cUPDMAPMACHINERESULT :=  WSAdvValue( oXmlRet,"_UPDMAPMACHINERESPONSE:_UPDMAPMACHINERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.