#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER08บAutor  ณJackson E. de Deus    บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os horarios de atendimentos dos patrimonios.		  บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ07/07/14ณ01.00 |Criacao                               ณฑฑ
ฑฑณJackson	       ณ20/10/14ณ01.01 |Ajustes efetuados para contemplar     ณฑฑ
ฑฑณ									mais de um atendimento por dia ao     ณฑฑ 
ฑฑณ									patrimonio e correcao no indicador    ณฑฑ 
ฑฑณ									de horarios ( fora do expediente )    ณฑฑ 
ฑฑณJackson	       ณ20/04/15ณ01.02 |Correcao - calculo de horarios        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTOPER08(aItens,cRota)

Local oTela
Local oBtn,oBtn2,oBtn3,oBtn4,oBtn5,oSay1,oSay2,oSay3,oSay4,oSrv
Local cRotatit :=  "<strong><font size=3 color=black>Rota</strong>"
Local cCodCli := "<strong><font size=3 color=black>Cliente</strong>" 
Local cLjCli := "<strong><font size=3 color=black>Loja</strong>" 
Local cNomCli := "<strong><font size=3 color=black>Nome</strong>" 
Local cEnd := "<strong><font size=3 color=black>Endere็o</strong>"
Local cCodRota := "<strong><font size=3 color=#483D8B>" +cRota +"</strong>" 
Local cTurno :=  "<strong><font size=3 color=black>Turno</strong>"
Local cSrv := "<strong><font size=3 color=black>Tipo de Servi็o</strong>"
Local cSeqPatr := "<strong><font size=3 color=black>Sequ๊ncia</strong>"
Private aInfoTec := {}
Private cTurnoTec := ""
Private aTurno := {"","","",""}
Private cDescSrv := ""
Private cAbast := ""
Private _cHrTurno := ""
Private _cCliente := ""
Private _cLoja := ""
Private _cNome := ""
Private _cEndereco := ""
Private cAlertHora := ""
Private _cSeqPatrim := ""
Private aTrabd := {}
Private aAlter := {}
Private aHeader := {}
Private aCols := {}
Private _dDtIni := Firstday(dDatabase)
Private _dDtFim := Lastday(dDatabase)
Private _nPosSeq := 0

Default aItens := {}

If cEmpAnt <> "01"
	Return
EndIf

If Len(aItens) == 0
	Aviso("TTOPER08","Nใo hแ patrim๔nios cadastrados para essa rota.",{"Ok"})
	Return
EndIf

aInfoTec := TEC( cRota )
cTurnoTec := Turno( aInfoTec[3] )
//If !Empty( aInfoTec[3] ) .And. !Empty( dDatabase )
	//aTurno := StaticCall( TTOPER17,Turno,aInfoTec[3],dDatabase )
//EndIf

cAbast := "<strong><font size=3 color=#483D8B>" +aInfoTec[2] +"</strong>"
_cHrTurno := "<strong><font size=3 color=#483D8B>" +cTurnoTec +"</strong>"

CursorWait()
Processa({ || Carregar(aItens,cRota) },"Carregando calendario, aguarde..")	
CursorArrow()            

