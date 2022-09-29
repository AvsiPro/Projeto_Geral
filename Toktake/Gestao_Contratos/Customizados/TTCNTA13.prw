#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTA13  บAutor  ณJackson E. de Deus  บ Data ณ  22/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a inclusao/remocao de patrimonio na planilha.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCNTA13()

Local lRet		 	:= .F.
Local aDimension	:= MsAdvSize()
Local oDlg  
Local bTudoOk		:= { || Processa( { || Gravar() }, "Alterando planilha, aguarde.." ) }
Local bCancel		:= { || oDlg:End() }
Local oLayer		:= FWLayer():new()
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.) 
Local aButtons		:= { {"HISTORIC", { || Patrim(2) }, "Maquinas", "Maquinas" , {|| .T.} } }
Local oPnlGrid1
Local oPnlGrid2
Local oPnlRodape
Local nOpc			:= 3
Local aAlter		:= {"ZQ_PATRIM","ZQ_LOJA","ZQ_VALOR","ZQ_DATAINS","T_PRORA"}
Local aTipo			:= {"Inclusใo","Remo็ใo"}
Local aProRata		:= {"Sim","Nใo"}
Local aPergs		:= {}
Local aRet			:= {}
Local aPatrim		:= {}
Local nTipo			:= 1
Local nVlProRa		:= 0
Local cUsrPerm		:= If(cEmpAnt == "01",SuperGetMv("MV_XGCT001",.T.,"ADMIN"),"") 

Private cContrato	:= ""//CNA->CNA_CONTRA 
Private cPlanilha	:= ""//CNA->CNA_NUMERO
Private cCombo		:= aTipo[1]
Private oMsGD
Private aHeader		:= {}
Private aCols		:= {}
Private cpCliente	:= ""//CNA->CNA_CLIENT
Private cpLoja		:= ""//CNA->CNA_LOJACL	// alterar para buscar a loja da OMM para gravacao na SZQ
Private aPatIns		:= {}
Private aPatRem		:= {}

If cEmpAnt == "01"
	
	If !cUserName $ cUsrPerm
		Aviso("TTCNTA13","Voc๊ nใo tem permissใo de acesso." +CRLF +"Parโmetro: MV_XGCT001",{"Ok"})
		Return
	EndIf
	
	
	If !ConPad1(,,,"CNA",,,.F.)
		Return
	Else
		cContrato	:= CNA->CNA_CONTRA 
		cPlanilha	:= CNA->CNA_NUMERO
		cpCliente	:= CNA->CNA_CLIENT
		//cpLoja		:= CNA->CNA_LOJACL
	EndIf  
	
	      
	LoadHead()
	LoadCols()
	
	oDlg := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Inclusใo/Exclusใo de patrim๔nios",,,.F.,,,,,,.T.,,,.T. )	
	    
		oLayer:init(oDlg,.T.)
		oLayer:addLine("LN_CAB",20,.F.)
		oLayer:addLine("LN_GRID1",70,.F.)
		oLayer:addCollumn("COL_CAB",100,.f.,"LN_CAB")
		oLayer:addCollumn("COL_GRID1",100,.f.,"LN_GRID1")
		oLayer:addWindow("COL_CAB","WIN_CAB","Contrato",100,.t.,.F.,{||},"LN_CAB")
		oLayer:addWindow("COL_GRID1","WIN_GRID1","Patrim๔nios",100,.t.,.F.,{||},"LN_GRID1")	
		oPnlCab := oLayer:GetWinPanel("COL_CAB","WIN_CAB","LN_CAB")
		oPnlGrid1 := oLayer:GetWinPanel("COL_GRID1","WIN_GRID1","LN_GRID1")
		oPnlCab:FreeChildren()
		oPnlGrid1:FreeChildren()                                                                                                             
		
	 	oSay1 := TSay():New(0,0,{ || "Contrato: " +AllTrim(cContrato) },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)     
	   	oSay2 := TSay():New(0,0,{ || "Planilha: " +AllTrim(cPlanilha) },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)     
	   	oSay1:Align := CONTROL_ALIGN_LEFT
	   	oSay2:Align := CONTROL_ALIGN_LEFT
	   	
		oSay3 := TSay():New(0,0,{ || "Tipo de ajuste: " },oPnlCab,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,010)
		oSay3:Align := CONTROL_ALIGN_LEFT
	   	oCBox1	:= TComboBox():New( 0,0,{|u|if(PCount()>0,cCombo:=u,cCombo)},aTipo,048,010,oPnlCab,,{ || Patrim() },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo)
	   	oCBox1:Align := CONTROL_ALIGN_LEFT
	   	
	   	Patrim()
	   	
		oMsGD := MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_DELETE+GD_UPDATE,'StaticCall(TTCNTA13,LinOk)','AllwaysTrue()','',aAlter,0,99,'U_TTCNTA19','','AllwaysTrue()',oPnlGrid1,aHeader,aCols, { || oMsGd:aCols := acols })
		oMsGD:Refresh(.T.)
		oMsGD:ForceRefresh(.T.)
		
		oMsGD:oBRowse:Align	:= CONTROL_ALIGN_ALLCLIENT
		
		//EnchoiceBar(oDlg,bTudoOk,bCancel,@aButtons)
		EnchoiceBar(oDlg,bTudoOk,bCancel,,@aButtons )
	oDlg:Activate(,,,.T.)
EndIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPatrim  บAutor  ณJackson E. de Deus    บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna patrimonios validos para uso                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Patrim(nOpc)

Local cSql := ""
Local aMaq := {} 
Local nLin := 0
Local lTem := .F.
Local nCnt := 0          
Default nOpc := 1

// instalados via OMM porem fora da planilha
If oCBOX1:NAT == 1
	aPatIns := {}
	cSql := "SELECT ZD_PATRIMO, N1_DESCRIC,ZD_LOJA,ZD_DATAINS FROM " +RetSqlName("SN1") +" SN1 "
	cSql += " INNER JOIN " +RetSqlName("SZD") +" SZD ON "
	cSql += " N1_CHAPA = ZD_PATRIMO AND N1_XCLIENT = ZD_CLIENTE AND N1_XLOJA = ZD_LOJA "
	cSql += " WHERE N1_XSTATTT = '3' AND N1_XCLIENT = '"+cpCliente+"' AND SN1.D_E_L_E_T_ = '' "
	cSql += " AND ZD_IDSTATU = '1' AND ZD_DATAREM = '' "
	cSql += " AND ZD_PATRIMO NOT IN (
	cSql += " 	SELECT ZQ_PATRIM FROM " +RetSqlName("SZQ")
	cSql += "		WHERE ZQ_CONTRA = '"+cContrato+"' AND ZQ_PLAN = '"+cPlanilha+"' AND ZQ_PATRIM = ZD_PATRIMO "
	cSql += " 		AND ZQ_CLIENTE = ZD_CLIENTE "	//AND ZD_LOJA = ZD_LOJA "
	cSql += " 		AND ZQ_DATAREM = '' AND D_E_L_E_T_ = '' "
	cSql += " ) "
    
	cSql += " ORDER BY ZD_PATRIMO "
// removidos via OMM porem ainda na planilha
Else
	aPatRem := {}
	cSql := "SELECT ZD_PATRIMO,N1_DESCRIC,ZD_LOJA, ZD_DATAREM FROM " +RetSqlName("SZD") +" SZD "
	cSql += " INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
	cSql += " N1_CHAPA = ZD_PATRIMO "
	cSql += " WHERE ZD_CLIENTE = '"+cpCliente+"' AND SZD.D_E_L_E_T_ = '' "
	cSql += " AND ZD_IDSTATU = '0' AND ZD_DATAREM <> '' "
	cSql += " 	AND ZD_PATRIMO NOT IN ( "
	cSql += " 	SELECT ZD_PATRIMO FROM " +RetSqlName("SZD") +" SZD2 "
	cSql += "		WHERE SZD2.ZD_PATRIMO = SZD.ZD_PATRIMO AND SZD2.ZD_CLIENTE = SZD.ZD_CLIENTE AND ZD_LOJA = ZD_LOJA "
	cSql += " 		AND ZD_IDSTATU = '1' AND ZD_DATAREM = '' AND D_E_L_E_T_ = '' "
	cSql += " )
	
	cSql += " ORDER BY ZD_PATRIMO "
