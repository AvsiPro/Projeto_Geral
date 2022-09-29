#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMATA240    บAutor  ณJackson E. de Deus บ Data ณ  29/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava movimento interno e atualiza SB2                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAT240(cLocal,cProduto,cTM,dEmissao,nQuant,cNumOS,cMola,cObs,cOrigem,cPatrimo,cTipo,lTransf,cDocSZ5)

Local aArea			:= GetArea()
Local lOk			:= .F.
Local aCM			:= Array(5)	
Local aVatu			:= Array(5)	
Default cLocal		:= ""
Default cTm			:= ""
Default dEmissao	:= dDatabase
Default nQuant		:= 0
Default cNumOS		:= ""
Default cMola		:= ""
Default cObs		:= ""
Default cOrigem		:= ""
Default cPatrimo	:= ""
Default cTipo		:= ""
Default lTransf		:= .F.
Default cDocSZ5		:= ""

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cLocal) .Or. Empty(cProduto) .Or. Empty(cTm) .Or. Empty(nQuant)
	Return lOk
EndIf

// movimentar somente em armazem rota e pa
If !SubStr(cLocal,1,1) $ "A#P#R"
	Return lOk
EndIf

If dEmissao < GetMV("MV_ULMES")
	CONOUT("#U_MAT240 -> MOVIMENTO ANTERIOR AO ULTIMO FECHAMENTO - NAO EFETIVADO.")
	Return lOk
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If !MSSeek( xFilial("SB1") +AvKey(cProduto,"B1_COD") )
	Return lOk
EndIf

dbSelectArea("SB2")
dbSetOrder(2)
If !MsSeek( xFilial("SB2") +AvKey(cLocal,"B2_LOCAL") +AvKey(cProduto,"B2_COD") )
	CriaSB2(cProduto,cLocal)
EndIf

