#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR08  บAutor  ณJackson E. de Deus  บ Data ณ  03/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Indicadores de Processo.		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ03/03/15ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROR08()

Local cPerg := "TTPROR08"
Local lEnd := .F. 
Local oDlg 
Local nOpca := 0   
Local nOpcao := 1
Local aDados := {}
Private cDir := ""

If cEmpAnt <> "01"
	return
EndIF

AjustaSX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de configuracao do Relatorio			         	     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Indicadores de processos") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir os indicadores de processos") SIZE 268, 8 OF oDlg PIXEL
	@ 38, 15 SAY OemToAnsi(" - Atendimentos de Ordens de Servi็o ") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER


If nOpca == 1
	If Empty(MV_PAR01)
		MV_PAR01 := dDatabase
	EndIf
	
	If Empty(MV_PAR02)
		MV_PAR02 := dDatabase
	EndIf
	                        
	cDir := AllTrim(MV_PAR05)
	If SubStr(cDir,Len(cDir),1) <> "\"
		cDir += "\"
	EndIf
	      
	If MV_PAR03 == 3    
		nOpcao := 3
	ElseIf MV_PAR03 == 2
		nOpcao := 2
	EndIf	
         
	MsAguarde({ || aDados := StaticCall(TTOPER17,Proces,MV_PAR01,MV_PAR02,MV_PAR04,.T.,nOpcao) },"Obtendo apontamentos, por favor aguarde...")
        
	If Len(aDados) > 0
		Processa( { |lEnd| Planilha(aDados,nOpcao)  },"Gerando relat๓rio, aguarde..")
	Else
		MsgInfo("Nใo hแ dados.")
	EndIf	
EndIf	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlanilhaบAutor  ณJackson E. de Deus    บ Data ณ  03/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a planilha em excel                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Planilha(aDados,nOpcao)  

Local oExcel := Nil
Local cTitulo := "Indicadores"
Local cCabeca := "indicadores"
Local cTime := Time()
Local nI
Local nJ
Local cArqXls := ""
Local aInfo := {}
Local aM := {}
Local aM2 := {}
Local nCont := 0
Local nCntTot := 0
Local aPlan := {}       
Local aRet := {}
Local aGeren := {}
Local aSuper := {}
Local cTipo := ""
Local cNomAtend := AllTrim(Posicione("AA1",1,xFilial("AA1")+AvKey( MV_PAR04,"AA1_CODTEC"),"AA1_NOMTEC"))
Local cRota := Posicione("AA1",1,xFilial("AA1")+AvKey( MV_PAR04,"AA1_CODTEC"),"AA1_LOCAL")
Local nTotAtend := 0
Local nProd1 := 0
Local nProd2 := 0
Local nTmpM1 := 0
Local nTmpM2 := 0
Local nTmpM3 := 0
Local nTmpM4 := 0
Local nInd1 := 0
Local nInd2 := 0
Local nAtd1 := 0
Local nAtd2 := 0
Local nAtdPg1 := 0
Local nAtdPg2 := 0
Local nSales1 := 0
Local nSales2 := 0
Local nAbast := 0
Local nAbst1 := 0
Local nAbst2 := 0
Local nTmpG1 := 0
Local nTmpG2 := 0
Local nTmpD1 := 0
Local nTmpD2 := 0
Local nGInd1 := 0
Local nGInd2 := 0
Local nGAtd1 := 0
Local nGAtd2 := 0
Local nGAtdPg1 := 0
Local nGAtdPg2 := 0
Local nGProd1 := 0
Local nGProd2 := 0
Local nGnTmp1 := 0
Local nGnTmp2 := 0
Local nGnTmp3 := 0
Local nGnTmp4 := 0
Local nTtOc := 0
Local nTtPo := 0
Local nTtSl := 0
Local nTtAb := 0
Local nTtTg := 0
Local nTtTd := 0
Local aMedia := {}

