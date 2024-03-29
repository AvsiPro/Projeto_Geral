#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ROBRFT03  � Autor � Alexandre Venancio  � Data �30/05/2020 ���
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
User Function ROBRFT03

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
Local cTitle := "Relat�rio de Chamados"
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01    Data De                                          �
//� mv_par02    Data Ate                                         �
//� mv_par03    Finalizado                                       �
//����������������������������������������������������������������

Pergunte("ROBRFT03",.F.)

oReport := TReport():New("ROBRFT03",cTitle,If(lAuto,Nil,"ROBRFT03"), {|oReport| ReportPrint(oReport)},"") 
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

TRCell():New(oSection1,"Codigo","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_CODIGO")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Atendente","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_ATENDE")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Pedido","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_PEDVEN")[1],/*lPixel*/, /**/ )
TRCell():New(oSection1,"Nota_Chamado","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_NOTA")[1],/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Cliente"   ,"TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_CODCLI")[1],/*lPixel*/)
TRCell():New(oSection1,"Razao","TRB",/*Titulo*/,/*Picture*/,TamSX3("A1_NOME")[1],/*lPixel*/)
TRCell():New(oSection1,"Emissao"	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_EMISSA")[1],/*lPixel*/)
TRCell():New(oSection1,"Item_Nota" 	,"TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_ITEM")[1],/*lPixel*/)
TRCell():New(oSection1,"Produto","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_PROD")[1],/*lPixel*/)
TRCell():New(oSection1,"Qtd","TRB",/*Titulo*/,'@E 999.99'/*Picture*/,TamSX3("Z50_QUANT")[1],/*lPixel*/)
TRCell():New(oSection1,"Preco","TRB",/*Titulo*/,'@E 99,999.99'/*Picture*/,TamSX3("Z50_PRECO")[1],/*lPixel*/)
TRCell():New(oSection1,"Obs_Chamado","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_OBS")[1],/*lPixel*/)
TRCell():New(oSection1,"Data_Criacao","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_DTCRIA")[1],/*lPixel*/)
TRCell():New(oSection1,"Hora_Criacao","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_HRCRIA")[1],/*lPixel*/)
TRCell():New(oSection1,"Status","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_STATUS")[1],/*lPixel*/)
TRCell():New(oSection1,"Opcao_Troca","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_OPCTRC")[1],/*lPixel*/)
TRCell():New(oSection1,"Defeito","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_DEFEIT")[1],/*lPixel*/)
TRCell():New(oSection1,"Tipo_Defeito","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_TPDEFE")[1],/*lPixel*/)
TRCell():New(oSection1,"Procede","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_PROCED")[1],/*lPixel*/)
TRCell():New(oSection1,"Obs_Atend","TRB",/*Titulo*/,/*Picture*/,TamSX3("Z50_OBSATD")[1],/*lPixel*/)
TRCell():New(oSection1,"Titulo_Cobrar","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_NUM")[1],/*lPixel*/)
TRCell():New(oSection1,"Vencimento","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_VENCREA")[1],/*lPixel*/)
TRCell():New(oSection1,"Valor","TRB",/*Titulo*/,/*Picture*/,TamSX3("E1_VALOR")[1],/*lPixel*/)

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
Local aStatus   :=  {'Aberto','Atendido','Negado'}
Local aOpcTrc   :=  {'Troca Tudo','Trocar Pecas'}
Local aDefeit   :=  {'Frontal','Hastes','Charneiras','Lentes'}
Local aTpDefe   :=  strtokarr(U_ROBFAT14(),";")

For nCont := 1 to len(aTpDefe)
    Aadd(aAux,strtokarr(aTpDefe[nCont],"="))
Next nCont

aTpDefe  := aClone(aAux)
aAux     := {}
MV_PAR03 := Iif(ValType(MV_PAR03) == 'N', MV_PAR03, Val(MV_PAR03))

