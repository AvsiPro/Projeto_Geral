#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPVDESC    บAutor  ณJackson E. de Deusบ   Data ณ  25/03/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera็ใo de Pedido de Descarte a partir do Menu.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPVDESC() 

Private opButton1
Private opButton2
Private oDlg2
Private dDtInicio	:= Ctod(Dtoc(dDatabase))
Private dDtFinal	:= Ctod(Dtoc(dDatabase))


   
// Verifica se usuario pode acessar o programa
//cUser := RetCodUsr()
If cEmpAnt == "01"
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	oDlg2 := MsDialog():New(000,000,210,318,"Gera็ใo de Pedidos de Descarte",,,,,CLR_BLACK,CLR_HGRAY,,,.T.)
	 			
		@ 05,60 Say "Filtro de Notas" Pixel  Of oDlg2	 		
		@ 02, 05  To 090, 156 LABEL "" Pixel Of oDlg2
		@ 030, 25 Say "Dt Digita็ใo De ?"  	  Pixel Of oDlg2
		@ 030, 95 MsGet  dDtInicio	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2
		@ 045, 25 Say "Dt Digita็ใo Ate ?"  	  Pixel Of oDlg2
		@ 045, 95 MsGet  dDtFinal	Picture "99/99/99" Size 40,0.5 Pixel Of oDlg2
					
		opButton1 := tButton():New(065,010,"&Confirmar" 	,oDlg2,{ || TelaSF1()},70,20,,,,.T.)
		opButton2 := tButton():New(065,080,"&Sair" 			,oDlg2,{ || Close(oDlg2)},70,20,,,,.T.)
	
	oDlg2:Activate(,,,.T.,,,)                                                                       
EndIF

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaSF1  บAutor  ณJackson E. de Deus     บ Data ณ  25/03/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Browse para visualiza็ใo das Notas e Gera็ใo do Pedido.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TelaSF1()

Local cFiltra
Private aIndexSF1	:= {} 
Private bFiltraBrw
Private cAlias		:= "SF1"

Private cCadastro	:= "Notas de Entrada de Devolu็ใo"
Private aRotina		:= {{"Pesquisar"	,"AxPesqui"							,0,1} ,;	// Pesquisar
						{"Visualizar"	,"A103NFiscal(cAlias,Recno(),2)"	,0,2} ,;	// Visualizar
		   				{"Gerar Pedido"	,"U_PVDESC"							,0,3} ,;	// Gera o Pedido de Descarte
	             		{"Legenda"		,"U_PVDLEG"							,0,4}}		// Legenda

 			             
Private aCores 	:= { {"F1_XPVDESF <> 'S'"	,"BR_VERDE"		} ,;	// Pedido de Descarte nใo gerado
					{"F1_XPVDESF == 'S'" ,"BR_PINK"			}} 		// Pedido de Descarte gerado						 
				

// Filtro da tela					   

cFiltra := "(F1_DTDIGIT >= dDtInicio .AND. F1_DTDIGIT <= dDtFinal) .AND. F1_TIPO = 'D' .AND. F1_FORNECE = '000001' "

bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSF1,@cFiltra) }  	
Eval(bFiltraBrw)	
		            
dbSelectArea(cAlias)                      
mBrowse( 6,1,22,75,cAlias,,,,,3,aCores)
EndFilBrw(cAlias,aIndexSF1)
                                                                                                                               

		 
Return Nil





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPVDLeg  บAutor  ณJackson E. de Deus    บ Data ณ  25/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda da Tela.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PVDLeg()
	BrwLegenda(cCadastro,"Status",{{"BR_VERDE","Pedido de Descarte nใo gerado"},;
	                               {"BR_PINK","Pedido de Descarte gerado"}})
							
Return .T.





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPVDESC  บAutor  ณJackson E. de Deus    บ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Pedido de Descarte.                                 บฑฑ
ฑฑบ			 ณ Tamb้m ้ executada a partir do PE MT100AGR.				  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PVDESC()

Local _cTESDoc
Local _cNumNF
Local _lVld
Local cAviso		:= ""             
Local nPVRec

                
/*--------------------------------------------------------------+
| Verifica se ้ Devolu็ใo de Descarte -  TES 260 ou 265 no item	|
+--------------------------------------------------------------*/
dbSelectArea("SF1")
_cTESDoc	:= SuperGetMV("MV_XTESNFD" ,.T. ,"260#265",)	// Tes de NF de descarte
_cNumNF		:= SF1->F1_DOC									// Numero da NF	
		
