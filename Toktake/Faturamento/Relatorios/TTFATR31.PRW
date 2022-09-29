#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATR31  บAutor  ณJackson E. de Deus  บ Data ณ  10/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de extrato de entregas					          บฑฑ
ฑฑ			  Controle de Entregas								          บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ10/04/15ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFATR31()

Local cPerg := "TTFATR31"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

If cEmpAnt == "01"
	AjustaSX1(cPerg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Extrato de entregas") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir o extrato de entregas") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1  
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If !Empty(cDir)
			Processa( { |lEnd| Gerar(@lEnd)   },"Gerando relatorio, aguarde..")
		Else
			Aviso( cPerg,"Escolha um diret๓rio vแlido.",{"Ok"} )
		EndIf
	EndIf
endif
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerar		บAutor  ณJackson E. de Deus  บ Data ณ  10/04/15   บฑฑ
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
Local cArqXls := "extrato_entregas.xml"
Local cRomaneio := ""
Local dDtRom := stod("")
Local cMotor := ""
     
If Empty(MV_PAR01)
	MsgAlert("TTFATR31","Preencha o c๓digo do motorista!")
	Return
EndIf     
              
If Empty(MV_PAR02)
	MV_PAR02 := ddatabase
EndIf

cMotor := MV_PAR01
dDtRom := MV_PAR02
cRomaneio := MV_PAR03            
               
cSql := "SELECT DISTINCT F2_XCARGA,F2_DOC, F2_SERIE, F2_XDTENTR, F2_CLIENTE, F2_LOJA, A1_NOME, F2_XCODPA, F2_EMISSAO, "
cSql += " (SELECT ZZ1_DESCRI FROM " +RetSqlName("ZZ1") +" ZZ1 WHERE ZZ1_COD = F2_XCODPA AND ZZ1_FILIAL = F2_FILIAL AND ZZ1.D_E_L_E_T_ = ''  ) DESCPA, "
cSql += " F2_XFINAL, F2_XNFABAS, F2_XRECENT, F2_XENTNOM, F2_XENTRG, F2_XENTKM, "

cSql += " 'ABASTECIMENTO' = CASE WHEN F2_XNFABAS = '1' AND F2_XCODPA <> '' AND F2_XFINAL = '4' "
cSql += "		THEN 'SIM' "
cSql += "		ELSE 'NAO' "
cSql += " END, "

cSql += " 'DIFERENCA' = (D2_QUANT - D3_QUANT), "
	  
cSql += "D2_ITEM, D2_COD, B1_DESC, D2_UM, D2_SEGUM, D2_QUANT, D3_QUANT, D3_EMISSAO, D3_TM, F5_TEXTO, D2_LOCAL, D3_LOCAL, D3_XORIGEM "
cSql += "FROM " +RetSqlName("SF2") +" F2 "

// join sa1
cSql += "INNER JOIN " +RetSqlName("SA1") +" A1 ON "
cSql += "A1_COD = F2_CLIENTE "
cSql += "AND A1_LOJA = F2_LOJA "
cSql += "AND A1.D_E_L_E_T_ = F2.D_E_L_E_T_ "

// join sd2
cSql += "INNER JOIN " +RetSqlName("SD2") +" D2 ON "
cSql += "F2_FILIAL = D2_FILIAL "
cSql += "AND F2_DOC = D2_DOC "
cSql += "AND F2_SERIE = D2_SERIE "
cSql += "AND F2_CLIENTE = D2_CLIENTE "
cSql += "AND F2_LOJA = D2_LOJA "
cSql += "AND F2.D_E_L_E_T_ = D2.D_E_L_E_T_ "

// join sb1
cSql += "INNER JOIN " +RetSqlName("SB1") +" B1 ON "
cSql += "B1_COD = D2_COD "
cSql += "AND B1.D_E_L_E_T_ = '' "

// join sd3
cSql += "LEFT JOIN " +RetSqlName("SD3") +" D3 ON "
cSql += "D3_FILIAL = D2_FILIAL "
cSql += "AND D3_XNUMNF = D2_DOC AND D3_XSERINF = D2_SERIE "
cSql += "AND D3_COD = D2_COD "
cSql += "AND D3_XITEMNF = D2_ITEM "
cSql += "AND D3.D_E_L_E_T_ = '' "

// join 
cSql += "LEFT JOIN " +RetSqlName("SF5") +" F5 ON " 
cSql += "F5_CODIGO = D3_TM AND F5.D_E_L_E_T_ = D3.D_E_L_E_T_ "

cSql += "WHERE SUBSTRING( F2_XMOTOR,1,6 ) = '"+cMotor+"' "
cSql += "AND F2_XDTROM = '"+Dtos(dDtRom)+"' "

