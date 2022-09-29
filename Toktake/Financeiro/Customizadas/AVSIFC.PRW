#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ AVSIFC   ณ Autor ณAlexandre Venancio     ณ Data ณ 22/05/17 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Fluxo de caixa customizado                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AVSIFC

Local aArea		:=	GetArea()
Local aPergs    :=	{}
Local aRet		:=	{}
Local dDtDe		:=	ctod(' / / ')
Local dDtAte	:=	ctod(' / / ') 
Local cBanco	:=	''//space(TamSX3("A6_COD")[1])
Local cAgencia	:=	''//space(TamSX3("A6_AGENCIA")[1])
Local cNumCon	:=	''//space(TamSX3("A6_NUMCON")[1])
Local cFilDe	:=	space(4)
Local cFilAt	:=	space(4)

Private aOpcoes	:=	{ "1=Centro de Custo", "2=Conta Contabil", "3=Natureza Financeira" }
Private aCabec	:=	{}
Private aCampos	:=	{}                  
Private aAux	:=	{}
Private nCont	:=	0  
Private nSldIni	:=	0               
Private lToktake:= .T.  //tratamento exclusivo para o fluxo de caixa da toktake

Private oDlg1,oGrp1,oBrw2,oGrp2,oBrw1,oBtn1,oBtn2,oSay1,oSay2

Private aList1	:=	{}
Private aList2	:=	{}
Private aAnalit	:=	{}
Private aSay2B	:=	{}
Private oList1	
Private oList2
Private oFont14 := TFont():New("Courier New",,-14 ,.T.,.T. ,5,.T.,5,.T.,.F.,.T.) //Arial, Tamanho 16, Negrita e Itแlica
Private	oFont12N:= TFont():New("Verdana",12,12 ,.T.,.T. ,5,.T.,5,.T.,.F.) //Arial, Tamanho 12, Normal	

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SA2/SA6"

cBanco	:=	space(TamSX3("A6_COD")[1]) 
cBanco2 :=	space(TamSX3("A6_COD")[1]) 
//cAgencia:=	space(TamSX3("A6_AGENCIA")[1])
cNumCon	:=	space(TamSX3("A6_NUMCON")[1])
 
aAdd(aPergs ,{2,"Tipo de Agrupamento"	,"Agrupar",aOpcoes,80,".T.",.T.})	// Tipo de Importa็ใo
aAdd(aPergs ,{1,"Data De?	"			,dDtDe	  ,' / / ',"","","",70,.F.})
aAdd(aPergs ,{1,"Data Ate?	"			,dDtAte	  ,' / / ',"","","",70,.F.})
aAdd(aPergs ,{1,"Banco De	"			,cBanco   ,'',"","SA6","",70,.F.})
aAdd(aPergs ,{1,"Banco Ate	"			,cBanco2  ,'',"","SA6","",70,.F.})
//aAdd(aPergs ,{1,"Conta?	"				,cNumCon  ,'',"","","",70,.F.})
aAdd(aPergs ,{1,"Filial De?	"			,cFilDe   ,'',"","","",70,.F.})
aAdd(aPergs ,{1,"Filial Ate?"			,cFilAt   ,'',"","","",70,.F.})

If !ParamBox(aPergs ,"Filtro",aRet)
	Return
Else
	Processa({||Busca(aRet[1],aRet[2],aRet[3],aRet[4],aRet[5],aRet[6],aRet[7]),"Aguarde"})
EndIf
     
Tela(aRet[1],aRet[2],aRet[3],aRet[4],aRet[5],aRet[6],aRet[7])

RestArea(aArea)

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  05/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Tela do fluxo                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Tela(nOpica,dDat1,dDat2,cBanco,cBanco2)
 
Local cMsgCnt := ''

//Aadd(aList1,{'','','','','','','','','','','','','','','',''})
Aadd(aList2,{'','','','','','','','','','','','','','','',''})
 
If !Empty(cBanco)
    cMsgCnt := " Banco de "+cBanco+" At้ "+cBanco2+" Saldo Inicial em "+cvaltochar(dDat1)+" R$ "+Transform(nSldIni,"@E 999,999,999.99")
EndIf
	
