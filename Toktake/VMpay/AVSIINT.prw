#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑ Fonte     ณฑฑ AVSIINT												   ฑฑ	
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ  Integracao Protheus X VMPay                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AVSIINT

Private aItens:= {'1=Ativo','2=Numero Serie','3=Produto (desc.)','4=Cliente','5=Pick-Lists','6=Linha'}
Private aCateg 	:=	{} //{'1=BEBIDAS QUENTES','2=BEBIDAS GELADAS','3=SNACKS','4=LANCHES QUENTES','5=CONGELADOS','6=COMBINADA','7=AUTOATENDIMENTO'}
Private cCombo1	:=	aItens[1]     
Private cBusca	:=	space(35)
Private oDlg1,oGrp1,oBrw1,oFld1,oBrw4,oBrw3,oBrw2,oBrw5,oFld2,oBrw6,oBrw7,oBrw8,oMenu,oTButton1
Private oBrw10,oBrw11,oGrp2,oBmp1,oBmp2,oSay1,oSay2,oSay3,oGrp3,oSay4,oSay5,oSay6,oMenuP
Private oSay8,oBtn1,oBtn2    
Private oList,oList2,oList3,oList4,oList5,oList6,oList7,oList8,oList9,oList10
Private aPick  	:=	{}
Private aList	:=	{} 
Private aListB	:=	{} 
Private aList1B	:=	{}
Private aList1	:=	{}
Private aList2B	:=	{}
Private aList2	:=	{}
Private aList3B	:=	{}
Private aList3	:=	{} 
Private aList4B	:=	{}
Private aList4	:=	{}
Private aList5B	:=	{}
Private aList5	:=	{}
Private aList6	:=	{}
Private aList7	:=	{}
Private aList8B	:=	{}
Private aList8	:=	{}
Private aList9B	:=	{}
Private aList9	:=	{}
Private aList10	:=	{}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    

//PREPARE ENVIRONMENT EMPRESA "00" FILIAL "01" //MODULO "FAT" TABLES "SA1"        

//Aadd(aList,{.T.,'','','','','','','','','','','','','','','','','',''})
//Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
//Aadd(aList2,{.T.,'','','','','','','','','','','','','','','','','',''})
//Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
//Aadd(aList4,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList5,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList6,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList7,{.T.,'','','','','','','','','','','','','','','','','',''})
//Aadd(aList8,{.T.,'','','','','','','','','','','','','','','','','',''})
//Aadd(aList9,{.T.,'','','','','','','','','','','','','','','','','',''})
Aadd(aList10,{.T.,'','','','','','','','','','','','','','','','','',''})

DbSelectArea("ZZ2")
Dbgotop()
While !EOF()
	Aadd(aCateg,Alltrim(ZZ2->ZZ2_CODIGO)+"="+Alltrim(ZZ2->ZZ2_DESCRI))	
	Dbskip()
EndDo

Processa({|| Busca1(),"Aguarde, buscando ativos"})

