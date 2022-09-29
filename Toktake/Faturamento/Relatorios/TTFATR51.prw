#include "topconn.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATR51  บAutor  ณJackson E. de Deus  บ Data ณ  23/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Extrato de consumo de insumos                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATR51()

Local cPerg := "TTFATR51"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

If cEmpAnt == "01"
	AjustaSX1(cPerg)
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Extrato de consumo") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir um extrato de consumo") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1  
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If !Empty(cDir)                                          
			CursorWait()
			Processa( { |lEnd| Gerar(@lEnd) },"Gerando relatorio, aguarde..")
			CursorArrow()
		Else
			Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
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

Local dDtIni := MV_PAR01
Local dDtFim := MV_PAR02
Local cClients := MV_PAR03
Local cPACliente := MV_PAR04
Local cMaquina := MV_PAR05
Local aClientes := {}
Local cSql := ""    
Local cSql2 := ""  
Local nPos := 0
Local aPatDose := {}
Local aSheet2 := {}
Local aInsumos := {}
Local aReceita := {}
Local aAxIns := {}
Local nCont := 0
Local aCont := {} 
Local aAux := {}  
Local aDoses := {}
Local aAxMaq := {}   
Local aPSAnt := {}
Local oExcel := FWMSEXCEL():New()
Local cArqXls := "extrato_consumo.xml"
Local cSheet1 := "Insumos"
Local cSheet2 := "Leituras"
Local nI,nJ,nK
Local cDose := ""
Local cDesc := ""
Local nQtdAnt := 0
Local nQtdAtu := 0
Local nVenda := 0
Local nTotVenda := 0
Local nTotCusto := 0

                                       
If Empty(dDtIni) .Or. Empty(dDtFim)
	MsgAlert("Parametrize corretamente!")
	Return
EndIf 

If Empty(cClients) .And. Empty(cPACliente) .And. Empty(cMaquina)
	MsgAlert("Parametrize corretamente!")
EndIf

aClientes := StrToKarr( cClients, "," )

              
// DEFINICAO FORMATO
//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Data inicial", dtoc(dDtIni) } )
oExcel:AddRow("Parametros","Parametros",{"Data final", dtoc(dDtFim) } )
oExcel:AddRow("Parametros","Parametros",{"Cliente",cClients  } )  
oExcel:AddRow("Parametros","Parametros",{"PA", cPACliente } ) 
oExcel:AddRow("Parametros","Parametros",{"Patrimonio", cMaquina } ) 
// consolidado           
oExcel:AddworkSheet(cSheet1) 
oExcel:AddTable (cSheet1,cSheet1)
oExcel:AddColumn(cSheet1,cSheet1,"Cliente",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"Loja",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"Razใo Social",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"PA",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"Patrim๔nio",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"Modelo",1,1) 
oExcel:AddColumn(cSheet1,cSheet1,"Cod. Dose",1,1) 
oExcel:AddColumn(cSheet1,cSheet1,"Desc. Dose",1,1) 
oExcel:AddColumn(cSheet1,cSheet1,"Cod. Insumo",1,1) 
oExcel:AddColumn(cSheet1,cSheet1,"Desc. Insumo",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"Qtd Receita",3,2)
oExcel:AddColumn(cSheet1,cSheet1,"Qtd venda",3,2)
oExcel:AddColumn(cSheet1,cSheet1,"Total consumido",3,2)
oExcel:AddColumn(cSheet1,cSheet1,"Total venda R$",3,2)
oExcel:AddColumn(cSheet1,cSheet1,"Total custo R$",3,2)

// leituras
oExcel:AddworkSheet(cSheet2) 
oExcel:AddTable (cSheet2,cSheet2) 
oExcel:AddColumn(cSheet2,cSheet2,"Cliente",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"Loja",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"Razใo Social",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"PA",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"Patrim๔nio",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"Modelo",1,1)
//oExcel:AddColumn(cSheet2,cSheet2,"Cliente",1,1)
//oExcel:AddColumn(cSheet2,cSheet2,"Loja",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"Data",1,4)
//oExcel:AddColumn(cSheet2,"Relatorio","Hora",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"Numerador atual",1,1)
oExcel:AddColumn(cSheet2,cSheet2,"OS Mobile",1,1)

