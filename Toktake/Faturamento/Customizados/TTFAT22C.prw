#include "topconn.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22CบAutor  ณJackson E. de Deus    บ Data ณ  27/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaturamento de Orcamentos - Fechamento					  บฑฑ
ฑฑบ          ณAbastecimento												  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ27/04/15ณ01.00 |Criacao                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TTFAT22C()
                                  
//Local oSize			:= FwSize():New( .F. )
Local aSize			:= MsAdvSize()
Local aSize2		:= {}
Local nWdtRdp		:= aSize[5]/2
Local cUsrPerm		:= "JDEUS"
Private _lAglCli	:= .F.
Private _aTabela	:= {} 
Private _lRatear	:= .F.	// ratear faturamento em percentual
Private _aRateio	:= {}  
Private _lSepLoja	:= .F.	// separar pedidos por loja (de acordo com grid)
Private _nMinimo	:= 0
Private _nMinimo2	:= 0
Private _aLojas		:= {}
Private _lFiltrado	:= .F.
Private _lProRata	:= .F.
Private _lFatCLDif	:= .F.	// faturamento diferenciado? cliente ou loja diferente?
Private	_cTpFat		:= ""	// tipo de faturamento - cliente/loja
Private	_cCliFat	:= ""	// cliente de faturamento
Private	_cLjFat		:= ""	// loja de faturamento
Private _cCodTab	:= ""	// tabela para buscar dose complementar
Private _cCondPg	:= ""	// condicao pagamento contrato
Private _cContt		:= ""
Private oDlg
Private oLayer		:= FwLayer():New()
Private oPnl1
Private oPnl2
Private oList2
Private oList3
Private oMenu2
Private oSim		:= LoadBitMap(GetResources(), "LBOK")
Private oNao		:= LoadBitMap(GetResources(), "LBNO")
Private oFim		:= LoadBitMap(GetResources(), "BR_PRETO")
Private oSVal
Private _cCliCnt	:= ""
Private _cLjCnt		:= ""
Private cLoja		:= "0001"
Private dDtIni		:= FirstDay(dDatabase)
Private dDtFim		:= LastDay(dDatabase)
Private aList2		:= {}
Private aList2Bkp	:= {}
Private aList3		:= {}
Private aList3Bkp	:= {}
Private _aList4		:= {}
Private _aList5		:= {}
Private aProdutos	:= {}
Private nValTot		:= 0	// valor total do pedido a ser gerado
Private cQtdTotal	:= ""
Private cNomeCli	:= ""
Private _cMenNOta	:= ""
Private _cNotas		:= ""
Private _cDoseComp	:= If(cEmpAnt=="01",SuperGetMV("MV_XFAT011",.T.,"1001896"),"")
Private _nQuantP	:= 0
Private _aMaqCnt	:= {}
Private cTpContr		:= ""


If cEmpAnt <> "01"
	Return
EndIF

If Type("__cinternet") <> "U"
	If __cinternet == "AUTOMATICO"
		prepare environment empresa "01" filial "01"
	EndIf
EndIf

// log de acesso
U_TTGENC01( xFilial("SCJ"),"FECHAMENTO","FECHAMENTO DO FATURAMENTO","","","",cUserName,dtos(date()),time(),,"ENTROU",,,"SCJ" )     



// valores iniciais para carregamento dos objetos tcBrowse
AADD( aList2, { .F., "", DTOC(STOD("")), 0, 0, "","","","","","","","" } )
AADD( _aList4, { .F., "", DTOC(STOD("")), 0, 0, "","","","","","","","" } )
AADD( aList3, { "","", 0, 0.0,0.0,0.0  } )
_aList5 := { { "","","","","","" } }	 

If cUserName $ cUsrPerm
  	SetKey(VK_F4, { || NfRem() } )           
	SetKey(VK_F11, { || AjustePrc() } )
	//SetKey(VK_F12, { || Reproc() } )
EndIf	


