#include "totvs.ch"
#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#INCLUDE "MSGRAPHI.CH"
#include "fwmvcdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTMONITOR บAutor  ณJackson E. de Deus  บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonitor das Ordens de Servi็o Mobile                        บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑบ          ณ                                      					  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ02/06/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ29/07/14ณ01.01 |Adicionada opcao em menu popup para	  ณฑฑ
ฑฑณ								  desabilitar validacao da OS no retorno  ณฑฑ
ฑฑณJackson       ณ02/03/15ณ01.02 |Alteracao de layout e novos recursos.	  ณฑฑ
ฑฑณJackson       ณ19/03/15ณ01.03 |Ajustes e novos indicadores no rodape.  ณฑฑ
ฑฑณJackson       ณ26/03/15ณ01.04 |Correcao na atualizacao de indicadores. ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTMONITOR()
                           
Local aSize	:= MsAdvSize(Nil,.F.)
Local nTempo := 60000	// tempo de refresh de atualizacao das OS - 1 minuto
Local aAlter := {}
Local nOpc := 2
Local cCSSTree		:= ""
Local bSavKeyF4		:= SetKey(VK_F4,Nil)
Local bSavKeyF12	:= SetKey(VK_F12,Nil)
Local bSavKeyF11	:= SetKey(VK_F11,Nil)
Local nWdtPnl		:= Asize[5]/2
Local nWdtPn1		:= (nWdtPnl/2)/2
Local nWdtPn2		:= nWdtPnl-nWdtPn1
Local nHthPnl		:= Asize[6]/2
Local oPanel
Local aCpoAA1 := {"NOUSER", "AA1_CODTEC","AA1_NOMTEC","AA1_PAGER","AA1_LOCAL","AA1_EMAIL","AA1_XSUPER","AA1_XGEREN","AA1_XFILAT","AA1_XEMPRE"}
Local aCpoZG := { "NOUSER", "ZG_FILIAL","ZG_NUMOS","ZG_DESCFRM", "ZG_AGENTED","ZG_CLIFOR","ZG_LOJA","ZG_DESCCF","ZG_PATRIM","ZG_PATRIMD","ZG_ROTA","ZG_ROTAD","ZG_DATAINI","ZG_HORAINI","ZG_DTINI","ZG_HRINI","ZG_LATLNG1","ZG_LATLNG2","ZG_MSG","ZG_DATAFIM","ZG_HORAFIM","ZG_RESPOST","ZG_XLOCFIS"}
Local aCpoSA1 := {"NOUSER", "A1_END","A1_BAIRRO","A1_COMPLEM","A1_MUN","A1_EST"}
Local aPos := {000,000,000,000}
Local oFont2 := TFont():New('Courier new',,-12,.T.)
Private aItems := { "Ordem de Servi็o","Cod. T้cnico","Nome T้cnico","Cod. Supervisor","Nome Supervisor","Cod. Gestor","Nome Gestor" }
Private cCombo := aItems[1]
Private oWindow,oPnlEsq,oPnlDir, oPnlRdpe1, PnlRdpe2,oTree,oMsMGet1,oMsmGet2,oMsmGet3,oPnlmGet,oMsmGet4
Private aArquivos := {}
Private aHeader := {}
Private aCols := {}
Private oLayer := FwLayer():New() 
Private oFont := TFont():New('Courier new',,-18,.T.)
Private aOS := {}                             
Private cLog := ""
Private cImgGestor := "angry1.png"
Private cImgSuper := "angry3.png"
Private cImgTec := "angry4.png"     
Private cImgOS := ""
Private cImgOSAtso := "red_star.png"
Private cCadastro := "Manuten็ใo de OS"      
Private cIncOS := GetMV("MV_XINCOS")
Private lFocoTree := .F.
Private lRefresh := .T.
Private lOpenMenu := .F.
Private _nTotOS := 0		// total geral de OS
Private _nTotInic := 0		// total geral iniciada
Private _nTotAber := 0		// total geral pendente
Private _nTotCanc := 0		// total geral cancelada agente
Private _nTotCanc2 := 0		// total geral cancelada central
Private _nTotFim := 0		// total geral finalizada no prazo
Private _nTotFim2 := 0		// total geral finalizada com atraso
Private _nTotAtraso := 0	// total geral atrasada
Private _nTotPrazo := 0		// total geral no prazo  
Private _aOSFim := {}		// atendentes/os finalizadas
Private _aOSFim2 := {}		// os finalizadas no prazo
Private _aOSCanc := {}		// atendentes/os canceladas
Private _aOSCanc2 := {}		// atendentes/os canceladas
Private _aOSAtraso := {}	// atendentes/os com atraso
Private _aOSPrazo := {}		// atendentes/os no prazo
Private _aFormIndic := {"1","2","3","4","7","8","13","16","17"}	// formularios considerados nos calculos
Private cTxt1 := "Programadas"
Private cTxt2 := "Encer. no prazo"
Private cTxt3 := "Encer. c/ atraso"
Private cTxt4 := "Em aberto no prazo"
Private cTxt5 := "Em aberto c/ atraso"
Private cTxt6 := "Cancelada p/ Agente"
Private cTxt7 := "Cancelada p/ Central"
Private cQtd1 := "0"
Private cQtd2 := "0"
Private cQtd3 := "0"
Private cQtd4 := "0"
Private cQtd5 := "0"
Private cQtd6 := "0"
Private cQtd7 := "0"
Private cQtdP1 := "100%"
Private cQtdP2 := "0"
Private cQtdP3 := "0"
Private cQtdP4 := "0"
Private cQtdP5 := "0"
Private cQtdP6 := "0"
Private cQtdP7 := "0"

DicGrid()
                              

