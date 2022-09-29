#include 'PROTHEUS.CH'
#include 'RWMAKE.CH'
#include 'FONT.CH'
#include 'COLORS.CH'
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCNTA18  บAutor  ณJackson E. de Deus  บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera็ใo das doses dos patrim๔nios por contrato.           บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ18/12/13ณ01.00 |Criacao                               ณฑฑ 
ฑฑณJackson	       ณ13/10/14ณ01.01 |Inc. novos campos de doses - N1_XPx   ณฑฑ 
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTCNTA18()

Local oLayer		:= FWLayer():new()
Local bTudoOk		:= {|| Alterar() }
Local bCancel		:= {|| MsUnLockAll(),oDlg:End()}
Local nTamanho		:= 100
Local aHead			:= {" ","Patrim๔nio","Loja"}
Local aTam			:= {5,10,10}
Private oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Private oNao		:= LoadBitMap(GetResources(), "BR_VERMELHO")
Private aFldPs		:= {}
Private aDimension	:= MsAdvSize()
Private oFont		:= TFont():New('Arial',,-12,.T.,.T.)
Private oList            
Private aPatrim		:= {}
Private aValores	:= {}
Private cCodCli		:= CN9->CN9_CLIENT
Private cLojaCli	:= CN9->CN9_LOJACL
Private cCliente	:= CN9->CN9_CLIENT +"-" +GetAdvFVal("SA1","A1_NREDUZ",xFilial("SA1")+CN9->CN9_CLIENT,1) 
Private cContrato	:= CN9->CN9_NUMERO
Private cCodTab		:= ""	// Tabela de preco
Private cDescProd	:= ""
Private cPatrimo	:= ""
Private nPosREc		:= 0
Private nPosPatr	:= 2
Private nPosPatDsc	:= 0
Private nPosVol		:= 0
Private cPictXP		:= If(cEmpAnt == "01",PesqPict("SN1","N1_XP1"),"")
Private cPictVol	:= "@E 99,999"	//PesqPict("SN1","N1_XVOLMIN")

