#include "protheus.ch"
#include "rwmake.ch"
#include "colors.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA04  บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza informacoes do atendimento, sem entrar na tela de  บฑฑ
ฑฑบ          ณalteracao.                                                  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ06/06/13ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ07/08/14ณ02.00 |Ajustes feitos no lanc. de contadores	  ณฑฑ
ฑฑณ								  e lanc. do caixa - lacres/moedas 		  ณฑฑ
ฑฑณJackson       ณ14/10/14ณ02.01 |Ajustes na gravacao da alteracao do 	  ณฑฑ
ฑฑณ								  patrimonio - SN1						  ณฑฑ
ฑฑณJackson       ณ29/10/14ณ02.02 |Ajuste na tela de lancamento  	      ณฑฑ
ฑฑณ								  de contadores - valicadao de POS		  ณฑฑ
ฑฑณJackson       ณ07/11/14ณ02.03 |Correcao na logica de valid. do POS     ณฑฑ
ฑฑณJackson       ณ24/11/14ณ02.04 |Alt. na chamada da funcao U_TTPROC27    ณฑฑ
ฑฑณJackson       ณ27/11/14ณ02.05 |Mudan็a na tela de doses - novos botoes ณฑฑ
ฑฑณJackson       ณ02/12/14ณ02.05 |Nova tela - conf. plano de trabalho	  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTTMKA04()        

Local lRetPerm		:= .F.
Local lVldField		:= .T.
Local aFields		:= {}
//Local bError         := { |e| oError := e , Break(e) }
//Local bErrorBlock    := ErrorBlock( bError )
Private dDataOMM	// Data de criacao da OMM
Private cAssOMM		:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK002",.T.,""),"")
Private cOcorrIns	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK003",.T.,""),"")
Private cOcorrRem	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK004",.T.,""),"")
Private cOcorrTnf 	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK012",.T.,""),"")
Private cTpLocac	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK020",.T.,""),"")
Private _nDiasInst	:= If(cEmpAnt == "01",SuperGetMV("MV_XTMK023",.T.,0),"")
Private alArea		:= GetArea()
Private lOK			:= .F.
Private cMsg		:= Space(75)
Private cNumAtend	:= ""
Private cTarefa		:= ""
Private cSeqAtu		:= ""
Private cTipoTela	:= "OBSERVACAO"
Private cDescSeq	:= ""
Private cNomeArea	:= ""
Private oFont		:= TFont():New('Arial',,-12,.T.,.T.)

Private lExistPed	:= .F.
Private lAgendInst	:= .F.
Private lAgendRem	:= .F.
Private lAtuObs		:= .F.                 
Private lAtuPatrim	:= .F.
Private lAtuContrato:= .F.
Private lAtuDoses	:= .F.
Private lAtuContad	:= .F.
Private lAtuStatus	:= .F.
Private lAtuPa		:= .F.
Private lAtuTabPrc	:= .F.
Private lConfOper	:= .F.
Private lAtuTesour	:= .F.
Private lAtuPlTrab	:= .F.
Private lSeqFim		:= .F.
Private lRegulariza := .F.

Private cpCliente	:= ""
Private cpLoja		:=  ""
Private cNomeCli	:= ""
Private aChamIns	:=	{}

If cEmpAnt <> "01"
	Return(lOK)
EndIf

dbSelectArea("SUC")
If !Empty(SUC->UC_CODCANC)
	ShowHelpDlg("TTTMKA04",{"O atendimento estแ cancelado."},5,{""},5)
	Return 	
EndIf

cNumAtend := SUC->UC_CODIGO
dDataOMM := SUC->UC_DATA

