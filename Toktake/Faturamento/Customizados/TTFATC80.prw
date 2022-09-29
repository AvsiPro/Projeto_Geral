#include "topconn.ch"
#include "protheus.ch"  
#include "fwmvcdef.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC80  บAutor  ณJackson E. de Deus  บ Data ณ  18/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mapa de maquina                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATC80()

Local oBrowse
Private cCadastro := "Mapa de mแquina"

If cEmpAnt <> "01"
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZH")
oBrowse:SetDescription(cCadastro)
             
//oBrowse:SetFilterDefault("ZH_MSBLQL<>'1'")
oBrowse:AddLegend("ZH_STATUS=='1'","BLACK","Desativado")
oBrowse:AddLegend("ZH_STATUS=='2'","WHITE","Aguardando aprov.")
oBrowse:AddLegend("ZH_STATUS=='3'","GREEN","Ativo")


oBrowse:Activate()

Return
                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef  บAutor  ณJackson E. de Deus   บ Data ณ  15/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Menu do browse                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()

Local aRotina	:= {} 
Local cAlias	:= "SZH"
                                               
ADD OPTION aRotina TITLE 'Pesquisar'	ACTION "PesqBrw"							OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'	ACTION "STATICCALL( TTFATC80, Manut, 2 )"	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'		ACTION "STATICCALL( TTFATC80, Manut, 3 )"	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'		ACTION "STATICCALL( TTFATC80, Manut, 4 )"	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'		ACTION "STATICCALL( TTFATC80, Manut, 5 )"	OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Revisao'		ACTION "STATICCALL( TTFATC80, Manut, 6 )"	OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Aprovar'		ACTION "STATICCALL( TTFATC80, Aprov, 7 )"	OPERATION 7 ACCESS 0

                    
Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAprov  บAutor  ณJackson E. de Deus     บ Data ณ  12/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Aprova o mapa                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Aprov()

Local aArea		:= GetArea()                                                          
Local cPatrimo	:= SZH->ZH_CHAPA
Local cCodCli	:= SZH->ZH_CLIENTE
Local cLoja		:= SZH->ZH_LOJA
Local cVersao	:= SZH->ZH_VERSAO
Local cVerOld	:= ""

If MsgYesNo("ษ necessแrio conferir as molas antes de aprovar. Voc๊ jแ conferiu?")
	// desativa mapa atual ativo
	If Val(cVersao) >= 1		
		cQuery := "UPDATE "+RetSqlName("SZH")
		cQuery += " SET ZH_STATUS = '1', ZH_MSBLQL = '1' "
		cQuery += " WHERE ZH_CHAPA = '"+cPatrimo+"' AND ZH_VERSAO <> '"+cVersao+"' " //AND ZH_CLIENTE = '"+cCodCli+"' AND ZH_LOJA = '"+cLoja+"' " - Altera็ใo realizada por Ronaldo G. de Jesus - 07/02/2017
		
		nExec := TCSQLExec(cQuery)
		If nExec < 0
			MsgAlert( "ERRO " +CRLF + TCSQLError() )
		EndIf
	EndIf
		
	// aprovacao da nova versao
	cQuery := "UPDATE "+RetSqlName("SZH")
	cQuery += " SET ZH_STATUS = '3', ZH_DINICIO = '"+dtos(Date())+"' "
	cQuery += " WHERE ZH_CHAPA = '"+cPatrimo+"' AND ZH_VERSAO = '"+cVersao+"' AND ZH_CLIENTE = '"+cCodCli+"' AND ZH_LOJA = '"+cLoja+"' "
	
	nExec := TCSQLExec(cQuery)
	If nExec < 0
		MsgInfo( "ERRO " +CRLF + TCSQLError() )
	Else
		MsgInfo("Mapa aprovado!")	
	EndIf    
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณManut  บAutor  ณJackson E. de Deus     บ Data ณ  26/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manutencao do cadastro de mapa                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Manut(nOpc)

