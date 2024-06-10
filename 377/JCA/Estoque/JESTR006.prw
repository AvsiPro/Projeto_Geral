#INCLUDE "MATR715.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³JESTR006   ³ Autor ³ 377					³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de transferencias entre filiais em Excel           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function JESTR006()

Local Titulo  := STR0001    //"Transferencias entre filiais"                                     // Titulo do Relatorio
Local cDesc1  := STR0002    //"O relatorio ira imprimir as informacoes sobre as notas fiscais"   // Descricao 1
Local cDesc2  := STR0003    //"de transferencia entre filiais, imprimindo informacoes sobre as"  // Descricao 2
Local cDesc3  := STR0004    //"saidas e entradas de cada documento."                             // Descricao 3
Local cString := "SD2"      // Alias utilizado na Filtragem
Local lDic    := .F.        // Habilita/Desabilita Dicionario
Local lComp   := .T.        // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T.        // Habilita/Desabilita o Filtro
Local wnrel   := "JESTR006"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "JESTR006"  // nome do programa

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {STR0008,STR0009,STR0010}  //"Produto"###"Documento / Serie"###"Data de emissao"
Private cPerg   := "MTR715"  // Pergunta do Relatorio
Private aReturn := { STR0005, 1,STR0006, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
//[1] Reservado para Formulario
//[2] Reservado para N§ de Vias
//[3] Destinatario
//[4] Formato => 1-Comprimido 2-Normal
//[5] Midia   => 1-Disco 2-Impressora
//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
//[7] Expressao do Filtro
//[8] Ordem a ser selecionada
//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01          // Filial origem de                        ³
//³ mv_par02          // Filial origem ate                       ³
//³ mv_par03          // Data de emissao de                      ³
//³ mv_par04          // Data de emissao ate                     ³
//³ mv_par05          // Doc Saida de                            ³
//³ mv_par06          // Doc Saida ate                           ³
//³ mv_par07          // Ser Doc Saida de                        ³
//³ mv_par08          // Ser Doc Saida ate                       ³
//³ mv_par09          // Produto de                              ³
//³ mv_par10          // Produto ate                             ³
//³ mv_par11          // Lista NFs Em transito/Ja recebidas/Todas³
//³ mv_par12          // Totaliza quebras  Sim/Nao               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to     
	Return
Endif
/*SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif*/
RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Rodrigo de A Sartorio ³ Data ³29.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)
Local aStrucSD2  := {}
Local aFilsCalc  := {}                 			// Array com dados das filiais
Local aAreaSM0   := SM0->(GetArea()) 				// Status original do arquivo SM0
Local cFilBack   := cFilAnt           		 		// Filial corrente original
Local aRetNf     := {}                				// Informacoes relacionadas a transferencia entre filiais
Local cSeek      := ""                				// Variavel utilizada na quebra
Local cWhile     := ""                				// Variavel utilizada na quebra
Local cTexto     := ""                				// Texto para totalizacao utilizada na quebra
// Texto para totalizacao geral
Local cTextoGer  := STR0011 //"TOTAL GERAL EM TRANSITO FILIAL "
Local cName 	 := "" 								// Nome do campo utilizado no filtro
Local cQryAd 	 := "" 						   		// Campos adicionados na query conforme filtro de Usuario
Local aTotais    := {0,0,0}				  			// Array para totalizacao utilizada na quebra
Local aTotaisGer := {0,0,0}				 			// Array para totalizacao geral
Local li         := 100               				// Contador de Linhas
Local cbCont     := 0                 				// Numero de Registros Processados
Local cbText     := ""                				// Mensagem do Rodape
Local cQuery     := ""  							// Query para filtragem
Local lQuery     := .F.								// Variavel que indica filtragem
Local cAliasSD2  := "SD2"							// Alias para processamento
Local nTamDoc    := TamSX3("D2_DOC")[1]
Local lTamDoc    := IIF(nTamDoc > 9,.T.,.F.)
Local nX		 := 0
Local lUsaFilTrf := UsaFilTrf()
Local nRecnoSF4  := 0

