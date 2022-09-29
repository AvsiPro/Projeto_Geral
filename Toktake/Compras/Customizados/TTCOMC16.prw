#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCOMC16  ºAutor  ³Jackson E. de Deus  º Data ³  06/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao de pre nota de devolucao                            º±±
±±º          ³com base em uma nota de saida                               º±±
±±º          ³Controle de Entregas			                              º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³06/04/15³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTCOMC16( cNumNF,cSerie,cCliente,cLoja,axItens )
           
Local lRet			:= .F.  
Local cSql			:= ""
Local nRecSF2		:= 0
Local lGeraLog		:= FindFunction("U_TTGENC01")
Local lItemParc		:= .F.
Local cTpDev		:= ""
Local nItem			:= 0
Local nTotNF		:= 0
Local cNFDev		:= ""
Local cAliasXF		:= ""
Local cTpNF			:= If(cEmpAnt == "01",SuperGetMV("MV_XLOG010",.T.,"1"),"")	// 1 = pre nota | 2 = nota classificada
Local nRecnoSF1		:= 0
Private lMsErroAuto	:= .F.
Private aCabec		:= {}
Private aItens		:= {}
Private aLinha		:= {}
Default cNumNF		:= ""
Default cSerie		:= ""
Default cCliente	:= ""
Default cLoja		:= ""
Default axItens		:= {}