Local oWindow
Local lOk			:= .F.
Local aSize			:= MsAdvSize()                 
Local aCpoSZH		:= { "NOUSER","ZH_CHAPA", "ZH_CODMAQ", "ZH_CLIENTE", "ZH_LOJA" }
Local aPos			:= {000,000,000,000}
Local nOpcGD		:= GD_INSERT+GD_UPDATE+GD_DELETE
Local aButtons		:= {} //{ {"HISTORIC", { || SelPlan() }, "Planilha", "Planilha" , {|| .T.} } }
Local oFont			:= TFont():New('Courier new',,-12,.T.)
Local lAprovar		:= .F.
Private oLayer		:= FwLayer():New()
Private aAlter		:= { /*"ZH_BANDEJA",*/"ZH_MOLA","ZH_QUANT","ZH_TIPOMOL","ZH_CODPROD" }
Private aCols		:= {}
Private aHeader		:= {}
Private _aDados		:= {}
Private _aRecnos	:= {}
Private _cChapa		:= Space(6)
Private _cCliente	:= Space(6)
Private _cLOja		:= Space(4)
Private _cCodMaq	:= Space(15)
Private _cVersao	:= ""
Private _dInicio	:= stod("")
Private _aBandeja	:= { { 1, "A", .F., {}, {} },{ 2, "B", .F., {}, {} },{ 3, "C", .F., {}, {} },{ 4, "D", .F., {}, {} },{ 5, "E", .F., {}, {} },{ 6, "F", .F., {},{} } }
Private _cMsgInfo	:= ""
Private _cMsgRev	:= "Voc๊ estแ gerando uma nova versใo do mapa"
Private _cMsgAprov	:= "Essa ้ uma versใo de mapa gerada via aplicativo mobile"

If nOpc == 2
	nOpcGD := 2
ElseIf nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 6
	nOpcGD := GD_INSERT+GD_UPDATE+GD_DELETE
ElseIf nOpc == 5
	nOpcGD := 2
EndIf

fHead()
dbSelectArea("SZH")
RegToMemory("SZH",.T.)

If nOpc == 3
	_dInicio := Date()
	_cVersao := "1"
EndIf

If SZH->ZH_STATUS == "2"
	lAprovar := .T.
EndIf


