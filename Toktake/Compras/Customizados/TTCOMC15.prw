#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC15  บAutor  ณJackson E. de Deus  บ Data ณ  12/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o email das divergencias da nota fiscal de entrada.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras - Funcao TTCOMC13                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCOMC15()

Local cHtml		:= ""
Local cMsg		:= ""
Local lMail		:= .F.
Local lRet      := .F.
Local cRemete	:= SuperGetMV("MV_RELACNT",.T.,"microsiga",)
//Local cTarget	:= IIF( AllTrim(UsrRetMail(__cUserID))<>"",AllTrim(UsrRetMail(__cUserID))+";","")	// email do usuario atual
Local cTarget   := If(cEmpAnt == "01",SuperGetMV("MV_XNDV004",.T.,""),"")	// email dos responsaveis do compras
Local cSubject	:= ""
Local aAttach	:= {}
Local cEmpresa	:= AllTrim(SM0->M0_NOME)

If cEmpAnt == "01"
	
	If AllTrim(cTarget) == ""
		Aviso("TTCOMC15","Destinatแrio de email invแlido." +CRLF +"Informe o Depto de TI.",{"Ok"})
		Return
	EndIf
	
	// -> Assunto
	cSubject := "Diverg๊ncia de quantidade entregue na Nota Fiscal: " +AllTrim(SF1->F1_DOC) + "/" +AllTrim(SF1->F1_SERIE) +" Empresa: " +cEmpresa
	
	// -> Email
	// Cabe็alho
	cHtml := "<html>" +CRLF
	cHtml += "<head>" +CRLF
	cHtml += "<title>Diverg๊ncia de Quantidade</title>" +CRLF
	
	// Estilos
	cHtml += "<style type='text/css'>" +CRLF
	cHtml += "	table.bordasimples {border-collapse: collapse;}" +CRLF
	cHtml += "	table.bordasimples tr td {border:1px solid '#BC8F8F';}" +CRLF
	cHtml += "	body { background-color: #FFFFFF;" +CRLF
	cHtml += "	color: #5D665B; " +CRLF
	cHtml += "	margin: 50px;" +CRLF
	cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;" +CRLF
	cHtml += "	font-size: small;" +CRLF
	cHtml += "	line-height: 180%;" +CRLF
	cHtml += " 	}" +CRLF
	cHtml += "</style>" +CRLF
	cHtml += "</head>" +CRLF
	
	// Corpo	
	cHtml += "<body>" +CRLF
	cHtml += "<p><strong>Para a Nota Fiscal de Entrada "+SF1->F1_DOC+"/"+SF1->F1_SERIE+" houve diverg๊ncia em quantidades/pre็o recebidas(os):</strong></p>" +CRLF
	cHtml += "<br>" +CRLF
	
	cHtml += "<table class='bordasimples'>" +CRLF
	cHtml += "<tr>" +CRLF
	cHtml += "	<th>Item</th>" +CRLF
	cHtml += "	<th>Produto</th>" +CRLF
	cHtml += "	<th>Descri็ใo</th>" +CRLF
	cHtml += "	<th>UM</th>" +CRLF
	cHtml += "	<th>Quantidade comprada</th>" +CRLF
	cHtml += "	<th>Quantidade recebida</th>" +CRLF
	cHtml += "	<th>Valor comprado</th>" +CRLF
	cHtml += "	<th>Valor recebido</th>" +CRLF
	cHtml += "</tr>" +CRLF
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek( xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
	While !Eof() .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		
		If SD1->D1_QUANT <> SD1->D1_XCLASPN .OR. SD1->D1_XPRCOM < SD1->D1_VUNIT
					
			cHtml += "<tr>" +CRLF
			cHtml += 	"<td>" +SD1->D1_ITEM +"</td>" +CRLF
			cHtml += 	"<td>" +AllTrim(SD1->D1_COD) +"</td>" +CRLF
			cHtml += 	"<td>" +Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC") +"</td>" +CRLF
			cHtml += 	"<td>" +AllTrim(SD1->D1_UM) +"</td>"		 +CRLF
			lMail := .T.
			
			If SD1->D1_QUANT <> SD1->D1_XCLASPN .AND. (SD1->D1_XPRCOM < SD1->D1_VUNIT .AND. SD1->D1_XPRCOM > 0)
				cHtml += 	"<td>" +Transform(SD1->D1_QUANT,PesqPict("SD1","D1_QUANT")) +"</td>" +CRLF
				cHtml += 	"<td>" +Transform(SD1->D1_XCLASPN,PesqPict("SD1","D1_QUANT")) +"</td>" +CRLF
				cHtml += 	"<td>" +Transform(SD1->D1_XPRCOM,PesqPict("SD1","D1_VUNIT")) +"</td>" +CRLF
				cHtml += 	"<td>" +Transform(SD1->D1_VUNIT,PesqPict("SD1","D1_XPRCOM")) +"</td>" +CRLF
				cHtml += "</tr>
				lRet := .T.
			Elseif (SD1->D1_XPRCOM < SD1->D1_VUNIT .AND. SD1->D1_XPRCOM > 0) .AND. lRet == .F.
				cHtml += 	"<td>" +"0" +"</td>"		 +CRLF
				cHtml += 	"<td>" +"0" +"</td>"		 +CRLF
				cHtml += 	"<td>" +Transform(SD1->D1_XPRCOM,PesqPict("SD1","D1_VUNIT")) +"</td>" +CRLF
				cHtml += 	"<td>" +Transform(SD1->D1_VUNIT,PesqPict("SD1","D1_XPRCOM")) +"</td>" +CRLF
				cHtml += "</tr>
			Elseif SD1->D1_QUANT <> SD1->D1_XCLASPN .AND. lRet == .F. 
				cHtml += 	"<td>" +Transform(SD1->D1_QUANT,PesqPict("SD1","D1_QUANT")) +"</td>" +CRLF
				cHtml += 	"<td>" +Transform(SD1->D1_XCLASPN,PesqPict("SD1","D1_QUANT")) +"</td>" +CRLF			
				cHtml += 	"<td>" +"0" +"</td>"		 +CRLF
				cHtml += 	"<td>" +"0" +"</td>"		 +CRLF
				cHtml += "</tr>
			Endif
			
		ElseIf  SD1->D1_QUANT == SD1->D1_XCLASPN .OR. SD1->D1_XPRCOM == SD1->D1_VUNIT
			    lMail := .F.
		EndIf
			lRet := .F.
		SD1->(dbSkip())	
	EndDo
	
	cHtml += "</table>" +CRLF
	cHtml += "<br>" +CRLF
	
	cHtml += "<p>E-Mail automแtico enviado via Protheus.</p>" +CRLF
	cHtml += "<p>Favor nใo responder.</p>" +CRLF
	cHtml += "</body>" +CRLF
	cHtml += "</html>" +CRLF
	
	// Envia o email aos responsaveis
	If lMail == .T.
		U_TTMailN(cRemete,cTarget,cSubject,cHtml,aAttach,.F.)
	Endif
EndIF

Return