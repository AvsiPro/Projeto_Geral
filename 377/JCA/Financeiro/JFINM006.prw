
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"

/*
    Programa que gera os movimentos em lote na rotina de concilialção bancária
	Este programa é chamado através do ponto de entrada F473VIEW.prw
    02-MIT 44 FINANCEIRO FIN006 - Conciliacao Automatica - inclusao de tarifas em massa
    https://docs.google.com/document/d/1nkTlKsGJ1tOAhvsvDDAPpwq4RHwnh0lQ/edit
*/

User Function JFINM006()

	Local   nOpc       := 0
	Local 	nX 			:= 0
	Local   aDesc      := "Este programa irá efetivar os movimentos em lote."+chr(13)+"Informe as 3 primieras letras dos históricos desejados."+chr(13)+"Separando por ponto e virula, para mais de uma opção. EX: TAR;REN "
	Local 	cHist	:=	""
	PRIVATE 	cBanco	:= MV_PAR01
	PRIVATE aHist	:= {}
	PRIVATE Exec       := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	PRIVATE cPerg	   := "JCAFIN01"
	Private _lBcoCorrespondente := .f.

	ValPerg()

	dbSelectArea("SIG")

	nOpc := Aviso("Efetivação em lote",aDesc,{"Sim","Nao"})

	IF nOpc == 2
		Return
	ENDIF

	If !Pergunte (cPerg,.t.)
		Return
	Endif

	aHist := Separa(alltrim(MV_PAR01),";",.T.)

	FOR nX := 1 TO len(aHist)
		cHist += alltrim(UPPER(aHist[nX]))
	NEXT nX
	//Devolvo o valor inicial de MV_PAR01
	MV_PAR01 := cBanco

	If nOpc == 1

		cIndexName := Criatrab(Nil,.F.)

		cIndexKey  := "IG_FILIAL+IG_IDPROC+IG_ITEM"

		cFilter    := " IG_IDPROC == '"+SIF->IF_IDPROC+"' .AND. IG_STATUS == '1' .AND. IG_CARTER == '2' .AND. SUBSTRING(ALLTRIM(IG_HISTEXT),1,3)$('"+ cHist +"') "//.AND. IG_EFETIVA == ''"

		IndRegua("SIG", cIndexName, cIndexKey,, cFilter, "Aguarde, selecionando registros....")

		DbSelectArea("SIG")

		cMarca := GetMark( )

		dbGoTop()
		do while !eof()
			reclock('SIG',.f.)
			replace IG_XOK with cMarca
			msunlock()
			dbSkip()
		enddo

		dbGoTop()

		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Movimentos"
		oMark:=MsSelect():New("SIG","IG_XOK",,,,cMarca,{02,1,170,350})
		oMark:oBrowse:lhasMark := .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := {|| Inverte(cMarca,@oMark)}

		@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
		ACTIVATE DIALOG oDlg CENTERED

		If Exec
			Processa({|lEnd|EFETIVA()})  //Executa movimento financeiro a pagar e atualiza SIG
		Endif

		//		DbSelectArea("SIG")
		//		RetIndex("SIG")

		//		FErase(cIndexName+OrdBagExt())
	Endif

Return Nil


