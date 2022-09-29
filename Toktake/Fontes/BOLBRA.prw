#Include "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³RENATO TAKAO / EVERALDO D. CASAROLI      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressão DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BOLBRA()

Local   aCampos :=	{	{"E1_NOMCLI","Cliente","@!"}	,;
						{"E1_PREFIXO","Prefixo","@!"}	,;
						{"E1_NUM","Titulo","@!"}		,;
						{"E1_PARCELA","Parcela","@!"}	,;
						{"E1_VALOR","Valor","@E 9,999,999.99"},;
						{"E1_VENCTO","Vencimento"},;
						{"E1_NUMBCO","Nosso Número"},;
						{"E1_NUMBOR","Num. Borderô"}	}
Local   nOpc 	:= 	0
Local   aDesc 	:= 	{	"Este programa imprime os boletos de"	,;
						"cobranca bancaria de acordo com"		,;
						"os parâmetros informados"	}

Private Exec    	:= .f.
Private cIndexName 	:= ''
Private cIndexKey  	:= ''
Private cFilter    	:= ''
Private	aRegs 		:= {}
Private _nTxper := GETMV("MV_TXPER") 
Tamanho  :=	"M"
titulo   := "Impressão de Boleto Bradesco"
cDesc1   := "Este programa destina-se a impressão do Boleto Bradesco."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLBRA"
lEnd     := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aReturn  :=	{"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")  

cPerg    :=	"BOLBRA"

AjustaSX1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

nOpc := 1

If nOpc == 1
	    //Posiciona na Arq de Parametros CNAB

	cIndexName := Criatrab(Nil,.F.)
//    cIndexKey  := 	"E1_FILIAL+E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
    cIndexKey  := 	"E1_FILIAL+E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
    cFilter    := 	"E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ;
   					"E1_NUM     >= '" + MV_PAR03 + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. " + ;
					"E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. " + ;
					"E1_NUMBOR  >= '" + MV_PAR07 + "' .And. E1_NUMBOR  <= '" + MV_PAR08 + "' .And. " + ;
					"E1_FILIAL   = '"+xFilial("SE1")+"' .And. E1_SALDO > 0 .And. " + ;
					"SubsTring(E1_TIPO,3,1) != '-' .And. "+;
				    "E1_PORTADO = '237'"
					
					//.And. "+; 

	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SE1")
	#IFNDEF TOP
		DbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()
    
	DbSelectArea("SA6")
	DbSetOrder(1)
	If !DbSeek( xFilial("SA6") + mv_par09+ mv_par10 + mv_par11 )
		Alert("Banco/Agencia/Conta nao encontrado.")
	Return
	Endif

	DbSelectArea("SEE")
	DbSetOrder(1)
	If !DbSeek( xFilial("SEE") + mv_par09+ mv_par10 + mv_par11 + mv_par12 )
		Alert("Arquivo de parametros banco/cnab incorreto. Verifique banco/agencia/conta/sub-conta.")
	Return
	Endif

	If mv_par09 != "237"
  		Alert("Banco invalido. Configuracao valida apenas para Bradesco")
	Return
	Endif
	
	@ 001,001 To 400,700 Dialog oDlg Title "Selecao de Titulos"
	@ 001,001 To 170,350 Browse "SE1" Mark "E1_OK"
	@ 180,310 BmpButton Type 01 Action ( Exec := .t. , Close(oDlg) )
	@ 180,280 BmpButton Type 02 Action ( Exec := .f. , Close(oDlg) )
	Activate Dialog oDlg Centered
		
	If Exec
		Processa( { |lEnd| MontaRel()} )
	Endif

	RetIndex("SE1")

	fErase(cIndexName+OrdBagExt())
	
EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³RENATO TAKAO / EVERALDO D. CASAROLI      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel()

Local oPrint
Local n := 0
LOCAL aBitmap := "LOGOBRAD.BMP"