cQuery := "SELECT ISNULL(CAST(CAST(Z50_OBSATD AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS OBS_ATD,"
cQuery += " A1_NOME AS RAZAO,E1_NUM,E1_VENCREA,E1_VALOR,Z50_PROCED,*"
cQuery += " FROM "+RetSQLName("Z50")+" Z50"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=Z50_CODCLI AND A1_LOJA=Z50_LOJCLI AND A1.D_E_L_E_T_=' '" 
cQuery += " LEFT JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL='"+xFilial("SE1")+"' AND E1_NUM=Z50_NOTA AND E1_FILORIG=Z50_FILPED AND E1_PREFIXO='GAR' AND E1.D_E_L_E_T_=' '"
cQuery += " WHERE Z50.D_E_L_E_T_=' '
cQuery += " AND Z50_DTCRIA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuery += " AND Z50_STATUS "+Iif(MV_PAR03 == 1, "", "NOT")+" IN ('3','4')"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
        Aadd(aAux,{ TRB->Z50_CODIGO,;
                    TRB->Z50_ATENDE,;
                    TRB->Z50_PEDVEN,;
                    TRB->Z50_NOTA,;
                    TRB->Z50_CODCLI,;
                    TRB->RAZAO,;
                    TRB->Z50_EMISSA,;
                    TRB->Z50_ITEM,;
                    TRB->Z50_PROD,;
                    TRB->Z50_QUANT,;
                    TRB->Z50_PRECO,;
                    TRB->Z50_OBS,;
                    TRB->Z50_DTCRIA,;
                    TRB->Z50_HRCRIA,;
                    TRB->Z50_STATUS,;
                    TRB->Z50_OPCTRC,;
                    TRB->Z50_DEFEIT,;
                    TRB->Z50_TPDEFE,;
                    TRB->Z50_PROCED,;
                    TRB->OBS_ATD,;
                    TRB->E1_NUM,;
                    TRB->E1_VENCREA,;
                    TRB->E1_VALOR})
    
    Dbskip()
ENDDO

oReport:onPageBreak( { ||  /*oReport:SkipLine(), oSection1:PrintLine(), oReport:SkipLine() */})
		
oReport:SetMeter(TRB->(LastRec()))
dbSelectArea("TRB")               
Dbgotop()
oSection1:Init()

For nCont := 1 to len(aAux) 

    oSection1:Cell('Codigo'):SetValue(aAux[nCont,01])
    oSection1:Cell('Atendente'):SetValue(aAux[nCont,02])
    oSection1:Cell('Pedido'):SetValue(aAux[nCont,03])
    oSection1:Cell('Nota_Chamado'):SetValue(aAux[nCont,04])
    oSection1:Cell('Cliente'):SetValue(aAux[nCont,05])
    oSection1:Cell('Razao'):SetValue(aAux[nCont,06])
    oSection1:Cell('Emissao'):SetValue(stod(aAux[nCont,07]))
    oSection1:Cell('Item_Nota'):SetValue(aAux[nCont,08])
    oSection1:Cell('Produto'):SetValue(aAux[nCont,09])
    oSection1:Cell('Qtd'):SetValue(aAux[nCont,10])
    oSection1:Cell('Preco'):SetValue(aAux[nCont,11])
    oSection1:Cell('Obs_Chamado'):SetValue(aAux[nCont,12])
    oSection1:Cell('Data_Criacao'):SetValue(stod(aAux[nCont,13]))
    oSection1:Cell('Hora_Criacao'):SetValue(aAux[nCont,14])

    oSection1:Cell('Status'):SetValue(If(!Empty(aAux[nCont,15]) .AND. val(aAux[nCont,15]) <= len(aStatus),aStatus[val(aAux[nCont,15])],""))
    oSection1:Cell('Opcao_Troca'):SetValue(If(!Empty(aAux[nCont,16]),aOpcTrc[val(aAux[nCont,16])],""))
    oSection1:Cell('Defeito'):SetValue(If(!Empty(aAux[nCont,17]),aDefeit[val(aAux[nCont,17])],""))

    nPos := Ascan(aTpDefe,{|x| x[1] == aAux[nCont,18]})
    If nPos > 0
        oSection1:Cell('Tipo_Defeito'):SetValue(aTpDefe[nPos,2])
    Else
        oSection1:Cell('Tipo_Defeito'):SetValue(aAux[nCont,18])
    EndIf 
    
    oSection1:Cell('Procede'):SetValue(If(aAux[nCont,19]=="1","Sim",If(!Empty(aAux[nCont,19]),"Nao","")))
    oSection1:Cell('Obs_Atend'):SetValue(aAux[nCont,20])
    oSection1:Cell('Titulo_Cobrar'):SetValue(aAux[nCont,21])
    oSection1:Cell('Vencimento'):SetValue(cvaltochar(stod(aAux[nCont,22])))
    oSection1:Cell('Valor'):SetValue(aAux[nCont,23])
    
	oReport:IncMeter()

	If oReport:Cancel()
		Exit
	EndIf

	oSection1:PrintLine()
	

Next nCont

oSection1:Finish()
oReport:EndPage() 

Return Nil
