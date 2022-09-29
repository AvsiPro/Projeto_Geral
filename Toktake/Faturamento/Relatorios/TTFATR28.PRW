#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATR28  บAutor  ณJackson E. de Deus  บ Data ณ  30/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Precos de Abastecimento x Faturamento         บฑฑ
ฑฑบ          ณ Confronta valor utilizado no abastecimento e posteriormenteบฑฑ
ฑฑบ			   no faturamento ao cliente								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATR28()

Local cPerg := "TTFATR28"
Local lEnd := .F.

If cEmpAnt == "01"
	AjustaSX1(cPerg)
	 
	 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Pergunte("TTFATR28",.T.)
	
	Processa( { |lEnd| Gerar(@lEnd)   },"Gerando relatorio, aguarde..")
endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerar     บAutor  ณJackson E. de Deus  บ Data ณ  30/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gerar(lEnd)

Local nCont := 0
Local cQuery := ""
Local oExcel := FWMSEXCEL():New()
Local cDir := alltrim(MV_PAR07)
Local cArqXls := "abastecidos_x_faturados.xml"

// data inicial
If Empty(MV_PAR01)
	MV_PAR01 := firstday(ddatabase)	// primeiro dia do mes - ref database
EndIf             
               
// data final
If Empty(MV_PAR02)
	MV_PAR02 := ddatabase	// data do dia - ref database 
EndIf
              
// filial inicial
If Empty(MV_PAR03)
	MV_PAR03 := ""
EndIf
                 
// filial final             
If Empty(MV_PAR04)
	MV_PAR04 := "99"
EndIf


cQuery := "SELECT "
cQuery += "D2_DOC, "
cQuery += "D2_SERIE, "
cQuery += "SUBSTRING( ZZ1_ITCONT,1,6 ) CLIENTE, "
cQuery += "SUBSTRING( ZZ1_ITCONT, 7,4 ) LOJA, " 
cQuery += "ZZ1_DESCRI, "
cQuery += "CASE WHEN SF2.F2_XFINAL='4' THEN 'ABASTECIMENTO' ELSE 'VENDA PA' END AS TIPO, "
cQuery += "D2_XCODPA XCODPA, D2_EMISSAO, D2_ITEM, D2_COD PRODUTO, B1_DESC DESC_PROD, D3_QUANT QTD, " 
cQuery += "D2_PRCVEN PRECO_VENDA, (D3_QUANT * D2_PRCVEN) TOTAL, "  
cQuery += "D3_LOCAL ARMAZEM, " 

cQuery += "( SELECT TOP 1 DA1_PRCVEN FROM " +RetSqlName("DA1")
cQuery += "	WHERE DA1_CODTAB = 'Y58' AND DA1_CODPRO = SD2.D2_COD AND D_E_L_E_T_ = '' ORDER BY R_E_C_N_O_ DESC  ) PRECO_TAB, "
cQuery += " B1_CUSTD CUSTO_ATUAL "

cQuery += "FROM " +RetSqlName("SD2") + " SD2 " 

cQuery += "INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
cQuery += "SB1.B1_COD = SD2.D2_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SF2") +" SF2 ON "
cQuery += "SF2.F2_FILIAL = SD2.D2_FILIAL "
cQuery += "AND SF2.F2_DOC = SD2.D2_DOC "
cQuery += "AND SF2.F2_SERIE = SD2.D2_SERIE "
cQuery += "AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQuery += "AND SF2.F2_LOJA = SD2.D2_LOJA "
cQuery += "AND SF2.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SD3") + " SD3 ON "
cQuery += "SD3.D3_FILIAL = SD2.D2_FILIAL "
cQuery += "AND SD3.D3_XNUMNF = SD2.D2_DOC "
cQuery += "AND SD3.D3_XSERINF = SD2.D2_SERIE "
cQuery += "AND SD3.D3_XITEMNF = SD2.D2_ITEM "
cQuery += "AND SD3.D3_TM = '100' "
cQuery += "AND SD3.D_E_L_E_T_ = '' "
cQuery += "AND SD3.D3_LOCAL <> SD2.D2_XCODPA "

