/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr070	³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao               	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr070()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#Include "TTCTBR04.Ch"
#Include "PROTHEUS.Ch"

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "AP5MAIL.CH"



User Function TTCTBR04()

Local aCtbMoeda		:= {}
LOCAL cDesc1 		:= OemToAnsi(STR0001)	//"Este programa ira imprimir o Relatorio para Conferencia"
LOCAL cDesc2 		:= OemToansi(STR0002)   //"de Digitacao - Modelo 1. Ideal para Plano de Contas "
LOCAL cDesc3		:= OemToansi(STR0003)   //"que possuam codigos nao muito extensos.            "
Local cNomeArq
LOCAL wnrel
LOCAL cString		:= "CT2"
Local titulo 		:= OemToAnsi(STR0004)
Local lRet			:= .T.
Local lCusto 		:= .T.
Local lItem 		:= .F.
Local lCV	 		:= .F.
Local Limite		:= 220
private  _VEZ       := 1
PRIVATE _CHISTO 	:= " "
Private _cORIGEM    := " "
Private _F1HIST     := " "
Private _cLote      := " "
Private _cHISE2 	:= " "
Private _cRAZAO     := " "
Private _cUsuario   := " "
Private _cSoli  	:= " "
PRIVATE _cConta     := 1
PRIVATE Tamanho		:="G"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTBG01"
PRIVATE aReturn 	:= { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "TTCTBR04/"+Upper(GetEnvServer())
Private _cTipo    	:= ' '
Private _etiqueta 	:= ' '
Private _vencimento	:= ' '
Private _cLP      	:= ' '
Private _cKey     	:= ' '

Private cUserLg		:= ""
Private cUsuarioI	:= ''
Private cDataI		:= ''
Private _cCampo   	:= {}

li 		:= 80
m_pag	:= 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						 	³
//³ mv_par01				// Data Inicial                  	 	³
//³ mv_par02				// Data Final                         	³
//³ mv_par03				// Lote  Inicial                        ³
//³ mv_par04				// Lote  Final  						³
//³ mv_par05				// Documento Inicial                    ³
//³ mv_par06				// Documento Final			    		³
//³ mv_par07				// Moeda?						     	³
//³ mv_par08				// Sub-Lote Inicial                  	³
//³ mv_par09				// Sub-Lote Final  						³
//³ mv_par10				// Usuario         ?                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg, .F.)

wnrel	:= "TTCTBR04"            //Nome Default do relatorio em Disco
wnrel 	:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par07)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		Set Filter To
		Return
	Endif
Endif
2 := 2

SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR070Imp(@lEnd,wnRel,cString,Titulo,.T.,.F.,.F.,Limite)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR070IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Conferencia Digitacao Modelo 1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR070Imp(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpC3   - Titulo                                           ³±±
±±³          ³ ExpL1   - Define se imprime o centro de custo              ³±±
±±³          ³ ExpL2   - Define se imprime o item                         ³±±
±±³          ³ ExpL3   - Define se imprime a classe de valor              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR070Imp(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV,Limite)

LOCAL CbTxt		:= Space(10)
Local CbCont	:= 0
Local cabec1  	:= ""
Local cabec2  	:= " "

Local aColunas		:= {}
Local cDigVer  		:= GetMv("MV_DIGVER")
Local cLote
Local cSubLote
Local cDoc
Local cMoeda		:= mv_par07
Local cSayItem		:= CtbSayApro("CTD")
Local cSayCC		:= CtbSayApro("CTT")
Local cSayCV		:= CtbSayApro("CTH")
Local cLoteRes
Local cSubRes
Local cDocRes
Local dDataRes
Local dData
Local _cDoc         := Space(9)
Local _cPrefixo     := Space(3)
Local _cCliFor      := Space(6)
Local _cLoja        := Space(4)
Local _cTipo        := Space(3)
Local _Etiqueta     := Space(10)
Local _F1Hist       := Space(35)
Local _cCampo       := Space(15)
Local _cRazao       := Space(40)
Local lPrimPag		:= .T.
Local lQuebraDoc	:= .F.
Local nTotalDeb		:= 0
Local nTotalCrd		:= 0
Local nTotLotDeb	:= 0
Local nTotLotCrd	:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerInf	:= nTotGerDig := 0
Local nDif			:= 0
Local nCol
Local _cCliFor := ""
Local _cLoja   := ""

Cabec1 		:= "LI TP CONTA                                              C CUSTO                                          VALOR DEB        VALOR CRED   HP  HIST                                   ITEM"
//Cabec1 		:= OemToAnsi(STR0008)
//Cabec1 		+= OemToAnsi(Upper(Left(cSayCC + Space(21), 21)))
//Cabec1 		+= OemToAnsi(STR0016)

//0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//LI TP CONTA                                              C CUSTO                                          VALOR DEB        VALOR CRED   HP  HIST
//XXX X XXXXXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   9999999999        9999999999        XX  XXXX...

aColunas 	:= {000, 004, 006, 057, 088, 106, 126, 130, 180 }
//aColunas 	:= {027, 000, 000, 048, 066, 084, 088 }

dbSelectArea("CT2")
dbSetOrder(1)
dbSeek(xFilial()+DTOS(mv_par01)+mv_par03+mv_par08+mv_par05,.T.)

SetRegua(RecCount())

While !Eof() .And. CT2->CT2_FILIAL == xFilial() .And. CT2->CT2_DATA <= mv_par02
	
	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0009)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF
	
	If Ctr070Skip()
		dbSkip()
		Loop
	EndIf
	
	IncRegua()
	
	cLote 		:= CT2->CT2_LOTE
	cSubLote 	:= CT2->CT2_SBLOTE
	cDoc		:= CT2->CT2_DOC
	dData 		:= CT2->CT2_DATA
	cLP         := CT2->CT2_LP
	lFirst		:= .T.
	nTotalDeb 	:= 0
	nTotalCrd 	:= 0
	
	lQuebraDoc 	:= .T.
	While !Eof() .And. CT2->CT2_FILIAL == xFilial() .And. Dtos(CT2->CT2_DATA) == Dtos(dData) .And.;
		CT2->CT2_LOTE == cLote 			        .And.;
		CT2->CT2_SBLOTE == cSubLote 			.And.;
		CT2->CT2_DOC == cDoc
		
		If Ctr070Skip()
			dbSkip()
			Loop
		EndIf
		
		IncRegua()
		
		IF li > 62 .Or. lQuebraDoc
			if _VEZ == 2
				li++
				@ li,00 PSAY Replicate("-",Limite)
				CTBR04_DT(dData,cLote,cDoc,cLP)
				_cConta := 1
				li := li + 12
				Roda(cbcont,cbtxt,"M")
			EndIf
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
			Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
			If lQuebraDoc .Or. lPrimPag
				lPrimPag	:= .F.
			EndIf
			lQuebraDoc := .F.
			_VEZ := 2
		EndIf
		
		If lFirst .or. li > 30
			If li > 30
				li++
				@ li,00 PSAY Replicate("-",Limite)
				li++
				@ li,100 psay "Continua....."
				Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
				Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
			Endif
			@ li,00 PSAY Replicate("-",Limite)
			li++
			@ li,000 PSAY OemToAnsi(STR0012)
			@ li,007 PSAY DTOC(dData)
			@ li,019 PSAY OemToAnsi(STR0013)
			@ li,027 PSAY cLote
			@ li,038 PSAY OemToAnsi(STR0017) //"Sub-Lote"
			@ li,049 PSAY cSubLote
			@ li,058 PSAY OemToAnsi(STR0014)
			@ li,064 PSAY cDoc
			lFirst := .F.
			li ++
			@ li,00 PSAY Replicate("-",Limite)
			li ++
		EndIf
		
		If CT2->CT2_DC == '1' .Or. CT2->CT2_DC =='2'//Se o lancamento e tipo '1' ou '2'
			@ li, aColunas[1] PSAY CT2->CT2_LINHA
			@ li, aColunas[2] PSAY CT2->CT2_DC
			If CT2->CT2_DC == '1'
				@ li, aColunas[3] PSAY AllTrim(CT2->CT2_DEBITO) + " - " + Left(GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+CT2->CT2_DEBITO,1,""), 30)
			ElseIf CT2->CT2_DC == '2'
				@ li, aColunas[3] PSAY AllTrim(CT2->CT2_CREDIT) + " - " + Left(GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+CT2->CT2_CREDIT,1,""), 30)
			Endif
			
			nValor := CT2->CT2_VALOR
			If CT2->CT2_DC == '1'
				@ li,aColunas[4] PSAY AllTrim(CT2->CT2_CCD) + " - " + Left(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+CT2->CT2_CCD,1,""), 30)
				@ li,aColunas[5] PSAY nValor Picture Tm(nValor,17)
				nTotalDeb += nValor
				nTotGerDeb+= nValor
				nTotLotDeb+= nValor
			ElseIf CT2->CT2_DC =='2'
				@ li,aColunas[4] PSAY AllTrim(CT2->CT2_CCC) + " - " + Left(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+CT2->CT2_CCC,1,""), 30)
				@ li,aColunas[6] PSAY nValor Picture Tm(nValor,17)
				nTotalCrd += nValor
				nTotGerCrd+= nValor
				nTotLotCrd+= nValor
			Endif
			@ li, aColunas[7] PSAY CT2->CT2_HP
			@ li, aColunas[8] PSAY CT2->CT2_HIST
			If CT2->CT2_DC == '1'
				@ li, aColunas[9] PSAY  AllTrim(CT2->CT2_ITEMD) + " - " + Left(GetAdvFVal("CTD","CTD_DESC01",xFilial("CTD")+CT2->CT2_ITEMD,1,""), 30)
			ElseIf CT2->CT2_DC == '2'
				@ li, aColunas[9] PSAY  AllTrim(CT2->CT2_ITEMC) + " - " + Left(GetAdvFVal("CTD","CTD_DESC01",xFilial("CTD")+CT2->CT2_ITEMC,1,""), 30)
			End
			If _cCONTA == 1
				_cHISTO  := CT2->CT2_ORIGEM
				_cOrigem := CT2->CT2_ORIGEM
				_cLote   := CT2->CT2_LOTE
				_cLP     := CT2->CT2_LP
				_cKey    := CT2->CT2_KEY
				_cConta := 2
			Endif
		Elseif CT2->CT2_DC == '3' //Se o lancamento e tipo '3', e desdobrado
			For n:=1 to 2
				@ li, aColunas[1] PSAY CT2->CT2_LINHA
				If n == 1
					@ li, aColunas[2] PSAY '1'
				Else
					@ li, aColunas[2] PSAY '2'
				Endif
				If n==1
					@ li, aColunas[3] PSAY AllTrim(CT2->CT2_DEBITO) + " - " + Left(GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+CT2->CT2_DEBITO,1,""), 30)
				Else
					@ li, aColunas[3] PSAY AllTrim(CT2->CT2_CREDIT) + " - " + Left(GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+CT2->CT2_CREDIT,1,""), 30)
				Endif
				
				nValor := CT2->CT2_VALOR
				If n == 1
					@ li,aColunas[4] PSAY AllTrim(CT2->CT2_CCD) + " - " + Left(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+CT2->CT2_CCD,1,""), 30)
					@ li,aColunas[5] PSAY nValor Picture Tm(nValor,17)
					nTotalDeb += nValor
					nTotGerDeb+= nValor
					nTotLotDeb+= nValor
				Else
					@ li,aColunas[4] PSAY AllTrim(CT2->CT2_CCC) + " - " + Left(GetAdvFVal("CTT","CTT_DESC01",xFilial("CTT")+CT2->CT2_CCC,1,""), 30)
					@ li,aColunas[6] PSAY nValor Picture Tm(nValor,17)
					nTotalCrd += nValor
					nTotGerCrd+= nValor
					nTotLotCrd+= nValor
				Endif
				@ li, aColunas[7]	PSAY CT2->CT2_HP
				@ li, aColunas[8] 	PSAY CT2->CT2_HIST
				If n == 1
					@ li, aColunas[9] 	PSAY AllTrim(CT2->CT2_ITEMD) + " - " + Left(GetAdvFVal("CTD","CTD_DESC01",xFilial("CTD")+CT2->CT2_ITEMD,1,""), 30)
				Else
					@ li, aColunas[9] 	PSAY AllTrim(CT2->CT2_ITEMC) + " - " + Left(GetAdvFVal("CTD","CTD_DESC01",xFilial("CTD")+CT2->CT2_ITEMC,1,""), 30)
				End
				If _cCONTA == 1
					_cHISTO 	:= CT2->CT2_ORIGEM
					_cOrigem 	:= CT2->CT2_ORIGEM
					_cLote 		:= CT2->CT2_LOTE
					_cLP     	:= CT2->CT2_LP
					_cKey    	:= CT2->CT2_KEY
					_cConta 	:= 2
				Endif
				If n == 1
					li++
				Endif
			Next
		Endif
		
		// Procura pelo complemento de historico
		cSeq := CT2->CT2_SEQLAN
		nReg := Recno()
		dbSelectArea("CT2")
		dbSetOrder(10)
		If dbSeek(xFilial()+DTOS(dData)+cLote+cSubLote+cDoc+cSeq)
			dbSkip()
			If CT2->CT2_DC == "4"
				While !Eof() .And. CT2->CT2_FILIAL == xFilial() .And.;
					CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
					CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_DC == "4" .And.;
					DTOS(CT2->CT2_DATA) == DTOS(dData)
					li++
					@ li, aColunas[1] PSAY CT2->CT2_LINHA
					@ li, aColunas[2] PSAY CT2->CT2_DC
					@ li, aColunas[8] PSAY CT2->CT2_HIST
					dbSkip()
				EndDo
			EndIf
		Else
			dbGoto(nReg)
			dbSetOrder(1)
			dbSkip()
		EndIf
		
		dbSetOrder(1)
		li++
	Enddo
	
	li++
	@ li,02 PSAY OemToAnsi(STR0018)
	CTC->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+"01"))
	nTotGerInf += CTC->CTC_INF
	nTotGerDig += CTC->CTC_DIG
	@ li, aColunas[5] 	PSAY nTotalDeb Picture Tm(nTotalDeb,17)
	@ li, aColunas[6] 	PSAY nTotalCrd Picture Tm(nTotalCrd,17)
	
	li++
	nTotalDeb := 0
	nTotalCrd := 0
	
	// TOTALIZA O LOTE
	If cLote != CT2->CT2_LOTE 				.Or.;
		cSubLote != CT2->CT2_SBLOTE 			.Or.;
		Dtos(dData) != Dtos(CT2->CT2_DATA)
		li++
		//	@ li,02 PSAY OemToAnsi(STR0020)
		CT6->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+"01"))
		li++
		nTotLotDeb := 0
		nTotLotCrd := 0
	EndIf
	
	// Impressao do Cabecalho
	IF li > 62
		if _VEZ == 2
			li++
			@ li,00 PSAY Replicate("-",Limite)
			CTBR04_DT(dData,cLote,cDoc,cLP)
			_cConta := 1
			li := li + 12
			Roda(cbcont,cbtxt,"M")
		EndIf
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
		Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
		_VEZ:=2
	EndIf
