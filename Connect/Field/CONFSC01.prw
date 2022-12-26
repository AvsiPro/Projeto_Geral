#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"    
#INCLUDE "TBICONN.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "fileio.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CONFSC01 ³ Autor ³ Alexandre Venancio    ³ Data ³ 10/10/22 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³   Rotina de faturamento e historico.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CONFSC01

Local aPergs	:=	{}
Local aRet		:=	{}
Local cCond		:=	space(3)
Local nCont 
Local nJ 

Private cPeri		:=	space(4)

Private oDlg1,oGrp1,oGrp2,oSay1,oSay2,oSay6,oGrp3,oBrw1
Private oGrp5,oBrw3,oBtn1,oMenu,oGrp6,oSay3,oSay4,oSay5
Private oList,oList2,oList3,oList4,oList5,oGrp4,oSay7,oSay8
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

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF
        
oFont4:Bold := .T.
 
/*                             
alist                                               aList2b							aList3b            		aList4b

1 - Número do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descrição					2 - Data Emissao		2 - Desricao
3 - Código Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endereço Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condição de Pagamento                                                                                   9 - Quantidade
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
 
aAdd( aPergs ,{1,"Data de Faturamento : ",cCond,"@!",'.T.',"SE4",'.T.',40,.F.})  
aAdd( aPergs ,{1,"Período Faturamento 'MMAA' : ",cPeri,"@E 9999",'.T.',"",'.T.',40,.F.})  
aAdd( aPergs ,{2,"Faturamento Quinzenal?","1",{"1=Primeira","2=Segunda"},080,'',.T.})
        
If !ParamBox(aPergs ,"Parametros ",aRet)
	Return
Else
	cCond := aRet[1]
	cPeri := aRet[2]
	cQuinze := aRet[3]
EndIf

Processa( { || Busca(cCond,cQuinze),"Aguarde"})
//Aadd(aList,{'',0,'',})
Aadd(aList2,{'','',0})
Aadd(aList3,{'','',0})
Aadd(aList4,{'','',0})
Aadd(aList5,{'','','','',0,'',0,0,0,0,'','','',''})

oDlg1      := MSDialog():New( 092,232,770,1672,"Histórico de Faturamentos",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 002,004,336,710,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oGrp2      := TGroup():New( 008,008,072,612,"Dados do Cliente",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 024,012,{||"Cliente"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,032,008)
		oSay2      := TSay():New( 024,052,{||"oSay2"},oGrp2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,492,016)
		oSay3      := TSay():New( 040,012,{||"Endereço"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay4      := TSay():New( 040,052,{||"oSay4"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,392,008)
		oSay5      := TSay():New( 052,012,{||"Contrato"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 052,052,{||"oSay6"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,552,008)
		oSay7      := TSay():New( 062,360,{||"Valor Excedente"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,552,008)
		oSay8      := TSay():New( 062,052,{||"Parâmetros selecionados / Data Fat. "+cCond+" / Periodo "+cPeri+" / Quinzena "+cQuinze},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,552,008)
	 
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
		{'Ativo','Modelo','Vlr Locação','Qtd. Min.','Valor Min.','Qtd.Total','Vlr.Fat.','Vlr.Compl.'},;
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
		oList5 	   := TCBrowse():New(209,174,532,118,, {'Seleção','Produto','Descrição','Data Ant.','Leit.Ant.','Data Atual','Leit.Atual','Consumo','Valor Un.','Valor Fat.','Penult.Data','Penult.Leit'},{30,40,70,30,30,30,30,30,30,30,30,30},;
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
							aList5[oList5:nAt,13],;
							aList5[oList5:nAt,14]}}

	oGrp5      := TGroup():New( 076,520,202,708,"Faturamento",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oList3 	   := TCBrowse():New(084,524,182,115,, {'Pedido','Emissão','Nota','Vlr Faturamento'},{30,40,40},;
	                            oGrp5,,,,{|| FHelp2(oList3:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{ Alltrim(aList3[oList3:nAt,01]),;
							 aList3[oList3:nAt,02],;
							 aList3[oList3:nAt,04],;
		 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}
	
	For nCont := 1 to len(aList)
		oList:nAt := nCont
		Fhelp(nCont)
	Next nCont

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

//Botões diversos
oMenu := TMenu():New(0,0,0,0,.T.)
// Adiciona itens no Menu
oTMenuIte1 := TMenuItem():New(oDlg1,"Procurar",,,,{|| procurar()},,,,,,,,,.T.)
oTMenuIte2 := TMenuItem():New(oDlg1,"Listar-Faturamento",,,,{|| Processa({||PreFat(),"Aguarde"})} ,,,,,,,,,.T.)
oTMenuIte3 := TMenuItem():New(oDlg1,"Faturar",,,,{|| Processa({||GeraPv(0),"Aguarde"})} ,,,,,,,,,.T.)
oTMenuIte4 := TMenuItem():New(oDlg1,"Envio NF/Boleto",,,,{|| NFBol()} ,,,,,,,,,.T.)
oTMenuIte5 := TMenuItem():New(oDlg1,"Fechamento Mensal",,,,{|| Fechamento()} ,,,,,,,,,.T.)
oTMenuIte6 := TMenuItem():New(oDlg1,"Rescisão Contrato",,,,{|| Rescisao(oList:nAt)} ,,,,,,,,,.T.)
oTMenuIte7 := TMenuItem():New(oDlg1,"Impressoes",,,,{|| Processa({||U_CONFSR02(aList,alist2,aList3,aList4,aList5,oSay6:cTitle),"Aguarde"})} ,,,,,,,,,.T.)


oMenu:Add(oTMenuIte1)
oMenu:Add(oTMenuIte2)
oMenu:Add(oTMenuIte3)
oMenu:Add(oTMenuIte4)
oMenu:Add(oTMenuIte5)
oMenu:Add(oTMenuIte6)
oMenu:Add(oTMenuIte7)

// Cria botão que sera usado no Menu  
oTButton1 := TButton():New( 025, 640, "Opções",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
// Define botão no Menu
oTButton1:SetPopupMenu(oMenu)

//ao clicar com o botão direito no grid de ativos.
	MENU oMenuP POPUP 
	MENUITEM "Faturar" ACTION (Processa({|| GeraPv(1)},"Aguarde"))
	ENDMENU                                                                           

	oList:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }

//ao clicar com o botão direito no grid de faturamentos.
	MENU oMenuP3 POPUP 
	MENUITEM "Itens Pedido" ACTION (Processa({|| ItensPv(aList3[oList3:nAt,01],aList3[oList3:nAt,04])},"Aguarde"))
	ENDMENU                                                                           

	oList3:bRClicked := { |oObject,nX,nY| oMenuP3:Activate( nX, (nY-10), oObject ) }

oDlg1:Activate(,,,.T.)

//Reset Environment

Return                                
                                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca os contratos e historicos de faturamentos existentesº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Busca(cCond,cQuinze)

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


cQuery := "SELECT AAN_CONTRT,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,"
cQuery += " B1_DESC,AAN_XCBASE,AAN_QUANT,AAN_ULTEMI,"
cQuery += " AAN_XMINQT,AAN_XVLRMI,"
cQuery += " AAN_VLRUNI,AAN_INICOB,AAN_FIMCOB,AAN_CONPAG,"
cQuery += " E4_COND,E4_DESCRI,A1_NREDUZ,A1_NOME,A1_END,"
cQuery += " A1_BAIRRO,A1_MUN,"
cQuery += " AAM_INIVIG,AAM_FIMVIG,A1_EMAIL,'' AS AAN_XISENT,"
cQuery += " AAM_XFORFA, AAM_XTIPFA,'' AS AAM_XPERCT,"
cQuery += " '' AS AAM_XRENOV,AAN_FILIAL,AAM_XPRDCM"
cQuery += " FROM "+RetSQLName("AAN")+" AAN"
cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT AND AAM.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SE4")+" E4 ON E4_FILIAL='"+xFilial("SE4")+"' AND E4_CODIGO=AAN_CONPAG AND E4.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=AAN_CODPRO AND B1_XCARACT<>'D' AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"' AND AAN.D_E_L_E_T_=''" 

If !Empty(cCond)
	cQuery += " AND AAN_CONPAG='"+cCond+"'" 
EndIf

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
      
/*
	1			2		3			4		5		  6			7		 8			9  			10		
AAN_CONTRT,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,B1_DESC,AAN_XCBASE,AAN_QUANT,AAN_ULTEMI,AAN_VLRUNI,
	11			12		13		  14		15		16		  17	  18	 19		   20      21		  22          23       24
AAN_INICOB,AAN_FIMCOB,AAN_CONPAG,E4_COND,E4_DESCRI,A1_NREDUZ,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,AAM_INIVIG,AAM_FIMVIG,A1_EMAIL,AAN_XISENT
	25			26			27		28      29   30
AAM_XFORFA,AAM_XTIPFA,AAM_XPERCT,AAM_XRENOV,0,AAN_FILIAL
*/

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

	//Se o inicio da cobranca é maior que o primeiro dia do mes, então deve-se cobrar pro-rata.
	If stod(TRB->AAN_INICOB) > firstday(ddatabase)
		//Quantidade de dias a serem cobrados até o final do mês (segundo o Cassio os contratos sempre são cobrados do dia 01 ao ultimo dia do mes
		nDiasCb := lastday(ddatabase) - stod(TRB->AAN_INICOB)
		//Valor a ser cobrado com a pro-rata
		nNewVlr := nVlrPro * nDiasCb                                                                                    
	//Se o fim da cobranca é menor que o ultimo dia do mes, então deve-se cobrar pro-rata dos dias em que a maquina saiu.
	ElseIf stod(TRB->AAN_FIMCOB) < lastday(ddatabase)
		//Quantidade de dias a serem cobrados do primeiro até a data da saída da maquina do cliente.
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
					TRB->AAM_XPRDCM})
    Else
    	//Soma todos os itens do contrato para pegar o valor total.
    	aList[nPos1,02] += nNewVlr //(TRB->AAN_QUANT*TRB->AAN_VLRUNI)
    EndIf
    
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
					0})								//11

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
  
Asort(aList,,,{|x,y| x[1] < y[1]})
                
