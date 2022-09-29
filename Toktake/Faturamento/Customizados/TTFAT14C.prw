#include "topconn.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT14C   บAutor  ณJackson E. de Deusบ Data  ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Painel retorno entregas                                    บฑฑ
ฑฑบ          ณ Controle de Entregas                                       บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ06/04/15ณ01.00 |Criacao                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TTFAT14C()
           
Local oDlg  
Local aSize := MsAdvSize()
Local nWdtRdp := aSize[5]/2
Local nTam := 0.7
Local nI 
Local nOpc := 0
Local oFont := TFont():New('Arial',,-12,.T.,.T.) 
Private cUsrs := SuperGetMV("MV_XLOG004",.T.,"JDEUS")
Private oList
Private aHead := { "Nota","S้rie","Cliente","Loja","Cliente/PA","OS Entrega","Entregue","OS Conf.","Conferido","Conferente","Data entrega","Hora","Nome","Rg","Km","Status confer๊ncia","Devolu็ใo","Status dev." }
Private aTam := {50,20,40,30,120,40,50,40,50,100,40,25,90,70,50,70,40,80}
Private oBlck := LoadBitMap( GetResources(), "BR_PRETO" )
Private oBranco := LoadBitMap( GetResources(), "BR_BRANCO" )
Private oVerde := LoadBitMap( GetResources(), "BR_VERDE" )
Private oVerm := LoadBitMap( GetResources(), "BR_VERMELHO" )
Private oOk := LoadBitMap( GetResources(), "OK" )
Private oX := LoadBitMap( GetResources(), "CANCEL" )
Private cRoman := Space( TamSx3("F2_XCARGA")[1] )
Private aDados := {}
Private cMotorista := ""
Private _cMot := ""
Private cVeiculo := ""
Private cCadastro := ""


If !cUserName $ cUsrs
	MsgAlert("Usuแrio nใo tem permissใo para acessar a rotina.","TTFAT14C")
	Return
EndIf

AADD( aDados, { oBlck,oBlck,"", "", "", "","", STOD(""), "", "","","","","","","","","",oBlck,oBlck,0,stod(""),0,"" } )