oTela := MSDialog():New( 088,232,600,1200,"Calendario do mes",,,.F.,,,,,,.T.,,,.T. )
	oTela:lEscClose := .F.
	// painel topo
	oPanel := tPanel():New(0,0,"",oTela,,,,,,0,030)
	oPanel:align := CONTROL_ALIGN_TOP
	              
	// tsays em html
	oRT := TSay():New( 000,005,{ || cRotaTit },oPanel,,,.F.,.F.,.F.,.T.,,,020,010,,,,,,.T.)
	oNomeRT := TSay():New( 000,035,{ || cCodRota },oPanel,,,.F.,.F.,.F.,.T.,,,020,010,,,,,,.T.)
	oAbast := TSay():New( 000,070,{ || cAbast },oPanel,,,.F.,.F.,.F.,.T.,,,100,010,,,,,,.T.)
	oTurno := TSay():New( 000,180,{ || cTurno },oPanel,,,.F.,.F.,.F.,.T.,,,020,010,,,,,,.T.)
	oHoraTurno := TSay():New( 000,210,{ || _cHrTurno },oPanel,,,.F.,.F.,.F.,.T.,,,300,010,,,,,,.T.)
	oSay1 := TSay():New( 010,005,{ || cCodCli },oPanel,,,.F.,.F.,.F.,.T.,,,020,010,,,,,,.T.)
	oCli := TSay():New( 010,035,{ || _cCliente },oPanel,,,.F.,.F.,.F.,.T.,,,020,010,,,,,,.T.)
	oSay2 := TSay():New( 010,070,{ || cLjCli },oPanel,,,.F.,.F.,.F.,.T.,,,015,010,,,,,,.T.)
	oLoja := TSay():New( 010,087,{ || _cLoja },oPanel,,,.F.,.F.,.F.,.T.,,,015,010,,,,,,.T.)
	oSay3 := TSay():New( 010,110,{ || cNomCli },oPanel,,,.F.,.F.,.F.,.T.,,,020,010,,,,,,.T.)
	oNome := TSay():New( 010,130,{ || _cNome },oPanel,,,.F.,.F.,.F.,.T.,,,300,010,,,,,,.T.)
	oSrv := TSay():New( 010,265,{ || cSrv },oPanel,,,.F.,.F.,.F.,.T.,,,060,010,,,,,,.T.)
	oDscSv := TSay():New( 010,320,{ || cDescSrv },oPanel,,,.F.,.F.,.F.,.T.,,,350,010,,,,,,.T.)
	oSay4 := TSay():New( 020,005,{ || cEnd },oPanel,,,.F.,.F.,.F.,.T.,,,030,010,,,,,,.T.)
	oEnd := TSay():New( 020,035,{ || _cEndereco },oPanel,,,.F.,.F.,.F.,.T.,,,300,010,,,,,,.T.)
	
	//oSeq := TSay():New( 020,265,{ || cSeqPatr },oPanel,,,.F.,.F.,.F.,.T.,,,300,010,,,,,,.T.)
	//oDscSeq := TSay():New( 020,320,{ || _cSeqPatrim },oPanel,,,.F.,.F.,.F.,.T.,,,300,010,,,,,,.T.)
	oObsHora := TSay():New( 020,265,{ || cAlertHora },oPanel,,,.F.,.F.,.F.,.T.,,,300,010,,,,,,.T.)

	// painel central - calendario
	oPanel2 := tPanel():New(0,0,"",oTela,,,,,,0,0)
	oPanel2:align := CONTROL_ALIGN_ALLCLIENT
	
	oGrid := MsNewGetDados():New(0,0,0,0,GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAlter,1,999,"STATICCALL(TTOPER08,VldField)","","AllwaysTrue()",oPanel2,aHeader,aCols,{ || GridChange(aItens,cRota) } )
	oGrid:oBrowse:bWhen := { || GridChange(aItens,cRota), .T. }
	oGrid:oBrowse:bHeaderClick := { || Ordena(oGrid:oBrowse:nColPos) }
	oGrid:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	                          
	// painel rodape - botoes
	oPanel4 := tPanel():New(0,0,"",oTela,,,,,/*SetTransparentColor(CLR_BLUE ,030)*/,0,020)
	oPanel4:align := CONTROL_ALIGN_BOTTOM
	
	oBtn	:= TButton():New( 005,005,"Sugerir horarios",oPanel4,{|| Horario(@aItens,cRota) },050,012,,,,.T.,,"",,,,.F. )
	oBtn5	:= TButton():New( 005,060,"Limpar",oPanel4,{|| Limpar() },040,012,,,,.T.,,"",,,,.F. )
	oBtn4	:= TButton():New( 005,105,"Gerar excel",oPanel4,{|| Planilha(oGrid:aCols,aItens,cRota) },040,012,,,,.T.,,"",,,,.F. )
	oBtn2	:= TButton():New( 005,400,"Confirmar",oPanel4,{|| Processa({ || Gravar(aItens,oGrid:aCols,cRota,@oTela) },"Gravando horarios, aguarde..") },037,012,,,,.T.,,"",,,,.F. )
	oBtn3	:= TButton():New( 005,440,"Sair",oPanel4,{|| oTela:End()},037,012,,,,.T.,,"",,,,.F. )
	
oTela:Activate(,,,.T.)                                   

ChkRota(cRota)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHorario บAutor  ณJackson E. de Deus    บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para escolha do tipo do calculo das horas			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Horario(aItens,cRota)
                                        
Local nColPos := oGrid:oBrowse:nColPos
Local bAction := { || CalcHora(nOpcao,aItens,cRota) } 
                 
nOpcao := Aviso("TTOPER08 - Horario","Escolha o tipo de carregamento de horario: " +CRLF +"1 - Carregar o dia" +CRLF +"2 - Carregar o m๊s inteiro",{"Dia","M๊s","Cancelar"})
If nOpcao == 3
	Return
Else
	If nOpcao == 1 .And. nColPos < 4
		Return
	EndIf        
	
	Processa({ || CalcHora(nOpcao,aItens,cRota) },"Calculando horarios, aguarde..") 	// utilizando regua 'Processa'
	//oCaracol := Caracol():Create()		// utilizando regua 'Caracol'
	//oCaracol:Iniciar(bAction)	
EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcHora บAutor  ณJackson E. de Deus   บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz o calculo dos horarios das maquinas por dia ou mes	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcHora(nOpcao,aItens,cRota)

