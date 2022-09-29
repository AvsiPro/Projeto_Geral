#include "TOTVS.CH"
#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#include "FWBROWSE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTMON2 บAutor  ณJackson E. de Deus     บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonitor de chamados do call center x chamados tecnicos      บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ18/09/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ08/10/14ณ01.01 |Alteracao no comportamento das janelas  ณฑฑ
ฑฑณ								  do FwLayer                              ณฑฑ
ฑฑณ								  Solic. Gustavo S.					      ณฑฑ
ฑฑณJackson       ณ20/10/14ณ01.02 | Window 3 - Agrupamentos:				  ณฑฑ
ฑฑณ									Iniciar ordenada pela coluna 5		  ณฑฑ
ฑฑณ									Qtd Chamados x Qtd maquinas 2;		  ณฑฑ
ฑฑณ									Ordenacao tambem pela coluna 5;		  ณฑฑ
ฑฑณJackson       ณ24/11/14ณ01.03 | Ajuste da largura das colunas		  ณฑฑ
ฑฑณJackson       ณ09/09/15ณ02.00 | Programa redesenhado	- varias mudancas ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTMON2()
                           
Local aSize			:= {}                                              
Local nTempo		:= 240000	// 240000 tempo de refresh - 4 minutos ( 60 * 1000 * 4 )
Local oGrp			:= LoadBitMap(GetResources(), "BR_AZUL")
Local aSize			:= MsAdvSize()
Local nWdtRdp		:= aSize[5]/2
Private _cArquivo	:= ""
Private _cIndice	:= ""
Private _cArquivo2	:= ""
Private _cIndice2	:= ""
Private _cArquivo3	:= ""
Private _cIndice3	:= ""
Private _cArquivo4	:= ""
Private _cIndice4	:= ""
Private _cArquivo5	:= ""
Private _cIndice5	:= ""
Private _aTotais	:= {0,0,0,0,0,0,0}
Private _cFiltro	:= ""
Private oVazio		:= LoadBitMap(GetResources(), "BR_PRETO") 
Private oVerde		:= LoadBitMap(GetResources(), "BR_VERDE") 
Private oVerm		:= LoadBitMap(GetResources(), "BR_VERMELHO") 
Private oAmar		:= LoadBitMap(GetResources(), "BR_AMARELO") 
Private oRoxo		:= LoadBitMap(GetResources(), "BR_VIOLETA") 
Private oLaran		:= LoadBitMap(GetResources(), "BR_LARANJA") 
Private _aUsers		:= {}
Private oWindow
Private oLayer		:= FwLayer():New()  
Private oList1
Private oList2
Private cCadastro	:= "Monitor de Chamados"
Private aAux		:= {}
Private aStruTrb1	:= {}
Private aDados3		:= {}			// Array dados TcBrowse3
Private aDados3Bkp	:= {}			// Array dados TcBrowse3 BKP
Private aUFTodos	:= fEstados()
Private aUFBR		:= { "TODOS" }
Private lRefresh	:= .F.
Private nLastRec	:= 0			// Ultimo RECNO da SUC - utilizado para controle do refresh da tela
Private cQtd1		:= "0"
Private cQtd2		:= "0"
Private cQtd3		:= "0"
Private cQtd4		:= "0"
Private cQtd5		:= "0"
Private cQtd6		:= "0"
Private cQtd7		:= "0"
Private cQtdP2		:= "0%"
Private cQtdP3		:= "0%"
Private cQtdP4		:= "0%"
Private cQtdP5		:= "0%"
Private cQtdP6		:= "100%"
Private cQtdP7		:= "0%"


SetKey(VK_F12, { || Processa( { || Refresh() },"Verificando atualiza็๕es, aguarde..") } )


PrepTrab()    
Carga()


dbSelectArea("TRB1")
TRB1->(dbGoTop())

