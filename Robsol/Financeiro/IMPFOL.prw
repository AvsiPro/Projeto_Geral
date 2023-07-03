#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPFOL   บAutor  ณRodrigo Barreto   บ Data ณ  20/01/2023   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta csv para gerar tabela ZZ1 e SE2 para tํtulos de folhaบฑฑ
ฑฑบ          ณ										                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RobSol                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION IMPFOL()

	Local aArea    := GetArea()
	Local nI,nZ := 0
	Local cLinha  := ""
	Local cArqAux := ""
	Local cCgc   := ""
	Local cIdTit, cTipo, cNaturez, cCodFor	 := ""
	Local aAuxEv := {}
	Local ARATEZ := {} //rateio da natureza
	Local aRatEvEz := {}
	Local nValor := 0
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	lOCAL aAuxZZ1 := {}
	Private aVcto   := {}
	Private lMsErroAuto := .F.

	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0201"

	//Chamando o cGetFile para pegar um arquivo txt ou xml, mostrando o servidor
	cArqAux := cGetFile( 'Arquivo *.csv|*.csv ',; //[ cMascara],
		'Selecao de Arquivos',;                  //[ cTitulo],
		0,;                                      //[ nMascpadrao],
		'C:\',;  	                              //[ cDirinicial],
		.F.,;                                    //[ lSalvar],
		GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
		.T.)                                     //[ lArvore]

	If !File(cArqAux)
		MsgStop("O arquivo " +cArqAux + " nรฃo foi encontrado. A importaรงรฃo serรก abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArqAux)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()

		IncProc("Lendo arquivo ...")

		cLinha := FT_FREADLN()

		If lPrim
			//Campos do cabeรงalho
			aCampos := Separa(cLinha,";",.T.)
			//ajuste de log
			//cDiretorio := Left(cArqAux,RAT("\",cArqAux))	//ajuste log
			//cArq := Right(cArqAux,Len(cArqAux)-Len(cDiretorio)) //ajuste log
			//oLog := SCLogger():New(cDiretorio, cArq,.T.)	//-- Objeto de Log.

			lPrim := .F.
		Else
			//Itens
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo
	lPrim := .T.

	For nI := 1 to Len(aDados)
		cLine	:= FT_FReadLn() // Retorna a linha corrente
		aAux    := StrTokArr(cLine,";")

		If nI < 2
			cFilant := PADL(aDados[nI][9],4,"0")
		EndIf
		cCgc := aDados[nI][2]
		cCgc := NewCGCCPF(cCgc)
		cCgc := PADL(cCgc,11,"0")

		If lPrim
			cIdTit := dtos(date()) + substr(cfilant,4,1)//PADL(aDados[nI][6],9,"0")
			cNaturez :=  aDados[nI][7]
			dDtVenc := CtoD(aDados[nI][5])
			lPrim := .F.

			If dDtVenc < DATE()
				Alert("Data de vencimento no arquivo nใo poderแ ser inferior a data base do sistema. Corrija seu arquivo.")
				Return Nil
			EndIf

			If cFilant == "0103"
				cCodFor := "FOLHAMG  "
			Else
				cCodFor := "FOLHA    "
			EndIf
		EndIf

		DbSelectArea("SA2")
		dbSetOrder(3)
		//aAuxA2 := GetAdvFVal("SA2", { "A2_NOME", "A2_CGC","A2_END", "A2_BAIRRO","A2_CEP", "A2_MUN", "A2_EST", "A2_BANCO", "A2_AGENCIA", "A2_DVAGE", "A2_DVCTA"	, "A2_NUMCON"  },;
		//							  xFilial("SA2")+cCgc , 3, { "", "", "", "", "", "", "", "", "","","","" })
		//A2_FILIAL+A2_CGC
		IF dbSeek(xFilial('SA2')+ PADR(cCgc,15))     // Filial: 01 / C๓digo: 000001 / Loja: 02
			aAuxA2 :={SA2->A2_NOME, SA2->A2_CGC, SA2->A2_END,SA2->A2_BAIRRO,SA2->A2_CEP,SA2->A2_MUN,;
				SA2->A2_EST, SA2->A2_BANCO, SA2->A2_AGENCIA, SA2->A2_DVAGE, SA2->A2_DVCTA, SA2->A2_NUMCON}

			aArray := { "FOL" , 	Strzero(val(aDados[nI][3]),9) ,	Strzero(val(aDados[nI][4]),2) ,;
				"FOL" , alltrim(aAuxA2[1]),  alltrim(aAuxA2[2]),;
				alltrim(aAuxA2[3]), alltrim(aAuxA2[4]),	 aAuxA2[5],;
				alltrim(aAuxA2[6]), aAuxA2[7], CtoD(aDados[nI][5]),;
				Val(StrTran(aDados[nI][6],",",".")), aAuxA2[8],	aAuxA2[9],;
				aAuxA2[10], aAuxA2[12], aAuxA2[11],aDados[nI][8] }

			AADD(aAuxZZ1,aArray)

			lMsErroAuto := .F.

		Else
			MsgInfo("CPF:"+cCgc+". Na linha" + CValToChar(nI)+" nใo localizado.")
			Return
		EndIf

	Next nI
	aAuxEz:={}
	DbSelectArea("ZZ1")
	DBSetOrder(1)
	For nZ := 1 to Len(aAuxZZ1)

		aAuxEz:={} //recebe centro de custo e valor para rateio

		//ZZ1_FILIAL+ZZ1_PREFIX+ZZ1_NUM+ZZ1_PARCE+ZZ1_TIPO+ZZ1_CGC
		If !DbSeek(xFilial("ZZ1")+aAuxZZ1[nZ,1]+aAuxZZ1[nZ,2]+substr(alltrim(aAuxZZ1[nZ,3]),1,1)+aAuxZZ1[nZ,4]+aAuxZZ1[nZ,6])
			RecLock("ZZ1", .T.)
			ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
			ZZ1->ZZ1_PREFIX := aAuxZZ1[nZ,1]
			ZZ1->ZZ1_NUM := aAuxZZ1[nZ,2]
			ZZ1->ZZ1_PARCE := aAuxZZ1[nZ,3]
			ZZ1->ZZ1_TIPO := aAuxZZ1[nZ,4]
			ZZ1->ZZ1_BANCO := aAuxZZ1[nZ,14]
			ZZ1->ZZ1_AGEN := aAuxZZ1[nZ,15]
			ZZ1->ZZ1_DGAGE := aAuxZZ1[nZ,16]
			ZZ1->ZZ1_CONTA := aAuxZZ1[nZ,17]
			ZZ1->ZZ1_DGCONT := aAuxZZ1[nZ,18]
			ZZ1->ZZ1_CGC := aAuxZZ1[nZ,6]
			ZZ1->ZZ1_NOME := aAuxZZ1[nZ,5]
			ZZ1->ZZ1_DTVENC := aAuxZZ1[nZ,12]
			ZZ1->ZZ1_VALOR := aAuxZZ1[nZ,13]
			ZZ1->ZZ1_FISJUR := "F"
			ZZ1->ZZ1_END := ALLTRIM(aAuxZZ1[nZ,7])
			ZZ1->ZZ1_BAIRRO := ALLTRIM(aAuxZZ1[nZ,8])
			ZZ1->ZZ1_MUN :=  ALLTRIM(aAuxZZ1[nZ,10])
			ZZ1->ZZ1_CEP :=  ALLTRIM(aAuxZZ1[nZ,9])
			ZZ1->ZZ1_EST := ALLTRIM(aAuxZZ1[nZ,11])
			ZZ1->ZZ1_ID := Strzero(val(cIdTit),9)

			nValor += aAuxZZ1[nZ,13]

			cCentro := alltrim(aAuxZZ1[nZ,19])
			//
			nPos := aScan(aRatEz, {|x| AllTrim(Upper(x[1][2])) == cCentro})
			If nPos == 0
				//CENTRO DE CUSTO
				aadd( aAuxEz ,{"EZ_CCUSTO" , aAuxZZ1[nZ,19], Nil })//centro de custo da natureza
				aadd( aAuxEz ,{"EZ_VALOR" , aAuxZZ1[nZ,13] , Nil })//valor do rateio neste centro de custo
				aadd(aRatEz,aAuxEz)
			Else
				aRatez[nPos][2][2] += aAuxZZ1[nZ,13]
			Endif
			MsUnLock() // Confirma e finaliza a opera็ใo
		
		else
			alert("Titulo duplicado, verifique as informa็๕es na planilha")
			return nil 
		EndIf

	Next nZ

	aArray := {}
	aadd( aArray , { "E2_PREFIXO"  ,	"FOL"        	, NIL })
	aadd( aArray , { "E2_NUM"      , 	Strzero(val(cIdTit),9)	, NIL })
	aadd( aArray , { "E2_PARCELA"  , 	"  "		, NIL })
	aadd( aArray , { "E2_TIPO"     , 	"FOL"    	 	, NIL })
	aadd( aArray , { "E2_NATUREZ"  ,	cNaturez         , NIL })
	aadd( aArray , { "E2_FORNECE"  ,	cCodFor	 		, NIL   })
	aadd( aArray , { "E2_LOJA"  	,	"0001" 		, NIL })
	aadd( aArray , { "E2_EMISSAO"  , DATE()	, NIL })
	aadd( aArray , { "E2_VENCTO"   , dDtVenc	, NIL })
	aadd( aArray , { "E2_VENCREA"  , datavalida(dDtVenc)	, NIL })
	aadd( aArray , { "E2_VALOR"    , nValor       	, NIL })
	aadd( aArray , { "E2_MULTNAT" , '1' , Nil })

	//#########################################################################################################&
	//Adicionando o vetor da 1บ Natureza &
	//#########################################################################################################&

	aadd( aAuxEv ,{"EV_NATUREZ" , padr(cNaturez,tamsx3("EV_NATUREZ")[1]), Nil })//natureza a ser rateada
	aadd( aAuxEv ,{"EV_VALOR" , nValor, Nil })//valor do rateio na natureza
	aadd( aAuxEv ,{"EV_PERC" , "100", Nil })//percentual do rateio na natureza
	aadd( aAuxEv ,{"EV_RATEICC" , "1", Nil })//indicando que hแ rateio por centro de custo

	aadd(aAuxEv,{"AUTRATEICC" , aRatEz, Nil })//recebendo dentro do array da natureza os multiplos centros de custo
	aAdd(aRatEvEz,aAuxEv)//adicionando a natureza ao rateio de multiplas naturezas

	aAdd(aArray,{"AUTRATEEV", aRatEvEz,Nil})//adicionando ao vetor aCab o vetor do rateio

	lMsErroAuto := .F.
	DbSelectArea("SE2")
	DbSetOrder(1)
	//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	//If !DbSeek(xFilial("SE2")+Avkey("PLU","E2_PREFIXO")+Avkey(Strzero(val(aDados[nI][3]),9),"E2_NUM")+Avkey(Strzero(val(aDados[nI][4]),2),"E2_PARCELA")+Avkey(Padr(aDados[nI][5],3),"E2_TIPO")+Avkey(Padr(aDados[nI][7],14),"E2_FORNECE")+Avkey(PadR(strzero(val(aDados[nI][8]),2),4),"E2_LOJA"))
	If !DbSeek(xFilial("SE2")+"FOL"+cIdTit+"  "+"FOL"+cCodFor+"0001")
		Begin Transaction
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)   // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo

			If lMsErroAuto
				MostraErro()
				//Else
				//	Alert("Tํtulo incluํdo com sucesso!")

			Endif
		End Transaction
	EndIf

	SE2->(DBCloseArea())
	ZZ1->(DBCloseArea())
	SA2->(DBCloseArea())
	RestArea(aArea)

Return

//----------------------------------------------------------
// Funcao Auxiliar para retirar a mแscara do campo CNPJ/CPF:
//----------------------------------------------------------
Static Function NewCGCCPF(cCGCCPF)

Local aInvChar := {"/",".","-"}
Local nI

For nI:=1 to Len(aInvChar)
     cCGCCPF := StrTran(cCGCCPF,aInvChar[nI])
Next

Return cCGCCPF
