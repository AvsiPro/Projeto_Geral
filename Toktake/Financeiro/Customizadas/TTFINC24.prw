#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH' 
#INCLUDE "TOPCONN.CH"
  
      
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTFINC24 ณ Autor ณ Alexandre Venancio    ณ Data ณ 04/10/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ   Rotina de prestacao de contas da rota.                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAlexandre       ณ04/10/13ณ01.01 |Criacao                               ณฑฑ
ฑฑณJackson         ณ21/05/13ณ01.02 |Ajuste - retorno dos lacres           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFINC24()
                
Local aArea	:=	GetArea()                
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oSay12","oSay13","oSay14","oGrp2","oBrw1","oGrp3","oBrw2","oGrp4","oBrw3","oBrw4","oBrw5","oBtn1")
SetPrvt("oBtn3","oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23","oSay24","oGrp5")
SetPrvt("oSay25","oSay26","oSay27","oSay28","oSay29","oSay30","oSay31","oSay32","oSay33","oSay34","oSay35")
SetPrvt("oSay36","oSay37","oSay38","oSay39","oSay40","oSay41","oSay42","oSay43","oSay44","oSay45","oSay46","oSay47")
SetPrvt("oSay48","oSay49","oSay50","oSay51","oSay52","oSay53")
Private aList1 := {}	                
Private aList2 := {}
Private aList3 := {}
Private aList4 := {}
Private aList5 := {}
Private oList1
Private oList2
Private oList3
Private oList4
Private oList5           
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  
Private cRota	:=	space(6)
Private dDia	:=	ctod("  /  /  ")
Private lCxFech	:= .F.           
 
DEFINE FONT oFonte NAME 'Verdana' SIZE 9,12
DEFINE FONT oFonte2 NAME 'Arial' SIZE 8,9

//Prepare Environment Empresa "01" Filial "01" //Tables "ZZE" 

nOp := Rota()

	
If nOp == 0
	RestArea(aArea)
	Return
Else       
	//Validacao das moedas abastecidas nos patrimonios.
	//busca nos XMLs e preenchem a ZF novamente para evitar erros
	U_TTFINT01(cRota,dDia)
EndIf