Local aItensExc  := {}
Local aAuxExc    := {}
//
//                                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21      22
//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local cCabec1:= STR0012  // "FILIAL     DESCRICAO       DOCUMENTO SERIE TES CFO   DESCRICAO          PRODUTO         DESCRICAO       GRUPO UM           QUANTIDADE     VALOR TOTAL     CUSTO TOTAL     DATA DE   |FILIAL     DESCRICAO FILIAL DATA DE  "
Local cCabec2:= STR0013  // "ORIGEM     ORIGEM                          ORI ORIG  OPERACAO ORIGEM                                                                                                      EMISSAO   |DESTINO    DESTINO          DIGITACAO"
//                        XXXXXXXXXX  XXXXXXXXXXXXXXX XXXXXX   XXX   XXX XXXXX XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXXXX XX XXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXX|XXXXXXXXXX XXXXXXXXXXXXXXX  XXXXXXXXXX
//                        1234567890 123456789012345 123456    123   123 12345 123456789012345678 123456789012345 1234567890123456789012345 12345 12 12345678901234 123456789012345 123456789012345 1234567890|1234567890 123456789012345  1234567890

// Caso o tamanho do campo documento seja maior que 9 mudar o cabecalho
If lTamDoc
//                                  1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21      22
//                        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	cCabec1 := STR0017 //"FILIAL     DESCRICAO        DOCUMENTO            SERIE TES  CFO         PRODUTO         DESCRICAO PRODUTO         GRUPO UM QUANTIDADE     VALOR TOTAL     CUSTO TOTAL     DATA DE   |FILIAL     DESCRICAO        DATA DE  "
	cCabec2 := STR0018 //"ORIGEM     ORIGEM                                ORI   ORIG                                                                                                               EMISSAO   |DESTINO    DESTINO          DIGITACAO"
//                        XXXXXXXXXX XXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX XXX   XXX  XXXXX       XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXX XXXXX XX XXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXX|XXXXXXXXXX XXXXXXXXXXXXXXX  XXXXXXXXXX
//                        1234567890 123456789012345  12345678901234567890 123   123  12345       123456789012345 1234567890123456789012345 12345 12 12345678901234 123456789012345 123456789012345 1234567890|1234567890 123456789012345  1234567890
EndIf

// Posiciona arquivos utilizados nas ordens corretas
dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

// Varre arquivo de itens de nota fiscal da filial posicionada
dbSelectArea("SD2")
SetRegua(LastRec())
If aReturn[8] == 1 // Ordem por produto 
	dbSetOrder(1)
	cWhile   := "D2_FILIAL+D2_COD"  
	cTexto   := STR0014 //"TOTAL DO PRODUTO EM TRANSITO"
ElseIf aReturn[8] == 2 // Ordem de documento
	dbSetOrder(3)                   
	cWhile   := "D2_FILIAL+D2_DOC+D2_SERIE"  
	cTexto   := STR0015 //"TOTAL DO DOCUMENTO EM TRANSITO"
