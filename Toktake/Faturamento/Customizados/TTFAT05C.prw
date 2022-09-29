#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT05C   บAutor  ณJackson E. de Deus บ Data ณ  10/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBloqueia a digitacao de produto que tenha cadastro na SN1.  บฑฑ
ฑฑบ          ณAtivo Fixo.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT05C()

Local cProduto := ""
Local nCont := 0
Local aArea := GetArea()
Local cFuncExcecao := If(cEmpAnt=="01",SuperGetMV("MV_XNOFUNC",.T.,""),"")	//funcoes de excecao que poderam utilizar os ativos no pedido de venda
Local cExcecao := If(cEmpAnt=="01",SuperGetMV("MV_XATFMOV",.T.,""),"")
Local lExcecao := .F.

If cEmpAnt <> "01"
	Return
EndIf

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ cFuncExcecao
		lExcecao := .T.
		Exit
	EndIf 
	nCont++
EndDo
     

If lExcecao
	Return .T.
Else
	//Verifica se o pedido se trata de remessa para conserto
	If AllTrim(M->C5_XFINAL) $ cExcecao //"C|E|Y"
		Return .T.
	Else	
		cProduto := M->C6_PRODUTO
		lExistSN1 := ChkSN1(cProduto)
		If ValType(lExistSN1) == "L"
			If lExistSN1
				Aviso("TTFAT05C","O produto possui cadastro no Ativo Fixo e nใo pode ser utilizado de forma direta para gera็ใo de pedido de venda.",{"Ok"})
				Return .F.
			EndIf
		EndIf
	EndIf
EndIf


RestArea(aArea)

Return .T.

             

//Verifica na tabela de Ativo Fixo a existencia de cadastro do produto
Static Function ChkSN1(cProduto)

Local lRet := .F.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SN1") + " SN1 "
cQuery += "WHERE N1_PRODUTO = '"+cProduto+"' AND D_E_L_E_T_ = '' "
 
If Select("TRBSN1") > 0
	TRBSN1->(dbCloseArea())
EndIf                     

tcquery cquery new alias "TRBSN1"

nTot := TRBSN1->TOTAL

If nTot >= 1
	lRet := .T.
EndIf
         
Return lRet
