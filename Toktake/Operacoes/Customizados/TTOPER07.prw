#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTOPER07  ºAutor  ³Jackson E. de Deus  º Data ³  07/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava os horarios do plano de trabalho da Rota	          º±±
±±º          ³															  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³07/07/14³01.00 |Criacao                                 ³±±
±±³Jackson       ³20/10/14³01.01 |Inclusao de novo campo na gravacao:	  ³±±
±±³									SZR->ZR_SEQ                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTOPER07(cCodFil,cRota,cCliente,cLoja,cPatrim,cAno,cMes,cDia,cHora,cSeq,cTpPla)

Local lRet := .F.
Local lExcluir := .F.
Local cQuery := ""
Local nRecno := 0

Default cCodFil := ""
Default cRota := ""
Default cCliente := ""
Default cLoja := ""
Default cPatrim := ""
Default cAno := ""
Default cMes := ""
Default cDia := ""
Default cSeq := ""
Default cTpPla := ""

If cEmpAnt <> "01"
	Return
EndIF

If Empty(cCodFil) .Or. Empty(cRota) .Or. Empty(cCliente);
	.Or. Empty(cLoja) .Or. Empty(cPatrim) .Or. Empty(cAno) ;
	.Or. Empty(cMes) .Or. Empty(cDia) .Or. Empty(cTpPla)
	Return lRet
EndIf	

If Empty(cHora) .Or. cHora == ":"
	lExcluir := .T.
EndIf

cQuery := "SELECT R_E_C_N_O_ REC FROM " +RetSqlName("SZR") 
cQuery += " WHERE "
cQuery += " ZR_ROTA = '"+cRota+"' AND ZR_CHAPA = '"+cPatrim+"' "
cQuery += " AND ZR_ANO = '"+cAno+"' AND ZR_MES = '"+cMes+"' AND ZR_DIA = '"+cDia+"' "
cQuery += " AND ZR_SEQ = '"+cSeq+"' AND ZR_TIPOPLA = '"+cTpPla+"' AND D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
Tcquery cQuery New Alias "TRB"
dbselectArea("TRB")

If !EOF()  
	nRecno := TRB->REC	
EndIf
dbCloseArea()

dbSelectArea("SZR")

// nao existe ainda
If nRecno == 0
	If !lExcluir
		RecLock("SZR",.T.)
		SZR->ZR_FILIAL := cFilial
		SZR->ZR_ROTA := cRota
		SZR->ZR_CLIENTE := cCliente
		SZR->ZR_LOJA := cLoja
		SZR->ZR_CHAPA := cPatrim
		SZR->ZR_ANO := cAno
		SZR->ZR_MES := cMes
		SZR->ZR_DIA := cDia
		SZR->ZR_HORA := cHora
		SZR->ZR_SEQ := cSeq
		SZR->ZR_TIPOPLA := cTpPla
		MsUnLock()
	EndIf		
// ja existe porem com horario diferente
Else            
	dbGoTo(nRecno)
	If Recno() == nRecno
		If !lExcluir
			RecLock("SZR",.F.)
			SZR->ZR_CLIENTE := cCliente
			SZR->ZR_LOJA := cLoja
			SZR->ZR_HORA := cHora
			SZR->ZR_SEQ := cSeq
			SZR->ZR_TIPOPLA := cTpPla
			MsUnLock()                                            
		// exclusao
		Else
			RecLock("SZR",.F.)
			dbDelete()
			MsUnLock()
		EndIf
	EndIf		
EndIf
	 
Return lRet