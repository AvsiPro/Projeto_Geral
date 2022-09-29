#include "protheus.ch
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER11  บAutor  ณJackson E. de Deus  บ Data ณ  10/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica os campos de doses do cadastro de patrimonio	  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ10/10/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTOPER11(cPatrimo)

Local lPVazio := .F.                       
Local cdestino := SuperGetMV("MV_XATF003",.T.,"")

Default cPatrimo := ""

If Empty(cPatrimo)
	Return
EndIf             

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cdestino)
	Conout("# TTOPER11 - Verificar parametro MV_XATF003 #")
	Return
EndIf


lPVazio := ChkPs(cPatrimo)
If lPVazio
	Mail(cPatrimo,cdestino)
EndIf

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkPs     บAutor  ณJackson E. de Deus  บ Data ณ  10/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica os campos de doses - P's                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkPs(cPatrimo)
     
Local cQuery := ""
Local lPVazio := .F.
Local lNovos := .T.
Local nTotP := 0
Local nPOk := 0
Local aCampos := {}


dbSelectArea("SN1")
For nI := 1 To 25
	cCampo := "N1_XP"+cvaltochar(nI)
	If FieldPos(cCampo) > 0
		AADD( aCampos, cCampo )
	EndIf
Next nI
	
cQuery := "SELECT "
For nI := 1 To Len(aCampos)
	cQuery += aCampos[nI]
	If nI <> Len(aCampos)
		cQuery += ","
	EndIf
	nTotP++
Next nI

cQuery += " FROM " +RetSqlName("SN1")
cQuery += " WHERE N1_CHAPA = '"+cPatrimo+"' AND D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")

If !EOF()
	For nI := 1 To nTotP
		If !Empty( TRB->&( "N1_XP" +cvaltochar(nI) ) )
			nPOk++			
		EndIf
	Next nI
EndIf
dbCloseArea()

If nPOk == 0
	lPVazio := .T.
EndIf	

Return lPVazio


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMail      บAutor  ณJackson E. de Deus  บ Data ณ  10/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail para o supervisor.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mail(cPatrimo,cdestino)

Local cRemete := "microsiga"
Local cAssunto := "Patrim๔nio com cadastro incompleto"
Local cHtml := ""
Local aAttach := {}
Local cModelo := AllTrim( Posicione("SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"), "N1_DESCRIC") )
Default cDestino := ""

If Empty(cDestino)
	Return
EndIf


cHtml := "<html>" +CRLF
cHtml += "<head>"+CRLF
cHtml += "<title>" +cAssunto +"</title>" +CRLF
			
// Estilos
cHtml += "<style type='text/css'>"	+CRLF
cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
cHtml += "	body { background-color: #FFFFFF;"	+CRLF
cHtml += "	color: #5D665B; "	+CRLF
cHtml += "	margin: 10px;"	+CRLF
cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
cHtml += "	font-size: small;"	+CRLF
//	cArqMail += "	line-height: 180%;"
cHtml += " 	}"	+CRLF
cHtml += "</style>"	+CRLF

cHtml += "</head>"	+CRLF

// Corpo
cHtml += "<body>"	+CRLF

cHtml += "<p>O patrim๔nio "+cPatrimo +" - " +cModelo +" possui inconsist๊ncia em seu cadastro.</p>"	+CRLF
cHtml += "<p>Favor cadastrar as doses atrav้s da rotina de configura็๕es de patrim๔nios no m๓dulo Gestใo de Contratos.</p>"	+CRLF

cHtml += "<br>"	+CRLF
cHtml += "<br>"	+CRLF

cHtml += "<p>" +Replicate("_",35) +"</p>"	+CRLF
cHtml += "<p>E-mail automแtico enviado via protheus.</p>"	+CRLF
cHtml += "<p>Favor nใo responder.</p>"	+CRLF
cHtml += "</body>"	+CRLF
cHtml += "</html>"	+CRLF

U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)

Return