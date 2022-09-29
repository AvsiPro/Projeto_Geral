#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "fileio.ch"

#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6

#DEFINE VBOX       080
#DEFINE VSPACE     008
#DEFINE HSPACE     010
#DEFINE SAYVSPACE  008
#DEFINE SAYHSPACE  008
#DEFINE HMARGEM    030
#DEFINE VMARGEM    030
#DEFINE MAXITEM    018                                                // Máximo de produtos para a primeira página 
#DEFINE MAXITEMP2  049                                                // Máximo de produtos para a pagina 2 em diante 
#DEFINE MAXITEMP2F 069                                                // Máximo de produtos para a página 2 em diante quando a página não possui informações complementares
#DEFINE MAXITEMP3  025                                                // Máximo de produtos para a pagina 2 em diante (caso utilize a opção de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%. 
#DEFINE MAXITEMC   022                                                // Máxima de caracteres por linha de produtos/serviços
#DEFINE MAXMENLIN  080                                                // Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG     013                                                // Máximo de dados adicionais por página
#DEFINE MAXVALORC  008                                                // Máximo de caracteres por linha de valores numéricos


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Alexandre Venancio  º Data ³  05/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina criada para envio automatico da danfe para o email  º±±
±±º          ³do cadastro do cliente, a funcao principal era de enviar    º±±
±±º          ³a danfe e o boleto automaticamente, como nao foi possivel   º±±
±±º          ³quebrar pdf a pdf na danfeii, separei a rotina para que possa±±
±±º          ³ser chamada tanto do programa original quanto atraves de jobº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTRDANFE(lReimp)

Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local cBody			:=	""
Local cSubject		:=	""
Local aArquivos		:=	{}  
Local cDestino		:=	""
Local cRemete		:=	""
Local lArqOk		:= .F.    
Private PixelX := 300        
Private PixelY := 300  
Private cBcoBol		:=	''
Private cAgcBol		:=	''
Private cCtaBol		:=	''  
Private cTipCna		:=	''   

PRIVATE oFont10N   := TFont():New("Times New Roman",08,08,.T.,.T.,5,.F.)// 1
PRIVATE oFont07N   := TFont():New("Times New Roman",06,06,.T.,.T.,5,.F.)// 2
PRIVATE oFont07    := TFont():New("Times New Roman",06,06,.F.,.T.,5,.F.)// 3
PRIVATE oFont08    := TFont():New("Times New Roman",07,07,.F.,.F.,5,.F.)// 4
PRIVATE oFont08N   := TFont():New("Times New Roman",06,06,.T.,.T.,5,.F.)// 5
PRIVATE oFont09N   := TFont():New("Times New Roman",08,08,.T.,.T.,5,.F.)// 6
PRIVATE oFont09    := TFont():New("Times New Roman",08,08,.F.,.T.,5,.F.)// 7
PRIVATE oFont10    := TFont():New("Times New Roman",09,09,.F.,.T.,5,.F.)// 8
PRIVATE oFont11    := TFont():New("Times New Roman",10,10,.F.,.T.,5,.F.)// 9
PRIVATE oFont12    := TFont():New("Times New Roman",11,11,.F.,.F.,5,.F.)// 10
PRIVATE oFont11N   := TFont():New("Times New Roman",10,10,.T.,.T.,5,.F.)// 11
PRIVATE oFont18N   := TFont():New("Times New Roman",15,15,.T.,.T.,5,.F.)// 12 
PRIVATE OFONT12N   := TFont():New("Times New Roman",10,11,.T.,.T.,5,.F.)// 12  
                            
DEFAULT lReimp		:= .F.	
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SF2"

