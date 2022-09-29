#Include "topconn.ch"
#Include "aarray.ch"
#Include "json.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMOBILE    บAutor  ณJackson E. de Deus บ Data ณ  10/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerador de OS MObile                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MOBILE(aDados,cMsgRet)

/*
padrao do array aDados

1 - formulario
2 - descricao formulario
3 - codigo de atendente
4 - nome atendente
5 - patrimonio
6 - descricao patrimonio
7 - tipo maquina - snacks/bebida quente/bebida gelada
8 - tabela de preco do patrimonio
9 - data agendada
10 - hora agendada
11 - nome do cliente
12 - endereco do cliente/pa
13 - contato do cliente/pa
14 - mensagem para atendente
15 - armazem rota ou pa
16 - descricao armazem rota/pa
17 - nota fiscal
18 - serie nota fiscal
19 - tipo nf - entrada/saida
20 - cliente/fornecedor
21 - loja cliente/fornecedor
22 - Informacoes adicionais - campo/valor
23 - Modelo da maquina -
24 - PA Maquina
*/

Local cNumOS := ""
Local cNumOLD := ""
Local aaNotif1
Local aaNotif
Local cRegID := ""
Local cnPush := ""
Local cnPush2 := ""
Local cSang := "N"
Local cCont := "N"
Local cManut := "N"
Local cAbastSnck := "N"
Local cAbastBeb := "N"
Local cInvent := "N"
Local cConfCega := "N"
Local cEntrega := "N"
Local cInstMaq := "N"
Local cRemMaq := "N"
Local aMapa := {}
Local nPrat := 0
Local cMola := ""
Local nSldAnt := 0
Local nAbAnt := 0
Local nRtAnt := 0
Local nDescAnt := 0
Local nSaldoAt := 0
Local nCap := 0
Local cProd := ""
Local cDescP := ""
Local aaNotif := Nil
Local nFormAnt := 0
Local aSangria := {}
Local aLeitura := {}
Local cNf := ""
Local cSerie := ""
Local cTpDoc := ""
Local cCliFor := ""
Local cLoja := ""
Local cTipBeb := ""
Local cDirSend := "\_mobile\mobile\data_send\"
Local lMsgRet := .F.
Local aInfo := {}
Local cMailCli := ""
Local cValor := ""
Local cDesc := ""
Local nPreco := 0.0
Local cDose := ""
Local cTabela := ""
Local cCodPA := ""
Local cVlCedLaR := ""
Local cVlCedLaC := ""
Local cVlBan := ""
Local cVlGlR := ""
Local cVlGlC := ""
Local cVLog1 := ""
Local cVLog2 := ""
Local cVLog3 := ""
Local cVLog4 := ""
Local cVLog5 := ""
Local cTrocaTab := ""
Local nI
Local dInicio := stod("")
Local dFim := stod("")
Local cSenhaCnf := ""
Local cDescFrm := "" //AllTrim(aDados[2]) := ""
Local lAudit := .F.
Local cHrIniCC := ""
Local oObj,oObj2,oItem
Local aJson := {}
Local cLatitude := ""
Local cLongitude := ""

If Empty(aDados)
	Return cNumOS
EndIf

If !ValdArr(@aDados)
	Return cNumOS
EndIf


If Type("cMsgRet") == "C"
	lMsgRet := .T.
EndIf


cNf := aDados[17]
cSerie := aDados[18]
cTpDoc := aDados[19]
cCliFor := aDados[20]
cLoja := aDados[21]
aInfo := IIF(Len(aDados)>=22,Aclone(aDados[22]),{})
cCodPA	:= IIF( LEN(aDados)>=24,ALLTRIM(aDados[24]),"")

dbSelectArea("SZS")
dbSetOrder(2)
If Dbseek(xFilial("SZS")+ aDados[3]) //If msSeek( xFilial("SZS") +AvKey( aDados[3],"ZS_CODTEC" ) )
	cRegID := AllTrim(SZS->ZS_IDGCM)
EndIf

cNumOS := RetNum()

dbSelectArea("SZG")
nFormAnt := Val(aDados[1])
cDescFrm := AllTrim(aDados[2])


// posicao maquina latlng
nPos := Ascan( aInfo, { |x| x[1] == "latitude" } )
If nPos > 0
	cLatitude := aInfo[nPos][2]
EndIf

nPos := Ascan( aInfo, { |x| x[1] == "longitude" } )
If nPos > 0
	cLongitude := aInfo[nPos][2]
EndIf

// conferencia cega
If AllTrim(aDados[1]) == "01"
	cConfCega := "S"
EndIf

// leitura
If AllTrim(aDados[1]) == "02"
	cCont := "S"
EndIf

// sangria
If AllTrim(aDados[1]) == "03"
	cSang := "S"
	cCont := "S"

	If "AUDITORIA" $ Alltrim(aDados[2])
		lAudit := .T.
		cDescFrm := "SANGRIA"
	EndIf
EndIf

// abastecimento
If AllTrim(aDados[1]) == "04"
	cAbastSnck := "S"

	// formulario leitura?
	nPos := Ascan( aInfo, { |x| x[1] == "form_leitura" } )
	If nPos > 0
		cCont := aInfo[nPos][2]
	EndIf

	// formulario sangria?
	nPos := Ascan( aInfo, { |x| x[1] == "form_sangria" } )
	If nPos > 0
		cSang := aInfo[nPos][2]
	EndIf


	//cCont := "S"
	//cSang := "S"
EndIf

If AllTrim(aDados[1]) == "06"
	cManut := "S"
EndIf

// abastecimento bebidas
If AllTrim(aDados[1]) == "08"
	cAbastBeb := "S"

	// formulario leitura?
	nPos := Ascan( aInfo, { |x| x[1] == "form_leitura" } )
	If nPos > 0
		cCont := aInfo[nPos][2]
	EndIf

	// formulario sangria?
	nPos := Ascan( aInfo, { |x| x[1] == "form_sangria" } )
	If nPos > 0
		cSang := aInfo[nPos][2]
	EndIf
	//cCont := "S"
	//cSang := "S"
EndIf

// entrega
If AllTrim(aDados[1]) == "13"
	cEntrega := "S"
EndIf

// instalacao de maquina
If AllTrim(aDados[1]) == "16"
	cInstMaq := "S"
	cCont := "S"
EndIf

// remocao de maquina
If AllTrim(aDados[1]) == "17"
	cRemMaq := "S"
	cCont := "S"
EndIf

// inventario
If AllTrim(aDados[1]) == "21"
	cInvent := "S"
EndIf