oWindow := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Mapa de mแquina",,,.F.,,,,,,.T.,,,.T. )	
      
	oWindow:lEscClose := .F.
	oWindow:lMaximized := .T. 
	
	oLayer:Init(oWindow,.F.)
	oLayer:addLine("LINHA1",70,.F.)

	oLayer:addCollumn('COLUNA1_1',25,.F.,"LINHA1")
	oLayer:addCollumn('COLUNA2_1',75,.F.,"LINHA1")

  	oLayer:addWindow("COLUNA1_1","WIN_1","Bandejas",100,.F.,.T.,{||},"LINHA1")
  	oLayer:addWindow("COLUNA2_1","WIN_2","Molas",100,.F.,.T.,{||},"LINHA1")
                                                     
	oPnl1 := oLayer:GetWinPanel("COLUNA1_1","WIN_1","LINHA1")
	oPnl2 := oLayer:GetWinPanel("COLUNA2_1","WIN_2","LINHA1")
	         
	// painel superior - campos
    oPanel := tPanel():New( 0,0,"",oWindow,,,,,,0,50)
	oPanel:Align := CONTROL_ALIGN_TOP
	                     
	oImgProd := TBitmap():New(0,aSize[5]-600,50,50,"","",.T.,oPanel,{ || },,.F.,.T.,,,.F.,,.T.,,.F.)
	//oImgProd:Load( , "\_mobile\data\data_img\1001120.jpg" )
	
	oChapa := TGet():New( 05,05,{|u| If(PCount()>0,_cChapa:=u,_cChapa) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{ || AtuCab() },.F.,.F.,""/*F3*/,"",,,,,,,"Patrim๔nio",2,oFont)	
	If nOpc <> 3
		oChapa:Disable()
	EndIf
	oMaq := TGet():New( 05,100,{|u| If(PCount()>0,_cCodMaq:=u,_cCodMaq) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Modelo",2,oFont)		
	oMaq:Disable()
	
	oCli := TGet():New( 20,05,{|u| If(PCount()>0,_cCliente:=u,_cCliente) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Cliente",2,oFont)	
	oCli:Disable()
	oLj := TGet():New( 20,100,{|u| If(PCount()>0,_cLOja:=u,_cLOja) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Loja",2,oFont)	
	oLj:Disable()	              
	oDt := TGet():New( 05,200,{|u| If(PCount()>0,_dInicio:=u,_dInicio) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Inicio",2,oFont)	
	oDt:Disable()	
	oVer := TGet():New( 20,200,{|u| If(PCount()>0,_cVersao:=u,_cVersao) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Versใo",2,oFont)	
	oVer:Disable()

	oInfo := TSay():New( 40,05,{ || _cMsgInfo  },oPanel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,500)
	oInfo:SetCss(" QLabel {font: bold 12px; color: #ff3377; } ")	
	If lAprovar	
		_cMsgInfo := _cMsgAprov
	EndIf
	If nOpc == 6
	 _cMsgInfo := _cMsgRev
	EndIf
	
	
	oBdj1 := TButton():New( 05, 05,"Bandeja 1-A",oPnl1,{ || AtvBdj(1)   },100,20,,,,.T.,,"",,,,.F. )
   	oBdj1:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:PMSSETADIR.png); background-repeat: none; margin: 1px }" ) 
   	
   	oBdj2 := TButton():New( 30, 05,"Bandeja 2-B",oPnl1,{ || AtvBdj(2)  },100,20,,,,.T.,,"",,,,.F. )
   	oBdj2:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:PMSSETADIR.png); background-repeat: none; margin: 1px }" ) 
   	
   	oBdj3 := TButton():New( 60, 05,"Bandeja 3-C",oPnl1,{ || AtvBdj(3)  },100,20,,,,.T.,,"",,,,.F. )
   	oBdj3:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:PMSSETADIR.png); background-repeat: none; margin: 1px }" ) 
   	
   	oBdj4 := TButton():New( 90, 05,"Bandeja 4-D",oPnl1,{ || AtvBdj(4)  },100,20,,,,.T.,,"",,,,.F. )
   	oBdj4:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:PMSSETADIR.png); background-repeat: none; margin: 1px }" ) 
   	
   	oBdj5 := TButton():New( 120, 05,"Bandeja 5-E",oPnl1,{ || AtvBdj(5)  },100,20,,,,.T.,,"",,,,.F. )
   	oBdj5:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:PMSSETADIR.png); background-repeat: none; margin: 1px }" ) 
   	
   	oBdj6 := TButton():New( 150, 05,"Bandeja 6-F",oPnl1,{ || AtvBdj(6)  },100,20,,,,.T.,,"",,,,.F. )
   	oBdj6:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:PMSSETADIR.png); background-repeat: none; margin: 1px }" ) 
   	
 
	// D:\Protheus11\Protheus_Data\_mobile\data\data_img      
    oMsGD := MsNewGetDados():New(0,0,0,0,nOpcGD,'STATICCALL( TTFATC80, LinOk )','STATICCALL( TTFATC80, TudoOk )','',aAlter,0,100,'STATICCALL( TTFATC80,AltCpo )','','AllwaysTrue()',oPnl2,aHeader,aCols, { || fChange() })
   	oMsGD:oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
   	
   	If nOpc <> 3
   		Carrega()   
   	EndIf
	oMsGD:Refresh(.T.)	 
	oMsGD:GoTop()
	oMsGd:Disable()
	 
oWindow:Activate(,,,.T.,/*aButtons*/,,EnchoiceBar(oWindow,{ || fChange(),IIF(oMsGD:tudoOk(),lOk := Gravar(nOpc),), IIF(lOk, oWindow:End() ,)    },{ || oWindow:End(),,aButtons,,,.F.,.F.,.F.} )) 

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtvBdj  บAutor  ณJackson E. de Deus    บ Data ณ  12/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Configuracao de bandeja                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtvBdj(nPos)

Local nI

// salva o que esta na bandeja ativa
For nI := 1 To Len(_aBandeja)
	If _aBandeja[nI][3]
		_aBandeja[nI][4] := aclone( oMsGd:acols )
	EndIf
Next nI

