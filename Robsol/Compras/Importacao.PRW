#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

// Ponto de Entrada utilizado para implementar funcionalidades na importação de PC no Documento de Entrada
// Inclusão de Adição e Sequencial do PC no DE.
User Function MT103IP2()

	Local nLinha:= PARAMIXB[1]
	Local nPosAd     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_X_AD" })
	Local nPosSq     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_X_SEQAD" })

	If SC7->C7_X_ADIC > 0
		aCols[nLinha,nPosAd] := SC7->C7_X_ADIC
	EndIF

	If SC7->C7_X_SEQ > 0
		aCols[nLinha,nPosSq] := SC7->C7_X_SEQ
	EndIf

Return Nil

// Ponto de entrada na gravação da nota fiscal de entrada
User Function SF1100I()

	// Local aBkArea := GetArea()
	// Local nRecnoSE2
	Private aHeaderBk := aClone(aHeader)
	Private aColsBk   := aClone(aCols)
	Private nBk       := n
	Private cObs      := Space(50)
	Private cObs1     := Space(50)
	Private cNTrans   := Space(40)
	Private cCTrans   := PadR('6Q',(TamSX3("F1_TRANSP")[1]))  //Space(6)
	Private cTPFrete  := "CIF"
	Private nQuant    := 0
	Private cEspecie  := "CONTAINER"
	Private nPesoB    := 0
	Private nPesoL    := 0
	Private c_Marca   := Space(10)  //F1__MARCA  = Marca
	Private c_Num     := Space(10)  //F1__NMRCAO = Numeracao
	Private cNat      := Space(10)
	Private nTotSE2   := 0
	Private nDI       := Space(10)
	Private dDI       := CTOD('//')
	Private xLocDesemb:= PadR('SANTOS',(TamSX3("F1_X_LOCDES")[1])) 	//Space(60)
	Private UFDesemb  := PadR('SP',(TamSX3("F1_X_UFDES")[1]))		//Space(02)
	Private dDesemb   := CTOD('//')
	Private n_AliqCOF := 8.60
	Private n_AliqPIS := 1.65
	//RODRIGO BARRETO 19/12/2022
	Private n_VlCOF := 0.00
	Private n_VlPIS := 0.00
	Private n_SisCo := 0.00 //taxa siscomex
	Private cNrRef := SPACE(40)
	Private cNbr := SPACE(40)

	Private n_VlTot	  := 0.00
	Private aAdicao   := {}
	Private aHeaderAdd:= {}
	Private aColsAdd  := {}
	Private aSize     := MSAdvSize()

	aTPFrete :={"CIF","FOB"}

	// Tratamento da observação da nota fiscal de entrada
	If cFormul == "S" // Formulário próprio -> solicita observação
		//If ( ( (SF1->F1_TIPO == 'N') .OR. (SF1->F1_TIPO == 'C') ) .AND. (SF1->F1_EST == 'EX') ) //Documento de Importacao, requer preenchimento das adicoes
		If SF1->F1_EST == 'EX'

			AddAdicao()
			HeadAdd()

			@aSize[1],aSize[2] TO ((aSize[6]/2)+50),aSize[5] DIALOG oDlgObs TITLE OemToAnsi("Dados Adicionais da NF de Entrada: " + SF1->F1_DOC + " - " + SF1->F1_SERIE)

			oMulti2:=MsNewGetDados():New(002,(aSize[3]/2),(aSize[4]/2)-5,aSize[3]-5,GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue()", , "",,,,,,,oDlgObs,aHeaderAdd,aColsAdd)
			oMulti2:lNewLine := .T.

			ColAdd()

			//@127,230 BMPBUTTON TYPE 1 ACTION (ActFunc(1),lRet := .T.)
			@151,230 BMPBUTTON TYPE 1 ACTION (ActFunc(1),lRet := .T.)
			/*Rodrigo
		Else
			@000,000 TO 350,540 DIALOG oDlgObs TITLE OemToAnsi("Dados Adicionais da NF de Entrada: " + SF1->F1_DOC + " - " + SF1->F1_SERIE)
			//@000,000 TO 300,540 DIALOG oDlgObs TITLE OemToAnsi("Dados Adicionais da NF de Entrada: " + SF1->F1_DOC + " - " + SF1->F1_SERIE)
			//@002,002 TO 147,270
			@002,002 TO 174,270

			@151,230 BMPBUTTON TYPE 1 ACTION GravaObs()

		EndIf
			*/
			@007,004 SAY "Tranportadora.:"
			@006,047 GET cCTrans F3 "SA4" Valid VldTransp(cCTrans) object oTransp
			@006,092 GET cNTrans When .F. Size 148,50 object oNomeTra
			@019,004 SAY "Frete por Conta.:"
			@018,047 ComboBox cTPFrete                Items aTPFrete  SIZE 25,50  object oTPFrete
			@019,079 SAY "Quantidade.:"
			@018,122 GET nQuant  Picture "@e 99999" SIZE 40,50
			@031,004 SAY "Especie.:"
			@030,047 GET cEspecie SIZE 100,50
			@043,004 SAY "Peso Bruto.:"
			@042,047 GET nPesoB  Picture "@e 999999.999" SIZE 40,50
			@043,106 SAY "Peso Liquido.:"
			@042,145 GET nPesoL  Picture "@e 999999.999" SIZE 40,50
			@055,004 SAY "Marca:"
			@054,047 GET c_Marca SIZE 40, 50
			@055,106 SAY "Numeração:"
			@054,145 GET c_Num   SIZE 40, 50
			@067,004 SAY "Observacoes.:"
			@066,047 GET cObs SIZE 200,50
			@078,047 GET cObs1 SIZE 200,50
			@091,004 SAY "DI.:"
			@090,047 GET nDI SIZE 40,50
			@091,106 SAY "Data DI.:"
			@090,145 GET dDI SIZE 40,50
			@103,004 SAY "Estado Desemb.:"
			@102,047 GET UFDesemb SIZE 40,50
			@103,106 SAY "Local Desemb.:"
			@102,145 GET xLocDesemb SIZE 40,50
			@115,004 SAY "Data Desemb.:"
			@114,047 GET dDesemb SIZE 40,50
			//RODRIGO BARRETO 19/12/2022
			//@115,106 SAY "Aliq. COF:"
			//@114,145 GET n_AliqCOF  Picture "@e 999999.999" SIZE 40,50
			//@127,004 SAY "Aliq. PIS:"
			//@126,047 GET n_AliqPIS  Picture "@e 999999.999" SIZE 40,50
			@115,106 SAY "Valor COF:"
			@114,145 GET n_VlCOF  Picture "@e 999999.999" SIZE 40,50
			@127,004 SAY "Valor PIS:"
			@126,047 GET n_VlPIS  Picture "@e 999999.999" SIZE 40,50

			@127,106 SAY "Vl.Total:"
			@126,145 GET n_VlTot  Picture "@e 999,999,999.99" SIZE 80,50

			//RODRIGO BARRETO 19/12/2022
			@139,004 SAY "TX Siscomex:"
			@138,047 GET n_SisCo  Picture "@e 999999.999" SIZE 40,50
			@139,106 SAY "Nr/REF:"
			@138,145 GET cNrRef   SIZE 100,50
			@151,004 SAY "BL NR:"
			@150,047 GET cNbr  SIZE 100,50


			ACTIVATE DIALOG oDlgObs CENTERED
		EndIf
	EndIf

Return

//Rotina para montar o vetor aHeader
Static Function HeadAdd()

	AADD(aHeaderAdd,{ "Adicao"          , "XX_ADICAO"  , "@!"                 , 03, 0, ".F.",".F.", "C", "", } )
	AADD(aHeaderAdd,{ "Base PIS/COF"    , "XX_BASEPIS" , "@E 999,999,999.99"  , 12, 2, ".T.",".T.", "N", "", } )
	AADD(aHeaderAdd,{ "Valor PIS"       , "XX_VALPIS"  , "@E 999,999,999.99"  , 12, 2, ".T.",".T.", "N", "", } )
	AADD(aHeaderAdd,{ "Valor COF"       , "XX_VALCOF"  , "@E 999,999,999.99"  , 12, 2, ".T.",".T.", "N", "", } )
	AADD(aHeaderAdd,{ "Valor ADU"       , "XX_VALADU"  , "@E 999,999,999.99"  , 12, 2, ".T.",".T.", "N", "", } )
	AADD(aHeaderAdd,{ "Valor II"        , "XX_VALIPI"  , "@E 999,999,999.99"  , 12, 2, ".T.",".T.", "N", "", } )

Return

// Rotina para montar o vetor aCOLS
Static Function ColAdd()

	Local aArea := GetArea()
	Local nAux    := 0

	aAdicao := ASort(aAdicao,,,{|x,y| x<y})

	aColsAdd:= {}

	For nAux := 1 To Len(aAdicao)
		AADD(aColsAdd, {StrZero(aAdicao[nAux],3),0,0,0,0,0, .F.})
	Next nAux

	oMulti2:SetArray(aColsAdd)
	oMulti2:oBrowse:Refresh()

	Restarea( aArea )

Return

//Rotina responsável por preencher array com adi??es
Static Function AddAdicao()

	Local aArea   := GetArea()
	Local nPosAd  :=  aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_X_AD" })
	Local nAux    := 0

	AAdd(aAdicao,aCols[1,nPosAd])

	For nAux := 1 To Len(aCols)
		If( ( AScan(aAdicao,{|x| x==aCols[nAux,nPosAd]}) ) == 0 ) //Inclusão de nova adição
			AAdd(aAdicao,aCols[nAux,nPosAd])
		EndIf
	Next nAux

	RestArea(aArea)

Return


//Rotina responsável por preencher array com informações para geração de complemento,
//por incluir os complementos na tabela CD5.
Static Function GeraComple()

	Local aArea      := GetArea()
	Local nVlTotal   := 0
	Local nPos       := 0
	Local nBasePISCO := 0
	Local nValPIS    := 0
	Local nAux       := 0
	Local nValCOF    := 0
	Local nValADU    := 0
	Local nValII     := 0
	Local nValTOT	 := 0
	Local aDados     := {}
	Local nPosProd   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD" })
	Local nPosTotal  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_TOTAL" })
	Local nPosAd     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_X_AD" })//GDFieldPos(SD1->D1_X_AD)
	Local nPosSq     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_X_SEQAD" })//GDFieldPos(SD1->D1_X_SEQAD)
	Local nPosIt     := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ITEM" })//GDFieldPos(SD1->D1_ITEM)
	Local aTot                           := {}
	Local nPosic

	// Local nBSPIS     := 0 //Base PIS, Base COFINS tamb?m
	// Local nVLPIS     := 0 //Valor PIS
	// Local nVLCOF     := 0 //Valor COFINS
	// Local nBCIMP     := 0 //Val ADU, DSPAD tamb?m
	// Local nVLRII     := 0 //Val II
	// Local AAREASD1
	Private xTICMS	:=0

	ProcRegua(Len(aCols))

	For nAux := 1 To Len(aCols)
		nPos    := ( AScan(oMulti2:aCols,{|x| AllTrim(x[1])==StrZero(aCols[nAux,nPosAd],3)}) )

		//Valores contidos no array de adicao, utilizados no rateio.
		If (nPos > 0)

			nBasePISCO := oMulti2:aCols[nPos,2]
			nValPIS    := oMulti2:aCols[nPos,3]
			nValCOF    := oMulti2:aCols[nPos,4]
			nValADU    := oMulti2:aCols[nPos,5]
			nValII     := oMulti2:aCols[nPos,6]
			nValTOT	   := oMulti2:aCols[nPos,7]

		EndIf

		nVlTotal := (nValADU+nValII)

		nFatRat := Round((aCols[nAux,nPosTotal]/nVlTotal),9)

		AAdd(aDados,{SF1->F1_DOC         ,; //01 Num Documento
			SF1->F1_SERIE                ,; //02 Serie
			SF1->F1_ESPECIE              ,; //03 Especie
			SF1->F1_FORNECE              ,; //04 Fornecedor
			SF1->F1_LOJA                 ,; //05 Loja
			"0"                          ,; //06 Tipo Doc Imp
			SF1->F1_DOC                  ,; //07 Num Doc Imp
			Round((nFatRat*nBasePISCO),2),; //08 Base PIS
			n_AliqPIS                    ,; //09 Aliquota PIS
			Round((nFatRat*nValPIS),2)   ,; //10 Val PIS
			Round((nFatRat*nBasePISCO),2),; //11 Base COF
			n_AliqCOF                    ,; //12 Aliquota COF
			Round((nFatRat*nValCOF),2)   ,; //13 Val COF
			Space(20)                    ,; //14 Ato Consessorio
			SF1->F1_EMISSAO              ,; //15 Data Pgto PIS
			SF1->F1_EMISSAO              ,; //16 Data Pgto COF
			'0'                    		 ,; //17 Local Exec Serv
			SF1->F1_X_DI                 ,; //18 Num DI
			SF1->F1_X_DTDI               ,; //19 Dt DI
			SF1->F1_X_LOCDES             ,; //20 Local Desembara?o
			SF1->F1_X_UFDES              ,; //21 UF Desembara?o
			SF1->F1_X_DTDES              ,; //22 Data Desembara?o
			SF1->F1_FORNECE              ,; //23 Exportador
			AllTrim(STR(aCols[nAux,nPosAd])),; //24 Adicao
			AllTrim(aCols[nAux,1]),; // Rodrigo Barreto AllTrim(Str(aCols[nAux,nPosSq])),; //25 Sequencial
			SF1->F1_FORNECE              ,; //26 Cod Fabricante
			Round((nFatRat*nValADU),2)   ,; //27 Val Desc
			Round((nFatRat*nValADU),2)   ,; //28 Val BC Imp
			Round((nFatRat*nValADU),2)   ,; //29 Val ADU
			Round((nFatRat*nValII),2)    ,; //30 Val II
			0                            ,; //31 Val IOF
			aCols[nAux,nPosIt]           ,; //32 Item
			aCols[nAux,nPosProd]         ,; //33 Produto
			'1'         				 ,; //34 Via Transp
			'1'         				 ; //35 Forma Impoortacao
			})

		// --- Array utilizado na apuração da difença entre os valores calculados e informados  --- //
		// --- utilizado para ajustes dos centavos no arredondamento                                                                                                --- //
		nPosic := aScan(aTot, {|x| x[1]==AllTrim(STR(aCols[nAux,nPosAd])) })
		If nPosic <= 0
			aadd(aTot, {AllTrim(STR(aCols[nAux,nPosAd]))            ,;  //  1- Adição
				nBasePISCO                                              ,;  //  2- Valor Base PIS/COFINS
				nValPIS                                                 ,;  //  3- Valor PIS
				nValCOF                                                 ,;  //  4- Valor COFINS
				nValADU                                                 ,;  //  5- Valor ADU
				nValII                                                  ,;  //  6- Valor II
				Round((nFatRat*nBasePISCO),2)                           ,;  //  7- Total Base PIS/COFINS
				Round((nFatRat*nValPIS),2)                              ,;  //  8- Total PIS
				Round((nFatRat*nValCOF),2)                              ,;  //  9- Total COFINS
				Round((nFatRat*nValADU),2)                              ,;  // 10- Total ADU
				Round((nFatRat*nValII),2)                               ,;  // 11- Total II
				})
		Else
			aTot[nPosic,07] += Round((nFatRat*nBasePISCO),2)
			aTot[nPosic,08] += Round((nFatRat*nValPIS),2)
			aTot[nPosic,09] += Round((nFatRat*nValCOF),2)
			aTot[nPosic,10] += Round((nFatRat*nValADU),2)
			aTot[nPosic,11] += Round((nFatRat*nValII),2)
		EndIf

	Next nAux

	// --- Ajuste de centavos em função do arredondamento nos cálculos --- //
	For nAux := 1 To Len(aTot)
		nPosic := aScan(aDados, {|x| x[24]==aTot[nAux,1] })
		If nPosic > 0
			aDados[nPosic,08] := aDados[nPosic,08] + ( aTot[nAux,2] - aTot[nAux,07] )       // Base PIS
			aDados[nPosic,11] := aDados[nPosic,11] + ( aTot[nAux,2] - aTot[nAux,07] )       // Base COFINS
			aDados[nPosic,10] := aDados[nPosic,10] + ( aTot[nAux,3] - aTot[nAux,08] )       // Valor PIS
			aDados[nPosic,13] := aDados[nPosic,13] + ( aTot[nAux,4] - aTot[nAux,09] )       // Valor COFINS
			aDados[nPosic,29] := aDados[nPosic,29] + ( aTot[nAux,5] - aTot[nAux,10] )       // Valor ADU
			aDados[nPosic,30] := aDados[nPosic,30] + ( aTot[nAux,6] - aTot[nAux,11] )       // Valor II
			aDados[nPosic,27] := aDados[nPosic,27] + ( aTot[nAux,5] - aTot[nAux,10] )       // Valor Desc
			aDados[nPosic,28] := aDados[nPosic,28] + ( aTot[nAux,5] - aTot[nAux,10] )       // Valor BC Imp
		EndIf
	Next nAux

	DbSelectArea('CD5')
	DbSetOrder(4) //CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA+CD5_ITEM

	For nAux := 1 To Len(aDados)

		IncProc()

		If (CD5->(DbSeek(xFilial('CD5')+PadL(aDados[nAux,1],9)+PadL(aDados[nAux,2],3)+PadL(aDados[nAux,4],6)+PadL(aDados[nAux,5],2)+PadL(aDados[nAux,32],4))) )
			CD5->( RecLock("CD5",.F.) )
			CD5->( dbDelete() )
			CD5->( MsUnlock() )
		EndIf

		RecLock('CD5',.T.)
		Replace CD5_FILIAL With xFilial('CD5')
		Replace CD5_DOC    With aDados[nAux,1]
		Replace CD5_SERIE  With aDados[nAux,2]
		Replace CD5_ESPEC  With aDados[nAux,3]
		Replace CD5_FORNEC With aDados[nAux,4]
		Replace CD5_LOJA   With aDados[nAux,5]
		Replace CD5_TPIMP  With aDados[nAux,6]
		Replace CD5_DOCIMP With aDados[nAux,7]
		Replace CD5_BSPIS  With aDados[nAux,8]
		Replace CD5_ALPIS  With aDados[nAux,9]
		Replace CD5_VLPIS  With aDados[nAux,10]
		Replace CD5_BSCOF  With aDados[nAux,11]
		Replace CD5_ALCOF  With aDados[nAux,12]
		Replace CD5_VLCOF  With aDados[nAux,13]
		Replace CD5_ACDRAW With aDados[nAux,14]
		Replace CD5_LOCAL  With aDados[nAux,17]
		Replace CD5_NDI    With aDados[nAux,18]
		Replace CD5_DTDI   With aDados[nAux,19]
		Replace CD5_LOCDES With aDados[nAux,20]
		Replace CD5_UFDES  With aDados[nAux,21]
		Replace CD5_DTDES  With aDados[nAux,22]
		Replace CD5_CODEXP With aDados[nAux,23]
		Replace CD5_NADIC  With aDados[nAux,24]
		Replace CD5_SQADIC With SUBSTR(aDados[nAux,25],2,3)//aDados[nAux,25]
		Replace CD5_CODFAB With aDados[nAux,26]
		Replace CD5_BCIMP  With aDados[nAux,28]
		Replace CD5_DSPAD  With aDados[nAux,29]
		Replace CD5_VLRII  With aDados[nAux,30]
		Replace CD5_VLRIOF With aDados[nAux,31]
		Replace CD5_ITEM   With aDados[nAux,32]
		Replace CD5_VTRANS With aDados[nAux,34]
		Replace CD5_INTERM With aDados[nAux,35]

		MsUnlock()

		//Incluido esse código para gravar o valor do campo CD5_VLRII no campo D1_II, para corrigir valor na tag <vii> do xml
		AREASD1 := GetArea('SD1')

		dbSelectArea('SD1')
		dbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

		If dbSeek (xFilial('SD1') + CD5->CD5_DOC + CD5->CD5_SERIE + CD5->CD5_FORNEC + CD5->CD5_LOJA + aDados[nAux, 33] + CD5->CD5_ITEM)
			RecLock('SD1',.F.)
			Replace SD1->D1_II WITH CD5->CD5_VLRII
			Replace SD1->D1_VALICM WITH ROUND(SD1->D1_BASEICM * SD1->D1_PICM,2) / 100
			//Rodrigo Barreto da Silva
			Replace SD1->D1_X_SEQAD WITH VAL(CD5->CD5_SQADIC)
			MsUnlock()
		Else
			ALERT('Atenção! Não foi encontrado o Item: '+ CD5->CD5_ITEM + ' da Nota: ' + CD5->CD5_DOCIMP + ' !')
		Endif

		restArea(AREASD1)

		dbSelectArea('CD5')

	Next nAux

	CD5->(DbCloseArea())

	RestArea(aArea)

Return

//Chamada das rotinas de gravação de Observaçães na SF1 e complementos na CD5, quando for DI.
Static Function ActFunc(cSituacao)

	Local aArea := GetArea()

	If n_VlTot==0
		cSituacao:=""
		MsgInfo("Valor total da nota fiscal não informado!")
		Return
	EndIf

	GravaObs()
	RestArea(aArea)

	aArea := GetArea()
	Processa( {|| GeraComple()},"Gerando Complementos DI .......")
	RestArea(aArea)

Return

//Grava observação
Static Function GravaObs()

	Local xVlSE2:=0

	RecLock("SF1", .F.)
	Replace F1_X_TRANS  	With cCTrans
	Replace F1_TRANSP		With cCTrans
	Replace F1_X_TIPO   	With cTPFrete
	Replace F1_X_QTD    	With nQuant
	Replace F1_VOLUME1		With nQuant
	Replace F1_X_ESPEC  	With cEspecie
	Replace F1_ESPECI1  	With cEspecie
	Replace F1_X_PESOB  	With nPesoB
	Replace F1_PBRUTO  		With nPesoB
	Replace F1_X_PESOL  	With nPesoL
	Replace F1_PLIQUI  		With nPesoL
	Replace F1_X_OBS    	With cObs
	Replace F1_X_OBS1   	With cObs1
	Replace F1_X_DI     	With nDI
	Replace F1_X_DTDI   	With dDI
	Replace F1_X_LOCDE		With xLocDesemb
	Replace F1_X_UFDES		With UFDesemb
	Replace F1_X_DTDES		With dDesemb
	Replace F1_X_MARCA		With c_Marca
	Replace F1_X_NMRCAO		With c_Num
	Replace F1_X_TIMPO		With n_VlTot
	//RODRIGO BARRETO 19/12/2022
	Replace F1_X_VLCOF     With n_VlCOF
	Replace F1_X_VLPIS	   With n_VlPIS
	Replace F1_X_SISCO	   With n_SisCo
	Replace F1_X_NRRE	   With cNrRef
	Replace F1_X_CNBR 	   With cNbr
	MsUnlock()

	//BUSCA A DIFERENÇA DO FINANCEIRO GERADO E O VALOR TOTAL INFORMADO, E FAZ O ACERTO DO CONTAS A PAGAR
	strSQL:="SELECT SUM(E2_VALOR) AS VALOR FROM " + RetSqlName("SE2") + " "
	strSQL+="WHERE E2_FILIAL = '"+SF1->F1_FILIAL+"' "
	strSQL+="AND E2_PREFIXO = '"+SF1->F1_SERIE+"' "
	strSQL+="AND E2_NUM = '"+SF1->F1_DOC+"' "
	strSQL+="AND E2_FORNECE = '"+SF1->F1_FORNECE+"' "
	strSQL+="AND E2_LOJA = '"+SF1->F1_LOJA+"' "
	strSQL+="AND D_E_L_E_T_ <> '*' "

	If Select("ORS") <> 0
		ORS->(DbCloseArea())
	EndIF

	TcQuery strSQL New Alias "ORS"

	If ORS->(!EOF())

		xVlSE2:=ORS->VALOR
		xVlSE2:=n_VlTot-xVlSE2
		If xVlSE2 > 0
			DbSelectArea("SE2")
			DbSetOrder(1)
			//POSICIONA NA PRIMEIRA PARCELA
			If DbSeek(SF1->F1_FILIAL+SF1->F1_SERIE+SF1->F1_DOC+'1  '+'NF '+SF1->F1_FORNECE+SF1->F1_LOJA)

				RecLock("SE2", .F.)
				Replace E2_ACRESC		With xVlSE2
				MsUnlock()

				//OU POSICIONA NA UNICA PARCELA
			ElseIf DbSeek(SF1->F1_FILIAL+SF1->F1_SERIE+SF1->F1_DOC+'   '+'NF '+SF1->F1_FORNECE+SF1->F1_LOJA)

				RecLock("SE2", .F.)
				Replace E2_ACRESC		With  xVlSE2
				MsUnlock()

			EndIf
		EndIf
	EndIf

	Close(oDlgObs)

Return

Static Function VldTransp(cTransp,cTipo)

	dbSelectArea("SA4")
	dbSetOrder(1)
	dbSeek(xfilial() + cTransp)
	If eof() .and. cTipo=="T"
		Alert("Transportadora Nao Cadastrada")
		return(.f.)
	elseif empty(cTransp) .and. cTipo=="T"
		Alert("Campo Transportadora Obrigatorio")
		return(.f.)
	endif
	if cTipo=="T"
		cNomeTra:=SA4->A4_NOME
		oNomeTra:Refresh()
	elseif cTipo=="R"
		cNomeRed:=SA4->A4_NOME
		oNomeRed:Refresh()
	endif

return(.t.)

//*******************************************************************************************
//PONTO DE ENTRADA NO PEDIDO DE COMPRAS PARA ADICIONAR AS INFORMAÇÕES DO PEDIDO DE IMPORTAÇÃO
//*******************************************************************************************
User Function MT120BRW()

	aAdd(aRotina,{"Dados Importacao","U_XIMPOR",4,0,4})

Return Nil

//*******************************************************************************************
//TELA PARA PREENCHIMENTO DE INFORMAÇÕES NO PEDIDO DE COMPRAS DE IMPORTAÇÃO
//*******************************************************************************************
User Function xImpor()

	// Local aBkArea := GetArea()
	Private nPerc:=1

	@000,000 TO 300,540 DIALOG oDlgObs TITLE OemToAnsi("Dados Adicionais da Importação - Pedido: " + SC7->C7_NUM)
	@002,002 TO 147,270
	@127,230 BMPBUTTON TYPE 1 ACTION xGravaPed()

	@007,004 SAY "Percentual.:"
	@006,047 GET nPerc  Picture "@e 99.9999999" SIZE 40,50

	ACTIVATE DIALOG oDlgObs CENTERED

Return

Static Function xGravaPed()

	Local strSQL	:=""
	Local nAdicaox	:=1
	Local nSeqx		:=1

	strSQL:="SELECT C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN AS CHAVE "
	strSQL+="FROM "+RetSqlName("SC7")+" WITH (NOLOCK) "
	strSQL+="WHERE C7_FILIAL = '"+CFILANT+"' "
	strSQL+="AND C7_NUM = '"+SC7->C7_NUM+"' "
	strSQL+="ORDER BY C7_ITEM ASC "

	If Select("ORSSC7") > 0
		ORSSC7->(DbCloseArea())
	EndIf

	TcQuery strSQL new alias "ORSSC7"

	While !ORSSC7->(EOF())
		dbSelectarea("SC7")
		dbSetOrder(1)
		If dbSeek(ORSSC7->CHAVE)
			RecLock("SC7",.F.)
			SC7->C7_X_FATOR := nPerc
			SC7->C7_X_ADIC	:= nAdicaox
			SC7->C7_X_SEQ	:= nSeqx
			SC7->C7_PRECO	:= SC7->C7_X_VLEXT * SC7->C7_X_FATOR
			SC7->C7_TOTAL	:= SC7->C7_PRECO * SC7->C7_QUANT
			MsUnLock()
		End if
		nSeqx:= nSeqx + 1
		ORSSC7->(dbSkip())
	EndDo

	ORSSC7->(DbCloseArea())

	msgInfo("Atualização efetuada com sucesso!")
	Close(oDlgObs)

Return()

User Function MT103VPC()

	Local lRet := .t.
	// Local nPosNProd
	// Local nPosProd
	/*
	If AllTrim(ProcName(2)) == "A103PROCPC"
		lRet := .f.
		nSldPed := SC7->C7_QUANT-SC7->C7_QUJE-SC7->C7_QTDACLA
		If (nSldPed > 0 .And. Empty(SC7->C7_RESIDUO) )
			NfePC2Acols(SC7->(RecNo()),,nSlDPed,cItem)
			nPosProd            := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_ALIQII"})
			//nPosNProd        := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_X_DESC"})
			//nPosOS                               := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_ORDEM"})
			IF nPosProd > 0
				aCols[val(cItem),nPosProd]    := 14 //Posicione("SB1",1,xFilial("SB1") + aCols[val(cItem),nPosProd],"B1_X_DESC")
			EndIF
			//aCols[val(cItem),nPosOS]          := Posicione("SC1",1,xFilial("SC1") + SC7->C7_NUMSC + SC7->C7_ITEMSC,"C1_OS" )
			cItem := SomaIt(cItem)
		EndIf
	Else
		Public cItem := "001"
	Endif*/

Return(lRet)
