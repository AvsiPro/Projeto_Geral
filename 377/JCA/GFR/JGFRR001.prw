#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
    Relatório Impressão da Ordem de serviço no modelo da JCA.
    MIT 44_Frotas GFR004_Impressão da Ordem de serviço

    DOC MIT
    https://docs.google.com/document/d/1IyRgdtP9qWzsJWT-XeFa-2l9_JZdDDKU/edit#heading=h.gjdgxs
    DOC Entrega
    
    
*/

User Function JGFRR001()

LOCAL cString		:= ""
Local titulo 		:= ""
LOCAL wnrel		 	:= "RGFR001"
LOCAL cDesc1	    := "Relação Ordem de Serviço JCA"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico JCA"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RGFR001",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "RGFR001"
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
PRIVATE oCouNew14N	:= TFont():New("Courier New"	,14,14,,.T.,,,,.F.,.F.)		// Negrito
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

If !MsgYesNo("Imprimir OS posicionada?")
	AjustaSx1(cPerg)
	Pergunte(cPerg,.f.)


	@ 096,042 TO 323,505 DIALOG oDlg TITLE OemToAnsi("Relatorio de Ordem de Serviço")
	@ 008,010 TO 084,222
	@ 018,020 SAY OemToAnsi(cDesc1)
	@ 030,020 SAY OemToAnsi(cDesc2)
	@ 045,020 SAY OemToAnsi(cDesc3)

	@ 095,120 BMPBUTTON TYPE 5 	ACTION Pergunte(cPerg,.T.)
	@ 095,155 BMPBUTTON TYPE 1  ACTION Eval( { || nOpcRel := 1, oDlg:End() } )
	@ 095,187 BMPBUTTON TYPE 2  ACTION Eval( { || nOpcRel := 0, oDlg:End() } )

	ACTIVATE DIALOG oDlg CENTERED
Else 
	MV_PAR01 := STJ->TJ_ORDEM
	lBrowse  := .t.
	nOpcRel  := 1
EndIf



IF nOpcRel == 1 
	Processa({ |lEnd| COMR01Cfg("Impressao OS")},"Imprimindo , aguarde...")
    //ImpCabec() 
    
	Processa({|lEnd| GFR01(@lEnd,wnRel,cString,nReg)},titulo)
Else
	Return .f.
Endif

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³COMR01Cfg ³ Autor ³ Luiz Alberto    ³ Data ³20/02/2013³±±
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

Local cFilename := 'ordem_servico'

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
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Luiz Alberto     ³ Data ³ 20.02.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110	    		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GFR01(lEnd,WnRel,cString,nReg)

Local nCont 
nPg		  := 0

cQuery := "SELECT TJ_FILIAL,TJ_ORDEM,TJ_DTORIGI,TJ_HORACO1,TJ_SERVICO,T4_NOME,TJ_CODBEM,T9_PLACA,TJ_POSCONT,TL_TAREFA,TT9_DESCRI"
cQuery += " FROM "+RetSQLName("STJ")+" TJ"
cQuery += " INNER JOIN "+RetSQLName("STL")+" TL ON TL_FILIAL=TJ_FILIAL AND TL_ORDEM=TJ_ORDEM AND TL.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("TT9")+" TT9 ON TT9_FILIAL='"+xFilial("TT9")+"' AND TT9_TAREFA=TL_TAREFA AND TT9.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("ST4")+" T4 ON T4_FILIAL='"+xFilial("ST4")+"' AND T4_SERVICO=TJ_SERVICO AND T4.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("ST9")+" T9 ON T9_FILIAL='"+xFilial("ST9")+"' AND T9_CODBEM=TJ_CODBEM AND T9.D_E_L_E_T_=' '"
cQuery += " WHERE TJ.D_E_L_E_T_=' '" 
cQuery += " AND TJ_FILIAL='"+xFilial("STJ")+"'"

If lBrowse
	cQuery += " AND TJ_ORDEM='"+MV_PAR01+"'"

else
	cQuery += " AND TJ_DTORIGI BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	cQuery += " AND TJ_ORDEM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"

EndIf 
 

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