// String JSON para Push
/*
aaNotif1 := Array(#)
aaNotif1[#'tag'] := "os"
aaNotif1[#'os'] := Val(cNumOS)
aaNotif1[#'operacao'] := "novo"
*/

oObj := JsonObj():New()
oObj:PutVal("tag","os")
oObj:PutVal("os",Val(cNumOS))
oObj:PutVal("operacao","novo" )


// grava em ZG_ENVIO
//aaNotif := Array(#)


oObj2 := JsonObj():New()
/*
aaNotif[#'tag']		:= "OS"
aaNotif[#'os']		:= Val(cNumOS)
aaNotif[#'atend']	:= ALLTRIM(aDados[3])
aaNotif[#'tipo']	:= IIF( !lAudit,AllTrim(aDados[2]),cDescFrm )
aaNotif[#'obj']		:= ALLTRIM(aDados[5])
aaNotif[#'dscobj']	:= ALLTRIM(aDados[6])
aaNotif[#'model']	:= IIF( LEN(aDados)>=23,ALLTRIM(aDados[23]),"")
aaNotif[#'dtag']	:= aDados[9]
aaNotif[#'hrag']	:= aDados[10]
aaNotif[#'cliente']	:= IIF( !Empty(aDados[16]),aDados[16],aDados[11] )
aaNotif[#'end']		:= ALLTRIM(aDados[12])
aaNotif[#'contato']	:= ALLTRIM(aDados[13])
aaNotif[#'obs']		:= ALLTRIM(aDados[14])
aaNotif[#'status']	:= "OPEN"
*/
oObj2:PutVal("tag","OS")
oObj2:PutVal("os",Val(cNumOS))
oObj2:PutVal("atend",AllTrim(aDados[3]))
oObj2:PutVal("tipo",IIF( !lAudit,AllTrim(aDados[2]),cDescFrm))
oObj2:PutVal("obj",ALLTRIM(aDados[5]))
oObj2:PutVal("dscobj",ALLTRIM(aDados[6]))
oObj2:PutVal("model",IIF( LEN(aDados)>=23,ALLTRIM(aDados[23]),""))
oObj2:PutVal("dtag",dtos(aDados[9]))	// corrigido aqui
oObj2:PutVal("hrag",aDados[10])
oObj2:PutVal("cliente",IIF( !Empty(aDados[16]),aDados[16],aDados[11] ))
oObj2:PutVal("end",ALLTRIM(aDados[12]))
oObj2:PutVal("contato",ALLTRIM(aDados[13]))
oObj2:PutVal("obs",ALLTRIM(aDados[14]))
oObj2:PutVal("status","OPEN")

// armazem maquina
//aaNotif[#'armazem']	:= cCodPA
oObj2:PutVal("armazem",cCodPA)

// latlng
oObj2:PutVal("latitude",cLatitude)
oObj2:PutVal("longitude",cLongitude)


// contadores
If cCont == "S"
	aJSON := {}

	//aaNotif[#'fleit'] := "S"
	oObj2:PutVal("fleit","S")

	dbSelectArea("SN1")
	dbSetOrder(2)

	//aaNotif[#'leit'] := Array(1)
	//aaNotif[#'leit'][1] := Array(#)
	oItem := JsonObj():New()

	If dbSeek( xFilial("SN1") +AvKey(aDados[5],"N1_CHAPA") )
		cTabela := SN1->N1_XTABELA
		For nI := 1 To 60
			cValor := ""
			cDesc := ""
			nPreco := 0.0
			cDose := &("SN1->N1_XP" +CVALTOCHAR(nI))
			If !Empty(cDose)
				cDesc := AllTrim( Posicione( "SB1",1,xFilial("SB1") +AvKey(cDose,"B1_COD"),"B1_DESC") )

				If !Empty(cTabela)
					nPreco := Posicione( "DA1",2,xFilial("DA1") +AvKey(cDose,"DA1_CODPRO") +AvKey(cTabela,"DA1_CODTAB"),"DA1_XPRCPP" )
				EndIf

				cValor := "P" +cvaltochar(nI) +" - " +cDesc

				// somente para maquina de bebida
				If !Empty(aDados[7]) .And. AllTrim(aDados[7]) <> "1"
					cValor += " - " +"R$" +AllTrim(Cvaltochar(Transform(nPreco,"@E 9.99")))
				EndIf
			EndIf

			//aaNotif[#'leit'][1][#'p' +cvaltochar(nI)] := cValor
			oItem:PutVal('p' +cvaltochar(nI), cValor )

		Next nI
	EndIf

	// teste
	/*
	aaNotif[#'leit'][1][#'cont_totcash'] := ""
	aaNotif[#'leit'][1][#'cont_totsale'] := ""
	aaNotif[#'leit'][1][#'cont_parcial'] := ""
	aaNotif[#'leit'][1][#'cont_testes'] := ""
	*/

	oItem:PutVal('cont_totcash', "" )
	oItem:PutVal('cont_totsale', "" )
	oItem:PutVal('cont_parcial', "" )
	oItem:PutVal('cont_testes', "" )



	// respostas P - 14/08/2017
	For nI := 1 To 60
		//aaNotif[#'leit'][1][#'cont_p' +cvaltochar(nI)] := ""
		oItem:PutVal('cont_p' +cvaltochar(nI), "" )
	Next nI

	AADD(aJson,oItem)
	oObj2:PutVal("leit",aJson)	// CORRIGIDO AQUI 23/04/2018
	aJson := {}

	// validacoes
	aContAnt := {}
	aContAnt := ContAnt(aDados[5],aDados[9])	// maq data

	//aaNotif[#'vld'] := Array(1)
	//aaNotif[#'vld'][1] := Array(#)
	oItem := JsonObj():New()
	/*
	aaNotif[#'vld'][1][#'sle'] := aContAnt[1]
	aaNotif[#'vld'][1][#'csh'] := aContAnt[2]
	aaNotif[#'vld'][1][#'tst'] := aContAnt[3]
	aaNotif[#'vld'][1][#'par'] := aContAnt[4]
	*/
	oItem:PutVal('sle',aContAnt[1] )
	oItem:PutVal('csh',aContAnt[2] )
	oItem:PutVal('tst',aContAnt[3] )
	oItem:PutVal('par',aContAnt[4] )


	For nI := 1 To 60
		//aaNotif[#'vld'][1][#'p' +cvaltochar(nI)] := aContAnt[nI+4]
		oItem:PutVal('p' +cvaltochar(nI),aContAnt[nI+4] )
	Next nI


	AADD(aJson,oItem)
	oObj2:PutVal("vld",aJson)


	// emails do cliente - recebimento das leituras
	cMailCli := AllTrim( Posicione( "SA1",1,xFilial("SA1") +AvKey(cCliFor,"A1_COD") +AvKey(cLoja,"A1_LOJA"),"A1_EMAIL" ) )

	//aaNotif[#'mailcliente'] := cMailCli
	oObj2:PutVal('mailcliente',cMailCli)