// mapa = 60 botoes
For nI := 1 To 60
	oExcel:AddColumn(cSheet2,cSheet2,"Botao " +cvaltochar(nI),1,1)
	oExcel:AddColumn(cSheet2,cSheet2,"Descri็ใo",1,1)
	oExcel:AddColumn(cSheet2,cSheet2,"Qtd Ant",3,2)
	oExcel:AddColumn(cSheet2,cSheet2,"Qtd Atual",3,2)
	oExcel:AddColumn(cSheet2,cSheet2,"Venda",3,2)
Next nI


    
// query
cSql := "SELECT ZN_CLIENTE, ZN_LOJA, A1_NOME, ZN_PATRIMO, N1_DESCRIC, ZN_DATA, ZN_HORA, ZN_NUMATU,ZN_NUMOS "

For nI := 1 To 60
	cPosP := PadL( nI, 2, "0" )
	cBotao := "BOTAO"+CVALTOCHAR(nI)
	
	// Mapa P
	cSql += ", N1_XP" +cvaltochar(nI)
	         
	// Qtd Atual
	cSql += ", ZN_BOTAO" +cPosP
Next nI 

cSql += " FROM " +RetSqlName("SZN") +" ZN "
cSql += " INNER JOIN " +RetSqlName("SN1") +" ON N1_CHAPA = ZN_PATRIMO "
cSql += " LEFT JOIN " +RetSqlName("SA1") +" ON A1_COD = ZN_CLIENTE AND A1_LOJA = ZN_LOJA "
//cSql += " LEFT JOIN " +RetSqlName("SZD") +" ZD ON ZD_PATRIMO = ZN_PATRIMO AND ZD_CLIENTE = ZN_CLIENTE AND ZD_LOJA = ZN_LOJA AND ZD_DATAINS <= ZN_DATA AND ZD.D_E_L_E_T_ = '' ORDER BY ZD_DATAINS DESC "
cSql += " WHERE "
cSql += " ZN_DATA BETWEEN '"+DTOS(dDtIni)+"' AND '"+DTOS(dDtFim)+"' "
 

If !Empty(aClientes)
	cSql += " AND ZN_CLIENTE IN ( "
	For nI := 1 To Len(aClientes) 
		cSql +=  "'" +ALLTRIM(aClientes[nI]) +"'"
		If nI <> Len(aClientes)
			cSql += ","
		EndIf
	Next nI
	cSql += " ) "
EndIf

If !Empty(cPACliente)
	cSql += " AND ZN_CODPA = '"+cPACliente+"' "
EndIf

If !Empty(cMaquina)
	cSql += " AND ZN_PATRIMO = '"+cMaquina+"' "
EndIf

cSql += " AND ZN_TIPINCL IN ('LEITURA CF','ABASTEC') "
cSql += " AND ZN.D_E_L_E_T_ = '' "


cSql += " ORDER BY ZN_CLIENTE, ZN_LOJA, ZN_PATRIMO, ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC"


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While TRB->(!EOF())
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR51","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)


