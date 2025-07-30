#include "PROTHEUS.CH"

/*/{Protheus.doc} CIJOBCF3
	Jobs de envio do pdf das notas para a Ecuro
	@type function
	@author TNU
	@since 07/2025
	@param cAlias, character, param_description
	@return logical, return_description
/*/

/*-------------------------------------------------------*/
/*                 Criação 18/07/25                      */
/*                                                       */
/*-------------------------------------------------------*/


User Function CIJOBCF3()

    Local aItens := {}
    Local nCont 

    Default cEmpJob := '01'
	Default cFilJob := '000101'

    If Empty(FunName())
        RpcSetType(3)
        RpcSetEnv(cEmpJob, cFilJob)
    EndIf 

	cSumario := CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| [CIJOBCF3] - Iniciando Execucao - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    Conout(cSumario)

    Conout("[CIJOBCF3] - Chamada da função jEnvENotas()")
    
    //chamar rotina para pegar os links
    aItens := buscaLnk()
    //chamar rotina para enviar para a ecuro
    For nCont := 1 to len(aItens)
        envEcuro(aItens[nCont])
    Next nCont 

    Conout("[CIJOBCF3] - Retorno da função jEnvENotas()")

    cSumario := CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| [CIJOBCF3] - Finalizando Execucao - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    Conout(cSumario)

    conout(cSumario)

Return 

/*/{Protheus.doc} buscaLnk
Obter EMPID (e-Notas) e chave Externa da RPS (e-Notas) p/ consulta
@type function
@version 1.0
@author Cristiam
@since 20/04/2021
@return array, { EMPID, NFIDEXT }   // Código Empresa e-Notas e Chave Externa do RPS e-Notas
/*/
static function buscaLnk()
    
    local cAliasQry := getNextAlias()
    local aRet      := {}
    Local dDia      := dDatabase //para validar, coloquei a data de 05/06/25

    beginSQL alias cAliasQry
        select ZPW_NFEINT, ZPW_LNKPDF , ZPW_NFEID, ZPW_DATA, ZPW_HORA
        from %Table:ZPW% ZPW
        where ZPW_FILIAL = ' '
          and ZPW_STATUS IN ('Autorizada')
          AND ZPW_DATA >=   %exp:dDia%
          and ZPW.%notDel%
    endSQL

    while ! (cAliasQry)->( eof() )
        aAdd( aRet, {   (cAliasQry)->ZPW_NFEINT,;
                        (cAliasQry)->ZPW_LNKPDF,;
                        (cAliasQry)->ZPW_NFEID,;
                        (cAliasQry)->ZPW_DATA,;
                        (cAliasQry)->ZPW_HORA })
        (cAliasQry)->( dbSkip() )
    endDo
    (cAliasQry)->( dbCloseArea() )

return(aRet)

/*/{Protheus.doc} envEcuro
    (long_description)
    @type  Static Function
    @author user
    @since 18/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function envEcuro(aAux)
    
    Local aArea := GetArea()
    Local oRest 
    Local cJSON := ''

    local   cUrl      := "https://api.enotasgw.com.br"
    local   aHeader   := {}
    local   cAcesso   := superGetMV("FS_ENFKEY",,"YTUyOTk0NDktMWNiZS00NjAzLWE0NzYtMWEwOTAwMDUwNzAw")       // API KEY
    local   oRet      := JsonObject():New()
    local   cErro     := ""
    local   cErro2    := ""
    local   xRet

    oRest := fwRest():new( cURL )

    aadd(aHeader, "Accept: application/json")
    aadd(aHeader, "Content-Type: application/json; charset=utf-8")
    aadd(aHeader, "Authorization: Basic "+cAcesso )

    //oRest:setPath("/v1/empresas/" + cEmpID + "/nfes")    // emissao da NF

    cJSON += '{'
    cJSON +=    '"nfeInt": "'+ alltrim(aAux[1])+'",'
    cJSON +=    '"linkPdf": "'+ alltrim(aAux[2])+'",'
    cJSON +=    '"nfeId": "'+ aAux[3]+'",'
    cJSON +=    '"dataEmissao": "'+ cvaltochar(stod(aAux[4]))+'",'
    cJSON +=    '"horaEmissao": "'+ aAux[5]+'"'
    cJSON += '}'

    
    oRest:SetPostParams( cJSON )
    
    if oRest:Post( aHeader )
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

    RestArea(aArea)

Return(xRet)