For nXPP := val(MV_PAR01) to val(MV_PAR02) 

	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+Strzero(nXPP,9)+MV_PAR03)
	                                                   
		If Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_BLEMAIL") == "1" 
			If !"TOKTAKE" $ Alltrim(Upper(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EMAIL"))) .OR. Alltrim(Upper(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EMAIL"))) == "PROCESSAMENTO-SEV.ALIMENTACAO@TOKTAKE.COM.BR"
				cDestino := Alltrim(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EMAIL"))
			EndIf
			//If !"TOKTAKE" $ Alltrim(Upper(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_XEMAIL")))
			//	cDestino += ";"+ Alltrim(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_XEMAIL"))
			//EndIf
		    
			If !Empty(cDestino)
				cDestino := "" // ALTERADO PARA NAO ENVIAR PARA CLIENTE ATE QUE SEJA FEITO O AJUSTE		 	
				oDanfe 	:= FWMSPrinter():New("DANFE"+strzero(nXPP,9)+".rel",  IMP_PDF, lAdjustToLegacy, "\SPOOL\", lDisableSetup,,,,.F.,,,.F.)
				
				oDanfe:SetResolution(78) //Tamanho estipulado para a Danfe
				oDanfe:SetPortrait()
				oDanfe:SetPaperSize(DMPAPER_A4)
				oDanfe:StartPage()   	// Inicia uma nova página
				oDanfe:SetMargin(60,60,60,60)
				oDanfe:cPathPDF := "\SPOOL\"
				
				//A Query esta com * pois sao varios campos que preciso das duas tabelas e fiquei com preguica de digitar um a um aqui  
				//-----------------------------------------------------------------------------------------//
				//
				//           CABECALHO DA NOTA FISCAL
				//
				//----------------------------------------------------------------------------------------//
				cQuery := "SELECT *"
				cQuery += " FROM "+RetSQLName("SF2")+" F2"
				cQuery += "  INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=F2_CLIENT AND A1_LOJA=F2_LOJENT AND A1.D_E_L_E_T_=''"
				cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"'"
				//cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(DDataBase-25)+"' AND '"+dtos(DDataBase)+"'"
				cQuery += " AND F2_CHVNFE<>''"
				cQuery += " AND F2_DOC='"+strzero(nXPP,9)+"'"
				cQuery += " AND F2_SERIE='"+MV_PAR03+"'"
				cQuery += " AND F2.D_E_L_E_T_=''"
				  
				If Select("TRB") > 0
					dbSelectArea("TRB")
					dbCloseArea()
				EndIf
				  
				MemoWrite("TTRDANFE.SQL",cQuery)
				
				cQuery:= ChangeQuery(cQuery)
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
				
				DbSelectArea("TRB")
				
				aArea	:= GetArea()
				ImpDet(oDanfe,nXPP)     
				RestArea(aArea)
				DbSelectArea("TRB")
				
				oDanfe:EndPage()
				oDanfe:Preview()
				
				lArqOk := ChkArq("\spool\danfe"+Strzero(nXPP,9)+".pdf")
				// Se arquivo estiver incorreto, tenta gerar corretamente por 5 vezes
				If !lArqOk
					For nI := 1 To 5
						oDanfe 	:= FWMSPrinter():New("DANFE"+strzero(nXPP,9)+".rel",  IMP_PDF, lAdjustToLegacy, "\SPOOL\", lDisableSetup,,,,.F.,,,.F.)
						oDanfe:SetResolution(78) //Tamanho estipulado para a Danfe
						oDanfe:SetPortrait()
						oDanfe:SetPaperSize(DMPAPER_A4)
						oDanfe:StartPage()   	// Inicia uma nova página
						oDanfe:SetMargin(60,60,60,60)
						oDanfe:cPathPDF := "\SPOOL\" 			
						
						aArea := GetArea()
						ImpDet(oDanfe,nXPP)     
						RestArea(aArea)
						DbSelectArea("TRB")
						lArqOk := ChkArq("\spool\danfe"+Strzero(nXPP,9)+".pdf")
						If lArqOk
							Exit
						EndIf	
					Next nI
				EndIf
				If !lArqOk
					CONOUT("TTRDANFE - PROBLEMA DANFE - " +Strzero(nXPP,9) )
					Loop
				EndIf                                 
				
				//Esta condicao foi colocada para que o bordero seja gerado apenas uma vez.
				//If lReimp
				If Empty(Posicione("SE1",1,xFilial("SE1")+Alltrim(SF2->F2_FILIAL+SF2->F2_SERIE)+SF2->F2_DOC,"E1_PORTADO"))
					// **************************************************** //
					//														//     
					//	 Determinando qual sera o banco a enviar o titulo   //
					//	 Regra 												//     
					//		1 - Funcao Financeiro (Natureza X Banco)		//     
					//		2 - Cadastro do Cliente (A1_BCO1)				//     
					//	    3 - Caso nao atenda nenhuma das anteriores 033  //     
					// **************************************************** //
					// 1 - Funcao Financeiro (Natureza X Banco)
	                cBcoBol := RegraBco(nXPP)
	                If !Empty(cBcoBol)     
	                	cAgcBol := substr(cBcoBol,4,6)
		                cCtaBol := substr(cBcoBol,10,15)
		                cTipCna := substr(cBcoBol,25)
	                	cBcoBol := substr(cBcoBol,1,3)	                	
	                EndIf		                
	                // 2 - Cadastro do Cliente (A1_BCO1)
	                If empty(cBcoBol)
	                  	cBcoBol := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_BCO1")   
	                  	//ATE O DIA 06/03/14 TODOS OS CLIENTES ESTAVAM CADASTRADOS COM O BANCO 033.
	                  	cAgcBol	:= IF(SM0->M0_CODIGO=="01",'0643  ','00643 ')
	                   	cCtaBol	:= If(SM0->M0_CODIGO=="01",'130018031      ','130018495      ')
	                   	cTipCna	:= If(SM0->M0_CODIGO=="01",'I31','I95')
	                EndIf
	                // 3 - Caso nao atenda nenhuma das anteriores 033  
	                If empty(cBcoBol)
	                   	cBcoBol := "033"
	                   	cAgcBol	:= IF(SM0->M0_CODIGO=="01",'0643  ','00643 ')
	                   	cCtaBol	:= If(SM0->M0_CODIGO=="01",'130018031      ','130018495      ')
	                   	cTipCna	:= If(SM0->M0_CODIGO=="01",'I31','I95')
	                EndIf
	
					//Gera o Bordero para o titulo a ser gerado boleto.
					//If U_TTFINC07(TRB->F2_FILIAL+MV_PAR03, nXPP, nXPP) 
					If GeraBord(cBcoBol,cAgcBol,cCtaBol,cTipCna)
						
	                    
					    //Gera o boleto e Retorna a Data de vencimento do titulo
					    If cBcoBol == "033"
						    cRetorno := u_ttrboleto(nXPP)       
						Else
							cRetorno := u_ttrbol2(nXPP)
						EndIf
					    
					    //Destinatario do email
					    //cDestino 	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EMAIL")
					    //Remetente do email      
					    IF !empty(Getmv("MV_XMAILDP"))
					    	cDestino := alltrim(cDestino) + ";"+alltrim(Getmv("MV_XMAILDP"))
					    EndIf
					    cRemete     := "cadastro@toktake.com.br"
					    //Conteudo do corpo da mensagem do email
					    cBody		:=	GetHtm(nXPP,cRetorno)           
					    
					    If !empty(cRetorno)
						    //Assunto do email
						    cSubject	:=	"TOK TAKE  -  NFE "+SF2->F2_DOC+" e BOLETO BANCÁRIO  VCTO "+cvaltochar(cRetorno)
						else
						    cSubject	:=	"TOK TAKE  -  NFE "+SF2->F2_DOC //e BOLETO BANCÁRIO  VCTO "+cvaltochar(cRetorno)
						Endif
					    //Arquivos a serem atachados no email - padrão - Local do arquivo e content id "apelido" do arquivo 
					    aArquivos := {}                                           
					    
					    Sleep(6000)
					                                   
					    If !empty(cRetorno)
						    Aadd(aArquivos,{"\spool\boleto"+Strzero(nXPP,9)+".pdf",'Content-ID: <ID_boleto.pdf>'})
						EndIf
						
					    Aadd(aArquivos,{"\spool\danfe"+Strzero(nXPP,9)+".pdf",'Content-ID: <ID_danfe.pdf>'})
					    Aadd(aArquivos,{"\system\logocob.jpg",'Content-ID: <ID_logocob.jpg>'})
			
					    //Utilizando a nova classe de email para poder anexar corretamente o email ao corpo da mensagem.
					    // ************************************************************ //
					    // 		Parametros da rotina de envio de email  			  	//
					    //																//
					    //	01 - Remetente da mensagem                                  //
					    //	02 - Destinatario do email                                  //
					    //	03 - Assunto do email                                       //
					    //	04 - Corpo da mensagem                                      //
					    //	05 - Array com arquivos a serem atachados                   //
						//			Posicao 1 - \Caminho\NomeArquivo.extensao           //
						//			Posicao 2 - Content-ID "Apelido" da imagem          //
						//	06 - Confirmacao de leitura (logico)						//
						// ************************************************************ //
						//Validacao colocada a pedido do Rodrigo do Processamento, para eles receberem uma copia da danfe e boleto tambem dos pedidos Pro-a
						//09/04/2013 - Alexandre                                                   
						If Alltrim(SF2->F2_XGPV) == "PRO-A"
							cDestino := Alltrim(cDestino)+";GrupoProcessamento@toktake.com.br"
						EndIf                
						
					    U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
					EndIf 
				ELSE
					//Nova validacao para poder reimprimir e retransmitir as notas e boletos 
				    If lReimp           
				    	
				    	cBcoBol := Posicione("SE1",1,xFilial("SE1")+Alltrim(SF2->F2_FILIAL+SF2->F2_SERIE)+SF2->F2_DOC,"E1_PORTADO") 
				    	If cBcoBol == "033"
						    cRetorno := u_ttrboleto(nXPP)       
						Else
							cRetorno := u_ttrbol2(nXPP)
						EndIf
					    
					    //Destinatario do email
					    //cDestino 	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_EMAIL")
					    IF !empty(Getmv("MV_XMAILDP"))
					    	cDestino := alltrim(cDestino) + ";"+alltrim(Getmv("MV_XMAILDP"))
					    EndIf  
					    //Adicionando o usuario que solicitou a reimpressao da nf para envio por email
					    cDestino := Alltrim(cDestino) + ";" + alltrim(cusername)+"@toktake.com.br"
					    
					    //Remetente do email      
					    cRemete     := "cadastro@toktake.com.br"
		       
					   If !Empty(cRetorno) 
					   		//Conteudo do corpo da mensagem do email
				    		cBody		:=	GetHtm(nXPP,cRetorno)    
						    //Assunto do email
						    cSubject	:=	"TOK TAKE  -  NFE e BOLETO BANCÁRIO  VCTO "+cvaltochar(cRetorno)
						Else
						    cSubject	:=	"TOK TAKE  -  NFE"
						EndIf
						
						
					    //Arquivos a serem atachados no email - padrão - Local do arquivo e content id "apelido" do arquivo 
					    aArquivos := {}                      
					    
					    Sleep(6000)
					    
					  	If !empty(cRetorno)
							Aadd(aArquivos,{"\spool\boleto"+Strzero(nXPP,9)+".pdf",'Content-ID: <ID_boleto.pdf>'})
						EndIf
					    Aadd(aArquivos,{"\spool\danfe"+Strzero(nXPP,9)+".pdf",'Content-ID: <ID_danfe.pdf>'})
					    Aadd(aArquivos,{"\system\logocob.jpg",'Content-ID: <ID_logocob.jpg>'})
					    
					    //Validacao colocada a pedido do Rodrigo do Processamento, para eles receberem uma copia da danfe e boleto tambem dos pedidos Pro-a
						//09/04/2013 - Alexandre                                                   
						If Alltrim(SF2->F2_XGPV) == "PRO-A"
							cDestino := Alltrim(cDestino)+";GrupoProcessamento@toktake.com.br"
						EndIf
						
					 	U_TTMAILN(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
					EndIf
				EndIf
			EndIf
			cDestino := "" 
		EndIf   
	EndIf
		
Next nXPP


//RESET ENVIRONMENT

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Alexandre Venancio  º Data ³  05/18/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Corpo do email                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetHtm(cnota,cRetorno)   

cHtml := "<table width='764' height='421' border='1'>"
cHtml += "  <tr>"
cHtml += "    <td height='351' colspan='2'><p>Prezado Cliente,</p>"
cHtml += "	 <p>Para simplificar nossa relação, você esta recebendo uma cópia da nota fiscal número "+Strzero(cnota,9)+If(!empty(cRetorno)," e do boleto correspondente.</p>","</p>")
cHtml += "	 <p>&nbsp;</p>"   
//cHtml += "		<p>Informamos que a partir do dia <b>12/12/2012</b>, os títulos registrados em banco, seguirão com instrução automática de protesto. Qualquer divergência, dúvida gerada em relação as notas, deverá ser tratada antes do vencimento. </p>"
cHtml += "		<p>&nbsp;</p>"
cHtml += "		<p>Vale informar que os boletos e suas respectivas notas  são enviados automaticamente através do e-mail cadastro@toktake.com.br, a atualização dos dados da sua conta eletrônica é de suma importância, qualquer alteração, informar.</p>"
cHtml += "		<p>&nbsp;</p>"
cHtml += "		<p>Certos do vosso entendimento  e compreensão, ficamos à disposição. </p>"
cHtml += "    <p>Caso você não seja o destinatário correto desse e-mail, por gentileza, remova-o e nos avise contasareceber@toktake.com.br .</p>" 
cHtml += "	<img src='cid:ID_logocob.jpg'></td>"
cHtml += " </tr>"
cHtml += " <tr>"
cHtml += "   <td width='696'><a href='http://www.toktake.com.br/' title='TokTake'>Site TokTake</a> ."
cHtml += "    </td>"
cHtml += "</tr>"
cHtml += "</table>"



Return(cHtml)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Alexandre Venancio  º Data ³  05/17/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Detalhes da Danfe.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpDet(oDanfe,nXPP)  
                                                                                    
Local nMaxItemP2    := MAXITEM // Variável utilizada para tratamento de quantos itens devem ser impressos na página corrente 
Local nMaxDes	    := MAXITEMC          
Local aMensagem		:=	{} 
Local cTes			:=	""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Box - Recibo de entrega                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SM0")
DbSetorder(1)

    

oDanfe:Box(000,000,010,501)
oDanfe:Say(006, 002, "RECEBEMOS DE "+SM0->M0_NOMECOM+" OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO", oFont07)
oDanfe:Box(009,000,037,101)
oDanfe:Say(017, 002, "DATA DE RECEBIMENTO", oFont07N )
oDanfe:Box(009,100,037,500)
oDanfe:Say(017, 102, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont07N )
oDanfe:Box(000,500,037,603)
oDanfe:Say(007, 510, "NF-e/F.: "+xFilial("SF2"), oFont08N )
oDanfe:Say(017, 510, "N. "+StrZero(Val(TRB->F2_DOC),9), oFont08 )
oDanfe:Say(027, 510, "SÉRIE "+TRB->F2_SERIE, oFont08 )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 1 IDENTIFICACAO DO EMITENTE                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:Box(095,000,190,250)
oDanfe:Say(106,098, "Identificação do emitente",oFont12N )
nLinCalc	:=	128        
cStrAux		:=	AllTrim(SM0->M0_NOMECOM)
nForTo		:=	Len(cStrAux)/25
nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
For nX := 1 To nForTo
	oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*25)+1),25), oFont12N  )
	nLinCalc+=10
Next nX

cStrAux		:=	AllTrim(SM0->M0_ENDCOB)
nForTo		:=	Len(cStrAux)/32
nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
For nX := 1 To nForTo
	oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
	nLinCalc+=10