EndDo

If li != 80
	IF li > 62
		if _VEZ == 2
			CTBR04_DT(dData,cLote,cDoc,cLP)
			_cConta := 1
			li := li + 12
			Roda(cbcont,cbtxt,"M")
		EndIf
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
		Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
		_VEZ := 2
	EndIf
	li+=2
	@ li,00 PSAY Replicate("-",Limite)
	li++
	li++
	If _cConta == 2
		CTBR04_DT(dData,cLote,cDoc,cLP)
		li := li + 12
		Roda(cbcont,cbtxt,"M")
		Roda(cbcont,cbtxt,"M")
	Endif
EndIf


If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ctr070Skip³ Autor ³ Pilar S Albaladejo	³ Data ³ 02.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica condicoes para pular os registros			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctr070Skip()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ctr070Skip()

Local lRet := .F.

If '1' <> CT2->CT2_TPSALD
	lRet := .T.
Endif

If (CT2->CT2_LOTE < mv_par03) .Or. (CT2->CT2_LOTE > mv_par04)
	lRet := .T.
Endif

If (CT2->CT2_SBLOTE < mv_par08) .Or. (CT2->CT2_SBLOTE > mv_par09)
	lRet := .T.
Endif

If (CT2->CT2_DOC < mv_par05) .Or. (CT2->CT2_DOC > mv_par06)
	lRet := .T.
