#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
    Relatório de Boletim de Entrada
    MIT 44_ESTOQUE_EST003 - Boletim de entrada _  boletim de entrada de nota fiscal

    DOC MIT
    https://docs.google.com/document/d/1ryOUSqK-re9ttZwBiDu_xsL34cHlGjhA/edit
    DOC Entrega
    
    
*/

User Function JESTR003()

LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "RESTAT1"
LOCAL cDesc1	    := "Boletim de Entrada"
LOCAL cDesc2	    := ""
LOCAL cDesc3	    := "Especifico JCA"
PRIVATE nLastKey 	:= 0
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "RESTAT1"
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
PRIVATE oCouNew09	:= TFont():New("Courier New"	,09,09,,.F.,,,,.T.,.F.)		// Negrito //oCouNew09N
PRIVATE oCouNew10N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew10	:= TFont():New("Courier New"	,10,10,,.F.,,,,.T.,.F.)
PRIVATE oCouNew12N	:= TFont():New("Courier New"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11N	:= TFont():New("Courier New"	,11,11,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oCouNew11 	:= TFont():New("Courier New"	,11,11,,.F.,,,,.T.,.F.)                 
PRIVATE oArial08N	:= TFont():New("Arial"			,08,08,,.T.,,,,.F.,.F.)		// Negrito
PRIVATE oArial09N	:= TFont():New("Arial"			,11,11,,.T.,,,,.F.,.F.)		// Negrito
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

Private aSm0 := FWLoadSM0()
Private aCombo   := RetSX3Box(GetSX3Cache("C1_XTIPCOT", "X3_CBOX"),,,1)

DbSelectArea("SF1")
/*If Funname() == "MNTA420" .OR. Funname() <> "MATA105"
	


	@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Entrega de peças")
	@ 008,010 TO 084,222
	@ 018,020 SAY OemToAnsi(cDesc1)
	@ 030,020 SAY OemToAnsi(cDesc2)
	@ 045,020 SAY OemToAnsi(cDesc3)

	@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)
	@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
	@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )

	ACTIVATE DIALOG oDlg CENTERED
else*/
	MV_PAR01 := SF1->F1_DOC
	MV_PAR02 := SF1->F1_SERIE
	lBrowse := .t.
	nOpcRel := 1
//EndIf


IF nOpcRel == 1 
	Processa({ |lEnd| COMR01Cfg("Impressao Boletim de Entrada")},"Imprimindo , aguarde...")
	Processa({|lEnd| GFR01(@lEnd,wnRel,cString,nReg)},titulo)
Else
	Return .f.
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³COMR01Cfg ³ Autor ³                        ³ Data ³20/02/2013³±±
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

Local cFilename := 'boletim_entrada_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.

oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
oPrint:SetLandsCape()
//oPrint:SetPortrait()

oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin(5,5,5,5) // nEsquerda, nSuperior, nDireita, nInferior 
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
±±³Fun‡…o    ³ C110PC   ³ Autor ³                     ³ Data ³ 20.02.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110	    		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GFR01(lEnd,WnRel,cString,nReg)

Local nPg		  := 0
Local cPedidos    := ''
Local cBarra      := ''

cQuery := "SELECT DISTINCT F1.*,D1.*,C7.*,B1_DESC,BE_LOCALIZ,ZPM_DESC,B1_FABRIC,B1_ZMARCA" //BZ_XLOCALI
cQuery += " FROM "+RetSQLName("SF1")+" F1"
cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE"
cQuery += " AND D1_FORNECE=F1_FORNECE AND D1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=D1_COD AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SC7")+" C7 ON C7_FILIAL=D1_FILIAL AND C7_NUM=D1_PEDIDO AND C7_ITEM=D1_ITEMPC AND C7.D_E_L_E_T_=' '"
//cQuery += " LEFT JOIN "+RetSQLName("SBZ")+" BZ ON BZ_FILIAL='"+xFilial("SBZ")+"' AND BZ_COD=B1_COD AND BZ.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SBE")+" BE ON BE_FILIAL=D1_FILIAL AND BE_LOCAL=B1_LOCPAD AND BE.D_E_L_E_T_=' '"
cQuery += " AND (CASE WHEN B1_XCODPAI = ' ' THEN B1_COD ELSE B1_XCODPAI END = BE_CODPRO)"
cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '"

cQuery += " WHERE F1_FILIAL='"+xFilial("SF1")+"' AND F1.D_E_L_E_T_=' '"

If lBrowse
	cQuery += " AND F1_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR01+"'"
	cQuery += " AND F1_SERIE BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR02+"'"
Else 
	cQuery += " AND CP_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
EndIf 

cQuery += " ORDER BY D1_ITEM"

TCQUERY cQuery NEW ALIAS "CADTMP"

//TcSetField('CADTMP','D2_EMISSAO','D')

Count To nReg

CADTMP->(dbGoTop())

li       := 5000
dEmissao := CtoD('')
cCotacao := ""
nQtdTot	 := 0
nVlrTot  := 0

ProcRegua(nReg,"Aguarde a Impressao")

While CADTMP->(!Eof())
	IncProc()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 1700 .Or. cCotacao <> CADTMP->F1_DOC
		If Li <> 5000
			oPrint:EndPage()
		Endif		
        nPg++
		
        ImpCabec()                                                                     
		
        //oPrint:Say(1800,450,OemToAnsi(cPedidos),oArial12N)
		oPrint:Say(500,1620,OemToAnsi(cPedidos),oArial12N)
		
        dEmissao := CtoD('')
		cCotacao := CADTMP->F1_DOC
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif

    If !Alltrim(CADTMP->D1_PEDIDO) $ cPedidos
        cPedidos := cBarra + Alltrim(CADTMP->D1_PEDIDO)
        cBarra := "/"
    EndIf
/*
	If len(Alltrim(CADTMP->D1_COD)+"-"+Alltrim(CADTMP->B1_DESC)) < 60
		oPrint:Say(li,050,OemToAnsi(Alltrim(CADTMP->D1_COD)+"-"+Alltrim(CADTMP->B1_DESC)),oCouNew09)
	Else 
		oPrint:Say(li,050,OemToAnsi(substr(Alltrim(CADTMP->D1_COD)+"-"+Alltrim(CADTMP->B1_DESC),1,60)),oCouNew09)
		oPrint:Say(li+14,050,OemToAnsi(substr(Alltrim(CADTMP->D1_COD)+"-"+Alltrim(CADTMP->B1_DESC),61)),oCouNew09)
	EndIf 
*/	
	//nPosx := Ascan(aSM0,{|x| Alltrim(x[2]) == Alltrim(CADTMP->C7_FILENT)})
	//oPrint:Say(li,060,OemToAnsi(Alltrim(CADTMP->C7_FILENT)+If(nPosx>0,aSM0[nPosx,07],'')),oCouNew09)
	oPrint:Say(li,060,OemToAnsi(Alltrim(CADTMP->C7_FILENT)),oCouNew09)
	oPrint:Say(li,390,OemToAnsi(Alltrim(CADTMP->D1_COD)),oCouNew09)
	oPrint:Say(li,690,OemToAnsi(Alltrim(CADTMP->B1_DESC)),oCouNew09)

	//oPrint:Say(li,890,OemToAnsi(Alltrim(CADTMP->BZ_XLOCALI)),oCouNew10)
	//oPrint:Say(li,1290,OemToAnsi("-"),oCouNew10)  //solicitado em 19/04
	oPrint:Say(li,1580,OemToAnsi(cvaltochar(CADTMP->D1_QUANT)),oCouNew10)
	oPrint:Say(li,1710,OemToAnsi(Alltrim(CADTMP->B1_FABRIC)),oCouNew09)

	oPrint:Say(li,1940,OemToAnsi(Alltrim(CADTMP->B1_ZMARCA)+' '+Alltrim(CADTMP->ZPM_DESC)),oCouNew09)
	oPrint:Say(li,2230,OemToAnsi(Alltrim(CADTMP->BE_LOCALIZ)),oCouNew09) //BZ_XLOCALI
	
	oPrint:Say(li,2530,OemToAnsi(Alltrim(Posicione("SC1",1,CADTMP->C7_FILIAL+CADTMP->C7_NUMSC+CADTMP->C7_ITEMSC,"C1_PREFIX"))),oCouNew09)
	
	If !Empty(CADTMP->C7_ZTPCOM)
		nPosx := ascan(aCombo,{|x| x[2] == CADTMP->C7_ZTPCOM})
		If nPosX > 0
			oPrint:Say(li,2830,OemToAnsi(aCombo[nPosx,3]),oCouNew09)
		EndIF 
	EndIf 
	
	
	//oPrint:Say(li,1790,OemToAnsi(Transform(CADTMP->D1_VUNIT,"@E 999,999,999.99")),oCouNew10)
	//oPrint:Say(li,2190,OemToAnsi(Transform(CADTMP->D1_TOTAL,"@E 999,999,999.99")),oCouNew10)
	li+=050

	
	CADTMP->(DbSkip())

EndDo

oPrint:Say(500,1620,OemToAnsi(cPedidos),oArial12N)


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

//Local aDescAD   :=  {"DESCONTOS","FRETES","BASE CALC. ICMS","ICMS","BASE CALC. IPI","IPI","SUBST.TRIBUTARIA","SEGUROS","PIS","COFINS","INSS","ISS","IRRF","CSL"}
//Local aAcrDsc   :=  {"F1_DESCONT","F1_FRETE","F1_BASEICM","F1_VALICM","F1_BASEIPI","F1_VALIPI","F1_ICMSRET","F1_SEGURO","F1_VALPIS","F1_VALCOFI","F1_INSS","F1_ISS","F1_IRRF","F1_VALCSLL"}
//Local nX 

oPrint:StartPage() 		// Inicia uma nova pagina
//BOX PRINCIPAL
//oPrint:Box(000,0030,3000,2550 )  //LINHA/COLUNA/ALTURA/LARGURA

oBrush1 := TBrush():New( , CLR_HGRAY)

oPrint:Fillrect( {000, 030, 150, 3140 }, oBrush1, "-2")

oPrint:Box(158,0028,390,1565 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {160, 032, 250, 1563 }, oBrush1, "-2")

oPrint:Box(158,1596,390,3145 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {160, 1600, 250, 3140 }, oBrush1, "-2")

oPrint:Box(402,0028,540,1565 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {404, 032, 450, 1563 }, oBrush1, "-2")

oPrint:Box(402,1596,540,3145 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {404, 1600, 450, 3140 }, oBrush1, "-2")

oPrint:Box(551,0028,2040,3145 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {556, 033, 645, 3140 }, oBrush1, "-2")

oPrint:Box(2160,0028,2380,1565 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {2165, 032, 2213, 1563 }, oBrush1, "-2")

oPrint:Box(2160,1596,2380,3145 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Fillrect( {2165, 1600, 2213, 3140 }, oBrush1, "-2")

oPrint:Say(095,1240,OemToAnsi("BOLETIM DE ENTRADA - JCA"),oArial14N)
oPrint:SayBitMap(045,0070,cBitLogo,0080,0080)
oPrint:SayBitMap(045,3000,cBitmap,0080,0080)

oPrint:Say(215,0640,OemToAnsi("FILIAL DE ENTREGA"),oArial14N)

oPrint:line(320,0030,320,1565,1)
oPrint:line(250,850,390,850,1)

nPosx := Ascan(aSM0,{|x| Alltrim(x[2]) == Alltrim(SF1->F1_EMISSAO)})

If nPosx > 0
	oPrint:Say(300,0040,OemToAnsi( aSM0[nPosx,03]+" "+aSM0[nPosx,17]),oCouNew10)
	oPrint:Say(300,0880,OemToAnsi('CNPJ: '+Transform(aSM0[nPosx,18],"@R 99.999.999/9999-99") ),oCouNew10)

	oPrint:Say(360,0040,OemToAnsi( Alltrim(SF1->F1_FILIAL)+" "+Alltrim(aSM0[nPosx,07])),oCouNew10)
Else 
	oPrint:Say(300,0040,OemToAnsi( SM0->M0_CODIGO+" "+SM0->M0_NOMECOM),oCouNew10)
	oPrint:Say(300,0880,OemToAnsi('CNPJ: '+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") ),oCouNew10)

	oPrint:Say(360,0040,OemToAnsi( Alltrim(SF1->F1_FILIAL)+" "+SM0->M0_FILIAL),oCouNew10)
EndIf 

oPrint:Say(360,0880,OemToAnsi( SM0->M0_ENDENT ),oCouNew10)

oPrint:Say(215,1630,OemToAnsi("NOTA FISCAL"),oArial14N)
oPrint:line(158,1900,390,1900,1)
oPrint:Say(215,1960,OemToAnsi("EMISSÃO"),oArial14N)
oPrint:line(158,2200,390,2200,1)
oPrint:Say(215,2220,OemToAnsi("DATA ENTRADA"),oArial14N)
oPrint:line(158,2500,390,2500,1)
oPrint:Say(215,2540,OemToAnsi("VALOR TOTAL"),oArial14N)
oPrint:line(158,2850,390,2850,1)
oPrint:Say(215,2880,OemToAnsi("VENCIMENTO"),oArial14N)

oPrint:Say(330,1642,OemToAnsi(SF1->F1_DOC),oCouNew11N)
oPrint:Say(330,1985,OemToAnsi(CVALTOCHAR(SF1->F1_EMISSAO)),oCouNew11N)
oPrint:Say(330,2240,OemToAnsi(CVALTOCHAR(SF1->F1_DTDIGIT)),oCouNew11N)
oPrint:Say(330,2550,OemToAnsi(Transform(SF1->F1_VALBRUT,"@E 999,999,999.99")),oCouNew11N)

dVencto := Posicione("SE2",6,SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC,"E2_VENCREA")
oPrint:Say(330,2890,OemToAnsi(CVALTOCHAR(dVencto)),oCouNew11N)

oPrint:Say(440,0040,OemToAnsi("Fornecedor"),oArial11N)
oPrint:Say(440,1610,OemToAnsi("Pedido (s)"),oArial11N)

oPrint:Say(500,050,OemToAnsi(SF1->F1_FORNECE+SF1->F1_LOJA+'-'+POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")),oCouNew11)
//oPrint:Say(500,1620,OemToAnsi(''),oCouNew11)


oPrint:Say(600,0050,OemToAnsi("Filial Destino"),oArial11N)
oPrint:line(551,350,2040,350,1)
oPrint:Say(600,0380,OemToAnsi("Cód. Produto"),oArial11N)
oPrint:line(551,650,2040,650,1)
oPrint:Say(600,0680,OemToAnsi("Descrição Produto"),oArial11N)
oPrint:line(551,1550,2040,1550,1)
oPrint:Say(600,1580,OemToAnsi("Qtd."),oArial11N)
oPrint:line(551,1700,2040,1700,1)
oPrint:Say(600,1710,OemToAnsi("Cód. Original"),oArial11N)
oPrint:line(551,1900,2040,1900,1)
oPrint:Say(600,1930,OemToAnsi("Marca"),oArial11N)
oPrint:line(551,2200,2040,2200,1)
oPrint:Say(600,2230,OemToAnsi("Endereço"),oArial11N)
oPrint:line(551,2500,2040,2500,1)
oPrint:Say(600,2530,OemToAnsi("Prefixo"),oArial11N)
oPrint:line(551,2800,2040,2800,1)
oPrint:Say(600,2830,OemToAnsi("Tipo Solicitação"),oArial11N)


oPrint:Say(2204,0590,OemToAnsi("ASSINATURA CONFERENTE"),oArial11N)
oPrint:line(2340,200,2340,1400,1)
oPrint:Say(2204,1970,OemToAnsi("ASSINATURA CONFERENTE"),oArial11N)
oPrint:line(2340,1700,2340,3000,1)



/*
oPrint:Say(050,0040,OemToAnsi("Empresa :"),oArial11N)
oPrint:Say(050,0280,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOME ),oArial11N)
oPrint:Say(050,2040,OemToAnsi("CNPJ :"),oArial11N)
oPrint:Say(050,2180,OemToAnsi(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") ),oArial11N)

oPrint:Say(090,0040,OemToAnsi("Filial  :"),oArial11N)
oPrint:Say(090,0280,OemToAnsi( + SM0->M0_CODFIL+" "+SM0->M0_NOMECOM),oArial11N)
oPrint:Say(090,1900,OemToAnsi("Inscricao Estadual  :"),oArial11N)
oPrint:Say(090,2210,OemToAnsi( SM0->M0_INSC),oArial11N)

oPrint:Say(130,0040,OemToAnsi("Endereço :"),oArial11N)
oPrint:Say(130,0280,OemToAnsi( SM0->M0_ENDENT+" "+SM0->M0_COMPENT),oArial11N)
oPrint:Say(130,2040,OemToAnsi("Emissao :"),oArial11N)
oPrint:Say(130,2210,OemToAnsi( CVALTOCHAR(SF1->F1_EMISSAO) ),oArial11N)
*/
//oPrint:line(160,0030,160,2550,1)

//oPrint:Say(210,0780,OemToAnsi("AUTORIZACAO DE PAGAMENTO DE FORNECEDOR"),oArial14N)

//CAB1
/*oPrint:Box(240,030,340,850 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(240,850,340,1250 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(240,1250,340,1750 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(240,1750,340,2150 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(240,2150,340,2550 )  //LINHA/COLUNA/ALTURA/LARGURA*/
/*
oPrint:Say(300,280,OemToAnsi("FORNECEDOR"),oArial14N)
oPrint:Say(300,890,OemToAnsi("NOTA FISCAL"),oArial14N)
oPrint:Say(300,1290,OemToAnsi("DATA EMISSAO NF"),oArial14N)
oPrint:Say(300,1790,OemToAnsi("DATA ENTRADA"),oArial14N)
oPrint:Say(300,2190,OemToAnsi("NAT. OPER."),oArial14N)
*/
/*
oPrint:Box(340,030,440,850 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(340,850,440,1250 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(340,1250,440,1750 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(340,1750,440,2150 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(340,2150,440,2550 )  //LINHA/COLUNA/ALTURA/LARGURA
*/
/*
oPrint:Say(400,050,OemToAnsi(POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")),oCouNew11)
oPrint:Say(400,890,OemToAnsi(SF1->F1_DOC),oCouNew11)
oPrint:Say(400,1320,OemToAnsi(CVALTOCHAR(SF1->F1_EMISSAO)),oCouNew11)
oPrint:Say(400,1820,OemToAnsi(CVALTOCHAR(SF1->F1_DTDIGIT)),oCouNew11)
oPrint:Say(400,2180,OemToAnsi("NAT. OPER."),oCouNew11)
*/

/*
oPrint:Box(440,030,540,850 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(440,850,540,1250 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(440,1250,540,1750 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(440,1750,540,2150 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(440,2150,540,2550 )  //LINHA/COLUNA/ALTURA/LARGURA
*/
/*
oPrint:Say(500,260,OemToAnsi("CONTA DEVEDORA"),oArial14N)
oPrint:Say(500,890,OemToAnsi("CONTA CREDORA"),oArial14N)
oPrint:Say(500,1290,OemToAnsi("DEVEDORA"),oArial14N)
oPrint:Say(500,1790,OemToAnsi("CREDORA"),oArial14N)
oPrint:Say(500,2190,OemToAnsi("TP. DOCTO."),oArial14N)
*/
/*
oPrint:Box(540,030,640,850 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(540,850,640,1250 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(540,1250,640,1750 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(540,1750,640,2150 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(540,2150,640,2550 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Box(640,030,740,850 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(640,850,740,1250 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(640,1250,740,1550 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(640,1550,740,1750 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(640,1750,740,2150 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(640,2150,740,2550 )  //LINHA/COLUNA/ALTURA/LARGURA
*/

//primeira linha dos itens 700
/*
oPrint:Say(700,260,OemToAnsi("MATERIAL"),oArial14N)
oPrint:Say(700,890,OemToAnsi("LOCALIZACAO"),oArial14N)
oPrint:Say(700,1290,OemToAnsi("PREFIXO"),oArial14N)
oPrint:Say(700,1590,OemToAnsi("QTDE"),oArial14N)
oPrint:Say(700,1790,OemToAnsi("VALOR UNITARIO"),oArial14N)
oPrint:Say(700,2190,OemToAnsi("TOTAL"),oArial14N)

/*
oPrint:line(1740,0030,1740,2550,1)
oPrint:Box(1740,030,1840,350 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:line(1840,0030,1840,2550,1)*/
/*oPrint:Say(1800,50,OemToAnsi("PEDIDO(s)"),oArial14N)

oPrint:Say(1900,1490,OemToAnsi("TOTAL DOS PRODUTOS: "),oArial14N)
oPrint:Say(1900,1990,OemToAnsi(TRANSFORM(SF1->F1_VALMERC,"@E 999,999,999.99")),oCouNew11)

//oPrint:line(1940,0030,1940,2550,1)
//ultima linha dos itens 2010
oPrint:Say(2000,590,OemToAnsi("VENCIMENTOS "),oArial14N)
oPrint:Say(2000,1790,OemToAnsi("ACRESCIMOS / DESCONTOS "),oArial14N)
*/
//nPosRef := 2100
/*
For nX := 1 to len(aAcrDsc)

    oPrint:Say(nPosRef,1700,aDescAD[nX],oCouNew10) 
    oPrint:Say(nPosRef,1990,OemToAnsi(Transform(&("SF1->"+aAcrDsc[nX]),"@R 999,999.99")),oCouNew10)   
    nPosRef += 50 
Next nX 
*/
//oPrint:line(2040,0030,2040,2550,1)

//oPrint:line(2040,1550,2800,1550,1)

//oPrint:line(2800,0030,2800,2550,1)
/*
oPrint:Say(2860,1550,OemToAnsi("TOTAL LIQUIDO "),oArial14N)
oPrint:Say(2860,1990,OemToAnsi(TRANSFORM(SF1->F1_VALBRUT,"@E 999,999,999.99")),oCouNew11)

//oPrint:line(2900,0030,2900,2550,1)
oPrint:Say(2960,50,OemToAnsi("JCA - TOTVS"),oArial14N)
*/
li       := 700

Return 
