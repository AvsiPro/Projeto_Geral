#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINR490	� Autor � Paulo Boschetti	    � Data � 23.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � C�pia de Cheques											  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � FINR490(void)						    				  ���
�������������������������������������������������������������������������Ĵ��
���	 Uso	 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FinR490n()
//��������������������������������������������������������������Ŀ
//� Define Variaveis 														  �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL cDesc1 := "Este programa ir� imprimir as copias dos cheques emitidos."
LOCAL cDesc2 := "Ser� impresso 1 ou 2 cheques for folha."
LOCAL cDesc3 :=""
LOCAL cString:="SEF"

PRIVATE titulo  :="Copias de Cheques"
PRIVATE aReturn := { "Zebrado", 1,"Administracao", 4, 2, 1, "",1 }
PRIVATE nLastKey:=0
PRIVATE nomeprog:="FINR490"
PRIVATE cPerg	 :="FIN490"
PRIVATE li		 :=1

If cEmpAnt <> "01"
	return
EndIF

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas 					         �
//����������������������������������������������������������������
pergunte("FIN490",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros					     �
//� mv_par01			// Codigo Do Banco					     �
//� mv_par02			// Da Agencia						     �
//� mv_par03			// Da Conta 						     �
//� mv_par04			// Do Cheque							 �
//� mv_par05			// Ate o Cheque							 �
//� mv_par06			// Imprime composicao do cheque			 �
//� mv_par07			// Copias p/ pagina (1/2)				 �
//� mv_par08			// Imprime Numeracao Sequencial			 �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT 						 �
//����������������������������������������������������������������
wnrel := "FINR490"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"P")

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa490Imp(@lEnd,wnRel,cString)},titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FA490Imp � Autor � Wagner Xavier 	    � Data � 13.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Copia de cheques											  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA490Imp(lEnd,wnRel,cString)								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd	  - A��o do CodeBlock								  ���
���			 � wnRel   - T�tulo do relat�rio 							  ���
���Parametros� cString - Mensagem										  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FA490Imp(lEnd,wnRel,cString)

LOCAL cExtenso := ""
LOCAL j,nTipo:=18,nRec,nContador:=0,cDocto

// Retirada a comparacao abaixo uma vez que o Protheus nao mais trabalha com normal e comprimido,
// mas com retradoe paisagem.
//nTipo   :=IIF(aReturn[4]==1,15,18)
mv_par01:=mv_par01+Space( 3-Len(mv_par01))
mv_par02:=mv_par02+Space( 5-Len(mv_par02))
mv_par03:=mv_par03+Space(10-Len(mv_par03))
mv_par04:=mv_par04+Space(15-Len(mv_par04))

//��������������������������������������������������������������Ŀ
//� Verifica se existe o Banco							         �
//����������������������������������������������������������������
DbSelectArea("SA6")
DbSeek(cFilial+mv_par01+mv_par02+mv_par03)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

//��������������������������������������������������������������Ŀ
//� Localiza o 1.Cheque a ser impresso 								  �
//����������������������������������������������������������������
dbSelectArea("SEF")
dbSeek(cFilial+mv_par01+mv_par02+mv_par03+mv_par04,.T.)