Local aDadosEmp    := {	SM0->M0_NOMECOM                                    							,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                                            	,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB 	,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             	,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  	,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+	         	 ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       	 ; //[7]
						Subs(SM0->M0_CGC,13,2)                                                    	,; //[8]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            	 ; //[9]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        	}  //[10]I.E
//************** vERIFICAR SE TEM FILIAL E SE O CNPJ DA CONTA E O MESMO DA FILIAL OU SE E DA MATRIZ.
Local aDadosTit
Local aDadosBanco
Local aDatSacado
Local aBolText
Local i         := 1
Local CB_RN_NN  := {}
Local nRec      := 0
Local _nVlrAbat := 0
Local _nTotEnc  := 0

Private _cNossoNum 	:= "0000000"

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

DbSelectArea("SE1")

dbGoTop()

Do While !EOF()
	nRec := nRec + 1
	dbSkip()
EndDo

//nRec := SE1->(RecCount()) //nRec + 1

DbSelectArea("SE1")
dbGoTop()

ProcRegua(nRec)

Do While !EOF()

	If !Marked("E1_OK")
		dbSkip()
		loop	   
	Endif
	
	
	If Empty(SE1->E1_NUMBCO)
    		_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,11)
		RecLock("SEE",.f.)    
			SEE->EE_FAXATU :=_cNossoNum 
		MsUnlock("SEE")
	Else	
    		_cNossoNum := Subs(SE1->E1_NUMBCO,1,11) //Substr(SE1->E1_NUMBCO,5,7)
	Endif

	//Posiciona o SA1 (Cliente)
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.t.))
	
	DbSelectArea("SE1")

	aDadosBanco  := {"237-2"   														   ,; // [1]Numero do Banco
  				 SA6->A6_NOME			   	           	                               ,; // [2]Nome do Banco
				 subs(SA6->A6_AGENCIA, 1, 4)                        				   ,; // [3]Agência
	 			 StrZero(Val(Subs(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1)),7) ,; // [4]Conta Corrente
				 SubsTr(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  			   ,; // [5]Dígito da conta corrente
		  		 IIF(SE1->E1_SITUACA <> "4","09","02")                			       ,; // [6]Codigo da Carteira
				 "6"                                              	}  					  // [7]Digito da Agência
				 
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {	AllTrim(SA1->A1_NOME)                           	,;      // [1]Razão Social
							AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           	,;      // [2]Código
							AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO)	,;      // [3]Endereço
							AllTrim(SA1->A1_MUN )                            	,;      // [4]Cidade
							SA1->A1_EST                                      	,;      // [5]Estado
							SA1->A1_CEP                                      	,;      // [6]CEP
							SA1->A1_CGC										  	}      	// [7]CGC
	Else
		aDatSacado   := {	AllTrim(SA1->A1_NOME)                           	,;      // [1]Razão Social
						 	AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA             	,;      // [2]Código
						 	AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;      // [3]Endereço
						 	AllTrim(SA1->A1_MUNC)	                            ,;      // [4]Cidade
						 	SA1->A1_ESTC	                                    ,;      // [5]Estado
						 	SA1->A1_CEPC                                        ,;      // [6]CEP
                            SA1->A1_CGC										  	}      	// [7]CGC
	Endif                

	_nTotEnc	:= 	SE1->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)		
	_nVlrAbat   := 	_nTotEnc
	//ROUND(_nTxper,2)