// Janela
oDlg := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Faturamento",,,.F.,,,,,,.T.,,,.T. )
	oDlg:lEscClose := .F.
	oDlg:lMaximized := .T.
		
	oPanel3 := tPanel():New(0,0,"",oDlg,,,,,,0,30)
	oPanel3:SetCss( "QLabel { background-color: #E1E1E1; }" )	
	oPanel3:align := CONTROL_ALIGN_BOTTOM
    
	oPanel := tPanel():New(0,0,"",oDlg,,,,,,0,150)
	oPanel:align := CONTROL_ALIGN_BOTTOM
	
	oPanelX := tPanel():New(0,0,"",oDlg,,,,,,0,10)
	oPanelX:SetCss( "QLabel { background-color: #E1E1E1; }" )	
	oPanelX:align := CONTROL_ALIGN_BOTTOM  

	oFld1 := TFolder():New( 0,0,{ "Or็amentos PE","Or็amentos PP","Hist๓rico de pedidos" },{},oDlg,,,,.T.,.F.,0,0,)
	oFld1:Align := CONTROL_ALIGN_ALLCLIENT
	
	 	                
	// menu orcamentos PE
	MENU oMenu POPUP
		MENUITEM "Visualizar or็amento"	ACTION ( Visual(1,oList2:nAt) )
		MENUITEM "Visualizar pedido"	ACTION ( Visual(2,oList2:nAt) )
		MENUITEM "Visualizar nota"		ACTION ( Visual(3,oList2:nAt) )
		MENUITEM "Cancelar pedido"		ACTION ( IIF( ChkPerm(1),Cancel(oList2:nAt),  ) )
	ENDMENU
	
	// menu orcamentos PP
	MENU oMenu2 POPUP
		//MENUITEM "Visualizar or็amento"	ACTION ( Visual(1,_aList4:nAt) )
		MENUITEM "Visualizar pedido"	ACTION ( VisPed( _aList4[oList4:nAt][10] ) )
		//MENUITEM "Visualizar nota"		ACTION ( Visual(3,_aList4:nAt) )
		MENUITEM "Cancelar pedido"		ACTION ( IIF( ChkPerm(1),CancPed(_aList4[oList4:nAt][10],2),  ) )
	ENDMENU
	
						
	// orcamentos PE			
	oList2 := TCBrowse():New(0,0,0,0,,{"","Or็amento","Emissใo","Valor","Patrim๔nio","Modelo","PA","Descri็ใo","Loja","Pedido","Nota fiscal"},;
						{5,40,40,50,50,100,40,100,60,60,60},oFld1:aDialogs[1],,,,{ ||  },{ || },,,,,,"Or็amentos PE",.F.,,.T.,,.F.,,.T.,.T.,)
	
	oList2:Align	:= CONTROL_ALIGN_ALLCLIENT
	oList2:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oList2:bLDblClick := { || MarkOrc(),oList2:DrawSelect() }
	oList2:bHeaderClick := { || HeadClk(),oList2:DrawSelect() }  
	oList2:SetArray(aList2)
	oList2:bLine := { || { IIF( Empty(aList2[oList2:nAt,10]),IIF(aList2[oList2:nAt,1],oSim,oNao), oFim ),;		// flag
							aList2[oList2:nAt,2],;												// orcamento
							aList2[oList2:nAt,3],;												// emissao
							Transform( aList2[oList2:nAt,4],PesqPict("SF2","F2_VALBRUT") ),;	// valor total
							aList2[oList2:nAt,5],;												// maquina
							aList2[oList2:nAt,6],;												// modelo
							aList2[oList2:nAt,7],;												// PA
							aList2[oList2:nAt,8],;												// Desc PA
							aList2[oList2:nAt,9],;												// Loja
							aList2[oList2:nAt,10],;												// Pedido
							aList2[oList2:nAt,11]}}					   							// Nota					
						
	
	// orcamentos PP
	oList4 := TCBrowse():New(0,0,0,0,,{"","Or็amento","Emissใo","Valor","Patrim๔nio","Modelo","PA","Descri็ใo","Loja","Pedido","Nota fiscal"},;
						{5,40,40,50,50,100,40,100,60,60,60},oFld1:aDialogs[2],,,,{ || UpdRdp()  },{ || },,,,,,"Or็amentos PP",.F.,,.T.,,.F.,,.T.,.T.,)
	
	oList4:Align	:= CONTROL_ALIGN_ALLCLIENT
	oList4:bRClicked := { |oObject,nX,nY| oMenu2:Activate( nX, (nY-10), oObject ) }
	oList4:SetArray( _aList4 )
	
	oList4:bLine := { || { IIF( Empty(_aList4[oList4:nAt,10]),IIF(aList2[oList4:nAt,1],oSim,oNao), oFim ),;		// flag
							_aList4[oList4:nAt,2],;												// orcamento
							_aList4[oList4:nAt,3],;												// emissao
							Transform( _aList4[oList4:nAt,4],PesqPict("SF2","F2_VALBRUT") ),;	// valor total
							_aList4[oList4:nAt,5],;												// maquina
							_aList4[oList4:nAt,6],;												// modelo
							_aList4[oList4:nAt,7],;												// PA
							_aList4[oList4:nAt,8],;												// Desc PA
							_aList4[oList4:nAt,9],;												// Loja
							_aList4[oList4:nAt,10],;											// Pedido
							_aList4[oList4:nAt,11]}}					   						// Nota	
	
	
	// historico
	oList5 := TCBrowse():New(0,0,0,0,,,,oFld1:aDialogs[3],,,,{ ||  },{ || },,,,,,"Hist๓rico",.F.,,.T.,,.F.,,.T.,.T.,)
	oList5:SetArray( _aList5 )
	
	oList5:AddColumn(TCColumn():New( "Pedido"		,{|| _aList5[oList5:nAt,01] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList5:AddColumn(TCColumn():New( "Emissใo"		,{|| _aList5[oList5:nAt,02] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList5:AddColumn(TCColumn():New( "Finalidade"	,{|| _aList5[oList5:nAt,03] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList5:AddColumn(TCColumn():New( "Cliente"		,{|| _aList5[oList5:nAt,04] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList5:AddColumn(TCColumn():New( "Nota"			,{|| _aList5[oList5:nAt,05] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList5:AddColumn(TCColumn():New( "S้rie"		,{|| _aList5[oList5:nAt,06] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	             	
	oList5:Align	:= CONTROL_ALIGN_ALLCLIENT
    
	
	// produtos consolidados					
	oList3 := TCBrowse():New(0,0,0,0,,{"Produto","Descri็ใo","Qtd","Pre็o Empresa","Pre็o P๚blico","Total"},{50,100,30,45,45,20},;
						oPanel,,,,{ ||  },{ || },,,,,,"Produtos consolidados",.F.,,.T.,,.F.,,.T.,.T.,)
	oList3:Align	:= CONTROL_ALIGN_ALLCLIENT						 
	oList3:SetArray(aList3) 
	oList3:bLine := { || { aList3[oList3:nAt,01],;
						aList3[oList3:nAt,02],;
						aList3[oList3:nAt,03],;
						Transform( aList3[oList3:nAt,04],PesqPict("SCK","CK_PRCVEN") ),;
						Transform( aList3[oList3:nAt,06],PesqPict("SCK","CK_PRCVEN") ),;
						Transform( aList3[oList3:nAt,05],PesqPict("SCK","CK_VALOR") ) }}
	
	
	 
	oLbl := TSay():New( 2,01,{ || "Produtos" },oPanelX,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,12,,,,,,.F. )	
	oLbl:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	
	
	oSVT := TSay():New( 2,05,{ || "Valor total" },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,12,,,,,,.F. )	
	oSVT:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	
	oSVal := TSay():New( 2,40,{ || cQtdTotal },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,15,,,,,,.F. )	
	oSVal:SetCss( "QLabel {font: bold 12px; color: #B2246B; }" )
		
	oMinimo := TSay():New( 10,05,{ || "Mํnimo contrato: " +cvaltochar(_nMinimo) },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,12,,,,,,.F. )	
	oMinimo:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	
	oTotAp := TSay():New( 18,05,{ || "Total apurado:" },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,12,,,,,,.F. )	
	oTotAp:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	
	oTotAp2 := TSay():New( 18,50,{ || "" },oPanel3,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,15,,,,,,.F. )	
	oTotAp2:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	
	
	oBtNF := TButton():New( 05, nWdtRdp-280,"Parametros",oPanel3,{ || fParam()  },040,015,,,,.T.,,"Parโmetros",,,,.F. )
	oBtNF:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:bmpperg.png); background-repeat: none; margin: 1px }" )			
   	
   	oBtPrc := TButton():New( 05, nWdtRdp-240,"Reaj. Pre็o",oPanel3,{ || AjustePrc()  },040,015,,,,.T.,,"Reajustar pre็os",,,,.F. )
	oBtPrc:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:RECALC.png); background-repeat: none; margin: 1px }" )			
   	
	
	oBtPar := TButton():New( 05, nWdtRdp-200,"Notas",oPanel3,{ || NfRem()  },040,015,,,,.T.,,"Configurar notas de remessa",,,,.F. )
	oBtPar:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:VERNOTA.png); background-repeat: none; margin: 1px }" )			
   	//oBtPar:SetPopupMenu(oMenu2)
   	
   	oBtfiltro := TButton():New( 05, nWdtRdp-160,"Filtro",oPanel3,{ || Filtro()  },040,015,,,,.T.,,"Filtro dos or็amentos",,,,.F. )
	oBtfiltro:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:FILTRO.png); background-repeat: none; margin: 1px }" )			
   	
   	oBtRel := TButton():New( 05, nWdtRdp-120,"Relat๓rio",oPanel3,{ || Relatorio()  },040,015,,,,.T.,,"Relat๓rio de consumo",,,,.F. )
	oBtRel:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:HISTORIC.png); background-repeat: none; margin: 1px }" )			
   	   					
	oBtPed := TButton():New( 05, nWdtRdp-80,"Pedido",oPanel3,{ || Pedido()  },040,015,,,,.T.,,"Gerar os pedidos",,,,.F. )
	oBtPed:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:PEDIDO.png); background-repeat: none; margin: 1px }" )			
   											
   	oBtSair := TButton():New( 05, nWdtRdp-40,"Sair",oPanel3,{ || oDlg:End() },040,015,,,,.T.,,"Sair",,,,.F. )
	oBtSair:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:final.png); background-repeat: none; margin: 1px }" )			
	           
	oList2:nScrollType := 1
	oList3:nScrollType := 1  
	oList4:nScrollType := 1 
	oList5:nScrollType := 1
	
	RefshTela()
	
oDlg:Activate(,,,.T.) 

If Type("__cinternet") <> "U"
	If __cinternet == "AUTOMATICO"
		reset environment
	EndIf
EndIf   

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfParam  บAutor  ณJackson E. de Deus    บ Data ณ  07/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fParam()

Local aPergs		:= {}
Local aRet			:= {}


//aAdd(aPergs ,{1,"Cliente"		,Space(6),"@!",".T.","SA1",".T.",60,.F.}) 
aAdd(aPergs ,{1,"Contrato"		,Space(TamSx3("CN9_NUMERO")[1]),"@!",".T.","CN9",".T.",60,.F.}) 
aAdd(aPergs ,{1,"Data inicio"	,dDatabase,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{1,"Data fim"		,dDatabase,"99/99/99","","","",50,.F.})

If !ParamBox(aPergs ,"Faturamento",@aRet)
	Return                                     
Else
	//_cCliCnt := aRet[1] 
	_cContt := aRet[1]
   	dDtIni := aRet[2]
	dDtFim := aRet[3]
EndIf

//cNomeCli := Posicione("SA1",1,xFilial("SA1")+_cCliCnt,"A1_NOME")		

CursorWait()
MsAguarde( { || Carga() },"Aguarde, carregando dados.." )
CursorArrow()

EncheList()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEncheList  บAutor  ณJackson E. de Deus บ Data ณ  07/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EncheList()


// Orcamentos cliente  
oList2:SetArray(aList2)
oList2:bLine := { || { IIF( Empty(aList2[oList2:nAt,10]),IIF(aList2[oList2:nAt,1],oSim,oNao), oFim ),;
						aList2[oList2:nAt,2],;						// orcamento
						aList2[oList2:nAt,3],;						// emissao
						Transform( aList2[oList2:nAt,4],PesqPict("SF2","F2_VALBRUT") ),;	// valor total
						aList2[oList2:nAt,5],;						// maquina
						aList2[oList2:nAt,6],;						// modelo
						aList2[oList2:nAt,7],;						// PA
						aList2[oList2:nAt,8],;						// Desc PA
						aList2[oList2:nAt,9],;						// Loja
						aList2[oList2:nAt,10],;						// Pedido
						aList2[oList2:nAt,11]}}						// Nota


// Produtos
oList3:SetArray(aList3) 
oList3:bLine := { || { aList3[oList3:nAt,01],;
					aList3[oList3:nAt,02],;
					aList3[oList3:nAt,03],;
					Transform( aList3[oList3:nAt,04],PesqPict("SCK","CK_PRCVEN") ),;
					Transform( aList3[oList3:nAt,06],PesqPict("SCK","CK_PRCVEN") ),;
					Transform( aList3[oList3:nAt,05],PesqPict("SCK","CK_VALOR") ) }}
						

If !Empty( _aList4 )
	//oList4:Enable()  
	oList4:SetArray( _aList4 )
	oList4:bLine := { || { IIF( Empty(_aList4[oList4:nAt,10]),IIF(_aList4[oList4:nAt,1],oSim,oNao), oFim ),;		// flag
						_aList4[oList4:nAt,2],;												// orcamento
						_aList4[oList4:nAt,3],;												// emissao
						Transform( _aList4[oList4:nAt,4],PesqPict("SF2","F2_VALBRUT") ),;	// valor total
						_aList4[oList4:nAt,5],;												// maquina
						_aList4[oList4:nAt,6],;												// modelo
						_aList4[oList4:nAt,7],;												// PA
						_aList4[oList4:nAt,8],;												// Desc PA
						_aList4[oList4:nAt,9],;												// Loja
						_aList4[oList4:nAt,10],;											// Pedido
						_aList4[oList4:nAt,11]}}					   						// Nota	
	//oList4:Refresh(.T.)
	//oList4:Enable()    
	oList4:Refresh(.T.)
	//oFld1:Refresh()
EndIf


oList5:SetArray( _aList5 )
oList5:Refresh(.T.)

oList2:nScrollType := 1
oList3:nScrollType := 1
oList4:nScrollType := 1
oList5:nScrollType := 1


RefshTela()

Return

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFiltro    บAutor  ณJackson E. de Deus  บ Data ณ  07/16/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Filtro()

Local aOpc := {"Nenhum","Patrim๔nio","PA","Loja"}
Local oDlgX
Local oGet1,oBtn    
Local oPanel
Local oFont := TFont():New('Arial',,16,,.T.,,,,,.F.,.F.)
Private oCBox1
Private cPesq := Space(6)
Private cCombo := aOpc[1]


oDlgX := MSDialog():New(0,0,100, 412,"Filtro",,,,,,,,,.T.,,,,.T.)
	oPanel := tPanel():New(0,0,"",oDlgX,,,,CLR_BLACK,CLR_WHITE,0,0)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT
	oPanel:SetCss( "QLabel { background-color: #E1E1E1; }" )		
	
	oCBox1 := TComboBox():New( 20,10,{|u|if( PCount()>0,cCombo:=u,cCombo )},aOpc,070,15,oPanel,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo)	
	oCBox1:SetHeight(30)
	oCBox1:SetCSS("QComboBox { border: 1px solid gray; border-radius: 3px; padding: 1px 18px 1px 3px; min-width: 6em; background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #D3D3D3, stop: 0.4 #D8D8D8, stop: 0.5 #DDDDDD, stop: 1.0 #E1E1E1); } ")
	
	oGet1 := TGet():New( 20,81,{ |u| If( Pcount()>0,cPesq:=u,cPesq ) },oPanel,070,13,'',,CLR_BLACK,CLR_WHITE,oFont,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,,,,,"Digite")					                                                                                          
	oGet1:SetCss("QLineEdit { border: 1px solid gray; border-radius: 3px; color: #5C5C99; font: 16px; }")
	
	oBtn := TButton():New( 20,152,"Confirmar",oPanel,{ || ExecFil(), oDlgX:End() },050,15,,,,.T.,,"",,,,.F. )
	oBtn:SetCss( "QPushButton{ border: 1px solid gray; border-radius: 3px; background-image: url(rpo:FILTRO.png); background-repeat: none; margin: 1px }" )			
oDlgX:Activate(,,,.T.,{|| },,{ || } )


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFil   บAutor  ณJackson E. de Deus  บ Data ณ  07/16/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFil()

Local nPos := 0    
Local nPosPat := 5
Local nPosPA := 7
Local nPosLj := 9
Local aAux := {}  


IIF(oCBOX1 <> NIL .Or. oCBOX1 == 0,nPos := oCBOX1:nAt,1)

// desfaz filtro
If nPos == 1 .And. Empty(cPesq) .And. !ArrayCompare(aList2,aList2Bkp)
	aList2 := Aclone(aList2Bkp)
Else
	If !_lFiltrado
		aList2Bkp := Aclone(aList2)
		aList3Bkp := Aclone(aList3)
	EndIf
	
	
	// patrimonio
	If nPos == 2
		For nI := 1 To Len(aList2)
			If AllTrim(aList2[nI][nPosPat]) == AllTrim(cPesq)
				AADD( aAux, aList2[nI] )
			EndIf
		Next nI
		
	// PA
	ElseIf nPos == 3
		For nI := 1 To Len(aList2)
			If AllTrim(aList2[nI][nPosPA]) == AllTrim(cPesq)
				AADD( aAux, aList2[nI] )
			EndIf
		Next nI
	// Loja
	ElseIf nPos == 4
		For nI := 1 To Len(aList2)
			If AllTrim(aList2[nI][nPosLj]) == AllTrim(cPesq)
				AADD( aAux, aList2[nI] )
			EndIf
		Next nI
	EndIf
	
	If !Empty(aAux)
		If !ArrayCompare(aAux,aList2)
			aList2 := aClone(aAux)
			_lFiltrado := .T.
		EndIf
	EndIf
EndIf

oList2:SetArray(aList2) 
oList2:bLine := { || { IIF( Empty(aList2[oList2:nAt,10]),IIF(aList2[oList2:nAt,1],oSim,oNao), oFim ),;
							aList2[oList2:nAt,2],;						// orcamento
							aList2[oList2:nAt,3],;						// emissao
							Transform( aList2[oList2:nAt,4],PesqPict("SF2","F2_VALBRUT") ),;	// valor total
							aList2[oList2:nAt,5],;						// maquina
							aList2[oList2:nAt,6],;						// modelo
							aList2[oList2:nAt,7],;						// PA
							aList2[oList2:nAt,8],;						// Desc PA
							aList2[oList2:nAt,9],;						// Loja
							aList2[oList2:nAt,10],;						// Pedido
							aList2[oList2:nAt,11]}}						// Nota

oList2:Refresh()
RefshTela()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelatorio  บAutor  ณJackson E. de Deus บ Data ณ  07/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Relatorio()

Local oExcel := FWMSEXCEL():New()
Local cArqXls := "consumo_doses.xml"
Local cSheet1 := "Doses_Total"
Local cSheet2 := "Doses_por_Maquina"
Local cSheet3 := "Contadores"
Local cDoseCompl := _cDoseComp	//"1001896"
Local nI
Local nJ
Local cDir := "" 
Local nQuant := 0
Local nTotal := 0
Local nQtdSub := 0
Local nPrcSub := 0
Local nPOs := 0
Local aMAq := {}
Local aDoses := {}
Local aProd := {}
Local dAnt := stod("")
Local dAtu := stod("")
Local nSaleAnt := 0
Local nSaleAtu := 0
Local nTotSale := 0
Local aBots := {}
Local nTotB := 0
Local nPrcCompl := 0
Local nSangra := 0
Local nTotFat := 0
Local aAuxCnt := {}
Local aPRECO := {}
Local aLinha := {}
Local cTabPrc := ""
Local nVenda := 0
Local nPosL := 0
Local nDose := 0


cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
If Empty(cDir)
	MsgAlert("Escolha um diret๓rio vแlido!")
	Return
EndIf
                                          
CursorWait()

//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Contrato: ", _cContt } )
oExcel:AddRow("Parametros","Parametros",{"Data de: ", dtoc(dDtIni) } )
oExcel:AddRow("Parametros","Parametros",{"Data ate: ", dtoc(dDtFim) } )
oExcel:AddRow("Parametros","Parametros",{"Total: ",  cQtdTotal } )
oExcel:AddRow("Parametros","Parametros",{"Minimo do contrato: ", cvaltochar(_nMinimo) } )


oExcel:AddworkSheet(cSheet1) 
oExcel:AddTable (cSheet1,"Relatorio")
oExcel:AddColumn(cSheet1,"Relatorio","Dose",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Descri็ใo",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Quantidade",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Pre็o empresa",1,3)
oExcel:AddColumn(cSheet1,"Relatorio","Total",1,3)

oExcel:AddworkSheet(cSheet2) 
oExcel:AddTable (cSheet2,"Relatorio")
oExcel:AddColumn(cSheet2,"Relatorio","Dose",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Descri็ใo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Quantidade",1,2)
oExcel:AddColumn(cSheet2,"Relatorio","Pre็o empresa",1,3)
oExcel:AddColumn(cSheet2,"Relatorio","Pre็o p๚blico",1,3)
oExcel:AddColumn(cSheet2,"Relatorio","Venda",1,3) // novo
oExcel:AddColumn(cSheet2,"Relatorio","Total",1,3) 


oExcel:AddWorkSheet(cSheet3)
oExcel:AddTable (cSheet3,"Relatorio")
oExcel:AddColumn(cSheet3,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Instala็ใo",1,4)
oExcel:AddColumn(cSheet3,"Relatorio","Leitura anterior",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Leitura atual",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Contador anterior",1,2)
oExcel:AddColumn(cSheet3,"Relatorio","Contador atual",1,2)
oExcel:AddColumn(cSheet3,"Relatorio","Diferen็a",1,2)

For nI := 1 To 12
	oExcel:AddColumn(cSheet3,"Relatorio","P" +cvaltochar(nI),1,2)
	oExcel:AddColumn(cSheet3,"Relatorio","PE",1,2)
	oExcel:AddColumn(cSheet3,"Relatorio","PP",1,2)
Next nI
                                           
oExcel:AddColumn(cSheet3,"Relatorio","Total Ps",1,2)
oExcel:AddColumn(cSheet3,"Relatorio","Sangria",1,2)



// sheet 1
For nI := 1 To Len(aList3)
	If aList3[nI][1] != cDoseCompl
		nQuant += aList3[nI][3]
		nTotal += aList3[nI][5]
	EndIf
	
	If aList3[nI][1] == cDoseCompl
		oExcel:AddRow(cSheet1,"Relatorio",{"",; 
										"Sub-Total",;
										nQuant,;
										"",;
										nTotal })
	EndIf
	
	oExcel:AddRow(cSheet1,"Relatorio",{aList3[nI][1],; 
										aList3[nI][2],;
										aList3[nI][3],;
										aList3[nI][4],;
										aList3[nI][5] })
										
	If nI == Len(aList3)
		oExcel:AddRow(cSheet1,"Relatorio",{"",; 
									"Total",;
									nQuant,;
									"",;
									nTotal })
		
	EndIf
Next nI

// sheet 2
aExc := {}
For nI := 1 To Len(aProdutos)
	nPOs := Ascan( aList2, { |x| x[2] == aProdutos[nI][6] } )
	If nPOs > 0
		If ! aList2[nPos][1]
			AADD( aExc, nI )
			Loop
		EndIf     
	EndIf

	If Ascan( aMAq, { |x| x[1] == aProdutos[nI][10] } ) == 0 
		AADD( aMAq, { aProdutos[nI][10], {} } )
	EndIf
Next nI                                

For nI := 1 To Len(aMAq)
	For nJ := 1 To Len(aProdutos)
		nPos := AScan( aExc, { |x| x == nJ } )
		If nPOs > 0
			Loop
		EndIf
		
		If aMAq[nI][1] == aProdutos[nJ][10]
			AADD( aMAq[nI][2], aProdutos[nJ] )
		EndIf
	Next nJ
Next nI             

nQuant := 0
nTotal := 0
For nI := 1 To Len(aMaq)
	cMaq := aMaq[nI][1]
	cDescMaq := AllTrim( Posicione( "SN1",2,xFilial("SN1") +AvKey(cMaq,"N1_CHAPA"),"N1_DESCRIC" ) )
	cTabela := AllTrim( Posicione( "SN1",2,xFilial("SN1") +AvKey(cMaq,"N1_CHAPA"),"N1_XTABELA" ) )
	aDoses := Aclone(aMaq[nI][2])
	aProd := {}
	nQtdSub := 0
	nPrcSub := 0 
	aPrc := {0,0}

	// aglutinar as doses para nao ficar repetindo - 1 4
	For nJ := 1 To Len(aDoses)
		nPos := Ascan( aProd, { |x| x[1] == aDoses[nJ][1] .And. x[4] == aDoses[nJ][4] } )
		If nPos == 0
			AADD( aProd, aDoses[nJ] )
		Else
			aProd[nPos][3] += aDoses[nJ][3]
			aProd[nPos][5] += aDoses[nJ][5]
		EndIf
	Next nJ
	                                                           	
	oExcel:AddRow(cSheet2,"Relatorio",{"",cMaq +"-" +cDescMaq,"","","","","" })
												
	For nJ := 1 To Len(aProd)
		aPrc := {0,0}
		aPrc :=  STATICCALL( TTPROC56, fPRC, cTabela,aProd[nJ][1] ) 
		oExcel:AddRow(cSheet2,"Relatorio",{aProd[nJ][1],; 
											aProd[nJ][2],;
											aProd[nJ][3],;
											aProd[nJ][4],;
											aProd[nJ][7],; 
											( aProd[nJ][3]*aPrc[2] ),;				// venda -> novo											
											aProd[nJ][5] })
		nQtdSub += aProd[nJ][3]
		nPrcSub += aProd[nJ][5]
	Next nJ
		
	oExcel:AddRow(cSheet2,"Relatorio",{"","Sub-Total",nQtdSub,"","",0,nPrcSub })
	
	nQuant += nQtdSub
	nTotal += nPrcSub
	
	If nI == Len(aMaq)
		oExcel:AddRow(cSheet2,"Relatorio",{"","Total",nQuant,"","",0,nTotal } )
	EndIf
Next nI


// sheet 3 - demonstrativo contadores 
// maquina cont_ant cont_atu loja data_ultimo_orcamento dtins dtrem minimo
For nI := 1 To Len( _aMaqCnt )
	
	cModel := Posicione("SN1",2,xFilial("SN1") +AvKey(_aMaqCnt[nI][1],"N1_CHAPA"),"N1_DESCRIC")
	
	dAnt := stod("")
	dAtu := stod("")
	nSaleAnt := 0
	nSaleAtu := 0
	nTotSale := 0
	aBots := {}
	nTotB := 0
	nPrcCompl := 0
	nSangra := 0	// contadores x Preco Publico aProdutos
	nTotFat := 0

	aAuxCnt := {}

	aOS := {}
	For nJ := 1 To Len( aList2 )
		If aList2[nJ][1] .And. aList2[nJ][5] == _aMaqCnt[nI][1]       
			AADD( aOS, { aList2[nJ][13],ctod(aList2[nJ][3])  } )	// os data			
		EndIf
	Next nJ
	
	aSort( aOS,,,{ |x,y| x[2] < y[2] } ) 
	
	// REC Contador Ant e Atual
	If !Empty( aOS )
		nPosFim := 1
		If Len( aOS ) > 1 
			nPosFim := Len(aOS)		
		EndIf

		nRecAnt := STATICCALL( TTFAT39C, ZNCon, _aMaqCnt[nI][1],aOS[1][2] )

		// reg do reg atual
		dbSelectArea("SZN")
		dbSetOrder(4)
		If MsSeek( xFilial("SZN") +AvKey( aOS[nPosFim][1] ,"ZN_NUMOS") )
			nRecAtu := Recno()
		EndIf						
	EndIf
		

	dbSelectArea("SZN")
	dbGoTo( nRecAtu )                          
	
	nSaleAtu := SZN->ZN_NUMATU
	dAtu := SZN->ZN_DATA
	
	dbGoTo( nRecAnt )                          
	
	nSaleAnt := SZN->ZN_NUMATU
	dAnt := SZN->ZN_DATA
	nTotSale := ( nSaleAtu - nSaleAnt )
	
	dbSelectArea("SN1")
	dbSetOrder(2)
	If MsSeek( xFilial("SN1") +AvKey(_aMaqCnt[nI][1],"N1_CHAPA") )		
		For nJ := 1 To 12                  
			cBot := PadL( cvaltochar(nJ),2,"0" )
			AADD( aAuxCnt, { &("SN1->N1_XP" +cvaltochar(nJ)),0 } ) //AADD( aAuxCnt, { &("SZN->ZN_BOTAO" +cBot),0 } )
		Next nJ
	EndIf
	
	For nDose := 1 To Len( aAuxCnt )
		nVenda := 0
		If !Empty(aAuxCnt[nDose][1])
			For nJ := 1 To Len( aProdutos )
				If AllTrim(aProdutos[nJ][1]) == AllTrim(aAuxCnt[nDose][1]) .And. AllTrim(aProdutos[nJ][10]) == AllTrim(_aMaqCnt[nI][1])
					nPosL := AScan( aList2, { |x| x[2] == aProdutos[nJ][6] }  )
					If nPOsL > 0
						If aList2[nPOsL][1]
							nVenda += aProdutos[nJ][3]
						EndIf
					EndIf
				EndIf
			Next nJ
		EndIf
		aAuxCnt[nDose][2] := nVenda
		AADD( aBots, { nVenda,0,0 } )

		nTotB += nVenda 
	Next nDose

	// Sangria
	/*
	oVM := VMACHINE():New( _aMaqCnt[nI][1] )
	For nJ := 1 To Len( oVM:aMapa )
		nSangra += ( oVM:aMapa[nJ][7] * aBots[nJ][1]  )			
	Next nJ
	*/
	cTabPrc := SN1->N1_XTABELA
	If !Empty(cTabPrc)
		For nJ := 1 To Len( aBots )
	    	cProd := &("SN1->N1_XP"+cvaltochar(nJ))
			If !Empty(cProd)
				aPRECO := STATICCALL( TTPROC56, fPRC,cTabPrc,cProd )
				aBots[nJ][2] := aPRECO[1]
				aBots[nJ][3] := aPRECO[2]	
				nSangra += ( aPRECO[2] * aBots[nJ][1]  )
			EndIf						
		Next nJ	
	EndIf
	
	aLinha := { _aMaqCnt[nI][1],;
				cModel,;
				_aMaqCnt[nI][6],;
				dAnt,;
				dAtu,;
				nSaleAnt,;
				nSaleAtu,;
				nTotSale } 
	
	For nJ := 1 To Len( aBots )
		AADD( aLinha, aBots[nJ][1] )
		AADD( aLinha, aBots[nJ][2] )
		AADD( aLinha, aBots[nJ][3] )
	Next nJ
						
	AADD( aLinha, nTotB )
	AADD( aLinha, nSangra )
		                          	
	oExcel:AddRow(cSheet3,"Relatorio", aLinha ) 

Next nI

						 

oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFAT22C","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( "MsExcel" )
		Aviso("TTFAT22C", "MsExcel nใo instalado. " +CRLF +"O arquivo estแ localizado em: "+cDir, {"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf

CursorArrow()  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkPerm  บAutor  ณJackson E. de Deus   บ Data ณ  07/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica permissao de acesso ao recurso                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkPerm(nOpcao)

Local lRet := .F.
Local cPerm1 :=  SuperGetMV("MV_XFAT001",.T.,"JDEUS")
Local cPerm2 :=  SuperGetMV("MV_XFAT002",.T.,"JDEUS")
Local cPerm3 :=  SuperGetMV("MV_XFAT003",.T.,"JDEUS")


// cancelar pedido
If nOpcao == 1
	If cUsername $ cPerm1
		lRet := .T.
	EndIf
// faturar nota
ElseIf nOpcao == 2
	If cUsername $ cPerm2
		lRet := .T.
	EndIf               
// cancelar nota
ElseIf nOpcao == 3
	If cUsername $ cPerm3
		lRet := .T.
	EndIf
EndIf

If !lRet
	MsgAlert("Voc๊ nใo possui permissใo para utilizar esse recurso.","TTFAT22C")
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHeadClk  บAutor  ณMicrosiga           บ Data ณ  10/20/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function HeadClk()

Local nI

If oList2:ColPos() == 1
	For nI := 1 To Len(aList2)
		If aList2[nI][1]
			aList2[nI][1] := .F.
		Else 
			aList2[nI][1] := .T.
		EndIf
	Next nI
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarkOrc  บAutor  ณJackson E. de Deus   บ Data ณ  04/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marcacao dos Orcamentos                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarkOrc()

Local nLinha := oList2:nAt
Local nI
Local cMsg := ""
Local cLojaBkp := ""


If !Empty(aList2[oList2:nAt][10])
	MsgAlert("Esse or็amento jแ foi baixado!" +CRLF +"Pedido: " +aList2[oList2:nAt][10] )
	Return
EndIf


If aList2[oList2:nAt][1]         
	aList2[oList2:nAt][1] := .F.		
Else
	aList2[oList2:nAt][1] := .T.                               
EndIf

RefshTela()


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRefshTela  บAutor  ณJackson E. de Deus บ Data ณ  04/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza tela                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RefshTela()

Local nI
Local nQtdTot := 0

nValTot := 0

fHelp()

For nI := 1 To Len(aList3)  
	// considerar somente doses efetivas
	If alltrim(aList3[nI][3]) <> AllTrim(_cDoseComp)
		nQtdTot += aList3[nI][3]      
	EndIf
	
	nValTot += aList3[nI][5]
Next nI

cQtdTotal := "R$ " +AllTrim( Transform( Round(nValTot,2),PesqPict("SF2","F2_VALBRUT") ) ) 
oSVal:SetText(cQtdTotal)
oSVal:Refresh()

//oMinimo2:SetText("Mํnimo calculado: " +cvaltochar(_nMinimo2))
//oMinimo2:Refresh()
_nQuantP := nQtdTot
oTotAp2:SetText(cvaltochar(_nQuantP))
oTotAp2:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfHelp  บAutor  ณJackson E. de Deus     บ Data ณ  06/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os produtos no grid	                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fHelp(nLinha) 

// mostrar somente os produtos dos orcamentos que foram marcados
Local aItem := {}

aItem := AglProd(2)
If !ArrayCompare(aItem,aList3)
	aList3 := aClone(aItem)						
	oList3:SetArray(aList3) 
	oList3:bLine := { || { aList3[oList3:nAt,01],;
						aList3[oList3:nAt,02],;
						aList3[oList3:nAt,03],;
						Transform( aList3[oList3:nAt,04],PesqPict("SCK","CK_PRCVEN") ),;
						Transform( aList3[oList3:nAt,06],PesqPict("SCK","CK_PRCVEN") ),;
						Transform( aList3[oList3:nAt,05],PesqPict("SCK","CK_VALOR") ) }}
	
	oList3:Refresh(.T.)			
EndIf                       

If Empty(aList3)
	AADD( aList3, { "","",0, "" ,0,0 } )
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22C  บAutor  ณMicrosiga           บ Data ณ  12/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisPed( cNumPed )
 

If !Empty( cNumPed )
	cCadastro := "Pedido de venda"
	aRotina := StaticCall( MATA410,MenuDef )
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") ) 	
		A410Visual("SC5",Recno(),2)      
	EndIf
EndIf		  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisual  บAutor  ณJackson E. de Deus    บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualizar orcamento/pedido                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Visual(nOpcao,nLinha)

Local aArea := GetArea()
Local nRecno := 0      
Local cNumPed := aList2[nLinha][10]
Local cNota := aList2[nLinha][11]
Local cSerie := "2"
Local cLoja := ""
Private cCadastro := ""
Private aRotina := {}

// orcamento
If nOpcao == 1
	nRecno := aList2[nLinha][12]
	If !Empty( nRecno )
		cCadastro := "Orcamentos de venda"
		aRotina := StaticCall( MATA415,MenuDef )
		dbSelectArea("SCJ")
		dbSetOrder(1)
		If dbSeek( xFilial("SCJ") +AvKey(aList2[nLinha][2],"CJ_NUM") )
			dbSelectArea("SCK")
			dbSetOrder(1)
			dbSeek( xFilial("SCK") +AvKey(aList2[nLinha][2],"CK_NUM") )
			dbSelectArea("SCJ")
			A415Visual("SCJ",nRecno,2)      
		EndIf
	EndIf		  
// pedido	  
ElseIf nOpcao == 2
	If !Empty( cNumPed )
		cCadastro := "Pedido de venda"
		aRotina := StaticCall( MATA410,MenuDef )
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") ) 	
			A410Visual("SC5",Recno(),2)      
		EndIf
	EndIf		  
// nota
ElseIf nOpcao == 3
	If !Empty(cNota)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") ) 	
			cLoja := SC5->C5_LOJACLI
			dbSelectArea("SF2")
			dbsetOrder(2)
			If dbSeek( xFilial("SF2") +AvKey(_cCliCnt,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNota,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
				Mc090Visual("SF2",Recno(),2)
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancel  บAutor  ณJackson E. de Deus    บ Data ณ  06/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancelamento de pedido via eliminacao de residuo           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cancel(nLinha)

Local aArea := GetArea()
Local cNumPed := aList2[nLinha][10]

If !Empty( cNumPed )
	If MsgYesNo("Confirma o cancelamento do pedido gerado?")
		MsAguarde({ || ProcCnc( cNumPed ) },"Aguarde, cancelando pedido de venda...")
	EndIf
EndIf		  

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22C  บAutor  ณMicrosiga           บ Data ณ  12/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CancPed( cNumPed,nOpc )

If !Empty( cNumPed )
	If MsgYesNo("Confirma o cancelamento do pedido gerado?")
		MsAguarde({ || ProcCnc( cNumPed,nOpc ) },"Aguarde, cancelando pedido de venda...")
	EndIf
EndIf	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcCnc  บAutor  ณJackson E. de Deus   บ Data ณ  06/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o cancelamento do pedido                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcCnc(cNumPed,nOpc)

Default nOpc := 1
Private cCadastro := "Pedido de venda"
Private aRotina := StaticCall( MATA410,MenuDef )

dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") ) 	
	Ma410Resid("SC5",Recno(),2)
	
	If AllTrim(SC5->C5_NOTA) == "XXXXXXXXX"
		If nOpc == 1  
			For nI := 1 To Len(aList2)    
				If aList2[nI][10] == cNumPed 
					aList2[nI][10] := ""        
				EndIf
			Next nI
		 	oList2:Refresh(.T.)    
		Else 
			For nI := 1 To Len(_aList4)    
				If _aList4[nI][10] == cNumPed 
					_aList4[nI][10] := ""        
				EndIf
			Next nI 
			oList4:Refresh(.T.)    
		EndIf
	EndIf  
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAglProd  บAutor  ณJackson E. de Deus   บ Data ณ  28/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna produtos dos orcamentos marcados                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AglProd(nOpc)

Local nI,nJ
Local nQtd			:= 0
Local nTot			:= 0  
Local cCodPA		:= ""
Local aRRRR			:= {}
Local aAx			:= {} 
Local aPA			:= {}
Local aExc			:= {}
Local cNumOrC		:= ""
Local nTotDose		:= 0
Local nDifer		:= 0
Local cDoseCompl	:= _cDoseComp	//"1001896"
Local cDescCmpl		:= Posicione( "SB1",1,xFilial("SB1")+AvKey(cDoseCompl,"B1_COD"),"B1_DESC" )
Local nDosed		:= 0
Local nDias			:= 0
Local nPrcD			:= 0
Local nPosPrc		:= 0

Default nOpc		:= 1


// para faturar - separar por pa/preco  _lFatCLDif
If nOPc == 1    
	For nI := 1 To Len(aList2)
		If aList2[nI][1]
			For nJ := 1 To Len(aProdutos)
				If aProdutos[nJ][6] == aList2[nI][2]
					// Preco PE - Cliente
					// produto loja pa preco PE
					If Ascan( aRRRR, { |x| x[1] == aProdutos[nJ][1] /*.And. x[6] == aProdutos[nJ][9]*/ .AND. IIF(_lFatCLDif,.T.,x[6] == aProdutos[nJ][9])  .And. x[5] == aProdutos[nJ][8] .And. x[3] == aProdutos[nJ][4] } ) == 0
						AADD( aRRRR, { aProdutos[nJ][1],;		// produto
										0,;						// qtd
										aProdutos[nJ][4],;		// preco
										0,;						// total
										aProdutos[nJ][8],;		// pa
										aProdutos[nJ][9] } )	// loja
					EndIf
				EndIf	
			Next nJ        
		EndIf           
	Next nI
	
	If Len(aRRRR) > 0
		// aglutina Quantidades com precos iguais
		AgltPrc(@aRRRR)
		
		// MINIMO DE DOSES
		If _nMinimo > 0
			For nI := 1 To Len(aRRRR)
				nTotDose += aRRRR[nI][2]
			Next nI
			If nTotDose < _nMinimo
				// com prorata
				If _lProRata
					nDosed:= _nMinimo/30
					nDias := 30	//dDtFim - dDtIni
					_nMinimo2 := Int(nDias*nDosed)
			    	nDifer := _nMinimo2 - nTotDose
			    // sem prorata	
				Else 
					//_nMinimo2 := _nMinimo - nTotDose
					nDifer := _nMinimo - nTotDose
			    EndIf
		     	_aTabela := TabPrc()	// como definir qual tabela de preco usar? cada orcamento se refere a um patrimonio que pode estar vinculado a tabela difernete	
		     	nPrcD := 0
		     	nPosPrc := AScan( _aTabela, { |x| AllTrim(x[1]) == AllTrim(cDoseCompl) }  )
		     	If nPosPrc > 0
		     		nPrcD := _aTabela[nPosPrc][2]
		     	EndIf
		     	If Empty(nPrcD)
		     		nPrcD := 0.0
		     	EndIf

				AADD( aRRRR, { cDoseCompl, nDifer, nPrcD,Round(nDifer*nPrcD,6),aRRRR[Len(aRRRR)][5],aRRRR[Len(aRRRR)][6] } )
			EndIf
		EndIf		
	EndIf
	        
// para mostrar na tela - grid inferior com produtos consolidados por diferenca somente de preco
Else
	For nI := 1 To Len(aList2)
		If aList2[nI][1]
			For nJ := 1 To Len(aProdutos)
				If aProdutos[nJ][6] == aList2[nI][2]	// mesmo orcamento
					If Ascan( aRRRR, { |x| x[1] == aProdutos[nJ][1] .And. x[4] == aProdutos[nJ][4] } ) == 0
						AADD( aRRRR, { aProdutos[nJ][1],aProdutos[nJ][2],0, aProdutos[nJ][4] ,0,0  } )	// PRODUTO DESC QTD PRCPE TOTAL PRCPP                                                          
					EndIf
				EndIf	
			Next nJ        
		EndIf           
	Next nI
	// aglutina Quantidades de produtos com precos iguais
	For nI := 1 To Len(aRRRR)
		nQtd := 0
		nTot := 0
		For nJ := 1 To Len(aProdutos)
			cNumOrC := aProdutos[nJ][6]
			If Ascan( aList2, { |x| AllTrim(x[2]) == AllTrim(cNumOrC) .And. !x[1] } ) > 0
				Loop
			EndIf
			
			If aProdutos[nJ][1] <> aRRRR[nI][1]
				Loop
			EndIf                                              
			
			If aRRRR[nI][4] == aProdutos[nJ][4] .And. aRRRR[nI][4] == aProdutos[nJ][4] //aRRR[nI][6] == aProdutos[nJ][7]
				nQtd += aProdutos[nJ][3]
				nTot += aProdutos[nJ][5]
			EndIf                                  
		Next nJ                     
		aRRRR[nI][3] := nQtd
		aRRRR[nI][5] := nTot
	Next nI

	aSort( aRRRR,,,{ |x,y| x[3] > y[3] })
	
	// MINIMO DE DOSES
	If _nMinimo > 0
		For nI := 1 To Len(aRRRR)
			nTotDose += aRRRR[nI][3]
		Next nI
		If nTotDose < _nMinimo
			// com prorata
			If _lProRata
				nDosed:= _nMinimo/30
				nDias := 30	//dDtFim - dDtIni
				_nMinimo2 := Int(nDias*nDosed)
		    	nDifer := _nMinimo2 - nTotDose
		    // sem prorata	
			Else 
				//_nMinimo2 := _nMinimo - nTotDose
				nDifer := _nMinimo - nTotDose
		    EndIf
	     	_aTabela := TabPrc()	// como definir qual tabela de preco usar? cada orcamento se refere a um patrimonio que pode estar vinculado a tabela difernete	
	     	nPrcD := 0
	     	nPosPrc := AScan( _aTabela, { |x| AllTrim(x[1]) == AllTrim(cDoseCompl) }  )
	     	If nPosPrc > 0
	     		nPrcD := _aTabela[nPosPrc][2]
	     	EndIf
	     	If Empty(nPrcD)
	     		nPrcD := 0.0
	     	EndIf
			AADD( aRRRR, { cDoseCompl,cDescCmpl, nDifer, nPrcD,Round(nDifer*nPrcD,6),0.0 } )
		EndIf
	EndIf	 
EndIf	

Return aRRRR


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAgltPrc  บAutor  ณJackson E. de Deus   บ Data ณ  07/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AgltPrc(aAx)

Local aAuxR := {}
Local nI, nJ 
Local nPosOrc := 0

// compara produto x loja x pa x preco 
For nI := 1 To Len(aAx)
	For nJ := 1 To Len(aProdutos)
		cNumOrC := aProdutos[nJ][6]
		// desconsiderar os desmarcados
		nPosOrc := Ascan( aList2, { |x| AllTrim(x[2]) == AllTrim(cNumOrC) .And. !x[1] } )
		If nPosOrc > 0
			Loop
		EndIf                          
		
		If aProdutos[nJ][1] == aAx[nI][1] /*.And. aProdutos[nJ][9] == aAx[nI][6]*/.AND. IIF(_lFatCLDif,.T.,aProdutos[nJ][9] == aAx[nI][6])  .And. aProdutos[nJ][8] == aAx[nI][5] .And. aProdutos[nJ][4] == aAx[nI][3]
			aAx[nI][2] += aProdutos[nJ][3]
			aAx[nI][4] += aProdutos[nJ][5]
		EndIf
	Next nJ	               
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTabPrc  บAutor  ณJackson E. de Deus    บ Data ณ  24/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega produtos da tabela de preco                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TabPrc()

Local aAux	:=	{}
Local cQuery

cQuery := "SELECT DA0_CODTAB,DA1_CODPRO,DA1_PRCVEN,DA1_XPRCPP"
cQuery += " FROM "+RetSQLName("DA0")+" D0"
cQuery += " INNER JOIN "+RetSQLName("DA1")+" D1 ON DA1_CODTAB=DA0_CODTAB AND D1.D_E_L_E_T_=''"
cQuery += " WHERE DA0_CODTAB = '"+_cCodTab+"' "	// tabela gravada no orcamento
cQuery += " ORDER BY DA1_CODPRO"
            
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	Aadd(aAux,{ TRB->DA1_CODPRO,TRB->DA1_PRCVEN,TRB->DA1_XPRCPP, TRB->DA0_CODTAB })
	DbSkip()
Enddo

Return(aAux)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAglxPP  บAutor  ณJackson E. de Deus    บ Data ณ  20/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aglutina os produtos com preco publico PP                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AglxPP()

Local nI
Local cDoseCompl := _cDoseComp	//"1001896" 
Local nPosP := 0
Local aProd := {}

For nI := 1 To Len(aList3)
	// desconsidera dose complementar
	If aList3[nI][1] == cDoseCompl
		Loop
	EndIf   
	
	If aList3[nI][6] == 0
		Loop
	EndIf
	nPosP := Ascan( aProd, { |x| x[1] == aList3[nI][1] .And. x[3] == aList3[nI][6] } )
	If nPosP == 0
		AADD( aProd, { aList3[nI][1],; // produto
					aList3[nI][3],;		// qtd
					aList3[nI][6],;		// PP
					"",;				// OBS
					"",;				// Local
					0  } )				// PP - legado TTFAT20C - retirar depois
	Else
		aProd[nPosP][2] += List3[nI][3]
	EndIf
Next nI

//ttfat20 -> // produto qtd PP OBS LOCAL PP	
//alist3 -> PRODUTO DESC QTD PRCPE TOTAL PRCPP 

Return aProd 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22C  บAutor  ณMicrosiga           บ Data ณ  10/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AglxPP2()

Local nI
Local cDoseCompl := _cDoseComp	//"1001896" 
Local nPosP := 0
Local aProd := {}


dbSelectArea("SCK")
dbSetOrder(1)

dbSelectArea("SCJ")
dbSetOrder(1)

For nI := 1 To Len( _aList4 )
	// desconsidera dose complementar
	If !_aList4[nI][1]	// == cDoseCompl
		Loop
	EndIf
	
	dbSelectArea("SCJ")
	dbGoTo( _aList4[nI][12] )
	
	dbSelectArea("SCK")
	If MSSeek( xFilial("SCK") +AvKey(SCJ->CJ_NUM,"CK_NUM") )
		While SCK->(!EOF()) .And. SCK->CK_NUM == SCJ->CJ_NUM
		
			nPosP := Ascan( aProd, { |x| x[1] == SCK->CK_PRODUTO .And. x[6] == SCK->CK_PRCVEN } )
			If nPosP == 0
				AADD( aProd, { SCK->CK_PRODUTO,;	// produto
								SCK->CK_QTDVEN,;	// qtd
								SCK->CK_PRCVEN,;	// PP
								"",;				// OBS
								SCK->CK_LOCAL,;		// Local
								SCK->CK_PRCVEN  } )	// PP - legado TTFAT20C - retirar depois
			Else
				aProd[nPosP][2] += SCK->CK_QTDVEN
			EndIf
		
			SCK->(dbSkip())
		End
	EndIf
	
Next nI

//ttfat20 -> // produto qtd PP OBS LOCAL PP	
//alist3 -> PRODUTO DESC QTD PRCPE TOTAL PRCPP 

Return aPRod      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPedido  บAutor  ณJackson E. de Deus    บ Data ณ  27/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar pedido de venda                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pedido()

Local cPedido := ""
Local cSql := "" 
Local nI
Local nExec := 0    
Local aItens := {}
Local axItens := {} 
Local aDados := {}
Local axCab := {}
Local cTxtMsg := ""
Local aArrX := {}          
Local aProdPP := {}
Local aLojas := {}
Private lEnd := .F.

If ( Empty(aList2) .And. Empty(nValTot) ) .Or. Empty(_aList4)
	Return
EndIf

If Empty( _cNotas )
	MsgAlert("Selecione as notas utilizadas na remessa!")
	//Return
EndIf

If !MsgYesNo( "Confirma a gera็ใo do(s) pedidos de venda?" )
	Return
EndIf

MsAguarde( { || aDados := AglProd(1) },"Aguarde, separando produtos PE.." )
MsAguarde( { || aProdPP := AglxPP2() },"Aguarde, separando produtos PP.." )


// Se aglutina faturamento no cliente/loja do contrato
If _lAglCli .And. !_lFatCLDif
	AADD( aLojas, { _cLjCnt,"", {} } )
	For nJ := 1 To Len(aDados)
		AADD( aLojas[1][3], { aDados[nJ][1],;
							aDados[nJ][2],;
							aDados[nJ][3],;
							aDados[nJ][4],;
							aDados[nJ][5] } )
	Next nJ	
// por loja msmo
ElseIf !_lAglCli
	aLojas := LojasGrid() 
	If !Empty(aLojas)
		For nI := 1 To Len(aLojas)
			AADD( aLojas[nI], {} )
			For nJ := 1 To Len(aDados)
				If aDados[nJ][6] == aLojas[nI][1]
					AADD( aLojas[nI][3], { aDados[nJ][1],;
										aDados[nJ][2],;
										aDados[nJ][3],;
										aDados[nJ][4],;
										aDados[nJ][5] } )
				EndIf
			Next nJ
		Next nI
	EndIf
EndIf
	
// se for faturamento diferenciado - alterar o cliente/loja aqui //_cCliFat
If _lFatCLDif
	aLojas := {}              
	AADD( aLojas, { _cLjFat,"", {} } )
	For nJ := 1 To Len(aDados)
		AADD( aLojas[1][3], { aDados[nJ][1],;
							aDados[nJ][2],;
							aDados[nJ][3],;
							aDados[nJ][4],;
							aDados[nJ][5] } )
	Next nJ
EndIf
	

If Empty(aLojas)
	Return
EndIf

oProcess := MsNewProcess():New( { |lEnd| ExecPed(@oProcess, @lEnd,aLojas,aProdPP) }, "Gera็ใo de pedidos", "Gerando os pedidos..", .T. )
oProcess:Activate()
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecPed  บAutor  ณJackson E. de Deus   บ Data ณ  07/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao dos pedidos                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecPed(oProcess, lEnd,aLojas,aProdPP)

Local nI,nK    
Local nExec := 0    
Local cSql := ""
Local cPedido := ""
Local cPedido2 := ""
Local cNumOrc := ""
Local cLoja := ""
Local axItens := {}
Local axCab := {}
Local cTxtMsg := "Pedidos gerados" +CRLF
Local cCliFt := "" 
Local cLjFt := ""
Local cCliTT := "000001"
Local cLjTT := "0001"
Local cFinalPed := ""



// cafe
If cTpContr $ "004#010"
	cFinalPed := "J"
	
	// mensagem NF
	_cMenNota := "COBRANCA REF AO CONSUMO DE BEBIDAS QUENTES NO PERIODO " +dtoc(dDtIni) +" A " +dtoc(dDtFim)
	If !Empty( _cNotas )
		_cMenNota += " NF DE REMESSA " +_cNotas
	EndIf
// snacks/beb gelada
ElseIf cTpContr $ "006#007"
	cFinalPed := "2"
	
	// mensagem NF
	_cMenNota := "COBRANCA REF AO PERIODO " +dtoc(dDtIni) +" A " +dtoc(dDtFim)
	If !Empty( _cNotas )
		_cMenNota += " NF DE REMESSA " +_cNotas
	EndIf
EndIf


// tratamento para troca de cliente ou loja
If _lFatCLDif 
	cCliFt := _cCliFat
Else
	cCliFt := _cCliCnt	
EndIf

oProcess:SetRegua1(Len(aLojas))

// para lojas // ou rateios..
For nI := 1 To Len(aLojas)
	If lEnd
		Exit		
	EndIf
	
	cPedido := ""
	cLoja := aLojas[nI][1]
	axItens := aclone(aLojas[nI][3])
	
	oProcess:IncRegua1("Loja: " +cLoja)
	sleep(5)
	
	oProcess:SetRegua2(2)
	If Empty(_cCondPg)
		_cCondPg := "001"
	EndIf
	

	If !Empty(axItens)
		axCab := { {"C5_XFINAL",cFinalPed}, {"C5_XPREPED","S"},{"C5_CONDPAG",_cCondPg},{"C5_XTPPAG",""},{"C5_XCODPA",""},{"C5_MENNOTA",_cMenNOta} }
		
		oProcess:IncRegua2("Gerando pedido..")
	
		MsAguarde({ || cPedido := U_TTFAT21C( cCliFt,cLoja,axItens,"",axCab ) },"Aguarde, gerando pedido de venda...")
		If !Empty(cPedido)
		
			oProcess:IncRegua2("Atualizando orcamentos..")
				
			// gravar o pedido de venda gerado nos orcamentos
			For nK := 1 To Len(aList2)
				If !aList2[nK][1]
					Loop
				EndIf
				If AllTrim(aList2[nK][9]) <> AllTrim(cLoja)
					Loop
				EndIf
				cNumOrc := aList2[nK][2]
				
				// marca orcamentos como baixados
				cSql := "UPDATE " +RetSqlName("SCJ")
				cSql += " SET CJ_STATUS = 'B', CJ_XNUMPV = '"+cPedido+"' "
				cSql += " WHERE CJ_FILIAL = '"+xFilial("SCJ")+"' "
				//cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"' "
				cSql += " AND CJ_NUM = '"+cNumOrc+"' "
				cSql += " AND D_E_L_E_T_ = '' "
				
				nExec := TCSQLExec(cSql)
				If nExec < 0
					CONOUT("#TTFAT22C -> ERRO AO ATUALIZAR SCJ : " +cNumOrc +" PEDIDO: " +cPedido)
				EndIf
				
				// marca nos itens dos orcamentos qual pedido de venda gerou
				cSql := "UPDATE " +RetSqlName("SCK")
				cSql += " SET CK_NUMPV = '"+cPedido+"' "
				cSql += " WHERE CK_FILIAL = '"+xFilial("SCK")+"' "
				//cSql += " AND CK_CLIENTE = '"+_cCliCnt+"' "
				cSql += " AND CK_NUM = '"+cNumOrc+"' "
				cSql += " AND D_E_L_E_T_ = '' "
				
				nExec := TCSQLExec(cSql)
				If nExec < 0
					CONOUT("#TTFAT22C -> ERRO AO ATUALIZAR SCK : " +cNumOrc +" PEDIDO: " +cPedido)
				EndIf
				
				// flega contadores
				dbSelectArea("SZN")
				dbSetOrder(4)
				If dbSeek( xFilial("SZN") +AvKey(aList2[nK][13],"ZN_NUMOS") )
					/*RecLock("SZN",.F.)
					SZN->ZN_FECHAM := "S"
					MsUnLock()*/
				EndIf
				
				aList2[nK][10] := cPedido
				aList2[nK][1] := .F.
			Next nK
			RefshTela()
			cTxtMsg += "Loja: " +cLoja +" - " +cPedido +CRLF
		EndIf
	EndIf
Next nI


If !Empty(aProdPP)
	axCab := { {"C5_XFINAL","S"},{"C5_CONDPAG","118"}, {"C5_XTPPAG","TOK"}, {"C5_XPREPED","S"},{"C5_XCODPA",""},{"C5_MENNOTA",_cMenNOta} }
	MsAguarde({ || cPedido2 := U_TTFAT21C( cCliTT,cLjTT,aProdPP,"",axCab ) },"Aguarde, gerando pedido PP...")
	If !Empty(cPedido2)
	
		oProcess:IncRegua2("Atualizando orcamentos..")
			                                            						 
		// gravar o pedido de venda gerado nos orcamentos
		For nK := 1 To Len(_aList4)
			If !_aList4[nK][1]
				Loop
			EndIf
	
			cNumOrc := _aList4[nK][2]
			
			// marca orcamentos como baixados
			cSql := "UPDATE " +RetSqlName("SCJ")
			cSql += " SET CJ_STATUS = 'B', CJ_XNUMPV = '"+cPedido2+"' "
			cSql += " WHERE CJ_FILIAL = '"+xFilial("SCJ")+"' "
			cSql += " AND CJ_NUM = '"+cNumOrc+"' "
			cSql += " AND D_E_L_E_T_ = '' "
			
			nExec := TCSQLExec(cSql)
			If nExec < 0
				CONOUT("#TTFAT22C -> ERRO AO ATUALIZAR SCJ : " +cNumOrc +" PEDIDO: " +cPedido2)
			EndIf
			
			// marca nos itens dos orcamentos qual pedido de venda gerou
			cSql := "UPDATE " +RetSqlName("SCK")
			cSql += " SET CK_NUMPV = '"+cPedido2+"' "
			cSql += " WHERE CK_FILIAL = '"+xFilial("SCK")+"' "
			cSql += " AND CK_NUM = '"+cNumOrc+"' "
			cSql += " AND D_E_L_E_T_ = '' "
			
			nExec := TCSQLExec(cSql)
			If nExec < 0
				CONOUT("#TTFAT22C -> ERRO AO ATUALIZAR SCK : " +cNumOrc +" PEDIDO: " +cPedido)
			EndIf
			
	
			_aList4[nK][10] := cPedido2
			_aList4[nK][1] := .F.
		Next nK
		
		oList4:Refresh(.T.)
	
		cTxtMsg += "Tok Take - " +cPedido2
	EndIf
EndIf

Aviso("",cTxtMsg,{"Ok"})


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLojasGrid  บAutor  ณJackson E. de Deus  บ Data ณ  07/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LojasGrid()

Local nI
Local aLojas := {}

For nI := 1 To Len(aList2)
	If Ascan( aLojas, { |x| x[1] == aList2[nI][9] } ) == 0
		AADD( aLojas, { aList2[nI][9], AllTrim( Posicione("SA1",1,xFilial("SA1")+AvKey(_cCliCnt,"A1_COD")+AvKey(aList2[nI][9],"A1_LOJA"),"A1_NREDUZ") ) } )
	EndIf
Next nI

Return aLojas



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarga	    บAutor  ณJackson E. de Deus  บ Data ณ  27/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga inicial dos dados                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carga()

Local cSql			:= ""
Local cNumPed		:= ""
Local cNota			:= ""
Local cCodPa		:= ""
Local cDescPA		:= "" 
Local cModelo		:= ""
Local nPrcPP		:= 0
Local nTotDose		:= 0
Local nDifer		:= 0
Local cDoseCompl	:= _cDoseComp	//"1001896"
Local cDescCmpl		:= Posicione( "SB1",1,xFilial("SB1")+AvKey(cDoseCompl,"B1_COD"),"B1_DESC" )
Local cTiposCnt		:= ""
Local cAuxTps		:= SuperGetMV("MV_XFAT012",.T.,"004")
Local aAuxTps		:= {}
Local cProdMod		:= ""
Local cTipServ		:= ""
Local nCntCn9		:= 0


If !Empty(cAuxTps)
	aAuxTps := StrToKarr( cAuxTps,"#" )
	For nI := 1 To Len( aAuxTps )
		cTiposCnt += "'" +aAuxTps[nI] +"'"
		If nI <> Len( aAuxTps )
			cTiposCnt += ","
		EndIf
	Next nI
EndIf


aList2 := {}
nValTot := 0
aProdutos := {}
aList3 := {}
_aLojas := {}
_nMinimo := 0
_lProRata := .F.
_lFatCLDif := .F.
_cCliFat := ""
_cLjFat := ""

    
MsProcTxt("Informacoes de contrato..")

    
// contrato - minimo
cSql := "SELECT CN9_CLIENT,CN9_LOJACL,CN9_XVOLMI,CN9_XPRORA, CN9_XTPFAT,CN9_XCLIFT,CN9_XLJFAT,CN9_CONDPG,CN9_TPCTO  FROM " +RetSqlName("CN9")
//cSql += " WHERE CN9_CLIENT = '"+_cCliCnt+"' AND CN9_TPCTO = '004'  AND D_E_L_E_T_ =  '' "
cSql += " WHERE CN9_NUMERO = '"+_cContt+"' AND CN9_TPCTO IN ("+cTiposCnt+") AND D_E_L_E_T_ = '' "
If Select("TRBX") > 0   
	TRBX->(dbCloseArea())
EndIf                   

TcQuery cSql New Alias "TRBX"
dbSelectArea("TRBX") 
If !EOF()
	_cCliCnt := TRBX->CN9_CLIENT
	_cLjCnt := TRBX->CN9_LOJACL
	_nMinimo := TRBX->CN9_XVOLMI
	_lProRata := IIF( AllTrim(TRBX->CN9_XPRORA)=="1",.T.,.F. )
	_cTpFat := TRBX->CN9_XTPFAT
	_cCliFat := TRBX->CN9_XCLIFT
	_cLjFat := TRBX->CN9_XLJFAT
	_cCondPg := TRBX->CN9_CONDPG
	cTpContr := TRBX->CN9_TPCTO
	
	nCntCn9++	
EndIf
TRBX->(dbCloseArea())


If nCntCn9 == 0
	//MsgInfo("Nenhum contrato vแlido foi encontrado. Revise os parโmetros ou cadastros de contratos.")
	//Return
EndIf



// Faturamento por cliente? todas lojas em unico faturamento aglutinado
If AllTrim(_cTpFat) == "1"
	_lAglCli := .T.	
EndIf


//If AllTrim(_cTpFat) == "1"
	If !Empty(_cCliFat) .Or. !Empty(_cLjFat)
		// faturamento para cliente/loja diferente somente se cliente/loja forem diferentes do cliente/loja do contrato
		If Alltrim(_cCliFat) <> AllTrim(_cCliCnt) .Or. AllTrim(_cLjFat) <> AllTrim(_cLjCnt)
			_lFatCLDif := .T.
		EndIf
	EndIf
//EndIf

MsProcTxt("Orcamentos cliente..")


// orcamentos - competencia
//cSql := "SELECT CJ_NUM, CJ_XNUMOS, CJ_EMISSAO, CJ_LOJA, CJ_XNUMPV,CJ_XPATRIM, SUM(CK_VALOR) TOTAL, SCJ.R_E_C_N_O_ CJREC FROM " +RetSqlName("SCJ") + " SCJ "

cSql := "SELECT CJ_NUM, CJ_XNUMOS, CJ_EMISSAO, CJ_LOJA, CJ_XNUMPV,CJ_XPATRIM, SCJ.R_E_C_N_O_ CJREC FROM " +RetSqlName("SCJ") + " SCJ "


cSql += "INNER JOIN " +RetSqlName("SCK") +" SCK ON "
cSql += "CJ_FILIAL = CK_FILIAL "
cSql += "AND CJ_NUM = CK_NUM "
cSql += "AND CJ_CLIENTE = CK_CLIENTE  "
cSql += "AND CJ_LOJA = CK_LOJA "
cSql += "AND SCJ.D_E_L_E_T_ = SCK.D_E_L_E_T_ "

cSql += "LEFT JOIN " +RetSqlName("AA3") 
cSql += " ON AA3_CHAPA = CJ_XPATRIM "

cSql += "LEFT JOIN " +RetSqlName("SB1")
cSql += " ON B1_COD = AA3_MODELO "


cSql += "WHERE "
cSql += " CJ_FILIAL = '"+xFilial("SCJ")+"' "

// tipo de faturamento - por cliente - pega tudo do cliente independente de loja
If _cTpFat == "1" .OR. Empty(_cTpFat)                                                              
	cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"' "
// tipo de faturamento - por loja - pega tudo do cliente somente para a loja do contrato
ElseIf _cTpFat == "2"
	cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"' AND CJ_LOJA = '"+_cLjCnt+"' "
EndIf

//cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"'  // comentado
cSql += " AND CJ_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "
cSql += " AND CJ_XNUMOS <> '' "		// orcamentos originados de OS
//cSql += " AND CJ_STATUS = 'A' "		// orcamentos em aberto
//cSql += " AND CK_NUMPV = '' "		// orcamentos em aberto

cSql += " AND SCJ.D_E_L_E_T_ = '' "
cSql += " AND CJ_XPATRIM <> '' "

// somente cafe
If cTpContr $ "004#010"
	cSql += " AND B1_XFAMILI <> '153' "
	
// somente snacks/beb gelada
ElseIf cTpContr $ "006#007"
	cSql += " AND B1_XFAMILI = '153' "
EndIf

cSql += " GROUP BY CJ_NUM,CJ_XNUMOS,CJ_EMISSAO, CJ_LOJA, CJ_XNUMPV,CJ_XPATRIM, SCJ.R_E_C_N_O_ "
cSql += "ORDER BY CJ_EMISSAO"

If Select("TRBX") > 0
	TRBX->(dbCloseArea())
EndIf                   

TcQuery cSql New Alias "TRBX"
dbSelectArea("TRBX")
While !EOF()
	cNumPed := ""
	cNota := ""
	cProdMod := ""
	cModelo := ""
	cCodPa := ""
	cDescPA := ""
	cTipServ := ""
	
	// DESCONSIDERAR PEDIDOS COM VALOR ZERO
	If TRBX->TOTAL == 0
		TRBX->(dbSkip())
		Loop
	EndIf
		
	If Empty(_cCodTab)
		_cCodTab := AllTrim( Posicione( "SCJ",1,xFilial("SCJ")+AvKey(TRBX->CJ_NUM,"CJ_NUM"),"CJ_TABELA" ) )
	EndIf
	

	cProdMod := Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBX->CJ_XPATRIM,"N1_CHAPA"),"N1_PRODUTO" )
	cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBX->CJ_XPATRIM,"N1_CHAPA"),"N1_DESCRIC" )
	cCodPa := Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBX->CJ_XPATRIM,"N1_CHAPA"),"N1_XPA"  )
	If !Empty(cCodPa)
		cDescPA := Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(cCodPa,"ZZ1_COD"),"ZZ1_DESCRI" )
	EndIf
	
	//cTipServ := AllTrim( Posicione("SB1",1,XFILIAL("SB1") +AvKey(cProdMod,"B1_COD"),"B1_XFAMILI") )

		
	dbSelectArea("TRBX")
	                      
	// somente cafe
	//If cTpContr $ "004#010"
	//	If cTipServ <> "153"
	//		Loop
	//	EndIf
	// somente snacks/beb gelada
	//ElseIf cTpContr $ "006#007"
	//	If cTipServ == "153"
	//		Loop
	//	EndIf
	//EndIf
	
	If !Empty(TRBX->CJ_XNUMPV)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If MSSeek( xFilial("SC5") +AvKey(TRBX->CJ_XNUMPV,"C5_NUM")  )
			If AllTrim(SC5->C5_NOTA) <> "XXXXXXXXX"
				cNumPed := SC5->C5_NUM
				cNota := IIF(AllTrim(SC5->C5_NOTA) <> "XXXXXXXXX",SC5->C5_NOTA,"")
			Else
				cNota := IIF(AllTrim(SC5->C5_NOTA) <> "XXXXXXXXX",SC5->C5_NOTA,"")
			EndIf
		EndIf
	EndIf
		
	AADD( aList2, { IIF(Empty(cNumPed),.T.,.F.), TRBX->CJ_NUM, DTOC(STOD(TRBX->CJ_EMISSAO)), 0/*TRBX->TOTAL*/,;
					 TRBX->CJ_XPATRIM,cModelo, cCodPA,cDescPA, TRBX->CJ_LOJA,cNumPed,cNota,TRBX->CJREC,TRBX->CJ_XNUMOS } )
	
	//nValTot += TRBX->TOTAL
	
	dbSelectArea("TRBX")
	dbSkip()
End

TRBX->(dbCloseArea())

MsProcTxt("Produtos..")

// produtos
For nI := 1 To Len(aList2)
	// relacao total produtos
	cSql := "SELECT CK_PRODUTO, CK_DESCRI, SUM(CK_QTDVEN) QTD, CK_PRCVEN,CK_XPRCPP,CK_LOCAL, SUM(CK_VALOR) VALTOT "
	//cSql += ", CK_XPRCPP "	// PRECO PUBLICO		
	cSql += " FROM " +RetSqlName("SCK") +" SCK "
	cSql += "INNER JOIN " +RetSqlName("SCJ") +" SCJ ON "
	cSql += "CJ_FILIAL = CK_FILIAL "
	cSql += "AND CJ_NUM = CK_NUM "
	cSql += "AND CJ_CLIENTE = CK_CLIENTE "
	cSql += "AND CJ_LOJA = CK_LOJA "  
	cSql += "AND SCJ.D_E_L_E_T_ = SCK.D_E_L_E_T_ "
	cSql += "WHERE "
	cSql += " CJ_FILIAL = '"+xFilial("SCJ")+"' "
	cSql += "AND CJ_XNUMOS <> '' "
	
	// tipo de faturamento - por cliente - pega tudo do cliente independente de loja
	If _cTpFat == "1" .Or. Empty(_cTpFat)                                                               
		cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"' "
	// tipo de faturamento - por loja - pega tudo do cliente somente para a loja do contrato
	ElseIf _cTpFat == "2"
		cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"' AND CJ_LOJA = '"+_cLjCnt+"' "
	EndIf
	
	//cSql += " AND CJ_CLIENTE = '"+_cCliCnt+"' "
	cSql += " AND CJ_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "
	cSql += " AND CJ_NUM = '"+aList2[nI][2]+"' "	// orcamentos originados de OS
	cSql += " AND SCK.D_E_L_E_T_ = '' "
	cSql += "GROUP BY CK_PRODUTO,CK_DESCRI,CK_PRCVEN,CK_XPRCPP,CK_LOCAL "
	cSql += "ORDER BY CK_PRODUTO "
	
	If Select("TRBX") > 0   
		TRBX->(dbCloseArea())
	EndIf                   
	
	TcQuery cSql New Alias "TRBX"
	dbSelectArea("TRBX")
	While !EOF()
	
		// DESCONSIDERAR PEDIDOS COM VALOR ZERO
		If TRBX->VALTOT == 0
			TRBX->(dbSkip())
			Loop
		EndIf
		
		AADD( aProdutos, { TRBX->CK_PRODUTO, AllTrim(TRBX->CK_DESCRI), TRBX->QTD,TRBX->CK_PRCVEN,;
						 TRBX->VALTOT, aList2[nI][2], TRBX->CK_XPRCPP, TRBX->CK_LOCAL, aList2[nI][9],aList2[nI][5] } )	
						 
		nValTot += TRBX->VALTOT
						 
		dbSkip()
	End
	
	TRBX->(dbCloseArea())
Next nI


If Empty(aProdutos) 
	AADD( aProdutos, { "", "", 0, 0.0, 0, "",0.0,"","","" } )
EndIf


MsProcTxt("Consolidando produtos..")

// consolida produtos
If !Empty( aProdutos )
	aList3 := AglProd(2)
EndIf


If Empty(aList2)
	AADD( aList2, { .F., "", DTOC(STOD("")), 0, 0, "","","","","","","","" } )	
EndIf

MsProcTxt("Lojas do cliente..")

// lojas do cliente
cSql := "SELECT A1_LOJA, A1_NREDUZ FROM " +RetSqlName("SA1")
cSql += " WHERE A1_COD = '"+_cCliCnt+"' AND D_E_L_E_T_ = '' "
If Select("TRBX") > 0   
	TRBX->(dbCloseArea())
EndIf                   

TcQuery cSql New Alias "TRBX"
dbSelectArea("TRBX")
While !EOF()
	AADD( _aLojas, { TRBX->A1_LOJA, TRBX->A1_NREDUZ } )	
	dbSkip()
End

TRBX->(dbCloseArea())



MsProcTxt("Or็amentos tok take..")

_aList4 := {}

// orcamentos pp toktake
cSql := "SELECT CJ_NUM, CJ_XNUMOS, CJ_EMISSAO, CJ_LOJA, CJ_XNUMPV,CJ_XPATRIM, SUM(CK_VALOR) TOTAL, SCJ.R_E_C_N_O_ CJREC "
cSql += " FROM " +RetSqlName("SCJ") + " SCJ "
cSql += "INNER JOIN " +RetSqlName("SCK") +" SCK ON "
cSql += "CJ_FILIAL = CK_FILIAL "
cSql += "AND CJ_NUM = CK_NUM "
cSql += "AND CJ_CLIENTE = CK_CLIENTE  "
cSql += "AND CJ_LOJA = CK_LOJA "
cSql += "AND SCJ.D_E_L_E_T_ = SCK.D_E_L_E_T_ "
//cSql += " AND SCK.CK_XPRCPP > 0 "


cSql += "INNER JOIN " +RetSqlName("SZG") +" ON "
cSql += "ZG_NUMOS = CJ_XNUMOS "

cSql += "WHERE "
cSql += " CJ_FILIAL = '"+xFilial("SCJ")+"' "
cSql += " AND CJ_CLIENTE = '000001' AND CJ_LOJA = '0001' "
cSql += " AND CJ_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "
cSql += " AND CJ_XNUMOS <> '' "		// orcamentos originados de OS
//cSql += " AND CJ_STATUS = 'A' "	// orcamentos em aberto
//cSql += " AND CK_NUMPV = '' "		// orcamentos em aberto
cSql += " AND CJ_XPATRIM <> '' "
cSql += " AND SCJ.D_E_L_E_T_ = '' "

// cliente da OS
cSql += " AND ZG_CLIFOR = '"+_cCliCnt+"' "
cSql += " AND ZG_LOJA = '"+_cLjCnt+"' "

cSql += " GROUP BY CJ_NUM,CJ_XNUMOS,CJ_EMISSAO, CJ_LOJA, CJ_XNUMPV,CJ_XPATRIM, SCJ.R_E_C_N_O_ "
cSql += "ORDER BY CJ_EMISSAO"


If Select("TRBX") > 0
	TRBX->(dbCloseArea())
EndIf                   

TcQuery cSql New Alias "TRBX"
dbSelectArea("TRBX")
While !EOF()
	cNumPed := ""
	cNota := ""
	cModelo := ""
	cCodPa := ""
	cDescPA := ""
	
	/*
	nPos := Ascan( aList2, { |x| AllTrim(x[5]) == AllTrim(TRBX->CJ_XPATRIM) .And. AllTrim(x[13]) == AllTrim(TRBX->CJ_XNUMOS)  } )
	If nPos == 0		
		dbSkip()
		Loop
	EndIf
	*/
	
	
	If Empty(_cCodTab)
		_cCodTab := AllTrim( Posicione( "SCJ",1,xFilial("SCJ")+AvKey(TRBX->CJ_NUM,"CJ_NUM"),"CJ_TABELA" ) )
	EndIf
	
	If !Empty(TRBX->CJ_XNUMPV)
		dbSelectArea("SC5")
		dbSetOrder(1)
		If MSSeek( xFilial("SC5") +AvKey(TRBX->CJ_XNUMPV,"C5_NUM")  )
			If AllTrim(SC5->C5_NOTA) <> "XXXXXXXXX"
				cNumPed := SC5->C5_NUM
				cNota := IIF(AllTrim(SC5->C5_NOTA) <> "XXXXXXXXX",SC5->C5_NOTA,"")
			Else
				cNota := IIF(AllTrim(SC5->C5_NOTA) <> "XXXXXXXXX",SC5->C5_NOTA,"")
			EndIf
		EndIf
	EndIf
	
	
	cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBX->CJ_XPATRIM,"N1_CHAPA"),"N1_DESCRIC" )
	cCodPa := Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBX->CJ_XPATRIM,"N1_CHAPA"),"N1_XPA"  )
	If !Empty(cCodPa)
		cDescPA := Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(cCodPa,"ZZ1_COD"),"ZZ1_DESCRI" )
	EndIf
	
	
	dbSelectArea("TRBX") 

	
	AADD( _aList4, { IIF(Empty(cNumPed),.T.,.F.), TRBX->CJ_NUM, DTOC(STOD(TRBX->CJ_EMISSAO)), TRBX->TOTAL,;
					 TRBX->CJ_XPATRIM,cModelo, cCodPA,cDescPA, TRBX->CJ_LOJA,cNumPed,cNota,TRBX->CJREC,TRBX->CJ_XNUMOS } )
	
	dbSkip()
