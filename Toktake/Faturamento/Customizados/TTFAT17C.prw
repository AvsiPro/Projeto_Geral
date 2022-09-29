#include "topconn.ch"
#include "protheus.ch"
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT17C บAutor  ณJackson E. de Deus   บ Data ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Roteirizacao das entregas - Gera as OS Mobile              บฑฑ
ฑฑบ          ณ Controle de Entregas										  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ06/04/15ณ01.00 |Criacao                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TTFAT17C()

Local oDlg    
Local aSize			:= MsAdvSize()
Local oLayer		:= FWLayer():new()
Local aAlter		:= {"ZR_HORA"}
Local cMotrta		:=  ""
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.) 
Private cKm			:= ""
Private cDtRom		:= Ctod(DtoC(dDatabase))
Private cMotor		:= space(6)
Private oTree
Private nKmtotal	:= 0
Private aNFCli		:= {}
Private aDados		:= {}
Private dDtAgend
Private aHeader		:= {}
Private aCols		:= {}
Private aColsIni	:= {}
Private lRotaOk		:= .F.
Private _cMarks		:= ""
Private lOSGerada	:= .F.

If cEmpAnt <> "01"
	Return
EndIf

// prepara aheader
fGrid()
                            
// Monta a tela
oDlg := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Entregas - OS",,,.F.,,,,,,.T.,,,.T. )	
	oLayer:Init(oDlg,.F.)	
	oLayer:addCollumn('COLUNA1',30,.F.)
	oLayer:addCollumn('COLUNA2',70,.F.)
	oLayer:addWindow("COLUNA1","WIN_1","Romaneios",90,.F.,.T.,{||} )
  	oLayer:addWindow("COLUNA2","WIN_2","Entregas",90,.F.,.T.,{||} ) 	
  	oPnlEsq := oLayer:GetWinPanel("COLUNA1","WIN_1" )
	oPnlDir := oLayer:GetWinPanel("COLUNA2","WIN_2" )	
	oPnlEsq:FreeChildren()
    oPnlDir:FreeChildren()
	
	// painel rodape
	oPanel5 := tPanel():New(0,0,"",oDlg,,,,,,0,030)
	oPanel5:SetCss( " QLabel { background-color: #D0D0D0 ; }" )
	oPanel5:align := CONTROL_ALIGN_BOTTOM
	
	// Menu popup
	MENU oMenu POPUP
	MENUITEM "Visualizar NF" ACTION ( VisNF() )
	ENDMENU
	                                                                        
	// Arvore
	cCSSTree := "QTreeWidget:item:hover { background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #e7effd, stop: 1 #cbdaf1); border: 1px solid #bfcde4; }"
	CSSDictAdd("TTree", cCSSTree)

	oTree := DbTree():New(0,0,0,0,oPnlEsq,{ || /*Visual()*/ },{ || /*RClick(oTree)*/ },.T.,,/*fonte*/)
    oTree:bRClicked := { |oObject,nX,nY| IIF(oTree:Nivel()==2,oMenu:Activate( nX, (nY-170), oObject ),/**/)  }
    oTree:Align := CONTROL_ALIGN_ALLCLIENT

	// grid
	oGrid := MsNewGetDados():New(0,0,0,0,GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,"AllwaysTrue()","","AllwaysTrue()",oPnlDir,aHeader,aCols,{ || /*troca linha*/ } )
	oGrid:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	oMotor := TGet():New( 05,05,{|u| If(PCount()>0,cMotor:=u,cMotor) },oPanel5,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{ || },.F.,.F.,"DA4","",,,,,,,"Motorista",2,oFont)	
 	oMotor:SetCss("QLineEdit { border: 1px solid gray; border-radius: 3px; color: #5C5C99; font: 14px; }")
	oDt := TGet():New( 05,100,{|u| If(PCount()>0,cDtRom:=u,cDtRom) },oPanel5,045,010,PesqPict("SF2","F2_XDTROM"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Data do romaneio",2,oFont)	
 	oDt:SetCss("QLineEdit { border: 1px solid gray; border-radius: 3px; color: #5C5C99; font: 14px; }")
 	    
    oBtPesq := TButton():New( 05,200,"Pesquisar",oPanel5,{|| IIF( !Empty(cMotor) .And. !Empty(cDtRom),Processa( { || CursorWait(),fTree(),CursorArrow() },"Verificando notas, aguarde.."), MsgInfo("Preencha os campos da pesquisa") ) },050,015,,,,.T.,,"",,,,.F. )
   	oBtPesq:SetCss( "QPushButton{  background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:LUPA.png); background-repeat: none; margin: 1px }" ) 
			        
	oMtsta := TSay():New( 20,05,{ || cMotrta },oPanel5,,oFont,.F.,.F.,.F.,.T.,,,250,010,,,,,,.F.) 
	oKm := TSay():New( 20,260,{ || cKm },oPanel5,,oFont,.F.,.F.,.F.,.T.,,,250,010,,,,,,.F.)
	oKm:SetCss(" QLabel {font: bold 12px; color: #CC0000; } ")
	
	oBtRota := TButton():New( 05, 260,"Rota",oPanel5,{ || IIF(!oTree:isEmpty() .And. !lOSGerada,Processa( { || CursorWait(),fRetRota(),CursorArrow() },"Roteirizando entregas, aguarde.."),/**/)  },050,015,,,,.T.,,"",,,,.F. )
   	oBtRota:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:CARGA.png); background-repeat: none; margin: 1px }" ) 
	/*
   	oBtMapa := TButton():New( 05, 310,"Mapa",oPanel5,{ || Processa( { || Mapa() },"Criando mapa, aguarde..") },050,015,,,,.T.,,"",,,,.F. )
   	oBtMapa:SetCss( "QPushButton{  background-color: #dadbde; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:web.png); background-repeat: none; margin: 1px; }" ) 
   	oBtMapa:Disable()*/
   	
  	oBtOk := TButton():New( 05, 360,"Gerar OS",oPanel5,{ || IIF(lRotaOk .And. !lOSGerada, Processa( { || CursorWait(),EnviaOS(oGrid:aCols,aNfCli,cMotor),CursorArrow() },"Gera็ใo de ordem de servi็o, aguarde.."),/**/)  },050,015,,,,.T.,,"",,,,.F. )
   	oBtOk:SetCss( "QPushButton{  background-color: #dadbde; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:dbg06.png); background-repeat: none; margin: 1px; }" ) 
   		
   	oBtSair := TButton():New( 05, 20,"Sair",oPanel5,{ || oDlg:End() },050,015,,,,.T.,,"",,,,.F. )
   	oBtSair:SetCss( "QPushButton{  background-color: #B9B9B9; border: 1px solid gray; border-radius: 3px; background-image: url(rpo:final.png); background-repeat: none; margin: 1px }" )

	oDlg:bStart = { || CoordBtn() }   
  