Local nX, nY
Local aTrb2 := {}
Local aAux := {}
Local nQtdDias := 0
Local nPos := 0
Local dDia := _dDtIni
Local nDiaFim := Day( LastDay(dDatabase) )
Local cMes := cValTochar(MONTH(dDatabase))
Local cDia := cValtoChar(Day(dDatabase))
Local cPatrim := oGrid:aCols[oGrid:oBrowse:nAt][1]
Local nLinha := oGrid:oBrowse:nAt
Local nColPos := oGrid:oBrowse:nColPos
Local nDiaCol := 0
Local dDia


CursorWait()
// Calcula dia
If nOpcao == 1
	//ProcRegua(1)
	//oCaracol:xSetRegua(1)     

	nDiaCol := nColPos-3	// dia da coluna
	nDiacol := StrZero(nDiacol,2)
	dDia := STOD( cvaltochar(Year(dDatabase)) + StrZero(Month(dDatabase),2) +nDiacol )	
   	//		stod( Cvaltochar(Year(dDatabase)) +StrZero(Month(dDatabase),2) +StrZero(nDia,2) )
   	// busca horarios da rota / dia	                       	 
	aTrb2 := StaticCall(TTOPER02,PlTrab,cRota,dDia)
	
	//IncProc("Calculando dia " +cvaltochar(nColPos-3))
	//oCaracol:xIncRegua()
	If Len(aTrb2) > 0
		For nY := 1 To Len(aTrb2)
			cHr := SubStr(aTrb2[nY][16],1,2)
			cMin := SubStr(aTrb2[nY][16],4)
			Aadd(aAux,{ Val(nDiacol), aTrb2[nY,6], cHr +":" +cMin, aTrb2[nY,10]  })	// dia + patrim + horario + seq
		Next nY   
		
		// atualiza grid               
		For nI := 1 To Len(oGrid:aCols)	
			nPos := Ascan( aAux, { |x| AllTrim(x[2]) == AllTrim(oGrid:aCols[nI][1]) .And. x[1] == Val(nDiacol) .And. Val(oGrid:aCols[nI][3]) == x[4] } )
			If nPos > 0
				cHr := SubStr(aAux[nPos][3],1,2)
				cMin := SubStr(aAux[nPos][3],4)
				oGrid:aCols[nI][nColPos] := cHr +":" +cMin
			EndIf	
		Next nI

		oGrid:Refresh()
	EndIf
// Calcula mes	
ElseIf nOpcao == 2
	ProcRegua(_dDtFim - _dDtIni)                		                 
	//oCaracol:xSetRegua(_dDtFim - _dDtIni)     
	
	nCol := 3
	For nX := _dDtIni To _dDtFim
		nCol++
		IncProc("Calculando dia " +cvaltochar(Day(nX)))
		//oCaracol:xIncRegua()
		
		//Buscar horarios de atendimento dos patrimonios
		aTrb2 := StaticCall(TTOPER02,PlTrab,cRota,nX)
		If Len(aTrb2) > 0
			For nY := 1 to len(aTrb2)
				cHr := SubStr(aTrb2[nY][16],1,2)
				cMin := SubStr(aTrb2[nY][16],4)
				Aadd(aAux,{ nCol, aTrb2[nY,6], cHr +":" +cMin, aTrb2[nY,10] })	// dia + patrim + horario
			Next nY   
			
			// atualiza grid               
			For nI := 1 To Len(oGrid:aCols)	
				nPos := Ascan(aAux, { |x| AllTrim(x[2]) == AllTrim(oGrid:aCols[nI][1]) .And. x[1] == nCol .And. Val(oGrid:aCols[nI][3]) == x[4]  } )
				If nPos > 0
					cHr := SubStr(aAux[nPos][3],1,2)
					cMin := SubStr(aAux[nPos][3],4)
					oGrid:aCols[nI][nCol] := cHr +":" +cMin
				EndIf	
			Next nI

		EndIf
	Next nX
	
	oGrid:Refresh()
			 	
EndIf
CursorArrow()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLimpar   บAutor  ณJackson E. de Deus   บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa o conteudo das celulas - coluna do dia ou mes inteiroบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Limpar()

Local nOpcao := 0
Local nColPos := oGrid:oBrowse:nColPos
Local nI

nOpcao := Aviso("TTOPER08 - Limpar","Escolha o tipo de limpeza: " +CRLF +"1 - Horแrios do dia" +CRLF +"2 - Horแrios do m๊s",{"Dia","M๊s","Cancelar"})
If nOpcao == 3
	Return
EndIf

If nOpcao == 1
	If nColPos > 3
		For nI := 1 To Len(oGrid:aCols)
			oGrid:aCols[nI][nColPos] := ""
		Next nI	      
	EndIf
ElseIf nOpcao == 2
	For nI := 1 To Len(oGrid:aCols)
		nColPos := 3
		For nX := _dDtIni To _dDtFim
			nColPos++
			oGrid:aCols[nI][nColPos] := ""
		Next nCol
	Next nI	
EndIf

