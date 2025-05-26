#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER CHR(13) + CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MTBCO     º Autor ³ EduarDo Augusto    º Data ³  17/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Fonte p/ Tratamento Do Nosso Numero, Digitos VerIficaDores º±±
±±º          ³ Montagem da Linha Digitavel e Codigo de Barras.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Hakuna Matata                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º							                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function NNCBLDDV(_aBoletos)

Local _aArea   := getarea()
Local _aImpBol := {}
For _nxx:=1 To Len(_aBoletos)
	If Empty(_aBoletos[_nxx][6])
		SF2->(DbGoTo(_aBoletos[_nxx][1]))
		SC5->(DbGoTo(_aBoletos[_nxx][4]))
		U_fProcCodBco(_aBoletos[_nxx,2],_aBoletos[_nxx,3])
		_aBoletos[_nxx][6]:="Ok"
		aAdd(_aImpBol,{_aBoletos[_nxx,3],_aBoletos[_nxx,2]}) //serie/Doc
	EndIf
Next _nxx
RestArea(_aArea)
Return

User Function fProcCodBco(_cNumeIni)

Local _vAmbSa1    := SA1->(GetArea())
Local _cNumBar    := ""
Local _cNossoNum  := ""
Private _cBanco	  := _cBanco
private _cDigBar  := ""
Private _cDigCor  := ""
Private _nDigtc3  := 0
Private cQuery	  := ""
Private _cDig1bar := 0
cSelect	:= " SELECT  *			" + ENTER
cFrom	:= " FROM "+ RetSqlName("SEE") +" SEE " + ENTER
cWhere	:= " WHERE SEE.EE_FILIAL 	= '" +  xFilial("SEE")  + "' "+ENTER
cWhere	+= " AND SEE.D_E_L_E_T_ 	= ' '" + ENTER
cWhere	+= " AND SEE.EE_CODIGO= '" + _cBanco + "'  	" + ENTER //Filtro por DATA
cQuery := cSelect + cFrom + cWhere
If Select( "TMP" ) > 0
	DbSelectArea( "TMP" )
	DbCloseArea()
EndIf
MemoWrite( "rfatr01b.sql" , cQuery )
TcQuery cQuery New Alias "TMP"
_cParcIni	:= SE1->E1_PARCELA
_cPrefixo	:= SE1->E1_PREFIXO
_cNum    	:= SE1->E1_NUM
_cParcFim	:= SE1->E1_PARCELA
If Empty(_cBanco)
	_cBanco   := TMP->EE_CODIGO
	_cAgencia := TMP->EE_AGENCIA
	_cConta   := TMP->EE_CONTA
	_cDvCta   := TMP->EE_DVCTA
	_cSubcta  := TMP->EE_SUBCTA
EndIf
_cNossoNum	:= ""
If Mv_Par05 == 2 .And. !Empty(SE1->E1_XNUMBCO)
	_cNossoNum := SE1->E1_XNUMBCO
Else
	Do Case
		Case _cBanco == "347"
			_cNossoNum	:= Nosso347()
		Case _cBanco == "001"
			_cNossoNum	:= Nosso001()
		Case _cBanco == "479"
			_cNossoNum	:= u_NossoBkb()
		Case _cBanco == "341"
			_cNossoNum	:= Nosso341()
		Case _cBanco == "033"
			_cNossoNum	:= Nosso033()
		Case _cBanco == "399"
			_cNossoNum	:= Nosso399()
		Case _cBanco == "237"
			_cNossoNum	:= Nosso237()
		Case _cBanco == "643"
			_cNossoNum	:= Nosso237()
		Case _cBanco == "422"
			_cNossoNum	:= Nosso422()
		Case _cBanco == "389"
			_cNossoNum	:= Nosso389()
	EndCase
EndIf
If _cBanco == "347"
	_cNossoNum	:= Alltrim(_cNossoNum)
	_cDigBar	:= ""
	_cNumBar	:= _fNumBar1(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar)
	_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
ElseIf _cBanco == "033"
	_cNossoNum	:= Alltrim(_cNossoNum)
	_cNossoDig	:= Right(_cNossoNum,1)
	_cDigBar	:= ""
	_cNumBar	:= _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
ElseIf _cBanco == "399"
	_cNossoNum	:= Alltrim(_cNossoNum)
	_cNossoDig	:= Right(_cNossoNum,1)
	_cDigBar	:= ""
	_cNumBar	:= _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
ElseIf  _cBanco == "001"
	_cNossoNum	:= Alltrim(_cNossoNum)
	_cNossoDig	:= Right(_cNossoNum,1)
	//_cNossoNum	:= Left(_cNossoNum,Len(_cNossoNum)-1)
	_cDigBar	:= ""
	_cNumBar	:= _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
