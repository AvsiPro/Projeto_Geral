#include "protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER14  บAutor  ณJackson E. de Deus  บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manutencao de plano de trabalho do patrimonio	          บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ01/12/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTOPER14(cPatrimo,cCliente,cLoja,nRecnoZE)

Local aArea		:= GetArea()
Local cSql		:= ""
Local oDlg		:= Nil
Local oLayerC	:= FwLayer():New()
Local nCor		:= "#000000"
Local nCorMark	:= "#FFA001"
Local nCorFer	:= "#111AAA"
Local nCorDSem	:= "#696969"
Local nCorDMes	:= "#B03060"
Local aDiasFer	:= {}
Local lEditable	:= .T.
Local oFont		:= TFont():New('Arial',,-12,.T.,.T.)
Local lOk		:= .F.
Local cAuxFreq	:= "" 
Local aFreq		:= {}
Local cSeq		:= Space(3)
Local cTpPla	:= ""	// sangria rota
Local cTipoPla	:= ""	// tipo plano
Local cProgVld	:= "STATICCALL|TTOPER14|VALIDCLICK"	// programa de validacao da inclusao de dias no calendario - metodos de utilizacao -> U_TTOPER16 OU STATICCALL|TTOPER16|VALIDA
Local aTpPlan := { "Leitura","Sangria","Abastecimento" }
//Local cActionClk := "STATICCALL|TTOPER14|POSCLICK"	// programa executado apos o clique
Private cTpPlan		:= ""
Private cFreq		:= Space(2) 
Private cRota		:= Space(6)
Private _cFechame	:= ""
Private _cMes		:= "" 
Private _aDias		:= {}
Private _cMensal	:= ""
Private _aFeriado	:= {}
Private _lOmm		:= .F.
Private oCalend		:= Nil
Private aDiasMark	:= {}

Default cPatrimo	:= ""
Default cCliente	:= ""
Default cLoja		:= ""
Default nRecnoZE	:= 0

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cPatrimo) .Or. Empty(cCliente) .Or. Empty(cLoja)
	MsgAlert("Parโmetros incorretos!")
	//Return
EndIf

// escolha do tipo de plano
//oDlg := MSDialog():New( 0,0,200,200,"Tipo",,,.F.,/*nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)*/,CLR_WHITE,,,,.T.,,,.T. )
/*	oCBTipo := TComboBox():New( 040,030,{ |u| If(PCount()>0,cTpPlan:=u,cTpPlan) },aTpPlan,044,010,oDlg,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTpPlan,"Tipo plano",1,oFont,CLR_BLACK)	
	
	oPanel2 := tPanel():New( 0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,020 )
	oPanel2:align := CONTROL_ALIGN_BOTTOM
	
	oBtOk	:= TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || lRet := Valida(), oDlg:End() } , oPanel2, "Confirmar" , ,)	
	oBtCanc	:= TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel2, "Cancelar" , ,)
	
	oBtCanc:Align := CONTROL_ALIGN_RIGHT
	oBtOk:Align := CONTROL_ALIGN_RIGHT
oDlg:Activate(,,,.T.) */

/*
cSql := "SELECT R_E_C_N_O_ REC FROM " +RetSqlName("SZE") +" WHERE ZE_MENSAL LIKE '"+SUBSTR(DtoS(dDatabase),1,6)+"%' AND ZE_CHAPA = '"+cPatrimo+"' "
cSql += " AND ZE_CLIENTE = '"+cCliente+"' AND ZE_LOJA = '"+cLoja+"' AND ZE_TIPOPLA = '"+cTipoPla+"'  AND D_E_L_E_T_ = '' "
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  
TcQuery cSql new Alias "TRB"
dbSelectArea("TRB")
If !EOF()
	nRecnoZE := TRB->REC
EndIf



If nRecnoZE > 0 //.And. ( Empty(cPatrimo) .Or. Empty(cCliente) .Or. Empty(cLoja) )
	dbSelectArea("SZE")
	dbGoTo(nRecnoZE)
	If Recno() == nRecnoZE
		cPatrimo := SZE->ZE_CHAPA
		cCliente := SZE->ZE_CLIENTE
		cLoja := SZE->ZE_LOJA
		cRota := SZE->ZE_ROTA
		cFreq := SZE->ZE_FREQUEN
		cTpPla := SZE->ZE_TIPOPLA
	EndIf
EndIf                               
*/
_cMes := SubStr(dtos(ddatabase),1,6)
cAuxFreq := GetMV("MV_XOPE001")
aFreq := StrToKarr(cAuxFreq,"#")
         
