#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTLOC  ºAutor  ³Jackson E. de Deus  º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Locacoes - geracao do pedido de venda                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCNTLOC()

Local oWindow
Local aSize			:= MsAdvSize()
Local nOpc			:= GD_UPDATE
Local aAlter		:= { "ZQ_VALOR"/*,"T_PLAN"*/ }
Local aButtons		:= { {"HISTORIC", { || SelPlan() }, "Planilha", "Planilha" , {|| .T.} } }
Private oFont		:= TFont():New('Courier new',,-12,.T.)
Private lProRata	:= IIF( CN9->CN9_XPRORA=="1",.T.,.F. )
Private aCols		:= {}
Private aHeader		:= {}   
Private aReajuste	:= {}
Private cCheck		:= "LBOK"	// LoadBitMap(GetResources(), "LBOK")
Private cUnCheck	:= "LBNO"	// LoadBitMap(GetResources(), "LBNO") 
Private aHist		:= {}

If cEmpAnt <> "01"
	Return
EndIf 

fHead()


oWindow := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Locações",,,.F.,,,,,,.T.,,,.T. )	
      
	oWindow:lEscClose := .F.
	oWindow:lMaximized := .T.
       
	oFld1 := TFolder():New( 0,0,{ "Equipamentos","Histórico de Faturamento" },{},oWindow,,,,.T.,.F.,0,0,)
	oFld1:Align := CONTROL_ALIGN_ALLCLIENT
	
	MENU oMenu POPUP
	MENUITEM "Relatório" ACTION ( MsAguarde({ || Relat( oLbx:nAt )},"Gerando relatório..") )
	ENDMENU
                                               
	// patrimonios
    oMsGD := MsNewGetDados():New(0,0,0,0,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,999,'STATICCALL( TTCNTLOC,AltPlan )','','AllwaysTrue()',oFld1:aDialogs[1],aHeader,aCols, { || oMsGD:Acols := aCols})
   	oMsGD:oBrowse:bldblclick := { || gdclick() }
   	oMsGD:oBrowse:Align	:= CONTROL_ALIGN_ALLCLIENT
   	           
   	// historico
   	@ 0,0 LISTBOX oLbx FIELDS HEADER "Pedido","Emissão","R$ Valor","Período","Nota fiscal","Série"  SIZE 0,0 OF oFld1:aDialogs[2] PIXEL

	oLbx:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oLbx:Align := CONTROL_ALIGN_ALLCLIENT 	
	
   	Carrega()
   	fHist()
	
oWindow:Activate(,,,.T.,/*aButtons*/,,EnchoiceBar(oWindow,{ || Pedido() },{ || oWindow:End(),,aButtons,,,.F.,.F.,.F.} )) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³gdclick  ºAutor  ³Jackson E. de Deus   º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca/Desmarca os patrimonios                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function gdclick()

If oMsGD:oBrowse:nColPos == 5 .Or. oMsGD:oBrowse:nColPos == 9         //oMsGd:Acols[oMsGD:nAt][oMsGD:oBrowse:nColPos]
	If oMsGD:oBrowse:nColPos == 5
		Aadd(aReajuste,{oMsGD:Acols[oMsGD:nAt][5],0,oMsGD:Acols[oMsGD:nAt][10]})
	EndIf
	oMsGD:EditCell()
	If len(aReajuste) > 0
		aReajuste[len(aReajuste),02] := oMsGD:Acols[oMsGD:nAt][5]
	EndIf
Else
	If oMsGd:Acols[oMsGD:nAt][1] == cCheck
		oMsGd:Acols[oMsGD:nAt][1] := cUnCheck
	Else
		oMsGd:Acols[oMsGD:nAt][1] := cCheck
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SelPlan  ºAutor  ³Jackson E. de Deus   º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SelPlan()

Local aPergs	:= {} 
Local aRet		:= {}
Local cPlan		:= ""
Local nI

aAdd(aPergs ,{1,"Planilha"	,Space(6),"@!","","","",50,.F.})

If !ParamBox(aPergs ,"Planilha",@aRet)
	Return
EndIf
 
cPlan := aRet[1]

For nI := 1 To Len( oMsGd:Acols )
	If oMsGd:acols[nI][9] != cPlan
		oMsGd:acols[nI][1] := cUnCheck
	EndIf
Next nI

oMsGd:Refresh()
   

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltPlan  ºAutor  ³Jackson E. de Deus   º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de planilha                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AltPlan()

If __readvar == "M->T_PLAN"
	If Val(M->T_PLAN) == 0
		Return .F.
	EndIf 
	
	If Len(ALLTRIM(M->T_PLAN)) < 6
		M->T_PLAN := PadL( AllTrim(M->T_PLAN),6,"0" )
		Return .T.
	EndIf
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fHead  ºAutor  ³Jackson E. de Deus     º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega aHeader                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fHead()

dbSelectArea("SX3")
dbSetOrder(2)            
dbGoTop()

