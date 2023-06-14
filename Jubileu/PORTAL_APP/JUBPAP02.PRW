#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6
	
	
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫ PROGRAMA     ∫ AMCFIN02  ∫ AUTOR ∫                    ∫ DATA ∫ AGOSTO/2005 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ DESCRICAO    ∫ PROGRAMA ESPECIFICO PARA REEMISSAO DA IMPRESSAO DO          ∫±±
±±∫              ∫ BOLETO DE COBRANCA DO BANCO ITAU, EM FORMATO GRAFICO A SER  ∫±±
±±∫              ∫ EMITIDO JUNTAMENTE COM A NOTA FISCAL FATURA OU CUPOM FISCAL ∫±±
±±∫              ∫ DESDE QUE A FORMA DE PAGAMENTO ASSIM O JUSTIFIQUE.          ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕπ±±
±±∫ TABS.UTILIZ  ∫ DESCRICAO                                          ∫ ACESSO ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕπ±±
±±∫   SA1010     ∫ CADASTRO DE CLIENTES                               ∫ READ   ∫±±
±±∫   SA6010     ∫ CADASTRO DE BANCOS                                 ∫ READ   ∫±±
±±∫   SE1010     ∫ CONTAS A RECEBER                                   ∫ WRITE  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕπ±±
±±∫ HISTORICO    ∫ (AGO/2005) ELABORACAO DE PROGRAMA INICIAL - ALEX (REV. 00)  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ USO          ∫ ESPECIFICO  - CONTROLE DE LOJAS/FINANCEIRO.                 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕŒÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫ PROPRIETARIO ∫ CUSTOMIZADO PARA                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
user function ROBBOL(lAutomat,cPasta,cfilorig,cParcela)

//
PRIVATE Exec    := .F.  
PRIVATE _nTxper := GETMV("MV_XTAXA",,5)
PRIVATE _nMulta := GETMV("MV_XMULTA",,2)

PRIVATE nCB1Linha	:= GETMV("PV_BOL_LI1",,14.5)
PRIVATE nCB2Linha	:= GETMV("PV_BOL_LI2",,26.1)
Private nCBColuna	:= GETMV("PV_BOL_COL",,1.3)
Private nCBLargura	:= GETMV("PV_BOL_LAR",,0.0280)
Private nCBAltura	:= GETMV("PV_BOL_ALT",,1.4)

//AQUIPrivate aDaBnk	:= 	DadBnk()
Private _Bco 	:=	'001' //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_BCOBOL"}),2],"A6_COD") //GetMV("PI_BCOBOL",,"341  ")
Private _Age 	:=	'1511 ' //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_AGEBOL"}),2],"A6_AGENCIA") //GetMV("PI_AGEBOL",,"2938 ")
Private _Cta 	:=	If(cfilorig=="0101",'11        ','101       ') //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_CTABOL"}),2],"A6_NUMCON") //GetMV("PI_CTABOL",,"21899     ")
Private _DiV 	:=	If(cfilorig=="0101",'6','5') //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_DIGBOL"}),2],"A6_DVCTA") //GetMV("PI_DIGBOL",,"3")
Private _Car	:=	'17' //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_CARBOL"}),2],"EE_CODCART") //GetMV("PI_CARBOL",,"109")
Private _SubCta	:=	'001' //Avkey(aDaBnk[ascan(aDaBnk,{|x| x[1] == "PI_SUBCTA"}),2],"EE_SUBCTA") 
Private _cNossoNum
Private nPag    :=  1


Default cPasta		:=	""
Default lAutomat	:=	.T.

DbselectArea("SE1")
DbSetOrder(1)

Processa({|lEnd|MontaRel(cPasta,cParcela)})

Return Nil
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥MontaRel()   ≥Descriá„o≥Montagem e Impressao de boleto Gra- ≥±±
±±≥          ≥             ≥         ≥fico do Banco Itau.                 ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function MontaRel(cPasta,cParcela)
LOCAL   oPrint
LOCAL   n := 0
Local aBitmap      := {"" ,;                             //Banner publicit·rio         
                       "\Bitmaps\Logo_Siga.bmp"      }   //Logo da empresa


LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
							SM0->M0_ENDCOB                                                              ,; //[2]EndereÁo
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
						"ApÛs o vencimento cobrar Mora Diaria de R$",;  //"ApÛs Vencimento Aplicar Mora de "+cvaltochar(_nTxper)+"% a.m" - Alterado por Ronaldo Gomes - 17/03/2017                                  ,;
						"ApÛs Vencimento Aplicar Multa de "+cvaltochar(_nMulta)+"% - R$",; //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"} - Alterado por Ronaldo Gomes - 17/03/2017
						GetMV("MV_XMSGBL1",,"Protestar apos 7 dias de vencimento"),;
						GetMV("MV_XMSGBL2",,"")}
                           //Ajustar, trocar para mv_par     aqui
// "ApÛs o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL _nVlrAbat    := 0
//LOCAL cParcela	   := ""
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.

DbSelectArea("SE1")
DbSetOrder(1)

If DBSEEK(xFilial("SE1")+Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM")+Avkey(cParcela,"E1_PARCELA"))
//
//Do While !EOF() .and. E1_PREFIXO+E1_NUM == Avkey(MV_PAR01,"E1_PREFIXO")+Avkey(MV_PAR02,"E1_NUM")
	
	
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+_Bco+_Age+_Cta)
	//DbSeek(xFilial("SA6")+_Bco+_Age+_Cta)
	//
	
	DO CASE
		CASE Alltrim(SE1->E1_PARCELA) == "A"
			cParcela := "1"
		CASE Alltrim(SE1->E1_PARCELA) == "B"
			cParcela := "2"
		CASE Alltrim(SE1->E1_PARCELA) == "C"
			cParcela := "3"
		CASE Alltrim(SE1->E1_PARCELA) == "D"
			cParcela := "4"
		CASE Alltrim(SE1->E1_PARCELA) == "E"
			cParcela := "5"
		CASE Alltrim(SE1->E1_PARCELA) == "F"
			cParcela := "6"
		CASE Alltrim(SE1->E1_PARCELA) == "G"
			cParcela := "7"
		CASE Alltrim(SE1->E1_PARCELA) == "H"
			cParcela := "8"
		CASE Alltrim(SE1->E1_PARCELA) == "I"
			cParcela := "9"
		OTHERWISE
			cParcela := "0"
	ENDCASE
	
	oPrint 	:= FWMSPrinter():New("Boleto_"+strzero(VAL(MV_PAR02),9)+"_"+Alltrim(SE1->E1_PARCELA)+".rel",  IMP_PDF, lAdjustToLegacy, cPasta, lDisableSetup,,,,.F.,,,.F.)

	oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:StartPage()   	// Inicia uma nova p·gina
	oPrint:SetMargin(60,60,60,60)
	oPrint:cPathPDF := cPasta //ctemp
	
	

	If !Empty(SE1->E1_NUMBCO)
		_cNossoNum	:= SE1->E1_NUMBCO
	Else
		//_cNossoNum	:= PegaNNum()
	EndIf

	//
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	//
	DbSelectArea("SE1")
	//
						
   
   	
	aDadosBanco  := {SA6->A6_COD     ,;                        //1-Numero do Banco
                     SA6->A6_NREDUZ  ,;                        //2-Nome do Banco
                     Alltrim(SA6->A6_AGENCIA)+If(empty(SA6->A6_DVAGE),'','-')+Alltrim(SA6->A6_DVAGE) ,;   //3-AgÍncia
                     Alltrim(SA6->A6_NUMCON),;      //4-Conta Corrente
                     Iif(SA6->A6_COD $ "479/389/033","",SA6->A6_DVCTA)  ,; //5-DÌgito da conta corrente
			         alltrim(SEE->EE_CODCART) ,;   //6-Carteira
			         "",;
                     "",""} 					
						
	//
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Raz„o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]CÛdigo
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]EndereÁo
		AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
		SA1->A1_EST                                       ,;     // [5]Estado
		SA1->A1_CEP                                       ,;     // [6]CEP
		SA1->A1_CGC									  ,;       // [7]CGC
		SA1->A1_INSCR									}		//[8]IE
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Raz„o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]CÛdigo
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]EndereÁo
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		SA1->A1_CEPC                                         ,;   // [6]CEP
		SA1->A1_CGC										    ,;   // [7]CGC
		SA1->A1_INSCR										}	// [8]IE
	Endif
	
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	//CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(E1_VALOR-_nVlrAbat),Datavalida(E1_VENCTO,.T.))
    CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],;
					aDadosBanco[6],AllTrim(E1_NUM)+AllTrim(E1_PARCELA),(E1_SALDO-_nVlrAbat),SE1->E1_VENCREA,SEE->EE_CODEMP,SEE->EE_FAXATU,Iif(SE1->E1_DECRESC > 0,.t.,.f.),SE1->E1_PARCELA,aDadosBanco[3])

	
	aDadosTit    :=  {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)	    ,;  //1-N˙mero do tÌtulo
					E1_EMISSAO								,;  //2-Data da emiss„o do tÌtulo
					dDataBase								,;  //3-Data da emiss„o do boleto
					E1_VENCREA								,;  //4-Data do vencimento
					(E1_SALDO - _nVlrAbat)		,;  //5-Valor do tÌtulo
					AllTrim(CB_RN_NN[3])						,;  //6-Nosso n˙mero (Ver fÛrmula para calculo)
					SE1->E1_DESCFIN							,;  // 7-VAlor do Desconto do titulo
					SE1->E1_VALJUR }                             // 8-Valor dos juros do titulo
	
    cInst0:= strtran(SEE->EE_FORMEN1,"'","")
    cInst1:= strtran(SEE->EE_FORMEN2,"'","")
    cInst2:= strtran(SEE->EE_FOREXT1,"'","")
    cInst3:= ""

    If nPag > 1
		oPrint:endpage()
        oPrint:StartPage()
    endif
	Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	n := n + 1
	
	//dbSkip()
	IncProc()
	i := i + 1
    nPag++