Else
	_cNossoNum	:= Alltrim(_cNossoNum)
	_cNossoDig	:= Right(_cNossoNum,1)
	_cNossoNum	:= Left(_cNossoNum,Len(_cNossoNum)-1)
	_cDigBar	:= ""
	_cNumBar	:= _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol	:= _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
EndIf
If !Empty(_cNossoNum) .Or. !Empty(_cNumBar) .Or. !Empty(_cNumbol)
	If SE1->(Reclock(Alias(),.F.))
		If _cBanco == "347"
			SE1->E1_NUMBCO  := _cNossoNum
		ElseIf _cBanco == "033"
			SE1->E1_NUMBCO	:= _cNossoNum
		ElseIf _cBanco == "399"
			SE1->E1_NUMBCO	:= _cNossoNum
		ElseIf _cBanco == "001"
			SE1->E1_NUMBCO	:= _cNossoNum
		ElseIf _cBanco == "341"
			SE1->E1_NUMBCO  :=_cNossoNum + _cNossoDig
		Else
			SE1->E1_NUMBCO  :=_cNossoNum + _cNossoDig
			If Empty(SE1->E1_NUMBCO)
				SE1->E1_NUMBCO  := _cNossoNum + _cNossoDig
			Else
				SE1->E1_NUMBCO  := SE1->E1_NUMBCO
			EndIf
		EndIf
		SE1->E1_PORTADO	:= _cBanco
		SE1->E1_AGEDEP	:= _cAgencia
		SE1->E1_CONTA	:= _cConta
		SE1->E1_CODBAR  := _cNumBar
		SE1->E1_CODDIG  := _cNumBol
		SE1->E1_SITUACA := "0"
		If Empty(SE1->E1_XNUMBCO) // Vazio
			SE1->E1_XNUMBCO := SE1->E1_NUMBCO
		Else // Ja gravaDo
			If Mv_Par05 == 2 .And. !Empty(SE1->E1_XNUMBCO)
				SE1->E1_NUMBCO := SE1->E1_XNUMBCO // Usa o original
			Else
				_cNossoNum := SE1->E1_XNUMBCO
			EndIf
		EndIf
		SE1->(msunlock())
	EndIf
EndIf
RetIndex("SA1")
Return

Static Function _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)	// Montagem da Linha Digitavel

Local _cNumBol,_cNossoNu1:=_cNossoNum,_nVez
For _nVez:=1 To Len(_cNossoNum)
	If Substr(_cNossoNum,_nVez,1)=="0"
		_cNossoNu1:=Right(_cNossoNu1,Len(_cNossoNu1)-1)
	Else
		Exit
	EndIf
