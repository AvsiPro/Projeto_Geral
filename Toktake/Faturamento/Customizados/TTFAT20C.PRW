#include "protheus.ch" 
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC20บAutor  ณJackson E. de Deus    บ Data ณ  27/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa OS para geracao de orcamento						  บฑฑ
ฑฑบ          ณAbastecimento												  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ27/04/15ณ01.00 |Criacao                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TTFAT20C(cNumOS,lReproc)

Local aRet			:= {"",""}
Local cNumOrc		:= ""	// PE
Local cNumOrc2		:= ""	// PP
Local cNumPed		:= ""
Local cItem			:= "00"
Local cLocal		:= ""
Local cProduto		:= ""
Local nQuant		:= 0
Local nPreco		:= 0
Local cObsItem		:= ""
Local cPatrim		:= ""
Local dDtFim		:= stod("")
Local axItens		:= {}
Local cCodCli		:= ""
Local cLoja			:= ""  
Local nMaxBt1		:= 25	// posicao maxima dos botoes bebida quente
Local nMaxBt2		:= 60	// posicao maxima dos botoes
Local aPs			:= {}
Local nI			:= 0
Local nJ			:= 0
Local cFamili		:= ""
Local nPos			:= 0
Local nPosMola		:= 0
Local cPosBot		:= 0
Local cPosBotX		:= 0
Local cSql 			:= ""
Local nBotAnt		:= 0
Local nBotAtu		:= 0
Local aAux			:= {}
Local nRecSZN		:= 0
Local cTabela		:= ""
Local aAuxAgl		:= {} 
Local aProd1		:= {}
Local aProd2		:= {}
Local aTabPrc		:= {}
Local lExistOrc		:= .F.
Local lExistPed		:= .F.
Local axCab			:= {}	//{ {"C5_XFINAL","J"} }
Local lJob			:= .F.
Local cPedFech		:= ""
Local lGerarPed		:= .F.
Default cNumOS		:= ""
Default lReproc		:= .F.

If cEmpAnt <> "01"
	Return
EndIf

If Type("cEmpAnt") == "U"
	lJob := .T.
	prepare environment empresa "01" filial "01"
EndIf

If Empty(cNumOS)
	Conout( "#TTFAT20C -> PARAMETROS INVALIDOS" )
	Return aRet
EndIf 

dbSelectArea("SZG")
dbSetOrder(1)
If !dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	Conout( "#TTFAT20C -> OS MOBILE NAO ENCONTRADA: " +cNumOS )	
	Return aRet
EndIf

If .NOT. CVALTOCHAR(SZG->ZG_TPFORM) $ "4|8|18|19|21|22"
	Conout( "#TTFAT20C -> OS MOBILE INVALIDA: " +cNumOS )	
	Return aRet	
EndIf

cCodCli := SZG->ZG_CLIFOR
cLoja := SZG->ZG_LOJA
cPatrim := SZG->ZG_PATRIM
dDtFim := SZG->ZG_DATAFIM

dbSelectArea("SZN")
dbSetOrder(4)
If !dbSeek( xFilial("SZN") +AvKey(cNumOS,"ZN_NUMOS") )
	Conout( "#TTFAT20C -> OS MOBILE NAO ENCONTRADA EM CONTADORES: " +cNumOS )	
	Return aRet
EndIf

// valida contadores
If SZN->ZN_VALIDA <> "O"
	Conout( "#TTFAT20C -> CONTADORES INVALIDOS: " +cNumOS )	
	Return aRet
EndIf

ChkProc(cNumOS,@lExistOrc,@lExistPed,@cPedFech)
If ( lExistOrc .And. !lReproc ) .OR. !Empty(cPedFech)
	Return aRet
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
If !dbSeek( xFilial("SA1")+AvKey(cCodCli,"A1_COD")+AvKey(cLoja,"A1_LOJA") )
	Conout( "#TTFAT20C -> CLIENTE NAO ENCONTRADO - " +cCodCli +"/" +cLoja )
	Return aRet