ElseIf aReturn[8] == 3 // Ordem de data
	dbSetOrder(5)                         
	cWhile   := "D2_FILIAL+DTOS(D2_EMISSAO)"  	
	cTexto   := STR0016 //"TOTAL DA DATA EM TRANSITO"	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega filiais da empresa corrente                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SM0")
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
	// Adiciona filial
	Aadd(aFilsCalc,{alltrim(SM0->M0_CODFIL),SM0->M0_CGC,SM0->M0_FILIAL})
	dbSkip()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre filiais da empresa corrente                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSeek(cEmpAnt)
Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
	cFilAnt:=SM0->M0_CODFIL
	aTotaisGer:= {0,0,0}
	// Filtra filial da nota fiscal de saida
	If cFilAnt < mv_par01 .Or. cFilAnt > mv_par02
		dbSkip()
		Loop
	EndIf
	dbSelectArea("SD2")

	cQuery := "SELECT SD2.D2_FILIAL,SD2.D2_EMISSAO,SD2.D2_DOC,"+ IIF(SerieNfId("SD2",3,"D2_SERIE")<>"D2_SERIE","SD2."+SerieNfId("SD2",3,"D2_SERIE")+","," ")
	cQuery += "SD2.D2_SERIE,SD2.D2_COD,SD2.D2_TES,SD2.D2_CF,SD2.D2_UM,B1_FABRIC,"
	cQuery += "SD2.D2_QUANT,SD2.D2_TOTAL,SD2.D2_CUSTO1,SD2.D2_TIPO,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_LOCAL"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Esta rotina foi escrita para adicionar no select os campos         ³
	//³usados no filtro do usuario quando houver, a rotina acrecenta      ³
	//³somente os campos que forem adicionados ao filtro testando         ³
	//³se os mesmo já existem no select ou se forem definidos novamente   ³
	//³pelo o usuario no filtro, esta rotina acrecenta o minimo possivel  ³
	//³de campos no select pois a tabela SD1 tem muitos campos e a query  |
	//³pode derrubar o TOP CONNECT e abortar o sistema				       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
	aStrucSD2 := SD2->(dbStruct())
		If !Empty(aReturn[7])
		For nX := 1 To SD2->(FCount())
		cName := SD2->(FieldName(nX))
		If AllTrim( cName ) $ aReturn[7]
		    If aStrucSD2[nX,2] <> "M"  
		      	If !cName $ cQuery .And. !cName $ cQryAd
		        	cQryAd += "," + cName 
		        Endif 	
		    EndIf
		EndIf 			       	
		Next nX
     	Endif     
			 
		If !Empty(cQryAd)
			cQuery+= cQryAd
		EndIf	
	lQuery    := .T.
	cAliasSD2 := GetNextAlias()  
	cQuery += " FROM "
	cQuery += RetSqlName("SD2")+" SD2 ,"+RetSqlName("SF4")+" SF4 WHERE SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_ <> '*' AND "
	cQuery += "SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.D_E_L_E_T_ <> '*' AND "
	cQuery += "SF4.F4_TRANFIL = '1' AND SF4.F4_CODIGO = SD2.D2_TES AND "
	cQuery += "SD2.D2_EMISSAO >= '"+DTOS(mv_par03)+"' AND SD2.D2_EMISSAO <= '"+DTOS(mv_par04)+"' AND "
	cQuery += "SD2.D2_DOC >= '"+mv_par05+"' AND SD2.D2_DOC <= '"+mv_par06+"' AND "
	cQuery += "SD2."+SerieNfId("SD2",3,"D2_SERIE")+" >= '"+mv_par07+"' AND SD2."+SerieNfId("SD2",3,"D2_SERIE")+" <= '"+mv_par08+"' AND "
	cQuery += "SD2.D2_COD >= '"+mv_par09+"' AND SD2.D2_COD <= '"+mv_par10+"' "
	cQuery += "ORDER BY " + SqlOrder(SD2->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
	aEval(SD2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAliasSD2,x[1],x[2],x[3],x[4]),Nil)})
	dbSelectArea(cAliasSD2)
	
	Do While !Eof() .And. xFilial("SD2") == D2_FILIAL
		If lEnd
			@ Prow()+1,001 PSAY STR0007 //"CANCELADO PELO OPERADOR"
			Exit
		EndIf
		IncRegua()
		// Valida o Filtro de Usuario
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSkip()
			Loop
		EndIf	  
		// So efetua filtragem caso nao tenha efetuado na query		
		If !lQuery
			// Filtra emissao da nota fiscal de saida
			If D2_EMISSAO < mv_par03 .Or. D2_EMISSAO > mv_par04
				dbSkip()
				Loop
			EndIf
			// Filtra documento da nota fiscal de saida
			If D2_DOC < mv_par05 .Or. D2_DOC > mv_par06
				dbSkip()
				Loop
			EndIf
			// Filtra serie da nota fiscal de saida
			If SerieNfId("SD2",2,"D2_SERIE") < mv_par07 .Or. SerieNfId("SD2",2,"D2_SERIE") > mv_par08
				dbSkip()
				Loop
			EndIf
			// Filtra produto da nota fiscal de saida
			If D2_COD < mv_par09 .Or. D2_COD > mv_par10
				dbSkip()
				Loop
			EndIf
		EndIf
		// Totaliza de acordo com a escolha o usuario
		cSeek := &(cWhile)
		aTotais:={0,0,0}
		Do While !Eof() .And. cSeek  == &(cWhile)

            aAuxExc := {}
			// Valida o Filtro de Usuario
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSkip()
				Loop
			EndIf		
			// So efetua filtragem caso nao tenha efetuado na query
			If !lQuery
				// Filtra emissao da nota fiscal de saida
				If D2_EMISSAO < mv_par03 .Or. D2_EMISSAO > mv_par04
					dbSkip()
					Loop
				EndIf
				// Filtra documento da nota fiscal de saida
				If D2_DOC < mv_par05 .Or. D2_DOC > mv_par06
					dbSkip()
					Loop
				EndIf
				// Filtra serie da nota fiscal de saida
				If SerieNfId("SD2",2,"D2_SERIE") < mv_par07 .Or. SerieNfId("SD2",2,"D2_SERIE") > mv_par08
					dbSkip()
					Loop
				EndIf
				// Filtra produto da nota fiscal de saida
				If D2_COD < mv_par09 .Or. D2_COD > mv_par10
					dbSkip()
					Loop
				EndIf
			EndIf
			// Checa TES
			If lQuery .Or. (!lQuery .And. SF4->(MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES)) .And. SF4->F4_TRANFIL == "1")
				aRetNF:=MR715BuscaNF(aFilsCalc,cAliasSD2,lUsaFilTrf)
				If Len(aRetNF) > 0
					// Checa status de acordo com o parametro
					If mv_par11 == 3 .Or. (mv_par11 == 2 .And. !Empty(aRetNF[3])) .Or. (mv_par11 == 1  .And. Empty(aRetNf[3]))
						// Imprime linha
						If ( li > 58 )
							li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,If(aReturn[4]==1,15,18))
							li++
						Endif

	                    SB1->(MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))
						
						Aadd(aAuxExc,Substr(cFilAnt,1,10))
						
						Aadd(aAuxExc,Substr(SM0->M0_FILIAL,1,15))
						
						Aadd(aAuxExc,Substr((cAliasSD2)->D2_DOC,1,nTamDoc))
                        

						If lTamDoc
							
							Aadd(aAuxExc,Substr((cAliasSD2)->&(SerieNfId("SD2",3,"D2_SERIE")),1,3))
                            Aadd(aAuxExc,Substr((cAliasSD2)->D2_TES,1,3))
                            Aadd(aAuxExc,Substr((cAliasSD2)->D2_CF,1,5))
						Else
							
							Aadd(aAuxExc,Substr((cAliasSD2)->&(SerieNfId("SD2",3,"D2_SERIE")),1,3))
                            Aadd(aAuxExc,Substr((cAliasSD2)->D2_TES,1,3))
                            Aadd(aAuxExc,Substr((cAliasSD2)->D2_CF,1,5))
							nRecnoSF4 := SF4->(Recno())
							SF4->(Dbseek(xFilial("SF4")+(cAliasSD2)->D2_TES))
							
							Aadd(aAuxExc,Substr(SF4->F4_TEXTO,1,18))
							SF4->(dbGoTo(nRecnoSF4))
						EndIf	
						
						Aadd(aAuxExc,Substr((cAliasSD2)->D2_COD,1,15))
                        Aadd(aAuxExc,Substr(SB1->B1_DESC,1,15))
						Aadd(aAuxExc,Alltrim(Posicione("ZPM",1,xFilial("ZPM")+SB1->B1_ZMARCA,"ZPM_DESC")))
						Aadd(aAuxExc,Alltrim((cAliasSD2)->B1_FABRIC))
						Aadd(aAuxExc,Substr(SB1->B1_GRUPO,1,5))
                        Aadd(aAuxExc,Substr((cAliasSD2)->D2_UM,1,2))
						
						If lTamDoc
							
                            Aadd(aAuxExc,(cAliasSD2)->D2_QUANT)
                            Aadd(aAuxExc,(cAliasSD2)->D2_TOTAL)
                            Aadd(aAuxExc,(cAliasSD2)->D2_CUSTO1)
                            Aadd(aAuxExc,(cAliasSD2)->D2_EMISSAO)

							// Imprime informacoes da devolucao
							If !Empty(aRetNf[3])
								
								Aadd(aAuxExc,Substr(aRetNf[1],1,10))
                                Aadd(aAuxExc,Substr(aRetNf[2],1,10))
                                Aadd(aAuxExc,aRetNf[3])
							Else
								
								Aadd(aAuxExc,aRetNf[1])
                                Aadd(aAuxExc,Substr(aRetNf[2],1,10))

								Aadd(aAuxExc,STR0019)

								aTotais[1]+=(cAliasSD2)->D2_QUANT ;aTotaisGer[1]+=(cAliasSD2)->D2_QUANT
								aTotais[2]+=(cAliasSD2)->D2_TOTAL ;aTotaisGer[2]+=(cAliasSD2)->D2_TOTAL
								aTotais[3]+=(cAliasSD2)->D2_CUSTO1;aTotaisGer[3]+=(cAliasSD2)->D2_CUSTO1
							EndIf
						Else
							
							Aadd(aAuxExc,(cAliasSD2)->D2_QUANT)
                            Aadd(aAuxExc,(cAliasSD2)->D2_TOTAL)
                            Aadd(aAuxExc,(cAliasSD2)->D2_CUSTO1)
                            Aadd(aAuxExc,(cAliasSD2)->D2_EMISSAO)

							// Imprime informacoes da devolucao
							If !Empty(aRetNf[3])
								
								Aadd(aAuxExc,Substr(aRetNf[1],1,10))
                                Aadd(aAuxExc,Substr(aRetNf[2],1,10))
                                Aadd(aAuxExc,aRetNf[3])

								//Aadd(aAuxExc,Posicione("SBZ",1,aRetNf[1]+(cAliasSD2)->D2_COD,"BZ_LOCPAD"))
								//Aadd(aAuxExc,Posicione("SBZ",1,aRetNf[1]+(cAliasSD2)->D2_COD,"BZ_XLOCALI"))
								cLocPd := Posicione("SB1",1,aRetNf[1]+(cAliasSD2)->D2_COD,"B1_LOCPAD")
								Aadd(aAuxExc,cLocPd)

								cProdPai := Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_XCODPAI")
								If !Empty(cProdPai)
									cPrat   := Posicione("SBE",7,(cAliasSD2)->D2_FILIAL+cProdPai,"BE_LOCALIZ")
								Else 
									cPrat   := Posicione("SBE",7,(cAliasSD2)->D2_FILIAL+(cAliasSD2)->D2_COD,"BE_LOCALIZ")
								EndIf 

								Aadd(aAuxExc,cPrat)

							Else
								
								Aadd(aAuxExc,aRetNf[1])
                                Aadd(aAuxExc,Substr(aRetNf[2],1,10))

								Aadd(aAuxExc,STR0019)

								Aadd(aAuxExc,'')
								Aadd(aAuxExc,'')
								aTotais[1]+=(cAliasSD2)->D2_QUANT ;aTotaisGer[1]+=(cAliasSD2)->D2_QUANT
								aTotais[2]+=(cAliasSD2)->D2_TOTAL ;aTotaisGer[2]+=(cAliasSD2)->D2_TOTAL
								aTotais[3]+=(cAliasSD2)->D2_CUSTO1;aTotaisGer[3]+=(cAliasSD2)->D2_CUSTO1
							EndIf
						EndIf

						cLocPd := Posicione("SB1",1,aRetNf[1]+(cAliasSD2)->D2_COD,"B1_LOCPAD")
						cProdPai := Posicione("SB1",1,xFilial("SB1")+(cAliasSD2)->D2_COD,"B1_XCODPAI")
						If !Empty(cProdPai)
							cPrat   := Posicione("SBE",7,(cAliasSD2)->D2_FILIAL+cProdPai,"BE_LOCALIZ")
						Else 
							cPrat   := Posicione("SBE",7,(cAliasSD2)->D2_FILIAL+(cAliasSD2)->D2_COD,"BE_LOCALIZ")
						EndIf 
						//Posicione("SBZ",1,(cAliasSD2)->D2_FILIAL+Substr((cAliasSD2)->D2_COD,1,15),"BZ_XLOCALI")

						Aadd(aAuxExc,(cAliasSD2)->D2_LOCAL)
						Aadd(aAuxExc,cPrat)

						li++
						cbCont++
					EndIf
				EndIf

				If len(aAuxExc) > 0
					Aadd(aItensExc,aAuxExc)
				Endif 

			EndIf
			dbSelectArea(cAliasSD2)
			dbSkip()
		EndDo
		
	EndDo
	// Fecha arquivo da query
	If lQuery
		dbSelectArea(cAliasSD2)
		dbCloseArea()
		dbSelectArea("SD2")
	EndIf
	
		
	dbSelectArea("SM0")
	dbSkip()