static function EFETIVA()

	Local nAt := 0
	Local aPergs   := {}
	Local aDados    := {}
	PRIVATE cNatur := space(12)
	Private aLstAux := {}
	Private aEfetiv := {}
	Private lP := .F.
	Private lAp := .F.
	Private lPed := .F.
	Private lApB := .F.
	Private lApC := .F.
	Private aAlcada := {}
	Private lMsErroAuto := .F.

	aAdd(aPergs, {1, "Natureza",  cNatur,  "", ".T.", "SED", ".T.", 80,  .F.})

	If ParamBox(aPergs, "Informe a natureza para movimento bancário")
		cNatur := MV_PAR01
		//atualizo MV_PAR01 com seu conteudo inicial
		MV_PAR01 := cBanco
	ENDIF

	nRec := reccount()

	DbSelectArea("SIG")
	dbGoTop()
	ProcRegua(nRec)
	Do While !EOF()
		IF !Empty(IG_XOK)
			aLstAux := {IG_IDPROC,IG_ITEM,IG_VLREXT,IG_DTEXTR,IG_HISTEXT,IG_AGEEXT,IG_CONEXT,IG_DOCEXT,IG_SEQMOV}
			aAdd(aEfetiv,aLstAux  )//,TRB->TMP_VLNF,TRB->TMP_VLICMR,TRB->TMP_EMIS})
			lAp := .T.
		Endif

		DbSkip()
	Enddo
	
	SIG->(DbCloseArea())

	IF lAP
		For nAt := 1 to len(aEfetiv)
			lP := .F.
			//MOVIMENTO BANCÁRIO
			nOperacao := 3 //3=Inclusão de Movimento "Pagar"
			IF nAt == 1
				cNatur   := PadR(alltrim(cNatur)   , TamSx3("E5_NATUREZ")[1])
				cBanco      := PadR(cBanco      , TamSx3("A6_COD"    )[1])
				cAgencia    := PadR(MV_PAR02    , TamSx3("A6_AGENCIA")[1])
				cConta      := PadR(MV_PAR03      , TamSx3("A6_NUMCON" )[1])
			ENDIF
			dDataMov := aEfetiv[nAt,4]
			cHist := ALLTRIM(aEfetiv[nAt,5])

			//Necessário estar posicionado na SA6 no indice 1 por causa da ExecAuto FINA100
			SA6->(DbSetOrder(1)) //A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
			If SA6->(DbSeek( xFilial("SA6") + cBanco + cAgencia + cConta ))	.Or. SA6->(DbSeek( xFilial("SA6") + cBanco ))
				aDados := {}
				aAdd( aDados, {"E5_DATA"    , dDataMov  , NIL} )
				aAdd( aDados, {"E5_DTDIGIT" , dDataBase  , NIL} )
				aAdd( aDados, {"E5_DTDISPO" , dDataMov  , NIL} )
				aAdd( aDados, {"E5_VENCTO" , dDataMov  , NIL} )
				aAdd( aDados, {"E5_VALOR"   , aEfetiv[nAt,3]    , NIL} )
				aAdd( aDados, {"E5_NATUREZ" , cNatur , NIL} )
				aAdd( aDados, {"E5_MOEDA"   , "M1"      , NIL} )
				aAdd( aDados, {"E5_RECPAG"   , "P"      , NIL} )
				aAdd( aDados, {"E5_HISTOR"  , cHist  , NIL} )
				aAdd( aDados, {"E5_RATEIO"  , "N"   , NIL} )
				aAdd( aDados, {"E5_RECONC"  , "x"   , NIL} )
				aAdd( aDados, {"E5_SEQCON"   , ALLTRIM(aEfetiv[nAt,9])    , NIL} )
				aAdd( aDados, {"E5_BANCO"   , cBanco    , NIL} )
				aAdd( aDados, {"E5_AGENCIA" , cAgencia  , NIL} )
				aAdd( aDados, {"E5_CONTA"   , cConta    , NIL} )

				//Efetua a inclusão do movimento a pagar via Rotina Automática FINA100 (Movimentos Bancários)
				MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aDados, nOperacao )
				If lMsErroAuto
					cMsgErro:= MostraErro("\")
					cMsgErro := "Erro de Inclusao na Rotina Automatica FINA100:" + Chr(13) + cMsgErro
					Conout(cMsgErro)
					lRet := .F.
				ELSE
					//ATUALIZA SIG
					//IG_FILIAL+IG_IDPROC+IG_ITEM
					DbSelectArea('SIG')
					DbSetOrder(1)
					If Dbseek(xFilial('SIG') + alltrim(aEfetiv[nAt,1]) + alltrim(aEfetiv[nAt,2]))
						RecLock('SIG',.F.)
						SIG->IG_DTMOVI	:= dDataMov
						SIG->IG_AGEMOV	:= cAgencia
						SIG->IG_CONMOV	:= cConta
						SIG->IG_STATUS	:= "4"
						SIG->IG_HISMOV	:= cHist
						SIG->IG_NATMOV	:= cNatur
						SIG->IG_EFETIVA	:= "1"
						SIG->IG_VLRMOV  := aEfetiv[nAt,3]
						SIG->(MsUnLock())
					ENDIF
				ENDIF
			ENDIF
		Next nAt

		FWAlertSuccess("Movimentos realizados.", "Conciliação concluída.")
	else
		FWAlertError("Marque ao menos um item para conciliar", "Erro na conciliação")
	endIf

	SIG->(DbCloseArea())

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ ValidaPergunta()                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValPerg()

	LOCAL _sAlias := Alias()
	LOCAL aRegs := {}
	LOCAL i,j
	dbSelectArea("SX1")
	dbSetorder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","Historico:  "			,"","","MV_CH1" ,"C",15,0,0,"G","","MV_PAR01","","","","" ,"","","","","" ,"","","","","" ,"","","","","" ,"","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			SX1->( MsUnlock() )
		EndIf
	Next
	dbSelectArea(_sAlias)

Return Nil

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  		 ¦ Autor ¦ Datamanager           ¦ Data ¦          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotinas Genericas                                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function Inverte(cMarca,oMark)

	Local nReg := SIG->(Recno())
	dbSelectArea("SIG")
	dbGoTop()
	While !Eof()
		RecLock("SIG")
		IF IG_XOK == cMarca
			SIG->IG_XOK := "  "
		Else
			SIG->IG_XOK := cMarca
		Endif
		dbSkip()
	Enddo
	SIG->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)

Return Nil

