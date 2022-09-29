#include "protheus.ch"
#include "topconn.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTA16  ºAutor  ³Jackson E. de Deus  º Data ³  26/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Patrimônios da planilha 	          º±±
±±º          ³															  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³26/12/13³01.00 |Criacao                                 ³±±
±±³Jackson       ³08/10/14³01.01 |Adicao de coluna Loja e visualizacao    ³±±
±±								  do historico de patrimonios			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTCNTA16()

Local aDimension	:= MsAdvSize()
Local oDlg
Local bTudoOk		:= {|| oDlg:End()}
Local bCancel		:= {|| oDlg:End()}
Local oLayer		:= FWLayer():new()
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local oPnlGrid1
Local oPnlGrid2
Local oPnlRodape
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aRet			:= {}
Local nTamanho		:= 100
Local aHead			:= { "Patrimônio", "Descrição", "Valor", "Data instalação", "OMM", "Loja" }
Local aTam			:= { 20,50,20,20,20,10 }
Local aHead2		:= { "Patrimônio", "Descrição", "Valor", "Tipo", "Data", "OMM" }
Local aTam2			:= { 20,50,20,20,20,10 }
Local nValTotal		:= 0
Local nCont			:= 0    
Local cNumChapa		:= space(6) 
Private oList
Private oList2
Private aPatrim		:= {}          
Private aProRata	:= {}

Private cContrato	:= ""
Private	cPlanilha	:= ""
Private cpCliente	:= ""
Private cpLoja		:= ""