Next nX
    
	oDanfe:Say(nLinCalc,098,"Complemento: "+Alltrim(SM0->M0_COMPCOB),oFont08N)
	nLinCalc+=10
		
	cStrAux		:=	AllTrim(SM0->M0_BAIRCOB)
	cStrAux		+=	" Cep:"+TransForm(SM0->M0_CEPCOB,"@r 99999-999") 
	nForTo		:=	Len(cStrAux)/32
	nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
	For nX := 1 To nForTo
		oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
		nLinCalc+=10
	Next nX
	oDanfe:Say(nLinCalc,098, SM0->M0_CIDCOB+"/"+SM0->M0_ESTCOB ,oFont08N ) 
	nLinCalc+=10
	oDanfe:Say(nLinCalc,098, "Fone: "+SM0->M0_TEL,oFont08N ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 2                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDanfe:Box(095,248,190,351)
oDanfe:Say(108,255, "DANFE",oFont18N )
oDanfe:Say(118,255, "DOCUMENTO AUXILIAR DA",oFont08 )
oDanfe:Say(128,255, "NOTA FISCAL ELETRÔNICA",oFont08 )
oDanfe:Say(138,255, "0-ENTRADA",oFont08 )
oDanfe:Say(148,255, "1-SAÍDA"  ,oFont08 )
oDanfe:Box(131,305,141,315)
oDanfe:Say(138,307, "1" ,oFont08N )
oDanfe:Say(163,255,"N. "+StrZero(Val(TRB->F2_DOC),9),oFont10N )
oDanfe:Say(173,255,"SÉRIE "+TRB->F2_SERIE,oFont10N )   
nFolha := 1
nFolhas := 1
oDanfe:Say(183,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aUF := {}

aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Logotipo                                     						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cLogoD := GetSrvProfString("Startpath","") + "DANFE0101.BMP"
//If !File(cLogoD)
	//cLogoD	:= GetSrvProfString("Startpath","") + "DANFE01.BMP"
	cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt+ ".BMP"
	If !File(cLogoD)
		lMv_Logod := .F.
	EndIf
//EndIf

If nfolha==1
	oDanfe:SayBitmap(095,000,cLogoD,095,096)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Codigo de barra                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDanfe:Box(095,351,128,603)
oDanfe:Box(128,351,158,603)
oDanfe:Say(148,355,TransForm(TRB->F2_CHVNFE,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N ) //aqui
oDanfe:Box(158,351,190,603)

If nFolha == 1
	oDanfe:Say(138,355,"CHAVE DE ACESSO DA NF-E",oFont12N )
	nFontSize := 28
	oDanfe:Code128C(125,370,TRB->F2_CHVNFE, nFontSize )   //aqui
EndIf

cChaveCont := ""
cCodAutDPEC := ""
If Empty(cCodAutDPEC)
	If Empty(cChaveCont)
		oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
		oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
	Endif
Endif

If  !Empty(cCodAutDPEC)
	oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
	oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 4                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDanfe:Box(192,000,215,603)
oDanfe:Box(192,000,215,351)

oDanfe:Say(201,002,"NATUREZA DA OPERAÇÃO",oFont08N )
//O CONTEUDO ESTA MAIS ABAIXO

//			oDanfe:Say(211,302,IIF(!Empty(cCodAutDPEC),cCodAutDPEC+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),IIF(!Empty(cCodAutSef) .And. ((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"23") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1",cCodAutSef+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"))),oFont08 )

nFolha++


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 5                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:Box(217,000,240,603)
oDanfe:Box(217,000,240,200)
oDanfe:Box(217,200,240,400)
oDanfe:Box(217,400,240,603)
oDanfe:Say(225,002,"INSCRIÇÃO ESTADUAL",oFont08N )
oDanfe:Say(233,002,SM0->M0_INSC ,oFont08 ) 
oDanfe:Say(225,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N )
oDanfe:Say(233,205,'',oFont08 )
oDanfe:Say(225,405,"CNPJ",oFont08N )
oDanfe:Say(233,405,TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99"),oFont08 )  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro destinatário/remetente                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case TRB->A1_PESSOA == "J"
		cAux := TransForm(TRB->A1_CGC,"@r 99.999.999/9999-99")	
	Case TRB->A1_PESSOA == "F"
		cAux := TransForm(TRB->A1_CGC,"@r 999.999.999-99")
	OtherWise
		cAux := Space(14)
EndCase


oDanfe:Say(248,002,"DESTINATARIO/REMETENTE",oFont08N )
oDanfe:Box(250,000,270,450)
oDanfe:Say(258,002, "NOME/RAZÃO SOCIAL",oFont08N )
oDanfe:Say(268,002,TRB->A1_NOME,oFont08 ) 
oDanfe:Box(250,280,270,500)
oDanfe:Say(258,283,"CNPJ/CPF",oFont08N )
oDanfe:Say(268,283,cAux,oFont08 )

oDanfe:Box(270,000,290,500)
oDanfe:Box(270,000,290,260)
oDanfe:Say(277,002,"ENDEREÇO",oFont08N )
oDanfe:Say(287,002,Alltrim(TRB->A1_END)+" " + Alltrim(TRB->A1_COMPLEM),oFont08 )	
oDanfe:Box(270,230,290,380)
oDanfe:Say(277,232,"BAIRRO/DISTRITO",oFont08N )
oDanfe:Say(287,232,TRB->A1_BAIRRO ,oFont08 )	
oDanfe:Box(270,380,290,500)
oDanfe:Say(277,382,"CEP",oFont08N )
oDanfe:Say(287,382,Transform(TRB->A1_CEP,"@R 99999-999"),oFont08 )	
oDanfe:Box(289,000,310,500)
oDanfe:Box(289,000,310,180)
oDanfe:Say(298,002,"MUNICIPIO",oFont08N )
oDanfe:Say(308,002,TRB->A1_MUN,oFont08 )	
oDanfe:Box(289,150,310,256)
oDanfe:Say(298,152,"FONE/FAX",oFont08N )
oDanfe:Say(308,152,Transform(TRB->A1_TEL,"@R 9999-9999"),oFont08 )	
oDanfe:Box(289,255,310,341)
oDanfe:Say(298,257,"UF",oFont08N )
oDanfe:Say(308,257,TRB->A1_EST,oFont08 )	
oDanfe:Box(289,340,310,500)
oDanfe:Say(298,342,"INSCRIÇÃO ESTADUAL",oFont08N )
oDanfe:Say(308,342,TRB->A1_INSCR,oFont08 )	


oDanfe:Box(250,502,270,603)
oDanfe:Say(258,504,"DATA DE EMISSÃO",oFont08N )
oDanfe:Say(268,504,cvaltochar(stod(TRB->F2_EMISSAO)),oFont08 )	
oDanfe:Box(270,502,290,603)
oDanfe:Say(277,504,"DATA ENTRADA/SAÍDA",oFont08N )
oDanfe:Box(289,502,310,603)
oDanfe:Say(298,503,"HORA ENTRADA/SAÍDA",oFont08N )


oDanfe:Say(316,002,"FATURA",oFont08N )
oDanfe:Box(318,000,349,068)
oDanfe:Box(318,067,349,134)
oDanfe:Box(318,134,349,202)
oDanfe:Box(318,201,349,268)
oDanfe:Box(318,268,349,335)
oDanfe:Box(318,335,349,403)
oDanfe:Box(318,402,349,469)
oDanfe:Box(318,469,349,537)
oDanfe:Box(318,536,349,603)

nColuna := 002     
DbSelectArea("SE1")
DbSetOrder(2)
If Dbseek(xFilial("SE1")+AvKey(TRB->F2_CLIENTE,"E1_CLIENTE") +AvKey(TRB->F2_LOJA,"E1_LOJA") +AvKey(TRB->F2_FILIAL+TRB->F2_SERIE,"E1_PREFIXO") +AvKey(TRB->F2_DOC,"E1_NUM") )
	While !EOF() .AND. SE1->E1_PREFIXO == TRB->F2_FILIAL+ALLTRIM(TRB->F2_SERIE) .AND. TRB->F2_DOC == SE1->E1_NUM .AND. TRB->F2_CLIENTE == SE1->E1_CLIENTE
		oDanfe:Say(326,nColuna,SE1->E1_PREFIXO+SE1->E1_NUM,oFont08)
		oDanfe:Say(334,nColuna,CVALTOCHAR(SE1->E1_VENCREA),oFont08)
		//oDanfe:Say(342,nColuna,TRANSFORM(SE1->E1_VALOR,"@E 999,999,999,99"),oFont08)
		oDanfe:Say(342,nColuna,CVALTOCHAR(SE1->E1_VALOR),oFont08)
		nColuna:= nColuna+67                                 
		Dbskip()
	EndDo
Endif
         
DbSelectArea("TRB")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do imposto                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:Say(358,002,"CALCULO DO IMPOSTO",oFont08N )
oDanfe:Box(360,000,383,121)
oDanfe:Say(369,002,"BASE DE CALCULO DO ICMS",oFont08N )
oDanfe:Say(379,002,TRANSFORM(TRB->F2_BASEICM,"@e 999,999,999.99"),oFont08 ) 
oDanfe:Box(360,120,383,200)
oDanfe:Say(369,125,"VALOR DO ICMS",oFont08N )	
oDanfe:Say(379,125,TRANSFORM(TRB->F2_VALICM,"@e 999,999,999.99"),oFont08 )		
oDanfe:Box(360,199,383,360)
oDanfe:Say(369,200,"BASE DE CALCULO DO ICMS SUBSTITUIÇÃO",oFont08N )
oDanfe:Say(379,202,TRANSFORM(TRB->F2_BRICMS,"@e 999,999,999.99"),oFont08 )		
oDanfe:Box(360,360,383,490)
oDanfe:Say(369,363,"VALOR DO ICMS SUBSTITUIÇÃO",oFont08N )
oDanfe:Say(379,363,TRANSFORM(TRB->F2_ICMSRET,"@e 999,999,999.99") ,oFont08 )	
oDanfe:Box(360,490,383,603)
oDanfe:Say(369,491,"VALOR TOTAL DOS PRODUTOS",oFont08N )
oDanfe:Say(379,491,TRANSFORM(TRB->F2_VALMERC,"@e 999,999,999.99"),oFont08 )	


oDanfe:Box(383,000,406,110)
oDanfe:Say(392,002,"VALOR DO FRETE",oFont08N )
oDanfe:Say(402,002,If(TRB->F2_FRETE>0,TRANSFORM(TRB->F2_FRETE,"@e 999,999,999.99"),''),oFont08 )	
oDanfe:Box(383,100,406,190)
oDanfe:Say(392,102,"VALOR DO SEGURO",oFont08N )
oDanfe:Say(402,102,If(TRB->F2_SEGURO>0,TRANSFORM(TRB->F2_SEGURO,"@e 999,999,999.99"),''),oFont08 )		
oDanfe:Box(383,190,406,290)
oDanfe:Say(392,194,"DESCONTO",oFont08N )
oDanfe:Say(402,194,If(TRB->F2_DESCONT>0,TRANSFORM(TRB->F2_DESCONT,"@e 999,999,999.99"),''),oFont08 )	
oDanfe:Box(383,290,406,415)
oDanfe:Say(392,295,"OUTRAS DESPESAS ACESSÓRIAS",oFont08N )
oDanfe:Say(402,295,'',oFont08 )
oDanfe:Box(383,414,406,500)
oDanfe:Say(392,420,"VALOR DO IPI",oFont08N )
oDanfe:Say(402,420,If(TRB->F2_VALIPI>0,TRANSFORM(TRB->F2_VALIPI,"@e 999,999,999.99"),''),oFont08 )  	
oDanfe:Box(383,500,406,603)
oDanfe:Say(392,506,"VALOR TOTAL DA NOTA",oFont08N )
oDanfe:Say(402,506,TRANSFORM(TRB->F2_VALBRUT,"@e 999,999,999.99"),oFont08 )	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transportador/Volumes transportados                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:Say(414,002,"TRANSPORTADOR/VOLUMES TRANSPORTADOS",oFont08N )
oDanfe:Box(416,000,439,603)
oDanfe:Say(425,002,"RAZÃO SOCIAL",oFont08N )
oDanfe:Say(435,002, Posicione("SA4",1,xFilial("SA4")+TRB->F2_TRANSP,"A4_NOME") ,oFont08 ) 	
oDanfe:Box(416,245,439,315)
oDanfe:Say(425,247,"FRETE POR CONTA",oFont08N )        

cModFrete := TRB->F2_TPFRETE                                
If cModFrete =="0"										
	oDanfe:Say(435,247,"0-EMITENTE",oFont08 )
ElseIf cModFrete =="1"
	oDanfe:Say(435,247,"1-DEST/REM",oFont08 )
ElseIf cModFrete =="2"
	oDanfe:Say(435,247,"2-TERCEIROS",oFont08 )
ElseIf cModFrete =="9"
	oDanfe:Say(435,247,"9-SEM FRETE",oFont08 )
Else
	oDanfe:Say(435,247,"",oFont08 )
Endif

oDanfe:Box(416,315,439,370)
oDanfe:Say(425,317,"CÓDIGO ANTT",oFont08N )

oDanfe:Box(416,370,439,490)
oDanfe:Say(425,375,"PLACA DO VEÍCULO",oFont08N )
oDanfe:Say(435,375,TRB->F2_XPLACA,oFont08 )		
oDanfe:Box(416,450,439,510)
oDanfe:Say(425,452,"UF",oFont08N )
oDanfe:Say(435,452,'',oFont08 )  	
oDanfe:Box(416,510,439,603)
oDanfe:Say(425,512,"CNPJ/CPF",oFont08N )
oDanfe:Say(435,512,Transform(Posicione("SA4",1,xFilial("SA4")+TRB->F2_TRANSP,"A4_CGC"),"@r 99.999.999/9999-99") ,oFont08 )  	

oDanfe:Box(438,000,462,603)
oDanfe:Box(438,000,462,241)
oDanfe:Say(446,002,"ENDEREÇO",oFont08N )
oDanfe:Say(457,002,Posicione("SA4",1,xFilial("SA4")+TRB->F2_TRANSP,"A4_END"),oFont08 )  	
oDanfe:Box(438,240,462,341)
oDanfe:Say(446,242,"MUNICIPIO",oFont08N )
oDanfe:Say(457,242,Posicione("SA4",1,xFilial("SA4")+TRB->F2_TRANSP,"A4_MUN"),oFont08 ) 		
oDanfe:Box(438,340,462,440)
oDanfe:Say(446,342,"UF",oFont08N )
oDanfe:Say(457,342,Posicione("SA4",1,xFilial("SA4")+TRB->F2_TRANSP,"A4_EST"),oFont08 )  	
oDanfe:Box(438,440,462,603)
oDanfe:Say(446,442,"INSCRIÇÃO ESTADUAL",oFont08N )
oDanfe:Say(457,442,Posicione("SA4",1,xFilial("SA4")+TRB->F2_TRANSP,"A4_INSEST"),oFont08 )   	


oDanfe:Box(461,000,485,603)
oDanfe:Box(461,000,485,050)
oDanfe:Say(471,002,"QUANTIDADE",oFont08N )
oDanfe:Say(482,002,CVALTOCHAR(TRB->F2_VOLUME1),oFont08 )	
oDanfe:Box(461,100,485,200)
oDanfe:Say(471,102,"ESPECIE",oFont08N )


oDanfe:Say(482,102,TRB->F2_ESPECI1,oFont08 )    

oDanfe:Box(461,200,485,301)
oDanfe:Say(471,202,"MARCA",oFont08N )
//oDanfe:Say(482,202,aTransp[13],oFont08 )	//AQUI
oDanfe:Box(461,300,485,400)
oDanfe:Say(471,302,"NUMERAÇÃO",oFont08N )
//oDanfe:Say(482,302,aTransp[14],oFont08 ) 	//AQUI
oDanfe:Box(461,400,485,501)
oDanfe:Say(471,402,"PESO BRUTO",oFont08N )


oDanfe:Say(482,402,Transform(TRB->F2_PBRUTO,"@E 999999.9999"),oFont08 )	

oDanfe:Box(461,500,485,603)
oDanfe:Say(471,502,"PESO LIQUIDO",oFont08N )


oDanfe:Say(482,502,Transform(TRB->F2_PLIQUI,"@E 999999.9999"),oFont08 )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do ISSQN                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oDanfe:Say(686,000,"CALCULO DO ISSQN",oFont08N )
oDanfe:Box(688,000,711,151)
oDanfe:Say(696,002,"INSCRIÇÃO MUNICIPAL",oFont08N )
oDanfe:Say(706,002,SM0->M0_INSCM,oFont08 )		//AQUI
oDanfe:Box(688,150,711,301)
oDanfe:Say(696,152,"VALOR TOTAL DOS SERVIÇOS",oFont08N )
//oDanfe:Say(706,152,aISSQN[2],oFont08 )		//AQUI
oDanfe:Box(688,300,711,451)
oDanfe:Say(696,302,"BASE DE CÁLCULO DO ISSQN",oFont08N )
//oDanfe:Say(706,302,aISSQN[3],oFont08 ) 		//AQUI
oDanfe:Box(688,450,711,603)
oDanfe:Say(696,452,"VALOR DO ISSQN",oFont08N )
//oDanfe:Say(706,452,aISSQN[4],oFont08 )   		//AQUI

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados Adicionais                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:Say(719,000,"DADOS ADICIONAIS",oFont08N )
oDanfe:Box(721,000,865,351)
oDanfe:Say(729,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N )



oDanfe:Box(721,350,865,603)
oDanfe:Say(729,352,"RESERVADO AO FISCO",oFont08N )
/*
nLenMensagens:= Len(aResFisco)
nLin:= 741
For nX := 1 To Min(nLenMensagens, MAXMSG)
	oDanfe:Say(nLin,351,aResFisco[nX],oFont08 )
	nLin:= nLin+10
Next
  */
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto ou servico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAux := {{{},{},{},{},{},{},{},{},{},{},{},{},{},{}}}
nY := 0                
aItens := {}                                                                  

cQy := "SELECT D2_COD,B1_DESC,B1_POSIPI,D2_CLASFIS,D2_CF,D2_UM,D2_QUANT,D2_PRUNIT,D2_TOTAL,D2_BASEICM,D2_VALICM,D2_IPI,D2_PICM,D2_IPI,D2_TES,D2_PEDIDO"
cQy += " FROM "+RetSQLName("SD2")+" D2"
cQy += "  INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
cQy += " WHERE D2_DOC='"+Strzero(nXPP,9)+"'"
cQy += " AND D2_SERIE='"+MV_PAR03+"'"     
cQy += " AND D2_FILIAL='"+xFilial("SD2")+"'"
//cQy += " AND D2_EMISSAO BETWEEN '"+dtos(DDatabase-1)+"' AND '"+dtos(DDatabase)+"'"
cQy += " AND D2.D_E_L_E_T_=''"
     
If Select("TRB2") > 0
	dbSelectArea("TRB2")
	dbCloseArea()
EndIf
  
MemoWrite("TTRDANFE2.SQL",cQy)

cQy:= ChangeQuery(cQy)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQy),'TRB2',.T.,.T.)   

DbSelectArea("TRB2")

oDanfe:Say(211,002,Posicione("SF4",1,xFilial("SF4")+TRB2->D2_TES,"F4_TEXTO"),oFont08 )        //aqui F4_FINALID   
cTes := Posicione("SF4",1,xFilial("SF4")+TRB2->D2_TES,"F4_TEXTO")
cNumPed := ""
cMsgPed := ""

While !EOF() 

	Aadd(aItens,{TRB2->D2_COD,Substr(TRB2->B1_DESC,1,nMaxDes),TRB2->B1_POSIPI,TRB2->D2_CLASFIS,;
				TRB2->D2_CF,TRB2->D2_UM,TRB2->D2_QUANT,TRB2->D2_PRUNIT,TRB2->D2_TOTAL,;
				TRB2->D2_BASEICM,TRB2->D2_VALICM,TRB2->D2_IPI,TRB2->D2_PICM,TRB2->D2_IPI})	
	If len(Alltrim(TRB2->B1_DESC)) > nMaxDes
		Aadd(aItens,{'',Substr(TRB2->B1_DESC,nMaxDes+1,nMaxDes),'','',;
				'','','','','',;
				'','','','',''})	
	EndIf	
    
	If !Empty(Posicione("SF4",1,xFilial("SF4")+TRB2->D2_TES,"F4_FORMULA")) .AND. Ascan(aMensagem,{|x| x[2] = TRB2->D2_TES}) == 0  
		cAux := Posicione("SM4",1,xFilial("SM4")+Posicione("SF4",1,xFilial("SF4")+TRB2->D2_TES,"F4_FORMULA"),"M4_FORMULA")
		aadd(aMensagem,{strtran(cAux,'"'),TRB2->D2_TES})
	EndIf
	If Empty(cNumped)
		cMsgPed := Alltrim(Posicione("SC5",1,xFilial("SC5")+TRB2->D2_PEDIDO,"C5_MENNOTA")) 
		cNumPed := TRB2->D2_PEDIDO
	EndIf
	DbSkip()
EndDo
    
nLenMensagens:= Len(aMensagem)			//AQUI
nLin:= 741
nMensagem := 0
For nX := 1 To Min(nLenMensagens, MAXMSG)
	oDanfe:Say(nLin,002,substr(aMensagem[nX][1],1,MAXMENLIN),oFont08 )
	nLin:= nLin+10                                           
	If len(Alltrim(aMensagem[nX][1])) > MAXMENLIN
		oDanfe:Say(nLin,002,substr(aMensagem[nX][1],MAXMENLIN+1,MAXMENLIN),oFont08 )
		nLin:= nLin+10
		If len(Alltrim(aMensagem[nX][1])) > (MAXMENLIN * 2)
			oDanfe:Say(nLin,002,substr(aMensagem[nX][1],(MAXMENLIN*2)+1,MAXMENLIN),oFont08 )
			nLin:= nLin+10                                            
		EndIf
	EndIf
Next nX         


nMensagem := nX 

DbSelectArea("TRB")

nAuxN := len(Alltrim(cMsgPed))

cAux2 := substr(cMsgPed,1,MAXMENLIN)
nPP	  := 1

While nAuxN > 0
	oDanfe:Say(nLin,002,cAux2,oFont08)
	nAuxN -= MAXMENLIN
	cAux2 := substr(cMsgPed,MAXMENLIN*nPP,MAXMENLIN)
	nPP++ 
	nLin := nLin + 10
EndDo
                      
oDanfe:Say(nLin+10,002,"Pedido : "+cNumPed+" Cod.Cli: "+TRB->A1_COD+TRB->A1_LOJA+" Nome Fantasia "+TRB->A1_NREDUZ,oFont08)

nLenItens := Len(aItens)
//AQUI//AQUI//AQUI//AQUI
For nX :=1 To nLenItens
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][01])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][02])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][03])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][04])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][05])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][06])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][07])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][08])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][09])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][10])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][11])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][12])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][13])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][14])
	If nY >= 14
		nY := 0
	EndIf
