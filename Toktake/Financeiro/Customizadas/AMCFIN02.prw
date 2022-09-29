#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º AMCFIN02  º AUTOR º                    º DATA º AGOSTO/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º DESCRICAO    º PROGRAMA ESPECIFICO PARA REEMISSAO DA IMPRESSAO DO          º±±
±±º              º BOLETO DE COBRANCA DO BANCO ITAU, EM FORMATO GRAFICO A SER  º±±
±±º              º EMITIDO JUNTAMENTE COM A NOTA FISCAL FATURA OU CUPOM FISCAL º±±
±±º              º DESDE QUE A FORMA DE PAGAMENTO ASSIM O JUSTIFIQUE.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ¹±±
±±º TABS.UTILIZ  º DESCRICAO                                          º ACESSO º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍ¹±±
±±º   SA1010     º CADASTRO DE CLIENTES                               º READ   º±±
±±º   SA6010     º CADASTRO DE BANCOS                                 º READ   º±±
±±º   SE1010     º CONTAS A RECEBER                                   º WRITE  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¹±±
±±º HISTORICO    º (AGO/2005) ELABORACAO DE PROGRAMA INICIAL - ALEX (REV. 00)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º USO          º ESPECIFICO  - CONTROLE DE LOJAS/FINANCEIRO.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROPRIETARIO º CUSTOMIZADO PARA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function AMCFIN02()

//
LOCAL   nOpc := 0
PRIVATE Exec    := .F.  
PRIVATE _nTxper := GETMV("MV_XTAXA")
PRIVATE _nMulta := GETMV("MV_XMULTA")

If cEmpAnt <> "10"
	Return
EndIf


//
cPerg     :="PFIR09"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ValidPerg()
//
If !Pergunte(cPerg,.T.)
	Return()
EndIf
//
CRIA_MV()
//
PRIVATE nCB1Linha	:= GETMV("PV_BOL_LI1") //14.5
PRIVATE nCB2Linha	:= GETMV("PV_BOL_LI2") //26.1
Private nCBColuna	:= GETMV("PV_BOL_COL") //1.3
Private nCBLargura	:= GETMV("PV_BOL_LAR") //0.0280
Private nCBAltura	:= GETMV("PV_BOL_ALT") //1.4
//
DbselectArea("SE1")
DbSetOrder(1)
//
Processa({|lEnd|MontaRel()})
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaRel()   ³Descri‡ão³Montagem e Impressao de boleto Gra- ³±±
±±³          ³             ³         ³fico do Banco Itau.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\SIGAADV\ITAU.BMP"

LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
							SM0->M0_ENDCOB                                                              ,; //[2]Endereço
							AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
							"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
							"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
							"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
							Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
							Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
							"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]I.E 
							Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         ,; 
							Alltrim(XX8->XX8_DESCRI)												}  //[8]Nome Filial
							

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"",;
						"Após o vencimento cobrar Mora Diaria de R$",;  //"Após Vencimento Aplicar Mora de "+cvaltochar(_nTxper)+"% a.m" - Alterado por Ronaldo Gomes - 17/03/2017                                  ,;
						"Após Vencimento Aplicar Multa de 2% - R$",; //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"} - Alterado por Ronaldo Gomes - 17/03/2017
						GetMV("MV_XMSGBL1"),;
						GetMV("MV_XMSGBL2")}
                           //Ajustar, trocar para mv_par     aqui
// "Após o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ""
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.

//oPrint:= TMSPrinter():New( "Boleto Itaú" )