SetRegua(RecCount())
fa490Cabec(nTipo)
While !Eof() .And. EF_FILIAL+EF_BANCO=cFilial+mv_par01 .And. ;
	EF_AGENCIA=mv_par02 .And. EF_CONTA=mv_par03 .And. ;
	EF_NUM<=mv_par05
	
	If lEnd
		@Prow()+1,1 PSAY "Cancelado pelo operador"
		Exit
	EndIF
	
	IncRegua()
	
	IF EF_IMPRESS $ "AC" .or. SubStr(EF_TIPO,1,2) == "TB"
		dbSkip()
		Loop
	EndIF
	
	//���������������������Ŀ
	//�Validacao da carteira�
	//�����������������������
	
	If EF_CART = "R"
		DbSkip()
		Loop
	EndIf
	
	IF mv_par07 == 1		//uma copia por folha
		li:=1
	Elseif li > 32 		//so coube uma copia
		li:=1
	Else				//2 copias por folha
		IF nContador == 0
			li:=1
		Else
			li:=33
		EndIF
	EndIF
	
	nContador++
	IF nContador>2;nContador:=1;li:=1;EndIF
	__LogPages()
	@li, 1 PSAY Alltrim(SM0->M0_NOMECOM) + " - " + Alltrim(SM0->M0_FILIAL) + "  -  COPIA DE CHEQUE"
	li++
	@li, 0 PSAY Replicate("-",80)
	li++
	@li, 0 PSAY "|  Numero Cheque "  +EF_NUM
	@li,35 PSAY "Data da Emissao "  +Dtoc(EF_DATA)
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|  Banco "+EF_BANCO+  "     "    +SA6->A6_NREDUZ
	@li,35 PSAY "Agencia "+EF_AGENCIA+"   Conta "+EF_CONTA
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|  Valor Cheque "+Transform(EF_VALOR,"@E 9999,999,999.99")
	@li,35 PSAY "Data do Cheque  "+Dtoc(EF_DATA)
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|  Favorecido "+EF_BENEF
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|  Historico  "+EF_HIST
	@li,79 PSAY "|"
	li++
	If mv_par08 == 1
		
		//����������������������������������������������������������Ŀ
		//� Pegar e gravar o proximo numero da Copia do Cheque 	   �
		//� Posicionar no sx6 utilizando GetMv. N�o Utilize Seek !!! �
		//������������������������������������������������������������
		cDocto := STRZERO(VAL(Getmv("MV_NUMCOP"))+1,6)
		dbSelectArea("SX6")
		GetMv("MV_NUMCOP")
		RecLock("SX6",.F.)
		Replace X6_CONTEUD With cDocto
		MsUnlock()
		dbSelectArea("SEF")
		
		@li, 0 PSAY "|  Copia de Cheque No. "+cDocto
		@li,79 PSAY "|"
	Else
		@li, 0 PSAY "|"
		@li,79 PSAY "|"
	End
	li++
	@li, 0 PSAY "|  Vistos"
	@li,79 PSAY "|"
	li++
	@li, 0 PSAY "|"+Replicate("-",78)+"|"
	li++
	@li, 0 PSAY "|Observacoes      |Contas a Pagar|Gerente Financ|Contabilidade |Assinado por   |"
	li++
	@li, 0 PSAY "|-----------------|--------------|--------------|--------------|---------------|"
	li++
	For j:=1 to 3
		@li, 0 PSAY "|"
		@li,18 PSAY "|"
		@li,33 PSAY "|"
		@li,48 PSAY "|"
		@li,63 PSAY "|"
		@li,79 PSAY "|"
		li++
	Next j
	@li, 0 PSAY Replicate("-",80)
	nRec:=RecNo()
	IF mv_par06 == 1
		fr490Cpos(SEF->EF_NUM)
	EndIF
	dbGoTo(nRec)
	dbSkip()
End

Set Device To Screen
Set Filter To

If aReturn[5] = 1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � fr490Cpos� Autor � Wagner Xavier 		� Data � 13.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Copia de cheques								              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FINR490(void)							  				  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 											                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     �Generico 										              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function fr490Cpos(cCheque)
LOCAL nFirst:=0,lAglut:=.F.
Local aColu	:= {}
Local aTam := TamSX3("E2_FORNECE")
Local aTam2 := TamSX3("EF_TITULO")
Local cCabeca := ""
Local cCabecb := ""

DbSelectArea("SEF")
dbSeek (cFilial+mv_par01+mv_par02+mv_par03+cCheque)
//��������������������������������������������������������������Ŀ
//� Definicao das colunas de impressao                           �
//� aTam[1] = Tamanho do codigo do fornecedor (6 ou 20)          �
//� aTam2[1]= Tamanho do nro de titulo (6 ou 12)                 �
//����������������������������������������������������������������

If aTam[1] > 6
	aColu := {001,025,057,008,012,026,030,052}
	cCabeca	:= "|Fornec                  Nome Fornecedor                 Natureza              |"
	cCabecb	:= "|       Prf Numero        P   Vencto                  Valor do Titulo          |"
ElseIf aTam2[1] > 6
	aColu := {001,011,043,008,012,026,030,052}
	cCabeca	:= "|Fornec    Nome Fornecedor                 Natureza                            |"
	cCabecb	:= "|       Prf Numero        P   Vencto                  Valor do Titulo          |"
Else
	aColu := {001,008,029,040,044,051,053,063}
	//	cCabeca	:= "|Fornec   Nome Fornecedor   Prf Numero P| Natureza   Vencto    Valor do Titulo|"
	cCabeca	:= "|Fornec Nome Fornecedor      Natureza   Pre Numero P Vencto     Valor do Titulo|"
	cCabecb	:= ""
Endif