//For nCont := 1 to 20 
While CADTMP->(!Eof())
	IncProc()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se havera salto de formulario                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If li > 2900 .Or. cCotacao <> CADTMP->TJ_ORDEM
		If Li <> 5000
			oPrint:EndPage()
		Endif		
	
		nPg++
		ImpCabec()                                                                     
		dEmissao := CtoD('')
		cCotacao := CADTMP->TJ_ORDEM
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif

	oPrint:Say(li,0060,"Grupo de defeito: ",oCouNew14N)
	oPrint:Say(li,0500,CADTMP->TJ_SERVICO+" - "+CADTMP->T4_NOME,oArial14N)
	
    li+=150

    oPrint:Say(li,0060,"Defeito: ",oCouNew12N)
	oPrint:Say(li,0280,CADTMP->TL_TAREFA+" - "+CADTMP->TT9_DESCRI,oArial12N)
	
    oPrint:Say(li,1560,"Matricula",oCouNew12N)
    oPrint:Say(li,1830,"Hora   Inicial",oCouNew12N)
    oPrint:Say(li,2160,"Hora   Final ",oCouNew12N)

    li+=70

    oPrint:Say(li,0060,"ALAVANCA DURA ",oCouNew12N)

	oPrint:Say(li,1050,"V ( )   T ( )",oCouNew12N)
    
    oPrint:Say(li,1560,"_____________",oCouNew12N)
    oPrint:Say(li,1830,"______:______",oCouNew12N)
    oPrint:Say(li,2160,"______:______",oCouNew12N)
    
	

	li+=150
	
	CADTMP->(DbSkip(1))

EndDo
//Next nCont

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


oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(000,0030,3100,2550 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(060,0040,OemToAnsi("Ordem de Seriço corretiva :"),oCouNew12N)
oPrint:Say(060,0580,OemToAnsi( CADTMP->TJ_ORDEM ),oArial14N)

oPrint:Say(060,1040,OemToAnsi("Abertura :"),oCouNew12N)
oPrint:Say(060,1280,OemToAnsi(cvaltochar(STOD(CADTMP->TJ_DTORIGI))+" - "+ cvaltochar(CADTMP->TJ_HORACO1) ),oCouNew12N)

oPrint:Say(060,1740,OemToAnsi("Emissão :"),oCouNew12N)
oPrint:Say(060,1980,OemToAnsi(cvaltochar(dDatabase)+" - "+ cvaltochar(time()) ),oCouNew12N)

oPrint:Say(130,0040,OemToAnsi("Empresa  :"),oCouNew12N)
oPrint:Say(130,0280,OemToAnsi( SM0->M0_CODIGO+" "+SM0->M0_NOME),oCouNew12N)

oPrint:Say(130,1240,OemToAnsi("Filial  :"),oCouNew12N)
oPrint:Say(130,1380,OemToAnsi( SM0->M0_CODFIL+" "+SM0->M0_NOMECOM),oCouNew12N)


oPrint:line(190,0030,190,2550)

oPrint:Say(250,0040,OemToAnsi("Data da Execução:"),oCouNew12N)
oPrint:Say(250,0400,OemToAnsi(' ' ),oCouNew12N)

oPrint:Say(250,1240,OemToAnsi("Hora do Termino:"),oCouNew12N)
oPrint:Say(250,1720,OemToAnsi(' ' ),oCouNew12N)

oPrint:Say(320,0040,OemToAnsi("Empresa:"),oCouNew12N)
oPrint:Say(320,0400,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOME ),oCouNew12N)

oPrint:Say(320,1240,OemToAnsi("Empresa:"),oCouNew12N)
oPrint:Say(320,1380,OemToAnsi(SM0->M0_CODFIL+" "+SM0->M0_NOMECOM ),oCouNew12N)

oPrint:Say(390,0040,OemToAnsi("Garagem:"),oCouNew12N)
oPrint:Say(390,0400,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOME ),oCouNew12N)

oPrint:Say(390,1070,OemToAnsi("Carro:"),oArial14N)
oPrint:Say(390,1200,OemToAnsi(CADTMP->TJ_CODBEM ),oArial14N)

oPrint:Say(390,1440,OemToAnsi("Placa:"),oCouNew12N)
oPrint:Say(390,1580,OemToAnsi(CADTMP->T9_PLACA ),oCouNew12N)

oPrint:Say(390,1870,OemToAnsi("KM Atual Veiculo:"),oCouNew12N)
oPrint:Say(390,2280,OemToAnsi(CVALTOCHAR(CADTMP->TJ_POSCONT) ),oCouNew12N)


oPrint:line(450,0030,450,2550)

li := 550

Return 

/*
    AJUSTAR SX1 DO RELATORIO
*/
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
		aAdd(_aRegs,{cPerg,'01',"Emissao Inicial ?" ,"Emissao Inicial ?" ,"Emissao Inicial ?" ,'mv_ch1','D',08,0,0,'G','','mv_par01','','','','',"",""})
		aAdd(_aRegs,{cPerg,'02',"Emissao Final? "   ,"Emissao Final? "   ,"Emissao Final? "   ,'mv_ch2','D',08,0,0,'G','','mv_par02','','','','',"",""})
		aAdd(_aRegs,{cPerg,'03',"Ordem de Seriço de?","","",'mv_ch3','C', 6,0,0,'G','','mv_par03','','','','',"","STJ"})
		aAdd(_aRegs,{cPerg,'04',"Ordem de Seriço ate?","","",'mv_ch4','C', 6,0,0,'G','','mv_par04','','','','',"","STJ"})
		
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