Next nX
For nX := 1 To nLenItens
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	If nY >= 14
		nY := 0
	EndIf
	
Next nX

// Popula o array de cabeçalho das colunas de produtos/serviços.
aAuxCabec := {;
	"COD. PROD",;
	"DESCRIÇÃO DO PROD./SERV.",;
	"NCM/SH",;
	"CST",;
	"CFOP",;
	"UN",;
	"QUANT.",;
	"V.UNITARIO",;
	"V.TOTAL",;
	"BC.ICMS",;
	"V.ICMS",;
	"V.IPI",;
	"A.ICMS",;
	"A.IPI";
}

// Retorna o tamanho das colunas baseado em seu conteudo
//aTamCol := RetTamCol(aAuxCabec, aAux, oDanfe, oFont08 , oFont08N )
              //verificaraqui
oDanfe:Say(493,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N )
oDanfe:Box(495,000,678,603)

oDanfe:Box(495,000,678,052)
oDanfe:Say(503,002,"COD. PROD",oFont08N )

oDanfe:Box(495,052,678,155)
oDanfe:Say(503,054,"DESCRIÇÃO DO PROD./SERV.",oFont08N )

oDanfe:Box(495,155,678,190)
oDanfe:Say(503,157,"NCM/SH",oFont08N )

oDanfe:Box(495,190,678,210)
oDanfe:Say(503,192,"CST",oFont08N )

