#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTECC08 บAutor  ณJackson E. de Deus   บ Data ณ  24/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de escolha do atendente - Chamado Tecnico      		  บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ18/09/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTTECC08()
                          
Local aArea			:= GetArea()          
Local cTecBkp		:= aCols[n,Ascan(aHeader,{|x| Alltrim(x[2]) == "AB2_XTEC"})]
Local aSize			:= MsAdvSize(Nil,.F.)
Local nTamanho		:= 0.7                                              
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local oVazio		:= LoadBitMap(GetResources(), "BR_PRETO")
Local oWnd
Local oLayer		:= FwLayer():New()  
Local aCabec		:= {"","C๓d. Atendente","Nome Atendente","Tarefas","Supervisor","Gerente"}
Local aColun		:= {5,5,10,5,10,10}
Local nLargWnd		:= aSize[5]
Local nPos1			:= 0
Local nPos2			:= 0
Local cTxt			:= ""
Local nOpca			:= 0
Local aDias			:= {}
Local cProduto		:= M->AB2_CODPRO

Local nCont		 := 0 
Local lEdi1		 := .F.       

Private oList1
Private aLista		:= {}
Private cPatrimo	:= ""
Private cCliente	:= ""
Private cCodCli		:= M->AB1_CODCLI
Private cLoja		:= M->AB1_LOJA
Private oFont		:= TFont():New('Courier new',,-18,.T.)
Private cCadastro	:= "Atendentes"
Private cRet		:= ""
Private cRetNome	:= ""

If cEmpAnt <> "01"
	Return
EndIF

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTTMKA31"
		lEdi1 := .T.
		Exit
	EndIf 
	nCont++
EndDo

