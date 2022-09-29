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
±±ºPrograma  ³TTRBOL2	ºAutor  ³Alexandre Venancio  º Data ³  05/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Boleto para os demais bancos.                             º±±
±±º          ³** enviado por email ao emitir a Danfe ***                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTRBOL2(nNotF)

Local oPrint
Local nX := 0
Local cNroDoc 	   :=  " "
Local aDadosEmp 
Local nMulta	:= 0          
Local nDiasProt := 0  
Local nDiasMult := 0  
                      
Local aDadosTit
Local aDadosBanco
Local aDatSacado
Local aBolText 

Local aBco		   := {}                                   
Local nI           := 1
Local aCB_RN_NN    := {}
Local nVlrAbat	   := 0
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T. 
Local cRetorno	:=	""

Private cBanco   := ""
Private cAgencia := ""
Private cConta   := ""
Private cSubCt   := ""
Private aCabec  := {} 

//nNotF := 144734
//MV_PAR03 := '2'
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN" TABLES "SE1/SEA/SA6"

Private aTitulos	:=	CallRegs(nNotF)

oPrint := FWMSPrinter():New("Boleto"+Strzero(nNotF,9)+".rel", IMP_PDF, lAdjustToLegacy, "\SPOOL\", lDisableSetup,,,,.T.,,,.T.)

oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

oPrint:SetMargin(5,10,5,10) // nEsquerda, nSuperior, nDireita, nInferior 

oPrint:cPathPDF := "\spool\" // Caso seja utilizada impressão em IMP_PDF

For nX := 1 to len(aTitulos)

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
 
    cBanco   := SE1->E1_PORTADO
    cAgencia := SE1->E1_AGEDEP
    cConta   := SE1->E1_CONTA
    cSubct   := Posicione("SEE",1,xFilial("SEE")+cBanco+cAgencia+cConta,"EE_SUBCTA")
                                                                
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o SA6 (Bancos)    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SA6")
	DbSetOrder(1)
   	If !DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)
      	Loop
   	EndIf
                   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona na Arq de Parametros CNAB   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SEE")
	DbSetOrder(1)

   	If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCt)
        Loop
   	EndIf
	
	DbSelectArea("SE1")

	aDadosBanco  := {SEE->EE_CODIGO  										    ,;	//	[1]	Numero do Banco
                     SUBSTR(Alltrim(SA6->A6_NOME),1,15)						,;	//	[2]	Nome do Banco
	                 SUBSTR(SEE->EE_AGENCIA, 1, 4)								,;	//	[3]	Agência
                     SUBSTR(SA6->A6_NUMCON,	1,Len(AllTrim(SA6->A6_NUMCON))-1)	,;	//	[4]	Conta Corrente
                     SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)	  	,;	//	[5]	Dígito da conta corrente
                     SUBSTR(SEE->EE_SUBCTA,1,3)									,;  //	[6]	Codigo da Carteira
                     SUBSTR(SEE->EE_AGENCIA,5,1)								}   //	[7]	Digito da Agencia

	aDadosEmp    := {	SM0->M0_NOMECOM																,;	//	[1]	Nome do Cedente
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+			 ;	//	[2]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+ 			 	     ;	//	[2]
						Subs(SM0->M0_CGC,13,2)													 }	//	[2]	CGC			    
                     
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)				,;	//	[1]	Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;	//	[3]	Endereço
		AllTrim(SA1->A1_MUN )								,;	//	[4]	Cidade
		SA1->A1_EST											,;	//	[5]	Estado
		SA1->A1_CEP											,;	//	[6]	CEP
		SA1->A1_CGC											,;	//	[7]	CGC
		SA1->A1_PESSOA										}	//	[8]	PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)				,;	//	[1]	Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA				,;	//	[2]	Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;	//	[3]	Endereço
		AllTrim(SA1->A1_MUNC)								,;	//	[4]	Cidade
		SA1->A1_ESTC										,;	//	[5]	Estado
		SA1->A1_CEPC										,;	//	[6]	CEP
		SA1->A1_CGC											,;	//	[7]	CGC
		SA1->A1_PESSOA										}	//	[8]	PESSOA
	Endif
	
	nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)  
	cRetorno	:= SE1->E1_VENCREA
	cParcel  := If(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)
    nTxJur   := SE1->E1_VALJUR
    
    If !Empty(SE1->E1_NUMBCO)
    
    	If aDadosBanco[1] == "001"
    		cNroDoc := Right(SE1->E1_NUMBCO,10)
    	Else//237 por enquanto
    		cNroDoc := SubStr(SE1->E1_NUMBCO,1,11)
    	EndIf
    	
	ElseIf !Empty(SEE->EE_FAXATU)
	 	cNroDoc	:= Right(SEE->EE_FAXATU,10)       
	Else
		cNroDoc	:= STRZERO(VAL(SE1->E1_NUM),10)	
	EndIf
    
	cNroDoc	:= STRZERO(VAL(cNroDoc),10)
   

    nDiasProt := getmv("MV_XPROTES")
    

	cMen1 := "Cobrar juros de R$ "+AllTrim(Transform(ntxjur,"@E 999,999.99"))+" por  dia de atraso após o vencimento."
	cMen2 := Iif(nDiasProt>0,"Protestar após "+Alltrim(Transform(nDiasProt,"99"))+" dias de vencimento."," -- ")
	cMen3 := Iif(SE1->E1_PORTADO=='237',"Após vencimento pagavel somente nas Agencias do Bradesco", "Código de cliente "+SA1->A1_COD+" " + SA1->A1_LOJA)
	cMen4 := " "//Iif(mv_par19=='237'," ","Sr. Caixa nao deixar de cobrar R$ "+AllTrim(Transform(SA6->A6_TXCOBSI,"@E 999,999.99"))+" ref. custas bancárias.")
    cMen5 := "--"
    
    aBolText    := { 	cMen1 									,; //[1] TEXTO 1
				  		cMen2 									,; //[2] TEXTO 1
						cMen3 									,; //[3] TEXTO 1
						cMen4 									,;  //[4] TEXTO 1                     
						cMen5									}  //[5] TEXTO 1                     


	//Monta codigo de barras
    aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9"			,; //Banco
							  Subs(aDadosBanco[3],1,4)				,;//Agencia
							  aDadosBanco[4]						,;//Conta
							  aDadosBanco[5]						,;//Digito da Conta
							  aDadosBanco[6]						,;//Carteira
							  AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,;//Documento
							  (E1_SALDO-nVlrAbat)					,;//Valor do Titulo
							  SE1->E1_VENCREA 						,;//Vencimento
							  SEE->EE_CODEMP						,;//Convenio
							  cNroDoc  								,;//Sequencial
							  Iif(SE1->E1_DECRESC > 0,.t.,.f.)		,;//Se tem desconto
							  SE1->E1_PARCELA						,;//Parcela
							  aDadosBanco[3])						  //Agencia Completa

	aDadosTit := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	,;  //	[1]	Número do título
						E1_EMISSAO						,;  //	[2]	Data da emissão do título
						dDataBase						,;  //	[3]	Data da emissão do boleto
						E1_VENCREA						,;  //	[4]	Data do vencimento
						IF(Posicione("SE5",7,xFilial("SE5")+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO,"E5_MOTBX")=="CMP",E1_VALOR,(E1_SALDO - nVlrAbat))			,;  //	[5]	Valor do título
						aCB_RN_NN[3]					,;  //	[6]	Nosso número (Ver fórmula para calculo)
						E1_PREFIXO						,;  //	[7]	Prefixo da NF                          
						E1_TIPO							,;  //	[8]	Prefixo da NF
						IF(Posicione("SE5",7,xFilial("SE5")+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO,"E5_MOTBX")=="CMP",E1_VALOR-E1_SALDO,E1_DECRESC)						,;  //	[9]	Decrescimo
						E1_XACRPV						}   //	[10]Acrescimo	

   	If cBanco == nil
		 If Marked("E1_OK")
	    	  Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		  	nX := nX + 1
	  	 EndIf
   	Else
   			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)  
			nX := nX + 1
	EndIf
    
	DbSelectArea("SE1")
	//dbSkip()
	//IncProc()
	nI := nI + 1

