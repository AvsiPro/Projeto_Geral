#include "topconn.ch" 
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR09บAutor  ณJackson E. de Deus    บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de KM dos motoristas							  บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ02/03/15ณ01.00 |Criacao                               ณฑฑ 
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROR09()

Local cPerg := "TTPROR09"
Local lEnd := .F. 
Local oDlg 
Local nOpca := 0
Local aDados := {}
Private cDir := ""

If cEmpAnt <> "01"
	return
EndIF

AjustaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de configuracao do Relatorio			         	     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Relat๓rio de KM") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir uma relacao de KM do perํodo") SIZE 268, 8 OF oDlg PIXEL
	@ 38, 15 SAY OemToAnsi(" ") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER


If nOpca == 1
	cDir := AllTrim(MV_PAR04)
	If SubStr(cDir,Len(cDir),1) <> "\"
		cDir += "\"
	EndIf
	
	Processa( { |lEnd| aDados := Retdados(@lEnd) },"Buscando dados, aguarde..")
		
	If Len(aDados) > 0
		Planilha(aDados)	      
	EndIf
EndIf	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetdadosบAutor  ณJackson E. de Deus    บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os dados do relatorio                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Retdados()

Local cSql := ""
Local nCont := 0
Local cAuthCode := "3174CC0FD60FE8B0540591624D43216A592FF9F1"
Local cClientCode := "42CB7AEE2B2FFA173B53" 
Local cResult := ""
Local cError := ""
Local cWarning := ""
Local aMotorista := {}
Local nPos := 0
Local nI := 0
Local aWS := {}
Local aAx := {}
Local cCli := ""
Local cLj := ""

cSql := "SELECT DA4_COD, AA1_PAGER, AA1_NOMTEC FROM " +RetSqlName("DA4") +" DA4 "
cSql += "INNER JOIN " +RetSqlName("AA1") +" AA1 ON "
cSql += "AA1_CODTEC = DA4_COD AND DA4.D_E_L_E_T_ = AA1.D_E_L_E_T_ "
cSql += " WHERE DA4.D_E_L_E_T_ = '' "
cSql += " AND DA4_COD = '"+MV_PAR01+"' " //AND '"+MV_PAR02+"' "
cSql += " ORDER BY DA4_COD"

//cSql := "SELECT AA1_CODTEC, AA1_PAGER, AA1_NOMTEC FROM AA1010 WHERE D_E_L_E_T_ = '' AND AA1_PAGER <> '' AND AA1_CODTEC = '"+MV_PAR01+"' "
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
TRB->( dbGoTop() )
While !EOF()
	IncProc("")
	AADD( aMotorista, { TRB->DA4_COD, TRB->AA1_PAGER, TRB->AA1_NOMTEC, {}, {} } )
	dbSkip()
End
TRB->(dbCloseArea())

// expediente inicial - final
For nI := 1 To Len(aMotorista)
	For dDia := MV_PAR02 To MV_PAR03
		AADD( aWS, cAuthCode ) 
		AADD( aWS, cClientCode ) 
		AADD( aWS, Val(aMotorista[nI][2]) )
		AADD( aWS, FWTimeStamp(3, dDia, Time()) )
		
		cResult := U_WSKPC010(aWS) 
		cResult := U_WSKPF001(cResult)
		nKmIni := 0	
		nKmFim := 0
		If !Empty(cResult)
			oXml := XmlParser( cResult, "_", @cError, @cWarning )
			If oXml != Nil
				If XmlChildEx( oXml, "_STATUSLIST" ) != Nil
					If XmlChildEx( oXml:_STATUSLIST, "_STATUS" ) != NIL
						If ValType(oXml:_STATUSLIST:_STATUS) = "O"
						     XmlNode2Arr(oXml:_STATUSLIST:_STATUS, "_STATUS")
						EndIf
						For nJ := 1 To Len(oXml:_STATUSLIST:_STATUS)
							If XmlChildEx( oXml:_STATUSLIST:_STATUS[nJ], "_STATUSDESCRICAO" ) != NIL
								If "EXPEDIENTE INICIADO" $ UPPER(oXml:_STATUSLIST:_STATUS[nJ]:_STATUSDESCRICAO:TEXT)
									If XmlChildEx( oXml:_STATUSLIST:_STATUS[nJ], "_KM" ) != NIL
										nKmIni := Val(oXml:_STATUSLIST:_STATUS[nJ]:_KM:TEXT)
									EndIf
								ElseIf "EXPEDIENTE ENCERRADO" $ UPPER(oXml:_STATUSLIST:_STATUS[nJ]:_STATUSDESCRICAO:TEXT)
									If XmlChildEx( oXml:_STATUSLIST:_STATUS[nJ], "_KM" ) != NIL
										nKmFim := Val(oXml:_STATUSLIST:_STATUS[nJ]:_KM:TEXT)
									EndIf
								EndIf
							EndIf
						Next nJ
					EndIf	
				EndIf
			EndIf
		EndIf      
		
		AADD( aMotorista[nI][4], { dDia, nKmIni, nKmFim } )
		
		aWS := {}
		cResult := ""
		nKmIni := 0
		nKmFim := 0
	Next dDia
Next nI
	