oDlg1      := MSDialog():New( 017,058,628,1344,"Pick-List",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 000,004,148,280,"Ativos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,144,276},,, oGrp1 ) 
		oList 	   := TCBrowse():New(008,008,270,137,, {'','Ativo','Modelo','Num. S้rie','Linha'},{10,30,40,20},;
		                            oGrp1,,,,{|| FHelp()},{|| editped(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList:SetArray(aList)
		oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList[oList:nAt,02]),;
		 					 aList[oList:nAt,03],;
		 					 aList[oList:nAt,04],;
		 					 aList[oList:nAt,19]}}
		                                                                       //,"Inventแrios"
	oFld1      := TFolder():New( 000,284,{"Pick-List","Leituras","Sangrias"},{},oDlg1,,,,.T.,.F.,348,148,) 

		//oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[3] ) 
		oList1 	   := TCBrowse():New(000,001,344,135,, {'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Saldo'},{5,20,20,90,20,20,20},;
                           oFld1:aDialogs[1],,,,{|| /*FHelp(oList:nAt)*/},{|| editcol(oList2:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

		oList1:SetArray(aList1)
		oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),;
							aList1[oList1:nAt,02],; 
		 					aList1[oList1:nAt,03],;
		 					aList1[oList1:nAt,04],;
		 					aList1[oList1:nAt,05],;
		 					aList1[oList1:nAt,06],;  
		 					aList1[oList1:nAt,16],;  
		 					aList1[oList1:nAt,07]}}
		 					
		//oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[2] ) 
		oList8 	   := TCBrowse():New(000,001,344,135,, {'Data','Sele็ใo','Produto','Descri็ใo','Quant. Apont.','Valor'},{30,30,50,120,30,30},;
                           oFld1:aDialogs[2],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

		oList8:SetArray(aList8)
		oList8:bLine := {||{aList8[oList8:nAt,01],;
							aList8[oList8:nAt,02],; 
		 					aList8[oList8:nAt,03],;
		 					aList8[oList8:nAt,04],;
		 					aList8[oList8:nAt,05],;
		 					aList8[oList8:nAt,08]}}

		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[1] ) 
		oList9 	   := TCBrowse():New(000,001,344,135,, {'Data','Audit','Valor'},{30,40,40},;
                           oFld1:aDialogs[3],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList2:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)

		oList9:SetArray(aList9)
		oList9:bLine := {||{aList9[oList9:nAt,01],;
							aList9[oList9:nAt,02],; 
		 					aList9[oList9:nAt,03]}}
		 					
		//oBrw5      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,132,344},,, oFld1:aDialogs[4] ) 

	oFld2      := TFolder():New( 152,004,{"Produtos","Planogramas","Locais Inst.","Rotas","Cโnisteres","oaDialogs10"},{},oDlg1,,,,.T.,.F.,276,132,) 

		//oBrw6      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[1] ) 
		oList2 	   := TCBrowse():New(000,001,274,110,, {'','C๓digo','Descri็ใo','Saldo'},{10,30,40,20},;
		                            oFld2:aDialogs[1],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{ If(aList2[oList2:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList2[oList2:nAt,02]),;
		 					 aList2[oList2:nAt,03],;
		 					 aList2[oList2:nAt,04]}}    
		 					 
		//oBrw7      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[2] ) 
		oList3 	   := TCBrowse():New(000,001,274,110,, {'','Ativo','Selecao','Produto','Descri็ใo','Capacidade','Nivel Par','Nivel Alerta','Valor'},{10,30,30,40,30,30,30,30,30},;
		                            oFld2:aDialogs[2],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList3[oList3:nAt,02]),;
		 					 Strzero(val(aList3[oList3:nAt,03]),2),;
		 					 aList3[oList3:nAt,04],;
		 					 aList3[oList3:nAt,05],;
		 					 aList3[oList3:nAt,06],;
		 					 aList3[oList3:nAt,07],;
		 					 aList3[oList3:nAt,08],;
		 					 Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}    

		//oBrw8      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[3] ) 
		oList4 	   := TCBrowse():New(000,001,274,110,, {'','Cod. Local','Descricao'},{10,30,40},;
		                            oFld2:aDialogs[3],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList4:SetArray(aList4)             
		oList4:bLine := {||{ If(aList4[oList4:nAt,01],oOk,oNo),; 
		 					 aList4[oList4:nAt,02],;
		 					 aList4[oList4:nAt,03],;
		 					 aList4[oList4:nAt,04]}}   
		 					  
		//oBrw9      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[4] ) 
		oList5 	   := TCBrowse():New(000,001,274,110,, {'','Codigo','Descricao'},{10,30,40},;
		                            oFld2:aDialogs[4],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList5:SetArray(aList5)
		oList5:bLine := {||{ If(aList5[oList5:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList5[oList5:nAt,02]),;
		 					 aList5[oList5:nAt,03]}}   
		 					  
		//oBrw10     := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[5] ) 
		oList6 	   := TCBrowse():New(000,001,274,110,, {'','Insumo','Capacidade','Nivel Par','Nivel Alerta','Disponํvel','Utilizado'},{10,80,30,30,30,30,30},;
		                            oFld2:aDialogs[5],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList6:SetArray(aList6)
		oList6:bLine := {||{ If(aList6[oList6:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList6[oList6:nAt,02]),;
		 					 aList6[oList6:nAt,03],;
		 					 aList6[oList6:nAt,04],;
		 					 aList6[oList6:nAt,05],;
		 					 aList6[oList6:nAt,06],;
		 					 aList6[oList6:nAt,07]}}   
		 					  
		//oBrw11     := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{000,000,116,272},,, oFld2:aDialogs[6] ) 
		oList7 	   := TCBrowse():New(000,001,274,110,, {'','Ativo','Modelo','Pick-List'},{10,30,40,20},;
		                            oFld2:aDialogs[6],,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList7:SetArray(aList7)
		oList7:bLine := {||{ If(aList7[oList7:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList7[oList7:nAt,02]),;
		 					 aList7[oList7:nAt,03],;
		 					 aList7[oList7:nAt,04]}}    

	oGrp2      := TGroup():New( 152,284,198,424,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oBmp1      := TBitmap():New( 159,288,044,034,,"\system\lgtot.bmp",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oBmp2      := TBitmap():New( 159,339,044,034,,"\system\lgvmp.bmp",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
		oSay1      := TSay():New( 160,386,{||"Pick List V. 2.0"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,037,008)
		oSay2      := TSay():New( 178,386,{||"developed by"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,035,008)
		oSay3      := TSay():New( 186,387,{||"AVSI Pro"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,032,008)

	oGrp3      := TGroup():New( 209,284,285,632,"Informa็๕es do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		oSay4      := TSay():New( 221,288,{||"oSay4"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,432,008)
		oSay5      := TSay():New( 233,288,{||"oSay5"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,432,008)
		oSay6      := TSay():New( 245,288,{||"oSay6"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,432,008)
		oSay7      := TSay():New( 257,288,{||"oSay7"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,432,008)
		oSay8      := TSay():New( 269,288,{||"oSay8"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,432,008)
    
	oGrp4      := TGroup():New( 151,428,208,548,"Busca",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay9      := TSay():New( 179,432,{||"Procurar por"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oCBox1     := TComboBox():New( 163,432,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItens,108,010,oGrp4,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		oGet1      := TGet():New( 179,480,{|u|if(PCount()>0,cBusca:=u,cBusca)},oGrp4,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
		oBtn3      := TButton():New( 195,438,"Procurar",oGrp4,{||Busca2(1)},037,008,,,,.T.,,"",,,,.F. )
		oBtn4      := TButton():New( 195,495,"Filtrar",oGrp4,{||Busca2(2)},037,008,,,,.T.,,"",,,,.F. )
	

	oBtn2      := TButton():New( 180,588,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
 	
 	//Botao de faturamento
	oMenu := TMenu():New(0,0,0,0,.T.)
	// Adiciona itens no Menu
	oTMenuIte1 := TMenuItem():New(oDlg1,"Pick-List Vmpay",,,,{|| Processa({|| Vmpay(),"Buscando informa็๕es"})},,,,,,,,,.T.)
	oTMenuIte7 := TMenuItem():New(oDlg1,"Vendas Vmpay",,,,{|| Processa({|| Vendaspay(),"Buscando informa็๕es"})},,,,,,,,,.T.)
	oTMenuIte2 := TMenuItem():New(oDlg1,"Validar Saldo",,,,{|| Processa({||saldos(),"Aguarde..."})},,,,,,,,,.T.)   
	oTMenuIte3 := TMenuItem():New(oDlg1,"Inverter",,,,{|| Processa({||inverte(),"Aguarde..."})},,,,,,,,,.T.) 
	oTMenuIte4 := TMenuItem():New(oDlg1,"Validar Planograma",,,,{|| Processa({|| ValidPlan(),"Aguarde..."})},,,,,,,,,.T.) 
	oTMenuIte5 := TMenuItem():New(oDlg1,"Gerar PV",,,,{|| Processa({||pedido(),"Aguarde..."})},,,,,,,,,.T.) 
	oTMenuIte6 := TMenuItem():New(oDlg1,"Exportar Remessas",,,,{|| Processa({||Remessas(),"Aguarde..."})},,,,,,,,,.T.) 
	oMenu:Add(oTMenuIte1)
	oMenu:Add(oTMenuIte7)
	oMenu:Add(oTMenuIte2)
	oMenu:Add(oTMenuIte3)
	oMenu:Add(oTMenuIte4)
	oMenu:Add(oTMenuIte5)
	oMenu:Add(oTMenuIte6)
	//oBtn1      := TButton():New( 160,588,"oBtn1",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	// Cria botใo que sera usado no Menu
	oTButton1 := TButton():New( 160, 588, "Op็๕es",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	// Define botใo no Menu
	oTButton1:SetPopupMenu(oMenu)     
	
	// Menu popup grid 3
	MENU oMenuP POPUP 
	MENUITEM "Salvar Planograma" ACTION ( saveplan())
	MENUITEM "Incluir Planograma" ACTION ( incplan(1))
	MENUITEM "Alterar Planograma" ACTION ( incplan(2))
	MENUITEM "Excluir Planograma" ACTION ( excplan())
	MENUITEM "Replicar Planograma" ACTION ( repplan())
	
	ENDMENU                                                                           

	oList3:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }
                                                                                   

	// Menu popup grid 2
	MENU oMenu8 POPUP 
	MENUITEM "Salvar Venda" ACTION ( savevend())
	
	ENDMENU                                                                           

	oList8:bRClicked := { |oObject,nX,nY| oMenu8:Activate( nX, (nY-10), oObject ) }
	
oDlg1:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Buscan inicial;                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Busca1()

Local cQuery 
Local aAtivos	:= 	{}

cQuery := "SELECT AA3_CHAPA,B1_DESC,AA3_NUMSER,AA3_CODCLI,AA3_LOJA,AA3_HORDIA,B1_XFAMILI AS AA3_XCATEG,AA3_CODLOC,"
cQuery += " A1_NOME,A1_NREDUZ,A1_END,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP,AA3_CODPRO"
cQuery += " FROM "+RetSQLName("AA3")+" AA3 "
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=AA3_CODPRO AND B1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=AA3_CODCLI AND A1_LOJA=AA3_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " WHERE AA3.D_E_L_E_T_='' AND AA3_XVMPAY='1' ORDER BY AA3_CHAPA"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF() 
	nPos := Ascan(aCateg,{|x| substr(x,1,3) == Alltrim(TRB->AA3_XCATEG)})
	                 
	Aadd(aList,{.T.,TRB->AA3_CHAPA,TRB->B1_DESC,TRB->AA3_NUMSER,;
				TRB->A1_NOME,TRB->A1_NREDUZ,TRB->A1_END,TRB->A1_BAIRRO,TRB->A1_MUN,TRB->A1_EST,TRB->A1_CEP,;
				'','','','',.F.,TRB->AA3_CODCLI,TRB->AA3_LOJA,If(nPos>0,substr(aCateg[nPos],5),''),TRB->AA3_CODLOC,TRB->AA3_CODPRO})
	Aadd(aListB,{.T.,TRB->AA3_CHAPA,TRB->B1_DESC,TRB->AA3_NUMSER,;
				TRB->A1_NOME,TRB->A1_NREDUZ,TRB->A1_END,TRB->A1_BAIRRO,TRB->A1_MUN,TRB->A1_EST,TRB->A1_CEP,;
				'','','','',.F.,TRB->AA3_CODCLI,TRB->AA3_LOJA,If(nPos>0,substr(aCateg[nPos],5),''),TRB->AA3_CODLOC,TRB->AA3_CODPRO})
				
	If Ascan(aAtivos,{|x| Alltrim(x) == Alltrim(TRB->AA3_CHAPA)}) == 0
		Aadd(aAtivos,TRB->AA3_CHAPA)
	EndIf
	
	Dbskip()
EndDo
 
cQuery := "SELECT B1_COD,B1_DESC"
cQuery += " FROM "+RetSQLName("SB1")+" SB1 "
cQuery += " WHERE SB1.D_E_L_E_T_='' ORDER BY B1_COD"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

While !EOF()                            
	Aadd(aList2,{.F.,TRB->B1_COD,TRB->B1_DESC,0,'','','','','','','','','','','','','','',''})
	Aadd(aList2B,{.F.,TRB->B1_COD,TRB->B1_DESC,0,'','','','','','','','','','','','','','',''})
	
	Dbskip()
EndDo 

DbSelectArea("SB2")
DbSetOrder(1)
For nX := 1 to len(aList2B)
	DbSeek(xFilial("SB2")+aList2B[nX,02]+'D00001')
	nSaldo	:=	SaldoSB2()
	aList2B[nX,04] := nSaldo
	aList2[nX,04] := nSaldo
Next nX
 //ZH_CLIENTE, ZH_LOJA, ZH_CHAPA, ZH_CODMAQ, ZH_CODPROD, ZH_MOLA, 
/*          TROCAR PELA TABELA SZH010 */
//','Ativo','Selecao','Produto','Descri็ใo','Capacidade','Nivel Par','Nivel Alerta','Valor'
cQuery := "SELECT ZH_CHAPA,ZH_MOLA,ZH_CODPROD,B1_DESC,ZH_QUANT,ZH_CLIENTE,ZH_LOJA,ZH_CODMAQ" //,Z4_NIVPAR,Z4_NIVALE,Z4_VALOR
//cQuery += " Z4_INSUM1,Z4_MEDID1,Z4_INSUM2,Z4_MEDID2,Z4_INSUM3,Z4_MEDID3,Z4_INSUM4,Z4_MEDID4,Z4_INSUM5,Z4_MEDID5,Z4_INSUM6,Z4_MEDID6,Z4_INSUM7,Z4_MEDID7"
cQuery += " FROM "+RetSQLName("SZH")+" ZH"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=ZH_CODPROD AND B1.D_E_L_E_T_=''"
cQuery += " WHERE ZH.D_E_L_E_T_=''" // AND Z4_DATATE=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()  
	If Ascan(aList,{|x| Alltrim(x[2])+x[17] == Alltrim(TRB->ZH_CHAPA)+TRB->ZH_CLIENTE}) > 0
	/*    Aadd(aList3B,{.T.,Alltrim(TRB->Z4_CHAPA),strzero(val(TRB->Z4_SELECAO),2),Alltrim(TRB->Z4_CODPRO),;
	    				Alltrim(TRB->B1_DESC),TRB->Z4_CAPACID,TRB->Z4_NIVPAR,;
	    				TRB->Z4_NIVALE,TRB->Z4_VALOR,TRB->Z4_CODCLI,TRB->Z4_LOJCLI,;
	    				TRB->Z4_CODMAQ,TRB->Z4_INSUM1,TRB->Z4_MEDID1,TRB->Z4_INSUM2,TRB->Z4_MEDID2,TRB->Z4_INSUM3,TRB->Z4_MEDID3,;
	    				TRB->Z4_INSUM4,TRB->Z4_MEDID4,TRB->Z4_INSUM5,TRB->Z4_MEDID5,TRB->Z4_INSUM6,TRB->Z4_MEDID6,TRB->Z4_INSUM7,TRB->Z4_MEDID7}) */
    Aadd(aList3B,{.T.,Alltrim(TRB->ZH_CHAPA),strzero(val(TRB->ZH_MOLA),2),Alltrim(TRB->ZH_CODPROD),;
	    				Alltrim(TRB->B1_DESC),TRB->ZH_QUANT,'',;
	    				'','',TRB->ZH_CLIENTE,TRB->ZH_LOJA,;
	    				TRB->ZH_CODMAQ,'','','','','','',;
	    				'','','','','','','',''})	    				
	EndIf
	Dbskip()
EndDo
 
Asort(aList3B,,,{|x,y| x[2]+x[3] < y[2]+y[3]}) 

cQuery := "SELECT ABS_LOCAL,ABS_DESCRI,ABS_CODIGO,ABS_LOJA,ABS_END,ABS_BAIRRO,ABS_MUNIC,ABS_ESTADO,ABS_CEP"
cQuery += " FROM "+RetSQLName("ABS")
cQuery += " WHERE D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()   
    Aadd(aList4B,{.F.,TRB->ABS_LOCAL,Alltrim(TRB->ABS_DESCRI),TRB->ABS_CODIGO,TRB->ABS_LOJA,;
    				Alltrim(TRB->ABS_END),Alltrim(TRB->ABS_BAIRRO),Alltrim(TRB->ABS_MUNIC),Alltrim(TRB->ABS_ESTADO),TRB->ABS_CEP})
	Dbskip()
EndDo

cQuery := "SELECT NNR_CODIGO,NNR_DESCRI"
cQuery += " FROM "+RetSQLName("NNR")+" NNR "
cQuery += " WHERE NNR.D_E_L_E_T_='' AND SUBSTRING(NNR_CODIGO,1,1)='R' ORDER BY NNR_CODIGO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  

While !EOF() 	
	Aadd(aList5B,{.F.,TRB->NNR_CODIGO,TRB->NNR_DESCRI,'','','','','',''})
	Aadd(aList5,{.F.,TRB->NNR_CODIGO,TRB->NNR_DESCRI,'','','','','',''})
	Dbskip()
EndDo
          
/*    TROCAR PELA TABELA SZN010
	ZN_DATA,ZN_CLIENTE,ZN_BOTAO,ZN_, ZN_PATRIMO
cQuery := "SELECT Z3_DATA,Z3_CODCLI,"
                                               
For nX := 1 to 77
	cQuery += "Z3_SELEC"+cvaltochar(strzero(nX,2))+","
Next nX

For nX := 1 to 12
	cQuery += "Z3_AUDIT"+cvaltochar(strzero(nX,2))+","
Next nX

cQuery += "Z3_CHAPA"                           */

cQuery := "SELECT ZN_DATA,ZN_CLIENTE,"
                                               
For nX := 1 to 60
	cQuery += "ZN_BOTAO"+cvaltochar(strzero(nX,2))+","
Next nX

cQuery += "ZN_PATRIMO"

cQuery += " FROM "+RetSQLName("SZN")+" ZN "
cQuery += " WHERE ZN.D_E_L_E_T_='' "

cQuery += " AND ZN_PATRIMO IN('"
    
cSep	:=	''
              
For nX := 1 to len(aAtivos)
	cQuery += cSep + Alltrim(aAtivos[nX])
	cSep := "','"
Next nX

cQuery += "')"   

cQuery += " ORDER BY ZN_DATA DESC,ZN_PATRIMO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
    
DbSelectArea("TRB")  
//'Data','Sele็ใo','Produto','Descri็ใo','Quant. Apont.'   
aAux := {}
While !EOF() 	
	For nX := 1 to 60
		If !Empty(&("TRB->ZN_BOTAO"+cvaltochar(strzero(nX,2))))
			Aadd(aList8B,{stod(TRB->ZN_DATA),cvaltochar(strzero(nX,2)),'','',&("TRB->ZN_BOTAO"+cvaltochar(strzero(nX,2))),TRB->ZN_PATRIMO,TRB->ZN_CLIENTE,0})
		EndIf
	Next nX  
	/*
	For nX := 1 to 12
		IF &("TRB->Z3_AUDIT"+cvaltochar(strzero(nX,2))) > 0
			Aadd(aList9B,{stod(TRB->Z3_DATA),cvaltochar(strzero(nX,2)),&("TRB->Z3_SELEC"+cvaltochar(strzero(nX,2))),TRB->Z3_CHAPA,TRB->Z3_CODCLI})
		EndIf
	Next nX  */
	Dbskip()
Enddo         

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Pesquisas                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Busca2(nOpca)

If cCombo1 == "1"
	If nOpca == 1
		//oList:nAt := 1
		oList:refresh()
		nPos := Ascan(aList,{|x| Alltrim(cBusca) $ Alltrim(x[2])})
		If nPos > 0
			oList:nAt := nPos
		EndIf              
	Else
		aList := {}
		For nX := 1 to len(aListB)
			If Alltrim(aListB[nX,02]) == Alltrim(cBusca)
				Aadd(aList,aListB[nX])
				oList:SetArray(aList)
				oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
				 					 Alltrim(aList[oList:nAt,02]),;
				 					 aList[oList:nAt,03],;
				 					 aList[oList:nAt,04],;
				 					 aList[oList:nAt,19]}}
				exit
			EndIf   
		Next nX  
		
		If len(aList) < 1
			//For nX := 1 to len(aListB)
			//	Aadd(aList,aListB[nX])
			//Next nX	
			aList := aClone(aListB)
		EndIf  
	
		oList:SetArray(aList)
		oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList[oList:nAt,02]),;
		 					 aList[oList:nAt,03],;
		 					 aList[oList:nAt,04],;
		 					 aList[oList:nAt,19]}}
		//oList:nAt := 1
	EndIF   
	oList:refresh()
	oDlg1:refresh()    
ElseIf cCombo1 == "2" 
	If nOpca == 1
	//	oList:nAt := 1
		oList:refresh()
		nPos := Ascan(aList,{|x| Alltrim(cBusca) $ Alltrim(x[4])})
		If nPos > 0
			oList:nAt := nPos
		EndIf              
	Else
		aList := {}
		For nX := 1 to len(aListB)
			If Alltrim(aListB[nX,04]) == Alltrim(cBusca)
				Aadd(aList,aListB[nX])
				oList:SetArray(aList)
				oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
				 					 Alltrim(aList[oList:nAt,02]),;
				 					 aList[oList:nAt,03],;
				 					 aList[oList:nAt,04],;
				 					 aList[oList:nAt,19]}}
				exit
			EndIf   
		Next nX  
		
		If len(aList) < 1
			//For nX := 1 to len(aListB)
			//	Aadd(aList,aListB[nX])
			//Next nX	
            aList := aClone(aListB)

			oList:SetArray(aList)
			oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
			 					 Alltrim(aList[oList:nAt,02]),;
			 					 aList[oList:nAt,03],;
			 					 aList[oList:nAt,04],;
			 					 aList[oList:nAt,19]}}
	            
		EndIf
	EndIF   
	oList:refresh()
	oDlg1:refresh()   
ElseIf cCombo1 == "3" 
	If nOpca == 1
		//oList2:nAt := 1
		oList2:refresh()
		nPos := Ascan(aList2,{|x| Alltrim(upper(cBusca)) $ Alltrim(x[3])})
		If nPos > 0
			oList2:nAt := nPos
		EndIf              
	Else
		aList2 := {}
		For nX := 1 to len(aList2B)
			If Alltrim(upper(cBusca)) $ Alltrim(upper(aList2B[nX,03])) 
				Aadd(aList2,aList2B[nX])
			EndIf   
		Next nX  
		
		If len(aList2) < 1
			aList2 := aClone(aList2B)  
		EndIf
  
  		oList2:SetArray(aList2)
		oList2:bLine := {||{ If(aList2[oList2:nAt,01],oOk,oNo),; 
		 					 Alltrim(aList2[oList2:nAt,02]),;
		 					 aList2[oList2:nAt,03],;
		 					 aList2[oList2:nAt,04]}}
	EndIf
	oList2:refresh()
	oDlg1:refresh()
ElseIf cCombo1 == "4" 
	aList := {}
	For nX := 1 to len(aListB)
		IF Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,05]) .Or. Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,06])
			Aadd(aList,aListB[nX])
		EndIf
	Next nX
	
	If len(aList) < 1
		If !Empty(cBusca)
			MsgAlert("Nใo encontrado Ativos para o cliente pesquisado")
		EndIf
		For nX := 1 to len(aListB)
			Aadd(aList,aListB[nX])
		Next nX	
	EndIF

	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 Alltrim(aList[oList:nAt,02]),;
	 					 aList[oList:nAt,03],;
	 					 aList[oList:nAt,04],;
	 					 aList[oList:nAt,19]}}

	oList:nAt:=1
	oList:refresh()
    oDlg1:refresh()

ElseIf cCombo1 == "5"
	aList := {}
	For nX := 1 to len(aListB)
		IF aListB[nX,16]
			Aadd(aList,aListB[nX])
		EndIf
	Next nX	
	
	If len(aList) < 1
		MsgAlert("Nใo hแ pick-lists pendentes")
		For nX := 1 to len(aListB)
			Aadd(aList,aListB[nX])
		Next nX	
	EndIf
	
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 Alltrim(aList[oList:nAt,02]),;
	 					 aList[oList:nAt,03],;
	 					 aList[oList:nAt,04],;
	 					 aList[oList:nAt,19]}}

	//oList:nAt:=1
	oList:refresh() 
	oDlg1:refresh()   
ElseIf cCombo1 == "6"
	aList := {}

	For nX := 1 to len(aListB)
		IF Alltrim(UPPER(cBusca)) $ Alltrim(aListB[nX,19])
			Aadd(aList,aListB[nX])
		EndIf
	Next nX
	
	If len(aList) < 1
		If !Empty(cBusca)
			MsgAlert("Nใo encontrado Ativos com a Linha pesquisada.","busca2 - AVSIINT")
		EndIf
		For nX := 1 to len(aListB)
			Aadd(aList,aListB[nX])
		Next nX	
	EndIF

	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 Alltrim(aList[oList:nAt,02]),;
	 					 aList[oList:nAt,03],;
	 					 aList[oList:nAt,04],;
	 					 aList[oList:nAt,19]}}

	//oList:refresh()
    //oDlg1:refresh()
EndIf
 
   
    
Fhelp()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualizacao dos itens conforme ativo selecionado          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FHelp()

oSay4:settext("")
oSay5:settext("")
oSay6:settext("")
oSay7:settext("")
oSay8:settext("")

oSay4:settext('Cliente  - '+Alltrim(aList[oList:nAT,05])+" / "+Alltrim(aList[oList:nAT,06]))
oSay5:settext('Endere็o - '+Alltrim(aList[oList:nAT,07])+" / "+Alltrim(aList[oList:nAT,08])+" / "+Alltrim(aList[oList:nAT,09])+" / "+Alltrim(aList[oList:nAT,10])+" / "+Alltrim(aList[oList:nAT,11]))

aList1 := {}
aList3 := {}  
aList4 := {}  
aList6 := {}  
aList8 := {} 
aList9 := {}

For nX := 1 to len(aList3B)
	If Alltrim(aList[oList:nAt,02]) == Alltrim(aList3B[nX,02])
		Aadd(aList3,aList3B[nX])
	EndIF
Next nX  

If len(aList3) < 1
	Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
EndIf

oList3:nAt := 1
oList3:SetArray(aList3)
oList3:bLine := {||{ If(aList3[oList3:nAt,01],oOk,oNo),; 
 					 Alltrim(aList3[oList3:nAt,02]),;
 					 Strzero(val(aList3[oList3:nAt,03]),2),;
 					 aList3[oList3:nAt,04],;
 					 aList3[oList3:nAt,05],;
 					 aList3[oList3:nAt,06],;
 					 aList3[oList3:nAt,07],;
 					 aList3[oList3:nAt,08],;
 					 Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}  

For nX := 1 to len(aList1B)
	If Alltrim(aList1B[nX,08]) == Alltrim(aList[oList:nAt,02])
		Aadd(aList1,aList1B[nX])
	EndIf
Next nX
         
If len(aList1) < 1
	Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
EndIf

oList1:nAt := 1
oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),;
					aList1[oList1:nAt,02],; 
 					aList1[oList1:nAt,03],;
 					aList1[oList1:nAt,04],;
 					aList1[oList1:nAt,05],;
 					aList1[oList1:nAt,06],;  
 					aList1[oList1:nAt,16],;  
 					aList1[oList1:nAt,07]}} 
 					
For nX := 1 to len(aList4B)
	If aList4B[nX,04] == aList[oList:nAt,17] .And. aList4B[nX,05] == aList[oList:nAt,18]	
		Aadd(aList4,aList4B[nX])
		If aList4B[nX,02] == aList[oList:nAt,20] .And. !Empty(aList[oList:nAt,20])
			aList4[len(aList4),01] := .T.
			If !Empty(aList4[len(aList4),06]) 
				oSay6:settext("Local de Instala็ใo "+aList4[len(aList4),06]+" / "+aList4[len(aList4),07]+" / "+aList4[len(aList4),08]+" / "+aList4[len(aList4),09]+" / "+aList4[len(aList4),10])
			EndIf
		EndIf  
	EndIf
Next nX

If len(aList4) < 1
	Aadd(aList4,{.F.,'','','','','','','','','','','','','','','','','',''})
EndIF

oList4:nAt := 1
oList4:SetArray(aList4)             
oList4:bLine := {||{ If(aList4[oList4:nAt,01],oOk,oNo),; 
 					 aList4[oList4:nAt,02],;
 					 aList4[oList4:nAt,03],;
 					 aList4[oList4:nAt,04]}}   

For nX := 1 to len(aList8B)
	If Alltrim(aList8B[nX,06]) == Alltrim(aList[oList:nAt,02])
		Aadd(aList8,aList8B[nX])
		nPos := Ascan(aList3B,{|x| Alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList8B[nX,06])+Alltrim(aList8B[nX,02])})
		If nPos > 0  
			aList8[len(aList8),03] := aList3B[nPos,04]
			aList8[len(aList8),04] := aList3B[nPos,05]
		EndIF
	EndIf
Next nX
         
If len(aList8) < 1
	Aadd(aList8,{'','','','','','','','','','','','','','','','','','',''})
EndIf

oList8:nAt := 1
oList8:SetArray(aList8)
oList8:bLine := {||{aList8[oList8:nAt,01],;
					aList8[oList8:nAt,02],; 
 					aList8[oList8:nAt,03],;
 					aList8[oList8:nAt,04],;
 					aList8[oList8:nAt,05],;
 					aList8[oList8:nAt,08]}} 
 					
For nX := 1 to len(aList9B)
	If Alltrim(aList9B[nX,04]) == Alltrim(aList[oList:nAt,02])
		Aadd(aList9,aList9B[nX])
	EndIf
Next nX
         
If len(aList9) < 1
	Aadd(aList9,{'','','','','','','','','','','','','','','','','','',''})
EndIf

oList9:nAt := 1
oList9:SetArray(aList9)
oList9:bLine := {||{aList9[oList9:nAt,01],;
					aList9[oList9:nAt,02],; 
 					aList9[oList9:nAt,03]}}  	 

If len(aList6) < 1
	Aadd(aList6,{.F.,'','','','','','','','','','','','','','','','','','',''})
EndIf

oList6:SetArray(aList6)
oList6:bLine := {||{ If(aList6[oList6:nAt,01],oOk,oNo),; 
 					 Alltrim(aList6[oList6:nAt,02]),;
 					 aList6[oList6:nAt,03],;
 					 aList6[oList6:nAt,04],;
 					 aList6[oList6:nAt,05],;
 					 aList6[oList6:nAt,06],;
 					 aList6[oList6:nAt,07]}}   
 								
 					
oList1:refresh()
oList3:refresh()    
oList4:refresh()
oList6:refresh()
oList8:refresh()
oList9:refresh()
oList:refresh()

oDlg1:refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Buscar Pick-Lists pendentes                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VMPay()

Local aArea	:=	GetArea()
Local aRet	:=	{}
Local nSld	:=	0
Local cArmz	:=	'D00001'    
Local lFlag	:=	.f.  
Local aAuxL := 	{}
Local cPatr	:=	''
                  
aRet := U_PRTWS02()

//'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Saldo'
For nX := 1 to len(aRet)
	//If Ascan(aAuxL,{|x| Alltrim(x[2]) == aRet[nX,01]}) == 0 
		//cProdMq := Posicione("AA3",7,xFilial("AA3")+aRet[nX,01],"AA3_CODPRO")
		//cDesc := Alltrim(Posicione("SB1",1,xFilial("SB1")+cProdMq,"B1_DESC"))
	//	Aadd(aAuxL,{.T.,aRet[nX,01],cDesc,aRet[nX,16],aRet[nX,10],aRet[nX,11],aRet[nX,12],aRet[nX,13],aRet[nX,14]})	
	//EndIf
    If Alltrim(cPatr) <> Alltrim(aRet[nX,01])
	    cPatr := aRet[nX,01] 
	    cArmz := ArmAtv(cPatr)
	EndIf
              
 	If Empty(cArmz)
 		cArmz	:=	'D00001'    
 	EndIf
 	
 	If cArmz == 'D00001'
		DbSelectArea("SB2")
	    DbSetOrder(1)
	    If DbSeek(xFilial("SB2")+Avkey(aRet[nX,08],"B2_COD")+cArmz)
	    	nSld := SaldoSB2()
	    EndIf 
	Else
		DbSelectArea("SZ6")
		DbSetOrder(1)
		If DbSeek(xFilial("SZ6")+cArmz+Avkey(aRet[nX,08],"Z6_COD"))
			nSld := SZ6->Z6_QATU
		EndIf
	EndIf   
    
    cDescr := ''
   	If Ascan(aList2B,{|x| Alltrim(x[2]) == Alltrim(aRet[nX,08])}) > 0
   	//If DbSeek(xFilial("SB1")+aRet[nX,08])
    	cDescr := Alltrim(aList2B[Ascan(aList2B,{|x| Alltrim(x[2]) == Alltrim(aRet[nX,08])}),03])
    EndIf
    
	If nSld < val(aRet[nX,05]) .Or. nSld == 0
		lFlag := .F.  
		nPosAtv := Ascan(aList,{|x| Alltrim(x[2]) == aRet[nX,01]})
		If nPosAtv > 0
			aList[nPosAtv,01] := .F.
		EndIf 
		nPosAtv := Ascan(aListB,{|x| Alltrim(x[2]) == aRet[nX,01]})
		If nPosAtv > 0
			aListB[nPosAtv,01] := .F.
		EndIf 
		
	Else
		lFlag := .T.
	EndIf     
	//Marcando ativos que tem pick-lists pendentes
	nPosAtv := Ascan(aList,{|x| Alltrim(x[2]) == aRet[nX,01]})
	If nPosAtv > 0
		aList[nPosAtv,16] := .T.
	EndIf
	nPosAtv := Ascan(aListB,{|x| Alltrim(x[2]) == aRet[nX,01]})
	If nPosAtv > 0
		aListB[nPosAtv,16] := .T.
	EndIf
	
	Aadd(aList1B,{lFlag,aRet[nX,15],aRet[nX,08],cDescr,;
				val(aRet[nX,05]),val(aRet[nX,05]),nSld,aRet[nX,01],aRet[nX,02],;
				aRet[nX,03],aRet[nX,17],aRet[nX,16],aRet[nX,18],aRet[nX,19],aRet[nX,20],aRet[nX,21]})	
Next nX   
          
Asort(aList1B,,,{|x,y| Alltrim(x[8])+Alltrim(x[2]) < Alltrim(y[8])+Alltrim(y[2])})

For nX := 1 to len(aList1B)
	If Alltrim(aList1B[nX,08]) == Alltrim(aList[oList:nAt,02])
		Aadd(aList1,aList1B[nX])
	EndIf
Next nX
         
If len(aList1) < 1
	Aadd(aList1,{.T.,'','','','','','','','','','','','','','','','','',''})
EndIf

//aList1 := aClone(aList1B)  
oList1:SetArray(aList1)
oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),;
					aList1[oList1:nAt,02],; 
 					aList1[oList1:nAt,03],;
 					aList1[oList1:nAt,04],;
 					aList1[oList1:nAt,05],;
 					aList1[oList1:nAt,06],;  
 					aList1[oList1:nAt,16],;  
 					aList1[oList1:nAt,07]}}