If (SUC->UC_ENTIDAD == "SA1")	// Cliente
	cpCliente := SubStr(SUC->UC_CHAVE,1,TamSx3("A1_COD")[1])
	cpLoja := SubStr(SUC->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
	cNomeCli := Posicione("SA1",1,xFilial("SA1")+cpCliente+cpLoja,"A1_NOME")
EndIf

dbSelectArea("SUD")
dbSetOrder(1)

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณVerifica permissao de acessoณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
lRetPerm := U_TTTMKA05(cNumAtend)
If ValType(lRetPerm) == "L"
	If !lRetPerm
		Return
	EndIf
EndIf            

If dbSeek(xFilial("SUD")+AvKey(cNumAtend,"UD_CODIGO"))
	If Alltrim(SUD->UD_ASSUNTO) <> cAssOMM
		Return
	EndIf
	cTarefa := SUD->UD_XTAREF
	cSeqAtu := SUD->UD_XTARSEQ

	// Atendimento encerrado?
	If AllTrim(SUD->UD_STATUS) == "2"
		lSeqFim	:= .T.
	EndIf
EndIf

If lSeqFim
	ShowHelpDlg("TTTMKA04",{"O atendimento estแ encerrado."},5,{""},5)
	Return 
EndIf	

dbSelectArea("SZ9")
dbSetOrder(2)	// filial + tarefa + sequencia               
If dbSeek(xFilial("SZ9")+AvKey(cTarefa,"Z9_COD")+AvKey(cSeqAtu,"Z9_SEQ"))
	Do Case
		// Patrimonio
		Case AllTrim(SZ9->Z9_CONTROL) $ "1|3"
			cTipoTela := "PATRIMONIO"
			lAtuPatrim := .T.
		
		// Contrato		
		Case AllTrim(SZ9->Z9_CONTROL) == "4"
			cTipoTela := "CONTRATO" 
			lAtuContrato := .T.
		
		// Doses
		Case AllTrim(SZ9->Z9_CONTROL) == "5"
			cTipoTela := "DOSES"
			lAtuDoses := .T.
		
		// Agendar Instalacao 		
		Case Alltrim(SZ9->Z9_CONTROL) == "6"
			lAgendInst := .T.      
		
		// Informar contadores
		Case AllTrim(SZ9->Z9_CONTROL) == "7"
			cTipoTela := "CONTADORES" 
			lAtuContad := .T.
		
		// Encerramento de Tarefa
		Case AllTrim(SZ9->Z9_CONTROL) == "8"
			lAtuStatus := .T.
		
		// Informar PA		
		Case AllTrim(SZ9->Z9_CONTROL) == "9"
			cTipoTela := "PA"
			lAtuPA := .T.
		
		// Informar Tabela de Preco		
		Case AllTrim(SZ9->Z9_CONTROL) == "10"
			cTipoTela := "TABPRECO"
			lAtuTabPrc := .T.
		
		// Agendar Remocao 		
		Case AllTrim(SZ9->Z9_CONTROL) == "11"
			lAgendRem := .T.           
			
		// Confirmar Instalacao/Remocao
		Case AllTrim(SZ9->Z9_CONTROL) == "12"
			cTipoTela := "CONFIRMA_OPERACAO"
			lConfOper := .T.
		
		// Tesouraria - Troco/materiais enviados
		Case AllTrim(SZ9->Z9_CONTROL) == "13"
			cTipoTela := "TESOURARIA"
			lAtuTesour := .T.
		// Plano de trabalho
		Case AllTrim(SZ9->Z9_CONTROL) == "14" 
			cTipoTela := "PLTRAB"
			lAtuPlTrab := .T.
		Case Alltrim(SZ9->Z9_CONTROL) == "15"
			cTipoTela := "TECNICO"      
		//Gerar nota de remocao
		Case Alltrim(SZ9->Z9_CONTROL) == "16"
			cTipoTela := "NF_REM"      
		//Mapa de produtos (Abastecimento)
		Case Alltrim(SZ9->Z9_CONTROL) == "20"
			cTipoTela := "MAPA"
			
	EndCase
	
	cDescSeq := AllTrim(SZ9->Z9_TAREFA)
	cNomeArea := AllTrim(SZ9->Z9_AREA)
	If "REGULARIZA" $ UPPER(SZ9->Z9_DESC)
		lRegulariza := .T.
	EndIf
EndIf      

//Monta tela de acordo com a sequencia de tarefa
If cTipoTela == "OBSERVACAO"
	lAtuObs := .T.
	TelaObs()
ElseIf cTipoTela == "PATRIMONIO"
	TelaPatrim()
ElseIf cTipoTela == "CONTRATO"
	TelaContr()
ElseIf cTipoTela == "DOSES"
	TelaDose()
ElseIf cTipoTela == "CONTADORES"
	TelaCont()
ElseIf cTipoTela == "PA"
	TelaPA()
ElseIf cTipoTela == "TABPRECO"
	TelaTabPrc()
ElseIf cTipoTela == "CONFIRMA_OPERACAO"
	TelaConf()
ElseIf cTipoTela == "TESOURARIA"
	TelaTes()
ElseIf cTipoTela == "PLTRAB"
	TelaPlTrab() 
ElseIf cTipoTela == "TECNICO"
	If U_TTGENC07()    
		MsAguarde({ || AtuCampos(cTarefa,cSeqAtu,,{})},"Aguarde, atualizando atendimento...")
	EndIF 
ElseIf cTipoTela == "NF_REM"
	If U_TTTMKA50(SUC->UC_CHAVE,SUC->UC_CODIGO)
		MsAguarde({ || AtuCampos(cTarefa,cSeqAtu,,{})},"Aguarde, atualizando atendimento...")
	EndIf                
ElseIf cTipoTela == "MAPA"  
	DbSelectArea("SUD")
	While !EOF() .AND. SUD->UD_FILIAL==SUC->UC_FILIAL .AND. SUD->UD_CODIGO=SUC->UC_CODIGO
	 	IF !U_TTCOMC17(SUD->UD_PRODUTO,SUD->UD_XNPATRI,.T.,.F.,.T.)
	 		lNaoMov := .F.
	 		exit
	 	EndIf
		Dbskip()                                                
	EndDo                
	
	If lNaoMov 
		MsAguarde({ || AtuCampos(cTarefa,cSeqAtu,,{})},"Aguarde, atualizando atendimento...")
	EndIf
EndIf

Return lOK

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaObs   บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento da observacao de encerramento da    บฑฑ
ฑฑบ          ณsequencia.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaObs()
Local oDlg1
Local oGrp1
Local lOK		:= .T.
Private cMsg	:= Space(75)			// observacao
Private cDtAgend := Ctod(Space(8))		// Dt Instalacao
Private oSay1
Private oFont
Private oGrp1
Private oMGet1
Private oSBtn1
	
oDlg1	:= MSDialog():New( 230,300,448,640,"Atualiza็ใo de Status",,,.F.,,,,,,.T.,,,.T. )
	oFont	:= TFont():New('Arial',,-12,.T.,.T.)
	oSay	:= TSay():New( 004,004,{||"Tarefa: " +cDescSeq},oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1	:= TSay():New( 014,004,{||"มrea: " +cNomeArea},oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2	:= TSay():New( 024,004,{||"Informe a observa็ใo para encerramento da etapa:"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oGrp1	:= TGroup():New( 036,004,088,168,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
     
	If !lAgendInst .And. !lAgendRem
		@ 038,006 GET oMGet1 VAR cMsg OF oDlg1 MULTILINE SIZE 160,048 COLORS 0, 16777215 HSCROLL PIXEL
	Else
		@ 038,006 GET oMGet1 VAR cMsg OF oDlg1 MULTILINE SIZE 160,020 COLORS 0, 16777215 HSCROLL PIXEL
		// Se for agendamento de instalacao
		If lAgendInst
			oSay3	:= TSay():New( 060,035,{|| "Agendamento da instala็ใo:"},oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
		// Se for agendamento de remocao
		ElseIf lAgendRem
			oSay3	:= TSay():New( 060,035,{|| "Agendamento da remo็ใo:"},oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
		EndIf
		@ 070,035 MSGET cDtAgend PICTURE "@99/99/99" OF oDlg1 SIZE 045,008 PIXEL HASBUTTON
	EndIf    
	
	oSBtn1	:= SButton():New( 092,076,1,{|| lOk := ChkObs(), IIF(lOk, {UpdAtend(cTipoTela,cMsg), oDlg1:End()}, /*nao faz nada*/)  },oDlg1,.T.,"", )
oDlg1:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkObs    บAutor  ณJackson E. de Deus  บ Data ณ  30/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkObs()

Local lRet := .T.

// verifica observacao           
If AllTrim(cMsg) == "" .And. !lAtuTabPrc
	lRet := .F.            
	ShowHelpDlg("TTTMKA04",{"Observa็ใo nใo informada."},5,{"Digite o texto da observa็ใo."},5)
	Return lRet
EndIf  

// verifica data de agendamento
/*
If lAgendInst .Or. lAgendRem
	If Empty(cDtAgend)
		lRet := .F.
		ShowHelpDlg("TTTMKA04",{"Data nใo informada."},5,{"Digite a data do agendamento."},5)
		Return lRet
	EndIf
	If lAgendInst
		If cDtAgend < dDatabase +_nDiasInst
			lRet := .F.
			ShowHelpDlg("TTTMKA04",{"Data invแlida."},5,{"O prazo da instala็ใo nใo deve ser inferior a " +cvaltochar(_nDiasInst)  +" dias." +CRLF +"Data mํnima: " +dtoc(dDatabase +_nDiasInst) },5)
			Return lRet
		EndIf
	EndIf
EndIf    
*/
Return lRet
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaPatrim  บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento do patrimonio das maquinas ao fim   บฑฑ
ฑฑบ          ณda sequencia.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaPatrim()

Local nOpc		:= 2	//GD_INSERT+GD_DELETE+GD_UPDATE
Local aAlter	:= {"UD_XNPATRI"}
Local aDados	:= {}
Local cCodCli	:= SubStr(SUC->UC_CHAVE,1,TamSx3("A1_COD")[1]) 
Local cLjCli	:= SubStr(SUC->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1]) 
Local aObj
Private aCols	:= {}
Private aHeader	:= {}
Private aInfo	:= {}
Private oDlg1
Private oSay1
Private oGrp1
Private oMsGD
Private oSBtn1
Private oSBtn2
Private nPosItem
Private nPosProd
Private nPosChapa
Private cNomCli := ""

LoadHead()
If Len(aHeader) == 0
	ShowHelpDlg("TTTMKA04",{"Array aHeader vazio."},5,{"Houve problema na gera็ใo do aHeader."},5)
	Return
EndIf

LoadCols(cNumAtend,@aDados)
If Len(aCols) == 0
	ShowHelpDlg("TTTMKA04",{"Array aCols vazio."},5,{"Houve problema na gera็ใo do aCols."},5)
	Return
EndIf	                       
cNomCli := Posicione("SA1",1,xFilial("SA1")+cCodCli +cLjCli,"A1_NOME")

nPosItem	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ITEM"})	
nPosProd	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"})		
nPosChapa	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XNPATRI"})

oDlg1 := MSDialog():New( 178,247,503,885,"Patrim๔nio",,,.F.,,,,,,.T.,,,.T. )
	oSay  := TSay():New( 002,002,{||"Tarefa: " +cDescSeq},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1 := TSay():New( 012,002,{||"มrea: " +cNomeArea},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2 := TSay():New( 022,002,{||"Escolha o patrim๔nio dos produtos"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	oGrp1 := TGroup():New(032,002,144,319,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F.)
	
	oMsGD := MsNewGetDados():New(034,004,142,318,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp1,aHeader,aCols)
	oMsGD:Refresh(.T.)
	oMsGD:ForceRefresh(.T.)
	
	oSBtn1 := SButton():New( 148,258,1,{|| AddaInfo(@aInfo,nPosItem,nPosProd,nPosChapa),IIF(Len(aInfo)>0,UpdAtend(cTipoTela,cMsg,aInfo),),oDlg1:End()},oDlg1,.T.,"", )
	oSBtn1 := SButton():New( 148,293,2,{|| oDlg1:End()},oDlg1,.T.,"", )	
	
oDlg1:Activate(,,,.T.)

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldPatr  บAutor  ณJackson E. de Deus   บ Data ณ  28/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o patrimionio digitado                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldPatr()

Local nLinhaAtu := oMsGD:nAt
Local nI   

For nI := 1 To Len(oMsGD:aCols)
	If nI == nLinhaAtu
		Loop
	EndIf   
	If oMsGD:aCols[nI][4] == M->UD_XNPATRI
		Aviso("TTTMKA04-VldPatr","O patrim๔nio escolhido jแ estแ selecionado em outra linha.",{"Ok"})
		Return .F.
	EndIf
Next nI

Return .T.
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaContr   บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento do contrato das maquinas ao fim da  บฑฑ
ฑฑบ          ณsequencia.	                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaContr()

Local nOpc			:= 2	//GD_INSERT+GD_DELETE+GD_UPDATE
Local aDados		:= {}
Private aAlter		:= {"UD_XCONTRA","UD_XPLAN"}
Private aCols		:= {}
Private aHeader		:= {}
Private aInfo		:= {}
Private oDlg1
Private oSay1
Private oGrp1
Private oMsGD
Private oSBtn1
Private oSBtn2
Private nPosCont
Private nPosItem
Private nPosProd
Private nPosPlan

LoadHead()
If Len(aHeader) == 0
	ShowHelpDlg("TTTMKA04",{"Array aHeader vazio."},5,{"Houve problema na gera็ใo do aHeader."},5)
	Return
EndIf

LoadCols(cNumAtend,@aDados)
If Len(aCols) == 0
	ShowHelpDlg("TTTMKA04",{"Array aCols vazio."},5,{"Houve problema na gera็ใo do aCols."},5)
	Return
EndIf	

nPosItem	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ITEM"})	
nPosProd	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"})	
nPosCont	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XCONTRA"})
nPosPlan	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XPLAN"})

oDlg1 := MSDialog():New( 178,247,503,885,"Contrato",,,.F.,,,,,,.T.,,,.T. )
	oSay  := TSay():New( 002,002,{||"Tarefa: " +cDescSeq},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1 := TSay():New( 012,002,{||"มrea: " +cNomeArea},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2 := TSay():New( 022,002,{||"Escolha o contrato dos produtos"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	oGrp1 := TGroup():New( 032,002,144,319,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oMsGD := MsNewGetDados():New(034,004,142,318,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'STATICCALL(TTTMKA04,VldContr)','','AllwaysTrue()',oGrp1,aHeader,aCols,{|| oMsGD:aCols := aCols} )
	oMsGD:OnChange()
	oMsGD:Refresh(.T.)
	oMsGD:ForceRefresh(.T.)
	
	oSBtn1 := SButton():New( 148,258,1,{|| ContrSel(@aInfo,nPosItem,nPosProd,nPosCont,nPosPlan),IIF(Len(aInfo)>0,UpdAtend(cTipoTela,cMsg,aInfo),),oDlg1:End()},oDlg1,.T.,"", )
	oSBtn2 := SButton():New( 148,293,2,{|| oDlg1:End()},oDlg1,.T.,"", )	
oDlg1:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldContr  บAutor  ณMicrosiga           บ Data ณ  07/25/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldContr()

Local lRet := .T.
Local aDados := {}
Local aArea := {}

// validacao da planilha
If __readVar == "M->UD_XPLAN"
	If Empty( M->UD_XPLAN )
		MsgAlert("Informe a planilha do contrato!")
		Return .F.
	EndIf
	
	If Len( Alltrim(M->UD_XPLAN) ) < 6
		MsgAlert("Informe o n๚mero correto da planilha! Ex: 000001")
		Return .F.
	EndIf
	aArea := GetArea()
	STATICCALL( TTTMKA16,fRetCNA,cpCliente,cpLoja,@aDados )
	RestArEa(aArea)
	If Empty( aDados )
		MsgAlert("O contrato informado nใo possui planilha cadastrada. Providencie o cadastro da planilha.")
		lRet := .F.
	EndIf
	If Len( aDados ) == 1
		If Empty( aDados[1] )
			MsgAlert("O contrato informado nใo possui planilha cadastrada. Providencie o cadastro da planilha.")
			lRet := .F.
		EndIf
	EndIf
EndIf


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaPA      บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento da PA das maquinas.				  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaPA()

Local nOpc			:= 2	//GD_INSERT+GD_DELETE+GD_UPDATE
Local aAlter		:= {"B1_LOCPAD"}
Local aDados		:= {}
Private aCols		:= {}
Private aHeader		:= {}
Private aInfo		:= {}
Private oDlg1
Private oSay1
Private oGrp1
Private oMsGD
Private oSBtn1
Private oSBtn2
Private nPosPA
Private nPosItem
Private nPosProd

LoadHead()
If Len(aHeader) == 0
	ShowHelpDlg("TTTMKA04",{"Array aHeader vazio."},5,{"Houve problema na gera็ใo do aHeader."},5)
	Return
EndIf

LoadCols(cNumAtend,@aDados)
If Len(aCols) == 0
	ShowHelpDlg("TTTMKA04",{"Array aCols vazio."},5,{"Houve problema na gera็ใo do aCols."},5)
	Return
EndIf	

nPosItem	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ITEM"})	
nPosProd	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"})		
//nPosCont	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XCONTRA"})	
nPosPA		:= Ascan(aHeader,{|x|AllTrim(x[2])=="B1_LOCPAD"})	


oDlg1 := MSDialog():New( 178,247,503,885,"PA",,,.F.,,,,,,.T.,,,.T. )
	oSay  := TSay():New( 002,002,{|| "Tarefa: " +cDescSeq},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1 := TSay():New( 012,002,{|| "มrea: " +cNomeArea},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2 := TSay():New( 022,002,{|| "Escolha a PA dos produtos"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,096,008)
	oGrp1 := TGroup():New( 032,002,144,319,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oMsGD := MsNewGetDados():New(034,004,142,318,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp1,aHeader,aCols,{|| oMsGD:aCols := aCols} )
	oMsGD:OnChange()
	oMsGD:Refresh(.T.)
	oMsGD:ForceRefresh(.T.)
	
	oSBtn1 := SButton():New( 148,258,1,{|| AddaInfo(@aInfo,nPosItem,nPosProd,nPosPA),IIF(Len(aInfo)>0,UpdAtend(cTipoTela,cMsg,aInfo),),oDlg1:End()},oDlg1,.T.,"", )
	oSBtn2 := SButton():New( 148,293,2,{|| oDlg1:End()},oDlg1,.T.,"", )	
oDlg1:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaTabPrcบAutor  ณJackson E. de Deus  บ Data ณ  06/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento da tabela de preco das maquinas.	  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaTabPrc()

Local nOpc			:= 2	//GD_INSERT+GD_DELETE+GD_UPDATE
Local aAlter		:= {"UA_TABELA"}
Local aDados		:= {}
Private aCols		:= {}
Private aHeader		:= {}
Private aInfo		:= {}
Private oDlg1
Private oSay1
Private oGrp1
Private oMsGD
Private oSBtn1
Private oSBtn2
Private nPosTabs
Private nPosItem
Private nPosProd

LoadHead()
If Len(aHeader) == 0
	ShowHelpDlg("TTTMKA04",{"Array aHeader vazio."},5,{"Houve problema na gera็ใo do aHeader."},5)
	Return
EndIf

LoadCols(cNumAtend,@aDados)
If Len(aCols) == 0
	ShowHelpDlg("TTTMKA04",{"Array aCols vazio."},5,{"Houve problema na gera็ใo do aCols."},5)
	Return
EndIf	

nPosItem	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ITEM"})	
nPosProd	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"})		
nPosTabs	:= Ascan(aHeader,{|x|AllTrim(x[2])=="UA_TABELA"})	

oDlg1 := MSDialog():New( 178,247,503,885,"Tabela de Pre็o",,,.F.,,,,,,.T.,,,.T. )
	oSay  := TSay():New( 002,002,{|| "Tarefa: " +cDescSeq},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1 := TSay():New( 012,002,{|| "มrea: " +cNomeArea},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2 := TSay():New( 022,002,{|| "Escolha a tabela de pre็o dos produtos:"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oGrp1 := TGroup():New( 032,002,144,319,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oMsGD := MsNewGetDados():New(034,004,142,318,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp1,aHeader,aCols,{|| oMsGD:aCols := aCols} )
	oMsGD:OnChange()
	oMsGD:Refresh(.T.)
	oMsGD:ForceRefresh(.T.)

	oSBtn1 := SButton():New( 148,258,1,{|| AddaInfo(@aInfo,nPosItem,nPosProd,nPosTabs), IIF(Len(aInfo)>0, IIF(ChkTabPrc(),UpdAtend(cTipoTela,cMsg,aInfo) , ), ),oDlg1:End()},oDlg1,.T.,"", )
	oSBtn2 := SButton():New( 148,293,2,{|| oDlg1:End()},oDlg1,.T.,"", )	
oDlg1:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkPatrim  บAutor  ณJackson E. de Deus บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica patrimonio duplicado                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkPatrim()
           
Local lRet := .T.
Local cPatrimonio := oMsGD:aCols[oMsGD:nAt][nPosChapa]
Local nCont := 0

For nI := 1 To Len(oMsGD:Acols)                                  	
	If AllTrim(oMsGD:acols[nI][nPoschapa]) == AllTrim(cPatrimonio)
		nCont++
	EndIf
Next nI 
If nCont > 1
	Aviso("TTTMKA04","Nใo ้ permitido o uso do mesmo patrim๔nio em mais de um item.",{"Ok"})
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkTabPrc บAutor  ณJackson E. de Deus  บ Data ณ  07/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkTabPrc()

Local lRet := .T.
Local cTpCont := ""
Local cValidCont := SuperGetMV("MV_XTMK018",.T.,"")	// tipos de contrato que exigem validacao da tabela de preco
Local lAtvBlq := SuperGetMV("MV_XTMK019",.T.,.F.)	// ativa/desativa o bloqueio na verificacao da tabela de preco

If !lAtvBlq
	Return .T.
EndIf

//SE FOR LA OU SA, OBRIGA A AMARRACAO DO CLIENTE NA TABELA DE PRECO
/*
Tipos de contratos
Loca็ใo			//[1]
Serv.Caf้		//[2]
LA				//[3]
S.A				//[4]
Kit Lanche		//[5]
Caf้ + Loca็ใo	//[6]
LA + Loca็ใo	//[7]
SA + Loca็ใo	//[8]
*/	
For nI := 1 To Len(aInfo)
	dbSelectArea("SUD")
	cTpCont := GetAdvFval("SUD","UD_XTPCONT",xFilial("SUD")+SUC->UC_CODIGO+AvKey(aInfo[nI][1],"UD_ITEM"),1)
	dbSelectArea("DA0")
	dbSetOrder(1)
	If dbSeek(xFilial("DA0")+AvKey(aInfo[nI][3],"DA0_CODTAB"))                                         
		If cTpCont $ cValidCont
			If AllTrim(DA0->DA0_XCLIEN) <> cpCliente // Verifica se a tabela esta com o cliente amarrado	
				Aviso("TTMKA04","A tabela de pre็o informada deve estar vinculada ao cliente.",{"Ok"})
				Return .F.
			EndIf
		EndIf
		
		If AllTrim(DA0->DA0_ATIVO) == "2" // Verifica se a tabela esta ativa
			Aviso("TTMKA04","A tabela de pre็o informada no item " +aInfo[nI][1] +" estแ inativa." +CRLF +"Escolha uma tabela ativa." +CRLF +"Data Inicial: "+DtoC(DA0->DA0_DATDE) +CRLF +"Data Final: "+dTOC(DA0->DA0_DATATE),{"Ok"})
			Return .F.
		EndIf					
	Else
		Aviso("TTTMKA04","A tabela " +aInfo[nI][3] +" informada no item " +aInfo[nI][1] +" nใo existe!"+CRLF +"Informe uma tabela vแlida.",{"Ok"})
	EndIf		 
Next nI

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADDaInfo	  บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara o array ADDaInfo para posterior atualizaco de		  บฑฑ
ฑฑบ          ณcampos.				                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADDaInfo(aInfo,nPosItem,nPosProd,nPosCampo)

Local lOk := .F.

If lAtuPatrim
	lOk := ChkPatrim()
	If !lOk
		Return
	EndIf
EndIf

For nI := 1 To Len(oMsGD:Acols)// Adiciona no Array aInfo os itens do Grid                                  	
	AADD(aInfo,{oMsGD:Acols[nI,nPosItem],oMsGD:Acols[nI,nPosProd],oMsGD:Acols[nI,nPosCampo]})
Next nI                                                          
                                            
For nI := 1 To Len(aInfo)
	If AllTrim(aInfo[nI][3]) == ""
		Aviso("TTTMKA04","Preencha todos os campos.",{"Ok"})
		aInfo := {}
		Return
	EndIf
Next nI

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณContrSel	  บAutor  ณJackson E. de Deus  บ Data ณ  27/08/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara o array ADDaInfo para posterior atualizao de campos บฑฑ
ฑฑบ          ณUtilizado na tela de contrato                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   
Static Function ContrSel(aInfo,nPosItem,nPosProd,nPosCampo,nPosPlan)

// Adiciona no Array aInfo os itens do Grid
For nI := 1 To Len(oMsGD:Acols)
	If AllTrim(oMsGD:Acols[nI][nPosCampo]) == ""
		Aviso("TTTMKA04","Preencha todos os campos.",{"Ok"})
		aInfo := {}
		Return
	EndIf
	If AllTrim(CN9->CN9_TPCTO) == cTpLocac .And. AllTrim(CN9->CN9_XTPCNT) $ "3" // Se for contrato de locacao e tipo agrupado/selecionado obriga informar a planilha
		If Empty(oMsGD:Acols[nI][nPosPlan])                              
			Aviso("TTTMKA04","Para contrato do tipo selecionado, ้ obrigat๓rio informar a planilha.",{"Ok"})
			aInfo := {}
			Return			
		EndIf
	EndIf
	AADD(aInfo,{oMsGD:Acols[nI,nPosItem],oMsGD:Acols[nI,nPosProd],oMsGD:Acols[nI,nPosCampo],oMsGD:Acols[nI,nPosPlan]})
Next nI                                                          

Return      

    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaDose	  บAutor  ณJackson E. de Deus  บ Data ณ  25/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento dos valores das doses.			  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaDose()

Local aRetParam		:= {}
Local cTitulo		:= "Doses"
Local cBt1Hint		:= "Salvar todas as altera็๕es"
Local cBt2Hint		:= "Sair sem salvar"
Local cBt3Hint		:= "Replicar para outros itens"
Local cLimTroco		:= 0
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
//Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Private TamSB1		:= Space(TamSx3("B1_COD")[1])
Private oTcBrowse	     
Private oDlg1 
Private aBrowse
Private aCols		:= {}	
Private lMudaTela	:= .F.
Private aDados		:= {}
Private aGetsDose	:= {}

// Preenche aCols
LoadCols(cNumAtend,@aDados)
If Len(aDados) > 0
	aBrowse := aCLone(aDados)
EndIf

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณPrepara o Array aGetsDose que deve ser usado na tela de preenchimento das dosesณ
ณEssa tela de preenchimento depende desse Array                                 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
For nI := 1 To Len(aBrowse)
	AADD(aGetsDose, {aBrowse[nI][2],aBrowse[nI][3],	cLimTroco})
	For nX := 1 To 25	// Cria 25 posicoes no array para guardar os valores dos gets da tela					
		AADD(aGetsDose[nI], {TamSB1, 0,0})	//[4][x] Campo Dose, Campo Valor, Campo Valor	
	Next nX
Next nI

oDlg1 := MSDialog():New(110,234,465,790,cTitulo,,,.F.,,,,,,.T.,,,.T. ) 
	oSay  := TSay():New(002,002,{|| "Tarefa: " +cDescSeq},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1 := TSay():New(012,002,{|| "มrea: " +cNomeArea},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2 := TSay():New(022,002,{|| "Preencha os valores das doses dos produtos:"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	
	oGroup := TGroup():New(035,002,148,279,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F.)
	
	oTcBrowse := TCBrowse():New(037,005,271,110,,,{5,10,15,30,10},oGroup,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.,)
	oTcBrowse:SetArray(aBrowse)
	
	oTcBrowse:AddColumn(TCColumn():New(' '			,{ || If(aBrowse[oTcBrowse:nAt,01],oOk,oNo)},"@BMP",,,,,.T.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Item'		,{ || aBrowse[oTcBrowse:nAt,02]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Produto'	,{ || aBrowse[oTcBrowse:nAt,03]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oTcBrowse:AddColumn(TCColumn():New('Descri็ใo'	,{ || aBrowse[oTcBrowse:nAt,04]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	
	oTcBrowse:SetArray(aBrowse)
	oTcBrowse:bWhen        := { || Len(aBrowse) > 0 }     
	oTcBrowse:bLDblClick := { || DblClk()}  
	
	oSBtn3		:= TBtnBmp2():New( 295, 435, 40, 40, 'SDUREPL'	, , , ,{|| IIF(oTcBrowse:nLen > 1,ReplIt(),/*tem apenas uma linha entao nao precisa replicar nada */) } , oDlg1, cBt3Hint , ,)
	oSBtn1		:= TBtnBmp2():New( 295, 475, 40, 40, 'OK'		, , , ,{|| UpdAtend(cTipoTela,,aGetsDose),oDlg1:End()} , oDlg1, cBt1Hint , ,)
	oSBtn2		:= TBtnBmp2():New( 296, 515, 40, 40, 'CANCEL'	, , , ,{|| oDlg1:End()} , oDlg1, cBt2Hint , ,)
	
	oDlg1:Refresh()
oDlg1:Activate(,,,.T.)                                                                                                                                                                   

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDblClk	  บAutor  ณJackson E. de Deus  บ Data ณ  25/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento dos valores das doses.			  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DblClk()

Local cTitulo		:= "Preencha as doses"                                          
Local cBt1Hint		:= "Clique para salvar as informa็๕es da tela"
Local cBt2Hint		:= "Clique para sair da tela"
Local cValorPE		:= "PE"
Local cValorPP		:= "PP"
Local cPictValor	:= PesqPict("DA1","DA1_PRCVEN")
Local cPictTroco	:= PesqPict("SN1","N1_XLIMTRO")
Local oDlg1
Local oSBtn1
Local oSBtn2
Local cConsulta		:= "DA1OMM"
Local nI
Local nJ
Local cQuery		:= ""
Local cCodTab		:= ""
Local nOpc			:= 3 
Local aCampos		:= {}
Local aAlter		:= {"B1_COD"}
Private aCols := {}
Private aHeader := {}
Private nLimTroco	:= 0	// limite de troco
Private aValores	:= {}	// valores das doses de acordo com a tabela de preco
         

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณVerifica o array aGetsDose para saber quais dados deve trazer na telaณ
ณItem/Produto                                                         ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
For nI := 1 To Len(aGetsDose)
	If aGetsDose[nI][1] == oTcBrowse:aArray[oTcBrowse:nAt][2] .And. aGetsDose[nI][2] == oTcBrowse:aArray[oTcBrowse:nAt][3]
		nPosArray := nI
		
		cDoses := Posicione("SUD",1,xFilial("SUD")+SUC->UC_CODIGO+AvKey(oTcBrowse:Aarray[oTcBrowse:nAt][2],"UD_ITEM"),"UD_XDOSES" )
		If !Empty(cDoses)
			aAxDose := StrToKarr(cDoses,"|")                                                                    
			For nI := 1 To Len(aAxDose)
				nPos := nI+2
				If nI == 1	// limite troco    
					nLimTroco := Val(aAxDose[nI])
					aGetsDose[nPosArray][3] := nLimTroco
					Loop
				EndIf
				aAux := StrToKarr(aAxDose[nI],";")
				aGetsDose[nPosArray][nPos][1] := aAux[1]
				aGetsDose[nPosArray][nPos][2] := Val(aAux[2])
				aGetsDose[nPosArray][nPos][3] := Val(aAux[3])
			Next nI
		EndIf
		
		Exit
	EndIf
Next nI

//Buscar a tabela de preco informada
dbSelectArea("SUD")
cCodTab := Posicione("SUD",1,xFilial("SUD")+SUC->UC_CODIGO+AvKey(oTcBrowse:Aarray[oTcBrowse:nAt][2],"UD_ITEM"),"UD_XTABPRC" )
If !Empty(cCodTab)
	//Carrega os produtos da tabela de preco
	cQuery := "SELECT DA1_CODPRO, DA1_PRCVEN PE, DA1_XPRCPP PP"
	cQuery += " FROM " +RetSqlName("DA1")
	cQuery += " WHERE DA1_CODTAB = '"+cCodTab+"' AND DA1_ATIVO = '1' AND D_E_L_E_T_ = '' "
	
	If Select("TRBPRC") > 0
		TRBPRC->(dbCloseArea())
	EndIf
	TcQuery cQuery New Alias "TRBPRC"
	dbSelectArea("TRBPRC")
	While !EOF()
		AADD(aValores, {TRBPRC->DA1_CODPRO,TRBPRC->PE,TRBPRC->PP})
		dbSkip()
	End
	TRBPRC->(dbCloseArea())
EndIf

dbSelectArea("SX3")
dbSetOrder(2)

AADD(aHeader,{"Botao","T_BOTAO","",3,0,"","","C","","R" } )

dbSeek( "B1_COD" )		 
AADD(aHeader,{"Dose",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"StaticCall(TTTMKA04,Preenche)","",SX3->X3_TIPO,cConsulta,SX3->X3_Context  } )

dbSeek("B1_DESC")
AADD(aHeader,{"Descri็ใo",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context  } )

dbSeek( "DA1_PRCVEN" )		 
AADD(aHeader,{"PE",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context  } )
                             
dbSeek( "DA1_XPRCPP" )		 
AADD(aHeader,{"PP",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context  } )

For nI := 1 To 25
	nPos := nI+3
	AAdd(aCols, Array(Len(aHeader)+1))
	nLin := Len(aCols)
	For nCol := 1 To Len(aHeader)
		If nCol == 1
			aCols[nLin][nCol] := "P" +cvaltochar(nI)
		ElseIf nCol == 2
			aCols[nLin][nCol] := aGetsDose[nPosArray][nPos][1] //CriaVar(aHeader[nCol][2], .T.)	
		ElseIf nCol == 3
			aCols[nLin][nCol] := Posicione("SB1",1,xFilial("SB1")+AvKey(aGetsDose[nPosArray][nPos][1],"B1_COD"),"B1_DESC")
		ElseIf nCol == 4
			aCols[nLin][nCol] := aGetsDose[nPosArray][nPos][2]
		ElseIf nCol == 5
			aCols[nLin][nCol] := aGetsDose[nPosArray][nPos][3]
		EndIf
	Next nCol                 
	aCols[nLin][Len(aHeader)+1] := .F.	
Next nI
		
// Monta a janela
oDlg1   := MSDialog():New( 098,252,515,900,cTitulo,,,.F.,,,,,,.T.,,,.T. )
	// painel 1
	oPanel1 := TPanelCss():New(0,0,"",oDlg1,,.F.,.F.,,,0,030,.T.,.F.)
	cStyle := "Q3Frame{ border-style:solid; border-width:1px; border-color:#263238; background-color:#607d8b }"
	oPanel1:setCSS( cStyle ) 
	oPanel1:align := CONTROL_ALIGN_TOP
	
	oSayProd	:= TSay():New( 005,002,{||"Mแquina: "+AllTrim(aBrowse[oTcBrowse:nAt][3]) +" - " +AllTrim(aBrowse[oTcBrowse:nAt][4])},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay7 := TSay():New( 015,002,{||"Limite de Troco"},oPanel1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,008)
	@ 015,055 MSGET nLimTroco 	PICTURE cPictTroco		OF oPanel1 SIZE 060,008 PIXEL HASBUTTON
	
	oMsGD := MsNewGetDados():New(0,0,0,0,GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,25,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHeader,aCols,{|| oMsGD:aCols := aCols} )
	oMsGD:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	// painel 3
	oPanel3 := TPanelCss():New(0,0,"",oDlg1,,.F.,.F.,,,0,20,.T.,.F.)
	cStyle := "Q3Frame{ border-style:solid; border-width:1px; border-color:#263238; background-color:#607d8b }"
	oPanel3:setCSS( cStyle ) 
	oPanel3:align := CONTROL_ALIGN_BOTTOM

	// botoes salvar/cancelar
	oSBtn1 := TBtnBmp2():New( 373, 440, 40, 40, 'SALVAR'	, , , ,{|| SalvaInf(),oDlg1:End()} , oPanel3, cBt1Hint , ,)
	oSBtn2 := TBtnBmp2():New( 373, 487, 40, 40, 'CANCEL'	, , , ,{|| oDlg1:End()} , oPanel3, cBt2Hint , ,)
	
	oSBtn2:Align := CONTROL_ALIGN_RIGHT
	oSBtn1:Align := CONTROL_ALIGN_RIGHT
oDlg1:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPreenche  บAutor  ณJackson E. de Deus  บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o valor digitado e preenche os valores PE e PP.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Preenche()

Local nI
Local nJ
Local lOk := .T.
                                     	     
If !Empty(M->B1_COD)
	//Verifica se o valor corresponde a um produto valido
	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB1")+AvKey(M->B1_COD,"B1_COD"))
		Aviso("TTTMKA04","Preencha um produto vแlido.",{"Ok"})
		lOk := .F.
		Return lOk
	EndIf       
	
	lOk := .F.
	For nJ := 1 To Len(aValores)// Valida se o produto digitado esta na tabela de preco escolhida
		If AllTrim(aValores[nJ][1]) == Trim(M->B1_COD)
			lOk := .T.
			Exit
		EndIf
	Next nJ        		
	If !lOk
		Aviso("TTTMKA04","Preencha um produto vแlido da tabela." +CRLF +"Voc๊ pode consultar os produtos da tabela utilizando o botใo F3.",{"Ok"})
		Return lOk
	EndIf
	For nJ := 1 To Len(aValores)	//Preenche o valor PE e PP
		If AllTrim(aValores[nJ][1]) == AllTrim(M->B1_COD)
			aCols[oMsGD:nAt][3] := Posicione("SB1",1,xFilial("SB1")+AvKey(M->B1_COD,"B1_COD"),"B1_DESC")
			aCols[oMsGD:nAt][4] := aValores[nJ][2]
			aCols[oMsGD:nAt][5] := aValores[nJ][3]
			Exit				
		EndIf
	Next nJ
EndIf	

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSalvaInf	บAutor  ณJackson E. de Deus  บ Data ณ  25/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para preenchimento dos valores das doses.			  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SalvaInf()

Local nPos       
Local nI

aGetsDose[nPosArray][3] := nLimTroco

For nI := 1 To Len(oMsGD:Acols)
	nPos:=nI+3
	aGetsDose[nPosArray][nPos][1] := oMsGD:Acols[nI][2]
	aGetsDose[nPosArray][nPos][2] := oMsGD:Acols[nI][4]
	aGetsDose[nPosArray][nPos][3] := oMsGD:Acols[nI][5]
Next nI

// Altera flag da legenda para verde
aBrowse[oTcBrowse:nAt][1] := .T. 

oTcBrowse:Refresh(.T.)
oTcBrowse:SetFocus()        

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณApplyBD	  บAutor  ณJackson E. de Deus  บ Data ณ  25/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o atendimento.									  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ApplyBD()

UpdAtend(cTipoTela,,aGetsDose)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReplIt  บAutor  ณJackson E. de Deus    บ Data ณ  26/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReplica as doses para os produtos repetidos do grid.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReplIt()

If MsgYesNo("Deseja replicar as doses do produto atual para os produtos repetidos?")
	Processa({|| ReplIt2() },"Atualizando doses dos produtos.. Aguarde")
EndIf 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReplIt2   บAutor  ณJackson E. de Deus  บ Data ณ  26/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReplica as doses para os produtos repetidos do grid.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReplIt2()

// Verifica o objeto TcBrowse da tela anterior para formar o aCols dessa tela
ProcRegua(Len(oTcBrowse:aArray))
For nI := 1 To Len(oTcBrowse:aArray)          
	IncProc("Item: " +oTcBrowse:aArray[nI][2])             
	// se for item diferente mas produto igual
	If oTcBrowse:aArray[nI][2] <> oTcBrowse:aArray[oTcBrowse:nAt][2] .And. oTcBrowse:aArray[nI][3] == oTcBrowse:aArray[oTcBrowse:nAt][3]
		// Produto do Array igual produto do aCols porem diferente do item posicionado
		If aGetsDose[nI][1] <> oTcBrowse:aArray[oTcBrowse:nAt][2] .And. aGetsDose[nI][2] == oTcBrowse:aArray[nI][3]
			aGetsDose[nI][3] := aGetsDose[oTcBrowse:nAt][3]
			
			For nJ := 4 To Len(aGetsDose[nI])
				aGetsDose[nI][nJ][1] := aGetsDose[oTcBrowse:nAt][nJ][1]
				aGetsDose[nI][nJ][2] := aGetsDose[oTcBrowse:nAt][nJ][2]					
			Next nJ
			
			oTcBrowse:aArray[nI][1] := .T.
			oTcBrowse:Refresh(.T.)
			oTcBrowse:SetFocus()  
		EndIf
	EndIf                                   
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaCont  บAutor  ณJackson E. de Deus  บ Data ณ  26/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLancamento de contadores.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TelaCont()

Local lRet		 	:= .F.
Local aDimension	:= MsAdvSize()
Local oDlg
Local oLayer		:= FWLayer():new()
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local oPnlGrid1
Local oPnlGrid2
Local nOpc			:= 3 
Local aCampos		:= {"UD_ITEM","UD_PRODUTO","B1_DESC","ZN_PATRIMO","ZZN_NRSERI"}	//,"ZN_DATA","ZN_CODPA","ZN_NUMATU","ZN_COTCASH","ZN_TROCO","ZN_BOTTEST"}
Local aAlter		:= {}
Local nTamanho		:= 0.7
Local aDados		:= {}
Local aFalta		:= {}
Local cMsgAviso		:= ""
Local aSZI			:= {}
Private aPOS		:= {}
Private oMsGD
Private aHeader		:= {}
Private aCols		:= {}
      
LoadHead(@aCampos)
LoadCols(cNumAtend,@aDados) 

For nI := 1 To Len(aCampos)
	If aCampos[nI] $ "UD_ITEM|UD_PRODUTO|B1_DESC|ZN_PATRIMO"
		Loop
	EndIf   
	AADD(aAlter, aCampos[nI])
Next nI

For nI := 1 To Len(aDados)
	If Empty(aDados[nI][4])
		aadd(aFalta,{aDados[nI][2],aDados[nI][3]})
	EndIf
Next nI                             

If Len(aFalta) > 0                   
	cMsgAviso := "Patrim๔nio(s) nใo preenchido(s) na OMM." +CRLF
	cMsgAviso += "Ajuste a OMM e retorne para fazer essa atualiza็ใo." +CRLF
	cMsgAviso += "Produtos: " +CRLF
	For nI := 1 To Len(aFalta)
		cMsgAviso += AllTrim(aFalta[nI][1]) +" - " +aFalta[nI][2] +CRLF
	Next nI
	Aviso("TTTMKA04",cMsgAviso,{"Ok"},3)
	Return
EndIf

If nTamanho <> 100
	For nI := 1 To Len(aDimension)
		aDimension[nI] := aDimension[nI] * nTamanho
	Next nI
EndIf

oDlg := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Digita็ใo de POS",,,.F.,,,,,,.T.,,,.T. )	
	oLayer:init(oDlg,.T.)
	oLayer:addLine("LN_CAB",70,.F.)
	oLayer:addCollumn("COL_CAB",100,.f.,"LN_CAB")
	oLayer:addWindow("COL_CAB","WIN_CAB","",100,.t.,.F.,{||},"LN_CAB")
	oPnlCab := oLayer:GetWinPanel("COL_CAB","WIN_CAB","LN_CAB")
	oPnlCab:FreeChildren()
	
	oPanel1 := tPanel():New(0,0,"",oDlg,,,,,,0,030)
	oPanel1:Align := CONTROL_ALIGN_TOP
	                                                                                                             		
 	oSay1 := TSay():New(0,5,{ || "Tarefa: " +AllTrim(cDescSeq) },oPanel1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)     
   	oSay2 := TSay():New(0,200,{ || "มrea: " +AllTrim(cNomeArea) },oPanel1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)     
	oSay3 := TSay():New(10,5,{ || "Preencha os POS dos patrim๔nios" },oPanel1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)        	

	oMsGD := MsNewGetDados():New(0,0,0,0,GD_UPDATE,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'STATICCALL(TTTMKA04,CntVlCp)','AllwaysTrue()','AllwaysTrue()',oPnlCab,aHeader,aCols)
	oMsGD:Refresh(.T.)
	oMsGD:ForceRefresh(.T.)
   	oMsGD:oBRowse:Align	:= CONTROL_ALIGN_ALLCLIENT
                                        
	oPanel := TPanelCss():New(0,0,"",oDlg,,.F.,.F.,,,0,020,.T.,.F.)
	cStyle := "Q3Frame{ border-style:solid; border-width:1px; border-color:#263238; background-color:#607d8b }"
	oPanel:setCSS( cStyle ) 
	oPanel:align := CONTROL_ALIGN_BOTTOM
	oSBtn1 := TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || lOk := CntVlAll(), If(lOK,UpdAtend(cTipoTela,,aPOS),), If(lOk,oDlg:End(),) } , oPanel, "Clique para salvar" , ,)
	oSBtn2 := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel, "Clique para sair" , ,)
	                              
	oSBtn2:Align := CONTROL_ALIGN_RIGHT
	oSBtn1:Align := CONTROL_ALIGN_RIGHT
oDlg:Activate(,,,.T.,,,) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCntVlCp  บAutor  ณJackson E. de Deus   บ Data ณ  29/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณvalidacao de campo - tela dos contadores                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CntVlCp()

Local lRet := .T.
Local lTemPos := .F. 
Local nI
Local aArea := GetArea()
    
// validacao campo POS                     
If __readvar == "M->ZZN_NRSERI" .And. !Empty(&(__readvar))
	cItem := oMsGD:acols[oMsGD:nAt][1]
	dbSelectArea("SUD")
	dbSetOrder(1)
	dbSeek( xFilial("SUD") +AvKey(cNumAtend,"UD_CODIGO") +AvKey(cItem,"UD_ITEM") )
	If AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrIns)
		If "PO=1" $ SUD->UD_XMOEDA
			lTemPos := .T.
		EndIf
	ElseIf AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrRem)
		dbSelectArea("SN1")
		dbSetOrder(2)
		If dbSeek( xFilial("SN1") +AvKey(oMsGD:acols[oMsGD:nAt][4],"N1_CHAPA") )
			If "PO=1" $ SN1->N1_XSISPG
				lTemPos := .T.
			EndIf
		EndIf
	EndIf    
    If !lTemPos
    	If !Empty(&(__readvar))
    		Aviso("TTTMKA04","Esse patrim๔nio nใo possui POS em seu sistema de pagamento." +CRLF +"Nใo ้ necessแrio preencher.",{"Ok"})
    		&(__readvar) := ""
    	EndIf
    	
    	RestArea(aArea)
    	Return .T.
    EndIf
	If Len(Alltrim(&(__readvar))) < 8
		Aviso("TTTMKA04","O n๚mero do POS deve conter pelo menos 8 caracteres!",{"Ok"})
		RestArea(aArea)
		Return .F.
	EndIf
	For nI := 1 To Len(&(__readvar))
		If !IsDigit( SubStr(&(__readvar),nI,1) )
			Aviso("TTTMKA04","O n๚mero do POS deve conter somente n๚meros!",{"Ok"})
			RestArea(aArea)
			Return .F.
		EndIf
	Next nI

	cSql := "SELECT R_E_C_N_O_ REC FROM " +RetSqlName("ZZN") +" WHERE ZZN_IDPDV LIKE '%"+Alltrim(&(__readvar))+"%' AND D_E_L_E_T_ = '' "
	IIF( Select("TRBZ") > 0,TRBZ->(dbCloseArea()), )
	TcQuery cSql New Alias "TRBZ"
	dbSelectArea("TRBZ")
	dbGoTop()
	If !EOF()
		nRec := TRBZ->REC
		TRBZ->(dbCloseArea())
		dbSelectArea("ZZN")
		dbGoto(nRec)
		If Recno() == nRec
			If !Empty(ZZN->ZZN_PATRIM) .And. AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrIns) .And. AllTrim(ZZN->ZZN_PATRIM) <> AllTrim(oMsGD:acols[oMsGD:nAt][4])
				Aviso("TTTMKA04","O POS informado jแ possui um patrim๔nio vinculado." +CRLF +"Patrim๔nio: " +AllTrim(ZZN->ZZN_PATRIM) +CRLF +"Solicite ao Depto de Tesouraria a regulariza็ใo.",{"Ok"})
				RestArea(aArea)
				Return .F.
			EndIf
		EndIf
	Else
		If AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrIns)
			Aviso("TTTMKA04","O POS informado nใo estแ cadastrado no sistema." +CRLF +"Solicite ao Depto de Tesouraria a regulariza็ใo.",{"Ok"})
			RestArea(aArea)
			Return .F.
		ElseIf AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrRem)
			Aviso("TTTMKA04","O POS informado nใo confere com o que estแ vinculado a esse patrim๔nio.",{"Ok"})
			RestArea(aArea)
			Return .F.
		EndIf
	EndIf 
EndIf

RestArea(aArea)

Return lRet
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCntVlAll  บAutor  ณJackson E. de Deus  บ Data ณ  29/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณvalidacao do tudo OK da tela dos contadores                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CntVlAll()

Local lRet := .T.  
Local nI
Local cItem := ""   
Local lErro := .F.   
Local aCampos := {}
Local nCont := 0        
Local lTemPos := .F.
Local aArea := GetArea()    

For nI := 1 To Len(oMsGD:aCols)
	lTemPos := .F.
	cItem := oMsGD:acols[nI][1]
	dbSelectArea("SUD")
	dbSetOrder(1)
	dbSeek( xFilial("SUD") +AvKey(cNumAtend,"UD_CODIGO") +AvKey(cItem,"UD_ITEM") )
	If AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrIns)
		If "PO=1" $ SUD->UD_XMOEDA
			lTemPos := .T.
		EndIf
	ElseIf AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrRem)
		dbSelectArea("SN1")
		dbSetOrder(2)
		If dbSeek( xFilial("SN1") +AvKey(oMsGD:acols[oMsGD:nAt][4],"N1_CHAPA") )
			If "PO=1" $ SN1->N1_XSISPG
				lTemPos := .T.
			EndIf
		EndIf
	EndIf    
    If lTemPos .And. Empty(oMsGD:Acols[nI][5])
   		Aviso("TTTMKA04","O patrim๔nio " +AllTrim(oMsGD:acols[nI][4]) +" possui POS em seu sistema de pagamento." +CRLF +"ษ necessแrio preencher.",{"Ok"})
   		lErro := .T.
    EndIf
Next nI
                  
If lErro
	lRet := .F.
Else	                                 
	For nI := 1 To Len(oMsGD:aCols)	                           	
		AADD(aPOS,{oMsGD:Acols[nI,1],oMsGD:Acols[nI,4],oMsGD:Acols[nI,5]})
	Next nI  
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaConf  บAutor  ณJackson E. de Deus  บ Data ณ  23/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfirmacao de instalacao/remocao                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaConf()

Local cTitulo		:= cDescSeq
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local cMsgAviso		:= ""
Local aFalta		:= {}
Local nI                
Local aInfo		 	:= {}
Private oTcBrowse	     
Private oDlg1 
Private aBrowse
Private aDados		:= {}
Private nPosItem 	:= 2
Private nPosProd 	:= 3
Private nPosPatr	:= 4
Private nPosLoc  	:= 6
Private nPosVolt 	:= 7
Private nPosData 	:= 8
Private nPosHora 	:= 9
Private cRet		:= ""
Private cRetVolt	:= ""

// Busca os dados
LoadCols(cNumAtend,@aDados)
aBrowse := aCLone(aDados)

For nI := 1 To Len(aDados)
	If AllTrim(aDados[nI][4]) == ""
		aadd(aFalta,{aDados[nI][3],aDados[nI][5]})
	EndIf
Next nI                             

If Len(aFalta) > 0                   
	cMsgAviso := "Patrim๔nio(s) nใo preenchido(s) na OMM." +CRLF
	cMsgAviso += "Ajuste a OMM e retorne nessa rotina." +CRLF
	cMsgAviso += "Produtos: " +CRLF
	For nI := 1 To Len(aFalta)
		cMsgAviso += AllTrim(aFalta[nI][1]) +" - " +aFalta[nI][2] +CRLF
	Next nI
	Aviso("TelaConf",cMsgAviso,{"Ok"})
	Return
EndIf
     
// monta a tela
oDlg1 := MSDialog():New(110,234,465,910,cTitulo,,,.F.,,,,,,.T.,,,.T. ) 

oSay  := TSay():New(002,002,{|| "Tarefa: " +cDescSeq },oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
oSay2  := TSay():New(012,002,{||"มrea: " +cNomeArea},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
oSay3 := TSay():New(022,002,{|| "Confirme a instala็ใo/remo็ใo dos produtos:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,120,008)

oGroup := TGroup():New(035,002,148,450,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F.)

oTcBrowse := TCBrowse():New(037,005,332,110,,{" ", "Item", "Produto", "Patrim๔nio", "Descri็ใo", "Local Fํsico", "Voltagem", "Data", "Hora"},;
			{5,15,25,40,70,50,20,30,20},oGroup,,,,,{||},{ || If( MsgYesNo("Deseja replicar a data para os pr๓ximos itens?"),RepData(), ) },,,,,,.F.,,.T.,,.F.,,.T.,.F.,)

oTcBrowse:SetArray(aBrowse)

// Monta a linha a ser exibina no Browse
oTcBrowse:bLine := {||{ If(aBrowse[oTcBrowse:nAt,01],oOK,oNO),;	// Flag
						aBrowse[oTcBrowse:nAt,02],;				// Item
						aBrowse[oTcBrowse:nAt,03],;				// Produto
						aBrowse[oTcBrowse:nAt,04],;				// Patrimonio
						aBrowse[oTcBrowse:nAt,05],;				// Descricao
						aBrowse[oTcBrowse:nAt,06],;				// Local fisico
						aBrowse[oTcBrowse:nAt,07],;				// Voltagem
						aBrowse[oTcBrowse:nAt,08],;				// Data
						aBrowse[oTcBrowse:nAt,09]}}				// Hora

oTcBrowse:bWhen			:= { || Len(aBrowse) > 0 }     
oTcBrowse:bLDblClick	:= { || EditCell() }  

oSBtn1 := TButton():New( 015,063,"Confirmar",oDlg1,{|| AddaInfo2(@aInfo,nPosItem,nPosProd,nPosLoc,nPosData,nPosHora),IIF(Len(aInfo)>0,UpdAtend(cTipoTela,cMsg,aInfo),), oDlg1:End()},35,12 )
oSBtn2 := TButton():New( 015,073,"Sair",oDlg1,{|| oDlg1:End()},35,12 )

oDlg1:Refresh()
oDlg1:Activate(,,,.T.)                                                                                                                                                                   
	
Return	

                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEditCell	  บAutor  ณJackson E. de Deus  บ Data ณ  23/07/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPermite a edicao dos campos.								  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EditCell()
        
Local cLocOrig := ""
Local cData := ""
Local cHora := ""
Local nPosAtual := 0
	
dbSelectArea("SUC")
 
lEditCell(@oTcBrowse:aArray,oTcBrowse,PesqPict("SUC","UC_PENDENT"),nPosData)
If !Empty(oTcBrowse:aArray[oTcBrowse:nAt][nPosData]) .And. oTcBrowse:nLen > 1
	If MsgYesNo("Deseja replicar a data para os pr๓ximos itens?")
		cData := oTcBrowse:aArray[oTcBrowse:nAt][nPosData]
		nPosAtual := oTcBrowse:nAt
		nPosAtual++           
		
		For nI := nPosAtual To Len(oTcBrowse:aArray)	
			oTcBrowse:aArray[nI,nPosData] := cData					
		Next nI         
		oTcBrowse:Refresh()
	EndIf
EndIf	
 
lEditCell(@oTcBrowse:aArray,oTcBrowse,PesqPict("SUC","UC_INICIO"),nPosHora)
If !Empty(oTcBrowse:aArray[oTcBrowse:nAt][nPosHora]) .And. oTcBrowse:nLen > 1
	If MsgYesNo("Deseja replicar a hora para os pr๓ximos itens?")
		cHora := oTcBrowse:aArray[oTcBrowse:nAt][nPosHora]
		nPosAtual := oTcBrowse:nAt
		nPosAtual++           
		
		For nI := nPosAtual To Len(oTcBrowse:aArray)	
			oTcBrowse:aArray[nI,nPosHora] := cHora					
		Next nI         
		oTcBrowse:Refresh()
	EndIf
EndIf	

If oTcBrowse:ColPos() == nPosVolt 
	lEditCell(@oTcBrowse:aArray,oTcBrowse,"@!",oTcBrowse:ColPos())
	oTcBrowse:aArray[oTcbrowse:nAt][nPosVolt] := cRetVolt
	oTcBrowse:Refresh()
	oTcBrowse:DrawSelect()		
ElseIf oTcBrowse:ColPos() == nPosData 
	//lEditCell(@oTcBrowse:aArray,oTcBrowse,PesqPict("SUC","UC_PENDENT"),oTcBrowse:ColPos())
ElseIf oTcBrowse:ColPos() == nPosHora
	//lEditCell(@oTcBrowse:aArray,oTcBrowse,PesqPict("SUC","UC_INICIO"),oTcBrowse:ColPos())
ElseIf oTcBrowse:ColPos() == nPosLoc
	cLocOrig := aBrowse[oTcbrowse:nAt][nPosLoc] 
	lEditCell(@oTcBrowse:aArray,oTcBrowse,PesqPict("SUD","UD_XLOCFIS"),nPosLoc)
	oTcBrowse:aArray[oTcbrowse:nAt][nPosLoc] := cRet
		
	If !ExistCpo("SZ8", AllTrim(SUC->UC_CHAVE) +oTcBrowse:aArray[oTcbrowse:nAt][nPosLoc],2)	// Verifica na SZ8 - INDICE 2 
		oTcBrowse:aArray[oTcbrowse:nAt][nPosLoc] := cLocOrig	
	EndIf

	oTcBrowse:Refresh()
	oTcBrowse:DrawSelect()
EndIf
                      
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAddaInfo2	บAutor  ณJackson E. de Deus  บ Data ณ  23/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara o array aInfo para posterior atualizacao da SUD.	  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AddaInfo2(aInfo,nPosItem,nPosProd,nPosLoc,nPosData,nPosHora)

Local cVoltagem := ""
Local cHora		:= ""

// Valida os campos
For nI := 1 To Len(oTcBrowse:aArray)                                  	
	If !Upper(oTcBrowse:aArray[nI][nPosVolt]) $ "110V|220V"
		Aviso("TTTMKA04","Corrija o campo Voltagem do item " +oTcBrowse:aArray[nI][nPosItem] +".",{"Ok"})
		Return
	EndIf
	If Empty(oTcBrowse:aArray[nI][nPosData])
		Aviso("TTTMKA04","Corrija o campo Data do item " +oTcBrowse:aArray[nI][nPosItem] +".",{"Ok"})
		Return
	EndIf                                      
	If AllTrim(oTcBrowse:aArray[nI][nPosHora]) == ""
		Aviso("TTTMKA04","Corrija o campo Hora do item " +oTcBrowse:aArray[nI][nPosItem] +".",{"Ok"})
		Return
	EndIf
	If SubStr(oTcBrowse:aArray[nI][nPosHora],4,1) == "" .Or. SubStr(oTcBrowse:aArray[nI][nPosHora],4,2) == "" 
		Aviso("TTTMKA04","Preencha corretamente o campo hora do item " +oTcBrowse:aArray[nI][nPosItem] +".",{"Ok"})
		Return
	EndIf
Next nI                                                          
       
// Adiciona no Array aInfo os itens do Grid
For nI := 1 To Len(oTcBrowse:aArray)
	If Upper(oTcBrowse:aArray[nI][nPosVolt]) == "110V"
		cVoltagem := "110"
	ElseIf Upper(oTcBrowse:aArray[nI][nPosVolt]) == "220V"
		cVoltagem := "220"	
	EndIf                   
	If AllTrim(SubStr(oTcBrowse:aArray[nI,nPosHora],7,2)) == ""
		cHora := AllTrim(oTcBrowse:aArray[nI,nPosHora]) +"00"
	Else
		cHora := AllTrim(oTcBrowse:aArray[nI,nPosHora])
	EndIf
	AADD(aInfo,{oTcBrowse:aArray[nI,nPosItem],oTcBrowse:aArray[nI,nPosProd],oTcBrowse:aArray[nI,nPosLoc],cVoltagem,oTcBrowse:aArray[nI,nPosData],cHora})
Next nI                                                          
                                            
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXRetLoc	บAutor  ณJackson E. de Deus  บ Data ณ  23/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os locais de instalacao.							  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function XRetLoc(aLocais,cpCliente,cpLoja)

Local cQuery := ""

cQuery += "SELECT Z8_LOCFIS1 " +CRLF
cQuery += "FROM " +RetSqlName("SZ8") +" SZ8 " +CRLF
cQuery += "WHERE " +CRLF
cQuery += "SZ8.Z8_CLIENTE = '"+cpCliente+"' " +CRLF
cQuery += "AND SZ8.Z8_LOJA = '"+cpLoja+"' " +CRLF
cQuery += "AND SZ8.D_E_L_E_T_ = '' "
cQuery += "ORDER BY SZ8.Z8_LOCFIS1"

cQuery := ChangeQuery(cQuery)
    
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                          
TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	AADD(aLocais,{AllTrim(TRB->Z8_LOCFIS1)})
	TRB->(dbSkip())
End
TRB->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRepData   บAutor  ณJackson E. de Deus  บ Data ณ  03/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReplica a data digitada                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RepData()

Local cData := ""
Local nPosAtual := 0

If Empty(oTcBrowse:aArray[oTcBrowse:nAt][nPosData])
	Return
EndIf

cData := oTcBrowse:aArray[oTcBrowse:nAt][nPosData]
nPosAtual := oTcBrowse:nAt
nPosAtual++           

For nI := nPosAtual To Len(oTcBrowse:aArray)	
	oTcBrowse:aArray[nI,nPosData] := cData					
	//lEditCell(@oTcBrowse:aArray,oTcBrowse,PesqPict("SUC","UC_PENDENT"),oTcBrowse:ColPos())
Next nI         

oTcBrowse:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaTes   บAutor  ณJackson E. de Deus  บ Data ณ  27/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para lancamento do troco e lacres	                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaTes()

Local cTitulo		:= ""
Local cLimTroco		:= 0
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local lOk 			:= .T.
Local cNumChapa		:= ""
Local nTipo			:= 0
Local nLimTroco		:= 0
Local aInfo			:= {}
Local aAuxLacres	:= {}
Local aAuxMoedas	:= {} 
Local aLacres		:= {}
Local aMoedas		:= {}
Local aLimTroco		:= {}
Local nI
Private oList	     
Private oDlg 
Private aBrowse
Private aCols		:= {}	
Private aDados		:= {}

LoadCols(cNumAtend,@aDados)

aBrowse := aCLone(aDados)

For nI := 1 To Len(aBrowse)
	AADD(aInfo,{aBrowse[nI,2],;				// [1] Item
				aBrowse[nI,3],;				// [2] Produto
				aBrowse[nI,4],;				// [3] Patrimonio
	            "",;                        // [4] Lacre;tipo;cor;gleenview
				0})							// [5] Troco
Next nI

           
oDlg := MSDialog():New(110,234,465,790,cTitulo,,,.F.,,,,,,.T.,,,.T. ) 
	oSay  := TSay():New(002,002,{|| "Tarefa: " +cDescSeq},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay1 := TSay():New(012,002,{|| "มrea: " +cNomeArea},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

	oGroup := TGroup():New(035,002,148,279,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F.)
	
	oList := TCBrowse():New(037,005,271,110,,,{5,10,15,30,10},oGroup,,,,{|| refresh(@cNumChapa,@nLimTroco,aLimTroco)},{ || TELAINF(nTipo, cNumChapa, nLimTroco, @aInfo, aLacres, aMoedas) },/*{ || Marca() }*/,,,,,,.F.,,.T.,{ || Len(aBrowse) > 0},.F.,,.T.,.T.,)
		
	oList:SetArray(aBrowse)
	
	oList:AddColumn(TCColumn():New(' '			,{||If(aBrowse[oList:nAt,01],oOk,oNo)},"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Item'		,{||aBrowse[oList:nAt,02]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Produto'	,{||aBrowse[oList:nAt,03]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Patrim๔nio'	,{||aBrowse[oList:nAt,04]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Descri็ใo'	,{||aBrowse[oList:nAt,05]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	
	ChkOMM(@nTipo,@nLimTroco,@aLacres,@aMoedas,@aLimTroco)	
	         
	oSBtn1 := TBtnBmp2():New( 295, 475, 40, 40, 'OK'		, , , ,{|| lOk := Atualiza(), If(lOK,UpdAtend(cTipoTela,,aInfo), ), If(lOK,oDlg:End(), )   } , oDlg, "Salvar" , ,)
	oSBtn2 := TBtnBmp2():New( 296, 515, 40, 40, 'CANCEL'	, , , ,{|| oDlg:End()} , oDlg, "Sair" , ,)
		
	oDlg:Refresh()
oDlg:Activate(,,,.T.)         

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณrefresh   บAutor  ณMicrosiga           บ Data ณ  03/21/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function refresh(cNumChapa,nLimTroco,aLimTroco)

Local nI
                         
cNumchapa := oList:aArray[oList:nAt][4]

// pega o troco do patrimonio
For nI := 1 To Len(aLimTroco)
	If aLimTroco[nI][1] == cNumChapa
		nLimTroco := aLimTroco[nI][2]
	EndIf
Next nI
                             
Return
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtualiza  บAutor  ณJackson E. de Deus  บ Data ณ  27/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Atualiza()

Local lOk := .T.

For nI := 1 To Len(oList:aArray)
	If !oList:aArray[nI][1]
		Aviso("TTTMKA04","Preencha as moedas/materiais de todos os itens.",{"Ok"})
		Return .F.
	EndIf
Next nI

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaInf   บAutor  ณJackson E. de Deus  บ Data ณ  27/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra a tela para digitacao das moedas/materiais           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TelaInf(nTipo, cNumChapa, nLimTroco, aInfo, aLacres, aMoedas)

Local lRet := .F.

If oList:aArray[oList:nAt][1]
	Aviso("TTTMKA04","Jแ foi feito o lan็amento das moedas/materiais desse patrim๔nio.",{"Ok"}) 
EndIf

lRet := U_TTTMKA20(nTipo, cNumChapa, nLimTroco, @aInfo, aLacres, aMoedas)
If lRet
	oList:aArray[oList:nAt][1] := .T.
	oDlg:refresh(.t.)
EndIf
      
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkOMM    บAutor  ณJackson E. de Deus  บ Data ณ  27/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica o tipo da OMM e limite de troco                    บฑฑ
ฑฑบ          ณe se ja houve digitacao dos lacres/moedas                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkOMM(nTipo,nLimTroco,aAuxLacres,aAuxMoedas,aLimTroco)
                       
Local aArea := GetArea()
Local aDoses := {}
Local nI,nJ
Local aAux := {}
Local aAux2 := {}
Local cAux := ""
Local cAux2 := ""
Local cAuxLac := ""
Local cAuxTroco := ""
Local cLacre := ""
Local cTipo := ""
Local cCor := ""
Local cGleenv := ""
Local nTotal := 0
Local nMoe1 := 0
Local nMoe2 := 0
Local nMoe3 := 0
Local nMoe4 := 0
Local nMoe5 := 0

dbSelectArea("SUD")
dbSetOrder(1)
For nI := 1 To Len(oList:aArray)
	If dbSeek( xFilial("SUD") +cNumAtend +oList:aArray[nI][2] )
		// Pega o tipo de atendimento
		If AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrIns)
			nTipo := 1
		ElseIf AllTrim(SUD->UD_OCORREN) == AllTrim(cOcorrRem)
			nTipo := 2
		EndIf                           
		
		If !Empty(SUD->UD_XDOSES)
			aDoses := StrToKarr(SUD->UD_XDOSES,"|")
											    
			// Pega o limite de troco
			If Len(aDoses) > 0 .And. dDataOMM > CtoD("07/10/2013")
				nLimTroco := Val(aDoses[1])						
			EndIf
			AADD( aLimTroco, { oList:aArray[nI][4], nLimTroco  } )  
		EndIf	
	
		// Verifica se ja houve lancamento dos valores
		If !Empty(SUD->UD_XLACRE) .And. !Empty(SUD->UD_XTROCO)
			oList:aArray[nI][1] := .T.
			
			/*
			// Lacres / Troco
			cAuxLac := SUD->UD_XLACRE
			cAuxTroco := SUD->UD_XTROCO
			
			// Separa os lancamentos de lacres
			If !Empty(cAuxLac)
				aAux := StrToKarr(cAuxLac,"|")    
				For nJ := 1 To Len(aAux)
					aAux2 := StrToKarr(aAux[nJ],";")  
					cLacre	:= IIF(Len(aAux2) > 0, aAux2[1], "" ) 
					cTipo	:= IIF(Len(aAux2) > 1, aAux2[2], "" ) 
					cCor	:= IIF(Len(aAux2) > 2, aAux2[3], "" ) 
					cGleenv	:= IIF(Len(aAux2) > 3, aAux2[4], "" ) 
					AADD( aLacres, { cLacre, cTipo, cCor, cGleenv, .F. } )
				Next nJ
			EndIf	
			                    
			// Separa as moedas do troco
			If !Empty(cAuxTroco)
				aAux := StrToKarr(cAuxTroco,";")
		
				// na instalacao - 5 tipos de moedas
				If nTipo == 1
					nMoe1 := IIF( Len(aAux) > 0, Val(aAux[1]), 0 )  
					nMoe2 := IIF( Len(aAux) > 1, Val(aAux[2]), 0 )  
					nMoe3 := IIF( Len(aAux) > 2, Val(aAux[3]), 0 )  
					nMoe4 := IIF( Len(aAux) > 3, Val(aAux[4]), 0 )  
					nMoe5 := IIF( Len(aAux) > 4, Val(aAux[5]), 0 )  
					nTotal := nMoe1 + nMoe2 + nMoe3 + nMoe4 + nMoe5              
					
					AADD( aMoedas, { "R$ 0,05", nMoe1} )
					AADD( aMoedas, { "R$ 0,10", nMoe2} )
					AADD( aMoedas, { "R$ 0,25", nMoe3} )
					AADD( aMoedas, { "R$ 0,50", nMoe4} )
					AADD( aMoedas, { "R$ 1,00", nMoe5} )
					AADD( aMoedas, { "Total", nTotal } ) 
					                                   		
				// na remocao - moedas e cedulas			
				ElseIf nTipo == 2
					nMoe1 := aAux2[1]
					nMoe2 := aAux2[2]
					nTotal := nMoe1 + nMoe2
					AADD( aMoedas, { "Moedas", nMoe1} )
					AADD( aMoedas, { "Cedulas", nMoe2} )
					AADD( aMoedas, { "Total", nTotal } )		
				EndIf
			EndIf
			*/
	   EndIf				
	EndIf			    
Next nI
											
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaPlTrab  บAutor  ณJackson E. de Deusบ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfiguracao do plano de trabalho das maquinas              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TelaPlTrab()

Local lRet		 	:= .F.
Local aDimension	:= MsAdvSize()
Local oDlg
Local oLayer		:= FWLayer():new()
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local oPnlGrid1
Local oPnlGrid2
Local nOpc			:= 3 
Local aCampos		:= { "UD_ITEM","UD_PRODUTO","B1_DESC","ZN_PATRIMO" }
Local aAlter		:= {}
Local nTamanho		:= 0.7
Local aDados		:= {}
Local aFalta		:= {}
Local cMsgAviso		:= ""
Local oOk			:= LoadBitMap(GetResources(), "BR_VERDE")
Local oNo			:= LoadBitMap(GetResources(), "BR_VERMELHO")
Local aDados		:= {}
Private oMsGD
Private aHeader		:= {}
Private aCols		:= {}

LoadCols(cNumAtend,@aDados)
      
oDlg := MSDialog():New( 110,234,465,790,"Configura็ใo do plano de trabalho",,,.F.,,,,,,.T.,,,.T. )	
	oPanel1 := tPanel():New(0,0,"",oDlg,,,,,,0,030)
	oPanel1:Align := CONTROL_ALIGN_TOP
	                                                                                                             		
 	oSay1 := TSay():New(0,5,{ || "Tarefa: " +AllTrim(cDescSeq) },oPanel1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)     
   	oSay2 := TSay():New(10,5,{ || "มrea: " +AllTrim(cNomeArea) },oPanel1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,010)     
	oSay3 := TSay():New(20,5,{ || "Configure o plano de trabalho" },oPanel1,"",oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)        	
    
    oPanel2 := tPanel():New(0,0,"",oDlg,,,,,,0,0)
	oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
	
	oList := TCBrowse():New(0,0,0,0,,,{5,10,15,30,10},oPanel2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.F.,)
	oList:SetArray(aDados)
	
	oList:AddColumn(TCColumn():New(' '			,{|| If(aDados[oList:nAt,01],oOk,oNo)},"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Item'		,{|| aDados[oList:nAt,02]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Produto'	,{|| aDados[oList:nAt,03]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Descri็ใo'	,{|| aDados[oList:nAt,04]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New('Patrim๔nio'	,{|| aDados[oList:nAt,05]},"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	
	oList:bWhen := { || Len(aDados) > 0 }     
	oList:bLDblClick := {|| PlTrbPatr()}
	oList:Align := CONTROL_ALIGN_ALLCLIENT  
                                        
	oPanel := TPanelCss():New(0,0,"",oDlg,,.F.,.F.,,,0,020,.T.,.F.)
	cStyle := "Q3Frame{ border-style:solid; border-width:1px; border-color:#263238; background-color:#607d8b }"
	oPanel:setCSS( cStyle ) 
	oPanel:align := CONTROL_ALIGN_BOTTOM
	oSBtn1 := TBtnBmp2():New( 0, 0, 40, 40, 'OK'	, , , ,{ || UpdAtend(cTipoTela),oDlg:End() } , oPanel, "Clique para salvar" , ,)
	oSBtn2 := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel, "Clique para sair" , ,)
	                              
	oSBtn2:Align := CONTROL_ALIGN_RIGHT
	oSBtn1:Align := CONTROL_ALIGN_RIGHT
oDlg:Activate(,,,.T.,,,) 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlTrbPatr  บAutor  ณJackson E. de Deus บ Data ณ  01/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Configuracao do plano de trabalho da maquina posicionada   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PlTrbPatr()
        
Local lRet := .F.
Local aArea := GetArea()
Local cPatrimo := oList:aArray[oList:nAt][5]
Local nRecnoZE := 0
Local cSql := ""

dbSelectArea("SUD")

If dbSeek( xFilial("SUD") +cNumAtend +oList:aArray[oList:nAt][2] )
	cSql := "SELECT R_E_C_N_O_ REC FROM " +RetSqlName("SZE") +" WHERE ZE_MENSAL LIKE '"+SUBSTR(DtoS(dDatabase),1,6)+"%' AND ZE_CHAPA = '"+cPatrimo+"' "
	cSql += " AND ZE_CLIENTE = '"+cpCliente+"' AND ZE_LOJA = '"+cpLoja+"' AND ZE_TIPOPLA = '14'  AND D_E_L_E_T_ = '' "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf                  
	TcQuery cSql new Alias "TRB"
	dbSelectArea("TRB")
	If !EOF()
		nRecnoZE := TRB->REC
	EndIf

	lRet := U_TTOPER14(cPatrimo,cpCliente,cpLoja,nRecnoZE)                                 
	If lRet
		oList:aArray[oList:nAt][1] := .T.
	EndIf
EndIf

RestArea(aArea)

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUpdAtend	บAutor  ณJackson E. de Deus  บ Data ณ  23/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os campos.										  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function UpdAtend(cTipoTela,cMsg,aInfo)

//Local cOcorrRem		:= SuperGetMV("MV_XTMK004",.T.,"")
Local lStatusSZD	:= .F.
Local lExistOMM		:= .F.
Local lAtivaBlq		:= SuperGetMV("MV_XTMK017",.T.,.F.)
Local aArea
Local nContErro		:= 0
Local aPatrimonio	:= {}
Local lInstall		:= .F.
Local lRemove		:= .F.

Default cMsg		:= ""
Default aInfo		:= {}

If lAtuObs
	cMsg := AllTrim(cMsg)
	cMsg := SubStr(cMsg,1,75)	// recorta para tamanho max 75 carac.
EndIf

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณTratamento para OMM de remocao                                                                   ณ
ณVerificar no historico de movimentacao de maquinas se existe registro da instalacao do patrimonioณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
// Tarefa de inserir os patrimonios e Tarefa de efetivar data de instalacao/remocao - Nessa tarefa sao atualizadas a SN1 e a SZD
// OBS -> DEVE SER DESENVOLVIDO O TRATAMENTO PARA OS CASOS DE INSTALACAO - INSTALACAO QUANDO JA EXISTE INSTALACAO NO CLIENTE/LOJA
If lAtuPatrim .Or. lConfOper
	If lAtivaBlq
		dbSelectArea("SUD")
		aArea := GetArea()
	
		dbSelectArea("SUD")
		dbSetOrder(1)
		While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
			If AllTrim(SUD->UD_OCORREN) == cOcorrTnf
				nContErro++
			Else
				If AllTrim(SUD->UD_OCORREN) == cOcorrIns
					lInstall := .T.
				ElseIf AllTrim(SUD->UD_OCORREN) == cOcorrRem
					lRemove := .T.
				EndIf
				
				If lConfOper
					AADD(aPatrimonio,{SUD->UD_XNPATRI})
				EndIf
			EndIf
			dbSkip()
		End
		
		If lAtuPatrim
			For nX := 1 To Len(aInfo)
				AADD(aPatrimonio,{aInfo[nX][3]})
			Next nX
		EndIf
		
		If nContErro == 0 .And. Len(aPatrimonio) > 0
			// instalacao
			If lInstall
				lStatusSZD := StatusSZD(aPatrimonio,cpCliente,cpLoja,1)
				If ValType(lStatusSZD) == "L"
					If !lStatusSZD
						Return
					EndIf
				EndIf	
			
			// remocao	
			ElseIf lRemove
				If lAtuPatrim
					//Primeiro verifica se existe OMM de remocao em aberto onde consta algum desses patrimonios
					lChkOMM := ChkOMMRem(aPatrimonio,cpCliente,cpLoja)
					If ValType(lExistOMM) == "L"
						If !lChkOMM
							Return
						EndIf
					EndIf         
					
					//Verifica o historico de movimentacao de maquinas - SZD
					lStatusSZD := StatusSZD(aPatrimonio,cpCliente,cpLoja,2)
					If ValType(lStatusSZD) == "L"
						If !lStatusSZD
							Return
						EndIf
					EndIf	                                                         
				Else
					lStatusSZD := StatusSZD(aPatrimonio,cpCliente,cpLoja,2)
					If ValType(lStatusSZD) == "L"
						If !lStatusSZD
							Return
						EndIf
					EndIf	
				EndIf
			EndIf	
		EndIf
		RestArea(aArea)
	EndIf                        
EndIf
                                 
//Executa a funcao AtuCampos - atualiza tudo	                                                                  
MsAguarde({ || AtuCampos(cTarefa,cSeqAtu,cMsg,aInfo)},"Aguarde, atualizando atendimento...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuCampos	บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os campos.										  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuCampos(cTarefa,cSeqAtu,cObs,aInfo)							

Local alAreaSUD
Local cQuery		:= ""                                                               
Local cDtDia		:= ""
Local cTime			:= ""
Local cString		:= ""
Local aDados		:= {}
Local cSeqNew		:= ""
Local cCodFil		:= ""
Local lUpd			:= .F.
Local cMsgObs		:= ""
Local cTxtObs		:= ""
Local cNewTxt		:= ""
Local cAuxTxt		:= ""
Local cTxtRes		:= ""
Local nPosRest		:= 0
Local llOk			:= .F.
Local cNumTmk		:= ""
Local cTarget		:= ""
Local aItens		:= {}
Local nLimtroco		:= 0
Local cDoses		:= ""
Local cUDOBS		:= ""
Local aCabMail		:= {}
Local cArqMail		:= ""
Local cSubject		:= ""
Local cRemete		:= ""
Local aAttach		:= {}
Local lGeraPV		:= .F.
Local cStatusFim	:= SuperGetMV("MV_XTMK005",.T.,"000001")	// status de finalizacao da tarefa/atendimento
Local lAltPlan		:= .F.
Local nI			:= 0
Local nJ			:= 0
Local nK			:= 0
Local nL			:= 0
Local nX			:= 0
Local nZ			:= 0
Local nY			:= 0
Local aAuxMM		:= {}
Local nPosP			:= 0
Local aDoses		:= {}
Local aDosesAux		:= {}
Local lMailOK		:= .F.	// controle para nao repetir os emails dos usuarios
Local cSisP			:= ""
Local aSisP			:= {}
Local nRecSN1		:= 0
Local lBlqOMMCont	:= SuperGetMV("MV_XTMK019",.T.,.F.)	// Ativa bloqueio quando nao encontrar contrato
Local lLocacao		:= .F.
Local cTarefas		:= SuperGetMV("MV_XTMK021",.T.,"")		// Tipo de contrato de locacao
Local lOk			:= .F.
Local dznData		:= ctod("")
Local nznCotCash	:= 0
Local lOkSZN		:= .F.
Local lExistSZN		:= .F.
Local nVlrTroco		:= 0
Local aTroco		:= 0
Local nZNTroco		:= 0 
Local cDescTar		:= ""
Local aAltATF		:= {}
Local lGeraLog		:= IIF(FindFunction("U_TTGENC01"),.T.,.F.)
Local lAuditoria	:= .F.
Default cTarefa 	:= ""
Default cSeqAtu		:= ""
Default cObs		:= ""

If Empty(cTarefa)
	Return
EndIf

cDtDia := Date()
cDtDia := DtoC(cDtDia)
cTime := Time()

// sequencia de tarefas
cQuery := "SELECT " +CRLF 
cQuery += "Z9_FILIAL, Z9_COD, Z9_DESC, Z9_SEQ, Z9_TAREFA, Z9_AREA, Z9_SLA, Z9_CORELAC, Z9_DESC, " +CRLF
cQuery += "UQ_DESC, UQ_CODRESP, UQ_EMAIL " +CRLF
cQuery += "FROM "+RetSqlName("SZ9") +" SZ9 " +CRLF
cQuery += "INNER JOIN "+RetSqlName("SUQ") +" SUQ ON " +CRLF 
cQuery += "SZ9.Z9_CORELAC = SUQ.UQ_SOLUCAO " +CRLF
cQuery += "AND SZ9.D_E_L_E_T_ = SUQ.D_E_L_E_T_ " +CRLF
cQuery += "WHERE " +CRLF
cQuery += "SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"' " +CRLF
cQuery += "AND SZ9.Z9_COD = '"+cTarefa+"' " +CRLF 
cQuery += "AND SZ9.D_E_L_E_T_ = '' "
cQuery += "ORDER BY SZ9.Z9_SEQ "

If Select("TRB") > 0 
	TRB->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")
dbGoTop()
While !EOF()
   	AADD(aDados, {TRB->Z9_COD, TRB->Z9_SEQ, TRB->Z9_TAREFA, TRB->Z9_AREA, TRB->Z9_SLA, TRB->Z9_CORELAC, TRB->UQ_DESC,TRB->UQ_CODRESP, TRB->UQ_EMAIL,TRB->Z9_DESC})   			   				 
   	TRB->(dbSkip())
End
TRB->(dbCloseArea())                                          

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
ณAtualiza informacoes do registro                            ณ
ณPreenche a acao, descricao, responsavel, tarefa, sequencia  ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
*/	     
If Len(aDados) == 0
	Return
EndIf

dbSelectArea("SZ9")
dbSetOrder(2)	// filial + tarefa + sequencia
If dbSeek(xFilial("SZ9")+AvKey(cTarefa,"Z9_COD")+AvKey(cSeqAtu,"Z9_SEQ"))
	If AllTrim(SZ9->Z9_CONTROL) $ "2|3"
		lGeraPV := .T.
	EndIf
	cDescTar := ALLTRIM(UPPER(SZ9->Z9_DESC))
EndIf  
	
dbSelectArea("SUC")
cSeqNew := Soma1(cSeqAtu)
cNumTmk := cNumAtend //SUC->UC_CODIGO
dbSeek( xFilial("SUC")+cNumTmk )
cCodFil := SUC->UC_FILIAL
		
dbSelectArea("SUD")
alAreaSUD := GetArea()
dbSeek(xFilial("SUD")+cNumTmk+"01")
                         
If strzero(Len(aDados),3) == cSeqAtu
	lAtuStatus  := .T.
EndIf

BeginTran()           
While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
	lUpd := .F.		 	
	If !lAtuStatus
		For nI := 1 To Len(aDados)
			If !lUpd
				For nJ := 1 To Len(aDados[nI])
					If aDados[nI][1] == cTarefa .And. aDados[nI][2] == AllTrim(cSeqNew)
						// verifica se preencheu o tipo de contrato
						If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrIns
							If Empty(SUD->UD_XTPCONT)
								Aviso("TTTMKA04","INCONSISTENCIA" +CRLF +"Nใo foi informado o tipo de contrato em detalhes da mแquina."+CRLF +"O patrim๔nio deve ter um tipo de contrato selecionado." ,{"Ok"})
								DisarmTransaction()
								If FindFunction("U_TTGENC01")
									U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Nใo foi informado o tipo de contrato em detalhes da mแquina: "+SUD->UD_XNPATRI,cpCliente,cpLoja,"SUD")	
								EndIf
								Return .F.
							EndIf
						EndIf	
											
						If RecLock("SUD",.F.)
							SUD->UD_SOLUCAO := aDados[nI][6]
							//Alterado a busca do operador para tratar as omms que serao destinadas as filiais. - Alexandre 19/07/13
							SUD->UD_OPERADO := If(empty(aDados[nI][8]),Operad(SUC->UC_CHAVE),aDados[nI][8])
							SUD->UD_XTAREF	:= cTarefa
							SUD->UD_XTARSEQ := aDados[nI][2]
							SUD->UD_XTARDT	:= Date()
							SUD->UD_XTARHR	:= Time()
							
							// Varre Array aInfo [Pode ser: Patrimonios,Contratos,Doses,Confirmacao de inst/rem]
							For nK := 1 To Len(aInfo)
								If SUD->UD_ITEM == aInfo[nK][1] .And. SUD->UD_PRODUTO == aInfo[nK][2]
								    If lAtuPatrim	
										SUD->UD_XNPATRI := aInfo[nK][3]
										If AllTrim(SUD->UD_XNPATRI) <> ""
											// Se for Instalacao
											If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrIns
												dbSelectArea("SN1")
												dbSetOrder(2)	// filial + chapa
												nRecSN1 := U_TTTMKA19(SUD->UD_XNPATRI)
												If nRecSN1 > 0
													SN1->( dbGoTo(nRecSN1) )
													If RecLock("SN1",.F.)
														SN1->N1_XSTATTT := "5"	// empenhado
														SN1->(MsUnlock())
													EndIf   
												EndIf
												dbSelectArea("SUD")
											  EndIf
											// Se for Remocao
											If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrRem
												dbSelectArea("SN1")
												dbSetOrder(2)	// filial + chapa
												nRecSN1 := U_TTTMKA19(SUD->UD_XNPATRI)
												If nRecSN1 > 0
													If RecLock("SN1",.F.)
														SN1->N1_XSTATTT := "6"	// em remocao
														SN1->(MsUnlock())
													EndIf   
												EndIf
												dbSelectArea("SUD")
										    EndIf
												
											// Se for Transferencia
											If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrTnf
												dbSelectArea("SN1")
												dbSetOrder(2)	// filial + chapa
												nRecSN1 := U_TTTMKA19(SUD->UD_XNPATRI)
												If nRecSN1 > 0
													If RecLock("SN1",.F.)
														SN1->N1_XSTATTT := "7" // em transferencia
														SN1->(MsUnlock())
													EndIf   
												EndIf
												dbSelectArea("SUD")
										    EndIf
									    EndIf
									  
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Patrimonio inserido: "+SUD->UD_XNPATRI,cpCliente,cpLoja,"SUD")	
										EndIf
									EndIf    
									
									If lAtuContrato                                                 
										SUD->UD_XCONTRA := aInfo[nK][3]
										If AllTrim(aInfo[nK][4]) <> ""
											SUD->UD_XPLAN := aInfo[nK][4]
										EndIf
									
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Contrato: "+SUD->UD_XCONTRA,cpCliente,cpLoja,"SUD")	
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Planilha: "+SUD->UD_XPLAN,cpCliente,cpLoja,"SUD")														
										EndIf
										dbSelectArea("SUD")
									EndIf
								
									If lAtuDoses
										cDoses := ""          
										cDoses += CValToChar(aInfo[nK][3]) +"|"
										For nL := 4 To Len(aInfo[nK])
											If nL <> Len(aInfo[nK])
												cDoses += aInfo[nK][nL][1] +";" +CValToChar(aInfo[nK][nL][2]) +";" +CValToChar(aInfo[nK][nL][3])  +"|"
											Else
												cDoses += aInfo[nK][nL][1] +";" +CValToChar(aInfo[nK][nL][2]) +";" +CValToChar(aInfo[nK][nL][3])
											EndIf
										Next nL
										SUD->UD_XDOSES := cDoses
									
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Doses: "+SUD->UD_XDOSES,cpCliente,cpLoja,"SUD")	
										EndIf
										dbSelectArea("SUD")	              
									EndIf
									
									If lAtuPA
										cUDOBS := MSMM(SUD->UD_CODEXEC)
										cUDOBS += "#PA: " +aInfo[nK][3] +" "
									    SUD->UD_XPA := aInfo[nK][3]
										MSMM(SUD->UD_CODEXEC,,,,2)           
										MSMM(SUD->UD_CODEXEC,,,cUDOBS,1,,,"SUD","UD_CODEXEC")
									
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"PA: "+aInfo[nK][3],cpCliente,cpLoja,"SUD")	
										EndIf
										dbSelectArea("SUD")
									EndIf
								
									If lAtuTabPrc
										cUDOBS := MSMM(SUD->UD_CODEXEC)
										cUDOBS += "#TABELA DE PRECO: " +aInfo[nK][3] +" "
									
										MSMM(SUD->UD_CODEXEC,,,,2)           
										MSMM(SUD->UD_CODEXEC,,,cUDOBS,1,,,"SUD","UD_CODEXEC")
										SUD->UD_XTABPRC := aInfo[nK][3]
									
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"TABELA DE PRECO - ITEM: " +aInfo[nK][1] +" -> "+SUD->UD_XTABPRC,cpCliente,cpLoja,"SUD")	
										EndIf
										dbSelectArea("SUD")
									EndIf
									
									// Lancamento tesouraria - lacres/moedas
									If lAtuTesour
										//SUD->UD_XLACRE := aInfo[nK][4] // VOLTAR QUANDO CRIAR OS CAMPOS
										//SUD->UD_XTROCO := aInfo[nK][5]
										If FindFunction("U_TTGENC01")
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"LANCAMENTO TESOURARIA - ITEM: " +aInfo[nK][1] +" -> "+SUD->UD_XNPATRI,cpCliente,cpLoja,"SUD")	
										EndIf
										dbSelectArea("SUD")
									EndIf
									
									Exit	                                                                                                                                 
								EndIf                     
							Next nK
								
							If lAgendInst
								SUD->UD_XDTINST := cDtAgend
								cUDOBS := MSMM(SUD->UD_CODEXEC)
								cUDOBS += "Data agendada: " +DToC(cDtAgend)
						
								MSMM(SUD->UD_CODEXEC,,,,2)           
								MSMM(SUD->UD_CODEXEC,,,cUDOBS,1,,,"SUD","UD_CODEXEC")
						
								If lGeraLog
									U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"AGENDAMENTO DE INSTALACAO: "+DToC(cDtAgend),cpCliente,cpLoja,"SUD")	
								EndIf                                                  
						
							ElseIf lAgendRem
								SUD->UD_XDTINST := cDtAgend
								cUDOBS := MSMM(SUD->UD_CODEXEC)
								cUDOBS += "Data agendada: " +DToC(cDtAgend)
							
								MSMM(SUD->UD_CODEXEC,,,,2)           
								MSMM(SUD->UD_CODEXEC,,,cUDOBS,1,,,"SUD","UD_CODEXEC")
							
								If lGeraLog
									U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"AGENDAMENTO DE REMOCAO: "+DToC(cDtAgend),cpCliente,cpLoja,"SUD")	
								EndIf    
							EndIf
												
							dbSelectArea("SUD")
							SUD->(MSUnLock())
						EndIf                  

						// atualizacao de POS
						If lAtuContad
							For nK := 1 To Len(aInfo)
								If SUD->UD_ITEM == aInfo[nK][1] .And. SUD->UD_XNPATRI == aInfo[nK][2]
									cNumPOS := aInfo[nK][3]
							
									cSql := "SELECT R_E_C_N_O_ REC FROM " +RetSqlName("ZZN") +" WHERE ZZN_NRSERI LIKE '%"+cNumPos+"%' AND D_E_L_E_T_ = '' "
									IIF( Select("TRBZ") > 0,TRBZ->(dbCloseArea()), )
									TcQuery cSql New Alias "TRBZ"
									dbSelectArea("TRBZ")
									dbGoTop()
									If !EOF()           
										nRecZZN := TRBZ->REC
									EndIf    
									TRBZ->(dbCloseArea())
																		
									If SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrIns
										dbSelectArea("ZZN")
										dbGoTo(nRecZZN)
										If Recno() == nRecZZN
											If RecLock("ZZN",.F.)
												ZZN->ZZN_PATRIM := SUD->UD_XNPATRI
												ZZN->ZZN_CLIENT := cpCliente
												ZZN->ZZN_LOJA := cpLoja
												ZZN->ZZN_LOCALZ := "1"
												ZZN->(MsUnLock())
											EndIf
										EndIf	                      
									ElseIf SUD->UD_ASSUNTO == cAssOMM .And. SUD->UD_OCORREN == cOcorrRem
										dbSelectArea("ZZN")
										dbGoTo(nRecZZN)
										If Recno() == nRecZZN
											If RecLock("ZZN",.F.)
												ZZN->ZZN_PATRIM := ""
												ZZN->ZZN_CLIENT := ""
												ZZN->ZZN_LOJA := ""
												ZZN->ZZN_LOCALZ := "4"
												ZZN->(MsUnLock())
											EndIf
										EndIf
									EndIf    
								EndIf	
							Next nK
							dbSelectArea("SUD")	
						EndIf
							
						/*
						ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						ณHistorico da movimentacaoณ
						ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						*/
						If lConfOper
							// funcao que busca o recno do patrimonio
							If !FindFunction("U_TTTMKA19")
								Aviso("TTTMKA04","Fun็ใo U_TTTMKA19 nใo compilada no reposit๓rio." +CRLF +"Favor informar o administrador do sistema.",{"Ok"})
								DisarmTransaction()
								Return .F.
							EndIf
							
							// funcao que altera o cadastro do patrimonio
							If !FindFunction("U_TTTMKA25")
								Aviso("TTTMKA04","Fun็ใo U_TTTMKA25 nใo compilada no reposit๓rio." +CRLF +"Favor informar o administrador do sistema.",{"Ok"})
								DisarmTransaction()
								Return .F.
							EndIf
							
							// funcao que atualiza a base instalada
							If !FindFunction("U_TTTECC05")
								Aviso("TTTMKA04","Fun็ใo U_TTTECC05 nใo compilada no reposit๓rio." +CRLF +"Favor informar o administrador do sistema.",{"Ok"})
								DisarmTransaction()
								Return .F.
							EndIf
							
							// funcao que atualiza o plano de trabalho
							If !FindFunction("U_TTOPER03")                         
								Aviso("TTTMKA04","Fun็ใo U_TTOPER03 nใo compilada no reposit๓rio." +CRLF +"Favor informar o administrador do sistema.",{"Ok"})
								DisarmTransaction()
								Return .F.
							EndIf
							
							For nL := 1 To Len(aInfo)
								If SUD->UD_ITEM == aInfo[nL][1] .And.;    	// Item
									SUD->UD_PRODUTO == aInfo[nL][2] .And.;	// Produto
									SUD->UD_ASSUNTO == cAssOMM				// Assunto
									
									If IsInCallStack("U_TTTMKA04")
										MsProcTxt("Atualizando status do patrim๔nio..")
									EndIf
								 	
								 	aAltATF := {}
								 	
								 	// Se for instalacao
								    If SUD->UD_OCORREN == cOcorrIns
										aDoses := StrToKarr(SUD->UD_XDOSES,"|")
										// verifica se eh locacao - para integracao com Gestao de Contratos - Jackson 19/02/14
										If AllTrim(SUD->UD_XTPCONT) $ "1|6|7|8"
											lLocacao := .T.
										EndIf
				
										AADD( aAltATF, { "N1_XSTATTT", "3" } )				// em cliente
										AADD( aAltATF, { "N1_XLOCINS", aInfo[nL][3] } )		// local fisico
										AADD( aAltATF, { "N1_XCLIENT", cpCliente } )		// cod cliente
										AADD( aAltATF, { "N1_XLOJA", cpLoja } )				// loja cliente
										AADD( aAltATF, { "N1_XTENSIN", aInfo[nL][4]  } )	// Tensao maquina
										AADD( aAltATF, { "N1_XPTHDL", SUD->UD_XPTHDL  } )	// Ponto hidraulico
										AADD( aAltATF, { "N1_XPLGNBR", SUD->UD_XPLGNBR  } )	// Plug NBR
										AADD( aAltATF, { "N1_XTABELA", SUD->UD_XTABPRC  } )			// Tabela preco
										AADD( aAltATF, { "N1_XPA", SUD->UD_XPA  } )			// PA
								
							            // Tratamento para Forma de pagamento
										If dDataOMM > CtoD("07/10/2013")
											cSistema := SUD->UD_XMOEDA
										Else
											cSisP := Alltrim(GetMv("MV_XTMK010"))
											cSisP += "#"+ Alltrim(GetMv("MV_XTMK011"))
											If AllTrim(cSisP) <> ""
												aSisP := strtokarr(cSisP,"#")
												If Len(aSisP) <> 0
													// ajuste para OMMs antigas - gravar a nova forma de pagamento
													cSistema := RetSisPG( aSisp[Val(SUD->UD_XMOEDA)] )
												EndIf
											EndIf 
										EndIf
										
										AADD( aAltATF, { "N1_XSISPG", cSistema  } )	// Tipo de pagamento
								            
										// Tratamento para Doses
										If Len(aDoses) > 0 .And. dDataOMM > CtoD("07/10/2013")
											nLimTroco := Val(aDoses[1])						
											For nX := 2 To Len(aDoses)
												nPosP := nX-1
												aDosesAux := StrToKarr(aDoses[nX],";")
												AADD( aAltATF, { "N1_XP"+CValToChar(nPosP), aDosesAux[1]   } )	// doses
												//SN1->&("N1_XP"+CValToChar(nPosP)) := aDosesAux[1] 
											Next nX
										EndIf                           
											
										AADD( aAltATF, { "N1_XLIMTRO", nLimTroco  } )			// limite de troco
										AADD( aAltATF, { "N1_XVOLMIN", SUD->UD_XMINIMO  } )		// minimo
										AADD( aAltATF, { "N1_XTPSERV", SUD->UD_XTPCONT  } )		// tipo do contrato/servico
										
										lOk := U_TTTMKA25(SUD->UD_XNPATRI, aAltATF)
										If !lOk
											Aviso("TTTMKA04-AtuCampos","Houve erro ao alterar o cadastro do patrim๔nio.",{"Ok"})
											DisarmTransaction()
											Return .F.
										EndIf
	
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"ATIVO FIXO ATUALIZADO - EM CLIENTE: "+SUD->UD_XNPATRI,cpCliente,cpLoja,"SN1")	
										EndIf 
										dbSelectArea("SUD")
										
									// Se for remocao
								    ElseIf SUD->UD_OCORREN == cOcorrRem .Or. SUD->UD_OCORREN == cOcorrTnf
										If "REGULARIZACAO" $ cDescTar                                
											AADD( aAltATF, { "N1_XSTATTT", "1" } )				// disponivel
										Else
											AADD( aAltATF, { "N1_XSTATTT", "4" } )				// em manutencao
										EndIf

										AADD( aAltATF, { "N1_XLOCINS", "" } )
										AADD( aAltATF, { "N1_XCLIENT", "" } )
										AADD( aAltATF, { "N1_XLOJA", "" } )
										AADD( aAltATF, { "N1_XTENSIN", ""  } )
										AADD( aAltATF, { "N1_XPTHDL", ""  } )
										AADD( aAltATF, { "N1_XPLGNBR", ""  } )
										AADD( aAltATF, { "N1_XSISPG", ""  } )
										AADD( aAltATF, { "N1_XTABELA", ""  } )
										AADD( aAltATF, { "N1_XPA", ""  } )

										// Limpa os P's
										For nX := 1 To 60								// Alterado para 60 em 06/08/2015
											AADD( aAltATF, { "N1_XP"+CValToChar(nX), ""  } )	// Tipo de pagamento
										Next nX
										
										AADD( aAltATF, { "N1_XLIMTRO", 0  } )
										AADD( aAltATF, { "N1_XVOLMIN", 0  } )
										AADD( aAltATF, { "N1_XTPSERV", ""  } )
										AADD( aAltATF, { "N1_XPLANTR", ""  } )
										
										lOk := U_TTTMKA25(SUD->UD_XNPATRI, aAltATF)
										If !lOk
											Aviso("TTTMKA04-AtuCampos","Houve erro ao alterar o cadastro do patrim๔nio.",{"Ok"})
											DisarmTransaction()
											Return .F.
										EndIf
			
										If lGeraLog
											U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"ATIVO FIXO ATUALIZADO - EM MANUTENCAO: "+SUD->UD_XNPATRI,cpCliente,cpLoja,"SN1")	
										EndIf 
										dbSelectArea("SUD")
								    EndIf
							    	If IsInCallStack("U_TTTMKA04")
										MsProcTxt("Gravando hist๓rico de movimenta็ใo de mแquina..")
									EndIf
									// Se for instalacao
									If SUD->UD_OCORREN == cOcorrIns
										dbSelectArea("SZD")
										If RecLock("SZD",.T.)
										    SZD->ZD_CLIENTE := cpCliente
										    SZD->ZD_LOJA	:= cpLoja
										    SZD->ZD_NOME	:= cNomeCli
										    SZD->ZD_PATRIMO := SUD->UD_XNPATRI
										    SZD->ZD_NROOMM	:= cNumTmk
								    	    SZD->ZD_DATAINS	:= aInfo[nL][5]
										    SZD->ZD_HORAINS	:= aInfo[nL][6]
									     	SZD->ZD_IDSTATU	:= "1"
									     	SZD->ZD_CODPA	:= SUD->UD_XPA
											SZD->(MsUnLock())
											
											If lGeraLog
												U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO INSTALADO EM "+DTOC(aInfo[nL][5]) +": " +SUD->UD_XNPATRI,cpCliente,cpLoja,"SZD")	
											EndIf 
										EndIf	
					    	            dbSelectArea("SUD")            
									// Se for remocao
								    ElseIf SUD->UD_OCORREN == cOcorrRem
								    	dbSelectArea("SZD")                                             
								    	dbSetOrder(1) //ZD_FILIAL + ZD_CLIENTE + ZD_LOJA + ZD_PATRIMO +ZD_NROOMM 
								    	If dbSeek(xFilial("SZD")+AvKey(cpCliente,"ZD_CLIENTE")+AvKey(cpLoja,"ZD_LOJA")+AvKey(SUD->UD_XNPATRI,"ZD_PATRIMO")) //+AvKey(cNumTmk,"ZD_NROOMM"))
								        	// Validacao para nao permitir data de remocao inferior a data de instalacao - Jackson 18/02/14	
								     		If aInfo[nL][5] < SZD->ZD_DATAINS
								        		Aviso( "TTTMKA04","A data de remo็ใo nใo pode ser inferior a data de instala็ใo." +CRLF +"Data de instala็ใo: " +dtoc(SZD->ZD_DATAINS) +CRLF +"Data de remo็ใo informada: " +dtoc(aInfo[nL][5]), {"Ok"} )
								        		DisarmTransaction()
								        		If FindFunction("U_TTGENC01")
													U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"A DATA DE REMOCAO NAO PODE SER INFERIOR A DATA DE INSTALACAO",cpCliente,cpLoja,"SZD")	
												EndIf 
								        		Return .F.
								        	EndIf
								        	
								        	RecLock("SZD",.F.)
											SZD->ZD_DATAREM	:= aInfo[nL][5]
										    SZD->ZD_HORAREM	:= aInfo[nL][6]
										    SZD->ZD_NROOMMR := cNumTMK
									     	SZD->ZD_IDSTATU	:= "0"
											SZD->(MsUnLock())
											
											If lGeraLog
												U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"PATRIMONIO REMOVIDO EM "+DTOC(aInfo[nL][5]) +": " +SUD->UD_XNPATRI,cpCliente,cpLoja,"SZD")	
											EndIf 
								        EndIf
										dbSelectArea("SUD")
									EndIf
									
									/*
									ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									ณInserir/Remover patrimonio - base instalada - Gestao de Servicosณ
									ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									*/
									If IsInCallStack("U_TTTMKA04")
										MsProcTxt("Atualizando base instalada..")
									EndIf
									If SUD->UD_OCORREN == cOcorrIns
										lOk := U_TTTECC05(1,cpCliente, cpLoja, SUD->UD_XNPATRI,aInfo[nL][5],SUD->UD_XCONTRA)
										If ValType(lOk) == "L"
											If !lOk
												Aviso("TTTMKA04", "Houve erro ao atualizar a base instalada." +CRLF +"Tente novamente.",{"Ok"})
												DisarmTransaction()
												Return .F.	
											EndIf
										EndIf
									ElseIf SUD->UD_OCORREN == cOcorrRem
										lOk := U_TTTECC05(2,cpCliente, cpLoja, SUD->UD_XNPATRI)
										If ValType(lOk) == "L"
											If !lOk
												Aviso("TTTMKA04", "Houve erro ao atualizar a base instalada." +CRLF +"Tente novamente.",{"Ok"})
												DisarmTransaction()
												Return .F.	
											EndIf
										EndIf	
									EndIf
					

									/*
									ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									ณAltera planilha do cliente - caso a omm seja de locacao  - Gestao de Contratosณ
									ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									*/
									If IsInCallStack("U_TTTMKA04")
										MsProcTxt("Atualizando contrato do cliente..")
									EndIf
									// instalacao
									If SUD->UD_OCORREN == cOcorrIns .And. lLocacao
										lOk := U_TTCNTA15(cNumTmk,1,SUD->UD_XCONTRA,SUD->UD_XPLAN,cpCliente,cpLoja,SUD->UD_XNPATRI,SUD->UD_XVLALUG,aInfo[nL][5],.T.)
										If ValType(lOk) == "L"
											If !lOk
												Aviso("TTTMKA04","Houve erro ao incluir o patrim๔nio no contrato do cliente."+CRLF +"Tente novamente.",{"Ok"})
												If lBlqOMMCont
													DisarmTransaction()
													If lGeraLog
														U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Houve erro ao incluir o patrim๔nio no contrato do cliente " +"PATRIMONIO: " +SUD->UD_XNPATRI,cpCliente,cpLoja,"SUD")	
													EndIf 
													Return .F.        
												EndIf
											EndIf
										EndIf
									// remocao	
									ElseIf SUD->UD_OCORREN == cOcorrRem
									 	lOk := U_TTCNTA15(cNumTmk,2,,,cpCliente,cpLoja,SUD->UD_XNPATRI,,aInfo[nL][5],.T.)
									 	If ValType(lOk) == "L"
											If !lOk
												Aviso("TTTMKA04","Houve erro ao remover o patrim๔nio do contrato do cliente."+CRLF +"Tente novamente.",{"Ok"})
												If lBlqOMMCont
													DisarmTransaction()
													If lGeraLog
														U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Houve erro ao incluir o patrim๔nio no contrato do cliente " +"PATRIMONIO: " +SUD->UD_XNPATRI,cpCliente,cpLoja,"SUD")	
													EndIf 
													Return .F.       
												EndIf
											EndIf
										EndIf
									EndIf
									
									/*
									ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									ณRemove o patrimonio do plano de trabalho na remocaoณ
									ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
									*/
							    	If SUD->UD_OCORREN == cOcorrRem
										lOk := U_TTOPER03(cpCliente, cpLoja, SUD->UD_XNPATRI)
										If ValType(lOk) == "L"                                               
											If lOk
												If lGeraLog
													U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"Patrimonio removido do plano de trabalho" +"PATRIMONIO: " +SUD->UD_XNPATRI,cpCliente,cpLoja,"SZE")	
												EndIf 
											EndIf
										EndIf
									EndIf
								EndIf			
							Next nL
						EndIf
						dbSelectArea("SUD")
						lUpd := .T.
						Exit
					EndIf
				Next nJ
			EndIf	
	  	Next nI
	Else
		// Atualiza status
		If RecLock("SUD",.F.)	
			SUD->UD_STATUS := "2"
			SUD->(MsUnLock())
		EndIf	          
	
		If SUC->UC_STATUS <> "3" .And. Empty(SUC->UC_DTENCER) .And. Empty(SUC->UC_CODENCE)
			If RecLock("SUC",.F.)
		    	SUC->UC_STATUS := "3"
		    	SUC->UC_DTENCER := Date()
		    	SUC->UC_CODENCE := cStatusFim	// finalizado
				SUC->(MsUnLock())
				/*
				ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				ณEncerra as listas de pendencias se existir alguma - SOMENTE PARA ESSE ATENDIMENTO ENCERRADO ณ
				ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				*/
				TK272DelSU4(cNumTmk)
					
				If lGeraLog
					U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"ENCERRAMENTO",cpCliente,cpLoja,"SUD")	
				EndIf 
	        EndIf            
        EndIf
  	EndIf    
  	
	If !lMailOK
		cTarget += AllTrim(UsrRetMail(SUD->UD_OPERADO))
		lMailOK := .T.
	EndIf
  	SUD->( dbSkip() ) 
End
cString := " Data de finaliza็ใo: " +cDtDia +" " +cTime +" " +cUserName +" "
	
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณAltera a observacao da OMM - utilizada nos emailsณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
// -> Se for observacao
If lAtuObs
	cString += AllTrim(cObs) +" "
	If lAgendInst
		cString += "Data de instala็ใo: " +dToC(cDtAgend) +CRLF
	ElseIf lAgendRem
		cString += "Data de remo็ใo: " +dToC(cDtAgend) +CRLF		
	EndIf
EndIf
If lAtuPatrim
	For nI := 1 To Len(aInfo)
		If nI == 1
			cString += "Patrim๔nios: "
		EndIf
		cString += aInfo[nI][3]
		If nI <> Len(aInfo)
			cString += "/"
		EndIf
	Next nI
EndIf                  
If lAtuContrato
	For nI := 1 To Len(aInfo)
		If nI == 1
			cString += "Contratos: "
		EndIf
		cString += aInfo[nI][3]
		If nI <> Len(aInfo)
			cString += "/"
		Else
			cString += CRLF
		EndIf
	Next nI	
EndIf
If lAtuContad        
	cString += "POS informados." +CRLF
EndIf
If lAtuPA
	cString += "PA do(s) produto(s) informada(s)." +CRLF
EndIf
If lAtuTabPrc
	cString += "Tabela de pre็o do(s) produto(s) informada(s). "+CRLF	
EndIf
If lAtuTesour
	cString += "Lacre/troco do(s) produto(s) informado(s). "+CRLF	
EndIf  
If lAtuPlTrab
	cString += "Plano de trabalho configurado." +CRLF
EndIf
If len(aChamIns) > 0
	For nPy := 1 to len(aChamIns)
		cString += "Chamado Call Center Instalacao/Remocao "+aChamIns[nPy,01]+" Chamado T้cnico "+aChamIns[nPy,02]+CRLF
	Next nPy
EndIf
	
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ÛAฟ
ณAltera o campo de observacaoณ
ณA tarefa atual fica OK      ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ÛAู
*/ 
RestArea(alArea)
cMsgObs := MSMM(SUC->UC_CODOBS)
aAuxMM := StrtoKarr(cMsgObs,"#")
For nX := 1 To Len(aAuxMM)
	If cSeqAtu $ aAuxMM[nX]
		aAuxMM[nX] += " " +cString +CRLF
	EndIf
	cTxtObs += "#" +aAuxMM[nX]
Next nX

// exclui/inclui o memo
MSMM(SUC->UC_CODOBS,,,,2)           
MSMM(SUC->UC_CODOBS,,,cTxtObs,1,,,"SUC","UC_CODOBS")

EndTran() //encerra transacao
DbCommitAll()
MsUnLockAll()		

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณEnvia o email para as acoes do atendimentoณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
// Prepara variaveis para montagem do corpo do email
If !FindFunction("U_TTTMKA09") .Or. !FindFunction("U_TTTMKA07") .Or. !FindFunction("U_TTMAILN")
	Aviso("TTTMKA04","Todas as fun็๕es necessแrias para envio do e-mail nใo estใo presentes no sistema." +CRLF +"O e-mail informativo nใo serแ enviado.",{"Ok"})	  
Else
	U_TTTMKA09(1,cCodFil,cNumTmk,@aCabMail,@aItens)
	If ValType(aCabMail) == "A" .And. ValType(aItens) == "A"
		If Len(aCabMail) > 0 .And. Len(aItens) > 0
			Aadd(aCabMail,cString)			// [6] Nova Observacao TMK [em VERMELHO]
			
			// Prepara o corpo do email
			U_TTTMKA07(1,aCabMail,@cArqMail,aItens,lAtuStatus)
			If IsInCallStack("U_TTTMKA04")
				MsprocTxt("Enviando E-mail para as a็๕es...")
			EndIf
			
			// Envia o email
			cRemete := SuperGetMV("MV_RELACNT",.T.,"microsiga",)
			cTarget += 	AllTrim(UsrRetMail(__cUserID)) 
			cSubject := "Ordem de Movimenta็ใo de Maquina - Nบ "+cNumTmk
			U_TTMailN(cRemete,cTarget,cSubject,cArqMail,aAttach,.F.)
		EndIf
	EndIf
EndIf
                             
RestArea(alAreaSUD)
	
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณGera o pedido de venda - CHAVE: PEDIDOณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
If lGeraPV
	If SUD->UD_OCORREN == cOcorrIns .Or. SUD->UD_OCORREN == cOcorrTnf	//Gera somente se for ocorrencia de instalacao ou transferencia
		If FindFunction("U_TTTMKA03")
			If IsInCallStack("U_TTTMKA04")
				MsprocTxt("Gerando o pedido de venda..")
			EndIf
			U_TTTMKA03()	// Funcao de geracao do pedido de venda
					
			aPedido := InfoPedido()
			If Valtype(aPedido) == "A"
				If Len(aPedido) > 0
					dbSelectArea("SUD")
					While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == cNumTmk .And. SUD->(!Eof())
						For nX := 1 To Len(aPedido)
							If SUD->UD_ITEM == aPedido[nX][1] .And. SUD->UD_PRODUTO == aPedido[nX][2] 					
								If RecLock("SUD",.F.)
									SUD->UD_VENDA := aPedido[nX][3]		// preenche o Pedido
									SUD->UD_ITEMVDA := aPedido[nX][1]	// preenche o item
									SUD->(MsUnLock())
								EndIf                                                               
								/*
								ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								ณAltera o status do patrimonio para patrimonio empenhado - CHAVE: PEDIDOณ
								ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
								*/
								dbSelectArea("SN1")
								dbSetOrder(2)	// filial + chapa
								nRecSN1 := U_TTTMKA19(SUD->UD_XNPATRI)
								If nRecSN1 > 0
									SN1->( dbGoTo(nRecSN1) )
									If RecLock("SN1",.F.)
										SN1->N1_XSTATTT := "5"	// empenhado
										SN1->(MsUnlock())
									EndIf   
								EndIf
								dbSelectArea("SUD")
							EndIf
						Next nX        
					SUD->(dbSkip())
					End
				EndIf
			EndIf

			If lGeraLog
				U_TTGENC01(xFilial("SUD"),"TTTMKA04","OMM - ATUALIZACAO","",cNumTMK,"",cusername,dtos(date()),time(),,"GERACAO DE PEDIDO DE VENDA",cpCliente,cpLoja,"SC5")	
			EndIf 		
		Else
			Aviso("TTTMKA04","Fun็ใo U_TTTMKA03 nใo compilada no reposit๓rio." +CRLF +"O pedido de venda nใo serแ gerado.",{"Ok"})
		EndIf
	EndIf
EndIf
          
RestArea(alArea)
lOk := .T.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadHead	  บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o array aHeader.										  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadHead(aCampos)

Default aCampos := {}

DbSelectArea("SX3")
DbSetOrder(1)
dbGoTop()

If cTipoTela == "CONTADORES" 	                           
	dbSetOrder(2)
	For nI := 1 To Len(aCampos)
		If dbSeek(aCampos[nI])
			AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context } ) 
		EndIf
	Next nI
	
	Return
EndIf

DbSeek("SUD")
While !EOF() .and. SX3->X3_ARQUIVO == "SUD"
	If /*X3Uso(SX3->X3_USADO) .and. */cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "UD_ITEM|UD_PRODUTO"   
	AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context } ) 
		If Alltrim(SX3->X3_CAMPO) == "UD_PRODUTO"
      		Exit
		EndIf
	EndIf
	DbSkip()
End

dbGoTop()
DbSeek("SB1")
While !EOF() .and. SX3->X3_ARQUIVO == "SB1"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "B1_DESC"
      Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO, SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context } )
      Exit
   EndIf
   DbSkip()
End

// Se for preenchimento de patrimonio, adiciona o campo do patrimonio
If cTipoTela == "PATRIMONIO"
	dbGoTop()
	DbSeek("SUD")
	While !EOF() .and. SX3->X3_ARQUIVO == "SUD"
	   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "UD_XNPATRI"
	     Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"StaticCall(TTTMKA04,VldPatr)","",SX3->X3_TIPO,"",SX3->X3_Context } )
	   EndIf
	   DbSkip()
	End
EndIf 

// Se for preenchimento de contrato, adiciona o campo contrato e planilha
If cTipoTela == "CONTRATO"
	dbGoTop()
	DbSeek("SUD")
	While !EOF() .and. SX3->X3_ARQUIVO == "SUD"
	   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "UD_XCONTRA|UD_XPLAN"
	      Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context } )
	   EndIf
	   DbSkip()
	End 
EndIf
       
// Se for preenchimento de PA, adiciona o campo PA
If cTipoTela == "PA"
	dbGoTop()
	DbSeek("SB1")
	While !EOF() .and. SX3->X3_ARQUIVO == "SB1"
	   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "B1_LOCPAD"
	      Aadd(aHeader,{"PA",SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"",SX3->X3_Context } )
	      Exit
	   EndIf
	   DbSkip()
	End 
EndIf
              
// Se for preenchimento de tabela de preco, adiciona o campo tabela de preco
If cTipoTela == "TABPRECO"
	dbGoTop()
	DbSeek("SUA")
	While !EOF() .and. SX3->X3_ARQUIVO == "SUA"
	   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .And. AllTrim(SX3->X3_CAMPO) $ "UA_TABELA"
	      Aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"","",SX3->X3_TIPO,"", SX3->X3_Context } )
	      Exit
	   EndIf
	   DbSkip()
	End 
EndIf
   
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadCols	  บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o array aCols.										  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadCols(cNumAtend,aDados)

Local cQuery

Local aAux := {}

cQuery := "SELECT SUD.UD_ITEM, SUD.UD_PRODUTO, SB1.B1_DESC, SUD.UD_XNPATRI, SUD.UD_OCORREN, " +CRLF
cQuery += "SUD.UD_XLOCFIS, SUD.UD_XVOLT " +CRLF
cQuery += "FROM " +RetSqlName("SUD") +" SUD " +CRLF

cQuery += "INNER JOIN " +RetSqlName("SB1") +" SB1 ON " +CRLF
cQuery += "SUD.UD_PRODUTO = SB1.B1_COD " +CRLF
cQuery += "AND SUD.D_E_L_E_T_ = SB1.D_E_L_E_T_ " +CRLF

cQuery += "WHERE " +CRLF
cQuery += "SUD.UD_FILIAL = '"+xFilial("SUD")+"' " +CRLF
cQuery += "AND SUD.UD_CODIGO = '"+cNumAtend+"' " +CRLF
cQuery += "AND SUD.D_E_L_E_T_ = '' " +CRLF
                                           
cQuery += "ORDER BY SUD.UD_ITEM, SUD.UD_PRODUTO "  

cQuery := ChangeQuery(cQuery)
MemoWrite("LoadCols.sql",cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf           
                       
TCQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	If cTipoTela == "PATRIMONIO"
		AADD(aDados,{TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC,SPACE(TamSX3("UD_XNPATRI")[1])})
	ElseIf cTipoTela == "CONTRATO" 
		AADD(aDados,{TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC,SPACE(TamSx3("UD_XCONTRA")[1]),Space(TamSX3("UD_XPLAN")[1])})
	ElseIf cTipoTela == "CONTADORES"				
		AADD(aDados,{TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC,TRB->UD_XNPATRI})
	ElseIf cTipoTela == "DOSES"				
		AADD(aDados,{.F.,TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC})					
	ElseIf cTipoTela == "PA" 
		AADD(aDados,{TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC,SPACE(TamSx3("ZZ1_COD")[1])})
	ElseIf cTipoTela == "TABPRECO" 
		AADD(aDados,{TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC,SPACE(TamSx3("DA0_CODTAB")[1])})				
	ElseIf cTipoTela == "CONFIRMA_OPERACAO" 
		AADD(aDados,{.F.,TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->UD_XNPATRI,AllTrim(TRB->B1_DESC),;
					AllTrim(TRB->UD_XLOCFIS),If(TRB->UD_XVOLT=="1","110v","220v"),CtoD(space(8)),Space(8)})	
	ElseIf cTipoTela == "TESOURARIA"				 
		AADD(aDados,{.F.,TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->UD_XNPATRI,AllTrim(TRB->B1_DESC) })
	ElseIf cTipoTela == "PLTRAB"
		AADD( aDados,{.F.,TRB->UD_ITEM,TRB->UD_PRODUTO,TRB->B1_DESC,TRB->UD_XNPATRI} )	
	EndIf
	
	dbSkip()  
End While
TRB->(dbCloseArea())

If !cTipoTela $ "DOSES|CONFIRMA_OPERACAO|TESOURARIA|PLTRAB"
	For nI := 1 To Len(aDados)
		AAdd(aCols, Array(Len(aHeader)+1))
		nLin := Len(aCols)
		For nCol := 1 To Len(aHeader)
			If cTipoTela == "CONTADORES"
				If nCol <= 4
					aCols[nLin][nCol] := aDados[nI][nCol]
				Else
					aCols[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
				EndIf
			Else
				If aHeader[nCol][10] == "R"
					aCols[nLin][nCol] := aDados[nI][nCol]
				Else
					aCols[nLin][nCol] := CriaVar(aHeader[nCol][2], .T.)
				EndIf
			EndIf	
		Next nCol                 
		// inicializa a ultima coluna para o controle da getdados: deletado ou nao
		aCols[nLin][Len(aHeader)+1] := .F.	
	Next nI
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInfoPedido  บAutor  ณJackson E. de Deus  บ Data ณ  06/06/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca informacoes do pedido gerado.						  บฑฑ
ฑฑบ          ณ				                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InfoPedido()

Local cQuery := ""
Local aDados := {}
Local cMenNota := ""
Local aArea := GetArea()
Local dToday 
                
dToday := GRAVADATA(dToday,.F.,8)

// Prepara o filtro da mensagem da nota - buscar somente os patrimonios da OMM
dbSelectArea("SUD")                                 						
While SUD->UD_FILIAL == SUC->UC_FILIAL .And. SUD->UD_CODIGO == SUC->UC_CODIGO .And. SUD->(!Eof())
	If AllTrim(SUD->UD_XNPATRI) <> ""
		cMenNota += " AND SC5.C5_MENNOTA LIKE '%"+SUD->UD_XNPATRI+"%' "
	EndIf
	SUD->(dbSkip())
End

cQuery := "SELECT C6_ITEM, C6_PRODUTO, C5_NUM, C5_CLIENTE, C5_LOJACLI, C5_XHRINC "			+CRLF
cQuery += "FROM " +RetSqlName("SC5") +" SC5 " 												+CRLF

cQuery += "INNER JOIN " +RetSqlName("SC6") +" SC6 ON "										+CRLF
cQuery += "SC5.C5_FILIAL 		= SC6.C6_FILIAL "											+CRLF
cQuery += "AND SC5.C5_CLIENTE	= SC6.C6_CLI "												+CRLF
cQuery += "AND SC5.C5_LOJACLI	= SC6.C6_LOJA "												+CRLF
cQuery += "AND SC5.C5_NUM		= SC6.C6_NUM "												+CRLF
cQuery += "AND SC5.D_E_L_E_T_	= SC6.D_E_L_E_T_ "											+CRLF

cQuery += "WHERE "																			+CRLF
cQuery += "SC5.C5_CLIENTE		= '"+cpCliente+"' "		 									+CRLF
cQuery += "AND SC5.C5_LOJACLI	= '"+cpLoja+"' "											+CRLF
cQuery += "AND SC5.C5_FILIAL	= '"+SUC->UC_FILIAL+"' "									+CRLF                          	
cQuery += "AND SC5.C5_EMISSAO	= '"+dToday+"' "											+CRLF 
cQuery += "AND SC5.C5_XNOMUSR	= '"+cUserName+"' "											+CRLF
cQuery += "AND SC5.C5_MENNOTA	LIKE '%Patrimonio%' "										+CRLF

If AllTrim(cMenNota) <> ""
	cQuery += cMenNota																		+CRLF
EndIf

cQuery += " AND SC5.D_E_L_E_T_	= '' "														+CRLF
cQuery += "ORDER BY C6_ITEM, C6_PRODUTO " +CRLF
cQuery := ChangeQuery(cQuery)

MemoWrite("OMMPED.SQL",cQuery)
If Select("TRBPED") > 0
	TRBPED->(dbCloseArea())
EndIf
                          
TcQuery cQuery New Alias "TRBPED"

dbSelectArea("TRBPED")
While !EOF()
	AADD(aDados, {TRBPED->C6_ITEM,TRBPED->C6_PRODUTO,TRBPED->C5_NUM,TRBPED->C5_XHRINC})
	TRBPED->(dbSkip())
End
TRBPED->(dbCloseArea())

RestArea(aArea)

Return aDados		 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA04  บAutor  ณAlexandre Venancio  บ Data ณ  07/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para trazer o proximo responsavel de acordo com o   บฑฑ
ฑฑบ          ณestado de destino da omm, para tarefas de filiais.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Operad(cChave)

Local aArea	:=	GetArea()
Local cOperador	:=	""
Local cEst := ""

If AllTrim(SUD->UD_SOLUCAO) == "000188"
	If AllTrim(SM0->M0_CODFIL) == "01"
		cEst := Posicione("SA1",1,xFilial("SA1")+cChave,"A1_EST")
	Else 
        cEst := SM0->M0_ESTCOB
	EndIf
	PswOrder(2)
	If PswSeek(cEst,.t.)
		cOperador := PswID()
	Endif	
EndIf

RestArea(aArea)

Return(cOperador)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTK272DelSU4  บAutorณVendas Clientes    บ Data ณ  28/03/02   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณApaga a lista de pendencia gerada pelo atendimento          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTeleMarketing                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณExpC1 - Codigo da lista                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TK272DelSU4(cCodLig)
Local aArea := GetArea()		//Salva a area atual

DbSelectArea("SU4")
DbSetOrder(4) 					// Pesquisar pela descricao temporariamente.
If DbSeek(xFilial("SU4")+cCodLig)
	RecLock("SU4",.F.)	
	Replace SU4->U4_STATUS With "2"      	// Status da Lista 1=Pendente 2=Encerrada      
	MsUnlock()
	
	DbSelectArea("SU6")
	DbSetOrder(1)
	If DbSeek(xFilial("SU6")+SU4->U4_LISTA)
		RecLock("SU6",.F.)
		Replace SU6->U6_STATUS With	"2"		//1=Nao Enviado 2=Enviado
		MsUnlock()
	Endif
	
	DbCommit()
Endif

RestArea(aArea)

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkOMMRem บAutor  ณJackson E. de Deus  บ Data ณ  29/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica existencia dos patrimonios em outra OMM aberta.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkOMMRem(aPatrimonio,cpCliente,cpLoja)

Local cPatrim := ""
Local cQuery := ""
Local cMsgAux := ""
Local aAux := {}

For nX := 1 To Len(aPatrimonio)
	If nX <> Len(aPatrimonio)
		cPatrim += aPatrimonio[nX][1] +"','"
	Else                             
		cPatrim += aPatrimonio[nX][1]
	EndIf
Next nX

cQuery := "SELECT UD_XNPATRI,UD_CODIGO, UC_CHAVE, UC_ENTIDAD "
cQuery += "FROM " +RetSqlName("SUD") + " SUD "

cQuery += "INNER JOIN " +RetSqlName("SUC") + " SUC ON "
cQuery += "SUD.UD_FILIAL = SUC.UC_FILIAL "
cQuery += "AND SUD.UD_CODIGO = SUC.UC_CODIGO "
cQuery += "AND SUD.D_E_L_E_T_ = SUC.D_E_L_E_T_ "

cQuery += "WHERE "
cQuery += "SUD.UD_FILIAL = '"+xFilial("SUD")+"' "
cQuery += "AND SUD.UD_ASSUNTO = '"+cAssOMM+"' "
cQuery += "AND SUD.UD_OCORREN = '"+cOcorrREm+"' "
cQuery += "AND SUD.UD_XNPATRI IN ('"+cPatrim+"') "
cQuery += "AND SUD.UD_CODIGO <> '"+cNumAtend+"' "
cQuery += "AND SUD.D_E_L_E_T_ = '' "
//cQuery += "AND SUD.UD_STATUS = '1' "
cQuery += "AND SUC.UC_STATUS <> '3' "
cQuery += "AND SUC.UC_CODCANC = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                   

tcquery cQuery new alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	AADD(aAux, {TRB->UD_XNPATRI,TRB->UD_CODIGO,SubStr(TRB->UC_CHAVE,1,6),SubStr(TRB->UC_CHAVE,7)})
	dbSkip()
End

If Len(aAux) >0
	cMsgAux := "PROBLEMA" +CRLF
	cMsgAux += "Jแ existe OMM de remo็ใo em aberto contendo algum dos patrim๔nios informados." +CRLF +CRLF

	For nX := 1 To Len(aAux)                                            
		cMsgAux += "OMM: " +aAux[nX][2] + " - Cliente: " +AllTrim(aAux[nX][3]) +"/" +AllTrim(aAux[nX][4]) +" - " +AllTrim(Posicione("SA1",1,xFilial("SA1")+aAux[nX][3]+aAux[nX][4],"A1_NREDUZ"))  +CRLF
		cMsgAux += "Patrim๔nio: " +aAux[nX][1] +CRLF 
	Next nX
	cMsgAux += "-> Nใo pode existir mais de uma OMM de remo็ใo para o mesmo patrim๔nio." +CRLF +"-> Uma deve ser cancelada." +CRLF +CRLF +CRLF
	Aviso("TTTMKA04",cMsgAux,{"Ok"})
	Return .F.
EndIf

Return .T.      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณStatusSZD  บAutor  ณJackson E. de Deus บ Data ณ  29/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica existencia de instalacao do patrimonio na remocao. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StatusSZD(aPatrimonio,cpCliente,cpLoja,nTipo)
        
Local cQuery := ""
Local aAux := {}
Local cPatrim := ""
Local nCont := 0
Local nREs := 0
Local nX
Local nY      
Local cMsgSZD := ""
Local lProblema := .F.
Local aSZD := {}
Local lInstall := .F.
Local lRemove := .F.
Default ntipo := 1		// instalacao - remocao

If nTipo == 1
	lInstall := .T.
ElseIf nTipo == 2
	lRemove := .T.
EndIf	

For nX := 1 To Len(aPatrimonio)
	If nX <> Len(aPatrimonio)
		cPatrim += aPatrimonio[nX][1] +"','"
	Else                             
		cPatrim += aPatrimonio[nX][1]
	EndIf
Next nX

cQuery := "SELECT * FROM " +RetSqlName("SZD") +" SZD "
cQuery += "WHERE ZD_CLIENTE = '"+cpCliente+"' AND ZD_LOJA = '"+cpLoja+"' "
cQuery += "AND ZD_PATRIMO IN ('"+cpatrim+"') AND D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

tcquery cQuery new alias "TRB"

dbSelectArea("TRB") 
dbGotop()
While !EOF()
	AADD(aSZD, {TRB->ZD_CLIENTE,TRB->ZD_LOJA,TRB->ZD_NROOMM,TRB->ZD_PATRIMO,TRB->ZD_DATAINS,TRB->ZD_HORAINS,TRB->ZD_DATAREM,TRB->ZD_HORAREM,TRB->ZD_IDSTATU,TRB->R_E_C_N_O_})
	dbSkip()
End										    	

// Na tarefa de informar os patrimonios
// Na instalacao - verifica se ja existe instalacao do patrimonio ainda ativa na SZD
// Na remocao - verifica falta de registro de instalacao na SZD   
If lAtuPatrim                            
	For nX := 1 To Len(aPatrimonio)
		nRes := AScan(aSZD, { |x| x[4] == aPatrimonio[nX][1] .And. AllTrim(x[9]) == "1" .And. AllTrim(x[7]) == ""   } )
		If lInstall
			If nRes > 0
				AADD(aAux, aPatrimonio[nX][1])
			EndIf
		ElseIf lRemove
			If nRes == 0
				AADD(aAux, aPatrimonio[nX][1])
			EndIf
		EndIF
	Next nX
    
	If Len(aAux) > 0
		// instalacao
		If lInstall
			cMsgSZD += "PROBLEMA" +CRLF
			cMsgSZD += "Existe(m) patrim๔nio(s) jแ instalado(s) nesse esse cliente/loja." +CRLF
			For nX := 1 To Len(aAux)
				cMsgSZD += "Patrim๔nio: " +AllTrim(aAux[nX]) +CRLF
			Next nX
			cMsgSZD += "SOLUวรO" +CRLF
			cMsgSZD += "Regularizar o(s) patrim๔nio(s)." +CRLF
			
			Aviso("TTTMKA04",cMsgSZD,{"Ok"})
			Return .F.
		
		// remocao
		ElseIf lRemove
			cMsgSZD += "PROBLEMA" +CRLF
			cMsgSZD += "Existe(m) patrim๔nio(s) sem hist๓rico de instala็ใo para esse cliente/loja." +CRLF
			For nX := 1 To Len(aAux)
				cMsgSZD += "Patrim๔nio: " +AllTrim(aAux[nX]) +CRLF
			Next nX
			cMsgSZD += "SOLUวรO" +CRLF
			cMsgSZD += "Regularizar o(s) patrim๔nio(s)." +CRLF

			Aviso("TTTMKA04",cMsgSZD,{"Ok"})
			Return .F.
		EndIf	
	EndIf
EndIf

// Na efetivacao da instalacao/remocao
// Na instalacao - verifica se ja existe instalacao do patrimonio - nao deve existir
// Verifica existencia de registro de instalacao na SZD - deve existir somente UM, caso contrario ้ INCONSISTENCIA
If lConfOper  
	// instalacao
	If lInstall
		For nX := 1 To Len(aPatrimonio)
			nRes := AScan(aSZD, { |x| x[4] == aPatrimonio[nX][1] .And. AllTrim(x[9]) == "1" .And. AllTrim(x[7]) == ""   } )
			If nRes > 0
				AADD(aAux, aPatrimonio[nx][1])
			EndIf
		Next nX
		
		If Len(aAux) > 0
			cMsgSZD += "PROBLEMA" +CRLF
			cMsgSZD += "Existe(m) patrim๔nio(s) jแ instalado(s) nesse esse cliente/loja." +CRLF
			For nX := 1 To Len(aAux)
				cMsgSZD += "Patrim๔nio: " +AllTrim(aAux[nX]) +CRLF
			Next nX
			cMsgSZD += "SOLUวรO" +CRLF
			cMsgSZD += "Regularizar o(s) patrim๔nio(s)." +CRLF
			
			Aviso("TTTMKA04",cMsgSZD,{"Ok"})
			Return .F.
		EndIf         
	
	// remocao
	ElseIf lRemove
		//verifica existencia de mais de um registro de instalacao do patrimonio no cliente/loja
		For nX := 1 To Len(aPatrimonio)
			For nY := 1 To Len(aSZD)                                                   
				//patrimonio ativo e sem data de remocao
				If aPatrimonio[nX][1] == aSZD[nY][4] .And.  AllTrim(aSZD[nY][9]) == "1" .And. AllTrim(DtoS(CtoD(aSZD[nY][7]))) == ""
					nCont++
				EndIf
			Next nY        
			AADD(aPatrimonio[nX],nCont)   
			nCont := 0	                 
		Next nX
		
		For nX := 1 To Len(aPatrimonio)
			If aPatrimonio[nX][2] == 0
				AADD(aAux, {aPatrimonio[nX][1], "Sem registro de instala็ใo"})
				lProblema := .T.
			ElseIf aPatrimonio[nX][2] == 1
				AADD(aAux, {aPatrimonio[nX][1], "Patrim๔nio Ok"})
			Else 	                                             
				AADD(aAux, {aPatrimonio[nX][1], "Mais de uma instala็ใo aguardando remo็ใo"})
				lProblema := .T.
			EndIf
		Next nX
	
		If !lProblema
			Return .T.
		Else
			cMsgSZD := "PROBLEMA" +CRLF
			cMsgSZD += "Existe inconsist๊ncia no hist๓rico de movimenta็ใo de mแquinas." +CRLF
			cMsgSZD += "Problemas que podem ocorrer:" +CRLF                                             
	 		cMsgSZD += "1. Inexist๊ncia de instala็ใo." +CRLF
	 		cMsgSZD += "2. Exist๊ncia de mais de uma instala็ใo sem a devida finaliza็ใo." +CRLF +CRLF
		
			For nX := 1 To Len(aAux)
				cMsgSZD += "Patrim๔nio: " +AllTrim(aAux[nX][1]) +" -> " +aAux[nX][2] +CRLF
			Next nX
			
			cMsgSZD += CRLF
			
			cMsgSZD += "SOLUวรO" +CRLF
			cMsgSZD += "1. Inexist๊ncia de instala็ใo:" +CRLF
			cMsgSZD += "Criar uma OMM de regulariza็ใo (instala็ใo) para o cliente/loja e patrim๔nio(s)." +CRLF +"Ap๓s o encerramento, retornar para essa OMM de remo็ใo." +CRLF +CRLF
			cMsgSZD += "2. Exist๊ncia de mais de uma instala็ใo sem a devida finaliza็ใo:" +CRLF
			cMsgSZD += "Verificar com o Depto de Processamento qual a correta data de instala็ใo do(s) patrim๔nios para o ajuste." +CRLF
			
			Aviso("TTTMKA04",cMsgSZD,{"Ok"})
			If FindFunction("U_TTTMKA17")
				U_TTTMKA17(aSZD)	//Mostra tela com os registros desse patrimonio no cliente
				Return .F.	                 
			EndIf
		EndIf
	EndIf	
EndIf
  						
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetSisPG  บAutor  ณJackson E. de Deus  บ Data ณ  03/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento para OMM antiga - sistema de pagamento           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetSisPG(cTipo)

Local cSistema := ""

If AllTrim(cTipo) == "Cedulas e Moedas"
	cSistema := "CE=1|MC=0|MS=1|VR=0|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas, Moedas e POS(visa vale)"
	cSistema := "CE=1|MC=0|MS=1|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas, Moedas e POS(ticket)"
	cSistema := "CE=1|MC=0|MS=1|VR=1|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas, Moedas e Smart"
	cSistema := "CE=1|MC=0|MS=1|VR=0|SM=1|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Moedas e Smart"
	cSistema := "CE=0|MC=0|MS=1|VR=0|SM=1|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas e Smart"
	cSistema := "CE=1|MC=0|MS=1|VR=0|SM=1|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Free"
	cSistema := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Moedas"
	cSistema := "CE=0|MC=0|MS=1|VR=0|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas"
	cSistema := "CE=1|MC=0|MS=0|VR=0|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Moedas e POS(visa vale)"
	cSistema := "CE=0|MC=0|MS=1|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Moedas e POS(ticket)"
	cSistema := "CE=0|MC=0|MS=1|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas e POS(visa vale)"
	cSistema := "CE=1|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedulas e POS(ticket)"
	cSistema := "CE=1|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Leitor Smart"
	cSistema := "CE=0|MC=0|MS=0|VR=0|SM=1|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Indutivo"
	cSistema := "CE=0|MC=0|MS=0|VR=1|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "INDUTIVO COM MOEDA" 
	cSistema := "CE=0|MC=0|MS=0|VR=1|SM=0|PO=0|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "POS Debito"         
	cSistema := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "POS Sodexo"         
	cSistema := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "POS ELO"            
	cSistema := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Moeda e POS Sodexo" 
	cSistema := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Moeda e POS Elo"    
	cSistema := "CE=0|MC=0|MS=1|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedula e POS Sodexo"
	cSistema := "CE=1|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
ElseIf AllTrim(cTipo) == "Cedula e POS Elo"   
	cSistema := "CE=1|MC=0|MS=0|VR=0|SM=0|PO=1|CI=0|CA=0"
EndIf
               
Return cSistema