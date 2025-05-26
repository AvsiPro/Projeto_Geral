#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

/*/{Protheus.doc} U_SFINA080
description Baixa títulos a Pagar via Planilha CSV
@type function
@version 
@author Roni Silva
@since 05/2022
@return return_type, return_description
/*/
USER function SFINA080()

	LOCAL cCadastro := "Baixar Titulos a Pagar via CSV"
	LOCAL cExt      := "Arquivo CSV | *.CSV"
	LOCAL cPath     := ""
	LOCAL cFileLog  := ""

	LOCAL lOpc      := .F.
	LOCAL lErro     := .F.

	LOCAL oTButton1 := NIL
	LOCAL oTButton2 := NIL

	LOCAL aPadrao   := {}

	PRIVATE cArq     := SPACE(250)
	PRIVATE cDirDest := ""
	PRIVATE oDlg     := NIL
	PRIVATE oArq     := NIL

	PRIVATE lAutoErrNoFile := .F.
	PRIVATE	lMsErroAuto    := .F.
	PRIVATE lMsHelpAuto	   := .T.

	//Carrega layout padrao da Planilha
	AADD( aPadrao, { "Filial"         , "" } )
	AADD( aPadrao, { "Prefixo"        , "" } )
	AADD( aPadrao, { "No. Titulo"     , "" } )
	AADD( aPadrao, { "Parcela"        , "" } )
	AADD( aPadrao, { "Tipo"           , "" } )
	AADD( aPadrao, { "Natureza"       , "" } )
	AADD( aPadrao, { "Portador"       , "" } )
	AADD( aPadrao, { "Fornecedor"     , "" } )
	AADD( aPadrao, { "Loja"           , "" } )
	AADD( aPadrao, { "Nome Fornece"   , "" } )
	AADD( aPadrao, { "DT Emissao"     , "" } )
	AADD( aPadrao, { "Vencimento"     , "" } )
	AADD( aPadrao, { "Vencto Real"    , "" } )
	AADD( aPadrao, { "Vlr.Titulo"     , "E2_VALOR" } )
	AADD( aPadrao, { "ISS"            , "" } )
	AADD( aPadrao, { "IRRF"           , "" } )
	AADD( aPadrao, { "DT Baixa"       , "" } ) //RONI SILVA
	AADD( aPadrao, { "Historico"      , "" } )
	AADD( aPadrao, { "Saldo"          , "E2_SALDO" } ) //RONI SILVA

	//Gera Diretorio de Log
	cDirDest := "C:\Protheus"	//"\log_cli"
	if !EXISTDIR(cDirDest)
		if MAKEDIR(cDirDest) <> 0
			MSGSTOP( "Não foi possivel criar o diretorio '" + cDirDest + "' ", "Processo Cancelado", "BAIXACSV" )
			return(.T.)
		endif
	endif

	cDirDest += "\Logs"	//"\log_cli"
	if !EXISTDIR(cDirDest)
		if MAKEDIR(cDirDest) <> 0
			MSGSTOP( "Não foi possivel criar o diretorio '" + cDirDest + "' ", "Processo Cancelado", "BAIXACSV" )
			return(.T.)
		endif
	endif

	//DefiniÃ§Ã£o da janela e seus conteÃºdos
	DEFINE MSDIALOG oDlg TITLE cCadastro from 0,0 to 219,552 of oDlg pixel

	@ 006,006 to 048,271 of oDlg pixel

	@ 015,015 say " Este programa ira ler o conteudo de um arquivo  CSV, conforme informações fornecidas" of oDlg pixel
	@ 025,015 say " pelo usuario, com os dados para fazer a Baixa Manual do Titulos a Pagar.            " of oDlg pixel
	@ 035,015 say "                                                                                     " of oDlg pixel

	@ 060,007 say "Nome Arquivo"     SIZE 050,010 of oDlg pixel

	@ 057,050 MSGET oArq      var cArq     Picture "@!"                         SIZE 205,007 pixel of oDlg
	@ 057,257 BUTTON "..."                                                      SIZE 013,010 pixel of oDlg ;
		ACTION cArq := ALLTRIM(CGETFILE(cExt,SUBSTR(cExt,1,12),,,.T.,GETF_LOCALHARD))

	//Botoes da MSDialog
	oTButton1 := TBUTTON():CREATE( oDlg,075,195,"Confirmar",{|| lOpc := Confirma(), IIf( lOpc, oDlg:END(), "") } ,36,16,,,,.T.,,,,,,)
	oTButton2 := TBUTTON():CREATE( oDlg,075,235,"Cancelar" ,{|| lOpc := .F., oDlg:END()                        } ,36,16,,,,.T.,,,,,,)

	activate MSDIALOG oDlg center

	if lOpc

		//Valida a Existencia do Arquivo
		if !FILE(cArq)
			MSSALERT("Arquivo texto: " + ALLTRIM(cArq) + " não localizado",cCadastro)
			return()
		endif

		AUTOGRLOG("INICIANDO O LOG de Baixa Automática a Pagar via CSV")
		AUTOGRLOG(REPLICATE("-",90))