Next
Do Case
	Case _cBanco == "347" // Sudameris
		_cCampo1 := _cBanco + "9" + Left(Alltrim(_cAgencia),4) + Left(_cConta,1)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)	// Caculo do 1° Digito Verificador
		_cCampo2 := Substr(_cConta,2,6)
		_cDigt	 :=_fDigVer1(_cNossoNum,_cAgencia,_cConta)  // Caculo do 2° Digito Verificador
		_cCampo2_1 := "000"
		_cDig2	 := _fDigVer2(_cCampo2,_cDigt,_cCampo2_1)	// Caculo do 2° Digito Verificador
		_cCampo3 := "000" + _cNossoNum
		_cDig3	 := _fDigVer3(_cNossoNum)	// Caculo do 3° Digito Verificador
		_cCampo4 := _cDigBar	// Caculo do 4° Digito Verificador
		_cCampo5 := Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10)	// Fator de Vencimento + Valor do Titulo
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDigt + _cCampo2_1 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5	// Linha Digitavel Montada 
	Case _cBanco == "001" //Banco Do Brasil
		_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Substr(_cNumBar,06,4) + Strzero(SE1->E1_VALOR*100,10)
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5
	Case _cBanco == "341" // Banco Itau
		_cCampo1 := _cBanco + "9" + "109" + Left(_cNossoNum,2)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		_cCampo2 := Substr(_cNossoNum,3) + _cNossoDig + Left(_cAgencia,3)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		_cCampo3 := Substr(_cAgencia,4,1) + Substr(alltrim(_cConta),1,5) + Alltrim(_cDvCta) + "000"
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10)
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5
	Case _cBanco == "033" // Banco Santander
		cCpo01 := _cBanco
		cCpo02 := "9" // Moeda "9"=Real
		cCpo03 := "9" // Fixo "9"
		cCpo04 := Substr(_cCodemp,6,4) // Codigo Padrao Cedenteo Banco Santander
		cDig_4 := _fDigVer(_cBanco + "99" + cCpo04,cCpo01)
		cCpo05 := Substr(_cCodemp,10,3) + Substr(_cNossoNum,1,7) // Restante Do Cod Cedente
		cDig_5 := _fDigVer2(cCpo05, _cBanco)
		cCpo06 := Substr(_cNossoNum,8,6) // Restante Do Nosso Numero
		cCpo07 := "0" // IOS
		cCpo08 := "101" // "101"=Cobranca Simples Com Registro
		cDig_8 := _fDigVer3(cCpo06 + cCpo07 + cCpo08, _cBanco)
		cDig_9 := _cDig1bar
		cCpo10 := Strzero(SE1->E1_VENCREA - CtoD("07/10/1997"),4) // Fator de Vencimento
		cCpo11 := Strzero((Iif(SE1->E1_PREFIXO<>"RPS", SE1->E1_SALDO, SE1->E1_SALDO - (If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) + If(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS) + If(SE1->E1_SABTPIS>0,0,SE1->E1_PIS) + SE1->E1_IRRF + SE1->E1_ISS + SE1->E1_INSS)))*100,10)
		_cNumBol := cCpo01 + cCpo02 + cCpo03 + cCpo04 + cDig_4
		_cNumBol += cCpo05 + cDig_5
		_cNumBol += cCpo06 + cCpo07 + cCpo08 + cDig_8
		_cNumBol += cDig_9
		_cNumBol += cCpo10 + cCpo11
	Case _cBanco == "399" // Banco HSBC
		cCpo01 := _cBanco
		cCpo02 := "9" // Moeda "9"=Real
		cCpo03 := Substr(_cNossoNum,1,5) // Inicio Do Nosso Numero Banco HSBC
		cDig_3 := _fDigVer(_cBanco + "9" + cCpo03,cCpo01)
		cCpo04 := Substr(_cNossoNum,6,6) + Alltrim(_cAgencia) // Fim Do Nosso Numero Banco HSBC + Agencia
		cDig_4 := _fDigVer2(cCpo04, _cBanco)
		cCpo05 :=  Alltrim(_cConta) + Alltrim(_cDvCta)	// Conta Corrente + Digito da Conta Corrente
		cCpo06 := "00"	// Codigo da Carteira
		cCpo07 := "1"	// Codigo Aplicativo
		cDig_7 := _fDigVer3(cCpo05 + cCpo06 + cCpo07, _cBanco)
		cDig_8 := _cDig1bar
		cCpo09 := Strzero(SE1->E1_VENCTO - CtoD("07/10/1997"),4) // Fator de Vencimento
		cCpo10 := Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDo+SE1->E1_ACRESC-SE1->E1_DECRESC,(SE1->E1_SALDo+SE1->E1_ACRESC-SE1->E1_DECRESC)-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +If(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+If(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10)	// Valor Do Titulo
		_cNumBol := cCpo01 + cCpo02 + cCpo03 + cDig_3
		_cNumBol += cCpo04 + cDig_4
		_cNumBol += cCpo05 + cCpo06 + cCpo07 + cDig_7
		_cNumBol += cDig_8
		_cNumBol += cCpo09 + cCpo10
	Case _cBanco=="422" // Banco Safra
		_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Substr(_cNumBar,06,14)
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5
	Case _cBanco == "479" // Bank Boston
		_cCampo1 := _cBanco + "9" + "001526"
		_cCampo2 := "20600000002"
		_cCampo3 := _cNossoNu1 + _cNossoDig + "8"
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->e1_valor*100,10)
		_cNumBol :=_cCampo1+_cCampo2+_cCampo3+_cDig3+_cCampo4+_cCampo5
	Case _cBanco == "237" // Banco Bradesco
		_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Substr(_cNumBar,06,14)
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5
	Case _cBanco == "643" // Banco PINE
		_cCampo1 := "237" + "9" + Substr(_cNumBar,20,5)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Substr(_cNumBar,06,14)
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5
	Case _cBanco == "389" // Banco Mercantil
		_cCampo1 := "389" + "9" + Strzero(Val(Alltrim(_cAgencia)),4) + Left(_cNossoNum,1)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		_cCampo4 := _cDigBar
		_cCampo5 := Substr(_cNumBar,06,14)
		_cNumBol := _cCampo1 + _cDig1 + _cCampo2 + _cDig2 + _cCampo3 + _cDig3 + _cCampo4 + _cCampo5
EndCase
Return _cNumBol

Static Function _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,_cDigBar,_cNossoDig)	// Montagem do Código de Barras

Local _cNumBar,_cNossoNu1 := _cNossoNum,_nVez
Private _cDigcor := ""
For _nVez:=1 To Len(_cNossoNum)
	If Substr(_cNossoNum,_nVez,1) == "0"
		_cNossoNu1:=Right(_cNossoNu1,Len(_cNossoNu1)-1)
	Else
		Exit
	EndIf
