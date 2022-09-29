#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RFATR97  � Rotina padr�o para impress�o da nota fiscal de entrada/sa�da ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � Dez/2009 � Cadubitski                                                   ���
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
User Function RFATR97(cNotIni, cNotFim, cSerie, nNotTip, lBoleto)

Local aRegs		:= {}
Local nLastKey	:= 0
Local cDesc1	:= "Este programa tem como objetivo efetuar a impress�o da"
Local cDesc2	:= "Nota Fiscal de Sa�da Servi�os , conforme os par�metros"
Local cDesc3	:= "definidos pelo usu�rio."
Local cString	:= "SF2"
Local cPerg		:= "FATR97    "

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
Private cTitulo		:= "Impress�o da Nota Fiscal Entrada/Sa�da"
Private wnrel		:= "RFATR97"
Private Li			:= 0

//������������������������������������������������������������Ŀ
//� Define se deve checar se h� notas anteriores sem impress�o �
//��������������������������������������������������������������
//Private lChkImp		:= .f.		// .T.
//������������������������������������������������������������Ŀ
//� Define o tamanho da linha do campo de dados adicionais     �
//��������������������������������������������������������������
Private nTamMen		:= 115
//������������������������������������������������������������Ŀ
//� Define o tamanho da linha do campo de descri��o do produto �
//��������������������������������������������������������������
Private nTamPro		:= 41 //55	em 19/05/06
//�������������������������������������������������������������Ŀ
//� Define a quantidade de linhas para o detalhe da nota fiscal �
//���������������������������������������������������������������
Private nTamDet		:= 25
//�������������������������������������������������������������Ŀ
//� Define a quantidade de linhas para o detalhe da nota fiscal �
//���������������������������������������������������������������
Private nTamSer		:= 4
//�������������������������������������������������������������Ŀ
//� Define a quantidade de linhas para os dados adicionais (obs)�
//���������������������������������������������������������������
Private nTamObs		:= 6
//�����������������������������������������������������������������������������Ŀ
//� Define a ser� impresso o total de IPI qdo IPI para cr�dito (Destaca IPI = N)�
//�������������������������������������������������������������������������������
Private lDestIPI	:= .F.

// Monta array com as perguntas
aAdd(aRegs,{	cPerg,;										// Grupo de perguntas
				"01",;										// Sequencia
				"Nota Fiscal Inicial",;						// Nome da pergunta
				"",;										// Nome da pergunta em espanhol
				"",;										// Nome da pergunta em ingles
				"mv_ch1",;									// Vari�vel
				"C",;										// Tipo do campo
				09,;										// Tamanho do campo
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
				"",;										// F3 para o campo
				"",;										// Identificador do PYME
				"",;										// Grupo do SXG
				"",;										// Help do campo
				"" })									// Picture do campo
aAdd(aRegs,{cPerg,"02","Nota Fiscal Final",		"","","mv_ch2","C",09,0,0,"G","","MV_PAR03","",		"","","999999","","",		"",		"",		"","","","","","","","","","","","","","","","",		"",		"","","","" })
aAdd(aRegs,{cPerg,"03","Serie Nota Fiscal",		"","","mv_ch3","C",03,0,0,"G","","MV_PAR03","",		"","",		"","","",		"",		"",		"","","","","","","","","","","","","","","","",		"",		"","","",""})

CriaSx1(aRegs)

pergunte("FATR97    ",.f.)                     

//����������������������������������������Ŀ
//� Verifica se � uma impress�o autom�tica �
//������������������������������������������
//��������������������������������������������������������������������������������������Ŀ
//� Chama a fun��o de interface com o usu�rio para defini��o dos par�metros do relat�rio �
//����������������������������������������������������������������������������������������
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

//������������������������Ŀ
//� Aborta o processamento �
//��������������������������
If nLastKey == 27
	Set Filter to
	Return(Nil)
Endif

//��������������������������������������������Ŀ
//� Seta os par�metros alterados pela SetPrint �
//����������������������������������������������
SetDefault(aReturn,cString)

//������������������������Ŀ
//� Aborta o processamento �
//��������������������������	
If nLastKey == 27
	Set Filter to
	Return(Nil)
Endif

RptStatus( { |lEnd| RFATR97A() } )


Return(Nil)

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RFATR97  � Rotina padr�o para impress�o da nota fiscal de entrada/sa�da ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function RFATR97A()

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
Local lIPIObs	:=  .F.								// Flag para identificar se algum item tem IPI em observa��es
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

/*
If lChkImp
		cQry	:= " SELECT SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_EMISSAO,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_VALBRUT,"
		cQry	+= " CASE WHEN SF2.F2_TIPO NOT IN('B','D')"
		cQry	+= " 	THEN (SELECT SA1.A1_NOME FROM "+RetSqlName("SA1")+" SA1"
		cQry	+= "		WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
		cQry	+= "		AND SA1.A1_COD = SF2.F2_CLIENTE"
		cQry	+= "		AND SA1.A1_LOJA = SF2.F2_LOJA"
		cQry	+= "		AND SA1.D_E_L_E_T_ <> '*')"
		cQry	+= "	ELSE (SELECT SA2.A2_NOME FROM "+RetSqlName("SA2")+" SA2"
		cQry	+= "		WHERE SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
		cQry	+= "		AND SA2.A2_COD = SF2.F2_CLIENTE"
		cQry	+= "		AND SA2.A2_LOJA = SF2.F2_LOJA"
		cQry	+= "		AND SA2.D_E_L_E_T_ <> '*')"
		cQry	+= "	END AS A1_NOME"
		cQry	+= " FROM "+RetSqlName("SF2")+" SF2"
		cQry	+= " WHERE SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		cQry	+= " AND SF2.F2_DOC < '"+mv_par01+"'"
		cQry	+= " AND SF2.F2_SERIE = '"+mv_par03+"'"
		cQry	+= " AND SF2.F2_FIMP = ' '" 
		cQry	+= " AND SF2.D_E_L_E_T_ <> '*'"

		If Select("TMPDUPL") > 0
			dbSelectArea("TMPDUPL")
			dbCloseArea()
		EndIf
		TCQUERY cQry NEW ALIAS "TMPDUPL"
		dbSelectArea("TMPDUPL")
		dbGoTop()
		While !Eof()
			aAdd( aFImp, {	TMPDUPL->F2_DOC,;
							TMPDUPL->F2_SERIE,;
							SToD(TMPDUPL->F2_EMISSAO),;
							TMPDUPL->F2_VALBRUT,;
							TMPDUPL->F2_CLIENTE,;
							TMPDUPL->F2_LOJA,;
							TMPDUPL->A1_NOME ;
							})
			dbSkip()
		EndDo
		dbSelectArea("TMPDUPL")
		dbCloseArea()
	If Len(aFImp) > 0
		VisaFImp(aFImp)
		Return(Nil)
	EndIf
EndIf
*/