cQuery += "INNER JOIN " +RetSqlName("ZZ1") +" ZZ1 ON "
cQuery += "ZZ1.ZZ1_FILIAL = SD2.D2_FILIAL "
cQuery += "AND ZZ1.ZZ1_COD = SD3.D3_LOCAL "
cQuery += "AND ZZ1.D_E_L_E_T_ = '' "

cQuery += "WHERE SF2.F2_XFINAL = '4' "
cQuery += "AND SD2.D_E_L_E_T_  = '' "
cQuery += "AND SD2.D2_EMISSAO >= '"+dtos(MV_PAR01)+"' AND SD2.D2_EMISSAO <= '"+dtos(MV_PAR02)+"' "
cQuery += "AND SD2.D2_FILIAL >= '"+MV_PAR03+"' AND SD2.D2_FILIAL <= '"+MV_PAR04+"' "

If !Empty(MV_PAR06)
	cQuery += "AND SUBSTRING(ZZ1.ZZ1_ITCONT,1,6) >= '"+MV_PAR05+"' AND SUBSTRING(ZZ1.ZZ1_ITCONT,1,6) <= '"+MV_PAR06+"' "
EndIf
cQuery += "UNION ALL "

cQuery += "SELECT " 
cQuery += "D2_DOC, " 
cQuery += "D2_SERIE, "
cQuery += "SUBSTRING( ZZ1_ITCONT,1,6 ) CLIENTE, "
cQuery += "SUBSTRING( ZZ1_ITCONT, 7,4 ) LOJA, " 
cQuery += "ZZ1_DESCRI, "
cQuery += "CASE WHEN SF2.F2_XFINAL='4' THEN 'ABASTECIMENTO' ELSE 'VENDA PA' END AS TIPO, "
cQuery += "D2_XCODPA XCODPA, D2_EMISSAO, D2_ITEM, D2_COD PRODUTO, B1_DESC DESC_PROD, D2_QUANT QTD, "
cQuery += "D2_PRCVEN PRECO_VENDA, D2_TOTAL TOTAL, " 
cQuery += "D2_LOCAL ARMAZEM, " 

cQuery += "( SELECT TOP 1 DA1_PRCVEN FROM " +RetSqlName("DA1")  
cQuery += "	WHERE DA1_CODTAB = 'Y58' AND DA1_CODPRO = SD2.D2_COD AND D_E_L_E_T_ = '' ORDER BY R_E_C_N_O_ DESC ) PRECO_TAB, "

cQuery += " B1_CUSTD CUSTO_ATUAL "
cQuery += "FROM " +RetSqlName("SD2") + " SD2 " 

cQuery += "INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
cQuery += "SB1.B1_COD = SD2.D2_COD "
cQuery += "AND SB1.D_E_L_E_T_ = '' "


cQuery += "INNER JOIN " +RetSqlName("SF2") +" SF2 ON "
cQuery += "SF2.F2_FILIAL = SD2.D2_FILIAL "
cQuery += "AND SF2.F2_DOC = SD2.D2_DOC "
cQuery += "AND SF2.F2_SERIE = SD2.D2_SERIE "
cQuery += "AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQuery += "AND SF2.F2_LOJA = SD2.D2_LOJA "
cQuery += "AND SF2.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("ZZ1") +" ZZ1 ON "
cQuery += "ZZ1.ZZ1_FILIAL = SD2.D2_FILIAL "
cQuery += "AND ZZ1.ZZ1_COD = SD2.D2_LOCAL "
cQuery += "AND ZZ1.D_E_L_E_T_ = '' "

cQuery += "WHERE SF2.F2_XFINAL = '2' "
cQuery += "AND SD2.D_E_L_E_T_  = '' "
cQuery += "AND SD2.D2_EMISSAO >= '"+dtos(MV_PAR01)+"' AND SD2.D2_EMISSAO <= '"+dtos(MV_PAR02)+"' "
cQuery += "AND SD2.D2_FILIAL >= '"+MV_PAR03+"' AND SD2.D2_FILIAL <= '"+MV_PAR04+"' "

If !Empty(MV_PAR06)
	cQuery += "AND SUBSTRING(ZZ1.ZZ1_ITCONT,1,6) >= '"+MV_PAR05+"' AND SUBSTRING(ZZ1.ZZ1_ITCONT,1,6) <= '"+MV_PAR06+"' "