_lVld		:= VldNF(_cNumNF,_cTESDoc)
		
// -> Gera o Pedido de Descarte
If _lVld
	If AllTrim(SF1->F1_XPVDESF) == "" .And. AllTrim(SF1->F1_XPVDESR) == "" 
		MsgRun("Gerando o Pedido de Descarte, por favor aguarde...","Pedido de Venda",{ || GeraPedido() } )
	Else
		nPVRec := Val(SF1->F1_XPVDESR)	// Recno do Pedido de Venda Gerado
	 	dbSelectArea("SC5")
    	dbGoTo(nPVRec)
			
		cAviso := "Jแ existe Pedido de Venda de Descarte para essa NF." + CRLF
		cAviso += "Filial: " +SC5->C5_FILIAL							+ CRLF
		cAviso += "Pedido: " +SC5->C5_NUM 								+ CRLF
		cAviso += "Data: " + DtoC(SC5->C5_EMISSAO)						+ CRLF
		cAviso += "Hora: " + SC5->C5_XHRINC								+ CRLF
		cAviso += "Usuแrio: " +AllTrim(SC5->C5_XNOMUSR)

		Aviso("PVDESC", cAviso, {"Ok"},3)
		SC5->(dbCloseArea())

	EndIf	
Else
	If xFilial("SF1") # SF1->F1_FILIAL
		If !IsInCallStack("U_MT100AGR")
			MsgAlert("A filial nใo pode ser diferente da filial da Nota Fiscal.")
		EndIf
	EndIf
EndIf        


	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraPedido  บAutor  ณJackson E. de Deusบ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o Pedido de Descarte e envia e-mail para a แrea.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraPedido()

Local lSendMail		:= SuperGetMV("MV_XMAILPD",.T.,.F.)
Local cFornCNPJ		:= ""
Local _nItem   		:= 0
Local _cTESPV
Local _cCFPV
Local _cNumPed
Local _cMsgNota
Local _cEspecie
Local _cDescCli
Local _nVol 
Local _cTipoCli
Local _nCusto		:= 0
Local _dData
Local nP	                    
Local nX
Local alAreaSA1
Local _cAviso		:= ""
Local llRet			:= .F.
Local lRetMail		:= .F.
Local _cLocalPA		:= ""
Local cRemete			
Local cArqMail
Local cTarget		
Local cSubject
Local aAttach		:= {}
Local _aSC5	  		:= {}
Local _aItem	   	:= {}
Local cCorTable		:= ""
Local cPVRecno		:= ""
Local _cCodCli
Local _cLjCli
Local MsgPA			:= ""
      
_cNumPed	:= GetSX8Num("SC5","C5_NUM")						// Numero do PV

_cMsgNota	:= SuperGetMV("MV_XMSGPV" ,.T. ,"DESCARTE",)		// Msg do PV
_cMsgNota	+= " REF. NF: "+SF1->F1_DOC +"/"+SF1->F1_SERIE +" PA: "

_cEspecie	:= SuperGetMV("MV_XESPPV" ,.T. ,"UN",)				// Especie do PV
_nVol		:= SuperGetMV("MV_XVOLPV" ,.T. ,21,)				// Volume do PV
_cCondPag	:= SuperGetMV("MV_XCNDPV" ,.T. ,"001",)				// Cond pag do PV
_dData		:= SuperGetMV("MV_ULMES",.T.,CTOD("01/06/2012"),)	// Data do ultimo fechamento
_cTESPV		:= SuperGetMV("MV_XTESPV" ,.T. ,"934",)				// TES do PV
_cCFPV		:= SuperGetMV("MV_XCFPV" ,.T. ,"5927",)				// CFOP do PV
_cTransp	:= SuperGetMV("MV_XTRANSP", .T., "000019")			// Transportadora
_nItem		:= 1												// Item inicial do PV
cRemete 	:= SuperGetMV("MV_RELACNT",.T.,"microsiga",)
cTarget		:= SuperGetMV("MV_XRESPVD",.T.,"jdeus@toktake.com.br",)
cCorTable	:= SuperGetMV("MV_XCOR001",.T.,"#BC8F8F",)

