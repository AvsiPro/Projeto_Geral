#include "protheus.ch
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER10  บAutor  ณJackson E. de Deus  บ Data ณ  09/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica as OS do dia que estใo em atraso e dispara e-mail บฑฑ
ฑฑบ          ณ aos supervisores.										  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ09/10/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ20/10/14ณ01.01 |Alteracao para nao considerar chamados  ณฑฑ
ฑฑณ								  com status INCO - Inconsistencia        ณฑฑ
ฑฑณJackson       ณ21/10/14ณ01.02 |Verificar no sistema Equipe Remota o	  ณฑฑ
ฑฑณ								  status atualizado da OS				  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTOPER10()

Local aAux := {}
Local nI
Local cCodSuper := ""
Local cMailSuper := ""
Local cCodGeren := ""
Local cMailGeren := ""
Local cHoraIni := ""
Local cHoraFim := ""
Local cTotal := ""
Private aAtraso := {}

cHoraIni := Time()

Prepare Environment Empresa "01" Filial "01"

Dados()

For nI := 1 To Len(aAtraso)
	cCodSuper := aAtraso[nI][6]
	cCodGeren := aAtraso[nI][15]
	cMailSuper := AllTrim( Posicione("AA1",1,xFilial("AA1")+cCodSuper,"AA1_EMAIL") )
	cMailGeren := "mmelao@toktake.com.br" //AllTrim( Posicione("AA1",1,xFilial("AA1")+cCodGeren,"AA1_EMAIL") )	// ALTERADO POIS COMECARAM A RECLAMAR DOS EMAILS DAS OS
	If !Empty(cMailSuper)
		If Ascan( aAux, { |x| x[1] == cCodSuper } ) == 0
			AADD( aAux, { cCodSuper, cMailSuper, cMailGeren } )
		EndIf     
	EndIf
Next nI                      

For nI := 1 To Len(aAux)
	For nJ := 1 To Len(aAtraso)
		If aAtraso[nJ][6] == aAux[nI][1]
			AADD( aAux[nI], aAtraso[nJ] )
		EndIf
	Next nJ
Next nI

For nI := 1 To Len(aAux)
	If Len(aAux[nI]) > 0
		Mail(aAux[nI])     
	EndIf
Next nI

Reset Environment

cHoraFim := Time()

cTotal := ElapTime( cHoraIni, cHoraFim )
Conout("# TTOPER10 - Tempo total de execucao: " +cTotal +"  #")

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDados     บAutor  ณJackson E. de Deus  บ Data ณ  09/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os dados                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Dados()
     
Local cQuery := ""
Local aAux := {}
Local nI 
Local lAtrasou := .F.
Local cResult := ""
Local cError := ""
Local cWarning := ""
Local oXml := Nil
Local cStatusOS := ""

cQuery := "SELECT " // alterar depois
cQuery += "ZG_NUMOS, ZG_ROTA, ZG_AGENTE, ZG_AGENTED, ZG_CLIFOR, ZG_LOJA, A1_NREDUZ, ZG_DESCFRM, ZG_PATRIM, ZG_PATRIMD,  ZG_DATAINI, ZG_HORAINI, ZG_HORAFIM, AA1_XGEREN, AA1_XSUPER, AA1_CODTEC "
cQuery += "FROM " +RetSqlName("SZG") +" SZG "
cQuery += "INNER JOIN " +RetSqlName("AA1") +" AA1 ON AA1_PAGER = ZG_AGENTE AND AA1.D_E_L_E_T_ = '' AND AA1_XGEREN <> '' AND AA1_XSUPER <> '' AND AA1_PAGER <> '' "
cQuery += "INNER JOIN " +RetSqlName("SA1") +" SA1 ON SA1.A1_COD = ZG_CLIFOR AND SA1.A1_LOJA = ZG_LOJA AND SA1.D_E_L_E_T_ = '' "
cQuery += "WHERE "
cQuery += " ZG_STATUS NOT IN ( 'FIOK','INCO','COPE','CTEC','CCLI' ) AND "
cQuery += " ZG_DATAINI = '"+DTOS(Date())+"' AND SZG.D_E_L_E_T_ = '' "
cQuery += "ORDER BY ZG_AGENTED, ZG_HORAINI "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")

While !EOF()
	AADD( aAux, { TRB->ZG_NUMOS, TRB->ZG_AGENTE, stod(TRB->ZG_DATAINI), TRB->ZG_HORAINI, TRB->AA1_CODTEC, TRB->AA1_XSUPER,;
					 TRB->ZG_AGENTED, TRB->ZG_CLIFOR, TRB->ZG_LOJA, TRB->ZG_DESCFRM, TRB->ZG_PATRIM, TRB->ZG_PATRIMD,;
					 TRB->A1_NREDUZ, TRB->ZG_ROTA, TRB->AA1_XGEREN }   )
	dbSkip()
End