If cEmpAnt == "01"
	
	If !ConPad1(,,,"CNA",,,.F.)
		Return
	Else
		cContrato	:= CNA->CNA_CONTRA 
		cPlanilha	:= CNA->CNA_NUMERO
		cpCliente	:= CNA->CNA_CLIENT
		//cpLoja		:= CNA->CNA_LOJACL
	EndIf  
	
	
	Carregar(@nValTotal,@nCont)
	
	If nTamanho <> 100
		aDimension[1] := aDimension[1] * nTamanho
		aDimension[2] := aDimension[2] * nTamanho
		aDimension[3] := aDimension[3] * nTamanho
		aDimension[4] := aDimension[4] * nTamanho
		aDimension[5] := aDimension[5] * nTamanho
		aDimension[6] := aDimension[6] * nTamanho
		aDimension[7] := aDimension[7] * nTamanho
	EndIf
	
	
	oDlg := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Patrimônios na planilha",,,.F.,,,,,,.T.,,,.T. )	
	    
		oLayer:init(oDlg,.T.)
	
		oLayer:addLine("LN_CAB",15,.F.)
		oLayer:addLine("LN_GRID1",80,.F.)
		//oLayer:addLine("LN_GRID2",40,.F.)
		
		oLayer:addCollumn("COL_CAB",100,.f.,"LN_CAB")
		oLayer:addCollumn("COL_GRID1",50,.f.,"LN_GRID1")
		oLayer:addCollumn("COL_GRID2",50,.f.,"LN_GRID1")
		
		oLayer:addWindow("COL_CAB","WIN_CAB","Total",100,.t.,.F.,{||},"LN_CAB")
		oLayer:addWindow("COL_GRID1","WIN_GRID1","Patrimônios",100,.t.,.F.,{||},"LN_GRID1")
		oLayer:addWindow("COL_GRID2","WIN_GRID2","Pro Rata",100,.t.,.F.,{||},"LN_GRID1")	
		
		oPnlCab := oLayer:GetWinPanel("COL_CAB","WIN_CAB","LN_CAB")
		oPnlGrid1 := oLayer:GetWinPanel("COL_GRID1","WIN_GRID1","LN_GRID1")
		oPnlGrid2 := oLayer:GetWinPanel("COL_GRID2","WIN_GRID2","LN_GRID1")
			    
		oPnlCab:FreeChildren()
		oPnlGrid1:FreeChildren()
		oPnlGrid2:FreeChildren()
		
		// Cabecalho                                                                                                                                               
		oSay1 := TSay():New(0,0,{ || "Contrato: " +cContrato },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)    
		oSay2 := TSay():New(0,0,{ || "Planilha: " +cPlanilha },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)    
		oSay3 := TSay():New(0,0,{ || "Total de patrimônios instalados: " +cvaltochar(nCont) },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,160,010)    
		oSay4 := TSay():New(0,0,{ || "Valor total: R$" +AllTrim( Transform(nValTotal,PesqPict("CNA","CNA_VLTOT")) ) },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)    
		oSay1:Align := CONTROL_ALIGN_LEFT
		oSay2:Align := CONTROL_ALIGN_LEFT
		oSay3:Align := CONTROL_ALIGN_LEFT
		oSay4:Align := CONTROL_ALIGN_LEFT
		
		// tcbrowse patrimonios
		oList := TCBrowse():New(0,0,0,0,,aHead,aTam,oPnlGrid1,,,,/*bchange*/,{ || OMM( cpCliente,aPatrim[oList:nAt,01] ) },,,,,,,.F.,,.T.,{ || Len(aPatrim) > 0},.F.,,.T.,.T.,)
		oList:Align	:= CONTROL_ALIGN_ALLCLIENT
		oList:SetArray(aPatrim)
		oList:bLine := { || { aPatrim[oList:nAt,01],; 
							 aPatrim[oList:nAt,02],;					
							 Transform(aPatrim[oList:nAt,03],PesqPict("SZQ","ZQ_VALOR") ),;
							 aPatrim[oList:nAt,04],;
							 aPatrim[oList:nAt,05],;
							 aPatrim[oList:nAt,06] }}
							 
		oList:nScrollType := 1 //SCROLL VRC 
	 
		oPanel := tPanel():New(0,0,"",oPnlGrid1,,,,,,100,020)
		oPanel:align := CONTROL_ALIGN_BOTTOM
		
		@ 010,004 MSGET cNumChapa	PICTURE "@!"		OF oPanel SIZE 040,008 PIXEL						                                                                                          
		oSBtn3 := TButton():New( 010,050,"Pesquisar",oPanel,{ || IF(!empty(cNumChapa),fPosPatr(cNumChapa),)  },30,10,,,,.T.,,"",,,,.F.)
		
		// tcbrowse pro rata
		oList2 := TCBrowse():New(0,0,0,0,,aHead2,aTam2,oPnlGrid2,,,,/*bchange*/,/*{ || Marca() }*/,,,,,,,.F.,,.T.,{ || Len(aProRata) > 0},.F.,,.T.,.T.,)
		oList2:Align	:= CONTROL_ALIGN_ALLCLIENT
		oList2:SetArray(aProRata)
		oList2:bLine := { || { aProRata[oList2:nAt,01],; 
								 aProRata[oList2:nAt,02],;					
								 Transform(aProRata[oList2:nAt,03],PesqPict("SZQ","ZQ_VALOR") ),;
								 IIF(aProRata[oList2:nAt,01]<>"",IIF(aProRata[oList2:nAt,04]=="I","Instalação","Remoção"),"" ) ,;
								 aProRata[oList2:nAt,05],;
								 aProRata[oList2:nAt,06] }}	 
		oList2:nScrollType := 1 //SCROLL VRC 				 					                                              
	     
	 
	 	oPanel2 := tPanel():New(0,0,"",oPnlGrid2,,,,,,100,020)
		oPanel2:align := CONTROL_ALIGN_BOTTOM
		
		@ 010,004 MSGET cNumChapa	PICTURE "@!"		OF oPanel2 SIZE 040,008 PIXEL						                                                                                          
		oSBtn3 := TButton():New( 010,050,"Pesquisar",oPanel2,{ || IF(!empty(cNumChapa),fPosPR(cNumChapa),)  },30,10,,,,.T.,,"",,,,.F.)
		
	oDlg:Activate(,,,.T.,,,EnchoiceBar(oDlg,bTudoOk,bCancel)) 
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Carregar Autor  ³Jackson E. de Deus    º Data ³  26/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os patrimonios             						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Carregar(nValTotal,nCont)

