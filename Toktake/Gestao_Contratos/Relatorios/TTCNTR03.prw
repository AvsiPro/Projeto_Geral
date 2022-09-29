#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTR03  บAutor  ณMicrosiga           บ Data ณ  03/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCNTR03()
local cMens := ""
Local nOpca := 0

Private cTitRel := OemToAnsi("Medicoes")
Private lEnd	:= .F.
Private cDir	:= ""

If cEmpAnt == "01"
	
	AjustaSX1()
	
	Pergunte("TTCNR040",.T.)
	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Processamento do Relatorio							         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If AllTrim(cDir) <> ""
			Processa({|lEnd| CNR040Imp(@lEnd)   },"Gerando planilhas, aguarde..")
		Else
			Aviso("TTCNTR01","Escolha um diret๓rio vแlido.",{"Ok"})
		EndIf
EndIF

Return Nil
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |CNR040Imp บAutor  ณFabio Alves Silva   บ Data ณ  28/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do Relatorio de Medicao                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNTR040                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CNR040Imp(lEnd)

Local cQuery       := ""
Local cAliasCNE    := ""
Local cMedicao     := ""
Local cContra      := ""
Local cRevisa      := ""
Local cDescri      := ""  
Local cUM          := ""
Local aStrucCND    := CND->(dbStruct())
Local aStrucCNE    := CNE->(dbStruct())
Local aStrucCNB    := CNB->(dbStruct())
Local aTot         := Array(13)
Local aTotINMO     := {}
Local aTotINME     := {}

Local cDirSpool    := GetMv("MV_RELT")

Local nTotAcm      := 0
Local nTot         := 0
Local nBruto       := 0
Local nMultAcm     := 0
Local nTotMult     := 0
Local nBonifAcm	 := 0
Local nTotBonif	 := 0
Local nDescAcm     := 0
Local nRetAcm      := 0
Local nBrAcumulado := 0
Local nBrMedicao   := 0
Local nBrTotal     := 0
Local nLinBck      := 0
Local nX           := 0
Local nDescMe	   := 0
Local nRetCac	   := 0
Local cPer1
Local cPer2
Local aAux2			:= {}
Local nVlrPatri		:= 0
Local cTxtDescri	:= ""
Local nQtdDias		:= 0
Local nQtdComp		:= 0
Local nVlDia		:= 0
Local nTotPRata		:= 0
Local cCompet		:= ""
Local cAuxMes		:= ""
Local cCodCli		:= ""
Local cLoja			:= ""
Local cNomeCli		:= ""
Local lInsumo		:= .t.
Local cProduto		:= ""
Local cDescProd		:= ""
Local cLojaSN1		:= ""
Local cLocFis
Local dDtInst
Local dDtRem


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Recupera Picture dos Campos								     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPtVLMEAC := PesqPict("CND","CND_VLMEAC")
Local cPtVLSALD := PesqPict("CND","CND_VLSALD")
Local cPtVLTOT1 := PesqPict("CND","CND_VLTOT" )
Local cPtQTDSOL := PesqPict("CNE","CNE_QTDSOL")
Local cPtQTAMED := PesqPict("CNE","CNE_QTAMED")
Local cPtQUANT  := PesqPict("CNE","CNE_QUANT" )
Local cPtPERC   := PesqPict("CNE","CNE_PERC"  )
Local cPtVLUNIT := PesqPict("CNE","CNE_VLUNIT")
Local cPtVLTOT  := PesqPict("CNE","CNE_VLTOT" )   
Local cPtQTMED  := PesqPict("CNB","CNB_QTDMED")
Local cPtCNBTOT := PesqPict("CNB","CNB_VLTOT" )
Local cPtDESC   := PesqPict("CND","CND_DESCME")
Local cPtMULT   := PesqPict("CNR","CNR_VALOR" )
Local cPtRETC   := PesqPict("CND","CND_RETCAC")
Local cPtVLCTR  := PesqPict("CN9","CN9_VLATU" )
Local cPtINSMO  := PesqPict("CN9","CN9_INSSMO")
Local cPtINSME  := PesqPict("CN9","CN9_INSSME")

Local cProduto1 := ""
Local cProduto2 := ""
Local cDescri1  := ""
Local cDescri2  := ""
Local nCNETamPrd:= TamSX3("CNE_PRODUT")[1]
Local nCNETamDsc:= TamSX3("CNB_DESCRI")[1]

Local nTipo     := 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CNR040RES - Ponto de entrada para desenvolvimento do resumo de medicao ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lResumo   := ExistBlock("CNR040RES")

Local lFiltForn := !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("CND_FORNEC")[1]))
Local lFixo     := .T.

Local dDataRef  := If(Empty(mv_par19),dDataBase,mv_par19)
Local nPageCabec	:= 0	//guarda a pagina para o preenchimento do valor total do faturamento no cabecalho
Local nPageAtu		:= 0
Local nTotReg	:= 0
Local cVencto	:= ""
Local cPlanilha := ""
Local cUFLoja	:= ""
Local nPosPat	:= 0
Local nTotalLoc	:=	0

Private aLocacoes := {}
Private aInsumos := {}
Private oExcel
Private cAliasCND    := GetNextAlias()
Private nTotfat		:= 0	// total faturamento (medicoes + insumos)
Private nTotMed := 0		// total medicao - valor unitario planilha
Private nTotInsumo := 0		// total insumo
Private cCliDifer := SuperGEtMV("MV_XGCT002",.T.,"")	//clientes diferenciados onde a busca dos insumos sera pelas lojas do estado da loja do contrato
Private cTpFat	:= ""
Private aLojas := {}	//lojas usadas na query para buscar somente os insumos dessas lojas quando faturamento for por cliente
Private cLojas := ""	//lojas usadas na query para buscar somente os insumos dessas lojas quando faturamento for por cliente
Private aAuxLj := {}
private lIniInsumo := .F.