//									Codigo Banco           Agencia			C.Corrente     Digito C/C
	CB_RN_NN    := Ret_cBarra( 	Subs(aDadosBanco[1],1,3),;
								aDadosBanco[3],;
								aDadosBanco[4],;
								aDadosBanco[5],;
								aDadosBanco[6],;
								_cNossoNum,(E1_VALOR-_nVlrAbat) )

	aDadosTit    := {""+AllTrim(E1_NUM)                                          ,;//""+AllTrim(E1_PARCELA)				,;  // [1] Número do título
					E1_EMISSAO                              					,;  // [2] Data da emissão do título
					Date()                                  					,;  // [3] Data da emissão do boleto
					E1_VENCTO													,;  // [4] Data do vencimento
					E1_SALDO				                  					,;  // [5] Valor do título
			 		IIF(SE1->E1_SITUACA <> "4","09","02")+"/"+SUBST(CB_RN_NN[3],1,12) ,;  // [6] Nosso número + Carteira (Ver fórmula para calculo)
					E1_PREFIXO		                         					,;  // [7] Prefixo da NF
					E1_TIPO	                               						,;  // [8] Tipo do Titulo	
					E1_IRRF		                               					,;  // [9] IRRF 
					E1_ISS	                             						,;  // [10] ISS 
					E1_INSS 	                               					,;  // [11] INSS 
					E1_PIS                                  					,;  // [12] PIS  
					E1_COFINS                               					,;  // [13] COFINS									
					E1_CSLL                               						,;  // [14] CSLL          	
					_nVlrAbat                               					,;  // [15] Abatimentos 
					Round(((SE1->E1_VALOR * _nTxper)/100),2)						}   // [16] Mora Diaria
             
	aBolText:={}
  /*	IF  E1_VLFIES>0
		AADD(aBolText,"Bolsa de R$ "+alltrim(Transform(E1_VLFIES,"@E 9999,999.99")))	// msg 1
	ENDIF   */                           

	_vMulta:=((E1_SALDO*2.00)/100)   
   //	Round(((SE1->E1_VALOR * 0.33)/100),2)
	_vMora:=Round(((E1_SALDO*_nTxper)/100),2)  // este valor é regravado no pto entrada AC680GRV
	AADD(aBolText,"PARCELA "+ E1_PARCELA) // msg 1
	AADD(aBolText,"Após o vencimento cobrar multa de R$ "+alltrim(Transform(_vMulta,"@E 9999,999.99"))+" e mora de R$ "+alltrim(Transform(_vMora,"@E 9999,999.99"))+" por dia") // msg3
   // _nCreditos:=0
	AADD(aBolText,"Sr. Caixa não receber após 30 dias do vencimento") // msg 3
//	AADD(aBolText,"PARCELA "+ E1_PARCELA) // msg 4
	AADD(aBolText,"O não pagamento desde título acarretará na suspensão do sinal.") // msg 4
	AADD(aBolText,"") // msg 6
	AADD(aBolText,"") // msg 7
	AADD(aBolText,"") // msg 8

	Impress(oPrint,{},aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	n := n + 1

	DbSelectArea("SE1")
	SE1->(dbSkip())

	IncProc()

	i := i + 1
EndDo

oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

//oPrinter:Print()   // Imprime direto na impressora default do AP5

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

Local i 		:=	0
Local aCoords1	:= {0150,1900,0550,2300}
Local aCoords2 	:= {0450,1050,0550,1900}
Local aCoords3 	:= {0710,1900,0810,2300}
Local aCoords4 	:= {0980,1900,1050,2300}
Local aCoords5 	:= {1330,1900,1400,2300}
Local aCoords6 	:= {2000,1900,2100,2300}
Local aCoords7 	:= {2270,1900,2340,2300}
Local aCoords8 	:= {2620,1900,2690,2300}
Local oFont8,oFont10n,oFont10,oFont08n,oFont14,oFont16n,oFont24,oBrush

aBmp := "LOGOBRAD.BMP"

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

oFont2n := TFont():New("Arial",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
oFont08n:= TFont():New("Arial",9,08,.T.,.T.,5,.T.,5,.T.,.F.) // Fonte 08 Normal
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.) //modificado de 16 para 14 JCNS
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

/*
oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
*/
// Inicia aqui a alteracao para novo layout - RAI
oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)              
oPrint:Say  (0084,210,aDadosBanco[2],oFont14 )	// [2]Nome do Banco
oPrint:Say  (0062,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10n) //Nome + CNPJ
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0150,1510,"Nro.Documento               "                   ,oFont8)
oPrint:Say  (0200,1510,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]					                ,oFont8)	//Nome + Codigo
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0300,1060,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)//StrZero(Year(aDadosTit[4]),4)AllTrim(Str(Day(dDataBase),2))+' de '+AllTrim(MesExtenso(dDataBase))+' de '+AllTrim(Str(Year(dDataBase),4)))
//oPrint:Say  (0300,1060,AllTrim((Day(aDadosTit[4]),2))+'/'+AllTrim(Str(Month(aDadosTit[4]),2))+'/'+AllTrim(Str(Year(aDadosTit[4]),4)),oFont10)//
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)
                  
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 050,100,aBmp,0100,0100 )                                          // [2]Nome do Banco
Else
	oPrint:Say  (2214,100,aDadosBanco[2],oFont15n )										// [2]Nome do Banco                     1934
