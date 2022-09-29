#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA05   ºAutor  ³Jackson E. de Deus º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera os pedidos de venda de Insumo - Faturamento fechmto    º±±
±±º          ³                                                            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³03/09/13³01.01 |Criacao                                 ³±±
±±³Jackson       ³08/05/14³01.02 |Correcao MsExecAuto					  ³±±
±±³Jackson       ³12/05/14³01.03 |Correcao MsExecAuto					  ³±±
±±³Jackson       ³26/02/15³01.03 |Correcao na busca de PA do Fleury		  ³±±
±±³								  Query de insumos direto do TTCNTR01	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTCNTA05()
                  
Local nOpca := 0
Local cPerg := "TTCNTA05"
Private cCompete := ""
Private oProcess
Private lEnd := .F.

If cEmpAnt == "01"
	
	AjustaSX1(cPerg)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tela de configuracao 			         	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Pedidos de Insumo") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este programa ira emitir os pedidos de venda de Insumo") SIZE 268, 8 OF oDlg PIXEL
		@ 38, 15 SAY OemToAnsi("") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("Configure os parametros") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento dos pedidos							         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess := MsNewProcess():New( { |lEnd| Pedidos(@oProcess, @lEnd) }, "Pedidos de Insumo", "Gerando os pedidos..", .F. )
		oProcess:Activate()
	EndIf
EndIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pedidos  ºAutor  ³Jackson E. de Deus   º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera os pedidos de venda de Insumo.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Pedidos()

Local cAliasCN9 := GetNextAlias()
Local cQuery
Local cQueryX
Local nTotReg := 0
Local lOk := .F.
Local aDados := {}
Local cUFLoja := ""
Local aLojas := {}
Local aAuxPed := {}
Local oExcel := FWMSEXCEL():New()
Local cArqXls := "pedidos_insumo.xml"
Local cDir := ""
Local ntotal := 0
Local aProdBlq := {}
Local cNomeFant := ""
Local lVldPedido := .F.
Local nI, nJ
Private cCodFil := ""
Private cLojas := ""
Private _cNumPed := ""
Private cCodCli := ""
Private cLjCli := ""
Private cTpCli := ""
Private cDescCli := ""
Private cTIPO := "N"
Private cRazao := ""
Private cXGPV :=  "PRO-A"	// U_TTUSRGPV(Alltrim(cUserName)) //"PRO-A"
Private cFinal := "B"
Private lMsErroAuto := .F.
Private aRelatorio := {}
Private cCliDifer := "005437"
Private _lSimula := .F.
cCompete := mv_par07

// monta a query
cQuery := "SELECT * FROM " + RetSQLName("CN9") + " CN9 "
cQuery += "WHERE CN9.CN9_FILIAL = '"+xFilial("CN9")+"' "
cQuery += "AND CN9.CN9_NUMERO >= '"+mv_par01+"' "
cQuery += "AND CN9.CN9_NUMERO <= '"+mv_par02+"' " 
//cQuery += "AND CN9.CN9_SITUAC = '05' "
cQuery += "AND CN9.CN9_CLIENT >= '"+mv_par03+"' "
cQuery += "AND CN9.CN9_CLIENT <= '"+mv_par04+"' "
cQuery += "AND CN9.CN9_LOJACL >= '"+mv_par05+"' "
cQuery += "AND CN9.CN9_LOJACL <= '"+mv_par06+"' "
cQuery += "AND CN9.D_E_L_E_T_ = ' ' "                

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCN9,.F.,.T.)},"")


While !(cAliasCN9)->(Eof())
	nTotReg++
	dbSkip()
End
oProcess:SetRegua1(ntotReg)