//RONI SILVA		MSGRUN("Aguarde, Validando Estrutura Tabela (CSV)....",,{|| lErro := fValidCSV(aPadrao) })

		if lErro
			cFileLog := NOMEAUTOLOG()
			if cFileLog <> ""
				MOSTRAERRO(cPath,cFileLog)
			endif

			//Fecha Arquivo de Log
			//cFileLog := NomeAutoLog()
			if FILE(cFileLog)
				FERASE(cFileLog)
			endif

			return()
		endIf
		MSGRUN("Aguarde, Validando Dados da Tabela (CSV)....",,{|| lErro := fValidDAD(aPadrao) })

		if lErro
			cFileLog := NOMEAUTOLOG()
			if cFileLog <> ""
				MOSTRAERRO(cPath,cFileLog)
			endif

			//Fecha Arquivo de Log
			//cFileLog := NomeAutoLog()
			if FILE(cFileLog)
				FERASE(cFileLog)
			endif

//			return() //RONI SILVA

		endIf

		MSGRUN("Aguarde, Baixando Tí­tulos a Pagar via CSV....",,{|| lErro := fBaixaSE2(aPadrao) })

		if lErro <> NIL
			if !lErro
				MSGINFO( "Baixas a Pagar via CSV, Finanlizada com Sucesso !!!" + CRLF + CRLF +;
					"Verifique o arquivo .TXT gerado na pasta 'C:/PROTHEUS/LOG'", "Aviso" )
			else
				MSGINFO( "Ocorreram Problemas nas Baixas a Pagar via CSV !!!" + CRLF + CRLF +;
					"Verifique o arquivo .TXT gerado na pasta 'C:/PROTHEUS/LOG'", "Aviso" )
			endif
		endif

	endIf

return()


/*/{Protheus.doc} Confirma
description Verifica se o Arquivo CSV foi informado
@type function
@version 
@author Roni Silva
@since 05/2022
@return return_type, return_description
/*/
STATIC function Confirma()

	LOCAL lRet  := .T.

	if lRet .and. EMPTY(cArq)
		MSGALERT("Falta Informar Arquivo CSV", "Atenção")
		oArq:SETFOCUS()
		lRet := .F.
	endIf

return(lRet)


/*/{Protheus.doc} fValidCSV
description Valida Planilha CSV
@type function
@version 
@author Roni Silva
@since 05/2022
@param aPadrao, array, param_description
@return return_type, return_description
/*/
STATIC function fValidCSV(aPadrao)

	LOCAL cBuffer := ""
	LOCAL cImport := ""
	LOCAL cCampo  := ""
	LOCAL lRet    := .F.

	LOCAL nLin    := 0
	LOCAL nPos    := 0
	LOCAL nX      := 0
	LOCAL i       := 0
	LOCAL aImport := {}

	//Le Planilha
	FT_FUSE(cArq)
	FT_FGOTOP()
	FT_FSKIP(2)

	cBuffer := FT_FREADLN()

	nLin++

	cImport := STRTRAN(cBuffer,chr(10),"")

	//aImport := STRTOKARR(cImport, ";")

	while !EMPTY(cImport)

		i := AT(";",cImport)

		if i > 0
			cCampo := LEFT(cImport,i-1)
			AADD( aImport, FwNoAccent( ALLTRIM(cCampo) ) )
			cImport := SUBSTR(cImport,i+1)
		else
			cCampo := cImport
			AADD( aImport, FwNoAccent( ALLTRIM(cCampo) ) )
			cImport := ""
		endif
	enddo

	if !lRet
		//Valida a quantidade de Colunas
		if LEN(aPadrao) > LEN(aImport)
			AUTOGRLOG("O Numero das Colunas da Planilha nao conefere com o Padrao")
			AUTOGRLOG(REPLICATE("-",90))
			lRet := .T.
		endif
	endif

	if !lRet
		//Valida colunas existentes na Planilha
		for nX := 1 to LEN(aImport)

			nPos := ASCAN( aPadrao, { |x| UPPER( ALLTRIM( x[1] ) ) == UPPER( ALLTRIM( aImport[nX] ) ) } )

			if nPos == 0
				AUTOGRLOG("Coluna com Nome " + ALLTRIM(aImport[nX]) + " Nao econtrado na Planilha Padrao")
				AUTOGRLOG(REPLICATE("-",90))
				lRet := .T.
			endif

		next nX
	endif

	if !lRet
		//Valida posiÃ§Ã£o dos campos na Planilha
		for nX := 1 to LEN(aImport)

			nPos := ASCAN( aPadrao, { |x| UPPER( ALLTRIM( x[1] ) ) == UPPER( ALLTRIM( aImport[nX] ) ) } )

			if nPos <> nX
				AUTOGRLOG("Coluna com Nome " + ALLTRIM(aImport[nX]) + " Em posição Diferente do Padrão")
				AUTOGRLOG(REPLICATE("-",90))
				lRet := .T.
			endif

		next nX
	endif