// muda status bandeja
For nI := 1 To Len(_aBandeja)
	If nI <> nPos
		_aBandeja[nI][3] := .F.
	EndIf
Next nI

// ativa dados dessa bandeja clicada
_aBandeja[nPos][3] := .T.

oLayer:setWinTitle("COLUNA2_1", "WIN_2", "Bandeja "+_aBandeja[nPos][2], "LINHA1")	

aCols := {}
If !Empty(_aBandeja[nPos][4])
	aCols := aclone(_aBandeja[nPos][4])
EndIf

If Empty(aCols)
	oMsGD:aCols := {}

	AAdd(aCols, Array(Len(aHeader)+1))
	nLin := Len(aCols) 
	//aCols[nLin][1] := Space(TamSX3("ZH_BANDEJA")[1])
	aCols[nLin][1] := Space(TamSX3("ZH_MOLA")[1])
	aCols[nLin][2] := Space(TamSX3("ZH_TIPOMOL")[1])
	aCols[nLin][3] := 0//Space(TamSX3("ZH_QUANT")[1])
	aCols[nLin][4] := Space(TamSX3("ZH_CODPROD")[1])
	aCols[nLin][5] := Space(TamSX3("B1_DESC")[1])
	aCols[nLin][6] := Space(TamSx3("BM_DESC")[1])
	
	aCols[nLin][Len(aHeader)+1] := .F.	
EndIf

oMsGD:SetArray( aCols )
oMsGD:Refresh()	 
oMsGd:Enable()                            

Return
       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuCab  บAutor  ณJackson E. de Deus    บ Data ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza campos do cabecalho                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuCab()

If !Empty(_cChapa)
	dbSelectArea("SN1")
	dbSetOrder(2)
	If msSeek( xFilial("SN1") +AvKey(_cChapa,"N1_CHAPA") )
		_cCodMaq := SN1->N1_PRODUTO
		_cCliente := SN1->N1_XCLIENT
		_cLOja := SN1->N1_XLOJA
	EndIf
Else	
	_cCodMaq := ""
	_cCliente := ""
	_cLOja := ""
EndIf


oMaq:Refresh()
oCli:Refresh()
oLj:Refresh()
      

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChange   บAutor  ณJackson E. de Deus  บ Data ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ bloco fchange do grid                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChange()
            
Local nPos

nPos := Ascan( _aBandeja, { |x| x[3] == .T. } )
If nPos > 0
	_aBandeja[nPos][4] := aclone(oMsGD:aCols)
EndIf

For nI := 1 To Len(oMsGD:aCols)
	conout()
Next nI

