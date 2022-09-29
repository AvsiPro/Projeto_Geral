#INCLUDE "RPTDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "PROTHEUS.CH"                                
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPRINTSETUP.CH"

#DEFINE IMP_SPOOL 2
                                                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFATR27  ºAutor  ³Jackson E. de Deus  º Data ³  21/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime comprovante de pagamento e envia ao fornecedor.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*----------------------------------+ 
|	Recebe parametros:				|
|									|
|	Parametro			| Obrig.	|
|	Cod. do fornecedor	| x			|
|	Loja do fornecedor	| x			|
|	Numero da NF		| x			|
|	Prefixo				| x			|
|	Parcela				| x			|
|	Tipo				| x			|
+----------------------------------*/
User Function TTFATR27 (cCodForn,cLjForn,cNumNF,cPrefixo,cParcela,cTipo)

Local aArquivos := {}
Local alAreaSA2
Local alAreaSE2
Local cMsg		:= ""
Local cAviso	:= ""
Local cDest		:= ""
Local cNomeForn	:= ""
Local llRetOK	:= .F.
Local dData
Local cData
Local cTime
Local cHora
Local cMinutos
Local cSegundos
Local cCodComp	:= ""
Local cStartPath := "\system\"
Local oPrint
Local oArial14N	:= TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)		// Negrito
Local oArial14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Local cStartPath := GetSrvProfString("StartPath","")
Local cRootPath  := GetSrvProfString("RootPath","")

// Verifica se foram passados os parâmetros
If Empty(cCodForn) .Or. Empty(cLjForn) .Or. Empty(cNumNF) .Or. Empty(cPrefixo) .Or. Empty(cTipo)   
	//MsgAlert("É obrigatório o envio de todos os parâmetros!")
	Return