EndIf	

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRB",.F.,.T.)
                        
dbSelectArea("TRB")
While !EOF()
	If oCBOX1:NAT == 1
		AADD( aPatIns, { TRB->ZD_PATRIMO, TRB->N1_DESCRIC, TRB->ZD_LOJA, STOD(TRB->ZD_DATAINS) } )
		AADD( aMaq, { TRB->ZD_PATRIMO, TRB->N1_DESCRIC,TRB->ZD_LOJA, STOD(TRB->ZD_DATAINS) } )
	Else
		nTot := 0
		cSql := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZQ")
		cSql += " WHERE ZQ_CONTRA = '"+cContrato+"' AND ZQ_PLAN = '"+cPlanilha+"' AND ZQ_PATRIM = '"+TRB->ZD_PATRIMO+"' "
		cSql += " 	AND ZQ_CLIENTE = '"+cpCliente+"' AND ZQ_LOJA = '"+TRB->ZD_LOJA+"' "
		cSql += " 	AND ZQ_DATAREM = '' AND D_E_L_E_T_ = '' "
		If Select("TRB2") > 0
			TRB2->(dbCloseArea())
		EndIf

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRB2",.F.,.T.)
		dbSelectArea("TRB2")
		If TRB2->(!EOF())
			nTot := TRB2->TOTAL
		EndIf
		TRB2->(dbCloseArea())
		
		dbSelectArea("TRB")
		If nTot > 0
			AADD( aPatRem, { TRB->ZD_PATRIMO, TRB->N1_DESCRIC,TRB->ZD_LOJA, STOD(TRB->ZD_DATAREM) } ) 
			AADD( aMaq, { TRB->ZD_PATRIMO, TRB->N1_DESCRIC,TRB->ZD_LOJA, STOD(TRB->ZD_DATAREM) } )
		EndIf
	EndIf
	
	dbSkip()
End

TRB->(dbCloseArea())


If nOpc == 2
	aCols := {}
	For nI := 1 To Len(aMaq)
		lTem := .F.
		For nJ := 1 To Len(oMsGD:aCols)
			If AllTrim(oMsGD:aCols[nJ][1]) == AllTrim(aMaq[nI][1])
				lTem := .T.
			EndIf
		Next nJ
		If !lTem
			AAdd(aCols, Array(Len(aHeader)+1))
			nLin := Len(aCols) 
			aCols[nLin][1] := aMaq[nI][1]
			aCols[nLin][2] := aMaq[nI][2]
			aCols[nLin][3] := aMaq[nI][3]
			aCols[nLin][4] := 0
			aCols[nLin][5] := aMaq[nI][4]  
			aCols[nLin][6] := "1"
			aCols[nLin][Len(aHeader)+1] := .F.
			
			nCnt++
		EndIf
	Next nI
	If nCnt > 0
		oMsGd:SetArray( aCols )
		oMsGD:Refresh()	 	
	EndIf
EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF3Pat	    บAutor  ณJackson E. de Deus  บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta especifica - patrimonios planilha                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function F3Pat()

Local cPat := ""
Local oDlg
Local aAux := IIF(oCBOX1:NAT==1,aclone(aPatIns),aclone(aPatRem))

If Empty(aAux)
	MsgInfo("Nใo hแ dados.")
	Return cPat
EndIf

