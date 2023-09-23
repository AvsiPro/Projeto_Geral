
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
				aAdd( aDados, {"E5_HISTOR"  , ALLTRIM(aEfetiv[nAt,5])   , NIL} )
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
						SIG->IG_HISMOV	:= "Conciliado em lote."
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
¦¦¦Programa  ¦  boletos ¦ Autor ¦ Datamanager           ¦ Data ¦          ¦¦¦
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

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  boletos ¦ Autor ¦ Datamanager           ¦ Data ¦          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotinas Genericas                                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)

	//oFont?? = tamanho da fonte usada
	Local oFont8
	Local oFont9
	Local oFont10
	Local oFont16
	Local oFont16n
	Local oFont20
	Local oFont24
	Local i := 0
	Local oBrush                            //fundo no valor do titulo

	//Parâmetros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

	oFontCN := TFont():New("Currier New",9,8,.T.,.T.,5,.T.,5,.T.,.F.)

	//oBrush := TBrush():New("",4)
	//oBrush := TBrush():New(,CLR_BLUE,,)
	oBrush := TBrush():New(,,,)

	oPrint:StartPage()   // Inicia uma nova página

	oPrint:Line (150,100,150,2300)


	If aDadosBanco[1] == "001"
		oPrint:SayBitMap(750,100,"\system\bb.bmp",500,130)
		oPrint:SayBitMap(1870,100,"\system\bb.bmp",500,130)
	ElseIf aDadosBanco[1] == "341"
		oPrint:SayBitMap (750,100,"\system\itau.bmp",500,130)
		oPrint:SayBitMap (1870,100,"\system\itau.bmp",500,130)
	ElseIf aDadosBanco[1] == "033"
		oPrint:SayBitMap (750,100,"\system\santander.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\santander.bmp",500,120)
	ElseIf aDadosBanco[1] == "237"
		oPrint:SayBitMap (750,100,"\system\bradesco.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\bradesco.bmp",500,120)
	ElseIf aDadosBanco[1] == "422"
		oPrint:SayBitMap (750,100,"\system\safra.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\safra.bmp",500,120)
	ElseIf aDadosBanco[1] == "084"
		oPrint:SayBitMap (750,100,"\system\prime.bmp",500,120)
		oPrint:SayBitMap (1870,100,"\system\prime.bmp",500,120)
	Endif

	oPrint:Say  (84,1850,"Comprovante de Entrega"                             ,oFont10)

	oPrint:Line (250,100,250,1300 )
	oPrint:Line (350,100,350,1300 )
	oPrint:Line (420,100,420,2300 )
	oPrint:Line (490,100,490,2300 )

	oPrint:Line (350,400,420,400)
	oPrint:Line (420,500,490,500)
	oPrint:Line (350,625,420,625)
	oPrint:Line (350,750,420,750)

	oPrint:Line (150,1300,490,1300 )
	oPrint:Line (150,2300,490,2300 )
	oPrint:Say  (150,1310 ,"MOTIVOS DE NÃO ENTREGA (para uso do entregador)"  ,oFont8)
	oPrint:Say  (200,1310 ,"|   | Mudou-se"                                   ,oFont8)
	oPrint:Say  (270,1310 ,"|   | Recusado"                                   ,oFont8)
	oPrint:Say  (340,1310 ,"|   | Desconhecido"                               ,oFont8)

	oPrint:Say  (200,1580 ,"|   | Ausente"                                    ,oFont8)
	oPrint:Say  (270,1580 ,"|   | Não Procurado"                              ,oFont8)
	oPrint:Say  (340,1580 ,"|   | Endereço insuficiente"                      ,oFont8)

	oPrint:Say  (200,1930 ,"|   | Não existe o Número"                        ,oFont8)
	oPrint:Say  (270,1930 ,"|   | Falecido"                                   ,oFont8)
	oPrint:Say  (340,1930 ,"|   | Outros(anotar no verso)"                    ,oFont8)

	oPrint:Say  (420,1310 ,"Recebi(emos) o bloqueto"                          ,oFont8)
	oPrint:Say  (450,1310 ,"com os dados ao lado."                            ,oFont8)
	oPrint:Line (420,1700,490,1700)
	oPrint:Say  (420,1705 ,"Data"                                             ,oFont8)
	oPrint:Line (420,1900,490,1900)
	oPrint:Say  (420,1905 ,"Assinatura"                                       ,oFont8)

	oPrint:Say  (150,100 ,"Beneficiário"                                      ,oFont8)
	oPrint:Say  (180,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])),oFont9)
	oPrint:Say  (210,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)

	oPrint:Say  (250,100 ,"Pagador"                                           ,oFont8)
	oPrint:Say  (290,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                ,oFont10)

	oPrint:Say  (350,100 ,"Data do Vencimento"                                ,oFont8)

	If aDadosBanco[1] $ "237/341"  //SE BRADESCO
		oPrint:Say  (380,100 ,Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)  ,oFont10)
	Else
		oPrint:Say  (380,100 ,DTOC(aDadosTit[4])                              ,oFont10)
	Endif

	oPrint:Say  (350,405 ,"Nro.Documento",oFont8)
	oPrint:Say  (380,405 ,AllTrim(Transform(aDadosTit[1],"@! 9999999999")),oFont10)

	oPrint:Say  (350,630,"Moeda"                                              ,oFont8)
	oPrint:Say  (380,655,"R$"     				                              ,oFont10)

	oPrint:Say  (350,755,"Valor/Quantidade"                                   ,oFont8)
	oPrint:Say  (380,765,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")) ,oFont10)

	oPrint:Say  (420,100 ,"Agência/Cod. Beneficiário"                         ,oFont8)

	If     aDadosBanco[1] == "033"   //SE BANESPA
		oPrint:Say  (450,100,AllTrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4]),oFont10)
	ElseIf aDadosBanco[1] == "399"   //SE HSBC
		oPrint:Say  (450,100,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	ElseIf aDadosBanco[1] == "422"   //SE SAFRA
		oPrint:Say  (450,100,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	//+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
	Else
		oPrint:Say  (450,100,aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	Endif

	oPrint:Say  (420,505,"Nosso Número"                                       ,oFont8)
	oPrint:Say  (450,525,aDadosTit[6]                                         ,oFont10)

	For i := 100 to 2300 step 50
		oPrint:Line( 520, i, 520, i+30)
	Next i

	For i := 100 to 2300 step 50
		oPrint:Line( 750, i, 750, i+30)
	Next i

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ficha do Sacado                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oPrint:Line (870,100,870,2300)
	oPrint:Line (870,650,770,650 )
	oPrint:Line (870,900,770,900 )

	oPrint:Say  (782,700,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont20 )
	If aDadosBanco[1] == "001"
		//oPrint:Say  (782,100, "BANCO DO BRASIL",oFont14n )
	ElseIf aDadosBanco[1] == "341"
		//oPrint:Say  (782,100, "BANCO ITAÚ",oFont20 )
	ElseIf aDadosBanco[1] == "033"
		oPrint:Say  (782,100, "SANTANDER",oFont20 )
	ElseIf aDadosBanco[1] == "237"
		oPrint:Say  (782,100, "BRADESCO",oFont20 )
	ElseIf aDadosBanco[1] == "422"
		oPrint:Say  (782,100, "SAFRA",oFont20 )
	Endif

	oPrint:Line (0970,100,0970,2300 )
	oPrint:Line (1070,100,1070,2300 )
	oPrint:Line (1140,100,1140,2300 )
	oPrint:Line (1210,100,1210,2300 )

	oPrint:Line (1070,500,1210,500)
	oPrint:Line (1140,750,1210,750)
	oPrint:Line (1070,1000,1210,1000)
	oPrint:Line (1070,1350,1140,1350)
	oPrint:Line (1070,1550,1210,1550)

	oPrint:Say  (870,100 ,"Local de Pagamento"                                         ,oFont8)

	If     aDadosBanco[1] == "237"
		oPrint:Say  (0910,100 ,"Pagável preferencialmente na rede Bradesco ou Bradesco Expresso" ,oFont10)
	ElseIf aDadosBanco[1] == "341"
		oPrint:Say  (0910,100 ,"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO" ,oFont10)
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (0910,100 ,"Pagável em qualquer banco até o vencimento, após somente no Unibanco" ,oFont10)
	ElseIf aDadosBanco[1] == "422"
		oPrint:Say  (0910,100 ,"Pagável em qualquer banco do sistema de compensação" ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (0910,100 ,"Pagar preferencialmente em agência HSBC" ,oFont10)
	ElseIf aDadosBanco[1] == "084"

		oPrint:Say  (0910,100 ,"Pagável em qualquer banco até o vencimento"  ,oFont10)
	Endif


	oPrint:Say  (870,1910,"Vencimento"                                                 ,oFont8)

	If aDadosBanco[1] $ "237/341"  //SE BRADESCO
		oPrint:Say  (0910,2055,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
	Else
		oPrint:Say  (0910,2055,PadL(AllTrim(DTOC(aDadosTit[4])),16)                     ,oFont10)
	Endif


	oPrint:Say  (0970,100 ,"Beneficiário"                                               ,oFont8)
	oPrint:Say  (1000,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])+"-"+AllTrim(aDadosEmp[2])),oFont9)
	oPrint:Say  (1030,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)


	oPrint:Say  (0970,1910,"Agência/Código Beneficiário"                                ,oFont8)

	if     aDadosBanco[1] = '001'
		nLbco := 2040
		nNoss := 2040
	elseif aDadosBanco[1] = '033'
		nLbco := 1975
		nNoss := 2040
	elseif aDadosBanco[1] = '224' .or. aDadosBanco[1] = '224'
		nLbco := 2035
		nNoss := 2070
	elseif aDadosBanco[1] = '237'
		nLbco := 2040
		nNoss := 2030
	elseif aDadosBanco[1] = '341'
		nLbco := 2068
		nNoss := 2035
	elseif aDadosBanco[1] = '356'
		nLbco := 2010
		nNoss := 2020
	elseif aDadosBanco[1] = '399'
		nLbco := 2010
		nNoss := 2040
	elseif aDadosBanco[1] = '409'
		nLbco := 2005
		nNoss := 1990
	elseif aDadosBanco[1] = '422'
		nLbco := 2000
		nNoss := 2055
	else
		nLbco := 2040
		nNoss := 2040
	endif

	If aDadosBanco[1]     == "033"   //SE BANESPA
		oPrint:Say  (1010,nLbco,AllTrim(aDadosBanco[3])+'/'+alltrim(aDadosBanco[4]),oFont10)
	ElseIf aDadosBanco[1] == "399"   //SE HSBC
		oPrint:Say  (1010,nLbco,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	ElseIf aDadosBanco[1] == "422"   //SE SAFRA
		oPrint:Say  (1010,nLbco,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	//+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
	Else
		oPrint:Say  (1010,nLbco,AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),oFont10)
	Endif

	oPrint:Say  (1070,100 ,"Data do Documento"                                          ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (1100,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
	Else
		oPrint:Say  (1100,100 ,DTOC(aDadosTit[3])                                       ,oFont10)
	Endif

	oPrint:Say  (1070,505 ,"Nro.Documento"                                              ,oFont8)
	oPrint:Say  (1100,595 ,AllTrim(Transform(aDadosTit[1],"@! 9999999999")),oFont10)

	oPrint:Say  (1070,1005,"Espécie Doc."                                               ,oFont8)

	If aDadosBanco[1] == "399"  //SE HSBC
		oPrint:Say  (1100,1105,"PD"                                                         ,oFont10)
	Else
		oPrint:Say  (1100,1105,"DM"                                                         ,oFont10)
	Endif

	oPrint:Say  (1070,1355,"Aceite"                                                     ,oFont8)
	oPrint:Say  (1100,1455,"N"                                                          ,oFont10)

	oPrint:Say  (1070,1555,"Data do Processamento"                                      ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (1100,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
	Else
		oPrint:Say  (1100,1655,DTOC(aDadosTit[2])                                       ,oFont10)
	Endif

	oPrint:Say  (1070,1910,"Nosso Número"                                               ,oFont8)
	oPrint:Say  (1100,nNoss,AllTrim(aDadosTit[6])                                       ,oFont10)

	oPrint:Say  (1140,100 ,"Uso do Banco"                                               ,oFont8)

	If aDadosBanco[1] == "409"
		oPrint:Say  (1170,100,"cvt 5539-5",oFont10)
	Endif

	oPrint:Say  (1140, 505,"Carteira"                                                   ,oFont8)
	If     aDadosBanco[1] == "033"
		oPrint:Say  (1170, 520,"SIMPLES ECR"                                            ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (1170, 540,"CSB"                                                    ,oFont10)
	Else
		oPrint:Say  (1170, 540,aDadosBanco[6]+aDadosBanco[7]                            ,oFont10)
	Endif

	oPrint:Say  (1140, 755,"Espécie"                                                    ,oFont8)
	oPrint:Say  (1170, 805,"R$"                                                         ,oFont10)

	oPrint:Say  (1140,1005,"Quantidade"                                                 ,oFont8)
	oPrint:Say  (1140,1555,"Valor"                                                      ,oFont8)

	oPrint:Say  (1140,1910,"(=)Valor do Documento"                                      ,oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (1170,2060,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	else
		oPrint:Say  (1170,2045,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (1210,100 ,"Instruções/Todos as informações deste bloqueto são de exclusiva responsabilidade do beneficiário",oFont8)
	ElseIf aDadosBanco[1] == "001"
		oPrint:Say  (1210,100 ,"PAGÁVEL EM QUALQUER BANCO",oFont8)
	Else
		oPrint:Say  (1210,100 ,"Instruções/Texto de responsabilidade do beneficiário"        ,oFont8)
	Endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (1240,2060,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Else
		oPrint:Say  (1240,2045,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Endif

	//oPrint:Say  (1260,100 ,cInst0 ,oFontCN)
	oPrint:Say  (1260,100 ,cInst3 ,oFontCN)
	oPrint:Say  (1290,100 ,cInst1 ,oFontCN)
	oPrint:Say  (1320,100 ,cInst2 ,oFontCN)
	//oPrint:Say  (1350,100 ,cInst3 ,oFontCN)
	oPrint:Say  (1350,100 ,cInst0 ,oFontCN)
	oPrint:Say  (1380,100 ,aBolText[1],oFontCN)
	oPrint:Say  (1410,100 ,aBolText[2],oFontCN)
	oPrint:Say  (1440,100 ,aBolText[3],oFontCN)

	oPrint:Say  (1210,1910,"(-)Desconto/Abatimento"                                     ,oFont8)
	oPrint:Say  (1280,1910,"(-)Outras Deduções"                                         ,oFont8)
	oPrint:Say  (1350,1910,"(+)Mora/Multa"                                              ,oFont8)
	oPrint:Say  (1420,1910,"(+)Outros Acréscimos"                                       ,oFont8)
	oPrint:Say  (1490,1910,"(=)Valor Cobrado"                                           ,oFont8)

	oPrint:Say  (1560 ,100 ,"Pagador:"                                                  ,oFont8)
	oPrint:Say  (1588 ,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"                        ,oFont8)
	oPrint:Say  (1630 ,210 ,aDatSacado[3]                                               ,oFont8)
	oPrint:Say  (1670 ,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

	If aDadosBanco[1] == "422"
		oPrint:Say  (1525,100 ,"Sacador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	Else
		oPrint:Say  (1525,100 ,"Pagador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	EndIf

	oPrint:Say  (1710,1500,"Autenticação Mecânica "                                     ,oFont8)
	oPrint:Say  (0804,1850,"Recibo do Pagador"                                          ,oFont10)

	oPrint:Line (0870,1900,1560,1900 )
	oPrint:Line (1280,1900,1280,2300 )
	oPrint:Line (1350,1900,1350,2300 )
	oPrint:Line (1420,1900,1420,2300 )
	oPrint:Line (1490,1900,1490,2300 )
	oPrint:Line (1560,100 ,1560,2300 )

	oPrint:Line (1705,100,1705,2300  )

	For i := 100 to 2300 step 50
		oPrint:Line( 1870, i, 1870, i+30)
	Next i


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ficha de Compensacao                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:Line (1990,100,1990,2300)
	oPrint:Line (1990,650,1890,650 )
	oPrint:Line (1990,900,1890,900 )

	oPrint:Say  (1902,700,aDadosBanco[1]+"-"+If(aDadosBanco[1]<>'422',modulo11(aDadosBanco[1],aDadosBanco[1]),'7'),oFont20 )

	oPrint:Say  (1900,1004,CB_RN_NN[2],oFont12) //linha digitavel

	If aDadosBanco[1] == "001"
		//oPrint:Say  (1900,100, "BANCO DO BRASIL",oFont14n )
	ElseIf aDadosBanco[1] == "341"
		//oPrint:Say  (1900,100, "BANCO ITAÚ",oFont20 )
	ElseIf aDadosBanco[1] == "033"
		oPrint:Say  (1900,100, "SANTANDER",oFont20 )
	ElseIf aDadosBanco[1] == "237"
		oPrint:Say  (1900,100, "BRADESCO",oFont20 )
	ElseIf aDadosBanco[1] == "422"
		oPrint:Say  (1900,100, "SAFRA",oFont20 )
	Endif

	oPrint:Line (2090,100,2090,2300 )
	oPrint:Line (2190,100,2190,2300 )
	oPrint:Line (2260,100,2260,2300 )
	oPrint:Line (2330,100,2330,2300 )

	oPrint:Line (2190,500,2330,500)
	oPrint:Line (2260,750,2330,750)
	oPrint:Line (2190,1000,2330,1000)
	oPrint:Line (2190,1350,2260,1350)
	oPrint:Line (2190,1550,2330,1550)

	oPrint:Say  (1990,100 ,"Local de Pagamento"                             ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (2030,100 ,"Pagável preferencialmente na rede Bradesco ou Bradesco Expresso"       ,oFont10)
	ElseIf aDadosBanco[1] == "341"
		oPrint:Say  (2030,100 ,"Até o vencimento, preferencialmente no Itau e Após o vencimento, somente no Itau" ,oFont10)
	ElseIf aDadosBanco[1] == "409"
		oPrint:Say  (2030,100 ,"Pagável em qualquer banco até o vencimento, após somente no Unibanco" ,oFont10)
	ElseIf aDadosBanco[1] == "422"
		oPrint:Say  (2030,100 ,"Pagável em qualquer banco do sistema de compensação" ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (2030,100 ,"Pagar preferencialmente em agência HSBC" ,oFont10)
	Else
		oPrint:Say  (2030,100 ,"Pagável em qualquer banco até o vencimento"       ,oFont10)
	Endif


	oPrint:Say  (1990,1910,"Vencimento"                                     ,oFont8)

	If aDadosBanco[1] $ "237/341"
		oPrint:Say  (2030,2055,PadL(AllTrim(Substring(DTOS(aDadosTit[4]),7,2)+"/"+Substring(DTOS(aDadosTit[4]),5,2)+"/"+Substring(DTOS(aDadosTit[4]),1,4)),16," ")  ,oFont10)
	Else
		oPrint:Say  (2030,2055,PadL(AllTrim(DTOC(aDadosTit[4])),16," ")                               ,oFont10)
	Endif


	oPrint:Say  (2090,100 ,"Beneficiário"                                        ,oFont8)
	oPrint:Say  (2120,100 ,Iif(_lBcoCorrespondente,aDadosBanco[8],AllTrim(aDadosEmp[1])+"-"+AllTrim(aDadosEmp[2])),oFont9)
	oPrint:Say  (2150,100 ,Iif(_lBcoCorrespondente,aDadosBanco[9],AllTrim(aDadosEmp[3])+"-"+AllTrim(aDadosEmp[4])+"-"+AllTrim(aDadosEmp[6])),oFont9)

	oPrint:Say  (2090,1910,"Agência/Código Beneficiário"                         ,oFont8)

	If     aDadosBanco[1] == "033"   //SE BANESPA
		oPrint:Say  (2130,nLbco,AllTrim(aDadosBanco[3])+"/"+alltrim(aDadosBanco[4]),oFont10)
	ElseIf aDadosBanco[1] == "399"   //SE HSBC
		oPrint:Say  (2130,nLbco,aDadosBanco[3]+'-'+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
	ElseIf aDadosBanco[1] == "422"   //SE SAFRA
		oPrint:Say  (2130,nLbco,aDadosBanco[3]+' / '+aDadosBanco[4],oFont10)	 //+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")
	Else
		oPrint:Say  (2130,nLbco,AllTrim(aDadosBanco[3]+"/"+aDadosBanco[4]+Iif(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],"")),oFont10)
	Endif

	oPrint:Say  (2190,100 ,"Data do Documento"                              ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (2220,100 ,Substring(DTOS(aDadosTit[3]),7,2)+"/"+Substring(DTOS(aDadosTit[3]),5,2)+"/"+Substring(DTOS(aDadosTit[3]),1,4)  ,oFont10)
	Else
		oPrint:Say  (2220,100 ,DTOC(aDadosTit[3])                               ,oFont10)
	Endif


	oPrint:Say  (2190,505 ,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (2220,605 ,AllTrim(Transform(aDadosTit[1],"@! 9999999999")),oFont10)

	oPrint:Say  (2190,1005,"Espécie Doc."                                   ,oFont8)

	If aDadosBanco[1] == "399"  //SE HSBC
		oPrint:Say  (2220,1105,"PD"                                             ,oFont10)
	Else
		oPrint:Say  (2220,1105,"DM"                                             ,oFont10)
	Endif

	oPrint:Say  (2190,1355,"Aceite"                                         ,oFont8)
	oPrint:Say  (2220,1455,"N"                                              ,oFont10)

	oPrint:Say  (2190,1555,"Data do Processamento"                          ,oFont8)

	If aDadosBanco[1] == "237"
		oPrint:Say  (2220,1655,Substring(DTOS(aDadosTit[2]),7,2)+"/"+Substring(DTOS(aDadosTit[2]),5,2)+"/"+Substring(DTOS(aDadosTit[2]),1,4)  ,oFont10)
	Else
		oPrint:Say  (2220,1655,DTOC(aDadosTit[2])                           ,oFont10)
	Endif


	oPrint:Say  (2190,1910,"Nosso Número"                                   ,oFont8)
	oPrint:Say  (2220,nNoss,AllTrim(aDadosTit[6])                            ,oFont10)

	oPrint:Say  (2260,100 ,"Uso do Banco"                                   ,oFont8)
	If aDadosBanco[1] == "409"
		oPrint:Say  (2290,100 ,"cvt 5539-5"  ,oFont10)
	Endif

	oPrint:Say  (2260,505 ,"Carteira"                                       ,oFont8)
	If     aDadosBanco[1] == "033"
		oPrint:Say  (2290,520,"SIMPLES ECR"                                 ,oFont10)
	ElseIf aDadosBanco[1] == "399"
		oPrint:Say  (2290, 540,"CSB"                                        ,oFont10)
	Else
		oPrint:Say  (2290,540 ,aDadosBanco[6]+aDadosBanco[7]                ,oFont10)
	Endif


	oPrint:Say  (2260,755 ,"Espécie"                                        ,oFont8)
	oPrint:Say  (2290,805 ,"R$"                                             ,oFont10)

	oPrint:Say  (2260,1005,"Quantidade"                                     ,oFont8)
	oPrint:Say  (2260,1555,"Valor"                                          ,oFont8)

	oPrint:Say  (2260,1910,"(=)Valor do Documento"                          ,oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (2290,2060,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	Else
		oPrint:Say  (2290,2045,PadL(AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),16," "),oFont10)
	Endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (2330,100 ,"Instruções/Todos as informações deste bloqueto são de exclusiva responsabilidade do beneficiário",oFont8)
	Elseif aDadosBanco[1] == "001"
		oPrint:Say  (2330,100 ,"PAGÁVEL EM QUALQUER BANCO",oFont8)
	Else
		oPrint:Say  (2330,100 ,"Instruções/Texto de responsabilidade do beneficiário",oFont8)
	Endif

	If aDadosBanco[1] == "341"
		oPrint:Say  (2360,2060,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Else
		oPrint:Say  (2360,2045,PadL(AllTrim(Transform( aDadosTit[5] * (aDadosTit[7]/100),"@E 999,999,999.99")),16," "),oFont10)
	Endif

	//oPrint:Say  (2370,100 ,cInst0 ,oFontCN)
	oPrint:Say  (2370,100 ,cInst3 ,oFontCN)
	oPrint:Say  (2400,100 ,cInst1 ,oFontCN)
	oPrint:Say  (2430,100 ,cInst2 ,oFontCN)
	//oPrint:Say  (2460,100 ,cInst3 ,oFontCN)
	oPrint:Say  (2460,100 ,cInst0 ,oFontCN)
	oPrint:Say  (2480,100 ,aBolText[1],oFontCN)
	oPrint:Say  (2530,100 ,aBolText[2],oFontCN)
	oPrint:Say  (2580,100 ,aBolText[3],oFontCN)

	oPrint:Say  (2330,1910,"(-)Desconto/Abatimento"                         ,oFont8)
	oPrint:Say  (2400,1910,"(-)Outras Deduções"                             ,oFont8)
	oPrint:Say  (2470,1910,"(+)Mora/Multa"                                  ,oFont8)
	oPrint:Say  (2540,1910,"(+)Outros Acréscimos"                           ,oFont8)
	oPrint:Say  (2610,1910,"(=)Valor Cobrado"                               ,oFont8)

	oPrint:Say  (2680,100 ,"Pagador"                                         ,oFont8)
	oPrint:Say  (2708,210 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
	oPrint:Say  (2748,210 ,aDatSacado[3]                                    ,oFont8)
	oPrint:Say  (2788,210 ,aDatSacado[6]+"  "+aDatSacado[4]+" - "+aDatSacado[5]+"         CGC/CPF: "+Iif(Len(AllTrim(aDatSacado[7]))==14,Transform(aDatSacado[7],"@R 99.999.999/9999-99"),Transform(aDatSacado[7],"@R 999.999.999-99")) ,oFont8)

	If aDadosBanco[1] == "422"
		oPrint:Say  (1525,100 ,"Beneficiário final "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
		oPrint:Say  (2830,100 ,"Beneficiário final "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	Else
		oPrint:Say  (1525,100 ,"Pagador/Avalista "+Iif(_lBcoCorrespondente,aDadosEmp[1],"")  ,oFont8)
	EndIf

	oPrint:Say  (2830,1500,"Autenticação Mecânica -"                        ,oFont8)

	If aDadosBanco[1] == "341"
		oPrint:Say  (2830,1850,"Ficha de Compensação"                       ,oFont8)
	Else
		oPrint:Say  (2830,1850,"Ficha de Compensação"                       ,oFont10)
	Endif

	oPrint:Line (1990,1900,2680,1900 )
	oPrint:Line (2400,1900,2400,2300 )
	oPrint:Line (2470,1900,2470,2300 )
	oPrint:Line (2540,1900,2540,2300 )
	oPrint:Line (2610,1900,2610,2300 )
	oPrint:Line (2680,100 ,2680,2300 )

	oPrint:Line (2825,100,2825,2300  )

	MSBAR("INT25"  ,25.9,1.5,CB_RN_NN[1],oPrint,.F.,,,0.0253,1.6,,,,.F.)
	//MSBAR("INT25"  ,25,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.6,,,,.F.)
	//MSBAR("INT25"  ,12.5,0.40,CB_RN_NN[1],oPrint,.F.,,,0.023,1.4,,,,.F.)


	/*
MSBAR("INT25"  , 21  ,  3 ,"123456789012",oPr,,,.t.)
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Parametros³ 01 cTypeBar String com o tipo do codigo de barras          ³±±
±±³          ³             "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     ³±±
±±³          ³             "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"    ³±±
±±³          ³ 02 nRow     Numero da Linha em centimentros                ³±±
±±³          ³ 03 nCol     Numero da coluna em centimentros               ³±±
±±³          ³ 04 cCode    String com o conteudo do codigo                ³±±
±±³          ³ 05 oPr      Objeto Printer                                 ³±±
±±³          ³ 06 lcheck   Se calcula o digito de controle                ³±±
±±³          ³ 07 Cor      Numero  da Cor, utilize a "common.ch"          ³±±
±±³          ³ 08 lHort    Se imprime na Horizontal                       ³±±
±±³          ³ 09 nWidth   Numero do Tamanho da barra em centimetros      ³±±
±±³          ³ 10 nHeigth  Numero da Altura da barra em milimetros        ³±±
±±³          ³ 11 lBanner  Se imprime o linha em baixo do codigo          ³±±
±±³          ³ 12 cFont    String com o tipo de fonte                     ³±±
±±³          ³ 13 cMode    String com o modo do codigo de barras CODE128  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/


	oPrint:EndPage() // Finaliza a página

Return Nil
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  boletos ¦ Autor ¦ Datamanager           ¦ Data ¦          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotinas Genericas                                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function Modulo10(cData)

	Local L,D,P := 0
	Local B     := .F.

	L := Len(cData)  //TAMANHO DE BYTES DO CARACTER
	B := .T.
	D := 0     //DIGITO VERIFICADOR
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End

Return(D)
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  boletos ¦ Autor ¦ Datamanager           ¦ Data ¦          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotinas Genericas                                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
static Function Modulo11(cData,cBanc)

	Local L, D, P := 0

	cData:=alltrim(cData)

	If cBanc == "001"  // Banco do brasil
		L := Len(cdata)
		D := 0
		P := 10
		While L > 0
			P := P - 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 2
				P := 10
			End
			L := L - 1
		End
		D := mod(D,11)
		If len(cData) > 20
			If D == 10 .or. D == 11 .or. D == 0
				D := "1"
			Else
				D := AllTrim(Str(D))
			End
		Else
			If D == 10
				D := "X"
			Else
				D := AllTrim(Str(D))
			End
		Endif
	ElseIf cBanc == "341" .Or. cBanc == "453" .or. cBanc == "224" // Itau/Mercantil/Rural/Safra
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End

		D := 11 - (mod(D,11))

		If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422" .or. cBanc == "224")
			D := 1
		End
		If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf  cBanc == "422"
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End

		D := 11 - (mod(D,11))

		If (D == 10 .Or. D == 11) .and. (cBanc == "341" .or. cBanc == "422" .or. cBanc == "224")
			D := 1
		End
		If (D == 1 .Or. D == 0 .Or. D == 10 .Or. D == 11) .and. (cBanc == "289" .Or. cBanc == "453")
			D := 0
		End
		D := AllTrim(Str(D))

	ElseIf cBanc == "237"
		Q := If(len(cData) > 20,9,7)
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = Q
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))

		If     D == 10
			If Len(cData) > 20
				D := '1'
			Else
				D := 'P'
			Endif
		ElseIf D == 11
			If Len(cData) > 20
				D := '1'
			Else
				D := '0'
			Endif
		ElseIf D == 0
			If Len(cData) > 20
				D := '1'
			Else
				D := '0'
			Endif
		Else
			D := AllTrim(Str(D))
		End
	ElseIf cBanc == "389" //Mercantil
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := mod(D,11)
		If D == 1 .Or. D == 0
			D := 0
		Else
			D := 11 - D
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "479"  //BOSTON
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "409"  //UNIBANCO
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10 .or. D == 0
			If Len(cData) > 20
				D := 1
			Else
				D := 0
			Endif
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "356"  //Real
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := Mod(D*10,11)
		If D == 10 .or. D == 0
			D := 0
		End
		D := AllTrim(Str(D))
	ElseIf  cBanc == "399"  //HSBC
		Q := If(len(cData) > 20,9,7)
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = Q
				P := 1
			End
			L := L - 1
		End
		D := (mod(D,11))        //Alterado em 13/04 - os digitos 0 e 1 estavam inconsistentes de acordo com o calculo
		If (D == 0 .Or. D == 1)
			If Len(cData) > 20
				D := 1
			Else
				D := 0
			Endif
		Else
			D := 11 - (mod(D,11))
		End
		D := AllTrim(Str(D))
	ElseIf cBanc == "084"  //UNIPRIME
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 7
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))
		If (D == 10 .Or. D == 11)
			D := 1
		End
		D := AllTrim(Str(D))
	Else
		L := Len(cdata)
		D := 0
		P := 1
		While L > 0
			P := P + 1
			D := D + (Val(SubStr(cData, L, 1)) * P)
			If P = 9
				P := 1
			End
			L := L - 1
		End
		D := 11 - (mod(D,11))
		If (D == 10 .Or. D == 11)
			D := 1
		End
		D := AllTrim(Str(D))
	Endif

Return(D)

//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  boletos ¦ Autor ¦ Datamanager           ¦ Data ¦          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotinas Genericas                                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para Clientes Microsiga                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

	Local cCodEmp := StrZero(Val(SubStr(cConvenio,1,6)),6)
	Local cNumSeq := strzero(val(cSequencial),5)
	Local blvalorfinal := strzero(round(nValor*100,10),10)
	Local cCpoLivre := cCBSemDig := cCodBarra := cFatVenc := ''
	Local cNossoNum
	Local _cDigito := ""
	Local _cSuperDig := ""

	_cParcela := NumParcela(_cParcela)

	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)

	//Proximo numero da faixa
	pNumero := val(SEE->EE_FAXATU)

	//Campo Livre (Definir campo livre com cada banco)

	If Substr(cBanco,1,3) == "001"  // Banco do brasil

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,10)

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		//Nosso Numero com digito
		cNumbco	:= Alltrim(cconvenio)+cNNumSDig
		//cNNumSDig := Alltrim(cconvenio)+cNNumSDig
		cNNum   := cNumbco  + modulo11(cNumbco,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cvaltochar(cNumbco) + "-" + modulo11(cNumbco,SubStr(cBanco,1,3))

		//cContNum := cNNumSDig //strzero(val(cNNumSDig),10)cContNum
		//cCpoLivre := substr(cconvenio,1,4)+strzero(val(cNNumSDig),7) + cAgencia + StrZero(Val(cConta),8) + cCarteira
		cCpoLivre := cNumbco + cAgencia + StrZero(Val(cConta),8) + cCarteira

		//cCpoLivre := Alltrim(cconvenio) + cAgencia + StrZero(Val(cConta),8) + cNNumSDig //cCarteira
		//cCpoLivre := strzero(val(cNNumSDig),11) + cAgencia + StrZero(Val(cConta),8) + cCarteira
		//cCpoLivre := strzero(val(cContNum),11) + cAgencia + StrZero(Val(cConta),8) + cCarteira


	ElseIf Substr(cBanco,1,3) == "033"  // Banespa

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			//		cNNumSDig := AllTrim(cConvenio)+strzero(pNumero,10)
			cNNumSDig := strzero(pNumero,12)

		else

			cNNumSDig := substr(alltrim(SE1->E1_NUMBCO),1,12)  //alteracao 13-08-2014 erro nosso numero santander

		endif

		//Nosso Numero com digito
		cNumbco	:= cNNumSDig
		cNNum   := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig + "-" + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//	cCpoLivre := cNNumSDig + cAgencia + StrZero(Val(cConta),8) + cCarteira

		cCpoLivre := "9" + strzero(val(substr(cConvenio,9,7)),7) + strzero(val(cNNumSDig),12) + modulo11(cNNumSDig,SubStr(cBanco,1,3)) + '0' + cCarteira


	Elseif Substr(cBanco,1,3) == "422"  // Banco Safra --- Ajustado nosso número com 8 posições

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			//cNNumSDig := alltrim(str(pNumero,10))
			cNNumSDig := STRZERO(pNumero,9)
		else

			//cNNumSDig := alltrim(str(val(SE1->E1_NUMBCO),10))
			cNNumSDig := STRZERO(val(SE1->E1_NUMBCO),9)
		endif

		//Nosso Numero
		cNumbco	:= cNNumSDig
		cNNum := cNNumSDig //+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig + "-" + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10) + cDacCC + cNNum + "2"
		cCpoLivre := "7"+StrZero(Val(cAgencia),4) + StrZero(Val(cConta),10) + cNNum + "2"

	Elseif Substr(cBanco,1,3) == "237" // Banco Bradesco    -- CARTEIRA + SEQUENCIAL COM 11 POSIÇÕES

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			//		pNumero   := val(cCarteira + bldocnufinal)
			//		cNNumSDig := cCarteira + bldocnufinal

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,11)


		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		cCarteira := alltrim(cCarteira)

		//Nosso Numero sem digito
		cNumbco	:= cNNumSDig
		//	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero
		//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNossoNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"

	Elseif Substr(cBanco,1,3) == "084" // Banco Bradesco    -- CARTEIRA + SEQUENCIAL COM 11 POSIÇÕES

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			//		pNumero   := val(cCarteira + bldocnufinal)
			//		cNNumSDig := cCarteira + bldocnufinal

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,11)


		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		cCarteira := alltrim(cCarteira)

		//Nosso Numero sem digito
		cNumbco	:= cNNumSDig
		//	cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero
		//	cNNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		//	cNossoNum := cCarteira + '/' + bldocnufinal + '-' + AllTrim( Str( modulo10( cNNumSDig ) ) )
		cNossoNum := cCarteira + '/' + cNumbco + '-' + modulo11(cCarteira+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cCarteira + cNNumSDig + StrZero(Val(cConta),7) + "0"

	Elseif Substr(cBanco,1,3) == "341"  // Banco Itau

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			//		pNumero   := val(cCarteira+strzero(val(cNroDoc),6)+ _cParcela)
			//		cNNumSDig := cCarteira+strzero(val(cNroDoc),6)+ _cParcela

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := alltrim(str(pNumero,10))

		else

			cNNumSDig := alltrim(str(val(SE1->E1_NUMBCO),10))

		endif

		//Nosso Numero
		cNumbco	:= strzero(val(cNNumSDig),8)
		cNNumSDig := cCarteira + cNumbco
		//	cNNum := cCarteira+strzero(val(cNroDoc),6) + _cParcela + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )

		//Nosso Numero para impressao
		//	cNossoNum := cCarteira+"/"+strzero(val(cNroDoc),6)+ _cParcela +'-' + AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
		cCalcDig      := AllTrim( Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cNNumSDig ) ) )
		cNossoNum := cCarteira + '/' + cNumbco + '-' + cCalcDig

		cCpoLivre := cNNumSDig + cCalcDig + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5) + cDacCC + "000"

	Elseif Substr(cBanco,1,3) == "356" // Banco REAL

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,13)

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		//Nosso Numero
		cNumbco	:= cNNumSDig
		cNNum   := cNNumSDig

		//Nosso Numero para impressao
		cNossoNum := cNNum
		cCpoLivre := StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7) + AllTrim(Str( modulo10( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7)+cNNumSDig ) ) ) + cNNumSDig

	Elseif Substr(cBanco,1,3) == "399"  // Banco HSBC

		//Nosso Numero sem digito
		if empty(SE1->E1_NUMBCO)

			pNumero := val(SEE->EE_FAXATU) + 1

			cNNumSDig := strzero(pNumero,10)  //CODIGO CONVENIO COM 5 + SEQUENCIAL COM 5

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		//Nosso Numero
		cNumbco	:= cNNumSDig
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cNNum + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),6) + cDacCC + "001"

	Elseif Substr(cBanco,1,3) == "389" // Banco mercantil

		pNumero := val(SEE->EE_FAXATU) + 1

		//Nosso Numero sem digito
		cNNumSDig := "09"+cCarteira+ strzero(val(cSequencial),6)
		//Nosso Numero
		cNNum := "09"+cCarteira+ strzero(val(cSequencial),6) + modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := "09"+cCarteira+ strzero(val(cSequencial),6) +"-"+ modulo11(cAgencia+cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cAgencia + cNNum + StrZero(Val(SubStr(cConvenio,1,9)),9)+Iif(_lTemDesc,"0","2")

	Elseif Substr(cBanco,1,3) == "453"  // Banco rural

		pNumero := val(SEE->EE_FAXATU) + 1

		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),7)
		//Nosso Numero
		cNNum := cNNumSDig + AllTrim( Str( modulo10( cNNumSDig ) ) )
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ AllTrim( Str( modulo10( cNNumSDig ) ) )

		cCpoLivre := "0"+StrZero(Val(cAgencia),3) + StrZero(Val(cConta),10)+cNNum+"000"

	Elseif Substr(cBanco,1,3) == "479" // Banco Boston

		pNumero := val(SEE->EE_FAXATU) + 1

		cNumSeq := strzero(val(cSequencial),8)
		cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),9)
		//Nosso Numero sem digito
		cNNumSDig := strzero(val(cSequencial),8)
		//Nosso Numero
		cNNum := cNNumSDig + modulo11(cNNumSDig,SubStr(cBanco,1,3))
		//Nosso Numero para impressao
		cNossoNum := cNNumSDig +"-"+ modulo11(cNNumSDig,SubStr(cBanco,1,3))

		cCpoLivre := cCodEmp+"000000"+cNNum+"8"

	Elseif Substr(cBanco,1,3) == "409" // Banco UNIBANCO

		if empty(SE1->E1_NUMBCO)

			cNNumSDig := strzero(val(SEE->EE_FAXATU) + 1,10)
			pNumero   := val(SEE->EE_FAXATU) + 1

		else

			cNNumSDig := alltrim(SE1->E1_NUMBCO)

		endif

		_cDigito := modulo11(cNNumSDig,SubStr(cBanco,1,3))

		//Calculo do super digito
		cSSu := '1'
		_cSuperDig := modulo11(cSSu+cNNumSDig + _cDigito,SubStr(cBanco,1,3))
		cNNum := cSSu+cNNumSDig + _cDigito + _cSuperDig

		//Nosso Numero para impressao
		cNossoNum := cSSu + "/" + cNNumSDig + "-" + _cDigito + "/" + _cSuperDig

		// O codigo fixo "04" e para a cobrança com registro
		// O codigo fixo "06" e para a caução
		cCpoLivre := "04" + SubStr(DtoS(dvencimento),3,6) + StrZero(Val(StrTran(_cAgCompleta,"-","")),5) + cNNumSDig + _cDigito + _cSuperDig

	Endif

	//Dados para Calcular o Dig Verificador Geral
	ccalcg := ''
	If substr(cBanco,1,3) == '001'
		ccalcg := cBanco + cFatVenc + blvalorfinal + SUBSTR(cCpoLivre,1,4)+SUBSTR(CCPOLIVRE,11,7)+SUBSTR(CCPOLIVRE,18,4)+SUBSTR(CCPOLIVRE,22,10)//cCpoLivre
		cCBSemDig := cBanco + cFatVenc + blvalorfinal + '000000' + alltrim(cconvenio) + cNnumsdig + cCarteira
	else
		cCBSemDig := cBanco + cFatVenc + blvalorfinal + cCpoLivre
	endif
	//Codigo de Barras Completo
	If substr(cBanco,1,3) <> '084'
		If substr(cBanco,1,3) == '001'
			cCodBarra := cBanco + modulo11(cCBSemDig,substr(cBanco,1,3)) + cFatVenc + blvalorfinal + '000000' + alltrim(cconvenio) + cNnumsdig + cCarteira
		Else
			cCodBarra := cBanco + modulo11(cCBSemDig,substr(cBanco,1,3)) + cFatVenc + blvalorfinal +cCpoLivre
		EndIf
	Else
		cCodBarra := cBanco + modulo11(cCBSemDig,'999') + cFatVenc + blvalorfinal + cCpoLivre
	EndIf
	//Digito Verificador do Primeiro Campo
	//If substr(cBanco,1,3) <> '001'
	cPrCpo := cBanco + SubStr(cCodBarra,20,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
	/*else
	cPrCpo := cBanco + SubStr(cCodBarra,10,5)
	cDvPrCpo := AllTrim(Str(Modulo10(cPrCpo)))
EndIf
	*/
	//Digito Verificador do Segundo Campo
	cSgCpo := SubStr(cCodBarra,25,10)
	cDvSgCpo := AllTrim(Str(Modulo10(cSgCpo)))

	//Digito Verificador do Terceiro Campo
	cTrCpo := SubStr(cCodBarra,35,10)  //35,10
	cDvTrCpo := AllTrim(Str(Modulo10(cTrCpo)))

	//Digito Verificador Geral
	cDvGeral := SubStr(cCodBarra,5,1)

	//Linha Digitavel
	cLindig := SubStr(cPrCpo,1,5) + "." + SubStr(cPrCpo,6,4) + cDvPrCpo + " "   //primeiro campo
	cLinDig += SubStr(cSgCpo,1,5) + "." + SubStr(cSgCpo,6,5) + cDvSgCpo + " "   //segundo campo
	cLinDig += SubStr(cTrCpo,1,5) + "." + SubStr(cTrCpo,6,5) + cDvTrCpo + " "   //terceiro campo
	cLinDig += " " + cDvGeral              //dig verificador geral
	cLinDig += "  " + SubStr(cCodBarra,6,4)+SubStr(cCodBarra,10,10)  // fator de vencimento e valor nominal do titulo
	//cLinDig += "  " + cFatVenc +blvalorfinal  // fator de vencimento e valor nominal do titulo

	If substr(cbanco,1,3) == "422"
		cNossoNum := substr(cNossoNum,1,9)
	ENDIF

Return({cCodBarra,cLinDig,cNossoNum})
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