If !lEdi1
	cTxt := AllTrim( Posicione("SB1",1,xFilial("SB1")+ AvKey(cProduto,"B1_COD"),"B1_DESC" ) )
	cTxt :=  PadR(cTxt, 60," ")
	nTam := RetTamTex(cTxt, oFont)
	cPatrimo := '<strong><font size=4 color=black>' +cTxt +'</strong>'
	
	cTxt := cCodCli +"/" +cLoja +" " +AllTrim( Posicione("SA1",1,xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLoja,"A1_LOJA"), "A1_NREDUZ" ) )
	cTxt :=  PadR(cTxt, 50," ")
	nTam2 := RetTamTex(cTxt, oFont)
	cCliente := '<strong><font size=4 color=black>' +cTxt +'</strong>'
	
	                               
	// carrega os patrimonios do cliente
	Processa( { || fCarregar(cProduto,cCodCli,cLoja,@aDias) },"Verificando cadastros, aguarde..")
	
	If Len(aLista) == 0
		Aviso("","",{"Ok"})
		Return
	EndIf
	             
	aSize[1] := aSize[1] * nTamanho
	aSize[2] := aSize[2] * nTamanho
	aSize[3] := aSize[3] * nTamanho
	aSize[4] := aSize[4] * nTamanho
	aSize[5] := aSize[5] * nTamanho
	aSize[6] := aSize[6] * nTamanho
	aSize[7] := aSize[7] * nTamanho
	 
	oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],cCadastro,,,.F.,/*nOr(WS_VISIBLE,WS_POPUP)*/,CLR_WHITE,,,,.T.,,,.T. )
	        
	  	oPanel := tPanel():New(0,0,"",oWnd,,,,CLR_BLACK,CLR_WHITE,0,040)
		oPanel:align := CONTROL_ALIGN_TOP
		
		oPanel3 := tPanel():New(0,0,"",oWnd,,,,CLR_BLACK,CLR_WHITE,0,020)
		oPanel3:align := CONTROL_ALIGN_BOTTOM
	
		oLayer:Init(oWnd,.F.)
		oLayer:addCollumn('COLUNA1',100,.F.)
	  	oLayer:addWindow("COLUNA1","WIN_1","Atendentes",100,.F.,.T.,{||} )	
	  	//oLayer:addWindow("COLUNA1","WIN_2","",70,.F.,.T.,{||} )	
		oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
		//oPnl2 := oLayer:GetWinPanel("COLUNA1","WIN_2")	
		                           
		nPos1 := (aSize[5]-nTam)/2
		nPos2 := (aSize[5]-nTam2)/2
		oSay1	:= TSay():New( 010,150,{ || cPatrimo },oPanel,,,.F.,.F.,.F.,.T.,,,300,008,,,,,,.T.)	// patrimonio
		oSay2	:= TSay():New( 020,150,{ || cCliente },oPanel,,,.F.,.F.,.F.,.T.,,,300,008,,,,,,.T.)	// cliente + loja + nome fantasia
		
	    // Atendentes
	    oList := TCBrowse():New(0,0,0,0,,aCabec,aColun,oPnl,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.)
		oList:SetArray(aLista)
		oList:bLine := { ||{ IIF( aLista[oList:nAt,01] == Nil,oVazio, IIF(aLista[oList:nAt,01],oOk,oNo) ),;	// status
							 aLista[oList:nAt,02],;					// cod tecnico
							 aLista[oList:nAt,03],;					// nome tecnico
							 aLista[oList:nAt,04],;					// tarefas
							 aLista[oList:nAt,05],;					// supervisor
							 aLista[oList:nAt,06] }}				// gerente
							 
		oList:bLDblClick := { || DblClk(),oList:DrawSelect() }  			
		oList:Align := CONTROL_ALIGN_ALLCLIENT
		
		// botoes rodape
		oBtn := TBtnBmp2():New( 0, 0, 40, 40, 'S4SB014N', , , ,{ || fCal( aLista[oList:nAt][7] ) } , oPanel3, "Calendแrio" , ,)
		oBtn2 := TBtnBmp2():New( 0, 0, 40, 40, 'OK'	, , , ,{ || oWnd:End(nOpca := 1) } , oPanel3, "Confirmar" , ,)
		oBtn3 := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oWnd:End() } , oPanel3, "Cancelar" , ,)
		
		oBtn3:Align := CONTROL_ALIGN_RIGHT
		oBtn2:Align := CONTROL_ALIGN_RIGHT
		oBtn:Align := CONTROL_ALIGN_RIGHT
	
	oWnd:Activate(,,,.T.)
	
	If nOpca == 0
		cRet := ""
	EndIf    
	
	If Empty(cRet) .And. !Empty(cTecBkp)
		cRet := cTecBkp
	EndIf
EndIf  
 
RestArea(aArea)

Return cRet     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDblClk  บAutor  ณJackson E. de Deus  	 บ Data ณ  24/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo executada no duplo clique da linha, marca a linha   บฑฑ
ฑฑบ          ณ como selecionada ou nใo-selecionada.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 		                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DblClk()

If aLista[oList:nAt][1] <> Nil
	If aLista[oList:nAt][1]         
		aLista[oList:nAt][1] := .F.
		cRet := ""
		cRetNome := ""		
	Else     
		If !Empty(cRet)
			nPos := Ascan( aLista, { |x| x[2] == cRet } )
			If nPos > 0
				aLista[nPos][1] := .F.
				oList:Refresh()
			EndIf	
		EndIf
		aLista[oList:nAt][1] := .T.                                   
		cRet := aLista[oList:nAt][2]
		cRetNome := aLista[oList:nAt][3]
	EndIf
EndIf                              
  
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCarregarบAutor  ณJackson E. de Deus   บ Data ณ  24/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os dados da tela.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCarregar(cProduto,cCodcli,cLoja)

Local cQuery := ""
Local cMensal := SubStr( DtoS(dDatabase),1,6 )
Local aAux := {}
Local aAux2 := {}
Local aSupGer := {}
Local aServs := {}
Local aAbast := {}
Local nI,nJ 

