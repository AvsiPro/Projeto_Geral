#INCLUDE "FONT.CH"
#Include "RPTDEF.CH"
#INCLUDE "topconn.ch"

/*

	Ponto de entrada FA070CAN sera executado apos a confirmacao 
    do cancelamento da baixa do contas a receber.

	Utilizado para enviar ao Tracker os cancelamentos das baixas das faturas realizadas

*/
User Function FA070CAN

Local cTipBx        := SuperGetmv("TI_TIPBXT",.F.,"FT")
Local lLigaTr       := SuperGetmv("TI_LIGINT",.F.,.T.)

If lLigaTr
    If !Empty(cTipBx)
        If Alltrim(SE1->E1_TIPO) $ cTipBx 
            EnvTrck()
        EndIf 
    EndIf 
EndIF 

return 


/*/{Protheus.doc} EnvTrck
    Enviar informações de baixa para a tracker (equalizar as bases)
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
Static Function EnvTrck()

Local aArea     := GetArea()
Local oEnvio    := JsonObject():New()
Local cApiDest  := SuperGetMV("TI_APIDES",.F.,"https://buslog.track3r.com.br")
Local cEndPnt   := SuperGetMV("TI_ENDPNT",.F.,"/api/totvs-protheus/cancela-pagamento-fatura")
Local cToken    := SuperGetMV("TI_TOKTRK",.F.,'0D901F83-1739-41E3-995B-7303EF0BB19A')

oEnvio['filial']    := SE1->E1_FILIAL 
oEnvio['prefixo']   := SE1->E1_PREFIXO
oEnvio['titulo']    := SE1->E1_NUM
oEnvio['parcela']   := SE1->E1_PARCELA
oEnvio['tipo']      := SE1->E1_TIPO
oEnvio['natureza']  := SE1->E1_NATUREZ
oEnvio['cliente']   := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")
oEnvio['emissao']   := cvaltochar(SE1->E1_EMISSAO)
oEnvio['vencimento']:= cvaltochar(SE1->E1_VENCTO)
oEnvio['vencto_real']:= cvaltochar(SE1->E1_VENCREA)
oEnvio['data_baixa'] := cvaltochar(dDataBase)
oEnvio['valor']     := SE1->E1_VALOR
oEnvio['historico'] := SE1->E1_HIST 
oEnvio['movimento'] := 'estorno'
oEnvio['usuario']   := cusername

cRet := oEnvio:toJson()

ApiEnv04(cApiDest,cEndPnt,cRet,cToken)

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
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
Static Function ApiEnv04(cUrlDest,cPathDest,cJson,cToken)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local cUrlInt	:=	Alltrim(cUrlDest) 
Local cPath     :=  Alltrim(cPathDest)

Aadd(aHeader,'Content-Type: application/json')
Aadd(aHeader,'Token: '+cToken) 

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:Post(aHeader)
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    oRet := oJson:FromJson(cRet)
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oBody  := JsonObject():New()
    oBody:fromJson(cRet)
    lRet := .F.
Endif

Return(cRet)