EndIf

dbSelectArea("SN1")
dbSetOrder(2)
If !dbSeek( xFilial("SN1") +AvKey(cPatrim,"N1_CHAPA") )
	Conout( "#TTFAT20C -> PATRIMONIO NAO ENCONTRADO: " +cPatrim )
	Return aRet	
EndIf
         

lGerarPed := SuperGetMV("MV_XFAT010",.F.,.F.)


// definicao dos produtos     
cProduto := SN1->N1_PRODUTO
cTabela := SZG->ZG_TABELA
cLocal := SN1->N1_XPA

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek( xFilial("SB1") +AvKey(cProduto,"B1_COD") )
	cFamili := AllTrim(SB1->B1_XFAMILI)
EndIf                                  

/*
//ฺฤฤฤฤฤฤฤฟ
//ณConsumoณ
//ภฤฤฤฤฤฤฤู
*/
// bebida quente
If cFamili == "153"	
	// botoes da maquina                   
	dbSelectArea("SN1")
	For nI := 1 To nMaxBt1
		If !Empty( &("SN1->N1_XP" +CVALTOCHAR(nI)) )
			AADD( aPs, { CVALTOCHAR(nI), &("SN1->N1_XP" +CVALTOCHAR(nI)), 0 } )
		EndIf
	Next nI
	If !Empty(aPs)
		dbSelectArea("SZN")
	
		For nI := 1 To Len(aPs)      
			cPosBot := PadL( aPs[nI][1], 2, "0" )
			For nJ := 1 To nMaxBt1
				If !Empty( &("SZN->ZN_BOTAO"+cPosBot) )
					aPs[nI][3] := &("SZN->ZN_BOTAO"+cPosBot)	// qtd vendida da dose 
				EndIf 
			Next nJ
		Next nI
		nNumAtu := SZN->ZN_NUMATU

		// verificar lancamento anterior
		cSql := "SELECT TOP 5 ZN_NUMATU NUMATU, R_E_C_N_O_ ZNREC, ZN_TRPLACA FROM " +RetSqlName("SZN")
		cSql += " WHERE ZN_FILIAL = '"+xFilial("SZN")+"' AND ZN_PATRIMO = '"+cPatrim+"' AND ZN_NUMOS <> '"+cNumOs+"' "
		cSql += " AND ZN_DATA <= '"+DTOS(dDtFim)+"' "
		cSql += " AND ZN_NUMATU <= '"+cvaltochar(nNumAtu)+"' AND D_E_L_E_T_ = '' AND ZN_VALIDA <> 'X' "
		cSql += " AND ZN_TIPINCL IN ('LEITURA CF','ABASTEC','INSTALACAO','REMOCAO') "
		cSql += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC "	// ajustar essa consulta - mesmo problema dos contadores
		
		If Select("TRBZ") > 0
			TRBZ->(dbCloseArea())
		EndIf
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBZ",.F.,.T.)
		dbSelectArea("TRBZ")                                                
		/*
		While !EOF()
			AADD( aAux, { TRBZ->NUMATU, TRBZ->ZNREC }  )
			dbSkip()
		End                                                
		*/
		If Empty(TRBZ->ZN_TRPLACA)
			AADD( aAux, { TRBZ->NUMATU, TRBZ->ZNREC }  )
		Else 
			If AllTrim(TRBZ->ZN_TRPLACA) == "1"	// placa antiga?
				While !EOF()
					If AllTrim(TRBZ->ZN_TRPLACA) == "2" .Or. Empty(TRBZ->ZN_TRPLACA)	// placa nova ou sem reg de troca
						AADD( aAux, { TRBZ->NUMATU, TRBZ->ZNREC }  )
						Exit
					EndIf	
					dbSkip()    
				End			
			EndIf	
		EndIf 
		If !Empty(aAux)
			aSort( aAux,,,{ |x,y| x[1] > y[1] } ) 
			nRecSZN := aAux[1][2]
		EndIf
		
		dbSelectArea("SZN")
		dbGoTo(nRecSZN)
		If Recno() == nRecSZN
			For nI := 1 To Len(aPs)
				cPosBotX := PadL( aPs[nI][1], 2, "0" )                      
				nBotAtu := aPs[nI][3] 
				nBotAnt := &("SZN->ZN_BOTAO"+CVALTOCHAR(cPosBotX))
				If nBotAtu >= nBotAnt
					aPs[nI][3] := nBotAtu - nBotAnt
				EndIf
			Next nI		
		EndIf
	EndIf