oGrid:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldField  บAutor  ณJackson E. de Deus  บ Data ณ  16/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o horario digitado no Grid                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldField()

Local nDia := oGrid:oBrowse:nColPos - 3
Local dDiaMes := stod( Cvaltochar(Year(dDatabase)) +StrZero(Month(dDatabase),2) +StrZero(nDia,2) )
Local aAuxHr := {}
Local cHrTurno := ""
Local cHrAux := ""
Local nPos := 0
Local lRet := .T.
Local cHora := "" 
Local lSabado := .F.

VldHora(dDiaMes,M->ZR_HORA,@cAlertHora)

Return lRet

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOrdena	บAutor  ณJackson E. de Deus  บ Data ณ  17/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ordena a coluna posicionada ao clicar no cabecalho         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ordena(nCol)

Local nLinha := oGrid:oBrowse:nAt
Local aAuxCol := aClone(oGrid:aCols)
Local aAux := {} 
Local aVazio := {}
Local aFinal := {}
Local lHora := .F.
Local lDigita := .F.

If nCol < 4
	Return
EndIf        

For nI := 1 To Len(aAuxCol)
	cHora := StrTran(aAuxCol[nI][nCol],":","")
	
	If nI == oGrid:oBrowse:nAt .And. IsInCallStack("VlCampo")
		lDigita := .T.
		cHora := StrTran(M->ZR_HORA,":","")
	EndIf
	
	If Empty( cHora )
		AADD( aVazio, { aAuxCol[nI][1], aAuxCol[nI][nCol], aAuxCol[nI][3] } )	// adicionar horarios vazios
	Else
		If lDigita
			aAuxCol[nI][nCol] := M->ZR_HORA
		EndIf
		AADD( aAux, { aAuxCol[nI][1], aAuxCol[nI][nCol], aAuxCol[nI][3]  } ) // horarios ok 
		lHora := .T.
	EndIf
Next nI
                                     
// ordena array auxiliar
Asort( aAux,,,{ |x,y| x[2] < y[2] } )

For nI := 1 To Len(aAux)
	For nJ := 1 To Len(aAuxCol)
		If aAuxCol[nJ][1] == aAux[nI][1] .And. aAuxCol[nJ][3] == aAux[nI][3]
			AADD( aFinal, aAuxCol[nJ] )
		EndIf
	Next nJ
Next nI

If Len(aVazio) > 0        
	For nI := 1 To Len(aVazio)
		For nJ := 1 To Len(aAuxCol)
			If aAuxCol[nJ][1] == aVazio[nI][1] .And. aAuxCol[nJ][3] == aVazio[nI][3]
				AADD( aFinal, aAuxCol[nJ] )
			EndIf
		Next nJ
	Next nI
EndIf

If lHora
	oGrid:SetArray(aFinal)
	oGrid:Refresh()                        
	oGrid:oBrowse:nAt := nLinha
	oGrid:oBrowse:nColPos := nCol
	oGrid:Refresh()     
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGridChangeบAutor  ณJackson E. de Deus  บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Na mudanca de linha, atualiza os dados do topo da janela   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GridChange(aItens,cRota)
                
Local cCodCli := ""	//
Local cLjCli := ""
Local cNome := ""
Local cEndCli := ""
Local cPatrim := ""
Local nPos := 0
Local lAtend := .F.
Local nI
Local cHora := ""
Local nDia := oGrid:oBrowse:nColPos - 3
Local dDiaMes := stod( Cvaltochar(Year(dDatabase)) +StrZero(Month(dDatabase),2) +StrZero(nDia,2) )
Local aAuxHr := {}
Local cHrTurno := ""
Local cHrAux := ""
Local cSeq := ""
Local lSabado := .F.
//Local cAlertHora := ""
                  
cPatrim := oGrid:aCols[oGrid:oBrowse:nAt][1]
cSeq := oGrid:ACols[oGrid:oBrowse:nAt][3] 

