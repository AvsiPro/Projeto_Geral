#include "topconn.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATR52  บAutor  ณJackson E. de Deus  บ Data ณ  13/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Extrato de Movimentacao de Rota                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATR52()

Local cPerg := "TTFATR52"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""

If cEmpAnt == "01"
	AjustaSX1(cPerg)
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Movimenta็ใo de Rota") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir a movimenta็ใo da Rota") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1  
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If !Empty(cDir)                                          
			//CursorWait()
			Processa( { |lEnd| Gerar(@lEnd) },"Gerando relatorio, aguarde..")
			//CursorArrow()
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

Local cRota := MV_PAR01
Local dDtIni := MV_PAR02
Local dDtFim := MV_PAR03
Local oExcel := Nil
Local cArqXls := "extrato_movimentacao.xml"
Local cSheet1 := "Parametros"
Local cSheet2 := "Movimento_consolidado" 
Local cSheet3 := "Movimento_analitico"
Local nCont := 0
Local aDados := {}
Local aProd := {}

                                      
If Empty(dDtIni) .Or. Empty(dDtFim)
	MsgAlert("Parametrize corretamente!")
	Return
EndIf

oExcel := FWMSEXCEL():New()
oExcel:SetBgColorHeader("#000000") 
oExcel:SetTitleBgColor("#FFFFFF")
oExcel:SetLineBgColor("#f0f0f5")
oExcel:Set2LineBgColor("#8585ad")

          
//Primeira aba - parametros
oExcel:AddworkSheet(cSheet1)
oExcel:AddTable (cSheet1,cSheet1)
oExcel:AddColumn(cSheet1,cSheet1,"Parametros",1,1)
oExcel:AddColumn(cSheet1,cSheet1,"Respostas",1,1)

oExcel:AddRow(cSheet1,cSheet1,{"Rota",cRota  } )  
oExcel:AddRow(cSheet1,cSheet1,{"Data inicial", dtoc(dDtIni) } )
oExcel:AddRow(cSheet1,cSheet1,{"Data final", dtoc(dDtFim) } )



// consolidado           
oExcel:AddworkSheet(cSheet2) 
oExcel:AddTable (cSheet2,cSheet2)
oExcel:AddColumn(cSheet2,cSheet2,"Produto",1,1) 
oExcel:AddColumn(cSheet2,cSheet2,"Descri็ใo",1,1) 
oExcel:AddColumn(cSheet2,cSheet2,"Total saํda",3,2)
oExcel:AddColumn(cSheet2,cSheet2,"Total abastecido",3,2)
oExcel:AddColumn(cSheet2,cSheet2,"Total saldo a retornar",3,2)
oExcel:AddColumn(cSheet2,cSheet2,"Total retornado",3,2)
oExcel:AddColumn(cSheet2,cSheet2,"Total diferen็a",3,2,.T.)
oExcel:AddColumn(cSheet2,cSheet2,"Total diferen็a em R$",3,2,.T.)


// analitico
oExcel:AddworkSheet(cSheet3)
oExcel:AddTable (cSheet3,cSheet3)
oExcel:AddColumn(cSheet3,cSheet3,"Nota fiscal",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"S้rie",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"Data de emissใo",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"Data de saํda",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"Data de retorno",1,1)
oExcel:AddColumn(cSheet3,cSheet3,"Nota fiscal Dev.",1,1)
oExcel:AddColumn(cSheet3,cSheet3,"S้rie",1,1)
oExcel:AddColumn(cSheet3,cSheet3,"Item da NF",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"Produto",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"Descri็ใo",1,1) 
oExcel:AddColumn(cSheet3,cSheet3,"Qtd saํda",3,2)
oExcel:AddColumn(cSheet3,cSheet3,"Pre็o",3,2)
oExcel:AddColumn(cSheet3,cSheet3,"Qtd abastecido",3,2)
oExcel:AddColumn(cSheet3,cSheet3,"Saldo a retornar",3,2)
oExcel:AddColumn(cSheet3,cSheet3,"Qtd retornada",3,2)
oExcel:AddColumn(cSheet3,cSheet3,"Qtd diferen็a",3,2)


