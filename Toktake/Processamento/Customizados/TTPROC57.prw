#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC57    ºAutor  ³Jackson E. de Deusº Data ³  30/06/17   º±±
±±º							Xcode Mobile								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Painel de movimentos de produtos - Acompanhamento/Fecham.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTPROC57(cRota)

Local aArea			:= GetArea()
Local aSize			:= MsAdvSize()
Local nWdtRdp		:= aSize[5]/2
Local oLayer		:= FwLayer():New()
Local dDtIni		:= dDatabase
Local lPend			:= .F.
Local aRet			:= {}
Local aPergs		:= {}
Local lFim			:= .F.
Local aNFSaida		:= {}
Local cNfDev		:= ""
Local cSeriDev		:= ""
Local cDescZZ1		:= ""
Local dIniCClo		:= dDatabase
Local cNumOS		:= ""
Local aProds		:= {}
Local cHrIniCC		:= ""
Local aItensDev		:= {}

Private _dIniCiclo	:= dDatabase
Private _cHrIniCC	:= ""
Private _aProdZ6	:= {}
Private _aNF		:= {}
Private _cNfDev		:= ""
Private _cSerDv		:= ""
Private _aDocIt		:= {}
Private _aAbast		:= {}
Private _aRetir		:= {}
Private _aDescarte	:= {}
Private _cTecAtend	:= ""
Private cTpEntr		:= ""
Private oOSStat		:= Nil
Private oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oProb		:= LoadBitMap(GetResources(), "BR_VERMELHO")
Private oBranco		:= LoadBitMap( GetResources(), "BR_BRANCO" )
Private oVerde		:= LoadBitMap( GetResources(), "BR_VERDE" )
Private oTelaF
Private oLista1
Private _aLista1	:=	{}
Private aLista2		:=	{}
Private _cRota		:= ""
Private _cOsInvent	:= ""
Private _lNFDev		:= .F.
Private _lPedOk		:= .F.
Private _lFim		:= .F.
Private _lDivOk 	:= .F.
Private _aItensDev	:= {} // INCLUIDO POR RONALDO G. DE JESUS - 17/10/2018

Default cRota		:= ""



If Empty(cRota)
	aAdd(aPergs ,{1,"Rota/PA?"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",6,.F.})
	If !ParamBox(aPergs ,"Inventário",@aRet)
		Return
	Else
		cRota := aRet[1]
		If Empty(cRota)
			MsgAlert("Informe uma Rota/PA válida!")
			Return
		EndIf
	EndIf
EndIf

_cRota := cRota

_cTecAtend := fTecAA1( cRota )	// tecnico

// tipo de ciclo de trabalho
dbSelectArea("ZZ1")
dbSetOrder(1)
If MSSeek( xFilial("ZZ1") +AvKey( _cRota,"ZZ1_COD" ) )
	cDescZZ1 := AllTrim( ZZ1->ZZ1_DESCRI )
	cTpEntr := AllTrim( ZZ1->ZZ1_TIPO )
EndIf


// produtos do armazem
Processa( { || fProdsArm( cRota,@aProds ) },"Verificando produtos, aguarde.." )

_aProdZ6 := Aclone(aProds)
If Empty( _aProdZ6 )
	MsgAlert( "Criar saldos iniciais na tabela SZ6" )
	Return
EndIf


// produtos das notas em poder da rota - pega o que esta pendente de fechamento
Processa( { || ProdNF( cRota ) },"Verificando notas, aguarde..")

// tabela customizada
TabDocs()

// define dia de inicio e OS de inventario
LoadIni( _cRota,dDatabase,@dIniCClo,@cNumOS,@cHrIniCC )
_dIniCiclo := dIniCClo
_cOSInvent := cNumOS
_cHrIniCC := cHrIniCC

// montar array da lista do grid
For nI := 1 To Len( _aProdZ6 )
	AADD( _aLista1, { "1",;
					_aProdZ6[nI][1],;
					_aProdZ6[nI][2],;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					"",;
					0 } ) 
Next nI



// carrega saldos - grid
Processa( { || RefAtu( _dIniCiclo )  },"Carregando dados.." )


// nf saida
ChkNfS( _cRota,dIniCClo,cHrIniCC,dDAtabase,@aNFSaida )

_aNF := Aclone( aNFSaida )


// nf dev
ChkNfDv( _cRota,dIniCClo,cHrIniCC,dDatabase, @cNfDev,@cSeriDev,@aItensDev )
If !Empty(cNfDev)
	_lNFDev := .T.

	_cNfDev := cNfDev
	_cSerDv := cSeriDev
	_aItensDev := aClone( aItensDev )
EndIf


// verifica se ja gerou os pedidos
ChkPeds(_dIniCiclo,dDatabase,_cHriniCC)


// monta a tela
oTelaF := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Fechamento - "+cRota +" " +cDescZZ1,,,.F.,,,,,,.T.,,,.T. )
	oTelaF:lEscClose := .F.
	oTelaF:lMaximized := .T.

	oPanel3 := tPanel():New(0,0,"",oTelaF,,,,,,0,30)
	oPanel3:SetCss( "QLabel { background-color: #E1E1E1; }" )
	oPanel3:align := CONTROL_ALIGN_BOTTOM

    oLayer:Init(oTelaF,.F.)
	oLayer:addLine("LINHA1",100,.F.)
	oLayer:addCollumn('COLUNA1_1',100,.F.,"LINHA1")

  	oLayer:addWindow("COLUNA1_1","WIN_2","Análise dos produtos - " +cDescZZ1,100,.T.,.F.,{||  },"LINHA1")
	oPnl1 := oLayer:GetWinPanel("COLUNA1_1","WIN_2","LINHA1")

	oLista1 := TCBrowse():New(0,0,0,0,, {"","Produto","Descrição","Estoque ant.","Carga recebida","Abastecido","Retirado","Saldo","Estoque contado",;
									"Devolução Apontada","Avarias de Maq. a Dev.","Contagem avarias","Div. avarias","Div. totais","Desconto","Dev em NF"},;
							{20,50,100,50,50,50,50,50,50,50,60,50,50,50,50,50},;
	      					oPnl1,,,,{ || },{ || Detalhe( _aLista1[oLista1:nAt,02] ) },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oLista1:Align := CONTROL_ALIGN_ALLCLIENT
	oLista1:SetArray(_aLista1)
	oLista1:bLine := { || {  IcStat(_aLista1[oLista1:nAt,01]),;
							 _aLista1[oLista1:nAt,02],;
		 					 _aLista1[oLista1:nAt,03],;
		                     _aLista1[oLista1:nAt,04],;
		                     _aLista1[oLista1:nAt,05],;
		                     _aLista1[oLista1:nAt,06],;
		                     _aLista1[oLista1:nAt,07],;
		                     _aLista1[oLista1:nAt,08],;
		                     _aLista1[oLista1:nAt,09],;
	   	                     _aLista1[oLista1:nAt,10],;
		                     _aLista1[oLista1:nAt,11],;
		                     _aLista1[oLista1:nAt,12],;
		                     _aLista1[oLista1:nAt,13],;
		                     _aLista1[oLista1:nAt,14],;
		                     _aLista1[oLista1:nAt,15],;
		                     _aLista1[oLista1:nAt,16] }}


	// botoes
	oSDT := TSay():New( 2,05,{ || "Inicio ciclo" },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,12,,,,,,.F. )
	oSDT:SetCss( "QLabel {font: bold 12px; color: #333333; }" )

	oSDTD := TSay():New( 2,40,{ || DTOC(_dIniCiclo) +" " +_cHrIniCC },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,15,,,,,,.F. )
	oSDTD:SetCss( "QLabel {font: bold 12px; color: #B2246B; }" )

	//oSNf := TSay():New( 12,05,{ || "NF Devolução: " +cNfDev +"/" +cSeriDev },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,12,,,,,,.F. )
	//oSNf:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	//oSNf:bLClicked := { || IIF( !Empty(cNfDev),VisNF(cNfDev), ) ) }

	// os de inventario
	oSOS := TSay():New( 22,05,{ || "OS invent. " +_cOsInvent },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,12,,,,,,.F. )
	oSOS:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	oSOS:bLClicked := { ||  }

	oOSStat := TBitmap():Create(oPanel3,22,95,10,10,"BR_BRANCO",,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)


 	// Menu popup do botao de acoes
	MENU oMenu POPUP
	MENUITEM "Refresh"					ACTION ( Processa( { || RefAtu( _dIniCiclo ) },"Recarregando dados, aguarde..")  )
	MENUITEM "NFs com Rota/PA"			ACTION ( MsAguarde({ || VerNotas() },"Carregando notas...") )
	MENUITEM "Estorno Movimentos"		ACTION ( IIF( VldPerm(8),EstMov(),/**/ ) )
	MENUITEM "Pesquisa Prod"			ACTION ( PesqGrid() )
	MENUITEM "Extrato Abastecimento"	ACTION ( U_TTFATR50( cRota,_dIniCiclo,dDatabase,_cHrIniCC ) )
	MENUITEM "Pedidos descarte/perda"	ACTION ( fPedDesc() )
	MENUITEM "Processar O.S."			ACTION ( U_TTPROC58( cRota,_dIniCiclo,_cHrIniCC,dDatabase  ) )
	ENDMENU


	oBt2 := TButton():New( 05, nWdtRdp-400,"1.OS Inventário",oPanel3,{ || gerarInv(_dIniCiclo,dDAtabase,_cHrIniCC) },040,015,,,,.T.,,"Gerar a conferência dos produtos",,,,.F. )
	oBt2:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-repeat: none; margin: 1px }" )

	oBtInv := TButton():New( 05, nWdtRdp-360,"2.Proc. Inv.",oPanel3,{ || CalcInv() },040,015,,,,.T.,,"Processa as contagens",,,,.F. )
	oBtInv:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-repeat: none; margin: 1px }" )

   	oBtCnc := TButton():New( 05, nWdtRdp-320,"3.Cancelar Inv.",oPanel3,{ || CancInv() },040,015,,,,.T.,,"Cancelar a OS de inventário",,,,.F. )
	oBtCnc:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-repeat: none; margin: 1px }" )

	oBtNF := TButton():New( 05, nWdtRdp-280,"5.Devolução",oPanel3,{ || NFDEV() },040,015,,,,.T.,,"Gerar devolução de produtos",,,,.F. )
	oBtNF:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-repeat: none; margin: 1px }" )

    oBt3 := TButton():New( 05, nWdtRdp-240,"4.Relatório",oPanel3,{ || U_TTESTR15( cRota,_dIniCiclo,dDatabase,_cHrIniCC,_aLista1, _aNF,_cNfDev, _cSerDv ) },040,015,,,,.T.,,"Relatório de movimentos do periodo",,,,.F. )
	oBt3:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px;  background-repeat: none; margin: 1px }" )

    oBtDiv := TButton():New( 05, nWdtRdp-200,"6.Ajuste Div.",oPanel3,{ || AjusteDiv() },040,015,,,,.T.,,"Ajusta divergências",,,,.F. )	// E PEDIDOS DE PERDA
	oBtDiv:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-repeat: none; margin: 1px }" )

   	oBt4 := TButton():New( 05, nWdtRdp-160,"7.Pedidos",oPanel3,{ || PedDesc()  },040,015,,,,.T.,,"Gerar pedidos de descarte",,,,.F. )
	oBt4:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px;  background-repeat: none; margin: 1px }" )

	oBt5 := TButton():New( 05, nWdtRdp-120,"8.Encerrar",oPanel3,{ || lFim := FimC2(lPend) ,IIF(lFim,oTelaF:End(),)  },040,015,,,,.T.,,"Encerrar a prestação de contas",,,,.F. )
	oBt5:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px;  background-repeat: none; margin: 1px }" )

   	oBt6 := TButton():New( 05, nWdtRdp-80,"Sair",oPanel3,{ || oTelaF:End() },040,015,,,,.T.,,"Sair da rotina",,,,.F. )
	oBt6:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px;  background-repeat: none; margin: 1px }" )


	oBtnZ := TBtnBmp2():New( 02,(nWdtRdp*2)-40,40,40,"ENGRENAGEM",,,,{ || },oPanel3,,,.T. )
	oBtnZ:SetPopupMenu(oMenu)

	oLista1:nScrollType := 1


	// carrega status
	oTelaF:bStart := { || Start() }

oTelaF:Activate(,,,.T.)

RestArea(aArea)

Return

/*
Carregamento inicial - verifica se ja tem fechamento em aberto de dias anteriores
*/
Static Function Start()

Local cQuery := ""
Local cOsAnt := ""
Local nI
Local lOpen	:= .F.


// verifica se tem fechamento em aberto
cQuery := "SELECT TOP 1 ZG_NUMOS, ZG_DATAINI FROM " +RetSqlName("SZG")
cQuery += " WHERE ( ZG_ROTA = '"+_cRota+"' OR ZG_PA = '"+_cRota+"' ) AND ZG_FORM = '21' "
cQuery += " AND ZG_DATAINI > '20170615' "
cQuery += " AND ZG_DATAINI < '"+Dtos(_dIniCiclo)+"' "
cQuery += " AND ZG_STATUS NOT IN ( 'COPE','CTEC' ) AND D_E_L_E_T_ = '' AND ZG_PROC = '' "

MpSysOpenQuery( cQuery,"TRBZ" )

dbSelectArea("TRBZ")
// nao processou ?
If !EOF()

	dbSelectArea("SZC")
	dbSetOrder(3)
	If !MsSeek( xFilial("SZC") +AvKey(TRBZ->ZG_NUMOS,"ZC_NUMOS") )
		lOpen := .T.
	EndIf

	If AllTrim( SZC->ZC_PROC ) <> "S"
		lOpen := .T.
	EndIf
	// DESCOMENTAR DEPOIS QUE TODAS AS PAS/ROTAS ESTIVEREM NO NOVO PROCESSO
	/*If lOpen
		Aviso("TTPROC57","Essa Rota/PA está em fechamento, iniciado no dia " +dtoc(stod(TRBZ->ZG_DATAINI)) +CRLF +"Entre o sistema com a data mencionada e encerre o fechamento.",{"Ok"})
		oTelaF:End()
	EndIf*/
EndIf


// DESABILITAR BOTOES DE ETAPAS QUE JA FORAM CONCLUIDAS
If !Empty( _cOsInvent )
	oBt2:Disable()
EndIf

dbSelectArea("SZC")
dbSetOrder(3)
If MsSeek( xFilial("SZC") +AvKey(_cOsInvent,"ZC_NUMOS") )
	oBtInv:Disable()

	If AllTrim( SZC->ZC_PROC ) == "S"
		_lFim := .T.
	EndIf

EndIf

If _lDivOk
	oBtDiv:Disable()
EndIf

If _lNFDev
	oBtNF:Disable()
