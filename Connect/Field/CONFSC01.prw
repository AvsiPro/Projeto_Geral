#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"    
#INCLUDE  "TBICONN.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#include "fileio.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CONFSC01 � Autor � Alexandre Venancio    � Data � 10/10/22 ���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �   Rotina de faturamento e historico.                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �                                               ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function CONFSC01

Local aPergs	:=	{}
Local aRet		:=	{}             
Local cCond		:=	space(3)
Local nCont 

Private cPeri		:=	space(4)

Private oDlg1,oGrp1,oGrp2,oSay1,oSay2,oSay6,oGrp3,oBrw1
Private oGrp5,oBrw3,oBtn1,oMenu,oGrp6,oSay3,oSay4,oSay5
Private oList,oList2,oList3,oList4,oList5,oGrp4,oSay7 
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

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF
        
oFont4:Bold := .T.
 
/*                             
alist                                               aList2b							aList3b            		aList4b

1 - N�mero do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descri��o					2 - Data Emissao		2 - Desricao
3 - C�digo Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endere�o Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condi��o de Pagamento                                                                                   9 - Quantidade
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
aAdd( aPergs ,{1,"Per�odo Faturamento 'MMAA' : ",cPeri,"@E 9999",'.T.',"",'.T.',40,.F.})  
        
If !ParamBox(aPergs ,"Parametros ",aRet)
	Return
Else
	cCond := aRet[1]
	cPeri := aRet[2]
EndIf

Processa( { || Busca(cCond),"Aguarde"})
//Aadd(aList,{'',0,'',})
Aadd(aList2,{'','',0})
Aadd(aList3,{'','',0})
Aadd(aList4,{'','',0})
Aadd(aList5,{'','','',0})

//Asort(aList3,,,{|x,y| x[2] > y[2]})

oDlg1      := MSDialog():New( 092,232,770,1672,"Hist�rico de Faturamentos",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 002,004,336,710,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oGrp2      := TGroup():New( 008,008,072,612,"Dados do Cliente",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 024,012,{||"Cliente"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,032,008)
		oSay2      := TSay():New( 024,052,{||"oSay2"},oGrp2,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,492,016)
		oSay3      := TSay():New( 040,012,{||"Endere�o"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay4      := TSay():New( 040,052,{||"oSay4"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,392,008)
		oSay5      := TSay():New( 052,012,{||"Contrato"},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 052,052,{||"oSay6"},oGrp2,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,552,008)
		oSay7      := TSay():New( 062,360,{||"Valor Excedente"},oGrp2,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,552,008)
	
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
		{'Ativo','Modelo','Vlr Loca��o','Qtd. Min.','Valor Min.','Qtd.Total','Vlr.Fat.','Vlr.Compl.'},;
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
		oList5 	   := TCBrowse():New(209,174,532,118,, {'Sele��o','Produto','Descri��o','Data Ant.','Leit.Ant.','Data Atual','Leit.Atual','Consumo','Valor Un.','Valor Fat.'},{30,40,70,30,30,30,30,30,30,30},;
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
							Transform(aList5[oList5:nAt,10],"@E 999,999,999.99")}}

	oGrp5      := TGroup():New( 076,520,202,708,"Faturamento",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oList3 	   := TCBrowse():New(084,524,182,115,, {'Pedido','Emiss�o','Vlr Faturamento'},{30,40,40},;
	                            oGrp5,,,,{|| FHelp2(oList3:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{ Alltrim(aList3[oList3:nAt,01]),;
							 aList3[oList3:nAt,02],;
		 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}
	
	/*oGrp6      := TGroup():New( 200,470,332,708,"Itens Faturados",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oList4 	   := TCBrowse():New(208,472,232,120,, {'Nota','Produto','Vlr'},{30,50,30},;
	                            oGrp6,,,,{|| /*FHelp(oList:nAt)* /},{|| /*editcol(oList:nAt)* /},, ,,,  ,,.F.,,.T.,,.F.,,,) 
		oList4:SetArray(aList4)
		oList4:bLine := {||{ aList4[oList4:nAt,01],;
							 aList4[oList4:nAt,02],;
		 					 Transform(aList4[oList4:nAt,03],"@E 999,999,999.99")}}*/

	For nCont := 1 to len(aList)
		oList:nAt := nCont
		Fhelp(nCont)
	Next nCont

	oList:nAt := 1