EndIf

oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 ) //---
oPrint:Line (0550, 100,0550,2300 )

oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 ) //--
oPrint:Line (0550,1900,0150,1900 )

oPrint:Say  (0160,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (0200,1910,"(  )Ausente"                                    ,oFont8)
oPrint:Say  (0240,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0280,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (0320,1910,"(  )Não procurado"                              ,oFont8)
oPrint:Say  (0360,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0400,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (0440,1910,"(  )Falecido"                                   ,oFont8)
oPrint:Say  (0480,1910,"(  )Outros(anotar no verso)"                  	,oFont8)

For i := 100 to 2300 step 50
	oPrint:Line( 0600, i, 0600, i+30)
Next i

oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)              
If File(aBmp)
	oPrint:SayBitmap(0610,100,aBmp,0100,0100 )                                          // [2]Nome do Banco
Else
	oPrint:Say  (0622,100,aDadosBanco[2],oFont15n )										// [2]Nome do Banco                     1934
EndIf                                       	// [2]Nome do Banco
oPrint:Say  (0622,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (0644,1900,"Recibo do Sacado",oFont10)
oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )

oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)

oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0750,100 ,"PAGAVEL PREFERNCIALMENTE NAS AGENCIAS DO BRADESCO"        ,oFont10)

oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]										,oFont10n) //Nome + CNPJ

oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (0940,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0910,505 ,"Nro.Documento"				         		    ,oFont8)
oPrint:Say  (0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,If(aDadosTit[8]$"NF |NFF","DM",aDadosTit[8])		,oFont10) //Tipo do Titulo

oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             	,oFont10)

oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Subs(aDadosTit[6],1,14)+"-"+Subs(aDadosTit[6],15,1),oFont10) //Carteira + Dados do Título

oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)

oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (1050,100 ,"Instruções (Texto de responsabilidade do cedente)",oFont8)
oPrint:Say  (1100,100 ,aBolText[1]                                      ,oFont8) //Informacoes do Titulo
oPrint:Say  (1150,100 ,aBolText[2]                                      ,oFont8)
oPrint:Say  (1200,100 ,aBolText[3]                                      ,oFont8)
oPrint:Say  (1250,100 ,aBolText[4]                                      ,oFont8)
oPrint:Say  (1300,100 ,aBolText[5]                                      ,oFont8)
oPrint:Say  (1300,100 ,aBolText[6]                                      ,oFont8)
oPrint:Say  (1300,100 ,aBolText[7]                                      ,oFont8)
//oPrint:Say  (1300,100 ,aBolText[8]                                      ,oFont08n)

oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)    

If aDadosTit[15] > 0
	oPrint:Say  (1080,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont10)
Endif

oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]				   	                ,oFont10)
oPrint:Say  (1430,1600,IIF(!EMPTY(aDatSacado[7]),"CNPJ.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),""),oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

//oPrint:SayBitmap( 1420,2000,aBitMap[1],200,200 )

oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)

oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )

For i := 100 to 2300 step 50
	oPrint:Line( 1850, i, 1850, i+30)
Next i

// Encerra aqui a alteracao para o novo layout - RAI

oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1900, 550)
oPrint:Line (2000,800,1900, 800)
If File(aBmp)
	oPrint:SayBitmap(1900,100,aBmp,0100,0100 )                                          // [2]Nome do Banco
Else
	oPrint:Say  (1912,100,aDadosBanco[2],oFont15n )										// [2]Nome do Banco                     1934
EndIf                                       	// [2]Nome do Banco
oPrint:Say  (1912,567,aDadosBanco[1],oFont24 )	// [1]Numero do Banco
oPrint:Say  (1934,820, CB_RN_NN[2] ,oFont14)		//Linha Digitavel do Codigo de Barras

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2040,100 ,"PAGAVEL PREFERNCIALMENTE NAS AGENCIAS DO BRADESCO"     ,oFont10)