//�������������������������������������Ŀ
//� Posiciona os arquivos para os loops �
//���������������������������������������
dbSelectArea("SF2")					// Cabecalho da Nota Fiscal Saida
dbSetorder(1)						// FILIAL+DOC+SERIE+CLIENTE+LOJA+FORMUL
DbSeek(xFilial("SF2")+mv_par01+mv_par03,.T.)
	
dbSelectArea("SD2")					// Itens de Venda da Nota Fiscal
dbSetorder(3)						// FILIAL+DOC+SERIE+CLIENTE+LOJA+COD+ITEM
DbSeek(xFilial("SD2")+mv_par01+mv_par03,.T.)

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SA1")
dbSetOrder(1)

dbSelectArea("SA2")
dbSetOrder(1)

dbSelectArea("SA4")
dbSetOrder(1)

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SC6")
dbSetOrder(1)

dbSelectArea("SE1")
dbSetOrder(1)

dbSelectArea("SE4")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

//�������������������������������Ŀ
//� Inicializa r�gua de impress�o �
//���������������������������������
SetRegua(Val(mv_par02)-Val(mv_par01))

//��������������������������������������Ŀ
//� Impressao dos caracteres de controle �
//����������������������������������������
SetPrc(0,0)											// Inicializa impressora (Junior em 26/04/06)
Li := 0												// reinicio
@ Li,000 PSAY Chr(27)+"@"
@ li,000 PSay Chr(27)+Chr(67)+chr(104)				// Define tamanho do papel em 100 linhas/pagina... (Junior)
@ Li,000 PSay Chr(27)+Chr(48)       		 		// Compressao de Impressao - Linha		(Junior em 26/04/06)
@ Li,000 PSAY Chr(15)								// Define caracteres comprimidos

	dbSelectArea("SF2")
	                                    
	
	While !Eof() .And. SF2->F2_FILIAL == xFilial("SF2") .And. SF2->F2_DOC <= mv_par02 .And. lContinua 
		//��������������������������������Ŀ
		//� Movimenta a regua de impress�o �
		//����������������������������������
		IncRegua("Nota Fiscal "+SF2->F2_DOC+"/"+SF2->F2_SERIE)		

		//������������������������������������������Ŀ                   admin	t14520
		
		//� Desconsidera notas com s�rieS diferentes �
		//��������������������������������������������
		If SF2->F2_SERIE <> mv_par03 .or. SF2->F2_TIPO$'BD'
			dbSkip()
			Loop
		Endif
		
		//���������������������������������������������Ŀ
		//� Verifica se houve cancelamento pelo usu�rio �
		//�����������������������������������������������
		IF lEnd
			@ Li,001 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif

		//����������������������������������Ŀ
		//� Zera os array's para a nova nota �
		//������������������������������������
		aCab		:= {}								// Array com os dados do cabe�alho da Nota Fiscal
		aItens		:= {}								// Array com os dados dos itens da Nota Fiscal
		aServico	:= {}								// Array com os dados dos servi�os prestados
		aRodape		:= {}								// Array com os dados do rodap� (totais)
		aDuplic		:= {}								// Array com os dados das duplicatas
		aNatOpe		:= {}								// Array com as naturezas de opera��o da nota fiscal
		aImpostos	:= {}								// Array com os dados de impostos abatidos do total da nota
		aTransp		:= {}								// Array com os dados de transporte
		aCodMen		:= {}								// Array com os c�digos das mensagens padr�es
		aDadAdc		:= {}								// Array com os dados de mensagens
		aNFDev		:= {}								// Array com as Notas de Devolu��o		
		aIPIDEV		:= {}								// Array com os valores do IPI de devolu��o para ser impresso no corpo da nota
		aNatOpe		:= {}								// Array com as naturezas de opera��o da nota fiscal
		aPesPed		:= {}								// Array que controla o peso com base no pedido de venda
		aNBM		:= {}								// Array com os c�digos NBM dos produtos
		
		lTransp		:= .T.								// Flag  para identificar se h� transportadora associada a nota
		dEmiDev		:= CToD("  /  /  ")					// Data de emiss�o da nota de devolu��o
		nPesLiq		:= 0								// Peso liquido calculado com base no produto
		nPesBru		:= 0								// Peso bruto calculado com base no produto
		nTotSer		:= 0								// Valor total dos servi�os
		lIPIObs		:= .F.								// IPI no campo de observa��es
        
		dbSelectArea("SA1")
		If !MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			Aviso(	cTitulo,;
					"Cliente n�o localizado no arquivo! Contate o Administrador.",;
					{"&Continua"},,;
					"Cliente: "+SF2->F2_CLIENTE+"/"+SF2->F2_LOJA)
			Return(Nil)
		EndIf

		dbSelectArea("SF2")
		//���������������������������������������������������Ŀ
		//� Alimenta array com os campos do cabecalho da nota �
		//�����������������������������������������������������
		aAdd( aCab, SF2->F2_DOC)  												// [1]Numero
		aAdd( aCab, SF2->F2_SERIE)												// [2]Serie
		aAdd( aCab, SF2->F2_TIPO)												// [3]Tipo da nota fiscal
		aAdd( aCab, SF2->F2_EMISSAO)											// [4]Data de Emissao
		aAdd( aCab, SF2->F2_CLIENTE)											// [5]Codigo do cliente
		aAdd( aCab, SF2->F2_LOJA)												// [6]Loja do Cliente
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_NOME, SA1->A1_NOME))		// [7]Nome do Cliente
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_END, SA1->A1_END))			// [8]Endere�o
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_BAIRRO, SA1->A1_BAIRRO))	// [9]Bairro
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_CEP, SA1->A1_CEP))			// [10]Cep
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_MUN, SA1->A1_MUN))			// [11]Munic�pio
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_EST, SA1->A1_EST))			// [12]Estado
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_TEL, SA1->A1_TEL))			// [13]Fone
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_FAX, SA1->A1_FAX))			// [14]Fax
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_CGC, SA1->A1_CGC))			// [15]CGC
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_INSCR, SA1->A1_INSCR))		// [16]Inscri��o Estadual
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_INSCRM, SA1->A1_INSCRM))	// [17]Inscri��o Municipal
	   	aAdd( aCab, SF2->F2_VEND1)												// [18]Vendedor 
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_DDD, SA1->A1_DDD))			// [19]DDD  Incluido em 26/05/06
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_END, SA1->A1_ENDENT))		// [20]Endere�o de entrega
		aAdd( aCab, If(SF2->F2_TIPO $ "BD", SA2->A2_END, SA1->A1_ENDCOB))		// [21]Endere�o de cobranca

		//���������������������������������������������������������Ŀ
		//� Alimenta array com os campos do rodap� da nota (totais) �
		//�����������������������������������������������������������
		aAdd( aRodape, If(SF2->F2_VALBRUT == 0,;
						SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE,;
						SF2->F2_VALBRUT))										// [1]Valor Bruto
		aAdd( aRodape, SF2->F2_VALMERC)											// [2]Valor  da Mercadoria
		aAdd( aRodape, SF2->F2_VALFAT)											// [3]Valor faturado
		aAdd( aRodape, SF2->F2_FRETE)											// [4]Frete
		aAdd( aRodape, SF2->F2_ICMFRET)											// [5]ICMS sobre o frete
		aAdd( aRodape, SF2->F2_FRETAUT)											// [6]Frete Aut�nomo
		aAdd( aRodape, SF2->F2_ICMAUTO)											// [7]ICMS sobre Frete Aut�nomo
		aAdd( aRodape, SF2->F2_SEGURO)											// [8]Seguro
		aAdd( aRodape, SF2->F2_DESPESA)											// [9]Despesas acessorias
		aAdd( aRodape, SF2->F2_DESCONT)											// [10]Desconto total
		aAdd( aRodape, SF2->F2_VALACRS)											// [11]Acr�scimos
		aAdd( aRodape, SF2->F2_BASEICM)											// [12]Base do ICMS
		aAdd( aRodape, SF2->F2_VALICM)											// [13]Valor  do ICMS
		aAdd( aRodape, SF2->F2_BASEIPI)											// [14]Base do IPI
		aAdd( aRodape, SF2->F2_VALIPI) 											// [15]Valor  do IPI
		aAdd( aRodape, SF2->F2_BRICMS)											// [16]Base do ICMS retido
		aAdd( aRodape, SF2->F2_ICMSRET)											// [17]Valor do ICMS Retido
		aAdd( aRodape, SF2->F2_BASEISS)											// [18]Base do ISS
		aAdd( aRodape, SF2->F2_VALISS)											// [19]Valor do ISS
		aAdd( aRodape, SF2->F2_BASEINS)											// [20]Base do INSS
		aAdd( aRodape, SF2->F2_VALINSS)											// [21]Valor do INSS
		aAdd( aRodape, SF2->F2_VALIRRF)											// [22]Valor do IRRF

		//���������������������������������������������������������Ŀ
		//� Alimenta array com os campos do rodap� da nota (totais) �
		//�����������������������������������������������������������
		dbSelectArea("SE1")
		MsSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC,.T.)
		While !Eof() .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO .And.;
							SE1->E1_NUM == SF2->F2_DOC
			//������������������������������������������������������������������������Ŀ
			//� Se for t�tulo referente a parcela da nota grava dados no array aDuplic �
			//��������������������������������������������������������������������������
			If SE1->E1_TIPO == "NF "
				aAdd( aDuplic,	{	SF2->F2_PREFIXO,;							// [1]Prefixo do T�tulo
									SF2->F2_DUPL,;								// [2]Numero da duplicata
									SF2->F2_COND,;								// [3]Condicao de Pagamento
									GetAdvFVal("SE4",;
							 			"E4_DESCRI",;
							 			xFilial("SE4")+SF2->F2_COND,;
										1,0),;									// [4]Descri��o da Condi��o de Pagamento
									SE1->E1_PARCELA,;							// [5]Parcela
									SE1->E1_VALOR,;								// [6]Valor do T�tulo
									SE1->E1_VENCTO,;							// [7]Vencimento
									SE1->E1_VENCREA,;							// [8]Vencimento Real
									SE1->E1_EMISSAO ;							// [9]Emissao
									})
			//��������������������������������������������������������������������������Ŀ
			//� Se for t�tulo referente a abatimento grava os valores no array aImpostos �
			//����������������������������������������������������������������������������
			ElseIf SE1->E1_TIPO $ MVIRABT .Or.;		// Soma o valor do IRRF
				SE1->E1_TIPO $ MVINABT .Or.;	 	// Soma o valor do Inss
				SE1->E1_TIPO $ MVCSABT .Or.;		// Soma o valor do Csll
				SE1->E1_TIPO $ MVCFABT .Or.;		// Soma o valor do Cofins
				SE1->E1_TIPO $ MVPIABT				// Soma o valor do Pis

				nElem	:= aScan( aImpostos, { |x| x[1] == SE1->E1_TIPO })
				If nElem == 0
					aAdd( aImpostos, { SE1->E1_TIPO, SE1->E1_VALOR})
				Else
					aImpostos[nElem,2]	+= SE1->E1_VALOR
				EndIf
			EndIf
			dbSelectArea("SE1")
			dbSkip()
		EndDo
		dbSelectArea("SF2")

		//�����������������������������������������������������Ŀ
		//� Alimenta array de mensagens com os impostos da nota �
		//�������������������������������������������������������     
		        
		If Len(aImpostos) > 0
			cMensag	:= "RETENCAO NA FONTE: "
			For nLoop := 1 To Len(aImpostos)
				If aImpostos[nLoop,1] == "IR-"
					cLblTip		:= "IRRF"                    //Valor Bruto
					nAlqImp	:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "IN-"
					cLblTip		:= "INSS"
					nAlqImp	:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				Else 	
					cLblTip	:= ""
					nAlqImp	:= 0
			    Endif		
				cMensag	+= Iif(!empty(cLblTip),cLblTip+"-"+AllTrim(Transform(nAlqImp, "@E 999.99%"))+" R$ "+AllTrim(Transform(aImpostos[nLoop,2], "@E 999,999,999.99"))+" ","") 	
			Next    
			CallMens(cMensag, 2, "0")
			
			cMensag	:= "RETENCAO NA FONTE: "
			For nLoop := 1 To Len(aImpostos)	
				If aImpostos[nLoop,1] == "CS-"
					cLblTip		:= "CSLL"
					nAlqImp		:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "CF-"
					cLblTip		:= "COFINS"
					nAlqImp		:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)
				ElseIf aImpostos[nLoop,1] == "PI-"
					cLblTip		:= "PIS"
					nAlqImp		:= Round((aImpostos[nLoop,2] / aRodape[1])*100,2)     
				Else 	
					cLblTip	:= ""
					nAlqImp	:= 0
			    Endif		
				cMensag	+= Iif(!empty(cLblTip),cLblTip+"-"+AllTrim(Transform(nAlqImp, "@E 999.99%"))+" R$ "+AllTrim(Transform(aImpostos[nLoop,2], "@E 999,999,999.99"))+" ","") 					
			Next nLoop  
			CallMens(cMensag, 2, "0")
		EndIf

		//����������������������������������������������������������������������Ŀ
		//� Alimenta array com os campos da transportadora e dados do transporte �
		//������������������������������������������������������������������������
		/*
		If !Empty(SF2->F2_TRANSP)
			dbSelectArea("SA4")
			If !MsSeek(xFilial("SA4")+SF2->F2_TRANSP)
				Aviso(	cTitulo,;
							"Transportadora n�o localizada no arquivo! Contate o Administrador.",;
							{"&Continua"},,;
							"Transportadora: "+SF2->F2_TRANSP)
				lTransp	:= .F.
				Return(Nil)
			EndIf
		Else
			lTransp	:= .F.
		EndIf
		dbSelectArea("SF2")
		aAdd( aTransp, SF2->F2_TRANSP)											// [1]C�digo da Transportadora
		aAdd( aTransp, SF2->F2_REDESP)											// [2]Transportadora de Redespacho
		If lTransp
			aAdd( aTransp, SA4->A4_NOME)										// [3]Nome da Transportadora
			aAdd( aTransp, SA4->A4_END)											// [4]Endere�o
			aAdd( aTransp, SA4->A4_BAIRRO)										// [5]Bairro
			aAdd( aTransp, SA4->A4_MUN)											// [6]Munic�pio
			aAdd( aTransp, SA4->A4_EST)											// [7]Estado
			aAdd( aTransp, SA4->A4_CEP)											// [8]Cep 
			aAdd( aTransp, SA4->A4_CGC)											// [9]CGC
			aAdd( aTransp, SA4->A4_INSEST)										// [10]Inscri��o Estadual
		Else
			aAdd( aTransp, CriaVar("A4_NOME",.F.))
			aAdd( aTransp, CriaVar("A4_END",.F.))
			aAdd( aTransp, CriaVar("A4_BAIRRO",.F.))
			aAdd( aTransp, CriaVar("A4_MUN",.F.))
			aAdd( aTransp, CriaVar("A4_EST",.F.))
			aAdd( aTransp, CriaVar("A4_CEP",.F.))
			aAdd( aTransp, CriaVar("A4_CGC",.F.))
			aAdd( aTransp, CriaVar("A4_INSEST",.F.))
		EndIf
		If SF2->(FieldPos("F2_TPFRETE")) > 0
			aAdd( aTransp, SF2->F2_TPFRETE)										// [11]Tipo de Frete (1=CIF,2=FOB)
		Else
			aAdd( aTransp, "1")
		EndIf
		If SF2->(FieldPos("F2_UFPLAC")) > 0
			aAdd( aTransp, SF2->F2_UFPLAC)										// [12]UF da Placa do Ve�culo
		Else
			aAdd( aTransp, SA4->A4_EST)	
		EndIf
		If SF2->(FieldPos("F2_XPLACA")) > 0
			aAdd( aTransp, SF2->F2_XPLACA)										// [13]Placa do Caminh�o
		Else
			aAdd( aTransp, " ")
		EndIf
		aAdd( aTransp, SF2->F2_VOLUME1)											// [14]Quantidade de Volumes
		aAdd( aTransp, SF2->F2_ESPECI1)											// [15]Esp�cie dos Volumes 
		If SF2->(FieldPos("F2_MARCA")) > 0
			aAdd( aTransp, SF2->F2_MARCA)										// [16]Marca dos Volumes
		Else
			aAdd( aTransp, " ")
		EndIf
		If SF2->(FieldPos("F2_NUMVOL")) > 0
			aAdd( aTransp, SF2->F2_NUMVOL)										// [17]N�mero dos dos Volumes
		Else
			aAdd( aTransp, " ")
		EndIf
		aAdd( aTransp, SF2->F2_PBRUTO)											// [18]Peso Bruto Total
		aAdd( aTransp, SF2->F2_PLIQUI)											// [19]Peso L�quido Total
        */

		//����������������������������������������������������������������������������������������������������������Ŀ
		//� Permite a Impressao da Msg do Pedido de Vendas (C5_MENNOTM) somente uma vez por Nota - Cezar em 22/05/06 �
		//������������������������������������������������������������������������������������������������������������
		//lDetmsg	:=	.T.
		
		nVlZfr := 0 //Desconto Zona Franca
		
		//�������������������������������������������������������Ŀ
		//� Alimenta array com os campos dos itens da nota fiscal �
		//���������������������������������������������������������
		dbSelectArea("SD2")
		dbSetorder(3)
		MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
		
		lC5Mens := .t.

		While !Eof() .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC == SF2->F2_DOC .And.;
							SD2->D2_SERIE == SF2->F2_SERIE
		
			//���������������������������������Ŀ
			//� Posiciona no arquivo de Produto �
			//�����������������������������������
			dbSelectArea("SB1")
			If !MsSeek(xFilial("SB1")+SD2->D2_COD)
				Aviso(	cTitulo,;
							"Produto n�o localizado no arquivo! Contate o Administrador.",;
							{"&Continua"},,;
							"Produto: "+SD2->D2_COD)
				Return(Nil)
			EndIf
			//����������������������������������Ŀ
			//� Carrega as mensagens codificadas �
			//������������������������������������
			If SB1->(FieldPos("B1_MENNOT")) > 0 .And. !Empty(SB1->B1_MENNOT)
				If aScan( aCodMen, { |x| x[2] == SB1->B1_MENNOT } ) == 0
					aAdd( aCodMen, { "8", SB1->B1_MENNOT } )
				EndIf
			EndIf
			//������������������������������������Ŀ
			//� Defino o c�digo NBM para o produto �
			//��������������������������������������
			If Empty(SB1->B1_CLASFIS)
				cCodNBM	:= CriaVar("B1_CLASFIS",.F.)
				If !Empty(SB1->B1_POSIPI)
					nElem := aScan( aNBM, { |x| x[2] == SB1->B1_POSIPI})
					If nElem > 0
						cCodNBM	:= aNBM[nElem, 01]
					Else
						If Len(aNBM) > 0
							cCodNBM	:= Soma1(aNBM[Len(aNBM),01], TAMSX3("B1_CLASFIS")[1])
						Else
							cCodNBM	:= "A"
						EndIf
						aAdd( aNBM, { cCodNBM, SB1->B1_POSIPI })
					EndIf
				EndIf
			Else
				cCodNBM	:= SB1->B1_CLASFIS
			EndIf
            
            _CDESSRV := SB1->B1_DESC                                    
            _CALIQISS:= SD2->D2_ALIQISS
            
			//�������������������������������������������������Ŀ
			//� Posiciona no arquivo de Tipo de Entrada e Sa�da �
			//���������������������������������������������������
			dbSelectArea("SF4")
			If !MsSeek(xFilial("SF4")+SD2->D2_TES)
				Aviso(	cTitulo,;
						"Tipo de Entrada/Sa�da n�o localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"TES: "+SD2->D2_TES)
				Return(Nil)
			EndIf
			//����������������������������������Ŀ
			//� Carrega as mensagens codificadas �
			//������������������������������������
			If SF4->(FieldPos("F4_XMSG1")) > 0 .And. !Empty(SF4->F4_XMSG1)
				If aScan( aCodMen, { |x| x[2] == SF4->F4_XMSG1} ) == 0
					aAdd( aCodMen, { "1", SF4->F4_XMSG1 } )
				EndIf
			EndIf
			//�����������������������������������������������Ŀ
			//� Adiciona o array com as naturezas de opera��o �
			//�������������������������������������������������
			If aScan( aNatOpe, { |x| x[2] == SD2->D2_CF }) == 0
				aAdd( aNatOpe, { SD2->D2_TES, SD2->D2_CF, SF4->F4_TEXTO })
			EndIf

			//������������������������������������������������������Ŀ
			//� Posiciona no arquivo do Cabe�alho do Pedido de Venda �
			//��������������������������������������������������������
			dbSelectArea("SC5")
			dbsetorder(1)
			If !dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
				Aviso(	cTitulo,;
						"Cabe�alho do Pedido n�o localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Pedido: "+SD2->D2_PEDIDO)
				Return(Nil)
			EndIf
			//����������������������������������Ŀ
			//� Carrega as mensagens codificadas �
			//������������������������������������
			If !Empty(SC5->C5_MENPAD)
				If aScan( aCodMen, { |x| x[2] == SC5->C5_MENPAD } ) == 0
					aAdd( aCodMen, { "3", SC5->C5_MENPAD} )
				EndIf
			EndIf
			//��������������������������������Ŀ
			//� Carrega as mensagens digitadas �
			//����������������������������������
			If !Empty(SC5->C5_MENNOTA) .and. lC5Mens
				//CallMens( SC5->C5_MENNOTA, 2, "4" ) 
				cC5Mens := Alltrim(SC5->C5_MENNOTA)
				lC5Mens := .f.
			EndIf
			
			//���������������������������������������������������Ŀ
			//� Posiciona no arquivo dos Itens do Pedido de Venda �
			//�����������������������������������������������������
			dbSelectArea("SC6")
			If !MsSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
				Aviso(	cTitulo,;
						"Item do Pedido n�o localizado no arquivo! Contate o Administrador.",;
						{"&Continua"},,;
						"Pedido/Item: "+SD2->D2_PEDIDO+"/"+SD2->D2_ITEMPV)
				Return(Nil)
			EndIf

			nQdeLnh	:= MlCount( SB1->B1_DESC, nTamPro)
			cOpMemo	:= "4"


			For nLoop := 1 To nQdeLnh
					//cMemo	:= MemoLine( SB1->B1_DESC, nTamPro, nLoop)                                            

				If SD2->D2_VALISS > 0
					If nLoop <> 1
						aAdd( aServico, {	CriaVar("D2_COD",.F.),;
											_CDESSRV,;
											CriaVar("D2_UM",.F.),;
											CriaVar("D2_QUANT",.F.),;
											CriaVar("D2_PRCVEN",.F.),;
											CriaVar("D2_TOTAL",.F.) ;
										})
					Else
						aAdd( aServico, {	SD2->D2_COD,;
											_CDESSRV,;
											SD2->D2_UM,;
											SD2->D2_QUANT,;
											SD2->D2_PRCVEN,;
											SD2->D2_TOTAL ;
										})
					EndIf
				Endif
				    /*
					//����������������������������������������������������Ŀ
					//� Adiciona o array apenas com a descri��o do produto �
					//������������������������������������������������������
					If nLoop <> 1
						aAdd( aItens, {	CriaVar("SD2->D2_COD", .F.),;				// [1]C�digo do Produto
										_CDESSRV,;										// [2]Descri��o
										CriaVar("B1_CLASFIS", .F.),;				// [3]NBM
										CriaVar("D2_CLASFIS", .F.),;				// [4]Situa��o Tribut�ria
										CriaVar("D2_UM", .F.),;						// [5]Unidade de Medida
										CriaVar("D2_QUANT", .F.),;					// [6]Quantidade
										CriaVar("D2_PRCVEN", .F.),;					// [7]Pre�o de Venda
										CriaVar("D2_TOTAL", .F.),;					// [8]Pre�o Total
										CriaVar("D2_PICM", .F.),;					// [9]Percentual do ICMS
										CriaVar("D2_IPI", .F.),;					// [10]Percentual do IPI
										CriaVar("D2_VALIPI", .F.),;					// [11]Valor do IPI
										CriaVar("D2_CF", .F.),;						// [12]C�digo Fiscal de Opera��o e Presta��o
										CriaVar("D2_QTSEGUM", .F.),;				// [13]Quantidade na 2 unidade de medida
										CriaVar("D2_SEGUM", .F.), ;					// [14]2 unidade de medida
										CriaVar("D2_PEDIDO", .F.) ;					// [15]Numero do pedido de venda
										 })
					//���������������������������������������������Ŀ
					//� Adiciona o array todos oa dados necess�rios �
					//�����������������������������������������������
					Else
						aAdd( aItens, {	SD2->D2_COD,;
										_CDESSRV,;
										cCodNBM,;
										If(!Empty(SD2->D2_CLASFIS),;
											SD2->D2_CLASFIS,;
											SB1->B1_ORIGEM+SF4->F4_SITTRIB)	,;
										SD2->D2_UM,;
										SD2->D2_QUANT,;
										If(Empty(SD2->D2_DESCZFR),SD2->D2_PRCVEN,Round((SD2->D2_TOTAL+SD2->D2_DESCZFR)/SD2->D2_QUANT,2) ),;
										If(Empty(SD2->D2_DESCZFR),SD2->D2_TOTAL,Round(SD2->D2_TOTAL+SD2->D2_DESCZFR,2)),;
										SD2->D2_PICM,;
										If(SF4->F4_DESTACA <> "N", SD2->D2_IPI, 0),;
										If(SF4->F4_DESTACA <> "N", SD2->D2_VALIPI, 0),;
										SD2->D2_CF,;
										SD2->D2_QTSEGUM,;
										SD2->D2_SEGUM,;
										SD2->D2_PEDIDO ;
										})

						nVlZfr := nVlZfr + SD2->D2_DESCZFR
						
					EndIf 
				EndIF   */
			Next nLoop
             
			//���������������������������������������������������������Ŀ
			//� Adiciona o array com os valores do IPI no corpo da nota �
			//�����������������������������������������������������������
			If SF4->F4_DESTACA == "N" .And. SF2->F2_TIPO $ "BD"
				aAdd( aIPIDEV, SD2->D2_VALIPI )
				lIPIObs	:= .T.
			EndIf
			
			/*
			//��������������������������������������������Ŀ
			//� Adiciona o array com as notas de devolu��o �
			//����������������������������������������������
			If !Empty(SD2->D2_NFORI)
				dbSelectArea("SF1")
				If MsSeek(xFilial("SF1")+SD2->(D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA))
					dEmiDev	:= SF1->F1_EMISSAO
				EndIf
				dbSelectArea("SD2")
				If aScan( aNFDev, { |x| x[1]+x[2] == SD2->D2_NFORI+SD2->D2_SERIORI }) == 0
					aAdd( aNFDev, { SD2->D2_NFORI, SD2->D2_SERIORI, dEmiDev, SD2->D2_TIPO })
				EndIf
			EndIf
			*/
			
			//�������������������������������Ŀ
			//�Vai para o proximo item de nota�
			//���������������������������������
			dbSelectArea("SD2")
			dbSkip()
			
		Enddo

        /*
		If !Empty(aTransp[18]) .Or. !Empty(aTransp[19])//Peso Bruto Total / Peso L�quido Total
			//�������������������������Ŀ
			//� Pega os pesos do Pedido �
			//���������������������������
			If Len(aPesPed) > 0
				lSomLiq	:= Empty(aTransp[18])//Peso Bruto Total
				lSomBru	:= Empty(aTransp[19])//Peso L�quido Total
				For nLoop := 1 To Len(aPesPed)
					If lSomLiq
						aTransp[18]	+= aPesPed[nLoop,03]
					EndIf
					If lSomBru
						aTransp[19] += aPesPed[nLoop,02]
					EndIf
				Next nLoop
			EndIf
			//��������������������������Ŀ
			//� Pega os pesos do produto �
			//����������������������������
			If Empty(aTransp[18]) .Or. Empty(aTransp[19])
				If Empty(aTRansp[18])
					aTransp[18]	+= nPesLiq
				EndIf
				If Empty(aTransp[19])
					aTransp[19] += nPesBru
				EndIf
			EndIf
		EndIf
		*/	
		//����������������������������������������Ŀ
		//� Monta a mensagem de devolu��o de notas �
		//������������������������������������������
		cMensag	:= ""
		If Len(aNFDev) > 0
			If aNFDev[1,4] == "D"
				cMensag	:= "Devolucao   "
			ElseIf aNFDev[1,4] == "C"
				cMensag	:= "Complemento "
			Else
				cMensag	:= "Retorno "
			EndIf
			cMensag	+= "Ref. a sua(s) nota(s) fiscal(is) "
			For nLoop := 1 To Len(aNFDev)
				If nLoop <> 1
					cMensag	+= " e "
				EndIf
				cMensag	+= AllTrim(aNFDev[nLoop,1])+"/"+AllTrim(aNFDev[nLoop,2])+" de "+DToC(aNFDev[nLoop,3])
			Next nLoop
		EndIf
		//�����������������������������������Ŀ
		//� Grava a mensagem montada no array �
		//�������������������������������������
		If !Empty(cMensag)
			CallMens(cMensag, 2, "2")
		EndIf

		//��������������������������������Ŀ
		//� Grava as mensagens codificadas �
		//����������������������������������
		For nLoop := 1 To Len(aCodMen)
			CallMens(aCodMen[nLoop,2], 1, aCodMen[nLoop,1]+StrZero(nLoop,2))
		Next nLoop       
             

       
		//�����������������������������������������������Ŀ
		//�Calcula a quantidade de formularios necessarios�
		//�������������������������������������������������
		//nFormul := Max( Int(Len(aItens)/nTamDet + .999999999), Int(Len(aServico)/nTamSer + .999999999) )
        nFormul := Max(0,Int(Len(aServico)/nTamSer + .999999999) )                                                                                                  

		//����������������������������������������Ŀ
		//�Chama funcao de impressao da nota fiscal�
		//������������������������������������������
		For nForAtu := 1 to nFormul
			Imprime()
		Next

		//�����������������������������������������������������������������������Ŀ
		//� Grava o flag de nota impressa se foi pedido a impress�o na impressora �
		//�������������������������������������������������������������������������
		dbSelectArea("SF2")
		If aReturn[5] == 3          //2 // Alterado em 31/05/06 - Cezar, pois Direto na Porta retorna 3
			RecLock("SF2",.F.)
				SF2->F2_FIMP	:= "X"
			MsUnLock()
		EndIf

		//�������������������������������������������Ŀ
		//�Movimenta o registro e a regua de impressao�
		//���������������������������������������������
		dbSelectArea("SF2")
		dbSkip()
	EndDo

//�����������������������������������������������������������������
//�Imprime caracter de descompactacao e zera posicao do formulario�
//�����������������������������������������������������������������
@ 000, 000 PSAY Chr(18)					  // Descompressao de caracteres

//�������������������Ŀ
//�Encerra a impressao�
//���������������������
Set Device To Screen    

SetPgEject(.f.)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	OurSpool(wnrel)
Endif

Ms_Flush()


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




******************************************************************************************************
Static Function VisaFImp(aFImp)
******************************************************************************************************

Local oDlg
Local oListBox
Local aTitulo	:= {	"Nota Fiscal",;
						"S�rie",;
						"Emiss�o",;
						"Valor Bruto",;
						"C�digo Cliente",;
						"Loja",;
						"Nome Cliente/Fornecedor" ;
						}								// Array com os t'tiulos da janela listbox
Local cListBox	:= ""

//�����������������������������������������������Ŀ
//| Array aFImp                                   | 
//| 1o. Elemento - N�mero da Nota Fiscal          |
//| 2o. Elemento - S�rie da Nota Fiscal           |
//| 3o. Elemento - Data de Emiss�o da Nota Fiscal |
//| 4o. Elemento - Valor Bruto da Nota Fiscal     |
//| 5o. Elemento - C�digo do Cliente              |
//| 6o. Elemento - Loja do Cliente                |
//| 7o. Elemento - Nome do Cliente                |
//�������������������������������������������������

//�����������������������������������������������������������������������������������������������Ŀ
//| Ordena array pela parcela de forma descendente para que o registro totalizador fique primeiro |
//�������������������������������������������������������������������������������������������������
aSort(aFImp,,, { |x, y| x[2]+x[1] < y[2]+y[1] } )

//���������������Ŀ
//| Monta display |
//�����������������
DEFINE MSDIALOG oDlg TITLE "Notas Fiscais n�o Impressas" From 9,0 To 19,60 OF oMainWnd 
DEFINE SBUTTON FROM    4,206 	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg 
@ .5,.7 LISTBOX oListBox VAR cListBox Fields HEADER ;
										aTitulo[1],;
										aTitulo[2],;
										aTitulo[3],;
										aTitulo[4],;
										aTitulo[5],;
										aTitulo[6],;
										aTitulo[7],;
										SIZE 195,62 
oListBox:SetArray(aFImp)
oListBox:bLine := { || {	aFImp[oListBox:nAt,1],;
   							aFImp[oListBox:nAt,2],;
   							aFImp[oListBox:nAt,3],;
							Transform(aFImp[oListBox:nAt,4], "@E 9,999,999.99"),;
							aFImp[oListBox:nAt,5],;
							aFImp[oListBox:nAt,6],;
							aFImp[oListBox:nAt,7] ;
							}}
ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)