If FWIsInCallStack("U_TTTMKA04")
	_lOmm := .T.  
	/*If nRecnoZE > 0
		lEditable := .F.
	EndIf*/                
EndIf

oDlg := MSDialog():New( 0,0,500,480,"Plano de trabalho - " +cPatrimo +" - " +Trim(Posicione("SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_DESCRIC"), "N1_DESCRIC" )),,,.F.,/*nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)*/,CLR_WHITE,,,,.T.,,,.T. )    
    
    // painel 1
   	oPanel := tPanel():New(0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,040)
	oPanel:align := CONTROL_ALIGN_TOP
    
	oGtRota := TGet():New( 005,002,{ |u|If(Pcount()>0,cRota:=u,cRota) },oPanel,030,008,'@!',{ || },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,,,,,,"Rota",2,oFont,CLR_BLACK)
	oCBFreq := TComboBox():New( 005,055,{ |u| If(PCount()>0,cFreq:=u,cFreq) },aFreq,044,010,oPanel,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cFreq,"Frequ๊ncia",2,oFont,CLR_BLACK)
    oCBTipo := TComboBox():New( 005,075,{ |u| If(PCount()>0,cTpPlan:=u,cTpPlan) },aTpPlan,044,010,oDlg,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTpPlan,"Tipo plano",1,oFont,CLR_BLACK)	
    //oGtSeq := TGet():New( 005,140,{ |u|If(Pcount()>0,cSeq:=u,cSeq) },oPanel,020,008,'999',{ || },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,,,,,,"Sequ๊ncia",2,oFont,CLR_BLACK)
    //OGtSeq:Disable()
    
	oLayerC:Init(oDlg,.F.)
	oLayerC:addCollumn('COLUNA1',100,.F.)
  	oLayerC:addWindow("COLUNA1","WIN_1","",100,.F.,.T.,{||} )
  	oPnl := oLayerC:GetWinPanel("COLUNA1","WIN_1")
  	
	// calendario
	oCalend := Calend():New(10,10,oPnl,dDatabase,nCor,nCorMark,nCorFer,nCorDSem,nCorDMes,lEditable,cProgVld)
	oCalend:Activate()
	
	Feriados()
	If nRecnoZE > 0
		LoadCal(nRecnoZE)
	EndIf
	
	oPanel2 := tPanel():New( 0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,020 )
	oPanel2:align := CONTROL_ALIGN_BOTTOM

	oBtFreq	:= TBtnBmp2():New( 0, 0, 40, 40, 'PIN'	, , , ,{ || Fechmto() } , oPanel2, "Fechamento" , ,)
	//oBtSeq	:= TBtnBmp2():New( 0, 0, 40, 40, 'ORDEM'	, , , ,{ || } , oPanel2, "Sequ๊ncia" , ,)
	oBtClean := TBtnBmp2():New( 0, 0, 40, 40, 'S4WB004N'	, , , ,{ || Limpar() } , oPanel2, "Limpar" , ,)
	
	oBtOk	:= TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || lOk := Gravar(nRecnoZE,cPatrimo,cCliente,cLoja,cFreq,cSeq,cRota,_cFechame,_cMensal,cTpPla), If(lOk,oDlg:End(),) } , oPanel2, "Confirmar" , ,)	
	oBtCanc	:= TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel2, "Cancelar" , ,)
	
	oBtFreq:Align := CONTROL_ALIGN_LEFT
	//oBtSeq:Align := CONTROL_ALIGN_LEFT
	oBtClean:Align := CONTROL_ALIGN_LEFT
	
	oBtCanc:Align := CONTROL_ALIGN_RIGHT
	oBtOk:Align := CONTROL_ALIGN_RIGHT