Endif

If mv_par10 <> " "
	
	if CT2->CT2_LOTE == '008810' 			 //compras
		_aArea:=GetArea("CT2")
		_cOrigem := CT2->CT2_KEY
		dbSelectArea("SF1")
		dbSetOrder(1)   //filial           // doc            serie            fornece                 loja
		//070000345401  00536004491002162        0001
		If dbSeek(subst(_cORIGEM,1,2)+subst(_CORIGEM,3,9)+subst(_CORIGEM,12,3)+subst(_cORIGEM,15,6)+subst(_cORIGEM,21,4))
			_cCampo		:= "SF1->F1_USERLGI"
			_cTipo      := SF1->F1_TIPO
		Endif
		If !empty(_cCampo)
			cUserLG		:= Embaralha(&_cCampo,1)
			cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
			If alltrim(mv_par10) <> alltrim(cUsuarioI)
				lRet := .T.
			Endif
		Endif
		RestArea(_aArea)
	else
		If Alltrim(mv_par10) $ CT2->CT2_ORIGEM
			//			lRet := .F.
		Else
			lRet := .T.
		Endif
	Endif
Endif
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR04_DT ³ Autor ³ Artur Nucci Ferrari	³ Data ³ 08.08.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Detalhes do lançamento                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR04_DT(dData,cLote,cDoc,cLP)
Local _aAreaDT := GetArea("CT2")