oList1:refresh()    
oDlg1:refresh()     

If MsgYesNo("Filtrar somente ativos com Pick-List pendentes?","VMPay - AVSIINT")
	cCombo1 := "5"
	Busca2(1)	
EndIF

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Edita a coluna de saldo do item do picklist                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(nLinha2)

Local aArea		:=	GetArea()
Local cBkMail	:=	aList1[nLinha2,6]
Local lSaldo	:=	.F.
                       
While !lSaldo
	aList1[nLinha2,6] := space(4-len(cvaltochar(aList1[nLinha2,6])))+cvaltochar(aList1[nLinha2,6])
	lEditCell( aList1, oList1, "", 6)

	aList1[nLinha2,06] := val(aList1[nLinha2,06])
	
	If aList1[nLinha2,6] <= aList1[nLinha2,7]
		lSaldo := .T.
	Else
		If MsgYesNo("Nใo hแ saldo para atender este item, confirma a inclusใo desta quantidade?","editcol - PRTOPE01")
			lSaldo := .T.
		EndIF
	EndIf    
EndDo



oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function saldos()

Local aArea		:=	GetArea()
Local nSaldo	:=	0  
Local nPedido	:=	0    
Local aSldPrd	:=	{}

For nX := 1 to len(aList1B)
	If Ascan(aSldPrd,{|x| x[1] == aList1B[nX,03]}) == 0
		cProd	:=	aList1B[nX,03]  
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial("SB2")+Avkey(cProd,"B2_COD")+Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD"))
		nSaldo := SaldoSB2()
		nTotais:= 0
		AEval(aList1B,{|aList1B| nTotais += If(aList1B[3]==cProd,aList1B[6],0)}) 
		//AEval(aList2B,{|aList2B| nPedido += If(aList2B[3]==cProd,aList2B[6],0)}) 
		//Aadd(aSldPrd,{aList2B[nX,03],Alltrim(aList2B[nX,04]),aList2B[nX,07],nSaldo,If(nSaldo>aList2B[nX,07],.T.,.F.)})
		Aadd(aSldPrd,{aList1B[nX,03],Alltrim(aList1B[nX,04]),nTotais,nSaldo,If(nSaldo<nTotais,.T.,.F.)})
	EndIF
