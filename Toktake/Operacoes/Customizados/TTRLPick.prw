#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTRLPick   บAutor  ณJackson E. de Deus  บ Data ณ 25/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTRLPick( aMaquinas,dDia )


Local oExcel	:= FWMSEXCEL():New()
Local cPlanilha := "picklist.xml"
Local cQuery := ""
Local cWhere := ""
Local nI
Local cMaquina := ""
Default aMaquinas := {}
Default dDia := Nil

If Empty(aMaquinas) .Or. dDia == Nil
	Return
EndIf
If cEmpAnt <> "01"
	Return
endIf

cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
If Empty(cDir)
	Aviso("TTRLPick","Escolha um diret๓rio vแlido.",{"Ok"})
	Return
EndIf


cWhere := "("
For nI := 1 To Len( aMaquinas )
	cWhere += "'" +aMaquinas[nI][1] +"'"
	If nI <> Len( aMaquinas )
		cWhere += ","
	EndIf
Next nI
cWhere += ")"

cQuery := "SELECT * FROM PICKLIST "
cQuery += "INNER JOIN " +RetSqlName("SN1") +" ON N1_CHAPA = MAQUINA "
cQuery += "INNER JOIN " +RetSqlName("SB1") +" ON B1_COD = PRODUTO "
cQuery += " WHERE MAQUINA IN "+cWhere+" AND DIA = '"+DTOS(dDia)+"' "
cQuery += " AND PICKLIST.D_E_L_E_T_ = '' " 
cQuery += " ORDER BY MAQUINA,B1_XSECAO, B1_XFAMILI, B1_GRUPO "

MPSysOpenQuery( cQuery , "TRBR" )

dbSelectArea("TRBR")
dbGoTop()
If EOF()
	Return
EndIf



oExcel:AddworkSheet("Pick")
oExcel:AddTable("Pick","Pick")
oExcel:AddColumn("Pick","Pick","Patrimonio",1,1)
oExcel:AddColumn("Pick","Pick","Modelo",1,1)
oExcel:AddColumn("Pick","Pick","Cliente",1,1)
oExcel:AddColumn("Pick","Pick","Produto",1,1)
oExcel:AddColumn("Pick","Pick","Desc. Produto",1,1)
oExcel:AddColumn("Pick","Pick","Quantidade",1,2)    
 
 
cMaquina := TRBR->MAQUINA
While TRBR->(!EOF())

	If cMaquina <> TRBR->MAQUINA
		cMaquina := TRBR->MAQUINA
		oExcel:AddRow("Pick","Pick",{ "",;
									"",;
									"",;
									"",;
									"",;
									0  })	
	EndIf
	    
	cNomeCli := ""
	
	// cliente                                                                     
	dbSelectArea("AA3")
	dbSetOrder(7)
	If MSSeek( xFilial("AA3") +AvKey(TRBR->MAQUINA,"AA3_NUMSER") )
		cNomeCli := Posicione( "SA1",1,xFilial("SA1") +AvKey(AA3->AA3_CODCLI,"A1_COD") +AvKey(AA3->AA1_LOJA,"A1_LOJA"),"A1_NOME" )
	EndIf
	
	oExcel:AddRow("Pick","Pick",{ TRBR->MAQUINA,;
									Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBR->MAQUINA,"N1_CHAPA"),"N1_DESCRIC" ),; 
									cNomeCli,;
									TRBR->PRODUTO,;
									Posicione( "SB1",1,xFilial("SB1") +AvKey(TRBR->PRODUTO,"B1_COD"),"B1_DESC" ),;
									TRBR->QUANT  })		
	dbSkip()
End

dbCloseArea()

 
		
oExcel:Activate()
oExcel:GetXMLFile(cDir+cPlanilha)

If File(cDir +cPlanilha)
	Aviso( "TTRLPick","A planilha foi gerada em "+UPPER(cDir) +CRLF +"Nome: "+cPlanilha,{"Ok"} )
	If !ApOleClient( 'MsExcel' )
		Aviso( "TTRLPick", "MsExcel nใo instalado. " +CRLF +"O arquivo estแ em: "+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cPlanilha )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  



Return