EndDo
// Restaura filial original
cFilAnt:=cFilBack
RestArea(aAreaSM0)

If cbCont > 0
	Roda(cbCont,cbText,Tamanho)
EndIf

If len(aItensExc) > 0
	GeraExcel(aItensExc)
EndIf 

Set Device To Screen
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ MR715BuscaNF                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 29/01/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Busca as informacoes da nota fiscal de transferencia       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³aFilsCalc  Array com informacoes das filiais da empresa     ³±±
±±³           ³           em uso corrente no sistema.                      ³±±
±±³           ³cAliasSD2  Area do arquivo de itens de NF de saida          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³aRetNF     Array com informacoes da nota de retorno         ³±±
±±³           ³           [1] Codigo da filial que recebeu a nota          ³±±
±±³           ³           [2] Descricao da filial que recebu a nota        ³±±
±±³           ³           [3] Data de digitacao da nota                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ JESTR006                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR715BuscaNF(aFilsCalc,cAliasSD2,lUsaFilTrf)
Local aRetNf      := {"","",""}
Local nAchoCGC    := 0
Local nAchoFil    := 0
Local aArea       := GetArea()
Local cFilBack    := cFilAnt
Local cCGCOrig    := ""
Local cCGCDest    := SM0->M0_CGC
Local cCodFilOrig := ""
Local cCodFilDest := SM0->M0_CODFIL

