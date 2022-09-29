#INCLUDE "PROTHEUS.CH"     
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC42  บAutor  ณJackson E. de Deus   บ Data ณ  26/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Geracao da OS de inventario da PA ou da Rota              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC42( cCodPA,cCodCli,cLoja,cCodTec,dInicio,dFim,cHrIniCC )
            
Local aArea	:= GetArea()
Local cOsMobile := ""                                                                                                     
Local aDados := {}
Local aInfo := {}
Default cCodPA := ""
Default cCodCli := ""
Default cLoja := ""
Default cCodTec := ""

If cEmpAnt <> "01"
	return
EndIF

cNomeAtend	:= Posicione("AA1",1,xFilial("AA1")+AvKey(cCodTec,"AA1_CODTEC"),"AA1_NOMTEC")

dbSelectArea("ZZ1") 
dbSetOrder(1)
If MSSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
	cDescPA := ZZ1->ZZ1_DESCRI	
EndIf



AADD( aInfo, { "data_invent_inicio",dInicio } )
AADD( aInfo, { "data_invent_fim",dFim } )
AADD( aInfo, { "hora_inicio",cHrIniCC } )


               
aDados := { "21",;
			"INVENTARIO",;
			AllTrim(cCodTec),;             	
			AllTrim(cNomeAtend),;
			"",;
			"",;
			"",;
			"",;
			dDataBase,;
			Time(),;
			"TOK TAKE",;
			ZZ1->ZZ1_END,;	// PA
			"",;
			"",;
			cCodPA,;
			cDescPA,;
			"",;
			"",;
			"",;
			cCodCli,;
			cLoja,;
			aInfo,;
			"",;
			cCodPA } 
			
cOSMobile := U_MOBILE( aDados )


RestArea(aArea)

Return cOsMobile