EndIf

If _lPedOk
	oBt4:Disable()
EndIf


If dDatabase <> Date() .And. _lFim
	oBt5:Disable()
EndIf

If _lFim
	oBtCnc:Disable()
	oBt5:Disable()
EndIf

RetStat()


//TabDocs()

Return


/*
grid de pesquisa
*/
Static Function PesqGrid()

Local oDlg
Local oFont := TFont():New('Arial',,16,,.T.,,,,,.F.,.F.)
Local cPesq := Space(15)


oDlg := MSDialog():New(0,0,100, 412,"Pesquisa",,,,,,,,,.T.,,,,.T.)
	oPanel := tPanel():New( 0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,0 )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	oPanel:SetCss( "QLabel { background-color: #EBEBFF; }" )

	oGet1 := TGet():New( 20,20,{ |u| If( Pcount()>0,cPesq:=u,cPesq ) },oPanel,130,13,'',,CLR_BLACK,CLR_WHITE,oFont,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,,,,,"Digite")
	oGet1:SetCss("QLineEdit { border: 1px solid gray; border-radius: 3px; color: #5C5C99; font: 16px; }") //;QLabel {font: bold 14px; color: #CC0000; }")

	oBtn := TButton():New( 20,152,"Pesquisar",oPanel,{ || findItem(cPesq) },050,15,,,,.T.,,"",,,,.F. )
	oBtn:SetCss( "QPushButton{ border: 1px solid gray; border-radius: 3px; background-image: url(rpo:LUPA.png); background-repeat: none; margin: 1px }" )
oDlg:Activate(,,,.T.,{|| },,{ || } )


Return


/*
Procura o item com base no codigo digitado
*/
Static Function findItem(cPesq)

Local nI

For nI := 1 To Len(_aLista1)
	If AllTrim(_aLista1[nI][2]) == AllTrim(cPesq)
		oLista1:GoPosition(nI)
		Exit
	EndIf
Next nI


Return


/*
Carrega o inicio do ciclo e OS de inventario atual
*/
Static Function LoadIni( cArmazem,dDtIni,dIniCClo,cNumOS, cHrInicio )

Local cQuery := ""
Local nI
Default dDtIni	:= dDatabase

// inicio do ciclo = data do ultimo inventario anterior+1
/*cQuery := "SELECT TOP 1 ZG_NUMOS,ZG_DATAFIM,ZG_HORAFIM, ZG_HRPROC FROM " +RetSqlName("SZG")
cQuery += " WHERE ( ZG_ROTA = '"+cArmazem+"' OR ZG_PA = '"+cArmazem+"' ) AND D_E_L_E_T_ = '' AND ZG_STATUS = 'FIOK' AND ZG_DATAFIM <= '"+DTOS(dDtIni)+"' AND ZG_FORM = '21' "
cQuery += " AND ZG_HRPROC <> '' "
cQuery += " ORDER BY ZG_DATAFIM DESC "*/
cQuery := "SELECT TOP 1 ZG_NUMOS,ZG_DATAFIM,ZG_HORAFIM, ZG_HRPROC FROM " +RetSqlName("SZG")
cQuery += " WHERE ( ZG_ROTA = '"+cArmazem+"' OR ZG_PA = '"+cArmazem+"' ) AND D_E_L_E_T_ = '' AND ZG_STATUS NOT IN ( 'COPE','CTEC' ) AND ZG_DATAFIM <= '"+DTOS(dDtIni)+"' AND ZG_FORM = '21' "
cQuery += " AND ZG_HRPROC <> '' "
cQuery += " ORDER BY R_E_C_N_O_ DESC "

MpSysOpenQuery( cQuery,"TRBZ" )

dbSelectArea("TRBZ")
//dIniCClo := STOD(TRBZ->ZG_DATAFIM)+1
dIniCClo := STOD(TRBZ->ZG_DATAFIM)
cHrInicio := TRBZ->ZG_HRPROC


TRBZ->(dbCloseArea())

If Empty(dIniCClo)
	dIniCClo := dDatabase
	cHrInicio := "00:00:00"
EndIf


cQuery := "SELECT TOP 10 ZG_NUMOS,ZG_DATAFIM, ZG_DATAINI,ZG_HORAINI FROM " +RetSqlName("SZG")
cQuery += " WHERE ( ZG_ROTA = '"+cArmazem+"' OR ZG_PA = '"+cArmazem+"' ) AND D_E_L_E_T_ = '' "
cQuery += " AND ZG_DATAINI >= '"+DTOS(dIniCClo)+"' AND ZG_DATAINI <= '"+dtos(dDatabase)+"'  "
cQuery += " AND ZG_STATUS NOT IN ( 'COPE','CTEC' ) AND ZG_FORM = '21' "
cQuery += " ORDER BY ZG_DATAFIM DESC "

MpSysOpenQuery( cQuery,"TRBZ" )

dbSelectArea("TRBZ")
// pegar a OS gerada
While !EOF()
	If ( stod(TRBZ->ZG_DATAINI) == dIniCClo .And. TRBZ->ZG_HORAINI > cHrInicio ) .OR. stod(TRBZ->ZG_DATAINI) > dIniCClo
		cNumOS := AllTrim(TRBZ->ZG_NUMOS)
		Exit
	EndIf
	dbSkip()
End
//cNumOS := AllTrim(TRBZ->ZG_NUMOS)

Return


/*
Valida permissoes nos botoes
*/
Static Function VldPerm( nBotao )

Local lRet := .T.
Local cPerm1 := SuperGetMV("MV_XFAT001",.T.,"")
Local cPerm2 := SuperGetMV("MV_XFAT002",.T.,"")
Local cPerm3 := SuperGetMV("MV_XFAT003",.T.,"")
Local cPerm4 := SuperGetMV("MV_XFAT004",.T.,"")
Local cPerm5 := SuperGetMV("MV_XFAT005",.T.,"")
Local cPerm6 := SuperGetMV("MV_XFAT006",.T.,"")
Local cPerm7 := SuperGetMV("MV_XFAT007",.T.,"")
Local cPerm8 := SuperGetMV ("MV_XFAT013",.T.,"JDEUS#JNASCIMENTO") // AJUSTADO POR RONALDO G. DE JESUS - 17/10/2018
//Local cPerm8 := "JDEUS#JNASCIMENTO"


If nBotao == 1
	If !cUserName $ cPerm1
		lRet := .F.
	EndIf
ElseIf nBotao == 2
	If !cUserName $ cPerm2
		lRet := .F.
	EndIf
ElseIf nBotao == 3
	If !cUserName $ cPerm3
		lRet := .F.
	EndIf
ElseIf nBotao == 4
	If !cUserName $ cPerm4
		lRet := .F.
	EndIf
ElseIf nBotao == 5
	If !cUserName $ cPerm5
		lRet := .F.
	EndIf
ElseIf nBotao == 6
	If !cUserName $ cPerm6
		lRet := .F.
	EndIf
ElseIf nBotao == 7
	If !cUserName $ cPerm7
		lRet := .F.
	EndIf
EndIf

// botoes F6 e F7
If nBotao == 8
	If !cUserName $ cPerm8
		lRet := .F.
	EndIf
EndIf

Return lRet


/*
Refresh - atualiza o grid
*/
Static Function RefAtu( _dIniCiclo )

Local nI,nJ
Local nSaldoAnt := 0
Local aConf := {}
Local dDtIni := dDatabase
Local aQtd := {}
Local nQt := 0
Local nAbast := 0
Local nQAtu := 0
Local nRetir := 0
Local nEstoque := 0
Local nDescarte := 0
Local nConfBom := 0
Local nConfRuim := 0
Local nDevOS := 0
Local nDivAvar := 0
Local nDivBom := 0
Local nDivTot := 0
Local aConfBom := {}
Local aConfRuim := {}
Local nDesconto := 0
Local nDevNF := 0
Local aExced := {}
Local aTotFica := {}
Local cArm := IIF( SubStr(_cRota,1,1) == "R",_cRota,"A"+SubStr(_cRota,2) )
Local aCarga :={}
Local aAbast := {}
Local aRetir := {}
Local aDescarte := {}
Local aQtdSldAnt := {}



ProcRegua(3)

// carrega abastecidos - retirados - descartes
IncProc("Movimentos..")
MovSZ5( _cRota,_dIniCiclo,dDatabase,@aCarga,@aAbast,@aRetir,@aDescarte, _cHrIniCC )
_aAbast := Aclone( aAbast )
_aRetir := Aclone( aRetir )
_aDescarte := Aclone( aDescarte )

// conferidos
IncProc("Verificando contagem..")
ItensInv( _cOsInvent, @aConfBom, @aConfRuim, @aExced, @aTotFica )


// PEGAR SALDO ANTERIOR - OS DE INVENTARIO DO CICLO ANTERIOR
SldAntZC( _cRota,_dIniCiclo, @aQtdSldAnt, _cHrIniCC )




IncProc("Preparando grid..")

dbSelectArea("SZ6")
dbSetOrder(1)
For nI := 1 To Len( _aLista1 )

	nSaldoAnt := 0
	nQt := 0
	nAbast := 0
	nQAtu := 0
	nRetir := 0
	nDescarte := 0
	nEstoque := 0
	nConfBom := 0
	nConfRuim := 0
	nDevOS := 0
	nDivAvar := 0
	nDivTot := 0
	nDesconto := 0
	nDevNF := 0

	// saldo anterior
	For nJ := 1 To Len(aQtdSldAnt)
		If AllTrim( _aLista1[nI][2] ) == AllTrim( aQtdSldAnt[nJ][1] )
			nSaldoAnt += aQtdSldAnt[nJ][2]
		EndIf
	Next nJ


	// qtd total de carga
	For nJ := 1 To Len(aCarga)
		If AllTrim(_aLista1[nI][2]) == AllTrim(aCarga[nJ][1])
			nQt += aCarga[nJ][2]
		EndIf
	Next nJ

	// qtd utilizada do produto
	For nJ := 1 To Len(_aAbast)
		If AllTrim(_aLista1[nI][2]) == AllTrim(_aAbast[nJ][1])
			nAbast += _aAbast[nJ][3]
		EndIf
	Next nJ

	// retirado
	For nJ := 1 To Len(_aRetir)
		If AllTrim(_aLista1[nI][2]) == AllTrim(_aRetir[nJ][1])
			nRetir += _aRetir[nJ][2]
		EndIf
	Next nJ

	// saldo
    dbSelectArea( "SZ6" )
    If MsSeek( xFilial("SZ6") +AvKey( cArm ,"Z6_LOCAL") +AvKey( _aLista1[nI][2],"Z6_COD") )
		nQAtu := SZ6->Z6_QATU
    EndIf

	// conferido bom
	For nJ := 1 To Len( aConfBom )
		If AllTrim(_aLista1[nI][2]) == AllTrim(aConfBom[nJ][1])
			nConfBom := aConfBom[nJ][2]
			Exit
		EndIf
	Next nJ

	// conferido ruim
	For nJ := 1 To Len( aConfRuim )
		If AllTrim(_aLista1[nI][2]) == AllTrim(aConfRuim[nJ][1])
			nConfRuim := aConfRuim[nJ][2]
			Exit
		EndIf
	Next nJ


	// contagem descarte maquinas
	For nJ := 1 To Len( _aDescarte )
		If AllTrim(_aLista1[nI][2]) == AllTrim(_aDescarte[nJ][1])
			nDescarte += _aDescarte[nJ][2]
		EndIf
	Next nJ

	nPos := AScan( aExced, { |x| AllTrim(x[1]) == AllTrim(_aLista1[nI][2]) } )
	If nPos > 0
		nDevOs := aExced[nPos][2]
	EndIf

	// devolucoes ja efetuadas - NF devolucao
	For nJ := 1 To Len( _aItensDev )
		If AllTrim(_aLista1[nI][2]) == AllTrim(_aItensDev[nJ][1])
			nDevNF += _aItensDev[nJ][2]
		EndIf
	Next nJ



	// divergencia avarias
	nDivAvar := ( nConfRuim - nDescarte )
	nDivBom := ( nConfBom - nQAtu )

	// divergencias totais
	nDivTot := nDivBom	//( nConfBom - nQAtu )
	//nDivTot := ( nConfBom - nDevNF - nQAtu )  // ALTERADO POIS APOS GERAR A DEVOLUCAO, O SALDO BAIXA E GERA DIVERGENCIA POSITIVA NA COLUNA DIVERGENCIAS TOTAIS

	If nDivAvar > 0
		nDivTot += nDivAvar
	EndIf

	If nDivTot < 0
		nDesconto += nDivTot
	EndIf
	If nDivAvar < 0
		nDesconto += nDivAvar
	EndIf

	/*
	13.	Divergências Totais: (Estoque Contado Bom - Saldo) + se Divergência de Avarias > 0, soma, senão não soma.
	14.	Desconto Funcionario: Soma valores de Se 13.<0, + se 12.<0.
	*/

	_aLista1[nI][4] := nSaldoAnt
	_aLista1[nI][5] := nQt
	_aLista1[nI][6] := nAbast
	_aLista1[nI][7] := nRetir
	_aLista1[nI][8] := nQAtu
	_aLista1[nI][9] := nConfBom
	_aLista1[nI][10] := nDevOS		// devolucao apontada
	_aLista1[nI][11] := nDescarte	// descarte do periodo - apontado nas OS de abastecimento
	_aLista1[nI][12] := nConfRuim	// descarte que foi conferico no inventario
	_aLista1[nI][13] := nDivAvar
	_aLista1[nI][14] := nDivTot
	_aLista1[nI][15] := nDesconto
	_aLista1[nI][16] := nDevNF

Next nI

/*
0 status
1 produto
2 descricao
3 estoque anterior
4 carga recebida - total recebido no armazem
5 abastecido
6 retirado
7 saldo
8 estoque contado
9 devolucao apontada na os
10 avaria em maquinas a devolver - apontadas nas os
11 contagem das avarias
12 divergencia de avarias
13 divergencia totais
14 desconto
15 qtd ja devolvida nf
*/

ChkInco()

RetStat()

Return


/*
Status da OS de inventario
*/
Static Function RetStat()


Local cCor := ""

// STATUS DA OS DE INVENTARIO
If Empty(_cOsInvent)
	If oOSStat <> Nil
		oOSStat:Hide()
	EndIf
