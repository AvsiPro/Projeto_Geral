#include "protheus.ch"
#include "tbiconn.ch"
 
/*
--------------------------------------------------------------------------------
Programa: Classe Calend
Autor: Jackson E. de Deus
Data: 07/07/2014
Descricao: Calendario
--------------------------------------------------------------------------------
*/
CLASS Calend
                  
	DATA oFrameAll					// Frame geral
	DATA oFrameTop					// Frame topo
	DATA oFrameTop2					// Frame topo 2
	//DATA oFrameCenter				// Frame central  
	DATA oFrmLin1					// Frame linha 1
	DATA oFrmLin2					// Frame linha 2
	DATA oFrmLin3					// Frame linha 3
	DATA oFrmLin4					// Frame linha 4
	DATA oFrmLin5					// Frame linha 5
	DATA oFrmLin6					// Frame linha 6
	DATA oFrmCol1
	DATA oXY1
	DATA oXY2
	DATA oXY3
	DATA oXY4
	DATA oXY5
	DATA oXY6
	DATA oXY7
	DATA oXY8
	DATA oXY9
	DATA oXY10
	DATA oXY11
	DATA oXY12
	DATA oXY13
	DATA oXY14
	DATA oXY15
	DATA oXY16
	DATA oXY17
	DATA oXY18
	DATA oXY19
	DATA oXY20
	DATA oXY21
	DATA oXY22
	DATA oXY23
	DATA oXY24
	DATA oXY25
	DATA oXY26
	DATA oXY27
	DATA oXY28
	DATA oXY29
	DATA oXY30
	DATA oXY31
	DATA oXY32
	DATA oXY33
	DATA oXY34
	DATA oXY35
	DATA oXY36
	DATA oXY37
	
	DATA oBtLeftY					// botao < ANO
	DATA oBtLeftM					// botao < MES
	DATA oBtRightY					// botao > ANO
	DATA oBtRightM					// botao > MES
	
	// Botoes dos dias
	DATA oDia1
	DATA oDia2
	DATA oDia3
	DATA oDia4
	DATA oDia5
	DATA oDia6
	DATA oDia7
	DATA oDia8
	DATA oDia9
	DATA oDia10
	DATA oDia11
	DATA oDia12
	DATA oDia13
	DATA oDia14
	DATA oDia15
	DATA oDia16
	DATA oDia17
	DATA oDia18
	DATA oDia19
	DATA oDia20
	DATA oDia21
	DATA oDia22
	DATA oDia23
	DATA oDia24
	DATA oDia25
	DATA oDia26
	DATA oDia27
	DATA oDia28
	DATA oDia29
	DATA oDia30
	DATA oDia31 
	DATA nCor						// cor normal dos dias
	DATA nCorMark					// cor dos dias marcados
	DATA nCorFer					// cor dos dias feriados
	DATA nCorDSem					// cor dos dias da semana - cabecalho
	DATA nCorDMes					// cor dos meses/ano - cabecalho
	DATA dDataAtual					// data atual - database                                
	DATA aDiasMark					// dias marcados
	DATA aDiasFer					// dias feriado
	DATA cAnoMes  
	DATA aTextoHtm
	DATA lEditable
	DATA cProgVld					// programa de validacao da escolha dos dias
	DATA cActionClk					// programa executado apos o clique no dia
	
	
	METHOD New(nRow,nCol,oDlg,dData,nCor,nCorMark,nCorFer,nCorDSem,nCorDMes,lEditable,cProgVld,cActionClk) CONSTRUCTOR	// Construtor                      
    METHOD Activate()													// Ativa o calendario
    METHOD GoLeftM()													// volta um mes 
    METHOD GoRightM()													// avanca um mes
    METHOD GoLeftY()													// volta um ano 
    METHOD GoRightY()													// avanca um ano
    METHOD AddMark(dData,bBlockVld)										// Marca um dia
    METHOD DelMark(dData)												// Desmarca um dia
    METHOD ADDAll()														// Marca tudo do mes/ano	- usado pelo usuario
    METHOD DelAll()														// Desmarca tudo do mes/ano	- usado pelo usuario
    METHOD Feriado(aDias)												// Adiciona dias de feriado ao calendario
    METHOD Seleciona()													// Marca/Desmarca o dia clicado -> INTERNO NAO USAR DIRETAMENTE                 
    METHOD AtuHtml()													// Atualiza os html da tela -> INTERNO NAO USAR DIRETAMENTE
                                     