Next
Do Case
	Case _cBanco == "001" // Banco do Brasil
		_cCampo1 := _cBanco + "9" + _cDigBar + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + Substr(SEE->EE_CODEMP,1,6) + Substr(_cNossoNum,1,Len(Alltrim(_cNossoNum))-1) + PadL(Alltrim(_cAgencia),4,"0") + PadL(Alltrim(_cConta),8,"0") + Substr(Alltrim(SEE->EE_CODCART),2,2)
		_cNumBar := Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
	Case _cBanco == "341" // Banco Itau
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + "109" + _cNossoNum + _cNossoDig + Alltrim(_cAgencia) + 	Substr(Alltrim(_cConta),1,5) + Alltrim(_cDvCta) + "000"
		_cNumBar := Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
	Case _cBanco == "033" // Banco Santander
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO,SE1->E1_SALDO-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +If(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+If(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10) + "9" + Substr(_cCodemp,6,7) + _cNossoNum + "0" + "101"
		_cDig1bar := _fDigBar(_cCampo1,_cBanco)
		_cCampo2 :=_cBanco + "9" + _cDig1bar + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO,SE1->E1_SALDO-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +If(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+If(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10) + "9" + Substr(_cCodemp,6,7) + _cNossoNum + "0" + "101"
		_cNumBar := _cCampo2
	Case _cBanco == "399" // Banco HSBC
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDo+SE1->E1_ACRESC-SE1->E1_DECRESC,(SE1->E1_SALDo+SE1->E1_ACRESC-SE1->E1_DECRESC)-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +If(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+If(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10) + _cNossoNum + Substr(Alltrim(_cAgencia),1,4) + Substr(Alltrim(_cConta),1,5) + Alltrim(_cDvCta) + "00" + "1"
		_cDig1bar:= _fDigBar(_cCampo1,_cBanco)
		_cCampo2 := _cBanco + "9" + _cDig1bar + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((IIf(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDo+SE1->E1_ACRESC-SE1->E1_DECRESC,(SE1->E1_SALDo+SE1->E1_ACRESC-SE1->E1_DECRESC)-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +If(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+If(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10) + _cNossoNum + Substr(Alltrim(_cAgencia),1,4) + Substr(Alltrim(_cConta),1,5) + Alltrim(_cDvCta) + "00" + "1"
		_cNumBar := _cCampo2
	Case _cBanco == "422" // Banco Safra
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + "7" + Strzero(Val(Alltrim(_cAgencia)),5) + Strzero(Val(Alltrim(_cConta)),9) + _cNossoNum + _cNossoDig + "2"
		_cNumBar := Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
	Case _cBanco=="479" // Bank Boston
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + "001522060000000" + _cNossoNu1 + _cNossoDig + "8"
		_cNumBar:=Left(_cCampo1,4) + (_cDigBar:=_fDigBar1(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
	Case _cBanco == "237" // Banco Bradesco
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero((SE1->E1_VALOR + SE1->E1_ACRESC)*100,10) + Substr(_cAgencia,1,4) + Substr(SEE->EE_CODCART,2,2) + _cNossoNum + Strzero(Val(_cConta),7) + "0"
		_cNumBar := Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
	Case _cBanco == "643" // Banco PINE
		_cCampo1 := "237" + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + Substr(_cAgencia,1,4) + Substr(SEE->EE_CODCART,2,2) + _cNossoNum + Substr(_cConta,1,7) + "0"
		_cNumBar := Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
	Case _cBanco == "389" // Banco Mercantil
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + Strzero(Val(Alltrim(_cAgencia)),4) + _cNossoNum + _cNossoDig + "999999999" + "2"
		_cNumBar:=Left(_cCampo1,4) + (_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
EndCase
Return _cNumBar

Static Function _fDigVer(_cCampo,_cBanco)

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco == "347" // Banco Sudameris
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	_cCampo := PadL(_cCampo,9,"0")
	For _nVez := 1 To Len(_cCampo)
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "001" // Banco do Brasil
	_nFator := 0
	_nPeso	:= 2 
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "341" // Banco Itau
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "033" // Banco Santander
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "399" // Banco HSBC
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "422" // Banco Safra
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "479" // Bank Boston
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "237" // Banco Bradesco
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "643" // Banco PINE
	_nFator := 0
	_nPeso	:= 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
ElseIf _cBanco == "389" // Banco Mercantil
	_nFator := 0
	_nPeso	:= 2
	_nReturn:=v0
	For _nVez := Len(_cCampo) To 1 Step - 1
		_nResult := Val(Substr(_cCampo,_nVez,1)) * _nPeso
		_cResult := Strzero(_nResult,2)
		_nFator += Val(Substr(_cResult,1,1))
		_nFator += Val(Substr(_cResult,2,1))
		_nPeso := If(_nPeso == 2,1,2)
	Next
	_nReturn := mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10 - _nReturn
	EndIf
EndIf
//SEE->(DbCloseArea())   //////RAFAEL
Return Str(_nReturn,1)

Static Function _fDigBar(_cCampo,_cBanco)

Local _nVez,_nPeso,_nFator,_nResto
If _cBanco=="347" // Sudameris
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo1) to 1 Step -1
		_nFator+=Val(Substr(_cCampo1,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto==10
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="001" // Banco Do Brasil
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto>9
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="341" // Itau
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto==10.or._nResto==11
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="033" // BANESPA
	_nPeso:=2
	_nFator_ := 0
	_nFator:=0
	_nFatorAux := 0
	_nResto:=0
	_nVez:=1
	nSoma := 0
	nPeso := 2
	For w := Len(_cCampo) To 1 Step -1
		nCalc := Val(Substr(_cCampo,w,1)) * nPeso
		nSoma += nCalc
		nPeso := IIf(nPeso == 9, 2, ++nPeso)
	Next
	nSoma *= 10
	_nResto := Mod(nSoma,11)
	If _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10
		_nResto := 1
	EndIf
ElseIf _cBanco=="399" // HSBC
	_nPeso:=2
	_nFator_ := 0
	_nFator:=0
	_nFatorAux := 0
	_nResto:=0
	_nVez:=1
	nSoma := 0
	nPeso := 2
	For w := Len(_cCampo) To 1 Step -1
		nCalc := Val(Substr(_cCampo,w,1)) * nPeso
		nSoma += nCalc
		nPeso := IIf(nPeso == 9, 2, ++nPeso)
	Next
	nSoma *= 10
	_nResto := Mod(nSoma,11)
	If _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10
		_nResto := 1
	EndIf
ElseIf _cBanco=="422" // Safra
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto==10
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="479" // Boston
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto>9
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="237" // Bradesco
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto>9
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="643" // PINE
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto>9
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
ElseIf _cBanco=="389" // Mercantil
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nFator+=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto==10
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
EndIf
//SEE->(DbCloseArea()) ///////RAFAEL
Return Str(_nResto,1)

Static Function Nosso341()

Local _xDvcta     := ""
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0
If Empty(SE1->E1_NUMBCO)
	dbSelectArea("SEE")
	DbSetOrder(1)
	If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+_cSubcta,.T.)
		RecLock("SEE",.f. )
		SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,8)
		MsUnlock()
	Else
	MsgInfo("Não encontrou o registro na Tabela SEE")
	EndIf
	_xConta   	:= Alltrim(SEE->EE_CONTA)
	_xAgencia 	:= Left(SEE->EE_AGENCIA,4)
	_xCart    	:= "109"
	_xNosso_num := Right(SEE->EE_FAXATU,8)//Right(TMP->EE_FAXATU,8)
	_xVariavel	:= _xAgencia+_xConta+_xCart+_xNosso_num
	For _nVez:= Len(Alltrim(_xVariavel)) to 1 Step -1
		_nResult:=Val(Substr(_xVariavel,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
	_cRet:=_xNosso_num+str(_nReturn,1)
Else
	_cRet:=SE1->E1_NUMBCO
EndIf
Return(_cRet)

Static Function Nosso001()

Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xConvenio  := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 9
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0
If Empty(SE1->E1_NUMBCO)
	dbSelectArea("SEE")
	DbSetOrder(1)
	If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+Mv_Par04,.T.)
		RecLock("SEE",.f.)
		SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,5)
		MsUnlock()
	Else
		MsgInfo("Não encontrou o registro na Tabela SEE")
	EndIf
	_xNosso_num := Strzero(Val(Substr(SEE->EE_FAXATU,8,5)),5)
	_xConvenio := AllTrim(SEE->EE_CODEMP)
	_xVariavel	:= _xConvenio + _xNosso_num
	For _nVez:= Len(Alltrim(_xVariavel)) to 1 Step -1
		_nFator+=Val(Substr(_xVariavel,_nVez,1))*_nPeso
		_nPeso := _nPeso - 1
		If _nPeso == 1
			_nPeso :=9
		Else
			_nPeso := _nPeso
		EndIf
	Next
	_nResto:=mod(_nFator,11)
	If 	   _nResto  = 10
		_cResult := "X"
	ElseIf _nResto   = 0
		_cResult := "0"
	Else
		_nResto < 10
		_nResto := _nResto
		_cResult := Str(_nResto,1)
	EndIf
	_cRet:=_xNosso_num + _cResult
Else
	_cRet:=SE1->E1_NUMBCO
EndIf
Return(_cRet)

Static Function Nosso033()

Private cNumero	:=SPACE(12)
Private cDig	:=SPACE(01)
If Empty(SE1->E1_NUMBCO)
	dbSelectArea("SEE")
	DbSetOrder(1)
	If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+_cSubcta,.T.)
		cNumero:= Strzero(Val(Strzero(Val(SEE->EE_FAXATU),Len(SEE->EE_FAXATU))),12)
		cDig	:= NnumPlas(cNumero)
		cNumero2:= cNumero+cDig
		RecLock("SEE",.f.)
		Replace EE_FAXATU With Soma1(cNumero,Len(SEE->EE_FAXATU))
		SEE->( MsUnlock() )
	Else
		MsgInfo("Não encontrou o registro na Tabela SEE")
	EndIf
	_cRet:=cNumero2
Else
	_cRet:=SE1->E1_NUMBCO
EndIf
Return(_cRet)

Static Function NnumPlas(_cCampo)	// Peso (2 a 9) Continua processo de analise do Digito do Santander

Local _nCnt   := 0
Local _nPeso  := 2
Local _nJ     := 1
Local _nResto := 0
For _nJ := Len(_cCampo) To 1 Step -1
	_nCnt  := _nCnt + Val(Substr(_cCampo,_nJ,1))*_nPeso
	_nPeso :=_nPeso+1
	If _nPeso > 9
		_nPeso := 2
	EndIf
Next _nJ
_nResto:=(_ncnt%11)
If _nResto == 0 .or. _nResto==1
	_nDig:='0'
ElseIf _nResto == 10
	_nDig:='1'
Else
	_nResto:=11-_nResto
	_nDig:=Str(_nResto,1)
EndIf
Return(_nDig)

Static Function Nosso399()

Private cNumero	:=SPACE(12)
Private cDig	:=SPACE(01)
If Empty(SE1->E1_NUMBCO)
	cNumero := Strzero(Val(Substr(SEE->EE_FAXATU,3,10)),10)
	cDig	:= NnumPla(cNumero)
	cNumero2:= cNumero+cDig
	DbSelectArea("SEE")
	DbSetOrder(1)
	If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+"R",.T.)
		RecLock("SEE",.f.)
		Replace EE_FAXATU With Strzero(Val(Soma1(cNumero)),12)
		SEE->( MsUnlock() )
	Else
		MsgInfo("Não encontrou o registro na Tabela SEE")
	EndIf
	_cRet:=cNumero2
Else
	_cRet:=SE1->E1_NUMBCO
EndIf
Return(_cRet)

Static Function NnumPla(_cCampo)	// Pesos (2 a 7) Continua processo de analise do Digito do Hsbc

Local _nCnt   := 0
Local _nPeso  := 2
Local _nJ     := 1
Local _nResto := 0
For _nJ := Len(_cCampo) To 1 Step -1
	_nCnt  := _nCnt + Val(Substr(_cCampo,_nJ,1))*_nPeso
	_nPeso :=_nPeso+1
	If _nPeso > 7
		_nPeso := 2
	EndIf
Next _nJ
_nResto:=(_ncnt%11)
If _nResto == 0 .or. _nResto==1
	_nDig:='0'
Else
	_nResto:=11-_nResto
	_nDig:=Str(_nResto,1)
EndIf
Return(_nDig)

Static Function Nosso237()

Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _cResult    := ""
Local _nFator     := 0

DbSelectArea("SEE")
DbSetOrder(1)
If DbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta,.T.)
	RecLock("SEE",.F.)
	SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,11)
	MsUnlock()                                                        
Else
	MsgInfo("Não encontrou o registro na Tabela SEE")
EndIf

_xCart    	:= Substr(Strzero(Val(SEE->EE_CODCART),3),2,2)
_xNosso_num := Strzero(Val(SEE->EE_FAXATU),11)
_xVariavel	:= _xCart+_xNosso_num
_nPeso:=2
_nFator:=0
_nResto:=0
For _nVez:=Len(_xVariavel) to 1 Step -1
	_nFator+=Val(Substr(_xVariavel,_nVez,1))*_nPeso
	_nPeso:=If(_nPeso<7,_nPeso+1,2)
Next
_nResto:=mod(_nFator,11)
If _nResto = 1
	_cResult := "P"
ElseIf _nResto = 0
	_cResult := "0"
Else
	_nResto:=11-_nResto
	_cResult := str(_nResto,1)
EndIf
Return(_xNosso_num+_cResult)

Static Function Nosso347()

Local _xNosso_num := ""
DbSelectArea("SEE")
DbSetOrder(1)
If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+"R",.T.)
	RecLock("SEE",.f.)
	SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,7)
	MsUnlock()
Else
	MsgInfo("Não encontrou o registro na Tabela SEE")
EndIf
_xNosso_num := Strzero(Val(SEE->EE_FAXATU),7)
Return(_xNosso_num)

Static Function Nosso422()

Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _cResult    := ""
Local _nFator     := 0
DbSelectArea("SEE")
DbSetOrder(1)
If DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+"R",.T.)
	RecLock("SEE",.f.)
	SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,8)
	MsUnlock()
Else
	MsgInfo("Não encontrou o registro na Tabela SEE")
EndIf
_xNosso_num := Strzero(Val(SEE->EE_FAXATU),8)
_xVariavel	:= _xNosso_num
_nPeso  :=2
_nFator :=0
_nResto :=0
For _nVez:=Len(_xVariavel) to 1 Step -1
	_nFator+=Val(Substr(_xVariavel,_nVez,1))*_nPeso
	_nPeso:=If(_nPeso<9,_nPeso+1,2)
Next
_nResto:=mod(_nFator,11)
If _nResto = 1
	_cResult := "0"
ElseIf _nResto = 0
	_cResult := "1"
Else
	_nResto:=11-_nResto
	_cResult := str(_nResto,1)
EndIf
Return(_xNosso_num+_cResult)

Static Function Nosso389()

Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0
Local _xFaixa     := ""
DbSelectArea("SEE")
DbSetOrder(1)
If SEE->(DbSEEk(xFilial("SEE")+_cBanco+_cAgencia+_cConta+"R",.T.))
	RecLock("SEE",.f.)
	SEE->EE_FAXATU := soma1(SEE->EE_FAXATU,6)
	MsUnlock()
Else
	MsgInfo("Não encontrou o registro na Tabela SEE")
EndIf

_xNosso_num := Strzero(Val(SEE->EE_FAXATU),6)
_xCart    	:= Substr(Strzero(Val(SEE->EE_CODCART),3),2,2)
_xAgencia 	:= Strzero(Val(SEE->EE_AGENCIA),4)
_xFaixa     := "02"
_xVariavel	:= _xAgencia+_xFaixa+_xCart+_xNosso_num
For _nVez:= Len(Alltrim(_xVariavel)) to 1 Step -1
	_nFator+=Val(Substr(_xVariavel,_nVez,1))*_nPeso
	_nPeso:=If(_nPeso<9,_nPeso+1,2)
Next
_nResto:=mod(_nFator,11)
If _nResto = 1
	_cResult := "0"
ElseIf _nResto = 0
	_cResult := "0"
Else
	_nResto:=11-_nResto
	_cResult := str(_nResto,1)
EndIf
Return(_xFaixa+_xCart+_xNosso_num+_cResult)

Static Function _fDigVer1(_cNossoNum,_cAgencia,_cConta)	// Calculo do 1° Digito Verificador

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco=="347" // Sudameris
	_nFator:=0
	_nPeso:=1
	_nReturn:=0
	_cCampo:=Alltrim(Substr(_cNossoNum,1,7))+Alltrim(_cAgencia)+Alltrim(Substr(_cConta,1,7))
	For _nVez:=1 to Len(_cCampo)
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
EndIf
Return Str(_nReturn,1)

Static Function _fDigVer2(_cCampo2,_cBanco) //Calculo do 2° Digito Verificador

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco=="347" // Sudameris
	_nFator:=0
	_nPeso:=1
	_nReturn:=0
	_cCampo:=PadL(_cCampo2+_cDigt+_cCampo2_1,10,"0")
	For _nVez:=1 to Len(_cCampo)
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,2))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
ElseIf _cBanco=="033" // Santander
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	_cCampo:=_cCampo2
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	Else
		_nReturn:=0
	EndIf