Else
	If oOSStat <> Nil
		oOSStat:Show()
		dbSelectArea("SZG")
		dbSetOrder(1)
		If MsSeek( xFilial("SZG") +AvKey(_cOsInvent,"ZG_NUMOS") )
			If AllTrim( SZG->ZG_STATUS ) == "ACTE"
				oOSStat:SetBmp( "BR_AMARELO" )
			ElseIf AllTrim( SZG->ZG_STATUS ) == "INIC"
				oOSStat:SetBmp( "BR_VIOLETA" )
			ElseIf AllTrim( SZG->ZG_STATUS ) == "COPE"
				oOSStat:SetBmp( "BR_MARROM" )
			ElseIf AllTrim( SZG->ZG_STATUS ) == "CTEC"
			    oOSStat:SetBmp( "BR_CINZA" )
			ElseIf AllTrim( SZG->ZG_STATUS ) == "FIOK"
				oOSStat:SetBmp( "BR_VERDE" )
			EndIf
		EndIf
	EndIf
EndIf

cCor := STATICCALL( TTMONITOR, Status, SZG->ZG_NUMOS )

Return cCor


/*
Retorna o bitmap da cor da linha do grid
*/
Static Function IcStat( cOpcao )

Local oIcon := Nil
Default cOpcao := ""

If Empty(cOpcao)
	Return
EndIf

If cOpcao == "1"
	oIcon := oOk
ElseIf cOpcao == "2"
	oIcon := oProb
EndIf

Return oIcon


/*
Encerra o ciclo de abastecimentos
*/
Static Function FimC2( lPend )

Local lFim := .F.
Local cQuery := ""
Local cArm := ""


If !VldPerm(7)
	MsgAlert("Você não tem permissão para acessar esse recurso!")
	Return lFim
EndIf


If Empty(_cOsInvent)
	MsgAlert("É necessário contar o estoque através do inventário!")
	Return lFim
Else
	dbSelectArea("SZC")
	dbSetOrder(3)
	If !MsSeek( xFilial("SZC") +AvKey(_cOsInvent,"ZC_NUMOS") )
		MsgAlert("Necessário processar as contagens.")
		Return lFim
	EndIf
EndIf

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey( _cOsInvent,"ZG_NUMOS" ) )
	If dDatabase > SZG->ZG_DATAFIM
		MsgAlert("Atenção, o inventário está registrado com data anterior ( " +dtoc(SZG->ZG_DATAFIM) +"). Cancele o inventário ou entre com a data correta para o encerramento.")
		Return lFim
	EndIf
EndIf


If !MsgYesNo("Confirma a finalização da prestação de contas? Essa operação não poderá ser desfeita.")
	Return lFim
EndIf


// update dados na SZ7 - encerrado
cQuery := "UPDATE " +RetSqlName("SZ7")
cQuery += " SET Z7_RETORNO = '"+dtos(dDatabase)+"', Z7_STATUS = '3' "
cQuery += " WHERE Z7_ARMMOV = '"+_cRota+"' AND Z7_STATUS = '2' AND D_E_L_E_T_ = '' "
//cQuery += " AND Z7_SAIDA <= '"+DTOS(dDatabase)+"'  "


TCSQLExec(cQuery)


// UPDATE DADOS DA SZC - CONTAGENS PROCESSADAS
cQuery := "UPDATE " +RetSqlName("SZC")
cQuery += " SET ZC_PROC = 'S' "
cQuery += " WHERE ZC_LOCAL = '"+_cRota+"' AND ZC_DATA = '"+DTOS(dDatabase)+"' "
cQuery += " AND ZC_PROC = '' AND ZC_NUMOS = '"+_cOsInvent+"' "

TCSQLExec(cQuery)


// ajuste no SZ6
MsAguarde( { || AjustaSZ6( _cRota ) },"Aguarde, ajustando estoque..." )


// flag processado na OS
dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(_cOsInvent,"ZG_NUMOS") )
	Reclock("SZG",.F.)
	SZG->ZG_PROC := "BR_VERDE"
	SZG->ZG_HRPROC := IIF( date() == SZG->ZG_DATAFIM,Time(),"23:59:00" )
	MsUnlock()
EndIf


// DESBLOQUEIO ARMAZEM
dbSelectArea("ZZ1")
dbSetOrder(1)
// ROTA
If SubStr( _cRota,1,1 ) == "R"

	If MsSeek( xFilial("ZZ1") +AvKey( _cRota,"ZZ1_COD" ) )
		RecLock( "ZZ1",.F. )
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBLQ := ""
		MsUnlock()
	EndIf

// PA
Else
	cArm := "A" +SubStr( _cRota,2 )

	// desbloqueia o armazem P
	If MsSeek( xFilial("ZZ1") +AvKey( _cRota,"ZZ1_COD" ) )
		RecLock( "ZZ1",.F. )
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBLQ := ""
		MsUnlock()
	EndIf

	// desbloqueia o armazem A
	If MsSeek( xFilial("ZZ1") +AvKey( cArm,"ZZ1_COD" ) )
		RecLock( "ZZ1",.F. )
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBLQ := ""
		MsUnlock()
	EndIf

EndIf


MsgInfo("Fechamento realizado!")

lFim := .T.

Return lFim

/*
Ajuste dos saldos na tabela SZ6
*/
Static Function AjustaSZ6( _cRota )

Local cQuery := ""
Local cArmazem := ""
Local aInvent := {}
Local nI
Local nNovoSld := 0
Local nAjuste := 0
Local nQtdZ6 := 0

dbSelectArea("SZ6")
dbSetOrder(1)