return(lRet)


/*/{Protheus.doc} fValidDAD
description Valida od dados da Planilha
@type function
@version 
@author Roni Silva
@since 05/2022
@param aPadrao, array, param_description
@return return_type, return_description
/*/
static function fValidDAD(aPadrao)

	LOCAL cBuffer    := ""
	LOCAL cImport    := ""
	LOCAL cCampo     := ""
	LOCAL cConteudo  := ""
	LOCAL cC5XNSU    := ""
	LOCAL cE5PARCELA := ""
	LOCAL cE5DATA    := ""
	LOCAL cE5BANCO   := ""
	LOCAL cE5AGENCIA := ""
	LOCAL cE5CONTA   := ""
	LOCAL cTipoMvt   := ""

	LOCAL lRet       := .F.

	LOCAL nE5VALOR   := 0
	LOCAL nLin       := 0
	LOCAL nX         := 0

	LOCAL aImport := {}
	LOCAL aCampos := {}

	//Le Planilha
	FT_FUSE(cArq)
	FT_FGOTOP()

	while !FT_FEOF()

		cCampo  := ""
		aImport := {}

		//Capturar dados
		cBuffer := FT_FREADLN()

		cImport := STRTRAN(cBuffer,CHR(10),"")

		if EMPTY(cImport) .or. SUBSTR(cImport,1,1) == ";" .or. SUBSTR(cImport,1,1) <> "0"
			FT_FSKIP()
			loop
		endif

		nLin++

		//aImport := STRTOKARR(cImport, ";")

		while !EMPTY(cImport)
			i := AT(";",cImport)
			if i > 0
				cCampo := UPPER(LEFT(cImport,i-1))
				AADD( aImport, ALLTRIM(cCampo) )
				cImport := SUBSTR(cImport,i+1)
			else
				cCampo := UPPER(cImport)
				AADD( aImport, ALLTRIM(cCampo) )
				cImport := ""
			endif
		enddo

			aCampos := ACLONE(aImport)

		//Valida Campos da Planilha
		for nX := 1 to 19

			cCampo    := ALLTRIM( aPadrao[nX][2] )
			cConteudo := ALLTRIM( aImport[nX] )

			if cCampo == "E2_SALDO"
				nsaldo := cConteudo
				if nsaldo <= "0,00"
					AUTOGRLOG("Saldo a baixar igual a zero !!!"+cConteudo)
					AUTOGRLOG("Na Linha: " + CVALTOCHAR(nLin))
					AUTOGRLOG(REPLICATE("-",90))
					lRet := .T.
				endif

			endif

		next nX

		FT_FSKIP()

	enddo

return( lRet )