End

TRBX->(dbCloseArea())

If Empty(_aList4)
	AADD( _aList4, { .F., "", DTOC(STOD("")), 0, 0, "","","","","","","","" } )
EndIf


MsProcTxt("Hist๓rico de faturamento..")
_aList5 := {}
	 
// historico de faturamento
cSql := "SELECT * FROM " +RetSqlName("SC5") + " SC5 "
cSql += " INNER JOIN " +RetSqlName("ZZC") + " ZZC ON "
cSql += " ZZC_CODIGO = C5_XFINAL AND ZZC.D_E_L_E_T_ = '' "
cSql += " WHERE C5_CLIENTE = '"+_cCliCnt+"' AND C5_XPREPED = 'S' AND C5_XFINAL IN ('J','S') "
cSql += " AND SC5.D_E_L_E_T_ = '' "
cSql += " ORDER BY C5_EMISSAO DESC "

MpSysOpenQuery( cSql,"TRBX" )
dbSelectArea("TRBX")
While !EOF()                        
			
	AADD( _aList5, { TRBX->C5_NUM, DTOC(STOD(TRBX->C5_EMISSAO)), TRBX->ZZC_FINAL, TRBX->C5_CLIENTE, TRBX->C5_NOTA, TRBX->C5_SERIE  } )
	
	dbSkip()
