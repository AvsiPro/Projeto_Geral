#include "totvs.ch"

/*/{Protheus.doc} canENotas
Envio de Cancelamento para E-Notas
@type function
@version  12.1.2210
@author Odair Junior
@since 29/01/2024
/*/
user function canENotas( _Filial, _Doc, _Serie, lQuiet )
local   aArea     := getArea()
local   aAreaSA1  := SA1->(getArea())
local   aAreaSD2  := SD2->(getArea())
local   aAreaSF2  := SF2->(getArea())
local   lOk       := .F.
local   cUrl      := "https://api.enotasgw.com.br"
local   oRest
local   cJSON     := ""
local   aHeader   := {}
local   cAcesso   := superGetMV("FS_ENFKEY",,"YTUyOTk0NDktMWNiZS00NjAzLWE0NzYtMWEwOTAwMDUwNzAw")       // API KEY
local   cEmpID    := ""
local   oRet      := JsonObject():New()
local   cErro     := ""
local   cErro2    := ""
local   xRet
local   cNFeID    := ""
local   cIdExt    := ""
default lQuiet    := .F.

    if ! getENotas( @cEmpID )
        if ! lQuiet
            msgStop( "Esta Empresa/Filial não está configurada para o E-Notas", "Integração E-Notas" )
        endif
        restArea( aArea )
        return nil
    endif

    dbSelectArea("ZPD")

    oRest := fwRest():new( cURL )

    aadd(aHeader, "Accept: application/json")
    aadd(aHeader, "Content-Type: application/json; charset=utf-8")
    aadd(aHeader, "Authorization: Basic "+cAcesso )

    cIdExt := substr(getDePara( ZPD->ZPD_IDEXT ),2)
    cIdExt := left(cIdExt, len(cIdExt)-1)

    oRest:setPath("/v1/empresas/" + cEmpID + "/nfes/porIdExterno/" + cIdExt )    // cancelamento da NF

    If (oRest:Delete(aHeader))
        lOk  := .T.
    else
        cErro := oRest:getLastError()
    endif
    xRet := decodeUTF8( oRest:GetResult() )

    if ! empty( cErro2 := oRet:fromJson(xRet) )
        cErro += iif(empty(cErro), "", " | ") + alltrim( cErro2 )
    else
        cNFeID := oRet['nfeId']
    endif

    if ! lQuiet
        if lOk
            msgInfo("Cancelamento de NF enviada com êxito para o E-Notas","Integração E-Notas")
        else
            msgStop("Problema ao enviar cancelamento de NF para E-Notas: "+CRLF+cErro+CRLF+CRLF+xRet," Integração E-Notas")
        endif
    endif

    // atualiza demais registros da NF p/ Last <- N
    cQuery := "update "+retSqlName("ZPE")+" set ZPE_LAST='N'"
    cQuery += " where ZPE_FILIAL='"+xFilial("ZPE")+"'"
    cQuery += " and ZPE_DOC='"+SF2->F2_DOC+"'"
    cQuery += " and ZPE_SERIE='"+SF2->F2_SERIE+"'"
    cQuery += " and D_E_L_E_T_=' '"
    if tcSqlExec( cQuery ) < 0
        conout("[canENotas.prw] Falha ao atualizar ZPE_LAST, Erro: "+CRLF+TCSQLError() )
    endif

    recLock("ZPE",.T.)
    ZPE->ZPE_FILIAL := xFilial("ZPE")
    ZPE->ZPE_DOC    := SF2->F2_DOC
    ZPE->ZPE_SERIE  := SF2->F2_SERIE
    ZPE->ZPE_NFEINT := cIdExt
    ZPE->ZPE_STATUS := iif( lOK, "1", "2" )     // 1=Ok   2=Recusa E-Notas
    ZPE->ZPE_DATA   := Date()
    ZPE->ZPE_HORA   := Time()
    ZPE->ZPE_LAST   := " "
    ZPE->ZPE_NFEID  := cNFeID
    ZPE->ZPE_ERRO   := cErro
    ZPE->ZPE_RETORN := xRet
    ZPE->ZPE_REQUES := cJSON
    msUnlock()

    SA1->( restArea( aAreaSA1 ) )
    SD2->( restArea( aAreaSD2 ) )
    SF2->( restArea( aAreaSF2 ) )
    restArea( aArea )
return lOk


/*/{Protheus.doc} getENotas
Retorna EmpresaID e Ambiente configurado para E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 17/04/2021
@param cEmpID, character, EmpresaID - uso E-Notas
@param cAmbiente, character, Ambiente - Homologação/Produção - uso E-Notas
@return logical, Se a empresa/filial está habilitada para o E-Notas
/*/
static function getENotas( cEmpID )
local aArea := getArea()
local lRet  := .F.

    cEmpID    := ""

    dbSelectArea("ZPA")
    ZPA->(dbSetOrder(1))
    if ZPA->( dbSeek( xFilial("ZPA") + cFilAnt ) ) .and. ZPA->ZPA_ENOTAS == "S"
//    if ZPA->( dbSeek( xFilial("ZPA") + "000101" ) ) .and. ZPA->ZPA_ENOTAS == "S"
        lRet      := .T.
        cEmpID    := alltrim(ZPA->ZPA_EMPID)
    endif

    restArea( aArea )
return lRet

/*/{Protheus.doc} getDePara
Rotina DE / PARA, obter dados para a montagem do JSON de remessa
@type function
@version 1.0
@author Cristiam Rossi
@since 19/04/2021
@param cCampo, character, Campo da tabela 
@return character, valor convertido para string
/*/
static function getDePara( cConteudo )
local   aArea  := getArea()
local   cRet   := ""
local   bError
private xValor
private cErroA := ""

    if ! empty( cConteudo )

        bError   := ErrorBlock( { |oErro| ChkErr( oErro ) } ) 
        begin sequence

        xValor := &( cConteudo )

        if Valtype(xValor)=='C'
            cRet := '"' + alltrim(xValor) + '"'

        elseif Valtype(xValor)=='L'
            cRet := iif( xValor, "true", "false" )

        elseif Valtype(xValor)=='N'
            cRet := cValToChar( xValor )
        endif

        end sequence
        ErrorBlock( bError )
    endif

    restArea(aArea)
return cRet


/*/{Protheus.doc} ChkErr
Tratamento pra não dar error.log
@type function
@version 1.0
@author Cristiam Rossi
@since 19/04/2021
@param oErroArq, object, Objeto do error.log
/*/
static function ChkErr(oErroArq)
    if oErroArq:GenCode > 0
        cErroA += '(' + Alltrim( Str( oErroArq:GenCode ) ) + ') : ' + AllTrim( oErroArq:Description ) + CRLF
    endif
    break
return nil