/*/{Protheus.doc} fBaixaSE2
description Rotina para executar a Baixa do SE2
@type function
@version 
@author Roni Silva
@since 05/2022
@param aPadrao, array, param_description
@return return_type, return_description
/*/
STATIC function fBaixaSE2(aPadrao)

	LOCAL cCampo    := ""
	LOCAL cBuffer   := ""
	LOCAL cImport   := ""
	LOCAL cConteudo := ""
	LOCAL cArqDest  := ""
	LOCAL cArqLog   := ""
	LOCAL cMsgErro  := ""
	LOCAL cMsg      := ""

	LOCAL cE5PREFIXO := ""
	LOCAL cE5NUMERO  := ""
	LOCAL cE5PARCELA := ""
	LOCAL cE5BANCO   := ""
	LOCAL cE5AGENCIA := ""
	LOCAL cE5CONTA   := ""
	LOCAL cE5TIPO    := ""
	LOCAL dE5DATA    := CTOD(SPACE(08))

	LOCAL cData      := DTOS(DATE())
	LOCAL cTime      := SUBSTR(TIME(),1,2) + SUBSTR(TIME(),4,2)

	LOCAL aImport := {}
	LOCAL aCampos := {}
	LOCAL aBaixa  := {}
	LOCAL aLogErr := {}
	LOCAL aTitulo := {}

	LOCAL nE5VLJUROS := 0
	LOCAL nE5VALOR   := 0
	LOCAL nHandle    := 0

	LOCAL nLin := 0
	LOCAL nX   := 0

	LOCAL lRet := .F.

	lAutoErrNoFile := .T.

	//Gera Arquivo de Log
	cArqDest := "BAIXACSV_" + cData + cTime + ".TXT"
	cArqLog := cDirDest + "\" + cArqDest

	nHandle := FCREATE( ALLTRIM(cArqLog), 0 )

	if nHandle == -1
		MSGSTOP( "Erro na criação do arquivo de LOG " + ALLTRIM(cArqLog) + " - Handle: " + STRZERO(nhandle,10) + " Log não será¡ gravado!! ", "BAIXACSV" )
		Return( NIL )
	endif

	//Grava Cabeï¿½alho
	cMsg := "FILIAL"
	cMsg += ";PREFIXO"
	cMsg += ";NUMERO TITULO"
	cMsg += ";PARCELA"
	cMsg += ";TIPO"
	cMsg += ";BANCO"
	cMsg += ";AGENCIA"
	cMsg += ";CONTA"
	cMsg += ";DATA BAIXA"
	cMsg += ";JUROS"
	cMsg += ";VALOR RECEBIDO"
	cMsg += ";ERRO" + CHR(13) + CHR(10)

	FWRITE(nHandle, cMsg, Len(cMsg) )

	//Le Planilha
	FT_FUSE(cArq)
	FT_FGOTOP()

	while !FT_FEOF()

		cCampo  := ""
		aImport := {}

		//Capturar dados
		cBuffer := FT_FREADLN()

		cImport := STRTRAN(cBuffer,CHR(10),"")

		nLin++

		if EMPTY(cImport) .or. SUBSTR(cImport,1,1) == ";" .or. SUBSTR(cImport,1,1) <> "0"
			FT_FSKIP()
			loop
		endif


		//aImport := STRTOKARR(cImport, ";")

		while !empty(cImport)
			i := at(";",cImport)
			if i > 0
				cCampo := upper(Left(cImport,i-1))
				aadd(aImport,Alltrim(cCampo))
				cImport := substr(cImport,i+1)
			else
				cCampo := upper(cImport)
				aadd(aImport,Alltrim(cCampo))
				cImport := ""
			endif
		enddo

		
		//Valida Campos da Planilha
		for nX := 1 to 19

			cCampo    := ALLTRIM( aPadrao[nX][2] )
			cConteudo := ALLTRIM( aImport[nX] )

			if cCampo == "E5_DATA"
				cConteudo := ALLTRIM(cConteudo)
				dE5DATA   := CTOD( SUBSTR(cConteudo,7,2) + "/" + SUBSTR(cConteudo,5,2) + "/" + SUBSTR(cConteudo,1,4) )
			elseif cCampo == "E5_PARCELA"
				cConteudo  := ALLTRIM(cConteudo)
				cE5PARCELA := PADL(cConteudo, TAMSX3("E5_PARCELA")[1], "0")
			elseif cCampo == "E5_BANCO"
				cConteudo := ALLTRIM(cConteudo)
				cE5BANCO  := PADR( cConteudo, TAMSX3("A6_COD")[1] )
			elseif cCampo == "E5_AGENCIA"
				cConteudo  := ALLTRIM(cConteudo)
				cE5AGENCIA := STRZERO(VAL(cConteudo),4)
				cE5AGENCIA := PADR( cE5AGENCIA, TAMSX3("A6_AGENCIA")[1] )
			elseif cCampo == "E5_CONTA"
				cConteudo := ALLTRIM(cConteudo)
				cE5CONTA  := LEFT( cConteudo, LEN(cConteudo)-1 )
			elseif cCampo == "E5_VALOR"
				nE5VALOR := VAL(STRTRAN(cConteudo,",","."))
			endif

		next nX

		//Busca Titulo no SE2