oPrint 	:= FWMSPrinter():New("Boleto_"+strzero(VAL(MV_PAR02),9)+".rel",  IMP_PDF, lAdjustToLegacy, "\", lDisableSetup,,,,.F.,,,.T.)

oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:StartPage()   	// Inicia uma nova página
oPrint:SetMargin(60,60,60,60)
//oPrint:cPathPDF := "C:\Temp" //"\_AMC\Nota_Debito\"

//
DBSEEK(xFilial("SE1")+MV_PAR01+MV_PAR02)
//
Do While !EOF() .and. E1_PREFIXO+E1_NUM == MV_PAR01+MV_PAR02
	//
	If E1_PARCELA < MV_PAR03
		DBSKIP()
		LOOP
	ENDIF
	//
	If E1_PARCELA > MV_PAR04
		DBSKIP()
		LOOP
	ENDIF
	//
	IF E1_SALDO <= 0
		DBSKIP()
		LOOP
	ENDIF
	//
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	//
	DO CASE
		CASE SE1->E1_PARCELA == "A"
			cParcela := "1"
		CASE SE1->E1_PARCELA == "B"
			cParcela := "2"
		CASE SE1->E1_PARCELA == "C"
			cParcela := "3"
		CASE SE1->E1_PARCELA == "D"
			cParcela := "4"
		CASE SE1->E1_PARCELA == "E"
			cParcela := "5"
		CASE SE1->E1_PARCELA == "F"
			cParcela := "6"
		CASE SE1->E1_PARCELA == "G"
			cParcela := "7"
		CASE SE1->E1_PARCELA == "H"
			cParcela := "8"
		CASE SE1->E1_PARCELA == "I"
			cParcela := "9"
		OTHERWISE
			cParcela := "0"
	ENDCASE
	//
	//	_cNossoNum := cFilant + substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5) + cParcela //Composicao Filial + Titulo + Parcela

	If Alltrim(SUBSTR(SE1->E1_PREFIXO,3,1)) $ "D"
			_cNossoNum := Substr(cFilant,2,1)+"4"+substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5)+cParcela //Composicao Somente para Serie D + + Titulo + Parcela	
	Else			
			_cNossoNum := Substr(cFilant,2,1)+Substr(SE1->E1_PREFIXO,3,1)+substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5)+cParcela //Composicao Filial Posição 2+Prefixo Posição 3+ Titulo + Parcela
	Endif

	//
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	//
	DbSelectArea("SE1")
	//
/*	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Itaú S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Agência
						"13614          "				,; // [4]Conta Corrente
						"1"  					,; // [5]Dígito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */
						
if cfilant == "01"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Itaú S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Agência
						"13614          "				,; // [4]Conta Corrente
						"1"  					,; // [5]Dígito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */

Elseif cfilant == "03"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Itaú S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Agência
						"13979          "				,; // [4]Conta Corrente
						"8"  					,; // [5]Dígito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */

Elseif cfilant == "04"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Itaú S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Agência
						"14036          "				,; // [4]Conta Corrente
						"6"  					,; // [5]Dígito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */    
    
Elseif cfilant == "02"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Itaú S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Agência
						"14157          "				,; // [4]Conta Corrente
						"0"  					,; // [5]Dígito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */ 

Endif								
						
						
	//
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endereço
		AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
		SA1->A1_EST                                       ,;     // [5]Estado
		SA1->A1_CEP                                       ,;     // [6]CEP
		SA1->A1_CGC									  ,;       // [7]CGC
		SA1->A1_INSCR									}		//[8]IE
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		SA1->A1_CEPC                                         ,;   // [6]CEP
		SA1->A1_CGC										    ,;   // [7]CGC
		SA1->A1_INSCR										}	// [8]IE
	Endif
	
	//If aMarked[i]
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(E1_VALOR-_nVlrAbat),Datavalida(E1_VENCTO,.T.))
	
	aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)						,;  // [1] Número do título
						E1_EMISSAO                              					,;  // [2] Data da emissão do título
						Date()                                  					,;  // [3] Data da emissão do boleto
						Datavalida(E1_VENCTO,.T.)                  					,;  // [4] Data do vencimento
						(E1_SALDO - _nVlrAbat)                  					,;  // [5] Valor do título                       
						CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                               					,;  // [7] Prefixo da NF
						E1_TIPO	                               						}  // [8] Tipo do Titulo
	//
	Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	n := n + 1
	//EndIf
	
	dbSkip()
	IncProc()
	i := i + 1
