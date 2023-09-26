#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"    
#INCLUDE "TBICONN.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "fileio.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ CONFSC01 ณ Autor ณ Alexandre Venancio    ณ Data ณ 10/10/22 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ   Rotina de faturamento e historico.                       ณฑฑ
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

User Function CONFSC01

Local aPergs	:=	{}
Local aRet		:=	{}
Local cCond		:=	space(3)
Local nCont 
Local nJ 

Private cPeri		:=	space(4)
Private cCont1		:=	space(15)
Private cCont2		:=	'ZZZZZZZZZZZZZZZ'
Private cCli1		:=	space(9)
Private cCli2		:=	'ZZZZZZZZZ'
Private cTpCnt		:=	space(3)

Private oDlg1,oGrp1,oGrp2,oSay1,oSay2,oSay6,oGrp3,oBrw1
Private oGrp5,oBrw3,oBtn1,oMenu,oGrp6,oSay3,oSay4,oSay5
Private oList,oList2,oList3,oList4,oList5,oGrp4,oSay7,oSay8,oSay9
Private aList	:=	{}
Private aList2	:=	{}
Private aList3	:=	{} 
Private aList4	:=	{}
Private aList5 	:=	{} 
Private aHead   := 	{}

Private aListb	:=	{}
Private aList2b	:=	{}
Private aList3b	:=	{} 
Private aList4b	:=	{} 
Private aList5b	:=	{}
 
Private oFont1 := TFont():New('Arial',,-15,.T.)
Private oFont2 := TFont():New('Arial',,-12,.T.)
Private oFont3 := TFont():New('Verdana',,-12,.T.)
Private oFont4 := TFont():New('Arial',,-16,.T.)

Private oSpv   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oFat   	:= LoadBitmap(GetResources(),'br_vermelho')    
Private oPvg   	:= LoadBitmap(GetResources(),'br_amarelo')    

Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    

Private aTabPrc :=	{}
Private cQuinze	:=	""
Private cLocacS	:=	""

Private aAbater	:=	{}

Private lLiberaF:=	.F.

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF
        
oFont4:Bold := .T.
 
/*                             
alist                                               aList2b							aList3b            		aList4b

1 - N๚mero do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descri็ใo					2 - Data Emissao		2 - Desricao
3 - C๓digo Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endere็o Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condi็ใo de Pagamento                                                                                   9 - Quantidade
10- Descricao da condicao
11- Inicio Vigencia
12- Fim Vigencia
13- Email Cliente 
14- Inicio Multa
15- Prazo
16- Percentual Multa
17- Renovacao Automatica
*/                    

aQtdH := {'Numero_Contrato',;
			'Valor_Mensal',;
			'Codigo_Cliente',;
			'Loja_Cliente',;
			'Nome',;
			'Endereco',;
			'Bairro',;
			'Cidade',;
			'Condicao',;
			'Descricao_cond',;
			'Inicio_vig',;
			'Fim_vig',;
			'Email_Cliente',;
			'Inicio_Multa',;
			'Prazo',;
			'Perc_Multa',;
			'Renovacao'}
 
aAdd( aPergs ,{1,"Data de Faturamento : "		,cCond	,"@!",'.T.',"SE4",'.T.',40,.F.})  
aAdd( aPergs ,{1,"Perํodo Faturamento 'MMAA' : ",cPeri	,"@E 9999",'.T.',"",'.T.',40,.F.})  
aAdd( aPergs ,{2,"Faturamento Quinzenal?"		," "	,{" ","1=Primeira","2=Segunda"},080,'',.T.})
aAdd( aPergs ,{1,"Contrato de : "				,cCont1	,"@!",'.T.',"AAM",'.T.',80,.F.})  
aAdd( aPergs ,{1,"Contrato Ate: "				,cCont2	,"@!",'.T.',"AAM",'.T.',80,.F.})  
aAdd( aPergs ,{1,"Cliente de : " 				,cCli1	,"@!",'.T.',"SA1",'.T.',60,.F.})  
aAdd( aPergs ,{1,"Cliente Ate: " 				,cCli2	,"@!",'.T.',"SA1",'.T.',60,.F.})  
aAdd( aPergs ,{1,"Tipo Contrato:"				,cTpCnt	,"@!",'.T.',"A7",'.T.',40,.F.})  
aAdd( aPergs ,{2,"Somente Loca็๕es?"			,"1"	,{"1=Nใo","2=Sim"},080,'',.T.})

		
If !ParamBox(aPergs ,"Parametros ",aRet)
	Return
Else
	cCond 	:= aRet[1]
	cPeri 	:= aRet[2]
	cQuinze := aRet[3]
	cCont1	:= iF(!empty(aRet[4]),strzero(val(aRet[4]),15),aRet[4])
	cCont2	:= If(!empty(aRet[5]) .and. !'Z' $ aRet[5],strzero(val(aRet[5]),15),aRet[5])
	cCli1	:= aRet[6]
	cCli2	:= aRet[7]
	cTpCnt	:= aRet[8]
	cLocacS := aRet[9]
EndIf

Processa( { || Busca(cCond,cQuinze,cLocacS),"Aguarde"})

