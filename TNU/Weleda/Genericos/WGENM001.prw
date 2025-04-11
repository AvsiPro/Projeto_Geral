#Include "protheus.ch"
#Include "topconn.ch"

/*/{Protheus.doc} WGENM001
Função generica que le as tabelas Z90 e Z91 
para montar o json de cada api dinamicamente
@type user function
@author Alexandre Venâncio
@since 08/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function WGENM001(cCodigo,lVisual)

Local aArea     := GetArea()
Local aCabec    := {}
Local aItens    := {}
Local cJson     := ""
Local aRet      := {}

Default cCodigo := '000001'
Default lVisual := .F.

If Empty(FunName())
    RpcSetType(3)
    RpcSetEnv('T1','D MG 01 ')
EndIf

aCabec := BuscaZ90(cCodigo)
aItens := BuscaZ91(cCodigo)
cJson  := MontaJson(aItens)

If lVisual
    U__VerJson(cJson)
Else 
    Aadd(aRet,cJson)
    Aadd(aRet,aCabec)
    Aadd(aRet,aItens)
EndIf 

RestArea(aArea)
    
Return(aRet)

/*/{Protheus.doc} BuscaZ90
    Busca os dados de informação principal da API de destino
    @type  Static Function
    @author user
    @since 08/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaZ90(cCodigo)

Local aArea := GetArea()
Local aRet  := {}

DbSelectArea("Z90")
DbSetOrder(1)
If Dbseek(xFilial("Z90")+cCodigo)
    Aadd(aRet,Z90->Z90_VERBO)
    Aadd(aRet,Z90->Z90_URLDEV)
    Aadd(aRet,Z90->Z90_URLQA)
    Aadd(aRet,Z90->Z90_URLPRD)
    Aadd(aRet,Z90->Z90_ENDDEV)
    Aadd(aRet,Z90->Z90_ENDQA)
    Aadd(aRet,Z90->Z90_ENDPRD)
    Aadd(aRet,Z90->Z90_DESC)
    Aadd(aRet,Z90->Z90_TIPO)
    Aadd(aRet,Z90->Z90_MODCOM)
    Aadd(aRet,Z90->Z90_REQAUT)
    Aadd(aRet,Z90->Z90_HEADDV)
    Aadd(aRet,Z90->Z90_HEADQA)
    Aadd(aRet,Z90->Z90_HEADPR)
Else 

EndIf 

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} BuscaP91
    Busca os dados referentes aos campos a serem enviados para a api com seu relacionamento local
    @type  Static Function
    @author user
    @since 08/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaZ91(cCodigo)

Local aArea := GetArea()
Local aRet  := {}

DbSelectArea("Z91")
DbSetOrder(1)
If Dbseek(xFilial("Z91")+cCodigo)
    While !Eof() .And. Z91->Z91_COD == cCodigo
        Aadd(aRet,{ Alltrim(Z91->Z91_CPOPAI),;
                    Alltrim(Z91->Z91_TIPPAI),;
                    Alltrim(Z91->Z91_CPODES),;
                    Alltrim(Z91->Z91_CPOORI),;
                    Alltrim(Z91->Z91_CNTFIX),;
                    Alltrim(Z91->Z91_TIPCNT),;
                    Alltrim(Z91->Z91_ITEM),;
                    Alltrim(Z91->Z91_MAXLEN)})
        Dbskip()
    EndDo 
Else 

EndIf 

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} MontaJson(aItens)
    Monta o Json ja fazendo o de/para dos campos
    @type  Static Function
    @author user
    @since 08/04/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MontaJson(aItens)

Local aArea := GetArea()
Local cJson := ""
Local oJson := JsonObject():New()
Local nCont := 0
Local nX    := 0
Local nZ    := 0
Local cCpoDes := ''
Local cFilDes := ''
Local oItem := Nil
Local oFilho:= Nil 

//Primeira vez pega somente os itens da raiz
For nCont := 1 to len(aItens)
    If Empty(aItens[nCont,01]) .And. Empty(aItens[nCont,02])
        oJson[&("aItens[nCont,03]")] := If(!Empty(aItens[nCont,05]),aItens[nCont,05],aItens[nCont,04])
    EndIf 
Next nCont 

//Segunda vez pega os "pais" da raiz e para os demais "pais" já monta a estrutura restante
For nCont := 1 to len(aItens)
    If Empty(aItens[nCont,01]) .And. aItens[nCont,06] == "P"
        oJson[&("aItens[nCont,03]")] := {} 
        cCpoDes := aItens[nCont,03]
        oItem := JsonObject():New()
        oFilho := Nil 

        For nX := 1 to len(aItens)
            If AllTrim(aItens[nX,01]) == AllTrim(cCpoDes)
                oItem[aItens[nX,03]] := If(!Empty(aItens[nX,05]), aItens[nX,05], If(aItens[nX,06] == "P",{},aItens[nX,04]))

                If aItens[nX,06] == "P"
                    cFilDes := aItens[nX,03]
                    oFilho := JsonObject():New()
                    For nZ := 1 to len(aItens)
                        If AllTrim(aItens[nZ,01]) == AllTrim(cFilDes)
                            oFilho[aItens[nZ,03]] := If(!Empty(aItens[nZ,05]), aItens[nZ,05], If(aItens[nZ,06] == "P",{},aItens[nZ,04]))
                        EndIf 
                    Next nZ 
                    Aadd(oItem[aItens[nX,03]],oFilho)
                EndIf 
            EndIf
        Next nX

        // Adiciona o objeto no array
        aAdd(oJson[cCpoDes], oItem)
    
    EndIf 
Next nCont 

cJson := oJson:toJson()


RestArea(aArea)

Return(cJson)