// marcacao
Aadd(aHeader, {" ","CHECK", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})

// patrimonio
If DbSeek("ZQ_PATRIM")
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf      

// descricao
If DbSeek("N1_DESCRIC")
     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf     

// produto
If dbSeek("N1_PRODUTO")
     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf


// valor
If DbSeek("ZQ_VALOR")
	AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"" /*vld campo*/,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

// data
If DbSeek("ZQ_DATAINS") 
	AADD(aHeader,{"Instalação",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

If DbSeek("ZQ_DATAREM") 
	AADD(aHeader,{"Remoção",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf								

If DbSeek("ZQ_LOJA") 
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

If DbSeek("ZQ_PLAN") 
	AADD(aHeader,{Trim(X3Titulo()),"T_PLAN","999999",SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,"" } )
EndIf

//RECNO SZQ
Aadd(aHeader, {" ","RECNO", "", 10, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})	   
											
Return                          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fHist  ºAutor  ³Jackson E. de Deus     º Data ³  12/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Historico dos pedidos desse contrato                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fHist()

Local aArea := GetArea()
Local cSql := ""
Local aAux := {}
Local cNumPed := ""
Local cPer := ""
Local nVal := 0
Local dData := stod("")

cSql := "SELECT * FROM " +RetSqlName("SZL") +" WHERE ZL_MODULO = 'TTCNTLOC' AND ZL_TIPOMOV = 'FAT_LOCACAO' "
cSql += " AND ZL_DOCTO = '"+CN9->CN9_NUMERO+"' AND ZL_TABELA = 'SC5' AND D_E_L_E_T_ = ''  "
cSql += " ORDER BY ZL_DATA, ZL_HORA "


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

While !EOF()

	aAux := StrToKarr( TRB->ZL_OBS,";" )
	
	cNumPed := aAux[1]
	cPer := DTOC(STOD(aAux[2])) +" - " +DTOC(STOD(aAux[3]))
	nVal := TRB->ZL_VALOR                      
	dData := DTOC(STOD(TRB->ZL_DATA))
	
	cNota := ""
	cSerie := ""
	   
	If !Empty(cNumPed)
		dbSelectArea("SC5")
		dbSetOrder(1)		
		If msSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
			If ! "XXX" $ SC5->C5_NOTA
				cNota := SC5->C5_NOTA
				cSerie := SC5->C5_SERIE
				AADD( aHist, { cNumPed,dData,nVal,cPer,cNota,cSerie,TRB->R_E_C_N_O_ } ) 
			EndIf		
		EndIf	
	EndIf
	
	dbSelectArea("TRB")
	dbSkip()
End

If !Empty(aHist)
	oLbx:SetArray( aHist )
	oLbx:bLine := {|| { aHist[oLbx:nAt,1],;
						aHist[oLbx:nAt,2],;
						Transform(aHist[oLbx:nAt,3],PesqPict("SF2","F2_VALBRUT")),;
						aHist[oLbx:nAt,4],;
						aHist[oLbx:nAt,5],;
						aHist[oLbx:nAt,6] }}
	oLbx:Refresh()
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCNTLOC  ºAutor  ³Microsiga           º Data ³  03/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Relat(nLinha)

Local cContra	:= CN9->CN9_NUMERO
Local oExcel	:= FWMSEXCEL():New()	
Local nRecZL	:= aHist[nLinha][7]
Local aPlan		:= {}
Local lInsumo	:= .F.
Local aLocacoes	:= {}
Local dInicio	:= stod("")
Local dFim		:= stod("")
Local cPeriodo	:= ""
Local cVencto	:= ""
Local cDir		:= ""
Local cPlanilha	:= cContra +".xml"
Local nTpInsumo	:= 0
Local aInsumos	:= {}
Local cUFLoja	:= ""
Local aAux		:= {}
Local nQtdComp	:= 0
Local nVlDia	:= 0
Local nVlPR		:= 0
Local cTxtDescri:= ""
Local nTotfat	:= 0
Local cNumPed	:= ""
Local nQtdDias	:= 0
Local aDados	:= {}
Private nTotInsumo := 0
Private cLojas	:= ""
Private cCliDifer	:= SuperGEtMV("MV_XGCT002",.T.,"")	//clientes diferenciados onde a busca dos insumos sera pelas lojas do estado da loja do contrato

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
If Empty(cDir)
	Aviso("TTCNTLOC","Escolha um diretório válido.",{"Ok"})
	Return
EndIf


//Define a primeira sheet Contrato
oExcel:AddworkSheet("Contrato")
oExcel:AddTable ("Contrato","Contrato")
//oExcel:AddColumn("Contrato","Contrato","Medicao",1,1)
oExcel:AddColumn("Contrato","Contrato","Contrato",1,1)
//oExcel:AddColumn("Contrato","Contrato","Revisao",1,1)
oExcel:AddColumn("Contrato","Contrato","Pedido",1,1)
oExcel:AddColumn("Contrato","Contrato","Cliente",1,1)
oExcel:AddColumn("Contrato","Contrato","Valor do Faturamento",1,2)
oExcel:AddColumn("Contrato","Contrato","Vencimento",1,4)
oExcel:AddColumn("Contrato","Contrato","Periodo",1,1)
oExcel:AddColumn("Contrato","Contrato","Competencia",1,1)
oExcel:AddColumn("Contrato","Contrato","Data",1,4)

oExcel:AddworkSheet("Locacoes")
oExcel:AddTable ("Locacoes","Locacoes")
oExcel:AddColumn("Locacoes","Locacoes","Patrimonio",1,1)
oExcel:AddColumn("Locacoes","Locacoes","Modelo",1,1)
oExcel:AddColumn("Locacoes","Locacoes","Valor Locacao",1,2)
oExcel:AddColumn("Locacoes","Locacoes","Loja",1,1)
oExcel:AddColumn("Locacoes","Locacoes","Descricao",1,1)
oExcel:AddColumn("Locacoes","Locacoes","Endereco de Instalacao",1,1)
oExcel:AddColumn("Locacoes","Locacoes","Data de Instalacao",1,4)
oExcel:AddColumn("Locacoes","Locacoes","Data de Remocao",1,4)


oExcel:AddworkSheet("Insumos")
oExcel:AddTable ("Insumos","Insumos")
oExcel:AddColumn("Insumos","Insumos","Produto",1,1)
oExcel:AddColumn("Insumos","Insumos","Descricao",1,1)
oExcel:AddColumn("Insumos","Insumos","Armazem",1,1)
oExcel:AddColumn("Insumos","Insumos","Descricao",1,1)
oExcel:AddColumn("Insumos","Insumos","Qtde",1,2)
oExcel:AddColumn("Insumos","Insumos","Valor UN",1,2)
oExcel:AddColumn("Insumos","Insumos","Total",1,2)
oExcel:AddColumn("Insumos","Insumos","Mensagem",1,1)
oExcel:AddColumn("Insumos","Insumos","Pedido",1,1)


dbSelectArea("SZL")
dbGoTo(nRecZL)
aAux := StrToKarr( SZL->ZL_OBS,";" )
cNumPed := aAux[1]
dInicio := aAux[2]
dFim := aAux[3]
cPlans := aAux[4]
cPeriodo := DTOC(STOD(dInicio)) + " A " +DTOC(STOD(dFim))
cVencto := AllTrim( Posicione("SE4",1,xFilial("SE4") +AvKey(SC5->C5_CONDPAG,"C5_CONDPAG"),"E4_DESCRI") ) +" Emiss. NF"
nTotfat := SZL->ZL_VALOR

nQtdDias := stod(dFim) - stod(dInicio)+1
nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1


// locacoes
aPlan := StrToKarr( cPlans, "|" )
For nI := 1 To Len(aPlan)
	dbSelectArea("CNA")
	dbSetOrder(1) //CNA_FILIAL+CNA_CONTRA+CNA_REVISA+CNA_NUMERO (filial+contrato+revisao+planilha)
	If !MSSeek(xFilial("CNA") +AvKey(cContra,"CN9_NUMERO") +AvKey("","CNA_REVISA") +AvKey(aPlan[nI],"CNA_NUMERO") )
		Loop		
	EndIf       

	If AllTrim(CNA->CNA_XINSUM) == "1"
		lInsumo := .T.
	EndIf
	
	dbSelectArea("CNB")
	dbSetOrder(1)
	If !MSSeek( xFilial("CNB") +AvKey(cContra,"CNB_CONTRA") +AvKey("","CNB_REVISA") +AvKey(aPlan[nI],"CNB_NUMERO")  )
		Loop
	EndIf
	        	
	dbSelectArea("SZQ")
	dbSetOrder(1)
	If MSSeek( xFilial("SZQ") +AvKey(cContra,"ZQ_CONTRA") +AvKey(aPlan[nI],"ZQ_PLAN") ) 
		While AllTrim(SZQ->ZQ_CONTRA) == AllTrim(cContra) .And. AllTrim(SZQ->ZQ_PLAN) == AllTrim(aPlan[nI]) .And. SZQ->(!EOF())
  			      
  			lQuebra := .F.  			
  			If SZQ->ZQ_DATAINS > STOD(dFim)
  				dbSkip()
  				Loop
  			EndIf       
  			
  			If !Empty(SZQ->ZQ_DATAREM)
  				If SZQ->ZQ_DATAREM < STOD(dInicio)
  					dbSkip()
  					Loop
  				EndIf
  			EndIf
  			
  			// instalacao posterior a data fim
			If SZQ->ZQ_DATAINS > STOD(dInicio) .And. SZQ->ZQ_DATAINS < STOD(dFim)
				lQuebra := .T.
			EndIf   
			                                       
			// remocao antes do periodo
			If !Empty(SZQ->ZQ_DATAREM)
				If SZQ->ZQ_DATAREM > STOD(dInicio) .AND. SZQ->ZQ_DATAREM < STOD(dFim)
					lQuebra := .T.
				EndIf
			EndIf
  								  								
  			// pro rata   
			If lProRata .And. lQuebra
				// instalacao
				If SZQ->ZQ_DATAINS > STOD(dInicio)
					nQtdDias := ( STOD(dFim) - SZQ->ZQ_DATAINS )+1 //nQtdDias := ( SZQ->ZQ_DATAINS - STOD(dInicio) )+1
					nVlDia := SZQ->ZQ_VALOR / nQtdComp
					nVlPR := nVlDia * nQtdDias
					
					cTxtDescri := "Ref Pro Rata Instalação de patrimônio na data: "+DTOC(SZQ->ZQ_DATAINS)
				EndIf
			
				// remocao
				If !Empty(SZQ->ZQ_DATAREM)	
					If SZQ->ZQ_DATAREM < STOD(dFim)
						nQtdDias := ( SZQ->ZQ_DATAREM - Stod(dInicio) )+1
						nVlDia := SZQ->ZQ_VALOR / nQtdComp
						nVlPR := nVlDia * nQtdDias
						
						cTxtDescri := "Ref Pro Rata Remoção de patrimônio na data: "+DTOC(SZQ->ZQ_DATAREM)
					EndIf
				EndIf
												
				AADD(aLocacoes,{SZQ->ZQ_PATRIM,;
  								cTxtDescri,;
  								nVlPR,;
  								SZQ->ZQ_LOJA,;
  								Posicione( "SA1",1,xFilial("SA1") +AvKey(CN9->CN9_CLIENT,"A1_COD") + AvKey(SZQ->ZQ_LOJA,"A1_LOJA"),"A1_NREDUZ" ),;
  								Posicione( "SN1",2,xFilial("SN1") +AvKey(SZQ->ZQ_PATRIM,"N1_CHAPA"),"N1_XLOCINS" ),;
  								SZQ->ZQ_DATAINS,;
  								SZQ->ZQ_DATAREM})
  								
			Else
			
				AADD(aLocacoes,{SZQ->ZQ_PATRIM,;
  								Posicione( "SN1",2,xFilial("SN1") +AvKey(SZQ->ZQ_PATRIM,"N1_CHAPA"),"N1_DESCRIC" ),;
  								SZQ->ZQ_VALOR,;
  								SZQ->ZQ_LOJA,;
  								Posicione( "SA1",1,xFilial("SA1") +AvKey(CN9->CN9_CLIENT,"A1_COD") + AvKey(SZQ->ZQ_LOJA,"A1_LOJA"),"A1_NREDUZ" ),;
  								Posicione( "SN1",2,xFilial("SN1") +AvKey(SZQ->ZQ_PATRIM,"N1_CHAPA"),"N1_XLOCINS" ),;
  								SZQ->ZQ_DATAINS,;
  								SZQ->ZQ_DATAREM})	  
			EndIf
  								
			SZQ->(dbSkip())
		End        
	EndIf		
Next nI


//Grava as locacoes do periodo
For nI := 1 To Len(aLocacoes)
	oExcel:AddRow("Locacoes","Locacoes",{aLocacoes[nI][1],;
										aLocacoes[nI][2],;
										aLocacoes[nI][3],;		
										aLocacoes[nI][4],;			
										aLocacoes[nI][5],;			
										aLocacoes[nI][6],;			
										aLocacoes[nI][7],;
										aLocacoes[nI][8]})			
Next nI           

If lInsumo
	nTpInsumo := Aviso("TTCNTLOC","Escolha o tipo de consulta aos insumos:",{"SD2","SD3","SD2+SD3"})
		
	If CN9->CN9_CLIENT $ cCliDifer
		cUFLoja := Posicione("SA1",1,xFilial("SA1") +CN9->CN9_CLIENT +CN9->CN9_LOJACL,"A1_EST")
		STATICCALL( TTCNTA05, RetLojas, CN9->CN9_CLIENT, cUFLoja )
	EndIf
				
	If nTpInsumo == 1 
		Insumosd2(@aInsumos,stod(dInicio),stod(dFim))
	ElseIf nTpInsumo == 2	
		Insumos(@aInsumos,stod(dInicio),stod(dFim))
	ElseIf nTpInsumo == 3 
		Insumos(@aInsumos,stod(dInicio),stod(dFim))
		Insumosd2(@aInsumos,stod(dInicio),stod(dFim))
	EndIf
	
					 		
	//Grava os insumos
	For nI := 1 To Len(aInsumos)
		oExcel:AddRow("Insumos","Insumos",{aInsumos[nI][1],;
											aInsumos[nI][2],;
											aInsumos[nI][3],;		
											aInsumos[nI][4],;			
											aInsumos[nI][5],;			
											aInsumos[nI][6],;			
											aInsumos[nI][7],;
											aInsumos[nI][8],;
											aInsumos[nI][9]})			
	Next nI                            
	                                 		
	nTotfat += nTotInsumo 
EndIf
		
// primeira sheet
oExcel:AddRow("Contrato","Contrato",{ cContra,;
									cNumPed,;
									 AllTrim(CN9->CN9_CLIENT)+" - "+Posicione("SA1",1,xFilial("SA1")+CN9->CN9_CLIENT+CN9->CN9_LOJACL,"A1_NOME" ),;
									  nTotFat,;
									  cVencto,;
									  cPeriodo,;
									  CN9->CN9_XPCOMP,;
									  Dtoc(dDatabase)})    

		
oExcel:Activate()
oExcel:GetXMLFile(cDir+cPlanilha)

If File(cDir +cPlanilha)
	Aviso("TTCNTLOC","A planilha foi gerada em "+UPPER(cDir) +CRLF +"Nome: "+cPlanilha,{"Ok"})

	If !ApOleClient( 'MsExcel' )
		Aviso("TTCNTLOC", 'MsExcel não instalado. ' +CRLF +'O arquivo está em: '+cDir )
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

Static Function Insumosd2(aInsumos,dInicio,dFim)

Local aArea	:=	GetArea()
Local cQuery
Local cPer1	:= dInicio
Local cPer2 := dFim
Local cArm	:=	''
Local cCodPA := ""
Local cUm := ""
Local cSegUm := ""
Local nTot := 0
Local nQtd := 0
Local nQSb := 0
Local nSub := 0
					
cQuery := STATICCALL(TTCNTR01,QueryD2,cPer1,cPer2,CN9->CN9_CLIENT,cLojas,cCliDifer) 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

If !Empty(TRB->D2_COD)
	cArm	:= TRB->D2_LOJA //Posicione("ZZ1",3,xFilial("ZZ1")+(cAliasCND)->CN9_CLIENTE+TRB->D2_LOJA,"ZZ1_COD")
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
							"",;
							""})
			
			
			nTot	+=	nSub
				
			nQSb	:=	0
			nSub	:=	0
			cArm	:=	TRB->D2_LOJA
			
		EndIf
		
		AADD(aInsumos,{TRB->D2_COD,;
						TRB->B1_DESC,;
						TRB->D2_LOJA,;
						TRB->NOME,;
						TRB->QTD,;
						TRB->D2_PRCVEN,;
						TRB->VALOR,;
						TRB->C5_MENNOTA,;
						TRB->C5_NUM})
	
		
			nQtd	+=	TRB->QTD 
			nQSb	+=	TRB->QTD
			nSub	+=	TRB->VALOR
		
	
		DbSkip()
	EndDo                                   
	//ultimo sub-total que o jackson ficou com preguiça de colocar
	AADD(aInsumos,{"",;
				"Sub-Total",;
				cArm,;
				"",;
				0,;
				0,;
				nSub,;
				"",;
				""})
	//Totais
	AADD(aInsumos,{"",;
					"Totais",;
					"",;
					"",;
					0,;
					0,;
					nTot+nSub,;
					"",;
					""})                  
EndIf	

TRB->(dbCloseArea())
			
RestArea(aArea)

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

Static Function Insumos(aInsumos,dInicio,dFim)
      
Local aArea	:=	GetArea()
Local cQuery
Local cPer1	:= dInicio
Local cPer2 := dFim
Local cArm	:=	''
Local cUm := ""
Local cSegUm := ""
Local nTot := 0
Local nQtd := 0
Local nQSb := 0
Local nSub := 0

cQuery := STATICCALL(TTCNTR01,QueryD3,cPer1,cPer2,CN9->CN9_CLIENT,cLojas,cCliDifer) 

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
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
							"",;
							""})
			                      
			nTot	+=	nSub
				
			nQSb	:=	0
			nSub	:=	0
			cArm	:=	TRB->D3_LOCAL
		EndIf
		
			AADD(aInsumos,{TRB->D3_COD,;
						TRB->B1_DESC,;
						TRB->D3_LOCAL,;
						TRB->ZZ1_DESCRI,;
						TRB->QTD,;
						TRB->D2_PRCVEN,;
						TRB->VALOR,;
						TRB->C5_MENNOTA,;
						TRB->C5_NUM})
		 
		
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
			"",;
			""})
	//Totais
	AADD(aInsumos,{"",;
			"Totais",;                 	
			"",;
			"",;
			0,;
			0,;
			nTot+nSub,;
			"",;
			""}) 