//Inicia verificacao dos pedidos de cada contrato
(cAliasCN9)->(dbGoTop())
While !(cAliasCN9)->(Eof())
	oProcess:IncRegua1("Contrato: " +(cAliasCN9)->CN9_NUMERO )
		
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xFilial("CN9")+(cAliasCN9)->CN9_NUMERO+(cAliasCN9)->CN9_REVISA)
		aDados := {}
		cUFLoja := GetAdvFVal("SA1","A1_EST", xFilial("SA1") +(cAliasCN9)->CN9_CLIENT +(cAliasCN9)->CN9_LOJACL,1)
		RetLojas((cAliasCN9)->CN9_CLIENT, cUFLoja) 	           
		
		// fleury/dia brasil	
		If (cAliasCN9)->CN9_CLIENT $ "005437#001283" // dados d2 e d3   					
			Insumos(@aDados)
			InsumosD2(@aDados)			
		// mapfre
		Else 
			//Insumos(@aDados)
			InsumosD2(@aDados)	
		EndIf
		
		cCodCli := (cAliasCN9)->CN9_CLIENT
		
		If Empty(aDados)
			AADD(aRelatorio, {(cAliasCN9)->CN9_NUMERO,;
								(cAliasCN9)->CN9_CLIENT,;
								(cAliasCN9)->CN9_LOJACL,;
								Posicione("SA1",1,xFilial("SA1")+(cAliasCN9)->CN9_CLIENT+(cAliasCN9)->CN9_LOJACL,"A1_NREDUZ"),;
								""	,;
								0,;
								"NAO HA DADOS DE INSUMOS PARA ESSE CONTRATO"})	
		Else
			For nI := 1 To Len(aDados)
				If Posicione("SB1",1,xFilial("SB1")+aDados[nI][1], "B1_MSBLQL" ) == "1"
					If Ascan(aProdBlq,{|x| AllTrim(x) == AllTrim(aDados[nI][1]) }) == 0
						AADD( aProdBlq, aDados[nI][1] )                                     
					EndIf
				EndIf
			Next nI
			
			If Len(aProdBlq) > 0
				// Array para Relatorio final
				AADD(aRelatorio, {(cAliasCN9)->CN9_NUMERO,;
									(cAliasCN9)->CN9_CLIENT,;
									"",;
									"",;
									"ERRO"	,;
									0,;
									"POSSUI PRODUTO(S) BLOQUEADO(S)"})
				(cAliasCN9)->( dbSkip() )
				Loop
			EndIf
			
			// Separa as lojas
			If (cAliasCN9)->CN9_CLIENT $ "005502#001283" // mapfre/dia brasil -> usa somente a loja matriz
				AADD( aLojas, (cAliasCN9)->CN9_LOJACL )  	
			// outros clientes fatura para as lojas
			Else	
				For nI := 1 To Len(aDados)     
					If aScan( aLojas, { |x| AllTrim(x) == AllTrim(aDados[nI][7]) } ) > 0
						Loop
					EndIf
					AADD( aLojas, aDados[nI][7] )
				Next nI			
			EndIf	
			
			oProcess:SetRegua2(Len(aLojas))
			
			For nI := 1 To Len(aLojas)
				If (cAliasCN9)->CN9_CLIENT == "005437" // FLEURY                                              
					cNomeFant := Posicione("SA1",1,xFilial("SA1")+(cAliasCN9)->CN9_CLIENT+aLojas[nI],"A1_NREDUZ") 
				Else
					cNomeFant := Posicione("SA1",1,xFilial("SA1")+(cAliasCN9)->CN9_CLIENT+(cAliasCN9)->CN9_LOJACL,"A1_NREDUZ") 
				EndIf
				oProcess:IncRegua2( "Loja: " +aLojas[nI] +" - " +AllTrim(cNomeFant) )
				_cNumPed := ""
				cLjCli := ""
				aAuxPed := {}
				ntotal := 0
				
				For nJ := 1 To Len(aDados)
					// Fleury - separa lojas
					If (cAliasCN9)->CN9_CLIENT == "005437"
						If aDados[nJ][7] == aLojas[nI]
							AADD( aAuxPed, aDados[nJ] )
						EndIf
					// Mapfre - somente uma loja	
					Else
						AADD( aAuxPed, aDados[nJ] )
					EndIf
				Next nJ
				
				// Ajusta os produtos repetidos (aglutina) - MAPFRE
				If (cAliasCN9)->CN9_CLIENT $ "005502#001283" 
					AjustaItem(@aAuxPed)
				EndIf
				
				cCodPa := aAuxPed[1][6]
				If (cAliasCN9)->CN9_CLIENT == "005437" 
					cCodfil := RetFil(cUFLoja)     
					cFilAnt := cCodFil
				EndIf
				cCodFil := cFilAnt
									
				// Se for Mapfre - considerar loja matriz
				//If CN9->CN9_CLIENT == "005502" 
				//	cLjCli := CN9->CN9_LOJACL           
				// caso contrario, a loja do array de lojas
				//Else
					cLjCli := aLojas[nI]           
				//EndIf                                          
				
				lOk := .F.
				lOk := gerapv(@nTotal,aAuxPed)				
				If !lOk				
					// Array para Relatorio do final
					AADD(aRelatorio, {(cAliasCN9)->CN9_NUMERO,;
										(cAliasCN9)->CN9_CLIENT,;
										aLojas[nI],;
										cNomeFant,;
										"ERRO" ,;
										nTotal,;
										"HOUVE ERRO A GERAR O PEDIDO" })	
				Else
		
					// Array para Relatorio do final
					AADD(aRelatorio, {(cAliasCN9)->CN9_NUMERO,;
										(cAliasCN9)->CN9_CLIENT,;
										cLjCli,;
										cNomeFant,;
										_cNumPed,;
										nTotal,;
										""})				
				EndIf							
			Next nI
		EndIf	
	EndIf
	aDados := {}
	ntotal := 0
	(cAliasCN9)->(dbSkip())	