If !lUsaFilTrf
	// Posiciona no fornecedor
	If (cAliasSD2)->D2_TIPO $ "DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		If MsSeek(xFilial("SA2")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
			cCGCOrig:=SA2->A2_CGC
		EndIf
	Else
		// Posiciona no cliente
		cArqCliFor:="SA1"
		dbSelectArea("SA1")
		dbSetOrder(1)
		If MsSeek(xFilial("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
			cCGCOrig:=SA1->A1_CGC
		EndIf
	EndIf
	
	// Checa se cliente / fornecedor esta configurado como filial do sistema
	If !Empty(cCGCOrig) .And. ((nAchoCGC:=ASCAN(aFilsCalc,{|x| x[2] == cCGCOrig})) > 0)
		// Pesquisa se nota fiscal ja foi registrada no destino
		cFilAnt := aFilsCalc[nAchoCGC,1]
		dbSelectArea("SD1")
		dbSetOrder(2)
		dbSeek(xFilial("SD1")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE)
		While !Eof() .And. xFilial("SD1")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE == D1_FILIAL+D1_COD+D1_DOC+D1_SERIE
			// Checa TES
			If !Empty(SD1->D1_TES)
				If SF4->(MsSeek(xFilial("SF4")+SD1->D1_TES)) .And. SF4->F4_TRANFIL == "1"
					// Itens de nota fiscal de entrada
					If SD1->D1_TIPO $ "DB"
						dbSelectArea("SA1")
						dbSetOrder(1)
						If MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA) .And. SA1->A1_CGC == cCGCDest
							aRetNf:={cFilAnt,aFilsCalc[nAchoCGC,3],SD1->D1_DTDIGIT}
							Exit
						EndIf
					Else
						dbSelectArea("SA2")
						dbSetOrder(1)
						If MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA) .And. SA2->A2_CGC == cCGCDest
							aRetNf:={aFilsCalc[nAchoCGC,1] ,aFilsCalc[nAchoCGC,3],SD1->D1_DTDIGIT}
							Exit
						EndIf
					EndIf
				EndIf
			Else
				// O documento ainda nao foi classificado (pre-nota), portanto o material pode ser considerado "ainda em transito"
				aRetNf:={cFilAnt,aFilsCalc[nAchoCGC,3],''}
			EndIf
			dbSelectArea("SD1")
			dbSkip()
		End
	EndIf