******************************************************************************************************
Static Function CallMens(cMensag, nTipo, cPrior)
******************************************************************************************************

Local cTexto	:= ""
Local nLoop		:= 0
Local nCnt		:= 0

//������������������������������������������Ŀ
//| Se for mensagem codificada monta o texto |
//��������������������������������������������
If nTipo == 1
	cTexto	:= AllTrim(Formula(cMensag))
Else
	cTexto	:= AllTrim(cMensag)
EndIf

For nLoop := 1 To Len(cTexto) Step nTamMen
	nCnt++
	aAdd( aDadAdc, { cPrior+StrZero(nCnt,2), SubStr(cTexto,nLoop,nTamMen)} )
Next

Return(Nil)




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

For nLoop := 1 To Len(aNatOpe)
	cNatOpe	+= If(!Empty(cNatOpe), "/", "")+AllTrim(aNatOpe[nLoop,3])
	cCFOOpe += If(!Empty(cCFOOpe), "/", "")+Transform(aNatOpe[nLoop,2], "@R 9.999")
Next nLoop

//�����������������������������Ŀ
//| Imprime o Cabe�alho da Nota |
//�������������������������������

Li := 2
Li+= 9
@ Li,004 PSAY Left(cNatOpe, 40)
//@ Li,045 PSAY Left(cCFOOpe, 14)
@ Li,105 PSAY aCab[4]//Data de Emissao