// LA
Else
	// botoes da maquina - VERIFICAR ABASTECIMENTO ANTERIOR PARA TER A DIFERENCA DA VENDA                  
	//dbSelectArea("SN1")
	cSql := "SELECT ZH_MOLA, ZH_CODPROD FROM " +RetSqlName("SZH")
	cSql += " WHERE ZH_CHAPA = '"+cPatrim+"' AND ZH_STATUS = '3' AND D_E_L_E_T_ = '' ORDER BY ZH_MOLA " 
	If Select("TRBZ") > 0
		TRBZ->(dbCloseArea())
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBZ",.F.,.T.)
	dbSelectArea("TRBZ")
	While !EOF()
		AADD( aPs, { TRBZ->ZH_MOLA, TRBZ->ZH_CODPROD, 0 } )
		dbSkip()
	End
	/*
	For nI := 1 To nMaxBt2
		If !Empty( &("SN1->N1_XP" +CVALTOCHAR(nI)) )
			AADD( aPs, { CVALTOCHAR(nI), &("SN1->N1_XP" +CVALTOCHAR(nI)), 0 } )
		EndIf
	Next nI
	*/
	
	cSql := "SELECT * FROM " +RetSqlName("SZ0")
	cSql += " WHERE Z0_FILIAL = '"+xFilial("SZ0")+"' AND Z0_NUMOS = '"+cNumOS+"' AND Z0_CHAPA = '"+cPatrim+"' AND D_E_L_E_T_ = '' "
	cSql += " ORDER BY Z0_PRODUTO "
	If Select("TRBX") > 0
		TRBX->(dbCloseArea())
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBX",.F.,.T.)
	dbSelectArea("TRBX")
	While !EOF()
		nPosMola := Ascan( aPs, { |x| AllTrim(x[1]) == AllTrim(TRBX->Z0_MOLA) .And. AllTrim(x[2]) == AllTrim(TRBX->Z0_PRODUTO)  } )
		If nPosMola > 0
			If TRBX->Z0_SLDMOV - TRBX->Z0_SALDO > 0
				nVendAnt := VendAnt( cPatrim, TRBX->Z0_MOLA, TRBX->Z0_PRODUTO, dDtFim, cNumOS )

				dbSelectArea("TRBX")
				aPs[nPosMola][3] := nVendAnt //( TRBX->Z0_SLDMOV - TRBX->Z0_SALDO ) - nVendAnt
			EndIf
		EndIf
		dbSelectArea("TRBX")
		dbSkip()
	End
EndIf

For nI := 1 To Len(aPs)
	If AllTrim(aPS[nI][2]) == "CORINGA"
		Loop
	EndIf
	If aPs[nI][3] > 0
		AADD( axItens, { aPs[nI][2], aPs[nI][3] } ) // produto qtd
	EndIf
Next nI

// verificar se nao encontrar venda anterior ??
If Empty(axItens)
	Conout("#TTFAT20C - SEM ITENS PARA FATURAR " +cNumOs)
	
	// EXCLUIR ORCAMENTO CASO SEJA REPROCESSAMENTO E NAO ENCONTRAR CONTADORES
	If lReproc	
		If Empty(cPedFech)
			ExcluiOrc(cNumOS)
		EndIf
	EndIf
		
	Return aRet
