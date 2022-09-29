#INCLUDE "rwmake.ch"
#include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MKB   º Autor ³ Cadubitski         º Data ³    Jan/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para nao permitir marcar os pedidos que  .º±±
±±º          ³ tiver com TES 888.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M460MKB()

//Alert("passei no marca") verificar lina 290 MarkBrow... dentro do mata460a

Return("u_ttm460m()")


User function ttm460m()

Local aArea  := GetArea()
Local cXTESC := ""	//GETNEWPAR("MV_XTESC","888")
Local cTes   := CriaVar("C6_TES",.F.)
Local lRet 	 := .t.  
Local nCont  := 0  
Local lEstorno := .F.
//Local cTesA	 := '608/781'  //parametro


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf


cXTESC := GETNEWPAR("MV_XTESC","888")

cTes := GetAdvFVal( 'SC6', 'C6_TES', xFilial( 'SC6' ) + SC9->(C9_PEDIDO+C9_ITEM) ,1 , '' )

If Alltrim(cTes) == Alltrim(cXTESC)
	lRet := .f.
Else
	lRet := .t. 
EndIf       
 
If SM0->M0_CODIGO == "01"
	While !empty(procname(nCont))
		If alltrim(UPPER(procname(nCont))) $ "MA461ESTOR"
			lEstorno := .T.
			Exit
		EndIf 
		nCont++
	EndDo
	
	If !lEstorno
		lRet := VldEst() 
	EndIf
EndIf

/*If cTes $ cTesA .And. Empty(GetAdvFVal( 'SC6', 'C6_XPATRIM', xFilial( 'SC6' ) + SC9->(C9_PEDIDO+C9_ITEM) ,1 , '' ))
	MsgAlert("Movimentações de Patrimonio somente são permitidas quando originadas pelo Call Center.","M460MKB")
	lRet	:=	.F.
EndIf */

RestArea( aArea )

Return(lRet)             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MKB   ºAutor  ³Microsiga           º Data ³  12/30/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldEst()

Local aArea	:=	GetArea()
Local lRet	:=	.T.
Local nEst	:=	SC9->C9_QTDLIB
Local lBaixa := .F.
Local lDose := .F.
Local nSaldo := 0
Local nSaldo2 := 0

DbSelectArea("SB2")
Dbsetorder(1)	// filial + codigo + local
If DbSeek(xFilial("SC9")+SC9->C9_PRODUTO+SC9->C9_LOCAL)
	nSaldo	:= SB2->B2_QATU // B2_QATU – B2_QACLASS – B2_RESERVA // SaldoSB2()
	nSaldo2 := SB2->B2_QATU - SB2->B2_QACLASS - SB2->B2_RESERVA
	
	Conout("#M460MKB - PROD: " +ALLTRIM(SC9->C9_PRODUTO) + " - SALDO B2_QATU: " +CVALTOCHAR(nSaldo) )
	Conout("#M460MKB - PROD: " +ALLTRIM(SC9->C9_PRODUTO) + " - SALDO CALCULADO: " +CVALTOCHAR(nSaldo2) )
	
	dbSelectArea("SF4")
	dbSetOrder(1) 
	If MsSeek( xFilial("SF4") +AvKey(SC6->C6_TES,"F4_CODIGO") )
		If SF4->F4_ESTOQUE == "S"
			lBaixa := .T.
		EndIf
	EndIf

	If nEst > nSaldo .And. lBaixa .And. GetEnvServer() == "JVVXC9"
		MsgAlert("Esta operação deixará o estoque deste produto negativo, favor verificar o estoque deste produto","M460MKB")
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)

Return(lRet)