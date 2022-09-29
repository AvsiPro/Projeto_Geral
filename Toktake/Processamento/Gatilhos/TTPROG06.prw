/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROG06  บAutor  ณJackson E. de Deus  บ Data ณ  11/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho para preenchimento do nome do tecnico.			  บฑฑ
ฑฑบ          ณInclusao de Ordem de Servico - Equipe Remota                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTPROG06()

Local cNome := ""     
Local cAgente := ""
Local cRota := ""
Local cDescRota := ""

If cEmpAnt <> "01"
	return
EndIF

If !Empty(M->ZG_AGENTE)
	cAgente := cvaltochar(M->ZG_AGENTE)
	dbSelectArea("AA1")
	dbSetOrder(7)
	If dbSeek( xFilial("AA1") +AvKey(cAgente,"AA1_PAGER") )	
		cNome := AA1->AA1_NOMTEC
		cRota := AA1->AA1_LOCAL
	EndIf
	
	If !Empty(cRota)
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +AvKey(cRota,"ZZ1_COD"), "ZZ1_DESCRI" )
		M->ZG_ROTA := cRota
		M->ZG_ROTAD := cDescRota
	EndIf
EndIf            

Return cNome