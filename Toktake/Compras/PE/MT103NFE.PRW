/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MT103NFE ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 07/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Controla entrada de NF                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Sem parƒmetros.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Tok Take                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"

User Function MT103NFE()
Local aArea	:= GetArea()
Local cQuery  := ""
Local c_EOL	  := CHR(13)+CHR(10)
Local _cCNPJF := Space(14)
Local _cCNPJC := Space(14)
Local _cCod   := Space(10)
Local _cRazao := Space(40)
Local cCombo  := "1-NFE"
Local aCombo := {"1-NF Entrada","2-Importação","3-Devolução"}
Local nCont	:=	0
Local lEdi	:=	.F.

Local cForns	:= If(cEmpAnt == "01",SuperGetMV("MV_XVLDESP",.T.,"000001"),"")	// Adicionado Jackson E. de Deus 18/04/2013
Local aForns	:= {}										// Adicionado Jackson E. de Deus 18/04/2013

aForns := STRTOKARR(cForns,"#")								// Adicionado Jackson E. de Deus 18/04/2013

If cEmpAnt $ "01/02"
	While !empty(procname(nCont))
		If alltrim(UPPER(procname(nCont))) $ "TTFINC10/U_TTTMKA50/U_TTMT140/U_TTCOMC16" 
			lEdi := .T.
			Exit
		EndIf 
		nCont++
	EndDo
	
	IF INCLUI .And. !lEdi
		While .T.
			@ 127,112 To 350,730 DIALOG _oObjeto1 TITLE "Nota Fiscal de Entrada - Inclusão"
			
			@ 010,005 Say "Seleção :"
			@ 010,055 ComboBox cCombo Items aCombo Size 65,21
			
			@ 030,005 Say "CNPJ :"
			@ 030,055 GET _cCNPJF PICTURE "@R 99.999.999/9999-99" When SubStr(cCombo,1,1)=='1' F3 "2CGC"  SIZE 70,12 VALID IIf(!Empty(_cCNPJF),_cRazao:=Posicione("SA2",3,xFilial("SA2")+_cCNPJF,"A2_NOME"),_cRazao:="")
			
			@ 050,005 Say "Código :"
			@ 050,055 GET _cCod PICTURE "@!"                     When SubStr(cCombo,1,1)=='2'  F3 "IMP"  SIZE 70,07 VALID IIf(!Empty(_cCNPJF),_cRazao:=Posicione("SA2",1,xFilial("SA2")+_cCod,"A2_NOME"),_cRazao:="")
			
			@ 070,005 Say "CNPJ (Devolução)  :"
			@ 070,055 GET _cCNPJC PICTURE "@R 99.999.999/9999-99" When SubStr(cCombo,1,1)=='3' F3 "1CGC"  SIZE 70,12 VALID IIf(!Empty(_cCNPJF),_cRazao:=Posicione("SA1",3,xFilial("SA1")+_cCNPJC,"A1_NOME"),_cRazao:="")
			
			@ 090,005 Say "Razâo Social:"
			@ 090,055 GET _cRazao PICTURE "@!" When .F. SIZE 200,12
			
			@ 010,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
			ACTIVATE DIALOG _oObjeto1 CENTERED
			If Empty(_cCNPJF) .AND. Empty(_cCNPJC) .AND. Empty(_cCod)
				Aviso("NFE","CNPJ/Código do " + IIF(SubStr(cCombo,1,1)=='3',"Cliente","Fornecedor") + " não preenchido. Cadastre para continuar.",{"Ok"},,"Atenção:")
				Loop
			End
			If SubStr(cCombo,1,1)=='3'
				cQuery := "SELECT A1_COD AS 'CODIGO',A1_LOJA AS 'LOJA',A1_EST AS 'EST' " + c_EOL
				cQuery += "FROM " + RetSqlName("SA1") + c_EOL
				cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
				If SM0->M0_CODIGO=="02"
					cQuery += "AND A1_FILIAL='" + xFilial("SA1") + "' " + c_EOL
				End
				cQuery += "AND A1_CGC='" + _cCNPJC + "' " + c_EOL
				MemoWrite("MT103NFE.sql",cQuery)
			Else
				cQuery := "SELECT A2_COD AS 'CODIGO',A2_LOJA AS 'LOJA',A2_EST AS 'EST' " + c_EOL
				cQuery += "FROM " + RetSqlName("SA2") + c_EOL
				cQuery += "WHERE D_E_L_E_T_='' " + c_EOL 
				If SM0->M0_CODIGO=="02"
					cQuery += "AND A2_FILIAL='" + xFilial("SA2") + "' " + c_EOL
				End
				If SubStr(cCombo,1,1) == '1'
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
	
				// Adicionado por Jackson E. de Deus em 18/04/2013
				// Se for Tok Take Matriz, já preenche espécie como SPED
				For nI := 1 To Len(aForns)
					If cA100For == aForns[nI]
						If cTipo == "D"
							CESPECIE := "SPED"
							Exit
						EndIf
					EndIf
					Exit 
				Next nI
				
				Exit
			Else
				Aviso("NFE","CNPJ/Código do " + IIF(SubStr(cCombo,1,1)=='3',"Cliente","Fornecedor") + " digitado não confere. Favor revisar.",{"Ok"},,"Atenção:")
				Loop
			End
		End
	End
EndIF
RestArea(aArea)
Return Nil