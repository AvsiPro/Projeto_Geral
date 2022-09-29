#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������Ŀ��
���Programa  �R01TOKTAKE| Autor � Claudio Dias Junior (Focus Consultoria)  | Data � 01/01/10 ���
��������������������������������������������������������������������������������������������Ĵ��
���Descricao � Relat�rio Pol�tica de Estoque                                                 ���
��������������������������������������������������������������������������������������������Ĵ��
���Parametros� Parametro                                                               		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Retorno   � Parametro                                                                     ���
��������������������������������������������������������������������������������������������Ĵ��
���Espec�fico� TOKTAKE                                                                 		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                                       		 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
���������������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������*/

User Function R01TOKTAKE()

	Local cDesc1         	:= "Relat�rio Pol�tica de Estoque"
	Local cDesc2         	:= ""
	Local cDesc3         	:= "Vers�o 01/01/2010"
	Local cPict         	:= ""
	Local titulo       		:= "Relat�rio Pol�tica de Estoque"
	Local nLin         		:= 80
	Local Cabec1       		:= ""
	Local Cabec2       		:= ""
	Local imprime      		:= .T.
	Local aOrd 				:= {"Produto"}
	Private lEnd        	:= .F.
	Private lAbortPrint  	:= .F.
	Private CbTxt        	:= ""         
	Private limite          := 80
	Private tamanho         := "G"
	Private nomeprog        := "R01TOKTAKE" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo           := 18
	Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cPerg       	:= "R01TOKTAKE"
	Private cbtxt      		:= Space(10)
	Private cbcont     		:= 00
	Private CONTFL     		:= 01
	Private m_pag      		:= 01
	Private wnrel      		:= "R01TOKTAKE" // Coloque aqui o nome do arquivo usado para impressao em disco
	
	Private cString 		:= "SB2"
	
	ValidPerg(cPerg)
	
	If !pergunte(cPerg,.T.)
		Return Nil
	EndIf
	
	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
Return Nil

//***********************************************************************************************************************************************************//

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  21/09/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Private c_Query	:= "" 			   		// Query
Private c_QryCnt:= "" 			   		// Count dos Registros para a Contagem do SetRegua
Private n_Ordem	:= aReturn[8] 	   		// Ordenacao na Query
Private c_Chr	:= Chr(13)+Chr(10)
Private a_Excel	:= {}

//-----------------------------------------  1o Query  -----------------------------------------------------------------------------------------------------//

c_Query	:= " SELECT	 B2_FILIAL AS FILIAL " + c_Chr
c_Query	+= "		,B2_LOCAL AS XLOCAL " + c_Chr
c_Query	+= "		,B2_COD AS CODIGO " + c_Chr
c_Query	+= "		,B1_DESC AS DESCRICAO " + c_Chr
c_Query	+= "		,B1_UM AS UNID_MED " + c_Chr
c_Query	+= "		,B2_QATU AS QTD_ATU " + c_Chr
c_Query	+= "		,B2_QEMP AS QTD_EMP " + c_Chr
c_Query	+= "		,B1_EMIN AS PONTO_PED " + c_Chr
c_Query	+= "		,B1_ESTSEG AS EST_SEG " + c_Chr
c_Query	+= "		,B2_QATU - ( B2_QEMP + B2_RESERVA ) AS SLD_DISP " + c_Chr

c_Query	+= " FROM " + RetSqlName("SB2") + " SB2 " + c_Chr

c_Query	+= "	INNER JOIN " + RetSqlName("SB1") + " SB1 " + c_Chr
c_Query	+= "	ON  B1_FILIAL		= '' " + c_Chr
c_Query	+= "	AND B1_COD			= B2_COD " + c_Chr
c_Query	+= "	AND SB1.D_E_L_E_T_	= '' " + c_Chr

c_Query	+= " WHERE SB2.D_E_L_E_T_ = '' " + c_Chr
c_Query	+= " AND B1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " + c_Chr
c_Query	+= " AND B1_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + c_Chr
c_Query	+= " AND B2_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + c_Chr
c_Query	+= " AND B2_LOCAL BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' " + c_Chr



//---------------------------------------  Fim - 1o Query  -------------------------------------------------------------------------------------------------//

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