EndDo
//            

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Impress      ³Descri‡ão³Impressao de Boleto Grafico do Banco³±±
±±³          ³             ³         ³Itau.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
LOCAL oBrush       
Local nlinha   := 0
Local ncoluna  := 0
//
aBmp2	:= "\SYSTEM\logoamc.bmp"
aBmp 	:= "\SYSTEM\ITAU_LOGO.BMP"
//
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont5  := TFont():New("Arial",9,5 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7  := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9I := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9N := TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12n:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
//     

oFont9I:Italic := .T.
oBrush := TBrush():New("",5)//4
//
//oPrint:StartPage()   // Inicia uma nova página
//
oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
//
// LOGOTIPO
If File(aBmp2)
	oPrint:SayBitmap( 0000,0020,aBmp2,110,060 )
	oPrint:Say(0070,0020,'www.amaquinadecafe.com.br',oFont10 )	// [2]Nome do Banco
	oPrint:Say(0080,0090,'(11) 3622-2400',oFont9)
EndIf   

oPrint:Box(000,180,0120,650, "-2")   //Cabeçalho
oPrint:Line(000,415,0120,415)          

oPrint:Line (015,180,015,650 )  //1
oPrint:Line (030,180,030,650 )  //2
oPrint:Line (045,180,045,650 )  //3
oPrint:Line (060,180,060,650 )  //4
oPrint:Line (075,415,075,650 )  //5
oPrint:Line (090,180,090,650 )  //6
oPrint:Line (105,180,105,650 )  //7
  
oPrint:Say(005,0181,'Beneficiário'							,oFont5)
oPrint:Say(013,0183,aDadosEmp[1]							,oFont8)

oPrint:Say(005,0416,'Vencimento'							,oFont5)
oPrint:Say(013,0580,DTOC(aDadosTit[4])                      ,oFont8)

oPrint:Say(020,0181,'Data do Documento'						,oFont5)
oPrint:Say(028,0183,DTOC(aDadosTit[2])						,oFont7)

oPrint:Say(020,0416,'Nosso Número'							,oFont5)
oPrint:Say(028,0530,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont8)

oPrint:Say(035,0181,'Nº do documento'						,oFont5)
oPrint:Say(043,0183 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont8) //Prefixo +Numero+Parcela

oPrint:Say(035,0416,'(=) Valor do documento'				,oFont5)
oPrint:Say(043,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont9N)
         
//oPrint:Say(050,0181,''						,oFont5)
oPrint:Say(050,0416,'(-) Desconto'							,oFont5)           

oPrint:Say(065,0416,'(-) Outras Deduções/Abatimento'		,oFont5)
oPrint:Say(067,0265,'Para agilizar o atendimento'			,oFont7)

oPrint:Say(080,0416,'(+) Mora/Multa/Juros'					,oFont5)
oPrint:Say(077,0247,'informe o seu código de cliente abaixo:',oFont7)

oPrint:Say(095,0416,'(+) Outros Acréscimos'					,oFont5)  
oPrint:Say(087,0278,aDatSacado[2]							,oFont8)  

oPrint:Say(110,0416,'(=) Valor Cobrado'						,oFont5)


//  *************************     RECIBO DO PAGADOR     *********************

oPrint:Line (0146,043,0130,043)  //linha que separa o logo do nome do banco
oPrint:Line (0146,125,0130,125)  //linha que separa o nome do banco do numero 341
oPrint:Line (0146,225,0130,225) // linha que separa 341 do codigo de barras

//Caixa parte pagador do boleto        
oPrint:Box(0146,010,0350,650, "-4")   //Cabeçalho

// LOGOTIPO  
If File(aBmp)
	oPrint:SayBitmap( 0113,011,aBmp,030,030 )
	oPrint:Say  (0142,045,"Banco Itaú SA",oFont14n )	// [2]Nome do Banco
Else
	oPrint:Say  (0444,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0142,130,"341-7",oFont16N )	// [1]Numero do Banco
oPrint:Say  (0142,510,"RECIBO DE PAGADOR",oFont12n)		//Linha Digitavel do Codigo de Barras   1934 CB_RN_NN[2]
//
oPrint:Line (0168,10,0168,650 )  //linha Vencimento
oPrint:Line (0190,10,0190,650 )  //linha beneficiario
oPrint:Line (0212,10,0212,650 )	 //linha data documento
oPrint:Line (0234,10,0234,650 )	 //linha uso do banco
oPrint:Line (0300,10,0300,650 )	 //linha instruções

oPrint:Line (0256,510,0256,650 )	 //linha desconto
oPrint:Line (0278,510,0278,650 )	 //linha multa

oPrint:Line (0146,510,0300,510) //linha que separa do vencimento ate inscr estadual
oPrint:Line (0190,090,0234,090) //linha que separa data do documento do numero
oPrint:Line (0190,255,0234,255) //linha que separa numero do documento da especie
oPrint:Line (0190,335,0234,335) //linha que separa especie do aceite
oPrint:Line (0190,395,0212,395) //linha que separa aceite da data do processamento
oPrint:Line (0212,425,0234,425) //linha que separa quantidade do valor

// ****************************  
//
oPrint:Say  (0153,512 ,"Vencimento" 		                         ,oFont9)
oPrint:Say  (0166,590,DTOC(aDadosTit[4])                             ,oFont10)

oPrint:Say  (0153,014 ,"Local de Pagamento"	                         ,oFont9)
oPrint:Say  (0164,014 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ" ,oFont11n)

oPrint:Say  (0177,014 ,"Beneficiário"			   					 ,oFont9)
oPrint:Say  (0188,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0177,512 ,"Agência/Código Beneficiário"				 ,oFont9)
oPrint:Say  (0188,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0199,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0210,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0199,092 ,"Nº do Documento"							 ,oFont9)
oPrint:Say  (0210,092 ,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0199,257 ,"Espécie Doc"								 ,oFont9)
oPrint:Say  (0210,258,aDadosTit[8]									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0199,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0210,0357,"N"                                           ,oFont10)

oPrint:Say  (0199,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0210,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0199,512 ,"Nosso Número"								 ,oFont9)
oPrint:Say  (0210,0580,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (0221,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0221,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0232,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0221,257 ,"Espécie"				   					 ,oFont9)
oPrint:Say  (0232,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0221,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0221,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0221,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0232,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
                                
oPrint:Say  (0243,014 ,"Instruções: (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)" ,oFont9)
//oPrint:Say  (0255,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10) - Alterado por Ronaldo Gomes - 17/03/2017
oPrint:Say  (0255,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)/30),"@E 99,999.99"))  ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 
//oPrint:Say  (0267,014 ,aBolText[3]                                   ,oFont10) - Alterado por Ronaldo Gomes - 17/03/2017
oPrint:Say  (0267,014 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*_nMulta/100),"@E 99,999.99"))       ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 