EndDo

(cAliasCN9)->(dbCloseArea())

If Len(aRelatorio) == 0
	Return
EndIf

// Gera a planilha
While Empty(cDir)
	cDir := cGetFile(, OemToAnsi("Local para salvar a planilha"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.)         
End

oExcel:AddworkSheet("Pedidos") 
oExcel:AddTable ("Pedidos","Pedidos")
oExcel:AddColumn("Pedidos","Pedidos","Contrato",1,1)
oExcel:AddColumn("Pedidos","Pedidos","Cliente",1,1)
oExcel:AddColumn("Pedidos","Pedidos","Loja",1,1)
oExcel:AddColumn("Pedidos","Pedidos","Nome fantasia",1,1)
oExcel:AddColumn("Pedidos","Pedidos","Competencia",1,1)
oExcel:AddColumn("Pedidos","Pedidos","Pedido",1,1)
oExcel:AddColumn("Pedidos","Pedidos","Valor total",1,2)
oExcel:AddColumn("Pedidos","Pedidos","Observacao",1,1)                                                                 
                                                            
For nI := 1 To Len(aRelatorio)
	oExcel:AddRow("Pedidos","Pedidos",{aRelatorio[nI][1],; 
										aRelatorio[nI][2],;
										aRelatorio[nI][3],;
										aRelatorio[nI][4],;
										cCompete,;
										aRelatorio[nI][5],;
										aRelatorio[nI][6],;
										aRelatorio[nI][7]})

Next nI

// Produtos Bloqueados
If Len(aProdBlq) > 0
	oExcel:AddworkSheet("Produtos_Bloqueados") 
	oExcel:AddTable ("Produtos_Bloqueados","Produtos_Bloqueados")
	oExcel:AddColumn("Produtos_Bloqueados","Produtos_Bloqueados","Produto",1,1)
	oExcel:AddColumn("Produtos_Bloqueados","Produtos_Bloqueados","Descrição",1,1)
	
	 For nI := 1 To Len(aProdBlq)
		oExcel:AddRow("Produtos_Bloqueados","Produtos_Bloqueados",{aProdBlq[nI],Posicione("SB1",1,xFilial("SB1")+aProdBlq[nI], "B1_DESC" )})
	Next nI                                                        
EndIf

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTCNTA05","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTCNTA05", 'MsExcel não instalado. ' +CRLF +'O arquivo está em: '+cDir )
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Cabec  	ºAutor  ³Jackson E. de Deus  º Data ³  28/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o array do cabecalho do pedido de vendas.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabec(aSC5,cLjCli,cCodfil,cCodPa,nVol)

Local cMenNota := ""
Local cCondPag := "020"
Local aRet := {}
Local aPergs := {}

cMenNota := ""
//cCondPag := GetAdvFval("SA1","A1_TABELA" ,xFilial("SA1")+cCodCli+cLjCli,1)
cTpCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_TIPO")
cDescCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_NREDUZ")
cRazao := GetAdvFval("SA1","A1_NOME" ,xFilial("SA1")+cCodCli+cLjCli,1)

aAdd(aPergs ,{1,"Mensagem"	,space(TamSx3("C5_MENNOTA")[1]),"@!",".T.","",".T.",100,.F.})	
// Mensagem da Nota
If ParamBox(aPergs ,"Mensagem da nota - Loja: "+cLjCli,@aRet)
	cMenNota := AllTrim(aRet[1])
EndIf		
				
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Monta o cabecalho do pedido de venda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
*/
Aadd(aSC5, {"C5_FILIAL" 	,cFilAnt			,Nil}) 			// Filial
Aadd(aSC5, {"C5_NUM"    	,_cNumPed			,Nil})			// Numero do Pedido
Aadd(aSC5, {"C5_TIPO"   	,"N"      			,Nil})			// Tipo do Pedido
Aadd(aSC5, {"C5_CLIENTE"	,cCodCli 			,Nil})			// Cliente para faturamento
Aadd(aSC5, {"C5_LOJACLI"	,cLjCli				,Nil})			// Loja do cliente
Aadd(aSC5, {"C5_CLIENT"		,cCodCli 			,Nil})			// Cliente para entrega
Aadd(aSC5, {"C5_LOJAENT"	,cLjCli				,Nil})			// Loja para entrada
Aadd(aSC5, {"C5_XDTENTR"	,dDatabase+10		,Nil})			// Data da entrega
Aadd(aSC5, {"C5_XNFABAS"	,"2"				,Nil})			// Nf Abastecimento - NAO
//Aadd(aSC5, {"C5_XCODPA"		,cCodPa				,Nil})
Aadd(aSC5, {"C5_XFINAL" 	,"B"				,Nil})			// Finalidade de venda - Insumos p/ Locacao Fechamento
Aadd(aSC5, {"C5_TRANSP" 	,"000019"			,Nil})			// Transportadora -> Tok Take
Aadd(aSC5, {"C5_XTPCARG"	,"1"				,Nil})      
Aadd(aSC5, {"C5_XHRPREV"	,"00:00"			,Nil})  
Aadd(aSC5, {"C5_CONDPAG"	,cCondPag			,Nil})			// Codigo da condicao de pagamanto*
Aadd(aSC5, {"C5_MOEDA"		,1 					,Nil})			// Moeda
Aadd(aSC5, {"C5_FRETE"		,0 					,Nil})			// Frete
Aadd(aSC5, {"C5_TXMOEDA"	,0 					,Nil})			// Tx da Moeda
Aadd(aSC5, {"C5_EMISSAO"	,dDatabase			,Nil})			// Data de emissao
Aadd(aSC5, {"C5_MENNOTA"	,cMenNota			,Nil})			// Msg da nota
Aadd(aSC5, {"C5_ESPECI1"	,"UN"				,Nil})			// Especie
Aadd(aSC5, {"C5_XHRINC"		,TIME()				,Nil})			// Hora da inclusao
Aadd(aSC5, {"C5_XDATINC"	,DATE()				,Nil})			// Data da inclusao
Aadd(aSC5, {"C5_XNOMUSR"	,cUserName			,Nil}) 			// Login do usuario
Aadd(aSC5, {"C5_XCODUSR"	,__cUserID			,Nil})			// Codigo do usuario
Aadd(aSC5, {"C5_TPFRETE" 	,"C" 				,Nil})			// Tipo de Frete: CIF
Aadd(aSC5, {"C5_TIPOCLI"	,cTpCli				,Nil})			// Tipo de Cliente
Aadd(aSC5, {"C5_TIPLIB" 	,"1"         		,Nil})			// Tipo de Liberacao
Aadd(aSC5, {"C5_VEND1"  	,"000023"			,Nil})			// Vendedor
Aadd(aSC5, {"C5_XDESCLI"	,cDescCli			,Nil})			// Desc Cliente
Aadd(aSC5, {"C5_VOLUME1"	,nVol				,Nil})			// Volume
Aadd(aSC5, {"C5_XGPV"	 	,cXGPV				,Nil}) 			// Grupo do Pedido de Venda
    
Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Itens  ºAutor  ³Jackson E. de Deus     º Data ³  01/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o array dos itens do pedido de venda.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Itens(aSC6,aAuxPed,cLjCli,cCodfil,nTotal,nVol) 

Local cTES := ""
Local cProd := ""
Local nItem := "01" 
Local cOpera := ""
Local cArmPA := ""
Local lPAOK := .F.
Local aPergs := {}
Local aRet := {}
Local nI := 0
Local nJ := 0 
//Local ddtIni := dDatabase - 120
//Local ddtFim := dDatabase
//Local nContTes := 0
Local aTES := {}
Local aAux := {}
Local lTesOK := .F.  
Local aTES		:= {}	
Local lAjusTES	:= .F.
Local cTpCli	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_TIPO")
Local cEPP    	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_XEPP")
Local cOpera	:= U_TTOPERA("PRO-A",cTpCli,"B",cEPP) 
Private aHeader := {}


For nI := 1 To Len(aAuxPed)
	AADD( aTES, { aAuxPed[nI][1], "" } )
Next nI

For nI := 1 To Len(aTES) 
	cTes := MaTesInt(2,cOpera,cCodCli,cLjCli,"C",aTES[nI][1],"C6_TES")
	If Empty(cTes)
		lAjusTES := .T.
		aTES[nI][2] := Space(3)
	Else
		aTES[nI][2] := cTes
	EndIf	
Next nI

If lAjusTES
	aTES := U_TTFAT26C( aTES )
EndIf

	
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array de itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/                        
nVol := 0	 // volume

For nI := 1 To Len(aAuxPed)
	cProd := aAuxPed[nI][1]
	cCusto := "70500007"
	cItemCC := Posicione("ZZ1",1, cCodfil +aAuxPed[nI][6],"ZZ1_ITCONT") 
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek( cCodfil +AvKey(cProd,"B1_COD") +Avkey(aAuxPed[nI][6] ,"B1_LOCPAD") )
		CriaSB2(cProd,aAuxPed[nI][6])
	Endif
	
	For nJ := 1 To Len(aTes)
		If aTes[nJ][1] == cProd
			cTes := aTes[nI][2]
			Exit
		EndIf
	Next nJ		  
		
	Aadd(aSC6,{{"C6_FILIAL"	 	,cFilAnt									,Nil},;		// Filial
				{"C6_ITEM"   	,nItem 										,Nil},;		// Numero do Item
				{"C6_PRODUTO"	,cProd										,Nil},;		// Codigo do Produto
				{"C6_NUM"    	,_cNumPed									,Nil},;		// Numero do Pedido de venda
				{"C6_QTDVEN" 	,aAuxPed[nI][2]								,Nil},; 	// Quantidade Vendida
				{"C6_XQTDORI"	,aAuxPed[nI][2]								,Nil},;
				{"C6_TPOP"		,"F"										,Nil},;
				{"C6_PRCVEN"	,aAuxPed[nI][3]		  						,Nil},;		// Preco Unitario Liquido
				{"C6_PRUNIT"	,aAuxPed[nI][3]		  						,Nil},;		// Preco Unitario Liquido
				{"C6_VALOR"		,Round(aAuxPed[nI][2]*aAuxPed[nI][3],6)		,Nil},; 	// Valor Total do Item
				{"C6_TES"		,cTES										,Nil},; 	// Tipo de Entrada/Saida do Item  // mudar a TES
				{"C6_CLI"		,cCodCli									,Nil},; 	// Cliente
				{"C6_LOJA"		,cLjCli		  								,Nil},; 	// Loja do Cliente
				{"C6_LOCAL"		,aAuxPed[nI][6] 							,Nil},; 	// Armazem - PA
				{"C6_CCUSTO"	,cCusto							  			,Nil},;		// CENTRO DE CUSTO ??
				{"C6_ITEMCC"	,cItemCC									,Nil},;
				{"C6_XGPV"		,cXGPV			 							,Nil},; 	// Grupo do Pedido de Venda
				{"C6_ENTREG"	,dDataBase+10 								,Nil},; 	// Data da Entrega							
				{"C6_XDTEORI"	,DDATABASE+10								,Nil},;
				{"C6_UM"		,aAuxPed[nI][4]								,Nil},; 	// Unidade de Medida Primar.
				{"C6_SEGUM"		,aAuxPed[nI][5]						   		,Nil},;		// Segunda Unidade de medida
				{"C6_XHRINC"	,TIME()										,Nil},;		// Hora da inclusao
				{"C6_XDATINC"	,Date()		 								,Nil},;		// Data da inclusao
				{"C6_XUSRINC"	,cUsername 	 								,Nil}})		// Login do usuario
	
	nItem := Soma1(nItem)
	ntotal += Round(aAuxPed[nI][2]*aAuxPed[nI][3],6)
	
	nVol += aAuxPed[nI][2]
	
Next nI



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Insumos ºAutor  ³Jackson E. de Deus    º Data ³  08/27/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem os insumos enviados via remessa - SD3			      º±±
±±º          ³								                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Insumos(aDados)
      
Local aArea	:=	GetArea()
Local cQuery
Local cPer1	:= ""
Local cPer2 := ""
Local cArm	:=	''
Local cUm := ""
Local cSegUm := ""

cPer1 := StoD( SubStr(cCompete,4) +SubStr(cCompete,1,2) +"01" )
cPer2 := LastDay(cPer1)

cQuery := STATICCALL(TTCNTR01,QueryD3,cPer1,cPer2,CN9->CN9_CLIENT,cLojas,cCliDifer) 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTA05_D3.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
dbGoTop()
cArm := TRB->D3_LOCAL
If !Empty(cArm)	
	While !EOF()
		cLoja := ""
		  
	    If cArm <> TRB->D3_LOCAL
			cArm	:=	TRB->D3_LOCAL
		EndIf
		
		// FLEURY / DIA BRASIL
		If CN9->CN9_CLIENT $ "005437#001283"
			cLoja := Posicione("ZZ1",1,xFilial("ZZ1") +TRB->D3_LOCAL, "ZZ1_ITCONT")
			cLoja := SubStr(cLoja,7,4)
		Else
			cLoja := TRB->D2_LOJA	// nao utilizado pois quando mapfre nao chama essa rotina	                                               
		EndIf
		
		cUm := Posicione("SB1", 1, xFilial("SB1") +AvKey(TRB->D3_COD,"B1_COD"), "B1_UM" )
		cSegUm := Posicione("SB1", 1, xFilial("SB1") +AvKey(TRB->D3_COD,"B1_COD"), "B1_SEGUM" )
		DbSelectArea("TRB")
						
		AADD(aDados,{TRB->D3_COD,;
					TRB->QTD,;
					TRB->D2_PRCVEN,;
					cUm,;
					cSegUm,;
					TRB->D3_LOCAL,;
					cLoja,;
					TRB->VALOR})

		TRB->( DbSkip() )
	EndDo                                   
EndIf 

TRB->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Insumosd2  ºAutor  ³Jackson E. de Deus º Data ³  02/27/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem os insumos enviados via faturamento direto - SD2     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Insumosd2(aDados)

Local aArea	:=	GetArea()
Local cQuery
Local cPer1	:= ""	//cCompete
Local cPer2 := ""	//cCompete 
Local cArm	:=	''
Local cCodPA := ""
Local cUm := ""
Local cSegUm := ""
Local dDtAux

cPer1 := StoD( SubStr(cCompete,4) +SubStr(cCompete,1,2) +"01" )
cPer2 := LastDay(cPer1)

cQuery := STATICCALL(TTCNTR01,QueryD2,cPer1,cPer2,CN9->CN9_CLIENT,cLojas,cCliDifer) 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCNTA05_D2.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
dbGoTop()
If !Empty(TRB->D2_COD)
	While TRB->( !EOF() )
		If CN9->CN9_CLIENT $ "005437"	// fleury / DIA BRASIL
			cCodPA := TRB->C5_XCODPA
		ElseIf CN9->CN9_CLIENT == "005502"	// mapfre
			cCodPA := "P01513"			// ??? DEFINIR ESSA QUESTAO DE PA
		ElseIf CN9->CN9_CLIENT == "001283"
			cCodPa := "P01995"
		EndIf
		
		cUm := Posicione("SB1", 1, xFilial("SB1") +AvKey(TRB->D2_COD,"B1_COD"), "B1_UM" )
		cSegUm := Posicione("SB1", 1, xFilial("SB1") +AvKey(TRB->D2_COD,"B1_COD"), "B1_SEGUM" )
		dbSelectArea("TRB")
		
		AADD(aDados,{TRB->D2_COD,;
					TRB->QTD,;
					TRB->D2_PRCVEN,;
					cUm,;
					cSegUm,;
					cCodPa,;
					TRB->D2_LOJA,;
					TRB->VALOR})					
		
		TRB->( DbSkip() )
	End                                   
EndIf	

TRB->(dbCloseArea())
			
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1  ºAutor  ³Jackson E. de Deus º Data ³  28/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta as perguntas                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)

