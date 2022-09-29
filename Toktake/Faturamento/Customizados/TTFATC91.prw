#include "protheus.ch"
#include "fwmvcdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC91    บAutor  ณJackson E. de Deusบ Data ณ  16/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Painel de integracao Mobile		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATC91()

Local oBrowse
Private cCadastro := "Integra็ใo mobile"

If cEmpAnt <> "01"
	Return
EndIf


oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZS")
oBrowse:SetDescription(cCadastro)
             
oBrowse:AddLegend("Empty(ZS_CODTEC)","WHITE","Disponํvel")
oBrowse:AddLegend("!Empty(ZS_CODTEC)","GREEN","Em uso")

oBrowse:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef  บAutor  ณJackson E. de Deus   บ Data ณ  12/15/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MenuDef()

Local aRotina	:= {} 
Local cAlias	:= "SZS"
                                               
ADD OPTION aRotina TITLE 'Pesquisar'	ACTION "PesqBrw"							OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'	ACTION "STATICCALL( TTFATC91, Visual, 2 )"	OPERATION 2 ACCESS 0
//ADD OPTION aRotina TITLE 'Incluir'		ACTION "STATICCALL( TTFATC80, Manut, 3 )"	OPERATION 3 ACCESS 0
//ADD OPTION aRotina TITLE 'Alterar'		ACTION "STATICCALL( TTFATC80, Manut, 4 )"	OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'		ACTION "STATICCALL( TTFATC80, Manut, 5 )"	OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Tabelas'		ACTION "STATICCALL( TTFATC91, fTab, 6 )"	OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Imagens'		ACTION "STATICCALL( TTFATC91, fImg, 6 )"	OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Aplicativo'	ACTION "STATICCALL( TTFATC91, fDownApp, 6 )"	OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE "Desvincular"	ACTION "STATICCALL( TTFATC91, fDesV, 6 )"	OPERATION 6 ACCESS 0

                   
Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC91  บAutor  ณMicrosiga           บ Data ณ  02/29/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Visual()

Local aCampos := {"NOUSER","ZS_TIPO","ZS_MARCA","ZS_IDGCM","ZS_CODTEC","ZS_VAPI","ZS_VDROID","ZS_VAPP","ZS_DTREG","ZS_HRREG"}
                        
AxVisual('SZS',Recno(),2,aCampos)    


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC91  บAutor  ณMicrosiga           บ Data ณ  02/25/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTab()


Local oDlgTab
Local oLayer		:= FwLayer():New()
Local aSize			:= MsAdvSize()
Local nOpcClick		:= 0
Local nI
Local aButtons		:= {}
Local aCampos		:= { "M_PROD","M_DESC","M_XSECAOT","M_XFAMLIT","M_XGRUPOT","M_TIPO" }	// B1_XSECAO,B1_XSECAOT,B1_XFAMILI, B1_XFAMLIT,B1_GRUPO, B1_XGRUPOT
Private oList
Private aHeader		:= {}
Private aCols		:= {}
Private _aAlter		:= { /*"M_PROD", */"M_TIPO","M_CAP" }
Private cDirServ	:= "\_mobile\mobile\data\data_tables\"

AADD( aButtons, {"HISTORIC", { || GdSeek( oList , "Busca produto"/* , aHeader , aCols , .T.*/ ) }, "Pesquisa", "Pesquisa" , {|| .T.} } )

//RegToMemory("SB1")
LoadHead(aCampos)

//dbSelectArea("SB1")
oDlgTab := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Tabelas",,,.F.,,,,,,.T.,,,.T. )	
	                  
    oLayer:Init(oDlgTab,.F.)
	oLayer:addLine("LINHA1",88,.F.)
	oLayer:addCollumn('COLUNA1_1',100,.F.,"LINHA1")
  	oLayer:addWindow("COLUNA1_1","WIN_1","Produtos",100,.T.,.F.,{||  },"LINHA1")
	oPnl1 := oLayer:GetWinPanel("COLUNA1_1","WIN_1","LINHA1")
	
	// produtos	
	oList := MsNewGetDados():New(0,0,0,0,GD_DELETE+GD_UPDATE,"AllwaysTrue()","AllwaysTrue()","",_aAlter,0,999,"AllwaysTrue()"/*("STATICCALL( TTFAT11C, VldCpo )"*/,"","AllwaysTrue()",oDlgTab,aHeader,aCols, { || acols := aclone(oList:acols) })
	oList:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	oDlgTab:bStart := { || LJMsgRun("Carregando produtos..","Aguarde...",{ || LoadProd() }) }
		
	EnchoiceBar(oDlgTab,{ || oDlgTab:End(nOpcClick := 1) },{ || oDlgTab:End(nOpcClick := 0)},,@aButtons,,,,.F.,.F.,.T.,.F.,.F.  )
