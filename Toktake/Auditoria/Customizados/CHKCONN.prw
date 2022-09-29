#include 'totvs.ch'
#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCHKCONN   บAutor  ณJackson E. de Deus  บ Data ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica o status de conexao do WS TT		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CHKCONN()

Local oDlg
Local nTempo := 60000
Local oTimerS
Local oPanelX
Local oPanelY
Local oPanelZ
Local oPanelA
Local oPanelB
Local oPanelC
Local oS1
Local oS2
Local oSay
Local oSay2
Local oRfsh
Local oBmp1
Local oBmp2
Private nTime := 0
Private nTime2 := 0
Private cMsg := ""
Private cMsg2 := ""
Private cTime1 := ""
Private cTime2 := ""

//prepare environment empresa "01" filial "01"

oDlg := MSDialog():New(0,0,410, 350,"Comunica็ใo com Web Service",,,.F.,,,,,,.T.,,,.T.)	
	oTimerS := TTimer():New( nTempo, { || conn(@oPanelX,@oPanelY,@oPanelZ,@oSay,@oSTime1) }, oDlg )  
	oTimerS:Activate()
    
    // painel TT
	oS1 := TSay():New( 5,45,{|| "Protheus" },oDlg,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,008,,,,,,.F.)
	oS1:SetCss(" QLabel {font: bold 12px; color: #000000; } ")
	
	Sem1 := tPanel():New(20,30,,oDlg,,,,,,60,160) 	
	Sem1:SetCss( " QLabel { background-color: #000000; border-radius: 12px ; border: 1px solid gray;}" )
	
	oPanelX  := tPanel():New(30,40,,oDlg,,,,,,40,40) 	
	oPanelX:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )
	
	oPanelY  := tPanel():New(80,40,,oDlg,,,,,,40,40) 	
	oPanelY:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )
	
	oPanelZ  := tPanel():New(130,40,,oDlg,,,,,,40,40) 	
	oPanelZ:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )
	
	oSay := TSay():New( 180,30,{|| cMsg }	,oDlg,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,008,,,,,,.F.)
	oSay:SetCss(" QLabel {font: bold 12px; color: #000000; } ")
	
	oSTime1 := TSay():New( 190,30,{|| cTime1 }	,oDlg,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSTime1:SetCss(" QLabel {font: bold 12px; color: #000000; } ")
	
	
	//oBmp1 := TBitmap():New(60,105,40,40,"PMSSETAESQ","",.T.,oDlg,{ || },,.F.,.F.,,,.F.,,.T.,,.F.)
	//oBmp2 := TBitmap():New(120,105,40,40,"PMSSETADIR","",.T.,oDlg,{ || },,.F.,.F.,,,.F.,,.T.,,.F.)
	                       
	/*
	// painel equipe remota
	oS2 := TSay():New( 5,130,{|| "Web Service" }	,oDlg,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,008,,,,,,.F.)
	oS2:SetCss(" QLabel {font: bold 12px; color: #000000; } ")
	
	Sem2 := tPanel():New(20,130,,oDlg,,,,,,60,160) 	
	Sem2:SetCss( " QLabel { background-color: #000000; border-radius: 12px ; border: 1px solid gray;}" )
	
	oPanelA  := tPanel():New(30,140,,oDlg,,,,,,40,40) 	
	oPanelA:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )
	
	oPanelB  := tPanel():New(80,140,,oDlg,,,,,,40,40) 	
	oPanelB:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )
	
	oPanelC  := tPanel():New(130,140,,oDlg,,,,,,40,40) 	
	oPanelC:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )
	
	oSay2 := TSay():New( 180,135,{|| cMsg2 }	,oDlg,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,250,008,,,,,,.F.)
	oSay2:SetCss(" QLabel {font: bold 12px; color: #000000; } ")
	
	oSTime2 := TSay():New( 190,135,{|| cTime2 }	,oDlg,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008,,,,,,.F.)
	oSTime2:SetCss(" QLabel {font: bold 12px; color: #000000; } ")
	*/
	
	oRfsh := TBtnBmp2():New( 370,300,40,40, 'PMSRRFSH'	, , , ,{ || conn(@oPanelX,@oPanelY,@oPanelZ,@oSay,@oSTime1/*,@oPanelA,@oPanelB,@oPanelC,@oSay,@oSay2,@oSTime1,@oSTime2*/)  } , oDlg, "Atualizar" , ,)	
	                                                                                                       	
	conn(@oPanelX,@oPanelY,@oPanelZ,@oSay,@oSTime1/*,@oPanelA,@oPanelB,@oPanelC,@oSay,@oSay2,@oSTime1,@oSTime2*/)
					
oDlg:Activate(,,,.T.,{|| },,{ || } )

//reset environment 

Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConn   บAutor  ณJackson E. de Deus     บ Data ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz os testes e atualiza a tela                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Conn(oPanelX,oPanelY,oPanelZ,oSay,oSTime1/*oPanelA,oPanelB,oPanelC,oSay,oSay2,oSTime1,oSTime2*/)

Local cTempo := ""

lTT := ConnTT(@cTempo)
cTime1 := cValToChar( Val(SubStr(cTempo,7,2)) ) +" seg."
If !lTT
	cMsg := "ERRO" 
	oPanelX:SetCss( " QLabel { background-color: #FF0000; border-radius: 36px ; border: 1px solid gray;}" ) 
	oPanelY:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
	oPanelZ:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )    