EndIf

// sangria
If cSang == "S"

	aJSON := {}
	//aaNotif[#'fsang'] := "S"
	oObj2:PutVal('fsang',"S")

	If !Empty(aSangria)
		//aaNotif[#'sang'] := Array(1)
		//aaNotif[#'sang'][1] := Array(#)
		//aaNotif[#'sang'][1][#'pos'] := 1
		//aaNotif[#'sang'][1][#'value'] := 0
	EndIf

	//aInfo := iif(len(aDados)>=22,Aclone(aDados[22]),{})
	For nI := 1 To Len( aInfo )
		If aInfo[nI][1] == "cedlacreret"
			cVlCedLaR := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "cedlacrecol"
			cVlCedLaC := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "bananinha"
			cVlBan := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "gleenviewret"
			cVlGlR := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "gleenviewcol"
			cVlGlC := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "log1"
			cVLog1 := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "log2"
			cVLog2 := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "log3"
			cVLog3 := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "log4"
			cVLog4 := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "log5"
			cVLog5 := aInfo[nI][2]
		EndIf

	Next nI
	/*
	aaNotif[#'vlds'] := Array(1)
	aaNotif[#'vlds'][1] := Array(#)
	aaNotif[#'vlds'][1][#'cedlacreret'] := cVlCedLaR
	aaNotif[#'vlds'][1][#'cedlacrecol'] := cVlCedLaC
	aaNotif[#'vlds'][1][#'bananinha'] := cVlBan
	aaNotif[#'vlds'][1][#'gleenviewret'] := cVlGlR
	aaNotif[#'vlds'][1][#'gleenviewcol'] := cVlGlC
	aaNotif[#'vlds'][1][#'log1'] := cVLog1
	aaNotif[#'vlds'][1][#'log2'] := cVLog2
	aaNotif[#'vlds'][1][#'log3'] := cVLog3
	aaNotif[#'vlds'][1][#'log4'] := cVLog4
	aaNotif[#'vlds'][1][#'log5'] := cVLog5
	*/
	oItem := JsonObj():New()
	oItem:PutVal('cedlacreret',cVlCedLaR)
	oItem:PutVal('cedlacrecol',cVlCedLaC)
	oItem:PutVal('bananinha',cVlBan)
	oItem:PutVal('gleenviewret',cVlGlR)
	oItem:PutVal('gleenviewcol',cVlGlC)
	oItem:PutVal('log1',cVLog1)
	oItem:PutVal('log2',cVLog2)
	oItem:PutVal('log3',cVLog3)
	oItem:PutVal('log4',cVLog4)
	oItem:PutVal('log5',cVLog5)

	AADD(aJSON,oItem)
	oObj2:PutVal("vlds",aJSON)

EndIf

// abastecimento de bebidas
If cAbastBeb == "S"
	cTipBeb := aDados[7]

	//aaNotif[#'fabast'] := "S"
	//aaNotif[#'tpabast'] := cTipBeb

	oObj2:PutVal("fabast","S")
	oObj2:PutVal("tpabast",cTipBeb)
EndIf

// abastecimento snacks
If cAbastSnck == "S"

	aJSON := {}

	aMapa := getMapa(aDados[5],aDados[9])
	If Empty(aMapa)
		MsgInfo("Cadastre o mapa dessa mแquina!")
		cNumOS := ""
		Return cNumOS
	EndIf

	//aaNotif[#'fabast'] := "S"
	//aaNotif[#'tpabast'] := "1"

	oObj2:PutVal("fabast","S")
	oObj2:PutVal("tpabast","1")


	//aaNotif[#'abast'] := Array(Len(aMapa))
	For nI := 1 To Len(aMapa)
		nPrat := aMapa[nI][1]
		cMola := aMapa[nI][2]
		nCap := aMapa[nI][3]
		cProd :=  aMapa[nI][4]
		cDescP :=  aMapa[nI][5]
		nPreco := aMapa[nI][6]
		nSldAnt := aMapa[nI][7]
		nAbAnt := aMapa[nI][8]
		nRtAnt := aMapa[nI][9]
		nDescAnt := aMapa[nI][10]
		nSaldoAt := aMapa[nI][11]
		/*
		aaNotif[#'abast'][nI] := Array(#)
		aaNotif[#'abast'][nI][#'bdj'] := nPrat
		aaNotif[#'abast'][nI][#'mol'] := cMola
		aaNotif[#'abast'][nI][#'cap'] := nCap
		aaNotif[#'abast'][nI][#'prod'] := cProd
		aaNotif[#'abast'][nI][#'dscprod'] := cDescP
		aaNotif[#'abast'][nI][#'prc'] := nPreco
		aaNotif[#'abast'][nI][#'sant'] := nSldAnt
		aaNotif[#'abast'][nI][#'sldant'] := nSaldoAt
		aaNotif[#'abast'][nI][#'abastant'] := nAbAnt
		aaNotif[#'abast'][nI][#'retant'] := nRtAnt
		aaNotif[#'abast'][nI][#'descant'] := nDescAnt
		*/

		oItem := JsonObj():New()

		oItem:PutVal("bdj",nPrat)
		oItem:PutVal("mol",cMola)
		oItem:PutVal("cap",nCap)
		oItem:PutVal("prod",cProd)
		oItem:PutVal("dscprod",cDescP)
		oItem:PutVal("prc",nPreco)
		oItem:PutVal("sant",nSldAnt)

		oItem:PutVal("sldant",nSaldoAt)
		oItem:PutVal("abastant",nAbAnt)
		oItem:PutVal("retant",nRtAnt)
		oItem:PutVal("descant",nDescAnt)

		AADD(aJson,oItem)

	Next nI

	oObj2:PutVal("abast",aJSON)


	// troca de tabela
	For nI := 1 To Len( aInfo )
		If aInfo[nI][1] == "trocatabela"
			cTrocaTab := aInfo[nI][2]
			Exit
		EndIf
	Next nI

	//aaNotif[#'trocatabela'] := cTrocaTab

	oObj2:PutVal("trocatabela",cTrocaTab)
EndIf

