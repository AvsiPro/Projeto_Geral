#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBFAT09  ºAutor  ³Alexandre Venancio  º Data ³  08/23/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho para informar que cliente tem pagamentos em atraso  º±±
±±º          ³ao digitar um pedido de venda                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ disparado nos campos C5_CLIENTE e C5_LOJACLI               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ROBFAT09()

Local aArea	:=	GetArea()
//Local cRet	:=	&(Readvar())
Local cQuery
Local nQtd	:=	0       
Local lEdi	:=	.F.
                                         
If !lEdi
	cQuery := "SELECT COUNT(*) AS QTD FROM "+RetSQLName("SE1")
	cQuery += " WHERE "         
	cQuery += " E1_CLIENTE='"+SC5->C5_CLIENTE+"' AND E1_LOJA='"+SC5->C5_LOJACLI+"' 
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
	
	If nQtd > 0 .And. !Empty(SC5->C5_LOJACLI) .And. !SC5->C5_CLIENTE $ '000001/000002' 
		If MsgYesNo("Este Cliente tem pagamentos em Atraso"+chr(13)+chr(10)+"Deseja visualizar os titulos em aberto!","ROBFAT09 - Cliente Inadimplente")
			U_ROBFAT10(SC5->C5_CLIENTE,SC5->C5_LOJACLI)
		EndIf
	else
		MsgAlert("Não há titulos em atraso para este cliente")
	EndIf

EndIf

RestArea(aArea)

Return()