aStrucCND := CND->(dbStruct())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta query para selecao das medicoes      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT * FROM " + RetSQLName("CND")+ " CND," + RetSQLName("CN9") + " CN9 "
cQuery += "WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
cQuery += "  AND CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"
cQuery += "  AND CND.CND_CONTRA = CN9.CN9_NUMERO "
cQuery += "  AND CND.CND_REVISA = CN9.CN9_REVISA "
cQuery += "  AND CND.CND_NUMMED >= '"+mv_par01+"'"
cQuery += "  AND CND.CND_NUMMED <= '"+mv_par02+"'"
cQuery += "  AND CND.CND_CONTRA >= '"+mv_par03+"'"
cQuery += "  AND CND.CND_CONTRA <= '"+mv_par04+"'" 
cQuery += "  AND CND.CND_REVISA >= '"+mv_par17+"'"
cQuery += "  AND CND.CND_REVISA <= '"+mv_par18+"'"
cQuery += "  AND CN9.CN9_DTINIC >= '"+dtos(mv_par05)+"'"
cQuery += "  AND CN9.CN9_DTFIM  <= '"+dtos(mv_par06)+"'"
cQuery += "  AND CN9.CN9_SITUAC >= '"+mv_par07+ "'"
cQuery += "  AND CN9.CN9_SITUAC <= '"+mv_par08+ "'"
cQuery += "  AND "
If lFiltForn
	cQuery += " CND.CND_FORNEC >= '"+mv_par09+"' AND "
	cQuery += " CND.CND_FORNEC <= '"+mv_par10+"' AND "
Else
	cQuery += " CND.CND_CLIENT >= '"+mv_par15+"' AND "
	cQuery += " CND.CND_CLIENT <= '"+mv_par16+"' AND "
EndIf
If !Empty(mv_par11)
	cQuery += " CN9.CN9_TPCTO   = '"+mv_par11 + "' AND "
EndIf
cQuery += "      CND.D_E_L_E_T_ = ' ' "
cQuery += "  AND CN9.D_E_L_E_T_ = ' ' "                

cQuery += " AND CND_COMPET='"+mv_par20 +"'"

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCND,.F.,.T.)},"Processando") //-- Processando

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza estrutura do CND           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aStrucCND)
	If aStrucCND[nX,2] != 'C' .And. (cAliasCND)->( FieldPos( aStrucCND[nx,1] ) ) > 0
		TCSetField(cAliasCND,aStrucCND[nX,1], aStrucCND[nX,2],aStrucCND[nX,3],aStrucCND[nX,4])
	EndIf
Next nX


While !(cAliasCND)->(Eof())	
	nTotReg++
	dbSkip()
End           

If ntotReg > 1
	ProcRegua(nTotReg)
Else
	ProcRegua((cAliasCND)->( LASTREC()))
EndIf