// inventario
If cInvent == "S"
	aJson := {}

	//aInfo := iif(len(aDados)>=22,Aclone(aDados[22]),{})
	For nI := 1 To Len( aInfo )

		If aInfo[nI][1] == "data_invent_inicio"
			dInicio := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "data_invent_fim"
			dFim := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "hora_inicio"
			cHrIniCC := aInfo[nI][2]
		EndIf

		If aInfo[nI][1] == "senha_conferente"
			cSenhaCnf := aInfo[nI][2]
		EndIf

	Next nI

	If Empty(cSenhaCnf)
		cSenhaCnf := getAuthC( aDados[3] )
	EndIf

	aProds := ProdInv( aDados[3],aDados[15],dInicio,dFim,cHrIniCC )
	If Empty(aProds)
		MsgInfo("Nใo foram encontrados produtos para o armaz้m!")
		cNumOS := ""
		Return cNumOS
	EndIf

	//aaNotif[#'finvent'] := "S"
	//aaNotif[#'invent'] := Array( Len( aProds ) )

	oObj2:PutVal("finvent","S")

	For nI := 1 To Len( aProds )
		/*
		aaNotif[#'invent'][nI] := Array(#)
		aaNotif[#'invent'][nI][#'prod'] := aProds[nI][1]
		aaNotif[#'invent'][nI][#'qtd'] := 0					// qtd bom -  sera preenchido na OS
		aaNotif[#'invent'][nI][#'desc'] := 0				// qtd ruim -  sera preenchido na OS
		aaNotif[#'invent'][nI][#'exced'] := 0				// excesso/devolver -  sera preenchido na OS
		aaNotif[#'invent'][nI][#'saldo'] := aProds[nI][4]	// saldo atual
		aaNotif[#'invent'][nI][#'sldavar'] := aProds[nI][5]	// total avarias
		aaNotif[#'invent'][nI][#'totfica'] := 0				// total que fica no armzem -  sera preenchido na OS
		*/

		oItem := JsonObj():New()

		oItem:PutVal("prod",aProds[nI][1])
		oItem:PutVal("qtd",0)
		oItem:PutVal("desc",0)
		oItem:PutVal("exced",0)
		oItem:PutVal("saldo",aProds[nI][4])
		oItem:PutVal("sldavar",aProds[nI][5])
		oItem:PutVal("totfica",0)

		AADD(aJSON,oitem)

	Next nI

	oObj2:PutVal("invent",aJSON)

	// senha do conferente
	//aaNotif[#'authcnf'] := cSenhaCnf
	oObj2:PutVal("authcnf",cSenhaCnf)
EndIf


// conferencia cega
If cConfCega == "S"

	aJSON := {}

	If Empty(cNf) .Or. Empty(cSerie) .Or. Empty(cCliFor) .Or. Empty(cLoja)
		cNumOS := ""
		Return cNumOS
	EndIf

	aProds := ProdConf( cNf,cSerie,cCliFor,cLoja,cTpDoc )

	If Empty(aProds)
		MsgInfo("Nใo foram encontrados produtos para essa nota fiscal!")
		cNumOS := ""
		Return cNumOS
	EndIf

	//aaNotif[#'fconfcega'] := "S"

	oObj2:PutVal("fconfcega","S")

	//aaNotif[#'conf'] := Array(Len(aProds))
	For nI := 1 To Len(aProds)
		/*
		aaNotif[#'conf'][nI] := Array(#)
		aaNotif[#'conf'][nI][#'prod'] := aProds[nI][1]
		aaNotif[#'conf'][nI][#'nome'] := aProds[nI][2]
		aaNotif[#'conf'][nI][#'qtd'] := 0					// sera preenchido na OS
		aaNotif[#'conf'][nI][#'qtdreal'] := aProds[nI][3]
		aaNotif[#'conf'][nI][#'item'] := aProds[nI][4]
		*/
		oItem := JsonObj():New()
		oItem:PutVal("prod",aProds[nI][1])
		oItem:PutVal("nome",aProds[nI][2])
		oItem:PutVal("qtd",0)
		oItem:PutVal("qtdreal",aProds[nI][3])
		oItem:PutVal("item",aProds[nI][4])

		AADD(aJSON,oItem)

	Next nI

	oObj2:PutVal("conf",aJSON)

EndIf

// entrega
If cEntrega == "S"
	//aaNotif[#'fentrega'] := "S"
	oObj2:PutVal("fentrega","S")
EndIf


// chamado
If cManut == "S"
	aJSON := {}

	//aaNotif[#'fmanut'] := "S"
	//aaNotif[#'manut'] := Array(1)
	//aaNotif[#'manut'][1] := Array(#)
	//aaNotif[#'manut'][1][#'defeito'] := ""

	oObj2:PutVal("fmanut","S")

	oItem := JsonObj():New()
	oItem:PutVal("defeito","")
	AADD(aJSON,oItem)

	oObj2:PutVal("manut",aJSON)

EndIf


// instalacao de maquina
If cInstMaq == "S"
	//aaNotif[#'finstmaq'] := "S"
	oObj2:PutVal("finstmaq","S")
EndIf

// remocao de maquina
If cRemMaq == "S"
	//aaNotif[#'fremmaq'] := "S"
	oObj2:PutVal("fremmaq","S")
EndIf




// verificar numeracao - evitar duplicidade
dbSelectArea("SZG")
dbSetOrder(1)
cNumOLD := cNumOS
While dbseek( xFilial("SZG") +AvKey(cNumOs,"ZG_NUMOS") )
	cNumOS := RetNum()
End

If cNumOS <> cNumOLD
	//aaNotif1[#'os'] := Val(cNumOS)
	//aaNotif[#'os']	:= Val(cNumOS)

	// alterar OS no objeto JSON
	oObj:PutVal("os",Val(cNumOS))
	oObj2:PutVal("os",Val(cNumOS))
EndIf


// JSON
//cNPush := ToJson(aaNotif1)
//cNPush2 := ToJson(aaNotif)

cNPush := oObj:toJSON()
cNPush2 := oObj2:toJSON()

cNPush2 := FwCutOff(cNPush2,.F.)