Else    
	cMsg := "OK"                                                                                   
	oPanelX:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
	
	If cTempo < "00:00:05"       
		oPanelX:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
		oPanelY:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 		
		oPanelZ:SetCss( " QLabel { background-color: #19A347; border-radius: 36px ; border: 1px solid gray;}" ) 
	Else
		oPanelX:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )                                                                                                         
		oPanelZ:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
		oPanelY:SetCss( " QLabel { background-color: #FFFF66; border-radius: 36px ; border: 1px solid gray;}" ) 
	EndIf	
EndIf

/*
lKP := ConnKP(@cTempo)
cTime2 := cValToChar( Val(SubStr(cTempo,7,2)) ) +" seg."
If !lKP
	cMsg2 := "ERRO" 
	oPanelA:SetCss( " QLabel { background-color: #FF0000; border-radius: 36px ; border: 1px solid gray;}" ) 
	oPanelB:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 	
	oPanelC:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" )    	
Else
	cMsg2 := "OK"                                                                                   
	oPanelA:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
	
	If cTempo < "00:00:05"
		oPanelA:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
		oPanelB:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
		oPanelC:SetCss( " QLabel { background-color: #19A347; border-radius: 36px ; border: 1px solid gray;}" ) 
	Else
		oPanelA:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
		oPanelC:SetCss( " QLabel { background-color: #888888; border-radius: 36px ; border: 1px solid gray;}" ) 
		oPanelB:SetCss( " QLabel { background-color: #FFFF66; border-radius: 36px ; border: 1px solid gray;}" ) 
	EndIf
EndIf
*/

oSTime1:Refresh()
//oSTime2:Refresh()

//oSay:Refresh()
oPanelX:Refresh()
oPanelY:Refresh()
oPanelZ:Refresh() 
/*       
oSay2:Refresh()
oPanelA:Refresh()
oPanelB:Refresh()
oPanelC:Refresh()
*/       
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConnTT   บAutor  ณJackson E. de Deus   บ Data ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Teste de conexao - Tok Take                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ConnTT(cTempo)
             
Local lOk := .T.
Local nPort := 80
Local cUrlTT := "http://200.98.28.187:10142/ws/TTMWS.apw?WSDL"
Local nTimeOut := 5000
Local cHeadRet := ""
Local cResponse := ""
Local cInicio := ""
Local cFim := ""

cHeadRet := ""
cResponse := HTTPCGet( cUrlTT ,"",nTimeOut,{},@cHeadRet )
If Empty(cResponse)
	lOk := .F.
Else
	// teste de consumo de metodo
	/*
	cAxTeste := "AAA"
	cInicio := Time()
	oWS := WSTTWS():New()
	If oWS:SETACOMPANHAMENTOORDEMSERVICO("6241D1E1C9517582E2CBFE491E908A10C7C3DFCE","42CB7AEE2B2FFA173B53",cAxTeste)
		cResponse := oWs:cSETACOMPANHAMENTOORDEMSERVICORESULT
	Else                                                     
		cResponse := GetWSCError()
	EndIf
	*/
	
	cInicio := Time()
	oWS := WSTTMWS():New()
	If oWS:GETOS("400262","JJ0011")
		cResponse := oWs:cGETOSRESULT
	Else                                                     
		cResponse := GetWSCError()
	EndIf
	
	cFim := Time()
	cTempo := ElapTime(cInicio,cFim)
	
	If Empty(cResponse)
		lOk := .F.
	Else
		lOk := .T.
	EndIf
EndIf

Return lOk


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConnKP   บAutor  ณJackson E. de Deus   บ Data ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Teste de conexao - Equipe Remota                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ConnKP(cTempo)

Local lOk := .T.
Local nPort := 80
Local cUrlKP := "http://equiperemota.keeple.com.br/webservices/keeplefieldintegration.asmx?WSDL"
Local nTimeOut := 5000
Local aDados := {}
Local cAuthCode := "3174CC0FD60FE8B0540591624D43216A592FF9F1"
Local cClientCode := "42CB7AEE2B2FFA173B53" 
Local cHeadRet := ""
Local cResult := ""
Local cInicio := ""
Local cFim := ""

cHeadRet := ""
cResponse := HTTPCGet( cUrlKP ,"",nTimeOut,{},@cHeadRet )
If Empty(cResponse)
	lOk := .F.
Else
	// teste de consumo de metodo
	AADD( aDados, cAuthCode ) 
	AADD( aDados, cClientCode ) 
	AADD( aDados, 1012 )
	AADD( aDados, FwTimeStamp(3) )
	
	cInicio := Time()
	cResult := U_WSKPC010(aDados)
	cFim := Time()
	cTempo := ElapTime(cInicio,cFim)
	If "true" $ cResult 
		lOk := .T.
	Else
		lOk := .F.
	EndIf
EndIf          

Return lOk