If SubStr( _cRota,1,1 ) == "R"
	cArmazem := _cRota
	/*
	cQuery := "SELECT Z6_COD, Z6_QATU FROM " +RetSqlName("SZ6")
	cQuery += " WHERE Z6_FILIAL = '"+xFilial("SZ6")+"' "
	cQuery += " AND Z6_LOCAL = '"+cARmazem+"' "
	cQuery += " AND Z6_QATU > 0 "
	cQuery += " AND D_E_L_E_T_ = '' "

	If Select("TRB2") > 0
		TRB2->(dbCloseArea())
	EndIf

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB2',.F.,.T.)

	dbSelectArea("TRB2")
	While TRB2->(!EOF())

		AADD( aInvent, { TRB2->Z6_COD, TRB2->Z6_QATU } )

		TRB2->(dbSkip())
	End

	TRB2->(dbCloseArea())

	For nI := 1 To Len(aInvent)
		U_MntSZ5( _cRota,aInvent[nI][1],"515",dDatabase,aInvent[nI][2],"","","AJUSTE ESTOQUE - ENCERRAMENTO","TTPROC57","","",IIF( SubStr(_cRota,1,1) == "R",.T.,.F. ) )
	Next nI
	*/

	For nI := 1 To Len( _aLista1 )
		cProduto := _aLista1[nI][2]
		nQInv := _aLista1[nI][9]
		nQtdDev := _aLista1[nI][10]
		nNovoSld := ( nQInv - nQtdDev )

		dbSelectArea("SZ6")
		If MsSeek( xFilial("SZ6") +AvKey(cARmazem,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
			//RecLock( "SZ6",.F. )
			//SZ6->Z6_QATU := nNovoSld
			//MsUnLock()
			nQtdZ6 := SZ6->Z6_QATU

			If ( nNovoSld - nQtdZ6 ) < 0
				nAjuste := ABS( nNovoSld - nQtdZ6 )
				U_MntSZ5( cARmazem,cProduto,"515",dDatabase,nAjuste,"","","AJUSTE ESTOQUE - ENCERRAMENTO","TTPROC57","","",IIF( SubStr(_cRota,1,1) == "R",.T.,.F. ) )
			ElseIf ( nNovoSld - nQtdZ6 ) > 0
				nAjuste := ABS( nNovoSld - nQtdZ6 )
				U_MntSZ5( _cRota,cProduto,"015",dDatabase,nAjuste,"","","AJUSTE ESTOQUE - ENCERRAMENTO","TTPROC57","","",IIF( SubStr(_cRota,1,1) == "R",.T.,.F. ) )
			EndIf
		EndIf

	Next nI

ElseIf  SubStr( _cRota,1,1 ) == "P"
	cARmazem := "A" +SubStr( _cRota,2 )


	For nI := 1 To Len( _aLista1 )
		cProduto := _aLista1[nI][2]
		nQInv := _aLista1[nI][9]
		nQtdDev := _aLista1[nI][10]
		nNovoSld := ( nQInv - nQtdDev )

		dbSelectArea("SZ6")
		If MsSeek( xFilial("SZ6") +AvKey(cARmazem,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
			//RecLock( "SZ6",.F. )
			//SZ6->Z6_QATU := nNovoSld
			//MsUnLock()

			nQtdZ6 := SZ6->Z6_QATU

			If ( nNovoSld - nQtdZ6 ) < 0
				nAjuste := ABS( nNovoSld - nQtdZ6 )
				U_MntSZ5( cARmazem,cProduto,"515",dDatabase,nAjuste,"","","AJUSTE ESTOQUE - ENCERRAMENTO","TTPROC57","","",IIF( SubStr(_cRota,1,1) == "R",.T.,.F. ) )
			ElseIf ( nNovoSld - nQtdZ6 ) > 0
				nAjuste := ABS( nNovoSld - nQtdZ6 )
				U_MntSZ5( _cRota,cProduto,"015",dDatabase,nAjuste,"","","AJUSTE ESTOQUE - ENCERRAMENTO","TTPROC57","","",IIF( SubStr(_cRota,1,1) == "R",.T.,.F. ) )
			EndIf

		EndIf

	Next nI
EndIf

Return


// Ajuste no armazem
Static Function MovArm( cArmazem,aItens, cTm, cMsg )

Local nI

For nI := 1 To Len(aItens)
	U_MntSZ5( cArmazem,aItens[nI][1],cTm,dDatabase,aItens[nI][2],"","","AJUSTE ESTOQUE - FECHAMENTO -> " +cMsg,"TTPROC57","","",IIF( SubStr(cArmazem,1,1) == "R",.T.,.F. ) )
Next nI

Return


/*
Detalhe dos abastecimentos no periodo
*/
Static Function Detalhe( cProduto )

Local aArea := GetArea()
Local oWnd
Local oLayer	:= FwLayer():New()
Local aSize		:= MsAdvSize(Nil,.F.)
Local nWdtRdp	:= aSize[5]/2
Local aProd		:= {}
Default cProduto := ""

For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.9
Next nI


For nI := 1 To Len(_aAbast)
	If Empty(cProduto)
		AADD( aProd, _aAbast[nI] )
	Else
		If AllTrim(_aAbast[nI][1]) == AllTrim(cProduto)
			AADD( aProd, _aAbast[nI] )
		EndIf
	EndIf
Next nI

If Empty(aProd)
	MsgInfo("Não houve abastecimento.")
	Return
EndIf

oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )

	oLayer:Init(oWnd,.F.)

	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Abastecimentos",100,.F.,.T.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()


	oLstDet := TCBrowse():New(020,012,410,090,,,,oPnl,,,,{ || },{ || VerOS(aProd[oLstDet:nAt][6]) },,,,,,,.F.,,.T.,,.F.,,,)
	oLstDet:SetArray(aProd)

	oLstDet:AddColumn(TCColumn():New('Produto'			,{|| aProd[oLstDet:nAt][1] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Descrição'		,{|| aProd[oLstDet:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Quantidade'		,{|| aProd[oLstDet:nAt][3] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Local'			,{|| aProd[oLstDet:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Data'				,{|| aProd[oLstDet:nAt][5] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('OS Mobile'		,{|| aProd[oLstDet:nAt][6] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Patrimônio'		,{|| aProd[oLstDet:nAt][7] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Modelo'			,{|| aProd[oLstDet:nAt][8] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))

	oLstDet:Align := CONTROL_ALIGN_ALLCLIENT

	oLstDet:nScrollType := 1

oWnd:Activate(,,,.T.)

RestArea(aArea)

Return


/*
Visualizar a Ordem de Servico
*/
Static Function VerOS( cNumOS )

Private cCadastro := "Manutenção de Ordens de Serviço"

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xfilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	U_TTPROC32(2)
EndIf

Return


/*
Geracao dos pedidos de descarte e perda contra a PA
*/
Static Function PedDesc()

Local aArea			:= GetArea()
Local aItens		:= {}
Local aItens2		:= {}
Local cNumPed		:= ""
Local nPos			:= 0
Local aAux			:= {}
Local nPed			:= 0
Local nI			:= 0
Local nJ			:= 0
Local cMsg			:= ""
Local cNomeAtend	:= AllTrim( Posicione( "AA1",1,xFilial("AA1") +AvKey( _cTecAtend,"AA1_CODTEC" ),"AA1_NOMTEC"  ) )
Local cArmA			:= ""

If !VldPerm(6)
	MsgAlert("Você não tem permissão para acessar esse recurso!")
	Return
EndIf

// verificar se os pedidos de descarte esse periodo ja foram feitos
If _lPedOk
	MsgInfo( "Os pedidos já foram gerados." )
	Return
EndIf

If Empty(_cOsInvent)
	MsgAlert("Antes da geração dos pedidos, é preciso gerar a OS de inventário e processar as contagens.")
	Return
EndIf

dbSelectArea("SZC")
dbSetOrder(3)
If !MsSeek( xFilial("SZC") +AvKey(_cOsInvent,"ZC_NUMOS") )
	//If AllTrim( SZC->ZC_PROC ) <> "S"
		MsgAlert("Antes da geração dos pedidos, é preciso processar as contagens.")
		Return
	//EndIf
EndIf
//TabDocs()



If !Empty( _aDescarte )
	For nI := 1 To Len( _aDescarte )
		If AScan( aAux, { |x| x[1] == _aDescarte[nI][3] } ) == 0
			AADD( aAux, { _aDescarte[nI][3], {} } )
		EndIf
	Next nI

	For nI := 1 To Len( aAux )
		For nJ := 1 To Len( _aDescarte )
			If _aDescarte[nJ][3] == aAux[nI][1]
				AADD( aAux[nI][2], { _aDescarte[nJ][1], _aDescarte[nJ][2] } )
			EndIf
		Next nJ
	Next nI


	If !Empty(aAux)
		If Select("TRBD") == 0
			DbUseArea(.T., "TOPCONN", "INVDOCS", "TRBD", .T., .F.)
		EndIf
		DbSelectArea("TRBD")
	EndIf

	For nI := 1 To Len( aAux )
		aItens := aclone( aAux[nI][2] )
		cCodPa := aAux[nI][1]

		dbSelectArea("SB2")
		dbSetOrder(2)
		For nJ := 1 To Len( aItens )
			If !MSSeek( xFilial("SB2") +AvKey( cCodPa,"B2_LOCAL" ) +AvKey( aItens[nJ][1],"B2_COD" ) )
				CRIASB2( aItens[nJ][1],cCodPa )
			EndIf
		Next nJ


		cMsg := "Avaria de Maquina - Fechamento de Rota: "
		cMsg += " OS: "+_cOsInvent
		cMsg += " PA/Rota: " +_cRota +" Ref PA: " +cCodPa
		cMsg += " " +cNomeAtend
		cMsg += " " +cUsername


		LJMsgRun("Gerando pedido - " +cvaltochar(nI) +" de " +cvaltochar(Len(aAux)),"Aguarde...",{ || cNumPed := STATICCALL( TTPROC25, GeraPedido,"000001",Strzero(val(cFilAnt),4), cCodPa, "", aItens,cMsg )} )

		If !Empty(cNumPed)
			nPed++

			// grava na tabela de historico de pedidos gerados
			DbSelectArea("TRBD")
			RecLock("TRBD",.T.)
			TRBD->FILIAL	:= xFilial("SC5")
			TRBD->ARMAZEM	:= _cRota
			TRBD->OPERAD	:= cUserName
			TRBD->TIPODOC	:= "SC5" // pedido
			TRBD->NUMERO	:= cNumPed
			TRBD->DIA		:= dDatabase
			TRBD->HORA		:= Time()
			TRBD->OBS		:= "PEDIDO DE DESCARTE"
			MsUnLock()

		EndIf

	Next nI
EndIf

MsgInfo( "Pedidos gerados: " +cValToChar(nPed) )

_lPedOk := .T.
oBt4:Disable()

RestArea(aArea)

Return


/*
Gerar a OS de inventario
*/
Static Function GerarInv( dInicio,dFim,cHrInicio )

Local nI,nJ
Local cSerie := "2"
Local cCliFor := "000001"
Local cLoja := "0001"
Local cNumNF := ""
Local aRTNF := {"",""}
Local axLst := {}
Local cOSInvent := ""
Local cCodTec := ""
Local cMsg := ""
Local cMsgErro := ""
Local nTpInv := 2
Local nProc := 0
Local nPend := 0
Local aOS := {}
Local cQuery := ""
Local lSemAtend := .F.
Local cNome := ""
Local cMsg := ""
Local nOpc := 0


If !VldPerm(3)
	MsgAlert("Você não tem permissão para acessar esse recurso!")
	Return
EndIf


// verifica status
If !Empty( _cOsInvent )
	MsgAlert("Inventário já gerado!")
	Return
EndIf


// verifica se tem os pendente
OSPenD( _cRota,dInicio,dDatabase,@nProc,@nPend,@aOS, cHrInicio )
If nPend > 0
	For nI := 1 To Len(aOS)
		cMsg += aOS[nI][1] +" - " +aOS[nI][3]  +CRLF
	Next nI
	Aviso("TTPROC57","Essa Rota/PA ainda possui OS pendente de finalização:" +CRLF +cMsg,{"Ok"})
	Return
EndIf
If nProc > 0
	For nI := 1 To Len(aOS)
		cMsg += aOS[nI][1] +" - " +aOS[nI][3] +CRLF
	Next nI
	Aviso("TTPROC57","Essa Rota/PA ainda possui OS pendente de processamento:" +CRLF +cMsg,{"Ok"})
	Return
EndIf


// rota
If SubStr( _cRota,1,1 ) == "R"
	cCodTec := _cTecAtend

	If Empty(cCodTec)
		MsgAlert("Configure o atendente da Rota! - Cadastro de PA")
		Return
	EndIf

// pa
Else

	cCodTec := _cTecAtend
	cMsg := ""
	If Empty(cCodTec)
		cMsg := "PA sem atendente padrão configurado." +CRLF
		cMsg += "Escolha um atendente para receber a Ordem de Serviço de inventário."

		Aviso("TTPROC57",cMsg,{"Ok"})

		If ( ConPad1(,,,"AA1",,,.F.) )
			cCodTec := AA1->AA1_CODTEC
		EndIf

	Else
		cNome := Posicione( "AA1",1,xFilial("AA1") +AvKey(cCodTec,"AA1_CODTEC"), "AA1_NOMTEC" )
		cMsg := "Atendente padrão: " +cNome
		cMsg += "Deseja alterar o atendente?"

		nOpc := Aviso("TTPROC57",cMsg,{"Sim","Não"})
 		If nOpc == 1
			If ( ConPad1(,,,"AA1",,,.F.) )
				cCodTec := AA1->AA1_CODTEC
			Else
				MsgInfo("Geração de OS cancelada..")
				Return
			EndIf
		EndIf

	EndIf

EndIf


If Empty(cCodTec)
	MsgAlert("Escolha um atendente válido para realizar a contagem!")
	Return
EndIf


CursorWait()


// travar os movimentos de estoque
dbSelectArea("ZZ1")
dbSetOrder(1)
If SubStr( _cRota,1,1 ) == "R"
	If MsSeek( xFilial("ZZ1") +AvKey(_cRota,"ZZ1_COD") )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "1"
		ZZ1->ZZ1_XMOTBLQ := "CONTAGEM INVENTARIO - " +Dtoc(Date()) +" - " +cUserName
		//ZZ1->ZZ1_EMINV := "1" 	// em inventario
		MsUnLock()
	EndIf
Else
	cArmazem := "A" +SubStr( _cRota,2 )

	// bloqueia armazem P
	If MsSeek( xFilial("ZZ1") +AvKey(_cRota,"ZZ1_COD") )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "1"
		ZZ1->ZZ1_XMOTBLQ := "CONTAGEM INVENTARIO - " +Dtoc(Date()) +" - " +cUserName
		//ZZ1->ZZ1_EMINV := "1" 	// em inventario
		MsUnLock()
	EndIf

	// bloqueia armazem A
	If MsSeek( xFilial("ZZ1") +AvKey(cArmazem,"ZZ1_COD") )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "1"
		ZZ1->ZZ1_XMOTBLQ := "CONTAGEM INVENTARIO - " +Dtoc(Date()) +" - " +cUserName
		//ZZ1->ZZ1_EMINV := "1" 	// em inventario
		MsUnLock()
	EndIf
EndIf


// gera a OS de inventario
MsAguarde({ || cOsInvent := U_TTPROC42( _cRota,cCliFor,cLoja,cCodTec,dInicio,dFim,_cHrIniCC ) },"Gerando os de inventário..." )

If !Empty( cOsInvent )

	_cOsInvent := cOsInvent

	// update dados na SZ7 - em prestacao de contas
	cQuery := "UPDATE " +RetSqlName("SZ7")
	cQuery += " SET Z7_OSCNFRT = '"+cOsInvent+"', Z7_STATUS = '2' "
	cQuery += " WHERE Z7_ARMMOV = '"+_cRota+"' AND Z7_STATUS = '1' AND D_E_L_E_T_ = '' "

	TCSQLExec(cQuery)


	MsgInfo( "OS de inventário gerada: " +cOsInvent )
EndIf

/*
O bloqueio de entrada de mercadoria fica na rotina de registro de saida - TTFATC30.PRW
O bloqueio de envio de OS de abastecimento e entrega fica na rotina TTPROC30.PRW
*/


CursorArrow()

Return


/*
Gerar a NF de devolucao
*/
Static Function NFDEV()

Local oWnd
Local oLstDet
Local cOsInvent := ""
Local cNumNF := ""
Local cSerie := "2"
Local aItens := {}
Local aItensRuim := {}
Local aExced := {}
Local aTotFica := {}
Local cProduto := ""
Local nQtdDev := 0
Local axLst := {}
Local nI,nJ
Local nCnt := 0
Local nSobra := 0
Local aaXX := {}
Local nPos := 0
Local nSaldo := 0
Local nRet := 0
Local nFalta := 0
Local aItensRuim := {}
Local cMsgNF := ""
Local cNomeAtend := AllTrim( Posicione( "AA1",1,xFilial("AA1") +AvKey( _cTecAtend,"AA1_CODTEC" ),"AA1_NOMTEC"  ) )
Local lDevolver := .F.
Local cArmA := ""
Local nQtd := 0
Local aItensDev := {}
Local lDevParc := .F.
Local aDevolver := {}
Local nQtd := 0


If !VldPerm(4)
	MsgAlert("Você não tem permissão para acessar esse recurso!")
	Return
EndIf

// verifica status
If Empty( _cOSInvent )
	MsgAlert("Primeiro inicie a prestação de contas!")
	Return
EndIf


If !Empty(_cNfDev) .And. !Empty(_cSerDv)
	MsgInfo( "A nota de devolução já foi criada!" +CRLF +_cNfDev + "/" +_cSerDv )
Else
	dbSelectArea("SZG")
	dbSetOrder(1)
	If dbSeek( xFilial("SZG") +AvKey( _cOsInvent,"ZG_NUMOS" ) )
		If AllTrim(SZG->ZG_STATUS) <> "FIOK"
			MsgInfo("A conferência ainda não foi finalizada.")
		Else
			ItensInv( _cOsInvent,@aItens,@aItensRuim, @aExced, @aTotFica)
		EndIf
	EndIf

	If Empty( aItens )
		MsgAlert("Processe as contagens do inventário.")
		Return
	EndIf
EndIf


For nI := 1  To Len( aExced )
	If aExced[nI][2] > 0
		lDevolver := .T.
		Exit
	EndIf
Next nI

If !lDevolver
	MsgInfo( "Não há mercadoria apontada para devolução." )
	Return
EndIf

CursorWait()


For nI := 1  To Len( aExced )
	If aExced[nI][2] > 0
		AADD( aDevolver,{ aExced[nI][1],aExced[nI][2] } )
	EndIf
Next nI


// ajustar as quantidades das notas
If FindFunction( "U_TTOPER19" )
	U_TTOPER19( _cRota, aDevolver,@axLst )
EndIf

If !Empty(axLst)
    For nI := 1 To Len(aDevolver)
    	For nJ := 1 To Len(axLst)
    		If axLst[nI][1] == aDevolver[nI][1]
    			nQtd += aDevolver[nI][2]
    		EndIf
    	Next nJ
    	If nQtd < aDevolver[nI][2]
			MsgAlert("Há produto(s) com saldo inferior em relação ao apontado na devolução." +CRLF ;
					 +"A quantidade a ser devolvida será menor, conforme histórico de entregas.")

			U_TTOPER20(axLst)	// mostra tela com produtos

    		Exit
    	EndIf
    Next nI

	cMsgNF := "Fechamento"
	cMsgNF += " Invent.: " +cOsInvent
	cMsgNF += " Rota/PA: " +_cRota
	cMsgNF += " Atendente: " +cNomeAtend
	cMsgNF += " Usuário: " +cUserName


	MsAguarde( { || cNumNF := U_TTMT140(axLst,cMsgNF) },"Gerando nota de devolução.." )

	If !Empty(cNumNF)

		// update dados na SZ7 - em prestacao de contas
		cQuery := "UPDATE " +RetSqlName("SZ7")
		cQuery += " SET Z7_DOCRET = '"+cNumNF+"', Z7_SERIRET = '2' "
		cQuery += " WHERE Z7_ARMMOV = '"+_cRota+"' AND Z7_STATUS = '2' AND D_E_L_E_T_ = '' "

		TCSQLExec(cQuery)

		// grava na tabela de historico de pedidos gerados
		If Select("TRBD") == 0
			DbUseArea(.T., "TOPCONN", "INVDOCS", "TRBD", .T., .F.)
		EndIf
		DbSelectArea("TRBD")

		RecLock("TRBD",.T.)
		TRBD->FILIAL	:= xFilial("SC5")
		TRBD->ARMAZEM	:= _cRota
		TRBD->OPERAD	:= cUserName
		TRBD->TIPODOC	:= "SF1" // pedido
		TRBD->NUMERO	:= cNumNF
		TRBD->DIA		:= dDatabase
		TRBD->HORA		:= Time()
		TRBD->OBS		:= "NOTA DEVOLUCAO"
		MsUnLock()


		// baixa do armazem A/R
		If SubStr(_cRota,1,1) == "R"
			MovArm( _cRota,axLst, "515", "NF DEVOLUCAO" )		// R
		Else
			cArmA := "A" +SubStr( _cRota,2 )
			MovArm( cArmA,axLst, "515", "NF DEVOLUCAO" )		// A
			MovArm( _cRota,axLst, "515", "NF DEVOLUCAO" )		// P
		EndIf



		_lNFDev := .T.
		_cNfDev := cNumNF
		_cSerDv := "2"

		// itens da devolucao para mostrar no grid - 25/07
		ChkNfDv( _cRota,_dIniCiclo,_cHrIniCC,dDatabase, _cNfDev,_cSerDv,@aItensDev )
		_aItensDev := aClone( aItensDev )

		// desabilita botao da NF
		oBtNF:Disable()

		MsgInfo( "Nota de devolução gerada: " +cNumNF )
	EndIf
EndIf

CursorArrow()

Processa( { || RefAtu( _dIniCiclo ) },"Recarregando dados, aguarde..")


Return



/*
Retorna os produtos do Armazem - SZ6
*/
Static Function fProdsArm( cArmazem,aProds )

Local cQuery := ""
Local aSec := { "001","005","007", "008", "010", "013","014", "015" ,"016", "017","036" } 	// CAFE + SNACKS
Local nI

If SubStr( cArmazem,1,1 ) == "P"
	cArmazem := "A" +SubStr( cArmazem,2 )
EndIf

// produtos SZ6 - CONSULTA PRIMARIA PARA MONTAR O GRID
cQuery := "SELECT Z6_COD, B1_DESC FROM " +RetSqlName("SZ6") + " Z6 "
cQuery += " INNER JOIN " +RetSqlName("SB1") + " B1 ON Z6_COD = B1_COD AND B1.D_E_L_E_T_ = '' "
cQuery += " WHERE Z6_LOCAL = '"+cArmazem+"' AND Z6.D_E_L_E_T_ = '' "

cQuery += " AND B1_XMIXENT = '1' "

cQuery += " AND B1_XSECAO IN ( "
For nI := 1 To Len(aSec)
	cQuery += "'" +aSec[nI] + "'"
	If nI <> Len(aSec)
		cQuery += ","
	EndIf
Next nI
cQuery += " ) "


cQuery += " ORDER BY B1_XSECAO, B1_XFAMILI, B1_GRUPO "	// ORDENADO POR SECAO LINHA CATEGORIA

MpSysOpenQuery( cQuery, "TRB" )

dbSelectArea("TRB")
While !EOF()
	AADD( aProds, { AllTrim( TRB->Z6_COD ), AllTrim( TRB->B1_DESC )  } )
	dbSkip()
End

TRB->( dbCloseArea() )


Return



/*
Notas fiscais geradas para o armazem da Rota/PA
*/
Static Function ProdNf(cRota)

Local cQuery := ""
Local oBranco := LoadBitMap( GetResources(), "BR_BRANCO" )
Local oVerde := LoadBitMap( GetResources(), "BR_VERDE" )
Local oStatus := oBranco


// nova consulta - mercadorias rota
cQuery := "SELECT Z7_DOC, Z7_SERIE, Z7_EMISSAO, Z7_SAIDA, Z7_ITEM, Z7_COD, Z7_OSCNFRT, Z7_DOCRET, Z7_SERIRET, Z7_NFREUSO,Z7_QATU, "
cQuery += " B1_DESC, Z7_QUANT, Z7_ARMORI, D2_PRCVEN, D2_TES, SF2.R_E_C_N_O_ F2REC, D2_PRCVEN,D2_TES, "
cQuery += " SZ7.R_E_C_N_O_ Z7REC, Z7_STATUS "

cQuery += " FROM " +RetSqlName("SZ7") +" SZ7 "

cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
cQuery += " B1_COD = Z7_COD "
cQuery += " AND SB1.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN " +RetSqlName("SF2") +" SF2 ON "
cQuery += " F2_FILIAL = Z7_FILIAL "
cQuery += " AND F2_DOC = Z7_DOC "
cQuery += " AND F2_SERIE = Z7_SERIE "
cQuery += " AND F2_CLIENTE = Z7_CLIENTE "
cQuery += " AND F2_LOJA = Z7_LOJA "
cQuery += " AND SF2.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN " +RetSqlName("SD2") +" SD2 ON "
cQuery += " D2_FILIAL = Z7_FILIAL "
cQuery += " AND D2_DOC = Z7_DOC "
cQuery += " AND D2_SERIE = Z7_SERIE "
cQuery += " AND D2_ITEM = Z7_ITEM "
cQuery += " AND D2_COD = Z7_COD "
cQuery += " AND SD2.D_E_L_E_T_ = '' "

cQuery += " WHERE "
cQuery += " Z7_ARMMOV = '"+cRota+"' "
cQuery += " AND Z7_STATUS IN ('1','2') "	// em aberto | em fechamento
cQuery += " AND Z7_RETORNO = '' "
cQuery += " AND Z7_SAIDA <= '"+dtos(dDatabase)+"' "
cQuery += " AND SZ7.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

DbSelectArea("TRB")

While !EOF()
	oStatus := oBranco
	If !Empty(TRB->Z7_OSCNFRT)
		dbSelectArea("SZG")
		dbSetOrder(1)
		If MsSeek( xFilial("SZG") +AvKey(TRB->Z7_OSCNFRT,"ZG_NUMOS") )
			If AllTrim(SZG->ZG_STATUS) == "FIOK"
				oSTatus := oVerde
			EndIf
		EndIf
	EndIf

	DbSelectArea("TRB")

	AADD( _aDocIt, { TRB->Z7_DOC,;
					TRB->Z7_SERIE,;
					STOD(TRB->Z7_EMISSAO),;
					TRB->Z7_COD,;
					TRB->B1_DESC,;
					TRB->Z7_ITEM,;
					TRB->Z7_QUANT,;
					TRB->Z7_SAIDA,;
					TRB->Z7_ARMORI,;
					TRB->D2_PRCVEN,;
					TRB->D2_TES,;
					TRB->Z7REC,;
					TRB->F2REC,;
					TRB->Z7_STATUS,;
					TRB->Z7_OSCNFRT,;
					TRB->Z7_DOCRET,;
					TRB->Z7_SERIRET,;
					oStatus,;
					TRB->Z7_NFREUSO,;
					TRB->Z7_QATU } )
	dbskip()
EndDo

TRB->( dbCloseArea() )


Return



/*
Retorna as quantidades do Inventario
*/
Static Function ItensInv( cOSConf,aConfBom,aConfRuim,aExced,aTotFica )

Local aDados := {}
Local nPosA := 0
Local axItens := {}
Local aItens := {}
Local aItensDs := {}
Local cMsgErro := ""
Local nI

// pegar tabela SZC
dbSelectArea( "SZC" )
dBSetOrder( 3 )
If !MSSeek( xFilial("SZC") +AvKey( cOSConf,"ZC_NUMOS" ) )
	//MsgAlert( "Ordem de serviço de inventário pode não ter sido processada. Verifique." )
	Return
EndIf

// pega os produtos contados
While SZC->ZC_FILIAL == xFilial("SZC") .And. AllTrim(SZC->ZC_NUMOS) == AllTrim(cOSConf) .And. SZC->( !EOF() )

	// Produtos Bons
	If AllTrim( SZC->ZC_TIPO ) == "1"
		AADD( aConfBom, { AllTrim(SZC->ZC_COD),SZC->ZC_QTD } )
	// Produtos Ruins - Descartes
	ElseIf AllTrim( SZC->ZC_TIPO ) == "2"
		AADD( aConfRuim, { AllTrim(SZC->ZC_COD),SZC->ZC_QTD } )

	// Produtos Excedentes - devolucao
	ElseIf AllTrim( SZC->ZC_TIPO ) == "3"
		AADD( aExced, { AllTrim(SZC->ZC_COD), SZC->ZC_QTD } )

	// Produtos que ficam no estoque
	ElseIf AllTrim( SZC->ZC_TIPO ) == "4"
		AADD( aTotFica, { AllTrim(SZC->ZC_COD), SZC->ZC_QTD } )

	EndIf

	SZC->( dbSkip() )
End

Return


/*
Retorna as contagens do inventario anterior
*/
Static Function SldAntZC( cArmazem,dInicio, aQtdSldAnt,cHrInicio )

Local cQuery := ""
Local cOsAnt := ""

cQuery := "SELECT TOP 1 ZG_NUMOS,ZG_DATAFIM FROM " +RetSqlName("SZG")
cQuery += " WHERE ( ZG_ROTA = '"+cArmazem+"' OR ZG_PA = '"+cArmazem+"' )  AND D_E_L_E_T_ = '' "
cQuery += " AND ZG_STATUS = 'FIOK' AND ZG_FORM = '21' "
//cQuery += " AND ZG_DATAFIM < '"+DTOS(dInicio)+"' "

cQuery += " AND "
cQuery += " ( ZG_DATAFIM < '"+DTOS(dInicio)+"' "
cQuery += " OR "
cQuery += " ( ZG_DATAFIM = '"+DTOS(dInicio)+"' AND ZG_HORAFIM < '"+cHrInicio+"' ) "
cQuery += " ) "

//cQuery += " ORDER BY ZG_DATAFIM DESC "
cQuery += " ORDER BY R_E_C_N_O_ DESC "

MpSysOpenQuery( cQuery,"TRBZ" )

dbSelectArea("TRBZ")
cOsAnt := TRBZ->ZG_NUMOS
TRBZ->(dbCloseArea())

If Empty(cOsAnt)
	Return
EndIf

dbSelectArea("ZZ1")
dbSetOrder(1)
MsSeek( xFilial("ZZ1") +AvKey(_cRota,"ZZ1_COD") )


dbSelectArea( "SZC" )
dBSetOrder( 3 )
If MSSeek( xFilial("SZC") +AvKey( cOsAnt,"ZC_NUMOS" ) )

	// pega os produtos contados
	While SZC->ZC_FILIAL == xFilial("SZC") .And. AllTrim(SZC->ZC_NUMOS) == AllTrim(cOsAnt) .And. SZC->( !EOF() )

		// Provisorio
		If !ZZ1->ZZ1_DEVCAR

			If AllTrim( SZC->ZC_TIPO ) == "1"
				AADD( aQtdSldAnt, { AllTrim(SZC->ZC_COD), SZC->ZC_QTD } )
			EndIf

		Else
			// QUANTIDADE CONTADA QUE FICA NO ESTOQUE
			If AllTrim( SZC->ZC_TIPO ) == "4"	//"4"
				AADD( aQtdSldAnt, { AllTrim(SZC->ZC_COD), SZC->ZC_QTD } )
			EndIf
		EndIf

		SZC->( dbSkip() )
	End

EndIf


Return


/*
Retorna a movimentacao do periodo - SZ5
*/
Static Function MovSZ5( cArmazem,dDtIni,dDtFim,aCarga,aAbast,aRetir,aDescarte,cHrInicio  )

Local cQuery := ""
Local cQuery1 := ""
Local cQuery2 := ""
Local cQuery3 := ""
Local nPos := 0
Local cArmA := ""
Local nXTOT := 0
Local aAux := {}

// carga
If SubStr( cArmazem,1,1 ) == "P"
	cArmA := "A" +SubStr(cArmazem,2)
EndIf

cQuery1 := "SELECT Z5_COD, SUM(Z5_QUANT) TOTAL FROM " +REtSqlName("SZ5")
cQuery1 += " WHERE "

// rota
If SubStr( cArmazem,1,1 ) == "R"
	cQuery1 += " Z5_LOCAL = '"+cArmazem+"' "
// pa
Else
	cQuery1 += " Z5_LOCAL = '"+cArmA+"' "
EndIf

cQuery1 += " AND Z5_TM = '100' "
//cQuery1 += " AND Z5_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"' "
// considerar data e hora
cQuery1 += " AND ( "
cQuery1 += 			" ( Z5_EMISSAO = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
cQuery1 += 			" OR "
cQuery1 += 			"( Z5_EMISSAO BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
cQuery1 += " ) "

cQuery1 += " AND Z5_ORIGEM = 'TTFAT18C' AND Z5_OBS LIKE '%ENTRADA%' "
cQuery1 += " AND D_E_L_E_T_ = '' "
cQuery1 += " GROUP BY Z5_COD "

MpSysOpenQuery( cQuery1,"TRBC" )

dbSelectArea("TRBC")
While !EOF()

	AADD( aCarga, { TRBC->Z5_COD, TRBC->TOTAL } )

	nXTOT += TRBC->TOTAL

	dbSkip()
End
TRBC->( dbCloseArea() )

//msgInfo( "Total saida: " +cvaltochar(nXTot) )


// ABASTECIDO
// ROTA
If SubStr( cARmazem,1,1 ) == "R"
	/*cQuery := "SELECT Z5_LOCAL,Z5_COD, B1_DESC, Z5_QUANT, Z5_EMISSAO, Z5_NUMOS, Z5_CHAPA,N1_DESCRIC, SZ5.R_E_C_N_O_ Z5REC FROM " +RetSqlName("SZ5") +" SZ5 "
	cQuery += " INNER JOIN " +RetSqlName("SZG") +" ON "
	cQuery += " ZG_NUMOS = Z5_NUMOS "
	cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
	cQuery += " B1_COD = Z5_COD AND SB1.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " +RetSqlName("SN1") +" SN1 ON "
	cQuery += " N1_CHAPA = Z5_CHAPA AND SN1.D_E_L_E_T_ = '' "
	cQuery += " WHERE "
	cQuery += " ZG_ROTA = '"+cArmazem+"' AND ZG_STATUS = 'FIOK' AND ZG_PROC <> '' "
	cQuery += " AND SUBSTRING(Z5_LOCAL,1,1) = 'P' "
	cQuery += " AND Z5_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'  "
	cQuery += " AND Z5_TM = '100' AND SZ5.D_E_L_E_T_ = '' "*/

	cQuery := "SELECT Z5_LOCAL,Z5_COD, B1_DESC, Z5_QUANT, Z5_EMISSAO, Z5_NUMOS, Z5_CHAPA,N1_DESCRIC, SZ5.R_E_C_N_O_ Z5REC FROM " +RetSqlName("SZ5") +" SZ5 "

	cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
	cQuery += " B1_COD = Z5_COD AND SB1.D_E_L_E_T_ = '' "

	cQuery += " LEFT JOIN " +RetSqlName("SN1") +" SN1 ON "
	cQuery += " N1_CHAPA = Z5_CHAPA AND SN1.D_E_L_E_T_ = '' "

	cQuery += " WHERE "
	cQuery += " Z5_LOCAL = '"+cArmazem+"' "
	//cQuery += " AND Z5_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'  "

	// considerar data e hora
	cQuery += " AND ( "
	cQuery += 			" ( Z5_EMISSAO = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery += 			" OR "
	cQuery += 			"( Z5_EMISSAO BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
	cQuery += " ) "

	cQuery += " AND Z5_TIPO = 'A' "
	cQuery += " AND Z5_TM = '600' AND SZ5.D_E_L_E_T_ = '' "
Else

	cArmA := "A" +SubStr( cArmazem,2 )

	cQuery := "SELECT Z5_LOCAL,Z5_COD, B1_DESC, Z5_QUANT, Z5_EMISSAO, Z5_NUMOS, Z5_CHAPA,N1_DESCRIC, SZ5.R_E_C_N_O_ Z5REC FROM " +RetSqlName("SZ5") +" SZ5 "

	cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
	cQuery += " B1_COD = Z5_COD AND SB1.D_E_L_E_T_ = '' "

	cQuery += " LEFT JOIN " +RetSqlName("SN1") +" SN1 ON "
	cQuery += " N1_CHAPA = Z5_CHAPA AND SN1.D_E_L_E_T_ = '' "

	cQuery += " WHERE "

	cQuery += " Z5_LOCAL = '"+cArmA+"' "
	//cQuery += " AND Z5_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'  "

	// considerar data e hora
	cQuery += " AND ( "
	cQuery += 			" ( Z5_EMISSAO = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery += 			" OR "
	cQuery += 			"( Z5_EMISSAO BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
	cQuery += " ) "

	cQuery += " AND Z5_TIPO = 'A' "
	cQuery += " AND Z5_TM = '600' AND SZ5.D_E_L_E_T_ = '' "

EndIf

If Select("TRB3") > 0
	TRB3->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB3"

dbSelectArea("TRB3")

While !EOF()
	AADD( aAbast, { TRB3->Z5_COD, TRB3->B1_DESC, TRB3->Z5_QUANT, TRB3->Z5_LOCAL, STOD(TRB3->Z5_EMISSAO), TRB3->Z5_NUMOS, TRB3->Z5_CHAPA, TRB3->N1_DESCRIC, TRB3->Z5REC, "" } )
	dbSkip()
End

TRB3->(dbCloseArea())




// retirados
If SubStr(cArmazem,1,1) == "R"
	cQuery3 := "SELECT Z5_COD, SUM(Z5_QUANT) TOTAL FROM " +RetSqlNAme("SZ5")  +" SZ5 WITH (NOLOCK) "
	cQuery3 += " WHERE Z5_LOCAL = '"+cArmazem+"' "

	//cQuery3 += " AND Z5_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"' "

	// considerar data e hora
	cQuery3 += " AND ( "
	cQuery3 += 			" ( Z5_EMISSAO = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery3 += 			" OR "
	cQuery3 += 			"( Z5_EMISSAO BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
	cQuery3 += " ) "

	cQuery3 += " AND Z5_TM = '100' AND Z5_TIPO = 'R' AND SZ5.D_E_L_E_T_ = ''  "
	cQuery3 += " GROUP BY Z5_COD "

	MpSysOpenQuery( cQuery3, "TRB" )
	dbSelectArea("TRB")
	While !EOF()
		AADD( aRetir, { TRB->Z5_COD, TRB->TOTAL } )
		dbSkip()
	End
	TRB->(dbCloseArea())
Else

	cArmA := "A" +SubStr( cArmazem,2 )

	cQuery3 := "SELECT Z5_COD, SUM(Z5_QUANT) TOTAL FROM " +RetSqlNAme("SZ5")  +" SZ5 WITH (NOLOCK) "
	cQuery3 += " WHERE Z5_LOCAL = '"+cArmA+"' "

	//cQuery3 += " AND Z5_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"' "
	// considerar data e hora
	cQuery3 += " AND ( "
	cQuery3 += 			" ( Z5_EMISSAO = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery3 += 			" OR "
	cQuery3 += 			"( Z5_EMISSAO BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
	cQuery3 += " ) "

	cQuery3 += " AND Z5_TM = '100' AND Z5_TIPO = 'R' AND SZ5.D_E_L_E_T_ = ''  "
	cQuery3 += " GROUP BY Z5_COD "

	MpSysOpenQuery( cQuery3, "TRB" )
	dbSelectArea("TRB")
	While !EOF()
		AADD( aRetir, { TRB->Z5_COD, TRB->TOTAL } )
		dbSkip()
	End
	TRB->(dbCloseArea())
EndIf

// descarte do periodo
// gravar o detalhamento dos descartes
// rota
If SubStr(cArmazem,1,1) == "R"
	cQuery2 := "SELECT Z5_COD, Z5_QUANT, Z5_LOCAL FROM " +RetSqlName("SZ5")
	cQuery2 += " WHERE "	//Z5_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "
	cQuery2 += " Z5_NUMOS IN (
	cQuery2 += 					" SELECT ZG_NUMOS FROM " +RetSqlName("SZG")
	cQuery2 += 						" WHERE ZG_ROTA = '"+cArmazem+"' AND ZG_FORM IN ('04','08') "//AND ZG_DATAFIM BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "

	// considerar data e hora
	cQuery2 += 							" AND ( "
	cQuery2 += 								" ( ZG_DATAFIM = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery2 += 								" OR "
	cQuery2 += 								"( ZG_DATAFIM BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
	cQuery2 += 							" ) "

	cQuery2 += " ) "
	cQuery2 += " AND Z5_TIPO = 'D' "
	cQuery2 += " AND Z5_TM = '600' "
	cQuery2 += " AND D_E_L_E_T_ = '' "
	cQuery2 += " AND SUBSTRING( Z5_LOCAL,1,1 ) = 'P' "	// PEGAR O QUE FOI APONTADO COMO DESCARTE, SAIDA DA PA


	MpSysOpenQuery( cQuery2, "TRB" )
	dbSelectArea("TRB")
	While !EOF()

		nPos :=  AScan( aAux, { |x| x[1] == TRB->Z5_COD .And. x[3] == TRB->Z5_LOCAL } )
		If nPos == 0
			AADD( aDescarte, { TRB->Z5_COD, TRB->Z5_QUANT, TRB->Z5_LOCAL } )
		Else
			aDescarte[nPos][2] += TRB->Z5_QUANT
		EndIf

		dbSkip()

	End

	TRB->(dbCloseArea())
Else
	cArmA := "A" +SubStr( cArmazem,2 )

	cQuery2 := "SELECT Z5_COD, SUM(Z5_QUANT) TOTAL FROM " +RetSqlName("SZ5")
	//cQuery2 += " WHERE Z5_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "

	// considerar data e hora
	cQuery2 += " WHERE ( "
	cQuery2 += 			" ( Z5_EMISSAO = '"+dtos(dDtIni)+"' AND Z5_HORA > '"+cHrInicio+"' ) "
	cQuery2 += 			" OR "
	cQuery2 += 			"( Z5_EMISSAO BETWEEN '"+dtos(dDtIni+1)+"' AND  '"+dtos(dDtFim)+"' ) "
	cQuery2 += 			" ) "

	cQuery2 += " AND Z5_TIPO = 'D' "
	cQuery2 += " AND D_E_L_E_T_ = '' "
	cQuery2 += " AND Z5_LOCAL = '"+cArmA+"' "
	cQuery2 += " GROUP BY Z5_COD "

	MpSysOpenQuery( cQuery2, "TRB" )
	dbSelectArea("TRB")
	While !EOF()

		AADD( aDescarte, { TRB->Z5_COD, TRB->TOTAL, cArmazem } )

		dbSkip()

	End
	TRB->(dbCloseArea())
EndIf

Return


/*
Verifica as OS pendentes de finalizacao/processamento
*/
Static Function OSPenD( cArmazem,dDtIni,ddata,nProc,nPend,aOS,cHrInicio )

Local cQuery := ""

If SubStr( cArmazem,1,1 ) == "R"
	cQuery := "SELECT ZG_NUMOS,ZG_STATUS,ZG_PROC,ZG_FORM,ZG_DESCFRM,ZG_DATAINI FROM " +RetSqlName("SZG")
	cQuery += " WHERE ZG_FILIAL = '"+xFilial("SZG")+"' AND ZG_ROTA = '"+cArmazem+"' "
	//cQuery += " AND ZG_DATAINI BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(ddata)+"' AND  ZG_FORM IN ('04','08') AND D_E_L_E_T_ = '' "
	cQuery += " AND  ZG_FORM IN ('04','08') AND D_E_L_E_T_ = '' "
	cQuery += " AND ZG_STATUS NOT IN ('CTEC','COPE','CCLI') "

	cQuery += " AND ( "
	cQuery += 			" ( ZG_DATAINI = '"+DTOS(dDtIni)+"' AND ZG_HORAINI > '"+cHrInicio+"' ) "
	cQuery += 		" OR "
	cQuery += 			" ( ZG_DATAINI BETWEEN '"+DTOS(dDtIni+1)+"' AND '"+DTOS(ddata)+"' ) "
	cQuery += 		" ) "

Else
	cQuery := "SELECT ZG_NUMOS,ZG_STATUS,ZG_PROC, ZG_FORM,ZG_DESCFRM, ZG_DATAINI FROM " +RetSqlName("SZG") +" SZG "
	//cQuery += "INNER JOIN " +RetSqlName("SN1") + " SN1 ON N1_CHAPA = ZG_PATRIM AND SN1.D_E_L_E_T_ = '' "
	cQuery += " WHERE ZG_FILIAL = '"+xFilial("SZG")+"'
	//cQuery += " AND ZG_DATAINI BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(ddata)+"' AND  ZG_FORM IN ('04','08','13') AND SZG.D_E_L_E_T_ = '' "
	cQuery += " AND ZG_FORM IN ('04','08','13') AND SZG.D_E_L_E_T_ = '' "
	cQuery += " AND ZG_STATUS NOT IN ('CTEC','COPE','CCLI') "
	//cQuery += " AND N1_XPA = '"+cArmazem+"' "
	cQuery += " AND ( ZG_PA = '"+cArmazem+"' OR ZG_ROTA = '"+cARmazem+"' ) "
	/*
	cQuery += " AND ( "
	cQuery += 			" ( ZG_DATAINI = '"+DTOS(dDtIni)+"' AND ZG_HORAINI > '"+cHrInicio+"' ) "
	cQuery += 		" OR "
	cQuery += 			" ( ZG_DATAINI BETWEEN '"+DTOS(dDtIni+1)+"' AND '"+DTOS(ddata)+"' ) "
	cQuery += 		" ) "
	*/
	cQuery += " AND ( "
	cQuery += 			" ( ZG_DATAINI < '"+DTOS(dDtIni)+"' ) "
	cQuery += 		" OR "
	cQuery += 			" ( ZG_DATAINI = '"+DTOS(dDtIni)+"' AND ZG_HORAINI > '"+cHrInicio+"' ) "
	cQuery += 		" OR "
	cQuery += 			" ( ZG_DATAINI BETWEEN '"+DTOS(dDtIni+1)+"' AND '"+DTOS(ddata)+"' ) "
	cQuery += 		" ) "
EndIf

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBZ"

dbSelectArea("TRBZ")
While !EOF()
	If AllTrim(TRBZ->ZG_STATUS) <> "FIOK"

		If TRBZ->ZG_FORM == "13"
			If STOD(TRBZ->ZG_DATAINI) <= dDatabase
				nPend++
				AADD( aOS, { TRBZ->ZG_NUMOS, TRBZ->ZG_FORM, AllTrim(TRBZ->ZG_DESCFRM) } )
			EndIf
		Else
			nPend++
			AADD( aOS, { TRBZ->ZG_NUMOS,TRBZ->ZG_FORM, AllTrim(TRBZ->ZG_DESCFRM) } )
		EndIf

	EndIf

	If AllTrim(TRBZ->ZG_STATUS) == "FIOK" .And. Empty(TRBZ->ZG_PROC)
		nProc++
		AADD( aOS, { TRBZ->ZG_NUMOS,TRBZ->ZG_FORM, AllTrim(TRBZ->ZG_DESCFRM) } )
	EndIf

	dbSelectArea("TRBZ")
	TRBZ->(dbSkip())
End

TRBZ->(dbCloseArea())

Return


/*
Cancela o inventario
*/
Static Function CANCINV()

Local cOsInv := ""
Local nI
Local cArmazem := ""
Local cRotaExec := "" 		// INCLUIDO POR RONALDO G. DE JESUS - 17/10/2018
Local dAgend := dDatabase	// INCLUIDO POR RONALDO G. DE JESUS - 17/10/2018


If Empty( _cOsInvent )
	MsgInfo("Não gerou a OS de inventário.")
	Return
EndIf

If !MsgYesNo("Deseja cancelar o inventário?")
	Return
EndIf


If !MsgYesNo("Tem certeza que deseja cancelar o inventário?")
	Return
EndIf

dbSelectArea("SZG")
dbSetOrder(1)
If MSSeek( xFilial("SZG") +AvKey( _cOsInvent,"ZG_NUMOS") )
	If AllTrim(SZG->ZG_STATUS) <> "FIOK"
		cRotaExec := SZG->ZG_ROTA // INCLUIDO POR RONALDO G. DE JESUS - 17/10/2018
		dAgend := SZG->ZG_DATAINI // INCLUIDO POR RONALDO G. DE JESUS - 17/10/2018
		STATICCALL( TTPROC30, ProcCanc, _cOsInvent,_cOsInvent,cRotaExec,cRotaExec,dAgend,dAgend,1,"CANCELADO VIA CENTRAL" )	// CORRIGIDO POR RONALDO G. DE JESUS - 17/10/2018
	ElseIf AllTrim(SZG->ZG_STATUS) == "FIOK"
		RecLock("SZG",.F.)
		SZG->ZG_STATUS := "COPE"
		SZG->ZG_STATUSD := "Cancelado pelo Atendente"
		SZG->ZG_DTCANC := Date()
		SZG->ZG_HRCANC := Time()
		SZG->ZG_OBSCANC := "CANCELADO VIA CENTRAL"
		MsUnLock()
	EndIf

	If AllTrim(SZG->ZG_STATUS) == "COPE"
		// APAGA NA SZ7
		dbSelectArea("SZ7")
		For nI := 1 To Len(_aDocIt)
			dbGoTo(_aDocIt[nI][12])
			RecLock("SZ7",.F.)
			SZ7->Z7_OSCNFRT := ""
			SZ7->Z7_STATUS := "1"	// volta status dos itens para "Em Aberto"
			MsUnlock()
		Next nI

		// APAGA NA SZC
		dbSelectArea( "SZC" )
		dBSetOrder( 3 )
		If MSSeek( xFilial("SZC") +AvKey( _cOsInvent,"ZC_NUMOS" ) )

			While SZC->ZC_FILIAL == xFilial("SZC") .And. AllTrim(SZC->ZC_NUMOS) == AllTrim(_cOsInvent) .And. SZC->( !EOF() )

				Reclock("SZC",.F.)
				dbDelete()
				MsUnlock()

				SZC->( dbSkip() )
			End
		EndIf

	EndIf
EndIf



If SubStr( _cRota,1,1 ) == "R"

	// DESBLOQUEAR O ARMAZEM
	dbSelectArea("ZZ1")
	If MSSeek( xFilial("ZZ1") +AvKey( _cRota, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBL := ""
		MsUnLock()
	EndIf

Else
	cArmazem := "A" +SubStr( _cRota,2 )

	// DESBLOQUEAR O ARMAZEM
	dbSelectArea("ZZ1")
	If MSSeek( xFilial("ZZ1") +AvKey( _cRota, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBL := ""
		MsUnLock()
	EndIf

	If MSSeek( xFilial("ZZ1") +AvKey( cArmazem, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBL := ""
		MsUnLock()
	EndIf

EndIf

// habilitar os botoes de inventario e processar inventario
_cOsInvent := ""
oSOS:Refresh()

oBt2:Enable()
oBtInv:Enable()

MsgInfo( "Inventário cancelado!" )

Return


/*
Visualizar notas
*/
Static Function VerNotas()

Local aArea := GetArea()
Local oWnd
Local oLayer	:= FwLayer():New()
Local aSize		:= MsAdvSize(Nil,.F.)
Local nWdtRdp	:= aSize[5]/2
Local aNotas	:= {}
Local aNFPend	:= {}
Local cQuery	:= ""


MsProcTxt("Verificando notas pendentes de registro..")

// pegar notas faturadas para a rota e que nao deram saida
cQuery := "SELECT F2_DOC, F2_SERIE, F2_EMISSAO, F2_DTIMP FROM " +RetSqlName("SF2")
cQuery += " WHERE F2_XCODPA = '"+_cRota+"' AND F2_XFINAL = '4' AND F2_XNFABAS = '1' AND D_E_L_E_T_ = '' "
cQuery += " AND F2_CHVNFE <> '' "
cQuery += " AND F2_DTIMP = '' AND F2_HRIMP = '' "
cQuery += " AND F2_DOC NOT IN ( SELECT F2_DOC FROM " +RetSqlName("SZ7") +" SZ7 "
cQuery += " WHERE Z7_FILIAL = F2_FILIAL AND Z7_DOC = F2_DOC AND Z7_SERIE = F2_SERIE AND SZ7.D_E_L_E_T_ = '' ) "
cQuery += " AND F2_EMISSAO >= '20170301' "
cQuery += " ORDER BY F2_EMISSAO DESC "

MpSysOpenQuery( cQuery,"TRBF" )


dbSelectArea("TRBF")
While !EOF()
	AADD( aNotas,{ .F., TRBF->F2_DOC, TRBF->F2_SERIE, STOD(TRBF->F2_EMISSAO),"" } )
	dbSkip()
End
TRBF->(dbCloseArea())


MsProcTxt("Verificando notas registradas..")

/*
For nI := 1 To Len(_aDocIt)
	If Ascan( aNotas, { |x| x[2] == _aDocIt[nI][1] .And. x[3] == _aDocIt[nI][2] } ) == 0
		AADD( aNotas, { .T.,;
						_aDocIt[nI][1],;
						_aDocIt[nI][2],;
						_aDocIt[nI][3],;
						StoD(_aDocIt[nI][8]) } )
	EndIf
Next nI
*/
// ALTERADO - JACKSON 27/07/2017
For nI := 1 To Len(_aNF)
	AADD( aNotas, { .T.,;
						_aNF[nI][1],;
						_aNF[nI][2],;
						dtoc(_aNF[nI][3]),;
						dtoc(_aNF[nI][4]) } )
Next nI


For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.5
Next nI

oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Notas fiscais",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )

	oLayer:Init(oWnd,.F.)

	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Notas",100,.F.,.T.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()

	MENU oMenu POPUP
	MENUITEM "Retirar NF" ACTION ( RemNF( _cRota,aNotas[oLstDet:nAt][2],aNotas[oLstDet:nAt][3] ) )
	ENDMENU

	oLstDet := TCBrowse():New(020,012,410,090,,,,oPnl,,,,{ || },{ ||  },,,,,,,.F.,,.T.,,.F.,,,)
	oLstDet:SetArray(aNotas)

	oLstDet:AddColumn(TCColumn():New(' '			,{ || IIF(aNotas[oLstDet:nAt][1],oOk,oProb) },"@BMP",,,,,.T.,.F.,,,,.F., ) )
	oLstDet:AddColumn(TCColumn():New('Nota fiscal'	,{|| aNotas[oLstDet:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Série'		,{|| aNotas[oLstDet:nAt][3] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Emissão'		,{|| aNotas[oLstDet:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Saída'		,{|| aNotas[oLstDet:nAt][5] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))

	oLstDet:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oLstDet:Align := CONTROL_ALIGN_ALLCLIENT

	oLstDet:nScrollType := 1

oWnd:Activate(,,,.T.)

RestArea(aArea)

Return


/*
Retirar NF da Rota/PA
*/
Static Function RemNF( cArmazem,cNF,cSerie )

Local nI
Local cCliente := ""
Local cLoja := ""
Local aNotas := {}
Local dIniCClo := ddatabase
Local cNumOS := ""


If !VldPerm(8)
	MsgAlert( "Você não tem permissão para acessar esse recurso!" )
	Return
EndIf

If !MsgYesNo( "Confirma a retirada dessa NF do ciclo de trabalho?" )
	Return
EndIf

For nI := 1 To Len(_aDocIt)
	dbSelectArea("SZ7")
	dbGoTo(_aDocIt[nI][12])
	If Recno() == _aDocIt[nI][12] .And. AllTrim(SZ7->Z7_DOC) == AllTrim(cNF) .And. AllTrim(SZ7->Z7_SERIE) == AllTrim(cSerie)
		If RecLock("SZ7",.F.)
			dbDelete()
			MsUnLock()
		EndIf
		cCliente := SZ7->Z7_CLIENTE
		cLoja := SZ7->Z7_LOJA
	EndIf
Next nI

NfEstZ5( cNF )

dbSelectArea("SF2")
dbSetOrder(2)
If MSSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
	RecLock("SF2",.F.)
	SF2->F2_DTIMP := stod("")
	SF2->F2_HRIMP := ""
	MsUnLock()
EndIf


// produtos das notas em poder da rota - pega o que esta pendente de fechamento
Processa( { || ProdNF( _cRota ) },"Verificando notas, aguarde..")
LoadIni( cArmazem,dDatabase,@dIniCClo,@cNumOS )


For nI := 1 To Len(_aDocIt)
	If Ascan( aNotas, { |x| x[1] == _aDocIt[nI][1] .And. x[2] == _aDocIt[nI][2] } ) == 0
		AADD( aNotas, { _aDocIt[nI][1],;
						_aDocIt[nI][2],;
						_aDocIt[nI][3],;
						StoD(_aDocIt[nI][8]) } )
	EndIf
Next nI

oLstDet:SetArray(aNotas)
oLstDet:Refresh()

Return


/*
Retorna o atendente que esta no armazem
*/
Static Function fTecAA1( cLocal )

Local cQuery := ""
Local cCodTEc := ""

cQuery := "SELECT ZZ1_XATEND FROM " +RetSqlName("ZZ1")
cQuery += " WHERE ZZ1_COD = '"+cLocal+"' AND D_E_L_E_T_ = '' "

MpSysOpenQuery(cQuery,"TRB")

dbSelectARea("TRB")
If !EOF()
	cCodTEc := TRB->ZZ1_XATEND
EndIf

dbCloseArea()

Return cCodTEc

/*
Processar a OS de inventario
*/
Static Function CalcInv()

Local nI
Local cOsInvent := ""

If Empty( _cOsInvent )
	MsgAlert("A Ordem de Serviço ainda não foi gerada.")
	Return
EndIf


dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(_cOsInvent,"ZG_NUMOS") )

	If AllTrim(SZG->ZG_STATUS) == "FIOK"
		If SZG->ZG_DATAFIM > SZG->ZG_DATAINI
			MsgAlert("O inventário foi finalizado com data posterior ao agendamento. Cancele e inicie outro inventário.")
			Return
		EndIf

		aDados := U_MXML000(SZG->ZG_RESPOST)
	Else
		MsgInfo("Inventário não finalizado.")
		Return
	EndIf

EndIf


dbSelectArea("SZC")
dbSetOrder(3) // filial os
If MSSeek( xFilial("SZC") +AvKey( _cOsInvent ,"ZC_NUMOS") )
	MsgInfo("Inventário já processado.")
	Return
EndIf

MsAguarde( { || fProcInv( _cOsInvent,aDados ) },"Verificando contagens..." )


// refresh tela
Processa( { || RefAtu( _dIniCiclo )  },"Carregando dados.." )


// desabilita botao
oBtInv:Disable()

Return


/*
Processa o inventario - contagens
*/
Static Function fProcInv(cOsInvent,aDados)

U_TTPROC28( cOsInvent,aDados )

dbSelectArea("SZG")
RecLock("SZG",.F.)
SZG->ZG_PROC := "BR_VERDE"
MsUnLock()


Return


/*
Verifica as inconsistencias nas linhas
*/
Static Function ChkInco()

Local nI

For nI := 1 To Len(_aLista1)
	If _aLista1[nI][13] <> 0 .Or. _aLista1[nI][14] <> 0
		_aLista1[nI][1] := "2"
	EndIf
Next nI

If oLista1 <> Nil
	oLista1:Refresh(.T.)
EndIf

Return


/*
Mostra os pedidos gerados
*/
Static Function fPedDesc()

Local aArea := GetArea()
Local oWnd
Local oLayer	:= FwLayer():New()
Local aSize		:= MsAdvSize(Nil,.F.)
Local aPedido	:= {}
Local cQuery	:= ""
Local oVerde	:= LoadBitMap(GetResources(), "BR_VERDE")
Local oVermelho := LoadBitMap(GetResources(), "BR_VERMELHO")

// monta query
cQuery := "SELECT * FROM INVDOCS INVD "
cQuery += "LEFT JOIN " +RetSqlName("SC5") + " SC5 ON C5_FILIAL = FILIAL AND C5_NUM = NUMERO AND SC5.D_E_L_E_T_ = '' "
cQuery += "WHERE ARMAZEM = '"+_cRota+"' AND DIA = '"+DTOS(dDatabase)+"' AND TIPODOC = 'SC5' AND INVD.D_E_L_E_T_ = '' "

MpSysOpenQuery( cQuery,"TRBF" )


dbSelectArea("TRBF")
While !EOF()
	AADD( aPedido,{ TRBF->NUMERO, dtoc(STOD(TRBF->DIA)), IIF( !Empty(TRBF->C5_NOTA),.T.,.F.), TRBF->OBS } )
	dbSkip()
End
TRBF->(dbCloseArea())

If Empty(aPedido)
	MsgInfo("Não há pedidos.")
	Return
EndIf

For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.5
Next nI

oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Pedidos gerados",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )

	oLayer:Init(oWnd,.F.)

	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Pedidos",100,.F.,.T.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()


	oLstDet := TCBrowse():New(020,012,410,090,,,,oPnl,,,,{ || },{ ||  },,,,,,,.F.,,.T.,,.F.,,,)
	oLstDet:SetArray(aPedido)

	oLstDet:AddColumn(TCColumn():New('Pedido'		,{|| aPedido[oLstDet:nAt][1] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Emissão'		,{|| aPedido[oLstDet:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLstDet:AddColumn(TCColumn():New('Faturado'		,{|| If(aPedido[oLstDet:nAt][3],oVerde,oVermelho)},"@BMP",,,,,.T.,.F.,,,,.F., ) )		// Processados
	oLstDet:AddColumn(TCColumn():New('Obs'			,{|| aPedido[oLstDet:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))


	oLstDet:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oLstDet:Align := CONTROL_ALIGN_ALLCLIENT

	oLstDet:nScrollType := 1

oWnd:Activate(,,,.T.)

RestArea(aArea)

Return

/* Pedidos do ciclo */
Static Function PedCiclo( cArmazem,dInicio,cHrIniCC,dFim,aPedido )

Local cQuery := ""


// monta query
cQuery := "SELECT NUMERO,SUM(C6_QTDVEN) TOTAL FROM INVDOCS INVD "

cQuery += "LEFT JOIN " +RetSqlName("SC6") +" SC6 ON C6_FILIAL = FILIAL AND C6_NUM = NUMERO AND SC6.D_E_L_E_T_ = '' "

cQuery += "WHERE "
cQuery += "ARMAZEM = '"+cArmazem+"' "
cQuery += "AND ( ( DIA = '"+DTOS(dInicio)+"'  AND HORA > '"+cHrIniCC+"' ) OR ( DIA BETWEEN '"+DTOS(dInicio+1)+"' AND '"+DTOS(dFim)+"' ) ) "
cQuery += "AND TIPODOC = 'SC5' AND INVD.D_E_L_E_T_ = '' "

cQuery += "GROUP BY NUMERO"


MpSysOpenQuery( cQuery,"TRBF" )


dbSelectArea("TRBF")
While !EOF()
	AADD( aPedido,{ AllTrim(TRBF->NUMERO), TRBF->TOTAL } )
	dbSkip()
End
TRBF->( dbCloseArea() )

Return


/*
Verifica se existe tabela no TOP - gravar historico dos pedidos/notas
*/
Static Function TabDocs()

Local aCampos := {  {"FILIAL","C",2,0},;
					{"ARMAZEM","C",6,0},;
					{"OPERAD","C",15,0},;
					{"TIPODOC","C",3,0},;
					{"NUMERO","C",15,0},;
					{"DIA","D",8,0},;
					{"HORA","C",8,0},;
					{"OBS","C",50,0} }

If !TCCanOpen("INVDOCS")
	DbCreate( "INVDOCS",aCampos,"TOPCONN" )
EndIf

Return

/*
Verifica se gerou os PEDIDOS
*/
Static Function ChkPeds( dInicio, dFim, cHrIniCC )

Local cQuery := ""


If !TCCanOpen("INVDOCS")
	Return
EndIf

// monta query
cQuery := "SELECT COUNT(*) TOTAL FROM INVDOCS INVDOCS "
cQuery += " LEFT JOIN " +RetSqlName("SC5") + " SC5 ON "
cQuery += " C5_FILIAL = FILIAL AND C5_NUM = NUMERO AND SC5.D_E_L_E_T_ = '' "
cQuery += "WHERE ARMAZEM = '"+_cRota+"' AND TIPODOC = 'SC5' AND INVDOCS.D_E_L_E_T_ = '' "
cQuery += " AND ( ( DIA = '"+DTOS(dInicio)+"' AND C5_XHRINC > '"+cHrIniCC+"' ) OR ( DIA BETWEEN '"+dtos(dInicio+1)+"' AND '"+DTOS(dFim)+"' ) ) "
cQuery += " AND OBS = 'PEDIDO DE DESCARTE' "

MpSysOpenQuery( cQuery,"TRBF" )

dbSelectArea("TRBF")

If TRBF->TOTAL > 0
	_lPedOk := .T.
EndIf

TRBF->( dbCloseArea() )

Return


/* Verifica notas que entraram  */
Static Function ChkNfS( cArmazem,dInicio,cHrIniCC,dFim,aNF )

Local cQuery := ""
Local aNF := {}
Local cArm := ""

If SubStr( cArmazem,1,1 ) == "P"
	cArm := "A" +SubStr( cArmazem,2 )
Else
	cArm := cARmazem
EndIf

// consulta notas
cQuery := "SELECT Z5_NF, Z5_EMISSAO, Z5_HORA, F2_EMISSAO "
cQuery += "FROM " +RetSqlName("SZ5")

cQuery += " LEFT JOIN " +RetSqlName("SF2") +" ON F2_FILIAL = Z5_FILIAL AND F2_DOC = Z5_NF AND F2_TIPO = 'N' "

cQuery += " WHERE Z5_LOCAL = '"+cArm+"' "
cQuery += " AND Z5_TM = '100' AND Z5_ORIGEM = 'TTFAT18C' "
cQuery += " AND ( ( Z5_EMISSAO = '"+DTOS(dInicio)+"' AND Z5_HORA > '"+cHrIniCC+"' ) OR ( Z5_EMISSAO BETWEEN '"+dtos(dInicio+1)+"' AND '"+dtos(dFim)+"' ) )"

MpSysOpenQuery( cQuery,"TRBX" )

dbSelectARea("TRBX")
While !EOF()

	If AScan( aNF, { |x| x[1] == TRBX->Z5_NF  } ) == 0
		AADD( aNF, { TRBX->Z5_NF, "2", STOD(TRBX->F2_EMISSAO), STOD(TRBX->Z5_EMISSAO) } )
  	EndIf

	dbSkip()
End

TRBX->(dbCloseArea())

Return

/* Nota de devolucao do ciclo! */
Static Function ChkNfDv( cArmazem,dInicio,cHrIniCC,dFim,cNfDev,cSeriDev,aItensDev )

Local cQuery := ""

cQuery := "SELECT * FROM INVDOCS "
cQuery += "	WHERE ARMAZEM = '"+cArmazem+"' AND D_E_L_E_T_ = '' "
cQuery += " AND TIPODOC = 'SF1' "
cQuery += " AND ( ( DIA = '"+DTOS(dInicio)+"'  AND HORA > '"+cHrIniCC+"' ) OR ( DIA BETWEEN '"+DTOS(dInicio+1)+"' AND '"+dTos(dFim)+"' ) )"

MPSYSOPENQUERY( cQuery,"TRBX" )

dbSelectArea("TRBX")
If ! EOF()
	cNfDev := TRBX->NUMERO
	cSeriDev := "2"
EndIf

TRBX->( dbCloseArea() )


If !Empty( cNfDev ) .And. !Empty( cSeriDev )
     //aItensDev
	cQuery := "SELECT * FROM " +RetSqlName("SD1") +" SD1 "
	cQuery += " WHERE D1_FILIAL = '"+xFilial("SD1")+"' AND D1_DOC = '"+cNfDev+"' AND D1_SERIE = '"+cSeriDev+"' AND D_E_L_E_T_ = '' ORDER BY D1_COD "

	MpSysOpenQuery( cQuery, "TRBX" )

	dbSelectArea("TRBX")

	While !EOF()
		AADD( aItensDev, { TRBX->D1_COD, TRBX->D1_QUANT } )
		dbSkip()
	End

	TRBX->( dbCloseArea() )

EndIf


Return

// ESTORNO NOTA ENTRADA SZ5
Static Function NfEstZ5( cNF )

Local cQuery := ""

cQuery := "SELECT * FROM " +RetSqlName("SZ5")
cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"' AND Z5_NF = '"+cNF+"'  AND D_E_L_E_T_ = '' AND Z5_ORIGEM = 'TTFAT18C' AND Z5_OBS LIKE '%ENTRADA%' AND Z5_TM = '100' "
cQuery += " ORDER BY Z5_DOC "

MpSysOpenQuery( cQuery,"TRB" )
dbSelectArea("TRB")

While !EOF()

	dbSelectArea( "SZ6" )
	dbSetOrder(1)
	If MsSeek( xFilial("SZ6") +AvKey( TRB->Z5_LOCAL,"Z6_LOCAL") +AvKey(TRB->Z5_COD,"Z6_COD") )
		RecLock("SZ6",.F.)
		SZ6->Z6_QATU := ( SZ6->Z6_QATU - TRB->Z5_QUANT )
		MsUnLock()
	EndIf

	dbSelectArea("TRB")
	TRB->( dbSkip() )
End

cQuery := "UPDATE " +RetSqlName("SZ5")
cQuery += " SET D_E_L_E_T_ = '*' "
cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"' AND Z5_NF = '"+cNF+"' AND D_E_L_E_T_ = '' "  // AJUSTADO POR RONALDO G. DE JESUS - 17/10/2018
//cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"' AND Z5_NF = '"+cNF+"' D_E_L_E_T_ = '' " // COMENTADO POR RONALDO G. DE JESUS - 17/10/2018


TCSQLExec(cQuery)

Return


/*
Ajuste das divergencias
*/
Static Function AjusteDiv()

Local nI
Local cArmA
Local aItens := {}
Local aItens2 := {}
Local cMsg := ""
Local cNomeAtend := AllTrim( Posicione( "AA1",1,xFilial("AA1") +AvKey( _cTecAtend,"AA1_CODTEC" ),"AA1_NOMTEC"  ) )
Local cNumPed := ""
Local nPed := 0
Local nOpcao := 0
Local aDivAvar := {}
Local nQtd := 0

MsgInfo( "É preciso imprimir o relatório antes do ajuste de divergências." )

nOpcao := Aviso( "Ajustes","Escolha a opção: Imprimir o relatório ou Ajustas as divergências",{"Imprimir","Ajustar"} )

If nOpcao == 1
	U_TTESTR15( _cRota,_dIniCiclo,dDatabase,_cHrIniCC,_aLista1, _aNF,_cNfDev, _cSerDv )
	Return
EndIf

/*
Somente dos valores negativos: Emitir pedido de Perda, para PA. Faturar a perda(baixa de A, P ou R se Rota).Obs na Nota e ajuste:"Perda de PA - Fechamento de Rota: OS de Inventario; PA/Rota; Nome do Técnico; Nome do Usuário que gerou" - Gera desconto para funcionário.
Para os valores positivos: Gerar movimentos de entrada na PA, em Pe no A, e R se Rota. (se não entrar, não conseguirá faturar a devolução) - Tem que registrar o tipo de movimento de entrada - Inventario de Rota/PA.
*/

// pegar as divergencias totais - gerar pedido de perda PA - ROTA??
// PA
If SubStr( _cRota,1,1 ) == "P"

	cArmA := "A" +SubStr( _cRota,2 )


	For nI := 1 To Len( _aLista1 )

		// negativos
		If _aLista1[nI][14] < 0
			AADD( aItens, { _aLista1[nI][2], ABS(_aLista1[nI][14]) } )
		EndIf

		// positivos
		If _aLista1[nI][14] > 0
			nQtd := ABS(_aLista1[nI][14])
			// abater devolucao
			If _aLista1[nI][16] > 0
				nQtd := _aLista1[nI][14] - _aLista1[nI][16]
			EndIf
			If nQtd > 0
				AADD( aItens2, { _aLista1[nI][2], nQtd/*ABS(_aLista1[nI][14])*/ } )
			EndIf
			//AADD( aItens2, { _aLista1[nI][2], ABS(_aLista1[nI][14]) } )
		EndIf


		// divergencia avarias - positivas ( Anexo 3 - Pag. 6 - item 12 )
		If _aLista1[nI][13] > 0
			AADD( aDivAvar, { _aLista1[nI][2], ABS(_aLista1[nI][13]) } )
		EndIf

	Next nI

	// perdas
	If !Empty(aItens)

		cMsg := "Perda de PA - Fechamento de PA/Rota: "
		cMsg += "OS: " +_cOsInvent
		cMsg += " PA/Rota: " +_cRota
		cMsg += " " +cNomeAtend
		cMsg += " " +cUsername

		LJMsgRun("Gerando o(s) pedido(s) de perda","Aguarde...",{ || cNumPed := STATICCALL( TTPROC25, GeraPedido,"000001",Strzero(val(cFilAnt),4), _cRota, "", aItens,cMsg )} )

		If !Empty(cNumPed)
			nPed++

			// grava na tabela de historico de pedidos gerados
			// tabela log pedidos
			If Select("TRBD") == 0
				DbUseArea(.T., "TOPCONN", "INVDOCS", "TRBD", .T., .F.)
			EndIf
			DbSelectArea("TRBD")

			RecLock("TRBD",.T.)
			TRBD->FILIAL	:= xFilial("SC5")
			TRBD->ARMAZEM	:= _cRota
			TRBD->OPERAD	:= cUserName
			TRBD->TIPODOC	:= "SC5"		// pedido
			TRBD->NUMERO	:= cNumPed
			TRBD->DIA		:= dDatabase
			TRBD->HORA		:= Time()
			TRBD->OBS		:= "PEDIDO DE PERDA"
			MsUnLock()

		EndIf

		// baixa quantidades armazem
		MovArm( cArmA, aItens, "515","PERDA" )		// armazem A
		MovArm( _cRota, aItens, "515","PERDA" )		// armazem P

	EndIf

	If !Empty(aDivAvar)

		cMsg := "Avaria em PA - Fechamento de PA/Rota: "
		cMsg += "OS: " +_cOsInvent
		cMsg += " PA/Rota: " +_cRota
		cMsg += " " +cNomeAtend
		cMsg += " " +cUsername

		LJMsgRun("Gerando o(s) pedido(s) de perda","Aguarde...",{ || cNumPed := STATICCALL( TTPROC25, GeraPedido,"000001",Strzero(val(cFilAnt),4), _cRota, "", aDivAvar,cMsg )} )

		If !Empty(cNumPed)
			nPed++

			// grava na tabela de historico de pedidos gerados
			// tabela log pedidos
			If Select("TRBD") == 0
				DbUseArea(.T., "TOPCONN", "INVDOCS", "TRBD", .T., .F.)
			EndIf
			DbSelectArea("TRBD")

			RecLock("TRBD",.T.)
			TRBD->FILIAL	:= xFilial("SC5")
			TRBD->ARMAZEM	:= _cRota
			TRBD->OPERAD	:= cUserName
			TRBD->TIPODOC	:= "SC5"		// pedido
			TRBD->NUMERO	:= cNumPed
			TRBD->DIA		:= dDatabase
			TRBD->HORA		:= Time()
			TRBD->OBS		:= "PEDIDO DE PERDA"
			MsUnLock()

		EndIf


		// baixa quantidades armazem
		MovArm( cArmA, aDivAvar, "515","PERDA" )		// armazem A
		MovArm( _cRota, aDivAvar, "515","PERDA" )		// armazem P
	EndIf

	// positivos
	If !Empty( aItens2 )
		// sobe quantidades armazem
		MovArm( cArmA, aItens2, "015","POSITIVOS" )		// armazem A
		MovArm( _cRota, aItens2, "015","POSITIVOS" )	// armazem P
	EndIf


// ROTA
Else
	For nI := 1 To Len( _aLista1 )
		If _aLista1[nI][14] < 0
			AADD( aItens, { _aLista1[nI][2], ABS(_aLista1[nI][14]) } )
		EndIf

		If _aLista1[nI][14] > 0
			nQtd := ABS(_aLista1[nI][14])
			// abater devolucao
			If _aLista1[nI][16] > 0
				nQtd := _aLista1[nI][14] - _aLista1[nI][16]
			EndIf
			If nQtd > 0
				AADD( aItens2, { _aLista1[nI][2], nQtd/*ABS(_aLista1[nI][14])*/ } )
			EndIf
		EndIf
	Next nI

	If !Empty( aItens )

		// COMO FATURAR O PEDIDO DE PERDA DA ROTA? GERAR SALDO NA SB2?
		cMsg := "Perda de PA - Fechamento de Rota: "
		cMsg += "OS: " +_cOsInvent
		cMsg += " PA/Rota: " +_cRota
		cMsg += " " +cNomeAtend
		cMsg += " " +cUsername

		LJMsgRun("Gerando o(s) pedido(s) de perda","Aguarde...",{ || cNumPed := STATICCALL( TTPROC25, GeraPedido,"000001",Strzero(val(cFilAnt),4), _cRota, "", aItens,cMsg )} )

		If !Empty(cNumPed)
			nPed++

			// grava na tabela de historico de pedidos gerados
			// tabela log pedidos
			If Select("TRBD") == 0
				DbUseArea(.T., "TOPCONN", "INVDOCS", "TRBD", .T., .F.)
			EndIf
			DbSelectArea("TRBD")

			RecLock("TRBD",.T.)
			TRBD->FILIAL	:= xFilial("SC5")
			TRBD->ARMAZEM	:= _cRota
			TRBD->OPERAD	:= cUserName
			TRBD->TIPODOC	:= "SC5"		// pedido
			TRBD->NUMERO	:= cNumPed
			TRBD->DIA		:= dDatabase
			TRBD->HORA		:= Time()
			TRBD->OBS		:= "PEDIDO DE PERDA"
			MsUnLock()

		EndIf

		// baixa quantidades armazem
		MovArm( _cRota, aItens, "515","PERDA" )

	EndIf

	If !Empty( aItens2 )
		// sobe quantidades armazem
		MovArm( _cRota, aItens2, "015","POSITIVOS" )
	EndIf

EndIf

// desabilita
oBtDiv:Disable()


Processa( { || RefAtu( _dIniCiclo ) },"Recarregando dados, aguarde..")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC57  ºAutor  ³Microsiga           º Data ³  08/18/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EstMov()

// desbloquear armazem
If SubStr( _cRota,1,1 ) == "R"
	dbSelectArea("ZZ1")
	If MSSeek( xFilial("ZZ1") +AvKey( _cRota, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBL := ""
		MsUnLock()
	EndIf
Else
	cArmazem := "A" +SubStr( _cRota,2 )

	dbSelectArea("ZZ1")
	If MSSeek( xFilial("ZZ1") +AvKey( _cRota, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBL := ""
		MsUnLock()
	EndIf

	If MSSeek( xFilial("ZZ1") +AvKey( cArmazem, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "2"
		ZZ1->ZZ1_XMOTBL := ""
		MsUnLock()
	EndIf
EndIf

U_TTESTMOV( _cRota,_dIniCiclo,dDatabase,_cHrIniCC)

// bloquear novamente
If SubStr( _cRota,1,1 ) == "R"
	dbSelectArea("ZZ1")
	If MSSeek( xFilial("ZZ1") +AvKey( _cRota, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "1"
		ZZ1->ZZ1_XMOTBL := "CONTAGEM INVENTARIO - " +Dtoc(Date()) +" - " +cUserName
		MsUnLock()
	EndIf
Else
	cArmazem := "A" +SubStr( _cRota,2 )

	dbSelectArea("ZZ1")
	If MSSeek( xFilial("ZZ1") +AvKey( _cRota, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "1"
		ZZ1->ZZ1_XMOTBL := "CONTAGEM INVENTARIO - " +Dtoc(Date()) +" - " +cUserName
		MsUnLock()
	EndIf

	If MSSeek( xFilial("ZZ1") +AvKey( cArmazem, "ZZ1_COD" ) )
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_MSBLQL := "1"
		ZZ1->ZZ1_XMOTBL := "CONTAGEM INVENTARIO - " +Dtoc(Date()) +" - " +cUserName
		MsUnLock()
	EndIf
EndIf


Return


Static Function AjusteB2(cArmazem,aProd)

Local nI
Local nCustD := 0
Local cQuery := ""
Local nUltPrc := 0
Default cArmazem := ""
Default aProd := {}

If Empty(cArmazem)
	Return
EndIf

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB2")
dbSetOrder(2)


If Empty(aProd)
	cQuery := "SELECT B2_COD FROM " +RetSqlName("SB2")
	cQuery += " WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '"+cArmazem+"' AND D_E_L_E_T_ = '' "

	MPSysOpenQuery( cQuery , "TRBZ" )
	dbSelectArea("TRBZ")
	While !EOF()
		AADD( aProd, { TRBZ->B2_COD  } )
		dbSkip()
	End

	TRBZ->(dbCloseArea())

EndIf

For nI := 1 To Len(aProd)
	nCustD := 0
	nUltPrc := 0
	dbSelectArea("SB1")
	If MsSeek( xFilial("SB1") +AvKey(aProd[nI][1],"B1_COD") )
		nCustd := SB1->B1_CUSTD
		nUltPrc := SB1->B1_UPRC
	EndIf

	If nCustd == 0
		nCustd := nUltPrc
	EndIf

	If nCustD > 0
		dbSelectArea("SB2")
		If MsSeek( xFilial("SB2") +AvKey(cArmazem,"B2_LOCAL") +AvKey(aProd[nI][1],"B2_COD") )
			//If SB2->B2_CM1 < 0 .OR. SB2->B2_CM1 > 15 .OR. SB2->B2_VATU1 < 0 .OR. SB2->B2_VATU2 < 0
				RecLock("SB2",.F.)
				SB2->B2_CM1 := nCustD
				SB2->B2_CM2 := nCustD
				SB2->B2_VATU1 := IIF(nCustD>0,nCustd*SB2->B2_QATU,0)
				SB2->B2_VATU2 := IIF(nCustD>0,nCustd*SB2->B2_QATU,0)
				MsUnLock()
			//EndIf
		EndIf
	EndIf
Next nI


Return