dbSelectArea("SZG")
RecLock("SZG",.T.)
SZG->ZG_FILIAL	:= xFilial("SZG")
SZG->ZG_NUMOS	:= cNumOS
SZG->ZG_TPFORM	:= nFormAnt
SZG->ZG_FORM	:= aDados[1]
SZG->ZG_DESCFRM	:= aDados[2]
SZG->ZG_CODTEC	:= aDados[3]
SZG->ZG_AGENTED	:= aDados[4]
SZG->ZG_DTCRIAC := Date()
SZG->ZG_HRCRIAC := Time()
SZG->ZG_DATAINI	:= aDados[9]
SZG->ZG_HORAINI	:= aDados[10]
SZG->ZG_CLIFOR	:= aDados[20]
SZG->ZG_LOJA	:= aDados[21]
SZG->ZG_DESCCF	:= aDados[11]
SZG->ZG_END		:= aDados[12]
SZG->ZG_PATRIM	:= aDados[5]
SZG->ZG_PATRIMD := aDados[6]
SZG->ZG_ROTA	:= aDados[15]
SZG->ZG_ROTAD	:= aDados[16]
SZG->ZG_MSG		:= aDados[14]
SZG->ZG_TABELA	:= aDados[8]
SZG->ZG_ENVIO	:= cNPush2
SZG->ZG_DOC		:= aDados[17]
SZG->ZG_SERIE	:= aDados[18]
SZG->ZG_TPDOC	:= cTpDoc
SZG->ZG_TPCRIAC	:= IIF( FwIsInCallStack("U_TTPROC30") .OR. FwIsInCallStack("U_AT300GRV") ,"1","2" )
SZG->ZG_IDUSR	:= __cUserID
SZG->ZG_NOVOFRM	:= .T.
SZG->ZG_STATUS	:= "OPEN"
SZG->ZG_STATUSD := "Criada"
SZG->ZG_CODEMP	:= cEmpAnt
SZG->ZG_CODFIL	:= cFilAnt
SZG->ZG_PA		:= cCodPA
SZG->( MsUnLock() )


If Empty(cRegID)
	If lMsgRet
		cMsgRet := "O aparelho do atendente nใo estแ habilitado para receber notifica็๕es push!"
	EndIf
EndIf

If !Empty(cRegID) .And. !Empty(cNPush)
	cRetEnvio := U_GOOGLE01(cRegID,cNPush)
	If "200 OK" $ cRetEnvio
		If lMsgRet
			cMsgRet := "A ordem de servi็o foi enviada para o atendente!"
		EndIf
	Else
		If lMsgRet
			cMsgRet := "Houve erro ao enviar a ordem de servi็o." +CRLF +cRetEnvio
		EndIf
	EndIf
EndIf

Return cNumOS


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProdInv  บAutor  ณMicrosiga           บ Data ณ  02/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Produtos para inventario                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProdInv( cAtendente,cArmazem,dInicio,dFim,cHrIniCC )

Local lMovel := .F.
Local cQuery := ""
Local aItens := {}
Local nQtdAvar := 0
Local cArm := ""
Local aItensAv := {}
Local nPOs := 0
Local aSec := { "001","005","007", "008", "010", "013","014", "015" ,"016", "017","036" } 	// CAFE + SNACKS
Local nI
Default dInicio := dDatabase
Default dFim := dDatabase

/*
dbSelectArea("AA1")
dbSetOrder(1)
If dbseek( xFilial("AA1") +AvKey(cAtendente,"AA1_CODTEC") )
	If AllTrim(AA1->AA1_XARMOV) == "S"
		lMovel := .T.
	EndIf
EndIf
*/

If SubStr(cArmazem,1,1) == "P"
	cArm := "A" +SubStr(cArmazem,2)
Else
	cArm := cARmazem
EndIF

/*
cQuery := "SELECT Z6_COD, B1_DESC, B1_CODBAR, Z6_QATU SALDO "
cQuery += " FROM " +RetSqlName("SZ6") + " SZ6 "
cQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON "
cQuery += " B1_COD = Z6_COD AND SB1.D_E_L_E_T_ = '' "
cQuery += " WHERE Z6_LOCAL = '"+cArm+"' AND SZ6.D_E_L_E_T_ = '' "
cQuery += " AND ( B1_XMIXENT = '1' OR Z6_QATU > 0 ) "
*/

cQuery := "SELECT B1_COD,Z6_COD, B1_DESC, B1_CODBAR, Z6_QATU SALDO "
cQuery += " FROM " +RetSqlName("SB1") + " SB1 "
cQuery += " LEFT JOIN "+RetSQLName("SZ6")+" SZ6 ON "
cQuery += " B1_COD = Z6_COD AND SZ6.D_E_L_E_T_ = '' AND Z6_LOCAL = '"+cArm+"' "
cQuery += " WHERE "
cQuery += " Z6_FILIAL = '"+xFilial("SZ6")+"' "
cQuery += " AND SB1.D_E_L_E_T_ = '' "
cQuery += " AND ( B1_XMIXENT = '1' OR Z6_QATU > 0 ) "

// LEVAR SOMENTE PRODUTOS DAS SECOES CONFIGURADAS - CONFORME CONTATO COM JORGE EM 03/08/2017
cQuery += " AND B1_XSECAO IN ( "
For nI := 1 To Len(aSec)
	cQuery += "'" +aSec[nI] + "'"
	If nI <> Len(aSec)
		cQuery += ","
	EndIf
Next nI
cQuery += " ) "


cQuery += " ORDER BY B1_XSECAO, B1_XFAMILI, B1_GRUPO, B1_DESC"	// ORDENADO POR SECAO LINHA CATEGORIA

// itens avariados apontados
aItensAv := ItensAvar( cArmazem,dInicio,dFim,cHrIniCC )

MpSysOpenQuery( cQuery,"TRBX" )
dbSelectArea("TRBX")
While !EOF()

    nQtdAvar := 0
	nPOs := Ascan( aItensAv, { |x|, AllTrim(x[1]) == AllTrim(TRBX->Z6_COD) } )
	If nPOs > 0
		nQtdAvar := aItensAv[nPOs][2]
	EndIf

    AADD( aItens, { Alltrim(TRBX->B1_COD),;
    				Alltrim(TRBX->B1_DESC),;
    				AllTrim(TRBX->B1_CODBAR),;
    				TRBX->SALDO,;
    				nQtdAvar } )
	dbSkip()
End

Return aItens


/*
// SZ7
If lMovel
	cQuery := "SELECT Z7_COD,B1_DESC,B1_CODBAR, SUM(Z7_QATU) SALDO "
	cQuery += " FROM "+RetSQLName("SZ7")+" Z7"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD = Z7_COD AND B1.D_E_L_E_T_='' "
	cQuery += " WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' AND Z7_ARMMOV = '"+cArmazem+"' "
	cQuery += " AND Z7_STATUS IN ('1','2') "
	cQuery += " AND Z7_RETORNO = '' "
	cQuery += " AND Z7.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY Z7_COD, B1_DESC,B1_CODBAR "

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	While !EOF()
	    Aadd( aItens,{ Alltrim(TRB->Z7_COD), Alltrim(TRB->B1_DESC), AllTrim(TRB->B1_CODBAR),0 } )
		DbSkip()
	EndDo

// SB2
Else
	cQuery := "SELECT B2_COD,B1_DESC,B1_CODBAR,B2_QATU,B2_QEMPSA"
	cQuery += " FROM "+RetSQLName("SB2")+" B2"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD = B2_COD AND B1.D_E_L_E_T_=''"
	cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_LOCAL='"+cArmazem+"'"
	cQuery += " AND B2.D_E_L_E_T_=''"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	While !EOF()
	    Aadd( aItens, {Alltrim(TRB->B2_COD),Alltrim(TRB->B1_DESC),AllTrim(TRB->B1_CODBAR),0 } )
		DbSkip()
	EndDo
EndIf
*/

