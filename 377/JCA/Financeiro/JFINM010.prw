#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"
#Include 'RestFul.ch'

/*
    Job para integração com a Equals para lançamento dos movimentos bancarios por dia conciliados

    Não tem MIT
    
*/
User Function JFINM010

Local aArea     := GetArea()
Local nCont 
Local aSm0      := {}
Local aGrupos   := {}
Local aItens    := {}
//Local aSeries   := {}
Local nSeries   

Private aValores:= {}
Private aCabec  := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

Private cUrlInt	:=	Alltrim(SuperGetMV("TI_XAPIEQU",.F.,'https://app.equals.com.br/')) 
Private cToken  :=  SuperGetMV("TI_XTOEQU",.F.,"YWxleGFuZHJlLnZlbmFuY2lvQGdydXBvMzc3LmNvbS5icjpGRmxscm44QTYxVVZOdW5YNHNlMDRoaVhrTjlXQlpqUA==")

aSm0 := FWLoadSM0()

For nCont := 1 to len(aSm0)
    If Ascan(aGrupos,{|x| x == aSM0[nCont,03]+'-'+aSm0[nCont,17]}) == 0 
        Aadd(aGrupos,aSM0[nCont,03]+'-'+aSm0[nCont,17])
    EndIf 
Next nCont

Ddate := ctod('05/04/2024') //ddatabase-3
cTime := time()

cIdRel := xApiPost(Ddate)

aItens := xApiGet(cIdRel)

For nCont := 1 to len(aItens)
    For nSeries := 1 to len(aItens[nCont])
        If aItens[nCont,nSeries]:hasProperty('banco')
            If aItens[nCont,nSeries]['banco'] <> '0'
                cEmpresa := aItens[nCont,nSeries]['categoriaEstabelecimento']
                cCodigoE := aItens[nCont,nSeries]['numeroFiliacaoEstabelecimento']
                cBanco   := aItens[nCont,nSeries]['banco']
                cAgencia := aItens[nCont,nSeries]['agencia']
                cConta   := aItens[nCont,nSeries]['numeroConta']
                dVencto  := aItens[nCont,nSeries]['dataVencimento']
                dDtLote  := aItens[nCont,nSeries]['dataLote']
                cNumLote := aItens[nCont,nSeries]['numeroLote']
                cAdquir  := aItens[nCont,nSeries]['adquirente']
                cBandei  := aItens[nCont,nSeries]['bandeira']
                nVlrPrv  := aItens[nCont,nSeries]['valorPrevisto']
                nVlrPag  := aItens[nCont,nSeries]['valorPago']
                nVlrAbt  := aItens[nCont,nSeries]['valorEmAberto']

                Aadd(aValores,{ cEmpresa,;
                                cCodigoE,;
                                cBanco,;
                                cAgencia,;
                                cConta,;
                                dVencto,;
                                dDtLote,;
                                cNumLote,;
                                cAdquir,;
                                cBandei,;
                                nVlrPrv,;
                                nVlrPag,;
                                nVlrAbt})
            EndIf 
        Else 
            cBanco := ''
        EndIf 
        
    Next nSeries
    /*cId := aItens[nCont]:id
    cAdiq := aItens[nCont]:nome
    aSeries := aItens[nCont]:series
    For nSeries := 1 to len(aSeries)
        cAgencia := aSeries[nSeries]:agencia
        cConta   := aSeries[nSeries]:conta
        dDiaPgto := aSeries[nSeries]:data
        nVlrBrut := aSeries[nSeries]:valor 
        nVlrLiq  := aSeries[nSeries]:liquido

        aBco := BuscaBco(cvaltochar(cAgencia),cConta)
        cBanco := ''
        cFilLct:= ''

        If len(aBco) > 0
            cBanco := aBco[1,2]
            cFilLct:= aBco[1,1]
        EndIf 

        If nVlrLiq > 0
            Aadd(aValores,{cId,;
                            cAdiq,;
                            cBanco,;
                            cvaltochar(cAgencia),;
                            cConta,;
                            stod(strtran(dDiaPgto,"-")),;
                            nVlrBrut,;
                            nVlrLiq,;
                            cFilLct})
        EndIf 
    Next nSeries*/

Next nCont 

If len(aValores) > 0
/*Aadd(aValores,{ cBanco,;
                            cAgencia,;
                            cConta,;
                            dVencto,;
                            dDtLote,;
                            cNumLote,;
                            cAdquir,;
                            cBandei,;
                            nVlrPrv,;
                            nVlrAbt})*/
    Aadd(aCabec,{'Empresa',;
                'Codigo_Empresa',;
                'Banco',;
                'Agencia',;
                'Conta',;
                'Vencimento',;
                'Data_Lote',;
                'Numero_lote',;
                'Adquirente',;
                'Bandeira',;
                'Valor_Previsto',;
                'Valor_Pago',;
                'Valor_Em_Aberto'})

    GeraPlan()
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} BuscaBco
    (long_description)
    @type  Static Function
    @author user
    @since 28/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaBco(cAgencia,cConta)