// consulta 
cQuery := "SELECT Z7_DOC, Z7_SERIE, Z7_EMISSAO, Z7_SAIDA, Z7_ITEM, Z7_COD, Z7_DOCRET, Z7_SERIRET, "
cQuery += " B1_DESC, Z7_QUANT, Z7_QATU, Z7_ARMORI, D2_PRCVEN, Z7_RETORNO, (Z7_QUANT - Z7_QATU) ABAST "

cQuery += " FROM " +RetSqlName("SZ7") +" SZ7 "

cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
cQuery += " B1_COD = Z7_COD "
cQuery += " AND SB1.D_E_L_E_T_ = '' "
                                 
cQuery += " INNER JOIN " +RetSqlName("SF2") +" SF2 ON "
cQuery += " F2_FILIAL = Z7_FILIAL "
cQuery += " AND F2_DOC = Z7_DOC "
cQuery += " AND F2_SERIE = Z7_SERIE "
cQuery += " AND F2_CLIENTE = Z7_CLIENTE "
cQuery += " AND F2_LOJA = Z7_LOJA "
cQuery += " AND SF2.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN " +RetSqlName("SD2") +" SD2 ON "
cQuery += " D2_FILIAL = Z7_FILIAL "
cQuery += " AND D2_DOC = Z7_DOC "
cQuery += " AND D2_SERIE = Z7_SERIE "
cQuery += " AND D2_ITEM = Z7_ITEM "
cQuery += " AND D2_COD = Z7_COD "
cQuery += " AND SD2.D_E_L_E_T_ = '' "

cQuery += " WHERE "          
cQuery += " Z7_ARMMOV = '"+cRota+"' "
cQuery += " AND Z7_STATUS  = '3' "
cQuery += " AND Z7_RETORNO <> '' "
cQuery += " AND Z7_SAIDA >= '"+DTOS(dDtIni)+"' "
cQuery += " AND Z7_RETORNO <= '"+DTOS(dDtFim)+"' "
cQuery += " AND SZ7.D_E_L_E_T_ = '' "
cQuery += " ORDER BY Z7_DOC, Z7_SAIDA, Z7_COD "

 
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While TRB->(!EOF())
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR52","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)

TRB->(dbGoTop())
While TRB->(!EOF())
	
	nRetorno := 0
	nDifer := 0

	nRetorno := fRetNF(TRB->Z7_DOC, TRB->Z7_SERIE, TRB->Z7_ITEM, TRB->Z7_COD, STOD(TRB->Z7_EMISSAO),STOD(TRB->Z7_RETORNO)  )

	
	dbSelectArea("TRB")
	nDifer := TRB->Z7_QATU - nRetorno
	
	AADD( aDados, { TRB->Z7_DOC, TRB->Z7_SERIE, DTOC(STOD(TRB->Z7_EMISSAO)), DTOC(STOD(TRB->Z7_SAIDA)),;
					DTOC(STOD(TRB->Z7_RETORNO)), TRB->Z7_DOCRET, TRB->Z7_SERIRET, TRB->Z7_ITEM,;
					TRB->Z7_COD, TRB->B1_DESC, TRB->Z7_QUANT, TRB->D2_PRCVEN,;
					TRB->ABAST, TRB->Z7_QATU, nRetorno, nDifer } )
	
	dbSkip()
End


// consolida
For nI := 1 To Len(aDados)
	If AScan( aProd, { |x| x[1] == aDados[nI][9] } ) == 0
		AADD( aProd, { aDados[nI][9],;
						aDados[nI][10],;
						0,;	// saida
						0,;	// abastecido
						0,;	// saldo
						0,;	// retornado
						0,;	// diferenca
						0 } ) 	// diferenca em R$
						
	EndIf
Next nI