oDlg1      := MSDialog():New( 041,047,620,1316,"Fluxo de Caixa - "+aOpcoes[val(nOpica)]+" Periodo "+cvaltochar(dDat1)+" A "+cvaltochar(dDat2)+If(!Empty(cMsgCnt),cMsgCnt,''),,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 001,004,164,624,"Sintetico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{009,008,161,620},,, oGrp1 ) 
    oList1:= 	TCBrowse():New(009,008,613,150,, aCabec,aCampos,;
                            oGrp1,,,,{|| Fhelp(oList1:nAt) },{|| Processa({||analitico(oList1:nAt),'Aguarde'})},, ,,,  ,,.F.,,.T.,,.F.,,,)
  
	oList1:SetArray(aList1) 
	QtdDias(nCont)
	
	oGrp2      := TGroup():New( 168,004,252,624,"Analitico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{176,008,268,620},,, oGrp2 ) 
    oList2:= 	TCBrowse():New(176,008,613,072,, {'Prefixo','Titulo','Parcela','Cliente','Classifica็ใo','Dia','Valor Titulo','Valor Pago'},{30,30,30,50,30,30},;
                            oGrp2,,,,{|| /*FhelpPC(oList2:nAt)*/ },{|| /*editcol(oList2:nAt,2)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aList2)
	oList2:bLine := {||{aList2[oList2:nAt,01],; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04],;
	 					 aList2[oList2:nAt,05],;
	 					 aList2[oList2:nAt,06],;
	 					 aList2[oList2:nAt,07],;
	 					 aList2[oList2:nAt,08]}}

	//oBtn1      := TButton():New( 276,008,"Op็๕es",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oMenu := TMenu():New(0,0,0,0,.T.)
	// Adiciona itens no Menu
	oTMenuIte1 := TMenuItem():New(oDlg1,"Excel (Sint้tico)",,,,{|| Processa({|| excel(),"Aguarde"})},,,,,,,,,.T.)
	
	oTMenuIte2 := TMenuItem():New(oDlg1,"Excel (Analitico)",,,,{|| Processa({|| ExcAnlit(),"Aguarde"})},,,,,,,,,.T.)
	oMenu:Add(oTMenuIte1)
	oMenu:Add(oTMenuIte2)
	// Cria botใo que sera usado no Menu
	oTButton1 := TButton():New( 256, 004, "Op็๕es",oDlg1,{||},037,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	// Define botใo no Menu
	oTButton1:SetPopupMenu(oMenu)     

	oBtn2      := TButton():New( 256,587,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
    
	oSay1      := TSay():New( 253,260,{||"Posicionamento"},oDlg1,,oFont12N,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,092,008)
	oSay2      := TSay():New( 260,250,{||""},oDlg1,,oFont14,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,332,038)
	
oDlg1:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  05/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Monta os itens do Grid de Receita e Despesas              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function QtdDias(nCont)
                  
If nCont == 21
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03],;
	 					 aList1[oList1:nAt,04],;
	 					 aList1[oList1:nAt,05],; 
	 					 aList1[oList1:nAt,06],;
	 					 aList1[oList1:nAt,07],;
	 					 aList1[oList1:nAt,08],;
	 					 aList1[oList1:nAt,09],; 
	 					 aList1[oList1:nAt,10],;
	 					 aList1[oList1:nAt,11],;
	 					 aList1[oList1:nAt,12],;
	 					 aList1[oList1:nAt,13],; 
	 					 aList1[oList1:nAt,14],;
	 					 aList1[oList1:nAt,15],;
	 					 aList1[oList1:nAt,16],;
	 					 aList1[oList1:nAt,17],; 
	 					 aList1[oList1:nAt,18],;
	 					 aList1[oList1:nAt,19],;
	 					 aList1[oList1:nAt,20],;
	 					 aList1[oList1:nAt,21],; 
	 					 aList1[oList1:nAt,22],;
	 					 aList1[oList1:nAt,23],;
	 					 aList1[oList1:nAt,24],;
	 					 aList1[oList1:nAt,25],; 
	 					 aList1[oList1:nAt,26],;
	 					 aList1[oList1:nAt,27],;
	 					 aList1[oList1:nAt,28],;
	 					 aList1[oList1:nAt,29],; 
	 					 aList1[oList1:nAt,30],;
	 					 aList1[oList1:nAt,31],;
	 					 aList1[oList1:nAt,32],;
	 					 aList1[oList1:nAt,33],;
	 					 aList1[oList1:nAt,34],; 
	 					 aList1[oList1:nAt,35],;
	 					 aList1[oList1:nAt,36],;
	 					 aList1[oList1:nAt,37],;
	 					 aList1[oList1:nAt,38],; 
	 					 aList1[oList1:nAt,39],;
	 					 aList1[oList1:nAt,40],; 
	 					 aList1[oList1:nAt,41],;
	 					 aList1[oList1:nAt,42]}}    
ElseIf nCont == 22
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03],;
	 					 aList1[oList1:nAt,04],;
	 					 aList1[oList1:nAt,05],; 
	 					 aList1[oList1:nAt,06],;
	 					 aList1[oList1:nAt,07],;
	 					 aList1[oList1:nAt,08],;
	 					 aList1[oList1:nAt,09],; 
	 					 aList1[oList1:nAt,10],;
	 					 aList1[oList1:nAt,11],;
	 					 aList1[oList1:nAt,12],;
	 					 aList1[oList1:nAt,13],; 
	 					 aList1[oList1:nAt,14],;
	 					 aList1[oList1:nAt,15],;
	 					 aList1[oList1:nAt,16],;
	 					 aList1[oList1:nAt,17],; 
	 					 aList1[oList1:nAt,18],;
	 					 aList1[oList1:nAt,19],;
	 					 aList1[oList1:nAt,20],;
	 					 aList1[oList1:nAt,21],; 
	 					 aList1[oList1:nAt,22],;
	 					 aList1[oList1:nAt,23],;
	 					 aList1[oList1:nAt,24],;
	 					 aList1[oList1:nAt,25],; 
	 					 aList1[oList1:nAt,26],;
	 					 aList1[oList1:nAt,27],;
	 					 aList1[oList1:nAt,28],;
	 					 aList1[oList1:nAt,29],; 
	 					 aList1[oList1:nAt,30],;
	 					 aList1[oList1:nAt,31],;
	 					 aList1[oList1:nAt,32],;
	 					 aList1[oList1:nAt,33],;
	 					 aList1[oList1:nAt,34],; 
	 					 aList1[oList1:nAt,35],;
	 					 aList1[oList1:nAt,36],;
	 					 aList1[oList1:nAt,37],;
	 					 aList1[oList1:nAt,38],; 
	 					 aList1[oList1:nAt,39],;
	 					 aList1[oList1:nAt,40],;
	 					 aList1[oList1:nAt,41],;
	 					 aList1[oList1:nAt,42],;
	 					 aList1[oList1:nAt,43],;
	 					 aList1[oList1:nAt,44] }}
ElseIf nCont == 23
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03],;
	 					 aList1[oList1:nAt,04],;
	 					 aList1[oList1:nAt,05],; 
	 					 aList1[oList1:nAt,06],;
	 					 aList1[oList1:nAt,07],;
	 					 aList1[oList1:nAt,08],;
	 					 aList1[oList1:nAt,09],; 
	 					 aList1[oList1:nAt,10],;
	 					 aList1[oList1:nAt,11],;
	 					 aList1[oList1:nAt,12],;
	 					 aList1[oList1:nAt,13],; 
	 					 aList1[oList1:nAt,14],;
	 					 aList1[oList1:nAt,15],;
	 					 aList1[oList1:nAt,16],;
	 					 aList1[oList1:nAt,17],; 
	 					 aList1[oList1:nAt,18],;
	 					 aList1[oList1:nAt,19],;
	 					 aList1[oList1:nAt,20],;
	 					 aList1[oList1:nAt,21],; 
	 					 aList1[oList1:nAt,22],;
	 					 aList1[oList1:nAt,23],;
	 					 aList1[oList1:nAt,24],;
	 					 aList1[oList1:nAt,25],; 
	 					 aList1[oList1:nAt,26],;
	 					 aList1[oList1:nAt,27],;
	 					 aList1[oList1:nAt,28],;
	 					 aList1[oList1:nAt,29],; 
	 					 aList1[oList1:nAt,30],;
	 					 aList1[oList1:nAt,31],;
	 					 aList1[oList1:nAt,32],;
	 					 aList1[oList1:nAt,33],;
	 					 aList1[oList1:nAt,34],; 
	 					 aList1[oList1:nAt,35],;
	 					 aList1[oList1:nAt,36],;
	 					 aList1[oList1:nAt,37],;
	 					 aList1[oList1:nAt,38],; 
	 					 aList1[oList1:nAt,39],;
	 					 aList1[oList1:nAt,40],;
	 					 aList1[oList1:nAt,41],;
	 					 aList1[oList1:nAt,42],;
	 					 aList1[oList1:nAt,43],;
	 					 aList1[oList1:nAt,44],;
	 					 aList1[oList1:nAt,45],;
	 					 aList1[oList1:nAt,46] }}

ElseIf nCont == 24
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03],;
	 					 aList1[oList1:nAt,04],;
	 					 aList1[oList1:nAt,05],; 
	 					 aList1[oList1:nAt,06],;
	 					 aList1[oList1:nAt,07],;
	 					 aList1[oList1:nAt,08],;
	 					 aList1[oList1:nAt,09],; 
	 					 aList1[oList1:nAt,10],;
	 					 aList1[oList1:nAt,11],;
	 					 aList1[oList1:nAt,12],;
	 					 aList1[oList1:nAt,13],; 
	 					 aList1[oList1:nAt,14],;
	 					 aList1[oList1:nAt,15],;
	 					 aList1[oList1:nAt,16],;
	 					 aList1[oList1:nAt,17],; 
	 					 aList1[oList1:nAt,18],;
	 					 aList1[oList1:nAt,19],;
	 					 aList1[oList1:nAt,20],;
	 					 aList1[oList1:nAt,21],; 
	 					 aList1[oList1:nAt,22],;
	 					 aList1[oList1:nAt,23],;
	 					 aList1[oList1:nAt,24],;
	 					 aList1[oList1:nAt,25],; 
	 					 aList1[oList1:nAt,26],;
	 					 aList1[oList1:nAt,27],;
	 					 aList1[oList1:nAt,28],;
	 					 aList1[oList1:nAt,29],; 
	 					 aList1[oList1:nAt,30],;
	 					 aList1[oList1:nAt,31],;
	 					 aList1[oList1:nAt,32],;
	 					 aList1[oList1:nAt,33],;
	 					 aList1[oList1:nAt,34],; 
	 					 aList1[oList1:nAt,35],;
	 					 aList1[oList1:nAt,36],;
	 					 aList1[oList1:nAt,37],;
	 					 aList1[oList1:nAt,38],; 
	 					 aList1[oList1:nAt,39],;
	 					 aList1[oList1:nAt,40],;
	 					 aList1[oList1:nAt,41],;
	 					 aList1[oList1:nAt,42],; 
	 					 aList1[oList1:nAt,43],;
	 					 aList1[oList1:nAt,44],;
	 					 aList1[oList1:nAt,45],;
	 					 aList1[oList1:nAt,46],;
	 					 aList1[oList1:nAt,47],;
	 					 aList1[oList1:nAt,48]}} 
ElseIf nCont == 25
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03],;
	 					 aList1[oList1:nAt,04],;
	 					 aList1[oList1:nAt,05],; 
	 					 aList1[oList1:nAt,06],;
	 					 aList1[oList1:nAt,07],;
	 					 aList1[oList1:nAt,08],;
	 					 aList1[oList1:nAt,09],; 
	 					 aList1[oList1:nAt,10],;
	 					 aList1[oList1:nAt,11],;
	 					 aList1[oList1:nAt,12],;
	 					 aList1[oList1:nAt,13],; 
	 					 aList1[oList1:nAt,14],;
	 					 aList1[oList1:nAt,15],;
	 					 aList1[oList1:nAt,16],;
	 					 aList1[oList1:nAt,17],; 
	 					 aList1[oList1:nAt,18],;
	 					 aList1[oList1:nAt,19],;
	 					 aList1[oList1:nAt,20],;
	 					 aList1[oList1:nAt,21],; 
	 					 aList1[oList1:nAt,22],;
	 					 aList1[oList1:nAt,23],;
	 					 aList1[oList1:nAt,24],;
	 					 aList1[oList1:nAt,25],; 
	 					 aList1[oList1:nAt,26],;
	 					 aList1[oList1:nAt,27],;
	 					 aList1[oList1:nAt,28],;
	 					 aList1[oList1:nAt,29],; 
	 					 aList1[oList1:nAt,30],;
	 					 aList1[oList1:nAt,31],;
	 					 aList1[oList1:nAt,32],;
	 					 aList1[oList1:nAt,33],;
	 					 aList1[oList1:nAt,34],; 
	 					 aList1[oList1:nAt,35],;
	 					 aList1[oList1:nAt,36],;
	 					 aList1[oList1:nAt,37],;
	 					 aList1[oList1:nAt,38],; 
	 					 aList1[oList1:nAt,39],;
	 					 aList1[oList1:nAt,40],;
	 					 aList1[oList1:nAt,41],;
	 					 aList1[oList1:nAt,42],; 
	 					 aList1[oList1:nAt,43],;
	 					 aList1[oList1:nAt,44],;
	 					 aList1[oList1:nAt,45],;
	 					 aList1[oList1:nAt,46],;
	 					 aList1[oList1:nAt,47],;
	 					 aList1[oList1:nAt,48],;
	 					 aList1[oList1:nAt,49],;
	 					 aList1[oList1:nAt,50]}}
EndIf    

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  05/22/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca itens do fluxo                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Busca(cTipAg,dDtde,dDtAt,cBco,cBco2,cFilD,cFilA)

Local aArea		:=	GetArea()  
Local aAux2		:=	{}  
Local nPosic	:=	0  
Local aAuxiliar	:=	{}   
Local aCpoDes	:=	{'CTT_DESC01','CT1_DESC01','ED_DESCRIC','CTT_CUSTO','CT1_CONTA','ED_CODIGO'}
Local aRecno	:=	{}

//nSldIni := SALDOBCO(cBco,dDtde,cBco2,cFilD,cFilA) //Posicione("SE8",1,xFilial("SE8")+cBco+cAge+cCon+dtos(dDtde),"E8_SALRECO")

/* **************************************************** /
/*
/*
/*     RECEBER
/*
/*
/* *************************************************** */
                        
//Busca pelo tipo selecionado pelo usuแrio
cQuery := "SELECT DISTINCT "+aCpoDes[val(cTipAg)]+","+aCpoDes[val(cTipAg)+3]+",E1_EMISSAO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VALOR AS VALOR,E1_CLIENTE,E1_VENCREA,E1_BAIXA,E1_SALDO,"
cQuery += " E5_DTDISPO,E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E5_VLJUROS,E5_VLMULTA,E5_VLDESCO,E5_SITUACA,E5_TIPODOC,E5.R_E_C_N_O_,A1_NREDUZ"
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SE5")+" E5 ON E5_FILIAL=E1_FILIAL AND E5_NUMERO=E1_NUM AND E5_PREFIXO=E1_PREFIXO AND E5_PARCELA=E1_PARCELA AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA AND E5.D_E_L_E_T_=''"
//cQuery += " 	AND ((E5_DATA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"') OR (E5_DTDISPO BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"')) AND E5_MOTBX='NOR' AND E5_RECPAG='R'"
cQuery += " 	AND E5_DTDISPO BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"' AND E5_MOTBX='NOR' AND E5_DTCANBX=''" // AND E5_RECPAG='R'"

If !Empty(cBco)
	cQuery += " AND E5_BANCO BETWEEN '"+cBco+"' AND '"+If(Empty(cBco2),cBco,cBco2)+"'"
EndIf                

cQuery += " LEFT JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=E1_FILORIG AND D2_DOC=E1_NUM AND D2_CLIENTE=E1_CLIENTE AND D2_LOJA=E1_LOJA AND D2.D_E_L_E_T_=''"

If val(cTipAg) == 1
	cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=D2_CCUSTO AND CTT.D_E_L_E_T_=''"
ElseIf val(cTipAg) == 2
	cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=D2_CONTA AND CT1.D_E_L_E_T_=''"
Else
    cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
EndIF

cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"

cQuery += " WHERE E1.D_E_L_E_T_='' AND (E1_BAIXA<>'' OR E1_TIPO='RA')"

cQuery += " AND E1_TIPO NOT LIKE '%-%'"
 
If !Empty(cFilD)
	cQuery += " AND E1_FILIAL BETWEEN '"+cFilD+"' AND '"+cFilA+"'"
EndIf

cQuery += " ORDER BY "+aCpoDes[val(cTipAg)+3]+",E1_EMISSAO,E5.R_E_C_N_O_  ASC"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  
       
Aadd(aCabec,'Tipo')
Aadd(aCabec,'Classifica็ใo')
Aadd(aCampos,30)
Aadd(aCampos,80)   

Aadd(aAux,'Receita')
Aadd(aAux,'')
 
For nX := 1 to day(lastday(dDtAt))  
	If day(datavalida(ctod(cvaltochar(strzero(nX,2))+"/"+cvaltochar(strzero(month(dDtAt),2))+"/"+cvaltochar(year(dDtAt))))) == nX
		Aadd(aCabec,'Proje็ใo - Dia '+cvaltochar(nX))
		Aadd(aCabec,'Realizado - Dia '+cvaltochar(nX))
		Aadd(aCampos,50)
		Aadd(aCampos,50)
		nCont++
	EndIf
Next nX


Aadd(aCabec,'Total Projeta็ใo M๊s')
Aadd(aCabec,'Total Realizado M๊s')
nCont++
nCont++

For nX := 1 to nCont*2
	Aadd(aAux2,If(nX==1,'Saldo',If(nX>2,0,'')))
Next nX

Aadd(aList1,aAux2)

aAux2 := {}

While !EOF() 

	If Ascan(aRecno,{|x| x == TRB->R_E_C_N_O_}) == 0
		Aadd(aRecno,TRB->R_E_C_N_O_)
		nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)')+cvaltochar(DAY(STOD(TRB->E5_DTDISPO)))})	
		If nPosic == 0
	
			Aadd(aAuxiliar,{'','',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
							DAY(STOD(TRB->E5_DTDISPO)),;
				   			TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO,;
				   			TRB->VALOR,&("TRB->"+aCpoDes[val(cTipAg)+3])})
				   			
			Aadd(aSay2B,{iF(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)') ,;
							&("TRB->"+aCpoDes[val(cTipAg)+3])})
		Else
	        If TRB->E5_SITUACA == "C" .OR. Alltrim(TRB->E5_TIPODOC) == 'ES'
		        aAuxiliar[nPosic,05] -= TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO
				aAuxiliar[nPosic,06] -= TRB->VALOR
	        Else
				aAuxiliar[nPosic,05] += TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO
				aAuxiliar[nPosic,06] += TRB->VALOR
			EndIF
		EndIf   
		//+If(TRB->E5_BANCO=="033",1,0)
		If TRB->E5_SITUACA != "C" .AND. Alltrim(TRB->E5_TIPODOC) != "ES"
			Aadd(aAnalit,{'',If(!Empty(Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
							STOD(TRB->E1_EMISSAO),TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,;
							TRB->VALOR,TRB->E1_CLIENTE,DAY(STOD(TRB->E5_DTDISPO)),TRB->E5_VALOR,Alltrim(TRB->A1_NREDUZ)})
		Else
			nFt := Ascan(aAnalit,{|x| x[4]+x[5]+x[6]+x[8] == TRB->E1_PREFIXO+TRB->E1_NUM+TRB->E1_PARCELA+TRB->E1_CLIENTE})
			If nFt > 0
				Adel(aAnalit,nFt)
				Asize(aAnalit,len(aAnalit)-1)
			EndIf
		EndIf
	EndIf
		                                                                                                          
	Dbskip()                                                   
	
EndDo
       
//busca lan็amentos gerados direto pelo movimento bancario a receber
cQuery := "SELECT "+aCpoDes[val(cTipAg)]+","+aCpoDes[val(cTipAg)+3]+",E5_DATA,E5_VALOR,E5_VLJUROS,E5_VLMULTA,E5_VLDESCO,E5_HISTOR FROM "+RetSQLName("SE5")+" E5"

If val(cTipAg) == 1
	cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=E5_CCC AND CTT.D_E_L_E_T_=''"
ElseIf val(cTipAg) == 2
	cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=E5_CREDITO AND CT1.D_E_L_E_T_=''"
Else
    cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E5_NATUREZ AND ED.D_E_L_E_T_=''"
EndIF

cQuery += " WHERE E5_DATA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"'"
cQuery += " AND (E5_NUMERO='' OR E5_TIPO IN('NDF','PA')) AND E5_BANCO='341'" // BETWEEN '"+cBco+"' AND '"+If(Empty(cBco2),cBco,cBco2)+"'"
cQuery += " AND E5_RECPAG='R' AND E5_MOEDA<>'TB' AND E5_TIPODOC NOT IN('AP','ES') AND E5_KEY='' AND E5.D_E_L_E_T_=''" 
cQuery += " AND E5_PREFIXO+E5_NUMERO+E5_PARCELA NOT IN(SELECT E5_PREFIXO+E5_NUMERO+E5_PARCELA FROM "+RetSQLName("SE5")
cQuery += "       WHERE E5_DATA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"' AND E5_TIPO='PA' AND E5_RECPAG='P' AND D_E_L_E_T_='')


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF() 
	nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)'+cvaltochar(DAY(STOD(TRB->E5_DATA)))})

	If nPosic == 0
		Aadd(aAuxiliar,{'','',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
								DAY(STOD(TRB->E5_DATA)),;
								TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO,TRB->E5_VALOR,&("TRB->"+aCpoDes[val(cTipAg)+3])})
														
		Aadd(aSay2B,{If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
					&("TRB->"+aCpoDes[val(cTipAg)+3])})
	Else
		aAuxiliar[nPosic,05] += TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO		
		aAuxiliar[nPosic,06] += TRB->E5_VALOR
	EndIf   
	
		Aadd(aAnalit,{'',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
						STOD(TRB->E5_DATA),'','','R',;
						TRB->E5_VALOR,'',DAY(STOD(TRB->E5_DATA)),TRB->E5_VALOR,Alltrim(TRB->E5_HISTOR)})
	Dbskip()
EndDo 

If lToktake
	//busca transferencias bancarias ocorridas para o itau - conforme regra passada pela Viviane.
	cQuery := "SELECT "+aCpoDes[val(cTipAg)]+","+aCpoDes[val(cTipAg)+3]+",E5_DATA,E5_VALOR,E5_VLJUROS,E5_VLMULTA,E5_VLDESCO,E5_HISTOR FROM "+RetSQLName("SE5")+" E5"
	
	If val(cTipAg) == 1
		cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=E5_CCC AND CTT.D_E_L_E_T_=''"
	ElseIf val(cTipAg) == 2
		cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=E5_CREDITO AND CT1.D_E_L_E_T_=''"
	Else
	    cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E5_NATUREZ AND ED.D_E_L_E_T_=''"
	EndIF
	
	cQuery += " WHERE E5_DATA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"'"
	cQuery += " AND E5_NUMERO='' AND E5_BANCO='341'" 
	cQuery += " AND E5_RECPAG='R' AND E5_MOEDA='TB' AND E5_TIPODOC<>'AP' AND E5.D_E_L_E_T_='' AND E5_HISTOR LIKE '%ROTA%'"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("AVSIINT.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF() 
		nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)'+cvaltochar(DAY(STOD(TRB->E5_DATA)))})
	
		If nPosic == 0
			Aadd(aAuxiliar,{'','',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
									DAY(STOD(TRB->E5_DATA)),;
									TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO,TRB->E5_VALOR,&("TRB->"+aCpoDes[val(cTipAg)+3])})
															
			Aadd(aSay2B,{If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
						&("TRB->"+aCpoDes[val(cTipAg)+3])})
		Else
			aAuxiliar[nPosic,05] += TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO		
			aAuxiliar[nPosic,06] += TRB->E5_VALOR
		EndIf   
		
			Aadd(aAnalit,{'',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
							STOD(TRB->E5_DATA),'','','R',;
							TRB->E5_VALOR,'',DAY(STOD(TRB->E5_DATA)),TRB->E5_VALOR,Alltrim(TRB->E5_HISTOR)})
		Dbskip()
	EndDo 
	
	If cEmpAnt == "01"
		// Busca informa็๕es de provisใo de cartao de credito e debito importados pelo conciliador SITEF (Toktake)
		cQuery := "SELECT ZZE_PRODUT AS BANDEIRA,DATEADD(DAY,CAST(ZZM_PRZDIA AS INTEGER),ZZE_DATATR) VENCTO,ZZE_DATATR,ROUND(SUM(ZZE_VLRLIQ),2) AS TOTAL"
		cQuery += " FROM "+RetSQLName("ZZE")+" ZZE"
		cQuery += " 	INNER JOIN "+RetSQLName("ZZM")+" ZZM ON ZZM_PRODUT=ZZE_PRODUT AND ZZM.D_E_L_E_T_=''"
		cQuery += " 	WHERE DATEADD(DAY,CAST(ZZM_PRZDIA AS INTEGER),ZZE_DATATR) BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"'"
		cQuery += " 	AND ZZE_ESTTRA LIKE 'EFETUAD%' AND ZZE_PRODUT<>'' AND ZZE.D_E_L_E_T_=''"
		cQuery += " 	GROUP BY ZZE_PRODUT,ZZE_DATATR,ZZM_PRZDIA"
		cQuery += " 	ORDER BY 2"
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("AVSIINT.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		
		While !EOF()
			//nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)'+cvaltochar(DAY(STOD(TRB->E5_DATA)))})
		
			//If nPosic == 0
				Aadd(aAuxiliar,{'','',Alltrim(TRB->BANDEIRA)+'(c)',;
										DAY(TRB->VENCTO),;
										0,TRB->TOTAL,''})
																
			   //	Aadd(aSay2B,{If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
				//			&("TRB->"+aCpoDes[val(cTipAg)+3])})
			/*Else
				aAuxiliar[nPosic,05] += TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO		
				aAuxiliar[nPosic,06] += TRB->E5_VALOR
			EndIf   */
			
				Aadd(aAnalit,{'',Alltrim(TRB->BANDEIRA)+'(c)',;
								TRB->VENCTO,'','','R',;
								TRB->TOTAL,'',DAY(TRB->VENCTO),TRB->TOTAL,''})
			Dbskip()
		EndDo
	EndIF 
	
EndIF
 
//Busca pelos titulos que ainda estao em carteira
cQuery := "SELECT DISTINCT "+aCpoDes[val(cTipAg)]+","+aCpoDes[val(cTipAg)+3]+",E1_EMISSAO,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VALOR AS VALOR,E1_CLIENTE,E1_VENCREA,E1_BAIXA,E1_SALDO,A1_NREDUZ"

cQuery += " FROM "+RetSQLName("SE1")+" E1"

cQuery += " LEFT JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=E1_FILORIG AND D2_DOC=E1_NUM AND D2_CLIENTE=E1_CLIENTE AND D2_LOJA=E1_LOJA AND D2.D_E_L_E_T_=''"

If val(cTipAg) == 1
	cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=D2_CCUSTO AND CTT.D_E_L_E_T_=''"
ElseIf val(cTipAg) == 2
	cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=D2_CONTA AND CT1.D_E_L_E_T_=''"
Else
    cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E1_NATUREZ AND ED.D_E_L_E_T_=''"
EndIF

cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"

cQuery += " WHERE E1.D_E_L_E_T_='' AND E1_VENCREA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"'"  

If !Empty(cFilD)
	cQuery += " AND E1_FILIAL BETWEEN '"+cFilD+"' AND '"+cFilA+"'"
EndIf

cQuery += " ORDER BY "+aCpoDes[val(cTipAg)+3]+",E1_EMISSAO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF() 
    If Ascan(aAnalit,{|x| x[4]+x[5]+x[6]+x[8] == TRB->E1_PREFIXO+TRB->E1_NUM+TRB->E1_PARCELA+TRB->E1_CLIENTE}) == 0
		nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == iF(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)')+cvaltochar(DAY(STOD(TRB->E1_VENCREA)))})	
		If nPosic == 0
	
			Aadd(aAuxiliar,{'','',iF(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
							DAY(STOD(TRB->E1_VENCREA)),;
				   			0,TRB->VALOR,&("TRB->"+aCpoDes[val(cTipAg)+3])})
				   			
			Aadd(aSay2B,{iF(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)') ,;
							&("TRB->"+aCpoDes[val(cTipAg)+3])})
		Else
	
			aAuxiliar[nPosic,05] += 0 //TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO
			aAuxiliar[nPosic,06] += TRB->VALOR
		EndIf   
		
		Aadd(aAnalit,{'',If(!Empty(Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)','Nao Classif.(c)'),;
						STOD(TRB->E1_EMISSAO),TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,;
						TRB->VALOR,TRB->E1_CLIENTE,DAY(STOD(TRB->E1_VENCREA)),0,Alltrim(TRB->A1_NREDUZ)})
	EndIF
	
	Dbskip()                                                   
	
EndDo

For nX := 1 to len(aAuxiliar)
	Aadd(aAux,aAuxiliar[nX])
Next nX

Aadd(aAux2,aAux[1])
Aadd(aAux2,'')

For nX := 3 to len(aCabec)
	If substr(aCabec[nX],1,4) == "Real"
		nsomad	:=	0		
	 	For nJ := 3 to len(aAux)
		 	If aAux[nJ,04] == val(right(acabec[nX],2))
		 		nsomad += aAux[nJ,05]
		 	EndIf
		Next nJ
		Aadd(aAux2,nsomad)
	ElseIf substr(aCabec[nX],1,4) == "Proj"
		nsoma2	:=	0		
	 	For nJ := 3 to len(aAux)
		 	If aAux[nJ,04] == val(right(acabec[nX],2))
		 		nsoma2 += aAux[nJ,06]
		 	EndIf
		Next nJ
		Aadd(aAux2,nsoma2)			
	Else
		Aadd(aAux2,0)
	EndIf                 
	
Next nX

Aadd(aList1,aAux2)
aAux2 := {}

Aadd(aAux2,'')
        
For nJ := 3 to len(aAux)
	Aadd(aAux2,aAux[nJ,03])
	For nX := 3 to len(aCabec)
		If substr(aCabec[nX],1,4) == "Real" .And. val(right(acabec[nX],2)) == aAux[nJ,04]
		 	Aadd(aAux2,aAux[nJ,5])
		Else
			Aadd(aAux2,0)
		EndIf                 
	Next nX	 
	nPos := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux2[2])})
	
	If nPos > 0
		For nX := 3 to len(aList1[nPos])
			If Empty(aList1[nPos,nX]) .And. !Empty(aAux2[nX])
				aList1[nPos,nX] := aAux2[nX]
			EndIf
		Next nX
	Else
		Aadd(aList1,aAux2)
	EndIf
	
	aAux2 := {}   
	Aadd(aAux2,'') 
	
	Aadd(aAux2,aAux[nJ,03])
	For nX := 3 to len(aCabec)
		If substr(aCabec[nX],1,4) == "Proj" .And. val(right(acabec[nX],2)) == aAux[nJ,04]
		 	Aadd(aAux2,aAux[nJ,6])
		Else
			Aadd(aAux2,0)
		EndIf                 
	Next nX	 
	nPos := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux2[2])})
	
	If nPos > 0
		For nX := 3 to len(aList1[nPos])
			If Empty(aList1[nPos,nX]) .And. !Empty(aAux2[nX])
				aList1[nPos,nX] := aAux2[nX]
			EndIf
		Next nX
	Else
		Aadd(aList1,aAux2)
	EndIf
	
	aAux2 := {}   
	Aadd(aAux2,'')

Next nJ
           
aAux2 := {}

For nX := 1 to nCont*2+2
	Aadd(aAux2,'')
Next nX

Aadd(aList1,aAux2)     


/* **************************************************** /
/*
/*
/*     PAGAR
/*
/*
/* *************************************************** */
    
cQuery := "SELECT "+If(val(cTipAg)==3,"A2_NATUREZ",aCpoDes[val(cTipAg)])+",C7_CONTA,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_DATPRF,C7_TOTAL AS TOTAL,C7_EMISSAO,C7_NUM,C7_FORNECE,E4_COND,A2_NREDUZ"
cQuery += " FROM "+RetSQLName("SC7")+" C7"

If Val(cTipAg) == 1
	cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=C7_CC AND CTT.D_E_L_E_T_=''"
ElseIf Val(cTipAg) == 2
	cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=C7_CONTA AND CT1.D_E_L_E_T_=''"
Else
    cQuery += " LEFT JOIN "+RetSQLName("SA2")+" ED ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND ED.D_E_L_E_T_=''" 
EndIf           

cQuery += " INNER JOIN "+RetSQLName("SE4")+" E4 ON E4_CODIGO=C7_COND AND LEN(E4_COND) < 3 AND E4.D_E_L_E_T_=''"
        
cQuery += " LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND A2.D_E_L_E_T_=''"

cQuery += " WHERE DATEADD(day, CAST(E4_COND AS INT), C7_DATPRF) BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"' AND C7.D_E_L_E_T_='' AND C7_QUJE<C7_QUANT"
                        //eliminar pedidos de residuo  
cQuery += " AND C7_RESIDUO <>'S'"
If !Empty(cFilD)
	cQuery += " AND C7_FILIAL BETWEEN '"+cFilD+"' AND '"+cFilA+"'"
EndIf

cQuery += " ORDER BY "+If(val(cTipAg)==3,"A2_NATUREZ","1")+",C7_DATPRF"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

aAux := {}  
aAux2:= {}    
nsomad := 0
 
Aadd(aAux,'Despesas')
Aadd(aAux,'')
 
aAuxiliar := {}

While !EOF() 
// C7_CC,CTT_DESC01,C7_CONTA,C7_QUANT,C7_QUJE,C7_RESIDUO,C7_DATPRF,SUM(C7_TOTAL) AS TOTAL
	
	nPosic := Ascan(aAuxiliar,{|x| x[3] == Alltrim(&("TRB->"+If(val(cTipAg)==3,"A2_NATUREZ",aCpoDes[val(cTipAg)])))+'(d)'+cvaltochar(DAY(datavalida(STOD(TRB->C7_DATPRF)+VAL(TRB->E4_COND))))})
	   
	If nPosic == 0
		Aadd(aAuxiliar,{'','',If(!Empty(&("TRB->"+If(val(cTipAg)==3,"A2_NATUREZ",aCpoDes[val(cTipAg)]))),Alltrim(&("TRB->"+If(val(cTipAg)==3,"A2_NATUREZ",aCpoDes[val(cTipAg)])))+'(d)','Nao Classif.(d)'),;
						DAY(datavalida(STOD(TRB->C7_DATPRF)+VAL(TRB->E4_COND))),TRB->TOTAL,''})
		Aadd(aSay2B,{If(val(cTipAg)==3,&("TRB->A2_NATUREZ"),&("TRB->"+aCpoDes[val(cTipAg)])),(If(val(cTipAg)==3,&("TRB->C7_CONTA"),aCpoDes[val(cTipAg)+3]))})
	Else
		aAuxiliar[nPosic,05] += TRB->TOTAL
	EndIf

	Aadd(aAnalit,{'',If(!Empty(&("TRB->"+If(val(cTipAg)==3,"A2_NATUREZ",aCpoDes[val(cTipAg)]))),;
					Alltrim(&("TRB->"+If(val(cTipAg)==3,"A2_NATUREZ",aCpoDes[val(cTipAg)])))+'(d)','Nao Classif.(d)'),;
					STOD(TRB->C7_EMISSAO),'Pedido Compra',TRB->C7_NUM,'',;
					TRB->TOTAL,TRB->C7_FORNECE,DAY(datavalida(STOD(TRB->C7_DATPRF)+VAL(TRB->E4_COND))),0,TRB->A2_NREDUZ})
	
	
	Dbskip()
EndDo	         

//Aadd(aAux2,aAux)
For nX := 1 to len(aAuxiliar)
	Aadd(aAux,aAuxiliar[nX])
Next nX

Aadd(aAux2,aAux[1])
Aadd(aAux2,'')

For nX := 3 to len(aCabec)
	If substr(aCabec[nX],1,4) == "Proj"
		nsomad	:=	0		
	 	For nJ := 3 to len(aAux)
		 	If aAux[nJ,04] == val(right(acabec[nX],2))
		 		nsomad += aAux[nJ,05]
		 	EndIf
		Next nJ
		Aadd(aAux2,nsomad)			
	Else
		Aadd(aAux2,0)
	EndIf                 
	
Next nX

Aadd(aList1,aAux2)
aAux2 := {}

Aadd(aAux2,'')
        
For nJ := 3 to len(aAux)
	Aadd(aAux2,aAux[nJ,03])
	For nX := 3 to len(aCabec)
		If substr(aCabec[nX],1,4) == "Proj" .And. val(right(acabec[nX],2)) == aAux[nJ,04]
		 	Aadd(aAux2,aAux[nJ,5])			
		Else
			Aadd(aAux2,0)
		EndIf                 
	Next nX	 
	nPos := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux2[2])})
	
	If nPos > 0
		For nX := 3 to len(aList1[nPos])
			If !Empty(aList1[nPos,nX]) .And. !Empty(aAux2[nX]) 
				aList1[nPos,nX] := aAux2[nX]+aList1[nPos,nX]
			ElseIf !Empty(aAux2[nX])
				aList1[nPos,nX] := aAux2[nX]
			EndIf
		Next nX
	Else
		Aadd(aList1,aAux2)
	EndIf
	
	aAux2 := {}   
	Aadd(aAux2,'')