If cLote="008810"
	c_Query := MQ_8810(dData,cLote,cDoc,cLP)
ElseIf cLote="008820"
	//c_Query := MQ_8850(dData,cLote,cDoc,cLP)
	c_Query := MQ_8810(dData,cLote,cDoc,cLP)
ElseIf cLote="008850"
	//c_Query := MQ_8850(dData,cLote,cDoc,cLP)
	c_Query := MQ_8810(dData,cLote,cDoc,cLP)
End
If cLote="008810"
	If Select("QRY")>0
		DbSelectArea("QRY")
		DbCloseArea()
	Endif
	TCQUERY c_Query NEW ALIAS "QRY"
	dbSelectArea("QRY")
	aColRod 	:= {000, 057 ,098, 116 ,170 }
	
	li := li + 1
	@ li,aColRod[1] PSay "Filial...............: " + GetAdvFVal( 'SM0', 'M0_FILIAL' , cEmpAnt + QRY->FILIAL , 1, '' )
	@ li,aColRod[2] PSay "Nota Fiscal..........: " + QRY->NF + "/" + QRY->SERIE + " - " + IIf(QRY->TIPO="N","NFE","Devolução")
	@ li,aColRod[4] PSay "Emissao..............: " + SubStr(QRY->EMISSAO,7,2) + "/" + SubStr(QRY->EMISSAO,5,2) + "/" + SubStr(QRY->EMISSAO,1,4)
	@ li,aColRod[5] PSay "Lançamento...........: " + SubStr(QRY->DTDIGIT,7,2) + "/" + SubStr(QRY->DTDIGIT,5,2) + "/" + SubStr(QRY->DTDIGIT,1,4)
	li := li + 2
	@ li,aColRod[1] PSay "Favorecido...........: " + QRY->CLIFOR + "/" + QRY->LOJA + " - " + QRY->RAZAO
	@ li,aColRod[4] PSay "Usuário Emitente.....: " + SubStr(Embaralha(QRY->URSERLGI,1),1,15)
	@ li,aColRod[5] PSay "No.Etiqueta..........: " + Upper(QRY->CONTROLE)
	li := li + 2
	@ li,aColRod[1] PSay "Histórico Entrada....: " + Upper(QRY->MENNF)
	li := li + 2
	If !Empty(QRY->VENCREA)
		@ li,aColRod[1] PSay "Título...............: " + QRY->PREFIXO + "-" + QRY->NF
		@ li,aColRod[2] PSay "Vencimento...........: " + SubStr(QRY->VENCREA,7,2) + "/" + SubStr(QRY->VENCREA,5,2) + "/" + SubStr(QRY->VENCREA,1,4)
		@ li,aColRod[4] PSay "Valor................: R$ " + Transform(QRY->VALOR,"@E 9,999,999.99")
		@ li,aColRod[5] PSay "Banco................: " + QRY->BANCO
		li := li + 2
		@ li,aColRod[1] PSay "Natureza.............: " + QRY->NATUREZA + "-" + QRY->DESC_NATUREZA
		@ li,aColRod[4] PSay "Cond. Pagamento......: " + QRY->CONDPAG + "-" + QRY->DESC_CONDPAG
		li := li + 2
		@ li,aColRod[1] PSay "Histórico............: " + Upper(QRY->HISTORICO)
		li := li + 2
	Else
		@ li,aColRod[2] PSay "********** NFE SEM GERAÇÃO NO FINANCEIRO **********"
	Endif
