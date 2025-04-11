#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} WAPIPOST
    Chamada de post Generica para todas as APIs
    @type  Static Function
    @author Alexandre Venâncio
    @since 10/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function WAPIPOST(aArray,cJson,aHead)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local cUrlInt   :=  aArray[1]
Local cPath     :=  aArray[2]
Local cRet      :=  ''
Local nCont     :=  0
Local aRet      :=  {}

/*
AAdd(aHeader, "Content-Type: application/json")
AAdd(aHeader, "Authorization: Basic "+cToken)
*/

For nCont := 1 to len(aHead)
    AAdd(aHeader, aHead[nCont])
Next nCont  

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:POST(aHeader)
    cRet  := oRest:GetResult()
    oJson := JsonObject():New()
    oJson:FromJson(cRet) 
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oJson  := JsonObject():New()
    oJson:fromJson(cRet)
    lRet := .F.
EndIF 

Aadd(aRet,{lRet,cRet})

Return(aRet)
