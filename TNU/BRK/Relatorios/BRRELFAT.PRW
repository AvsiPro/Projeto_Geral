#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

STATIC nMeses    as numeric
STATIC __cTabTMP as string
STATIC cCampos   as String
STATIC cPer1     as string
STATIC cPer2     as string 


/*/{Protheus.doc} BRRELFAT
Rotina Relatório de Faturamento apresentado por mês
@type function
@version  12.1.33
@author valdemir Rabelo
@since 31/05/2022
@return variant, Nil
/*/
USER FUNCTION BRRELFAT()
	Local oReport	As Object
	Local aArea		As Array

	aArea := GetArea()

	oReport	:= ReportDef()
	if oReport != nil
		oReport:PrintDialog()
	endif

	RestArea( aArea )

RETURN


/*/{Protheus.doc} ReportDef
Rotina preparando relatório
@type function
@version  12.1.33
@author Valdemir Rabelo
@since 01/06/2022
@return variant, String
/*/
Static Function ReportDef()
	Local oReport   as Object
	Local oSection  as Object
	Local cPerg     as Character
	Local cReport   as Character
	Local cTitulo   as Character
	Local cDescri   as Character
	Local nX        as numeric
	Local dData     as date
	Local _aMes     as array
	Local lVld      := .F. as logical
	Local cFileName := "C:\Temp\BRRELFAT_"+dtos(date())+SUBSTR(TIME(), 1, 2)+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2)+".XML"

	MAKEDIR( "C:\Temp" )

	cPerg   := "BRRELFAT01"
	cTitulo := "RELATÓRIO FATURAMENTO MÊS A MÊS"
	cDescri := "MONTAGEM DO "+cTITULO
	cReport := cPerg
	MontaPerg(cPerg)
	
	While !lVld
		if  ! Pergunte(cPerg, .T.)     
			Return
		endif
		lVld := vldper() 
	end

	nMeses  := DateDiffMonth(stod(cPer1), stod(cPer2))
	nMeses  := IIF(nMeses==0,1,nMeses+1)
	if nMeses > 12
	   nMeses  := 12 
	endif 
	_aMes   := {}
	oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDescri)

	IF (oReport != nIL)
		oReport:SetLandscape(.T.)	//Imprime o relatorio no formato paisagem

		For nX := 1 to nMeses
			if nX==1
				dData := stod(cPer1)
			else
				dData := MonthSum(dData, 1)
				dData := FirstDate(dData)
			endif
			aAdd(_aMes, dtos(dData) )
		Next
		cMES  := dtos(dData)

		oReport:cFile  := cFileName
		oReport:SetTotalInLine(.F.)
		oReport:lParamPage := .T.

		//Aqui iremos deixar como selecionado a opção Planilha, e iremos habilitar somente o formato de tabela
		oReport:SetDevice(4) //Planilha
		oReport:SetTpPlanilha({.T., .F., .F., .F.}) //Formato Tabela {Normal, Suprimir linhas brancas e totais, Formato de Tabela, Formato de Tabela xlsx}

		// Secao principal
		oSection := TRSection():New(oReport, "" , {"SF2"})	//"CABECALHO"

		TRCell():New(oSection,"CLIENTE", "" ,SX3->(RetTitle("F2_CLIENTE")),PesqPict("SF2","F2_CLIENTE"),TamSX3("F2_CLIENTE")[1] + 8	)
		TRCell():New(oSection,"LOJA",    "" ,SX3->(RetTitle("F2_LOJA"))   ,PesqPict("SF2","F2_LOJA")   ,TamSX3("F2_LOJA")[1] + 8	)
		TRCell():New(oSection,"NOME",    "" ,"RAZÃO SOCIAL"               ,PesqPict("SA1","A1_NOME")   ,TamSX3("A1_NOME")[1] -50   	)
		TRCell():New(oSection,"VLRBRUTO","" ,"VALOR BRUTO"                ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8	)
		TRCell():New(oSection,"MEDIA",   "" ,"MEDIA"                      ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8	)
		TRCell():New(oSection,"TOTPERC", "" ,"% TOTAL"                    ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8	)
		if nMeses >= 1
            cMES := Left(_aMes[1],6)
			TRCell():New(oSection,"MES_01", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 2
            cMES := Left(_aMes[2],6)
			TRCell():New(oSection,"MES_02", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 3
            cMES := Left(_aMes[3],6)
			TRCell():New(oSection,"MES_03", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 4
            cMES := Left(_aMes[4],6)
			TRCell():New(oSection,"MES_04", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 5
            cMES := Left(_aMes[5],6)
			TRCell():New(oSection,"MES_05", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 6
            cMES := Left(_aMes[6],6)
			TRCell():New(oSection,"MES_06", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 7
            cMES := Left(_aMes[7],6)
			TRCell():New(oSection,"MES_07", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 8
            cMES := Left(_aMes[8],6)
			TRCell():New(oSection,"MES_08", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 9
            cMES := Left(_aMes[9],6)
			TRCell():New(oSection,"MES_09", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif  
		if nMeses >= 10
            cMES := Left(_aMes[10],6)
			TRCell():New(oSection,"MES_10", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 11
            cMES := Left(_aMes[11],6)
			TRCell():New(oSection,"MES_11", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif
		if nMeses >= 12
            cMES := Left(_aMes[12],6)
			TRCell():New(oSection,"MES_12", "" ,ConvMesD(Right(cMES,2))+"/"+Left(cMes,4) ,PesqPict("SF2","F2_VALBRUT"),TamSX3("F2_VALBRUT")[1] + 8)
		endif

        //oSection:SetTotalInLine(.F.)

        oBreak1 := TRBreak():New(oSection,{||  },{|| "Total : " },.F.)


        TRFunction():New(oSection:Cell("VLRBRUTO"), /* cID */, "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .T./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        TRFunction():New(oSection:Cell("MEDIA"), /* cID */, "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .T./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        TRFunction():New(oSection:Cell("TOTPERC"), /* cID */, "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .T./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)

        if nMeses >= 1
            TRFunction():New(oSection:Cell("MES_01"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif
        if nMeses >= 2
           TRFunction():New(oSection:Cell("MES_02"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif
        if nMeses >= 3
           TRFunction():New(oSection:Cell("MES_03"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif
        if nMeses >= 4
           TRFunction():New(oSection:Cell("MES_04"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
        if nMeses >= 5
           TRFunction():New(oSection:Cell("MES_05"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
        if nMeses >= 6
           TRFunction():New(oSection:Cell("MES_06"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
        if nMeses >= 7
           TRFunction():New(oSection:Cell("MES_07"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif
        if nMeses >= 8
           TRFunction():New(oSection:Cell("MES_08"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
        if nMeses >= 9
           TRFunction():New(oSection:Cell("MES_09"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif
        if nMeses >= 10
           TRFunction():New(oSection:Cell("MES_10"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
        if nMeses >= 11
           TRFunction():New(oSection:Cell("MES_11"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
        if nMeses >= 12
           TRFunction():New(oSection:Cell("MES_12"), /* cID */  , "SUM", oBreak1, /*cTitle*/, /*cPicture*/, /*uFormula*/, .F./*lEndSection*/, .T./*lEndReport*/, /*lEndPage*/)
        endif 
		oSection:SetHeaderSection(.T.)	//Não imprime o cabecalho da secao
		oSection:SetPageBreak(.F.)		//Salta a pagina na quebra da secao
		//oSection1:Cell("TOTAL"):SetHeaderAlign("RIGHT")

	Endif

Return oReport



/*/{Protheus.doc} ConvMesD
Rotina para converter o mes inteiro para nome
@type function
@version  12.1.333
@author valdemir rabelo
@since 19/06/2022
@param pMes, variant, inteiro
@return variant, descrição mes
/*/
Static Function ConvMesD(pMes)
	Local aMES := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
Return aMes[val(pMes)]


/*/{Protheus.doc} ConvMesP
Rotina para converter de nome do mes para inteiro
@type function
@version  12.1.333
@author valdemir rabelo
@since 19/06/2022
@param pMes, variant, inteiro
@return variant, Mes Numerico
/*/
Static Function ConvMesP(pDes)
	Local aMES := {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
Return StrZero(aScan(aMES, {|X| Upper(alltrim(X))==Upper(alltrim(pDes)) }),2)



/*/{Protheus.doc} ReportPrint
Rotina para carregar os dados nas celular
@type function
@version  12.1.33
@author valdemir rabelo
@since 01/06/2022
@param oReport, object, Nil
@return variant, Nil
/*/
Static Function ReportPrint(oReport As Object)
	Local oSection	As Object   //Cabeçalho
	Local oSection1 As Object   //"Titulos Vencidos"
	Local cQry      As String
	Local nX        As numeric
	Local nReg      As numeric
	Local nTotGer   As numeric
	Local aMeses    as Array
	Local aDados[99]
	Local nVlrBru := 0

	__cTabTMP := GetNextAlias()

	cQry      := MontaQry() // Monta Query
	aMeses    := Separa(cCampos,",")

	oSection  := oReport:Section(1) //QDO CHEGA AQUI JÁ TEM O CDIR, CFILE,
	oSection1 := oReport:Section(1)

	oReport:SetTitle(oReport:Title())     // Titulo do relatório
	aFill(aDados,nil)
	oSection1:Cell("CLIENTE"):SetBlock( { || aDados[01] } )
	oSection1:Cell("LOJA"):SetBlock(    { || aDados[02] } )
	oSection1:Cell("NOME"):SetBlock(    { || aDados[03] } )
	oSection1:Cell("VLRBRUTO"):SetBlock({ || aDados[04] } )
	oSection1:Cell("MEDIA"):SetBlock(   { || aDados[05] } )
	oSection1:Cell("TOTPERC"):SetBlock( { || aDados[06] } )
	IF nMeses >= 1
		oSection1:Cell("MES_01"):SetBlock(  { || aDados[07] } )
	endif
	IF nMeses >= 2
		oSection1:Cell("MES_02"):SetBlock(  { || aDados[08] } )
	endif
	IF nMeses >= 3
		oSection1:Cell("MES_03"):SetBlock(  { || aDados[09] } )
	endif
	IF nMeses >= 4
		oSection1:Cell("MES_04"):SetBlock(  { || aDados[10] } )
	endif
	IF nMeses >= 5
        oSection1:Cell("MES_05"):SetBlock(  { || aDados[11] } )
    endif 
    IF nMeses >= 6
        oSection1:Cell("MES_06"):SetBlock(  { || aDados[12] } )
    endif
    IF nMeses >= 7
        oSection1:Cell("MES_07"):SetBlock(  { || aDados[13] } )
    endif
    IF nMeses >= 8
        oSection1:Cell("MES_08"):SetBlock(  { || aDados[14] } )
    endif	
    IF nMeses >= 9
        oSection1:Cell("MES_09"):SetBlock(  { || aDados[15] } )
    endif   
    IF nMeses >= 10
        oSection1:Cell("MES_10"):SetBlock(  { || aDados[16] } )
    endif 
    IF nMeses >= 11
        oSection1:Cell("MES_11"):SetBlock(  { || aDados[17] } )
    endif     
    IF nMeses >= 12
        oSection1:Cell("MES_12"):SetBlock(  { || aDados[18] } )
    endif    
    oSection:Init()

    TcQuery cQry New Alias (__cTabTMP)

    nTotGer := 0
    nReg    := 0
    (__cTabTMP)->( dbEval({|| nTotGer += TOTAL },,{|| !EOF() }) )
    (__cTabTMP)->( dbGotop() )
    (__cTabTMP)->( dbEval({|| nReg += 1 },,{|| !EOF() }) )
    oReport:SetMeter(nReg)
    (__cTabTMP)->( dbGotop() )

    While !oReport:Cancel() .And. (__cTabTMP)->( !Eof() )
        oReport:IncMeter()
        aDados[01] := (__cTabTMP)->CLIENTE
        aDados[02] := (__cTabTMP)->LOJA
        aDados[03] := (__cTabTMP)->NOME
        //aDados[04] := (__cTabTMP)->TOTAL
        					 
        aDados[06] := ( (__cTabTMP)->TOTAL * 100) / nTotGer

        nLin    := 7
		nVlrBru := 0
        For nX := 1 to Len(aMeses)
            aDados[nLin] := (__cTabTMP)->&(aMeses[nX])
			nVlrBru += (__cTabTMP)->&(aMeses[nX])
            nLin += 1
        Next
		aDados[04] := nVlrBru
		aDados[05] := nVlrBru / nMeses
        oSection1:PrintLine()
        aFill(aDados,nil)

        (__cTabTMP)->( dbSkip() )
    EndDo

    oReport:SkipLine()

    (__cTabTMP)->( dbCloseArea() )

Return oReport





/*/{Protheus.doc} MontaPerg
Rotina para montar o pergunte
@type function
@version  12.1.33
@author valde
@since 01/06/2022
@return variant, return_nil
/*/
Static Function MontaPerg(cPerg)
	Local cAno   := Left(dtos(dDatabase),4)
	Local lAchou := .T. 

	DbSelectArea('SX1')
	SX1->(DbSetOrder(1)) // Grupo + Ordem
	lAchou := SX1->(DbSeek(cPerg+'01'))

	U_STPutSx1( cPerg, "01","Período MMM/YYYY de: ","MV_PAR01","mv_ch1","C",8 ,0,"G",,"","AAA/9999")
	U_STPutSx1( cPerg, "02","Período MMM/YYYY ate:","MV_PAR02","mv_ch2","C",8 ,0,"G",,"","AAA/9999")
	U_STPutSx1( cPerg, "03","Cliente de:          ","MV_PAR03","mv_ch3","C",TamSX3("A1_COD")[1]     ,0,"G",,"SA1","@!")
	U_STPutSx1( cPerg, "04","Loja de:             ","MV_PAR04","mv_ch4","C",TamSX3("A1_LOJA")[1]    ,0,"G",,""   ,"@!")
	U_STPutSx1( cPerg, "05","Cliente ate:         ","MV_PAR05","mv_ch5","C",TamSX3("A1_COD")[1]     ,0,"G",,"SA1","@!")
	U_STPutSx1( cPerg, "06","Loja ate:            ","MV_PAR06","mv_ch6","C",TamSX3("A1_LOJA")[1]    ,0,"G",,""   ,"@!")
	U_STPutSx1( cPerg, "07","Filial :             ","MV_PAR07","mv_ch7","C",30                      ,0,"G",,"CONFIL","@!")

	// ao não encontrar a pergunta, criar colocando período do ano atual
	If ! lAchou	
	   SX1->(DbSeek(cPerg+'01'))
	   RecLock("SX1",.F.)
	   SX1->X1_CNT01 := "JAN/"+cANO
	   MsUnlock()
	   SX1->(DbSeek(cPerg+'02'))
	   RecLock("SX1",.F.)
	   SX1->X1_CNT01 := "DEZ/"+cANO
	   MsUnlock()	
	   SX1->(DbSeek(cPerg+'05'))
	   RecLock("SX1",.F.)
	   SX1->X1_CNT01 := "ZZZZZZ"	   
	   MsUnlock()	
	   SX1->(DbSeek(cPerg+'06'))
	   RecLock("SX1",.F.)
	   SX1->X1_CNT01 := "ZZZ"	   
	   MsUnlock()	      
	endif 
Return 


/*/{Protheus.doc} U_vldper
Rotina para validar o período informado
@type function
@version  12.1.33
@author valdemir rabelo
@since 08/06/2022
@return variant, lógico
/*/
STATIC FUNCTION vldper()
	Local lRET := .T. as logical
	Local nAno := 0   as numeric

	if Empty(MV_PAR01) .or.   Empty(MV_PAR02)
	   FWMsgRun(,{|| Sleep(4000)},'Informativo','O período não pode ser vazio, favor informar.')
	   Return .F. 
	endif 

	if !(UPPER(Left(MV_PAR01,3)) $ "JAN/FEV/MAR/ABR/MAI/JUN/JUL/AGO/SET/OUT/NOV/DEZ")
	   FWMsgRun(,{|| Sleep(4000)},'Informativo','O mês do período inicial é inválido.')
	   return 
	endif 

	if !(UPPER(Left(MV_PAR02,3)) $ "JAN/FEV/MAR/ABR/MAI/JUN/JUL/AGO/SET/OUT/NOV/DEZ")
	   FWMsgRun(,{|| Sleep(4000)},'Informativo','O mês do período final é inválido.')
	   return 
	endif 

	cPer1 := "01/" + ConvMesP( Left(MV_PAR01,3) ) + "/" + Right(MV_PAR01, 4)
	cPer2 := "01/" + ConvMesP( Left(MV_PAR02,3) ) + "/" + Right(MV_PAR02, 4)

	cPer1 := ctod( cPer1 )
	cPer2 := ctod( cPer2 )

	if !Empty(cPer1) .and. !Empty(cPer2)
		nAno := YEAR(cPer2)-YEAR(cPer1)
	endif 

	IF (nAno > 0) .and. (nAno > 2)
       FWMsgRun(,{|| Sleep(4000)},'Informativo','O período informado não pode ser superior a dois anos.')
	   lRET := .F.
	ENDIF 

	cPer1 := dtos(cPer1)
	cPer2 := dtos(cPer2)

RETURN lRET

/*/{Protheus.doc} MontaQry
Rotina para montagem da query
@type function
@version  12.1.33
@author Valdemir Rabelo
@since 01/06/2022
@return variant, String
/*/
Static Function MontaQry()
	Local nX    := 0     As numeric
	Local cRET  := ""    As String
	Local cSUM  := ""    As String 
	Local _cFil := ""    As String 

	MAKEDIR('C:\Temp')

	cCampos := ""
	cSUM    := ""

	if !Empty(MV_PAR07)
		_cFil   := FormatIn(MV_PAR07,";")
	endif 

	dData   := stod(cPer1)

	For nX := 1 to nMeses
		if nX == 1
			cMes   := Left(cPer1,6)
		else
			cCampos += ","
			cSUM    += ","
			dData  := MonthSum(dData, 1)
			cMes   := Left(dtos(dData),6)
		endif
		cCampos += "MES_"+cMes
		cSUM    += "SUM(MES_"+cMes+") MES_"+cMes
	Next

	If DWCanOpenView("TMPF2")
		cRET := " DROP VIEW TMPF2 "
		MATExecQry(cRET)
	EndIf

	cRET := "CREATE VIEW TMPF2 AS " + CRLF
	cRET += "SELECT  " + CRLF
	cRET += "  CLIENTE, LOJA, NOME, TOTAL, MEDIA, " +cCampos + CRLF
	cRET += "FROM (
	cRET += "  SELECT " + CRLF
	cRET += "    F2_CLIENTE CLIENTE, " + CRLF
	cRET += "    F2_LOJA LOJA, " + CRLF
	cRET += "    A1_NOME NOME, " + CRLF
	cRET += "    SUM(F2_VALBRUT) TOTAL, " + CRLF
	cRET += "    SUM(F2_VALBRUT) / "+CValToChar(nMeses)+" MEDIA, " + CRLF
	cRET += "    'MES_'+SUBSTRING(F2_EMISSAO,1,6) MESES, " + CRLF
	cRET += "    ISNULL(SUM(F2_VALBRUT),0) VALOR " + CRLF
	cRET += "  FROM " + RETSQLNAME('SF2') + " F2 " + CRLF
	cRET += "  INNER JOIN " + RETSQLNAME('SA1') + " A1 " + CRLF
	cRET += "  ON A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA=F2.F2_LOJA AND A1.D_E_L_E_T_ = ' '" + CRLF
	cRET += "  WHERE F2.D_E_L_E_T_ = ' ' " + CRLF
	cRET += "    AND F2.F2_EMISSAO BETWEEN '"+cPer1+"' AND '"+dtos(stod(cPer2)+32)+"' " + CRLF
	cRET += "    AND F2.F2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"' " + CRLF
	cRET += "    AND F2.F2_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"' " + CRLF
	if !Empty(MV_PAR07)
	   cRET += "    AND F2.F2_FILIAL IN " +_cFil + " " + CRLF
	endif 
	cRET += "  GROUP BY F2_CLIENTE, F2_LOJA, A1_NOME, SUBSTRING(F2_EMISSAO,1,6) " + CRLF
	cRET += ") X PIVOT ( SUM(VALOR) FOR MESES IN ("+cCampos+") ) AS PVT " + CRLF

	Memowrite('c:\Temp\BRRELFAT.sql', cRET)
	MATExecQry(cRET)

	cRET := " SELECT CLIENTE, LOJA, NOME, SUM(TOTAL) TOTAL, SUM(MEDIA) MEDIA, " + CRLF 
	cRET += cSUM  + CRLF 
	cRET += " FROM TMPF2 GROUP BY CLIENTE, LOJA, NOME"

Return cRET













/*/{Protheus.doc} zPutSX1
Função para criar Grupo de Perguntas
@author Atilio
@since 09/06/2017
@version 1.0
@type function
    @param cGrupo,    characters, Grupo de Perguntas       (ex.: X_TESTE)
    @param cOrdem,    characters, Ordem da Pergunta        (ex.: 01, 02, 03, ...)
    @param cTexto,    characters, Texto da Pergunta        (ex.: Produto De, Produto Até, Data De, ...)
    @param cMVPar,    characters, MV_PAR?? da Pergunta     (ex.: MV_PAR01, MV_PAR02, MV_PAR03, ...)
    @param cVariavel, characters, Variável da Pergunta     (ex.: MV_CH0, MV_CH1, MV_CH2, ...)
    @param cTipoCamp, characters, Tipo do Campo            (C = Caracter, N = Numérico, D = Data)
    @param nTamanho,  numeric,    Tamanho da Pergunta      (Máximo de 60)
    @param nDecimal,  numeric,    Tamanho de Decimais      (Máximo de 9)
    @param cTipoPar,  characters, Tipo do Parâmetro        (G = Get, C = Combo, F = Escolha de Arquivos, K = Check Box)
    @param cValid,    characters, Validação da Pergunta    (ex.: Positivo(), u_SuaFuncao(), ...)
    @param cF3,       characters, Consulta F3 da Pergunta  (ex.: SB1, SA1, ...)
    @param cPicture,  characters, Máscara do Parâmetro     (ex.: @!, @E 999.99, ...)
    @param cDef01,    characters, Primeira opção do combo
    @param cDef02,    characters, Segunda opção do combo
    @param cDef03,    characters, Terceira opção do combo
    @param cDef04,    characters, Quarta opção do combo
    @param cDef05,    characters, Quinta opção do combo
    @param cHelp,     characters, Texto de Help do parâmetro
    @obs Função foi criada, pois a partir de algumas versões do Protheus 12, a função padrão PutSX1 não funciona (por medidas de segurança)
    @example Abaixo um exemplo de como criar um grupo de perguntas
     
    cPerg    := "X_TST"
     
    cValid   := ""
    cF3      := ""
    cPicture := ""
    cDef01   := ""
    cDef02   := ""
    cDef03   := ""
    cDef04   := ""
    cDef05   := ""
     
    U_STPutSX1(cPerg, "01", "Produto De?",       "MV_PAR01", "MV_CH0", "C", TamSX3('B1_COD')[01], 0, "G", cValid,       "SB1", cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o produto inicial")
    U_STPutSX1(cPerg, "02", "Produto Até?",      "MV_PAR02", "MV_CH1", "C", TamSX3('B1_COD')[01], 0, "G", cValid,       "SB1", cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o produto final")
    U_STPutSX1(cPerg, "03", "A partir da Data?", "MV_PAR03", "MV_CH2", "D", 08,                   0, "G", cValid,       cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a data inicial a ser considerada")
    U_STPutSX1(cPerg, "04", "Média maior que?",  "MV_PAR04", "MV_CH3", "N", 09,                   2, "G", "Positivo()", cF3,   "@E 999,999.99", cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a média de atraso que será considerada")
    U_STPutSX1(cPerg, "05", "Tipo de Saldos?",   "MV_PAR05", "MV_CH4", "N", 01,                   0, "C", cValid,       cF3,   cPicture,        "Todos", "Maior que 0", "Menor que 0", "Zerados", cDef05, "Informe o tipo de saldo a ser considerado")
    U_STPutSX1(cPerg, "06", "Tipos de Produto?", "MV_PAR06", "MV_CH5", "C", 60,                   0, "K", cValid,       cF3,   cPicture,        "PA",    "PI",          "MP",          cDef04,    cDef05, "Informe os tipos de produto que serão considerados")
    U_STPutSX1(cPerg, "07", "Caminho de Log?",   "MV_PAR07", "MV_CH6", "C", 60,                   0, "F", cValid,       cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o caminho para geração do log")
/*/
User Function STPutSX1(cGrupo, cOrdem, cTexto, cMVPar, cVariavel, cTipoCamp, nTamanho, nDecimal, cTipoPar, cValid, cF3, cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, cHelp)
	Local aArea       := GetArea()
	Local cChaveHelp  := ""
	Local nPreSel     := 0

	Default cGrupo    := Space(10)
	Default cOrdem    := Space(02)
	Default cTexto    := Space(30)
	Default cMVPar    := Space(15)
	Default cVariavel := Space(6)
	Default cTipoCamp := Space(1)
	Default nTamanho  := 0
	Default nDecimal  := 0
	Default cTipoPar  := "G"
	Default cValid    := Space(60)
	Default cF3       := Space(6)
	Default cPicture  := Space(40)
	Default cDef01    := Space(15)
	Default cDef02    := Space(15)
	Default cDef03    := Space(15)
	Default cDef04    := Space(15)
	Default cDef05    := Space(15)
	Default cHelp     := ""

	//Se tiver Grupo, Ordem, Texto, Parâmetro, Variável, Tipo e Tamanho, continua para a criação do parâmetro
	If !Empty(cGrupo) .And. !Empty(cOrdem) .And. !Empty(cTexto) .And. !Empty(cMVPar) .And. !Empty(cVariavel) .And. !Empty(cTipoCamp) .And. nTamanho != 0

		//Definição de variáveis
		cGrupo     := PadR(cGrupo, Len(SX1->X1_GRUPO), " ")           //Adiciona espaços a direita para utilização no DbSeek
		cChaveHelp := "P." + AllTrim(cGrupo) + AllTrim(cOrdem) + "."  //Define o nome da pergunta
		cMVPar     := Upper(cMVPar)                                   //Deixa o MV_PAR tudo em maiúsculo
		nPreSel    := Iif(cTipoPar == "C", 1, 0)                      //Se for Combo, o pré-selecionado será o Primeiro
		cDef01     := Iif(cTipoPar == "F", "56", cDef01)              //Se for File, muda a definição para ser tanto Servidor quanto Local
		nTamanho   := Iif(nTamanho > 60, 60, nTamanho)                //Se o tamanho for maior que 60, volta para 60 - Limitação do Protheus
		nDecimal   := Iif(nDecimal > 9,  9,  nDecimal)                //Se o decimal for maior que 9, volta para 9
		nDecimal   := Iif(cTipoPar == "N", nDecimal, 0)               //Se não for parâmetro do tipo numérico, será 0 o Decimal
		cTipoCamp  := Upper(cTipoCamp)                                //Deixa o tipo do Campo em maiúsculo
		cTipoCamp  := Iif(! cTipoCamp $ 'C;D;N;', 'C', cTipoCamp)     //Se o tipo do Campo não estiver entre Caracter / Data / Numérico, será Caracter
		cTipoPar   := Upper(cTipoPar)                                 //Deixa o tipo do Parâmetro em maiúsculo
		cTipoPar   := Iif(Empty(cTipoPar), 'G', cTipoPar)             //Se o tipo do Parâmetro estiver em branco, será um Get
		nTamanho   := Iif(cTipoPar == "C", 1, nTamanho)               //Se for Combo, o tamanho será 1

		DbSelectArea('SX1')
		SX1->(DbSetOrder(1)) // Grupo + Ordem

		//Se não conseguir posicionar, a pergunta será criada
		If ! SX1->(DbSeek(cGrupo + cOrdem))
			RecLock('SX1', .T.)
			X1_GRUPO   := cGrupo
			X1_ORDEM   := cOrdem
			X1_PERGUNT := cTexto
			X1_PERSPA  := cTexto
			X1_PERENG  := cTexto
			X1_VAR01   := cMVPar
			X1_VARIAVL := cVariavel
			X1_TIPO    := cTipoCamp
			X1_TAMANHO := nTamanho
			X1_DECIMAL := nDecimal
			X1_GSC     := cTipoPar
			X1_VALID   := cValid
			X1_F3      := cF3
			X1_PICTURE := cPicture
			X1_DEF01   := cDef01
			X1_DEFSPA1 := cDef01
			X1_DEFENG1 := cDef01
			X1_DEF02   := cDef02
			X1_DEFSPA2 := cDef02
			X1_DEFENG2 := cDef02
			X1_DEF03   := cDef03
			X1_DEFSPA3 := cDef03
			X1_DEFENG3 := cDef03
			X1_DEF04   := cDef04
			X1_DEFSPA4 := cDef04
			X1_DEFENG4 := cDef04
			X1_DEF05   := cDef05
			X1_DEFSPA5 := cDef05
			X1_DEFENG5 := cDef05
			X1_PRESEL  := nPreSel

			//Se tiver Help da Pergunta
			If !Empty(cHelp)
				X1_HELP    := ""

				fPutHelp(cChaveHelp, cHelp)
			EndIf
			SX1->(MsUnlock())
		EndIf
	EndIf

	RestArea(aArea)
Return



/*---------------------------------------------------*
 | Função: fPutHelp                                  |
 | Desc:   Função que insere o Help do Parametro     |
 *---------------------------------------------------*/
Static Function fPutHelp(cKey, cHelp, lUpdate)
    Local cFilePor  := "SIGAHLP.HLP"
    Local cFileEng  := "SIGAHLE.HLE"
    Local cFileSpa  := "SIGAHLS.HLS"
    Local nRet      := 0
    Default cKey    := ""
    Default cHelp   := ""
    Default lUpdate := .F.
     
    //Se a Chave ou o Help estiverem em branco
    If Empty(cKey) .Or. Empty(cHelp)
        Return
    EndIf
     
    //**************************** Português
    nRet := SPF_SEEK(cFilePor, cKey, 1)
     
    //Se não encontrar, será inclusão
    If nRet < 0
        SPF_INSERT(cFilePor, cKey, , , cHelp)
     
    //Senão, será atualização
    Else
        If lUpdate
            SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
        EndIf
    EndIf

    //**************************** Inglês
    nRet := SPF_SEEK(cFileEng, cKey, 1)
     
    //Se não encontrar, será inclusão
    If nRet < 0
        SPF_INSERT(cFileEng, cKey, , , cHelp)
     
    //Senão, será atualização
    Else
        If lUpdate
            SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
        EndIf
    EndIf

    //**************************** Espanhol
    nRet := SPF_SEEK(cFileSpa, cKey, 1)
     
    //Se não encontrar, será inclusão
    If nRet < 0
        SPF_INSERT(cFileSpa, cKey, , , cHelp)
     
    //Senão, será atualização
    Else
        If lUpdate
            SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
        EndIf
    EndIf
Return