Define MsDialog oDlg Title "Patrim๔nios" From 0,0 To 250,500 Pixel
	@ 005,002  Say IIF(oCBOX1:NAT==1,"Instalados via OMM","Removidos via OMM")   Pixel Of oDlg
	@ 015,002 LISTBOX oLbx FIELDS HEADER "Patrim๔nio", "Modelo" SIZE 249,090 OF oDlg PIXEL
	
	oLbx:SetArray(aAux)
	oLbx:bLine := {|| { aAux[oLbx:nAt,1],;
						aAux[oLbx:nAt,2] }}        
	oLbx:blDblClick := {|| cPat := aAux[oLbx:nAt,1], oDlg:End()  }
      
	oButton := tButton():New(110,220,'Confirmar',oDlg,{ || oDlg:End() },30,12,,,,.T.)
Activate MsDialog oDlg Center

Return cPat


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLinOk	    บAutor  ณJackson E. de Deus  บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Linha Ok do grid                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LinOk()

Local lRet := .T.
Local cPatrimo := oMsGD:aCols[oMsGD:nAt][1]
Local cpLoja := oMsGD:aCols[oMsGD:nAt][3]
Local nVlAlug := oMsGD:aCols[oMsGD:nAt][4]
Local dData := oMsGD:aCols[oMsGD:nAt][5]

If Empty(cPatrimo)
	MsgAlert("Preencha o patrim๔nio!")
	lRet := .F.
	Return lRet
EndIf

If Empty(cpLoja)
	MsgAlert("Preencha a loja!")
	lRet := .F.
	Return lRet
EndIf

// inclusao - obrigatorio o valor da locacao	
If oCBOX1:NAT == 1
	If nVlAlug == 0
		MsgAlert("Preencha o valor!")
		lRet := .F.
		Return lRet
	EndIf
EndIf

If Empty(dData)
	MsgAlert("Preencha a data!")
	lRet := .F.
	Return lRet
EndIf
	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCampo  บAutor  ณJackson E. de Deus  บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao de campos do grid                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldCampo()

Local lRet := .T.
Local nValSUD := 0
Local cPatrimo := oMsGD:aCols[oMsGD:nAt][1]
Local cAssOMM	:= SuperGetMV("MV_XTMK002",.T.,"000007")

// instalacao
If oCBOX1:NAT == 1
	nRecno := ChkOmm(1,cPatrimo)
// remocao	
Else 
	nRecno := ChkOmm(2,cPatrimo)
EndIf

dbSelectArea("SZD")
dbGoto(nRecno)

// validacao campo patrimonio		
If __readvar == "M->ZQ_PATRIM"
	If !Empty(M->ZQ_PATRIM)
		If oCBOX1:NAT == 1
			If Ascan( aPatIns, { |x| AllTrim(x[1]) == AllTrim(M->ZQ_PATRIM) } ) == 0 .And. !cUserName $ "JDEUS"
				Alert("Patrim๔nio nใo instalado no cliente." +CRLF +"S๓ ้ possํvel adicionar na planilha patrim๔nio jแ instalado via OMM.")
				lRet := .F.
				Return lRet
			EndIf
		Else
			If Ascan( aPatRem, { |x| AllTrim(x[1]) == AllTrim(M->ZQ_PATRIM) } ) == 0 .And. !cUserName $ "JDEUS"
				Alert("Patrim๔nio nใo removido do cliente." +CRLF +"S๓ ้ possํvel remover da planilha patrim๔nio jแ removido via OMM.")
				lRet := .F.
				Return lRet
			EndIf
		EndIf
	EndIf		

// validacao campo loja
ElseIf __readvar == "M->ZQ_LOJA"
	If Empty(cPatrimo)
		Alert("Preencha primeiro o patrim๔nio.")
		lRet := .F.
		Return lRet	
	EndIf
	// inclusao
	If oCBOX1:NAT == 1
		If AllTrim(M->ZQ_LOJA) != AllTrim(SZD->ZD_LOJA) .And. !cUserName $ "JDEUS"
			Alert("A loja informada nใo corresponde com a loja da instala็ใo atual.")
			STATICCALL(TTCNTA16,OMM,cpCliente,cPatrimo)
			lRet := .F.
			Return lRet
		EndIf
	// remocao	
	Else 
		If AllTrim(M->ZQ_LOJA) != AllTrim(SZD->ZD_LOJA) .And. !cUserName $ "JDEUS"
			Alert("A loja informada nใo corresponde com a loja da ๚ltima instala็ใo.")
			STATICCALL(TTCNTA16,OMM,cpCliente,cPatrimo)
			lRet := .F.
			Return lRet
		EndIf
	EndIf                          