Next nX

Asort(aSldPrd,,,{|x,y| x[5] > y[5]})
 
SldItem(aSldPrd)

RestArea(aArea)

Return                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT  บAutor  ณMicrosiga           บ Data ณ  03/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Tela com saldo por item para administracao               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SldItem(aProdc)

Local aArea	:=	GetArea()
Private oSaldo1,oSaldo2
Private aSaldo1	:= {}
Private aSaldo2 := {}
Private aItAux1 := {}
Private aItAux2 := {}

SetPrvt("oSaldo","oGrsld1","oBrw1","oGrsld2","oBrw2","oBtSld1")

For nX := 1 to len(aProdc)
	If aProdc[nX,05]
		nPosx := Ascan(aSaldo1,{|x| Alltrim(x[1]) == Alltrim(aProdc[nX,01])}) 
	    IF nPosx == 0
	    	Aadd(aSaldo1,aProdc[nX])
	    	For nJ := 1 to len(aList1B)
	    		If Alltrim(aList1B[nJ,03]) == Alltrim(aProdc[nX,01])
	    			Aadd(aItAux2,{Alltrim(aProdc[nX,01]),Alltrim(aProdc[nX,02]),aList1B[nJ,06],aList1B[nJ,08]})
	    		EndIf
	    	Next nJ
	    EndIf
	EndIF
Next nX

If len(aItAux2) < 1
	Aadd(aItAux2,{'','','',''})  
EndIf

