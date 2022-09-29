#include 'protheus.ch'
#include 'parmtype.ch'
#include 'rwmake.ch'
#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6
	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออออออหอออออออออออหอออออออหออออออออออออออออออออหออออออหอออออออออออออปฑฑ
ฑฑ?PROGRAMA     ?AMCFIN03  ?AUTOR ?                   ?DATA ?MARCO/2017  บฑ?
ฑฑฬออออออออออออออฮอออออออออออสอออออออสออออออออออออออออออออสออออออสอออออออออออออนฑฑ
ฑฑ?DESCRICAO    ?PROGRAMA ESPECIFICO PARA REEMISSAO DA IMPRESSAO DO          บฑ?
ฑฑ?             ?BOLETO DE COBRANCA DO BANCO ITAU, EM FORMATO GRAFICO        บฑ?
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออหออออออออนฑฑ
ฑฑ?TABS.UTILIZ  ?DESCRICAO                                          ?ACESSO บฑ?
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออฮออออออออนฑฑ
ฑฑ?  SA1010     ?CADASTRO DE CLIENTES                               ?READ   บฑ?
ฑฑ?  SA6010     ?CADASTRO DE BANCOS                                 ?READ   บฑ?
ฑฑ?  SE1010     ?CONTAS A RECEBER                                   ?WRITE  บฑ?
ฑฑฬออออออออออออออฮออออออออออออออออออออออออออออออออออออออออออออออออออออสออออออออนฑฑ
ฑฑ?HISTORICO    ?(MAR/2017) ELABORACAO DE PROGRAMA INICIAL - ALEX (REV. 00)  บฑ?
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?USO          ?ESPECIFICO  - CONTROLE DE LOJAS/FINANCEIRO.                 บฑ?
ฑฑฬออออออออออออออฮอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ?PROPRIETARIO ?CUSTOMIZADO PARA AMC                                        บฑ?
ฑฑศออออออออออออออสอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function AMCFIN03()

LOCAL	aPergs := {} 
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
PRIVATE _nTxper := GETMV("MV_XTAXA")
PRIVATE _nMulta := GETMV("MV_XMULTA") 

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras-Banco do Brasil"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBAR    "
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

If cEmpAnt <> "10"
	Return
EndIf

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",3,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",3,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chb","C",4,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_chc","C",4,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Para Banco","","","mv_chj","C",3,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
//Aadd(aPergs,{"Para Ag๊ncia","","","mv_chk","C",6,0,0,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Para Conta","","","mv_chl","C",15,0,0,"G","","MV_PAR21","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//Aadd(aPergs,{"Linha Obs 1","","","mv_chj","C",60,0,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Linha Obs 2","","","mv_chj","C",60,0,0,"G","","MV_PAR20","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aPergs,{"Linha Obs 3","","","mv_chj","C",60,0,0,"G","","MV_PAR21","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1("BLTBAR    ",aPergs)

if !Pergunte (cPerg,.T.)
   Return
EndIf    

//LimpaFlag()

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)+E1_PORTADO+E1_CLIENTE"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM)" //.And."
//cFilter		+= "E1_PORTADO<>'   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF

dbGoTop()

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Sele็ใo de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑ?
ฑฑบPrograma  ณAMCFIN03  บAutor  ณMicrosiga           ?Data ? 03/14/17   บฑ?
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑ?
ฑฑบDesc.     ?                                                           บฑ?
ฑฑ?         ?                                                           บฑ?
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑ?
ฑฑบUso       ?AP                                                         บฑ?
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
*/
Static Function MontaRel()
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\SIGAADV\ITAU.BMP"

LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
							SM0->M0_ENDCOB                                                              ,; //[2]Endere็o
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
						"Ap๓s o vencimento cobrar Mora Diaria de R$",;  //"Ap๓s Vencimento Aplicar Mora de "+cvaltochar(_nTxper)+"% a.m" - Alterado por Ronaldo Gomes - 17/03/2017                                  ,;
						"Ap๓s Vencimento Aplicar Multa de 2% - R$" ,; //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"} - Alterado por Ronaldo Gomes - 17/03/2017
						GetMV("MV_XMSGBL1") ,;  //Mensagem 1 para boleto - Alexandre 14/03/2018 Solicitado Viviane
						GetMV("MV_XMSGBL2")}  //Mensagem 2 para boleto - Alexandre 14/03/2018 Solicitado Viviane
                           //Ajustar, trocar para mv_par     aqui
