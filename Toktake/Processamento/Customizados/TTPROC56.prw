#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC56  บAutor  ณJackson E. de Deus  บ Data ณ  01/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prestacao de contas - validacao de contadores              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
controle flag szn   
ZN_VALIDA
gravacao do registro -> S
invalidar registro -> X
validar registro -> O
*/

User Function TTPROC56()

Local aArea						:= GetArea()
Local nOpcao					:= 0                                    
Local aDimension				:= MsAdvSize()
Local nWdtRdp					:= aDimension[5]/2
Local aAlter					:= {"T_QTD2"}
Local aRet						:= {}
Local aPergs					:= {} 
Private oLayer					:= FwLayer():New()
Private cRota					:= ""
Private _dDtIni					:= stod("")
Private _dDtFim					:= stod("")
Private aHeader					:= {}
Private aCols					:= {}
Private oList1,oList2,oList3
//Private aList1					:= {} 
Private aList2					:= {} 
Private aList3					:= {}  
Private aList4					:= {}
Private aList3Bk				:= {}
Private aList2Bkp				:= {}
Private aList3Bkp				:= {}
Private aL3B					:= {}
Private oDlg1,oGrp1,oBrw1,oGrp2,oBrw2,oGrp3,oBrw3,oBtn1,oBtn2,oMenu
Private oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11,oSay12,oSay13
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')
Private oAma   	:= LoadBitmap(GetResources(),'br_amarelo')
Private oBranco	:= LoadBitmap(GetResources(),'br_branco')
Private aContad	:=		{}
Private aOS		:=		{} 
Private aEstru	:=		{}
Private aAbZ0Ant := {}
Private aAbastz0:=		{}
Private aSubEst	:=		{}

If cEmpAnt <> "01"
	return
EndIF

