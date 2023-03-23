#include 'protheus.ch'
#include 'parmtype.ch' 
#include 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6
/*
	Imprimir boleto avulso
*/
User Function JbBol01


Local aPergs 	:=	{}
Local aRet	 	:=	{}
Local cTitulo	
Local cPref 	
Local cBank		
Local cAgenc	
Local cCont		
Local aAuxL1	:=	{}
Private	aDaBnk	:=	{}


If Empty(FunName())
	RpcSetType(3)
	RPCSetEnv("01","0201")
EndIf

cTitulo	:=	space(TamSX3("E1_NUM")[1]) 
cPref 	:=	space(TamSX3("E1_PREFIXO")[1])
cBank	:=	space(TamSX3("EE_CODIGO")[1])
cAgenc	:=	space(TamSX3("EE_AGENCIA")[1])
cCont	:=	space(TamSX3("E1_CONTA")[1])

aAdd(aPergs ,{1,"Serie de?	"		,cPref	  ,'@!',"","","",70,.F.})
aAdd(aPergs ,{1,"Nota de?	"		,cTitulo  ,'@!',"","SE1","",70,.F.})
aAdd(aPergs ,{1,"Nota Até?	"		,cTitulo  ,'@!',"","SE1","",70,.F.})
aAdd(aPergs ,{1,"Banco?	"			,cBank	  ,'@!',"","SEE","",70,.F.})
aAdd(aPergs ,{1,"Agência?	"		,cAgenc	  ,'@!',"","","",70,.F.})
aAdd(aPergs ,{1,"Conta?	"			,cCont	  ,'@!',"","","",70,.F.})

If ParamBox(aPergs ,"Filtro",@aRet)
	//For nCont := aRet[2] to aRet[3]
		//MV_PAR01 := aRet[1]
		//MV_PAR02 := nCont
		MV_PAR03 := aRet[4]
		MV_PAR04 := aRet[5]
		MV_PAR05 := aRet[6]
	
		/*DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR02)
*/
		DbSelectArea("SEE")
		DbSetOrder(1)
		If Dbseek(xFilial("SEE")+MV_PAR03+MV_PAR04+MV_PAR05)
			aDaBnk := {SEE->EE_CODIGO,Alltrim(SEE->EE_AGENCIA),Alltrim(SEE->EE_CONTA),Alltrim(SEE->EE_DVCTA),Alltrim(SEE->EE_CODCART),SEE->EE_SUBCTA}
		EndIf

		aAuxL1 := Busca(aRet[1],aRet[2],aRet[3])
		If len(aAuxL1) > 0
			bol011(aAuxL1)
		EndIf
	//Next nCont
EndIf

Return
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º PROGRAMA     º JbFin01  º AUTOR º                    º DATA º Maio/2021    º±±
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
User Function JbFin01(lAutomat,cPasta)

//
Local aArea		:= GetArea()
PRIVATE Exec    := .F.  
PRIVATE _nTxper := GETMV("MV_XTAXA",,1)
PRIVATE _nMulta := GETMV("MV_XMULTA",,2)

PRIVATE nCB1Linha	:= GETMV("PV_BOL_LI1",,14.5)
PRIVATE nCB2Linha	:= GETMV("PV_BOL_LI2",,26.1)
Private nCBColuna	:= GETMV("PV_BOL_COL",,1.3)
Private nCBLargura	:= GETMV("PV_BOL_LAR",,0.0280)
Private nCBAltura	:= GETMV("PV_BOL_ALT",,1.4)

Default aDaBnk		:= 	{} //DadBnk()
Default cPasta		:=	""
Default lAutomat	:=	.T.

Private _Bco 	:=	aDaBnk[1] //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_BCOBOL"}),2],"A6_COD") //GetMV("PI_BCOBOL",,"341  ")
Private _Age 	:=	aDaBnk[2] //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_AGEBOL"}),2],"A6_AGENCIA") //GetMV("PI_AGEBOL",,"2938 ")
Private _Cta 	:=	aDaBnk[3] //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_CTABOL"}),2],"A6_NUMCON") //GetMV("PI_CTABOL",,"21899     ")
Private _DiV 	:=	aDaBnk[4] //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_AGEBOL"}),2],"A6_DVCTA") //GetMV("PI_DIGBOL",,"3")
Private _Car	:=	aDaBnk[5] //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_CARBOL"}),2],"EE_CODCART") //GetMV("PI_CARBOL",,"109")
Private _SubCta	:=	aDaBnk[6] //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_SUBCTA"}),2],"EE_SUBCTA") 

DbselectArea("SE1")
DbSetOrder(1)

Processa({|lEnd|MontaRel(cPasta)})

RestArea(aArea)

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
Static Function MontaRel(cPasta)
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
						"Após Vencimento Aplicar Multa de "+cvaltochar(_nMulta)+"% - R$",; //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"} - Alterado por Ronaldo Gomes - 17/03/2017
						GetMV("MV_XMSGBL1",," "),;//"Receber até 30 dias após o vencimento."),;
						GetMV("MV_XMSGBL2",,"")}
                           //Ajustar, trocar para mv_par     aqui
							// "Após o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ""
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.