EndIf


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	nCont++
	dbSkip()
End


ProcRegua(nCont)


//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Data de: ", dtoc(mv_par01) } )
oExcel:AddRow("Parametros","Parametros",{"Data ate: ", dtoc(mv_par02) } )
oExcel:AddRow("Parametros","Parametros",{"Filial de: ", mv_par03 } )
oExcel:AddRow("Parametros","Parametros",{"Filial ate: ", mv_par04 } )
oExcel:AddRow("Parametros","Parametros",{"Cliente de: ", mv_par05 } )
oExcel:AddRow("Parametros","Parametros",{"Cliente ate: ", mv_par06 } )
oExcel:AddRow("Parametros","Parametros",{"Destino: " , mv_par07 } )



oExcel:AddworkSheet("Notas") 
oExcel:AddTable ("Notas","Relatorio")
oExcel:AddColumn("Notas","Relatorio","Nota",1,1)
oExcel:AddColumn("Notas","Relatorio","Serie",1,1)
oExcel:AddColumn("Notas","Relatorio","Cliente",1,1)
oExcel:AddColumn("Notas","Relatorio","Loja",1,1)
oExcel:AddColumn("Notas","Relatorio","Nome",1,1)
oExcel:AddColumn("Notas","Relatorio","Tipo",1,1)
oExcel:AddColumn("Notas","Relatorio","PA",1,1)
oExcel:AddColumn("Notas","Relatorio","Emissao",1,4)                                                                 
oExcel:AddColumn("Notas","Relatorio","Item NF",1,1)                                                              
oExcel:AddColumn("Notas","Relatorio","Cod Produto",1,1)
oExcel:AddColumn("Notas","Relatorio","Desc Produto",1,1) 
oExcel:AddColumn("Notas","Relatorio","Quantidade",1,2) 
oExcel:AddColumn("Notas","Relatorio","Preco de venda",1,2)
oExcel:AddColumn("Notas","Relatorio","Total",1,2) 
oExcel:AddColumn("Notas","Relatorio","Armazem",1,1)  
oExcel:AddColumn("Notas","Relatorio","Preco de tabela",1,2)
oExcel:AddColumn("Notas","Relatorio","Total Preco de Tabela",1,2)   
oExcel:AddColumn("Notas","Relatorio","Preco de Custo atual",1,2)  
 


dbGoTop()
While !EOF()
	IncProc("NF: "+TRB->D2_DOC +" - " +	dtoc(stod(TRB->D2_EMISSAO)) )
	oExcel:AddRow("Notas","Relatorio",{TRB->D2_DOC,; 
										TRB->D2_SERIE,;
										TRB->CLIENTE,;
										TRB->LOJA,;
										TRB->ZZ1_DESCRI,;
										TRB->TIPO,;
										TRB->XCODPA,;
										dtoc(stod(TRB->D2_EMISSAO)),;
										TRB->D2_ITEM,;
										TRB->PRODUTO,;
										TRB->DESC_PROD,;
										TRB->QTD,;
										TRB->PRECO_VENDA,; 
										TRB->TOTAL,;
										TRB->ARMAZEM,;
										TRB->PRECO_TAB,;
										TRB->QTD*TRB->PRECO_TAB,;
										TRB->CUSTO_ATUAL })

	dbSkip()
End
dbCloseArea()       
   

If Empty(cDir)
	While Empty(cDir)
		cDir := cGetFile(, OemToAnsi("Selecione o local para gravacao"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	End
EndIf

oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR28","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR28", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
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

PutSx1(cPerg,"01","Data De ?","Data De ?","Data De ?","mv_cha","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data Ate ?","Data Ate ?","Data Ate ?","mv_chb","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Filial De ?","Filial De ?","Filial De ?","mv_chc","C",2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Filial Ate ?","Filial Ate ?","Filial Ate ?","mv_chd","C",2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Cliente De ?","Cliente De ?","Cliente De ?","mv_che","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"06","Cliente Ate ?","Cliente Ate ?","Cliente Ate ?","mv_chf","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"07","Destino ?","Destino ?","Destino ?","mv_chg","C",30,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","")
      
Return