// SHEET 2
TRB->(dbGoTop())
While !EOF()
	IncProc("")
	
	nRecAnt := 0       
	aPSAnt := Array(60)

	cCodPA := PAHist( TRB->ZN_PATRIMO, TRB->ZN_CLIENTE, TRB->ZN_LOJA, TRB->ZN_DATA )
		            
	aLinha := { TRB->ZN_CLIENTE,;
				TRB->ZN_LOJA,;
				TRB->A1_NOME,;
				cCodPA,;
				TRB->ZN_PATRIMO,;
				TRB->N1_DESCRIC,;
				dtoc(stod(TRB->ZN_DATA)),;
				TRB->ZN_NUMATU,;
				TRB->ZN_NUMOS }
				
	nPPT := Ascan( aPatDose, { |x| AllTrim(x[1]) == AllTrim( TRB->ZN_CLIENTE ) .And. AllTrim(x[2]) == AllTrim(TRB->ZN_LOJA) .And. AllTrim(x[3]) == AllTrim(cCodPA) .And.  AllTrim(x[4]) == AllTrim(TRB->ZN_PATRIMO) } ) 
	If nPPT == 0                  	
		AADD( aPatDose, { TRB->ZN_CLIENTE, TRB->ZN_LOJA, cCodPA, TRB->ZN_PATRIMO, {} } )
	EndIf
						
	// Qtd Ant	
	cSql2 := "SELECT TOP 1 R_E_C_N_O_ ZNRECANT FROM " +RetSqlName("SZN")
	cSql2 += " WHERE ZN_PATRIMO = '"+TRB->ZN_PATRIMO+"' AND ZN_DATA <= '"+TRB->ZN_DATA+"' "
	cSql2 += " AND ZN_NUMATU < '"+CVALTOCHAR(TRB->ZN_NUMATU)+"' AND ZN_VALIDA <> 'X' "
	cSql2 += " ORDER BY ZN_DATA DESC, ZN_HORA DESC,ZN_NUMATU DESC "
	If Select("TRBX") > 0
		TRBX->(dbCloseArea())
	EndIf
		
	TcQuery cSql2 New Alias "TRBX"
	dbSelectArea("TRBX")
	If !EOF()
		nRecAnt := TRBX->ZNRECANT
	EndIf
	
	dbSelectArea("SZN")
	dbGoTo(nRecAnt)
	For nI := 1 To 60
		cPosP := PadL( nI, 2, "0" )
		aPSAnt[nI] := &("SZN->ZN_BOTAO"+cPosP)
	Next nI

	// posicoes	
	For nI := 1 To 60
		cPosP := PadL( nI, 2, "0" )
		aAux := {}
		aAxMaq := {}
		cDesc := ""
		nQtdAnt := 0
		nQtdAtu := 0
		nVenda := 0
		
		dbSelectArea("TRB")
		cDose := &("TRB->N1_XP"+cvaltochar(nI))
		If !Empty(cDose)
			cDesc := Posicione("SB1",1,xFilial("SB1") +AvKey(cDose,"B1_COD"),"B1_DESC" )
		EndIf
		nQtdAnt := aPSAnt[nI]
		nQtdAtu := &("TRB->ZN_BOTAO"+cPosP)
		nVenda := nQtdAtu - nQtdAnt

		aAux := { cDose,;		// cod dose
					cDesc,;		// desc dose
					nQtdAnt,;	// qtd ant
					nQtdAtu,;	// qtd atual
					nVenda }	// qtd venda
     	
     	If !Empty(cDose)
			nPosDS := Ascan( aDoses, { |x| AllTrim(x[1]) == AllTrim(TRB->ZN_PATRIMO) .And. AllTrim(x[2]) == AllTrim(cDose) } )
			If nPosDS == 0
				AADD( aDoses, { AllTrim(TRB->ZN_PATRIMO), cDose, nVenda } )	// maquina, dose vendas
			Else
				aDoses[nPosDS][3] += nVenda
			EndIf
		EndIf
	
		For nJ := 1 To Len(aAux)
			AADD( aLinha, aAux[nJ] )
		Next nJ
	Next nI
	
	AADD( aSheet2, aLinha )

	dbSelectArea("TRB")	
	TRB->( dbSkip() )
End

For nI := 1 To Len(aDoses)
	cDose := aDoses[nI][2]
	axIns := {}
	
	If Ascan( aInsumos, { |x| AllTrim(x[1]) == AllTrim(cDose) } ) > 0
		Loop
	EndIf
	
	cSql2 := "SELECT G1_COD, G1_COMP, G1_QUANT, B1_DESC FROM " +RetSqlName("SG1") +" G1 "
	cSql2 += " INNER JOIN " +RetSqlName("SB1") +" ON B1_COD = G1_COMP "
	cSql2 += " WHERE G1_COD = '"+cDose+"' AND G1.D_E_L_E_T_ = '' "
			
	If Select("TRBX") > 0
		TRBX->(dbCloseArea())
	EndIf
	
	TcQuery cSql2 New Alias "TRBX"
	dbSelectArea("TRBX")
	While !EOF()
		AADD( axIns, { TRBX->G1_COMP, TRBX->B1_DESC, TRBX->G1_QUANT }  )
		
		dbSkip()
	End                        
	dbCloseArea() 
	AADD( aInsumos, { cDose, axIns } )	
Next nI