oDlg:Activate(,,,.T.,,,)	
                              
Return 
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisNF  บAutor  ณJackson E. de Deus     บ Data ณ  13/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualizacao da NF                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisNF()

Local aArea := GetArea()

If !oTree:IsEmpty()
	If oTree:Nivel() == 2
		nRecno := Val(oTree:getCargo())
		  
		// romaneio saida
		If _lNfSaida
			dbSelectArea("SF2")
			dbGoTo(nRecno)
			If Recno() == nRecno
				Mc090Visual("SF2",nRecno,2)
			EndIf
		// romaneio devolucao	
		Else
		 
			// visualizar a nota de entrada
			dbSelectArea("SF1")
			dbGoTo(nRecno)
			If Recno() == nRecno
				dbSelectArea("SD1")
				dbSetOrder(1)                     
				If dbSeek( xFilial("SD1") +AvKey(SF1->F1_DOC,"D1_DOC") +AvKey(SF1->F1_SERIE,"D1_SERIE") +AvKey(SF1->F1_FORNECE,"D1_FORNECE") +AvKey(SF1->F1_LOJA,"D1_LOJA")  )
					A103NFiscal('SF1',SF1->( Recno() ),1)
				EndIf
			EndIf
			
		EndIf
		
	EndIf
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCoordBtn  บAutor  ณJackson E. de Deus  บ Data ณ  13/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajusta posicao do botao Sair                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CoordBtn()

Local aCoord := oPanel5:GetClientRect()