oPrint 	:= FWMSPrinter():New("Boleto_"+strzero(VAL(MV_PAR02),9)+"_"+Alltrim(MV_PAR06)+".rel",  IMP_PDF, lAdjustToLegacy, cPasta, lDisableSetup,,,,.F.,,,.F.)

oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:StartPage()   	// Inicia uma nova página
oPrint:SetMargin(60,60,60,60)
oPrint:cPathPDF := cPasta

DBSEEK(xFilial("SE1")+Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM")+Avkey(MV_PAR06,"E1_PARCELA")+Avkey(MV_PAR07,"E1_TIPO"))
//
Do While !EOF() .and. E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO == Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM")+Avkey(MV_PAR06,"E1_PARCELA")+Avkey(MV_PAR07,"E1_TIPO")
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+_Bco+_Age+_Cta)
	
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
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	//
	DbSelectArea("SE1")
	//
						
   	aDadosBanco  := {_Bco           		,; // [1]Numero do Banco
						"Banco Itaú S.A."      ,; // [2]Nome do Banco
						_Age                 ,; // [3]Agência
						_Cta				,; // [4]Conta Corrente
						_DiV  					,; // [5]Dígito da conta corrente
						_Car                  }  // [6]Codigo da Carteira */
						
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
	
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	If Empty(SE1->E1_NUMBCO)
		_cNossoNum	:= PegaNNum()
		CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(SE1->E1_VALOR-_nVlrAbat+SE1->E1_ACRESC-SE1->E1_DECRESC),Datavalida(SE1->E1_VENCTO,.T.))
	ELSE
		CB_RN_NN := {}
		Aadd(CB_RN_NN,SE1->E1_CODBAR)
		Aadd(CB_RN_NN,SE1->E1_CODDIG)
		Aadd(CB_RN_NN,SE1->E1_NUMBCO)
	EndIf

	
	aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)						,;  // [1] Número do título
						E1_EMISSAO                              					,;  // [2] Data da emissão do título
						Date()                                  					,;  // [3] Data da emissão do boleto
						Datavalida(E1_VENCTO,.T.)                  					,;  // [4] Data do vencimento
						(E1_SALDO - _nVlrAbat + SE1->E1_ACRESC - SE1->E1_DECRESC)   ,;  // [5] Valor do título                       
						CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                               					,;  // [7] Prefixo da NF
						E1_TIPO	                               						,;  // [8] Tipo do Titulo
						E1_ACRESC													,;	// [9] Acrescimos
						E1_DECRESC													}	// [10] Descontos
	
	Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,n)
	n := n + 1
	
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
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN,nlinha)
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL nX := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
LOCAL oBrush       

aBmp2	:= "\SYSTEM\lgrl02.bmp"
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
If nlinha > 0
	oPrint:StartPage()   // Inicia uma nova página
endIf
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

//  *************************     RECIBO DO PAGADOR     *********************

oPrint:Line (0040,043,0020,043)  //linha que separa o logo do nome do banco
oPrint:Line (0040,125,0020,125)  //linha que separa o nome do banco do numero 341
oPrint:Line (0040,225,0020,225) // linha que separa 341 do codigo de barras

//Caixa parte pagador do boleto        
oPrint:Box(0040,010,0350,650, "-4")   //Cabeçalho

// LOGOTIPO  
If File(aBmp)
	oPrint:SayBitmap( 0010,011,aBmp,030,030 )
	oPrint:Say  (0035,045,"Banco Itaú SA",oFont14n )	// [2]Nome do Banco*/
Else
	oPrint:Say  (0144,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0035,130,"341-7",oFont16N )	// [1]Numero do Banco
oPrint:Say  (0035,510,"RECIBO DE PAGADOR",oFont12n)		//Linha Digitavel do Codigo de Barras   1934 CB_RN_NN[2]*/

//
oPrint:Line (0070,10,0070,650 )  //linha Vencimento
oPrint:Line (0100,10,0100,650 )  //linha beneficiario
oPrint:Line (0130,10,0130,650 )	 //linha data documento
oPrint:Line (0160,10,0160,650 )	 //linha uso do banco
oPrint:Line (0300,10,0300,650 )	 //linha instruções

oPrint:Line (0200,510,0200,650 )	 //linha desconto
oPrint:Line (0240,510,0240,650 )	 //linha multa

oPrint:Line (0040,510,0300,510) //linha que separa do vencimento ate inscr estadual

oPrint:Line (0100,090,0160,090) //linha que separa data do documento do numero
oPrint:Line (0100,255,0160,255) //linha que separa numero do documento da especie
oPrint:Line (0100,335,0160,335) //linha que separa especie do aceite
oPrint:Line (0100,395,0130,395) //linha que separa aceite da data do processamento
oPrint:Line (0130,425,0160,425) //linha que separa quantidade do valor