// -> Busca Cliente | que ้ fornecedor
cFornCNPJ := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
dbSelectArea("SA1")
alAreaSA1 := GetArea()
dbSetOrder(3)		// Por CNPJ
If dbSeek( xFilial("SA1")+cFornCNPJ )
	_cCodCli	:= SA1->A1_COD
	_cLjCli		:= SA1->A1_LOJA
	_cDescCli	:= SA1->A1_NREDUZ								// Desc. do Cliente
	_cTipoCli	:= SA1->A1_TIPO									// Tipo do Cliente
Else
	MsgAlert("Cliente nใo encontrado! CNPJ: "+cFornCNPJ)
EndIf
RestArea(alAreaSA1)



dbSelectArea("SF1")

/*----------------------------------------------+
| Gera Array com cabe็alho do Pedido de Venda	|
+----------------------------------------------*/
Aadd(_aSC5, {"C5_FILIAL" 	,xFilial("SC5")		,Nil}) 			// Filial
Aadd(_aSC5, {"C5_NUM"    	,_cNumPed			,Nil})			// Numero do Pedido
Aadd(_aSC5, {"C5_TIPO"   	,"N"      			,Nil})			// Tipo do Pedido
Aadd(_aSC5, {"C5_CLIENTE"	,_cCodCli 			,Nil})			// Cliente para faturamento
Aadd(_aSC5, {"C5_LOJACLI"	,_cLjCli			,Nil})			// Loja do cliente
Aadd(_aSC5, {"C5_CLIENT"	,_cCodCli 			,Nil})			// Cliente para entrega
Aadd(_aSC5, {"C5_LOJAENT"	,_cLjCli			,Nil})			// Loja para entrada
Aadd(_aSC5, {"C5_XDTENTR"	,dDatabase+5		,Nil})			// Data da entrega
Aadd(_aSC5, {"C5_XNFABAS"	,"2"				,Nil})			// Nf Abastecimento - NAO
Aadd(_aSC5, {"C5_XFINAL" 	,"L"				,Nil})			// Finalidade de venda - Descarte
Aadd(_aSC5, {"C5_TRANSP" 	,_cTransp			,Nil})			// Transportadora -> Tok Take
Aadd(_aSC5, {"C5_CONDPAG"	,_cCondPag			,Nil})			// Codigo da condicao de pagamanto*
Aadd(_aSC5,	{"C5_MOEDA"		,1 					,Nil})			// Moeda
Aadd(_aSC5,	{"C5_FRETE"		,0 					,Nil})			// Frete
Aadd(_aSC5,	{"C5_TXMOEDA"	,1 					,Nil})			// Tx da Moeda
Aadd(_aSC5, {"C5_EMISSAO"	,dDatabase			,Nil})			// Data de emissao
Aadd(_aSC5, {"C5_MENNOTA"	,_cMsgNota			,Nil})			// Msg da nota
Aadd(_aSC5, {"C5_ESPECI1"	,_cEspecie			,Nil})			// Especie
Aadd(_aSC5, {"C5_XRINC"		,TIME()				,Nil})			// Hora da inclusao
Aadd(_aSC5, {"C5_XDATINC"	,DATE()				,Nil})			// Data da inclusao
Aadd(_aSC5, {"C5_XNOMUSR"	,cUserName			,Nil}) 			// Login do usuario
Aadd(_aSC5, {"C5_XCODUSR"	,__cUserID			,Nil})			// Codigo do usuario
Aadd(_aSC5, {"C5_TPFRET" 	,"C" 				,Nil})			// Tipo de Frete: CIF
Aadd(_aSC5, {"C5_TIPOCLI"	,_cTipoCli			,Nil})			// Tipo de Cliente
Aadd(_aSC5, {"C5_TIPLIB" 	,"1"         		,Nil})			// Tipo de Liberacao
//Aadd(_aSC5, {"C5_XSTLIB" 	,"1"         		,Nil})			// Liberacao
Aadd(_aSC5, {"C5_VEND1"  	,"000023"			,Nil})			// Vendedor
Aadd(_aSC5, {"C5_XDESCLI"	,_cDescCli			,Nil})			// Desc Cliente
Aadd(_aSC5, {"C5_LIBEROK"	,"S"         		,Nil})			// Liberacao Total
Aadd(_aSC5, {"C5_VOLUME1"	,_nVol				,Nil})			// Volume
Aadd(_aSC5, {"C5_XGPV"	 	,'PCA'				,Nil}) 			// Grupo do Pedido de Venda