nP1 := 279
nCol1 := 1

For nX := 1 to round(len(aBolText[4])/110,0)
	oPrint:Say  (nP1,014 ,substr(aBolText[4],nCol1,110)       ,oFont10) // Incluido por Alexandre - 14/03/2018 
	nCol1 += 110
	nP1 += 12
Next nX



oPrint:Say  (0243,512 ,"(-) Desconto/Abatimento"					 ,oFont9)
oPrint:Say  (0263,512 ,"(+) Mora/Multa"			 					 ,oFont9)
oPrint:Say  (0285,512 ,"(=) Valor Cobrado"		 					 ,oFont9)

oPrint:Say  (0307,015 ,"Pagador"				 					 ,oFont9)
oPrint:Say  (0318,014 ,aDatSacado[1]+" ("+aDatSacado[2]+")"          ,oFont10)
oPrint:Say  (0329,014 ,aDatSacado[3]+" - "+Transform(strzero(val(aDatSacado[6]),8),"@R 99999-999")                     ,oFont10)
oPrint:Say  (0340,014 ,aDatSacado[4]								 ,oFont10)
oPrint:Say  (0340,254 ,aDatSacado[5] 								 ,oFont10)
//CNPJ
if Len(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (0316,510 ,TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oPrint:Say  (0316,510 ,TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif   
//Inscrição estadual
oPrint:Say  (0327,510,aDatSacado[8] ,oFont10)

oPrint:Say  (0348,510 ,"Cód. de Baixa" 						 	     ,oFont9)
                    
oPrint:Say  (0360,450 ,"Autenticação Mecânica" 						 ,oFont9I)
oPrint:Say  (0360,014 ,"Esta quitação só terá validade após o pagamento do cheque pelo banco Pagador.",oFont5)
oPrint:Say  (0365,014 ,"Ate o vencimento pagável em qualquer agência bancária.",oFont5)
// ****************************                

//Separação da nota de debito ou inicio do boleto com a parte destacavel
oPrint:Say  (0390, 020, REPLICATE( '- ', 136 ), oFont9)
//Caixa parte pagador do boleto        
oPrint:Box(0431,010,0698,650, "-4")   //Cabeçalho

// LOGOTIPO  
If File(aBmp)
	oPrint:SayBitmap( 0400,011,aBmp,030,030 )
	oPrint:Say  (0418,045,"Banco Itaú SA",oFont14n )	// [2]Nome do Banco
Else
	oPrint:Say  (0444,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0418,130,"341-7",oFont24 )	// [1]Numero do Banco
oPrint:Say  (0418,230,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//

oPrint:Line (0431,040,0398,040)  //linha que separa o logo do nome do banco
oPrint:Line (0431,125,0398,125)  //linha que separa o nome do banco do numero 341
oPrint:Line (0431,225,0398,225) // linha que separa 341 do codigo de barras

oPrint:Line (0458,10,0458,650 )  //linha Vencimento
oPrint:Line (0480,10,0480,650 )  //linha beneficiario
oPrint:Line (0502,10,0502,650 )	 //linha data documento
oPrint:Line (0524,10,0524,650 )	 //linha uso do banco
oPrint:Line (0634,10,0634,650 )	 //linha instruções

oPrint:Line (0560,510,0560,650 )	 //linha desconto
oPrint:Line (0597,510,0597,650 )	 //linha multa

oPrint:Line (0431,510,0634,510) //linha que separa do vencimento ate inscr estadual
oPrint:Line (0480,090,0524,090) //linha que separa data do documento do numero
oPrint:Line (0480,255,0524,255) //linha que separa numero do documento da especie
oPrint:Line (0480,335,0524,335) //linha que separa especie do aceite
oPrint:Line (0480,395,0502,395) //linha que separa aceite da data do processamento
oPrint:Line (0502,425,0524,425) //linha que separa quantidade do valor

//
oPrint:Say  (0442,512 ,"Vencimento" 		                         ,oFont9)
oPrint:Say  (0456,590,DTOC(aDadosTit[4])                             ,oFont10)

oPrint:Say  (0450,014 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ" ,oFont11n)

oPrint:Say  (0466,014 ,"Beneficiário"			   					 ,oFont9)
oPrint:Say  (0477,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0466,512 ,"Agência/Código Beneficiário"				 ,oFont9)
oPrint:Say  (0477,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0488,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0499,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0488,092 ,"Nº do Documento"							 ,oFont9)
oPrint:Say  (0499,092 ,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0488,257 ,"Espécie Doc"								 ,oFont9)
oPrint:Say  (0499,258,aDadosTit[8]									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0488,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0499,0357,"N"                                           ,oFont10)

oPrint:Say  (0488,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0499,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0488,512 ,"Nosso Número"								 ,oFont9)
oPrint:Say  (0499,0580,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (0514,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0510,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0521,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0510,257 ,"Espécie"				   					 ,oFont9)
oPrint:Say  (0521,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0510,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0510,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0510,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0521,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
                                
oPrint:Say  (0532,014 ,"Instruções: (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)" ,oFont9)
//oPrint:Say  (0546,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10) - Alterado por Ronaldo Gomes - 17/03/2017
oPrint:Say  (0546,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)/30),"@E 99,999.99"))  ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 
//oPrint:Say  (0556,014 ,aBolText[3]                                   ,oFont10)  - Alterado por Ronaldo Gomes - 17/03/2017
oPrint:Say  (0556,014 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*_nMulta/100),"@E 99,999.99"))       ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 


nP1 := 566
nCol1 := 1

For nX := 1 to round(len(aBolText[4])/110,0)
	oPrint:Say  (nP1,014 ,substr(aBolText[4],nCol1,110)       ,oFont10) // Incluido por Alexandre - 14/03/2018 
	nCol1 += 110
	nP1 += 10
Next nX

oPrint:Say  (0532,512 ,"(-) Desconto/Abatimento"					 ,oFont9)
oPrint:Say  (0568,512 ,"(+) Mora/Multa"			 					 ,oFont9)
oPrint:Say  (0605,512 ,"(=) Valor Cobrado"		 					 ,oFont9)

oPrint:Say  (0642,015 ,"Pagador"				 					 ,oFont9)
oPrint:Say  (0653,014 ,aDatSacado[1]+" ("+aDatSacado[2]+")"          ,oFont10)
oPrint:Say  (0665,014 ,aDatSacado[3]+" - "+Transform(strzero(val(aDatSacado[6]),8),"@R 99999-999")+"  -  "+aDatSacado[4]+" - "+aDatSacado[5]                                    ,oFont10)
  
//CNPJ
if Len(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (0653,510 ,TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oPrint:Say  (0653,510 ,TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif   
//Inscrição estadual
oPrint:Say  (0665,510,aDatSacado[8] ,oFont10)

oPrint:Say  (0695,510 ,"Cód. de Baixa" 						 	     ,oFont9)
                    
oPrint:Say  (0740,380 ,"Autenticação Mecânica" 						 ,oFont9I)

oPrint:Say  (0740,510 ,"FICHA DE COMPENSAÇÃO"  						 ,oFont10)


//Codigo de Barras    
oPrint:Code128c(0790, 030, CB_RN_NN[1], 040) 

//Gravar somente o NUMBCO AQUI
DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO :=	Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)   // Nosso número (Ver fórmula para calculo)
/*SE1->E1_PORTADO	:= 	"999"
SE1->E1_AGEDEP 	:=  "999"
SE1->E1_CONTA	:=  "99999-9"*/ 
SE1->E1_CODBAR	:=	CB_RN_NN[2]
//SE1->E1_SITUACA	:=	"0"
MsUnlock()
//
oPrint:EndPage() // Finaliza a página
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
±±³          ³             ³         ³gerando o codigo de barras.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "109" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + Alltrim(cAgencia) + Alltrim(cConta) + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + Alltrim(cConta) + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))
//
Return({CB,RN,NN})
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg   ³Descri‡ão³Verifica o Arquivo Sx1, criando as  ³±±
±±³          ³             ³         ³Perguntas se necessario.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
//
Local J := 0
Local I := 0
PRIVATE APERG := {},AALIASSX1:=GETAREA()
//
//     "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"      			,"X1_PERSPA"				,"X1_PERENG"				,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
//
AADD(APERG,{CPERG  ,"01"		,"Prefixo?"     			,"Prefixo?"    		    	,"Prefixo?"     			,"mv_ch1"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"02"		,"Numero?"         		    ,"Numero?"                  ,"Numero?"          		,"mv_ch2"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"03"		,"Da Parcela?"     			,"Da Parcela?"		    	,"Da Parcela?"		    	,"mv_ch3"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"04"		,"Ate a Parcela?"    		,"Ate a Parcela?"     		,"Ate a Parcela?"     		,"mv_ch4"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
//
DBSELECTAREA("SX1")
DBSETORDER(1)
//
FOR I := 1 TO LEN(APERG)
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO len(APERG[I]) 
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(AALIASSX1)
//
RETURN()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CRIA_MV ³Descri‡…o³ Criacao dos Param.Necessarios no (SX6) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION CRIA_MV()
//
dbSelectArea("SX6")
dbSetOrder(1)
//
If !dbSeek(cFilant+"PV_BOL_LI1")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI1"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "14.5"
	SX6->X6_CONTSPA	:= "14.5"
	SX6->X6_CONTENG	:= "14.5"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LI2")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI2"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "26.1"
	SX6->X6_CONTSPA	:= "26.1"
	SX6->X6_CONTENG	:= "26.1"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_COL")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_COL"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "1.3"
	SX6->X6_CONTSPA	:= "1.3"
	SX6->X6_CONTENG	:= "1.3"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LAR")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LAR"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "0.0280"
	SX6->X6_CONTSPA	:= "0.0280"
	SX6->X6_CONTENG	:= "0.0280"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_ALT")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_ALT"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "1.40"
	SX6->X6_CONTSPA	:= "1.40"
	SX6->X6_CONTENG	:= "1.40"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
return