Next nJ
           
aAux2 := {}

cQuery := "SELECT DISTINCT "+aCpoDes[val(cTipAg)]+","+aCpoDes[val(cTipAg)+3]+",E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_VALOR AS VALOR,E2_FORNECE,E2_VENCREA,E2_BAIXA,E2_SALDO"
cQuery += ",E5_DATA,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E5_VLJUROS,E5_VLMULTA,E5_VLDESCO,A2_NREDUZ,E2.R_E_C_N_O_"
cQuery += " FROM "+RetSQLName("SE2")+" E2"

cQuery += " LEFT JOIN "+RetSQLName("SE5")+" E5 ON E5_FILIAL=E2_FILIAL AND E5_NUMERO=E2_NUM AND E5_PREFIXO=E2_PREFIXO AND E5_PARCELA=E2_PARCELA AND E5_CLIFOR=E2_FORNECE AND E5_LOJA=E2_LOJA AND E5.D_E_L_E_T_=''"
cQuery += "  AND E5_NUMCHEQ='' AND E5_DATA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"' AND E5_RECPAG='P' AND E5_TIPODOC NOT IN ('DC','JR','ES') " //AND E5_MOTBX='NOR' AND E5_TIPODOC NOT IN('DC')

If !Empty(cBco)
	cQuery += " AND E5_BANCO BETWEEN '"+cBco+"' AND '"+If(Empty(cBco2),cBco,cBco2)+"'"