EndIf
If cEmpAnt == "01"	         
	// Informações do Fornecedor
	dbSelectArea("SA2")
	alAreaSA2 := GetArea()
	
	cDest := Posicione("SA2",1,xFilial("SA2")+cCodForn+cLjForn,"A2_XEMAIL")
	cNomeForn := Posicione("SA2",1,xFilial("SA2")+cCodForn+cLjForn,"A2_NOME")                     
	
	// Verifica se encontrou o fornecedor
	If Alltrim(cNomeForn) == ""
		cAviso += "Fornecedor não encontrado na empresa atual!" + CRLF
		cAviso += "Código: "+cCodForn 							+CRLF
		cAviso += "Loja: " +cLjForn
		Aviso("TTFATR98",cAviso, {"Ok"},1)
		Return	
	EndIf
	
	     
	
	// Verifica se encontrou o email do fornecedor - A2_XEMAIL
	If Alltrim(cDest) == ""
		cAviso += "O e-mail do fornecedor não está cadastrado!" + CRLF
		cAviso += "Fornecedor: " +cNomeForn						+ CRLF
		cAviso += "O e-mail não será enviado."
		Aviso("TTFATR98",cAviso, {"Ok"},1)	
		Return
	EndIf
	                            
	
	// Valor e Vencimento do Titulo
	// 6 -> cod, loja, pref, num tit, parc, tipo
	dbSelectArea("SE2")
	alAreaSE2 := GetArea()
	dbSetOrder(6)
	If dbSeek(xFilial("SE2") +AvKey(cCodForn,"E2_FORNECE") +AvKey(cLjForn,"E2_LOJA") +AvKey(cPrefixo,"E2_PREFIXO") +AvKey(cNumNF,"E2_NUM") +AvKey(cParcela,"E2_PARCELA") +AvKey(cTipo,"E2_TIPO") )
		cValor	:= SE2->E2_VALOR
		dVenc	:= SE2->E2_VENCTO   	
	Else                                  
		cAviso += "Título não encontrado!" +CRLF
		cAviso += "Número: " +cNumNF + CRLF
		cAviso += "Prefixo: " + cPrefixo + CRLF
		cAviso += "Parcela: " + cParcela + CRLF
		cAviso += "Tipo: " + cTipo
		Aviso("TTFATR98",cAviso, {"Ok"},1)
		Return
	EndIf
	 
	
	// Código do comprovante
	dData := Date()
	cData := DtoC(dData)
	cData := StrTran(cData,"/")
	
	cTime 		:= TIME()
	cHora 		:= SUBSTR(cTime, 1, 2)
	cMinutos 	:= SUBSTR(cTime, 4, 2)
	cSegundos 	:= SUBSTR(cTime, 7, 2)
	
	If AllTrim(cParcela) <> ""
		// Se tem parcela
		cCodComp := "comprovante_nf" +cNumNF +"_parcela" +cParcela +"_dt" +cData+cHora+cMinutos+cSegundos
	Else
		// Se for parcela unica
		cCodComp := "comprovante_nf" +cNumNF +"_dt" +cData+cHora+cMinutos+cSegundos
	EndIf     
	
	// Transforma o Valor
	cValor := CVALTOCHAR(cValor)
	
	// Corpo do email que será enviado
	cMsg := "<html>"
	cMsg += "<title></title>"
	cMsg += "<head></head>"
	cMsg += "<body>"
	cMsg += "<p><strong>Comprovante de Pagamento</strong></p><br>"                
	cMsg += "<p>Segue em anexo o comprovante de pagamento, referente a Nota Fiscal "+cNumNF+", efetuado em "+DtoC(dVenc)+".</p><br>"
	cMsg += "<p>E-mail automático, favor não responder.</p><br>"
	cMsg += "</body>"
	cMsg += "</html>
	
	oPrint      		:= FWMSPrinter():New(cCodComp,6,.F.,,.T.)
	oPrint:cPathPDF		:="C:\SPOOL\"
	oPrint:SetPortrait()
	oPrint:SetPaperSize(9)
	oPrint:SetMargin(60,60,60,60)
	oPrint:StartPage()
	
	// Empresa atual
	// Tok Take
	If cEmpAnt == "01"
	   oPrint:SayBitmap(040,010,cStartPath+"\logo_toktake.png",054,067)
	// A Maquina de Café
	ElseIf cEmpAnt == "10"
	   oPrint:SayBitmap(040,010,cStartPath+"\logo_mc.gif",056,067)
	// Dica do Chef
	ElseIf cEmpAnt == "11"
	   oPrint:SayBitmap(040,010,cStartPath+"\logo_ddc.gif",063,069)
	EndIf
	
	
	// Dados Tok Take                                                        
	oPrint:Say(050,110,AllTrim(SM0->M0_NOMECOM),oArial14N)
	oPrint:Say(070,110,'End.: '+SM0->M0_ENDCOB,oArial14)   
	oPrint:Say(090,110,'Cep: ' +substr(SM0->M0_CEPCOB,1,5)+'-'+substr(SM0->M0_CEPCOB,6,3) + '     ' + Alltrim(SM0->M0_CIDCOB) + '       ' + SM0->M0_ESTCOB,oArial14)                 
	oPrint:Say(110,110,'Tel: ' + SM0->M0_TEL + ' Fax ' + SM0->M0_FAX,oArial14)    
	oPrint:Say(130,110,'CNPJ: ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + '  IE: '  + Transform(SM0->M0_INSC,"@R 999.999.999.999"),oArial14)                                                    
	
	
	// Box do cliente                        
	oPrint:Box(165,000,830,560)
	
	// Dados do cliente
	oPrint:Say(190,200,"COMPROVANTE DE PAGAMENTO"					,oArial14N,,,,2)	// Centralizado
	oPrint:Say(220,010,"A"											,oArial14)
	oPrint:Say(240,010,cNomeForn									,oArial14)
	oPrint:Say(270,010,"Comprovante de pagamento, referente a:"		,oArial14)
	oPrint:Say(290,010,"Nota Fiscal: "+cNumNF+"."					,oArial14)
	oPrint:Say(310,010,"Valor de R$"+cValor+"."						,oArial14)
	oPrint:Say(330,010,"Vencimento em: "+DtoC(dVenc)+"."			,oArial14)
	oPrint:Say(370,010,"Pagamento efetuado em: "+DtoC(dDatabase)+".",oArial14)
	       
	oPrint:EndPage()
	oPrint:Preview()
	
	U_CpyT2S(oPrint:cPathPDF+cCodComp+".pdf","\SPOOL\"+cCodComp+".pdf")
	                    
	// prepara o anexo          
	Aadd(aArquivos,{"\SPOOL\"+cCodComp+".pdf",'Content-ID: <ID_comprovante.pdf>'})
	
	
	//Envia o email para o Fornecedor
	llRetOK := U_TTMAILN('microsiga@toktake.com.br',cDest+";"+GETMV("MV_XTTFATR"),'Comprovante',cMsg,aArquivos,.F.)
	
	//If llRetOK == 0
	//   Alert("Email enviado com sucesso para o Fornecedor")
	//Endif
	
	FreeObj(oPrint)
	oPrint := Nil	
endif  
RestArea(alAreaSA2)
RestArea(alAreaSE2)

Return llRetOK