If len(aSaldo1) > 0	
	oSaldo     := MSDialog():New( 092,232,535,1027,"oSaldo",,,.F.,,,,,,.T.,,,.T. )
	
		oGrsld1    := TGroup():New( 000,004,192,196,"Produto",oSaldo,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,188,116},,, oGrsld1 ) 
		oSaldo1 	   := TCBrowse():New(008,008,185,180,, {'Produto','Descricao','Saldo'},{40,40,40},;
	                            oGrsld1,,,,{|| FSaldo(oSaldo1:nAt)},{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
	
		oSaldo1:SetArray(aSaldo1)
		oSaldo1:bLine := {||{ aSaldo1[oSaldo1:nAt,01],;
								Alltrim(aSaldo1[oSaldo1:nAt,02]),;
								aSaldo1[oSaldo1:nAt,04]}}
	
		oGrsld2    := TGroup():New( 000,200,192,388,"Ativos",oSaldo,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,128,188,260},,, oGrsld2 ) 
		oSaldo2 	   := TCBrowse():New(008,203,180,180,, {'Ativo','Produto','Qtd'},{40,40,40},;
	                            oGrsld2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
	
		oSaldo2:SetArray(aSaldo2)
		oSaldo2:bLine := {||{ aSaldo2[oSaldo2:nAt,01],;
								aSaldo2[oSaldo2:nAt,02],;
								aSaldo2[oSaldo2:nAt,03]}}
	
	oBtSld1    := TButton():New( 196,228,"Sair",oSaldo,{||oSaldo:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oSaldo:Activate(,,,.T.)
EndIf
 
RestArea(aArea)

Return         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  03/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FSaldo(nLinha)

Local aArea	:=	GetArea()
         
aSaldo2 := {}

For nX := 1 to len(aItAux2)      
	If Alltrim(aItAux2[nX,01]) == Alltrim(aSaldo1[nLinha,01])
		Aadd(aSaldo2,{aItAux2[nX,04],aItAux2[nX,01],aItAux2[nX,03]})
	EndIf
Next nX

If len(aSaldo2) < 1
	Aadd(aSaldo2,{'','',''})
EndIf

oSaldo2:SetArray(aSaldo2)
oSaldo2:bLine := {||{ aSaldo2[oSaldo2:nAt,01],;
						aSaldo2[oSaldo2:nAt,02],;
						aSaldo2[oSaldo2:nAt,03]}}

oSaldo2:refresh()
oSaldo:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Inverte marcacao do alist com os ativos para geracao do   บฑฑ
ฑฑบ          ณpedido                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function inverte()
                                                 
Local aArea	:=	GetArea()

For nX := 1 to len(aList) 
	IF aList[nX,16]
		If aList[nX,01] 
			aList[nX,01] := .F.
		Else 
			aList[nX,01] := .T.
		EndIf
	EndIF
Next nX
      
oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  02/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Linha do primeiro grid                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editped(nLinha)

Local aArea	:=	GetArea()

If aList[nLinha,01]
	aList[nLinha,01] := .F.
Else
	aList[nLinha,01] := .T.
EndIf

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Geracao do pedido de venda                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pedido()

Local aArea	:=	GetArea()
Local aCabec	:=	{}
Local aItens	:=	{}  
Local nItem		:=	1
Local aLinha	:=	{}  
Local nContJ	:=	0   
Local nPreco	:=	0     
Local cMsgPed	:=	""
Local cBarra	:=	""      
Local lPick		:=	.F.
                            
If Empty(aList[1,2])
	Return
EndIf

For nContJ := 1 to len(aList)
	If aList[nContJ,01] .And. aList[nContJ,16]
		
		cArmz := ArmAtv(aList[nContJ,02]) 
		
		aCabec := {} 
		aItens := {}    
		lPick  := .F.
		aAdd( aCabec , { "C5_FILIAL" 	, xFilial("SC5")					, Nil } )
		aAdd( aCabec , { "C5_TIPO" 		, 'N'								, Nil } )
		aAdd( aCabec , { "C5_CLIENTE"	, '000001'						  	, Nil } )
		aAdd( aCabec , { "C5_LOJACLI"	, '0001'					   		, Nil } )
		//aAdd( aCabec , { "C5_CLIENT"	, aList[nContJ,17]				  	, Nil } )
		//aAdd( aCabec , { "C5_LOJAENT"	, aList[nContJ,18]			   		, Nil } )
		//aAdd( aCabec , { "C5_NATUREZ"	, '101050'					      	, Nil } )
		aAdd( aCabec , { "C5_XCCUSTO"	, '70500002'					    , Nil } )
		//aAdd( aCabec , { "C5_XCCONTA"	, '40406'						    , Nil } )
		aAdd( aCabec , { "C5_TIPOCLI"	, 'F'			      				, Nil } )
		Aadd( aCabec , { "C5_MENNOTA"	, 'Pedido Gerado pelo Pick-List do Patrimonio '+aList[nContJ,02], Nil } )
		aAdd( aCabec , { "C5_CONDPAG"	, '001'								, Nil } )	
		//aAdd( aCabec , { "C5_TABELA"	, '001'								, Nil } )	
		//aAdd( aCabec , { "C5_XPDV"		, 'M'+aList[nContJ,02]				, Nil } )	
		aAdd( aCabec , { "C5_XDTENTR"	, DDATABASE+1						, Nil } )	
		aAdd( aCabec , { "C5_XNFABAS"	, '1'								, Nil } )	
		aAdd( aCabec , { "C5_XCODPA"	, cArmz								, Nil } )	
		aAdd( aCabec , { "C5_XFINAL"	, '4'								, Nil } )	
		aAdd( aCabec , { "C5_TRANSP"	, '000019'							, Nil } )	
		aAdd( aCabec , { "C5_VEND1"		, '000023'							, Nil } )	
		aAdd( aCabec , { "C5_ESPECI1"	, 'UN'								, Nil } )	
		
        nItem := 1
		For nJ := 1 to len(aList1B)
			If Alltrim(aList[nContJ,02]) == Alltrim(aList1B[nJ,08]) 
				aLinha := {}    
				nPreco := Posicione("SB1",1,xFilial("SB1")+aList1B[nJ,03],"B1_CUSTD")
				nPreco := Round(nPreco + (nPreco*0.30),2)
				If nPreco <= 0
					nPreco := 9.99
				EndIf       
				
				If Valtype(aList1B[nJ,06]) == "N"
					If aList1B[nJ,06] <> aList1B[nJ,05] 
						ConfQtd()                                   
					EndIf
				EndIF
				
				If aList1B[nJ,06] < 1
					loop
				EndIf
				
				/*cTesut := ''
				
				If Empty(Posicione("SB1",1,xFilial("SB1")+aList1B[nJ,03],"B1_CEST"))
					cTesut	:=	'512'
				Else
					cTesut 	:=	'503'
				EndIf       */
				
				aAdd( aLinha , { "C6_FILIAL"	, xFilial("SC6") 									, Nil })
				aAdd( aLinha , { "C6_ITEM"		, aList1B[nJ,02]									, Nil })         //StrZero(nItem,TamSX3("C6_ITEM")[1])
				aAdd( aLinha , { "C6_PRODUTO"	, aList1B[nJ,03]			 						, Nil })
				aAdd( aLinha , { "C6_QTDVEN"	, aList1B[nJ,06]									, Nil })
				aAdd( aLinha , { "C6_PRCVEN"	, nPreco											, Nil })
				aAdd( aLinha , { "C6_LOCAL"		, If(substr(cArmz,1,1)=="A","P"+substr(cArmz,2),cArmz)												, Nil })
//				aAdd( aLinha , { "C6_OPER"		, '03'	 											, Nil })  
				//aAdd( aLinha , { "C6_TES"		, cTesut 											, Nil })  
				aAdd( aLinha , { "C6_QTDLIB"	, aList1B[nJ,06]									, Nil })
				aAdd( aItens , aLinha ) 
		    	nItem++
			EndIf
		Next nJ 
		
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3)
			
		If lMsErroAuto  
			//DisarmTransaction()
			MostraErro()
			//Return
		Else
			//MSGALERT("PEDIDO "+SC5->C5_NUM)
			cMsgPed += cBarra + SC5->C5_NUM
			cBarra := ","
			/*DbSelectArea("SZ0")
			DbSetOrder(1)
			For nJ := 1 to len(aList1B)
				If Alltrim(aList[nContJ,02]) == Alltrim(aList1B[nJ,08])
					Reclock("SZ0",.T.)
					SZ0->Z0_PICKLIS	:=	aList1B[nJ,12]
					SZ0->Z0_PLAITID	:=	aList1B[nJ,11]
					If Valtype(aList1B[nJ,13]) <> "D" 
						aList1B[nJ,13] := ctod(aList1B[nJ,13])
					EndIf
					SZ0->Z0_DATA	:=	aList1B[nJ,13]
					SZ0->Z0_HORA	:=	aList1B[nJ,14]
					SZ0->Z0_CHAPA	:=	aList1B[nJ,08]
					SZ0->Z0_CLIENTE	:= 	aList[nContJ,17]
					SZ0->Z0_LOJA	:=	aList[nContJ,18]
					SZ0->Z0_PRODUTO	:=	aList1B[nJ,03]
					SZ0->Z0_QTDSOL	:=	aList1B[nJ,05]
					SZ0->Z0_QTDCONF	:=	aList1B[nJ,06]
					SZ0->Z0_SALDO	:=	aList1B[nJ,07]
					SZ0->Z0_PEDIDO	:=	SC5->C5_NUM
					SZ0->(Msunlock())
				EndIf
			Next nJ            */
		 	//cRet := SC5->C5_NUM
		 	//cNfG := GeraNf(SC5->C5_NUM,aList[1,25],cTipnf)
		    //Monta Array para gerar email com pedidos faturados.	
			//Aadd(aEmail,{aList[nX,10],aList[nX,24],cRet,cNfG})
       	 EndIf
	EndIf
Next nContJ         

MsgAlert("Pedido(s) Gerado(s) "+cMsgPed,"PRTOPE01")
oDlg1:end()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Alterar quantidade de itens modificados na rotina no VMPayบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfQtd()

Local aArea		:=	GetArea() 
Local aAuxAr	:=	{}
Local nPos 		:=	Ascan(aPick,{|x| Alltrim(x[1]) == Alltrim(aList1B[nJ,08])})
Local aAuxPl	:=	strtokarr(aPick[nPos,02],",")  
Local nPos2		:=	Ascan(aAuxPl,{|x| substr(x,1,8) == "items:id"})    
Local aAuxP		:=	{}
Local cVarVM	:=	''
Local aAuxRet	:=	{}
Local aAuxR2	:=	{}
Local oRestClient 	:= FWRest():New("http://vmpay.vertitecnologia.com.br")
//Local oRestClient := FWRest():New("http://demo.vmpay.vertitecnologia.com.br")
Local aHeader	:=	{}        
Local nPikid	:=	199090      
Local cChavH	:=	"?access_token=JKRwU4xyVkMFwLY4zP5wmMOSfUAJ0YD1UfgqEMU7"
Local cChavP	:=	"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB"  

Aadd(aHeader, "Authorization: Basic " + Encode64("access_token:AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB"))

cDtCriac := Date()
cDtCriac := Dtos(cDtCriac)
cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
cDtCriac += "T" +cvaltochar(time())+".000-03:00"
              
aAuxP := strtokarr(aAuxPl[1],":")
//cVarVM := '{'+CRLF
//cVarVM +=	'	"'+aAuxP[1]+'":'+aAuxP[2]+','+CRLF
Aadd(aAuxAr,aAuxPl[1])

//cVarVM += 	'	"'+substr(aAuxPl[2],1,11)+'": "'+cDtCriac+'",'+CRLF
Aadd(aAuxAr,substr(aAuxPl[2],1,11)+cDtCriac)             

//cVarVM += 	'	"'+substr(aAuxPl[3],1,11)+'": "'+cDtCriac+'",'+CRLF
Aadd(aAuxAr,substr(aAuxPl[3],1,11)+cDtCriac)

aAuxP := strtokarr(aAuxPl[4],":")
//cVarVM += 	'	"'+aAuxP[1]+'":'+aAuxP[2]+','+CRLF

//cVarVM += 	'	"pending":true,'+CRLF
                          
//cVarVM += 	'	"items": [ '+CRLF

Aadd(aAuxAr,aAuxPl[4])             

               
//aAuxP := strtokarr(aAuxPl[nPos2+1],":")
//cVarVM += 	'	{'+CRLF             
//cVarVM += 	'		"id":'+cvaltochar(nPikid)+','+CRLF
//cVarVM +=	'		"'+aAuxP[1]+'": '+aAuxP[2]+','+CRLF
//aAuxP := strtokarr(aAuxPl[nPos2+2],":")
//cVarVM += 	'		"'+aAuxP[1]+'":'+aAuxP[2]+CRLF
//cVarVM +=	' 	}'+CRLF

nPikid++

Aadd(aAuxAr,{substr(aAuxPl[nPos2],7),aAuxPl[nPos2+1],aAuxPl[nPos2+2],aAuxPl[nPos2+4]})

For nX := nPos2+5 to len(aAuxPl) step 5
	Aadd(aAuxAr,{aAuxPl[nX],aAuxPl[nX+1],aAuxPl[nX+2],aAuxPl[nX+4]})
	aAuxP := strtokarr(aAuxPl[nX+1],":")
	/*cVarVM += 	'	,'+CRLF
	cVarVM +=	'	{'+CRLF
	cVarVM += 	'		"id":'+cvaltochar(nPikid)+','+CRLF
	cVarVM +=	'		"'+aAuxP[1]+'":'+aAuxP[2]+','+CRLF
	aAuxP := strtokarr(aAuxPl[nX+2],":")
	cVarVM += 	'		"'+aAuxP[1]+'":'+aAuxP[2]+CRLF
	cVarVM +=	'	}'+CRLF
	nPikid++*/
Next nX
/*
cVarVM += 	'  ]'+CRLF
cVarVM += '}'+CRLF
*/       

For nX := 5 to len(aAuxAr)
	If aAuxAr[nX,01] == "id:"+aList1B[nJ,09]
		nPos3 := nX
		exit
	EndIf
Next nX

cVarVM += 	'	{'+CRLF
cVarVM += 	'	"pick_list": {'+CRLF             
cVarVM += 	'		"items_attributes"	: ['+CRLF

//If nPos3 > 0
	//cVarVM += '"'+substr(aAuxAr[1],1,2)+'"'+substr(aAuxAr[1],3)
	//Aadd(aAuxRet,'"'+substr(aAuxAr[1],1,2)+'"'+substr(aAuxAr[1],3))
	Aadd(aAuxRet,aAuxAr[1])
	
	//cVarVM += '"'+substr(aAuxAr[2],1,10)+'":"'+substr(aAuxAr[2],12)+'"'
	//Aadd(aAuxRet,'"'+substr(aAuxAr[2],1,10)+'":"'+substr(aAuxAr[2],12)+'"')
	Aadd(aAuxRet,aAuxAr[2])
	
	//cVarVM += '"'+substr(aAuxAr[3],1,10)+'":"'+substr(aAuxAr[3],12)+'"'
	//Aadd(aAuxRet,'"'+substr(aAuxAr[3],1,10)+'":"'+substr(aAuxAr[3],12)+'"')
	Aadd(aAuxRet,aAuxAr[3])
	
	//cVarVM += '"'+substr(aAuxAr[4],1,12)+'":'+substr(aAuxAr[4],14)
	//Aadd(aAuxRet,'"'+substr(aAuxAr[4],1,12)+'":'+substr(aAuxAr[4],14))
	Aadd(aAuxRet,aAuxAr[4])
	
	//cVarVM += '"items":['
	//Aadd(aAuxRet,'"items":')
	Aadd(aAuxRet,"pending:true")
	Aadd(aAuxRet,"items:")
	
	//For nPos3 := 5 to len(aAuxAr)
		aAuxR2 := {}
		//cVarVM += '"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3)
		//Aadd(aAuxR2,'"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3))
		//Aadd(aAuxR2,aAuxAr[nPos3,01])
		cVarVM += '{'+CRLF
		cVarVM += '"'+substr(aAuxAr[nPos3,1],1,2)+'"'+substr(aAuxAr[nPos3,1],3)+','+CRLF
		
		
		aAuxP	:=	strtokarr(aAuxAr[nPos3,2],":")
		cVarVM += '"'+aAuxP[1]+'":'+aAuxP[2]+','+CRLF
	    //Aadd(aAuxR2,'"'+aAuxP[1]+'":'+aAuxP[2])
	    Aadd(aAuxR2,aAuxAr[nPos3,02])
	    
		aAuxP	:=	strtokarr(aAuxAr[nPos3,3],":")
		cVarVM += '"'+aAuxP[1]+'":'+cvaltochar(aList1B[nJ,06])+CRLF
		cVarVM += ' }'+CRLF
		//Aadd(aAuxR2,'"'+aAuxP[1]+'":'+aAuxP[2])
		Aadd(aAuxR2,aAuxAr[nPos3,03])
	    
	    cVarVM += '  ]'+CRLF
	    cVarVM += ' }'+CRLF
	    cVarVM += '}'+CRLF
		Aadd(aAuxRet,aAuxR2)      
  	//Next nX
	                                                              
	//Aadd(aHeader, "Authorization:" + GetMv("TI_MIDAUTH",,""))
	Aadd(aHeader, "Content-Type: application/json")

	cPath := aPick[nPos,03]
	//oRestClient:setPath(cPath+cChavP) 
	//oRestClient:Delete()

	//cPath := substr(aPick[nPos,03],1,at("lists/",aPick[nPos,03])+4)
	
	oRestClient:setPath(cPath+cChavP) 

	                                           
	//oRestClient:setPath(cPath)   
	oRestClient:SetPostParams(cVarVM)
	
	If oRestClient:Put(aHeader,cVarVM)             
	//IF oRestClient:Post(aHeader)
		//cResult := oRestClient:GetResult("GET")
		cResult := oRestClient:GetResult()
	Else
		cResult := oRestClient:GetLastError()
	EndIf
	
	//MsgAlert(cResult)                
		
	//EndIf
    
//EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar o planograma da maquina no vmpay                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPlan()

Local aArea	:=	GetArea()
      
U_PRTWS03(aList[oList:nAt,02],1)

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/15/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Salvar o planograma de acordo com o contido no vmpay      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Saveplan()

Local aArea	:=	GetArea()
Local aCabec:=	{"ZH_CLIENTE","ZH_LOJA","ZH_CHAPA","ZH_CODMAQ","ZH_CODPROD","ZH_MOLA","ZH_QUANT","ZH_NIVPAR","ZH_NIVALE","ZH_VALOR"}
Local nPosB	:=	Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aList3[oList3:nAt,02])}) 
Local lAlt	:=	.F. 
Local lMolD	:=	.F.
Local aAuxD	:=	{}
 //ZH_CLIENTE, ZH_LOJA, ZH_CHAPA, ZH_CODMAQ, ZH_CODPROD, ZH_MOLA, 