EndIf                

cQuery += " LEFT JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=E2_FILORIG AND D1_DOC=E2_NUM AND D1_FORNECE=E2_FORNECE AND D1_LOJA=E2_LOJA AND D1.D_E_L_E_T_=''"

If val(cTipAg) == 1
	cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=D1_CC AND CTT.D_E_L_E_T_=''"
ElseIf val(cTipAg) == 2
	cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON (CT1_CONTA=D1_CONTA OR CT1_CONTA=E2_CONTAD) AND CT1.D_E_L_E_T_=''"
Else
	cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E2_NATUREZ AND ED.D_E_L_E_T_='' "
EndIF  

cQuery += " LEFT JOIN "+RetSQLName("SA2")+" A2 ON A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND A2.D_E_L_E_T_=''"

cQuery += " WHERE E2.D_E_L_E_T_='' AND E2_BAIXA<>''" //E2_VENCREA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"' AND  

If !Empty(cFilD)
	cQuery += " AND E2_FILIAL BETWEEN '"+cFilD+"' AND '"+cFilA+"'"
EndIf

cQuery += " ORDER BY "+aCpoDes[val(cTipAg)+3]+",E2_VENCREA"
 
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

aAux := {}  
aAux2:= {}    
nsomad := 0
aAuxiliar := {}        
aRecno	:= {}

