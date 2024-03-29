#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TOKR05   � Rotina padr�o para impress�o da ficha de inventario          ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � Jan/2010 � Wanderley                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = N�mero da Nota Fiscal Inicial                                   ���
���             � ExpC2 = N�mero da Nota Fiscal Final                                     ���
���             � ExpC3 = S�rie da Nota Fiscal                                            ���
���             � ExpC4 = Tipo da Nota Fiscal                                             ���
���             � ExpL1 = Imprime Boleto                                                  ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Deve ser definido os par�metros abaixo antes da implanta��o do programa ���
���             � lChkImp - Verificar se h� notas anteriores n�o impressas                ���
���             �           Case seja .T. � necess�rio criar o campo F1_FIMP (C-1,0)      ���
���             � nTamMen - Tamanho da linha de mensagme do campo dados adicionais        ���
���             � nTamPro - Tamanho da linha de descri��o do produto                      ���
���             � nTamDet - Quantidade de linhas do detalhe de produtos                   ���
���             � nTamSer - Quantidade de linhas do detalhe de servi�os                   ���
���             � nTamObs - Quantidade de linhas do campo de detalhes adcionais           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function TOKR05

Local aRegs		:= {}
Local nLastKey	:= 0
Local cDesc1	:= "Este programa tem como objetivo efetuar a impress�o da"
Local cDesc2	:= "Nota Fiscal de Entrada/Sa�da, conforme os par�metros"
Local cDesc3	:= "definidos pelo usu�rio."
Local cString	:= "SF2"
Local cPerg		:= "TOKR151   "

Private lEnd		:= .F.
Private aReturn		:= {	"Especial",;				// [1]= Tipo de Formul�rio
							1,;							// [2]= N�mero de Vias
							"Faturamento",;				// [3]= Destinat�rio
							2,;							// [4]= Formato 1=Comprimido 2=Normal
							2,;							// [5]= M�dia 1=Disco 2=Impressora
							1,;							// [6]= Porta LPT1, LPT2, Etc
							"",;						// [7]= Express�o do Filtro
							"" ;						// [8]= ordem a ser selecionada
							}
Private cTamanho	:= "M"
Private cTitulo		:= "Impress�o da Ficha Inventario"
Private wnrel		:= "TOKR05"
Private Li			:= 0

Private lChkImp		:= .f.		// .T.
Private nTamMen		:= 100
Private nTamPro		:= 41 //55	em 19/05/06
Private nTamDet		:= 15
Private nTamSer		:= 4
Private nTamObs		:= 6
Private lDestIPI	:= .F.

aAdd(aRegs,{	cPerg,;										// Grupo de perguntas
				"01",;										// Sequencia
				"Produto de",;						// Nome da pergunta
				"",;										// Nome da pergunta em espanhol
				"",;										// Nome da pergunta em ingles
				"mv_ch1",;									// Vari�vel
				"C",;										// Tipo do campo
				15,;										// Tamanho do campo
				0,;											// Decimal do campo
				0,;											// Pr�-selecionado quando for choice
				"G",;										// Tipo de sele��o (Get ou Choice)
				"",;										// Valida��o do campo
				"MV_PAR01",;								// 1a. Vari�vel dispon�vel no programa
				"",;		  								// 1a. Defini��o da vari�vel - quando choice
				"",;										// 1a. Defini��o vari�vel em espanhol - quando choice
				"",;										// 1a. Defini��o vari�vel em ingles - quando choice
				"",;										// 1o. Conte�do vari�vel
				"",;										// 2a. Vari�vel dispon�vel no programa
				"",;										// 2a. Defini��o da vari�vel
				"",;										// 2a. Defini��o vari�vel em espanhol
				"",;										// 2a. Defini��o vari�vel em ingles
				"",;										// 2o. Conte�do vari�vel
				"",;										// 3a. Vari�vel dispon�vel no programa
				"",;										// 3a. Defini��o da vari�vel
				"",;										// 3a. Defini��o vari�vel em espanhol
				"",;										// 3a. Defini��o vari�vel em ingles
				"",;										// 3o. Conte�do vari�vel
				"",;										// 4a. Vari�vel dispon�vel no programa
				"",;										// 4a. Defini��o da vari�vel
				"",;										// 4a. Defini��o vari�vel em espanhol
				"",;										// 4a. Defini��o vari�vel em ingles
				"",;										// 4o. Conte�do vari�vel
				"",;										// 5a. Vari�vel dispon�vel no programa
				"",;										// 5a. Defini��o da vari�vel
				"",;										// 5a. Defini��o vari�vel em espanhol
				"",;										// 5a. Defini��o vari�vel em ingles
				"",;										// 5o. Conte�do vari�vel
				"SB1",;										// F3 para o campo
				"",;										// Identificador do PYME
				"",;										// Grupo do SXG
				"",;										// Help do campo
				"" })									// Picture do campo