c_QryCnt := "SELECT COUNT(*) AS QTDREG FROM (" + c_Query + ") AS RESULT "
MEMOWRITE("R01TOKTAKE.SQL",c_QryCnt)
c_QryCnt := ChangeQuery(c_QryCnt)
MEMOWRITE("R01TOKTAKE_Change.SQL",c_QryCnt)

TCQUERY c_QryCnt NEW ALIAS "TRB"

SetRegua(TRB->QTDREG)

If !Empty(QTDREG)

	If n_Ordem == 1
		c_Query += "ORDER BY B2_COD" + c_Chr
	EndIf

	Cabec1 := "FILIAL  LOCAL      C�D.PRODUTO     DESCRI��O PRODUTO                          UNIDADE       SLD.ATUAL           EMPENHO         SLD.DISP.     EST.SEGURAN�A      PONTO PEDIDO       SCs COLOC.        PCs COLOC.  DT.ENT.PCs"
	//		   XX      XX         XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   XX       999,999,999.99    999,999,999.99    999,999,999.99    999,999,999.99    999,999,999.99    999,999,999.99   999,999,999.99  DD/MM/AAAA
	//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	
	aAdd( a_Excel, {"FILIAL;LOCAL;C�D.PRODUTO;DESCRI��O PRODUTO;UNIDADE;SLD.ATUAL;EMPENHO;SLD.DISP.;EST.SEGURAN�A;PONTO PEDIDO;SCs COLOC.;PCs COLOC.;DT.ENT.PCs"} )
	
	a_Cols := {0, 8, 19, 35, 78, 87, 105, 123, 141, 159, 176, 194, 210}
	
	TRB->(DbCloseArea())
	
	TCQUERY c_Query NEW ALIAS "TRB"	 
	
//- 1o while -----------------------------------------------------------------------------------------------------------------------------------------------//
	
	While TRB->(!EOF()) // While para para o Cabecalho
		
	    If lAbortPrint
	       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	       Exit
	    Endif
	
		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin++
		Endif
	    
		IncRegua()
		
//----- Captura dados da tabela de solicita��es
		a_DadosSC1 := fDadosSC1()

//----- Captura dados da tabela de pedidos de compra
		a_DadosSC7 := fDadosSC7()
		
//----- Imprime dados
		@ nLin, a_Cols[01] PSAY TRB->FILIAL
		@ nLin, a_Cols[02] PSAY TRB->XLOCAL
		@ nLin, a_Cols[03] PSAY TRB->CODIGO
		@ nLin, a_Cols[04] PSAY TRB->DESCRICAO
		@ nLin, a_Cols[05] PSAY TRB->UNID_MED
		@ nLin, a_Cols[06] PSAY Transform(TRB->QTD_ATU	, "@E 999,999,999.99")
		@ nLin, a_Cols[07] PSAY Transform(TRB->QTD_EMP	, "@E 999,999,999.99")
		@ nLin, a_Cols[08] PSAY Transform(TRB->SLD_DISP	, "@E 999,999,999.99")
		@ nLin, a_Cols[09] PSAY Transform(TRB->PONTO_PED, "@E 999,999,999.99")
		@ nLin, a_Cols[10] PSAY Transform(TRB->EST_SEG	, "@E 999,999,999.99")
		@ nLin, a_Cols[11] PSAY Transform(a_DadosSC1[1]	, "@E 999,999,999.99")
		@ nLin, a_Cols[12] PSAY Transform(a_DadosSC7[1]	, "@E 999,999,999.99")
		@ nLin, a_Cols[13] PSAY Right(a_DadosSC7[2],2) +"/"+ SubStr(a_DadosSC7[2],5,2) +"/"+ Left(a_DadosSC7[2],4)
		
//----- Armazena dados para exporta��o para o Excel
        aAdd( a_Excel, {	"'"+TRB->FILIAL +";"+;
					        TRB->XLOCAL +";"+;
					        TRB->CODIGO +";"+;
					        TRB->DESCRICAO +";"+;
					        TRB->UNID_MED +";"+;
					        Transform(TRB->QTD_ATU	, "@E 999,999,999.99") +";"+;
					        Transform(TRB->QTD_EMP	, "@E 999,999,999.99") +";"+;
					        Transform(TRB->SLD_DISP	, "@E 999,999,999.99") +";"+;
					        Transform(TRB->PONTO_PED, "@E 999,999,999.99") +";"+;
					        Transform(TRB->EST_SEG	, "@E 999,999,999.99") +";"+;
					        Transform(a_DadosSC1[1]	, "@E 999,999,999.99") +";"+;
					        Transform(a_DadosSC7[1]	, "@E 999,999,999.99") +";"+;
       						Right(a_DadosSC7[2],2) +"/"+ SubStr(a_DadosSC7[2],5,2) +"/"+ Left(a_DadosSC7[2],4) } )
		
		TRB->(DbSkip())
        nLin++
	
    EndDo