// validacao campo valor	
ElseIf __readvar == "M->ZQ_VALOR"
	If Empty(cPatrimo)
		Alert("Preencha primeiro o patrim๔nio.")
		lRet := .F.
		Return lRet	
	EndIf
	// inclusao
	If oCBOX1:NAT == 1
		dbSelectArea("SUD")
		dbSetOrder(1)
		If dbSeek( xFilial("SUD") +AvKey(SZD->ZD_NROOMM,"UD_CODIGO") )
			If AllTrim(SUD->UD_ASSUNTO) == AllTrim(cAssOMM)
				While SUD->UD_FILIAL == xFilial("SUD") .AND. AllTrim(SUD->UD_CODIGO) == AllTrim(SZD->ZD_NROOMM) .And. ;
					AllTrim(SUD->UD_ASSUNTO) == AllTrim(cAssOMM) .And. !EOF()
					If AllTrim(SUD->UD_XNPATRI) == AllTrim(SZD->ZD_PATRIMO)
						nValSUD := SUD->UD_XVLALUG 
						Exit
					EndIf
					dbSkip()
				End
			EndIf	
		EndIf
		If M->ZQ_VALOR != nValSUD	// .And. !cUserName $ "JDEUS"
			If !MsgYesNo("O valor de loca็ใo informado nใo corresponde com o valor informado na OMM de instala็ใo." +CRLF +"Valor informado na OMM: " +cvaltochar(nValSUD) +CRLF +"Confirma?")
				lRet := .F.
			EndIf
			Return lRet
		EndIf
	EndIf    

// validacao campo data	                                                                                                              
ElseIf __readvar == "M->ZQ_DATAINS"
	If Empty(cPatrimo)
		Alert("Preencha primeiro o patrim๔nio.")
		lRet := .F.
		Return lRet	
	EndIf
	// inclusao
	If oCBOX1:NAT == 1
		If M->ZQ_DATAINS != SZD->ZD_DATAINS .And. !cUserName $ "JDEUS"
			Alert("A data informada nใo corresponde com a data da ๚ltima instala็ใo.")
			STATICCALL(TTCNTA16,OMM,cpCliente,cPatrimo)
			lRet := .F.
			Return lRet
		EndIf
	// remocao	
	Else 
		If M->ZQ_DATAINS != SZD->ZD_DATAREM .And. !cUserName $ "JDEUS"
			Alert("A data informada nใo corresponde com a data da ๚ltima remo็ใo.")
			STATICCALL(TTCNTA16,OMM,cpCliente,cPatrimo)
			lRet := .F.
			Return lRet
		EndIf
	EndIf               
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkOmm  บAutor  ณJackson E. de Deus    บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna Recno do registro no historico                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkOmm(nTipo,cPatrimo)
      
Local cSql := ""
Local nRecno := 0       

cSql := "SELECT TOP 1 R_E_C_N_O_ REC FROM " +RetSqlName("SZD") 
cSql += " WHERE ZD_CLIENTE = '"+cpCliente+"' AND ZD_PATRIMO = '"+cPatrimo+"' AND D_E_L_E_T_ = '' "

If nTipo == 1
	cSql += " AND ZD_IDSTATU = '1' AND ZD_DATAREM = '' "
ElseIf nTipo == 2
	cSql += " AND ZD_IDSTATU = '0' AND ZD_DATAREM <> '' "
EndIf

cSql += " ORDER BY R_E_C_N_O_ DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRB",.F.,.T.)
                        
dbSelectArea("TRB")
If !EOF()
	nRecno := TRB->REC
EndIf

TRB->(dbCloseArea())

Return nRecno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar     บAutor  ณJackson E. de Deus บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gravar()