oPrint:Say  (2000,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2040,2010,If(Dtoc(aDadosTit[4])=="11/11/11","C/Apresentação",DTOC(aDadosTit[4])),oFont10)

oPrint:Say  (2100,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (2140,100 ,aDadosEmp[1]										,oFont10n) //Nome + CNPJ

oPrint:Say  (2100,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (2140,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2230,100 ,DTOC(aDadosTit[2])                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (2200,505 ,"Nro.Documento"              ,oFont8)
oPrint:Say  (2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2230,1050,If(aDadosTit[8]$"NF |NFF","DM",aDadosTit[8])		,oFont10) //Tipo do Titulo

oPrint:Say  (2200,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (2230,1455,"N"                                             ,oFont10)

oPrint:Say  (2200,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (2230,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao

oPrint:Say  (2200,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (2230,2010,Subs(aDadosTit[6],1,14)+"-"+Subs(aDadosTit[6],15,1),oFont10)

oPrint:Say  (2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (2300,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (2270,1555,"Valor"                                          ,oFont8)

oPrint:Say  (2270,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,"Instruções (Texto de responsabilidade do cedente)",oFont8)
oPrint:Say  (2390,100 ,aBolText[1]                                      ,oFont8) //Informacoes do Titulo
oPrint:Say  (2440,100 ,aBolText[2]										,oFont8)
oPrint:Say  (2490,100 ,aBolText[3]                                      ,oFont8)
oPrint:Say  (2540,100 ,aBolText[4]                                      ,oFont8)
oPrint:Say  (2590,100 ,aBolText[5]                                      ,oFont8)
oPrint:Say  (2640,100 ,aBolText[6]                                      ,oFont8)
oPrint:Say  (2540,1400,aBolText[7]                                      ,oFont8)
//oPrint:Say  (2590,1400,aBolText[8]                                      ,oFont08n)

oPrint:Say  (2340,1910,"(-)Desconto/Abatimento"                         ,oFont8)     

If aDadosTit[15] > 0
	oPrint:Say  (2370,2010,AllTrim(Transform(aDadosTit[15],"@E 999,999,999.99")),oFont10)
Endif

oPrint:Say  (2410,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (2480,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (2550,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (2620,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (2690,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (2720,400 ,aDatSacado[1]						             ,oFont10)
oPrint:Say  (2720,1600,IIF(!EMPTY(aDatSacado[7]),"CNPJ.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),""),oFont10)
oPrint:Say  (2773,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (2826,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
//oPrint:SayBitmap( 2700,2000,aBitMap[1],200,200 )
oPrint:Say  (2835,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (2835,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (2835,1850,"Ficha de Compensação"                           ,oFont10)
oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )
oPrint:Line (2880,100 ,2880,2300 )

//IMPRIME O CODIGO DE BARRAS

//MSBAR("INT25"  ,27,1.5, CB_RN_NN[1] ,oPrint,.F.,,,,1.3,,,,.F.)
MSBAR("INT25"  ,25,1.5, CB_RN_NN[1] ,oPrint,.F.,,,,1.3,,,,.F.)

//oPrint:Say  (2880,1500 ,CB_RN_NN[1])

DbSelectArea("SE1")

RecLock("SE1",.f.)
     SE1->E1_NUMBCO :=	Subst(CB_RN_NN[3],1,12)
MsUnlock()

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)

Local L,D,P := 0
Local B     := .F.
L := Len(cData)
B := .T.
D := 0
do while L > 0
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
EndDo

D := 10 - (Mod(D,10))

If D = 10
	D := 0
End

Return(D)
      
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Modulo11(cData) //Modulo 11 com base 7

Local L, D, P := 0

L := Len(cdata)
D := 0
P := 1      
DV:= " "

While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 7   //Volta para o inicio, ou seja comeca a multiplicar por 2,3,4...
		P := 1
	End
	L := L - 1
End                   

_nResto := mod(D,11)  //Resto da Divisao 

D := 11 - _nResto 
DV:=STR(D)

If _nResto == 0
	DV := "0"
End
If _nResto == 1
	DV := "P"
End

Return(DV)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Mod11CB(cData) // Modulo 11 com base 9

Local CBL, CBD, CBP := 0
CBL := Len(cdata)
CBD := 0
CBP := 1      

While CBL > 0
	CBP := CBP + 1
	CBD := CBD + (Val(SubStr(cData, CBL, 1)) * CBP)
	If CBP = 9    //Volta para o inicio, ou seja comeca a multiplicar por 2,3,4...
		CBP := 1
	End
	CBL := CBL - 1
End                   
_nCBResto := mod(CBD,11)  //Resto da Divisao 
CBD := 11 - _nCBResto 
If (CBD == 0 .Or. CBD == 1 .Or. CBD > 9) 
	CBD := 1
End

Return(CBD)


//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BOLBRA  ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO BRADESCO COM CODIGO DE BARRAS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)

Local bldocnufinal := Strzero(Val(cNroDoc),11)
Local blvalorfinal := strzero((nValor*100),10)
Local dvnn         := 0
Local dvcb         := 0
Local dv           := 0
Local NN           := ''
Local RN           := ''
Local CB           := ''
Local s            := ''
Local dDtBase	   := CtoD("07/10/97")
Local cFatorVencto := ""

//Fator de Vencimento do Boleto
cFatorVencto := Str(SE1->E1_VENCREA - dDtBase,4)

//NOSSO NUMERO
snn  := cCarteira+bldocnufinal     // Carteira + Numero Gravado no SEE
dvnn := modulo11(snn)  //Digito verificador no Nosso Numero - Base 7
NN   := bldocnufinal + AllTrim(dvnn)

//STRING PARA O CODIGO DE BARRAS
_cLivre := cAgencia + cCarteira + bldocnufinal + StrZero(Val(cConta),7) + '0'
scb := cBanco +"9"+ cFatorVencto + StrZero((nValor*100),10)+_cLivre
dvcb := mod11CB(scb)	//digito verificador do codigo de barras
CB := SubStr(scb,1,4)+AllTrim(Str(dvcb))+SubStr(scb,5,39)

//MONTAGEM DA LINHA DIGITAVEL 
srn := cBanco+"9"+Substr(_cLivre,1,5)//Codigo Banco + Codigo Moeda + 5 primeiros digitos do campo livre
dv := modulo10(srn)
RN := SubStr(srn, 1, 5) + '.' + SubStr(srn,6,4)+AllTrim(Str(dv))+' '
srn := SubStr(_cLivre,6,10)	// posicao 6 a 15 do campo livre
dv := modulo10(srn)      
RN := RN + SubStr(srn,1,5)+'.'+SubStr(srn,6,5)+AllTrim(Str(dv))+' '
srn := SubStr(_cLivre,16,10)	// posicao 16 a 25 do campo livre
dv := modulo10(srn)
RN := RN + SubStr(srn,1,5)+'.'+SubStr(srn,6,5)+AllTrim(Str(dv)) + ' '
RN := RN + AllTrim(Str(dvcb))+' '
RN := RN + cFatorVencto + Strzero((nValor * 100),10)

Return({CB,RN,NN}) // Codigo de Barras, Linha Digitável e Nosso Número

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³VALIDPERG ³ Autor ³ RAIMUNDO PEREIRA      ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±³          ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()  

//Local aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

AADD(aRegs,{cPerg,"01","Do Prefixo           ?","","","mv_ch1","C", 3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate o Prefixo        ?","","","mv_ch2","C", 3,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Numero            ?","","","mv_ch3","C", 9,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Ate o Numero         ?","","","mv_ch4","C", 9,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Da Parcela           ?","","","mv_ch5","C", 1,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ate a Parcela        ?","","","mv_ch6","C", 1,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Do Bordero           ?","","","mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Ate o Bordero        ?","","","mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Banco:                ","","","mv_ch9","C",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SA6","",""})
AADD(aRegs,{cPerg,"10","Agencia:              ","","","mv_cha","C",06,0,0,"G","","MV_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Conta:                ","","","mv_chb","C",15,0,0,"G","","MV_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AADD(aRegs,{cPerg,"12","SubConta:             ","","","mv_chc","C",03,0,0,"G","","MV_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
LValidPerg(aRegs)

Return