oDlgTab:Activate(,,,.T.)


If nOpcClick == 1
	LJMsgRun("Atualizando tabela..","Aguarde...",{ || UpdTabs() })
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadHead  บAutor  ณJackson E. de Deus  บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o aHeader do grid	                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadHead(aCampos)

Local nI := 0
Local cCampos := ""
      
dbSelectArea("SX3")
dbSetOrder(2)
dbGoTop()

//{ "M_PROD","B1_DESC","B1_XSECAOT","B1_XFAMLIT","B1_XGRUPOT","M_TIPO" }
If MSSeek("B1_COD")
	AADD(aHeader,{"Produto", "M_PROD", SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
		 		"", SX3->X3_USADO, SX3->X3_TIPO, "SB1", SX3->X3_CONTEXT, SX3->X3_CBOX })
EndIf

If MSSeek("B1_DESC")
	AADD(aHeader,{Trim(X3Titulo()), "M_DESC", SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
			 	"", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
EndIf

If MSSeek("B1_XSECAOT")
	AADD(aHeader,{"Secao", "M_XSECAO", SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
		 		"", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
EndIf

If MSSeek("B1_XFAMLIT")
	AADD(aHeader,{"Linha", "M_XFAMLIT", SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
		 		"", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
EndIf

If MSSeek("B1_XGRUPOT")
	AADD(aHeader,{"Categoria", "M_XGRUPOT", SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
		 		"", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
EndIf		 

If MSSeek("B1_XTIPMAQ")
	AADD(aHeader,{"Usa em?", "M_TIPO", SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,"", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
EndIf

AADD(aHeader,{"Qtd - insumo", "M_CAP","@E 999.99", 3,2,"", "S","N", "", "", ""/*,"1"*/ })


Aadd(aHeader, {"Imagem","M_LEG", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})// imagem 

            
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadProd  บAutor  ณJackson E. de Deus  บ Data ณ  25/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os produtos do MIX                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadProd()

Local cQuery	:= ""
Local nI
Local cDirImg	:= "\_mobile\mobile\data\data_img\"
Local nCap		:= 0
      
cQuery := "SELECT B1_COD, B1_DESC, B1_XSECAO,B1_XSECAOT,B1_XFAMILI, B1_XFAMLIT,B1_GRUPO, B1_XGRUPOT, B1_XTIPMAQ, B1_PESBRU FROM " +RetSqlName("SB1")
cQuery += " WHERE B1_XMIXENT = '1' AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY B1_XSECAO, B1_XFAMILI, B1_GRUPO, B1_DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf      

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
dbSelectArea("TRB") 
While !EOF()
        
	nCap := 0
	
	// copo/palheta	
	If (TRB->B1_GRUPO) $ "0070#0071#0072#0108"
		nCap := 0
	Else
		nCap := TRB->B1_PESBRU	
	EndIf
				
	AAdd(aCols, Array(Len(aHeader)+1))
 	nLin := Len(aCols)
	
	aCols[nLin][1] := TRB->B1_COD
	aCols[nLin][2] := TRB->B1_DESC
	aCols[nLin][3] := TRB->B1_XSECAOT
	aCols[nLin][4] := TRB->B1_XFAMLIT
	aCols[nLin][5] := TRB->B1_XGRUPOT
	aCols[nLin][6] := TRB->B1_XTIPMAQ 
	aCols[nLin][7] := nCap
	
	If File( cDirImg +AllTrim(TRB->B1_COD) +".png" )  
		aCols[nLin][8] := "OK"
	Else
		aCols[nLin][8] := "CANCEL"
	EndIf
		
	aCols[nLin][Len(aHeader)+1] := .F.		
	
	dbSkip()
End
TRB->(dbCloseArea())

If Empty(aCols)
	AAdd(aCols, Array(Len(aHeader)+1))
 	nLin := Len(aCols)
	
	aCols[nLin][1] := Space(TamSx3("B1_COD")[1])
	aCols[nLin][2] := Space(TamSx3("B1_DESC")[1])
	aCols[nLin][3] := Space(TamSx3("B1_XSECAOT")[1])
	aCols[nLin][4] := Space(TamSx3("B1_XFAMLIT")[1])
	aCols[nLin][5] := Space(TamSx3("B1_XGRUPOT")[1])
	aCols[nLin][6] := Space(1) 
	aCols[nLin][7] := 0
	aCols[nLin][8] := Space(6)
		
	aCols[nLin][Len(aHeader)+1] := .F.		
EndIf

oList:Acols := aClone(aCols)
oList:Refresh(.T.)
oList:GoTop()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC91  บAutor  ณMicrosiga           บ Data ณ  02/25/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function UpdTabs()

Local nHandle
Local nI
Local cArq := "produtos.csv"
Local cArqCap := "capacidades.json"
Local cTpInsumo := ""
Local aCateg := {}
Local aCat := {}
Local cGrupo := ""
Local cModelo := ""
Local cFamilia := ""
Local aJson := {}
Local oObj

/*
LAYOUT DO ARQUIVO DE TABELA DE PRODUTOS
PRODUTO | DESCRICAO | CODIGO DE BARRAS | TIPO_SERVICO | ORDEM_LISTA | QTD_INSUMO | TIPO_INSUMO
*/

aCateg := { { "copo"		, {"0070","0071","0072"} },;
			{"palheta"		, {"0108"}},;
			{"cafe_grao"	, {"0040"}},;
			{"cafe_soluvel"	, {"0041"}},;
			{"acucar"		, {"0004","0005","0006"}},;
			{"leite"		, {"0096","0097"}},;
			{"chocolate"	, {"0002"}},;
			{"cha"			, {"0052","0053","0054","0055","0056"}}}


If !Empty(oList:aCols)
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	nHandle := FCreate( cDirServ+cArq )
	If nHandle = -1
		MsgAlert("Houve erro ao criar o arquivo!")
		Return
	Else
		For nI := 1 To Len(oList:aCols)
			If oList:aCols[nI][Len(aHeader)+1]
				Loop
			EndIf
			
			cTpInsumo := ""
			
			If MsSeek( xFilial("SB1") +AvKey(oList:aCols[nI][1],"B1_COD") )
				If RecLock("SB1",.F.)
					SB1->B1_XTIPMAQ := AllTrim(oList:aCols[nI][6])
					MsUnLock()
				EndIf
				
				cGrupo := SB1->B1_GRUPO
				For nJ := 1 To Len(aCateg)
					aCat := aclone(aCateg[nJ][2])
					For nK := 1 To Len(aCat)
						If AllTrim(aCat[nK]) == AllTrim(cGrupo)
							cTpInsumo := aCateg[nJ][1]
							Exit
						EndIf
					Next nK
					If !Empty(cTpInsumo)
						Exit
					EndIf
				Next nJ				
			EndIf
			
			If Empty(cTpInsumo)
				cTpInsumo := "X"
			EndIf
			
			FWrite( nHandle, AllTrim( oList:aCols[nI][1] ) +";" ;
							 +AllTrim( oList:aCols[nI][2] ) +";" ;
							 +AllTrim( Posicione("SB1",1,xFilial("SB1")+AvKey(oList:aCols[nI][1],"B1_COD"),"B1_CODBAR") ) + ";" ;
							 +AllTrim( oList:aCols[nI][6] ) +";";							 
							 +CVALTOCHAR(nI) +";" ;
							 +CVALTOCHAR( oList:aCols[nI][7] ) +";" ;
							 +cTpInsumo +IIF(nI<Len(oList:aCols),CRLF,"") )
		Next nI
		
		FClose(nHandle)
	EndIf	
EndIf


// capacidades canister - capacidades padrao e alteradas via premissas
// ZZP
aJson := {}

dbSelectArea("ZZP")
dbGoTop()
While !EOF()
	cModelo := ZZP->ZZP_CODIGO
	cFamilia := Posicione( "SB1",1,xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI" )
	//If MsSeek( xFilial("ZZP") +AvKey(cModelo,"ZZP_CODIGO") )
		dbSelectArea("ZZP") 
		If cFamilia == "153"
			oItem := JsonObject():New()
			oItem:PutVal("modelo", AllTrim(cModelo))
			oItem:PutVal("descricao", AllTrim(ZZP->ZZP_DESC) ) 
			oItem:PutVal("copo", ZZP->ZZP_CAP1)
			oItem:PutVal("palheta", ZZP->ZZP_CAP2)
			oItem:PutVal("cafe_grao", ZZP->ZZP_CAP3)
			oItem:PutVal("cafe_soluvel", ZZP->ZZP_CAP4)
			oItem:PutVal("acucar", ZZP->ZZP_CAP5)
			oItem:PutVal("leite", ZZP->ZZP_CAP6)
			oItem:PutVal("chocolate", ZZP->ZZP_CAP7)
			oItem:PutVal("cha", ZZP->ZZP_CAP8)
			AADD(aJson,oItem) 
		EndIf

	//EndIf
	ZZP->(dbSkip())
End

If !Empty(aJson)
	oObj := JsonObject():New()
	oObj:PutVal("capacidades",aJson)
	
	cJson := oObj:ToJson()
	
	If Empty(cJson)
		MsgAlert("Houve erro ao gerar o arquivo com as capacidades de canister!")
	Else 	        
		nPosC := At("[", cJson) 
		cJson := SubStr( cJson,nPosC,Len(cJson)  )
		cJSon := SubStr( cJson,1, Len(cJson)-1 )
		MEMOWRITE( cDirServ+cArqCap, cJson )
	EndIf
EndIf

/*
Modelo;Copos;Palheta;Caf้ Grใo;Caf้ soluvel;A็ucar;Leite;Chocolate;Chแ
Europa E;600;600;3,5;2;5;2;3,5;4,4
Sagoma E;400;400;3,5;2;5;2;3,5;4,4
Sagoma H;400;0;0;2;5;2;3,5;4,4
XM E;240;240;1,5;0;2,0 Peq;0,7 Peq;1,5 Peq/ 3,1 Gde;2,0 Peq
XM H;240;0;0;0,5 Peq;2,0 Peq;0,7 Peq;1,5 Peq/ 3,1 Gde;2,0 Peq
XS E;0;0;0,7;0;0;0,38 Peq/ 0,80 Gde;0,94 Peq/ 2,2 Gde;0
XS H;0;0;0;0,33 Peq/ 0,76 Gde;1,2 Peq;0,38 Peq/ 0,80 Gde;0,94 Peq/ 2,2 Gde;0,98 Peq
Mini E;0;0;0,65;0;0;0,38 Peq/ 0,80 Gde;0,94 Peq/ 2,2 Gde;0
Mini H;0;0;0;0,33 Peq/ 0,76 Gde;0;0,38 Peq/ 0,80 Gde;0,94 Peq/ 2,2 Gde;0
Bari;0;0;0,5;0;0;0;0;0
*/

Return
 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfImg  บAutor  ณJackson E. de Deus      บ Data ณ  25/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizacao de imagens                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fImg()

Local oDlgImg
Local oLayer		:= FwLayer():New()
Local aSize			:= MsAdvSize()
Local aImg2			:= {}
Local nOpcClick		:= 0
Local nI
Local aButtons		:= {} //{ {"HISTORIC", { || CfgImg() }, "Imagens", "Imagens" , {|| .T.} } }
Private cType		:= "Arquivo PNG (*.PNG) |*.png|" 
Private cDirLocal	:= ""
Private cDirServ	:= "\_mobile\mobile\data\data_img\"
Private aImgLocal	:= {}
Private aImgServ	:= {}

AADD( aButtons, {"HISTORIC", { || CfgImg() }, "Imagens", "Imagens" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || IIF(Marc(1),MsAguarde( { || TransfArq(1)  },"Enviando.." ),MsgInfo("Nenhum arquivo selecionado!") ) }, "Enviar", "Enviar" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || IIF(Marc(2),MsAguarde( { || TransfArq(2)  },"Recebendo.." ),MsgInfo("Nenhum arquivo selecionado!") )  }, "Receber", "Receber" , {|| .T.} } )


// imagens servidor
aImg2 := Directory(AllTrim(cDirServ)+"*.png")
For nI := 1 To Len(aImg2)
	AADD( aImgServ, { .T., aImg2[nI][1] } )
Next nI


If Empty(aImgLocal)
	AADD( aImgLocal, { .F., "" } )
EndIf             
If Empty(aImgServ)
	AADD( aImgServ, { .F., "" } )
EndIf  


oDlgImg := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Imagens",,,.F.,,,,,,.T.,,,.T. )	
	                  
    oLayer:Init(oDlgImg,.F.)
	oLayer:addLine("LINHA1",88,.F.)
	oLayer:addCollumn('COLUNA1_1',50,.F.,"LINHA1")
	oLayer:addCollumn('COLUNA1_2',50,.F.,"LINHA1")

  	oLayer:addWindow("COLUNA1_1","WIN_1","Imagens local",100,.T.,.F.,{||  },"LINHA1")
  	oLayer:addWindow("COLUNA1_2","WIN_2","Imagens servidor",100,.T.,.F.,{|| },"LINHA1")

	oPnl1 := oLayer:GetWinPanel("COLUNA1_1","WIN_1","LINHA1")
	oPnl2 := oLayer:GetWinPanel("COLUNA1_2","WIN_2","LINHA1")   

	// imagens local	 linha coluna largura altura
	oListBox := TCBrowse():New(0,0,0,0,,{"","Imagem"},{5,100},oPnl1,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.)
	oListBox:Align := CONTROL_ALIGN_ALLCLIENT
	oListBox:SetArray(aImgLocal)
	oListBox:bLine := {||{ 	IIf(aImgLocal[oListBox:nAt][1],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
								aImgLocal[oListBox:nAt][2] }}
	
	oListBox:bLDblClick := { || aImgLocal[oListBox:nAt,1] := !aImgLocal[oListBox:nAt,1], oListBox:Refresh() }
	oListBox:nScrollType := 1						
	
	// imagens servidor                                 
	oListBox2 := TCBrowse():New(0,0,0,0,,{"","Imagem"},{5,100},oPnl2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.)
	oListBox2:Align := CONTROL_ALIGN_ALLCLIENT
	oListBox2:SetArray(aImgServ)
	oListBox2:bLine := {||{ 	IIf(aImgServ[oListBox2:nAt][1],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
								aImgServ[oListBox2:nAt][2] }}
	oListBox2:bLDblClick := { || aImgServ[oListBox2:nAt,1] := !aImgServ[oListBox2:nAt,1], oListBox2:Refresh() }							
	oListBox2:nScrollType := 1
		
	// acoes
	//oBtEnv	:= TBtnBmp2():New( aSize[6]-65, aSize[5]-40, 40, 40, 'RIGHT' , , , ,{ || IIF(Marc(1),MsAguarde( { || TransfArq(1)  },"Enviando.." ),MsgInfo("Nenhum arquivo selecionado!") )  } , oDlgImg, "Enviar" , ,)
	//oBtRec	:= TBtnBmp2():New( aSize[6]-65, aSize[5]+7, 40, 40, 'LEFT' , , , ,{ || IIF(Marc(2),MsAguarde( { || TransfArq(2)  },"Recebendo.." ),MsgInfo("Nenhum arquivo selecionado!") )  }, oDlgImg, "Receber" , ,)	
	EnchoiceBar( oDlgImg,{ || oDlgImg:End()  },{ || oDlgImg:End(nOpcClick := 0)},,@aButtons,,,.F.,.F.,.F.,.F.,.F. )
oDlgImg:Activate(,,,.T.)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCfgImg  บAutor  ณJackson E. de Deus    บ Data ณ  16/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CfgImg()

Local aImg := {}

// imagens local
cDirLocal := cGetFile(cType, OemToAnsi("Selecione o local com as imagens"), 0, "C:\", .T., GETF_LOCALHARD +GETF_NETWORKDRIVE +GETF_RETDIRECTORY  , .F., .F.)          
If Empty(cDirLocal)
	MsgAlert("Nenhum local vแlido foi escolhido!")
	Return
EndIf
 
aImg := Directory(AllTrim(cDirLocal)+"*.png")
If !Empty(aImg)
	aImgLocal := {}
	For nI := 1 To Len(aImg)
		AADD( aImgLocal, { .T., aImg[nI][1] } )
	Next nI	
EndIf

If !Empty(aImgLocal)
	oListBox:SetArray(aImgLocal)
	oListBox:bLine := {||{ 	IIf(aImgLocal[oListBox:nAt][1],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
								aImgLocal[oListBox:nAt][2] }}
	oListBox:nScrollType := 1
	oListBox:Refresh(.T.)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTransfArq  บAutor  ณJackson E. de Deus บ Data ณ  16/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Transferencia das imagens                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TransfArq(nOpc)

Local nEnv := 0
Local nRec := 0
Local aImg := {}
Local aImg2 := {}
Local nI
//	cDirServ		

// envia
If nOpc == 1
	For nI := 1 To Len(aImgLocal)
		If aImgLocal[nI][1]
			MsProcTXT(aImgLocal[nI][2])
			If CpyT2S(cDirLocal+aImgLocal[nI][2],cDirServ)             
				nEnv++
			EndIf             
		EndIf
	Next nI

// recebe
Else
	For nI := 1 To Len(aImgServ)
		If aImgServ[nI][1]
			MsProcTXT(aImgServ[nI][2])
			If CpyS2T(cDirServ +aImgServ[nI][2],cDirLocal)   
				nRec++
			EndIf
		EndIf
	Next nI
EndIf

// refresh janela servidor
If nEnv > 0
	aImg2 := Directory(AllTrim(cDirServ)+"*.png")
	If !Empty(aImg2)
		aImgServ := {}
		For nI := 1 To Len(aImg2)
			AADD( aImgServ, { .T., aImg2[nI][1] } )
		Next nI        
	EndIf
	
	If !Empty(aImgServ)
		oListBox2:SetArray(aImgServ)
		oListBox2:bLine := {||{ 	IIf(aImgServ[oListBox:nAt][1],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
									aImgServ[oListBox:nAt][2] }}
		oListBox2:nScrollType := 1
		oListBox2:Refresh(.T.)
	EndIf
	MsgInfo("Quantidade enviada: " +cvaltochar(nEnv))
EndIf

// refresh janela local
If nRec > 0
	aImg := Directory(AllTrim(cDirLocal)+"*.png")
	If !Empty(aImg)
		aImgLocal := {}
		For nI := 1 To Len(aImg)
			AADD( aImgLocal, { .T., aImg[nI][1] } )
		Next nI	
	EndIf
	
	If !Empty(aImgLocal)
		oListBox:SetArray(aImgLocal)
		oListBox:bLine := {||{ 	IIf(aImgLocal[oListBox:nAt][1],LoadBitmap( GetResources(), "LBOK" ),LoadBitmap( GetResources(), "LBNO" )),;
									aImgLocal[oListBox:nAt][2] }}
		oListBox:nScrollType := 1
		oListBox:Refresh(.T.)
	EndIf
	MsgInfo("Quantidade recebida: " +cvaltochar(nRec))
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarc  บAutor  ณJackson E. de Deus      บ Data ณ  16/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marca os arquivos                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Marc(nOPc)

Local lRet := .T.
Local nMarc := 0
Local nI

// local
If nOpc == 1
	For nI := 1 To Len(aImgLocal)
		If aImgLocal[nI][1]
			nMarc++
		EndIf
	Next nI
// servidor
Else
	For nI := 1 To Len(aImgServ)
		If aImgServ[nI][1]
			nMarc++
		EndIf
	Next nI
EndIf

If nMarc == 0
	lRet := .F.
EndIf

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDownApp  บAutor  ณJackson E. de Deus  บ Data ณ  09/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Download do App                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDownApp()

Local cDirServ	:= "\_mobile\mobile\data\"
Local cNomeApp	:= "tokapp.apk"
Local cType		:= "Arquivo APK (*.APK) |*.apk|" 
Local cDirLocal	:= ""

If !File(cDirServ + cNomeApp)
	MsgInfo("Aplicativo nใo encontrado no diret๓rio.")
	Return
EndIf
         
cDirLocal := cGetFile(cType, OemToAnsi("Selecione o local para download"), 0, "C:\", .T., GETF_LOCALHARD +GETF_NETWORKDRIVE +GETF_RETDIRECTORY  , .F., .F.)          
If Empty(cDirLocal)
	MsgAlert("Nenhum local vแlido foi escolhido!")
	Return
EndIf

If CpyS2T(cDirServ +cNomeApp,cDirLocal) 
	MsgInfo("Download realizado no diret๓rio escolhido.")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC91  บAutor  ณMicrosiga           บ Data ณ  07/13/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesV()

If MsgYesNo("Confirma a desvincula็ใo do atendente nesse aparelho? Cuidado - Qualquer Ordem de Servi็o pendente no aparelho nใo serแ recebida no sistema.")
	RecLock("SZS",.F.)
	SZS->ZS_CODTEC := ""
	MsUnlock()
EndIf


Return