End
@ 55,007 psay "________________________"
@ 55,042 psay "________________________"
@ 55,072 psay "________________________"
@ 55,102 psay "________________________"
@ 56,007 psay "        EMITENTE        "
@ 56,042 PSAY "        VISTADO         "
@ 56,072 psay "        APROVADO        "
@ 56,102 psay "      CONTAS A PAGAR    "
RestArea(_aAreaDT)
Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MainQuery ºAutor  ³Artur Nucci Ferrari º Data ³  21/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta a query principal do processamento.                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MQ_8810(dData,cLote,cDoc,cLP)

Local c_EOL := chr(13)
Local cQuery := ''
Local c_EOL	     := CHR(13)+CHR(10)

cQuery := "SELECT DISTINCT " + c_EOL
cQuery += "F1_FILIAL AS FILIAL " + c_EOL
cQuery += ",F1_DOC AS NF " + c_EOL
cQuery += ",F1_SERIE AS SERIE " + c_EOL
cQuery += ",F1_TIPO AS TIPO " + c_EOL
cQuery += ",F1_PREFIXO AS PREFIXO " + c_EOL
cQuery += ",F1_FORNECE AS CLIFOR " + c_EOL
cQuery += ",F1_LOJA AS LOJA " + c_EOL
cQuery += ",A2_NOME AS RAZAO " + c_EOL
cQuery += ",F1_EMISSAO AS EMISSAO " + c_EOL
cQuery += ",F1_DTDIGIT AS DTDIGIT " + c_EOL
cQuery += ",F1_COND AS CONDPAG " + c_EOL
cQuery += ",E4_DESCRI AS DESC_CONDPAG " + c_EOL
cQuery += ",F1_XMENNOT AS MENNF " + c_EOL
cQuery += ",ISNULL(F1_CONTROL,'') AS CONTROLE " + c_EOL
cQuery += ",ISNULL(E2_NATUREZ,'') AS NATUREZA " + c_EOL
cQuery += ",ISNULL(ED_DESCRIC,'') AS DESC_NATUREZA " + c_EOL
cQuery += ",ISNULL(E2_VALOR,0) AS VALOR " + c_EOL
cQuery += ",ISNULL(E2_VENCREA,'') AS VENCREA " + c_EOL
cQuery += ",ISNULL(E2_PORTADO,'') AS BANCO  " + c_EOL
cQuery += ",ISNULL(E2_HIST,'') AS HISTORICO  " + c_EOL
cQuery += ",F1_USERLGI AS URSERLGI " + c_EOL
cQuery += "FROM " + RetSqlName("CT2") + c_EOL
cQuery += "INNER JOIN " + RetSqlName("SF1") + c_EOL
cQuery += "ON F1_FILIAL=SUBSTRING(CT2_KEY,1,2) " + c_EOL
cQuery += "AND F1_DOC=SUBSTRING(CT2_KEY,3,9) " + c_EOL
cQuery += "AND F1_SERIE=SUBSTRING(CT2_KEY,12,3) " + c_EOL
cQuery += "AND F1_FORNECE=SUBSTRING(CT2_KEY,15,6) " + c_EOL
cQuery += "AND F1_LOJA=SUBSTRING(CT2_KEY,21,4) " + c_EOL
cQuery += "AND F1_TIPO NOT IN ('D','B') " + c_EOL
cQuery += "AND " + RetSqlName("SF1") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "INNER JOIN " + RetSqlName("SA2") + c_EOL
cQuery += "ON A2_COD=F1_FORNECE " + c_EOL
cQuery += "AND A2_LOJA=F1_LOJA " + c_EOL
cQuery += "AND " + RetSqlName("SA2") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("SE2") + c_EOL
cQuery += "ON E2_NUM=F1_DOC " + c_EOL
cQuery += "AND E2_PREFIXO=F1_PREFIXO " + c_EOL
cQuery += "AND E2_FORNECE=F1_FORNECE " + c_EOL
cQuery += "AND E2_LOJA=F1_LOJA " + c_EOL
cQuery += "AND E2_EMISSAO=F1_EMISSAO " + c_EOL
cQuery += "AND " + RetSqlName("SE2") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("SED") + c_EOL
cQuery += "ON ED_CODIGO=E2_NATUREZ " + c_EOL
cQuery += "AND " + RetSqlName("SED") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("SE4") + c_EOL
cQuery += "ON E4_CODIGO=F1_COND " + c_EOL
cQuery += "AND " + RetSqlName("SE4") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "WHERE " + RetSqlName("CT2") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "AND CT2_DATA='"+DTOS(dData)+"' " + c_EOL
cQuery += "AND CT2_LOTE='"+cLote+"' " + c_EOL
cQuery += "AND CT2_DOC='"+cDoc+"' " + c_EOL
cQuery += "UNION " + c_EOL
cQuery += "SELECT DISTINCT " + c_EOL
cQuery += "F1_FILIAL AS FILIAL " + c_EOL
cQuery += ",F1_DOC AS NF " + c_EOL
cQuery += ",F1_SERIE AS SERIE " + c_EOL
cQuery += ",F1_TIPO AS TIPO " + c_EOL
cQuery += ",F1_PREFIXO AS PREFIXO " + c_EOL
cQuery += ",F1_FORNECE AS CLIFOR " + c_EOL
cQuery += ",F1_LOJA AS LOJA " + c_EOL
cQuery += ",A1_NOME AS RAZAO " + c_EOL
cQuery += ",F1_EMISSAO AS EMISSAO " + c_EOL
cQuery += ",F1_DTDIGIT AS DTDIGIT " + c_EOL
cQuery += ",F1_COND AS CONDPAG " + c_EOL
cQuery += ",E4_DESCRI AS DESC_CONDPAG " + c_EOL
cQuery += ",F1_XMENNOT AS MENNF " + c_EOL
cQuery += ",ISNULL(F1_CONTROL,'') AS CONTROLE " + c_EOL
cQuery += ",ISNULL(E1_NATUREZ,'') AS NATUREZA " + c_EOL
cQuery += ",ISNULL(ED_DESCRIC,'') AS DESC_NATUREZA " + c_EOL
cQuery += ",ISNULL(E1_VALOR,0) AS VALOR " + c_EOL
cQuery += ",ISNULL(E1_VENCREA,'') AS VENCREA " + c_EOL
cQuery += ",ISNULL(E1_PORTADO,'') AS BANCO  " + c_EOL
cQuery += ",ISNULL(E1_HIST,'') AS HISTORICO  " + c_EOL
cQuery += ",F1_USERLGI AS URSERLGI " + c_EOL
cQuery += "FROM " + RetSqlName("CT2") + c_EOL
cQuery += "INNER JOIN " + RetSqlName("SF1") + c_EOL
cQuery += "ON F1_FILIAL=SUBSTRING(CT2_KEY,1,2) " + c_EOL
cQuery += "AND F1_DOC=SUBSTRING(CT2_KEY,3,9) " + c_EOL
cQuery += "AND F1_SERIE=SUBSTRING(CT2_KEY,12,3) " + c_EOL
cQuery += "AND F1_FORNECE=SUBSTRING(CT2_KEY,15,6) " + c_EOL
cQuery += "AND F1_LOJA=SUBSTRING(CT2_KEY,21,4) " + c_EOL
cQuery += "AND F1_TIPO IN ('D','B') " + c_EOL
cQuery += "AND " + RetSqlName("SF1") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "INNER JOIN " + RetSqlName("SA1") + c_EOL
cQuery += "ON A1_COD=F1_FORNECE " + c_EOL
cQuery += "AND A1_LOJA=F1_LOJA " + c_EOL
cQuery += "AND " + RetSqlName("SA1") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("SE1") + c_EOL
cQuery += "ON E1_NUM=F1_DOC " + c_EOL
cQuery += "AND E1_PREFIXO=F1_PREFIXO " + c_EOL
cQuery += "AND E1_CLIENTE=F1_FORNECE " + c_EOL
cQuery += "AND E1_LOJA=F1_LOJA " + c_EOL
cQuery += "AND E1_EMISSAO=F1_EMISSAO " + c_EOL
cQuery += "AND " + RetSqlName("SE1") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("SED") + c_EOL
cQuery += "ON ED_CODIGO=E1_NATUREZ " + c_EOL
cQuery += "AND " + RetSqlName("SED") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "LEFT JOIN " + RetSqlName("SE4") + c_EOL
cQuery += "ON E4_CODIGO=F1_COND " + c_EOL
cQuery += "AND " + RetSqlName("SE4") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "WHERE " + RetSqlName("CT2") + ".D_E_L_E_T_='' " + c_EOL
cQuery += "AND CT2_DATA='"+DTOS(dData)+"' " + c_EOL
cQuery += "AND CT2_LOTE='"+cLote+"' " + c_EOL
cQuery += "AND CT2_DOC='"+cDoc+"' " + c_EOL