ElseIf _cBanco=="399" // Hsbc
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	_cCampo:=_cCampo2
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	Else
		_nReturn:=0
	EndIf
EndIf
Return Str(_nReturn,1)

Static Function _fDigVer3(_ccampo3,_cBanco) // Calculo do 3° Digito Verificador

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco=="347" // Sudameris
	_nFator:=0
	_nPeso:=1
	_nReturn:=0
	_cCampo:="0"+_cNossoNum
	For _nVez:=1 to Len(_cCampo)
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
ElseIf _cBanco=="033" // Banespa
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	_cCampo:=_ccampo3
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
ElseIf _cBanco=="399" // Hsbc
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	_cCampo:=_ccampo3
	For _nVez:=Len(_cCampo) to 1 Step -1
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
EndIf
Return Str(_nReturn,1)

Static Function _fDigBar1(_cCampo1,_cBanco)	// Calculo do Digito Verificador Centralizador (Posicao 33 da Linha Digitavel)

Local _nVez,_nPeso,_nFator,_nResto
If _cBanco=="347" // Sudameris
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo1) to 1 Step -1
		_nFator+=Val(Substr(_cCampo1,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto==10
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
EndIf
Return Str(_nResto,1)

Static Function _fDigVer4(_cAgencia,_cConta,_cNossoNum,_cBanco)	// Calculo do 4° Digito Verificador da Linha Digitavel

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco=="033" // Banespa
	_nFator:=0
	_nPeso:=2
	_nReturn:=0
	_cCampo:=Alltrim(Substr(_cAgencia,2,3))+Alltrim(Substr(_cConta,1,2))+Alltrim(Substr(_cConta,3,8))+Alltrim(Substr(_cNossoNum,1,7))+"00"+_cBanco
	For _nVez:=1 to Len(_cCampo)
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		If _nResult > 9
			_nResult :=_nResult -9
		Else
			_cResult:=Strzero(_nResult,2)
		EndIf
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,2))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
EndIf
Return Str(_nReturn,1)