If !Empty(cRomaneio)
	cSql += " AND F2_XCARGA = '"+cRomaneio+"' "
EndIf
//cSql += "AND F2_XCODPA <> '' AND F2_XFINAL = '4' AND F2_XNFABAS = '1' "
cSql += "AND F2.D_E_L_E_T_ = '' "

cSql += "ORDER BY F2_XCARGA,F2_DOC, D2_ITEM "

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
	Aviso("TTFATR31","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(3)


IncProc("")
//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Motorista: ", mv_par01 } )
oExcel:AddRow("Parametros","Parametros",{"Data: ", dtoc(mv_par02) } )
oExcel:AddRow("Parametros","Parametros",{"Romaneio: " , mv_par03 } )

// segunda aba - romaneios/notas
oExcel:AddworkSheet("Notas") 
oExcel:AddTable ("Notas","Notas")
oExcel:AddColumn("Notas","Notas","Romaneio",1,1)
oExcel:AddColumn("Notas","Notas","Nota",1,1)
oExcel:AddColumn("Notas","Notas","Serie",1,1)
oExcel:AddColumn("Notas","Notas","Cliente",1,1)
oExcel:AddColumn("Notas","Notas","Loja",1,1)
oExcel:AddColumn("Notas","Notas","Nome",1,1)
oExcel:AddColumn("Notas","Notas","Emissao",1,4) 
oExcel:AddColumn("Notas","Notas","PA",1,1)
oExcel:AddColumn("Notas","Notas","Descricao PA",1,1)
oExcel:AddColumn("Notas","Notas","Abastecimento PA",1,1)
oExcel:AddColumn("Notas","Notas","Canhoto baixado",1,1)
oExcel:AddColumn("Notas","Notas","Recebedor",1,1)
oExcel:AddColumn("Notas","Notas","RG",1,1)
oExcel:AddColumn("Notas","Notas","KM",1,1)


IncProc("") 
dbGoTop()
cNumNF := TRB->F2_DOC
While !EOF()
	If cNumNF <> TRB->F2_DOC
		oExcel:AddRow("Notas","Notas",{TRB->F2_XCARGA,;
										TRB->F2_DOC,; 
										TRB->F2_SERIE,;
										TRB->F2_CLIENTE,;
										TRB->F2_LOJA,;
										TRB->A1_NOME,;
										STOD(TRB->F2_EMISSAO),;
										TRB->F2_XCODPA,;
										TRB->DESCPA,;
										TRB->ABASTECIMENTO,;
										IIF( TRB->F2_XRECENT=="S","SIM","NAO" ),;
										TRB->F2_XENTNOM,;
										TRB->F2_XENTRG,;
										TRB->F2_XENTKM })
	EndIf
	cNumNF := TRB->F2_DOC									
	TRB->(dbSkip())
End

IncProc("")
// terceira aba - movimento produtos
oExcel:AddworkSheet("Movimento") 
oExcel:AddTable ("Movimento","Movimento")
oExcel:AddColumn("Movimento","Movimento","Nota",1,1)
oExcel:AddColumn("Movimento","Movimento","Serie",1,1)
oExcel:AddColumn("Movimento","Movimento","Item",1,1)
oExcel:AddColumn("Movimento","Movimento","Cod. Produto",1,1)
oExcel:AddColumn("Movimento","Movimento","Desc. Produto",1,1)
oExcel:AddColumn("Movimento","Movimento","Qtd saida",3,2,.T.)
oExcel:AddColumn("Movimento","Movimento","Armazem saida",1,1)
oExcel:AddColumn("Movimento","Movimento","Qtd entrada",3,2,.T.)
oExcel:AddColumn("Movimento","Movimento","Armazem entrada",1,1)
oExcel:AddColumn("Movimento","Movimento","Diferenca",3,2,.T.)

 
dbGoTop()
While !EOF()
	oExcel:AddRow("Movimento","Movimento",{TRB->F2_DOC,; 
										TRB->F2_SERIE,;
										TRB->D2_ITEM,;
										TRB->D2_COD,;
										TRB->B1_DESC,;
										TRB->D2_QUANT,;
										TRB->D2_LOCAL,;
										TRB->D3_QUANT,;
										TRB->D3_LOCAL,;
										TRB->DIFERENCA })

	TRB->(dbSkip())
End
TRB->( dbCloseArea() )
   
oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR31","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR31", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
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
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  10/04/15   บฑฑ
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

PutSx1(cPerg,"01","Motorista ?","Motorista?","Motorista ?","mv_cha","C",8,0,0,"G","","DA4","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data ?","Data ?","Data ?","mv_chb","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Romaneio ?","Romaneio ?","Romaneio ?","mv_chc","C",15,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","")
      
Return