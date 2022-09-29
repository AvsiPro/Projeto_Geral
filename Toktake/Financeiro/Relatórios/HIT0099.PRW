//#INCLUDE "FINR133.CH"                                                                                                                                       
//#Include "FIVEWIN.Ch"
#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HIT0099 ³ Autor ³Jose Lucas/Diego Rivero³ Data ³ 09.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HIT0099(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Localizacoes paises ConeSul...                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function HIT0099()
Local oReport 


//If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport	:= ReportDef()
	oReport:PrintDialog()
/*Else
	HIT0099R32()
EndIf
*/
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Paulo Augusto          ³ Data ³28/06/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
Local oReport,oSection1,oSection2
Local cReport := "HIT0099"
Local cTitulo := OemToAnsi("mismos, o apenas los valores originales. ") 
Local cDescri := OemToAnsi("Este programa imprimir  la demsotraci¢n contable de Clientes.")+" "+OemToAnsi("Se puede  emitir  todo  el movimiento de los ")
Local nTamCli:= TamSx3("A1_NREDUZ")[1] 
Pergunte( "FIR133X" , .F. )
                   
oReport  := TReport():New( cReport, cTitulo, "FIR133X" , { |oReport| ReportPrint( oReport, "TRB" ) }, cDescri )
oReport:SetLandScape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a 1a. secao do relatorio Valores nas Moedas   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New( oReport,"Codigo" , {"TRB","SA1"},{"Nome Fantasia","Endereço","Nome Vendedor"},/*Campos do SX3*/,/*Campos do SIX*/)                      //"Cliente"
 
oSection2 := TRSection():New( oSection1,"Titulos a receber" , {"TRB","SE1"} ) //
TRCell():New( oSection2, "A1_COD" 	,"SA1" ,/*X3Titulo*/  ,/*Picture*/,TamSx3("A1_COD")[1]+TamSx3("A1_LOJA")[1],/*lPixel*/,{||TRB->CODIGO+"-"+TRB->LOJA})
TRCell():New( oSection2, "A1_NREDUZ","SA1" ,/*X3Titulo*/ ,/*Picture*/,nTamCli,/*lPixel*/,{||SA1->A1_NREDUZ})	

TRCell():New( oSection2, "CONDPG" 	,"" , /*X3Titulo()*/,PesqPict("SA1","A1_COND")/*Picture*/,15,/*lPixel*/,{||TRB->CONDPG })
TRCell():New( oSection2, "SALDOFIM"	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->SALDOFIM })
TRCell():New( oSection2, "VALOR02" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR02 })
TRCell():New( oSection2, "VALOR03" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR03 })
TRCell():New( oSection2, "VALOR04" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR04 })
TRCell():New( oSection2, "VALOR05" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR05 })
TRCell():New( oSection2, "VALOR06" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR06 })
TRCell():New( oSection2, "VALOR07" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR07 })
TRCell():New( oSection2, "VALOR08" 	,"" , /*X3Titulo()*/,PesqPict("SE1","E1_VALOR")/*Picture*/,15,/*lPixel*/,{||TRB->VALOR08 })

oSection2:Cell("CONDPG"):lHeaderSize	:=	.T.
oSection2:Cell("SALDOFIM"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR02"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR03"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR04"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR05"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR06"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR07"):lHeaderSize	:=	.T.
oSection2:Cell("VALOR08"):lHeaderSize	:=	.T.

Return oReport
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA133Imp ³ Autor ³ Lucas                 ³ Data ³ 11.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA133Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint( oReport )
Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local oBreak1 
Local nOrder	:=oReport:Section(1):GetOrder()
Local cIndice	:=	""
Local CbCont,CbTxt
Local nQuebra:=0,lImprAnt := .F.
Local cNome
Local aSaldos:={},j,dEmissao:=CTOD(""),dVencto:=CTOD("")
Local nRec,nPrim,cPrefixo,cNumero,cParcela,cNaturez,nValliq


Local nRegistro
Local lNoSkip:= .T.
Local lFlag  := .F.

Local aCampos:={},aTam:={}
Local aInd	 :={}
Local cCondE1:=cCondE5:=" "
Local cIndE1 :=cIndE5 :=cIndA1 :=" "
Local nRegAtu,lImprime
Local nRegSe1Atu := SE1->(RecNo())
Local nOrdSe1Atu := SE1->(IndexOrd())
Local lBaixa     := .F.
Local cChaveSe1
Local cRazSocial
Local cVendedor
Local cTelefone
Local	lPerg := .T., lChkDRef := .F.
Local 	I
Local cImpSldChq 
Local nTotCheque:=0
Local nAcumCh:=0
Local	nVlCli00	   
Local	nVlCli01	   
Local	nVlCli02	   
Local	nVlCli03	   
Local	nVlCli04	   
Local	nVlCli05	   
Local	nVlCli06	  
Local	nVlCli07	   
Local	nVlCli08	   
Local	nVlCli09	   
Local	nVlCli10	   
Local	nVlCli11	   
Local	nSalCliFim	             

mv_par07 := 0
mv_par08 := 2
mv_par09 := 0
mv_par10 := 1
mv_par11 := 1
mv_par12 := 2
mv_par13 := 1

Private cClieIni  := mv_par01
Private cClieFim  := mv_par02
Private dFechaIni := mv_par03
Private dFechaFim := Min(mv_par04,dDataBase)
Private nInforme  := mv_par05
Private nMoeda    := mv_par10
Private lConverte := (mv_par11==1)
Private nDecs     := MsDecimais(nMoeda)
Private dData01
Private dData02
Private dData03
Private dData04
Private dData05
Private dData06
Private dData07
Private dData08
Private dData09
Private dData10
Private dData11

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private dDataRef 	:= mv_par06
Private nPeriodos 	:= IIf(mv_par09==0,1,mv_par09)
Private nTipoPer	:= mv_par08
Private nPerAnt		:= 0 //IIf(mv_par07 > 9,9,mv_par07)
Private nImpSldChq	:= mv_par12
cImpSldChq := IIF(nImpSldChq == 1,'nInforme == 1 .And. TRB->TIPO <> "CH "',"nInforme == 1")