Local aArea := GetArea()
Local cQuery 
Local aRet  := {}

cQuery := "SELECT A6_FILIAL,A6_COD "
cQuery += " FROM "+RetSQLName("SA6")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND A6_AGENCIA='"+cAgencia+"' AND rtrim(A6_NUMCON)+rtrim(A6_DVCTA)='"+Alltrim(cConta)+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISM001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aRet,{TRB->A6_FILIAL,TRB->A6_COD})

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} xApiPost
    Chamada de post inicial para geração do relatório pela api
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xApiPost(Ddate)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local oParser
Local cJson     :=  montajson(Ddate)
Local cPath     :=  Alltrim(SuperGetMV("TI_XENPEQU",.F.,'api/v2/fluxodecaixa/gerar-relatorio'))
Local cRet      :=  ''
/*
    Ultima validada enviada pelo pessoal da equals
    POST https://app.equals.com.br/api/v2/fluxodecaixa/gerar-relatorio
    GET https://app.equals.com.br/api/v2/fluxodecaixa/carregar-relatorio?idRelatorio=IDGERADOPELOPOST
*/

AAdd(aHeader, "Content-Type: application/json")
AAdd(aHeader, "Authorization: Basic "+cToken)

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:POST(aHeader)
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    FwJsonDeserialize(cRet,@oParser) //nao esta fazendo pelo objeto jsonobject 
    oJson:FromJson(cRet) 
    cRet := cvaltochar(oJson['idRelatorio'])
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oBody  := JsonObject():New()
    oBody:fromJson(cRet)
    FwJsonDeserialize(cRet,@oParser) 
    lRet := .F.
EndIF 


Return(cRet)


/*/{Protheus.doc} xApiGet
    Chamada de get para buscar o relatório 
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xApiGet(cIdRel)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lContinua :=  .T.
Local cJson 
Local cPathG    :=  Alltrim(SuperGetMV("TI_XENGEQU",.F.,'api/v2/fluxodecaixa/carregar-relatorio?idRelatorio='+cIdRel+'&page=#'))
Local nPage     := 1
Local cPathC    := ''
Local aItens    :=  {}


sleep(1500)

AAdd(aHeader, "Content-Type: application/json")
AAdd(aHeader, "Authorization: Basic "+cToken)

While lContinua 
    oRest := FWRest():New(cUrlInt)

    cPathC := strtran(cPathG,'#',cvaltochar(nPage))

    oRest:SetPath(cPathC)

    oRest:SetPostParams(cJson)


    If oRest:Get(aHeader)
        oJson := JsonObject():New()
        cRet  := oRest:GetResult()
        oJson:FromJson(cRet) 
        If len(oJson['items']) > 0
            Aadd(aItens,oJson['items'])
        else 
            lContinua := .F.
        Endif 
    else
        cRetorno := Alltrim(oRest:GetLastError()) 
        cRet := Alltrim(oRest:cresult)
        oBody  := JsonObject():New()
        oBody:fromJson(cRet)
        lContinua := .F.
    Endif

    nPage++
EndDo 

Return(aItens)

/*/{Protheus.doc} Montajson
    (long_description)
    @type  Static Function
    @author user
    @since 30/04/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Montajson(Ddate)

Local cRet  := ''
Local cDate := dtos(Ddate)

cDate := substr(cDate,1,4)+'-'+substr(cDate,5,2)+'-'+substr(cDate,7,2)

cRet := '{'
cRet += '  "opcaoData": "V",'
cRet += '  "dataBase": "'+cDate+'",'
cRet += '  "dataInicial": "'+cDate+'",'
cRet += '  "dataFinal": "'+cDate+'",'
cRet += '  "adquirentes": [],'
cRet += '  "bandeiras": [],'
cRet += '  "estabelecimentos": null,'
cRet += '  "tipoProdutos": [],'
cRet += '  "mostrarSeparadoPorEstab": true,'
cRet += '  "mostrarSeparadoPorFiliacaoEstab": true,'
cRet += '  "mostrarSeparadoPorLote": true,'
cRet += '  "mostrarSeparadoPorDomicilioBancario": true,'
cRet += '  "mostrarApenasLotesComDiferenca": true,'
cRet += '  "opcaoDiferenca": "L"'
cRet += '} '

Return(cRet)

/*/{Protheus.doc} GeraPlan
    (long_description)
    @type  Static Function
    @author user
    @since 04/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraPlan()

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Relacao_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
//Local cGuia     :=  'Conciliação'
Local cExterno  :=  'Relacao_Pagamentos'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cExterno) 
oExcel:AddTable (cExterno,cExterno)

For nX := 1 to len(aCabec[1])
    oExcel:AddColumn(cExterno,cExterno,aCabec[1,nX],1,1)
Next nX


For nX := 1 to len(aValores)
    aAux := {}
    For nY := 1 to len(aCabec[1])
        Aadd(aAux,aValores[nX,nY])
    Next nY

    oExcel:AddRow(cExterno,cExterno,aAux)
Next nX



oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)