Next nX

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()// Visualiza antes de imprimir    

Return(cRetorno)
            
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)

LOCAL oFont8
LOCAL oFont11c
LOCAL oFont11
LOCAL oFont10
LOCAL oFont13
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
oFont11  := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0.25
nRow5 := 0.25
nLin2 := 0.275
 
oPrint:Line (nRow1*0150,nRow1*500,nRow1*0070,nRow1* 500)
oPrint:Line (nRow1*0150,710*nRow1,nRow1*0070, nRow1*710)

If aDadosBanco[1] == "001"
	oPrint:Say  (nLin2*0104,nRow5*100,aDadosBanco[2],oFont11 )			// [2]Nome do Banco
Else
	oPrint:Say  (nLin2*0104,nRow5*100,aDadosBanco[2],oFont13 )			// [2]Nome do Banco
EndIf

If aDadosBanco[1] == "341"
 oPrint:Say  (nLin2*0100,nRow5*513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] == "409"
 oPrint:Say  (nLin2*0100,nRow5*513,aDadosBanco[1]+"-0",oFont21 )		// [1]Numero do Banco
ElseIf aDadosBanco[1] == "237"                 
 oPrint:Say  (nLin2*0100,nRow5*513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
Else
 oPrint:Say  (nLin2*0100,nRow5*513,aDadosBanco[1]+"-9",oFont21 )		// [1]Numero do Banco
Endif

oPrint:Say  (nLin2*0104,nRow5*1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRow1*0150,100*nRow1,nRow1*0150,nRow1*2300)

oPrint:Say  (nLin2*0160,nRow5*100 ,"Cedente",oFont8)
oPrint:Say  (nLin2*0210,nRow5*100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nLin2*0160,nRow5*1060,"Agência/Código Cedente",oFont8)
If aDadosBanco[1] $ "001/237"
	oPrint:Say  (nLin2*0210,nRow5*1060,aDadosBanco[3]+"-"+aDadosBanco[7]+" / "+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
Else
	oPrint:Say  (nLin2*0210,nRow5*1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
EndIf

oPrint:Say  (nLin2*0160,nRow5*1510,"Nro.Documento",oFont8)
oPrint:Say  (nLin2*0210,nRow5*1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nLin2*0250,nRow5*100 ,"Sacado",oFont8)
oPrint:Say  (nLin2*0300,nRow5*100 ,left(aDatSacado[1],40),oFont10)				//Nome

oPrint:Say  (nLin2*0250,nRow5*1060,"Vencimento",oFont8)
oPrint:Say  (nLin2*0300,nRow5*1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nLin2*0250,nRow5*1510,"Valor do Documento",oFont8)
oPrint:Say  (nLin2*0300,nRow5*1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nLin2*0400,nRow5*0100,"Recebi(emos) o bloqueto/título"	,oFont10 )
oPrint:Say  (nLin2*0450,nRow5*0100,"com as características acima."	,oFont10 )
oPrint:Say  (nLin2*0350,nRow5*1060,"Data"								,oFont8  )
oPrint:Say  (nLin2*0350,nRow5*1410,"Assinatura"						,oFont8  )
oPrint:Say  (nLin2*0450,nRow5*1060,"Data"								,oFont8  )
oPrint:Say  (nLin2*0450,nRow5*1410,"Entregador"						,oFont8  )

oPrint:Line (nRow1*0250, 100*nRow1,nRow1*0250,nRow1*1900 )
oPrint:Line (nRow1*0350, 100*nRow1,nRow1*0350,nRow1*1900 )
oPrint:Line (nRow1*0450,1050*nRow1,nRow1*0450,nRow1*1900 )
oPrint:Line (nRow1*0550, 100*nRow1,nRow1*0550,nRow1*2300 )

oPrint:Line (nRow1*0550,1050*nRow1,nRow1*0150,nRow1*1050 )
oPrint:Line (nRow1*0550,1400*nRow1,nRow1*0350,nRow1*1400 )
oPrint:Line (nRow1*0350,1500*nRow1,nRow1*0150,nRow1*1500 )
oPrint:Line (nRow1*0550,1900*nRow1,nRow1*0150,nRow1*1900 )

oPrint:Say  ( nLin2*0165,nRow5*1910,"(  )Mudou-se"					,oFont8 )
oPrint:Say  ( nLin2*0205,nRow5*1910,"(  )Ausente"						,oFont8 )
oPrint:Say  ( nLin2*0245,nRow5*1910,"(  )Não existe nº indicado"		,oFont8 )
oPrint:Say  ( nLin2*0285,nRow5*1910,"(  )Recusado"					,oFont8 )
oPrint:Say  ( nLin2*0325,nRow5*1910,"(  )Não procurado"				,oFont8 )
oPrint:Say  ( nLin2*0365,nRow5*1910,"(  )Endereço insuficiente"		,oFont8 )
oPrint:Say  ( nLin2*0405,nRow5*1910,"(  )Desconhecido"				,oFont8 )
oPrint:Say  ( nLin2*0445,nRow5*1910,"(  )Falecido"					,oFont8 )
oPrint:Say  ( nLin2*0485,nRow5*1910,"(  )Outros(anotar no verso)"		,oFont8 )
           

/*****************/
/* SEGUNDA PARTE */
/*****************/

//nRow2 := 250
nRow2 := 0.25  
//nRow1 := 0.25
//nRow5 := 0.25
nLin2 := 0.26


//Pontilhado separador
For nI := nRow2*100 to nRow2*2300 step 50
	oPrint:Line(nRow2*0580, nI,nRow2*0580, nI+30)
Next nI

oPrint:Line (nRow2*0710,nRow2*100,nRow2*0710,nRow2*2300)
oPrint:Line (nRow2*0710,nRow2*500,nRow2*0630, nRow2*500)
oPrint:Line (nRow2*0710,nRow2*710,nRow2*0630, nRow2*710)

If aDadosBanco[1] == "001"
	oPrint:Say  (nLin2*0664,nRow5*100,aDadosBanco[2],oFont11 )		// [2]Nome do Banco
Else
	oPrint:Say  (nLin2*0664,nRow5*100,aDadosBanco[2],oFont13 )		// [2]Nome do Banco
EndIf

If aDadosBanco[1] == "341"
 oPrint:Say  (nLin2*0655,nRow5*513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
ElseIf aDadosBanco[1] == "409"
 oPrint:Say  (nLin2*0655,nRow5*513,aDadosBanco[1]+"-0",oFont21 )	// [1]Numero do Banco
ElseIf aDadosBanco[1] == "237"                 
 oPrint:Say  (nLin2*0655,nRow5*513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
Else
 oPrint:Say  (nLin2*0655,nRow5*513,aDadosBanco[1]+"-9",oFont21 )	// [1]Numero do Banco
EndIf

oPrint:Say  (nLin2*0664,nRow5*1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2*0810,nRow2*100,nRow2*0810,nRow2*2300 )
oPrint:Line (nRow2*0910,nRow2*100,nRow2*0910,nRow2*2300 )
oPrint:Line (nRow2*0980,nRow2*100,nRow2*0980,nRow2*2300 )
oPrint:Line (nRow2*1050,nRow2*100,nRow2*1050,nRow2*2300 )

oPrint:Line (nRow2*0910,nRow2*500,nRow2*1050,nRow2*500)
oPrint:Line (nRow2*0980,nRow2*750,nRow2*1050,nRow2*750)
oPrint:Line (nRow2*0910,nRow2*1000,nRow2*1050,nRow2*1000)
oPrint:Line (nRow2*0910,nRow2*1300,nRow2*0980,nRow2*1300)
oPrint:Line (nRow2*0910,nRow2*1480,nRow2*1050,nRow2*1480)

oPrint:Say  (nLin2*0710,nRow5*100 ,"Local de Pagamento",oFont8)
If aDadosBanco[1] == "237"
	oPrint:Say  (nLin2*0745,nRow5*400 ,"Pagável preferencialmente nas agencias do Bradesco.",oFont10)
Else
	oPrint:Say  (nLin2*0745,nRow5*400 ,"Pagável em qualquer Banco até o vencimento.",oFont10)
EndIf
oPrint:Say  (nLin2*0765,nRow5*400 ," ",oFont10)

oPrint:Say  (nLin2*0710,nRow5*1810,"Vencimento",oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*0750,nRow5*nCol,cString,oFont11c)

oPrint:Say  (nLin2*0810,nRow5*100 ,"Cedente",oFont8)
oPrint:Say  (nLin2*0850,nRow5*100 ,aDadosEmp[1]+"                  - "+aDadosEmp[2],oFont10) //Nome + CNPJ

oPrint:Say  (nLin2*0810,nRow5*1810,"Agência/Código Cedente",oFont8)
If aDadosBanco[1] $ "001/237"
	cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+" / "+aDadosBanco[4]+"-"+aDadosBanco[5])
Else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
EndIf
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*0850,nRow5*nCol,cString,oFont11c)

oPrint:Say  (nLin2*0900,nRow5*100 ,"Data do Documento",oFont8)
oPrint:Say  (nLin2*0940,nRow5*100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nLin2*0900,nRow5*505 ,"Nro.Documento",oFont8)
oPrint:Say  (nLin2*0940,nRow5*605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nLin2*0900,nRow5*1005,"Espécie Doc.",oFont8)
If aDadosBanco[1] $ "001/237"
	oPrint:Say  (nLin2*0940,nRow5*1050,"DM",oFont10) //Tipo do Titulo
Else
	oPrint:Say  (nLin2*0940,nRow5*1050,aDadosTit[8],oFont10) //Tipo do Titulo
EndIf



oPrint:Say  (nLin2*0900,nRow5*1305,"Aceite",oFont8)
oPrint:Say  (nLin2*0940,nRow5*1400,"N",oFont10)

oPrint:Say  (nLin2*0900,nRow5*1485,"Data do Processamento",oFont8)
oPrint:Say  (nLin2*0940,nRow5*1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nLin2*0900,nRow5*1810,"Nosso Número",oFont8)

If aDadosBanco[1] == "001"
	cString := Alltrim(aCB_RN_NN[3])
Else
	cString := Alltrim(aDadosTit[6])
EndIf

nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*0940,nRow5*nCol,cString,oFont11c)

oPrint:Say  (nLin2*0970,nRow5*100 ,"Uso do Banco",oFont8)

oPrint:Say  (nLin2*0970,nRow5*505 ,"Carteira",oFont8)
If aDadosBanco[1] == "001"
	//oPrint:Say  (nRow2*1010,555 ,"17/019",oFont10)
	oPrint:Say  (nLin2*1005,nRow5*555 ,Alltrim(cSubct),oFont10)
Else
	oPrint:Say  (nLin2*1005,nRow5*555 ,aDadosBanco[6],oFont10)
EndIf


oPrint:Say  (nLin2*0970,nRow5*755 ,"Espécie",oFont8)
oPrint:Say  (nLin2*1005,nRow5*805 ,"R$",oFont10)

oPrint:Say  (nLin2*0970,nRow5*1005,"Quantidade",oFont8)
oPrint:Say  (nLin2*0970,nRow5*1485,"Valor"     ,oFont8)

oPrint:Say  (nLin2*0970,nRow5*1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*1005,nRow5*nCol,cString ,oFont11c)

oPrint:Say  (nLin2*1040,nRow5*100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nLin2*1095,nRow5*100 ,aBolText[1] /*/+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       /*/,oFont10)
oPrint:Say  (nLin2*1140,nRow5*100 ,aBolText[2] /*/+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  /*/,oFont10)
oPrint:Say  (nLin2*1195,nRow5*100 ,aBolText[3],oFont10)
oPrint:Say  (nLin2*1240,nRow5*100 ,aBolText[4],oFont10)
oPrint:Say  (nLin2*1295,nRow5*100 ,aBolText[5],oFont10)

oPrint:Say  (nLin2*1040,nRow5*1810,"(-)Desconto/Abatimento",oFont8)
cString := Alltrim(Transform(aDadosTit[9],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*1070,nRow5*nCol,cString ,oFont11c)

oPrint:Say  (nLin2*1105,nRow5*1810,"(-)Outras Deduções"    ,oFont8)
oPrint:Say  (nLin2*1175,nRow5*1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nLin2*1245,nRow5*1810,"(+)Outros Acréscimos"  ,oFont8)
cString := Alltrim(Transform(aDadosTit[10],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*1275,nRow5*nCol,cString ,oFont11c)

oPrint:Say  (nLin2*1310,nRow5*1810,"(=)Valor Cobrado"      ,oFont8)
cString := Alltrim(Transform(((aDadosTit[5]+aDadosTit[10])-aDadosTit[9]),"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*1340,nRow5*nCol,cString,oFont11c)

oPrint:Say  (nLin2*1390,nRow5*100 ,"Sacado",oFont8)
oPrint:Say  (nLin2*1420,nRow5*400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)
oPrint:Say  (nLin2*1470,nRow5*400 ,aDatSacado[3],oFont10)
oPrint:Say  (nLin2*1510,nRow5*400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nLin2*1560,nRow5*400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nLin2*1560,nRow5*400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

If aDadosBanco[1] == "409"
	oPrint:Say  (nLin2*1560,nRow5*1850,aDadosTit[6],oFont10)
Else
	oPrint:Say  (nLin2*1560,nRow5*1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4,10)  ,oFont10)
EndIf

oPrint:Say  (nLin2*1600,nRow5*100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nLin2*1600,nRow5*1500,"Autenticação Mecânica",oFont8)

oPrint:Line (nRow2*0710,nRow2*1800,nRow2*1400,nRow2*1800 ) 
oPrint:Line (nRow2*1120,nRow2*1800,nRow2*1120,nRow2*2300 )
oPrint:Line (nRow2*1190,nRow2*1800,nRow2*1190,nRow2*2300 )
oPrint:Line (nRow2*1260,nRow2*1800,nRow2*1260,nRow2*2300 )
oPrint:Line (nRow2*1330,nRow2*1800,nRow2*1330,nRow2*2300 )
oPrint:Line (nRow2*1400,nRow2*100 ,nRow2*1400,nRow2*2300 )
oPrint:Line (nRow2*1640,nRow2*100 ,nRow2*1640,nRow2*2300 )


/******************/
/* TERCEIRA PARTE */                                         

/******************/

//nRow3 := 250
nRow3 := 0.25
 
nLin2 := 0.255

For nI := nRow3*100 to nRow3*2300 step 50
	//oPrint:Line(nRow3*1880, nI, nRow3*1880, nI+30)
	oPrint:Line(nRow3*1880, nI, nRow3*1880, nI+30)
Next nI

oPrint:Line (nRow3*2000,nRow3*100,nRow3*2000,nRow3*2300)
oPrint:Line (nRow3*2000,nRow3*500,nRow3*1920, nRow3*500)
oPrint:Line (nRow3*2000,nRow3*710,nRow3*1920, nRow3*710)

If aDadosBanco[1] == "001"
	oPrint:Say  (nLin2*1934,nRow3*100,aDadosBanco[2],oFont11 )	// 	[2]Nome do Banco
Else
	oPrint:Say  (nLin2*1934,nRow3*100,aDadosBanco[2],oFont13 )	// 	[2]Nome do Banco
EndIf

If aDadosBanco[1] == "341"
 oPrint:Say  (nLin2*1930,nRow3*513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "409"
 oPrint:Say  (nLin2*1930,nRow3*513,aDadosBanco[1]+"-0",oFont21 )	// 	[1]Numero do Banco
ElseIf aDadosBanco[1] == "237"                 
 oPrint:Say  (nLin2*1930,nRow3*513,aDadosBanco[1]+"-2",oFont21 )	// 	[1]Numero do Banco
Else
 oPrint:Say  (nLin2*1930,nRow3*513,aDadosBanco[1]+"-9",oFont21 )	// 	[1]Numero do Banco
EndIf


oPrint:Say  (nLin2*1940,nRow3*755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3*2100,nRow3*100,nRow3*2100,nRow3*2300 )
oPrint:Line (nRow3*2200,nRow3*100,nRow3*2200,nRow3*2300 )
oPrint:Line (nRow3*2270,nRow3*100,nRow3*2270,nRow3*2300 )
oPrint:Line (nRow3*2340,nRow3*100,nRow3*2340,nRow3*2300 )

oPrint:Line (nRow3*2200,nRow3*500 ,nRow3*2340,nRow3*500 )
oPrint:Line (nRow3*2270,nRow3*750 ,nRow3*2340,nRow3*750 )
oPrint:Line (nRow3*2200,nRow3*1000,nRow3*2340,nRow3*1000)
oPrint:Line (nRow3*2200,nRow3*1300,nRow3*2270,nRow3*1300)
oPrint:Line (nRow3*2200,nRow3*1480,nRow3*2340,nRow3*1480)

oPrint:Say  (nLin2*1995,nRow3*100 ,"Local de Pagamento",oFont8)
If aDadosBanco[1] == "237"
	oPrint:Say  (nLin2*2015,nRow3*400 ,"Pagável preferencialmente nas agencias do Bradesco.",oFont10)
Else
	oPrint:Say  (nLin2*2015,nRow3*400 ,"Pagável em qualquer Banco até o vencimento.",oFont10)
EndIf
oPrint:Say  (nLin2*2055,nRow3*400 ," ",oFont10)
           
oPrint:Say  (nLin2*1995,nRow3*1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2040,nRow3*nCol,cString,oFont11c)

oPrint:Say  (nLin2*2095,nRow3*100 ,"Cedente",oFont8)
oPrint:Say  (nLin2*2140,nRow3*100 ,aDadosEmp[1]+"                  - "+aDadosEmp[2]	,oFont10) //Nome + CNPJ

oPrint:Say  (nLin2*2095,nRow3*1810,"Agência/Código Cedente",oFont8)
If aDadosBanco[1] $ "001/237"
	cString := Alltrim(aDadosBanco[3]+"-"+aDadosBanco[7]+" / "+aDadosBanco[4]+"-"+aDadosBanco[5])
Else
	cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
EndIf
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2140,nRow3*nCol,cString ,oFont11c)


oPrint:Say  (nLin2*2190,nRow3*100 ,"Data do Documento",oFont8)
oPrint:Say (nLin2*2225,nRow3*100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nLin2*2190,nRow3*505 ,"Nro.Documento",oFont8)
oPrint:Say  (nLin2*2225,nRow3*605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nLin2*2190,nRow3*1005,"Espécie Doc.",oFont8)
If aDadosBanco[1] $ "001/237"
	oPrint:Say  (nLin2*2225,nRow3*1050,"DM",oFont10) //Tipo do Titulo
Else
	oPrint:Say  (nLin2*2225,nRow3*1050,aDadosTit[8],oFont10) //Tipo do Titulo
EndIf


oPrint:Say  (nLin2*2190,nRow3*1305,"Aceite",oFont8)
oPrint:Say  (nLin2*2225,nRow3*1400,"N"     ,oFont10)

oPrint:Say  (nLin2*2190,nRow3*1485,"Data do Processamento",oFont8)
oPrint:Say  (nLin2*2225,nRow3*1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nLin2*2190,nRow3*1810,"Nosso Número",oFont8)

If aDadosBanco[1] == "001"
	cString := Alltrim(aCB_RN_NN[3])
Else
	cString := Alltrim(aDadosTit[6])
EndIf
	
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2225,nRow3*nCol,cString,oFont11c)


oPrint:Say  (nLin2*2260,nRow3*100 ,"Uso do Banco",oFont8)

oPrint:Say  (nLin2*2260,nRow3*505 ,"Carteira",oFont8)
If aDadosBanco[1] == "001"
	oPrint:Say  (nLin2*2290,nRow3*555 ,Alltrim(cSubct),oFont10)
Else
	oPrint:Say  (nLin2*2290,nRow3*555 ,aDadosBanco[6],oFont10)
EndIf

oPrint:Say  (nLin2*2260,nRow3*755 ,"Espécie",oFont8)
oPrint:Say  (nLin2*2290,nRow3*805 ,"R$"     ,oFont10)

oPrint:Say  (nLin2*2260,nRow3*1005,"Quantidade",oFont8)
oPrint:Say  (nLin2*2260,nRow3*1485,"Valor"     ,oFont8)

oPrint:Say  (nLin2*2260,nRow3*1810,"Valor do Documento",oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2290,nRow3*nCol,cString,oFont11c)

oPrint:Say  (nLin2*2330,nRow3*100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nLin2*2380,nRow3*100 ,aBolText[1] /*/+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))      /*/,oFont10)
oPrint:Say  (nLin2*2430,nRow3*100 ,aBolText[2] /*/+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  /*/,oFont10)
oPrint:Say  (nLin2*2480,nRow3*100 ,aBolText[3],oFont10)
oPrint:Say  (nLin2*2530,nRow3*100 ,aBolText[4],oFont10)
//oPrint:Say  (nRow3*2590,100 ,aBolText[5],oFont10)

oPrint:Say  (nLin2*2330,nRow3*1810,"(-)Desconto/Abatimento",oFont8)
cString := Alltrim(Transform(aDadosTit[9],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2360,nRow3*nCol,cString,oFont11c)

oPrint:Say  (nLin2*2400,nRow3*1810,"(-)Outras Deduções"    ,oFont8)
oPrint:Say  (nLin2*2470,nRow3*1810,"(+)Mora/Multa"         ,oFont8)
oPrint:Say  (nLin2*2540,nRow3*1810,"(+)Outros Acréscimos"  ,oFont8)
cString := Alltrim(Transform(aDadosTit[10],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2570,nRow3*nCol,cString,oFont11c)

oPrint:Say  (nLin2*2605,nRow3*1810,"(=)Valor Cobrado"      ,oFont8)
cString := Alltrim(Transform(((aDadosTit[5]+aDadosTit[10])-aDadosTit[9]),"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nLin2*2636,nRow3*nCol,cString,oFont11c)

oPrint:Say  (nLin2*2675,nRow3*100 ,"Sacado",oFont8)
oPrint:Say  (nLin2*2690,nRow3*400 ,LEFT(aDatSacado[1],45)+" ("+aDatSacado[2]+")",oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nLin2*2690,nRow3*1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nLin2*2690,nRow3*1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nLin2*2740,nRow3*400 ,aDatSacado[3],oFont10)
oPrint:Say  (nLin2*2780,nRow3*400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

If aDadosBanco[1] == "409"
	oPrint:Say  (nLin2*2780,nRow3*1750,aDadosTit[6] ,oFont10)
Else
	oPrint:Say  (nLin2*2780,nRow3*1850,Substr(aDadosTit[6],1,3)+" "+Substr(aDadosTit[6],4)  ,oFont10)
EndIf

oPrint:Say  (nLin2*2820,nRow3*100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nLin2*2820,nRow3*1500,"Autenticação Mecânica - Ficha de Compensação",oFont8)
                             
oPrint:Line (nRow3*2000,nRow3*1800,nRow3*2690,nRow3*1800)
oPrint:Line (nRow3*2410,nRow3*1800,nRow3*2410,nRow3*2300)
oPrint:Line (nRow3*2480,nRow3*1800,nRow3*2480,nRow3*2300)
oPrint:Line (nRow3*2550,nRow3*1800,nRow3*2550,nRow3*2300)
oPrint:Line (nRow3*2620,nRow3*1800,nRow3*2620,nRow3*2300)
oPrint:Line (nRow3*2690,nRow3*100 ,nRow3*2690,nRow3*2300)
oPrint:Line (nRow3*2850,nRow3*100 ,nRow3*2850,nRow3*2300)

/*--------------------------------------------------------------------------------\
| foi feita uma alteração por Fabio Sales no 2º parâmetro da função MSBAR         |
| de 26.5 para 25.5 para ajuste de impressão do código de barra. Data-->14/112011 |
\--------------------------------------------------------------------------------*/
 
// MSBAR("INT25",25.5,1.5,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
oPrint:Code128c(815,030,aCB_RN_NN[1],550)
 
oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³                       ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Del Valle                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Modulo10(cData)
Local L,D,P := 0
Local B     := .F.

L := Len(cData)  //TAMANHO DE BYTES DO CARACTER
B := .T.   
D := 0     //DIGITO VERIFICADOR
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
±±³Programa  ³ Modulo11 ³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData,cBanc)
Local L, D, P := 0  

If cBanc == "001"  // Banco do brasil
   L := Len(cdata)
   D := 0
   P := 10
   While L > 0 
      P := P - 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 2 
         P := 10
      End
      L := L - 1
   End
   D := mod(D,11)
   If D == 10
      D := "X"
   Else
      D := AllTrim(Str(D))
   End           
ElseIf cBanc == "341" .Or. cBanc == "453" .Or. cBanc == "399" .or. cBanc == "422" // Itau/Mercantil/Rural/HSBC/Safra
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
   
   If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422")
      D := 1
   End
   If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453" .Or. cBanc == "399")
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "237"// Bradesco Calculo do Modulo11 base 7
   L := Len(cdata)
   D := 0
   P := 2
   
   While L > 0 
   	  D := D + Val(SubStr(cdata, L, 1)) * P
      P := P + 1
      L := L - 1
   		IF P = 8
   			P:= 2
   		End
   End
      
   If mod(D,11) = 0
   	D := str(0)
   Else
   	D := str(11 - (mod(D,11)))
   End 
   
   If D = str(10)
   	D := "P"  
   End
   
   D := AllTrim(D)
   
ElseIf cBanc == "389" //Mercantil
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
   D := mod(D,11)
   If D == 1 .Or. D == 0
      D := 0
   Else
	   D := 11 - D
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "479"  //BOSTON
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
   D := Mod(D*10,11)
   If D == 10
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "409"  //UNIBANCO
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
   D := Mod(D*10,11)
   If D == 10 .or. D == 0
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "356"  //Real
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
   D := Mod(D*10,11)
   If D == 10 .or. D == 0
      D := 0
   End
   D := AllTrim(Str(D))
Else
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
   If (D == 10 .Or. D == 11)
      D := 1
   End
   D := AllTrim(Str(D))
Endif   

Return(D)   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³                       ³ Data ³ 29/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta,_NSOMA,_NDVCALC,_NmULT,_CNOSSONUM,_LGEROU,_AAREA)

//Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,4)),4)
//Local cNumSeq := strzero(val(cSequencial),5)
//Local cNumSeq := strzero(val(SubStr(cNroDoc,1,7)),7)
//Local bldocnufinal := strzero(val(cNroDoc),9)

Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,6)),6)
Local cNumSeq := strzero(val(Right(cSequencial,5)),5)
Local blvalorfinal := strzero((nValor*100),10)
Local cNNumSDig := cCpoLivre := cCBSemDig := cCodBarra := cNNum := cFatVenc := ''
Local cNossoNum
Local _cDigito := ""
Local _cSuperDig := ""                                   
Local cCarteira := Right(Alltrim(cCarteira),3)

_cParcela := NumParcela(_cParcela)

//Fator Vencimento - POSICAO DE 06 A 09
cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

//Campo Livre (Definir campo livre com cada banco)

If Substr(cBanco,1,3) == "001"  // Banco do brasil
	If Len(AllTrim(cConvenio)) == 7
		//Nosso Numero sem digito
		cNNumSDig := AllTrim(cConvenio)+strzero(val(cSequencial),10)
		//Nosso Numero com digito
		cNNum := cNNumSDig

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig

//		cCpoLivre := "000000"+cNNumSDig+AllTrim(cConvenio)+strzero(val(cSequencial),10)+ cCarteira
		cCpoLivre := "000000"+cNNumSDig+cCarteira
	Else
		//Nosso Numero sem digito
		cNNumSDig := cCodEmp+cNumSeq	 
		//Nosso Numero com digito
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cNNumSDig+cAgencia + StrZero(Val(cConta),8) + cCarteira
	Endif

   
Elseif Substr(cBanco,1,3) == "389" // Banco mercantil
	//Nosso Numero sem digito
	cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
	//Nosso Numero
	cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))

	cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")

//Elseif Substr(cBanco,1,3) == "237" // Banco bradesco
	//Nosso Numero sem digito
 //	cNNumSDig := cCarteira + bldocnufinal
	//Nosso Numero
//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	//Nosso Numero para impressao
//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )

//	cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"       

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Composicao do Campo Livre (25 posições)                              ³
	//³                                                                     ³
	//³20 a 23 - (04) - Agencia cedente (sem o digito), completar com zeros ³
	//³                 a esquerda se necessario	                        ³
	//³24 a 25 - (02) - Carteira                                            ³
	//³26 a 36 - (11) - Nosso Numero (sem o digito verificador)             ³
	//³37 a 43 - (07) - Conta do cedente, sem o digito verificador, complete³
	//³                 com zeros a esquerda, se necessario                 ³
	//³44 a 44 - (01) - Fixo "0"                                            ³
	//³                                                                     ³
	//³Composicao do Nosso Número                                           ³
	//³01 a 02 - (02) - Número da Carteira (SEE->EE_SUBCTA)                 ³
	//³                 06 para Sem Registro 19 para Com Registro           ³
	//³03 a 13 - (11) - Nosso Número (SEE->EE_FAXATU)                       ³
	//³04 a 14 - (01) - Dígito do Nosso Número (Modulo 11)                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Elseif Substr(cBanco,1,3) == "237" // Banco bradesco
    
	cNrDoc := strzero(val(Right(cSequencial,11)),11)
	
	//Nosso Numero sem digito
	cNNumSDig := Right(cCarteira,2) + cNrDoc
	
	//Nosso Numero
	//cNNum := cNNumSDig + AllTrim( Str( modulo11( cNNumSDig ) ) )
	cNNum := cNNumSDig + AllTrim( modulo11( cNNumSDig ) )
	
	//Nosso Numero para impressao
	//cNossoNum := cCarteira + '/' + Substr(cNrDoc,1,2)+"/"+Substr(cNrDoc,3,9) + '-' + AllTrim( Str( modulo11( cNNumSDig ) ) )
	cNossoNum := Right(cCarteira,2) + '/'+ Right(cNrDoc,11) + '-' + AllTrim( modulo11( cNNumSDig,"237" ) )

	cCpoLivre := cAgencia + Right(cCarteira,2) + cNrDoc + StrZero(Val(cConta),7) + "0"       
    
    //cCpoLivre := strzero(val(substr(cAgencia,1,3)),4) + Right(cCarteira,2) + substr(digv,3,11) + StrZero(Val(cConta),7) + "0"       

Elseif Substr(cBanco,1,3)$("341")  // Banco Itau
	//Nosso Numero sem digito
	cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela
	//Nosso Numero
	cNNum := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )

	cCpoLivre := cNNumSDig+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) ) ) )+"000"