/*------------------------------------------+
| Gera Array com Itens do Pedido de Venda	|
+------------------------------------------*/
dbSelectArea("SD1")
SD1->(dbSetOrder(1))
SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ))
While SD1->(!Eof()) .And.;
	SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	
	// -> Busca custo do produto
	_cProduto	:= SD1->D1_COD
	_cLocal		:= SD1->D1_LOCAL
	_nCusto		:= Custo(_cProduto,_cLocal,_dData)
	
	// -> Busca armaz้m PA da NF
	_cLocalPA	:= BuscaPA()
	
	// Se nใo encontrou PA, abre tela para digita็ใo
	If Alltrim(_cLocalPA) == ""                     
		MsgAlert("PA nใo encontrada! Por favor digite manualmente.")
		_cLocalPA := GetPA(_cProduto)
	EndIf                            
	
	MsgPA := _cLocalPA
	
	Aadd(_aItem,{{"C6_FILIAL",xFilial("SD1")	,Nil},;		// Filial
	{"C6_ITEM"   ,StrZero(_nItem,2) 			,Nil},;		// Numero do Item
	{"C6_PRODUTO",SD1->D1_COD					,Nil},;		// Codigo do Produto
	{"C6_NUM"    ,_cNumPed						,Nil},;		// Numero do Pedido de venda
	{"C6_QTDVEN" ,SD1->D1_QUANT					,Nil},; 	// Quantidade Vendida
	{"C6_PRCVEN" ,_nCusto		  				,Nil},;		// Preco Unitario Liquido
	{"C6_PRUNIT" ,_nCusto		  				,Nil},;		// Preco Unitario Liquido
	{"C6_VALOR"  ,Round(SD1->D1_QUANT*_nCusto,6),Nil},; 	// Valor Total do Item
	{"C6_TES"    ,_cTESPV						,Nil},; 	// Tipo de Entrada/Saida do Item  // mudar a TES
	{"C6_CLI"    ,_cCodCli						,Nil},; 	// Cliente
	{"C6_LOJA"   ,_cLjCli		  				,Nil},; 	// Loja do Cliente
	{"C6_LOCAL"  ,_cLocalPA		 				,Nil},; 	// Armazem - PA
	{"C6_XGPV"	 ,'PCA'			 				,Nil},; 	// Grupo do Pedido de Venda
	{"C6_ENTREG" ,dDataBase+5 					,Nil},; 	// Data da Entrega
	{"C6_UM"     ,SD1->D1_UM					,Nil},; 	// Unidade de Medida Primar.
	{"C6_SEGUM"	 ,SD1->D1_SEGUM					,Nil},;		// Segunda Unidade de medida
	{"C6_XHRINC" ,TIME()						,Nil},;		// Hora da inclusao
	{"C6_XDATINC",Date()		 				,Nil},;		// Data da inclusao
	{"C6_XUSRINC",cUsername 	 				,Nil}})		// Login do usuario
	
	_nItem++
	
	SD1->(dbSkip())
	
EndDo


