#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC95    ºAutor  ³Jackson E. de Deusº Data ³  19/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de email das Leituras                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTPROC95(cAgente,cDataAtu,lReenvio,cCliReen)

Local cQuery	:= ""
Local cQuery2	:= ""
Local nI
Local aArquivos	:= {}
Local cDestino	:= ""
Local cAssunto	:= "Fechamento - Leituras - TokTake"
Local cHtml		:= ""
Local nPendente	:= 0
Local aResp		:= {}
Local aAux		:= {}
Local nTotal	:= 0
Local cCliente	:= ""
Local cLoja		:= ""
Local cStatus	:= ""
Local lEnvMail	:= .F.
Local aAxMail	:= {}
Local aEmail	:= {}
Local cMailDest	:= ""    
Local cNomeAb	:=	""  
Local cMusrAtu	:= ""

Default cAgente		:= ""
Default cDataAtu	:= Date()
Default lReenvio	:= .F. 
Default cCliReen	:= ""

If cEmpAnt <> "01"
	return
EndIF
// primeira consulta - resultados agrupados com total por agente + cliente + loja do dia
cQuery := "SELECT ZG_CODTEC,ZG_AGENTED, ZG_CLIFOR, ZG_LOJA, COUNT(*) TOTAL FROM " +RetSqlName("SZG")
cQuery += " WHERE ZG_DATAINI = '"+DTOS(cDataAtu)+"' AND ZG_FORM IN ('02','03','04','08') "

If !Empty(cAgente) .And. !Empty(cCliReen)
	cQuery += " AND ZG_CODTEC='"+cAgente+"' AND ZG_CLIFOR = '"+cCliReen+"' AND ZG_EOS<>'' " //cQuery += " AND ZG_AGENTE='"+cAgente+"' AND ZG_EOS='3'"
Else
	cQuery += " AND ZG_EOS<>'' " 
EndIf

cQuery += " GROUP BY ZG_CODTEC,ZG_AGENTED, ZG_CLIFOR, ZG_LOJA "

If Select("TRBG") > 0
	TRBG->( dbCloseArea() )
EndIf                     