//Inicia processamento dos contratos/medicoes
(cAliasCND)->(dbGoTop())
While !(cAliasCND)->(Eof())

	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInstancia classe FWMSEXCELณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	oExcel := FWMSEXCEL():New()	
	
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine as sheets e colunasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/ 
	//Define a primeira sheet Contrato
	oExcel:AddworkSheet("Contrato")
	//Define a tabela Medicao
	oExcel:AddTable ("Contrato","Contrato")
	//Define as colunas da sheet da planilha
	oExcel:AddColumn("Contrato","Contrato","Medicao",1,1)
	oExcel:AddColumn("Contrato","Contrato","Contrato",1,1)
	oExcel:AddColumn("Contrato","Contrato","Revisao",1,1)
	oExcel:AddColumn("Contrato","Contrato","Planilha",1,1)
	oExcel:AddColumn("Contrato","Contrato","Cliente",1,1)
	oExcel:AddColumn("Contrato","Contrato","Valor do Faturamento",1,2)
	oExcel:AddColumn("Contrato","Contrato","Vencimento",1,4)
	oExcel:AddColumn("Contrato","Contrato","Periodo",1,1)
	oExcel:AddColumn("Contrato","Contrato","Competencia",1,1)
	oExcel:AddColumn("Contrato","Contrato","Data",1,4)
	
	
	//Define a segunda sheet da planilha
	oExcel:AddworkSheet("Locacoes")
	//Define a tabela Locacoes
	oExcel:AddTable ("Locacoes","Locacoes")
	//Define as colunas da sheet Contrato
	oExcel:AddColumn("Locacoes","Locacoes","Patrimonio",1,1)
	oExcel:AddColumn("Locacoes","Locacoes","Modelo",1,1)
	oExcel:AddColumn("Locacoes","Locacoes","Valor Locacao",1,2)
	//oExcel:AddColumn("Locacoes","Locacoes","Valor Pro-Rata",1,2)
	oExcel:AddColumn("Locacoes","Locacoes","Loja",1,1)
	oExcel:AddColumn("Locacoes","Locacoes","Descricao",1,1)
	oExcel:AddColumn("Locacoes","Locacoes","Endereco de Instalacao",1,1)
	oExcel:AddColumn("Locacoes","Locacoes","Data de Instalacao",1,4)
	oExcel:AddColumn("Locacoes","Locacoes","Data de Remocao",1,4)
	
	
	//Define a terceira sheet da planilha
	oExcel:AddworkSheet("Insumos")
	//Define a tabela Insumos
	oExcel:AddTable ("Insumos","Insumos")
	//Define as colunas da sheet Insumos
	oExcel:AddColumn("Insumos","Insumos","Produto",1,1)
	oExcel:AddColumn("Insumos","Insumos","Descricao",1,1)
	oExcel:AddColumn("Insumos","Insumos","Armazem",1,1)
	oExcel:AddColumn("Insumos","Insumos","Descricao",1,1)
	oExcel:AddColumn("Insumos","Insumos","Qtde",1,2)
	oExcel:AddColumn("Insumos","Insumos","Valor UN",1,2)
	oExcel:AddColumn("Insumos","Insumos","Total",1,2)
	oExcel:AddColumn("Insumos","Insumos","Mensagem",1,1)
	                                                
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Armazena o codigo da medicao, contrato e revisao  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMedicao := (cAliasCND)->CND_NUMMED
	cContra  := (cAliasCND)->CND_CONTRA 
	cRevisa  := (cAliasCND)->CND_REVISA
	
	cTpFat := alltrim((cAliasCND)->CN9_XTPFAT)
	cCodCli := (cAliasCND)->CN9_CLIENT
	
	dbSelectArea("SA1")
	cUFLoja := GetAdvFVal("SA1","A1_EST", xFilial("SA1") +(cAliasCND)->CN9_CLIENT +(cAliasCND)->CN9_LOJACL,1)
	dbselectArea(cAliasCND)
	
	cLoja := IIF(cTpFat=="2",(cAliasCND)->CN9_LOJACL,"")
    lInsumo := .T.

    //armazena o nome da planilha
	cPlanilha := cContra +"_" +cMedicao +".xml"
    
	aLocacoes := {}
	aInsumos := {}
	aLojas := {}
	aAuxLj := {}
			
    
	IncProc("Contrato: "+cContra)
	dbSelectArea("CN9")
	dbSetOrder(1)
	
	If dbSeek(xFilial("CN9")+(cAliasCND)->CND_CONTRA+(cAliasCND)->CND_REVISA)
		lFixo := Posicione("CN1",1,xFilial("CN1")+(cAliasCND)->CN9_TPCTO,"CN1_CTRFIX") == "1"
		
		// Verifica se a planilha considera Insumos
 		dbSelectArea("CNA")
  		dbSetOrder(1) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO (filial+contrato+revisao+planilha)
   		If dbSeek(xFilial("CNA")+cContra +AvKey("","CNA_REVISA")+(cAliasCND)->CND_NUMERO)
    		If aLLtRIM(CNA->CNA_XINSUM) == "2"
    			lInsumo := .F.
    		EndIf
    	EndIf
		
		nTotfat := (cAliasCND)->CND_VLTOT	
		
		// PREPARA A DATA DE VENCIMENTO
		cVencto := AllTrim( Posicione("SE4",1,xFilial("SE4")+(cAliasCND)->CND_CONDPG,"E4_DESCRI") ) +" Emiss. NF"
				
		If SubStr((cAliasCND)->CND_COMPET,1,2) == "01"
			cAuxMes := "12"
		Else    
			cAuxMes := Val(SubStr((cAliasCND)->CND_COMPET,1,2))-1 //MONTH((cAliasCND)->CND_COMPET)-1
			If cAuxMes <= 9
				cAuxMes := "0" +cValTochar(cAuxMes)
			Else
				cAuxMes := cValTochar(cAuxMes)
			EndIf
		EndIf
		
		// Define a variavel da competencia
		cCompet := SUBSTR(CN9->CN9_XPCOMP,1,2) +"/" +cAuxMes  +" A " +SUBSTR(CN9->CN9_XPCOMP,4,2) +"/" +cAuxMes		
	    
	    cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+(cAliasCND)->CND_COMPETE)-1)),3))
		cPer2	:= If(SUBSTR(CN9->CN9_XPCOMP,1,2) > substr(CN9->CN9_XPCOMP,4,2),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20))),3)),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)))										  	
        If aLLtRIM(STOD(DTOC(cPer2))) == ""
        	cPer2 := cPer1 + 30
        EndIf
        
		dbSelectArea("CNE")
	    If lFixo
			cQuery := "SELECT CNE.CNE_ITEM,    CNE.CNE_PRODUT, CNB.CNB_DESCRI, CNB.CNB_UM,     CNB.CNB_VLUNIT, CNE.CNE_QTDSOL, "
			cQuery += "       CNE.CNE_QTAMED,  CNE.CNE_QUANT,  CNE.CNE_PERC,   CNE.CNE_VLUNIT, CNE.CNE_VLTOT,  CNB.CNB_QUANT,  "
			cQuery += "       CNB.CNB_QTDMED, (CNE.CNE_QTDSOL-CNE.CNE_QTAMED) AS CNE_QTDACM, ISNULL(CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), CNB_XPRORA)),''), CNB.R_E_C_N_O_ CNBREC "
			cQuery += "  FROM "+ RetSQLName("CNE")+" CNE, "+RetSQLName("CNB")+" CNB "
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
			cQuery += "   AND CNE.CNE_NUMMED = '"+cMedicao+"'" 
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra +"'"
			cQuery += "   AND CNE.CNE_REVISA = '"+cRevisa +"'"
			cQuery += "   AND CNB.CNB_CONTRA = CNE.CNE_CONTRA "
			cQuery += "   AND CNB.CNB_REVISA = CNE.CNE_REVISA "
			cQuery += "   AND CNB.CNB_NUMERO = CNE.CNE_NUMERO "
			cQuery += "   AND CNB.CNB_ITEM   = CNE.CNE_ITEM   "
			cQuery += "   AND CNB.D_E_L_E_T_ = ' ' "
			cQuery += "   AND CNE.D_E_L_E_T_ = ' ' "
		Else  
			cQuery := "SELECT CNE.CNE_ITEM,    CNE.CNE_PRODUT, CNE.CNE_QTDSOL, "
			cQuery += "       CNE.CNE_QTAMED,  CNE.CNE_QUANT,  CNE.CNE_PERC,   "
			cQuery += "       CNE.CNE_VLUNIT, CNE.CNE_VLTOT, (CNE.CNE_QTDSOL-CNE.CNE_QTAMED) AS CNE_QTDACM "
			cQuery += "  FROM "+ RetSQLName("CNE")+" CNE "
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CNE.CNE_NUMMED = '"+cMedicao+"'" 
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra +"'"  
			cQuery += "   AND CNE.CNE_REVISA = '"+cRevisa +"'"
			cQuery += "   AND CNE.D_E_L_E_T_ = ' ' "		
		EndIf
		
		cAliasCNE := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCNE,.F.,.T.)},"") //-- Processando

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza estrutura dos itens da medicao  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		For nX := 1 to Len(aStrucCNE)
			If aStrucCNE[nX,2] != 'C' .And. (cAliasCNE)->( FieldPos( aStrucCNE[nx,1] ) ) > 0
				TCSetField(cAliasCNE,aStrucCNE[nX,1], aStrucCNE[nX,2],aStrucCNE[nX,3],aStrucCNE[nX,4])
			EndIf
		Next nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza estrutura dos itens da planilha ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		For nX := 1 to Len(aStrucCNB)
			If aStrucCNB[nX,2] != 'C' .And. (cAliasCNE)->( FieldPos( aStrucCNB[nx,1] ) ) > 0
				TCSetField(cAliasCNE,aStrucCNB[nX,1], aStrucCNB[nX,2],aStrucCNB[nX,3],aStrucCNB[nX,4])
			EndIf
		Next nX

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza campo calculado na query ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		TCSetField(cAliasCNE,"CNE_QTDACM", "N",TamSx3("CNE_QUANT")[1],TamSx3("CNE_QUANT")[2])

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Inicializa as variaveis de totalizacao		  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		nTotAcm := 0
		nTot    := 0
		nBruto  := 0
		cDescri := ''
	
		While !(cAliasCNE)->(Eof())
			cProduto := ""
			cDescProd := ""
			cLojaSN1 := ""
			cNomeCli := ""
			cPatrimo := ""
            cLojas := ""
            
			// Define o valor total da medicao (Valor unitario da planilha - CNB)
			nTotMed := (cAliasCNE)->CNE_VLUNIT
			cDescri1  := ""
			cDescri2  := ""
			cProduto1 := ""
			cProduto2 := ""
			If lFixo
				cDescri  := AllTrim((cAliasCNE)->CNB_DESCRI)   
			Else
		   		cDescri :=  Posicione("SB1",1,xFilial("SB1")+(cAliasCNE)->CNE_PRODUT,"B1_DESC")
		   		cUM     :=  Posicione("SB1",1,xFilial("SB1")+(cAliasCNE)->CNE_PRODUT,"B1_UM")
			EndIf
		   
			cDescri1 := cDescri
			If nCNETamDsc> 40 .And. !Empty(SubStr(cDescri,41,nCNETamDsc))
				nTipo := 5      
			   	cDescri1 := SubStr(cDescri,1,40)           
			   	cDescri2 := SubStr(cDescri,41,nCNETamDsc)     
			 Else
				nTipo    := 5
				cDescri2 :=""  		 
			 EndIf
					 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica o conteudo do campo Produtoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cProduto1 := (cAliasCNE)->CNE_PRODUT  
			
			If nCNETamPrd> 15 .And. !Empty(SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd)) 
				nTipo := 5           
			   	cProduto1 := SubStr((cAliasCNE)->CNE_PRODUT,1,15)           
			   	cProduto2 := SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd) 			   
			Else  
				If Empty(cDescri2)           
					nTipo    := 5
					cProduto2:=""					 
				EndIf
			EndIf
				
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao dos Itens da Medicao						   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAux := RetPatr(cContra,(cAliasCND)->CND_NUMERO)	// patrimonios
			For nX := 1 to len(aAux)
				cProduto := ""
				cDescProd := ""
				cLojaSN1 := ""
				cNomeCli := ""
				cPatrimo := aAux[nX][1]
				RetInfPatr(cPatrimo,@cProduto,@cDescProd,@cLojaSN1,@cLocFis,@dDtInst,@dDtRem,.f.,cPer2,cPer1,(cAliasCND)->CND_NUMERO,cContra)
			    
				If Alltrim(dDtInst) == ""
					dDtInst := aAux[nX][3]
				EndIf                     
				//If AllTrim(dDtRem) == ""
				//	dDtRem := aAux[nX][4]
				//EndIf
			
				nVal := aAux[nX][2]
		
				//loja - se for faturamento por CLIENTE, busca na SN1
	  			If cTpFat == "1"
	  				cLoja := cLojaSN1
	  				If AllTrim(cLoja) <> ""
						AADD(aLojas, cLoja)    
					EndIf
	  			EndIf                                                             
	  			cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaSN1,"A1_NREDUZ")
		  			
  				AADD(aLocacoes,{cPatrimo,;
  								cDescProd,;
  								nVal,;
  								cLojaSN1,;
  								cNomeCli,;
  								cLocFis,;
  								dDtInst,;
  								dDtRem})
	  		
		  	Next nX

	        dDtAssi := CN9->CN9_DTASSI
	        
	        // PRO RATA
	 		// Formato do Array aAux2 com TODOS os valores do Pro Rata
			// [x][1] - Tipo - Remocao ou Instalacao [R|I]
			// [x][2] - Patrimonio - Numero do patrimonio
			// [x][3] - Valor - Valor do aluguel do patrimonio
			// [x][4] - Data da remocao/instalacao
			dbSelectArea("CN9")
			
			If Select("CNB") <> 0
   				dbSelectArea("CNB")
       			dbGoTo((cAliasCNE)->CNBREC)  
          	EndIf
			If AllTrim(CNB->CNB_XPRORA) <> ""
				aAux := StrToKarr(CNB->CNB_XPRORA,"|")
				For nI := 1 to Len(aAux)
					aLojas := {}
					cProduto := ""
					cDescProd := ""
					cLojaSN1 := ""
					cNomeCli := ""
					aAux2 := StrToKarr(aAux[nI],",")
					If Len(aAux2) >= 4
						If AllTrim(aAux2[2]) <> "" .And. AllTrim(aAux2[3]) <> "" .And. AllTrim(aAux2[4]) <> ""
							If CtoD(aAux2[4]) >= cPer1 .And. CtoD(aAux2[4]) <= cPer2
								cDescri1 := AllTrim(aAux2[2])	//adiciona o patrimonio     
								nVlrPatri := Val(aAux2[3])		//adiciona o valor pro rata
								nTotPrata += nVlrPatri			//incrementa o totalizador de valores Pro Rata
								
								RetInfPatr(cDescri1,@cProduto,@cDescProd,@cLojaSN1,@cLocFis,@dDtInst,@dDtRem,.t.,cPer1,cPer2,(cAliasCND)->CND_NUMERO,cContra)
								
								// calculo do valor Pro Rata
								// remocao
								If AllTrim(aAux2[1]) == "R" 
									nQtdDias := cTod(aAux2[4]) - cPer1 +1		// Dia da remocao - dia inicial
									nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1						// Total Dias do mes
									nVlDia := nVlrPatri / nQtdComp				// Valor da locacao por dia 
									nVlrPatri := nVlDia * nQtdDias				// Valor Pro Rata do patrimonio
									nVlrPatri := cvaltochar(nVlrPatri)			// Transform(nVlrPatri,"@E 999,999,999.99")
									dDtRem := aAux2[4]							// pega da pro rata a data de remocao
								// instalacao
								ElseIf AllTrim(aAux2[1]) == "I"
									//nQtdDias := cPer2 - cTod(aAux2[4])	// Data final - dia da instalacao
									nQtdDias := cPer2 - ctod(aAux2[4])
									nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1						// Total de dias do mes
									nVlDia := nVlrPatri / nQtdComp				// Valor da locacao por dia
									nVlrPatri := nVlDia * nQtdDias				// Valor Pro Rata do patrimonio
									nVlrPatri := cvaltochar(nVlrPatri)			//Transform(nVlrPatri,"@E 999,999,999.99")
									dDtInst := aAux2[4]							// pega da pro rata a data de instalacao
								EndIf
					  			
					  			//-- Descricao                                            
								If AllTrim(aAux2[1]) == "R"
									cTxtDescri := "Ref Pro Rata Remo็ใo de patrim๔nio na data: "+aAux2[4]
								ElseIf	AllTrim(aAux2[1]) == "I"
									cTxtDescri := "Ref Pro Rata Instala็ใo de patrim๔nio na data: "+aAux2[4]
								EndIf
	
								//loja - se for por CLIENTE, busca na SN1
					  			If cTpFat == "1"
					  				cLoja := cLojaSN1
					  				If AllTrim(cLoja) <> ""
					  					AADD(aLojas, cLoja)    
					  				EndIf
					  			EndIf                                                             
					  			cNomeCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLojaSN1,"A1_NREDUZ")
					  			
					  			nPosPat := AScan(aLocacoes, {|x| AllTrim(x[1]) == AllTrim(cDescri1) })
					  			If nPosPat > 0
					  				aDel(aLocacoes, nPosPat)
					  				Asize(aLocacoes, Len(aLocacoes)-1)
					  			EndIf
					  			
								AADD(aLocacoes,{cDescri1,;
				  								cTxtDescri,;
				  								Val(nVlrPatri),;
				  								cLojaSN1,;
				  								cNomeCli,;
				  								cLocFis,;
				  								dDtInst,;
				  								dDtRem})
							EndIf
						EndIf
					EndIf
				Next nI
			EndIf
        	dbSelectArea(cAliasCNE) 
			(cAliasCNE)->(dbSkip())		
		EndDo
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava a sheet de locacoesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		nTotalLoc := 0
		For nI := 1 To Len(aLocacoes)
			oExcel:AddRow("Locacoes","Locacoes",{aLocacoes[nI][1],;			//Patrimonio
												aLocacoes[nI][2],;				//Modelo
												aLocacoes[nI][3],;				//Valor
												aLocacoes[nI][4],;				//Loja
												aLocacoes[nI][5],;				//Desc Loja				
												aLocacoes[nI][6],;				//End instalacao patrimonio
												aLocacoes[nI][7],;				//Data instalacao
												aLocacoes[nI][8]})				//Data remocao  
			nTotalLoc += aLocacoes[nI][3]									
		Next nI
		
		oExcel:AddRow("Locacoes","Locacoes",{"Total",;			//Patrimonio
											""	,;				//Modelo
											nTotalLoc,;			//Valor
											"",;				//Loja
											"",;				//Desc Loja				
											"",;				//End instalacao patrimonio
											"",;				//Data instalacao
											""})				//Data remocao  

		/*
			INICIO DA PARTE DESTINADA PARA RELATORIOS DE INSUMOS REMETIDOS PARA O CLIENTE		
		*/		 
		//If (cAliasCND)->CND_NUMERO == "000001"
			If lInsumo
				lIniInsumo := .T.
				// NOVA REGRA DAS LOJAS - preenche a variavel cLojas
				If (cAliasCND)->CN9_CLIENTE $ cCliDifer
					RetLojas( (cAliasCND)->CN9_CLIENT, cUFLoja )
				EndIf
				
				// opcao colocada para o usuario escolher o tipo de faturamento de insumo - porque todo mes isso da problema
				If Mv_PAR21 == 1 
					Insumosd2()
				ElseIf Mv_par21 == 2	
					Insumos()
				ElseIf Mv_par21 == 3
					Insumos()
					Insumosd2()  	
				EndIf	
				
				
				// fleury
				/*
				If (cAliasCND)->CN9_CLIENTE $ cCliDifer 
					Insumos()
				// mapfre	
				ElseIf (cAliasCND)->CN9_CLIENTE == "005502"
					Insumosd2()                             
				Else
					Insumos()
					Insumosd2()                             					
				EndIf
				*/
				
				//Grava os insumos
				For nI := 1 To Len(aInsumos)
					oExcel:AddRow("Insumos","Insumos",{aInsumos[nI][1],;
														aInsumos[nI][2],;
														aInsumos[nI][3],;		
														aInsumos[nI][4],;			
														aInsumos[nI][5],;			
														aInsumos[nI][6],;			
														aInsumos[nI][7],;
														aInsumos[nI][8]})			
				Next nI                            
				                                 
				// Adiciona total geral dos Insumos
				oExcel:AddRow("Insumos","Insumos",{"",;
													"Total",;
													"",;		
													"",;			
													0,;			
													0,;			
													nTotInsumo,;
													""})			
			//EndIf
		EndIf
		
		//Considera Insumos? Ajusta o total do faturamento 
		If lInsumo
        	nTotfat += nTotInsumo
        	nTotInsumo := 0
        EndIf
		
		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava a primeira sheetณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
		oExcel:AddRow("Contrato","Contrato",{cMedicao,;
											cContra,;
											cRevisa,;
											(cAliasCND)->CND_NUMERO,;
											 AllTrim((cAliasCND)->CND_CLIENT)+" - "+Posicione("SA1",1,xFilial("SA1")+(cAliasCND)->CND_CLIENT+(cAliasCND)->CND_LOJACL,"A1_NOME" ),;
											  nTotFat,;
											  cVencto,;
											  cCompet,;
											  (cAliasCND)->CND_COMPET,;
											  Dtoc(DDATABASE)})    
	
	
	
	
		oExcel:Activate()
		oExcel:GetXMLFile(cDir+cPlanilha)
		
		If File(cDir +cPlanilha)
			Aviso("TTCNTR01","A planilha foi gerada em "+UPPER(cDir) +CRLF +"Nome: "+cPlanilha,{"Ok"})
			//mostra planilha na tela somente se for impressao de um contrato
			If nTotReg == 1
				If !ApOleClient( 'MsExcel' )
					Aviso("TTCNTR01", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
				Else
					oExcelApp := MsExcel():New()
					oExcelApp:WorkBooks:Open( cDir +cPlanilha )
					oExcelApp:SetVisible(.T.)         
					oExcelApp:Destroy()
				EndIf
			EndIF
		EndIf  
		
		oExcel:DeActivate()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Finaliza a consulta aos itens ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		(cAliasCNE)->(dbCloseArea())	
	EndIf
	(cAliasCND)->(dbSkip())	
EndDo

(cAliasCND)->(dbCloseArea())


Return


/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCNR040ClFrณ Autor ณ Aline Sebrian         ณ Data ณ 11.04.11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณValida os parametro do Cliente e Fornecedor no relatorio.   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณCNR040ClFr()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณCNR040ClFr()                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CNR040ClFr(cTipo)
Local aSaveArea	:= GetArea()

If cTipo=="1"    
	If !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("A2_COD")[1]))
		MV_PAR15	:= Space(6)
		MV_PAR16	:= REPLICATE("Z",TamSx3("A1_COD")[1])	 
	EndIf