oDlg:Activate(,,,.T.)

RestArea(aArea)

Return lOk
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFechmto บAutor  ณJackson E. de Deus    บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDefine o dia de fechamento                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fechmto()

Local nDias := LastDay(dDatabase) - FirstDay(dDatabase)
Local _aDias := {}
Local nI
Local cData := ""
Local cDia := ""
Local oFont := TFont():New('Arial',,-12,.T.,.T.)
Local nOpca := 0

For nI := 1 To nDias
	AADD(_aDias, padl(cvaltochar(nI),2,"0"))
Next nI

oDlg2 := MSDialog():New( 0,0,100,300,"Dia do fechamento",,,.F.,/*nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)*/,CLR_WHITE,,,,.T.,,,.T. )       
	oCBFech := TComboBox():New( 005,005,{ |u| If(PCount()>0,cDia:=u,cDia) },_aDias,044,010,oDlg2,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cDia,"Fechamento",2,oFont,CLR_BLACK)
	oSFecha := TSay():New( 020,005,{ || "Dia escolhido: " +_cFechame },oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)    
 
	oPanel2 := tPanel():New( 0,0,"",oDlg2,,,,CLR_BLACK,CLR_WHITE,0,020 )
	oPanel2:align := CONTROL_ALIGN_BOTTOM

	oBtnOk := TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || oDlg2:End(nOpca:=1) } , oPanel2, "Salvar" , ,)	
	oBtnCanc := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg2:End() } , oPanel2, "Cancelar" , ,)
	
	oBtnCanc:Align := CONTROL_ALIGN_RIGHT
	oBtnOk:Align := CONTROL_ALIGN_RIGHT
oDlg2:Activate(,,,.T.)

If nOpca == 1
	cData := substr(dtos(oCalend:dDataAtual),1,6) +cDia
	_cFechame := cDia
	oCalend:ADDMark( stod( cData ) ) 	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLimpar  บAutor  ณJackson E. de Deus    บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpa os dias do mes                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Limpar()

If MsgYesNo("Deseja desmarcar todos os dias?")      
	For dDia := FirstDay(dDatabase) To LastDay(dDatabase)
		oCalend:DelMark(dDia)
	Next nI
	_cFechame := ""                         
EndIf

Return
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar  บAutor  ณJackson E. de Deus    บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava as alteracoes na tabela SZE                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(nRecnoZE,cPatrimo,cCliente,cLoja,cFreq,cSeq,cRota,_cFechame,_cMensal,cTpPla)

Local _aDias := oCalend:aDiasMark
Local nI
Local nPos
Local cDias := ""
Local lRet := .F.
Local lGeraLog := FindFunction("U_TTGENC01")
Local lOmmRem := .F.

If Empty(cRota)
	MsgAlert("Informe a rota!")
	Return lRet
EndIf

If Empty(cFreq)
	MsgAlert("Informe a frequ๊ncia!")
	Return lRet
EndIf

aSort( _aDias,,,{ |x,y| x < y } )

If _lOmm
	dbSelectArea("SUD")
	If SUD->UD_OCORREN == "000181"
		lOmmRem := .T.
	EndIf
EndIf

For nI := FirstDay(oCalend:DDataAtual) To Lastday(oCalend:DDataAtual)
	dDiaMes := nI
	nPos := Ascan( _aDias, { |x| x == dDiaMes } )
	If nPos > 0
		If Day(dDiaMes) <> Val(_cFechame)
			cDias += "1"
		Else
			If lOmmRem  
				cDias += "X"
			Else
				cDias += "F"
			EndIf
		EndIf	
	Else
		cDias += "0"	
	EndIf
Next nI		

cFreq := PadR(cFreq,2," ")