If cEmpAnt == "01"
	
	dbSelectArea("SN1")
	For nI := 1 To 25
		cCampo := "P"+cvaltochar(nI)
		cCampoN1 := "N1_XP"+cvaltochar(nI)
		If FieldPos( cCampoN1 ) > 0
			AADD( aFldPs, cCampoN1 )
			AADD( aHead, cCampo )
			AADD( aTam, 10 )
		EndIf
	Next nI
	AADD( aHead, "Vol Min" )
	AADD( aTam, 10 )
	
	nPosVol := Len(aHead)
	
	// busca tabela de preco do cliente
	cCodTab := ChkTab()
	If Empty(cCodTab)
		Aviso("","Nใo existe tabela de pre็o para o cliente."+CRLF +"Escolha uma tabela.",{"Ok"})	
		
		oDlgX := MSDialog():New( 230,300,425,640,"Tabela de Pre็o",,,.F.,,,,,,.T.,,,.T. )
			oSay  := TSay():New( 005,005,{||"Escolha a tabela de pre็o"},oDlgX,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
		
			oGrp1 := TGroup():New( 017,002,080,170,"",oDlgX,CLR_BLACK,CLR_WHITE,.T.,.F. )
			@ 025,030 Say "Tabela de Pre็o" 
			@ 035,030 MSGET cCodTab F3 "DA0" PICTURE	PesqPict("DA0","DA0_CODTAB") OF oDlgX SIZE 050,008 PIXEL HASBUTTON							
			oSBtn1	:= SButton():New( 070,076,1,{|| oDlgX:End() },oDlgX,.T.,"", )
		oDlgX:Activate(,,,.T.)
	EndIf
	
	If Empty(cCodTab)
		Return
	EndIf       
	
	CarregaPrc()	// carrega tabela de precos
	
	Carregar()		// busca os patrimonios  
	
	If Empty(aPatrim)
		Aviso("TTCNTA18","ERRO",{"Ok"})
		Return
	EndIf
	
	oDlg := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Amarrar Produtos ao Patrimonio",,,.F.,,,,,,.T.,,,.T. )	   
		oLayer:init(oDlg,.T.)
	
		oLayer:addLine("LN_CAB",20,.F.)
		oLayer:addLine("LN_GRID1",75,.F.)
		
		oLayer:addCollumn("COL_CAB",100,.f.,"LN_CAB")
		oLayer:addCollumn("COL_GRID1",100,.f.,"LN_GRID1")
		
		oLayer:addWindow("COL_CAB","WIN_CAB","Informa็๕es Gerais",100,.F.,.F.,{||},"LN_CAB")
		oLayer:addWindow("COL_GRID1","WIN_GRID1","Patrim๔nios",100,.F.,.F.,{||},"LN_GRID1")
	
		oPnlCab := oLayer:GetWinPanel("COL_CAB","WIN_CAB","LN_CAB")
		oPnlGrid1 := oLayer:GetWinPanel("COL_GRID1","WIN_GRID1","LN_GRID1")
		    
		oPnlCab:FreeChildren()
		oPnlGrid1:FreeChildren()
	
		// Cabecalho                                                                                                                                               
		oSay1      := TSay():New( 05,0,{ || "Cliente: " +cCliente},oPnlCab,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
		oSay2      := TSay():New( 05,0,{ || "Contrato: " +cContrato},oPnlCab,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oSay3      := TSay():New( 05,0,{ || "Tabela de pre็o: " +cCodTab},oPnlCab,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
		oSay4      := TSay():New( 10,0,{ || "Produto: " +cDescProd},oPnlCab,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
		oSay5      := TSay():New( 10,150,{ || "Patrimonio: " +cPatrimo},oPnlCab,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
	
		oSay1:Align := CONTROL_ALIGN_LEFT
		oSay2:Align := CONTROL_ALIGN_LEFT
		oSay3:Align := CONTROL_ALIGN_LEFT
	
		// tcbrowse patrimonios
		oList := TCBrowse():New(0,0,0,0,,aHead,aTam,oPnlGrid1,,,,{|| TrocaLinha()},/*{ || Marca() }*/,,,,,,,.F.,,.T.,{ || Len(aPatrim) > 0},.F.,,.T.,.T.,)
		oList:Align	:= CONTROL_ALIGN_ALLCLIENT
		oList:SetArray(aPatrim)
		  
		oList:bLine := { || Linha() }  
		               
		oList:bLDblClick	:= { || EditCell() }
		oList:nScrollType := 1 //SCROLL VRC   
	  
	oDlg:Activate(,,,.T.,,,EnchoiceBar(oDlg,bTudoOk,bCancel)) 
EndIF

Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLinha	     บAutor  ณJackson E. de Deus บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao das linhas do TcBrowse							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function Linha()
             
Local aLinha := {}
Local nI,nPos

aLinha := { IIF(aPatrim[oList:nAt,01],oOk,oNao),; 
							 aPatrim[oList:nAt,02],;					
							 aPatrim[oList:nAt,03] }

// campos doses - P's							 
For nI := 1 to Len(aFldPs)            
	nPos := nI+3
	AADD( aLinha, aPatrim[oList:nAt,nPos] )
Next nI

// volume minimo
AADD( aLinha, Transform( aPatrim[oList:nAt,nPosVol], cPictVol) )							 

Return aLinha

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditCell   บAutor  ณJackson E. de Deus บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Edicao de celulas										  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function EditCell()

Local xValbkp	:= ""
Local lOK		:= .F.
Local lCadOk	:= .F.
Local cPict		:= ""
Local nI		:= 0
Local aAlter	:= {}
Local nPos		:= 0
				
For nI := 1 To Len(aFldPs)
	nPos := nI+3
	AADD( aAlter, { nPos, cPictXP } )
Next nI
AADD( aAlter, { Len(aAlter)+4, cPictVol }  ) 					
					
If cvaltochar(oList:colPos) $ "1 | 2 | 3"
	Return
EndIf

// busca a picture correta do campo
For nI := 1 To Len(aAlter)
	If aAlter[nI][1] == oList:ColPos
		cPict := aAlter[nI][2]
		Exit
	EndIf
Next nI

xValbkp := oList:AArray[oList:nAt][oList:colPos]
lEditCell(@oList:aArray,oList, cPict ,oList:ColPos )	

If oList:ColPos <> nPosVol
	If !Empty(oList:AArray[oList:nAt][oList:colPos])
		dbSelectArea("SB1")
		dbSetOrder(1)
		If !dbSeek(xFilial("SB1") +AvKey( oList:AArray[oList:nAt][oList:colPos],"B1_COD") )
			Aviso("","Preencha um produto vแlido.",{"Ok"})
			oList:AArray[oList:nAt][oList:colPos] := xValbkp
			
			oList:Refresh()
			Return	 	
		EndIf
		
		// Valida se o produto digitado esta na tabela de preco escolhida
		For nI := 1 To Len(aValores)
			If AllTrim(aValores[nI]) == AllTrim(oList:AArray[oList:nAt][oList:colPos])
				lOK := .T.
				Exit
			EndIf
		Next nI
		
		If !lOK
			Aviso("TTCNTA18","O produto nใo estแ na tabela de pre็o."+CRLF +"Cadastre os valores na tela a seguir.",{"Ok"})
			lCadOK := CadProd()
			If !lCadOk
				Aviso("TTCNTA18","O produto nใo foi cadastrado, nใo poderแ ser utilizado.",{"Ok"})
				oList:AArray[oList:nAt][oList:colPos] := xValbkp	 	
			EndIf
		EndIf       				
	EndIf
EndIf

oList:Refresh()

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrocaLinha บAutor  ณJackson E. de Deus บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracoes de texto no cabecalho a cada troca de linha	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function TrocaLinha()

Local cCodProd := ""
Local aArea := GetArea() 
Local nCont := 0
Local nI	:= 0

If oList:ColPos <> 1 .And. oList:ColPos <> 2 .And. oList:ColPos <> 3 .And. oList:ColPos <> nPosVol .And. oList:ColPos > 0
	cCodProd := oList:aArray[oList:nAt][oList:ColPOs]
	cDescProd := AllTrim( GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cCodProd,1) )
	oSay4:SetText("")
	oSay4:SetText("Produto: " +cDescProd)
EndIf

If oList<>NIl
	cPatrimo := AllTrim( oList:aArray[oList:nAt][nPosPatr] ) +" - " +AllTrim(aPatrim[oList:nAt][nPosPatDsc] )
	oSay5:SetText("")
	oSay5:SetText("Patrim๔nio: " +cPatrimo)
EndIf             

     
oList:Refresh()                                            
oDlg:Refresh()
    
RestArea(aArea)

Return 
             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlterar บAutor  ณJackson E. de Deus 	 บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera os patrim๔nios									  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Alterar()

If !MsgYesNO("Deseja alterar os patrim๔nios?")
	Return
EndIf

Processa( {|| Grava()   },"Alterando cadastros, aguarde..")
    
Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrava บAutor  ณJackson E. de Deus 	 บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera os patrim๔nios									  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Grava()
                          
Local nI := 0
Local nJ := 0
Local lVazio := .F.

dbSelectArea("SN1")
ProcRegua(Len(oList:aArray))
For nI := 1 To Len(oList:aArray)
	IncProc("Patrim๔nio " +aPatrim[nI][2])
	SN1->( dbGoTo(aPatrim[nI][nPosRec]) )
	lVazio := .F. 
	If RecLock("SN1",.F.)                             
		For nJ := 1 To Len(aFldPs)
			nPos := nJ+3
			If SN1->&(aFldPs[nJ]) <> oList:aArray[nI][nPos]
				SN1->&(aFldPs[nJ]) := oList:aArray[nI][nPos]   
			EndIf
			If Empty(SN1->&(aFldPs[nJ]))
				lVazio := .T.
			EndIf
		Next nJ
		If SN1->N1_XVOLMIN <> oList:AArray[nI][nPosVol]
			SN1->N1_XVOLMIN := oList:AArray[nI][nPosVol]   
		EndIf
		
		SN1->( MsUnLock() )
		If !lVazio
			oList:aArray[nI][1] := .T.
		EndIf
	EndIf
Next nI

Return


                         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkTab บAutor  ณJackson E. de Deus 	 บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica tabela de preco									  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkTab()

Local cQuery := ""
Local cTabela := ""

cQuery := "SELECT DA0_CODTAB FROM " +RetSqlName("DA0") +" WHERE DA0_XCLIEN = '"+cCodCli+"' AND DA0_XLOJA = '"+cLojaCli+"' AND D_E_L_E_T_ = '' "

If Select("TRBD") > 0
	TRBD->( dbCloseArea() )
EndIf

TcQuery cQuery New Alias "TRBD"

dbSelectArea("TRBD")
cTabela := TRBD->DA0_CODTAB                          

dbCloseArea()

Return cTabela

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregaPrc บAutor  ณJackson E. de Deus บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega produtos da tabela de preco						  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CarregaPrc()

Local cQuery := ""

cQuery := "SELECT DA1_CODPRO "
cQuery += " FROM " +RetSqlName("DA1")
cQuery += " WHERE DA1_CODTAB = '"+cCodTab+"' AND DA1_ATIVO = '1' AND D_E_L_E_T_ = '' "

If Select("TRBPRC") > 0
	TRBPRC->(dbCloseArea())
EndIf
     
TcQuery cQuery New Alias "TRBPRC"
dbSelectArea("TRBPRC")
While !EOF()
	AADD(aValores, TRBPRC->DA1_CODPRO )
	dbSkip()
End
TRBPRC->(dbCloseArea())

dbSelectArea("DA1")
dbSetOrder(3)	// tabela + item
If dbSeek( xFilial("DA1") +cCodTab)
	SoftLock("DA1")
EndIf

Return

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregar บAutor  ณJackson E. de Deus   บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os patrimonios									  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Carregar()

Local cQuery := ""
Local aCampos := {"STATUS", "N1_CHAPA", "N1_XLOJA"} 
Local aAux := {}
Local nI,nJ

For nI := 1 To Len(aFldPs)
	AADD( aCampos, aFldPs[nI] )
Next nI
AADD( aCampos, "N1_XVOLMIN" )
AADD( aCampos, "N1REC" )
AADD( aCampos, "N1_DESCRIC" )
                         
nPosRec := Len(aCampos)-1
nPosPatDsc := Len(aCampos)

cQuery := "SELECT N1_CHAPA,N1_DESCRIC,N1_XLOJA, R_E_C_N_O_ N1REC, N1_XVOLMIN "
// campos das doses P's
For nI := 1 To Len(aFldPs)
	cQuery += ", " +aFldPs[nI] +" " 
Next nI

cQuery += "FROM " +RetSqlName("SN1") + " "
cQuery += "WHERE N1_XCLIENT='"+cCodCli+"' "
cQuery += "AND N1_XTPSERV='2' "
cQuery += "AND N1_PRODUTO IN(SELECT B1_COD FROM "+RetSqlName("SB1") +" WHERE B1_XSECAO='026') "
cQuery += "AND D_E_L_E_T_='' "
cQuery += "ORDER BY N1_CHAPA "

If Select("TRBA") >0
     TRBA->( dbCloseArea() )
EndIf                      

TcQuery cQuery New Alias "TRBA"

dbSelectArea("TRBA")
While !EOF()
	aAux := {}     
	For nI := 1 To Len(aCampos)
		If aCampos[nI] == "STATUS"
			AADD( aAux, .T. )
			Loop
		EndIf
		For nJ := 1 To FCount()
			If FieldName(nJ) == aCampos[nI]      
				cValor := FieldGet(nJ)
				If "N1_XP" $ FieldName(nJ) .And. Empty(cValor)
					cValor := TriggerSize(FieldName(nJ),cValor)
					aAux[1] := .F.
				EndIf
				AADD( aAux, cValor )
				Exit
			EndIf
		Next nJ	
	Next nI

	AADD( aPatrim, aAux )
	dbSkip()
End
dbCloseArea()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCadProd  บAutor  ณJackson E. de Deus   บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณtela de cadastro do produto na tabela de preco			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CadProd()

Local nTamanho := 0.25
Local cProduto := AllTrim( GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+oList:AArray[oList:nAt][oList:ColPos],1) )
Local nVlPE := 0
Local nVlPP := 0
Local lOK := .F.
Local oSay1
Local oSay2
Local oSay3
Local aTela := aClone(aDimension)

If nTamanho <> 100
	aTela[1] := aTela[1] * nTamanho
	aTela[2] := aTela[2] * nTamanho
	aTela[3] := aTela[3] * nTamanho
	aTela[4] := aTela[4] * nTamanho
	aTela[5] := aTela[5] * nTamanho
	aTela[6] := aTela[6] * nTamanho
	aTela[7] := aTela[7] * nTamanho
EndIf

oDlg1   := MSDialog():New( aTela[7],aTela[1],aTela[6],aTela[5],"Cadastro - Tabela de pre็o",,,.F.,,,,,,.T.,,,.T. )	
	oSay1	:= TSay():New( 005,020,{|| cProduto   },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
	oSay2	:= TSay():New( 020,020,{|| "Valor PE: "},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	oSay3	:= TSay():New( 040,020,{|| "Valor PP: "},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
	@ 020,060 MSGET nVlPE	PICTURE PesqPict("DA1","DA1_PRCVEN")		OF oDlg1 SIZE 060,008  PIXEL HASBUTTON
	@ 040,060 MSGET nVlPP	PICTURE PesqPict("DA1","DA1_PRCVEN")		OF oDlg1 SIZE 060,008  PIXEL HASBUTTON	
  
  	oPanel := tPanel():New(0,0,"",oDlg1,,,,,,100,020)
	oPanel:align := CONTROL_ALIGN_BOTTOM
	oSBtn1		:= TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{|| lOK := SalvaProd(nVlPE,nVlPP), If(lOK,oDlg1:End(), ) } , oPanel, "Salvar" , ,)
	oSBtn2		:= TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{|| oDlg1:End()} , oPanel, "Cancelar" , ,)	
	oSBtn2:Align := CONTROL_ALIGN_RIGHT
	oSBtn1:Align := CONTROL_ALIGN_RIGHT
oDlg1:Activate(,,,.T.)

Return lOK

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSalvaProd บAutor  ณJackson E. de Deus  บ Data ณ  18/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSalva o produto na tabela de preco atual					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SalvaProd(nVlPE,nVlPP)

Local lRet := .F.
Local cItem := "0001"
Local lVld := .F.
Local cUm := AllTrim( GetAdvFVal("SB1","B1_UM",xFilial("SB1")+oList:AArray[oList:nAt][oList:ColPos],1) )
Local cSegUm := AllTrim( GetAdvFVal("SB1","B1_SEGUM",xFilial("SB1")+oList:AArray[oList:nAt][oList:ColPos],1) )
Local cTpOper := ""
Local cProd := oList:AArray[oList:nAt][oList:ColPos]

dbSelectArea("DA1")
While !lVld
	If dbSeek(xFilial("DA1") +AvKey(cCodTab,"DA1_CODTAB") +AvKey(cItem,"DA1_ITEM"))	
		cItem := SOMA1(cItem)
		cTpOper := DA1->DA1_TPOPER
		nQtdLot := DA1->DA1_QTDLOT           
		nIndLot := DA1->DA1_INDLOT
	Else                          
		lVld := .T.
	EndIf
End	

If RecLock("DA1",.T.) 
	DA1->DA1_FILIAL	:= xFilial("DA1")
	DA1->DA1_ITEM	:= cItem 
	DA1->DA1_CODTAB	:= cCodTab
	DA1->DA1_CODPRO	:= cProd
	DA1->DA1_PRCVEN	:= nVlPE
	DA1->DA1_XPRCPP	:= nVlPP
	DA1->DA1_ATIVO	:= "1"
	DA1->DA1_MOEDA	:= 1
	DA1->DA1_DATVIG	:= DATE()
	DA1->DA1_TPOPER	:= cTpOper
	DA1->DA1_INDLOT	:= nIndLot
	DA1->DA1_QTDLOT	:= nQtdLot					              
	DA1->DA1_XUM	:= cUm
	DA1->DA1_XSEGUM	:= cSegUm
	MsUnLock()
	
	AADD(aValores,oList:AArray[oList:nAt][oList:ColPos] )
	lRet := .T.
	Aviso("","O produto foi cadastrado com sucesso na tabela de pre็o.",{"Ok"})
EndIf	

Return lRet