EndIf 
//EndDo
//            

oPrint:EndPage()     // Finaliza a p·gina
//oPrint:Preview()     // Visualiza antes de imprimir
oPrint:Print()
Return nil
//
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥Impress      ≥Descriá„o≥Impressao de Boleto Grafico do Banco≥±±
±±≥          ≥             ≥         ≥Itau.                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

//oFont?? = tamanho da fonte usada
Local oFont8
Local oFont9
Local oFont10
Local oFont16
Local oFont16n     
Local oFont20
Local oFont24
Local i := 0
Local nX
Local oBrush                            //fundo no valor do titulo   
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690       

//Par‚metros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)

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
//oBrush := TBrush():New("",4)
//oBrush := TBrush():New(,CLR_BLUE,,)
oBrush := TBrush():New(,,,)



oPrint:Line (0040,063,0020,063)  //linha que separa o logo do nome do banco
oPrint:Line (0040,145,0020,145)  //linha que separa o nome do banco do numero 341
oPrint:Line (0040,225,0020,225) // linha que separa 341 do codigo de barras

//Caixa parte pagador do boleto        
oPrint:Box(0040,010,0350,650, "-4")   //CabeÁalho

// LOGOTIPO  
/*If File(aBmp)
	oPrint:SayBitmap( 0010,011,aBmp,030,030 )
	oPrint:Say  (0035,045,"Banco Ita˙ SA",oFont14n )	// [2]Nome do Banco*/
//Else
	oPrint:Say  (030,70,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont16n )	// [2]Nome do Banco
//EndIf
//
//oPrint:Line (150,100,150,2300)   

	                               
If aDadosBanco[1] == "001" 
	oPrint:SayBitMap(020,10,"\Images\bb.bmp",50,13)
	oPrint:SayBitMap(440,10,"\Images\bb.bmp",50,13)
ElseIf aDadosBanco[1] == "341" 
	oPrint:SayBitMap (035,100,"\Images\itau.bmp",500,130)
	oPrint:SayBitMap (370,100,"\Images\itau.bmp",500,130)
ElseIf aDadosBanco[1] == "033"                                              
	oPrint:SayBitMap (035,100,"\Images\santander.bmp",500,120)
	oPrint:SayBitMap (370,100,"\Images\santander.bmp",500,120)
ElseIf aDadosBanco[1] == "237"                                              
	oPrint:SayBitMap (035,100,"\Images\bradesco.bmp",500,120)
	oPrint:SayBitMap (370,100,"\Images\bradesco.bmp",500,120)
ElseIf aDadosBanco[1] == "422"                                              
	oPrint:SayBitMap (035,100,"\Images\safra.bmp",500,120)
	oPrint:SayBitMap (370,100,"\Images\safra.bmp",500,120)
ElseIf aDadosBanco[1] == "084"                                              
	oPrint:SayBitMap (035,100,"\Images\prime.bmp",500,120)
	oPrint:SayBitMap (370,100,"\Images\prime.bmp",500,120)
Endif	


oPrint:Line (0070,10,0070,650 )  //linha Vencimento

oPrint:Line (0100,10,0100,650 )  //linha beneficiario

oPrint:Line (0130,10,0130,650 )	 //linha data documento

oPrint:Line (0160,10,0160,650 )	 //linha uso do banco
oPrint:Line (0300,10,0300,650 )	 //linha instruÁıes

oPrint:Line (0200,510,0200,650 )	 //linha desconto
oPrint:Line (0240,510,0240,650 )	 //linha multa

oPrint:Line (0040,510,0300,510) //linha que separa do vencimento ate inscr estadual

oPrint:Line (0100,090,0160,090) //linha que separa data do documento do numero
oPrint:Line (0100,255,0160,255) //linha que separa numero do documento da especie
oPrint:Line (0100,335,0160,335) //linha que separa especie do aceite
oPrint:Line (0100,395,0130,395) //linha que separa aceite da data do processamento
oPrint:Line (0130,425,0160,425) //linha que separa quantidade do valor


oPrint:Say  (0052,512 ,"Vencimento" 		                         ,oFont9)
oPrint:Say  (0068,590,DTOC(aDadosTit[4])                             ,oFont10)

oPrint:Say  (0052,014 ,"Local de Pagamento"	                         ,oFont9)
oPrint:Say  (0068,014 ,"Pag·vel em qualquer banco atÈ o vencimento" ,oFont8)
oPrint:Say  (0082,014 ,"Benefici·rio"			   					 ,oFont9)
oPrint:Say  (0098,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0082,512 ,"AgÍncia/CÛdigo Benefici·rio"				 ,oFont9)
oPrint:Say  (0098,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0112,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0128,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0112,092 ,"N∫ do Documento"							 ,oFont9)
oPrint:Say  (0128,092 , aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0112,257 ,"EspÈcie Doc"								 ,oFont9)
oPrint:Say  (0128,258 ,"R$"     									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0112,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0128,0357,"N"                                           ,oFont10)

oPrint:Say  (0112,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0128,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0112,512 ,"Nosso N˙mero"								 ,oFont9)
oPrint:Say  (0128,0550,aDadosTit[6]                                  ,oFont10)

oPrint:Say  (0142,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0142,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0158,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0142,257 ,"EspÈcie"				   					 ,oFont9)
oPrint:Say  (0158,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0142,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0142,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0142,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0158,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)


oPrint:Say  (0170,014 ,"InstruÁıes: (Todas informaÁıes deste bloqueto s„o de exclusiva responsabilidade do Benefici·rio)" ,oFont9)
oPrint:Say  (0185,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)/30),"@E 99,999.99"))  ,oFont10) 
oPrint:Say  (0200,014 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*_nMulta/100),"@E 99,999.99"))       ,oFont10) 

