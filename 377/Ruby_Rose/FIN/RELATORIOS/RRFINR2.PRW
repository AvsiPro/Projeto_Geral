#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RRFINR1  � Autor � Rodrigo Barrreto	  � Data �30/05/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Contas a Receber                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RRFINR2

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf	

oReport:= ReportDef()
oReport:PrintDialog()
                                               
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Venancio     �Data  �30/05/2020 ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � Dados para exibi��o                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: nReg =                                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection1 
//Local oBreak
Local cTitle := "Relat�rio de Contas a Receber"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("RRFINR2",.F.)

oReport := TReport():New("RRFINR2",cTitle,If(lAuto,Nil,"RRFINR2"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLandscape() 
oReport:cFontBody := 'Courier New' 
oReport:nFontBody := 10 

//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,"Supplier",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"EMISSAO","TRB",/*Titulo*/,/*Picture*/,13,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NRO_PEDIDO","TRB",/*Titulo*/,/*Picture*/,9,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NRO_NF","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"RAZAO_SOCIAL","TRB",/*Titulo*/,/*Picture*/,35 /*TamSX3("A1_NOME")[1]*/,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Vendedor","TRB",/*Titulo*/,/*Picture*/,28 /*TamSX3("A1_NOME")[1]*/,/*lPixel*/, /**/ )
TRCell():New(oSection1,"Situacao","TRB",/*Titulo*/,/*Picture*/,11,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Vencimento","TRB",/*Titulo*/,/*Picture*//*Picture*/,TamSX3("E1_VENCREA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Tot_Produtos"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_VALOR")[1],/*lPixel*/)
TRCell():New(oSection1,"Saldo_Tit","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_SALDO")[1],/*lPixel*/)

/*
oBreak := TRBreak():New(oSection1,oSection1:Cell("EMISSAO"),"Sub-Total")

TRFunction():New(oSection1:Cell("Tot_Produtos"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Saldo_Tit"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)

TRFunction():New(oSection1:Cell("Tot_Produtos"),"TOTAL_DESCONTOS","SUM",,,"@E 999,999,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Saldo_Tit"),"Saldo_Tit","SUM",,,"@E 999,999,999,999.99",,.F.,.T.,,oSection1)
*/

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �11/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Solicitacoes de Compras                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
Local cQuery 	:= ""
Local dAuxDt	:=	ctod('//')
Local cSitu			:= ""
Local nVlr01 	:=	0
Local nVlr02	:=	0
Local nTot01	:=	0
Local nTot02	:=	0

/*
MV_PAR01 :=	' '
MV_PAR02 := 'ZZ'
MV_PAR03 := ' '
MV_PAR04 := 'ZZ'
MV_PAR05 := CTOD('01/05/2022')
MV_PAR06 := CTOD('31/12/2030')
MV_PAR07 := ' '
*/
cQuery := " SELECT DISTINCT E1_EMISSAO AS EMISSAO,E1_PEDIDO AS Nro_Pedido,E1_NUM AS Nro_NF,"
cQuery += " E1_NOMCLI AS RAZAO_SOCIAL, E1_VENCREA AS Vencimento, E1_VALOR AS Tot_Produtos,"
cQuery += " E1_SALDO AS Saldo_Tit,A3_NREDUZ AS Vendedor FROM "+RetSQLName("SE1")+" E1"

cQuery += " 	INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"'" 
cQuery += "        AND A1_COD=E1_CLIENTE" 
cQuery += "        AND A1_LOJA=E1_LOJA" 
cQuery += "        AND A1.D_E_L_E_T_=' '" 
cQuery += "        AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" 
cQuery += "        AND A1_CGC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"  

cQuery += " 	INNER JOIN "+RetSQLName("SA3")+" A3 ON" 
cQuery += "        A3_COD=E1_VEND1 AND A3_FILIAL='"+xFilial("SA3")+"'" 
cQuery += "        AND A3.D_E_L_E_T_=' '" 
cQuery += "        AND A3_COD BETWEEN '' AND 'ZZZZZZ'" 
 
cQuery += " WHERE E1.D_E_L_E_T_=' ' " 
cQuery += " AND E1_FILIAL BETWEEN ' ' AND 'ZZZZZZ'" 
cQuery += " AND E1_EMISSAO BETWEEN '"+dtos(MV_PAR05)+"' AND '"+dtos(MV_PAR06)+"'" 
cQuery += " AND E1_SALDO > '0' " 

If !Empty(MV_PAR07) 
	cQuery += " AND E1_VEND1 ='"+MV_PAR07+"'" 