nPos := Ascan(aItens, { |x| AllTrim(x[1]) == AllTrim(cPatrim) .And. AllTrim(x[5]) == AllTrim(cSeq) } )
If nPos > 0
	cCodCli := AllTrim(aItens[nPos][6])
	cLjCli := AllTrim(aItens[nPos][7])
	cNome := AllTrim( Posicione( "SA1", 1, xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLjCli,"A1_LOJA"), "A1_NOME" ) )
	cEndCli :=  AllTrim(aItens[nPos][8]) +" / " +AllTrim(aItens[nPos][9]) +" / " +AllTrim(aItens[nPos][10])
	
	_cCliente := "<strong><font size=3 color=#EE6363>"  +cCodCli + "</strong>" 
	_cLoja := "<strong><font size=3 color=#EE6363>"  +cLjCli + "</strong>"
	_cNome := "<strong><font size=3 color=#EE6363>"  +cNome + "</strong>"
	_cEndereco := "<strong><font size=3 color=#EE6363>"  +cEndCli + "</strong>"
	cAbast := "<strong><font size=3 color=#483D8B>"  + TEC(cRota)[2] + "</strong>"
	
	// verifica atendimento no dia
	For nI := 1 To Len(aItens[nPos][16])
		If SubStr( aItens[nPos][16][nI], oGrid:oBrowse:nColPos-3,1 ) $ "1|F"
			lAtend := .T.		
		EndIf
	Next nI
	
	If lAtend
		cDescSrv := "<strong><font size=3 color=#EE6363>"  +aItens[nPos][12] + "</strong>"
	Else
		cDescSrv := ""
	EndIf
	
	// sequencia do atendimento no dia
	//_cSeqPatrim := "<strong><font size=3 color=#EE6363>"  +cvaltochar(Val(aItens[nPos][5])) + "</strong>"
			                    
	// verifica horario de atendimento x turno atendente - COMENTAR CASO NAO QUEIRA USAR
	// -> horario x turno
	cAlertHora := ""
	If oGrid:oBrowse:nColPos > 3
		cHora := oGrid:aCols[oGrid:oBrowse:nAt][oGrid:oBrowse:nColPos]
		VldHora(dDiaMes,cHora,@cAlertHora)
	EndIf
	// <- horario x turno
		
	oAbast:Refresh()
	oCli:Refresh()        
	oLoja:Refresh()        
	oNome:Refresh()  
	oEnd:Refresh()
	oDscSv:Refresh()  
	//oDscSeq:Refresh()
	oObsHora:Refresh()    	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldHora  บAutor  ณJackson E. de Deus   บ Data ณ  20/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida a hora digitada ou existente na celula              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldHora(dDiaMes,cHora,cAlertHora)
 
Local lRet := .T.
Local cAlertHora := ""
Local lSabado := .F.
Local aAuxHr := {}
//Local aTurno := {}
Local cHrTurno := ""
Local cHrAux := ""

Default cHora := ""
If Empty(cHora)
	Return
EndIf

If !Empty( aInfoTec[3] ) .And. !Empty( dDiaMes )
	aTurno := StaticCall( TTOPER17,Turno,aInfoTec[3],dDiaMes )
EndIf

If Dow(dDiaMes) == 7// .And. "SAB" $ cTurnoTec
	lSabado := .T.
EndIf
		
cHora := StrTran(cHora,":","")
If !Empty(cHora)
	cHora := SubStr(cHora,1,2) +":" +SubStr(cHora,3,2)
	If !lSabado
		// antes do expediente do atendente
		If cHora < aTurno[1]                                                                                        
			cTexto := "Horแrio inferior ao expediente do atendente."
			If IsInCallStack("VldField")                                                                            
				cAlertHora := cTexto
				If !MsgYesNo(cAlertHora +CRLF +"Utilizar mesmo assim?","TTOPER08 - VldField")
					lRet := .F.
				EndIf
			ElseIf IsInCallStack("GridChange")                                                                            
				cAlertHora := "<strong><font size=3 color=#CD0000>"+cTexto+"</strong>"
			EndIf
		// no almoco do atendente
		ElseIf cHora >= aTurno[2] .And. cHora <= aTurno[3]
			cTexto := "Horแrio entre o almo็o do atendente."
			If IsInCallStack("VldField")   
				cAlertHora := cTexto
				If !MsgYesNo(cAlertHora +CRLF +"Utilizar mesmo assim?","TTOPER08 - VldField")
					lRet := .F.
				EndIf
			ElseIf IsInCallStack("GridChange")  
				cAlertHora := "<strong><font size=3 color=#CD0000>"+cTexto+"</strong>"
			EndIf
		// apos expediente do atendente
		ElseIf cHora > aTurno[4]
			cTexto := "Horแrio posterior ao expediente do atendente."
			If IsInCallStack("VldField") 
				cAlertHora := cTexto
				If !MsgYesNo(cAlertHora +CRLF +"Utilizar mesmo assim?","TTOPER08 - VldField")
					lRet := .F.
				EndIf
			ElseIf IsInCallStack("GridChange")    
				cAlertHora := "<strong><font size=3 color=#CD0000>"+cTexto+"</strong>"
			EndIf
		EndIf
	Else
		// antes do expediente do atendente
		If cHora < aTurno[1]
			cTexto := "Horแrio inferior ao expediente do atendente."
			If IsInCallStack("VldField") 
				cAlertHora := cTexto
				If !MsgYesNo(cAlertHora +CRLF +"Utilizar mesmo assim?","TTOPER08 - VldField")
					lRet := .F.
				EndIf
			ElseIf IsInCallStack("GridChange")               
				cAlertHora := "<strong><font size=3 color=#CD0000>"+cTexto+"</strong>"
			EndIf
		// apos expediente do atendente
		ElseIf cHora > aTurno[2]
			cTexto := "Horแrio posterior ao expediente do atendente."
			If IsInCallStack("VldField") 
				cAlertHora := cTexto
				If !MsgYesNo(cAlertHora +CRLF +"Utilizar mesmo assim?","TTOPER08 - VldField")
					lRet := .F.
				EndIf
			ElseIf IsInCallStack("GridChange")  
				cAlertHora := "<strong><font size=3 color=#CD0000>"+cTexto+"</strong>"
			EndIf
		EndIf
	EndIf