nP1 := 212
nCol1 := 1

For nX := 1 to round(len(aBolText[4])/30,0)
	oPrint:Say  (nP1,014 ,substr(aBolText[4],nCol1,110)       ,oFont10) 
	nCol1 += 110
	nP1 += 12
Next nX

oPrint:Say  (0170,512 ,"(-) Desconto/Abatimento"					 ,oFont9)
//oPrint:Say  (0263,512 ,"(+) Mora/Multa"			 					 ,oFont9)
oPrint:Say  (0210,512 ,"(+) Mora/Multa"			 					 ,oFont9)
//oPrint:Say  (0285,512 ,"(=) Valor Cobrado"		 					 ,oFont9)
oPrint:Say  (0250,512 ,"(=) Valor Cobrado"		 					 ,oFont9)

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
//InscriÁ„o estadual
oPrint:Say  (0327,510,aDatSacado[8] ,oFont10)

oPrint:Say  (0348,510 ,"CÛd. de Baixa" 						 	     ,oFont9)
                    
oPrint:Say  (0360,450 ,"AutenticaÁ„o Mec‚nica" 						 ,oFont9I)
oPrint:Say  (0360,014 ,"Esta quitaÁ„o sÛ ter· validade apÛs o pagamento do cheque pelo banco Pagador.",oFont5)
oPrint:Say  (0365,014 ,"Ate o vencimento pag·vel em qualquer agÍncia banc·ria.",oFont5)

// **************************** FINAL DA PARTE SUPERIOR DO BOLETO               

//SeparaÁ„o da nota de debito ou inicio do boleto com a parte destacavel
oPrint:Say  (0390, 020, REPLICATE( '- ', 136 ), oFont9)
//Caixa parte pagador do boleto        
oPrint:Box(0431,010,0698,650, "-4")   //CabeÁalho

// LOGOTIPO  
/*If File(aBmp)
	oPrint:SayBitmap( 0400,011,aBmp,030,030 )
	oPrint:Say  (0418,045,"Banco Ita˙ SA",oFont14n )	// [2]Nome do Banco
Else*/
	oPrint:Say  (0420,070,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont15n )	// [2]Nome do Banco
//EndIf
//
//oPrint:Say  (0418,130,"341-7",oFont24 )	// [1]Numero do Banco
oPrint:Say  (0418,230,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//

oPrint:Line (0431,065,0398,065)  //linha que separa o logo do nome do banco
oPrint:Line (0431,135,0398,135)  //linha que separa o nome do banco do numero 341
oPrint:Line (0431,225,0398,225) // linha que separa 341 do codigo de barras

oPrint:Line (0458,10,0458,650 )  //linha Vencimento
oPrint:Line (0480,10,0480,650 )  //linha beneficiario
oPrint:Line (0502,10,0502,650 )	 //linha data documento
oPrint:Line (0524,10,0524,650 )	 //linha uso do banco
oPrint:Line (0634,10,0634,650 )	 //linha instruÁıes

oPrint:Line (0560,510,0560,650 )	 //linha desconto
oPrint:Line (0597,510,0597,650 )	 //linha multa

oPrint:Line (0431,510,0634,510) //linha que separa do vencimento ate inscr estadual
oPrint:Line (0480,090,0524,090) //linha que separa data do documento do numero
oPrint:Line (0480,255,0524,255) //linha que separa numero do documento da especie
oPrint:Line (0480,335,0524,335) //linha que separa especie do aceite
oPrint:Line (0480,395,0502,395) //linha que separa aceite da data do processamento
oPrint:Line (0502,425,0524,425) //linha que separa quantidade do valor

oPrint:SayBitMap(410,10,"\Images\bb.bmp",50,13)
//
oPrint:Say  (0440,512 ,"Vencimento" 		                         ,oFont9)
oPrint:Say  (0456,590,DTOC(aDadosTit[4])                             ,oFont10)

oPrint:Say  (0450,014 ,"Pag·vel em qualquer banco atÈ o vencimento" ,oFont11n)

oPrint:Say  (0466,014 ,"Benefici·rio"			   					 ,oFont9)
oPrint:Say  (0477,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0466,512 ,"AgÍncia/CÛdigo Benefici·rio"				 ,oFont9)
oPrint:Say  (0477,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0488,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0499,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0488,092 ,"N∫ do Documento"							 ,oFont9)
oPrint:Say  (0499,092 ,aDadosTit[1]	                                 ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0488,257 ,"EspÈcie Doc"								 ,oFont9)
oPrint:Say  (0499,258 ,"DM"     									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0488,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0499,0357,"N"                                           ,oFont10)

oPrint:Say  (0488,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0499,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0488,512 ,"Nosso N˙mero"								 ,oFont9)
oPrint:Say  (0499,0550,aDadosTit[6]                                  ,oFont10)

oPrint:Say  (0514,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0510,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0521,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0510,257 ,"EspÈcie"				   					 ,oFont9)
oPrint:Say  (0521,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0510,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0510,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0510,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0521,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (0532,014 ,"InstruÁıes: (Todas informaÁıes deste bloqueto s„o de exclusiva responsabilidade do Benefici·rio)" ,oFont9)
//oPrint:Say  (0546,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10) - Alterado por Ronaldo Gomes - 17/03/2017
oPrint:Say  (0546,014 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)/30),"@E 99,999.99"))  ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 
//oPrint:Say  (0556,014 ,aBolText[3]                                   ,oFont10)  - Alterado por Ronaldo Gomes - 17/03/2017
oPrint:Say  (0556,014 ,aBolText[3]+" "+AllTrim(Transform((aDadosTit[5]*_nMulta/100),"@E 99,999.99"))       ,oFont10) // Incluido por Ronaldo Gomes - 17/03/2017 


nP1 := 566
nCol1 := 1

For nX := 1 to round(len(aBolText[4])/30,0)
	oPrint:Say  (nP1,014 ,substr(aBolText[4],nCol1,110)       ,oFont10)
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
//InscriÁ„o estadual
oPrint:Say  (0665,510,aDatSacado[8] ,oFont10)

oPrint:Say  (0695,510 ,"CÛd. de Baixa" 						 	     ,oFont9)
                    
oPrint:Say  (0740,380 ,"AutenticaÁ„o Mec‚nica" 						 ,oFont9I)

oPrint:Say  (0740,510 ,"FICHA DE COMPENSA«√O"  						 ,oFont10)


//Codigo de Barras    
oPrint:Code128c(0790, 030, CB_RN_NN[1], 040) 
         