// atendente
If nOpcao == 1
	cTipo := "Atendente"
	aRet := aclone(aDados[1])        
	For nI := 4 To Len(aRet)
		AADD( aInfo, aRet[nI] )
	Next nI
	
	For nI := 1 To Len(aInfo)
		If aInfo[nI][1] == 1
			AADD( aM, aInfo[nI] )
		ElseIf aInfo[nI][1] == 2
			AADD( aM2, aInfo[nI] )
		EndIf
	Next nI
	
	ProcRegua(2)	
	IncProc("")
	
	// OS pontuais - chamados
	If Len(aM) > 0		
		For nI := 1 To Len(aM)				     
			oExcel := FWMSEXCEL():New()
			cArqXls := "os_pt_acumulado_" +LOWER(StrTran(cNomAtend," ","_"))  +".xml" 
			
			aTot := aM[nI][2]
			aTotAcm := aM[nI][3]
			aOS := aM[nI][6]    
			aOsPend := aM[nI][5]
			//ASort( aOS, , , { |x,y| x[27] > y[27] } )
			
			oExcel:AddworkSheet("Parametros")
			oExcel:AddTable ("Parametros","Parametros")
			oExcel:AddColumn("Parametros","Parametros","Parโmetro",1,1)
			oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)
			
			oExcel:AddRow( "Parametros","Parametros", { cTipo, cNomAtend } )
			oExcel:AddRow( "Parametros","Parametros", { "Matrํcula", alltrim(mv_par04) } )
			oExcel:AddRow( "Parametros","Parametros", { "Data inicial", dtoc(MV_PAR01) } )
			oExcel:AddRow( "Parametros","Parametros", { "Data final", dtoc(MV_PAR02) } )
			oExcel:AddRow( "Parametros","Parametros", { "Tipo de atendimento", "OS pontuais" } )
			oExcel:AddRow( "Parametros","Parametros", { "Caminho do relat๓rio", alltrim(MV_PAR05) } )                                                                                                             
	
						
			// indices      
			oExcel:AddworkSheet("Indicadores")
			oExcel:AddTable ("Indicadores","Indicadores")
			oExcel:AddColumn("Indicadores","Indicadores","Indicador",1,1)
			oExcel:AddColumn("Indicadores","Indicadores","Unidade",1,1)
			oExcel:AddColumn("Indicadores","Indicadores","Acumulado at้ "+dtoc(MV_PAR02),1,1)
			oExcel:AddColumn("Indicadores","Indicadores","Resultado " +dtoc(MV_PAR02),1,1)
			
			// os pendentes
			oExcel:AddworkSheet("Os_pendentes")
			oExcel:AddTable ("Os_pendentes","Os_pendentes")
			oExcel:AddColumn("Os_pendentes","Os_pendentes","Data agendada",3,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","Hora agendada",3,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","OS",1,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","PA Cliente",1,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","Patrim๔nio",1,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","Modelo",1,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","Obs sobre o defeito",1,1)
			oExcel:AddColumn("Os_pendentes","Os_pendentes","Tempo de atraso",3,1)
			
			// os finalizadas
			oExcel:AddworkSheet("Os_finalizadas")
			oExcel:AddTable ("Os_finalizadas","Os_finalizadas")
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Data de inicializa็ใo",3,1) //
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Hora de inicializa็ใo",3,1) //
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Data de finaliza็ใo",3,1) //
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Hora de finaliza็ใo",3,1) //
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Data agendada",3,1) //
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Hora agendada",3,1) //
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","PA Cliente",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","OS",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Patrim๔nio",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Modelo",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Tempo de deslocamento",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Tempo utilizado",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Tempo de atraso",3,1)
			
			// indicadores
			oExcel:AddRow( "Indicadores","Indicadores", { "OS finalizadas", "Qtd",CValToChar(aTotAcm[1]),CValToChar(aTot[1])  } )
			oExcel:AddRow( "Indicadores","Indicadores", { "OS finalizadas no prazo", "Qtd",CValToChar(aTotAcm[2]),CValTochar(aTot[2]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "OS finalizadas em atraso", "Qtd",CValToChar(aTotAcm[3]),CValToChar(aTot[3]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Produtividade", "Qtd/Dia",transform( atotacm[4], "@E 999,999.99" ) ,transform( atot[4], "@E 999,999.99" )  } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Tempo m้dio de atendimento", "Hora",IntToHora(aTotAcm[5]),IntToHora(aTot[5]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Tempo m้dio de OS em atraso", "Hora",IntToHora(aTotAcm[6]),IntToHora(aTot[6]) } )
															
			// os pendentes
			For nJ := 1 To Len(aOsPend)
				oExcel:AddRow( "Os_pendentes","Os_pendentes", { dtoc(aOsPend[nJ][2]),;
																aOsPend[nJ][3],;
																aOsPend[nJ][1],;
																aOsPend[nJ][10],;
																aOsPend[nJ][6],;
																aOsPend[nJ][7],;
																aOsPend[nJ][8],;
																IntToHora(aOsPend[nJ][11]) } )
			Next nJ
			                       
		  	For nJ := 1 To Len(aOS)
		  	
		  		
				oExcel:AddRow( "Os_finalizadas","Os_finalizadas", { dtoc(aOS[nJ][22]),;
																	StrTran(aOS[nJ][23],".",":"),;
																	dtoc(aOS[nJ][21]),;
																	StrTran(aOS[nJ][20],".",":"),;
																	dtoc(aOS[nJ][10]),;
																	aOS[nJ][11],;
																	aOS[nJ][26],;
																	aOS[nJ][1],;
																	aOS[nJ][16],;
																	aOS[nJ][17],;
																	IntToHora(aOS[nJ][28]),;
																	IntToHora(aOS[nJ][27]),;
																	IntToHora(aOS[nJ][29]) } )
			Next nJ
			nCont++	   
		Next nI
		If nCont > 0
			oExcel:Activate()
			oExcel:GetXMLFile(cDir +cArqXls)
			If File(cDir +cArqXls)
				AADD( aPlan, cDir +cArqXls )
				nCntTot++             
			EndIf
		EndIf
	EndIf	
	
	nCont := 0
	IncProc("")
	
	// programadas
	If Len(aM2) > 0	
		For nI := 1 To Len(aM2)  
			oExcel := FWMSEXCEL():New()
			cArqXls := "os_pr_acumulado_" +lower(StrTran(cNomAtend," ","_")) +".xml"
			
			aTot := aM2[nI][2]
			aTotAcm := aM2[nI][3]
			aOS := aM2[nI][6]
			
			// parametros
			oExcel:AddworkSheet("Parametros")
			oExcel:AddTable ("Parametros","Parametros")
			oExcel:AddColumn("Parametros","Parametros","Parโmetro",1,1)
			oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)
			
			oExcel:AddRow( "Parametros","Parametros", { cTipo, cNomAtend } )
			oExcel:AddRow( "Parametros","Parametros", { "Matrํcula", alltrim(mv_par04) } )
			oExcel:AddRow( "Parametros","Parametros", { "Data inicial", dtoc(MV_PAR01) } )
			oExcel:AddRow( "Parametros","Parametros", { "Data final", dtoc(MV_PAR02) } )
			oExcel:AddRow( "Parametros","Parametros", { "Tipo de atendimento", "OS programadas" } )
			oExcel:AddRow( "Parametros","Parametros", { "Caminho do relat๓rio", alltrim(MV_PAR05) } )    
			
			// indices      
			oExcel:AddworkSheet("Indicadores")
			oExcel:AddTable ("Indicadores","Indicadores")
			oExcel:AddColumn("Indicadores","Indicadores","Indicador",1,1)
			oExcel:AddColumn("Indicadores","Indicadores","Unidade",1,1)
			oExcel:AddColumn("Indicadores","Indicadores","Acumulado at้ "+dtoc(MV_PAR02),1,1)
			oExcel:AddColumn("Indicadores","Indicadores","Resultado " +dtoc(MV_PAR02),1,1)
			
			// os finalizadas
			oExcel:AddworkSheet("Os_finalizadas")
			oExcel:AddTable ("Os_finalizadas","Os_finalizadas")
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Data de inicializa็ใo",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Hora de inicializa็ใo",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Data de finaliza็ใo",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Hora de finaliza็ใo",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Data agendada",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Hora agendada",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","OS",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","PA Cliente",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Patrim๔nio",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Modelo",1,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Tempo gasto",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Tempo deslocamento",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Tempo atraso",3,1)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","SALE",3,2)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Abastecimento",3,2)
			oExcel:AddColumn("Os_finalizadas","Os_finalizadas","Corre็๕es de Apontamentos",3,2)
			
	
			// indicadores
			oExcel:AddRow( "Indicadores","Indicadores", { "OS finalizadas", "Qtd",CValToChar(aTotAcm[1]),CValToChar(aTot[1])  } )
			oExcel:AddRow( "Indicadores","Indicadores", { "OS finalizadas no prazo", "Qtd",CValToChar(aTotAcm[2]),CValTochar(aTot[2]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "OS finalizadas em atraso", "Qtd",CValToChar(aTotAcm[3]),CValToChar(aTot[3]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "OS nใo finalizadas/canceladas agente", "Qtd",CValToChar(aTotAcm[4]),CValToChar(aTot[4]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "OS canceladas", "Qtd",CVALTOCHAR(aTotAcm[5]),CVALTOCHAR(aTot[5]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Maior tempo de deslocamento", "Hora",IntToHora(aTotAcm[6]),IntToHora(aTot[6]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Maior tempo gasto", "Hora",IntToHora(aTotAcm[7]),IntToHora(aTot[7]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Atendimento das OS no prazo", "%",CVALTOCHAR(aTotAcm[8]),CVALTOCHAR(aTot[8]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Atendimento da QTD de OS programada", "%",CVALTOCHAR(aTotAcm[9]),CVALTOCHAR(aTot[9]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Total sale", "Qtd", CVALTOCHAR(aTotAcm[10]) , CVALTOCHAR(aTot[10]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Abastecimento", "%", cvaltochar(aTotAcm[12]) , cvaltochar(aTot[12]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Tempo gasto", "%", cvaltochar(aTotAcm[15]) , cvaltochar(aTot[15]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Tempo de deslocamento", "%", cvaltochar(aTotAcm[16]) , cvaltochar(aTot[16]) } )
			oExcel:AddRow( "Indicadores","Indicadores", { "Corre็๕es de Apontamentos", "Qtd", cvaltochar(aTotAcm[17]) , cvaltochar(aTot[17]) } )
			
			For nJ := 1 To Len(aOS)
				dDtIni := aOS[nJ][22]
				dDtFim := aOS[nJ][21]
				dDtAg := aOS[nJ][10]
		  		cHrAg := StrTran(aOS[nJ][11],".",":")
		  		cHrIni := StrTran(aOS[nJ][23],".",":")
		  		cHrFim := StrTran(aOS[nJ][20],".",":")	
		  		cTmpAtend := aOS[nJ][27]
		  		cTmpDeslc := aOS[nJ][28]
		  		cTmpAtras := aOS[nJ][29]
		  		nSale := aOS[nJ][30]
		  		nAbast := aOS[nJ][31]
		  		nCorrec := aOS[nJ][32]
		
		  		// converte
		  		cTmpAtend := StrTran(IntToHora(cTmpAtend),".",":")
		  		cTmpDeslc := StrTran(IntToHora(cTmpDeslc),".",":")
		  		cTmpAtras := StrTran(IntToHora(cTmpAtras),".",":")
				
				oExcel:AddRow( "Os_finalizadas","Os_finalizadas", { dtoc(dDtIni),;
																	cHrIni,;
																	dtoc(dDtFim),;
																	cHrFim,;
																	dtoc(dDtAg),;
																	cHrAg,;
																	aOS[nJ][1],;
																	aOS[nJ][26],;
																	aOS[nJ][16],;
																	aOS[nJ][17],;
																	cTmpAtend,;
																	cTmpDeslc,;
																	cTmpAtras,;
																	nSale,;
																	nAbast,;
																	nCorrec } )
			Next nJ
			nCont++	  
		Next nI
		If nCont > 0
			oExcel:Activate()
			oExcel:GetXMLFile(cDir +cArqXls)
			If File(cDir +cArqXls)
				AADD( aPlan, cDir +cArqXls )
				nCntTot++             
			EndIf
		EndIf
	EndIf		
		
// supervisor
ElseIf nOpcao == 2
	cTipo := "Supervisor"
	aRet := aclone(aDados)
	aDados := {}
	For nI := 1 To Len(aRet)
		aDados := Aclone( aRet[nI] )
		AADD( aSuper, aDados )
	Next nI                 
	
	For nI := 1 To Len(aSuper)
		If aSuper[nI][4][1] == 1
			AADD( aM, { aSuper[nI][1],;
						aSuper[nI][4][2],;
						aSuper[nI][4][3] } )
		ElseIf aSuper[nI][4][1] == 2
			AADD( aM2, { aSuper[nI][1],;
						aSuper[nI][4][2],;
						aSuper[nI][4][3] } )	
		EndIf	
	Next nI
	
	ProcRegua(2)
	IncProc("")
	           
	nTotAtend := 0
	nTmpM1 := 0
	nTmpM2 := 0
	nTmpM3 := 0
	nTmpM4 := 0
	nInd1 := 0
	nInd2 := 0
	nAtd1 := 0
	nAtd2 := 0
	nAtdPg1 := 0
	nAtdPg2 := 0
	nSales1 := 0
	nSales2 := 0
		       
	// pontuais
	If Len(aM) > 0
		oExcel := FWMSEXCEL():New()
		cArqXls := "os_pt_acumulado_" +lower(StrTran(cNomAtend," ","_"))  +".xml"
		
		oExcel:AddworkSheet("Parametros")
		oExcel:AddTable ("Parametros","Parametros")
		oExcel:AddColumn("Parametros","Parametros","Parโmetro",1,1)
		oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)
		
		oExcel:AddRow( "Parametros","Parametros", { cTipo, cNomAtend } )
		oExcel:AddRow( "Parametros","Parametros", { "Matrํcula", alltrim(mv_par04) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data inicial", dtoc(MV_PAR01) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data final", dtoc(MV_PAR02) } )
		oExcel:AddRow( "Parametros","Parametros", { "Tipo de atendimento", "OS pontuais" } )
		oExcel:AddRow( "Parametros","Parametros", { "Caminho do relat๓rio", alltrim(MV_PAR05) } )                                                                                                             
				
		// indices      
		oExcel:AddworkSheet("Indicadores")
		oExcel:AddTable ("Indicadores","Indicadores")
		oExcel:AddColumn("Indicadores","Indicadores","Atendente",1,1)
		oExcel:AddColumn("Indicadores","Indicadores","Produtividade - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Produtividade - Resultado "+dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio at้ o atendimento - Consolidado at้ " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio at้ o atendimento - Resultado " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio de OS em atraso - Consolidado at้ " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio de OS em atraso - Resultado " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo gasto do dia",3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo de deslocamento do dia",3,1)
		
		For nI := 1 To Len(aM)
			cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )	
			oExcel:AddRow( "Indicadores","Indicadores", { cAtend,;
														aM[nI][3][4],;
														aM[nI][2][4],;
														IntToHora(aM[nI][3][5]),;
														IntToHora(aM[nI][2][5]),;
														IntToHora(aM[nI][3][6]),;
														IntToHora(aM[nI][2][6]),;
														IntToHora(aM[nI][2][8]),;
														IntToHora(aM[nI][2][7]) } )
		
			// somatorio/media supervisor
			nProd1 += aM[nI][3][4]
			nProd2 += aM[nI][2][4]
			nTmpM1 += aM[nI][3][5]
			nTmpM2 += aM[nI][2][5]
			nTmpM3 += aM[nI][3][6]
			nTmpM4 += aM[nI][2][6]
		
			If nI = Len(aM)
				nTotAtend := Len(aM)
				nTmpM1 := nTmpM1/nTotAtend
				nTmpM2 := nTmpM2/nTotAtend
				nTmpM3 := nTmpM3/nTotAtend
				nTmpM4 := nTmpM4/nTotAtend
	
				oExcel:AddRow( "Indicadores","Indicadores", { "RESULTADO SUPERVISOR",;
															nProd1,;
															nProd2,;
															IntToHora(nTmpM1),;
															IntToHora(nTmpM2),;
															IntToHora(nTmpM3),;
															IntToHora(nTmpM4),;
															"",;
															"" })
				
			EndIf
		
			nCont++
		Next nI
		If nCont > 0
			oExcel:Activate()
			oExcel:GetXMLFile(cDir +cArqXls)
			If File(cDir +cArqXls)
				AADD( aPlan, cDir +cArqXls )
				nCntTot++             
			EndIf
		EndIf
	EndIf	
	       
	nCont := 0    
	IncProc("")
			                      
	// programadas
	If Len(aM2) > 0
		oExcel := FWMSEXCEL():New()
		cArqXls := "os_pr_acumulado_" +lower(StrTran(cNomAtend," ","_"))  +".xml"
		
		oExcel:AddworkSheet("Parametros")
		oExcel:AddTable ("Parametros","Parametros")
		oExcel:AddColumn("Parametros","Parametros","Parโmetro",1,1)
		oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)
		
		oExcel:AddRow( "Parametros","Parametros", { cTipo, cNomAtend } )
		oExcel:AddRow( "Parametros","Parametros", { "Matrํcula", alltrim(mv_par04) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data inicial", dtoc(MV_PAR01) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data final", dtoc(MV_PAR02) } )
		oExcel:AddRow( "Parametros","Parametros", { "Tipo de atendimento", "OS programadas" } )
		oExcel:AddRow( "Parametros","Parametros", { "Caminho do relat๓rio", alltrim(MV_PAR05) } )
		
		// indices      
		oExcel:AddworkSheet("Indicadores")
		oExcel:AddTable ("Indicadores","Indicadores")
		oExcel:AddColumn("Indicadores","Indicadores","Atendente",1,1)
		oExcel:AddColumn("Indicadores","Indicadores","Indice de ociosidade - Consolidado at้ " +dtoc(MV_PAR02),3,2)		//
		oExcel:AddColumn("Indicadores","Indicadores","Indice de ociosidade - Resultado " +dtoc(MV_PAR02),3,2)			//
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento das OS no prazo - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento das OS no prazo - Resultado " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento da programa็ใo das OS - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento da programa็ใo das OS - Resultado " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Total Sale - Consolidado at้ " +dtoc(MV_PAR02),3,2)	//
		oExcel:AddColumn("Indicadores","Indicadores","Total Sale - Resultado" +dtoc(MV_PAR02),3,2)			//
		oExcel:AddColumn("Indicadores","Indicadores","Abastecimento - Consolidado at้ " +dtoc(MV_PAR02),3,2)//
		oExcel:AddColumn("Indicadores","Indicadores","Abastecimento - Resultado " +dtoc(MV_PAR02),3,2)		//
		oExcel:AddColumn("Indicadores","Indicadores","Tempo gasto - Consolidado at้ " +dtoc(MV_PAR02),1,2)	//
		oExcel:AddColumn("Indicadores","Indicadores","Tempo gasto - Resultado " +dtoc(MV_PAR02),1,2)		//
		oExcel:AddColumn("Indicadores","Indicadores","Tempo de deslocamento - Consolidado at้ " +dtoc(MV_PAR02),1,2)	//
		oExcel:AddColumn("Indicadores","Indicadores","Tempo de deslocamento - Resultado " +dtoc(MV_PAR02),1,2)			//
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo gasto do dia",3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo de deslocamento do dia",3,1)
		
		For nI := 1 To Len(aM2)
			cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM2[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
			oExcel:AddRow( "Indicadores","Indicadores", { cAtend,;
														aM2[nI][3][11],;
														aM2[nI][2][11],;
														aM2[nI][3][8],;	// alterado 21/05 SOLIC. FELIPE
														aM2[nI][2][8],;	// alterado 21/05 SOLIC. FELIPE
														aM2[nI][3][9],;
														aM2[nI][2][9],;
														aM2[nI][3][10],;
														aM2[nI][2][10],;
														aM2[nI][3][12],;
														aM2[nI][2][12],;
														aM2[nI][3][15],;
														aM2[nI][2][15],;
														aM2[nI][3][16],;
														aM2[nI][2][16],;
														IntToHora(aM2[nI][2][7]),;
														IntToHora(aM2[nI][2][6]) } )
	
			// somatorio/media supervisor // rever regra de calculo de cada coluna
			// "Indice de Ociosidade", "Total Sale ??", "Abastecimento", Tempo Gasto", Tempo de Deslocamento" 
			// atendimento da programacao??
			/*
			nInd1 += aM2[nI][3][11]	//
			nInd2 += aM2[nI][2][11]	//
			nAtd1 += aM2[nI][3][8]
			nAtd2 += aM2[nI][2][8]
			nAtdPg1 += aM2[nI][3][9]	//
			nAtdPg2 += aM2[nI][2][9]	//
			nSales1 += aM2[nI][3][10]	//
			nSales2 += aM2[nI][2][10]	//
			nAbst1 += aM2[nI][3][12]	//
			nAbst2 += aM2[nI][2][12]	//
			nTmpG1 += aM2[nI][3][15]	//
			nTmpG2 += aM2[nI][2][15]	//
			nTmpD1 += aM2[nI][3][16]	//
			nTmpD2 += aM2[nI][2][16]	//
			
			nTtOc++  
			nTtPo++
			//nTtSl++
			nTtAb++
			nTtTg++
			nTtTd++
			
			// tratamento
			If aM2[nI][2][11] == 0
				nTtOc--
			EndIf
			
			If aM2[nI][2][9] == 0
				nTtPo--
			EndIf
			
			//If aM2[nI][2][10] == 0
				//nTtSl--        
			//EndIf
			
			If aM2[nI][2][12] == 0
				nTtAb--
			EndIf
			           
			If aM2[nI][2][15] == 0
				nTtTg--
			EndIf
                       
			If aM2[nI][2][16] == 0
				nTtTd--
			EndIf
            */
            /*
			If nI = Len(aM2)
				nTotAtend := Len(aM2)
				nInd1 := nInd1/nTotAtend
				nInd2 := nInd2/nTtOc
				nAtd1 := nAtd1/nTotAtend
				nAtd2 := nAtd2/nTotAtend
				nAtdPg1 := nAtdPg1/nTotAtend
				nAtdPg2 := nAtdPg2/nTtPo
				nAbst1 := nAbst1/nTotAtend
				nAbst2 := nAbst2/nTtAb
				nTmpG1 := nTmpG1/nTotAtend 
				nTmpG2 := nTmpG2/nTtTg
				nTmpD1 := nTmpD1/nTotAtend
				nTmpD2 := nTmpD2/nTtTd
				
				oExcel:AddRow( "Indicadores","Indicadores", { "RESULTADO SUPERVISOR",;
															nInd1,;
															nInd2,;
															nAtd1,;
															nAtd2,;
															nAtdPg1,;
															nAtdPg2,;
															nSales1,;
															nSales2,;
															nAbst1,;
															nAbst2,;
															nTmpG1,;
															nTmpG2,;
															nTmpD1,;
															nTmpD2,;													
															"",;
															"" })
			EndIf
			*/
			nCont++
		Next nI
		aMedia := StaticCall(TTOPER17,MediaSup,aM2)
		If Len(aMedia) > 0
			oExcel:AddRow( "Indicadores","Indicadores", { "RESULTADO SUPERVISOR",;
															aMedia[1][1],;
															aMedia[1][2],;
															aMedia[1][3],;
															aMedia[1][4],;
															aMedia[1][5],;
															aMedia[1][6],;
															aMedia[1][7],;
															aMedia[1][8],;
															aMedia[1][9],;
															aMedia[1][10],;
															aMedia[1][11],;
															aMedia[1][12],;
															aMedia[1][13],;
															aMedia[1][14],;													
															"",;
															"" })
		EndIf													
		If nCont > 0
			oExcel:Activate()
			oExcel:GetXMLFile(cDir +cArqXls)
			If File(cDir +cArqXls)
				AADD( aPlan, cDir +cArqXls )
				nCntTot++             
			EndIf
		EndIf   
	EndIf	
	 
// gerente
ElseIf nOpcao == 3
	cTipo := "Gerente"
	aRet := aclone(aDados)
	aDados := {}
	For nI := 1 To Len(aRet)
		aDados := Aclone( aRet[nI] )
		AADD( aSuper, aDados )
	Next nI                 
	
	For nI := 1 To Len(aSuper)
		If aSuper[nI][4][1] == 1
			AADD( aM, { aSuper[nI][2],;
						aSuper[nI][4][2],;
						aSuper[nI][4][3] } )
		ElseIf aSuper[nI][4][1] == 2
			AADD( aM2, { aSuper[nI][2],;
						aSuper[nI][4][2],;
						aSuper[nI][4][3] } )	
		EndIf	
	Next nI
	
	// agrupa pontuais
	aSp := {}
	For nI := 1 To Len(aM)
		If Ascan( aSp, { |x| x[1] == aM[nI][1] } ) == 0
			AADD( aSp, { aM[nI][1] } )
		EndIf
	Next nI  
	
	For nI := 1 To Len(aSP)
		For nJ := 1 To Len(aM)
			If aSP[nI][1] == aM[nJ][1]
				AADD( aSP[nI], aM[nJ] )
			EndIf
		Next nJ
	Next nI
	aM := Aclone(aSP)
	

	// agrupa programadas
	aSp := {}
	For nI := 1 To Len(aM2)
		If Ascan( aSp, { |x| x[1] == aM2[nI][1] } ) == 0
			AADD( aSp, { aM2[nI][1] } )
		EndIf
	Next nI  
	
	For nI := 1 To Len(aSP)
		For nJ := 1 To Len(aM2)
			If aSP[nI][1] == aM2[nJ][1]
				AADD( aSP[nI], aM2[nJ] )
			EndIf
		Next nJ
	Next nI	
	aM2 := Aclone(aSP)
	

	ProcRegua(2)
	IncProc("")
	           
	nTotAtend := 0
	nProd1 := 0
	nProd2 := 0
	nTmpM1 := 0
	nTmpM2 := 0
	nTmpM3 := 0
	nTmpM4 := 0
	
	nInd1 := 0
	nInd2 := 0
	nAtd1 := 0
	nAtd2 := 0
	nAtdPg1 := 0
	nAtdPg2 := 0
	nSales1 := 0
	nSales2 := 0
		       
	// pontuais
	If Len(aM) > 0
		oExcel := FWMSEXCEL():New()
		cArqXls := "os_pt_acumulado_" +lower(StrTran(cNomAtend," ","_"))  +".xml"
		
		oExcel:AddworkSheet("Parametros")
		oExcel:AddTable ("Parametros","Parametros")
		oExcel:AddColumn("Parametros","Parametros","Parโmetro",1,1)
		oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)
		
		oExcel:AddRow( "Parametros","Parametros", { cTipo, cNomAtend } )
		oExcel:AddRow( "Parametros","Parametros", { "Matrํcula", alltrim(mv_par04) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data inicial", dtoc(MV_PAR01) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data final", dtoc(MV_PAR02) } )
		oExcel:AddRow( "Parametros","Parametros", { "Tipo de atendimento", "OS pontuais" } )
		oExcel:AddRow( "Parametros","Parametros", { "Caminho do relat๓rio", alltrim(MV_PAR05) } )                                                                                                             
				
		// indices      
		oExcel:AddworkSheet("Indicadores")
		oExcel:AddTable ("Indicadores","Indicadores")
		oExcel:AddColumn("Indicadores","Indicadores","Atendente",1,1)
		oExcel:AddColumn("Indicadores","Indicadores","Produtividade - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Produtividade - Resultado "+dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio at้ o atendimento - Consolidado at้ " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio at้ o atendimento - Resultado " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio de OS em atraso - Consolidado at้ " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio de OS em atraso - Resultado " +dtoc(MV_PAR02),3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo gasto",3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo de deslocamento",3,1)
		
		For nI := 1 To Len(aM)
			cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
			nTotAtend := 0
			nProd1 := 0
			nProd2 := 0
			nTmpM1 := 0
			nTmpM2 := 0
			nTmpM3 := 0
			nTmpM4 := 0
			For nJ := 2 To Len(aM[nI])                                                                                       
			   	/*
				oExcel:AddRow( "Indicadores","Indicadores", { cAtend,;
															aM[nI][3][4],;
															aM[nI][2][4],;
															IntToHora(aM[nI][3][5]),;
															IntToHora(aM[nI][2][5]),;
															IntToHora(aM[nI][3][6]),;
															IntToHora(aM[nI][2][6]),;
															IntToHora(aM[nI][3][7]),;
															IntToHora(aM[nI][2][7]) } )
			    */
			    
				// somatorio/media supervisor
				nTotAtend++
				nProd1 += aM[nI][nJ][3][4]
				nProd2 += aM[nI][nJ][2][4]
				nTmpM1 += aM[nI][nJ][3][5]
				nTmpM2 += aM[nI][nJ][2][5]
				nTmpM3 += aM[nI][nJ][3][6]
				nTmpM4 += aM[nI][nJ][2][6]
				
				// fechou supervisor?
				If nJ = Len(aM[nI])
					nTmpM1 := nTmpM1/nTotAtend
					nTmpM2 := nTmpM2/nTotAtend
					nTmpM3 := nTmpM3/nTotAtend
					nTmpM4 := nTmpM4/nTotAtend
					
					// totalizador gerente
					nGProd1 += nProd1
					nGProd2 += nProd2
					nGnTmp1 += nTmpM1
					nGnTmp2 += nTmpM2
					nGnTmp3 += nTmpM3
					nGnTmp4 += nTmpM4
				
					oExcel:AddRow( "Indicadores","Indicadores", { cAtend,;
																nProd1,;
																nProd2,;
																IntToHora(nTmpM1),;
																IntToHora(nTmpM2),;
																IntToHora(nTmpM3),;
																IntToHora(nTmpM4),;
																"",;
																"" } )
				EndIf
				nCont++
			Next nJ
			If nI = Len(aM)
				nGTotAtd := Len(aM)
				nGnTmp1 := nGnTmp1/nGTotAtd
				nGnTmp2 := nGnTmp2/nGTotAtd
				nGnTmp3 := nGnTmp3/nGTotAtd
				nGnTmp4 := nGnTmp4/nGTotAtd
				
				oExcel:AddRow( "Indicadores","Indicadores", { "RESULTADO GERENTE",;
															nGProd1,;
															nGProd2,;
															IntToHora(nGnTmp1),;
															IntToHora(nGnTmp2),;
															IntToHora(nGnTmp3),;
															IntToHora(nGnTmp4),;
															"",;
															"" })
				
			EndIf
		Next nI
		If nCont > 0
			oExcel:Activate()
			oExcel:GetXMLFile(cDir +cArqXls)
			If File(cDir +cArqXls)
				AADD( aPlan, cDir +cArqXls )
				nCntTot++             
			EndIf
		EndIf
	EndIf	
	
	nCont := 0    
	IncProc("")
			                      
	// programadas
	If Len(aM2) > 0            
		oExcel := FWMSEXCEL():New()
		cArqXls := "os_pr_acumulado_" +lower(StrTran(cNomAtend," ","_"))  +".xml"
		
		oExcel:AddworkSheet("Parametros")
		oExcel:AddTable ("Parametros","Parametros")
		oExcel:AddColumn("Parametros","Parametros","Parโmetro",1,1)
		oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)
		
		oExcel:AddRow( "Parametros","Parametros", { cTipo, cNomAtend } )
		oExcel:AddRow( "Parametros","Parametros", { "Matrํcula", alltrim(mv_par04) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data inicial", dtoc(MV_PAR01) } )
		oExcel:AddRow( "Parametros","Parametros", { "Data final", dtoc(MV_PAR02) } )
		oExcel:AddRow( "Parametros","Parametros", { "Tipo de atendimento", "OS programadas" } )
		oExcel:AddRow( "Parametros","Parametros", { "Caminho do relat๓rio", alltrim(MV_PAR05) } )
		
		// indices      
		oExcel:AddworkSheet("Indicadores")
		oExcel:AddTable ("Indicadores","Indicadores")
		oExcel:AddColumn("Indicadores","Indicadores","Supervisor",1,1)
		oExcel:AddColumn("Indicadores","Indicadores","Indice de ociosidade - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Indice de ociosidade - Resultado " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento das OS no prazo - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento das OS no prazo - Resultado " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento da programa็ใo das OS - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Atendimento da programa็ใo das OS - Resultado " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Total Sale - Consolidado at้ " +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Total Sale - Resultado" +dtoc(MV_PAR02),3,2)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo gasto",3,1)
		oExcel:AddColumn("Indicadores","Indicadores","Maior tempo de deslocamento",3,1)
		

		For nI := 1 To Len(aM2)
			cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM2[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
			nInd1 := 0
			nInd2 := 0
			nAtd1 := 0
			nAtd2 := 0
			nAtdPg1 := 0
			nAtdPg2 := 0
			nSales1 := 0
			nSales2 := 0
			For nJ := 2 To Len(aM2[nI])                                                                                       
				// detalhes atendentes
				/*
				oExcel:AddRow( "Indicadores","Indicadores", { cAtend,;
															aM2[nI][3][11],;
															aM2[nI][2][11],;
															aM2[nI][3][2],;
															aM2[nI][2][2],;
															aM2[nI][3][9],;
															aM2[nI][2][9],;
															aM2[nI][3][10],;
															aM2[nI][2][10],;
															IntToHora(aM2[nI][3][7]),;
															IntToHora(aM2[nI][2][7]) } )
	            */
	            
				// somatorio/media supervisor
				nTotAtend++
				nInd1 += aM2[nI][nJ][3][11]
				nInd2 += aM2[nI][nJ][2][11]
				nAtd1 += aM2[nI][nJ][3][2]
				nAtd2 += aM2[nI][nJ][2][2]
				nAtdPg1 += aM2[nI][nJ][3][9]
				nAtdPg2 += aM2[nI][nJ][2][9]
				nSales1 += aM2[nI][nJ][3][10]
				nSales2 += aM2[nI][nJ][2][10]
				
				// fechou supervisor?
				If nJ = Len(aM2[nI])
					nInd1 := nInd1/nTotAtend
					nInd2 := nInd2/nTotAtend
					nAtd1 := nAtd1/nTotAtend
					nAtd2 := nAtd2/nTotAtend
					nAtdPg1 := nAtdPg1/nTotAtend
					nAtdPg2 := nAtdPg2/nTotAtend
					 
					// totalizador gerente
					nGInd1 += nInd1
					nGInd2 += nInd2
					nGAtd1 += nAtd1
					nGAtd2 += nAtd2
					nGAtdPg1 += nAtdPg1
					nGAtdPg2 += nAtdPg2
				
					oExcel:AddRow( "Indicadores", "Indicadores", { cAtend,;
																	nInd1,;
																	nInd2,;
																	nAtd1,;
																	nAtd2,;
																	nAtdPg1,;
																	nAtdPg2,;
																	nSales1,;
																	nSales2,;
																	"",;
																	"" })
															
				EndIf                      
				 
				nCont++
			Next nJ
			
		  	// fechamento gerente
			If nI = Len(aM2)
				nTotAtend := Len(aM2)
				nGInd1 := nGInd1/nTotAtend
				nGInd2 := nGInd2/nTotAtend
				nGAtd1 := nGAtd1/nTotAtend
				nGAtd2 := nGAtd2/nTotAtend
				nGAtdPg1 := nGAtdPg1/nTotAtend
				nGAtdPg2 := nGAtdPg2/nTotAtend
				
				oExcel:AddRow( "Indicadores","Indicadores", { "RESULTADO GERENTE",;
															nGInd1,;
															nGInd2,;
															nGAtd1,;
															nGAtd2,;
															nGAtdPg1,;
															nGAtdPg2,;
															nSales1,;
															nSales2,;
															"",;
															"" })
			EndIf			
		Next nI
		If nCont > 0
			oExcel:Activate()
			oExcel:GetXMLFile(cDir +cArqXls)
			If File(cDir +cArqXls)
				AADD( aPlan, cDir +cArqXls )
				nCntTot++             
			EndIf
		EndIf  
	EndIf	
EndIf

If nCntTot > 0
	MsgInfo("Planilhas geradas: " +cvaltochar(nCntTot) +CRLF +"Caminho: "+cDir,"TTPROR08")
	If ApOleClient( 'MsExcel' )
		For nI := 1 To Len(aPlan)
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( aPlan[nI] )
			oExcelApp:SetVisible(.T.)         
			oExcelApp:Destroy()
		Next nI
	EndIf
EndIf  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  03/03/15   บฑฑ
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


Local aHelp1 := {"Data inicial das OS."}  
Local aHelp2 := {"Data final das OS."}  
Local aHelp3 := {"Tipo 1: Atendente 2: Supervisor"} 
Local aHelp4 := {"Matricula"} 
Local aHelp5 := {"Escolha o local para salvar o relat๓rio."}  

PutSx1(cPerg,'01','Data de ?','Data de ?' ,'Data de ?','mv_cha','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','',aHelp1,aHelp1,aHelp1)
PutSx1(cPerg,'02','Data ate ?','Data ate ?' ,'Data ate ?','mv_chb','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','',aHelp2,aHelp2,aHelp2)
PutSx1(cPerg,'03','Tipo ?','Tipo ?','Tipo ?' ,'mv_chc','N',1 ,0,1,'C','','','','','mv_par03',"Atendente","","","","Supervisor","","","Gerente","","",/*opc*/"","","",/*opc*/"","","",aHelp3,aHelp3,aHelp3)   	
PutSX1(cPerg,"04","Matricula ? ","Matricula ?","Matricula ?" ,"mv_chd","C",50,0,0,"G","NAOVAZIO(MV_PAR04)","AA1","","S","mv_par04","","","","","","","","","","","","","","","","",aHelp4,aHelp4,aHelp4)     
PutSX1(cPerg,"05","Salvar em:","Salvar em:","Salvar em:" ,"mv_che","C",50,0,0,"G","ExistDir(MV_PAR05)","RETDIR","","S","mv_par05","","","","","","","","","","","","","","","","",aHelp5,aHelp5,aHelp5)     

Return