EndIf
           
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregar  บAutor  ณJackson E. de Deus  บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz o carregamento inicial do grid na abertura da janela   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carregar(aItens,cRota)
                            
Local nX,nY                                    
Local dDia := _dDtIni
Local nDiaFim := Day( LastDay(dDatabase) )
Local aTrb2 := {}
Local nDiaAux := 0
Local cAno := CValToChar(YEAR(dDatabase))
Local cMes := StrZero(MONTH(dDatabase),2)

ProcRegua(1)

IncProc("Configurando campos..")
// Monta aHeader
AADD( aHeader,{"Patrimonio","CHAPA", "@!", 6, 0, ".F.", "", "C", "","R" } ) 
AADD( aHeader,{"Descricao","DESC", "@!", 30, 0, ".F.", "", "C", "","R" } ) 
   
dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("ZR_SEQ")
	AAdd(aHeader,{AllTrim(X3_TITULO), SX3->X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, "AllwaysTrue()", X3_USADO, X3_TIPO, X3_F3, X3_CONTEXT})
EndIf

If dbSeek("ZR_HORA")
	AADD( aAlter, SX3->X3_CAMPO )
	For nI := 1 To nDiaFim
		cDia := DiaSemana(dDia)
		Aadd( aHeader, {CVALTOCHAR(nI) +" - " +cDia,SX3->X3_CAMPO,"99:99",5,0,SX3->X3_VLDUSER,"","C","","R","","", "", "A"} )
		dDia++
	Next nI
EndIf	
	