oPrint:Say  (0055,512 ,"Vencimento" 		                         ,oFont9)
oPrint:Say  (0068,590,DTOC(aDadosTit[4])                             ,oFont10)

oPrint:Say  (0055,014 ,"Local de Pagamento"	                         ,oFont9)
oPrint:Say  (0068,014 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ" ,oFont11n)

oPrint:Say  (0085,014 ,"Beneficiário"			   					 ,oFont9)
oPrint:Say  (0098,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0085,512 ,"Agência/Código Beneficiário"				 ,oFont9)
oPrint:Say  (0098,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0115,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0128,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0115,092 ,"Nº do Documento"							 ,oFont9)
oPrint:Say  (0128,092 ,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0115,257 ,"Espécie Doc"								 ,oFont9)
oPrint:Say  (0128,258,aDadosTit[8]									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0115,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0128,0357,"N"                                           ,oFont10)

oPrint:Say  (0115,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0128,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0115,512 ,"Nosso Número"								 ,oFont9)
oPrint:Say  (0128,0580,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (0145,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0145,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0158,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0145,257 ,"Espécie"				   					 ,oFont9)
oPrint:Say  (0158,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0145,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0145,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0145,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0158,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (0170,014 ,"Instruções: (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)" ,oFont9)
oPrint:Say  (0185,014 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]/100)*0.034),"@E 99,999.99"))  ,oFont10) 
oPrint:Say  (0200,014 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*_nMulta/100),"@E 99,999.99"))       ,oFont10) 

nP1 := 215
nCol1 := 1

For nX := 1 to round(len(aBolText[4])/30,0)
	oPrint:Say  (nP1,014 ,substr(aBolText[4],nCol1,110)       ,oFont10) 
	nCol1 += 110
	nP1 += 12
Next nX

oPrint:Say  (0170,512 ,"(-) Desconto/Abatimento"					 ,oFont9)
//oPrint:Say  (0183,580,AllTrim(Transform(aDadosTit[10],"@E 999,999,999.99")),oFont10)

oPrint:Say  (0210,512 ,"(+) Mora/Multa"			 					 ,oFont9)
//oPrint:Say  (0225,580,AllTrim(Transform(aDadosTit[9],"@E 999,999,999.99")),oFont10)

oPrint:Say  (0250,512 ,"(=) Valor Cobrado"		 					 ,oFont9)
oPrint:Say  (0263,580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

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


// **************************** FINAL DA PARTE SUPERIOR DO BOLETO               

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
//oPrint:Say  (0546,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)/30),"@E 99,999.99"))  ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 
oPrint:Say  (0546,014 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]/100)*0.034),"@E 99,999.99"))  ,oFont10) 
oPrint:Say  (0556,014 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*_nMulta/100),"@E 99,999.99"))       ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 


nP1 := 566
nCol1 := 1

For nX := 1 to round(len(aBolText[4])/30,0)
	oPrint:Say  (nP1,014 ,substr(aBolText[4],nCol1,110)       ,oFont10)
	nCol1 += 110
	nP1 += 10
Next nX

oPrint:Say  (0532,512 ,"(-) Desconto/Abatimento"					 ,oFont9)
//oPrint:Say  (0545,580,AllTrim(Transform(aDadosTit[10],"@E 999,999,999.99")),oFont10)

oPrint:Say  (0568,512 ,"(+) Mora/Multa"			 					 ,oFont9)
//oPrint:Say  (0581,580,AllTrim(Transform(aDadosTit[9],"@E 999,999,999.99")),oFont10)

oPrint:Say  (0605,512 ,"(=) Valor Cobrado"		 					 ,oFont9)
oPrint:Say  (0618,580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)


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
SE1->E1_NUMBCO 	:=  CB_RN_NN[3]
SE1->E1_CODBAR	:=	CB_RN_NN[1]
SE1->E1_CODDIG  :=  CB_RN_NN[2]
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
s    :=  cAgencia + cConta + _cCart + bldocnufina
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
//s    := cAgencia + cConta + _cCart + bldocnufinal
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//RN   := RN + SubStr(bldocnufinal, 3, 5) + '.' + SubStr(bldocnufinal, 8, 1) + AllTrim(Str(dv)) + '  '
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

