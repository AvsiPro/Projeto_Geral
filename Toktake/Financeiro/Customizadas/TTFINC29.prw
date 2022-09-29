#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC29  บAutor  ณJackson E. de Deus  บ Data ณ  10/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de validacao dos Logs - com base nos Logs	          บฑฑ
ฑฑบ          ณ informados na sangria - Log 1/2/3/4						  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ13/06/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFINC29(nRecSZN,nOpcat)

// recebe somente o recno da SZN que se deseja consultar

Local aArea := GetArea()
Local oTela
Private lFormata := SuperGetMV("MV_XFINC01",,.F.)	// ativa formatacao dos valores em formato de valor
Private cLg1 := ""
Private cLg2 := ""
Private cLg3 := ""
Private cLg4 := ""
Private cLg5 := ""
Private cLogAtu := ""
Private cLogAnt := ""
Private cDifer := ""
Private cDfRec := ""
Private cPatrimo := ""
Private cOk24 := "ic_ok24.png"
Private cOk48 := "ic_ok48.png"
Private cCanc24 := "ic_canc24.png"
Private cCanc48 := "ic_canc48.png"              
Private lCRCok := .F.
Private aDados := {}
Private cLogObs := ""
Private cLogObs2 := ""
Private cLogObs3 := ""
Private cCRC := ""
Default nRecSZN := 0
Default nOpcat := "0"

If nRecSZN = 0
	Return
EndIf

Prepara(nRecSZN)
	

