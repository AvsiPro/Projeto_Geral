#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"    
#INCLUDE "TopConn.ch"
#INCLUDE "FWPrintSetup.ch"
#DEFINE IMP_PDF 6  
#DEFINE IMP_SPOOL 2
#DEFINE DMPAPER_A4         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRBOLETO ºAutor  ³Alexandre Venancio  º Data ³  05/16/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao de PDF do boleto para envio automatico ao cliente  º±±
±±º          ³na geracao da Danfe.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTRBOLETO(nNotF)

LOCAL oPrint
LOCAL nX := 0
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    								  ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     						  ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          	   ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Após Vencimento cobrar: 2% de Multa + Mora por Dia de Atraso de R$ "						      	,;   //[1]Mora Diaria
					   "PROTESTAR APÓS 5 DIAS DO VENCIMENTO.",;
					   "SR CAIXA NÃO RECEBER APÓS 15 DIAS (CORRIDOS) DO VENCIMENTO" ,;
					   "O PAGAMENTO DESTE BOLETO NÃO QUITA DÉBITOS ANTERIORES."}   //[2]Sujeito a Protesto

LOCAL nI		:= 1
LOCAL aCB_RN_NN	:= {}
LOCAL nVlrAbat	:= 0
Local aBCOLogo  := {}
Local cDVNrBanc
Local cNrBancario
Local cAgeNN
Local cCtaNN
Local cCarNN
Local cNumNN
Local cMsg     := "Referente Nota Fiscal Eletronica Nr: "
Local cNFEle   := ""    
Local cRet     := Space(30)
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T. 
Local cRetorno	:=	""

Private aTitulos	:=	CallRegs(nNotF)

