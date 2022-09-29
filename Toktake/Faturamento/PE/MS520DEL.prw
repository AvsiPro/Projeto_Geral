#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MS520DEL  ºAutor  ³Jackson E. de Deus  º Data ³  27/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado antes da exclusão do registro da tabela SF2.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento - Exclusão de Doc de Saída                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MS520DEL()

Local alArea := GetArea()
Local aItens := {}
Local aLinha := {}
Local aCabec := {}
Local cFilBkp := cFilAnt
Local lFatOrc := .F.
Local cTM		:= ""	//GetMv( "MV_XTMSD3",,"001" ) 
Local cTMBaixa := ""	//GetMv("MV_XLOG008",,"515")
Local aMata240 := {}
Private lMsErroAuto := .F.


// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf


cTM		:= GetMv( "MV_XTMSD3",,"001" ) 
cTMBaixa := GetMv("MV_XLOG008",,"515")


/*
Conforme o PE SF2460I, ao faturar uma NF de transferência é gerado automaticamente
a NF de Pré-Nota na filial de destino, conforme campo F2_XTRANSF.
A customização a seguir serve para excluir também a Pré-Nota na filial de destino.
Jackson E. de Deus 01/03/2013
*/
If cEmpAnt == "01"
	If !Empty(SF2->F2_XTRANSF)	
		dbSelectArea("SF1")
		alAreaSF1 := GetArea()
		dbSetOrder(1)			// Filial + Doc + Serie + Fornecedor + Loja + Tipo
		If MSSeek( SF2->F2_XTRANSF +AvKey( SF2->F2_DOC,"F1_DOC" ) +AvKey( SF2->F2_SERIE,"F1_SERIE" ) +AvKey( SF2->F2_CLIENTE,"F1_FORNECE" ) +AvKey( SF2->F2_LOJA,"F1_LOJA" ) +AvKey( SF2->F2_TIPO,"F1_TIPO" ) )
			If AllTrim(SF1->F1_STATUS) <> "A"
				dbSelectArea("SD1")
				alAreaSD1 := GetArea()
				dbSetOrder(1)  			// Filial + Doc + Serie + Fornecedor + Loja + Produto + Item NF		
				If dbSeek( SF2->F2_XTRANSF + AvKey( SF1->F1_DOC,"F1_DOC" )  + AvKey( SF1->F1_SERIE,"F1_SERIE" ) +AvKey( SF1->F1_FORNECE,"F1_FORNECE" ) +AvKey( SF1->F1_LOJA,"F1_LOJA" ) )
					While SD1->( !EoF() ) .And. SF1->F1_FILIAL == SD1->D1_FILIAL .And. SF1->F1_DOC == SD1->D1_DOC .And.;
												SF1->F1_SERIE == SD1->D1_SERIE .And. SF1->F1_FORNECE == SD1->D1_FORNECE .And.;
												SF1->F1_LOJA == SD1->D1_LOJA
						
						// itens nf
						AADD(aLinha	,{"D1_FILIAL"	, SD1->D1_FILIAL								, Nil})
						AADD(aLinha	,{"D1_TIPO"		, SD1->D1_TIPO									, Nil})
						AADD(aLinha	,{"D1_DOC"		, SD1->D1_DOC									, Nil})
						AADD(aLinha	,{"D1_SERIE"	, SD1->D1_SERIE									, Nil})
						AADD(aLinha	,{"D1_FORNECE"	, SD1->D1_FORNECE								, Nil})
						AADD(aLinha	,{"D1_LOJA"		, SD1->D1_LOJA									, Nil})
						AADD(aLinha	,{"D1_ITEM"		, SD1->D1_ITEM									, Nil})
						AADD(aLinha	,{"D1_COD"		, SD1->D1_COD									, Nil})
					
						Aadd(aItens,aLinha)
						aLinha := {}
						SD1->(dbSkip())
					End
				EndIf
				
				// cabecalho nf
				AADD(aCabec,	{"F1_FILIAL"	, SF1->F1_FILIAL		,NIL})
				AADD(aCabec,	{"F1_TIPO"		, SF1->F1_TIPO			,NIL})
				AADD(aCabec,	{"F1_DOC"		, SF1->F1_DOC			,NIL})
				AADD(aCabec,	{"F1_SERIE"		, SF1->F1_SERIE			,NIL})
				AADD(aCabec,	{"F1_FORNECE"	, SF1->F1_FORNECE		,NIL})
				AADD(aCabec,	{"F1_LOJA"		, SF1->F1_LOJA			,NIL})
				
				cFilAnt := SF2->F2_XTRANSF
				MATA140(aCabec, aItens, 5)
				cFilAnt := cFilBkp
			EndIf	
		EndIf
	EndIf
	
	/*
	MOVIMENTACAO PA - BAIXA DAS MERCADORIAS
	Jackson E. de Deus 15/05/2015
	*/
	/*If AllTrim(SF2->F2_TIPO) == "N" .And. !Empty(SF2->F2_XCODPA) .And. AllTrim(SF2->F2_XFINAL) == "4" .And. AllTrim(SF2->F2_XNFABAS) == "1"
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		If dbSeek( xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA )
			While SD2->D2_FILIAL == SF2->F2_FILIAL .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And. ;
					SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA .And. SD2->(!EOF())
			 	
			 	// verifica entrada na PA
			 	If STATICCALL( TTFAT19C,CHKMOV,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SD2->D2_ITEM,SD2->D2_COD,SF2->F2_XCODPA,SD2->D2_QUANT,SF2->F2_EMISSAO,cTM )
			 		// verifica se ainda nao deu baixa da PA
			 		If !STATICCALL( TTFAT19C,CHKMOV,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,SD2->D2_ITEM,SD2->D2_COD,SF2->F2_XCODPA,SD2->D2_QUANT,SF2->F2_EMISSAO,cTMBaixa )
				 		aMata240 := {}
						aAdd(aMata240, {})
						aAdd(aMata240[1], {'D3_TM'     ,cTMBaixa	   ,Nil})
						aAdd(aMata240[1], {'D3_COD'    ,SD2->D2_COD    ,Nil})
						aAdd(aMata240[1], {'D3_UM'     ,SD2->D2_UM     ,Nil})
						aAdd(aMata240[1], {'D3_QUANT'  ,SD2->D2_QUANT  ,Nil})
						aAdd(aMata240[1], {'D3_LOCAL'  ,SF2->F2_XCODPA ,Nil})
						aAdd(aMata240[1], {'D3_EMISSAO',SD2->D2_EMISSAO,Nil})
						aAdd(aMata240[1], {'D3_DOC'    ,SD2->D2_DOC    ,Nil})
						aAdd(aMata240[1], {'D3_CONTA'  ,SD2->D2_CONTA  ,Nil})
						aAdd(aMata240[1], {'D3_CC'     ,SD2->D2_CCUSTO ,Nil})
						aAdd(aMata240[1], {'D3_CLVL'   ,SD2->D2_CLVL   ,Nil})
						aAdd(aMata240[1], {'D3_ITEMCTA',SD2->D2_ITEMCC ,Nil})
						aAdd(aMata240[1], {'D3_XNUMNF' ,SD2->D2_DOC    ,Nil})
						aAdd(aMata240[1], {'D3_XSERINF',SD2->D2_SERIE  ,Nil})
						aAdd(aMata240[1], {'D3_XCLIENT',SD2->D2_CLIENTE,Nil})
						aAdd(aMata240[1], {'D3_XLOJCLI',SD2->D2_LOJA   ,Nil})
						aAdd(aMata240[1], {'D3_XITEMNF',SD2->D2_ITEM   ,Nil})
						aAdd(aMata240[1], {'D3_XSLDONF',SD2->D2_QUANT  ,Nil})
						aAdd(aMata240[1], {'D3_XORIGEM',"MS520DEL"	   ,Nil})
						
						lMsErroAuto := .F.
						MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
						If lMsErroAuto
							conout("# MS520DEL -> ERRO AO BAIXAR ESTOQUE DA PA : " +SF2->D2_DOC + "/" +SF2->F2_SERIE)
						EndIf
					EndIf
			 	EndIf
			 	
				dbSelectArea("SD2")
				SD2->(dbSkip())
			End
		EndIf			
	EndIf*/
EndIf
			
RestArea(alArea)

Return NIL