_cMes := SubStr(dtos(oCalend:DDataAtual),1,6)
_cMensal := _cMes
_cMensal += cFreq
_cMensal += cDias    
//"Leitura","Sangria","Abastecimento"
//SANGRIA LINHA 1
//ABASTECIMENTO LINHA 2
//LEITURA LINHA 4
// tratamento tipo plano
If cTpPlan == "Leitura"
	cTpPla := "4"
ElseIf cTpPlan == "Sangria"
	cTpPla := "1"
Else
	cTpPla := "2"
EndIf

If SubStr(cRota,1,2) == "RT"
	cTpPla += "4"
ElseIf SubStr(cRota,1,2) == "R0"
	cTpPla += "2"
Else
	cTpPla += "3"
EndIf

If nRecnoZE > 0
	dbSelectArea("SZE")
	dbGoTo(nRecnoZE)
	If RecLock("SZE",.F.)
		SZE->ZE_FILIAL	:= xFilial("SZE")
		SZE->ZE_FREQUEN	:= cFreq
		SZE->ZE_SEQ		:= cSeq  
		SZE->ZE_FECHAME	:= _cFechame
		SZE->ZE_ROTA	:= cRota
		SZE->ZE_MENSAL	:= _cMensal
		SZE->ZE_TIPOPLA	:= cTpPla
		SZE->(MsUnLock())
		MsgInfo("Plano de trabalho alterado")
		lRet := .T.
		If lGeraLog
			U_TTGENC01(xFilial("SZE"),"TTOPER14","PLTRAB - ATUALIZACAO","",cvaltochar(nRecnoZE),"",cusername,dtos(date()),time(),,"PLANO DE TRABALHO ATUALIZADO - PATRIMONIO " +cPatrimo,cCliente,cLoja,"SZE")	
		EndIf 
	EndIf	
Else
	dbSelectArea("SZE")
	If RecLock("SZE",.T.)
		SZE->ZE_FILIAL	:= xFilial("SZE")
		SZE->ZE_CLIENTE	:= cCliente
		SZE->ZE_LOJA	:= cLoja
		SZE->ZE_CHAPA	:= cPatrimo
		SZE->ZE_FREQUEN	:= cFreq
		SZE->ZE_SEQ		:= cSeq  
		SZE->ZE_FECHAME	:= _cFechame
		SZE->ZE_ROTA	:= cRota
		SZE->ZE_MENSAL	:= _cMensal
		SZE->ZE_TIPOPLA	:= cTpPla
		SZE->(MsUnLock())
		MsgInfo("Plano de trabalho incluํdo")
		lRet := .T.
		If lGeraLog
			U_TTGENC01(xFilial("SZE"),"TTOPER14","PLTRAB - INCLUSAO","",cvaltochar(recno()),"",cusername,dtos(date()),time(),,"PLANO DE TRABALHO ATUALIZADO - PATRIMONIO " +cPatrimo,cCliente,cLoja,"SZE")	
		EndIf 
	EndIf	
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFeriados  บAutor  ณJackson E. de Deus  บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os feriados no calendario                          บฑฑ
ฑฑบ          ณ Considera somente ano corrente                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Feriados()

Local cSql := ""

cSql := "SELECT P3_DATA FROM " +RetSqlName("SP3") +" WHERE P3_FILIAL = '"+xFilial("SP3")+"' AND SUBSTRING(P3_DATA,1,4) = '"+cvaltochar(Year(dDatabase))+"' AND D_E_L_E_T_ = '' ORDER BY P3_DATA"
If Select("TRBP") > 0
	TRBP->( dbCloseArea() )
EndIf                     

TcQuery cSql New Alias "TRBP"
dbSelectArea("TRBP")
While !EOF()
	AADD(_aFeriado, stod(TRBP->P3_DATA) )
	dbSkip()
End
TRBP->(dbCloseArea())

If Len(_aFeriado) > 0
	aSort( _aFeriado,,,{ |x,y| x < y } )
	oCalend:Feriado(_aFeriado) 
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadCal  บAutor  ณJackson E. de Deus   บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os dias do calendario que possuem atendimentos.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadCal(nRecnoZE)
     