EndIf

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAglutina produtos repetidosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
aAuxAgl := {}
For nI := 1 To Len(axItens)
	If AScan( aAuxAgl, { |x| AllTrim(x[1]) == axItens[nI][1] } ) == 0
		AADD( aAuxAgl, { axItens[nI][1], axItens[nI][2] } )
	EndIf
Next nI 
                               
For nI := 1 To Len(aAuxAgl)
	nQuant := 0
	For nJ := 1 To Len(axItens)
		If aAuxAgl[nI][1] <> axItens[nJ][1]
			Loop
		EndIf                 
		nQuant += axItens[nJ][2]
	Next nJ                   
	aAuxAgl[nI][2] := nQuant
Next nI
axItens := Aclone(aAuxAgl)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPreco dos produtosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
aTabPrc := TabPrc(cTabela,axItens)
If Empty(aTabPrc)
	Conout("#TTFAT20C - TABELA DE PRECOS VAZIA " +cNumOs)
	Return aRet
EndIf

For nI := 1 To Len(axItens)
	For nJ := 1 To Len(aTabPrc)
		If AllTrim(aTabPrc[nJ][1]) == AllTrim(axItens[nI][1])
			// PRECO EMPRESA
			If aTabPrc[nJ][2] > 0 .And. AScan( aProd1, { |x| AllTrim(x[1]) == AllTrim(axItens[nI][1]) } ) == 0
				AADD( aProd1, { axItens[nI][1], axItens[nI][2] ,aTabPrc[nJ][2], "",cLocal, aTabPrc[nJ][3] } )	// produto qtd PE OBS LOCAL PP
			EndIf           
			// PRECO PUBLICO
			If aTabPrc[nJ][3] > 0 .And. AScan( aProd2, { |x| AllTrim(x[1]) == AllTrim(axItens[nI][1]) } ) == 0
				AADD( aProd2, { axItens[nI][1], axItens[nI][2] ,aTabPrc[nJ][3], "",cLocal, 0 } )	// produto qtd PP OBS LOCAL PP
			EndIf
		EndIf
	Next nJ
Next nI


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera orcamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
If !Empty(aProd1)
	If !lExistOrc .OR. lReproc
		If Empty(cPedFech)
			cNumOrc := U_TTFAT24C( cNumOS,cPatrim,cCodCli,cLoja,aProd1,lReproc )
			aRet[1] := cNumOrc
		EndIf	
	EndIf
EndIf

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera pedidoณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
*//*
If !Empty(aProd2)
	If !lExistPed .OR. lReproc
		//If Empty(cPedFech)
			cCodCli := "000001"
			cLoja := "0001"
			axCab := { {"C5_XFINAL","S"},{"C5_CONDPAG","118"}, {"C5_XTPPAG","TOK"}, {"C5_XPREPED","S"},{"C5_XCODPA",""},{"C5_MENNOTA",""} }
			If lGerarPed
				cNumPed := U_TTFAT21C( cCodCli,cLoja,aProd2,cNumOS,axCab )
				If !Empty(cNumPed)
					aRet[2] := cNumPed
				EndIf       
			EndIf      
		//EndIf        
	EndIf
EndIf*/


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera orcamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
If !Empty(aProd2)
	//If !lExistOrc .OR. lReproc
//		If Empty(cPedFech)
			cNumOrc2 := U_TTFAT24C( cNumOS,cPatrim,"000001","0001",aProd2,lReproc )
			aRet[1] := cNumOrc2
  //		EndIf	
	//EndIf
EndIf
                             

If lJob
	reset environment             
EndIf

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkProc  บAutor  ณJackson E. de Deus   บ Data ณ  06/29/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se ja gerou orcamento/pedido                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkProc(cNumOS,lExistOrc,lExistPed,cPedFech)

Local cSql := ""