For nCont := 1 to len(aAux3)         
	//Buscando os pedidos faturados
	cQuery := "SELECT C6_NUM,C5_EMISSAO,C6_NOTA,C6_VALOR,"
	cQuery += " C6_DESCRI,C6_ITEM,C6_QTDVEN,C6_SERIE,C6_FILIAL"
	cQuery += " FROM "+RetSQLName("SC6")+" C6"
	cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL "
	cQuery += " AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5.D_E_L_E_T_=''"
	cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"'"
	cQuery += " AND C6_CONTRT='"+aAux3[nCont,01]+"' "
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
							TRB->C6_FILIAL+Alltrim(TRB->C6_SERIE)})
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

For nCont := 1 to len(aList3b)
	nPos := Ascan(aList,{|x| Alltrim(x[1]) == aList3b[nCont,05]})
	If nPos > 0 .And. (strzero(month(aList3b[nCont,02]),2)+cvaltochar(year(aList3b[nCont,02])) == strzero(month(ddatabase),2)+cvaltochar(year(ddatabase)))
		If aList[nPos,len(aQtdH)+1] == 0
			IF !Empty(aList3b[nCont,04])
				aList[nPos,len(aQtdH)+1] += 2
			Else
				aList[nPos,len(aQtdH)+1] += 1
			EndIf
		EndIf
	EndIf
Next nCont


cQuery := "SELECT AAM_CONTRT,DA1_CODPRO,B1_DESC,DA1_PRCVEN"
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
					TRB->DA1_PRCVEN})
	Dbskip()
EndDo 

For nCont := 1 to len(aList5b)
	
	aLeitura := {}
	aLeitura 	:=	LeiAntr(aList5b[nCont,01],aList5b[nCont,02],'')

	cQuery := "SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,Z08_DATA,Z08_CONTRT,Z08_FATURA" 
	cQuery += "  FROM "+RetSQLname("Z08")+" Z08" 
	cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
	cQuery += "   AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' ' 
	
	If len(aLeitura) > 0
		cQuery += " WHERE Z08_COD='"+aLeitura[1]+"'"
		cQuery += "  AND Z08.D_E_L_E_T_=' '
	ELSE
		cQuery += " WHERE  Z08_COD IN(SELECT MAX(Z08_COD) FROM "+RetSQLname("Z08")
		cQuery += "     	WHERE  Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+aList5b[nCont,02]+"'"
		cQuery += "  	AND Z08_CONTRT='"+aList5b[nCont,01]+"' AND D_E_L_E_T_=' ')"
		cQuery += " AND Z08.D_E_L_E_T_=' '"
	EndIF 
	
	cQuery += "  UNION 
	cQuery += "  SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,Z08_DATA,Z08_CONTRT,Z08_FATURA" 
	cQuery += "  FROM "+RetSQLname("Z08")+" Z08"
	cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
	cQuery += "		AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' '" 
	
	If len(aLeitura) > 0
		cQuery += " WHERE Z08_COD='"+aLeitura[2]+"'"
		cQuery += "  AND Z08.D_E_L_E_T_=' '"
	Else 
		cQuery += "  WHERE  Z08_COD IN(SELECT MAX(Z08_COD)-1 FROM "+RetSQLname("Z08")
		cQuery += "		WHERE  Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+aList5b[nCont,02]+"'" 
		cQuery += "  	AND Z08_CONTRT='"+aList5b[nCont,01]+"' AND D_E_L_E_T_=' ')"
		cQuery += " AND Z08.D_E_L_E_T_=' '"
	EndIf 

	cQuery += "  ORDER BY Z08_COD DESC"

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
		nPos := Ascan(aAux5,{|x| Alltrim(x[1]) == strzero(val(TRB->Z08_SELECA),2)})
		nPos2 := Ascan(aTabPrc,{|x| x[1]+x[2] == TRB->Z08_CONTRT+TRB->Z08_PRODUT})

		If nPos == 0
			Aadd(aAuxL5,strzero(val(TRB->Z08_SELECA),2))
			Aadd(aAuxL5,TRB->Z08_PRODUT)
			Aadd(aAuxL5,TRB->B1_DESC)
			Aadd(aAuxL5,'')
			Aadd(aAuxL5,0)			
			Aadd(aAuxL5,TRB->Z08_DATA)
			Aadd(aAuxL5,TRB->Z08_QTDLID)
			Aadd(aAuxL5,0)
			
			If nPos2 > 0
				Aadd(aAuxL5,aTabPrc[nPos2,04])
			Else 
				Aadd(aAuxL5,0)
				
			EndIf 

			Aadd(aAuxL5,0)
			
			Aadd(aAuxL5,Z08_COD)
			Aadd(aAuxL5,Z08_FATURA)

			Aadd(aAuxL5,'')
			Aadd(aAuxL5,'')
			
			If len(aAuxL5) > 0
				Aadd(aAux5,aAuxL5)
			EndIf
		Else 
			If Empty(aAux5[nPos,04])
				aAux5[nPos,04] := TRB->Z08_DATA
				aAux5[nPos,05] := TRB->Z08_QTDLID
			ElseIf Empty(aAux5[nPos,06])
				aAux5[nPos,06] := TRB->Z08_DATA
				aAux5[nPos,07] := TRB->Z08_QTDLID
			Endif 

			If nPos2 > 0 .And. aAux5[nPos,09] == 0
				aAux5[nPos,09] := aTabPrc[nPos2,04]
			EndIf 
		EndIf 
		Dbskip()
	EndDo 

	Aeval(aAux5,{|x| x[8] := x[7] - x[5]})
	Aeval(aAux5,{|x| x[10] := x[9] * x[8]})
	
	For nAux := 1 to len(aAux5)
		Aadd(aList5b[nCont],aAux5[nAux])
	Next nAux

Next nCont

//If cQuinze == "2"
	For nCont := 1 to len(aList)
		If (aList[nCont,14] == "2" .And. cQuinze == "2") .Or. (aList[nCont,14] == "1")
			For nAux := 1 to len(aList5B)
				If aList5B[nAux,01] == aList[nCont,01]
					Recalc(aList5B[nAux],nAux)
				EndIf 
			Next nAux 
		EndIf 
	Next nCont 
//EndIf 


RestArea(aArea)