oWindow := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],cCadastro,,,.F.,,CLR_WHITE,,,,.T.,,,.T. )	
	oWindow:lEscClose := .F.
	oWindow:lMaximized := .T.
	
	oTimer := TTimer():New( nTempo, {|| Refresh() }, oWindow )  
	oTimer:Activate()
	
	oLayer:Init(oWindow,.F.)
	
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Chamados",090,.F.,.T.,{||} )
	oPnlEsq := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnlEsq:FreeChildren()

  	oPanel := tPanel():New(0,0,"",oWindow,,,,CLR_BLACK,CLR_WHITE,0,030)
	oPanel:align := CONTROL_ALIGN_BOTTOM
                                                             
    
    // Menu popup grid 1
	MENU oMenu POPUP
		MENUITEM "Visualizar chamado Call Center" ACTION ( Visual( TRB1->RECUC,TRB1->UCFIL,1 ) )
		MENUITEM "Visualizar chamado T้cnico" ACTION ( Visual( TRB1->RECUC,TRB1->UCFIL,2 ) )
	ENDMENU
	         
    // chamados
    oList1 := TCBrowse():New(0,0,0,0,,,,oPnlEsq,,,,,{||},,,,,,,.F.,'TRB1',.T.,,.F.,,.T.,.F.)
    
	oList1:AddColumn(TCColumn():New(''								,{|| Fst(TRB1->STATUS)  },"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Estado'						,{|| TRB1->UF },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList1:AddColumn(TCColumn():New('Chamado'						,{|| TRB1->CHAMADO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList1:AddColumn(TCColumn():New('Data inicio'					,{|| TRB1->DTINI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList1:AddColumn(TCColumn():New('Hora inicio'					,{|| TRB1->HRINI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Cliente'						,{|| TRB1->CLIENTE },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Ocorr๊ncia Call Center'		,{|| TRB1->OCTMKD },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Ocorr๊ncia Chamado T้cnico'	,{|| TRB1->OCTECD },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Responsแvel'					,{|| TRB1->RESP },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('OS Mobile'						,{|| TRB1->OSMOB },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('T้cnico'						,{|| TRB1->TECNICO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Data'							,{|| TRB1->DFIMOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList1:AddColumn(TCColumn():New('Hora'							,{|| TRB1->HFIMOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          
	oList1:AddColumn(TCColumn():New('Status OS'						,{|| TRB1->STATOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          
	oList1:AddColumn(TCColumn():New('Patrim๔nio'					,{|| TRB1->PATRIM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList1:AddColumn(TCColumn():New('Modelo'						,{|| TRB1->MODEL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList1:AddColumn(TCColumn():New('Data prevista'					,{|| TRB1->DPREVTMK },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList1:AddColumn(TCColumn():New('Hora prevista'					,{|| TRB1->HPREVTMK },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          		
	oList1:AddColumn(TCColumn():New('Filial'						,{|| TRB1->FILIAL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          		
	

	oList1:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	
	oList1:Align := CONTROL_ALIGN_ALLCLIENT
	
	// menu orcamentos
	MENU oMenuX POPUP                        
		MENUITEM "Maiores atrasos"	ACTION ( MAtraso() )
		MENUITEM "ฺltimos 2 meses"	ACTION ( Hist2M() )
		MENUITEM "Indicadores"		ACTION ( IndTec() )
		MENUITEM "Filtro"			ACTION ( Filtro("TRB1") )
		MENUITEM "Legenda"			ACTION ( Legenda() )
	ENDMENU
                        
	/*
	// INDICADORES RODAPE	
	oLg1 := TBitmap():Create(oPanel,0,0,10,10,"BR_AZUL"			,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)			// total programadas
	oLg2 := TBitmap():Create(oPanel,10,0,10,10,"BR_VERDE"			,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)	// qtd e% encerrado no prazo - chamado t้cnico 
	oLg3 := TBitmap():Create(oPanel,20,0,10,10,"BR_PINK"			,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)	// qtd e % encerrado com atraso - chamado t้cnico 
	oLg4 := TBitmap():Create(oPanel,10,120,10,10,"BR_AMARELO"		,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)	// qtd e % aberto - no prazo - chamado t้cnico
	oLg5 := TBitmap():Create(oPanel,20,120,10,10,"red_star.png"	,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)	// qtd e % aberto - com atraso - chamado t้cnico
	oLg6 := TBitmap():Create(oPanel,10,260,10,10,"BR_CINZA"		,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)	// qtd e % de chamados em aberto - chamado t้cnico
	oLg7 := TBitmap():Create(oPanel,20,260,10,10,"BR_MARROM"		,,.T., {||  },,.F.,.F.,,,.F.,,.T.,,.F.)	// qtd e% parcialmente atendidos - chamado t้cnico
	
	oSLg1 := TSay():New( 0,10	,{|| "Programados 30d"}				,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,50,008,,,,,,.F.)
	oSLg2 := TSay():New( 10,10	,{|| "Encer. no prazo 30d"}			,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,50,008,,,,,,.F.)
	oSLg3 := TSay():New( 20,10	,{|| "Encer. c/ atraso 30d"}		,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,50,008,,,,,,.F.)
	oSLg4 := TSay():New( 10,130	,{|| "Em aberto no prazo"}			,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg5 := TSay():New( 20,130	,{|| "Em aberto c/ atraso"}			,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg6 := TSay():New( 10,275	,{|| "Chamados em aberto"}			,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	oSLg7 := TSay():New( 20,275	,{|| "Parcialmente atendidos"}		,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,80,008,,,,,,.F.)
	
	
	oSLgQ1 := TSay():New( 0,65	,{|| cQtd1 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ2 := TSay():New( 10,65	,{|| cQtd2 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ3 := TSay():New( 20,65	,{|| cQtd3 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ4 := TSay():New( 10,195,{|| cQtd4 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ5 := TSay():New( 20,195,{|| cQtd5 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ6 := TSay():New( 10,345,{|| cQtd6 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSLgQ7 := TSay():New( 20,345,{|| cQtd7 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)	
	
	oSQP2 := TSay():New( 10,80	,{|| cQtdP2 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP3 := TSay():New( 20,80	,{|| cQtdP3 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP4 := TSay():New( 10,215	,{|| cQtdP4 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP5 := TSay():New( 20,215	,{|| cQtdP5 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP6 := TSay():New( 10,360	,{|| cQtdP6 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)
	oSQP7 := TSay():New( 20,360	,{|| cQtdP7 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,25,008,,,,,,.F.)	
	
	oSLgQ5:SetCss(" QLabel {font: bold 12px; color: #CC0000; } ")
	oSQP5:SetCss(" QLabel { font: bold 12px; color: #CC0000; } ")
	*/	
	

	// botoes rodape
	oBtPar := TButton():New( 0, nWdtRdp-85,"Op็๕es",oPanel,{ ||  },45,15,,,,.T.,,"Op็๕es",,,,.F. )
	oBtPar:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:engrenagem.png); background-repeat: none; margin: 1px }" )			
   	oBtPar:SetPopupMenu(oMenuX)
   	
   	oBtn := TButton():New( 0, nWdtRdp-40,"Sair",oPanel,{ || oWindow:End()  },40,15,,,,.T.,,"Sair",,,,.F. )
	oBtn:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 0px; background-image: url(rpo:cancel.png); background-repeat: none; margin: 1px }" )			
	  
	// calcula indicadores
	//oWindow:bStart := { || 	Processa( { || CalcInd() }, "Calculando indicadores, aguarde.." )  }
	        
oWindow:Activate(,,,.T.) 


FechaTrb()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechaTrb    บAutor  ณJackson E. de Deusบ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fecha e apaga os arquivos de trabalho                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FechaTrb()

If Select("TRB1") > 0
	TRB1->(dbCloseArea())
EndIf                   


If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
 
If Select("TRB3") > 0
	TRB3->(dbCloseArea())
EndIf

If Select("TRBT") > 0
	TRBT->(dbCloseArea())
EndIf

If Select("TRBU") > 0
	TRBU->(dbCloseArea())
EndIf 

If File("\system\" +_cArquivo +"." +OrdbagExt())
	MsErase("\system\" +_cArquivo +"." +OrdbagExt())
EndIf

If File("\system\" +_cArquivo2 +"." +OrdbagExt())
	MsErase("\system\" +_cArquivo2 +"." +OrdbagExt())
EndIf

If File("\system\" +_cArquivo3 +"." +OrdbagExt())
	MsErase("\system\" +_cArquivo3 +"." +OrdbagExt())
EndIf

If File("\system\" +_cArquivo4 +"." +OrdbagExt())
	MsErase("\system\" +_cArquivo4 +"." +OrdbagExt())
EndIf

If File("\system\" +_cArquivo5 +"." +OrdbagExt())
	MsErase("\system\" +_cArquivo5 +"." +OrdbagExt())
EndIf		

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda    บAutor  ณJackson E. de Deus บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Legenda()
     
BrwLegenda(cCadastro,"Status",{{"BR_VERDE","Encerrado"},; 
								{"BR_VERMELHO","Pendente"},;
                               {"BR_AMARELO","Esgotando prazo"},;
                               {"BR_LARANJA","Atendido parcial"},; 
                                {"BR_VIOLETA","Atrasado"},;
                               {"BR_AZUL","Ultimos 2 meses"}})   

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSt    บAutor  ณJackson E. de Deus     บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o status para coluna do tcbrowse                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSt(cStatus)

Local oBmp := Nil

If AllTrim(cStatus) == "BR_VERMELHO"
	oBmp := oVerm
ElseIf AllTrim(cStatus) == "BR_AMARELO"
	oBmp := oAmar
ElseIf AllTrim(cStatus) == "BR_VIOLETA"
	oBmp := oRoxo	
ElseIf AllTrim(cStatus) == "BR_LARANJA"
	oBmp := oLaran
EndIf            

If oBmp == Nil
	oBmp := oVazio
EndIf


Return oBmp


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAtraso    บAutor  ณJackson E. de Deus บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Maiores atrasos                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MAtraso()

Local aArea		:= GetArea()
Local oWnd
Local oLayer	:= FwLayer():New() 
Local aSize		:= MsAdvSize(Nil,.F.)
Local nWdtRdp	:= aSize[5]/2
Local oPanel
Local oGrp		:= LoadBitMap(GetResources(), "BR_AZUL")
Local oMenu
Local nI

CursorWait()

// Maiores atrasos - SOMENTE OS CHAMADOS PENDENTES COM DATA INFERIOR A HOJE
Processa( { || Carregar(2) },"Carregando os chamados atrasados, aguarde..")

CursorArrow()

dbSelectArea("TRB2")
TRB2->(dbGoTop())

If !Empty(_cFiltro)
	If MsgYesNo("Considerar filtro da tela inicial?")
		Fil("TRB2")    		
	EndIf             
EndIf
    

For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.8
Next nI

oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )		
	
	oLayer:Init(oWnd,.F.)
	
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Maiores atrasos",90,.F.,.T.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()
	
	oPanel := tPanel():New(0,0,"",oWnd,,,,CLR_BLACK,CLR_WHITE,0,020)
	oPanel:align := CONTROL_ALIGN_BOTTOM
    
    
    // menu popup grid 2
    MENU oMenu POPUP
	    MENUITEM "Visualizar chamado Call Center" ACTION ( Visual(TRB2->RECUC,TRB2->UCFIL,1 ) )
		MENUITEM "Visualizar chamado T้cnico" ACTION ( Visual(TRB2->RECUC,TRB2->UCFIL,2 ) )		
	ENDMENU
              
	// maiores atrasos
	oList2 := TCBrowse():New(0,0,0,0,,,,oPnl,,,,,{||},,,,,,,.F.,'TRB2',.T.,,.F.,,.T.,.F.)
    
	oList2:AddColumn(TCColumn():New(''								,{|| Fst(TRB2->STATUS)  },"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Estado'						,{|| TRB2->UF },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Chamado'						,{|| TRB2->CHAMADO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Data inicio'					,{|| TRB2->DTINI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Hora inicio'					,{|| TRB2->HRINI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Cliente'						,{|| TRB2->CLIENTE },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Ocorr๊ncia Call Center'		,{|| TRB2->OCTMKD },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Ocorr๊ncia Chamado T้cnico'	,{|| TRB2->OCTECD },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Responsแvel'					,{|| TRB2->RESP },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('OS Mobile'						,{|| TRB2->OSMOB },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('T้cnico'						,{|| TRB2->TECNICO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Data'							,{|| TRB2->DFIMOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('Hora'							,{|| TRB2->HFIMOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          
	oList2:AddColumn(TCColumn():New('Status OS'						,{|| TRB2->STATOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          
	oList2:AddColumn(TCColumn():New('Patrim๔nio'					,{|| TRB2->PATRIM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList2:AddColumn(TCColumn():New('Modelo'						,{|| TRB2->MODEL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList2:AddColumn(TCColumn():New('Data prevista'					,{|| TRB2->DPREVTMK },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList2:AddColumn(TCColumn():New('Hora prevista'					,{|| TRB2->HPREVTMK },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          		
	oList2:AddColumn(TCColumn():New('Filial'						,{|| TRB2->FILIAL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          		
	
	
	oList2:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oList2:Align := CONTROL_ALIGN_ALLCLIENT
			    
oWnd:Activate(,,,.T.) 

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHist2M    บAutor  ณJackson E. de Deus  บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Historico 2 meses                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Hist2M()

Local aArea		:= GetArea()
Local oWnd
Local oLayer	:= FwLayer():New() 
Local aSize		:= MsAdvSize(Nil,.F.)
Local oPnl
Local oGrp		:= LoadBitMap(GetResources(), "BR_AZUL")
Local aCabec3	:= {"","Estado","Cliente","Chamados x Maquina","Qtd chamados x Qtd Patrimonio","Qtd chamados","Qtd Maquinas"}
Local aColun3	:= {5,25,100,20,20,20,20}
Local nI
Local oList3

CursorWait()

// somente 2 ultimos meses
Processa( { || Carregar(3) },"Carregando a rela็ใo clientes x chamados, aguarde..")
aDados3 := aclone(aAux)
aDados3Bkp := AClone(aDados3)

CursorArrow()


For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.8
Next nI

oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )		
	
	oLayer:Init(oWnd,.F.)
	
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Ultimos 2 meses",100,.F.,.T.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()
    

	// ultimos 2 meses agrupado por cliente
    oList3 := TCBrowse():New(0,0,0,0,,aCabec3,aColun3,oPnl,,,,,{ || fdblclk3(oList3:nAt,oList3:ColPos) },,,,,,,.F.,,.T.,,.F.,,.T.,.F.)
	oList3:SetArray(aDados3)
	oList3:bLine := { ||{ oGrp,;										// Cor
					 	aDados3[oList3:nAt,09],;						// Estado
					 	aDados3[oList3:nAt,06],;						// Cliente
					 	aDados3[oList3:nAt,08],;						// Qtd Chamados x Qtd maquinas
				 		aDados3[oList3:nAt,11],;						// Qtd Chamados x Qtd maquinas 2 - somente chamados com maquina
					 	aDados3[oList3:nAt,07],;						// Total de chamados
				 		aDados3[oList3:nAt,10]}}						// Total de maquinas
	
	oList3:bHeaderClick := { || bHdClk3( oList3:nAt,oList3:nColPos,@oList3 ) }
	oList3:Align := CONTROL_ALIGN_ALLCLIENT

oWnd:Activate(,,,.T.)  

RestArea(aArea)
         
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIndTec    บAutor  ณJackson E. de Deus  บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Indicadores dos tecnicos                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IndTec()

Local aArea		:= GetArea()
Local oWnd
Local oLayer	:= FwLayer():New() 
Local aSize		:= MsAdvSize(Nil,.F.)
Local bSavKeyF4	:= SetKey(VK_F4,Nil)
Local oPnl
Local nI
Local oListX
Local oListY
Local oPanel
Local cCodTec	:= ""
Local dDia		:= stod("")
Local cOcorrTec := ""
Local aStru		:= {}
Private nTrb1	:= 0
Private nTrb2	:= 0
Private cInd1	:= ""
Private cInd2	:= ""
Private cInd3	:= ""
Private cInd4	:= ""
Private cInd5	:= ""
Private cInd6	:= ""


FilTec(@cCodTec,@dDia,@cOcorrTec)

If Empty(cCodTec)
	MsgAlert("Informe o c๓digo do atendente!")
	Return
EndIf

CursorWait()


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMONTA AREA DE TRABALHOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
AADD( aStru,{"CODTEC"	,"C",6,0})
AADD( aStru,{"NOMTEC"	,"C",TamSx3("AA1_NOMTEC")[1],0})
AADD( aStru,{"DT"		,"D",8,0})
AADD( aStru,{"CODCLI"	,"C",TamSx3("A1_COD")[1],0})
AADD( aStru,{"LOJA"		,"C",TamSx3("A1_LOJA")[1],0})
AADD( aStru,{"NOME"		,"C",TamSx3("A1_NREDUZ")[1],0})
AADD( aStru,{"OCTEC"	,"C",TamSx3("AB2_CODPRB")[1],0})
AADD( aStru,{"TOTAL"	,"N",4,0})

		
If Select("TRBT") > 0
	TRBT->(dbCloseArea())
EndIf


If Select("TRBU") > 0
	TRBU->(dbCloseArea())
EndIf

_cArquivo4 := CriaTrab(aStru,.T.)
_cIndice4  := CriaTrab(Nil,.F.)

_cArquivo5 := CriaTrab(aStru,.T.)
_cIndice5  := CriaTrab(Nil,.F.)
			
		
dbUseArea(.T.,,_cArquivo4,"TRBT",.F.,.F.)
IndRegua("TRBT",_cIndice4,"CODTEC")


dbUseArea(.T.,,_cArquivo5,"TRBU",.F.,.F.)
IndRegua("TRBU",_cIndice5,"CODTEC")

// HOJE
Processa( { || LoadTec(cCodTec,dDia,cOcorrTec,2) },"Aguarde..")

// 30 DIAS
Processa( { || LoadTec(cCodTec,dDia,cOcorrTec,1) },"Aguarde..")


dbSelectArea("TRBT")
TRBT->(dbGoTop())

dbSelectArea("TRBU")
TRBU->(dbGoTop())
	
CursorArrow()


For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.9
Next nI


oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )		
	
	oLayer:Init(oWnd,.F.)
	
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Hoje",45,.F.,.F.,{||} )
  	oLayer:addWindow("COLUNA1","WIN_2","30 dias",45,.F.,.F.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl2 := oLayer:GetWinPanel("COLUNA1","WIN_2")
	oPnl:FreeChildren()                          
	oPnl2:FreeChildren()                          
	
	oPanel := tPanel():New(0,0,"",oWnd,,,,CLR_BLACK,CLR_WHITE,0,020)
	oPanel:align := CONTROL_ALIGN_BOTTOM
     
    // Hoje
	oListX := TCBrowse():New(0,0,0,0,,,,oPnl,,,,,{||},,,,,,,.F.,'TRBT',.T.,,.F.,,.T.,.F.)
	oListX:Align := CONTROL_ALIGN_ALLCLIENT
	
	//oListX:AddColumn(TCColumn():New('Tecnico'			,{|| TRBT->NOMTEC },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	//oListX:AddColumn(TCColumn():New('Data'				,{|| TRBT->DT },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oListX:AddColumn(TCColumn():New('Cliente'			,{|| TRBT->CODCLI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oListX:AddColumn(TCColumn():New('Loja'				,{|| TRBT->LOJA },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oListX:AddColumn(TCColumn():New('Nome'				,{|| TRBT->NOME },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oListX:AddColumn(TCColumn():New('Total atendimento'	,{|| TRBT->TOTAL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	
	
	
	// 30 DIAS
	oListY := TCBrowse():New(0,0,0,0,,,,oPnl2,,,,,{||},,,,,,,.F.,'TRBU',.T.,,.F.,,.T.,.F.)
	oListY:Align := CONTROL_ALIGN_ALLCLIENT
	//oListY:AddColumn(TCColumn():New('Tecnico'			,{|| TRBU->NOMTEC },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oListY:AddColumn(TCColumn():New('Data'				,{|| TRBU->DT },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oListY:AddColumn(TCColumn():New('Cliente'			,{|| TRBU->CODCLI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oListY:AddColumn(TCColumn():New('Loja'				,{|| TRBU->LOJA },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oListY:AddColumn(TCColumn():New('Nome'				,{|| TRBU->NOME },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oListY:AddColumn(TCColumn():New('Total atendimento'	,{|| TRBU->TOTAL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	

	// indicadores
	// pior tempo - entre abertura chamado tmk e finaliza็ใo OS
	oIndT1 := TSay():New( 0,5	,{|| "Pior tempo" }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,008,,,,,,.F.)
	oInd1 := TSay():New( 0,50	,{|| cInd1 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)

	// pior tempo 2 - inicio abertura OS  e finaliza็ใo OS
	oIndT2 := TSay():New( 10,5	,{|| "Pior tempo 2" }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,008,,,,,,.F.)
	oInd2 := TSay():New( 10,50	,{|| cInd2 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)

	// melhor tempo
	oIndT3 := TSay():New( 0,100	,{|| "Melhor tempo" }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,008,,,,,,.F.)
	oInd3 := TSay():New( 0,150	,{|| cInd3 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)

	// melhor tempo 2
	oIndT4 := TSay():New( 10,100,{|| "Melhor tempo 2" }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,008,,,,,,.F.)
	oInd4 := TSay():New( 10,150	,{|| cInd4 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)

	// media tempo 1
	oIndT5 := TSay():New( 0,200	,{|| "Media tempo" }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,008,,,,,,.F.)
	oInd5 := TSay():New( 0,250	,{|| cInd5 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)

	// media tempo2
	oIndT6 := TSay():New( 10,200,{|| "Media tempo 2" }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,40,008,,,,,,.F.)
	oInd6 := TSay():New( 10,250	,{|| cInd6 }	,oPanel,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)				
		
	oWnd:bStart := { || Processa( { || ClcIDTec() }, "Calculando indicadores, aguarde.." )  }

oWnd:Activate(,,,.T.)  

RestArea(aArea)


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadTec    บAutor  ณJackson E. de Deus บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os dados dos atendimentos dos tecnicos             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadTec(cCodTec,dDia,cOcorrTec,nOpcao)

Local cSql := ""
Local cAlias := ""
Local nTot := 0


If nOpcao == 1
	cAlias := "TRBU"
ElseIf nOpcao == 2
	cAlias := "TRBT"
EndIf



// consulta
cSql := "SELECT ZG_CODTEC CODTEC, ZG_AGENTED NOMTEC, AB2_CODPRB OCORR , ZG_DATAFIM DT, ZG_CLIFOR CODCLI, ZG_LOJA LOJA, ZG_DESCCF NOME, COUNT(*) TOTAL "
cSql += "FROM " +RetSqlName("AB2") +" AB2 WITH (NOLOCK) "

cSql += "INNER JOIN " +RetSqlName("SZG") +" ZG ON "
cSql += "ZG_NUMOS = AB2_XOSMOB "

cSql += "INNER JOIN " +RetSqlName("AB9") +" AB9 ON "
cSql += "AB9_XOSMOB = AB2_XOSMOB "

cSql += "WHERE "
If nOpcao == 1
	cSql += " ZG_DATAFIM BETWEEN '"+DTOS(Date()-30)+"' AND '"+DTOS(Date()-1)+"' "
ElseIf nOpcao == 2
	cSql += " ZG_DATAFIM = '"+DTOS(Date())+"' "
EndIf

cSql += "AND ZG_STATUS = 'FIOK' "
cSql += "AND AB2.D_E_L_E_T_ = '' "

If !empty(cCodTec)
	cSql += " AND ZG_CODTEC = '"+cCodTec+"' "
EndIf
If !Empty(dDia)
	cSql += " AND AB2_EMISSA = '"+DTOS(dDia)+"' "
EndIf
If !Empty(cOcorrTec)
	cSql += " AND AB2_CODPRB = '"+cOcorrTec+"' "
EndIf

cSql += "GROUP BY ZG_CODTEC,ZG_AGENTED, AB2_CODPRB, ZG_DATAFIM, ZG_CLIFOR, ZG_LOJA, ZG_DESCCF "
cSql += "ORDER BY TOTAL DESC, ZG_AGENTED, ZG_DATAFIM DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf        

TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
TRB->(dbGoTop())  

While TRB->(!EOF())
	nTot++
	TRB->(dbSkip())	
End

If cAlias == "TRBT"
	nTrb1 := nTot
ElseIf cAlias == "TRBU"
	nTrb2 := nTot	
EndIf

ProcRegua(nTot)

TRB->(dbGoTop())  
While TRB->(!EOF())
                    
	IncProc("")
	                   
	dbSelectArea(cAlias)
	If RecLock(cAlias,.T.)
		(cAlias)->CODTEC := TRB->CODTEC
		(cAlias)->NOMTEC :=  TRB->NOMTEC
		(cAlias)->DT := stod(TRB->DT)
		(cAlias)->CODCLI := TRB->CODCLI
		(cAlias)->LOJA := TRB->LOJA
		(cAlias)->NOME := TRB->NOME  
		(cAlias)->OCTEC := TRB->OCORR
		(cAlias)->TOTAL := TRB->TOTAL
		(cAlias)->(MsUnLock())
	EndIf
	
	dbSelectArea("TRB")
	TRB->(dbSkip())
End


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณClcIDTec    บAutor  ณJackson E. de Deusบ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula os indicadores do tecnico                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ClcIDTec()


Local cSql := ""
Local cTmp1 := ""
Local cTmp2 := ""
Local aMedia1 := {}
Local aMedia2 := {}


If nTrb1 == 0 .And. nTrb2 == 0
	Return
EndIf


ProcRegua(3)

                                           
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQUERY PERIODOณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
cSql := "SELECT ZG_NUMOS, UC_DATA, UC_INICIO, UC_DTENCER, AB1_EMISSA, "
cSql += " ZG_DTCRIAC, ZG_HRCRIAC, ZK_DTINI, ZK_HRINI, ZK_DTFIM, ZK_HRFIM "
cSql += "FROM " +RetSqlName("SZG") +" ZG WITH (NOLOCK) "

cSql += " INNER JOIN " +RetSqlName("SZK") + " SZK ON "
cSql += " ZK_NUMOS = ZG_NUMOS "
cSql += " AND SZK.D_E_L_E_T_ = '' "

cSql += " INNER JOIN " +RetSqlName("AB2") +" AB2 ON "
cSql += " AB2_XOSMOB = ZG_NUMOS " 
cSql += " AND AB2.D_E_L_E_T_ = '' "                               

cSql += "INNER JOIN " +RetSqlName("AB1") +" AB1 ON "
cSql += "AB1_NRCHAM = AB2_NRCHAM "
csql += " AND AB1.D_E_L_E_T_ = '' "

cSql += "INNER JOIN " +RetSqlName("AB9") +" AB9 ON "
cSql += "AB9_XOSMOB = AB2_XOSMOB "
cSql += " AND AB9.D_E_L_E_T_ = '' "

cSql += "INNER JOIN " +RetSqlName("SUC") + " SUC ON "  
cSql += "UC_CODIGO = AB1_NUMTMK "
cSql += "AND SUC.D_E_L_E_T_ = '' "

cSql += "WHERE "

cSql += " AB1_EMISSA BETWEEN '"+DTOS(Date()-30)+"' AND '"+DTOS(Date()-1)+"' "

cSql += "AND ZG_STATUS = 'FIOK' "
cSql += "AND ZG.D_E_L_E_T_ = '' "


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()      
                                 
	// tempo ate o inicio - TMK OS
	cTmp1 := IntToHora(SubtHoras(STOD(TRB->UC_DATA), TRB->UC_INICIO,STOD(TRB->ZK_DTFIM),TRB->ZK_HRFIM))
              
	// tempo ate o inicio - OS OS
	cTmp2 := IntToHora(SubtHoras(STOD(TRB->ZG_DTCRIAC), TRB->ZG_HRCRIAC,STOD(TRB->ZK_DTFIM),TRB->ZK_HRFIM))

	
	AADD( aMedia1, cTmp1 )
	AADD( aMedia2, cTmp2 )
	
	TRB->(dbSkip())
End

TRB->(dbCloseArea())


IncProc("")


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQUERY DATA ATUALณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
cSql := "SELECT ZG_NUMOS, UC_DATA, UC_INICIO, UC_DTENCER, AB1_EMISSA, "
cSql += " ZG_DTCRIAC, ZG_HRCRIAC, ZK_DTINI, ZK_HRINI, ZK_DTFIM, ZK_HRFIM "
cSql += "FROM " +RetSqlName("SZG") +" ZG WITH (NOLOCK) "

cSql += " INNER JOIN " +RetSqlName("SZK") + " SZK ON "
cSql += " ZK_NUMOS = ZG_NUMOS "
cSql += " AND SZK.D_E_L_E_T_ = '' "

cSql += " INNER JOIN " +RetSqlName("AB2") +" AB2 ON "
cSql += " AB2_XOSMOB = ZG_NUMOS " 
cSql += " AND AB2.D_E_L_E_T_ = '' "                               

cSql += "INNER JOIN " +RetSqlName("AB1") +" AB1 ON "
cSql += "AB1_NRCHAM = AB2_NRCHAM "
csql += " AND AB1.D_E_L_E_T_ = '' "

cSql += "INNER JOIN " +RetSqlName("AB9") +" AB9 ON "
cSql += "AB9_XOSMOB = AB2_XOSMOB "
cSql += " AND AB9.D_E_L_E_T_ = '' "

cSql += "INNER JOIN " +RetSqlName("SUC") + " SUC ON "  
cSql += "UC_CODIGO = AB1_NUMTMK "
cSql += "AND SUC.D_E_L_E_T_ = '' "

cSql += "WHERE "

cSql += " AB1_EMISSA = '"+DTOS(Date())+"' "

cSql += "AND ZG_STATUS = 'FIOK' "
cSql += "AND ZG.D_E_L_E_T_ = '' "


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()      
                                 
	// tempo ate o inicio - TMK OS
	cTmp1 := IntToHora(SubtHoras(STOD(TRB->UC_DATA), TRB->UC_INICIO,STOD(TRB->ZK_DTFIM),TRB->ZK_HRFIM))
              
	// tempo ate o inicio - OS OS
	cTmp2 := IntToHora(SubtHoras(STOD(TRB->ZG_DTCRIAC), TRB->ZG_HRCRIAC,STOD(TRB->ZK_DTFIM),TRB->ZK_HRFIM))

	
	AADD( aMedia1, cTmp1 )
	AADD( aMedia2, cTmp2 )
	
	TRB->(dbSkip())
End

TRB->(dbCloseArea())


IncProc("")

aSort( aMedia1,,,{ |x,y| x > y })
aSort( aMedia2,,,{ |x,y| x > y })


cInd1 := aMedia1[1]
cInd2 := aMedia2[1]
cInd3 := aMedia1[Len(aMedia1)]
cInd4 := aMedia2[Len(aMedia2)]

// media 1
nTempo := 0
For nI := 1 To Len(aMedia1)
	nTempo := Somahoras( nTempo,aMedia1[nI] )
Next nI

nMedia1 := nTempo/Len(aMedia1)

cInd5 := IntToHora(nMedia1)

// media 2
nTempo := 0
For nI := 1 To Len(aMedia2)
	nTempo := Somahoras( nTempo,aMedia2[nI] )
Next nI

nMedia2 := nTempo/Len(aMedia2)

cInd6 := IntToHora(nMedia2)


cInd1 := StrTran(cInd1,".",":")
cInd2 := StrTran(cInd2,".",":")
cInd3 := StrTran(cInd3,".",":")
cInd4 := StrTran(cInd4,".",":")
cInd5 := StrTran(cInd5,".",":")
cInd6 := StrTran(cInd6,".",":")

oInd1:Refresh()
oInd2:Refresh()
oInd3:Refresh()
oInd4:Refresh()
oInd5:Refresh()
oInd6:Refresh()

IncProc("")


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFilTec    บAutor  ณJackson E. de Deus  บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro dos atendimentos do tecnico                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FilTec(cCodTec,dDia,cOcorrTec)

Local aPergs	:= {} 
Local aRet		:= {}
Local dDia		:=	ctod('  /  /  ')

aAdd(aPergs ,{1,"T้cnico"			,space(6),"@!",".T.","AA1",".T.",10,.F.})	
aAdd(aPergs ,{1,"Data"				,dDia,"99/99/99","","","",0,.F.})
//aAdd(aPergs ,{1,"Ocorr๊ncia Tmk"	,space(6),"@!",".T.","SU9",".T.",10,.F.})	
aAdd(aPergs ,{1,"Ocorr๊ncia Chm"	,space(6),"@!",".T.","AAG",".T.",10,.F.})	


If !ParamBox(aPergs ,"Filtro",@aRet)
	Return
EndIf
 

cCodTec := aRet[1]
dDia := aRet[2]   
cOcorrTec := aRet[3]


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfdblclk3 บAutor  ณJackson E. de Deus   บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Duplo clique do TcBrowse 3                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fdblclk3(nLinha,nCol)

// ver patrimonios
If nCol == 7
	DetPatr(nLinha)
// ver chamados	
Else
	Detalhes(nLinha) 
EndIf

Return

                                   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณbHdClk3  บAutor  ณJackson E. de Deus   บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Clique no cabecalho da coluna do Tcbrowse 3                บฑฑ
ฑฑบ          ณ Altera a ordenacao dos valores                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function bHdClk3(nLinha,nCol,oList3)

Local lOrdenou := .F.

// chamados x maquinas
If nCol == 4
	aSort( aDados3,,,{ |x,y| x[8] > y[8] })	// ordena relacao qtd maq x chamados
	lOrdenou := .T.              

// Qtd Chamados x Qtd maquinas 2 - somente chamados com maquina
ElseIf nCol == 5
	aSort( aDados3,,,{ |x,y| x[11] > y[11] })	// ordena relacao qtd maq x chamados
	lOrdenou := .T. 

// qtd chamados
ElseIf nCol == 6
	aSort( aDados3,,,{ |x,y| x[7] > y[7] }) // qtd chamados
	lOrdenou := .T.
// qtd maquinas
ElseIf nCol == 7                                                                
	aSort( aDados3,,,{ |x,y| x[10] > y[10] }) // qtd maquinas
	lOrdenou := .T.
EndIf  


If lOrdenou
	oList3:aArray := aDados3
	oList3:Refresh()   
EndIf           


Return         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarga  บAutor  ณJackson E. de Deus     บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga inicial dos arrays dos TcBrowse                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carga()

CursorWait()

Processa( { || Carregar(1) },"Carregando os chamados de hoje, aguarde..")

CursorArrow()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrepTrab    บAutor  ณJackson E. de Deusบ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara as estruturas para areas de trabalho temporarias   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrepTrab()


// trb1
AADD( aStruTrb1,{"STATUS"		,"C",12,0})
AADD( aStruTrb1,{"UF"			,"C",2,0})
AADD( aStruTrb1,{"CHAMADO"		,"C",TamSx3("UC_CODIGO")[1],0})
AADD( aStruTrb1,{"DTINI"		,"D",8,0})
AADD( aStruTrb1,{"HRINI"		,"C",8,0})
AADD( aStruTrb1,{"CLIENTE"		,"C",TamSx3("A1_NOME")[1],0})
AADD( aStruTrb1,{"OCTMKD"		,"C",TamSx3("U9_DESC")[1],0})
AADD( aStruTrb1,{"OCTECD"		,"C",TamSx3("AAG_DESCRI")[1],0})  
AADD( aStruTrb1,{"RESP"			,"C",20,0})  
AADD( aStruTrb1,{"OSMOB"		,"C",TamSx3("ZG_NUMOS")[1],0})  
AADD( aStruTrb1,{"TECNICO"		,"C",TamSx3("AA1_NOMTEC")[1],0})  
AADD( aStruTrb1,{"DFIMOSM"		,"D",8,0})
AADD( aStruTrb1,{"HFIMOSM"		,"C",8,0})
AADD( aStruTrb1,{"STATOSM"		,"C",TamSx3("ZG_STATUSD")[1],0})  
AADD( aStruTrb1,{"PATRIM"		,"C",TamSx3("N1_CHAPA")[1],0})  
AADD( aStruTrb1,{"MODEL"		,"C",TamSx3("B1_DESC")[1],0})  
AADD( aStruTrb1,{"DPREVTMK"		,"D",8,0})
AADD( aStruTrb1,{"HPREVTMK"		,"C",8,0})
AADD( aStruTrb1,{"FILIAL"		,"C",2,0})
AADD( aStruTrb1,{"CODCLI"		,"C",6,0})
AADD( aStruTrb1,{"LOJA"			,"C",4,0}) 
AADD( aStruTrb1,{"CODTEC"		,"C",6,0}) 
AADD( aStruTrb1,{"OCTMK"		,"C",TamSx3("UD_OCORREN")[1],0})
AADD( aStruTrb1,{"OCTEC"		,"C",TamSx3("AB2_CODPRB")[1],0})  
AADD( aStruTrb1,{"RECUC"		,"N",15,0})
AADD( aStruTrb1,{"UCFIL"		,"C",2,0})
AADD( aStruTrb1,{"UCSTT"		,"C",1,0})
  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregar บAutor  ณJackson E. de Deus   บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga inicial dos arrays dos TcBrowse                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carregar(nTipo,cCodCli,cLoja,cUF)

Local nI
Local cQuery	:= ""
Local nCont		:= 0
Local cFilEst	:= ""
Local aUsr		:= {}  
Local cStatus	:= ""
Local cHrAtual	:= ""
Local nPos		:= 0
Local cResp		:= ""
Local nRel		:= 0
Local nTotMaq	:= 0
Local nProximo	:= 0
Local oStatus
Local aChamados	:= {}
Local aAux3		:= {}
Local nFim		:= 0
Local nMaqAB2	:= 0
Local cAlias	:= ""
Local aAtraso	:= {}

Default nTipo	:= 0
Default cCodCli	:= ""
Default cLoja	:= ""
Default cUF		:= ""

If nTipo == 0
	Return
EndIf
               
If Len(_aUsers) == 0
	fRetNome(1,@_aUsers)
EndIf

// principal/refresh
If nTipo == 1 .Or. nTipo == 4
	cAlias := "TRB1"
	
	If nTipo == 1
		If File("\system\" +_cArquivo +"." +OrdbagExt())
			MsErase("\system\" +_cArquivo +"." +OrdbagExt())
		EndIf
		
		If Select("TRB1") > 0
			TRB1->(dbCloseArea())
		EndIf
		
		_cArquivo := CriaTrab(aStruTrb1,.T.)
		_cIndice  := CriaTrab(Nil,.F.)
			
		
		dbUseArea(.T.,,_cArquivo,"TRB1",.F.,.F.)
		IndRegua("TRB1",_cIndice,"CHAMADO")
	EndIf
	
// maiores atrasos
ElseIf nTipo == 2
	cAlias := "TRB2"
	
	If File("\system\" +_cArquivo2 +"." +OrdbagExt())
		MsErase("\system\" +_cArquivo2 +"." +OrdbagExt())
	EndIf
	
	If Select("TRB2") > 0
		TRB2->(dbCloseArea())
	EndIf
	
	_cArquivo2 := CriaTrab(aStruTrb1,.T.)
	_cIndice2  := CriaTrab(Nil,.F.)
		
	
	dbUseArea(.T.,,_cArquivo2,"TRB2",.F.,.F.)
	IndRegua("TRB2",_cIndice2,"CHAMADO")

// detalhe	
ElseIf nTipo == 5
	cAlias := "TRB3"
	
	
	If File("\system\" +_cArquivo3 +"." +OrdbagExt())
		MsErase("\system\" +_cArquivo3 +"." +OrdbagExt())
	EndIf
	
	If Select("TRB3") > 0
		TRB3->(dbCloseArea())
	EndIf
	
	_cArquivo3 := CriaTrab(aStruTrb1,.T.)
	_cIndice3  := CriaTrab(Nil,.F.)
		
	
	dbUseArea(.T.,,_cArquivo3,"TRB3",.F.,.F.)
	IndRegua("TRB3",_cIndice3,"CHAMADO")
	
EndIf
  

// Carregamento -> Janela 1 | Janela 2 | Tela Detalhes chamados cliente/loja
If nTipo <> 3	// nTipo == 1 .Or. nTipo == 2 .Or. nTipo == 4 .Or. nTipo == 5
	cQuery := "SELECT DISTINCT UC_FILIAL, UC_CODIGO, UC_DATA, UC_INICIO, UC_STATUS, A1_NOME, A1_NREDUZ, A1_EST, UD_STATUS, UC_DTENCER, UC_PENDENT, UC_HRPEND, " +CRLF
//	cQuery += "( SELECT X5_DESCRI FROM SX5010 WHERE X5_TABELA = 'T1' AND X5_CHAVE = UD_ASSUNTO AND D_E_L_E_T_ = '' ) ASSUNTO, 
	cQuery += " A1_COD, A1_LOJA, " +CRLF
	cQuery += " UD_OCORREN, U9_DESC, SUC.R_E_C_N_O_ SUCREC, SUD.UD_OPERADO, AA1_CODTEC,AA1.AA1_NOMTEC, AB2.AB2_XOSMOB, SZG.ZG_DATAFIM, SZG.ZG_HORAFIM, " +CRLF
	cQuery += " SZG.ZG_STATUSD, AB2.AB2_NUMSER, SN1.N1_DESCRIC, AB2.AB2_CODPRB, AAG.AAG_DESCRI " +CRLF
	cQuery += "FROM " +RetSqlName("SUC") +" SUC " +CRLF
		                
	// Join Itens chamado                      	
	cQuery += "INNER JOIN " +RetSqlName("SUD") +" SUD ON " +CRLF
	cQuery += "SUD.UD_FILIAL = SUC.UC_FILIAL " +CRLF
	cQuery += "AND SUD.UD_CODIGO = SUC.UC_CODIGO " +CRLF
	cQuery += "AND SUD.D_E_L_E_T_ = SUC.D_E_L_E_T_ " +CRLF
	
	// Join Clientes
	cQuery += "INNER JOIN " +RetSqlName("SA1") +" SA1 ON " +CRLF
	cQuery += "SA1.A1_COD = SUBSTRING(SUC.UC_CHAVE,1,6) " +CRLF
	cQuery += "AND SA1.A1_LOJA = SUBSTRING(SUC.UC_CHAVE,7,4) " +CRLF
	
	// Join Chamados Tecnicos
	cQuery += "LEFT JOIN " +RetSqlName("AB1") +" AB1 ON " +CRLF
	cQuery += "AB1.AB1_FILIAL = SUC.UC_FILIAL " +CRLF
	cQuery += "AND AB1.AB1_NUMTMK = SUC.UC_CODIGO " +CRLF
	cQuery += "AND AB1.D_E_L_E_T_ = SUC.D_E_L_E_T_ " +CRLF
	     
	// Join Itens chamados tecnicos
	cQuery += "LEFT JOIN " +RetSqlName("AB2") +" AB2 ON " +CRLF
	cQuery += "AB2.AB2_FILIAL = AB1.AB1_FILIAL " +CRLF
	cQuery += "AND AB2.AB2_NRCHAM = AB1.AB1_NRCHAM " +CRLF
	cQuery += "AND AB2.D_E_L_E_T_ = AB1.D_E_L_E_T_ " +CRLF
	
	// Join Ocorrencias Chamado tecnico
	cQuery += "LEFT JOIN " +RetSqlName("AAG") +" AAG ON " +CRLF
	cQuery += "AAG.AAG_CODPRB = AB2.AB2_CODPRB "
	cQuery += "AND AAG.D_E_L_E_T_ = AB2.D_E_L_E_T_ "  
	     	
	// Join Patrimonios
	cQuery += "LEFT JOIN " +RetSqlName("SN1") +" SN1 ON " +CRLF
	cQuery += "SN1.N1_CHAPA = AB2.AB2_NUMSER " +CRLF
	cQuery += "AND SN1.D_E_L_E_T_ = AB2.D_E_L_E_T_ "   +CRLF 
	      
	// Join OS Mobile
	cQuery += "LEFT JOIN " +RetSqlName("SZG") +" SZG ON " +CRLF
	cQuery += "SZG.ZG_NUMOS = AB2.AB2_XOSMOB " +CRLF
	cQuery += "AND SZG.D_E_L_E_T_ = AB2.D_E_L_E_T_ " +CRLF
	     
  	// Join Tecnicos
	cQuery += "LEFT JOIN " +RetSqlName("AA1") +" AA1 ON " +CRLF
	cQuery += "AA1.AA1_CODTEC = SZG.ZG_CODTEC " +CRLF	//cQuery += "AA1.AA1_PAGER = SZG.ZG_AGENTE "
	cQuery += "AND AA1.D_E_L_E_T_ = SZG.D_E_L_E_T_ "		+CRLF 
	        
	// Join Ocorrencias
	cQuery += "INNER JOIN " +RetSqlName("SU9") +" SU9 ON " +CRLF
	cQuery += "SU9.U9_CODIGO = SUD.UD_OCORREN " +CRLF
	cQuery += "AND SU9.D_E_L_E_T_ = SUD.D_E_L_E_T_ " +CRLF
	
	cQuery += "WHERE " +CRLF
	cQuery += "SUC.D_E_L_E_T_ = '' " +CRLF
	cQuery += "AND SUD.UD_ASSUNTO <> '000007' " +CRLF
	cQuery += "AND SUC.UC_CODCANC = '' " +CRLF
		    
	// CONDICOES
	// todos abertos na data atual e em datas anteriores porem dentro do prazo
	If nTipo == 1
		cQuery += "AND SUC.UC_STATUS <> '3' "     +CRLF
		cQuery += "AND ( SUC.UC_DATA = '"+DTOS(DATE())+"' OR ( SUC.UC_DATA < '"+DTOS(DATE())+"' AND SUC.UC_PENDENT >= '"+DTOS(DATE())+"' ) )"	+CRLF
		cQuery += "ORDER BY SUC.R_E_C_N_O_ DESC "   +CRLF  
	
	// somente atrasados - calcular o atraso
	ElseIf nTipo == 2
		cQuery += "AND SUC.UC_DATA <= '"+DTOS(DATE())+"' " +CRLF
		cQuery += "AND SUC.UC_STATUS  <> '3' "   +CRLF  
		cQuery += "ORDER BY SUC.UC_DATA, SUC.UC_INICIO " +CRLF
	
	// se for refresh - considerar somente novos RECNOS
	ElseIf nTipo == 4
		cQuery += "AND SUC.UC_DATA = '"+DTOS(DATE())+"' " +CRLF
		cQuery += "AND SUD.UD_STATUS <> '3' "     +CRLF
		cQuery += "AND SUC.R_E_C_N_O_ > '"+cvaltochar(nLastRec)+"' " +CRLF
		cQuery += "ORDER BY SUC.R_E_C_N_O_ DESC " +CRLF
	
	// se for detalhes do agrupamento por cliente/loja - 2 meses atras ate hoje
	ElseIf nTipo == 5
		cQuery += "AND SUC.UC_CHAVE = '"+cCodCli+cLoja+"' "      +CRLF                                                
		cQuery += "AND SUC.UC_DATA BETWEEN '"+DtoS( Date()-60) +"' AND '"+DtoS(Date())+"' " +CRLF
		cQuery += "ORDER BY SUC.UC_DATA DESC, SUC.UC_INICIO DESC " +CRLF
	EndIf
	
	If Select("TRB") > 0
   		TRB->(dbCloseArea())
	EndIf                  

	TcQuery cQuery New Alias "TRB"
	
	aAux := {}
	
	dbSelectArea("TRB")
	dbGoTop()
	While !EOF()
		nCont++
		TRB->(dbSkip())
	End
	
	ProcRegua(nCont)
	TRB->(dbGoTop())
	While TRB->(!EOF())
		IncProc( "Chamado " +AllTrim(TRB->UC_CODIGO) )
		
		cFilEst := RetEstFil(TRB->UC_FILIAL)
		cHrMax := TRB->UC_HRPEND + ":00"
		     
		// Tratamento para Ignorar chamados conforme regras

		// Abertos na data de hoje e de antes porem ainda no prazo
		If nTipo == 1
			cHrAtual := Time()
			If ( STOD(TRB->UC_PENDENT) == Date() .And. cHrAtual > cHrMax )
				TRB->(dbSkip())
				Loop
			EndIf
								
		// Somente atrasados
		ElseIf nTipo == 2
			cHrAtual := Time()
					
			// dia de finalizacao for maior que hoje - desconsidera
			If STOD(TRB->UC_PENDENT) > Date()
				TRB->(dbSkip())
				Loop
			
			// dia de finalizacao igual a hoje porem nao estourou o horario ainda
			ElseIf STOD(TRB->UC_PENDENT) == Date() .And. cHrAtual < cHrMax
				TRB->(dbSkip())
				Loop
			EndIf
			
		// no Refresh desconsiderar os que ja estouraram o prazo final - esses registros devem ir somente para a janela dos atrasados
		ElseIf nTipo == 4
			If STOD(TRB->UC_PENDENT) == Date() .And. cHrAtual > cHrMax
				
				AADD(aAtraso, TRB->UC_CODIGO) 
				
				TRB->(dbSkip())
				Loop
			EndIf
		EndIf
		      
		// Tratamento para definir o status de acordo com janela da tela
		// carregamento inicial - janela 1 e refresh janela 1
		If nTipo == 1 .Or. nTipo == 4 
			oStatus := fStat( STOD(TRB->UC_PENDENT), cHrMax )
		
		// chamados atrasados - janela 2
		ElseIf nTipo == 2                                
			oStatus := oRoxo                 
     		      
		// chamados do cliente/loja - janela 3
		ElseIf nTipo == 5
			// pendentes
			If AllTrim(TRB->UC_STATUS) $ "1|2"
				//oStatus := oVerm
				oStatus := fStat( STOD(TRB->UC_PENDENT), cHrMax )                 
			// encerradas	
			ElseIf AllTrim(TRB->UC_STATUS) == "3"
				oStatus := oVerde
			EndIf        		      
		EndIf
		
		// alimenta array de estados para Filtro
		If AScan( aUFBR, { |x| SubStr(AllTrim(x),1,2) == AllTrim(TRB->A1_EST) } ) == 0 
			nPos := Ascan( aUFTodos, { |x| AllTrim( x[1] ) == AllTrim(TRB->A1_EST)  } ) 
			If nPos > 0
				AADD( aUFBR, AllTrim(TRB->A1_EST) + " - " +aUFTodos[nPos][2]  )
			EndIf		
		EndIf
		
	    /*
   		AADD( aAux, { cFilEst, TRB->UC_CODIGO, STOD(TRB->UC_DATA), TRB->A1_NREDUZ, TRB->UC_STATUS,;
	   				 STOD(TRB->UC_DTENCER), TRB->U9_DESC, TRB->SUCREC,;
	   				 TRB->A1_COD, TRB->A1_LOJA, TRB->UC_INICIO, TRB->UC_FILIAL, TRB->AA1_NOMTEC, TRB->AB2_XOSMOB,;
	   				 STOD(TRB->ZG_DATAFIM), TRB->ZG_HORAFIM, TRB->ZG_STATUSD, TRB->AB2_NUMSER, TRB->N1_DESCRIC,;
	   				 "", STOD(TRB->UC_PENDENT), TRB->UC_HRPEND, TRB->UD_OPERADO, TRB->AAG_DESCRI, TRB->A1_EST, oStatus  } )	
		*/
		
		// responsavel
		cResp := ""
		If !Empty(TRB->UD_OPERADO)
			nPos := Ascan( _aUsers, { |x|, AllTrim(x[1]) == AllTrim(TRB->UD_OPERADO) }  )
			If nPos > 0
				cResp := _aUsers[nPos][2]
			Else                               
				PswOrder(1)
				If PswSeek(TRB->UD_OPERADO)
					aUsrAux := PswRet(1)
					If Len(aUsrAux) > 0
						cResp := aUsrAux[1][4]							// atualiza o array
						fRetNome(2,Nil,TRB->UD_OPERADO,aUsrAux[1][4])	// atualiza o dbf
					EndIf
				EndIf
			EndIf
		EndIf	
		     
		If nTipo <> 4
			If Select(cAlias) > 0
				//(cAlias)->(dbCloseArea())
			EndIf        
		EndIf
	
		// grava tabela temporaria
		dbSelectArea(cAlias)
		If Reclock(cAlias,.T.)
			(cAlias)->STATUS	:= oStatus:cName
			(cAlias)->UF		:= TRB->A1_EST
			(cAlias)->CHAMADO	:= TRB->UC_CODIGO
			(cAlias)->DTINI		:= STOD(TRB->UC_DATA)
			(cAlias)->HRINI		:= TRB->UC_INICIO
			(cAlias)->CLIENTE	:= TRB->A1_NREDUZ
			(cAlias)->OCTMKD	:= TRB->U9_DESC
			(cAlias)->OCTECD	:= TRB->AAG_DESCRI
			(cAlias)->RESP		:= cResp
			(cAlias)->OSMOB		:= TRB->AB2_XOSMOB
			(cAlias)->TECNICO	:= TRB->AA1_NOMTEC
			(cAlias)->DFIMOSM	:= STOD(TRB->ZG_DATAFIM)
			(cAlias)->HFIMOSM	:= TRB->ZG_HORAFIM
			(cAlias)->STATOSM	:= TRB->ZG_STATUSD
			(cAlias)->PATRIM	:= TRB->AB2_NUMSER
			(cAlias)->MODEL		:= TRB->N1_DESCRIC
			(cAlias)->DPREVTMK	:= STOD(TRB->UC_PENDENT)
			(cAlias)->HPREVTMK	:= TRB->UC_HRPEND
			(cAlias)->FILIAL	:= cFilEst
			(cAlias)->CODCLI	:= TRB->A1_COD
			(cAlias)->LOJA		:= TRB->A1_LOJA
			(cAlias)->CODTEC	:= TRB->AA1_CODTEC
			(cAlias)->OCTMK		:= TRB->UD_OCORREN
			(cAlias)->OCTEC		:= TRB->AB2_CODPRB
			(cAlias)->RECUC		:= TRB->SUCREC
			(cAlias)->UCFIL		:= TRB->UC_FILIAL
			(cAlias)->UCSTT		:= TRB->UC_STATUS
		
				
			(cAlias)->(MsUnLock())
		EndIf	
			
		
		DbSelectArea("TRB")

		TRB->(dbSkip())
	End    

	
	If ( nTipo == 1 .Or. nTipo == 4 ) //.And. Len(aAux) > 0 
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		nLastRec := (cAlias)->RECUC
	EndIf

	
	// Tratamento atendimentos parciais (chamado call center x OS Mobile) -> SE STATUS FOR FINALIZADO E PARCIAL -> AMARELO C/ LARANJA ( ALTERAR )
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	While (cAlias)->(!EOF())
		If aScan( aChamados, { |x| AllTrim(x) == AllTrim((cAlias)->CHAMADO) } ) > 0
			(cAlias)->(dbSkip())
			Loop
		EndIf
		AADD( aChamados, (cAlias)->CHAMADO )
		(cAlias)->(dbSkip())
	End
		
	For nI := 1 To Len(aChamados)
		nFim := 0
		aAux3 := {}
		aExcluir := {}
		nPos := 0
		         
		(cAlias)->(dbGoTop())
		While (cAlias)->(!EOF())
			
			If (cAlias)->CHAMADO == aChamados[nI]
				AADD( aAux3, { (cAlias)->STATOSM } )
			EndIf
			
			(cAlias)->(dbSkip())
		End
		
		For nJ := 1 To Len(aAux3)
			If "FINALIZADO" $ AllTrim(UPPER(aAux3[nJ][1]))
				nFim++
			EndIf
		Next nJ
		
		// houve finalizacao - ACERTAR PARA RETIRAR O CHAMADO DA JANELA 1 QUANDO ELE FOR TOTALMENTE ATENDIDO
		If nFim > 0
			
			// finalizou todos do chamado - todos ficam verde
			If Len(aAux3) == nFim		
				(cAlias)->(dbGoTop())
				While (cAlias)->(!EOF())
					If (cAlias)->CHAMADO == aChamados[nI]
						If (cAlias)->UCSTT <> "3"
							
							// janela 1 - pendentes e tela de detalhes dos chamados - ultimos 2 meses
							If nTipo == 5 .Or. nTipo == 1 .Or. nTipo == 4							    
								RecLock(cAlias,.F.)
								(cAlias)->STATUS	:= oVerm:cName
								MsUnLock()
							
							// janela atrasados
							ElseIf nTipo == 2
								RecLock(cAlias,.F.)
								(cAlias)->STATUS	:= oRoxo:cName
								MsUnLock()                         
							EndIf
						Else	
							AADD( aExcluir, aChamados[nI] )
						EndIf	
					EndIf
					
					(cAlias)->(dbSkip())
				End
				                      
				If !Empty(aExcluir) .And. nTipo <> 5
					(cAlias)->(dbGoTop())
					For nJ := 1 To Len(aExcluir)
						While (cAlias)->(!EOF())
							If (cAlias)->CHAMADO == aExcluir[nJ]
								RecLock(cAlias,.F.)
								dbDelete()
								MsUnLock()  
							EndIf
							(cAlias)->(dbSkip())
						End
					Next nJ
				EndIf
				
		
			// finalizou parcial - todos ficam laranja
			Else
				(cAlias)->(dbGoTop())
				While (cAlias)->(!EOF())
					If (cAlias)->CHAMADO == aChamados[nI]
						RecLock(cAlias,.F.)
						(cAlias)->STATUS	:= oLaran:cName  
						MsUnLock()
					EndIf
					
					(cAlias)->(dbSkip())
				End
			EndIf	     
		EndIf	
	Next nI

	If nTipo == 5
		(cAlias)->( dbGoTop() )
		While !EOF()
			AADD( _aTmk2m, { Fst((cAlias)->STATUS),;
							(cAlias)->UF,;
							(cAlias)->CHAMADO,;
							(cAlias)->DTINI,;
							(cAlias)->HRINI,;
							(cAlias)->CLIENTE,;
							(cAlias)->OCTMKD,;
							(cAlias)->OCTECD,;
							(cAlias)->RESP,;
							(cAlias)->OSMOB,;
							(cAlias)->TECNICO,;
							(cAlias)->DFIMOSM,;
							(cAlias)->HFIMOSM,;
							(cAlias)->STATOSM,;
							(cAlias)->PATRIM,;
							(cAlias)->MODEL,;
							(cAlias)->DPREVTMK,;
							(cAlias)->HPREVTMK,;
							(cAlias)->FILIAL} )
			dbSkip()
		End
	EndIf
	    
	// no REFRESH -> excluir os atrasados
	If nTipo == 4
		(cAlias)->(dbGoTop())
		While (cAlias)->(!EOF())	     
			If ( Date() > (cAlias)->DPREVTMK ) .Or. ( Date() == (cAlias)->DPREVTMK .And. Time() > (cAlias)->HPREVTMK+":00"  )			
				RecLock(cAlias,.F.)
				dbDelete() 
				MsUnLock()
			EndIf			
			
			(cAlias)->(dbSkip())
		End  
	EndIf
	
	
// Carregamento -> Janela 3 - agrupamento de chamados por cliente
ElseIf nTipo == 3
	cQuery := "SELECT UC_FILIAL, A1_COD, A1_LOJA, A1_END, A1_MUN, A1_NREDUZ, A1_EST, COUNT(*) TOTAL "
	cQuery += "FROM " +RetSqlName("SUC") +" SUC "
	
	cQuery += "INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
	cQuery += "SA1.A1_COD = SUBSTRING(SUC.UC_CHAVE,1,6) "
	cQuery += "AND SA1.A1_LOJA = SUBSTRING(SUC.UC_CHAVE,7,4) "
	
	cQuery += "INNER JOIN " +RetSqlName("SUD") +" SUD ON "
	cQuery += "SUD.UD_FILIAL = SUC.UC_FILIAL "
	cQuery += "AND SUD.UD_CODIGO = SUC.UC_CODIGO "
	cQuery += "AND SUD.D_E_L_E_T_ = SUC.D_E_L_E_T_ "
		
	cQuery += "WHERE SUC.D_E_L_E_T_ = '' "
	cQuery += "AND SUD.UD_ASSUNTO <> '000007' "
	cQuery += "AND SUC.UC_CODCANC = '' "

	cQuery += "AND SUC.UC_DATA BETWEEN '"+DtoS( Date()-60 ) +"' AND '"+DtoS( Date() )+"' "
	cQuery += "GROUP BY UC_FILIAL, A1_COD, A1_LOJA, A1_END, A1_MUN, A1_NREDUZ, A1_EST "
	
	cQuery += "ORDER BY A1_EST, TOTAL DESC "
	
	If Select("TRB") > 0
   		TRB->(dbCloseArea())
	EndIf                  

	TcQuery cQuery New Alias "TRB"
	
	aAux := {}
	
	dbSelectArea("TRB")
	dbGoTop()	
	While !EOF()
		nCont++
		TRB->(dbSkip())
	End
	
	
	dbGoTop()
	While !EOF()
		IncProc(AllTrim(TRB->A1_NREDUZ))
		
		cFilEst := RetEstFil(TRB->UC_FILIAL)
		
		// alimenta array de estados para Filtro
		If AScan( aUFBR, { |x| SubStr(AllTrim(x),1,2) == AllTrim(TRB->A1_EST) } ) == 0 
			nPos := Ascan( aUFTodos, { |x| AllTrim( x[1] ) == AllTrim(TRB->A1_EST)  } ) 
			If nPos > 0
				AADD( aUFBR, AllTrim(TRB->A1_EST) + " - " +aUFTodos[nPos][2]  )
			EndIf		
		EndIf
			
	   	AADD(aAux, { cFilEst, TRB->A1_COD, TRB->A1_LOJA, TRB->A1_END, TRB->A1_MUN, SubStr(TRB->A1_NREDUZ,1,50), TRB->TOTAL, 0, TRB->A1_EST, 0, 0 } )     	
		TRB->(dbSkip())
	End
	   
	// busca patrimonios - Qtd Maq x Chamados ( Total Maquinas / Total Chamados )
	For nI := 1 To Len(aAux)
		nTotMaq := 0
		nMaqAB2 := 0
		nRel := 0
          
		// maquinas instaladas
		nTotMaq := fTotMaq(aAux[nI][2], aAux[nI][3])
		nRel := Round( aAux[nI][7] / nTotMaq, 1)
		aAux[nI][8] := nRel
		aAux[nI][10] := nTotMaq
		                      
		// maquinas nos chamados
		nMaqAB2 := fab2Maq(aAux[nI][2], aAux[nI][3])
		nRel := Round( aAux[nI][7] / nMaqAB2, 1)
		aAux[nI][11] := nRel
		
	Next nI

	aSort(aAux,,,{ |x,y| x[11] > y[11] })	// ordena relacao qtd maq x chamados
		
EndIf

TRB->(dbCloseArea())


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfStat บAutor  ณJackson E. de Deus      บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o status do registro                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fStat( dDtFim, cHoraFim )

Local cStatus := ""
Local oStatus              
Local cHora := ""
Local cDifHra := ""
Default cHoraFim := ""

If Empty(dDtFim) .Or. Empty(cHoraFim)
	Return oVazio
EndIf

// data de retorno menor que data atual
If dDtFim < Date()
	oStatus := oRoxo
// data de retorno igual data atual - calcula horas	
ElseIf dDtFim == Date()
	cHora := Time()
	If cHora > cHoraFim 
		cDifHra := ElapTime( cHoraFim, cHora )
	Else
		cDifHra := ElapTime( cHora, cHoraFim )
	EndIf
	
	// ate 5 horas antes do prazo == amarelo	
	If cDifHra <= "05:00:00"
		cStatus := "3"
		oStatus := oAmar
	// dentro do prazo == verde	
	Else
		oStatus := oVerm
	EndIf
// data de retorno maior que data atual
ElseIf dDtFim > Date()
	oStatus := oVerm
EndIf


Return oStatus


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFiltro บAutor  ณJackson E. de Deus     บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro da tela                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Filtro(cTab)

Local aPergs	:= {} 
Local aRet		:= {}
Local cUF		:= "" 
Local dDia		:=	ctod('  /  /  ')
Local cClient	:= ""
Local cLoja		:= ""
Local cCodTec	:= ""
Local cOcorrTmk := ""
Local cOcorrTec := ""


aAdd(aPergs ,{2,"Estado"			,"TODOS",aUFBR,100,"",.F.})	
aAdd(aPergs ,{1,"Cliente"			,space(6),"@!",".T.","SA1",".T.",10,.F.})	
aAdd(aPergs ,{1,"Loja"				,space(4),"@!",".T.","",".T.",10,.F.})	
aAdd(aPergs ,{1,"Data de Abertura"	,dDia,"99/99/99","","","",0,.F.})
aAdd(aPergs ,{1,"T้cnico"			,space(6),"@!",".T.","AA1",".T.",10,.F.})	
aAdd(aPergs ,{1,"Ocorr๊ncia Tmk"	,space(6),"@!",".T.","SU9",".T.",10,.F.})	
aAdd(aPergs ,{1,"Ocorr๊ncia Chm"	,space(6),"@!",".T.","AAG",".T.",10,.F.})	


If !ParamBox(aPergs ,"Filtro",@aRet)
	Return
EndIf
 
If AllTrim(UPPER(aRet[1])) <> "TODOS"
	cUF := SubStr( aRet[1],1,2 ) 
Else
	cUF := UPPER(aRet[1])
EndIf

cClient := aRet[2]
cLoja := aRet[3]
dDia := aRet[4]   
cCodTec := aRet[5]
cOcorrTmk := aRet[6]
cOcorrTec := aRet[7]


_cFiltro := ""

If AllTrim(cUF) <> "TODOS"
	_cFiltro := "UF == '"+cUF+"' "
EndIf
	
If !Empty(cClient)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro := " CODCLI == '"+cClient+"' "
EndIf
If !Empty(cLoja)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " LOJA == '"+cLoja+"' "
EndIf
If !Empty(dDia) 
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " DTINI == STOD('"+DTOS(dDia)+"') "
EndIf
If !Empty(cCodTec)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " CODTEC == '"+cCodTec+"' "
EndIf
If !Empty(cOcorrTmk)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " OCTMK == '"+cOcorrTmk+"' "
EndIf
If !Empty(cOcorrTec)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " OCTEC == '"+cOcorrTec+"' "
EndIf
  


Processa( { || Fil(cTab) },"Aplicando filtro, aguarde..")
//Processa( { || ExecFil(cTab,cUF,cClient,cLoja,dDia,cCodTec,cOcorrTmk,cOcorrTec) },"Aplicando filtro, aguarde..")


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecFil บAutor  ณJackson E. de Deus    บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa o filtro                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecFil(cTab,cUF,cClient,cLoja,dDia,cCodTec,cOcorrTmk,cOcorrTec)

_cFiltro := ""

If AllTrim(cUF) <> "TODOS"
	_cFiltro := "UF == '"+cUF+"' "
EndIf
	
If !Empty(cClient)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro := " CODCLI == '"+cClient+"' "
EndIf
If !Empty(cLoja)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " LOJA == '"+cLoja+"' "
EndIf
If !Empty(dDia) 
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " DTINI == '"+dDia+"' "
EndIf
If !Empty(cCodTec)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " CODTEC == '"+cCodTec+"' "
EndIf
If !Empty(cOcorrTmk)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " OCTMK == '"+cOcorrTmk+"' "
EndIf
If !Empty(cOcorrTec)
	If !Empty(_cFiltro)
		_cFiltro += " .AND. "	
	EndIf
	_cFiltro += " OCTEC == '"+cOcorrTec+"' "
EndIf

   
Fil(cTab)
	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFil    บAutor  ณJackson E. de Deus     บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra a tabela                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fil(cTab)


dbSelectArea(cTab) 
	

If !Empty(_cFiltro)
	DbSetFilter({ || &_cFiltro},_cFiltro )
	DbGoTop()
Else
	DbClearFilter()
EndIf

If cTab == "TRB1"
	If ValType(oList1) == "O"
		oList1:Refresh(.T.)  
	EndIf
ElseIf cTab == "TRB2"
	If ValType(oList2) == "O"
		oList2:Refresh(.T.)  
	EndIf
EndIf 


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotMaq บAutor  ณJackson E. de Deus    บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna patrimonios                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTotMaq(cCodCli, cLoja, lDetalhe, aPatr)

Local aArea := GetArea()                                       
Local cQuery := ""
Local nTot := 0
Local aAuxPatr := {}    
Local nI          
Local nJ
Local nTotChm := 0 
 
Default lDetalhe := .F. 
Default aPatr := {}

cQuery := " SELECT N1_CHAPA, N1_DESCRIC, N1_XLOCINS FROM " +RetSqlName("SN1") + " SN1 "
cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
cQuery += " SN1.N1_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND SB1.B1_XSECAO = '026' "
cQuery += " WHERE SN1.D_E_L_E_T_ = '' AND N1_XCLIENT = '"+cCodCli+"' AND N1_XLOJA = '"+cLoja+"' AND N1_XSTATTT IN ('3','6') "

If Select("TRBN1") > 0
	TRBN1->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRBN1"

dbSelectArea("TRBN1")
While !EOF()
	AADD( aAuxPatr, { TRBN1->N1_CHAPA, TRBN1->N1_DESCRIC, TRBN1->N1_XLOCINS, Nil, 0  }  )
	dbSkip()
End

If lDetalhe
	// busca data de instalacao
	For nI := 1 To Len(aAuxPatr)
		aAuxPatr[nI][4] := ChkDtInst(aAuxPatr[nI][1],cCodCli, cLoja)
	Next nI
	
	// carrega os chamados para obter o total de chamados por patrimonio
	Carregar(5,cCodCli,cLoja)                                           
	dbSelectArea("TRB3")


	For nI := 1 To Len(aAuxPatr)
		cNumChapa := aAuxPatr[nI][1]
		nTotChm := 0
		
		TRB3->(dbGoTop())
		While !EOF()
			If AllTrim(TRB3->PATRIM) == AllTrim(cNumChapa)
				nTotChm++
			EndIf
			dbSkip()
		End

		aAuxPatr[nI][5] := nTotChm
	Next nI

	
	aPatr := AClone(aAuxPatr)
EndIf


nTot := Len(aAuxPatr)

RestArea(aArea)

Return nTot


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkDtInst บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica data de instalacao do patrimonio                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkDtInst( cNumChapa,cCodCli, cLoja)
 
Local cQuery := ""
Local dData := STOD("")
Local aAxDt := {}

cQuery := "SELECT * FROM " +RetSqlName("SZD") 
cQuery += " WHERE D_E_L_E_T_ = '' AND ZD_DATAREM = '' AND ZD_IDSTATU = '1' "
cQuery += " AND ZD_CLIENTE = '"+cCodCli+"' AND ZD_LOJA = '"+cLoja+"' AND ZD_PATRIMO = '"+cNumChapa+"' "
cQuery += "ORDER BY ZD_DATAINS DESC "

If Select("TRBZ") > 0
	TRBZ->(dbcloseArea())
EndIf                   

TcQuery cQuery New Alias "TRBZ"

dbSelectArea("TRBZ")
While !EOF()
	AADD( aAxDt, TRBZ->ZD_DATAINS )
	dbSkip()
End                              

If Len(aAxDt) > 0
	dData := STOD(aAxDt[1])
EndIf

Return dData


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRefresh   บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizacao da tela                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Refresh()
             

CursorWait()

// carrega somente os novos registros dos chamados de hoje
Processa( { || Carregar(4,Nil,Nil) },"Verificando novos chamados, aguarde..")

//Processa( { || CalcInd() }, "Calculando indicadores, aguarde.." )

CursorArrow()


oList1:Refresh()
oList1:GoTop()    
                    
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisual    บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza o chamado - call center e chamado tecnico        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Visual(nRecno,cCodFil,nOpcao)

Local cBkpFil := cFilAnt
Local aArea := GetArea()
Default nRecno := 0
Default cCodfil := ""
Default nOpcao := 0

If nRecno == 0 .Or. Empty(cCodFil) .Or. nOpcao == 0
	Return
EndIf

If AllTrim(cCodFil) <> AllTrim(cFilAnt)
	cFilAnt := cCodFil
EndIf

dbSelectArea("SUC")
dbGoTo(nRecno)

If FindFunction("U_TTTMKA30")
	U_TTTMKA30( cCodFil,SUC->UC_CODIGO, nOpcao )
EndIf                           

cFilAnt := cBkpFil

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetalhes  บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra os chamados do periodo para o cliente/loja          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Detalhes(nLinha3)

Local aArea			:= GetArea()
Local aSize			:= MsAdvSize(Nil,.F.)
Local nTamanho		:= 0.75                                              
Local oWnd
Local oLayer		:= FwLayer():New()
Local oPnl  
Local cCodCli		:= AllTrim(aDados3[nLinha3][2])
Local cLoja			:= AllTrim(aDados3[nLinha3][3])
Local aLista		:= {}
Local oList
Local aPatr			:= {}
Private _aTmk2m		:= {}
Private oFont := TFont():New('Courier new',,-18,.T.)
Private cCadastro := AllTrim(aDados3[nLinha3][6])
                                
// carrega os chamados do cliente
Processa( { || Carregar(5,cCodCli,cLoja) },"Verificando chamados, aguarde..")
dbSelectArea("TRB3")
TRB3->(dbGoTop()) 

If Empty(_aTmk2m)
	MsgInfo("NaO hA dAd0S")
	Return
EndIf

/*
While !EOF()
	AADD( _aTmk2m, { Fst(TRB3->STATUS),;
					TRB3->UF,;
					TRB3->CHAMADO,;
					TRB3->DTINI,;
					TRB3->HRINI,;
					TRB3->CLIENTE,;
					TRB3->OCTMKD,;
					TRB3->OCTECD,;
					TRB3->RESP,;
					TRB3->OSMOB,;
					TRB3->TECNICO,;
					TRB3->DFIMOSM,;
					TRB3->HFIMOSM,;
					TRB3->STATOSM,;
					TRB3->PATRIM,;
					TRB3->MODEL,;
					TRB3->DPREVTMK,;
					TRB3->HPREVTMK,;
					TRB3->FILIAL} )
	dbSkip()
End
*/
aSize[1] := aSize[1] * nTamanho
aSize[2] := aSize[2] * nTamanho
aSize[3] := aSize[3] * nTamanho
aSize[4] := aSize[4] * nTamanho
aSize[5] := aSize[5] * nTamanho
aSize[6] := aSize[6] * nTamanho
aSize[7] := aSize[7] * nTamanho
 
oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],cCadastro,,,.F.,/*nOr(WS_VISIBLE,WS_POPUP)*/,CLR_WHITE,,,,.T.,,,.T. )	

	oLayer:Init(oWnd,.F.)
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1",cCadastro,100,.F.,.T.,{||} )	
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()
    
    // Menu popup
	MENU oMnu POPUP
		MENUITEM "Visualizar chamado Call Center" ACTION ( Visual(TRB3->RECUC,TRB3->UCFIL,1 ) )
		MENUITEM "Visualizar chamado T้cnico" ACTION ( Visual(TRB3->RECUC,TRB3->UCFIL,2 ) )
	ENDMENU
     
    // chamados
	/*oList := TCBrowse():New(0,0,0,0,,,,oPnl,,,,,{||},,,,,,,.F.,'TRB3',.T.,,.F.,,.T.,.F.)
    
	oList:AddColumn(TCColumn():New(''								,{|| Fst(TRB3->STATUS)  },"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Estado'							,{|| TRB3->UF },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList:AddColumn(TCColumn():New('Chamado'						,{|| TRB3->CHAMADO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList:AddColumn(TCColumn():New('Data inicio'					,{|| TRB3->DTINI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList:AddColumn(TCColumn():New('Hora inicio'					,{|| TRB3->HRINI },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Cliente'						,{|| TRB3->CLIENTE },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Ocorr๊ncia Call Center'			,{|| TRB3->OCTMKD },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Ocorr๊ncia Chamado T้cnico'		,{|| TRB3->OCTECD },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Responsแvel'					,{|| TRB3->RESP },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('OS Mobile'						,{|| TRB3->OSMOB },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('T้cnico'						,{|| TRB3->TECNICO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Data'							,{|| TRB3->DFIMOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Hora'							,{|| TRB3->HFIMOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          
	oList:AddColumn(TCColumn():New('Status OS'						,{|| TRB3->STATOSM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          
	oList:AddColumn(TCColumn():New('Patrim๔nio'						,{|| TRB3->PATRIM },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList:AddColumn(TCColumn():New('Modelo'							,{|| TRB3->MODEL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList:AddColumn(TCColumn():New('Data prevista'					,{|| TRB3->DPREVTMK },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList:AddColumn(TCColumn():New('Hora prevista'					,{|| TRB3->HPREVTMK },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          		
	oList:AddColumn(TCColumn():New('Filial'							,{|| TRB3->FILIAL },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          		
	*/
	oList := TCBrowse():New(0,0,0,0,,;
	{"","Estado","Chamado","Data inicio","Hora inicio","Cliente","Ocorrencia Call Center","Ocorrencia Chamado Tecnico",;
	"Responsavel","OS Mobile","Tecnico","Data","Hora","Status OS","Patrimonio","Modelo","Data prevista","Hora prevista","Filial"},;
	{5,20,30,30,25,60,65,90,80,65,80,30,20,20,30,35,70,30,30},oPnl,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.)
	
	oList:SetArray(_aTmk2m)
	oList:bLine := { ||{ _aTmk2m[oList:nAt,01],;
						 _aTmk2m[oList:nAt,02],;
						 _aTmk2m[oList:nAt,03],;		
						 DtoC(_aTmk2m[oList:nAt,04]),;
						 _aTmk2m[oList:nAt,05],;
					 	 _aTmk2m[oList:nAt,06],;	
 	 	 				_aTmk2m[oList:nAt,07],;	
 	 	 	 			_aTmk2m[oList:nAt,08],;	
 	 	 	 	 		_aTmk2m[oList:nAt,09],;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,10],;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,11],;	
 	 	 	 	 	 	DTOC(_aTmk2m[oList:nAt,12]),;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,13],;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,14],;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,15],;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,16],;	
 	 	 	 	 	 	DTOC(_aTmk2m[oList:nAt,17]),;	
 	 	 	 	 	 	_aTmk2m[oList:nAt,18],;
 	 	 	 	 	 	_aTmk2m[oList:nAt,19]  }}	

	oList:bRClicked := { |oObject,nX,nY| oMnu:Activate( nX, (nY-10), oObject ) }
	oList:Align := CONTROL_ALIGN_ALLCLIENT
              	    
oWnd:Activate(,,,.T.)


RestArea(aArea) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetPatr   บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra os patrimonios instalados no cliente                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DetPatr(nLinha3)

Local aSize			:= MsAdvSize(Nil,.F.)
Local nTamanho		:= 0.7                                              
Local oWnd
Local oLayer		:= FwLayer():New()  
Local cCodCli		:= AllTrim(aDados3[nLinha3][2])
Local cLoja			:= AllTrim(aDados3[nLinha3][3])
Local aLista		:= {}
Local oList1
Local aPatr			:= {}
Local aCabecPtr		:= {"Patrim๔nio","Modelo","Local fํsico","Data de instala็ใo","Qtd chamados"}
Local aColunPtr		:= {5,5,5,5,5}
Private cCadastro := AllTrim(aDados3[nLinha3][6])
                                
// carrega os patrimonios do cliente
Processa( { || fTotMaq(cCodCli, cLoja, .T., @aPatr) },"Verificando patrim๔nios, aguarde..")

If Len(aPatr) == 0
	Aviso("","Nใo hแ registro de patrim๔nio nesse cliente/loja",{"Ok"})
	Return
EndIf
             
aLista := aClone(aPatr)

aSize[1] := aSize[1] * nTamanho
aSize[2] := aSize[2] * nTamanho
aSize[3] := aSize[3] * nTamanho
aSize[4] := aSize[4] * nTamanho
aSize[5] := aSize[5] * nTamanho
aSize[6] := aSize[6] * nTamanho
aSize[7] := aSize[7] * nTamanho
 
oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],cCadastro,,,.F.,/*nOr(WS_VISIBLE,WS_POPUP)*/,CLR_WHITE,,,,.T.,,,.T. )	

	oLayer:Init(oWnd,.F.)
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Patrim๔nios instalados",100,.F.,.T.,{||} )	
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()
      
    // Patrimonios
    oList := TCBrowse():New(0,0,0,0,,aCabecPtr,aColunPtr,oPnl,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.)
	oList:SetArray(aLista)
	oList:bLine := { ||{ aLista[oList:nAt,01],;	 		// Patrimonio
						 aLista[oList:nAt,02],;				// Modelo
						 aLista[oList:nAt,03],;				// Local fํsico
						 DtoC(aLista[oList:nAt,04]),;		// Data instalacao
						 aLista[oList:nAt,05] }}			// Qtd chamados
				
	oList:Align := CONTROL_ALIGN_ALLCLIENT
              	    
oWnd:Activate(,,,.T.) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetEstFil บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o estado da filial do sistema.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetEstFil(cCodFil)


Local cFilEst := ""

If AllTrim(cCodFil) == "01"
	cFilEst := "SP"
ElseIf AllTrim(cCodFil) == "02"
	cFilEst := "SP"
ElseIf AllTrim(cCodFil) == "03"
	cFilEst := "SP"
ElseIf AllTrim(cCodFil) == "04"
	cFilEst := "RJ"
ElseIf AllTrim(cCodFil) == "05"
	cFilEst := "BA"
ElseIf AllTrim(cCodFil) == "06"
	cFilEst := "PE"
ElseIf AllTrim(cCodFil) == "07"
	cFilEst := "CE"
ElseIf AllTrim(cCodFil) == "08"
	cFilEst := "MG"
ElseIf AllTrim(cCodFil) == "09"
	cFilEst := "SP"
ElseIf AllTrim(cCodFil) == "10"
	cFilEst := "DF"
ElseIf AllTrim(cCodFil) == "11"
	cFilEst := "PR"
ElseIf AllTrim(cCodFil) == "12"
	cFilEst := "SP"
ElseIf AllTrim(cCodFil) == "13"
	cFilEst := "SP"
ElseIf AllTrim(cCodFil) == "15"
	cFilEst := "MT"
ElseIf AllTrim(cCodFil) == "16"
	cFilEst := "RS"
EndIf
			
				
Return cFilEst


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetNome  บAutor  ณJackson E. de Deus  บ Data ณ  18/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria/atualiza o dbf com ID/Nome dos usuarios               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetNome(nTipo,aUsr,cIdUsr,cNomeUsr)

Local cDbfUsr := 'USRIDNOME'
Local aStruct := {}
Local aUsers := {}
Local nI

AADD( aStruct,{"ID"		,"C",06,0} )
AADD( aStruct,{"NOME"	,"C",30,0} )
             
// Busca de dados
If nTipo == 1

	If !File("\system\" +cDbfUsr +".dtc")
		//MsCreate( cDbfUsr, aStruct, "DBFCDXADS" )
		MsCreate( cDbfUsr, aStruct, "CTREECDX" )
	EndIf
	//CTREECDX
	//dbUseArea( .T., "DBFCDXADS", cDbfUsr, "TRBC", .F. ,.F. )
	dbUseArea( .T., "CTREECDX", cDbfUsr, "TRBC", .F. ,.F. )
	dbSelectArea("TRBC")
	If EOF()
		aUsers := AllUsers()
		For nI := 1 To Len(aUsers)
			RecLock("TRBC",.T.)
			TRBC->ID := aUsers[nI][1][1]
			TRBC->NOME := aUsers[nI][1][4]
			MsUnLock()
		Next nI
	EndIf
	
	dbGoTop()
	While !EOF()
		AADD( aUsr, { TRBC->ID, TRBC->NOME } )
		dbSkip()
	End
	
	TRBC->( dbCloseArea() )   
	          
// Atualizacao	
ElseIf nTipo == 2	  
	//CTREECDX	
	//dbUseArea( .T., "DBFCDXADS", cDbfUsr, "TRBC", .F. ,.F. )
	dbUseArea( .T., "CTREECDX", cDbfUsr, "TRBC", .F. ,.F. )
	dbSelectArea("TRBC")
	RecLock("TRBC",.T.)
	TRBC->ID := cIdUsr
	TRBC->NOME := cNomeUsr
	TRBC->( MsUnLock() )		
	
	TRBC->( dbCloseArea() )   	
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEstados    บAutor  ณJackson E. de Deusบ Data ณ  22/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os estados brasileiros                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fEstados()

Local aUF := {}

dbSelectArea("SX5")
dbSetOrder(1)
If dbSeek( xFilial("SX5") +AvKey("12","X5_TABELA") )
	While SX5->X5_TABELA == "12" .And. !EOF()
		AADD( aUF, { AllTrim(SX5->X5_CHAVE), AllTrim(SX5->X5_DESCRI) } )
		dbSkip()
	End
EndIf         

Return aUF

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfab2Maq    บAutor  ณJackson E. de Deus บ Data ณ  25/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Total de maquinas em chamados para o cliente/loja no       บฑฑ
ฑฑบ          ณ periodo.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fab2Maq(cCodCli,cLoja)

Local cQuery := ""
Local aMaq := {}
Local nTotal := 0


cQuery := "SELECT AB2_NUMSER FROM " +RetSqlName("AB2") +" AB2 " +CRLF
cQuery += "INNER JOIN " +RetSqlName("AB1") +" AB1 ON " +CRLF
cQuery += "AB1.AB1_FILIAL = AB2.AB2_FILIAL AND AB1.AB1_NRCHAM = AB2.AB2_NRCHAM AND AB1.D_E_L_E_T_ = '' " +CRLF
cQuery += "WHERE " +CRLF
cQuery += " AB2.D_E_L_E_T_ = '' AND AB1.AB1_NUMTMK <> '' AND AB1.AB1_CODCLI = '"+cCodCli+"' " +CRLF
cQuery += " AND AB1.AB1_LOJA = '"+cLoja+"' AND AB1.AB1_EMISSA BETWEEN '"+DtoS( Date()-60) +"' AND '"+DtoS(Date())+"' " +CRLF

If Select("TRBM") > 0
	TRBM->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRBM"

dbSelectArea("TRBM")
dbGoTop()
While !EOF()      
	If Ascan( aMaq, { |x| x == TRBM->AB2_NUMSER } ) == 0  
		AADD( aMaq, TRBM->AB2_NUMSER )                  
	EndIf
	TRBM->(dbSkip())
End

TRBM->(dbCloseArea())

nTotal := Len(aMaq)

Return nTotal



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTMON2    บAutor  ณMicrosiga           บ Data ณ  09/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcInd()

Local aArea := GetArea()
Local nTotHist := 0
Local nTot	:= 0
Local nTot1	:= 0
Local nTot2	:= 0          
Local aChm	:= {}
Local aAux	:= {}
Local nParc	:= 0
Local nTotPrazo		:= 0
Local nTotAtraso	:= 0


ProcRegua(4)


dbSelectArea("TRB1")
dbGoTop()
While !EOF()
	If Ascan( aChm, { |x| x[1] == TRB1->CHAMADO } ) == 0
		AADD( aChm, { TRB1->CHAMADO } )
		nTot1++
	EndIf
	dbSkip()
End


IncProc("")
   

If Select("TRB2") == 0
	Carregar(2)
EndIf          

dbSelectArea("TRB2")
dbGoTop()
While !EOF()
	If Ascan( aChm, { |x| x[1] == TRB2->CHAMADO } ) == 0
		AADD( aChm, { TRB2->CHAMADO } )
		nTot2++
	EndIf
	dbSkip()
End 


IncProc("")

// total programado           
nTot := nTot1+nTot2
     
// parcialmente atendido
nParc1 := Parc("TRB1")
nParc2 := Parc("TRB2")             

nParc := nParc1+nParc2


IncProc("")


// historico 30 dias
Hist30(@nTotHist,@nTotPrazo,@nTotAtraso)


IncProc("")
	                               

// indicadores
_aTotais[1] := nTotHist
_aTotais[2] := nTotPrazo
_aTotais[3] := nTotAtraso
_aTotais[4] := nTot1
_aTotais[5] := nTot2
_aTotais[6] := nTot
_aTotais[7] := nParc


cQtd1 := cvaltochar(_aTotais[1])
oSLgQ1:Refresh()

cQtd2 := cvaltochar(_aTotais[2])
oSLgQ2:Refresh()

cQtd3 := cvaltochar(_aTotais[3])
oSLgQ3:Refresh()

cQtd4 := cvaltochar(_aTotais[4])
oSLgQ4:Refresh()

cQtd5 := cvaltochar(_aTotais[5])
oSLgQ5:Refresh()

cQtd6 := cvaltochar(_aTotais[6])
oSLgQ6:Refresh()


cQtd7 := cvaltochar(_aTotais[7])
oSLgQ7:Refresh()


// percentual
cQtdP2 := cvaltochar( Round((nTotPrazo/nTotHist) * 100,2) ) +"%" 
oSQP2:Refresh()

cQtdP3 := cvaltochar( Round((nTotAtraso/nTotHist) * 100,2) ) +"%"
oSQP3:Refresh()

cQtdP4 := cvaltochar( Round((nTot1/nTot) * 100,2) ) +"%"
oSQP4:Refresh()

cQtdP5 := cvaltochar( Round((nTot2/nTot) * 100,2) ) +"%" 
oSQP5:Refresh()

//cQtdP6 := cvaltochar( Round((nTotAtraso/nTotHist) * 100,2) )  
cQtdP7 := cvaltochar( Round((nParc/nTot) * 100,2) ) +"%" 
oSQP7:Refresh()


IncProc("")


RestArea(aArea)
         
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTMON2    บAutor  ณMicrosiga           บ Data ณ  09/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Parc(cAlias)

Local nParc := 0
Local nI,nJ
Local nFim := 0
Local aaux3 := {}
Local aExcluir := {}
Local aChamados := {}
 


dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While (cAlias)->(!EOF())
	If aScan( aChamados, { |x| AllTrim(x) == AllTrim((cAlias)->CHAMADO) } ) > 0
		(cAlias)->(dbSkip())
		Loop
	EndIf
	AADD( aChamados, (cAlias)->CHAMADO )
	(cAlias)->(dbSkip())
End


For nI := 1 To Len(aChamados)
	nFim := 0
	aAux3 := {}
	         
	(cAlias)->(dbGoTop())
	While (cAlias)->(!EOF())
		
		If (cAlias)->CHAMADO == aChamados[nI]
			AADD( aAux3, { (cAlias)->STATOSM } )
		EndIf
		
		(cAlias)->(dbSkip())
	End
	
	For nJ := 1 To Len(aAux3)
		If "FINALIZADO" $ AllTrim(UPPER(aAux3[nJ][1]))
			nFim++
		EndIf
	Next nJ
	
	If nFim > 0
		If Len(aAux3) <> nFim
			nParc++
		EndIf	     
	EndIf	
Next nI


Return nParc


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHist30    บAutor  ณJackson E. de Deus  บ Data ณ  09/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Historico dos 30 dias                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Hist30(nTotHist,nTotPrazo,nTotAtraso) 

Local cQuery := ""      
                      

cQuery := "SELECT UC_CODIGO, UC_DATA, UC_INICIO, UC_DTENCER, UC_PENDENT, UC_HRPEND, UC_CODENCE "
cQuery += "FROM " +RetSqlName("SUC") +" SUC "

cQuery += "INNER JOIN " +RetSqlName("SUD") +" SUD ON "
cQuery += "SUD.UD_FILIAL = SUC.UC_FILIAL "
cQuery += "AND SUD.UD_CODIGO = SUC.UC_CODIGO "
cQuery += "AND SUD.D_E_L_E_T_ = SUC.D_E_L_E_T_ "
	
cQuery += "WHERE SUC.D_E_L_E_T_ = '' "
cQuery += "AND SUD.UD_ASSUNTO <> '000007' "
cQuery += "AND SUC.UC_CODCANC = '' "

cQuery += "AND SUC.UC_DATA BETWEEN '"+DtoS( Date()-30 ) +"' AND '"+DtoS( Date()-1 )+"' "
cQuery += "AND UC_STATUS = '3' "	// finalizados


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	nTotHist++
	
	If ( TRB->UC_DTENCER > TRB->UC_PENDENT ) .Or. ( TRB->UC_CODENCE == "000002"  )
		nTotAtraso++
	EndIf
	
	If TRB->UC_DTENCER <= TRB->UC_PENDENT .And. TRB->UC_CODENCE == "000001"
		nTotPrazo++
	EndIf
			
	dbSkip()
End
                 

Return