TcQuery cQuery New Alias "TRBG"
dbSelectArea("TRBG")
While TRBG->( !EOF() )
	cAgente	 := TRBG->ZG_CODTEC
	cCliente := TRBG->ZG_CLIFOR
	cLoja := TRBG->ZG_LOJA     
	cNomeAb := ALLTRIM(TRBG->ZG_AGENTED)
	nTotal := TRBG->TOTAL
	nPendente := 0
	cStatus := ""
	aResp := {}
	aAux := {}
	cHtml := ""
	lEnvMail := .F.
	
	// segunda consulta - todas as OS do agente - cliente - loja do dia
	cQuery2 := "SELECT ZG_NUMOS, ZG_EOS, ZG_STATUS, ZG_PATRIM, ZG_PATRIMD, ZG_DATAFIM, ZG_HORAFIM, ZN_NUMATU, ZN_COTCASH, "
	cQuery2 += " ZN_BOTAO01, ZN_BOTAO02, ZN_BOTAO03, ZN_BOTAO04, ZN_BOTAO05, ZN_BOTAO06, ZN_BOTAO07, "
	cQuery2 += " ZN_BOTAO08, ZN_BOTAO09, ZN_BOTAO10, ZN_BOTAO11, ZN_BOTAO12, ZN_BOTAO13, ZN_BOTAO14, " 
	cQuery2 += " ZN_BOTAO15, ZN_BOTAO16, ZN_BOTAO17, ZN_BOTAO18, ZN_BOTAO19, ZN_BOTAO20, ZN_BOTAO21, "
	cQuery2 += " ZN_BOTAO22, ZN_BOTAO23, ZN_BOTAO24, ZN_BOTAO25, ZN_BOTAO26, ZN_BOTAO27, ZN_BOTAO28, ZN_BOTAO29, " 
	cQuery2 += " ZN_BOTTEST, ZN_PARCIAL FROM " +RetSqlName("SZG") +" ZG "
	cQuery2 += " LEFT JOIN " +RetSqlName("SZN") +" ZN ON "
	cQuery2 += " ZN_DATA = ZG_DATAFIM "
	cQuery2 += " AND ZN_PATRIMO = ZG_PATRIM "
	cQuery2 += " AND ZN_NUMOS = ZG_NUMOS "
	cQuery2 += " AND ZN_AGENTE = ZG_AGENTE "
	cQuery2 += " AND ZN.D_E_L_E_T_ = ZG.D_E_L_E_T_ "
	cQuery2 += " WHERE "
	cQuery2 += " ZG_DATAINI = '"+DTOS(cDataAtu)+"' AND ZG_CLIFOR = '"+cCliente+"' AND ZG_LOJA = '"+cLoja+"' AND ZG_CODTEC = '"+cAgente+"' AND ZG_FORM IN ('02','03','04','08')"
	If !lReenvio
		cQuery2 += " AND ZG.ZG_EOS <> '2'"
	EndIf
	
	cQuery2 += " AND ZG.D_E_L_E_T_ = '' "
	
	If Select("TRBG2") > 0
		TRBG->( dbCloseArea() )
	EndIf
	
	TcQuery cQuery2 New Alias "TRBG2"
	dbSelectArea("TRBG2")
	While TRBG2->( !EOF() )
		If !AllTrim(TRBG2->ZG_STATUS) $ "CTEC|COPE|CCLI|FIOK"
			nPendente++
			TRBG2->( dbSkip() )
			Loop
		EndIf
		
		For nI := 1 To FCount()
			If FieldName(nI) == "ZG_EOS"
				If AllTrim( FieldGet(nI) ) == "1" .or. lReenvio
					lEnvMail := .T.                 
				EndIf
			ElseIf FieldName(nI) == "ZG_STATUS"
				cStatus := AllTrim( FieldGet(nI) )
				Exit
			EndIf
		Next nI
		
		// Adicionar somente as OS finalizadas
		If cStatus == "FIOK"
			For nI := 1 To FCount()			
				If FieldName(nI) $ "ZG_EOS|ZG_STATUS"
					Loop
				EndIf
			
				AADD( aAux, { FieldName(nI), IIF(ValType(FieldGet(nI))=="N",cvaltochar(FieldGet(nI)),FieldGet(nI)) }  )	
			Next nI
		EndIf        
		
		If Len(aAux) > 0
			AADD( aResp, aAux )
		EndIf
		aAux := {}
		TRBG2->( dbSkip() )
	End
	TRBG2->( dbCloseArea() )
	
	// verifica se pode enviar o email
	If lEnvMail .And. nPendente == 0
		If !lReenvio
			cDestino := AllTrim( Posicione("SA1",1,xFilial("SA1") +AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA"), "A1_EMAIL") )	// EMAIL DO CLIENTE
		    cDestino += ";jnascimento@toktake.com.br;rjesus@toktake.com.br"
		    
		    aEmail := StrToKarr(cDestino,";")
			If Len(aEmail) > 0
				For nI := 1 To Len(aEmail)
					If Ascan( aAxMail, { |x| AllTrim(x) == aEmail[nI] } ) == 0
						AADD( aAxMail, aEmail[nI] )
					EndIf
				Next nI
				
				For nI := 1 To Len(aEmail)
					cMailDest += aEmail[nI]
					If nI <> Len(aEmail)
						cMailDest += ";"
					EndIf
				Next nI
			EndIf
		Else
		    cMusrAtu := AllTrim( UsrRetMail(__cUserId) )
		    If lReenvio .And. !Empty(cMusrAtu)
		    	cMailDest := cMusrAtu
		    EndIf
		EndIf
        
	
		//incluir aqui o envio da foto tirada no atendimento para o cliente, o padrao da pasta e \protheus_data\_keeple\Tipo_Form\Nr_OS\Foto\xxx.jpg	
		cHtml := BodyMl(aResp,cNomeAb)                    
		If !Empty(cHtml) .And. !Empty(cMailDest)	
			Aadd(aArquivos,{"\system\logocob.jpg",'Content-ID: <ID_logocob.jpg>'})
			U_TTMAILN('microsiga@toktake.com.br', cMailDest, cAssunto, cHtml, aArquivos,.T.)
			       
			// Altera o flag das OS para '2 - enviada'
			For nI := 1 To Len(aResp)         
				dbSelectArea("SZG")
				dbSetOrder(1)
				If msSeek( xFilial("SZG") +AvKey( aResp[nI][1][2],"ZG_NUMOS") )
					If RecLock("SZG",.F.)
						SZG->ZG_EOS := "2"
						MsUnLock()
					EndIf
				EndIf
			Next nI
			
			U_TTGENC01( xFilial("SZG"),"TTWS","ORDEM DE SERVICO","",,"","WS",dtos(date()),time(),,"ENVIO DE EMAIL - CLIENTE: "+cCliente + " | LOJA: " +cLoja,,,"SZG" )	
		EndIf
	EndIf
	TRBG->( dbSkip() )
End
TRBG->( dbCloseArea() )


Return


Static Function BodyMl(aResp,cNomeAb)

Local cHtml := ""
Local nI
Local nJ
Local cNumchapa := ""
Local cDescChapa := ""
Local cData := ""
Local cHora := ""
Local cTxtCab := ""
Local lTodosP := .T.
Local cProd := ""
Local cFamil := ""    
Local nOpera := 1

If Len(aResp) == 0
	Return cHtml
EndIf

cHtml := "<html>"
cHtml += "<head>
cHtml += "<title></title>"
cHtml += "<style type='text/css'>  "
cHtml += "	table.bordasimples {border-collapse: collapse;}	"
cHtml += "	table.bordasimples tr td {border:1px solid #91476C;}"	
cHtml += "	body { background-color: #FFFFFF;	color: #5D665B; 	margin: 50px;	font-family: Times New Roman, Times, serif;	font-size: small; 	}"
cHtml += "</style>"
cHtml += "</head>"                

cHtml += "<body>"
cHtml += " <table align='center'><tr>"
cHtml += "	<img src='cid:ID_logocob.jpg' height='42' width='42'></td>"
cHtml += " </tr></table><br><br>"

cHtml += "<font face='Verdana'>Conforme solicitação de nosso abastecedor e por constar seu email em nosso cadastro, você esta recebendo uma cópia da leitura realizada nos Patrimônios abaixo para conferência <br><br>"
cHtml += " Abastecedor que realizou a leitura <b>"+cNomeAb+"</b>"

dbSelectArea("SX3")
dbSetOrder(2)

For nI := 1 To Len(aResp)
	For nJ := 1 To 5
		If aResp[nI][nJ][1] == "ZG_PATRIM"
			cNumChapa := aResp[nI][nJ][2]
			Loop
		ElseIf aResp[nI][nJ][1] == "ZG_PATRIMD"
			cDescChapa := aResp[nI][nJ][2]
			Loop
		ElseIf aResp[nI][nJ][1] == "ZG_DATAFIM"
			cData :=  aResp[nI][nJ][2]
			Loop
		ElseIf aResp[nI][nJ][1] == "ZG_HORAFIM"
			cHora := aResp[nI][nJ][2]
			Loop
		EndIf
	Next nJ
	
	lTodosP := .T.
	
	// Verificar tipo da maquina para montar o email - VERIFICAR POSTERIORMENTE
	cProd := Posicione("SN1",2,xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA"), "N1_PRODUTO" )
	cFamil := Posicione("SB1",1,xFilial("SB1") +AvKey(cProd,"B1_COD"),"B1_XFAMILI")
	If AllTrim(cFamil) <> "153"
		lTodosP := .F.	
	EndIf  
	//cData := '20141112'
	cTxtCab := "Máquina " +cNumChapa +" - " +cDescChapa +" - " +cvaltochar(stod(cData)) + "	" +cHora

	cHtml += "<table border='1'>"
	cHtml += 	"<tr>"
	cHtml += 		"<td colspan='2' bgcolor='#191970'><font face='verdana' color='FFFFFF'><B>"+cTxtCab+"</B></font></td>"
	cHtml += 	"</tr>"
		
	cHtml += 	"<tr>"
	cHtml += 		"<td bgcolor='#6495ED'><font face='verdana' color='FFFFFF'><B>Tipo de contador</B></font></td>"
	cHtml += 		"<td bgcolor='#6495ED'><font face='verdana' color='FFFFFF'><B>Valor</B></font></td>"
	cHtml += 	"</tr>"
	
	nOpera := 1
		
	For nJ := 6 To Len(aResp[nI]) 
		// Outras maquinas - nao mostrar os P's
		If !lTodosP
			If "ZN_BOTAO" $ aResp[nI][nJ][1]
				Loop
			EndIf   
		// Maquina de bebidas quentes - nao mostrar campo CotCash
		Else        
			If "ZN_COTCASH" == aResp[nI][nJ][1]
				Loop
			EndIf
		EndIf
		
		msSeek(aResp[nI][nJ][1])
		
		If nOpera % 2 == 0
			cHtml += 	"<tr>"
			cHtml += 		"<td bgcolor='#EEE9E9'>"+X3Titulo(aResp[nI][nJ][1])+"</td>"
			cHtml += 		"<td bgcolor='#EEE9E9'>"+aResp[nI][nJ][2]+"</td>"
			cHtml += 	"</tr>"
		Else
			cHtml += 	"<tr>"
			cHtml += 		"<td>"+X3Titulo(aResp[nI][nJ][1])+"</td>"
			cHtml += 		"<td>"+aResp[nI][nJ][2]+"</td>"
			cHtml += 	"</tr>"
		EndIf	
		nOpera++
	Next nJ	
			           
	cHtml += "</table>"
						
	If nI <> Len(aResp)
		cHtml += "<p>&nbsp;</p>"
	EndIf
Next nI	 

cHtml += "<BR><BR><font color='#FFA500'><b>TOK TAKE ALIMENTAÇÃO LTDA.<BR>"  
cHtml += "MATRIZ - SP</b></font><BR>"
cHtml += "Tel.: 011 3622-2400<BR>"
cHtml += "<a href='http://www.toktake.com.br'>www.toktake.com.br</a><BR><BR><BR><BR>"

cHtml += "<font face='arial' size='2'>AVISO LEGAL<br><br>"
cHtml += "Esta mensagem é destinada exclusivamente para a(s) pessoa(s) a quem é dirigida, podendo conter informação confidencial e/ou  legalmente privilegiada. Se você não for destinatário desta mensagem, desde já fica notificado de abster-se a divulgar, copiar, distribuir, examinar ou, de qualquer forma, utilizar a informação contida nesta mensagem, pode ser ilegal. Caso você tenha recebido esta mensagem por engano, pedimos que nos retorne este E-Mail, promovendo, desde logo, a eliminação do seu conteúdo em sua base de dados, registros ou sistema de controle. Fica desprovida de eficácia e validade a mensagem que contiver vínculos obrigacionais, expedidas por quem não detenha poderes de representação.<br><br><br>"

cHtml += "LEGAL ADVICE<br><br>"
cHtml += "This message is exclusively destined for the people to whom it is directed, and it can bear private and/or legally exceptional information. If you are not addressee of this message, since now you are advised to not release, copy, distribute, check or, otherwise, use the information contained in this message, because it is illegal. If you received this message by mistake, we ask you to return this email, making possible, as soon as possible, the elimination of its contents of your database, registrations or controls system. The message that bears any mandatory links, issued by someone who has no representation powers, shall be null or void.<br><br></font>"
	
cHtml += "</body>"
cHtml += "</html>"

      
Return cHtml