// Verifica Arrays do pedido
If Len(_aSC5) > 0 
	
	If Len(_aItem) > 0
	
		// Atribui a PA na mensagem do Pedido [ mensagem que vai para a NF ]
		If _aSC5[17][2] <> Nil
			_aSC5[17][2] += MsgPA 
		EndIf
	
		// -> Gera o Pedido de venda
		llRet := U_TTGeraPV(_aSC5,_aItem)
		
		// -> Se gerado com sucesso
		If llRet .And. llRet <> Nil
			
			// Confirma n๚mero sequencial
			ConfirmSX8()
			cPVRecno := CValToChar(Recno())	// Salva o Recno do Pedido da SC5
			
			// Grava Flag de Pedido gerado na tabela SF1 e Recno do Pedido
			dbSelectArea("SF1")
			RecLock("SF1",.F.)
				SF1->F1_XPVDESF := 'S'			// Flag de controle
				SF1->F1_XPVDESR := cPVRecno		// Recno do Pedido
				
			SF1->(MsUnLock())
			
			
			// -> Texto para tela de Aviso
			_cAviso := "Foi gerado o Pedido de Venda de Descarte" + CRLF
			_cAviso += "N๚mero do pedido: "	+ _aSC5[2][2]		  + CRLF
			_cAviso += "Cliente: " 			+ _aSC5[4][2]	  	  + CRLF
			_cAviso += "Nome: " 			+ _aSC5[27][2]	  	  + CRLF
			_cAviso += "Loja: "				+ _aSC5[5][2]		  + CRLF
			
			// -> Texto para o Email
			// -> Assunto
			cSubject := "Pedido de Venda de Descarte Ref. Nota Fiscal: " +SF1->F1_DOC + "/"+SF1->F1_SERIE
			
			// -> Email
			// Cabe็alho
			cArqMail := "<html>"
			cArqMail += "<head>"
			cArqMail += "<title>Pedido de Descarte</title>"
			
			// Estilos
			cArqMail += "<style type='text/css'>"
			cArqMail += "	table.bordasimples {border-collapse: collapse;}"
			cArqMail += "	table.bordasimples tr td {border:1px solid "+cCorTable+";}"
			cArqMail += "	body { background-color: #FFFFFF;"
			cArqMail += "	color: #5D665B; "
			cArqMail += "	margin: 50px;"
			cArqMail += "	font-family: Georgia, 'Times New Roman', Times, serif;"
			cArqMail += "	font-size: small;"
		//	cArqMail += "	line-height: 180%;"
			cArqMail += " 	}"
			cArqMail += "</style>"
			cArqMail += "</head>"
		
			// Corpo	
			cArqMail += "<body>"
			cArqMail += "<p><strong>E-mail informativo referente ao Pedido de Venda de Descarte. </strong></p>"
			cArqMail += "<p>Para a Nota Fiscal de Entrada "+SF1->F1_DOC+"/"+SF1->F1_SERIE+" foi gerado o Pedido de Venda de Descarte, segue abaixo:</p>"
			cArqMail += "<p>&nbsp;</p>"
			
			// Tabela
			// Nota Fiscal
			cArqMail += "<p><strong>Nota Fiscal de Entrada</strong></p>"
			cArqMail += "<table class='bordasimples'>"
			cArqMail += "<tr>"
			cArqMail += "	<td>Filial da Nota Fiscal</td>"
			cArqMail += "	<td>"+SF1->F1_FILIAL+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>N๚mero da Nota Fiscal</td>"
			cArqMail += "	<td>"+SF1->F1_DOC+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>S้rie da Nota Fiscal</td>"
			cArqMail += "	<td>"+SF1->F1_SERIE+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>Tipo</td>"
			cArqMail += "	<td>Devolu็ใo</td>"	
			cArqMail += "</tr>"
			cArqMail += "</table>"
			cArqMail += "<p>&nbsp;</p>"
			
			// Pedido de Venda de Descarte gerado
			cArqMail += "<p><strong>Pedido de Venda de Descarte</strong></p>"
			cArqMail += "<table class='bordasimples'>"
			cArqMail += "<tr>"
			cArqMail += "	<td>Filial do Pedido de venda</td>"
			cArqMail += "	<td>"+ _aSC5[1][2]+"</td>"	
			cArqMail += "</tr>"                                 
			cArqMail += "<tr>"
			cArqMail += "	<td>N๚mero do Pedido de venda</td>"
			cArqMail += "	<td>"+ _aSC5[2][2]+"</td>"	
			cArqMail += "</tr>" 
			cArqMail += "<tr>"
			cArqMail += "	<td>C๓digo do Cliente</td>"
			cArqMail += "	<td>"+ _aSC5[4][2]+"</td>"	
			cArqMail += "</tr>"                                 
			cArqMail += "<tr>"
			cArqMail += "	<td>Loja do Cliente</td>"
			cArqMail += "	<td>"+ _aSC5[5][2]+"</td>"	
			cArqMail += "</tr>"                                  
			cArqMail += "<tr>"
			cArqMail += "	<td>Nome do Cliente</td>"
			cArqMail += "	<td>"+ _aSC5[27][2]+"</td>"	
			cArqMail += "</tr>"                                  
			cArqMail += "<tr>"
			cArqMail += "	<td>Data da Emissใo</td>"
			cArqMail += "	<td>"+ DtoC(dDataBase)+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>Usuแrio</td>"
			cArqMail += "	<td>"+_aSC5[21][2]+"</td>"	
			cArqMail += "</tr>"                                   
			cArqMail += "</table>"
			
			cArqMail += "<p>&nbsp;</p>"
			
			cArqMail += "<p>E-Mail automแtico enviado via protheus.</p>"
			cArqMail += "<p>Favor nใo responder.</p>"
			cArqMail += "</body>"
			cArqMail += "</html>
			
			// -> Envia email para o responsแvel da แrea
			If lSendMail
				lRetMail := U_TTMailN(cRemete,cTarget,cSubject,cArqMail,aAttach,.F.)
			EndIf

			// -> Se email foi enviado com sucesso		
			If ValType(lRetMail) == "L"
				If lRetMail 
					_cAviso += "Foi enviado e-mail para o responsแvel da แrea."
				Else
					_cAviso += "Erro ao enviar e-mail para o responsแvel da แrea." + CRLF
					_cAviso += "Favor comunicar sobre o Pedido gerado."
				EndIf
			EndIf	
				
		Else
			
			// Libera o n๚mero
			RollbackSX8()
			
			// Tela de Aviso
			_cAviso += "Ocorreu um erro ao gerar o Pedido de venda de descarte." + CRLF
			
			// -> Texto para o Email
			// -> Assunto
			cSubject := "Pedido de Venda de Descarte Ref. Nota Fiscal: " +SF1->F1_DOC + "/"+SF1->F1_SERIE
			
			// Cabe็alho
			cArqMail := "<html>"
			cArqMail += "<head>"
			cArqMail += "<title>Pedido de Descarte</title>"
			
			// Estilos
			cArqMail += "<style type='text/css'>"
			cArqMail += "	table.bordasimples {border-collapse: collapse;}"
			cArqMail += "	table.bordasimples tr td {border:1px solid "+cCorTable+";}"
			cArqMail += "	body { background-color: #FFFFFF;"
			cArqMail += "	color: #5D665B; "
			cArqMail += "	margin: 50px;"
			cArqMail += "	font-family: Georgia, 'Times New Roman', Times, serif;"
			cArqMail += "	font-size: small;"
		//	cArqMail += "	line-height: 180%;"
			cArqMail += " 	}"
			cArqMail += "</style>"
			cArqMail += "</head>"
		
			// Corpo	
			cArqMail += "<body>"
			cArqMail += "<p><strong>E-mail informativo referente ao Pedido de Venda de Descarte. </strong></p>"
			cArqMail += "<p>Houve erro ao gerar o Pedido de Descarte.</p>"
		
			cArqMail += "<p>&nbsp;</p>"
			
			// Tabela
			// Nota Fiscal
			cArqMail += "<p>Refer๊ncia: </p>"
			cArqMail += "<p><strong>Nota Fiscal de Entrada</strong></p>"
			cArqMail += "<table class='bordasimples'>"
			cArqMail += "<tr>"
			cArqMail += "	<td>Filial da Nota Fiscal</td>"
			cArqMail += "	<td>"+SF1->F1_FILIAL+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>N๚mero da Nota Fiscal</td>"
			cArqMail += "	<td>"+SF1->F1_DOC+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>S้rie da Nota Fiscal</td>"
			cArqMail += "	<td>"+SF1->F1_SERIE+"</td>"	
			cArqMail += "</tr>"
			cArqMail += "<tr>"
			cArqMail += "	<td>Tipo</td>"
			cArqMail += "	<td>Devolu็ใo</td>"	
			cArqMail += "</tr>"
			cArqMail += "</table>"
			cArqMail += "<p>&nbsp;</p>"
		
			cArqMail += "</p>E-Mail automแtico enviado via protheus.</p>"
			cArqMail += "</p>Favor nใo responder.</p>"
			cArqMail += "</body>"
			cArqMail += "</html>
			
			// -> Envia email para o responsแvel da แrea
			If lSendMail
				lRetMail := U_TTMailN(cRemete,cTarget,cSubject,cArqMail,aAttach,.F.)
			EndIf
			
			// -> Se email foi enviado com sucesso
			If ValType(lRetMail) == "L"
				If lRetMail
					_cAviso += "Foi enviado e-mail para o responsแvel da แrea."
				Else
					_cAviso += "Erro ao enviar e-mail para o responsแvel da แrea." +CRLF
				EndIf	
			EndIf
				
		EndIf
						
	Else
		_cAviso += "Inconsist๊ncia entre itens da Nota x itens do Pedido de Compra." +CRLF 
		_cAviso += "Nใo foi possํvel gerar o Pedido de Venda."
	EndIf	
