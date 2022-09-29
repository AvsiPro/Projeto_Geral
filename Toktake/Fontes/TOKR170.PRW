#INCLUDE "TOKR170.CH"
#INCLUDE "FIVEWIN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GDCR170  ³ Autor ³ RICARDO SOUZA         ³ Data ³ 28/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprimir o boletim de Entrada.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TOKR170(cAlias,nReg,nOpcx)

	Local oPrint
	Local wnrel			:= "TOKR170"
	Local cDesc1		:= "Este programa ira emitir o Boletim de Entrada."
	Local cDesc2		:= " "
	Local cDesc3		:= "Últ. Atualização 28/11/09"
	Local cString		:= "SF1"
	
	Private contador 	:= 0
	Private cStartPath 	:= GetSrvProfString("Startpath","")
	Private cPecaRev 	:= ""
	Private Tamanho		:= "G"
	Private titulo	 	:= "Boletim de Entrada"
	Private aReturn 	:= {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	Private nomeprog	:= "TOKR170"
	Private nLastKey	:= 0
	Private nBegin		:= 0
	Private nDifColCC   := 0
	Private aLinha		:= {}
	Private aSenhas		:= {}
	Private aUsuarios	:= {}
	Private M_PAG		:= 1
	Private lin 		:= 580
	Private ncw 		:= 1
	Private nordem 		:= 1
	
	Private cUserLg		:= ""
	Private cUsuarioI	:= ''
	Private cDataI		:= ''
	Private cCampo
	Private cPerg		:= "TK170A"
	Private c_MsgOBS	:= ""
	
	ValidPerg()
	
	If !Pergunte(cPerg, .T.)
		Return Nil
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utiLizadas para parametros                         ³
	//³ mv_par01             // da Data                              ³
	//³ mv_par02             // ate a Data                           ³
	//³ mv_par03             // Nota De                              ³
	//³ mv_par04             // Nota Ate                             ³
	//³ mv_par05             // Imprimir Descricao? Produto/Pre-Nota ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrint	:= TMSPrinter():New( "Boletim de Entrada" )
	
	//oPrint:SetPortrait()
	oPrint:SetLandScape()
	
	MsgRun("Gerando Visualizacao, Aguarde...","",{|| CursorWait(), MontaRel(oPrint), CursorArrow()}) //"Gerando Visualizacao, Aguarde..."
	
	oPrint:Preview()  		// Visualiza antes de imprimir

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MontaRel ³ Autor ³ Ricardo               ³ Data ³ 28.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Inicio processo montagem relatorio                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MontaRel(ExpO1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TOKPEDC                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(oPrint)

	Local cLocDest		:= GetMV("MV_CQ")
	Local aDivergencia	:= {}
	Local aPedidos  	:= {}
	Local aCQ			:= {}
	Local _lQtdErr		:= .F.
	Local _lPrcErr		:= .F.
	Local _QtdSal		:= .F.
	Local _lTes			:= .F.
	Local cForAnt		:= 0
	Local nDocAnt		:= 0
	Local lContinua		:= .T.
	Local lPedCom		:= .F.
	Local cQuery		:= ""
	Local _cPedido 		:= 'S'
	                           	
	i := 0
	
	//oArial16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
	//oCourN08N	:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
	oVerdan08N	:= TFont():New("Verdana",08,08,,.T.,,,,.T.,.F.)
	oVerdan10N	:= TFont():New("Verdana",10,10,,.T.,,,,.T.,.F.)
	oVerdan12N	:= TFont():New("Verdana",12,12,,.T.,,,,.T.,.F.)
	oVerdan14N	:= TFont():New("Verdana",14,14,,.T.,,,,.T.,.F.)
	oVerdan16N	:= TFont():New("Verdana",16,16,,.T.,,,,.T.,.F.)
	oVerdan18N	:= TFont():New("Verdana",18,18,,.T.,,,,.T.,.F.)
	oVerdan08	:= TFont():New("Verdana",08,08,,.F.,,,,.T.,.F.)
	oVerdan10	:= TFont():New("Verdana",10,10,,.F.,,,,.T.,.F.)
	oVerdan12	:= TFont():New("Verdana",12,12,,.F.,,,,.T.,.F.)
	oVerdan14	:= TFont():New("Verdana",14,14,,.F.,,,,.T.,.F.)
	oVerdan16	:= TFont():New("Verdana",16,16,,.F.,,,,.T.,.F.)
	oVerdan18	:= TFont():New("Verdana",18,18,,.F.,,,,.T.,.F.)
	
	_cQuery := "SELECT *  "
	_cQuery += "FROM "	    + RetSqlName( 'SF1' ) 
	_cQuery += " WHERE "
	_cQuery += "F1_FILIAL='" + xFilial( 'SF1' )    +"' AND "
	_cQuery += "F1_DTDIGIT>='"  + DTOS(MV_PAR01)   + "' AND "
	_cQuery += "F1_DTDIGIT<='"  + DTOS(MV_PAR02)   + "' AND "
	_cQuery += "F1_DOC>='"  + MV_PAR03             + "' AND "
	_cQuery += "F1_DOC<='"  + MV_PAR04             + "' AND "
	_cQuery += "D_E_L_E_T_<>'*' "
	_cQuery += "ORDER BY " + SqlOrder(SF1->(IndexKey()))
	_cQuery := ChangeQuery(_cQuery)
	
	If Select("RS")>0
		DbSelectArea("RS")
		DbCloseArea()
	Endif
	   	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"RS",.T.,.T.)
	
	DbSelectArea("RS")
	DbGoTop()

	While !Eof()

		_nlinha		:= 610
		c_MsgOBS	+= RS->F1_XMENS + " - "
	
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+RS->F1_DOC+RS->F1_SERIE+RS->F1_FORNECE+RS->F1_LOJA)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do Cabecalho.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		i++
		CapaRel(oPrint, i) 	// Funcao que monta a capa do relatório
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao dos itens da Nota de Entrada.                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		dbSelectArea("SD1")	
		nDocAnt 		:= D1_DOC+D1_SERIE
		cForAnt 		:= D1_FORNECE+D1_LOJA
		aDivergencia 	:= {}
		aPedidos     	:= {}
		aItemNF 		:= {}
		aItemNFalt		:= {}
		aItemDIV 		:= {}
		aItemDIVFa		:= {}
		Aadd(aItemNF,{'','','','',''}) //Cod.Prod / UM / Descricao / Cta / CC
		Aadd(aItemDIV,{'','','','','','','',''}) //Div. / Pedido / Descricao / Observacoes/ Dt. Emissao / Dt. Entrega / Solicitante / Cond. Pgto
	
		While ( !Eof() .And. SD1->D1_DOC+SD1->D1_SERIE == nDocAnt .And. cForAnt == SD1->D1_FORNECE+SD1->D1_LOJA .And. SD1->D1_FILIAL == xFilial("SD1") )
	            
			_cPedido := "S"
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona Todos os Arquivos Ref. ao Itens                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD1->D1_COD)
	
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4")+SD1->D1_TES)
			
			dbSelectArea("SC7")
			dbSetOrder(14)
			_cCodImp	:= " "       
	
			If dbSeek(xFilial()+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
				dbSelectArea("SC1")
				dbSetOrder(1)
				If dbSeek(xFilial()+SC7->C7_NUMSC+SC7->C7_ITEMSC)
					lPedCom := .T.
					If cEmpAnt <> "04"
						_cCodImp	:= "" // Codigo do Produto na Empresa 40
					Endif
				EndIf
	
				dbSelectArea("SE4")
				dbSetOrder(1)
				dbSeek(xFilial("SE4")+SC7->C7_COND)
				
				cProblema := ""
				If SC7->C7_QUANT <> SD1->D1_QUANT
					cProblema += "Q"
					_lQtdErr := .T.
				Else
					cProblema += " "
				EndIf
				If (SC7->C7_QUANT - SC7->C7_QUJE) < SD1->D1_QUANT  .AND. SD1->D1_TES == "   "
					_QtdSal := .T.
					n_proc1 :=-(SD1->D1_QUANT - (SC7->C7_QUANT - SC7->C7_QUJE)) / SC7->C7_QUANT * 100
				EndIf
				If SD1->D1_TES != "   " .AND. (SC7->C7_QUANT - SC7->C7_QUJE) < 0
					_QtdSal := .T.
					N_PORC1 :=-(SC7->C7_QUANT - SC7->C7_QUJE) / SC7->C7_QUANT * 100
				EndIf
				If IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) # SD1->D1_VUNIT
					cProblema := cProblema+"P"
					_lPrcErr := .T.
				Else
					cProblema := cProblema+" "
				EndIf
				If SC7->C7_DATPRF <> SD1->D1_DTDIGIT
					cProblema := cProblema+"E"
				Else
					cProblema := cProblema+" "
				EndIf
				If !Empty(cProblema)
					aADD(aDivergencia,cProblema)
				Else
					aADD(aDivergencia,"Ok ")
				Endif
				aADD(aPedidos,{SC7->C7_NUM+"/"+SC7->C7_ITEM,;
					Iif(MV_PAR05==1,SB1->B1_DESC,SC7->C7_DESCRI),;
					TransForm(0,PesqPict("SC7","C7_QUANT",11)),;
					TransForm(0,PesqPict("SC7","C7_PRECO",13)),;
					DTOC(SC7->C7_EMISSAO),;
					DTOC(SC7->C7_DATPRF),;
					SC7->C7_NUMSC+"/"+SC7->C7_ITEMSC,;
					IIf(lPedCom,SubStr(SC1->C1_SOLICIT,1,15),""),;
					IIf(lPedCom,SC1->C1_CC,""),;
					AllTrim(SE4->E4_DESCRI),;
					IIF(Empty(SC7->C7_OBS)," ",SC7->C7_OBS)} )//
			Else
				aADD(aDivergencia,"Err")
				aADD(aPedidos,{"",STR0014,"","","","","","","","",""}) //"Sem Pedido de Compra"
				_cPedido = 'N'
			Endif
	
			If !Empty(SD1->D1_NUMCQ) .AND. SF4->F4_ESTOQUE == "S"
				AADD(aCQ,SD1->D1_NUMCQ+SD1->D1_COD+cLocDest+"001"+DTOS(SD1->D1_DTDIGIT))
			Endif
	
			aItemNF[1,1] := IIF(Empty(_cCodIMP),SD1->D1_COD,_cCodImp)
			aItemNF[1,2] := SD1->D1_UM
			IF _cPedido <> 'N'
				If MV_PAR05 == 1
					aItemNF[1,3] := SB1->B1_DESC
				Else
					aItemNF[1,3] := SC7->C7_DESCRI
				Endif
			Else     
				If MV_PAR05 == 1
					aItemNF[1,3] := SB1->B1_DESC
				Else
					aItemNF[1,3] := SD1->D1_XDESCRI
				Endif
			Endif
	
			aItemNF[1,4] := " "
			aItemNF[1,5] := SD1->D1_CC
	        
			If _nLinha <= 1010

				_nlinha := ImpDetNF(oPrint, aItemNF, 1, _nLinha)		
				_nlinha += 40
				
			Else
				
				Aadd(aItemNFalt, {aItemNF[1,1], aItemNF[1,2], aItemNF[1,3], aItemNF[1,4], aItemNF[1,5]})
				
			Endif
			aItemNF[1,1] := ""
			aItemNF[1,2] := ""
			aItemNF[1,3] := ""
			aItemNF[1,4] := ""
			aItemNF[1,5] := ""
			            
			dbSelectArea("SD1")
			dbSkip()
		Enddo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Divergencia com Pedido de Compra.                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aPedidos) .And. !Empty(aDivergencia)
			_nLinha := 1290
			For nX := 1 To Len(aPedidos)
				
				aItemDIV[1,1] := aDivergencia[nX]
				aItemDIV[1,2] := aPedidos[nX][1]
				aItemDIV[1,3] := aPedidos[nX][2]

				aItemDIV[1,4] := aPedidos[nX][11]
				
				aItemDIV[1,5] := aPedidos[nX][5]
				aItemDIV[1,6] := aPedidos[nX][6]
				aItemDIV[1,7] := aPedidos[nX][8]
				aItemDIV[1,8] := aPedidos[nX][10]
								
				If _nLinha <= 1690
					
					//_nLinha := ImpDetDiv(oPrint, aItemDIV, 1, _nLinha) CONFORME SOLICITAÇÃO DO SR. ODAIR EM 14/07/2010
					_nLinha += 40  
					
				Else
				    
					Aadd(aItemDIVFa, {aItemDIV[1,1], aItemDIV[1,2], aItemDIV[1,3], aItemDIV[1,4], aItemDIV[1,5], aItemDIV[1,6], aItemDIV[1,7], aItemDIV[1,8]})
					
				Endif
				aItemDIV[1,1] := ""
				aItemDIV[1,2] := ""
				aItemDIV[1,3] := ""
				aItemDIV[1,4] := ""
				aItemDIV[1,5] := ""
				aItemDIV[1,6] := ""
				aItemDIV[1,7] := ""
				aItemDIV[1,8] := ""
				
			Next nX
		EndIf
		
		oPrint:EndPage() 		// Finaliza a pagina
		
		//Imprimir os itens que não couberam na primeira pagina ( aItemNFalt e aItemDIVFa )
		If Len(aItemNFalt) > 0 .or. Len(aItemDIVFa) > 0
		
			_nComeca 	:= 1
			_nComeca1 	:= 1
			
			While (_nComeca <= Len(aItemNFalt) .or. _nComeca1 <= Len(aItemDIVFa))
				
				_nLinNF		:= 610
				_nLinDIV 	:= 1290
	
				i++
				CapaRel(oPrint, i) 	// Funcao que monta a capa do relatório
					
				For nNum := _nComeca To Len(aItemNFalt)
					
					If _nLinNF > 970
						Exit
					Endif
					
					_nLinNF := ImpDetNF(oPrint, aItemNFalt, nNum, _nLinNF)
					_nLinNF += 40					
					_nComeca ++
					
				Next nNum                               
				
				For nNum := _nComeca1 To Len(aItemDIVFa)
					
					If _nLinDIV > 1690
						Exit
					Endif
					
					_nLinDIV := ImpDetDiv(oPrint, aItemDIVFa, nNum, _nLinDIV)
					_nLinDIV += 40  
					_nComeca1 ++
					
				Next nNum

				oPrint:EndPage() 		// Finaliza a pagina
				
			Enddo
			
		Endif
		
		DbSelectArea("RS")
		DbSkip()
			      
	Enddo

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CapaRel  ³ Autor ³ Ricardo Souza         ³ Data ³ 28.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Montagem da estrutura do relatorio                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CapaRel(ExpO1,ExpN1)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oPrint                                      ³±±
±±³          ³ ExpN1 = Contador de paginas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico TOK TAKE                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CapaRel(oPrint,i)

	Local cFileLogo  := "TOK.BMP" // Empresa+Filial
	Local nOrden, cCGC
	LOCAL cMoeda
	
	_nMargEsq 	:= 50
	_nMargDir	:= 3100
	
	oPrint:StartPage() 		// Inicia uma nova pagina
	
	//Box Cabecalho
	oPrint:Box( 150, _nMargEsq + 0, 450, _nMargDir - 0 )
	oPrint:Box( 151, _nMargEsq + 1, 449, _nMargDir - 1 )
	oPrint:Box( 152, _nMargEsq + 2, 448, _nMargDir - 2 )
	oPrint:Box( 153, _nMargEsq + 3, 447, _nMargDir - 3 )
	
	//Box Dados Nota Fiscal
	oPrint:Box( 470, _nMargEsq + 0, 1250, _nMargDir - 0 )
	oPrint:Box( 471, _nMargEsq + 1, 1251, _nMargDir - 1 )
	oPrint:Box( 472, _nMargEsq + 2, 1252, _nMargDir - 2 )
	oPrint:Box( 473, _nMargEsq + 3, 1253, _nMargDir - 3 )
	
	//Box Divergencia com Pedido de Compra
	oPrint:Box( 1300, _nMargEsq + 0, 1700, _nMargDir - 0 )
	oPrint:Box( 1301, _nMargEsq + 1, 1699, _nMargDir - 1 )
	oPrint:Box( 1302, _nMargEsq + 2, 1698, _nMargDir - 2 )
	oPrint:Box( 1303, _nMargEsq + 3, 1697, _nMargDir - 3 )

	//Box Observacao
	oPrint:Box( 1880, _nMargEsq + 0, 1720, _nMargDir - 0 )
	oPrint:Box( 1879, _nMargEsq + 1, 1719, _nMargDir - 1 )
	oPrint:Box( 1878, _nMargEsq + 2, 1718, _nMargDir - 2 )
	oPrint:Box( 1877, _nMargEsq + 3, 1717, _nMargDir - 3 )
	
	//Box Recebimento
	oPrint:Box( 1935, _nMargEsq + 100, 2350, _nMargDir - 100 )
	oPrint:Box( 1936, _nMargEsq + 101, 2349, _nMargDir - 101 )
	oPrint:Box( 1937, _nMargEsq + 102, 2348, _nMargDir - 102 )
	oPrint:Box( 1938, _nMargEsq + 103, 2347, _nMargDir - 103 )
	
	//Linhas horizontais no Box Cabecalho
	oPrint:Line( 230, 800, 230, 2500 )   	// horizontal
	oPrint:Line( 290, 050, 290, 0800 )   	// horizontal
	//Linhas Verticais no Box Cabecalho
	oPrint:Line( 153, 0800, 447, 0800 )   	// vertical
	oPrint:Line( 230, 1880, 447, 1880 )   	// vertical
	oPrint:Line( 153, 2500, 447, 2500 )   	// vertical
	
	//Linhas horizontais no Box Dados Nota Fiscal
	oPrint:Line( 530, 0050, 530, 3100 )   	// horizontal
	oPrint:Line( 600, 0050, 600, 3100 )   	// horizontal
	//Linhas Verticais no Box Dados Nota Fiscal
	oPrint:Line( 530, 0370, 1250, 0370 )   	// vertical
	oPrint:Line( 530, 0450, 1250, 0450 )   	// vertical
	oPrint:Line( 530, 0990, 1250, 0990 )   	// vertical
	oPrint:Line( 530, 1290, 1250, 1290 )   	// vertical
	oPrint:Line( 530, 1590, 1250, 1590 )   	// vertical
	oPrint:Line( 530, 1890, 1250, 1890 )   	// vertical
	oPrint:Line( 530, 2090, 1250, 2090 )   	// vertical
	oPrint:Line( 530, 2290, 1250, 2290 )   	// vertical
	oPrint:Line( 530, 2590, 1250, 2590 )   	// vertical
	oPrint:Line( 530, 2790, 1250, 2790 )   	// vertical
	oPrint:Line( 600, 2890, 1250, 2890 )   	// vertical

	//Linhas horizontais no Box Divergencia com Pedido de Compra
	oPrint:Line( 1370, 0050, 1370, 3100 )   	// horizontal
	//oPrint:Line( 1270, 0050, 1270, 3100 )   	// horizontal
	//Linhas Verticais no Box Divergencia com Pedido de Compra
	/*
	oPrint:Line( 1200, 0170, 1797, 0170 )   	// vertical
	oPrint:Line( 1200, 0370, 1797, 0370 )   	// vertical

	oPrint:Line( 1200, 1080, 1797, 1080 )   	// vertical //
	
	oPrint:Line( 1200, 1860, 1797, 1860 )   	// vertical
	oPrint:Line( 1200, 2130, 1797, 2130 )   	// vertical
	oPrint:Line( 1200, 2400, 1797, 2400 )   	// vertical
	oPrint:Line( 1200, 2830, 1797, 2830 )   	// vertical
	*/
	//Linhas horizontais no Box Recebimento