Static Function _fDigVer5(_cAgencia,_cConta,_cNossoNum,_cBanco)	// Calculo do 5° Digito Verificador da Linha Digitavel

Local _nVez,_nPeso,_nFator,_nResto,_cCampo
If _cBanco=="033" // Banespa
	_nPeso:=7
	_nFator:=0
	_nResto:=0
	_cReturn:=0
	_cDigtc3:=_fDigVer4(_cAgencia,_cConta,_cNossoNum,_cBanco)
	_cCampo:=Alltrim(Substr(_cAgencia,2,3))+Alltrim(Substr(_cConta,1,2))+Alltrim(Substr(_cConta,3,8))+Alltrim(Substr(_cNossoNum,1,7))+"00"+_cBanco+_cDigtc3
	While .T.
		For _nVez:=1 to Len(_cCampo)
			_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
			_cResult:=Strzero(_nResult,2)
			_nFator+=Val(Substr(_cResult,1,2))
			_nPeso := _nPeso - 1
			If _nPeso == 1
				_nPeso :=7
			Else
				_nPeso :=_nPeso
			EndIf
		Next
		_nReturn:=mod(_nFator,11)
		If  _nReturn==0
			_nReturn:=0
			Exit
		ElseIf _nReturn<=10 .AND. _nReturn >1
			_nReturn:=11-_nReturn
			Exit
		ElseIf _nReturn==1 .AND. _cDigtc3=="9"
			_nFator:=0
			_nResult:=0
			_cResult:=0
			_cDigcor:="0"
			_cCampo:=Alltrim(Substr(_cAgencia,2,3))+Alltrim(Substr(_cConta,1,2))+Alltrim(Substr(_cConta,3,8))+Alltrim(Substr(_cNossoNum,1,7))+"00"+_cBanco+_cDigcor
			Loop
		ElseIf _nReturn==1 .AND. _cDigtc3<"9"
			_nFator:=0
			_nResult:=0
			_cResult:=0
			_cDigtc3:=Str(Val(_cDigtc3)+1)
			_cDigcor:=_cDigtc3
			_cCampo:=Alltrim(Substr(_cAgencia,2,3))+Alltrim(Substr(_cConta,1,2))+Alltrim(Substr(_cConta,3,8))+Alltrim(Substr(_cNossoNum,1,7))+"00"+_cBanco+_cDigcor
			Loop
		EndIf
	endDo
