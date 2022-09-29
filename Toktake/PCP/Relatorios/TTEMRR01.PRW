#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TTPCPR01³ Autor ³ Artur Nucci Ferrari    ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ SALDO ESTOQUE											   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESTOQUE                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TTEMRR01()
Local oReport

If cEmpAnt <> "01"
	Return
EndIf

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PCP                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

Local oReport
Local oSection
//Private cPerg    := "TTPCP01"
//ValPerg(cPerg)
//Pergunte(cPerg,.T.)
oReport := TReport():New("TTEMRR01","URGENCIA","",{|oReport| PrintReport(oReport)},"Este relatório imprime a relação das etiquetas Pallet da Produção.")

// Seção  Dados da Nota Fiscal
oSection1 := TRSection():New(oReport,OemToAnsi("ETIQUETAS PALLET"),{"TRB"})
//                      CAMPO   	 ALIAS  TITULO   		PIC TAMANHO

TRCell():New(oSection1,"F2_DOC"     ,"TRB","DOC 	"	 ,"@!",09)
TRCell():New(oSection1,"F2_SERIE"   ,"TRB","SERIE   "	 ,"@!",03)
TRCell():New(oSection1,"F2_EMISSAO" ,"TRB","EMISSAO	"    ,"@!",08)
TRCell():New(oSection1,"F2_CLIENTE" ,"TRB","CLIENTE	"	 ,"@!",06)
TRCell():New(oSection1,"F2_LOJA"    ,"TRB","LOJA    "    ,"@!",04)
TRCell():New(oSection1,"B1_COD"	    ,"TRB","PRODUTO	"	 ,"@!",15)
TRCell():New(oSection1,"B1_DESC"	,"TRB","DESCRICAO"	 ,"@!",30)
TRCell():New(oSection1,"D2_QUANT"	,"TRB","QUANT  	"	 ,"@E 999999.99",16)
TRCell():New(oSection1,"D2_LOCAL"	,"TRB","LOCAL"       ,"@!",06)
TRCell():New(oSection1,"D2_TES"	    ,"TRB","TES"         ,"@!",03)
TRCell():New(oSection1,"D2_CF"	    ,"TRB","CFOP"        ,"@!",04)
TRCell():New(oSection1,"F2_TRANSP"	,"TRB","TRANSP"      ,"@!",06)

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintReport³ Autor ³ Artur Nucci Ferrari ³ Data ³ 07/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Responsável pela impessão do relatório               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PCP                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintReport(oReport)


Local oSection1 := oReport:Section(1)

// Selecao dos dados a Serem Impressos // Carrega o Arquivo Temporario de Trabalho

MsAguarde({|| fSelDados()},"Selecionando Itens")

// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()
oReport:SetMeter(RecCount())
oSection1:Init()
While  !Eof()
	If oReport:Cancel()
		Exit
	EndIf
	oSection1:PrintLine()
	DbSelectArea("TRB")
	DbSkip()
	oReport:IncMeter()
EndDo
oSection1:Finish()
If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

Return

// Selecao dos dados a serem impressos // criacao do temporario

Static Function fSelDados()
Local c_EOL	     := CHR(13)+CHR(10)

// Criacao arquivo de Trabalho
_aStru	:= {}

AADD(_aStru,{"F2_DOC"	    ,"C",09,0})
AADD(_aStru,{"F2_SERIE"	    ,"C",03,0})
AADD(_aStru,{"F2_EMISSAO"	,"D",08,0})
AADD(_aStru,{"F2_CLIENTE"	,"C",06,0})
AADD(_aStru,{"F2_LOJA"		,"C",04,0})
AADD(_aStru,{"B1_COD"	    ,"C",15,0})
AADD(_aStru,{"B1_DESC"		,"C",30,0})
AADD(_aStru,{"D2_QUANT"		,"N",16,2})
AADD(_aStru,{"D2_LOCAL"	    ,"C",06,0})
AADD(_aStru,{"D2_TES"		,"C",03,0})
AADD(_aStru,{"D2_CF"		,"C",04,0})
AADD(_aStru,{"F2_TRANSP"	,"C",06,0})

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"F2_DOC",,,"Selecionando Registros...")

// Montagem da Query com dados dos pedido de compras em aberto
// Seleciona os pedidos de compras e aberto

