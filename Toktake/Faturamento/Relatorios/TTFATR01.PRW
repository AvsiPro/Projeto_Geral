#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TTFATR01 � Autor � Totvs                 � Data � Out/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de notas de abastecimento.                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TTFATR01()

Local aRegs		:= {}
Local nLastKey	:= 0
Local cDesc1	:= "Este programa tem como objetivo efetuar a impress�o das"
Local cDesc2	:= "notinhas de abastecimento, conforme os par�metros"
Local cDesc3	:= "definidos pelo usu�rio."
Local cString	:= "SD3"
Local cPerg		:= "TTFATR01  "

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
Private cTamanho	:= "P"
Private cTitulo		:= "Impress�o das Notinhas de Abastecimento"
Private wnrel		:= "TTFATR01"
Private Li			:= 0

//�������������������������������������������������������������Ŀ
//� Define a quantidade de linhas para o detalhe da nota fiscal �
//���������������������������������������������������������������
Private nTamDet		:= 20

If cEmpAnt <> "01"
	Return
EndIf

// Monta array com as perguntas
aAdd(aRegs,{cPerg,"01","Nota Fiscal De"		,"","","mv_ch1","C",09,0,0,"G","","MV_PAR01","","","","","","",	"","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Nota Fiscal Ate"	,"","","mv_ch2","C",09,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Serie Nota De"		,"","","mv_ch3","C",03,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Serie Nota Ate"		,"","","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
                                                 

U_CriaSx1(aRegs)	

If !Pergunte(cPerg,.T.)
   Return()
Endif

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

//�����������������������Ŀ
//�Inicio do processamento�
//�������������������������
RptStatus( { |lEnd| RFATR99A() } )

Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TTFATR01 � Autor � Totvs                 � Data � Out/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de notas de abastecimento.                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RFATR99A()

//������������������������������������Ŀ
//� Definicoes das variaveis da funcao �
//��������������������������������������
Private aCab		:= {}
Private aItens		:= {}
Private nForAtu		:= 0	// Loop do Formul�rio de nota

//�������������������������������Ŀ
//� Inicializa r�gua de impress�o �
//���������������������������������
SetRegua(Val(mv_par02)-Val(mv_par01))

//�������������������������������Ŀ
//� Cria arquivo temporario       �
//���������������������������������

cQuery := ""
cQuery := "SELECT D3_XNUMNF NOTA,D3_XSERINF SERIE,D3_LOCAL LOC,D3_COD PRODUTO,D3_QUANT QTD,D3_XPATRI PATRI, "
cQuery += " B1_DESC DESCRI,F2_EMISSAO EMISSAO,F2_XPLACA PLACA,F2_TRANSP TRANSP,A4_NOME NOME,A4_END ENDERECO,A4_EST EST "
cQuery += " FROM "+RetSqlName("SD3")+" SD3,"+RetSqlName("SB1")+" SB1,"+RetSqlName("SF2")+" SF2, "+RetSqlName("SA4")+" SA4 "
cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery += " AND D3_XNUMNF BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += " AND D3_XSERINF BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
//cQuery += " AND SubString(D3_LOCAL,1,1) <> 'R' " //Somente os locais que nao sao rotas
cQuery += " AND D3_XTIPO = 'A' " //Somente os movimentos de abastecimento de entrada no PA
cQuery += " AND SD3.D_E_L_E_T_ <> '*' "
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += " AND D3_COD = B1_COD "
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " AND D3_XNUMNF = F2_DOC "
cQuery += " AND D3_XSERINF = F2_SERIE "
cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
cQuery += " AND A4_FILIAL = '"+xFilial("SA4")+"' "
cQuery += " AND F2_TRANSP = A4_COD "
cQuery += " AND SA4.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY D3_XNUMNF,D3_XSERINF,D3_LOCAL,D3_XPATRI "

U_MONTAQRY(cQuery,"TRB")  

DbSelectArea("TRB")

//��������������������������������������Ŀ
//� Impressao dos caracteres de controle �
//����������������������������������������
SetPrc(0,0)											// Inicializa impressora (Junior em 26/04/06)
Li := 0												// reinicio
@ Li,000 PSAY Chr(27)+"@"
@ li,000 PSay Chr(27)+Chr(67)+chr(104)				// Define tamanho do papel em 100 linhas/pagina... (Junior)
@ Li,000 PSay Chr(27)+Chr(48)       		 		// Compressao de Impressao - Linha		(Junior em 26/04/06)
@ Li,000 PSAY Chr(15)								// Define caracteres comprimidos

//����������������������������������Ŀ
//� Inicia loop do cabecalho de nota �
//������������������������������������

While !Eof()
	//��������������������������������Ŀ
	//� Movimenta a regua de impress�o �
	//����������������������������������
	IncRegua("Nota Fiscal "+TRB->NOTA+"/"+TRB->SERIE)		

	//���������������������������������������������Ŀ
	//� Verifica se houve cancelamento pelo usu�rio �
	//�����������������������������������������������
	IF lEnd
		@ Li,001 PSAY "** CANCELADO PELO OPERADOR **"
		lContinua := .F.
		Exit
	Endif

	//���������������������������������������������������Ŀ
	//� Alimenta array com os campos do cabecalho da nota �
	//�����������������������������������������������������
	aCab := {}
	
	aAdd( aCab, Alltrim(TRB->NOTA)) 	// [1]Numero Da nota de Carregamento
	aAdd( aCab, Alltrim(TRB->SERIE))	// [2]Serie
	aAdd( aCab, TRB->EMISSAO)			// [3]Serie
	aAdd( aCab, Alltrim(TRB->NOME))		// [4]Nome da transportadora
	aAdd( aCab, Alltrim(TRB->ENDERECO))	// [5]Ebdereco da transportadora
	aAdd( aCab, Alltrim(TRB->EST))		// [6]Estado da transportadora
	aAdd( aCab, Alltrim(TRB->PLACA))	// [7]Placa
	aAdd( aCab, Alltrim(TRB->LOC))		// [8] PA - Incluido pelo Wanderley Andrade
	aAdd( aCab, Alltrim(TRB->PATRI))	// [9] Patrimonio
	
	//�������������������������������������������������������Ŀ
	//� Alimenta array com os campos dos itens da nota fiscal �
	//���������������������������������������������������������
    
    cNota 	:= TRB->NOTA 		//Nota
	cSerie 	:= TRB->SERIE 		//Serie
	cLocal 	:= TRB->LOC 		//Ponto de Abastecimento
	cPatri 	:= TRB->PATRI 		//Numero de Parimonio

	aItens := {}
	
	While !Eof() .And. TRB->NOTA+TRB->SERIE+TRB->LOC+TRB->PATRI == cNota+cSerie+cLocal+cPatri
		
		aAdd( aItens, {	TRB->PRODUTO,;
						SubStr(TRB->DESCRI,1,25),;
						TRB->QTD;
						})

		dbSelectArea("TRB")
		dbSkip()

	Enddo

	//�����������������������������������������������Ŀ
	//�Calcula a quantidade de formularios necessarios�
	//�������������������������������������������������
	nFormul := Int(Len(aItens)/nTamDet + .999999999)

	//����������������������������������������Ŀ
	//�Chama funcao de impressao da nota fiscal�
	//������������������������������������������
	For nForAtu := 1 to nFormul
		Imprime()
	Next

	//�������������������������������������������Ŀ
	//�Movimenta o registro e a regua de impressao�
	//���������������������������������������������
	dbSelectArea("TRB")
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

Return()


*******************************************************************************************************
Static Function Imprime()
*******************************************************************************************************

Local nLoop1	:= 0

//��������������������������Ŀ
//| Imprime os Itens da Nota |
//����������������������������
//Li := 12
Li := 14

If Len(aItens) > 0
	
	For nLoop1 := (nForAtu-1)*nTamDet+1 To Min(Len(aItens),nForAtu*nTamDet)
	
		@ Li,000 PSAY aItens[nLoop1,01]							// Codigo
		@ Li,015 PSAY aItens[nLoop1,02]							// Descricao
		@ Li,051 PSAY aItens[nLoop1,03]	Picture "@E 9,999.99"	// Qtde
	
		Li++
	Next

EndIf

//�����������������������������������Ŀ
//� Imprime numero da nota no canhoto �
//�������������������������������������
//Li := 71
Li := 72

//@ Li,022 PSAY aCab[01]+"-"+aCab[02] 	//Nota+Serie de Carregamento
@ Li,005 PSAY "P.A: "+aCab[08]+" - "+aCab[01]+"-"+aCab[02] 	//Nota+Serie de Carregamento

li += 4
@ Li,005 PSAY aCab[09] 					//Patrimonio
@ Li,026 PSAY Stod(aCab[03]) 			//Emissao da nota
li += 4
@ Li,001 PSAY aCab[04] 					//Nome da transportador
@ Li,048 PSAY aCab[07] 					//Placa
li += 3
@ Li,001 PSAY SubStr(aCab[05],1,25)	//Endereco da transportadora
@ Li,048 PSAY aCab[06] 					//Estado da transportadora

Li += 5


//�����������������������������Ŀ
//�Posiciona final do formulario�
//�������������������������������
//@ Li,000 PSAY Chr(18)+Chr(15)


//@ Li,000 PSAY Chr(27)+"@"
//Li := 0									// reinicio
//@ li,000 PSay Chr(27)+Chr(67)+chr(104)	// Define tamanho do papel em 100 linhas/pagina... (Junior)
//@ Li,000 PSay Chr(27)+Chr(48)       		// Compressao de Impressao - Linha		(Junior em 26/04/06)

//@ Li,000 PSAY Chr(15)						// Define caracteres comprimidos

@ Li,000 PSAY "."+Chr(18)+Chr(15)
SetPrc(0,0)                              	// (Zera o Formulario)

Return(.T.)