/*/{Protheus.doc} PegaNNum()

	(long_description)
	@type  Static Function
	@author user
	@since 23/04/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function PegaNNum()

Local aArea	:=	GetArea()
Local cRet := ""
Local cQuery 

cQuery := "SELECT EE_FAXATU,R_E_C_N_O_ AS REGISTRO FROM "+RetSQLName("SEE")
cQuery += " WHERE EE_FILIAL='"+xFilial("SEE")+"' AND EE_CODIGO='"+_Bco+"' AND EE_AGENCIA='"+_Age+"'"
cQuery += " AND EE_CONTA='"+_Cta+"' AND EE_SUBCTA='"+_SubCta+"' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	TRB->( dbclosearea() )
Endif
	
DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),"TRB", .T., .T.)
	
cRet := TRB->EE_FAXATU

If TRB->REGISTRO > 0
	DbselectArea("SEE")
	DbGoto(TRB->REGISTRO)
	Reclock("SEE",.F.)
	SEE->EE_FAXATU := STRZERO(VAL(TRB->EE_FAXATU)+1,12)
	SEE->(Msunlock())
EndIf

RestArea(aArea)

Return(cRet)

#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function bol011(aArraX) 

Local nCont		:=	0
Private aList1 	:=	{}
Private oList1 
Private oDlg1,oGrp1,oBrw1,oGrp2,oSay1,oGet1,oBtn1
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    

If len(aArraX) >0 
	For nCont := 1 to len(aArraX)
		Aadd(aList1,aArraX[nCont])
	Next nConta

	oDlg1      := MSDialog():New( 092,232,660,1437,"Envio Faturamento",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 000,004,196,592,"Titulos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
	oList1 	   := TCBrowse():New(008,010,576,184,, {'','Numero','Prefixo','Parcela','Cliente','Emissão','Vencimento','Valor'},{10,40,25,60,20,20,20,30},;
										oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| editcol(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
			oList1:SetArray(aList1)
			oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
								aList1[oList1:nAt,02],; 
								aList1[oList1:nAt,03],;
								aList1[oList1:nAt,04],; 
								aList1[oList1:nAt,05],;
								aList1[oList1:nAt,06],;
								aList1[oList1:nAt,07],; 
								aList1[oList1:nAt,08]}}

	oGrp2      := TGroup():New( 200,004,272,316,"oGrp2",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 208,008,{||"Cópia email para:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet1      := TGet():New( 208,042,,oGrp2,276,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oMenu := TMenu():New(0,0,0,0,.T.)
	// Adiciona itens no Menu
	oTMenuIte1 := TMenuItem():New(oDlg1,"Enviar",,,,{|| Processa({|| Enviar(aList1),"Aguarde.."})},,,,,,,,,.T.)
	oTMenuIte2 := TMenuItem():New(oDlg1,"Inverter Seleção",,,,{|| Markall()},,,,,,,,,.T.)
	oTMenuIte9 := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()},,,,,,,,,.T.)

	oMenu:Add(oTMenuIte1)
	oMenu:Add(oTMenuIte2)
	oMenu:Add(oTMenuIte9)

	// Cria botão que sera usado no Menu
	oTButton1 := TButton():New( 256, 464, "Opções",oDlg1,{|| /*alert("Botão 01")*/ },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	// Define botão no Menu
	oTButton1:SetPopupMenu(oMenu)

	oDlg1:Activate(,,,.T.)
	
Else
	MsgAlert("Não encontrado titulos que atendam ao filtro informado.")
EndIf

Return

/*/{Protheus.doc} editcol
	(long_description)
	@type  Static Function
	@author user
	@since 11/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function editcol(nLinha)

Local nCnt := 1

If MsgYesNo("Marcar/Desmarcar todos os boletos da mesma nota?")
	For nCnt := 1 to len(aList1)
		If aList1[nLinha,02] == aList1[nCnt,02]
			If aList1[nCnt,01] 
				aList1[nCnt,01] := .F.
			Else	
				aList1[nCnt,01] := .T.
			EndIF
		EndIf
	Next nCnt
Else
	If aList1[nLinha,01]
		aList1[nLinha,01] := .F.
	Else
		aList1[nLinha,01] := .T.
	EndIf
EndIf

oList1:refresh()
oDlg1:refresh()
	
Return

/*/{Protheus.doc} BUSCA
cription)

Local aArea	:=	GetArea()

RestArea(aAreA)	at
	ype  Static Function
	@a	@since 11/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function BUSCA(cPar1,cPar2,cPar3)

Local aArea	:=	GetArea()
Local cQuery 
Local aRet 	:=	{}

//'','Numero','Prefixo','Parcela','Cliente','Emissão','Vencimento','Valor'
cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,A1_NOME,E1_EMISSAO,E1_VENCREA,E1_VALOR,A1_COD,A1_LOJA,E1.R_E_C_N_O_ AS RECE1,A1_EMAIL,E1_TIPO"
cQuery += " FROM "+RetSQLName("SE1")+" E1 "
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE E1_PREFIXO='"+cPar1+"' AND E1_NUM BETWEEN '"+cPar2+"' AND '"+cPar3+"' AND E1.D_E_L_E_T_=' '"
cQuery += " AND E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND E1_BAIXA=' ' AND E1_SALDO>0"

If Select("TRB") > 0
	TRB->( dbclosearea() )
Endif
	
DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),"TRB", .T., .T.)

