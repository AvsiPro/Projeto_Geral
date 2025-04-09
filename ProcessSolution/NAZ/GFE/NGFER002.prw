#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � NGFER002  � Autor � Alexandre Venancio  � Data �08/04/2025 ���
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
���Programa  � ReportDef�Autor  �Alexandre Venancio     �Data  �20/09/2023 ��
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
oSection1:= TRSection():New(oReport,"NAZ",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 

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

cQuery := "SELECT F2_SERIE AS SERIE,F2_DOC AS NOTA,F2_EMISSAO AS EMISSAO,D2_CF AS CFOP,D2_CLASFIS AS CST,A1_CGC AS CNPJ,'S - '+X5_DESCRI AS TIPOMOV,F2_VALBRUT AS VALOR,
cQuery += " D2_PICM AS ALIQUOTA,F2_BASEICM AS BASE,F2_VALICM AS VALICM,F2_CHVNFE AS CHAVE 
cQuery += " FROM "+RetSQLName("SF2")+" F2
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND A1.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SX5")+" X5 ON X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='13' AND X5_CHAVE=D2_CF AND X5.D_E_L_E_T_=' '
cQuery += " WHERE F2.D_E_L_E_T_=' '
cQuery += " AND F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
cQuery += " UNION ALL
cQuery += " SELECT F1_SERIE AS SERIE,F1_DOC AS NOTA,F1_EMISSAO AS EMISSAO,D1_CF AS CFOP,D1_CLASFIS AS CST,A2_CGC AS CNPJ,'E - '+X5_DESCRI AS TIPOMOV,F1_VALBRUT AS VALOR,
cQuery += " D1_PICM AS ALIQUOTA,F1_BASEICM AS BASE,F1_VALICM AS VALICM,F1_CHVNFE AS CHAVE 
cQuery += " FROM "+RetSQLName("SF1")+" F1
cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND A2.D_E_L_E_T_=' '
cQuery += " INNER JOIN "+RetSQLName("SX5")+" X5 ON X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='13' AND X5_CHAVE=D1_CF AND X5.D_E_L_E_T_=' '
cQuery += " WHERE F1.D_E_L_E_T_=' '
cQuery += " AND F1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
// SERIE,NOTA,EMISSAO,CFOP,CST,CNPJ,TIPOMOV,VALOR,ALIQUOTA,BASE,VALICM,CHAVE

    nPos := Ascan(aAux,{|x| x[1]+x[3]+x[11] == TRB->SERIE+TRB->NOTA+TRB->CFOP})
    If nPos == 0
   
        Aadd(aAux,{ TRB->SERIE,;
                    '',;
                    TRB->NOTA,;
                    TRB->EMISSAO,;
                    TRB->CNPJ,;
                    TRB->TIPOMOV,;
                    TRB->VALOR,;
                    TRB->BASE,;
                    TRB->ALIQUOTA,;
                    TRB->VALICM,;
                    TRB->CFOP,;
                    TRB->CST,;
                    TRB->CHAVE,;
                    '',;
                    '',;
                    '',;
                    '',;
                    ''})
    
    EndIf
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Serie'):SetValue(aAux[nCont,01])
    oSection1:Cell('Pulo'):SetValue(aAux[nCont,02])
    oSection1:Cell('Nota Fiscal'):SetValue(aAux[nCont,03])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,04]))
    oSection1:Cell('CNPJ Destino'):SetValue(aAux[nCont,05])
    oSection1:Cell('Tipo Sa�da'):SetValue(aAux[nCont,06])
    oSection1:Cell('Valor'):SetValue(aAux[nCont,07])
    oSection1:Cell('Base'):SetValue(aAux[nCont,08])
    oSection1:Cell('Aliq.'):SetValue(aAux[nCont,09])
    oSection1:Cell('ICMS'):SetValue(aAux[nCont,10])
    oSection1:Cell('CFOP'):SetValue(aAux[nCont,11])
    oSection1:Cell('CST'):SetValue(aAux[nCont,12])
    oSection1:Cell('Chave de Acesso'):SetValue(aAux[nCont,13])
    oSection1:Cell('MOD'):SetValue(aAux[nCont,14])
    oSection1:Cell('GLB'):SetValue(aAux[nCont,15])
    oSection1:Cell('SEF'):SetValue(aAux[nCont,16])
    oSection1:Cell('INT'):SetValue(aAux[nCont,17])
    oSection1:Cell('ESF'):SetValue(aAux[nCont,18])
    

	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