cQuery := "SELECT DISTINCT ZE_MENSAL, ZE_TIPOPLA, ZE_ROTA, AA1_CODTEC, AA1_NOMTEC, AA1_XSUPER, AA1_XGEREN FROM " +RetSqlName("SZE") +" SZE "
cQuery += "INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
cQuery += "N1_CHAPA = ZE_CHAPA AND SN1.D_E_L_E_T_ = '' "
cQuery += " LEFT JOIN " +RetSqlNAme("AA1") +" AA1 ON "
cQuery += " AA1.AA1_LOCAL = SZE.ZE_ROTA "
cQuery += " AND AA1.D_E_L_E_T_ = '' "
cQuery += " WHERE ZE_MENSAL LIKE '"+cMensal+"%' AND N1_PRODUTO = '"+cProduto+"' AND SZE.D_E_L_E_T_ = '' "
cQuery += " AND ZE_CLIENTE = '"+cCodcli+"' AND ZE_LOJA = '"+cLoja+"' AND ZE_FILIAL = '"+xFilial("SZE")+"' "

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf
                         
TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	AADD( aAux, { TRB->ZE_MENSAL, TRB->ZE_TIPOPLA, TRB->ZE_ROTA, TRB->AA1_CODTEC, TRB->AA1_NOMTEC, TRB->AA1_XSUPER, TRB->AA1_XGEREN,;
				Posicione("AA1",1,xFilial("AA1")+TRB->AA1_XSUPER,"AA1_NOMTEC"), Posicione("AA1",1,xFilial("AA1")+TRB->AA1_XGEREN,"AA1_NOMTEC" ) } )            
    
    // Separa os supervisores e gerentes
	If Ascan( aSupGer, { |x| x[1] == TRB->AA1_XSUPER } ) == 0
		AADD( aSupGer, { TRB->AA1_XSUPER, Posicione("AA1",1,xFilial("AA1")+TRB->AA1_XSUPER, "AA1_NOMTEC") } )
	EndIf                                                  
	
	If Ascan( aSupGer, { |x| x[1] == TRB->AA1_XGEREN } ) == 0
		AADD( aSupGer, { TRB->AA1_XGEREN, Posicione("AA1",1,xFilial("AA1")+TRB->AA1_XGEREN, "AA1_NOMTEC") } )
	EndIf
					
	dbSkip()
End

cQuery := "SELECT AA1_CODTEC, AA1_NOMTEC, AA1_XSUPER, AA1_XGEREN FROM " +RetSqlName("AA1") + " AA1 "
cQuery += " INNER JOIN " +RetSqlName("AA2") +" AA2 ON AA1_CODTEC = AA2_CODTEC AND AA2.D_E_L_E_T_ = '' "
cQuery += " WHERE AA1.D_E_L_E_T_ = '' AND AA1_LOCAL = '' "
cQuery += " ORDER BY AA1_XGEREN DESC "

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf                    

TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	If Ascan( aAux, { |x| x[4] == TRB->AA1_CODTEC } ) == 0
		AADD( aAux2, { TRB->AA1_CODTEC, TRB->AA1_NOMTEC, Posicione("AA1",1,xFilial("AA1")+TRB->AA1_XSUPER, "AA1_NOMTEC"), Posicione("AA1",1,xFilial("AA1")+TRB->AA1_XGEREN, "AA1_NOMTEC" )} )		
	EndIf
	
	dbSkip()
End

// Tipos de Servico
DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+"ZW")
  	While !EOF() .AND. SX5->X5_TABELA == "ZW"
		Aadd( aServs, Alltrim(SX5->X5_DESCRI) )
		Dbskip()
	EndDo
EndIf