Aadd(aList2,{'','',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
Aadd(aList3,{'','',0})
Aadd(aList4,{'','',0})
Aadd(aList5,{'','','','',0,'',0,0,0,0,'','','',''})

If len(aList) > 0
	oDlg1      := MSDialog():New( 092,232,770,1672,"Hist๓rico de Faturamentos",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 002,004,336,710,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oGrp2      := TGroup():New( 008,008,072,612,"Dados do Cliente",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			
			oSay9      := TSay():New( 013,250,{||"Quantidade de contratos selecionados " +cvaltochar(len(aList))},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,552,008)
		
			oSay1      := TSay():New( 024,012,{||"Cliente"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,032,008)
			oSay2      := TSay():New( 024,052,{||"oSay2"},oGrp2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,492,016)
			oSay3      := TSay():New( 040,012,{||"Endere็o"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay4      := TSay():New( 040,052,{||"oSay4"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,392,008)
			oSay5      := TSay():New( 052,012,{||"Contrato"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay6      := TSay():New( 052,052,{||"oSay6"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,552,008)
			oSay7      := TSay():New( 062,360,{||"Valor Excedente"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,552,008)
			oSay8      := TSay():New( 062,052,{||"Parโmetros selecionados / Data Fat. "+cCond+" / Periodo "+cPeri+" / Quinzena "+cQuinze},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,552,008)
		
		oGrp3      := TGroup():New( 076,008,332,170,"Contratos",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

			oList 	   := TCBrowse():New(084,010,158,245,, {'','Contrato','Vlr Faturamento'},{5,90,30},;
									oGrp3,,,,{|| FHelp(oList:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
			oList:SetArray(aList)
			oList:bLine := {||{If(aList[oList:nAt,len(aQtdH)+1]==0,oSpv,(If(aList[oList:nAt,len(aQtdH)+1]==1,oPvg,oFat))),;
								substr(aList[oList:nAt,05],at("/ ",aList[oList:nAt,05])+2),; 
								Transform(aList[oList:nAt,02],"@E 999,999,999.99")}}
		//
		//oTBitmap := TBitmap():New(220,010,110,010,,"\_AMC\Legendas.bmp",.T.,oGrp3, {||alert('teste')},,.F.,.F.,,,.F.,,.T.,,.F.)
									
		oGrp4      := TGroup():New( 076,172,202,516,"Ativos",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

			oList2 	   := TCBrowse():New(084,174,337,115,,;
			{'Ativo','Modelo','Vlr Loca็ใo','Qtd. Min.','Valor Min.','Qtd.Total','Vlr.Fat.','Vlr.Compl.'},;
			{30,40,40,40,40,40,40,40},;
					oGrp4,,,,{|| FHelp3(oList2:nAt,oList:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		
			oList2:SetArray(aList2)
			oList2:bLine := {||{ Alltrim(aList2[oList2:nAt,01]),;
								Alltrim(aList2[oList2:nAt,02]),;
								If(aList2[oList2:nAt,03]>1,Transform(aList2[oList2:nAt,03],"@E 999,999,999.99"),'Isento'),;
								If(aList2[oList2:nAt,07]>0,Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),'S/ Min.Qtd.'),;
								If(aList2[oList2:nAt,08]>0,Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),'S/ Vlr.Min.'),;
								If(aList2[oList2:nAt,09]>0,Transform(aList2[oList2:nAt,09],"@E 999,999,999.99"),'S/Qtd'),;
								If(aList2[oList2:nAt,10]>0,Transform(aList2[oList2:nAt,10],"@E 999,999,999.99"),'S/Vlr'),;
								aList2[oList2:nAt,11]}}
		
		oGrp7      := TGroup():New( 202,172,332,708,"Consumo",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
											//290 118
			oList5 	   := TCBrowse():New(209,174,532,118,, {'Sele็ใo','Produto','Descri็ใo','Data Ant.','Leit.Ant.','Data Atual','Leit.Atual','Consumo','Valor Un.','Valor Fat.','Penult.Data','Penult.Leit'},{30,40,70,30,30,30,30,30,30,30,30,30},;
									oGrp7,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, oFont2,,,  ,,.F.,,.T.,,.F.,,,)
			
			oList5:SetArray(aList5)
			oList5:bLine := {||{Alltrim(aList5[oList5:nAt,01]),;
								Alltrim(aList5[oList5:nAt,02]),;
								Alltrim(aList5[oList5:nAt,03]),;
								STOD(aList5[oList5:nAt,04]),;
								aList5[oList5:nAt,05],;
								STOD(aList5[oList5:nAt,06]),;
								aList5[oList5:nAt,07],;
								If(aList5[oList5:nAt,08]<>0,aList5[oList5:nAt,08],'Sem Consumo'),;
								Transform(aList5[oList5:nAt,09],"@E 999,999,999.99"),;
								Transform(aList5[oList5:nAt,10],"@E 999,999,999.99"),;
								stod(aList5[oList5:nAt,13]),;
								aList5[oList5:nAt,14]}}

		oGrp5      := TGroup():New( 076,520,202,708,"Faturamento",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

			oList3 	   := TCBrowse():New(084,524,182,115,, {'Pedido','Emissใo','Nota','Vlr Faturamento'},{30,40,40},;
									oGrp5,,,,{|| FHelp2(oList3:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
			oList3:SetArray(aList3)
			oList3:bLine := {||{ Alltrim(aList3[oList3:nAt,01]),;
								aList3[oList3:nAt,02],;
								aList3[oList3:nAt,04],;
								Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}
		
		Processa({|| atugrid()},"Atualizando totais")

		For nCont := 1 to len(aList)
			nPos := Ascan(aList5B,{|x| x[1] == aList[nCont,01]})
			If nPos > 0 
				If len(aList5B[nPos]) > 4
					For nJ := 5 to len(aList5B[nPos])
						If aList5B[nPos,nJ,12] == "S"
							aList[nCont,18] := 2
							exit
						EndIf 
					Next nJ 
				EndIf
			EndIf 
		Next nCont

		oList:nAt := 1
		oList2:nAt := 1
		oList:refresh()
		oList2:refresh()

	oBtn1      := TButton():New( 055,640,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

	//Bot๕es diversos
	oMenu := TMenu():New(0,0,0,0,.T.)
	// Adiciona itens no Menu
	oTMenuIte1 := TMenuItem():New(oDlg1,"Procurar",,,,{|| procurar()},,,,,,,,,.T.)
	oTMenuIte2 := TMenuItem():New(oDlg1,"Listar-Faturamento",,,,{|| Processa({||PreFat(),"Aguarde"})} ,,,,,,,,,.T.)
	oTMenuIte3 := TMenuItem():New(oDlg1,"Faturar",,,,{|| Processa({||GeraPv(0),"Aguarde"})} ,,,,,,,,,.T.)
	oTMenuIte4 := TMenuItem():New(oDlg1,"Envio NF/Boleto",,,,{|| NFBol(1)} ,,,,,,,,,.T.)
	oTMenuIte7 := TMenuItem():New(oDlg1,"Impressoes",,,,{|| Processa({||U_CONFSR02(oSay6:cTitle,.F.),"Aguarde"})} ,,,,,,,,,.T.)


	oMenu:Add(oTMenuIte1)
	oMenu:Add(oTMenuIte2)
	oMenu:Add(oTMenuIte3)
	oMenu:Add(oTMenuIte4)
	oMenu:Add(oTMenuIte7)

	// Cria botใo que sera usado no Menu  
	oTButton1 := TButton():New( 025, 640, "Op็๕es",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	// Define botใo no Menu
	oTButton1:SetPopupMenu(oMenu)

	//ao clicar com o botใo direito no grid de ativos.
		MENU oMenuP POPUP 
		MENUITEM "Faturar" ACTION (Processa({|| GeraPv(1)},"Aguarde"))
		MENUITEM "Localizar" ACTION (Processa({|| Localiza()},"Aguarde"))
		MENUITEM "Liberados p/ Faturar" ACTION (Processa({|| ValFat()},"Aguarde"))
		ENDMENU                                                                           

		oList:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }

	//ao clicar com o botใo direito no grid de faturamentos.
		MENU oMenuP3 POPUP 
		MENUITEM "Itens Pedido" ACTION (Processa({|| ItensPv(aList3[oList3:nAt,01],aList3[oList3:nAt,04])},"Aguarde"))
		MENUITEM "Estornar Faturamento" ACTION (Processa({|| estorfat(aList3[oList3:nAt,01],aList3[oList3:nAt,04])},"Aguarde"))
		MENUITEM "Imprimir Leitura" ACTION (Processa({||U_CONFSR02(oSay6:cTitle,.T.,aList3[oList3:nAt,01]),"Aguarde"}))

		ENDMENU                                                                           

		oList3:bRClicked := { |oObject,nX,nY| oMenuP3:Activate( nX, (nY-10), oObject ) }

	oDlg1:Activate(,,,.T.)
else 
	MsgAlert("Nใo encontrados contratos que atendam ao filtro selecionado")
EndIf

//Reset Environment

Return                                

/*/{Protheus.doc} atugrid
	(long_description)
	@type  Static Function
	@author user
	@since 05/01/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function atugrid()

Local nCont := 0

For nCont := 1 to len(aList)
	oList:nAt := nCont
	Fhelp(nCont)
Next nCont

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca os contratos e historicos de faturamentos existentesบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Busca(cCond,cQuinze,cLocacS)

	Local aArea		:=	GetArea()
	Local cQuery   
	Local nPos1		:=	0
	Local nPos3		:=	0           
	Local aAux3		:=	{} 
	Local nNewVlr	:=	0
	Local nDiasMs	:=	day(lastday(ddatabase))
	Local nCont 
	Local aAux5		:=	{}
	Local nAux		:=	0
	Local cCntTab	:=	""
	Local cBarra 	:=	""
	Local nLeitur	:=	0
	Local nX     	:=	0

	cQuery := "SELECT AAN_CONTRT,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,"
	cQuery += " B1_DESC,AAN_XCBASE,AAN_QUANT,AAN_ULTEMI,"
	cQuery += " AAN_XMINQT,AAN_XVLRMI,"
	cQuery += " AAN_VLRUNI,AAN_INICOB,AAN_FIMCOB,AAN_CONPAG,"
	cQuery += " E4_COND,E4_DESCRI,A1_NREDUZ,A1_NOME,A1_END,"
	cQuery += " A1_BAIRRO,A1_MUN,A1_EST,"
	cQuery += " AAM_INIVIG,AAM_FIMVIG,A1_EMAIL,'' AS AAN_XISENT,"
	cQuery += " AAM_XFORFA, AAM_XTIPFA,'' AS AAM_XPERCT,"
	cQuery += " '' AS AAM_XRENOV,AAN_FILIAL,AAM_XPRDCM,AAM_XPOCLI"
	cQuery += " FROM "+RetSQLName("AAN")+" AAN"
	cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT AND AAM.D_E_L_E_T_=' ' AND AAM_STATUS='1'"
	cQuery += " INNER JOIN "+RetSQLName("SE4")+" E4 ON E4_FILIAL='"+xFilial("SE4")+"' AND E4_CODIGO=AAN_CONPAG AND E4.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=AAN_CODPRO AND B1_XCARACT<>'D' AND B1.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN "+RetSQLName("Z01")+" Z01 ON Z01_FILIAL='"+xFilial("Z01")+"' AND Z01_CODIGO=B1_XTIPOCN AND Z01_DESCRI NOT LIKE 'GAB%' AND Z01.D_E_L_E_T_=' '"
	cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"' AND AAN.D_E_L_E_T_=''" 

	If !Empty(cCond)
		cQuery += " AND AAN_CONPAG='"+cCond+"'" 
	EndIf

	cQuery += " AND AAM_CONTRT BETWEEN '"+cCont1+"' AND '"+cCont2+"'"
	cQuery += " AND AAM_CODCLI BETWEEN '"+cCli1+"' AND '"+cCli2+"'"

	If !Empty(cTpCnt)
		cQuery += " AND AAM_CLASSI='"+cTpCnt+"'"
	EndIF 

	If cLocacS == "2"
		cQuery += " AND AAN_VLRUNI>1"
	EndIF 

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	
	MemoWrite("CONFSC01.SQL",cQuery)

	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
	DbSelectArea("TRB")   

	While !EOF()
		If !TRB->AAN_CONTRT $ cCntTab
			cCntTab += cBarra + TRB->AAN_CONTRT
			cBarra := "','"
		EndIf 

		nPos1 := Ascan(aList,{|x| Alltrim(x[1]) == TRB->AAN_CONTRT})
		nPos3 := Ascan(aAux3,{|x| Alltrim(x[1]) == TRB->AAN_CONTRT})

		//Valor Diario da locacao do equipamento em referencia a quantidade de dias no mes corrente
		nVlrPro := TRB->AAN_VLRUNI / nDiasMs 

		//Se o inicio da cobranca ้ maior que o primeiro dia do mes, entใo deve-se cobrar pro-rata.
		If stod(TRB->AAN_INICOB) > firstday(ddatabase)
			//Quantidade de dias a serem cobrados at้ o final do m๊s (segundo o Cassio os contratos sempre sใo cobrados do dia 01 ao ultimo dia do mes
			nDiasCb := lastday(ddatabase) - stod(TRB->AAN_INICOB)
			//Valor a ser cobrado com a pro-rata
			nNewVlr := nVlrPro * nDiasCb                                                                                    
		//Se o fim da cobranca ้ menor que o ultimo dia do mes, entใo deve-se cobrar pro-rata dos dias em que a maquina saiu.
		ElseIf stod(TRB->AAN_FIMCOB) < lastday(ddatabase)
			//Quantidade de dias a serem cobrados do primeiro at้ a data da saํda da maquina do cliente.
			nDiasCb := stod(TRB->AAN_FIMCOB) - firstday(ddatabase)
			//Valor a ser cobrado com a pro-rata
			nNewVlr := nVlrPro * nDiasCb
		Else
			//Cobrar o valor cheio para o mes todo
			nNewVlr := TRB->AAN_VLRUNI
		EndIf
		//Item do contrato isento de cobranca    
		If TRB->AAN_XISENT == "1"
			nNewVlr := 0
		EndIf
		//Preenche o array do primeiro grid
		If nPos1 == 0
			Aadd(aList,{TRB->AAN_CONTRT,;
						nNewVlr,;
						TRB->AAM_CODCLI,;
						TRB->AAM_LOJA,;
						Alltrim(TRB->A1_NOME)+" / "+Alltrim(TRB->A1_NREDUZ),;
						Alltrim(TRB->A1_END),;
						Alltrim(TRB->A1_BAIRRO),;
						Alltrim(TRB->A1_MUN),;
						TRB->E4_COND,;
						TRB->E4_DESCRI,;
						STOD(TRB->AAM_INIVIG),;
						STOD(TRB->AAM_FIMVIG),;
						TRB->A1_EMAIL,;
						TRB->AAM_XFORFA,;	//14
						TRB->AAM_XTIPFA,;	//15
						TRB->AAM_XPERCT,;
						TRB->AAM_XRENOV,;
						0,;
						TRB->AAN_FILIAL,;
						0,;
						0,;
						TRB->AAM_XPRDCM,;
						TRB->A1_EST,;
						TRB->AAM_XPOCLI})
		Else
			//Soma todos os itens do contrato para pegar o valor total.
			aList[nPos1,02] += nNewVlr //(TRB->AAN_QUANT*TRB->AAN_VLRUNI)
		EndIf
		
		if !Empty(TRB->AAN_XCBASE)
			Aadd(aList2b,{	TRB->AAN_XCBASE,;				//01
							Alltrim(TRB->B1_DESC),;			//02
							TRB->AAN_VLRUNI,;				//03
							TRB->AAN_CONTRT,;				//04
							Stod(TRB->AAN_INICOB),;			//05
							stod(TRB->AAN_FIMCOB),;			//06
							TRB->AAN_XMINQT,;				//07
							TRB->AAN_XVLRMI,;				//08
							0,;								//09
							0,;								//10
							0,;								//11
							TRB->AAN_CONPAG})				//12
		else
			Aadd(aList2b, {"","",0,"","","",0,0,0,0,0,""})
		endif

		//Itens referente aos pedidos faturados para o contrato.
		If nPos3 == 0
			Aadd(aAux3,{TRB->AAN_CONTRT,;
						TRB->AAM_CODCLI,;
						TRB->AAM_LOJA,;
						TRB->AAN_FILIAL})
		EndIf

		If Ascan(aList5b,{|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(TRB->AAN_CONTRT)+Alltrim(TRB->AAN_XCBASE)}) == 0
			Aadd(aList5B,{	TRB->AAN_CONTRT,;
							TRB->AAN_XCBASE,;
							TRB->AAN_XMINQT,;
							TRB->AAN_XVLRMI})
		EndIf 
			
		Dbskip()
	EndDo
	
	Asort(aList,,,{|x,y| x[5] < y[5]})
					
	For nCont := 1 to len(aAux3)         
		//Buscando os pedidos faturados
		cQuery := "SELECT C6_NUM,C5_EMISSAO,C6_NOTA,C6_VALOR,"
		cQuery += " C6_DESCRI,C6_ITEM,C6_QTDVEN,C6_SERIE,C6_FILIAL,"
		cQuery += " ISNULL(CAST(CAST(Z08_URLFAT AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS URL"
		cQuery += " FROM "+RetSQLName("SC6")+" C6"
		cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL "
		cQuery += " AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5.D_E_L_E_T_=' '"
		cQuery += " AND C5_XTPPED IN('F','L','V','Q')"
		cQuery += " LEFT JOIN "+RetSQLName("Z08")+" Z08 ON Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_PEDIDO=C5_NUM AND Z08_NOTA=C5_NOTA AND Z08.D_E_L_E_T_=' '"
		cQuery += " AND Z08_URLFAT<>' ' "
		cQuery += " WHERE C6_FILIAL BETWEEN ' ' AND 'ZZ'" //'"+xFilial("SC6")+"'"
		//cQuery += " AND C6_CONTRT='"+aAux3[nCont,01]+"' "
		cQuery += " AND C6_CLI='"+aAux3[nCont,02]+"' AND C6.D_E_L_E_T_=''"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf                                                                                 
		
		MemoWrite("CONFSC01.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		While !EOF() 
			If Ascan(aList3b,{|x| x[1] == TRB->C6_NUM}) == 0
				Aadd(aList3b,{	TRB->C6_NUM,;
								stod(TRB->C5_EMISSAO),;
								TRB->C6_VALOR,;
								TRB->C6_NOTA,;
								aAux3[nCont,01],;
								aAux3[nCont,02],;
								aAux3[nCont,03],;
								TRB->C6_FILIAL+Alltrim(TRB->C6_SERIE),;
								TRB->URL})
			Else
				aList3b[Ascan(aList3b,{|x| x[1] == TRB->C6_NUM}),03] += TRB->C6_VALOR
			EndIF
			Aadd(aList4b,{	TRB->C6_NOTA,;
							substr(TRB->C6_DESCRI,1,20),;
							TRB->C6_VALOR,;
							TRB->C6_NUM,;
							TRB->C6_ITEM,;
							aAux3[nCont,01],;
							aAux3[nCont,02],;
							aAux3[nCont,03],;
							TRB->C6_QTDVEN})
			DbSkip()
		EndDo
		
	Next nCont     

	cQuery := "SELECT AAM_CONTRT,DA1_CODPRO,B1_DESC,DA1_PRCVEN,DA1_XCONSU"
	cQuery += " FROM "+RetSQLName("AAM")+" AAM"
	cQuery += "  INNER JOIN "+RetSQLName("DA1")+" DA1 ON DA1_FILIAL='"+xFilial("DA1")+"' AND DA1_CODTAB=AAM_XCODTA AND DA1.D_E_L_E_T_=' '"
	cQuery += "  INNER JOIN "+RetSQLName("SB1")+" SB1 ON B1_FILIAL=DA1_FILIAL AND B1_COD=DA1_CODPRO AND SB1.D_E_L_E_T_=' '"
	cQuery += " WHERE AAM.D_E_L_E_T_=' '"
	cQuery += " AND AAM_CONTRT IN('"+cCntTab+"')"
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf                                                                                 
		
	MemoWrite("CONFSC01.SQL",cQuery)

	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
	While !EOF()
		Aadd(aTabPrc,{	TRB->AAM_CONTRT,;
						TRB->DA1_CODPRO,;
						TRB->B1_DESC,;
						TRB->DA1_PRCVEN,;
						TRB->DA1_XCONSU})
		Dbskip()
	EndDo 

	For nCont := 1 to len(aList5b)
		
		aLeitura := {}
		aLeitura 	:=	LeiAntr(aList5b[nCont,01],aList5b[nCont,02],'')
		
		cQuery := ""
		
		For nLeitur := 1 to len(aLeitura )
			If !Empty(cQuery)	
				cQuery += "  UNION "
			EndIf 

			cQuery += "SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,"
			cQuery += " Z08_DATA,Z08_CONTRT,Z08_FATURA,Z08.R_E_C_N_O_ AS RECZ08,Z08_PEDIDO,"
			cQuery += " ISNULL(CAST(CAST(Z08_URLFAT AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS URL" 
			cQuery += "  FROM "+RetSQLname("Z08")+" Z08" 
			cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
			cQuery += "   AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' ' 
			
			cQuery += " WHERE Z08_COD='"+aLeitura[nLeitur]+"'"
			cQuery += "  AND Z08.D_E_L_E_T_=' '"
			cQuery += "  AND Z08_NUMSER='"+aList5b[nCont,02]+"' AND Z08_CONTRT='"+aList5b[nCont,01]+"'"
		Next nLeitur
			
		If !Empty(cQuery)
			//cQuery += "  ORDER BY Z08_COD DESC"
			cQuery += " ORDER BY Z08_DATA DESC,Z08_COD DESC"

			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf                                                                                 
			
			MemoWrite("CONFSC01.SQL",cQuery)
			
			cQuery:= ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
			
			aAux5 := {}

			While !EOF() 
				aAuxL5 := {}
				nPos := Ascan(aAux5,{|x| Alltrim(x[1]) == strzero(val(TRB->Z08_SELECA),3)})
				nPos2 := Ascan(aTabPrc,{|x| x[1]+x[2] == TRB->Z08_CONTRT+TRB->Z08_PRODUT})

				If nPos == 0 .OR. TRB->Z08_PRODUT != aAux5[nPos,2]
					Aadd(aAuxL5,strzero(val(TRB->Z08_SELECA),3)) //1
					Aadd(aAuxL5,TRB->Z08_PRODUT) //2
					Aadd(aAuxL5,TRB->B1_DESC) //3
					//Se ja esta faturado Z08_FATURA==S Posiciona registro atual na 04 e 05
					//do contrario 06 e 07
					If TRB->Z08_FATURA == "S"
						Aadd(aAuxL5,TRB->Z08_DATA) //4
						Aadd(aAuxL5,TRB->Z08_QTDLID) //5
						Aadd(aAuxL5,'') //6
						Aadd(aAuxL5,0) //7	
					Else 
						Aadd(aAuxL5,'') //4
						Aadd(aAuxL5,0) //5	
						Aadd(aAuxL5,TRB->Z08_DATA) //6
						Aadd(aAuxL5,TRB->Z08_QTDLID) //7
					EndIF 
					Aadd(aAuxL5,0) //8
					
					If nPos2 > 0
						Aadd(aAuxL5,aTabPrc[nPos2,04]) //9
					Else 
						Aadd(aAuxL5,0) //9
					EndIf 

					Aadd(aAuxL5,0) //10
					
					Aadd(aAuxL5,TRB->Z08_COD) //11
					Aadd(aAuxL5,TRB->Z08_FATURA) //12

					Aadd(aAuxL5,'') //13
					Aadd(aAuxL5,0) //14
					
					If len(aAuxL5) > 0
						Aadd(aAux5,aAuxL5) 
					EndIf
					
					If nPos2 > 0
						Aadd(aAuxL5,aTabPrc[nPos2,05]) //15
					Else 
						Aadd(aAuxL5,0) //15
					EndIf 

					Aadd(aAuxL5,TRB->RECZ08)  //16
					Aadd(aAuxL5,TRB->Z08_PEDIDO)  //17
					Aadd(aAuxL5,TRB->URL)  //18

				Else 
					If TRB->Z08_DATA < aAux5[nPos,04] .OR. Empty(aAux5[nPos,04]) //TRB->Z08_QTDLID < aAux5[nPos,05]
						aAux5[nPos,13] := aAux5[nPos,04]
						aAux5[nPos,14] := aAux5[nPos,05]
						aAux5[nPos,04] := TRB->Z08_DATA
						aAux5[nPos,05] := TRB->Z08_QTDLID
					
					Endif 

					If nPos2 > 0 .And. aAux5[nPos,09] == 0
						aAux5[nPos,09] := aTabPrc[nPos2,04]
					EndIf 

					If nPos2 > 0 .And. aAux5[nPos,15] == 0
						aAux5[nPos,15] := aTabPrc[nPos2,05]
					EndIf 

				EndIf 
				Dbskip()
			EndDo 

			
			For nAux := 1 to len(aAux5)
				Aadd(aList5b[nCont],aAux5[nAux])
			Next nAux
		EndIf

		lZerou := .F.
		for nX := 5 to len(aList5b[nCont])
			If aList5b[nCont,nX,07] < aList5b[nCont,nX,05]
				lZerou := .T.
				exit 
			EndIf 
		Next nX 

		for nX := 5 to len(aList5b[nCont])
			
		//leitura atual x leitura faturamento anterior
			If lZerou //aList5b[nCont,nX,07] < aList5b[nCont,nX,05] .OR. lZerou
				//leitura zerada
				aList5b[nCont,nX,08] := aList5b[nCont,nX,07]
				//lZerou := .T.
			Else 
				aList5b[nCont,nX,08] := aList5b[nCont,nX,07] - aList5b[nCont,nX,05]
			EndIf 
		//leitura atual x leitura intermediaria
			if aList5b[nCont,nX,14] > 0 //> aList5b[nCont,nX,07]
				If lZerou //aList5b[nCont,nX,14] < aList5b[nCont,nX,07] .or. aList5b[nCont,nX,14] < aList5b[nCont,nX,05]
					aList5b[nCont,nX,08] += aList5b[nCont,nX,14]
				endif
			endif

			aList5b[nCont,nX,10] := aList5b[nCont,nX,08] * aList5b[nCont,nX,09]

			nPos := Ascan(aList,{|x| Alltrim(x[1]) == aList5B[nCont,01]})
			If nPos > 0 
				If !Empty(aList5B[nCont,nX,17])
					aList[nPos,len(aQtdH)+1] := 1
					nPosic := Ascan(aList3B,{|x| x[1] == aList5B[nCont,nX,17]})
					If nPosic > 0
						If !Empty(aList3B[nPosic,04])
							aList[nPos,len(aQtdH)+1] := 2
						EndIf 
					EndIf 

				Else 
					aList[nPos,len(aQtdH)+1] := 0
				EndIf
			Endif 
		next nX

	Next nCont
	
	Asort(aList3B,,,{|x,y| DTOS(x[2]) > DTOS(y[2])})
	RestArea(aArea)

Return                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualiza os grids de acordo com o grid principal (Contratosฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)

Local aArea	:=	GetArea()
Local nCont

oSay2:settext("")
oSay4:settext("")
oSay6:settext("")
oSay7:settext("")

aList2 := {}
aList3 := {}
aList4 := {}              

oSay2:settext(aList[nLinha,03]+'-'+aList[nLinha,04]+' - '+aList[nLinha,05]+' - Contrato '+aList[nLinha,01])    
oSay4:settext(aList[nLinha,06]+' - '+aList[nLinha,07]+' - '+aList[nLinha,08])

//PReenche o grid de ativos do contrato
For nCont := 1 to len(aList2b)
	If aList2b[nCont,04] == aList[nLinha,01]
		Aadd(aList2,aList2b[nCont])
	EndIf
Next nCont
     
                             
If len(aList2) < 1
	//Nao encontrou Ativos no Contrato
	Aadd(aList2,{'','',0,'','','',0,0,0,0,0})
EndIf

//PReenche o grid de Pedidos faturados para o contrato
For nCont := 1 to len(aList3b)
	If aList3b[nCont,05] == aList[nLinha,01]
		Aadd(aList3,aList3b[nCont])
	EndIf  
Next nCont

Asort(aList3,,,{|x,y| x[2] > y[2]})

oList3:nAt := 1 

If len(aList3) < 1
	//Nao encontrou Pedidos faturados para o Contrato
	Aadd(aList3,{'','',0,'','','',''})  
	Aadd(aList4,{'','',0,0,0})
Else
	For nCont := 1 to len(aList4b)
		If aList4b[nCont,04] == aList3[1,1]
			Aadd(aList4,aList4b[nCont])	
		EndIf
	Next nCont                             
	
	If len(aList4) < 1
		Aadd(aList4,{'','',0,0,0})
	EndIf
EndIf            

Asort(aList3,,,{|x,y| x[2] > y[2]})
    
	
oList2:SetArray(aList2)
oList2:bLine := {||{ Alltrim(aList2[oList2:nAt,01]),;
					Alltrim(aList2[oList2:nAt,02]),;
					If(aList2[oList2:nAt,03]>1,Transform(aList2[oList2:nAt,03],"@E 999,999,999.99"),'Isento'),;
					If(aList2[oList2:nAt,07]>0,Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),'S/ Min.Qtd.'),;
					If(aList2[oList2:nAt,08]>0,Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),'S/ Vlr.Min.'),;
					If(aList2[oList2:nAt,09]>0,Transform(aList2[oList2:nAt,09],"@E 999,999,999.99"),'S/Qtd'),;
					If(aList2[oList2:nAt,10]>0,Transform(aList2[oList2:nAt,10],"@E 999,999,999.99"),'S/Vlr'),;
					aList2[oList2:nAt,11]}}


oList3:SetArray(aList3)
oList3:bLine := {||{ Alltrim(aList3[oList3:nAt,01]),;
							 aList3[oList3:nAt,02],;
							 aList3[oList3:nAt,04],;
		 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}

oList2:nAt := len(aList2)


oList:refresh()
oList2:refresh()
oList3:refresh() 
oDlg1:refresh()

For nCont := 1 to len(aList2)
	Fhelp3(nCont,oList:nAt)
Next nCont 

oList2:gotop()
oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*/{Protheus.doc} FHelp3
	(long_description)
	@type  Static Function
	@author user
	@since 18/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function FHelp3(nLinha,nLinha2,nOpini)

Local aArea 	:=	GetArea()
Local nPos  	:= 	0
Local nCont 
Local nX 
Local nTotQ		:=	0
Local nTotV 	:=	0
Local nTotC 	:=	0
Local cTexto
Local nDifCb	:=	0
Default nOpini 	:= 	1

aList5 := {}

If nOpini == 0
	nPos := Ascan(aList5b,{|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(aList2B[nLinha,04])+Alltrim(aList2B[nLinha,01])})
else 
	nPos := Ascan(aList5b,{|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(aList2[nLinha,04])+Alltrim(aList2[nLinha,01])})
endif 

If nPos > 0 .And. len(aList5b[nPos]) > 4
	For nCont := 5 to len(aList5b[nPos])
		Aadd(aList5,aList5b[nPos,nCont])
	Next nCont
Else 
	Aadd(aList5,{'','','','',0,'',0,0,0,0,'','','',''})
EndIf 

Aeval(aList5,{|x| nTotQ += x[8]}) //+x[14]})
Aeval(aList5,{|x| nTotV += x[10]}) //+(x[14]*x[9])})

oList5:SetArray(aList5)
oList5:bLine := {||{Alltrim(aList5[oList5:nAt,01]),;
							Alltrim(aList5[oList5:nAt,02]),;
							Alltrim(aList5[oList5:nAt,03]),;
							STOD(aList5[oList5:nAt,04]),;
							aList5[oList5:nAt,05],;
							STOD(aList5[oList5:nAt,06]),;
							aList5[oList5:nAt,07],;
							If(aList5[oList5:nAt,08]<>0,aList5[oList5:nAt,08],'Sem Consumo'),;
							Transform(aList5[oList5:nAt,09],"@E 999,999,999.99"),;
							Transform(aList5[oList5:nAt,10],"@E 999,999,999.99"),;
							stod(aList5[oList5:nAt,13]),;
							aList5[oList5:nAt,14]}}

If nOpini == 0
	aList2b[nLinha,09] := nTotQ
	aList2b[nLinha,10] := nTotV
	If aList2b[nLinha,07] > 0 .And. cQuinze == "2"	
		If aList2b[nLinha,07] - aList2b[nLinha,09] > 0
			aList2b[nLinha,11] := aList2b[nLinha,07] - aList2b[nLinha,09]
		EndIf 
	EndIf 
else 
	aList2[nLinha,09] := nTotQ
	aList2[nLinha,10] := nTotV

	If (aList2[nLinha,07] > 0 .And. cQuinze == "2") .or. (aList[nLinha2,14] == "1")	
		If aList2[nLinha,07] - aList2[nLinha,09] > 0
			aList2[nLinha,11] := aList2[nLinha,07] - aList2[nLinha,09]
		EndIf 
	EndIf
EndIf 

DbSelectArea("AAM")
DbSetOrder(1)
DbSeek(xFilial("AAM")+aList[nLinha2,01])

Aeval(aList2B,{|x| nTotC += If(x[3] > 1 .AND. x[4] == aList[nLinha2,01],x[3],0)+If(x[4] == aList[nLinha2,01],x[10],0)}) //

aList[nLinha2,02] := nTotC

cTexto := "Qtd Ativos "+cvaltochar(len(aList2))

cTexto += " # Tabela de Pre็o "+AAM->AAM_XCODTA+" "

If !Empty(AAM->AAM_XFORFA)
	IF AAM->AAM_XFORFA == "1"
		cTexto += " - Faturamento Mensal "
	Else 
		cTexto += " - Faturamento Quinzenal "
	EndIF 
EndIF 

If !Empty(AAM->AAM_XTIPFA)
	aTipFa := {'Minino Global','Minimo Unid./Ativo','Sem Minimo'}
	AAM->AAM_XTIPFA
	cTexto += " - "+aTipFa[val(AAM->AAM_XTIPFA)]
EndIF 
If !Empty(AAM->AAM_XTIPMI)
	//1=Quantidade;2=Valor  
	IF AAM->AAM_XTIPMI == "1"
		cTexto += " - Minimo por Quantidade "
	Else 
		cTexto += " - Minimo por Valor "
	EndIF 
EndIF 

If AAM->AAM_XQTVLM > 0
	cTexto += " - Qtd/Vlr Minimo "+Transform(AAM->AAM_XQTVLM,"@E 999,999,999") 

	Aeval(aList2b,{|x| nDifCb += If(x[4] == aList[nLinha2,01],If(AAM->AAM_XTIPMI=="1",x[9],x[10]),0)})

	If nDifCb < AAM->AAM_XQTVLM .AND. cQuinze == "2"
		
		aList[nLinha2,20] := AAM->AAM_XQTVLM-nDifCb
	EndIf 
EndIF 


If aList[nLinha2,20] > 0
	nAbater := 0
	nVlrAbt	:= 0

	If cQuinze == '2' .And. AAM->AAM_XFORFA == "2"
		For nCont := 1 to len(aList5B)
			If aList5B[nCont,01] == aList[nLinha2,01]
				For nX := 5 to len(aList5B[nCont])
					If aList5B[nCont,nX,12] <> 'S'
						cSelec := aList5B[nCont,nX,01]
						cNumSr := aList5B[nCont,2]
						cLeit  := aList5B[nCont,nX,11]
						cDtAnt := aList5B[nCont,nX,04]
						If aList5B[nCont,nX,08] == (aList5B[nCont,nX,07] - aList5B[nCont,nX,05])
							cDtAnt := dtos(stod(cDtAnt)-1)
						EndIf 

						nQtdAb := abatfat(cNumSr,cLeit,cSelec,cDtAnt)
						
						If nQtdAb == 0 .And. aList5B[nCont,nX,05] > 0
							nQtdAb := aList5B[nCont,nX,05]
						EndIf 
						
						/*If Ascan(aAbater,{|x| Alltrim(x[1])+Alltrim(x[6])+Alltrim(x[5]) == Alltrim(aList5B[nCont,01])+Alltrim(cNumSr)+Alltrim(cSelec)}) == 0
							Aadd(aAbater,{aList5B[nCont,01],aList5B[nCont,nX,02],nQtdAb,nQtdAb *  aList5B[nCont,nX,09],cSelec,cNumSr})
						EndIF */
						nPosAbt := Ascan(aAbater,{|x| Alltrim(x[1])+Alltrim(x[2])+Alltrim(x[5]) == Alltrim(aList5B[nCont,01])+Alltrim(aList5B[nCont,nX,02])+Alltrim(cSelec)})
						nMaqMol := Ascan(aAbater,{|x| Alltrim(cNumSr)+Alltrim(cSelec) $ Alltrim(x[6])}) 
						
						If nMaqMol == 0
							If nPosAbt == 0
								Aadd(aAbater,{aList5B[nCont,01],aList5B[nCont,nX,02],nQtdAb,aList5B[nCont,nX,09],cSelec,Alltrim(cNumSr)+Alltrim(cSelec)+"#"})
							Else 
								aAbater[nPosAbt,03] += nQtdAb
								aAbater[nPosAbt,06] := Alltrim(aAbater[nPosAbt,06]) + Alltrim(cNumSr)+Alltrim(cSelec)+"#"
								//aAbater[nPos,04] += nQtdAb *  aList5B[nCont,nX,09]*/
							EndIf 
						EndIF 

						nVlrAbt += nQtdAb *  aList5B[nCont,nX,09]
						
						
						//nAbater += aList5B[nCont,nX,05] - nQtdAb
						nAbater += nQtdAb
					EndIf
				Next nX 
			EndIf
		Next nCont

		If AAM->AAM_XQTVLM-nDifCb-nAbater > 0 .And. aList[nLinha2,len(aQtdH)+1] <= 1
			If AAM->AAM_XTIPMI=="1"
				cTexto += " - Doses Compl. a serem cobradas "+Transform(AAM->AAM_XQTVLM-nDifCb-nAbater,"@E 999,999,999")
			Else 
				cTexto += " - Doses Compl. a serem cobradas "+Transform((AAM->AAM_XQTVLM-nDifCb-nAbater)/POSICIONE("DA1",1,XFILIAL("DA1")+AAM->AAM_XCODTA+AAM->AAM_XPRDCM,"DA1_PRCVEN"),"@E 999,999,999")
			EndIf 
		EndIf 
	EndIf 

	IF AAM->AAM_XTIPMI=="1"
		aList[nLinha2,20] := aList[nLinha2,20] - nAbater
		aList[nLinha2,21] := POSICIONE("DA1",1,XFILIAL("DA1")+AAM->AAM_XCODTA+AAM->AAM_XPRDCM,"DA1_PRCVEN")
		If aList[nLinha2,20]*aList[nLinha2,21] > 0 .And. aList[nLinha2,len(aQtdH)+1] <= 1
			oSay7:settext("Valor Excedente a ser cobrado "+Transform(aList[nLinha2,20]*aList[nLinha2,21],"@E 999,999.99"))
		EndIf
	else
		aList[nLinha2,21] := POSICIONE("DA1",1,XFILIAL("DA1")+AAM->AAM_XCODTA+AAM->AAM_XPRDCM,"DA1_PRCVEN")
		aList[nLinha2,20] := (AAM->AAM_XQTVLM-nDifCb-nVlrAbt) / aList[nLinha2,21] 
		If aList[nLinha2,20]*aList[nLinha2,21] > 0 .And. aList[nLinha2,len(aQtdH)+1] <= 1
			oSay7:settext("Valor Excedente a ser cobrado "+Transform(aList[nLinha2,20]*aList[nLinha2,21],"@E 999,999.99"))
		EndIf 
	EndIf  
	
EndIf 

oSay6:settext(cTexto)

oList:refresh()
If nOpini <> 0
	oList2:refresh()
EndIf 

oList5:nAt := 1

oList5:refresh()
oDlg1:refresh()

RestArea(aAreA)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Localizar contrato por cliente                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Procurar()

Local aArea	:=	GetArea()
Local aPergs := {}
Local cCodRec := space(6)
Local aRet := {}
Local nPos	:=	0     

aAdd( aPergs ,{1,"Cliente : ",cCodRec,"@!",'.T.',"SA1",'.T.',40,.F.})  
        
If ParamBox(aPergs ,"Parametros ",aRet)
	IF !Empty(aRet[1])
		nPos := Ascan(aList,{|x| x[3] == aRet[1]})
		If nPos > 0
			oList:nAt := nPos
			oList:refresh()
			oDlg1:refresh()  
			Fhelp(oList:nAt)
		Else
			MsgAlert("Nใo encontrado contrato para este cliente "+aRet[1])
		EndIf
	EndIf
endIF

RestArea(aArea)

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gera o faturamento dos pedidos do mes corrente            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function GeraNF(cPedido,cCond,cSerie)

Local aArea	:=	GetArea()
Local cNota	:=	''
Private _aPVlNFs	:=	{}
Private _cCondPag	:=	cCond
Private _cSerie		:=	cSerie
             

dbSelectArea("SC9")
if !dbSeek(xFilial("SC9")+cPedido)
	nQtdLib := SC6->C6_QTDVEN
	//nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
	nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,.F.,.F.,.F.,.F.,.F.,.F.)
Endif

      
DbSelectArea("SC9")
DbSetOrder(1)
If DbSeek(xFilial("SC9")+cPedido)
	While SC9->(!EOF()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial("SC9")+cPedido .AND. EMPTY(SC9->C9_NFISCAL)
		//If Alltrim(SC9->C9_BLCRED) == "" .And. Alltrim(SC9->C9_BLEST) == ""
		    cTES := Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,"C6_TES")
		    
			Aadd(_aPVlNFs,{ SC9->C9_PEDIDO,;
							SC9->C9_ITEM,;
							SC9->C9_SEQUEN,;
							SC9->C9_QTDLIB,;
							SC9->C9_PRCVEN,;
							SC9->C9_PRODUTO,;
							.F.,;
							SC9->(RecNo()),;
							SC5->(Recno(Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,""))),;
							SC6->(Recno(Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,""))),;
							SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+_cCondPag,""))),;
							SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
							SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO,""))),;
							SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+cTES,""))) })
		
		DbSelectArea("SC9")
		DbSkip()
	End
EndIf 

If Len(_aPVlNFs) > 0
	/*/

		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
		ฑฑณFuncao    ณMaPvlNfs  ณ Autor ณMicrosiga              ณ Data ณ28.08.1999ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณDescri…o ณInclusao de Nota fiscal de Saida atraves do PV liberado     ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณRetorno   ณ                                                            ณฑฑ
		ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
		ฑฑณParametrosณExpA1: Array com os itens a serem gerados                   ณฑฑ
		ฑฑณ          ณExpC2: Serie da Nota Fiscal                                 ณฑฑ
		ฑฑณ          ณExpL3: Mostra Lct.Contabil                                  ณฑฑ
		ฑฑณ          ณExpL4: Aglutina Lct.Contabil                                ณฑฑ
		ฑฑณ          ณExpL5: Contabiliza On-Line                                  ณฑฑ
		ฑฑณ          ณExpL6: Contabiliza Custo On-Line                            ณฑฑ
		ฑฑณ          ณExpL7: Reajuste de preco na nota fiscal                     ณฑฑ
		ฑฑณ          ณExpN8: Tipo de Acrescimo Financeiro                         ณฑฑ
		ฑฑณ          ณExpN9: Tipo de Arredondamento                               ณฑฑ
		ฑฑณ          ณExpLA: Atualiza Amarracao Cliente x Produto                 ณฑฑ
		ฑฑณ          ณExplB: Cupom Fiscal                                         ณฑฑ
		ฑฑณ          ณExpCC: Numero do Embarque de Exportacao                     ณฑฑ
		ฑฑณ          ณExpBD: Code block para complemento de atualizacao dos titu- ณฑฑ
		ฑฑณ          ณ los financeiros.                                           ณฑฑ
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
		
		/*/	
		// -> Gera a NF
   		cNota := MAPVLNFS(_aPVlNFs,_cSerie,.F.,.F.,.F.,.F.,.F.,0,0,.F., .F.)
  		
EndIf

RestArea(aArea)

Return({cNota,_cSerie})
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Impressao do pre-faturamento por data.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreFat()

Local aArea	:=	GetArea()
Local aPergs := {}
Local aRet	 := {}
Local cResp1 := ''
Local cResp2 := ''

aAdd(aPergs ,{2,"Tipo de Impressใo?","1",{"1=Sint้tico","2=Analitico"},080,'',.T.})
aAdd(aPergs ,{2,"Perํodo de Impressใo?","1",{"1=M๊s","2=Somente dia"},080,'',.T.})

If !ParamBox(aPergs ,"Informe a op็ใo desejada",@aRet)
	Return
else
	cResp1 := If(aRet[1]=="1",'SINTษTICO','ANALITICO')
	cResp2 := aRet[2]
EndIf

U_CONFSR01(cResp1,cResp2)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Envio da Nota de Debito e o Boleto para os clientes em   บฑฑ
ฑฑบ          ณlote.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NFBol(nOpc)

Local aArea		:=	GetArea()
Local nX 

Private oBoleto,oGrupo1,oBrw1,oBotao1,oBotao2,oBotao3,oEmail,oBmp1,oBmp2,oBmp3,oBmp4,oSayB1,oSayB2,oSayB3,oSayB4,oBotao4
Private aEmail	:=	{}

If nOpc == 1
	For nX := 1 to len(aList3b)
		If strzero(month(aList3b[nX,02]),2)+cvaltochar(year(aList3b[nX,02])) == strzero(month(ddatabase),2)+cvaltochar(year(ddatabase)) .And. !Empty(aList3b[nX,01])
			nPosL1 := Ascan(aList,{|x| x[1] == aList3b[nX,05]})
			Aadd(aEmail,{.F.,;
						aList3b[nX,04],;
						Alltrim(aList[nPosL1,05]),;
						If(!Empty(aList3b[nX,04]),'Enviado','Nใo enviado'),;
						aList[nPosL1,13],;
						aList[nPosL1,01],;
						aList3b[nX,01],;
						aList[nPosL1,09],;
						aList[nPosL1,03],;
						aList[nPosL1,04],;
						aList3b[nX,08],;
						'',;
						'',;
						aList3b[nX,09]})
		EndIf
	Next nX 
else
	For nX := 1 to len(aDados)
		Aadd(aEmail,aDados[nX])
	Next nX 
EndIf 

If len(aEmail) < 1
	Aadd(aEmail,{.F.,'','','',''})
EndIf

Asort(aEmail,,,{|x,y| x[2] < y[2]})

oBoleto    := MSDialog():New( 092,232,660,1243,"Nota/Boleto por Email",,,.F.,,,,,,.T.,,,.T. )

	oGrupo1      := TGroup():New( 004,008,246,500,"Contratos Faturados",oBoleto,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{016,016,248,292},,, oGrp1 ) 
	oEmail 	   := TCBrowse():New(016,016,475,225,, {'','Nota','Cliente','Status','Email'},{5,30,40,40,20},;
                            oGrupo1,,,,{|| /*FHelp(oEmail:nAt)*/},{|| editcol(oEmail:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oEmail:SetArray(aEmail)
	oEmail:bLine := {||{If(aEmail[oEmail:nAt,01],oOk,oNo),; 
						aEmail[oEmail:nAt,02],;
						aEmail[oEmail:nAt,03],; 
						aEmail[oEmail:nAt,04],;  
	 					aEmail[oEmail:nAt,05]}}

	oBotao1    := TButton():New( 260,048,"Inverter Marc.",oBoleto,{||inverte(1)},037,012,,,,.T.,,"",,,,.F. )
	oBotao4    := TButton():New( 260,098,"Marcar/Desm. Todos",oBoleto,{||inverte(2)},037,012,,,,.T.,,"",,,,.F. )
	oBotao2    := TButton():New( 260,179,"Enviar",oBoleto,{||Processa({|| bolmail()},"Processando...") },037,012,,,,.T.,,"",,,,.F. )
	oBotao3    := TButton():New( 260,300,"Sair",oBoleto,{||oBoleto:end()},037,012,,,,.T.,,"",,,,.F. )
	oBotao5    := TButton():New( 260,398,"URL Faturam.",oBoleto,{|| urlfat(aEmail[oEmail:nAt,14])},037,012,,,,.T.,,"",,,,.F. )
	
oBoleto:Activate(,,,.T.)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marcar/Desmarcar itens a enviar por email e incluir email. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(nLinha)

Local aArea		:=	GetArea()
Local cBkMail	:=	aEmail[nLinha,5]

If oEmail:colpos == 1
	If aEmail[nLinha,oEmail:colpos]
		aEmail[nLinha,oEmail:colpos] := .F.
	Else
		aEmail[nLinha,oEmail:colpos] := .T.
	EndIf
ElseIf oEmail:colpos == 5
	lEditCell( aEmail, oEmail, "", oEmail:colpos)
	If aEmail[nLinha,05] <> cBkMail
		IF MsgYesNo("Atualizar o email no cadastro do cliente?","editcol - CONFSC01")
			DbSelectArea("SA1")
			DbSetOrder(1)
			If DbSeek(xFilial("SA1")+aList[oList:nAt,03]+aList[oList:nAt,04])
				Reclock("SA1",.F.)
				SA1->A1_EMAIL := Alltrim(SA1->A1_EMAIL)+";"+Alltrim(aEmail[nLinha,05])
				SA1->(Msunlock())
			EndIF 
		endIf 
	EndIf
EndIf

RestArea(aArea)

Return                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Marcar/Desmarcar todos de uma so vez                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function inverte(nOp)

Local aArea	:=	GetArea()
Local nX 

If nOp == 1               
	For nX := 1 to len(aEmail)
		If Empty(aEmail[nX,02])
			If aEmail[nX,01]
				aEmail[nX,01] := .F.
			Else
				aEmail[nX,01] := .T.	
			EndIf
		EndIf
	Next nX
Else
	For nX := 1 to len(aEmail)
		If aEmail[nX,01]
			aEmail[nX,01] := .F.
		Else
			aEmail[nX,01] := .T.	
		EndIf
	Next nX
EndIf
	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Atualiza grid de itens faturados com o grid de pedidos   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp2(nLinha)

Local aArea	:=	GetArea()
Local nCont 

aList4 := {}     
         
For nCont := 1 to len(aList4b)
	If aList4b[nCont,04] == aList3[nLinha,1]
		Aadd(aList4,aList4b[nCont])	
	EndIf
Next nCont                             

If len(aList4) < 1
	Aadd(aList4,{'','',0,0,0})
EndIf                              

oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Marca e desmarca itens                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarkAtv(nLinha)

If aFecha2[nLinha,01]
	aFecha2[nLinha,01] := .F.
Else
	aFecha2[nLinha,01] := .T.
EndIf

oFecha2:SetArray(aFecha2)
oFecha2:bLine := {||{If(aFecha2[oFecha2:nAt,01],oSpv,oFat),;
					 aFecha2[oFecha2:nAt,02],; 
 					 aFecha2[oFecha2:nAt,03],;
 					 stod(aFecha2[oFecha2:nAt,04])}}
oFecha2:refresh()
oDlF1:refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC01  บAutor  ณMicrosiga           บ Data ณ  09/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o arquivo esta com tamanho compativel          บฑฑ
ฑฑบ          ณ maior que 100 KB                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


// Verifica se o arquivo esta com tamanho compativel - maior que 100 KB
Static Function ChkArq(cArquivo)
      
Local nHdl := fopen(cArquivo, FO_READ + FO_SHARED)
Local nTamArq := 0
Local nTamMin := 103200 // 100KB tamanho minimo dos pdfs - 100*1024
Local lRet := .T.

If nHdl == -1
	fclose(nHdl)
	lRet := .F.
	Return lRet
EndIf	
   
nTamArq := FSeek(nHdl, 0, FS_END)
conout("Tamanho arquivo " +cArQuivo + " -> " +CVALTOCHAR(nTamArq) )   // retirar depois
If nTamArq < nTamMin
	lRet := .F.
EndIf
           
fclose(nHdl)

Return lRet

/*/{Protheus.doc} GeraPv()
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function GeraPv(nOpcG)

Local aArea 	:=	GetArea()
Local nCont 
Local nCntG
Local nCnt5
Local aItens	:=	{}
Local aItSFt	:=	{}
Local aLocac 	:=	{}
Local nJ 
Local cAtLoc 	:=	""
Local cBarra 	:=	""
Local aCombo    := {"1=Todos", "2=Somente Dose", "3=Somente Locacao" }
Local aPerg     := {}
Local cAtFat 	:=	""
Local cTipFat	:=	'' //aList[oList:nAt,15]
Local cForFat 	:=	''
Local nX 
Local lDose     := .F.
Local lLoc      := .F.
Local cFilFat	:=	If(aList[oList:nAt,23]=="RJ","0102","0101")
Local cBkpcFil  :=	cFilant 
Local aFilFat	:=	{'0101=SP','0102=RJ'} //,'0103=PR'}
Local nLst5

If nOpcG == 0 .And. !lLiberaF .And. cLocacS <> "2"
	MsgAlert("Primeiro rode a op็ใo de Libera็ใo para faturamento")
	Return
EndIf

cFilant := cFilFat 

If aList[oList:nAt,len(aQtdH)+1] > 1
	MsgAlert("Contrato jแ faturado para o perํodo")
	//Return
EndIf

aAdd( aPerg ,{2,"Escolha uma op็ใo : ",0,aCombo,100,"",.T.})
aAdd( aPerg ,{1,"PO cliente : ",aList[oList:nAt,24],"@!",'.T.',"",'.T.',40,.F.})  
aAdd( aPerg ,{2,"Filial de Faturameto : ",cFilFat,aFilFat,100,"",.T.})

If !ParamBox(aPerg ,"Parametros ")
	Return
EndIf

cFilant := MV_PAR03
cFilFat := MV_PAR03

if MV_PAR01 == "1" 
	lDose := .T.
	lLoc  := .T.
elseif MV_PAR01 == "2"
	lDose := .T.
elseif MV_PAR01 == "3"
	lLoc := .T.
endif

If nOpcG == 0
	//Faturar todos os itens liberados do array alist
	Asort(aList2B,,,{|x,y| x[4] < y[4]})
	Asort(aList5B,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
	//cLocacS

	For nCntG := 1 to len(aList)
		If aList[nCntG,len(aQtdH)+1] == 1 .OR. lLoc
			cForFat :=	aList[nCntG,14]
			cTipFat	:=	aList[nCntG,15]
			aLocac  :=  {}
			nPos2B  :=	Ascan(aList2B,{|x| x[4] == aList[nCntG,01]})

			aItens := {}
			aItSFt := {}
			cAtLoc := ''
			For nCont := nPos2B to len(aList2B)
				
				
				//Loca็๕es
				If aList2B[nCont,04] == aList[nCntG,01]
					cAtLoc += cBarra + Alltrim(aList2b[nCont,01])
					cBarra := "/"
					If aList2B[nCont,03] > 1
						Aadd(aLocac,{aList2B[nCont,01],;
									aList2B[nCont,03],;
									aList2B[nCont,12]})
					EndIf 
				else
					exit
				EndIf 

				//Doses
				cBarra := ""

				If cTipFat $ "1/2/3"

					nPosL5 := Ascan(aList5B,{|x| x[1]+x[2] == aList2B[nCont,04]+aList2B[nCont,01]})

					For nCnt5 := nPosL5 to len(aList5B)
						
						
						If aList5B[nCnt5,01] == aList[nCntG,01] .And. len(aList5b[nCnt5]) > 4
							cAtFat += cBarra + Alltrim(aList5b[nCnt5,02])
							cBarra := "/"
							For nJ := 5 to len(aList5b[nCnt5])
								If aList5B[nCnt5,nJ,08] > 0 .And. aList5B[nCnt5,nJ,09] > 0
									nPos := Ascan(aItens,{|x| x[1] == aList5B[nCnt5,nJ,02]})
									If nPos == 0
										Aadd(aItens,{	aList5B[nCnt5,nJ,02],;
														aList5B[nCnt5,nJ,08],;
														aList5B[nCnt5,nJ,09]})
									Else 
										aItens[nPos,02] += aList5B[nCnt5,nJ,08]
									EndIf
								Else 
									Aadd(aItSFt,{	aList5B[nCnt5,nJ,02],;
													aList5B[nCnt5,nJ,08],;
													aList5B[nCnt5,nJ,09]}) 
								EndIf
							Next nJ
						Else 
							exit 
						EndIf
					Next nCnt5
				
					If aList[nCntG,20] > 0 .And. len(aItens) > 0
						Aadd(aItens,{aList[nCntG,22],;
									aList[nCntG,20],;
									aList[nCntG,21]})
					EndIf 
				
				ElseIf cTipFat == "22"
					//For nX := 1 to len(aList2B)
						aItens := {}
						aItSFt := {}
						nPosL5 := Ascan(aList5B,{|x| x[1]+x[2] == aList2B[nCont,04]+aList2B[nCont,01]})

						For nLst5 := nPosL5 to len(aList5B)
							If aList5B[nLst5,01] == aList2B[nCont,04] .And. len(aList5b[nLst5]) > 4 .And. aList5B[nLst5,02] == aList2B[nCont,01]
								For nJ := 5 to len(aList5b[nLst5])
									If aList5B[nLst5,nJ,08] > 0 .And. aList5B[nLst5,nJ,09] > 0
										nPosloc := Ascan(aItens,{|x| x[1] == aList5B[nLst5,nJ,02]})
										
										If nPosloc == 0
											
											Aadd(aItens,{	aList5B[nLst5,nJ,02],;
															aList5B[nLst5,nJ,08],;
															aList5B[nLst5,nJ,09]})
										Else 
											aItens[nPosloc,02] += aList5B[nLst5,nJ,08]
										EndIf
									Else 
										Aadd(aItSFt,{	aList5B[nLst5,nJ,02],;
														aList5B[nLst5,nJ,08],;
														aList5B[nLst5,nJ,09]}) 
									EndIf
								Next nJ 
							EndIf
						Next nLst5

						If (aList2B[nCont,11] > 0 .And. cQuinze == "2") .OR.(cForFat=="1" .AND. cTipFat=="2" .and. aList2B[nCont,11] > 0) //cCond == "2"
							Aadd(aItens,{	aList[nCntG,22],;
											aList2B[nCont,11],;
											Posicione("DA1",1,xFilial("DA1")+AAM->AAM_XCODTA+aList[nCntG,22],"DA1_PRCVEN")})
						EndIf 
						cAtFat := Alltrim(aList2B[nCont,01])
						//If len(aItens) > 0 
							//If resumfat(aItens,aItSFt,.F.)
								//Processa({|| Pedido(cAtFat,aItens,cFilFat,MV_PAR02)},"Aguarde")
							//else
							//	Return 
							//EndIf 
						//	aItens := {}
						//EndIF		
					//Next nX
				EndIf 
			Next nCont

			//Faturamento Doses
			If len(aItens) > 0
				If len(aItens) > 0 .AND. lDose
				//PEDIDOS DE DOSES
					
					If Empty(cAtFat)
						cAtFat := Alltrim(aList2[nCntG,01])
					EndIF 

					DbSelectArea("AAM")
					DbSetOrder(1)
					DbSeek(xFilial("AAM")+aList[nCntG,01])
					aCabec := {}
					aItC6  := {}
					cItem  := '01'

					aAdd( aCabec , { "C5_FILIAL"    , cFilFat		      , Nil } ) 
					aAdd( aCabec , { "C5_XTPPED"    , 'F'                 , Nil } )
					aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
					aAdd( aCabec , { "C5_CLIENTE"   , aList[nCntG,03]    , Nil } )
					aAdd( aCabec , { "C5_LOJACLI"   , aList[nCntG,04]    , Nil } )
					Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento de Doses - Ref. Patrimonio(s) '+cAtFat   , Nil } )
					aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV     , Nil } )    
					aAdd( aCabec , { "C5_NATUREZ"   , "31101001  "     , Nil } )    
					aAdd( aCabec , { "C5_XCONTRT"	, aList[nCntG,01]	, Nil })
						
					For nCont := 1 to len(aItens)
						aLinha := {}
						aAdd( aLinha , { "C6_FILIAL"     , cFilFat		                          , Nil })
						aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
						aAdd( aLinha , { "C6_PRODUTO"    , aItens[nCont,01]                       , Nil })
						aAdd( aLinha , { "C6_QTDVEN"     , aItens[nCont,02]                       , Nil })
						aAdd( aLinha , { "C6_PRCVEN"     , aItens[nCont,03]                       , Nil })
						aAdd( aLinha , { "C6_OPER"       , "08"                                   , Nil })
						// aAdd( aLinha , { "C6_TES"        , '523'                                  , Nil })  
						aAdd( aLinha , { "C6_QTDLIB"     , aItens[nCont,02]    	                  , Nil })
						aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

						If !Empty(MV_PAR02)
							aAdd( aLinha , { "C6_PEDCLI"	,	MV_PAR02 	, Nil })
						EndIf 

						aAdd( aItC6 , aLinha ) 
						cItem := Soma1(cItem)
					Next nCont

					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
						
					IF lMsErroAuto  
						MostraErro()
					ELSE
						aDadNF := GeraNF(SC5->C5_NUM,SC5->C5_CONDPAG,'1')
						nVlrFt := 0
						//Msgalert("Pedido gerado de faturamento de doses "+SC5->C5_NUM)
						DbSelectArea("Z08")
						DbSetOrder(3)
						cUrlfat := ''
						For nCont := 1 to len(aList5B)
							If aList5B[nCont,01] == aList[nCntG,01] .And. len(aList5b[nCont]) > 4
								For nJ := 5 to len(aList5b[nCont])
									If Dbseek(xFilial("Z08")+aList5b[nCont,nJ,11]+aList5b[nCont,nJ,01]+aList5B[nCont,02])
										RecLock("Z08", .F.)
										Z08->Z08_FATURA := 'S'
										Z08->Z08_PEDIDO := SC5->C5_NUM
										Z08->Z08_CONSUM := aList5b[nCont,nJ,08]
										Z08->Z08_VLRFAT := aList5b[nCont,nJ,10]
										Z08->Z08_NOTA	:= aDadNF[1]
										Z08->Z08_SERIE	:= aDadNF[2]
										nVlrFt += aList5b[nCont,nJ,10]
										Z08->(MsUnlock())
										aList5b[nCont,nJ,12] := 'S'
										Dbskip() 
										cUrlFat := aList5b[nCont,nJ,18]
									EndIf 
								Next nJ
							EndIf 
						Next nCont

						Aadd(aList3b,{	SC5->C5_NUM,;
										SC5->C5_EMISSAO,;
										nVlrFt,;
										aDadNF[1],;
										aList[nCntG,01],;
										aList[nCntG,03],;
										aList[nCntG,04],;
										SC5->C5_FILIAL,;
										cUrlFat})

						Aadd(aList3,{	SC5->C5_NUM,;
										SC5->C5_EMISSAO,;
										nVlrFt,;
										aDadNF[1],;
										aList[nCntG,01],;
										aList[nCntG,03],;
										aList[nCntG,04],;
										SC5->C5_FILIAL,;
										cUrlFat})

						For nCont := 1 to len(aList5B)
							If aList5B[nCont,01] == aList[nCntG,01] .And. len(aList5b[nCont]) > 4
								For nJ := 5 to len(aList5b[nCont])
									aList5B[nCont,nJ,04] := aList5B[nCont,nJ,06]
									aList5B[nCont,nJ,05] := aList5B[nCont,nJ,07]
									aList5B[nCont,nJ,06] := ""
									aList5B[nCont,nJ,07] := 0
									aList5B[nCont,nJ,08] := 0
									aList5B[nCont,nJ,10] := 0
									aList5B[nCont,nJ,12] := "S"
									aList5B[nCont,nJ,17] := SC5->C5_NUM
								Next nJ
							EndIF 
						Next nCont
					ENDIF

				EndIF 
			
			EndIf
			//Faturamento locacao
			If len(aLocac) > 0 .AND. lLoc
				cProdLoc := SuperGetMV("TI_PRODLOC",.F.,"SLOC000001")
				cNaturez := SuperGetMV("TI_NATRLOC",.F.,"31101003  ")
				cTesLoc  := Posicione("SB1",1,xFilial("SB1")+cProdLoc,"B1_TS")
				DbSelectArea("AAM")
				DbSetOrder(1)
				DbSeek(xFilial("AAM")+aList[nCntG,01])
				aCabec := {}
				aItC6  := {}
				cItem  := '01'

				If aList[nCntG,23] == "RJ"
					cFilFat := '0102'
				else
					cFilFat := '0101' 
				EndIF 

				cfilant := cFilfat

				aAdd( aCabec , { "C5_FILIAL"    , cFilFat		      	, Nil } ) 
				aAdd( aCabec , { "C5_XTPPED"    , 'L'                 	, Nil } )
				aAdd( aCabec , { "C5_TIPO"      , 'N'                 	, Nil } )
				aAdd( aCabec , { "C5_CLIENTE"   , aList[nCntG,03]   , Nil } )
				aAdd( aCabec , { "C5_LOJACLI"   , aList[nCntG,04]   , Nil } )
				Aadd( aCabec , { "C5_MENNOTA"   , 'Locacao de Maquinas Ref. Patrimonio(s) '+cAtLoc    , Nil } )
				aAdd( aCabec , { "C5_CONDPAG"   , aLocac[1,3]     		, Nil } )    //AAM->AAM_CPAGPV
				aAdd( aCabec , { "C5_NATUREZ"   , cNaturez     			, Nil } )
				aAdd( aCabec , { "C5_XCONTRT"	, aList[nCntG,01]	, Nil })
				
				nVlrFt := 0
				For nCont := 1 to len(aLocac)
					aLinha := {}
					aAdd( aLinha , { "C6_FILIAL"     , cFilFat		                          , Nil })
					aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
					aAdd( aLinha , { "C6_PRODUTO"    , cProdLoc		                          , Nil })
					aAdd( aLinha , { "C6_QTDVEN"     , 1				                      , Nil })
					aAdd( aLinha , { "C6_PRCVEN"     , aLocac[nCont,02]                       , Nil })
					aAdd( aLinha , { "C6_TES"        , cTesLoc                                , Nil })  
					aAdd( aLinha , { "C6_QTDLIB"     , 1			    	                  , Nil })
					aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

					If !Empty(MV_PAR02)
						aAdd( aLinha , { "C6_PEDCLI"	,	MV_PAR02 	, Nil })
					EndIF 

					nVlrFt += aLocac[nCont,02]
					aAdd( aItC6 , aLinha ) 
					cItem := Soma1(cItem)
				Next nCont

				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
					
				IF lMsErroAuto  
					MostraErro()
				ELSE
					aDadNF := GeraNF(SC5->C5_NUM,SC5->C5_CONDPAG,If(cFilfat=='0101','LOC','LRJ'))

					Aadd(aList3b,{	SC5->C5_NUM,;
										SC5->C5_EMISSAO,;
										nVlrFt,;
										aDadNF[1],;
										aList[nCntG,01],;
										aList[nCntG,03],;
										aList[nCntG,04],;
										SC5->C5_FILIAL,;
										''})
										
						Aadd(aList3,{	SC5->C5_NUM,;
										SC5->C5_EMISSAO,;
										nVlrFt,;
										aDadNF[1],;
										aList[nCntG,01],;
										aList[nCntG,03],;
										aList[nCntG,04],;
										SC5->C5_FILIAL,;
										''})
					aLocac := {}
					
				ENDIF    
			EndIf
		EndIf 
	Next nCntG

ElseIf nOpcG == 1	
	cForFat :=	aList[oList:nAt,14]
	cTipFat	:=	aList[oList:nAt,15]

	//Faturamento unico na linha do array alist
	For nCont := 1 to len(aList2B)
		If aList2B[nCont,04] == aList[oList:nAt,01]
			cAtLoc += cBarra + Alltrim(aList2b[nCont,01])
			cBarra := "/"
			If aList2B[nCont,03] > 1
				Aadd(aLocac,{aList2B[nCont,01],;
							aList2B[nCont,03],;
							aList2B[nCont,12]})
			EndIf 
		EndIf 
	Next nCont

	cBarra := ""

	If cTipFat $ "1/3"
		For nCont := 1 to len(aList5B)
			If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
				cAtFat += cBarra + Alltrim(aList5b[nCont,02])
				cBarra := "/"
				For nJ := 5 to len(aList5b[nCont])
					If aList5B[nCont,nJ,08] > 0 .And. aList5B[nCont,nJ,09] > 0
						nPos := Ascan(aItens,{|x| x[1] == aList5B[nCont,nJ,02]})
						If nPos == 0
							Aadd(aItens,{	aList5B[nCont,nJ,02],;
											aList5B[nCont,nJ,08],;
											aList5B[nCont,nJ,09]})
						Else 
							aItens[nPos,02] += aList5B[nCont,nJ,08]
						EndIf
					Else 
						Aadd(aItSFt,{	aList5B[nCont,nJ,02],;
											aList5B[nCont,nJ,08],;
											aList5B[nCont,nJ,09]}) 
					EndIf
				Next nJ 
			EndIf
		Next nCont
	
		If aList[oList:nAt,20] > 0 .And. len(aItens) > 0
			Aadd(aItens,{aList[oList:nAt,22],;
						aList[oList:nAt,20],;
						aList[oList:nAt,21]})
		EndIf 
	
	ElseIf cTipFat == "2"
		DbSelectArea("AAM")
		DbSetOrder(1)
		DbSeek(xFilial("AAM")+aList[oList:nAt,01])
		For nX := 1 to len(aList2)
			//aItens := {}
			For nCont := 1 to len(aList5B)
				If aList5B[nCont,01] == aList2[nX,04] .And. len(aList5b[nCont]) > 4 .And. aList5B[nCont,02] == aList2[nX,01]
					For nJ := 5 to len(aList5b[nCont])
						If aList5B[nCont,nJ,08] > 0 .And. aList5B[nCont,nJ,09] > 0
							nPosloc := Ascan(aItens,{|x| x[1] == aList5B[nCont,nJ,02]})
							
							If nPosloc == 0
								
								Aadd(aItens,{	aList5B[nCont,nJ,02],;
												aList5B[nCont,nJ,08],;
												aList5B[nCont,nJ,09]})
							Else 
								aItens[nPosloc,02] += aList5B[nCont,nJ,08]
							EndIf
						Else 
							Aadd(aItSFt,{	aList5B[nCont,nJ,02],;
												aList5B[nCont,nJ,08],;
												aList5B[nCont,nJ,09]}) 
						EndIf
					Next nJ 
				EndIf
			Next nCont

			//If (aList2[nX,11] > 0 .And. cQuinze == "2") .OR.(cForFat=="1" .AND. cTipFat=="2" .and. aList2[nX,11] > 0) //cCond == "2"
			If (aList2[nX,08] > 0 .And. cQuinze == "2") .OR.(cForFat=="1" .AND. cTipFat=="2" .and. aList2[nX,08] > 0) //cCond == "2"
				npos := Ascan(aItens,{|x| alltrim(x[1]) == alltrim(aList[oList:nAt,22])})
				If aList2[nX,10] - aList2[nX,08] > 0
					
					nVlrDos  := Posicione("DA1",1,xFilial("DA1")+AAM->AAM_XCODTA+aList[oList:nAt,22],"DA1_PRCVEN")
					
					If cTipFat == "2"
						//Minimo por ativo e valor
						nQtdVlr := (aList2[nX,10] - aList2[nX,08]) / nVlrDos
					Else 
						nQtdVlr := (aList2[nX,10] - aList2[nX,08])/aList[oList:nAt,21]
					EndIf 

					If npos == 0
						Aadd(aItens,{	aList[oList:nAt,22],;
										nQtdVlr,;
										nVlrDos})
					Else 
						aItens[npos,02] += nQtdVlr
					EndIf
				EndIf
			EndIf 
			cAtFat := Alltrim(aList2[nX,01])
			//If len(aItens) > 0 
			//	If resumfat(aItens,aItSFt,.F.)
			//		Processa({|| Pedido(cAtFat,aItens,cFilFat,MV_PAR02)},"Aguarde")
			//	else
			//		Return 
			//	EndIf 
			//	aItens := {}
			//EndIF		
		Next nX
	EndIf 

EndIF 

If len(aItens) > 0
	If resumfat(aItens,aItSFt,.F.,cForFat)
					
		If len(aItens) > 0 .AND. lDose
		//PEDIDOS DE DOSES
			
			If Empty(cAtFat)
				cAtFat := Alltrim(aList2[oList2:nAt,01])
			EndIF 

			DbSelectArea("AAM")
			DbSetOrder(1)
			DbSeek(xFilial("AAM")+aList[oList:nAt,01])
			aCabec := {}
			aItC6  := {}
			cItem  := '01'

			aAdd( aCabec , { "C5_FILIAL"    , cFilFat		      , Nil } ) 
			aAdd( aCabec , { "C5_XTPPED"    , 'F'                 , Nil } )
			aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
			aAdd( aCabec , { "C5_CLIENTE"   , aList[oList:nAt,03]    , Nil } )
			aAdd( aCabec , { "C5_LOJACLI"   , aList[oList:nAt,04]    , Nil } )
			Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento de Doses - Ref. Patrimonio(s) '+cAtFat   , Nil } )
			aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV     , Nil } )    
			aAdd( aCabec , { "C5_NATUREZ"   , "31101001  "     , Nil } )    
			aAdd( aCabec , { "C5_XCONTRT"	, aList[oList:nAt,01]	, Nil })
				
			For nCont := 1 to len(aItens)
				aLinha := {}
				aAdd( aLinha , { "C6_FILIAL"     , cFilFat		                          , Nil })
				aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
				aAdd( aLinha , { "C6_PRODUTO"    , aItens[nCont,01]                       , Nil })
				aAdd( aLinha , { "C6_QTDVEN"     , aItens[nCont,02]                       , Nil })
				aAdd( aLinha , { "C6_PRCVEN"     , aItens[nCont,03]                       , Nil })
				aAdd( aLinha , { "C6_OPER"       , "08"                                   , Nil })
				// aAdd( aLinha , { "C6_TES"        , '523'                                  , Nil })  
				aAdd( aLinha , { "C6_QTDLIB"     , aItens[nCont,02]    	                  , Nil })
				aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

				If !Empty(MV_PAR02)
					aAdd( aLinha , { "C6_PEDCLI"	,	MV_PAR02 	, Nil })
				EndIf 

				aAdd( aItC6 , aLinha ) 
				cItem := Soma1(cItem)
			Next nCont

			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
				
			IF lMsErroAuto  
				MostraErro()
			ELSE
				aDadNF := GeraNF(SC5->C5_NUM,SC5->C5_CONDPAG,'1')
				nVlrFt := 0
				Msgalert("Pedido gerado de faturamento de doses "+SC5->C5_NUM)
				DbSelectArea("Z08")
				DbSetOrder(3)
				cUrlFat := ''
				For nCont := 1 to len(aList5B)
					If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
						For nJ := 5 to len(aList5b[nCont])
							If Dbseek(xFilial("Z08")+aList5b[nCont,nJ,11]+aList5b[nCont,nJ,01]+aList5B[nCont,02])
								RecLock("Z08", .F.)
								Z08->Z08_FATURA := 'S'
								Z08->Z08_PEDIDO := SC5->C5_NUM
								Z08->Z08_CONSUM := aList5b[nCont,nJ,08]
								Z08->Z08_VLRFAT := aList5b[nCont,nJ,10]
								Z08->Z08_NOTA	:= aDadNF[1]
								Z08->Z08_SERIE	:= aDadNF[2]
								nVlrFt += aList5b[nCont,nJ,10]
								Z08->(MsUnlock())
								aList5b[nCont,nJ,12] := 'S'
								Dbskip() 
								cUrlFat := aList5b[nCont,nJ,18] 
							EndIf 
						Next nJ
					EndIf 
				Next nCont

				Aadd(aList3b,{	SC5->C5_NUM,;
								SC5->C5_EMISSAO,;
								nVlrFt,;
								aDadNF[1],;
								aList[oList:nAt,01],;
								aList[oList:nAt,03],;
								aList[oList:nAt,04],;
								SC5->C5_FILIAL,;
								cUrlFat})

				Aadd(aList3,{	SC5->C5_NUM,;
								SC5->C5_EMISSAO,;
								nVlrFt,;
								aDadNF[1],;
								aList[oList:nAt,01],;
								aList[oList:nAt,03],;
								aList[oList:nAt,04],;
								SC5->C5_FILIAL,;
								cUrlFat})

				For nCont := 1 to len(aList5B)
					If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
						For nJ := 5 to len(aList5b[nCont])
							aList5B[nCont,nJ,04] := aList5B[nCont,nJ,06]
							aList5B[nCont,nJ,05] := aList5B[nCont,nJ,07]
							aList5B[nCont,nJ,06] := ""
							aList5B[nCont,nJ,07] := 0
							aList5B[nCont,nJ,08] := 0
							aList5B[nCont,nJ,10] := 0
							aList5B[nCont,nJ,12] := "S"
							aList5B[nCont,nJ,17] := SC5->C5_NUM
						Next nJ
					EndIF 
				Next nCont
			ENDIF

		EndIF 
	Else 
		Return 
	EndIf 
EndIf
					
//Faturamento locacao
If len(aLocac) > 0 .AND. lLoc
	If resumfat(aLocac,aItSFt,lLoc,cForFat)
		cProdLoc := SuperGetMV("TI_PRODLOC",.F.,"SLOC000001")
		cNaturez := SuperGetMV("TI_NATRLOC",.F.,"31101003  ")
		cTesLoc  := Posicione("SB1",1,xFilial("SB1")+cProdLoc,"B1_TS")
		DbSelectArea("AAM")
		DbSetOrder(1)
		DbSeek(xFilial("AAM")+aList[oList:nAt,01])
		aCabec := {}
		aItC6  := {}
		cItem  := '01'

		aAdd( aCabec , { "C5_FILIAL"    , cFilFat		      	, Nil } ) 
		aAdd( aCabec , { "C5_XTPPED"    , 'L'                 	, Nil } )
		aAdd( aCabec , { "C5_TIPO"      , 'N'                 	, Nil } )
		aAdd( aCabec , { "C5_CLIENTE"   , aList[oList:nAt,03]   , Nil } )
		aAdd( aCabec , { "C5_LOJACLI"   , aList[oList:nAt,04]   , Nil } )
		Aadd( aCabec , { "C5_MENNOTA"   , 'Locacao de Maquinas Ref. Patrimonio(s) '+cAtLoc    , Nil } )
		aAdd( aCabec , { "C5_CONDPAG"   , aLocac[1,3]     		, Nil } )    //AAM->AAM_CPAGPV
		aAdd( aCabec , { "C5_NATUREZ"   , cNaturez     			, Nil } )
		aAdd( aCabec , { "C5_XCONTRT"	, aList[oList:nAt,01]	, Nil })
		
		nVlrFt := 0
		For nCont := 1 to len(aLocac)
			aLinha := {}
			aAdd( aLinha , { "C6_FILIAL"     , cFilFat		                          , Nil })
			aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
			aAdd( aLinha , { "C6_PRODUTO"    , cProdLoc		                          , Nil })
			aAdd( aLinha , { "C6_QTDVEN"     , 1				                      , Nil })
			aAdd( aLinha , { "C6_PRCVEN"     , aLocac[nCont,02]                       , Nil })
			aAdd( aLinha , { "C6_TES"        , cTesLoc                                , Nil })  
			aAdd( aLinha , { "C6_QTDLIB"     , 1			    	                  , Nil })
			aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

			If !Empty(MV_PAR02)
				aAdd( aLinha , { "C6_PEDCLI"	,	MV_PAR02 	, Nil })
			EndIF 

			nVlrFt += aLocac[nCont,02]
			aAdd( aItC6 , aLinha ) 
			cItem := Soma1(cItem)
		Next nCont

		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
			
		IF lMsErroAuto  
			MostraErro()
		ELSE
			Msgalert("Pedido gerado de loca็ใo "+SC5->C5_NUM)
			aDadNF := GeraNF(SC5->C5_NUM,SC5->C5_CONDPAG,If(cFilfat=='0101','LOC','LRJ'))

			Aadd(aList3b,{	SC5->C5_NUM,;
								SC5->C5_EMISSAO,;
								nVlrFt,;
								aDadNF[1],;
								aList[oList:nAt,01],;
								aList[oList:nAt,03],;
								aList[oList:nAt,04],;
								SC5->C5_FILIAL,;
								''})
								
				Aadd(aList3,{	SC5->C5_NUM,;
								SC5->C5_EMISSAO,;
								nVlrFt,;
								aDadNF[1],;
								aList[oList:nAt,01],;
								aList[oList:nAt,03],;
								aList[oList:nAt,04],;
								SC5->C5_FILIAL,;
								''})
			
		ENDIF    
	EndIf
EndIf 

Fhelp(oList:nAt)

cfilant := cBkpcFil

RestArea(aArea)

Return

/*/{Protheus.doc} ItensPv
	(long_description)
	@type  Static Function
	@author user
	@since 09/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function ItensPv(cPedido,cNota)

Local oDlg3i,oGrp1i,oGrp2i,oBtn1i
Local aItemPv 	:=	{}
Local aItemNf 	:=	{}
Local oItemPv
Local oItemNf 

If !Empty(cPedido)
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(xFilial("SC6")+cPedido)
	While !EOF() .AND. SC6->C6_FILIAL == xFilial("SC6") .AND. SC6->C6_NUM == cPedido 
		Aadd(aItemPv,{	SC6->C6_ITEM,;
						SC6->C6_PRODUTO,;
						SC6->C6_QTDVEN,;
						SC6->C6_PRCVEN,;
						SC6->C6_VALOR})
		Dbskip()
	EndDo 
EndIF 

IF !Empty(cNota)
	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2")+cNota)
	While !EOF() .AND. SD2->D2_FILIAL == xFilial("SD2") .AND. SD2->D2_DOC == cNota 
		Aadd(aItemNf,{	SD2->D2_ITEM,;
						SD2->D2_COD,;
						SD2->D2_QUANT,;
						SD2->D2_PRCVEN,;
						SD2->D2_TOTAL})
		Dbskip()
	EndDo 
	
EndIF 

If len(aItemNf) < 1
	Aadd(aItemNf,{'','','',0,0})
EndIf 

If len(aItemPv) > 0
	oDlg3i    := MSDialog():New( 092,232,395,1148,"Itens",,,.F.,,,,,,.T.,,,.T. )

		oGrp1i      := TGroup():New( 004,008,124,216,"Pedido "+cPedido,oDlg3i,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,120,212},,, oGrp1i ) 
		oItemPv 	   := TCBrowse():New(012,012,199,107,, {'Item','Produto','Qtd','Vlr Unit.','Vlr Total'},{30,40,40,40,40},;
									oGrp1i,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
			oItemPv:SetArray(aItemPv)
			oItemPv:bLine := {||{ 	aItemPv[oItemPv:nAt,01],;
									aItemPv[oItemPv:nAt,02],;
									aItemPv[oItemPv:nAt,03],;
									Transform(aItemPv[oItemPv:nAt,04],"@E 999,999,999.99"),;
									Transform(aItemPv[oItemPv:nAt,05],"@E 999,999,999.99")}}
		
		oGrp2i      := TGroup():New( 004,220,124,448," Nota "+cNota,oDlg3i,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,224,120,444},,, oGrp2i ) 
		oItemNf 	   := TCBrowse():New(012,224,222,107,, {'Item','Produto','Qtd','Vlr Unit.','Vlr Total'},{30,40,40,40,40},;
									oGrp2i,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
			oItemNf:SetArray(aItemNf)
			oItemNf:bLine := {||{ 	aItemNf[oItemNf:nAt,01],;
									aItemNf[oItemNf:nAt,02],;
									aItemNf[oItemNf:nAt,03],;
									Transform(aItemNf[oItemNf:nAt,04],"@E 999,999,999.99"),;
									Transform(aItemNf[oItemNf:nAt,05],"@E 999,999,999.99")}}
		
		oBtn1i      := TButton():New( 128,192,"Sair",oDlg3i,{|| oDlg3i:end()},037,012,,,,.T.,,"",,,,.F. )

	oDlg3i:Activate(,,,.T.)
EndIf 

Return

/*/{Protheus.doc} Pedido
	(long_description)
	@type  Static Function
	@author user
	@since 10/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Pedido(cAtFat,aItens,cFilFat,cPoCli)

Local aArea		:=	GetArea()
Local nCont 	:=	0
Local nJ 
Local aCabec	:=	{}
Local aItC6		:=	{}
Local cItem
Local aLinha	:=	{}

If Empty(cAtFat)
	cAtFat := Alltrim(aList2[oList2:nAt,01])
EndIF 

DbSelectArea("AAM")
DbSetOrder(1)
DbSeek(xFilial("AAM")+aList[oList:nAt,01])
aCabec := {}
aItC6  := {}
cItem  := '01'

cNaturez := SuperGetMV("TI_NATRLOC",.F.,"31101003  ")

aAdd( aCabec , { "C5_FILIAL"    , cFilFat		      , Nil } ) 
aAdd( aCabec , { "C5_XTPPED"    , 'F'                 , Nil } )
aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
aAdd( aCabec , { "C5_CLIENTE"   , aList[oList:nAt,03]    , Nil } )
aAdd( aCabec , { "C5_LOJACLI"   , aList[oList:nAt,04]    , Nil } )
Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento de Doses - Ref. Patrimonio(s) '+cAtFat   , Nil } )
aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV     , Nil } )    
aAdd( aCabec , { "C5_XCONTRT"	, aList[oList:nAt,01]	, Nil })
aAdd( aCabec , { "C5_NATUREZ"   , cNaturez     			, Nil } )
		   	
For nCont := 1 to len(aItens)
	aLinha := {}
	aAdd( aLinha , { "C6_FILIAL"     , cFilFat		                          , Nil })
	aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
	aAdd( aLinha , { "C6_PRODUTO"    , aItens[nCont,01]                       , Nil })
	aAdd( aLinha , { "C6_QTDVEN"     , aItens[nCont,02]                       , Nil })
	aAdd( aLinha , { "C6_PRCVEN"     , aItens[nCont,03]                       , Nil })
	aAdd( aLinha , { "C6_OPER"       , "08"                                   , Nil })
	//aAdd( aLinha , { "C6_TES"        , '523'                                  , Nil })  
	aAdd( aLinha , { "C6_QTDLIB"     , aItens[nCont,02]    	                  , Nil })
	aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

	If !Empty(cPoCli)
		aAdd( aLinha , { "C6_PEDCLI"	,	cPoCli 	, Nil })
	EndIf 

	aAdd( aItC6 , aLinha ) 
	cItem := Soma1(cItem)
Next nCont

lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
	
IF lMsErroAuto  
	MostraErro()
ELSE
	aDadNF := GeraNF(SC5->C5_NUM,SC5->C5_CONDPAG,'1')
	nVlrFt := 0
	Msgalert("Pedido gerado de faturamento de doses "+SC5->C5_NUM)
	DbSelectArea("Z08")
	DbSetOrder(3)
	cUrlFat := ''
	For nCont := 1 to len(aList5B)
		If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
			For nJ := 5 to len(aList5b[nCont])
				If Dbseek(xFilial("Z08")+aList5b[nCont,nJ,11]+aList5b[nCont,nJ,01]+aList5B[nCont,02])
					//While !EOF() .And. Z08->Z08_COD == aList5b[nCont,nJ,11]
						RecLock("Z08", .F.)
						Z08->Z08_FATURA := 'S'
						Z08->Z08_PEDIDO := SC5->C5_NUM
						Z08->Z08_CONSUM := aList5b[nCont,nJ,08]
						Z08->Z08_VLRFAT := aList5b[nCont,nJ,10]
						Z08->Z08_NOTA	:= aDadNF[1]
						Z08->Z08_SERIE	:= aDadNF[2]
						nVlrFt += aList5b[nCont,nJ,10]
						Z08->(MsUnlock())
						aList5b[nCont,nJ,12] := 'S'
						Dbskip()
						cUrlFat := aList5b[nCont,nJ,18]
					//EndDo 
				EndIf 
			Next nJ
		EndIf 
	Next nCont

	Aadd(aList3b,{	SC5->C5_NUM,;
					SC5->C5_EMISSAO,;
					nVlrFt,;
					aDadNF[1],;
					aList[oList:nAt,01],;
					aList[oList:nAt,03],;
					aList[oList:nAt,04],;
					SC5->C5_FILIAL,;
					cUrlFat})
					
	Aadd(aList3,{	SC5->C5_NUM,;
					SC5->C5_EMISSAO,;
					nVlrFt,;
					aDadNF[1],;
					aList[oList:nAt,01],;
					aList[oList:nAt,03],;
					aList[oList:nAt,04],;
					SC5->C5_FILIAL,;
					cUrlFat})

	For nCont := 1 to len(aList5B)
		If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4 .AND. Alltrim(aList5B[nCont,02]) == Alltrim(cAtFat)
			For nJ := 5 to len(aList5b[nCont])
				aList5B[nCont,nJ,04] := aList5B[nCont,nJ,06]
				aList5B[nCont,nJ,05] := aList5B[nCont,nJ,07]
				aList5B[nCont,nJ,06] := ""
				aList5B[nCont,nJ,07] := 0
				aList5B[nCont,nJ,08] := 0
				aList5B[nCont,nJ,10] := 0
				aList5B[nCont,nJ,12] := "S"
				aList5B[nCont,nJ,17] := SC5->C5_NUM
			Next nJ
		EndIF 
	Next nCont

ENDIF

RestArea(aArea)

Return

/*/{Protheus.doc} LeiAntr
	(long_description)
	@type  Static Function
	@author user
	@since 15/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function LeiAntr(cCont,cAtv,cLei)

	Local aArea := GetArea()
	Local aRet  := {}
	Local cQry  := ""
	Local nLei  := 0

	cQry := "SELECT Z08_COD,Z08_DATA,Z08_FATURA,COUNT(*) FROM "+RetSQLName("Z08")
	cQry += " WHERE Z08_NUMSER='"+cAtv+"' AND Z08_CONTRT='"+cCont+"' AND D_E_L_E_T_=' '"

	IF !Empty(cLei)
		cQry += " AND Z08_COD NOT IN('"+cLei+"')"
	EndIf 

	cQry += " GROUP BY Z08_COD,Z08_DATA,Z08_FATURA "
	cQry += " ORDER BY Z08_DATA DESC"

	If Select("QUERY") > 0
		dbSelectArea("QUERY")
		dbCloseArea()
	EndIf
		
	MemoWrite("CONFSC01.SQL",cQry)

	cQry:= ChangeQuery(cQry)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),'QUERY',.F.,.T.)   

	While !EOF() //.And. nLei < 2
		Aadd(aRet,QUERY->Z08_COD)
		nLei++
		If QUERY->Z08_FATURA == "S"
			Exit
		EndIf
		Dbskip()
	EndDo 

	RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} LeiAntr
	(long_description)
	@type  Static Function
	@author user
	@since 15/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Localiza()
	
	Local aLoca   := {}
	Local aLocaR  := {}
	Local cNome   := ""

	aAdd( aLoca ,{1,"Nome do Cliente : ",Space(100)	,"@!",'.T.',"",'.T.',80,.F.})  
			
	If !ParamBox(aLoca ,"Localizar",aLocaR)
		Return
	Else
		cNome := aLocaR[1]
	EndIf

	oList:nAt := AScan(aList, {|x| UPPER(AllTrim(cNome)) $ UPPER(StrTran(AllTrim(x[5]), "/", " "))})
	oList:refresh()

Return 

/*/{Protheus.doc} bolmail()
	(long_description)
	@type  Static Function
	@author user
	@since 07/02/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function bolmail()

Local aArea 	:=	GetArea()
Local nCont 	:=	0
Local cBody     :=  corpo()  
Local aArquivos	:=	{}
Local cFile1	:=	''
Local cFile2	:=	''
Local cFile3	:=	''
Local lEmail 	:=	.T.

For nCont := 1 to len(aEmail)
	If aEmail[nCont,01]
		MV_PAR01 := Substr(aEmail[nCont,11],5)
		MV_PAR02 := aEmail[nCont,02]
		
		cBoletos := ""
		cBarra 	 := ""
		cFile3	 := ""

		DbSelectArea("SA1")
		DBSetOrder(1)
		DbSeek(xFilial("SA1")+aEmail[nCont,09]+aEmail[nCont,10])
		cCnpjj := SA1->A1_CGC
		
		If !ExistDir('C:\BOLETOS\'+cCnpjj+'\')
			Makedir('C:\BOLETOS\'+cCnpjj+'\')
		EndIf


		//Gera boleto?
		If SA1->A1_XBOL == "S" .OR. EMPTY(SA1->A1_XBOL)
			DbSelectArea("SE1")
			DbSetOrder(1)
			If Dbseek(avkey(substr(aEmail[nCont,11],1,2),"E1_FILIAL")+Avkey(MV_PAR01,"E1_PREFIXO")+MV_PAR02)
				//While !EOF() .AND. SE1->E1_PREFIXO == MV_PAR01 .AND. SE1->E1_NUM == MV_PAR02 
					//aAreaE1 := GetArea()//+Alltrim(SE1->E1_PARCELA)
					U_CONBOL(.T.,'C:\BOLETOS\'+cCnpjj+'\',substr(aEmail[nCont,11],1,4),'')
					//RestArea(aAreaE1)
					CPYT2S('C:\BOLETOS\'+cCnpjj+'\boleto_'+MV_PAR02+'.pdf','\SPOOL\')
					cFile3 += cBarra + '\SPOOL\boleto_'+MV_PAR02+'.pdf'
					cBarra := ','
					//Dbskip()
				//EndDo
			EndIf
		
		ENDIF
		
		//Danfe ou Recibo de loca็ใo
		If SUBSTR(MV_PAR01,1,1) <> "L"
		
			//(cNota, cSerie, cPasta, ccnpj)
			U_CONDANFE(MV_PAR02,MV_PAR01,'C:\BOLETOS\',cCnpjj)

		else 
			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(substr(aEmail[nCont,11],1,4)+MV_PAR02+MV_PAR01)

			U_CONGEN03(MV_PAR02,MV_PAR01,'C:\BOLETOS\',cCnpjj,substr(aEmail[nCont,11],1,4))
		
		ENDIF

		cRemete := 'nf.erp@connectvending.com.br'
		cDestino := Alltrim(aEmail[nCont,05])
		cDestino += ';'+Alltrim(SUPERGETMV( "MV_XMAILFT", .F., 'faturas@connectvending.com.br' ))
		
		cSubject := 'Faturamento NF'+MV_PAR02+' Cliente - '+SA1->A1_NOME

		If SUBSTR(MV_PAR01,1,1) <> "L"
			CPYT2S('C:\BOLETOS\'+cCnpjj+'\'+MV_PAR02+'.pdf','\SPOOL\')
			CPYT2S('C:\BOLETOS\'+cCnpjj+'\'+MV_PAR02+'.xml','\SPOOL\')
		
		Else
		
			CPYT2S('C:\BOLETOS\'+cCnpjj+'\'+"recibo_loc_"+MV_PAR02+'.pdf','\SPOOL\')

		EnDIf 
		
		//CPYT2S('C:\BOLETOS\'+cCnpjj+'\boleto_'+MV_PAR02+'.pdf','\SPOOL\')
		
		cFile1 := '\SPOOL\'+MV_PAR02+'.pdf'
		cFile2 := '\SPOOL\'+MV_PAR02+'.xml'
		//cFile3 := '\SPOOL\boleto_'+MV_PAR02+'.pdf'
		cFile4 := '\SPOOL\recibo_loc_'+MV_PAR02+'.pdf'

		Aadd(aArquivos,{cFile1,''})
		Aadd(aArquivos,{cFile2,''})
		Aadd(aArquivos,{cFile3,''})
		Aadd(aArquivos,{cFile4,''})
		
		cBody     :=  corpo() 
/*
		If !Empty(aEmail[nCont,14])
			cBody :=  strtran(cBody,"URLFATURAMENTO","URL Faturamento "+aEmail[nCont,14])
		else
			cBody :=  strtran(cBody,"URLFATURAMENTO","")
		ENDIF
*/
		cBody :=  strtran(cBody,"URLFATURAMENTO","")

		//U_CONMAIL(cRemete,cDestino,cSubject,cBody,aArquivos,.T.) 
		lEmail := U_EnviarEmail(cDestino,cSubject,cBody,cFile1+','+cFile2+','+cFile3+','+cFile4,.f.)  
	EndIf 
Next nCont

RestArea(aArea)

Return


/*/{Protheus.doc} Corpo
    (long_description)
    @type  Static Function
    @author user
    @since 07/03/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function corpo

Local cRet := ""

cRet := If(val(substr(time(),1,2))<12 .and.val(substr(time(),1,2))>=0,'Bom dia','Boa tarde' )+'<br><br>'


cRet += "Prezados(as),<br><br>"
cRet += "Voc๊ estแ recebendo em anexo a fatura referente ao consumo de doses ou loca็ใo de sua(s) mแquina(s) de caf้.<br><br>"
cRet += "Em caso de d๚vidas, basta entrar em contato conosco.<br><br>"

cRet += "URLFATURAMENTO"

cRet += "<br><br>Atenciosamente,<br><br>"

cRet += "Connect Vending Com้rcio de Mแquinas Automatizadas Ltda.<br><br>"

cRet += "Dicas de Seguran็a<br>"
cRet += "Fique atento: Seus boletos sempre chegarใo pelo remetente do Dominio: <p> CONNECTVENDING.COM.BR </p><br>"
cRet += "Ex.: noreply@connectvending.com.br financeiro@connectvending.com.br<br>"
cRet += "Ao pagar confira sempre o CNPJ e o FAVORECIDO<br>"
cRet += "CONNECT VENDING<br>"

Return(cRet)

/*/{Protheus.doc} abatfat(cNumSr,cLeit,cSelec,cDtAnt)
	(long_description)
	@type  Static Function
	@author user
	@since 08/02/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function abatfat(cNumSr,cLeit,cSelec,cDtAnt)

Local aArea := GetArea()
Local nRet  := 0
Local cQuery 

cQuery := "SELECT Z08_QTDLID FROM "+RetSQLName("Z08")
cQuery += " WHERE Z08_FILIAL='"+xFilial("Z08")+"'"
cQuery += " AND Z08_NUMSER='"+cNumSr+"'"
cQuery += " AND Z08_COD<>'"+cLeit+"'"
cQuery += " AND Z08_SELECA='"+cSelec+"'"
cQuery += " AND Z08_DATA<='"+cDtAnt+"'"
cQuery += " AND D_E_L_E_T_=' '"
cQuery += " ORDER BY Z08_DATA DESC"

If Select("QUERY") > 0
	dbSelectArea("QUERY")
	dbCloseArea()
EndIf
	
MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QUERY',.F.,.T.)

nRet := QUERY->Z08_QTDLID

RestArea(aArea)

Return(nRet)

/*/{Protheus.doc} resumfat
	(long_daItens)
	@type  Stati
	Local aArea	:=	GetArea()
	
	RestArea(aArea)
	 Function
	@
	@since 09/02/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function resumfat(aItens,aItSFt,lLoc,cForFat)

Local aArea	:=	GetArea()
Local nCont :=  0
Local nToQt :=  0
Local nToVl :=  0
Local lRet  :=  .F.
Local nToQt2 :=  0
Local nToVl2 :=  0
Local oResumo,oGrRes,oResm1,oResm2,oLRes
Local aAux  :=  {}
Local nOpc  :=  0
Local aAuxB	:=	{}

Asort(aItens,,,{|x,y| x[1] < y[1]})

For nCont := 1 to len(aItens)
	Aadd(aAux,{	aItens[nCont,01],;
				If(lLoc,'Locacao',Posicione("SB1",1,xFilial("SB1")+aItens[nCont,01],"B1_DESC")),;
				If(lLoc,1,aItens[nCont,02]),;
				If(lLoc,aItens[nCont,02],aItens[nCont,03]),;
				If(lLoc,aItens[nCont,02],aItens[nCont,03]) * If(lLoc,1,aItens[nCont,02]) })

	nToQt += If(lLoc,1,aItens[nCont,02])
	nToVl += If(lLoc,1,aItens[nCont,02]) * If(lLoc,aItens[nCont,02],aItens[nCont,03])
Next nCont

If len(aAux) > 0
	Aadd(aAux,{'','Total',nToQt,,nToVl})

	If len(aItSFt) > 0
		Aadd(aAux,{'','',,,})
		Aadd(aAux,{'','Itens sem cobran็a',,,})
		nToQt2 := 0
		nToVl2 := 0
		For nCont := 1 to len(aItSFt)
			nPos := ascan(aAux,{|x| Alltrim(x[1]) == Alltrim(aItSFt[nCont,01])})

			If nPos == 0
				Aadd(aAux,{	aItSFt[nCont,01],;
					Posicione("SB1",1,xFilial("SB1")+aItSFt[nCont,01],"B1_DESC"),;
					aItSFt[nCont,02],;
					aItSFt[nCont,03],;
					aItSFt[nCont,03] * aItSFt[nCont,02] })
			Else
				aAux[nPos,03] += aItSFt[nCont,02]
			EndIf 

			nToQt2 += aItSFt[nCont,02]
			nToVl2 += aItSFt[nCont,02] * aItSFt[nCont,03]

		Next nCont

		Aadd(aAux,{'','Total',nToQt2,,nToVl2})
		Aadd(aAux,{'','',,,})
		Aadd(aAux,{'','Total Consumido',nToQt+nToQt2,,nToVl+nToVl2})
		
	EndIf

	If cQuinze == "2" .And. cForFat == "2"
		Aadd(aAux,{'','',,,})
		Aadd(aAux,{'','Doses abatidas quinzena anterior',,,})
		
		nToQt := 0
		nToVl := 0
		
		For nCont := 1 to len(aAbater) 
			If aList[oList:nAt,01] == aAbater[nCont,01]
				nPos := Ascan(aAuxB,{|x| Alltrim(x[1]) == Alltrim(aAbater[nCont,02])})
				If nPos == 0
					Aadd(aAuxB,{aAbater[nCont,02],;
								Posicione("SB1",1,xFilial("SB1")+aAbater[nCont,02],"B1_DESC"),;
								aAbater[nCont,03],;
								aAbater[nCont,04],;
								aAbater[nCont,03]*aAbater[nCont,04]})
				else
					aAuxB[nPos,03] += aAbater[nCont,03]
					aAuxB[nPos,05] += aAbater[nCont,03]*aAbater[nCont,04]
				EndIF 

				nToQt += aAbater[nCont,03]
				nToVl += aAbater[nCont,03]*aAbater[nCont,04]
				lAbate := .T.
			EndIf
		Next nCont

		For nCont := 1 to len(aAuxB)
			Aadd(aAux,aAuxB[nCont])
		Next nCont

		nPosDosC := Ascan(aAux,{|x| Alltrim(x[1]) == 'DOSE COMP'})
		nPosItCm := Ascan(aItens,{|x| Alltrim(x[1]) == 'DOSE COMP'})

		If nPosDosC > 0
			iF aAux[nPosDosC,3]-nToQt > 0
				aAux[nPosDosC,3] := round(aAux[nPosDosC,3]-nToQt,0)
				aAux[nPosDosC,5] := aAux[nPosDosC,3] * aAux[nPosDosC,4]
			/*else
				aAux[nPosDosC,3] := 0
				aAux[nPosDosC,5] := 0 */
			EndIf 

			If nPosItCm > 0 .And. aAux[nPosDosC,3] > 0
				aItens[nPosItCm,02] := aAux[nPosDosC,3]
			EndIf 

			nNewQtd := 0
			nNewVlr := 0
			nPosTot := ascan(aAux,{|x| Alltrim(upper(X[2])) == 'TOTAL'})

			For nCont := 1 to nPosTot - 1
				nNewQtd += aAux[nCont,03]
				nNewVlr += aAux[nCont,05]
			Next nCont

			aAux[nPosTot,03] := round(nNewQtd,0)
			aAux[nPosTot,05] := nNewVlr

		EndIf 

		If nPosDosC > 0
			If aAux[nPosDosC,3] <= 0
				Adel(aAux,nPosDosC)
				Asize(aAux,len(aAux)-1)
			EndIf
		EndIf

		Aadd(aAux,{'','Totais',nToQt,,nToVl})
		
	EndIf 

	oResumo    := MSDialog():New( 092,232,531,1139,"Resumo Faturamento",,,.F.,,,,,,.T.,,,.T. )

		oGrRes     := TGroup():New( 008,016,192,432,"Itens para o pedido",oResumo,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{020,020,188,428},,, oGrRes ) 
		oLRes 	   := TCBrowse():New(020,020,405,170,, {'Produto','Descri็ใo','Qtd.','Vlr Unit.','Valor Fat.'},;
								{40,70,30,30,30},;
								oGrRes,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, oFont2,,,  ,,.F.,,.T.,,.F.,,,)
		
		oLRes:SetArray(aAux)
		oLRes:bLine := {||{	aAux[oLRes:nAt,01],;
							aAux[oLRes:nAt,02],;
							Transform(aAux[oLRes:nAt,03],"@E 999,999"),;
							Transform(aAux[oLRes:nAt,04],"@E 999.99"),;
							Transform(aAux[oLRes:nAt,05],"@E 999,999.99")}}

		oResm1     := TButton():New( 196,156,"Confirmar",oResumo,{||oResumo:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
		oResm2     := TButton():New( 196,212,"Cancelar",oResumo,{||oResumo:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

	oResumo:Activate(,,,.T.)
else
	MsgAlert("Sem Faturamento")
EndIf 

If nOpc == 1
	lRet := .T.
EndIF 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} estorfat
cription)
	@type  Stati	@author user
	@since 09/02/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function estorfat(cPedido,cNota)

Local cFilFat  := substr(aList3[oList3:nAt,08],1,4)
Local aCabec   := {}
Local aItens   := {}
Local aLinha   := {}
Local nCont	   := 0
Local nX 	   := 0
Local cBkpcFil := cFilant

cFilant := cFilFat

Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .F.

If !Empty(cNota)
	MsgAlert("Somente pedidos nใo faturados podem ser estornados")
	Return 
EndIf 

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(cFilFat+cPedido)

aadd(aCabec, {"C5_NUM"		, cPedido			,	Nil})
aadd(aCabec, {"C5_TIPO"		, "N"				,   Nil})
aadd(aCabec, {"C5_CLIENTE"	, SC5->C5_CLIENTE	,   Nil})
aadd(aCabec, {"C5_LOJACLI"	, SC5->C5_LOJACLI	,   Nil})
aadd(aCabec, {"C5_LOJAENT"	, SC5->C5_LOJAENT	,  	Nil})
aadd(aCabec, {"C5_CONDPAG"	, SC5->C5_CONDPAG	, 	Nil})

DbSelectArea("SC6")
DbSetOrder(1)
DbSeek(cFilFat+cPedido)
While !EOF() .AND. SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM
	
	aLinha := {}
	aadd(aLinha,{"C6_ITEM"		, SC6->C6_ITEM	  , Nil})
	aadd(aLinha,{"C6_PRODUTO"	, SC6->C6_PRODUTO , Nil})
	aadd(aLinha,{"C6_QTDVEN"	, SC6->C6_QTDVEN  , Nil})
	aadd(aLinha,{"C6_PRCVEN"	, SC6->C6_PRCVEN  , Nil})
	aadd(aLinha,{"C6_PRUNIT"	, SC6->C6_PRUNIT  , Nil})
	aadd(aLinha,{"C6_VALOR"		, SC6->C6_VALOR   , Nil})
	aadd(aLinha,{"C6_TES"		, SC6->C6_TES     , Nil})
	aadd(aItens, aLinha)

	cFilSC9 := xFilial("SC9")
    // posiciona SC9 a partir da SC6
    SC9->(dbSetOrder(1)) // C9_FILIAL, C9_PEDIDO, C9_ITEM
    If SC9->(dbSeek(cFilSC9 + SC6->C6_NUM + SC6->C6_ITEM)) // C9_FILIAL, C9_PEDIDO, C9_ITEM
    	A460Estorna(.T.)
	EndIf
     
	
	SC6->(Dbskip())
EndDo 

MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 5)

If !lMsErroAuto
	For nCont := 1 to len(aList5B)
		If aList5B[nCont,01] == aList[oList:nAt,01]
			If len(aList5B[nCont]) > 4
				For nX := 5 to len(aList5B[nCont])
					If aList5B[nCont,nX,17] == cPedido
						DbSelectArea("Z08")
						DbGoto(aList5B[nCont,nX,16])
						RECLOCK("Z08", .F. )
						Z08->Z08_PEDIDO := ' '
						Z08->Z08_FATURA := ' '
						Z08->Z08_CONSUM := 0
						Z08->Z08_VLRFAT := 0
						Z08->Z08_NOTA	:= ' '
						Z08->Z08_SERIE	:= ' '
						Z08->(MSUNLOCK()) 
					EndIF
				Next nX
			EndIf 
		EndIf 
	Next nCont
	
	nPosic := Ascan(aList3B,{|x| x[1]+x[5] == aList3[oList3:nAt,01]+aList3[oList3:nAt,05]})

	MsgAlert("Pedido excluํdo com sucesso, se deseja faturar esta leitura, saia e entre novamente na rotina de faturamento")
	Adel(aList3,oList3:nAt)
    ASize(aList3,len(aList3)-1)
	Adel(aList3B,nPosic)
    ASize(aList3B,len(aList3B)-1)
	oList3:refresh()
	oDlg1:refresh()
Else
	MsgAlert("Nใo foi possํvel excluir o pedido")
EndIf

cFilant := cBkpcFil

Return

/*/{Protheus.doc} ValFat
	(long_description)
	@type  Static Function
	@author user
	@since 21/06/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function ValFat()
	
//
Local aArea :=	GetArea()
Local nConP
Local nCont
Local nCon5
Local lOk 	:=	.F.


If cLocacS == "S"
	MsgAlert("Loca็๕es podem ser faturadas sem libera็ใo")
	return
EndIf 

Asort(aList2B,,,{|x,y| x[4] < y[4]})
Asort(aList5B,,,{|x,y| x[1]+x[2] < y[1]+y[2]})

For nConP := 1 to len(aList)
	lOk 	:=	.F.
	cForFat :=	aList[nConP,14]
	cTipFat	:=	aList[nConP,15]
	nPos2B  :=	Ascan(aList2B,{|x| x[4] == aList[nConP,01]})
	//If cTipFat $ "1/2/3"
	For nCont := nPos2B to len(aList2B)
		If aList2B[nCont,04] == aList[nConP,01]
			
			nPosL5 := Ascan(aList5B,{|x| x[1]+x[2] == aList2B[nCont,04]+aList2B[nCont,01]})

			For nCon5 := nPosL5 to len(aList5B)
				If aList5B[nCon5,01] == aList[nConP,01]

					If len(aList5b[nCon5]) > 4
						If !Empty(aList5b[nCon5,5,6])
							lOk 	:=	.T.
						ELSE
							lOk 	:=	.F.
							EXIT
						endif
					else
						lOk 	:=	.F.
						EXIT
					EndIf
				else
					
					exit	
				EndIf 
			Next nCon5
		Else 
			EXIT		
		EndIf 
	Next nCont

	If lOk
		aList[nConP,len(aQtdH)+1] := 1
		lLiberaF := .T.
	EndIf 

Next nConP

Fhelp(oList:nAt)

RestArea(aArea)

Return


/*/{Protheus.doc} User Function nomeFunction
	(long_description)
	@type  Function
	@author user
	@since 29/08/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function CONFSCX1()

Local cQuery 
Local aRet 		:=	{}
Local aPergs	:=	{}
Local dDtFat1	:=	ctod(' / / ')
Local dDtFat2	:=	ctod(' / / ')
Local cCliDe	:=	space(9)
Local cCliAt	:=	'ZZZZZZZZZ'
Local cFilDe	:=	space(4)
Local cFilAt	:=	'ZZZZ'

Private aDados	:=	{}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

aAdd( aPergs ,{1,"Filial de : "  ,cFilDe  ,"@!",'.T.',"",'.T.',60,.F.})  
aAdd( aPergs ,{1,"Filial At้: "  ,cFilAt  ,"@!",'.T.',"",'.T.',60,.F.}) 
aAdd( aPergs ,{1,"Faturado de : ",dDtFat1 ,"@!",'.T.',"",'.T.',60,.T.})  
aAdd( aPergs ,{1,"Faturado At้: ",dDtFat2 ,"@!",'.T.',"",'.T.',60,.T.}) 
aAdd( aPergs ,{1,"Cliente de : " ,cCliDe  ,"@!",'.T.',"SA1",'.T.',60,.F.})  
aAdd( aPergs ,{1,"Cliente At้: " ,cCliAt  ,"@!",'.T.',"SA1",'.T.',60,.F.}) 
aAdd( aPergs ,{2,"Tipo Nota?"    ,"1" 	  ,{"1=Todos","2=Somente Loca็ใo"},080,'',.T.})


If !ParamBox(aPergs ,"Parโmetros ",aRet)
	Return
EndIF 

cQuery := "SELECT F2_DOC,A1_NOME,A1_NREDUZ,F2_COND,F2_CLIENTE,F2_LOJA,F2_FILIAL,F2_SERIE,C5_XTPPED,A1_EMAIL,"
cQuery += " ISNULL(CAST(CAST(Z08_URLFAT AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS URL,"
cQuery += " MAX(D2_PEDIDO) AS C5_NUM,"
cQuery += " MAX(C6_CONTRT) AS CONTRT"
cQuery += " FROM "+RetSQLName("SF2")+" F2
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM=D2_ITEMPV AND C6.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA AND C5.D_E_L_E_T_=' ' AND C5_XTPPED NOT IN('A')"
cQuery += " LEFT JOIN "+RetSQLName("Z08")+" Z08 ON Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_PEDIDO=C5_NUM AND Z08_NOTA=F2_DOC AND Z08.D_E_L_E_T_=' '"
cQuery += " WHERE F2.D_E_L_E_T_=' '"
cQuery += " AND F2_FILIAL BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"'" 
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(aRet[3])+"' AND '"+dtos(aRet[4])+"'"
cQuery += " AND F2_CLIENTE BETWEEN '"+aRet[5]+"' AND '"+aRet[6]+"'"

If aRet[7] == "2"
	cQuery += " AND F2_SERIE LIKE 'L%'"
EndIf 

cQuery += " GROUP BY F2_DOC,A1_NOME,A1_NREDUZ,F2_COND,F2_CLIENTE,F2_LOJA,F2_FILIAL,F2_SERIE,C5_XTPPED,A1_EMAIL,Z08_URLFAT"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
DbSelectArea("TRB")   

While !EOF()
/*true ou false	-	enviado ou nao
nota		-	numero da nota
cliente		-	razao / fantasia
enviado ou nao	-	texto
email		-	email cadastro sa1
contrato	-	aam_contrt
pedido		-	numero pedido gerado
condpgto	-	codigo descricao
codigo cliente	-	codigo docliente
loja		-	loja cliente
filial+serie	-	filial faturamento + serie da nota
12		-	vazio*/
	Aadd(aDados,{	.F.,;
					TRB->F2_DOC,;
					TRB->A1_NOME+" / "+TRB->A1_NREDUZ,;
					'',;
					TRB->A1_EMAIL,;
					TRB->CONTRT,;
					TRB->C5_NUM,;
					TRB->F2_COND,;
					TRB->F2_CLIENTE,;
					TRB->F2_LOJA,;
					TRB->F2_FILIAL+TRB->F2_SERIE,;
					'',;
					TRB->C5_XTPPED,;
					TRB->URL})
	Dbskip()
ENDDO

If len(aDados)
	NFBOL(2)
EndIf 

Return

/*/{Protheus.doc} urlfat
	(long_description)
	@type  Static Function
	@author user
	@since 26/09/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function urlfat(curl)

SetPrvt("oUrl","oGrp1","oMGet1","oBtn1")

oUrl       := MSDialog():New( 092,232,452,663,"Url de Faturamento",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 004,004,156,204,"",oUrl,CLR_BLACK,CLR_WHITE,.T.,.F. )
oMGet1     := TMultiGet():New( 012,008,{|u| If(PCount()>0,curl:=u,curl) },oGrp1,192,140,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
oMGet1:Disable()
oBtn1      := TButton():New( 160,084,"Sair",oUrl,{|| oUrl:end()},037,008,,,,.T.,,"",,,,.F. )

oUrl:Activate(,,,.T.)

Return