oBtn1      := TButton():New( 055,640,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

//Bot�es diversos
oMenu := TMenu():New(0,0,0,0,.T.)
// Adiciona itens no Menu
oTMenuIte1 := TMenuItem():New(oDlg1,"Procurar",,,,{|| procurar()},,,,,,,,,.T.)
oTMenuIte2 := TMenuItem():New(oDlg1,"Listar-Faturamento",,,,{|| Processa({||PreFat(),"Aguarde"})} ,,,,,,,,,.T.)
oTMenuIte3 := TMenuItem():New(oDlg1,"Faturar",,,,{|| Processa({||GeraPv(0),"Aguarde"})} ,,,,,,,,,.T.)
oTMenuIte4 := TMenuItem():New(oDlg1,"Envio NF/Boleto",,,,{|| NFBol()} ,,,,,,,,,.T.)
oTMenuIte5 := TMenuItem():New(oDlg1,"Fechamento Mensal",,,,{|| Fechamento()} ,,,,,,,,,.T.)
oTMenuIte6 := TMenuItem():New(oDlg1,"Rescis�o Contrato",,,,{|| Rescisao(oList:nAt)} ,,,,,,,,,.T.)


oMenu:Add(oTMenuIte1)
oMenu:Add(oTMenuIte2)
oMenu:Add(oTMenuIte3)
oMenu:Add(oTMenuIte4)
oMenu:Add(oTMenuIte5)
oMenu:Add(oTMenuIte6)
// Cria bot�o que sera usado no Menu 345, 012
oTButton1 := TButton():New( 025, 640, "Op��es",oDlg1,{||},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
// Define bot�o no Menu
oTButton1:SetPopupMenu(oMenu)

	MENU oMenuP POPUP 
	MENUITEM "Faturar" ACTION (Processa({|| GeraPv(1)},"Aguarde"))
	ENDMENU                                                                           

	oList:bRClicked := { |oObject,nX,nY| oMenuP:Activate( nX, (nY-10), oObject ) }

oDlg1:Activate(,,,.T.)

//Reset Environment

Return                                
                                                  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Busca os contratos e historicos de faturamentos existentes���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Busca(cCond)

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
Local aTabPrc 	:=	{}


cQuery := "SELECT AAN_CONTRT,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,"
cQuery += " B1_DESC,AAN_XCBASE,AAN_QUANT,AAN_ULTEMI,"
cQuery += " AAN_XMINQT,AAN_XVLRMI,"
cQuery += " AAN_VLRUNI,AAN_INICOB,AAN_FIMCOB,AAN_CONPAG,"
cQuery += " E4_COND,E4_DESCRI,A1_NREDUZ,A1_NOME,A1_END,"
cQuery += " A1_BAIRRO,A1_MUN,"
cQuery += " AAM_INIVIG,AAM_FIMVIG,A1_EMAIL,'' AS AAN_XISENT,"
cQuery += " '' AS AAM_XINIMU,'' AS AAM_XPRAZO,'' AS AAM_XPERCT,"
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
AAM_XINIMU,AAM_XPRAZO,AAM_XPERCT,AAM_XRENOV,0,AAN_FILIAL
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

	//Se o inicio da cobranca � maior que o primeiro dia do mes, ent�o deve-se cobrar pro-rata.
	If stod(TRB->AAN_INICOB) > firstday(ddatabase)
		//Quantidade de dias a serem cobrados at� o final do m�s (segundo o Cassio os contratos sempre s�o cobrados do dia 01 ao ultimo dia do mes
		nDiasCb := lastday(ddatabase) - stod(TRB->AAN_INICOB)
		//Valor a ser cobrado com a pro-rata
		nNewVlr := nVlrPro * nDiasCb                                                                                    
	//Se o fim da cobranca � menor que o ultimo dia do mes, ent�o deve-se cobrar pro-rata dos dias em que a maquina saiu.
	ElseIf stod(TRB->AAN_FIMCOB) < lastday(ddatabase)
		//Quantidade de dias a serem cobrados do primeiro at� a data da sa�da da maquina do cliente.
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
					TRB->AAM_XINIMU,;
					TRB->AAM_XPRAZO,;
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
					0}) 							//11

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
	cQuery += " WHERE C6_FILIAL='"+aAux3[nCont,04]+"'"
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
	
	cQuery := "SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,Z08_DATA,Z08_CONTRT" 
	cQuery += "  FROM "+RetSQLname("Z08")+" Z08" 
	cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
	cQuery += "   AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' ' 
	cQuery += "  WHERE  Z08_COD IN(SELECT MAX(Z08_COD) FROM "+RetSQLname("Z08")
	cQuery += "     	WHERE  Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+aList5b[nCont,02]+"'"
	cQuery += "  	AND Z08_CONTRT='"+aList5b[nCont,01]+"' AND D_E_L_E_T_=' ')
	cQuery += "  AND Z08.D_E_L_E_T_=' '
	cQuery += "  UNION 
	cQuery += "  SELECT Z08_COD,Z08_SEQUEN,Z08_SELECA,Z08_PRODUT,B1_DESC,Z08_QTDLID,Z08_DATA,Z08_CONTRT" 
	cQuery += "  FROM "+RetSQLname("Z08")+" Z08"
	cQuery += "  LEFT JOIN "+RetSQLname("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"'"
	cQuery += "		AND B1_COD=Z08_PRODUT AND B1.D_E_L_E_T_=' '" 
	cQuery += "  WHERE  Z08_COD IN(SELECT MAX(Z08_COD)-1 FROM "+RetSQLname("Z08")
	cQuery += "		WHERE  Z08_FILIAL='"+xFilial("Z08")+"' AND Z08_NUMSER='"+aList5b[nCont,02]+"'" 
	cQuery += "  	AND Z08_CONTRT='"+aList5b[nCont,01]+"' AND D_E_L_E_T_=' ')"
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

RestArea(aArea)

Return                   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/08/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Atualiza os grids de acordo com o grid principal (Contratos��
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

1 - N�mero do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descri��o					2 - Data Emissao		2 - Desricao
3 - C�digo Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endere�o Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condi��o de Pagamento                                                                                   9 - Quantidade
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


//oSay6:settext("Dia de Fat. "+Alltrim(cvaltochar(aList[nLinha,09]))+" - Vig�ncia "+cvaltochar(aList[nLinha,11])+" a "+cvaltochar(aList[nLinha,12]))           

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
 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}}