// "Ap๓s o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ""
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.

oPrint 	:= FWMSPrinter():New("Boleto_"+strzero(VAL(MV_PAR02),9)+".rel",  IMP_PDF, lAdjustToLegacy, "\", lDisableSetup,,,,.F.,,,.T.)

oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:StartPage()   	// Inicia uma nova pแgina
oPrint:SetMargin(60,60,60,60)
//oPrint:cPathPDF := "C:\Temp" //"\_AMC\Nota_Debito\"

DbSelectArea("SE1")
dbGotop()

ProcRegua(RecCount())

While SE1->(!EOF()) 
	IncProc()
	
    //Quando nao estiver selecionado despreza o registro
    If !Marked("E1_OK")
       DbSkip()
       Loop
    EndIf  

    IF  ALLTRIM(SE1->E1_PORTADO) <> ""
       If ALLTRIM(SE1->E1_PORTADO) # "341"
          DbSkip()
          Loop
       EndIf 
    EndIf     

	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	//DbSeek(xFilial("SA6")+MV_PAR19+MV_PAR20+MV_PAR21,.T.)
	//

if cfilant == "01"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Ita?S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Ag๊ncia
						"13614          "				,; // [4]Conta Corrente
						"1"  					,; // [5]Dํgito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */

Elseif cfilant == "03"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Ita?S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Ag๊ncia
						"13979          "				,; // [4]Conta Corrente
						"8"  					,; // [5]Dํgito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */

Elseif cfilant == "04"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Ita?S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Ag๊ncia
						"14036          "				,; // [4]Conta Corrente
						"6"  					,; // [5]Dํgito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */    
    
Elseif cfilant == "02"
   
   	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Ita?S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Ag๊ncia
						"14157          "				,; // [4]Conta Corrente
						"0"  					,; // [5]Dํgito da conta corrente
						"109"                  }  // [6]Codigo da Carteira */ 

Endif		


	DO CASE
		CASE Alltrim(SE1->E1_PARCELA) == "A"
			cParcela := "10"
		CASE Alltrim(SE1->E1_PARCELA) == "B"
			cParcela := "11"                                           
		CASE Alltrim(SE1->E1_PARCELA) == "C"
			cParcela := "12"
		CASE Alltrim(SE1->E1_PARCELA) == "D"
			cParcela := "13"
		CASE Alltrim(SE1->E1_PARCELA) == "E"
			cParcela := "14"
		CASE Alltrim(SE1->E1_PARCELA) == "F"
			cParcela := "15"
		CASE Alltrim(SE1->E1_PARCELA) == "G"
			cParcela := "16"
		CASE Alltrim(SE1->E1_PARCELA) == "H"
			cParcela := "17"
		CASE Alltrim(SE1->E1_PARCELA) == "I"
			cParcela := "18"
		OTHERWISE
			cParcela := Alltrim(SE1->E1_PARCELA)
	ENDCASE
	//
	//
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	//
	DbSelectArea("SE1")
	//
/*	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
						"Banco Ita?S.A."      ,; // [2]Nome do Banco
						"5589  "                 ,; // [3]Ag๊ncia
						"13614          "				,; // [4]Conta Corrente
						"1"  					,; // [5]Dํgito da conta corrente
						"109"                  }  // [6]Codigo da Carteira*/
						