End

If Empty(_aList5)
	_aList5 := { { "","","","","","" } }	 
EndIf


// contadores maquina - relatorio
_aMaqCnt := {}
aAxMaq := aclone(aList2)
aSort( aAxMaq,,,{ |x,y| x[5] < y[5] .And. ctod(x[3]) < ctod(y[3]) } ) 

For nI := 1 To Len(aAxMaq)
	If AScan( _aMaqCnt, { |x| x[1] == aAxMaq[nI][5] } ) == 0
		AADD( _aMaqCnt, { aAxMaq[nI][5], 0,0,aAxMaq[nI][9],stod(""),stod(""),stod(""),0  } )	// maquina cont_ant cont_atu loja data_ultimo_orcamento dtins dtrem minimo
	EndIf
Next nI
    

For nI := 1 To Len(_aMaqCnt)    

	aOS := {}
	dInstall := stod("")
	dRemov := stod("")
	cLojaPat := _aMaqCnt[nI][4]
	/*
	For nJ := 1 To Len(aAxMaq)
		If aAxMaq[nJ][5] == _aMaqCnt[nI][1]       
			AADD( aOS, { aAxMaq[nJ][13],ctod(aAxMaq[nJ][3])  } )			
		EndIf
	Next nJ
	aSort( aOS,,,{ |x,y| x[1] < y[1] } ) 
	// REC Contador Ant e Atual
	If !Empty( aOS )
		nPosFim := 1
		If Len( aOS ) > 1 
			nPosFim := Len(aOS)		
		EndIf
		
		// pegar reg do contador anterior
		//If ( Len(_aMaqCnt[nI][2]) ) == 0
			nRecAnt := STATICCALL( TTFAT39C, ZNCon, _aMaqCnt[nI][1],aOS[1][2] )
			_aMaqCnt[nI][2] := nRecAnt
		//EndIf
		
		// reg do reg atual
		dbSelectArea("SZN")
		dbSetOrder(4)
		If MsSeek( xFilial("SZN") +AvKey( aOS[nPosFim][1] ,"ZN_NUMOS") )
			_aMaqCnt[nI][3] := Recno()
		EndIf
		             
		// data ultimo orcamento
		_aMaqCnt[nI][5] := aOS[nPosFim][2]							
	EndIf
	*/
	

	// data instalacao
	dbSelectArea("AA3")
	dbSetOrder(6)
	If MsSeek( xFilial("AA3") +AvKey( _aMaqCnt[nI][1],"AA3_NUMSER") )
		If AA3->AA3_CODCLI == _cCliCnt .And. AA3->AA3_LOJA == cLojaPat
			dInstall := AA3->AA3_DTINST
			
			If Empty( dInstall )
				dUltOrc := _aMaqCnt[nI][5]
				dInstall := DtInstMaq( _aMaqCnt[nI][1],_cCliCnt,cLojaPat,dUltOrc, @dInstall,.F. )
			EndIf
		Else		
			// data remocao - procurar data de remocao da maquina apos a data do orcamento
			dUltOrc := _aMaqCnt[nI][5]
			
			// data instalacao
			DtInstMaq( _aMaqCnt[nI][1],_cCliCnt,cLojaPat,dUltOrc, @dInstall,.T. )
			
			
			cLogObs := "TRANSFERENCIA DE CLIENTE/LOJA " +_cCliCnt +"/" +cLojaPat
			
			cQuery := "SELECT TOP 1 AAF_DTINI FROM " +RetSqlName("AAF")
			cQuery += " WHERE AAF_NUMSER = '"+_aMaqCnt[nI][1]+"' AND AAF_DTINI >= '"+DTOS(dUltOrc)+"' AND D_E_L_E_T_ = '' "
			cQuery += " AND AAF_CODCLI <> '"+_cCliCnt+"' AND AAF_LOJA <> '"+cLojaPat+"' "
			cQuery += " AND AAF_LOGINI LIKE '%"+cLogObs+"%' "
			cQuery += " ORDER BY AAF_DTINI"
			
			MpSysOpenQuery( cQuery, "TRBX" )
			dbSelectArea("TRBX")
			If !EOF()
				dRemov := STOD(TRBX->AAF_DTINI)
			EndIf
			
			TRBX->(dbCloseArea())				
		EndIf			
	EndIf 
	                              
	_aMaqCnt[nI][6] := dInstall 
	_aMaqCnt[nI][7] := dRemov	        
	_aMaqCnt[nI][8] := _nMinimo
	