Return aItens



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณItensAvar  บAutor  ณJackson E. de Deus บ Data ณ  12/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Itens avariados contados na PA                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ItensAvar( cArmazem,dInicio,dFim,cHrIniCC )

Local cQuery := ""
Local cArmA := ""
Local aItem := {}

// ROTA
If SubStr( cArmazem,1,1 ) == "R"
	cQuery := "SELECT Z5_COD, SUM(Z5_QUANT) TOTAL FROM " +RetSqlName("SZ5")
	cQuery += " WHERE "	//Z5_EMISSAO BETWEEN '"+DTOS(dInicio)+"' AND '"+DTOS(dFim)+"' "
	cQuery += " Z5_NUMOS IN (
	cQuery += 					" SELECT ZG_NUMOS FROM " +RetSqlName("SZG")
	cQuery += 						" WHERE ZG_ROTA = '"+cArmazem+"' AND ZG_FORM IN ('04','08') "

	// SOMENTE APOS O INICIO DO CICLO
	cQuery += 						" AND ( ( ZG_DATAFIM = '"+DTOS(dInicio)+"' AND ZG_HORAFIM > '"+cHrIniCC+"' ) "
	cQuery += 						" OR "
	cQuery += 						" ( ZG_DATAFIM BETWEEN '"+DTOS(dInicio+1)+"' AND '"+DTOS(dFim)+"' ) ) "

	cQuery += " ) "

	cQuery += " AND Z5_TIPO = 'D' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND Z5_TM = '600' "
	cQuery += " AND SUBSTRING( Z5_LOCAL,1,1 ) = 'P' "
	cQuery += " GROUP BY Z5_COD "

// PA
Else
	cArmA := "A" +SubStr( cArmazem,2 )
	cQuery := "SELECT Z5_COD, SUM(Z5_QUANT) TOTAL FROM " +RetSqlName("SZ5")
	cQuery += " WHERE "

	cQuery += " ( ( Z5_EMISSAO = '"+DTOS(dInicio)+"' AND Z5_HORA > '"+cHrIniCC+"' )
	cQuery += " OR "
	cQuery += " (  Z5_EMISSAO BETWEEN '"+DTOS(dInicio+1)+"' AND '"+DTOS(dFim)+"' ) ) "

	cQuery += " AND Z5_LOCAL = '"+cArmA+"' "
	cQuery += " AND Z5_TIPO = 'D' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND Z5_TM = '600' "
	cQuery += " GROUP BY Z5_COD "

EndIf

MpSysOpenQuery( cQuery,"TRBZ" )
dbSelectArea( "TRBZ" )

While !EOF()
	AADD( aItem, { TRBZ->Z5_COD, TRBZ->TOTAL } )
	dbSkip()
End


Return aItem




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProdConf  บAutor  ณMicrosiga           บ Data ณ  01/31/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Produtos para conferencia cega                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProdConf(cNota,cSerie,cCliFor,cLoja,cTipoDoc)

Local cQuery := ""
Local aProd := {}

If cTipoDoc == "1"
    cQuery := "SELECT "
	cQuery += "SD1.D1_ITEM, "
	cQuery += "SD1.D1_COD, "
	cQuery += "SD1.D1_QUANT, "
	cQuery += "SB1.B1_DESC, "
	cQuery += "SD1.D1_UM "

    cQuery += "FROM " +RetSqlName("SD1") +" AS SD1 "

	cQuery += "INNER JOIN " +RetSqlName("SB1") +" AS SB1 ON "
	cQuery += "SD1.D1_COD = SB1.B1_COD "
	cQuery += "AND SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_ "

	cQuery += "WHERE "

	cQuery += "SD1.D1_FILIAL		=	'"+xFilial("SD1")+"' "
	cQuery += "AND SD1.D1_DOC		=	'"+cNota+"' "
	cQuery += "AND SD1.D1_SERIE		=	'"+cSerie+"' "
	cQuery += "AND SD1.D1_FORNECE	=	'"+cCliFor+"' "
	cQuery += "AND SD1.D1_LOJA		=	'"+cLoja+"' "

	cQuery += "AND SD1.D_E_L_E_T_	=	'' "

	cQuery := ChangeQuery(cQuery)

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	TCQUERY cQuery NEW ALIAS "TRB"

	dbSelectArea("TRB")
	TRB->(dbGoTop())
	While !EOF()
		AADD(aProd, { Alltrim(TRB->D1_COD),;
					AllTrim(TRB->B1_DESC),;
					TRB->D1_QUANT,;
					AllTrim(TRB->D1_ITEM) })
		TRB->(dbSkip())
	End
	TRB->(dbCloseArea())

// nota de saida
ElseIf cTipoDoc == "2"
	cQuery := "SELECT "
	cQuery += "SD2.D2_ITEM, "
	cQuery += "SD2.D2_COD, "
	cQuery += "SD2.D2_QUANT, "
	cQuery += "SB1.B1_DESC, "
	cQuery += "SD2.D2_UM "
    cQuery += "FROM " +RetSqlName("SD2") +" AS SD2 "
	cQuery += "INNER JOIN " +RetSqlName("SB1") +" AS SB1 ON "
	cQuery += "SD2.D2_COD = SB1.B1_COD "
	cQuery += "AND SD2.D_E_L_E_T_ = SB1.D_E_L_E_T_ "
	cQuery += "WHERE "
	cQuery += "SD2.D2_FILIAL		=	'"+xFilial("SD2")+"' "
	cQuery += "AND SD2.D2_DOC		=	'"+cNota+"' "
	cQuery += "AND SD2.D2_SERIE		=	'"+cSerie+"' "
	cQuery += "AND SD2.D2_CLIENTE	=	'"+cCliFor+"' "
	cQuery += "AND SD2.D2_LOJA		=	'"+cLoja+"' "
	cQuery += "AND SD2.D_E_L_E_T_	=	'' "

	cQuery := ChangeQuery(cQuery)

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	TCQUERY cQuery NEW ALIAS "TRB"

	dbSelectArea("TRB")
	TRB->(dbGoTop())
	While !EOF()
		AADD(aProd, { Alltrim(TRB->D2_COD),;
					AllTrim(TRB->B1_DESC),;
					TRB->D2_QUANT,;
					AllTrim(TRB->D2_ITEM) })
		TRB->(dbSkip())
	End
	TRB->(dbCloseArea())
