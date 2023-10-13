#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � JFISR003  � Autor � Alexandre Venancio  � Data �20/09/2023 ���
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
User Function JFISR003

Local oReport

PRIVATE lAuto     := .F. 

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("01","00020087")
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
Local cTitle := "Relat�rio de C�lculo Diferencial de Al�quota"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("JFISR003",.F.)

oReport := TReport():New("JFISR003",cTitle,If(lAuto,Nil,"JFISR003"), {|oReport| ReportPrint(oReport)},"") 
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
oSection1:= TRSection():New(oReport,"JCA",{"TRB"},/*aOrdem*/)
oSection1:SetHeaderPage()
// oSection1:SetPageBreak(.T.) // Foi usado o EndPage(.T.) pois o SetPageBreak estava saltando uma pagina em branco no inicio da impressao 
//F2_EMISSAO,F2_SERIE,F2_DOC,F2_BASEICM,D2_ALFCPST,M0_ESTENT,D2_VALICM,F2_EST,F2_BRICMS,D2_ICMSRET,D2_VFECPST
TRCell():New(oSection1,"Empresa/Filial","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_FILIAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Origem","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_ESPECIE")[1],/*lPixel*/)
TRCell():New(oSection1,"Tipo","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_ESPECIE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Serie","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_SERIE")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Documento"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_DOC")[1],/*lPixel*/)
TRCell():New(oSection1,"Chave","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_CHVNFE")[1],/*lPixel*/)
TRCell():New(oSection1,"Fornecedor"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("A2_NOME")[1],/*lPixel*/)
TRCell():New(oSection1,"UF" 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("A2_EST")[1],/*lPixel*/)
TRCell():New(oSection1,"Emiss�o","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_EMISSAO")[1],/*lPixel*/)
TRCell():New(oSection1,"Entrada","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_EMISSAO")[1],/*lPixel*/)
TRCell():New(oSection1,"CFOP","TRB",/*Titulo*/,/*Picture*/,TamSX3("D1_CF")[1],/*lPixel*/)
TRCell():New(oSection1,"Contabil","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F1_VALBRUT")[1],/*lPixel*/)
TRCell():New(oSection1,"Base","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F1_VALBRUT")[1],/*lPixel*/)
TRCell():New(oSection1,"Aliquota","TRB",/*Titulo*/,'@E 99.99'/*Picture*/,TamSX3("D1_PICM")[1],/*lPixel*/)
TRCell():New(oSection1,"ICMS Difer","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D1_ICMSRET")[1],/*lPixel*/)
TRCell():New(oSection1,"Cod Ajuste","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_ESPECIE")[1],/*lPixel*/)
TRCell():New(oSection1,"Aliq FCP","TRB",/*Titulo*/,'@E 99.99'/*Picture*/,TamSX3("D1_PICM")[1],/*lPixel*/)
TRCell():New(oSection1,"ICMS FCP","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D1_ICMSRET")[1],/*lPixel*/)
TRCell():New(oSection1,"Cod FCP","TRB",/*Titulo*/,/*Picture*/,TamSX3("F1_ESPECIE")[1],/*lPixel*/)

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


cQuery := "SELECT F1_FILIAL,F1_ESPECIE,F1_TIPO,F1_SERIE,F1_DOC,F1_CHVNFE,F1_FORNECE,F1_EST,A2_NOME,"
cQuery += " F1_EMISSAO,F1_DTDIGIT,D1_CF,F1_VALBRUT,D1_BASEICM,D1_PICM,D1_ICMSRET,D1_VALFECP,D1_VFECPST"
cQuery += " FROM "+RetSQLName("SF1")+" F1"
cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND A2.D_E_L_E_T_=' '"
cQuery += " WHERE F1.D_E_L_E_T_=' '"
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
        Aadd(aAux,{ TRB->F1_FILIAL,;
                    TRB->F1_ESPECIE,;
                    TRB->F1_TIPO,;
                    TRB->F1_SERIE,;
                    TRB->F1_DOC,;
                    TRB->F1_CHVNFE,;
                    TRB->F1_FORNECE+" - "+TRB->A2_NOME,;
                    TRB->F1_EST,;
                    TRB->F1_EMISSAO,;
                    TRB->F1_DTDIGIT,;
                    TRB->D1_CF,;
                    TRB->F1_VALBRUT,;
                    TRB->D1_BASEICM,;
                    TRB->D1_PICM,;
                    TRB->D1_ICMSRET,;
                    '',;
                    TRB->D1_VALFECP,;
                    TRB->D1_VFECPST,;
                    ''})
    
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Empresa/Filial'):SetValue(aAux[nCont,01])
    oSection1:Cell('Origem'):SetValue(aAux[nCont,02])
    oSection1:Cell('Tipo'):SetValue(aAux[nCont,03])
    oSection1:Cell('Serie'):SetValue(aAux[nCont,04])
    oSection1:Cell('Documento'):SetValue(aAux[nCont,05])
    oSection1:Cell('Chave'):SetValue(aAux[nCont,06])
    oSection1:Cell('Fornecedor'):SetValue(aAux[nCont,07])
    oSection1:Cell('UF'):SetValue(aAux[nCont,08])
    oSection1:Cell('Emiss�o'):SetValue(stod(aAux[nCont,09]))
    oSection1:Cell('Entrada'):SetValue(stod(aAux[nCont,10]))
    oSection1:Cell('CFOP'):SetValue(aAux[nCont,11])
    oSection1:Cell('Contabil'):SetValue(aAux[nCont,12])
    oSection1:Cell('Base'):SetValue(aAux[nCont,13])
    oSection1:Cell('Aliquota'):SetValue(aAux[nCont,14])
    oSection1:Cell('ICMS Difer'):SetValue(aAux[nCont,15])
    oSection1:Cell('Cod Ajuste'):SetValue(aAux[nCont,16])
    oSection1:Cell('Aliq FCP'):SetValue(aAux[nCont,17])
    oSection1:Cell('ICMS FCP'):SetValue(aAux[nCont,18])
    oSection1:Cell('Cod FCP'):SetValue(aAux[nCont,19])
  
   
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