Next nI

	              
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22C  บAutor  ณMicrosiga           บ Data ณ  10/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DtInstMaq( cPatrimo,cCliente,cLoja,dUltOrc, dInstall,lRemoveu )

Local cQuery := ""

// data instalacao
cQuery := "SELECT TOP 1 ZD_DATAINS FROM " +RetSqlName("SZD")
cQuery += " WHERE ZD_PATRIMO = '"+cPatrimo+"' AND ZD_DATAINS <= '"+DTOS(dUltOrc)+"' "
cQuery += " AND ZD_CLIENTE = '"+cCliente+"' AND ZD_LOJA = '"+cLoja+"' "

If !lRemoveu
	cQuery += "	AND ZD_IDSTATU = '1' AND D_E_L_E_T_ = '' "
Else 
	cQuery += "	AND ZD_IDSTATU = '0' AND D_E_L_E_T_ = '' "
EndIf

cQuery += " AND D_E_L_E_T_ = '' "

cQuery += " ORDER BY ZD_DATAINS DESC "
		
MpSysOpenQuery( cQuery, "TRBX" )
dbSelectArea("TRBX")
If !EOF()
	dInstall := STOD(TRBX->ZD_DATAINS)
EndIf

TRBX->(dbCloseArea())	
			
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22C  บAutor  ณMicrosiga           บ Data ณ  08/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NfRem()

