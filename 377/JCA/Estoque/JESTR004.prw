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

nPg		  := 0

mv_par02 := 'zzz'
mv_par03 := ctod('01/01/2000')
mv_par04 := ctod('01/01/2100')
mv_par06 := 'zzz'
mv_par08 := 'zzz'
mv_par10 := 'zzz'
mv_par12 := 'zzz'

cQuery := "SELECT ZPC_FILIAL,ZPC_REQUIS,ZPC_CODIGO,B1_DESC,ZPC_LOCAL,ZPC_QUANT,ZPC_DATA,ZPC_PREFIX,ZPC_SOLICI,RA_NOME,ZPC_STATUS,ZPC_ITEM"
cQuery += " FROM "+RetSQLName("ZPC")+" ZPC"
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

	oPrint:Say(li,0040,Alltrim(CADTMP->ZPC_CODIGO)+' - '+CADTMP->B1_DESC,oArial09N)

    oPrint:Say(li,1100,Alltrim(CADTMP->ZPC_REQUIS),oArial09N)
    oPrint:Say(li,1260,Alltrim(CADTMP->ZPC_LOCAL),oArial09N)
    oPrint:Say(li,1410,cvaltochar(stod(CADTMP->ZPC_DATA)),oArial09N)
    oPrint:Say(li,1585,cvaltochar(CADTMP->ZPC_QUANT),oArial09N)
    oPrint:Say(li,1735,Alltrim(CADTMP->ZPC_PREFIX),oArial09N)
    oPrint:Say(li,1880,Alltrim(CADTMP->RA_NOME),oArial09N)
    oPrint:Say(li,2340,If(CADTMP->ZPC_STATUS=="1","Sim","Não"),oArial09N)
    

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


oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(000,0030,3100,2540 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(050,0040,OemToAnsi("Empresa :"),oArial11N)
oPrint:Say(050,0280,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOMECOM ),oArial11N)
oPrint:Say(100,0040,OemToAnsi("Filial  :"),oArial11N)
oPrint:Say(100,0280,OemToAnsi( + SM0->M0_CODFIL+" "+SM0->M0_FILIAL),oArial11N)

oPrint:Say(150,0030,Replicate("-",211),oCouNew08)

oPrint:Say(190,1050,OemToAnsi("Relatório de Venda Perdida"),oArial14N)  

oPrint:Say(290,0040,OemToAnsi("Empresa/Filial :"),oArial11N)
oPrint:Say(290,0300,OemToAnsi(MV_PAR01+" a "+MV_PAR02 ),oArial11N)

oPrint:Say(290,0900,OemToAnsi("Periodo :"),oArial11N)
oPrint:Say(290,1100,OemToAnsi(cvaltochar(MV_PAR03)+"  a  "+cvaltochar(MV_PAR04) ),oArial11N)

oPrint:Say(290,1900,OemToAnsi("Material :"),oArial11N)
oPrint:Say(290,2100,OemToAnsi(MV_PAR05+" a "+MV_PAR06 ),oArial11N)

oPrint:Say(350,0040,OemToAnsi("Prefixo :"),oArial11N)
oPrint:Say(350,0300,OemToAnsi(MV_PAR07+" a "+MV_PAR08 ),oArial11N)

oPrint:Say(350,0900,OemToAnsi("Solicitante :"),oArial11N)
oPrint:Say(350,1100,OemToAnsi(MV_PAR09+"  a  "+MV_PAR10 ),oArial11N)

oPrint:Say(350,1900,OemToAnsi("Requisição :"),oArial11N)
oPrint:Say(350,2100,OemToAnsi(MV_PAR11+" a "+MV_PAR12 ),oArial11N)


oPrint:Say(0400,0030,Replicate("-",211),oCouNew08)

oPrint:Say(480,0040,OemToAnsi("Material"),oArial10N)
oPrint:Say(480,1100,OemToAnsi("Requis."),oArial10N)
oPrint:Say(480,1260,OemToAnsi("Almox."),oArial10N)
oPrint:Say(480,1410,OemToAnsi("Data"),oArial10N)
oPrint:Say(480,1580,OemToAnsi("Qtde"),oArial10N)
oPrint:Say(480,1735,OemToAnsi("Prefixo"),oArial10N)
oPrint:Say(480,1880,OemToAnsi("Usuário"),oArial10N)
oPrint:Say(480,2340,OemToAnsi("Parado"),oArial10N)

oPrint:Say(0530,0030,Replicate("-",211),oCouNew08)

li := 600

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
		aAdd(_aRegs,{cPerg,'01',"Filial de?","","",'mv_ch1','C', 6,0,0,'G','','mv_par01','','','','',"",""})
		aAdd(_aRegs,{cPerg,'02',"Filial de?","","",'mv_ch2','C', 6,0,0,'G','','mv_par02','','','','',"",""})
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