Else
	_cAviso += "Inconsist๊ncia no cabe็alho do Pedido de Venda." +CRLF
	_cAviso += "Nใo foi possํvel gerar o Pedido de Venda."
EndIf

// Mostra Aviso na tela
Aviso("GERAPEDIDO",_cAviso,{"Ok"},3)


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCusto  บAutor  ณJackson E. de Deus     บ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca custo do produto.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ _cProduto - C๓d. do produto                                บฑฑ
ฑฑบ			 ณ _cLocal	 - Local										  บฑฑ
ฑฑบ			 ณ _dData	 - Data do ultimo fechamento					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ nCusto	 - Custo do produto			                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MT100AGR                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Custo(_cProduto,_cLocal,_dData)

Local cQry
Local nCusto := 0 
Local alAreaSB1                

// -> Monta Query para consulta
cQry := "SELECT TOP 1 SB9.B9_FILIAL, SB9.B9_COD, SB9.B9_LOCAL, SB9.B9_DATA, SB9.B9_CUSTD AS CUSTO "
cQry += "FROM "+RetSQLName("SB9")+" AS SB9 "
cQry += "WHERE "
cQry += "SB9.B9_FILIAL = '"+xFilial("SB9")+"' AND "
cQry += "SB9.B9_COD = '"+_cProduto+"' AND "
cQry += "SB9.B9_LOCAL = '"+_cLocal+"' AND "
cQry += "SB9.B9_DATA >= '"+DTOS(_dData)+"' AND "
cQry += "SB9.D_E_L_E_T_ <> '*'"