For nI := 1 To Len(aPatDose)
	cPatrimo := aPatDose[nI][4]

	dbSelectArea("SN1")
	dbSetOrder(2)
	If MsSeek( xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA") )
		For nJ := 1 To 60
			cDose := &("SN1->N1_XP"+cvaltochar(nJ))
			If !Empty(cDose)
				nPDose := Ascan( aDoses,{ |x| AllTrim(x[1]) == AllTrim(cPatrimo) .And. AllTrim(x[2]) == AllTrim(cDose) } )
				If nPDose > 0
					AADD( aPatDose[nI][5], aDoses[nPDose] )
				EndIf
			EndIf
		Next nJ
	EndIf
Next nI

          
// sheet 1
For nI := 1 To Len(aPatDose)
	cCodCli := aPatDose[nI][1]
	cLoja := aPatDose[nI][2]
	cNomeCli := Posicione( "SA1",1, xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLoja,"A1_LOJA"),"A1_NOME" )
	cCodPA := aPatDose[nI][3]
	cPatrimo := aPatDose[nI][4]
	cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"),"N1_DESCRIC" )
	cTabela := Posicione( "SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"),"N1_XTABELA" )
	aDoses := aClone( aPatDose[nI][5] )
	nPrcPE := 0	

	For nJ := 1 To Len(aDoses)
		cDose := aDoses[nJ][2]
		nVenda := aDoses[nJ][3]
		cDesc := Posicione( "SB1",1,xFilial("SB1") +AvKey(cDose,"B1_COD"), "B1_DESC" )
		aReceita := {}
			
		nPos := Ascan( aInsumos, { |x| AllTrim(x[1]) == AllTrim(cDose) } )
		If nPos == 0
			Loop
		EndIf   
		
		aReceita := Aclone( aInsumos[nPos][2] )     
		
		If !Empty(cTabela)
			aPRECO := STATICCALL( TTPROC56, fPRC,cTabela,cDose )
			If aPRECO[1] > 0
				nPrcPE := aPRECO[1]
			EndIf
		EndIf
				
		For nK := 1 To Len(aReceita)
			cInsum := aReceita[nK][1]
			cDescIns := aReceita[nK][2]
			nQtRec := aReceita[nK][3]
			nCustoB2 := 0
			nConv := 0
			nTotVenda := 0
			nTotCusto := 0
			nCustoB2 := Posicione( "SB2",2,xFilial("SB2") +AvKey("D00001","B2_LOCAL") +AvKey(cInsum,"B2_COD"),"B2_CM1" )
			
			nConv := nVenda * nQtRec //aDoses[nJ][nK][4]
			nTotVenda := nVenda * nPrcPE
			nTotCusto := nConv * nCustoB2
			
			oExcel:AddRow(cSheet1,cSheet1, { 	cCodCli,;
												cLoja,;
												cNomeCli,;
												cCodPA,;
												cPatrimo,;
												cModelo,;
												cDose,;
												cDesc,;
												cInsum,;
												cDescIns,;
												nQtRec,;
												nVenda,;
												nConv,;
												nTotVenda,;
												nTotCusto  } )
			
			
		Next nK 
	Next nJ
Next nI	
	
// sheet 2
For nI := 1 To Len(aSheet2)
	oExcel:AddRow(cSheet2,cSheet2, aSheet2[nI] )
Next nI


oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR51","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR51", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
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
ฑฑบPrograma  ณTTPROCR50 บAutor  ณMicrosiga           บ Data ณ  11/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PAHist( cPatrimo, cCliente,cLoja, dData )

Local cSql := ""
Local cCodPa := ""


cSql := "SELECT * FROM " +RetSqlName("SZD")
cSql += " WHERE ZD_PATRIMO = '"+cPatrimo+"' AND ZD_CLIENTE = '"+cCliente+"' AND ZD_LOJA = '"+cLoja+"' AND D_E_L_E_T_ = '' "
cSql += " ORDER BY ZD_DATAINS DESC "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRBZ"

dbSelectArea("TRBZ")
While !EOF()

	If TRBZ->ZD_DATAINS <= dData
		cCodPa := TRBZ->ZD_CODPA
		Exit
	EndIf

	dbSkip()
End


Return cCodPa


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

PutSx1(cPerg,"01","Data De ?","Data De ?","Data De ?","mv_cha","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data Ate ?","Data Ate ?","Data Ate ?","mv_chb","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Cliente ?","Cliente ?","Cliente ?","mv_chc","C",99,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","PA ?","PA ?","PA ?","mv_chd","C",8,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Maquina ?","Maquina ?","Maquina ?","mv_che","C",8,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","")

      
Return