Li+= 4
@ Li,004 PSAY Alltrim(aCab[7])+" - "+aCab[5]+"-"+aCab[6]//Nome do Cliente + Codigo + Loja
If Len(Alltrim(aCab[15])) > 11		//CGC
	@ Li,090 PSAY Transform(aCab[15], "@R 99.999.999/9999-99")
Else
	@ Li,090 PSAY Transform(aCab[15], "@R 999.999.999-99")
EndIf

Li+= 3
@ Li,004 PSAY aCab[8]//Endere�o
@ Li,090 PSAY aCab[9]//Bairro

Li+= 2
@ Li,004 PSAY aCab[11]//Munic�pio
@ Li,045 PSAY Transform(aCab[10], "@R 99999-999")//Cep
@ Li,065 PSAY If(!Empty(Alltrim(aCab[13])), "("+Alltrim(aCab[19])+")"+Transform(AllTrim(aCab[13]), "@R 9999-9999")," ")//+" "+Transform(AllTrim(aCab[14]), "@R 9999-9999")," ")//DDD / Fone / Fax
@ Li,085 PSAY aCab[12]//Estado
@ Li,090 PSAY Transform(aCab[16], "@R 999.999.999.999")//Inscri��o Estadual

//�����������������������Ŀ
//| Imprime as Duplicatas |
//�������������������������

Li+= 3

cDuplic := cDuplic1 := cDuplic2 := ""

Li := 26


//�����������������������������Ŀ
//| Imprime os Itens de Servi�o |
//�������������������������������
If Len(aServico) > 0
	ImpSer(Li)
EndIf

//�����������������������������Ŀ
//�Imprime Mensagens nos itens  �
//�������������������������������
       
LI := 48
@ LI,004 PSAY "Novo Endereco: Estrada Tenente Marques, 5.555. Andar 4 Sala 410."

Li := 50

//��������������������������������������������Ŀ
//� Ordena o array por prioridade de impress�o �
//����������������������������������������������
aSort( aDadAdc,,, { |x,y| x[1] < y[1] } )

//����������������������Ŀ
//� Mensagens Adicionais �
//������������������������

For nLoop := 1 To Len(aDadAdc)
	
	@ Li,004 PSAY aDadAdc[nLoop,2]

	Li++

Next nLoop

Li := 68
If nFormul > 1 .And. nForAtu <> nFormul
	@ Li,009 PSAY "****,***,***.**"
	@ Li,032 PSAY "****,***,***.**"
	@ Li,056 PSAY "****,***,***.**"
	@ Li,079 PSAY "****,***,***.**"
	@ Li,108 PSAY "****,***,***.**"
