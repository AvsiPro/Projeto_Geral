#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCOMC13  ºAutor  ³Jackson E. de Deus  º Data ³  07/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao de pre nota de devolucao                            º±±
±±º          ³com base em uma nota de saida                               º±±
±±º          ³A nota pode ser total ou parcial                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³07/11/14³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTCOMC13(cNumNF,cSerie,cCliente,cLoja,axItens)
           
Local lRet := .F.  
Local cSql := ""
Local nRecSF2 := 0
Local lGeraLog := FindFunction("U_TTGENC01")
Local lItemParc := .F.
Local cTpDev := ""
Private lMsErroAuto := .F.
Private aCabec		:= {}
Private aItens		:= {}
Private aLinha		:= {}
Private aRotina		:= {{"Visualizar"	,"A103NFiscal('SF1',Recno(),2)"	,0,1}}
Default cNumNF := ""
Default cSerie := ""
Default cCliente := ""
Default cLoja := ""
Default axItens := {}

If cEmpAnt == "01"
	
	//Prepare Environment Empresa "01" filial "01"
	If Empty(cNumNF) .Or. Empty(cSerie) .Or. Empty(cCliente) .Or. Empty(cLoja)
		Conout("# TTCOMC13 - " +"Verificar parametros de entrada -> "  +cNumNF +"/" +cSerie +" #")
		Return lRet
	EndIf
	
	dbSelectArea("SF2")
	dbSetOrder(2)	// CLIENTE LOJA NF SERIE
	If !dbSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
		Conout("# TTCOMC13 - " +"Nota de saida nao encontrada -> "  +cNumNF +"/" +cSerie +" - Cliente " +cCliente +"/" +cLoja  +" #")
		Return lRet
	EndIf                                                                                                                               
	
	nRecSF2 := Recno()
	
	If Len(axItens) > 0
		lItemParc := .T.
	EndIf
	
	// Cabecalho da nota
	AADD(aCabec,	{"F1_TIPO"		, "D"					,NIL})
	AADD(aCabec,	{"F1_FORMUL"	, "S"					,NIL})
	AADD(aCabec,	{"F1_DOC"		, cNumNF				,NIL})
	AADD(aCabec,	{"F1_SERIE"		, cSerie				,NIL})
	AADD(aCabec,	{"F1_EMISSAO"	, SF2->F2_EMISSAO		,NIL})
	AADD(aCabec,	{"F1_FORNECE"	, cCliente				,NIL})
	AADD(aCabec,	{"F1_LOJA"		, cLoja					,NIL})
	AADD(aCabec,	{"F1_ESPECIE"	, SF2->F2_ESPECIE		,NIL})
	AADD(aCabec,	{"F1_EST"		, SF2->F2_EST			,NIL})
	AADD(aCabec,	{"F1_SEGURO"	, SF2->F2_SEGURO		,NIL})
	AADD(aCabec,	{"F1_FRETE"		, SF2->F2_FRETE			,NIL})
	AADD(aCabec,	{"F1_VALMERC"	, SF2->F2_VALMERC		,NIL})
	AADD(aCabec,	{"F1_VALBRUT"	, SF2->F2_VALBRUT		,NIL})
	
	// Itens da nota  
	cSql := "SELECT D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_LOCAL, D2_DOC, D2_SERIE "
	cSql += " FROM " +RetSqlName("SF2") +" F2 "
	cSql += "INNER JOIN " +RetSqlName("SD2") +" D2 ON "
	cSql += "F2.F2_FILIAL = D2.D2_FILIAL "
	cSql += "AND F2.F2_DOC = D2.D2_DOC "
	cSql += "AND F2.F2_SERIE = D2.D2_SERIE "
	cSql += "AND F2.F2_CLIENTE = D2.D2_CLIENTE "
	cSql += "AND F2.F2_LOJA = D2.D2_LOJA "
	cSql += "AND D2.D_E_L_E_T_ = '' "
	cSql += "WHERE "
	cSql += " F2_FILIAL = '"+xFilial("SF2")+"' "
	cSql += "AND F2_DOC = '"+cNumNf+"' AND F2_SERIE = '"+cSerie+"' AND F2_CLIENTE = '"+cCliente+"' AND F2_LOJA = '"+cLoja+"' "
	cSql += "ORDER BY D2_ITEM, D2_COD"
	
	If Select("TRB") > 0
		TRB->(dbcloseArea())
	EndIf                  
	
	TcQuery cSql New Alias "TRB"
	dbSelectArea("TRB")
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
		
		AADD(aLinha	,{"D1_FILIAL"	, TRB->D2_FILIAL								, Nil})
		AADD(aLinha	,{"D1_TIPO"		, "D"											, Nil})
		AADD(aLinha	,{"D1_DOC"		, cNumNF										, Nil})
		AADD(aLinha	,{"D1_SERIE"	, cSerie										, Nil})
		AADD(aLinha	,{"D1_FORNECE"	, TRB->D2_CLIENTE								, Nil})
		AADD(aLinha	,{"D1_LOJA"		, TRB->D2_LOJA									, Nil})
		AADD(aLinha	,{"D1_ITEM"		, STRZERO(Val(TRB->D2_ITEM),TamSx3("D1_ITEM")[1]), Nil})
		AADD(aLinha	,{"D1_COD"		, TRB->D2_COD									, Nil})
		AADD(aLinha	,{"D1_QUANT"	, nQuant										, Nil})
		AADD(aLinha	,{"D1_VUNIT"	, TRB->D2_PRCVEN								, Nil})
		AADD(aLinha	,{"D1_TOTAL"	, nTotal										, Nil})
		AADD(aLinha	,{"D1_LOCAL"	, TRB->D2_LOCAL									, Nil})
		AADD(aLinha	,{"D1_NFORI"	, TRB->D2_DOC							   		, Nil})
		AADD(aLinha	,{"D1_SERIORI"	, TRB->D2_SERIE									, Nil})
		AADD(aLinha	,{"D1_ITEMORI"	, TRB->D2_ITEM									, Nil})
		AADD(aLinha	,{"AUTDELETA"	, "N"											, Nil}) 
		
		Aadd(aItens,aLinha)
					
		TRB->(dbSkip())
	End
	
	If Empty(aCabec) .Or. Empty(aItens)
		Conout("# TTCOMC13 - " +"Os arrays para ExecAuto sao invalidos" +" #")
		Return lRet
	EndIf
	
	MATA140(aCabec, aItens, 3)   
	
	If !lMsErroAuto
		If !lItemParc
			cTpDev := "1"	// devolucao total
		Else
			cTpDev := "2"	// devolucao parcial
		EndIf
			
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
		lRet := .T.
		U_TTGENC01( xFilial("SZG"),"TTCOMC13","ORDEM DE SERVICO","",cNumNf,cSerie,"WS",dtos(date()),time(),,"Nota de devolucao gerada",,,"SF1" )
	Else
		U_TTGENC01( xFilial("SZG"),"TTCOMC13","ORDEM DE SERVICO","",cNumNf,cSerie,"WS",dtos(date()),time(),,"Erro na geracao da nota de devolucao",,,"SF1" )
	EndIf
EndIf

Return lRet