/*
aAbast := STATICCALL( TTPROC57, fQTAbast, cRota,dDtIni,dDtFim )
aItensP := {}
aItensR := {}

For nI := 1 To Len(aAbast)
	If SubStr(aAbast[nI][4],1,1) == "P"	// qtd entrou P
		AADD( aItensP, aAbast[nI] )
	ElseIf SubStr(aAbast[nI][4],1,1) == "R"	// qtd saiu R
		AADD( aItensR, aAbast[nI] )	
	EndIf
Next nI
*/

nSaida := 0
nSaldo := 0
nAbast := 0
nDev := 0
nDifer := 0
nDifR := 0

For nI := 1 To Len(aProd)
	nSaida := 0
	nSaldo := 0
	nAbast := 0
	nDev := 0
	nDifer := 0
	nDifR := 0
	/*
	nAbastP := 0
	If !Empty(aItensP)
		For nJ := 1 To Len(aItensP)
			If AllTrim(aItensP[nJ][1]) == AllTrim(aProd[nI][1])
				nAbastP += aItensP[nJ][3]
			EndIf
		Next nJ
	EndIf
	*/
	For nJ := 1 To Len(aDados)
		If aDados[nJ][9] == aProd[nI][1]
			nSaida += aDados[nJ][11] 
			nSaldo += aDados[nJ][14]
			nAbast += aDados[nJ][13]
			nDev += aDados[nJ][15]
			nDifer += aDados[nJ][16]
			nDifR += Round(nDifer*aDados[nJ][12],2)
		EndIf
	Next nJ
	
	aProd[nI][3] := nSaida
	aProd[nI][4] := nAbast	//IIF(nAbastP==0,nAbast,nAbastP)
	aProd[nI][5] := nSaldo
	aProd[nI][6] := nDev
	aProd[nI][7] := nDifer
	aProd[nI][8] := nDifR		
Next nI


// Sheet 2
For nI := 1 To Len(aProd)
	oExcel:AddRow(cSheet2,cSheet2, aProd[nI] )
Next nI


// Sheet 3
For nI := 1 To Len(aDados)
	oExcel:AddRow(cSheet3,cSheet3, aDados[nI] )	
Next nI



oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR52","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR52", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
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
ฑฑบPrograma  ณfRetNF บAutor  ณJackson E. de Deus     บ Data ณ  13/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a quantidade retornada do produto                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetNF(cNf, cSerie, cItem, cProduto, dEmissao, dRetorno)

Local cSql := ""
Local nRet := 0


cSql := "SELECT SUM(D1_QUANT) TOTAL FROM " +RetSqlName("SD1") +" SD1 "
cSql += " INNER JOIN " +RetSqlName("SF1") +" SF1 ON "
cSql += " F1_FILIAL = D1_FILIAL "
cSql += " AND F1_DOC = D1_DOC "
cSql += " AND F1_SERIE = D1_SERIE "
cSql += " AND F1_FORNECE = D1_FORNECE "
cSql += " AND F1_LOJA = D1_LOJA "
cSql += " AND SF1.D_E_L_E_T_ = '' "
cSql += " WHERE "
cSql += " D1_NFORI = '"+cNf+"' AND D1_SERIORI = '"+cSerie+"' "
cSql += " AND D1_ITEMORI = '"+cItem+"' AND D1_COD = '"+cProduto+"' "
cSql += " AND F1_DTDIGIT > '"+DTOS(dEmissao)+"' "

If !Empty(dRetorno)
	cSql += "AND F1_DTDIGIT <= '"+DTOS(dRetorno)+"' "	           
EndIf
      
cSql += " AND SD1.D_E_L_E_T_ = '' "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRBZ"

dbSelectArea("TRBZ")
If !EOF()
	nRet := TRBZ->TOTAL
EndIf

TRBZ->(dbCloseArea())
	
Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  13/11/15   บฑฑ
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

PutSx1(cPerg,"01","Rota ?","Rota ?","Rota ?","mv_cha","C",6,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Data De ?","Data De ?","Data De ?","mv_chb","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Data Ate ?","Data Ate ?","Data Ate ?","mv_chc","D",8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","")

      
Return