EndIf
   
       
TRB->(dbCloseArea())

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Carrega  ºAutor  ³Jackson E. de Deus   º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os dados                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Carrega()


Local aArea := GetArea()
Local cSql := ""
Local nLin := 0

cSql := "SELECT ZQ_PATRIM, N1_DESCRIC, N1_PRODUTO, ZQ_VALOR, ZQ_DATAINS, ZQ_DATAREM, ZQ_LOJA, ZQ_PLAN, SZQ.R_E_C_N_O_ AS REG FROM " +RetSqlName("SZQ") +" SZQ "
cSql += " INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
cSql += " N1_CHAPA = ZQ_PATRIM AND SN1.D_E_L_E_T_ = '' "
cSql += " WHERE ZQ_CONTRA = '"+CN9->CN9_NUMERO+"' "
cSql += " AND SZQ.D_E_L_E_T_ = '' "
cSql += " ORDER BY ZQ_DATAINS "  

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	AAdd(aCols, Array(Len(aHeader)+1))
	nLin := Len(aCols)
	
	aCols[nLin][1] := cCheck
	aCols[nLin][2] := TRB->ZQ_PATRIM
	aCols[nLin][3] := TRB->N1_DESCRIC
	aCols[nLin][4] := TRB->N1_PRODUTO
	aCols[nLin][5] := TRB->ZQ_VALOR
	aCols[nLin][6] := dtoc(stod(TRB->ZQ_DATAINS))
	aCols[nLin][7] := dtoc(stod(TRB->ZQ_DATAREM))
	aCols[nLin][8] := TRB->ZQ_LOJA
	aCols[nLin][9] := TRB->ZQ_PLAN  
    
	//Recno szq
	aCols[nLin][10] := TRB->REG
	
	aCols[nLin][Len(aHeader)+1] := .F.
	
	TRB->(dbSkip())			