//- Fim - 1o while -----------------------------------------------------------------------------------------------------------------------------------------//

//- Fechando �rea utilizada
	TRB->(DbCloseArea())
	
Endif

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

//Pergunta se gera ou n�o o Excel
If Len(a_Excel) > 0
	
	If MsgYesNo(" Deseja Gerar uma planilha do Relat�rio? ", " TOKTAKE - C O N F I R M A � � O")
		Processa({|| fCriaXLS() },"Gerando planilha excel. Por favor aguarde...")
	EndIf
	
EndIf

Return Nil

//**********************************************************************************************************************************************************//

/*����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������Ŀ��
���Programa  � fDadosSC7| Autor � Claudio Dias Junior (Focus Consultoria)  | Data � 01/01/10 ���
��������������������������������������������������������������������������������������������Ĵ��
���Descricao � Captura dados da tabela SC7                                                   ���
��������������������������������������������������������������������������������������������Ĵ��
���Parametros� Parametro                                                               		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Retorno   � Array => [1] = Quantidade de Pedidos de compras                               ���
���          �          [2] = Data da primeira compra                                        ���
��������������������������������������������������������������������������������������������Ĵ��
���Espec�fico� TOKTAKE                                                                 		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                                       		 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
���������������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������*/

Static Function fDadosSC7()

Local c_QtdSC7 	:= 0
Local c_DateSC7 := ""

c_Query	:= " SELECT 	 C7_PRODUTO " + c_Chr
c_Query	+= " 			,SUM(C7_QUANT) AS QTDSC7 " + c_Chr
c_Query	+= " 			,MIN(C7_EMISSAO) AS DT_EMIS " + c_Chr

c_Query	+= "FROM " + RetSqlName("SC7") + " SC7 " + c_Chr

c_Query	+= "WHERE SC7.D_E_L_E_T_ = '' " + c_Chr
c_Query	+= "AND C7_PRODUTO = '" + TRB->CODIGO + "' " + c_Chr
c_Query	+= "AND C7_LOCAL = '" + TRB->XLOCAL + "' " + c_Chr
c_Query	+= "AND C7_ENCER = '' " + c_Chr
c_Query	+= "GROUP BY C7_PRODUTO " + c_Chr

If Select("QRY") > 0
	QRY->(DbCloseArea())
Endif

c_QryCnt := "SELECT COUNT(*) AS QTDREG FROM (" + c_Query + ") AS RESULT "
MEMOWRITE("R01TOKTAKE_fDadosSC7.SQL",c_QryCnt)
c_QryCnt := ChangeQuery(c_QryCnt)

TCQUERY c_QryCnt NEW ALIAS "QRY"

SetRegua(QRY->QTDREG)

If !Empty(QTDREG)                 

	QRY->(DbCloseArea())
	
	TCQUERY c_Query NEW ALIAS "QRY"	 

	c_QtdSC7  := QRY->QTDSC7
	c_DateSC7 := QRY->DT_EMIS

EndIf

QRY->(DbCloseArea())

Return {c_QtdSC7, c_DateSC7}

//**********************************************************************************************************************************************************//

/*����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������Ŀ��
���Programa  � fDadosSC1| Autor � Claudio Dias Junior (Focus Consultoria)  | Data � 01/01/10 ���
��������������������������������������������������������������������������������������������Ĵ��
���Descricao � Captura dados da tabela SC1                                                   ���
��������������������������������������������������������������������������������������������Ĵ��
���Parametros� Parametro                                                               		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Retorno   � Array => [1] = Quantidade de solicita��es                                     ���
��������������������������������������������������������������������������������������������Ĵ��
���Espec�fico� TOKTAKE                                                                 		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                                       		 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
���������������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������*/

Static Function fDadosSC1()

Local c_QtdSC1 	:= 0