/*
oList4:SetArray(aList4)
oList4:bLine := {||{ aList4[oList4:nAt,01],;
			 		 aList4[oList4:nAt,02],;
 					 Transform(aList4[oList4:nAt,03],"@E 999,999,999.99")}}
*/
oList:refresh()
oList2:refresh()
oList3:refresh() 
//oList4:refresh() 
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

Local aArea :=	GetArea()
Local nPos  := 	0
Local nCont 
Local nTotQ	:=	0
Local nTotV :=	0
Local nTotC :=	0
Local cTexto
Local nDifCb:=	0

Default nOpini := 1

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
	Aadd(aList5,{'','','','',0,'',0,0,0,0})
EndIf 

Aeval(aList5,{|x| nTotQ += x[8]})
Aeval(aList5,{|x| nTotV += x[10]})

oList5:SetArray(aList5)
oList5:bLine := {||{ Alltrim(aList5[oList5:nAt,01]),;
						Alltrim(aList5[oList5:nAt,02]),;
						Alltrim(aList5[oList5:nAt,03]),;
						STOD(aList5[oList5:nAt,04]),;
						aList5[oList5:nAt,05],;
						STOD(aList5[oList5:nAt,06]),;
						aList5[oList5:nAt,07],;
						If(aList5[oList5:nAt,08]<>0,aList5[oList5:nAt,08],'Sem Consumo'),;
						Transform(aList5[oList5:nAt,09],"@E 999,999,999.99"),;
						Transform(aList5[oList5:nAt,10],"@E 999,999,999.99")}}

