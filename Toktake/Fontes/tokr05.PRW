#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ TOKR05   ³ Rotina padrão para impressão da ficha de inventario          º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ Jan/2010 ³ Wanderley                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpC1 = Número da Nota Fiscal Inicial                                   º±±
±±º             ³ ExpC2 = Número da Nota Fiscal Final                                     º±±
±±º             ³ ExpC3 = Série da Nota Fiscal                                            º±±
±±º             ³ ExpC4 = Tipo da Nota Fiscal                                             º±±
±±º             ³ ExpL1 = Imprime Boleto                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ Deve ser definido os parâmetros abaixo antes da implantação do programa º±±
±±º             ³ lChkImp - Verificar se há notas anteriores não impressas                º±±
±±º             ³           Case seja .T. é necessário criar o campo F1_FIMP (C-1,0)      º±±
±±º             ³ nTamMen - Tamanho da linha de mensagme do campo dados adicionais        º±±
±±º             ³ nTamPro - Tamanho da linha de descrição do produto                      º±±
±±º             ³ nTamDet - Quantidade de linhas do detalhe de produtos                   º±±
±±º             ³ nTamSer - Quantidade de linhas do detalhe de serviços                   º±±
±±º             ³ nTamObs - Quantidade de linhas do campo de detalhes adcionais           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TOKR05

Local aRegs		:= {}
Local nLastKey	:= 0
Local cDesc1	:= "Este programa tem como objetivo efetuar a impressão da"
Local cDesc2	:= "Nota Fiscal de Entrada/Saída, conforme os parâmetros"
Local cDesc3	:= "definidos pelo usuário."
Local cString	:= "SF2"
Local cPerg		:= "TOKR151   "

Private lEnd		:= .F.
Private aReturn		:= {	"Especial",;				// [1]= Tipo de Formulário
							1,;							// [2]= Número de Vias
							"Faturamento",;				// [3]= Destinatário
							2,;							// [4]= Formato 1=Comprimido 2=Normal
							2,;							// [5]= Mídia 1=Disco 2=Impressora
							1,;							// [6]= Porta LPT1, LPT2, Etc
							"",;						// [7]= Expressão do Filtro
							"" ;						// [8]= ordem a ser selecionada
							}
Private cTamanho	:= "M"
Private cTitulo		:= "Impressão da Ficha Inventario"
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
				"mv_ch1",;									// Variável
				"C",;										// Tipo do campo
				15,;										// Tamanho do campo
				0,;											// Decimal do campo
				0,;											// Pré-selecionado quando for choice
				"G",;										// Tipo de seleção (Get ou Choice)
				"",;										// Validação do campo
				"MV_PAR01",;								// 1a. Variável disponível no programa
				"",;		  								// 1a. Definição da variável - quando choice
				"",;										// 1a. Definição variável em espanhol - quando choice
				"",;										// 1a. Definição variável em ingles - quando choice
				"",;										// 1o. Conteúdo variável
				"",;										// 2a. Variável disponível no programa
				"",;										// 2a. Definição da variável
				"",;										// 2a. Definição variável em espanhol
				"",;										// 2a. Definição variável em ingles
				"",;										// 2o. Conteúdo variável
				"",;										// 3a. Variável disponível no programa
				"",;										// 3a. Definição da variável
				"",;										// 3a. Definição variável em espanhol
				"",;										// 3a. Definição variável em ingles
				"",;										// 3o. Conteúdo variável
				"",;										// 4a. Variável disponível no programa
				"",;										// 4a. Definição da variável
				"",;										// 4a. Definição variável em espanhol
				"",;										// 4a. Definição variável em ingles
				"",;										// 4o. Conteúdo variável
				"",;										// 5a. Variável disponível no programa
				"",;										// 5a. Definição da variável
				"",;										// 5a. Definição variável em espanhol
				"",;										// 5a. Definição variável em ingles
				"",;										// 5o. Conteúdo variável
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
					Wnrel,;					// Nome Padrão do Relatório
					cPerg,;					// Alias do Grupo de Perguntas
					@cTitulo,;				// Título do Relatório
					cDesc1,;				// Descrição 1
					cDesc2,;				// Descrição 2
					cDesc3,;				// Descrição 3
					.F.,;					// Habilita Dicionário de Dados
					,;						// Array com as ordens de indexação do arquivo principal
					.F.,;					// Habilita Compressão do Relatório
					cTamanho,;				// Classificação do Tamanho (P[80]/M[132]/G[220])
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes das variaveis da funcao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFImp		:= {}								// Array com os dados das notas fiscais não impressas
Local aPesPed	:= {}								// Array que controla o peso com base no pedido de venda
Local aClasFis	:= {}								// Array com as letras do NBM de cada produto
Local lContinua	:= .T.								// Controlador de impressão
Local lTransp	:= .T.								// Flag para identificar se há transportadora associada a nota
Local lSomLiq	:= .T.								// Flag de Controle de somatória do peso liquido
Local lSomBru	:= .T.								// Flag de Controle de somatória do peso bruto
Local nElem		:= 0								// Elemento do array pesquisado
Local nQdeLnh	:= 0								// Quantidade de linhas do campo de descrição do produto para o campo memo
Local nPesLiq	:= 0								// Peso liquido calculado com base no produto
Local nPesBru	:= 0								// Peso bruto calculado com base no produto
Local dEmiDev	:= CToD("  /  /  ")					// Data de emissão da nota de devolução
Local cMemo		:= ""								// Conteúdo do campo memo
Local cOpMemo	:= ""								// Opção de utilização do campo memo para descrição do produto
Local cCodNBM	:= ""								// Código da Classificação Fiscal NBM para o produto
Local cMensag	:= ""								// String com a mensagem montada
Local cQry		:= ""								// String com a query a ser processada
Local nElem		:= 0								// Posição do elemento encontrado em um ascan
Local cLblTip	:= ""								// Label no nome do imposto
Local nAlqImp	:= 0								// Aliquota do imposto retido
Local aMeses	:= {}								// Array com o nome dos meses
Local cMesAno	:= ""								// Mes e ano de referência
//Local lDetMsg	:=	.T.								// Flag para Impressao da Msg do Pedido de Vendas uma única vez por Nota Fiscal
Local lIPIObs	:=  .F.								// Flag para identificar se algum item tem IPI em observações
Local lImp := .t.

Private aCab		:= {}							// Array com os dados do cabeçalho da Nota Fiscal
Private aItens		:= {}							// Array com os dados dos itens da Nota Fiscal
Private aServico	:= {}							// Array com os dados dos serviços prestados
Private aRodape		:= {}							// Array com os dados do rodapé (totais)
Private aDuplic		:= {}							// Array com os dados das duplicatas
Private aNatOpe		:= {}							// Array com as naturezas de operação da nota fiscal
Private aImpostos	:= {}							// Array com os dados de impostos abatidos do total da nota
Private aTransp		:= {}							// Array com os dados de transporte
Private aCodMen		:= {}							// Array com os códigos das mensagens padrões
Private aDadAdc		:= {}							// Array com os dados de mensagens
Private aNFDev		:= {}							// Array com as Notas de Devolução
Private aIPIDEV		:= {}							// Array com os valores do IPI de devolução para ser impresso no corpo da nota
Private aNBM		:= {}							// Array com os códigos NBM dos produtos
Private nForAtu		:= 0							// Loop do Formulário de nota
Private lC5Mens		:= .t.
Private cC5Mens		:= " "
Private nTotSer		:= 0							// Valor Total dos serviços
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
