#include 'protheus.ch'
#include 'parmtype.ch'
#include 'tbiconn.ch'
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQFTFIN02  บAutor  ณMicrosiga           บ Data ณ  07/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  importar titulos a receber atraves de arquivo csv.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION QFTFIN02()

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
    Local lMsErroAuto := .F.
    Local lSc1 := .F.
    Local cDiretorio:= ""
    Local cArq		:= ""
    Local oLog
    Local cNameFile := ""
    Private aVcto   := {}


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

        aArray := { { "E1_PREFIXO"  , "PLU"/*aDados[nI][1]*/             		, NIL },;
            { "E1_NUM"      , Strzero(val(aDados[nI][2]),9) 	            , NIL },;
            { "E1_PARCELA"	, Strzero(val(aDados[nI][3]),2)					, NIL },;
            { "E1_TIPO"     , Padr(aDados[nI][4],3)             		, NIL },;
            { "E1_NATUREZ"  , Padr(aDados[nI][5],10)            		, NIL },;
            { "E1_CLIENTE"  , Padr(aDados[nI][6],14)         			, NIL },;
            { "E1_LOJA"  	, strzero(val(aDados[nI][7]),4)         		, NIL },;
            { "E1_EMISSAO"  , dDatabase				, NIL },;
            { "E1_VENCTO"   , CtoD(aDados[nI][9])			, NIL },;
            { "E1_VENCREA"  , CtoD(aDados[nI][10])			, NIL },;
            { "E1_VALOR"    , val(aDados[nI][11])           	, NIL }}
        //{ "E1_VLCRUZ"   , val(aDados[nI][11])           	, NIL }}//,;

        /*	            { "E1_FILORIG"  , "0101" 		           	, NIL },;
				{ "E1_MSEMP"  , "01" 		           	, NIL },;
                { "E1_MSFIL"  , "0101" 		           	, NIL }}*/

	lMsErroAuto := .F.
	DbSelectArea("SE1")
	DbSetOrder(2)
	If !DbSeek(xFilial("SE1")+Avkey(aDados[nI][6] ,"E1_CLIENTE")+Avkey(strzero(val(aDados[nI][7]),4),"E1_LOJA")+Avkey(aDados[nI][1],"E1_PREFIXO")+Avkey(Strzero(val(aDados[nI][2]),9),"E1_NUM")+Avkey(aDados[nI][3],"E1_PARCELA")+Avkey(aDados[nI][4],"E1_TIPO"))
    Begin Transaction

	MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Altera็ใo, 5 - Exclusใo

		If lMsErroAuto
		    //MostraErro()
		    MostraErro('C:\TEMP\BKP\log\',strzero(val(aAux[2]),9)+".log")
		    lMsErroAuto := .F.
            DisarmTransaction()
		Else
		   //Alert("Tํtulo incluํdo com sucesso!")
		Endif
        End Transaction
    EndIf

    Next nI

Return