//		aTitulo := fValSC5(cC5XNSU)

		if LEN(aImport) > 0

			cE5PREFIXO := PadR(aImport[2],TamSx3("E2_PREFIXO")[1]) //iif(empty(aImport[2]),"   ",aImport[2])
			cE5NUMERO  := PadR(aImport[3],TamSx3("E2_NUM")[1])
			cE5PARCELA := PadR(aImport[4],TamSx3("E2_PARCELA")[1]) //iif(empty(aImport[4]),"   ",aImport[4])
			cE5TIPO    := PadR(aImport[5],TamSx3("E2_TIPO")[1]) //aImport[5]
			CfORNECE 	:= PadR(aImport[8],TamSx3("E2_FORNECE")[1]) //aImport[8]
			CLOJA		:= PadR(aImport[9],TamSx3("E2_LOJA")[1]) //aImport[9]

			lMsErroAuto := .F.

			//Posiciona no Titulo a Pagar (SE2)
			DBSELECTAREA("SE2")
			SE2->( DBSETORDER(01) )
			if SE2->( DBSEEK( XFILIAL("SE2") + cE5PREFIXO + cE5NUMERO + cE5PARCELA + cE5TIPO + CfORNECE + CLOJA ))
				if SE2->E2_SALDO > 0

					aBaixa := {}
					//AADD( aBaixa, { "E2_FILIAL"   , XFILIAL('SE2') , Nil } )
					AADD( aBaixa, { "E2_PREFIXO"  , SE2->E2_PREFIXO, Nil } )
					AADD( aBaixa, { "E2_NUM"      , SE2->E2_NUM	   , Nil } )
					AADD( aBaixa, { "E2_PARCELA"  , SE2->E2_PARCELA, Nil } )
					AADD( aBaixa, { "E2_TIPO"     , SE2->E2_TIPO   , Nil } )
					AADD( aBaixa, { "E2_FORNECE"  , SE2->E2_FORNECE, Nil } )
					AADD( aBaixa, { "E2_LOJA"     , SE2->E2_LOJA   , Nil } )
					AADD( aBaixa, { "E2_LA"       , "S"            , Nil } )
					AADD( aBaixa, { "AUTMOTBX"    , /*"NOR"*/ "CAN", Nil } )
					AADD( aBaixa, { "AUTBANCO"	  , cE5BANCO	   , Nil } )
					AADD( aBaixa, { "AUTAGENCIA"  , cE5AGENCIA	   , Nil } )
					AADD( aBaixa, { "AUTCONTA"	  , cE5CONTA	   , Nil } )
					AADD( aBaixa, { "AUTDTBAIXA"  , dDataBase        , Nil } )
					AADD( aBaixa, { "AUTDTCREDITO", dDataBase        , Nil } )
					AADD( aBaixa, { "AUTHIST"	  , "VALOR PAGO S/ TITULO BAIXA CSV", Nil } )
					AADD( aBaixa, { "AUTJUROS"	  , nE5VLJUROS     , Nil } )
					AADD( aBaixa, { "AUTVALREC"   , nE5VALOR  	   , Nil } )
					//AADD( aBaixa, { "AUTDESCONT"  , 0	           , Nil } )	// 11
					//AADD( aBaixa, { "AUTMULTA" 	, 0		       , Nil } )	// 12
					//AADD( aBaixa, { "AUTACRESC"   , 0		       , Nil } )	// 13
					//AADD( aBaixa, { "AUTDECRESC"  , 0	           , Nil } )	// 14

					MSEXECAUTO( {|x,y| FINA080(x,y)}, aBaixa, 3 )

					if lMsErroAuto

						//MostraErro()
						cMsgErro := ""

						aLogErr  := GETAUTOGRLOG()
						for nX = 1 to LEN(aLogErr)
							cMsgErro += aLogErr[nX] + CRLF
						next

						lRet := if( !lRet, .T., lRet)
						Mostraerro()
					else

						cMsgErro := "OK"

						//Grva NSU e TID na tabela SE2 RONI SILVA