Local nTamCli := TamSx3("A1_COD")[1]
Local nTamLj := TamSx3("A1_LOJA")[1]


//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Numero inicial do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}
PutSX1(cPerg,"01","Contrato de:","","","mv_ch0","C",15,0,0,"G","","CN9","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Numero final do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"02","Contrato ate:","","","mv_ch1","C",15,0,0,"G","","CN9","","S","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

      
//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Codigo inicial do Cliente"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"03","Cliente de:","","","mv_ch2","C",nTamCli,0,0,"G","","SA1","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor := {"Codigo final do Cliente"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"04","Cliente ate:","","","mv_ch3","C",nTamCli,0,0,"G","","SA1","","S","mv_par04","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor := {"Loja inicial do Cliente"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"05","Loja de:","","","mv_ch4","C",nTamLj,0,0,"G","","","","S","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor := {"Loja inicial do Cliente"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"06","Loja ate:","","","mv_ch5","C",nTamLj,0,0,"G","","","","S","mv_par06","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR07--------------------------------------------------
aHelpPor := {"Mês/Ano de Competência"}
aHelpEng := {"Fecha de referencia para conversión","de los valores entre monedas."}
aHelpSpa := {"Reference date for values","convertion between currency."}
	
PutSX1(cPerg,"07","Mês/Ano Competência","Fecha de referencia","Reference date","mv_ch6","C",7,0,0,"G","","","","S","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetLojas	ºAutor  ³Jackson E. de Deus  º Data ³  28/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna as lojas do cliente					              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetFil	ºAutor  ³Jackson E. de Deus  º Data ³  28/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a filial com base no Estado do cliente              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetFil(cUF)

Local cCodFil := ""
              
If cUF == "SP"
	cCodFil := "01"
ElseIf cUF == "RJ"
	cCodFil := "04"
ElseIf cUF == "PR"
	cCodFil := "11"
ElseIf cUF == "RS"	
	cCodFil := "16"
ElseIf cUF == "BA"
	cCodFil := "05"
ElseIf cUF == "PE"
	cCodFil := "06"
EndIf

Return cCodFil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaItemºAutor  ³Jackson E. de Deus  º Data ³  28/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Aglutina os produtos repetidos                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaItem(aAuxPed)
      
Local aAux := {}   
Local nPos := 0
Local nI,nJ := 0
Local nVal := 0
Local nQuant := 0

// agrupa produto local preco
For nI := 1 To Len(aAuxPed)
	nPos := AScan(aAux, {|x| Alltrim(x[1]) == AllTrim(aAuxPed[nI][1]) .And. x[3] == aAuxPed[nI][3] .And. x[6] == aAuxPed[nI][6] })
	If nPos == 0
		AADD(aAux, aAuxPed[nI] )
	EndIf
Next nI   
                                
For nI := 1 To Len(aAux)
	nQuant := 0
	nVal := 0
	For nJ := 1 To Len(aAuxPed)
		If aAux[nI][1] == aAuxPed[nJ][1] .And. aAux[nI][3] == aAuxPed[nJ][3] .And. aAux[nI][6] == aAuxPed[nJ][6]
			nQuant += aAuxPed[nJ][2]
			nVal += aAuxPed[nJ][8]
		EndIf                 	
	Next nJ                   
	aAux[nI][2] := nQuant
	aAux[nI][8] := nVal
Next nI

aAuxPed := Aclone(aAux)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA05  ºAutor  ³Microsiga           º Data ³  02/24/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function gerapv(nTotal,aAuxPed)
    
Local lOk := .T.
Local aSC5 := {}
Local aSC6 := {}
Local nVol := 0
Local lVldPedido := .F.
Private lMsErroAuto := .F.

While !lVldPedido
	_cNumPed := GetSX8NUM("SC5","C5_NUMERO")
	lVldPedido := VldNumPed(_cNumPed,cFilAnt)
End

Itens(@aSC6,aAuxPed,cLjCli,cCodFil,@nTotal,@nVol)
Cabec(@aSC5,cLjCli,cCodFil,cCodPa,nVol) 

If !_lSimula
	MSExecAuto({|x,y,z|MATA410(x,y,z)},aSC5,aSC6,3)
	dbSelectArea("SC5")
	dbSetOrder(1)
	If !MSSeek( xFilial("SC5") +AvKey(_cNumPed,"C5_NUM") )
		lOk := .F.
		_cNumPed := ""
		If lMsErroAuto
			RollBackSx8()
			MostraErro()
		EndIf
	Else
		ConfirmSX8()
	EndIf
EndIf				

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldNumPed  ºAutor  ³Jackson E. de Deus º Data ³  03/18/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida numero de pedido                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldNumPed(_cNumPed,cFilAnt)

Local lRet := .T.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SC5")
cQuery += " WHERE C5_FILIAL = '"+cFilAnt+"' AND C5_NUM = '"+_cNumPed+"' AND D_E_L_E_T_ = '' "

If Select("TRBC5") > 0
	TRBC5->( dbCloseArea() )
EndIf                       

TcQuery cQuery New Alias "TRBC5"
                               
dbSelectArea("TRBC5")
If !EOF()
	If TRBC5->TOTAL > 0
		lRet := .F.
	EndIf
EndIf

dbCloseArea()

Return lRet