Elseif Substr(cBanco,1,3) == "453"  // Banco rural
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),7)
	//Nosso Numero
	cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )

	cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"

Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC
	//Nosso Numero sem digito
	cNNumSDig := StrZero(Val(SubStr(cConvenio,1,5)),5)+strzero(val(cSequencial),5)
	//Nosso Numero
	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

	cCpoLivre := cNNum+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+"001"

Elseif Substr(cBanco,1,3) == "422"  // Banco Safra
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	//Nosso Numero
	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

	cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10)+cNNum+"2"

Elseif Substr(cBanco,1,3) == "479" // Banco Boston
	cNumSeq := strzero(val(cSequencial),8)            
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)  	 
	//Nosso Numero
	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

	cCpoLivre := cCodEmp+"000000"+cNNum+"8"
	
Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO
	cNumSeq := strzero(val(cSequencial),10)            
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)  	 
	//Nosso Numero
	_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//Calculo do super digito
	_cSuperDig := modulo11("1"+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := "1"+cNNumSDig + _cDigito + _cSuperDig
	//Nosso Numero para impressao
	cNossoNum := "1/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig
	// O codigo fixo "04" e para a combranco som registro
	cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig
	
Elseif Substr(cBanco,1,3) == "356" // Banco REAL
	cNumSeq := strzero(val(cNumSeq),13)
	//Nosso Numero sem digito
	cNNumSDig := cNumSeq
	//Nosso Numero
	cNNum := cNumSeq
	//Nosso Numero para impressao
	cNossoNum := cNNum
	cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig

	
Endif	

//Dados para Calcular o Dig Verificador Geral
cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
//Codigo de Barras Completo
cCodBarra := cBanco + Modulo11(cCBSemDig) + cFatVenc + blvalorfinal + cCpoLivre

//Digito Verificador do Primeiro Campo                  
cPrCpo := cBanco + SubStr(cCodBarra,20,5)
cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))