//						DBSELECTAREA("SE2")
//						SE2->( RECLOCK("SE2",.F.) )
//						//	SE2->E2_XNSU := cC5XNSU
//						SE2->E2_XTID := aImport[42]
//						SE2->( MSUNLOCK() )

						//dbselectarea("SE5")
						//if SE5->(E5_PREFIXO+E5_NUMERO+E5_CLIFOR+E5_LOJA) == SE2->(E2_PREFIXO+E2_NUM+E2_CLIENTE+E2_LOJA)
						//	SE5->( RecLock("SE5",.F.) )
						//		SE5->E5_VALOR   := ( nE1VALOR - ( nE1VRETIRF + nValRetPCC ) )
						//		SE5->E5_VLMOED2 := ( nE1VALOR - nValRetPCC )	//	xMoeda(SE5->E5_VALOR,SE5->E5_MOEDA,2,SE5->E5_DATA,3)
						//		SE5->E5_BASEIRF := nE1VALOR
						//		//SE5->E5_VRETIRF := 0
						//		SE5->E5_ORIGEM  := "FINA740"
						//	SE5->( MsUnLock() )
						//endif

					endif

				else
					//ronisilva
					//DBSELECTAREA("SE2")
					//SE2->( RECLOCK("SE2",.F.) )
					//SE2->E2_BAIXA := CTOD('  /  /    ')
					//SE2->E2_SALDO := SE2->E2_VALOR
					//SE2->( MSUNLOCK() )
					//MSGALERT('Titulo já baixado '+SE2->E2_NUM+' '+SE2->E2_PARCELA+' '+STR(RECNO()))
					cMsgErro := "Ja esta BAIXADO"
					lRet     := if( !lRet, .T., lRet)
				endif

			else
				cMsgErro := "Nao Localizado"
				lRet     := if( !lRet, .T., lRet)
			endif
		endif

		//Grava Cabeï¿½alho
		cMsg := aImport[1]
		cMsg += ";" + cE5PREFIXO
		cMsg += ";" + cE5NUMERO
		cMsg += ";" + cE5PARCELA
		cMsg += ";" + cE5TIPO
		cMsg += ";" + cE5BANCO
		cMsg += ";" + cE5AGENCIA
		cMsg += ";" + cE5CONTA
		cMsg += ";" + DTOS( dE5DATA )
		cMsg += ";" + TRANSFORM( nE5VLJUROS,"@E 999,999,999,999.99" )
		cMsg += ";" + TRANSFORM( nE5VALOR,"@E 999,999,999,999.99" )
		cMsg += ";" + SUBSTR(cMsgErro,1,30) + CHR(13) + CHR(10)

		FWRITE(nHandle, cMsg, LEN(cMsg) )

		FT_FSKIP()

	enddo

	FCLOSE(nHandle)

Return( lRet)


/*/{Protheus.doc} fValSC5
description Busca Pedido de Venda para identificar o Titulo
@type function
@version 
@author Roni Silva
@since 05/2022
@param cC5XNSU, character, param_description
@return return_type, return_description
/*/
STATIC function fValSC5(cC5XNSU)

	LOCAL cAliasSC5 := "cAliasSC5"
	LOCAL cQuery    := ""
	LOCAL aRet      := {}

	cQuery := "SELECT C5_XNSU, C5_XTID, C5_NOTA, C5_SERIE, C5_CLIENTE, C5_LOJACLI, C5_NUM"
	cQuery += "  FROM " + RETSQLNAME("SC5") + " SC5 "
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '"
	cQuery += "   AND SC5.C5_XNSU = '" + cC5XNSU + "'"
	cQuery := CHANGEQUERY(cQuery)

	DBUSEAREA(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSC5,.F.,.T.)

	(cAliasSC5)->( DBGOTOP() )
	if !(cAliasSC5)->( EOF() )
		AADD( aRet, { (cAliasSC5)->C5_XNSU    ,;
			(cAliasSC5)->C5_XTID    ,;
			(cAliasSC5)->C5_SERIE   ,;
			(cAliasSC5)->C5_NOTA    ,;
			(cAliasSC5)->C5_CLIENTE ,;
			(cAliasSC5)->C5_LOJACLI ,;
			(cAliasSC5)->C5_NUM     } )
	endif

	(cAliasSC5)->( DBCLOSEAREA() )

return( aRet )