Else
	If !Empty(mv_par15) .Or. (!Empty(mv_par16) .And. UPPER(mv_par16) != REPLICATE("Z",TamSx3("A1_COD")[1]))
		MV_PAR09	:= Space(6)
		MV_PAR10	:= REPLICATE("Z",TamSx3("A2_COD")[1])    
	EndIf
EndIf   

	    
RestArea(aSaveArea)

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInsumos   บAutor  ณAlexandre Venancio  บ Data ณ  27/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relacao de insumos enviados para o cliente que devem ser   บฑฑ
ฑฑบ          ณcobrados junto com as locacoes                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Insumos()
      
Local aArea	:=	GetArea()
Local cQuery
Local cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+(cAliasCND)->CND_COMPETE)-1)),3))
//Local cPer2 := If(SUBSTR(CN9->CN9_XPCOMP,1,2) > substr(CN9->CN9_XPCOMP,4,2),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20))),3)),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)))
Local cPer2 := If(SUBSTR(CN9->CN9_XPCOMP,1,2) >= substr(CN9->CN9_XPCOMP,4,2),If(CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3))>cPer1,CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20))),3))),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)))
Local nTot	:=	0
Local nQtd	:=	0
Local nSub	:=	0
Local nQSb	:=	0
Local cArm	:=	''

