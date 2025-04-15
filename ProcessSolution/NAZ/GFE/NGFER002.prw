#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � NGFER002  � Autor � AlexANDre Venancio  � Data �08/04/2025 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de Valores de Frete por Regional                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NGFER002

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","11")
EndIf	

oReport:= ReportDef()
oReport:PrintDialog()
                                               
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �AlexANDre Venancio     �Data  �20/09/2023 ��
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
Local cTitle := "Relat�rio de Analise de Notas de Sa�da"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("GFER040",.F.)

oReport := TReport():New("GFER040",cTitle,If(lAuto,Nil,"GFER040"), {|oReport| ReportPrint(oReport)},"") 
oReport:SetLANDscape() 

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
oSection1:= TRSection():New(oReport,"NAZ",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltANDo uma pagina em branco no inicio da impressao 

//Periodo	Regional	Valor Faturamento Bruto	Valor de frete s/ imposto 	% Frete s/ imposto

TRCell():New(oSection1,"Data","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_DTEMIS")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Regional","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_REGCOM")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor Faturamento Bruto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor Frete s/ Imposto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"% Frete s/ Imposto","TRB",/*Titulo*/,'@R 999%'/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �AlexANDre Inacio Lemes �Data  �11/07/2006���
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

cQuery := " SELECT GW1_DTEMIS,GW1_REGCOM,SUM(GW8_VALOR) AS TOTAL  " 
cQuery += " FROM " + RetSQLName("GW1") + " GW1  " 
cQuery += " INNER JOIN " + RetSQLName("GW8") + " GW8 ON GW8_FILIAL = GW1_FILIAL AND GW1_CDTPDC=GW8_CDTPDC AND GW1_EMISDC=GW8_EMISDC AND GW1_SERDC=GW8_SERDC AND GW1_NRDC=GW8_NRDC AND GW8.D_E_L_E_T_=' '  " 
cQuery += " WHERE GW1_FILIAL+GW1_NRDC+GW1_CDTPDC+GW1_SERDC+GW1_EMISDC IN "
cQuery += "      (SELECT GW4_FILIAL+GW4_NRDC+GW4_TPDC+GW4_SERDC+GW4_EMISDC FROM " + RetSQLName("GW4") + " GW4  " 
cQuery += "         INNER JOIN " + RetSQLName("GW3") + " GW3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_EMISDF = GW4_EMISDF AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND GW3_DTEMIS = GW4_DTEMIS AND GW3.D_E_L_E_T_=' ' " 
cQuery += " WHERE GW4.D_E_L_E_T_=' ')  " 
cQuery += " AND GW1_DTEMIS BETWEEN '20250101' AND '20250131' AND GW1_REGCOM<>' '  " 
cQuery += " GROUP BY GW1_DTEMIS,GW1_REGCOM  " 
cQuery += " ORDER BY 1  " 

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
// SERIE,NOTA,EMISSAO,CFOP,CST,CNPJ,TIPOMOV,VALOR,ALIQUOTA,BASE,VALICM,CHAVE

    //nPos := Ascan(aAux,{|x| x[1]+x[3]+x[11] == TRB->SERIE+TRB->NOTA+TRB->CFOP})
    //If nPos == 0
   
        Aadd(aAux,{ TRB->GW1_DTEMIS,;
                    TRB->GW1_REGCOM,;
                    TRB->TOTAL,;
                    0,;
                    0})
    
    //EndIf
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

For nCont := 1 to len(aAux) 
// TRCell():New(oSection1,"Data","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_DTEMIS")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
// TRCell():New(oSection1,"Regional","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_REGCOM")[1],/*lPixel*/)
// TRCell():New(oSection1,"Valor Faturamento Bruto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
// TRCell():New(oSection1,"Valor Frete s/ Imposto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/, /**/ )
// TRCell():New(oSection1,"% Frete s/ Imposto"

    oSection1:Cell('Data'):SetValue(STOD(aAux[nCont,01]))
    oSection1:Cell('Regional'):SetValue(aAux[nCont,02])
    oSection1:Cell('Valor Faturamento Bruto'):SetValue(aAux[nCont,03])
    oSection1:Cell('Valor Frete s/ Imposto'):SetValue(aAux[nCont,04])
    oSection1:Cell('% Frete s/ Imposto'):SetValue(aAux[nCont,05])
    

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