While !EOF() 
	//nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)'+cvaltochar(DAY(STOD(TRB->E2_VENCREA)))})
	If Ascan(aRecno,{|x| x == TRB->R_E_C_N_O_}) == 0
		Aadd(aRecno,TRB->R_E_C_N_O_)
		nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)'+cvaltochar(DAY(STOD(TRB->E5_DATA)))})
	
		If nPosic == 0
			Aadd(aAuxiliar,{'','',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)','Nao Classif.(d)'),;
									DAY(STOD(TRB->E5_DATA)),;
									TRB->E5_VALOR-TRB->E5_VLJUROS-TRB->E5_VLMULTA-TRB->E5_VLDESCO,TRB->VALOR,&("TRB->"+aCpoDes[val(cTipAg)+3])})
									//TRB->E2_PREFIXO,TRB->E2_NUM,TRB->E2_PARCELA})						
			Aadd(aSay2B,{If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)','Nao Classif.(d)'),;
						&("TRB->"+aCpoDes[val(cTipAg)+3])})
		Else
			aAuxiliar[nPosic,05] += TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO		
			aAuxiliar[nPosic,06] += TRB->VALOR
		EndIf   
		
		If Ascan(aAnalit,{|x| x[4]+x[5]+x[6]+x[8] == TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+'P'+TRB->E2_FORNECE}) == 0
			//D1_CC,CTT_DESC01,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_VALOR AS TOTAL,E2_FORNECE,E2_VENCREA
			Aadd(aAnalit,{'',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)','Nao Classif.(d)'),;
							STOD(TRB->E2_EMISSAO),TRB->E2_PREFIXO,TRB->E2_NUM,TRB->E2_PARCELA+'P',;
							TRB->VALOR,TRB->E2_FORNECE,DAY(STOD(TRB->E5_DATA)),TRB->E5_VALOR,TRB->A2_NREDUZ})
		Else
			aAnalit[Ascan(aAnalit,{|x| x[4]+x[5]+x[6]+x[8] == TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+'P'+TRB->E2_FORNECE}),10] += TRB->E5_VALOR
		EndIf	  
	EndIf

	Dbskip()