/*
oPrint:Say  (420,1310 ,"Recebi(emos) o bloqueto"                          ,oFont8) 
oPrint:Say  (450,1310 ,"com os dados ao lado."                            ,oFont8) 
oPrint:Line (420,1700,490,1700)
oPrint:Say  (420,1705 ,"Data"                                             ,oFont8) 
oPrint:Line (420,1900,490,1900)
oPrint:Say  (420,1905 ,"Assinatura"                                       ,oFont8) 
_lBcoCorrespondente := .f.
oPrint:Say  (150,100 ,"Benefici·rio"                                      ,oFont8) 
oPrint:Say  (180,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])),oFont9)
oPrint:Say  (210,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)
 
oPrint:Say  (250,100 ,"Pagador"                                           ,oFont8) 
oPrint:Say  (290,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                ,oFont10)

oPrint:Say  (350,100 ,"Data do Vencimento"                                ,oFont8)  

If aDadosBanco[1] $ "237/341"  //SE BRADESCO
	oPrint:Say  (380,100 ,Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)  ,oFont10)
Else
	oPrint:Say  (380,100 ,DTOC(aDadosTit[4])                              ,oFont10) 
Endif

oPrint:Say  (350,405 ,"Nro.Documento",oFont8) 
oPrint:Say  (380,405 ,AllTrim(Transform(aDadosTit[1],"@! 9999999999")),oFont10)

oPrint:Say  (350,630,"Moeda"                                              ,oFont8)
oPrint:Say  (380,655,"R$"     				                              ,oFont10)

oPrint:Say  (350,755,"Valor/Quantidade"                                   ,oFont8) 
oPrint:Say  (380,765,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")) ,oFont10)

oPrint:Say  (420,100 ,"AgÍncia/Cod. Benefici·rio"                         ,oFont8) 
    
If     aDadosBanco[1] == "033"   //SE BANESPA 
	oPrint:Say  (450,100,AllTrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4]),oFont10)
ElseIf aDadosBanco[1] == "399"   //SE HSBC 
	oPrint:Say  (450,100,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
ElseIf aDadosBanco[1] == "422"   //SE SAFRA 
	oPrint:Say  (450,100,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	//+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
Else
	oPrint:Say  (450,100,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
Endif	

oPrint:Say  (420,505,"Nosso N˙mero"                                       ,oFont8)   
oPrint:Say  (450,525,aDadosTit[6]                                         ,oFont10)  
 
For i := 100 to 2300 step 50
   oPrint:Line( 520, i, 520, i+30)
Next i

For i := 100 to 2300 step 50
   oPrint:Line( 750, i, 750, i+30)
Next i
	
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Ficha do Sacado                                                      ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

oPrint:Line (870,100,870,2300)   
oPrint:Line (870,650,770,650 )
oPrint:Line (870,900,770,900 ) 

oPrint:Say  (782,700,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont20 ) 
If aDadosBanco[1] == "001" 
	oPrint:Say  (782,100, "BANCO DO BRASIL",oFont14n )
ElseIf aDadosBanco[1] == "341" 
	oPrint:Say  (782,100, "BANCO ITA⁄",oFont20 )
ElseIf aDadosBanco[1] == "033"       
	oPrint:Say  (782,100, "SANTANDER",oFont20 )
ElseIf aDadosBanco[1] == "237"   
	oPrint:Say  (782,100, "BRADESCO",oFont20 )
ElseIf aDadosBanco[1] == "422"     
	oPrint:Say  (782,100, "SAFRA",oFont20 )
Endif	

oPrint:Line (0970,100,0970,2300 )
oPrint:Line (1070,100,1070,2300 )
oPrint:Line (1140,100,1140,2300 )
oPrint:Line (1210,100,1210,2300 )

oPrint:Line (1070,500,1210,500)
oPrint:Line (1140,750,1210,750)
oPrint:Line (1070,1000,1210,1000)
oPrint:Line (1070,1350,1140,1350)
oPrint:Line (1070,1550,1210,1550)

oPrint:Say  (870,100 ,"Local de Pagamento"                                         ,oFont8) 

If     aDadosBanco[1] == "237"
	oPrint:Say  (0910,100 ,"Pag·vel preferencialmente na rede Bradesco ou Bradesco Expresso" ,oFont10)
ElseIf aDadosBanco[1] == "341"
	oPrint:Say  (0910,100 ,"PAG¡VEL EM QUALQUER BANCO AT… O VENCIMENTO" ,oFont10)
ElseIf aDadosBanco[1] == "409"
	oPrint:Say  (0910,100 ,"Pag·vel em qualquer banco atÈ o vencimento, apÛs somente no Unibanco" ,oFont10)	
ElseIf aDadosBanco[1] == "422"
	oPrint:Say  (0910,100 ,"Pag·vel em qualquer banco do sistema de compensaÁ„o" ,oFont10)		
ElseIf aDadosBanco[1] == "399"
	oPrint:Say  (0910,100 ,"Pagar preferencialmente em agÍncia HSBC" ,oFont10)			
ElseIf aDadosBanco[1] == "084"

	oPrint:Say  (0910,100 ,"Pag·vel em qualquer banco atÈ o vencimento"  ,oFont10)
Endif                              


oPrint:Say  (870,1910,"Vencimento"                                                 ,oFont8)

If aDadosBanco[1] $ "237/341"  //SE BRADESCO
	oPrint:Say  (0910,2055,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
Else
	oPrint:Say  (0910,2055,PadL(AllTrim(DTOC(aDadosTit[4])),16)                     ,oFont10)
Endif

 
oPrint:Say  (0970,100 ,"Benefici·rio"                                               ,oFont8) 
oPrint:Say  (1000,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])+"-"+AllTrim(aDadosEmp[2])),oFont9)
oPrint:Say  (1030,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)


oPrint:Say  (0970,1910,"AgÍncia/CÛdigo Benefici·rio"                                ,oFont8) 

if     aDadosBanco[1] = '001'
	nLbco := 2040      
	nNoss := 2040
elseif aDadosBanco[1] = '033'
	nLbco := 1975
	nNoss := 2040	
elseif aDadosBanco[1] = '224' .or. aDadosBanco[1] = '224'
	nLbco := 2035
	nNoss := 2070		
elseif aDadosBanco[1] = '237'
	nLbco := 2040
	nNoss := 2030	
elseif aDadosBanco[1] = '341'
	nLbco := 2068
	nNoss := 2035			
elseif aDadosBanco[1] = '356'
	nLbco := 2010
	nNoss := 2020		
elseif aDadosBanco[1] = '399'
	nLbco := 2010
	nNoss := 2040				
elseif aDadosBanco[1] = '409'
	nLbco := 2005
	nNoss := 1990			
elseif aDadosBanco[1] = '422'
	nLbco := 2000
	nNoss := 2055				
else
	nLbco := 2040
	nNoss := 2040			
endif		                  

If aDadosBanco[1]     == "033"   //SE BANESPA 
	oPrint:Say  (1010,nLbco,AllTrim(aDadosBanco[3])+'/'+alltrim(aDadosBanco[4]),oFont10)	
ElseIf aDadosBanco[1] == "399"   //SE HSBC 
	oPrint:Say  (1010,nLbco,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
ElseIf aDadosBanco[1] == "422"   //SE SAFRA 
	oPrint:Say  (1010,nLbco,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	//+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")	
Else
	oPrint:Say  (1010,nLbco,AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),oFont10)
Endif	

oPrint:Say  (1070,100 ,"Data do Documento"                                          ,oFont8)  

If aDadosBanco[1] == "237" 
	oPrint:Say  (1100,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
Else
	oPrint:Say  (1100,100 ,DTOC(aDadosTit[3])                                       ,oFont10) 
Endif

oPrint:Say  (1070,505 ,"Nro.Documento"                                              ,oFont8) 
oPrint:Say  (1100,595 ,AllTrim(Transform(aDadosTit[1],"@! 9999999999")),oFont10)

oPrint:Say  (1070,1005,"EspÈcie Doc."                                               ,oFont8)

If aDadosBanco[1] == "399"  //SE HSBC
	oPrint:Say  (1100,1105,"PD"                                                         ,oFont10)
Else
	oPrint:Say  (1100,1105,"DM"                                                         ,oFont10)
Endif	

oPrint:Say  (1070,1355,"Aceite"                                                     ,oFont8) 
oPrint:Say  (1100,1455,"N"                                                          ,oFont10)

oPrint:Say  (1070,1555,"Data do Processamento"                                      ,oFont8) 

If aDadosBanco[1] == "237" 
	oPrint:Say  (1100,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
Else
	oPrint:Say  (1100,1655,DTOC(aDadosTit[2])                                       ,oFont10)
Endif

oPrint:Say  (1070,1910,"Nosso N˙mero"                                               ,oFont8)   
oPrint:Say  (1100,nNoss,AllTrim(aDadosTit[6])                                       ,oFont10)  

oPrint:Say  (1140,100 ,"Uso do Banco"                                               ,oFont8)

If aDadosBanco[1] == "409"
	oPrint:Say  (1170,100,"cvt 5539-5",oFont10)
Endif

oPrint:Say  (1140, 505,"Carteira"                                                   ,oFont8)     
If     aDadosBanco[1] == "033"
	oPrint:Say  (1170, 520,"SIMPLES ECR"                                            ,oFont10)     
ElseIf aDadosBanco[1] == "399"
	oPrint:Say  (1170, 540,"CSB"                                                    ,oFont10)     
Else
	oPrint:Say  (1170, 540,aDadosBanco[6]+aDadosBanco[7]                            ,oFont10)     
Endif	

oPrint:Say  (1140, 755,"EspÈcie"                                                    ,oFont8)   
oPrint:Say  (1170, 805,"R$"                                                         ,oFont10)  

oPrint:Say  (1140,1005,"Quantidade"                                                 ,oFont8) 
oPrint:Say  (1140,1555,"Valor"                                                      ,oFont8)            

oPrint:Say  (1140,1910,"(=)Valor do Documento"                                      ,oFont8) 

If aDadosBanco[1] == "341"
	oPrint:Say  (1170,2060,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
else
	oPrint:Say  (1170,2045,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
endif	

If aDadosBanco[1] == "341"
	oPrint:Say  (1210,100 ,"InstruÁıes/Todos as informaÁıes deste bloqueto s„o de exclusiva responsabilidade do benefici·rio",oFont8)     
Else
	oPrint:Say  (1210,100 ,"InstruÁıes/Texto de responsabilidade do benefici·rio"        ,oFont8)     
Endif                 

If aDadosBanco[1] == "341"
	oPrint:Say  (1240,2060,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
Else    
	oPrint:Say  (1240,2045,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
Endif

oPrint:Say  (1260,100 ,cInst0 ,oFontCN)     
oPrint:Say  (1290,100 ,cInst1 ,oFontCN)     
oPrint:Say  (1320,100 ,cInst2 ,oFontCN)     
oPrint:Say  (1350,100 ,cInst3 ,oFontCN)     
oPrint:Say  (1380,100 ,aBolText[1],oFontCN)    
oPrint:Say  (1410,100 ,aBolText[2],oFontCN)    
oPrint:Say  (1440,100 ,aBolText[3],oFontCN)    

oPrint:Say  (1210,1910,"(-)Desconto/Abatimento"                                     ,oFont8) 
oPrint:Say  (1280,1910,"(-)Outras DeduÁıes"                                         ,oFont8)
oPrint:Say  (1350,1910,"(+)Mora/Multa"                                              ,oFont8)
oPrint:Say  (1420,1910,"(+)Outros AcrÈscimos"                                       ,oFont8)
oPrint:Say  (1490,1910,"(=)Valor Cobrado"                                           ,oFont8)

oPrint:Say  (1560 ,100 ,"Pagador:"                                                  ,oFont8) 
oPrint:Say  (1588 ,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                        ,oFont8)
oPrint:Say  (1630 ,210 ,aDatSacado[3]                                               ,oFont8)
oPrint:Say  (1670 ,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

If aDadosBanco[1] == "422"
	oPrint:Say  (1525,100 ,"Sacador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)  
Else
	oPrint:Say  (1525,100 ,"Pagador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)   
EndIf

oPrint:Say  (1710,1500,"AutenticaÁ„o Mec‚nica "                                     ,oFont8)  
oPrint:Say  (0804,1850,"Recibo do Pagador"                                          ,oFont10)

oPrint:Line (0870,1900,1560,1900 )
oPrint:Line (1280,1900,1280,2300 )
oPrint:Line (1350,1900,1350,2300 )
oPrint:Line (1420,1900,1420,2300 )
oPrint:Line (1490,1900,1490,2300 )  
oPrint:Line (1560,100 ,1560,2300 )

oPrint:Line (1705,100,1705,2300  )     

For i := 100 to 2300 step 50
   oPrint:Line( 1870, i, 1870, i+30)
Next i                                                                   


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Ficha de Compensacao                                                ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oPrint:Line (1990,100,1990,2300)   
oPrint:Line (1990,650,1890,650 )
oPrint:Line (1990,900,1890,900 ) 

oPrint:Say  (1902,700,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont20 ) 

oPrint:Say  (1900,1004,CB_RN_NN[2],oFont12) //linha digitavel

If aDadosBanco[1] == "001" 
	oPrint:Say  (1900,100, "BANCO DO BRASIL",oFont14n )
ElseIf aDadosBanco[1] == "341" 
	oPrint:Say  (1900,100, "BANCO ITA⁄",oFont20 )
ElseIf aDadosBanco[1] == "033"       
	oPrint:Say  (1900,100, "SANTANDER",oFont20 )
ElseIf aDadosBanco[1] == "237"   
	oPrint:Say  (1900,100, "BRADESCO",oFont20 )
ElseIf aDadosBanco[1] == "422"     
	oPrint:Say  (1900,100, "SAFRA",oFont20 )
Endif	

oPrint:Line (2090,100,2090,2300 )
oPrint:Line (2190,100,2190,2300 )
oPrint:Line (2260,100,2260,2300 )
oPrint:Line (2330,100,2330,2300 )

oPrint:Line (2190,500,2330,500)
oPrint:Line (2260,750,2330,750)
oPrint:Line (2190,1000,2330,1000)
oPrint:Line (2190,1350,2260,1350)
oPrint:Line (2190,1550,2330,1550)

oPrint:Say  (1990,100 ,"Local de Pagamento"                             ,oFont8) 

If aDadosBanco[1] == "237" 
	oPrint:Say  (2030,100 ,"Pag·vel preferencialmente na rede Bradesco ou Bradesco Expresso"       ,oFont10)
ElseIf aDadosBanco[1] == "341"
	oPrint:Say  (2030,100 ,"AtÈ o vencimento, preferencialmente no Itau e ApÛs o vencimento, somente no Itau" ,oFont10)
ElseIf aDadosBanco[1] == "409"
	oPrint:Say  (2030,100 ,"Pag·vel em qualquer banco atÈ o vencimento, apÛs somente no Unibanco" ,oFont10)		
ElseIf aDadosBanco[1] == "422"
	oPrint:Say  (2030,100 ,"Pag·vel em qualquer banco do sistema de compensaÁ„o" ,oFont10)			
ElseIf aDadosBanco[1] == "399"
	oPrint:Say  (2030,100 ,"Pagar preferencialmente em agÍncia HSBC" ,oFont10)				
Else
	oPrint:Say  (2030,100 ,"Pag·vel em qualquer banco atÈ o vencimento"       ,oFont10)
Endif


oPrint:Say  (1990,1910,"Vencimento"                                     ,oFont8)

If aDadosBanco[1] $ "237/341"
	oPrint:Say  (2030,2055,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
Else
	oPrint:Say  (2030,2055,PadL(AllTrim(DTOC(aDadosTit[4])),16," ")                               ,oFont10)
Endif

 
oPrint:Say  (2090,100 ,"Benefici·rio"                                        ,oFont8) 
oPrint:Say  (2120,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])+"-"+AllTrim(aDadosEmp[2])),oFont9)
oPrint:Say  (2150,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)

oPrint:Say  (2090,1910,"AgÍncia/CÛdigo Benefici·rio"                         ,oFont8) 

If     aDadosBanco[1] == "033"   //SE BANESPA 
	oPrint:Say  (2130,nLbco,AllTrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4]),oFont10)
ElseIf aDadosBanco[1] == "399"   //SE HSBC 
	oPrint:Say  (2130,nLbco,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
ElseIf aDadosBanco[1] == "422"   //SE SAFRA 
	oPrint:Say  (2130,nLbco,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	 //+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")	
Else
	oPrint:Say  (2130,nLbco,AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),oFont10)
Endif	

oPrint:Say  (2190,100 ,"Data do Documento"                              ,oFont8)  

If aDadosBanco[1] == "237"
	oPrint:Say  (2220,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
Else                                                                                
	oPrint:Say  (2220,100 ,DTOC(aDadosTit[3])                               ,oFont10) 
Endif


oPrint:Say  (2190,505 ,"Nro.Documento"                                  ,oFont8) 
oPrint:Say  (2220,605 ,AllTrim(Transform(aDadosTit[1],"@! 9999999999")),oFont10)

oPrint:Say  (2190,1005,"EspÈcie Doc."                                   ,oFont8)

If aDadosBanco[1] == "399"  //SE HSBC
	oPrint:Say  (2220,1105,"PD"                                             ,oFont10)
Else
	oPrint:Say  (2220,1105,"DM"                                             ,oFont10)
Endif	

oPrint:Say  (2190,1355,"Aceite"                                         ,oFont8) 
oPrint:Say  (2220,1455,"N"                                              ,oFont10)

oPrint:Say  (2190,1555,"Data do Processamento"                          ,oFont8) 

If aDadosBanco[1] == "237"
	oPrint:Say  (2220,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
Else
	oPrint:Say  (2220,1655,DTOC(aDadosTit[2])                           ,oFont10)
Endif


oPrint:Say  (2190,1910,"Nosso N˙mero"                                   ,oFont8)   
oPrint:Say  (2220,nNoss,AllTrim(aDadosTit[6])                            ,oFont10)  

oPrint:Say  (2260,100 ,"Uso do Banco"                                   ,oFont8)      
If aDadosBanco[1] == "409"
	oPrint:Say  (2290,100 ,"cvt 5539-5"  ,oFont10)
Endif

oPrint:Say  (2260,505 ,"Carteira"                                       ,oFont8)     
If     aDadosBanco[1] == "033"
	oPrint:Say  (2290,520,"SIMPLES ECR"                                 ,oFont10)     
ElseIf aDadosBanco[1] == "399"
	oPrint:Say  (2290, 540,"CSB"                                        ,oFont10)     	
Else
	oPrint:Say  (2290,540 ,aDadosBanco[6]+aDadosBanco[7]                ,oFont10)     
Endif	


oPrint:Say  (2260,755 ,"EspÈcie"                                        ,oFont8)   
oPrint:Say  (2290,805 ,"R$"                                             ,oFont10)  

oPrint:Say  (2260,1005,"Quantidade"                                     ,oFont8) 
oPrint:Say  (2260,1555,"Valor"                                          ,oFont8)            

oPrint:Say  (2260,1910,"(=)Valor do Documento"                          ,oFont8)                     

If aDadosBanco[1] == "341"
	oPrint:Say  (2290,2060,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
Else    
	oPrint:Say  (2290,2045,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
Endif	

If aDadosBanco[1] == "341"
	oPrint:Say  (2330,100 ,"InstruÁıes/Todos as informaÁıes deste bloqueto s„o de exclusiva responsabilidade do benefici·rio",oFont8)     
Else
	oPrint:Say  (2330,100 ,"InstruÁıes/Texto de responsabilidade do benefici·rio",oFont8)
Endif

If aDadosBanco[1] == "341"
	oPrint:Say  (2360,2060,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
Else    
	oPrint:Say  (2360,2045,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
Endif	

oPrint:Say  (2370,100 ,cInst0 ,oFontCN)     
oPrint:Say  (2400,100 ,cInst1 ,oFontCN)     
oPrint:Say  (2430,100 ,cInst2 ,oFontCN)  
oPrint:Say  (2460,100 ,cInst3 ,oFontCN)  
oPrint:Say  (2480,100 ,aBolText[1],oFontCN)     
oPrint:Say  (2530,100 ,aBolText[2],oFontCN)     
oPrint:Say  (2580,100 ,aBolText[3],oFontCN)    

oPrint:Say  (2330,1910,"(-)Desconto/Abatimento"                         ,oFont8) 
oPrint:Say  (2400,1910,"(-)Outras DeduÁıes"                             ,oFont8)
oPrint:Say  (2470,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (2540,1910,"(+)Outros AcrÈscimos"                           ,oFont8)
oPrint:Say  (2610,1910,"(=)Valor Cobrado"                               ,oFont8)

oPrint:Say  (2680,100 ,"Pagador"                                         ,oFont8) 
oPrint:Say  (2708,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
oPrint:Say  (2748,210 ,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (2788,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

If aDadosBanco[1] == "422"
	oPrint:Say  (1525,100 ,"Sacador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)  
	oPrint:Say  (2830,100 ,"Sacador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)  
Else
	oPrint:Say  (1525,100 ,"Pagador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)   
EndIf

oPrint:Say  (2830,1500,"AutenticaÁ„o Mec‚nica -"                        ,oFont8)  

If aDadosBanco[1] == "341"
	oPrint:Say  (2830,1850,"Ficha de CompensaÁ„o"                       ,oFont8)
Else
	oPrint:Say  (2830,1850,"Ficha de CompensaÁ„o"                       ,oFont10)
Endif

oPrint:Line (1990,1900,2680,1900 )
oPrint:Line (2400,1900,2400,2300 )
oPrint:Line (2470,1900,2470,2300 )
oPrint:Line (2540,1900,2540,2300 )
oPrint:Line (2610,1900,2610,2300 )  
oPrint:Line (2680,100 ,2680,2300 )

oPrint:Line (2825,100,2825,2300  )     

MSBAR("INT25"  ,25.9,1.5,CB_RN_NN[1],oPrint,.F.,,,0.0253,1.6,,,,.F.)   
//MSBAR("INT25"  ,25,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.6,,,,.F.)
//MSBAR("INT25"  ,12.5,0.40,CB_RN_NN[1],oPrint,.F.,,,0.023,1.4,,,,.F.)   

*/
/*
MSBAR("INT25"  , 21  ,  3 ,"123456789012",oPr,,,.t.)
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø±±
±±≥Parametros≥ 01 cTypeBar String com o tipo do codigo de barras          ≥±±
±±≥          ≥             "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ≥±±
±±≥          ≥             "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"    ≥±±
±±≥          ≥ 02 nRow     Numero da Linha em centimentros                ≥±±
±±≥          ≥ 03 nCol     Numero da coluna em centimentros               ≥±±
±±≥          ≥ 04 cCode    String com o conteudo do codigo                ≥±±
±±≥          ≥ 05 oPr      Objeto Printer                                 ≥±±
±±≥          ≥ 06 lcheck   Se calcula o digito de controle                ≥±±
±±≥          ≥ 07 Cor      Numero  da Cor, utilize a "common.ch"          ≥±±
±±≥          ≥ 08 lHort    Se imprime na Horizontal                       ≥±±
±±≥          ≥ 09 nWidth   Numero do Tamanho da barra em centimetros      ≥±±
±±≥          ≥ 10 nHeigth  Numero da Altura da barra em milimetros        ≥±±
±±≥          ≥ 11 lBanner  Se imprime o linha em baixo do codigo          ≥±±
±±≥          ≥ 12 cFont    String com o tipo de fonte                     ≥±±
±±≥          ≥ 13 cMode    String com o modo do codigo de barras CODE128  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

      
oPrint:EndPage()
//
Return Nil
/*/
_____________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶                                               
¶¶¶Programa  ¶  boletos ¶ Autor ¶ Datamanager           ¶ Data ¶          ¶¶¶                              
¶¶+----------+------------------------------------------------------------¶¶¶                                               
¶¶¶DescriÁ‡o ¶ Rotinas Genericas                                          ¶¶¶
¶¶+----------+------------------------------------------------------------¶¶¶
¶¶¶Uso       ¶ Especifico para Clientes Microsiga                         ¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
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
_____________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶                                               
¶¶¶Programa  ¶  boletos ¶ Autor ¶ Datamanager           ¶ Data ¶          ¶¶¶                              
¶¶+----------+------------------------------------------------------------¶¶¶                                               
¶¶¶DescriÁ‡o ¶ Rotinas Genericas                                          ¶¶¶
¶¶+----------+------------------------------------------------------------¶¶¶
¶¶¶Uso       ¶ Especifico para Clientes Microsiga                         ¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
/*/
static Function Modulo11(cData,cBanc)

Local L, D, P := 0     

cData:=alltrim(cData)                    

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
   If len(cData) > 20
   		If D == 10 .or. D == 11 .or. D == 0
    		  D := "1"
   		Else
              D := AllTrim(Str(D))
		End
   Else 
	    If D == 10
		      D := "X"
   		Else
      		  D := AllTrim(Str(D))
	    End           
   Endif	           
ElseIf cBanc == "341" .Or. cBanc == "453" .or. cBanc == "224" // Itau/Mercantil/Rural/Safra
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
   
   If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422" .or. cBanc == "224")
      D := 1
   End
   If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
      D := 0
   End
   D := AllTrim(Str(D))
ElseIf  cBanc == "422"
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
   
   If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422" .or. cBanc == "224")
      D := 1
   End
   If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
      D := 0
   End
   D := AllTrim(Str(D))

ElseIf cBanc == "237"
   Q := If(len(cData) > 20,9,7)
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = Q 
         P := 1
      End
      L := L - 1
   End
   D := 11 - (mod(D,11))  
   
   If     D == 10  
		If Len(cData) > 20
			D := '1'
		Else	
   	  		D := 'P'
   	  	Endif	
   ElseIf D == 11
		If Len(cData) > 20
			D := '1'
		Else	   
	        D := '0'
	    Endif    	      
   ElseIf D == 0
		If Len(cData) > 20
			D := '1'
		Else	   
	        D := '0'
	    Endif    	      	    
   Else
	  D := AllTrim(Str(D))         
   End           
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
   	If Len(cData) > 20
      D := 1   	
   	Else
      D := 0
    Endif  
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
ElseIf  cBanc == "399"  //HSBC
   Q := If(len(cData) > 20,9,7)
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = Q 
         P := 1
      End
      L := L - 1
   End
   D := (mod(D,11))        //Alterado em 13/04 - os digitos 0 e 1 estavam inconsistentes de acordo com o calculo
   If (D == 0 .Or. D == 1)
   	If Len(cData) > 20
   	  D := 1	
	Else   
      D := 0
    Endif  
   Else
	  D := 11 - (mod(D,11))      
   End
   D := AllTrim(Str(D))
ElseIf cBanc == "084"  //UNIPRIME
   L := Len(cdata)
   D := 0
   P := 1
   While L > 0 
      P := P + 1
      D := D + (Val(SubStr(cData, L, 1)) * P)
      If P = 7 
         P := 1
      End
      L := L - 1
   End
   D := 11 - (mod(D,11))
   If (D == 10 .Or. D == 11)
      D := 1
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
//Retorna os strings para inpress„o do Boleto
//CB = String para o cÛd.barras, RN = String com o n˙mero digit·vel
//CobranÁa n„o identificada, n˙mero do boleto = TÌtulo + Parcela
/*/
_____________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶                                               
¶¶¶Programa  ¶  boletos ¶ Autor ¶ Datamanager           ¶ Data ¶          ¶¶¶                              
¶¶+----------+------------------------------------------------------------¶¶¶                                               
¶¶¶DescriÁ‡o ¶ Rotinas Genericas                                          ¶¶¶
¶¶+----------+------------------------------------------------------------¶¶¶
¶¶¶Uso       ¶ Especifico para Clientes Microsiga                         ¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,6)),6)
Local cNumSeq := strzero(val(cSequencial),5)
Local blvalorfinal := strzero(round(nValor*100,10),10)
Local cCpoLivre := cCBSemDig := cCodBarra := cFatVenc := ''
Local cNossoNum
Local _cDigito := ""
Local _cSuperDig := ""