Else
	// Posiciona no fornecedor
	If (cAliasSD2)->D2_TIPO $ "DB"
		dbSelectArea("SA2")
		dbSetOrder(1)
		If MsSeek(xFilial("SA2")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
			cCodFilOrig := SA2->A2_FILTRF
		EndIf
	Else
		// Posiciona no cliente
		cArqCliFor:="SA1"
		dbSelectArea("SA1")
		dbSetOrder(1)
		If MsSeek(xFilial("SA1")+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA)
			cCodFilOrig := SA1->A1_FILTRF
		EndIf
	EndIf
	
	// Checa se cliente / fornecedor esta configurado como filial do sistema
	If !Empty(cCodFilOrig) .And. (nAchoFil := ASCAN(aFilsCalc,{|x| x[1] == alltrim(cCodFilOrig)})) > 0 
		// Pesquisa se nota fiscal ja foi registrada no destino
		cFilAnt := aFilsCalc[nAchoFil,1]
		dbSelectArea("SD1")
		dbSetOrder(2)
		dbSeek(xFilial("SD1")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE)
		While !Eof() .And. xFilial("SD1")+(cAliasSD2)->D2_COD+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE == D1_FILIAL+D1_COD+D1_DOC+D1_SERIE
			// Checa TES
			If !Empty(SD1->D1_TES)
				If SF4->(MsSeek(xFilial("SF4")+SD1->D1_TES)) .And. SF4->F4_TRANFIL == "1"
					// Itens de nota fiscal de entrada
					If SD1->D1_TIPO $ "DB"
						dbSelectArea("SA1")
						dbSetOrder(1)
						If MsSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA) .And. alltrim(SA1->A1_FILTRF) == alltrim(cCodFilDest)
							aRetNf:={cFilAnt,aFilsCalc[nAchoFil,3],SD1->D1_DTDIGIT}
							Exit
						EndIf
					Else
						dbSelectArea("SA2")
						dbSetOrder(1)
						If MsSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA) .And. alltrim(SA2->A2_FILTRF) == alltrim(cCodFilDest)
							aRetNf:={aFilsCalc[nAchoFil,1] ,aFilsCalc[nAchoFil,3],SD1->D1_DTDIGIT}
							Exit
						EndIf
					EndIf
				EndIf
			Else
				// O documento ainda nao foi classificado (pre-nota), portanto o material pode ser considerado "ainda em transito"
				aRetNf:={cFilAnt,aFilsCalc[nAchoFil,3],''}
			EndIf
			dbSelectArea("SD1")
			dbSkip()
		End
	EndIf
