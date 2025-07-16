#include "totvs.ch"
/*/{Protheus.doc} JSONform
Formata uma string JSON modo Pretty
@type function
@version 1.0
@author Cristiam
@since 18/04/2021
@param cJSON, character, String JSON
@return character, String JSON pretty format
/*/
user function JSONform( cJSON, lQuiet, cErro )
local   cMsg
local   cNewMsg := ""
local   nAspas  := 0
local   nRecuo  := 0
local   nI
local   oJSON   := JsonObject():New()
default cJSON   := ""
default lQuiet  := .F.
default cErro   := ""

// Validação JSON de entrada

    cMsg := alltrim( cJSON )

    if empty( cMsg )
        cErro := "JSONform: string vazia"
        if ! lQuiet
            msgStop( cErro, "JSONform")
        endif
        return ""
    endif

    if ! Empty( cErro := oJSON:fromJson(cMsg) )
        cErro := "JSONform: JSON corrompido"+CRLF+cErro
        if ! lQuiet
            msgStop( cErro, "JSONform")
        endif
        return ""
    endif

    oJSON:DeActivate()
    oJSON := nil

// troca os tokens abaixo para formatá-los depois
    cMsg := strTran( cMsg, "},", chr(176) )
    cMsg := strTran( cMsg, "],", chr(177) )
    cMsg := strTran( cMsg, "),", chr(178) )
    cMsg := strTran( cMsg, '\"', chr(179) )

// adicionando ENTERS
    cMsg := strTran( cMsg, "{", "{"+CRLF )
    cMsg := strTran( cMsg, "[", "["+CRLF )
    cMsg := strTran( cMsg, "(", "("+CRLF )
    cMsg := strTran( cMsg, "}", CRLF+"}"+CRLF )
    cMsg := strTran( cMsg, "]", CRLF+"]"+CRLF )
    cMsg := strTran( cMsg, ")", CRLF+")"+CRLF )

// adicionando ENTERS nos tokens trocados
    cMsg := strTran( cMsg, chr(176), CRLF+"},"+CRLF )
    cMsg := strTran( cMsg, chr(177), CRLF+"],"+CRLF )
    cMsg := strTran( cMsg, chr(178), CRLF+"),"+CRLF )

// localiza vírgulas que não estejam entre ""
    for nI := 1 to len( cMsg )
        cToken := substr(cMsg,nI,1)

        if cToken == '"'
            nAspas++
        endif

        if cToken == "," .and. nAspas % 2 == 0
            cToken += CRLF
        endif

        cNewMsg += cToken
    next

    cNewMsg := strTran(cNewMsg, chr(179), '\"')

// gerando array por linhas para adicionar os recuos
    aLinhas := strTokArr( cNewMsg, CRLF )
    cNewMsg := ""

    for nI := 1 to len( aLinhas )
        if right( alltrim(aLinhas[nI]), 1 ) $ ")]}" .or. left( alltrim(aLinhas[nI]), 1 ) $ ")]}"
            nRecuo -= 3
        endif

        cNewMsg += space(nRecuo) + alltrim( aLinhas[nI] ) + CRLF

        if right( alltrim(aLinhas[nI]), 1 ) $ "{[("
            nRecuo += 3
        endif
    next

return cNewMsg
