#include "protheus.ch"
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR16  บAutor  ณMicrosiga           บ Data ณ  04/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTESTR16()

Local cPerg := "TTESTR16"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

If cEmpAnt <> "01"
	Return
EndIf

AjustaSX1(cPerg)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de configuracao do Relatorio			         	     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Movimentacao estoque") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir a movimentacao do armazem") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1  
	cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If !Empty(cDir)                                          
		CursorWait()
		Processa( { |lEnd| ProcRel(@lEnd) },"Gerando relatorio, aguarde..")
		CursorArrow()
	Else
		Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
	EndIf
EndIf


Return
                                   


// processa a geracao do relatorio
Static Function ProcRel(lEnd)

Local cQuery := ""          
Local oExcel := FWMSEXCEL():New()
Local cArqXML := "movimento_sz5.xml"
Local cSheet2 := "Movimentos"
Local cAlias := "TRBZ5"   
Local cModelo := ""
Local cOpera := ""              
Local cTipoMov := "" 
Local nCount := 0
        

// DEFINICAO FORMATO
//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Armazem: ", mv_par01 } )
oExcel:AddRow("Parametros","Parametros",{"Data de: ", dtoc(mv_par02) } )
oExcel:AddRow("Parametros","Parametros",{"Data ate: ", dtoc(mv_par03) } )
                                                                         
         

oExcel:AddworkSheet(cSheet2) 
oExcel:AddTable (cSheet2,"Relatorio")
oExcel:AddColumn(cSheet2,"Relatorio","Armazem",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Documento",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Emissใo",1,4)
oExcel:AddColumn(cSheet2,"Relatorio","Hora",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Produto",1,1)  
oExcel:AddColumn(cSheet2,"Relatorio","Descri็ใo",1,1)  
oExcel:AddColumn(cSheet2,"Relatorio","Tipo Mov",1,4)  
oExcel:AddColumn(cSheet2,"Relatorio","Quantidade",3,2) 
oExcel:AddColumn(cSheet2,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Mola",1,1)  
oExcel:AddColumn(cSheet2,"Relatorio","Observa็ใo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Opera็ใo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","OS Mobile",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","NF origem",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","NF item",1,1)


// CONSULTA  SZ5 X SZG
cQuery := "SELECT Z5_LOCAL, Z5_COD, Z5_TM, Z5_QUANT, Z5_EMISSAO, Z5_DOC, Z5_NUMOS, Z5_MOLA, Z5_CHAPA, Z5_OBS,Z5_TIPO, Z5_HORA, B1_DESC, Z5_NF, Z5_NFITEM "
cQuery += " FROM " +RetSqlName("SZ5") + " SZ5 "      

cQuery += " LEFT JOIN " +RetSqlName("SB1") +" SB1 ON "
cQuery += " B1_COD = Z5_COD AND SB1.D_E_L_E_T_ = '' "

cQuery += " LEFT JOIN " +RetSqlName("SZG") + " SZG ON "
cQuery += " ZG_NUMOS = Z5_NUMOS AND SZG.D_E_L_E_T_ = '' "

cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"' AND Z5_LOCAL = '"+MV_PAR01+"' "
cQuery += " AND  Z5_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
cQuery += " AND SZ5.D_E_L_E_T_ = '' "
cQuery += " ORDER BY Z5_EMISSAO, Z5_HORA "


MpSysOpenQuery( cQuery, "TRBZ5"  )

dbSelectArea( "TRBZ5" )
While !EOF()
	nCount++
	dbSkip()
End
            
    
ProcRegua(nCount)

dbGoTop()
While !EOF()
    
    cOpera := ""              
    cTipoMov := ""                 
    cModelo := ""
                  
    
    If TRBZ5->Z5_TM == "100" .OR. TRBZ5->Z5_TM == "015"
    	cTipoMov := "Entrada"
    ElseIf TRBZ5->Z5_TM == "600" .OR. TRBZ5->Z5_TM == "515"
    	cTipoMov := "Saida"
    EndIf
    
                       
	// ABASTECIMENTO
	If TRBZ5->Z5_TIPO  == "A"
		cOpera := "ABASTECIMENTO"                
	// RETIRADO
	ElseIf TRBZ5->Z5_TIPO == "R"
		cOpera := "RETIRADO"                 
	// DESCARTE
	ElseIf TRBZ5->Z5_TIPO == "D"
		cOpera := "DESCARTE"
	EndIf
	                                                      
	If !Empty(TRBZ5->Z5_CHAPA)
		cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(TRBZ5->Z5_CHAPA,"N1_CHAPA"),"N1_DESCRIC" )
	EndIf     
	                                                                       
	
	oExcel:AddRow( cSheet2,"Relatorio", { TRBZ5->Z5_LOCAL,;
											TRBZ5->Z5_DOC,;
											STOD( TRBZ5->Z5_EMISSAO ),;
											TRBZ5->Z5_HORA,;
											TRBZ5->Z5_COD,;
											TRBZ5->B1_DESC,;
											cTipoMov ,;
											TRBZ5->Z5_QUANT,;
											TRBZ5->Z5_CHAPA,;
											cModelo,;
											TRBZ5->Z5_MOLA,;
											TRBZ5->Z5_OBS,;
											cOpera,;
											TRBZ5->Z5_NUMOS,;
											TRBZ5->Z5_NF,;
											TRBZ5->Z5_NFITEM  } )
	

	IncProc("")
	
	dbSkip()  

End



oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXML)

If File(cDir +cArqXML)
	Aviso("TTESTR16","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTESTR16", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXML )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  


Return


// perguntas
Static Function AjustaSX1(cPerg)

PutSx1(cPerg,"01","Armazem ?","Armazem ?","Armazem ?","mv_cha","C",9,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data De ?","Data De ?","Data De ?","mv_chb","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Data Ate ?","Data Ate ?","Data Ate ?","mv_chc","D",8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","")

      
Return