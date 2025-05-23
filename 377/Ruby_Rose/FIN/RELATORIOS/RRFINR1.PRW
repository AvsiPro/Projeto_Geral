#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RRFINR1  � Autor � Alexandre Venancio  � Data �30/05/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Vendas						                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RRFINR1

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
Local oBreak
Local cTitle := "Relat�rio de Vendas"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("RRFINR1",.F.)

oReport := TReport():New("RRFINR1",cTitle,If(lAuto,Nil,"RRFINR1"), {|oReport| ReportPrint(oReport)},"") 
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

TRCell():New(oSection1,"EMISSAO","TRB",/*Titulo*/,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"COD_CLIENTE","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_CLIENTE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"RAZAO_SOCIAL","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Vlr_Produtos","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_VALMERC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Desconto"   ,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_DESCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Total_Bruto","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_VALBRUT")[1],/*lPixel*/)
TRCell():New(oSection1,"Total_ST"	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_ICMSRET")[1],/*lPixel*/)
TRCell():New(oSection1,"Total_IPI" 	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_VALIPI")[1],/*lPixel*/)
TRCell():New(oSection1,"Total_FCP_ST","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_BSFCPST")[1],/*lPixel*/)
TRCell():New(oSection1,"Vlr_Pedido","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_VALMERC")[1],/*lPixel*/)


oBreak := TRBreak():New(oSection1,oSection1:Cell("EMISSAO"),"Sub-Total")

TRFunction():New(oSection1:Cell("Vlr_Produtos"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Desconto"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_Bruto"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_ST"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_IPI"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Total_FCP_ST"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)
TRFunction():New(oSection1:Cell("Vlr_Pedido"),"Total Grupos","SUM",oBreak,,,,.F.,.F.)

TRFunction():New(oSection1:Cell("Vlr_Produtos"),"TOTAL_PRODUTOS","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Desconto"),"TOTAL_DESCONTOS","SUM",,,"@E 99,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Total_Bruto"),"TOTAL_COM_IMPOSTOS","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Total_ST"),"TOTAL_ST","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Total_IPI"),"TOTAL_IPI","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Total_FCP_ST"),"TOTAL_FCP_ST","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)
TRFunction():New(oSection1:Cell("Vlr_Pedido"),"TOTAL_PRODUTOS","SUM",,,"@E 999,999,999.99",,.F.,.T.,,oSection1)

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
Local dAuxDt	:=	ctod(' / / ')

cQuery := " SELECT F2_EMISSAO AS EMISSAO,F2_CLIENTE AS COD_CLIENTE,A1_NOME AS RAZAO_SOCIAL,"
cQuery += " F2_VALMERC AS Vlr_Produtos,F2_DESCONT AS Desconto,"
cQuery += " F2_VALBRUT AS Total_Bruto,F2_ICMSRET AS Total_ST,F2_VALIPI AS Total_IPI,F2_BSFCPST AS Total_FCP_ST,"
cQuery += " (SELECT SUM(C6_VALOR)  FROM "+RetSQLName("SD2")+" SD2"
cQuery += "		INNER JOIN "+RetSQLName("SC6")+" SC6"
cQuery += "		ON D2_FILIAL = C6_FILIAL"
cQuery += "		AND D2_PEDIDO=C6_NUM"
cQuery += "		AND D2_ITEMPV=C6_ITEM"
cQuery += "		AND D2_CLIENTE=C6_CLI"
cQuery += "		AND D2_LOJA=C6_LOJA"
cQuery += "		AND SC6.D_E_L_E_T_=' '"
cQuery += "		WHERE D2_FILIAL = F2_FILIAL"
cQuery += "		AND D2_SERIE = F2_SERIE"
cQuery += "		AND D2_DOC = F2_DOC"
cQuery += "		AND D2_TIPO = F2_TIPO"
cQuery += "		AND D2_CLIENTE = F2_CLIENTE"
cQuery += "		AND D2_LOJA = F2_LOJA" 
//cQuery += "     AND D2_PEDIDO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
cQuery += "	) AS Vlr_Pedido" 
cQuery += " FROM "+RetSQLName("SF2")+" F2" 
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"'" 
cQuery += "        AND A1_COD=F2_CLIENTE" 
cQuery += "        AND A1_LOJA=F2_LOJA" 
cQuery += "        AND A1.D_E_L_E_T_=' '" 
cQuery += "        AND A1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'" 
cQuery += "        AND A1_CGC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"  
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A3 ON A3_FILIAL='"+xFilial("SA3")+"'"
cQuery += " 		AND A3_COD=F2_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " AND A3_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"  
cQuery += " WHERE  F2.D_E_L_E_T_=' '" 
cQuery += "        AND F2_FILIAL BETWEEN ' ' AND 'ZZZ'" 
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(MV_PAR07)+"' AND '"+dtos(MV_PAR08)+"'"
//cQuery += " AND F2_DOC BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'" 
cQuery += " ORDER BY  F2.F2_EMISSAO,F2.F2_VEND1,F2.F2_CLIENTE "

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

	oSection1:Cell("EMISSAO"):SetValue(stod(TRB->EMISSAO))
	oSection1:Cell(TRB->COD_CLIENTE)
	oSection1:Cell(TRB->RAZAO_SOCIAL)
	oSection1:Cell(TRB->Vlr_Produtos)
	oSection1:Cell(TRB->Desconto)
	oSection1:Cell(TRB->Total_Bruto)
	oSection1:Cell(TRB->Total_ST)
	oSection1:Cell(TRB->Total_IPI)
	oSection1:Cell(TRB->Total_FCP_ST)
	oSection1:Cell(TRB->Vlr_Pedido)

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	If dAuxDt <> STOD(TRB->EMISSAO)
		oReport:ThinLine()
		dAuxDt := STOD(TRB->EMISSAO)
	EndIf

	oSection1:PrintLine()
	
	dbSelectArea("TRB")
	dbSkip()
EndDo                     
	
oSection1:Finish()
oReport:EndPage() 

Return Nil