oBtSair:Move(oBtSair:nTop+5,aCoord[3]-100,100,30,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTree     บAutor  ณJackson E. de Deus  บ Data ณ  13/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega a arvore dos romaneios/notas                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTree()

Local aAx := {}
Local aRom := {}
Local aNFs := {}
Local cSql := ""
Local cRomaneio := ""
Local nI, nJ, nK
Local cDescPa := ""
Local aInfo := {}

// romaneio de saida
If _lNfSaida
	cSql := "SELECT R_E_C_N_O_ REC, F2_XCARGA AS CARGA, F2_DOC AS DOC, F2_SERIE AS SERIE, F2_CLIENTE AS CLIFOR, F2_LOJA AS LOJA, F2_XCODPA AS CODPA, F2_XDTROM AS DTROM, F2_EMISSAO AS EMISSAO, F2_XNFABAS AS ABAST, F2_XFINAL AS FINAL FROM " +RetSQLName("SF2")  +" SF2 "
	cSql +=" WHERE SUBSTRING(F2_XMOTOR,1,6) = '"+cMotor+"' AND F2_XDTROM = '"+dtos(cDtRom)+"' AND F2_XRECENT = '' AND SF2.D_E_L_E_T_ = '' ORDER BY F2_XCARGA "
	
// romaneio de devolucao
Else 
	cSql := "SELECT R_E_C_N_O_ REC, F1_XCARGA AS CARGA, F1_DOC AS DOC, F1_SERIE AS SERIE, F1_FORNECE AS CLIFOR, F1_LOJA AS LOJA, '' AS CODPA, F1_XDTROM AS DTROM, F1_EMISSAO AS EMISSAO, '' AS ABAST, '' AS FINAL FROM " +RetSQLName("SF1")  +" SF1 "
	cSql +=" WHERE SUBSTRING(F1_XMOTOR,1,6) = '"+cMotor+"' AND F1_XDTROM = '"+dtos(cDtRom)+"' AND F1_XRECENT = '' AND SF1.D_E_L_E_T_ = '' ORDER BY F1_XCARGA "	
EndIf

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	

	If !Empty(TRB->CODPA)
		dbSelectArea("ZZ1")
		dbSetOrder(1)
		If dbSeek( xFilial("ZZ1") +AvKey( TRB->CODPA,"ZZ1_COD" ) )
			cDescPa := AllTrim(ZZ1->ZZ1_DESCRI)
		EndIf
	EndIf

	
	aOS := ChkOS(TRB->DOC, TRB->SERIE,_lNfSaida)
	AADD( aAx, { TRB->CARGA, TRB->DOC, TRB->SERIE, TRB->CLIFOR, TRB->LOJA, TRB->EMISSAO, TRB->CODPA, cDescPa, aOS, TRB->REC } )
	aOS := {}
	dbSelectArea("TRB")
	dbskip()
End

For nI := 1 To Len(aAx)
	If AScan( aRom, { |x| x[1] == aAx[nI][1] } ) == 0
		AADD( aRom, { aAx[nI][1], {} } )
	EndIf
Next nI

If Len(aRom) == 0
	MsgInfo("Nใo hแ dados!")
	Return                           
EndIf

// carregar arvore
If !oTree:isEmpty()
	oTree:Reset()
	If !lOSGerada		
		If Len(oGrid:aCols) > 0      
			aInfo := {}
			AAdd(aInfo, Array(Len(aHeader)+1))
			nLin := Len(aInfo)
			For nCol := 2 To Len(aHeader)
				If !aHeader[nCol][2] $ "T_DIST | T_TEMPO"
					aInfo[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
				Else
					If aHeader[nCol][2] == "T_DIST"                                                   
						aInfo[nLin][nCol] := CriaVar("A1_NREDUZ", .T.)
					ElseIf aHeader[nCol][2] == "T_TEMPO"                                                   
						aInfo[nLin][nCol] := CriaVar("ZR_HORA", .T.)
					EndIf
				EndIf
			Next nCol
			                 
			aInfo[nLin][Len(aHeader)+1] := .F.	
			oGrid:SetArray(aInfo)  
			oGrid:Disable()
		EndIf
	EndIf
EndIf

oTree:BeginUpdate()
For nI := 1 To Len(aRom)             
	For nJ := 1 To Len(aAx)
		If aRom[nI][1] == aAx[nJ][1]
			AADD( aRom[nI][2], aAx[nJ] )
		EndIf
	Next nJ
Next nI

For nI := 1 To Len(aRom)
	cRomaneio := PADR( aRom[nI][1], 30, " " )      
	aNFs := aclone(aRom[nI][2])
	If !oTree:TreeSeek( cRomaneio )
		oTree:AddTreeItem( cRomaneio,"HISTORIC",,cRomaneio )
	EndIf                

	If oTree:TreeSeek( cRomaneio )
		For nJ := 1 To Len(aNFs)
			cNumNF := aNFs[nJ][2]
			cRecno := cvaltochar(aNFs[nJ][10])
			cDescNF := PADR( cNumNF + "/" +Alltrim(aNFs[nJ][3]), 30, " " ) 
			
			If !oTree:TreeSeek( cRecno )
				oTree:AddItem( cDescNF ,cRecno, "S4WB005N",,,,2)				
			EndIf
				                                                       
			If oTree:TreeSeek( cRecno )
				aOS := Aclone(aNFs[nJ][9])
				For nK := 1 To Len(aOS)
					cNumOs := aOS[nK][1]
					cIMgOS := aOS[nK][3]
					cDescOS := PADR( AllTrim(cNumOS) +"-" +aOS[nK][2], 30, " " ) 
					
					If !oTree:TreeSeek( cNumOs )
						oTree:AddItem( cDescOS ,cNumOs, cImgOS,,,,3) 				
					EndIf
					oTree:TreeSeek( cRecno )
				Next nK
				oTree:TreeSeek( cRecno )
			EndIf
			oTree:TreeSeek( cRomaneio )
		Next nJ
	EndIf
Next nI

oTree:EndUpdate()	                  
oTree:EndTree()         

oMtsta:SetText( AllTrim(Posicione("DA4",1,xFilial("DA4")+cMotor,"DA4_NOME") ) )
oMtsta:Refresh()

Return

               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkOS     บAutor  ณJackson E. de Deus  บ Data ณ  13/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica as OS Mobile geradas para a nota fiscal           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkOS(cNumNF, cSerie,lSaida)

Local cSql := ""
Local aOS := {}
Default lSaida := .T.

cSql := "SELECT ZG_NUMOS, ZG_DESCFRM, ZG_STATUS, ZG_TPFORM FROM " +RetSqlName("SZG") +" WHERE ZG_TPFORM IN ('1','13') "
cSql += " AND ZG_DOC = '"+cNumNF+"' AND ZG_SERIE = '"+cSerie+"' AND D_E_L_E_T_ = '' "                            

If lSaida
	cSql += " AND ZG_TPDOC = '2' "
Else
	cSql += " AND ZG_TPDOC = '1' "
EndIf

If Select("TRBG") > 0
	TRBG->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRBG"

dbSelectArea("TRBG")
dbGoTop()
While !EOF()                                                    
	cImgStat := StaticCall( TTMONITOR,Status,AllTrim(TRBG->ZG_STATUS) )
	AADD( aOS, { TRBG->ZG_NUMOS, AllTrim(TRBG->ZG_DESCFRM), cImgStat, cvaltochar(TRBG->ZG_TPFORM) } )
	dbSkip()
End

TRBG->(dbCloseArea())

Return aOS

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetRota  บAutor  ณJackson E. de Deus  บ Data ณ  03/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca os dados e faz a roteirizacao                        บฑฑ
ฑฑบ          ณ Usa area de trabalho anterior - TRB (Arvore)               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fRetRota()

Local cSql			:= ""
Local oXml			:= Nil
Local aOS			:= {}
Local cXML			:= ""
Local cError		:= ""
Local cWarning		:= ""
Local cEndTT		:= "-23.5135419,-46.7345419"
Local cEndFim		:= ""
Local aWayPoints	:= {}
Local cHoraAgend	:= ""
Local nI,nJ,nY
Local nTotReg		:= 0
Local aInfo			:= {}
Local aCoord		:= {}
Local aAx			:= {} 
Local lProbl		:= .F.
Local cxlatNF		:= ""
Local cxlngNF		:= ""
Local aRotas		:= {}
Local aWP			:= {}
Local cEndIn		:= ""
Local cEndFn		:= ""
Local cxLatCoord	:= ""
Local cxLngCoord	:= ""
Local aStep			:= {}
Local cCliNF		:= ""
Local cLojaNF		:= ""
Local cCli			:= ""
Local cLoja			:= ""
Local nRecno		:= 0
Local nRecSA1		:= 0
Local cNReduz		:= ""
Local cEnd			:= ""
Local cMun			:= ""
Local cEst			:= ""
Local cLat			:= ""
Local cLng			:= ""
Local nDist			:= 0
Local cTempo		:= ""
Local aPerc			:= {}
Local cDist			:= ""
Local nSeg			:= 0 
Local cStatus		:= ""
Local cEndEntr		:= ""
Local nPosCoord		:= 0
Local cOSEnt		:= ""
Local lGAPIEmp		:= .F.	//SuperGetMV( "MV_XWSK021",.T.,.F. )	// acesso a API Google Maps pelo plano empresarial

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	nTotReg++
	dbSkip()
End         

_cMarks := ""
nKmtotal := 0
aNFCli := {}
aDados := {}
ProcRegua(nTotReg)
dbGoTop()
While !EOF()
	IncProc("NF: " +AllTrim(TRB->DOC) +"/" +AllTrim(TRB->SERIE) )
	cCliNF := AllTrim(TRB->CLIFOR)
	cLojaNF := AllTrim(TRB->LOJA)
	cCli := ""
	cLoja := ""
	
	cOSEnt := ""
	cOSCnf := ""
		
	If !Empty(TRB->CODPA) .And. AllTrim(TRB->ABAST) == "1" .And. AllTrim(TRB->FINAL) == "4"	// PA
		dbSelectArea("ZZ1")
		dbSetOrder(1)
		If dbSeek( xFilial("ZZ1") +AvKey( TRB->CODPA,"ZZ1_COD" ) )
			cCli := SubStr(ZZ1->ZZ1_ITCONT,1,6)
			cLoja := SubStr(ZZ1->ZZ1_ITCONT,7,4)
		EndIf
	EndIf
	
	If Empty(cCli) .And. Empty(cLoja)
		cCli := cCliNF
		cLoja := cLojaNF
	EndIf                                   
	  
	If _lNfSaida                                                                                                                     
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek( xFilial("SA1") +AvKey(cCli,"A1_COD") +Avkey(cLoja,"A1_LOJA") )
			nRecno := Recno()
			cNReduz := AllTrim( SA1->A1_NREDUZ )
			cEnd := AllTrim( SA1->A1_END )
			cMun := AllTrim( SA1->A1_MUN )
			cEst := AllTrim( SA1->A1_EST )
			cLat := AllTrim( SA1->A1_XLATDE )
			cLng := AllTrim( SA1->A1_XLNGDE )
			nDist := 0
			cTempo := ""
			
			If FieldPos("A1_XDISTTT") > 0 .And. FieldPos("A1_XTMPDIS") > 0
				nDist := Val(AllTrim( SA1->A1_XDISTTT ))
				cTempo := AllTrim( SA1->A1_XTMPDIS )
			EndIf
		    
			aOS := ChkOS( TRB->DOC, TRB->SERIE )
			For nI := 1 To Len(aOS)
				If aOS[nI][4] == "13"
					cOSEnt := aOS[nI][1]
				EndIf
			Next nI
		
			AADD( aNFCli, { AllTrim(TRB->DOC), AllTrim(TRB->SERIE), cCliNF, cLojaNF, cEnd, cMun,cEst, cLat, cLng, cNReduz, AllTrim(TRB->CODPA),;
							 nDist,0,cTempo,"","","",nRecno, STOD(TRB->DTROM), cCli, cLoja, STOD(TRB->EMISSAO), TRB->ABAST, TRB->FINAL, cOSEnt } )	
							 // distancia / tempo em seg. / tempo deslocamento / hora agendada / distancia formatada km / end formatado google / recno sa1
		EndIf
	// romaneio devolucao
	Else
		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek( xFilial("SA2") +AvKey(cCli,"A2_COD") +Avkey(cLoja,"A2_LOJA") )
			nRecno := Recno()
			cNReduz := AllTrim( SA2->A2_NREDUZ )
			cEnd := AllTrim( SA2->A2_END )
			cMun := AllTrim( SA2->A2_MUN )
			cEst := AllTrim( SA2->A2_EST )
			cLat := ""
			cLng := ""
			nDist := 0
			cTempo := ""
			
			aOS := ChkOS( TRB->DOC, TRB->SERIE )
			For nI := 1 To Len(aOS)
				If aOS[nI][4] == "13"
					cOSEnt := aOS[nI][1]
				EndIf
			Next nI
		
			AADD( aNFCli, { AllTrim(TRB->DOC), AllTrim(TRB->SERIE), cCliNF, cLojaNF, cEnd, cMun,cEst, cLat, cLng, cNReduz, AllTrim(TRB->CODPA),;
							 nDist,0,cTempo,"","","",nRecno, STOD(TRB->DTROM), cCli, cLoja, STOD(TRB->EMISSAO), TRB->ABAST, TRB->FINAL, cOSEnt } )	
							 // distancia / tempo em seg. / tempo deslocamento / hora agendada / distancia formatada km / end formatado google / recno sa1	
		EndIf	
			
	
	EndIf	

	dbSelectArea("TRB")
	dbSkip()
End


ProcRegua(2)
IncProc("Preparando dados..")
For nI := 1 To Len( aNFCLI )	 
	lCoord := .F.
	nPos1 := 0
	nRecSA1 := aNFCLI[nI][18]
		
	If Empty( aNFCLI[nI][8] ) .Or. Empty( aNFCLI[nI][9] )
		cEnd := aNFCLI[nI][5] +", " +aNFCLI[nI][6] +" - " +aNFCLI[nI][7]	// endereco
	Else
		cEnd := aNFCLI[nI][8] +"," +aNFCLI[nI][9]	// coordenadas
		lCoord := .T.
	EndIf
		
	If aNFCLI[nI][12] == 0 .Or. Empty( aNFCLI[nI][14] )
		nSeg := 0
		nDist := 0
		cTempo := ""
		cDist := ""
		
		// verifica se ja calculou antes o endereco
		If !lCoord
			nPos1 := Ascan( aNfCli, { |x| x[5] == aNFCLI[nI][5] .And. x[6] == aNFCLI[nI][6] .And. x[7] == aNFCLI[nI][7]  } )
		Else 
			nPos1 := Ascan( aNfCli, { |x| x[8] == aNFCLI[nI][8] .And. x[9] == aNFCLI[nI][9] } )		
		EndIf
		
		If nPos1 > 0
			aNFCLI[nI][12] := aNFCli[nPos1][12]
			aNFCLI[nI][13] := aNFCli[nPos1][13]
			aNFCLI[nI][14] := aNFCli[nPos1][14]
			aNFCLI[nI][16] := aNFCli[nPos1][16]
		Else				
			aPerc := {}
			aPerc := CalcDist(cEndTT,cEnd)
			nDist := aPerc[1]
			nSeg := aPerc[2]
			cDist := AllTrim( cValToChar( Round(nDist/1000,2) ) +" KM" )
			cTempo := IntToHora( nSeg/3600 ) //CalcSeg(nSeg)
			
			aNFCLI[nI][12] := nDist
			aNFCLI[nI][13] := nSeg
			aNFCLI[nI][14] := cTempo
			aNFCLI[nI][16] := cDist
			
			dbSelectArea("SA1")
			dbGoTo(nRecSA1)
			If Recno() == nRecSA1    
				If FieldPos("A1_XDISTTT") > 0 .And. FieldPos("A1_XTMPDIS") > 0
					If RecLock("SA1",.F.)
						SA1->A1_XDISTTT := cValToChar(nDist)
						SA1->A1_XTMPDIS := cTempo
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		aNFCLI[nI][16] := AllTrim( cValToChar( Round(aNFCLI[nI][12]/1000,2) ) +" KM" )
	EndIf
	
	aNFCLI[nI][17] := cEnd
Next nI

// pontos intermediarios
For nI := 1 To Len(aNFCLI)
	If Empty(aNFCLI[nI][8]) .Or. Empty(aNFCLI[nI][9])	// obrigatoria a existencia de coordenadas no cadastro do cliente
		
		If _lNfSaida
			If !fConv(aNFCLI[nI][20],aNFCLI[nI][21])
				lProbl := .T.
			EndIf
		EndIf
		
	EndIf
Next nI

If !lProbl
	aSort( aNFCLI,,,{ |x,y| x[8] < y[8] .And. x[9] < y[9]  } )
	For nI := 1 To Len(aNFCLI)
		If !Empty(aNFCLI[nI][8]) .And. !Empty(aNFCLI[nI][9])
			If Ascan( aWayPoints, { |x| x == aNFCli[nI][17] } ) == 0	// nao repetir enderecos
				AADD( aWayPoints, aNFCLI[nI][17] )                      
			EndIf
		EndIf
	Next nI
EndIf

// Empresarial - limite 23 pontos ref.
If lGAPIEmp
	If Len(aWayPoints) <= 23
		AADD( aRotas, aWayPoints  )
	Else
		lProbl := .T.
	EndIf	
// versao gratuita - limite 8 pontos ref.
Else
	// ate 8 pontos ref - Ok
	If Len(aWayPoints) <= 8
		AADD( aRotas, aWayPoints  )	
	// mais de 8 pontos ref -> quebrar as requisicoes
	Else
		For nI := 1 To Len(aWayPoints)
			AADD( aWP, aWayPoints[nI]  )
			If nI % 8 == 0 .Or. nI == Len(aWayPoints)
				AADD( aRotas, aWP  )
				aWP := {}
			EndIf
		Next nI
	EndIf
EndIf

IncProc("Calculando rotas..")
cHoraAgend := "07:30"
If !lProbl  
	For nY := 1 To Len(aRotas)	          
		aWP := Aclone(aRotas[nY])
        
		// definicao endereco origem
		If nY == 1
			cEndIn := cEndTT			// ponto inicial = endereco toktake
		Else 
			cEndIn := cEndFn			// ponto inicial = ultimo ponto anterior
		EndIf
		                            
		// definicao endereco destino
		If nY == Len(aRotas)
			cEndFn := cEndTT			// ultimo ponto = endereco toktake
		Else 
			cEndFn := aWP[Len(aWP)]		// ultimo ponto = ultimo cliente
			aDel(aWP,Len(aWP))			// exclui ultimo cliente do array
			aSize(aWP,Len(aWP)-1)
		EndIf	

		cXML := U_XGAPI01(cEndIn,cEndFn,aWP)
		oXml := XmlParser( cXml, "_", @cError, @cWarning )
	
		If oXml != Nil	
			cStatus := oXml:_DIRECTIONSRESPONSE:_STATUS:TEXT
			If cStatus != "OK"
				Conout("# TTFAT17C: " +cStatus)
			Else
				If XmlChildEx( oXml:_DIRECTIONSRESPONSE, "_ROUTE" ) != NIL
					If ValType(oXml:_DIRECTIONSRESPONSE:_ROUTE:_LEG) = "O"
					     XmlNode2Arr(oXml:_DIRECTIONSRESPONSE:_ROUTE:_LEG, "_LEG")
					EndIf
					aStep := oXml:_DIRECTIONSRESPONSE:_ROUTE:_LEG
					For nI := 1 To Len(aStep)
						cMetros := aStep[nI]:_DISTANCE:_VALUE:TEXT
						nKmtotal += Val(cMetros)
						cTempo := aStep[nI]:_DURATION:_VALUE:TEXT
						cEndIni := aStep[nI]:_START_ADDRESS:TEXT
						cEndFim := aStep[nI]:_END_ADDRESS:TEXT  
						
						cLatfim := aStep[nI]:_END_LOCATION:_LAT:TEXT
						cLngFim := aStep[nI]:_END_LOCATION:_LNG:TEXT
						
						AADD( aCoord, { cLatfim, cLngFim, cEndIni, cEndFim, cTempo, cMetros  } )
					Next nI
				EndIf
			EndIf
		EndIf		
	Next nY
	
	// para cada nota - verifica rota calculada e tempo
	If Len(aCoord) > 0
		For nI := 1 To Len(aNFCLI)
			nPosCoord := CalcCoord(aCoord,aNFCLI[nI][8],aNFCLI[nI][9])
		
			cTmpDsloc := IntToHora( Val(aCoord[nPosCoord][5])/3600 )
			cHoraAgend := StaticCall(TTOPER02,SmaHra,cHoraAgend,cTmpDsloc)
			cHoraAgend := StaticCall(TTOPER02,SmaHra,cHoraAgend,"00:30")
			If cHoraAgend > "23:59"
				cHoraAgend := "23:59"
			EndIf
			aNFCLI[nI][15] := cHoraAgend
			aNFCLI[nI][16] := AllTrim( cValToChar( Round(Val(aCoord[nPosCoord][6])/1000,2) ) +" KM" )
			cEndEntr:= aNFCLI[nI][5]+"," +aNFCLI[nI][6] +" - " +aNFCLI[nI][7]                
			
			AADD(aAx, { "BR_VERMELHO",aNFCLI[nI][1], aNFCLI[nI][2], aNFCLI[nI][3], aNFCLI[nI][4], aNFCLI[nI][10],;
						cEndEntr, aNFCLI[nI][16], StrTran(cTmpDsloc,".",":"), aNFCLI[nI][15] } )			
						
			_cMarks += aCoord[nPosCoord][1] +"," +aCoord[nPosCoord][2] +"," +cvaltochar(nI) +"," +StrTran(aNFCLI[nI][10]," ","+")
			If nI <> Len(aNFCLI)
				_cMarks += "&"
			EndIf			
		
		Next nI
	EndIf
	If Len(aAx) == Len(aNFCli)
		aDados := Aclone(aAx)
	Else
		lProbl := .T.
	EndIf	
EndIf

// roteirizacao burra => entrega mais perto -> mais longe
If lProbl
	aSort( aNFCLI,,,{ |x,y| x[12] < y[12] } )
	For nI := 1 To Len(aNFCLI)
		cTmpDsloc := aNFCLI[nI][14]
		cHoraAgend := StaticCall(TTOPER02,SmaHra,cHoraAgend,cTmpDsloc)
		cHoraAgend := StaticCall(TTOPER02,SmaHra,cHoraAgend,"00:30")
		If cHoraAgend > "23:59"
			cHoraAgend := "23:59"
		EndIf
		aNFCLI[nI][15] := cHoraAgend
		
		cEndEntr := aNFCLI[nI][5] +"," +aNFCLI[nI][6] +" - " +aNFCLI[nI][7]
		
		AADD(aDados, { "BR_VERMELHO",aNFCLI[nI][1], aNFCLI[nI][2], aNFCLI[nI][3], aNFCLI[nI][4], aNFCLI[nI][10],;
						 cEndEntr, aNFCLI[nI][16], aNFCLI[nI][14], aNFCLI[nI][15] } )
		
		If !Empty(aNFCLI[nI][8]) .And. !Empty(aNFCLI[nI][9])				 
			_cMarks += aNFCLI[nI][8] +"," +aNFCLI[nI][9] +"," +cvaltochar(nI) +"," +StrTran(aNFCLI[nI][10]," ","+")
			If nI <> Len(aNFCLI)
				_cMarks += "&"
			EndIf
		EndIf		
	Next nI
EndIf
	
// carrega acols
If Len(aDados) > 0
	lRotaOk := .T.
	For nI := 1 To Len(aDados)
		AAdd(aInfo, Array(Len(aHeader)+1))
		nLin := Len(aInfo)
		For nCol := 1 To Len(aHeader)
			aInfo[nLin][nCol] := aDados[nI][nCol]
		Next nCol
		                 
		aInfo[nLin][Len(aHeader)+1] := .F.	
	Next nI
                          
	oGrid:SetArray( aInfo, .T. )
	oGrid:Enable()
	oGrid:Refresh(.T.)	  
	oGrid:GoTop()
	
 	//oBtMapa:Enable()

	cKm	:= "Km total estimado: " +cvaltochar(Round(nKmtotal/1000,2))
	oKm:SetText(cKm)
	oKm:Refresh()
EndIf                        	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaOS  บAutor  ณJackson E. de Deus   บ Data ณ  03/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera as Ordens de Servico Mobile                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaOS(aAux,aNfCli,cMotor)

Local nI   
Local aDoc		:= {}
Local cDtAgen	:= ""
Local cHoraAgen	:= ""
Local cCli		:= ""
Local cLoja		:= ""
Local nPos
Local cDadosCnt	:= ""
Local cPA		:= ""
Local cNumOS	:= ""
Local nTpEntr	:= 13
Local cRelConf	:= ""	// relacao de conferentes
Local nQtdOS	:= 0
Local oDlg1         
Local oGpr1,oSayDT,oBtn
Local lDataOk	:= .F.
Local lAbast	:= .F.
Local aArea		:= GetArea()
Local cXDTEntr	:= Ctod(DtoC(dDatabase))
Local aDados	:= {}
Local cLocal	:= ""
Local cEndereco	:= ""

dbSelectArea("AA1")
dbSetOrder(1)
dbSeek( xFilial("AA1") +AvKey(cMotor,"AA1_CODTEC") )

// define data da entrega
oDlg1 := MSDialog():New( 167,287,280,628,"Data de entrega",,,.F.,,,,,,.T.,,,.T. )
	oSayDT := TGet():New( 016,020,{|u| If(PCount()>0,cXDTEntr:=u,cXDTEntr) },oDlg1,045,010,PesqPict("SF2","F2_XDTROM"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Data de entrega",1)	
	oBtn	:= TBtnBmp2():New( 60, 297, 40, 40, 'OK'		, , , ,{ || oDlg1:End()  } , oDlg1, "Confirmar" , ,)
oDlg1:Activate(,,,.T.)

If Empty(cXDTEntr)
	MsgAlert("Configurar data de entrega!")
	Return
EndIf

dDtAgend := cXDTEntr


dbSelectArea("SZG")
dbSetOrder(1)

CursorWait()
procregua(Len(aAux))
For nI := 1 To Len(aAux)
	IncProc( "NF " +aAux[nI][2] +"/" +aAux[nI][3] )
	
	If Empty(aAux[nI][2])
		Loop
	EndIf

	If !Empty(aNfCli[nI][25])
		If MsSeek( xFilial("SZG") +AvKey(aNfCli[nI][25],"ZG_NUMOS") )
			If !AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC|CCLI"
				Loop
			EndIf
		EndIf
	EndIf
	
	aDocEntr := {}
	nPos := 0                    
	cPa := ""
	cCli := ""
	cLoja := ""   
	cCliNF := ""
	cLjNF := ""
	cRelConf := ""
	cHoraAgen := ""
	cDadosCnt := ""
	cNumOS := ""
	cEndereco := ""
	
	cCliNF := aAux[nI][4]
	cLjNF := aAux[nI][5]

	nPos := Ascan( aNFCli, { |x| Alltrim(x[1]) == AllTrim(aAux[nI][2]) .And. AllTrim(x[2]) == AllTrim(aAux[nI][3]) } )
	If nPos > 0 
				
		If Empty(cCli) .And. Empty(cLoja)
			cCli := cCliNF
			cLoja := cLjNF
		EndIf
		
		cEndereco += AllTrim(aNFCLI[nPos][5]) +"," +AllTrim(aNFCLI[nPos][6]) +"," +AllTrim(aNFCLI[nPos][7])
 		
 		// PA   
		If !Empty(aNFCLI[nPos][11])	
			If AllTrim(aNFCLI[nPos][23]) == "1" .And. AllTrim(aNFCLI[nPos][24]) == "4" .And. SubStr(aNFCLI[nPos][11],1,1) == "P"
				cPa := aNFCLI[nPos][11]
				cCli := aNFCLI[nPos][20]
				cLoja := aNFCLI[nPos][21] 
			
			 
				If !Empty(cPa)
					cLocal := Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(cPA,"ZZ1_COD"),"ZZ1_DESCRI" )
				EndIf
			EndIf								
		// CLIENTE
		Else
			cLocal := AllTrim(aNFCLI[nPos][10])
		EndIf
	EndIf

	cDtAgen := dDtAgend
	cHoraAgen := aAux[nI][10]
	If "." $ cHoraAgen
		cHoraAgen := StrTran(cHoraAgen,".",":")
	EndIf
                                 
	cDadosCnt := "Nota fiscal: " +aAux[nI][2]+"/" +aAux[nI][3] +" PA: " +cPa +" Data de entrega: " +DtoC(cDtAgen)
	                          	
	// os de entrega                                                                                                           
	cHoraAgen += ":00"

	aDados := { "13",;
				"ENTREGAS",;
				AllTrim(AA1->AA1_CODTEC),;
				AllTrim(AA1->AA1_NOMTEC),;
				"",;
				"",;
				"",;
				"",;
				cDtAgen,;
				cHoraAgen,;
				ALLTRIM(Posicione( "SA1", 1, xFilial("SA1")+AvKey(cCliNF,"A1_COD") +AvKey(cLjNF,"A1_LOJA"),"A1_NREDUZ" )),;
				cEndereco,;
				"",;
				cDadosCnt,;
				"",;
				cLocal,;
				AllTrim(aNFCLI[nPos][1]),;
				AllTrim(aNFCLI[nPos][2]),;
				IIF(_lNfSaida,"2","1"),;
				cCliNF,;
				cLjNF,;
				{},;
				"",;
				"" }
							
	cNumOS := U_MOBILE(aDados)
	
	
	If !Empty(cNumOs)
		If Val(cNUmOS) > 0
			nQtdOS++
			oGrid:aCols[nI][1] := "BR_VERDE"
			oGrid:Refresh()
		EndIf
	EndIf
Next nI
CursorArrow()

If nQtdOS > 0
	lOSGerada := .T.
	fTree()
	
	U_TTGENC01( xFilial("SF2"),"TTFAT17","ROMANEIO","",cMotor,,cUserName,dtos(date()),time(),,"KM ESTIMADO: "+cvaltochar(nKmTotal),,,"SF2" )		    	
EndIf

RestArea(aArea)

Return nQtdOS



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrid  บAutor  ณJackson E. de Deus     บ Data ณ  03/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara o aHeader e Acols                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGrid()

Local nI,nLin
         
Aadd(aHeader, {" ","LEGPAT", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})

// aheader
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("F2_DOC")
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )

dbSeek("F2_SERIE")
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )

dbSeek("F2_CLIENTE")
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )

dbSeek("F2_LOJA")
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )

dbSeek("A1_NOME")
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )

dbSeek("A1_END")
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
// distancia km
dbSeek("A1_NREDUZ")
 AADD(aHeader,{"Distancia","T_DIST",SX3->X3_PICTURE,15,SX3->X3_DECIMAL,SX3->X3_VALID,;
 			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )     

// tempo deslocamento
dbSeek("ZR_HORA")
AADD(aHeader,{"Deslocamento","T_TEMPO",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX, SX3->X3_RELACAO } )

// hora agendada
AADD(aHeader,{Trim(X3Titulo()),	SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcDist  บAutor  ณJackson E. de Deus  บ Data ณ  03/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula a distancia entre dois pontos                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcDist(cOrigem,cDestino)
                                         
Local cXml		:= ""
Local cError	:= ""
Local cWarning	:= ""
Local aDados	:= {} 
Local nDist		:= 0
Local cTipo		:= "xml"
Local cRet		:= ""  
Local nTempo	:= 0
Local aRet		:= {0,0,""}

Default cOrigem := ""
Default cDestino := ""

If Empty(cOrigem) .Or. Empty(cDestino)
	Return aRet
EndIf

If " " $ cOrigem
	cOrigem := StrTran(cOrigem," ","+")
EndIf                                

If " " $ cDestino
	cDestino := StrTran(cDestino," ","+")
EndIf  
       

cRet := U_XGAPI06(cTipo,cOrigem,cDestino)

// retorno em xml
If cTipo == "xml"
	/*
	OK: indica que a resposta cont้m um result vแlido.
	INVALID_REQUEST: indica que a solicita็ใo fornecida ้ invแlida.
	MAX_ELEMENTS_EXCEEDED: indica que o produto de origem vezes o destino excede o limite por solicita็ใo.
	OVER_QUERY_LIMIT: indica que o servi็o recebeu muitas solicita็๕es de seu aplicativo no perํodo de tempo permitido.
	REQUEST_DENIED: indica que o servi็o negou o uso da Matriz de distโncias ao seu aplicativo.
	UNKNOWN_ERROR:ทindica que nใo foi possํvel processar uma solicita็ใo da Matriz de distโncias devido a um erro do servidor. A solicita็ใo pode ser processada; tente novamente.
	*/
	If Empty(cRet)
		Return nDist
	EndIf
	oXml := XmlParser( cRet, "_", @cError, @cWarning )
	If oXml == NIL
		//MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
		Return aRet
	Endif
	If AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_STATUS:TEXT ) == "OK"
		If  AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_ROW:_ELEMENT:_STATUS:TEXT ) == "OK"                                
			nTempo := Val( oXml:_DISTANCEMATRIXRESPONSE:_ROW:_ELEMENT:_DURATION:_VALUE:TEXT )	// duracao - segundos
			nDist := Val( oXml:_DISTANCEMATRIXRESPONSE:_ROW:_ELEMENT:_DISTANCE:_VALUE:TEXT )
			cDistKm := AllTrim(oXml:_DISTANCEMATRIXRESPONSE:_ROW:_ELEMENT:_DISTANCE:_TEXT:TEXT)
			aRet[1] := nDist
			aRet[2] := nTempo
			aRet[3] := cDistKm
		EndIf
	ElseIf AllTrim( oXml:_DISTANCEMATRIXRESPONSE:_STATUS:TEXT ) $ "INVALID_REQUEST|OVER_QUERY_LIMIT|REQUEST_DENIED"
		// SERVICO NEGADO
		U_TTMAILN('microsiga@toktake.com.br','jdeus@toktake.com.br','Google API',oXml:_DISTANCEMATRIXRESPONSE:_ERROR_MESSAGE:TEXT,{},.F.)
		Return aRet
	EndIf
EndIf	

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcCoord  บAutor  ณJackson E. de Deus บ Data ณ  30/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Procura equivalencia de coordenadas com base em aprox de   บฑฑ
ฑฑบ          ณ latitude e longitude                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcCoord(aCoord,cLatCli,cLngCli)

Local nI
Local aAX := AClone(aCoord)
Local nDif := 0
Local nDif2 := 0
Local aDif := {}
Local nLatCli := Val(cLatCli)
Local nLngCli := Val(cLngCli) 
Local nPosArr := 0
                
For nI := 1 To Len(aAX)
	aAx[nI][1] := Val(aAx[nI][1]) 	
	aAx[nI][2] := Val(aAx[nI][2]) 	
Next nI

For nI := 1 To Len(aAX)
	nDif := ABS( aAx[nI][1] - nLatCli )	
	nDif2 := ABS( aAx[nI][2] - nLngCli )
	AADD( aDif, { nDif, nDif2, nI  } )	
Next nI

aSort( aDif,,,{ |x,y| x[1] < y[1] .And. x[2] < y[2] } )

nPosArr := aDif[1][3]

Return nPosArr

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConv  บAutor  ณJackson E. de Deus     บ Data ณ  30/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Converte o endereco do cliente em coordendas e ja grava    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fConv(cCliente,cLoja)

Local aArea := GetArea()
Local cRet := ""
Local lRet := .F.
Local oXml := Nil
Local cError := ""
Local cWarning := ""
Local cLat := ""
Local cLng := ""
Local cTipo := "xml"

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek( xFilial("SA1") +AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
	If Empty(SA1->A1_XLATDE) .And. Empty(SA1->A1_XLNGDE)
		// API GOOGLE GEOCODE
		cRet := U_XGAPI03(cTipo,AllTrim(SA1->A1_END) +"," +Alltrim(SA1->A1_MUN) +"," +AllTrim(SA1->A1_EST))
		If !Empty(cRet)	
			oXml := XmlParser( cRet, "_", @cError, @cWarning )
			If oXml != Nil
				If XmlChildEx( oXml, "_GEOCODERESPONSE" ) != NIL 			
					If XmlChildEx( oXml:_GEOCODERESPONSE, "_RESULT" ) != NIL
						If ValType(oXml:_GEOCODERESPONSE:_RESULT) != "A"
							If XmlChildEx( oXml:_GEOCODERESPONSE:_RESULT, "_GEOMETRY" ) != NIL
								 If XmlChildEx( oXml:_GEOCODERESPONSE:_RESULT:_GEOMETRY, "_LOCATION" ) != NIL
					
									cLat := AllTrim( oXML:_GEOCODERESPONSE:_RESULT:_GEOMETRY:_LOCATION:_LAT:TEXT ) 	
									cLng := AllTrim( oXML:_GEOCODERESPONSE:_RESULT:_GEOMETRY:_LOCATION:_LNG:TEXT ) 	
									If !Empty(cLat) .And. !Empty(cLng)
										RecLock("SA1",.F.)
										SA1->A1_XLATDE := cLat
										SA1->A1_XLNGDE := cLng
										MsUnLock()
										lRet := .T.
									EndIf
								EndIf
							EndIf
						EndIf	
					EndIf
				EndIf				
			EndIf
		EndIf
	EndIf	
EndIf	

RestArea(aArea)
	
Return lRet		