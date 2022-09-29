#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFATG07  ºAutor  ³Alexandre Venancio  º Data ³  08/23/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para informar que cliente tem pagamentos em atraso  º±±
±±º          ³ao digitar um pedido de venda                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ disparado nos campos C5_CLIENTE e C5_LOJACLI               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTFATG07()

Local aArea	:=	GetArea()
Local cRet	:=	&(Readvar())
Local cQuery
Local nQtd	:=	0       
Local nCont :=	0
Local lEdi	:=	.F.
                                         
While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "TTEDI100/U_TTJRNOTA/U_TTPROC25/U_TTFAT21C/PWSX/CEFATA/PUTSALESORDER/U_CEFATA15/CEFATA15/U_WSKPX009/U_WSKPX012/U_WSINTBLG1"    
		lEdi := .T.
		Exit
	EndIf 
	nCont++
EndDo

If !lEdi
	cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("SE1")
	cQuery += " WHERE "         
	cQuery += " E1_CLIENTE='"+M->C5_CLIENTE+"' AND E1_LOJA='"+M->C5_LOJACLI+"' 
	cQuery += " AND E1_VENCREA < '"+dtos(dDataBase)+"' AND E1_BAIXA='' AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND D_E_L_E_T_=''" 
	
	If Select('QUERY') > 0
		dbSelectArea('QUERY')
		dbCloseArea()
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
	
	DbSelectArea("QUERY")
	
	nQtd := QUERY->QTD
	
	If nQtd > 0 .And. !Empty(M->C5_LOJACLI) .And. !M->C5_CLIENTE $ '000001/000002' .And. !lEdi
		If MsgYesNo("Este Cliente tem pagamentos em Atraso"+chr(13)+chr(10)+"Deseja visualizar os titulos em aberto!","TTFATG07 - Cliente Inadimplente")
			U_HIT0200(M->C5_CLIENTE,M->C5_LOJACLI)
		EndIf
	EndIf

EndIf

RestArea(aArea)

Return(cRet)