EndDo	         

cQuery := "SELECT "+aCpoDes[val(cTipAg)]+","+aCpoDes[val(cTipAg)+3]+",E5_DATA,E5_VALOR,E5_VLJUROS,E5_VLMULTA,E5_VLDESCO FROM "+RetSQLName("SE5")+" E5"

If val(cTipAg) == 1
	cQuery += " LEFT JOIN "+RetSQLName("CTT")+" CTT ON CTT_CUSTO=E5_CCD AND CTT.D_E_L_E_T_=''"
ElseIf val(cTipAg) == 2
	cQuery += " LEFT JOIN "+RetSQLName("CT1")+" CT1 ON CT1_CONTA=E5_DEBITO AND CT1.D_E_L_E_T_=''"
Else
    cQuery += " LEFT JOIN "+RetSQLName("SED")+" ED ON ED_CODIGO=E5_NATUREZ AND ED.D_E_L_E_T_=''"
EndIF

cQuery += " WHERE E5_DATA BETWEEN '"+dtos(dDtde)+"' AND '"+dtos(dDtAt)+"'"
cQuery += " AND E5_NUMERO='' AND E5_BANCO BETWEEN '"+cBco+"' AND '"+If(Empty(cBco2),cBco,cBco2)+"'"
cQuery += " AND E5_RECPAG='P' AND E5_MOEDA<>'TB' AND E5_TIPODOC NOT IN ('AP','ES') AND E5.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")
  