If nTipoPer == 3 //Informado
	lOk	:=	.T.
	While lOk
		If Pergunte("FI133B",.T.)
			lPerg := .T.
			For I:=1 to 10
            cData1 := ("mv_par"+StrZero(I,2))
            cData2 := ("mv_par"+StrZero(I+1,2))
				If  &cData1. >= &cData2.
					lPerg := .F.
					I:=10
				Endif
			Next
			If lPerg
				For I:=1 to 11
               cData1 := ("mv_par"+StrZero(I,2))
					If &cData1. == dDataRef
						lChkDRef := .T.
						I := 11
					Endif
				Next
				If !lChkDRef
					MsgStop(OemToAnsi("Uma das datas deve coincidir com a Data de Referencia")) //
					Loop
				Endif
			Endif

			If lPerg
            dData01  := mv_par01
            dData02  := mv_par02
            dData03  := mv_par03
            dData04  := mv_par04
            dData05  := mv_par05
            dData06  := mv_par06
            dData07  := mv_par07
            dData08  := mv_par08
            dData09  := mv_par09
            dData10  := mv_par10
            dData11  := mv_par11
				//para restaurar os valores nas MV_PAR originais
				Pergunte("FIR133X",.f.)
            lOk   := .F.
			Else
				MsgStop(OemToAnsi("Erro de sequencia nas datas")) //"Erro de sequencia nas datas"
			Endif
		Else
			Return .F.
		Endif
	Enddo
Else
	dData01 := Fr133Data(dDataRef,01,nPeriodos,nTipoPer,nPerAnt)
	dData02 := Fr133Data(dDataRef,02,nPeriodos,nTipoPer,nPerAnt)
	dData03 := Fr133Data(dDataRef,03,nPeriodos,nTipoPer,nPerAnt)
	dData04 := Fr133Data(dDataRef,04,nPeriodos,nTipoPer,nPerAnt)
	dData05 := Fr133Data(dDataRef,05,nPeriodos,nTipoPer,nPerAnt)
	dData06 := Fr133Data(dDataRef,06,nPeriodos,nTipoPer,nPerAnt)
	dData07 := Fr133Data(dDataRef,07,nPeriodos,nTipoPer,nPerAnt)
	dData08 := Fr133Data(dDataRef,08,nPeriodos,nTipoPer,nPerAnt)
EndIf


Private cNomeArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := OemToAnsi("ACCOUNT RECEIVABLE AGING LIST") //
Titulo += Space(1)
Titulo += OemToAnsi(" Emissão De: ")+DTOC(dFechaIni)+OemToAnsi("  Até : ")+DTOC(dFechaFim)  //###

AADD(aCampos,{"CODIGO"  ,"C",TamSx3('E1_CLIENTE')[1],0})
AADD(aCampos,{"LOJA"    ,"C",TamSx3('E1_LOJA')[1],0})
AADD(aCampos,{"CLIENTE" ,"C",25,0})
AADD(aCampos,{"TELEFONE","C",15,0})
AADD(aCampos,{"VENDEDOR","C",06,0})
AADD(aCampos,{"NOMEVEND","C",25,0})
AADD(aCampos,{"TELEVEND","C",15,0})
AADD(aCampos,{"NATUREZA","C",10,0})
AADD(aCampos,{"BANCO"   ,"C",03,0})
AADD(aCampos,{"EMISSAO" ,"C",08,0})
AADD(aCampos,{"BAIXA"   ,"C",08,0})
AADD(aCampos,{"VENCTO"  ,"C",08,0})
AADD(aCampos,{"VALOR"   ,"N",18,nDecs})
AADD(aCampos,{"DEBITO"  ,"N",18,nDecs})
AADD(aCampos,{"CREDITO" ,"N",18,nDecs})
AADD(aCampos,{"SALDO"   ,"N",18,nDecs})
AADD(aCampos,{"SALTIT"  ,"N",18,nDecs})
AADD(aCampos,{"DC"      ,"C", 1,0})
AADD(aCampos,{"SIGLA"   ,"C",03,0})
AADD(aCampos,{"CONDPG" ,"C",18,nDecs})
AADD(aCampos,{"SALDOFIM" ,"N",18,nDecs})
AADD(aCampos,{"VALOR02" ,"N",18,nDecs})
AADD(aCampos,{"VALOR03" ,"N",18,nDecs})
AADD(aCampos,{"VALOR04" ,"N",18,nDecs})
AADD(aCampos,{"VALOR05" ,"N",18,nDecs})
AADD(aCampos,{"VALOR06" ,"N",18,nDecs})
AADD(aCampos,{"VALOR07" ,"N",18,nDecs})
AADD(aCampos,{"VALOR08" ,"N",18,nDecs})

cNomeArq  := CriaTrab(aCampos)

dbUseArea( .T., __cRDDNTTS, cNomeArq,"TRB", if(.F. .Or. .F., !.F., NIL), .F. )
If nOrder	==	1
	cIndice	:=	"CODIGO+LOJA"
ElseIf nOrder	==	2
	cIndice	:=	"CODIGO+LOJA+PREFIXO+NUMERO+PARCELA+TIPO"
Else
	cIndice	:=	"CODIGO+LOJA"
Endif
IndRegua("TRB",cNomeArq,cIndice,,,OemToAnsi("Selecionando Registros..."))  //

Processa({|lEnd| GeraTra(oSection1:GetAdvplExp('SE1'),oSection1:GetAdvplExp('SA1'))},,OemToAnsi("Preparando Transit¢rio..."))  //

R133fechas()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rotina de impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()


oSection2:SetParentFilter({|cParam| TRB->CODIGO+TRB->LOJA == cParam },{||SA1->A1_COD+SA1->A1_LOJA}) 
If mv_par05 == 1
	oBreak1 := TRBreak():New( oSection2,{||.T.},"Valores")
	TRFunction():New(oSection2:Cell("CONDPG")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("SALDOFIM")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR02")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR03")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR04")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR05")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR06")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR07")	, ,"SUM", oBreak1, , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR08")	, ,"SUM", oBreak1, , , , .F. ,)
Else
	//Totalizadores
	TRFunction():New(oSection2:Cell("CONDPG")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("SALDOFIM")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR02")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR03")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR04")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR05")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR06")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR07")	, ,"SUM", , , , , .F. ,)
	TRFunction():New(oSection2:Cell("VALOR08")	, ,"SUM", , , , , .F. ,)
	
	//oculta
	
	//Define valores para as secoes
	oSection2:Cell("CONDPG"):SetBlock({|| nVlCli00 })
	oSection2:Cell("SALDOFIM"):SetBlock({|| nSalCliFim })
	oSection2:Cell("VALOR02"):SetBlock({|| nVlCli02 })
	oSection2:Cell("VALOR03"):SetBlock({|| nVlCli03 })
	oSection2:Cell("VALOR04"):SetBlock({|| nVlCli04 })
	oSection2:Cell("VALOR05"):SetBlock({|| nVlCli05 })
	oSection2:Cell("VALOR06"):SetBlock({|| nVlCli06 })
	oSection2:Cell("VALOR07"):SetBlock({|| nVlCli07 })
	oSection2:Cell("VALOR08"):SetBlock({|| nVlCli08 })
EndIf
oSection1:SetOrder(1) 
oSection1:SetTotalInLine(.T.)
oReport:SetTotalInLine(.F.)