//FILIAL+CHAPA+SELECAO+CODCLI
For nX := 1 to len(aList3)
	If !aList3[nX,01] 
		DbSelectArea("SZH")     
		DbSetOrder(2)

		If "," $ aList3[nX,03] 
	   		aAuxD := strtokarr(aList3[nX,03],",")
	   		lMolD := .T.
	   		
	   		For nPing := 1 to len(aAuxD)  
	   			DbSelectArea("SZH")     
				DbSetOrder(2)
                ////ZH_CLIENTE, ZH_LOJA, ZH_CHAPA, ZH_CODMAQ, ZH_CODPROD, ZH_MOLA,
		   		If !DbSeek(xFilial("SZH")+aList3[nX,02]+aList[oList:nAt,17]+aList[oList:nAt,18]+Avkey(aAuxD[nPing],"ZH_MOLA"))
		   			Reclock("SZH",.T.)
					SZH->ZH_CLIENTE	:=	aList[oList:nAt,17]
					SZH->ZH_LOJA	:=	aList[oList:nAt,18]
					SZH->ZH_CHAPA	:=	aList3[nX,02]
					SZH->ZH_CODMAQ	:=	Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
					SZH->ZH_CODPROD	:=	aList3[nX,04]
					SZH->ZH_MOLA	:=	aAuxD[nPing]     
					SZH->ZH_DINICIO	:=	dDataBase
					SZH->ZH_QUANT	:=	aList3[nX,06]
					/*SZH->ZH_NIVPAR	:=	aList3[nX,07]
					SZH->ZH_NIVALE	:=	aList3[nX,08]
					SZH->ZH_VALOR	:=	aList3[nX,09]*/
					SZH->(Msunlock()) 
				Else
					If SZH->ZH_CODPROD <> aList3[nX,04]
						//Primeiro altera o existente
						/*Reclock("SZH",.F.)
						SZ4->Z4_DATATE	:= dDataBase
						SZ4->Z4_SELECAO	:= Alltrim(SZ4->Z4_SELECAO)+"X"
						SZ4->(Msunlock())*/
						//Na sequencia cria um novo
						Reclock("SZH",.T.)
						SZH->ZH_CLIENTE	:=	aList[oList:nAt,17]
						SZH->ZH_LOJA	:=	aList[oList:nAt,18]
						SZH->ZH_CHAPA	:=	aList3[nX,02]
						SZH->ZH_CODMAQ	:=	Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
						SZH->ZH_CODPROD	:=	aList3[nX,04]
						SZH->ZH_MOLA	:=	aList3[nX,03]
						SZH->ZH_DINICIO :=	dDataBase
						SZH->Z4_QUANT	:=	aList3[nX,06]
						/*SZH->Z4_NIVPAR	:=	aList3[nX,07]
						SZH->Z4_NIVALE	:=	aList3[nX,08]
						SZH->Z4_VALOR	:=	aList3[nX,09]*/
						SZH->(Msunlock())
					EndIf
				EndIf
			Next nPing
	 	Else
	   		If !DbSeek(xFilial("SZH")+aList3[nX,02]+aList[oList:nAt,17]+aList[oList:nAt,18]+Avkey(aList3[nX,03],"ZH_MOLA"))
	//		If !DbSeek(xFilial("SZ4")+aList3[nX,02]+Avkey(aList3[nX,03],"Z4_SELECAO")+aList[oList:nAt,17])	
				Reclock("SZH",.T.)
				SZH->ZH_CLIENTE	:=	aList[oList:nAt,17]
				SZH->ZH_LOJA	:=	aList[oList:nAt,18]
				SZH->ZH_CHAPA	:=	aList3[nX,02]
				SZH->ZH_CODMAQ	:=	Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
				SZH->ZH_CODPROD	:=	aList3[nX,04]
				SZH->ZH_MOLA	:=	aList3[nX,03]
				SZH->ZH_DINICIO	:=	dDataBase
				SZH->ZH_QUANT	:=	If(Valtype(aList3[nX,06])<>"N",val(aList3[nX,06]),aList3[nX,06])
				/*SZH->ZH_NIVPAR	:=	If(Valtype(aList3[nX,07])<>"N",val(aList3[nX,07]),aList3[nX,07])
				SZH->ZH_NIVALE	:=	If(Valtype(aList3[nX,08])<>"N",val(aList3[nX,08]),aList3[nX,08])
				SZH->ZH_VALOR	:=	If(Valtype(aList3[nX,09])<>"N",val(aList3[nX,09]),aList3[nX,09])*/
				SZH->(Msunlock())
			Else
				If SZ4->Z4_CODPRO <> aList3[nX,04]
					//Primeiro altera o existente
					/*Reclock("SZ4",.F.)
					SZ4->Z4_DATATE	:= dDataBase
					SZ4->Z4_SELECAO	:= Alltrim(SZ4->Z4_SELECAO)+"X"
					SZ4->(Msunlock())*/
					//Na sequencia cria um novo
					Reclock("SZH",.T.)
					SZH->ZH_CLIENTE	:=	aList[oList:nAt,17]
					SZH->ZH_LOJA	:=	aList[oList:nAt,18]
					SZH->ZH_CHAPA	:=	aList3[nX,02]
					SZH->ZH_CODMAQ	:=	Posicione("AA3",7,xFilial("AA3")+aList3[nX,02],"AA3_CODPRO")
					SZH->ZH_CODPROD	:=	aList3[nX,04]
					SZH->ZH_MOLA	:=	aList3[nX,03]
					SZH->ZH_QUANT	:=	aList3[nX,06]
					/*SZH->ZH_NIVPAR	:=	aList3[nX,07]
					SZH->ZH_NIVALE	:=	aList3[nX,08]
					SZH->ZH_VALOR	:=	aList3[nX,09]*/
					SZH->(Msunlock())
				EndIf
			EndIf 
		EndIf
		aList3[nX,01] := .T.
		lAlt := .T.
	EndIF	
Next nX
                   
If lAlt
	For nX := 1 to len(aList3)
		nPos := Ascan(aList3B,{|x| alltrim(x[2])+Alltrim(x[3]) == Alltrim(aList3[nX,02])+Alltrim(aList3[nX,03])})
		If nPos > 0         
			For nJ := 1 to len(aList3[nX])
				aList3B[nPos,nJ] := aList3[nX,nJ]
			Next nJ
		Else
			Aadd(aList3B,aList3[nX])
		EndIf
	Next nX
EndIf

oList3:refresh()
oDlg1:refresh()

RestArea(aArea)

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  iNCLUIR PLANOGRAMAS                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function incplan(nSelec)
      
Local aArea	:=	GetArea()  
Local nOpcao := 0
Private oPlanog	               
SetPrvt("oPlan1","oGrPlan","oBrw1","oBtn1","oBtn2")
Private aPlanog := {}
  
If nSelec == 1
	aadd(aPlanog,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
					'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
Else
	aPlanog := BuscPlan()
EndIf

oPlan1     := MSDialog():New( 092,232,577,1480,"Incluir Planograma",,,.F.,,,,,,.T.,,,.T. )

	oGrPlan    := TGroup():New( 000,004,212,619,"Produtos",oPlan1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,208,340},,, oGrPlan ) 
	oPlanog 	   := TCBrowse():New(008,008,609,202,, {'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Insumo1','Dosagem1','Insumo2','Dosagem2','Insumo3','Dosagem3','Insumo4','Dosagem4','Insumo5','Dosagem5','Insumo6','Dosagem6','Insumo7','Dosagem7'},;
						{5,20,20,90,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20},;
                           oGrPlan,,,,{|| /*FHelp(oList:nAt)*/},{|| editplan(oPlanog:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

	oPlanog:SetArray(aPlanog)
	oPlanog:bLine := {||{If(aPlanog[oPlanog:nAt,01],oOk,oNo),;
						aPlanog[oPlanog:nAt,02],; 
	 					aPlanog[oPlanog:nAt,03],;
	 					aPlanog[oPlanog:nAt,04],;
	 					aPlanog[oPlanog:nAt,05],;
	 					aPlanog[oPlanog:nAt,06],;  
	 					aPlanog[oPlanog:nAt,07],;  
	 					aPlanog[oPlanog:nAt,08],;
	 					aPlanog[oPlanog:nAt,09],;
	 					aPlanog[oPlanog:nAt,10],;
	 					aPlanog[oPlanog:nAt,11],;
	 					aPlanog[oPlanog:nAt,12],;
	 					aPlanog[oPlanog:nAt,13],;
	 					aPlanog[oPlanog:nAt,14],;
	 					aPlanog[oPlanog:nAt,15],;
	 					aPlanog[oPlanog:nAt,16],;
	 					aPlanog[oPlanog:nAt,17],;
	 					aPlanog[oPlanog:nAt,18],;
	 					aPlanog[oPlanog:nAt,19],;
	 					aPlanog[oPlanog:nAt,20],;
	 					aPlanog[oPlanog:nAt,21]}} 
	 					
	oBtn1      := TButton():New( 217,192,"Confirmar",oPlan1,{||oPlan1:end(nOpcao:=1)},037,012,,,,.T.,,"",,,,.F. )           
	oBtn2      := TButton():New( 217,242,"Incluir Item",oPlan1,{|| IncLin(1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 217,292,"Remover Item",oPlan1,{|| IncLin(2)},037,012,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( 217,342,"Sair",oPlan1,{||oPlan1:end(nOpcao:=0)},037,012,,,,.T.,,"",,,,.F. )

oPlan1:Activate(,,,.T.)

RestArea(aArea)

If nOpcao == 1                 
	DbSelectArea("SZ4")     
	DbSetOrder(2)
	//FILIAL+CHAPA+SELECAO+CODCLI
	For nX := 1 to len(aPlanog)
		If !DbSeek(xFilial("SZ4")+aPlanog[nX,38]+aPlanog[nX,02]+aPlanog[nX,36])	
			Reclock("SZ4",.T.)
			SZ4->Z4_CODCLI 	:=	aPlanog[nX,36]
			SZ4->Z4_LOJCLI	:=	aPlanog[nX,37]
			SZ4->Z4_CHAPA	:=	aPlanog[nX,38]
			SZ4->Z4_CODMAQ	:=	aPlanog[nX,40]
			SZ4->Z4_CODPRO	:=	aPlanog[nX,03]
			SZ4->Z4_SELECAO	:=	aPlanog[nX,02]
			//Insumos
			SZ4->Z4_INSUM1 	:= 	aPlanog[nX,08]
			SZ4->Z4_MEDID1	:=	aPlanog[nX,09]
			SZ4->Z4_INSUM2 	:=	aPlanog[nX,10]
			SZ4->Z4_MEDID2	:=	aPlanog[nX,11]
			SZ4->Z4_INSUM3 	:=	aPlanog[nX,12]
			SZ4->Z4_MEDID3	:=	aPlanog[nX,13]
			SZ4->Z4_INSUM4 	:=	aPlanog[nX,14]
			SZ4->Z4_MEDID4	:=	aPlanog[nX,15]               
			SZ4->Z4_INSUM5 	:=	aPlanog[nX,16]
			SZ4->Z4_MEDID5	:=	aPlanog[nX,17]
			SZ4->Z4_INSUM6 	:=	aPlanog[nX,18]
			SZ4->Z4_MEDID6	:=	aPlanog[nX,19]
			SZ4->Z4_INSUM7 	:=	aPlanog[nX,20]
			SZ4->Z4_MEDID7	:=	aPlanog[nX,21]
			
			SZ4->(Msunlock())        
			Aadd(aList3B,{.T.,aPlanog[nX,38],aPlanog[nX,02],aPlanog[nX,03],aPlanog[nX,04],aPlanog[nX,05],aPlanog[nX,06],'',;
							0,aPlanog[nX,36],aPlanog[nX,37]})
			/*    Aadd(aList3B,{.T.,Alltrim(TRB->Z4_CHAPA),strzero(val(TRB->Z4_SELECAO),2),Alltrim(TRB->Z4_CODPRO),;
    				Alltrim(TRB->B1_DESC),TRB->Z4_CAPACID,TRB->Z4_NIVPAR,;
    				TRB->Z4_NIVALE,TRB->Z4_VALOR,TRB->Z4_CODCLI,TRB->Z4_LOJCLI})*/
		Else
			Reclock("SZ4",.F.)
			SZ4->Z4_CODCLI 	:=	aPlanog[nX,36]
			SZ4->Z4_LOJCLI	:=	aPlanog[nX,37]
			SZ4->Z4_CHAPA	:=	aPlanog[nX,38]
			SZ4->Z4_CODMAQ	:=	aPlanog[nX,40]
			SZ4->Z4_CODPRO	:=	aPlanog[nX,03]
			SZ4->Z4_SELECAO	:=	aPlanog[nX,02]
			//Insumos
			SZ4->Z4_INSUM1 	:= 	aPlanog[nX,08]
			SZ4->Z4_MEDID1	:=	aPlanog[nX,09]
			SZ4->Z4_INSUM2 	:=	aPlanog[nX,10]
			SZ4->Z4_MEDID2	:=	aPlanog[nX,11]
			SZ4->Z4_INSUM3 	:=	aPlanog[nX,12]
			SZ4->Z4_MEDID3	:=	aPlanog[nX,13]
			SZ4->Z4_INSUM4 	:=	aPlanog[nX,14]
			SZ4->Z4_MEDID4	:=	aPlanog[nX,15]               
			SZ4->Z4_INSUM5 	:=	aPlanog[nX,16]
			SZ4->Z4_MEDID5	:=	aPlanog[nX,17]
			SZ4->Z4_INSUM6 	:=	aPlanog[nX,18]
			SZ4->Z4_MEDID6	:=	aPlanog[nX,19]
			SZ4->Z4_INSUM7 	:=	aPlanog[nX,20]
			SZ4->Z4_MEDID7	:=	aPlanog[nX,21]
			
			SZ4->(Msunlock())        
		
		EndIf
	Next nX
EndIf

Return                                                                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Incluir linha no planograma                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IncLin(nOpc)

Local aArea	:=	GetArea()

If nOpc == 1
	aadd(aPlanog,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
				'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
Else
	DbSelectArea("SZ4")
	DbSetOrder(2)
	If Dbseek(xFilial("SZ4")+aPlanog[oPlanog:nAt,38]+aPlanog[oPlanog:nAt,02]+aPlanog[oPlanog:nAt,36])
		Reclock("SZ4",.F.)
		DbDelete()
		SZ4->(Msunlock())
	EndIf
	
	If Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(aPlanog[oPlanog:nAt,03]) }) > 0
		Adel(aList3,Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(aPlanog[oPlanog:nAt,03]) }))
		Asize(aList3,len(aList3)-1)
	EndIf
	ADel(aPlanog,oPlanog:nAt)
	Asize(aPlanog,len(aPlanog)-1)
	
	If len(aPlanog) < 1
		aadd(aPlanog,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
			'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
	EndIF
EndIF

oPlanog:SetArray(aPlanog)
oPlanog:bLine := {||{If(aPlanog[oPlanog:nAt,01],oOk,oNo),;
					aPlanog[oPlanog:nAt,02],; 
 					aPlanog[oPlanog:nAt,03],;
 					aPlanog[oPlanog:nAt,04],;
 					aPlanog[oPlanog:nAt,05],;
 					aPlanog[oPlanog:nAt,06],;  
 					aPlanog[oPlanog:nAt,07],;  
 					aPlanog[oPlanog:nAt,08],;
 					aPlanog[oPlanog:nAt,09],;
 					aPlanog[oPlanog:nAt,10],;
 					aPlanog[oPlanog:nAt,11],;
 					aPlanog[oPlanog:nAt,12],;
 					aPlanog[oPlanog:nAt,13],;
 					aPlanog[oPlanog:nAt,14],;
 					aPlanog[oPlanog:nAt,15],;
 					aPlanog[oPlanog:nAt,16],;
 					aPlanog[oPlanog:nAt,17],;
 					aPlanog[oPlanog:nAt,18],;
 					aPlanog[oPlanog:nAt,19],;
 					aPlanog[oPlanog:nAt,20],;
 					aPlanog[oPlanog:nAt,21]}} 
oPlanog:refresh()
oPlan1:refresh()

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  04/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Edita linhas do planograma                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editplan(nLinha)          

Local aArea	:=	GetArea()
Local lProd	:=	.F.  
Local nPosic:=	oPlanog:ncolpos    
     
If nPosic == 2
	lEditCell( aPlanog, oPlanog, "", 2)
	//Dose
	lProd	:= ConPad1(,,,"SB1",,,.f.)
	//Usuario pressionou o ok
	If lProd
		aPlanog[oPlanog:nAt,03] := SB1->B1_COD
		aPlanog[oPlanog:nAt,04] := SB1->B1_DESC //Alltrim(Posicione("SB1",1,xFilial("SB1")+aPlanog[oPlanog:nAt,03],"B1_DESC"))
	Else
		while !lProd
			aPlanog[oPlanog:nAt,03] := space(15)
			lEditCell( aPlanog, oPlanog, "", 3)
			IF existcpo("SB1",aPlanog[oPlanog:nAt,03])
				lProd := .T.
				//aPlanog[oPlanog:nAt,03] := SB1->B1_COD
				aPlanog[oPlanog:nAt,04] := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPlanog[oPlanog:nAt,03],"B1_DESC"))
			EndIF
		EndDo 
	EndIf
EndIf
	

If nPosic == 8 
	lProd := .F.
	//Insumo 1
	While !lProd
		aPlanog[oPlanog:nAt,08] := space(15)
		lEditCell( aPlanog, oPlanog, "", 8)
		If !Empty(aPlanog[oPlanog:nAt,08])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,08])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 9)
			Endif	     
		Else
			lProd := .T.
		EndIf
	EndDo
