#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MntSZ5    ºAutor  ³Jackson E. de Deus  º Data ³  07/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Movimento interno na tabela SZ5                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MntSZ5(cLocal,cProduto,cTM,dEmissao,nQuant,cNumOS,cMola,cObs,cOrigem,cPatrimo,cTipo,lisRota,cNumNF, cItemNF,lMudaZ6)

Local aArea			:= GetArea()
Local lOk			:= .F.
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
Default lisRota		:= .F.
Default cNumNF		:= ""
Default cItemNF		:= ""
Default lMudaZ6		:= .T.

If Empty(cLocal) .Or. Empty(cProduto) .Or. Empty(cTm) .Or. Empty(nQuant)
	Return lOk
EndIf

If cEmpAnt == "01"
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	If !MsSeek( xFilial("SZ6") +AvKey(cLocal,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
		//STATICCALL( ESTXFUN,CRIASZ6,cProduto,cLocal )
		U_CRIASZ6(cProduto,cLocal)
	EndIf
				
	If MsSeek( xFilial("SZ6") +AvKey(cLocal,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
		// saida - verifica se saldo eh suficiente
		If cTM > "500"
			If SZ6->Z6_QATU < nQuant .And. !lisRota
				CONOUT("#MNTSZ5 -> SALDO INSUFICIENTE PARA BAIXA: " +cLocal + ":" +cProduto +":" +cvaltochar(nQuant)) 
				//RestArea(aArea)	// TESTAR PERMISSAO DE SALDO NEGATIVO
				//Return lOk
			EndIf
		EndIf   
		
		cDoc := NextNumZ5()
		
		// cria o movimento
		dbSelectArea("SZ5")
		If RecLock("SZ5",.T.)
			SZ5->Z5_FILIAL	:= xFilial("SZ5")
			SZ5->Z5_LOCAL	:= cLocal
			SZ5->Z5_COD		:= cProduto
			SZ5->Z5_EMISSAO	:= dEmissao
			SZ5->Z5_HORA	:= Time()
			SZ5->Z5_TM		:= cTM
			SZ5->Z5_QUANT	:= nQuant
			SZ5->Z5_DOC		:= cDoc
			SZ5->Z5_NUMOS	:= cNumOS
			SZ5->Z5_CHAPA	:= cPatrimo
			SZ5->Z5_MOLA	:= cMola   
			SZ5->Z5_TIPO	:= cTipo
			SZ5->Z5_ORIGEM	:= cOrigem
			SZ5->Z5_OBS		:= cObs
			SZ5->Z5_NF		:= cNumNF
			SZ5->Z5_NFITEM	:= cItemNF
			SZ5->Z5_TRANSF	:= "N"		
			SZ5->( MsUnLock() )
		EndIf
	
		If lMudaZ6
			dbSelectArea("SZ6")
			If RecLock("SZ6",.F.)
				If cTM <= "500"
					SZ6->Z6_QATU += nQuant
				Else 
					SZ6->Z6_QATU -= nQuant
				EndIf
					
				SZ6->( MsUnLock() )
				lOk := .T.
			EndIf
		Else
			lOk := .T.
		EndIf
		
	EndIf
EndIF

RestArea(aArea)

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NextNumZ5  ºAutor  ³Jackson E. de Deus º Data ³  23/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Proximo documento SZ5		                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NextNumZ5()

Local cDoc := ""
Local cQuery := ""

cQuery := " SELECT MAX(Z5_DOC) DOC FROM " +RetSqlName("SZ5")+ " WITH(NOLOCK) "

If Select("TRBZ") > 0
	TRBZ->( dbCloseArea() )
EndIf
                        
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBZ",.F.,.T.)  

dbSelectArea("TRBZ")

If !Empty(TRBZ->DOC)
	cDoc := SOMA1(TRBZ->DOC)
Else
	cDoc := PadL("1",TamSx3("Z5_DOC")[1],"0")	
EndIf

TRBZ->(dbCloseArea())


Return cDoc