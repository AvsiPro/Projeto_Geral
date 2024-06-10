#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
    Relatório de Vendas Perdidas
    MIT 44_ESTOQUE_EST010 - Relatório venda perdida

    DOC MIT
    https://docs.google.com/document/d/1NbATZu4GJBMnmfoSdiBFXaBUAQgcqZaX/edit
    DOC Entrega
    
    
*/

User Function JESTR004()

LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "JESTR004"
LOCAL cDesc1	    := "Relação Vendas perdidas"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico JCA"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RESTR10",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "JESTR004"
PRIVATE lEnd        := .F.

PRIVATE nBegin		:= 0
PRIVATE nDifColCC   := 0

PRIVATE aSenhas		:= {}
PRIVATE aUsuarios	:= {}
PRIVATE M_PAG	    := 1

Private oPrint
PRIVATE nSalto      := 50
PRIVATE lFirstPage  := .T.
Private oBrush  	:= TBrush():NEW("",CLR_HGRAY)          
Private oBrushG  	:= TBrush():NEW("",CLR_YELLOW)          
Private oPen		:= TPen():New(0,5,CLR_BLACK)
PRIVATE oCouNew08	:= TFont():New("Courier New"	,08,08,,.F.,,,,.T.,.F.)
PRIVATE oCouNew08N	:= TFont():New("Courier New"	,08,08,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew09N	:= TFont():New("Courier New"	,09,09,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew10N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12N	:= TFont():New("Courier New"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11N	:= TFont():New("Courier New"	,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11 	:= TFont():New("Courier New"	,11,11,,.F.,,,,.T.,.F.)                 
PRIVATE oArial08N	:= TFont():New("Arial"			,08,08,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial09N	:= TFont():New("Arial"			,09,09,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial10N	:= TFont():New("Arial"			,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial11N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial12N	:= TFont():New("Arial"			,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial14N	:= TFont():New("Arial"			,14,14,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew12S	:= TFont():New("Courier New",12,12,,.T.,,,,.F.,.F.)		// SubLinhado
PRIVATE cContato    := ""
PRIVATE cNomFor     := ""
Private nReg 		:= 0
Private lBrowse		:= .F.

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

chkfile("ZPC")

If Funname() == "MNTA420" .OR. Funname() <> "MATA105"
	//AjustaSx1(cPerg)
	//Pergunte(cPerg,.f.)


	@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Entrega de peças")
	@ 008,010 TO 084,222
	@ 018,020 SAY OemToAnsi(cDesc1)
	@ 030,020 SAY OemToAnsi(cDesc2)
	@ 045,020 SAY OemToAnsi(cDesc3)

	@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)
	@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
	@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )

	ACTIVATE DIALOG oDlg CENTERED
else
	MV_PAR01 := SCP->CP_NUM
	MV_PAR02 := SCP->CP_NUM
	lBrowse := .t.
	nOpcRel := 1
EndIf


IF nOpcRel == 1 
	Processa({ |lEnd| COMR01Cfg("Impressao Relação de vendas perdidas")},"Imprimindo , aguarde...")
	Processa({ |lEnd| GFR01(@lEnd,wnRel,cString,nReg)},titulo)
Else
	Return .f.
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³COMR01Cfg ³ Autor ³ Alexandre Venancio   ³ Data ³01/12/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria os objetos para relat. grafico.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function COMR01Cfg(Titulo)

Local cFilename := 'vendas_perdidas_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.

oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
//oPrint:SetLandsCape()
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF 
cDiretorio := oPrint:cPathPDF

If	MAKEDIR('C:\TEMP')!= 0
	//		Aviso(STR0001,STR0026+cPathOri+STR0027,{"OK"}) //"Inconsistencia"###"Nao foi possivel criar diretorio "###".Finalizando ..."
	return nil
EndIf

Return Nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Alexandre Venancio    ³ Data ³ 20.02.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110	    		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GFR01(lEnd,WnRel,cString,nReg)

Local aAux := {}
nPg		  := 0

/*
mv_par02 := 'zzz'
mv_par03 := ctod('01/01/2000')
mv_par04 := ctod('01/01/2100')
mv_par06 := 'zzz'
mv_par08 := 'zzz'
mv_par10 := 'zzz'
mv_par12 := 'zzz'
*/

cQuery := "SELECT ZPC_FILIAL,ZPC_REQUIS,ZPC_CODIGO,B1_DESC,B1_EMIN,ZPC_LOCAL,ZPC_QUANT,"
cQuery += " ZPC_DATA,ZPC_PREFIX,ZPC_SOLICI,RA_NOME,ZPC_STATUS,ZPC_ITEM,ZPC_TIPO,ZPC_ALMOXA,CP_OP"
cQuery += " FROM "+RetSQLName("ZPC")+" ZPC"
cQuery += " INNER JOIN "+RetSQLName("SCP")+" CP ON CP_FILIAL=ZPC_FILIAL AND CP_NUM=ZPC_REQUIS AND CP.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=ZPC_CODIGO AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SRA")+" RA ON RA_FILIAL=ZPC_FILIAL AND RA_MAT=ZPC_SOLICI AND RA.D_E_L_E_T_=' '"
cQuery += " WHERE ZPC_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"

cQuery += " AND ZPC_DATA BETWEEN '"+dtos(MV_PAR03)+"' AND '"+dtos(MV_PAR04)+"'"
cQuery += " AND ZPC_CODIGO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
cQuery += " AND ZPC_PREFIX BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
cQuery += " AND ZPC_SOLICI BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
cQuery += " AND ZPC_REQUIS BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"


cQuery += " ORDER BY ZPC_REQUIS"

TCQUERY cQuery NEW ALIAS "CADTMP"

TcSetField('CADTMP','ZPC_REQUIS','C')

Count To nReg

CADTMP->(dbGoTop())

li       := 5000
dEmissao := CtoD('')
cCotacao := ""
nQtdTot	 := 0
nVlrTot  := 0

ProcRegua(nReg,"Aguarde a Impressao")

cOpcoes := GetSx3Cache( "ZPC_TIPO" ,"X3_CBOX"	)
aAux := Separa(cOpcoes,";")
   
While CADTMP->(!Eof())
	IncProc()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 1900 //.Or. cCotacao <> CADTMP->CP_NUM
		If Li <> 5000
			oPrint:EndPage()
		Endif		
	
		nPg++
		ImpCabec()                                                                     
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif

	cPrefixo := Posicione("STJ",1,CADTMP->ZPC_FILIAL+substr(CADTMP->CP_OP,1,6),"TJ_CODBEM")
	oPrint:Say(li,0055,Alltrim(CADTMP->ZPC_CODIGO),oArial09N)
	oPrint:Say(li,0290,substr(CADTMP->B1_DESC,1,48),oArial09N)
	oPrint:Say(li,0990,Alltrim(CADTMP->ZPC_REQUIS),oArial09N)
    oPrint:Say(li,1200,cvaltochar(CADTMP->ZPC_QUANT),oArial09N)
    //material planejado
	oPrint:Say(li,1320,If(CADTMP->B1_EMIN>0,"SIM","NÃO"),oArial09N)
    oPrint:Say(li,1500,CADTMP->ZPC_ALMOXA,oArial09N)
    oPrint:Say(li,1710,CADTMP->ZPC_SOLICI,oArial09N)
    oPrint:Say(li,1970,cvaltochar(stod(CADTMP->ZPC_DATA)),oArial09N)
    oPrint:Say(li,2160,Alltrim(cPrefixo),oArial09N)

	If len(aAux) > 0 .And. !Empty(CADTMP->ZPC_TIPO)
		nPosx := val(CADTMP->ZPC_TIPO)
		If nPosx > 0
			oPrint:Say(li,2330,substr(aAux[nPosx],3),oArial09N)
		Endif 
	EndIf 
    
	li+=20

	oPrint:Say(li,0030,Replicate("-",211),oCouNew08)

	li+=50

	CADTMP->(DbSkip(1))
    
EndDo

oPrint:EndPage()

oPrint:Preview() 

CADTMP->(dbCloseArea())	

Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Alexandre Venancio         ³ Data ³     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()

Local cBitmap      := '\system\lgrl01.bmp'
Local cBitLogo	   := '\system\logo_1001.bmp'

oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(000,0030,3100,2540 )  //LINHA/COLUNA/ALTURA/LARGURA

oBrush1 := TBrush():New( , CLR_HGRAY)

oPrint:Fillrect( {000, 030, 150, 2540 }, oBrush1, "-2")

oPrint:SayBitMap(045,0070,cBitLogo,0080,0080)
oPrint:Say(070,1050,OemToAnsi("Relatório de Venda Perdida"),oArial14N)  
oPrint:SayBitMap(045,2400,cBitmap,0080,0080)

oPrint:Fillrect( {160, 030, 200, 1200 }, oBrush1, "-2")
oPrint:Box(200,0030,300,1200 )
oPrint:line(250,0030,250,1195 )
oPrint:line(200,0535,300,535 )

oPrint:Say(190,0510,OemToAnsi("FILIAL"),oArial14N)
oPrint:Say(230,0035,OemToAnsi(Substr(alltrim(SM0->M0_CODIGO)+" "+alltrim(SM0->M0_NOMECOM),1,30) ),oArial10N)
oPrint:Say(230,0540,OemToAnsi("CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") ),oArial10N)
oPrint:Say(280,0035,OemToAnsi( SM0->M0_FILIAL),oArial10N)
oPrint:Say(280,0540,OemToAnsi( SM0->M0_ENDENT),oArial10N)


oPrint:Fillrect( {160, 1210, 230, 2535 }, oBrush1, "-2")
oPrint:Box(225,1210,300,2535 )
oPrint:line(160,1370,300,1370 ,2)
oPrint:line(160,1530,300,1530 ,2)
oPrint:line(160,1690,300,1690 ,2)
oPrint:line(160,1850,300,1850 ,2)
oPrint:line(160,2010,300,2010 ,2)
oPrint:line(160,2170,300,2170 ,2)
oPrint:line(160,2330,300,2330 ,2)

oPrint:Say(190,1220,OemToAnsi("Prefixo de"),oArial10N)
oPrint:Say(190,1380,OemToAnsi("Prefixo Até"),oArial10N)
oPrint:Say(190,1540,OemToAnsi("Solicit. De"),oArial10N)
oPrint:Say(190,1700,OemToAnsi("Solicit. Até"),oArial10N)
oPrint:Say(190,1860,OemToAnsi("Data De"),oArial10N)
oPrint:Say(190,2020,OemToAnsi("Data Até"),oArial10N)
oPrint:Say(190,2180,OemToAnsi("Código De"),oArial10N)
oPrint:Say(190,2340,OemToAnsi("Código Até"),oArial10N)


oPrint:Say(265,1230,OemToAnsi(MV_PAR07),oArial11N)
oPrint:Say(265,1390,OemToAnsi(MV_PAR08),oArial11N)
oPrint:Say(265,1550,OemToAnsi(MV_PAR09),oArial11N)
oPrint:Say(265,1700,OemToAnsi(MV_PAR10),oArial11N)
oPrint:Say(265,1868,OemToAnsi(cvaltochar(MV_PAR03)),oCouNew08N)
oPrint:Say(265,2030,OemToAnsi(cvaltochar(MV_PAR04)),oCouNew08N)
oPrint:Say(265,2190,OemToAnsi(MV_PAR11),oArial11N)
oPrint:Say(265,2350,OemToAnsi(MV_PAR12),oArial11N)

oPrint:Fillrect( {330, 030, 400, 2540 }, oBrush1, "-2")

oPrint:Say(360,0055,OemToAnsi("Código do"),oArial10N)
oPrint:Say(390,0055,OemToAnsi("Produto"),oArial10N)
oPrint:line(330,280,3100,280 )

oPrint:Say(360,0300,OemToAnsi("Descrição Produto"),oArial10N)
oPrint:line(330,970,3100,970 )

oPrint:Say(360,0980,OemToAnsi("Requisição"),oArial10N)
oPrint:line(330,1150,3100,1150 )

oPrint:Say(360,1160,OemToAnsi("Qtd"),oArial10N)
oPrint:line(330,1290,3100,1290 )

oPrint:Say(360,1300,OemToAnsi("Material"),oArial10N)
oPrint:Say(390,1300,OemToAnsi("Planejado"),oArial10N)
oPrint:line(330,1470,3100,1470 )

oPrint:Say(360,1480,OemToAnsi("Matricula"),oArial10N)
oPrint:Say(390,1480,OemToAnsi("Almoxarife"),oArial10N)
oPrint:line(330,1690,3100,1690 )

oPrint:Say(360,1700,OemToAnsi("Matricula"),oArial10N)
oPrint:Say(390,1700,OemToAnsi("Requisitante"),oArial10N)
oPrint:line(330,1950,3100,1950 )

oPrint:Say(360,1960,OemToAnsi("Data do"),oArial10N)
oPrint:Say(390,1960,OemToAnsi("Registro"),oArial10N)
oPrint:line(330,2140,3100,2140 )

oPrint:Say(360,2150,OemToAnsi("Prefixo"),oArial10N)
oPrint:line(330,2310,3100,2310 )

oPrint:Say(360,2320,OemToAnsi("Tipo"),oArial10N)

li := 480

Return 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Alexandre Venancio         ³ Data ³     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1(cPerg)
Local nLh 
Local	_nx		:= 0,;
		_nh		:= 0,;
		_nlh	:= 0,;
		_aHelp	:= Array(8,1),;
		_aRegs  := {},;
		_sAlias := Alias(),;
		_aHead	:= {"X1_GRUPO","X1_ORDEM","X1_PERGUNTE","X1_PERSPA","X1_PERENG	",;
					"X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
					"X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEF02",;
					"X1_DEF03","X1_DEF04","X1_DEF05","X1_F3"}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria uma array, contendo todos os valores...³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(_aRegs,{cPerg,'01',"Filial de?","","",'mv_ch1','C', 8,0,0,'G','','mv_par01','','','','',"",""})
		aAdd(_aRegs,{cPerg,'02',"Filial de?","","",'mv_ch2','C', 8,0,0,'G','','mv_par02','','','','',"",""})
		aAdd(_aRegs,{cPerg,'03',"Emissao Inicial ?" ,"Emissao Inicial ?" ,"Emissao Inicial ?" ,'mv_ch3','D',08,0,0,'G','','mv_par03','','','','',"",""})
		aAdd(_aRegs,{cPerg,'04',"Emissao Final? "   ,"Emissao Final? "   ,"Emissao Final? "   ,'mv_ch4','D',08,0,0,'G','','mv_par04','','','','',"",""})
		aAdd(_aRegs,{cPerg,'05',"Material de?","","",'mv_ch5','C', 6,0,0,'G','','mv_par05','','','','',"","SB1"})
		aAdd(_aRegs,{cPerg,'06',"Material de?","","",'mv_ch6','C', 6,0,0,'G','','mv_par06','','','','',"","SB1"})
		aAdd(_aRegs,{cPerg,'07',"Prefixo de?","","",'mv_ch7','C', 6,0,0,'G','','mv_par07','','','','',"",""})
		aAdd(_aRegs,{cPerg,'08',"Prefixo ate?","","",'mv_ch8','C', 6,0,0,'G','','mv_par08','','','','',""," "})
		aAdd(_aRegs,{cPerg,'09',"Solicitante de?","","",'mv_ch9','C', 6,0,0,'G','','mv_par09','','','','',"","SRA"})
		aAdd(_aRegs,{cPerg,'10',"Solicitante ate?","","",'mv_cha','C', 6,0,0,'G','','mv_par10','','','','',"","SRA"})
		aAdd(_aRegs,{cPerg,'11',"Requisição de?","","",'mv_chb','C', 6,0,0,'G','','mv_par11','','','','',"","SCP"})
		aAdd(_aRegs,{cPerg,'12',"Requisição ate?","","",'mv_chc','C', 6,0,0,'G','','mv_par12','','','','',"","SCP"})
		
        DbSelectArea('SX1')
		SX1->(DbSetOrder(1))

		For _nx:=1 to Len(_aRegs)
			If	RecLock('SX1',Iif(!SX1->(DbSeek(_aRegs[_nx][01]+_aRegs[_nx][02])),.t.,.f.))
				For nlh:=1 to Len(_aHead)
				If	( nlh <> 10 )
						Replace &(_aHead[nlh]) With _aRegs[_nx][nlh]
					EndIf
				Next nlh
				MsUnlock()
			Else
				Help('',1,'REGNOIS')
			Endif
	
		Next _nx
Return Nil