If Empty(cPer2)
	cPer2 := cPer1 + 30
EndIf

cQuery := QueryD3(cPer1,cPer2,(cAliasCND)->CN9_CLIENTE,cLojas,cCliDifer) 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTR040_D3.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

cArm	:=	TRB->D3_LOCAL
If !Empty(cArm)	
		
	While !EOF()
	
		nTotInsumo += TRB->VALOR 
		
	    If cArm <> TRB->D3_LOCAL			
			AADD(aInsumos,{"",;
							"Sub-Total",;
							cArm,;
							"",;
							0,;
							0,;
							nSub,;
							""})
			
			nQSb	:=	0//TRB->QTD
			nSub	:=	0//TRB->VALOR 
			cArm	:=	TRB->D3_LOCAL
		EndIf
		
			AADD(aInsumos,{TRB->D3_COD,;
						TRB->B1_DESC,;
						TRB->D3_LOCAL,;
						TRB->ZZ1_DESCRI,;
						TRB->QTD,;
						TRB->D2_PRCVEN,;
						TRB->VALOR,;
						TRB->C5_MENNOTA})
		 
			nTot	+=	TRB->VALOR
			nQtd	+=	TRB->QTD 
			nQSb	+=	TRB->QTD
			nSub	+=	TRB->VALOR
	
		DbSkip()
	EndDo   
	//ultimo sub-total que o jackson ficou com preguica de colocar
	AADD(aInsumos,{"",;
					"Sub-Total",;
					cArm,;
					"",;
					0,;
					0,;
					nSub,;
					""})
	//Totais
	AADD(aInsumos,{"",;
					"Totais",;
					"",;
					"",;
					0,;
					0,;
					nTot,;
					""})                                   