Local aArea := GetArea()
Local cQuery := ""
Local cProRata := ""
Local nI
Local nJ
Local aAux := {}
Local aAux2 := {}     
Local aAuxRem := {}

cQuery := "SELECT ZQ_PATRIM, N1_DESCRIC, ZQ_VALOR, ZQ_DATAINS, ZQ_DATAREM, ZQ_LOJA  FROM " +RetSqlName("SZQ") +" SZQ "

cQuery += "INNER JOIN " +RetSqlName("CN9") +" CN9 ON "
cQuery += "CN9.CN9_NUMERO = SZQ.ZQ_CONTRA "
cQuery += "AND CN9.D_E_L_E_T_ = '' "

cQuery += "INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
cQuery += "SN1.N1_CHAPA = SZQ.ZQ_PATRIM "
cQuery += "AND SN1.D_E_L_E_T_ = '' "
/*
cQuery += "LEFT JOIN " +RetSqlName("SZD") +" SZD ON "
cQuery += "SZD.ZD_PATRIMO = SZQ.ZQ_PATRIM "
cQuery += "AND SZD.ZD_DATAINS = SZQ.ZQ_DATAINS "
cQuery += "AND SZD.ZD_CLIENTE = CN9.CN9_CLIENT "
cQuery += "AND SZD.D_E_L_E_T_ = '' "
*/
cQuery += "WHERE ZQ_CONTRA = '"+cContrato+"' "
cQuery += "AND ZQ_PLAN = '"+cPlanilha+"' "
cQuery += "AND ZQ_DATAREM = '' "
cQuery += "AND SZQ.D_E_L_E_T_ = '' "
cQuery += "ORDER BY ZQ_DATAINS DESC "

If Select("PATR") > 0
	PATR->( dbCloseArea() )
EndIf                     

TcQuery cQuery New Alias "PATR"

dbSelectArea("PATR")
While !EOF()
	If AllTrim(PATR->ZQ_DATAREM) == ""
		AADD(aPatrim, { PATR->ZQ_PATRIM, PATR->N1_DESCRIC, PATR->ZQ_VALOR, DtoC(stod(PATR->ZQ_DATAINS)) , "", PATR->ZQ_LOJA } )
	Else
		AADD(aAuxRem, { PATR->ZQ_PATRIM, PATR->N1_DESCRIC, PATR->ZQ_VALOR, DtoC(stod(PATR->ZQ_DATAREM)) , "" } )
	EndIf                                                                                                                     
	dbSkip()
End

dbCloseArea()
                     

nCont := Len(aPatrim)

If Len(aPatrim) == 0
	AADD(aPatrim, { "", "", 0, "  /  /  ", "", "" } )	
EndIf


For nI := 1 To Len(aPatrim)
	nValTotal += aPatrim[nI][3]
Next nI



// ProRata
dbSelectArea("CNB")
dbSetOrder(1)
If msSeek(xFilial("CNB") +cContrato +AvKey("","CNA_REVISA") +cPlanilha)
	cProRata := AllTrim(CNB->CNB_XPRORA)
	If AllTrim(cProRata) <> ""
		aAux := StrToKarr(cProRata,"|")
		For nI := 1 To Len(aAux)
			aAux2 := StrtoKarr(aAux[nI],",")
			If Len(aAux2) == 4
				AADD(aProRata, {aAux2[2],;														// Patrimonio
								 Posicione("SN1",2,xFilial("SN1")+aAux2[2],"N1_DESCRIC"),;		// Descricao
								 Val(aAux2[3]),;												// Valor
								 aAux2[1],;														// Tipo I|R				
								 aAux2[4],;														// Data
								 ""  } )														// OMM remocao
		
			EndIf
		Next nI
	EndIf
EndIf

For nI := 1 To Len(aProRata)
	If aProRata[nI][4] == "R"
		For nJ := 1 To Len(aAuxRem)
			If AllTrim(aAuxRem[nJ][1]) == AllTrim(aProRata[nI][1])
				aProRata[nI][6] := aAuxRem[nJ][5] 
			EndIf
		Next nJ                        
	EndIf