EndIf
// Reposiciona area original
cFilAnt:=cFilBack
RestArea(aArea)

RETURN aRetNf 

/*/{Protheus.doc} GeraExcel
	(long_description)
	@type  Static Function
	@author user
	@since 21/01/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function GeraExcel(aItensExc)

Local aHeader := {}
Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Transf_filiais_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
Local cInterno  :=  'Transf_Filiais'

Aadd(aHeader,{  'Filial_Origem',;				//01
				'Descrição_Origem',;			//02
				'Documento',;					//03
				'Serie',;						//04
				'TES_Origem',;					//05
				'CFOP_Origem',;					//06
				'Desc_Oper_Origem',;			//07
				'Produto',;						//08
				'Descricao',;					//09
				'Marca',;						//10
				'Cod.Original',;
				'Grupo',;						//11
				'UM',;							//12
				'Quantidade',;					//13
				'Valor_Total',;					//14
				'Custo_Total',;					//15
				'Data_Emissao',;				//16
				'Filial_Destino',;				//17
				'Descricao_Destino',;			//18
				'Data_Digitação',;				//19
				'Armazem Origem',;				//20
				'Prateleira Origem',;			//21
				'Armazem Destino',;				//22
				'Prateleira Destino'})			//23

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cInterno) 
oExcel:AddTable (cInterno,cInterno)

For nX := 1 to len(aHeader[1])
    oExcel:AddColumn(cInterno,cInterno,aHeader[1,nX],1,1)
Next nX


For nX := 1 to len(aItensExc)
    aAux := {}
    For nY := 1 to len(aHeader[1])
        Aadd(aAux,aItensExc[nX,nY])
    Next nY

    oExcel:AddRow(cInterno,cInterno,aAux)
Next nX


oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	    
Return(cDir+cArqXls)