oPrint := FWMSPrinter():New("Boleto"+Strzero(nNotF,9)+".rel", IMP_PDF, lAdjustToLegacy, "\SPOOL\", lDisableSetup,,,,.T.,,,.F.)

oPrint:SetPortrait() 	// ou SetLandscape()
oPrint:StartPage()   	// Inicia uma nova página

oPrint:SetMargin(5,10,5,10) // nEsquerda, nSuperior, nDireita, nInferior 

oPrint:cPathPDF := "\spool\" // Caso seja utilizada impressão em IMP_PDF

For nI:=1 To Len(aTitulos) 
    
	If aTitulos[nI,01]
		cPrefixo := aTitulos[nI,2]
		cNum     := aTitulos[nI,3]
		cParcela := aTitulos[nI,4]
		cTipo    := aTitulos[nI,5]
		cCLiente := aTitulos[nI,7]
		cLoja    := aTitulos[nI,8]
		
		//Posiciona o SA1 (Cliente)
		DbSelectArea("SA1")
		DbSetOrder(1) 
		DbSeek(xFilial("SA1") + cCliente + cLoja )
			    
		DbSelectArea("SE1")
		DbSetOrder(1) 
		If !DbSeek(xFilial("SE1") + cPrefixo + cNum + cParcela + cTipo + cCliente + cLoja)
			Alert("O Titulo: " + cPrefixo + " " + cNum + " " + cParcela + " nao existe!")
			Loop
		Endif
		
		DbSelectArea("SA6")
		DbSetorder(1)
		DbSeek(xFilial("SA6")+If(SM0->M0_CODIGO=="01","0330643  130018031      I31","03300643 130018495      I95"))        //AQUI   
			
	     aDadosBanco  := {SA6->A6_COD                        					,;	// [1] Numero do Banco
	                   SA6->A6_NOME      	            	                  	,; 	// [2] Nome do Banco
	                   SUBSTR(SA6->A6_AGENCIA, 1, 6)                        	,;	// [3] Agência
	                   SUBSTR(SA6->A6_NUMCON, 1, 9)							    ,; 	// [4] Conta Corrente 
	                   SA6->A6_DVCTA			 								,; 	// [5] Dígito da conta corrente
	                   ""			 										    ,;  // [6] Codigo da Carteira SA6->A6_CARTCBR
	                   0														,;	// [7] Tx da Multa  SA6->A6_TXMLTBL     
	                   0.06			 										    ,;  // [8] Tx de Mora Diaria SA6->A6_TXMORBL
	                   If(SM0->M0_CODIGO=="01","5297362","6038751")			}   // [9] Codigo do Cedente Substr(SEE->EE_CODEMP,1,7) 
	   
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
			AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
			SA1->A1_EST                                      ,;    		// [5]Estado
			SA1->A1_CEP                                      ,;      	// [6]CEP
			SA1->A1_CGC										 ,;  		// [7]CGC
			SA1->A1_PESSOA}       										// [8]PESSOA
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)            	,;   	// [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
			AllTrim(SA1->A1_MUNC)	                            ,;   	// [4]Cidade
			SA1->A1_ESTC	                                    ,;   	// [5]Estado
			SA1->A1_CEPC                                        ,;   	// [6]CEP
			SA1->A1_CGC											,;		// [7]CGC
			SA1->A1_PESSOA}												// [8]PESSOA
		Endif
	
		If Empty (SE1->E1_NUMBCO)
		   cNumNN   := Strzero(Val(Alltrim(SEE->EE_FAXATU))+1,12)
	       	
		   RecLock( "SEE" , .F. )
		   SEE->EE_FAXATU := cNumNN
	       MsUnlock()
	       
	       //--- Para o Santander precisa gravar o Nosso Numero com o Digito (Modulo 11)
	       nCalcNrBanc  := Alltrim(cNumNN)
		   cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
		   cNossoNum 	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
	
	       RecLock( "SE1" , .F. )
		   SE1->E1_NUMBCO := cNossoNum
		   MsUnlock()
	    Else
		   cNossoNum := Substr(SE1->E1_NUMBCO,1,12)
	    EndIf   
		//--- fim 22.03.07
		
		cAgeNN		:= SUBSTR(SA6->A6_AGENCIA,1,4)
		cCtaNN		:= SUBSTR(SA6->A6_NUMCON,1,9)
		cCarNN		:= "101" //Alltrim(SUBSTR(SA6->A6_CARTCBR,1,3)) 
		cNumNN		:= SUBSTR(SE1->E1_NUMBCO,1,12)
		nCalcNrBanc := Alltrim(cNumNN)
		cDVNrBanc	:= Modulo11Nn(Alltrim(nCalcNrBanc))
		cNrBancario	:= Alltrim(cNumNN) + Alltrim(str(cDVNrBanc))
		
		//nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nVlrAbat 	:= SE1->E1_VALOR - SE1->E1_SALDO
		
		cRetorno	:= SE1->E1_VENCREA
		//Monta codigo de barras
		//aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNrBancario,(SE1->E1_VALOR-nVlrAbat+SE1->E1_ACRESC),SE1->E1_VENCREA,cCarNN,aDadosBanco[9])
		aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNrBancario,(SE1->E1_VALOR-nVlrAbat),SE1->E1_VENCREA,cCarNN,aDadosBanco[9])
	
			
		aDadosTit	:= {AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA)	,;  // [1] Número do título
						SE1->E1_EMISSAO                      			,;  // [2] Data da emissão do título
						dDataBase                    					,;  // [3] Data da emissão do boleto					
						SE1->E1_VENCREA                       			,;  // [4] alterado por Fabio Sales em 03/05/2012 de vencimento SE1->E1_VENCTO para SE1->E1_VENCREA
						SE1->E1_VALOR				           			,;  // [5] Valor do título
						SE1->E1_NUMBCO									,;  // [6] Nosso número (Ver fórmula para calculo)
						SE1->E1_PREFIXO                      			,;  // [7] Prefixo da NF
						SE1->E1_TIPO	                        		,;	// [8] Tipo do Titulo
						nVlrAbat                                        ,;   //Abatimento
						SE1->E1_ACRESC									}
	
		If !Empty(SE1->E1_NFELETR)
			cRet := cMsg + SE1->E1_NFELETR
		Endif	
	 	
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNrBancario,cRet,cDVNrBanc)
		nX := nX + 1
		
		IncProc()
	EndIf
Next nI

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir    


Return(cRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN,cNrBancario,cRet,cDVNrBanc) 

LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont13
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)   
oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//oPrint:StartPage()   // Inicia uma nova página

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 0

oPrint:Line (nRow2+045,030,nRow2+045, 550)
oPrint:Line (nRow2+045,155,nRow2+025, 155)
oPrint:Line (nRow2+045,210,nRow2+025, 210)

oPrint:SayBitmap(nRow2+015,020,"logosant.bmp",130,025) //300, 120      // Imprime o Logo do Banco     +0135