EndIf

TRB->(dbCloseArea())
			
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณinsumosd2 บAutor  Alexandre Venancio   บ Data ณ  30/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insumos com consulta nos pedidos feitos para o cliente     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function insumosd2()

Local aArea	:=	GetArea()
Local cQuery
Local cPer1	:=	CTOD(SUBSTR(CN9->CN9_XPCOMP,1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+(cAliasCND)->CND_COMPETE)-1)),3))
//Local cPer2 :=	If(SUBSTR(CN9->CN9_XPCOMP,1,2) > substr(CN9->CN9_XPCOMP,4,2),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20))),3)),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)))
Local cPer2 := If(SUBSTR(CN9->CN9_XPCOMP,1,2) >= substr(CN9->CN9_XPCOMP,4,2),If(CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3))>cPer1,CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20))),3))),CTOD(SUBSTR(CN9->CN9_XPCOMP,4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR20)-1)),3)))
Local nTot	:=	0
Local nQtd	:=	0
Local nSub	:=	0
Local nQSb	:=	0
Local cArm	:=	'' 

If Empty(cPer2) 
	cPer2 := cPer1 + 30
EndIf

cQuery := QueryD2(cPer1,cPer2,(cAliasCND)->CN9_CLIENTE,cLojas,cCliDifer)

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTR040_D2.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