aAdd(aRegs,{cPerg,"02","Produto Ate"      ,		"","","mv_ch2","C",15,0,0,"G","","MV_PAR02","",		"","","999999","","",		"",		"",		"","","","","","","","","","","","","","","","",		"SB1",		"","","","" })
aAdd(aRegs,{cPerg,"03","Armazem De"       ,		"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","",		"","",		"","","",		"",		"",		"","","","","","","","","","","","","","","","",		"ZZ1",		"","","",""})
aAdd(aRegs,{cPerg,"04","Armazem Ate"      ,		"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","",		"","",		"","","",		"",		"",		"","","","","","","","","","","","","","","","",		"ZZ1",		"","","",""})
aAdd(aRegs,{cPerg,"05","Saldo"            ,		"","","mv_ch5","N",01,0,0,"C","","MV_PAR05","Positivo",	"","",		"","","Zerado",	"",		"",		"","","Ambas","","","","","","","","","","","","","",		"",		"","","",""})
aAdd(aRegs,{cPerg,"06","Bloqueio"         ,		"","","mv_ch6","N",01,0,0,"C","","MV_PAR06","Sim",	"","",		"","","Nao",	"",		"",		"","","Ambas","","","","","","","","","","","","","",		"",		"","","",""})

CriaSx1(aRegs)

If !Pergunte(cPerg,.T.)
	Return(Nil)
EndIf

Wnrel := SetPrint(	cString,;				// Alias do Arquivo Principal
					Wnrel,;					// Nome Padr�o do Relat�rio
					cPerg,;					// Alias do Grupo de Perguntas
					@cTitulo,;				// T�tulo do Relat�rio
					cDesc1,;				// Descri��o 1
					cDesc2,;				// Descri��o 2
					cDesc3,;				// Descri��o 3
					.F.,;					// Habilita Dicion�rio de Dados
					,;						// Array com as ordens de indexa��o do arquivo principal
					.F.,;					// Habilita Compress�o do Relat�rio
					cTamanho,;				// Classifica��o do Tamanho (P[80]/M[132]/G[220])
					,;						// 
					)

If nLastKey == 27
	Set Filter to
	Return(Nil)
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return(Nil)
Endif

RptStatus( { |lEnd| TOKR05A() } )

Return(Nil)


Static Function TOKR05A()

//������������������������������������Ŀ
//� Definicoes das variaveis da funcao �
//��������������������������������������
Local aFImp		:= {}								// Array com os dados das notas fiscais n�o impressas
Local aPesPed	:= {}								// Array que controla o peso com base no pedido de venda
Local aClasFis	:= {}								// Array com as letras do NBM de cada produto
Local lContinua	:= .T.								// Controlador de impress�o
Local lTransp	:= .T.								// Flag para identificar se h� transportadora associada a nota
Local lSomLiq	:= .T.								// Flag de Controle de somat�ria do peso liquido
Local lSomBru	:= .T.								// Flag de Controle de somat�ria do peso bruto
Local nElem		:= 0								// Elemento do array pesquisado
Local nQdeLnh	:= 0								// Quantidade de linhas do campo de descri��o do produto para o campo memo
Local nPesLiq	:= 0								// Peso liquido calculado com base no produto
Local nPesBru	:= 0								// Peso bruto calculado com base no produto
Local dEmiDev	:= CToD("  /  /  ")					// Data de emiss�o da nota de devolu��o
Local cMemo		:= ""								// Conte�do do campo memo
Local cOpMemo	:= ""								// Op��o de utiliza��o do campo memo para descri��o do produto
Local cCodNBM	:= ""								// C�digo da Classifica��o Fiscal NBM para o produto
Local cMensag	:= ""								// String com a mensagem montada
Local cQry		:= ""								// String com a query a ser processada
Local nElem		:= 0								// Posi��o do elemento encontrado em um ascan
Local cLblTip	:= ""								// Label no nome do imposto
Local nAlqImp	:= 0								// Aliquota do imposto retido
Local aMeses	:= {}								// Array com o nome dos meses
Local cMesAno	:= ""								// Mes e ano de refer�ncia
//Local lDetMsg	:=	.T.								// Flag para Impressao da Msg do Pedido de Vendas uma �nica vez por Nota Fiscal
Local lIPIObs	:=  .F.								// Flag para identificar se algum item tem IPI em observa��es
Local lImp := .t.

