#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"    
#INCLUDE  "TBICONN.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "fileio.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ CONFSC02 ณ Autor ณ Alexandre Venancio    ณ Data ณ 01/09/16 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ   Rotina de pre-faturamento e historico.                   ณฑฑ
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

User Function CONFSC02

Private oDlg1,oGrp1,oGrp2,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oGrp3,oBrw1,oGrp4
Private oGrp5,oBrw3,oBtn1,oMenu,oGrp6
Private oList,oList2,oList3,oList4
Private aList	:=	{}
Private aList2	:=	{}
Private aList3	:=	{} 
Private aList4	:=	{} 
Private aHead   := 	{}

Private aListb	:=	{}
Private aList2b	:=	{}
Private aList3b	:=	{} 
Private aList4b	:=	{} 
 
Private oFont1 := TFont():New('Arial',,-15,.T.)
Private oFont2 := TFont():New('Arial',,-12,.T.)
Private oFont3 := TFont():New('Verdana',,-12,.T.)
Private oFont4 := TFont():New('Arial',,-16,.T.)

Private oSpv   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oFat   	:= LoadBitmap(GetResources(),'br_vermelho')    
Private oPvg   	:= LoadBitmap(GetResources(),'br_amarelo')    

Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    

//PREPARE ENVIRONMENT EMPRESA "10" FILIAL "01" MODULO "FAT" TABLES "AAN"   
        
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

Processa( { || Busca(),"Aguarde"})

Asort(aList3,,,{|x,y| x[2] > y[2]})

