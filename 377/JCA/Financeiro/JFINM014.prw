#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

Static lErro        As Logical
Static cChaveLog    As Character

/*
    Envio de carta de cobran็a com boletos
    MIT044 FINANCEIRO FIN014- enviar a carta de cobran็a com Boleto Bancแrio

    Doc Mit
    https://docs.google.com/document/d/1htcTA49rCiDbOZdrZ20WHgJFGSp1QD0u/edit
    Doc Entrega
    
    
*/
User Function JFINM014()

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

	cChaveLog := 'JFINM014'+'_'+DToS(Date())+'_'+Time()+'_'+cUserName
	lErro   := .F.

	fWizard()

Return

/*/{Protheus.doc} fWizard
	Criaรงรฃo do Wizard.
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function fWizard()

	Private oStepWiz	As object
	Private oPage1	    As Object
	Private oPage2	    As Object
	Private oPage3	    As Object
	Private oPage4	    As Object

	Private cTargetFile As Character
	Private LNextP1 as Logical
	Private LNextP2 as Logical
	Private LNextP3 as Logical

    Private aItems := {'SB1','SA1','SA2'}
    Private oCombo1
    Private cCombo1:= aItems[1]
	
	Private cCliDe :=  SPACE(6)
    Private cLojDe :=  SPACE(2)
    Private cCliAt :=  'ZZZZZZ'
    Private cLojAt :=  'ZZ'
	Private dVenDe :=	 CTOD('01/01/00')
	Private dVenAt :=	 CTOD('31/12/30')
    Private nVlrDe :=  0
	Private nVlrAt :=  999999999.99
	Private cBanco := space(3)
	Private cAgenc := space(5)
	Private cConta := space(10)
	Private cSubCt := space(3)
	Private cMailT := space(50)
	Private cCrtMd := space(6)
	Private aTiEnv := {'Sim','Nใo'}
	Private cTipEn := aTiEnv[2]
	
    oStepWiz := FWWizardControl():New(,{600,850})//Instancia a classe FWWizardControl
	oStepWiz:ActiveUISteps()
	LNextP1:= .T.
	LNextP2:= .F.
	LNextP3:= .F.
	//----------------------
	// Pagina 1
	//----------------------
	oPage1 := oStepWiz:AddStep("STEP1",{|Panel| cria_pn0(Panel)}) // Adiciona um Step
	oPage1:SetStepDescription("Titulos a serem transmitidos") // Define o tรญtulo do "step"
	oPage1:SetNextTitle("Avancar") // Define o tรญtulo do botรฃo de avanรงo
	oPage1:SetNextAction({||LNextP1}) // Define o bloco ao clicar no botรฃo Prรณximo
	oPage1:SetCancelAction({|| .T.}) // Define o bloco ao clicar no botรฃo Cancelar

	
	//----------------------
	// Pagina 2
	//----------------------
	oPage2 := oStepWiz:AddStep("STEP2", {|Panel| cria_pn2(Panel)})
	oPage2:SetStepDescription("Selecao dos titulos")
	oPage2:SetNextTitle("Avancar")
	oPage2:SetPrevTitle("Voltar") // Define o tรญtulo do botรฃo para retorno
	oPage2:SetNextAction({|| LNextP2  })
	oPage2:SetCancelAction({|| .T.})
	oPage2:SetPrevAction({|| .T.}) //Define o bloco ao clicar no botรฃo Voltar

	//----------------------
	// Pagina 3
	//----------------------
	oPage3 := oStepWiz:AddStep("STEP3", {|Panel| cria_pn4(Panel)})
	oPage3:SetStepDescription("Log de processamento")
	oPage3:SetNextTitle("Finalizar")
	oPage3:SetCancelAction({|| .T.})
	oPage3:SetPrevWhen({||.F.})
	oPage3:SetCancelWhen({||.T.})

	oStepWiz:Activate()

	oStepWiz:Destroy()

Return

/*/{Protheus.doc} cria_pn1
	Criaรงรฃo da primeira pรกgina do Wizard.
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function cria_pn0( oPanel As Object )

	Local oFont As Object
    

    oFont := TFont():New(,,-25,.T.,.T.,,,,,)

	TSay():New(20,25,{|| "Cliente de?"},oPanel,,,,,,.T.,CLR_BLUE,)
    oGet1     := TGet():New(20,85,{|u| If(PCount() > 0,cCliDe := u,cCliDe)},oPanel,60,10,PesqPict("SA1","A1_COD"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'SA1','')
    
    TSay():New(40,25,{|| "Loja de?"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet2     := TGet():New(40,85,{|u| If(PCount() > 0,cLojDe := u,cLojDe)},oPanel,40,10,PesqPict("SA1","A1_LOJA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
    TSay():New(60,25,{|| "Cliente ate?"},oPanel,,,,,,.T.,CLR_BLUE,)
    oGet3     := TGet():New(60,85,{|u| If(PCount() > 0,cCliAt := u,cCliAt)},oPanel,60,10,PesqPict("SA1","A1_COD"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'SA1','')
    
    TSay():New(80,25,{|| "Loja ate?"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet4     := TGet():New(80,85,{|u| If(PCount() > 0,cLojAt := u,cLojAt)},oPanel,40,10,PesqPict("SA1","A1_LOJA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
	TSay():New(100,25,{|| "Vencimento de?"},oPanel,,,,,,.T.,CLR_BLUE,)
    oGet5     := TGet():New(100,85,{|u| If(PCount() > 0,dVenDe := u,dVenDe)},oPanel,60,10,PesqPict("SE1","E1_VENCREA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
    TSay():New(120,25,{|| "Vencimento de?"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet6     := TGet():New(120,85,{|u| If(PCount() > 0,dVenAt := u,dVenAt)},oPanel,60,10,PesqPict("SE1","E1_VENCREA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
    TSay():New(140,25,{|| "Valor de?"},oPanel,,,,,,.T.,CLR_BLUE,)
    oGet7     := TGet():New(140,85,{|u| If(PCount() > 0,nVlrDe := u,nVlrDe)},oPanel,60,10,PesqPict("SE1","E1_VALOR"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
    TSay():New(160,25,{|| "Valor ate?"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet8     := TGet():New(160,85,{|u| If(PCount() > 0,nVlrAt := u,nVlrAt)},oPanel,60,10,PesqPict("SE1","E1_VALOR"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
	
	TSay():New(20,245,{|| "Banco"},oPanel,,,,,,.T.,CLR_BLUE,)
    oGet9     := TGet():New(20,310,{|u| If(PCount() > 0,cBanco := u,cBanco)},oPanel,60,10,PesqPict("SA6","A6_COD"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'SA6','')
    
    TSay():New(40,245,{|| "Ag๊ncia"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet10     := TGet():New(40,310,{|u| If(PCount() > 0,cAgenc := u,cAgenc)},oPanel,40,10,PesqPict("SA6","A6_AGENCIA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
    TSay():New(60,245,{|| "Conta"},oPanel,,,,,,.T.,CLR_BLUE,)
    oGet11     := TGet():New(60,310,{|u| If(PCount() > 0,cConta := u,cConta)},oPanel,60,10,PesqPict("SA6","A6_CONTA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
    TSay():New(80,245,{|| "Sub-Conta"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet12     := TGet():New(80,310,{|u| If(PCount() > 0,cSubCt := u,cSubCt)},oPanel,40,10,PesqPict("SEE","EE_SUBCTA"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
	TSay():New(100,245,{|| "Email Teste"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet13     := TGet():New(100,310,{|u| If(PCount() > 0,cMailT := u,cMailT)},oPanel,40,10,PesqPict("SA1","A1_EMAIL"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'','')
    
	TSay():New(120,245,{|| "Carta modelo"},oPanel,,,,,,.T.,CLR_BLUE,)
	oGet13     := TGet():New(120,310,{|u| If(PCount() > 0,cCrtMd := u,cCrtMd)},oPanel,40,10,PesqPict("SA1","A1_EMAIL"),,,,,,,.T.,,,{|| .T.},,,,.F.,.F.,'FWP','')
    
	TSay():New(140,245,{|| "Titulos sem boleto"},oPanel,,,,,,.T.,CLR_BLUE,)
	oCombo2 := TComboBox():New(140,310,{|u|if(PCount()>0,cTipEn:=u,cTipEn)},aTiEnv,50,20,oPanel,,{|| },,,,.T.,,,,,,,,,'cTipEn')
	
Return .t.


/*/{Protheus.doc} cria_pn2
	Criaรงรฃo da segunda pรกgina do Wizard.
	Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 07/08/2021
/*/
Static Function cria_pn2( oPanel As Object )

	oFont := TFont():New(,,-25,.T.,.T.,,,,,)

	oSay1 := TSay():New(10,15,{|| "Aguarde"},oPanel,,oFont,,,,.T.,CLR_GREEN,)

	If !Empty(cSubCt)
		MV_PAR19 := cSubCt
	Else
    	MV_PAR19 := SUPERGETMV("TI_SUBCTA",.F.,'123') //sub-conta
	EndIf 

	If !Empty(cBanco)
		MV_PAR20 := cBanco
	ELSE
		MV_PAR20 := SUPERGETMV("TI_BNCBOL",.F.,'001') //banco
	EndIf 

	If !Empty(cAgenc)
		MV_PAR21 := cAgenc
	Else 
		MV_PAR21 := SUPERGETMV("TI_AGEBOL",.F.,'0005') //agencia 
	EndIf 
	
	If !Empty(cConta)
		MV_PAR22 := cConta
	Else 
		MV_PAR22 := SUPERGETMV("TI_CNTBOL",.F.,'139074') // conta
	EndIf 

	

	U_JFINJ014a(,,.F.)
	
	oSay1:settext("")

	TSay():New(10,15,{|| "Envios realizados com sucesso!"},oPanel,,oFont,,,,.T.,CLR_GREEN,)

	LNextP2 := .t.

Return .t.

/*/{Protheus.doc} cria_pn4
	Visualizaรงรฃo do log de processamento.
    Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 24/04/2021
/*/
Static Function cria_pn4( oPanel As Object )

	Local oBtnLog	As Object
	Local oFont		As Object

	oFont := TFont():New(,,-25,.T.,.T.,,,,,)

	LNextP3 := .t.
	// Apresenta o tSay com a fonte Courier New
	If lErro

		TSay():New(10,15,{|| "Importacao finalizada com erro"},oPanel,,oFont,,,,.T.,CLR_RED,)

	Else

		TSay():New(10,15,{|| "Processo finalizado com sucesso!"},oPanel,,oFont,,,,.T.,CLR_GREEN,)

	EndIf

	TSay():New(35,15,{|| "Clique no botao abaixo para visualizar o log de processamento."},oPanel,,,,,,.T.,CLR_BLUE,)

	oBtnLog := TButton():New(50,15, "Visualizar",oPanel,{|| ProcLogView(cFilAnt, AvKey(cChaveLog,"CV8_PROC"))}, 60,20,,,.F.,.T.,.F.,,.F.,,,.F. )

Return


/*/{Protheus.doc} fGravaLog
	Gravaรงรฃo do log de processamento.
    Issue: TICONTIN-1534
	@author Alexandre Venancio	
	@since 24/04/2021
/*/
Static Function fGravaLog(cMsg, cDetalhe, lOk)

	Local cIdMov := GetSXENum("CV8","CV8_IDMOV",,5)

	Default cDetalhe := ''

	CV8->(RecLock("CV8",.T.))

	CV8->CV8_FILIAL	:= xFilial("CV8")
	CV8->CV8_DATA	:= Date()
	CV8->CV8_HORA	:= SubStr(Time(),1,5)
	CV8->CV8_USER	:= cUserName
	CV8->CV8_MSG	:= cMsg
	CV8->CV8_DET	:= cDetalhe
	CV8->CV8_PROC	:= cChaveLog
	CV8->CV8_SBPROC	:= "JFINM014"
	CV8->CV8_IDMOV	:= cIdMov
	CV8->CV8_INFO	:= IIF(lOk, '6', '4')

	CV8->(MsUnlock())

	ConfirmSx8()

Return

/*/{Protheus.doc} SrvXGetMostraErro
Retorna conteudo da mensagem do MostraErro()
@author totvs
@since 13/08/2015
@version 1.0
/*/
static Function GetErro()

Local cPath	:= GetSrvProfString("Startpath","")
Local cArq	:= "Erro_Rot_Auto_"+Dtos(dDataBase)+"_"+StrTran(Time(),":","_")+Alltrim(Str(ThreadID()))+".txt"
Local cRet	:= ""

MostraErro( cPath , cArq )
cRet := StrTran(MemoRead(  cPath + '\' + cArq ),Chr(13) + Chr(10)," ")
cRet := StrTran(cRet, '"', "'")
fErase(cArq)

Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CONJOB04 บAutor  ณ Alexandre Venancio  บ Data ณ  08/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de envio automatico de cartas de cobranca para o    บฑฑ
ฑฑบ          ณcliente conforme a data de vencimento.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function JFINJ014a(cCodEmp,cCodFil,lAuto)

	Local cQuery
	Local cBody
	Local cSubject	:=	"Avisos de Vencimento"
	Local aArquivos := {}
	Local cDestino	:=	"alexandre.venancio@avsipro.com.br'
	Local dDtFour 	:= ''
	Local cNomeArq	:= ''
	Local aTitE1	:= {}
	
	Private aAvisFi	:= {}
	Private aTitCli	:= {}
	Private aCumula	:= {}

	Private cMarca  	:= GetMark()


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


	Default cCodEmp := "01"
	Default cCodFil := "00020667"
	Default lAuto   := .T.

	//Utilizando a nova classe de email para poder anexar corretamente o email ao corpo da mensagem.
	// ************************************************************ //
	// 		Parametros da rotina de envio de email  			  	//
	//																//
	//	01 - Remetente da mensagem                                  //
	//	02 - Destinatario do email                                  //
	//	03 - Assunto do email                                       //
	//	04 - Corpo da mensagem                                      //
	//	05 - Array com arquivos a serem atachados                   //
	//			Posicao 1 - \Caminho\NomeArquivo.extensao           //
	//			Posicao 2 - Content-ID "Apelido" da imagem          //
	//	06 - Confirmacao de leitura (logico)						//
	// ************************************************************ //


	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	Private aSM0Data2 := FWSM0Util():GetSM0Data()
	Private nPos1     := Ascan(aSM0Data2,{|x| x[1] == "M0_CODFIL"})
	Private nPos2     := Ascan(aSM0Data2,{|x| x[1] == "M0_FILIAL"})
	Private nPos3     := Ascan(aSM0Data2,{|x| x[1] == "M0_NOME"})

	cNomeArq := 'c:\temp\_avisos\'+dtos(ddatabase)+'.txt'

	Aadd(aArquivos,{"\system\LGRL01.png",'Content-ID: <ID_LGRL01,png>'})

	dDtFour := datavalida(dDataBase+3,.T.)

	
	li       := 5000

	DbSelectArea("FWP")
	DbSetORder(1)
	Dbseek(xFilial("FWP")+cCrtMd)
	
	If !Empty(FWP->FWP_TXTASS)
		cSubject := Alltrim(FWP->FWP_TXTASS)
	EndIf 

	_pdfenvio()

	cQuery := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_TIPO,E1_NATUREZ,ED_DESCRIC,E1_FILORIG,E1_EMISSAO,"
	cQuery += " E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,E1_PARCELA,A1_CGC,"
	cQuery += " E1_PORTADO,E1.R_E_C_N_O_ AS REGE1,E1_NUMBCO,E1_CODBAR,E1_CODDIG,'S' AS A1_XBOL"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	
	If lAuto
		cQuery += " WHERE E1_VENCREA >= '"+DTOS(datavalida(dDtFour))+"' AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' "
		cQuery += " AND E1.D_E_L_E_T_='' AND E1_PORTADO BETWEEN ' ' AND '999'"
	Else 

		cQuery += " WHERE E1_CLIENTE BETWEEN '"+cCliDe+"' AND '"+cCliAt+"'"
		cQuery += " AND E1_LOJA BETWEEN '"+cLojDe+"' AND '"+cLojAt+"'"
		cQuery += " AND E1_VENCREA BETWEEN '"+dtos(dVenDe)+"' AND '"+dtos(dVenAt)+"'"
		cQuery += " AND E1_VALOR BETWEEN "+cvaltochar(nVlrDe)+" AND "+cvaltochar(nVlrAt)
		cQuery += " AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' ""
		cQuery += " AND E1.D_E_L_E_T_='' AND E1_PORTADO BETWEEN ' ' AND '999'"
	EndIf 

	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND E1_TIPO NOT LIKE '%-%'"
	cQuery += " ORDER BY E1_CLIENTE"

	If Select('TRBLOC') > 0
		dbSelectArea('TRBLOC')
		dbCloseArea()
	EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBLOC",.F.,.T.)
	dbSelectArea("TRBLOC")
		
	Count To nReg

	TRBLOC->(dbGoTop())

	nArq:= fCreate(cNomeArq)

	FWrite(nArq, 'Inicio '+DTOC(dDataBase) + ' ' + Time()+CRLF)
	FWrite(nArq, '*************************************************************************************************************'+CRLF)
	Fwrite(nArq, '|                       Avisos de Vencimentos transmitidos em '+cvaltochar(dDatabase)+'                      |'+CRLF)
	FWrite(nArq, '*************************************************************************************************************'+CRLF)

	While !EOF()

		If li > 1900 
			If Li <> 5000
				oPrint:EndPage()
			Endif		
		
			ImpCabec()                                                                     
		Endif

		oPrint:Say(li,0040,Alltrim(TRBLOC->E1_PREFIXO),oArial09N)

		oPrint:Say(li,0200,Alltrim(TRBLOC->E1_NUM),oArial09N)
		oPrint:Say(li,0400,Alltrim(TRBLOC->E1_PARCELA),oArial09N)
		oPrint:Say(li,0600,cvaltochar(TRBLOC->A1_NOME),oArial09N)
		
		oPrint:Say(li,1350,cvaltochar(STOD(TRBLOC->E1_EMISSAO)),oArial09N)
		oPrint:Say(li,1500,cvaltochar(STOD(TRBLOC->E1_VENCREA)),oArial09N)
		
		oPrint:Say(li,1650,Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),oArial09N)
		oPrint:Say(li,1900,Alltrim(TRBLOC->A1_EMAIL),oArial09N)


		li+=50

		cDestino 	:=	Alltrim(TRBLOC->A1_EMAIL)
		cDestino 	:=	If(!empty(cMailT),cMailT,"") //"alexandre.venancio@avsipro.com.br" 
		MV_PAR01	:=	TRBLOC->E1_PREFIXO
		MV_PAR02	:=	TRBLOC->E1_NUM
		MV_PAR03	:=	TRBLOC->E1_PARCELA
		MV_PAR04	:=	TRBLOC->E1_PARCELA

		cMarca  	:= GetMark()
		nVlrAbat := 0

		lBolSeparado := .f.
		aAreaTRBLOC := GetArea()
		DbSelectArea("SE1")
        DbsetOrder(1)
        If Dbseek(TRBLOC->E1_FILIAL+MV_PAR01+MV_PAR02+MV_PAR03+TRBLOC->E1_TIPO) //+aChave[4])
			nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		
            Reclock("SE1",.F.)
            Replace E1_OK With cMarca
            MsUnLock()
        EndIf
		
		If Upper(cTipEn) == "SIM"
			cFileBol := U_RF01BImp(.f.)
			cMsg := 'Arquivo gerado'
			lOk := .T.
		Else 
			cMsg = 'Nao enviar boleto'
			lOk := .T.
		EndIf 

		aSM0Data2 := FWSM0Util():GetSM0Data(cEmpAnt,TRBLOC->E1_FILIAL)
		cDetalhe := Alltrim(aSM0Data2[nPos2,02])
		cDetalhe += "|"+SE1->E1_CLIENTE+"|"+SE1->E1_LOJA+"|"+Alltrim(TRBLOC->A1_NOME)
		cDetalhe += "|"+SE1->E1_PREFIXO+"|"+SE1->E1_NUM+"|"+SE1->E1_PARCELA
		cDetalhe += "|"+cvaltochar(STOD(TRBLOC->E1_VENCREA))+"|"+Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99")
		
		fGravaLog(cMsg, cDetalhe, lOk)

		RestArea(aAreaTRBLOC)
		
		cBody 		:=	Aviso_1(TRBLOC->E1_CODDIG,TRBLOC->A1_XBOL,nVlrAbat)

		If Upper(cTipEn) == "SIM"
			If !'.pdf' $ cFileBol
				cFileBol := alltrim(cFileBol)+'.pdf'
			EndIf 

			cpyt2s(alltrim(cFileBol),'\spool\')
			aAux := separa(cFileBol,"\")

			cNewloc := '\spool\'+aaux[len(aaux)]
		Else 
			cNewloc := ''
		EndIf 

		aArquivos 	:=  {}

		U_JGENX002(cDestino,cSubject,cBody,cNewloc,.F.)

		cCorpo := TRBLOC->E1_CLIENTE+'#'+TRBLOC->E1_LOJA+'#'+TRBLOC->A1_NOME+'#'+TRBLOC->E1_PREFIXO+'#'+TRBLOC->E1_NUM+'#'+CVALTOCHAR(STOD(TRBLOC->E1_VENCREA))+'#'+Transform(TRBLOC->E1_VALOR-nVlrAbat,"@E 999,999,999.99")+'#'+TRBLOC->A1_EMAIL

		FWrite(nArq,cCorpo+CRLF)
		Aadd(aAvisFi,{TRBLOC->E1_CLIENTE,TRBLOC->E1_LOJA,TRBLOC->A1_NOME,TRBLOC->E1_PREFIXO+TRBLOC->E1_NUM,CVALTOCHAR(STOD(TRBLOC->E1_VENCREA)),Transform(TRBLOC->E1_VALOR-nVlrAbat,"@E 999,999,999.99"),TRBLOC->A1_EMAIL})
		Aadd(aTitE1,TRBLOC->REGE1)
		dbSelectArea("TRBLOC")
		DbSkip()
	EndDo

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+CRLF)
	fClose(nArq)

	cBody := AvisFin(cSubject,{})

	oPrint:EndPage()
	oPrint:Preview() 
	
	cDestino := If(!empty(cMailT),cMailT,"") //"alexandre.venancio@avsipro.com.br"

	U_JGENX002(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,'',.F.)

Return

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 15/01/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function _pdfenvio()

Local cFilename := 'avisos_enviados_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")

lAdjustToLegacy := .T.   //.F.
lDisableSetup  := .T.

oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrint:SetResolution(78)
//oPrint:SetLandsCape()
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4) 
oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior 
oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressใo em IMP_PDF 
cDiretorio := oPrint:cPathPDF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ImpCabec ณ Autor ณ Alexandre Venancio         ณ Data ณ     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Imprime o Cabecalho                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ ImpCabec(Void)                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MatR110                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ImpCabec()


oPrint:StartPage() 		// Inicia uma nova pagina
oPrint:Box(000,0030,3100,2540 )  //LINHA/COLUNA/ALTURA/LARGURA

oPrint:Say(050,0040,OemToAnsi("Empresa :"),oArial11N)
oPrint:Say(050,0280,OemToAnsi(SM0->M0_CODIGO+" "+SM0->M0_NOMECOM ),oArial11N)
oPrint:Say(100,0040,OemToAnsi("Filial  :"),oArial11N)
oPrint:Say(100,0280,OemToAnsi( + SM0->M0_CODFIL+" "+SM0->M0_FILIAL),oArial11N)

oPrint:Say(150,0030,Replicate("-",211),oCouNew08)

oPrint:Say(190,1050,OemToAnsi("Relat๓rio de Titulos enviados para cobran็a"),oArial14N)  

oPrint:Say(290,0040,OemToAnsi("Cliente de/ate"),oArial11N)
oPrint:Say(290,0300,OemToAnsi(cCliDe+" a "+cCliAt ),oArial11N)

oPrint:Say(290,0900,OemToAnsi("Vencto de/ate"),oArial11N)
oPrint:Say(290,1100,OemToAnsi(cvaltochar(dVenDe)+"  a  "+cvaltochar(dVenAt) ),oArial11N)

oPrint:Say(290,1900,OemToAnsi("Valor de/ate"),oArial11N)
oPrint:Say(290,2100,OemToAnsi(Transform(nVlrDe,"@E 999,999.99")+" a "+Transform(nVlrAt,"@E 999,999.99") ),oArial11N)

oPrint:Say(350,0040,OemToAnsi("Banco :"),oArial11N)
oPrint:Say(350,0300,OemToAnsi(MV_PAR20 ),oArial11N)

oPrint:Say(350,0900,OemToAnsi("Ag๊ncia :"),oArial11N)
oPrint:Say(350,1100,OemToAnsi(MV_PAR21 ),oArial11N)

oPrint:Say(350,1900,OemToAnsi("Conta :"),oArial11N)
oPrint:Say(350,2100,OemToAnsi(MV_PAR22 ),oArial11N)


oPrint:Say(0400,0030,Replicate("-",211),oCouNew08)

oPrint:Say(480,0040,OemToAnsi("Prefixo"),oArial10N)
oPrint:Say(480,0200,OemToAnsi("Titulo"),oArial10N)
oPrint:Say(480,0400,OemToAnsi("Parcela"),oArial10N)
oPrint:Say(480,0600,OemToAnsi("Cliente"),oArial10N)
oPrint:Say(480,1350,OemToAnsi("Emissใo"),oArial10N)
oPrint:Say(480,1500,OemToAnsi("Vencto"),oArial10N)
oPrint:Say(480,1650,OemToAnsi("Valor"),oArial10N)
oPrint:Say(480,1900,OemToAnsi("Email-cadastrado"),oArial10N)

oPrint:Say(0530,0030,Replicate("-",211),oCouNew08)

li := 600

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFIN01 บAutor  ณMicrosiga           บ Data ณ  03/19/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CONJOB4b(cCodEmp,cCodFil)

	Local aArea		:=	GetArea()
	Local cQuery
	Local cBody
	Local cSubject	:=	"Aviso de Cobran็a"
	Local aArquivos := {}
	Local cDestino	:=	"alexandre.venancio@avsipro.com.br"
	Local cCliente	:=	''
	Local nCont		:=	1
	Local dDtOne  	:= ''
	Local dDtTwo  	:= ''
	Local dDtTree 	:= ''
	Local aTitE1	:= {}

	Private aAvisFi	:= {}
	Private aTitCli	:= {}
	Private aCumula	:= {}

	Default cCodEmp := "01"
	Default cCodFil := "01"

	//Utilizando a nova classe de email para poder anexar corretamente o email ao corpo da mensagem.
	// ************************************************************ //
	// 		Parametros da rotina de envio de email  			  	//
	//																//
	//	01 - Remetente da mensagem                                  //
	//	02 - Destinatario do email                                  //
	//	03 - Assunto do email                                       //
	//	04 - Corpo da mensagem                                      //
	//	05 - Array com arquivos a serem atachados                   //
	//			Posicao 1 - \Caminho\NomeArquivo.extensao           //
	//			Posicao 2 - Content-ID "Apelido" da imagem          //
	//	06 - Confirmacao de leitura (logico)						//
	// ************************************************************ //

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	cNomeArq := 'c:\temp\_cobrancas\'+dtos(ddatabase)+'.txt'

	Aadd(aArquivos,{"\system\LGRL01.PNG",'Content-ID: <ID_LGRL01.PNG>'})

	// Valida็ใo para 03 dias

	IF DOW(dDataBase) == 2
		dDtOne := datavalida(dDataBase-3,.F.)-2 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtOne := datavalida(dDataBase-3,.F.)-2//-1 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtOne := datavalida(dDataBase-3,.T.)-2//+2 //Condi็ใo para Quarta
	ELSE
		dDtOne := datavalida(dDataBase-3,.F.)
	ENDIF

	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,"
	cQuery += " E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,"
	cQuery += " E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtOne,.F.))+"' AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '001' AND '999'"
	cQuery += " ORDER BY E1_CLIENTE,E1_LOJA,E1_VENCREA"

	If Select('TRBLOC') > 0
		dbSelectArea('TRBLOC')
		dbCloseArea()
	EndIf

	cSubject := "Aviso de Cobran็a"

	aTitCli := {}
	aAvisFi := {}

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBLOC",.F.,.T.)
	dbSelectArea("TRBLOC")

	cCliente := TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA

	nArq:= fCreate(cNomeArq)

	fWrite(nArq, 'Inicio '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))

	While !EOF()

		If cCliente != TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA
			cCliente := TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA
			If Len(aTitCli) > 0
				cBody := Cobranca1()
				//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
				U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.BMP",.f.)
				aTitCli := {}
				cDestino := Alltrim(TRBLOC->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRBLOC->E1_NUM}) == 0
					Aadd(aTitCli,{TRBLOC->E1_NUM,stod(TRBLOC->E1_EMISSAO),stod(TRBLOC->E1_VENCREA),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRBLOC->E1_VALJUR,"@E 999,999,999.99"),TRBLOC->ED_DESCRIC,TRBLOC->A1_NOME,;
						Transform(TRBLOC->E1_VALOR+(TRBLOC->E1_VALJUR*(DDATABASE-STOD(TRBLOC->E1_VENCREA))),"@E 999,999,999.99"),;
						TRBLOC->E1_PREFIXO,TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA})

				EndIf
				cDestino := Alltrim(TRBLOC->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRBLOC->E1_NUM}) == 0
				Aadd(aTitCli,{TRBLOC->E1_NUM,stod(TRBLOC->E1_EMISSAO),stod(TRBLOC->E1_VENCREA),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRBLOC->E1_VALJUR,"@E 999,999,999.99"),TRBLOC->ED_DESCRIC,TRBLOC->A1_NOME,;
					Transform(TRBLOC->E1_VALOR+(TRBLOC->E1_VALJUR*(DDATABASE-STOD(TRBLOC->E1_VENCREA))),"@E 999,999,999.99"),;
					TRBLOC->E1_PREFIXO,TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA})
			EndIf
			cDestino := Alltrim(TRBLOC->A1_EMAIL)
			cDestino := "hayewok628@jontra.com"
		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRBLOC->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRBLOC->A1_NOME,TRBLOC->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRBLOC->E1_VALOR
		EndIf

		cCorpo := TRBLOC->E1_CLIENTE+'/'+TRBLOC->E1_LOJA+'/'+TRBLOC->A1_NOME+'/'+TRBLOC->E1_PREFIXO+'/'+TRBLOC->E1_NUM+'/'+CVALTOCHAR(STOD(TRBLOC->E1_VENCREA))+'/'+Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99")+'/'+TRBLOC->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRBLOC->E1_CLIENTE,TRBLOC->E1_LOJA,TRBLOC->A1_NOME,TRBLOC->E1_PREFIXO+TRBLOC->E1_NUM,CVALTOCHAR(STOD(TRBLOC->E1_VENCREA)),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),TRBLOC->A1_EMAIL})
		Aadd(aTitE1,TRBLOC->REGE1)
		Dbskip()
	Enddo

	If len(aTitCli) > 0
		cBody := Cobranca1()
		//U_robmail(cRemete,cDestino,cSubject,cBody,aArquivos,.T.)
		U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cBody := AvisFin(cSubject,aCumula)
		cDestino := "alexandre.venancio@avsipro.com.br"
		U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.f.)
	EndIf

	// Valida็ใo para 05 dias 22/02/2023 alterado para 7

	IF DOW(dDataBase) == 2
		dDtTwo := datavalida(dDataBase-7,.F.)//-1 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtTwo := datavalida(dDataBase-7,.F.)//-2 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtTwo := datavalida(dDataBase-7,.F.)//-2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtTwo := datavalida(dDataBase-7,.F.)//-1 //Condi็ใo para Quinta
	ELSE
		dDtTwo := datavalida(dDataBase-7,.F.)
	ENDIF


	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,"
	cQuery += " E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,"
	cQuery += " E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=' '"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTwo,.F.))+"' AND E1_BAIXA=' ' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '001' AND '999'"
	cQuery += " ORDER BY E1_CLIENTE,E1_LOJA,E1_VENCREA"

	If Select('TRBLOC') > 0
		dbSelectArea('TRBLOC')
		dbCloseArea()
	EndIf

	cSubject := "Aviso de Cobran็a"
	aTitCli := {}
	aAvisFi := {}
	aTitE1  := {}

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBLOC",.F.,.T.)
	dbSelectArea("TRBLOC")

	cCliente := TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA

	nArq:= fCreate(cNomeArq)

	fWrite(nArq, 'Inicio '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))

	While !EOF()

		If cCliente != TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA
			cCliente := TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA
			If Len(aTitCli) > 0
				cBody := Cobranca2()
				U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
				aTitCli := {}

				cDestino := Alltrim(TRBLOC->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRBLOC->E1_NUM}) == 0
					Aadd(aTitCli,{TRBLOC->E1_NUM,stod(TRBLOC->E1_EMISSAO),stod(TRBLOC->E1_VENCREA),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRBLOC->E1_VALJUR,"@E 999,999,999.99"),TRBLOC->ED_DESCRIC,TRBLOC->A1_NOME,;
						Transform(TRBLOC->E1_VALOR+(TRBLOC->E1_VALJUR*(DDATABASE-STOD(TRBLOC->E1_VENCREA))),"@E 999,999,999.99"),;
						TRBLOC->E1_PREFIXO,TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA})

				EndIf
				
				cDestino := Alltrim(TRBLOC->A1_EMAIL)
				cDestino := "hayewok628@jontra.com"
				
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRBLOC->E1_NUM}) == 0
				Aadd(aTitCli,{TRBLOC->E1_NUM,stod(TRBLOC->E1_EMISSAO),stod(TRBLOC->E1_VENCREA),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRBLOC->E1_VALJUR,"@E 999,999,999.99"),TRBLOC->ED_DESCRIC,TRBLOC->A1_NOME,;
					Transform(TRBLOC->E1_VALOR+(TRBLOC->E1_VALJUR*(DDATABASE-STOD(TRBLOC->E1_VENCREA))),"@E 999,999,999.99"),;
					TRBLOC->E1_PREFIXO,TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA})
			EndIf
			
			cDestino := Alltrim(TRBLOC->A1_EMAIL)
			cDestino := "hayewok628@jontra.com"
			
		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRBLOC->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRBLOC->A1_NOME,TRBLOC->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRBLOC->E1_VALOR
		EndIf

		cCorpo := TRBLOC->E1_CLIENTE+'/'+TRBLOC->E1_LOJA+'/'+TRBLOC->A1_NOME+'/'+TRBLOC->E1_PREFIXO+'/'+TRBLOC->E1_NUM+'/'+CVALTOCHAR(STOD(TRBLOC->E1_VENCREA))+'/'+Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99")+'/'+TRBLOC->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRBLOC->E1_CLIENTE,TRBLOC->E1_LOJA,TRBLOC->A1_NOME,TRBLOC->E1_PREFIXO+TRBLOC->E1_NUM,CVALTOCHAR(STOD(TRBLOC->E1_VENCREA)),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),TRBLOC->A1_EMAIL})
		Aadd(aTitE1,TRBLOC->REGE1)
		Dbskip()
	EndDo

	If len(aTitCli) > 0
		cBody := Cobranca2()
		U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cBody := AvisFin(cSubject,aCumula)
		cDestino := "alexandre.venancio@avsipro.com.br"
		U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.f.)
	EndIf

	// Valida็ใo para 07 dias   22/02/2023  alterado para 9

	IF DOW(dDataBase) == 2
		dDtTree := datavalida(dDataBase-7,.F.)-4 //Condi็ใo para Segunda
	ELSEIF DOW(dDataBase) == 3
		dDtTree := datavalida(dDataBase-7,.F.)-4 //Condi็ใo para Ter็a
	ELSEIF DOW(dDataBase) == 4
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Quarta
	ELSEIF DOW(dDataBase) == 5
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Quinta
	ELSE //DOW(dDataBase) == 6
		dDtTree := datavalida(dDataBase-7,.F.)-2 //Condi็ใo para Sexta
	ENDIF

	cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_EMISSAO,E1_NATUREZ,ED_DESCRIC,"
	cQuery += " E1_PARCELA,E1_CLIENTE,E1_LOJA,A1_NOME,E1_VENCREA,E1_VALOR,A1_EMAIL,"
	cQuery += " E1_VALJUR,E1.R_E_C_N_O_ AS REGE1"
	cQuery += " FROM "+RetSQLName("SE1")+" E1"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	cQuery += " INNER JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=' '"
	cQuery += " WHERE E1_VENCREA = '"+dtos(datavalida(dDtTree,.F.))+"' AND E1_BAIXA='' AND E1_PREFIXO <> 'CTR' "
	cQuery += " AND E1_TIPO='NF'"
	cQuery += " AND E1_FILIAL='"+xFilial('SE1')+"'"
	cQuery += " AND E1.D_E_L_E_T_=''AND E1_PORTADO BETWEEN '001' AND '999'"
	cQuery += " ORDER BY E1_CLIENTE,E1_LOJA,E1_VENCREA"

	If Select('TRBLOC') > 0
		dbSelectArea('TRBLOC')
		dbCloseArea()
	EndIf

	cSubject := "Aviso de Cobran็a"
	aTitCli := {}
	aAvisFi := {}
	aTitE1  := {}

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBLOC",.F.,.T.)
	dbSelectArea("TRBLOC")

	While !EOF()

		If cCliente != TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA
			cCliente := TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA
			If Len(aTitCli) > 0
				cBody := Cobranca3()
				U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
				aTitCli := {}
				cDestino := Alltrim(TRBLOC->A1_EMAIL) //
				cDestino := "hayewok628@jontra.com"
				nCont++
			Else
				If aScan(aTitCli,{|x| x[1] = TRBLOC->E1_NUM}) == 0
					Aadd(aTitCli,{TRBLOC->E1_NUM,stod(TRBLOC->E1_EMISSAO),stod(TRBLOC->E1_VENCREA),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),;
						DDATABASE-STOD(E1_VENCREA),Transform(TRBLOC->E1_VALJUR,"@E 999,999,999.99"),TRBLOC->ED_DESCRIC,TRBLOC->A1_NOME,;
						Transform(TRBLOC->E1_VALOR+(TRBLOC->E1_VALJUR*(DDATABASE-STOD(TRBLOC->E1_VENCREA))),"@E 999,999,999.99"),;
						TRBLOC->E1_PREFIXO,TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA})

				EndIf
				cDestino := Alltrim(TRBLOC->A1_EMAIL) 
				cDestino := "hayewok628@jontra.com"
			EndIf
		Else
			If aScan(aTitCli,{|x| x[1] = TRBLOC->E1_NUM}) == 0
				Aadd(aTitCli,{TRBLOC->E1_NUM,stod(TRBLOC->E1_EMISSAO),stod(TRBLOC->E1_VENCREA),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),;
					DDATABASE-STOD(E1_VENCREA),Transform(TRBLOC->E1_VALJUR,"@E 999,999,999.99"),TRBLOC->ED_DESCRIC,TRBLOC->A1_NOME,;
					Transform(TRBLOC->E1_VALOR+(TRBLOC->E1_VALJUR*(DDATABASE-STOD(TRBLOC->E1_VENCREA))),"@E 999,999,999.99"),;
					TRBLOC->E1_PREFIXO,TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA})
			EndIf

			cDestino := Alltrim(TRBLOC->A1_EMAIL) //
			cDestino := "hayewok628@jontra.com"
		EndIf

		nPsi := Ascan(aCumula,{|x| Alltrim(x[1]) == Alltrim(TRBLOC->A1_NOME)})
		If nPsi == 0
			Aadd(aCumula,{TRBLOC->A1_NOME,TRBLOC->E1_VALOR})
		Else
			aCumula[nPsi,02] += TRBLOC->E1_VALOR
		EndIf

		cCorpo := TRBLOC->E1_CLIENTE+'/'+TRBLOC->E1_LOJA+'/'+TRBLOC->A1_NOME+'/'+TRBLOC->E1_PREFIXO+'/'+TRBLOC->E1_NUM+'/'+CVALTOCHAR(STOD(TRBLOC->E1_VENCREA))+'/'+Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99")+'/'+TRBLOC->A1_EMAIL

		FWrite(nArq,cCorpo+chr(13)+chr(10))

		Aadd(aAvisFi,{TRBLOC->E1_CLIENTE,TRBLOC->E1_LOJA,TRBLOC->A1_NOME,TRBLOC->E1_PREFIXO+TRBLOC->E1_NUM,CVALTOCHAR(STOD(TRBLOC->E1_VENCREA)),Transform(TRBLOC->E1_VALOR,"@E 999,999,999.99"),TRBLOC->A1_EMAIL})
		Aadd(aTitE1,TRBLOC->REGE1)
		Dbskip()
	Enddo

	If len(aTitCli) > 0
		cBody := Cobranca3()
		U_EnviarEmail(cDestino,cSubject,cBody,"\system\LGRL01.PNG",.f.)
		aTitCli := {}
	EndIf

	fWrite(nArq, 'Fim '+DTOC(dDataBase) + ' ' + Time()+chr(13)+chr(10))
	fClose(nArq)

	IF len(aAvisFi) > 0
		cBody := AvisFin(cSubject,aCumula)

		cDestino := "alexandre.venancio@avsipro.com.br"
		U_EnviarEmail(cDestino,cSubject+" "+cvaltochar(ddatabase),cBody,"",.f.)
	EndIf

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aviso de Cobranca, enviado xx dias antes de vencer o tituloบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Aviso_1(cBoleto,cGerBol,nVlrAbat)

	Local aArea	:=	GetArea()

	cHtml := "<html>"
	cHtml += "<body>"
	
	If Empty(cCrtMd)
		cHtml += "<table width='1078' border='0'>"
		cHtml += "  <tr>"
		cHtml += "    	<td>Caro cliente,</td></tr>"
		cHtml += "  <tr>"
		cHtml += "		<td>Estamos com a(s) fatura(s) abaixo listadas em aberto no nosso sistema, aguardando pagamento.</td>"
		cHtml += "  </tr><br>"


		cHtml += "<table width='1078' border='0'>"
		cHtml += "  <tr bgcolor='#33FFFF'>"
		cHtml += "    <td align='center'><b>Aviso de vencimento / NOTA  Nบ "+TRBLOC->E1_NUM+" Prefixo "+TRBLOC->E1_PREFIXO+" "+cvaltochar(STOD(TRBLOC->E1_VENCREA))+"</b></td>"
		cHtml += "  </tr>"
		cHtml += "</table><br><br><br>"

		cHtml += "<table width='1078' border='0'>"
		cHtml += "  <tr bgcolor='#d4e6f6'>"
		cHtml += "    <td >Cedente:</td><td><b>"+Alltrim(SM0->M0_NOMECOM)+"</b></td></tr>"
		cHtml += "    <tr bgcolor='#5592bb'><td>Sacado:</td><td><b>"+Alltrim(TRBLOC->A1_NOME)+"</b> CำDIGO "+TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA+" CNPJ "+Transform(TRBLOC->A1_CGC,"@R 99.999.999/9999-99")+"</td></tr>"
		cHtml += "    <tr bgcolor='#d4e6f6'><td>Valor:</td><td><b>R$ "+cvaltochar(Transform(TRBLOC->E1_VALOR-nVlrAbat,"@E 999,999,999.99"))+"</b></td></tr>"
		cHtml += "    <tr bgcolor='#d4e6f6'><td>Vencimento:</td><td><b>"+cvaltochar(Stod(TRBLOC->E1_VENCREA))+"</b></td></tr>"
		cHtml += "    <tr bgcolor='#d4e6f6'><td>Refer๊ncia:</td><td><b>"+Alltrim(TRBLOC->ED_DESCRIC)+"</b></td></tr>"
		cHtml += "</table><br><br><br>"

		cHtml += "	Caso o pagamento jแ tenha ocorrido, favor desconsiderar essa comunica็ใo.<br>"
		cHtml += "  Permanecemos เ disposi็ใo. Obrigado!"
	Else 
		cHtml += "<table width='1078' border='0'>"
		cHtml += "  <tr>"
		cHtml += "    	<td>"+AllTrim(FWP->FWP_TXTSAU)+"</td></tr>"
		cHtml += "  <tr>"
		cHtml += "		<td>"+AllTrim(FWP->FWP_TXTCRT)+"</td>"
		cHtml += "  </tr><br>"

		cHtml += "<table width='1078' border='0'>"
		cHtml += "  <tr bgcolor='#33FFFF'>"
		cHtml += "    <td align='center'><b>Aviso de vencimento / NOTA  Nบ "+TRBLOC->E1_NUM+" Prefixo "+TRBLOC->E1_PREFIXO+"</b></td>"
		cHtml += "  </tr>"
		cHtml += "</table><br><br><br>"

		cHtml += "<table width='1078' border='0'>"
		cHtml += "  <tr bgcolor='#d4e6f6'>"
		cHtml += "    <td >Cedente:</td><td><b>"+Alltrim(SM0->M0_NOMECOM)+"</b></td></tr>"
		cHtml += "    <tr bgcolor='#5592bb'><td>Sacado:</td><td><b>"+Alltrim(TRBLOC->A1_NOME)+"</b> CำDIGO "+TRBLOC->E1_CLIENTE+TRBLOC->E1_LOJA+" CNPJ "+Transform(TRBLOC->A1_CGC,"@R 99.999.999/9999-99")+"</td></tr>"
		cHtml += "    <tr bgcolor='#d4e6f6'><td>Valor:</td><td><b>R$ "+cvaltochar(Transform(TRBLOC->E1_VALOR-nVlrAbat,"@E 999,999,999.99"))+"</b></td></tr>"
		cHtml += "    <tr bgcolor='#d4e6f6'><td>Vencimento:</td><td><b>"+cvaltochar(Stod(TRBLOC->E1_VENCREA))+"</b></td></tr>"
		cHtml += "    <tr bgcolor='#d4e6f6'><td>Refer๊ncia:</td><td><b>"+Alltrim(TRBLOC->ED_DESCRIC)+"</b></td></tr>"
		cHtml += "</table><br><br><br>"

		cHtml += FWP->FWP_TXTCON
	EndIf 	

	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+"  <br />" 
	cHtml += "  <strong>E-mail</strong><strong> </strong><a href='mailto:financeiro@jca.com.br'>financeiro@jca.com.br</a><u> </u></p></td>"
	cHtml += "  </tr>"
	cHtml += "</table>"

	cHtml += "</body>"
	cHtml += "</html>"

	RestArea(aArea)

Return(cHtml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 1 Aviso, enviado xx dias apos o vencimento do titulo       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca1()

	Local aArea	:= GetArea()
	Local cHtml
	Local nX 	:= 0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
	cHtml += " </tr>"
	cHtml += " <tr><br><br><br>"
	cHtml += "    <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td></tr><tr>"
	cHtml += "  <td><p>"+substr(aTitCli[1,11],1,6)+"-"+substr(aTitCli[1,11],7,2)+" / "+Alltrim(aTitCli[1,8])+"</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do tํtulo abaixo relacionado. Pedimos para efetuar o pagamento para evitar possํvel protestos/negativa็ใo. Para qualquer d๚vida, entrar em contato atrav้s do telefone (11) "+SM0->M0_TEL
	cHtml += "  Caso o pagamento jแ tenha ocorrido, anterior เ data de hoje, solicitamos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail: financeiro@jca.com.br , informando o numero do seu CNPJ."
	
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#33FFFF'><b>N๚mero NF</b></td><td align='center' bgcolor='#33FFFF'><b>Emissใo</b></td><td align='center' bgcolor='#33FFFF'><b>Vencimento</b></td><td align='center' bgcolor='#33FFFF'><b>Valor</b></td><td align='center' bgcolor='#33FFFF'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>
	cHtml += "</table><br><br>

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "    <td><p>Certos de  vossa aten็ใo, permanecemos no aguardo.</p></td>"
	cHtml += "  </tr><br><br><br>"
	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+" <br />"
	cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:financeiro@jca.com.br'>financeiro@jca.com.br</a></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "	<td><img src='cid:LGRL01.PNG'></td>"
	cHtml += "  </tr>"
	cHtml += "</table>"
	cHtml += "</body>"
	cHtml += "</html>"

	RestArea(aArea)

Return(cHtml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 2 Aviso, enviado xx dias apos o vencimento do titulo.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca2()

	Local aArea	:=	GetArea()
	Local cHtml
	Local nX  	:=	0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
	cHtml += "</tr>"
	cHtml += "  <tr>"
	cHtml += " <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td></tr><tr>"
	cHtml += "  <td><p>"+substr(aTitCli[1,11],1,6)+"-"+substr(aTitCli[1,11],7,2)+" / "+Alltrim(aTitCli[1,8])+"</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do tํtulo abaixo relacionado. Pedimos para efetuar o pagamento para evitar possํvel protestos/negativa็ใo. Para qualquer d๚vida, entrar em contato atrav้s do telefone (11) "+SM0->M0_TEL
	cHtml += "  Caso o pagamento jแ tenha ocorrido, anterior เ data de hoje, solicitamos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail: financeiro@jca.com.br , informando o numero do seu CNPJ."
	
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"

	cHtml += "<table width='1081' border='0'>"

	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#33FFFF'><b>N๚mero NF</b></td><td align='center' bgcolor='#33FFFF'><b>Emissใo</b></td><td align='center' bgcolor='#33FFFF'><b>Vencimento</b></td><td align='center' bgcolor='#33FFFF'><b>Valor</b></td><td align='center' bgcolor='#33FFFF'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>
	cHtml += "</table><br><br>

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  </tr>"
	cHtml += "  <tr><br>"
	cHtml += "    <td><p><em>Certos  da vossa aten็ใo, permanecemos no aguardo.</em></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td>&nbsp;</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+"<br />" 
	cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:financeiro@jca.com.br'>financeiro@jca.com.br</a></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "	<td><img src='cid:LGRL01.PNG'></td>"
	cHtml += "  </tr>"
	cHtml += "</table>"
	cHtml += "</body>"
	cHtml += "</html>"

	RestArea(aArea)

Return(cHtml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  01/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  3 Aviso, enviado xx dias apos o vencimento do titulo.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cobranca3()

	Local aArea	:=	GetArea()
	Local cHtml
	Local nX 	:=	0

	cHtml := "<html>"
	cHtml += "<body>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += " <td align='center' bgcolor='#33FFFF'><b>Aviso de Cobran็a</b></td>"
	cHtml += "</tr>"
	cHtml += "  <tr>"
	cHtml += " <td align='right'>Sใo Paulo, "+Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999')+".</td>"
	cHtml += "</tr></table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td><p>Prezado Cliente,</p></td></tr><tr>"
	cHtml += "  <td><p>"+substr(aTitCli[1,11],1,6)+"-"+substr(aTitCli[1,11],7,2)+" / "+Alltrim(aTitCli[1,8])+"</p></td>"
	cHtml += "  </tr><br><br>"
	cHtml += "  <tr>"
	cHtml += "  <td>Informamos que at้ a presente data, nใo registramos o pagamento do tํtulo abaixo relacionado. Pedimos para efetuar o pagamento para evitar possํvel protestos/negativa็ใo. Para qualquer d๚vida, entrar em contato atrav้s do telefone (11) "+SM0->M0_TEL
	cHtml += "  Caso o pagamento jแ tenha ocorrido, anterior เ data de hoje, solicitamos que desconsidere este aviso e nos encaminhe o comprovante de pagamento atrav้s do e-mail: financeiro@jca.com.br , informando o numero do seu CNPJ."
	
	cHtml += "  </tr>"
	cHtml += "</table>
	cHtml += "<br><br><br>"
	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  <td align='center' bgcolor='#33FFFF'><b>N๚mero NF</b></td><td align='center' bgcolor='#33FFFF'><b>Emissใo</b></td><td align='center' bgcolor='#33FFFF'><b>Vencimento</b></td><td align='center' bgcolor='#33FFFF'><b>Valor</b></td><td align='center' bgcolor='#33FFFF'><b>Natureza</b></td>"
	cHtml += "  </tr>"

	For nX := 1 to len(aTitCli)
		cHtml += "  <tr>"
		cHtml += "<td align='center'>"+aTitCli[nX,10]+aTitCli[nX,01]+"</td><td align='center'>"+cvaltochar(aTitCli[nX,02])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,03])+"</td><td align='center'>"+cvaltochar(aTitCli[nX,04])+"</td><td align='center'>"+Alltrim(aTitCli[nX,07])+"</td>
		cHtml += "  </tr>"
	Next nX

	cHtml += "</table><br><br><br>"

	cHtml += "<table width='1081' border='0'>"
	cHtml += " <br><br><b>Esta mensagem nใo cont้m anexos</b><br><br>
	cHtml += "</table><br><br>

	cHtml += "<table width='1081' border='0'>"
	cHtml += "  <tr>"
	cHtml += "  </tr>"
	cHtml += "  <tr><br>"
	cHtml += "    <td>O nใo pronunciamento ensejarแ no encaminhamento do(s) tํtulo(s) para cart๓rio.</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><p>Certos  de vossa aten็ใo, permanecemos no aguardo. </p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td>&nbsp;</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td><p><strong>"+Alltrim(SM0->M0_NOMECOM)+"</strong><br />"
	cHtml += "      Departamento Financeiro<br />"
	cHtml += "      "+Alltrim(SM0->M0_ENDENT)+" "+Alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+"<br />"
	cHtml += "  <strong>T</strong>el 55 (11) "+SM0->M0_TEL+"<br />"
	cHtml += "  <strong>E-mail:</strong><strong> </strong><a href='mailto:financeiro@jca.com.br'>financeiro@jca.com.br</a></p></td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "    <td>&nbsp;</td>"
	cHtml += "  </tr>"
	cHtml += "  <tr>"
	cHtml += "	<td><img src='cid:LGRL01.png'></td>"
	cHtml += "  </tr>"
	cHtml += "</table>"
	cHtml += "</body>"
	cHtml += "</html>"

	RestArea(aArea)

Return(cHtml)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAMCFIN11  บAutor  ณMicrosiga           บ Data ณ  03/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AvisFin(cSubject,aCumula)

	Local cHtml	:=	"<html>"
	Local nX 	:=	0

	cHtml	+=	"	<head>		<title></title>	</head>"
	cHtml	+=	" 	<body><b>		<p>"+cSubject+" transmitidos.</b></p>"
	cHtml	+=	"	<table border='0' cellpadding='1' cellspacing='1' style='width: 1900px;'>
	cHtml	+=	"	<tr bgcolor='#0000FF'><td>Codigo Cliente</td>"
	cHtml	+=	"	<td>Loja</td>"
	cHtml	+=	"	<td>Nome</td>"
	cHtml	+=	"	<td>Titulo</td>"
	cHtml	+=	"	<td>Vencto.</td>"
	cHtml	+=	"	<td>Valor</td>"
	cHtml	+=	"	<td>Email</td>"
	cHtml	+=	"	</tr>"

	For nX := 1 to len(aAvisFi)
		cHtml 	+= 	"<tr bgcolor='"+If(Mod(nX,2)==0,"#d4e6f6","#5592bb")+"'>"
		cHtml	+=	"	<td>"+aAvisFi[nX,01]+"</td>"
		cHtml	+=	"	<td>"+aAvisFi[nX,02]+"</td>"
		cHtml	+=	"	<td>"+aAvisFi[nX,03]+"</td>"
		cHtml	+=	"	<td>"+aAvisFi[nX,04]+"</td>"
		cHtml	+=	"	<td>"+aAvisFi[nX,05]+"</td>"
		cHtml	+=	"	<td>"+aAvisFi[nX,06]+"</td>"
		cHtml	+=	"	<td>"+Alltrim(aAvisFi[nX,07])+"</td>"
		cHtml	+=	"	</tr>"
	Next nX

	cHtml 	+=	" </table>"
	cHtml	+=	"	<p>&nbsp;</p>"

	If len(aCumula) > 0

		cHtml 	+=	" 	<table border='0' cellpadding='1' cellspacing='1' style='width: 900px;'>"
		cHtml	+=	"	<tr><td>Cliente</td>"
		cHtml	+=	"	<td>Acumulado</td>"
		cHtml	+=	"	</tr>"

		Asort(aCumula,,,{|x,y| x[2] > y[2]})

		For nX := 1 to len(aCumula)
			cHtml 	+= 	"<tr>"
			cHtml	+=	"	<td>"+aCumula[nX,01]+"</td>"
			cHtml	+=	"	<td>"+Transform(aCumula[nX,02],"@E 999,999,999.99")+"</td>"
			cHtml	+=	"</tr>"
		Next nX
		cHtml 	+=	" </table>"
		cHtml	+=	"	<p>&nbsp;</p>"
	EndIf

	cHtml	+=	"	</body></html>"

Return(cHtml)
