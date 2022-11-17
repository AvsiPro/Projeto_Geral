#INCLUDE "PROTHEUS.CH"
/*
Rotina para realizar o filtro na seleção do fornecedor
na consulta padrão (F3) da tela de pré nota fiscal.
Vamos mostrar apenas os fornecedores de pedidos que estão em 
aberto e os pedidos de compras sejam do grupo de compras do usuário
-------------------------------------------------------------------------
Consulta Padrão: FORPRE
Conteudo do filtro: SA2->A2_COD + SA2->A2_LOJA $ @#U_FilFor()
-------------------------------------------------------------------------
Campo: F1_FORNECE
Validação: AllTrim(cA100For) $ U_FilFor() 
-------------------------------------------------------------------------
Autor: Jonas Gouveia
Data: 02/08/2016
*/

User Function FilFor()

Local cForRet 	:= ""
Local cQuery  	:= ""
Local aArea	  	:= GetArea()
Local aGrupo  	:= UsrGrComp(RetCodUsr())  
Local cFornePJ	:= ""
Local nX 		:= 0
Local nI 		:= 0
Local cCodUsr	:=	RetCodUsr()
Local cGrpUsr	:=	''
Local aGrupos 	:=	UsrRetGrp(cCodUsr)
//Local aGrpPC	:=	{}
Local aFilUser  := FWLoadSM0(.T.,.T.)
Local cFilUser	:= ""

Aeval(aGrupos,{|x| cGrpUsr += x + '/'})

For nI:=1 to Len(aFilUser)
	If aFilUser[nI][11]
		cFilUser += Iif(nI>1,"|","")+AllTrim(aFilUser[nI][2])
	EndIf
Next nI

cFilUser := "('"+StrTran(cFilUser,"|","','")+"') "

cQuery := " SELECT A2_COD + A2_LOJA FORNECE FROM "
cQuery += RetSqlName("SA2") + " SA2 "
cQuery += " WHERE A2_USER = '" + cCodUsr + "'" //RetCodUsr()
cQuery += " AND SA2.D_E_L_E_T_ = ' '"

DbUseArea( .T.,"TOPCONN", TcGenQry(,,cQuery), "TRBUSR", .F., .T.)

If TRBUSR->(!EOF())

	While TRBUSR->(!EOF())
		cFornePJ +=  "'" + TRBUSR->FORNECE + "'"
		TRBUSR->(DbSkip())
		If TRBUSR->(!EOF())
			cFornePJ += ","
		EndIf
	EndDo

EndIf

TRBUSR->(DbCloseArea())

cQuery := " SELECT DISTINCT C7_FORNECE, C7_LOJA, C7_USER FROM "
cQuery += RetSqlName("SC7") + " SC7 "
cQuery += " WHERE "
cQuery += " (C7_QUANT-C7_QUJE-C7_QTDACLA)> 0 AND "
cQuery += " C7_RESIDUO =  ' ' AND "
cQuery += " C7_TPOP <>    'P' AND "
cQuery += " C7_CONAPRO <> 'B' AND "
cQuery += " C7_FILIAL = '" + xFilial("SC7") + "' AND"
cQuery += " SC7.D_E_L_E_T_ = ' '"


If (Ascan(aGrupo,"*") == 0 )

	For nX := 1 To Len(aGrupo)
		If nX == 1
			cQuery += " AND (C7_GRUPCOM = '' OR C7_GRUPCOM IN ('" + aGrupo[nX] + "'"
		Else                                                        	
			cQuery += ",'" + aGrupo[nX] + "'"                           	
		Endif
	Next nX

	If Len(aGrupo) > 0
		cQuery += ") "
	EndIf

	cFornePJ := IIF(Empty(cFornePJ), "''", cFornePJ) 

	cQuery += "OR C7_FORNECE + C7_LOJA IN (" + cFornePJ + ")"
	cQuery += "OR C7_USER = (" + RetCodUsr() + ")"

	If Len(aGrupo) > 0
		cQuery += ") " 
	EndIf

EndIf

DbUseArea( .T.,"TOPCONN", TcGenQry(,,cQuery), "TRBFORN", .F., .T.)

cForRet := "("

While TRBFORN->(!EOF())
	aGrpPC := UsrRetGrp(TRBFORN->C7_USER)
	lPCGrp := .F.
	Aeval(aGrpPC,{|x| lPCGrp := If(x $ cGrpUsr,.T.,.F.)})

	If !lPCGrp
		TRBFORN->(Dbskip())
		loop
	EndIf 
	cForRet +=  TRBFORN->C7_FORNECE + TRBFORN->C7_LOJA + ","
	TRBFORN->(DbSkip())
EndDo

cForRet += ")"

TRBFORN->(DbCloseArea())

RestArea(aArea)

Return cForRet