// valida existencia do orcamento
cSql := "SELECT CJ_NUM,CJ_XNUMPV FROM " +RetSqlName("SCJ")
cSql += " WHERE CJ_XNUMOS = '"+cNumOS+"' AND D_E_L_E_T_ = '' "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBZ",.F.,.T.)
dbSelectArea("TRBZ")

If !Empty(TRBZ->CJ_NUM)
	lExistOrc := .T.                    
	If !Empty(TRBZ->CJ_XNUMPV)
		cPedFech := AllTrim(TRBZ->CJ_XNUMPV)
	EndIf
EndIf               

TRBZ->(dbCloseArea())

// valida existencia do pedido tt PP	
cSql := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SC5")
cSql += " WHERE C5_XNUMOS = '"+cNumOS+"' AND D_E_L_E_T_ = '' AND C5_NOTA NOT LIKE '%XXX%' "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBZ",.F.,.T.)
dbSelectArea("TRBZ")	

If TRBZ->TOTAL > 0
	lExistPed := .T.
EndIf               

TRBZ->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVendAnt  บAutor  ณJackson E. de Deus   บ Data ณ  30/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendAnt(cPatrim, cMola, cProduto, dDtFim, cNumOS)


Local cQuery := ""
Local nQtd := 0

// venda
cQuery := "SELECT TOP 1 * "
cQuery += " FROM "+RetSQLName("SZ0")
cQuery += " WHERE Z0_FILIAL='"+xFilial("SZ0")+"' AND Z0_CHAPA='"+cPatrim+"' AND Z0_MOLA='"+cMola+"' AND Z0_PRODUTO = '"+cProduto+"' "
cQuery += " AND D_E_L_E_T_='' "
cQuery += " AND Z0_DATA < '"+DTOS(dDtFim)+"' AND Z0_NUMOS <> '"+cNumOS+"' "
cQuery += " ORDER BY Z0_DATA DESC"

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBZ",.F.,.T.)
dbSelectArea("TRBZ")

nQtd := TRBZ->Z0_SLDMOV

dbCloseArea()

Return nQtd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTabPRC  บAutor  ณJackson E. de Deus    บ Data ณ  22/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a tabela de preco                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TabPRC(cTabela,axItens)

Local cSql := ""
Local nPos := 0
Local aTabPrc := {}

cSql := "SELECT DA1_CODPRO PRODUTO, DA1_PRCVEN PE, DA1_XPRCPP PP FROM " +RetSqlName("DA1")
cSql += " WHERE DA1_CODTAB = '"+cTabela+"' AND D_E_L_E_T_ = '' "
cSql += " ORDER BY DA1_ITEM "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBZ",.F.,.T.)
dbSelectArea("TRBZ")
While !EOF()
	nPos := AScan( axItens, { |x| AllTrim(x[1]) == AllTrim(TRBZ->PRODUTO) } )
	If nPos > 0
		AADD( aTabPrc, { TRBZ->PRODUTO, TRBZ->PE, TRBZ->PP } )
	EndIf
	dbSkip()
End

Return aTabPrc


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExcluiORc  บAutor  ณJackson E. de Deus บ Data ณ  20/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui um orcamento                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExcluiORc(cNumOS)

dbSelectArea("SCJ")
dbSetOrder(6)
If dbSeek( xFilial("SCJ") +AvKey(cNumOS,"CJ_XNUMOS") )
	SCJ->(RecLock("SCJ",.F.))
	SCJ->(dbDelete())
	SCJ->(MsUnLock())
	
	dbSelectArea("SCK")
	dbSetOrder(1)
	If dbSeek( xFilial("SCK") +AvKey(SCJ->CJ_NUM,"CK_NUM") )
		While SCK->CK_FILIAL == xFilial("SCK") .And. SCK->CK_NUM == SCJ->CJ_NUM .And. !EOF()
			SCK->(RecLock("SCK",.F.))
			SCK->(dbDelete())
			SCK->(MSUNLOCK())
			SCK->(dbSkip())
		End
	EndIf	
EndIf 		
	
Return  