If nOpini == 0
	aList2b[nLinha,09] := nTotQ
	aList2b[nLinha,10] := nTotV
else 
	aList2[nLinha,09] := nTotQ
	aList2[nLinha,10] := nTotV
EndIf 

DbSelectArea("AAM")
DbSetOrder(1)
DbSeek(xFilial("AAM")+aList[nLinha2,01])

Aeval(aList2B,{|x| nTotC += If(x[3] > 1 .AND. x[4] == aList[nLinha2,01],x[3],0)+If(x[4] == aList[nLinha2,01],x[10],0)}) //

aList[nLinha2,02] := nTotC

Aeval(aList,{|x| x[18] := if(x[2]>1,0,1)})

cTexto := "Tabela de Pre�o "+AAM->AAM_XCODTA+" "
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
eNDiF
oList5:refresh()
oDlg1:refresh()

RestArea(aAreA)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/22/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Localizar contrato por cliente                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			MsgAlert("N�o encontrado contrato para este cliente "+aRet[1])
		EndIf
	EndIf
endIF

RestArea(aArea)

Return(.T.)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Gera o faturamento dos pedidos do mes corrente            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		�������������������������������������������������������������������������Ŀ��
		���Funcao    �MaPvlNfs  � Autor �Microsiga              � Data �28.08.1999���
		�������������������������������������������������������������������������Ĵ��
		���Descri��o �Inclusao de Nota fiscal de Saida atraves do PV liberado     ���
		�������������������������������������������������������������������������Ĵ��
		���Retorno   �                                                            ���
		�������������������������������������������������������������������������Ĵ��
		���Parametros�ExpA1: Array com os itens a serem gerados                   ���
		���          �ExpC2: Serie da Nota Fiscal                                 ���
		���          �ExpL3: Mostra Lct.Contabil                                  ���
		���          �ExpL4: Aglutina Lct.Contabil                                ���
		���          �ExpL5: Contabiliza On-Line                                  ���
		���          �ExpL6: Contabiliza Custo On-Line                            ���
		���          �ExpL7: Reajuste de preco na nota fiscal                     ���
		���          �ExpN8: Tipo de Acrescimo Financeiro                         ���
		���          �ExpN9: Tipo de Arredondamento                               ���
		���          �ExpLA: Atualiza Amarracao Cliente x Produto                 ���
		���          �ExplB: Cupom Fiscal                                         ���
		���          �ExpCC: Numero do Embarque de Exportacao                     ���
		���          �ExpBD: Code block para complemento de atualizacao dos titu- ���
		���          � los financeiros.                                           ���
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		
		/*/	
		// -> Gera a NF
   		cNota := MAPVLNFS(_aPVlNFs,_cSerie,.F.,.F.,.F.,.F.,.F.,0,0,.F., .F.)
  		
EndIf

RestArea(aArea)

Return(cNota)
      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Impressao do pre-faturamento por data.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PreFat()

Local aArea	:=	GetArea()
Local aPergs := {}
Local aRet	 := {}
Local cResp1 := ''
Local cResp2 := ''

aAdd(aPergs ,{2,"Tipo de Impress�o?","1",{"1=Sint�tico","2=Analitico"},080,'',.T.})
aAdd(aPergs ,{2,"Per�odo de Impress�o?","1",{"1=M�s","2=Somente dia"},080,'',.T.})

If !ParamBox(aPergs ,"Informe a op��o desejada",@aRet)
	Return
else
	cResp1 := If(aRet[1]=="1",'SINT�TICO','ANALITICO')
	cResp2 := aRet[2]
EndIf

U_CONFSR01(cResp1,cResp2)

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Envio da Nota de Debito e o Boleto para os clientes em   ���
���          �lote.                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function NFBol()

Local aArea		:=	GetArea()
Local nX 

Private oBoleto,oGrupo1,oBrw1,oBotao1,oBotao2,oBotao3,oEmail,oBmp1,oBmp2,oBmp3,oBmp4,oSayB1,oSayB2,oSayB3,oSayB4,oBotao4
Private aEmail	:=	{}
 
For nX := 1 to len(aList3b)
	If strzero(month(aList3b[nX,02]),2)+cvaltochar(year(aList3b[nX,02])) == strzero(month(ddatabase),2)+cvaltochar(year(ddatabase)) .And. !Empty(aList3b[nX,01])
		nPosL1 := Ascan(aList,{|x| x[1] == aList3b[nX,05]})
		Aadd(aEmail,{.F.,aList3b[nX,04],Alltrim(aList[nPosL1,05]),If(!Empty(aList3b[nX,04]),'Enviado','N�o enviado'),;
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Marcar/Desmarcar itens a enviar por email e incluir email. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Marcar/Desmarcar todos de uma so vez                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/13/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Enviar notas e boletos por email                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Enviar()

Local aArea		:=	GetArea()
Local cSerNd	:=	Alltrim(cFilAnt+"D") 
Local nQtdLib	:=	0     
//Local lGerouNF	:=	.F.
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
		If aEmail[nAkacio,04] == 'N�o enviado'
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Atualiza grid de itens faturados com o grid de pedidos   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
/*
oList4:SetArray(aList4)
oList4:bLine := {||{ aList4[oList4:nAt,01],;
			 		 aList4[oList4:nAt,02],;
 					 Transform(aList4[oList4:nAt,03],"@E 999,999,999.99")}}

oList4:refresh() */
oDlg1:refresh()