Local oDlg1 := NIL                  
Local aNFS := {}
Local cNotas := ""
Local cQuery := ""
Local cPAs := ""
Local nI
Local aSize := MsAdvSize()
Local aAxNf := {}
Private oSim	:= LoadBitMap(GetResources(), "LBOK")
Private oNao	:= LoadBitMap(GetResources(), "LBNO")
                                                                               
// notas de PAS
For nI := 1 To Len(aList2)
	If ! aList2[nI][7] $ cPAs           
		If Empty(cPAs)
			cPAs += "'" +aList2[nI][7] + "'"
		Else 
			cPAs += "," +"'" +aList2[nI][7] + "'"		
		EndIf
	EndIf
Next nI


cQuery := "SELECT TOP 10 F2_DOC, F2_EMISSAO,F2_XCODPA FROM " +RetSqlName("SF2")
cQuery += " WHERE F2_EMISSAO BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' " 
cQuery += " AND F2_XCODPA IN ( "+cPAs+" ) AND F2_XFINAL = '4' AND F2_XNFABAS = '1' AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY F2_EMISSAO DESC "

MpSysOpenQuery(cQuery,"TRB")

dbSelectArea("TRB")
While !EOF()
	AADD( aNFS, { .F., TRB->F2_DOC, DTOC(STOD(TRB->F2_EMISSAO)),"PA - " +AllTrim(TRB->F2_XCODPA) } )
	dbSkip()