oDanfe:Box(495,210,678,230)
oDanfe:Say(503,212,"CFOP",oFont08N )

oDanfe:Box(495,230,678,250)
oDanfe:Say(503,232,"UN",oFont08N )

oDanfe:Box(495,250,678,289)
oDanfe:Say(503,252,"QUANT.",oFont08N )

oDanfe:Box(495,289,678,346)
oDanfe:Say(503,292,"V.UNITARIO",oFont08N )

oDanfe:Box(495,346,678,400)
oDanfe:Say(503,352,"V.TOTAL",oFont08N )

oDanfe:Box(495,400,678,465)
oDanfe:Say(503,402,"BC.ICMS",oFont08N )

oDanfe:Box(495,465,678,515)
oDanfe:Say(503,467,"V.ICMS",oFont08N )

oDanfe:Box(495,515,678,550)
oDanfe:Say(503,517,"V.IPI",oFont08N )

oDanfe:Box(495,550,678,578)
oDanfe:Say(503,552,"A.ICMS",oFont08N )

oDanfe:Box(495,578,678,603)
oDanfe:Say(503,582,"A.IPI",oFont08N )


// INICIANDO INFORMAÇÕES PARA O CABEÇALHO DA PAGINA 2
nLinha	:= 513
nL	:= 0
lFlag	:= .T.