While !EOF()
	Aadd(aRet,{.F.,TRB->E1_NUM,TRB->E1_PREFIXO,TRB->E1_PARCELA,TRB->A1_NOME,;
				cvaltochar(stod(TRB->E1_EMISSAO)),cvaltochar(stod(TRB->E1_VENCREA)),;
				TRB->E1_VALOR,TRB->A1_COD,TRB->A1_LOJA,TRB->A1_EMAIL,TRB->E1_TIPO,TRB->RECE1})
	Dbskip()
EndDo

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} Enviar
aAuxcription)
@type  Static Function
	@
	@since 11/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function Enviar(aAux)

Local aArea 	:=	GetArea()
Local nLista	:=	0
Local cPasta	:=	'C:\TEMP\'
Local cNfEnv	:=	''
Local cSerNf 	:=	''
Local cMailBk	:=	''
Local aParcEn	:=	{}
Private cPastaS :=	ALLTRIM(GetNewPar("SL_FOLDPDF",'\system\boletos\'))

cPasta	:=	'C:\OneDrive\Boletos\'+cFilant+'\'
/*
If cFilant == '0101'
	cPasta	:=	'C:\OneDrive\Boletos\0101\'
ElseIf cFilant == '0201'
	cPasta	:=	'C:\OneDrive\Boletos\0201\'
ElseIf cFilant == '0301'
	cPasta	:=	'C:\OneDrive\Boletos\0301\'
ElseIf cFilant == '0401'
	cPasta	:=	'C:\OneDrive\Boletos\0401\'
ElseIf cFilant == '0501'
	cPasta	:=  'C:\OneDrive\Boletos\0501\'
ElseIf cFilant == '0601'
	cPasta	:=  'C:\OneDrive\Boletos\0601\'
ElseIf cFilant == '0701'
	cPasta	:=  'C:\OneDrive\Boletos\0701\'
ElseIf cFilant == '0801'
	cPasta	:=  'C:\OneDrive\Boletos\0801\'
ElseIf cFilant == '0901'
	cPasta	:=  'C:\OneDrive\Boletos\0901\'
ElseIf cFilant == '1001'
	cPasta	:=  'C:\OneDrive\Boletos\1001\'
Else
	cPasta := 'C:\OneDrive\Boletos\'
EndIf
*/
If !ExistDir(cPastaS)
	Makedir(cPastaS)
EndIf

For nLista := 1 to len(aAux)
	If aAux[nLista,01]
		If cNfEnv <> aAux[nLista,02] 
			If Empty(cNfEnv)
				cNfEnv 	:= aAux[nLista,02]
				cSerNf 	:= aAux[nLista,03]
				cMailBk	:= aAux[nLista,11]
				Aadd(aParcEn,aAux[nLista,04])
			Else
				//enviar
				U_zGerDanfe(cNfEnv, cSerNf, cPasta, cMailBk,aParcEn)
				cNfEnv 	:= aAux[nLista,02]
				cSerNf 	:= aAux[nLista,03]
				cMailBk	:= aAux[nLista,11]
				aParcEn := {}
				Aadd(aParcEn,aAux[nLista,04])
			EndIF
		Else
			Aadd(aParcEn,aAux[nLista,04])
		EndIf

		MV_PAR01 := aAux[nLista,03]
		MV_PAR02 := aAux[nLista,02]
		MV_PAR06 := aAux[nLista,04]
		MV_PAR07 := aAux[nLista,12]

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR02+MV_PAR06+MV_PAR07)

		U_JbFin01(.T.,cPasta)
		
		CPYT2S(cPasta+"Boleto_"+strzero(VAL(MV_PAR02),9)+"_"+Alltrim(MV_PAR06)+".pdf",cPastaS)
		
	EndIf
Next nLista

If !File(cPasta+strzero(VAL(cNfEnv),9)+".pdf")
	U_zGerDanfe(cNfEnv, cSerNf, cPasta, cMailBk,aParcEn)
EndIf

MsgAlert("Arquivos gerados na pasta "+cPasta)
ShellExecute( "Open", "","" , cPasta , 1 )

RestArea(aArea)

Return

/*/{Protheus.doc} Markall()
	(long_description)
	@type  Static Function
	@author user
	@since 11/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function Markall()

Local nInvert := 0

For nInvert := 1 to len(aList1)
	If aList1[nInvert,01]
		aList1[nInvert,01] := .F.
	Else
		aList1[nInvert,01] := .T.
	EndIf
Next nInvert

oList1:refresh()
oDlg1:refresh()

Return

//Bibliotecas
#Include "Protheus.ch"
#Include "TBIConn.ch" 
#Include "Colors.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#include "fileio.ch"

 
/*/{Protheus.doc} zGerDanfe
Função que gera a danfe e o xml de uma nota em uma pasta passada por parâmetro
@author Alexandre
@since 25/11/2019
@version 1.0
@param cNota, characters, Nota que será buscada
@param cSerie, characters, Série da Nota
@param cPasta, characters, Pasta que terá o XML e o PDF salvos
@type function
@example u_zGerDanfe("000123ABC", "1", "C:\TOTVS\NF",'email@destino.com.br')
/*/
User Function zGerDanfe(cNota, cSerie, cPasta, cMail,aParcEn)
    Local aArea     := GetArea()
    Local cIdent    := ""
    Local cArquivo  := ""
    Local oDanfe    := Nil
    Local lEnd      := .F.
    Local nTamNota  := TamSX3('F2_DOC')[1]
    Local nTamSerie := TamSX3('F2_SERIE')[1]
	Local nY 		:= 0
    Private PixelX
    Private PixelY
    Private nConsNeg
    Private nConsTex
    Private oRetNF
    Private nColAux
    Default cNota   := ""
    Default cSerie  := ""
    Default cPasta  := GetTempPath()
     
    //Se existir nota
    If ! Empty(cNota)
        //Pega o IDENT da empresa
        cIdent := RetIdEnti()
         
        //Se o último caracter da pasta não for barra, será barra para integridade
        If !ExistDir(cPasta)
          	Makedir(cPasta)
        EndIf
         
        //Gera o XML da Nota
        cArquivo := cNota //+ "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-")
        u_zSpedXML(cNota, cSerie, cPasta + cArquivo  + ".xml", .F.)
         
        //Define as perguntas da DANFE
        Pergunte("NFSIGW",.F.)
        MV_PAR01 := PadR(cNota,  nTamNota)     //Nota Inicial
        MV_PAR02 := PadR(cNota,  nTamNota)     //Nota Final
        MV_PAR03 := PadR(cSerie, nTamSerie)    //Série da Nota
        MV_PAR04 := 2                          //NF de Saida
        MV_PAR05 := 1                          //Frente e Verso = Sim
        MV_PAR06 := 2                          //DANFE simplificado = Nao
         
        //Cria a Danfe
        oDanfe := FWMSPrinter():New(cArquivo, IMP_PDF, .F., cPasta, .T.)
         
        //Propriedades da DANFE
        oDanfe:SetResolution(78)
        oDanfe:SetPortrait()
        oDanfe:SetPaperSize(DMPAPER_A4)
        oDanfe:SetMargin(60, 60, 60, 60)
         
        //Força a impressão em PDF
        oDanfe:nDevice  := 6
        oDanfe:cPathPDF := cPasta                
        oDanfe:lServer  := .F.
        oDanfe:lViewPDF := .F.
         
        //Variáveis obrigatórias da DANFE (pode colocar outras abaixo)
        PixelX    := oDanfe:nLogPixelX()
        PixelY    := oDanfe:nLogPixelY()
        nConsNeg  := 0.4
        nConsTex  := 0.5
        oRetNF    := Nil
        nColAux   := 0
         
        //Chamando a impressão da danfe no RDMAKE
        //RptStatus({|lEnd| StaticCall(DANFEII, DanfeProc, @oDanfe, @lEnd, cIdent, , , .F.)}, "Imprimindo Danfe...")
		U_DANFEProc(@oDanfe, @lEnd, cIdent, , , .F.)

        oDanfe:Print()
        
        aArquivos := {}
		//Necessário enviar a copia para o servidor, caso o arquivo seja gerado localmente
		CPYT2S(cPasta+cArquivo+".pdf",cPastaS)
		
		Aadd(aArquivos,{cPastaS+cArquivo+".pdf",''})
		Aadd(aArquivos,{cPastaS+cArquivo+".xml",''})
        
		If len(aParcEn) > 0
			For nY := 1 to len(aParcEn)
				If File(cPastaS+"Boleto_"+strzero(VAL(cNota),9)+"_"+Alltrim(aParcEn[nY])+".pdf")
					Aadd(aArquivos,{cPastaS+"Boleto_"+strzero(VAL(cNota),9)+"_"+Alltrim(aParcEn[nY])+".pdf",''})
				EndIf
			Next nY 
		EndIf
		
		cBody := corpo()
		cBcc := ALLTRIM(GetNewPar("SL_MAILCC",''))
		cMail := 'avenanc@yahoo.com.br'
		//'cobranca@jubileudistribuidora.com'
		U_JBMAIL('suporte@avsipro.com.br',Alltrim(cMail),'Emissão de Nota',cBody,aArquivos,.F.,cBcc)
    
    EndIf
     
    RestArea(aArea)
    
Return(cArquivo)
/*
	Criando o corpo do email e trocando as informações variaveis do conteúdo.
	
*/
Static Function corpo()

Local cArqT1 := '\system\jubileu.txt'
Local cLinha := ''
Local cRet 	 := ''
FT_FUSE(cArqT1)

DbSelectArea("SA1")
DbSetOrder(1)
Dbseek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
cNome := Alltrim(SA1->A1_NOME)
cEnd  := Alltrim(SA1->A1_END)+" / "+Alltrim(SA1->A1_BAIRRO)+" / "+Alltrim(SA1->A1_MUN)

FT_FGOTOP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	If "*NOME_CLIENTE*" $ Alltrim(cLinha)
		cLinha := strtran(cLinha,"*NOME_CLIENTE*",cNome)
	ElseIf "*DADOS_CLIENTE*" $ Alltrim(cLinha)
		cLinha := strtran(cLinha,"*DADOS_CLIENTE*",cEnd)
	ElseIf "*VALOR_PEDIDO*" $ Alltrim(cLinha)
		cLinha := strtran(cLinha,"*VALOR_PEDIDO*","R$ "+Transform(SF2->F2_VALBRUT,"@E 999,999.99"))
	ElseIf "*NR_PEDIDO*" $ Alltrim(cLinha)
		cLinha := strtran(cLinha,"*NR_PEDIDO*",SD2->D2_PEDIDO)
	ElseIf "*dd/MM/yyyy*" $ Alltrim(cLinha)
		cEntrega := DTOC(Posicione("SC6",1,xFilial("SC6")+SD2->D2_PEDIDO,"C6_ENTREG"))
		cLinha := strtran(cLinha,"*dd/MM/yyyy*",cEntrega)
	ElseIf "*END_LOCAL*" $ Alltrim(cLinha)
		cLocal := Alltrim(SM0->M0_ENDCOB)+" - "+Alltrim(SM0->M0_CIDCOB)+" / "+SM0->M0_ESTCOB
		cLinha := strtran(cLinha,"*END_LOCAL*",cLocal)
	ElseIf "*(XX)XXXX-XXXX*" $ Alltrim(cLinha)
		cLinha := strtran(cLinha,"*(XX)XXXX-XXXX*",SM0->M0_TEL)
	EndIf
	cRet += Alltrim(cLinha)
	
	FT_FSKIP()
EndDo 

Return(cRet)

//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zSpedXML
Função que gera o arquivo xml da nota (normal ou cancelada) através do documento e da série disponibilizados
@author Alexandre Venancio
@since 25/11/2019
@version 1.0
@param cDocumento, characters, Código do documento (F2_DOC)
@param cSerie, characters, Série do documento (F2_SERIE)
@param cArqXML, characters, Caminho do arquivo que será gerado (por exemplo, C:\TOTVS\arquivo.xml)
@param lMostra, logical, Se será mostrado mensagens com os dados (erros ou a mensagem com o xml na tela)
@type function
@example Segue exemplo abaixo
    u_zSpedXML("000000001", "1", "C:\TOTVS\arquivo1.xml", .F.) //Não mostra mensagem com o XML
     
    u_zSpedXML("000000001", "1", "C:\TOTVS\arquivo2.xml", .T.) //Mostra mensagem com o XML
/*/
 
User Function zSpedXML(cDocumento, cSerie, cArqXML, lMostra)
    Local aArea        := GetArea()
    Local cURLTss      := PadR(GetNewPar("MV_SPEDURL","http://"),250)  
    Local oWebServ
    Local cIdEnt       := StaticCall(SPEDNFE, GetIdEnt)
    Local cTextoXML    := ""
    Default cDocumento := ""
    Default cSerie     := ""
    Default cArqXML    := GetTempPath()+"arquivo_"+cSerie+cDocumento+".xml"
    Default lMostra    := .F.
     
    //Se tiver documento
    If !Empty(cDocumento)
        cDocumento := PadR(cDocumento, TamSX3('F2_DOC')[1])
        cSerie     := PadR(cSerie,     TamSX3('F2_SERIE')[1])
         
        //Instancia a conexão com o WebService do TSS    
        oWebServ:= WSNFeSBRA():New()
        oWebServ:cUSERTOKEN        := "TOTVS"
        oWebServ:cID_ENT           := cIdEnt
        oWebServ:oWSNFEID          := NFESBRA_NFES2():New()
        oWebServ:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
        aAdd(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
        aTail(oWebServ:oWSNFEID:oWSNotas:oWSNFESID2):cID := (cSerie+cDocumento)
        oWebServ:nDIASPARAEXCLUSAO := 0
        oWebServ:_URL              := AllTrim(cURLTss)+"/NFeSBRA.apw"   
         
        //Se tiver notas
        If oWebServ:RetornaNotas()
         
            //Se tiver dados
            If Len(oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3) > 0
             
                //Se tiver sido cancelada
                If oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA != Nil
                    cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFECANCELADA:cXML
                     
                //Senão, pega o xml normal
                Else
                    cTextoXML := oWebServ:oWsRetornaNotasResult:OWSNOTAS:oWSNFES3[1]:oWSNFE:cXML
                EndIf
                 
                //Gera o arquivo
                MemoWrite(cArqXML, cTextoXML)
                 
                //Se for para mostrar, será mostrado um aviso com o conteúdo
                If lMostra
                    Aviso("zSpedXML", cTextoXML, {"Ok"}, 3)
                EndIf
                 
            //Caso não encontre as notas, mostra mensagem
            Else
                ConOut("zSpedXML > Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...")
                 
                If lMostra
                    Aviso("zSpedXML", "Verificar parâmetros, documento e série não encontrados ("+cDocumento+"/"+cSerie+")...", {"Ok"}, 3)
                EndIf
            EndIf
         
        //Senão, houve erros na classe
        Else
            ConOut("zSpedXML > "+IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3))+"...")
             
            If lMostra
                Aviso("zSpedXML", IIf(Empty(GetWscError(3)), GetWscError(1), GetWscError(3)), {"Ok"}, 3)
            EndIf
        EndIf
    EndIf
    RestArea(aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTMAILN   ºAutor  ³ Alexandre Venancio  º Data ³  09/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de emails                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JBMAIL(cFrom,cTo,cSubject,cBody,aAttach,lConfirm,cCC,cBCC)

Local lRet			:= .F.  
Local oServer
Local oMessage
Local cMailServer	:= ""
Local cSmtpServer	:= strtran(Alltrim( GetMV("MV_RELSERV") ),":587") 
Local cAccount		:= Alltrim( GetMV("MV_RELACNT") ) 
Local cPassword		:= Alltrim( GetMV("MV_RELPSW")  ) 
Local lAuth			:= .T. 
Local nMailPort		:= 0
Local nSmtpPort		:= 587
Local nI			:= 0
Local nErro			:= 0
Local cAttach		:= ""
Local cContent		:= ""
Default cFrom		:= ""
Default cTo			:= ""
Default cCC			:= ""
Default cBCC		:= ""
Default cSubject	:= ""
Default cBody		:= ""
Default aAttach		:= {}
Default lConfirm	:= .F.


If Empty(cFrom) .Or. Empty(cTo) .Or. Empty(cSubject)
	Conout("#PPMAILN: PARAMETROS DE ENTRADA INVALIDOS")
	Return lRet 
EndIf

If Empty(cSmtpServer) .Or. Empty(cAccount) .Or. Empty(cPassword)
	Conout("#PPMAILN: ERRO NOS PARAMETROS DE CONFIGURACAO DO EMAIL -> REVISAR MV_RELSERV/MV_RELAUSR/MV_RELAPSW")
	Return lRet
EndIf

// Cria a conexão com o server STMP ( Envio de e-mail )
oServer := TMailManager():New()

oServer:Init( cMailServer, cSmtpServer, cAccount, cPassword, nMailPort, nSmtpPort )

// seta um tempo de time out com servidor de 1min
If oServer:SetSmtpTimeOut( 120 ) != 0
	Conout( "#PPMAILN: FALHA AO SETAR TIMEOUT" )
	Return lRet
EndIf
	  
// realiza a conexao SMTP
If oServer:SmtpConnect() != 0
	Conout( "#TTMAILN: FALHA AO CONECTAR" )
	//Return lRet
EndIf

// autentica no servidor SMTP
If lAuth
	nErro := oServer:SMTPAuth( cAccount, cPassword )
	If nErro != 0
		Conout( "#TTMAILN: ERRO AO AUTENTICAR -> ", oServer:GetErrorString( nErro ) )
		Return lRet
	EndIf   
EndIf

  
// Apos a conexão, cria o objeto da mensagem
oMessage := TMailMessage():New()
  
// Limpa o objeto
oMessage:Clear()
  
// Popula com os dados de envio
oMessage:cFrom		:= cFrom
oMessage:cTo		:= cTo
oMessage:cCc		:= cCC
oMessage:cBcc		:= cBcc
oMessage:cSubject	:= cSubject
oMessage:cBody		:= cBody
oMessage:MsgBodyType( "text/html" )
  
// Adiciona um attach
For nI := 1 To Len(aAttach)
	cAttach := aAttach[nI][1]
	cContent := aAttach[nI][2]
	If File(cAttach)
		If oMessage:AttachFile( cAttach ) < 0
			Conout( "#PPMAILN: ERRO AO ATTACHAR O ARQUIVO" )
		Else
			//adiciona uma tag informando que é um attach e o nome do arq
			oMessage:AddAtthTag( cContent+";filename=" +cAttach ) //oMessage:AddAtthTag( "Content-ID: " +"<" +cContent +">" /*+";filename=" +cAttach*/ )
		EndIf
	Else
		Conout( "#PPMAILN: ARQUIVO ANEXO NAO ENCONTRADO -> " +cAttach )
	EndIf 
Next nI

// confirmacao de leitura  
If lConfirm
	oMessage:SetConfirmRead( .T. )
EndIf
	
// Envia o e-mail
nErro := oMessage:Send( oServer )
If nErro <> 0
	Conout( "#PPMAILN: ERRO AO ENVIAR O EMAIL -> ", oServer:GetErrorString( nErro ) )
Else
	lRet := .T.
EndIf

// Desconecta do servidor
If oServer:SmtpDisconnect() != 0
	Conout( "#PPMAILN: ERRO AO DESCONECTAR DO SERVIDOR SMTP" )
EndIf 
   
Return lRet
