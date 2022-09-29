
#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT120LOK บ Autor ณWanderley Andrade     บDataณ  15/01/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para validar a linha digitada do           บฑฑ
ฑฑบ          ณpedido de compras.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120LOK()

Local aArea		:= GetArea()
Local lRet		:= .T.
Local clQuery	:= ""
Local cProduto	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_PRODUTO"})]
Local cCodTab	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_CODTAB"})]
Local cconta	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_CONTA"})]
Local ccc    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_CC"})]
Local cItCt    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_ITEMCTA"})]
Local dEPC    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C7_DATPRF"})]
              
//Bloqueio de produtos pelo compras
//Item 56 da lista de pendencias solicitado pelo Jorge do compras - Alexandre 28/06/12
If substr(cNumEmp,1,2) == "01"
	If Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_XBLQCOM")
		MsgAlert("O Produto "+cProduto+" esta bloqueado para novas compras","MT120LOK")
		lRet := .F.
		Return(lRet)
	EndIf
Endif

If cEmpAnt == "01"
	
	If Empty(cCodTab)
		If SubStr(cProduto,1,2)=="10"
			MsgInfo("Os produtos iniciados com ["+SubStr(cProduto,1,2)+"] devem ter tabela de pre็o.","ATENวรO!!!")
			lRet := .F.
			Return(lRet)
		End
		If SubStr(cProduto,1,1)=="3" .OR. SubStr(cProduto,1,1)=="4" .OR. SubStr(cProduto,1,1)=="5"
			MsgInfo("Os produtos iniciados com ["+SubStr(cProduto,1,1)+"] devem ter tabela de pre็o.","ATENวรO!!!")
			lRet := .F.
			Return(lRet)
		End
	End
	if substr(cconta,1,1)="4"
		if empty(ccc)
			MsgInfo("Favor informar o Centro de Custo. Conta Contabil Despesas (Iniciando 4).","ATENวรO!!!")
			lRet := .F.
			Return(lRet)
		endif
	endif
	
	If substr(ccc,1,2)="03"
		If empty(cItCt)
			MsgInfo("Favor informar o Item Contabil. Centro de Custo (Iniciando 03).","ATENวรO!!!")
			lRet := .F.
			Return(lRet)
		EndIf
	EndIf
	
	If dEPC <= dDataBase
		If empty(dEPC)
			MsgInfo("Favor informar verificar a data informada para entrega.","ATENวรO!!!")
			lRet := .F.
			Return(lRet)
		EndIf
	EndIf
EndIF
If SM0->M0_CODIGO=='01'	// alterado em 11/12/2014 - validar somente Tok Take - Jackson
	lRet := U_TTBLQFOR(CA120FORN,CA120LOJ)
End 


RestArea(aArea)

Return(lRet)
