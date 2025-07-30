#include "totvs.ch"
#include 'RESTFUL.CH'
#include 'TBICONN.CH'
/*
{
    "tipo": "NFS-e",
    "empresaId": "string",
    "nfeId": "string",
    "nfeIdExterno": "string",
    "nfeStatus": "string",
    "nfeMotivoStatus": "string",
    "nfeLinkPdf": "http://api.enotasgw.com.br/file/(...)/pdf",
    "nfeLinkXml": "http://api.enotasgw.com.br/file/(...)/xml",
    "nfeNumero": "string",
    "nfeCodigoVerificacao": "string",
    "nfeNumeroRps": "string",
    "nfeSerieRps": "string",
    "nfeDataCompetencia": "date"
}
*/

/*
+------------------------------------------------------------------+
|                  Historico de Alteracao                          |
|                                                                  |
| 17/01/2025 - Alteracao na selecao do ZPE, utilizando ID NF       |
|                                                                  |
|                                                                  |
+------------------------------------------------------------------+

*/



WSRESTFUL intENotas DESCRIPTION 'API de integração E-Notas'

    WSMETHOD POST webhook;
    DESCRIPTION 'WebHook' ;
    WSSYNTAX '/intENotas/v1/webhook' ;
    PATH '/intENotas/v1/webhook' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON

ENDWSRESTFUL


/*/{Protheus.doc} POST 
/intENotas/v1/webhook
retorno WebHook do E-Notas
@return     Logical, Informa se o processo foi executado com sucesso.
@type       method
@author		Cristiam Rossi
@since		16/04/2021
@version	1.0
/*/
WSMETHOD POST webhook WSSERVICE intENotas
Local lRet        := .T.
Local oBody       := JsonObject():New()
Local oResponse   := JsonObject():New()
Local cBody       := self:GetContent()
Local cErro       := ''
Local oException  := ErrorBlock({|e| cErro := + e:Description + e:ErrorStack, lRet := .F. })
Local cResponse   := ""

    cBody := decodeUTF8( cBody )

    Begin Sequence

	if ! RpcSetEnv("01","01")
        lRet := .F.
        oResponse['code'] := 4
        oResponse['status'] := 400
        oResponse['message'] := 'Falha inicializar ambiente'
        oResponse['detailedMessage'] := 'Ocorreu algum erro interno na inicializacao da empresa/filial'
	EndIf

    varinfo( "cBody", cBody )

    if lRet .and. empty( cBody )
        lRet := .F.
        oResponse['code'] := 4
        oResponse['status'] := 400
        oResponse['message'] := 'Falta dados'
        oResponse['detailedMessage'] := 'Verifique se o conteudo enviado esta formatado corretamente em JSON'

    elseif lRet .and. ! Empty( cErro := oBody:fromJson(cBody) )
        lRet := .F.
        oResponse['code'] := 4
        oResponse['status'] := 400
        oResponse['message'] := 'Falha ao tentar converter o conteudo enviado'
        oResponse['detailedMessage'] := 'Verifique se o conteudo enviado esta formatado corretamente em JSON. Erro: ' + cErro
    endif

    if lRet
        recLock("ZPW", .T.)
        ZPW->ZPW_FILIAL := xFilial("ZPW")
        ZPW->ZPW_TIPO   := oBody["tipo"]
        ZPW->ZPW_EMPID  := oBody["empresaId"]
        ZPW->ZPW_NFEID  := oBody["nfeId"]
        ZPW->ZPW_NFEINT := oBody["nfeIdExterno"]
        ZPW->ZPW_STATUS := oBody["nfeStatus"]
        ZPW->ZPW_MOTIVO := oBody["nfeMotivoStatus"]
        ZPW->ZPW_LNKPDF := oBody["nfeLinkPdf"]
        ZPW->ZPW_LNKXML := oBody["nfeLinkXml"]
        ZPW->ZPW_NUMERO := oBody["nfeNumero"]
        ZPW->ZPW_CODVER := oBody["nfeCodigoVerificacao"]
        ZPW->ZPW_NUMRPS := oBody["nfeNumeroRps"]
        ZPW->ZPW_SERRPS := oBody["nfeSerieRps"]
        ZPW->ZPW_COMPET := oBody["nfeDataCompetencia"]
        ZPW->ZPW_DATA   := date()
        ZPW->ZPW_HORA   := time()
        msUnlock()
        cResponse := '{"code": 200,"status": true}'
    endif

    End Sequence

    ErrorBlock(oException)

    If lRet
        self:SetResponse( cResponse )
    EndIf

    If ! lRet
        SetRestFault(   oResponse['code'],;
                        oResponse['message'],;
                        .T.,;
                        oResponse['status'],;
                        oResponse['detailedMessage'];
                    )
    EndIf

    oResponse:DeActivate()
    oResponse := nil 
    oBody:DeActivate()
    oBody := nil