ENDCLASS
 
                  
/*
--------------------------------------------------------------------------------
Programa: Metodo New
Autor: Jackson E. de Deus
Data: 07/07/2014
Descricao: Construtor da classe
--------------------------------------------------------------------------------
*/
METHOD New(nRow,nCol,oDlg,dData,nCor,nCorMark,nCorFer,nCorDSem,nCorDMes,lEditable,cProgVld,cActionClk) CLASS Calend
    	
	Local nLarg := 210
	Local nAlt := 155
	Local cStyle := "Q3Frame{ border-style:solid; border-width:1px; border-color:#5D7DC7; background-color:#FFFFFF  }"            
	Local nAltLin := 20
	Local lHtml := .T.
	Local oFont := TFont():New('Courier new',,-18,.T.)
	Local chtmDom := ""
	Local chtmSeg := ""
	Local chtmTer := ""
	Local chtmQua := ""
	Local chtmQui := ""
	Local chtmSex := ""
	Local chtmSab := ""
	               
	Default nRow := 0
	Default nCol := 0
	Default oDlg := Nil
	Default dData := dDatabase
	Default nCor := "#000000"
	Default nCorMark := "#FFA001"
	Default nCorDSem := "#696969"
	Default nCorDMes := "#B03060"
	Default lEditable := .T.
	Default cProgVld := ""
	Default cActionClk := ""
	
	::cAnoMes := ""
	::dDataAtual := dData
	::nCor := nCor
	::nCorMark := nCorMark
	::nCorFer := nCorFer
	::nCorDSem := nCorDSem
	::nCorDMes := nCorDMes
	::aDiasMark := {}
	::aDiasFer := {}
	::aTextoHtm := {}
	::lEditable := lEditable
	::cProgVld := cProgVld
	::cActionClk := cActionClk
	
	// Define labels dias da semana - cabecalho
	chtmDom := '<font size=3 color='+nCorDSem+'>Dom'
	chtmSeg := '<font size=3 color='+nCorDSem+'>Seg'
	chtmTer := '<font size=3 color='+nCorDSem+'>Ter'
	chtmQua := '<font size=3 color='+nCorDSem+'>Qua'
	chtmQui := '<font size=3 color='+nCorDSem+'>Qui'
	chtmSex := '<font size=3 color='+nCorDSem+'>Sex'
	chtmSab := '<font size=3 color='+nCorDSem+'>Sab'
                  
    // painel geral                                                                            
    ::oFrameAll := TPanelCss():New(nRow,nCol,"",oDlg,,.F.,.F.,,,nLarg,nAlt,.F.,.F.)
    ::oFrameAll:setCSS( cStyle ) 
    
    // painel topo
    ::oFrameTop := TPanelCss():New(0,0,"",::oFrameAll,,.F.,.F.,,,nLarg,15,.F.,.F.)
    ::oFrameTop:setCSS( cStyle ) 

    // painel topo 2
    ::oFrameTop2 := tPanel():New(16,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,12,.F.,.F. )
        
	oLinha := TSay():New(25,1,{ || "<font size=2 color=black><hr>" },::oFrameAll,,oFont,,,,.T.,,CLR_BLACK,nLarg-2,4,,,,,,lHtml) 
                                         
    // Define frames dos dias do mes ( 5 linhas )
    ::oFrmLin1 := tPanel():New(32,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,nAltLin,.F.,.F.  )
    ::oFrmLin2 := tPanel():New(52,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,nAltLin,.F.,.F.  )
    ::oFrmLin3 := tPanel():New(72,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,nAltLin,.F.,.F.  )
    ::oFrmLin4 := tPanel():New(92,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,nAltLin,.F.,.F.  )
    ::oFrmLin5 := tPanel():New(112,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,nAltLin,.F.,.F.  )
    ::oFrmLin6 := tPanel():New(132,1,,::oFrameAll,,,,,CLR_WHITE,nLarg-2,nAltLin,.F.,.F.  )
       
	// Define os frames das posicoes dos dias do mes no calendario - 35 posicoes
	::oXY1 := tPanel():New(0,0,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )                                     
    ::oXY2 := tPanel():New(0,30,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY3 := tPanel():New(0,60,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY4 := tPanel():New(0,90,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY5 := tPanel():New(0,120,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY6 := tPanel():New(0,150,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY7 := tPanel():New(0,180,,::oFrmLin1,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )

	::oXY8 := tPanel():New(0,0,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )                                     
    ::oXY9 := tPanel():New(0,30,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY10 := tPanel():New(0,60,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY11 := tPanel():New(0,90,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY12 := tPanel():New(0,120,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY13 := tPanel():New(0,150,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY14 := tPanel():New(0,180,,::oFrmLin2,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    
    ::oXY15 := tPanel():New(0,0,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )                                     
    ::oXY16 := tPanel():New(0,30,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY17 := tPanel():New(0,60,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY18 := tPanel():New(0,90,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY19 := tPanel():New(0,120,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY20 := tPanel():New(0,150,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY21 := tPanel():New(0,180,,::oFrmLin3,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    
    ::oXY22 := tPanel():New(0,0,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )                                     
    ::oXY23 := tPanel():New(0,30,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY24 := tPanel():New(0,60,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY25 := tPanel():New(0,90,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY26 := tPanel():New(0,120,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY27 := tPanel():New(0,150,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY28 := tPanel():New(0,180,,::oFrmLin4,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
          
	::oXY29 := tPanel():New(0,0,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )                                     
    ::oXY30 := tPanel():New(0,30,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY31 := tPanel():New(0,60,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY32 := tPanel():New(0,90,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY33 := tPanel():New(0,120,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY34 := tPanel():New(0,150,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
    ::oXY35 := tPanel():New(0,180,,::oFrmLin5,,,,,CLR_WHITE,30,nAltLin,.F.,.F.  )
                                                                                    
    ::oXY36 := tPanel():New(0,0,,::oFrmLin6,,,,,CLR_WHITE,30,nAltLin,.F.,.F. )
    ::oXY37 := tPanel():New(0,30,,::oFrmLin6,,,,,CLR_WHITE,30,nAltLin,.F.,.F. )
    
    // botoes topo
    ::oBtLeftY := TBtnBmp2():New( 0,0,48,48,'ano_left.png',,,,{ || Self:GoLeftY() },::oFrameTop,"Retroceder ano",,.T. )
   	::oBtLeftM := TBtnBmp2():New( 0,0,48,48,'mes_left.png',,,,{ || Self:GoLeftM() },::oFrameTop,"Retroceder mes",,.T. )
    ::oBtLeftY:Align := CONTROL_ALIGN_LEFT
    ::oBtLeftM:Align := CONTROL_ALIGN_LEFT
    
    // Say Ano/Mes
    oAno := TSay():New(02,055,{ || ::cAnoMes },::oFrameTop,,oFont,,,,.T.,,,90,8,,,,,,lHtml) 
    
    ::oBtRightY := TBtnBmp2():New( 0,0,48,48,'ano_right.png',,,,{ || Self:GoRightY()  },::oFrameTop,"Avancar ano",,.T. )
   	::oBtRightM := TBtnBmp2():New( 0,0,48,48,'mes_right.png',,,,{ || Self:GoRightM() },::oFrameTop,"Avancar mes",,.T. )
    ::oBtRightY:Align := CONTROL_ALIGN_RIGHT
    ::oBtRightM:Align := CONTROL_ALIGN_RIGHT
 
    // Says dos dias da semana                                                                                        	                               	
	oDom := TSay():New(1,006,{ || chtmDom },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	oSeg := TSay():New(1,036,{ || chtmSeg },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	oTer := TSay():New(1,066,{ || chtmTer },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	oQua := TSay():New(1,096,{ || chtmQua },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	oQui := TSay():New(1,126,{ || chtmQui },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	oSex := TSay():New(1,156,{ || chtmSex },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	oSab := TSay():New(1,185,{ || chtmSab },::oFrameTop2,,oFont,,,,.T.,,,20,10,,,,,,lHtml)
	
Return SELF
 
      
// Carrega o calendario
METHOD Activate() CLASS Calend

	Local dDiaIni := FirstDay(Self:dDataAtual)		// dia inicial
	Local dDiaFim := LastDay(Self:dDataAtual)		// dia final
	Local nDiaSemIni := Dow(dDiaIni)				// dia semana inicial
	Local nPos := nDiaSemIni
	Local nPos2
	Local lHtml := .T.
	Local oFont := TFont():New('Courier new',,-18,.T.)
	Local cTextHtml := ""                              
	
	// Limpa os dias                          
	For nI := 1 To 31
		If ValType( &( 'oCalend:oDia' +cvaltochar(nI) ) ) == "O"
			FreeObj( &( 'oCalend:oDia' +cvaltochar(nI) ) )          
		EndIf
	Next nI
	
	For nI := dDiaIni to dDiaFim
		nPos2 := AScan( ::aDiasMark, { |x| x == nI  } )
		// encontrou - traz marcado
		If nPos2 > 0
			bSource :=  "{ || '<strong><font size=3 color=" +Self:nCorMark+">" +CValToChar(Day(nI)) +"' }"
		// traz desmarcado
		Else
			bSource :=  "{ || '<strong><font size=3 color=" +Self:nCor+">" +CValToChar(Day(nI)) +" ' }"
			// verifica feriado
			If Ascan( Self:aDiasFer, { |x| x == nI  } ) > 0
				bSource :=  "{ || '<strong><font size=3 color=" +Self:nCorFer +">"+CValToChar(Day(nI)) +" ' }"
			EndIf	
		EndIf
						
		cAux := cvaltochar(day(nI))		
		bAction := "{ |o| { Self:Seleciona("+cAux+","+dtos(nI)+") } }"	                                                                                                                                                                        
		
		&('oCalend:oDia'+cvaltochar(Day(nI))) := TSay():New(03,010,&bSource, &('oCalend:oXY'+cvaltochar(nPos)) ,,oFont,,,,.T.,,,300,100,,,,,,lHtml) 
		&('oCalend:oDia'+cvaltochar(Day(nI))):bLClicked :=  &bAction
	
		nPos++
	Next nI
	                                            
	// atualiza html do mes/ano
	::AtuHtml()

Return
                       

// recua um mes                                                     
METHOD GoLeftM() CLASS Calend

	Self:dDataAtual := MonthSub( Self:dDataAtual, 1 )
	::Activate()
	
Return
               
// avanca um mes
METHOD GoRightM() CLASS Calend
	
	Self:dDataAtual := MonthSum( Self:dDataAtual, 1 )
    ::Activate()
    
Return
                
// recua um ano
METHOD GoLeftY() CLASS Calend
	        	
	Self:dDataAtual := YearSub( Self:dDataAtual, 1 )
	::Activate()
	
Return

// avanca um ano
METHOD GoRightY() CLASS Calend				// avanca um ano
	    
	Self:dDataAtual := YearSum( Self:dDataAtual, 1 )
	::Activate()
	
Return
                             
// selecao do dia
METHOD Seleciona(nDia,cData) CLASS Calend				// Marca um dia no calendario
    
	Local nPos
	Local dDataAux := SToD(CValToChar(cData))
	Local lFeriado := .F.
	Local lOk := .T.
	Local aAxExecF := {}
	Local bError         := { |e| oError := e , Break(e) }
	Local bErrorBlock    := ErrorBlock( bError )
	Local oError
	
	// verifica se pode alterar o calendario
	If !Self:lEditable
		Return
	EndIf
	            
	BEGIN SEQUENCE
		// validacao
		If !Empty( Self:cProgVld )
			lOk := .F.
			If UPPER(SubStr(Self:cProgVld,1,2)) == "U_"	// padrao USER FUNCTION - U_XFUN
				If FindFunction(Self:cProgVld)
					Eval( &( "{|| lOk := " +Self:cProgVld +"(" +cvaltochar(cData) +")" +"}" ) )		
				EndIf	
			ElseIf UPPER(SubStr(Self:cProgVld,1,10)) == "STATICCALL"	// padrao STATICCALL - STATICCALL|XFUNPRW|FUNCAO_ESTATICA
				aAxExecF := StrTokarr(Self:cProgVld,"|")
				If Len(aAxExecF) >= 3
					Eval( &( "{|| lOk := " +aAxExecF[1] +"(" +aAxExecF[2] +"," +aAxExecF[3] +"," +cvaltochar(cData) +")" +"}" ) )		
				EndIf
			EndIf
		EndIf
	RECOVER
		MsgAlert( ProcName() +CRLF + Str(ProcLine()) +CRLF +oError:ErrorStack )            
		CONOUT( ProcName() +CRLF + Str(ProcLine()) +CRLF +oError:ErrorStack )            
	END SEQUENCE	
	
	If lOk
		// programa executado apos o clique do dia - sem validacao
		If !Empty( Self:cActionClk )
			If UPPER(SubStr(Self:cActionClk,1,2)) == "U_"	// padrao USER FUNCTION - U_XFUN
				If FindFunction(Self:cActionClk)
					Eval( &( "{|| " +Self:cActionClk +"(" +cvaltochar(cData) +")" +"}" ) )		
				EndIf	
			ElseIf UPPER(SubStr(Self:cActionClk,1,10)) == "STATICCALL"	// padrao STATICCALL - STATICCALL|XFUNPRW|FUNCAO_ESTATICA
				aAxExecF := StrTokarr(Self:cActionClk,"|")
				If Len(aAxExecF) >= 3
					Eval( &( "{|| " +aAxExecF[1] +"(" +aAxExecF[2] +"," +aAxExecF[3] +"," +cvaltochar(cData) +")" +"}" ) )		
				EndIf
			EndIf
		EndIf
	                      
		aSort( Self:aDiasMark )
		nPos := AScan( Self:aDiasMark, { |x| x == dDataAux } )
		
		// Encontrou - remove/desmarca
		If nPos > 0
			aDel( Self:aDiasMark, nPos )
			ASize( Self:aDiasMark, Len( Self:aDiasMark )-1 )
			
			nPos := AScan( Self:aDiasFer, { |x| x == dDataAux } )
			If nPos > 0
				lFeriado := .T.
			EndIf
			If !lFeriado	
		 		&('oCalend:oDia' +cvaltochar(nDia) ):cCaption := "<strong><font size=3 color="+Self:nCor+">" +CValToChar(nDia)
		 	Else 
			 	&('oCalend:oDia' +cvaltochar(nDia) ):cCaption := "<strong><font size=3 color="+Self:nCorFer+">" +CValToChar(nDia)
		 	EndIf
		// Nao encontrou - adiciona/marca
		Else
			AADD( Self:aDiasMark, dDataAux  ) 
			&('oCalend:oDia' +cvaltochar(nDia) ):cCaption := "<strong><font size=3 color="+Self:nCorMark+">" +CValToChar(nDia)			 
		EndIf
	EndIf	
	
Return

// Marca tudo do mes/ano
METHOD ADDAll() CLASS Calend				
	
	Local dDiaIni := FirstDay(Self:dDataAtual)		// dia inicial
	Local dDiaFim := LastDay(Self:dDataAtual)		// dia final
	                                       
	aSort( Self:aDiasMark )
	For nI := dDiaIni to dDiaFim
		nPos := AScan( Self:aDiasMark, { |x| x == nI } )
		
		If nPos == 0
			AADD( Self:aDiasMark, nI  )		
			&('oCalend:oDia' +cvaltochar(Day(nI)) ):cCaption := "<strong><font size=3 color="+Self:nCorMark+">" +CValToChar( Day(nI) )		       
		EndIf
	Next nI  
	
Return
      
// Desmarca todos os dias do mes/ano
METHOD DelAll() CLASS Calend     

	Local dDiaIni := FirstDay(Self:dDataAtual)		// dia inicial
	Local dDiaFim := LastDay(Self:dDataAtual)		// dia final
	                                    
	aSort( Self:aDiasMark )	
	For nI := dDiaIni to dDiaFim
		nPos := AScan( Self:aDiasMark, { |x| x == nI } )		
		If nPos > 0
			aDel( Self:aDiasMark, nPos )
			ASize( Self:aDiasMark, Len( Self:aDiasMark )-1 )
	  		&('oCalend:oDia' +cvaltochar( Day(nI)) ):cCaption := "<strong><font size=3 color="+Self:nCor+">" +CValToChar( Day(nI) )	              
		EndIf                                                            
	 Next nI	
	
Return    
    
// Atualiza o html de mes/ano              
METHOD AtuHtml() CLASS Calend

	Local cAuxHtm := '<font size=3 color='+Self:nCorDMes+'>'
    Local cAno := cValToChar( Year( Self:dDataAtual ) )
    Local nMes := Month( Self:dDataAtual )
    Local cMes := ""
    
    If nMes == 1
	    cMes := "Janeiro"
    ElseIf nMes == 2
	    cMes := "Fevereiro"    
    ElseIf nMes == 3
   	    cMes := "Março"
    ElseIf nMes == 4
   	    cMes := "Abril"
    ElseIf nMes == 5
   	    cMes := "Maio"
    ElseIf nMes == 6
   	    cMes := "Junho"
    ElseIf nMes == 7
	    cMes := "Julho"    
    ElseIf nMes == 8
	    cMes := "Agosto"    
    ElseIf nMes == 9
	    cMes := "Setembro"    
    ElseIf nMes == 10
	    cMes := "Outubro"    
    ElseIf nMes == 11
	    cMes := "Novembro"    
    ElseIf nMes == 12
	    cMes := "Dezembro"    
    EndIf                
    
	Self:cAnoMes := cAuxHtm +cMes + " / " +cAno
                  
Return

      
// Adiciona dias de feriado ao calendario
METHOD Feriado(aDias) CLASS Calend    

	If ValType(aDias) <> "A"
		Return
	EndIf
	
	For nI := 1 To Len(aDias)
		If ValType(aDias[nI]) <> "D"
			Loop
		EndIf
		If Ascan( Self:aDiasFer, { |x| x == aDias[nI] } ) == 0
			AADD( Self:aDiasFer, aDias[nI] )
			If Year(aDias[nI]) == Year(Self:dDataAtual) .And. Month(aDias[nI]) == Month(Self:dDataAtual)
				&('oCalend:oDia' +cvaltochar(Day(aDias[nI])) ):cCaption := "<strong><font size=3 color="+Self:nCorFer+">" +CValToChar( Day(aDias[nI]) )		                                           
			EndIf
		EndIf	
	Next nI

Return


// Adiciona marca a algum dia
METHOD AddMark(dData,bBlockVld) CLASS Calend
                    
	aSort( Self:aDiasMark )
	If AScan( Self:aDiasMark, { |x| x == dData } ) == 0
		AADD( Self:aDiasMark, dData  ) 
		&('oCalend:oDia' +cvaltochar(Day(dData)) ):cCaption := "<strong><font size=3 color="+Self:nCorMark+">" +CValToChar( Day(dData) )			 
	EndIf

Return

// Remove marca de algum dia
METHOD DelMark(dData) CLASS Calend
	        
	Local nPos
	
	aSort( Self:aDiasMark )
	nPos := AScan( Self:aDiasMark, { |x| x == dData } )	
	If nPos > 0	
		aDel( Self:aDiasMark, nPos )
		ASize( Self:aDiasMark, Len( Self:aDiasMark )-1 )
		&('oCalend:oDia' +cvaltochar( Day(dData)) ):cCaption := "<strong><font size=3 color="+Self:nCor+">" +CValToChar( Day(dData) )			 
	EndIf

Return