For nY := 1 To nLenItens
	nL++
	
	nLin:= 741
	nCont := 0

	If lflag
		If nL > nMaxItemP2    
			//oDanfe:Say( 660,250,"CÓPIA DA DANFE ENVIADA POR EMAIL",oFont12,,CLR_HRED,290 )
			oDanfe:EndPage()
			oDanfe:StartPage()

			nLinhavers := 42


			nLinha    	:=	265 //181 + IIF(nFolha >=3 ,0, nLinhavers)
			
			oDanfe:Box(095,000,190,250) //oDanfe:Box(000+nLinhavers,000,095+nLinhavers,250)

			oDanfe:Say(106,098, "Identificação do emitente",oFont12N )
			

			nLinCalc	:=	128 //023 + nLinhavers
			cStrAux		:=	AllTrim(SM0->M0_NOMECOM)
			nForTo		:=	Len(cStrAux)/25
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*25)+1),25), oFont12N  )
				nLinCalc+=10
			Next nX
			
			cStrAux		:=	AllTrim(SM0->M0_ENDCOB)
			nForTo		:=	Len(cStrAux)/32
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
				nLinCalc+=10
			Next nX
			
			cStrAux		:=	"Complemento: "+Alltrim(SM0->M0_COMPCOB)
			nForTo		:=	Len(cStrAux)/32
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
				nLinCalc+=10
			Next nX
			
			cStrAux		:=	AllTrim(SM0->M0_BAIRCOB)
			cStrAux		+=	" Cep:"+TransForm(SM0->M0_CEPCOB,"@r 99999-999")

			nForTo		:=	Len(cStrAux)/32
			nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
				nLinCalc+=10
			Next nX     
			
			oDanfe:Say(nLinCalc,098, SM0->M0_CIDCOB+"/"+SM0->M0_ESTCOB,oFont08N )
			nLinCalc+=10
			oDanfe:Say(nLinCalc,098, "Fone: "+SM0->M0_TEL,oFont08N )
			
			oDanfe:Box(095,248,190,351)
			oDanfe:Say(108,255, "DANFE",oFont18N )
			oDanfe:Say(118,255, "DOCUMENTO AUXILIAR DA",oFont08 )
			oDanfe:Say(128,255, "NOTA FISCAL ELETRÔNICA",oFont08 )
			oDanfe:Say(138,255, "0-ENTRADA",oFont08 )
			oDanfe:Say(148,255, "1-SAÍDA"  ,oFont08 )
			oDanfe:Box(131,305,141,315)
			oDanfe:Say(138,307, "1",oFont08N )
			oDanfe:Say(163,255,"N. "+StrZero(val(TRB->F2_DOC),9),oFont10N )
			oDanfe:Say(173,255,"SÉRIE "+TRB->F2_SERIE,oFont10N )
			oDanfe:Say(183,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N )
			

			oDanfe:Box(095,351,128,603)

			oDanfe:Box(128,351,158,603)
			//oDanfe:Box(040+nLinhavers,350,062+nLinhavers,603)
			//oDanfe:Box(063+nLinhavers,350,095+nLinhavers,603)
			oDanfe:Say(148,355,TransForm(TRB->F2_CHVNFE,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N )
			oDanfe:Box(158,351,190,603)
			
			oDanfe:Say(138,355,"CHAVE DE ACESSO DA NF-E",oFont12N )
			nFontSize := 28
			oDanfe:Code128C(125,370,TRB->F2_CHVNFE, nFontSize )
			
			oDanfe:SayBitmap(095,000,cLogoD,095,096)
			
			If Empty(cChaveCont)
				oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
				oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
			Endif
			
			If  !Empty(cCodAutDPEC)
				oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
				oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
			Endif
			
			
			If nFolha == 1
				If !Empty(cCodAutDPEC)
					nFontSize := 28
					oDanfe:Code128C(188,370,cCodAutDPEC, nFontSize )
				Endif
			Endif
			
			// inicio do segundo codigo de barras ref. a transmissao CONTIGENCIA OFF LINE
			If !Empty(cChaveCont) .And. Empty(cCodAutDPEC) .And. !(Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900)
				If nFolha == 1
					If !Empty(cChaveCont)
						nFontSize := 28
						oDanfe:Code128C(188,370,cChaveCont, nFontSize )
					EndIf
				Else
					If !Empty(cChaveCont)
						nFontSize := 28
						oDanfe:Code128C(188,370,cChaveCont, nFontSize )
					EndIf
				EndIf
			EndIf
			
			oDanfe:Box(192,000,215,603)
			oDanfe:Box(192,000,215,300)
			oDanfe:Say(201,002,"NATUREZA DA OPERAÇÃO",oFont08N )
			oDanfe:Say(211,002,cTes,oFont08 )

//			If(((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1")
//				oDanfe:Say(201,302,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N )
//			Endif

//			oDanfe:Say(211,302,IIF(!Empty(cCodAutDPEC),cCodAutDPEC+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),IIF(!Empty(cCodAutSef) .And. ((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"23") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1",cCodAutSef+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"))),oFont08 )
							
			nFolha++
			
			oDanfe:Box(217,000,240,603)
			oDanfe:Box(217,000,240,200)
			oDanfe:Box(217,200,240,400)
			oDanfe:Box(217,400,240,603)
			oDanfe:Say(225,002,"INSCRIÇÃO ESTADUAL",oFont08N )
			oDanfe:Say(233,002,SM0->M0_INSC ,oFont08 )
			oDanfe:Say(225,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N )
			oDanfe:Say(233,205,'',oFont08 )
			oDanfe:Say(225,405,"CNPJ",oFont08N )
			oDanfe:Say(233,405,TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99"),oFont08 )
			
			nLenMensagens:= Len(aMensagem)
			
			nColLim		:=	Iif(nMensagem <= nLenMensagens,680,865) 
			oDanfe:Say(245,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N )
			oDanfe:Box(248,000,nColLim,603)
			
			nAuxH := 0
			oDanfe:Box(248,000,nColLim,052)
			oDanfe:Say(255,002,"COD. PROD",oFont08N )

			oDanfe:Box(248,052,nColLim,155)
			oDanfe:Say(255,054,"DESCRIÇÃO DO PROD./SERV.",oFont08N )

			oDanfe:Box(248,155,nColLim,190)
			oDanfe:Say(255,157,"NCM/SH",oFont08N )

			oDanfe:Box(248,190,nColLim,210)
			oDanfe:Say(255,192,"CST",oFont08N )

			oDanfe:Box(248,210,nColLim,230)
			oDanfe:Say(255,212,"CFOP",oFont08N )

			oDanfe:Box(248,230,nColLim,250)
			oDanfe:Say(255,232,"UN",oFont08N )

			oDanfe:Box(248,250,nColLim,289)
			oDanfe:Say(255,252,"QUANT.",oFont08N )

			oDanfe:Box(248,289,nColLim,346)
			oDanfe:Say(255,292,"V.UNITARIO",oFont08N )

			oDanfe:Box(248,346,nColLim,400)
			oDanfe:Say(255,348,"V.TOTAL",oFont08N )

			oDanfe:Box(248,400,nColLim,465)
			oDanfe:Say(255,402,"BC.ICMS",oFont08N )

			oDanfe:Box(248,465,nColLim,515)
			oDanfe:Say(255,467,"V.ICMS",oFont08N )

			oDanfe:Box(248,515,nColLim,550)
			oDanfe:Say(255,517,"V.IPI",oFont08N )

			oDanfe:Box(248,550,nColLim,578)
			oDanfe:Say(255,552,"A.ICMS",oFont08N )

			oDanfe:Box(248,578,nColLim,603)
			oDanfe:Say(255,582,"A.IPI",oFont08N )
			
			// FINALIZANDO INFORMAÇÕES PARA O CABEÇALHO DA PAGINA 2
			nL	:= 1
			
			//Verifico se ainda existem Dados Adicionais a serem impressos
			IF nMensagem <= nLenMensagens
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Dados Adicionais                                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oDanfe:Say(719+nLinhavers,000,"DADOS ADICIONAIS",oFont08N )
				oDanfe:Box(721+nLinhavers,000,865+nLinhavers,351)
				oDanfe:Say(729+nLinhavers,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N )				
				
				nLin:= 741
				nLenMensagens:= Len(aMensagem)
				--nMensagem
				For nX := 1 To Min(nLenMensagens - nMensagem, MAXMSG)
					oDanfe:Say(nLin,002,aMensagem[nMensagem+nX],oFont08 )
					nLin:= nLin+10
				Next nX
				nMensagem := nMensagem+nX
				
				oDanfe:Box(721+nLinhavers,350,865+nLinhavers,603)
				oDanfe:Say(729+nLinhavers,352,"RESERVADO AO FISCO",oFont08N )
				
				// Seta o máximo de itens para o MAXITEMP2
				nMaxItemP2 := MAXITEMP2
			Else
				// Seta o máximo de itens para o MAXITEMP2F
				nMaxItemP2 := MAXITEMP2F
			EndIF
		Endif		
	Endif

	// INICIANDO INFORMAÇÕES PARA O CABEÇALHO DA PAGINA 3 E DIANTE	
	If	nL > Iif( (nfolha-1)%2==0 ,MAXITEMP3,nMaxItemP2)  
		//oDanfe:Say( 660,250,"CÓPIA DA DANFE ENVIADA POR EMAIL",oFont12,,CLR_HRED,290 )
		oDanfe:EndPage()
		oDanfe:StartPage()
		nLenMensagens:= Len(aMensagem)							
		nColLim		:=	Iif(!(nfolha-1)%2==0 .And. MV_PAR05==1,435,Iif(nMensagem <= nLenMensagens,680,865))
		lFimpar		:=  ((nfolha-1)%2==0)
		nLinha    	:=	265 //181      
		If nfolha >= 3
			nLinhavers := 0
		EndIf
		oDanfe:Box(095,000,190,250)
		oDanfe:Say(106,098, "Identificação do emitente",oFont12N )
		nLinCalc	:=	128 //023
		cStrAux		:=	AllTrim(SM0->M0_NOMECOM)
		nForTo		:=	Len(cStrAux)/25
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*25)+1),25), oFont12N  )
			nLinCalc+=10
		Next nX
		
		cStrAux		:=	AllTrim(SM0->M0_ENDCOB)
		nForTo		:=	Len(cStrAux)/32
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
			nLinCalc+=10
		Next nX
		
		cStrAux		:=	"Complemento: "+Alltrim(SM0->M0_COMPCOB)
		nForTo		:=	Len(cStrAux)/32
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
			nLinCalc+=10
		Next nX
		
		cStrAux		:=	AllTrim(SM0->M0_BAIRCOB)
		
		cStrAux		+=	" Cep: "+TransForm(SM0->M0_CEPCOB,"@r 99999-999")

		nForTo		:=	Len(cStrAux)/32
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
			nLinCalc+=10
		Next nX                        
		
		oDanfe:Say(nLinCalc,098, SM0->M0_CIDCOB+"/"+SM0->M0_ESTCOB,oFont08N )
		
		nLinCalc+=10
		oDanfe:Say(nLinCalc,098, "Fone: "+SM0->M0_TEL,oFont08N )
		
		oDanfe:Box(095,248,190,351)
		oDanfe:Say(108,255, "DANFE",oFont18N )
		oDanfe:Say(118,255, "DOCUMENTO AUXILIAR DA",oFont07 )
		oDanfe:Say(128,255, "NOTA FISCAL ELETRÔNICA",oFont07 )
		oDanfe:Say(138,255, "0-ENTRADA",oFont08 )
		oDanfe:Say(148,255, "1-SAÍDA"  ,oFont08 )
		oDanfe:Box(131,305,141,315)
		oDanfe:Say(138,307, "1",oFont08N )
		oDanfe:Say(163,255,"N. "+StrZero(Val(TRB->F2_DOC),9),oFont10N )
		oDanfe:Say(173,255,"SÉRIE "+TRB->F2_SERIE,oFont10N )
		oDanfe:Say(183,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N )
		
		//oDanfe:Box(000,350,095,603)
		oDanfe:Box(095,351,128,603)
		oDanfe:Box(128,351,158,603)
		oDanfe:Box(158,351,190,603)
		oDanfe:Say(148,355,TransForm(TRB->F2_CHVNFE,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N )
		
		oDanfe:Say(138,355,"CHAVE DE ACESSO DA NF-E",oFont12N )
		nFontSize := 28
		oDanfe:Code128C(125,370,TRB->F2_CHVNFE, nFontSize )
		
		oDanfe:SayBitmap(095,000,cLogoD,095,096)
		
		If Empty(cChaveCont)
			oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
			oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
		Endif
		
		If  !Empty(cCodAutDPEC)
			oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
			oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
		Endif
		
		
		If nFolha == 1
			If !Empty(cCodAutDPEC)
				nFontSize := 28
				oDanfe:Code128C(188,370,cCodAutDPEC, nFontSize )
			Endif
		Endif
		
		// inicio do segundo codigo de barras ref. a transmissao CONTIGENCIA OFF LINE
		If !Empty(cChaveCont) .And. Empty(cCodAutDPEC) .And. !(Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900)
			If nFolha == 1
				If !Empty(cChaveCont)
					nFontSize := 28
					oDanfe:Code128C(188,370,cChaveCont, nFontSize )
				EndIf
			Else
				If !Empty(cChaveCont)
					nFontSize := 28
					oDanfe:Code128C(188,370,cChaveCont, nFontSize )
				EndIf
			EndIf
		EndIf
		
		oDanfe:Box(192,000,215,603)
		oDanfe:Box(192,000,215,300)
		oDanfe:Say(201,002,"NATUREZA DA OPERAÇÃO",oFont08N )
		oDanfe:Say(211,002, cTes,oFont08 )

//		oDanfe:Say(201,302,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N )
//		oDanfe:Say(211,302,IIF(!Empty(cCodAutDPEC),cCodAutDPEC+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),IIF(!Empty(cCodAutSef) .And. ((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"23") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1",cCodAutSef+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"))),oFont08 )
		nFolha++
		
		oDanfe:Box(217,000,240,603)
		oDanfe:Box(217,000,240,200)
		oDanfe:Box(217,200,240,400)
		oDanfe:Box(217,400,240,603)
		oDanfe:Say(225,002,"INSCRIÇÃO ESTADUAL",oFont08N )
		oDanfe:Say(233,002,SM0->M0_INSC,oFont08 )
		oDanfe:Say(225,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N )
		oDanfe:Say(233,205,'',oFont08 )
		oDanfe:Say(225,405,"CNPJ",oFont08N )
		oDanfe:Say(233,405,TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99"),oFont08 )
		
		oDanfe:Say(244,002,"DADOS DO PRODUTO / SERVIÇO",oFont08N )
		oDanfe:Box(246,000,nColLim+10,603)
		
		nAuxH := 0
		oDanfe:Box(243,000,nColLim,052)
		oDanfe:Say(255,002,"COD. PROD",oFont08N )

		oDanfe:Box(243,052,nColLim,155)
		oDanfe:Say(255,054,"DESCRIÇÃO DO PROD./SERV.",oFont08N )

		oDanfe:Box(243,155,nColLim,190)
		oDanfe:Say(255,157,"NCM/SH",oFont08N )

		oDanfe:Box(243,190,nColLim,210)
		oDanfe:Say(255,192,"CST",oFont08N )

		oDanfe:Box(243,210,nColLim,230)
		oDanfe:Say(255,212,"CFOP",oFont08N )

		oDanfe:Box(243,230,nColLim,250)
		oDanfe:Say(255,232,"UN",oFont08N )

		oDanfe:Box(243,250,nColLim,289)
		oDanfe:Say(255,252,"QUANT.",oFont08N )

		oDanfe:Box(243,289,nColLim,346)
		oDanfe:Say(255,292,"V.UNITARIO",oFont08N )

		oDanfe:Box(243,346,nColLim,400)
		oDanfe:Say(255,348,"V.TOTAL",oFont08N )

		oDanfe:Box(243,400,nColLim,465)
		oDanfe:Say(255,402,"BC.ICMS",oFont08N )

		oDanfe:Box(243,465,nColLim,515)
		oDanfe:Say(255,467,"V.ICMS",oFont08N )

		oDanfe:Box(243,515,nColLim,550)
		oDanfe:Say(255,517,"V.IPI",oFont08N )

		oDanfe:Box(243,550,nColLim,578)
		oDanfe:Say(255,552,"A.ICMS",oFont08N )

		oDanfe:Box(243,578,nColLim,603)
		oDanfe:Say(255,582,"A.IPI",oFont08N )
		
		//Verifico se ainda existem Dados Adicionais a serem impressos
		nLenMensagens:= Len(aMensagem)			
		IF nMensagem <= nLenMensagens
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Dados Adicionais                                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oDanfe:Say(719,000,"DADOS ADICIONAIS",oFont08N )
			oDanfe:Box(721,000,865,351)
			oDanfe:Say(729,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N )				
			
			nLin:= 741
			nLenMensagens:= Len(aMensagem)
			--nMensagem
			For nX := 1 To Min(nLenMensagens - nMensagem, MAXMSG)				
				oDanfe:Say(nLin,002,aMensagem[nMensagem+nX],oFont08 )
				nLin:= nLin+10
			Next nX
			nMensagem := nMensagem+nX
			
			oDanfe:Box(721+nLinhavers,350,865+nLinhavers,603)
			oDanfe:Say(729+nLinhavers,352,"RESERVADO AO FISCO",oFont08N )
			
			// Seta o máximo de itens para o MAXITEMP2
			nMaxItemP2 := MAXITEMP2
		Else
			// Seta o máximo de itens para o MAXITEMP2F
			nMaxItemP2 := MAXITEMP2F
		EndIF	
		If (!(nfolha-1)%2==0) 
			If nY+69<nLenItens
				oDanfe:Say(875,497,"CONTINUA NO VERSO")
			Endif
		End
		
		nL := 1
	EndIf
	
	nAuxH := 0
	
	If aAux[1][1][nY] == "-"
		//oDanfe:Say(nLinha, nAuxH, Replicate("- ", 150), oFont08 )
	Else
		oDanfe:Say(nLinha,002,aAux[1][1][nY], oFont08  )

		oDanfe:Say(nLinha,054,aAux[1][2][nY],oFont08 ) // DESCRICAO DO PRODUTO

		oDanfe:Say(nLinha,157,aAux[1][3][nY],oFont08 ) // NCM

		oDanfe:Say(nLinha,192,aAux[1][4][nY],oFont08 ) // CST

		oDanfe:Say(nLinha,212,aAux[1][5][nY],oFont08 ) // CFOP

		oDanfe:Say(nLinha,232,aAux[1][6][nY],oFont08 ) // UN

		oDanfe:Say(nLinha,265,If(!empty(aAux[1][1][nY]),Transform(aAux[1][7][nY],"@E 999,999.99"),''),oFont08 ,45, 10, , 1,  ) // QUANT align

		oDanfe:Say(nLinha,315,If(!empty(aAux[1][1][nY]),Transform(aAux[1][8][nY],"@E 99,999.9999"),''),oFont08 ,52, 10, , 1,  ) // V UNITARIO

		oDanfe:Say(nLinha,365,If(!empty(aAux[1][1][nY]),Transform(aAux[1][9][nY],"@E 9,999,999.99"),''),oFont08 ,50, 10, , 1,  ) // V. TOTAL

		oDanfe:Say(nLinha,425,If(!empty(aAux[1][1][nY]),Transform(aAux[1][10][nY],"@E 9,999,999.99"),''),oFont08 ,50, 10, , 1,  ) // BC. ICMS

		oDanfe:Say(nLinha,485,If(!empty(aAux[1][1][nY]),Transform(aAux[1][11][nY],"@E 99,999.99"),''),oFont08 ,45, 10, , 1,  ) // V. ICMS

		oDanfe:Say(nLinha,525,If(!empty(aAux[1][1][nY]),Transform(aAux[1][12][nY],"@E 9,999.99"),''),oFont08 ,45, 10, , 1,  ) // V.IPI

		oDanfe:Say(nLinha,555,If(!empty(aAux[1][1][nY]),Transform(aAux[1][13][nY],"@E 99.99 %"),''),oFont08 ,30, 10, , 1,  ) // A.ICMS

		oDanfe:Say(nLinha,580,If(!empty(aAux[1][1][nY]),Transform(aAux[1][14][nY],"@E 99.99 %"),''),oFont08 ,36, 10, , 1,  ) // A.IPI   
		
		If Empty(aAux[1][1][nY])
			nLinha := nLinha + 4
		EndIf
	EndIf
	
	nLinha :=nLinha + 7
Next nY
/*
nLenMensagens := Len(aMensagem)
While nMensagem <= nLenMensagens
	DanfeCpl(oDanfe,aItens,aMensagem,@nItem,@nMensagem,oNFe,oIdent,oEmitente,@nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab, cLogoD)
EndDo
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a Impressão                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oDanfe:Say( 660,250,"CÓPIA DA DANFE ENVIADA POR EMAIL",oFont12,,CLR_HRED,290 )


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Microsiga           º Data ³  05/18/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DanfeCpl(oDanfe,aItens,aMensagem,nItem,nMensagem,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab, cLogoD) 

Local nX            := 0
Local nLinha        := 0
Local nLenMensagens := Len(aMensagem)
Local nItemOld	    := nItem
Local nMensagemOld  := nMensagem
Local nForMensagens := 0
Local lMensagens    := .F.
Local cLogo      	:= FisxLogo("1")
Local cChaveCont 	:= ""
Local lConverte     := GetNewPar("MV_CONVERT",.F.)
Local lMv_Logod := If(GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F.   )

If (nLenMensagens - (nMensagemOld - 1)) > 0
	lMensagens := .T.
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ------------------------ÄÄÄÄ¿
//³Dados Adicionais segunda parte em diante³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄ------------------------ÄÄÄÄÙ
If lMensagens
	nLenMensagens := Len(aMensagem)
	nForMensagens := Min(nLenMensagens, MAXITEMP2 + (nMensagemOld - 1) - (nItem - nItemOld))
	oDanfe:EndPage()
	oDanfe:StartPage()
	nLinha    := 275 //180
	oDanfe:Say(255,000,"DADOS ADICIONAIS",oFont08N )
	oDanfe:Box(267,000,865,351)
	oDanfe:Say(265,002,"INFORMAÇÕES COMPLEMENTARES",oFont08N )
	oDanfe:Box(267,350,865,603)
	oDanfe:Say(265,352,"RESERVADO AO FISCO",oFont08N )
	
	oDanfe:Box(095,000,190,250)
	oDanfe:Say(105,098, "Identificação do emitente",oFont12N )
	nLinCalc	:=	076
	cStrAux		:=	AllTrim(NoChar(oEmitente:_xNome:Text,lConverte))
	nForTo		:=	Len(cStrAux)/25
	nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
	For nX := 1 To nForTo
		oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*25)+1),25), oFont12N  )
		nLinCalc+=10
	Next nX
	
	cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xLgr:Text,lConverte))+", "+AllTrim(oEmitente:_EnderEmit:_Nro:Text)
	nForTo		:=	Len(cStrAux)/32
	nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
	For nX := 1 To nForTo
		oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
		nLinCalc+=10
	Next nX
	
	If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
		cStrAux		:=	"Complemento: "+AllTrim(NoChar(oEmitente:_EnderEmit:_xCpl:TEXT,lConverte))
		nForTo		:=	Len(cStrAux)/32
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
			nLinCalc+=10
		Next nX
		
		cStrAux		:=	AllTrim(NoChar(oEmitente:_EnderEmit:_xBairro:Text,lConverte))
		If Type("oEmitente:_EnderEmit:_Cep")<>"U"
			cStrAux		+=	" Cep:"+TransForm(oEmitente:_EnderEmit:_Cep:Text,"@r 99999-999")
		EndIf
		nForTo		:=	Len(cStrAux)/32
		nForTo		+=	Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
		For nX := 1 To nForTo
			oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N )
			nLinCalc+=10
		Next nX
		oDanfe:Say(nLinCalc,098, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N )
		nLinCalc+=10
		oDanfe:Say(nLinCalc,098, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N )
	Else
		oDanfe:Say(nLinCalc,098, oEmitente:_EnderEmit:_xBairro:Text+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont08N )
		nLinCalc+=10
		oDanfe:Say(nLinCalc,098, oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont08N )
		nLinCalc+=10
		oDanfe:Say(nLinCalc,098, "Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont08N )
	EndIf
	
	oDanfe:Box(095,248,148,351)
	oDanfe:Say(108,255, "DANFE",oFont18N )
	oDanfe:Say(118,255, "DOCUMENTO AUXILIAR DA",oFont07 )
	oDanfe:Say(128,255, "NOTA FISCAL ELETRÔNICA",oFont07 )
	oDanfe:Say(138,255, "0-ENTRADA",oFont08 )
	oDanfe:Say(148,255, "1-SAÍDA"  ,oFont08 )
	oDanfe:Box(132,305,142,315)
	oDanfe:Say(140,307, oIdent:_TpNf:Text,oFont08N )
	oDanfe:Say(157,255,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N )
	oDanfe:Say(167,255,"SÉRIE "+oIdent:_Serie:Text,oFont10N )
	oDanfe:Say(177,255,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N )
	
	oDanfe:Box(095,350,190,603)
	oDanfe:Box(095,350,135,603)
	oDanfe:Box(135,350,157,603)
	oDanfe:Box(158,350,190,603)
	oDanfe:Say(153,355,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N )
	
	oDanfe:Say(143,355,"CHAVE DE ACESSO DA NF-E",oFont12N )
	nFontSize := 28
	oDanfe:Code128C(036,370,SubStr(oNF:_InfNfe:_ID:Text,4), nFontSize )
	/*/
	If lMv_Logod
		oDanfe:SayBitmap(000,000,cLogoD,095,096)
	Else
		oDanfe:SayBitmap(000,000,cLogo,095,096)
	EndIf
	/*/
	If Empty(cChaveCont)
		oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
		oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
	Endif
	
	If  !Empty(cCodAutDPEC)
		oDanfe:Say(170,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12 )
		oDanfe:Say(180,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12 )
	Endif
	
	
	If nFolha == 1
		If !Empty(cCodAutDPEC)
			nFontSize := 28
			oDanfe:Code128C(188,370,cCodAutDPEC, nFontSize )
		Endif
	Endif
	
	// inicio do segundo codigo de barras ref. a transmissao CONTIGENCIA OFF LINE
	If !Empty(cChaveCont) .And. Empty(cCodAutDPEC) .And. !(Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900)
		If nFolha == 1
			If !Empty(cChaveCont)
				nFontSize := 28
				oDanfe:Code128C(188,370,cChaveCont, nFontSize )
			EndIf
		Else
			If !Empty(cChaveCont)
				nFontSize := 28
				oDanfe:Code128C(188,370,cChaveCont, nFontSize )
			EndIf
		EndIf
	EndIf
	
	oDanfe:Box(195,000,218,603)
	oDanfe:Box(195,000,218,300)
	oDanfe:Say(204,002,"NATUREZA DA OPERAÇÃO",oFont08N )
	oDanfe:Say(214,002,oIdent:_NATOP:TEXT,oFont08 )
	If(!Empty(cCodAutDPEC))
		oDanfe:Say(204,300,"NÚMERO DE REGISTRO DPEC",oFont08N )
	Endif
	If(((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1")
		oDanfe:Say(204,302,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N )
	Endif
	If((oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25")
		oDanfe:Say(204,300,"DADOS DA NF-E",oFont08N )
	Endif
	oDanfe:Say(214,302,IIF(!Empty(cCodAutDPEC),cCodAutDPEC+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),IIF(!Empty(cCodAutSef) .And. ((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"23") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1",cCodAutSef+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999"))),oFont08 )
	nFolha++
	
	oDanfe:Box(179,000,206,603)
	oDanfe:Box(179,000,206,200)
	oDanfe:Box(179,200,206,400)
	oDanfe:Box(179,400,206,603)
	oDanfe:Say(188,002,"INSCRIÇÃO ESTADUAL",oFont08N )
	oDanfe:Say(238,002,IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,""),oFont08 )
	oDanfe:Say(188,205,"INSC.ESTADUAL DO SUBST.TRIB.",oFont08N )
	oDanfe:Say(238,205,IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,""),oFont08 )
	oDanfe:Say(188,405,"CNPJ",oFont08N )
	oDanfe:Say(238,405,TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99")),oFont08 )
	
	For nX := nMensagem To nForMensagens
		oDanfe:Say(nlinha,002,aMensagem[nX],oFont08 )
		nMensagem++
		nLinha:= nLinha+ 10
	Next nX
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalizacao da pagina do objeto grafico                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:EndPage()  
oDanfe:preview()

Return(.T.)       
                                                                                    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Microsiga           º Data ³  05/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RegraBco(cnota)

Local aArea		:=	GetArea()
Local cQuery
Local aCcusto	:=	{}
Local cRetorno	:=	""

cQuery := "SELECT E1_NATUREZ FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_PREFIXO='"+xFilial("SF2")+MV_PAR03+"' AND E1_NUM='"+Strzero(cnota,9)+"'"
cQuery += " AND E1_CLIENTE='"+SF2->F2_CLIENTE+"' AND E1_LOJA='"+SF2->F2_LOJA+"'"
cQuery += " GROUP BY E1_NATUREZ"    

If Select("TRB2") > 0
	dbSelectArea("TRB2")
	dbCloseArea()
EndIf
  
MemoWrite("TTRDANFE2.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB2',.F.,.T.)   

DbSelectArea("TRB2")

While !EOF()                     
	If !empty(TRB2->E1_NATUREZ)
		Aadd(aCcusto,TRB2->E1_NATUREZ)
	EndIf
	DbSkip()
EndDo

If len(aCcusto) > 0
	For nX := 1 to len(aCcusto)
		//If !empty(Posicione("ZZL",1,xFilial("ZZL")+aCcusto[nX],"ZZL_BANCO")) 
		DbSelectArea("ZZL")
		DbSetORder(1)
		If DbSeek(xFilial("ZZL")+aCcusto[nX])
			//cRetorno :=	Posicione("ZZL",1,xFilial("ZZL")+aCcusto[nX],"ZZL_BANCO")
			cRetorno := ZZL->ZZL_BANCO+ZZL->ZZL_AGENCI+ZZL->ZZL_CONTA+ZZL->ZZL_TIPO
		EndIf
		//EndIf
	Next nX
EndIf
		        
RestArea(aArea)
		
Return(cRetorno)                                                  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Alexandre Venancio  º Data ³  05/30/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerando o bordero para o boleto a ser enviado ao cliente.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraBord(cBanco,cAg,cC,cSC)

Local aArea		:= GetArea()
Local nNumBord 	:= __Soma1(GETMV("MV_NUMBORR"))
Local lRet		:= .T.   
Local cMsg		:= ""
            
DbSelectArea("SEE")
DbSetOrder(1)
If Dbseek(xFilial("SEE")+cBanco+cAg+cC+cSC)

	nNNumAtual :=(VAL(SEE->EE_FAXATU)+ 1)
	nNumBco := cBanco 
   
	IF (VAL(SEE->EE_FAXATU)+1000) > VAL(SEE->EE_FAXFIM)
		cMsg := "Existe apenas "+Alltrim(STR(VAL(SEE->EE_FAXFIM) - VAL(SEE->EE_FAXATU)))+" número(s) de Nosso Número para o Banco: "+cBanco
		lRet := .F. 	                           
	EndIf
 	
 	IF nNNumAtual > VAL(SEE->EE_FAXFIM)
    	cMsg += " O nosso número para o banco "+cBanco+" se esgotou, o processo não continuará." 
    	lRet := .F.
  	EndIf

	// Calculando o digito verificador do Nosso Número
	
	If cBanco != "033"
		nNossoNum := (DigVerfNSNum(Alltrim(cBanco), Alltrim(SEE->EE_AGENCIA), Alltrim(SEE->EE_CONTA), Alltrim(SEE->EE_SUBCTA), + Alltrim(STRZERO(nNNumAtual,11))))
	Else
		nNossoNum := Strzero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
	EndIf
	nCalcNrBanc  := Alltrim(nNossoNum)
	cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
	cNossoNum 	:= Alltrim(nNossoNum) + Alltrim(str(cDVNrBanc))

	DbSelectArea("SE1")
	DbSetOrder(1)
	IF dbSeek(xFilial("SE1")+Alltrim(SF2->F2_FILIAL+SF2->F2_SERIE)+SF2->F2_DOC)
		RecLock("SE1",.F.)
	    SE1->E1_PORTADOR := cBanco
	    SE1->E1_AGEDEP   := SEE->EE_AGENCIA
	    SE1->E1_CONTA    := SEE->EE_CONTA
	    SE1->E1_NUMBOR   := nNumBord
	    SE1->E1_DATABOR  := DDataBase
	    SE1->E1_MOVIMEN  := DDataBase
	    SE1->E1_SITUACA  := Iif(cBanco == "237","3","5") 
	    SE1->E1_NUMBCO   := cNossoNum   
	    SE1->(MsUnlock())
	    //grava dados do bordero no arquivo Titulos enviados ao Banco
	    DbSelectArea("SEA")
	    DbSetOrder(1)
	    RecLock("SEA",.T.)
	   	SEA->EA_NUMBOR  := nNumBord
	    SEA->EA_PREFIXO := SE1->E1_PREFIXO
	    SEA->EA_NUM     := SE1->E1_NUM
	    SEA->EA_PARCELA := SE1->E1_PARCELA
	    SEA->EA_TIPO    := SE1->E1_TIPO      
	    SEA->EA_PORTADOR:= cBanco
	    SEA->EA_AGEDEP  := SEE->EE_AGENCIA
	    SEA->EA_NUMCON  := SEE->EE_CONTA
	    SEA->EA_DATABOR := DDataBase
	    SEA->EA_SITUACA := Iif(cBanco=="237","3","1")  
	    SEA->EA_CART    := "R"        
		SEA->EA_FORNECE := SPACE(06)
	    SEA->EA_LOJA    := SPACE(02)
	    SEA->EA_TRANSF  := "S"
	    SEA->(MsUnlock())
	EndIf         
	
		nNumBord := __Soma1(nNumBord)
		Putmv("MV_NUMBORR",nNumBord)
	DbSelectArea("SEE")
	DbSetOrder(1) 
    IF DbSeek(xFilial("SEE")+cBanco+cAg+cC+cSC)
    	RecLock("SEE",.F.)
	    SEE->EE_FAXATU := Strzero((Val(SEE->EE_FAXATU)+1),len(Alltrim(SEE->EE_FAXATU)))
	    SEE->(MsUnlock())  
    EndIF    
EndIF
	
RestArea(aArea)

Return(lRet)     

Static Function DigVerfNSNum(cBanco, cAgencia, cConta, cCarteira, cNosNum) 
Local _Ret:=""   
Do Case
	Case cBanco == "237" // Bradesco
	    _Ret := cNosNum + CalcDigNNum(11,cCarteira+cNosNum,{7,6,5,4,3,2},"P",.T.,.F.)
	Case cBanco == "001" //Banco Brasil
		_Ret := cNosNum + CalcDigNNum(11,cNosNum,{2,3,4,5,6,7,8,9},"X",.F.,.F.)
	Case cBanco == "341"// Banco Itaú
		_Ret := cNosNum + CalcDigNNum(10,cAgencia+substr(cConta,1,5)+cNosNum,{1,2},"0",.T.,.T.)
EndCase   
  
_Ret := Alltrim(_Ret)

Return(_Ret)

Static Function CalcDigNNum(nDiv,nNumero,aPeso,cLetra,lSubr,lSomaDec) 
/*Função CalcDigNNum
Paramêtros
nDiv : modulo de calculo da função Modulo 10 ou 11
nNumero : Número para calculo da função
aPeso : Array contendo sequencia e base de calculo  
cLetra : na composição do digito for de 2 digitos substitui por essa letra  
lSubr : Utiliza o metodo de substração (.t.) ou o MOD (.f.) somente.
lSomaDec : Soma sequência decimal. Ex 8 x 2 = 16 soma esse valor(.F.) ou soma 7 (1 + 6)(.T.)
*/
	LOCAL nCnt   := 0,;
	cDigito  := 0,;
	nSoma  := 0,;
	nBase  := 0,;
	nVlrSoma := 0

	nBase := Len(aPeso)+1

	FOR nCnt := Len(nNumero) TO 1 STEP -1
		nBase := IF(--nBase = 0,Len(aPeso),nBase)  
		nVlrSoma := Val(SUBS(nNumero,nCnt,01)) * aPeso[ nBase ]  
		nSoma += IIF (nVlrSoma >=10 .AND. lSomaDec,(Val(Subs(Alltrim(STR(nVlrSoma)),1,1)) + Val(Subs(Alltrim(STR(nVlrSoma)),2,1))), nVlrSoma )
	NEXT
	cDigito := IIF(lSubr, nDiv - (nSoma % nDiv), (nSoma % nDiv))

	DO CASE
		CASE cDigito = 11 // Somente entrará nessa condição se lSubr for igual a .t. e a variavel nDiv =11
			cDigito := "0"
		CASE cDigito = 10 .AND. !Empty(cLetra)
			cDigito := cLetra
		OTHERWISE
			cDigito := STR( cDigito, 1, 0 )
	ENDCASE
RETURN(cDigito) 
Static Function Modulo11Nn(cData)
LOCAL L, D, P,R := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

R := mod(D,11)
If (R == 10)
	D := 1
ElseIf (R == 0 .or. R == 1)
    D := 0
Else
    D := (11 - R)
End              

Return(D)                                                                                                               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRDANFE  ºAutor  ³Microsiga           º Data ³  06/25/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTRREIMP(cNota,cSerie)
                                                            
Local aArea	:=	GetArea()
Local oDlg1,oGrp1,oSay1,oSay2,oSay3,oGet1,oGet2,oGet3,oBtn1 
Local nOpc	:=	0  
Local npar01 := If(!empty(cNota),cNota,space(9))
Local npar02 := If(!empty(cNota),cNota,space(9))
Local npar03 := If(!empty(cSerie),cSerie,space(3))
Local lSegue := .T.

Private IMP_PDF	:=	6 

If empty(npar01) .And. empty(npar03)
	oDlg1      := MSDialog():New( 091,232,322,494,"Reimpressão de Notas",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 004,004,088,120,"Parâmetros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oSay1      := TSay():New( 020,016,{||"Nota De:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
		oGet1      := TGet():New( 020,048,{|u|If(Pcount()>0,npar01:=u,npar01)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF2","",,)
	
		oSay2      := TSay():New( 044,016,{||"Nota Até:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet2      := TGet():New( 044,048,{|u|If(Pcount()>0,npar02:=u,npar02)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF2","",,)
	
		oSay3      := TSay():New( 068,016,{||"Série"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oGet3      := TGet():New( 068,048,{|u|If(Pcount()>0,npar03:=u,npar03)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
		oBtn1      := TButton():New( 092,044,"Reimprimir",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.) 
Else
	nOpc := 1 
EndIf	

If nOpc == 1                                  
	If val(npar02) < val(npar01)
		MsgAlert("Dados inválidos","TTRREIMP")
		lSegue := .F.
	EndIf
	If empty(npar03)
		MsgAlert("Série não informada","TTRREIMP")
		lSegue := .F.
	EndIf
 	
 	If lSegue
		MV_PAR01 := Strzero(val(npar01),9)
		MV_PAR02 := Strzero(val(npar02),9)
		MV_PAR03 := npar03    
		U_TTRDANFE(.T.)
	EndIf	
EndIf
                         
RestArea(aArea)

Return


// Verifica se o arquivo esta com tamanho compativel - maior que 100 KB
Static Function ChkArq(cArquivo)
      
Local nHdl := FOpen(cArquivo , FO_READ + FO_SHARED )
Local nTamArq := 0
Local nTamMin := 102400 // 100KB tamanho minimo dos pdfs - 100*1024
Local lRet := .T.

If nHdl == -1
	fclose(nHdl)
	lRet := .F.
	Return lRet
EndIf	
   
nTamArq := FSeek(nHdl, 0, 2)

If nTamArq < nTamMin
	lRet := .F.
EndIf
           
fclose(nHdl)

Return lRet