//	oPrint:Line( 1860, 650, 1860, 2500 )   	// horizontal
	oPrint:Line( 2040, 150, 2040, 3000 )   	// horizontal
	//Linhas Verticais no Box Recebimento
	oPrint:Line( 2040, 1200, 2350, 1200 )   	// vertical
	oPrint:Line( 2040, 2200, 2350, 2200 )	
	
	//Inicio do Preenchimento dos boxs
	oPrint:Say( 050, 0050, AllTrim(SM0->M0_NOME)			,oVerdan16N )
	ImpCabec(oPrint, i)
	
	/* Apenas para Facilitar
	For ii := 0 To 3100 Step(100)
		oPrint:Say( 50, ii, AllTrim(Str(ii))	,oVerdan08 )
	Next ii
	For jj := 0 To 3000 Step(50)
		oPrint:Say( jj, 0, AllTrim(Str(jj))	,oVerdan08 )
	Next jj 
	*/
	
	//Preenchimento Fixo do Box Dados da NF - Linha 470 a 1100
	oPrint:Say( 480, 1250, "D A D O S   D A   N O T A   F I S C A L"		,oVerdan12N )
    /* ALTERAÇÃO EM 14/07/2010 CONFORME SR ODAIR
    oPrint:Say( 550, 0060, "Cód. Produto"		,oVerdan10N )
	oPrint:Say( 550, 0380, "UM"					,oVerdan10N )
	oPrint:Say( 550, 0460, "Descrição"			,oVerdan10N )
	oPrint:Say( 550, 2410, "Quantidade"			,oVerdan10N )
	oPrint:Say( 550, 2670, "Re-Contagem"		,oVerdan10N )
    */
	oPrint:Say( 550, 0060, "Cód. Produto"		,oVerdan10N )
	oPrint:Say( 550, 0380, "UM"					,oVerdan10N )
	oPrint:Say( 550, 0460, "Descrição"			,oVerdan10N )
	oPrint:Say( 550, 1000, "Contagem"			,oVerdan10N )
	oPrint:Say( 550, 1300, "Re-Contagem"		,oVerdan10N )
	oPrint:Say( 550, 1600, "Data Fabricação"	,oVerdan10N )
	oPrint:Say( 550, 1900, "Validade"			,oVerdan10N )
	oPrint:Say( 550, 2100, "Lote"				,oVerdan10N )
	oPrint:Say( 550, 2300, "Temperatura"		,oVerdan10N )
	oPrint:Say( 520, 2600, "Laudo"				,oVerdan10N )	
	oPrint:Say( 550, 2600, "Sim/Não"			,oVerdan10N )	
	oPrint:Say( 520, 2800, "Amostra"			,oVerdan10N )
	oPrint:Say( 550, 2800, "Peso"				,oVerdan10N )
	oPrint:Say( 550, 2900, "Quantidade"			,oVerdan10N )
	
	//Preenchimento Fixo do Box Divergencia com PC - Linha 1120 a 1700
	/* ALTERAÇÃO EM 14/07/2010 CONFORME SR ODAIR
	oPrint:Say( 1140, 0900, "D I V E R G Ê N C I A   C O M   P E D I D O   D E   C O M P R A"		,oVerdan12N )
	oPrint:Say( 1220, 0060, "Div."			,oVerdan10N )
	oPrint:Say( 1220, 0190, "Pedido"		,oVerdan10N )
	oPrint:Say( 1220, 0380, "Descrição"		,oVerdan10N )
	oPrint:Say( 1220, 1090, "Observaçoes"	,oVerdan10N )
	oPrint:Say( 1220, 1880, "Dt. Emissão"	,oVerdan10N )
	oPrint:Say( 1220, 2150, "Dt. Entrega"	,oVerdan10N )
	oPrint:Say( 1220, 2410, "Solicitante"	,oVerdan10N )
	oPrint:Say( 1220, 2850, "Cond. Pgto"	,oVerdan10N )
	*/
	oPrint:Say( 1320, 0900, "  C O N D I Ç Õ E S     D E     T R A N S P O R T E  ",oVerdan12 )
	oPrint:Say( 1400, 0060, "1. Presença de sujeira, pragas, produtos químicos." ,oVerdan12 )
	oPrint:Say( 1400, 1600, "SIM____       NÃO____",oVerdan12 )
	oPrint:Say( 1450, 0060, "2. Esta em boas condições (íntegro, sem furos, sem ferrugem).",oVerdan12 )
	oPrint:Say( 1450, 1600, "SIM____       NÃO____",oVerdan12 )
	oPrint:Say( 1500, 0060, "3. Material esta coberto.",oVerdan12 )	
	oPrint:Say( 1500, 1600, "SIM____       NÃO____",oVerdan12 )		
	oPrint:Say( 1550, 0060, "4. Embalagem, caixa, sacaria está integra, limpa e seca.",oVerdan12 )
	oPrint:Say( 1550, 1600, "SIM____       NÃO____",oVerdan12 )	
	//Observacao - c_MsgOBS
	oPrint:Say( 1800, 0060, "OBS..: " 					,oVerdan12N )
	oPrint:Say( 1815, 0190, Left(c_MsgOBS,156)			,oVerdan10 )
	oPrint:Say( 1825, 0190, SubStr(c_MsgOBS,157,43)	,oVerdan10 )

	//Preenchimento Fixo do Box Recebimento - Linha 1800 a 2250
	oPrint:Say( 1960, 0400, "R  E  C  E  B  I  M  E  N  T  O"	,oVerdan12N )
	oPrint:Say( 1960, 1400, "A L M O X A R I F A D O"			,oVerdan12N )
	oPrint:Say( 1960, 2400, "Q U A L I D A D E"					,oVerdan12N )
	
	oPrint:Say( 2080, 0250, "Resp.:____________________________"	,oVerdan10N )
	oPrint:Say( 2160, 0250, "Ass.:_____________________________"	,oVerdan10N )

	oPrint:Say( 2080, 1250, "Data: ____/____/______   Hora: ____:____"	,oVerdan10N )
	oPrint:Say( 2160, 1250, "De Acordo do Entregador:_______________________"	,oVerdan10N )

	oPrint:Say( 2080, 2250, "Data: ____/____/____   Hora: ____:___"	,oVerdan10N )
	oPrint:Say( 2160, 2250, "Resp.:______________________________"	,oVerdan10N )
	oPrint:Say( 2240, 2250, "Ass.:_______________________________"	,oVerdan10N )

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Ricardo Souza         ³ Data ³ 28.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir os dados do cabecalho do relatorio.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico TOK TAKE                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(oPrint, i)

	Local aVencto := {}
	
	oPrint:Say( 170, 0070, "Boletim de Entrada  -  "+SD1->D1_NUMSEQ							,oVerdan12 )
	oPrint:Say( 220, 0070, "Material Recebido em "+DTOC(STOD(RS->F1_DTDIGIT))						,oVerdan12 )
	oPrint:Say( 305, 0070, SM0->M0_NOME + " - " + SM0->M0_FILIAL							,oVerdan12 )
	oPrint:Say( 370, 0070, "C.N.P.J.: " + transform(SM0->M0_CGC,PesqPict("SA1","A1_CGC"))	,oVerdan12 )
	
	If RS->F1_TIPO $ "DB"
		
		DbSelectArea("SE1")
		DbSetOrder(2)
		DbSeek(xFilial("SE1")+RS->F1_FORNECE+RS->F1_LOJA+RS->F1_PREFIXO+RS->F1_DOC)
		While !Eof() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM == xFilial("SE1")+RS->F1_FORNECE+RS->F1_LOJA+RS->F1_PREFIXO+RS->F1_DOC
			aADD(aVencto,E1_VENCREA)
			DbSkip()
		End
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+RS->F1_FORNECE+RS->F1_LOJA)
		
		oPrint:Say( 160, 1150, "   D A D O S   D O   C L I E N T E   "							,oVerdan16N )
		oPrint:Say( 240, 0820, SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SUBSTR(SA1->A1_NOME,1,35)	,oVerdan10 )
		oPrint:Say( 290, 0820, SA1->A1_END														,oVerdan10 )
		oPrint:Say( 340, 0820, SA1->A1_MUN+" - "+SA1->A1_EST									,oVerdan10 )
		oPrint:Say( 390, 0820, "CNPJ "+transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC"))			,oVerdan10 )
		
	Else
		
		DbSelectArea("SE2")
		DbSetOrder(6)
		DbSeek(xFilial("SE2")+RS->F1_FORNECE+RS->F1_LOJA+RS->F1_SERIE+RS->F1_DOC)
		While !Eof() .And. E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == xFilial("SE2")+RS->F1_FORNECE+RS->F1_LOJA+RS->F1_SERIE+RS->F1_DOC
			aADD(aVencto,E2_VENCTO)
			DbSkip()
		End
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(XFilial("SA2")+RS->F1_FORNECE+RS->F1_LOJA)
		
		oPrint:Say( 160, 1150, "D A D O S   D O   F O R N E C E D O R"							,oVerdan16N )
		oPrint:Say( 240, 0820, SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SubStr(SA2->A2_NOME,1,35)	,oVerdan10 )
		oPrint:Say( 290, 0820, SA2->A2_END														,oVerdan10 )
		oPrint:Say( 340, 0820, SA2->A2_MUN+" - "+SA2->A2_EST									,oVerdan10 )
		_cDocs := "CNPJ "+ Transform(SA2->A2_CGC,PesqPict("SA2","A2_CGC"))
		_cDocs += " IE "+ SA2->A2_INSCR
		oPrint:Say( 390, 0820, _cDocs															,oVerdan10 )
		
	EndIf
	
	oPrint:Say( 240, 1900, "Nota Fiscal...: "+RS->F1_DOC+"-"+RS->F1_SERIE								,oVerdan12 )
	oPrint:Say( 290, 1900, "Dt. Emissão.: "+DTOC(STOD(RS->F1_EMISSAO))									,oVerdan12 )
	oPrint:Say( 340, 1900, "Dt. Vencto...: "+IIf( Len(aVencto)==1, DTOC(aVencto[1]),"Diversos" )	,oVerdan12 )
	oPrint:Say( 390, 1900, "Valor Total R$ "+Transform(RS->F1_VALBRUT,"@E 999,999.99")		,oVerdan12 )
	
	oPrint:Say( 160, 2520, "Usuário....: "+cusername				,oVerdan10 )
	oPrint:Say( 215, 2520, "Data Base.: "+DTOC(ddatabase)			,oVerdan10 )
	oPrint:Say( 270, 2520, "Data Impr.: "+DTOC(Date())				,oVerdan10 )
	oPrint:Say( 335, 2520, "Hora Ref...: "+Time()					,oVerdan10 )
	oPrint:Say( 390, 2520, "Página......: "+StrZero(i, 2)			,oVerdan10 )

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpDetNF ³ Autor ³ Ricardo Souza         ³ Data ³ 28.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir os detalhes da Nota Fiscal.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico TOK TAKE                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDetNF(oPrint, aItemNF, _nItem, _nLin)

	oPrint:Say( _nLin, 0060, aItemNF[_nItem,1]				,oVerdan08 )
	oPrint:Say( _nLin, 0380, aItemNF[_nItem,2]				,oVerdan08 )
	oPrint:Say( _nLin, 0460, Left(aItemNF[_nItem,3], 100)	,oVerdan08 )
	oPrint:Say( _nLin, 2410, "           "					,oVerdan08 )
	oPrint:Say( _nLin, 2670, AllTrim(aItemNF[_nItem,4])+" "+AllTrim(aItemNF[_nItem,5]) ,oVerdan08 )
	oPrint:Say( _nLin + 1, 0990, " "						,oVerdan08 )	
	oPrint:Say( _nLin, 0990, "...........................................................................................................................................................................................................................................",oVerdan08 )

	_nTamDesc := Len(AllTrim(aItemNF[_nItem,3]))
	_nQtdLin  := _nTamDesc / 100
	
	If _nQtdLin > 1
		_nLin += 40
		oPrint:Say( _nLin, 0460, SubStr(AllTrim(aItemNF[_nItem,3]),101,100)		,oVerdan08 )
		If _nQtdLin > 2
			_nLin += 40
			oPrint:Say( _nLin, 0460, SubStr(AllTrim(aItemNF[_nItem,3]),201)		,oVerdan08 )
		Endif
	Endif
	
Return (_nLin)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpDetDiv ³ Autor ³ Ricardo Souza         ³ Data ³ 28.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir os detalhes das divergências com o Pedido Compra. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico TOK TAKE                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDetDiv(oPrint, aItemDIV, _nItem, _nLin)

	oPrint:Say( _nLin, 0060, aItemDIV[_nItem,1]	,oVerdan08 )
	oPrint:Say( _nLin, 0190, aItemDIV[_nItem,2]	,oVerdan08 )
	oPrint:Say( _nLin, 0380, Left(aItemDIV[1,3], 50)	,oVerdan08 )

	oPrint:Say( _nLin, 1090, aItemDIV[_nItem,4]	,oVerdan08 )

	oPrint:Say( _nLin, 1880, aItemDIV[_nItem,5]	,oVerdan08 )
	oPrint:Say( _nLin, 2150, aItemDIV[_nItem,6]	,oVerdan08 )
	oPrint:Say( _nLin, 2410, aItemDIV[_nItem,7]	,oVerdan08 )
	oPrint:Say( _nLin, 2850, aItemDIV[_nItem,8]	,oVerdan08 )

Return (_nLin)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  25/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

	Local aRegs := {}
	
	cPerg := PADR(cPerg,6)
	
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Da Data          ? ","","","MV_CH1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ate a Data       ? ","","","MV_CH2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Nota de          ? ","","","MV_CH3","C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Nota Ate         ? ","","","MV_CH4","C",09,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"05","Imp. CC x Cta Cont?","","","MV_CH5","N",01,0,1,"C","","MV_PAR05","SIM","","","","","NÃO","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"06","Imp. Custo       ? ","","","MV_CH6","N",01,0,1,"C","","MV_PAR06","TOTAL","","","","","UNITÁRIO","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Imp. Descricao   ? ","","","MV_CH5","N",01,0,1,"C","","MV_PAR05","PRODUTO","","","","","PRÉ-NOTA","","","","","","","","","","","","","","","","","","",""})
	
	//U_PutX1GDC(cPerg, aRegs)

Return Nil