For nI := 1 To Len(aAux)
	lAtrasou := .F.     
	
	// Verifica o status da OS no Equipe Remota - desconsiderar OS finalizadas
	cResult := StaticCall(TTPROC30,RetornoOS,aAux[nI][1])
	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If oXml != NIL		     	        
			cStatusOS := AllTrim(oXml:_FormAnswers:_FormAnswer:_Status:TEXT) 	
			If AllTrim(cStatusOS) == "FIOK"
				Loop
			EndIf
		EndIf		
	EndIf	
	lAtrasou := ChkAtraso( aAux[nI][3],aAux[nI][4] )	// OS, dataini, horaini
	If lAtrasou
		AADD( aAtraso, aAux[nI] )
	EndIf
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkAtraso บAutor  ณJackson E. de Deus  บ Data ณ  09/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se atendimento da OS estแ atrasado.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkAtraso( dDataIni,cHoraIni )

Local cHora := ""
Local cDifHora := ""        
Local lRet := .F.

If Date() == dDataIni
	cHora := Time()	
	If cHora > cHoraIni
		cDifHora := ElapTime( cHoraIni,cHora )
	EndIf                                     
	If cDifHora > "00:00:05"
		lRet := .T.
	EndIf
//ElseIf Date() > dDataIni
//	lRet := .T.
EndIf	

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMail      บAutor  ณJackson E. de Deus  บ Data ณ  09/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail para o supervisor.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mail(aDados)

Local cRemete := "microsiga"
Local cdestino := aDados[2]
Local cAssunto := "Atraso no atendimento de Ordem de Servi็o"
Local cHtml := ""
Local aAttach := {}
Local aAux := {}
Local cAtend := ""

If !Empty(aDados[3])
	cDestino += ";" +aDados[3]
EndIf

aDel(aDados, 1)
aSize(aDados, Len(aDados)-1)
aDel(aDados, 1)             
aSize(aDados, Len(aDados)-1)
aDel(aDados, 1)             
aSize(aDados, Len(aDados)-1)


aSort( aDados,,,{ |x,y| x[7] < y[7] .And. x[4] < y[4] } )	// OS / Hora       

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

cHtml += "<p>Segue abaixo rela็ใo de Ordens de Servi็o que estใo atrasadas, separadas por t้cnico.</p>"	+CRLF

For nI := 1 To Len(aDados)
	If nI == 1
		cAtend := AllTrim(aDados[nI][7]) +" - Agente: " +cvaltochar(aDados[nI][2]) +" - Rota: " +AllTrim(aDados[nI][14])
		cHtml += "<b>" +cAtend +"</b>"	+CRLF
		cHtml += "<table class='bordasimples' cellpadding='4'>"	+CRLF
		cHtml += "<tr>"	+CRLF
		cHtml += 	"<td><b>OS</b></td>"	+CRLF
		cHtml += 	"<td><b>Hora</b></td>"	+CRLF
		cHtml += 	"<td><b>Patrim๔nio/Cliente</b></td>"	+CRLF
		cHtml += "</tr>"	+CRLF
	Else
		If cAtend <> AllTrim(aDados[nI][7])
			cAtend := AllTrim(aDados[nI][7]) +" - Agente: " +cvaltochar(aDados[nI][2]) +" - Rota: " +AllTrim(aDados[nI][14])
			cHtml += "</table>"	+CRLF
            
            cHtml += "<br>"	+CRLF
			cHtml += "<b>" +cAtend +"</b>"	+CRLF
			cHtml += "<table class='bordasimples' cellpadding='4'>"	+CRLF
			cHtml += "<tr>"	+CRLF
			cHtml += 	"<td><b>OS</b></td>"	+CRLF
			cHtml += 	"<td><b>Hora</b></td>"	+CRLF
			cHtml += 	"<td><b>Patrim๔nio/Cliente</b></td>"	+CRLF
			cHtml += "</tr>"	+CRLF
		EndIf	
	EndIf
	
	cHtml += "<tr>"	+CRLF
	cHtml += 	"<td>"+cvaltochar(Val(aDados[nI][1]))+"</td>"	+CRLF
	cHtml += 	"<td>"+AllTrim(aDados[nI][4])+"</td>"	+CRLF
	cHtml += 	"<td>"+AllTrim(aDados[nI][11]) +" - " +AllTrim(aDados[nI][13]) +"</td>"	+CRLF
	cHtml += "</tr>"	+CRLF
Next nI

cHtml += "</table>"	+CRLF

cHtml += "<br>"	+CRLF
cHtml += "<br>"	+CRLF

cHtml += "<p>" +Replicate("_",35) +"</p>"	+CRLF
cHtml += "<p>E-mail automแtico enviado via protheus.</p>"	+CRLF
cHtml += "<p>Favor nใo responder.</p>"	+CRLF
cHtml += "</body>"	+CRLF
cHtml += "</html>"	+CRLF

U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)

Return