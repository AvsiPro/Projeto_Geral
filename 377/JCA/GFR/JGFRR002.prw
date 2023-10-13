#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � JGFRR002  � Autor � Alexandre Venancio  � Data �18/09/2023  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Durabilidade de pe�as                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function JGFRR002

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
���Programa  � ReportDef�Autor  �Alexandre Venancio     �Data  �18/09/2023 ��
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
Local cTitle := "Relat�rio de Durabilidade de pe�as"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//����������������������������������������������������������������

Pergunte("JGFRR002",.F.)

oReport := TReport():New("JGFRR002",cTitle,If(lAuto,Nil,"JGFRR002"), {|oReport| ReportPrint(oReport)},"") 
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

TRCell():New(oSection1,"Material","TRB",/*Titulo*/,/*Picture*/,TamSX3("B1_DESC")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Veiculo","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_CODBEM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Requisicao","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_NUMSA")[1]+TamSX3("TL_ITEMSA")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Data_Saida","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_DTMPFIM")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Qtde"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_QUANTID")[1],/*lPixel*/)
TRCell():New(oSection1,"Vlr.Saida","TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("TL_CUSTO")[1],/*lPixel*/)
TRCell():New(oSection1,"Vlr.Atual"	,"TRB",/*Titulo*/,'@E 999,999,999.99'/*Picture*/,TamSX3("TL_CUSTO")[1],/*lPixel*/)
TRCell():New(oSection1,"Filial" 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_FILIAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Loc","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_LOCAL")[1],/*lPixel*/)
TRCell():New(oSection1,"Km na data","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_POSCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Km Ult. Trc","TRB",/*Titulo*/,/*Picture*/,TamSX3("TL_POSCONT")[1],/*lPixel*/)
TRCell():New(oSection1,"Dt Ult. Trc","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_DTMPFIM")[1],/*lPixel*/)
TRCell():New(oSection1,"KM","TRB",/*Titulo*/,/*Picture*/,TamSX3("TJ_DTMPFIM")[1],/*lPixel*/)

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

//TL_CODIGO,B1_DESC,TJ_CODBEM,TL_NUMSA+TL_ITEMSA,TJ_DTMPFIM,TL_QUANTID,TL_CUSTO,
//TL_CUSTO,TJ_FILIAL,TL_LOCAL,TL_POSCONT,TL_SEQRELA,'ULTIMATROCA','DATAULTIMATROCA','KMULTIMATROCA'

cQuery := "SELECT TL_CODIGO,B1_DESC,TJ_CODBEM,TL_NUMSA+TL_ITEMSA AS REQUISICAO,"
cQuery += " TJ_DTMPFIM,TL_QUANTID,TL_CUSTO,TJ_FILIAL,TL_LOCAL,TJ_POSCONT,"
cQuery += " TL_SEQRELA,'ULTIMATROCA' AS ULTTROCA,'DATAULTIMATROCA' AS DATULTTR,'KMULTIMATROCA' AS KMULTTR"
cQuery += " FROM "+RetSQLName("STL")+" STL"
cQuery += " INNER JOIN "+RetSQLName("STJ")+" STJ ON TJ_FILIAL=TL_FILIAL AND TJ_ORDEM=TL_ORDEM AND TJ_PLANO=TL_PLANO AND STJ.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=TL_CODIGO AND B1.D_E_L_E_T_=' '
cQuery += " WHERE STL.D_E_L_E_T_=' '"
cQuery += " ORDER BY TJ_CODBEM,TJ_ORDEM,TL_SEQRELA DESC,TL_CODIGO"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->TL_CODIGO+Alltrim(TRB->B1_DESC),;
                TRB->TJ_CODBEM,;
                TRB->REQUISICAO,;
                TRB->TJ_DTMPFIM,;
                TRB->TL_QUANTID,;
                TRB->TL_CUSTO,;
                TRB->TL_CUSTO,;
                TRB->TJ_FILIAL,;
                TRB->TL_LOCAL,;
                TRB->TJ_POSCONT,;
                TRB->ULTTROCA,;
                TRB->DATULTTR,;
                TRB->KMULTTR })
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()


//While !oReport:Cancel() .And. !TRB->(Eof()) 
For nCont := 1 to len(aAux) 

    oSection1:Cell('Material'):SetValue(aAux[nCont,01])
    oSection1:Cell('Veiculo'):SetValue(aAux[nCont,02])
    oSection1:Cell('Requisicao'):SetValue(aAux[nCont,03])
    oSection1:Cell('Data_Saida'):SetValue(stod(aAux[nCont,04]))
    oSection1:Cell('Qtde'):SetValue(aAux[nCont,05])
    oSection1:Cell('Vlr.Saida'):SetValue(aAux[nCont,06])
    oSection1:Cell('Vlr.Atual'):SetValue(aAux[nCont,07])
    oSection1:Cell('Filial'):SetValue(aAux[nCont,08])
    oSection1:Cell('Loc'):SetValue(aAux[nCont,09])
    oSection1:Cell('Km na data'):SetValue(aAux[nCont,10])
    oSection1:Cell('Km Ult. Trc'):SetValue(aAux[nCont,11])
    oSection1:Cell('Dt Ult. Trc'):SetValue(aAux[nCont,12])
    oSection1:Cell('KM'):SetValue(aAux[nCont,13])
    
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	

Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
