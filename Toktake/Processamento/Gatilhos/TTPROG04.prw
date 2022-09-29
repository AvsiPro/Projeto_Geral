
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROG04  บAutor  ณJackson E. de Deus  บ Data ณ  11/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho para preenchimento da descricao do patrimonio.      บฑฑ
ฑฑบ          ณInclusao de Ordem de Servico - Equipe Remota                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROG04()

Local aArea := GetArea()
Local nREcnoSN1 := 0
Local cDescri := ""               
Local cCliFor := ""
Local cLoja := ""
Local cNome := ""
      
If cEmpAnt <> "01"
	return
EndIF
      
If !Empty(M->ZG_PATRIM)
	nREcnoSN1 := U_TTTMKA19(M->ZG_PATRIM)
	
	If nREcnoSN1 > 0
		dbSelectArea("SN1")
		dbGoTo(nRecnoSN1)
		cDescri := SN1->N1_DESCRIC
		cCliFor := SN1->N1_XCLIENT
		cLoja := SN1->N1_XLOJA
	EndIf                     
	 
	If !Empty(cCliFor) .And. !Empty(cLoja)
		If ALLTRIM(M->ZG_FORM) == "01"
			dbSelectArea("SA2")
			dbSetOrder(1)
			If dbSeek( xFilial("SA2") +cCliFor +cLoja )
				cNome := SA2->A2_NREDUZ
			EndIf
		Else 
			dbSelectArea("SA1")
			dbSetOrder(1)
			If dbSeek( xFilial("SA1") +cCliFor +cLoja )
				cNome := SA1->A1_NREDUZ
			EndIf
		EndIf
		
		M->ZG_CLIFOR := cCliFor
		M->ZG_LOJA := cLoja
		M->ZG_DESCCF := cNome
	EndIf	
EndIf

RestArea(aArea)
      
Return cDescri