Local nTipo := 1
Local cPatrimo := ""
Local nVlAlug := 0
Local dData := ctod("")
Local lProRata := .F.
Local lOk := .F.
Local ncont := 0
Local aErros := {}
Local aPatrSZQ := {}

nTipo := oCBOX1:NAT

For nI := 1 To Len(oMsGD:aCols)
	If !oMsGD:aCols[nI][Len(aHeader)+1]
		ncont++
	EndIf
Next nI

ProcRegua(ncont)

For nI := 1 To Len(oMsGD:aCols)	
	If oMsGD:aCols[nI][Len(aHeader)+1]
		Loop
	EndIf
	
	IncProc("Patrim๔nio " +oMsGD:aCols[nI][1]) 
	cPatrimo := oMsGD:aCols[nI][1]
	cpLoja := oMsGD:aCols[nI][3]
	nVlAlug := oMsGD:aCols[nI][4]
	dData := oMsGD:aCols[nI][5]
	If oMsGD:aCols[nI][6] == "1"
		lProRata := .T.
	Else 
		lProRata := .F.
	EndIf
	
	lOk := U_TTCNTA14(nTipo, cContrato, cPlanilha, cPatrimo, nVlAlug, dData, cpCliente, cpLoja )	
	//lOk := U_TTCNTA15("",nTipo,cContrato,cPlanilha,cpCliente,cpLoja,cPatrimo,nVlAlug,dData,lProRata)
	If lOk
		Aviso("TTCNTA13","Patrim๔nio: " +cPatrimo +" -> Planilha atualizada - OK",{"Ok"})
	Else
		Aviso("TTCNTA13","Patrim๔nio: " +cPatrimo +" -> Planilha nใo atualizada - ERRO",{"Ok"})
	EndIf
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadHead  บAutor  ณJackson E. de Deus  บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega aHeader                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadHead()
             
DbSelectArea("SX3")
DbSetOrder(2)            
dbGoTop()
// patrimonio
If DbSeek("ZQ_PATRIM")
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"STATICCALL(TTCNTA13,VldCampo)",SX3->X3_USADO,SX3->X3_TIPO,"SZQ1",SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf      

// descricao
If DbSeek("N1_DESCRIC")
     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf     

// loja
If DbSeek("ZQ_LOJA")
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"STATICCALL(TTCNTA13,VldCampo)",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf  

// valor
If DbSeek("ZQ_VALOR")
	AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"STATICCALL(TTCNTA13,VldCampo)",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

// data
If DbSeek("ZQ_DATAINS") 
	AADD(aHeader,{"Data",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"STATICCALL(TTCNTA13,VldCampo)",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf							

If DbSeek("B1_MSBLQL")
	AADD(aHeader,{"Pro Rata","T_PRORA",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,"1=Sim;2=Nao",SX3->X3_RELACAO } )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadCols  บAutor  ณJackson E. de Deus  บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega aCols                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadCols()

AAdd(aCols, Array(Len(aHeader)+1))
nLin := Len(aCols)

For nCol := 1 To Len(aHeader)
	If aHeader[nCol][2] $ "T_TIPO|T_PRORA"
		aCols[nLin][nCol] := "1"
	Else
		aCols[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
	EndIf
Next nCol                

aCols[1][Len(aHeader)+1] := .F.		

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTA13  บAutor  ณMicrosiga           บ Data ณ  05/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ preenche a descricao do patrimonio                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTCNTA19()

Local aArea		:= GetArea()
Local nDescPatr	:= aScan(aHeader, {|x| AllTrim(Upper(x[2]))=="N1_DESCRIC" })
Local lRet		:= .T.

If UPPER(__readvar) == "M->ZQ_PATRIM"
	If !Empty(AllTrim((M->ZQ_PATRIM)))
		oMsGD:aCols[oMsGD:oBrowse:nRowPos][nDescPatr] := GetAdvFVal("SN1","N1_DESCRIC", xFilial("SN1")+M->ZQ_PATRIM, 2, Space(TamSX3("N1_DESCRIC")[1]))
	EndIf
EndIf

RestArea(aArea) 

Return lRet                                            