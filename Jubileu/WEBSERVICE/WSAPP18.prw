#Include "Totvs.ch"
#Include "RwMake.ch"
#Include "RestFul.ch"


WsRestFul WSAPP18 Description "venda diaria API" FORMAT APPLICATION_JSON
	WsData page		 AS Integer	Optional
	WsData pageSize  AS Integer	Optional
	WsData token     AS String
    WsData ano		 AS Integer	Optional
	WsData mes       AS Integer	Optional

WsMethod GET dailysales;
    Description 'Venda Diaria';
    WsSyntax '/WSAPP18';
    Path '/WSAPP18';
    Produces APPLICATION_JSON
End WsRestFul

/*/{Protheus.doc} GET
Retorna a venda diária do vendedor.

@param	Page	   , numerico, numero da pagina
		PageSize   , numerico, quantidade de registros por pagina
		token      , caracter, token vendedor que usara como filtro
        ano        , numerico, ano de consulta
        mes        , numerico, mes de consulta

@return cResponse  , caracter, JSON contendo a venda diária do vendedor
/*/

WsMethod GET dailysales WsReceive page, pageSize, token, ano, mes WsRest WSAPP18
	Local lRet:= .T.
	lRet := dailysales( self )
Return( lRet )

Static function dailysales( oSelf )

Local cJsonCli      := ""
Local oJsonAux	    := Nil
Local cVend 
Local cQuery 
Local cPriDia
Local cUltDia
Local nAux          :=  0
Local oResult 
Local aAux1             :=  {} 
Local aAux2             :=  {}
Local aAux3             :=  {}
Local aAux4             :=  {}
Local aAux5             :=  {}
Local aAux6             :=  {}
Local aAux7             :=  {}
Local aAux8             :=  {}

Local nTotVnd           :=  0
Local ncont 
Local nTotQtd           :=  0
Local nTotFat           :=  0
Local nTotQFt           :=  0

Default oself:page		:=	1
Default oself:pageSize	:= 	20
Default oself:ano		:=  2023
Default oself:mes       :=	7
Default oself:token		:=	''