RestArea(aArea)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera html de envio do email ao cliente                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso n�o consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/01/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu c�digo de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>C&aacute;ssio - Email: <a href='MAILTO:amc.centro@maquinadecafe.com.br'>amc.centro@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 3256-9662 , (11) 3256-9026 ou Cel.: (11) 98630-0602</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realiza��es alcan�adas este ano, sejam apenas sementes plantadas, que ser�o colhidas com maior sucesso no ano vindouro. S�o os votos da Equipe da AMC Matriz. Agrade�emos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Elseif cFilAnt == "02"

	cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
	cRet += "<table border='0'>"
	cRet += "<thead>"
	cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo "+if(ddatabase==ctod("30/03/2017"),"Nova ","")+"Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
	
	if ddatabase==ctod("30/03/2017")
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3> Pedimos desconsiderar o e-mail recebido esta semana com a nota e boleto da Loca��o de sua m�quina, pois nosso sistema gerou com inconsist�ncia.<br>Informamos ainda que a nota permanece inalterada.</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	EndIf
	
	cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
	                    //2 style='color: #FF0000;'
	If !Empty(ccodbar)
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso n�o consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/02/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu c�digo de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Fernanda ou Simone - Email: <a href='MAILTO:amc.sul@maquinadecafe.com.br'>amc.sul@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 5182-2877 , (11) 5182-7024 ou cel.: (11) 94724-8292</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realiza��es alcan�adas este ano, sejam apenas sementes plantadas, que ser�o colhidas com maior sucesso no ano vindouro. S�o os votos da Equipe da AMC SUL. Agrade�emos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Elseif cFilAnt == "03"

	cRet := "<p><img style='float: left;' src='http://www.amaquinadecafe.com.br/upload/57a9089789a19_thumb.png' alt='interactive connection' width='185&quot;' /> <img style='float: left;' src='http://www.amaquinadecafe.com.br/images/logo_grupo.png' alt='interactive connection' width='265' /> <br /><br /><br /><br /> <br /><br /><br /><br /></p>"
	cRet += "<table border='0'>"
	cRet += "<thead>"
	cRet += "<tr><td><h2 style='color: #2e6c80;'>Segue anexo "+if(ddatabase==ctod("30/03/2017"),"Nova ","")+" Fatura referente a Loca&ccedil;&atilde;o de sua(s) M&aacute;quina(s) de Caf&eacute; do m&ecirc;s de <span style='color: #2b2301;'> "+mesextenso(ddatabase)+"/"+cvaltochar(year(ddatabase))+"</span></h2></td></tr>"
	                         
	if ddatabase==ctod("30/03/2017")
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3> Pedimos desconsiderar o e-mail recebido esta semana com a nota e boleto da Loca��o de sua m�quina, pois nosso sistema gerou com inconsist�ncia.<br>Informamos ainda que a nota permanece inalterada.</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	EndIf
	
	cRet += "<tr><tr><td><h2 style='color: #2e6c80;'>"+GetMV("MV_XMSGBL1")+"</span></h2></tr></tr></td>"
	
	If !Empty(ccodbar)
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso n�o consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/03/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu c�digo de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>C&aacute;ssio, Lethicia ou Paulo - Email: <a href='MAILTO:amc.centro@maquinadecafe.com.br'>amc.centro@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 3256-9662 , (11) 3256-9026 ou Cel.: (11) 98630-0602</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realiza��es alcan�adas este ano, sejam apenas sementes plantadas, que ser�o colhidas com maior sucesso no ano vindouro. S�o os votos da Equipe da AMC CENTRO. Agrade�emos por nossa parceria.</h2></td></tr>"
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
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso n�o consiga visualizar o PDF anexo, clique no link para baixar seu boleto <a href='http://danfeamc.toktake.com.br/04/"+nnota+".pdf'>Boleto</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Caso prefira, segue aqui o seu c�digo de barras para pagamento:</h4></td></tr><tr></tr><tr></tr><tr></tr>"
		cRet += "<tr><td><h2>"+ccodbar+"</h2></td></tr>"
	EndIf  
	
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h3>Em caso de d&uacute;vidas, favor entrar em contato abaixo:</h3></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr></tr><tr></tr><tr></tr><tr><td><h4>Lilian ou Vitor - Email: <a href='MAILTO:amc.oeste@maquinadecafe.com.br'>amc.oeste@maquinadecafe.com.br</a></h4></td></tr><tr></tr><tr></tr><tr></tr>"
	cRet += "<tr><td><h5>Tel.: (11) 3622-3640 , (11) 3622-3616 ou Cel.: (11) 97408.7130</h5></td></tr>"
	
	If ddatabase < ctod("31/12/2018")
		//Mensagem de natal amc
		cRet += "<tr><td><h2 style='color: #FF0000;'>Que as realiza��es alcan�adas este ano, sejam apenas sementes plantadas, que ser�o colhidas com maior sucesso no ano vindouro. S�o os votos da Equipe da AMC OESTE. Agrade�emos por nossa parceria.</h2></td></tr>"
	EndIF
	
	cRet += "</thead>"
	cRet += "</table>"