dbSelectArea("SB2")
dbSetOrder(2)
If MsSeek( xFilial("SB2") +AvKey(cLocal,"B2_LOCAL") +AvKey(cProduto,"B2_COD") )
	// saida - verifica se saldo eh suficiente
	If cTM > "500" .And. !lTransf
		If (SB2->B2_QATU-SB2->B2_QEMPSA) < nQuant
			CONOUT("#U_MAT240 -> SALDO INSUFICIENTE PARA BAIXA: " +cLocal + ":" +cProduto +":" +cvaltochar(nQuant)) 
			RestArea(aArea)
			Return lOk
		EndIf
	EndIf   
	
	cDoc := NextD3()
	/*cNumSeq := ProxNum()
	While !VldSeq(cNumSeq)
		cNumSeq := ProxNum()
	End*/
	
	dbSelectArea("SB1")
	MSSeek( xFilial("SB1") +AvKey(cProduto,"B1_COD") )		
	
	// cria o movimento
	dbSelectArea("SD3")
	If RecLock("SD3",.T.)
		SD3->D3_FILIAL	:= xFilial("SD3")
		SD3->D3_TM		:= cTm
		SD3->D3_COD		:= cProduto
		SD3->D3_UM		:= SB1->B1_UM
		SD3->D3_QUANT	:= nQuant
		SD3->D3_CF		:= IIF(cTM<="500","DE0","RE0")
		SD3->D3_CONTA	:= SB1->B1_CONTA
		SD3->D3_LOCAL	:= cLocal
		SD3->D3_DOC		:= cDoc
		SD3->D3_EMISSAO	:= dEmissao
		SD3->D3_GRUPO	:= SB1->B1_GRUPO		
		SD3->D3_NUMSEQ	:= ProxNum()
		SD3->D3_SEGUM	:= SB1->B1_SEGUM
		SD3->D3_TIPO	:= SB1->B1_TIPO
		SD3->D3_USUARIO	:= cUserName
		SD3->D3_CHAVE	:= "E0"
		SD3->D3_XDATINC	:= Date()
		SD3->D3_XHRINC	:= Time()
		SD3->D3_MSBLQL	:= "2"
		SD3->D3_XNUMOS	:= cNumOS
		SD3->D3_XORIGEM	:= cOrigem
		SD3->D3_XTIPO	:= cTipo 
		SD3->D3_XPATRI	:= cPatrimo
		SD3->D3_XMOLA	:= cMola		
		SD3->D3_OBSQUAL	:= cObs 
		
		If lTransf
			SD3->D3_XDOCSZ5 := cDocSZ5
		EndIf
				
		//	CUSTO
		//	REFERENCIA -> PegaCMAtu(cProduto,cLocal) // SM3M330.PRX
		/*
		aCM[01] := SB2->B2_CM1
		aCM[02] := SB2->B2_CM2
		aCM[03] := SB2->B2_CM3
		aCM[04] := SB2->B2_CM4
		aCM[05] := SB2->B2_CM5
		
		aVatu[01] := SB2->B2_VATU1
		aVatu[02] := SB2->B2_VATU2
		aVatu[03] := SB2->B2_VATU3
		aVatu[04] := SB2->B2_VATU4
		aVatu[05] := SB2->B2_VATU5
		For nX := 1 to 5
			If SB2->B2_QATU > 0 .And. aVatu[nX] > 0
				aCM[nX] := aVatu[nX]/SB2->B2_QATU
			EndIf
		Next nX		
        */
		//aCM := GravaCusD3(aCM)
		/*
		Replace D3_CUSTO1 With aCM[01]
		Replace D3_CUSTO2 With aCM[02]
		Replace D3_CUSTO3 With aCM[03]
		Replace D3_CUSTO4 With aCM[04]
		Replace D3_CUSTO5 With aCM[05]
		aCM[01] := SD3->D3_CUSTO1
		aCM[02] := SD3->D3_CUSTO2
		aCM[03] := SD3->D3_CUSTO3
		aCM[04] := SD3->D3_CUSTO4
		aCM[05] := SD3->D3_CUSTO5
		*/
        
		//B2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
		
		SD3->( MsUnLock() )
		
		
		// altera saldo
		If !lTransf
			dbSelectArea("SB2")
			If RecLock("SB2",.F.)
				If cTM <= "500"
					SB2->B2_QATU += nQuant
				Else 
					SB2->B2_QATU -= nQuant
				EndIf
				
				If AllTrim(cTipo) == "D"
					SB2->B2_QEMPSA += nQuant
				EndIf
				
				SB2->( MsUnLock() )			
			EndIf
		EndIf
		lOk := .T.		
	EndIf
EndIf

RestArea(aArea)


Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNextD3   บAutor  ณJackson E. de Deus   บ Data ณ  29/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Proximo documento SD3                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NextD3()

Local cDoc := ""
Local cQuery := ""

cQuery := "SELECT MAX(D3_DOC) DOC FROM " +RetSqlName("SD3")
cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"' AND D3_DOC LIKE 'X%' "

MPSysOpenQuery( cQuery , "TRBA" )   
  
dbSelectArea("TRBA")
If !Empty(TRBA->DOC)
	cDoc := SOMA1(TRBA->DOC)
Else
	cDoc := PadR("X",TamSx3("D3_DOC")[1],"0")	 	
EndIf

TRBA->(dbCloseArea())
                                        
Return cDoc


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldSeq   บAutor  ณJackson E. de Deus   บ Data ณ  29/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o sequencial                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldSeq(cNumSeq)

Local lValido := .T.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SD3") +" WITH (NOLOCK) WHERE D3_NUMSEQ = '"+cNumSeq+"' "
MPSysOpenQuery( cQuery , "TRBX" )                        

dbSelectArea("TRBX")
If TRBX->TOTAL > 0
	lValido := .F.
EndIf
TRBX->(dbCloseArea())

Return lValido