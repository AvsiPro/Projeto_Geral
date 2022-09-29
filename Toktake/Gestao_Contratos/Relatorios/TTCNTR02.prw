#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTR02   บAutor  ณJackson E. de Deus บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de patrimonios de locacao instalados porem fora   บฑฑ
ฑฑบ          ณde planilha de locacao                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCNTR02()

Local cQuery := ""
Local oExcel := FWMSEXCEL():New()
Local cDir := ""
Local cArqXls := "patrimonios_sem_planilha.xml"
Local cCliente := ""
Local cContrato := ""
Local lTelaCont := .F.
Local cPerg := "TTCNTR02"
Local nOpca := 0

If cEmpAnt == "01"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Diverg๊ncias - Patrim๔nio x Planilha de Loca็ใo") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir uma relacao de patrim๔nios, exibindo suas respectivas") SIZE 268, 8 OF oDlg PIXEL    //"Este relatorio ira emitir uma relacao de medicoes, exibindo suas respectivas"
		@ 38, 15 SAY OemToAnsi("OMM's, data de instala็ใo e local de instala็ใo.") SIZE 268, 8 OF oDlg PIXEL    //"multas/bonificacoes, descontos e caucoes retidas. Favor verificar os  "
		
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 0
		Return
	EndIf
	
	
	If IsInCallStack("U_TTCTAC02")
		lTelaCont := .T.
		cCliente := CN9->CN9_CLIENT
		cContrato := CN9->CN9_NUMERO
	Else
		AjustaSX1(cPerg)
		Pergunte(cPerg,.T.)
	EndIf
	
	cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	
	If Empty(cDir)
		Return
	EndIf
	
	cQuery := "SELECT ZD_CLIENTE, ZD_LOJA, A1_NREDUZ, ZD_PATRIMO, N1_DESCRIC, N1_PRODUTO, ZD_NROOMM, ZD_DATAINS, N1_XSTATTT, N1_XLOCINS FROM " +RetSqlName("SZD") +" SZD "
	
	cQuery += "INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
	cQuery += "SN1.N1_CHAPA = SZD.ZD_PATRIMO "
	cQuery += "AND SN1.D_E_L_E_T_ = SZD.D_E_L_E_T_ "
	cQuery += "AND SN1.N1_XTPSERV = '1' "
	
	cQuery += "INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
	cQuery += "SA1.A1_COD = SZD.ZD_CLIENTE "
	cQuery += "AND SA1.A1_LOJA = SZD.ZD_LOJA "
	cQuery += "AND SA1.D_E_L_E_T_ = SZD.D_E_L_E_T_ "
	
	cQuery += "WHERE SZD.D_E_L_E_T_ = '' "
	cQuery += "AND ZD_IDSTATU = '1' "
	cQuery += "AND ZD_DATAREM = '' "            
	
	If lTelaCont
		cQuery += "AND ZD_CLIENTE = '"+cCliente+"' "
	EndIf
	
	cQuery += "AND ZD_PATRIMO NOT IN ( "
	cQuery += 	"	SELECT ZQ_PATRIM FROM " +RetSqlName("SZQ") "
	cQuery += 	"	WHERE ZQ_PATRIM = SZD.ZD_PATRIMO "
	
	If lTelaCont
		cQuery +=	"	AND ZQ_CONTRA = '"+cContrato+"' "
	Else
		If AllTrim(mv_par02) == ""
			mv_par02 := Replicate("Z",TamSX3("CN9_NUMERO")[1])
		EndIf
		cQuery +=	"	AND ZQ_CONTRA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	EndIf
	
	cQuery += 	"	AND D_E_L_E_T_ = '' "
	cQuery += " )  "
	
	cQuery += " ORDER BY ZD_DATAINS DESC "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf                  
	
	TcQuery cQuery New Alias "TRB"
	
	dbSelectArea("TRB")
	
	
	oExcel:AddworkSheet("Patrimonios") 
	oExcel:AddTable ("Patrimonios","Patrimonios")
	oExcel:AddColumn("Patrimonios","Patrimonios","Cliente",1,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","Loja",1,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","Nome fantasia",1,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","Patrim๔nio",1,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","Descri็ใo",3,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","Produto",2,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","OMM",1,1)
	oExcel:AddColumn("Patrimonios","Patrimonios","Data de instala็ใo",1,1)                                                                 
	oExcel:AddColumn("Patrimonios","Patrimonios","Local fํsico",1,1)                                                              
	
	While !EOF()
		oExcel:AddRow("Patrimonios","Patrimonios",{TRB->ZD_CLIENTE,; 
													TRB->ZD_LOJA,;
													TRB->A1_NREDUZ,;
													TRB->ZD_PATRIMO,;
													TRB->N1_DESCRIC,;
													TRB->N1_PRODUTO,;
													TRB->ZD_NROOMM,;
													dtoc(stod(TRB->ZD_DATAINS)),;
													TRB->N1_XLOCINS })
	
		dbSkip()
	End
	
	dbCloseArea()       
	
	oExcel:Activate()
	
	oExcel:GetXMLFile(cDir +cArqXls)
	
	If File(cDir +cArqXls)
		Aviso("TTCTAC02","A planilha foi gerada em "+cDir,{"Ok"})
		If !ApOleClient( 'MsExcel' )
			Aviso("TTCTAC02", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
		Else
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDir +cArqXls )
			oExcelApp:SetVisible(.T.)         
			oExcelApp:Destroy()
		EndIf
	EndIf  
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  18/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a pergunta do relatorio                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","Contrato De  ?","Contrato De  ?","Contrato De  ?","mv_cha","C",TamSX3("CN9_NUMERO")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CN9")
PutSx1(cPerg,"02","Contrato Ate  ?","Contrato Ate  ?","Contrato Ate  ?","mv_cha","C",TamSX3("CN9_NUMERO")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CN9")
      
Return