Endif

RestArea(aArea)

Return(cRet)                                                                   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/22/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Rotina de fechamento mensal                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
cQuery += "AAN_VLRUNI,AAN_VALOR,AAN_INICOB,AAN_FIMCOB,AAN_ULTPED,AAN_ULTEMI,AAM_INIVIG,AAM_FIMVIG,'' AS AAM_XINIMU,'' AS AAM_XPRAZO,'' AS AAM_XRENOV,AAN.R_E_C_N_O_ AS REG"
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
	oGrpF1     := TGroup():New( 000,004,216,202,"Contratos n�o Faturados",oDlF1,CLR_BLACK,CLR_WHITE,.T.,.F. )
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/27/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Marca e desmarca itens                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/27/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Remove o Ativo do contrato                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/28/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Calcular Rescisao do Contrato                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

1 - N�mero do Contrato             	pk				1 - Ativo						1 - Numero Pedido	fk	1 - Nota			
2 - Valor Total do Contrato							2 - Descri��o					2 - Data Emissao		2 - Desricao
3 - C�digo Cliente									3 - Valor Locacao				3 - Valor Total         3 - Valor
4 - Loja Cliente									4 - Contrato 		pk			4 - Nota                4 - Numero Pedido fk
5 - Nome Cliente / Nome Reduzido					5 - Inicio Cobranca				5 - contrato 		pk	5 - Item Pedido
6 - Endere�o Cliente								6 - Fim Cobranca				6 - Codigo Cliente      6 - Contrato
7 - Bairro                                                                          7 - Loja Cliente        7 - Codigo Cliente
8 - Cidade                                                                                                  8 - Loja Cliente 
9 - Condi��o de Pagamento                                                                                   9 - Quantidade
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