//    RpcClearEnv()
Return lRet

/*/{Protheus.doc} jIntENotas
Job com Request ao E-Notas para obter Status das RPS enviadas
@type function
@version 1.0
@author Cristiam Rossi
@since 20/04/2021
/*/
user function jIntENotas
local nI
local nHdlJ
local nRet     := 0
local cSumario := CRLF
local aRPS     := {}

   makeDir("/E-NOTAS")

    if ( nHdlJ := fCreate( "/E-NOTAS/jIntENotas.lck" ) ) == -1
        RpcClearEnv()       // Job em execução
        return nil          // sair
    endif

    cSumario += "+---------------------------------------------+" + CRLF
    cSumario += "| JOB JIntENotas - Inicio - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+---------------------------------------------+" + CRLF

    if ! RpcSetEnv("01","01")
        cSumario += "! falha ao conectar empresa/filial" + CRLF
    else
        aRPS := getRPS()    // { ZPA_EMPID, ZPE_NFEINT }

        for nI := 1 to len( aRPS )
            getENotas( aRPS[nI][1], aRPS[nI][2], aRPS[nI][3], aRPS[nI][4], aRPS[nI][5] )
            nRet++
        next
	endif

    cSumario += "Consultas E-Notas realizadas: "+cValToChar(nRet)+CRLF

    fClose( nHdlJ )

    cSumario += CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| JOB JIntENotas - Termino - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF

    conout(cSumario)

    RpcClearEnv()
return nil


/*/{Protheus.doc} getRPS
Obter EMPID (e-Notas) e chave Externa da RPS (e-Notas) p/ consulta
@type function
@version 1.0
@author Cristiam
@since 20/04/2021
@return array, { EMPID, NFIDEXT }   // Código Empresa e-Notas e Chave Externa do RPS e-Notas
/*/
static function getRPS()
local cAliasQry := getNextAlias()
local aRet      := {}

    beginSQL alias cAliasQry
        select ZPA_EMPID, ZPE_NFEINT, ZPE_FILIAL, ZPE_DOC, ZPE_SERIE
        from %Table:ZPE% ZPE
        join %Table:ZPA% ZPA
            on ZPA_FILIAL=' ' and ZPA_FILEMP=ZPE_FILIAL and ZPA.%notDel%
        where ZPA_FILIAL = ' '
          and ZPE_STATUS IN ('1','5')
          and ZPE_LAST = ' '
          AND ZPE_DATA >= '20250101'
          and ZPE.%notDel%
    endSQL

    while ! (cAliasQry)->( eof() )
        aAdd( aRet, {   (cAliasQry)->ZPA_EMPID,;
                        (cAliasQry)->ZPE_NFEINT,;
                        (cAliasQry)->ZPE_FILIAL,;
                        (cAliasQry)->ZPE_DOC,;
                        (cAliasQry)->ZPE_SERIE })
        (cAliasQry)->( dbSkip() )
    endDo
    (cAliasQry)->( dbCloseArea() )

return aRet


