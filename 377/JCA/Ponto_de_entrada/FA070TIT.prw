#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#Include "RPTDEF.CH"
#INCLUDE "topconn.ch"

/*

	Ponto de entrada FA070TIT sera executado apos a confirmacao da baixa do contas a receber.

	Utilizado para enviar ao Tracker as baixas das faturas realizadas

*/
User function FA070TIT()

    Local cInst         := GETMV("MV_INSCOB")
    Local cTipBx        := SuperGetmv("TI_TIPBXT",.F.,"FT")
    Local lLigaTr       := SuperGetmv("TI_LIGINT",.F.,.T.)
    Private aItemsFI2   := {}

    IF cInst == "1" .And. !EMPTY(SE1->E1_IDCNAB) .And. !EMPTY(SE1->E1_NUMBOR)
        If  MSGYESNO("Titulo se encontra em cobrança bancária. Deseja gerar instrução de cobrança? ")
            DbselectArea("FI2")
            DbSetOrder(1)//FI2_FILIAL+FI2_CARTEI+FI2_NUMBOR+FI2_PREFIX+FI2_TITULO+FI2_PARCEL+FI2_TIPO+FI2_CODCLI+FI2_LOJCLI+FI2_OCORR+FI2_GERADO
            If !Dbseek(xFilial("FI5")+SE1->E1_SITUACA+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+"02"+"2")
                Aadd(aItemsFI2,{"02","","",dtoc(ddatabase),"E1_BAIXA","D"})
                U_F040GrvFI2(aItemsFI2)
            EndIf
            FI2->(MsUnLock())
        EndIf
    EndIf

    If lLigaTr
        If !Empty(cTipBx)
            If !Empty(SE1->E1_NUMLIQ)
                nSaldo := conssld()
                If Alltrim(SE1->E1_TIPO) $ cTipBx .And. nSaldo == nValrec
                    EnvTrck()
                EndIf
            Else
                If Alltrim(SE1->E1_TIPO) $ cTipBx .And. SE1->E1_SALDO == nValrec
                    EnvTrck()
                EndIf 
            EndIf 
        EndIf 
    EndIF 

Return .T.

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
Local cEndPnt   := SuperGetMV("TI_ENDPNT",.F.,"/api/totvs-protheus/confirma-pagamento-fatura")
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
oEnvio['data_baixa']:= cvaltochar(dDataBase)
oEnvio['valor']     := SE1->E1_VALOR
oEnvio['historico'] := SE1->E1_HIST 
oEnvio['motivo_baixa'] := cMotBx
oEnvio['movimento'] := 'liquidacao'
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

/*/{Protheus.doc} conssld
    (long_description)
    @type  Static Function
    @author user
    @since 23/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function conssld()

Local aArea := GetArea()
Local nRet  :=  0
Local cQuery 

cQuery := "SELECT E1_NUMLIQ,SUM(E1_VALOR) AS TOTAL,SUM(E1_SALDO) AS SALDO,"
cQuery += " SUM(E1_VALOR-E1_SALDO) AS BAIXADOS"
cQuery += " FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_FILIAL='"+SE1->E1_FILIAL+"'"
cQuery += " AND E1_NUM='"+SE1->E1_NUM+"'"
cQuery += " GROUP BY E1_NUMLIQ"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("FA070TIT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  
            
While !EOF()
    nRet += TRB->SALDO
    Dbskip()
EndDo 

RestArea(aArea)

Return(nRet)