EndIf

Return aProd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณgetMapa  บAutor  ณJackson E. de Deus   บ Data ณ  01/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o mapa da maquina                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function getMapa(cPatrimo,dData)

Local cSql := ""
Local aMapa := {}
Local nSldAnt := 0
Local nPreco := 0.0
Local nAbAnt := 0
Local nRtAnt := 0
Local nDescAnt := 0
Local nSaldoAt := 0
Local cTabela := Posicione( "SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"),"N1_XTABELA" )


cSql := "SELECT * FROM SZH010 WHERE ZH_CHAPA = '"+cPatrimo+"' AND ZH_STATUS = '3' AND D_E_L_E_T_ = '' AND ZH_VERSAO <> '' ORDER BY ZH_BANDEJA, ZH_MOLA"

If Select("TRBY") > 0
	TRBY->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRBY"
dbSelectArea("TRBY")
While !EOF()
	nSldAnt := 0
	nPreco := 0.0
	nAbAnt := 0
	nRtAnt := 0
	nDescAnt := 0
	nSaldoAt := 0

	If !Empty(TRBY->ZH_CODPROD)
		nPreco := Posicione( "DA1",2,xFilial("DA1") +AvKey(TRBY->ZH_CODPROD,"DA1_CODPRO") +AvKey(cTabela,"DA1_CODTAB"),"DA1_XPRCPP" )
	EndIf

	cQuery := "SELECT TOP 2 Z0_SLDMOV,Z0_ABAST,Z0_RETIR,Z0_AVARIA,Z0_SALDO,Z0_DATA,ZG_HORAFIM  FROM "+RetSQLName("SZ0") +" SZ0 "
	cQuery += " LEFT JOIN " +RetSqlName("SZG") +" ON ZG_NUMOS = Z0_NUMOS "
	cQuery += " WHERE Z0_CHAPA = '"+cPatrimo+"' AND SZ0.D_E_L_E_T_ = '' AND Z0_DATA <= '"+DTOS(dData)+"' AND Z0_PRODUTO = '"+TRBY->ZH_CODPROD+"' "
	cQuery += " AND Z0_MOLA = '"+TRBY->ZH_MOLA+"' "
	cQuery += " ORDER BY Z0_DATA DESC "

	MPSysOpenQuery( cQuery , "TRBZ" )
	dbSelectArea("TRBZ")

	While TRBZ->(!EOF())

		If ( stod(TRBZ->Z0_DATA) == dData .And. TRBZ->ZG_HORAFIM < Time() ) .OR. stod(TRBZ->Z0_DATA) < dData

			nSldAnt := TRBZ->Z0_SLDMOV
			nAbAnt := TRBZ->Z0_ABAST
			nRtAnt := TRBZ->Z0_RETIR
			nDescAnt := TRBZ->Z0_AVARIA
			nSaldoAt := TRBZ->Z0_SALDO

			Exit
		EndIf

		TRBZ->(dbSkip())
	End


	dbSelectArea("TRBY")
	AADD( aMapa, { ALLTRIM(TRBY->ZH_BANDEJA),;
				 ALLTRIM(TRBY->ZH_MOLA),;
				  TRBY->ZH_QUANT,;
				   ALLTRIM(TRBY->ZH_CODPROD),;
				   AllTrim( Posicione("SB1",1,xFilial("SB1") +AvKey(TRBY->ZH_CODPROD,"B1_COD"),"B1_DESC" ) ),;
				   nPreco,;
				   nSldAnt,;
				   nAbAnt,;
				   nRtAnt,;
				   nDescAnt,;
				   nSaldoAt } )

	dbSkip()
End

Return aMapa


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณContAnt    บAutor  ณMicrosiga           บ Data ณ  05/17/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ContAnt(cPatrimo,dData)

Local aCont := Array(64)
Local cQuery := ""
Local cHora := Time()
Local nI
Local cBotao := ""
Local nPos := 0

aFill(aCont,0)



// consulta se tem lancamento na data de hoje
cQuery := "SELECT TOP 1 * "
cQuery += " FROM " +RetSqlName("SZN") + " SZN "
cQuery += " WHERE ZN_PATRIMO = '"+cPatrimo+"' AND ZN_DATA = '"+DTOS(dData)+"' AND ZN_HORA < '"+Substr(cHora,1,5)+"' AND D_E_L_E_T_ = '' "
cQuery += " AND ZN_TIPINCL IN ('LEITURA CF','ABASTEC','INSTALACAO','REMOCAO') AND ZN_VALIDA <> 'X' "
cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC"

MPSysOpenQuery( cQuery , "TRBZ" )

dbSelectArea("TRBZ")
If !EOF()
	aCont[1] := TRBZ->ZN_NUMATU
	aCont[2] := TRBZ->ZN_COTCASH
	aCont[3] := TRBZ->ZN_BOTTEST
	aCont[4] := TRBZ->ZN_PARCIAL

	For nI := 1 To 60
		nPos := nI+4
		cBotao := PadL( cvaltochar(nI),2,"0"  )
		aCont[nPos] := &("TRBZ->ZN_BOTAO"+CVALTOCHAR(cBotao))
	Next nI
	/*
	aCont[5] := TRBZ->ZN_BOTAO01
	aCont[6] := TRBZ->ZN_BOTAO02
	aCont[7] := TRBZ->ZN_BOTAO03
	aCont[8] := TRBZ->ZN_BOTAO04
	aCont[9] := TRBZ->ZN_BOTAO05
	aCont[10] := TRBZ->ZN_BOTAO06
	aCont[11] := TRBZ->ZN_BOTAO07
	aCont[12] := TRBZ->ZN_BOTAO08
	aCont[13] := TRBZ->ZN_BOTAO09
	aCont[14] := TRBZ->ZN_BOTAO10
	aCont[15] := TRBZ->ZN_BOTAO11
	aCont[16] := TRBZ->ZN_BOTAO12
	aCont[17] := TRBZ->ZN_BOTAO13
	aCont[18] := TRBZ->ZN_BOTAO14
	aCont[19] := TRBZ->ZN_BOTAO15
	aCont[20] := TRBZ->ZN_BOTAO16
	*/