While !Eof() .And. EF_FILIAL+EF_BANCO=cFilial+mv_par01 .And. ;
	EF_AGENCIA=mv_par02 .And. EF_CONTA=mv_par03 .And. ;
	EF_NUM==cCheque
	
	//���������������������Ŀ
	//�Validacao da carteira�
	//�����������������������
	
	If EF_CART = "R"
		DbSkip()
		Loop
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Verifica se nao � principal o cancelado					 	 �
	//����������������������������������������������������������������
	IF EF_IMPRESS == "C"
		dbSkip()
		Loop
	End
	IF li > 58
		li:=1
		@li,0 PSAY "COPIA DO CHEQUE : " + cCheque + " - Continuacao"
		li++
	EndIF
	IF nFirst == 0
		IF EF_IMPRESS = "A"
			lAglut:=.T.
		EndIF
		IF !lAglut .and. Empty(SEF->EF_TITULO)
			dbSkip()
			Loop
		End
		li++
		@li,0 PSAY "|- Composicao do Cheque "+Replicate("-",55)+"|"
		li++
		@li,0 PSAY cCabeca
		//��������������������������������������������������������������Ŀ
		//� Verifica se sera necess�rio imprimir em duas linhas os deta- �
		//� lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. �
		//����������������������������������������������������������������
		IF aTam[1] > 6 .or. aTam2[1] > 6
			li++
			@li,0 PSAY cCabecb
		Endif
		li++
		@li,0 PSAY Replicate("-",80)
	EndIF
	IF Empty(SEF->EF_TITULO)
		dbSkip()
		Loop
	End
	If aTam[1] == 6 .and. aTam2[1] == 6
		nTam := 20
	Else
		nTam := 30
	Endif
	nFirst++
	li++
	If SEF->EF_TIPO=='NCC'
		dbSelectArea("SE1")
		dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SEF->EF_FORNECE+SEF->EF_LOJA)
		dbSelectArea("SE1")
		@li, 0 PSAY "|"
		@li, aColu[1] PSAY E1_CLIENTE
		@li, aColu[2] PSAY SubStr(SA1->A1_NOME,1,nTam)
		@li, aColu[3] PSAY SE1->E1_NATUREZ
		dbSelectArea("SEF")
		//��������������������������������������������������������������Ŀ
		//� Verifica se sera necess�rio imprimir em duas linhas os deta- �
		//� lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. �
		//����������������������������������������������������������������
		IF aTam[1] > 6 .or. aTam2[1] > 6
			@li,79 PSAY "|"
			li++
			@li, 0 PSAY "|"
		Endif
		@li, aColu[4] PSAY EF_PREFIXO
		@li, aColu[5] PSAY EF_TITULO
		@li, aColu[6] PSAY EF_PARCELA
		@li, aColu[7] PSAY SE1->E1_VENCREA
		@li, aColu[8] PSAY EF_VALOR PicTure tm(EF_VALOR,16)
		@li,79 PSAY "|"
		li++
		@li, 0 PSAY "| Banco : " + SA1->A1_BANCO + " Agencia : " + AllTrim(SA1->A1_AGENCIA) +"-"+ AllTrim(SA1->A1_DIGAGE)+ " CC : " + AllTrim(SA1->A1_NUMCON) +"-"+ AllTrim(SA1->A1_DIGCON)
		@li,79 PSAY "|"
		
	Else
		dbSelectArea("SE2")
		dbSeek(cFilial+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+SEF->EF_FORNECE+SEF->EF_LOJA)
		dbSelectArea("SE2")
		@li, 0 PSAY "|"
		@li, aColu[1] PSAY E2_FORNECE
		@li, aColu[2] PSAY SubStr(SA2->A2_NOME,1,nTam)
		@li, aColu[3] PSAY SE2->E2_NATUREZ
		dbSelectArea("SEF")
		//��������������������������������������������������������������Ŀ
		//� Verifica se sera necess�rio imprimir em duas linhas os deta- �
		//� lhes. Isso ocorre qdo E2_FORNECE ou EF_TITULO forem > 6 pos. �
		//����������������������������������������������������������������
		IF aTam[1] > 6 .or. aTam2[1] > 6
			@li,79 PSAY "|"
			li++
			@li, 0 PSAY "|"
		Endif
		@li, aColu[4] PSAY EF_PREFIXO
		@li, aColu[5] PSAY EF_TITULO
		@li, aColu[6] PSAY EF_PARCELA
		@li, aColu[7] PSAY SE2->E2_VENCREA
		@li, aColu[8] PSAY EF_VALOR PicTure tm(EF_VALOR,16)
		@li,79 PSAY "|"
	li++
		@li, 0 PSAY "| Banco : " + SA2->A2_BANCO + " Agencia : " + AllTrim(SA2->A2_AGENCIA) +"-"+ AllTrim(SA2->A2_DIGAGE)+ " CC : " + AllTrim(SA2->A2_NUMCON) +"-"+ AllTrim(SA2->A2_DIGCON)
		@li,79 PSAY "|"
		
	End
	dbSkip()
EndDO
IF nFirst>0
	li++
	@li, 0 PSAY Replicate("-",80)
End
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa490Cabec� Autor � Alessandro B. Freire  � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de leitura do driver correto de impressao		      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA490cabec(nchar) 									      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nChar . 15-Comprimido , 18-Normal						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     �Finr490													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Fa490cabec(nChar)

LOCAL cTamanho := "P"
LOCAL aDriver := ReadDriver()

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif
if nChar == NIL
	@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
else
	if nChar == 15
		@pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	else
		@pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
	endif
endif
Return(.T.)