cQry := ChangeQuery(cQry)

If Select("TRB9") > 0
	TRB9->(dbCloseArea())
EndIf
                        

TCQUERY cQry NEW ALIAS "TRB9"

dbSelectArea("TRB9")
dbGoTop()
While !EOF()
	
	nCusto := TRB9->CUSTO
	
	TRB9->(Dbskip())
		
End

TRB9->(dbCloseArea())
  

// -> Se custo nใo for encontrado em SB9 ou for zero, pega custo standard do cadastro de produtos
If nCusto == 0

	dbSelectArea("SB1")
	alAreaSB1 := GetArea()
	dbSetOrder(1)		// Filial + Codigo
	If dbSeek( xFilial("SB1")+_cProduto)
    
    	nCusto := SB1->B1_CUSTD
	
	EndIf  
    RestArea(alAreaSB1)
           
EndIf


Return (nCusto)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldNF  บAutor  ณJackson E. de Deus    บ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se NF possui TES utilizadas para descarte.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ cNF	- N๚mero da NF	                                      บฑฑ
ฑฑบ			 ณ cTes - Range de TES utilizadas em NF de descarte			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ llVld - .T. ou .F.	                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MT100AGR                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldNF(cNF, cTes)

Local cQry
Local nTotal := 0
Local llVld	 := .F.
Local cTes2	 := ""
Local cSep	 := "#"
Local nX

// -> Separa as TES do parametro em uma s๓ variแvel para clausula WHERE 
// -> Padrใo do parโmetro	-	val1#val2#val3
// -> Padrใo da Query		-	'val1','val2','val3'
If AT(cSep,cTes) > 0

	For nX := 1 To Len(cTes)
		
		If nX == 1
			cTes2 += "'"
		EndIf
		
		If !(SubStr(cTes,nX,1) $ cSep)
			cTes2 += SubStr(cTes,nX,1)
			If nX == Len(cTes)
				cTes2 += "'"
			EndIf
		Else
			If nX <> Len(cTes)
				cTes2 += "','"
			Else
				cTes2 += "'"	
			EndIf	
		EndIf
    	
	Next nX

EndIf        


  
// -> Monta Query para consulta
cQry := "SELECT COUNT(*) AS TOTAL "
cQry += "FROM "+RetSQLName("SD1")+" AS SD1 "
cQry += "WHERE "
cQry += "D1_FILIAL = '"+xFilial("SD1")+"' AND "
cQry += "D1_DOC = '"+cNF+"' AND "
cQry += "D1_TES IN ("+cTes2+") AND " 
cQry += "D1_TIPO = 'D' AND "
cQry += "D_E_L_E_T_ <> '*'"

If Select("TRBX") > 0
	TRBX->(dbCloseArea())
EndIf
                        

TCQUERY cQry NEW ALIAS "TRBX"
  
dbSelectArea("TRBX")
dbGoTop()
While !EOF()
	
	nTotal := TRBX->TOTAL
	
	TRBX->(dbSkip())
		
End

