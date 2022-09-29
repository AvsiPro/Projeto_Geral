#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATR29  บAutor  ณJackson E. de Deus  บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de notas de saida com romaneio x Os Mobile        บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ04/11/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFATR29()

Local cPerg := "TTFATR29"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

If cEmpAnt == "01"
	AjustaSX1(cPerg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Notas x OS") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir uma relacao de notas de saida x OS Mobile") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte("TTFATR29",.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1  
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If !Empty(cDir)
			Processa( { |lEnd| Gerar(@lEnd)   },"Gerando relatorio, aguarde..")
		Else
			Aviso("TTFATR29","Escolha um diret๓rio vแlido.",{"Ok"})
		EndIf
	EndIf
endif
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerar		บAutor  ณJackson E. de Deus  บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o relatorio em planilha de excel.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gerar(lEnd)

Local cSql := ""
Local nCont := 0
Local cQuery := ""
Local oExcel := FWMSEXCEL():New()
Local cArqXls := "notas_x_os.xml"
Local lNfSaida := .T. 
              
// nota final             
If Empty(MV_PAR02)
	MV_PAR02 := "ZZZZZ"
EndIf

// data inicial
If Empty(MV_PAR03)
	MV_PAR03 := ddatabase
EndIf             
               
// data final
If Empty(MV_PAR04)
	MV_PAR04 := ddatabase
EndIf

If ValType(_lNfSaida) <> Nil
	lNfSaida := _lNfSaida
EndIf

// saida
If lNfSaida
	cSql := "SELECT F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE CLIFOR, F2_LOJA LOJA, F2_XCODPA CODPA, F2_EMISSAO EMISSAO, F2_XDTROM DTROM, F2_XCARGA CARGA, "
	cSql += " ZG_NUMOS, ZG_DESCFRM, ZG_STATUSD, ZG_AGENTED, ZG_DESCCF  "
	cSql += " FROM " +RetSqlName("SF2") +" SF2 "
	cSql += " LEFT JOIN " +RetSqlName("SZG") +" SZG ON "
	cSql += " SZG.ZG_DOC = SF2.F2_DOC AND SZG.ZG_SERIE = SF2.F2_SERIE AND SZG.D_E_L_E_T_ = '' "
	cSql += " AND SZG.ZG_TPFORM IN ('1','13') "
	cSql += " WHERE "           
	cSql += " SF2.F2_FILIAL = '"+xFilial("SF2")+"' "                                                        
	cSql += " AND SF2.F2_SERIE = '2' "
	cSql += " AND SF2.F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 
	cSql += " AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	
	
	If !Empty(MV_PAR05)
		cSql += " AND SF2.F2_XCARGA = '"+MV_PAR05+"' "
	EndIf
	
	cSql += "ORDER BY F2_DOC"
// devolucao
Else 
	cSql := "SELECT F1_DOC DOC, F1_SERIE SERIE, F1_FORNECE CLIFOR, F1_LOJA LOJA, '' CODPA, F1_EMISSAO EMISSAO, F1_XDTROM DTROM, F1_XCARGA CARGA, "
	cSql += " ZG_NUMOS, ZG_DESCFRM, ZG_STATUSD, ZG_AGENTED, ZG_DESCCF  "
	cSql += " FROM " +RetSqlName("SF2") +" SF1 "
	cSql += " LEFT JOIN " +RetSqlName("SZG") +" SZG ON "
	cSql += " SZG.ZG_DOC = SF1.F1_DOC AND SZG.ZG_SERIE = SF1.F1_SERIE AND SZG.D_E_L_E_T_ = '' "
	cSql += " AND SZG.ZG_TPFORM IN ('1','13') "
	cSql += " WHERE "           
	cSql += " SF2.F1_FILIAL = '"+xFilial("SF1")+"' "                                                        
	cSql += " AND SF1.F1_SERIE = '2' "
	cSql += " AND SF1.F1_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 
	cSql += " AND SF1.F1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	
	
	If !Empty(MV_PAR05)
		cSql += " AND SF1.F1_XCARGA = '"+MV_PAR05+"' "
	EndIf
	
	cSql += "ORDER BY F1_DOC"
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR29","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)

//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Nota de: ", mv_par01 } )
oExcel:AddRow("Parametros","Parametros",{"Nota ate: ", mv_par02 } )
oExcel:AddRow("Parametros","Parametros",{"Data de: ", dtoc(mv_par03) } )
oExcel:AddRow("Parametros","Parametros",{"Data ate: ", dtoc(mv_par04) } )
oExcel:AddRow("Parametros","Parametros",{"Romaneio: " , mv_par05 } )


oExcel:AddworkSheet("Notas") 
oExcel:AddTable ("Notas","Relatorio")
oExcel:AddColumn("Notas","Relatorio","Nota",1,1)
oExcel:AddColumn("Notas","Relatorio","Serie",1,1)
oExcel:AddColumn("Notas","Relatorio","Cliente",1,1)
oExcel:AddColumn("Notas","Relatorio","Loja",1,1)
oExcel:AddColumn("Notas","Relatorio","Nome",1,1)
oExcel:AddColumn("Notas","Relatorio","PA",1,1)
oExcel:AddColumn("Notas","Relatorio","Emissao",1,4)  
oExcel:AddColumn("Notas","Relatorio","Romaneio",1,1)                                                              
oExcel:AddColumn("Notas","Relatorio","Data romaneio",1,4)
oExcel:AddColumn("Notas","Relatorio","OS Mobile",1,1) 
oExcel:AddColumn("Notas","Relatorio","Formulแrio",1,1) 
oExcel:AddColumn("Notas","Relatorio","Agente",1,1) 
oExcel:AddColumn("Notas","Relatorio","Status OS",1,1) 
 
dbGoTop()
While !EOF()
	IncProc("NF: "+TRB->DOC +" - " +	dtoc(stod(TRB->EMISSAO)) )
	oExcel:AddRow("Notas","Relatorio",{TRB->DOC,; 
										TRB->SERIE,;
										TRB->CLIFOR,;
										TRB->LOJA,;
										TRB->ZG_DESCCF,;
										TRB->CODPA,;
										dtoc(stod(TRB->EMISSAO)),;
										TRB->CARGA,;
										dtoc(stod(TRB->DTROM)),;						
										TRB->ZG_NUMOS,;
										TRB->ZG_DESCFRM,;
										TRB->ZG_AGENTED,;
										TRB->ZG_STATUSD })

	dbSkip()
End
dbCloseArea()       
   
oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR29","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR29", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  04/11/14   บฑฑ
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

PutSx1(cPerg,"01","Nota De ?","Nota De ?","Nota De ?","mv_cha","C",9,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Nota Ate ?","Nota Ate ?","Nota Ate ?","mv_chb","C",9,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Data De ?","Data De ?","Data De ?","mv_chc","D",8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Data Ate ?","Data Ate ?","Data Ate ?","mv_chd","D",8,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Romaneio ?","Romaneio ?","Romaneio ?","mv_che","C",15,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","")
      
Return