/*/{Protheus.doc} getENotas
Obtém retorno dos RPS enviados ao E-Notas
@type function
@version 1.0
@author Cristiam
@since 20/04/2021
@param cEmpID, character, Código Clínica/Filial do E-Notas
@param cIdExt, character, Chave Externa do RPS no E-Notas
@param _Filial, character, Filial do RPS
@param _Doc, character, Número do RPS
@param _Serie, character, Série do RPS
/*/
static function getENotas( cEmpID, cIdExt, _Filial, _Doc, _Serie )
local   lOk       := .F.
local   cUrl      := "https://api.enotasgw.com.br"
local   oRest
local   aHeader   := {}
local   cAcesso   := superGetMV("FS_ENFKEY",,"YTUyOTk0NDktMWNiZS00NjAzLWE0NzYtMWEwOTAwMDUwNzAw")       // API KEY
local   oRet      := JsonObject():New()
local   cErro     := ""
local   cErro2    := ""
local   xRet

    cEmpID := alltrim(cEmpID)

    oRest := fwRest():new( cURL )

    aadd(aHeader, "Accept: application/json")
    aadd(aHeader, "Content-Type: application/json; charset=utf-8")
    aadd(aHeader, "Authorization: Basic "+cAcesso )

    oRest:setPath( "/v1/empresas/" + cEmpID + "/nfes/porIdExterno/" + strtran(alltrim(cIdExt)," ","%20") )    // Consulta RPS no E-Notas

    if oRest:Get( aHeader )
        lOk  := .T.
    else
        cErro := oRest:getLastError()
    endif
    xRet := decodeUTF8( oRest:GetResult() )

    if ! empty( cErro2 := oRet:fromJson(xRet) )
        cErro += iif(empty(cErro), "", " | ") + alltrim( cErro2 )
    else

        varinfo("oRet - intENotas", oRet)

        recLock("ZPW", .T.)
        ZPW->ZPW_FILIAL := xFilial("ZPW")
        ZPW->ZPW_TIPO   := oRet["tipo"]
        ZPW->ZPW_EMPID  := cEmpID
        ZPW->ZPW_NFEID  := oRet["id"]
        ZPW->ZPW_NFEINT := oRet["idExterno"]
        ZPW->ZPW_STATUS := oRet["status"]
        ZPW->ZPW_MOTIVO := oRet["motivoStatus"]
        ZPW->ZPW_LNKPDF := oRet["linkDownloadPDF"]
        ZPW->ZPW_LNKXML := oRet["linkDownloadXMl"]
        ZPW->ZPW_NUMERO := oRet["Numero"]
        ZPW->ZPW_CODVER := oRet["CodigoVerificacao"]
        ZPW->ZPW_NUMRPS := cValToChar( oRet["numeroRps"] )
        ZPW->ZPW_SERRPS := oRet["serieRps"]
        ZPW->ZPW_COMPET := oRet["dataCompetenciaRps"]    // 2021-04-17T23:43:00Z
        ZPW->ZPW_DATA   := date()
        ZPW->ZPW_HORA   := time()
        msUnlock()

        // atualiza demais registros da NF p/ Last <- N
        cQuery := "update "+retSqlName("ZPE")+" set ZPE_LAST='N'"
        cQuery += " where ZPE_FILIAL='"+_Filial+"'"
        cQuery += " and ZPE_NFEID ='"+oRet["id"]+"'"
        //cQuery += " and ZPE_DOC='"+_DOC+"'"
        // cQuery += " and ZPE_SERIE='"+_SERIE+"'"
        cQuery += " and D_E_L_E_T_=' '"
        if tcSqlExec( cQuery ) < 0
            conout("[intENotas.prw] Falha ao atualizar ZPE_LAST, Erro: "+CRLF+TCSQLError() )
        endif

        cStatus := upper( oRet['status'] )
        if cStatus == "NEGADA"
            cStat := "3"
        elseif cStatus == "AUTORIZADA"
            cStat := "4"
        elseif cStatus $ "AGUARDANDOAUTORIZACAO;SOLICITANDOAUTORIZACAO;AUTORIZACAOSOLICITADA;EMPROCESSODEAUTORIZACAO;AUTORIZADAAGUARDANDOGERACAOPDF"
            cStat := "5"        // processo de autorização
        else
            cStat := "6"        // Processo de Cancelamento
        endif

        recLock("ZPE",.T.)
        ZPE->ZPE_FILIAL := _Filial
        ZPE->ZPE_DOC    := _DOC
        ZPE->ZPE_SERIE  := _SERIE
        ZPE->ZPE_NFEINT := cIdExt
        ZPE->ZPE_STATUS := cStat    // 1=Ok;2=Recusa E-Notas;3=Negada Pref.;4=Autorizada;5=Processo Autorização;6=Outros
        ZPE->ZPE_DATA   := Date()
        ZPE->ZPE_HORA   := Time()
        ZPE->ZPE_LAST   := " "
        ZPE->ZPE_NFEID  := oRet["id"]
        ZPE->ZPE_CODVER := oRet["codigoVerificacao"]
        ZPE->ZPE_ERRO   := iif( empty(cErro), oRet['status'], cErro )
        ZPE->ZPE_RETORN := xRet
        ZPE->ZPE_REQUES := ""
        ZPE->ZPE_ORIGEM := 'getENotas'
        //ZPE->ZPE_DTNOTA := oRet["dataAutorizacao"]
		ZPE->ZPE_NFELET := oRet["Numero"]
		ZPE->ZPE_CODNFE := oRet["codigoVerificacao"]
		//ZPE->ZPE_EMINFE := oRet["dataCompetenciaRps"]
        msUnlock()
    endif

return nil