End   


oMsGD:Acols := aClone(aCols)
oMsGD:Refresh(.T.)	 
oMsGD:GoTop() 
                          
//oMsGD:SetArray( aInfo, .T. )
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Pedido  ºAutor  ³Jackson E. de Deus    º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao do pedido - parametros                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Pedido()

Local aArea := GetArea()
Local nTotal := 0
Local cNumPed := ""
Local aPergs	:= {} 
Local aRet		:= {}
Local dInicio	:=	ctod('  /  /  ')
Local dFim		:=	ctod('  /  /  ')
Private _aPlan	:= {}


aAdd(aPergs ,{1,"Inicio"	,dDatabase,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{1,"Fim"		,dDatabase,"99/99/99","","","",50,.F.})

If !ParamBox(aPergs ,"Parâmetros",@aRet)
	Return
EndIf
 
dInicio := aRet[1]   
dFim := aRet[2]

If dInicio == dFim
	MsgAlert("A data inicial e data final não podem ser iguais!")
	Return
EndIf

MsAguarde( { || Calc(@nTotal,dInicio,dFim)  }, "Aguarde, calculando locação.." )

If nTotal == 0
	MsgAlert("Não há locações a cobrar no período ou o valor das locações é igual a zero.")
	RestArea(aArea)
	Return
EndIf
              
If len(aReajuste) > 0
	lReajuste := .F.
	For nXX := 1 to len(aReajuste)
		If aReajuste[nXX,01] <> aReajuste[nXX,02]
			lReajuste := .T.
		EndIf
	Next nXX 
	
	If lReajuste
		If MsgYesNo("Valor de locação alterado nos itens, deseja salvar esta alteração na planilha do contrato?")
			DbSelectArea("SZQ")
			For nXX := 1 to len(aReajuste)
				DbGoto(aReajuste[nXX,03])
				Reclock("SZQ",.F.)
				SZQ->ZQ_VALOR := aReajuste[nXX,02]
				SZQ->(Msunlock())
			Next nXX	
		EndIf
	EndIF
	
EndIf

If MsgYesNo("Confirma a geração do pedido de venda da locação no valor de R$ " +AllTrim(Transform(nTotal,PesqPict("SF2","F2_VALBRUT"))) + " ?")
	MsAguarde( { || GeraPed(@cNumPed,nTotal,dInicio,dFim)  }, "Aguarde, gerando pedido.." )
	If Empty(cNumPed)
		MsgAlert("Houve erro ao gerar o pedido de vendas :(")
	Else                                                     
		MsgInfo("Pedido gerado! :)" +" -> " +cNumPed)
	EndIf
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Calc  ºAutor  ³Jackson E. de Deus      º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula o total                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Calc(nTotal,dInicio,dFim)

Local nI 
Local aGrid := aclone( oMsGD:aCols )
Local dDtIns
Local dDtRem
Local nVlPR := 0
Local nQtdDias := (dFim - dInicio)+1
Local nQtdComp := 30	//	Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1	// ALTERAR PARA CONSIDERAR O PERIODO -> DATA FIM - DATA INICIO
Local nVlDia := 0

For nI := 1 To Len(aGrid)
	
	If oMsGd:Acols[nI][1] == cUnCheck
		Loop
	EndIf
	
	If Ascan( _aPlan,{ |x| x == oMsGd:Acols[nI][9] } ) == 0
		AADD( _aPlan, oMsGd:Acols[nI][9]  )
	EndIf

	nVlrPatri := aGrid[nI][5]
	nVlPR := 0
	dDtIns := aGrid[nI][6]
	dDtRem := aGrid[nI][7]

	// instalacao posterior a data fim
	If ctod(dDtIns) > dFim
		Loop
	EndIf   
	                                       
	// remocao antes ou depois do periodo
	If !Empty(ctod(dDtRem))
		If ctod(dDtRem) < dInicio //.Or. ctod(dDtRem) > dFim
			Loop
		EndIf
	EndIf
	
	// pro rata   
	If lProRata
		// instalacao
		If ctod(dDtIns) >= dInicio
			nAux := ( dFim - ctod(dDtIns) )+1
			//nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1	// Total de dias do mes
			nVlDia := nVlrPatri / nQtdComp
			nVlPR := nVlDia * nAux
		EndIf
	
		// remocao
		If !Empty(ctod(dDtRem))	
			If ctod(dDtRem) <= dFim
				nAux := ( ctod(dDtRem) - dInicio )+1
				//nQtdComp := Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1	// Total Dias do mes
				nVlDia := nVlrPatri / nQtdComp
				nVlPR := nVlDia * nAux
			EndIf
		EndIf  
	EndIf
	
	// nao eh pro rata
	If nVlPR == 0
		//nQtdComp := nQtdDias	//Val(SUBSTR(CN9->CN9_XPCOMP,4,2)) - Val(SUBSTR(CN9->CN9_XPCOMP,1,2)) +1	// Total Dias do mes
		nVlDia := nVlrPatri / nQtdComp
		nTotal += nVlDia * nQtdDias
	// pro rata	
	Else 
		nTotal += nVlPR
	EndIf
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraPed  ºAutor  ³Jackson E. de Deus   º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o pedido de venda                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraPed(cNumPed,nTotal,dInicio,dFim)

Local cCodCli	:= CN9->CN9_CLIENT
Local cLjCli	:= CN9->CN9_LOJACL
Local aCab		:= {}
Local aItens	:= {}
Local aItem		:= {} 
Local cProd		:= "7000077"
Local cArmPad	:= Posicione( "SB1",1,xFilial("SB1") +AvKey(cProd,"B1_COD"),"B1_LOCPAD" )
Local cCusto	:= "70500005"
Local cItemCC	:= "0000010001SERVLOC"
Local cXGPV		:= U_TTUSRGPV(Alltrim(cUserName))
Local cMenNota	:= ""
Local cTpCli	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_TIPO")
Local cDescCli	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_NREDUZ")
Local lVldPedido := .F.
Local cPlans	:= ""
Private lMsErroAuto := .F.


If !Empty(CN9->CN9_XCLIFT) .And. !Empty(CN9->CN9_XLJFAT)
	If MsgYesNo("Esse contrato está parametrizado para utilizar outro cliente/loja no faturamento. Confirma essa mudança?")
		cCodCli := CN9->CN9_XCLIFT
		cLjCli := CN9->CN9_XLJFAT
	EndIf
EndIf

cMenNota := "COBRANCA REFERENTE A LOCAÇÃO NO PERIODO " +dtoc(dInicio) +" A " +dtoc(dFim)

//cNumPed := GetSx8Num("SC5","C5_NUMERO")
cNumPed := GetSxenum("SC5","C5_NUM")	

// Gera o pedido de venda
While !lVldPedido	
	lVldPedido := VldNumPed(cNumPed,cFilAnt)
	If !lVldPedido
		//RollBackSx8()
		cNumPed := Soma1(cNumPed)
	EndIf
End

	  		
Aadd(aItens,{{"C6_FILIAL"	,cFilAnt	,Nil},;
			{"C6_ITEM"   	,"01" 		,Nil},;
			{"C6_PRODUTO"	,cProd		,Nil},;
			{"C6_NUM"    	,cNumPed	,Nil},;
			{"C6_QTDVEN" 	,1			,Nil},; 
			{"C6_XQTDORI"	,1			,Nil},;
			{"C6_TPOP"		,"F"		,Nil},;
			{"C6_OPER"		,"62"		,Nil},;
			{"C6_PRCVEN"	,Round(nTotal,6)		,Nil},;
			{"C6_PRUNIT"	,Round(nTotal,6)		,Nil},;
			{"C6_VALOR"		,Round(nTotal,6)	,Nil},;
			{"C6_TES"		,"900"		,Nil},;
			{"C6_CLI"		,cCodCli	,Nil},;
			{"C6_LOJA"		,cLjCli		,Nil},;
			{"C6_LOCAL"		,cArmPad 	,Nil},;
			{"C6_CCUSTO"	,cCusto		,Nil},;
			{"C6_ITEMCC"	,cItemCC	,Nil},;
			{"C6_XGPV"		,cXGPV		,Nil},;
			{"C6_ENTREG"	,dDataBase	,Nil},; 
			{"C6_XDTEORI"	,DDATABASE	,Nil},;
			{"C6_UM"		,Posicione("SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_UM" )	,Nil},;
			{"C6_SEGUM"		,Posicione("SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_SEGUM" ),Nil},;
			{"C6_XHRINC"	,TIME()		,Nil},;
			{"C6_XDATINC"	,Date()		,Nil},;
			{"C6_XUSRINC"	,cUsername	,Nil}})


Aadd(aCab, {"C5_FILIAL" 	,cFilAnt			,Nil})
Aadd(aCab, {"C5_NUM"    	,cNumPed			,Nil})
Aadd(aCab, {"C5_TIPO"   	,"N"      			,Nil})
Aadd(aCab, {"C5_CLIENTE"	,cCodCli 			,Nil})
Aadd(aCab, {"C5_LOJACLI"	,cLjCli				,Nil})
Aadd(aCab, {"C5_CLIENT"		,cCodCli 			,Nil})
Aadd(aCab, {"C5_LOJAENT"	,cLjCli				,Nil})
Aadd(aCab, {"C5_XDTENTR"	,dDatabase			,Nil})
Aadd(aCab, {"C5_XNFABAS"	,"2"				,Nil})
Aadd(aCab, {"C5_XFINAL" 	,"8"				,Nil})
Aadd(aCab, {"C5_TRANSP" 	,"000019"			,Nil})
Aadd(aCab, {"C5_XTPCARG"	,"1"				,Nil})      
Aadd(aCab, {"C5_XHRPREV"	,"00:00"			,Nil})  
Aadd(aCab, {"C5_CONDPAG"	,CN9->CN9_CONDPG	,Nil})
Aadd(aCab, {"C5_MOEDA"		,1 					,Nil})
Aadd(aCab, {"C5_FRETE"		,0 					,Nil})
Aadd(aCab, {"C5_TXMOEDA"	,0 					,Nil})
Aadd(aCab, {"C5_EMISSAO"	,dDatabase			,Nil})
Aadd(aCab, {"C5_MENNOTA"	,cMenNota			,Nil})
Aadd(aCab, {"C5_ESPECI1"	,"UN"				,Nil})
Aadd(aCab, {"C5_XHRINC"		,TIME()				,Nil})
Aadd(aCab, {"C5_XDATINC"	,DATE()				,Nil})
Aadd(aCab, {"C5_XNOMUSR"	,cUserName			,Nil})
Aadd(aCab, {"C5_XCODUSR"	,__cUserID			,Nil})
Aadd(aCab, {"C5_TPFRETE" 	,"C" 				,Nil})
Aadd(aCab, {"C5_TIPOCLI"	,cTpCli				,Nil})
Aadd(aCab, {"C5_TIPLIB" 	,"1"         		,Nil})
Aadd(aCab, {"C5_VEND1"  	,"000023"			,Nil})
Aadd(aCab, {"C5_XDESCLI"	,cDescCli			,Nil})
Aadd(aCab, {"C5_VOLUME1"	,1					,Nil})
Aadd(aCab, {"C5_XGPV"	 	,cXGPV				,Nil})
Aadd(aCab, {"C5_XITEMCC"	,cItemCC			,Nil})
Aadd(aCab, {"C5_NATUREZ"	,CN9->CN9_NATURE	,Nil})

PUTMV("MV_1DUPNAT","SC5->C5_NATUREZ")

MSExecAuto({|x,y,z| MATA410(x,y,z)},aCab,aItens,3)

PUTMV("MV_1DUPNAT","SA1->A1_NATUREZ")

If !lMsErroAuto
/*dbSelectArea("SC5")
dbSetOrder(1)
If !msSeek( xfilial("SC5") +AvKey(cNumPed,"C5_NUM") )
	RollBackSx8()
	MostraErro()
	cNumPed := ""
	If lMsErroAuto
		MostraErro()	
	EndIf
Else
	ConfirmSX8() */
	
	For nI := 1 To Len(_aPlan)
		cPlans += _aPlan[nI]
		If nI <> Len(_aPlan)
			cPlans += "|"
		EndIf
	Next nI
	
	U_TTGENC01(xFilial("SC5"),"TTCNTLOC","FAT_LOCACAO","",CN9->CN9_NUMERO,"",cusername,dtos(date()),time(),nTotal,cNumPed +";"+DTOS(dInicio) +";" +DTOS(dFim) +";"+cPlans,CN9->CN9_CLIENT,CN9->CN9_LOJACL,"SC5")		
	_aPlan := {}
	fHist() 
else
	mostraerro()
EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldNumPed  ºAutor  ³Jackson E. de Deus º Data ³  05/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida o numero do pedido                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldNumPed(cNumPed,cFilAnt)

Local lRet := .T.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SC5")
cQuery += " WHERE C5_FILIAL = '"+cFilAnt+"' AND C5_NUM = '"+cNumPed+"' AND D_E_L_E_T_ = '' "

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