If Len(aItens) > 0

	For nY := 1 To Len(aItens)
		aItens[nY][5] := cvaltochar(val(aItens[nY][5]))
	Next nY
   
	// Busca horarios da rota para o ano/mes 
	aTrb2 := U_TTOPER06(xFilial("SZR"),cRota,/*cCliente*/,/*cLoja*/,/*cPatrim*/,cAno,cMes) 
	For nY := 1 to len(aTrb2)
		Aadd(aTrabd,{aTrb2[nY,7],;	//[1] dia
					aTrb2[nY,4],;	//[2] patrimonio
					aTrb2[nY,8],;	//[3] horario
					aTrb2[nY,2],;	//[4] cliente
					aTrb2[nY,3],;	//[5] loja
					aTrb2[nY,5],;	//[6] ano
					aTrb2[nY,3],;	//[7] mes
					aTrb2[nY,9],;	//[8] sequencia  
					aTrb2[nY,12]})	//[9] tipo plano
									
	Next nY                                                         

                              
	ProcRegua(Len(aItens))  
	// Monta acols                   
	For nI := 1 To Len(aItens)
		IncProc()
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		
		For nCol := 1 To Len(aHeader)
			If nCol == 1 .Or. nCol == 2
				aCols[nLin][nCol] := aItens[nI][nCol]
			ElseIf nCol == 3
				aCols[nLin][nCol] := aItens[nI][5]
			Else
				nDiaAux++
				nPos := Ascan(aTrabd, { |x| AllTrim(x[2]) == AllTrim(aItens[nI][1]) .And. ;	// patrimonio
											Val(x[1]) == nDiaAux .And. ;						// dia
											AllTrim(x[4]) == AllTrim(aItens[nI][6]) .And. ;	// cliente
											AllTrim(x[5]) == AllTrim(aItens[nI][7]) .And.;		// loja
											AllTrim(x[8]) == AllTrim(aItens[nI][5]) .and. ;	// sequencia
											AllTrim(x[9]) == AllTrim(aItens[nI][4])	} ) 	// tipo plano
				If nPos > 0
					cHr := SubStr(aTrabd[nPos][3],1,2)
					cMin := SubStr(aTrabd[nPos][3],4)
					aCols[nLin][nCol] := cHr +":" +cMin
				Else
					aCols[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
				EndIf		
			EndIf
		Next nCol
		nDiaAux := 0                 
		aCols[nLin][Len(aHeader)+1] := .F. 
	Next nI
EndIf	      

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDiaSemana บAutor  ณJackson E. de Deus  บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o dia da semana abreviado.					      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DiaSemana(dDia)

Local cdia := ""    

If Dow(dDia) == 1
	cdia := "Dom"
ElseIf Dow(dDia) == 2
	cDia := "Seg"
ElseIf Dow(dDia) == 3
	cDia := "Ter"
ElseIf Dow(dDia) == 4
	cDia := "Qua"
ElseIf Dow(dDia) == 5
	cDia := "Qui"
ElseIf Dow(dDia) == 6
	cDia := "Sex"
ElseIf Dow(dDia) == 7
	cDia := "Sab"
EndIf                     

Return cDia


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar    บAutor  ณJackson E. de Deus  บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava na tabela os horarios definidos para o calendario    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(aItens,aGrid,cRota)

Local nX,nI,nY
Local cCodFil := ""
Local cNumChapa := ""
Local cCliente := ""
Local cLoja := ""
Local cHora := ""
Local nI
Local lOk := .T.
Local cSeq := ""
Local cTpPla := ""

CursorWait()

cCodFil := xFilial("SZR")
    
ProcRegua(Len(aGrid))	

//BeginTran()
BEGIN SEQUENCE
	dbSelectArea("SZR")
	dbSetOrder(2)	// filial rota patrimonio ano mes dia sequencia tipopla
	
	For nX := 1 To Len(aItens)
		cCliente := AllTrim(aItens[nX][6])
		cLoja := AllTrim(aItens[nX][7])
		cTpPla := AllTrim(aItens[nX][4])
		For nI := 1 To Len(aGrid)
			If aGrid[nI][1] == aItens[nX][1] .And. aGrid[nI][3] == aItens[nX][5]
				cPatrim := aGrid[nI][1]
				cSeq := aGrid[nI][3]
				IncProc("Patrimonio " +cPatrim)
				/*
				nPos := Ascan(aItens, { |x| AllTrim(x[1]) == AllTrim(cPatrim) .And. AllTrim(x[5]) == AllTrim(cSeq) } )
				If nPos > 0
					cCliente := AllTrim(aItens[nPos][6])
					cLoja := AllTrim(aItens[nPos][7])
				EndIf	
			    */
				cAno := cvaltochar(Year(dDatabase))
				cMes := StrZero(Month(dDatabase),2)
			
				nCol := 3
				
				For nY := _dDtIni To _dDtFim
					nCol++
					cDia := strzero(Day(nY),2)
					cHora := Alltrim(aGrid[nI][nCol])
					
					If MSSeek( cCodFil +AvKey(cRota,"ZR_ROTA")+AvKey(cPatrim,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDia,"ZR_DIA") +AvKey(cSeq,"ZR_SEQ") +Avkey(cTpPla,"ZR_TIPOPLA")  )
						RecLock("SZR",.F.)
						//SZR->ZR_FILIAL := cCodFil
						//SZR->ZR_ROTA := cRota
						SZR->ZR_CLIENTE := cCliente
						SZR->ZR_LOJA := cLoja
						//SZR->ZR_CHAPA := cPatrim
						//SZR->ZR_ANO := cAno
						//SZR->ZR_MES := cMes
						//SZR->ZR_DIA := cDia
						SZR->ZR_HORA := cHora
						//SZR->ZR_SEQ := cSeq
						//SZR->ZR_TIPOPLA := cTpPla
						SZR->ZR_DATA := stod(cAno+cMes+cDia)
						SZR->ZR_DIASEMA := CVALTOCHAR(DOW(stod(cAno+cMes+cDia)))
						MsUnLock()                    
					Else
						RecLock("SZR",.T.)
						SZR->ZR_FILIAL := cCodFil
						SZR->ZR_ROTA := cRota
						SZR->ZR_CLIENTE := cCliente
						SZR->ZR_LOJA := cLoja
						SZR->ZR_CHAPA := cPatrim
						SZR->ZR_ANO := cAno
						SZR->ZR_MES := cMes
						SZR->ZR_DIA := cDia
						SZR->ZR_HORA := cHora
						SZR->ZR_SEQ := cSeq
						SZR->ZR_TIPOPLA := cTpPla
						SZR->ZR_DATA := stod(cAno+cMes+cDia)
						SZR->ZR_DIASEMA := CVALTOCHAR(DOW(stod(cAno+cMes+cDia)))
						MsUnLock()
					EndIf
					
					//U_TTOPER07(cCodFil,cRota,cCliente,cLoja,cPatrim,cAno,cMes,cDia,cHora, cSeq, cTpPla)
				Next nY //nCol
			EndIf	
		Next nI
	Next nX
END SEQUENCE
         
If lOk
	//EndTran()
Else
	//MsgAlert( "Houve erro ao gravar os horแrios." +CRLF +"Tente novamente.", "TTOPER08 - Gravar" )	
EndIf	
CursorArrow()	

MsUnLockAll()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlanilha  บAutor  ณJackson E. de Deus  บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera planilha em excel com os horarios do mes               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Planilha(aGrid,aItens,cRota)

Local oExcel := FWMSEXCEL():New()
Local nDiaIni := Day(_dDtIni)
Local nDiaFim := Day(_dDtFim)
Local nTotDias := nDiaFim-nDiaIni +1
Local cCodCli := ""
Local cLjCli := ""
Local nColPos := 0
Local cTitulo := "Calendario"
Local cDir := "c:\temp\"
Local cTecnico := TEC(cRota)[2]
Local cCabeca := "Rota "+cRota+" / Abastecedor - "+cTecnico
Local cTime := Time()
Local cArqXls := "calendario" +SubStr(cTime,1,2) +SubStr(cTime,4,2) +SubStr(cTime,7) +".xml" 


oExcel:AddworkSheet(cTitulo) 
oExcel:AddTable (cTitulo,cCabeca)

oExcel:AddColumn(cTitulo,cCabeca,"Nome",1,1) 
oExcel:AddColumn(cTitulo,cCabeca,"Endere็o",1,1) 
oExcel:AddColumn(cTitulo,cCabeca,"Patrim๔nio",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Modelo",1,1)
		
For nX := _dDtIni To _dDtFim
	oExcel:AddColumn(cTitulo,cCabeca,cvaltochar(Day(nX))+"-"+DiaSemana(nX),1,1) 
Next nX

For nX := 1 To Len(aGrid)
	aRow := Array(4+nTotDias)                         
	nPos := Ascan(aItens, { |x| AllTrim(x[1]) == AllTrim(aGrid[nX][1]) } ) // busca patrimonio

	If nPos > 0
		cCodCli := AllTrim(aItens[nPos][6])
		cLjCli := AllTrim(aItens[nPos][7])
		aRow[1] := AllTrim( Posicione( "SA1", 1, xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLjCli,"A1_LOJA"), "A1_NOME" ) )
		aRow[2] := AllTrim(aItens[nPos][8]) +" / " +AllTrim(aItens[nPos][9]) +" / " +AllTrim(aItens[nPos][10])	
		aRow[3] := aGrid[nX][1]
		aRow[4] := aGrid[nX][2]
	EndIf
	
	nPosRow := 4
	nColPos := 3
	For nY := nDiaIni To nDiaFim    
		nColPos++
		nPosRow++
		aRow[nPosRow] := aGrid[nX][nColPos]
	Next nY

	oExcel:AddRow(cTitulo,cCabeca, aRow )							
Next nX
										
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTOPER08 - Planilha","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTOPER08 - Planilha", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTEC บAutor  ณJackson E. de Deus        บ Data ณ  08/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o nome do tecnico de acordo com a rota              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TEC(cRota)

Local cQuery := "SELECT AA1_CODTEC, AA1_NOMTEC, AA1_TURNO FROM " +RetSqlname("AA1") + " WHERE AA1_LOCAL = '"+cRota+"' AND D_E_L_E_T_ = '' "
Local aRet := {"","",""}
            
If Select("TX") > 0
	TX->(dbCloseArea())
EndIf
TcQuery cQuery New Alias "TX"

dbSelectArea("TX")
If !EOF() 
	aRet[1] := AllTrim(TX->AA1_CODTEC)
	aRet[2] := AllTrim(TX->AA1_NOMTEC)
	aRet[3] := AllTrim(TX->AA1_TURNO)
EndIf
TX->(dbCloseArea())
      
Return aRet

     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTurno  บAutor  ณJackson E. de Deus     บ Data ณ  10/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o turno de trabalho do tecnico                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Turno(cTurno)

Local cDesc := ""
Default cTurno := ""

If Empty(cTurno)
	Return cDesc
EndIf

dbSelectArea("SR6")
dbSetOrder(1)
If dbSeek( xFilial("SR6") +AvKey( cTurno,"R6_TURNO" ) )
	cDesc := SR6->R6_DESC
EndIf

Return cDesc

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkRota  บAutor  ณJackson E. de Deus   บ Data ณ  20/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerificacao da rota ao sair do programa                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkRota(cRota)

Local cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlname("AA1") + " WHERE AA1_LOCAL = '"+cRota+"' AND D_E_L_E_T_ = '' "
Local nTotal := 0
            
If Select("TX") > 0
	TX->(dbCloseArea())
EndIf
TcQuery cQuery New Alias "TX"

dbSelectArea("TX")
nTotal := TX->TOTAL

TX->(dbCloseArea())
If nTotal = 0      
	Aviso("TTOPER08 - ChkRota","Essa rota nใo estแ vinculada em nenhum T้cnico." +CRLF +"As Ordens de Servi็o serใo geradas somente se o cadastro do T้cnico estiver vinculado na Rota.";
			+CRLF +"Rota: " +cRota ,{"Ok"})
ElseIf nTotal > 1
	Aviso("TTOPER08 - ChkRota","Essa rota estแ vinculada em mais de um T้cnico." +CRLF +"Verifique se isso estแ correto no cadastro de t้cnicos.";
			+CRLF +"Rota: " +cRota +CRLF +"T้cnicos vinculados: " +cvaltochar(nTotal),{"Ok"})
EndIf      

Return