MemoWrite("TTCTBR04.sql",cQuery)

Return cQuery



/*

E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA
E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA


If _cLote = '008850'    //financeiro
If _cLP$("500#501#504#540#542#549")
dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+SubStr(_ckey,3,3)+SubStr(_ckey,6,9)+SubStr(_ckey,15,3)+SubStr(_ckey,18,3)+SubStr(_ckey,21,6)+SubStr(_ckey,27,4))
_cHisto      := SE1->E1_HIST
_Etiqueta   := ""
_Vencimento := DTOC(SE1->E1_VENCREA)
_cCliFor    := SE1->E1_CLIENTE
_cLoja      := SE1->E1_LOJA
_cRazao     := GetAdvFval("SA1","A1_NOME" ,xFilial("SA1")+_cCliFor+_cLoja,1)
Endif
ElseIf _cLP$("508#510#511#512#513#514#549#587")
dbSelectArea("SE2")
dbSetOrder(1)
If dbSeek(xFilial("SE2")+SubStr(_ckey,3,3)+SubStr(_ckey,6,9)+SubStr(_ckey,15,3)+SubStr(_ckey,18,3)+SubStr(_ckey,21,6)+SubStr(_ckey,27,4))
_cHisto     := SE2->E2_HIST
_Etiqueta   := SE2->E2_CONTROL
_Vencimento := DTOC(SE2->E2_VENCREA)
_cCliFor    := SE1->E1_CLIENTE
_cLoja      := SE1->E1_LOJA
_cRazao     := GetAdvFval("SA2","A2_NOME" ,xFilial("SA2")+_cCliFor+_cLoja,1)
Endif
Endif
EndIf
dbselectArea("CT2")
li:= li+4
@ li,002 psay "Usuário Emitente....: " + mv_par10
li := li + 2
@ li,002 psay "Histórico Financeiro: " + _cHisto
li := li + 2
@ li,002 psay "No.Etiqueta.........: " + _Etiqueta
li := li + 2
@ li,002 psay "Vencimento.........:  " + _Vencimento
li := li + 2
@ li,002 psay "Favorecido..........: " + _cCliFor+" Loja: "+_cLoja+" - "+_cRazao
*/