oPrint:Say  (nRow2+043,158,aDadosBanco[1]+"-7",oFont21, 10 )	// [1]Numero do Banco
oPrint:Say  (nRow2+040,435,"Recibo do Sacado",oFont10, 10 )



oPrint:Line (nRow2+080,030,nRow2+080,550 )
oPrint:Line (nRow2+115,030,nRow2+115,550 )
oPrint:Line (nRow2+140,030,nRow2+140,550 )
oPrint:Line (nRow2+165,030,nRow2+165,550 )

oPrint:Line (nRow2+115,100,nRow2+165,100)
oPrint:Line (nRow2+140,150,nRow2+165,150)
oPrint:Line (nRow2+115,215,nRow2+165,215) //
oPrint:Line (nRow2+115,290,nRow2+140,290)
oPrint:Line (nRow2+115,350,nRow2+165,350)

oPrint:Say  (nRow2+055,030 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+070,100 ,"Pagar preferencialmente no Grupo Santander",oFont10)

oPrint:Say  (nRow2+055,435,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
//nCol := 550-(len(cString)*22)
oPrint:Say  (nRow2+070,490,cString,oFont11c)

oPrint:Say  (nRow2+090,030 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+100,030 ,aDadosEmp[1]+"       - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+090,435,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+" / "+aDadosBanco[9])
//nCol  := (550-(len(cString)*22))
oPrint:Say  (nRow2+100,465,cString,oFont11c)

oPrint:Say  (nRow2+125,030 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+135,030, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+125,103 ,"Número do Documento"                      ,oFont8)
oPrint:Say  (nRow2+135,135 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+125,217,"Espécie Documento"                                   ,oFont8)
oPrint:Say  (nRow2+135,220,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+125,292,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+135,295,"N"                                             ,oFont10)

oPrint:Say  (nRow2+125,352,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+135,360,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+125,435,"Nosso Número"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + Alltrim(str(cDVNrBanc)) )
//nCol := 1810+(444-(len(cString)*22))
oPrint:Say  (nRow2+135,450,cString,oFont11c)

oPrint:Say  (nRow2+148,030 ,"Carteira    "                                   ,oFont8)
oPrint:Say  (nRow2+158,030 ,"RCR"                                            ,oFont10)

oPrint:Say  (nRow2+148,153 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+158,157 ,"REAL"                                             ,oFont10)

oPrint:Say  (nRow2+148,217,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+148,352,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+148,435,"(=) Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
//nCol := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow2+158,490,cString ,oFont11c)

oPrint:Say  (nRow2+172,030 ,"Instruções (Termo de responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+182,030 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*aDadosBanco[8])/30),"@E 99,999.99")) 	,oFont10)
oPrint:Say  (nRow2+192,030 ,aBolText[2]                                                                        	,oFont10)
oPrint:Say  (nRow2+202,030 ,aBolText[3]                                                                       			,oFont10) //Alterado - Josilton 07-05-09 Tirado a desclição de "Valor por extenço"
oPrint:Say  (nRow2+212,030 ,aBolText[4]                                                                       			,oFont10) //Alterado - Josilton 07-05-09 Tirado a desclição de "Valor por extenço"
oPrint:Say  (nRow2+232,030 ,cRet																					,oFont10)

oPrint:Say  (nRow2+172,435,"(-)Desconto"                         ,oFont8)
oPrint:Say  (nRow2+196,435,"(-)Abatimento"                             ,oFont8)

oPrint:Say  (nRow2+192,435,Alltrim(Transform(aDadosTit[9],"@E 99,999,999.99")),oFont8)

oPrint:Say  (nRow2+219,435,"(+)Mora"                                  ,oFont8)
oPrint:Say  (nRow2+243,435,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (nRow2+267,435,"(=)Valor Cobrado"                               ,oFont8)
                                    


oPrint:Say  (nRow2+290,030 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+300,100 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"            ,oFont10)
oPrint:Say  (nRow2+315,100 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+325,100 ,aDatSacado[4]+" - "+aDatSacado[5]+ " CEP: " + aDatSacado[6],oFont10) // Cidade+Estado+CEP
if aDatSacado[8] = "F"
	oPrint:Say  (nRow2+335,100 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
Else
	oPrint:Say  (nRow2+335,100 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
EndIf

oPrint:Say  (nRow2+359,030 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+359,352,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2+045,0430,nRow2+0282,0430 ) 
oPrint:Line (nRow2+190,0430,nRow2+0190,0550 )
oPrint:Line (nRow2+213,0430,nRow2+0213,0550 )
oPrint:Line (nRow2+236,0430,nRow2+0236,0550 )
oPrint:Line (nRow2+261,0430,nRow2+0261,0550 )
oPrint:Line (nRow2+282,030 ,nRow2+0282,0550 )
oPrint:Line (nRow2+350,030 ,nRow2+0350,0550 )


/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 0

For nI := 030 to 550 step 20
	oPrint:Line(nRow3+418, nI, nRow3+418, nI+10)
Next nI

oPrint:Line (nRow3+458,030,nRow3+458, 550)
oPrint:Line (nRow3+458,155,nRow3+438, 155)
oPrint:Line (nRow3+458,210,nRow3+438, 210)

oPrint:SayBitmap(nRow3+430,015,"logosant.bmp",130,025) //300, 120      // Imprime o Logo do Banco
oPrint:Say  (nRow3+456,158,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+454,215,aCB_RN_NN[2],oFont14n)			//	Linha Digitavel do Codigo de Barras    

oPrint:Line (nRow3+498,030,nRow3+498,550 )
oPrint:Line (nRow3+538,030,nRow3+538,550 )
oPrint:Line (nRow3+563,030,nRow3+563,550 )
oPrint:Line (nRow3+588,030,nRow3+588,550 )

oPrint:Line (nRow3+538,100,nRow3+588, 100)
oPrint:Line (nRow3+563,150,nRow3+588, 150)
oPrint:Line (nRow3+538,215,nRow3+588, 215)
oPrint:Line (nRow3+538,290,nRow3+563, 290)
oPrint:Line (nRow3+538,350,nRow3+588, 350)

oPrint:Say  (nRow3+473,030 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+488,100 ,"Pagar preferencialmente no Grupo Santander",oFont10)
           
oPrint:Say  (nRow3+473,435,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
//nCol	 	 := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+488,490,cString,oFont11c)

oPrint:Say  (nRow3+508,030 ,"Cedente",oFont8)
oPrint:Say  (nRow3+522,030 ,aDadosEmp[1]+"       - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+508,435,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[9])
//nCol 	 := 1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+522,465,cString ,oFont11c)

oPrint:Say  (nRow3+545,030 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+555,030, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+545,103 ,"Número do Documento"                                  ,oFont8)
oPrint:Say  (nRow3+555,135 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+545,217,"Espécie Documento"                                   ,oFont8)
oPrint:Say  (nRow3+555,220,"DM"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+545,292,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+555,295,"N"                                             ,oFont10)

oPrint:Say  (nRow3+545,352,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+555,360,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+545,435,"Nosso Número"                                   ,oFont8)
cString := Alltrim(Substr(aDadosTit[6],1,12) +  ' ' + Alltrim(str(cDVNrBanc))  )
//nCol:= 		1810+(444-(len(cString)*22))
oPrint:Say  (nRow3+555,450,cString,oFont11c)

oPrint:Say  (nRow3+570,030 ,"Carteira"                                   ,oFont8)
oPrint:Say  (nRow3+580,030 ,"RCR"                        	,oFont10)

oPrint:Say  (nRow3+570,153 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+580,157 ,"REAL"                                             ,oFont10)

oPrint:Say  (nRow3+570,217,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+570,352,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+570,435,"(=) Valor do Documento"                          	,oFont8)
cString:=   Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
//nCol:=      1810+(460-(len(cString)*22))
oPrint:Say  (nRow3+580,490,cString,oFont11c)

oPrint:Say  (nRow2+594,030 ,"Instruções (Termo de responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+604,030 ,aBolText[1]+" "+AllTrim(Transform(((aDadosTit[5]*aDadosBanco[8])/30),"@E 99,999.99"))	,oFont10)
oPrint:Say  (nRow2+614,030 ,aBolText[2]                                                                        	,oFont10)
oPrint:Say  (nRow2+624,030 ,aBolText[3]                                                               			,oFont10) //Alterado - Josilton 07-05-09 Tirado a desclição de "Valor por extenço"
oPrint:Say  (nRow2+634,030 ,aBolText[4]                                                               			,oFont10) //Alterado - Josilton 07-05-09 Tirado a desclição de "Valor por extenço"
oPrint:Say  (nRow2+644,030 ,cRet																					,oFont10)

oPrint:Say  (nRow3+594,435,"(-)Desconto"                         ,oFont8)
oPrint:Say  (nRow3+616,435,"(-)Abatimento"                      ,oFont8)     

oPrint:Say  (nRow3+614,435,Alltrim(Transform(aDadosTit[9],"@E 99,999,999.99")),oFont8)

oPrint:Say  (nRow3+639,435,"(+)Mora"                              ,oFont8)
oPrint:Say  (nRow3+663,435,"(+)Outros Acréscimos"         ,oFont8)
oPrint:Say  (nRow3+687,435,"(=)Valor Cobrado"                ,oFont8)

oPrint:Say  (nRow3+708,030 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+718,100 ,aDatSacado[1]+" ("+aDatSacado[2]+" )"             ,oFont10)
oPrint:Say  (nRow3+730,100 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+740,100 ,aDatSacado[4]+" - "+aDatSacado[5]+ " CEP: " + aDatSacado[6]	,oFont10) // Cidade+Estado+CEP

if aDatSacado[8] = "F"
	oPrint:Say  (nRow3+750,100,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
Else
	oPrint:Say  (nRow3+750,100,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
EndIf
oPrint:Say  (nRow3+770,030 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (nRow3+770,352,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRow3+458,430,nRow3+700,430 )
oPrint:Line (nRow3+610,430,nRow3+610,550 )
oPrint:Line (nRow3+631,430,nRow3+631,550 )
oPrint:Line (nRow3+654,430,nRow3+654,550 )
oPrint:Line (nRow3+679,430,nRow3+679,550 )
oPrint:Line (nRow3+700,030,nRow3+700,550 )
oPrint:Line (nRow3+758,030,nRow3+758,550  )

oPrint:Code128c(nRow3+835,030,aCB_RN_NN[1],50)

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
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
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11Nn ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO SANTANDER COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO SANTANDER COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNrBancario,nValor,dVencto,cCart,cCedente)

LOCAL cValorFinal 	:= strzero(nValor*100,10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS				:= ''
LOCAL cFator      := strzero(dVencto - ctod("07/10/97"),4)

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
// cBanco está igual a 0339
cS:= cBanco + cFator +  cValorFinal + "9" + cCedente + cNrBancario + "0" + cCart
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,39)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.DDDDX		EEEFF.FFFFFY	GGGGG.GHJJJZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao   
//	  B = Codigo da moeda, sempre 9
//	  C = Fixo "9"
//	 DDDD = 4 Primeiras posicoes do codigo do cedente padrao Santander Banespa
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS1   := cBanco + "9" + SubStr(cCedente,1,4)
nDv1  := modulo10(cS1)
cRN1  := SubStr(cS1, 1, 5) + '.' + SubStr(cS1, 6, 4) + AllTrim(Str(nDv1)) + '   '

// 	CAMPO 2:
//	EEE  = Restante do Codigo do Cedente padrao Santander Banesp
//	FFFFFFF = Sete primeiros campos do Nosso Numero
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS2 := SubStr(cCedente,5,3) + SubStr(cNrBancario,1,7) 
nDv2:= modulo10(cS2)
cRN2:= SubStr(cS2, 1, 5) + '.' + SubStr(cS2, 6, 5) + AllTrim(Str(nDv2)) + '   '

// 	CAMPO 3:
//	GGGGGG = Restante do Nosso Numero                  
//	H              = 0  (Conteudo Fixo)
//	JJJ            = Carteira
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS3   := Subs(cNrBancario,8,6) + "0" + cCart
nDv3  := modulo10(cS3)
cRN3  := SubStr(cS3, 1, 5) + '.' + SubStr(cS3, 6, 5) + AllTrim(Str(nDv3)) + '   '

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN4  := AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN5  := cFator + cValorFinal

cRN	  := cRN1 + cRN2 + cRN3 + cRN4 + cRN5

Return({cCB,cRN})



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 23.05.05 ³ Modelagem de Dados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)                                                                                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTRBOLETO ºAutor  ³Alexandre Venancio  º Data ³  05/16/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Numero da nota fiscal que devera gerar o boleto automatico º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CallRegs(cnota)
                    
Local aTitulos := {}
Local cQry	:= "SELECT"

cQry	+= " SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,SE1.E1_NATUREZ,SE1.E1_CLIENTE,SE1.E1_LOJA,"
cQry	+= " SE1.E1_NOMCLI,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_VALOR,SE1.E1_HIST,SE1.E1_NUMBCO,"
cQry	+= " R_E_C_N_O_ AS E1_REGSE1"
cQry	+= " FROM "+RetSqlName("SE1")+" SE1 "
cQry	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"                                                                  //AQUI
cQry	+= " AND SE1.E1_PREFIXO = '"+xFilial("SF2")+MV_PAR03+"'" // AND '"++"'" //"+mv_par01+"' AND '"+mv_par02+"'"
cQry	+= " AND SE1.E1_NUM BETWEEN '"+strzero(cnota,9)+"' AND '"+strzero(cnota,9)+"'" //"+mv_par03+"' AND '"+mv_par04+"'"
//cQry	+= " AND SE1.E1_PARCELA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
//cQry	+= " AND SE1.E1_TIPO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'"
//cQry	+= " AND SE1.E1_CLIENTE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"'"
//cQry	+= " AND SE1.E1_LOJA BETWEEN '"+mv_par11+"' AND '"+mv_par12+"'"
//cQry	+= " AND SE1.E1_EMISSAO BETWEEN '"+DTOS(mv_par13)+"' AND '"+DTOS(mv_par14)+"'"
//cQry	+= " AND SE1.E1_VENCTO BETWEEN '"+DTOS(mv_par15)+"' AND '"+DTOS(mv_par16)+"'"
//cQry	+= " AND SE1.E1_NATUREZ BETWEEN '"+mv_par17+"' AND '"+mv_par18+"'"
cQry	+= " AND SE1.E1_SALDO > 0"
//cQry	+= " AND SE1.E1_NUMBOR BETWEEN '"+mv_par31+"' AND '"+mv_par32+"'"

cQry	+= " AND SE1.E1_TIPO NOT IN('"+MVABATIM+"')"
cQry	+= " AND SE1.D_E_L_E_T_ <> '*'"
cQry	+= " ORDER BY SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO"

If Select("FINR01A") > 0
	dbSelectArea("FINR01A")
	dbCloseAea()
EndIf

TCQUERY cQry NEW ALIAS "FINR01A"
TCSETFIELD("FINR01A", "E1_EMISSAO",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VENCTO",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VENCREA",	"D",08,0)
TCSETFIELD("FINR01A", "E1_VALOR", 	"N",14,2)
TCSETFIELD("FINR01A", "E1_REGSE1",	"N",10,0)

dbSelectArea("FINR01A")
While !Eof()
	aAdd(aTitulos, {	.T.,;						// 1=Mark
						FINR01A->E1_PREFIXO,;		// 2=Prefixo do Título
						FINR01A->E1_NUM,;			// 3=Número do Título
						FINR01A->E1_PARCELA,;		// 4=Parcela do Título
						FINR01A->E1_TIPO,;			// 5=Tipo do Título
						FINR01A->E1_NATUREZ,;		// 6=Natureza do Título
						FINR01A->E1_CLIENTE,;		// 7=Cliente do título
						FINR01A->E1_LOJA,;			// 8=Loja do Cliente
						FINR01A->E1_NOMCLI,;		// 9=Nome do Cliente
						FINR01A->E1_EMISSAO,;		//10=Data de Emissão do Título
						FINR01A->E1_VENCTO,;		//11=Data de Vencimento do Título
						FINR01A->E1_VENCREA,;		//12=Data de Vencimento Real do Título
						FINR01A->E1_VALOR,;			//13=Valor do Título
						FINR01A->E1_HIST,;			//14=Histótico do Título
						FINR01A->E1_REGSE1,;		//15=Número do registro no arquivo
						FINR01A->E1_NUMBCO ;		//16=Nosso Número
						})
	dbSkip()
EndDo

If Len(aTitulos) == 0
	aAdd(aTitulos, {.F.,"","","","","","","","","","","",0,"",0,""})
EndIf

dbSelectArea("FINR01A")
dbCloseArea()

Return(aTitulos)          