If cEmpAnt == "01"
	
	//prepare environment empresa "01" filial "01"
	//cTpNF			:= SuperGetMV("MV_XLOG010",.T.,"1")	// 1 = pre nota | 2 = nota classificada
	If Empty(cNumNF) .Or. Empty(cSerie) .Or. Empty(cCliente) .Or. Empty(cLoja)
		Conout("# TTCOMC16 - " +"Verificar parametros de entrada -> "  +cNumNF +"/" +cSerie +" #")
		Return 0
	EndIf
	
	dbSelectArea("SF2")
	dbSetOrder(2)	// CLIENTE LOJA NF SERIE
	If !dbSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
		Conout("# TTCOMC16 - " +"Nota de saida nao encontrada -> "  +cNumNF +"/" +cSerie +" - Cliente " +cCliente +"/" +cLoja  +" #")
		Return 0
	EndIf                                                                                                                               
	
	nRecSF2 := Recno()
	
	If Len(axItens) > 0
		lItemParc := .T.
	EndIf
	
	dbSelectArea("SF1")
	dbSetOrder(1)	// forn loja nf serie tipo
	If dbSeek( xFilial("SF2") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey("D","F1_TIPO")  )
		Conout("# TTCOMC16 - " +"Nota de devolucao ja lancada -> "  +cNumNF +"/" +cSerie +" - Cliente " +cCliente +"/" +cLoja  +" #")
		Return 0
	EndIf   
	
	
	// Itens da nota  
	cSql := "SELECT D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_LOCAL, D2_DOC, D2_SERIE,F4_TESDV "
	cSql += " FROM " +RetSqlName("SF2") +" F2 "
	cSql += "INNER JOIN " +RetSqlName("SD2") +" D2 ON "
	cSql += "F2.F2_FILIAL = D2.D2_FILIAL "
	cSql += "AND F2.F2_DOC = D2.D2_DOC "
	cSql += "AND F2.F2_SERIE = D2.D2_SERIE "
	cSql += "AND F2.F2_CLIENTE = D2.D2_CLIENTE "
	cSql += "AND F2.F2_LOJA = D2.D2_LOJA "
	cSql += "AND D2.D_E_L_E_T_ = '' " 
	cSql += "INNER JOIN " +RetSqlName("SF4") +" F4 ON F4_FILIAL = F2_FILIAL AND F4_CODIGO = D2_TES AND F4.D_E_L_E_T_ = ''
	cSql += "WHERE "
	cSql += " F2_FILIAL = '"+xFilial("SF2")+"' "
	cSql += "AND F2_DOC = '"+cNumNf+"' AND F2_SERIE = '"+cSerie+"' AND F2_CLIENTE = '"+cCliente+"' AND F2_LOJA = '"+cLoja+"' "
	cSql += "ORDER BY D2_ITEM, D2_COD"
	
	If Select("TRB") > 0
		TRB->(dbcloseArea())
	EndIf                  
	
	TcQuery cSql New Alias "TRB"
	dbSelectArea("TRB")
	
	cAliasXF := "2  " +xFilial("SF1") +"\system\SF2" +cEmpAnt +"0                               "
	cNFDev :=  GetSxeNum("NFF","F2_DOC",cAliasXF) // GetSx8Num("SF2","F2_DOC")
	While !EOF()      	
		aItem := {}
		
		If lItemParc // item quantidade
			// compara item e codigo
			nPos := Ascan( axItens, { |x| Val(x[1]) == Val(TRB->D2_ITEM) } )
			If nPos == 0
				TRB->(dbSkip())
				Loop
			EndIf
			
			nQuant := axItens[nPos][2]
			nTotal := Round( axItens[nPos][2]*TRB->D2_PRCVEN,2 )
		Else
			nQuant := TRB->D2_QUANT
			nTotal := TRB->D2_TOTAL
		EndIf
		
		nItem++
		
		AADD(aLinha	,{"D1_FILIAL"	, TRB->D2_FILIAL								, Nil})
		AADD(aLinha	,{"D1_TIPO"		, "D"											, Nil})
		AADD(aLinha	,{"D1_DOC"		, cNFDev										, Nil})
		AADD(aLinha	,{"D1_SERIE"	, cSerie										, Nil})
		AADD(aLinha	,{"D1_FORNECE"	, TRB->D2_CLIENTE								, Nil})
		AADD(aLinha	,{"D1_LOJA"		, TRB->D2_LOJA									, Nil})
		AADD(aLinha	,{"D1_ITEM"		, STRZERO(nItem,TamSx3("D1_ITEM")[1])			, Nil})
		AADD(aLinha	,{"D1_COD"		, TRB->D2_COD									, Nil})
		AADD(aLinha	,{"D1_QUANT"	, nQuant										, Nil})
		AADD(aLinha	,{"D1_VUNIT"	, TRB->D2_PRCVEN								, Nil})
		AADD(aLinha	,{"D1_TOTAL"	, nTotal										, Nil})
		AADD(aLinha	,{"D1_LOCAL"	, TRB->D2_LOCAL									, Nil})
		AADD(aLinha	,{"D1_NFORI"	, TRB->D2_DOC							   		, Nil})
		AADD(aLinha	,{"D1_SERIORI"	, TRB->D2_SERIE									, Nil})
		AADD(aLinha	,{"D1_ITEMORI"	, TRB->D2_ITEM									, Nil})
		
		If cTpNF == "2"
			AADD(aLinha	,{"D1_TES"	, TRB->F4_TESDV									, Nil})	
		EndIf
		
		AADD(aLinha	,{"AUTDELETA"	, "N"											, Nil}) 
		
		nTotNF += nTotal
		
		Aadd(aItens,aLinha)
		aLinha := {}
					
		TRB->(dbSkip())
	End
	
	
	// Cabecalho da nota
	AADD(aCabec,	{"F1_TIPO"		, "D"					,NIL})
	AADD(aCabec,	{"F1_FORMUL"	, "S"					,NIL})
	AADD(aCabec,	{"F1_DOC"		, cNFDev				,NIL})
	AADD(aCabec,	{"F1_SERIE"		, cSerie				,NIL})
	AADD(aCabec,	{"F1_EMISSAO"	, dDatabase				,NIL})
	AADD(aCabec,	{"F1_FORNECE"	, cCliente				,NIL})
	AADD(aCabec,	{"F1_LOJA"		, cLoja					,NIL})
	AADD(aCabec,	{"F1_ESPECIE"	, SF2->F2_ESPECIE		,NIL})
	AADD(aCabec,	{"F1_EST"		, SF2->F2_EST			,NIL})
	AADD(aCabec,	{"F1_SEGURO"	, SF2->F2_SEGURO		,NIL})
	AADD(aCabec,	{"F1_FRETE"		, SF2->F2_FRETE			,NIL})
	AADD(aCabec,	{"F1_VALMERC"	, nTotNF				,NIL})
	AADD(aCabec,	{"F1_VALBRUT"	, nTotNF				,NIL})
	
	If Empty(aCabec) .Or. Empty(aItens)
		Conout("# TTCOMC16 - " +"Os arrays para ExecAuto sao invalidos" +" #")
		Return nRecnoSF1
	EndIf
	
	If cTpNF == "1"
		MATA140(aCabec, aItens, 3)   
	ElseIf cTpNF == "2"
		MATA103(aCabec, aItens, 3)   
	EndIf              
	
	If !lMsErroAuto
		ConfirmSx8()
		If !lItemParc
			cTpDev := "1"	// devolucao total
		Else
			cTpDev := "2"	// devolucao parcial
		EndIf
		nRecnoSF1 := SF1->(Recno())
		dbSelectArea("SF2")
	    If FieldPos("F2_XDEVENT") > 0
	   		dbGoTo(nRecSF2)
	   		If Recno() == nRecSF2
				If Reclock("SF2",.F.)
					SF2->F2_XDEVENT := cTpDev
					MsUnLock()
				EndIf
			EndIf	
		EndIf
		U_TTGENC01( xFilial("SZG"),"TTCOMC16","ORDEM DE SERVICO","",cNumNf,cSerie,"WS",dtos(date()),time(),,"Nota de devolucao gerada",,,"SF1" )
		
	Else
		RollBackSx8()
		U_TTGENC01( xFilial("SZG"),"TTCOMC16","ORDEM DE SERVICO","",cNumNf,cSerie,"WS",dtos(date()),time(),,"Erro na geracao da nota de devolucao",,,"SF1" )
	EndIf
EndIf

Return nRecnoSF1