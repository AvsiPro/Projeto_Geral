#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQFTFIN02  บAutor  ณMicrosiga           บ Data ณ  07/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  importar titulos a pagar atraves de arquivo csv.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION QFTFIN01()

	Local cLinha  := ""
	Local cArqAux := ""
	Local cProd    := ""
	Local cDoc  := ""
	Local cPedido := ""
	Local cFil := ""
	Local cCondPg := ""
	Local cDtEmis := ''
	Local lPrim   := .T.
	Local lOk     := .T.
	Local aDocs     := {}
	Local aCampos := {}
	Local aDados  := {}
	Local cDocImp := ""	
	Local lSc1 := .F.
	Local cDiretorio:= ""
	Local cArq		:= ""
	Local oLog
	Local cNameFile := ""
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
		MsgStop("O arquivo " +cArqAux + " nใo foi encontrado. A importa็ใo serแ abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArqAux)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()

		IncProc("Lendo arquivo ...")

		cLinha := FT_FREADLN()

		If lPrim
			//Campos do cabe็alho
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

	For nI := 1 to Len(aDados)
		cLine	:= FT_FReadLn() // Retorna a linha corrente
		aAux    := StrTokArr(cLine,";")

		aArray := { { "E2_PREFIXO"  ,	"PLU"        	, NIL },; //3
			{ "E2_NUM"      , 	Strzero(val(aDados[nI][3]),9)   	, NIL },;
			{ "E2_PARCELA"  , 	Strzero(val(aDados[nI][4]),2)		, NIL },;//2
			{ "E2_TIPO"     , 	Padr(aDados[nI][5],3)    	 	, NIL },; //3
			{ "E2_NATUREZ"  ,	Padr(aDados[nI][6],10)         , NIL },; //10
			{ "E2_FORNECE"  ,	Padr(aDados[nI][7],14)	 		, NIL },; //14
			{ "E2_LOJA"  	,	Padr(strzero(val(aDados[nI][8]),2),4) 		, NIL },; //4
			{ "E2_EMISSAO"  , CtoD(aDados[nI][9])	, NIL },;
			{ "E2_VENCTO"   , CtoD(aDados[nI][10])	, NIL },;
			{ "E2_VENCREA"  , datavalida(CtoD(aDados[nI][11]))	, NIL },;
			{ "E2_VALOR"    , val(aDados[nI][12])       	, NIL },;
			{ "E2_FILORIG"    , Strzero(val(aDados[nI][1]),4)     	, NIL },; //4
			{ "E2_HIST"    	, Padr(aDados[nI][3],40)     	, NIL }} //40

		lMsErroAuto := .F.
		DbSelectArea("SE2")
		DbSetOrder(1)
		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		//If !DbSeek(xFilial("SE2")+Avkey("PLU","E2_PREFIXO")+Avkey(Strzero(val(aDados[nI][3]),9),"E2_NUM")+Avkey(Strzero(val(aDados[nI][4]),2),"E2_PARCELA")+Avkey(Padr(aDados[nI][5],3),"E2_TIPO")+Avkey(Padr(aDados[nI][7],14),"E2_FORNECE")+Avkey(PadR(strzero(val(aDados[nI][8]),2),4),"E2_LOJA"))
		If !DbSeek(xFilial("SE2")+"PLU"+Strzero(val(aDados[nI][3]),9)+Strzero(val(aDados[nI][4]),2)+Padr(aDados[nI][5],3)+Padr(aDados[nI][7],14)+PadR(strzero(val(aDados[nI][8]),2),4))
			Begin Transaction
				MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)   // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo

				If lMsErroAuto
					MostraErro()
				//Else
				//	Alert("Tํtulo incluํdo com sucesso!")
				Endif
			End Transaction
		End

	Next nI

	//End Transaction
Return