oRes1      := MSDialog():New( 092,232,592,927,"Rescis�o",,,.F.,,,,,,.T.,,,.T. )

	oGRes1      := TGroup():New( 004,004,080,336,"Informa��es do Contrato",oRes1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSayR7      := TSay():New( 016,012,{||"Cliente                 "+cInfCl},oGRes1,,oFont4,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR8      := TSay():New( 037,012,{||"Endere�o                "+cInfEnd},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
		oSayR9      := TSay():New( 055,012,{||"Vig�ncia do Contrato    "+cInfVig},oGRes1,,oFont3,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,316,008)
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

		oSayR5      := TSay():New( 156,216,{||"Valor para Rescis�o em "+cvaltochar(dDataBase)},oGRes3,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONFSC01  �Autor  �Microsiga           � Data �  09/16/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se o arquivo esta com tamanho compativel          ���
���          � maior que 100 KB                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

If nOpcG == 0
	//Faturar todos os itens liberados do array alist
ElseIf nOpcG == 1
	//Faturamento unico na linha do array alist
	For nCont := 1 to len(aList2B)
		If aList2B[nCont,04] == aList[oList:nAt,01]
			If aList2B[nCont,03] > 1
				Aadd(aLocac,{aList2B[nCont,01],;
							aList2B[nCont,03]})
			EndIf 
		EndIf 
	Next nCont

	For nCont := 1 to len(aList5B)
		If aList5B[nCont,01] == aList[oList:nAt,01] .And. len(aList5b[nCont]) > 4
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
EndIF 

If len(aItens) > 0 
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
	//aAdd( aCabec , { "C5_TRANSP"    , cAbast              , Nil } ) 
	Aadd( aCabec , { "C5_MENNOTA"   , 'Faturamento de Doses'              , Nil } )
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

		aAdd( aItC6 , aLinha ) 
		cItem := Soma1(cItem)
	Next nCont

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
		
	IF lMsErroAuto  
		MostraErro()
	ELSE
		Msgalert("Pedido gerado de faturamento de doses "+SC5->C5_NUM)
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
	//aAdd( aCabec , { "C5_TRANSP"    , cAbast              , Nil } ) 
	Aadd( aCabec , { "C5_MENNOTA"   , 'Locacao de Maquinas'              , Nil } )
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

		aAdd( aItC6 , aLinha ) 
		cItem := Soma1(cItem)
	Next nCont

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItC6,3)
		
	IF lMsErroAuto  
		MostraErro()
	ELSE
		Msgalert("Pedido gerado de loca��o "+SC5->C5_NUM)
	ENDIF    
EndIf 

RestArea(aArea)

Return