cQuery := "SELECT F2_DOC,F2_SERIE,F2_EMISSAO,F2_CLIENTE,F2_LOJA,B1_COD,B1_DESC,D2_QUANT,D2_LOCAL,D2_TES,D2_CF,F2_TRANSP FROM SF2010   " + c_EOL
cQuery += "INNER JOIN SD2010   " + c_EOL
cQuery += "ON D2_FILIAL=F2_FILIAL   " + c_EOL
cQuery += "AND D2_DOC=F2_DOC   " + c_EOL
cQuery += "AND D2_SERIE=D2_SERIE   " + c_EOL
cQuery += "AND D2_CLIENTE=F2_CLIENTE   " + c_EOL
cQuery += "AND D2_LOJA=F2_LOJA   " + c_EOL
cQuery += "AND D2_TIPO=F2_TIPO   " + c_EOL
cQuery += "AND D2_LOCAL IN ('D00006','D00026','D00015') " + c_EOL
cQuery += "AND D2_COD IN ('2206018','2206023','2206019','2206038','2206046','2206039','2206021','2206019','2205003','2206047','2206049','2206048','2206049','2206022','2206023','2206035','2206039','2206021','2206016') " + c_EOL
cQuery += "AND SD2010.D_E_L_E_T_=''   " + c_EOL
cQuery += "INNER JOIN SB1010   " + c_EOL
cQuery += "ON B1_COD=D2_COD   " + c_EOL
cQuery += "AND SB1010.D_E_L_E_T_=''   " + c_EOL
cQuery += "INNER JOIN SF4010   " + c_EOL
cQuery += "ON F4_CODIGO=D2_TES   " + c_EOL
cQuery += "AND F4_ESTOQUE='S'   " + c_EOL
cQuery += "AND SF4010.D_E_L_E_T_=''   " + c_EOL
cQuery += "WHERE SF2010.D_E_L_E_T_=''   " + c_EOL
//cQuery += "AND F2_XCARGA=''   " + c_EOL
cQuery += "AND F2_EMISSAO BETWEEN '20100617' AND '20100618'   " + c_EOL
cQuery += "AND F2_FILIAL='01'   " + c_EOL


MemoWrite("TTEMRR01.sql",cQuery)

IF SELECT("ETQ") > 0
	dbSelectArea("ETQ")
	DbCloseArea()
ENDIF

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"ETQ",.F.,.T.)

// AJUSTA CASAS DECIMAIS NO RETORNO DA QUERY

TcSetField("ETQ","D2_QUANT","N",16,2)

dbSelectArea("ETQ")
dbGotop()

While ETQ->(!Eof())
	
	DbSelectArea("TRB")
	// ADICIONA REGISTRO EM BRANCO
	RecLock("TRB",.T.)
	TRB->F2_DOC		:= ETQ->F2_DOC
	TRB->F2_SERIE	:= ETQ->F2_SERIE
	TRB->F2_EMISSAO	:= CTOD(SubStr(ETQ->F2_EMISSAO,7,2)+'/'+SubStr(ETQ->F2_EMISSAO,5,2)+'/'+SubStr(ETQ->F2_EMISSAO,3,2))
	TRB->F2_CLIENTE	:= ETQ->F2_CLIENTE
	TRB->F2_LOJA	:= ETQ->F2_LOJA
	TRB->B1_COD		:= ETQ->B1_COD
	TRB->B1_DESC	:= ETQ->B1_DESC
	TRB->D2_QUANT	:= ETQ->D2_QUANT
	TRB->D2_LOCAL	:= ETQ->D2_LOCAL
	TRB->D2_TES		:= ETQ->D2_TES
	TRB->D2_CF		:= ETQ->D2_CF
	TRB->F2_TRANSP	:= ETQ->F2_TRANSP
	MsUnlock()

	dbSelectArea("ETQ")
	DBSKIP()
Enddo

If Select("ETQ") > 0
	dbSelectArea("ETQ")
	DbCloseArea()
EndIf

Return

Static Function ValPerg(cPerg)
PutSx1(cPerg, '01', 'Etiqieta de        ?','' ,'' , 'mv_ch1', 'C', 06, 0, 0, 'G', '', ''   ,'','','mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Etiqueta até       ?','' ,'' , 'mv_ch2', 'C', 06, 0, 0, 'G', '', ''   ,'','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Emissao de         ?','' ,'' , 'mv_ch3', 'D', 08, 0, 0, 'G', '', ''   ,'','','mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Emissao até        ?','' ,'' , 'mv_ch4', 'D', 08, 0, 0, 'G', '', ''   ,'','','mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Produto de         ?','' ,'' , 'mv_ch5', 'C', 15, 0, 0, 'G', '', 'SB1','','','mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Produto até        ?','' ,'' , 'mv_ch6', 'C', 15, 0, 0, 'G', '', 'SB1','','','mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Ord. Produção de   ?','' ,'' , 'mv_ch7', 'C', 13, 0, 0, 'G', '', 'SC2','','','mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Ord. Produção até  ?','' ,'' , 'mv_ch8', 'C', 13, 0, 0, 'G', '', 'SC2','','','mv_par08',,,'','','','','','','','','','','','','','')
Return