EndIf	

If nPosic == 10 
	lProd := .F.
	
	//Insumo 2        
	While !lProd
		aPlanog[oPlanog:nAt,10] := space(15)
		lEditCell( aPlanog, oPlanog, "", 10)
		If !Empty(aPlanog[oPlanog:nAt,10])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,10])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 11)
			EndIf
		Else
			lProd := .T.
		EndIf
	Enddo 
EndIf

If nPosic == 12
	lProd := .F.
	
	//Insumo 3        
	While !lProd
		aPlanog[oPlanog:nAt,12] := space(15)
		lEditCell( aPlanog, oPlanog, "", 12)
		If !Empty(aPlanog[oPlanog:nAt,12])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,12])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 13)
			EndIf
		Else
			lProd := .T.
		EndIf
	Enddo
EndIf

If nPosic == 14             
	lProd := .F.
	//Insumo 3        
	While !lProd
		aPlanog[oPlanog:nAt,14] := space(15)
		lEditCell( aPlanog, oPlanog, "", 14)
		If !Empty(aPlanog[oPlanog:nAt,14])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,14])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 15)
			EndIf
		Else
			lProd := .T.
		EndIf
	Enddo
EndIf    

If nPosic == 16	            
	lProd := .F.
	//Insumo 3        
	While !lProd
		aPlanog[oPlanog:nAt,16] := space(15)
		lEditCell( aPlanog, oPlanog, "", 16)
		If !Empty(aPlanog[oPlanog:nAt,16])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,16])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 17)
			EndIf
		Else
			lProd := .T.
		EndIf
	Enddo
EndIf
     
If nPosic == 18           
	lProd := .F.
	//Insumo 3        
	While !lProd
		aPlanog[oPlanog:nAt,18] := space(15)
		lEditCell( aPlanog, oPlanog, "", 18)
		If !Empty(aPlanog[oPlanog:nAt,18])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,18])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 19)
			EndIf
		Else
			lProd := .T.
		EndIf
	Enddo
EndIf

If nPosic == 20            
	lProd := .F.
	//Insumo 3        
	While !lProd
		aPlanog[oPlanog:nAt,20] := space(15)
		lEditCell( aPlanog, oPlanog, "", 20)
		If !Empty(aPlanog[oPlanog:nAt,20])
			IF existcpo("SB1",aPlanog[oPlanog:nAt,20])
				lProd := .T.
				lEditCell( aPlanog, oPlanog, "@E 9.9999", 21)
			EndIf
		Else
			lProd := .T.
		EndIf
	Enddo
EndIf  

oPlanog:refresh()
oPlan1:refresh()

/*
//Insumo 3
lProd	:= ConPad1(,,,"SB1",,,.f.)
//Usuario pressionou o ok
If lProd
	aPlanog[oPlanog:nAt,12] := SB1->B1_COD
	lEditCell( aPlanog, oPlanog, "@E 9.9999", 13)
EndIf
//Insumo 4        
lProd	:= ConPad1(,,,"SB1",,,.f.)
//Usuario pressionou o ok
If lProd
	aPlanog[oPlanog:nAt,14] := SB1->B1_COD
	lEditCell( aPlanog, oPlanog, "@E 9.9999", 15)
EndIf
//Insumo 5
lProd	:= ConPad1(,,,"SB1",,,.f.)
//Usuario pressionou o ok
If lProd
	aPlanog[oPlanog:nAt,16] := SB1->B1_COD
	lEditCell( aPlanog, oPlanog, "@E 9.9999", 17)
EndIf
//Insumo 6        
lProd	:= ConPad1(,,,"SB1",,,.f.)
//Usuario pressionou o ok
If lProd
	aPlanog[oPlanog:nAt,18] := SB1->B1_COD
	lEditCell( aPlanog, oPlanog, "@E 9.9999", 19)
EndIf
//Insumo 7
lProd	:= ConPad1(,,,"SB1",,,.f.)
//Usuario pressionou o ok
If lProd
	aPlanog[oPlanog:nAt,20] := SB1->B1_COD
	lEditCell( aPlanog, oPlanog, "@E 9.9999", 21)
EndIf
*/
oPlanog:refresh()
oPlan1:refresh()

RestArea(aArea)

Return
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui planograma                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function excplan()

Local aArea	:=	GetArea()
Local nCont	:=	len(aList3)
 
DbSelectArea("SZ4")     
DbSetOrder(2)
//FILIAL+CHAPA+SELECAO+CODCLI
If DbSeek(xFilial("SZ4")+ALIST[oList:nAt,02])
   	While !EOF() .And. SZ4->Z4_CHAPA == ALIST[oList:nAt,02]
   		Reclock("SZ4",.F.)
   		DbDelete()
   		SZ4->(Msunlock())
   		Dbskip()
   	EndDo
EndIf

While nCont > 0
	ADel(aList3,oList3:nAt)
	Asize(aList3,len(aList3)-1)
	nCont--
EndDo

If len(aList3) < 1
	Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
EndIf

oList3:refresh()
oDlg1:refresh()
	
	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  05/10/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   remessas enviadas para os pontos de venda                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Remessas()

Local aArea		:=	GetArea()
Local aPergs	:=	{}
Local aRet		:=	{}      
Local cPdvD		:=	space(6)
Local cPdvA		:=	space(6)
Local dDtD		:=	ctod(" / / ")
Local dDtA		:=	ctod(" / / ")
Local aExcel	:=	{}         
Local oExcel	:=	FWMSEXCEL():New()
Local cTitulo	:=	"Remessas" 
Local cArqXls 	:=	"Remessas"+dtos(ddatabase)+strtran(time(),":")+".xls" 

Local cDir		

aAdd(aPergs ,{1,"PDV de?",cPdvD,"","","NNR","",050,.T.})
aAdd(aPergs ,{1,"PDV de?",cPdvA,"","","NNR","",050,.T.})	
aAdd(aPergs ,{1,"Periodo de?",dDtD,"","","","",040,.T.})
aAdd(aPergs ,{1,"Periodo ate?",dDtA,"","","","",040,.T.})	

If ParamBox(aPergs ,"Motivo da Despesa",@aRet)
	cDir 		:=	cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	
	If Empty(cDir)
		Return
	EndIf
	
	//aRet[1]
	cQuery := "SELECT C6_NUM,C6_NOTA,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_CLI,C6_LOJA,C5_XPDV,C6_ENTREG,C5_EMISSAO"
	cQuery += " FROM "+RetSQLName("SC6")+" C6"
	cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5.D_E_L_E_T_=''"
	cQuery += "		 AND C5_EMISSAO BETWEEN '"+dtos(aRet[3])+"' AND '"+dtos(aRet[4])+"' AND C5_XPDV BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"'"
	cQuery += " WHERE C6.D_E_L_E_T_=''"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("AVSIINT.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")  
	
	While !EOF() 
		Aadd(aExcel,{TRB->C6_NUM,TRB->C6_NOTA,TRB->C6_PRODUTO,TRB->C6_DESCRI,TRB->C6_QTDVEN,TRB->C6_PRCVEN,;
						TRB->C6_CLI,TRB->C6_LOJA,TRB->C5_XPDV,STOD(TRB->C6_ENTREG),STOD(TRB->C5_EMISSAO)})
		Dbskip()
	EndDo
	            
	If len(aExcel) > 0
		//C6_NUM,C6_NOTA,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_CLI,C6_LOJA,C5_XPDV,C6_ENTREG,C5_EMISSAO
		oExcel:AddworkSheet("Remessas") 
		
		oExcel:AddTable ("Remessas","PDV")
		
		oExcel:AddColumn("Remessas","PDV","Pedido",1,1)
		oExcel:AddColumn("Remessas","PDV","Nota",1,1) 
		oExcel:AddColumn("Remessas","PDV","Produto",1,1) 
		oExcel:AddColumn("Remessas","PDV","Descri็ใo",1,1) 
		oExcel:AddColumn("Remessas","PDV","Qtd Enviada",1,1) 
		oExcel:AddColumn("Remessas","PDV","Pre็o Unitแrio",1,1) 
		oExcel:AddColumn("Remessas","PDV","Codigo Cliente",1,1) 
		oExcel:AddColumn("Remessas","PDV","Loja",1,1) 
		oExcel:AddColumn("Remessas","PDV","PDV",1,1) 
		oExcel:AddColumn("Remessas","PDV","Data Entrega",1,1) 
		oExcel:AddColumn("Remessas","PDV","Data Emissใo",1,1) 
		
		For nX := 1 to len(aExcel)
			oExcel:AddRow("Remessas","PDV",{aExcel[nX,01],;
											aExcel[nX,02],; 	//Produto
											aExcel[nX,03],;		//Descricao
											aExcel[nX,04],;
											aExcel[nX,05],;
											aExcel[nX,06],;
											aExcel[nX,07],;		//Qtd
											aExcel[nX,08],;
											aExcel[nX,09],;
											aExcel[nX,10],;
											aExcel[nX,11]})  //valor total

		Next nX  
		
		oExcel:Activate()

		oExcel:GetXMLFile(cDir +cArqXls)
		
		//If File(cDir +cArqXls)
			oExcelApp := MsExcel():New()
			oExcelApp:Destroy()
		//EndIf    
	EndIf
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ    Busca planograma                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscPlan()