Else
	@ Li,009 PSAY aRodape[18]				Picture "@E 9999,999,999.99" //Base do ISS
	@ Li,038 PSAY _CALIQISS 				Picture "@E 9999,999,999.99" //Aliquota do ISS
	@ Li,066 PSAY aRodape[19]				Picture "@E 9999,999,999.99" //Valor do Iss
	@ Li,103 PSAY aRodape[01]       		Picture "@E 9999,999,999.99" //Valor  da Mercadoria
EndIf

Li += 5

If Len(aDuplic) >= 1
   For nX:=1 To Len(aDuplic)
   	   cDuplic += DToC(aDuplic[nX,7])+"-"+Alltrim(Transform(aDuplic[nX,6], "@E 999,999,999.99"))+" " 
   	   If nx == 3
   	      exit
   	   Endif   
   Next
Endif        
IF !empty(cDuplic)
   @ Li,002 PSAY substr(cDuplic,1,60)
Endif   
If !empty(sc5->c5_mennota)
   @ li, 064 PSAY SUBSTR(SC5->C5_MENNOTA,1,58)
endif

If Len(aDuplic) >= 4
   For nX:=4 To Len(aDuplic)
   	   cDuplic1 := DToC(aDuplic[nX,7])+"-"+Alltrim(Transform(aDuplic[nX,6], "@E 999,999,999.99"))+" " 
   	   If nx == 6
   	      exit
   	   Endif   
   Next