aAdd(aPergs ,{1,"Rota/PA ?"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",6,.F.}) 
If !ParamBox(aPergs ,"Presta็ใo de Contas",@aRet)
	Return
EndIf     
cRota := aRet[1]

If Empty(cRota)
	Return
EndIf


CursorWait()
Processa( { || PreAcols() },"Aguarde...")
CursorArrow()

If Len(aList2) == 0
	Return
EndIf

If len(aList3) == 0
	Aadd(aList3,{'','','','','','','','',''})
EndIf

LoadHead()

oDlg1      := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Presta็ใo de Contas - " +cRota,,,.F.,,,,,,.T.,,,.T. )

    oDlg1:lEscClose := .F.
	oDlg1:lMaximized := .T.

	oPanel3 := tPanel():New(0,0,"",oDlg1,,,,,,0,40)
	//oPanel3:SetCss( "QLabel { background-color: #E1E1E1; }" )	
	oPanel3:align := CONTROL_ALIGN_BOTTOM
                                                               
    oLayer:Init(oDlg1,.F.)
	oLayer:addLine("LINHA1",50,.F.)
	oLayer:addLine("LINHA2",50,.F.)
	
	oLayer:addCollumn('COLUNA1_1',100,.F.,"LINHA1")
	oLayer:addCollumn('COLUNA1_2',50,.F.,"LINHA2")
	oLayer:addCollumn('COLUNA2_2',50,.F.,"LINHA2")

  	oLayer:addWindow("COLUNA1_1","WIN_1","Valida็๕es dos apontamentos",100,.F.,.T.,{||},"LINHA1")
  	oLayer:addWindow("COLUNA1_2","WIN_2","Vendas",100,.F.,.T.,{||},"LINHA2")
  	oLayer:addWindow("COLUNA2_2","WIN_3","Ingredientes",100,.F.,.T.,{||},"LINHA2")
                                                     
	oPnl := oLayer:GetWinPanel("COLUNA1_1","WIN_1","LINHA1")
	oPnl1 := oLayer:GetWinPanel("COLUNA1_2","WIN_2","LINHA2")
	oPnl2 := oLayer:GetWinPanel("COLUNA2_2","WIN_3","LINHA2")
	
	// validacoes
	oList2 := TCBrowse():New(0,0,0,0,,,,oPnl,,,,{ || Processa( { || fHelp(oList2:nAt) },"Aguarde..." ) },{ || editcol(oList2:nAt) },,,,,,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aList2)
	
	oList2:AddColumn(TCColumn():New('OS/Patrimonio/Cliente'	,{|| aList2[oList2:nAt,01] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Atendente'				,{|| aList2[oList2:nAt,02] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Data'					,{|| aList2[oList2:nAt,03] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList2:AddColumn(TCColumn():New('V1'					,{|| aList2[oList2:nAt,04] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('V2'					,{|| aList2[oList2:nAt,05] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('V3'					,{|| aList2[oList2:nAt,06] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('V4'					,{|| aList2[oList2:nAt,07] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('V5'					,{|| aList2[oList2:nAt,08] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	//oList2:AddColumn(TCColumn():New('V6'					,{|| aList2[oList2:nAt,09] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	//oList2:AddColumn(TCColumn():New('V7'					,{|| aList2[oList2:nAt,10] },"@BMP",,,,20,.T.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Resultado'				,{|| aList2[oList2:nAt,11] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Venda'					,{|| aList2[oList2:nAt,13] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Abastec.'				,{|| aList2[oList2:nAt,12] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 	
	oList2:AddColumn(TCColumn():New('Estoque N'				,{|| aList2[oList2:nAt,14] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	//oList2:AddColumn(TCColumn():New('Cons. M้dio'			,{|| aList2[oList2:nAt,15] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Or็amento PE'			,{|| aList2[oList2:nAt,18] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList2:AddColumn(TCColumn():New('Or็amento PP'				,{|| aList2[oList2:nAt,19] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 

	oList2:nScrollType := 1	 	
	oList2:align := CONTROL_ALIGN_ALLCLIENT
	
	// Menu popup grid 1
	MENU oMenu POPUP 
	MENUITEM "Zerar Registro" ACTION ( ZeraReg(aList2[oList2:nAt][17]) )
	ENDMENU                                                                           

	oList2:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }		 	
                   
    // CONTADORES - ajustes
    oGetDB := MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE,"AllwaysTrue()","AllwaysTrue()","",aAlter,0,99,'STATICCALL(TTPROC56,VldCampo)','','AllwaysTrue()',oPnl1,aHeader,aCols,{ || /*GravaSZN()*/ })
	oGetDB:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
    
    // INGREDIENTES
	oList3 := TCBrowse():New(0,0,0,0,, {"Ingrediente","Estoque inicial",'Conversใo Venda','Abastecido','Adi็ใo Liq.','Estoque Final'},{140,40,60,40,40,40},;
	                            oPnl2,,,,{ || },{ || },, ,,,  ,,.F.,,.T.,,.F.,,,)

 	oList3:nScrollType := 1                    	
	oList3:align := CONTROL_ALIGN_ALLCLIENT
	
	
	oList4 := TCBrowse():New(0,0,0,0,, {"Mola","Produto","Estoque inicial","Retirado","Avaria","Venda","Abastecido","Adi็ใo Liq.","Estoque Final","Capacidade"},{140,40,60,40,40,40,40,40,40,15},;
	                            oPnl2,,,,{ || },{ || },, ,,,  ,,.F.,,.T.,,.F.,,,)

 	oList4:nScrollType := 1                    	
	oList4:align := CONTROL_ALIGN_ALLCLIENT
	
	oList4:Hide()
			                     	
    
    oSay1      := TSay():New( 0,004,{ || "Descri็ใo dos Tipos de Valida็๕es" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,152,008)
    oSay2      := TSay():New( 10,004,{ || "V1 - Cash Atual - Cash Anterior >= 0" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
    oSay3      := TSay():New( 20,004,{ || "V2 - Sale Atual - Sale Anterior >= 0" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
    oSay4      := TSay():New( 30,004,{ || "V3 - Soma Ps Atual - Soma Ps Ant. >= 0" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
    oSay5      := TSay():New( 10,124,{ || "V4 - V3 = V2" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
    oSay6      := TSay():New( 20,124,{ || "V5 - R$ Venda X V3 = V1" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
    //oSay7      := TSay():New( 30,124,{ || "V6 - Saldo Anterior - Saldo Atual + Abastecido" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
	//oSay8      := TSay():New( 10,254,{ || "V7 - V6 > Capacidade da Mola" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
	oSay9      := TSay():New( 20,254,{ || "Resultado - Correspondente de V1 a V5" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
    oSay10     := TSay():New( 30,254,{ || "Abastec. - Total em qtd de mercadorias" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
	oSay11     := TSay():New( 10,364,{ || "Adi็ใo Lq - Sld Atual - Anterior + (Abast.+Avaria+Descarte)" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,172,008)
	oSay12     := TSay():New( 20,364,{ || "Estoque N - Total de mercadorias no Patrim๔nio" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
	oSay13     := TSay():New( 30,364,{ || "Cons. M้dio - geral por mแquina" },oPanel3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,152,008)
		

	//oBtn0      := TButton():New( 0 , nWdtRdp-80,"Fechamento",oPanel3,{|| U_TTPROC57(cRota) /*RetRota(1)*/ },037,012,,,,.T.,,"",,,,.F. )
	oBtn1      := TButton():New( 0 ,nWdtRdp-40,"Or็amentos",oPanel3,{ || IIF(MsgYesNo("Confirma a gera็ใo dos or็amentos?"),Processa({ || Orcmto() },"Or็amentos..") ,/**/) },037,012,,,,.T.,,"",,,,.F. )
	oBtnC      := TButton():New( 20 ,nWdtRdp-80,"Capacidade",oPanel3,{ || CapCnster() },037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 20 ,nWdtRdp-40,"Sair",oPanel3,{ || oDlg1:end() },037,012,,,,.T.,,"",,,,.F. )
     	
oDlg1:Activate(,,,.T.)

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC56  บAutor  ณMicrosiga           บ Data ณ  10/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CapCnster()

Local oTela
Local aDimension := MsAdvSize()
Local nI
Local aCapac := {}
Local cArqCnf := "\system\canister_maquinas.csv"
Local aLinArq := {}
Local nLinha := 0  
Local aCabec := {}
Local aTaM := {} 
Local cModelo := ""
Local cNumOS := AllTrim( StrToKarr( aList2[oList2:nAt,01],"/" )[1] )

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	cModelo := AllTrim(SZG->ZG_PATRIMD)
EndIf


/*
Europa 
Sagoma
XM
XS
MINI
BARI      
*/

/*
CAFE GRAO
CAFE SOLUVEL
ACUCAR
LEITE
CHOCOLATE
CHA
PALHETA
COPO
*/

If !File(cArqCnf)
	MsgAlert("O arquivo de configura็๕es da capacidade das mแquinas nใo foi encontrado! Verifique com o Depto de Opera็๕es.")
	Return
EndIf

// carregar o arquivo txt com a configuracao
nHandle := FT_FUse(cArqCnf)
If nHandle == -1
	ApMsgStop("Erro na abertura do arquivo de configura็๕es -> " +Str(Ferror()))
	Return
EndIf

FT_FGoTop()     
While !FT_FEOF()
	aLinArq := StrToKarr(FT_FReadLn(),";")
	  
	If nLinha == 0
		aCabec := aClone(aLinArq)
		aTam := Array(Len(aCabec))
		For nI := 1 To Len(aTaM)
			aTam[nI] := 50
		Next nI
	Else
		AADD( aCapac, aLinArq  )	
	EndIf
	
	
	FT_FSKIP()
	nLinha++
End
FT_FUSE()
  
/*
aCapac := { { "CAFE GRAO"	,0,0,0,0,0,0 },;
			{ "CAFE SOLUVEL",0,0,0,0,0,0 },;
			{ "ACUCAR"		,0,0,0,0,0,0 },;
			{ "LEITE"		,0,0,0,0,0,0 },;
			{ "CHOCOLATE"  /	,0,0,0,0,0,0 },;
			{ "CHA"			,0,0,0,0,0,0 },;
			{ "PALHETA"		,0,0,0,0,0,0 },;
			{ "COPO"		,0,0,0,0,0,0 }}
*/

  

For nI := 1 To Len(aDimension)
	aDimension[nI] := aDimension[nI] * 0.7
Next nI

oTela := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Capacidades",,,.F.,,,,,,.T.,,,.T. )

	oPn1 := tPanel():New(0,0,"",oTela,,,,,,0,20)
	oPn1:align := CONTROL_ALIGN_TOP          
	
	oPn2 := tPanel():New(0,0,"",oTela,,,,,,0,0)
	oPn2:align := CONTROL_ALIGN_ALLCLIENT
	
	oImg := TBitmap():New(005,005,20,20,"UP",,.T.,oPn1,{||},,.F.,.F.,,,.F.,,.T.,,.F.)	   	          
	
	oSay1 := TSay():New( 005,025,{ || "Capacidades das mแquinas" },oPn1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,152,012)
	oSay1:SetCss( "QLabel {font: bold 12px; color: #0174DF; }" )
	
	oSay2 := TSay():New( 005,250,{ || cModelo },oPn1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,152,012)
	oSay2:SetCss( "QLabel {font: bold 12px; color: #FF1A75; }" )

	oLstCp := TCBrowse():New(0,0,0,0,, aCabec/*{"Produto","Europa","Sagoma","XM","XS","Mini","Bari" }*/,aTam/*{100,30,30,30,30}*/, oPn2,,,,{ || },{ || },,,,,,,.F.,,.T.,,.F.,,,)
	oLstCp:SetArray(aCapac)
	oLstCp:Align := CONTROL_ALIGN_ALLCLIENT


	oLstCp:AddColumn( TCColumn():New( "Modelo"			,{ || aCapac[oLstCp:nAt][1] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )
	oLstCp:AddColumn( TCColumn():New( "Copos"			,{ || aCapac[oLstCp:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )
	oLstCp:AddColumn( TCColumn():New( "Palheta"			,{ || aCapac[oLstCp:nAt][3] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )
	oLstCp:AddColumn( TCColumn():New( "Caf้ grใo"		,{ || aCapac[oLstCp:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )
	oLstCp:AddColumn( TCColumn():New( "Caf้ sol๚vel"	,{ || aCapac[oLstCp:nAt][5] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )	                                                                                              
	oLstCp:AddColumn( TCColumn():New( "A็๚car"			,{ || aCapac[oLstCp:nAt][6] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )	                                                                                              	
	oLstCp:AddColumn( TCColumn():New( "Leite"			,{ || aCapac[oLstCp:nAt][7] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )	                                                                                              		
	oLstCp:AddColumn( TCColumn():New( "Chocolate"		,{ || aCapac[oLstCp:nAt][8] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )	                                                                                              		
	oLstCp:AddColumn( TCColumn():New( "Chแ"				,{ || aCapac[oLstCp:nAt][9] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,) )	                                                                                              			
	 	     		
oTela:Activate(,,,.T.)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOrcmto  บAutor  ณMicrosiga           บ Data ณ  07/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Orcmto()

Local aArea := GetArea()
Local nI
Local nJ
Local nX
Local cQuery := ""  
Local aAx := {} 
Local cNumOS := ""
Local aRet := {}
Local cTabela := ""
Local cProd := ""  
Local nPE := 0
Local nPP := 0
Local cMaquina := ""
Local aProblem := {} 
Local aPRC := {0,0}
Local cGrupo := ""     

// COLOCAR BLOQUEIO - VALIDAR PRODUTOS X PRECO
// todos os produtos do mapa devem ter preco PE ou preco PP
ProcRegua(Len(aList2))
dbSelectArea("SZG")
dbSetOrder(1)

For nX := 1 To Len(aList2)
	aAx := StrToKarr( aList2[nX][1], "/" )
	cNumOS := AllTrim(aAx[1])
	cTabela := ""
	cMaquina := ""
	
	If !Empty(aList2[nX][17])
		dbSelectArea("SZN")
		dbGoTo(aList2[nX][17])
		If Recno() == aList2[nX][17] .And. AllTrim(SZN->ZN_VALIDA) == "X" //.Or. !SZN->ZN_TIPINCL $ "SANGRIA#AUDITORIA"
			Loop
		EndIf
	EndIf
			
	dbSelectArea("SZG")
	If MsSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
		cTabela := SZG->ZG_TABELA
		cMaquina := SZG->ZG_PATRIM
		
		If Empty(cTabela)
			dbSelectArea("SN1")
			dbSetOrder(2)
			If msSeek( xFilial("SN1") +AvKey(SZG->ZG_PATRIM,"N1_CHAPA") )
				cTabela := SN1->N1_XTABELA
			EndIf
			dbSelectArea("SZG")
		EndIf
		
		For nI := 1 To Len(aContad)
			If AllTrim(aContad[nI][2]) <> AllTrim(cNumOS)
				Loop
			EndIf
			
			For nJ := 10 To Len(aContad[nI])
				cProd := aContad[nI][nJ][4]
				If Empty(cProd)
					Loop
				EndIf
				
				cGrupo := Posicione("SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_GRUPO")
				If cGrupo $ "0004#0005#0006"
					Loop
				EndIf
								
				cDescProd := AllTrim( Posicione("SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_DESC") )
				
				If !Empty(cTabela)
					aPRC := fPRC(cTabela,cProd) 
				EndIf                          
				nPE := aPRC[1]
				nPP := aPRC[2] 
				
				If nPE == 0 .And. nPP == 0
					AADD( aProblem, { cMaquina, cTabela, cProd, cDescProd, nPE, nPP } )
				EndIf			
			Next nJ
		Next nI
	EndIf	
Next nX
                                                                          
If !Empty(aProblem) 
	cTxt := "Corrigir tabela de pre็o: " +CRLF
	For nI := 1 To Len(aProblem)
		cTxt += "Mแquina: " +aProblem[nI][1] +" - Tabela: " +aProblem[nI][2] +" - Produto: " +aProblem[nI][3] +" " +aProblem[nI][4] +CRLF
	Next nI        
	MsgAlert(cTxt)
	RestArea(aArea)
	Return
EndIf

//aTabPrc := STATICCALL( TTFAT20C, TabPrc, cTabela, aItens )

ProcRegua(Len(aList2))
For nI := 1 To Len(aList2)
	aAx := StrToKarr( aList2[nI][1], "/" )
	cNumOS := AllTrim(aAx[1])
	IncProc("OS " +cNumOS) 

	If !Empty(aList2[nI][17])
		dbSelectArea("SZN")
		dbGoTo(aList2[nI][17])
		If Recno() == aList2[nI][17] .And. AllTrim(SZN->ZN_VALIDA) <> "X"
			RecLock("SZN",.F.)
			SZN->ZN_VALIDA := "O" // O == OK
			MsUnLock()            
			
			//If ! SZN->ZN_TIPINCL $ "SANGRIA#AUDITORIA"
				aRet := StaticCall( TTPROC25, Fatura, cNumOS )	// gerar orcamento e pedido somente para lancamentos validos			
				aList2[nI][18] := aRet[1] 
				aList2[nI][19] := aRet[2]
			//EndIf
		EndIf
	EndIf
Next nI

RestArea(aArea)


//oDlg1:end()
oList2:Refresh(.T.)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZeraReg  บAutor  ณMicrosiga           บ Data ณ  07/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ZeraReg(nRecZN)

//Local nRecZN := aList2[nLinha][17]
Local aArea := GetArea()

              
dbSelectArea("SZN")
dbGoTo(nRecZN)
If Recno() == nRecZN
	// invalido
	If AllTrim(SZN->ZN_VALIDA) == "X"
		MsgAlert("Registro jแ marcado como invแlido.")
	// ok
	ElseIf AllTrim(SZN->ZN_VALIDA) == "O"
		MsgAlert("Registro jแ marcado como OK, nใo pode ser invalidado.")
	// validar ainda
	ElseIf AllTrim(SZN->ZN_VALIDA) == "S"
		If !MsgYesNo("Deseja marcar esse lan็amento como invแlido?" +CRLF +"O lan็amento continuarแ existindo por้m os seus contadores nใo serใo considerados para cแlculos.")
			Return
		EndIf
		RecLock("SZN",.F.)
		SZN->ZN_VALIDA := "X"	// desconsiderar contadores desse registro -> X == INVALIDO | O == OK
		MsUnLock()
		MsgInfo("Contador invalidado.")
	EndIf
EndIf

RestArea(aArea)

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC56  บAutor  ณMicrosiga           บ Data ณ  06/30/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadHead()

// posicao
AADD(aHeader,{"Posi็ใo","T_POS","@!",2,0,"","","C","","R" } )

// produto                                                             
AADD(aHeader,{"Produto","T_COD","@!",8,0,"","","C","","R" } )

// desc prod
AADD(aHeader,{"Descri็ใo","T_DESC","@!",20,0,"","","C","","R" } )

// Qtd vendida anterior
AADD(aHeader,{"Qtd Ant","T_QTDX",PesqPict("SZN","ZN_BOTAO01"),5,0,"","","N","","R" } )
          
// Qtd vendida            
AADD(aHeader,{"Qtd Atu","T_QTD1",PesqPict("SZN","ZN_BOTAO01"),5,0,"","","N","","R" } ) 

// diferenca
AADD(aHeader,{"Diferen็a","T_DIF",PesqPict("SZN","ZN_BOTAO01"),5,0,"","","N","","R" } ) 

// PE
AADD(aHeader,{"PE","T_PE",PesqPict("DA1","DA1_XPRCPP"),5,0,"","","N","","R" } ) 

// PP
AADD(aHeader,{"PP","T_PP",PesqPict("DA1","DA1_XPRCPP"),5,0,"","","N","","R" } ) 
              
// Nova Qtd            
AADD(aHeader,{"Nova Qtd","T_QTD2","@E 9,999,999",5,0,"","","N","","R" } )            
            
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCampo  บAutor  ณJackson E. de Deus  บ Data ณ  07/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao de campo                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldCampo()
           
Local lRet := .T.                     
Local aArea := GetArea()
Local nLinha := oGetDB:nAt
Local nRecZN := alist2[oList2:nAt][17]
Local cPosicao := PadL( oGetDB:aCols[nLinha][1], 2, "0" )   
Local lExistOrc := .F.
Local lExistPed := .F.
Local cPedFech	:= ""
Local aResultado := {0,0,0,0,0,0}


If __readvar == "M->T_QTD2"
	If M->T_QTD2 <> oGetDB:Acols[nLinha][5]
		dbSelectArea("SZN")
		dbGoTo(nRecZN)
		If Recno() == nRecZN
			STATICCALL( TTFAT20C,ChkProc,SZN->ZN_NUMOS,@lExistOrc,@lExistPed, @cPedFech )
			If (lExistOrc .And. !Empty(cPedFech))	// .Or. lExistPed
				MsgAlert("Jแ existe or็amento gerado para esses contadores e pedido de fechamento. Nใo serแ possํvel alterar.")
				lRet := .F.
			Else
				If RecLock("SZN",.F.)
					// numerador atual
					If AllTrim(cPosicao) == "0W"
						SZN->ZN_NUMATU := M->T_QTD2
					// cash	
					ElseIf AllTrim(cPosicao) == "0X"
						SZN->ZN_COTCASH := M->T_QTD2
					// testes
					ElseIf AllTrim(cPosicao) == "0Y"
						SZN->ZN_BOTTEST := M->T_QTD2
					// parcial
					ElseIf AllTrim(cPosicao) == "0Z"
						SZN->ZN_PARCIAL := 	M->T_QTD2			
					// botoes - 1 - 60
					Else
						&("SZN->ZN_BOTAO"+CVALTOCHAR(cPosicao)) := M->T_QTD2
					EndIf
					
					// atualizar calculos de contatores e cash
					aResultado[1] := SZN->ZN_COTCASH
					aResultado[2] := SZN->ZN_NUMATU
					
					For nXttz := 1 To 60
				 		aResultado[3] += &("SZN->ZN_BOTAO"+strzero(nXttz,2))
				 	Next nXttz
			
					//aResultado := STATICCALL( TTPROC25, BuscaAnt, SZN->ZN_PATRIMO,aResultado,Recno(),SZN->ZN_DATA )
							
					/*SZN->ZN_RESCASH	:= aResultado[1] - aResultado[4]
					SZN->ZN_RESSALE	:= aResultado[2] - aResultado[5] 
					SZN->ZN_RESCONT	:= aResultado[3] - aResultado[6]*/
					
					SZN->(MsUnLock())
				EndIf
				If lExistOrc
					MsAguarde({ || U_TTFAT20C(SZN->ZN_NUMOS,.T.) },"Aguarde, atualizando or็amento...")
				EndIf
			EndIf
		
		EndIf
	EndIf
EndIf

Restarea(aArea)

Return lRet

                                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPreAcols  บAutor  ณMicrosiga           บ Data ณ  06/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca Apontamentos da rota que esta prestando contas.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAcols()

Local aArea		:=	GetArea()
Local cQuery 
Local cRotax	:= ''  
Local cDatDT	:= ''
Local cAuxD		:= ''
Local cVirg		:= ''
Local aAux		:= {} 
Local nSomaAt	:= 0
Local nSomaAn	:= 0  
Local nSomaVn	:= 0  
Local nTestAtu	:= 0
Local nTestAnt	:= 0  
Local lV6		:= .T.   
Local lV7		:= .T.
Local nTot12	:= 0
Local nTot13	:= 0
Local nTot14	:= 0
Local nTot15	:= 0 
Local aSbe		:= {}    
Local lCafe		:= .F.
Local nRecZNAnt := 0
Local nRecZNAtu := 0
Local aSZ0		:= {}                         
Local aMapa		:= {}
ProcRegua(4)
IncProc("")

//cQuery := "SELECT ZN_CLIENTE,ZN_LOJA,A1_NREDUZ,ZN_AGENTE,AA1_NOMTEC,ZN_PATRIMO,ZN_NUMATU,ZN_COTCASH,ZN_RESCASH,ZN_RESSALE,ZN_RESCONT,ZN_VALIDA,ZN_DATA,"
cQuery := "SELECT ZN_CLIENTE,ZN_LOJA,A1_NREDUZ,ZN_AGENTE,AA1_NOMTEC,ZN_PATRIMO,ZN_NUMATU,ZN_COTCASH,ZN_VALIDA,ZN_DATA,"
cQuery += " ZN_ROTA,ZZ1_DESCRI,ZN.R_E_C_N_O_ AS REG,ZN_NUMOS,B1_XFAMILI,N1.*,"

For nXp := 1 to 60
	cQuery 	+= 	cVirg + "ZN_BOTAO"+Strzero(nXp,2)
	cVirg 	:= 	","
Next nXp

cQuery += " FROM "+RetSQLName("SZN")+" ZN"
cQuery += " INNER JOIN " +RetSQlName("SZG") + " ZG ON ZG_FILIAL = ZN_FILIAL AND ZG_NUMOS = ZN_NUMOS "
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZN_CLIENTE AND A1_LOJA=ZN_LOJA AND A1.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=N1_PRODUTO AND B1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN "+RetSQLName("AA1")+" AA1 ON AA1_CODTEC = ZG_CODTEC AND AA1.D_E_L_E_T_ = '' "   
cQuery += " LEFT JOIN "+RetSQLName("ZZ1")+" ZZ1 ON ZZ1_COD = ZN_ROTA AND ZZ1.D_E_L_E_T_ = '' "
cQuery += " WHERE ZN.D_E_L_E_T_='' AND ZN_VALIDA IN ('','S') "

cQuery += " AND ZN_ROTA = '"+cRota+"' "

//If !Empty(_dDtini) .And. !Empty(_dDtFim)
//	cQuery += " AND ZN_DATA BETWEEN '"+DTOS(_dDtini)+"' AND '"+DTOS(_dDtFim)+"' "
//EndIf
cQuery += " AND ZN_DATA >= '20170327' " //" AND ZN_DATA >= '20160429'
cQuery += " AND ZN_TIPINCL IN ('LEITURA CF','ABASTEC','INSTALACAO','REMOCAO') "
//cQuery += " AND ZN.R_E_C_N_O_ = '588779' "
//cQuery += " ORDER BY R_E_C_N_O_ DESC, ZN_DATA DESC"
cQuery += " ORDER BY ZN_DATA DESC"

//'Cliente/OS','Agente','Data','V1','V2','V3','V4','V5','V6','V7','Resultado','Abastec.','Adicao Lq','Estoque N','Consumo M้dio'
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
  
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
	/*
	If Ascan(aList1,{|x| x[2] = TRB->ZN_ROTA}) == 0
		Aadd(aList1,{'',TRB->ZN_ROTA,TRB->ZZ1_DESCRI,''})
	EndIf                                    
	*/
	/* 	Array aList2 - consolidado da prestacao de contas da OS deste abastecimento
	|--------------------------------------------------------------------|
	|	Posicao	|	Descricao 											 |
	|--------------------------------------------------------------------|
	|	1		|	Numero da OS / Patrimonio-Descricao	/	Cliente		 |
	|	2		|	Codigo do Agente e Nome                              | 
	|	3		|	Data da OS                                           |
	|	4		|	V1                                                   | 
	|	5 		|	V2                                                   |
	|	6   	|   V3                                                   |
	|	7   	|   V4                                                   |
	|	8   	|   V5                                                   |
	|	9   	|   V6                                                   |
	|	10  	|   V7                                                   |
	|	11		|	Resultado da leitura                                 |
	|	12		|	Abastecido											 |
	|	13		|	Adicao Liquida                                       |
	|	14		|	Estoque N                                            |  
	|	15		|	Consumo medio Diario                                 |
	|	16		|	Codigo da Rota                                       |
	|	17		|	Recno da ZN Atual para comparacao com o array aContad|
	|	18		|	Orcamento gerado									 |
	|	19		|	Pedido gerado										 |
	|	20		|	Venda produto * preco publico						 |
 	|--------------------------------------------------------------------| 
	*/
	
    Aadd(aList2,{Alltrim(TRB->ZN_NUMOS)+' / '+Alltrim(TRB->ZN_PATRIMO)+'-'+substr(TRB->N1_DESCRIC,1,15)+' / '+SUBSTR(TRB->A1_NREDUZ,1,20),;
    			 Alltrim(TRB->AA1_NOMTEC),;
    			 STOD(TRB->ZN_DATA),;
    			 oOk,;
    			 oOk,;
    			 oOk,;
    			 oOk,;
    			 oOk,;
    			 oOk,;
    			 oOk,;
    			 0,;	//TRB->ZN_RESSALE,;	//TRB->ZN_RESCONT,;
    			 0,;
    			 0,;
    			 0,;
    			 0,;
    			 TRB->ZN_ROTA,;
    			 TRB->REG,;
    			 "",;	// orcamento
    			 "",;	// pedido PP
    			 0})	
    
                               
    /*
    Array aContad - utilizado para efetuar as compara็๕es entre a leitura atual e a anterior e colocar as valida็๕es no grid do alist2
    |----------------------------------------------------------------------------------------------------------------------|
    |	Posicao		 Descricao                                                                                             |
    |----------------------------------------------------------------------------------------------------------------------|
    |	1	|		|Numero do patrimonio                                                                                  |
    |	2	|		|Numero da OS                                                                                          |
    |	3	|		|Recno da ZN Atual                                                                                     |
    |	4	|		|Data da leitura                                                                                       |
    |	5	|		|Contador Sale Atual                                                                                   |
    |	6	|		|Contador Cash Atual                                                                                   |
    |	7   |       |Contador Sale Anterior                                                                                |
    |	8	|		|Contador Cash Anterior                                                                                |
    |	9	|		|Recno da ZN Anterior                                                                                  |
    |	10	|		|Array com informacoes referente aos contadores Ps e informacoes referente ao abastecimento            |
    |		|10.1	|Botao Px                                                                                              |
    |		|10.2	|P apontado Leitura atual                                                                              |
    |		|10.3	|P apontado Leitura anterior                                                                           |
    |		|10.4	|Produto contido no mapa do P lido                                                                     |
    |		|10.5	|Tabela de pre็os contida no patrimonio                                                                |
    |		|10.6   |Valor unitario do item na tabela                                                                      |
    |		|10.7	|Valor total da venda - R$ unitario X quantidade apontada                                              |
    |		|10.8	|Saldo anterior da mola.                                                                               |
    |		|10.9	|Cliente                                                                                               |
    |		|10.10	|Loja do Cliente                                                                                       |
    |		|10.11	|Capacidade da Mola                                                                                    |
    |		|10.12	|Total Abastecido nesta leitura                                                                        |
    |		|10.13	|Adicao liquida em estoque                                                                             |
    |		|10.14	|Estoque total de produtos no patrimonio                                                               |
    |		|10.15	|Consumo m้dio diario                                                                                  |
    |---------------------------------------------------------------------------------------------------------------------|
    */
	Aadd(aContad,{TRB->ZN_PATRIMO,TRB->ZN_NUMOS,TRB->REG,STOD(TRB->ZN_DATA),TRB->ZN_NUMATU,TRB->ZN_COTCASH,0,0,0})
	            
	dbSelectArea("SN1")
	If MsSeek( xFilial("SN1") +AvKey(TRB->ZN_PATRIMO,"N1_CHAPA") )  
		dbSelectArea("SB1")
		If MsSeek( xFilial("SB1") +AvKey(SN1->N1_PRODUTO,"B1_COD") )
			lCafe := IIF( AllTrim(SB1->B1_XFAMILI) $ "144#153",.T.,.F. )
		EndIf
	EndIf
	
	dbSelectArea("TRB")
	
	If lCafe
		For nXp := 1 to 60
			Aadd(aContad[len(aContad)],{&("ZN_BOTAO"+Strzero(nXp,2)),&("ZN_BOTAO"+Strzero(nXp,2)),0,&("TRB->N1_XP"+cValtochar(nXp)),;
									TRB->N1_XTABELA,0,0,0,TRB->ZN_CLIENTE,TRB->ZN_LOJA,0,0,0,0,0})
		Next nXp
	Else 
		// mapa - szh - Aqui estas lento
		aMapa := MapZH( TRB->N1_CHAPA )	//STATICCALL( MOBILE, getMapa, TRB->N1_CHAPA,Date() )
		
		dbSelectArea("TRB")
		For nXp := 1 To Len( aMapa )
			If nXp > 60
				Exit
			EndIf
			
			Aadd(aContad[len(aContad)],{ &("ZN_BOTAO"+Strzero(nXp,2)),&("ZN_BOTAO"+Strzero(nXp,2)),0,aMapa[nXp][4],;
									TRB->N1_XTABELA,0,0,0,TRB->ZN_CLIENTE,TRB->ZN_LOJA,0,0,0,0,0} )
		Next nXp		
	EndIf
			
	// Array consolidando os insumos de bebidas quentes
	If TRB->B1_XFAMILI == "153"
		Aadd(aL3B,{ TRB->N1_CHAPA,TRB->REG,TRB->ZN_NUMOS,TRB->ZN_ROTA } )		
	EndIF
	
	If Ascan(aOS,{|x| x[1] == Alltrim(TRB->ZN_NUMOS)}) == 0
		Aadd(aOS,{Alltrim(TRB->ZN_NUMOS),TRB->ZN_ROTA})
	EndIf
		
	DbSkip()
EndDo

IncProc("")

ContAnt()	// CONTADORES ANTERIORES


IncProc("")

// Validacoes do alist2 com os contadores anteriores
For nTt := 1 to len(aContad) 
	lDifP := .F.
	lV6 	:= .T.
	lV7 	:= .T.                                                 
	nTot12 	:= 0
	nTot13	:= 0
	nTot14 	:= 0
	nTot15	:= 0     
	nSomaAt	:= 0
	nSomaAn	:= 0  
	nSomaVn := 0  
	nTestAtu := 0
	nTestAnt := 0
	lCafe	:= .F. 
	nRecZNAnt := 0
	nRecZNAtu := 0
	
	// resultado -> numerador atual - anterior
	aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),11] := ( aContad[nTt][5] - aContad[nTt][7] ) 
	
	dbSelectArea("SN1")
	If MsSeek( xFilial("SN1") +AvKey(aContad[nTt][1],"N1_CHAPA") )  
		dbSelectArea("SB1")
		If MsSeek( xFilial("SB1") +AvKey(SN1->N1_PRODUTO,"B1_COD") )
			lCafe := IIF( AllTrim(SB1->B1_XFAMILI) $ "144#153",.T.,.F. )
		EndIf
	EndIf
	             
	If !lCafe
		/*
		ABASTECIDO - SOMA DOS PRODUTOS ABASTECIDOS
		VENDA -  ( SALDO DO ULTIMO MOVIMENTO - SALDO ATUAL )
		ESTOQUE N - SOMA DOS SALDOS DO MOVIMENTO
		*/
		
		// consulta SZ0
		aSZ0 := {}
		aSZ0 := SldMolAnt( aContad[nTt,01],"","","",aContad[nTt,02],aContad[nTt,04] ) 
		
				
		aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),12] := aSZ0[1]	// abastecido
		aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),13] := aSZ0[2]	// venda
		aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),14] := aSZ0[3]	// Estoque N -> total de produtos no patrimonio
	EndIf
	
	//V1 - Cash
	If aContad[nTt,06] < aContad[nTt,08]
		aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),04] := oNo
	EndIf      
    //V2 - Sale
	If aContad[nTt,05] < aContad[nTt,07]
		aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),05] := oNo
	EndIf

	//V3 - Soma Ps           
	For nRr := 10 to Len(aContad[nTt])//69
		nSomaAn	+=	aContad[nTt,nRr,03]
		nSomaAt +=	aContad[nTt,nRr,02]
		
		//aContad[nTt,nRr,06] := Posicione("DA1",1,xFilial("DA1")+aContad[nTt,nRr,05]+aContad[nTt,nRr,04],"DA1_XPRCPP")
		//aContad[nTt,nRr,07] := (aContad[nTt,nRr,02]-aContad[nTt,nRr,03]) * aContad[nTt,nRr,06] //(nSomaAt - nSomaAn) * aContad[nTt,nRr,06] 
		nSomaVn += aContad[nTt,nRr,07]  
		
		lCafe := ascan(aL3b,{|x| alltrim(x[1]) == Alltrim(aContad[nTt,01])}) > 0
		
		//chapa mola cliente loja os data
		/*
		aContad[nTt,nRr,08] := SldMolAnt(aContad[nTt,01],If(!lCafe,val(right(aContad[nTt,nRr,1],2)),50+val(right(aContad[nTt,nRr,1],2))),aContad[nTt,nRr,09],aContad[nTt,nRr,10],Alltrim(aContad[nTt,02]),aContad[nTt,04],If(!lCafe,nTt,50+nTt),If(!lCafe,nRr,60),lCafe,nRr)
		If aContad[nTt,nRr,08] <> 0
			lV6 := .F.
		EndIf                      
		
		//Capacidade da mola
		aContad[nTt,nRr,11] := Posicione("SZH",1,xFilial("SZH")+aContad[nTt,01]+aContad[nTt,nRr,09]+aContad[nTt,nRr,10]+avkey(cvaltochar(val(right(acontad[nTT,10,1],2))),"ZH_MOLA"),"ZH_QUANT")
		If aContad[nTt,nRr,08] > aContad[nTt,nRr,11]
			lV7 := .F.
		EndIf         
		*/
		/*
		nTot12	+=	aContad[nTt,nRr,12]
		nTot13  +=	aContad[nTt,nRr,13]
		nTot14  +=	aContad[nTt,nRr,14]
		nTot15  +=	aContad[nTt,nRr,15]
		*/
		If aContad[nTt,nRr,02] - aContad[nTt,nRr,03] < 0
			lDifP := .T.
		EndIf
	Next nRr
	            
	nRecZNAnt := aContad[nTt][9]
	nRecZNAtu := aContad[nTt][3]
	If nRecZNAtu > 0
		dbSelectArea("SZN")
		dbGoto(nRecZNAtu)
		nTestAtu := SZN->ZN_BOTTEST
		
		If nRecZNAnt > 0
			dbGoTo(nRecZNAnt)
			nTestAnt := SZN->ZN_BOTTEST
		EndIf
	EndIf	
		                                      
	If nSomaAt < nSomaAn
	//	aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),06] := oNo
	EndIf
	                                                           
	//V4 -> V3 = V2
	
	//If nSomaAt - nSomaAn <> aContad[nTt,05] - aContad[nTt,07]
	// ALTERADO JACKSON 01/10/15 ->
	If lCafe 
		If ( (nSomaAt - nSomaAn) + (nTestAtu - nTestAnt )  )  <> aContad[nTt,05] - aContad[nTt,07]	
	   		// amarelo
	   		// se a diferenca de algum P for negativa == amarelo
	   		If !lDifP
		   		aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),07] := oNo
	   		Else
	   			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),07] := oAma
	   		EndIf
		EndIf
	Else
		nPos := Ascan( aList2, { |x| x[17] == aContad[nTt][3] } )
		If nPOs > 0
			If aList2[nPos][11] <> aList2[nPos][13]
				aList2[nPos][7] := oNo
			EndIf
		EndIf
	EndIf
	
	//V5 - R$ Venda * V3 = V1
	nNewVlr	:= 0
	If Len( CVALTOCHAR(aContad[nTt,06] - aContad[nTt,08]) ) < 5
		nNewVlr := ( aContad[nTt,06] - aContad[nTt,08] ) / 100
	ElseIf Len(CVALTOCHAR(aContad[nTt,06] - aContad[nTt,08])) >= 5
		nNewVlr := ( aContad[nTt,06] - aContad[nTt,08] ) / 1000
	EndIf

	If lCafe
		If nSomaVn <> nNewVlr
			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),08] := oNo
		EndIf	
	Else
		// total venda de produtos * preco == diferenca do cash
		nTot := ProdSZ0(aContad[nTt,01],aContad[nTt,02],aContad[nTt,04])
		If nTot <> nNewVlr
			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),08] := oNo
		EndIf
		nPos := Ascan( aList2, { |x| x[17] == aContad[nTt][3] } )
		If nPOs > 0
			aList2[nPos][20] := nTot
		EndIf
	EndIf
	
	/*
	//V6 
	//chapa mola cliente loja os 
	If !lV6
		If !lCafe
			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),09] := oNo
		Else 
			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),09] := oBranco
		EndIf	
	EndIf
	
	//Capacidade V7
	If !lV7
		If !lCafe
			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),10] := oNo
		Else 
			aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),10] := oBranco
		EndIf	
	EndIf
	*/

	
	//aList2[Ascan(aList2,{|x| x[17] == aContad[nTt,03]}),15] := nTot15	// Consumo m้dio diario      
	
	//Terceiro array - insumos de bebidas quentes
	If Ascan(aL3B,{|x| x[2] == aContad[nTt,3]}) <> 0 
		aDose := {}
		For nLipe := 10 to Len(aContad[nTt])//69
			If !Empty(aContad[nTt,nLipe,04]) .And. aContad[nTt,nLipe,02]-aContad[nTt,nLipe,03] <> 0
			 	aAdd(aDose,{aContad[nTt,nLipe,04],aContad[nTt,nLipe,02]-aContad[nTt,nLipe,03]})
			EndIf
		Next nLipe
		If len(aDose) > 0
			Aadd(aL3B[Ascan(aL3B,{|x| x[2] == aContad[nTt,3]})],aDose)	
		EndIf
	EndIf
Next nTt

Asort( aList2,,,{|x,y| x[16]+cvaltochar(x[3]) < y[16]+cvaltochar(y[3]) } )

If Empty(aList2)
	MsgAlert("Nใo encontrado itens para serem exibidos","TTPROC56")
	//Aadd(aList1,{'','','','','','','','',''})
	//Aadd(aList2,{ '', '', STOD(''),oOk,oOk,oOk,oOk,oOk,oOk,oOk,0,0,0,0,0,"",0})
	Aadd(aList3,{'','','','','','','','','',""})  
	aList2Bkp := aClone(aList2)
EndIf

IncProc("")

RestArea(aArea)

Return


Static Function mapZH( cMaquina )

Local cSql := ""
Local aMapa := {}


cSql := "SELECT ZH_BANDEJA, ZH_MOLA, ZH_QUANT, ZH_CODPROD, B1_DESC FROM " +RetSqlName("SZH") +" SZH "
cSql += " INNER JOIN " +RetSqlName("SB1") + " ON "
cSql += "B1_COD = ZH_CODPROD "
cSql += " WHERE ZH_CHAPA = '"+cMaquina+"' AND ZH_STATUS = '3' AND SZH.D_E_L_E_T_ = '' AND ZH_VERSAO <> '' "
cSql += " ORDER BY ZH_BANDEJA, ZH_MOLA"

If Select("TRBY") > 0
	TRBY->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRBY"
dbSelectArea("TRBY")
While !EOF()

	dbSelectArea("TRBY")
	AADD( aMapa, { ALLTRIM(TRBY->ZH_BANDEJA),;
				 ALLTRIM(TRBY->ZH_MOLA),;
				  TRBY->ZH_QUANT,;
				   ALLTRIM(TRBY->ZH_CODPROD),;
				   AllTrim(TRBY->B1_DESC) } )
	dbSkip()
End

Return amapa



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIngredient บAutor  ณJackson E. de Deusบ  Data ณ  07/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega ingredientes de acordo com a OS                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ingredient(cNumOS,cPatrimo,dData)

Local nPosIN := 0
Local aSbe		:=	{}
Local cPatrimo := ""
Local cProd := ""
Local cDescPRod := ""
Local cFamilia := ""
Local nQtdAbast := 0 
Local nPos := 0
Local dData := stod("")
Local cCliente := ""
Local cLoja := ""
Local aConv := {}
Local cAuxD := ""
Local dDataant := Nil
Local aSz0Ant := {}                          


If len(aList2) > 0
	nPosIN := ASCAN( AL3B, { |x|  alltrim(x[3]) == AllTrim(cNumOS) } )
	If nPosIN > 0
		If Len(aL3B[nPosIN]) > 4
			cPatrimo := aL3B[nPosIN][1]
			nRecZN := aL3B[nPosIN][2]
			dbSelectArea("SZN")
			dbGoTo(nRecZN)       
			cCliente := SZN->ZN_CLIENTE
			cLoja := SZN->ZN_LOJA
			dData := SZN->ZN_DATA
			 
			For nY := 1 to len(aL3B[nPosIN,5])
				cProduto	:= aL3B[nPosIN,5,nY,1]
				nQtd		:= aL3B[nPosIN,5,nY,2]
				
				//ESTRUTURA
				cQuery := "SELECT G1_COD,B.B1_DESC AS DESCP,G1_COMP,C.B1_DESC AS DESCI,"
				//cQuery += " CASE WHEN G1_QUANT < 1 THEN G1_QUANT ELSE G1_QUANT/1000 END AS G1_QUANT,
				cQuery += " G1_QUANT,C.B1_XFAMILI AS FAMILIA"
				cQuery += " FROM "+RetSQLName("SG1")+" G1"
				cQuery += " INNER JOIN "+RetSQLName("SB1")+" B ON B.B1_COD=G1_COD AND B.D_E_L_E_T_=''"
				cQuery += " INNER JOIN "+RetSQLName("SB1")+" C ON C.B1_COD=G1_COMP AND C.D_E_L_E_T_=''"
				cQuery += " WHERE G1_COD='"+Alltrim(cProduto)+"' AND G1.D_E_L_E_T_=''"
		
				If Select("TRB") > 0
					dbSelectArea("TRB")
					dbCloseArea()
				EndIf
				  
				//MemoWrite("TTPROC56.SQL",cQuery)
				
				cQuery:= ChangeQuery(cQuery)
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
				
				DbSelectArea("TRB")
				
				While !EOF()
					If Ascan(aEstru,{|x| x[1]+x[3] == TRB->G1_COD+TRB->G1_COMP}) == 0
						Aadd( aEstru,{ TRB->G1_COD,TRB->DESCP,TRB->G1_COMP,TRB->DESCI,TRB->G1_QUANT,TRB->FAMILIA } )
						If "U" $ TRB->G1_COMP .AND. Ascan(aSbe,{|x| x[1] == TRB->G1_COMP}) == 0
							AADD(aSbe,{TRB->G1_COMP,TRB->DESCI,'','',0,TRB->FAMILIA})  
						EndIf
					EndIF
					Dbskip()
				EndDo
			Next nY  
			                  
			// ABASTECIDO ANTERIOR
			cQuery := "SELECT TOP 1 Z0_PRODUTO,Z0_ABAST,Z0.R_E_C_N_O_ AS REGZ0 "
			cQuery += " FROM "+RetSQLName("SZ0")+" Z0 "
			cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=Z0_PRODUTO AND B1.D_E_L_E_T_='' "
			cQuery += " WHERE Z0_CHAPA='"+cPatrimo+"' AND Z0_DATA < '"+DTOS(dData)+"' AND Z0.D_E_L_E_T_='' "
			
			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf
			
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   					
			DbSelectArea("TRB")				
			While !EOF()       
				Aadd( aAbZ0Ant,{ TRB->Z0_PRODUTO,TRB->Z0_ABAST,TRB->REGZ0 } )
				Dbskip()
			End
			
			// ABASTECIDO ATUAL
			cQuery := "SELECT Z0_CHAPA,Z0_PRODUTO,B1_DESC,B1_XFAMILI,Z0_ABAST,Z0.R_E_C_N_O_ AS REGZ0 "
			cQuery += " FROM "+RetSQLName("SZ0")+" Z0 "
			cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=Z0_PRODUTO AND B1.D_E_L_E_T_='' "
			cQuery += " WHERE Z0_CHAPA='"+cPatrimo+"' AND Z0_NUMOS='"+cNumOS+"' AND Z0.D_E_L_E_T_='' "
			
			If Select("TRB") > 0
				TRB->(dbCloseArea())
			EndIf
			
			cQuery:= ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
			
			DbSelectArea("TRB")				
			While !EOF()    
				If Ascan(aAbastz0,{|x| x[8] == TRB->REGZ0}) == 0
					Aadd(aAbastz0,{TRB->Z0_CHAPA,TRB->Z0_PRODUTO,TRB->B1_DESC,TRB->B1_XFAMILI,TRB->Z0_ABAST,aL3B[nPosIN,04],aL3B[nPosIN,02],TRB->REGZ0})
					//Gravando aqui o conteudo abastecido por esta os.   
					If TRB->B1_XFAMILI == '153'
						aList2[ascan(aList2,{|x| x[17] == aL3B[nPosIN,02]}),12] += TRB->Z0_ABAST
					EndIf
				EndIf
				Dbskip()
			EndDo
			
			TRB->(dbCloseArea())
			
			
			// abastecimento anterior			
			cQuery := "SELECT TOP 1 * FROM " +RetSqlName("SZ0")
			cQuery += " WHERE Z0_NUMOS <> '"+cNumOs+"' AND Z0_DATA < '"+DTOS(dData)+"' AND Z0_CHAPA = '"+cPatrimo+"' AND D_E_L_E_T_ = '' "
			               
			TcQuery cQuery New Alias "TRB"
			
			dbSelectArea("TRB")
			If !EOF()
				dDataant := STOD(TRB->Z0_DATA)
			EndIf
			
			TRB->(dbCloseArea())
			
			If dDataAnt <> Nil 
				cQuery := "SELECT * FROM " +RetSqlName("SZ0")
				cQuery += " WHERE Z0_NUMOS <> '"+cNumOs+"' AND Z0_DATA = '"+DTOS(dDataAnt)+"' AND Z0_CHAPA = '"+cPatrimo+"'  AND D_E_L_E_T_ = '' "
				               
				Tcquery cQuery New Alias "TRB"
				
				dbSelectArea("TRB")
				While !EOF()
					AADD( aSz0Ant, { TRB->Z0_MOLA, TRB->Z0_PRODUTO, TRB->Z0_SLDMOV } )
					dbSkip()
				End
			EndIf
				
			
			// SUB-ESTRUTURA
			For nZ := 1 to len(aSbe)
				cQuery := "SELECT G1_COD,B.B1_DESC AS DESCP,G1_COMP,C.B1_DESC AS DESCI,"
				//cQuery += " CASE WHEN G1_QUANT < 1 THEN G1_QUANT ELSE G1_QUANT/1000 END AS G1_QUANT
				cQuery += " G1_QUANT,C.B1_XFAMILI AS FAMILIA"
				cQuery += " FROM "+RetSQLName("SG1")+" G1"
				cQuery += " INNER JOIN "+RetSQLName("SB1")+" B ON B.B1_COD=G1_COD AND B.D_E_L_E_T_=''"
				cQuery += " INNER JOIN "+RetSQLName("SB1")+" C ON C.B1_COD=G1_COMP AND C.D_E_L_E_T_=''"
				cQuery += " WHERE G1_COD ='"+aSbe[nZ,01]+"' AND G1.D_E_L_E_T_=''"
				
				If Select("TRB") > 0
					dbSelectArea("TRB")
					dbCloseArea()
				EndIf
				  
				//MemoWrite("ttproc56.SQL",cQuery)
				
				cQuery:= ChangeQuery(cQuery)
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
				
				DbSelectArea("TRB")
				
				While !EOF() 
					If Ascan(aSubEst,{|x| x[1]+x[3] == TRB->G1_COD+TRB->G1_COMP}) == 0
						Aadd(aSubEst,{TRB->G1_COD,TRB->DESCP,TRB->G1_COMP,TRB->DESCI,TRB->G1_QUANT,TRB->FAMILIA})
					EndIf
					Dbskip()
				EndDo
			Next nZ
			
			//'Ingrediente','Abastecido','Conversใo Venda','Adi็ใo Liq.','Estoque Final','Consumo m้dio'		
			// pega o periodo - conversoes de venda
			aConv := ConsMd(cPatrimo,cCliente,cLoja,dData,aEstru)
	
			// pega os insumos da dose						
			For nZ := 1 To Len(aEstru)
				cProdIns := Alltrim(aEstru[nZ][3])
				cDscINs := AllTrim( Posicione("SB1",1,xFilial("SB1")+AvKey(cProdIns,"B1_COD"),"B1_DESC") )
				cFamilia := AllTrim( Posicione("SB1",1,xFilial("SB1")+AvKey(cProdIns,"B1_COD"),"B1_XFAMILI") )

				nPos := Ascan(aList3,{|x| Alltrim(x[1]) == Alltrim(cProdIns)})
				If nPos == 0
					Aadd(aList3,{ cProdIns, 0,0,0,0,0,cDscINs,cRota,cFamilia,0 })
				EndIf							
			Next nZ
			              
			// conversao de venda
			For nY := 1 to len(aL3B[nPosIN,5])
				nConvers := 0
				For nW := 1 to len(aEstru)
					If Alltrim(aEstru[nW,01]) == Alltrim(aL3B[nPosIN,5,nY,01])
						If "U" $ Alltrim(aEstru[nW,03])
							For nZ := 1 to len(aSubest)
								If Alltrim(aSubest[nZ,01]) == Alltrim(aEstru[nW,03])
									If Ascan(aList3,{|x| Alltrim(x[1]) == Alltrim(aSubest[nZ,03])}) > 0
										nConvers := aSubest[nZ,05]	* aL3B[nPosIN,5,nY,02]
										aList3[Ascan(aList3,{|x| Alltrim(x[1]) == Alltrim(aSubest[nZ,03])}),03] += nConvers //(nConvers*100)
										//exit
									EndIf
								EndIf
							Next nZ
						Else  
							If Ascan(aList3,{|x| Alltrim(x[1]) == Alltrim(aEstru[nW,03])}) > 0
						   		nConvers := aEstru[nW,05] * aL3B[nPosIN,5,nY,02]
						   		aList3[Ascan(aList3,{|x| Alltrim(x[1]) == Alltrim(aEstru[nW,03])}),03] += nConvers //(nConvers*100)
						   		//exit
						   	EndIf	
						EndIf
					EndIf
				Next nW
			Next nY
			
			For nZ := 1 To Len(aList3)
				nQtdAbast := 0
				nConvers := aList3[nZ][3]
				nAdLiq := 0
				nEstI := 0
				nEstF := 0
				nConMd := 0
				
				nPos := Ascan( aSz0Ant, { |x| AllTrim(x[2]) == AllTrim(aList3[nZ][1]) } )
				If nPos > 0    
					aList3[nZ][10] := aSZ0Ant[nPos][3]
				EndIf
			
				
				// qtd abastecida
				For nA := 1 To Len(aAbastz0)
					If AllTrim(aAbastZ0[nA][2]) == AllTrim(aList3[nZ][1])
						nQtdAbast += aAbastZ0[nA][5]
					EndIf
				Next nA
				
				// conversao venda
				/*
				For nW := 1 To Len(aEstru)
					//If Alltrim(aEstru[nW][3]) == Alltrim( aList3[nZ][1] )	// insumo x insumo
						For nY := 1 To Len( aL3B[nPosIN][5] )
							If Alltrim(aEstru[nW][1]) == Alltrim( aL3B[nPosIN][5][nY][1] )	// dose x dose					 
					   			nConvers += Round( aEstru[nW][5] * aL3B[nPosIN][5][nY][2],4 )	// qtd insumo * qtd venda
				   			EndIf
				   		Next nY	
					//EndIf
				Next nW
				*/
													
				// adicao liquida
				nAdLiq := Round( nQtdAbast - nConvers,4 )
				
				// estoque final
				nEstF := Round( aList3[nZ][10] + nAdLiq,4 )

				/*
				estoque inicial == saldo anterior
				-> O QUE ษ SALDO ANTERIOR?? - REVISAR CALCULO
				estoque inicial + adicao liquida
				
				For nA := 1 To Len(aAbZ0Ant)
					If AllTrim(aAbZ0Ant[nA][1]) == AllTrim(aList3[nZ][1])
						nEstI := aAbZ0Ant[nA][2]
						nEstF := Round( nEstI + nAdLiq,4 )
					EndIf
				Next nA
                */
				// consumo medio                
				/*
				media da conversao de venda por visita:
				soma das conversoes de venda dividido pela quantidade de visitas
				*/
				For nA := 1 To Len(aConv)
					For nB := 1 To Len(aEstru)
						If aConv[nA][1] == aEstru[nB][1]
							nConMd := aConv[nA][5]
						EndIf
					Next nB
				Next nA
				
				aList3[nZ][2] := nQtdAbast
				//aList3[nZ][3] := nConvers
				aList3[nZ][4] := nAdLiq
				aList3[nZ][5] := nEstF
				aList3[nZ][6] := nConMd
			Next nZ
		EndIf
	EndIf
	 
	/*
	|--------------------------------------------------------------------------------------------|
	|	Array aL3B																				 |
	---------------------------------------------------------------------------------------------|
	|	1	|		|	Patrimonio                                                               |
	|	2	|		|	Recno ZN                                                                 |
	|	3	|		|	Numero OS                                                                |
	|	4	|		|	Rota                                                                     |
	|	5	|		|	Array de insumos                                                         |
	|		|5.1 	|	aContad[x,x,4]			Produto Dose                                     |
	|		|5.2	|	aContad[x,x,2]-aContad[x,x,3]	Diferen็a entre P atual e o P anterior   |
	|--------------------------------------------------------------------------------------------|
	
	|--------------------------------------------------------------------------------------------|
	|	aEstru	-	Estrutura																	 |
	|--------------------------------------------------------------------------------------------|
	|	1	|	C๓digo Produto Principal                                                         |
	|	2	|	Descri็ใo Produto Principal                                                      |
	|	3	|	Componente que compoe a estrutura                                                |
	|	4	|	Descri็ใo Componente                                                             |
	|	5	|	Quantidade que compoe o insumo na dose                                           |
	|	6	|	Familia do prooduto insumo                                                       |
	|--------------------------------------------------------------------------------------------|	
	
	|--------------------------------------------------------------------------------------------|
	|	aAbastz0	-	Itens abastecidos no Patrimonio											 |
	|--------------------------------------------------------------------------------------------|
	|	1	|	Patrimonio                                                                       |
	|	2	|	Produto insumo abastecido                                                        |
	|	3	|	Descri็ใo		                                                                 |
	|	4	|	Familia                                                                          | 
	|	5	|	Quantidade abastecida do insumo													 |
	|	6	|	Rota                                                                             | 
	|	7	|	Recno ZN																		 |
	|--------------------------------------------------------------------------------------------|
	
	
	|--------------------------------------------------------------------------------------------|
	|	aSubEst	-	Sub-Estrutura criada para a Estrutura de produtos Dose						 |
	|--------------------------------------------------------------------------------------------|
	|	1	|	C๓digo Produto Principal														 |
	|	2	|	Descri็ใo Produto Principal                                                      | 
	|	3	|	Componente que compoe a estrutura                                                | 
	|	4	|	Descri็ใo Componente                                                             | 
	|	5	|	Quantidade que compoe o insumo na dose                                           |
	|	6	|	Familia do prooduto insumo                                                       | 
	|--------------------------------------------------------------------------------------------|	
	*/ 
EndIf
      
If Empty(aList3)
	Aadd(aList3,{'','','','','','','','','',""}) 
EndIf	
aList3Bkp := aClone(aList3)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC56  บAutor  ณMicrosiga           บ Data ณ  04/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IngSnack(cNumOs,cPatrimo,dData,lBebGel)

Local cQuery := "" 
Local aSz0Ant := {}
Local dDataant := Nil
Local aMapa := {}
Local nPOs := 0
Default lBebGel := .F.


cQuery := "SELECT * FROM " +RetSqlName("SZ0")
cQuery += " WHERE Z0_NUMOS = '"+cNumOS+"' AND D_E_L_E_T_ = '' ORDER BY Z0_MOLA "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

Tcquery cQuery New Alias "TRB" 

dbSelectArea("TRB") 

While !EOF()
	AADD( aList4, { TRB->Z0_MOLA,;
	 				TRB->Z0_PRODUTO,;
	 				TRB->Z0_SALDO,;
	 				TRB->Z0_RETIR,;
	 				TRB->Z0_AVARIA,;
	 				0,;
	 				TRB->Z0_ABAST,;
	 				0,;
	 				TRB->Z0_SLDMOV,;
	 				0,;				// sld mov anterior
	 				0,;				// saldo final
	 				0,;			// capacidade mola
	 				AllTrim(Posicione("SB1",1,xFilial("SB1") +AvKey(TRB->Z0_PRODUTO,"B1_COD"),"B1_DESC" )) } )
	dbSkip()
End

TRB->(dbCloseArea())


cQuery := "SELECT TOP 1 * FROM " +RetSqlName("SZ0")
cQuery += " WHERE Z0_NUMOS <> '"+cNumOs+"' AND Z0_DATA < '"+DTOS(dData)+"' AND Z0_CHAPA = '"+cPatrimo+"' AND D_E_L_E_T_ = '' "
cQuery += " AND Z0_DATA > '20160401' "
cQuery += " ORDER BY Z0_DATA DESC "
               
Tcquery cQuery New Alias "TRB"

dbSelectArea("TRB")
If !EOF()
	dDataant := STOD(TRB->Z0_DATA)
EndIf

TRB->(dbCloseArea())

If dDataAnt <> Nil 
	cQuery := "SELECT * FROM " +RetSqlName("SZ0")
	cQuery += " WHERE Z0_NUMOS <> '"+cNumOs+"' AND Z0_DATA = '"+DTOS(dDataAnt)+"' AND Z0_CHAPA = '"+cPatrimo+"'  AND D_E_L_E_T_ = '' "
	               
	Tcquery cQuery New Alias "TRB"
	
	dbSelectArea("TRB")
	While !EOF()
		AADD( aSz0Ant, { TRB->Z0_MOLA, TRB->Z0_PRODUTO, TRB->Z0_SLDMOV } )
		dbSkip()
	End
EndIf


// mapa
aMapa := StaticCall( MOBILE, getMapa, cPatrimo, dData)

For nI := 1 To Len( aList4 )
	nSldMov := 0
	For nJ := 1 To Len(aSz0Ant)
		If aSz0Ant[nJ][1] == aList4[nI][1] .And. aSz0Ant[nJ][2] == aList4[nI][2]
			nSldMov += aSz0Ant[nJ][3]
		EndIf
	Next nJ
	
	aList4[nI][10] := nSldMov
	aList4[nI][6] := ( nSldMov - aList4[nI][3] )
	aList4[nI][8] := ( aList4[nI][7] - aList4[nI][6] - aList4[nI][5] - aList4[nI][4] )
	aList4[nI][11] := ( nSldMov + aList4[nI][8] ) 
	
	nPOs := Ascan( aMapa, { |x| AllTrim(x[2]) == AllTrim(aList4[nI][1]) .And. AllTrim(x[4]) == AllTrim(aList4[nI][2]) } )
	If nPOs > 0
		aList4[nI][12] := aMapa[nPos][3]
	EndIf	
Next nI


If lBebGel
	For nI := 1 To Len(aList4)
		aList4[nI][3] := 0
		aList4[nI][4] := 0
		aList4[nI][5] := 0
		aList4[nI][6] := 0
		aList4[nI][8] := 0
		aList4[nI][9] := 0
		aList4[nI][10] := 0
		aList4[nI][11] := 0
		aList4[nI][12] := 0
	Next nI
EndIf

If Empty(aList4)
	AADD( aList4, { "",;
	 				"",;
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
	 				"" } )
EndIf

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFHelp  บAutor  ณJackson E. de Deus     บ Data ณ  06/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Troca o grid dos contadores de acordo com a mudanca no    บฑฑ
ฑฑบ          ณ grid de rotas.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)
      
Local aArea	:=	GetArea()
Local nI,nJ
Local nLin := 0
Local aAx := StrToKarr( aList2[nLinha][1], "/"  )
Local cNumOS := AllTrim(aAx[1])
Local cPosicao := ""
Local cProd := ""
Local cDescProd := ""
Local nSldAnt := 0
Local nAdiLiq := 0
Local nVendaAnt := 0
Local nVenda := 0 
Local nRecAnt := 0
Local nRecZN := 0
Local nSale := 0
Local nCash := 0
Local nParc := 0
Local nTst := 0
Local nSaleAnt := 0
Local nCashAnt := 0
Local nParcAnt := 0
Local nTstAnt := 0
Local cPatrimo := ""
Local cTabela := ""
Local aPRC := {0,0}
Local aItens := {}
Local lCafe := .F.
Local lBebGel := .F.
                  

CursorWait()

ProcRegua(2)

IncProc("Carregando contadores..")

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega grid de contadoresณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	cTabela := SZG->ZG_TABELA                       
	
	dbSelectArea("SN1")
	dbSetOrder(2)
	If MsSeek( xFilial("SN1") +AvKey(SZG->ZG_PATRIM,"N1_CHAPA") )
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek( xFilial("SB1") +AvKey(SN1->N1_PRODUTO,"B1_COD") )
			If AllTrim(SB1->B1_XFAMILI) == "153"
				lCafe := .T.                
			ElseIf AllTrim(SB1->B1_XFAMILI) == "144"
				lBebGel := .T.	
			EndIf
		EndIf
	EndIf	                       
EndIf                                                        

//aTabPrc := STATICCALL( TTFAT20C, TabPrc, cTabela, aItens  )
aCols := {}
For nI := 1 To Len(aContad)
	If AllTrim(aContad[nI][2]) <> AllTrim(cNumOS)
		Loop
	EndIf                   
	nRecAnt := aContad[nI][9]
	nRecZN := aContad[nI][3]
	If nRecZN > 0
		dbSelectArea("SZN")
		dbGoto(nRecZN)
		nSale := SZN->ZN_NUMATU
		nCash := SZN->ZN_COTCASH
		nParc := SZN->ZN_PARCIAL
		nTst  := SZN->ZN_BOTTEST
		
		If nRecAnt > 0
			dbGoTo(nRecAnt)
			nSaleAnt := SZN->ZN_NUMATU
			nCashAnt := SZN->ZN_COTCASH
			nParcAnt := SZN->ZN_PARCIAL
			nTstAnt	:= SZN->ZN_BOTTEST
		EndIf 
		     
		// total sale
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		aCols[nLin][1] := "W"
		aCols[nLin][2] := "TS"
		aCols[nLin][3] := "TOTAL SALE"
		aCols[nLin][4] := nSaleAnt
		aCols[nLin][5] := nSale
		aCols[nLin][6] := nSale - nSaleAnt
		aCols[nLin][7] := 0
		aCols[nLin][8] := 0
		aCols[nLin][9] := 0
		aCols[nLin][Len(aHeader)+1] := .F.	
		
		// total cash
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		aCols[nLin][1] := "X"
		aCols[nLin][2] := "TC"
		aCols[nLin][3] := "TOTAL CASH"
		aCols[nLin][4] := nCashAnt
		aCols[nLin][5] := nCash
		aCols[nLin][6] := nCash - nCashAnt
		aCols[nLin][7] := 0
		aCols[nLin][8] := 0
		aCols[nLin][9] := 0
		aCols[nLin][Len(aHeader)+1] := .F.
		
		// testes
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		aCols[nLin][1] := "Y"
		aCols[nLin][2] := "T"
		aCols[nLin][3] := "TESTES"
		aCols[nLin][4] := nTstAnt
		aCols[nLin][5] := nTst
		aCols[nLin][6] := nTst - nTstAnt
		aCols[nLin][7] := 0
		aCols[nLin][8] := 0
		aCols[nLin][9] := 0
		aCols[nLin][Len(aHeader)+1] := .F.	
		
		// parcial
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		aCols[nLin][1] := "Z"
		aCols[nLin][2] := "P"
		aCols[nLin][3] := "PARCIAL"
		aCols[nLin][4] := nParcAnt
		aCols[nLin][5] := nParc
		aCols[nLin][6] := nParc - nParcAnt
		aCols[nLin][7] := 0
		aCols[nLin][8] := 0
		aCols[nLin][9] := 0
		aCols[nLin][Len(aHeader)+1] := .F.						
	EndIf
	
	For nJ := 10 To Len(aContad[nI])
		cPosicao := cvaltochar(nJ-9)
		cProd := aContad[nI][nJ][4]
		cDescProd := Posicione("SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_DESC")
		
		If !Empty(cTabela) .And. !Empty(cProd)
			aPRC := fPRC(cTabela,cProd) 
		EndIf                          
		nPE := aPRC[1]
		nPP := aPRC[2] 
		
		nSldAnt := aContad[nI][nJ][8]
		nAdiLiq := aContad[nI][nJ][13]
		nVendaAnt := aContad[nI][nJ][3]
		nVenda := aContad[nI][nJ][2]
		
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		aCols[nLin][1] := cPosicao
		aCols[nLin][2] := cProd
		aCols[nLin][3] := cDescProd
		aCols[nLin][4] := nVendaAnt
		aCols[nLin][5] := nVenda
		aCols[nLin][6] := nVenda - nVendaAnt
		aCols[nLin][7] := nPE
		aCols[nLin][8] := nPP	
		aCols[nLin][9] := 0
		aCols[nLin][Len(aHeader)+1] := .F.		
	Next nJ
Next nI 

oGetDB:Acols := aClone(aCols)
oGetDB:Refresh(.T.)	  
oGetDB:GoTop()



/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxฤ[ฟ
//ณCarrega grid de ingredientesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxฤ[ู
ENDDOC*/
aList3 := {}
aList4 := {}
aAbZ0Ant := {}
aAbastz0 := {}
aEstru := {}
IncProc("Carregando ingredientes..")

If lCafe
	Ingredient(cNumOS,SZG->ZG_PATRIM,SZG->ZG_DATAFIM)
	
	oList3:SetArray(aList3)

	oList3:bLine := {||{   Alltrim(	aList3[oList3:nAt,01]) +' - ' +aList3[oList3:nAt,07],; 
 					 	aList3[oList3:nAt,10],;	 					 	
 					 	aList3[oList3:nAt,03],;
 					 	aList3[oList3:nAt,02],;	 					 	
                     	aList3[oList3:nAt,04],;
                     	aList3[oList3:nAt,05]}} 
	oList3:nScrollType := 1    
	oList3:Refresh(.T.)
	oList4:Hide()
	oList3:Show()
	
	oLayer:setWinTitle( "COLUNA2_2", "WIN_3", "Ingredientes", "LINHA2" )   
	
	/*                     		                     	     
	"Ingrediente","Estoque inicial",'Conversใo Venda','Abastecido','Adi็ใo Liq.','Estoque Final'}                                 
	{"Ingrediente",'Abastecido','Conversใo Venda','Adi็ใo Liq.','Estoque Final','Consumo m้dio'}
	*/	

Else 
	IngSnack(cNumOs,SZG->ZG_PATRIM,SZG->ZG_DATAFIM,lBebGel)	
	
	oList4:SetArray(aList4)
	 
 	oList4:bLine := {||{   Alltrim(	aList4[oList4:nAt,01]) +" - " +aList4[oList4:nAt,13],; 
	 					 	aList4[oList4:nAt,02],;
	 					 	aList4[oList4:nAt,10],;
	                     	aList4[oList4:nAt,04],;
	                     	aList4[oList4:nAt,05],;
	                     	aList4[oList4:nAt,06],;
	                     	aList4[oList4:nAt,07],;
	                     	aList4[oList4:nAt,08],;
	                     	aList4[oList4:nAt,11],;
	                     	aList4[oList4:nAt,12] }} 
	                     	
	
	oList4:nScrollType := 1    
	oList4:Refresh(.T.)
	oList3:Hide()
	oList4:Show()
	            
	oLayer:setWinTitle( "COLUNA2_2", "WIN_3", "Produtos", "LINHA2" )

EndIf
  
RestArea(aArea)

CursorArrow()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPRC  บAutor  ณJackson E. de Deus      บ Data ณ  07/18/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPRC(cTabela,cProd)


Local cQuery := ""
Local aPRC := {0,0}

cQuery := "SELECT DA1_PRCVEN PE, DA1_XPRCPP PP FROM " +RetSqlName("DA1")
cQuery += " WHERE DA1_CODTAB = '"+cTabela+"' AND DA1_CODPRO = '"+cProd+"' AND D_E_L_E_T_ = '' "
	 
If Select("TRBP") > 0
	TRBP->(dbCloseArea())
EndIf
	  	
cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBP',.F.,.T.)   

DbSelectArea("TRBP")
If !EOF()
	aPRC[1] := TRBP->PE
	aPRC[2] := TRBP->PP
EndIf

TRBP->(dbCloseArea())
	

Return aPRC


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณeditcol  บAutor  ณMicrosiga           บ Data ณ  06/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Editar uma linha.                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(nLinha) 

Local aArea	:=	GetArea()
Local nPosC	:=	oList2:colpos
Local nTotAtu := 0
Local nTotAnt	:= 0
Local nVendP := 0

If nPosC < 4 .Or. nPosC > 10
	RestArea(aArea)
	Return
EndIf
 
 	/* 	Array aList2 - consolidado da prestacao de contas da OS deste abastecimento
	|--------------------------------------------------------------|
	|	Posicao	|	Descricao 									   |
	|--------------------------------------------------------------|
	|	1		|	Numero da OS / Patrimonio-Descricao	/	Cliente|
	|	2		|	Codigo do Agente e Nome                        | 
	|	3		|	Data da OS                                     |
	|	4		|	V1                                             | 
	|	5 		|	V2                                             |
	|	6   	| V3                                               |
	|	7   	| V4                                               |
	|	8   	| V5                                               |
	|	9   	| V6                                               |
	|	10  	| V7                                               |
	|	11		|	Resultado da leitura                           |
	|	12		|	Abastecido									 	|
	|	13		|	Adicao Liquida                                       |
	|	14		|	Estoque N                                            |  
	|	15		|	Consumo medio Diario                                 |
	|	16		|	Codigo da Rota                                       |
	|	17		|	Recno da ZN Atual para comparacao com o array aContad|
 	|--------------------------------------------------------------| 
	*/ 
/*
    Array aContad - utilizado para efetuar as compara็๕es entre a leitura atual e a anterior e colocar as valida็๕es no grid do alist2
    |------------------------------------------------------------------------------------------------------------------|
    |	Posicao		 Descricao                                                                                             |
    |------------------------------------------------------------------------------------------------------------------|
    |	1	|				|Numero do patrimonio                                                                                  |
    |	2	|				|Numero da OS                                                                                          |
    |	3	|				|Recno da ZN Atual                                                                                     |
    |	4	|				|Data da leitura                                                                                       |
    |	5	|				|Contador Sale Atual                                                                                   |
    |	6	|				|Contador Cash Atual                                                                                   |
    |	7	|		   		|Contador Sale Anterior                                                                                |
    |	8	|				|Contador Cash Anterior                                                                                |
    |	9	|				|Recno da ZN Anterior                                                                                  |
    |	10	|				|Array com informacoes referente aos contadores Ps e informacoes referente ao abastecimento            |
    |		|10.1		|Botao Px                                                                                              |
    |		|10.2		|P apontado Leitura atual                                                                              |
    |		|10.3		|P apontado Leitura anterior                                                                           |
    |		|10.4		|Produto contido no mapa do P lido                                                                     |
    |		|10.5		|Tabela de pre็os contida no patrimonio                                                                |
    |		|10.6   |Valor unitario do item na tabela                                                                      |
    |		|10.7		|Valor total da venda - R$ unitario X quantidade apontada                                              |
    |		|10.8		|Saldo anterior da mola.                                                                               |
    |		|10.9		|Cliente                                                                                               |
    |		|10.10	|Loja do Cliente                                                                                       |
    |		|10.11	|Capacidade da Mola                                                                                    |
    |		|10.12	|Total Abastecido nesta leitura                                                                        |
    |		|10.13	|Adicao liquida em estoque                                                                             |
    |		|10.14	|Estoque total de produtos no patrimonio                                                               |
    |		|10.15	|Consumo m้dio diario                                                                                  |
    |------------------------------------------------------------------------------------------------------------------|
    */
nPosP := Ascan( aContad,{|x| x[3] == aList2[nLinha,17]} ) 
For nTy := 10 to Len(aContad[nPosP])//69
	nTotAtu += aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,2]
	nTotAnt	+= aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,3]
Next nTy            
 
Do Case
	Case nPosC == 4
		//V1 = Cash atual > Cash Anterior
		cMsg1 := "V1"+chr(13)+chr(10)+"Cash Atual "+cvaltochar(aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),6])
		cMsg2 := "Cash Anterior "+cvaltochar(aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),8])
	Case nPosC == 5                                       
		//V2 = Sale Atual > Sale Anterior
		cMsg1 := "V2"+chr(13)+chr(10)+"Sale Atual "+cvaltochar(aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),5])
		cMsg2 := "Sale Anterior "+cvaltochar(aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),7])
	Case nPosC == 6                                  
		//Soma dos contadores P atual > Soma dos Contadores P anterior
		cMsg1 := "V3"+chr(13)+chr(10)+"Soma dos Pดs Atual "+cvaltochar(nTotAtu)
		cMsg2 := "Soma dos Pดs Anterior "+cvaltochar(nTotAnt)
	Case nPosC == 7   
		// ajustar aqui para pegar tambem o teste atual e teste anterior
		//Sale Atual - Sale Anterior = ( Soma P Atual - Soma P Anterior ) + ( Teste Atual - Teste Anterior )
		nTotSal := 	aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),5] - aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),7]

		cMsg1 := "V4"+chr(13)+chr(10)
		cMsg1 += "Para caf้ e refrigerante:" +CRLF
		cMsg1 += "Diferen็a entre Sale atual e anterior "+cvaltochar(nTotSal) +CRLF		
		cMsg1 += "Diferen็a entre Soma P Atual - P Anterior "+cvaltochar(nTotAtu-nTotAnt) +CRLF
		
		cMsg2 := "Para Snacks:" +CRLF
		cMsg2 += "Resultado igual a Venda"
	Case nPosC == 8
		//R$ Venda X Soma Ps Atual - Anterior = Total Cash atual - Total Cash Anterior
		nTotCash := aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),6] - aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),8] 
		nTotVnd  := 0
		For nTy := 10 to Len(aContad[nPosP])//69
			nTotVnd += aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,7]
		Next nTy
		
		cMsg1 := "V5"+chr(13)+chr(10)
		cMsg1 += "Para caf้ e refrigerante:" +CRLF
		cMsg1 += "Valor da Venda x Quantidade Apontada "+cvaltochar(nTotVnd) +CRLF					
		cMsg1 += "Diferen็a entre o Cash atual e o Anterior "+cvaltochar(nTotCash) +CRLF		
		
		cMsg2 := "Para Snacks:" +CRLF
		cMsg2 += "( Venda de produto x Pre็o p๚blico ) = a Diferen็a entre o Cash atual e o Anterior " +cvaltochar(aList2[nLinha][20])
	Case nPosC == 9
		//Saldo anterior - Saldo Atual + abastecido
		nTotSld := 0
		For nTy := 10 to Len(aContad[nPosP])//69
			nTotSld += aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,8]
		Next nTy                                                                                                                                      
		cMsg1 := "V6"+chr(13)+chr(10)+"Diferen็a entre o Saldo Anterior - Saldo Atual + Abastecido"
		cMsg2 := cvaltochar(nTotSld)
	Case nPosC == 10
		//Diferen็a entre Capacidade da mola e abastecido
		cMsg1 := "V7"+chr(13)+chr(10)+"Itens com diverg๊ncia"
		cMsg2 := ""
		For nTy := 10 to Len(aContad[nPosP])//69
			If aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,12] > aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,11]
				cMsg2 += aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,1]
				cMsg2 += " Capacidade "+cvaltochar( aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,11] )
				cMsg2 += "Abastecido "+cvaltochar( aContad[Ascan(aContad,{|x| x[3] == aList2[nLinha,17]}),nTy,12] ) +chr(13)+chr(10)
			Endif
		Next nTy
		
EndCase   

MsgAlert(cMsg1+chr(13)+chr(10)+cMsg2,"editcol - TTPROC56")

RestArea(aArea)

Return           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณContAnt  บAutor  ณJackson E. de Deus   บ Data ณ  06/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca os contadores anteriores para comparacao             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ContAnt()

Local aArea	:=	Getarea()                                   
Local cQuery          
Local cVirg := ''
Local cCliente := ""
Local cLoja := ""
Local nRecno := 0
Local nDif := 0
Local nPrecoP := 0
Local cTabela := ""
Local aPRC := {}

For nXtz := 1 to len(aContad)
	cCliente := ""
	cLoja := ""
	nRecno := aContad[nXtz][3]
	dbSelectArea("SZN")
	dbGoTo(nRecno)
	cCliente := SZN->ZN_CLIENTE
	cLoja := SZN->ZN_LOJA
	cTabela := Posicione("SN1",2,xFilial("SN1") +AvKey(SZN->ZN_PATRIMO,"N1_CHAPA"),"N1_XTABELA")		

	cQuery := "SELECT TOP 5 R_E_C_N_O_ AS REG,ZN_VALIDA,ZN_COTCASH,ZN_NUMATU,"
	cVirg := ''
	For nXp := 1 to 60
		cQuery 	+= 	cVirg + "ZN_BOTAO"+Strzero(nXp,2)
		cVirg 	:= 	","
	Next nXp
	
	cQuery += " FROM "+RetSQLName("SZN")	                    
	// ALTERADO JACKSON - ALTERAR AQUI PARA CONSIDERAR TAMBEM O CLIENTE E LOJA
	cQuery += " WHERE ZN_FILIAL='"+xFilial("SZN")+"' AND ZN_PATRIMO='"+aContad[nXtz,01]+"' AND ZN_TIPINCL IN ( 'ABASTEC','LEITURA CF', 'INSTALACAO', 'REMOCAO'  ) "
	cQuery += " AND ZN_CLIENTE = '"+cCliente+"' AND ZN_LOJA = '"+cLoja+"' "
	cQuery += " AND ZN_DATA <= '"+dtos(aContad[nXtz,04])+"' AND D_E_L_E_T_='' AND R_E_C_N_O_ <> '"+cvaltochar(aContad[nXtz,03])+"' AND ZN_VALIDA <> 'X' "
	cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC"
	 
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	  	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")
	
	While !EOF()
		If TRB->ZN_VALIDA != 'X'
			aContad[nXtz,07] := TRB->ZN_NUMATU
			aContad[nXtz,08] := TRB->ZN_COTCASH
			aContad[nXtz,09] := TRB->REG
			
			cBotP := "00"
			nP := 0
			For nPto := 10 to Len(aContad[nXtz])	//69
				nVend := 0
				nPrecoP := 0
				cBotP := Soma1(cBotP)
				nP++	
				cProd := &("SN1->N1_XP"+cvaltochar(nP))
				
				If !Empty(cProd) .And. !Empty(cTabela)			
					aPRC := fPRC(cTabela,cProd)				
					nPrecoP := aPRC[2]                                                              
				EndIf	
				
				aContad[nXtz,nPto,6] := nPrecoP
				aContad[nXtz,nPto,6] := nPrecoP
				aContad[nXtz,nPto,3] := &("TRB->ZN_BOTAO" +cBotP)
				aContad[nXtz,nPto,3] := &("TRB->ZN_BOTAO" +cBotP)
				nDif := ( aContad[nXtz,nPto,2]-aContad[nXtz,nPto,3] )

				If nPrecoP > 0
					nVend := ( nDif * nPrecoP )
				EndIf
												
				aContad[nXtz,nPto,7] := nVend												
			Next nPto 
			EXIT
		EndIf
		Dbskip()
	EndDo

Next nXtz

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSldMolAnt  บAutor  ณMicrosiga           บ Data ณ  06/13/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Saldo anterior da mola para a validacao V6                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SldMolAnt(cChapa,cMola,cCli,cLj,cOs,dData,nPos1,nPos2,lCafe,nPos2C)
//chapa mola cliente loja os data
Local aArea	:=	GetArea()
Local cQuery  
Local nRet	:=	0      
Local nAux1	:=	0
Local nAux2	:=	0
Local nAux3	:=	0
Local aSZ0	:= {0,0,0} 
Local nAbast := 0
Local nSldAtu := 0
Local nEstN	:= 0
Local nSldAnt := 0
Local cOSAnt := ""
    	

cQuery := "SELECT * FROM "+RetSQLName("SZ0")
cQuery += " WHERE Z0_FILIAL='"+xFilial("SZ0")+"' AND Z0_CHAPA='"+cChapa+"' " //AND Z0_MOLA='"+cvaltochar(cMola)+"'"
//cQuery += " AND Z0_CLIENTE='"+cCli+"' AND Z0_LOJA='"+cLj+"' 
cQuery += " AND D_E_L_E_T_='' "
cQuery += " AND Z0_DATA <= '"+DTOS(dData)+"' "
cQuery += " ORDER BY Z0_DATA DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
  
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")  
While !EOF()
    If AllTrim(TRB->Z0_NUMOS) == AllTrim(cOs)	// CORRIGIDO JACKSON
    	nAbast += TRB->Z0_ABAST
    	nSldAtu += TRB->Z0_SALDO
    	nEstN	+= TRB->Z0_SLDMOV
    Else      
    	If Empty(cOSAnt)
	    	cOSAnt := TRB->Z0_NUMOS
	    Else
	    	If AllTrim(TRB->Z0_NUMOS) <> AllTrim(cOSAnt)
	    		Exit
	    	EndIf
	    EndIf                      
	    
    	nSldAnt += TRB->Z0_SLDMOV    	
    EndIf

	Dbskip()
EndDo

aSZ0[1] := nAbast
aSZ0[2] := ( nSldAnt - nSldAtu )
aSZ0[3] := nEstN

RestArea(aArea)

Return(aSZ0)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC56  บAutor  ณMicrosiga           บ Data ณ  04/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProdSZ0(cChapa,cOs,dData)

Local aProd := {}
Local cQuery := "" 
Local nPos := 0
Local nI
Local nTot := 0 
Local aPRC := {}
Local cTabela := ""


cTabela := Posicione("SZG",1,xFilial("SZG") +AvKey(cOs,"ZG_NUMOS"),"ZG_TABELA")	
If Empty(cTabela)
	Return
EndIf

cQuery := "SELECT * FROM "+RetSQLName("SZ0")
cQuery += " WHERE Z0_FILIAL='"+xFilial("SZ0")+"' AND Z0_CHAPA='"+cChapa+"' "
cQuery += " AND D_E_L_E_T_='' "
cQuery += " AND Z0_DATA = '"+DTOS(dData)+"' AND Z0_NUMOS = '"+cOs+"' "
cQuery += " ORDER BY Z0_DATA DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
  
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")  
While !EOF()
	nPos := AScan( aProd, { |x| x[1] == TRB->Z0_PRODUTO } )
	If nPos == 0
		AADD( aProd, { TRB->Z0_PRODUTO,TRB->Z0_SALDO,0,0,0,0 } )	// produto | sld atual | sld mov ant | diferenca | preco | valor total
	Else
		aProd[nPos][2] += TRB->Z0_SALDO
	EndIf
	
	dbSkip()
End


For nI := 1 To Len(aProd)
	dDataAnt := NIl
	aPRC := fPRC(cTabela,aProd[nI][1])				
	aProd[nI][5] := aPRC[2]
	
	cQuery := "SELECT TOP 1 Z0_DATA FROM "+RetSQLName("SZ0")
	cQuery += " WHERE Z0_CHAPA = '"+cChapa+"' AND D_E_L_E_T_ = '' AND Z0_DATA < '"+DTOS(dData)+"' AND Z0_PRODUTO = '"+aProd[nI][1]+"' "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	  
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")  
	If !EOF()
		dDataAnt := STOD(TRB->Z0_DATA)
	EndIf
	dbCloseArea()
	
	If dDataAnt == Nil
		Loop
	EndIf
	
	cQuery := "SELECT SUM(Z0_SLDMOV) SDLMOV FROM "+RetSQLName("SZ0")
	cQuery += " WHERE Z0_FILIAL='"+xFilial("SZ0")+"' AND Z0_CHAPA='"+cChapa+"' "
	cQuery += " AND D_E_L_E_T_= '' "
	cQuery += " AND Z0_DATA = '"+DTOS(dDataAnt)+"' AND Z0_PRODUTO = '"+aProd[nI][1]+"' "
		
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	  
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")  
	If !EOF()
		aProd[nI][3] += TRB->SDLMOV
	EndIf
Next nI

For nI := 1 To Len(aProd)
	aProd[nI][4] := aProd[nI][3] - aProd[nI][2]
	aProd[nI][6] := aProd[nI][4] * aProd[nI][5]
	nTot += aProd[nI][6]
Next nI

Asort( aProd,,,{|x,y| x[1] < y[1] } )

Return nTot


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsMd  บAutor  ณJackson E. de Deus    บ Data ณ  10/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consumo periodo                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConsMd(cPatrimo,cCliente,cLoja,dData,aEstru)

Local cSql := ""
Local nNumAnt := 0 
Local nConMed := 0
Local aSZN := {}
Local aPs := {}
Local nVisitas := 0
Local nRecAtu := 0
Local nRecAnt := 0

/*
CONSULTA DO PERIODO
INICIO = ULTIMO FECHAMENTO
FIM = DATA ATUAL
MAQUINA - CLIENTE - LOJA
*/

// ultimo fechamento
cSql := "SELECT ZN_NUMATU FROM " +RetSqlName("SZN")
cSql += " WHERE "
cSql += " D_E_L_E_T_ = '' "     
//cSql += " AND ZN_FECHAM = 'S' "	// controle do fechamento
cSql += " AND ZN_PATRIMO = '"+cPatrimo+"' "
cSql += " AND ZN_CLIENTE = '"+cCliente+"' "
cSql += " AND ZN_LOJA = '"+cLoja+"' "
cSql += " AND ZN_DATA <= '"+DTOS(dData)+"' "
cSql += " AND ZN_VALIDA <> 'X' "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
                        
TcQuery cSql New Alias "TRBZ"

dbSelectArea("TRBZ")
If !EOF()
	nNumAnt := TRBZ->ZN_NUMATU
EndIf
TRBZ->(dbCloseArea())

cSql := "SELECT R_E_C_N_O_ ZNREC FROM " +RetSqlName("SZN")
cSql += " WHERE "
cSql += " D_E_L_E_T_ = '' "
cSql += " AND ZN_PATRIMO = '"+cPatrimo+"' "
cSql += " AND ZN_CLIENTE = '"+cCliente+"' "
cSql += " AND ZN_LOJA = '"+cLoja+"' "
//cSql += " AND ZN_NUMATU > '"+CVALTOCHAR(nNumAnt)+"'"
cSql += " AND ZN_DATA > '20150922' "	// teste soh provisorio
cSql += " AND ZN_DATA <= '"+DTOS(dData)+"' "
cSql += " AND ZN_VALIDA <> 'X' "
cSql += " AND ZN_TIPINCL IN ('LEITURA CF','ABASTEC','INSTALACAO','REMOCAO') "
cSql += " ORDER BY ZN_DATA DESC, ZN_HORA DESC,ZN_NUMATU DESC"

TcQuery cSql New Alias "TRBZ"

dbSelectArea("TRBZ")
While !EOF()
	AADD( aSZN, { TRBZ->ZNREC }  )
	dbSkip()
End
TRBZ->(dbCloseArea())

// botoes
dbSelectArea("SN1")
dbSetOrder(2)
If MsSeek( xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA") )
	For nI := 1 To 60
		AADD( aPs, {&("SN1->N1_XP"+cvaltochar(nI)),0,0,0,0} )	// atual anterior total media_conversao
	Next nI
EndIf                                         

nVisitas := Len(aSZN)                                         
nRecAtu := aSZN[1][1]
nRecAnt := aSZN[Len(aSZN)][1]
dbSelectArea("SZN")
For nI := 1 To Len(aPS)
	cPosBot := PadL( cvaltochar(nI), 2, "0" )
	
	dbGoto(nRecAtu)
	aPS[nI][2] := &("SZN->ZN_BOTAO"+cPosBot)
	
	dbGoto(nRecAnt)
	aPS[nI][3] := &("SZN->ZN_BOTAO"+cPosBot)
	         
	aPS[nI][4] := aPS[nI][2] - aPS[nI][3]
Next nI

For nY := 1 To Len( aPS )
	nConvers := 0
	For nW := 1 To Len(aEstru)
		If Alltrim( aEstru[nW][01] ) == Alltrim( aPS[nY][1] )	// dose					 
	   		nConvers += aEstru[nW][5] * aPS[nY][4]
		EndIf
	Next nW
	
	aPS[nY][5] := Round( nConvers/nVisitas,4 )
Next nY

Return aPS