// Monta Tela
oTela      := MSDialog():New( 141,305,620,1000,"Consulta de Logs",,,.F.,,,,,,.T.,,,.T. )

	oSPatr      := TSay():New( 015,080,{ || cPatrimo },oTela,,,.F.,.F.,.F.,.T.,,,230,015,,,,,,.T.)
	oBtmp5 := TBitmap():New(010,315,24,24,,,.T.,oTela,,,.F.,.F.,,,.F.,,.T.,,.F.)
 
	// grupo 1
	oGrp1      := TGroup():New( 040,008,144,340,"",oTela,CLR_BLACK,CLR_WHITE,.T.,.F. )
		// Coluna Logs
		oSayx1  := TSay():New( 060,015,{ || cLg1 },oGrp1,,,.F.,.F.,.F.,.T.,,,030,008,,,,,,.T.) 
		oSayx2  := TSay():New( 075,015,{ || cLg2 },oGrp1,,,.F.,.F.,.F.,.T.,,,030,008,,,,,,.T.) 
		oSayx3  := TSay():New( 090,015,{ || cLg3 },oGrp1,,,.F.,.F.,.F.,.T.,,,030,008,,,,,,.T.) 
		oSayx4  := TSay():New( 105,015,{ || cLg4 },oGrp1,,,.F.,.F.,.F.,.T.,,,030,008,,,,,,.T.) 
		oSayx5  := TSay():New( 120,015,{ || cLg5 },oGrp1,,,.F.,.F.,.F.,.T.,,,030,008,,,,,,.T.)                                                                                           
		
	    // Log Anterior
		oSLogAtu  := TSay():New( 045,050,{ || cLogAnt },oGrp1,,,.F.,.F.,.F.,.T.,,,070,008,,,,,,.T.)
		oSC1      := TSay():New( 060,050,{ || aDados[1][4][1] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSC2      := TSay():New( 075,050,{ || aDados[1][4][2] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSC3      := TSay():New( 090,050,{ || aDados[1][4][3] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSC4      := TSay():New( 105,050,{ || aDados[1][4][4] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSayxC5    := TSay():New( 120,050,{ || aDados[1][4][5] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
        
        // Log Atual
		oSLogAnt   := TSay():New( 045,135,{ || cLogAtu },oGrp1,,,.F.,.F.,.F.,.T.,,,070,008,,,,,,.T.)
		oSayx9      := TSay():New( 060,135,{ || aDados[2][4][1] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSayx10     := TSay():New( 075,135,{ || aDados[2][4][2] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSayx11     := TSay():New( 090,135,{ || aDados[2][4][3] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSayx12     := TSay():New( 105,135,{ || aDados[2][4][4] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oSCRC     := TSay():New( 120,135,{ || aDados[2][4][5] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		
		// Venda
		oDifer     := TSay():New( 045,210,{ || cDifer },oGrp1,,,.F.,.F.,.F.,.T.,,,070,008,,,,,,.T.)
		oDif1      := TSay():New( 060,210,{ || aDados[3][2][1] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oDif2      := TSay():New( 075,210,{ || aDados[3][2][2] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oDif3      := TSay():New( 090,210,{ || aDados[3][2][3] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oDif4      := TSay():New( 105,210,{ || aDados[3][2][4] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		
		// Recebido
		oDfRec     := TSay():New( 045,270,{ || cDfRec } ,oGrp1,,,.F.,.F.,.F.,.T.,,,070,008,,,,,,.T.)
		oDfRec1    := TSay():New( 060,270,{ || aDados[4][2][1] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)
		oDfRec2    := TSay():New( 075,270,{ || aDados[4][2][2] },oGrp1,,,.F.,.F.,.F.,.T.,,,052,008,,,,,,.T.)

		
  		// Status
		oBtmp1 := TBitmap():New(060,320,16,16, aDados[5][2][1] ,"",.T.,oGrp1,,,.F.,.F.,,,.F.,,.T.,,.F.)
		oBtmp2 := TBitmap():New(075,320,16,16, aDados[5][2][2] ,"",.T.,oGrp1,,,.F.,.F.,,,.F.,,.T.,,.F.)
		oBtmp3 := TBitmap():New(090,320,16,16, aDados[5][2][3] ,"",.T.,oGrp1,,,.F.,.F.,,,.F.,,.T.,,.F.)
		oBtmp4 := TBitmap():New(105,320,16,16, aDados[5][2][4] ,"",.T.,oGrp1,,,.F.,.F.,,,.F.,,.T.,,.F.)			
		oBtmp6 := TBitmap():New(120,320,16,16, aDados[5][2][5] ,"",.T.,oGrp1,,,.F.,.F.,,,.F.,,.T.,,.F.)	    

	// grupo 2
	oGrp2      := TGroup():New( 148,008,204,340,"",oTela,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oObs   := TSay():New( 155,016,{ || cLogObs },oGrp2,,,.F.,.F.,.F.,.T.,,,500,008,,,,,,.T.)
		oObs2  := TSay():New( 170,016,{ || cLogObs2 },oGrp2,,,.F.,.F.,.F.,.T.,,,500,008,,,,,,.T.)
		oObs3  := TSay():New( 185,016,{ || cLogObs3 },oGrp2,,,.F.,.F.,.F.,.T.,,,500,008,,,,,,.T.)
	
	oBtnx	:= TButton():New( 212,200,"Enviar",oTela,{ || Enviar() },037,012,,,,.T.,,"",,,,.F. )	
	oBtnx1	:= TButton():New( 212,250,"Verificar LOG C5",oTela,{ || LogCRC() },045,012,,,,.T.,,"",,,,.F. )
	oBtnx2	:= TButton():New( 212,300,"Sair",oTela,{ || oTela:End() },037,012,,,,.T.,,"",,,,.F. )
	
	oBtnx:Disable() 
	
	If nOpcat == "1" 
   		LogCRC()
   		If lCRCok
   			Return
   		EndIf
 	EndIf
	
oTela:Activate(,,,.T.)

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณchkfinalบAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao final da tela - valida os valores e Log 5 CRC    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function chkfinal()

Local llOk := .T.

// Valida os dois primeiros logs
For nI := 1 To 2
	// se venda nao for negativa
	If aDados[3][3][nI] < 0
		llOk := .F.
		Exit
	EndIf
	
	// se valor recebido for diferente da venda
	If aDados[4][3][nI] <> aDados[3][3][nI]
		llOk := .F.
		Exit
	EndIf
Next nI

            
If !llOk .Or. !lCRCOk
	oBtmp5:SetBmp(cCanc48)
ElseIf llOk .And. lCRCOk
	oBtmp5:SetBmp(cOk48)
EndIf


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldLog  บAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida os logs antes de tentar efetuar o calculo do log 5  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldLog()

Local llRet := .T.
Local nI := 0
Local nJ := 0
Local lProblema := .F.

For nI := 1 To 4
	If Empty(aDados[2][2][nI])
		MsgAlert("O Log C" +cvaltochar(nI) +" nใo foi informado." +CRLF +"Nใo serแ possํvel efetuar o cแlculo.")
		llRet := .F.
		Exit
	EndIf
Next nI
	
// Valida conteudo dos valores
For nI := 1 To 4
	If !lProblema
		For nJ := 1 To Len(aDados[2][2][nI])
			If !IsDigit(SubStr(aDados[2][2][nI],nJ,1)) 
				MsgAlert("O Log C" +cvaltochar(nI) +" possui caracteres invแlidos." +CRLF +"Nใo serแ possํvel efetuar o cแlculo.")
				lProblema := .T.
				Exit
			EndIf
		Next nJ
	EndIf
Next nI      

Return llRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuObs  บAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a Obs do rodape e status do Log C5                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuObs()

Local cMsg := ""
				
// Log 5 nao confere
If cCRC <> aDados[2][2][5]
	lCRCok := .F.
	cLogObs := '<font size=4 color=red>O Log C5 informado pela rota nใo confere com o valor calculado.'
	cLogObs2 := '<font size=4 color=red>Valor informado: ' +aDados[2][2][5]
	cLogObs3 := '<font size=4 color=red>Valor calculado: ' +cCRC
			
	aDados[2][4][5] := '<strong><font size=4 color=red>' +aDados[2][2][5] +'</strong>'
	oSCRC:Refresh()
	
	aDados[5][2][5] := 	cCanc24
	oBtmp6:SetBmp(aDados[5][2][5])
// Log 5 confere
Else
	lCRCok := .T.
	cLogObs := '<font size=4 color=blue>O Log C5 informado pela rota confere com o valor calculado.'	
	aDados[2][4][5] := '<font size=4 color=blue>' +aDados[2][2][5]
	
	aDados[5][2][5] := 	cOk24
	oBtmp6:SetBmp(aDados[5][2][5])
	
	oObs2:SetText("")
	oObs3:SetText("")
	oObs2:Refresh()
	oObs3:Refresh()
	oSCRC:Refresh()		
EndIf 
//oObs:setText("")
//oObs:setText(cLogObs)    
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLogCRC  บAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz o calculo do Log 5 - CRC                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LogCRC()

Local lChk := .F.
Local lRet	:=	.F.

lChk := VldLog()
If lChk
	CursorWait()
	Processa( { || cCRC := U_TTFINC30( aDados[2][2][1],aDados[2][2][2], aDados[2][2][3], aDados[2][2][4]) },"Aguarde..")
	CursorArrow()            
	If Empty(cCRC)
		MsgAlert("Houve erro ao calcular o Log C5" +CRLF +"Tente novamente.")
	Else
		cCRC := SubStr( cCRC,5 )
	
		AtuObs()
		chkfinal()
		If FindFunction("U_TTFINC31")
			oBtnx:Enable()
		EndIf
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrepara บAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara os dados da tela                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Prepara(nRecSZN)

Local cQuery := ""
Local lLogAnt := .F.
Local nDifer := 0

dbSelectArea("SZN")
dbGoTo(nRecSZN)

If Recno() = nRecSZN

	AADD(aDados, { "Log Anterior"	,	{"","","","",""},{0,0,0,0,0},{"","","","",""} } )	// Log Ant
	AADD(aDados, { "Log Atual"		,	{"","","","",""},{0,0,0,0,0},{"","","","",""} } )	// Log Atu
	AADD(aDados, { "Venda"			,	{"","","",""},{0,0,0,0} } )							// Venda = Log Atu - Log Ant
	AADD(aDados, { "Recebido"		,	{"",""},{0,0} } )									// Recebido
	AADD(aDados, { "Status"			,	{"","","","",""} } )								// Status

	// Obtem os logs atuais
	aDados[2][2][1] := AllTrim(SZN->ZN_LOGC01)
	aDados[2][2][2] := AllTrim(SZN->ZN_LOGC02)  
	aDados[2][2][3] := AllTrim(SZN->ZN_LOGC03)  
	aDados[2][2][4] := AllTrim(SZN->ZN_LOGC04)  
	aDados[2][2][5] := UPPER(AllTrim(SZN->ZN_LOGC05))
	
	aDados[2][3][1] := Val(SZN->ZN_LOGC01)
	aDados[2][3][2] := Val(SZN->ZN_LOGC02)  
	aDados[2][3][3] := Val(SZN->ZN_LOGC03)  
	aDados[2][3][4] := Val(SZN->ZN_LOGC04)  

	aDados[4][3][1] := SZN->ZN_NOTA01	// total recebido cedula
	aDados[4][3][2] := SZN->ZN_MOEDA1R	// total recebido moeda
	            
	// Obtem os logs anteriores
	cQuery := "SELECT TOP 1 R_E_C_N_O_ RECZN,* FROM " +RetSqlName("SZN") 
	cQuery += " WHERE ZN_DATA < '"+dtos(SZN->ZN_DATA)+"' AND ZN_ROTA = '"+SZN->ZN_ROTA+"' AND ZN_PATRIMO = '"+SZN->ZN_PATRIMO+"' AND D_E_L_E_T_ = '' "
	cQuery += " AND ZN_TIPINCL LIKE '%SANGRIA%' AND ( ZN_LOGC01 <> '' OR ZN_LOGC02 <> '' OR ZN_LOGC03 <> '' OR ZN_LOGC04 <> '' ) "
	cQuery += " ORDER BY ZN_DATA DESC "
	If Select("TRBZ") > 0
		TRBZ->(dbCloseArea())
	EndIf                   
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBZ',.F.,.T.)
	
	dbSelectArea("TRBZ")
	If !EOF()
		// dados em caracter
		aDados[1][2][1] := AllTrim(TRBZ->ZN_LOGC01)
		aDados[1][2][2] := AllTrim(TRBZ->ZN_LOGC02)  
		aDados[1][2][3]	:= AllTrim(TRBZ->ZN_LOGC03)  
		aDados[1][2][4] := AllTrim(TRBZ->ZN_LOGC04)
		aDados[1][2][5] := UPPER(AllTrim(TRBZ->ZN_LOGC05))
		
		// dados em numero
		aDados[1][3][1] := Val(TRBZ->ZN_LOGC01)
		aDados[1][3][2] := Val(TRBZ->ZN_LOGC02)  
		aDados[1][3][3]	:= Val(TRBZ->ZN_LOGC03)  
		aDados[1][3][4] := Val(TRBZ->ZN_LOGC04)

		lLogAnt := .T.
	EndIf  

	// Obtem a diferenca do log atual - anterior
	If !lLogAnt
		MsgAlert("Nใo hแ registro de logs desse patrim๔nio anterior a data atual.")
	Else
		For nI := 1 To 4
			/*
			nLogAtu := cvaltochar(aDados[2][3][nI])
			nLogAtu := SubStr(nLogAtu,1,Len(nLogAtu)-2) +"." +SubStr(nLogAtu,Len(nLogAtu)-1)
			nLogAtu := Val(nLogAtu)
			
			nLogAnt := cvaltochar(aDados[1][3][1])
			nLogAnt := SubStr(nLogAnt,1,Len(nLogAnt)-2) +"." +SubStr(nLogAnt,Len(nLogAnt)-1)
			nLogAnt := Val(nLogAnt)
			
			nVal := Round(nLogAtu - nLogAnt,2)
			nVal := cvaltochar(nVal)
			nVal := Val(nVal)       
			*/
			
			aDados[3][3][nI] := Round(aDados[2][3][nI] - aDados[1][3][nI],2)	// (log atual - log anterior)
		Next nI
	EndIf  
EndIf

// monta html dos valores
For nI := 1 To 5
	// Log anterior
	If nI < 5
		aDados[1][4][nI] :=  '<font size=4 color=gray>' +IIF( lFormata,Pict(aDados[1][2][nI]), aDados[1][2][nI] ) 
	Else
		aDados[1][4][nI] :=  '<font size=4 color=gray>' +aDados[1][2][nI]
    EndIf
    // Log atual
	If nI < 5
		aDados[2][4][nI] :=  '<font size=4 color=black>' +IIF( lFormata, Pict(aDados[2][2][nI]), aDados[2][2][nI] )
	Else
		aDados[2][4][nI] := '<font size=4 color=black>' +aDados[2][2][nI] 
	EndIf         
	
	// Venda
	If nI < 5
		If aDados[3][3][nI] >= 0
			aDados[3][2][nI] := '<font size=4 color=blue>' +IIF( lFormata, Pict(aDados[3][3][nI]), cvaltochar(aDados[3][3][nI]) ) +'</font>'
		Else	
			aDados[3][2][nI] :=	'<strong><font size=4 color=red>' +IIF( lFormata,Pict(aDados[3][3][nI]), cvaltochar(aDados[3][3][nI]) ) +'</strong>'
		EndIf										
	EndIf             
       
	// Recebido
	If nI <= 2
		aDados[4][2][nI] :=  IIF(aDados[4][3][nI]==aDados[3][3][nI],;
									'<font size=4 color=blue>' +Transform(aDados[4][3][nI],PesqPict("SZN","ZN_NOTA01")) ,;
											 '<strong><font size=4 color=red>' +Transform(aDados[4][3][nI],PesqPict("SZN","ZN_NOTA01")) +'</strong>') 
	EndIf          
	
	// Status
	If nI <= 2
		aDados[5][2][nI] := IIF(aDados[3][3][nI]>=0 .And. aDados[4][3][nI]==aDados[3][3][nI], cOk24 , cCanc24  ) 
	Else
		If nI < 5 
			aDados[5][2][nI] := IIF(aDados[3][3][nI]>=0 , cOk24 , cCanc24  )
		EndIf 
	EndIf	
Next nI	


// coluna logs
cLg1 :=  '<strong><font size=4 color=black>' +"Log C1 - C้dulas" +'</strong>'
cLg2 :=  '<strong><font size=4 color=black>' +"Log C2 - Moedas" +'</strong>'
cLg3 :=  '<strong><font size=4 color=black>' +"Log C3 - Ticket" +'</strong>'
cLg4 :=  '<strong><font size=4 color=black>' +"Log C4 - POS" +'</strong>'
cLg5 :=  '<strong><font size=4 color=black>' +"Log C5 - CRC" +'</strong>'  

// cabecalhos
cPatrimo := '<strong><font size=5 color=black>' +"Patrim๔nio: " +SZN->ZN_PATRIMO + " - " +SZN->ZN_TIPMAQ +'</strong>' 
cLogAnt := '<strong><font size=4 color=gray>' +"Anterior - " +dtoc(stod(TRBZ->ZN_DATA)) +'</strong>'
cLogAtu :=  '<strong><font size=4 color=black>' +"Atual - " +dtoc(SZN->ZN_DATA) +'</strong>'
cDifer := '<strong><font size=4 color=black>' +"Venda" +'</strong>'
cDfRec := '<strong><font size=4 color=black>' +"Recebido" +'</strong>'
	
Return

       


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPict   บAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o numero formatado como texto e com picture        บฑฑ
ฑฑบ          ณ definida                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pict(cvalor)

Local cPict := ""
Local cRet := ""

cvalor := cvaltochar(cvalor)

If ! "." $ cvalor
	cvalor := SubStr(cvalor,1,Len(cvalor)-2) +"." +SubStr(cvalor,Len(cvalor)-1)
EndIf

If Len(cvalor) == 12
	cPict := "@E 9,999,999,999.99"
ElseIf Len(cvalor) == 11
	cPict := "@E 999,999,999.99"
ElseIf Len(cvalor) == 10
	cPict := "@E 99,999,999.99"
ElseIf Len(cvalor) == 9
	cPict := "@E 9,999,999.99"
ElseIf Len(cvalor) == 8
	cPict:= "@E 999,999.99"
ElseIf Len(cvalor) == 7
	cPict:= "@E 99,999.99"
ElseIf Len(cvalor) == 6
	cPict := "@E 9,999.99"
ElseIf Len(cvalor) == 5
	cPict:= "@E 999.99"
ElseIf Len(cvalor) == 4
	cPict := "@E 99.99"
ElseIf Len(cvalor) == 3
	cPict:= "@E 9.99"
EndIf	      

cRet := Transform(Val(cvalor),cPict)

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviar   บAutor  ณJackson E. de Deus    บ Data ณ  13/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia por email a inconsistencia dos logs                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Enviar()

CursorWait()
Processa( { || U_TTFINC31(aDados) },"Aguarde..")
CursorArrow() 

Return 