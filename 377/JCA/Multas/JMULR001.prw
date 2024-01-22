#include 'fivewin.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"


/*
    Autorização de desconto Sinistro
    MIT 44_Sinistros_MULT007_Autorizacao de desconto

    DOC MIT
    https://docs.google.com/document/d/1Iyje3udB4TNaL8N14hgBz07bRcn1IEhu/edit
    DOC Entrega
    
    
*/

User Function JMULR001()

LOCAL cString		:= "SD2"
Local titulo 		:= ""
LOCAL wnrel		 	:= "JESTR001"
LOCAL cDesc1	    := "Relação entrega de materiais"
LOCAL cDesc2	    := "conforme parametro"
LOCAL cDesc3	    := "Especifico JCA"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= Padr("ZPDR01",10)
PRIVATE aLinha		:= {}
PRIVATE nomeProg 	:= "JESTR001"
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

//    
//AjustaSx1(cPerg)
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

IF nOpcRel == 1 
	Processa({ |lEnd| COMR01Cfg("Impressao Relação de peças")},"Imprimindo , aguarde...")
	Processa({ |lEnd| MULR01(@lEnd,wnRel,cString,nReg)},titulo)
Else
	Return .f.
Endif

Return
/*/{Protheus.doc} COMR01Cfg
    Gera objeto fwmsprinter.
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function COMR01Cfg(Titulo)

Local cFilename := 'autorizacao_desconto_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")

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
/*/{Protheus.doc} MULR01
    Gera relatório de autorização de desconto
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MULR01(lEnd,WnRel,cString,nReg)

Local nPg		  := 0
Local cQuery 

cQuery := "SELECT * FROM "+RetSQLName("ZPD")
cQuery += " WHERE ZPD_FILIAL='"+xFilial("ZPD")+"' "
cQuery += " AND ZPD_CODIGO='000003'"
cQuery += " AND D_E_L_E_T_=' '"

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
	If li > 1900 //.Or. cCotacao <> CADTMP->CP_NUM
		If Li <> 5000
			oPrint:EndPage()
		Endif		
	
		nPg++
		ImpCabec()                                                                     
		dEmissao := CtoD('')
		//cCotacao := CADTMP->CP_NUM
	Endif

	If lEnd
		oPrint:Say(Li,030,"CANCELADO PELO OPERADOR",oArial12N)
		Goto Bottom
		Exit
	Endif

	oPrint:Say(500,0140,OemToAnsi(Posicione("SRA",1,xFilial("SRA")+CADTMP->ZPD_RESPON,"RA_NOME")),oArial11N)
	oPrint:Say(500,1120,OemToAnsi(CADTMP->ZPD_RESPON ),oArial11N)
	oPrint:Say(500,1650,OemToAnsi(CADTMP->ZPD_VERBA+' - '+Posicione("SRV",1,xFilial("SRV")+CADTMP->ZPD_VERBA,"RV_DESC")),oArial11N)

    oPrint:Say(1290,350,OemToAnsi(Transform(CADTMP->ZPD_VALOR,"@E 999,999.99")),oArial12N)
    oPrint:Say(1290,1330,OemToAnsi(cvaltochar(CADTMP->ZPD_PARCEL)),oArial12N)
    oPrint:Say(1290,2080,OemToAnsi(Transform(CADTMP->ZPD_VALOR/CADTMP->ZPD_PARCEL,"@E 999,999.99")),oArial12N)

	li+=50
	
	CADTMP->(DbSkip(1))


EndDo

oPrint:EndPage()

oPrint:Preview() 

CADTMP->(dbCloseArea())	

Return 
/*/{Protheus.doc} ImpCabec
    cabeçalho
    @type  Static Function
    @author user
    @since 21/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ImpCabec()

Local cRetorno := ""
Local dDataAtual := ddatabase 

oPrint:StartPage() 		// Inicia uma nova pagina
//oPrint:Box(000,0030,2000,3200 )  //LINHA/COLUNA/ALTURA/LARGURA
oPrint:Box(000,0030,0130,2500 ) 

oPrint:Say(080,1000,OemToAnsi('AUTORIZAÇÃO PARA DESCONTO EM PAGAMENTO'),oArial12N)

oPrint:Box(190,0030,0360,2500 ) 
oPrint:Say(250,0480,OemToAnsi("EMPRESA"),oArial11N)
oPrint:Say(250,1940,OemToAnsi("ÁREA"),oArial11N)
oPrint:Say(310,0280,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOME ),oArial11N)
oPrint:Say(310,1680,OemToAnsi( + SM0->M0_CODFIL+" "+SM0->M0_NOMECOM),oArial11N)

oPrint:line(190,1400,0360,1400 )

oPrint:Box(360,0030,0530,2500 ) 
oPrint:Say(420,0340,OemToAnsi("FUNCIONÁRIO"),oArial11N)
oPrint:Say(420,1100,OemToAnsi("REGISTRO" ),oArial11N)
oPrint:Say(420,1850,OemToAnsi("TIPO"),oArial11N)

oPrint:line(360,1000,0530,1000 )
oPrint:line(360,1450,0530,1450 )

oPrint:Box(530,0030,0850,2500 )
oPrint:Say(590,1000,OemToAnsi("OBSERVAÇÕES"),oArial11N)

cTexto := "AUTORIZO A EMPRESA A DESCONTAR DOS MEUS VENCIMENTOS OS VALORES ABAIXO RELACIONADOS," 
cTexto += " REFERENTE A OCORRENCIA ACIMA."

oPrint:Say(1000,0100,OemToAnsi(cTexto),oArial11N)

oPrint:Box(1150,0200,1350,0750 )

oPrint:Box(1150,1050,1350,1600 )

oPrint:Box(1150,1900,1350,2450 )

oPrint:Say(1200,280,OemToAnsi('VALOR TOTAL'),oArial12N)
oPrint:Say(1200,1130,OemToAnsi('NÚMERO DE PARCELAS'),oArial12N)
oPrint:Say(1200,1980,OemToAnsi('VALOR DA PARCELA'),oArial12N)

oPrint:Say(1250,1750,OemToAnsi('X'),oArial12N)

cTexto1 := "Declaro-me ciente que os valores acima citados, serão descontados na(s) minha(s)"
cTexto2 := " próxima(s) Folha de Pagamento, e que o total das parcelas não "
cTexto3 := "excederá o total de 1(hum) salário base por mim recebido. Em caso de rescisão "
cTexto4 := " do meu contrato de trabalho, a empresa esta autorizada desde ja, "
cTexto5 := "a descontaro restante do meu débito até o valor do meu saldo a receber na quitação."

oPrint:Say(1550,0100,OemToAnsi(cTexto1+cTexto2),oArial11N)
oPrint:Say(1600,0100,OemToAnsi(cTexto3+cTexto4),oArial11N)
oPrint:Say(1650,0100,OemToAnsi(cTexto5),oArial11N)


cRetorno += cValToChar(Day(dDataAtual))
cRetorno += " de "
cRetorno += MesExtenso(dDataAtual)
cRetorno += " de "
cRetorno += cValToChar(Year(dDataAtual))

oPrint:Say(1950,1400,OemToAnsi(Alltrim(SM0->M0_CIDENT)+', '+cRetorno),oArial11N)



oPrint:Say(2250,0060,OemToAnsi('Assinatura do Funcionário: _________________________________'),oArial11N)

oPrint:Say(2250,1400,OemToAnsi('Empresa: _________________________________'),oArial11N)

li := 620

Return 