cSql := "SELECT ZK_CODTEC, ZK_NOMECLI,ZK_NOMTEC, ZK_DTFIM, ZK_NUMOS, ZG_DOC, ZG_SERIE, ZG_OBS FROM " +RetSqlName("SZK") +" SZK "
cSql += " INNER JOIN " +RetSqlName("SZG") +" SZG ON ZK_NUMOS = ZG_NUMOS "
cSql += " WHERE ZK_CODTEC = '"+MV_PAR01+"' " //AND '"+MV_PAR02+"' "
cSql += " AND ZK_DTFIM = '"+DTOS(MV_PAR02)+"' AND ZK_TPFORM = '13' AND SZK.D_E_L_E_T_ = '' " //AND '"+DTOS(MV_PAR04)+"'  "
cSql += " ORDER BY ZK_CODTEC, ZK_DTFIM, ZK_HRFIM"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
TRB->( dbGoTop() )
While !EOF()
	nCont++
	dbSkip()
End

ProcRegua(nCont)
TRB->( dbGoTop() )
While !EOF()
	IncProc("")

	aAx := StrToKarr(TRB->ZG_OBS,"|")
	cCli := AllTrim(aAx[2])
	cLj := AllTrim(aAx[3])
	
	dbSelectArea("SF2")
	dbSetOrder(2) //filial + cliente + loja + doc + serie
	If dbSeek( xFilial("SF2") +AvKey(cCli,"F2_CLIENTE") +AvKey(cLj,"F2_LOJA") +AvKey(TRB->ZG_DOC,"F2_DOC") +AvKey(TRB->ZG_SERIE,"F2_SERIE") )
		cKM := SF2->F2_XENTKM
		nPos := Ascan( aMotorista, {|x| x[1]==TRB->ZK_CODTEC } ) 
		If nPos > 0
			AADD( aMotorista[nPos][5], { stod(TRB->ZK_DTFIM), AllTrim(TRB->ZK_NOMECLI), cKM  } )
		EndIf	
	EndIf
	
	dbSelectArea("TRB")	
	TRB->( dbSkip() )
End

TRB->( dbCloseArea() )
      
aDados := aclone(aMotorista)      
             							      
Return aDados  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlanilhaบAutor  ณJackson E. de Deus    บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a planilha em excel                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Planilha(aDados)  

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "KM"
Local cCabeca := "KM"
Local cTime := Time()
Local nI,nJ
Local cArqXls := "relatorio_km_" +SubStr(cTime,1,2) +SubStr(cTime,4,2) +SubStr(cTime,7) +".xml"  
Local aExcel := {}
Local dData
Local nKM := 0
Local nKmIni := 0
Local nKmFim := 0
Local cMat := ""
Local cNome := ""

oExcel:AddworkSheet(cTitulo) 
oExcel:AddTable (cTitulo,cCabeca)

oExcel:AddColumn(cTitulo,cCabeca,"Matricula",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Nome motorista",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Data",1,1)     
oExcel:AddColumn(cTitulo,cCabeca,"Cliente",1,1)     
oExcel:AddColumn(cTitulo,cCabeca,"Km",3,2)  

For nI := 1 To Len(aDados)
	cMat := aDados[nI][1]
	cNome := aDados[nI][3]
	nKmIni := 0
	nKmFim := 0
	
	// KM de expediente inicial-final
	If Len(aDados[nI][4]) > 0
		dData := aDados[nI][4][1][1]
		nKmIni := aDados[nI][4][1][2]
		nKmFim := aDados[nI][4][1][3]
		AADD( aExcel, { cMat, cNome, dData, "INICIO DE EXPEDIENTE" ,nKmIni } )
	EndIf
	// Km de OS
	If Len(aDados[nI][5]) > 0
		For nJ := 1 To Len(aDados[nI][5])
			dData := aDados[nI][5][nJ][1]
			cCliente := aDados[nI][5][nJ][2]
			nKm := aDados[nI][5][nJ][3]
			AADD( aExcel, { cMat, cNome, dData, cCliente ,nKM } )
		Next nJ
	EndIf
	                                                                   
	If nKmFim > 0
		AADD( aExcel, { cMat, cNome, dData, "FIM DE EXPEDIENTE" ,nKmFim } )
	EndIf      
	
	nKmIni := 0
	nKmFim := 0
Next nI

For nI := 1 To Len(aExcel)
	oExcel:AddRow( cTitulo,cCabeca, aExcel[nI] )
Next nI
     
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	MsgInfo("A planilha foi gerada em "+cDir,"TTPROR09")
	If !ApOleClient( 'MsExcel' )
		MsgInfo('MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
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
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  02/03/15   บฑฑ
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


Local aHelp1 := {"Motorista."}
Local aHelp2 := {"Motorista final."}
Local aHelp3 := {"Data."}
Local aHelp4 := {"Data final."}
Local aHelp5 := {"Escolha o local para salvar o relat๓rio."}

PutSX1(cPerg,"01","Motorista de ?","Motorista de ?","Motorista de ?" ,"mv_cha","C",50,0,0,"G","","AA1","","S","mv_par01","","","","","","","","","","","","","","","","",aHelp1,aHelp1,aHelp1)     
PutSx1(cPerg,'02','Data de ?','Data de ?' ,'Data de ?','mv_chc','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','',aHelp3,aHelp3,aHelp3)
PutSx1(cPerg,'03','Data ate ?','Data ate ?' ,'Data ate ?','mv_chd','D',8,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','',aHelp4,aHelp4,aHelp4)
PutSX1(cPerg,"04","Salvar em:","Salvar em:","Salvar em:" ,"mv_che","C",50,0,0,"G","ExistDir(MV_PAR04)","RETDIR","","S","mv_par04","","","","","","","","","","","","","","","","",aHelp5,aHelp5,aHelp5)     

Return