Endif 

li++  

If !empty(cDuplic1) 
   @ li, 002 PSAY SUBSTR(cDuplic1,1,60)
endif
If !empty(sc5->c5_mennota) .and. len(sc5->c5_mennota) >=58
   @ li, 064 PSAY SUBSTR(SC5->C5_MENNOTA,59,58)
endif              

li++

If Len(aDuplic) >= 7
   For nX:=7 To Len(aDuplic)
   	   cDuplic2 := DToC(aDuplic[nX,7])+"-"+Alltrim(Transform(aDuplic[nX,6], "@E 999,999,999.99"))+" " 
   	   If nx == 9
   	      exit
   	   Endif   
   Next
Endif               

If !empty(cDuplic2) 
   @ li, 002 PSAY SUBSTR(cDuplic2,1,60)
endif
If !empty(sc5->c5_mennota) .and. len(sc5->c5_mennota) >=118
   @ li, 064 PSAY SUBSTR(SC5->C5_MENNOTA,119,58)
endif

Li:=88


//�����������������������������Ŀ
//�Posiciona final do formulario�
//�������������������������������
//@ Li,000 PSAY Chr(18)+Chr(15)


//@ Li,000 PSAY Chr(27)+"@"
//Li := 0												// reinicio
//@ li,000 PSay Chr(27)+Chr(67)+chr(104)				// Define tamanho do papel em 100 linhas/pagina... (Junior)
//@ Li,000 PSay Chr(27)+Chr(48)       		 		// Compressao de Impressao - Linha		(Junior em 26/04/06)