oDlg1      := MSDialog():New( 092,232,619,1472,"Hist๓rico de Faturamentos",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 000,004,236,618,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oGrp2      := TGroup():New( 008,008,072,612,"Dados do Cliente",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 024,012,{||"Cliente"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,032,008)
		oSay2      := TSay():New( 024,052,{||"oSay2"},oGrp2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,392,010)
		oSay3      := TSay():New( 040,012,{||"Endere็o"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay4      := TSay():New( 040,052,{||"oSay4"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,392,008)
		oSay5      := TSay():New( 056,012,{||"Contrato"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 056,052,{||"oSay6"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,392,008)

	oGrp3      := TGroup():New( 076,008,232,128,"Contratos",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oList 	   := TCBrowse():New(084,010,115,135,, {'','Contrato','Vlr Faturamento'},{5,30,40},;
	                            oGrp3,,,,{|| FHelp(oList:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList:SetArray(aList)
		oList:bLine := {||{If(aList[oList:nAt,len(aQtdH)+1]==0,oSpv,(If(aList[oList:nAt,len(aQtdH)+1]==1,oPvg,oFat))),;
							Alltrim(aList[oList:nAt,01]),; 
		 					 Transform(aList[oList:nAt,02],"@E 999,999,999.99")}}
    
	oTBitmap := TBitmap():New(220,010,110,010,,"\_AMC\Legendas.bmp",.T.,oGrp3, {||alert('teste')},,.F.,.F.,,,.F.,,.T.,,.F.)

	oGrp4      := TGroup():New( 076,132,232,321,"Ativos",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oList2 	   := TCBrowse():New(084,134,185,145,, {'Ativo','Modelo','Vlr Loca็ใo'},{30,40,40},;
	                            oGrp4,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{ Alltrim(aList2[oList2:nAt,01]),;
							 Alltrim(aList2[oList2:nAt,02]),;
		 					 If(aList2[oList2:nAt,03]>1,Transform(aList2[oList2:nAt,03],"@E 999,999,999.99"),'Isento')}}

	oGrp5      := TGroup():New( 076,325,232,456,"Faturamento",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oList3 	   := TCBrowse():New(084,327,125,145,, {'Pedido','Emissใo','Vlr Faturamento'},{30,40,40},;
	                            oGrp5,,,,{|| FHelp2(oList3:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{ Alltrim(aList3[oList3:nAt,01]),;
							 aList3[oList3:nAt,02],;
		 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}

	oGrp6      := TGroup():New( 076,460,232,612,"Itens Faturados",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oList4 	   := TCBrowse():New(084,462,145,145,, {'Nota','Produto','Vlr'},{30,50,30},;
	                            oGrp6,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,) 
		oList4:SetArray(aList4)
		oList4:bLine := {||{ aList4[oList4:nAt,01],;
							 aList4[oList4:nAt,02],;
		 					 Transform(aList4[oList4:nAt,03],"@E 999,999,999.99")}}

		
oBtn1      := TButton():New( 240,570,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

//Bot๕es diversos
oMenu := TMenu():New(0,0,0,0,.T.)
// Adiciona itens no Menu
oTMenuIte1 := TMenuItem():New(oDlg1,"Procurar",,,,{|| procurar()},,,,,,,,,.T.)
oTMenuIte2 := TMenuItem():New(oDlg1,"Pr้-Faturamento",,,,{|| Processa({||PreFat(),"Aguarde"})} ,,,,,,,,,.T.)
oTMenuIte3 := TMenuItem():New(oDlg1,"Envio NF/Boleto",,,,{|| NFBol()} ,,,,,,,,,.T.)
//oTMenuIte4 := TMenuItem():New(oDlg1,"Fechamento Mensal",,,,{|| Fechamento()} ,,,,,,,,,.T.)
//oTMenuIte5 := TMenuItem():New(oDlg1,"Rescisใo Contrato",,,,{|| Rescisao(oList:nAt)} ,,,,,,,,,.T.)


oMenu:Add(oTMenuIte1)
oMenu:Add(oTMenuIte2)
oMenu:Add(oTMenuIte3)
//oMenu:Add(oTMenuIte4)
//oMenu:Add(oTMenuIte5)
// Cria botใo que sera usado no Menu
oTButton1 := TButton():New( 240, 012, "Op็๕es",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
// Define botใo no Menu
oTButton1:SetPopupMenu(oMenu)
                             

oDlg1:Activate(,,,.T.)

//Reset Environment

Return                                
                                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca os contratos e historicos de faturamentos existentesบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Busca()

Local aArea	:=	GetArea()
Local cQuery   
Local nPos1	:=	0
Local nPos3	:=	0           
Local aAux3	:=	{} 
Local nNewVlr	:=	0
Local nDiasMs	:=	day(lastday(ddatabase))
Local nCont 

cQuery := "SELECT AAN_CONTRT,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,B1_DESC,AAN_XCBASE,AAN_QUANT,AAN_ULTEMI,"
cQuery += "AAN_VLRUNI,AAN_INICOB,AAN_FIMCOB,AAN_CONPAG,E4_COND,E4_DESCRI,A1_NREDUZ,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,"
cQuery += "AAM_INIVIG,AAM_FIMVIG,A1_EMAIL,AAN_XISENT,AAM_XINIMU,AAM_XPRAZO,AAM_XPERCT,AAM_XRENOV"
cQuery += " FROM "+RetSQLName("AAN")+" AAN"
cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT AND AAM.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SE4")+" E4 ON E4_CODIGO=AAN_CONPAG AND E4.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=AAN_CODPRO AND B1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"' AND AAN.D_E_L_E_T_=''" //AAN_FIMCOB>='20160801' AND

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("CONFSC02.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
      
/*
	1			2		3			4		5		  6			7		 8			9  			10		
AAN_CONTRT,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,B1_DESC,AAN_XCBASE,AAN_QUANT,AAN_ULTEMI,AAN_VLRUNI,
	11			12		13		  14		15		16		  17	  18	 19		   20      21		  22          23       24
AAN_INICOB,AAN_FIMCOB,AAN_CONPAG,E4_COND,E4_DESCRI,A1_NREDUZ,A1_NOME,A1_END,A1_BAIRRO,A1_MUN,AAM_INIVIG,AAM_FIMVIG,A1_EMAIL,AAN_XISENT
	25			26			27		28
AAM_XINIMU,AAM_XPRAZO,AAM_XPERCT,AAM_XRENOV
*/

DbSelectArea("TRB")   

While !EOF()
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
        //(TRB->AAN_QUANT*TRB->AAN_VLRUNI)
    	Aadd(aList,{TRB->AAN_CONTRT,nNewVlr,TRB->AAM_CODCLI,TRB->AAM_LOJA,;
    				Alltrim(TRB->A1_NOME)+" / "+Alltrim(TRB->A1_NREDUZ),Alltrim(TRB->A1_END),;
    				Alltrim(TRB->A1_BAIRRO),Alltrim(TRB->A1_MUN),TRB->E4_COND,TRB->E4_DESCRI,;
    				STOD(TRB->AAM_INIVIG),STOD(TRB->AAM_FIMVIG),TRB->A1_EMAIL,TRB->AAM_XINIMU,;
    				TRB->AAM_XPRAZO,TRB->AAM_XPERCT,TRB->AAM_XRENOV,0})
    Else
    	//Soma todos os itens do contrato para pegar o valor total.
    	aList[nPos1,02] += nNewVlr //(TRB->AAN_QUANT*TRB->AAN_VLRUNI)
    EndIf
    
    Aadd(aList2b,{TRB->AAN_XCBASE,Alltrim(TRB->B1_DESC),TRB->AAN_VLRUNI,TRB->AAN_CONTRT,Stod(TRB->AAN_INICOB),stod(TRB->AAN_FIMCOB)}) 
    //Itens referente aos pedidos faturados para o contrato.
    If nPos3 == 0
	    Aadd(aAux3,{TRB->AAN_CONTRT,TRB->AAM_CODCLI,TRB->AAM_LOJA})
	EndIf
        
	Dbskip()
EndDo
  
Asort(aList,,,{|x,y| x[1] < y[1]})
                
For nCont := 1 to len(aAux3)         
	//Buscando os pedidos faturados
	//cQuery := "SELECT C6_NUM,C5_EMISSAO,C6_NOTA,SUM(C6_VALOR) AS TOTAL"
	cQuery := "SELECT C6_NUM,C5_EMISSAO,C6_NOTA,C6_VALOR,C6_DESCRI,C6_ITEM,C6_QTDVEN"
	cQuery += " FROM "+RetSQLName("SC6")+" C6"
	cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5.D_E_L_E_T_=''"
	cQuery += " WHERE C6_CONTRT='"+aAux3[nCont,01]+"' AND C6_CLI='"+aAux3[nCont,02]+"' AND C6.D_E_L_E_T_=''"
	//cQuery += " GROUP BY C6_NUM,C5_EMISSAO,C6_NOTA"
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf                                                                                 
	  
	MemoWrite("CONFSC02.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	While !EOF() 
		If Ascan(aList3b,{|x| x[1] == TRB->C6_NUM}) == 0
			Aadd(aList3b,{TRB->C6_NUM,stod(TRB->C5_EMISSAO),TRB->C6_VALOR,TRB->C6_NOTA,aAux3[nCont,01],aAux3[nCont,02],aAux3[nCont,03]})
		Else
			aList3b[Ascan(aList3b,{|x| x[1] == TRB->C6_NUM}),03] += TRB->C6_VALOR
		EndIF
	    Aadd(aList4b,{TRB->C6_NOTA,substr(TRB->C6_DESCRI,1,20),TRB->C6_VALOR,TRB->C6_NUM,TRB->C6_ITEM,;
	    				aAux3[nCont,01],aAux3[nCont,02],aAux3[nCont,03],TRB->C6_QTDVEN})
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

RestArea(aArea)

Return                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/08/16   บฑฑ
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

aList2 := {}
aList3 := {}
aList4 := {}              
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

oSay2:settext(aList[nLinha,03]+'-'+aList[nLinha,04]+' - '+aList[nLinha,05])    
oSay4:settext(aList[nLinha,06]+' - '+aList[nLinha,07]+' - '+aList[nLinha,08])
oSay6:settext("Dia de Fat. "+Alltrim(cvaltochar(aList[nLinha,09]))+" - Vig๊ncia "+cvaltochar(aList[nLinha,11])+" a "+cvaltochar(aList[nLinha,12]))           

//PReenche o grid de ativos do contrato
For nCont := 1 to len(aList2b)
	If aList2b[nCont,04] == aList[nLinha,01]
		Aadd(aList2,aList2b[nCont])
	EndIf
Next nCont
     
                             
If len(aList2) < 1
	//Nao encontrou Ativos no Contrato
	Aadd(aList2,{'','',0,'','',''})
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

    
oList2:SetArray(aList2)
oList2:bLine := {||{ Alltrim(aList2[oList2:nAt,01]),;
					 Alltrim(aList2[oList2:nAt,02]),;
 					 If(aList2[oList2:nAt,03]>1,Transform(aList2[oList2:nAt,03],"@E 999,999,999.99"),'Isento')}}

oList3:SetArray(aList3)
oList3:bLine := {||{ Alltrim(aList3[oList3:nAt,01]),;
					 aList3[oList3:nAt,02],;
 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}

oList4:SetArray(aList4)
oList4:bLine := {||{ aList4[oList4:nAt,01],;
			 		 aList4[oList4:nAt,02],;
 					 Transform(aList4[oList4:nAt,03],"@E 999,999,999.99")}}

oList:refresh()
oList2:refresh()
oList3:refresh() 
oList4:refresh() 
oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/22/16   บฑฑ
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
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gera o faturamento dos pedidos do mes corrente            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

Return(cNota)
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/11/16   บฑฑ
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

U_AMCFRR01(cResp1,cResp2)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Envio da Nota de Debito e o Boleto para os clientes em   บฑฑ
ฑฑบ          ณlote.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NFBol()

Local aArea		:=	GetArea()
Local nX 

Private oBoleto,oGrupo1,oBrw1,oBotao1,oBotao2,oBotao3,oEmail,oBmp1,oBmp2,oBmp3,oBmp4,oSayB1,oSayB2,oSayB3,oSayB4,oBotao4
Private aEmail	:=	{}
 
For nX := 1 to len(aList3b)
	If strzero(month(aList3b[nX,02]),2)+cvaltochar(year(aList3b[nX,02])) == strzero(month(ddatabase),2)+cvaltochar(year(ddatabase)) .And. !Empty(aList3b[nX,01])
		nPosL1 := Ascan(aList,{|x| x[1] == aList3b[nX,05]})
		Aadd(aEmail,{.F.,aList3b[nX,04],Alltrim(aList[nPosL1,05]),If(!Empty(aList3b[nX,04]),'Enviado','Nใo enviado'),;
					 aList[nPosL1,13],aList[nPosL1,01],aList3b[nX,01],aList[nPosL1,09],aList[nPosL1,03],aList[nPosL1,04]})
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
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
		IF MsgYesNo("Atualizar o email no cadastro do cliente?","editcol - CONFSC02")
		
		endIf 
	EndIf
EndIf

RestArea(aArea)

Return                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
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
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/13/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Enviar notas e boletos por email                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Enviar()

Local aArea		:=	GetArea()
Local cSerNd	:=	Alltrim(cFilAnt+"D") 
Local nQtdLib	:=	0     
Local lGerouNF	:=	.F.
Local aArquivos	:=	{}
Local lRetorno	:=  .F.
Local lArqOk	:=	.F.
Local nAkacio
Local nI


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
				U_AMCFIN01(.T.) 
				Sleep(6000) 
			EndIf  
		Else
			MV_PAR01 := cSerNd
			MV_PAR02 := aEmail[nAkacio,02]                    
	      	aArquivos	:=	{}		
			U_AMCFIN01(.T.)
			Sleep(6000)				
		EndIf
	EndIf
Next nAkacio                    


For nAkacio := 1 to len(aEmail) 
	If aEmail[nAkacio,01]
		If aEmail[nAkacio,04] == 'Nใo enviado'
			If !Empty(aEmail[nAkacio,02])
		      	aArquivos	:=	{}
		      	lArqOk := .F.
		  		
		  		If !lArqOk
					For nI := 1 To 10   				
    					lArqOk := ChkArq("\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+aEmail[nAkacio,09]+aEmail[nAkacio,10]+".pdf")
			      		If lArqOk
							Exit
						EndIf
					Next nI
		  		EndIF
				
				cMsg := cHtml()
				Aadd(aArquivos,{"\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+aEmail[nAkacio,09]+aEmail[nAkacio,10]+".pdf",''})
				lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aEmail[nAkacio,05])+';nfe-amc@toktake.com.br','Nota de D้bito',cMsg,aArquivos,.T.)				
				//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br','cpereira@toktake.com.br','Nota de D้bito',cMsg,aArquivos,.T.)
				aEmail[nX,04] := 'Enviado'				
			Endif	
		Else
			If !Empty(aEmail[nAkacio,02])
		      	aArquivos	:=	{}
		      	lArqOk := .F.
		  		
		  		If !lArqOk
					For nI := 1 To 10   				
    					lArqOk := ChkArq("\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+aEmail[nAkacio,09]+aEmail[nAkacio,10]+".pdf")
			      		If lArqOk
							Exit
						EndIf
					Next nI
		  		EndIF
				
				cMsg := cHtml()
				Aadd(aArquivos,{"\_AMC\Nota_Debito\"+cFilAnt+"\"+aEmail[nAkacio,02]+aEmail[nAkacio,09]+aEmail[nAkacio,10]+".pdf",''})
				lRetorno := U_TTMAILN('nfe-amc@toktake.com.br',Alltrim(aEmail[nAkacio,05])+';nfe-amc@toktake.com.br','Nota de D้bito',cMsg,aArquivos,.T.)				
				//lRetorno := U_TTMAILN('nfe-amc@toktake.com.br','cpereira@toktake.com.br','Nota de D้bito',cMsg,aArquivos,.T.)
			EndIf	
		EndIf
	EndIf
Next nAkacio


//[15:28:02] Jackson: TTMAILN(cFrom,cTo,cSubject,cBody,aAttach,lConfirm,cCC,cBCC)
//[15:28:16] Jackson: U_TTMAILN('cadastro@toktake.com.br',cDestino,'Nota de D้bito',cMsg,aArquivos,.T.)



//If lGerouNF
	//MsgAlert("Finalizado, clique em OK para atualiza็ใo da tela","Enviar - CONFSC02")
	oBoleto:end()
	oDlg1:end()
	//U_CONFSC02()
//EndIF

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/16/16   บฑฑ
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

oList4:SetArray(aList4)
oList4:bLine := {||{ aList4[oList4:nAt,01],;
			 		 aList4[oList4:nAt,02],;
 					 Transform(aList4[oList4:nAt,03],"@E 999,999,999.99")}}

oList4:refresh() 
oDlg1:refresh()

RestArea(aArea)

Return

Static Function cHtml()

Local aArea	:=	GetArea()
Local cRet	:=	''

If cFilAnt == "01"

cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
cRet += "<table border='0'>"
cRet += "<thead>"
cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Camila ou C&aacute;ssio - Email: <a href='MAILTO:amc.centro@maquinadecafe.com.br'>amc.centro@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr><td><h5>Tel.: (11) 3256-9662 , (11) 3256-9026 ou Cel.: (11) 98630-0602</h5></td></tr>"
cRet += "</thead>"
cRet += "</table>"

Elseif cFilAnt == "02"

cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
cRet += "<table border='0'>"
cRet += "<thead>"
cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo "+if(ddatabase==ctod("30/03/2017"),"Nova ","")+"Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"

if ddatabase==ctod("30/03/2017")
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3> Pedimos desconsiderar o e-mail recebido esta semana com a nota e boleto da Loca็ใo de sua mแquina, pois nosso sistema gerou com inconsist๊ncia.<br>Informamos ainda que a nota permanece inalterada.</h3></td></tr><tr></tr><tr></tr><tr></tr>"
EndIf

cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Fernanda ou Simone - Email: <a href='MAILTO:amc.sul@maquinadecafe.com.br'>amc.sul@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr><td><h5>Tel.: (11) 5182-2877 , (11) 5182-7024 ou cel.: (11) 94724-8292</h5></td></tr>"
cRet += "</thead>"
cRet += "</table>"

Elseif cFilAnt == "03"

cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
cRet += "<table border='0'>"
cRet += "<thead>"
cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo "+if(ddatabase==ctod("30/03/2017"),"Nova ","")+" Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
                         
if ddatabase==ctod("30/03/2017")
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3> Pedimos desconsiderar o e-mail recebido esta semana com a nota e boleto da Loca็ใo de sua mแquina, pois nosso sistema gerou com inconsist๊ncia.<br>Informamos ainda que a nota permanece inalterada.</h3></td></tr><tr></tr><tr></tr><tr></tr>"
EndIf

cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Camila ou C&aacute;ssio - Email: <a href='MAILTO:amc.centro@maquinadecafe.com.br'>amc.centro@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr><td><h5>Tel.: (11) 3256-9662 , (11) 3256-9026 ou Cel.: (11) 98630-0602</h5></td></tr>"
cRet += "</thead>"
cRet += "</table>"

Elseif cFilAnt == "04"

cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
cRet += "<table border='0'>"
cRet += "<thead>"
cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Lilian ou Kevin - Email: <a href='MAILTO:amc.oeste@maquinadecafe.com.br'>amc.oeste@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
cRet += "<tr><td><h5>Tel.: (11) 3622-3640 , (11) 3622-3616 ou Cel.: (11) 97408.7130</h5></td></tr>"
cRet += "</thead>"
cRet += "</table>"

Endif


RestArea(aArea)

Return(cRet)                                                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina de fechamento mensal                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fechamento

Local aArea		:=	GetArea()
Local cQuery       
Local aFecha	:=	{} 

Private oFecha1,oFecha2
Private aFecha1	:=	{}
Private aFecha2	:=	{}

Private oDlF1,oGrpF1,oBrw1,oGrpF2,oBrw2,oBtnF1,oBtnF2

cQuery := "SELECT AAM_STATUS,AAM_CODCLI,AAM_LOJA,A1_NOME,A1_NREDUZ,AAN_CONTRT,AAN_ITEM,AAN_XCBASE,AAN_XISENT,AAN_CODPRO,B1_DESC,AAN_QUANT,"
cQuery += "AAN_VLRUNI,AAN_VALOR,AAN_INICOB,AAN_FIMCOB,AAN_ULTPED,AAN_ULTEMI,AAM_INIVIG,AAM_FIMVIG,AAM_XINIMU,AAM_XPRAZO,AAM_XRENOV,AAN.R_E_C_N_O_ AS REG"
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
  
MemoWrite("CONFSC02.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 

While !EOF()
    Aadd(aFecha,{TRB->AAM_STATUS,TRB->AAM_CODCLI,TRB->AAM_LOJA,TRB->A1_NOME,TRB->A1_NREDUZ,TRB->AAN_CONTRT,TRB->AAN_ITEM,;
    			TRB->AAN_XCBASE,TRB->AAN_XISENT,TRB->AAN_CODPRO,TRB->B1_DESC,TRB->AAN_QUANT,TRB->AAN_VLRUNI,TRB->AAN_VALOR,;
    			TRB->AAN_INICOB,TRB->AAN_FIMCOB,TRB->AAN_ULTPED,TRB->AAN_ULTEMI,TRB->AAM_INIVIG,TRB->AAM_FIMVIG,TRB->AAM_XINIMU,;
    			TRB->AAM_XPRAZO,TRB->AAM_XRENOV})
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
	oGrpF1     := TGroup():New( 000,004,216,202,"Contratos nใo Faturados",oDlF1,CLR_BLACK,CLR_WHITE,.T.,.F. )
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/27/16   บฑฑ
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
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Remove o Ativo do contrato                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Calcular Rescisao do Contrato                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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


oRes1      := MSDialog():New( 092,232,592,927,"Rescisใo",,,.F.,,,,,,.T.,,,.T. )

	oGRes1      := TGroup():New( 004,004,080,336,"Informa็๕es do Contrato",oRes1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSayR7      := TSay():New( 016,012,{||"Cliente                 "+cInfCl},oGRes1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR8      := TSay():New( 037,012,{||"Endere็o                "+cInfEnd},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR9      := TSay():New( 055,012,{||"Vig๊ncia do Contrato    "+cInfVig},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
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

		oSayR5      := TSay():New( 156,216,{||"Valor para Rescisใo em "+cvaltochar(dDataBase)},oGRes3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSC02  บAutor  ณMicrosiga           บ Data ณ  09/16/16   บฑฑ
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