Trposition():New(oSection1,"SA1",1,{|| xFilial('SA1')+TRB->CODIGO+TRB->LOJA})  
Trposition():New(oSection1,"SA3",1,{|| xFilial('SA3')+TRB->VENDEDOR} )  

oSection2:SetLineCondition({||&cImpSldChq})
oSection2:Cell("CONDPG"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("Payment Term")  ) //
oSection2:Cell("SALDOFIM"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("               TOTAL")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData02,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData01,"STR00"+CVALTOCHAR(85)," ")) + CHR(13)+ CHR(10)+dData01+ CHR(13)+ CHR(10)+OemToAnsi(" A ") + CHR(13)+ CHR(10)+  dData02  )
oSection2:Cell("VALOR02"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("              30 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData03,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData02,"STR00"+CVALTOCHAR(85)," ")) + CHR(13)+ CHR(10)+dData02+ CHR(13)+ CHR(10)+OemToAnsi(" A ")+ CHR(13)+ CHR(10)+  dData03   )
oSection2:Cell("VALOR03"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("              60 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData04,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData03,"STR00"+CVALTOCHAR(85)," ")) + CHR(13)+ CHR(10)+dData03+ CHR(13)+ CHR(10)+OemToAnsi(" A ")+ CHR(13)+ CHR(10)+  dData04   )
oSection2:Cell("VALOR04"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("              90 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData05,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData04,"STR00"+CVALTOCHAR(85)," ")) + CHR(13)+ CHR(10)+dData04+ CHR(13)+ CHR(10)+OemToAnsi(" A ") + CHR(13)+ CHR(10)+  dData05  )
oSection2:Cell("VALOR05"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("             120 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData06,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData05,"STR00"+CVALTOCHAR(85)," "))+ CHR(13)+ CHR(10)+dData05+ CHR(13)+ CHR(10)+OemToAnsi(" A ") + CHR(13)+ CHR(10)+  dData06   )
oSection2:Cell("VALOR06"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("             150 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData07,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData06,"STR00"+CVALTOCHAR(85)," "))+ CHR(13)+ CHR(10)+dData06+ CHR(13)+ CHR(10)+OemToAnsi(" A ") + CHR(13)+ CHR(10)+  dData07   )
oSection2:Cell("VALOR07"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("             180 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData08,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData07,"STR00"+CVALTOCHAR(85)," "))+ CHR(13)+ CHR(10)+dData07+ CHR(13)+ CHR(10)+OemToAnsi(" A ") + CHR(13)+ CHR(10)+  dData08   )
oSection2:Cell("VALOR08"):SetTitle(CHR(13)+ CHR(10)+OemToAnsi("  OVER 180 DAYS")  ) //IIf(substr(cvaltochar(dDataRef),4,7)==dData09,OemToAnsi("STR00"+CVALTOCHAR(84)),Iif(substr(cvaltochar(dDataRef),4,7)==dData08,"STR00"+CVALTOCHAR(85)," "))+ CHR(13)+ CHR(10)+dData08+ CHR(13)+ CHR(10)+OemToAnsi(" A ") + CHR(13)+ CHR(10)+  dData09   )

oSection2:SetHeaderPage()

oReport:SetTitle(titulo)

oReport:SetMeter(RecCount())
dbSelectArea("TRB")
DbGotop()

oSection1:Init() 
nTotCheque:=0
While !TRB->(EOF())  
   oSection1:PrintLine()      
 	oSection2:Init()
  	If mv_par05 == 2 //Sintetico
		nVlCli00	   := ''
		nVlCli01	   := 0
		nVlCli02	   := 0
		nVlCli03	   := 0
		nVlCli04	   := 0
		nVlCli05	   := 0
		nVlCli06	   := 0
		nVlCli07	   := 0
		nVlCli08	   := 0
		nVlCli09	   := 0
		nVlCli10	   := 0
		nVlCli11	   := 0
		nSalCliFim	:= 0
	EndIf 	
	cCliente:=TRB->CODIGO+TRB->LOJA
   While cCliente==TRB->CODIGO+TRB->LOJA  .And. !TRB->(EOF())
		oReport:IncMeter()    	
  		If mv_par05 == 2 //Sintetico
			nVlCli00	   += TRB->CONDPG
			nVlCli01	   += TRB->SALDOFIM
			nVlCli02	   += TRB->VALOR02
			nVlCli03	   += TRB->VALOR03
			nVlCli04	   += TRB->VALOR04
			nVlCli05	   += TRB->VALOR05
			nVlCli06	   += TRB->VALOR06
			nVlCli07	   += TRB->VALOR07
			nVlCli08	   += TRB->VALOR08
			nSalCliFim	+= TRB->SALDOFIM
		EndIf
		If &cImpSldChq .and. mv_par05 == 1 // analitico
	   		oSection2:PrintLine()	
	   	EndIf
  		Dbskip()
  	EndDo               
  	If mv_par05 == 2 //Sintetico
  		oSection2:PrintLine()
  	EndIf
  	If nTotCheque >0
		oReport:ThinLine()
		oReport:PrintText(OemToAnsi("STR00"+CVALTOCHAR(43)) + Space(01)+ Dtoc(dDataRef) + " : " +Alltrim(Transf(nTotCheque,PesqPict("SE1","E1_VALOR"))))
	EndIf 
 
	oSection2:Finish()	
	oReport:ThinLine()
	nAcumCh:=nAcumCh + nTotCheque
	nTotCheque:=0

EndDo     

If nAcumCh > 0
	oReport:PrintText(OemToAnsi("STR00"+CVALTOCHAR(45)) + Space(01)+ Dtoc(dDataRef) + " : " + Alltrim(Transf(nAcumCh,PesqPict("SE1","E1_VALOR"))))
	oReport:ThinLine()
EndIf 

oSection1:Finish()		

dbSelectArea("TRB")
dbCloseArea()

Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())	 // Elimina arquivos de indice a partir do arquivo Trabalho

dbSelectArea("SA1")
RetIndex("SA1")
dbSetOrder(1)
DbClearFilter()

dbSelectArea("SE1")
RetIndex("SE1")
dbSetOrder(1)
DbClearFilter()

dbSelectArea("SE5")
RetIndex("SE5")
dbSetOrder(1)
DbClearFilter()

Return .T.

/*---------------------------------------------------------------------------R3--------------------------------------------------------------------------------------------*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HIT0099 ³ Autor ³Jose Lucas/Diego Rivero³ Data ³ 09.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ HIT0099(void)    / FASE 3                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Localizacoes paises ConeSul...                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function HIT0099R32()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  := OemToAnsi("Este programa imprimir  la demsotraci¢n contable de Clientes.")   //
Local cDesc2  := OemToAnsi("Se puede  emitir  todo  el movimiento de los ")   //
Local cDesc3  := OemToAnsi("mismos, o apenas los valores originales. ")   //
Local wnrel
Local limite  :=  220
Local Tamanho := "G"
Local cString := "SE1"
Local lOk 	  :=.F.


Private aOrd      := {"Vencimiento","Prefixo+Titulo","Emissão"} //######
Private titulo 	:= OemToAnsi("Dividas Vencidas") //
Private cabec1 	:= ""
Private cabec2 	:= ""
Private aReturn := { OemToAnsi("Administração"), 1, OemToAnsi("Administração") , 1, 2, 1, "",1 }   //""###"Administraci¢n"
Private nomeprog:= "HIT0099"
Private aLinha 	:= {},nLastKey := 0
Private cPerg 	:= "FIR133X"

cTipos := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("FIR133X",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "HIT0099"            //Nome Default do relatorio em Disco

mv_par07 := 0
mv_par08 := 2
mv_par09 := 0
mv_par10 := 1
mv_par11 := 1
mv_par12 := 2
mv_par13 := 1

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,"",.T.)
mv_par07 := 0
mv_par08 := 2
mv_par09 := 0
mv_par10 := 1
mv_par11 := 1
mv_par12 := 2
mv_par13 := 1

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| lOk := Fa133Imp(@lEnd,wnRel,cString)},OemToAnsi("Dividas Vencidas")) 

If lOk
	Set Device To Screen
	If aReturn[5] = 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	Endif
	MS_FLUSH()
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA133Imp ³ Autor ³ Lucas                 ³ Data ³ 11.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Razonete de Cliente                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA133Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA133Imp(lEnd,wnRel,cString)
Local cIndice	:=	""
Local CbCont,CbTxt
Local tamanho:="G"
Local nQuebra:=0,lImprAnt := .F.
Local cNome,nTotDeb:=0,nTotCrd:=0,nSaldoAtu:=0,nTotDebG:=0,nTotCrdG:=0,nSalAtuG:=0,nSalAntG:=0
Local aSaldos:={},j,dEmissao:=CTOD(""),dVencto:=CTOD("")
Local nRec,nPrim,cPrefixo,cNumero,cParcela,cNaturez,nValliq
Local nAnterior:=0,cAnterior,cFornece,dDtDigit,cRecPag,nRec1,cSeq
Local nTotAbat
Local nRegistro
Local lNoSkip:= .T.
Local lFlag  := .F.
Local nSaldoFinal:=0
Local aCampos:={},aTam:={}
Local aInd	 :={}
Local cCondE1:=cCondE5:=" "
Local cIndE1 :=cIndE5 :=cIndA1 :=" "
Local nRegAtu,lImprime
Local nRegSe1Atu := SE1->(RecNo())
Local nOrdSe1Atu := SE1->(IndexOrd())
Local lBaixa     := .F.
Local cChaveSe1
Local cRazSocial
Local cVendedor
Local cTelefone
Local	lPerg := .T., lChkDRef := .F.
Local 	I
Local cImpSldChq 

mv_par07 := 0
mv_par08 := 2
mv_par09 := 0
mv_par10 := 1
mv_par11 := 1
mv_par12 := 2
mv_par13 := 1

Private cCodClie
Private cLojaCli
Private cClieProv := ""
Private cLoja := ""
Private cClieIni  := mv_par01
Private cClieFim  := mv_par02
Private dFechaIni := mv_par03
Private dFechaFim := Min(mv_par04,dDataBase)
Private nInforme  := mv_par05
Private nMoeda    := mv_par10
Private lConverte := (mv_par11==1)
Private nDecs     := MsDecimais(nMoeda)
Private dData01
Private dData02
Private dData03
Private dData04
Private dData05
Private dData06
Private dData07
Private dData08
Private dData09
Private dData10
Private dData11

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private dDataRef 	:= mv_par06
Private nPeriodos 	:= IIf(mv_par09==0,1,mv_par09)
Private nTipoPer	:= mv_par08
Private nPerAnt		:= IIf(mv_par07 > 9,9,mv_par07)
Private nImpSldChq	:= mv_par12
cImpSldChq := IIF(nImpSldChq == 1,'nInforme == 1 .And. TRB->TIPO <> "CH "',"nInforme == 1")

If nTipoPer == 3 //Informado
	lOk	:=	.T.
	While lOk
		If Pergunte("FI133B",.T.)
			lPerg := .T.
			For I:=1 to 10
            cData1 := ("mv_par"+StrZero(I,2))
            cData2 := ("mv_par"+StrZero(I+1,2))
				If  &cData1. >= &cData2.
					lPerg := .F.
					I:=10
				Endif
			Next
			If lPerg
				For I:=1 to 11
               cData1 := ("mv_par"+StrZero(I,2))
					If &cData1. == dDataRef
						lChkDRef := .T.
						I := 11
					Endif
				Next
				If !lChkDRef
					MsgStop(OemToAnsi("Uma das datas deve coincidir com a Data de Referencia")) //"Uma das datas deve coencidir com a Data de Referencia"
					Loop
				Endif
			Endif

			If lPerg
            dData01  := mv_par01
            dData02  := mv_par02
            dData03  := mv_par03
            dData04  := mv_par04
            dData05  := mv_par05
            dData06  := mv_par06
            dData07  := mv_par07
            dData08  := mv_par08
            dData09  := mv_par09
            dData10  := mv_par10
            dData11  := mv_par11
				//para restaurar os valores nas MV_PAR originais
				Pergunte("FIR133X",.f.)
            lOk   := .F.
			Else
				MsgStop(OemToAnsi("Erro de sequencia nas datas")) //"Erro de sequencia nas datas"
			Endif
		Else
			Return .F.
		Endif
	Enddo
Else
	dData01 := Fr133Data(dDataRef,01,nPeriodos,nTipoPer,nPerAnt)
	dData02 := Fr133Data(dDataRef,02,nPeriodos,nTipoPer,nPerAnt)
	dData03 := Fr133Data(dDataRef,03,nPeriodos,nTipoPer,nPerAnt)
	dData04 := Fr133Data(dDataRef,04,nPeriodos,nTipoPer,nPerAnt)
	dData05 := Fr133Data(dDataRef,05,nPeriodos,nTipoPer,nPerAnt)
	dData06 := Fr133Data(dDataRef,06,nPeriodos,nTipoPer,nPerAnt)
	dData07 := Fr133Data(dDataRef,07,nPeriodos,nTipoPer,nPerAnt)
	dData08 := Fr133Data(dDataRef,08,nPeriodos,nTipoPer,nPerAnt)
EndIf

Private nVlCli00	:= ''
Private nVlCli01	:= 0.00
Private nVlCli02	:= 0.00
Private nVlCli03	:= 0.00
Private nVlCli04	:= 0.00
Private nVlCli05	:= 0.00
Private nVlCli06	:= 0.00
Private nVlCli07	:= 0.00
Private nVlCli08	:= 0.00
Private nVlCli09	:= 0.00
Private nVlCli10 	:= 0.00
Private nVlCli11	:= 0.00
Private nTotChq		:= 0.00
Private nSalCliFim	:= 0.00

Private nVlVen00	:= 0.00
Private nVlVen01	:= 0.00
Private nVlVen02	:= 0.00
Private nVlVen03	:= 0.00
Private nVlVen04	:= 0.00
Private nVlVen05	:= 0.00
Private nVlVen06	:= 0.00
Private nVlVen07	:= 0.00
Private nVlVen08	:= 0.00
Private nVlVen09	:= 0.00
Private nVlVen10	:= 0.00
Private nVlVen11	:= 0.00
Private nSalVenFim	:= 0.00

Private nVlGer00	:= 0.00
Private nVlGer01	:= 0.00
Private nVlGer02	:= 0.00
Private nVlGer03	:= 0.00
Private nVlGer04	:= 0.00
Private nVlGer05	:= 0.00
Private nVlGer06	:= 0.00
Private nVlGer07	:= 0.00
Private nVlGer08	:= 0.00
Private nVlGer09	:= 0.00
Private nVlGer10 	:= 0.00
Private nVlGer11 	:= 0.00
Private nTotGerChq	:= 0.00
Private nSalGerFim 	:= 0.00

Private cNomeArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt	:= SPACE(10)
cbcont	:= 0
li		:= 80
m_pag	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := OemToAnsi("DIVIDAS VENCIDAS") //"DEUDAS VENCIDAS Y A VENCER DE CLIENTES"

Titulo += Space(10)
Titulo += OemToAnsi("Emissão De: ")+DTOC(dFechaIni)+OemToAnsi(" Até :")+DTOC(dFechaFim)  //" De Emision: "###"  Hasta : "
Titulo += Space(10) + OemToAnsi("Data de referencia")+Space(01)+DTOC(dDataRef)  //"Data  referencia"
Titulo += Space(10) + If(nInforme==1,OemToAnsi("Analitico"),OemToAnsi("Sintetico"))  //"Analitico"###"Resumen"

AADD(aCampos,{"CODIGO"  ,"C",06,0})
AADD(aCampos,{"LOJA"    ,"C",02,0})
AADD(aCampos,{"CLIENTE" ,"C",25,0})
AADD(aCampos,{"TELEFONE","C",15,0})
AADD(aCampos,{"VENDEDOR","C",06,0})
AADD(aCampos,{"NOMEVEND","C",25,0})
AADD(aCampos,{"TELEVEND","C",15,0})
AADD(aCampos,{"NATUREZA","C",10,0})
AADD(aCampos,{"PREFIXO" ,"C",03,0})
AADD(aCampos,{"NUMERO"  ,"C",15,0})
AADD(aCampos,{"TIPO"    ,"C",03,0})
AADD(aCampos,{"PARCELA" ,"C",01,0})
AADD(aCampos,{"BANCO"   ,"C",03,0})
AADD(aCampos,{"EMISSAO" ,"C",08,0})
AADD(aCampos,{"BAIXA"   ,"C",08,0})
AADD(aCampos,{"VENCTO"  ,"C",08,0})
AADD(aCampos,{"VALOR"   ,"N",18,nDecs})
AADD(aCampos,{"DEBITO"  ,"N",18,nDecs})
AADD(aCampos,{"CREDITO" ,"N",18,nDecs})
AADD(aCampos,{"SALDO"   ,"N",18,nDecs})
AADD(aCampos,{"SALTIT"  ,"N",18,nDecs})
AADD(aCampos,{"DC"      ,"C", 1,0})
AADD(aCampos,{"SIGLA"   ,"C",03,0})
AADD(aCampos,{"CONDPG" ,"N",18,nDecs})
AADD(aCampos,{"SALDOFIM" ,"N",18,nDecs})
AADD(aCampos,{"VALOR02" ,"N",18,nDecs})
AADD(aCampos,{"VALOR03" ,"N",18,nDecs})
AADD(aCampos,{"VALOR04" ,"N",18,nDecs})
AADD(aCampos,{"VALOR05" ,"N",18,nDecs})
AADD(aCampos,{"VALOR06" ,"N",18,nDecs})
AADD(aCampos,{"VALOR07" ,"N",18,nDecs})
AADD(aCampos,{"VALOR08" ,"N",18,nDecs})

cNomeArq  := CriaTrab(aCampos)

dbUseArea( .T., __cRDDNTTS, cNomeArq,"TRB", if(.F. .Or. .F., !.F., NIL), .F. )
If aReturn[8]	==	1
	cIndice	:=	"CODIGO+LOJA"
ElseIf aReturn[8]	==	2
	cIndice	:=	"CODIGO+LOJA+PREFIXO+NUMERO+PARCELA+TIPO"
Else
	cIndice	:=	"CODIGO+LOJA"
Endif
IndRegua("TRB",cNomeArq,cIndice,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

Processa({|lEnd| GeraTra(aReturn[7])},,OemToAnsi("Preparando Transit¢rio..."))  //"Preparando Transit¢rio..."

R133fechas()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia rotina de impressao                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()

nTotClie := 0
nTotVend := 0

SetRegua(RecCount())

nVlGer00	:= 0.00
nVlGer01	:= 0.00
nVlGer02	:= 0.00
nVlGer03	:= 0.00
nVlGer04	:= 0.00
nVlGer05	:= 0.00
nVlGer06	:= 0.00
nVlGer07	:= 0.00
nVlGer08	:= 0.00
nVlGer09	:= 0.00
nVlGer10	:= 0.00
nVlGer11	:= 0.00
nSalGerFim	:= 0.00

While ! Eof()

	If li > 65
		R133CabRes(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	EndIf

	nVlCli00	:= ''
	nVlCli01	:= 0.00
	nVlCli02	:= 0.00
	nVlCli03	:= 0.00
	nVlCli04	:= 0.00
	nVlCli05	:= 0.00
	nVlCli06	:= 0.00
	nVlCli07	:= 0.00
	nVlCli08	:= 0.00
	nVlCli09	:= 0.00
	nVlCli10	:= 0.00
	nVlCli11	:= 0.00
	nTotChq		:= 0.00
	nSalCliFim	:= 0.00

	cCodClie    := TRB->CODIGO
	cLojaCli    := TRB->LOJA
	cRazSocial  := TRB->CLIENTE
	cVendedor   := TRB->VENDEDOR
	cTelefone   := TRB->TELEFONE

	lImpClie := .T.

	While !Eof().and.TRB->CODIGO==cCodClie.and.TRB->LOJA==cLojaCli

		IncRegua()
		If lEnd
			Exit
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le registros com data anterior a data inicial (para compor   ³
		//³ os saldos anteriores) ate a data final.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If li>65
			R133CabRes(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
		EndIf


		If &(cImpSldChq)//Detallado
			If lImpClie
				R133CabCli()
				lImpClie := .F.
				li++
				li++
			EndIf
			@li,000 PSAY VENCTO
			@li,009 PSAY SIGLA
			@li,015 PSAY PREFIXO
			@li,019 PSAY NUMERO
			@li,035 PSAY PARCELA
			@li,038 PSAY CONDPG      	//Picture TM(VALOR00	, 15,nDecs)
			@li,066 PSAY VALOR02      	Picture TM(VALOR02	, 15,nDecs)
			@li,080 PSAY VALOR03      	Picture TM(VALOR03	, 15,nDecs)
			@li,094 PSAY VALOR04      	Picture TM(VALOR04	, 15,nDecs)
			@li,108 PSAY VALOR05      	Picture TM(VALOR05	, 15,nDecs)
			@li,122 PSAY VALOR06      	Picture TM(VALOR06	, 15,nDecs)
			@li,136 PSAY VALOR07      	Picture TM(VALOR07	, 15,nDecs)
			@li,150 PSAY VALOR08      	Picture TM(VALOR08	, 15,nDecs)
			@li,178 PSAY VALOR10      	Picture TM(VALOR10	, 15,nDecs)
			@li,192 PSAY VALOR11      	Picture TM(VALOR11	, 15,nDecs)
			@li,206 PSAY SALDOFIM		Picture TM(SALDOFIM	, 15,nDecs)
			@li,220 PSAY If(SALDOFIM<0,"C","D")
			li++
		EndIf
		nVlCli00	+= TRB->CONDPG
		nVlCli01	+= TRB->SALDOFIM
		nVlCli02	+= TRB->VALOR02
		nVlCli03	+= TRB->VALOR03
		nVlCli04	+= TRB->VALOR04
		nVlCli05	+= TRB->VALOR05
		nVlCli06	+= TRB->VALOR06
		nVlCli07	+= TRB->VALOR07
		nVlCli08	+= TRB->VALOR08
		nSalCliFim	+= TRB->SALDOFIM
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	If nInforme == 1 //Detallado
		nTotClie ++
		li++
		@li, 0 PSAY Repl("-",220)
		li++
		@li,  0 PSAY OemtoAnsi("Total Cliente: ")+cCodClie+"-"+cLojaCli  //"Total Cliente: "
		@li, 38 PSAY nVlCli00		//Picture TM(nVlCli00  , 15,nDecs)
		@li, 52 PSAY nVlCli01		Picture TM(nVlCli01  , 15,nDecs)
		@li, 66 PSAY nVlCli02		Picture TM(nVlCli02  , 15,nDecs)
		@li, 80 PSAY nVlCli03		Picture TM(nVlCli03  , 15,nDecs)
		@li, 94 PSAY nVlCli04		Picture TM(nVlCli04  , 15,nDecs)
		@li,108 PSAY nVlCli05		Picture TM(nVlCli05  , 15,nDecs)
		@li,122 PSAY nVlCli06		Picture TM(nVlCli06  , 15,nDecs)
		@li,136 PSAY nVlCli07		Picture TM(nVlCli07  , 15,nDecs)
		@li,150 PSAY nVlCli08		Picture TM(nVlCli08  , 15,nDecs)
		@li,164 PSAY nVlCli09		Picture TM(nVlCli09  , 15,nDecs)
		@li,178 PSAY nVlCli10		Picture TM(nVlCli10  , 15,nDecs)
		@li,192 PSAY nVlCli11		Picture TM(nVlCli11  , 15,nDecs)
		@li,206 PSAY nSalCliFim		Picture TM(nSalCliFim, 15,nDecs)
		@li,220 PSAY If(nSalCliFim<0,"C","D")
		If (nImpSldChq ==1)
			li++                         
			@li,000 PSAY OemToAnsi("Saldo") + Space(01)+ Dtoc(dDataRef) + " -" //"Saldo de Cheques Al "
			@li,032 PSAY nTotChq Picture TM(nTotChq  , 15,nDecs)
		EndIf
	    li++
		@li, 0 PSAY Repl("-",220)
		li++
	ElseIf nInforme == 2 //Sint‚tico
		nTotClie ++
		@li,  0 PSAY cCodClie+"-"+cLojaCli
		@li,011 PSAY Subs(cRazSocial,1,16)
		@li,028 PSAY cVendedor
		@li,038 PSAY nVlCli00		//Picture TM(nVlCli00  , 15,nDecs)
		@li,052 PSAY nVlCli01		Picture TM(nVlCli01  , 15,nDecs)
		@li,066 PSAY nVlCli02		Picture TM(nVlCli02  , 15,nDecs)
		@li,080 PSAY nVlCli03		Picture TM(nVlCli03  , 15,nDecs)
		@li,094 PSAY nVlCli04		Picture TM(nVlCli04  , 15,nDecs)
		@li,108 PSAY nVlCli05		Picture TM(nVlCli05  , 15,nDecs)
		@li,122 PSAY nVlCli06		Picture TM(nVlCli06  , 15,nDecs)
		@li,136 PSAY nVlCli07		Picture TM(nVlCli07  , 15,nDecs)
		@li,150 PSAY nVlCli08		Picture TM(nVlCli08  , 15,nDecs)
		@li,164 PSAY nVlCli09		Picture TM(nVlCli09  , 15,nDecs)
		@li,178 PSAY nVlCli10		Picture TM(nVlCli10  , 15,nDecs)
		@li,192 PSAY nVlCli11		Picture TM(nVlCli11  , 15,nDecs)
		@li,206 PSAY nSalCliFim		Picture TM(nSalCliFim, 15,nDecs)
		@li,220 PSAY If(nSalCliFim<0,"C","D")
		If (nImpSldChq ==1)
			li++
			@li,000 PSAY OemToAnsi("Saldo") + Space(01)+ Dtoc(dDataRef)  + " -" //"Saldo de Cheques Al "
			@li,032 PSAY nTotChq Picture TM(nTotChq  , 15,nDecs)
		EndIf
		li++
		li++
	EndIf
	//nVlGer00	+= nVlCli00
	nVlGer01	+= nVlCli01
	nVlGer02	+= nVlCli02
	nVlGer03	+= nVlCli03
	nVlGer04	+= nVlCli04
	nVlGer05	+= nVlCli05
	nVlGer06	+= nVlCli06
	nVlGer07	+= nVlCli07
	nVlGer08	+= nVlCli08
	nVlGer09	+= nVlCli09
	nVlGer10	+= nVlCli10
	nVlGer11	+= nVlCli11
	nTotGerChq	+= nTotChq
	nSalGerFim	+= nSalCliFim
EndDo

If nTotClie > 1 .or. nTotVend > 0
	If li>65
		R133CabRes(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	EndIf
	li++
	@li, 0 PSAY Repl("-",220)
	li++
	@li,  0 PSAY OemtoAnsi("T o t a l   G e r a l ") //"T o t a l   G e n e r a l "
	@li,038 PSAY nVlGer00		Picture TM(nVlGer00   , 15,nDecs)
	@li,052 PSAY nVlGer01		Picture TM(nVlGer01   , 15,nDecs)
	@li,066 PSAY nVlGer02		Picture TM(nVlGer02   , 15,nDecs)
	@li,080 PSAY nVlGer03		Picture TM(nVlGer03   , 15,nDecs)
	@li,094 PSAY nVlGer04		Picture TM(nVlGer04   , 15,nDecs)
	@li,108 PSAY nVlGer05		Picture TM(nVlGer05   , 15,nDecs)
	@li,122 PSAY nVlGer06		Picture TM(nVlGer06   , 15,nDecs)
	@li,136 PSAY nVlGer07		Picture TM(nVlGer07   , 15,nDecs)
	@li,150 PSAY nVlGer08		Picture TM(nVlGer08   , 15,nDecs)
	@li,164 PSAY nVlGer09		Picture TM(nVlGer09   , 15,nDecs)
	@li,178 PSAY nVlGer10		Picture TM(nVlGer10   , 15,nDecs)
	@li,192 PSAY nVlGer11		Picture TM(nVlGer11   , 15,nDecs)
	@li,206 PSAY nSalGerFim		Picture TM(nSalGerFim , 15,nDecs)
	@li,220 PSAY If(nSalGerFim<0,"C","D")
	If (nImpSldChq ==1)
		li++
		@li,000 PSAY OemToAnsi("S a l d o  G e r a l") + Space(01)+ Dtoc(dDataRef)  + " -" //"S a l d o   G e n e r a l   d e   C h e q u e s  A l "
		@li,064 PSAY nTotGerChq Picture TM(nTotGerChq  , 15,nDecs)
	EndIf
	li++
	@li, 0 PSAY Repl("-",220)
EndIf

Roda( cbCont, cbTxt, Tamanho )

dbSelectArea("TRB")
dbCloseArea()

Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())	 // Elimina arquivos de indice a partir do arquivo Trabalho

dbSelectArea("SA1")
RetIndex("SA1")
dbSetOrder(1)
DbClearFilter()

dbSelectArea("SE1")
RetIndex("SE1")
dbSetOrder(1)
DbClearFilter()

dbSelectArea("SE5")
RetIndex("SE5")
dbSetOrder(1)
DbClearFilter()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R450CabRes³ Autor ³ Jose Lucas           ³ Data ³ 24.09.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Cabecalho do Resumo.                          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ R450CabRes(void)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR450                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function R133CabRes(titulo,cabec1,cabec2,nomeprog,tamanho)
Local aDataRef:={}
Local aColR:={053,068,082,096,110,124,138,152,166,180,194}
Local i:=0

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
@ li,000 PSAY Replicate("*",220)
li++
For i:=1 to 11
	cData := ("dData"+StrZero(i,2))
	If (Dtos(&cData) == Dtos(dDataRef))
		@ li,aColR[i]-Len("Vencidos << >> A Vencer")/2 PSAY OemToAnsi("Vencidos << >> A Vencer") //"Vencidos << >> A Vencer"###"Vencidos << >> A Vencer"
		i:=11
	Endif
Next
li++
@ li,057 PSAY dData01 + 1
@ li,071 PSAY dData02 + 1
@ li,085 PSAY dData03 + 1
@ li,099 PSAY dData04 + 1
@ li,113 PSAY dData05 + 1
@ li,127 PSAY dData06 + 1
@ li,141 PSAY dData07 + 1
@ li,155 PSAY dData08 + 1
@ li,169 PSAY dData09 + 1
@ li,183 PSAY dData10 + 1

li++
@ li,000 PSAY OemToAnsi("Cliente/Comprovante            Vendedor     Ate           A             A             A             A             A             A             A             A             A             A            Post.           Saldo") //
li++

If nInforme == 1
	@ li,000 PSAY OemToAnsi("Fecha    Tipo Serie Numero      Quotas") //
Endif

@ li,043 PSAY 	dData01
@ li,057 PSAY 	dData02
@ li,071 PSAY 	dData03
@ li,085 PSAY 	dData04
@ li,099 PSAY 	dData05
@ li,113 PSAY 	dData06
@ li,127 PSAY 	dData07
@ li,141 PSAY 	dData08
@ li,155 PSAY 	dData09
@ li,169 PSAY 	dData10
@ li,183 PSAY 	dData11
@ li,197 PSAY 	dData11 + 1
li++
@ li,000 PSAY Replicate("*",220)
li := 12
Return( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R133Grav  ³ Autor ³ Jose Lucas            ³ Data ³ 03.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Grava um registro no arquivo de trabalho para impressao     ³±±
±±³          ³do Razonete.                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³R133Grv()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HIT0099                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R133Fechas()
Local nDiasAtrazo := 0
Local nDiasAVencer := 0
Local nValor := 0.00
Local nVlrCruz := 0.00
Local nSldTit := 0.00
Local cImpSldChq := IIf(nImpSldChq == 1,'TRB->TIPO <> "CH"',".T.")

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	nSldTit := TRB->SALDO
	RecLock("TRB",.F.)
	If (&cImpSldChq)
		If Alltrim(TRB->VENCTO) == Strtran(dData03,"/") 	// 30 days   .and. Alltrim(TRB->VENCTO) <= Strtran(dData03,"/")
			Replace VALOR02   With VALOR02 + nSldTit
		ElseIf Alltrim(TRB->VENCTO) == Strtran(dData04,"/") 	// 60 days .and. Alltrim(TRB->VENCTO) <= Strtran(dData04,"/")
			Replace VALOR03   With VALOR03 + nSldTit
		ElseIf Alltrim(TRB->VENCTO) == Strtran(dData05,"/") 	// 90 days .and. Alltrim(TRB->VENCTO) <= Strtran(dData05,"/")
			Replace VALOR04   With VALOR04 + nSldTit
		ElseIf Alltrim(TRB->VENCTO) == Strtran(dData06,"/") 	// 120 days .and. Alltrim(TRB->VENCTO) <= Strtran(dData06,"/")
			Replace VALOR05   With VALOR05 + nSldTit
		ElseIf Alltrim(TRB->VENCTO) == Strtran(dData07,"/") 	// 150 days .and. Alltrim(TRB->VENCTO) <= Strtran(dData07,"/")
			Replace VALOR06   With VALOR06 + nSldTit
		ElseIf Alltrim(TRB->VENCTO) == Strtran(dData08,"/") 	// 180 days .and. Alltrim(TRB->VENCTO) <= Strtran(dData08,"/")
			Replace VALOR07   With VALOR07 + nSldTit
		Else //If Alltrim(TRB->VENCTO) == Strtran(dData08,"/") 	// over 180 days .and. Alltrim(TRB->VENCTO) <= Strtran(dData09,"/")
			Replace VALOR08   With VALOR08 + nSldTit
		EndIf

		nValor := VALOR02+VALOR03+VALOR04+VALOR05+VALOR06+VALOR08+VALOR07
		Replace SALDOFIM  With nValor
	Else
		Replace TOTCHEQ With nSldTit
	Endif
	MsUnLock()
	dbSkip()
End
Return( NIL )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R133CabClie  ³ Autor ³ Lucas             ³ Data ³ 12.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir el cabeca de los Clientes...                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R133CabClie()                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ HIT0099                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function R133CabClie()

SA1->( dbSetOrder(1) )
SA1->( dbSeek(xFilial("SA1")+TRB->CODIGO+TRB->LOJA) )
@li,  0 PSAY OemtoAnsi("Cliente : ")+TRB->CODIGO+"-"+TRB->LOJA   //"Cliente : "
@li, 21 PSAY SA1->A1_NREDUZ + OemToAnsi("Endereço") + Alltrim(SA1->A1_END) + " - "  +;  //". Direccion : "
	Alltrim(SA1->A1_MUN) + "-"+ SA1->A1_EST +"  "+OemtoAnsi("TEL.:") +SA1->A1_TEL  //"TEL: "

SA3->( dbSetOrder(1) )
SA3->( dbSeek(xFilial("SA3")+SA1->A1_VEND ))

If SA3->( Found() )
	@li, 140 PSAY OemToAnsi("Vendedor:") //"VENDEDOR: "
	@li, 150 PSAY SA1->A1_VEND + "-" + Alltrim(SA3->A3_NOME)+"  "+OemToAnsi("TEL: ")+SA3->A3_TEL  //"TEL: "
EndIf


Return




/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GERATRA  ³ Autor ³ BRUNO SOBIESKI        ³ Data ³ 20.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Generacion del archivo temporal con la informacion de la   ³±±
±±³          ³ deuda con un Cliente.                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraTra(cFltSE1,cFltSA1)
Local nDebito := 0.00
Local nCredito := 0.00
Local nSigno
Local nPosTip
Local cTipos 		:=	""
Local nTaxa:= 0     
Local aTotG	:=	{}
Local cQuery 

If ExistBlock("FR133TIP")
	cTipos   := ExecBlock("FR133TIP",.F.,.F.)
Endif

nCount := 1000

cQuery := "SELECT E1_CLIENTE,E1_LOJA,A1_NOME,A1_VEND,A1_TEL,A1_COND,E4_DESCRI,YEAR(E1_VENCREA) ANO,MONTH(E1_VENCREA) AS MES,"
cQuery += " SUM(E1_VALOR-E5_VALOR) AS SALDO"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " LEFT JOIN "+RetSQLName("SE5")+" E5 ON E5_FILIAL=E1_FILIAL AND E5_NUMERO=E1_NUM AND E5_PREFIXO=E1_PREFIXO AND E5_PARCELA=E1_PARCELA"
cQuery += " AND E5.D_E_L_E_T_<>'*'"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL=E1_FILIAL AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_<>'*'"
cQuery += " LEFT JOIN "+RetSQLName("SE4")+" E4 ON E4_FILIAL=A1_FILIAL AND E4_CODIGO=A1_COND AND E4.D_E_L_E_T_<>'*'"
cQuery += " WHERE E1_FILIAL='"+xFilial("SE1")+"' "
cQuery += " AND E1_VENCREA < '"+dtos(mv_par06)+"'"
cQuery += " AND (E1_VALOR-E5_VALOR) > 0"
cQuery += " AND E1_CLIENTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQuery += " AND E1.D_E_L_E_T_<>'*'"
cQuery += " GROUP BY E1_CLIENTE,E1_LOJA,A1_NOME,A1_VEND,A1_TEL,A1_COND,E4_DESCRI,YEAR(E1_VENCREA),MONTH(E1_VENCREA)"
cQuery += " ORDER BY E1_CLIENTE,YEAR(E1_VENCREA),MONTH(E1_VENCREA)"

	If Select('QUERY') > 0
		dbSelectArea('QUERY')
		dbCloseArea()
	EndIf
	
	MemoWrite("HIT0099.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )
	

	DbSelectArea( "QUERY" )  
	While !EOF()
		IncProc(OemtoAnsi("Procesando cliente ")+Subst(QUERY->A1_NOME,1,27))  //""

		RecLock("TRB",.T.)
		TRB->CODIGO    :=  QUERY->E1_CLIENTE
		TRB->LOJA      :=  QUERY->E1_LOJA
		TRB->CLIENTE   :=  QUERY->A1_NOME
		TRB->VENDEDOR  :=  QUERY->A1_VEND
		TRB->TELEFONE  :=  QUERY->A1_TEL                              
		TRB->CONDPG	   :=  QUERY->A1_COND+"-"+ALLTRIM(QUERY->E4_DESCRI)
		TRB->VENCTO    :=  cvaltochar(QUERY->MES)+cvaltochar(QUERY->ANO)  //MES ANO
		TRB->VALOR     :=  QUERY->SALDO 	//  * nSigno
		TRB->SALDO     :=  QUERY->SALDO 	//nSaldo         * nSigno
		TRB->(MsUnLock())
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FR133Data³ Autor ³ BRUNO SOBIESKI        ³ Data ³ 20.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a data correta segundo os parametros informados.   ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fr133Data(dData,nColuna,nPeriodo,nTipo,nPeriodAnt)
Local dRet

If nTipo == 1 // Dia
	nDay 	 := Day(dData)
	nMonth   := Month(dData)
	nAno     := Year(dData)
	nRetPer  := nPeriodo * (nColuna - (nPeriodAnt+1) )
	dRet 	 := dData + nRetPer

ElseIf nTipo == 2  //Mes
	nMonth   := Month(dData)
	nAno     := Year(dData)
	nRetPer  := nPeriodo * (nColuna - (nPeriodAnt+1) )
	nMonth   := nMonth - nRetPer
	nAno     += IIf(nMonth <= 0, -1,Iif(nMonth >12 ,  1,0))
	nMonth   += IIf(nMonth <= 0, 12,Iif(nMonth >12 ,-12,0))
	If Month(dData) <> Month(dData+1)
		dRet	:=	StrZero(nMonth,2)+"/"+Str(nAno,4)
	Else
		cMonth   := Strzero(nMonth,2)
		cDay	 := Str(Day(dData),2)
		dRet     := cMonth+"/"+Str(nAno,4)
	Endif
Endif

Return dRet