_cParcela := NumParcela(_cParcela)

//Fator Vencimento - POSICAO DE 06 A 09
cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)

//Proximo numero da faixa
pNumero := val(SEE->EE_FAXATU)

//Campo Livre (Definir campo livre com cada banco)

If Substr(cBanco,1,3) == "001"  // Banco do brasil

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		cNNumSDig := strzero(pNumero,10)
				
	else
	             
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
		
	endif
		
	//Nosso Numero com digito
	cNumbco	:= Alltrim(cconvenio)+cNNumSDig 
	//cNNumSDig := Alltrim(cconvenio)+cNNumSDig 
	cNNum   := cNumbco  + modulo11(cNumbco,SubStr(cBanco,1,3))

	//Nosso Numero para impressao
	cNossoNum := cvaltochar(cNumbco) + "-" + modulo11(cNumbco,SubStr(cBanco,1,3))

	//cContNum := cNNumSDig //strzero(val(cNNumSDig),10)cContNum
	//cCpoLivre := substr(cconvenio,1,4)+strzero(val(cNNumSDig),7) + cAgencia + StrZero(Val(cConta),8) + cCarteira
	cCpoLivre := cNumbco + cAgencia + StrZero(Val(cConta),8) + cCarteira
	
	//cCpoLivre := Alltrim(cconvenio) + cAgencia + StrZero(Val(cConta),8) + cNNumSDig //cCarteira
	//cCpoLivre := strzero(val(cNNumSDig),11) + cAgencia + StrZero(Val(cConta),8) + cCarteira
	//cCpoLivre := strzero(val(cContNum),11) + cAgencia + StrZero(Val(cConta),8) + cCarteira