EndIf

cQuery += " ORDER BY  E1.E1_EMISSAO "


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf


cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

dAuxDt := stod(TRB->EMISSAO)

While !oReport:Cancel() .And. !TRB->(Eof()) 

	If dAuxDt <> STOD(TRB->EMISSAO)
		oReport:ThinLine()
		 
		oSection1:Cell("EMISSAO"):SetValue(dAuxDt)
		oSection1:Cell("Nro_Pedido"):SetValue("")
		oSection1:Cell("Nro_NF"):SetValue("")
		oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total na Data")
		oSection1:Cell("Vendedor"):SetValue("")
		oSection1:Cell("Situacao"):SetValue("")
		oSection1:Cell("Vencimento"):SetValue("")
		oSection1:Cell("Tot_Produtos"):SetValue(Transform(nVlr01,"@E 999,999,999.99"))
		oSection1:Cell("Saldo_Tit"):SetValue(Transform(nVlr02,"@E 999,999,999.99"))
		oSection1:PrintLine()

		oReport:SkipLine( 1 )
		//oSection1:PrintLine()
		dAuxDt := STOD(TRB->EMISSAO)
		nVlr01 := 0
		nVlr02 := 0
	EndIf

	If stod(TRB->Vencimento) >= date()
		iF TRB->Tot_Produto > TRB->Saldo_Tit
			cSitu := "Baixado Parcial"
		Else
			cSitu := "Aberto"
		EndIf
	ElseIF stod(TRB->Vencimento) < date()
		iF TRB->Tot_Produto > TRB->Saldo_Tit
			cSitu := "Baix Parc/Atrasado"
		Else
			cSitu := "Atrasado"
		EndIf
	EndIf

	oSection1:Cell("EMISSAO"):SetValue(stod(TRB->EMISSAO))
	oSection1:Cell("Nro_Pedido"):SetValue(TRB->Nro_Pedido)
	oSection1:Cell("Nro_NF"):SetValue(TRB->Nro_NF)
	oSection1:Cell("RAZAO_SOCIAL"):SetValue(TRB->RAZAO_SOCIAL)
	oSection1:Cell("Vendedor"):SetValue(TRB->Vendedor)
	oSection1:Cell("Situacao"):SetValue(cSitu)
	oSection1:Cell("Vencimento"):SetValue(stod(TRB->Vencimento))
	oSection1:Cell("Tot_Produtos"):SetValue(Transform(TRB->Tot_Produtos,"@E 999,999,999.99"))
	oSection1:Cell("Saldo_Tit"):SetValue(Transform(TRB->Saldo_Tit,"@E 999,999,999.99"))
	
	//oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()

	

	nVlr01 += TRB->Tot_Produtos
	nVlr02 += TRB->Saldo_Tit 
	nTot01 += TRB->Tot_Produtos
	nTot02 += TRB->Saldo_Tit

	
	
	dbSelectArea("TRB")
	dbSkip()
EndDo                   

oReport:ThinLine()
oReport:SkipLine( 1 ) 
oSection1:Cell("EMISSAO"):SetValue(dAuxDt)
oSection1:Cell("Nro_Pedido"):SetValue("")
oSection1:Cell("Nro_NF"):SetValue("")
oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total na Data")
oSection1:Cell("Vendedor"):SetValue("")
oSection1:Cell("Situacao"):SetValue("")
oSection1:Cell("Vencimento"):SetValue("")
oSection1:Cell("Tot_Produtos"):SetValue(Transform(nVlr01,"@E 999,999,999.99"))
oSection1:Cell("Saldo_Tit"):SetValue(Transform(nVlr02,"@E 999,999,999.99"))
oSection1:PrintLine()
	
oReport:ThinLine()
oReport:SkipLine( 1 ) 
oSection1:Cell("EMISSAO"):SetValue("")
oSection1:Cell("Nro_Pedido"):SetValue("")
oSection1:Cell("Nro_NF"):SetValue("")
oSection1:Cell("RAZAO_SOCIAL"):SetValue("Total Geral")
oSection1:Cell("Vendedor"):SetValue("")
oSection1:Cell("Situacao"):SetValue("")
oSection1:Cell("Vencimento"):SetValue("")
oSection1:Cell("Tot_Produtos"):SetValue(Transform(nTot01,"@E 999,999,999.99"))
oSection1:Cell("Saldo_Tit"):SetValue(Transform(nTot02,"@E 999,999,999.99"))
oSection1:PrintLine()

oSection1:Finish()
oReport:EndPage() 

Return Nil
