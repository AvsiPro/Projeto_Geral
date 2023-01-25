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
Local nQtd2 :=  0
Local cIdPr	:=	Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XIDPROP")
                                         
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

If !Empty(cIdPr)
	cQuery := "SELECT COUNT(*) AS QTD2 FROM "+RetSQLName("SE1")
	cQuery += " WHERE "         
	cQuery += " E1_CLIENTE IN(SELECT A1_COD FROM "+RetSQLName("SA1")+" WHERE A1_FILIAL='"+xFilial("SA1")+"' AND A1_XIDPROP='"+cIdPr+"')" 
	cQuery += " AND E1_VENCREA < '"+dtos(dDataBase)+"' AND E1_BAIXA=' ' AND E1_TIPO NOT IN('RA','NCC')"
	cQuery += " AND D_E_L_E_T_=' '" 

	If Select('QUERY') > 0
		dbSelectArea('QUERY')
		dbCloseArea()
	EndIf

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

	DbSelectArea("QUERY")

	nQtd2 := QUERY->QTD2
EndIF 

If nQtd > 0 .OR. nQtd2 > 0 
	If MsgYesNo("Exitem titulos em aberto para este Cliente ou ID Proprietário"+CRLF+"Deseja visualizar os titulos em aberto!","ROBFAT09 - Cliente Inadimplente")
		U_ROBFAT10(SC5->C5_CLIENTE,SC5->C5_LOJACLI,cIdPr)
	EndIf
else
	MsgAlert("Não há titulos em atraso para este cliente")
EndIf

RestArea(aArea)

Return()