While !EOF() 
	nPosic := Ascan(aAuxiliar,{|x| Alltrim(x[3])+cvaltochar(x[4]) == Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)'+cvaltochar(DAY(STOD(TRB->E5_DATA)))})

	If nPosic == 0
		Aadd(aAuxiliar,{'','',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)','Nao Classif.(d)'),;
								DAY(STOD(TRB->E5_DATA)),;
								TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO,TRB->E5_VALOR,&("TRB->"+aCpoDes[val(cTipAg)+3])})
														
		Aadd(aSay2B,{If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)','Nao Classif.(d)'),;
					&("TRB->"+aCpoDes[val(cTipAg)+3])})
	Else
		aAuxiliar[nPosic,05] += TRB->E5_VALOR-E5_VLJUROS-E5_VLMULTA-E5_VLDESCO		
		aAuxiliar[nPosic,06] += TRB->E5_VALOR
	EndIf   
	
	//If Ascan(aAnalit,{|x| x[4]+x[5]+x[6] == TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+'P'}) == 0
		//D1_CC,CTT_DESC01,E2_EMISSAO,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_VALOR AS TOTAL,E2_FORNECE,E2_VENCREA
		Aadd(aAnalit,{'',If(!Empty(&("TRB->"+aCpoDes[val(cTipAg)])),Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(d)','Nao Classif.(d)'),;
						STOD(TRB->E5_DATA),'','',''+'P',;
						TRB->E5_VALOR,'',DAY(STOD(TRB->E5_DATA)),TRB->E5_VALOR,''})
	/*Else
		aAnalit[Ascan(aAnalit,{|x| x[4]+x[5]+x[6] == TRB->E2_PREFIXO+TRB->E2_NUM+TRB->E2_PARCELA+'P'}),10] += TRB->E5_VALOR
	EndIf	*/

	Dbskip()
EndDo

For nX := 1 to len(aAuxiliar)
	Aadd(aAux,aAuxiliar[nX])
Next nX

Aadd(aAux2,'Despesas')
Aadd(aAux2,'')

For nX := 3 to len(aCabec)
	If substr(aCabec[nX],1,4) == "Real"
		nsomad	:=	0		
		AEval(aAux,{|x| nsomad += If(x[4]==val(right(acabec[nX],2)),x[5],0)})
		Aadd(aAux2,nsomad)
	ElseIf substr(aCabec[nX],1,4) == "Proj"
		nsoma2	:=	0 //aqui		
		AEval(aAux,{|x| nsoma2 += If(x[4]==val(right(acabec[nX],2)),x[6],0)})
		Aadd(aAux2,nsoma2)	
	Else
		Aadd(aAux2,0)
	EndIf                 
	
Next nX
                         
nPos := Ascan(aList1,{|x| x[1] == aAux2[1]})

If nPos > 0
	For nX := 3 to len(aAux2)
		aList1[nPos,nX] := aList1[nPos,nX] + aAux2[nX]
	Next nX
Else
	Aadd(aList1,aAux2)
EndIf

aAux2 := {}
//Aadd(aAux2,'Despesas')
Aadd(aAux2,'')
        
For nJ := 1 to len(aAux)
	Aadd(aAux2,aAux[nJ,03])
	For nX := 3 to len(aCabec)
		If substr(aCabec[nX],1,4) == "Real" .And. val(right(acabec[nX],2)) == aAux[nJ,04]
		 	Aadd(aAux2,aAux[nJ,5])
		Else
			Aadd(aAux2,'')
		EndIf                 
	Next nX	 
	nPos := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux2[2])})
	
	If nPos > 0
		For nX := 3 to len(aList1[nPos])
			If !Empty(aList1[nPos,nX]) .And. !Empty(aAux2[nX]) 
				aList1[nPos,nX] := aList1[nPos,nX] + aAux2[nX]
			ElseIf !Empty(aAux2[nX])
				aList1[nPos,nX] := aAux2[nX]
			EndIf
		Next nX
	Else
		Aadd(aList1,aAux2)
	EndIf
	
	aAux2 := {}   
	Aadd(aAux2,'')
	Aadd(aAux2,aAux[nJ,03])
	For nX := 3 to len(aCabec)
		If substr(aCabec[nX],1,4) == "Proj" .And. val(right(acabec[nX],2)) == aAux[nJ,04]
		 	Aadd(aAux2,aAux[nJ,6])
		Else
			Aadd(aAux2,0)
		EndIf                 
	Next nX	 
	nPos := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux2[2])})
	
	If nPos > 0
		For nX := 3 to len(aList1[nPos])
			If !Empty(aList1[nPos,nX]) .And. !Empty(aAux2[nX]) 
				aList1[nPos,nX] := aList1[nPos,nX] + aAux2[nX]
			ElseIf !Empty(aAux2[nX])
				aList1[nPos,nX] := aAux2[nX]
			EndIf
		Next nX
	Else
		Aadd(aList1,aAux2)
	EndIf
	
	aAux2 := {}   
	Aadd(aAux2,'')
Next nJ
           
aAux2 := {}

For nX := 1 to nCont*2+2
	Aadd(aAux2,'')
Next nX

Aadd(aList1,aAux2) 

npos1 := Ascan(aList1,{|x| Alltrim(x[1]) == "Receita"})
npos2 := Ascan(aList1,{|x| Alltrim(x[1]) == "Despesas"})

//voltando o saldo para pegar o primeiro e somar os demais
nSldIni := SALDOBCO(cBco,dDtde,cBco2,cFilD,cFilA)
aList1[1,2] := nSldIni 
//aList1[1,4] := nSldIni 
nSaldo1 := nSldIni
nSaldo2 := nSldIni
	                                                  
//For nX := 2 to len(aList1) //dDtAt
	//cDia  := datavalida(nOff)
	//cDia2 := day(cDia)
	//Buscar o saldo dia a dia
	//nSldIni := SALDOBCO(cBco,cDia,cBco2,cFilD,cFilA)
	//aList1[1,3] := nSldIni
	//saldo inicial
	For nX := 3 to len(aList1[1])
		//aList1[1,nX] := If(nX>3,aList1[1,nX-1],0) + aList1[1,nX] + aList1[npos1,nX] - aList1[npos2,nX]
		If nX % 2 == 0             
			aList1[1,nX] := nSaldo2 + aList1[npos1,nX] - aList1[npos2,nX]
			nSaldo2 := aList1[1,nX]
		Else
			aList1[1,nX] := nSaldo1 + aList1[npos1,nX] - aList1[npos2,nX]
			nSaldo1   := aList1[1,nX]
		EndIf
	Next nX 
	
	aList1[1,2] := Transform(aList1[1,2],"@E 999,999,999.99") 
	/*
	For nX := 1 to len(aCabec)
		If Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Proj"+cvaltochar(cDia2)}) > 0
			aList1[1,Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Proj"+cvaltochar(cDia2)})] := nSldIni + aList1[npos1,Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Proj"+cvaltochar(cDia2)})] - aList1[npos2,Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Proj"+cvaltochar(cDia2)})]
		    aList1[1,Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Real"+cvaltochar(cDia2)})] := nSldIni + aList1[npos1,Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Real"+cvaltochar(cDia2)})] - aList1[npos2,Ascan(aCabec,{|x| substr(x,1,4)+cvaltochar(val(right(x,2))) == "Real"+cvaltochar(cDia2)})]
			exit
		EndIf
	Next nX*/
//Next nX  

//Totalizando por linha
For nX := 2 to len(aList1)         
	aList1[nX,len(aList1[nX])-1] := 0
	aList1[nX,len(aList1[nX])] := 0
	For nJ := 1 to len(aCabec)-2
		If substr(aCabec[nJ],1,4) == "Proj"
			aList1[nX,len(aList1[nX])-1] += 	If(valtype(aList1[nX,nJ]) == "N",aList1[nX,nJ],0)
		ElseIf substr(aCabec[nJ],1,4) == "Real"
			aList1[nX,len(aList1[nX])] += 	If(valtype(aList1[nX,nJ]) == "N",aList1[nX,nJ],0)
		EndIf  
	Next nJ 
	aList1[nX,len(aList1[nX])-1] := Transform(aList1[nX,len(aList1[nX])-1],"@E 999,999,999.99")
	aList1[nX,len(aList1[nX])] := Transform(aList1[nX,len(aList1[nX])],"@E 999,999,999.99")
Next nX

For nX := 1 to len(aList1)        
	For nJ := 3 to len(aList1[nX])-2
		If !Empty(aList1[nX,nJ])
			aList1[nX,nJ] := Transform(aList1[nX,nJ],"@E 999,999,999.99")   
		EndIf
	Next nJ
Next nX
 



RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  05/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta Analitica dos itens do fluxo de caixa.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function analitico(linha)

Local aArea		:=	GetArea()
Local nPosCol	:=	oList1:nColPos		      
 
aList2 := {}