//Digito Verificador do Segundo Campo
cSgCpo := SubStr(cCodBarra,25,10)
cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))

//Digito Verificador do Terceiro Campo
cTrCpo := SubStr(cCodBarra,35,10)
cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))

//Digito Verificador Geral
cDvGeral := SubStr(cCodBarra,5,1)

//Linha Digitavel
cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
cLinDig += " " + cDvGeral              //dig verificador geral
cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo

Return({cCodBarra,cLinDig,cNossoNum})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³NumParcelaº Autor ³                    º Data ³  30/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ajusta a parcela.                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function NumParcela(_cParcela)
Local _cRet := ""
If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
	_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
Else
	_cRet := StrZero(Val(_cParcela),2)
Endif
Return(_cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ VerBco   ³ Autor ³                       ³ Data ³  Abr/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica informacoes de banco.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VerBco(cBanco)

Local cAg		:= " "
Local cCta		:= " "
Local cSubCta 	:= " "
Local cQuery	:= " "

//Se existir mais de uma conta do mesmo banco que seja com registro, sera considerado o primeiro registro
cQuery := "SELECT A6_AGENCIA AGENCIA,A6_NUMCON CONTA,A6_XCODCTA SUBCTA "
cQuery += " FROM "+RetSqlName("SA6")+" SA6 "
cQuery += " WHERE A6_FILIAL = '"+xFilial("SA6")+"' "
cQuery += " AND A6_COD = '"+cBanco+"' "
cQuery += " AND A6_XCART = '1' " //Somente banco com registro
cQuery += " AND SA6.D_E_L_E_T_ <> '*' "

U_MONTAQRY(cQuery,"TRB")

If Select("TRB") > 0

	cAg		:= Alltrim(TRB->AGENCIA)
	cCta	:= Alltrim(TRB->CONTA)
	cSubCta := Alltrim(TRB->SUBCTA)
	
	DbSelectArea("TRB")
	DbCloseArea("TRB")
EndIf

Return({cAg,cCta,cSubCta}) 
  
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
cQry	+= " AND SE1.E1_SALDO > 0"

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