oMsGD:Refresh(.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltCpo  บAutor  ณJackson E. de Deus    บ Data ณ  26/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracao de campos do grid                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltCpo()

Local lRet := .T.
Local cImgDef := "nophoto.png"
Local nPosDesc := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_DESCPRO" } )
Local nPGrupo := Ascan( aheader, { |x| ALLTRIM(x[2]) == "BM_DESC" } )
Local nPos := 0

// mola
If __readvar == "M->ZH_MOLA"
	If Len(ALLTRIM(CVALTOCHAR(M->ZH_MOLA))) > 2
		MsgAlert("O c๓digo de mola deve ter apenas 2 caracteres!")
		lRet := .F.
	EndIf
	
	nPos := AScan( oMsGd:aCols, { |x| x[2] == M->ZH_MOLA .And. x <> oMsGd:nAt } )
	If nPos > 0
		MsgAlert("Essa mola jแ estแ configurada!")
		lRet := .F.	
	EndIf
	
// tipo mola	
ElseIf __readvar == "M->ZH_TIPOMOL"

// quantidade                                   
ElseIf __readvar == "M->ZH_QUANT"

	If !Empty(M->ZH_QUANT)
		If M->ZH_QUANT > 20
			MsgAlert("A mola nใo deve ter capacidade superior a 20!")
			lRet := .F.
		EndIf
	EndIf

// produto		
ElseIf __readvar == "M->ZH_CODPROD"

	If !Empty(M->ZH_CODPROD)
		dbSelectArea("SB1")
		dbSetOrder(1)
		If msSeek( xFilial("SB1") +AvKey(M->ZH_CODPROD,"B1_COD") )
			omsGd:acols[omsGd:nAt][nPosDesc] := SB1->B1_DESC
			
			cGrupo := SB1->B1_GRUPO
			omsGd:aCols[omsGd:nAt][nPGrupo] := AllTrim(Posicione( "SBM",1,xFilial("SBM") +AvKey(cGrupo,"BM_GRUPO"),"BM_DESC" ))				
		EndIf
	
		If File("\_mobile\mobile\data\data_img\"+alltrim(M->ZH_CODPROD) +".png")
			oImgProd:Load( , "\_mobile\mobile\data\data_img\" +alltrim(M->ZH_CODPROD) +".png" )
			oImgProd:Refresh()
			
			//omsGd:acols[omsGd:nAt][6] := "\_mobile\data\data_img\" +alltrim(M->ZH_CODPROD) +".jpg"
		Else
			oImgProd:Load( , "\_mobile\mobile\data\data_img\" +cImgDef +".png")
			oImgProd:Refresh()
		EndIf
	EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLinOk  บAutor  ณJackson E. de Deus     บ Data ณ  02/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LinhaOk do grid                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LinOk()

Local lRet := .T.                                                  
Local nPBan := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_BANDEJA" } )
Local nPMola := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_MOLA" } )
Local nPTpMol := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_TIPOMOL" } )
Local nPQtd := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_QUANT" } )
Local nPProd := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_CODPROD" } )			

// mola 
If Empty(oMsGd:acols[oMsGd:nAt][nPMola])
	lRet := .F. 
	MsgAlert("Preencha a mola!")
	Return lRet
EndIf

// tipo de mola
If Empty(oMsGd:acols[oMsGd:nAt][nPTpMol])
	lRet := .F. 
	MsgAlert("Preencha o tipo de mola!")
	Return lRet
EndIf

// qtd
If Empty(oMsGd:acols[oMsGd:nAt][nPQtd])
	lRet := .F. 
	MsgAlert("Preencha a capacidade da mola!")
	Return lRet
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTudoOk  บAutor  ณJackson E. de Deus    บ Data ณ  06/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao tudok do grid                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TudoOk()

Local lRet := .T.
Local nI
Local aBandeja := {}

If Empty(_cChapa)
	MsgAlert("Configure o patrim๔nio!")
	lRet := .F.
	Return lRet
EndIf


Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfHead  บAutor  ณJackson E. de Deus     บ Data ณ  26/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega aHeader                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fHead()

dbSelectArea("SX3")
dbSetOrder(2)            
dbGoTop()

// marcacao
//Aadd(aHeader, {" ","CHECK", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})
/*
If msSeek("ZH_BANDEJA")
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX,,,"V" } )
EndIf 
*/
If msSeek("ZH_MOLA")
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf      

If msSeek("ZH_TIPOMOL")
     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf     

If msSeek("ZH_QUANT")
     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf

If msSeek("ZH_CODPROD")
	AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"" /*vld campo*/,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

If msSeek("ZH_DESCPRO") 
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

//Aadd(aHeader, {" ","IMGP", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})


If msSeek("BM_DESC") 
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarrega  บAutor  ณJackson E. de Deus   บ Data ณ  11/26/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o mapa                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Carrega()

Local cSql := ""
Local nLin := 0

cSql := "SELECT * FROM SZH010 "
cSql += " WHERE ZH_CHAPA = '"+SZH->ZH_CHAPA+"' AND ZH_VERSAO = '"+SZH->ZH_VERSAO+"' AND D_E_L_E_T_ = '' "
cSql += " ORDER BY ZH_BANDEJA, ZH_MOLA "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()

	_cChapa := TRB->ZH_CHAPA
	_cCliente := TRB->ZH_CLIENTE
	_cLOja := TRB->ZH_LOJA
	_cCodMaq := TRB->ZH_CODMAQ
	_cVersao := TRB->ZH_VERSAO
	_dInicio := STOD(TRB->ZH_DINICIO)

	AAdd(aCols, Array(Len(aHeader)+1))
	nLin := Len(aCols)
	               
	//aCols[nLin][1] := TRB->ZH_BANDEJA
	aCols[nLin][1] := TRB->ZH_MOLA
	aCols[nLin][2] := TRB->ZH_TIPOMOL
	aCols[nLin][3] := TRB->ZH_QUANT
	aCols[nLin][4] := TRB->ZH_CODPROD
	aCols[nLin][5] := AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(TRB->ZH_CODPROD,"B1_COD"),"B1_DESC" ))
	
	cGrupo := AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(TRB->ZH_CODPROD,"B1_COD"),"B1_GRUPO" ))
	
	aCols[nLin][6] := AllTrim(Posicione( "SBM",1,xFilial("SBM") +AvKey(cGrupo,"BM_GRUPO"),"BM_DESC" ))	
	//aCols[nLin][6] := "OK"
	
	aCols[nLin][Len(aHeader)+1] := .F.
	
	AADD( _aBandeja[Val(TRB->ZH_BANDEJA)][5], TRB->R_E_C_N_O_ )	//AADD( _aRecnos, TRB->R_E_C_N_O_ )
	                          
	// adiciona na bandeja
	AADD( _aBandeja[Val(TRB->ZH_BANDEJA)][4], acols[nLin] )
	
	TRB->(dbSkip())			
