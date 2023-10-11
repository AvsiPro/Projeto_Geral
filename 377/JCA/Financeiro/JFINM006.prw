
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"

/*
    Programa que gera os movimentos em lote na rotina de concilial็ใo bancแria
	Este programa ้ chamado atrav้s do ponto de entrada F473VIEW.prw
    02-MIT 44 FINANCEIRO FIN006 - Conciliacao Automatica - inclusao de tarifas em massa
    https://docs.google.com/document/d/1nkTlKsGJ1tOAhvsvDDAPpwq4RHwnh0lQ/edit
*/

User Function JFINM006()

	Local   nOpc       := 0
	Local 	nX 			:= 0
	Local   aDesc      := "Este programa irแ efetivar os movimentos em lote."+chr(13)+"Informe as 3 primieras letras dos hist๓ricos desejados."+chr(13)+"Separando por ponto e virula, para mais de uma op็ใo. EX: TAR;REN "
	PRIVATE	cHist	:=	""

	PRIVATE 	cBanco	:= ''
	PRIVATE aHist	:= {}
	PRIVATE Exec       := .F.
	PRIVATE cIndexName := ''
	PRIVATE cIndexKey  := ''
	PRIVATE cFilter    := ''
	PRIVATE cPerg	   := "JCAFIN01"
	Private _lBcoCorrespondente := .f.

	If Empty(FunName())
		RpcSetType(3)
		RpcSetEnv('01','00020087')
	EndIf

	nOpc := Aviso("Efetiva็ใo em lote",aDesc,{"Sim","Nao"})

	aPergs   := {}

	aAdd(aPergs, {1, "Hist๓rico",  space(100),  "",             ".T.",        "", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Banco", Space(TamSx3('A6_COD')[1]),  "",             ".T.",        "SA6", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Agencia", Space(TamSx3('A6_AGENCIA')[1]),  "",             ".T.",        "", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Conta", Space(TamSx3('A6_NUMCON')[1]),  "",             ".T.",        "", ".T.", 80,  .T.})
	aAdd(aPergs, {1, "Data De",  CTOD('  /  /  '),  "",             ".T.",        "",    ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data Ate",  CTOD('  /  /  '),  "",             ".T.",        "",    ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Natureza",  space(12),  "", ".T.", "SED", ".T.", 80,  .F.})

	If !ParamBox(aPergs, "Informe os parโmetros")
		Return
	EndIf

	aHist := Separa(alltrim(MV_PAR01),";",.T.)
	cBanco	:= MV_PAR02
	cNatur  := MV_PAR07

	FOR nX := 1 TO len(aHist)
		cHist += alltrim(UPPER(aHist[nX]))
	NEXT nX

	If nOpc == 1

		fSeleSIF()

		lSIF :=.f.

		TTRB1->(DbGoTop())
		while !TTRB1->(Eof())
			IF !Empty(TTRB1->IF_XOK)
				IF !lSIF
					cProcesso := TTRB1->IF_IDPROC
					lSIF := .T.
				ELSE
					cProcesso += ","+TTRB1->IF_IDPROC
				ENDIF
			ENDIF
			TTRB1->(DbSkip())
		EndDo

		IF Select('TTRB') > 0
			dbSelectArea('TTRB')
			dbCloseArea()
		ENDIF

		cMarca := GetMark( )
		_stru   := SIG->(DbStruct())

		cArq:=Criatrab(_stru,.T.)

		DBUSEAREA(.t.,,carq,"TTRB") //Alimenta o arquivo de apoio com os registros do cadastro de clientes (SA1)

		cQuery := " SELECT * FROM "+RetSqlName("SIG")+" "
		cQuery += " WHERE D_E_L_E_T_ = ' ' "
		cQuery += " AND IG_BCOEXT = '"+MV_PAR02+"' "
		cQuery += " AND IG_AGEEXT = '"+MV_PAR03+"' "
		cQuery += " AND IG_CONEXT = '"+MV_PAR04+"' "
		cQuery += " AND IG_DTEXTR BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
		cQuery += " AND IG_IDPROC IN ("+cProcesso+") "
		cQuery += " AND IG_STATUS = '1' "
		cQuery += " AND IG_CARTER = '2' "

		cAliasTMP := GetNextAlias()
		MPSysOpenQuery(cQuery, cAliasTMP)

		While (cAliasTMP)->(!EoF())
			if SUBSTRING(ALLTRIM((cAliasTMP)->IG_HISTEXT),1,3) $ cHist

				RecLock("TTRB",.T.)
				TTRB->IG_XOK 	:= cMarca
				TTRB->IG_IDPROC := (cAliasTMP)->IG_IDPROC
				TTRB->IG_ITEM   := (cAliasTMP)->IG_ITEM
				TTRB->IG_VLREXT := (cAliasTMP)->IG_VLREXT
				TTRB->IG_DTEXTR := SToD((cAliasTMP)->IG_DTEXTR)
				TTRB->IG_HISTEXT:= (cAliasTMP)->IG_HISTEXT
				TTRB->IG_AGEEXT := (cAliasTMP)->IG_AGEEXT
				TTRB->IG_CONEXT := (cAliasTMP)->IG_CONEXT
				TTRB->IG_DOCEXT := (cAliasTMP)->IG_DOCEXT
				TTRB->IG_SEQMOV := (cAliasTMP)->IG_SEQMOV
				TTRB->(MsUnlock())

			EndIf

			(cAliasTMP)->(DbSkip())
		EndDo

		(cAliasTMP)->(DbCloseArea())

		DbSelectArea('TTRB')
		TTRB->(dbGoTop())

		aCpoBro := {;
			{ "IG_XOK" ,, "Mark" ,"@!"},;
			{ "IG_ITEM" ,, "Item" ,"@!"},;
			{ "IG_VLREXT" ,, "Valor" ,"@E 999,999,999.99"},;
			{ "IG_DTEXTR" ,, "Data" ,"@!"},;
			{ "IG_HISTEXT" ,, "Hist๓rico" ,"@!"},;
			{ "IG_AGEEXT" ,, "Agencia" ,"@!"},;
			{ "IG_CONEXT" ,, "Conta" ,"@!"},;
			{ "IG_DOCEXT" ,, "Documento" ,"@!"};
			}

		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Movimentos"
		oMark:=MsSelect():New("TTRB","IG_XOK",,aCpoBro,,cMarca,{02,1,170,350})
		oMark:oBrowse:lhasMark := .t.
		oMark:oBrowse:lCanAllmark := .t.
		oMark:oBrowse:bAllMark := {|| Inverte(cMarca,@oMark)}

		@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
		ACTIVATE DIALOG oDlg CENTERED

		If Exec
			Processa({|lEnd|EFETIVA()})  //Executa movimento financeiro a pagar e atualiza SIG
		Endif

	Endif

Return Nil



/*/{Protheus.doc} fSeleSIF
   @description:
   @type: Static Function
   @author: Felipe Mayer
   @since: 09/10/2023
/*/

Static Function fSeleSIF()

	Local cMarca := GetMark( )


	IF Select('TTRB1') > 0
		dbSelectArea('TTRB1')
		dbCloseArea()
	ENDIF

	_stru := SIF->(DbStruct())
	aAdd(_stru,{"IF_XOK" ,"C" ,2 ,0 })

	cArq  :=Criatrab(_stru,.T.)

	DBUSEAREA(.t.,,carq,"TTRB1")

	cQuery := " SELECT * FROM "+RetSqlName("SIF")+" "
	cQuery += " WHERE D_E_L_E_T_ = ' ' "

	cAliasTMP := GetNextAlias()
	MPSysOpenQuery(cQuery, cAliasTMP)

	While (cAliasTMP)->(!EoF())

		RecLock("TTRB1",.T.)
		TTRB1->IF_IDPROC := (cAliasTMP)->IF_IDPROC
		TTRB1->IF_DTPROC := SToD((cAliasTMP)->IF_DTPROC)
		TTRB1->IF_BANCO := (cAliasTMP)->IF_BANCO
		TTRB1->IF_DESC := (cAliasTMP)->IF_DESC
		TTRB1->IF_ARQIMP:= (cAliasTMP)->IF_ARQIMP
		TTRB1->IF_ARQCFG := (cAliasTMP)->IF_ARQCFG
		TTRB1->IF_STATUS := (cAliasTMP)->IF_STATUS
		TTRB1->(MsUnlock())

		(cAliasTMP)->(DbSkip())
	EndDo

	(cAliasTMP)->(DbCloseArea())


	aCpoBro1 := {;
		{ "IF_XOK" ,, "Mark" ,"@!"},;
		{ "IF_IDPROC" ,, "Id Processamento" ,"@!"},;
		{ "IF_DTPROC" ,, "Data" ,"@!"},;
		{ "IF_BANCO" ,, "Banco" ,"@!"},;
		{ "IF_DESC" ,, "Descri็ใo" ,"@!"},;
		{ "IF_ARQIMP" ,, "Arquivo Imp" ,"@!"},;
		{ "IF_ARQCFG" ,, "Arquivo Cfg" ,"@!"},;
		{ "IF_STATUS" ,, "Status" ,"@!"};
		}

	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Registros"
	oMark:=MsSelect():New("TTRB1","IF_XOK",,aCpoBro1,,cMarca,{02,1,170,350})
	oMark:oBrowse:lhasMark := .t.
	oMark:oBrowse:lCanAllmark := .t.

	@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED


Return


static function EFETIVA()

	Local nAt := 0
	Local aDados    := {}
	Private aLstAux := {}
	Private aEfetiv := {}
	Private lP := .F.
	Private lAp := .F.
	Private lPed := .F.
	Private lApB := .F.
	Private lApC := .F.
	Private aAlcada := {}
	Private lMsErroAuto := .F.

	TTRB->(DbGoTop())
	while !TTRB->(Eof())
		IF !Empty(TTRB->IG_XOK)
			aLstAux := {IG_IDPROC,IG_ITEM,IG_VLREXT,IG_DTEXTR,IG_HISTEXT,IG_AGEEXT,IG_CONEXT,IG_DOCEXT,IG_SEQMOV}
			aAdd(aEfetiv,aLstAux  )//,TRB->TMP_VLNF,TRB->TMP_VLICMR,TRB->TMP_EMIS})
			lAp := .T.
		ENDIF

		TTRB->(DbSkip())
	EndDo

	IF lAP
		For nAt := 1 to len(aEfetiv)
			lP := .F.
			//MOVIMENTO BANCมRIO
			nOperacao := 3 //3=Inclusใo de Movimento "Pagar"
			IF nAt == 1
				cNatur      := PadR(alltrim(cNatur)   , TamSx3("E5_NATUREZ")[1])
				cBanco      := PadR(cBanco      , TamSx3("A6_COD"    )[1])
				cAgencia    := PadR(MV_PAR03    , TamSx3("A6_AGENCIA")[1])
				cConta      := PadR(MV_PAR04      , TamSx3("A6_NUMCON" )[1])
			ENDIF
			dDataMov := aEfetiv[nAt,4]

			//Necessแrio estar posicionado na SA6 no indice 1 por causa da ExecAuto FINA100
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
				aAdd( aDados, {"E5_HISTOR"  , ALLTRIM(aEfetiv[nAt,5])   , NIL} )
				aAdd( aDados, {"E5_RATEIO"  , "N"   , NIL} )
				aAdd( aDados, {"E5_RECONC"  , "x"   , NIL} )
				aAdd( aDados, {"E5_SEQCON"   , ALLTRIM(aEfetiv[nAt,9])    , NIL} )
				aAdd( aDados, {"E5_BANCO"   , cBanco    , NIL} )
				aAdd( aDados, {"E5_AGENCIA" , cAgencia  , NIL} )
				aAdd( aDados, {"E5_CONTA"   , cConta    , NIL} )

				//Efetua a inclusใo do movimento a pagar via Rotina Automแtica FINA100 (Movimentos Bancแrios)
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
						SIG->IG_XOK     := cMarca
						SIG->IG_DTMOVI	:= dDataMov
						SIG->IG_AGEMOV	:= cAgencia
						SIG->IG_CONMOV	:= cConta
						SIG->IG_STATUS	:= "4"
						SIG->IG_HISMOV	:= "Conciliado em lote."
						SIG->IG_NATMOV	:= cNatur
						SIG->IG_EFETIVA	:= "1"
						SIG->IG_VLRMOV  := aEfetiv[nAt,3]
						SIG->(MsUnLock())
					ENDIF

				ENDIF
			ENDIF
		Next nAt

		FWAlertSuccess("Movimentos realizados.", "Concilia็ใo concluํda.")
	else
		FWAlertError("Marque ao menos um item para conciliar", "Erro na concilia็ใo")
	endIf

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบFuncao    ณ ValidaPergunta()                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
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


Static Function Inverte(cMarca,oMark)

	Local nReg := TTRB->(Recno())
	dbSelectArea('TTRB')
	dbGoTop()
	While !Eof()
		RecLock('TTRB')
		IF TTRB->IG_XOK == cMarca
			TTRB->IG_XOK := "  "
		Else
			TTRB->IG_XOK := cMarca
		Endif
		dbSkip()
	Enddo
	(cAlias)->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)

Return Nil