/*	

aDadosBanco  := {SA6->A6_COD					,;				// [1]Numero do Banco
				     SA6->A6_NREDUZ					,;  			// [2]Nome do Banco
	                 SA6->A6_AGENCIA				,; 				// [3]Ag๊ncia
                     SA6->A6_NUMCON					,; 			    // [4]Conta Corrente
                     SA6->A6_DVCTA	  				,;    	  // [5]Dํgito da conta corrente
                     "109"}																		   	  // [6]Codigo da Carteira 
*/
	//
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Razใo Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]C๓digo
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endere็o
		AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
		SA1->A1_EST                                       ,;     // [5]Estado
		SA1->A1_CEP                                       ,;     // [6]CEP
		SA1->A1_CGC									  ,;       // [7]CGC
		SA1->A1_INSCR									}		//[8]IE
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Razใo Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]C๓digo
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endere็o
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		SA1->A1_CEPC                                         ,;   // [6]CEP
		SA1->A1_CGC										    ,;   // [7]CGC
		SA1->A1_INSCR										}	// [8]IE
	Endif
	
	//If aMarked[i]
	_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	
	//Nosso Numero
	//	_cNossoNum := cFilant + substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5) + cParcela //Composicao Filial + Titulo + Parcela
	If len(cParcela) > 1
		nTamP := 5
	Else
		nTamP := 6
	EndIF
	
	If Alltrim(SUBSTR(SE1->E1_PREFIXO,3,1)) $ "D"
			_cNossoNum := Substr(cFilant,2,1)+"4"+substr((strzero(Val(Alltrim(SE1->E1_NUM)),nTamP)),2,5)+cParcela //Composicao Somente para Serie D + + Titulo + Parcela	
	Else			
			_cNossoNum := Substr(cFilant,2,1)+Substr(SE1->E1_PREFIXO,3,1)+substr((strzero(Val(Alltrim(SE1->E1_NUM)),nTamP)),2,5)+cParcela //Composicao Filial Posi็ใo 2+Prefixo Posi็ใo 3+ Titulo + Parcela
	Endif
	
	//Linha digitavel
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(E1_VALOR-_nVlrAbat),Datavalida(E1_VENCTO,.T.))
	//Dados do titulo
	aDadosTit    := {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)					,;  // [1] N๚mero do tํtulo
						E1_EMISSAO                              			,;  // [2] Data da emissใo do tํtulo
						Date()                                  			,;  // [3] Data da emissใo do boleto
						Datavalida(E1_VENCREA,.T.)                  		,;  // [4] Data do vencimento
						(E1_SALDO - _nVlrAbat)                  			,;  // [5] Valor do tํtulo                       
						CB_RN_NN[3]                             			,;  // [6] Nosso n๚mero (Ver f๓rmula para calculo)
						E1_PREFIXO                               			,;  // [7] Prefixo da NF
						E1_TIPO	                               				}  	// [8] Tipo do Titulo
	//
	DbSelectArea("SE1")
	If Marked("E1_OK")
		Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN) 
		oPrint:StartPage()   // Inicia uma nova pแgina
		n := n + 1
	EndIf
	
	dbSkip()
	IncProc()
	i := i + 1
EndDo
//            

oPrint:EndPage()     // Finaliza a pแgina
oPrint:Preview()     // Visualiza antes de imprimir
Return nil
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑ?
ฑฑณFun…o    ณImpress      ณDescriใoณImpressao de Boleto Grafico do Bancoณฑ?
ฑฑ?         ?            ?        ณItau.                               ณฑ?
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
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

//Parโmetros de TFont.New()
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
//oPrint:StartPage()   // Inicia uma nova pแgina
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

oPrint:Box(000,180,0120,650, "-2")   //Cabe็alho
oPrint:Line(000,415,0120,415)          

oPrint:Line (015,180,015,650 )  //1
oPrint:Line (030,180,030,650 )  //2
oPrint:Line (045,180,045,650 )  //3
oPrint:Line (060,180,060,650 )  //4
oPrint:Line (075,415,075,650 )  //5
oPrint:Line (090,180,090,650 )  //6
oPrint:Line (105,180,105,650 )  //7
  
oPrint:Say(005,0181,'Beneficiแrio'							,oFont5)
oPrint:Say(013,0183,aDadosEmp[1]							,oFont8)

oPrint:Say(005,0416,'Vencimento'							,oFont5)
oPrint:Say(013,0580,DTOC(aDadosTit[4])                      ,oFont8)

oPrint:Say(020,0181,'Data do Documento'						,oFont5)
oPrint:Say(028,0183,DTOC(aDadosTit[2])						,oFont7)

oPrint:Say(020,0416,'Nosso N๚mero'							,oFont5)
oPrint:Say(028,0530,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont8)

oPrint:Say(035,0181,'N?do documento'						,oFont5)
oPrint:Say(043,0183 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont8) //Prefixo +Numero+Parcela

oPrint:Say(035,0416,'(=) Valor do documento'				,oFont5)
oPrint:Say(043,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont9N)
         
//oPrint:Say(050,0181,''						,oFont5)
oPrint:Say(050,0416,'(-) Desconto'							,oFont5)           

oPrint:Say(065,0416,'(-) Outras Dedu็๕es/Abatimento'		,oFont5)
oPrint:Say(067,0265,'Para agilizar o atendimento'			,oFont7)

oPrint:Say(080,0416,'(+) Mora/Multa/Juros'					,oFont5)
oPrint:Say(077,0247,'informe o seu c๓digo de cliente abaixo:',oFont7)