c_Query	:= " SELECT 	 C1_PRODUTO " + c_Chr
c_Query	+= " 			,SUM( C1_QUANT - C1_QUJE ) AS QTDSC1 " + c_Chr

c_Query	+= "FROM " + RetSqlName("SC1") + " SC1 " + c_Chr

c_Query	+= "WHERE SC1.D_E_L_E_T_ = '' " + c_Chr
c_Query	+= "AND C1_PRODUTO = '" + TRB->CODIGO + "' " + c_Chr
c_Query	+= "AND C1_LOCAL = '" + TRB->XLOCAL + "' " + c_Chr
c_Query	+= "GROUP BY C1_PRODUTO " + c_Chr

If Select("QRY") > 0
	QRY->(DbCloseArea())
Endif

c_QryCnt := "SELECT COUNT(*) AS QTDREG FROM (" + c_Query + ") AS RESULT "
MEMOWRITE("R01TOKTAKE_fDadosSC1.SQL",c_QryCnt)
c_QryCnt := ChangeQuery(c_QryCnt)

TCQUERY c_QryCnt NEW ALIAS "QRY"

SetRegua(QRY->QTDREG)

If !Empty(QTDREG)

	QRY->(DbCloseArea())
	
	TCQUERY c_Query NEW ALIAS "QRY"	 

	c_QtdSC1  := QRY->QTDSC1

EndIf

QRY->(DbCloseArea())

Return {c_QtdSC1}

//**********************************************************************************************************************************************************//

/*����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������Ŀ��
���Programa  � fCriaXLS | Autor � Claudio Dias Junior (Focus Consultoria)  | Data � 03/01/10 ���
��������������������������������������������������������������������������������������������Ĵ��
���Descricao � Fun��o respons�vel em criar o XLS                                             ���
��������������������������������������������������������������������������������������������Ĵ��
���Parametros� Parametro                                                               		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Retorno   � Parametro                                                                     ���
��������������������������������������������������������������������������������������������Ĵ��
���Espec�fico� TOKTAKE                                                              		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                                       		 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
���              �  /  /  �                                               					 ���
���������������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������*/

Static Function fCriaXLS()

Local o_Excel
Local c_Arq
Local n_Arq
Local c_Path

c_Arq  := CriaTrab( Nil, .F. )
c_Path := cGetFile("\", "Selecione o Local para salvar a Arquivo.",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY/*128+GETF_NETWORKDRIVE*/)
n_Arq  := FCreate( c_Path + ( DTOS(dDatabase) + "R01TOKTAKE" ) + ".CSV" )

If ( n_Arq == -1 )
	MsgAlert( "Nao conseguiu criar o arquivo!" , " A T E N � � O !" )
	Return()
EndIf

For i := 1 To Len(a_Excel)
	FWrite( n_Arq, a_Excel[i][1] + Chr(13) + Chr(10))
Next i

FClose(n_Arq)

Return nIL

//**********************************************************************************************************************************************************//

/*����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������Ŀ��
���Programa  � ValidPerg| Autor � Claudio Dias Junior (Focus Consultoria)  | Data � 01/01/10 ���
��������������������������������������������������������������������������������������������Ĵ��
���Descricao � Cadastra perguntas no SX1                                                     ���
��������������������������������������������������������������������������������������������Ĵ��
���Parametros� c_Perg => Grupo de perguntas que ir� ser criado                         		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Retorno   � Parametro                                                                     ���
��������������������������������������������������������������������������������������������Ĵ��
���Espec�fico� TOKTAKE                                                                 		 ���
��������������������������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                                       		 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
��������������������������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               					 ���
���������������������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������*/

Static Function ValidPerg(c_Perg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
c_Perg := c_Perg + Replicate(" ", 10 - Len(c_Perg))               
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{c_Perg,"01","Produto de: ?   ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{c_Perg,"02","Produto ate: ?  ","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"})
aAdd(aRegs,{c_Perg,"03","Categoria de: ? ","","","mv_ch3","C",04,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{c_Perg,"04","Categoria ate: ?","","","mv_ch4","C",04,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SBM"})
aAdd(aRegs,{c_Perg,"05","Filial de: ? ","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{c_Perg,"06","Filial ate: ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{c_Perg,"07","Almox de: ? ","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{c_Perg,"08","Almox ate: ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(c_Perg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)

Return Nil

//***********************************************************************************************************************************************************//