#Include 'Totvs.ch'
#include "Fileio.ch"
/*/{Protheus.doc} JFINJ001
   @description: Job para envio do boleto para a Tracker via encode64
   
    Doc Mit
   
    Doc Entrega
   
   
/*/
User Function JFINJ001(xEmp, xFi, lJob)

    Local aItens := {}
    Local nCont 

    Default xEmp := '01'
    Default xFil := '00020087'
    Default lJob := .F.

    If Empty(FunName())
       RpcSetType(3)
       RpcSetEnv(xEmp,xFil)
    EndIf

    aItens := Busca()

    If len(aItens) > 0
        For nCont := 1 to len(aItens)
            aItens[nCont,14] := GerBol(aItens[nCont])
        Next nCont

        EnvJson(aItens)
    EndIf 
    
Return

/*/{Protheus.doc} Busca
    Busca titulos com boletos gerados
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
Static Function Busca()

Local aArea := GetArea()
Local cQuery 
Local aRet  := {}

cQuery := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NUMBCO,A1_CGC,E1_EMISSAO,E1_VENCREA,"
cQuery += " E1_IDCNAB,E1_ZIMPBOL,E1_CODBAR,E1_CLIENTE,E1_LOJA,E1.R_E_C_N_O_ AS RECNOE1 "
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE E1_FILIAL BETWEEN ' ' AND 'ZZZ'"
cQuery += " AND E1_VENCREA>='"+dtos(dDatabase)+"' AND E1_BAIXA=' '"
cQuery += " AND E1_NUMBCO<>' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFINJ001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aRet,{ TRB->E1_FILIAL,;
                TRB->E1_PREFIXO,;
                TRB->E1_NUM,;
                TRB->E1_PARCELA,;
                TRB->E1_TIPO,;
                TRB->E1_NUMBCO,;
                TRB->E1_IDCNAB,;
                TRB->E1_ZIMPBOL,;
                TRB->E1_CODBAR,;
                TRB->E1_CLIENTE,;
                TRB->E1_LOJA,;
                TRB->RECNOE1,;
                TRB->A1_CGC,;
                "",;
                STOD(TRB->E1_EMISSAO),;
                STOD(TRB->E1_VENCREA)})
    Dbskip()
EndDo

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} GerBol
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
Static Function GerBol(aAux)

Local aArea     := GetArea()
Local cTamSring := GetSrvProfString("maxStringSize", "1000000")
Local nTamLinha := Val(cTamSring)
Local cBuffer   := ""
Local cEncode64 := ""
Private cMarca  := GetMark()

/*E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,
E1_NUMBCO,E1_IDCNAB,E1_ZIMPBOL,E1_CODBAR,E1_CLIENTE,;
E1_LOJA,RECNOE1,A1_CGC*/
DbSelectArea("SE1")
DbsetOrder(1)
If Dbseek(Avkey(aAux[1],"E1_FILIAL")+Avkey(aAux[2],"E1_PREFIXO")+Avkey(aAux[3],"E1_NUM")+Avkey(aAux[4],"E1_PARCELA")+Avkey(aAux[5],"E1_TIPO"))
    Reclock("SE1",.F.)
    Replace E1_OK With cMarca
    MsUnLock()
EndIf

MV_PAR20      :=  SE1->E1_PORTADO
MV_PAR21    :=  SE1->E1_AGEDEP  
MV_PAR22      :=  SE1->E1_CONTA

DbSelectArea("SEE")
DbSetOrder(1)
If Dbseek(xFilial("SEE")+MV_PAR20+MV_PAR21+MV_PAR22)
    While !EOF() .AND. SEE->EE_CODIGO == MV_PAR20 .and. SEE->EE_CONTA == MV_PAR22
        If SEE->EE_NRBYTES == 400
            MV_PAR19 := SEE->EE_SUBCTA
            Exit 
        EndIf 
        Dbskip()
    EndDo
EndIf 

lBolSeparado := .f.

CCMPVENCTO := SE1->E1_VENCTO

cFileBol := U_RF01BImp(.f.)

If !'.pdf' $ cFileBol
    cFileBol := alltrim(cFileBol)+'.pdf'
EndIf 

nHdlImp := FOpen(cFileBol,0)
nBytes  := FREAD(nHdlImp, cBuffer, nTamLinha)

cEncode64 := Encode64(cBuffer)

fClose(nHdlImp)

RestArea(aArea)

Return(cEncode64)

/*/{Protheus.doc} aItens
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
Static Function EnvJson(aItens)

Local aArea     := GetArea()
Local nCont 
Local oEnvio    := JsonObject():New()
Local cApiDest  := SuperGetMV("TI_APIDES",.F.,"")
Local cEndPnt   := SuperGetMV("TI_ENDPNT",.F.,"")


/*E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,
E1_NUMBCO,E1_IDCNAB,E1_ZIMPBOL,E1_CODBAR,E1_CLIENTE,;
E1_LOJA,RECNOE1,A1_CGC*/

For nCont := 1 to len(aItens)
    oEnvio['filial']        := aItens[nCont,01]
    oEnvio['prefixo']       := aItens[nCont,02]
    oEnvio['titulo']        := aItens[nCont,03]
    oEnvio['parcela']       := aItens[nCont,04]
    oEnvio['tipo']          := aItens[nCont,05]
    oEnvio['nosso_numero']  := aItens[nCont,06]
    oEnvio['idcnab']        := aItens[nCont,07]
    oEnvio['status_boleto'] := If(aItens[nCont,08]=="1","Impresso",If(aItens[nCont,08]=="2","Enviado","Nao impresso"))
    oEnvio['cliente']       := aItens[nCont,13]
    oEnvio['emissao']       := cvaltochar(aItens[nCont,15])
    oEnvio['vencimento']    := cvaltochar(aItens[nCont,16])
    oEnvio['boleto64']      := aItens[nCont,14]

    cRet := oEnvio:toJson()
    
    ApiEnv04(cApiDest,cEndPnt,cRet)

Next nCont 

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
Static Function ApiEnv04(cUrlDest,cPathDest,cJson)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local cUrlInt	:=	Alltrim(cUrlDest) 
Local cPath     :=  Alltrim(cPathDest)

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