ElseIf Substr(cBanco,1,3) == "033"  // Banespa

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
//		cNNumSDig := AllTrim(cConvenio)+strzero(pNumero,10)
		cNNumSDig := strzero(pNumero,12)
				
	else
	             
		cNNumSDig := substr(alltrim(SE1->E1_NUMBCO),1,12)  //alteracao 13-08-2014 erro nosso numero santander
		
	endif
		
	//Nosso Numero com digito
	cNumbco	:= cNNumSDig 
	cNNum   := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

	//Nosso Numero para impressao
	cNossoNum := cNNumSDig + "-" + modulo11(cNNumSDig,SubStr(cBanco,1,3))

//	cCpoLivre := cNNumSDig + cAgencia + StrZero(Val(cConta),8) + cCarteira

	cCpoLivre := "9" + strzero(val(substr(cConvenio,9,7)),7) + strzero(val(cNNumSDig),12) + modulo11(cNNumSDig,SubStr(cBanco,1,3)) + '0' + cCarteira 


Elseif Substr(cBanco,1,3) == "422"  // Banco Safra --- Ajustado nosso n˙mero com 8 posiÁıes

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		//cNNumSDig := alltrim(str(pNumero,10))
		cNNumSDig := STRZERO(pNumero,9)		
	else
	             
		//cNNumSDig := alltrim(str(val(SE1->E1_NUMBCO),10))
		cNNumSDig := STRZERO(val(SE1->E1_NUMBCO),9)
	endif
	
	//Nosso Numero
	cNumbco	:= cNNumSDig 	
	cNNum := cNNumSDig //+ modulo11(cNNumSDig,SubStr(cBanco,1,3))
	
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig + "-" + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	//cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10) + cDacCC + cNNum + "2"
	cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10) + cNNum + "2"