oDlg1      := MSDialog():New( 091,232,585,1313,"Resumo dos lan็amentos Rota "+cRota+" - Data "+cvaltochar(dDia),,,.F.,,CLR_WHITE,,,,.T.,,,.T. )
                             
	oGrp5      := TGroup():New( 002,385,220,535,"Presta็ใo de Contas por Patrimonio",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay25     := TSay():New( 010,420,{||"Patrimonio"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,051,008)
		oSay26     := TSay():New( 020,390,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,251,008)

		oSay27     := TSay():New( 040,420,{||"Venda Registrada"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,008)
		
		oSay28     := TSay():New( 050,390,{||"Cash Atual"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay30     := TSay():New( 050,490,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		
		oSay29     := TSay():New( 060,390,{||"Cash Anterior"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay31     := TSay():New( 060,490,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		
		oSay32     := TSay():New( 070,390,{||"Venda em R$"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay33     := TSay():New( 070,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		
		oSay34     := TSay():New( 080,390,{||"Fundo Troco Ant"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay35     := TSay():New( 080,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 

		oSay48     := TSay():New( 090,390,{||"Troco Abastecido"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay49     := TSay():New( 090,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 
		                            
		oSay36     := TSay():New( 100,420,{||"Sangrias"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,008)
		
		oSay37     := TSay():New( 110,390,{||"Cedulas e Moedas"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay38     := TSay():New( 110,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 
		
		oSay39     := TSay():New( 120,390,{||"POS"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay40     := TSay():New( 120,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 

		oSay41     := TSay():New( 130,390,{||"Valor Total Sangria"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay42     := TSay():New( 130,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 
        
		oSay52     := TSay():New( 140,390,{||"Smart / CCart๕es"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay53     := TSay():New( 140,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 

		oSay43     := TSay():New( 150,390,{||"Limite Troco Patrimonio"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay44     := TSay():New( 150,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 

		oSay45     := TSay():New( 160,420,{||"Total da Opera็ใo"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,008)

		oSay46     := TSay():New( 170,390,{||"Novo Fundo de Troco"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay47     := TSay():New( 170,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 

		oSay50     := TSay():New( 180,390,{||"Adi็ใo Liquida"},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
		oSay51     := TSay():New( 180,470,{||""},oGrp5,,oFonte,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008) 

	oGrp1      := TGroup():New( 002,004,050,380,"Resumo :Materiais Enviados",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	   
		oSay1      := TSay():New( 012,020,{||"Qtd Lacres Envio/Retorno"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
		oSay2      := TSay():New( 012,088,{||"999/999"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
		
		oSay3      := TSay():New( 012,124,{||"Qtd Glenviewดs Envio/Retorno"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
		oSay4      := TSay():New( 012,212,{||"999/999"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
		
		oSay5      := TSay():New( 012,248,{||"Qtd Bananinhas Envio/Retorno"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
		oSay6      := TSay():New( 012,332,{||"999/999"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
		
		oSay7      := TSay():New( 022,020,{||"Troco Enviado R$ "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
		oSay8      := TSay():New( 022,072,{||"999,999,999,99"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
		
		oSay9      := TSay():New( 022,124,{||"Troco Retornado R$"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay10     := TSay():New( 022,196,{||"999,999,999,99"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
		
		oSay11     := TSay():New( 022,248,{||"Troco Abastecido R$"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
		oSay12     := TSay():New( 022,316,{||"999,999,999,99"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
		
		oSay15     := TSay():New( 032,020,{||"Total Sangria Cedulas"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
		oSay16     := TSay():New( 032,085,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,008)

		oSay17     := TSay():New( 032,124,{||"Total Sangria Moedas"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,086,008)
		oSay18     := TSay():New( 032,208,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,008)
		
		oSay13     := TSay():New( 032,249,{||"Diferen็a Troco R$"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,051,008)
		oSay14     := TSay():New( 032,316,{||"999,999,999,99"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,040,008)
        
		//
		oSay22     := TSay():New( 042,020,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,034,008)
		oSay19     := TSay():New( 042,045,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)

		oSay23     := TSay():New( 042,124,{||"Modelo Maq"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
		oSay20     := TSay():New( 042,164,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
		
		oSay24     := TSay():New( 042,249,{||"Sistema Pagto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
		oSay21     := TSay():New( 042,289,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,100,008)

	Moedas() 
	Preacols()
		
	oGrp2      := TGroup():New( 052,004,144,132,"Moedas para Troco",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{060,008,140,128},,, oGrp2 ) 
		oList1 := TCBrowse():New(060,008,120,080,, {'Moedas','Saํda','Retorno'},{30,30,30},;
                            oGrp2,,,,{|| },{|| /*If(oList1:nAt<6 .And. !lCxFech,editcol1(oList1:nAt),)*/},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)
		oList1:SetArray(aList1)
		oList1:bLine := {||{ aList1[oList1:nAt,01],;
							If(oList1:nAt == 6,Transform(aList1[oList1:nAt,02],"@E 9,999.99 "),aList1[oList1:nAt,02]),;
							If(oList1:nAt == 6,Transform(aList1[oList1:nAt,03],"@E 9,999.99 "),aList1[oList1:nAt,03])}} 

	oGrp3      := TGroup():New( 052,136,144,380,"Lan็amentos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{060,140,140,376},,, oGrp3 ) 
		oList5 := TCBrowse():New(060,140,235,080,, {'Patrim๔nio','Troco','C้dulas','Moedas','Lacres Ret','Bananinha Ret.','Glenview Ret.'},{30,30,30,30,30,30,30},;
                            oGrp3,,,,{||FHelp() },{|| editcol2(oList5:nAt) },, ,,,  ,,.F.,,.T.,,.F.,,,.F.)
		oList5:SetArray(aList5)
		oList5:bLine := {||{aList5[oList5:nAt,01],;
							Transform(aList5[oList5:nAt,02],"@E 999,999.99"),;
							Transform(aList5[oList5:nAt,03],"@E 999,999.99"),;
							Transform(aList5[oList5:nAt,04],"@E 999,999.99"),;
							aList5[oList5:nAt,05],;
							aList5[oList5:nAt,06],;
							aList5[oList5:nAt,07]}} 
	
	oGrp4      := TGroup():New( 148,004,220,380,"Materiais Enviados",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{156,008,216,128},,, oGrp4 ) 
		oList2 := TCBrowse():New(156,008,120,060,, {'','Lacre','Cor Lacre','Patrim๔nio'},{30,30,30,30},;
                            oGrp4,,,,{|| },{|| If(!lCxFech,editcol3(oList2:nAt),)},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)
		oList2:SetArray(aList2)
		oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
							aList2[oList2:nAt,02],;
							aList2[oList2:nAt,03],;
							aList2[oList2:nAt,04]}} 

		//oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{156,132,216,252},,, oGrp4 ) 

		oList3 := TCBrowse():New(156,133,120,060,, {'','Bananinha','Patrim๔nio'},{30,30,30},;
                            oGrp4,,,,{|| },{|| If(!lCxFech,editcol4(oList3:nAt),)},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)
		oList3:SetArray(aList3)
		oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
							aList3[oList3:nAt,02],;
							aList3[oList3:nAt,03]}} 

		//oBrw5      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{156,257,216,377},,, oGrp4 ) 
		oList4 := TCBrowse():New(156,258,120,060,, {'','Glenview','Patrim๔nio'},{30,30,30},;
                            oGrp4,,,,{|| },{|| If(!lCxFech,editcol5(oList4:nAt),)},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)
		oList4:SetArray(aList4)
		oList4:bLine := {||{If(aList4[oList4:nAt,01],oOk,oNo),;
							aList4[oList4:nAt,02],;
							aList4[oList4:nAt,03]}} 

    
    oBtn      := TButton():New( 224,010,"Relatorio",oDlg1,{ || U_TTFINR14( {cRota,dDia,.F.} ) },037,012,,,,.T.,,"",,,,.F. )
	oBtn:Hide()

	oBtn1      := TButton():New( 224,092,"Confirmar",oDlg1,{ || gravar() },037,012,,,,.T.,,"",,,,.F. )
	
	If cusername $ 'JDEUS;RJESUS'
		oBtn2      := TButton():New( 224,200,"Inc. Patr.",oDlg1,{ || incluir() },037,012,,,,.T.,,"",,,,.F. )
	EndIf
	oBtn4      := TButton():New( 224,265,"Conf. Log",oDlg1,{ || confLog(1) },037,012,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 224,400,"Sair",oDlg1,{ ||oDlg1:end() },037,012,,,,.T.,,"",,,,.F. )
	
	If lCxFech
		//oBtn1:disable()
		//oBtn2:disable()
		oBtn:Show()
		MsgAlert("Caixa jแ fechado, nใo serใo permitidas altera็๕es!","TTFINC24")
	EndIf

oDlg1:Activate(,,,.T.)

RestArea(aArea)

Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Moedas                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Moedas()

Local aArea	:=	GetArea()

Aadd(aList1,{'R$ 0,05',0,0})
Aadd(aList1,{'R$ 0,10',0,0})
Aadd(aList1,{'R$ 0,25',0,0})
Aadd(aList1,{'R$ 0,50',0,0})
Aadd(aList1,{'R$ 1,00',0,0})
Aadd(aList1,{'Total $',0,0})

RestArea(aArea)

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Parametros                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Rota()

Local oDlg2,oSay1,oSay2,oGet1,oGet2,oBtn1,oBtn2
Local nOp	:=	0 

oDlg2      := MSDialog():New( 091,232,318,593,"Rota",,,.F.,,,,,,.T.,,,.T. )

	oSay1      := TSay():New( 020,024,{||"Rota"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 020,072,{|u|If(Pcount()>0,cRota:=u,cRota)},oDlg2,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,)
	oSay2      := TSay():New( 048,024,{||"Data"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 048,072,{|u|If(Pcount()>0,dDia:=u,dDia)},oDlg2,060,008,'',{|| IF(dDia<=dDatabase,.T.,.F.) },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)	// ALTERADO POR JACKSON EM 20/01/14 - NAO PERMITIR DATAS SUPERIORES A DATABASE

	oBtn1      := TButton():New( 080,036,"Confirmar",oDlg2,{||oDlg2:end(nOp:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 080,096,"Sair",oDlg2,{||oDlg2:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg2:Activate(,,,.T.)

Return(nOp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Valores das Rotas                                        บฑฑ
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
Local aCores	:=	{"Cinza","Laranja","Preto","Branco","Amarelo","Vermelho"}  
Local aMaqXms	:=	{'8000101','8000102','8000103','8000106','8000131','8000132','8000211','8000212','8000219'}

cQuery := "SELECT * FROM "+RetSQLName("SZF")+" ZF"
cQuery += " WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_DATA='"+dtos(dDia)+"' AND ZF_ROTA='"+cRota+"' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
	
    aList1[01,02] += TRB->ZF_MOEDA01 
    aList1[02,02] += TRB->ZF_MOEDA02 
    aList1[03,02] += TRB->ZF_MOEDA03 
    aList1[04,02] += TRB->ZF_MOEDA04 
    aList1[05,02] += TRB->ZF_MOEDA05 
    aList1[06,02] := (aList1[01,02] * 0.05) + (aList1[02,02] * 0.10) + (aList1[03,02] * 0.25)+ (aList1[04,02] * 0.50) + (aList1[05,02] * 1)    
    
    aList1[01,03] += TRB->ZF_RETMOE1 
    aList1[02,03] += TRB->ZF_RETMOE2 
    aList1[03,03] += TRB->ZF_RETMOE3 
    aList1[04,03] += TRB->ZF_RETMOE4 
    aList1[05,03] += TRB->ZF_RETMOE5 
    aList1[06,03] := (aList1[01,03] * 0.05) + (aList1[02,03] * 0.10) + (aList1[03,03] * 0.25)+ (aList1[04,03] * 0.50) + (aList1[05,03] * 1)    
    
    If !Empty(TRB->ZF_PATRIMO)
    	Aadd(aList5,{Alltrim(TRB->ZF_PATRIMO),0,0,0,space(6),space(6),space(6),space(6),space(6),space(6),space(6),'',0,'',0,0,0,0,0,0,0,0,0,0,.F.,0,0,0})
    EndIf                                             
    
    If !Empty(TRB->ZF_LACRE)
    	Aadd(aList2,{.F.,TRB->ZF_LACRE,aCores[val(TRB->ZF_CORLACR)],space(6)})
    EndIF
    
    If !Empty(TRB->ZF_ENVELOP)
    	Aadd(aList3,{.F.,TRB->ZF_ENVELOP,space(6)})
    EndIf   
    
    If !Empty(TRB->ZF_GLENVIE)
    	Aadd(aList4,{.F.,TRB->ZF_GLENVIE,space(6)})
    EndIf   
    
	DbSkip()
Enddo  

cQuery := "SELECT * FROM "+RetSQLName("SZN")+" ZN"
cQuery += " WHERE ZN_FILIAL='"+xFilial("SZN")+"' AND ZN_DATA='"+dtos(dDia)+"' AND ZN_ROTA='"+cRota+"' AND D_E_L_E_T_='' AND ZN_NUMOS<>''"
cQuery += " AND ZN_TIPINCL IN ('SANGRIA','AUDITORIA')"
cQuery += " AND ZN_VALIDA <> 'X' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()                         
	If ALLTRIM(TRB->ZN_CONFERE) == "S"	// ALTERADO - FLAG DESSE CAIXA EH "S"
		lCxFech	:=	.T.
	EndIf						//GravaZI(dDia,cPatr,nVlr = aList5[nX,03]+aList5[nX,04]+aList5[nX,16]+aList5[nX,27],aValores,lAuditoria)
    If Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}) > 0
    	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),02] := TRB->ZN_TROCO
    	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),03] := TRB->ZN_NOTA01
    	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),04] := TRB->ZN_MOEDA1R                         	
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),05] := IIF( !Empty(TRB->ZN_LACRMOE),TRB->ZN_LACRMOE,TRB->ZN_LACRCED )	// VERIFCAR SE GRAVA AQUI O LACRE RETIRADO CEDULA
    	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),06] := TRB->ZN_BANANIN	// ALTERADO JACKSON
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),07] := TRB->ZN_GLENVRE
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),08] := TRB->ZN_NUMATU
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),09] := TRB->ZN_COTCASH
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),10] := TRB->ZN_LOGC01
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),11] := TRB->ZN_HORA
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),17] := TRB->ZN_LOGC02
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),18] := TRB->ZN_LOGC03
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),19] := TRB->ZN_LOGC04
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),25] := If('AUDITORIA' $ Alltrim(TRB->ZN_TIPINCL),.T.,.F.)     
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),26] := TRB->ZN_NOTA02
	   	aList5[Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_PATRIMO)}),28] := TRB->R_E_C_N_O_
	   	                                                                                                                                                             
	Else
		Aadd(aList5,{ TRB->ZN_PATRIMO,TRB->ZN_TROCO,TRB->ZN_NOTA01,TRB->ZN_MOEDA1R,IIF( !Empty(Alltrim(TRB->ZN_LACRMOE)),Alltrim(TRB->ZN_LACRMOE),Alltrim(TRB->ZN_LACRCED) ),;
					  TRB->ZN_BANANIN,TRB->ZN_GLENVRE,TRB->ZN_NUMATU,TRB->ZN_COTCASH,TRB->ZN_LOGC01,TRB->ZN_HORA,'',0,'',0,0,TRB->ZN_LOGC02,;
		              TRB->ZN_LOGC03,TRB->ZN_LOGC04,0,0,0,0,0,If('AUDITORIA' $ Alltrim(TRB->ZN_TIPINCL),.T.,.F.),TRB->ZN_NOTA02,0, TRB->R_E_C_N_O_})
	EndIF
	

	//TRATAMENTO PARA MAQUINAS XM E XS PARA OS LACRES COFRE 
	cProd := Posicione("SN1",2,xFilial("SN1")+Avkey(TRB->ZN_PATRIMO,"N1_CHAPA"),"N1_PRODUTO") 
	If Ascan(aMaqXms,{|x| x == Alltrim(cProd)}) > 0
		If Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_GLENVIE)}) > 0            
	    	aList2[Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_GLENVIE)}),04] := TRB->ZN_PATRIMO
		EndIf
		If Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCMOE)}) > 0            
	    	aList2[Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCMOE)}),04] := TRB->ZN_PATRIMO
		EndIf
	Else
		If Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCMOE)}) > 0            
	    	aList2[Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCMOE)}),04] := TRB->ZN_PATRIMO
		EndIf
	EndIf    
	
	// cedula	
	If Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCCED)}) > 0            
    	aList2[Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCCED)}),04] := TRB->ZN_PATRIMO
	EndIf
	
	//If Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCCED)}) > 0            
    //	aList2[Ascan(aList2,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCCED)}),04] := TRB->ZN_PATRIMO
	//EndIf

	If Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_BANANIN)}) > 0
		aList3[Ascan(aList3,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_BANANIN)}),03] := TRB->ZN_PATRIMO
	EndIF
    
    If Ascan(aList4,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_GLENVIE)}) > 0
		aList4[Ascan(aList4,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_GLENVIE)}),03] := TRB->ZN_PATRIMO
	EndIF
	// ALTERADO JACKSON
	//If Ascan(aList4,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCMOE)}) > 0
	//	aList4[Ascan(aList4,{|x| Alltrim(x[2]) == Alltrim(TRB->ZN_LACCMOE)}),03] := TRB->ZN_PATRIMO
	//EndIF
	                                                         
	Dbskip()
EndDo

If len(aList2) < 1
	Aadd(aList2,{.F.,'','',''})
Else
	For nX := 1 to len(aList2)
		If empty(aList2[nX,04])
			If !Empty(Posicione("ZZO",1,xFilial("ZZO")+aList2[nX,02]+"1","ZZO_DATRET"))
				aList2[nX,01] := .T.
			EndIf
		EndIf
	Next nX
EndIf

If len(aList3) < 1
	Aadd(aList3,{.F.,'','',''})
Else
	For nX := 1 to len(aList3)
		If empty(aList3[nX,03])
			If !Empty(Posicione("ZZO",1,xFilial("ZZO")+aList3[nX,02]+"2","ZZO_DATRET"))
				aList3[nX,01] := .T.
			EndIf
		EndIf
	Next nX
EndIf

If len(aList4) < 1
	Aadd(aList4,{.F.,'','',''})
Else
	For nX := 1 to len(aList4)
		If empty(aList4[nX,03])
			If !Empty(Posicione("ZZO",1,xFilial("ZZO")+aList4[nX,02]+"3","ZZO_DATRET"))
				aList4[nX,01] := .T.
			EndIf
		EndIf
	Next nX
EndIf

If len(aList5) < 1
	//Aadd(aList5,{'',0,0,0,'','',''})
	Aadd(aList5,{"",0,0,0,space(6),space(6),space(6),space(6),space(6),space(6),space(6),'',0,'',0,0,0,0,0,0,0,0,0,0,.F.,0,0,0})
Else      
//			12					13				14					15				16        17    18    19     20       21       22       23       24         25         26
// data cash anterior ,  cash anterior, hora cash anterior, fundo troco anterior, venda pos,LOGC2,LOGC3,LOGC4,LOGC1ANT,LOGC2ANT,LOGC3ANT,LOGC4ANT,novofdotro,auditoria,trocosangrado
	For nX := 1 to len(aList5)
		//Busca o contador cash anterior  
		//RETORNO  'LOGC01 ESTA NA 10'
		//		1					2				3				4				5				6				7
		//TRB2->ZN_COTCASH,STOD(TRB2->ZN_DATA),TRB2->ZN_HORA,TRB2->ZN_LOGC01,TRB2->ZN_LOGC02,TRB2->ZN_LOGC03,TRB2->ZN_LOGC04
		
		// PEGA DADOS AUXILIARES PARA CONSULTA DA VENDA DO POS
		aFinr14 := STATICCALL( TTFINR14,VendAnt,aList5[nX,01],dDia )     
		
		//cash 1, data 2, hora 3
		aAuxPOS := {}
		If len(aFinr14) > 0
			aList5[nX,12] :=	aFinr14[2]
			aList5[nX,13] := 	aFinr14[1]
			aList5[nX,14] :=	aFinr14[3]
			aList5[nX,20] :=	aFinr14[4]
			aList5[nX,21] :=	aFinr14[5]
			aList5[nX,22] :=	aFinr14[6]
			aList5[nX,23] := 	aFinr14[7]
			
		    Aadd( aAuxPOS,{ dtos(dDia),aList5[nX,11] } )
		    Aadd( aAuxPOS,{ dtos(aFinr14[2]),aFinr14[3] } )
		EndIf
		
		aList5[nX,15] := STATICCALL( TTAUDT02,saldofd,aList5[nX,01],dDia,0 )
        
		aList5[nX,16] := If( len(aAuxPOS)>0,STATICCALL( TTAUDT02,VendaPOS,aList5[nX,01],aAuxPOS),0 )	// ( MAQUINA { [DATA,HORA],[DATA,HORA] } )
		
		//Consulta vendas ja importadas no sistema do ccartoes
	   	If "SM=1" $ posicione("SN1",2,xFilial("SN1")+aList5[nX,01],"N1_XSISPG")
			If !Empty(aList5[nX,12]) .And. !Empty(aList5[nX,14]) .And. !Empty(aList5[nX,11])
				cDe 	:= substr(dtos(aList5[nX,12]),1,4)+"-"+substr(dtos(aList5[nX,12]),5,2)+"-"+substr(dtos(aList5[nX,12]),7,2)+" "+aList5[nX,14]+":00" //substr(dtos(aFinr14[2]),1,4)+"-"+substr(dtos(aFinr14[2]),5,2)+"-"+substr(dtos(aFinr14[2]),7,2)+" "+aFinr14[3]+":00"
				cAte 	:= substr(dtos(dDia),1,4)+"-"+substr(dtos(dDia),5,2)+"-"+substr(dtos(dDia),7,2)+" "+aList5[nX,11]+":00"
				If !Empty(cDe) .And. !Empty(cAte)
					aList5[nX,27] := 0	//consCct(aList5[nX,01],cDe,cAte)	// AJUSTAR A CONSULTA
				EndIf
			EndIf
		EndIf		
	Next nX
EndIf

FHelp()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Lancamento dos trocos retornados                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol1(nLinha)
 
Local aArea	:=	GetArea()
Local nTot	:=	0
Local aVlr	:=	{0.05,0.10,0.25,0.50,1}

lEditCell(aList1, oList1, "@E 999,999.99",3)

For nX := 1 to 5
	nTot += (aList1[nX,03] * aVlr[nX])
Next nX                  

aList1[06,03] := nTot

oList1:refresh()
oDlg1:refresh()

Fhelp()

RestArea(aArea)

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Lancamentos dos patrimonios.                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol2(nLinha)

Local aArea	:=	GetArea()
Local lRet	:=	.F.
Local nSair	:=	5
Local nPos	:=	oList2:colpos    
Local cQuery
Local nTroSng := aList5[nLinha,26]
Local oTrocos,oSayTr,oGetTr,oSBTr

//U_TTFINC28(aList5[nLinha,01])

//lCxFech

For nX := 3 to 4 //len(aList5[nLinha])  alterado de 2 a 4 para 3 a 4 porque as informacoes ja devem vir digitadas pelo celular
	
	If lCxFech .And. nX == 3
		Loop
	EndIf
	
	lEditCell(aList5, oList5, "@E 999,999.99",nX) 
	
	If nX == 4 .And. aList5[nLinha,25] 
		oTrocos     := MSDialog():New( 091,232,212,479,"Troco Sangrado",,,.F.,,,,,,.T.,,,.T. )
		oSayTr      := TSay():New( 012,020,{||"Informe o Valor do Troco Sangrado"},oTrocos,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
		oGetTr      := TGet():New( 024,032,{|u|If(PCount()>0,nTroSng:=u,nTroSng)},oTrocos,048,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
		oSBTr     	:= SButton():New( 040,043,1,{||oTrocos:end()},oTrocos,,"", )
		
		oTrocos:Activate(,,,.T.)
		aList5[nLinha,26] := nTroSng
	EndIf
	
Next nX           

If Substr(Posicione("SN1",2,xFilial("SN1")+aList5[oList5:nAt,01],"N1_DESCRIC"),1,7) == "RECARGA"
	Conflog(0)
EndIF
/*             Tesouraria nใo digitara mais as informacoes de lacres */
While nSair < 8
	//lEditCell(aList5, oList5, "@!",nSair)
	If nSair <> 6 .And. !Empty(aList5[nLinha,nSair])
		cQuery := "SELECT TOP 1 ZZO_LACRE,ZZO_CORLAC FROM "+RetSQLName("ZZO")
		cQuery += " WHERE ZZO_PATRIM='"+aList5[oList5:nAt,01]+"' AND ZZO_DATUTI<>'' AND ZZO_DATUTI<>'"+DTOS(DDIA)+"' AND D_E_L_E_T_=''"
		cQuery += " AND ZZO_TIPO='"+cvaltochar(nSair-4)+"' ORDER BY ZZO_DATUTI DESC"
	
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB")
		If Len(aList5) >= nSair	
			If aList5[nLinha,nSair] != TRB->ZZO_LACRE .AND. !EMPTY(TRB->ZZO_LACRE)
			//aList5[nSair,oList5:colpos] != TRB->ZZO_LACRE .AND. !EMPTY(TRB->ZZO_LACRE)
				Msgalert("O Item retirado nใo bate com o ultimo item deixado no patrim๔nio "+chr(13)+chr(10)+If(nSair==5,"Lacre Informado ","Glenview Informado ")+Alltrim(aList5[nLinha,nSair])+" e consta o item "+Alltrim(TRB->ZZO_LACRE)+" no patrimonio","TTFINC24")
			EndIf
		EndIf
	EndIf
	nSair++
	
EndDo                   
/**/
      
FHelp()

RestArea(aArea)

Return        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Lacres                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol3(nLinha)

Local aArea	:=	GetArea()
Local nPos	:=	oList2:colpos
Local lSair	:=	.T.

If nPos == 1
	If aList2[nLinha,nPos]
		aList2[nLinha,nPos] := .F.
	Else
		aList2[nLinha,nPos] := .T.
	EndIf
Else   //Tesouraria nao deve mais digitar as informacoes dos lacres
	While lSair
		lEditCell(aList2, oList2, "@!",4)	
		For nX := 1 to len(aList5)
			If aList5[nX,01] == aList2[nLinha,04] .OR. Empty(aList2[nLinha,04])
				lSair := .F.
				exit
			EndIf
		Next nX
		If lSair
			MsgAlert("O Patrim๔nio informado nใo consta na lista enviada para a Rota!!! Verifique","TTFINC24")
		EndIf
	EndDo
	     
EndIf
      
FHelp()

RestArea(aArea)

Return        
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bananinha                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol4(nLinha)

Local aArea	:=	GetArea()
Local nPos	:=	oList3:colpos
Local lSair	:=	.T.

If nPos == 1
	If aList3[nLinha,nPos]
		aList3[nLinha,nPos] := .F.
	Else
		aList3[nLinha,nPos] := .T.
	EndIf
Else  //Tesouraria nao deve mais digitar as informacoes dos lacres
	While lSair
		lEditCell(aList3, oList3, "@!",3)
		For nX := 1 to len(aList5)
			If aList5[nX,01] == aList3[nLinha,03] .or. Empty(aList3[nLinha,03])
				lSair := .F.
				exit
			EndIf
		Next nX
		If lSair
			MsgAlert("O Patrim๔nio informado nใo consta na lista enviada para a Rota!!! Verifique","TTFINC24")
		EndIf
	EndDo 
EndIf
      
FHelp()

RestArea(aArea)

Return        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Glenview                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol5(nLinha)

Local aArea	:=	GetArea()
Local nPos	:=	oList4:colpos
Local lSair	:=	.T.

If nPos == 1
	If aList4[nLinha,nPos]
		aList4[nLinha,nPos] := .F.
	Else
		aList4[nLinha,nPos] := .T.
	EndIf
Else   //Tesouraria nao deve mais digitar as informacoes dos lacres
	While lSair
		lEditCell(aList4, oList4, "@!",3)
			For nX := 1 to len(aList5)
			If aList5[nX,01] == aList4[nLinha,03] .Or. Empty(aList4[nLinha,03])
				lSair := .F.
				exit
			EndIf
		Next nX
		If lSair
			MsgAlert("O Patrim๔nio informado nใo consta na lista enviada para a Rota!!! Verifique","TTFINC24")
		EndIf
	Enddo 
EndIf
      
FHelp()

RestArea(aArea)

Return        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualizacao dos campos.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp()
                                         
Local aArea	:=	GetArea()               
Local nTotE	:=	0
Local nTotR	:=	0
Local nTotA	:=	0 
Local nTotC	:=	0
Local nTotM	:=	0
Local aVlr	:=	{0.05,0.10,0.25,0.50,1}    
Local nLc	:=	0
Local nBn	:=	0
Local nGl	:=	0
Local aAuxPOS := {}   
Local nDifP	:=	0
Local nDifD	:=	0
      
oSay2:settext("")
oSay4:settext("")
oSay6:settext("")
oSay8:settext("")		//troco enviado
oSay10:settext("")		//troco retornado
oSay12:settext("")     //troco abastecido
oSay14:settext("")
oSay16:settext("")
oSay18:settext("")
oSay19:settext("")
oSay20:settext("")
oSay21:settext("") 
oSay26:settext("")
oSay53:settext("")

For nX := 1 to 5
	nTotE += (aList1[nX,02] * aVlr[nX])
	nTotR += (aList1[nX,03] * aVlr[nX])
Next nX          

For nX := 1 to len(aList5)
	nTotA	+= aList5[nX,02]
	nTotC	+= aList5[nX,03]
	nTotM	+= aList5[nX,04]
Next nX
                 
For nX := 1 to len(aList2)
	If !empty(aList2[nX,04])
		nLc++
	EndIf
Next nX

For nX := 1 to len(aList3)
	If !Empty(aList3[nX,03])
		nBn++
	EndIf
Next nX

For nX := 1 to len(aList4)
	If !Empty(aList4[nX,03])
		nGl++
	EndIf
Next nX

oSay2:settext(cvaltochar(len(aList2))+"/"+cvaltochar(len(aList2)-nLc))
oSay4:settext(cvaltochar(len(aList3))+"/"+cvaltochar(len(aList3)-nBn))
oSay6:settext(cvaltochar(len(aList4))+"/"+cvaltochar(len(aList4)-nGl))
oSay8:settext(Transform(nTotE,"@E 999,999,999.99"))
oSay10:settext(Transform(nTotR,"@E 999,999,999.99"))
oSay12:settext(Transform(nTotA,"@E 999,999,999.99"))
oSay14:settext(Transform(nTotE - (nTotR + nTotA),"@E 999,999,999.99"))
oSay16:settext(Transform(nTotC,"@E 9,999,999.99"))
oSay18:settext(Transform(nTotM,"@E 9,999,999.99"))

   
If Valtype(oList5) != "U"
	If !Empty(aList5[oList5:nAt,01])
		DbSelectArea("SN1")
		DbSetOrder(2)
		Dbseek(xFilial("SN1")+aList5[oList5:nAt,01])
		oSay19:settext(Alltrim(Posicione("SA1",1,xFilial("SA1")+SN1->N1_XCLIENT+SN1->N1_XLOJA,"A1_NREDUZ")))
		oSay20:settext(Alltrim(SN1->N1_DESCRIC)) 
		
		//Patrimonio
		oSay26:settext(aList5[oList5:nAt,01] + " " + substr(SN1->N1_DESCRIC,1,25))

//			12					13				14					15				16        17    18    19     20       21       22       23
// data cash anterior ,  cash anterior, hora cash anterior, fundo troco anterior, venda pos,LOGC2,LOGC3,LOGC4,LOGC1ANT,LOGC2ANT,LOGC3ANT,LOGC4ANT
        //inicio 
        
		//comum aos dois tipos de sangria
       	//Fundo de troco anterior
       	nFdo := aList5[oList5:nAt,15]
       	
       	//Total em vendas no POS registradas  
        nPos := aList5[oList5:nAt,16] 
       
	 	If Valtype(aList5[oList5:nAt,10]) == "C"
       		nVlr5 :=  VAL(aList5[oList5:nAt,10])
       	Else
       		nVlr5 :=  aList5[oList5:nAt,10]   
       	EndIf
       	If Valtype(aList5[oList5:nAt,17]) == "C"
       		nVlr6 :=  VAL(aList5[oList5:nAt,17])
       	Else
       		nVlr6 :=  aList5[oList5:nAt,17]   
       	EndIf
       	If Valtype(aList5[oList5:nAt,18]) == "C"
       		nVlr7 :=  VAL(aList5[oList5:nAt,18])
       	Else
       		nVlr7 :=  aList5[oList5:nAt,18]   
       	EndIf
       	If Valtype(aList5[oList5:nAt,19]) == "C"
       		nVlr8 :=  VAL(aList5[oList5:nAt,19])
       	Else
       		nVlr8 :=  aList5[oList5:nAt,19]   
       	EndIf

        If "RECARGA" $ Alltrim(SN1->N1_DESCRIC)
			
			If valtype(aList5[oList5:nAt,20]) == "C"
	       		//especifico recarga       
	       		
	       		oSay30:settext(cvaltochar(nVlr5+nVlr6+nVlr7+nVlr8))
				oSay29:settext("Cash Anterior "+cvaltochar(aList5[oList5:nAt,12]))
				nCAnt := (val(aList5[oList5:nAt,20])+val(aList5[oList5:nAt,21])+val(aList5[oList5:nAt,22])+val(aList5[oList5:nAt,23]))
				oSay31:settext(cvaltochar(val(aList5[oList5:nAt,20])+val(aList5[oList5:nAt,21])+val(aList5[oList5:nAt,22])+val(aList5[oList5:nAt,23]))) 
				nDinCnt := (nVlr5+nVlr6) - (val(aList5[oList5:nAt,20])+val(aList5[oList5:nAt,21]))    
			else                                                                                                    
	       		oSay30:settext(cvaltochar(nVlr5+nVlr6+nVlr7+nVlr8))
				oSay29:settext("Cash Anterior "+cvaltochar(aList5[oList5:nAt,12]))
		    	oSay31:settext(cvaltochar(aList5[oList5:nAt,20]+aList5[oList5:nAt,21]+aList5[oList5:nAt,22]+aList5[oList5:nAt,23]))     
			    nCAnt := (aList5[oList5:nAt,20]+aList5[oList5:nAt,21]+aList5[oList5:nAt,22]+aList5[oList5:nAt,23])             
			    nDinCnt := (nVlr5+nVlr6) - aList5[oList5:nAt,20]+aList5[oList5:nAt,21]
		 	endif 
		 	nVend := nVlr5+nVlr6+nVlr7+nVlr8-nCAnt
	        //nVend := (VAL(aList5[oList5:nAt,10])+VAL(aList5[oList5:nAt,17])+VAL(aList5[oList5:nAt,18])+VAL(aList5[oList5:nAt,19]))-nCAnt
	        nPosLoc := (nVlr8-if(valtype(aList5[oList5:nAt,23])=="C",val(aList5[oList5:nAt,23]),aList5[oList5:nAt,23]))
	        nPosLoc := substr(cvaltochar(nPosLoc),1,len(cvaltochar(nPosLoc))-2)+"."+right(cvaltochar(nPosLoc),2) 
	        nDifP := nPos - val(nPosLoc)                              
	        nDinR := (aList5[oList5:nAt,03]+aList5[oList5:nAt,04])
	        nDifD := val(substr(cvaltochar(nDinCnt),1,len(cvaltochar(nDinCnt))-2)+"."+right(cvaltochar(nDinCnt),2)) - nDinR
        Else                    
        	//especifico maquinas       
   			//Informacoes sobre a venda do patrimonio
			oSay30:settext(aList5[oList5:nAt,09])

			oSay29:settext("Cash Anterior "+cvaltochar(aList5[oList5:nAt,12]))
			oSay31:settext(cvaltochar(aList5[oList5:nAt,13]))
			If valtype(aList5[oList5:nAt,09]) == "C" 
	    		nVend := val(aList5[oList5:nAt,09])-aList5[oList5:nAt,13]  
	  		else
		  		nVend := aList5[oList5:nAt,09]-aList5[oList5:nAt,13]  
	  		endif
	    	nDifP := 0
	    	nDifD := 0
		EndIf
		//aList5[nX,27]
		//comum aos dois
		nVend := substr(cvaltochar(nVend),1,len(cvaltochar(nVend))-2)+"."+right(cvaltochar(nVend),2) 
		       
		oSay33:settext(Transform(val(nVend),"@E 999,999,999.99"))                  //venda
		oSay35:settext(Transform(nFdo,"@E 999,999,999.99"))                        //fundo de troco anterior
		oSay49:settext(Transform(aList5[oList5:nAt,02],"@E 999,999,999.99"))       //troco abastecido
        oSay38:settext(Transform(aList5[oList5:nAt,03]+aList5[oList5:nAt,04],"@E 999,999,999.99")+if(nDifD<>0," *","")) 
        

        oSay39:settext("POS "+POSPatr(aList5[oList5:nAt,01]))
        oSay40:settext(Transform(nPos,"@E 999,999,999.99")+if(nDifP<>0," *",""))      //Vendas em POS
         
        oSay42:settext(Transform(nPos+aList5[oList5:nAt,03]+aList5[oList5:nAt,04],"@E 999,999,999.99"))    //Total de sangria
        
        //vendas ccartoes
        oSay53:settext(Transform(aList5[oList5:nAt,27],"@E 999,999,999.99")) 
        
        oSay44:settext(Transform(SN1->N1_XLIMTRO,"@E 999,999,999.99"))  
        
        //Adicao liquida
        //oSay51:settext(Transform(val(nVend)-(nPos+aList5[oList5:nAt,03]+aList5[oList5:nAt,04]),"@E 999,999,999.99"))
        oSay51:settext(Transform( (val(nVend)+aList5[oList5:nAt,02]) -(nPos+aList5[oList5:nAt,03]+aList5[oList5:nAt,04]+aList5[oList5:nAt,27]),"@E 999,999,999.99"))                                                                                                                                    
        
        oSay47:settext(Transform((val(nVend)+nFdo+aList5[oList5:nAt,02])-(nPos+aList5[oList5:nAt,03]+aList5[oList5:nAt,04]),"@E 999,999,999.99"))  
        
        aList5[oList5:nAt,24] := (val(nVend)+nFdo+aList5[oList5:nAt,02])-(nPos+aList5[oList5:nAt,03]+aList5[oList5:nAt,04])

        //fim
        
		aAuxZ := strtokarr(Alltrim(SN1->N1_XSISPG),"|")
		cSisPg := ''         
		cBarra := ''
		For nPd := 1 to len(aAuxZ)
			If substr(aAuxZ[nPd],4,1) == "1"
				cSisPg +=  cBarra + substr(aAuxZ[nPd],1,2)
				cBarra := "/"
			EndIf
		Next nPd
		oSay21:settext(cSisPg)
	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Incluir um novo patrimonio na rota                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function incluir()

Local aArea	:=	GetArea()
Local aPergs	:= 	{} 
Local aRet		:= 	{} 

aAdd(aPergs ,{1,"Patrim๔nio"	,space(TamSx3("ZN_PATRIMO")[1]),"@!",".T.","SN1APT",".T.",100,.F.})
	
If ParamBox(aPergs ,"Incluir Patrim๒nio",@aRet) 
	If Ascan(aList5,{|x| Alltrim(x[1]) == Alltrim(aRet[1])}) == 0
		Aadd(aList5,{aRet[1],0,0,0,space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6),space(6)})  
		/*Reclock("SZN",.T.)                     
		SZN->ZN_FILIAL	:=	xFilial("SZN")
		SZN->ZN_ROTA 	:=	cRota
		SZN->ZN_DATA 	:=	dDia
		SZN->ZN_TIPINCL	:=	'SANGRIA'
		SZN->ZN_PATRIMO	:=	aRet[1] 
		SZN->ZN_NUMOS	:=	'AVULSO'
		ZN->(Msunlock())*/
	Else
		MsgAlert("Patrimonio jแ se encontra na lista desta rota, favor verificar","TTFINC4")
	EndIf
	oList5:refresh()
	oDlg1:refresh()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Salvar as informacoes                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function gravar()

Local aArea		:=	GetArea()
Local cSisPg	:=	''
Local nVlrtr	:=	0
Local aEmail	:=	{} 
Local cClie		:=	''
Local cParM		:=	GETMV("MV_XEMAUD")
Local nVenda	:= 0
Local nAdLiq 	:= 0 
Local uCash		:= Nil

If !lCxFech
	//Validacao para nao permitir encerrar a prestacao de contas sem que todos os patrimonios tenham sido modificados.
	For nX := 1 to len(aList5)
		If aList5[nX,02] == 0 .And. aList5[nX,03] == 0 .And. aList5[nX,04] == 0 .And. Empty(aList5[nX,05]) .And. Empty(aList5[nX,06]) .And. Empty(aList5[nX,07])
	    	If !VerZF(aList5[nX,01],cRota,dDia)
	    		RestArea(aArea)
	    		Return
	    	EndIf
		EndIf
	Next nX
		
	//Validacoes para auditoria
	DbSelectArea("SN1")
	DbSetOrder(2)
	For nX := 1 to len(aList5)
		cSisPg := ''
		nVlrtr := 0
		If Dbseek(xFilial("SN1")+aList5[nX,01])
			cSisPg := SN1->N1_XSISPG
			nVlrtr := SN1->N1_XLIMTRO
			cClie  := SN1->N1_XCLIENT+SN1->N1_XLOJA
		EndIf
	    If "MC=1" $ cSisPg
	    	If aList5[nX,24] > nVlrtr .Or. aList5[nX,24] < 0
	    		Aadd(aEmail,{aList5[nX,01],aList5[nX,24],nVlrtr,cClie})
	    	EndIf
	    EndIf
	    If "MS=1" $ cSisPg
	    	If aList5[nX,24] < -5 .OR. aList5[nX,24] > 5
	       		Aadd(aEmail,{aList5[nX,01],aList5[nX,24],0,cClie})
	    	EndIf
	    EndIf				
	Next nX
	//Disparo do email de auditoria
	If len(aEmail) > 0
	
		cMsg := "<b><font face='Verdana'>Solicita็ใo de Auditoria para Patrim๔nios com Fundo de Troco estourado.</font></b><br><br><br>"
		cMsg += "<table border='1'>"
		cMsg += "	<tr align='center' bgcolor=blue>"
		cMsg += "	   <td><font color='#FFFFFF' face='Verdana'><B>Patrim๔nio</B></font></td>"
		cMsg += "	   <td><font color='#FFFFFF' face='Verdana'><B>Cliente</B></font></td>"
		cMsg += "	   <td><font color='#FFFFFF' face='Verdana'><B>Fundo de troco</B></font></td>"
		cMsg += "	   <td><font color='#FFFFFF' face='Verdana'><B>Limite Fundo de Troco</B></font></td>"
		cMsg += "	   <td><font color='#FFFFFF' face='Verdana'><B>Diferen็a</B></font></td>"
		cMsg += "	   <td><font color='#FFFFFF' face='Verdana'><B>Abastecedor</B></font></td>"
		cMsg += "	</tr>"
		
	   	For nX := 1 to len(aEmail)
			cMsg += "	<tr align='right'>"
			cMsg += "	  <td>"+aEmail[nX,01]+"</td>"
			cMsg += "	  <td>"+aEmail[nX,04]+"  -  "+Posicione("SA1",1,xFilial("SA1")+aEmail[nX,04],"A1_NREDUZ")+"</td>"
			cMsg += "	  <td>R$ "+cvaltochar(Transform(aEmail[nX,02],"@R 999,999,999.99"))+"</td>"
			cMsg += "	  <td>R$ "+cvaltochar(Transform(aEmail[nX,03],"@R 999,999,999.99"))+"</td>"
			cMsg += "	  <td><font color='#FF0000'>R$ "+cvaltochar(Transform(aEmail[nX,03]-aEmail[nX,02],"@R 999,999,999.99"))+"</font></td>"
			cMsg += "	  <td>Rota "+cRota+"</td>"
			cMsg += "	</tr>"
		//	cMsg += 'Patrimonio '+aEmail[nX,01]+" - Valor do fundo de troco "+cvaltochar(aEmail[nX,02])+" - Limite do Fundo de Troco "+cvaltochar(aEmail[nX,03])+chr(13)+chr(10)
		Next nX
		U_TTMAILN('microsiga@toktake.com.br',cParM,'Auditoria',cMsg,{},.F.)	
	EndIf
	
	//MOEDAS
	DbSelectArea("SZF")
	DbSetOrder(1)
	If DbSeek(xFilial("SZF")+cRota+dtos(dDia))
		Reclock("SZF",.F.)
		SZF->ZF_RETMOE1	:=	aList1[01,03]
	    SZF->ZF_RETMOE2	:=	aList1[02,03]
	    SZF->ZF_RETMOE3	:=	aList1[03,03]
	    SZF->ZF_RETMOE4	:= 	aList1[04,03]
	    SZF->ZF_RETMOE5	:= 	aList1[05,03]
		SZF->(Msunlock())
	EndIF
	
	//PRESTACAO DE CONTAS POR PATRIMONIO
	DbSelectArea("SZN")
	DbSetOrder(5)
	For nX := 1 to len(aList5)
		
		uCash := aList5[nX][9]
		If ValType( uCash ) == "C"
			uCash := Val( uCash )
		EndIf
		
		nVenda := uCash - aList5[nX][13]
		//nAdLiq := ( nVenda + aList5[nX][2] ) - ( aList5[nX][16] +aList5[nX][03] +aList5[nX][04] +aList5[nX][27] ) 
		
		GravaZI( dDia,aList5[nX,01],aList5[nX,03]+aList5[nX,04]+aList5[nX,16]+aList5[nX,27],aList5[nX],aList5[nX,25] )
		DbSelectArea("SZN")
		DbSetOrder(5)
	
		If !aList5[nX,25]
			If DbSeek(xFilial("SZN")+dtos(dDia)+Avkey(aList5[nX,01],"ZN_PATRIMO")+Avkey('SANGRIA',"ZN_TIPINCL")+Avkey(cRota,"ZN_ROTA"))
				RecLock("SZN",.F.)
				SZN->ZN_TROCO	:=	aList5[nX,02]
				SZN->ZN_NOTA01	:=	aList5[nX,03]
				SZN->ZN_MOEDA1R	:=	aList5[nX,04]
				SZN->ZN_LACRMOE	:=	aList5[nX,05]
				SZN->ZN_LACRCED	:=	aList5[nX,06]
				SZN->ZN_GLENVRE	:=	aList5[nX,07]
				
				// venda
				SZN->ZN_RESCASH := nVenda  
				
				SZN->(Msunlock())
			EndIf
		Else
			If DbSeek(xFilial("SZN")+dtos(dDia)+aList5[nX,01]+'AUDITORIA'+cRota)
				Reclock("SZN",.F.)
				SZN->ZN_TROCO	:=	aList5[nX,02]
				SZN->ZN_NOTA01	:=	aList5[nX,03]
				SZN->ZN_MOEDA1R	:=	aList5[nX,04]
				SZN->ZN_LACRMOE	:=	aList5[nX,05]
				SZN->ZN_LACRCED	:=	aList5[nX,06]
				SZN->ZN_GLENVRE	:=	aList5[nX,07]
				SZN->ZN_NOTA02	:=	aList5[nX,26]
				
				// venda
				SZN->ZN_RESCASH := nVenda  
				
				SZN->(Msunlock())
			EndIf
		EndIf 
		
		If !Empty(aList5[nX,05]) .Or. !Empty(aList5[nX,06]) .Or. !Empty(aList5[nX,07])
			BaixaRet(aList5[nX,05],aList5[nX,06],aList5[nX,07],aList5[nX,01])
		EndIf
	Next nX
	
	//LACRES
	DbSelectArea("SZN")
	DbSetOrder(5)
	For nX := 1 to len(aList2)
		If !empty(aList2[nX,04])
			If DbSeek(xFilial("SZN")+dtos(dDia)+aList2[nX,04]+'SANGRIA'+cRota)
				Reclock("SZN",.F.)
				SZN->ZN_LACCMOE	:=	aList2[nX,02]
				SZN->(Msunlock())
			EndIf
			/*DbSelectArea("ZZO")
			DbSetOrder(1)
			If DbSeek(xFilial("ZZO")+aList2[nX,02]+"1")
				Reclock("ZZO",.F.)
				ZZO->ZZO_PATRIM	:=	aList2[nX,04]	
				ZZO->ZZO_DATUTI	:=	dDia	
				ZZO->(Msunlock())
			EndIf*/
			RetornaLc(aList2[nX,02],'2',aList2[nX,04])
			DbSelectArea("SZN")
			DbSetOrder(2)
		Else
			If aList2[nX,01]
				/*DbSelectArea("ZZO")
				DbSetOrder(1)
				If DbSeek(xFilial("ZZO")+aList2[nX,02]+"1")
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET	:=	dDia	
					ZZO->(Msunlock())
				EndIf*/
				RetornaLc(aList2[nX,02],'1','')
				DbSelectArea("SZN")
				DbSetOrder(2)
			Else
				If MsgYesNo("Nใo houve presta็ใo de contas para o lacre "+aList2[nX,02]+chr(13)+chr(10)+"Clique em Sim para manda-lo para a Lista Negra ou em Nใo para confirmar o seu retorno.","TTFINC24")
					DbSelectArea("ZZO")
					DbSetOrder(1)
					If DbSeek(xFilial("ZZO")+aList2[nX,02]+"1")
						Reclock("ZZO",.F.)
						ZZO->ZZO_BLACKL	:=	'X'
						ZZO->ZZO_DATUTI	:=	dDataBase	
						ZZO->(Msunlock())
					EndIf
					DbSelectArea("SZN")
					DbSetOrder(2)
				Else
					/*DbSelectArea("ZZO")
					DbSetOrder(1)
					If DbSeek(xFilial("ZZO")+aList2[nX,02]+"1")
						Reclock("ZZO",.F.)
						ZZO->ZZO_DATRET	:=	dDia	
						ZZO->(Msunlock())
					EndIf */
					RetornaLc(aList2[nX,02],'1','')
					DbSelectArea("SZN")
					DbSetOrder(2)
				EndIf	
			EndIf
		EndIf
	Next nX
	
	//BANANINHA   
	DbSelectArea("SZN")
	DbSetOrder(5)
	For nX := 1 to len(aList3)
		If !empty(aList3[nX,03])
			If DbSeek(xFilial("SZN")+dtos(dDia)+aList3[nX,03]+'SANGRIA'+cRota)
				Reclock("SZN",.F.)
				SZN->ZN_BANANIN	:=	aList3[nX,02]
				SZN->(Msunlock())
			EndIf
			DbSelectArea("ZZO")
			DbSetOrder(1)
			If DbSeek(xFilial("ZZO")+aList3[nX,02]+"2")
				Reclock("ZZO",.F.)
				ZZO->ZZO_PATRIM	:=	aList3[nX,03]	
				ZZO->ZZO_DATUTI	:=	dDia	
				ZZO->(Msunlock())
			EndIf
			DbSelectArea("SZN")
			DbSetOrder(2)
		Else
			If aList3[nX,01]
				DbSelectArea("ZZO")
				DbSetOrder(1)
				If DbSeek(xFilial("ZZO")+aList3[nX,02]+"2")
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET	:=	dDia	
					ZZO->(Msunlock())
				EndIf
				DbSelectArea("SZN")
				DbSetOrder(2)
			EndIf
	
		EndIf
	Next nX
	
	//GLENVIEW    
	DbSelectArea("SZN")
	DbSetOrder(5)
	For nX := 1 to len(aList4)
		If !empty(aList4[nX,03])
			If DbSeek(xFilial("SZN")+dtos(dDia)+aList4[nX,03]+'SANGRIA'+cRota)
				Reclock("SZN",.F.)
				SZN->ZN_GLENVIE	:=	aList4[nX,02]
				SZN->(Msunlock())
			EndIf
			/*DbSelectArea("ZZO")
			DbSetOrder(1)
			If DbSeek(xFilial("ZZO")+aList4[nX,02]+"3")
				Reclock("ZZO",.F.)
				ZZO->ZZO_PATRIM	:=	aList4[nX,03]	
				ZZO->ZZO_DATUTI	:=	dDia	
				ZZO->(Msunlock())
			EndIf */
			RetornaLc(aList4[nX,02],'2',aList4[nX,03])
			DbSelectArea("SZN")
			DbSetOrder(2)
		Else
			If aList4[nX,01]
				/*DbSelectArea("ZZO")
				DbSetOrder(1)
				If DbSeek(xFilial("ZZO")+aList4[nX,02]+"3")
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET	:=	dDia	
					ZZO->(Msunlock())
				EndIf  */
				RetornaLc(aList4[nX,02],'1','')
				DbSelectArea("SZN")
				DbSetOrder(2)
			EndIf
		
		EndIf
	Next nX
// somente moedas
Else
//PRESTACAO DE CONTAS POR PATRIMONIO
	DbSelectArea("SZN")
	DbSetOrder(5)
	For nX := 1 to len(aList5)
		
		GravaZI( dDia,aList5[nX,01],aList5[nX,03]+aList5[nX,04]+aList5[nX,16]+aList5[nX,27],aList5[nX],aList5[nX,25] )
		
		If !aList5[nX,25]
			If DbSeek( xFilial("SZN")+dtos(dDia)+aList5[nX,01]+'SANGRIA'+cRota)
				Reclock("SZN",.F.)
				SZN->ZN_TROCO	:=	aList5[nX,02]
				SZN->ZN_MOEDA1R	:=	aList5[nX,04]
				SZN->(Msunlock())
			EndIf
		Else
			If DbSeek( xFilial("SZN")+dtos(dDia)+aList5[nX,01]+'AUDITORIA'+cRota)
				Reclock("SZN",.F.)
				SZN->ZN_TROCO	:=	aList5[nX,02]
				SZN->ZN_MOEDA1R	:=	aList5[nX,04]
				SZN->(Msunlock())
			EndIf
		EndIf
	Next nX 
EndIf


oDlg1:end()

If MsgYesNo("Confirma o encerramento?")
	dbSelectArea("SZN")
	For nI := 1 To Len( aList5 )
		If aList5[nI][28] > 0
			dbGoTo(aList5[nI][28])
			RecLock("SZN",.F.)
			SZN->ZN_CONFERE := "S"
			SZN->(MsUnLock())
		EndIf
	Next nI
	
	If MsgYesNo("Deseja imprimir o romaneio de presta็ใo de contas?","TTFINC24")
		aRota := {cRota,dDia,.F.}
		U_TTFINR14(aRota)	
	EndIf
EndIf


RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณconfLog  บAutor  ณJackson E. de Deus   บ Data ณ  10/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Conferencia do Log 5                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function confLog(NP)
                     
Local aArea		:=	GetArea()
Local nRecSZN := 0
Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ RECZN FROM " +RetSqlName("SZN") 
cQuery += " WHERE ZN_DATA = '"+DTOS(dDia)+"' AND ZN_ROTA = '"+cRota+"' AND ZN_PATRIMO = '"+aList5[oList5:nAt,01]+"' AND ZN_TIPINCL LIKE '%SANGRIA%' "
cQuery += " AND ( ZN_LOGC01 <> '' OR ZN_LOGC02 <> '' OR ZN_LOGC03 <> '' OR ZN_LOGC04 <> '' ) AND D_E_L_E_T_ = ''  "
         
If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf                   
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ',.F.,.T.)   
dbSelectArea("TRBZ")
If !EOF()
	nRecSZN := TRBZ->RECZN
EndIf 

If nRecSZN > 0 
	Processa({ || U_TTFINC29(nRecSZN,If(NP==0,"1","0"))}, "Aguarde validando o Log C5 informado pela rota..." )
Else
	MsgInfo("Nใo hแ lan็amento dos logs para esse patrim๔nio.")
EndIf
                             
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  08/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o patrimonio foi retirado da rota do dia       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerZF(cPatrimo,cRota,dDia)

Local aArea	:=	GetArea()
Local cQuery 
Local lRet	:=	.F.

cQuery := "SELECT ZF_ALTERAD,ZE_TIPOPLA FROM "+RetSQLName("SZF")+" ZF"
cQuery += " LEFT JOIN "+RetSQLName("SZE")+" ZE ON ZE_CHAPA=ZF_PATRIMO AND ZE_ROTA=ZF_ROTA AND ZE_MENSAL LIKE '"+substr(dtos(dDia),1,6)+"%' AND SUBSTRING(ZE_MENSAL,"+cvaltochar(8+day(dDia))+",1)='1' AND ZE.D_E_L_E_T_=''
cQuery += " WHERE ZF_DATA='"+dtos(dDia)+"' AND ZF_ROTA='"+cRota+"' AND ZF_PATRIMO='"+cPatrimo+"' AND ZF.D_E_L_E_T_=''"

If Select("TRBD") > 0
	TRBD->(dbCloseArea())
EndIf  
                 
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBD',.F.,.T.)   
dbSelectArea("TRBD")

If Alltrim(TRBD->ZF_ALTERAD) == "R"
	lRet := .T.
Else  
	If Substr(TRBD->ZE_TIPOPLA,1,1) == "6"
		If Empty(aList5[oList5:nAt,08]) .And. Empty(aList5[oList5:nAt,10])
			MsgAlert("Nใo foi prestado contas do patrim๔nio "+cPatrimo+", verifique","VerZF - TTFINC24")
		Else
			lRet := .T.
		EndIF
	Else			
		MsgAlert("Nใo foi prestado contas do patrim๔nio "+cPatrimo+", verifique","VerZF - TTFINC24")
	EndIf
EndIF
//esta passando com erro porque o felipe ้ irresponsavel
lRet := .T.
RestArea(aArea)

Return(lRet)      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  09/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualizando as informacoes do fundo de troco.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaZI(dDia,cPatr,nVlr,aValores,lAuditoria)

Local aArea	:=	GetArea()
Local cQuery             
Local nFdAnt	:=	0
Local nDfVnd	:=	0
Local nVenda	:=	0

cQuery := " SELECT TOP 1 ZI_FDOTRO,ZI_CNTCAS FROM "+RetSQLName("SZI")+" WHERE ZI_PATRIMO='"+cPatr+"' AND ZI_DATA<'"+dtos(dDia)+"' AND D_E_L_E_T_=''"
cQuery += " ORDER BY ZI_DATA DESC"

If Select("TRB3") > 0
	dbSelectArea("TRB3")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB3',.F.,.T.)   

DbSelectArea("TRB3")    

If TRB3->ZI_FDOTRO <> 0
	nFdAnt := TRB3->ZI_FDOTRO
EndIF

nVenda := val(TRB3->ZI_CNTCAS)

If !empty(aValores[9]) .And. !empty(aValores[13])
	If aValores[9] > 0 .And. aValores[13] > 0
		nDfVnd := aValores[9] - aValores[13]
		nDfVnd := val(substr(cvaltochar(nDfVnd),1,len(cvaltochar(ndfvnd))-2)+"."+right(cvaltochar(nDfVnd),2))
	EndIf
EndIf
			                                       
DbSelectarea("SZI")
DbSetOrder(2)
If Dbseek(xFilial( "SZI")+dtos(dDia)+cPatr )  
	nVenda := val(SZI->ZI_CNTCAS) - nVenda
	nVenda := substr(cvaltochar(nVenda),1,len(cvaltochar(nVenda))-2)+"."+right(cvaltochar(nVenda),2)
	
	Reclock("SZI",.F.)
	SZI->ZI_VLRAJU := If(lAuditoria,nFdAnt-nVlr+val(nVenda),0)
	SZI->ZI_VLRSAN := nVlr
	SZI->ZI_FDOTRO := If(lAuditoria,aValores[2],(nFdAnt+SZI->ZI_VLRTRO) + (nDfVnd-SZI->ZI_VLRSAN))
	SZI->ZI_TROSAN := aValores[26]
		
	SZI->(Msunlock())
EndIf

RestArea(aArea)

Return                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  10/28/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function POSPatr(cPat)

Local aArea	:=	GetArea()
Local cQuery
Local cRet	:=	'' 

cQuery := "SELECT ZZN_IDPDV, ZZN_NRSERI FROM "+RetSQLName("ZZN")+" WHERE ZZN_PATRIM='"+cPat+"' AND D_E_L_E_T_=''"  

If Select("TRB4") > 0
	dbSelectArea("TRB4")
	dbCloseArea()
EndIf
  
MemoWrite("TTFINC24.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB4',.F.,.T.)   

DbSelectArea("TRB4")

If !Empty(TRB4->ZZN_IDPDV)
	cRet := TRB4->ZZN_IDPDV
EndIf
            
RestArea(aArea)

Return(cRet)
         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  03/31/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Baixa de lacres utilizados e retornados                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BaixaRet(cLacre1,cLacre2,cLacre3,cPatrm)

Local aArea	:=	GetArea()
Local cQuery            
Local aAux	:=	{}
      
cQuery := "SELECT ZZO_LACRE AS LACRE,R_E_C_N_O_ AS REGISTRO FROM "+RetSQLName("ZZO")
cQuery += " WHERE ZZO_LACRE IN('"+cLacre1+"','"+cLacre2+"','"+cLacre3+"')"
cQuery += " AND ZZO_PATRIM='"+cPatrm+"'"
cQuery += " AND D_E_L_E_T_=''"                 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{TRB->LACRE,TRB->REGISTRO})
	Dbskip()
EndDo

If len(aAux) > 0
	DbSelectArea("ZZO")
	For nPs := 1 to len(aAux)
		DbGoto(aAux[nPs,02])
		Reclock("ZZO",.F.)
		ZZO->ZZO_DATRET := dDia
		ZZO->(Msunlock()) 
	Next nPs
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  03/31/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Baixa de canhotos nao utilizados e retornados ou utilizadosฑฑ
ฑฑบ          ณe deixados nas maquinas.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetornaLc(cLacre,nOpc,cPatrm)

Local aArea	:=	GetArea()
Local cQuery 
Local cReg	:=	''

cQuery := "SELECT R_E_C_N_O_ AS REGISTRO FROM "+RetSQLName("ZZO")
cQuery += " WHERE ZZO_LACRE='"+cLacre+"' AND ZZO_ROTA='"+cRota+"' AND ZZO_PATRIM='' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
      
cReg := TRB->REGISTRO

If !Empty(cReg)
	DbSelectArea("ZZO")
	Dbgoto(cReg)
	Reclock("ZZO",.F.)
	If nOpc == '1'
		ZZO->ZZO_DATRET := dDia
	Else
		ZZO->ZZO_PATRIM := cPatrm
		ZZO->ZZO_DATUTI := dDia
	EndIf
	ZZO->(Msunlock())	
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC24  บAutor  ณMicrosiga           บ Data ณ  04/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Vendas no ccartoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function consCct(cPatrm,cDe,cAte)

Local aArea	:=	GetArea()
Local nVlr  :=	0
Local cQuery

/*
cQuery := "select sum(CAST(ISNULL(lmr.PrecoCobrado,ISNULL(lmr.CreditoNominal, 0)) AS decimal) / 100) AS VLR"
cQuery += " from [.\TOKTAKE].[ccartoes4].[dbo].LogMaqRegistroMovFinanceiro lmrmf"
cQuery += " inner join [.\TOKTAKE].[ccartoes4].[dbo].LogMaqRegistro lmr on lmr.idLogMaqRegistro = lmrmf.idLogMaqRegistro"
cQuery += " inner join [.\TOKTAKE].[ccartoes4].[dbo].Patrimonio p on p.idPatrimonio = lmrmf.idPatrimonio"
cQuery += " where lmrmf.DataHora between '"+cDe+"' and '"+cAte+"'"
cQuery += " and lmrmf.CodigoEvento = 20"
cQuery += " and p.numPatrimonio='"+cPatrm+"'"
*/
cQuery := "select sum(CAST(ISNULL(lmr.PrecoCobrado,ISNULL(lmr.CreditoNominal, 0)) AS decimal) / 100) AS VLR"
cQuery += " from [ccartoes4].[dbo].LogMaqRegistroMovFinanceiro lmrmf"
cQuery += " inner join [ccartoes4].[dbo].LogMaqRegistro lmr on lmr.idLogMaqRegistro = lmrmf.idLogMaqRegistro"
cQuery += " inner join [ccartoes4].[dbo].Patrimonio p on p.idPatrimonio = lmrmf.idPatrimonio"
cQuery += " where lmrmf.DataHora between '"+cDe+"' and '"+cAte+"'"
cQuery += " and lmrmf.CodigoEvento = 20"
cQuery += " and p.numPatrimonio='"+cPatrm+"'"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
//MemoWrite("TTATFC07.SQL",cQuery)

//cQuery:= ChangeQuery(cQuery)
//DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
MPSysOpenQuery( cQuery , "TRB" )  

DbSelectArea("TRB")

If !Empty(TRB->VLR)
	nVlr := TRB->VLR
EndIf

RestArea(aAreA)

Return(nVlr)