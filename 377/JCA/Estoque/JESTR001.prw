#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*
    Relatório de entrega de materiais
    MIT 44_ESTOQUE_EST005 - Requisição de entrega de  materiais

    DOC MIT
    https://docs.google.com/document/d/1iE6hUBnrLqA4vjaF5cH2PXYVIkZw65d0/edit
    DOC Entrega
    https://docs.google.com/document/d/1qx19Xna4nsiW8hMj9TtCoMKP1xUrdCNT/edit
    
*/

User Function JESTR001()

LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "RESTAT1"
LOCAL cDesc1	    := "Relação entrega de materiais"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico JCA"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("RESTAT1",10)
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
PRIVATE oCouNew10N	:= TFont():New("Courier New"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
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

If Funname() == "MNTA420" .OR. Funname() <> "MATA105"
	AjustaSx1(cPerg)
	Pergunte(cPerg,.f.)


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
	Processa({ |lEnd| COMR01Cfg("Impressao Relação de peças")},"Imprimindo , aguarde...")
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
Local cFilename := 'requisicao'+dtos(ddatabase)+strtran(cvaltochar(time()),":")

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.
oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
oPrint:SetLandsCape()
//oPrint:SetPortrait()
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

nPg		  := 0

cQuery := "SELECT CP_FILIAL,CP_NUM,CP_ITEM,CP_PRODUTO,CP_DESCRI,CP_QUANT,CP_EMISSAO,CP_SOLICIT,"
cQuery += " CP_CC,CP_OP,ZPM_DESC,B2_QATU-B2_RESERVA AS SALDO,B2_CM1,CP_XMATREQ,CP_XNOMREQ"
cQuery += " FROM "+RetSQLName("SCP")+" CP"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=CP_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("ZPM")+" ZPM ON ZPM_FILIAL=B1_FILIAL AND ZPM_COD=B1_ZMARCA AND ZPM.D_E_L_E_T_=' '" 
cQuery += " LEFT JOIN "+RetSQLName("SB2")+" B2 ON B2_FILIAL=CP_FILIAL AND B2_COD=CP_PRODUTO AND B2_LOCAL=B1_LOCPAD AND B2.D_E_L_E_T_=' '"
cQuery += " WHERE CP_FILIAL='"+xFilial("SCP")+"'"

If !lBrowse
	cQuery += " AND CP_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
	cQuery += " AND CP_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
	cQuery += " AND CP_NUMOS BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"
Else 
	cQuery += " AND CP_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
EndIf 

cQuery += " ORDER BY CP_NUM"

TCQUERY cQuery NEW ALIAS "CADTMP"

TcSetField('CADTMP','D2_EMISSAO','D')

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
	If li > 1900 .Or. cCotacao <> CADTMP->CP_NUM
		If Li <> 5000
			oPrint:EndPage()
		Endif		
	
		nPg++
		ImpCabec()                                                                     
		dEmissao := CtoD('')
		cCotacao := CADTMP->CP_NUM
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif

	oPrint:Say(li,0040,CADTMP->CP_PRODUTO+' - '+CADTMP->CP_DESCRI,oArial09N)
	oPrint:Say(li,1100,Capital(CADTMP->ZPM_DESC),oArial09N)
	oPrint:Say(li,1700,Capital("CADTMP->localizacao"),oArial09N)
	
	oPrint:Say(li,2000,Capital(CADTMP->CP_PRODUTO),oArial09N)
	oPrint:Say(li,2250,Transform(CADTMP->SALDO,"@E 999,999"),oArial09N)
	oPrint:Say(li,2370,Transform(CADTMP->CP_QUANT,"@E 999,999"),oArial09N)
	oPrint:Say(li,2600,Transform(CADTMP->B2_CM1,"@E 999,999.99"),oArial09N)
	oPrint:Say(li,2900,Transform(CADTMP->CP_QUANT*CADTMP->B2_CM1,"@E 999,999.99"),oArial09N)
	
	nQtdTot	 += CADTMP->CP_QUANT
	nVlrTot  += CADTMP->CP_QUANT*CADTMP->B2_CM1

	li+=50
	
	CADTMP->(DbSkip(1))

	If cCotacao <> CADTMP->CP_NUM .Or. CADTMP->(Eof())
		If li <> 5000

			li+=150
			oPrint:Say(li,2000,Replicate("-",100),oCouNew08)

			li+=050

			oPrint:Say(li,2000,'Total  ',oArial09N,,,,1)
			
			oPrint:Say(li,2370,TransForm(nQtdTot,"999,999"),oArial09N,,,,1)
			oPrint:Say(li,2900,TransForm(nVlrTot,"@E 999,999.99"),oArial09N,,,,1)
			
			li+=050

			oPrint:Say(li,0030,Replicate("-",299),oCouNew08)

			li+= 650
			oPrint:Say(li,0130,Replicate("_",30),oArial09N)
			oPrint:Say(li,2250,Replicate("_",30),oArial09N)
			li+=050
			oPrint:Say(li,0200,"Solicitante",oArial09N)
			oPrint:Say(li,2340,"Encarregado",oArial09N)

			nQtdTot	 := 0
			nVlrTot  := 0

		EndIf
	EndIf 

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


oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(000,0030,2000,3200 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(050,0040,OemToAnsi("Empresa :"),oArial11N)
oPrint:Say(050,0280,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOME ),oArial11N)
oPrint:Say(080,0040,OemToAnsi("Filial  :"),oArial11N)
oPrint:Say(080,0280,OemToAnsi( + SM0->M0_CODFIL+" "+SM0->M0_NOMECOM),oArial11N)

oPrint:Say(130,0030,Replicate("-",299),oCouNew08)

oPrint:Say(180,1050,OemToAnsi("Relação de entrega de peças"),oArial14N)  

oPrint:Say(0280,0040,"Requisição:",oArial09N)
oPrint:Say(0280,0340,CP_NUM,oArial09N)



oPrint:Say(0280,1300,"Local:",oArial09N)
oPrint:Say(0280,1480,CADTMP->CP_FILIAL,oArial09N)

oPrint:Say(0280,1740,"OS:",oArial09N)
oPrint:Say(0280,1940,substr(CADTMP->CP_OP,1,6),oArial09N)

oPrint:Say(0280,2340,"Data Requisição:",oArial09N)
oPrint:Say(0280,2640,cvaltochar(STOD(CADTMP->CP_EMISSAO)),oArial09N)


oPrint:Say(0320,0040,"Centro de Custos:",oArial09N)
oPrint:Say(0320,0340,CADTMP->CP_CC+Posicione("CTT",1,xFilial("CTT")+CADTMP->CP_CC,"CTT_DESC01"),oArial09N)

oPrint:Say(0320,1300,"Setor:",oArial09N)
oPrint:Say(0320,2340,"Hora Requisição:",oArial09N)

oPrint:Say(0360,0040,"Solicitante:",oArial09N)
oPrint:Say(0360,0340,CADTMP->CP_XMATREQ+" - "+CADTMP->CP_XNOMREQ,oArial09N)

oPrint:Say(0360,1300,"Veiculo:",oArial09N)

cBem := Posicione("STJ",1,CADTMP->CP_FILIAL+substr(CADTMP->CP_OP,1,6),"TJ_CODBEM")
cVeic := Posicione("ST9",1,xFilial("ST9")+cBem,"T9_PLACA")
oPrint:Say(0360,1480,Alltrim(cBem)+' - '+cVeic,oArial09N)

oPrint:Say(0400,0040,"Almoxarife:",oArial09N)
oPrint:Say(0360,0340,CADTMP->CP_SOLICIT,oArial09N)

oPrint:Say(0450,0030,Replicate("-",299),oCouNew08)

oPrint:Say(0490,0040,"Material",oArial09N)
oPrint:Say(0490,1100,"Marca",oArial09N)
oPrint:Say(0490,1500,"Ult. Req.:",oArial09N)
oPrint:Say(0490,1700,"Localizacao",oArial09N)
oPrint:Say(0490,2000,"Original",oArial09N)
oPrint:Say(0490,2250,"Saldo",oArial09N)
oPrint:Say(0490,2370,"Qtde",oArial09N)
oPrint:Say(0490,2600,"Vlr. Unit.",oArial09N)
oPrint:Say(0490,2900,"Vlr. Total",oArial09N)

oPrint:Say(0540,0030,Replicate("-",299),oCouNew08)

li := 620

Return 

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
		aAdd(_aRegs,{cPerg,'03',"Solicitação de?","","",'mv_ch3','C', 6,0,0,'G','','mv_par03','','','','',"","SCP"})
		aAdd(_aRegs,{cPerg,'04',"Solicitação ate?","","",'mv_ch4','C', 6,0,0,'G','','mv_par04','','','','',"","SCP"})
		aAdd(_aRegs,{cPerg,'05',"Ordem de Seriço de?","","",'mv_ch5','C', 6,0,0,'G','','mv_par05','','','','',"","STJ"})
		aAdd(_aRegs,{cPerg,'06',"Ordem de Seriço ate?","","",'mv_ch6','C', 6,0,0,'G','','mv_par06','','','','',"","STJ"})
		
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
