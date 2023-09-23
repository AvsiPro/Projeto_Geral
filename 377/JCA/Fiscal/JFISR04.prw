#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � JFISR04  � Autor � Alexandre Venancio  � Data �20/09/2023 ���
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
User Function JFISR04

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
Local cTitle := "Relat�rio de DIFAL"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("JFISR03",.F.)

oReport := TReport():New("JFISR04",cTitle,If(lAuto,Nil,"JFISR03"), {|oReport| ReportPrint(oReport)},"") 
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
TRCell():New(oSection1,"Emissao","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_EMISSAO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Serie","TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_SERIE")[1],/*lPixel*/)
TRCell():New(oSection1,"Documento","TRB",/*Titulo*/,/*Picture*/,TamSX3("F3_NFISCAL")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Base","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_BRICMS")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"% DIFAL","TRB",/*Titulo*/,'@E 99.99'/*Picture*/,TamSX3("D2_ALFCPST")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"UF_Origem"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_EST")[1],/*lPixel*/)
TRCell():New(oSection1,"ICMS Origem","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("F2_BRICMS")[1],/*lPixel*/)
TRCell():New(oSection1,"UF_Destino"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("F2_EST")[1],/*lPixel*/)
TRCell():New(oSection1,"ICMS Destino" 	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D2_VALICM")[1],/*lPixel*/)
TRCell():New(oSection1,"Vlr. FCP","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("D2_VFECPST")[1],/*lPixel*/)

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


cQuery := "SELECT F2_EMISSAO,F2_SERIE,F2_DOC,F2_BASEICM,D2_ALFCPST,M0_ESTENT,D2_VALICM,F2_EST,F2_BRICMS,D2_ICMSRET,D2_VFECPST"
cQuery += " FROM "+RetSQLName("SF2")+" F2
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA AND D2_VFECPST<>0
cQuery += " INNER JOIN SYS_COMPANY SM0 ON M0_CODFIL=F2_FILIAL AND SM0.D_E_L_E_T_=' '"
cQuery += " WHERE " //F2.D_E_L_E_T_=' ' AND
cQuery += " F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
   
        Aadd(aAux,{ TRB->F2_EMISSAO,;
                    TRB->F2_SERIE,;
                    TRB->F2_DOC,;
                    TRB->F2_BASEICM,;
                    TRB->D2_ALFCPST,;
                    TRB->M0_ESTENT,;
                    TRB->D2_VALICM,;
                    TRB->F2_EST,;
                    TRB->D2_ICMSRET,;
                    TRB->D2_VFECPST})
    
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,01]))
    oSection1:Cell('Serie'):SetValue(aAux[nCont,02])
    oSection1:Cell('Documento'):SetValue(aAux[nCont,03])
    oSection1:Cell('Base'):SetValue(aAux[nCont,04])
    oSection1:Cell('% DIFAL'):SetValue(aAux[nCont,05])
    oSection1:Cell('UF_Origem'):SetValue(aAux[nCont,06])
    oSection1:Cell('ICMS Origem'):SetValue(aAux[nCont,07])
    oSection1:Cell('UF_Destino'):SetValue(aAux[nCont,08])
    oSection1:Cell('ICMS Destino'):SetValue(aAux[nCont,09])
    oSection1:Cell('Vlr. FCP'):SetValue(aAux[nCont,10])
   
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	
Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