Else
	cQuery := "SELECT TOP 1 * "
	cQuery += " FROM " +RetSqlName("SZN") + " SZN "
	cQuery += " WHERE ZN_PATRIMO = '"+cPatrimo+"' AND ZN_DATA < '"+DTOS(dData)+"' AND D_E_L_E_T_ = '' "
	cQuery += " AND ZN_TIPINCL IN ('LEITURA CF','ABASTEC','INSTALACAO','REMOCAO') AND ZN_VALIDA <> 'X' "
	cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC"

	MPSysOpenQuery( cQuery , "TRBZ" )
	dbSelectArea("TRBZ")
	If !EOF()
		aCont[1] := TRBZ->ZN_NUMATU
		aCont[2] := TRBZ->ZN_COTCASH
		aCont[3] := TRBZ->ZN_BOTTEST
		aCont[4] := TRBZ->ZN_PARCIAL

		For nI := 1 To 60
			nPos := nI+4
			cBotao := PadL( cvaltochar(nI),2,"0"  )
			aCont[nPos] := &("TRBZ->ZN_BOTAO"+CVALTOCHAR(cBotao))
		Next nI

		/*
		aCont[5] := TRBZ->ZN_BOTAO01
		aCont[6] := TRBZ->ZN_BOTAO02
		aCont[7] := TRBZ->ZN_BOTAO03
		aCont[8] := TRBZ->ZN_BOTAO04
		aCont[9] := TRBZ->ZN_BOTAO05
		aCont[10] := TRBZ->ZN_BOTAO06
		aCont[11] := TRBZ->ZN_BOTAO07
		aCont[12] := TRBZ->ZN_BOTAO08
		aCont[13] := TRBZ->ZN_BOTAO09
		aCont[14] := TRBZ->ZN_BOTAO10
		aCont[15] := TRBZ->ZN_BOTAO11
		aCont[16] := TRBZ->ZN_BOTAO12
		aCont[17] := TRBZ->ZN_BOTAO13
		aCont[18] := TRBZ->ZN_BOTAO14
		aCont[19] := TRBZ->ZN_BOTAO15
		aCont[20] := TRBZ->ZN_BOTAO16
		*/
	EndIf
EndIf


TRBZ->(dbCloseArea())


Return aCont


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMOBILE    บAutor  ณMicrosiga           บ Data ณ  05/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function getConfs()

Local aConfs := {}
Local cQuery := ""

cQuery := "SELECT AA1_CODTEC, AA1_NOMTEC FROM " +RetSqlName("AA1")
cQuery += " WHERE D_E_L_E_T_ = '' ORDER BY AA1_NOMTEC "

MPSysOpenQuery( cQuery , "TRBZ" )
dbSelectArea("TRBZ")
While !EOF()
	AADD( aConfs, { AllTrim(TRBZ->AA1_NOMTEC) } )
	dbSkip()
End

TRBZ->(dbCloseArea())


Return aConfs


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetNum   บAutor  ณJackson E. de Deus   บ Data ณ  01/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o proximo numero de OS                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetNum()

Local lVld		:= .F.
Local aArea		:= GetArea()
Local cNum		:= ""
Local cAlias	:= "SZG"
Local cCampo	:= "ZG_NUMOS"
Local cQuery	:= ""
Local lExiste	:= .F.

cQuery := "SELECT MAX(ZG_NUMOS) NUMOS FROM " +RetSqlName("SZG")
cQuery += " WHERE ZG_NOVOFRM = 'T' AND D_E_L_E_T_ = '' "

cQuery += " AND ZG_NUMOS < '000000001000000' "	// tratamento erro

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBZ"

// tratamento
If AllTrim(TRBZ->NUMOS) == "000000000999999"
	cQuery := "SELECT MAX(ZG_NUMOS) NUMOS FROM " +RetSqlName("SZG")+ " WITH(NOLOCK) "
	cQuery += " WHERE ZG_NOVOFRM = 'T' AND D_E_L_E_T_ = '' "

	cQuery += " AND ZG_NUMOS > '000000001000000' "


	If Select("TRBZ") > 0
		TRBZ->(dbCloseArea())
	EndIf

	TcQuery cQuery New Alias "TRBZ"

EndIf


cNum := SOMA1(TRBZ->NUMOS)

TRBZ->(dbCloseArea())

If Empty(cNum)
	cNum := "000000000000001"
EndIf

dbSelectArea(cAlias)
dbSetOrder(1)
dbGoTop()

While !lVld
	lExiste := VldNum(cNum)
	If lExiste
		cNum := SOMA1(cNum)
	Else
		lVld := .T.
	EndIf
End

RestArea(aArea)

Return cNum


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldNum    บAutor  ณJackson E. de Deus  บ Data ณ  04/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldNum(cNumOs)

Local lExiste := .F.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZG") + " WHERE ZG_NUMOS = '"+cNumOs+"' AND D_E_L_E_T_ = '' "

MpSysOpenQuery(cQuery,"TRB")
dbSelectArea("TRB")

If TRB->TOTAL > 0
	lExiste := .T.
EndIf
TRB->(dbCloseArea())

Return lExiste


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValdArr    บAutor  ณJackson E. de Deus บ Data ณ  29/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValdArr(aDados)


If Empty(aDados[2])
	Return .F.
EndIf

If Empty(aDados[3])
	Return .F.
EndIf

If Empty(aDados[5])
	//Return .F.
EndIf

If Empty(aDados[6])
	//Return .F.
EndIf

If Empty(aDados[9])	// data
	Return .F.
EndIf

If Empty(aDados[10])// hora
	Return .F.
EndIf

// validacao da hora
If Len(AllTrim(aDados[10])) < 8
	aDados[10] := Time()
EndIf

// observacao
/*
Tratar aqui os caracteres especiais que ferram com a estrutura do JSON
*/
aDados[14] := StrTran( aDados[14],"“","'" )
aDados[14] := StrTran( aDados[14],"”","'" )



Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMOBILE    บAutor  ณMicrosiga           บ Data ณ  05/21/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function getAuthC(cAtendente)

Local cAtendLog := SuperGetMV("MV_XMB005",.T.,"")
Local cSenha := ""

dbSelectArea("AA1")
dbSetOrder(1)
If dbseek( xFilial("AA1") +AvKey(cAtendente,"AA1_CODTEC") )
	If AllTrim(AA1->AA1_XARMOV) == "S"

		If dbseek( xFilial("AA1") +AvKey(cAtendLog,"AA1_CODTEC") )
			cSenha := AllTrim(AA1->AA1_XMAUTH)
		EndIf

	EndIf
EndIf

Return cSenha