If !Empty(TRB->D2_COD)
	cArm	:=TRB->D2_LOJA //Posicione("ZZ1",3,xFilial("ZZ1")+(cAliasCND)->CN9_CLIENTE+TRB->D2_LOJA,"ZZ1_COD")
	While !EOF()
	
	nTotInsumo += TRB->VALOR 
	
	  If cArm <> TRB->D2_LOJA			
			AADD(aInsumos,{"",;
							"Sub-Total",;
							TRB->D2_LOJA,;
							"",;
							0,;
							0,;
							nSub,;
							""})
			
			nQSb	:=	0//TRB->QTD
			nSub	:=	0//TRB->VALOR 
			cArm	:=	TRB->D2_LOJA
		EndIf
		
		AADD(aInsumos,{TRB->D2_COD,;
						TRB->B1_DESC,;
						TRB->D2_LOJA,;
						TRB->NOME,;
						TRB->QTD,;
						TRB->D2_PRCVEN,;
						TRB->VALOR,;
						TRB->C5_MENNOTA})
	
			nTot	+=	TRB->VALOR
			nQtd	+=	TRB->QTD 
			nQSb	+=	TRB->QTD
			nSub	+=	TRB->VALOR
	
		DbSkip()
	EndDo                                   
	//ultimo sub-total que o jackson ficou com pregui็a de colocar
	AADD(aInsumos,{"",;
				"Sub-Total",;
				cArm,;
				"",;
				0,;
				0,;
				nSub,;
				""})
	//Totais
	AADD(aInsumos,{"",;
					"Totais",;
					"",;
					"",;
					0,;
					0,;
					nTot,;
					""})                  
EndIf	

TRB->(dbCloseArea())

RestArea(aArea)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetInfPatr บAutor  ณJackson E. de Deus  บ Data ณ  18/09/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna informacoes sobre a instalacao do patrimonio       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetInfPatr(cNumChapa,cProduto,cDescProd,cLojaSN1,cLocFis,dDtInst,dDtRem,lProRata,dDtIni,dDtFim,cPlanilha,cContra)

Local cQuery := ""
Local nTot := 0
Local aPatr := {}
Local nI

// Busca na SN1 informacoes do patrimonio
cQuery := "SELECT N1_PRODUTO, N1_DESCRIC, N1_XLOJA, N1_XLOCINS "
cQuery += "FROM " +RetSqlName("SN1") + " SN1 "
cQuery += "WHERE N1_CHAPA = '"+cNumChapa+"' "
cQuery += "AND D_E_L_E_T_ = '' "

If Select("TRBSN1") > 0
	TRBSN1->(dbCloseArea())
EndIf                     

TcQuery cQuery new alias "TRBSN1" 

dbSelectArea("TRBSN1")
cProduto	:= TRBSN1->N1_PRODUTO
cDescProd	:= TRBSN1->N1_DESCRIC
cLocFis		:= TRBSN1->N1_XLOCINS	

TRBSN1->(dbCloseArea())

// Busca na SZQ a data de instalacao e a loja
cQuery := "SELECT * FROM SZQ010 "
cQuery += " WHERE ZQ_CONTRA = '"+cContra+"' AND ZQ_PLAN = '"+cPlanilha+"' "
cQuery += " AND ZQ_PATRIM = '"+cNumChapa+"' AND D_E_L_E_T_ = '' "	//AND ZQ_CLIENTE = '"+cCliente+"'

If Select("TRBZQ") > 0
	TRBZQ->(dbCloseArea())
EndIf   

TcQuery cQuery new alias "TRBZQ" 

dbSelectArea("TRBZQ")
dbGoTop()
If !EOF()
	While !EOF()
		AADD( aPatr, { TRBZQ->ZQ_DATAINS, TRBZQ->ZQ_DATAREM, TRBZQ->ZQ_LOJA, TRBZQ->R_E_C_N_O_ }  )
		nTot++                                                             
		dbSkip()
	End
EndIf                 

TRBZQ->(dbCloseArea())

For nI := 1 To Len(aPatr)
	dDtRemP := aPatr[nI][2]
	nRecno := aPatr[nI][4]
	// caso tenha sido removido entre a competencia
	If !Empty(dDtRemP)
		If STOD(dDtRemP) >= dDtIni .And. STOD(dDtRemP) <= dDtFim
			dDtRem := dDtRemP
			cLojaSN1 := aPatr[nI][3]
						
			// procura se instalou novamente no mesmo contrato
			nPos2 := ASCAN( aPatr, { |x| x[4] <> nRecno .And. Empty(x[2]) .And. STOD(x[1]) <= dDtFim  } )
			If nPos2 > 0
				dDtInst := DTOC(STOD(aPatr[nPos2][1]))
				cLoja := aPatr[nPos2][3]
				cLocFis := ""	// remove local fisico
				Exit
			EndIf
		EndIf
	Else
		dDtInst := DTOC(STOD(aPatr[nI][1]))
		cLojaSN1 := aPatr[nI][3]
		Exit
	EndIf
Next nI
                                   

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetLojas  บAutor  ณJackson E. de Deus  บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca as lojas do estado do cliente                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetLojas(cCliente,cUFLoja)

Local cQuery := ""
Local aAuxLj := {}
Local aLojas := {}
Local nRes	:= 0 
Local nI

cQuery := "SELECT A1_LOJA FROM " +RetSqlName("SA1") +" SA1 "
cQuery += "WHERE A1_COD = '"+cCliente+"' AND A1_EST = '"+cUFLoja+"' AND D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"
            
dbGoTop()
While !EOF()
   	AADD(aLojas, TRB->A1_LOJA )	
	dbSkip()
End
TRB->(dbCloseArea())


