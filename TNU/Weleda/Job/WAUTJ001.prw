#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WAUTJ001
Função padrão para autenticação IQVIA
Chamada para buscar Token
Chamada para autenticação
@type user function
@author Alexandre Venâncio
@since 02/04/2025
@version 1.0
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WAUTJ001(param_name)

Local aArea := GetArea()

If Empty(FunName())
	RpcSetType(3)
	RPCSetEnv("00","00001000100")
EndIf	

RestArea(aArea)

Return

/*/{Protheus.doc} APITOKEN
Efetua a chamada da API para geração do token de acesso.
@author Alexandre Venâncio
@since 02/04/2025
@version 1
@param clUserID, C , Usuário da API
@param clPassword, C , Senha da API 
@return aRet , A , Array com o modelo a gravar 
@example
(examples)
@see (links_or_references)
/*/
Static function ApiToken()

Local cToken  := ""

Local oRest
Local aHeader := {}
Local oJson   := ""

// Obtem Token
//https://dev-  teste
//https://stg-  staging
//https://prod  prod
Local cUrlInt := Alltrim(SuperGetmv('TI_IQVURLT',.F.,"https://"))

//Caminho para a api de autenticação
Local cPath			:= Alltrim(SuperGetMV("TI_PATHLOG",.F.,"/oauth2/token?grant_type=client_credentials"))

aadd(aHeader,'Content-Type: application/x-www-form-urlencoded')

aadd(aHeader,'Authorization: Basic ' + SuperGetmv('TI_IQVURMT',.F.,''))

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams("")

If oRest:Post(aHeader)
	// If FWJsonDeserialize(oRest:GetResult(),@oJSon)
    //     cToken := oJson:access_token
    // EndIf
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    FwJsonDeserialize(cRet,@oParser) //nao esta fazendo pelo objeto jsonobject 
    oJson:FromJson(cRet) 
    cRet := cvaltochar(oJson['idRelatorio'])
    lRet := .T.
EndIF

Return(cToken)