SetKey(VK_F4, { || FormIndic() })
SetKey(VK_F11, { || U_CHKCONN() } )
SetKey(VK_F12, { || IIF(!lRefresh,MsgAlert("A atualiza็ใo estแ desabilitada. Habilite!"),Processa( { || oTimer:DeActivate(),CursorWait(),Refsh(),CursorArrow(),oTimer:Activate() },"Verificando atualiza็๕es, aguarde.."))} )

                                 
// Monta a Tela 
oWindow := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Monitor de Ordens de Servi็o",,,.F.,,,,,,.T.,,,.T. )	
	oWindow:lEscClose := .F.
	oWindow:lMaximized := .T.

	oTimer := TTimer():New( nTempo, {|| IIF(lRefresh .And. lFocoTree,Processa( { || CursorWait(),Refsh(),CursorArrow() },"Verificando atualiza็๕es, aguarde.."),/**/)}, oWindow )  
	oTimer:Activate()
	
	oLayer:Init(oWindow,.F.)
	oLayer:addCollumn('COLUNA1',30,.F.)
	oLayer:addCollumn('COLUNA2',70,.F.)
	oLayer:addWindow("COLUNA1","WIN_1","Ordem de Servi็o",90,.F.,.T.,{||} )
  	oLayer:addWindow("COLUNA2","WIN_2","Detalhe",90,.F.,.T.,{||} )  	
  	oPnlEsq := oLayer:GetWinPanel("COLUNA1","WIN_1" )
	oPnlDir := oLayer:GetWinPanel("COLUNA2","WIN_2" )
	oPnlEsq:FreeChildren()
    oPnlDir:FreeChildren()
     
    // container detalhe 
    oPnlmGet := tPanel():New(0,0,"",oPnlDir,,,,,,0,0)
	oPnlmGet:Align := CONTROL_ALIGN_ALLCLIENT                         
    
   
    // painel inferior - acoes
    oPanel := tPanel():New( 0,0,"",oWindow,,,,,,0,30)
   	oPanel:SetCss( " QLabel { background-color: #E0E0FF; }" )	
	oPanel:Align := CONTROL_ALIGN_BOTTOM
    
	oFld1 := TFolder():New( 0,0,{ "OS","Atualiza็๕es" },{},oPnlEsq,,,,.T.,.F.,160,076,)
	oFld1:Align := CONTROL_ALIGN_ALLCLIENT
		
	// Menu popup
	MENU oMenu POPUP
	MENUITEM "Cancelar" ACTION ( Cancelar() )					// cancelar OS
	MENUITEM "Ver no mapa" ACTION ( MapView() )			
	ENDMENU
		
	// Arvore
	cCSSTree := "QTreeWidget:item:hover { background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #e7effd, stop: 1 #cbdaf1); border: 1px solid #bfcde4; }"
	CSSDictAdd("TTree", cCSSTree)
    
	oTree := DbTree():New( 0,0,0,0,oFld1:aDialogs[1],{ || Visual() },{ || /*RClick(oTree)*/ },.T.,,/*fonte*/,/*"os;teste"*/ )
	oTree:bInit := { || Processa( { || Carregar() },"Carregando ordens de servi็o, aguarde..") } 
    oTree:bRClicked := { |oObject,nX,nY| IIF(oTree:Nivel()==4,oMenu:Activate( nX, (nY-170), oObject ),/**/)  }
    oTree:bLostFocus := { || lFocoTree := .F. }
    oTree:bGotFocus := { || lFocoTree := .T. }    
    oTree:Align := CONTROL_ALIGN_ALLCLIENT
         			
    // Log
    oMsGD := MsNewGetDados():New(0,0,0,0,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,999,'AllwaysTrue()','','AllwaysTrue()',oFld1:aDialogs[2],aHeader,aCols, { || oMsGD:Acols := aCols})
   	oMsGD:oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
        
	oFld2 := TFolder():New( 0,0,{"Agente","OS","Indicadores"},{},oPnlmGet,,,,.T.,.F.,160,076,)
	oFld2:Align := CONTROL_ALIGN_ALLCLIENT    
  	
    // MsmGet1 tecnicos
	oMsmGet1 := MsmGet():New("AA1",Recno(),2,,,,aCpoAA1,aPos,,,,,,oFld2:aDialogs[1],,.F.,.F.)                                                      
	oMsmGet1:oBox:align := CONTROL_ALIGN_ALLCLIENT
	oMsmGet1:Hide()
		
	// MsmGet SZG
	oMsmGet2 := MsmGet():New("SZG",Recno(),2,,,,aCpoZG,aPos,,,,,,oFld2:aDialogs[2],,.F.,.F.)                                                      
	oMsmGet2:oBox:align := CONTROL_ALIGN_ALLCLIENT
	oMsmGEt2:Hide()
	
	// MsmGet cliente
	oMsmGet3 := MsmGet():New("SA1",Recno(),2,,,,aCpoSA1,aPos,,,,,,oFld2:aDialogs[2],,.F.,.F.)                                                      
	oMsmGet3:oBox:align := CONTROL_ALIGN_BOTTOM
	oMsmGet3:oBox:nHeight += 10
	oMsMGet3:Hide()
	
	// rodape
	oLg1 := TBitmap():Create(oPanel,0,0,10,10,"BR_AZUL"			,,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)			// programadas
	oLg2 := TBitmap():Create(oPanel,10,0,10,10,"BR_VERDE"		,,.T., {|| Indic(4) },,.F.,.F.,,,.F.,,.T.,,.F.)	// encerradas no prazo
	oLg3 := TBitmap():Create(oPanel,20,0,10,10,"BR_PINK"		,,.T., {|| Indic(5) },,.F.,.F.,,,.F.,,.T.,,.F.)	// encerradas com atraso
	oLg4 := TBitmap():Create(oPanel,10,120,10,10,"BR_AMARELO"	,,.T., {|| Indic(7) },,.F.,.F.,,,.F.,,.T.,,.F.)	// abertas no prazo
	oLg5 := TBitmap():Create(oPanel,20,120,10,10,"red_star.png"	,,.T., {|| Indic(6) },,.F.,.F.,,,.F.,,.T.,,.F.)	// abertas em atraso
	oLg6 := TBitmap():Create(oPanel,10,260,10,10,"BR_CINZA"		,,.T., {|| Indic(3) },,.F.,.F.,,,.F.,,.T.,,.F.)	// canceladas pelo agente
	oLg7 := TBitmap():Create(oPanel,20,260,10,10,"BR_MARROM"	,,.T., {|| Indic(2) },,.F.,.F.,,,.F.,,.T.,,.F.)	// canceladas pela central
			
	oSLg1 := TSay():New( 0,10	,{|| "Programadas"}			,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,50,008,,,,,,.F.)
	oSLg2 := TSay():New( 10,10	,{|| "Encer. no prazo"}		,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,50,008,,,,,,.F.)
	oSLg2:bLClicked := { || Indic(4)  }
	oSLg3 := TSay():New( 20,10	,{|| "Encer. c/ atraso"}	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,50,008,,,,,,.F.)
	oSLg3:bLClicked := { || Indic(5)  }
	oSLg4 := TSay():New( 10,130	,{|| "Em aberto no prazo"}	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg4:bLClicked := { || Indic(7)  }
	oSLg5 := TSay():New( 20,130	,{|| "Em aberto c/ atraso"}	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg5:bLClicked := { || Indic(6)  }
	oSLg6 := TSay():New( 10,275	,{|| "Cancelada p/ Agente"}	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg6:bLClicked := { || Indic(3)  }
	oSLg7 := TSay():New( 20,275	,{|| "Cancelada p/ Central"},oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg7:bLClicked := { || Indic(2)  }
	
	oSLgQ1 := TSay():New( 0,75	,{|| cQtd1 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ2 := TSay():New( 10,75	,{|| cQtd2 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ3 := TSay():New( 20,75	,{|| cQtd3 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ4 := TSay():New( 10,205,{|| cQtd4 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ5 := TSay():New( 20,205,{|| cQtd5 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ6 := TSay():New( 10,365,{|| cQtd6 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ7 := TSay():New( 20,365,{|| cQtd7 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)	
	
	oSQP2 := TSay():New( 10,95	,{|| cQtdP2 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP3 := TSay():New( 20,95	,{|| cQtdP3 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP4 := TSay():New( 10,235	,{|| cQtdP4 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP5 := TSay():New( 20,235	,{|| cQtdP5 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP6 := TSay():New( 10,385	,{|| cQtdP6 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP7 := TSay():New( 20,385	,{|| cQtdP7 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)	
	
	oSLgQ5:SetCss(" QLabel {font: bold 12px; color: #CC0000; } ")
	oSQP5:SetCss(" QLabel { font: bold 12px; color: #CC0000; } ")	
	
	// menu        	   
	nWidth 	:= 100		
	nHeight := 150    	
   	nTop 	:= 1500
	nLeft 	:= 1500
	oPanelX  := tPanel():New(nTop,nLeft,,oWindow,,,,,,nWidth,nHeight) 	
	
	// estilo do menu
	oPanelX:SetCss( " QLabel { background-color: black; border-radius: 12px ; border: 2px solid gray;}" )		
	cColorBackGround 	:= "#000000"		
	cColorSeparator 	:= "#FFFFFF"		
	cGradientTop 		:= "#087BA6" 
	
	// Gradiente inicial do botao selecionado		
	cGradientBottom 	:= "#087BA6" 
	
	// Gradiente final do botao selecionado		
	cColorText		:= "#C0C0C0" 		
			
   	cHeigthBtn := 40		
	oFont := TFont():New('Arial',,10,,.T.,,,,,.F.,.F.)	
	oFont2 := TFont():New('Arial',,12,,.T.,,,,,.F.,.F.)
	oMWMenu  := TTrackMenu():New( oPanelX, 3, 2, nWidth-4, nHeight-6, {|o,cID| MyAction(o, cId) }, cHeigthBtn, cColorBackGround, cColorSeparator,;
			                                cGradientTop, cGradientBottom, oFont, cColorText ) 		
	
	// Insere botoes		
	oMWMenu:Add("ID001", "Pesquisar"	, "Pesquisa"			, "lupa.png"		)		
	oMWMenu:Add("ID002", "Incluir OS"	, "Inclui uma OS"		, "BMPINCLUIR.png"	)		
	oMWMenu:Add("ID003", "Legenda"		, "Status das OS"		, "objetivo.png" 	)
	oMWMenu:Add("ID004", "Refresh"		, "Habilita/desabilita"	, "ok.png" 	)        
	oMWMenu:Add("ID006", "Sair"			, "Sai da tela"     	, "FINAL.png"  )		

	oPanelX:nTop := aSize[6] - (nHeight+200)
	oPanelX:nLeft := aSize[5] +10
	
	oBtnX := TButton():New( 0,0,"Op็๕es",oPanel,{ || OpenMenu()  },040,015,,oFont2,,.T.,,"Menu de op็๕es",,,,.F. )
	oBtnX:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:ENGRENAGEM.png); background-repeat: none; margin: 1px }" ) 
	
	oWindow:bStart = { || oBtnX:nLeft := oPanelX:nLeft -100  }	// recua o botao a esquerda c/ ref. ao painel container
	
oWindow:Activate(,,,.T.) 

// Restaura os F
SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F11,bSavKeyF11 )
SetKey(VK_F12,bSavKeyF12 )

      
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMyAction บAutor  ณJackson E. de Deus   บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAcao no clique de opcao do menu                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MyAction(oMWMenu, cId)

Local nX	
Local oDlg
Local oGet1,oBtn    
Local oPanel
Local oFont := TFont():New('Arial',,16,,.T.,,,,,.F.,.F.)
Private oCBox1
Private cPesq := Space(20)

If cId == "ID001"
	OpenMenu()
	oDlg := MSDialog():New(0,0,100, 412,"Pesquisa",,,,,,,,,.T.,,,,.T.)
		oPanel := tPanel():New(0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,0)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT
		oPanel:SetCss( "QLabel { background-color: #EBEBFF; }" )		
		
		oCBox1 := TComboBox():New( 20,10,{|u|if( PCount()>0,cCombo:=u,cCombo )},aItems,070,15,oPanel,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo)	
		oCBox1:SetHeight(30)
		oCBox1:SetCSS("QComboBox { border: 1px solid gray; border-radius: 3px; padding: 1px 18px 1px 3px; min-width: 6em; background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #D3D3D3, stop: 0.4 #D8D8D8, stop: 0.5 #DDDDDD, stop: 1.0 #E1E1E1); } ")
		
		oGet1 := TGet():New( 20,81,{ |u| If( Pcount()>0,cPesq:=u,cPesq ) },oPanel,070,13,'',,CLR_BLACK,CLR_WHITE,oFont,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,,,,,"Digite")					                                                                                          
		oGet1:SetCss("QLineEdit { border: 1px solid gray; border-radius: 3px; color: #5C5C99; font: 16px; }") //;QLabel {font: bold 14px; color: #CC0000; }")
		
		oBtn := TButton():New( 20,152,"Pesquisar",oPanel,{ || Pesquisa(), oDlg:End() },050,15,,,,.T.,,"",,,,.F. )
		oBtn:SetCss( "QPushButton{ border: 1px solid gray; border-radius: 3px; background-image: url(rpo:LUPA.png); background-repeat: none; margin: 1px }" )			
	oDlg:Activate(,,,.T.,{|| },,{ || } )

ElseIf cId == "ID002"
	OpenMenu()
	IncluirOS()
ElseIf cId == "ID003"
	OpenMenu()
	STATICCALL( TTPROC30, Legenda )//Legenda()
ElseIf cId == "ID004"
	If lRefresh
		lRefresh := .F.
		oMWMenu:SetImage( "ID004", "cancel.png" )
		oMWMenu:Refresh()	
	Else
		lRefresh := .T. 
		oMWMenu:SetImage( "ID004", "ok.png" )	
		oMWMenu:Refresh()
	EndIf
ElseIf cId == "ID005"
	OpenMenu()
	Indic()
ElseIf cId == "ID006"
	OpenMenu()
	oWindow:End()
EndIf	                     	                                                

Return
                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOpenMenu บAutor   ณJackson E. de Deus  บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abertura/Fechamento do menu                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OpenMenu()
    
Local nI

If lOpenMenu
	//oPanelX:Hide()
	For nI := 1 To 42
		oPanelX:nLeft += 5
		oPanelX:CoorsUpdate()
		oPanelX:Refresh()
	Next nI
	lOpenMenu := .F.
Else
	//oPanelX:Show()  
	For nI := 1 To 42
		oPanelX:nLeft -= 5
		oPanelX:CoorsUpdate()
		oPanelX:Refresh()
	Next nI          
	lOpenMenu := .T.
EndIf	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIndic บAutor  ณJackson E. de Deus      บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Indicadores de performance                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Indic(nOpcao)

Local oDlg        
Local oPanel
Local oLayer1 := FWLayer():New()
Local oFont3 := TFont():New('Courier new',,-18,.T.)
Local aInfo := {}
Local cDescri := ""
Local aATD := {}
Local nI,nJ,nCont := 0

// canceladas pela central
If nOpcao == 2
	For nI := 1 To Len(_aOSCanc2)
		If Ascan( aATD, { |x| x[1] == _aOSCanc2[nI][1] } ) == 0
			AADD( aATD, { _aOSCanc2[nI][1], 0, "" } )
		EndIf
	Next nI
	
	For nI := 1 To Len(aATD)
		For nJ := 1 To Len(_aOSCanc2)
			If aATD[nI][1] == _aOSCanc2[nJ][1]
				nCont++
			EndIf
		Next nJ
		 
		aATD[nI][3] := aATD[nI][1]
		aATD[nI][1] := AllTrim( Posicione( "AA1", 1, xFilial("AA1") +AvKey(	aATD[nI][1],"AA1_CODTEC"),"AA1_NOMTEC" ) )
		aATD[nI][2] := nCont
		
		nCont := 0
	Next nI
	      
	aInfo := Aclone(aATD)
	cDescri := "Canceladas pela Central"

// canceladas pelo agente
ElseIf nOpcao == 3
	For nI := 1 To Len(_aOSCanc)
		If Ascan( aATD, { |x| x[1] == _aOSCanc[nI][1] } ) == 0
			AADD( aATD, { _aOSCanc[nI][1], 0, "" } )
		EndIf
	Next nI
	
	For nI := 1 To Len(aATD)
		For nJ := 1 To Len(_aOSCanc)
			If aATD[nI][1] == _aOSCanc[nJ][1]
				nCont++
			EndIf
		Next nJ
		 
		aATD[nI][3] := aATD[nI][1]
		aATD[nI][1] := AllTrim( Posicione( "AA1", 1, xFilial("AA1") +AvKey(	aATD[nI][1],"AA1_CODTEC"),"AA1_NOMTEC" ) )
		aATD[nI][2] := nCont
		
		nCont := 0
	Next nI
	      
	aInfo := Aclone(aATD)
	cDescri := "Canceladas pelo Agente"
                  
// finalizadas no prazo
ElseIf nOpcao == 4
	For nI := 1 To Len(_aOSFim)
		If Ascan( aATD, { |x| x[1] == _aOSFim[nI][1] } ) == 0
			AADD( aATD, { _aOSFim[nI][1], 0, "" } )
		EndIf
	Next nI
	
	For nI := 1 To Len(aATD)
		For nJ := 1 To Len(_aOSFim)
			If aATD[nI][1] == _aOSFim[nJ][1]
				nCont++
			EndIf
		Next nJ
		 
		aATD[nI][3] := aATD[nI][1]
		aATD[nI][1] := AllTrim( Posicione( "AA1", 1, xFilial("AA1") +AvKey(	aATD[nI][1],"AA1_CODTEC"),"AA1_NOMTEC" ) )
		aATD[nI][2] := nCont
		
		nCont := 0
	Next nI
	      
	aInfo := Aclone(aATD)
	cDescri := "Encerradas no prazo"

// finalizadas com atraso
ElseIf nOpcao == 5
	For nI := 1 To Len(_aOSFim2)
		If Ascan( aATD, { |x| x[1] == _aOSFim2[nI][1] } ) == 0
			AADD( aATD, { _aOSFim2[nI][1], 0, "" } )
		EndIf
	Next nI
	
	For nI := 1 To Len(aATD)
		For nJ := 1 To Len(_aOSFim2)
			If aATD[nI][1] == _aOSFim2[nJ][1]
				nCont++
			EndIf
		Next nJ
		 
		aATD[nI][3] := aATD[nI][1]
		aATD[nI][1] := AllTrim( Posicione( "AA1", 1, xFilial("AA1") +AvKey(	aATD[nI][1],"AA1_CODTEC"),"AA1_NOMTEC" ) )
		aATD[nI][2] := nCont
		
		nCont := 0
	Next nI
	      
	aInfo := Aclone(aATD)
	cDescri := "Encerradas com atraso"
	
// abertas em atraso
ElseIf nOpcao == 6
	For nI := 1 To Len(_aOSAtraso)
		If Ascan( aATD, { |x| x[1] == _aOSAtraso[nI][1] } ) == 0
			AADD( aATD, { _aOSAtraso[nI][1], 0, "" } )
		EndIf
	Next nI
	
	For nI := 1 To Len(aATD)
		For nJ := 1 To Len(_aOSAtraso)
			If aATD[nI][1] == _aOSAtraso[nJ][1]
				nCont++
			EndIf
		Next nJ     
		
		aATD[nI][3] := aATD[nI][1]
		aATD[nI][1] := AllTrim( Posicione( "AA1", 1, xFilial("AA1") +AvKey(	aATD[nI][1],"AA1_CODTEC"),"AA1_NOMTEC" ) )
		aATD[nI][2] := nCont
		
		nCont := 0
	Next nI
	      
	aInfo := Aclone(aATD)
	cDescri := "Em atraso"
	
// abertas no prazo	
ElseIf nOpcao == 7
	For nI := 1 To Len(_aOSPrazo)
		If Ascan( aATD, { |x| x[1] == _aOSPrazo[nI][1] } ) == 0
			AADD( aATD, { _aOSPrazo[nI][1], 0, "" } )
		EndIf
	Next nI
	
	For nI := 1 To Len(aATD)
		For nJ := 1 To Len(_aOSPrazo)
			If aATD[nI][1] == _aOSPrazo[nJ][1]
				nCont++
			EndIf
		Next nJ
		                    
		aATD[nI][3] := aATD[nI][1]
		aATD[nI][1] := AllTrim( Posicione( "AA1", 1, xFilial("AA1") +AvKey(	aATD[nI][1],"AA1_CODTEC"),"AA1_NOMTEC" ) )
		aATD[nI][2] := nCont
		
		nCont := 0
	Next nI
	      
	aInfo := Aclone(aATD)
	cDescri := "No prazo"
EndIf

ASort( aInfo, , , { |x,y| x[2] > y[2] } )

oDlg := MSDialog():New(0,0,500,500,cDescri,,,,,,,,,.T.,,,,.T.)
	oLayer1:init(oDlg,.T.)
	oLayer1:addLine("LN_ENCH",90,.F.)
	oLayer1:addCollumn("COL_ENCH",100,.F.,"LN_ENCH")
	oLayer1:addWindow("COL_ENCH","WIN_ENCH","",100,.T.,.F.,{||},"LN_ENCH")
	oPnl1 := oLayer1:GetWinPanel("COL_ENCH","WIN_ENCH","LN_ENCH")
	oPnl1:FreeChildren()
		
	oBrowse := FWBrowse():New()
	oBrowse:SetDataArray()
	oBrowse:setArray(aInfo)
	oBrowse:SetDescription(cDescri)
	oBrowse:SetOwner(oPnl1)	             
	
	ADD COLUMN oColumn DATA { || aInfo[oBrowse:nAt][1] } TITLE "Atendente"	SIZE  40 /*HEADERCLICK { || msginfo("clicou coluna codigo") }*/ OF oBrowse	
	ADD COLUMN oColumn DATA { || aInfo[oBrowse:nAt][2] } TITLE "Total"		SIZE  10 /*HEADERCLICK { || msginfo("clicou coluna descricao") }*/ OF oBrowse
		
	oBrowse:SetLineHeight(30)
	oBrowse:SetFontBrowse(oFont3)
	oBrowse:DisableConfig()
	oBrowse:DisableReport()
	oBrowse:SetDoubleClick({ || IIf( !Empty(oTree),oTree:TreeSeek(aInfo[oBrowse:nAt][3]),/**/) })	// posiciona na matricula
	oBrowse:Activate()
	
	oPanel := tPanel():New(0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,020)
	oPanel:Align := CONTROL_ALIGN_BOTTOM
	
	//oBrowse:SetHeaderImage( 1,"angry1.png" )
	//oBrowse:SetHeaderImage( 2,"BR_PINK" )
	oBtn := TBtnBmp2():New( 0, 0, 40, 40, 'GRAF3D' , , , ,{|| graph(aInfo) } , oPanel, "Grแfico" , ,)
	oBtn:Align := CONTROL_ALIGN_RIGHT
    	
oDlg:Activate(,,,.T.,{|| },,{ || } )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGraph บAutor  ณJackson E. de Deus      บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra os dados de indicadores em forma de grafico.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Graph(aInfo)

Local oChart
Local oDlg
Local nI
Local oLayer1 := FWLayer():New()

oDlg := MSDialog():New(0,0,500,500,"",,,,,,,,,.T.,,,,.T.)
	oLayer1:init(oDlg,.T.)
	oLayer1:addLine("LN_ENCH",90,.F.)
	oLayer1:addCollumn("COL_ENCH",100,.F.,"LN_ENCH")
	oLayer1:addWindow("COL_ENCH","WIN_ENCH","",100,.T.,.F.,{||},"LN_ENCH")
	oPnl1 := oLayer1:GetWinPanel("COL_ENCH","WIN_ENCH","LN_ENCH")
	oPnl1:FreeChildren()
	
	oChart := FWChartPie():New()
	oChart:init( oDlg, .t. )
	For nI := 1 To Len(aInfo)
		oChart:addSerie( aInfo[nI][1], aInfo[nI][2] )	
		If nI >= 10                                     
			If nI = 10
				Exit
			EndIf
		EndIf
	Next nI

	oChart:setLegend( CONTROL_ALIGN_LEFT ) 
	oChart:Build()   	
oDlg:Activate(,,,.T.,{|| },,{ || } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDicGrid บAutor  ณJackson E. de Deus    บ Data ณ  26/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta aHeader do grid de atualizacao de OS                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DicGrid()
      
Aadd(aHeader, {" ","T_LEG", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})// imagem 

AADD(aHeader,{"OS Mobile","ZG_NUMOS","@!",TamSx3("ZG_NUMOS")[1],0,"","","C","","R" } )// numero OS

AADD(aHeader,{"Descri็ใo","T_DESC","@!",254,0,"","","C","","R" } )// descricao


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuLog บAutor  ณJackson E. de Deus     บ Data ณ  02/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do Log da tela                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuLog(cNumOs,cImgOS,cTexto)

Local nLin := 0
Local aArea := GetArea()
Local adados := {}

AAdd(aCols, Array(Len(aHeader)+1))
nLin := Len(aCols)

aCols[nLin][1] := cImgOS 
aCols[nLin][2] := cNumOs
aCols[nLin][3] := cTexto

aCols[nLin][Len(aHeader)+1] := .F.	
                  

aDados := Aclone(aCols)
oMsGd:SetArray(aDados)

oMsGD:Refresh()
oMsGD:GoBottom()

RestArea(aArea)    

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRefsh     บAutor  ณJackson E. de Deus  บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo da arvore		                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Refsh()                

Local cNumOs := ""  
Local aAux := {}
Local cStatusAtu := ""							// status antigo
Local cAgenteAtu := ""							// rota antiga 
Local cStatus := ""
Local cStatusOS :=  ""
Local cHoraIni := ""
Local nSuperAtraso := 0
Local nTecAtraso := 0
Local nOSAtraso := 0
Local lTreeOk := !oTree:isEmpty()
Local cPosOrig := IIF(lTreeOk,oTree:GetCargo(),"")
Local cAuxNumOS	:=	''		          
Local lDifer := .F.
Local nPos1 := 0
Local nPos2 := 0
Local nPos3 := 0
Local nPos4 := 0
Local cGrntAtu := ""
Local cNomGrnAtu := ""
Local cSpvAtu := ""
Local cNomeSpvatu := ""

aAux := Dados()

// compara os arrays
//lDifer := ArrayCompare( aAux , aOS ) 
//If !lDifer
//	Return
//EndIf

For nI := 1 To Len( aAux )	// gerentes
	cGerente := aAux[nI][1]
	cNomGerente := PADR( aAux[nI][2], 30, " " ) 
    
	nSuperAtraso := 0
	For nJ := 3 To Len( aAux[nI] )	// supervisores
		cSupervisor := aAux[nI][nJ][1]
		cNomeSuper := PADR( aAux[nI][nJ][2], 30, " " )                               
        
		nTecAtraso := 0
 		For nK := 3 To Len( aAux[nI][nJ] )	// tecnicos		
 			cTecnico := aAux[nI][nJ][nK][1]
 			cNomeTecnico := PADR( aAux[nI][nJ][nK][2], 30, " " )  
	 		
	 		For nL := 3 To Len( aAux[nI][nJ][nK] )	// OS
		 		nPos1 := 0
		 		nPos2 := 0
		 		nPos3 := 0
		 		nPos4 := 0
		 		cGrntAtu := ""
				cNomGrnAtu := ""
				cSpvAtu := ""
				cNomeSpvatu := ""
		 		nOSAtraso := 0
	 			cStatusAtu := ""							// status antigo
    			cAgenteAtu := ""							// rota antiga 
	 			cNumOS := aAux[nI][nJ][nK][nL][3]
	 			cStatus := aAux[nI][nJ][nK][nL][4]
	 			cStatusOS := PADR( aAux[nI][nJ][nK][nL][5], 35, " " )
	 			dDataIni := aAux[nI][nJ][nK][nL][13]
	 			cHoraIni := aAux[nI][nJ][nK][nL][6]
	 			cHoraFim := aAux[nI][nJ][nK][nL][12]
	 			cOSObs := aAux[nI][nJ][nK][nL][14]
	 				 			
 				/*If "SOLICITACAO DE ATENDIMENTO" $ cOSObs
	 				cAuxNumOS := "/A"
	 			EndIf*/
				 			
				cAuxDesc := cHoraIni
				// tratamento descricao - OS cancelada - Aberta
				If cStatus $ "CTEC|COPE|CCLI" 
					cAuxDesc += "/" +"Cancelada"
				Else                        
					If !Empty(cHoraFim)
						cAuxDesc += "/" +cHoraFim
					EndIf
				EndIf
				              
				// procura a OS no array original 'aOS' - verifica se OS ja existia
	    		lEncontrou := ChkOS( cNumOS,@cStatusAtu,@cAgenteAtu,@cGrntAtu,@cNomGrnAtu,@cSpvAtu,@cNomeSpvatu,@nPos1,@nPos2,@nPos3,@nPos4 )
				If lEncontrou
					cImgOS := Status(cStatus)	// cor do status
					If cStatus $ "OPEN|DESP|ACTE|TACM|INIC"         
						lAtraso := .F.
						lAtraso := ChkAtraso( cNumOS,dDataIni,cHoraIni,cStatus,@cImgOS )	// verifica atraso da OS
	 					If lAtraso
		 					aOS[nPos1][nPos2][nPos3][nPos4][15] := .T.
	 					EndIf 
					ElseIf cStatus $ "FIOK|INCO"
						If aOS[nPos1][nPos2][nPos3][nPos4][17] > aOS[nPos1][nPos2][nPos3][nPos4][13]	// hora fim > hora agendada
							aOS[nPos1][nPos2][nPos3][nPos4][15] := .T.
						ElseIf aOS[nPos1][nPos2][nPos3][nPos4][17] == aOS[nPos1][nPos2][nPos3][nPos4][13] .Or. Empty(aOS[nPos1][nPos2][nPos3][nPos4][17])
							If aOS[nPos1][nPos2][nPos3][nPos4][12] > aOS[nPos1][nPos2][nPos3][nPos4][6]
								aOS[nPos1][nPos2][nPos3][nPos4][15] := .T.
							EndIf
						EndIf					
					EndIf
					
					// verifica mudanca de tecnico
					If cAgenteAtu <> cTecnico
						AjusArr(2,cGrntAtu,cSpvAtu,cAgenteAtu,,cNumOS)					// retira do tecnico anterior
						AjusArr(1,cGerente,cSupervisor,cTecnico,aAux[nI][nJ][nK][nL])	// coloca no tecnico novo
						If lTreeOk
							Exclui(cNumOS,cGrntAtu,cSpvAtu,cAgenteAtu)
						EndIf	
						Inclui(cNumOS,cAuxDesc,cImgOS,cGerente,cNomGerente,cSupervisor,cNomeSuper,cTecnico,cNomeTecnico,.T.,cAuxNumOS) 	
					// verifica mudanca de status
					ElseIf cStatus <> cStatusAtu
						If lTreeOk
							Altera(cNumOS,cAuxDesc,cImgOS,cGerente,cSupervisor,cTecnico)
						EndIf
					EndIf
				Else 
					Inclui(cNumOS,cAuxDesc,cImgOS,cGerente,cNomGerente,cSupervisor,cNomeSuper,cTecnico,cNomeTecnico,.F.)
					AjusArr(1,cGerente,cSupervisor,cTecnico,aAux[nI][nJ][nK][nL])
				EndIf
	 		Next nL
   		Next nK
	Next nJ
Next nI
                                  	                
oTree:setFocus()
If lTreeOk
	oTree:TreeSeek( cPosOrig )
EndIf

// recalcula totais de OS
TotalOS()
		                 
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusArr บAutor  ณJackson E. de Deus    บ Data ณ  18/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta o array original 'aOS'                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjusArr(nOpc,cGerente,cSupervisor,cTecnico,aArr,cNumOS)

Local nI,nJ,nK,nL

// inclui a OS na estrutura passada via parametros
For nI := 1 To Len( aOS )
	If aOS[nI][1] == cGerente
		For nJ := 3 To Len( aOS[nI] )
			If aOS[nI][nJ][1] == cSupervisor 
				For nK := 3 To Len( aOS[nI][nJ] )
					If nOpc == 1
						If AllTrim(aOS[nI][nJ][nK][1]) == cTecnico
							AADD( aOS[nI][nJ][nK], aArr )
							Exit
						EndIf
					EndIf            
					
					If nOpc == 2
						For nL := 3 To Len( aOS[nI][nJ][nK] )
							If aOS[nI][nJ][nK][nL][3] == cNumOS
								ADel( aOS[nI][nJ][nK], nL)
								Asize( aOS[nI][nJ][nK], Len(aOS[nI][nJ][nK])-1 )
								Exit
							EndIf
						Next nL
					EndIf
				Next nK
			EndIf			
		Next nJ
	EndIf	
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInclui บAutor  ณJackson E. de Deus     บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo da arvore - Inclui uma nova OS                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Inclui(cNumOS,cAuxDesc,cImgOS,cGerente,cNomGerente,cSupervisor,cNomeSuper,cTecnico,cNomeTecnico,lTransf,cAuxNumOS) 

oTree:BeginUpdate()
// monta a arvore do gerente
If !oTree:TreeSeek( cGerente )
	oTree:AddTreeItem(cNomGerente,cImgGestor,,cGerente)
EndIf

If oTree:TreeSeek( cGerente )
	// monta a arvore do supervisor
	If !oTree:TreeSeek( cSupervisor )
		oTree:AddItem( cNomeSuper ,cSupervisor, cImgSuper,,,,2)				
	EndIf
	
	If oTree:TreeSeek( cSupervisor )
		// monta a arvore do Tecnico
 		If !oTree:TreeSeek( cTecnico )
 			oTree:AddItem( cNomeTecnico, cTecnico, cImgTec,,,,3)
 		EndIf
 		
 		If oTree:TreeSeek( cTecnico )
 			// adiciona as OS
 			If !oTree:TreeSeek( cNumOS )
 				If Empty(cAuxNumOS)
 					oTree:AddItem( cNumOS + " - " +cAuxDesc, cNumOS, cImgOS,,,,4) 
 				Else
 					oTree:AddItem( cNumOS +cAuxNumOS + " - " +cAuxDesc, cNumOS, cImgOS,,,,4)
 				EndIf
 				
	 			If !lTransf
	 				AtuLog( cNumOS,cImgOS,"Inclusใo de OS" )
	 			Else
	 				AtuLog( cNumOS,cImgOS,"Transfer๊ncia OS" )
	 			EndIf	
	 		EndIf
	 		oTree:PTCOLLAPSE()
 		EndIf
 		oTree:PTCOLLAPSE()
	EndIf
	oTree:PTCOLLAPSE()
EndIf      
oTree:EndUpdate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltera บAutor  ณJackson E. de Deus     บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo da arvore - Altera uma OS                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function	Altera(cNumOS,cAuxDesc,cImgOS,cGerente,cSupervisor,cTecnico)

oTree:BeginUpdate()
If oTree:TreeSeek( cGerente )
	If oTree:TreeSeek( cSupervisor )
 		If oTree:TreeSeek( cTecnico )
 			If oTree:TreeSeek( cNumOS )
	 			oTree:ChangeBmp( cImgOS, cImgOS,,,cNumOS )
				oTree:ChangePrompt( cNumOS +" - " +cAuxDesc  ,cNumOS )	
				AtuLog(cNumOS,cImgOS,"Altera็ใo de Status - OS")
	 		EndIf
	 		oTree:PTCOLLAPSE()
 		EndIf
 		oTree:PTCOLLAPSE()
	EndIf
	oTree:PTCOLLAPSE()
EndIf  
oTree:EndUpdate()
      
Return	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExclui บAutor  ณJackson E. de Deus     บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo da arvore - Exclui uma OS                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Exclui(cNumOS,cGerente,cSupervisor,cTecnico)

oTree:BeginUpdate()
If oTree:TreeSeek( cGerente )
	If oTree:TreeSeek( cSupervisor )
 		If oTree:TreeSeek( cTecnico )
 			If oTree:TreeSeek( cNumOS )
	 			oTree:delItem()	// exclui a OS 
	 		EndIf
	 		oTree:PTCOLLAPSE()
 		EndIf
 		oTree:PTCOLLAPSE()
	EndIf
	oTree:PTCOLLAPSE()
EndIf      
oTree:EndUpdate()	 
	                           
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkAtrasoบAutor  ณJackson E. de Deus   บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica atraso na OS e muda a cor do status da OS          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkAtraso(cNumOS,dDataIni,cHoraIni,cStatus,cImgOS)

Local lAtrasou := .F.

/*
// Nao finalizadas porem nao excedeu o horario
If cStatus $ "DESP|ACTE|TACM|INIC"
	If Date() < dDataIni	// .And. Time() <= cHoraIni )
		cImgOS := Status(cStatus)
	EndIf
// Nao finalizadas porem excedeu o horario		
ElseIf cStatus $ "DESP|ACTE|TACM|INIC" .And. ( Date() > dDataIni .Or. ( Date() == dDataIni .And. Time() > cHoraIni ) )
	cImgOS := cImgOSAtso
	nOSAtraso++
// Canceladas ou Finalizadas 	
ElseIf cStatus $ "CTEC|COPE|CCLI|FIOK|INCO"
	cImgOS := Status(cStatus)	
EndIf
*/

If cStatus $ "OPEN|DESP|ACTE|TACM|INIC"
	If Date() > dDataIni .Or. ( Date() == dDataIni .And. Time() > cHoraIni ) 
		cImgOS := cImgOSAtso
		lAtrasou := .T.
	EndIf
EndIf

Return lAtrasou


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltStatusบAutor  ณJackson E. de Deus   บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica atraso na OS e muda a cor do status do Tecnico/    บฑฑ
ฑฑบ          ณSupervisor/Gestor                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltStatus(nNivel,cCodigo,nQtd)	

Local cImgGestor := "BMPUSER"
Local cImgSuper := "BMPUSER"
Local cImgTec := "BMPUSER"
                                             
Default nQtd := 0

// gerente
If nNivel == 1
	//If cStatSuper == "VERMELHO"
	//	cImgGestor := "BR_VERMELHO"
	//ElseIf cStatSuper == "AMARELO"
	//	cImgGestor := "BR_AMARELO"
	//EndIf
	cImgGestor := "BR_AMARELO"		
	If oTree:TreeSeek( cCodigo )
		oTree:ChangeBmp( cImgGestor, cImgGestor,,,cCodigo )
	EndIf	
// supervisor
ElseIf nNivel == 2
	// amarelo
	If nQtd == 1
		cImgSuper := "BR_AMARELO"
	// vermelho
	ElseIf nQtd >= 2
	 	cImgSuper := "BR_VERMELHO"
	EndIf
	If oTree:TreeSeek( cCodigo )
		oTree:ChangeBmp( cImgSuper, cImgSuper,,,cCodigo )
	EndIf	
// tecnico
ElseIf nNivel == 3
	cImgTec := "BR_VERMELHO"
	If oTree:TreeSeek( cCodigo )
		oTree:ChangeBmp( cImgTec, cImgTec,,,cCodigo )
	EndIf	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregar บAutor  ณJackson E. de Deus   บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a montagem da primeira arvore na abertura do programa   บฑฑ
ฑฑบ          ณ                                             				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Carregar()
             
Local cNumOs := ""
Local aAux := {}
Local cPosIni := "" 
Local lCriou := .F. 
Local cHoraIni := ""
Local cOSObs := ""
Local cAuxNumOS := ""
Local lAtraso := .F.

CursorWait()

ProcRegua(1)
IncProc("Carregando dados..")             
aAux := Dados()
                  
oTree:BeginUpdate()

ProcRegua( Len(aAux) )
For nI := 1 To Len( aAux )	// gerentes
	If nI == 1
		cPosIni := aAux[nI][1] 
	EndIf
	cGerente := aAux[nI][1]
	cNomGerente := PADR( aAux[nI][2], 30, " " ) 
	IncProc("Gestor: " +cNomGerente)
	
	// monta a arvore do gerente
	If !oTree:TreeSeek( cGerente )
		oTree:AddTreeItem(cNomGerente,cImgGestor,,cGerente)
		//oTree:AddTree(cNomGerente,.T., cImgGestor,cImgGestor ,,, cGerente ) 
	EndIf
		                                                                     
	If oTree:TreeSeek( cGerente )
		ProcRegua( Len(aAux[nI]) )
		
		nSuperAtraso := 0
		For nJ := 3 To Len( aAux[nI] )	// supervisores
			cSupervisor := aAux[nI][nJ][1]
			cNomeSuper := PADR( aAux[nI][nJ][2], 30, " " )
		 	IncProc("Supervisor: " +cNomeSuper)                                 
		
			// monta a arvore do supervisor
			If !oTree:TreeSeek( cSupervisor )
				oTree:AddItem( cNomeSuper ,cSupervisor, cImgSuper,,,,2)				
			EndIf
				                                                       
			If oTree:TreeSeek( cSupervisor )
				ProcRegua( Len(aAux[nI][nJ]) )

				nTecAtraso := 0
		 		For nK := 3 To Len( aAux[nI][nJ] )	// tecnicos		
		 			cTecnico := aAux[nI][nJ][nK][1]
		 			cNomeTecnico := PADR( aAux[nI][nJ][nK][2], 30, " " )
		 			IncProc("T้cnico: " +cNomeTecnico)     
		 			 	
		 			// monta a arvore do Tecnico
		 			If !oTree:TreeSeek( cTecnico )
		 				oTree:AddItem( cNomeTecnico, cTecnico, cImgTec,,,,3)
			 		EndIf
			 		
			 		If oTree:TreeSeek( cTecnico )
			 			ProcRegua( Len(aAux[nI][nJ][nK]) )
			 			
				 		For nL := 3 To Len( aAux[nI][nJ][nK] )	// OS
					 		nOSAtraso := 0
				 	   		cAuxNumOS := "" 
				 			cNumOS := aAux[nI][nJ][nK][nL][3]
				 			cStatus := aAux[nI][nJ][nK][nL][4]
				 			cStatusOS :=  PADR( aAux[nI][nJ][nK][nL][5], 35, " " )
 				 			dDataIni := aAux[nI][nJ][nK][nL][13]
				 			cHoraIni := aAux[nI][nJ][nK][nL][6]
				 			cHoraFim := aAux[nI][nJ][nK][nL][12]
				 			cOSObs := aAux[nI][nJ][nK][nL][14]
				 			
				 			/*If "SOLICITACAO DE ATENDIMENTO" $ cOSObs
				 				cAuxNumOS := "/A"
				 			EndIf*/
				 			
				 			cAuxDesc := cHoraIni
				 			// tratamento descricao - OS cancelada - Aberta
							If cStatus $ "CTEC|COPE|CCLI" 
								cAuxDesc += "/" +"Cancelada"
							Else                        
								If !Empty(cHoraFim)
									cAuxDesc += "/" +cHoraFim
								EndIf
							EndIf
				   
				 			IncProc("Ordem de Servi็o: " +cNumOS)

			 				cImgOS := Status(cStatus)	// cor do status   
				 			If cStatus $ "OPEN|DESP|ACTE|TACM|INIC"
				 				lAtraso := .F.
			 					lAtraso := ChkAtraso(cNumOS,dDataIni,cHoraIni,cStatus,@cImgOS)	// verifica atraso da OS
			 					If lAtraso
				 					aAux[nI][nJ][nK][nL][15] := .T.
			 					EndIf 
			 				ElseIf cStatus $ "FIOK|INCO"
								If aAux[nI][nJ][nK][nL][17] > aAux[nI][nJ][nK][nL][13]	// data > data agendada
									aAux[nI][nJ][nK][nL][15] := .T.								 	
								ElseIf aAux[nI][nJ][nK][nL][17] == aAux[nI][nJ][nK][nL][13] .Or. Empty(aAux[nI][nJ][nK][nL][17])	// data igual
									If aAux[nI][nJ][nK][nL][12] > aAux[nI][nJ][nK][nL][6]	// hora fim > hora agendada
										aAux[nI][nJ][nK][nL][15] := .T.
									EndIf
								EndIf			
			 				EndIf	 
				 			// adiciona as OS
				 			If !oTree:TreeSeek( cNumOS )
				 				If Empty(cAuxNumOS)
				 					oTree:AddItem( cNumOS + " - " +cAuxDesc, cNumOS, cImgOS,,,,4) 
				 				Else
				 					oTree:AddItem( cNumOS +cAuxNumOS +" - " +cAuxDesc, cNumOS, cImgOS,,,,4) 
				 				EndIf
					 		EndIf
					 		oTree:TreeSeek( cTecnico )
				 		Next nL
			 		EndIf
			 		oTree:PTCOLLAPSE()
			 		oTree:TreeSeek( cSupervisor )
		   		Next nK
	   		EndIf
	   		oTree:PTCOLLAPSE()
	   		oTree:TreeSeek( cGerente )
		Next nJ
	EndIf
	oTree:PTCOLLAPSE()
	oTree:TreeSeek( cGerente )
Next nI

If !oTree:IsEmpty()                                    	
	oTree:EndUpdate()	                  
	oTree:EndTree()
	oTree:PTCOLLAPSE()                    
	oTree:TreeSeek( cPosIni ) // Retorna ao primeiro nํvel 
	oTree:PTCOLLAPSE()
	Visual()   
EndIf

aOS := aClone(aAux) // salva em aOS

TotalOS()

CursorArrow()

Return                                

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStatus บAutor  ณJackson E. de Deus    บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a cor do status de acordo com o status		     บฑฑ
ฑฑบ          ณ                                             				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Status(cStatus)

Local cRet := ""

If cStatus $ "DESP#OPEN" 
	cRet := "BR_BRANCO"
ElseIf cStatus $ "ACTE"
	cRet := "BR_AMARELO"
ElseIf cStatus == "AGEN"
	cRet := "BR_LARANJA"
ElseIf cStatus == "TACM"
	cRet := "BR_AZUL"
ElseIf cStatus == "INIC"
	cRet := "BR_PINK"
ElseIf cStatus == "CTEC"
	cRet := "BR_CINZA"	
ElseIf cStatus == "COPE"
	cRet := "BR_MARROM"
ElseIf cStatus == "CCLI"
	cRet := "BR_PRETO"
ElseIf cStatus == "INCO"
	cRet := "BR_VERMELHO"	
ElseIf cStatus == "FIOK"
	cRet := "BR_VERDE"					
EndIf 

Return cRet

 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda บAutor  ณJackson E. de Deus    บ Data ณ  06/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda da tela                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function Legenda()

BrwLegenda(cCadastro,"Status",{{"BR_BRANCO","Despachada"},;
                               {"BR_AMARELO","Recebido pelo Agente"},;
                               {"BR_CINZA","Cancelado pelo Agente"},;
                               {"BR_MARROM","Cancelado pelo Atendente"},;
                               {"BR_PRETO","Cancelado pelo Cliente"},;
                               {"BR_VERDE","Finalizado"},;
                               {"BR_VERMELHO","Atrasada" } })      
                                                              
Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDados  บAutor  ณJackson E. de Deus    บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os dados das OS						 		     บฑฑ
ฑฑบ          ณ                                             				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Dados()
              
Local aAux := {}  
Local nI,nJ,nK 
Local cGerente := ""
Local cNomGrte := ""
Local cNomSpvsr := ""
Local cSupvsor := "" 
Local aGeren := {}
Local aSuper := {}
Local aTec := {}        
Local cLocF	:=	''

cQuery := "SELECT ZG_NUMOS, ZG_TPFORM, ZG_AGENTE, ZG_AGENTED,AA1_NOMTEC, ZG_DATAINI, ZG_HORAINI, ZG_DATAFIM,ZG_HORAFIM, ZG_STATUS,ZG_STATUSD,ZG_OBS, AA1_XGEREN, AA1_XSUPER, AA1_CODTEC, ZG_PATRIM FROM " +RetSqlName("SZG") +" SZG "
cQuery += "INNER JOIN " +RetSqlName("AA1") +" AA1 ON "
cQuery += "AA1_CODTEC = ZG_CODTEC  "
cQuery += "AND AA1.D_E_L_E_T_ = '' "
cQuery += "WHERE "
cQuery += " SZG.D_E_L_E_T_ = '' "
cQuery += "	AND ( ZG_DATAINI = '"+dtos(dDatabase)+"' AND AA1_XGEREN <> '' AND AA1_XSUPER <> '' ) "	// TODAS AGENDADAS NA DATA
cQuery += 			" OR ( ZG_TPFORM IN ('5','6','7','16','17') AND ZG_DATAINI <> '"+dtos(dDatabase)+"' AND ( ZG_STATUS = 'DESP' OR ZG_STATUS = 'ACTE' OR ZG_STATUS = 'TACM' OR ZG_STATUS = 'INIC' ) AND AA1_XGEREN <> '' AND AA1_XSUPER <> ''  ) "	// OS MANUTENCAO DE DIAS ANTERIORES POREM NAO FINALIZADAS

cQuery += "ORDER BY AA1_XGEREN, AA1_XSUPER, AA1_CODTEC, ZG_DATAINI, ZG_HORAINI "

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf
TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB") 

While !EOF()
	cGerente := AllTrim(TRB->AA1_XGEREN)
	cSupvsor := AllTrim(TRB->AA1_XSUPER)
	cNomGrte := AllTrim( Posicione("AA1",1,xFilial("AA1") +AvKey(cGerente,"AA1_NOMTEC"),"AA1_NOMTEC" ) )
	cNomSpvsr := AllTrim( Posicione("AA1",1,xFilial("AA1") +AvKey(cSupvsor,"AA1_NOMTEC"),"AA1_NOMTEC" ) )
	
	cLocF := Posicione("SN1",2,xFilial("SN1")+TRB->ZG_PATRIM,"N1_XLOCINS")
	
	If Empty(cGerente)
		cGerente := "G000000"	
	Else
		cGerente := "G" +cGerente
	EndIf                   
	
	If Empty(cSupvsor)
		cSupvsor := "S000000"
	Else
		cSupvsor := "S" +cSupvsor
	EndIf                                                                                         
	
	If Empty(cNomGrte)          
		cNomGrte := "------"
	EndIf
	
	If Empty(cNomSpvsr)
		cNomSpvsr := "------"	
	EndIf			
	
	AADD( aAux, {	AllTrim( cvaltochar(TRB->ZG_AGENTE )),;	//[1] codigo pager
					AllTrim( TRB->AA1_NOMTEC ),;			//[2] nome tecnico
					AllTrim( CValTochar(Val(TRB->ZG_NUMOS)) ),;				//[3] numero OS
					AllTrim( TRB->ZG_STATUS ),;				//[4] status
					AllTrim( TRB->ZG_STATUSD ),;			//[5] descricao status
					AllTrim( TRB->ZG_HORAINI ),;			//[6] hora inicio
					cGerente,;								//[7] gerente
					cSupvsor,;								//[8] supervisor
					AllTrim( TRB->AA1_CODTEC ),;			//[9] codigo tecnico
					cNomGrte,;								//[10] nome do gerente
					cNomSpvsr,;								//[11] nome do supervisor
					AllTrim( TRB->ZG_HORAFIM ),;			//[12] hora fim
					stod(TRB->ZG_DATAINI),;					//[13] data ini - agendamento
					ALLTRIM(TRB->ZG_OBS),;					//[14] Obs
					.F.,;									//[15] Atrasada?
					CVALTOCHAR(TRB->ZG_TPFORM),;			//[16] Tipo Formulario
					stod(TRB->ZG_DATAFIM) ,;				//[17] data finalizacao 
					cLocF					})				//[18] Local fisico
					
	dbSkip()
End           

For nI := 1 To Len(aAux)
	// separa os gerentes
	If aScan( aGeren, { |x| x[1] == aAux[nI][7] } ) == 0
		AADD( aGeren, { aAux[nI][7],;		// codigo gerente
						aAux[nI][10]  } )	// nome gerente
	EndIf
	
	// separa os supervisores
	If aScan( aSuper, { |x| x[1] == aAux[nI][7] .And. x[2] == aAux[nI][8] } ) == 0
		AADD( aSuper, { aAux[nI][7],;		// codigo gerente
						aAux[nI][8],;		// codigo supervisor
						aAux[nI][11]  } )	// nome supervisor
	EndIf
	
	// separa os tecnicos
	If aScan( aTec, { |x| x[1] == aAux[nI][7] .And. x[2] == aAux[nI][8] .And. x[3] == aAux[nI][9]  } ) == 0
		AADD( aTec, { aAux[nI][7],;			// codigo gerente
						aAux[nI][8],;		// codigo supervisor
						aAux[nI][9],;		// codigo tecnico
						aAux[nI][2] })		// nome tecnico
	EndIf	
Next nI                                

aSort( aGeren,,,{ |x,y| val(x[1]) < val(y[1]) } )
aSort( aSuper,,,{ |x,y| val(x[1]) < val(y[1]) .And. val(x[2]) < val(y[2]) } )
aSort( aTec,,,{ |x,y| val(x[1]) < val(y[1]) .And. val(x[2]) < val(y[2]) .And. val(x[3]) < val(y[3]) } )

// inclui Supervisores em Gerentes
For nI := 1 To Len(aGeren)	
	For nJ := 1 To Len(aSuper)         
		If aSuper[nJ][1] == aGeren[nI][1]			// supervisor subordinado ao gerente
			AADD( aGeren[nI], { aSuper[nJ][2],; 	// supervisor
								 aSuper[nJ][3]  } )	// nome supervisor
		EndIf	
	Next nJ
Next nI

// inclui Tecnicos em Supervisores/Gerentes
For nI := 1 To Len(aGeren)	
	For nJ := 3 To Len(aGeren[nI])
		For nK := 1 To Len(aTec)         
			If aTec[nK][1] == aGeren[nI][1] .And. aTec[nK][2] == aGeren[nI][nJ][1]
				AADD( aGeren[nI][nJ], { aTec[nK][3],;			// tecnico
										 aTec[nK][4]  } )		// nome tecnico
			EndIf	                
		Next nK
	Next nJ
Next nI

// inclui as OS no Array final                                           
For nI := 1 To Len(aGeren)	// gerente
	cGerente := aGeren[nI][1]
	For nJ := 3 To Len(aGeren[nI])	// supervisor
		cSupvsor := aGeren[nI][nJ][1]
		For nK := 3 To Len(aGeren[nI][nJ])	// tecnico
			cTecnico := aGeren[nI][nJ][nK][1]
			For nL := 1 To Len(aAux)
				If aAux[nL][7] == cGerente .And. aAux[nL][8] == cSupvsor .And. aAux[nL][9] == cTecnico	// tecnico subordinado ao supervisor/gerente ?
					AADD( aGeren[nI][nJ][nK], aAux[nL] )
				EndIf
			Next nL	
		Next nK
	Next nJ
Next nI

aRet := aClone(aGeren)

/*  
MAPA ARRAY
aRet[x]
	[x][1]	- codigo gerente
	[x][2]	- nome gerente
	[x][x]	- Array - supervisor
	[x][x][1]	- codigo supervisor
	[x][x][2]	- nome supervisor
	[x][x][x]	- Array - tecnico
	[x][x][x][1]	- codigo tecnico
	[x][x][x][2]	- nome tecnico
	[x][x][x][x]	- Array OS
	[x][x][x][x][1]		- codigo agente/pager
	[x][x][x][x][2]		- nome tecnico
	[x][x][x][x][3]		- numero OS
	[x][x][x][x][4]		- status OS
	[x][x][x][x][5]		- desc status OS
	[x][x][x][x][6]		- hora ini OS
	[x][x][x][x][7]		- cod gerente
	[x][x][x][x][8]		- cod supervisor
	[x][x][x][x][9]		- cod tecnico
	[x][x][x][x][10]	- nome gerente
	[x][x][x][x][11]	- nome supervisor
	[x][x][x][x][12]	- hora fim
	[x][x][x][x][13]	- data ini
	[x][x][x][x][14]	- Obs OS
	[x][x][x][x][15]	- atrasada?
	[x][x][x][x][16]	- tipo formulario
	[x][x][x][x][17]	- data finalizacao 
	[x][x][x][x][18]	- Local fisico da maquina 
*/
                         
TRB->( dbCloseArea() )       

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkOs   บAutor  ณJackson E. de Deus    บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณA cada refresh, verifica a existencia da OS na arvore ja    บฑฑ
ฑฑบ          ณcarregada                                             	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkOs( cNumOS,cStatusAtu,cAgenteAtu,cGrntAtu,cNomGrnAtu,cSpvAtu,cNomeSpvatu,nPos1,nPos2,nPos3,nPos4 )

Local nI,nJ,nK,nL
Local lOk := .F.

Default cNumOS := ""

If Empty( cNumOS )
	Return lOk
EndIf


For nI := 1 To Len( aOS )
	cGrntAtu := aOs[nI][1] 
	cNomGrnAtu := PADR( aOs[nI][2] , 30, " " ) 
	For nJ := 3 To Len( aOS[nI] )
		cSpvAtu := aOS[nI][nJ][1]
		cNomeSpvatu := PADR( aOs[nI][nJ][2] , 30, " " ) 
		For nK := 3 To Len( aOS[nI][nJ] )
			For nL := 3 To Len( aOS[nI][nJ][nK] )
				If aOS[nI][nJ][nK][nL][3] == cNumOS
					cStatusAtu := aOS[nI][nJ][nK][nL][4]
					cAgenteAtu := aOS[nI][nJ][nK][1]
					lOk := .T. 
					nPos1 := nI
					nPos2 := nJ
					nPos3 := nK
					nPos4 := nL
					Return lOk
				EndIf
			Next nL
		Next nK		
	Next nJ	
Next nI

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisual  บAutor  ณJackson E. de Deus    บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza os dados do Tecnico/Supervisor/Gerente ou OS      บฑฑ
ฑฑบ          ณ                                             	  			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Visual()

Local cNumOS := ""
Local cMat := ""
Local nTotOS := 0
Local nTotFim := 0
Local nTotAber := 0 
Local nTotCanc := 0
Local nTotInic := 0
Local oChart
Local oDlg
Local aAxT := {}

If !oTree:IsEmpty()
	// Gerente/Supervisor/Tecnico
	If oTree:Nivel() < 4 
		If oTree:Nivel() <= 2
			cMat := SubStr( oTree:getCargo(), 2 ) 
		Else
			cMat := oTree:getCargo()
		EndIf	
		
		dbSelectArea("AA1")
		dbSetOrder(1)
		If dbSeek( xFilial("AA1") +AvKey( cMat, "AA1_CODTEC") )
			oMsMGet2:Hide()
			oMsMGet3:Hide()
			oMsMGet1:Refresh()
			oMsMGet1:Show()	
		EndIf

		// indicadores - oFld2:aDialogs[4]
		If Type("oChart") == "O"
			oChart := Nil
		EndIf
		
		 // totais
		TotalOS(cMat,@nTotOS,@nTotFim,@nTotAber,@nTotCanc,@nTotInic)
		
		oChart := FWChartBar():New()
		oChart:init( oFld2:aDialogs[3], .t.,.T. ) 
		oChart:addSerie( "Total", nTotOS )
		oChart:addSerie( "Finalizadas", nTotFim )
		oChart:addSerie( "Iniciadas", nTotInic )
		oChart:addSerie( "Pendentes", nTotAber )
		oChart:addSerie( "Canceladas", nTotCanc )
		oChart:setLegend( CONTROL_ALIGN_LEFT )
		oChart:Build() 
	    
	    
    // Ordem de servico
	ElseIf oTree:Nivel() == 4
		aAxT := StrToKarr(oTree:getPrompt(),"-")
		cNumOs := PadL(AllTrim(aAxT[1]),TamSx3("ZG_NUMOS")[1],"0") //oTree:getCargo()
		
		dbSelectArea("SZG")
		dbSetOrder(1)
		MSSeek( xFilial("SZG") +AvKey( cNumOS, "ZG_NUMOS") )
		If !Found()
			MSSeek( xFilial("SZG") +AvKey( oTree:getCargo(), "ZG_NUMOS") )
		EndIf
	
		If Found()
			oMsMGet1:Hide()
			oMsMGet2:Refresh()
			oMsMGet2:Show()
			
			dbSelectArea("SA1")
			dbSetOrder(1)
			If MSSeek( xFilial("SA1") +AvKey(SZG->ZG_CLIFOR,"A1_COD") +AvKey(SZG->ZG_LOJA,"A1_LOJA") )
				oMsmGet3:Refresh()
				oMsmGet3:Show()
			EndIf
			
		EndIf	
	EndIf
EndIf	

oWindow:Refresh()
oTree:setFocus()	
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTotalOS   บAutor  ณJackson E. de Deus  บ Data ณ  16/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os totais de OS para uso nos graficos indicadores  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TotalOS(cMat,nTotOS,nTotFim,nTotAber,nTotCanc,nTotInic)

Local nI,nJ,nK,nL
Local nNivel := 0
Local lTotais  := .F.
Local cTpForm := ""
Default cMat := ""

If Empty(cMat)	
	lTotais := .T.
EndIf

// total geral das OS
If lTotais
	_nTotOS := 0
	_nTotInic := 0
	_nTotAber := 0
	_nTotCanc := 0
	_nTotCanc2 := 0
	_nTotFim := 0  
	_nTotFim2 := 0
	_nTotAtraso := 0
	_nTotPrazo := 0
	_aOSFim := {}
	_aOSFim2 := {}
	_aOSCanc := {}
	_aOSCanc2 := {}
	_aOSAtraso := {}
	_aOSPrazo := {}
	
	For nI := 1 To Len( aOS )
		For nJ := 3 To Len( aOS[nI] ) 
			For nK := 3 To Len( aOS[nI][nJ] )
				For nL := 3 To Len( aOS[nI][nJ][nK] )
				    cTpForm := aOS[nI][nJ][nK][nL][16]
				    If Ascan( _aFormIndic, { |x| x == cTpForm  } ) == 0
				    	Loop
				    EndIf
					
					_nTotOS++
					// finalizadas
					If aOS[nI][nJ][nK][nL][4] $ "FIOK|INCO"
						// com atraso
						If aOS[nI][nJ][nK][nL][15]
							_nTotFim2++
							AADD( _aOSFim2, { aOS[nI][nJ][nK][nL][9],aOS[nI][nJ][nK][nL][3] } )
						// no prazo
						Else 
							_nTotFim++
							AADD( _aOSFim, { aOS[nI][nJ][nK][nL][9],aOS[nI][nJ][nK][nL][3] } )
						EndIf
					// canceladas central
					ElseIf aOS[nI][nJ][nK][nL][4] $ "COPE|CCLI"
						_nTotCanc2++					
						AADD( _aOSCanc2, { aOS[nI][nJ][nK][nL][9],aOS[nI][nJ][nK][nL][3] } )
				   
					// canceladas agente		
					ElseIf aOS[nI][nJ][nK][nL][4] == "CTEC"	// cancelada pelo agente
						_nTotCanc++
						AADD( _aOSCanc, { aOS[nI][nJ][nK][nL][9],aOS[nI][nJ][nK][nL][3] } )
					
					// iniciadas	
					ElseIf aOS[nI][nJ][nK][nL][4] == "INIC"
						_nTotInic++
					Else
						_nTotAber++
					EndIf		
					
					// abertas total atraso - total prazo
					If aOS[nI][nJ][nK][nL][4] $ "DESP|AGEN|TACM|ACTE|INIC" 	// verifica atraso
						If aOS[nI][nJ][nK][nL][15]
							_nTotAtraso++
							AADD( _aOSAtraso, { aOS[nI][nJ][nK][nL][9],aOS[nI][nJ][nK][nL][3] } )
						Else 
							_nTotPrazo++
							AADD( _aOSPrazo, { aOS[nI][nJ][nK][nL][9],aOS[nI][nJ][nK][nL][3] } )
						EndIf
					EndIf
				Next nL
			Next nK		
		Next nJ
	Next nI
// codigo especifico - gerente/supervisor/atendente
Else
	nNivel := oTree:Nivel()
	// gerente
	If nNivel == 1
		For nI := 1 To Len( aOS )
			If aOS[nI][1] == "G" +AllTrim(cMat)
				For nJ := 3 To Len( aOS[nI] ) 
					For nK := 3 To Len( aOS[nI][nJ] )
						For nL := 3 To Len( aOS[nI][nJ][nK] )
							nTotOS++
							If aOS[nI][nJ][nK][nL][4] == "FIOK"
								nTotFim++
							ElseIf aOS[nI][nJ][nK][nL][4] $ "CTEC|COPE|CCLI"
								nTotCanc++
							ElseIf aOS[nI][nJ][nK][nL][4] == "INIC"
								nTotInic++
							Else
								nTotAber++
							EndIf
						Next nL
					Next nK		
				Next nJ
			EndIf	
		Next nI
	// supervisor          
	ElseIf nNivel == 2
		For nI := 1 To Len( aOS )
			For nJ := 3 To Len( aOS[nI] )
				If aOS[nI][nJ][1] == "S" +AllTrim(cMat) 
					For nK := 3 To Len( aOS[nI][nJ] )
						For nL := 3 To Len( aOS[nI][nJ][nK] )
							nTotOS++
							If aOS[nI][nJ][nK][nL][4] == "FIOK"
								nTotFim++
							ElseIf aOS[nI][nJ][nK][nL][4] $ "CTEC|COPE|CCLI"
								nTotCanc++
							ElseIf aOS[nI][nJ][nK][nL][4] == "INIC"
								nTotInic++
							Else
								nTotAber++
							EndIf
						Next nL
					Next nK
				EndIf			
			Next nJ
		Next nI
	// atendente
	ElseIf nNivel == 3
		For nI := 1 To Len( aOS )
			For nJ := 3 To Len( aOS[nI] ) 
				For nK := 3 To Len( aOS[nI][nJ] )
					If AllTrim(aOS[nI][nJ][nK][1]) == AllTrim(cMat)
						For nL := 3 To Len( aOS[nI][nJ][nK] )
							nTotOS++
							If aOS[nI][nJ][nK][nL][4] == "FIOK"
								nTotFim++
							ElseIf aOS[nI][nJ][nK][nL][4] $ "CTEC|COPE|CCLI"
								nTotCanc++
							ElseIf aOS[nI][nJ][nK][nL][4] == "INIC"
								nTotInic++
							Else
								nTotAber++
							EndIf
						Next nL
					EndIf
				Next nK		
			Next nJ
		Next nI
	EndIf
EndIf
AtuIndic()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuIndic บAutor  ณJackson E. de Deus   บ Data ณ  26/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os indicadores de performance                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuIndic()

Local nPCanc := 0
Local nPCanc2 := 0
Local nPFim := 0  
Local nPFim2 := 0  
Local nPAtraso := 0
Local nPPrazo := 0

nPCanc := Round((_nTotCanc/_nTotOS) * 100,2)	// canceladas pelo agente
nPCanc2 := Round((_nTotCanc2/_nTotOS) * 100,2)	// canceladas pela central
nPFim := Round((_nTotFim/_nTotOS) * 100,2)
nPFim2 := Round((_nTotFim2/_nTotOS) * 100,2)
nPAtraso := Round((_nTotAtraso/_nTotOS) * 100,2)
nPPrazo := Round((_nTotPrazo/_nTotOS) * 100,2)

cQtd1 := cvaltochar(_nTotOS)
cQtd2 := cvaltochar(_nTotFim)
cQtd3 := cvaltochar(_nTotFim2) 
cQtd4 := cvaltochar(_nTotPrazo)
cQtd5 := cvaltochar(_nTotAtraso)
cQtd6 := cvaltochar(_nTotCanc)
cQtd7 := cvaltochar(_nTotCanc2)

cQtdP1 := "100%"
cQtdP2 := cvaltochar( nPFim ) +"%"
cQtdP3 := cvaltochar( nPFim2 ) +"%"
cQtdP4 := cvaltochar( nPPrazo ) +"%"
cQtdP5 := cvaltochar( nPAtraso ) +"%"
cQtdP6 := cvaltochar( nPCanc ) +"%"
cQtdP7 := cvaltochar( nPCanc2 ) +"%"

oSLgQ1:SetText(cQtd1)
oSLgQ1:Refresh()     
//oSQP1:Refresh()

oSLgQ2:SetText(cQtd2)
oSLgQ2:Refresh()
oSQP2:SetText(cQtdP2)
oSQP2:Refresh()
                     
oSLgQ3:SetText(cQtd3)
oSLgQ3:Refresh()
oSQP3:SetText(cQtdP3)
oSQP3:Refresh()
                     
oSLgQ4:SetText(cQtd4)
oSLgQ4:Refresh()
oSQP4:SetText(cQtdP4)
oSQP4:Refresh()
                     
oSLgQ5:SetText(cQtd5)
oSLgQ5:Refresh()
oSQP5:SetText(cQtdP5)
oSQP5:Refresh()

oSLgQ6:SetText(cQtd6)
oSLgQ6:Refresh()
oSQP6:SetText(cQtdP6)
oSQP6:Refresh()

oSLgQ7:SetText(cQtd7)
oSLgQ7:Refresh()
oSQP7:SetText(cQtdP7)
oSQP7:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancelar บAutor  ณAlexandre Venancio   บ Data ณ  03/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Excluir Os pela rotina de monitoramento.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cancelar()

Local cNumOs := ""
Local nCnt := 0
Local lRet := .F.
Local oXml
Local cError := ""
Local cWarning := ""
Local cStatusOS := ""
Local aArea := GetArea()

If !oTree:IsEmpty()
	If oTree:Nivel() == 4
		cNumOS := oTree:getCargo()
		DbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
			If AllTrim(SZG->ZG_STATUS) $ "FIOK|INCO"
				MsgInfo("A Ordem de Servi็o nใo pode ser cancelada pois jแ foi finalizada.")
				RestArea(aArea)
				Return
			EndIf
			
			If AllTrim(SZG->ZG_STATUS) $ "CTEC|COPE|CCLI"
				MsgInfo("A Ordem de Servi็o jแ estแ cancelada.")
				RestArea(aArea)
				Return
			EndIf
		Else
			RestArea(aArea)
			Return
		EndIf
	    /*
		// Verifica o status atualizado da OS direto do WS
		cResult := StaticCall(TTPROC30,RetornoOS,SZG->ZG_NUMOS)
		If !Empty(cResult)
			oXml := XmlParser( cResult, "_", @cError, @cWarning )
			If oXml == Nil
				RestArea(aArea)
				Return
			EndIf
			     	        
			cStatusOS := AllTrim(oXml:_FormAnswers:_FormAnswer:_Status:TEXT) 	
			If AllTrim(cStatusOS) == "FIOK"     
				MsgAlert("A ordem de servi็o jแ foi finalizada." +CRLF +"O status serแ atualizado assim que as respostas forem processadas novamente.","TTMONITOR - Cancelar")
			Else
				StaticCall(TTPROC30,Cancelar)
			EndIf
	  	EndIf		
	  	*/
	EndIf
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณincluiros บAutor  ณAlexandre Venancio  บ Data ณ  03/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Incluir OS atraves da rotina de monitoramento.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function incluiros()

Local aArea	:=	GetArea()
Local cNumOs	:=	'' 
Local nItem		:=	''

cNumOs := StaticCall(TTPROC30,incluir)               

If !Empty(cNumOs) 

	cQuery := "SELECT ZG_FILIAL,ZG_NUMOS,ZG_DESCFRM,ZG_AGENTE,ZG_CLIFOR,ZG_LOJA,ZG_PATRIM,ZG_ROTA,ZG_AGENTED,ZF.R_E_C_N_O_ AS REC"
	cQuery += " FROM "+RetSQLName("SZG")+" ZG"
	cQuery += " LEFT JOIN "+RetSQLName("SZF")+" ZF ON ZF_FILIAL=ZG_FILIAL AND ZF_PATRIMO=ZG_PATRIM AND ZF_DATA=ZG_DATAINI AND ZF.D_E_L_E_T_=''"
	cQuery += " WHERE ZG_FILIAL='"+xFilial("SZG")+"' AND ZG_DATAINI='"+dtos(dDataBase)+"'	AND ZG_NUMOS='"+cNumOs+"' AND ZG.D_E_L_E_T_=''"
	 
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf         
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")
	                                     
    If Alltrim(TRB->ZG_DESCFRM) == 'SANGRIA'
		cQuery := "SELECT MAX(ZF_ITEM)+1 AS ITEM FROM "+RetSQLName("SZF")+" WHERE D_E_L_E_T_='' AND ZF_DATA='"+dtos(dDataBase)+"' AND ZF_FILIAL='"+xFilial("SZG")+"' AND ZF_ROTA='"+TRB->ZG_ROTA+"'"
	
		If Select("TRB2") > 0
			dbSelectArea("TRB2")
			dbCloseArea()
		EndIf         
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB2",.F.,.T.)
		dbSelectArea("TRB2")
		
		nItem := Strzero(TRB2->ITEM,3)
		If TRB->REC == 0 .And. Val(nItem) > 0
			Reclock("SZF",.T.)
			SZF->ZF_FILIAL	:=	TRB->ZG_FILIAL
			SZF->ZF_DATA	:=	dDataBase
			SZF->ZF_ROTA	:=	TRB->ZG_ROTA
			SZF->ZF_RESP	:=	TRB->ZG_AGENTED 
			SZF->ZF_PATRIMO	:=	TRB->ZG_PATRIM
			SZF->ZF_CLIENTE	:=	TRB->ZG_CLIFOR
			SZF->ZF_LOJA	:=	TRB->ZG_LOJA
			SZF->ZF_ITEM	:=	nItem
			SZF->ZF_ALTERAD	:=	'I'
			SZF->(Msunlock())
			
			DbSelectArea("SZN")
			DbSetOrder(2)
			If dbSeek( xFilial("SZN")+cvaltochar(dDataBase)+Avkey(TRB->ZG_PATRIM,"N1_CHAPA")+'SANGRIA' )
				If SZN->ZN_ROTA != TRB->ZG_ROTA
					Reclock("SZN",.F.)
					SZN->ZN_ROTA := TRB->ZG_ROTA
					SZN->(Msunlock())
				EndIf
			EndIf	
		EndIf
		/* 
		If TRB->REC > 0  
			//ja existe na SZF			
		Else
			Reclock("SZF",.T.)
			SZF->ZF_FILIAL	:=	TRB->ZG_FILIAL
			SZF->ZF_DATA	:=	dDataBase
			SZF->ZF_ROTA	:=	TRB->ZG_ROTA
			SZF->ZF_RESP	:=	TRB->ZG_AGENTED 
			SZF->ZF_PATRIMO	:=	TRB->ZG_PATRIM
			SZF->ZF_CLIENTE	:=	TRB->ZG_CLIFOR
			SZF->ZF_LOJA	:=	TRB->ZG_LOJA
			SZF->ZF_ITEM	:=	nItem
			SZF->ZF_ALTERAD	:=	'I'
			SZF->(Msunlock())
		EndIf
		
		DbSelectArea("SZN")
		DbSetOrder(2)
		If !DbSeek(xFilial("SZN")+cvaltochar(dDataBase)+Avkey(TRB->ZG_PATRIM,"N1_CHAPA")+'SANGRIA')
		    Reclock("SZN",.T.)     
		    SZN->ZN_FILIAL	:=	xFilial("SZF")
		    SZN->ZN_DATA   	:=	dDataBase
		    SZN->ZN_ROTA	:=	TRB->ZG_ROTA
		    SZN->ZN_PATRIMO	:=	TRB->ZG_PATRIM
		    SZN->ZN_CLIENTE	:=	TRB->ZG_CLIFOR
		    SZN->ZN_LOJA	:=	TRB->ZG_LOJA
		    SZN->ZN_TIPINCL	:= 	'SANGRIA'    
		    SZN->ZN_CONFERE	:=	'A' 
		    //SZN->ZN_NUMOS	:=	cNumOs
		    SZN->(Msunlock())   
		Else
			DbSeek(xFilial("SZN")+cvaltochar(dDataBase)+Avkey(TRB->ZG_PATRIM,"N1_CHAPA")+'SANGRIA')
			If SZN->ZN_ROTA != TRB->ZG_ROTA
				Reclock("SZN",.F.)
				SZN->ZN_ROTA 	:= TRB->ZG_ROTA
				//SZN->ZN_NUMOS  	:= nNumOs
				SZN->(Msunlock())
			EndIf
		EndIf
		*/
	EndIF
EndIf 

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRespostas บAutor  ณJackson E. de Deus  บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra as respostas da OS no navegador				      บฑฑ
ฑฑบ          ณ                                             	  			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Respostas()

Local nHandle
Local cDir := "C:\temp\"
Local cArqXml := ""
Local cNumOS := ""

If !oTree:IsEmpty()
	If oTree:Nivel() == 4
		cNumOS := oTree:getCargo()
		
		dbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
			If AllTrim(SZG->ZG_STATUS) $ "FIOK|INCO"
				If !Empty(SZG->ZG_RESPOST)
					cArqXml := AllTrim(SZG->ZG_NUMOS) +".xml"
					
					If !ExistDir(cDir)
						MakeDir(cDir)
					EndIf
					
					nHandle := FCreate( cDir+cArqXml )
					If nHandle == -1
						MsgInfo("Erro de cria็ใo do arquivo xml de respostas" +Str(Ferror()))
					Else
						FWrite(nHandle,SZG->ZG_RESPOST)
						FClose(nHandle)
						If File( cDir+cArqXml )
							If Ascan( aArquivos, { |x| x == cDir+cArqXml } ) == 0
								AADD( aArquivos, cDir+cArqXml )
							EndIf
							ShellExecute( "Open", "iexplore.exe" , cDir+cArqXml , "C:\", 1 )
						EndIf
					EndIf
				EndIf
			Else
				Aviso("","A ordem de servi็o ainda nใo foi finalizada.",{"Ok"})	            
			EndIf                                          
		EndIf
	EndIf
EndIf		

Return
				
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPesquisa  บAutor  ณJackson E. de Deus  บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a pesquisa na arvore conforme tipo de pesquisa e texto  บฑฑ
ฑฑบ          ณdigitado                                             	  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Pesquisa()

Local nPos
Local nI
Local lSair := .F. 
Local cItem := ""

IIF(oCBOX1 <> NIL .Or. oCBOX1 == 0,nPos := oCBOX1:nAt,1)

/*
1 - OS
2 - cod tecnico
3 - nome tecnico
4 - cod super
5 - nome super
6 - cod gestor
7 - nome gestor
*/

If nPos == 1
	cItem := AllTrim(cPesq)
Else	  
	// gestor 
	For nI := 1 To Len( aOS )
		If !lSair
			If nPos == 6
				If AllTrim(cItem) == aOS[nI][1]
					cItem := aOS[nI][1]
					lSair := .T.
					Exit
				EndIf	
			ElseIf nPos == 7
				If AllTrim(cPesq) $ aOS[nI][2]
					cItem := aOS[nI][1]
					lSair := .T.
					Exit
				EndIf
			EndIf
	
	        If nPos == 4 .Or. nPos == 5 .Or. nPos == 2 .Or. nPos == 3
				// supervisor
				For nJ := 3 To Len( aOS[nI] ) 
					If !lSair
						If nPos == 4
							If AllTrim(cPesq) == aOS[nI][nJ][1]
								cItem := aOS[nI][nJ][1]
								lSair := .T.
								Exit
							EndIf	
						ElseIf nPos == 5
							If AllTrim(cPesq) $ aOS[nI][nJ][2]
								cItem := aOS[nI][nJ][1]
								lSair := .T.
								Exit
							EndIf
						EndIf
						
						If nPos == 2 .Or. nPos == 3
							// tecnico
							For nK := 3 To Len( aOS[nI][nJ] )
								If !lSair
									If nPos == 2
										If AllTrim(cPesq) == aOS[nI][nJ][nK][1]
											cItem := aOS[nI][nJ][nK][1]
											lSair := .T.
											Exit
										EndIf	
									ElseIf nPos == 3
										If AllTrim(cPesq) $ aOS[nI][nJ][nK][2]
											cItem := aOS[nI][nJ][nK][1]
											lSair := .T.
											Exit
										EndIf
									EndIf
								EndIf	
							Next nK
						EndIf	
					EndIf	
				Next nJ
			EndIf
		EndIf	
	Next nI		
EndIf

If !Empty(cItem)
	If oTree:TreeSeek( cItem ) 
		oTree:SetFocus()
		Visual()
	EndIf
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltValid บAutor  ณJackson E. de Deus   บ Data ณ  29/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDesabilita validacao da OS no retorno das respostas         บฑฑ
ฑฑบ          ณExecutada via staticcall do fonte TTPROC30 - manut. de OS   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltValid()

Local cNumOS := ""

If !oTree:IsEmpty()
	If oTree:Nivel() == 4
		cNumOS := oTree:getCargo()
		DbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
			StaticCall(TTPROC30,AltValid)
		EndIf
	EndIf
EndIf		

Return

           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFormIndic บAutor  ณJackson E. de Deus  บ Data ณ  16/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Escolha de formularios considerados nos indicadores        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FormIndic()

Local oDlg1,oPanel,oPanel2,oSay1,oCB1,oCB2,oCB3,oCB4,oCB5,oCB6,oCB7,oCB8,oBtn1
Local nOpc := 0
Local cTpForm := ""
Local lFrm1 := .F.
Local lFrm2 := .F.
Local lFrm3 := .F.
Local lFrm4 := .F.
Local lFrm6 := .F.
Local lFrm7 := .F.
Local lFrm13 := .F.
Local lFrm16 := .F.
Local lFrm17 := .F.

oDlg1 := MSDialog():New( 0,0,400,400,"Configura็ใo de Indicadores",,,.F.,,,,,,.T.,,,.T. )

	cCSS := "QCheckBox:indicator { width: 13px; height: 13px; } "
	CSSDictAdd("TCheckBox", cCSS)
	
	oPanel := tPanel():New(0,0,,oDlg1,,,,,,0,0)
	oPanel:SetCss( " QLabel { background-color: #EBEBFF; }" )	
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT 		
    
	oPanel2 := tPanel():New(0,0,,oDlg1,,,,,,0,20)
	oPanel2:Align := CONTROL_ALIGN_BOTTOM 	
    
   	oSay1 := TSay():New( 05,040	,{|| "Escolha os formulแrios para composi็ใo dos indicadores:"},oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,008,,,,,,.F.)
                                                                                                                                         
	oCB1	:= TCheckBox():New( 020,040,"Confer๊ncia cega",{|u|If(Pcount()>0,lFrm1:=u,lFrm1)},oDlg1,100,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB2	:= TCheckBox():New( 040,040,"Leitura",{|u|If(Pcount()>0,lFrm2:=u,lFrm2)},oDlg1,100,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB3	:= TCheckBox():New( 060,040,"Sangria",{|u|If(Pcount()>0,lFrm3:=u,lFrm3)},oDlg1,100,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB4	:= TCheckBox():New( 080,040,"Abastecimento",{|u|If(Pcount()>0,lFrm4:=u,lFrm4)},oDlg1,100,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB5	:= TCheckBox():New( 100,040,"Chamado T้cnico",{|u|If(Pcount()>0,lFrm7:=u,lFrm7)},oDlg1,100,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB6	:= TCheckBox():New( 120,040,"Entregas",{|u|If(Pcount()>0,lFrm13:=u,lFrm13)},oDlg1,100,010,,{ || },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB7	:= TCheckBox():New( 140,040,"Instala็ใo de mแquina",{|u|If(Pcount()>0,lFrm16:=u,lFrm16)},oDlg1,100,010,,{ || },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCB8	:= TCheckBox():New( 160,040,"Remo็ใo de mแquina",{|u|If(Pcount()>0,lFrm17:=u,lFrm17)},oDlg1,100,010,,{ || },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
    
    UpdChkB(@lFrm1,@lFrm2,@lFrm3,@lFrm4,@lFrm7,@lFrm13,@lFrm16,@lFrm17)

	oBtn1	:= TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR' , , , ,{ || oDlg1:End(nOpc:=1) } , oPanel2, "Salvar" , ,)
	oBtn1:Align := CONTROL_ALIGN_RIGHT

oDlg1:Activate(,,,.T.)

If nOpc = 1
	_aFormIndic := {}
	If lFrm1
		AADD( _aFormIndic, "1" )
	EndIf
	If lFrm2
		AADD( _aFormIndic, "2" )
	EndIf
	If lFrm3
		AADD( _aFormIndic, "3" )
	EndIf
	If lFrm4
		AADD( _aFormIndic, "4" )
		AADD( _aFormIndic, "8" )	
	EndIf
	If lFrm7
		AADD( _aFormIndic, "6" )
		AADD( _aFormIndic, "7" )	
	EndIf
	If lFrm13
		AADD( _aFormIndic, "13" )	
	EndIf
	If lFrm16
		AADD( _aFormIndic, "16" )	
	EndIf
	If lFrm17
		AADD( _aFormIndic, "17" )	
	EndIf
	     
	CursorWait()
	TotalOS()
	CursorArrow()	
EndIf

CSSDictAdd("TCheckBox", "")
    
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUpdChkB บAutor  ณJackson E. de Deus    บ Data ณ  16/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza checkbox                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function UpdChkB(lFrm1,lFrm2,lFrm3,lFrm4,lFrm7,lFrm13,lFrm16,lFrm17)

Local nI
Local cTpForm := ""

For nI := 1 To Len(_aFormIndic)
	cTpForm := _aFormIndic[nI]
	If cTpForm == "1"
		lFrm1 := .T.
	ElseIf cTpForm == "2"
		lFrm2 := .T.	
	ElseIf cTpForm == "3"
		lFrm3 := .T.
	ElseIf cTpForm == "4"
		lFrm4 := .T.	
	ElseIf cTpForm == "7"
		lFrm7 := .T.	
	ElseIf cTpForm == "13"
		lFrm13 := .T.	
	ElseIf cTpForm == "16"
		lFrm16 := .T.	
	ElseIf cTpForm == "17"
		lFrm17 := .T.	
	EndIf
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMapView บAutor  ณJackson E. de Deus    บ Data ณ  18/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostrar mapa no navegador                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MapView()

Local cLatTT := "-23.513510 -46.734150" // coordenadas tok take
Local cUrl := ""
Local nOpc := 0

If !oTree:IsEmpty()
	If oTree:Nivel() == 4
	
		nOpc := Aviso( "","Qual posi็ใo deseja visualizar no mapa?",{"Inํcio da OS","Fim da OS"} )
	
		cNumOS := PadL( AllTrim(oTree:getCargo()),TamSx3("ZG_NUMOS")[1],"0")
		dbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
			                                                   
			If nOpc == 1
				If !Empty( SZG->ZG_LATLNG1 ) 
					cUrl := "https://www.google.com.br/maps/dir/" +cLatTT +"/" +SZG->ZG_LATLNG1
					ShellExecute( "Open", "iexplore.exe" , cUrl , "C:\", 1 )
				EndIf    
			ElseIf nOPc == 2
				If !Empty( SZG->ZG_LATLNG2 ) 
					cUrl := "https://www.google.com.br/maps/dir/" +cLatTT +"/" +SZG->ZG_LATLNG2
					ShellExecute( "Open", "iexplore.exe" , cUrl , "C:\", 1 )
				EndIf 
			EndIf
		
		EndIf
	EndIf		
EndIf



Return