Elseif Substr(cBanco,1,3) == "237" // Banco Bradesco    -- CARTEIRA + SEQUENCIAL COM 11 POSI«’ES

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
//		pNumero   := val(cCarteira + bldocnufinal)	
//		cNNumSDig := cCarteira + bldocnufinal

		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		cNNumSDig := strzero(pNumero,11)

				
	else
	             
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
		
	endif             
	
	cCarteira := alltrim(cCarteira)

	//Nosso Numero sem digito
	cNumbco	:= cNNumSDig 		                 	
//	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))	
	
	//Nosso Numero
//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	cNNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))	 
	
	//Nosso Numero para impressao
//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	cNossoNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))	

	cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"   

	Elseif Substr(cBanco,1,3) == "084" // Banco Bradesco    -- CARTEIRA + SEQUENCIAL COM 11 POSI«’ES

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
//		pNumero   := val(cCarteira + bldocnufinal)	
//		cNNumSDig := cCarteira + bldocnufinal

		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		cNNumSDig := strzero(pNumero,11)

				
	else
	             
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
		
	endif             
	
	cCarteira := alltrim(cCarteira)

	//Nosso Numero sem digito
	cNumbco	:= cNNumSDig 		                 	
//	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))	
	
	//Nosso Numero
//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	cNNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))	 
	
	//Nosso Numero para impressao