RpcClearEnv()
RpcSetType(3)
RPCSetEnv('01','0801')

    If !Empty(oself:ano) .And. !Empty(oself:mes)
        cPriDia := cvaltochar(oself:ano)+cvaltochar(strzero(oself:mes,2))+'01'
        cUltDia := dtos(ctod(cvaltochar(lastday(stod(cPriDia)))))
    EndIf

    aAux1 := ARRAY(DateDiffDay(stod(cPriDia),stod(cUltDia))+1)
    
    for ncont := 1 to len(aAux1)
        aAux1[ncont] := 0
    next ncont


    oJsonAux  := JsonObject():New()
    cAliasTMP := GetNextAlias()

    If !Empty(oself:token)
        cVend   := fVendToken( oself:token )

        cQuery := "SELECT C5_EMISSAO,SUM(C6_VALOR) AS VALOR"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6.D_E_L_E_T_=' '"
        cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        cQuery += " GROUP BY C5_EMISSAO"
        cQuery += " ORDER BY 1"
        cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "

        MPSysOpenQuery(cQuery, cAliasTMP)

	    While (cAliasTMP)->(!Eof())
            nPos := day(stod((cAliasTMP)->C5_EMISSAO))
            aAux1[nPos] := round((cAliasTMP)->VALOR / 1000,1)
            nAux++

            (cAliasTMP)->(DBSkip())
        EndDo

        (cAliasTMP)->(DBCloseArea())

        cQuery := "SELECT BM_DESC,SUM(C6_VALOR) AS VALOR,SUM(C6_PRCVEN*C6_QTDENT) AS FATURADO"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6.D_E_L_E_T_=' '"
        cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' '"
        cQuery += " INNER JOIN "+RetSQLName("SBM")+" BM ON BM_FILIAL=B1_FILIAL AND BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' '"
        cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        cQuery += " GROUP BY BM_DESC"
        cQuery += " ORDER BY 1"
        cQuery += " OFFSET (("+cValToChar(oself:page)+" - 1) * "+cValToChar(oself:pageSize)+") ROWS "
		cQuery += " FETCH NEXT "+cValToChar(oself:pageSize)+" ROWS ONLY "

        MPSysOpenQuery(cQuery, cAliasTMP)

	    While (cAliasTMP)->(!Eof())
            Aadd(aAux3,{Alltrim(EncodeUTF8((cAliasTMP)->BM_DESC)),;
                        (cAliasTMP)->VALOR,;
                        0,;
                        (cAliasTMP)->FATURADO})
            (cAliasTMP)->(DBSkip())
        EndDo

        (cAliasTMP)->(DBCloseArea())

        cQuery := "SELECT COUNT(C5_NUM) AS QTDTOTAL"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " WHERE D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        
        MPSysOpenQuery(cQuery, cAliasTMP)

        nTotQtd := (cAliasTMP)->QTDTOTAL

        (cAliasTMP)->(DBCloseArea())

        cQuery := "SELECT COUNT(C5_NUM) AS QTDTOTAL"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " WHERE D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        cQuery += " AND C5_NOTA<>' '"
        
        MPSysOpenQuery(cQuery, cAliasTMP)

        nTotQFt := (cAliasTMP)->QTDTOTAL

        (cAliasTMP)->(DBCloseArea())

        cQuery := " SELECT C5_CLIENTE,C5_LOJACLI,A1_NOME,SUM(C6_VALOR) AS VALOR, C5_NOTA"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI AND C6.D_E_L_E_T_=' ' "
        cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' ' "
        cQuery += " INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL='"+xFilial("SF4")+"' AND F4_CODIGO=C6_TES AND F4_DUPLIC='S' AND F4.D_E_L_E_T_ =' ' "
        cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        cQuery += " GROUP BY C5_CLIENTE,C5_LOJACLI,A1_NOME,C5_NOTA"
        cQuery += " ORDER BY 3"

        conout(cQuery)

        MPSysOpenQuery(cQuery, cAliasTMP)

	    While (cAliasTMP)->(!Eof())
            Aadd(aAux7,{;
                Alltrim(EncodeUTF8((cAliasTMP)->C5_CLIENTE)),;
                Alltrim(EncodeUTF8((cAliasTMP)->C5_LOJACLI)),;
                Alltrim(EncodeUTF8((cAliasTMP)->A1_NOME)),;
                (cAliasTMP)->VALOR,;
                Iif(!Empty((cAliasTMP)->C5_NOTA),'Faturado','Em Aberto');
            })

            (cAliasTMP)->(DBSkip())
        EndDo

        (cAliasTMP)->(DBCloseArea())
        
        cQuery := "SELECT C6_PRODUTO,B1_DESC,SUM(C6_QTDVEN) AS QTDVEND,SUM(C6_VALOR) AS VLRVEND,COUNT(C6_NUM) AS VENDPV"
        cQuery += " FROM "+RetSQLName("SC5")+" C5"
        cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI AND C6.D_E_L_E_T_=' '"
        cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=' '"
        cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL BETWEEN ' ' AND 'ZZZ'" 
        cQuery += " AND C5_VEND1='"+cVend+"'"
        cQuery += " AND C5_EMISSAO BETWEEN '"+cPriDia+"' AND '"+cUltDia+"'"
        cQuery += " GROUP BY C6_PRODUTO,B1_DESC"
        cQuery += " ORDER BY 3 DESC"

        MPSysOpenQuery(cQuery, cAliasTMP)

	    While (cAliasTMP)->(!Eof())
            Aadd(aAux8,{Alltrim(EncodeUTF8((cAliasTMP)->C6_PRODUTO)),;
                        Alltrim(EncodeUTF8((cAliasTMP)->B1_DESC)),;
                        (cAliasTMP)->QTDVEND,;
                        (cAliasTMP)->VENDPV,;
                        (cAliasTMP)->VLRVEND})

            (cAliasTMP)->(DBSkip())
        EndDo

        (cAliasTMP)->(DBCloseArea())
        
        Aeval(aAux3,{|x| nTotVnd += x[2]})
        Aeval(aAux3,{|x| nTotFat += x[4]})
        Aeval(aAux3,{|x| x[3] := round((x[2]/nTotVnd) * 100,2)})
        
        aAux2 := Array(len(aAux3))
        aAux4 := Array(len(aAux3))

        For ncont := 1 to len(aAux3)
            aAux2[ncont] := aAux3[ncont,3]
        Next ncont

        For ncont := 1 to len(aAux3)
            aAux4[ncont] := aAux3[ncont,1]
        next ncont

        oStatus := JsonObject():New()
        oResult := JsonObject():New()
        
        oResult['header'] := Array(5)
        oResult['header'][1] := JsonObject():New()
        oResult['header'][2] := JsonObject():New()
        oResult['header'][3] := JsonObject():New()
        oResult['header'][4] := JsonObject():New()
        oResult['header'][5] := JsonObject():New()
        
        
        oResult['series1'] := Array(1)
        oResult['series1'][1] := JsonObject():New()
        oResult['series2'] := Array(1)
        oResult['series2'][1] := JsonObject():New()
        oResult['series3'] := Array(1)
        oResult['series3'][1] := JsonObject():New()

        oResult['dataTable1'] := Array(len(aAux7))
        oResult['dataTable2'] := Array(len(aAux8))
        
        oResult['header'][1]['title'] := "Vlr. Total Vendas"
        oResult['header'][1]['type'] := "number"
        oResult['header'][1]['value'] := nTotVnd

        oResult['header'][2]['title'] := "Vlr. Total Faturado"
        oResult['header'][2]['type'] := "number"
        oResult['header'][2]['value'] := nTotFat

        oResult['header'][3]['title'] := EncodeUTF8("Vlr. Ticket Médio")
        oResult['header'][3]['type'] := "number"
        oResult['header'][3]['value'] := nTotVnd / nTotQtd
        
        oResult['header'][4]['title'] := "Num Vendas"
        oResult['header'][4]['type'] := ""
        oResult['header'][4]['value'] := nTotQtd

        oResult['header'][5]['title'] := "Qtd Faturados"
        oResult['header'][5]['type'] := ""
        oResult['header'][5]['value'] := nTotQFt
        
        oResult['series1'][1]['name'] := "Valor Vendas"
        oResult['series1'][1]['data'] := aAux1

        oResult['series2'][1]['labels'] := aAux4
        oResult['series2'][1]['data']   := aAux2

        aAux5 := Array(len(aAux3))
        aAux6 := Array(len(aAux3))
        
        Asort(aAux3,,,{|x,y| x[2] > y[2]})

        For ncont := 1 to len(aAux3)
            aAux5[ncont] := round(aAux3[ncont,2] / 1000,2)
        Next ncont

        For ncont := 1 to len(aAux3)
            aAux6[ncont] := aAux3[ncont,1]
        next ncont

        oResult['series3'][1]['labelcat']   := aAux6
        oResult['series3'][1]['data']       := aAux5

        Asort(aAux7,,,{|x,y| x[4] > y[4]})

        For ncont := 1 to len(aAux7)
            oResult['dataTable1'][ncont] := JsonObject():New()
            oResult['dataTable1'][ncont]['codigo_cliente'] := aAux7[ncont,01]
            oResult['dataTable1'][ncont]['loja'] := aAux7[ncont,02]
            oResult['dataTable1'][ncont]['razao'] := aAux7[ncont,03]
            oResult['dataTable1'][ncont]['valorVendas'] := aAux7[ncont,04]
            //oResult['dataTable1'][ncont]['vlrTicket'] := (aAux7[ncont,04] / nTotVnd) * 100
            oResult['dataTable1'][ncont]['status'] := aAux7[ncont,05]
        next ncont 

        For ncont := 1 to len(aAux8)
            oResult['dataTable2'][ncont] := JsonObject():New()
            oResult['dataTable2'][ncont]['ranking'] := ncont
            oResult['dataTable2'][ncont]['product'] := aAux8[ncont,01]
            oResult['dataTable2'][ncont]['description'] := aAux8[ncont,02]
            oResult['dataTable2'][ncont]['numVendas'] := aAux8[ncont,03]
            oResult['dataTable2'][ncont]['quant'] := aAux8[ncont,04]
            oResult['dataTable2'][ncont]['vlrVendas'] := aAux8[ncont,05]
        next ncont 

        If nAux > 0
            oStatus['code']    := '#200'
            oStatus['message'] := 'sucesso'

        Else
            oStatus['code']    := '#400'
            oStatus['message'] := 'nao encontrado'
        EndIf 

    EndIf 

    oJsonAux['status'] := oStatus
	oJsonAux['result'] := Array(1)
	oJsonAux['result'][1] := oResult

	cJsonCli := FwJsonSerialize(oJsonAux)
    
    conout('json # ' + cJsonCli)

	FreeObj(oJsonAux)
    FreeObj(oStatus)

	oself:SetResponse(cJsonCli)

    

Return .T.

/*/{Protheus.doc} fVendToken
   @description: Token Vendedor
   @type: Static Function
   @author: Felipe Mayer
   @since: 19/06/2023
/*/

Static Function fVendToken(cToken)

Local cRet  := ''
Local aArea := GetArea()
	
	cQuery := " SELECT * FROM "+RetSqlName('SA3')+" " + CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND UPPER(A3_TOKEN) = '"+Upper(cToken)+"' " + CRLF
	
	cAliasTMP := GetNextAlias()
	MPSysOpenQuery(cQuery, cAliasTMP)
	
	If (cAliasTMP)->(!EoF())
		cRet := (cAliasTMP)->A3_COD
	EndIf
	
	(cAliasTMP)->(DbCloseArea())

RestArea(aArea)

Return cRet