// ABASTECEDORES/ROTA
For nI := 1 To Len(aAux)
	aAbast := {}
	cTarefas := ""
	cCodTec := aAux[nI][4]
	For nJ := 1 To Len(aAux)
		If aAux[nJ][4] == cCodTec
			If Ascan( aAbast, { |x| x == aServs[ Val(SubStr( aAux[nJ][2],1,1)) ] } ) == 0
				AADD( aAbast, aServs[ Val(SubStr( aAux[nJ][2],1,1)) ] )                      
			EndIf
		EndIf
	Next nJ
	
	For nJ := 1 To Len(aAbast)
		cTarefas += aAbast[nJ]
		If nJ <> Len(aAbast)
			cTarefas += "/"
		EndIf
	Next nJ

	AADD( aLista, { .F., aAux[nI][4], aAux[nI][5], cTarefas, aAux[nI][8], aAux[nI][9], AllTrim(aAux[nI][1]) } )

Next nI

// SUPERVISORES/GERENTES DOS ABASTECEDORES      
For nI := 1 To Len(aSupGer)
	cTarefas := ""
	AADD( aLista, { .F., aSupGer[nI][1], aSupGer[nI][2], "", "", "", "" } )
Next nI

If Len(aAux2) > 0
	AADD( aLista, { Nil, "", "Tecnicos", "", "", "", "" } )
EndIf

// TECNICOS
For nI := 1 To Len(aAux2)
	AADD( aLista, { .F., aAux2[nI][1], aAux2[nI][2], "", aAux2[nI][3], aAux2[nI][4], "" } )
Next nI


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTamTexบAutor  ณJackson E. de Deus   บ Data ณ  24/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o tamanho do texto em pixels.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetTamTex(cTexto, oFont)

Local nTamanho := 0
Local oFontSize:= FWFontSize():new() 

nTamanho := oFontSize:getTextWidth( cTexto, oFont:Name, oFont:nWidth, oFont:Bold, oFont:Italic )
nTamanho := Round(nTamanho, 0)
	
Return nTamanho

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCal     บAutor  ณJackson E. de Deus   บ Data ณ  24/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calendario                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCal(cMensal)

Local oDlg
Local oLayerC		:= FwLayer():New()
Local nCor := "#000000"
Local nCorMark := "#FFA001"
Local nCorFer := "#111AAA"
Local nCorDSem := "#696969"
Local nCorDMes := "#B03060"
Local aDiasFer := {}
Local lEditable := .F.
Private aDias := {}
Private oCalend
Default cMensal := ""

If Empty(cMensal)
	Aviso("","Nใo hแ registros no plano de trabalho para esse t้cnico.",{"Ok"})
	Return
EndIf

oDlg := MSDialog():New( 0,0,440,480,"Dias de trabalho",,,.F.,/*nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)*/,CLR_WHITE,,,,.T.,,,.T. )    

	oLayerC:Init(oDlg,.F.)
	oLayerC:addCollumn('COLUNA1',100,.F.)
  	oLayerC:addWindow("COLUNA1","WIN_1","",100,.F.,.T.,{||} )	
  	oPnl := oLayerC:GetWinPanel("COLUNA1","WIN_1")
	
	oCalend := Calend():New(10,10,oPnl,dDatabase,nCor,nCorMark,nCorFer,nCorDSem,nCorDMes,lEditable)
	oCalend:Activate()
	
	LoadCal(cMensal)
	
	oPanel := tPanel():New(0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,020)
	oPanel:align := CONTROL_ALIGN_BOTTOM
	
	oButton := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel, "Cancelar" , ,)
	oButton:Align := CONTROL_ALIGN_RIGHT
	     
oDlg:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadCal  บAutor  ณJackson E. de Deus   บ Data ณ  24/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os dias do calendario que possuem atendimentos.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadCal(cMensal)
     
Local nI
Local nPosd := 0
Local cDia := ""
Local dDiaMes

cMensal := SubStr(cMensal,9)

For nI := FirstDay(dDatabase) To Lastday(dDatabase)
	cDia := ""                             
	nPosd++
	
	dDiaMes := nI 
	cDia := SubStr(cMensal,nPosd,1) 	
	If cDia $ "1|F"
		AADD( aDias, dDiaMes )
	EndIf	
Next nI		

For nI := 1 To Len(aDias)
	oCalend:ADDMark(aDias[nI]) 
Next nI

Return