Return                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Atualiza os grids de acordo com o grid principal (Contratos±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
/*                             
alist                                               aList2b							aList3b            		aList4b

1 - Número do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descrição					2 - Data Emissao		2 - Desricao
3 - Código Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endereço Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condição de Pagamento                                                                                   9 - Quantidade
10- Descricao da condicao
11- Inicio Vigencia
12- Fim Vigencia
13- Email Cliente 
14- Inicio Multa
15- Prazo
16- Percentual Multa
17- Renovacao Automatica
*/                   

oSay2:settext(aList[nLinha,03]+'-'+aList[nLinha,04]+' - '+aList[nLinha,05]+' - Contrato '+aList[nLinha,01])    
oSay4:settext(aList[nLinha,06]+' - '+aList[nLinha,07]+' - '+aList[nLinha,08])


//oSay6:settext("Dia de Fat. "+Alltrim(cvaltochar(aList[nLinha,09]))+" - Vigência "+cvaltochar(aList[nLinha,11])+" a "+cvaltochar(aList[nLinha,12]))           

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

Asort(aList3,,,{|x,y| x[1] > y[1]})
    
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

Aeval(aList5,{|x| nTotQ += x[8]})
Aeval(aList5,{|x| nTotV += x[10]})

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
							aList5[oList5:nAt,13],;
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

cTexto += " # Tabela de Preço "+AAM->AAM_XCODTA+" "

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

	Aeval(aList2b,{|x| nDifCb += If(x[4] == aList[nLinha2,01],x[9],0)})

	If nDifCb < AAM->AAM_XQTVLM
		cTexto += " - Doses Complementares a serem cobradas "+Transform(AAM->AAM_XQTVLM-nDifCb,"@E 999,999,999")
		aList[nLinha2,20] := AAM->AAM_XQTVLM-nDifCb
	EndIf 
EndIF 

oSay6:settext(cTexto)

If aList[nLinha2,20] > 0
	aList[nLinha2,21] := POSICIONE("DA1",1,XFILIAL("DA1")+AAM->AAM_XCODTA+AAM->AAM_XPRDCM,"DA1_PRCVEN")
	oSay7:settext("Valor Excedente a ser cobrado "+Transform(aList[nLinha2,20]*aList[nLinha2,21],"@E 999,999.99"))
EndIf 

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Localizar contrato por cliente                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			MsgAlert("Não encontrado contrato para este cliente "+aRet[1])
		EndIf
	EndIf
endIF

RestArea(aArea)

Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera o faturamento dos pedidos do mes corrente            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function GeraNF(cPedido,cCond)

Local aArea	:=	GetArea()
Local cNota	:=	''
Private _aPVlNFs	:=	{}
Private _cCondPag	:=	cCond
Private _cSerie		:=	"D"
             

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
		    /*
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
							//SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+_cTESPV,""))) })
		//EndIf
		*/
		DbSelectArea("SC9")
		DbSkip()
	End
EndIf 

If Len(_aPVlNFs) > 0
	/*/

		ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
		±±³Funcao    ³MaPvlNfs  ³ Autor ³Microsiga              ³ Data ³28.08.1999³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Descri‡…o ³Inclusao de Nota fiscal de Saida atraves do PV liberado     ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Retorno   ³                                                            ³±±
		±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
		±±³Parametros³ExpA1: Array com os itens a serem gerados                   ³±±
		±±³          ³ExpC2: Serie da Nota Fiscal                                 ³±±
		±±³          ³ExpL3: Mostra Lct.Contabil                                  ³±±
		±±³          ³ExpL4: Aglutina Lct.Contabil                                ³±±
		±±³          ³ExpL5: Contabiliza On-Line                                  ³±±
		±±³          ³ExpL6: Contabiliza Custo On-Line                            ³±±
		±±³          ³ExpL7: Reajuste de preco na nota fiscal                     ³±±
		±±³          ³ExpN8: Tipo de Acrescimo Financeiro                         ³±±
		±±³          ³ExpN9: Tipo de Arredondamento                               ³±±
		±±³          ³ExpLA: Atualiza Amarracao Cliente x Produto                 ³±±
		±±³          ³ExplB: Cupom Fiscal                                         ³±±
		±±³          ³ExpCC: Numero do Embarque de Exportacao                     ³±±
		±±³          ³ExpBD: Code block para complemento de atualizacao dos titu- ³±±
		±±³          ³ los financeiros.                                           ³±±
		±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
		ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		
		/*/	
		// -> Gera a NF
   		cNota := MAPVLNFS(_aPVlNFs,_cSerie,.F.,.F.,.F.,.F.,.F.,0,0,.F., .F.)
  		
EndIf

RestArea(aArea)

Return(cNota)
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressao do pre-faturamento por data.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PreFat()

Local aArea	:=	GetArea()
Local aPergs := {}
Local aRet	 := {}
Local cResp1 := ''
Local cResp2 := ''

aAdd(aPergs ,{2,"Tipo de Impressão?","1",{"1=Sintético","2=Analitico"},080,'',.T.})
aAdd(aPergs ,{2,"Período de Impressão?","1",{"1=Mês","2=Somente dia"},080,'',.T.})

If !ParamBox(aPergs ,"Informe a opção desejada",@aRet)
	Return
else
	cResp1 := If(aRet[1]=="1",'SINTÉTICO','ANALITICO')
	cResp2 := aRet[2]
EndIf

U_CONFSR01(cResp1,cResp2)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Envio da Nota de Debito e o Boleto para os clientes em   º±±
±±º          ³lote.                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NFBol()

Local aArea		:=	GetArea()
Local nX 

Private oBoleto,oGrupo1,oBrw1,oBotao1,oBotao2,oBotao3,oEmail,oBmp1,oBmp2,oBmp3,oBmp4,oSayB1,oSayB2,oSayB3,oSayB4,oBotao4
Private aEmail	:=	{}
 
For nX := 1 to len(aList3b)
	If strzero(month(aList3b[nX,02]),2)+cvaltochar(year(aList3b[nX,02])) == strzero(month(ddatabase),2)+cvaltochar(year(ddatabase)) .And. !Empty(aList3b[nX,01])
		nPosL1 := Ascan(aList,{|x| x[1] == aList3b[nX,05]})
		Aadd(aEmail,{.F.,aList3b[nX,04],Alltrim(aList[nPosL1,05]),If(!Empty(aList3b[nX,04]),'Enviado','Não enviado'),;
					 aList[nPosL1,13],aList[nPosL1,01],aList3b[nX,01],aList[nPosL1,09],aList[nPosL1,03],aList[nPosL1,04],aList3b[nX,08],''})
	EndIf
Next nX 

If len(aEmail) < 1
	Aadd(aEmail,{.F.,'','','',''})
EndIf

oBoleto    := MSDialog():New( 092,232,660,1043,"Nota/Boleto por Email",,,.F.,,,,,,.T.,,,.T. )

	oGrupo1      := TGroup():New( 004,008,246,400,"Contratos Faturados",oBoleto,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{016,016,248,292},,, oGrp1 ) 
	oEmail 	   := TCBrowse():New(016,016,375,225,, {'','Nota','Cliente','Status','Email'},{5,30,40,40,20},;
                            oGrupo1,,,,{|| /*FHelp(oEmail:nAt)*/},{|| editcol(oEmail:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oEmail:SetArray(aEmail)
	oEmail:bLine := {||{If(aEmail[oEmail:nAt,01],oOk,oNo),; 
						aEmail[oEmail:nAt,02],;
						aEmail[oEmail:nAt,03],; 
						aEmail[oEmail:nAt,04],;  
	 					aEmail[oEmail:nAt,05]}}

	oBotao1    := TButton():New( 260,048,"Inverter Marc.",oBoleto,{||inverte(1)},037,012,,,,.T.,,"",,,,.F. )
	oBotao4    := TButton():New( 260,098,"Marcar/Desm. Todos",oBoleto,{||inverte(2)},037,012,,,,.T.,,"",,,,.F. )
	oBotao2    := TButton():New( 260,179,"Enviar",oBoleto,{||Processa({|| enviar()},"Processando...") },037,012,,,,.T.,,"",,,,.F. )
	oBotao3    := TButton():New( 260,300,"Sair",oBoleto,{||oBoleto:end()},037,012,,,,.T.,,"",,,,.F. )

oBoleto:Activate(,,,.T.)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marcar/Desmarcar itens a enviar por email e incluir email. º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		
		endIf 
	EndIf
EndIf

RestArea(aArea)

Return                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Marcar/Desmarcar todos de uma so vez                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/13/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Enviar notas e boletos por email                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Enviar()

Local aArea		:=	GetArea()
Local cSerNd	:=	Alltrim(cFilAnt+"D") 
Local nQtdLib	:=	0     
Local aArquivos	:=	{}
Local lRetorno	:=  .F.
Local lArqOk	:=	.F.
Local nAkacio
Local nI 
Local nPtro

For nAkacio := 1 to len(aEmail) 
	If aEmail[nAkacio,01]
	 	If Empty(aEmail[nAkacio,02])                 
			dbSelectArea("SC6")
			dbSetOrder(1)	 		
			dbSeek(xFilial("SC6")+aEmail[nAkacio,07])
			While !eof() .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == aEmail[nAkacio,07]
			 	lCredito := .t.
			    lEstoque := .t.
			    lLiber   := .t.
			    lTransf := .f.    
			    lAvEst	:=	.T.
				dbSelectArea("SC9")
				if !dbSeek(xFilial("SC9")+aEmail[nAkacio,07]+SC6->C6_ITEM)
					nQtdLib := SC6->C6_QTDVEN
				   	nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
				Endif
				dbSelectArea("SC6")
				dbSkip()
			Enddo
			
			//Chamada da funcao que fara o faturamento do pedido
			aEmail[nAkacio,02] := GeraNF(aEmail[nAkacio,07],aEmail[nAkacio,08])

			If !Empty(aEmail[nAkacio,02])
				MV_PAR01 := cSerNd
				MV_PAR02 := aEmail[nAkacio,02]                    
		      	aArquivos	:=	{}
		      	//lArqOk := .F.
				cRet := U_AMCFIN01(.T.) 
				cRet := strtran(cRet,".")
				cRet := strtran(cRet," ")
				aEmail[nAkacio,12] := cRet
				Sleep(6000) 
			EndIf  
		Else
			MV_PAR01 := cSerNd
			MV_PAR02 := aEmail[nAkacio,02]                    
	      	aArquivos	:=	{}		
			cRet := U_AMCFIN01(.T.)
			cRet := strtran(cRet,".")
			cRet := strtran(cRet," ")
			aEmail[nAkacio,12] := cRet
			Sleep(6000)				
		EndIf
	EndIf
Next nAkacio                    


For nAkacio := 1 to len(aEmail) 
	If aEmail[nAkacio,01]
		If aEmail[nAkacio,04] == 'Não enviado'
			If !Empty(aEmail[nAkacio,02])
		      	aArquivos	:=	{}
		      	lArqOk := .F.
		  		
		  		If !lArqOk
					For nI := 1 To 10   				                                   //+aEmail[nAkacio,09]+aEmail[nAkacio,10]
    					lArqOk := ChkArq("\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+".pdf")
			      		If lArqOk
							Exit
						EndIf
					Next nI
		  		EndIF
				
				cMsg := cHtml(aEmail[nAkacio,12],aEmail[nAkacio,2])                                                   //+aEmail[nAkacio,09]+aEmail[nAkacio,10]
				Aadd(aArquivos,{"\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+".pdf",''})  
				aAxM := strtokarr(Alltrim(aEmail[nAkacio,05]),";")
				cMailenv := ''
				cPV	:=	''
				For nPtro := 1 to len(aAxM)
					//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aEmail[nAkacio,05])+';nfe-amc@toktake.com.br','Nota de Debito',cMsg,aArquivos,.T.)				
					//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aAxM[nPtro]),'Nota de Debito '+aEmail[nAkacio,02],cMsg,aArquivos,.T.)				
					cMailenv += cPV +Alltrim(aAxM[nPtro])
					cPV := ";"
				Next nPtro    
				lRetorno := U_TTMAILN('nfe.amc@toktake.com.br',cMailenv+';nfe.amc@toktake.com.br','Nota de Debito '+aEmail[nAkacio,02]+' Serie '+aEmail[nAkacio,11],cMsg,aArquivos,.T.)				                                                                                              
				
				//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aEmail[nAkacio,05])+';nfe-amc@toktake.com.br','Nota de Debito',cMsg,aArquivos,.T.)				
				aEmail[nX,04] := 'Enviado'				
			Endif	
		Else
			If !Empty(aEmail[nAkacio,02])
		      	aArquivos	:=	{}
		      	lArqOk := .F.
		  		
		  		If !lArqOk
					For nI := 1 To 10   				                                   //+aEmail[nAkacio,09]+aEmail[nAkacio,10]
    					lArqOk := ChkArq("\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+".pdf")
			      		If lArqOk
							Exit
						EndIf
					Next nI
		  		EndIF
				
				cMsg := cHtml(aEmail[nAkacio,12],aEmail[nAkacio,2])                                                    //+aEmail[nAkacio,09]+aEmail[nAkacio,10]
				Aadd(aArquivos,{"\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+".pdf",''})
				//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aEmail[nAkacio,05])+';nfe-amc@toktake.com.br','Nota de Debito',cMsg,aArquivos,.T.)				
				aAxM := strtokarr(Alltrim(aEmail[nAkacio,05]),";")
				cMailenv := ''
				cPV	:=	''
				For nPtro := 1 to len(aAxM)
					//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aEmail[nAkacio,05])+';nfe-amc@toktake.com.br','Nota de Debito',cMsg,aArquivos,.T.)				
					//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aAxM[nPtro]),'Nota de Debito '+aEmail[nAkacio,02],cMsg,aArquivos,.T.)				
					cMailenv += cPV + Alltrim(aAxM[nPtro])
					cPV := ";"
				Next nPtro 				
				
				lRetorno := U_TTMAILN('nfe.amc@toktake.com.br',cMailenv+';nfe.amc@toktake.com.br','Nota de Debito '+aEmail[nAkacio,02]+' Serie '+aEmail[nAkacio,11],cMsg,aArquivos,.T.)				                                                                                              
				
				//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br','cpereira@toktake.com.br','Nota de Debito',cMsg,aArquivos,.T.)
			EndIf	
		EndIf
	EndIf
Next nAkacio

oBoleto:end()
oDlg1:end()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Atualiza grid de itens faturados com o grid de pedidos   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera html de envio do email ao cliente                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function cHtml(ccodbar,nnota)

Local aArea	:=	GetArea()
Local cRet	:=	''

If cFilAnt == "01"

	cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
	cRet += "<table border='0'>"
	cRet += "<thead>"
	cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
	cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
	
	If !Empty(ccodbar)
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso não consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/01/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu código de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>C&aacute;ssio - Email: <a href='MAILTO:amc.centro@maquinadecafe.com.br'>amc.centro@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 3256-9662 , (11) 3256-9026 ou Cel.: (11) 98630-0602</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realizações alcançadas este ano, sejam apenas sementes plantadas, que serão colhidas com maior sucesso no ano vindouro. São os votos da Equipe da AMC Matriz. Agradeçemos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Elseif cFilAnt == "02"

	cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
	cRet += "<table border='0'>"
	cRet += "<thead>"
	cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo "+if(ddatabase==ctod("30/03/2017"),"Nova ","")+"Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
	
	if ddatabase==ctod("30/03/2017")
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3> Pedimos desconsiderar o e-mail recebido esta semana com a nota e boleto da Locação de sua máquina, pois nosso sistema gerou com inconsistência.<br>Informamos ainda que a nota permanece inalterada.</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	EndIf
	
	cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
	                    //2 style='color: #FF0000;'
	If !Empty(ccodbar)
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso não consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/02/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu código de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Fernanda ou Simone - Email: <a href='MAILTO:amc.sul@maquinadecafe.com.br'>amc.sul@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 5182-2877 , (11) 5182-7024 ou cel.: (11) 94724-8292</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realizações alcançadas este ano, sejam apenas sementes plantadas, que serão colhidas com maior sucesso no ano vindouro. São os votos da Equipe da AMC SUL. Agradeçemos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Elseif cFilAnt == "03"

	cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
	cRet += "<table border='0'>"
	cRet += "<thead>"
	cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo "+if(ddatabase==ctod("30/03/2017"),"Nova ","")+" Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
	                         
	if ddatabase==ctod("30/03/2017")
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3> Pedimos desconsiderar o e-mail recebido esta semana com a nota e boleto da Locação de sua máquina, pois nosso sistema gerou com inconsistência.<br>Informamos ainda que a nota permanece inalterada.</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	EndIf
	
	cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
	
	If !Empty(ccodbar)
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso não consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/03/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu código de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>C&aacute;ssio, Lethicia ou Paulo - Email: <a href='MAILTO:amc.centro@maquinadecafe.com.br'>amc.centro@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 3256-9662 , (11) 3256-9026 ou Cel.: (11) 98630-0602</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realizações alcançadas este ano, sejam apenas sementes plantadas, que serão colhidas com maior sucesso no ano vindouro. São os votos da Equipe da AMC CENTRO. Agradeçemos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Elseif cFilAnt == "04"

	cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
	cRet += "<table border='0'>"
	cRet += "<thead>"
	cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
	cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
	If !Empty(ccodbar)
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso não consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/04/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu código de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Lilian ou Vitor - Email: <a href='MAILTO:amc.oeste@maquinadecafe.com.br'>amc.oeste@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 3622-3640 , (11) 3622-3616 ou Cel.: (11) 97408.7130</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realizações alcançadas este ano, sejam apenas sementes plantadas, que serão colhidas com maior sucesso no ano vindouro. São os votos da Equipe da AMC OESTE. Agradeçemos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Endif

RestArea(aArea)

Return(cRet)                                                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rotina de fechamento mensal                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fechamento

Local aArea		:=	GetArea()
Local cQuery       
Local aFecha	:=	{} 

Private oFecha1,oFecha2
Private aFecha1	:=	{}
Private aFecha2	:=	{}

Private oDlF1,oGrpF1,oBrw1,oGrpF2,oBrw2,oBtnF1,oBtnF2

cQuery := "SELECT AAM_STATUS,AAM_CODCLI,AAM_LOJA,A1_NOME,A1_NREDUZ,AAN_CONTRT,AAN_ITEM,'' AS AAN_XCBASE,'' AS AAN_XISENT,AAN_CODPRO,B1_DESC,AAN_QUANT,"
cQuery += "AAN_VLRUNI,AAN_VALOR,AAN_INICOB,AAN_FIMCOB,AAN_ULTPED,AAN_ULTEMI,AAM_INIVIG,AAM_FIMVIG,'' AS AAM_XFORFA,'' AS AAM_XTIPFA,'' AS AAM_XRENOV,AAN.R_E_C_N_O_ AS REG"
cQuery += " FROM "+RetSQLName("AAN")+" AAN"
cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT AND AAM.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=AAN_CODPRO AND B1.D_E_L_E_T_=''"
cQuery += " WHERE AAN.D_E_L_E_T_=''"
cQuery += " ORDER BY AAN_CONTRT,AAN_ITEM"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("CONFSC01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

While !EOF()
    Aadd(aFecha,{TRB->AAM_STATUS,TRB->AAM_CODCLI,TRB->AAM_LOJA,TRB->A1_NOME,TRB->A1_NREDUZ,TRB->AAN_CONTRT,TRB->AAN_ITEM,;
    			TRB->AAN_XCBASE,TRB->AAN_XISENT,TRB->AAN_CODPRO,TRB->B1_DESC,TRB->AAN_QUANT,TRB->AAN_VLRUNI,TRB->AAN_VALOR,;
    			TRB->AAN_INICOB,TRB->AAN_FIMCOB,TRB->AAN_ULTPED,TRB->AAN_ULTEMI,TRB->AAM_INIVIG,TRB->AAM_FIMVIG,TRB->AAM_XFORFA,;
    			TRB->AAM_XTIPFA,TRB->AAM_XRENOV})
    If TRB->AAN_XISENT != "1" .And. STRZERO(MONTH(stod(TRB->AAN_ULTEMI)),2) != STRZERO(MONTH(DDATABASE),2) .And. strzero(Month(Stod(TRB->AAN_FIMCOB)),2)+cvaltochar(year(Stod(TRB->AAN_FIMCOB))) <= strzero(Month(dDatabase),2)+cvaltochar(year(ddatabase))
 	 	Aadd(aFecha1,{TRB->AAN_CONTRT,Alltrim(TRB->B1_DESC),TRB->AAN_VLRUNI})
    EndIf       
    
    If TRB->AAN_XISENT != "1" .And. strzero(Month(Stod(TRB->AAN_FIMCOB)),2)+cvaltochar(year(Stod(TRB->AAN_FIMCOB))) <= strzero(Month(dDatabase),2)+cvaltochar(year(ddatabase)) .And. stod(TRB->AAN_FIMCOB) <= lastday(ddatabase)
    	Aadd(aFecha2,{.F.,TRB->AAN_CONTRT,TRB->AAN_XCBASE,TRB->AAN_FIMCOB,TRB->REG})
    EndIF
	Dbskip()
EndDo

If len(aFecha1) < 1
	Aadd(aFecha1,{'','',0,'',''})
Endif

If len(aFecha2) < 1
	Aadd(aFecha2,{.F.,'','','',0})
Endif

oDlF1      := MSDialog():New( 092,232,592,1027,"Fechamento Mensal",,,.F.,,,,,,.T.,,,.T. )
	oGrpF1     := TGroup():New( 000,004,216,202,"Contratos não Faturados",oDlF1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,208,148},,, oGrpF1 ) 
	
	oFecha1 	   := TCBrowse():New(008,008,190,200,, {'Contrato','Item','Valor'},{25,40,30},;
                            oGrpF1,,,,{|| },{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oFecha1:SetArray(aFecha1)
	oFecha1:bLine := {||{aFecha1[oFecha1:nAt,01],;
						 aFecha1[oFecha1:nAt,02],; 
	 					 Transform(aFecha1[oFecha1:nAt,03],"@E 999,999.99")}}
  
	oGrpF2     := TGroup():New( 000,206,216,396,"Ativos Removidos",oDlF1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,160,212,332},,, oGrpF2 ) 
	oFecha2 	   := TCBrowse():New(008,210,180,200,, {'','Contrato','Ativo','Retirado em'},{25,30,40},;
                            oGrpF2,,,,{|| },{|| markatv(oFecha2:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oFecha2:SetArray(aFecha2)
	oFecha2:bLine := {||{If(aFecha2[oFecha2:nAt,01],oSpv,oFat),;
						 aFecha2[oFecha2:nAt,02],; 
	 					 aFecha2[oFecha2:nAt,03],;
	 					 stod(aFecha2[oFecha2:nAt,04])}}
	
	oBtnF1     := TButton():New( 224,220,"Remover Ativos",oDlF1,{||RemAtv()},040,012,,,,.T.,,"",,,,.F. )
	oBtnF2     := TButton():New( 224,346,"Sair",oDlF1,{||oDlF1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlF1:Activate(,,,.T.)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/27/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Marca e desmarca itens                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/27/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Remove o Ativo do contrato                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RemAtv()

Local aArea	:=	GetArea()
Local nG 

DbSelectArea("AAN")

For nG := 1 to len(aFecha2)

	If aFecha2[nG,01] .And. aFecha2[nG,05] > 0
		Dbgoto(aFecha2[nG,05])
		Reclock("AAN",.F.)
		Dbdelete()
		AAN->(Msunlock())
	EndIF  

Next nG 

oDlF1:end()

RestArea(aArea)

Return                         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Calcular Rescisao do Contrato                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Rescisao(nLinha)

Local aArea	:=	GetArea()    
Local nTot	:=	0             
Local nOpica:=	0
Local nX 

Private oRes1,oGres1,oGres2,oBrw1,oGres3,oBRes1,oBRes2,oSayR1,oSayR2,oSayR3,oSayR4,oSayR5,oSayR6,oSayR7,oSayR8,oSayR9,oSayR10,oSayR11,oSayR12,oSayR13
Private oResci
Private aResci	:=	{}  

/*                             
alist                                               aList2b							aList3b            		aList4b

1 - Número do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descrição					2 - Data Emissao		2 - Desricao
3 - Código Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endereço Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condição de Pagamento                                                                                   9 - Quantidade
10- Descricao da condicao
11- Inicio Vigencia
12- Fim Vigencia
13- Email Cliente 
14- Inicio Multa
15- Prazo
16- Percentual Multa
17- Renovacao Automatica
*/  
//'Ativo','Modelo','Instalado em','Valor'

For nX := 1 to len(aList2b)
	If aList[nLinha,01] == aList2b[nX,04]
		Aadd(aResci,{aList2b[nX,01],aList2b[nX,02],aList2b[nX,05],aList2b[nX,03],''})
	EndIf
Next nX
 
cInfCl  := aList[nLinha,03]+"-"+aList[nLinha,04]+" / "+aList[nLinha,05]
cInfEnd := aList[nLinha,06]+" / "+aList[nLinha,07]+" / "+aList[nLinha,08] 
cInfVig := cvaltochar(aList[nLinha,11]) +" A "+cvaltochar(aList[nLinha,12])

//Valor Mensal
Aeval(aList2b,{|aList2b| nTot += If(aList2b[4] == aList[nLinha,01] .And. aList2b[3]>1,aList2b[3],0)})

//Vencimento do Contrato
nVencCnt := MonthSum(stod(aList[nLinha,14]),val(aList[nLinha,15]))

//Quantidade de meses para vencer o contrato
nQtdMes	:=	DateDiffMonth(ddatabase,nVencCnt)

//Multa
nMulta 	:=	(nTot * nQtdMes) * (aList[nLinha,16]/100)


oRes1      := MSDialog():New( 092,232,592,927,"Rescisão",,,.F.,,,,,,.T.,,,.T. )

	oGRes1      := TGroup():New( 004,004,080,336,"Informações do Contrato",oRes1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSayR7      := TSay():New( 016,012,{||"Cliente                 "+cInfCl},oGRes1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR8      := TSay():New( 037,012,{||"Endereço                "+cInfEnd},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR9      := TSay():New( 055,012,{||"Vigência do Contrato    "+cInfVig},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR10     := TSay():New( 052,012,{||""},oGRes1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,316,008)
		oSayR11     := TSay():New( 068,122,{||"Valor Mensal "+Transform(nTot,"@E 999,999,999.99")},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,316,008)

	oGres2      := TGroup():New( 084,004,232,204,"Ativos no Contrato",oRes1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{092,008,228,200},,, oRes2 ) 
		oResci 	   := TCBrowse():New(092,008,193,135,, {'Ativo','Modelo','Instalado em','Valor'},{25,30,30,30},;
	                            oGres2,,,,{|| },{|| /*editcol*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oResci:SetArray(aResci)
		oResci:bLine := {||{aResci[oResci:nAt,01],;
							 aResci[oResci:nAt,02],; 
		 					 aResci[oResci:nAt,03],;
		 					 If(aResci[oResci:nAt,04]>1,Transform(aResci[oResci:nAt,04],"@E 999,999,999.99"),'Isento')}}
	
	oGRes3      := TGroup():New( 084,208,196,336,"Calculo",oRes1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oSayR1      := TSay():New( 096,216,{||"Vencimento do Contrato"},oGRes3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,008)
		oSayR2      := TSay():New( 096,292,{||nVencCnt},oGRes3,,oFont3,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,052,008)
		oSayR3      := TSay():New( 116,216,{||"Meses a serem cobrados"},oGRes3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,008)
		oSayR4      := TSay():New( 116,292,{|| nQtdMes},oGRes3,,oFont3,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,052,008)
		
		oSayR12      := TSay():New( 136,216,{||"% Multa"},oGRes3,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,160,008)
		oSayR13      := TSay():New( 136,292,{|| aList[nLinha,16]},oGRes3,,oFont3,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,052,008)

		oSayR5      := TSay():New( 156,216,{||"Valor para Rescisão em "+cvaltochar(dDataBase)},oGRes3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
		oSayR6      := TSay():New( 176,237,{||"R$ "+Transform(nMulta,"@E 999,999,999.99")},oGRes3,,oFont4,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,112,020)

	oBRes1     := TButton():New( 220,208,"Rescindir",oGRes1,{||oRes1:end(nOpica:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBRes2     := TButton():New( 220,300,"Sair",oGres1,{||oRes1:end(nOpica:=0)},037,012,,,,.T.,,"",,,,.F. )

oRes1:Activate(,,,.T.)

If nOpica == 1
	U_AMCFAT02()	   
	DbSelectArea("AAM")
	DbSetOrder(1)
	If Dbseek(xFilial("AAM")+aList[oList:nAt,01])
		Reclock("AAM",.F.)
		AAM->AAM_STATUS := "3"
		AAM->(Msunlock())
	EndIf
	DbSelectArea("AAN")
	DbSetOrder(1)
	IF Dbseek(xFilial("AAN")+aList[oList:nAt,01])
		While !EOF() .And. AAN->AAN_CONTRT == aList[oList:nAt,01]
			Reclock("AAN",.F.)
			DbDelete()
			AAN->(Msunlock())
			Dbskip()
		EndDo
	EndIf
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFSC01  ºAutor  ³Microsiga           º Data ³  09/16/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o arquivo esta com tamanho compativel          º±±
±±º          ³ maior que 100 KB                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
Local aItens	:=	{}
Local aLocac 	:=	{}
Local nJ 
Local cAtLoc 	:=	""
Local cBarra 	:=	""
Local cAtFat 	:=	""
Local cTipFat	:=	'' //aList[oList:nAt,15]
Local cForFat 	:=	''
Local nX 

If nOpcG == 0
	//Faturar todos os itens liberados do array alist
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
							aList2B[nCont,03]})
			EndIf 
		EndIf 
	Next nCont

	cBarra := ""

	If cTipFat == "1"
		For nCont := 1 to len(aList5B)
			If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
				cAtFat += cBarra + Alltrim(aList5b[nCont,02])
				cBarra := "/"
				For nJ := 5 to len(aList5b[nCont])
					nPos := Ascan(aItens,{|x| x[1] == aList5B[nCont,nJ,02]})
					If nPos == 0
						Aadd(aItens,{	aList5B[nCont,nJ,02],;
										aList5B[nCont,nJ,08],;
										aList5B[nCont,nJ,09]})
					Else 
						aItens[nPos,02] += aList5B[nCont,nJ,08]
					EndIf 
				Next nJ 
			EndIf
		Next nCont
	
		If aList[oList:nAt,20] > 0
			Aadd(aItens,{aList[oList:nAt,22],;
						aList[oList:nAt,20],;
						aList[oList:nAt,21]})
		EndIf 
	
	ElseIf cTipFat == "2"
		For nX := 1 to len(aList2)
			aItens := {}
			For nCont := 1 to len(aList5B)
				If aList5B[nCont,01] == aList2[nX,04] .And. len(aList5b[nCont]) > 4 .And. aList5B[nCont,02] == aList2[nX,01]
					For nJ := 5 to len(aList5b[nCont])
						nPosloc := Ascan(aItens,{|x| x[1] == aList5B[nCont,nJ,02]})
						
						If nPosloc == 0
							
							Aadd(aItens,{	aList5B[nCont,nJ,02],;
											aList5B[nCont,nJ,08],;
											aList5B[nCont,nJ,09]})
						Else 
							aItens[nPosloc,02] += aList5B[nCont,nJ,08]
						EndIf 
					Next nJ 
				EndIf
			Next nCont

			If (aList2[nX,11] > 0 .And. cQuinze == "2") .OR.(cForFat=="1" .AND. cTipFat=="2") //cCond == "2"
				Aadd(aItens,{	aList[oList:nAt,22],;
								aList2[nX,11],;
								Posicione("DA1",1,xFilial("DA1")+AAM->AAM_XCODTA+aList[oList:nAt,22],"DA1_PRCVEN")})
			EndIf 
			cAtFat := Alltrim(aList2[nX,01])
			If len(aItens) > 0 //(len(aItens) > 0 .And. cQuinze == "2") .OR.(cForFat=="1" .AND. cTipFat=="2" .And. len(aItens) > 0)
				Processa({|| Pedido(cAtFat,aItens)},"Aguarde")
				aItens := {}
			EndIF
			
			
		
		Next nX
	EndIf 

EndIF 

If len(aItens) > 0 
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

	aAdd( aCabec , { "C5_FILIAL"    , xFilial("SC5")      , Nil } ) 
	aAdd( aCabec , { "C5_XTPPED"    , 'F'                 , Nil } )
	aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
	aAdd( aCabec , { "C5_CLIENTE"   , aList[oList:nAt,03]    , Nil } )
	aAdd( aCabec , { "C5_LOJACLI"   , aList[oList:nAt,04]    , Nil } )
	Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento de Doses - Ref. Patrimonio(s) '+cAtFat   , Nil } )
	aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV     , Nil } )    
        
	For nCont := 1 to len(aItens)
		aLinha := {}
		aAdd( aLinha , { "C6_FILIAL"     , xFilial("SC6")                         , Nil })
		aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
		aAdd( aLinha , { "C6_PRODUTO"    , aItens[nCont,01]                       , Nil })
		aAdd( aLinha , { "C6_QTDVEN"     , aItens[nCont,02]                       , Nil })
		aAdd( aLinha , { "C6_PRCVEN"     , aItens[nCont,03]                       , Nil })
		aAdd( aLinha , { "C6_TES"        , '523'                                  , Nil })  
		aAdd( aLinha , { "C6_QTDLIB"     , aItens[nCont,02]    	                  , Nil })
		aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

		aAdd( aItC6 , aLinha ) 
		cItem := Soma1(cItem)
	Next nCont

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
		
	IF lMsErroAuto  
		MostraErro()
	ELSE
		Msgalert("Pedido gerado de faturamento de doses "+SC5->C5_NUM)
		DbSelectArea("Z08")
		DbSetOrder(1)
		For nCont := 1 to len(aList5B)
			If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
				For nJ := 5 to len(aList5b[nCont])
					If Dbseek(xFilial("Z08")+aList5b[nCont,nJ,11])
						While !EOF() .And. Z08->Z08_COD == aList5b[nCont,nJ,11]
							RecLock("Z08", .F.)
							Z08->Z08_FATURA := 'S'
							Z08->(MsUnlock())
							aList5b[nCont,nJ,12] := 'S'
							Dbskip()
						EndDo 
					EndIf 
				Next nJ
			EndIf 
		Next nCont
	ENDIF

EndIF 

//Faturamento locacao
If len(aLocac) > 0
	DbSelectArea("AAM")
	DbSetOrder(1)
	DbSeek(xFilial("AAM")+aList[oList:nAt,01])
	aCabec := {}
	aItC6  := {}
	cItem  := '01'

	aAdd( aCabec , { "C5_FILIAL"    , xFilial("SC5")      , Nil } ) 
	aAdd( aCabec , { "C5_XTPPED"    , 'L'                 , Nil } )
	aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
	aAdd( aCabec , { "C5_CLIENTE"   , aList[oList:nAt,03]    , Nil } )
	aAdd( aCabec , { "C5_LOJACLI"   , aList[oList:nAt,04]    , Nil } )
	Aadd( aCabec , { "C5_MENNOTA"   , 'Locacao de Maquinas Ref. Patrimonio(s) '+cAtLoc    , Nil } )
	aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV     , Nil } )    

	For nCont := 1 to len(aLocac)
		aLinha := {}
		aAdd( aLinha , { "C6_FILIAL"     , xFilial("SC6")                         , Nil })
		aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
		aAdd( aLinha , { "C6_PRODUTO"    , 'SLOC680001'                           , Nil })
		aAdd( aLinha , { "C6_QTDVEN"     , 1				                      , Nil })
		aAdd( aLinha , { "C6_PRCVEN"     , aLocac[nCont,02]                       , Nil })
		aAdd( aLinha , { "C6_TES"        , '523'                                  , Nil })  
		aAdd( aLinha , { "C6_QTDLIB"     , 1			    	                  , Nil })
		aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

		aAdd( aItC6 , aLinha ) 
		cItem := Soma1(cItem)
	Next nCont

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
		
	IF lMsErroAuto  
		MostraErro()
	ELSE
		Msgalert("Pedido gerado de locação "+SC5->C5_NUM)
		DbSelectArea("Z08")
		DbSetOrder(1)
		For nCont := 1 to len(aList5B)
			If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
				For nJ := 5 to len(aList5b[nCont])
					If Dbseek(xFilial("Z08")+aList5b[nCont,nJ,11])
						While !EOF() .And. Z08->Z08_COD == aList5b[nCont,nJ,11]
							RecLock("Z08", .F.)
							Z08->Z08_FATURA := 'S'
							Z08->(MsUnlock())
							aList5b[nCont,nJ,12] := 'S'
							Dbskip()
						EndDo
					EndIf 
				Next nJ
			EndIf 
		Next nCont
	ENDIF    
EndIf

RestArea(aArea)

Return

/*
	Impressão do Recibo de locação de maquinas

*/
Static Function ReciboLoc()
	
    Local lAdjustToLegacy  := .F.
    Local lDisableSetup    := .T.
	Local cMes             := "XXXXXXXX"
	Local cNum             := "XXXX"
	Local cCli             := "XXXXXXXX XXXXXXXX XXXXXXXX"
	Local cEnd             := "XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX"
	Local cCnpj            := "XX.XXX.XXX/XXXX-XX"
	Local cValor1          := "R$XXX,XX (XXX reais e XX centavos)"
	Local cValor2          := "XXX,XX"
	Local cPeriodo         := "Locação de máquina referente ao mês XX/XXXX"
	Local cVencimento      := "XX/XX/XXXX"
	Local cPonto           := "Ponto de Venda XXXXXXXX XXXXXXXXX - XXXX"
	Local cEmitente        := "CONNECT VENDING COMERCIO DE MAQUINAS AUTOMATIZADAS LTDA (CNPJ: 24.575.331/0001-18 - IE:"
	Local cEndEmit         := "Rua Fortunato Ferraz, 1030 - Vila Anastacio - São Paulo/SP - 05093-000"
	Local cEmissao         := "XX/XX/XXXX"
    Local oFont            := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont1           := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont2           := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont3           := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
    Local oFont4           := TFont():New('Arial' /*Fonte*/,,13 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )

	Private oPrinter := FWMSPrinter():New( "recibo_loc_"+cNum+".pdf",IMP_PDF,lAdjustToLegacy,"c:\temp\",lDisableSetup,,,,,,,, )
    
    oPrinter:StartPage()
    oPrinter:SetMargin( 000, 000, 000, 000 )
	
	oBrush1 := TBrush():New( , rgb(237, 237, 237) )
	oPrinter:Fillrect( { 26, 500, 74, 590 }, oBrush1, "-2")
	
	oPrinter:Box( 25, 5, 25, 590, "-9" )
	// oPrinter:SayBitmap( nLin, nCol, cConnect, 50, 20 ) 
	oPrinter:Say( 55, 125,"FATURA " + cNum + " - LOCAÇÃO DE " + cMes, oFont1 )
	oPrinter:Say( 35, 510,"NÚMERO", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 55, 530,cNum, oFont1 )
	oPrinter:Box( 75, 5, 75, 590, "-9" )
	oPrinter:Box( 25, 500, 75, 500, "-9" )

	oPrinter:Box( 75, 500, 150, 500, "-1" )
	oPrinter:Say( 85, 10,"RECEBEMOS DE", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 100, 10,cCli, oFont4,, /*Cor*/ )
	oPrinter:Say( 115, 10,cEnd, oFont4,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 85, 510,"CNPJ OU CPF", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 95, 510,cCnpj, oFont4,, /*Cor*/ )

	oPrinter:Box( 150, 5, 150, 590,"-1" )
	oPrinter:Say( 160, 10,"O VALOR DE", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 175, 10,cValor1, oFont4,, /*Cor*/ )

	oPrinter:Box( 200, 5, 200, 590,"-1" )
	oPrinter:Say( 210, 10,"REFERENTES A", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 225, 10,cPeriodo, oFont4,, /*Cor*/ )
	oPrinter:Say( 240, 10,cVencimento, oFont4,, /*Cor*/ )

	oPrinter:Box( 250, 5, 250, 590,"-1" )
	oPrinter:Say( 260, 10,"DETALHAMENTO", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 275, 10,cPonto, oFont4,, /*Cor*/ )
	oPrinter:Say( 275, 500,cValor2, oFont4,, /*Cor*/ )

	oPrinter:Box( 300, 5, 300, 590,"-1" )
	oPrinter:Say( 310, 10,"EMITENTE", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 325, 10,cEmitente, oFont4,, /*Cor*/ )
	oPrinter:Say( 340, 10,cEndEmit, oFont4,, rgb(102, 102, 102)/*Cor*/ )

	oPrinter:Fillrect( { 350, 300, 400, 590 }, oBrush1, "-2")
	oPrinter:Box( 350, 5, 350, 590,"-1" )
	oPrinter:Box( 350, 300, 400, 300,"-1" )
	oPrinter:Box( 400, 5, 400, 590,"-1" )
	oPrinter:Say( 360, 10,"DATA DE EMISSÃO", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 375, 10,cEmissao, oFont4,, /*Cor*/ )
	oPrinter:Say( 360, 310,"ASSINATURA", oFont,, rgb(102, 102, 102)/*Cor*/ )

	oPrinter:Say( 735, 5,"_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ", oFont )
	oPrinter:Box( 750, 100, 750, 590,"-1" )
	oPrinter:Box( 785, 100, 785, 590,"-1" )
	oPrinter:Box( 825, 100, 825, 590,"-1" )
	oPrinter:Box( 750, 300, 785, 420,"-1" )
	oPrinter:Box( 750, 420, 785, 500,"-1" )
	oPrinter:Box( 750, 420, 825, 420,"-1" )
	oPrinter:Fillrect( { 750, 30, 825, 85 }, oBrush1, "-2")
	oPrinter:Say( 760, 43,"NÚMERO", oFont2,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 820, 12,"COMPROVANTE", oFont,, /*Cor*/, 270 /*Angulo*/ )
	oPrinter:Say( 820, 22,"   DE ENTREGA", oFont,, /*Cor*/, 270 /*Angulo*/ )
	oPrinter:Say( 760, 110,"DESTINATÁRIO", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 760, 305,"CNPJ OU CPF", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 760, 425,"EMISSÃO", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 760, 505,"VALOR", oFont,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 795, 110,"RECEBIDO POR", oFont2,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 795, 175,"(nome e assinatura, por gentileza)", oFont3,, rgb(102, 102, 102)/*Cor*/ )
	oPrinter:Say( 795, 425,"DATA", oFont2,, rgb(102, 102, 102)/*Cor*/ )

	oPrinter:EndPage()
	oPrinter:Print()

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
Static Function Pedido(cAtFat,aItens)

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

aAdd( aCabec , { "C5_FILIAL"    , xFilial("SC5")      , Nil } ) 
aAdd( aCabec , { "C5_XTPPED"    , 'F'                 , Nil } )
aAdd( aCabec , { "C5_TIPO"      , 'N'                 , Nil } )
aAdd( aCabec , { "C5_CLIENTE"   , aList[oList:nAt,03]    , Nil } )
aAdd( aCabec , { "C5_LOJACLI"   , aList[oList:nAt,04]    , Nil } )
Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento de Doses - Ref. Patrimonio(s) '+cAtFat   , Nil } )
aAdd( aCabec , { "C5_CONDPAG"   , AAM->AAM_CPAGPV     , Nil } )    
	
For nCont := 1 to len(aItens)
	aLinha := {}
	aAdd( aLinha , { "C6_FILIAL"     , xFilial("SC6")                         , Nil })
	aAdd( aLinha , { "C6_ITEM"       , cItem 							      , Nil })
	aAdd( aLinha , { "C6_PRODUTO"    , aItens[nCont,01]                       , Nil })
	aAdd( aLinha , { "C6_QTDVEN"     , aItens[nCont,02]                       , Nil })
	aAdd( aLinha , { "C6_PRCVEN"     , aItens[nCont,03]                       , Nil })
	aAdd( aLinha , { "C6_TES"        , '523'                                  , Nil })  
	aAdd( aLinha , { "C6_QTDLIB"     , aItens[nCont,02]    	                  , Nil })
	aAdd( aLinha , { "C6_CONTRT" 	 , AAM->AAM_CONTRT						  , Nil })

	aAdd( aItC6 , aLinha ) 
	cItem := Soma1(cItem)
Next nCont

lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
	
IF lMsErroAuto  
	MostraErro()
ELSE
	Msgalert("Pedido gerado de faturamento de doses "+SC5->C5_NUM)
	DbSelectArea("Z08")
	DbSetOrder(1)
	For nCont := 1 to len(aList5B)
		If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
			For nJ := 5 to len(aList5b[nCont])
				If Dbseek(xFilial("Z08")+aList5b[nCont,nJ,11])
					While !EOF() .And. Z08->Z08_COD == aList5b[nCont,nJ,11]
						RecLock("Z08", .F.)
						Z08->Z08_FATURA := 'S'
						Z08->(MsUnlock())
						aList5b[nCont,nJ,12] := 'S'
						Dbskip()
					EndDo 
				EndIf 
			Next nJ
		EndIf 
	Next nCont
ENDIF

RestArea(aArea)

Return

Static Function ExtLeitura()
	
    Local lAdjustToLegacy  := .F.
    Local lDisableSetup    := .T.
    Local nX               := 0
    Local nY               := 0
	Local nLin             := 0
    Local oFont1           := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    // Local oFont2           := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont3           := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
    Local oFont4           := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont6           := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont5           := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )

	Private oPrinter := FWMSPrinter():New( "extrato_leitura_.pdf",IMP_PDF,lAdjustToLegacy,"c:\temp\",lDisableSetup,,,,,,,, )
    
    oPrinter:StartPage()
    oPrinter:SetMargin( 005, 005, 005, 005 )

	oBrush1 := TBrush():New( , rgb(0, 0, 0) )
	oBrush2 := TBrush():New( , rgb(238, 238, 238) )
	oBrush3 := TBrush():New( , rgb(0, 99, 125) )

	oPrinter:Say( nLin+=40, 10,"Extrato de Leituras", oFont5,, rgb(0, 99, 125) )
	oPrinter:Say( nLin+=10, 10,"Realizadas entre ", oFont3,, rgb(102, 102, 102) )

	oPrinter:Fillrect( { nLin+=30, 10, nLin+30, 590 }, oBrush2, "-2")
	oPrinter:Fillrect( { nLin+=10, 20, nLin+10, 30 }, oBrush1, "-2")
	oPrinter:Say( nLin+5, 45,"TOTAL GERAL", oFont4 )
	oPrinter:Say( nLin+15, 45,"Totalizando 1 Cliente", oFont1 )

	oPrinter:Say( nLin+=10, 400,"0001", oFont1 )
	oPrinter:Say( nLin, 450,"0002", oFont1 )
	oPrinter:Say( nLin, 500,"0003", oFont1 )
	oPrinter:Say( nLin, 550,"0004", oFont1 )

	oPrinter:Say( nLin+=30, 45,"Produto", oFont1 )
	oPrinter:Say( nLin, 100,"Descrição", oFont1 )
	oPrinter:Say( nLin, 360,"Consumo", oFont1 )
	oPrinter:Say( nLin, 410,"Subsidiado R$", oFont1 )
	oPrinter:Say( nLin, 480,"Ao Consumidor R$", oFont1 )
	oPrinter:Say( nLin, 550,"Total R$", oFont1 )

	for nX := 1 to 10
		oPrinter:Say( nLin+=20, 45,"D01010101", oFont1 )
		oPrinter:Say( nLin, 100,"CAFE NORMAL COM ACUCAR NORMAL", oFont1 )
		oPrinter:Say( nLin, 360,"15", oFont1 )
		oPrinter:Say( nLin, 410,"1000", oFont1 )
		oPrinter:Say( nLin, 480,"2000", oFont1 )
		oPrinter:Say( nLin, 550,"3000", oFont1 )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
	next

	oPrinter:Fillrect( { nLin+=20, 10, nLin+30, 590 }, oBrush3, "-2")

	oPrinter:Say( nLin+12, 30,"354 - AFIP", oFont4,, rgb(238, 238, 238) )
	oPrinter:Say( nLin+24, 30,"47.673.793/0102-17", oFont6,, rgb(238, 238, 238) )

	oPrinter:Say( nLin+=60, 10,"CONSOLIDADO", oFont6 )
	oPrinter:Fillrect( { nLin+=5, 10, nLin, 590 }, oBrush1, "-2")
	oPrinter:Fillrect( { nLin+=15, 10, nLin+30, 590 }, oBrush2, "-2")
	oPrinter:Fillrect( { nLin+10, 20, nLin+20, 30 }, oBrush3, "-2")
	oPrinter:Say( nLin+15, 40,"cCliente", oFont4 )
	oPrinter:Say( nLin+25, 40,"Totalizando " + "cNum" + " Pontos de Venda", oFont1 )
	oPrinter:Say( nLin+=15, 360,"cTotCons", oFont1 )
	oPrinter:Say( nLin, 410,"cTotSub", oFont1 )
	oPrinter:Say( nLin, 480,"cTotConsu", oFont1 )
	oPrinter:Say( nLin, 550,"cTotal", oFont1 )
	
	oPrinter:Say( nLin+=30, 45,"Produto", oFont1 )
	oPrinter:Say( nLin, 100,"Descrição", oFont1 )
	oPrinter:Say( nLin, 360,"Consumo", oFont1 )
	oPrinter:Say( nLin, 410,"Subsidiado R$", oFont1 )
	oPrinter:Say( nLin, 480,"Ao Consumidor R$", oFont1 )
	oPrinter:Say( nLin, 550,"Total R$", oFont1 )

	for nX := 1 to 10
		oPrinter:Say( nLin+=20, 45,"D01010101", oFont1 )
		oPrinter:Say( nLin, 100,"CAFE NORMAL COM ACUCAR NORMAL", oFont1 )
		oPrinter:Say( nLin, 360,"15", oFont1 )
		oPrinter:Say( nLin, 410,"1000", oFont1 )
		oPrinter:Say( nLin, 480,"2000", oFont1 )
		oPrinter:Say( nLin, 550,"3000", oFont1 )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
	next
	

	for nX := 1 to 2
	
		oPrinter:StartPage()

		oPrinter:Say( nLin:=20, 10,". . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .", oFont5,, rgb(0, 99, 125) )
		oPrinter:Say( nLin+=15, 10,"PONTO DE VENDA", oFont6 )
		oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush1, "-2")
		oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
		oPrinter:Fillrect( { nLin+20, 30, nLin+30, 20 }, oBrush1, "-2")
		oPrinter:Say( nLin+25, 40,"cCliente + cEnd", oFont4 )
		oPrinter:Say( nLin+35, 40,"cMaq", oFont1 )
		oPrinter:Say( nLin+25, 360,"cTotCons", oFont1 )
		oPrinter:Say( nLin+25, 410,"cTotSub", oFont1 )
		oPrinter:Say( nLin+25, 480,"cTotConsu", oFont1 )
		oPrinter:Say( nLin+25, 550,"cTotal", oFont1 )
		
		oPrinter:Say( nLin+=50, 25,"Mola", oFont1 )
		oPrinter:Say( nLin, 50,"Produto", oFont1 )
		oPrinter:Say( nLin, 100,"Descrição", oFont1 )
		oPrinter:Say( nLin, 360,"Consumo", oFont1 )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oFont1 )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oFont1 )
		oPrinter:Say( nLin, 550,"Total R$", oFont1 )

		for nY := 1 to 10

			if nY == 37
				oPrinter:StartPage()
				nLin:=0
			endif

			oPrinter:Say( nLin+=20, 25,"cMola", oFont1 )
			oPrinter:Say( nLin, 50,"cProduto", oFont1 )
			oPrinter:Say( nLin, 100,"cDescri", oFont1 )
			oPrinter:Say( nLin, 360,"cConsumo", oFont1 )
			oPrinter:Say( nLin, 410,"cSubsidi", oFont1 )
			oPrinter:Say( nLin, 480,"cConsumi", oFont1 )
			oPrinter:Say( nLin, 550,"cTotal", oFont1 )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		next

		oPrinter:Say( nLin+=30, 10,"Leituras no Período", oFont6 )
		oPrinter:Fillrect( { nLin-2.5, 120, nLin, 590 }, oBrush1, "-6")
		oPrinter:Fillrect( { nLin+10, 10, nLin+40, 590 }, oBrush2, "-2")
		oPrinter:Say( nLin+=25, 15,"22/11/22 10:00", oFont4 )
		oPrinter:Say( nLin, 100,"cCod", oFont1 )
		oPrinter:Say( nLin, 360,"cTotCons", oFont1 )
		oPrinter:Say( nLin, 410,"cTotSub", oFont1 )
		oPrinter:Say( nLin, 480,"cTotConsu", oFont1 )
		oPrinter:Say( nLin, 550,"cTotal", oFont1 )
		
		oPrinter:Say( nLin+=30, 25,"Mola", oFont1 )
		oPrinter:Say( nLin, 50,"Produto", oFont1 )
		oPrinter:Say( nLin, 100,"Descrição", oFont1 )
		oPrinter:Say( nLin, 360,"Consumo", oFont1 )
		oPrinter:Say( nLin, 410,"Subsidiado R$", oFont1 )
		oPrinter:Say( nLin, 480,"Ao Consumidor R$", oFont1 )
		oPrinter:Say( nLin, 550,"Total R$", oFont1 )
		
		for nY := 1 to 10
			oPrinter:Say( nLin+=20, 25,"cMola", oFont1 )
			oPrinter:Say( nLin, 50,"cProduto", oFont1 )
			oPrinter:Say( nLin, 100,"cDescri", oFont1 )
			oPrinter:Say( nLin, 360,"cConsumo", oFont1 )
			oPrinter:Say( nLin, 410,"cSubsidi", oFont1 )
			oPrinter:Say( nLin, 480,"cConsumi", oFont1 )
			oPrinter:Say( nLin, 550,"cTotal", oFont1 )
			oPrinter:Fillrect( { nLin+5, 10, nLin+5, 590 }, oBrush2, "-2")
		next
	next

	oPrinter:EndPage()
	oPrinter:Print()

Return 

Static Function DemonsCon()
	
    Local lAdjustToLegacy  := .F.
    Local lDisableSetup    := .T.
    Local nX               := 0
    Local nY               := 0
	Local nLin             := 0
    //Local oFont1           := TFont():New('Arial' /*Fonte*/,,10 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    //Local oFont2           := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    //Local oFont3           := TFont():New('Arial' /*Fonte*/,,12 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.T. /*Italico*/ )
    //Local oFont4           := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont5           := TFont():New('Arial' /*Fonte*/,,15 /*Tamanho*/,,.F. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont6           := TFont():New('Arial' /*Fonte*/,,20 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )
    Local oFont7           := TFont():New('Arial' /*Fonte*/,,25 /*Tamanho*/,,.T. /*Negrito*/,,,,,.F. /*Sublinhado*/,.F. /*Italico*/ )

	Private oPrinter := FWMSPrinter():New( "extrato_leitura_.pdf",IMP_PDF,lAdjustToLegacy,"c:\temp\",lDisableSetup,,,,,,,, )
    
    oPrinter:StartPage()
    oPrinter:SetMargin( 005, 005, 005, 005 )
	
	oBrush1 := TBrush():New( , rgb(0, 0, 0) )
	oBrush2 := TBrush():New( , rgb(238, 238, 238) )
	oBrush3 := TBrush():New( , rgb(0, 99, 125) )

	oPrinter:Say( nLin+=20, 125,"CONNECT VENDING COMERCIO DE MAQUINAS", oFont6,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+12, 125,"24.575.331/0001-18", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+24, 125,"R Dom João V, 417", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+36, 125,"05.075-060 - São Paulo - SP", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+48, 125,"(11) 4323-2212", oFont5,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin+=55, 10, nLin, 590 }, oBrush1, "-2")

	oPrinter:Box( nLin+=20, 30, nLin+100, 350,"-1" )

	oPrinter:Say( nLin+20, 35,"ASSOCICAO FUNDO DE INCENTIVO A", oFont6,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+32, 35,"47.673.793/0102-17", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+44, 35,"Rua Padre Machado, 1040 - 1100", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+56, 35,"04127-001 - São Paulo - SP", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+68, 35,"Este é o seu demonstrativo de consumo para o período", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+80, 35,"de 08/11/2022 e 21/11/2022", oFont5,, rgb(0, 0, 0) )

	oPrinter:Fillrect( { nLin, 360, nLin+100, 570 }, oBrush2, "-1")

	oPrinter:Say( nLin+40, 430,"6.530,04", oFont7,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+52, 400,"vencimento em 22/12/22", oFont5,, rgb(0, 0, 0) )
	oPrinter:Say( nLin+64, 410,"pagamento via Boleto", oFont5,, rgb(0, 0, 0) )

	
	oPrinter:Fillrect( { nLin+=100, 10, nLin, 590 }, oBrush2, "-1")


	for nX := 1 to 10
		oPrinter:Say( nLin+90, 400,"Consumo", oFont5,, rgb(0, 0, 0) )
		oPrinter:Say( nLin+90, 400+70,"Unitário (R$)", oFont5,, rgb(0, 0, 0) )
		oPrinter:Say( nLin+90, 400+70+70,"Total (R$)", oFont5,, rgb(0, 0, 0) )
		oPrinter:Fillrect( { nLin+=100, 10, nLin+20, 590 }, oBrush2, "-1")
		oPrinter:Say( nLin+=15, 30,"CAFE COM LEITE (DOSE)", oFont5,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 400,"2.306", oFont5,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 400+70,"0,99", oFont5,, rgb(0, 0, 0) )
		oPrinter:Say( nLin, 400+70+70,"2.282,94", oFont5,, rgb(0, 0, 0) )
		for nY := 1 to 10
			oPrinter:Say( nLin+=20, 30,"21/11/22 em 0730 - AFIP - MÁQ 0730", oFont5,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 400,"1.019", oFont5,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 400+70,"0,99", oFont5,, rgb(0, 0, 0) )
			oPrinter:Say( nLin, 400+70+70,"1.008,81", oFont5,, rgb(0, 0, 0) )
		next
	next

	oPrinter:EndPage()
	oPrinter:Print()

Return 

/*/{Protheus.doc} Recalc
	(long_description)
	@type  Static Function
	@author user
	@since 12/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Recalc(aArray,nLin)

Local aArea 	:=	GetArea()
Local cQuery
Local aAux5 	:=	{}
Local nY 
Local aLeitura 	:=	LeiAntr(aArray[01],aArray[02],aArray[5,11])
Local cTipFat	:=	alist[ascan(aList,{|x| x[1] == aarray[1]}),14]

cQuery := "  SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,Z08_DATA,Z08_CONTRT,Z08_FATURA" 
cQuery += "  FROM "+RetSQLname("Z08")+" Z08"
cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += "		AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' '" 
/*cQuery += "  WHERE  Z08_COD IN(SELECT MAX(Z08_COD)-1 FROM "+RetSQLname("Z08")
cQuery += "		WHERE  Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+aArray[02]+"'" 
cQuery += "  	AND Z08_CONTRT='"+aArray[01]+"' AND D_E_L_E_T_=' ')"*/
cQuery += " WHERE Z08_COD='"+aLeitura[1]+"'"
cQuery += "  AND Z08.D_E_L_E_T_=' '"
cQuery += " UNION "
cQuery += "  SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,Z08_DATA,Z08_CONTRT,Z08_FATURA" 
cQuery += "  FROM "+RetSQLname("Z08")+" Z08"
cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += "		AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' '" 
/*cQuery += "  WHERE  Z08_COD IN(SELECT MAX(Z08_COD)-2 FROM "+RetSQLname("Z08")
cQuery += "		WHERE  Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+aArray[02]+"'" 
cQuery += "  	AND Z08_CONTRT='"+aArray[01]+"' AND D_E_L_E_T_=' ')"*/
cQuery += " WHERE Z08_COD='"+aLeitura[2]+"'"
cQuery += "  AND Z08.D_E_L_E_T_=' '"
cQuery += "  ORDER BY Z08_COD DESC"

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
	nPos := Ascan(aAux5,{|x| Alltrim(x[1]) == strzero(val(TRB->Z08_SELECA),2)})
	nPos2 := Ascan(aTabPrc,{|x| x[1]+x[2] == TRB->Z08_CONTRT+TRB->Z08_PRODUT})

	If nPos == 0
		Aadd(aAuxL5,strzero(val(TRB->Z08_SELECA),2))
		Aadd(aAuxL5,TRB->Z08_PRODUT)
		Aadd(aAuxL5,TRB->B1_DESC)
		Aadd(aAuxL5,'')
		Aadd(aAuxL5,0)			
		Aadd(aAuxL5,TRB->Z08_DATA)
		Aadd(aAuxL5,TRB->Z08_QTDLID)
		Aadd(aAuxL5,0)
		
		If nPos2 > 0
			Aadd(aAuxL5,aTabPrc[nPos2,04])
		Else 
			Aadd(aAuxL5,0)
			
		EndIf 

		Aadd(aAuxL5,0)
		
		Aadd(aAuxL5,Z08_COD)
		Aadd(aAuxL5,Z08_FATURA)

		If len(aAuxL5) > 0
			Aadd(aAux5,aAuxL5)
		EndIf
	Else 
		If Empty(aAux5[nPos,04])
			aAux5[nPos,04] := TRB->Z08_DATA
			aAux5[nPos,05] := TRB->Z08_QTDLID
		ElseIf Empty(aAux5[nPos,06])
			aAux5[nPos,06] := TRB->Z08_DATA
			aAux5[nPos,07] := TRB->Z08_QTDLID
		Endif 

		If nPos2 > 0 .And. aAux5[nPos,09] == 0
			aAux5[nPos,09] := aTabPrc[nPos2,04]
		EndIf 
	EndIf 
	Dbskip()
EndDo 

Aeval(aAux5,{|x| x[8] := x[7] - x[5]})
Aeval(aAux5,{|x| x[10] := x[9] * x[8]})

For nY :=  5 to len(aList5B[nLin])
	If cTipFat == "1"
		nPL5 := Ascan(aAux5,{|x| x[1] == aList5B[nLin,nY,01]})
		If nPL5 > 0
			nQtdT := aAux5[nPL5,7] - aAux5[nPL5,5]
			aList5B[nLin,nY,08] := aList5B[nLin,nY,07] - nQtdT
			aList5B[nLin,nY,13] := stod(aAux5[nPL5,4])
			aList5B[nLin,nY,14] := aAux5[nPL5,5]
		EndIF
	Else 
		nPL5 := Ascan(aAux5,{|x| x[1]+x[6] == aList5B[nLin,nY,01]+aList5B[nLin,nY,04]})
		If nPL5 > 0
			nQtdT := aAux5[nPL5,7] - aAux5[nPL5,5]
			aList5B[nLin,nY,08] := aList5B[nLin,nY,07] - nQtdT
			aList5B[nLin,nY,13] := stod(aAux5[nPL5,4])
			aList5B[nLin,nY,14] := aAux5[nPL5,5]
		EndIf	
	EndIf
Next nY 

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

cQry := "SELECT Z08_COD,COUNT(*) FROM "+RetSQLName("Z08")
cQry += " WHERE Z08_NUMSER='"+cAtv+"' AND Z08_CONTRT='"+cCont+"' AND D_E_L_E_T_=' '"

IF !Empty(cLei)
	cQry += " AND Z08_COD NOT IN('"+cLei+"')"
EndIf 

cQry += " GROUP BY Z08_COD"
cQry += " ORDER BY Z08_COD DESC"

If Select("QUERY") > 0
	dbSelectArea("QUERY")
	dbCloseArea()
EndIf                                                                                 
	
MemoWrite("CONFSC01.SQL",cQry)

cQry:= ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),'QUERY',.F.,.T.)   

While !EOF() .And. nLei < 2
	Aadd(aRet,QUERY->Z08_COD)
	nLei++
	Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