Next nI          


aSort( aProRata,,,{ |x,y| ctod(x[5]) > ctod(y[5]) } )


If Len(aProRata) == 0
	AADD(aProRata, {"",;		// Patrimonio
					"",;		// Descricao
					 0,;		// Valor
					 "",;		// Tipo I|R				
					 "  /  /  ",;	// Data
					 "" } )	// OMM remocao
EndIf


RestArea(aArea)

Return                                                                                        

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPosPatr Autor  ³Jackson E. de Deus    º Data ³  26/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa patrimonio nos patrimonios instalados             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPosPatr(cNumChapa)
                                    
Local nPos := 0


nPos := Ascan(aPatrim, {|x| AllTrim(x[1]) == AllTrim(cNumChapa) } )
If nPos > 0
	oList:GoPosition(nPos)
EndIf

oList:Refresh()      

Return

         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPosPR ºAutor  ³Jackson E. de Deus     º Data ³  26/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pesquisa patrimonio na ProRata				              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPosPR(cNumChapa)
                                    
Local nPos := 0


nPos := Ascan(aProRata, {|x| AllTrim(x[1]) == AllTrim(cNumChapa) } )
If nPos > 0
	oList2:GoPosition(nPos)
EndIf

oList:Refresh()      

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OMM  ºAutor  ³Jackson E. de Deus       º Data ³  08/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de historico de patrimonios no cliente                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OMM(cCliente,cPatrim)

Local cQuery := ""
Local aSize	:= MsAdvSize()
Local oDlg2
Local aOMM := {}
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Private oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oNo			:= LoadBitMap(GetResources(), "BR_PRETO")

cQuery := "SELECT * FROM " +RetSqlName("SZD") +" WHERE ZD_CLIENTE = '"+cCliente+"' AND ZD_PATRIMO = '"+cPatrim+"' AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY ZD_DATAINS DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")

While !EOF()
	AADD( aOMM, { IIF(TRB->ZD_IDSTATU=="0",.F.,.T.), TRB->ZD_LOJA, DTOC(STOD(TRB->ZD_DATAINS)), TRB->ZD_HORAINS, TRB->ZD_NROOMM, DTOC(STOD(TRB->ZD_DATAREM)), TRB->ZD_HORAREM, TRB->ZD_NROOMMR   } )
	dbSkip()
End

dbCloseArea()



aSize[1] := aSize[1] * 0.40
aSize[2] := aSize[2] * 0.40
aSize[3] := aSize[3] * 0.40
aSize[4] := aSize[4] * 0.40
aSize[5] := aSize[5] * 0.40
aSize[6] := aSize[6] * 0.40
aSize[7] := aSize[7] * 0.40


//Monta a janela
oDlg2	:= MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Histórico do Patrimônio",,,.F.,,,,,,.T.,,,.T. )	
	
	oSay2 := TSay():New( 10,05,{|| "Histórico do patrimônio no cliente:" },oDlg2,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)    
	
	oList2 := TCBrowse():New(0,0,0,0,,{" ","Loja","Data Instalação","Hora","OMM Inst.", "Data Remoção", "Hora","OMM Rem."},{05,10,10,15,10,15,10,10},oDlg2,,,,/*{|| troca de linha*/,/*{|| duplo clique }*/,/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aOMM) > 0},.F.,,.T.,.T.,)	
	oList2:nScrollType := 1 //SCROLL VRC
	oList2:SetArray(aOMM)                                                      
	
	// Monta a linha a ser exibida no Browse
	oList2:bLine := {||{	IIF(aOMM[oList2:nAt,01],oOK,oNo),;
							aOMM[oList2:nAt,02],;
							aOMM[oList2:nAt,03],;
							aOMM[oList2:nAt,04],;
							aOMM[oList2:nAt,05],;
							aOMM[oList2:nAt,06],;
							aOMM[oList2:nAt,07],;
							aOMM[oList2:nAt,08]}}
							
	oList2:Align := CONTROL_ALIGN_ALLCLIENT								
oDlg2:Activate(,,,.T.)
      

Return