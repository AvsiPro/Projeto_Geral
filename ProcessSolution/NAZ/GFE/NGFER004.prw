#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � NGFER004  � Autor � AlexANDre Venancio  � Data �10/04/2025 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relat�rio de Valores de Frete por Regional por cliente     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function NGFER004

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
Local cTitle := "Relat�rio de Fretes por produto"
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
TRCell():New(oSection1,"C�digo Item","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_ITEM")[1],/*lPixel*/)
TRCell():New(oSection1,"Descri��o Item","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_DSITEM")[1],/*lPixel*/)
TRCell():New(oSection1,"C�digo Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_CDDEST")[1],/*lPixel*/)
TRCell():New(oSection1,"Nome Cliente","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW1_NMDEST")[1],/*lPixel*/)
TRCell():New(oSection1,"Nota Fiscal","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_NRDC")[1],/*lPixel*/)
TRCell():New(oSection1,"Peso Faturado","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_PESOR")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor do Item","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Valor Frete s/ Imposto","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Valor Frete p/ Item","TRB",/*Titulo*/,/*Picture*/,TamSX3("GW8_VALOR")[1],/*lPixel*/,/*{|| code-block de impressao }*/)


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

cQuery := " SELECT GW1_REGCOM,GW8_ITEM,GW8_DSITEM,GW8_NRDC,GW1_CDDEST,GW8_PESOR,GW8_VALOR  " 
cQuery += " FROM " + RetSQLName("GW1") + " GW1  " 
cQuery += " INNER JOIN " + RetSQLName("GW8") + " GW8 ON GW8_FILIAL = GW1_FILIAL AND GW1_CDTPDC=GW8_CDTPDC AND GW1_EMISDC=GW8_EMISDC AND GW1_SERDC=GW8_SERDC AND GW1_NRDC=GW8_NRDC AND GW8.D_E_L_E_T_=' '  " 
cQuery += " WHERE GW1_FILIAL+GW1_NRDC+GW1_CDTPDC+GW1_SERDC+GW1_EMISDC IN "
cQuery += "      (SELECT GW4_FILIAL+GW4_NRDC+GW4_TPDC+GW4_SERDC+GW4_EMISDC FROM " + RetSQLName("GW4") + " GW4  " 
cQuery += "         INNER JOIN " + RetSQLName("GW3") + " GW3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_EMISDF = GW4_EMISDF AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND GW3_DTEMIS = GW4_DTEMIS AND GW3.D_E_L_E_T_=' ' " 
cQuery += " WHERE GW4.D_E_L_E_T_=' ')  " 
cQuery += " AND GW1_DTEMIS BETWEEN '20250101' AND '20250131' AND GW1_REGCOM<>' '  " 
//cQuery += " GROUP BY GW1_REGCOM,GW1_CDDEST  " 
cQuery += " ORDER BY 1  " 

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()

    ////POSICIONE("GU3",1,XFILIAL("GU3")+GW1->GW1_CDDEST,"GU3_NMEMIT")   
    //POSICIONE("GU3",1,XFILIAL("GU3")+GW3->GW3_EMISDF,"GU3_NMEMIT")                                 
//GW1_REGCOM,GW8_ITEM,GW8_DSITEM,GW8_NRDC,GW1_CDDEST,GW8_PESOR,GW8_VALOR
    nPos := Ascan(aAux,{|x| x[2]+x[3]+x[5] == TRB->GW1_REGCOM+TRB->GW8_ITEM+TRB->GW1_CDDEST})

        Aadd(aAux,{ '01 A 31',;
                    TRB->GW1_REGCOM,;
                    TRB->GW8_ITEM,;
                    TRB->GW8_DSITEM,;
                    TRB->GW1_CDDEST,;
                    POSICIONE("GU3",1,XFILIAL("GU3")+TRB->GW1_CDDEST,"GU3_NMEMIT"),;
                    TRB->GW8_NRDC,;
                    TRB->GW8_PESOR,;
                    TRB->GW8_VALOR,;
                    0,;
                    0})
        

    Dbskip()
ENDDO


oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
oReport:SetMeter(TRB->(LastRec()))

oSection1:Init()

For nCont := 1 to len(aAux) 

    oSection1:Cell('Data'):SetValue(STOD(aAux[nCont,01]))
    oSection1:Cell('Regional'):SetValue(aAux[nCont,02])
    oSection1:Cell('C�digo Item'):SetValue(aAux[nCont,03])
    oSection1:Cell('Descri��o Item'):SetValue(aAux[nCont,04])
    oSection1:Cell('C�digo Cliente'):SetValue(aAux[nCont,05])
    oSection1:Cell('Nome Cliente'):SetValue(aAux[nCont,06])
    oSection1:Cell('Nota Fiscal'):SetValue(aAux[nCont,07])
    oSection1:Cell('Peso Faturado'):SetValue(aAux[nCont,08])
    oSection1:Cell('Valor Frete s/ Imposto'):SetValue(aAux[nCont,09])
    oSection1:Cell('Valor Frete p/ Item'):SetValue(aAux[nCont,10])
    
    oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont


oSection1:Finish()
oReport:EndPage() 

Return Nil


// SELECT GW1_REGCOM,GW1_CDDEST,SUM(GW8_VALOR) AS TOTAL   
// FROM GW1010 GW1   
// INNER JOIN GW8010 GW8 ON GW8_FILIAL = GW1_FILIAL AND GW1_CDTPDC=GW8_CDTPDC AND GW1_EMISDC=GW8_EMISDC AND GW1_SERDC=GW8_SERDC AND GW1_NRDC=GW8_NRDC AND GW8.D_E_L_E_T_=' '   
// WHERE GW1_FILIAL+GW1_NRDC+GW1_CDTPDC+GW1_SERDC+GW1_EMISDC IN 
//      (SELECT GW4_FILIAL+GW4_NRDC+GW4_TPDC+GW4_SERDC+GW4_EMISDC FROM GW4010 GW4   
//         INNER JOIN GW3010 GW3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_EMISDF = GW4_EMISDF AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND GW3_DTEMIS = GW4_DTEMIS AND GW3.D_E_L_E_T_=' '  
// WHERE GW4.D_E_L_E_T_=' ')   
// AND GW1_DTEMIS BETWEEN '20250101' AND '20250131' AND GW1_REGCOM<>' '  
// GROUP BY GW1_REGCOM,GW1_CDDEST  
// ORDER BY 1  