Local aArea	:=	GetArea()
Local cQuery
Local aRet	:=	{}

cQuery := "SELECT Z4.*,B1_DESC FROM "+RetSQLName("SZ4")+" Z4"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=Z4_CODPRO AND B1.D_E_L_E_T_=''
cQuery += " WHERE Z4_CHAPA='"+aList[oList:nAt,02]+"' AND Z4_CODCLI='"+aList[oList:nAt,17]+"' AND Z4.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  
/*
*/
//'','Mola','Produto','Descri็ใo','Quant.','Conf','Nivel Par','Insumo1','Dosagem1','Insumo2','Dosagem2','Insumo3','Dosagem3','Insumo4','Dosagem4','Insumo5','Dosagem5','Insumo6','Dosagem6','Insumo7','Dosagem7'
While !EOF() 
	Aadd(aRet,{.F.,TRB->Z4_SELECAO,TRB->Z4_CODPRO,Alltrim(TRB->B1_DESC),;
				TRB->Z4_CAPACID,TRB->Z4_NIVALE,TRB->Z4_NIVPAR,TRB->Z4_INSUM1,TRB->Z4_MEDID1,TRB->Z4_INSUM2,TRB->Z4_MEDID2,;
				TRB->Z4_INSUM3,TRB->Z4_MEDID3,TRB->Z4_INSUM4,TRB->Z4_MEDID4,TRB->Z4_INSUM5,TRB->Z4_MEDID5,TRB->Z4_INSUM6,;
				TRB->Z4_MEDID6,TRB->Z4_INSUM7,TRB->Z4_MEDID7,;
				'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
	Dbskip()
EndDo

If len(aRet) < 1
	aadd(aRet,{.F.,space(2),'','','','','','',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,;
				'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,'',0.0000,aList[oList:nAt,17],aList[oList:nAt,18],aList[oList:nAt,02],,aList[oList:nAt,21]})
EndIF

RestArea(aArea)

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  05/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca as vendas do Vmpay                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Vendaspay()

Local aArea	:=	GetArea()
Local dDtD	:=	ctod(' / / ') 
Local dDtA	:=	ctod(' / / ') 

Private aPergs	:=	{}
Private aRet	:=	{}
Private aVendas	:=	{}

aAdd(aPergs ,{1,"Data Inicial?",dDtD,"","","","",070,.T.})	
aAdd(aPergs ,{1,"Data Final?",dDtA,"","","","",070,.T.})	
      
If ParamBox(aPergs ,"Periodo de vendas",@aRet)
	aVendas := U_PRTWS03(aList[oList:nAt,02],2,aRet[1],aRet[2])
	If len(aVendas) > 0
		aList8 := {}
	//'Data','Sele็ใo','Produto','Descri็ใo','Quant. Apont.',chapa,codigo cliente
		For nX := 3 to len(aVendas) 
			cCodProt := ''
			If aVendas[nX,05] == "null"
				If Ascan(aList3,{|x| Alltrim(x[3]) == Alltrim(aVendas[nX,02])}) > 0
					cCodProt  	:=	 aList3[Ascan(aList3,{|x| Alltrim(x[3]) == Alltrim(aVendas[nX,02])}),04]  
				EndIf 
			Else
				cCodProt := aVendas[nX,05]
			EndIf
			cDesc := Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC")       
			/*If Empty(cCodProt)
				cCodProt := Alltrim(aVendas[nX,05])
				cDesc	 := Alltrim(Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC"))
			else
				cDesc	 := Alltrim(Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC"))
			EndIf     */
			
            nPosit := Ascan(aList8,{|x| x[2] == aVendas[nX,02]})
            If nPosit == 0
				Aadd(aList8,{cvaltochar(aRet[2]),aVendas[nX,02],cCodProt,cDesc,val(aVendas[nX,03]),aVendas[2],;
							aList[oList:nAt,17],If(val(aVendas[nX,03])>1,val(aVendas[nX,04])/val(aVendas[nX,03]),val(aVendas[nX,04]))})
			Else
				aList8[nPosit,05] += val(aVendas[nX,03])
			EndIf
		Next nX
		
		
		If len(aList8) > 0
			Asort(aList8,,,{|x,y| x[2]+x[1] < y[2]+y[1]})
			oList8:SetArray(aList8)
			oList8:bLine := {||{aList8[oList8:nAt,01],;
								aList8[oList8:nAt,02],; 
			 					aList8[oList8:nAt,03],;
			 					aList8[oList8:nAt,04],;
			 					aList8[oList8:nAt,05],;
			 					Transform(aList8[oList8:nAt,08],"@E 999,999.99")}}
			oList8:refresh()
			oDlg1:refresh()
	
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  06/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function savevend()

Local aArea		:=	GetArea()  
Local aGravar	:=	{}
                  
Aadd(aGravar,{"Z3_FILIAL",xFilial("SZ3")})
Aadd(aGravar,{"Z3_DATA",ctod(aList8[1,1])})
Aadd(aGravar,{"Z3_HORA",cvaltochar(time())})
Aadd(aGravar,{"Z3_CHAPA",aList8[1,6]})
Aadd(aGravar,{"Z3_CODCLI",aList8[1,7]})
Aadd(aGravar,{"Z3_LOJCLI",alist[oList:nAt,18]})

For nX := 1 to len(aList8)
	Aadd(aGravar,{"Z3_SELEC"+aList8[nX,02],cvaltochar(aList8[nX,05])})
	Aadd(aGravar,{"Z3_VALOR"+aList8[nX,02],aList8[nX,08]}) 
	Aadd(aGravar,{"Z3_PRDML"+aList8[nX,02],aList8[nX,03]}) 
Next nX

If len(aList8) > 0   
	Dbselectarea("SZ3")
	Dbsetorder(1)
	Reclock("SZ3",.T.)
	For nX := 1 to len(aGravar)
		&("SZ3->"+aGravar[nX,01]) := aGravar[nX,02]
	Next nX                                        
	SZ3->(Msunlock())
	MsgAlert("Leitura salva com sucesso!")
	
	For nX := 1 to len(aList8)
		Aadd(aList8B,aList8[nX])
	Next nX
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  07/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Replicar Planograma para outro ativo.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function repplan()

Local aArea	:=	GetArea()
Local aBkPl := 	{}
Local nOpc	:=	0
Local aGrav	:=	{}

Private oPlCp	
Private aAteq	:=	{}

SetPrvt("oRepPl","oGrp1","oBrw1","oBtn1","oBtn2")

For nX := 1 to len(aList3)
	Aadd(aBkPl,aList3[nX])
Next nX

For nX := 1 to len(aListB)
    If Alltrim(aListB[nX,03]) == Alltrim(aList[oList:nAt,03])
		If Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aListB[nX,02]) }) == 0
			Aadd(aAteq,{.F.,aListB[nX,02],aListB[nX,03],aListB[nX,17],aListB[nX,18],aListB[nX,05],aListB[nX,06]})
		EndIf
	EndIf
Next nX       

oRepPl     := MSDialog():New( 092,232,437,876,"Replicar Planograma",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,008,148,308,"Ativos",oRepPl,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,144,304},,, oGrp1 ) 

	oPlCp	 	   := TCBrowse():New(012,012,290,135,, {'','Ativo','Modelo','Cliente','Nome Fantasia'},{10,30,40,50,50},;
	                            oGrp1,,,,{|| },{|| editcp(oPlCp:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oPlCp:SetArray(aAteq)
	oPlCp:bLine := {||{ If(aAteq[oPlCp:nAt,01],oOk,oNo),; 
	 					 Alltrim(aAteq[oPlCp:nAt,02]),;
	 					 Alltrim(aAteq[oPlCp:nAt,03]),;
	 					 Alltrim(aAteq[oPlCp:nAt,06]),;
	 					 Alltrim(aAteq[oPlCp:nAt,07])}}

	oBtn1      := TButton():New( 152,080,"Confirmar",oRepPl,{||oRepPl:end(nOpc := 1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 152,192,"Cancelar",oRepPl,{||oRepPl:end(nOpc := 0)},037,012,,,,.T.,,"",,,,.F. )

oRepPl:Activate(,,,.T.)

If nOpc == 1
	If MsgYesNo("Confirma a c๓pia do planograma atual para as maquinas selecionadas?","repplan - AVSIINT")
		For nX := 1 to len(aAteq)
			If aAteq[nX,01]
				//Aadd(aGrav,aAteq[nX])
				For nJ := 1 to len(aBkPl)
					Aadd(aGrav,aBkPl[nJ])
					aGrav[len(aGrav),02] := aAteq[nX,02]
					aGrav[len(aGrav),10] := aAteq[nX,04]
					aGrav[len(aGrav),11] := aAteq[nX,05]
				Next nJ
			EndIf
		Next nX  
		/*
		    Aadd(aList3B,{.T.,Alltrim(TRB->Z4_CHAPA),strzero(val(TRB->Z4_SELECAO),2),Alltrim(TRB->Z4_CODPRO),;
	    				Alltrim(TRB->B1_DESC),TRB->Z4_CAPACID,TRB->Z4_NIVPAR,;
	    				TRB->Z4_NIVALE,TRB->Z4_VALOR,TRB->Z4_CODCLI,TRB->Z4_LOJCLI,;
	    				TRB->Z4_CODMAQ,TRB->Z4_INSUM1,TRB->Z4_MEDID1,TRB->Z4_INSUM2,TRB->Z4_MEDID2,TRB->Z4_INSUM3,TRB->Z4_MEDID3,;
	    				TRB->Z4_INSUM4,TRB->Z4_MEDID4,TRB->Z4_INSUM5,TRB->Z4_MEDID5,TRB->Z4_INSUM6,TRB->Z4_MEDID6,TRB->Z4_INSUM7,TRB->Z4_MEDID7})
		 */
		DbSelectArea("SZ4")
        For nX := 1 to len(aGrav)
        	Reclock("SZ4",.T.)
        	SZ4->Z4_CODCLI	:=	aGrav[nX,10]
        	SZ4->Z4_LOJCLI	:=	aGrav[nX,11]
        	SZ4->Z4_CHAPA	:=	aGrav[nX,02]
        	SZ4->Z4_CODMAQ	:=	aGrav[nX,12]
        	SZ4->Z4_CODPRO	:=	aGrav[nX,04]
        	SZ4->Z4_SELECAO	:=	aGrav[nX,03]
        	SZ4->Z4_CAPACID	:=	aGrav[nX,06]
        	SZ4->Z4_NIVPAR	:=	aGrav[nX,07]
        	SZ4->Z4_NIVALE	:=	aGrav[nX,08]
        	SZ4->Z4_VALOR	:=	aGrav[nX,09]
        	SZ4->Z4_INSUM1	:=	aGrav[nX,13]
        	SZ4->Z4_MEDID1	:=	aGrav[nX,14]
        	SZ4->Z4_INSUM2	:=	aGrav[nX,15]
        	SZ4->Z4_MEDID2	:=	aGrav[nX,16]
        	SZ4->Z4_INSUM3	:=	aGrav[nX,17]
        	SZ4->Z4_MEDID3	:=	aGrav[nX,18]
        	SZ4->Z4_INSUM4	:=	aGrav[nX,19]
        	SZ4->Z4_MEDID4	:=	aGrav[nX,20]
        	SZ4->Z4_INSUM5	:=	aGrav[nX,21]
        	SZ4->Z4_MEDID5	:=	aGrav[nX,22]
        	SZ4->Z4_INSUM6	:=	aGrav[nX,23]
        	SZ4->Z4_MEDID6	:=	aGrav[nX,24]
        	SZ4->Z4_INSUM7	:=  aGrav[nX,25]
        	SZ4->Z4_MEDID7	:=	aGrav[nX,26]
        	SZ4->(Msunlock())
        Next nX  
        
        MsgAlert("Planogramas salvos, saia da rotina e abra novamente para atualiza็ใo.")
	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIINT   บAutor  ณMicrosiga           บ Data ณ  07/19/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcp(nLinha)

Local aArea	:=	GetArea()

If aAteq[nLinha,01]
	aAteq[nLinha,01] := .F.
Else
	aAteq[nLinha,01] := .T.
EndIf
      
oPlCp:refresh()
oRepPl:refresh()

RestArea(aArea)

Return

Static Function ArmAtv(cAtiv)
                     
Local cCodPa	:=	''

cQuery := "SELECT ZZ1_COD AS PA"
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN  "+RetSQLName("ZZ1")+" ZZ1 ON ZZ1_COD='A'+SUBSTRING(N1_XPA,2,5) AND ZZ1.D_E_L_E_T_=''"
cQuery += " WHERE N1_CHAPA='"+cAtiv+"' AND N1.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

If !Empty(TRB->PA)
	cCodPa := TRB->PA
EndIf

Return(cCodPa)