Local nI
Local nPosd := 0
Local cDia := ""
Local dDiaMes

dbSelectArea("SZE")
dbGoTo(nRecnoZE)
If Recno() == nRecnoZE
	_cMensal := SZE->ZE_MENSAL
	_cMensal := SubStr(_cMensal,9)
	
	For nI := FirstDay(dDatabase) To Lastday(dDatabase)
		cDia := ""                             
		nPosd++
		
		dDiaMes := nI 
		cDia := SubStr(_cMensal,nPosd,1) 	
		If cDia $ "1|F|X"
			AADD( _aDias, dDiaMes )
			If cDia $ "F|X"
				_cFechame := cvaltochar(day(dDiaMes))
			EndIf
		EndIf	
	Next nI		
	
	For nI := 1 To Len(_aDias)
		oCalend:ADDMark(_aDias[nI]) 
	Next nI
EndIf	

Return
         


// valida o clique
Static Function VALIDCLICK(cData)

Local lRet := .T.
Local dData := SToD(CValToChar(cData))
//Local oDlg
//Local oFont := TFont():New('Arial',,-12,.T.,.T.)
//Local lOk := .F.
//Local aTpPlan := {"Leitura","Sangria","Abastecimento"}

// validacoes OMM
If Select("SUD") > 0
	If SUD->UD_OCORREN == "000180"
		If dData < SUD->UD_XDTINST
			MsgAlert("A data escolhida nใo pode ser inferior a data agendada da instala็ใo!")
			lRet := .F.
			Return lRet
		EndIf                         
	EndIf               
EndIf


//oDlg := MSDialog():New( 0,0,200,200,"Tipo",,,.F.,/*nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)*/,CLR_WHITE,,,,.T.,,,.T. )
//	oGtRota := TGet():New( 015,030,{ |u|If(Pcount()>0,cRota:=u,cRota) },oDlg,030,008,'@!',{ || },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,,,,,,"Rota",1,oFont,CLR_BLACK)
//	//oCBFreq := TComboBox():New( 030,030,{ |u| If(PCount()>0,cFreq:=u,cFreq) },aFreq,044,010,oDlg,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cFreq,"Frequ๊ncia",1,oFont,CLR_BLACK)
//	oCBTipo := TComboBox():New( 040,030,{ |u| If(PCount()>0,cTpPlan:=u,cTpPlan) },aTpPlan,044,010,oDlg,,{ ||  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cTpPlan,"Tipo plano",1,oFont,CLR_BLACK)	
	
//	oPanel2 := tPanel():New( 0,0,"",oDlg,,,,CLR_BLACK,CLR_WHITE,0,020 )
//	oPanel2:align := CONTROL_ALIGN_BOTTOM
	
//	oBtOk	:= TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || lRet := MarcaDia(dData), oDlg:End() } , oPanel2, "Confirmar" , ,)	
//	oBtCanc	:= TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel2, "Cancelar" , ,)
	
//	oBtCanc:Align := CONTROL_ALIGN_RIGHT
//	oBtOk:Align := CONTROL_ALIGN_RIGHT
//oDlg:Activate(,,,.T.)


Return lRet

// Marca o dia
Static Function MarcaDia(dData)

Local dDia
Local nI
Local lExiste := .F.
Local lRet := .T.

For nI := 1 To Len(aDiasMark)
	If aDiasMark[nI][1] == dData
		If aDiasMark[nI][2] == cTpPlan
			lExiste := .T.            
			dDia := aDiasMark[nI][1]
			Exit
		EndIf
	EndIf
Next nI                   

If lExiste
	Alert("Jแ existe dia selecionado para o tipo de trabalho" +CRLF +"Dia: " +dtoc(dDia) )
	lRet := .F.
Else
	AADD( aDiasMark, { dData,cTpPlan } )
	lRet := .T.
EndIf

Return lRet


// valida o tipo escolhido
Static Function Valida()



Return