oDlg := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Romaneio",,,.F.,,,,,,.T.,,,.T. )	
	
	// painel central
	oPanel := tPanel():New(0,0,"",oDlg,,,,,,0,0)
	oPanel:align := CONTROL_ALIGN_ALLCLIENT
	
	// painel rodape	
	oPanel2 := TPanel():New(0,0,"",oDlg,,,,,,0,40) 
	oPanel2:SetCss( "QLabel { background-color: #E1E1E1; }" )	
	oPanel2:Align := CONTROL_ALIGN_BOTTOM
	
	// Menu popup
	MENU oMenu POPUP
	MENUITEM "Visualizar NF"					ACTION ( VisNF(oList:nAt) )
	//MENUITEM "Relat๓rio de diverg๊ncias"		ACTION ( Processa( { || RelDiver(oList:nAt)  },"Aguarde..")  )	// fora de uso 14/03/2016
	MENUITEM "Gerar NF de devolu็ใo" 			ACTION ( Processa( { || NFDev(oList:nAt) },"Aguarde..")  )			
	MENUITEM "Visualizar NF de devolu็ใo"		ACTION ( VisNF(oList:nAt,.T.) )
	//MENUITEM "Emitir autoriza็ใo de desconto"	ACTION ( Processa( { || AutDscto(oList:nAt)  },"Aguarde..")  )	// fora de uso 14/03/2016
	MENUITEM "Gerar OS confer๊ncia cega"		ACTION ( Processa( { || OSCnf(oList:nAt)  },"Aguarde..")  )	// fora de uso 14/03/2016
	ENDMENU
		
	// grid
	oList := TCBrowse():New(0,0,0,0,,aHead,aTam,oPanel,,,,{ || /*fHelp(oList:nAt)*/ },{ || },,,,,,,.F.,,.T.,,.F.,,.T.,.T.,)
	oList:Align	:= CONTROL_ALIGN_ALLCLIENT						 
	oList:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oList:nScrollType := 0 //SCROLL VRC
	oList:bHeaderClick := { || Cabec(oList:nColPos) }
	oList:SetArray(aDados) 
	oList:bLine := { || { aDados[oList:nAt,03],;					// nota
						aDados[oList:nAt,04],;						// serie
						aDados[oList:nAt,05],;						// cliente
						aDados[oList:nAt,06],;						// loja
						aDados[oList:nAt,07],;						// nome
						aDados[oList:nAt,17],;	   					// os entrega
						aDados[oList:nAt,01],;	   					// entregue
						aDados[oList:nAt,18],;	   					// os conf
						aDados[oList:nAt,02],;						// conf cega
						aDados[oList:nAt,24],;	   					// conferente escolhido
						aDados[oList:nAt,08],;						// data entrega
						aDados[oList:nAt,09],;						// hora
						aDados[oList:nAt,14],;						// nome
						aDados[oList:nAt,15],;						// rg
						aDados[oList:nAt,16],;						// km 
						aDados[oList:nAt,19],;						// divergencia na qtd entregue ?
						aDados[oList:nAt,13],;						// gerou devolucao ?
						aDados[oList:nAt,20] }}						// status devolucao
						
	oList:Disable()
	
	// componentes rodape
	oRom := TGet():New( 5,5,{|u| If(PCount()>0,cRoman:=u,cRoman) },oPanel2,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{ || },.F.,.F.,"","",,,,,,,"Romaneio",2,oFont)	
 	oRom:SetCss("QLineEdit { border: 1px solid gray; border-radius: 3px; color: #5C5C99; font: 14px; }")
    
    oBtPesq := TButton():New( 5,80,"Pesquisar",oPanel2,{|| Processa( { || RetDados() },"Verificando notas, aguarde..") },50,14,,,,.T.,,"",,,,.F. )
    oBtPesq:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:lupa.png); background-repeat: none; margin: 1px }" )			
    
    /*
    If cUserName $ cUsrs
		oBtCnc := TButton():New( 5,205,"Cancelar OS",oPanel2,{|| Processa( { || CancelaOS(cRoman) },"Cancelando, aguarde..") },60,14,,,,.T.,,"",,,,.F. )
    	oBtCnc:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:cancel.png); background-repeat: none; margin: 1px }" )			
	EndIf*/    

	oMot := TSay():New( 20,5,{ || cMotorista },oPanel2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,010)
	oVeic := TSay():New( 30,5,{ || cVeiculo },oPanel2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
		
  	//oBtOk := TButton():New( 05, nWdtRdp-120,"Fechar romaneio",oPanel2,{ || Processa( { || CursorWait(),Fechar(),CursorArrow() },"Fechando romaneio, aguarde..") },070,015,,,,.T.,,"",,,,.F. )
	//oBtOk:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:ok.png); background-repeat: none; margin: 1px }" )			
   	
   	oBtSair := TButton():New( 05, nWdtRdp-50,"Sair",oPanel2,{ || oDlg:End() },050,015,,,,.T.,,"",,,,.F. )
	oBtSair:SetCss( "QPushButton{ background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:final.png); background-repeat: none; margin: 1px }" )			
	
	oDlg:bStart := { || oList:nHeight -= 10 }	// diminui a altura do tcbrowse
	
oDlg:Activate(,,,.T.,,,)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisNF	     บAutor  ณJackson E. de Deusบ Data  ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualizacao de NF                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisNF(nLinha,lDev)


Local cNumNF := oList:aArray[nLinha][3] 
Local cSerie := oList:aArray[nLinha][4]
Local cCliente := oList:aArray[nLinha][5]
Local cLoja := oList:aArray[nLinha][6]
Local nRecF1 := oList:aArray[nLinha][21]
Local aArea := GetArea()
Default lDev := .F.

If ! _lNfSaida
	MsgInfo("Op็ใo disponํvel somente para romaneio de entregas.")
	Return
EndIf

// saida
If !lDev
	dbSelectArea("SF2")
	dbsetOrder(2)
	If dbSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
		Mc090Visual("SF2",Recno(),2)
	EndIf
// devolucao
Else 
	dbSelectArea("SF1")
	dbSetOrder(1)
	SF1->( dbGoTo(nRecF1) )
	If SF1->( Recno() ) == nRecF1
		dbSelectArea("SD1")
		dbSetOrder(1)                     
		If dbSeek( xFilial("SD1") +AvKey(SF1->F1_DOC,"D1_DOC") +AvKey(SF1->F1_SERIE,"D1_SERIE") +AvKey(SF1->F1_FORNECE,"D1_FORNECE") +AvKey(SF1->F1_LOJA,"D1_LOJA")  )
			A103NFiscal('SF1',SF1->( Recno() ),1)
		EndIf
	EndIf
EndIf

RestArea(aArea)
	
Return
                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabec	     บAutor  ณJackson E. de Deusบ Data  ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda no clique do cabecalho                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec(nCol)
              
// entrega
If nCol == 7
	BrwLegenda(cCadastro,"Entrega da mercadoria",{{"BR_BRANCO","OS em aberto"},;
													{"BR_VERDE","Entregue"},;
					                               {"BR_VERMELHO","Nใo entregue"},;
					                               {"BR_PRETO","OS Cancelada"  } })   
// conferencia
ElseIf nCol == 9
	BrwLegenda(cCadastro,"Confer๊ncia de mercadoria",{{"BR_BRANCO","OS em aberto"},;
													{"BR_VERDE","Confer๊ncia efetuada"},;
					                               {"BR_VERMELHO","Confer๊ncia nใo efetuada"},;
					                               {"BR_PRETO","OS Cancelada" } })   
// qtd divergente?         
ElseIf nCol == 16
	BrwLegenda(cCadastro,"Confer๊ncia",{{"BR_BRANCO","Confer๊ncia nใo efetuada"},;
										{"BR_VERDE","Qtd Ok"},;
										{"BR_VERMELHO","Qtd Divergente"} })   
// status nf devolucao
ElseIf nCol == 18
	BrwLegenda(cCadastro,"Devolu็ใo",{{"BR_BRANCO","Sem devolu็ใo"},;
									{"BR_VERDE","Classificado"},;
									{"BR_VERMELHO","Pr้-Nota"} })   
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDados  บAutor  ณJackson E. de Deus  บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os dados do romaneio digitado                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetDados()

Local cSql := ""
Local cNomecli := ""
Local nTotReg := 0
Local lEntregue := .F.
Local lConfCega := .F.
Local cAssin := ""
Local cDevoluc := ""
Local cNome := ""
Local cRG := ""
Local cKM := ""
Local cDiver := ""
Local cOsEntr := ""
Local cOsConf := ""
Local cStatEntr := ""
Local cStatCnfC := ""
Local oStatQtd := Nil 
Local oEntr := Nil
Local oCnfCg := Nil  
Local oStatDev := Nil
Local cCnfrnte := ""
Local aBkp := AClone(aDados)
Local nRecDev := 0

If Empty(cRoman)
	MsgAlert("Digite um n๚mero de romaneio!")
	Return
EndIf

CursorWait()

// romaneio de saida
If _lNfSaida 
	cSql := "SELECT DISTINCT F2_DOC AS DOC, F2_SERIE AS SERIE, F2_XCODPA AS CODPA, F2_XNFABAS AS ABAST, F2_XFINAL AS FINAL, SF2.R_E_C_N_O_ REC, "
	cSql += " F2_CLIENTE AS CLIFOR, F2_LOJA AS LOJA, F2_XRECENT AS RECIBO,F2_XRECASS AS ASSINADO, F2_XDTENTR AS DTENTCOL,F2_XHRENTR AS HRENTR, "
	cSql += " A1_NOME AS NOME, F2_XMOTOR AS XMOTOR, F2_XPLACA AS PLACA, F2_EMISSAO AS EMISSAO"
	cSql += ", F2_XDEVENT AS DEVENT, F2_XENTNOM AS XENTNOM, F2_XENTRG AS XENTR, F2_XENTKM AS ENTKM, F2_XCONF AS XCONF "
	cSql += ", F1_DOC, F1_STATUS, F1_DTDIGIT, SF1.R_E_C_N_O_ F1REC "
	cSql += " FROM " +RetSqlName("SF2") +" SF2 "
	
	cSql += " LEFT JOIN " +RetSqlName("SD1") +" SD1 ON "
	cSql += " SD1.D1_FILIAL = SF2.F2_FILIAL "
	cSql += " AND SD1.D1_NFORI = SF2.F2_DOC "
	cSql += " AND SD1.D1_SERIORI = SF2.F2_SERIE "
	cSql += " AND SD1.D_E_L_E_T_ = '' "
	
	cSql += "LEFT JOIN " +RetSqlName("SF1") +" SF1 ON "
	cSql += "SF1.F1_FILIAL = SD1.D1_FILIAL "
	cSql += "AND SF1.F1_DOC = SD1.D1_DOC "
	cSql += "AND SF1.F1_SERIE = SD1.D1_SERIE "
	cSql += "AND SF1.F1_FORNECE = SD1.D1_FORNECE "
	cSql += "AND SF1.F1_LOJA = SD1.D1_LOJA "
	cSql += "AND SF1.F1_TIPO = 'D' "
	
	cSql += " INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
	cSql += " SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = '' "
	cSql += " WHERE SF2.F2_XCARGA = '"+cRoman+"' AND SF2.D_E_L_E_T_ = '' "
	cSql += " ORDER BY F2_XENTKM " 
// romaneio de devolucao
Else      
	cSql := "SELECT F1_DOC AS DOC, F1_SERIE AS SERIE, '' AS CODPA, '' AS ABAST, '' AS FINAL, SF1.R_E_C_N_O_  REC, "
	cSql += " F1_FORNECE AS CLIFOR, F1_LOJA AS LOJA, F1_XRECENT AS RECIBO,'' AS ASSINADO, '' AS DTENTCOL,'' AS HRENTR, "
	cSql += " A2_NOME AS NOME, F1_XMOTOR AS XMOTOR, F1_XPLACA AS PLACA, F1_EMISSAO AS EMISSAO "
	cSql += ", '' AS DEVENT, '' AS XENTNOM, '' AS XENTR, '' AS ENTKM, '' AS XCONF "
	cSql += " FROM " +RetSqlName("SF1") +" SF1 "
	
	cSql += " INNER JOIN " +RetSqlName("SA2") +" SA2 ON "
	cSql += " SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.D_E_L_E_T_ = '' "
	cSql += " WHERE SF1.F1_XCARGA = '"+cRoman+"' AND SF1.D_E_L_E_T_ = '' "
	cSql += " ORDER BY F1_DOC " 
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	nTotReg++
	dbSkip()
End         

If nTotReg > 0
	aDados := {}
EndIf                  

ProcRegua(nTotReg)
dbGoTop()
While !EOF()
	IncProc("NF: " +AllTrim(TRB->DOC) +"/" +AllTrim(TRB->SERIE))
	nRecDev := 0
	lConfCega := .F.
	cOsEntr := ""
	cOsConf := ""
	cStatEntr := ""
	cStatCnfC := ""
	cCnfrnte := ""
	oEntr := oBlck		//Nil
	oCnfCg := oBlck		//Nil
	oStatQtd := oBlck	//Nil
	cAssin := "Nใo"
	cNome := TRB->XENTNOM
	cRG := TRB->XENTR
	cKM := TRB->ENTKM
	cMotor := AllTrim(TRB->XMOTOR)
	_cMot := SubStr(cMotor,1,6)
	cPLaca := Alltrim(TRB->PLACA)
	cMotorista := cMotor
	cVeiculo := cPlaca +AllTrim( Posicione("DA3",1,xFilial("DA3") +AvKey(cPlaca,"DA3_COD"), "DA3_DESC") )

	If !Empty(TRB->CODPA) .And. AllTrim(TRB->ABAST) == "1" .And. AllTrim(TRB->FINAL) == "4"
		cNomecli := AllTrim( Posicione("ZZ1",1,xFilial("ZZ1") +AvKey(CODPA,"ZZ1_COD"),"ZZ1_DESCRI" ) )
	Else
		cNomecli := TRB->NOME
	EndIf
		
	If !Empty(TRB->ASSINADO)
		cAssin := "Sim"
	EndIf
	
	cDevoluc := TRB->DEVENT
	If cDevoluc == "1"
		cDevoluc := "Total"
	ElseIf cDevoluc == "2"
		cDevoluc := "Parcial"
	EndIf
	
	cDiver := TRB->XCONF
	If Empty(cDiver)
		oStatQtd := oBranco
	ElseIf cDiver == "1"
		oStatQtd := oVerde
	ElseIf cDiver == "2"
		oStatQtd := oVerm
	EndIf	
	
	RetOS(TRB->DOC,TRB->SERIE,@cOsEntr,@cOsConf,@cStatEntr,@cStatCnfC, @cCnfrnte,_lNfSaida )
	
	// verifica status OS
	If cStatEntr $ "DESP|ACTE|AGEN|TACM|INIC"
		oEntr := oBranco                     
	ElseIf cStatEntr $ "FIOK"
		// verifica se ja entregou
		If !Empty(TRB->RECIBO)
			oEntr := oVerde
		Else
			oEntr := oVerm
		EndIf
	EndIf
	
	// verifica status OS Conf Cega
	If cStatCnfC $ "DESP|ACTE|AGEN|TACM|INIC"
		oCnfCg := oBranco
	ElseIf cStatCnfC $ "FIOK"	
		// verifica divergencia na conferencia
		If !Empty(cDiver)
			oCnfCg := oVerde
		Else
			oCnfCg := oVerm
		EndIf
	EndIf
	
	// verifica cancelamento
	If cStatEntr $ "COPE|CCLI|CTEC"
		oEntr := oBlck
	EndIf
	
	// verifica cancelamento
	If cStatCnfC $ "COPE|CCLI|CTEC"
		oCnfCg := oBlck
	EndIf
	
	// verifica status NF devolucao
	If _lNfSaida
		nRecDev := TRB->F1REC
		If Empty(TRB->F1_DOC)
			oStatDev := oBranco 
		Else
			If Empty(TRB->F1_STATUS)
				oStatDev := oVerm
			Else 
				oStatDev := oVerde
			EndIf
		EndIf
	EndIf
			

	AADD( aDados, {oEntr, oCnfCg, TRB->DOC, TRB->SERIE, TRB->CLIFOR,TRB->LOJA,;
					cNomecli, DTOC(STOD(TRB->DTENTCOL)), TRB->HRENTR, cAssin, cMotor, cPlaca, cDevoluc,;
					cNome, cRG, CVALTOCHAR(cKM), cOsEntr,cOsConf, oStatQtd, oStatDev, nRecDev, STOD(TRB->EMISSAO), TRB->REC, cCnfrnte } )
	TRB->(dbSkip())
	
End
dbCloseArea()


If Len(aDados) == 0
	MsgInfo("Nใo hแ notas para esse romaneio")
Else
	oMot:SetText(cMotorista)
	oVeic:SetText(cVeiculo)
	oMot:Refresh()
	oVeic:Refresh()
	
	oList:SetArray(aDados)
	oList:bLine := { || { aDados[oList:nAt,03],;					// nota
						aDados[oList:nAt,04],;						// serie
						aDados[oList:nAt,05],;						// cliente
						aDados[oList:nAt,06],;						// loja
						aDados[oList:nAt,07],;						// nome
						aDados[oList:nAt,17],;	   					// os entrega
						aDados[oList:nAt,01],;	   					// entregue
						aDados[oList:nAt,18],;	   					// os conf
						aDados[oList:nAt,02],;						// conf cega
						aDados[oList:nAt,24],;	   					// conferente escolhido
						aDados[oList:nAt,08],;						// data entrega
						aDados[oList:nAt,09],;						// hora
						aDados[oList:nAt,14],;						// nome
						aDados[oList:nAt,15],;						// rg
						aDados[oList:nAt,16],;						// km 
						aDados[oList:nAt,19],;						// divergencia na qtd entregue ?
						aDados[oList:nAt,13],;						// gerou devolucao ?
						aDados[oList:nAt,20] }}						// status devolucao
	oList:Enable()
	oList:Refresh()
EndIf
		                
CursorArrow()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetOS	    บAutor  ณJackson E. de Deus  บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna as OS geradas para a NF                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetOS(cNumNF,cSerieNF,cOsEntr,cOsConf,cStatEntr,cStatCnfC,cCnfrnte,lSaida )

Local cSql := ""
Local aArea := GetArea()
Local dData := stod("")
Local cHora := ""
Local cEntregue := ""
Local cNome := ""
Local cRG := ""
Local nKM := 0
Local cConfs := ""
Local cCnfEsc := ""
Local aCnf := {}
Local nI 
Default lSaida := .T.

cSql := "SELECT ZG_NUMOS, ZG_TPFORM, ZG_STATUS FROM " +RetSqlName("SZG")
cSql += " WHERE ZG_TPFORM IN ('1','13') AND ZG_DOC = '"+cNumNF+"' AND ZG_SERIE = '"+cSerieNF+"' "

cSql += " AND D_E_L_E_T_ = '' "

If lSaida
	cSql += " AND ZG_TPDOC = '2' "
Else 
	cSql += " AND ZG_TPDOC = '1' "
EndIf

If Select("TSZG") > 0
	TSZG->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TSZG"
dbSelectArea("TSZG")
While TSZG->( !EOF() )
	If AllTrim(cvaltochar(TSZG->ZG_TPFORM)) == "1"
		cOsConf := TSZG->ZG_NUMOS
		cStatCnfC := AllTrim(TSZG->ZG_STATUS)
	ElseIf AllTrim(cvaltochar(TSZG->ZG_TPFORM)) == "13"
		cOsEntr := TSZG->ZG_NUMOS
		cStatEntr := AllTrim(TSZG->ZG_STATUS)
		
		If cStatEntr == "FIOK"
			StaticCall( TTPROC29, InfoEntr,,cOsEntr,@dData,@cHora,@cEntregue,@cNome,@cRG,@nKM,@cConfs,@cCnfEsc)		
			If !Empty(cConfs) .And. !Empty(cCnfEsc)
				aCnf := StrToKarr(cConfs,"#")
				For nI := 1 To Len(aCnf)
					If SubStr(aCnf[nI],1,1) == cCnfEsc
						cCnfrnte := AllTrim(SubStr( aCnf[nI],3 ))
						Exit
					EndIf
				Next nI				
			EndIf
		EndIf
	EndIf
	dbSelectArea("TSZG")	
	TSZG->(dbSkip())
End

RestArea(aArea)
         
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechar  บAutor  ณJackson E. de Deus    บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fecha o romaneio                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fechar()

Local aArea := GetArea()
Local cCliExec := SuperGetMV("MV_XLOG007",.T.,"")	// clientes PA excecoes - sem conferencia cega - ja movimenta estoque para PA conforme processo anterior
Local cFilEntr := SuperGetMV("MV_XLOG008",.T.,"")	// filiais com controle de entrega at
Local lMovPA := .F.
Local nI

If Empty(aDados)
	Return
EndIf
          
// valida romaneio completo
If !MsgNoYes("Confirma o fechamento do romaneio?")
	Return
EndIf

/*
NAO UTILIZAR
AS NOTAS DEVEM SER BAIXADAS VIA OS MOBILE
*/

ProcRegua(Len(aDados))
dbSelectArea("SF2")
For nI := 1 To Len(aDados)
	dbSelectArea("SF2")
	nRecno := aDados[nI][23]
	dbGoTo(nRecno)
	IncProc("NF: " +ALLTRIM(SF2->F2_DOC) +"/" +ALLTRIM(SF2->F2_SERIE))
	If Recno() == nRecno
		If !Empty( SF2->F2_XCODPA ) .And. SubStr( SF2->F2_XCODPA,1,1 ) == "P"
			lMovPa := .T.
		EndIf	
		If Empty(SF2->F2_XRECENT) .Or. lMovPa
			If Empty(SF2->F2_XRECENT) 
				U_TTFAT15C( Recno(),dDatabase,Time(),"S","S")
				U_TTGENC01( xFilial("SF2"),"ENTREGA","ROMANEIO","",SF2->F2_DOC,SF2->F2_SERIE,cUserName,dtos(date()),time(),,"FECHAMENTO ROMANEIO NF - BAIXA CANHOTO: "+SF2->F2_DOC+"/"+SF2->F2_SERIE,,,"SF2" )	   
			EndIf
			If lMovPa .And. cUserName $ "JDEUS#ADMIN" 
				If cFilAnt $ cFilEntr
					dbSelectArea("ZZ1")
					dbSetOrder(1)
					If dbSeek( xFilial("ZZ1") +AvKey( SF2->F2_XCODPA,"ZZ1_COD" ) )
						cCliPA := SubStr( ZZ1->ZZ1_ITCONT,1,6 )
						If .Not. cCliPA $ cCliExec
							U_TTFAT18C( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA, SF2->F2_FILIAL )
							U_TTGENC01( xFilial("SF2"),"ENTREGA","ROMANEIO","",SF2->F2_DOC,SF2->F2_SERIE,cUserName,dtos(date()),time(),,"FECHAMENTO ROMANEIO NF - MOVIMENTACAO PA: "+SF2->F2_DOC+"/"+SF2->F2_SERIE,,,"SF2" )	   
						EndIf
					EndIf
				EndIf
			EndIf		
		EndIf
	EndIf
Next nI     
                        
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFDev  บAutor  ณJackson E. de Deus     บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera NF de devolucao                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NFDev(nLinha)

Local cNumNF := oList:aArray[nLinha][3] 
Local cSerie := oList:aArray[nLinha][4]
Local cCliFor := oList:aArray[nLinha][5]
Local cLj := oList:aArray[nLinha][6]
Local oStatEntr := oList:aArray[nLinha][1]
Local oStatQtd := oList:aArray[nLinha][19]
Local cNumOSCnf := oList:aArray[nLinha][18]
Local lOk := .F.   
Local aDados := {} 
Local cMsgErro := ""
Local axItens := {}
Local lEntregaOk := .F. 
Local lParcial := .F.
Local nRecnoSf1 := 0

If ! _lNfSaida
	MsgInfo("Op็ใo disponํvel somente para romaneio de entregas.")
	Return
EndIf
     
// verifica se ja existe devolucao
If !Empty(oList:aArray[nLinha][13]) .Or. oList:aArray[nLinha][20]:cName <> "BR_BRANCO"
	MsgAlert("Devolu็ใo jแ efetuada!") 
	Return
EndIf

If !MsgNoYes("Confirma a gera็ใo de nota de devolu็ใo ?")
	Return
EndIf	

procregua(2)

// entrega ok via OS de entrega
If oStatEntr:cName == "BR_VERDE"
	lEntregaOk := .T.           
EndIf

If !Empty(cNumNF) .And. !Empty(cSerie) .And. !Empty(cCliFor) .And. !Empty(cLj)
	cTxtAux := "Total"
	
	IncProc("")
	// divergencia na qtd
    If oStatQtd:cName == "BR_VERMELHO"
    	cTxtAux := "Parcial"
	    // se conf cega efetuada e qtd divergente                               
		dbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek( xFilial("SZG") +AvKey(cNumOSCnf,"ZG_NUMOS") )
			// OS finalizada
			If AllTrim(SZG->ZG_STATUS) == "FIOK"
				If !Empty(SZG->ZG_RESPOST)      
					lConferido := .T.
					
					//aDados := U_WSKPF005( SZG->ZG_RESPOST,@cMsgErro )
					aDados := U_MXML000( SZG->ZG_RESPOST )
					For nI := 1 To Len( aDados )
						If aDados[nI][1] == "CONFERENCIA"
							aConf := Aclone( aDados[nI] )
							Exit
						EndIf
					Next nI
																
					If !Empty(aDados)
						axItens := U_TTPROC40(cNumNf,cSerie,cClifor,cLj,aConf)	// itens
						If Len(axItens) > 0
							lParcial := .T.
						EndIf
					EndIf
				EndIf                                        
			// OS cancelada
			ElseIf AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC|CCLI"
				//
			EndIf	
		EndIf                      
	EndIf
	

	IncProc("")
	// devolucao
	If !lEntregaOk .Or. ( lEntregaOk .And. lParcial )
		If FindFunction("U_TTCOMC16")
			nRecnoSf1 := U_TTCOMC16( cNumNF,cSerie,cCliFor,cLj,axItens )
			If !Empty(nRecnoSf1)
				dbSelectArea("SF1")
				dbGoTo(nRecnoSf1)
				If Recno() == nRecnoSf1
					MsgInfo("A Nota Fiscal de devolu็ใo foi criada com sucesso: " +SF1->F1_DOC +"/" +SF1->F1_SERIE)
				
					// atualiza coluna nf devolucao
					oList:aArray[nLinha][13] := cTxtAux
					oList:aArray[nLinha][20] := oVerm
					oList:Refresh()
					
					If !lEntregaOk .And. !lParcial
						CncOSCnf( cNumOSCnf )												// cancela conferencia cega
						CnfEntr( SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA )	// gera conferencia cega retorno nota
					EndIf
				EndIf		
			EndIf
		EndIf	
	EndIf     
EndIf	

Return

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCncOSCnf  บAutor  ณJackson E. de Deus  บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela OS de Conferencia Cega                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CncOSCnf(cNumOSCnf)

Local nTpCanc := 1 // tipo cancelamento - central|agente
Local aArea := GetArea()
Local nCnt := 0

dbSelectArea("SZG")
dbSetOrder(1)
If dbSeek( xFilial("SZG") +AvKey(cNumOSCnf,"ZG_NUMOS") ) 
	nCnt := StaticCall( TTPROC30, ProcCanc,cNumOSCnf,cNumOSCnf,"","Z",SZG->ZG_DATAINI,SZG->ZG_DATAINI,nTpCanc )
	If nCnt > 0
		oList:aArray[oList:nAt][2] := oBlck
		oList:Refresh()
		MsgInfo("A Ordem de Servi็o de confer๊ncia de mercadoria no destino foi cancelada.")
	EndIf
EndIf


RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCnfEntr  บAutor  ณJackson E. de Deus   บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera conferencia cega de entrada - devolucao NF            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CnfEntr(cNumNF,cSerie,cClifor,cLj,nAgente)

Local aArea			:= GetArea()
Local aDoc			:= {}
Local cNumOSConf	:= ""  
Local cTecnico		:= AllTrim(GetMV("MV_XTECCOM"))//"212411"	// GIL - Altera็ใo realizada por Ronaldo Gomes (21/03/2018)
Local cNomeAtend	:= Posicione( "AA1",1,xFilial("AA1") +AvKey(cTecnico,"AA1_CODTEC"),"AA1_NOMTEC" )
Local cDescCf		:= AllTrim( Posicione( "SA2",1,xFilial("SA2")+AvKey(cClifor,"A2_COD") +AvKey(cLj,"A2_LOJA"),"A2_NOME" ) )
Local cEndereco		:= ""
Local cTime			:= inttoHora(SomaHoras(Time(),"00:30:00")) +":00"
Local cTpDoc		:= "1"	// nota de entrada
Local cMsgOS		:= ""
Default nAgente		:= SuperGetMV("MV_XWSK019",.T.,"")	// agente da logistica


aDadosOS := { "01",;
				"CONFERENCIA CEGA",;
				AllTrim(cTecnico),;
				AllTrim(cNomeAtend),;
				"",;
				"",;
				"",;
				"",;
				dDatabase,;
				cTime,;
				cDescCf,;
				"TOK TAKE - EXPEDIวรO",;
				""/*contato*/,;
				cMsgOS,;
				"",;
				"EXPEDIวรO",;
				AllTrim(cNumNF),;
				AllTrim(cSerie),;
				cTpDoc,;
				cClifor,;
				cLj} 
				
				
//MsProcTxt("Salvando confer๊ncia cega no Mobile..") 
cNumOSConf := U_MOBILE(aDadosOS)

//aDoc := {cNumNf,cSerie,1}
//cNumOSConf := U_WSKPF009( 1,cCliFor,cLj,aDoc,Val(nAgente) )
If !Empty(cNumOSConf)
	If Val(cNumOSConf) > 0
		// grava flag na nota de entrada
		dbSelectArea("SF1")
		dbSetOrder(1)
		If dbSeek( xFilial("SF1") +AvKey(cNumNF,"F1_DOC") + AvKey(cSerie,"F1_SERIE") +AvKey(cCliFor,"F1_FORNECE") +AvKey(cLj,"F1_LOJA") )	
			If RecLock("SF1",.F.)
			    SF1->F1_XWSOSF := "S"
			    SF1->F1_XWSOSR := cNumOSConf
				SF1->(MsUnLock())
			EndIf
		EndIf	
		
		//If FwIsInCallStack("U_TTFAT14C")
			MsgInfo("Foi gerada a confer๊ncia cega do retorno da mercadoria: " +cNumOSConf)
		//EndIf
		U_TTGENC01( xFilial("SZG"),"ENTREGA","OS ENTREGA","",cNumNF,cSerie,"WS",dtos(date()),time(),,"DEVOLUCAO - OS de conferencia cega gerada: " +cNumOSConf,,,"SZG" )	
	EndIf
EndIf

RestArea(aArea)     

Return cNumOSConf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAutDscto  บAutor  ณJackson E. de Deus  บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Emite a autorizacao de desconto                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AutDscto(nLinha)
     
Local lMov := .T.
Local oStatEntr := oList:aArray[nLinha][1]
Local oStatQtd := oList:aArray[nLinha][19]
Local oStatDev := oList:aArray[nLinha][20]
Local cNumOSCnf := oList:aArray[nLinha][18]
Local cNumNF := oList:aArray[nLinha][3] 
Local cSerie := oList:aArray[nLinha][4]
Local cCliente := oList:aArray[nLinha][5]
Local cLoja := oList:aArray[nLinha][6]
Local dDtEmissao := aDados[nLinha][22] 
Local nRecF1 := oList:aArray[nLinha][21]
Local lEntregaOk := .F.
Local lConferido := .F.
Local lClass := IIF( oStatDev:cName == "BR_VERDE",.T.,.F.  )
Local lDiver := .F.
Local axItens := {}
Local cMsgErro := ""
Local aDadosCnf := {}

// Verifica status entrega x conf cega divergencia
If oStatQtd:cName == "BR_VERDE" .And. oStatEntr:cName == "BR_VERDE"
	MsgAlert("Entrega Ok e Quantidade Ok.")
	Return
EndIf

// verifica se ja fez devolucao
If Empty(oList:aArray[nLinha][13])
	MsgAlert("Antes de emitir a autoriza็ใo de desconto, ้ necessแrio gerar a nota fiscal de devolu็ใo.","TTFAT14C")
	Return
EndIf

If !MsgNoYes("Confirma a autoriza็ใo de desconto para o funcionแrio?" )// +CRLF + "Essa opera็ใo vai baixar do estoque a quantidade de produtos que estแ divergente.")
	Return
EndIf
                                
// entrega via OS de entrega
If oStatEntr:cName == "BR_VERDE"
	lEntregaOk := .T.           
EndIf


procregua(2)

IncProc("")
// divergencia na quantidade?
If oStatQtd:cName == "BR_VERMELHO"
	lDiver := .T.
	dbSelectArea("SZG")
	dbSetOrder(1)
	If dbSeek( xFilial("SZG") +AvKey(cNumOSCnf,"ZG_NUMOS") )
		// Finalizada
		If AllTrim(SZG->ZG_STATUS) == "FIOK"
			If !Empty(SZG->ZG_RESPOST)
				lConferido := .T.
				aDadosCnf :=  U_WSKPF005( SZG->ZG_RESPOST,@cMsgErro ) 
				
				If !Empty(aDadosCnf)
					// itens
					axItens := U_TTPROC40(cNumNf,cSerie,cCliente,cLoja,aDadosCnf)
					If Len(axItens) > 0
						lParcial := .T.
					EndIf
				EndIf
			EndIf
		// Cancelada	
		ElseIf AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC|CCLI"
			lConferido := .F.
		EndIf	
	EndIf                
EndIf

// Desconta Qtd do Estoque - Baixa
// situacoes
// entrega nao efetuada - devolucao total - divergencia
// entrega efetuada - devolucao parcial - divergencia
// entrega efetuada - conf cega nao efetuada - devolucao total
IncProc("")
If lDiver .Or. ( lEntregaOk .And. !lConferido ) //( !lEntregaOk .And. lDiver ) .Or. ( lEntregaOk .And. lDiver ) .Or. ( lEntregaOk .And. !lConferido )
	// Relatorio
	RelDscto( cNumNF,cSerie,dDtEmissao,axItens )

	// Baixa da mercadoria	
	If lClass .And. nRecF1 > 0	
		U_TTFAT19C( cNumNF,cSerie,cCliente,cLoja )
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelDscto  บAutor  ณJackson E. de Deus  บ Data ณ  01/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio desconto                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelDscto(cNumNF,cSerie,dDtEmissao,axItens)

Local oPrint
Local clNomeResp := AllTrim( Posicione("DA4",1,xFilial("DA4") +AvKey(_cMot,"DA4_COD"), "DA4_NOME") ) 
Local clCpf		:= Posicione("DA4",1,xFilial("DA4") +AvKey(_cMot,"DA4_COD"), "DA4_CGC")
Local clRg 		:= Posicione("DA4",1,xFilial("DA4") +AvKey(_cMot,"DA4_COD"), "DA4_RG")
Local clEmpres	:= AllTrim( Posicione("AA1",1,xFilial("AA1") +AvKey(_cMot,"AA1_CODTEC"), "AA1_XEMPRE") ) 
Local clCodMat	:= _cMot
Local nTotal	:= 0
Local nI
Local dDtEntr := DataValida(dDtEmissao+1)
	
Private nColIni		:= 40
Private nColIni2	:= 70                   
Private nLin		:= 25
Private nColFim		:= 2400
Private nColFim2	:= 2360  

oFont1 := TFont():New('Arial',,-25,.T.,.T.)
oFont2 := TFont():New('Arial',,-15,.T.,.T.)
oFont3 := TFont():New('Arial',,-15,.T.,.F.)
oFont4 := TFont():New('Arial',,-20,.T.,.T.)
oFont5 := TFont():New('Courier new',,-10,.T.,.T.)                                                            
oFont6 := TFont():New('Courier new',,-10,.T.,.F.)       

If clEmpres == "01"
	clEmpres := "TOK TAKE"   
ElseIf clEmpres == "02"  
	clEmpres := "LUXOR"
ElseIf clEmpres == "03"
	clEmpres == "MC"	
ElseIf clEmpres == "04"
	clEmpres == "MA"	
ElseIf clEmpres == "05" 
	clEmpres == "CAFE PILOTO"	
ElseIf clEmpres == "06" 
	clEmpres == "ACROBAT"	
ElseIf clEmpres == "10"
	clEmpres == "MAQUINA DE CAFE"	
ElseIf clEmpres == "12"
	clEmpres == "MHJ"	
ElseIf clEmpres == "13"
	clEmpres == "MKL"	
EndIf


oPrint := TMSPrinter():New("Autoriza็ใo de desconto")  
oPrint:SetPortrait()  
oPrint:SetPaperSize(9)
oPrint:Setup()     
oPrint:StartPage()  


For nI := 1 to Len( axItens )
	nTotal += axItens[nI][5]
Next nI

nLin := 200
oPrint:Say(nLin,nColIni2+1100,"AUTORIZAวรO DE DESCONTO EM FOLHA DE PAGAMENTO",oFont5,300,CLR_BLACK )
nLin += 150  
			 
oPrint:Say(nLin,nColIni2+100, "Eu, "+ clNomeResp +",portador do RG :"+ clRg +",CPF :"+ clCpf +", Matrํcula :"+ clCodMat +", funcionแrio da Empresa "+ clEmpres,oFont6,1400,CLR_BLACK )                                                                 	
nLin += 60   

oPrint:Say(nLin,nColIni2+100, "autorizo o desconto em folha de pagamento, no valor total de R$ "+ Alltrim( TransForm(nTotal,PesqPict("SD2","D2_TOTAL") )) +" , em _____ parcelas, referente เ diferen็a na distribui็ใo de produtos.",oFont6,1400,CLR_BLACK )                                                                 	
nLin += 150   

oPrint:Say(nLin,nColIni2+100, "Nota fiscal: " +cNumNF +"/" +cSerie,oFont6,1400,CLR_BLACK )                                                                 	
nLin += 60 

oPrint:Say(nLin,nColIni2+100, "Data de emissใo: "+dtoc(dDtEmissao),oFont6,1400,CLR_BLACK )
nLin += 60                                                       	                                        

oPrint:Say(nLin,nColIni2+100, "Data da ocorr๊ncia:  "+ Dtoc(dDtEntr),oFont6,1400,CLR_BLACK )
nLin += 200                                                       	                                        

oPrint:Say(nLin,nColIni2+1100, "PRODUTOS QUE SE ENCONTRAM COM DIVERGสNCIA NESTA NOTA",oFont6,1400,CLR_BLACK )
nLin += 50                                                       	                                         
oPrint:Say(nLin,nColIni2+1100, "----------------------------------------------------",oFont6,1400,CLR_BLACK )

nLin += 60 

oPrint:Say(nLin,nColIni2+100, "PRODUTO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+500, "DESCRIวรO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1500, "QTD", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1700, "VALOR UNITARIO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, "VALOR TOTAL", oFont6,200,CLR_BLACK )
nLin += 60 

oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
nLin += 20 

	// item diferenca produto descricao valor 
For nI := 1 to Len( axItens )
	If nLin >= 2300
		oPrint:Say(nLin,nColIni2+2000, "CONTINUA PROX PAG. ---> ", oFont6,200,CLR_BLACK )
		oPrint:EndPage()             
  		oPrint:StartPage()

  		oPrint:Say(nLin,nColIni2+1200,"AUTORIZAวรO DE DESCONTO EM FOLHA DE PAGAMENTO",oFont5,300,CLR_BLACK )                  
  		nLin += 150
  		oPrint:Say(nLin,nColIni2+100, "PRODUTO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+500, "DESCRIวรO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+1500, "QTD", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+1700, "VALOR UNITARIO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+2200, "VALOR TOTAL", oFont6,200,CLR_BLACK )
		nLin += 60 
		
		oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
		nLin += 20 
	EndIf
	
	oPrint:Say(nLin,nColIni2+100, axItens[nI][3] , oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+500, axItens[nI][4], oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500, CVALTOCHAR(axItens[nI][2]), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1700, Transform( axItens[nI][6], PesqPict("SD2","D2_TOTAL") ), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+2200, Transform( axItens[nI][5], PesqPict("SD2","D2_TOTAL") ), oFont6,200,CLR_BLACK )
	nLin += 30
Next nI
nLin += 20
	
oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
nLin += 50 

oPrint:Say(nLin,nColIni2+100, "TOTAL A DESCONTAR R$ ", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, Transform(nTotal,PesqPict("SD2","D2_TOTAL")), oFont6,200,CLR_BLACK )
nLin += 50 

oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
   	 
// rodape 	
RelRoda(@oPrint)
     
oPrint:Preview() 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelRoda  บAutor  ณJackson E. de Deus   บ Data ณ  01/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rodape do relatorio                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelRoda(oPrint)

If nLin < 2300
	nLin := 2300
EndIf

oPrint:Line( nLin,nColIni2+2100,nLin,nColFim+500 )
nLin += 10

oPrint:Say(nLin,nColIni2+100, "Responsแvel pela apura็ใo : " +UsrFullName(__cUserID) , oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, "Assinatura do funcionแrio" , oFont6,200,CLR_BLACK )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancelaOS  บAutor  ณJackson E. de Deus บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cancela as Ordens de Servico Mobile                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CancelaOS(cCarga)

Local nTotReg := 0
Local cSql := ""
Local oXml
Local cError := ""
Local cWarning := ""
Local cResult := ""
Local cStatusOS := ""
Local nCancOK := 0
Local lRet := .F.
          
If Empty(cCarga)
	Return
EndIf

If !MsgNoYes("Confirma o cancelamento das OS geradas para o romaneio?")
	Return
EndIf


cSql := "SELECT F2_DOC, F2_SERIE, ZG_NUMOS, ZG_STATUS, SZG.R_E_C_N_O_   "
cSql += " FROM " +RetSqlName("SF2") +" SF2 "
cSql += " INNER JOIN " +RetSqlName("SZG") +" SZG ON "
cSql += " SZG.ZG_DOC = SF2.F2_DOC AND SZG.ZG_SERIE = SF2.F2_SERIE AND SZG.D_E_L_E_T_ = '' "
cSql += " WHERE SZG.ZG_TPFORM IN ('1','13') "
cSql += " AND SF2.F2_XCARGA = '"+cCarga+"' AND SF2.D_E_L_E_T_ = '' AND ZG_STATUS NOT IN ('COPE','CTEC','CCLI','FIOK') " 

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	nTotReg++
	dbSkip()
End         

ProcRegua(nTotReg)
dbGoTop()
While !EOF()
	IncProc("NF: " +AllTrim(TRB->F2_DOC) +"/" +AllTrim(TRB->F2_SERIE))
	
	// ALTERAR AQUI PARA O CANCELAMENTO DAS OS
	
	// Verifica o status atualizado da OS MOBILE
	// cancelar no novo padrao
	If lRet
		nCancOK++
	EndIf
	
	dbSelectArea("TRB")		
	dbSkip()
End
dbCloseArea() 

If nCancOK > 0
	Aviso("Cancelamento","Foram canceladas " +cvaltochar(nCancOk) +" OS.",{"Ok"})
	RetDados()
EndIf     

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelDiver  บAutor  ณJackson E. de Deus  บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio das divergencias                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelDiver(nLinha)

Local cNumNF := oList:aArray[nLinha][3] 
Local cSerie := oList:aArray[nLinha][4]
Local cCliente := oList:aArray[nLinha][5]
Local cLoja := oList:aArray[nLinha][6]
Local cNumOSCnf := oList:aArray[nLinha][18] 
Local oStatQtd := oList:aArray[nLinha][19]
Local cMsgErro := ""
Local axItens := {}
Local aDados := {}  
Local cDir := ""
Local oExcel := Nil 
Local cTitulo := "Divergencia"
Local cCabeca := "Divergencia"
Local cTime := Time()
Local cArqXls := "divergencias_" +SubStr(cTime,1,2) +SubStr(cTime,4,2) +SubStr(cTime,7) +".xml"  


If Empty(cNumOSCnf)
	MsgInfo("Nใo gerou OS de confer๊ncia cega.") 
	Return
EndIf                                         

If oStatQtd:cName == "BR_VERDE"
	MsgInfo("Nใo possui diverg๊ncia.") 
	Return	
EndIf 

ProcRegua(2)
IncProc("")

dbSelectArea("SZG")
dbSetOrder(1)
If dbSeek( xFilial("SZG") +AvKey(cNumOSCnf,"ZG_NUMOS") )
	If AllTrim(SZG->ZG_STATUS) == "FIOK"
		If !Empty(SZG->ZG_RESPOST)
			aDados :=  U_WSKPF005( SZG->ZG_RESPOST,@cMsgErro ) 
			If !Empty(aDados)
				axItens := U_TTPROC40(cNumNf,cSerie,cCliente,cLoja,aDados)
			EndIf
		EndIf
	EndIf	                  	
EndIf

IncProc("")
If Len(axItens) > 0
	oExcel := FWMSEXCEL():New()
	oExcel:AddworkSheet(cTitulo) 
	oExcel:AddTable (cTitulo,cCabeca)
	
	oExcel:AddColumn(cTitulo,cCabeca,"Nota Fiscal",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Serie",1,1)  
	oExcel:AddColumn(cTitulo,cCabeca,"Item",1,1)     
	oExcel:AddColumn(cTitulo,cCabeca,"Produto",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Descri็ใo",1,1)
	oExcel:AddColumn(cTitulo,cCabeca,"Diferen็a",1,1)     
	oExcel:AddColumn(cTitulo,cCabeca,"Valor",3,2)  

	For nI := 1 To Len(axItens)
		oExcel:AddRow( cTitulo,cCabeca, { cNumNf, cSerie, axItens[nI][1], axItens[nI][3], axItens[nI][4], axItens[nI][2],axItens[nI][5]  } )
	Next nI
	
	
	cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If !Empty(cDir)
		oExcel:Activate()
		oExcel:GetXMLFile(cDir +cArqXls)
		
		If File(cDir +cArqXls)
			MsgInfo("A planilha foi gerada em "+cDir,"TTFAT14C")
			If !ApOleClient( 'MsExcel' )
				MsgInfo('MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
			Else
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( cDir +cArqXls )
				oExcelApp:SetVisible(.T.)         
				oExcelApp:Destroy()
			EndIf
		EndIf  
	EndIf
EndIf			

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT14C  บAutor  ณMicrosiga           บ Data ณ  04/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OSCnf(nLinha)

Local cNumNF := oList:aArray[nLinha][3] 
Local cSerie := oList:aArray[nLinha][4]
Local cCliente := oList:aArray[nLinha][5]
Local cLoja := oList:aArray[nLinha][6]
Local cOSEntr := oList:aArray[nLinha][17]
Local cOSCnf := oList:aArray[nLinha][18] 
Local aArea := GetArea()
Local dData := stod("")
Local cHora := ""
Local cEntregue := ""
Local cNome := ""
Local cRG := ""
Local nKM := 0
Local cConfs := ""
Local cCnfEsc := ""
Local lInvalido := .F.
Local aCnf := {}    
Local aConfer := {}
Local cCnfrnte := ""
Local cRelConf := "" 
Local aDocCnf := {}
Local cDadosCnt := ""
Local cNumOSCnf := "" 
Local cHoraAgen := ""  
Local lCanc := .F.
Local cMtrta := ""
Local nOpc := 0
Local cCliPa := ""
Local cLjPa := ""
Local lRet := .F. 
Local cAxCnf := ""
Local nI, nJ
Local cAx := ""
Local cCliExec := SuperGetMV("MV_XLOG007",.T.,"")	// clientes PA excecoes - sem conferencia cega




dbSelectArea("SF1")
dbGoTo(oList:aArray[nLinha][21]) 
CnfEntr( SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA )

Return

/*
geracao de os de conferencia cega via painel - situacoes
nao enviou na OS de entrega os conferentes -> plano de trabalho incorreto
preencheu errado o conferente -> nao gera a os
cancelou a os de conferencia cega -> gerar uma nova os
*/

dbSelectArea("SF2")
dbsetOrder(2)
If dbSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
	If !Empty(SF2->F2_XCODPA) .And. AllTrim(SF2->F2_XNFABAS) == "1"	.And. AllTrim(SF2->F2_XFINAL) == "4"
		If SubStr(SF2->F2_XCODPA,1,1) == "P" 
	
			cPa := SF2->F2_XCODPA
			cMtrta := AllTrim( SubStr( SF2->F2_XMOTOR,8 ) )
						
			dbSelectArea("ZZ1")
			dbSetOrder(1)
			If dbSeek( xFilial("ZZ1") +AvKey(SF2->F2_XCODPA,"ZZ1_COD") )
				cDescPA := ZZ1->ZZ1_DESCRI
				cCliPa := SubStr( ZZ1->ZZ1_ITCONT,1,6 )
				cLjPA :=SubStr( ZZ1->ZZ1_ITCONT,7,4 )
			EndIf
			
			// tratamento para clientes que sao PA porem nao necessita conferencia cega
			If cCliPa $ cCliExec // 005594#005437- delboni fleury
				Aviso("TTFAT14C","Para essa PA nใo ้ necessแria a confer๊ncia cega.",{"Ok"})
			Else
				dbSelectArea("SZG")
				dbSetOrder(1)
				
				// verifica OS de conferencia cega
				If !Empty(cOSCnf)
					If dbSeek( xFilial("SZG") +AvKey(cOSCnf,"ZG_NUMOS") )
						If AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC|CCLI"
							lCanc := .T.
						EndIf
					EndIf
				EndIf
		
				// verifica OS de entrega
				If Empty(cOSCnf) .Or. lCanc
					If dbSeek( xFilial("SZG") +AvKey(cOSEntr,"ZG_NUMOS") )
						If AllTrim( SZG->ZG_STATUS ) == "FIOK"
							If !Empty(SZG->ZG_RESPOST)
								StaticCall( TTPROC29,InfoEntr,,cOSEntr,@dData,@cHora,@cEntregue,@cNome,@cRG,@nKM,@cConfs,@cCnfEsc)
								
								// sem conferentes
								If Empty(cConfs) .Or. Empty(cCnfEsc)
									lInvalido := .T.
								// conferente apontado invalido
								Else
									aCnf := StrToKarr(cConfs,"#")
									For nI := 1 To Len(aCnf)
										If SubStr(aCnf[nI],1,1) == cCnfEsc
											cCnfrnte := AllTrim(SubStr( aCnf[nI],3 ))
										EndIf
									Next nI				
									If Empty(cCnfrnte)
										lInvalido := .T.
									EndIf
								EndIf
								// apontar conferente            
								If lInvalido 
									cRelConf := StaticCall( TTFAT17C, ChkCnf, cCliPa,cLjPa,dDatabase, .F.,cPa )
									If Empty(cRelConf) .And. cUserName $ cUsrs 
										lRet := ConPad1(,,,"AA1",,,.F.)
										If lRet
											nAgente := Val(AA1->AA1_PAGER)
											cRelConf := AllTrim(AA1->AA1_NOMTEC) 
										EndIf  
									EndIf
									If !Empty(cRelConf)
										aCnf := StrToKarr(cRelConf,"#")
										For nI := 1 To Len(aCnf)
											If !Empty(aCnf[nI])
												AADD( aConfer, { AllTrim( aCnf[nI] ) } )
											EndIf
										Next nI  
										
										// janela - conferentes
										Define MsDialog oDlg Title "Conferentes" From 0,0 To 250,500 Pixel
											@ 005,002  Say "Conferentes de: "+cDescPA	Pixel Of oDlg
											@ 015,002 LISTBOX oLbx FIELDS HEADER "Nome" SIZE 249,090 OF oDlg PIXEL
											
											oLbx:SetArray(aConfer)
											oLbx:bLine := {|| { aConfer[oLbx:nAt,1]}}
										 	oLbx:bChange := {|| cCnfrnte := aConfer[oLbx:nAt,1] }
										      
											oButton := tButton():New(110,220,'Confirmar',oDlg,{ || oDlg:End(nOpc:=1) },30,12,,,,.T.)
										Activate MsDialog oDlg Center
										
										// gerar OS
										If nOpc == 1 .And. !Empty(cCnfrnte)
											nAgente := StaticCall( TTPROC29,ChkAgnt,cCnfrnte )
											If nAgente > 0
												//aDocCnf := { SF2->F2_DOC, SF2->F2_SERIE, 2, SF2->F2_CLIENTE, SF2->F2_LOJA }	// nota serie tipo clientenf lojanf
												//cDadosCnt := "Nota fiscal: " +cNumNF+"/" +cSerie +" PA: " +cPa +" - " +cDescPA
												//cNumOSCnf := U_WSKPF009(1,cCliente,cLoja,aDocCnf,nAgente,cHoraAgen,.F.,Date(),cDadosCnt)
												
												
												If !Empty(cNumOSCnf)
													If Val(cNumOSCnf) > 0
														MsgInfo( "Ordem de Servi็o gerada: " +cNumOSCnf )
													EndIf
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf			
					EndIf	
				EndIf
			EndIf
		EndIf	
	EndIf
EndIf	

RestArea(aArea)

Return