For nI := 1 To len(aLojas)
	nRes := AScan(aAuxLj, { |x| x == aLojas[nI]  } )
	If nRes > 0
		Loop
	Else
		AADD(aAuxLj, aLojas[nI])	
	EndIf
Next nI

aLojas := aclone(aAuxLj)
				
For nI := 1 To Len(aLojas)
	If nI <> Len(aLojas)
 		cLojas += aLojas[nI] +"','"
 	Else
 		cLojas += aLojas[nI]
 	EndIf
Next nI
					
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetPatr   บAutor  ณJackson E. de Deus  บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca os patrimonios do contrato                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetPatr(cContra,cPlanilha)

Local cQuery := ""
Local aArea := GetArea()              
Local aAux := {}

cQuery := "SELECT ZQ_PATRIM, ZQ_VALOR, ZQ_DATAINS FROM " +RetSqlName("SZQ") + " WHERE ZQ_CONTRA = '"+cContra+"' AND ZQ_PLAN = '"+cPlanilha+"' AND D_E_L_E_T_ = '' AND ZQ_DATAREM = '' "

If Select("TRBP") > 0
	TRBP->( dbCloseArea() )
EndIf

Tcquery cQuery New alias "TRBP"

dbSelectArea("TRBP")
While !EOF()
	AADD(aAux, { TRBP->ZQ_PATRIM,;
				TRBP->ZQ_VALOR,;
				DTOC(stod(TRBP->ZQ_DATAINS)) })
	dbSkip()
End
dbCloseArea()

RestArea(aArea)                      
      
Return aAux



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQueryD2 บAutor  ณJackson E. de Deus    บ Data ณ  26/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a query referente as remessas - SD2                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function QueryD2(dDtIni,dDtFim,cCliente,cLojas,cCliDifer)

Local cQuery := ""

If Empty(dDtFim) 
	dDtFim := dDtIni + 30
EndIf

cQuery := "SELECT D2_COD,D2_LOJA,B1_DESC,SUM(D2_QUANT) AS QTD,D2_PRCVEN,A1_NREDUZ NOME,C5_MENNOTA,C5_XCODPA,SUM(D2_TOTAL) AS VALOR"
cQuery += " FROM "+RetSQLName("SD2")+" D2"
cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5.D_E_L_E_T_='' AND C5_XGPV='SAC'"
//cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=D2_XCODPA AND Z1.D_E_L_E_T_='' "
//cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=D2_FILIAL AND F4_CODIGO=D2_TES AND F4.D_E_L_E_T_=''"
cQuery += " WHERE "

cQuery += " D2_CLIENTE='"+cCliente+"' "
	
// No caso do cliente Fleury, considerar somente as lojas do estado  da loja do contrato
If cCliente $ cCliDifer
	If alltrim(cLojas) <> ""
		cQuery += " AND D2_LOJA IN ('"+cLojas+"') "
	EndIf                    
EndIf

cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"

cQuery += " AND D2_TES IN(SELECT F4_CODIGO FROM "+RetSQLName("SF4")+" WHERE F4_FINALID LIKE 'REM%' AND D_E_L_E_T_='')"
cQuery += " AND D2.D_E_L_E_T_='' AND D2_TES NOT IN('781','900')"
cQuery += " AND SUBSTRING(D2_COD,1,1) <> '8'"

cQuery += " GROUP BY D2_COD,D2_LOJA,B1_DESC,D2_PRCVEN,A1_NREDUZ,C5_MENNOTA,C5_XCODPA "
cQuery += " ORDER BY D2_LOJA"

Return cQuery



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQueryD3 บAutor  ณJackson E. de Deus    บ Data ณ  26/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a query referente as remessas - SD3                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function QueryD3(dDtIni,dDtFim,cCliente,cLojas,cCliDifer)
                        
Local cQuery := ""

If Empty(dDtFim)
	dDtFim := dDtIni + 30
EndIf
           
cQuery := "SELECT D3_COD,B1_DESC,D3_LOCAL,ZZ1_DESCRI,SUM(D3_QUANT) AS QTD,D2_PRCVEN,C5_MENNOTA, SUM(D2_TOTAL) AS VALOR "
cQuery += " FROM "+RetSQLName("SD3")+" D3"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D3_COD AND B1.D_E_L_E_T_='' AND B1_XSECAO='007' "
cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=D3_LOCAL AND Z1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 ON D2_FILIAL=D3_FILIAL AND D2_DOC=D3_XNUMNF AND D2_SERIE=D3_XSERINF AND D2_ITEM=D3_XITEMNF AND D2.D_E_L_E_T_='' "
//cQuery += " AND D2_TES IN(SELECT F4_CODIGO FROM " +RetSqlName("SF4") +" SF4 "
//cQuery += "             WHERE (F4_FINALID LIKE '%FUTU%' AND F4_CODIGO <> '781' ) AND D_E_L_E_T_='') "                                                            
cQuery += "INNER JOIN " +RetSqlName("SF4") +" F4 ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND F4_FINALID LIKE '%FUTU%' AND F4_CODIGO <> '781' AND F4.D_E_L_E_T_ = '' "

cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO AND C5_XGPV='SAC' AND C5.D_E_L_E_T_='' "

cQuery += " WHERE D3_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"' "  

// No caso do cliente Fleury, considerar somente as lojas do estado  da loja do contrato
If cCliente $ cCliDifer
	If alltrim(cLojas) <> ""
		cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE SUBSTRING(ZZ1_ITCONT,1,6)='"+cCliente+"' AND SUBSTRING(ZZ1_ITCONT,7,4) IN ('"+cLojas+"') AND D_E_L_E_T_='') "	
	EndIf                    
Else
	cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE SUBSTRING(ZZ1_ITCONT,1,6)='"+cCliente+"' AND D_E_L_E_T_='') "	
EndIf

cQuery += " AND D3.D_E_L_E_T_=''"
cQuery += " GROUP BY D3_COD,B1_DESC,D3_LOCAL,ZZ1_DESCRI,D2_PRCVEN,C5_MENNOTA"
cQuery += " ORDER BY D3_LOCAL"

Return cQuery