End

TRB->(dbCloseArea())

// notas de ROTAS - ADICIONAR CAMPO ROTA NA TABELA SZ0 - Z0_ARMORI
cQuery := "SELECT TOP 10 Z0_PRODUTO, ZG_ROTA, ZG_DATAFIM FROM " +RetSqlName("SZ0") +" SZ0 "

cQuery += "LEFT JOIN " +RetSqlName("SZG") +" ON "
cQuery += "ZG_NUMOS = Z0_NUMOS "

cQuery += " WHERE Z0_PA IN ( "+cPAs+" ) "
cQuery += " AND Z0_DATA BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' " 
cQuery += " AND SUBSTRING( ZG_ROTA,1,1 ) = 'R' " 
cQuery += " ORDER BY Z0_DATA DESC"

MpSysOpenQuery(cQuery,"TRB")

dbSelectArea("TRB")
While !EOF()

	aAxNf := fNotRota( TRB->ZG_ROTA, TRB->Z0_PRODUTO,stod(TRB->ZG_DATAFIM) )
	For nI := 1 To Len( aAxNF )
		If AScan( aNFS, { |x| x[2] == aAxNf[nI][1] }  ) == 0
			AADD( aNFS, { .F., aAxNf[nI][1], aAxNf[nI][2],"ROTA - "+AllTrim(TRB->ZG_ROTA) } )
		EndIf
	Next nI
	
	dbSelectArea("TRB")
	dbSkip()