TRBX->(dbCloseArea())  

// -> Se existe registro com TES especificada, retorna TRUE           
If nTotal > 0
	llVld := .T.
EndIf 
    

Return (llVld)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscaPA บAutor  ณJackson E. de Deus    บ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca armaz้m PA do produto da NF de origem.		          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ 	                                      					  บฑฑ
ฑฑบ			 ณ 															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ cRet	                                      				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MT100AGR                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BuscaPA()

Local cQry		:= ""
Local cRet		:= ""

cQry += "SELECT "
cQry += "SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_NFORI, SD1.D1_SERIORI, "
cQry += "SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_COD, SD2.D2_XCODPA AS XCODPA "
cQry += "FROM "+RetSQLName("SD1")+ " AS SD1 "

cQry += "INNER JOIN "+RetSqlName("SD2")+ " AS SD2 ON "
cQry += "SD1.D1_NFORI = SD2.D2_DOC AND "
cQry += "SD1.D1_SERIORI = SD2.D2_SERIE AND "
cQry += "SD1.D1_FORNECE = SD2.D2_CLIENTE AND "
cQry += "SD1.D1_LOJA = SD2.D2_LOJA AND "
cQry += "SD1.D1_FILIAL = SD2.D2_FILIAL AND "
cQry += "SD1.D1_COD = SD2.D2_COD AND "
cQry += "SD1.D_E_L_E_T_ = SD2.D_E_L_E_T_ "

cQry += "WHERE  "
cQry += "SD1.D1_DOC 	= '"+SD1->D1_DOC+"' 	AND "
cQry += "SD1.D1_FORNECE = '"+SD1->D1_FORNECE+"' AND "
cQry += "SD1.D1_LOJA	= '"+SD1->D1_LOJA+"' 	AND "
cQry += "SD1.D1_COD		= '"+SD1->D1_COD+"' 	AND "
cQry += "SD1.D1_FILIAL	= '"+SD1->D1_FILIAL+"' 	AND "
cQry += "SD1.D_E_L_E_T_ = '' "


If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
                        

TCQUERY cQry NEW ALIAS "TRBZ"
  
dbSelectArea("TRBZ")
dbGoTop()
While !EOF()
	// Salva a PA da nota de origem
	cRet := TRBZ->XCODPA
	
	TRBZ->(dbSkip())
		
End

TRBZ->(dbCloseArea())  

Return cRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPA     บAutor  ณJackson E. de Deus  บ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta tela para digita็ใo da PA                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParam.    ณ _cProduto                              					  บฑฑ
ฑฑบ			 ณ 															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ cCodPA                                     				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetPA(_cProduto)

Local oDlgImp
Local oGrp1
Local cDescPA	:= ""	
Private cCodPA	:= ""
Private lVld	:= .F.

While !lVld

	DEFINE MSDIALOG oDlgImp TITLE "PA - Produto: "+_cProduto From 0,0 to 130,350 PIXEL
	
	
	@ 003,002 GROUP oGrp1 TO 050,175 OF oDlgImp LABEL "PA"  PIXEL
	cCodPA 		:= CriaVar("ZZ1_COD")
	cDescPA		:= CriaVar("ZZ1_DESCRI")
	
	@ 015,015 Say "PA"
	@ 015,050 Get cCodPA 		Picture "@!"	Size 90,15 F3 "ZZ1" VALID cDescPA := ZZ1->ZZ1_DESCRI
	
	@ 030,015 Say "Descri็ใo"
	@ 030,050 Get cDescPA 		Picture "@!"	Size 120,15 WHEN .F.
	
	
	// Botao "Confirma"
	DEFINE SBUTTON FROM 050,148 TYPE 1 ACTION VldCampo(@oDlgImp)/*End()*/ ENABLE OF oDlgImp
	
	// Ativa a tela centralizada
	ACTIVATE DIALOG oDlgImp CENTER
	
End

  
Return cCodPA


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCampo  บAutor  ณMicrosiga           บ Data ณ  06/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida valor do campo GET da tela, para que nใo seja vazio.บฑฑ
ฑฑบ			 ณ Com base nisso o programa deixa o usuแrio sair da tela.	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldCampo(oDlgImp)

If Alltrim(cCodPA) <> "" .OR. !Empty(cCodPA)
	lVld := .T.     
	
	// Fecha Dialogo
	Close(oDlgImp)
EndIf       

Return 