//@ Li,000 PSAY Chr(15)							// Define caracteres comprimidos

@ Li,000 PSAY "."+Chr(18)+Chr(15)
SetPrc(0,0)                              // (Zera o Formulario)

Return(.T.)



*******************************************************************************************************
Static Function ImpDet()
*******************************************************************************************************

Local nLoop1 := 0

For nLoop1 := (nForAtu-1)*nTamDet+1 To Min(Len(aItens),nForAtu*nTamDet)

	@ Li,004 PSAY Left(aItens[nLoop1,01],14)			// Codigo
	@ Li,016 PSAY aItens[nLoop1,02]						// Descricao
	//��������������������������������������������������������������������Ŀ
	//� S� imprime os demais dados se n�o for a linha prinicpal do produto �
	//����������������������������������������������������������������������
	If !Empty(aItens[nLoop1,01])
		@ Li,059 PSAY aItens[nLoop1,03]											// NCM
	    @ Li,063 PSAY aItens[nLoop1,04]											// Sit. Tribut.
		@ Li,069 PSAY aItens[nLoop1,05]											// Unidade
		@ Li,071 PSAY aItens[nLoop1,06]				Picture "@E 999,999.99"		// Qtde.
	    @ Li,083 PSAY aItens[nLoop1,07]				Picture "@E 999,999.99"		// Preco Unit.
		@ Li,096 PSAY aItens[nLoop1,08]				Picture "@E 999,999.99"		// Preco Total
		@ Li,108 PSAY aItens[nLoop1,09]				Picture "@E 99"	     		// ICMS (%)	
		@ Li,112 PSAY aItens[nLoop1,10]				Picture "@E 99.9"			// IPI (%)	
		@ Li,114 PSAY aItens[nLoop1,11]				Picture "@E 999,999.99"		// Valor do IPI 
	EndIf

	Li++

Next

Return(nLoop1)




*******************************************************************************************************
Static Function ImpSer(nLinIni)
*******************************************************************************************************

Local nLoop1 	:= 0

For nLoop1 := (nForAtu-1)*nTamSer+1 To Min(Len(aServico),nForAtu*nTamSer)
	@ Li,004 PSAY aServico[nLoop1,02]
	//��������������������������������������������������������������������Ŀ
	//� S� imprime os demais dados se n�o for a linha prinicpal do produto �
	//����������������������������������������������������������������������
	If !Empty(aServico[nLoop1,01])
	    @ Li,085 PSAY aServico[nLoop1,05]				Picture "@E 999,999,999.99"
		@ Li,105 PSAY aServico[nLoop1,06]				Picture "@E 99999,999,999.99"
	EndIf
	nTotSer += aServico[nLoop1,06]
	Li++
Next

//@ nLinIni+nTamSer,127 PSAY nTotSer						Picture "@E 99,999,999,999.99"

Return(nLoop1)
           




Static Function cmenpa                     
        
c1      := SC5->C5_XNFABAS
c2      := SC5->C5_XCODPA
c3      := SC5->C5_XDCODPA

cret := "P.A: "+c2+" - "+c3
      
Return(cret)  


Static Function cmenpaend                     
        
c1      := SC5->C5_XNFABAS
c2      := SC5->C5_XCODPA
c3      := SC5->C5_XDCODPA

area6   := getarea()

cQry	:= " SELECT * "
cQry	+= " FROM "+RetSqlName("ZZ1")+" ZZ1"
cQry	+= " WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"'"
cQry	+= " AND   ZZ1_COD    = '"+c2+"'"

If Select("TM1") > 0
	dbSelectArea("TM1")
	dbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS "TM1"
dbSelectArea("TM1")
dbGoTop()
ct := "Endereco Entrega: "+alltrim(TM1->ZZ1_END)   +" - "
ct += alltrim(TM1->ZZ1_BAIRRO)+" - "
ct += alltrim(TM1->ZZ1_MUN)   +" - "
ct += alltrim(TM1->ZZ1_EST)   +" - "
ct += alltrim(TM1->ZZ1_CEP)
 
dbCloseArea()

restarea(area6)

cret := ct
      
Return(cret)  
