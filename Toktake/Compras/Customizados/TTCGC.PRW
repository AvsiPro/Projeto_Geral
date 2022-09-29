/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTGCG   บAutor  ณCADUBITSKI	         บ Data ณ  10/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para gravar campos especificos no SCR     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
#include "rwmake.ch"

User Function TTCGC()
Local aArea	:= GetArea()
Local cQuery  := ""
Local c_EOL	  := CHR(13)+CHR(10)
Local _cCNPJF := Space(14)
Local _cCNPJC := Space(14)
Local _cCod   := Space(10)
Local _cRazao := Space(40)
Local cCombo  := "1-NFE"
Local aCombo := {"1-NF Entrada","2-Importa็ใo","3-Devolu็ใo"}   
Local nCont	:=	0
Local lEdi	:=	.F.

If cEmpAnt <> "10"
	
	While !empty(procname(nCont))
		If alltrim(UPPER(procname(nCont))) $ "TTFINC10/U_TTMT140/U_TTCOMC16"
			lEdi := .T.
			Exit
		EndIf 
		nCont++
	EndDo
	
	If Alltrim(Upper(FunName())) == "MATA140" .And. !lEdi
		While .T.
			@ 127,112 To 350,730 DIALOG _oObjeto1 TITLE "Nota Fiscal de Entrada - Inclusใo"
			
			@ 010,005 Say "Sele็ใo :"
			@ 010,055 ComboBox cCombo Items aCombo Size 65,21
			
			@ 030,005 Say "CNPJ :"
			@ 030,055 GET _cCNPJF PICTURE "@R 99.999.999/9999-99" When SubStr(cCombo,1,1)=='1' F3 "2CGC"  SIZE 70,12 VALID IIf(!Empty(_cCNPJF),_cRazao:=Posicione("SA2",3,xFilial("SA2")+_cCNPJF,"A2_NOME"),_cRazao:="")
			
			@ 050,005 Say "C๓digo :"
			@ 050,055 GET _cCod PICTURE "@!"                     When SubStr(cCombo,1,1)=='2'  F3 "IMP"  SIZE 70,07 VALID IIf(!Empty(_cCNPJF),_cRazao:=Posicione("SA2",1,xFilial("SA2")+_cCod,"A2_NOME"),_cRazao:="")
			
			@ 070,005 Say "CNPJ (Devolu็ใo)  :"
			@ 070,055 GET _cCNPJC PICTURE "@R 99.999.999/9999-99" When SubStr(cCombo,1,1)=='3' F3 "1CGC"  SIZE 70,12 VALID IIf(!Empty(_cCNPJF),_cRazao:=Posicione("SA1",3,xFilial("SA1")+_cCNPJC,"A1_NOME"),_cRazao:="")
			
			@ 090,005 Say "Razโo Social:"
			@ 090,055 GET _cRazao PICTURE "@!" When .F. SIZE 200,12
			
			@ 010,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
			ACTIVATE DIALOG _oObjeto1 CENTERED
			
			If Empty(_cCNPJF) .AND. Empty(_cCNPJC) .AND. Empty(_cCod)
				Aviso("NFE","CNPJ/C๓digo do " + IIF(SubStr(cCombo,1,1)=='3',"Cliente","Fornecedor") + " nใo preenchido. Cadastre para continuar.",{"Ok"},,"Aten็ใo:")
				Loop
			End
			If SubStr(cCombo,1,1)=='3'
				cQuery := "SELECT A1_COD AS 'CODIGO',A1_LOJA AS 'LOJA',A1_EST AS 'EST'  " + c_EOL
				cQuery += "FROM " + RetSqlName("SA1") + c_EOL
				cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
				cQuery += "AND A1_CGC='" + _cCNPJC + "' " + c_EOL
				MemoWrite("MT103NFE.sql",cQuery)
			Else
				cQuery := "SELECT A2_COD AS 'CODIGO',A2_LOJA AS 'LOJA',A2_EST AS 'EST'  " + c_EOL
				cQuery += "FROM " + RetSqlName("SA2") + c_EOL
				cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
				If SubStr(cCombo,1,1)=='1'
					cQuery += "AND A2_CGC='" + _cCNPJF + "' " + c_EOL
				ElseIf SubStr(cCombo,1,1)=='2'
					cQuery += "AND A2_COD='" + SubStr(_cCod,1,6) + "' " + c_EOL
					cQuery += "AND A2_LOJA='" + SubStr(_cCod,7,4) + "' " + c_EOL
				End
				MemoWrite("MT103NFE.sql",cQuery)
			End
			If Select("TRB") > 0
				dbSelectArea("TRB")
				DbCloseArea()
			EndIf
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
			dbSelectArea("TRB")
			If !Eof()
				cA100For := TRB->CODIGO
				cLoja    := TRB->LOJA
				cUFOrig  := TRB->EST
				If SubStr(cCombo,1,1)=='3'
					cTipo := "D"
				End
				Exit
			Else
				Aviso("NFE","CNPJ/C๓digo do " + IIF(SubStr(cCombo,1,1)=='3',"Cliente","Fornecedor") + " digitado nใo confere. Favor revisar.",{"Ok"},,"Aten็ใo:")
				Loop
			End
		End
	End
EndIf

RestArea(aArea)
Return Space(6)