

/*/{Protheus.doc} WAPIGET
    Chamada de Get Generica para todas as APIs
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
User Function WAPIGET(aArray,cJson,aHead)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local nPage     := 1
Local aRet      :=  {}
Local cUrlInt   :=  lower(aArray[1])
Local cPath     :=  lower(aArray[2])
Local nCont 
Local lRet      := .T.

For nCont := 1 to len(aHead)
    AAdd(aHeader, aHead[nCont])
Next nCont  


//While lContinua 
    oRest := FWRest():New(cUrlInt)

    //cPathC := strtran(cPath,'#',cvaltochar(nPage))

    oRest:SetPath(cPath)

    //oRest:SetPostParams(cJson)

    If oRest:Get(aHeader)
        oJson := JsonObject():New()
        cRet  := oRest:GetResult()
        oJson:FromJson(cRet) 
        lRet := .T.
    else
        cRetorno := Alltrim(oRest:GetLastError()) 
        cRet := Alltrim(oRest:cresult)
        oBody  := JsonObject():New()
        oBody:fromJson(cRet)
        lRet := .F. 
    Endif

    nPage++
//EndDo 
Aadd(aRet,{lRet,cRet})

Return(aRet)