End   


oMsGD:Acols := aClone(aCols)
oMsGD:Refresh(.T.)	 
oMsGD:GoTop() 
                          
//oMsGD:SetArray( aInfo, .T. )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar  บAutor  ณJackson E. de Deus    บ Data ณ  12/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a gravacao do mapa                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(nOpc)

Local nRecno := 0
Local nLinha := 0
Local nCol := 0
Local nNrCampo := 0
Local nPos := 0
Local aDados := {}
Local aRecnos := {}
Local lOk := .T. 
Local nPProd := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_CODPROD" } )
Local nPMola := Ascan( aheader, { |x| ALLTRIM(x[2]) == "ZH_MOLA" } )
Local aMap := {}
Local cBandeja := ""
Local lCafe := .T.
Local lGrava := .T.
Local cGrupo := ""

dbSelectArea("SN1")
dbSetOrder(2)
If MsSeek( xFilial("SN1") +AvKey(_cChapa,"N1_CHAPA") )
	dbSelectArea("SB1")
	dbSetOrder(1)
	If MSSeek( xFilial("SB1") +AvKey(SN1->N1_PRODUTO,"B1_COD") )
		If AllTrim(SB1->B1_XFAMILI) $ "144/153"
			lCafe := .T.
		EndIf
	EndIf
EndIf

// revisao - verifica se existe diferenca entre bandejas/molas
If nOpc == 6                                                  

EndIf


