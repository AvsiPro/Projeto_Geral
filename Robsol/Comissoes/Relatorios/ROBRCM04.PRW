#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ROBRCM04  � Autor � Alexandre Venancio  � Data �30/05/2020 ���
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
User Function ROBRCM04

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
Local cTitle := "Relat�rio de Restri��es"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("ROBRFT02",.F.)

oReport := TReport():New("ROBRCM04",cTitle,If(lAuto,Nil,"ROBRFT02"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLandscape() 

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
oSection1:= TRSection():New(oReport,"Robsol",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

TRCell():New(oSection1,"Cupom","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_NUM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Razao_Social","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Cnpj","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_CGC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Fantasia"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NREDUZ")[1],/*lPixel*/)
TRCell():New(oSection1,"Marca","TRB",/*Titulo*/,/*Picture*/,TamSX3("BM_XMODELO")[1],/*lPixel*/)
TRCell():New(oSection1,"Qtd"	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("C6_QTDVEN")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor" 	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("C6_VALOR")[1],/*lPixel*/)
TRCell():New(oSection1,"Pagto","TRB",/*Titulo*/,/*Picture*/,TamSX3("E4_COND")[1],/*lPixel*/)
TRCell():New(oSection1,"Vendedor","TRB",/*Titulo*/,/*Picture*/,TamSX3("A3_NOME")[1],/*lPixel*/)
TRCell():New(oSection1,"Cidade","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_MUN")[1],/*lPixel*/)
TRCell():New(oSection1,"UF","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_EST")[1],/*lPixel*/)
TRCell():New(oSection1,"Equipe","TRB",/*Titulo*/,/*Picture*/,TamSX3("A3_NOME")[1],/*lPixel*/)
TRCell():New(oSection1,"Situacao","TRB",/*Titulo*/,/*Picture*/,TamSX3("C5_XOBSLIB")[1],/*lPixel*/)

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
Local aAux      :=  {}
Local nCont

cQuery := "SELECT CONVERT(VARCHAR(4098),C5_XOBSLIB) AS Situacao,"
cQuery += " C5_NUM AS Cupom,C5_EMISSAO AS Emissao,"
cQuery += " A1_NOME AS Razao_Social,A1_CGC AS Cnpj,"
cQuery += " A1_NREDUZ AS Fantasia,E4_DESCRI AS Pagto,"
cQuery += " A1_MUN AS Cidade,A1_EST AS UF,"
cQuery += " A3.A3_NOME AS Vendedor,A32.A3_NOME AS Equipe,"
cQuery += " BM_XMODELO AS Marca,SUM(C6_QTDVEN) AS Qtd,SUM(C6_VALOR) AS Valor"
cQuery += " FROM "+RetSQLName("SC5")+" C5"
cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SE4")+" E4 ON E4_FILIAL='"+xFilial("SE4")+"' AND E4_CODIGO=C5_CONDPAG AND E4.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA3")+" A3 ON A3.A3_FILIAL='"+xFilial("SA3")+"' AND A3.A3_COD=C5_VEND1 AND A3.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SA3")+" A32 ON A32.A3_FILIAL='"+xFilial("SA3")+"' AND A32.A3_COD=A3.A3_GEREN AND A32.D_E_L_E_T_=' '"
cQuery += " WHERE C5_FILIAL BETWEEN '0101' AND '0103' AND C5_ZZSTATU='B'"
cQuery += " AND C5.D_E_L_E_T_=' '"
cQuery += " AND C5_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
cQuery += " GROUP BY C5_XOBSLIB,C5_NUM,C5_EMISSAO,A1_NOME,A1_CGC,A1_NREDUZ,E4_DESCRI,A1_MUN,A1_EST,A3.A3_NOME,A32.A3_NOME,BM_XMODELO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->Cupom,;
                STOD(TRB->Emissao),;
                TRB->Razao_Social,;
                TRB->Cnpj,;
                TRB->Fantasia,;
                TRB->Marca,;
                TRB->Qtd,;
                TRB->Valor,;
                TRB->Pagto,;
                TRB->Vendedor,;
                TRB->Cidade,;
                TRB->UF,;
                TRB->Equipe,;
                TRB->Situacao})
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Cupom'):SetValue(aAux[nCont,01])
    oSection1:Cell('Emissao'):SetValue(aAux[nCont,02])
    oSection1:Cell('Razao_Social'):SetValue(aAux[nCont,03])
    oSection1:Cell('Cnpj'):SetValue(aAux[nCont,04])
    oSection1:Cell('Fantasia'):SetValue(aAux[nCont,05])
    oSection1:Cell('Marca'):SetValue(aAux[nCont,06])
    oSection1:Cell('Qtd'):SetValue(aAux[nCont,07])
    oSection1:Cell('Valor'):SetValue(aAux[nCont,08])
    oSection1:Cell('Pagto'):SetValue(aAux[nCont,09])
    oSection1:Cell('Vendedor'):SetValue(aAux[nCont,10])
    oSection1:Cell('Cidade'):SetValue(aAux[nCont,11])
    oSection1:Cell('UF'):SetValue(aAux[nCont,12])
    oSection1:Cell('Equipe'):SetValue(aAux[nCont,13])
    oSection1:Cell('Situacao'):SetValue(aAux[nCont,14])
    
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
/*	dbSelectArea("TRB")
	dbSkip()
EndDo                     
*/
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