For nX := 1 to len(aAnalit)
	If aList1[Linha,01] == 'Receita'
		If '(c)' $ aAnalit[nX,02]
			Aadd(aList2,{aAnalit[nX,04],aAnalit[nX,05],aAnalit[nX,06],;
								aAnalit[nX,11],;
								aAnalit[nX,02],cvaltochar(aAnalit[nX,09]),Transform(aAnalit[nX,07],"@E 999,999,999.99"),;
								Transform(aAnalit[nX,10],"@E 999,999,999.99")})
		EndIF
	ElseIf aList1[Linha,01] == 'Despesas'
		If '(d)' $ aAnalit[nX,02]
			Aadd(aList2,{aAnalit[nX,04],aAnalit[nX,05],aAnalit[nX,06],;
								aAnalit[nX,11],;
								aAnalit[nX,02],cvaltochar(aAnalit[nX,09]),Transform(aAnalit[nX,07],"@E 999,999,999.99"),;
								Transform(aAnalit[nX,10],"@E 999,999,999.99")})
		EndIF
	Else
		If aAnalit[nX,02] == aList1[linha,02] .And. cvaltochar(aAnalit[nX,09]) == cvaltochar(val(right(acabec[nposcol],2)))
			Aadd(aList2,{aAnalit[nX,04],aAnalit[nX,05],aAnalit[nX,06],;
							aAnalit[nX,11],;
							aAnalit[nX,02],cvaltochar(aAnalit[nX,09]),Transform(aAnalit[nX,07],"@E 999,999,999.99"),;
							Transform(aAnalit[nX,10],"@E 999,999,999.99")})
		EndIf 
	EndIf
Next nX

If len(aList2) < 1
	Aadd(aList2,{'','','','','','','','','','','','','','',''})
EndIf

oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,01],; 
 					 aList2[oList2:nAt,02],;
 					 aList2[oList2:nAt,03],;
 					 aList2[oList2:nAt,04],;
 					 aList2[oList2:nAt,05],;
 					 aList2[oList2:nAt,06],;
 					 aList2[oList2:nAt,07],;
 					 aList2[oList2:nAt,08]}}
oList2:refresh()
oDlg1:refresh()
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  05/30/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Exportar o fluxo para o excel.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Excel()

Local aArea	:=	GetArea()
    
//MsgAlert("Botใo desabilitado")
DlgToExcel({{"ARRAY",'Fluxo de Caixa',aCabec,aList1}})

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  06/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca o saldo bancario de acordo com a primeira data      บฑฑ
ฑฑบ          ณselecionada.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SALDOBCO(cBco,dDtini,cBco2,cFilD,cFilA) 

Local aArea	:=	GetArea()
Local nRet	:=	0
Local aSaldo:=	{}

cQuery := "SELECT E8_SALATUA,E8_BANCO,E8_AGENCIA,E8_CONTA,E8_DTSALAT FROM "+RetSQLName("SE8")
cQuery += " WHERE E8_FILIAL BETWEEN '"+substr(cFilD,1,2)+"' AND '"+substr(cFilA,1,2)+"' AND E8_BANCO BETWEEN '"+cBco+"' AND '"+If(Empty(cBco2),cBco,cBco2)+"'"
//cQuery += " AND E8_DTSALAT BETWEEN '"+dtos(dDtini-12)+"' AND '"+dtos(dDtini)+"' AND D_E_L_E_T_=''"
cQuery += " AND E8_DTSALAT BETWEEN '"+dtos(dDtini-12)+"' AND '"+dtos(datavalida(dDtini-1,.F.))+"' AND D_E_L_E_T_=''"
cQuery += " ORDER BY E8_DTSALAT DESC"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
	If Ascan(aSaldo,{|x| x[1]+x[2]+x[3] == TRB->E8_BANCO+TRB->E8_AGENCIA+TRB->E8_CONTA}) == 0
		Aadd(aSaldo,{TRB->E8_BANCO,TRB->E8_AGENCIA,TRB->E8_CONTA,TRB->E8_SALATUA})
	EndIf
	DbSkip()
EndDo

Aeval(aSaldo,{|x| nRet += x[4]})

cQuery := "SELECT SUM(E5_VALOR ) AS RESGATE"
cQuery += " FROM "+RetSQLName("SE5")
cQuery += " WHERE E5_DATA='"+dtos(dDtini)+"'"
cQuery += " AND E5_NATUREZ IN(SELECT ED_CODIGO FROM "+RetSQLName("SED")+" WHERE ED_DESCRIC LIKE 'RESGATE%' AND D_E_L_E_T_='')"
cQuery += " AND D_E_L_E_T_=''"


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

If TRB->RESGATE > 0
	nRet += TRB->RESGATE
EndIf

/*
cQuery := "SELECT SUM(EH_VALOR-EH_VALREG) AS APLIC FROM "+RetSQLName("SEH")
cQuery += " WHERE EH_APLEMP='APL' AND EH_TIPO='CDI' AND EH_ULTPGIR BETWEEN '"+dtos(ddtini-4)+"' AND '"+dtos(dDtini-1)+"' AND D_E_L_E_T_=''"
//cQuery += " GROUP BY EH_BANCO"                             

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("AVSIINT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  
            
aSaldo := {}
/*
While !EOF()
	If Ascan(aSaldo,{|x| x[1] == TRB->EH_BANCO}) == 0
		Aadd(aSaldo,{TRB->EH_BANCO,TRB->APLIC})
	EndIf
	DbSkip()
EndDo

Aeval(aSaldo,{|x| nRet += x[2]}) 

nRet += TRB->APLIC               */
 
RestArea(aArea)
                                                                      
Return(nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  06/08/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Posicionamento da linha e coluna                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fhelp(nLinha)      

Local aArea	:=	GetArea()
Local nCol	:=	oList1:ncolpos

If nCol == 0
	nCol := 1
EndIf

cMsg :=  "Linha "+cvaltochar(nlinha)+" - Coluna "+aCabec[nCol]+chr(13)+chr(10)

If !Empty(aList1[nLinha,01])
	cMsg += aList1[nLinha,01]
Else        
	nPosicao := Ascan(aSay2B,{|x| x[1] == aList1[nLinha,02]})  
	If nPosicao > 0
		cMsg +=	aSay2B[nPosicao,02]+" - "+aList1[nLinha,02]
	Else
		cMsg +=	aList1[nLinha,02]
	EndIf
EndIf

oSay2:settext("")
oSay2:settext(cMsg)

oDlg1:refresh()     

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAVSIFC    บAutor  ณMicrosiga           บ Data ณ  06/29/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Excel analitico                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExcAnlit()

Local oExcel 	:= FWMSEXCEL():New()
Local cTitulo 	:= "Demonstrativo"  
Local cArqXls   := "Fluxo_Cx_"+dtos(dDatabase)+cvaltochar(strtran(time(),":"))+".xls"

cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
      
If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Fluxo_de_Caixa") 

oExcel:AddTable ("Fluxo_de_Caixa","Analitico")
                                                            
//		Aadd(aAnalit,{'',Alltrim(&("TRB->"+aCpoDes[val(cTipAg)]))+'(c)',STOD(TRB->E1_EMISSAO),TRB->E1_PREFIXO,TRB->E1_NUM,TRB->E1_PARCELA,;
//						TRB->VALOR,TRB->E1_CLIENTE,DAY(STOD(TRB->E5_DTDISPO)),TRB->E5_VALOR,TRB->A1_NREDUZ})

oExcel:AddColumn("Fluxo_de_Caixa","Analitico","",1,1)
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Descri็ใo",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Emissใo",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Prefixo",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Titulo",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Parcela",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Valor",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Codigo_Cliente",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Data_Recebimento",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Valor_Recebido",1,1) 
oExcel:AddColumn("Fluxo_de_Caixa","Analitico","Cliente",1,1) 

For nX := 1 to len(aAnalit)
	oExcel:AddRow("Fluxo_de_Caixa","Analitico",{aAnalit[nX,01],;
												aAnalit[nX,02],;
												aAnalit[nX,03],;
												aAnalit[nX,04],;
												aAnalit[nX,05],;
												aAnalit[nX,06],;
												aAnalit[nX,07],;
												aAnalit[nX,08],;
												aAnalit[nX,09],;
												aAnalit[nX,10],;
												aAnalit[nX,11]})  
Next nX 

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

//If File(cDir +cArqXls)
	oExcelApp := MsExcel():New()
	oExcelApp:Destroy()
//EndIf

Return