EndIf
Return Str(_nReturn,1)

Static Function _fDigVer6(_cCampo3,_cBanco)	// Calculo do 6° Digito Verificador da Linha Digitavel

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco=="033" // Santander
	_nFator:=0
	_nPeso:=1
	_nReturn:=0
	_cCampo:=PadL(_cCampo3,10,"0")
	For _nVez:=1 to Len(_cCampo)
		_nResult:=Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult:=Strzero(_nResult,2)
		_nFator+=Val(Substr(_cResult,1,1))
		_nFator+=Val(Substr(_cResult,2,1))
		_nPeso:=If(_nPeso==2,1,2)
	Next
	_nReturn:=mod(_nFator,10)
	If _nReturn>0
		_nReturn:=10-_nReturn
	EndIf
EndIf
Return str(_nReturn,1)

Static Function _fDigBar2(_cCampo1,_cBanco)	// Calculo do Digito Verificador Centralizador (Posicao 33 da Linha Digitavel)

Local _nVez,_nPeso,_nFator,_nResto
If _cBanco=="033" // Banespa
	_nPeso:=2
	_nFator:=0
	_nResto:=0
	For _nVez:=Len(_cCampo1) to 1 Step -1
		_nFator+=Val(Substr(_cCampo1,_nVez,1))*_nPeso
		_nPeso:=If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto:=mod(_nFator,11)
	If _nResto==0.or._nResto==1.or._nResto==10
		_nResto:=1
	Else
		_nResto:=11-_nResto
	EndIf
EndIf
Return Str(_nResto,1)

Static Function _fNumBar1(_cBanco,_cAgencia,_cConta,_cNossoNum,_cDigBar)

Local _cNumBar,_cNossoNu1:=_cNossoNum,_nVez
Private _cDigcor:= ""
For _nVez:=1 to Len(_cNossoNum)
	If Substr(_cNossoNum,_nVez,1)=="0"
		_cNossoNu1:=Right(_cNossoNu1,Len(_cNossoNu1)-1)
	Else
		Exit
	EndIf
Next
Do Case
	Case _cBanco == "347" // Banco Sudameris
		_cDigt := _fDigVer1(_cNossoNum,_cAgencia,_cConta)  //Caculo Do Digitão de Cobrança
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCREA-CToD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + Substr(_cAgencia,1,4) + Substr(_cConta,1,7) + Substr(_cDigt,1) + "000000" + Substr(_cNossoNum,1,7)
		_cNumBar := Left(_cCampo1,4) + (_cDigBar := _fDigBar1(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
EndCase
Return _cNumBar