dbSelectArea("SZH")
For nI := 1 To Len(_aBandeja)

	cBandeja := cvaltochar(_aBandeja[nI][1])
	aDados := aClone( _aBandeja[nI][4] )
	aRecnos := aClone( _aBandeja[nI][5] )
	
	// revisao
	If nOpc == 6
		// bloqueia o mapa atual
		For nLinha := 1 To Len(aDados)
			If nLinha <= Len(aRecnos)
				dbGoTo(aRecnos[nLinha])
				If RecLock("SZH",.F.)  
					SZH->ZH_MSBLQL	:= "1"
					SZH->ZH_STATUS  := "1"
					SZH->( MsUnlock() )
				EndIf
			EndIf	
		Next nI
		
		// inclui o novo mapa
		If RecLock("SZH",.T.)
			SZH->ZH_CHAPA	:= _cChapa
			SZH->ZH_CLIENTE	:= _cCliente
			SZH->ZH_LOJA	:= _cLoja
			SZH->ZH_CODMAQ	:= _cCodMaq
			SZH->ZH_USUARIO	:= cUserName
			SZH->ZH_DINICIO	:= Date()
			SZH->ZH_VERSAO	:= Soma1(_cVersao)
			SZH->ZH_STATUS	:= "3"
			SZH->ZH_BANDEJA := cBandeja
			
			For nCol := 1 To Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
				FieldPut(nNrCampo, aDados[nLinha][nCol])
			Next nCol
			SZH->( MsUnlock() )
		EndIf
	// inclusao / alteracao / exclusao
	Else
		For nLinha := 1 To Len(aDados)
			// Alteracao  
			If nLinha <= Len(arecnos)
				dbGoTo(arecnos[nLinha])
				If RecLock("SZH",.F.)  
					// Exclusao
					If aDados[nLinha][Len(aHeader)+1]
						SZH->( dbDelete() )
						
					// Alteracao
					Else				
						SZH->ZH_BANDEJA := cBandeja
						For nCol := 1 To Len(aHeader)
							nPos := 0
							nPos := aScan( aAlter, { |x|, AllTrim(x) == AllTrim(aHeader[nCol][2]) } )
							If nPos > 0
								nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
								FieldPut(nNrCampo, aDados[nLinha][nCol])
							EndIf
						Next nCol
					EndIf    
					SZH->( MsUnlock() )
				EndIf
				
			// Inclusao
			Else
				If RecLock("SZH",.T.)
					SZH->ZH_CHAPA	:= _cChapa
					SZH->ZH_CLIENTE	:= _cCliente
					SZH->ZH_LOJA	:= _cLoja
					SZH->ZH_CODMAQ	:= _cCodMaq
					SZH->ZH_USUARIO	:= cUserName
					SZH->ZH_DINICIO	:= Date()
					SZH->ZH_VERSAO	:= _cVersao
					SZH->ZH_STATUS	:= "3"
					SZH->ZH_BANDEJA := cBandeja
					
					For nCol := 1 To Len(aHeader)
						nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
						FieldPut(nNrCampo, aDados[nLinha][nCol])
					Next nCol
					SZH->( MsUnlock() )
				EndIf
			EndIf
		Next nI
	EndIf

	// ajuste campos SN1
	For nLinha := 1 To Len(aDados)
		If !aDados[nLinha][Len(aHeader)+1] .And. !Empty(aDados[nLinha][1]) .And. !Empty(aDados[nLinha][2])
			AADD( aMap, aDados[nLinha] )
		EndIf
	Next nLinha	
Next nI

If !lCafe
	ASort( aMap,,,{ |x,y| x[1] < y[1] .And. x[2] < y[2] } )  
	ASort( aMap,,,{ |x,y| x[1] < y[1] .And. x[2] < y[2] } )  
Else
/*	For nI := 1 To Len(aMap)
		aMap[nI][1] := Val(aMap[nI][1]) 
	Next nI*/
	
	ASort( aMap,,,{ |x,y| val(x[1]) < val(y[1]) } )  
		
/*	For nI := 1 To Len(aMap)
		aMap[nI][1] := cvaltochar(aMap[nI][1]) 
	Next nI*/
EndIf

dbSelectArea("SN1")
dbSetOrder(2)
If msSeek( xFilial("SN1") +AvKey(_cChapa,"N1_CHAPA") )
	RecLock("SN1",.F.)
	For nI := 1 To 60
		&("SN1->N1_XP" +cvaltochar(nI)) := ""
	Next nI          
	MsUnLock()
	            
	If nOpc <> 5
		RecLock("SN1",.F.)
		For nI := 1 To Len(aMap)
			lGrava := .T.
			If nI <= 60
				If !lCafe
					&("SN1->N1_XP" +cvaltochar(nI)) := aMap[nI][nPProd]
				Else
					If !Empty(aMap[nI][nPMola]) .And. !Empty(aMap[nI][nPProd])
						// valida acucar - posicao 1 e posicao 2
						cGrupo := Posicione("SB1",1,xFilial("SB1")+AvKey(aMap[nI][nPProd],"B1_COD"),"B1_GRUPO")
						If cGrupo $ "0004#0005#0006" .And. nI <= 2
							&("SN1->N1_XP" +cvaltochar(nI)) := ""
							Loop
						EndIf
				
						If lGrava
							&("SN1->N1_XP" +cvaltochar(aMap[nI][nPMola])) := aMap[nI][nPProd]
						EndIf					
					EndIf
				EndIf
			EndIf
		Next nI          
		MsUnLock()
	EndIf
EndIf


Return lOk