//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
	cNossoNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))	

	cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"   
	
Elseif Substr(cBanco,1,3) == "341"  // Banco Itau

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
//		pNumero   := val(cCarteira+strzero(val(cNroDoc),6)+ _cParcela)	
//		cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela

		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		cNNumSDig := alltrim(str(pNumero,10))
				
	else
	             
		cNNumSDig := alltrim(str(val(SE1->E1_NUMBCO),10))
		
	endif

	//Nosso Numero
	cNumbco	:= strzero(val(cNNumSDig),8) 		 
	cNNumSDig := cCarteira + cNumbco  		
//	cNNum := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
	
	//Nosso Numero para impressao
//	cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
	cCalcDig      := AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
	cNossoNum := cCarteira + '/' + cNumbco + '-' + cCalcDig
	
	cCpoLivre := cNNumSDig + cCalcDig + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cDacCC + "000"

Elseif Substr(cBanco,1,3) == "356" // Banco REAL

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		cNNumSDig := strzero(pNumero,13)
				
	else
	             
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
		
	endif
	
	//Nosso Numero
	cNumbco	:= cNNumSDig 		
	cNNum   := cNNumSDig       
	
	//Nosso Numero para impressao
	cNossoNum := cNNum
	cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig

Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC

	//Nosso Numero sem digito
	if empty(SE1->E1_NUMBCO)
	
		pNumero := val(SEE->EE_FAXATU) + 1		                          		
	
		cNNumSDig := strzero(pNumero,10)  //CODIGO CONVENIO COM 5 + SEQUENCIAL COM 5
				
	else
	             
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
		
	endif

	//Nosso Numero
	cNumbco	:= cNNumSDig 			
	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
	
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

	cCpoLivre := cNNum + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),6) + cDacCC + "001"
		
Elseif Substr(cBanco,1,3) == "389" // Banco mercantil

	pNumero := val(SEE->EE_FAXATU) + 1		                          		

	//Nosso Numero sem digito
	cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
	//Nosso Numero
	cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
	//Nosso Numero para impressao
	cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))

	cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")

Elseif Substr(cBanco,1,3) == "453"  // Banco rural

	pNumero := val(SEE->EE_FAXATU) + 1		                          			
	
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),7)
	//Nosso Numero
	cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
	//Nosso Numero para impressao
	cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )

	cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"

Elseif Substr(cBanco,1,3) == "479" // Banco Boston

	pNumero := val(SEE->EE_FAXATU) + 1		                          		

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

	if empty(SE1->E1_NUMBCO)
	
		cNNumSDig := strzero(val(SEE->EE_FAXATU) + 1,10)
		pNumero   := val(SEE->EE_FAXATU) + 1		                          		
					
	else
	             
		cNNumSDig := alltrim(SE1->E1_NUMBCO)
		
	endif

	_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3)) 
	
	//Calculo do super digito
	cSSu := '1'
	_cSuperDig := modulo11(cSSu+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
	cNNum := cSSu+cNNumSDig + _cDigito + _cSuperDig
	
	//Nosso Numero para impressao
	cNossoNum := cSSu + "/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig
	
	// O codigo fixo "04" e para a cobranÁa com registro
	// O codigo fixo "06" e para a cauÁ„o
	cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig
		
Endif	

//Dados para Calcular o Dig Verificador Geral
ccalcg := ''
If substr(cBanco,1,3) == '001'
	ccalcg := cBanco + cFatVenc + blvalorfinal + SUBSTR(cCpoLivre,1,4)+SUBSTR(CCPOLIVRE,11,7)+SUBSTR(CCPOLIVRE,18,4)+SUBSTR(CCPOLIVRE,22,10)//cCpoLivre         
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + '000000' + alltrim(cconvenio) + cNnumsdig + cCarteira
else
	cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
endif
//Codigo de Barras Completo
If substr(cBanco,1,3) <> '084'
	If substr(cBanco,1,3) == '001'
		cCodBarra := cBanco + modulo11(cCBSemDig,substr(cBanco,1,3)) + cFatVenc + blvalorfinal + '000000' + alltrim(cconvenio) + cNnumsdig + cCarteira
	Else
		cCodBarra := cBanco + modulo11(cCBSemDig,substr(cBanco,1,3)) + cFatVenc + blvalorfinal +cCpoLivre      
	EndIf
Else
	cCodBarra := cBanco + modulo11(cCBSemDig,'999') + cFatVenc + blvalorfinal + cCpoLivre      
EndIf
//Digito Verificador do Primeiro Campo         
cPrCpo := cBanco + SubStr(cCodBarra,20,5)
cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))

//Digito Verificador do Segundo Campo
cSgCpo := SubStr(cCodBarra,25,10)
cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))

//Digito Verificador do Terceiro Campo
cTrCpo := SubStr(cCodBarra,35,10)  //35,10
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

If substr(cbanco,1,3) == "422"
	cNossoNum := substr(cNossoNum,1,9)
ENDIF

Return({cCodBarra,cLinDig,cNossoNum})

/*
	Imprimir boleto avulso
*/
User Function PPBolAv

Local aPergs 	:=	{}
Local aRet	 	:=	{}
Local cTitulo	:=	space(9)
Local cPref 	:=	space(3)

If Empty(FunName())
	RpcSetType(3)
	RPCSetEnv("01","0101")
EndIf

aAdd(aPergs ,{1,"Nota?	"			,cTitulo	  ,'@!',"","","",70,.F.})
aAdd(aPergs ,{1,"Serie?	"			,cPref	  ,'@!',"","","",70,.F.})

If ParamBox(aPergs ,"Filtro",aRet)
	MV_PAR01 := aRet[2]
	MV_PAR02 := aRet[1]

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR02)

	U_PILBOL2(.T.,'C:\TEMP\')
EndIf

Return
/*/
_____________________________________________________________________________
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶                                               
¶¶¶Programa  ¶  boletos ¶ Autor ¶ Datamanager           ¶ Data ¶          ¶¶¶                              
¶¶+----------+------------------------------------------------------------¶¶¶                                               
¶¶¶DescriÁ‡o ¶ Rotinas Genericas                                          ¶¶¶
¶¶+----------+------------------------------------------------------------¶¶¶
¶¶¶Uso       ¶ Especifico para Clientes Microsiga                         ¶¶¶
¶¶+-----------------------------------------------------------------------+¶¶
¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶
ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
/*/
Static Function NumParcela(_cParcela)

Local _cRet := ""

If ASC(_cParcela) >= 65 .or. ASC(_cParcela) <= 90
	_cRet := StrZero(Val(Chr(ASC(_cParcela)-16)),2)
Else
	_cRet := StrZero(Val(_cParcela),2)
Endif

Return(_cRet) 
