#Include "gdcr070.Ch"
#Include "PROTHEUS.Ch"

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
User Function TTCTBR02()

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
PRIVATE aReturn 	:= { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "TTCTBR02/"+Upper(GetEnvServer())
Private _cTipo    	:= ' '
Private _etiqueta 	:= ' '
Private _cLP      	:= ' '
Private _cKey     	:= ' '
Private cUserLg		:= ""
Private cUsuarioI	:= ''
Private cDataI		:= ''
Private cCampo   	:= {}
Private cPerg    := "TTCTB02"
ValPerg(cPerg)
Pergunte(cPerg, .F.)

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


wnrel	:= "GDCR070C"            //Nome Default do relatorio em Disco
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

Cabec1 		:= "LI TP CONTA                                              C CUSTO                                          VALOR DEB        VALOR CRED   HP  HIST"
//Cabec1 		:= OemToAnsi(STR0008)
//Cabec1 		+= OemToAnsi(Upper(Left(cSayCC + Space(21), 21)))
//Cabec1 		+= OemToAnsi(STR0016)

//0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//LI TP CONTA                                              C CUSTO                                          VALOR DEB        VALOR CRED   HP  HIST
//XXX X XXXXXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   9999999999        9999999999        XX  XXXX...

aColunas 	:= {000, 004, 006, 057, 098, 116, 136, 140 }
//aColunas 	:= {027, 000, 000, 048, 066, 084, 088 }

dbSelectArea("CT2")
dbSetOrder(1)

dbSeek(xFilial()+DTOS(mv_par01)+mv_par03+mv_par08+mv_par05,.T.)

SetRegua(RecCount())

While !Eof() .And. CT2->CT2_FILIAL == xFilial() 	.And.;
	CT2->CT2_DATA <= mv_par02
	
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
	lFirst		:= .T.
	nTotalDeb 	:= 0
	nTotalCrd 	:= 0
	
	lQuebraDoc 	:= .T.
	While !Eof() .And. CT2->CT2_FILIAL == xFilial() 			.And.;
		Dtos(CT2->CT2_DATA) == Dtos(dData) 	.And.;
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
				If CT2->CT2_LOTE == '008810' 		//Compras
					_cKFilial  := subst(_cKey,1,2)
					_cKDoc     := subst(_cKey,3,6)
					_cKPrefixo := subst(_cKey,9,3)
					_cKFornece := subst(_cKey,12,6)
					_cKLOja    := subst(_cKey,18,2)
				ElseIf CT2->CT2_LOTE == '008850' .AND. CT2->CT2_LP<>'500'	//Financeiro
					If _cLP$('587,593')
						_cKFilial  := subst(_cKey,1,2)
						_cKFornece := subst(_cKey,3,6)
						_cKLOja    := subst(_cKey,9,2)
						_cKPrefixo := subst(_cKey,11,3)
						_cKNum     := subst(_cKey,14,6)
						_cKParcela := subst(_cKey,20,1)
						_cKTipo    := subst(_cKey,21,3)
					Else
						_cKFilial  := subst(_cKey,1,2)
						_cKPrefixo := subst(_cKey,3,3)
						_cKNum     := subst(_cKey,6,6)
						_cKParcela := subst(_cKey,12,1)
						_cKTipo    := subst(_cKey,13,3)
						_cKFornece := subst(_cKey,16,6)
						_cKLOja    := subst(_cKey,22,2)
					End
				ElseIf CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
					_cKFilial  := subst(_cKey,1,2)
					_cKFornece := subst(_cKey,3,6)
					_cKLOja    := subst(_cKey,9,2)
					_cKPrefixo := subst(_cKey,11,3)
					_cKNum     := subst(_cKey,14,6)
					_cKParcela := subst(_cKey,20,1)
					_cKTipo    := subst(_cKey,21,3)
				End
				If CT2->CT2_LOTE  = '008810'		 //compras
					_cArea := GetArea("CT2")
					dbSelectArea("SF1")
					dbSetOrder(1)                 //doc               serie                  fornece                loja
					If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
						cCampo		:= "SF1->F1_USERLGI"
						_cTipo      := SF1->F1_TIPO
						_etiqueta   := SF1->F1_CONTROL
						_F1HIST     := SF1->F1_HIST
						
					Endif
					If !empty(cCampo)
						cUserLG		:= Embaralha(&cCampo,1)
						cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
						dbSelectArea("SA2")
						dbSetOrder(1)
						If dbSeek(xFilial("SA2")+_cKFornece+_cKLoja)
							_cRAZAO := SA2->A2_NOME
						Endif
						@ li,002 psay "Usuario emitente....: "+cUsuarioI
						li := li + 2
						@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+IIF(!Empty(SE2->E2_VENCREA)," Vencimento.....: "+DTOC(SE2->E2_VENCREA),"")
						li := li + 2
						@ li,002 psay "No.etiqueta.........: "+_etiqueta
						li := li + 2
						@ li,002 psay "Historico entrada....: "+_F1HIST
						
					Endif
					restArea(_cArea)
					
				elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_LP<>'500' 	//Financeiro
					
					dbSelectArea("SE2")
					dbSetOrder(6)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE2->E2_HIST
						_cSoli  := SE2->E2_SOLIC
						_etiqueta := SE2->E2_CONTROL
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "No.etiqueta.........: " + _etiqueta
					li := li + 2
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
					
				elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
					
					dbSelectArea("SE1")
					dbSetOrder(2)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE1->E1_HIST
						_cSoli  := SE1->E1_SOLIC
						_etiqueta := SE1->E1_XNACORD
						_vencto := SE1->E1_VENCREA
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "1No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
					li := li + 2
					
					dbSelectArea("SA1")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
						_cRAZAO := SA1->A1_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(_vencto)
					li := li + 2
					
					
					
				Endif
				
				dbselectArea("CT2")
				
				@ 55,007 psay "________________________"
				@ 55,042 psay "________________________"
				@ 55,072 psay "________________________"
				@ 55,102 psay "________________________"
				@ 56,007 psay "        EMITENTE        "
				@ 56,042 PSAY "        VISTADO         "
				@ 56,072 psay "        APROVADO        "
				@ 56,102 psay "      CONTAS A PAGAR    "
				_cConta := 1
				li := li + 12
				roda(cbcont,cbtxt,"M")
			ENDIF
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
			Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
			If lQuebraDoc .Or. lPrimPag
				lPrimPag	:= .F.
			EndIf
			lQuebraDoc := .F.
			_VEZ := 2
		EndIf
		
		If lFirst .or. li > 60
			If li > 60
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
	li:=40
	_VEZ := 2
	// Impressao do Cabecalho
	IF li > 62
		if _VEZ == 2
			li++
			@ li,00 PSAY Replicate("-",Limite)
			If CT2->CT2_LOTE == '008810' 		//Compras
				_cKFilial  := subst(_cKey,1,2)
				_cKDoc     := subst(_cKey,3,6)
				_cKPrefixo := subst(_cKey,9,3)
				_cKFornece := subst(_cKey,12,6)
				_cKLOja    := subst(_cKey,18,2)
			ElseIf CT2->CT2_LOTE == '008850' .and. CT2->CT_LP<>'500'
				If _cLP$('587,593')
					_cKFilial  := subst(_cKey,1,2)
					_cKFornece := subst(_cKey,3,6)
					_cKLOja    := subst(_cKey,9,2)
					_cKPrefixo := subst(_cKey,11,3)
					_cKNum     := subst(_cKey,14,6)
					_cKParcela := subst(_cKey,20,1)
					_cKTipo    := subst(_cKey,21,3)
				Else
					_cKFilial  := subst(_cKey,1,2)
					_cKPrefixo := subst(_cKey,3,3)
					_cKNum     := subst(_cKey,6,6)
					_cKParcela := subst(_cKey,12,1)
					_cKTipo    := subst(_cKey,13,3)
					_cKFornece := subst(_cKey,16,6)
					_cKLOja    := subst(_cKey,22,2)
				End
			End
			If CT2->CT2_LOTE  = '008810'		 //compras
				_cArea := GetArea("CT2")
				dbSelectArea("SF1")
				dbSetOrder(1)                 //doc               serie                  fornece                loja
				If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
					cCampo		:= "SF1->F1_USERLGI"
					_cTipo      := SF1->F1_TIPO
					_etiqueta   := SF1->F1_CONTROL
					_F1HIST     := SF1->F1_HIST
					
				Endif
				If !empty(cCampo)
					cUserLG		:= Embaralha(&cCampo,1)
					cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
					dbSelectArea("SA2")
					dbSetOrder(1)
					If dbSeek(xFilial("SA2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Usuario emitente....: "+cUsuarioI
					li := li + 2
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+IIF(!Empty(SE2->E2_VENCREA)," Vencimento.....: "+DTOC(SE2->E2_VENCREA),"")
					li := li + 2
					@ li,002 psay "No.etiqueta.........: "+_etiqueta
					li := li + 2
					@ li,002 psay "Historico entrada....: "+_F1HIST
					
					
				elseIf   CT2->CT2_LOTE == '008850'  .AND. CT2->CT2_LP<>'500'	//Financeiro
					
					dbSelectArea("SE2")
					dbSetOrder(6)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE2->E2_HIST
						_cSoli  := SE2->E2_SOLIC
						_etiqueta := SE2->E2_CONTROL
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "No.etiqueta.........: " + _etiqueta
					li := li + 2
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
					
				elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
					
					dbSelectArea("SE1")
					dbSetOrder(2)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE1->E1_HIST
						_cSoli  := SE1->E1_SOLIC
						_etiqueta := SE1->E1_XNACORD
						_vencto   := SE1->E1_VENCREA
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "2No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
					li := li + 2
					
					dbSelectArea("SA1")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
						_cRAZAO := SA1->A1_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(_vencto)
					
					
					
				Endif
				restArea(_cArea)
				
				
			Endif
			
			
			dbselectArea("CT2")
			
			@ 55,007 psay "________________________"
			@ 55,042 psay "________________________"
			@ 55,072 psay "________________________"
			@ 55,102 psay "________________________"
			@ 56,007 psay "        EMITENTE        "
			@ 56,042 PSAY "        VISTADO         "
			@ 56,072 psay "        APROVADO        "
			@ 56,102 psay "      CONTAS A PAGAR    "
			_cConta := 1
			li := li + 12
			roda(cbcont,cbtxt,"M")
		ENDIF
		
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
		Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
		_VEZ:=2
	EndIf
EndDo

If li != 80
	IF li > 62
		if _VEZ == 2
			If CT2->CT2_LOTE == '008810' 		//Compras
				_cKFilial  := subst(_cKey,1,2)
				_cKDoc     := subst(_cKey,3,6)
				_cKPrefixo := subst(_cKey,9,3)
				_cKFornece := subst(_cKey,12,6)
				_cKLOja    := subst(_cKey,18,2)
			ElseIf CT2->CT2_LOTE == '008850'  .AND. CT2->CT2_LP<>'500'	//Financeiro
				If _cLP$('587,593')
					_cKFilial  := subst(_cKey,1,2)
					_cKFornece := subst(_cKey,3,6)
					_cKLOja    := subst(_cKey,9,2)
					_cKPrefixo := subst(_cKey,11,3)
					_cKNum     := subst(_cKey,14,6)
					_cKParcela := subst(_cKey,20,1)
					_cKTipo    := subst(_cKey,21,3)
				Else
					_cKFilial  := subst(_cKey,1,2)
					_cKPrefixo := subst(_cKey,3,3)
					_cKNum     := subst(_cKey,6,6)
					_cKParcela := subst(_cKey,12,1)
					_cKTipo    := subst(_cKey,13,3)
					_cKFornece := subst(_cKey,16,6)
					_cKLOja    := subst(_cKey,22,2)
				End
			End
			If CT2->CT2_LOTE  = '008810'		 //compras
				_cArea := GetArea("CT2")
				dbSelectArea("SF1")
				dbSetOrder(1)                 //doc               serie                  fornece                loja
				If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
					cCampo		:= "SF1->F1_USERLGI"
					_cTipo      := SF1->F1_TIPO
					_etiqueta   := SF1->F1_CONTROL
					_F1HIST     := SF1->F1_HIST
					
				Endif
				If !empty(cCampo)
					cUserLG		:= Embaralha(&cCampo,1)
					cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
					dbSelectArea("SA2")
					dbSetOrder(1)
					If dbSeek(xFilial("SA2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Usuario emitente....: "+cUsuarioI
					li := li + 2
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+IIF(!Empty(SE2->E2_VENCREA)," Vencimento.....: "+DTOC(SE2->E2_VENCREA),"")
					li := li + 2
					@ li,002 psay "No.etiqueta.........: "+_etiqueta
					li := li + 2
					@ li,002 psay "Historico entrada....: "+_F1HIST
					
				Endif
				restArea(_cArea)
				
			elseIf   CT2->CT2_LOTE == '008850' 	 .AND. CT2->CT2_LP<>'500'//Financeiro
				
				dbSelectArea("SE2")
				dbSetOrder(6)      //fornece   loja   prefixo    num
				If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
					_cHISE2 := SE2->E2_HIST
					_cSoli  := SE2->E2_SOLIC
					_etiqueta := SE2->E2_CONTROL
				Endif
				li:= li+4
				@ li,002 psay "Usuario emitente....: "+mv_par10
				li := li + 2
				@ li,002 psay "Solicitante.........: "+_cSoli
				li := li + 2
				@ li,002 psay "Historico Financeiro: " + _cHISE2
				li := li + 2
				@ li,002 psay "No.etiqueta.........: " + _etiqueta
				li := li + 2
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				
				If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
					_cRAZAO := SA2->A2_NOME
				Endif
				@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
				
			elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
				
				dbSelectArea("SE1")
				dbSetOrder(2)      //fornece   loja   prefixo    num
				If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
					_cHISE2 := SE1->E1_HIST
					_cSoli  := SE1->E1_SOLIC
					_etiqueta := SE1->E1_XNACORD
					_vencto  := SE1->E1_VENCREA
				Endif
				li:= li+4
				@ li,002 psay "Usuario emitente....: "+mv_par10
				li := li + 2
				@ li,002 psay "Solicitante.........: "+_cSoli
				li := li + 2
				@ li,002 psay "Historico Financeiro: " + _cHISE2
				li := li + 2
				@ li,002 psay "4No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
				li := li + 2
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				
				If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
					_cRAZAO := SA1->A1_NOME
				Endif
				@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(_vencto)
				
				
				
			Endif
			
			
			dbselectArea("CT2")
			
			@ 55,007 psay "________________________"
			@ 55,042 psay "________________________"
			@ 55,072 psay "________________________"
			@ 55,102 psay "________________________"
			@ 56,007 psay "        EMITENTE        "
			@ 56,042 PSAY "        VISTADO         "
			@ 56,072 psay "        APROVADO        "
			@ 56,102 psay "      CONTAS A PAGAR    "
			_cConta := 1
			li := li + 12
			roda(cbcont,cbtxt,"M")
			If _cConta == 2
				_cArea := GetArea("CT2")
				If CT2->CT2_LOTE  = '008810'		 //compras
					_cArea := GetArea("CT2")
					dbSelectArea("SF1")
					dbSetOrder(1)                 //doc               serie                  fornece                loja
					If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
						cCampo		:= "SF1->F1_USERLGI"
						_cTipo      := SF1->F1_TIPO
						_etiqueta   := SF1->F1_CONTROL
						_F1HIST     := SF1->F1_HIST
						
					Endif
					If !empty(cCampo)
						cUserLG		:= Embaralha(&cCampo,1)
						cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
						dbSelectArea("SA2")
						dbSetOrder(1)
						If dbSeek(xFilial("SA2")+_cKFornece+_cKLoja)
							_cRAZAO := SA2->A2_NOME
						Endif
						@ li,002 psay "Usuario emitente....: "+cUsuarioI
						li := li + 2
						@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+IIF(!Empty(SE2->E2_VENCREA)," Vencimento.....: "+DTOC(SE2->E2_VENCREA),"")
						li := li + 2
						@ li,002 psay "No.etiqueta.........: "+_etiqueta
						li := li + 2
						@ li,002 psay "Historico entrada....: "+_F1HIST
						dbSelectArea("SA2")
						dbSetOrder(1)
						
						
					Endif
					restArea(_cArea)
					
				elseIf   CT2->CT2_LOTE == '008850'  .AND. CT2->CT2_LP<>'500'	//Financeiro
					
					dbSelectArea("SE2")
					dbSetOrder(6)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE2->E2_HIST
						_cSoli  := SE2->E2_SOLIC
						_etiqueta := SE2->E2_CONTROL
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "No.etiqueta.........: " + _etiqueta
					li := li + 2
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
					
				elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
					
					dbSelectArea("SE1")
					dbSetOrder(2)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE1->E1_HIST
						_cSoli  := SE1->E1_SOLIC
						_etiqueta := SE1->E1_XNACORD
						_vencto := SE1->E1_VENCREA
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "5No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
					li := li + 2
					
					dbSelectArea("SA1")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
						_cRAZAO := SA1->A1_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(_vencto)
					
					
				elseIf   CT2->CT2_LOTE == '008850' 	 .AND. CT2->CT2_LP<>'500'//Financeiro
					
					dbSelectArea("SE2")
					dbSetOrder(6)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE2->E2_HIST
						_cSoli  := SE2->E2_SOLIC
						_etiqueta := SE2->E2_CONTROL
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "No.etiqueta.........: " + _etiqueta
					li := li + 2
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
					
				elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
					
					dbSelectArea("SE1")
					dbSetOrder(2)      //fornece   loja   prefixo    num
					If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
						_cHISE2 := SE1->E1_HIST
						_cSoli  := SE1->E1_SOLIC
						_etiqueta := SE1->E1_XNACORD
						_vencto := SE1->E1_VENCREA
					Endif
					li:= li+4
					@ li,002 psay "Usuario emitente....: "+mv_par10
					li := li + 2
					@ li,002 psay "Solicitante.........: "+_cSoli
					li := li + 2
					@ li,002 psay "Historico Financeiro: " + _cHISE2
					li := li + 2
					@ li,002 psay "6No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
					li := li + 2
					
					dbSelectArea("SA1")
					dbSetOrder(1)
					
					If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
						_cRAZAO := SA1->A1_NOME
					Endif
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(_vencto)
					
					
				Endif
				
				
				dbselectArea("CT2")
				
				@ 55,007 psay "________________________"
				@ 55,042 psay "________________________"
				@ 55,072 psay "________________________"
				@ 55,102 psay "________________________"
				@ 56,007 psay "        EMITENTE        "
				@ 56,042 PSAY "        VISTADO         "
				@ 56,072 psay "        APROVADO        "
				@ 56,102 psay "      CONTAS A PAGAR    "
				_cConta := 1
				li := li + 12
				roda(cbcont,cbtxt,"M")
			ENDIF
			
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
			Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))
			_VEZ := 2
		EndIf
		li+=2
		@ li,00 PSAY Replicate("-",Limite)
		li++
		li++
		If CT2->CT2_LOTE == '008810' 		//Compras
			_cKFilial  := subst(_cKey,1,2)
			_cKDoc     := subst(_cKey,3,6)
			_cKPrefixo := subst(_cKey,9,3)
			_cKFornece := subst(_cKey,12,6)
			_cKLOja    := subst(_cKey,18,2)
		ElseIf CT2->CT2_LOTE == '008850' 	//Financeiro
			If _cLP$('587,593')
				_cKFilial  := subst(_cKey,1,2)
				_cKFornece := subst(_cKey,3,6)
				_cKLOja    := subst(_cKey,9,2)
				_cKPrefixo := subst(_cKey,11,3)
				_cKNum     := subst(_cKey,14,6)
				_cKParcela := subst(_cKey,20,1)
				_cKTipo    := subst(_cKey,21,3)
			Else
				_cKFilial  := subst(_cKey,1,2)
				_cKPrefixo := subst(_cKey,3,3)
				_cKNum     := subst(_cKey,6,6)
				_cKParcela := subst(_cKey,12,1)
				_cKTipo    := subst(_cKey,13,3)
				_cKFornece := subst(_cKey,16,6)
				_cKLOja    := subst(_cKey,22,2)
			End
		End
		If _cConta == 2
			_cArea := GetArea("CT2")
			If CT2->CT2_LOTE  = '008810'		 //compras
				dbSelectArea("SF1")
				dbSetOrder(1)                 //doc               serie                  fornece                loja
				If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
					cCampo		:= "SF1->F1_USERLGI"
					_cTipo      := SF1->F1_TIPO
					_etiqueta   := SF1->F1_CONTROL
					_F1HIST     := SF1->F1_HIST
					
				Endif
				If !empty(cCampo)
					cUserLG		:= Embaralha(&cCampo,1)
					cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
					dbSelectArea("SA2")
					dbSetOrder(1)
					If dbSeek(xFilial("SA2")+_cKFornece+_cKLoja)
						_cRAZAO := SA2->A2_NOME
					Endif
					@ li,002 psay "Usuario emitente....: "+cUsuarioI
					li := li + 2
					@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+IIF(!Empty(SE2->E2_VENCREA)," Vencimento.....: "+DTOC(SE2->E2_VENCREA),"")
					li := li + 2
					@ li,002 psay "No.etiqueta.........: "+_etiqueta
					li := li + 2
					@ li,002 psay "Historico entrada....: "+_F1HIST
					
				Endif
				restArea(_cArea)
			elseIf   CT2->CT2_LOTE == '008850' 	 .AND. CT2->CT2_LP<>'500' //Financeiro
				
				dbSelectArea("SE2")
				dbSetOrder(6)      //fornece   loja   prefixo    num
				If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
					_cHISE2 := SE2->E2_HIST
					_cSoli  := SE2->E2_SOLIC
					_etiqueta := SE2->E2_CONTROL
				Endif
				li:= li+4
				@ li,002 psay "Usuario emitente....: "+mv_par10
				li := li + 2
				@ li,002 psay "Solicitante.........: "+_cSoli
				li := li + 2
				@ li,002 psay "Historico Financeiro: " + _cHISE2
				li := li + 2
				@ li,002 psay "No.etiqueta.........: " + _etiqueta
				li := li + 2
				
				dbSelectArea("SA2")
				dbSetOrder(1)
				
				If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
					_cRAZAO := SA2->A2_NOME
				Endif
				@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
				
			elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
				
				dbSelectArea("SE1")
				dbSetOrder(2)      //fornece   loja   prefixo    num
				If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
					_cHISE2 := SE1->E1_HIST
					_cSoli  := SE1->E1_SOLIC
					_etiqueta := SE1->E1_XNACORD
					_vencto  := SE1->E1_VENCREA
				Endif
				li:= li+4
				@ li,002 psay "Usuario emitente....: "+mv_par10
				li := li + 2
				@ li,002 psay "Solicitante.........: "+_cSoli
				li := li + 2
				@ li,002 psay "Historico Financeiro: " + _cHISE2
				li := li + 2
				@ li,002 psay "7No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
				li := li + 2
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				
				If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
					_cRAZAO := SA1->A1_NOME
				Endif
				@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(_vencto)
				
				
				
			Endif
			
			dbselectArea("CT2")
			
			@ 55,007 psay "________________________"
			@ 55,042 psay "________________________"
			@ 55,072 psay "________________________"
			@ 55,102 psay "________________________"
			@ 56,007 psay "        EMITENTE        "
			@ 56,042 PSAY "        VISTADO         "
			@ 56,072 psay "        APROVADO        "
			@ 56,102 psay "      CONTAS A PAGAR    "
			li := li + 12
			
			roda(cbcont,cbtxt,"M")
			Set Filter To
		EndIf
	Endif
EndIF
//If CT2->CT2_LOTE == '008810' 		//Compras
//	_cKFilial  := subst(_cKey,1,2)
//	_cKDoc     := subst(_cKey,3,6)
//	_cKPrefixo := subst(_cKey,9,3)
//	_cKFornece := subst(_cKey,12,6)
//	_cKLOja    := subst(_cKey,18,2)
//ElseIf CT2->CT2_LOTE == '008850' .AND. CT2->CT2_LP<>'500'	//Financeiro
//	If _cLP$('587,593')
//		_cKFilial  := subst(_cKey,1,2)
//		_cKFornece := subst(_cKey,3,6)
//		_cKLOja    := subst(_cKey,9,2)
//		_cKPrefixo := subst(_cKey,11,3)
//		_cKNum     := subst(_cKey,14,6)
//		_cKParcela := subst(_cKey,20,1)
//		_cKTipo    := subst(_cKey,21,3)
//	Else
//		_cKFilial  := subst(_cKey,1,2)
//		_cKPrefixo := subst(_cKey,3,3)
//		_cKNum     := subst(_cKey,6,6)
//		_cKParcela := subst(_cKey,12,1)
//		_cKTipo    := subst(_cKey,13,3)
//		_cKFornece := subst(_cKey,16,6)
//		_cKLOja    := subst(_cKey,22,2)
//	End
//ElseIf CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
	_cKFilial  := subst(_cKey,1,2)
	_cKFornece := subst(_cKey,3,6)
	_cKLOja    := subst(_cKey,9,2)
	_cKPrefixo := subst(_cKey,11,3)
	_cKNum     := subst(_cKey,14,6)
	_cKParcela := subst(_cKey,20,1)
	_cKTipo    := subst(_cKey,21,3)
//End

_cArea := GetArea("CT2")
/*
If CT2->CT2_LOTE  = '008810'		 //compras
	dbSelectArea("SF1")
	dbSetOrder(1)                 //doc               serie                  fornece                loja
	If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
		cCampo		:= "SF1->F1_USERLGI"
		_cTipo      := SF1->F1_TIPO
		_etiqueta   := SF1->F1_CONTROL
		_F1HIST     := SF1->F1_HIST
		
	Endif
	If !empty(cCampo)
		cUserLG		:= Embaralha(&cCampo,1)
		cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek(xFilial("SA2")+_cKFornece+_cKLoja)
			_cRAZAO := SA2->A2_NOME
		Endif
		@ li,002 psay "Usuario emitente....: "+cUsuarioI
		li := li + 2
		@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+IIF(!Empty(SE2->E2_VENCREA)," Vencimento.....: "+DTOC(SE2->E2_VENCREA),"")
		li := li + 2
		@ li,002 psay "No.etiqueta.........: "+_etiqueta
		li := li + 2
		@ li,002 psay "Historico entrada....: "+_F1HIST
		
	Endif
	restArea(_cArea)
elseIf   CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' --.AND. CT2->CT2_LP='500'
*/	
	_vencto := ""
	dbSelectArea("SE1")
	dbSetOrder(2)      //fornece   loja   prefixo    num
	If dbSeek(xFilial("SE1")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
		_cHISE2 := SE1->E1_HIST
		_cSoli  := SE1->E1_SOLIC
		_etiqueta := SE1->E1_XNACORD
		_vencto  := DTOC(SE1->E1_VENCREA)
	Endif
	li:= li+4
	@ li,002 psay "Usuario emitente....: "+mv_par10
	li := li + 2
	@ li,002 psay "Solicitante.........: "+_cSoli
	li := li + 2
	@ li,002 psay "Historico Financeiro: " + _cHISE2
	li := li + 2
	@ li,002 psay "7No.Acordo.........: " + _etiqueta + " Lancamento efetuado no Contas a Receber"
	li := li + 2
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	
	If dbSeek(xFilial("SE1")+_cKFornece+_cKLoja)
		_cRAZAO := SA1->A1_NOME
	Endif
	@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + _vencto
		
/*
elseIf   CT2->CT2_LOTE == '008850' 	 .AND. CT2->CT2_LP<>'500' //Financeiro
	
	dbSelectArea("SE2")
	dbSetOrder(6)      //fornece   loja   prefixo    num
	If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
		_cHISE2 := SE2->E2_HIST
		_cSoli  := SE2->E2_SOLIC
		_etiqueta := SE2->E2_CONTROL
	Endif
	li:= li+4
	@ li,002 psay "Usuario emitente....: "+mv_par10
	li := li + 2
	@ li,002 psay "Solicitante.........: "+_cSoli
	li := li + 2
	@ li,002 psay "Historico Financeiro: " + _cHISE2
	li := li + 2
	@ li,002 psay "No.etiqueta.........: " + _etiqueta
	li := li + 2
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	
	If dbSeek(xFilial("SE2")+_cKFornece+_cKLoja)
		_cRAZAO := SA2->A2_NOME
	Endif
	@ li,002 psay "Favorecido..........: "+_cKFornece+" Loja: "+_cKLoja+" - "+_cRAZAO+" - Vencimento.......: " + DTOC(SE2->E2_VENCREA)
	
Endif
*/
dbselectArea("CT2")

@ 55,007 psay "________________________"
@ 55,042 psay "________________________"
@ 55,072 psay "________________________"
@ 55,102 psay "________________________"
@ 56,007 psay "        EMITENTE        "
@ 56,042 PSAY "        VISTADO         "
@ 56,072 psay "        APROVADO        "
@ 56,102 psay "      CONTAS A PAGAR    "
li := li + 12

roda(cbcont,cbtxt,"M")


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

If CT2->CT2_LOTE == '008810' 		//Compras
	_cKFilial  := subst(_cKey,1,2)
	_cKDoc     := subst(_cKey,3,6)
	_cKPrefixo := subst(_cKey,9,3)
	_cKFornece := subst(_cKey,12,6)
	_cKLOja    := subst(_cKey,18,2)
ElseIf CT2->CT2_LOTE == '008850' 	//Financeiro
	If _cLP$('587,593')
		_cKPrefixo := subst(_cKey,1,3)
		_cKNum     := subst(_cKey,3,6)
		_cKParcela := subst(_cKey,9,1)
		_cKTipo    := subst(_cKey,10,3)
		_cKFornece := subst(_cKey,13,6)
		_cKLOja    := subst(_cKey,19,2)
	Else
		_cKFornece := subst(_cKey,1,6)
		_cKLOja    := subst(_cKey,6,2)
		_cKPrefixo := subst(_cKey,11,3)
		_cKNum     := subst(_cKey,14,6)
		_cKParcela := subst(_cKey,20,1)
		_cKTipo    := subst(_cKey,21,3)
	End
ElseIf CT2->CT2_LOTE == '008850' .AND. CT2->CT2_SBLOTE='040' .AND. CT2->CT2_LP='500'
	_cKFilial  := subst(_cKey,1,2)
	_cKFornece := subst(_cKey,3,6)
	_cKLOja    := subst(_cKey,9,2)
	_cKPrefixo := subst(_cKey,11,3)
	_cKNum     := subst(_cKey,14,6)
	_cKParcela := subst(_cKey,20,1)
	_cKTipo    := subst(_cKey,21,3)
	
End

//If mv_par10 <> " "
//	If CT2->CT2_LOTE = '008810'		 //compras
//		_cArea := GetArea("CT2")
///		dbSelectArea("SF1")//
//		dbSetOrder(1)                 //doc               serie                  fornece                loja
//		If dbSeek(_cKFilial+_cKDoc+_cKPrefixo+_cKFornece+_cKLoja)
//			cCampo		:= "SF1->F1_USERLGI"
//			_cTipo      := SF1->F1_TIPO
//			_etiqueta   := SF1->F1_CONTROL
//			_F1HIST     := SF1->F1_HIST
//		Endif
//
//		If !empty(cCampo)
//			cUserLG		:= Embaralha(&cCampo,1)
//			cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
//			If alltrim(mv_par10) <> alltrim(cUsuarioI)
//				lRet := .T.
//			Endif
//		Endif

//		restArea(_cArea)
//	else
//	If mv_par10 $ CT2->CT2_ORIGEM
//		//			lRet := .F.
//	Else
//		lRet := .T.
//	Endif
//	Endif

//else    //financeiro
//	dbSelectArea("SE2")
//	dbSetOrder(6)      //fornece   loja   prefixo    num
//	If dbSeek(xFilial("SE2")+_cKFornece+_ckLoja+_cKPrefixo+_cKNum)
//		_cHISE2 := SE2->E2_HIST
//		_cSoli  := SE2->E2_SOLIC
////		_etiqueta := SE2->E2_CONTROL//
//	Endif
//Endif



Return lRet

/*
If mv_par10 <> " "

if CT2->CT2_LOTE == '008810' 			 //compras
_aArea:=GetArea("CT2")
_cOrigem := CT2->CT2_ORIGEM
dbSelectArea("SF1")
dbSetOrder(1)   //filial           // doc            serie            fornece                 loja
If dbSeek(subst(_cORIGEM,19,2)+subst(_CORIGEM,1,6)+subst(_CORIGEM,7,3)+subst(_cORIGEM,10,6)+subst(_cORIGEM,16,2))
cCampo		:= "SF1->F1_USERLGI"
_cTipo      := SF1->F1_TIPO
Endif
If !empty(cCampo)
cUserLG		:= Embaralha(&cCampo,1)
cUsuarioI	:= If (!Empty(cUserLg),Subs(cUserLg,1,15),"")
If alltrim(mv_par10) <> alltrim(cUsuarioI)
lRet := .T.
Endif
Endif
RestArea(_aArea)
else
If mv_par10 $ CT2->CT2_ORIGEM
//			lRet := .F.
Else
lRet := .T.
Endif
Endif
Endif
*/   

Static Function ValPerg(cPerg)
PutSx1(cPerg, '01', 'Data Inicial       ?','' ,'' , 'mv_ch1', 'D', 08, 0, 0, 'G', '', '','','','mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '02', 'Data Final         ?','' ,'' , 'mv_ch2', 'D', 08, 0, 0, 'G', '', '','','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '03', 'Lote Inicial       ?','' ,'' , 'mv_ch3', 'C', 06, 0, 0, 'G', '', '','','','mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '04', 'Lote Final         ?','' ,'' , 'mv_ch4', 'C', 06, 0, 0, 'G', '', '','','','mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '05', 'Documento Inicial  ?','' ,'' , 'mv_ch5', 'C', 06, 0, 0, 'G', '', '','','','mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '06', 'Documento Final    ?','' ,'' , 'mv_ch6', 'C', 06, 0, 0, 'G', '', '','','','mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '07', 'Moeda              ?','' ,'' , 'mv_ch7', 'C', 01, 0, 0, 'G', '', '','','','mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '08', 'Sub-Lote Inicial   ?','' ,'' , 'mv_ch8', 'C', 03, 0, 0, 'G', '', '','','','mv_par08',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '09', 'Sub-Lote Final     ?','' ,'' , 'mv_ch9', 'C', 03, 0, 0, 'G', '', '','','','mv_par09',,,'','','','','','','','','','','','','','')
PutSx1(cPerg, '10', 'Usuário            ?','' ,'' , 'mv_cha', 'C', 15, 0, 0, 'G', '', '','','','mv_par10',,,'','','','','','','','','','','','','','')
Return
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