Private aCab		:= {}							// Array com os dados do cabe�alho da Nota Fiscal
Private aItens		:= {}							// Array com os dados dos itens da Nota Fiscal
Private aServico	:= {}							// Array com os dados dos servi�os prestados
Private aRodape		:= {}							// Array com os dados do rodap� (totais)
Private aDuplic		:= {}							// Array com os dados das duplicatas
Private aNatOpe		:= {}							// Array com as naturezas de opera��o da nota fiscal
Private aImpostos	:= {}							// Array com os dados de impostos abatidos do total da nota
Private aTransp		:= {}							// Array com os dados de transporte
Private aCodMen		:= {}							// Array com os c�digos das mensagens padr�es
Private aDadAdc		:= {}							// Array com os dados de mensagens
Private aNFDev		:= {}							// Array com as Notas de Devolu��o
Private aIPIDEV		:= {}							// Array com os valores do IPI de devolu��o para ser impresso no corpo da nota
Private aNBM		:= {}							// Array com os c�digos NBM dos produtos
Private nForAtu		:= 0							// Loop do Formul�rio de nota
Private lC5Mens		:= .t.
Private cC5Mens		:= " "
Private nTotSer		:= 0							// Valor Total dos servi�os
Private nVlZfr		:= 0							// Valor Desconto Zona Franca
Private cTpPag		:= "" 							// Tipo de Pagamento

                            
cQry	:= "SELECT B2_FILIAL,B2_COD,B2_LOCAL,B2_QATU,B1_DESC,B1_COD,B1_UM "
cQry	+= "FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1 "
cQry	+= "WHERE SB2.D_E_L_E_T_<> '*'  AND SB1.D_E_L_E_T_<> '*'  "
cQry	+= "AND B2_LOCAL >= '"+MV_PAR03+"' AND B2_LOCAL <= '"+MV_PAR04+"' "
if MV_PAR05 = 1
   cQry	+= "AND B2_QATU > 0 "
else
	if MV_PAR05 = 2
       cQry	+= "AND B2_QATU = 0 "
    else
       cQry	+= "AND B2_QATU >= 0 "
	endif
endif

if MV_PAR06 = 1
   cQry	+= "AND B1_MSBLQL = '1' "
else
	if MV_PAR06 = 2
       cQry	+= "AND B1_MSBLQL = '2' "
	endif
endif
                                   
cQry	+= "AND B2_FILIAL = '"+xFilial("SB2")+"'"
cQry	+= "AND B1_FILIAL = '"+xFilial("SB1")+"'"
cQry	+= "AND B1_COD = B2_COD "
cQry	+= "AND B2_COD >= '"+MV_PAR01+"' AND B2_COD <= '"+MV_PAR02+"' "
cQry	+= "ORDER BY B1_COD "

MemoWrite('C:\pasta\TOKR05',cQry)


If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS "TMP"
dbSelectArea("TMP")
dbGoTop()

imprime()

dbSelectArea("TMP")
dbCloseArea()

@ 000, 000 PSAY Chr(18)					  // Descompressao de caracteres

Set Device To Screen    

SetPgEject(.f.)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()

Return


*******************************************************************************************************
Static Function Imprime()
*******************************************************************************************************

Local nLoop		:= 0
Local cNatOpe	:= ""
Local cCFOOpe	:= ""
Local cLinha1	:= ""
Local cLinha2	:= ""
Local cLinha3	:= ""
Local nDetObs	:= 0

dbSelectArea("TMP")
dbGoTop()
li := 2
@ li,000 PSAY "."+Chr(18)+Chr(15)
SetPrc(0,0)                              // (Zera o Formulario)
while !eof()
     
	@ li,045 PSAY TMP->B2_COD
	Li := Li+1
	@ li,045 PSAY TMP->B1_DESC
	Li := Li+2
	@ li,045 PSAY "UNIDADE MEDIDA: "+TMP->B1_UM
	Li := Li+1
	@ li,045 PSAY "LOCAL: "+TMP->B2_LOCAL+" - EMP./FILIAL: "+alltrim(SM0->M0_NOME)+"/"+alltrim(SM0->M0_FILIAL) 
	Li := LI+21
    dbskip()
    li=li+1
enddo

Return(.T.)


*******************************************************************************************************
Static Function CriaSx1(aRegs)
*******************************************************************************************************

Local aAreaAnt	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nLoop2	:= 0
Local nLoop1	:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nLoop1 := 1 To Len(aRegs)
	If !MsSeek(aRegs[nLoop1,1]+aRegs[nLoop1,2])
		RecLock("SX1",.T.)
		For nLoop2 := 1 To FCount()
			If nLoop2 <= Len(aRegs[nLoop1])
				FieldPut(nLoop2,aRegs[nLoop1,nLoop2])
			EndIf
		Next nLoop2
		MsUnlock()
	EndIf
Next nLoop1

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return(Nil)