End

If Empty(aNFS)
	MsgInfo("Nenhuma nota encontrada nesse perํodo.")
	Return cNotas
EndIf


If !Empty(_cNotas)
	aAx := StrTokarr( _cNotas,"/" )
	For nI := 1 To Len( aNFS )
		For nJ := 1 To Len( aAx )
			If AllTrim(aNFS[nI][2]) == PADL( aAx[nJ],TamSx3("F2_DOC")[1],"0" )
				aNFS[nI][1] := .T.
			EndIf
		Next nJ
	Next nI
EndIf

oWnd := MSDialog():New( 0,0,300,500,"Notas fiscais",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )		
	
	oList := TCBrowse():New(0,0,0,0,,,,oWnd,,,,{ || },{ ||  },,,,,,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aNFS)
	  
	oList:AddColumn(TCColumn():New(''				,{ || IIF(aNFS[oList:nAt][1],oSim,oNao)  },"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Nota fiscal'	,{|| aNFS[oList:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList:AddColumn(TCColumn():New('Emissใo'		,{|| aNFS[oList:nAt][3] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Tipo saida'		,{|| aNFS[oList:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))

	                                      
	oList:Align := CONTROL_ALIGN_ALLCLIENT
	oList:bLDblClick := {|| DblClk(@aNFS,@cNotas)} 	
	oList:nScrollType := 1 
			    
oWnd:Activate(,,,.T.) 

If !Empty(cNotas)
	_cNotas := cNotas
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT22C  บAutor  ณMicrosiga           บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fNotRota( cRota, cProduto,dFimOS )

Local aNotas := {}
Local cQuery := ""

cQuery := "SELECT Z7_DOC, Z7_EMISSAO FROM " +RetSqlName("SZ7")
cQuery += " WHERE Z7_ARMMOV = '"+cRota+"' AND Z7_COD = '"+cProduto+"' AND Z7_SAIDA >= '"+DTOS(dFimOS)+"'  "
cQuery += " AND Z7_RETORNO <= '"+DTOS(dFimOS)+"' "

MpSysOpenQuery(cQuery,"TRBR")

dbSelectArea("TRBR")
While !EOF()
	AADD( aNotas, { TRBR->Z7_DOC, DTOC(STOD(TRBR->Z7_EMISSAO)) } )
	dbSkip()
End

TRBR->(dbCloseArea())

Return aNotas


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDblClk  บAutor  ณJackson E. de Deus    บ Data ณ  08/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DblClk(aNFS,cNotas)

If aNFs[oList:nAt][1]         
	aNFs[oList:nAt][1] := .F.		
Else
	aNFs[oList:nAt][1] := .T.                                   
EndIf
    
cNotas := ""
For nI := 1 To Len(aNFs)
	If aNFs[nI][1]                 
		cNF := Cvaltochar(Val(aNFs[nI][2]))
		If Empty(cNotas)
			cNotas += cNF
		Else
			cNotas += "/" +cNF
		EndIf
	EndIf
Next nI


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReproc    บAutor  ณJackson E. de Deus  บ Data ณ  27/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Reprocessamento dos calculos das doses                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function Reproc()
                      
Local aOS := {}        
Local nI

If !MsgYesNo("Deseja reprocessar os or็amentos?" +CRLF +"Somente os or็amentos que estใo em aberto podem ser reprocessados.")
	Return
EndIf
					 
For nI := 1 To Len(aList2)
	cNumOS := aList2[nI][13]
	AADD( aOS, cNumOS )
Next nI

If !Empty(aOS)
	Processa(  { || ExecRep(aOS)  }, "Reprocessando.." )
EndIf

Return                                           
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecRep  บAutor  ณJackson E. de Deus   บ Data ณ  27/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa o reprocessamento                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function ExecRep(aOS)

Local nI

ProcRegua(Len(aOS))

For nI := 1 To Len(aOS)
	IncProc("OS: " +aOS[nI])
	U_TTFAT20C(aOS[nI],.T.)
Next nI

Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustePrc  บAutor  ณJackson E. de Deus บ Data ณ  08/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajuste de preco                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustePrc()

Local lEnd := .F.
Local lUpdated := .F.

If !MsgYesNo("Deseja atualizar os pre็os dos or็amentos?")
	Return
EndIf

Processa(  { |lEnd| lUpdated := PrcAjsPrc(@lEnd)  }, "Reajustando pre็os..","Aguarde..",.T. )

If lUpdated
	CursorWait()
	MsAguarde( { || Carga() },"Aguarde, carregando dados.." )
	CursorArrow()
	
	EncheList()
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrcAjsPrc  บAutor  ณMicrosiga           บ Data ณ  08/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrcAjsPrc(lEnd)

Local nI
Local lUpdated := .F.
Local cNumOrc := ""
Local cMaquina := ""
Local cTabela := ""
Local aPreco := {}
Local nPreco := 0
Local nPrcPP := 0


ProcRegua(Len(aList2))

For nI := 1 To Len(aList2)

	cNumOrc := aList2[nI][2]
	cMaquina := aList2[nI][5]
	cTabela := Posicione( "SN1",2, xFilial("SN1") +AvKey(cMaquina,"N1_CHAPA"),"N1_XTABELA" )
	aPreco := {}
	
	IncProc("Or็amento " +cNumOrc)
	
	If Empty(cTabela)
		Loop
	EndIf
	
	dbSelectArea("SCK")
	dbSetOrder(1)
	If dbSeek( xFilial("SCK") +AvKey(cNumOrc,"CK_NUM") )
		While SCK->CK_FILIAL == xFilial("SCK") .And. SCK->CK_NUM == cNumOrc .And. !EOF()
		        
			nPreco := 0
			nPrcPP := 0
					
			aPreco := STATICCALL( TTPROC56, fPRC,cTabela,SCK->CK_PRODUTO )
			If ValType(aPreco) == "A"
				If Len(aPreco) == 2
					nPreco := aPreco[1]
					nPrcPP := aPreco[2]
					
					dbSelectArea("SCK")    
						
					If SCK->CK_PRCVEN <> nPreco .Or. SCK->CK_XPRCPP <> nPrcPP
						SCK->(RecLock("SCK",.F.))
						SCK->CK_PRCVEN := nPreco 
						SCK->CK_XPRCPP := nPrcPP
						SCK->CK_VALOR := Round( SCK->CK_QTDVEN*nPreco,2 )
					
						SCK->(MSUNLOCK())
						lUpdated := .T.
					EndIf				
				EndIf
			EndIf
			
			dbSelectArea("SCK")  
			SCK->(dbSkip())
		End
	EndIf 		        	
Next nI


Return lUpdated


Static Function UpdRdp()

Local nVal := 0
Local nI

For nI := 1 To Len(_aList4)
	nVal += _aList4[nI][4]
Next nI

oSVal:SetText( "R$ " +AllTrim( Transform( Round(nVal,2),PesqPict("SF2","F2_VALBRUT") ) ))
oSVal:Refresh()
	
Return