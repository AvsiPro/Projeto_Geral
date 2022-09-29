#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR90  บAutor  ณJackson E. de Deus  บ Data ณ  23/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Custos de insumos                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTESTR90()

Local cPerg := "TTESTR90"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

AjustaSX1(cPerg)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de configuracao do Relatorio			         	     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Custo de insumos") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir as doses/insumos faturados") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	If Empty(MV_PAR01) .Or. Empty(MV_PAR02)
		MsgAlert("Preencha os parโmetros!")
		Return
	EndIf
	  
	cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If !Empty(cDir)                                          
		CursorWait()
		Processa( { |lEnd| Gerar(@lEnd) },"Gerando relatorio, aguarde..")
		CursorArrow()
	Else
		Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
	EndIf
EndIf

Return

                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR90  บAutor  ณJackson E. de Deus  บ Data ณ  23/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gerar()

Local oExcel	:= Nil
Local cPlanilha := "custo.xml"
Local cQuery := ""   
Local nCusto := 0
Local nCustCalc := 0
Local cLocPad := ""
Local nPos := 0
Local aCusto := {} 
         

// consulta
cQuery := "SELECT F2_FILIAL,F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, F2_LOJA, A1_NOME, D2_COD, B1_DESC, D2_QUANT, D2_PRCVEN, D2_TOTAL,"
cQuery += "G1_COMP, G1_QUANT , (D2_QUANT * G1_QUANT) CONSUMO "
//cQuery += "B2_CM1 CUSTO, ( D2_QUANT*G1_QUANT*B2_CM1 ) CUSTCALC "

cQuery += "FROM " +RetSqlName("SF2") +" WITH (NOLOCK) "

cQuery += "INNER JOIN " +RetSqlName("SA1") +" ON "
cQuery += "A1_COD = F2_CLIENTE "
cQuery += "AND A1_LOJA = F2_LOJA "

cQuery += "INNER JOIN " +RetSqlName("SD2") +" SD2 ON "
cQuery += "D2_FILIAL = F2_FILIAL "
cQuery += "AND D2_DOC = F2_DOC "
cQuery += "AND D2_SERIE = F2_SERIE "
cQuery += "AND SD2.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SB1") +" ON "
cQuery += "B1_COD = D2_COD "

cQuery += "INNER JOIN " +RetSqlName("SG1") +" SG1 ON "
cQuery += "G1_COD = D2_COD "
cQuery += "AND SG1.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SB2") +" ON "
cQuery += "B2_FILIAL = D2_FILIAL "
cQuery += "AND B2_COD = G1_COMP "
cQuery += "AND B2_LOCAL = B1_LOCPAD "

cQuery += "WHERE F2_XFINAL = 'J' "
cQuery += "AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
//cQuery += "AND F2_FILIAL = '01' "
 
cQuery += "ORDER BY B1_DESC "

MPSysOpenQuery( cQuery , "TRB" )  

dbSelectArea("TRB")
If EOF()
	MsgInfo("Nใo hแ dados.")     
	TRB->(dbCloseArea())    
	Return
EndIf


oExcel	:= FWMSEXCEL():New()  

oExcel:AddworkSheet("Calculo")
oExcel:AddTable ("Calculo","Insumos")
oExcel:AddColumn("Calculo","Insumos","Nota",1,1)
oExcel:AddColumn("Calculo","Insumos","Serie",1,1)
oExcel:AddColumn("Calculo","Insumos","Emissao",1,4)
oExcel:AddColumn("Calculo","Insumos","Cliente",1,1)
oExcel:AddColumn("Calculo","Insumos","Loja",1,1)
oExcel:AddColumn("Calculo","Insumos","Razao Social",1,1)
oExcel:AddColumn("Calculo","Insumos","Dose",1,1)
oExcel:AddColumn("Calculo","Insumos","Dose descricao",1,1)
oExcel:AddColumn("Calculo","Insumos","Qtd dose",1,2)
oExcel:AddColumn("Calculo","Insumos","Pre็o",1,2)
oExcel:AddColumn("Calculo","Insumos","Total",1,2)
oExcel:AddColumn("Calculo","Insumos","Insumo",1,1)
oExcel:AddColumn("Calculo","Insumos","Insumo descricao",1,1)
oExcel:AddColumn("Calculo","Insumos","Qtd receita",1,2) 
oExcel:AddColumn("Calculo","Insumos","Qtd consumo",1,2)    
oExcel:AddColumn("Calculo","Insumos","Custo insumo",1,2)    
oExcel:AddColumn("Calculo","Insumos","Custo calculado",1,2) 


While !EOF()
	
	nCusto := 0
	cLocPad := Posicione("SB1",1,xFilial("SB1")+AvKey(TRB->G1_COMP,"B1_COD"),"B1_LOCPAD")
	
	If Empty(cLocPad)
		cLocPad := "D00001"
	EndIf
	
	nPOs := Ascan( aCusto, { |x| x[1] == TRB->F2_FILIAL .And. x[2] == TRB->G1_COMP } )
	If nPOs > 0
		nCusto := aCusto[nPos][3]
	Else
		cQuery := "SELECT TOP 1 B9_CM1 FROM " +RetSqlName("SB9")
		cQuery += " WHERE B9_FILIAL = '"+TRB->F2_FILIAL+"' AND B9_LOCAL = '"+cLocPad+"' AND B9_COD = '"+TRB->G1_COMP+"' AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC "
		
		MPSysOpenQuery( cQuery , "TRB2" )  
		dbSelectArea("TRB2") 
		nCusto := TRB2->B9_CM1
		AADD( aCusto, { TRB->F2_FILIAL,TRB->G1_COMP,TRB2->B9_CM1 }  )
		TRB2->(dbCloseArea())
	EndIf
	
	dbSelectArea("TRB")
	
	nCustCalc := ( TRB->D2_QUANT * TRB->G1_QUANT * nCusto )

	oExcel:AddRow("Calculo","Insumos",{TRB->F2_DOC,;
										TRB->F2_SERIE,;
										DTOC(STOD(TRB->F2_EMISSAO)),;
										TRB->F2_CLIENTE,;
										TRB->F2_LOJA,;
										TRB->A1_NOME,;
										TRB->D2_COD,;
										AllTrim(TRB->B1_DESC),;
										TRB->D2_QUANT,;
										TRB->D2_PRCVEN,;
										TRB->D2_TOTAL,;
										TRB->G1_COMP,;
										AllTrim(Posicione("SB1",1,xFilial("SB1")+AvKey(TRB->G1_COMP,"B1_COD"),"B1_DESC")),;
										TRB->G1_QUANT,;
										TRB->CONSUMO,;
										nCusto,;
										nCustCalc })	     
	
	TRB->(dbSkip())                 
End
TRB->(dbCloseArea())   
	 
		
oExcel:Activate()
oExcel:GetXMLFile(cDir+cPlanilha)

If File(cDir +cPlanilha)
	Aviso("TTESTR90","A planilha foi gerada em "+UPPER(cDir) +CRLF +"Nome: "+cPlanilha,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTESTR90", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cPlanilha )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  23/05/16   บฑฑ
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

PutSx1(cPerg,"01","Data De ?","Data De ?","Data De ?","mv_cha","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data Ate ?","Data Ate ?","Data Ate ?","mv_chb","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
      
Return