oPrint:Say(095,0416,'(+) Outros Acr้scimos'					,oFont5)  
oPrint:Say(087,0278,aDatSacado[2]							,oFont8)  

oPrint:Say(110,0416,'(=) Valor Cobrado'						,oFont5)


//  *************************     RECIBO DO PAGADOR     *********************

oPrint:Line (0146,043,0130,043)  //linha que separa o logo do nome do banco
oPrint:Line (0146,125,0130,125)  //linha que separa o nome do banco do numero 341
oPrint:Line (0146,225,0130,225) // linha que separa 341 do codigo de barras

//Caixa parte pagador do boleto        
oPrint:Box(0146,010,0350,650, "-4")   //Cabe็alho

// LOGOTIPO  
If File(aBmp)
	oPrint:SayBitmap( 0113,011,aBmp,030,030 )
	oPrint:Say  (0142,045,"Banco Ita?SA",oFont14n )	// [2]Nome do Banco
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
oPrint:Line (0300,10,0300,650 )	 //linha instru็๕es

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
oPrint:Say  (0164,014 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAฺ. APำS O VENCIMENTO, SOMENTE NO ITAฺ",oFont11n)

oPrint:Say  (0177,014 ,"Beneficiแrio"			   					 ,oFont9)
oPrint:Say  (0188,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0177,512 ,"Ag๊ncia/C๓digo Beneficiแrio"				 ,oFont9)
oPrint:Say  (0188,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0199,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0210,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0199,092 ,"N?do Documento"							 ,oFont9)
oPrint:Say  (0210,092 ,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0199,257 ,"Esp้cie Doc"								 ,oFont9)
oPrint:Say  (0210,258,aDadosTit[8]									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0199,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0210,0357,"N"                                           ,oFont10)

oPrint:Say  (0199,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0210,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0199,512 ,"Nosso N๚mero"								 ,oFont9)
oPrint:Say  (0210,0580,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (0221,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0221,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0232,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0221,257 ,"Esp้cie"				   					 ,oFont9)
oPrint:Say  (0232,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0221,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0221,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0221,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0232,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
                                
oPrint:Say  (0243,014 ,"Instru็๕es: (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio)" ,oFont9)
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

//oPrint:Say  (nP1,014 ,aBolText[5]       ,oFont10) // Incluido por Alexandre - 14/03/2018 

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
//Inscri็ใo estadual
oPrint:Say  (0327,510,aDatSacado[8] ,oFont10)

oPrint:Say  (0348,510 ,"C๓d. de Baixa" 						 	     ,oFont9)
                    
oPrint:Say  (0360,450 ,"Autentica็ใo Mecโnica" 						 ,oFont9I)
oPrint:Say  (0360,014 ,"Esta quita็ใo s?ter?validade ap๓s o pagamento do cheque pelo banco Pagador.",oFont5)
oPrint:Say  (0365,014 ,"Ate o vencimento pagแvel em qualquer ag๊ncia bancแria.",oFont5)
// ****************************                

//Separa็ใo da nota de debito ou inicio do boleto com a parte destacavel
oPrint:Say  (0390, 020, REPLICATE( '- ', 136 ), oFont9)
//Caixa parte pagador do boleto        
oPrint:Box(0431,010,0698,650, "-4")   //Cabe็alho

// LOGOTIPO  
If File(aBmp)
	oPrint:SayBitmap( 0400,011,aBmp,030,030 )
	oPrint:Say  (0418,045,"Banco Ita?SA",oFont14n )	// [2]Nome do Banco
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
oPrint:Line (0634,10,0634,650 )	 //linha instru็๕es

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

oPrint:Say  (0450,014 ,"ATษ O VENCIMENTO, PREFERENCIALMENTE NO ITAฺ. APำS O VENCIMENTO, SOMENTE NO ITAฺ",oFont11n)

oPrint:Say  (0466,014 ,"Beneficiแrio"			   					 ,oFont9)
oPrint:Say  (0477,014 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (0466,512 ,"Ag๊ncia/C๓digo Beneficiแrio"				 ,oFont9)
oPrint:Say  (0477,580,Alltrim(aDadosBanco[3])+"/"+Alltrim(aDadosBanco[4])+"-"+Alltrim(aDadosBanco[5]),oFont10)

oPrint:Say  (0488,014 ,"Data do Documento"		   					 ,oFont9)
oPrint:Say  (0499,014 ,DTOC(aDadosTit[2])                            ,oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say  (0488,092 ,"N?do Documento"							 ,oFont9)
oPrint:Say  (0499,092 ,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0488,257 ,"Esp้cie Doc"								 ,oFont9)
oPrint:Say  (0499,258,aDadosTit[8]									 ,oFont10) //Tipo do Titulo

oPrint:Say  (0488,337 ,"Aceite"										 ,oFont9)
oPrint:Say  (0499,0357,"N"                                           ,oFont10)

oPrint:Say  (0488,397 ,"Data do Processamento"						 ,oFont9)
oPrint:Say  (0499,0397,DTOC(aDadosTit[3])                            ,oFont10) // Data impressao

oPrint:Say  (0488,512 ,"Nosso N๚mero"								 ,oFont9)
oPrint:Say  (0499,0580,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (0514,014 ,"USO DO BANCO"			   					 ,oFont9)

oPrint:Say  (0510,092 ,"Carteira"				   					 ,oFont9)
oPrint:Say  (0521,092 ,aDadosBanco[6]                                ,oFont10)

oPrint:Say  (0510,257 ,"Esp้cie"				   					 ,oFont9)
oPrint:Say  (0521,258 ,"R$"                                          ,oFont10)

oPrint:Say  (0510,337 ,"Quantidade"				   					 ,oFont9)
oPrint:Say  (0510,427 ,"Valor"					   					 ,oFont9)
oPrint:Say  (0510,512 ,"(=) Valor do Documento"  					 ,oFont9)
oPrint:Say  (0521,0580,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
                                
oPrint:Say  (0532,014 ,"Instru็๕es: (Todas informa็๕es deste bloqueto sใo de exclusiva responsabilidade do Beneficiแrio)" ,oFont9)
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

oPrint:Say  (nP1,014 ,aBolText[5]       ,oFont10) // Incluido por Alexandre - 14/03/2018 

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
//Inscri็ใo estadual
oPrint:Say  (0665,510,aDatSacado[8] ,oFont10)

oPrint:Say  (0695,510 ,"C๓d. de Baixa" 						 	     ,oFont9)
                    
oPrint:Say  (0740,380 ,"Autentica็ใo Mecโnica" 						 ,oFont9I)

oPrint:Say  (0740,510 ,"FICHA DE COMPENSAวรO"  						 ,oFont10)


//Codigo de Barras    
oPrint:Code128c(0790, 030, CB_RN_NN[1], 040) 

//Gravar somente o NUMBCO AQUI
DbSelectArea("SE1")
DbSetOrder(1)
If Dbseek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO :=	Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)   // Nosso n๚mero (Ver f๓rmula para calculo)
	/*SE1->E1_PORTADO	:= 	"999"
	SE1->E1_AGEDEP 	:=  "999"
	SE1->E1_CONTA	:=  "99999-9"*/ 
	SE1->E1_CODBAR	:=	CB_RN_NN[2]
	//SE1->E1_SITUACA	:=	"1"
	MsUnlock()
EndIf
//
oPrint:EndPage() // Finaliza a pแgina
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑ?
ฑฑณFun…o    ?Modulo10    ณDescriใoณFaz a verificacao e geracao do digi-ณฑ?
ฑฑ?         ?            ?        ณto Verificador no Modulo 10.        ณฑ?
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑ?
ฑฑณFun…o    ?Modulo11    ณDescriใoณFaz a verificacao e geracao do digi-ณฑ?
ฑฑ?         ?            ?        ณto Verificador no Modulo 11.        ณฑ?
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
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
//Retorna os strings para inpressใo do Boleto
//CB = String para o c๓d.barras, RN = String com o n๚mero digitแvel
//Cobran็a nใo identificada, n๚mero do boleto = Tํtulo + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑ?
ฑฑณFun…o    ณRet_cBarra   ณDescriใoณGera a codificacao da Linha digitav.ณฑ?
ฑฑ?         ?            ?        ณgerando o codigo de barras.         ณฑ?
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
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
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑ?
ฑฑบPrograma  ณAMCFIN03  บAutor  ณMicrosiga           ?Data ? 03/14/17   บฑ?
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑ?
ฑฑบDesc.     ?                                                           บฑ?
ฑฑ?         ?                                                           บฑ?
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑ?
ฑฑบUso       ?AP                                                         บฑ?
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
*/

Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next